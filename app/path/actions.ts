'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { requireRole } from '@/lib/auth';
import { TOTAL_UNITS } from '@/lib/path';

// Row-level security decides who is on the path, which unit is open, and who
// may sign off, so these actions stay thin.

export async function togglePathTask(formData: FormData) {
  const me = await requireRole(['coach']);
  const taskId = String(formData.get('taskId'));
  const done = formData.get('done') === '1';
  const supabase = await createClient();
  if (done) await supabase.from('path_progress').delete().eq('user_id', me.id).eq('task_id', taskId);
  else await supabase.from('path_progress').upsert({ user_id: me.id, task_id: taskId, submission: '', completed_at: new Date().toISOString() });
  revalidatePath('/path');
}

export async function submitPathTask(formData: FormData) {
  const me = await requireRole(['coach']);
  const taskId = String(formData.get('taskId'));
  const submission = String(formData.get('submission') ?? '').trim().slice(0, 8000);
  const supabase = await createClient();
  if (!submission) await supabase.from('path_progress').delete().eq('user_id', me.id).eq('task_id', taskId);
  else await supabase.from('path_progress').upsert({ user_id: me.id, task_id: taskId, submission, completed_at: new Date().toISOString() });
  revalidatePath('/path');
}

export async function signOffUnit(formData: FormData) {
  const me = await requireRole(['admin', 'coach']);
  const userId = String(formData.get('userId'));
  const unitN = Number(formData.get('unitN'));
  const note = String(formData.get('note') ?? '').trim().slice(0, 4000);
  const supabase = await createClient();
  const { error } = await supabase.from('path_signoffs').insert({ user_id: userId, unit_n: unitN, signed_by: me.id, note });
  revalidatePath('/coach');
  revalidatePath(`/coach/path/${userId}`);
  redirect(`/coach/path/${userId}?unit=${error ? unitN : Math.min(unitN + 1, TOTAL_UNITS)}${error ? '&e=signoff' : ''}`);
}

export async function undoUnitSignoff(formData: FormData) {
  await requireRole(['admin', 'coach']);
  const userId = String(formData.get('userId'));
  const unitN = Number(formData.get('unitN'));
  const supabase = await createClient();
  await supabase.from('path_signoffs').delete().eq('user_id', userId).eq('unit_n', unitN);
  revalidatePath('/coach');
  revalidatePath(`/coach/path/${userId}`);
  redirect(`/coach/path/${userId}?unit=${unitN}`);
}
