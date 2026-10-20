import { redirect } from 'next/navigation';
import Shell from '@/components/Shell';
import TaskList from '@/components/TaskList';
import UnitGrid from '@/components/UnitGrid';
import { requireRole } from '@/lib/auth';
import { isOnPath, loadPath, TOTAL_UNITS, TRAINER_UNITS, unitLabel } from '@/lib/path';
import { submitPathQuiz, submitPathTask, togglePathTask } from './actions';

export const metadata = { title: 'My Path' };

export default async function MyPath({ searchParams }: { searchParams: Promise<{ unit?: string }> }) {
  const me = await requireRole(['coach', 'admin']);
  if (me.role === 'admin') redirect('/admin/path');

  if (!(await isOnPath(me.id))) {
    return (
      <Shell profile={me} active="/path">
        <section className="card" style={{ gap: 10, maxWidth: 640 }}>
          <div className="eyebrow">My Path</div>
          <h1 className="h1">Trainer and Coach</h1>
          <p className="lede">
            My Path picks up where BaseCamp ends. It opens once your Instructor gate is signed off: six months to Trainer, then two years
            to Coach. If you were hired before BaseCamp existed, ask your General Manager to open it for you.
          </p>
        </section>
      </Shell>
    );
  }

  const { unit } = await searchParams;
  const d = await loadPath(me.id, unit ? Number(unit) : null);
  const u = d.units.find((x) => x.n === d.selected);
  const signoff = d.signoffs.find((s) => s.unit_n === d.selected);
  const isOpen = d.selected === d.open && !signoff;
  const doneCount = d.tasks.filter((t) => d.progress.has(t.id)).length;
  const pct = Math.round(((d.done ? TOTAL_UNITS : d.open - 1) / TOTAL_UNITS) * 100);
  const phase = d.open <= TRAINER_UNITS ? 'Trainer' : 'Coach';

  return (
    <Shell profile={me} active="/path">
      <section className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: 12, flexWrap: 'wrap' }}>
          <h1 style={{ fontWeight: 800, fontSize: 32 }}>{d.done ? 'Path complete' : `${phase} · ${unitLabel(d.open)}`}</h1>
          <span style={{ fontWeight: 600, color: 'var(--blue)' }}>{d.done ? 'On to Professional' : `${phase} phase`}</span>
        </div>
        <div className="bar" role="progressbar" aria-valuenow={pct} aria-valuemin={0} aria-valuemax={100} aria-label="My Path progress">
          <div style={{ width: `${pct}%` }} />
        </div>
        <div className="sub" style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap' }}>
          <span>Trainer, months 1 to 6</span>
          <span>Coach, years 2 and 3</span>
        </div>
      </section>

      <div className="row">
        <section className="card" style={{ flex: '1 1 280px', gap: 10 }}>
          <h2 style={{ fontSize: 18 }}>Your units</h2>
          <p className="sub">A unit unlocks once your mentor or GM signs off on the one before it.</p>
          <UnitGrid open={d.open} done={d.done} selected={d.selected} basePath="/path" />
        </section>

        <section style={{ flex: '999 1 460px', minWidth: 0, display: 'flex', flexDirection: 'column', gap: 16 }}>
          <div className="card" style={{ gap: 10 }}>
            <div className="eyebrow">{u?.phase} · {unitLabel(d.selected)}{u?.is_gate ? ' · Gate' : ''}</div>
            <h2 style={{ fontWeight: 800, fontSize: 28 }}>{u?.title}</h2>
            {u?.focus ? <div style={{ fontSize: 15 }}><strong>Focus:</strong> {u.focus}</div> : null}
            {u?.summary ? <p className="sub" style={{ fontSize: 15, whiteSpace: 'pre-wrap' }}>{u.summary}</p> : null}
            {u?.reading ? <div style={{ fontSize: 15 }}><strong>Reading:</strong> {u.reading.replaceAll('*', '')}</div> : null}
            {signoff ? (
              <div className="stack" style={{ gap: 6 }}>
                <span className="badge">Signed off {new Date(signoff.signed_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}</span>
                {signoff.note ? <p className="sub" style={{ whiteSpace: 'pre-wrap' }}><strong>Note:</strong> {signoff.note}</p> : null}
              </div>
            ) : null}
          </div>

          <div className="card">
            <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap', alignItems: 'baseline' }}>
              <h3 style={{ fontSize: 18 }}>The work</h3>
              <span className="sub">{doneCount} of {d.tasks.length} done</span>
            </div>
            <TaskList tasks={d.tasks} progress={d.progress} editable={isOpen} toggle={togglePathTask} submit={submitPathTask} quizzes={d.quizzes} quiz={submitPathQuiz} />
            {isOpen && d.tasks.length > 0 && doneCount === d.tasks.length ? (
              <div className="note">All done. Your mentor or GM will review and sign off to unlock the next unit.</div>
            ) : null}
          </div>
        </section>
      </div>
    </Shell>
  );
}
