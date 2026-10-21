'use server';

import { headers } from 'next/headers';
import { createClient as createPlainClient } from '@supabase/supabase-js';
import { createAdminClient } from '@/lib/supabase/server';
import { adminEmails, supabasePublicKey, supabaseUrl } from '@/lib/env';
import { isEmail } from '@/lib/validate';

export type LoginState = { status: 'idle' | 'sent' | 'error'; message: string };

async function siteOrigin(): Promise<string> {
  const h = await headers();
  const host = h.get('x-forwarded-host') ?? h.get('host') ?? 'basecamp.districthsf.com';
  const proto = h.get('x-forwarded-proto') ?? (host.startsWith('localhost') ? 'http' : 'https');
  return `${proto}://${host}`;
}

export async function sendLink(_prev: LoginState, formData: FormData): Promise<LoginState> {
  const email = String(formData.get('email') ?? '').trim().toLowerCase();
  if (!isEmail(email)) {
    return { status: 'error', message: 'That email doesn’t look right. Check it and try again.' };
  }

  const redirectTo = `${await siteOrigin()}/auth/confirm`;
  const sent: LoginState = {
    status: 'sent',
    message: `If ${email} has access, a sign-in link is on its way. You can open it on any device.`,
  };

  // Someone who was invited but never finished signing in (their invite
  // expired, or got buried) is still an unconfirmed account. Supabase refuses
  // a normal sign-in link for them, so send a fresh invite instead. Only people
  // an admin has already added (they have a profile) get one.
  try {
    const admin = createAdminClient();
    const { data: prof } = await admin.from('profiles').select('id').eq('email', email).maybeSingle();
    if (prof) {
      const { data } = await admin.auth.admin.getUserById((prof as { id: string }).id);
      if (data?.user && !data.user.email_confirmed_at) {
        const { error } = await admin.auth.admin.inviteUserByEmail(email, { redirectTo });
        if (error) console.error('[login] re-invite failed:', error.status, error.code ?? error.message);
        if (error?.status === 429) return { status: 'error', message: 'Too many tries. Wait a minute, then ask for a new link.' };
        return sent;
      }
    }
  } catch (e) {
    console.error('[login] invite check failed:', e instanceof Error ? e.message : e);
  }

  // Implicit-flow links carry the session in the URL hash, so they work even when
  // opened in a different browser (a phone's mail app) than the one that asked.
  const supabase = createPlainClient(supabaseUrl(), supabasePublicKey(), {
    auth: { flowType: 'implicit', persistSession: false, autoRefreshToken: false, detectSessionInUrl: false },
  });
  // Only owners in ADMIN_EMAILS can create an account by signing in.
  // Everyone else must be invited first, so unknown emails get no account.
  const { error } = await supabase.auth.signInWithOtp({
    email,
    options: {
      shouldCreateUser: adminEmails().includes(email),
      emailRedirectTo: redirectTo,
    },
  });

  // Unknown emails are refused on purpose (signup_disabled); log anything else.
  if (error && error.code !== 'signup_disabled' && error.code !== 'otp_disabled') {
    console.error('[login] sign-in link failed:', error.status, error.code ?? error.message);
  }
  if (error && error.status === 429) {
    return { status: 'error', message: 'Too many tries. Wait a minute, then ask for a new link.' };
  }
  // Same answer whether or not the email has access, so the form never reveals who is invited.
  return sent;
}
