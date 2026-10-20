import 'server-only';
import { createClient } from '@/lib/supabase/server';

export type Week = { n: number; phase: string; title: string; system_focus: string; summary: string; is_gate: boolean };
export type TaskKind = 'lesson' | 'film' | 'homework' | 'huddle';
export type Task = { id: string; week_n: number; sort: number; kind: TaskKind; title: string; details: string };
export type Progress = { task_id: string; submission: string; completed_at: string };
export type Signoff = { week_n: number; note: string; signed_at: string; signed_by: string };
export type Module = { id: string; sort: number; title: string; summary: string; body: string; video_url: string };

export const TOTAL_WEEKS = 24;
export const NEEDS_SUBMISSION: TaskKind[] = ['film', 'homework'];

export function openWeekFrom(signoffs: Pick<Signoff, 'week_n'>[]): number {
  const max = signoffs.reduce((m, s) => Math.max(m, s.week_n), 0);
  return Math.min(max + 1, TOTAL_WEEKS);
}

// True once every week is signed off, including week 24 (the Instructor gate).
export function finished(signoffs: Pick<Signoff, 'week_n'>[]): boolean {
  return signoffs.some((s) => s.week_n === TOTAL_WEEKS);
}

export function gateFor(openWeek: number): { title: string; body: string; week: number } {
  return openWeek <= 12
    ? { week: 12, title: 'Presenter gate, week 12', body: 'A filmed warm-up, a coached segment, and a systems check.' }
    : { week: 24, title: 'Instructor gate, week 24', body: 'A solo session with the full operational trail, an archetype drill, and a discovery call sign-off. This is the hiring decision.' };
}

export function readingFor(openWeek: number): { title: string; line: string } {
  return openWeek <= 12
    ? { title: 'The Coaching Habit', line: 'Connection comes before advice, and questions are how you build it.' }
    : { title: 'Conscious Coaching', line: 'Reading the person in front of you and tailoring how you coach them.' };
}

// Everything one intern's BaseCamp page needs. Uses the viewer's own session,
// so an intern can only ever load their own unlocked tasks.
export async function loadIntern(userId: string, weekN: number | null) {
  const supabase = await createClient();
  const [{ data: weeks }, { data: signoffs }] = await Promise.all([
    supabase.from('weeks').select('*').order('n'),
    supabase.from('week_signoffs').select('week_n, note, signed_at, signed_by').eq('user_id', userId).order('week_n'),
  ]);
  const so = (signoffs ?? []) as Signoff[];
  const open = openWeekFrom(so);
  const selected = weekN && weekN >= 1 && weekN <= open ? weekN : open;

  const { data: tasks } = await supabase.from('tasks').select('*').eq('week_n', selected).order('sort');
  const taskList = (tasks ?? []) as Task[];
  const { data: progress } = taskList.length
    ? await supabase.from('task_progress').select('task_id, submission, completed_at').eq('user_id', userId).in('task_id', taskList.map((t) => t.id))
    : { data: [] };

  return {
    weeks: (weeks ?? []) as Week[],
    signoffs: so,
    open,
    done: finished(so),
    selected,
    tasks: taskList,
    progress: new Map(((progress ?? []) as Progress[]).map((p) => [p.task_id, p])),
  };
}
