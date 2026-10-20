import Link from 'next/link';
import { notFound } from 'next/navigation';
import Shell from '@/components/Shell';
import { requireRole } from '@/lib/auth';
import { createClient } from '@/lib/supabase/server';
import type { Task, Week } from '@/lib/basecamp';
import { deleteTask, saveTask, saveWeek } from '../../actions';

export const metadata = { title: 'Edit week' };

const OK: Record<string, string> = { week: 'Week saved.', task: 'Item saved.', deleted: 'Item removed.' };
const KIND_LABEL = { lesson: 'Lesson', film: 'Filmed rep (link)', homework: 'Homework (written)', huddle: 'Huddle' } as const;

function KindSelect({ id, value }: { id: string; value?: string }) {
  return (
    <select id={id} name="kind" className="select" defaultValue={value ?? 'lesson'}>
      {Object.entries(KIND_LABEL).map(([k, label]) => (
        <option key={k} value={k}>{label}</option>
      ))}
    </select>
  );
}

function TaskFields({ t, n, nextSort }: { t?: Task; n: number; nextSort: number }) {
  const key = t?.id ?? 'new';
  return (
    <>
      <input type="hidden" name="week_n" value={n} />
      {t ? <input type="hidden" name="id" value={t.id} /> : null}
      <div className="row" style={{ gap: 12 }}>
        <div className="field" style={{ flex: '2 1 240px' }}>
          <label htmlFor={`t-${key}`}>Title</label>
          <input id={`t-${key}`} name="title" className="input" defaultValue={t?.title ?? ''} required />
        </div>
        <div className="field" style={{ flex: '1 1 180px' }}>
          <label htmlFor={`k-${key}`}>Type</label>
          <KindSelect id={`k-${key}`} value={t?.kind} />
        </div>
        <div className="field" style={{ flex: '0 1 100px' }}>
          <label htmlFor={`o-${key}`}>Order</label>
          <input id={`o-${key}`} name="sort" type="number" className="input" defaultValue={t?.sort ?? nextSort} />
        </div>
      </div>
      <div className="field">
        <label htmlFor={`d-${key}`}>Instructions for the intern</label>
        <textarea id={`d-${key}`} name="details" className="textarea" defaultValue={t?.details ?? ''} placeholder="What to read, watch, or do. Paste links here too." />
      </div>
      <div className="field">
        <label htmlFor={`b-${key}`}>Full lesson (optional)</label>
        <textarea id={`b-${key}`} name="body" className="textarea" style={{ minHeight: 220 }} defaultValue={t?.body ?? ''} placeholder="The reading interns open from this item. Blank line between paragraphs. Start a line with - for a bullet, ### for a subhead, and wrap words in ** for bold." />
      </div>
    </>
  );
}

export default async function EditWeek({ params, searchParams }: { params: Promise<{ n: string }>; searchParams: Promise<{ ok?: string }> }) {
  const me = await requireRole(['admin']);
  const { n: nStr } = await params;
  const { ok } = await searchParams;
  const n = Number(nStr);
  if (!Number.isInteger(n) || n < 1 || n > 24) notFound();

  const supabase = await createClient();
  const [{ data: week }, { data: tasks }] = await Promise.all([
    supabase.from('weeks').select('*').eq('n', n).single(),
    supabase.from('tasks').select('*').eq('week_n', n).order('sort'),
  ]);
  if (!week) notFound();
  const w = week as Week;
  const list = (tasks ?? []) as Task[];
  const nextSort = list.reduce((m, t) => Math.max(m, t.sort), 0) + 1;

  return (
    <Shell profile={me} active="/admin/weeks">
      <div className="stack" style={{ gap: 6 }}>
        <Link href="/admin/weeks" className="sub">&larr; All weeks</Link>
        <h1 className="h1">Week {n}</h1>
        <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap' }}>
          {n > 1 ? <Link className="sub" href={`/admin/weeks/${n - 1}`}>Previous week</Link> : null}
          {n < 24 ? <Link className="sub" href={`/admin/weeks/${n + 1}`}>Next week</Link> : null}
        </div>
      </div>
      {ok && OK[ok] ? <div className="note" role="status">{OK[ok]}</div> : null}

      <form action={saveWeek} className="card">
        <input type="hidden" name="n" value={n} />
        <div className="eyebrow">{w.phase} phase</div>
        <div className="field">
          <label htmlFor="title">Week title</label>
          <input id="title" name="title" className="input" defaultValue={w.title} required />
        </div>
        <div className="field">
          <label htmlFor="system_focus">System this week</label>
          <input id="system_focus" name="system_focus" className="input" defaultValue={w.system_focus} placeholder="For example, PushPress or Lead Connector" />
        </div>
        <div className="field">
          <label htmlFor="summary">What this week is about</label>
          <textarea id="summary" name="summary" className="textarea" defaultValue={w.summary} />
        </div>
        <label style={{ display: 'flex', gap: 10, alignItems: 'center', fontWeight: 500 }}>
          <input type="checkbox" name="is_gate" defaultChecked={w.is_gate} style={{ width: 20, height: 20 }} /> This is a gate week
        </label>
        <button className="btn blue" type="submit" style={{ alignSelf: 'flex-start' }}>Save week</button>
      </form>

      <section className="card" style={{ gap: 0 }}>
        <h2 style={{ fontSize: 20, marginBottom: 6 }}>The work ({list.length})</h2>
        {list.map((t) => (
          <div className="item" key={t.id}>
            <div className="grow">
              <span className="t">{t.title}</span>
              <span className="sub">{KIND_LABEL[t.kind]}{t.details ? ` · ${t.details.slice(0, 90)}${t.details.length > 90 ? '…' : ''}` : ''}</span>
            </div>
            <details style={{ flex: '1 1 100%' }}>
              <summary className="btn" style={{ listStyle: 'none', display: 'inline-flex' }}>Edit</summary>
              <form action={saveTask} className="stack" style={{ marginTop: 12, gap: 12 }}>
                <TaskFields t={t} n={n} nextSort={nextSort} />
                <button className="btn blue" type="submit" style={{ alignSelf: 'flex-start' }}>Save item</button>
              </form>
              <form action={deleteTask} style={{ marginTop: 8 }}>
                <input type="hidden" name="week_n" value={n} />
                <input type="hidden" name="id" value={t.id} />
                <button className="btn quiet" type="submit" style={{ color: 'var(--warn)' }}>Remove this item</button>
              </form>
            </details>
          </div>
        ))}
      </section>

      <form action={saveTask} className="card">
        <h2 style={{ fontSize: 20 }}>Add an item</h2>
        <TaskFields n={n} nextSort={nextSort} />
        <button className="btn primary" type="submit" style={{ alignSelf: 'flex-start' }}>Add to week {n}</button>
      </form>
    </Shell>
  );
}
