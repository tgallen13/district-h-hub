'use server';

import { headers } from 'next/headers';
import { createClient } from '@/lib/supabase/server';
import { adminEmails } from '@/lib/env';
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

  const supabase = await createClient();
  // Only owners in ADMIN_EMAILS can create an account by signing in.
  // Everyone else must be invited first, so unknown emails get no account.
  const { error } = await supabase.auth.signInWithOtp({
    email,
    options: {
      shouldCreateUser: adminEmails().includes(email),
      emailRedirectTo: `${await siteOrigin()}/auth/confirm`,
    },
  });

  if (error && error.status === 429) {
    return { status: 'error', message: 'Too many tries. Wait a minute, then ask for a new link.' };
  }
  // Same answer whether or not the email has access, so the form never reveals who is invited.
  return {
    status: 'sent',
    message: `If ${email} has access, a sign-in link is on its way. Open it on this device.`,
  };
}
