import { NextResponse, type NextRequest } from 'next/server';
import type { EmailOtpType } from '@supabase/supabase-js';
import { createClient } from '@/lib/supabase/server';

// Server-side half of sign-in links. Handles the two link styles that carry the
// token in the query string: token_hash (any browser) and a PKCE code (only the
// browser that asked for it). Links with the token in the URL hash go to /auth/confirm.
export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const tokenHash = searchParams.get('token_hash');
  const type = searchParams.get('type') as EmailOtpType | null;
  const code = searchParams.get('code');
  const supabase = await createClient();

  if (tokenHash && type) {
    const { error } = await supabase.auth.verifyOtp({ token_hash: tokenHash, type });
    if (!error) return NextResponse.redirect(new URL('/', request.url));
    return NextResponse.redirect(new URL('/login?e=expired', request.url));
  }

  if (code) {
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (!error) return NextResponse.redirect(new URL('/', request.url));
    const wrongDevice = /code verifier|code_verifier|pkce/i.test(error.message);
    return NextResponse.redirect(new URL(`/login?e=${wrongDevice ? 'device' : 'expired'}`, request.url));
  }

  return NextResponse.redirect(new URL('/login?e=expired', request.url));
}
