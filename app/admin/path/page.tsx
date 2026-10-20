import Link from 'next/link';
import Shell from '@/components/Shell';
import { requireRole } from '@/lib/auth';
import { createClient } from '@/lib/supabase/server';
import { unitLabel, type Unit } from '@/lib/path';

export const metadata = { title: 'My Path content' };

export default async function PathUnits() {
  const me = await requireRole(['admin']);
  const supabase = await createClient();
  const [{ data: weeks }, { data: tasks }] = await Promise.all([
    supabase.from('path_units').select('*').order('n'),
    supabase.from('path_tasks').select('unit_n'),
  ]);
  const counts = new Map<number, number>();
  for (const t of (tasks ?? []) as { unit_n: number }[]) counts.set(t.unit_n, (counts.get(t.unit_n) ?? 0) + 1);

  return (
    <Shell profile={me} active="/admin/path">
      <div className="stack" style={{ gap: 6 }}>
        <h1 className="h1">My Path content</h1>
        <p className="lede">What hired coaches work through after BaseCamp: six Trainer months, then eight Coach quarters. Open a unit to change it or the work inside it. Changes show up right away.</p>
      </div>
      {(['Trainer', 'Coach'] as const).map((phase) => (
        <section className="card" key={phase} style={{ gap: 0 }}>
          <h2 style={{ fontSize: 20, marginBottom: 6 }}>{phase} phase</h2>
          {((weeks ?? []) as Unit[])
            .filter((w) => w.phase === phase)
            .map((w) => (
              <div className="item" key={w.n}>
                <div className="grow">
                  <span className="t">{unitLabel(w.n)}: {w.title}</span>
                  <span className="sub">
                    {counts.get(w.n) ?? 0} items{w.focus ? ` · ${w.focus}` : ''}{w.is_gate ? ' · Gate' : ''}
                  </span>
                </div>
                <Link className="btn" href={`/admin/path/${w.n}`}>Edit</Link>
              </div>
            ))}
        </section>
      ))}
    </Shell>
  );
}
