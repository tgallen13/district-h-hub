import Link from 'next/link';
import { notFound } from 'next/navigation';
import Shell from '@/components/Shell';
import TaskList from '@/components/TaskList';
import WeekGrid from '@/components/WeekGrid';
import { requireRole, type Profile } from '@/lib/auth';
import { createClient } from '@/lib/supabase/server';
import { finished, openWeekFrom, TOTAL_WEEKS, type Progress, type Signoff, type Task, type Week } from '@/lib/basecamp';
import { signOff, undoSignoff } from '../actions';

export const metadata = { title: 'Intern' };

export default async function InternDetail({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ week?: string; e?: string }>;
}) {
  const me = await requireRole(['admin', 'coach']);
  const { id } = await params;
  const { week, e } = await searchParams;
  const supabase = await createClient();

  const { data: intern } = await supabase.from('profiles').select('*').eq('id', id).eq('role', 'intern').maybeSingle();
  if (!intern) notFound();
  const p = intern as Profile;

  const [{ data: weeks }, { data: signoffs }] = await Promise.all([
    supabase.from('weeks').select('*').order('n'),
    supabase.from('week_signoffs').select('week_n, note, signed_at, signed_by').eq('user_id', id).order('week_n'),
  ]);
  const so = (signoffs ?? []) as Signoff[];
  const open = openWeekFrom(so);
  const done = finished(so);
  const wanted = Number(week);
  const selected = wanted >= 1 && wanted <= open ? wanted : open;
  const w = ((weeks ?? []) as Week[]).find((x) => x.n === selected);
  const signoff = so.find((s) => s.week_n === selected);
  const latest = so.length ? Math.max(...so.map((s) => s.week_n)) : 0;

  const { data: tasks } = await supabase.from('tasks').select('*').eq('week_n', selected).order('sort');
  const taskList = (tasks ?? []) as Task[];
  const { data: progress } = taskList.length
    ? await supabase.from('task_progress').select('task_id, submission, completed_at').eq('user_id', id).in('task_id', taskList.map((t) => t.id))
    : { data: [] };
  const prog = new Map(((progress ?? []) as Progress[]).map((x) => [x.task_id, x]));
  const doneCount = taskList.filter((t) => prog.has(t.id)).length;

  let signer = '';
  if (signoff) {
    const { data: s } = await supabase.from('profiles').select('full_name, email').eq('id', signoff.signed_by).maybeSingle();
    signer = (s as { full_name: string; email: string } | null)?.full_name || (s as { email: string } | null)?.email || '';
  }

  return (
    <Shell profile={me} active="/coach">
      <div className="stack" style={{ gap: 6 }}>
        <Link href="/coach" className="sub">&larr; All interns</Link>
        <h1 className="h1">{p.full_name || p.email}</h1>
        <p className="lede">{done ? 'Finished all 24 weeks.' : `On week ${open} of ${TOTAL_WEEKS}.`}</p>
        {done && me.role === 'admin' ? (
          <div className="note">
            BaseCamp is complete. When you hire them, change their role to Coach on the <Link href="/admin">People</Link> page and My Path opens for them.
          </div>
        ) : null}
      </div>
      {e === 'signoff' ? <div className="warn" role="alert">That sign-off didn&rsquo;t save. Someone may have signed off this week already. Refresh and check.</div> : null}

      <div className="row">
        <section className="card" style={{ flex: '1 1 280px', gap: 10 }}>
          <h2 style={{ fontSize: 18 }}>Weeks</h2>
          <WeekGrid open={open} done={done} selected={selected} basePath={`/coach/${id}`} />
        </section>

        <section style={{ flex: '999 1 460px', minWidth: 0, display: 'flex', flexDirection: 'column', gap: 16 }}>
          <div className="card" style={{ gap: 10 }}>
            <div className="eyebrow">Week {selected} · {w?.phase}</div>
            <h2 style={{ fontWeight: 800, fontSize: 26 }}>{w?.title}</h2>
            <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap', alignItems: 'baseline' }}>
              <h3 style={{ fontSize: 17 }}>Their work</h3>
              <span className="sub">{doneCount} of {taskList.length} done</span>
            </div>
            <TaskList tasks={taskList} progress={prog} editable={false} />
          </div>

          {signoff ? (
            <div className="card" style={{ gap: 10 }}>
              <span className="badge">
                Signed off {new Date(signoff.signed_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
                {signer ? ` by ${signer}` : ''}
              </span>
              {signoff.note ? <p className="sub" style={{ whiteSpace: 'pre-wrap' }}>{signoff.note}</p> : null}
              {selected === latest ? (
                <form action={undoSignoff}>
                  <input type="hidden" name="internId" value={id} />
                  <input type="hidden" name="weekN" value={selected} />
                  <button className="btn" type="submit">Undo this sign-off</button>
                </form>
              ) : null}
            </div>
          ) : selected === open ? (
            <form action={signOff} className="card" style={{ gap: 12 }}>
              <h3 style={{ fontSize: 18 }}>Sign off week {selected}</h3>
              <p className="sub">
                {doneCount === taskList.length
                  ? 'Everything is marked done. Signing off unlocks the next week for them.'
                  : `${taskList.length - doneCount} still open. You can sign off anyway if you’ve covered it in person.`}
              </p>
              <input type="hidden" name="internId" value={id} />
              <input type="hidden" name="weekN" value={selected} />
              <div className="field">
                <label htmlFor="note">Note for {p.full_name.split(' ')[0] || 'them'} (optional)</label>
                <textarea id="note" name="note" className="textarea" placeholder="What went well, what to work on next week" />
              </div>
              <button className="btn blue" type="submit" style={{ alignSelf: 'flex-start' }}>
                {selected === TOTAL_WEEKS ? 'Sign off the Instructor gate' : `Sign off and unlock week ${selected + 1}`}
              </button>
            </form>
          ) : null}
        </section>
      </div>
    </Shell>
  );
}
