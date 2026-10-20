import 'server-only';
import { cache } from 'react';
import { redirect } from 'next/navigation';
import { createAdminClient, createClient } from '@/lib/supabase/server';
import { adminEmails } from '@/lib/env';

export type Role = 'admin' | 'coach' | 'intern' | 'candidate';
export type Profile = {
  id: string;
  email: string;
  full_name: string;
  role: Role;
  location: 'heights' | 'oak_forest' | null;
  path_access: boolean;
  created_at: string;
};

// The signed-in person and their profile, once per request.
export const getViewer = cache(async (): Promise<{ userId: string; email: string; profile: Profile | null } | null> => {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user || !user.email) return null;

  const { data } = await supabase.from('profiles').select('*').eq('id', user.id).maybeSingle();
  let profile = (data as Profile | null) ?? null;

  // First sign-in for an owner listed in ADMIN_EMAILS: create their admin profile.
  if (!profile && adminEmails().includes(user.email.toLowerCase())) {
    const admin = createAdminClient();
    const { data: created } = await admin
      .from('profiles')
      .upsert({ id: user.id, email: user.email.toLowerCase(), role: 'admin', full_name: '' })
      .select('*')
      .single();
    profile = (created as Profile | null) ?? null;
  }
  return { userId: user.id, email: user.email, profile };
});

export function homeFor(role: Role): string {
  if (role === 'admin') return '/admin';
  if (role === 'coach') return '/path';
  return '/basecamp';
}

// Use at the top of a page or action. Sends the person away if their role doesn't fit.
export async function requireRole(roles: Role[]): Promise<Profile> {
  const viewer = await getViewer();
  if (!viewer) redirect('/login');
  if (!viewer.profile) redirect('/no-access');
  if (!roles.includes(viewer.profile.role)) redirect(homeFor(viewer.profile.role));
  return viewer.profile;
}
