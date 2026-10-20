import Link from 'next/link';
import { notFound } from 'next/navigation';
import Shell from '@/components/Shell';
import TaskList from '@/components/TaskList';
import UnitGrid from '@/components/UnitGrid';
import { requireRole, type Profile } from '@/lib/auth';
import { createClient } from '@/lib/supabase/server';
import { isOnPath, loadPath, TOTAL_UNITS, unitLabel } from '@/lib/path';
import { signOffUnit, undoUnitSignoff } from '@/app/path/actions';

export const metadata = { title: 'Coach path' };

export default async function CoachPathDetail({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ unit?: string; e?: string }>;
}) {
  const me = await requireRole(['admin', 'coach']);
  const { id } = await params;
  const { unit, e } = await searchParams;
  const supabase = await createClient();

  const { data: person } = await supabase.from('profiles').select('*').eq('id', id).eq('role', 'coach').maybeSingle();
  if (!person || id === me.id || !(await isOnPath(id))) notFound();
  const p = person as Profile;

  const d = await loadPath(id, unit ? Number(unit) : null);
  const so = d.signoffs;
  const open = d.open;
  const done = d.done;
  const selected = d.selected;
  const w = d.units.find((x) => x.n === selected);
  const signoff = so.find((s) => s.unit_n === selected);
  const latest = so.length ? Math.max(...so.map((s) => s.unit_n)) : 0;
  const taskList = d.tasks;
  const prog = d.progress;
  const doneCount = taskList.filter((t) => prog.has(t.id)).length;
  // Mentors can sign off a unit they've finished themselves; admins can sign off any.
  const { data: mine } = await supabase.from('path_signoffs').select('unit_n').eq('user_id', me.id).eq('unit_n', selected).maybeSingle();
  const canSign = me.role === 'admin' || !!mine;

  let signer = '';
  if (signoff) {
    const { data: s } = await supabase.from('profiles').select('full_name, email').eq('id', signoff.signed_by).maybeSingle();
    signer = (s as { full_name: string; email: string } | null)?.full_name || (s as { email: string } | null)?.email || '';
  }

  return (
    <Shell profile={me} active="/coach">
      <div className="stack" style={{ gap: 6 }}>
        <Link href="/coach" className="sub">&larr; Back</Link>
        <h1 className="h1">{p.full_name || p.email}</h1>
        <p className="lede">{done ? 'Finished the Trainer and Coach path.' : `${open <= 6 ? 'Trainer' : 'Coach'} · ${unitLabel(open)}`}</p>
      </div>
      {e === 'signoff' ? <div className="warn" role="alert">That sign-off didn&rsquo;t save. You may not have finished this unit yourself yet, or someone signed it off already. Refresh and check.</div> : null}

      <div className="row">
        <section className="card" style={{ flex: '1 1 280px', gap: 10 }}>
          <h2 style={{ fontSize: 18 }}>Units</h2>
          <UnitGrid open={open} done={done} selected={selected} basePath={`/coach/path/${id}`} />
        </section>

        <section style={{ flex: '999 1 460px', minWidth: 0, display: 'flex', flexDirection: 'column', gap: 16 }}>
          <div className="card" style={{ gap: 10 }}>
            <div className="eyebrow">{w?.phase} · {unitLabel(selected)}</div>
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
                <form action={undoUnitSignoff}>
                  <input type="hidden" name="userId" value={id} />
                  <input type="hidden" name="unitN" value={selected} />
                  <button className="btn" type="submit">Undo this sign-off</button>
                </form>
              ) : null}
            </div>
          ) : selected === open && canSign ? (
            <form action={signOffUnit} className="card" style={{ gap: 12 }}>
              <h3 style={{ fontSize: 18 }}>Sign off {unitLabel(selected)}</h3>
              <p className="sub">
                {doneCount === taskList.length
                  ? 'Everything is marked done. Signing off unlocks the next unit for them.'
                  : `${taskList.length - doneCount} still open. You can sign off anyway if you’ve covered it in person.`}
              </p>
              <input type="hidden" name="userId" value={id} />
              <input type="hidden" name="unitN" value={selected} />
              <div className="field">
                <label htmlFor="note">Note for {p.full_name.split(' ')[0] || 'them'} (optional)</label>
                <textarea id="note" name="note" className="textarea" placeholder="What went well, what to work on next" />
              </div>
              <button className="btn blue" type="submit" style={{ alignSelf: 'flex-start' }}>
                {selected === TOTAL_UNITS ? 'Sign off the Coach gate' : selected === 6 ? 'Sign off the Trainer gate' : `Sign off and unlock ${unitLabel(selected + 1)}`}
              </button>
            </form>
          ) : selected === open ? (
            <div className="note">Signing off this unit takes an admin or a coach who has finished it.</div>
          ) : null}
        </section>
      </div>
    </Shell>
  );
}
