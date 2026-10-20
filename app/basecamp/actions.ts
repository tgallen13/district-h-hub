'use server';

import { revalidatePath } from 'next/cache';
import { createClient } from '@/lib/supabase/server';
import { requireRole } from '@/lib/auth';

// Row-level security enforces that interns can only touch tasks in their open
// week, so these actions stay thin.

export async function toggleTask(formData: FormData) {
  const me = await requireRole(['intern']);
  const taskId = String(formData.get('taskId'));
  const done = formData.get('done') === '1';
  const supabase = await createClient();
  if (done) {
    await supabase.from('task_progress').delete().eq('user_id', me.id).eq('task_id', taskId);
  } else {
    await supabase.from('task_progress').upsert({ user_id: me.id, task_id: taskId, submission: '', completed_at: new Date().toISOString() });
  }
  revalidatePath('/basecamp');
}

export async function submitTask(formData: FormData) {
  const me = await requireRole(['intern']);
  const taskId = String(formData.get('taskId'));
  const submission = String(formData.get('submission') ?? '').trim().slice(0, 8000);
  const supabase = await createClient();
  if (!submission) {
    await supabase.from('task_progress').delete().eq('user_id', me.id).eq('task_id', taskId);
  } else {
    await supabase.from('task_progress').upsert({ user_id: me.id, task_id: taskId, submission, completed_at: new Date().toISOString() });
  }
  revalidatePath('/basecamp');
}

export async function toggleModule(formData: FormData) {
  const me = await requireRole(['intern', 'candidate']);
  const moduleId = String(formData.get('moduleId'));
  const done = formData.get('done') === '1';
  const supabase = await createClient();
  if (done) {
    await supabase.from('orientation_progress').delete().eq('user_id', me.id).eq('module_id', moduleId);
  } else {
    await supabase.from('orientation_progress').upsert({ user_id: me.id, module_id: moduleId });
  }
  revalidatePath('/basecamp');
  revalidatePath('/basecamp/orientation');
}
