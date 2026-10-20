import Link from 'next/link';
import Shell from '@/components/Shell';
import { requireRole } from '@/lib/auth';
import { createAdminClient, createClient } from '@/lib/supabase/server';
import { unitLabel } from '@/lib/path';
import { reviewReflection } from '../actions';

export const metadata = { title: 'Reflections' };

type Row = { user_id: string; question_id: string; answer: string; submitted_at: string; reviewed_at: string | null; comment: string };
type Q = { id: string; prompt: string; task_id: string | null; path_task_id: string | null };
type T = { id: string; title: string; week_n?: number; unit_n?: number };

const day = (s: string) => new Date(s).toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });

// Every lesson ends with a reflection. Leadership reads them weekly here,
// marks each one reviewed and can leave a note the learner sees.
export default async function Reflections({ searchParams }: { searchParams: Promise<{ show?: string }> }) {
  const me = await requireRole(['admin', 'coach']);
  const { show } = await searchParams;
  const reviewed = show === 'reviewed';
  const supabase = await createClient();

  let query = supabase.from('quiz_responses').select('user_id, question_id, answer, submitted_at, reviewed_at, comment');
  query = reviewed ? query.not('reviewed_at', 'is', null).order('reviewed_at', { ascending: false }).limit(150) : query.is('reviewed_at', null).order('submitted_at').limit(300);
  const { data } = await query;
  const rows = (data ?? []) as Row[];

  // Staff can read every reflection; the question and lesson names come from
  // the server so a mentor sees context for My Path units they haven't done.
  const admin = createAdminClient();
  const qIds = [...new Set(rows.map((r) => r.question_id))];
  const uIds = [...new Set(rows.map((r) => r.user_id))];
  const { data: qs } = qIds.length ? await admin.from('quiz_questions').select('id, prompt, task_id, path_task_id').in('id', qIds) : { data: [] };
  const questions = new Map(((qs ?? []) as Q[]).map((q) => [q.id, q]));
  const tIds = [...new Set([...questions.values()].map((q) => q.task_id).filter(Boolean))] as string[];
  const pIds = [...new Set([...questions.values()].map((q) => q.path_task_id).filter(Boolean))] as string[];
  const [{ data: ts }, { data: ps }, { data: people }] = await Promise.all([
    tIds.length ? admin.from('tasks').select('id, title, week_n').in('id', tIds) : Promise.resolve({ data: [] }),
    pIds.length ? admin.from('path_tasks').select('id, title, unit_n').in('id', pIds) : Promise.resolve({ data: [] }),
    uIds.length ? supabase.from('profiles').select('id, full_name, email, role').in('id', uIds) : Promise.resolve({ data: [] }),
  ]);
  const tasks = new Map([...((ts ?? []) as T[]), ...((ps ?? []) as T[])].map((t) => [t.id, t]));
  const names = new Map(((people ?? []) as { id: string; full_name: string; email: string }[]).map((p) => [p.id, p.full_name || p.email]));

  const where = (q?: Q) => {
    const t = q ? tasks.get((q.task_id ?? q.path_task_id) as string) : undefined;
    if (!t) return { key: 'Other', sort: 999, lesson: '' };
    if (t.week_n !== undefined) return { key: `BaseCamp week ${t.week_n}`, sort: t.week_n, lesson: t.title };
    return { key: `My Path · ${unitLabel(t.unit_n ?? 1)}`, sort: 100 + (t.unit_n ?? 0), lesson: t.title };
  };

  // Group by person, then by week or unit.
  const groups = new Map<string, Map<string, { sort: number; items: (Row & { prompt: string; lesson: string })[] }>>();
  for (const r of rows) {
    const q = questions.get(r.question_id);
    const w = where(q);
    if (!groups.has(r.user_id)) groups.set(r.user_id, new Map());
    const g = groups.get(r.user_id)!;
    if (!g.has(w.key)) g.set(w.key, { sort: w.sort, items: [] });
    g.get(w.key)!.items.push({ ...r, prompt: q?.prompt ?? '', lesson: w.lesson });
  }
  const people_ = [...groups.entries()].sort((a, b) => (names.get(a[0]) ?? '').localeCompare(names.get(b[0]) ?? ''));

  return (
    <Shell profile={me} active="/coach/reflections">
      <div className="stack" style={{ gap: 6 }}>
        <h1 className="h1">Reflections</h1>
        <p className="lede">
          Every lesson ends with a reflection. They aren&apos;t graded. Read them each week, mark them reviewed, and leave a note when
          something is worth a word. The learner sees your note under their answer.
        </p>
      </div>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <Link href="/coach/reflections" className={`btn${reviewed ? '' : ' blue'}`}>Waiting for review</Link>
        <Link href="/coach/reflections?show=reviewed" className={`btn${reviewed ? ' blue' : ''}`}>Reviewed</Link>
      </div>

      {!rows.length ? (
        <section className="card"><p className="sub">{reviewed ? 'Nothing reviewed yet.' : 'You’re caught up. No reflections are waiting.'}</p></section>
      ) : null}

      {people_.map(([uid, weeks]) => (
        <section className="card" key={uid} style={{ gap: 8 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap', alignItems: 'baseline' }}>
            <h2 style={{ fontSize: 20 }}>{names.get(uid) ?? 'Unknown'}</h2>
            <span className="sub">{[...weeks.values()].reduce((n, w) => n + w.items.length, 0)} {reviewed ? 'reviewed' : 'to read'}</span>
          </div>
          {[...weeks.entries()].sort((a, b) => a[1].sort - b[1].sort).map(([label, w]) => (
            <div key={label} className="stack" style={{ gap: 0 }}>
              <div className="eyebrow" style={{ marginTop: 8 }}>{label}</div>
              {w.items.map((r) => (
                <div className="item" key={r.question_id} style={{ alignItems: 'flex-start' }}>
                  <div className="grow">
                    <span className="t">{r.lesson}</span>
                    <span className="sub">{r.prompt}</span>
                    <p className="quiz-answer" style={{ marginTop: 6 }}>{r.answer}</p>
                    <span className="sub">Submitted {day(r.submitted_at)}{r.reviewed_at ? ` · reviewed ${day(r.reviewed_at)}` : ''}</span>
                  </div>
                  <form action={reviewReflection} className="stack" style={{ flex: '1 1 260px', gap: 8 }}>
                    <input type="hidden" name="userId" value={r.user_id} />
                    <input type="hidden" name="questionId" value={r.question_id} />
                    <textarea className="textarea" name="note" aria-label="Note back (optional)" placeholder="Note back (optional)" defaultValue={r.comment} style={{ minHeight: 72 }} />
                    <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                      <button className="btn primary" type="submit" name="done" value="1">{reviewed ? 'Save note' : 'Mark reviewed'}</button>
                      {reviewed ? <button className="btn" type="submit" name="done" value="0">Reopen</button> : null}
                    </div>
                  </form>
                </div>
              ))}
            </div>
          ))}
        </section>
      ))}
    </Shell>
  );
}
