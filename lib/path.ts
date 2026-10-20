import 'server-only';
import { createClient } from '@/lib/supabase/server';
import type { Progress, Task } from '@/lib/basecamp';

// My Path: Trainer (units 1-6, one per month) and Coach (units 7-14, one per
// quarter). The database decides who is on the path and what is unlocked.

export const TOTAL_UNITS = 14;
export const TRAINER_UNITS = 6;

export type Unit = {
  n: number;
  phase: 'Trainer' | 'Coach';
  label: string;
  title: string;
  focus: string;
  summary: string;
  reading: string;
  is_gate: boolean;
};
export type UnitSignoff = { unit_n: number; note: string; signed_at: string; signed_by: string };

// "Trainer · Month 3" or "Coach · Year 2, Q1"
export function unitLabel(n: number): string {
  if (n <= TRAINER_UNITS) return `Month ${n}`;
  const q = n - TRAINER_UNITS - 1;
  return `Year ${2 + Math.floor(q / 4)}, Q${(q % 4) + 1}`;
}

export function openUnitFrom(signoffs: Pick<UnitSignoff, 'unit_n'>[]): number {
  const max = signoffs.reduce((m, s) => Math.max(m, s.unit_n), 0);
  return Math.min(max + 1, TOTAL_UNITS);
}

export function pathFinished(signoffs: Pick<UnitSignoff, 'unit_n'>[]): boolean {
  return signoffs.some((s) => s.unit_n === TOTAL_UNITS);
}

export async function isOnPath(userId: string): Promise<boolean> {
  const supabase = await createClient();
  const { data } = await supabase.rpc('on_path', { uid: userId });
  return data === true;
}

// One person's path, as the viewer is allowed to see it. Used for a coach's
// own page and for a mentor reviewing someone else.
export async function loadPath(userId: string, unitN: number | null) {
  const supabase = await createClient();
  const [{ data: units }, { data: signoffs }] = await Promise.all([
    supabase.from('path_units').select('*').order('n'),
    supabase.from('path_signoffs').select('unit_n, note, signed_at, signed_by').eq('user_id', userId).order('unit_n'),
  ]);
  const so = (signoffs ?? []) as UnitSignoff[];
  const open = openUnitFrom(so);
  const selected = unitN && unitN >= 1 && unitN <= open ? unitN : open;

  const { data: tasks } = await supabase.from('path_tasks').select('*').eq('unit_n', selected).order('sort');
  const taskList = ((tasks ?? []) as (Task & { unit_n: number })[]).map((t) => ({ ...t, week_n: t.unit_n }));
  const { data: progress } = taskList.length
    ? await supabase.from('path_progress').select('task_id, submission, completed_at').eq('user_id', userId).in('task_id', taskList.map((t) => t.id))
    : { data: [] };

  return {
    units: (units ?? []) as Unit[],
    signoffs: so,
    open,
    done: pathFinished(so),
    selected,
    tasks: taskList as Task[],
    progress: new Map(((progress ?? []) as Progress[]).map((p) => [p.task_id, p])),
  };
}
