'use client';

import { useEffect, useState } from 'react';
import { finishSignIn } from './actions';

// Where emailed sign-in and invite links land. Supabase's default links put the
// session in the URL hash, which only the browser can read, so this page hands
// it to the server. Links with a token in the query string go to /auth/callback.
export default function Confirm() {
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    const query = window.location.search;
    if (query.includes('token_hash=') || query.includes('code=')) {
      window.location.replace('/auth/callback' + query);
      return;
    }
    const hash = new URLSearchParams(window.location.hash.slice(1));
    const access = hash.get('access_token') ?? '';
    const refresh = hash.get('refresh_token') ?? '';
    // Clear the tokens from the address bar and history right away.
    window.history.replaceState(null, '', '/auth/confirm');
    if (hash.get('error_code') || !access || !refresh) {
      window.location.replace('/login?e=expired');
      return;
    }
    finishSignIn(access, refresh)
      .then((r) => (r.ok ? window.location.replace('/') : setFailed(true)))
      .catch(() => setFailed(true));
  }, []);

  return (
    <main className="center-page">
      <div className="card" style={{ maxWidth: 440 }} role="status">
        {failed ? (
          <>
            <h1 style={{ fontSize: 24 }}>That link didn&rsquo;t work</h1>
            <p className="sub" style={{ fontSize: 15 }}>It may have expired or already been used.</p>
            <a className="btn primary" href="/login" style={{ alignSelf: 'flex-start' }}>Get a new link</a>
          </>
        ) : (
          <>
            <h1 style={{ fontSize: 24 }}>Signing you in&hellip;</h1>
            <p className="sub" style={{ fontSize: 15 }}>One moment.</p>
          </>
        )}
      </div>
    </main>
  );
}
