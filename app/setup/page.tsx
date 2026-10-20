import { connection } from 'next/server';
import { redirect } from 'next/navigation';
import { isConfigured } from '@/lib/env';

export default async function Setup() {
  await connection();
  if (isConfigured()) redirect('/login');
  return (
    <main className="center-page">
      <div className="card" style={{ maxWidth: 560 }}>
        <div className="eyebrow">Coach Hub setup</div>
        <h1 style={{ fontSize: 28 }}>The database isn&rsquo;t connected yet</h1>
        <p className="sub" style={{ fontSize: 15 }}>
          In Vercel, open this project, go to Storage, create a Supabase database, and redeploy. The hub picks up the keys automatically.
        </p>
      </div>
    </main>
  );
}
