import Shell from '@/components/Shell';
import { requireRole } from '@/lib/auth';
import { createClient } from '@/lib/supabase/server';
import type { Module } from '@/lib/basecamp';
import { deleteModule, saveModule } from '../actions';

export const metadata = { title: 'Orientation' };

const OK: Record<string, string> = { saved: 'Saved.', deleted: 'Removed.' };

function ModuleFields({ m, nextSort }: { m?: Module; nextSort: number }) {
  const key = m?.id ?? 'new';
  return (
    <>
      {m ? <input type="hidden" name="id" value={m.id} /> : null}
      <div className="row" style={{ gap: 12 }}>
        <div className="field" style={{ flex: '2 1 240px' }}>
          <label htmlFor={`t-${key}`}>Title</label>
          <input id={`t-${key}`} name="title" className="input" defaultValue={m?.title ?? ''} required />
        </div>
        <div className="field" style={{ flex: '0 1 100px' }}>
          <label htmlFor={`o-${key}`}>Order</label>
          <input id={`o-${key}`} name="sort" type="number" className="input" defaultValue={m?.sort ?? nextSort} />
        </div>
      </div>
      <div className="field">
        <label htmlFor={`s-${key}`}>One-line summary</label>
        <input id={`s-${key}`} name="summary" className="input" defaultValue={m?.summary ?? ''} />
      </div>
      <div className="field">
        <label htmlFor={`b-${key}`}>Content</label>
        <textarea id={`b-${key}`} name="body" className="textarea" style={{ minHeight: 160 }} defaultValue={m?.body ?? ''} />
      </div>
      <div className="field">
        <label htmlFor={`v-${key}`}>Video link (optional)</label>
        <input id={`v-${key}`} name="video_url" type="url" className="input" defaultValue={m?.video_url ?? ''} placeholder="https://" />
      </div>
    </>
  );
}

export default async function OrientationAdmin({ searchParams }: { searchParams: Promise<{ ok?: string }> }) {
  const me = await requireRole(['admin']);
  const { ok } = await searchParams;
  const supabase = await createClient();
  const { data } = await supabase.from('orientation_modules').select('*').order('sort');
  const mods = (data ?? []) as Module[];
  const nextSort = mods.reduce((m, x) => Math.max(m, x.sort), 0) + 1;

  return (
    <Shell profile={me} active="/admin/orientation">
      <div className="stack" style={{ gap: 6 }}>
        <h1 className="h1">Orientation</h1>
        <p className="lede">What candidates and interns read first: vision, mission, values, the business model, and your commitment to them.</p>
      </div>
      {ok && OK[ok] ? <div className="note" role="status">{OK[ok]}</div> : null}
      <section className="card" style={{ gap: 0 }}>
        {mods.map((m) => (
          <div className="item" key={m.id}>
            <div className="grow">
              <span className="t">{m.title}</span>
              <span className="sub">{m.summary || 'No summary yet'}{m.body ? '' : ' · No content yet'}</span>
            </div>
            <details style={{ flex: '1 1 100%' }}>
              <summary className="btn" style={{ listStyle: 'none', display: 'inline-flex' }}>Edit</summary>
              <form action={saveModule} className="stack" style={{ marginTop: 12, gap: 12 }}>
                <ModuleFields m={m} nextSort={nextSort} />
                <button className="btn blue" type="submit" style={{ alignSelf: 'flex-start' }}>Save</button>
              </form>
              <form action={deleteModule} style={{ marginTop: 8 }}>
                <input type="hidden" name="id" value={m.id} />
                <button className="btn quiet" type="submit" style={{ color: 'var(--warn)' }}>Remove</button>
              </form>
            </details>
          </div>
        ))}
      </section>
      <form action={saveModule} className="card">
        <h2 style={{ fontSize: 20 }}>Add a section</h2>
        <ModuleFields nextSort={nextSort} />
        <button className="btn primary" type="submit" style={{ alignSelf: 'flex-start' }}>Add section</button>
      </form>
    </Shell>
  );
}
