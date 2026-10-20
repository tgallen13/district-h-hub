import { getViewer } from '@/lib/auth';

export default async function NoAccess() {
  const viewer = await getViewer();
  return (
    <main className="center-page">
      <div className="card" style={{ maxWidth: 520 }}>
        <div className="eyebrow">Coach Hub</div>
        <h1 style={{ fontSize: 28 }}>You&rsquo;re signed in, but not set up yet</h1>
        <p className="sub" style={{ fontSize: 15 }}>
          {viewer?.email ? <>We don&rsquo;t have a role for <strong>{viewer.email}</strong> yet. </> : null}
          Ask your General Manager to add you. Once they do, sign in again and you&rsquo;ll land in the right place.
        </p>
        <form action="/auth/signout" method="post">
          <button className="btn" type="submit">Sign out</button>
        </form>
      </div>
    </main>
  );
}
