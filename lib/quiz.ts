import 'server-only';
import { createClient } from '@/lib/supabase/server';

export type QuizQuestion = { id: string; sort: number; kind: 'mc' | 'short'; prompt: string; choices: string[] };
export type Reflection = { question_id: string; answer: string; submitted_at: string; reviewed_at: string | null; comment: string };
export type Attempt = { answers: Record<string, string | number>; correct: number; total: number; wrong: string[]; at: string };
export type QuizState = {
  questions: QuizQuestion[];
  passed: boolean;
  tries: number;
  last: Attempt | null;
  reflections: Map<string, Reflection>;
};

// Quiz state for a set of lessons, for one learner. track picks BaseCamp tasks
// or My Path tasks. Works for the learner themselves and for staff reviewing.
export async function loadQuizzes(track: 'basecamp' | 'path', taskIds: string[], userId: string): Promise<Map<string, QuizState>> {
  const out = new Map<string, QuizState>();
  if (!taskIds.length) return out;
  const col = track === 'basecamp' ? 'task_id' : 'path_task_id';
  const supabase = await createClient();
  const { data: qs } = await supabase.from('quiz_questions').select(`id, sort, kind, prompt, choices, ${col}`).in(col, taskIds).order('sort');
  const questions = (qs ?? []) as (QuizQuestion & Record<string, string>)[];
  if (!questions.length) return out;

  const [{ data: passes }, { data: attempts }, { data: refl }] = await Promise.all([
    supabase.from('quiz_passes').select(col).eq('user_id', userId).in(col, taskIds),
    supabase.from('quiz_attempts').select(`${col}, answers, correct, total, wrong, at`).eq('user_id', userId).in(col, taskIds).order('at', { ascending: false }),
    supabase.from('quiz_responses').select('question_id, answer, submitted_at, reviewed_at, comment').eq('user_id', userId).in('question_id', questions.map((q) => q.id)),
  ]);
  const passed = new Set(((passes ?? []) as Record<string, string>[]).map((p) => p[col]));
  const reflections = new Map(((refl ?? []) as Reflection[]).map((r) => [r.question_id, r]));

  for (const q of questions) {
    const tid = q[col];
    if (!out.has(tid)) out.set(tid, { questions: [], passed: passed.has(tid), tries: 0, last: null, reflections: new Map() });
    const s = out.get(tid)!;
    s.questions.push({ id: q.id, sort: q.sort, kind: q.kind, prompt: q.prompt, choices: q.choices ?? [] });
    const r = reflections.get(q.id);
    if (r) s.reflections.set(q.id, r);
  }
  for (const a of (attempts ?? []) as (Attempt & Record<string, unknown>)[]) {
    const s = out.get(a[col] as string);
    if (!s) continue;
    s.tries++;
    if (!s.last) s.last = { answers: a.answers, correct: a.correct, total: a.total, wrong: a.wrong ?? [], at: a.at };
  }
  return out;
}

// Turn the quiz form into the {question id: answer} object submit_quiz() grades.
export function answersFrom(formData: FormData): Record<string, string> {
  const answers: Record<string, string> = {};
  for (const [k, v] of formData.entries()) {
    if (k.startsWith('q:') && typeof v === 'string') answers[k.slice(2)] = v.slice(0, 4000);
  }
  return answers;
}
