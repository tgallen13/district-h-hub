// Supabase keys arrive from the Vercel Supabase integration. Newer projects
// name them "publishable"/"secret"; older ones "anon"/"service role".
export function supabaseUrl(): string {
  const v = process.env.NEXT_PUBLIC_SUPABASE_URL ?? process.env.SUPABASE_URL;
  if (!v) throw new Error('Missing NEXT_PUBLIC_SUPABASE_URL. Connect Supabase to the Vercel project.');
  return v;
}

export function supabasePublicKey(): string {
  const v =
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY ??
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ??
    process.env.SUPABASE_ANON_KEY;
  if (!v) throw new Error('Missing NEXT_PUBLIC_SUPABASE_ANON_KEY. Connect Supabase to the Vercel project.');
  return v;
}

export function supabaseSecretKey(): string {
  const v = process.env.SUPABASE_SECRET_KEY ?? process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!v) throw new Error('Missing SUPABASE_SERVICE_ROLE_KEY. Connect Supabase to the Vercel project.');
  return v;
}

// Emails allowed to bootstrap themselves as admins on first sign-in.
export function adminEmails(): string[] {
  return (process.env.ADMIN_EMAILS ?? '')
    .split(',')
    .map((e) => e.trim().toLowerCase())
    .filter(Boolean);
}

export function isConfigured(): boolean {
  try {
    supabaseUrl();
    supabasePublicKey();
    return true;
  } catch {
    return false;
  }
}
