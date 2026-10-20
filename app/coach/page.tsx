import Link from 'next/link';
import Shell from '@/components/Shell';
import { requireRole, type Profile } from '@/lib/auth';
import { createClient } from '@/lib/supabase/server';
import { finished, openWeekFrom, TOTAL_WEEKS, type Signoff, type Task } from '@/lib/basecamp';

export const metadata = { title: 'Interns' };

const LOC: Record<string, string> = { heights: 'Heights', oak_forest: 'Oak Forest' };

export default async function CoachHome() {
  const me = await requireRole(['admin', 'coach']);
  const supabase = await createClient();
  const [{ data: interns }, { data: signoffs }, { data: tasks }, { data: progress }] = await Promise.all([
    supabase.from('profiles').select('*').eq('role', 'intern').order('full_name'),
    supabase.from('week_signoffs').select('user_id, week_n, signed_at'),
    supabase.from('tasks').select('id, week_n'),
    supabase.from('task_progress').select('user_id, task_id'),
  ]);

  const byUser = new Map<string, Signoff[]>();
  for (const s of (signoffs ?? []) as (Signoff & { user_id: string })[]) {
    byUser.set(s.user_id, [...(byUser.get(s.user_id) ?? []), s]);
  }
  const taskWeek = new Map(((tasks ?? []) as Pick<Task, 'id' | 'week_n'>[]).map((t) => [t.id, t.week_n]));
  const tasksPerWeek = new Map<number, number>();
  for (const w of taskWeek.values()) tasksPerWeek.set(w, (tasksPerWeek.get(w) ?? 0) + 1);

  const rows = ((interns ?? []) as Profile[]).map((p) => {
    const so = byUser.get(p.id) ?? [];
    const open = openWeekFrom(so);
    const done = finished(so);
    const completed = ((progress ?? []) as { user_id: string; task_id: string }[]).filter(
      (x) => x.user_id === p.id && taskWeek.get(x.task_id) === open,
    ).length;
    const total = tasksPerWeek.get(open) ?? 0;
    return { p, open, done, completed, total, ready: !done && total > 0 && completed === total };
  });
  const waiting = rows.filter((r) => r.ready).length;

  return (
    <Shell profile={me} active="/coach">
      <div className="stack" style={{ gap: 6 }}>
        <h1 className="h1">Interns</h1>
        <p className="lede">
          {rows.length === 0
            ? 'No interns yet. Add people from the People page.'
            : waiting
              ? `${waiting} ${waiting === 1 ? 'intern has' : 'interns have'} finished the week and ${waiting === 1 ? 'is' : 'are'} waiting on your sign-off.`
              : 'Nobody is waiting on a sign-off right now.'}
        </p>
      </div>
      {rows.length ? (
        <section className="card" style={{ padding: 8 }}>
          <div className="scroll-x">
            <table className="table">
              <thead>
                <tr><th>Intern</th><th>Location</th><th>Week</th><th>This week</th><th><span className="sr-only">Status</span></th></tr>
              </thead>
              <tbody>
                {rows.map((r) => (
                  <tr key={r.p.id}>
                    <td><Link href={`/coach/${r.p.id}`} style={{ fontWeight: 600 }}>{r.p.full_name || r.p.email}</Link></td>
                    <td>{r.p.location ? LOC[r.p.location] : ''}</td>
                    <td>{r.done ? 'Complete' : `${r.open} of ${TOTAL_WEEKS}`}</td>
                    <td>{r.done ? '' : `${r.completed} of ${r.total} done`}</td>
                    <td>
                      {r.ready ? <span className="badge blue">Ready for sign-off</span> : r.done ? <span className="badge">Finished</span> : null}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>
      ) : null}
    </Shell>
  );
}
