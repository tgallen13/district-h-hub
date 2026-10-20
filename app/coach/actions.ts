'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { requireRole } from '@/lib/auth';

// The database only accepts a sign-off for the intern's open week and only an
// undo of their latest sign-off, so weeks always unlock in order.

export async function signOff(formData: FormData) {
  const me = await requireRole(['admin', 'coach']);
  const internId = String(formData.get('internId'));
  const weekN = Number(formData.get('weekN'));
  const note = String(formData.get('note') ?? '').trim().slice(0, 4000);
  const supabase = await createClient();
  const { error } = await supabase.from('week_signoffs').insert({ user_id: internId, week_n: weekN, signed_by: me.id, note });
  revalidatePath('/coach');
  revalidatePath(`/coach/${internId}`);
  redirect(`/coach/${internId}?week=${error ? weekN : Math.min(weekN + 1, 24)}${error ? '&e=signoff' : ''}`);
}

export async function undoSignoff(formData: FormData) {
  await requireRole(['admin', 'coach']);
  const internId = String(formData.get('internId'));
  const weekN = Number(formData.get('weekN'));
  const supabase = await createClient();
  await supabase.from('week_signoffs').delete().eq('user_id', internId).eq('week_n', weekN);
  revalidatePath('/coach');
  revalidatePath(`/coach/${internId}`);
  redirect(`/coach/${internId}?week=${weekN}`);
}

// Leadership's weekly read of reflections: mark reviewed (or reopen) with an
// optional note the learner sees under their answer.
export async function reviewReflection(formData: FormData) {
  await requireRole(['admin', 'coach']);
  const learner = String(formData.get('userId'));
  const questionId = String(formData.get('questionId'));
  const note = String(formData.get('note') ?? '').trim().slice(0, 2000);
  const done = formData.get('done') !== '0';
  const supabase = await createClient();
  await supabase.rpc('review_reflection', { learner, q_id: questionId, note, done });
  revalidatePath('/coach/reflections');
}
