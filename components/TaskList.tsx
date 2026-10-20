import { submitTask, toggleTask } from '@/app/basecamp/actions';
import { NEEDS_SUBMISSION, type Progress, type Task } from '@/lib/basecamp';
import { isHttpUrl } from '@/lib/validate';

const LABELS: Record<Task['kind'], { open: string; hint: string }> = {
  lesson: { open: 'Mark done', hint: 'Daily lesson' },
  huddle: { open: 'Check in', hint: 'Huddle' },
  film: { open: 'Add link', hint: 'Filmed rep' },
  homework: { open: 'Submit', hint: 'Homework' },
};

function isLink(s: string) {
  return isHttpUrl(s) && !s.trim().includes(' ');
}

// editable: the intern's open week. Otherwise it's a read-only record
// (past weeks for the intern, or a coach reviewing).
export default function TaskList({ tasks, progress, editable }: { tasks: Task[]; progress: Map<string, Progress>; editable: boolean }) {
  if (!tasks.length) return <p className="sub">No work has been added to this week yet.</p>;
  return (
    <div>
      {tasks.map((t) => {
        const p = progress.get(t.id);
        const needsText = NEEDS_SUBMISSION.includes(t.kind);
        return (
          <div className="item" key={t.id}>
            <div className="grow">
              <span className="t">{t.title}</span>
              <span className="sub">{t.details || LABELS[t.kind].hint}</span>
              {needsText && p?.submission ? (
                isLink(p.submission) ? (
                  <a href={p.submission} target="_blank" rel="noopener noreferrer" className="sub" style={{ color: 'var(--blue)', wordBreak: 'break-all' }}>{p.submission}</a>
                ) : (
                  <p className="sub" style={{ whiteSpace: 'pre-wrap', color: 'var(--ink)' }}>{p.submission}</p>
                )
              ) : null}
            </div>
            {!editable ? (
              p ? <span className="badge">Done</span> : <span className="badge grey">Not done</span>
            ) : needsText ? (
              <details style={{ flex: '1 1 100%' }} open={!p}>
                <summary className={`btn${p ? ' done' : ''}`} style={{ listStyle: 'none', display: 'inline-flex' }}>
                  {p ? 'Submitted · edit' : LABELS[t.kind].open}
                </summary>
                <form action={submitTask} className="stack" style={{ marginTop: 12, gap: 10 }}>
                  <input type="hidden" name="taskId" value={t.id} />
                  <label htmlFor={`s-${t.id}`} className="sub" style={{ fontWeight: 600 }}>
                    {t.kind === 'film' ? 'Link to your filmed rep' : 'Your homework'}
                  </label>
                  {t.kind === 'film' ? (
                    <input id={`s-${t.id}`} className="input" name="submission" type="url" placeholder="https://" defaultValue={p?.submission ?? ''} />
                  ) : (
                    <textarea id={`s-${t.id}`} className="textarea" name="submission" defaultValue={p?.submission ?? ''} />
                  )}
                  <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                    <button className="btn blue" type="submit">Save</button>
                    <span className="sub" style={{ alignSelf: 'center' }}>Clear the box and save to take it back.</span>
                  </div>
                </form>
              </details>
            ) : (
              <form action={toggleTask}>
                <input type="hidden" name="taskId" value={t.id} />
                <input type="hidden" name="done" value={p ? '1' : '0'} />
                <button className={`btn${p ? ' done' : ''}`} type="submit" aria-pressed={!!p}>
                  {p ? 'Done' : LABELS[t.kind].open}
                </button>
              </form>
            )}
          </div>
        );
      })}
    </div>
  );
}
