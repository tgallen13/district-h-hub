import Shell from '@/components/Shell';
import TaskList from '@/components/TaskList';
import WeekGrid from '@/components/WeekGrid';
import Orientation from '@/components/Orientation';
import { requireRole } from '@/lib/auth';
import { submitTask, toggleTask } from './actions';
import { gateFor, loadIntern, readingFor, TOTAL_WEEKS } from '@/lib/basecamp';

export const metadata = { title: 'BaseCamp' };

export default async function BaseCampPage({ searchParams }: { searchParams: Promise<{ week?: string }> }) {
  const me = await requireRole(['intern', 'candidate']);

  if (me.role === 'candidate') {
    return (
      <Shell profile={me} active="/basecamp">
        <div className="stack" style={{ gap: 10 }}>
          <h1 className="h1">Welcome to BaseCamp{me.full_name ? `, ${me.full_name.split(' ')[0]}` : ''}</h1>
          <p className="lede" style={{ fontSize: 17 }}>
            This is a paid apprenticeship on a real floor, not a course. Start with orientation so you know who we are and what we commit to you.
            Then book your Professional Path Call.
          </p>
        </div>
        <Orientation userId={me.id} role={me.role} />
        <section className="card dark">
          <h2 style={{ fontSize: 22 }}>Your Professional Path Call</h2>
          <p style={{ margin: 0, fontSize: 15, lineHeight: 1.5 }}>
            A conversation about your why, where you want this career to go, and whether BaseCamp is the right fit. Your General Manager will reach out to schedule it.
          </p>
        </section>
      </Shell>
    );
  }

  const { week } = await searchParams;
  const d = await loadIntern(me.id, week ? Number(week) : null);
  const w = d.weeks.find((x) => x.n === d.selected);
  const signoff = d.signoffs.find((s) => s.week_n === d.selected);
  const isOpen = d.selected === d.open && !signoff;
  const doneCount = d.tasks.filter((t) => d.progress.has(t.id)).length;
  const gate = gateFor(d.open);
  const book = readingFor(d.open);
  const toGate = gate.week - d.open;
  const pct = Math.round(((d.done ? TOTAL_WEEKS : d.open - 1) / TOTAL_WEEKS) * 100);

  return (
    <Shell profile={me} active="/basecamp">
      <section className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: 12, flexWrap: 'wrap' }}>
          <h1 style={{ fontWeight: 800, fontSize: 32 }}>{d.done ? 'BaseCamp complete' : `Week ${d.open} of ${TOTAL_WEEKS}`}</h1>
          <span style={{ fontWeight: 600, color: 'var(--blue)' }}>{d.open <= 12 ? 'Presenter' : 'Instructor'} phase</span>
        </div>
        <div className="bar" role="progressbar" aria-valuenow={pct} aria-valuemin={0} aria-valuemax={100} aria-label="BaseCamp progress">
          <div style={{ width: `${pct}%` }} />
        </div>
        <div className="sub" style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap' }}>
          <span>Presenter, weeks 1 to 12</span>
          {!d.done ? <span>{toGate === 0 ? 'Gate week' : `${toGate} ${toGate === 1 ? 'week' : 'weeks'} to your gate`}</span> : null}
          <span>Instructor, weeks 13 to 24</span>
        </div>
      </section>

      <div className="row">
        <section className="card" style={{ flex: '1 1 280px', gap: 10 }}>
          <h2 style={{ fontSize: 18 }}>Your weeks</h2>
          <p className="sub">A week unlocks once your coach signs off on the one before it.</p>
          <WeekGrid open={d.open} done={d.done} selected={d.selected} basePath="/basecamp" />
        </section>

        <section style={{ flex: '999 1 460px', minWidth: 0, display: 'flex', flexDirection: 'column', gap: 16 }}>
          <div className="card" style={{ gap: 10 }}>
            <div className="eyebrow">Week {d.selected} · {w?.phase}</div>
            <h2 style={{ fontWeight: 800, fontSize: 28 }}>{w?.title}</h2>
            {w?.system_focus ? <div style={{ fontSize: 15 }}><strong>System this week:</strong> {w.system_focus}</div> : null}
            {w?.summary ? <p className="sub" style={{ fontSize: 15, whiteSpace: 'pre-wrap' }}>{w.summary}</p> : null}
            {signoff ? (
              <div className="stack" style={{ gap: 6 }}>
                <span className="badge">Signed off {new Date(signoff.signed_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}</span>
                {signoff.note ? <p className="sub" style={{ whiteSpace: 'pre-wrap' }}><strong>Coach note:</strong> {signoff.note}</p> : null}
              </div>
            ) : null}
          </div>

          <div className="card">
            <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap', alignItems: 'baseline' }}>
              <h3 style={{ fontSize: 18 }}>{isOpen ? 'This week’s work' : 'Your work this week'}</h3>
              <span className="sub">{doneCount} of {d.tasks.length} done</span>
            </div>
            <TaskList tasks={d.tasks} progress={d.progress} editable={isOpen} toggle={toggleTask} submit={submitTask} />
            {isOpen && d.tasks.length > 0 && doneCount === d.tasks.length ? (
              <div className="note">All done. Your coach will review and sign off to unlock the next week.</div>
            ) : null}
          </div>

          <div className="row" style={{ gap: 16 }}>
            <div className="card dark" style={{ flex: '1 1 240px', padding: 20, gap: 8 }}>
              <div className="eyebrow">Next gate</div>
              <div style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 20 }}>{gate.title}</div>
              <div className="sub">{gate.body}</div>
            </div>
            <div className="card" style={{ flex: '1 1 240px', padding: 20, gap: 8 }}>
              <div className="eyebrow">Phase reading</div>
              <div style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 20 }}>{book.title}</div>
              <div className="sub">{book.line}</div>
            </div>
          </div>
        </section>
      </div>
    </Shell>
  );
}
