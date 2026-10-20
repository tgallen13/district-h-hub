'use server';

import { createClient } from '@/lib/supabase/server';

// Turns the tokens from a sign-in link into the hub's session cookie.
// Supabase verifies the tokens, so a forged pair is simply rejected.
export async function finishSignIn(accessToken: string, refreshToken: string): Promise<{ ok: boolean }> {
  if (!accessToken || !refreshToken || accessToken.length > 8000 || refreshToken.length > 2000) return { ok: false };
  const supabase = await createClient();
  const { error } = await supabase.auth.setSession({ access_token: accessToken, refresh_token: refreshToken });
  return { ok: !error };
}
