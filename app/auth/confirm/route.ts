import { NextResponse, type NextRequest } from 'next/server';
import type { EmailOtpType } from '@supabase/supabase-js';
import { createClient } from '@/lib/supabase/server';

// Where the emailed sign-in link lands. Handles both link styles Supabase can send:
// a token_hash link (works in any browser, recommended) and a PKCE code link
// (works only in the browser that asked for it).
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
