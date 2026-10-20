'use client';

import { useActionState } from 'react';
import { sendLink, type LoginState } from './actions';

const initial: LoginState = { status: 'idle', message: '' };

export default function LoginForm({ notice }: { notice?: string }) {
  const [state, action, pending] = useActionState(sendLink, initial);

  if (state.status === 'sent') {
    return (
      <div className="stack">
        <div className="note" role="status">{state.message}</div>
        <p className="sub">The link works once and expires after an hour. It’s fine to open it from your phone’s mail app. No email after a few minutes? Check spam, or ask your General Manager to confirm you&rsquo;ve been invited.</p>
      </div>
    );
  }

  return (
    <form action={action} className="stack">
      {notice ? <div className="warn" role="alert">{notice}</div> : null}
      <div className="field">
        <label htmlFor="email">Email</label>
        <input className="input" id="email" name="email" type="email" autoComplete="email" required placeholder="you@email.com" />
      </div>
      {state.status === 'error' ? <div className="warn" role="alert">{state.message}</div> : null}
      <button className="cta" type="submit" disabled={pending}>
        {pending ? 'Sending…' : 'Email me a sign-in link'}
      </button>
      <p className="sub">No password needed. Need access? Ask your General Manager.</p>
    </form>
  );
}
