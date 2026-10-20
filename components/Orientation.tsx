import { toggleModule } from '@/app/basecamp/actions';
import { createClient } from '@/lib/supabase/server';
import type { Module } from '@/lib/basecamp';
import Lesson from './Lesson';

export default async function Orientation({ userId }: { userId: string }) {
  const supabase = await createClient();
  const [{ data: mods }, { data: prog }] = await Promise.all([
    supabase.from('orientation_modules').select('*').order('sort'),
    supabase.from('orientation_progress').select('module_id').eq('user_id', userId),
  ]);
  const modules = (mods ?? []) as Module[];
  const done = new Set((prog ?? []).map((p: { module_id: string }) => p.module_id));

  return (
    <section className="card" style={{ gap: 6 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap', alignItems: 'baseline' }}>
        <h2 style={{ fontSize: 20 }}>Orientation</h2>
        <span className="sub">{done.size} of {modules.length} complete</span>
      </div>
      {modules.map((m) => {
        const d = done.has(m.id);
        return (
          <div className="item" key={m.id}>
            <div className="grow">
              <span className="t">{m.title}</span>
              {m.summary ? <span className="sub">{m.summary}</span> : null}
              {m.body ? (
                <details className="reader">
                  <summary>Read this section</summary>
                  <Lesson text={m.body} />
                </details>
              ) : null}
              {m.video_url ? (
                <a href={m.video_url} target="_blank" rel="noopener noreferrer" className="sub" style={{ color: 'var(--blue)' }}>Watch the video</a>
              ) : null}
            </div>
            <form action={toggleModule}>
              <input type="hidden" name="moduleId" value={m.id} />
              <input type="hidden" name="done" value={d ? '1' : '0'} />
              <button className={`btn${d ? ' done' : ''}`} type="submit" aria-pressed={d}>{d ? 'Complete' : 'Mark complete'}</button>
            </form>
          </div>
        );
      })}
    </section>
  );
}
