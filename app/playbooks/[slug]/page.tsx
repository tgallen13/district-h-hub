import Link from 'next/link';
import { notFound } from 'next/navigation';
import Shell from '@/components/Shell';
import Lesson from '@/components/Lesson';
import { requireRole } from '@/lib/auth';
import { loadPlaybook } from '@/lib/playbooks';
import { archiveRun, deleteItem, saveItem, saveSection, startRun, toggleCheck } from '../actions';

export const metadata = { title: 'Playbook' };

function fmtDate(d: string | null) {
  if (!d) return '';
  return new Date(`${d}T12:00:00`).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}

export default async function PlaybookPage({ params, searchParams }: { params: Promise<{ slug: string }>; searchParams: Promise<{ run?: string }> }) {
  const me = await requireRole(['admin', 'coach']);
  const isAdmin = me.role === 'admin';
  const { slug } = await params;
  const { run: runParam } = await searchParams;
  const d = await loadPlaybook(slug, runParam ?? null);
  if (!d) notFound();
  const { playbook, sections, items, runs, run, checked } = d;
  const runId = run?.id ?? '';
  const live = !!run && !run.archived;
  const total = items.length;
  const done = items.filter((i) => checked.has(i.id)).length;
  const pct = total ? Math.round((done / total) * 100) : 0;

  return (
    <Shell profile={me} active="/playbooks">
      <div className="stack" style={{ gap: 6 }}>
        <Link href="/playbooks" className="sub">&larr; All playbooks</Link>
        <h1 className="h1">{playbook.title}</h1>
        {playbook.summary ? <p className="lede">{playbook.summary}</p> : null}
      </div>

      <section className="card" style={{ gap: 12 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap', alignItems: 'baseline' }}>
          <h2 style={{ fontSize: 20 }}>{run ? run.name : 'No opening in progress'}</h2>
          {run ? (
            <span className="sub">
              {run.target_date ? `Target ${fmtDate(run.target_date)} · ` : ''}
              {done} of {total} steps done{run.archived ? ' · Archived' : ''}
            </span>
          ) : null}
        </div>
        {run ? (
          <div className="bar" role="progressbar" aria-valuenow={pct} aria-valuemin={0} aria-valuemax={100} aria-label="Checklist progress">
            <div style={{ width: `${pct}%` }} />
          </div>
        ) : (
          <p className="sub">{isAdmin ? 'Start an opening below to track the checklist for a real location.' : 'When an admin starts an opening, you can work through the checklist here.'}</p>
        )}
        {runs.length > 1 ? (
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            {runs.map((r) => (
              <Link key={r.id} href={`/playbooks/${slug}?run=${r.id}`} className={`badge${r.id === runId ? ' blue' : ' grey'}`}>
                {r.name}{r.archived ? ' (archived)' : ''}
              </Link>
            ))}
          </div>
        ) : null}
        {isAdmin ? (
          <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap', alignItems: 'flex-end' }}>
            <details>
              <summary className="btn" style={{ listStyle: 'none', display: 'inline-flex' }}>Start a new opening</summary>
              <form action={startRun} className="row" style={{ gap: 12, marginTop: 12, alignItems: 'flex-end' }}>
                <input type="hidden" name="slug" value={slug} />
                <div className="field" style={{ flex: '2 1 220px' }}>
                  <label htmlFor="run-name">Name</label>
                  <input id="run-name" name="name" className="input" placeholder="For example, Location 3: Garden Oaks" required />
                </div>
                <div className="field" style={{ flex: '1 1 160px' }}>
                  <label htmlFor="run-date">Target opening date</label>
                  <input id="run-date" name="target_date" type="date" className="input" />
                </div>
                <button className="btn blue" type="submit">Start</button>
              </form>
            </details>
            {run ? (
              <form action={archiveRun}>
                <input type="hidden" name="slug" value={slug} />
                <input type="hidden" name="runId" value={runId} />
                <input type="hidden" name="archived" value={run.archived ? '0' : '1'} />
                <button className="btn quiet" type="submit">{run.archived ? 'Reopen this opening' : 'Archive this opening'}</button>
              </form>
            ) : null}
          </div>
        ) : null}
      </section>

      {sections.map((s) => {
        const list = items.filter((i) => i.section_id === s.id);
        const sDone = list.filter((i) => checked.has(i.id)).length;
        const nextSort = list.reduce((m, i) => Math.max(m, i.sort), 0) + 1;
        return (
          <section className="card" key={s.id} id={`s-${s.id}`} style={{ gap: 10 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap', alignItems: 'baseline' }}>
              <div className="stack" style={{ gap: 4 }}>
                {s.timing ? <div className="eyebrow">{s.timing}</div> : null}
                <h2 style={{ fontSize: 22 }}>{s.title}</h2>
              </div>
              {run && list.length ? <span className="sub">{sDone} of {list.length} done</span> : null}
            </div>
            {s.body ? (
              <details className="reader">
                <summary>Read this phase</summary>
                <Lesson text={s.body} />
              </details>
            ) : null}

            <div>
              {list.map((i) => {
                const isDone = checked.has(i.id);
                return (
                  <div className="item" key={i.id}>
                    <div className="grow">
                      <span className="t" style={{ fontWeight: 500, textDecoration: isDone ? 'line-through' : undefined, color: isDone ? 'var(--muted)' : undefined }}>{i.text}</span>
                      {i.owner ? <span className="sub">Owner: {i.owner}</span> : null}
                    </div>
                    {live ? (
                      <form action={toggleCheck}>
                        <input type="hidden" name="slug" value={slug} />
                        <input type="hidden" name="runId" value={runId} />
                        <input type="hidden" name="itemId" value={i.id} />
                        <input type="hidden" name="sectionId" value={s.id} />
                        <input type="hidden" name="done" value={isDone ? '1' : '0'} />
                        <button className={`btn${isDone ? ' done' : ''}`} type="submit" aria-pressed={isDone}>{isDone ? 'Done' : 'Mark done'}</button>
                      </form>
                    ) : run ? (
                      isDone ? <span className="badge">Done</span> : <span className="badge grey">Not done</span>
                    ) : null}
                    {isAdmin ? (
                      <details style={{ flex: '1 1 100%' }}>
                        <summary className="sub" style={{ cursor: 'pointer' }}>Edit step</summary>
                        <form action={saveItem} className="row" style={{ gap: 12, marginTop: 8, alignItems: 'flex-end' }}>
                          <input type="hidden" name="slug" value={slug} />
                          <input type="hidden" name="runId" value={runId} />
                          <input type="hidden" name="sectionId" value={s.id} />
                          <input type="hidden" name="id" value={i.id} />
                          <div className="field" style={{ flex: '3 1 260px' }}>
                            <label htmlFor={`it-${i.id}`}>Step</label>
                            <input id={`it-${i.id}`} name="text" className="input" defaultValue={i.text} />
                          </div>
                          <div className="field" style={{ flex: '1 1 140px' }}>
                            <label htmlFor={`io-${i.id}`}>Owner</label>
                            <input id={`io-${i.id}`} name="owner" className="input" defaultValue={i.owner} />
                          </div>
                          <div className="field" style={{ flex: '0 1 90px' }}>
                            <label htmlFor={`is-${i.id}`}>Order</label>
                            <input id={`is-${i.id}`} name="sort" type="number" className="input" defaultValue={i.sort} />
                          </div>
                          <button className="btn blue" type="submit">Save</button>
                        </form>
                        <form action={deleteItem} style={{ marginTop: 6 }}>
                          <input type="hidden" name="slug" value={slug} />
                          <input type="hidden" name="runId" value={runId} />
                          <input type="hidden" name="sectionId" value={s.id} />
                          <input type="hidden" name="id" value={i.id} />
                          <button className="btn quiet" type="submit" style={{ color: 'var(--warn)' }}>Remove step</button>
                        </form>
                      </details>
                    ) : null}
                  </div>
                );
              })}
            </div>

            {isAdmin ? (
              <details>
                <summary className="sub" style={{ cursor: 'pointer' }}>Edit this phase or add a step</summary>
                <form action={saveItem} className="row" style={{ gap: 12, marginTop: 10, alignItems: 'flex-end' }}>
                  <input type="hidden" name="slug" value={slug} />
                  <input type="hidden" name="runId" value={runId} />
                  <input type="hidden" name="sectionId" value={s.id} />
                  <input type="hidden" name="sort" value={nextSort} />
                  <div className="field" style={{ flex: '3 1 260px' }}>
                    <label htmlFor={`new-${s.id}`}>New step</label>
                    <input id={`new-${s.id}`} name="text" className="input" required />
                  </div>
                  <div className="field" style={{ flex: '1 1 140px' }}>
                    <label htmlFor={`newo-${s.id}`}>Owner</label>
                    <input id={`newo-${s.id}`} name="owner" className="input" />
                  </div>
                  <button className="btn" type="submit">Add step</button>
                </form>
                <form action={saveSection} className="stack" style={{ gap: 10, marginTop: 14 }}>
                  <input type="hidden" name="slug" value={slug} />
                  <input type="hidden" name="runId" value={runId} />
                  <input type="hidden" name="id" value={s.id} />
                  <div className="row" style={{ gap: 12 }}>
                    <div className="field" style={{ flex: '2 1 220px' }}>
                      <label htmlFor={`st-${s.id}`}>Phase title</label>
                      <input id={`st-${s.id}`} name="title" className="input" defaultValue={s.title} />
                    </div>
                    <div className="field" style={{ flex: '1 1 160px' }}>
                      <label htmlFor={`sw-${s.id}`}>When</label>
                      <input id={`sw-${s.id}`} name="timing" className="input" defaultValue={s.timing} />
                    </div>
                    <div className="field" style={{ flex: '0 1 90px' }}>
                      <label htmlFor={`so-${s.id}`}>Order</label>
                      <input id={`so-${s.id}`} name="sort" type="number" className="input" defaultValue={s.sort} />
                    </div>
                  </div>
                  <div className="field">
                    <label htmlFor={`sb-${s.id}`}>Reading</label>
                    <textarea id={`sb-${s.id}`} name="body" className="textarea" style={{ minHeight: 200 }} defaultValue={s.body} />
                  </div>
                  <button className="btn blue" type="submit" style={{ alignSelf: 'flex-start' }}>Save phase</button>
                </form>
              </details>
            ) : null}
          </section>
        );
      })}

      {isAdmin ? (
        <form action={saveSection} className="card" style={{ gap: 10 }}>
          <h2 style={{ fontSize: 20 }}>Add a phase</h2>
          <input type="hidden" name="slug" value={slug} />
          <input type="hidden" name="runId" value={runId} />
          <input type="hidden" name="sort" value={sections.reduce((m, s) => Math.max(m, s.sort), 0) + 1} />
          <div className="row" style={{ gap: 12 }}>
            <div className="field" style={{ flex: '2 1 220px' }}>
              <label htmlFor="ns-title">Phase title</label>
              <input id="ns-title" name="title" className="input" required />
            </div>
            <div className="field" style={{ flex: '1 1 160px' }}>
              <label htmlFor="ns-when">When</label>
              <input id="ns-when" name="timing" className="input" placeholder="For example, 6 months out" />
            </div>
          </div>
          <button className="btn" type="submit" style={{ alignSelf: 'flex-start' }}>Add phase</button>
        </form>
      ) : null}
    </Shell>
  );
}
