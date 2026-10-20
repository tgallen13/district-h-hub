import Link from 'next/link';
import Shell from '@/components/Shell';
import { requireRole } from '@/lib/auth';
import { createClient } from '@/lib/supabase/server';
import type { Week } from '@/lib/basecamp';

export const metadata = { title: 'Curriculum' };

export default async function Weeks() {
  const me = await requireRole(['admin']);
  const supabase = await createClient();
  const [{ data: weeks }, { data: tasks }] = await Promise.all([
    supabase.from('weeks').select('*').order('n'),
    supabase.from('tasks').select('week_n'),
  ]);
  const counts = new Map<number, number>();
  for (const t of (tasks ?? []) as { week_n: number }[]) counts.set(t.week_n, (counts.get(t.week_n) ?? 0) + 1);

  return (
    <Shell profile={me} active="/admin/weeks">
      <div className="stack" style={{ gap: 6 }}>
        <h1 className="h1">Curriculum</h1>
        <p className="lede">The 24 BaseCamp weeks. Open a week to change its title and focus, or to add, edit, and remove the work inside it. Changes show up for interns right away.</p>
      </div>
      {(['Presenter', 'Instructor'] as const).map((phase) => (
        <section className="card" key={phase} style={{ gap: 0 }}>
          <h2 style={{ fontSize: 20, marginBottom: 6 }}>{phase} phase</h2>
          {((weeks ?? []) as Week[])
            .filter((w) => w.phase === phase)
            .map((w) => (
              <div className="item" key={w.n}>
                <div className="grow">
                  <span className="t">Week {w.n}: {w.title}</span>
                  <span className="sub">
                    {counts.get(w.n) ?? 0} items{w.system_focus ? ` · ${w.system_focus}` : ''}{w.is_gate ? ' · Gate week' : ''}
                  </span>
                </div>
                <Link className="btn" href={`/admin/weeks/${w.n}`}>Edit</Link>
              </div>
            ))}
        </section>
      ))}
    </Shell>
  );
}
