'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { requireRole } from '@/lib/auth';

// Row-level security decides who can tick items (staff, active runs only) and
// who can change content or runs (admins), so these actions stay thin.

function clean(v: FormDataEntryValue | null, max = 2000): string {
  return String(v ?? '').trim().slice(0, max);
}
function back(slug: string, runId?: string, hash = '') {
  revalidatePath(`/playbooks/${slug}`);
  redirect(`/playbooks/${slug}${runId ? `?run=${runId}` : ''}${hash}`);
}

export async function toggleCheck(formData: FormData) {
  const me = await requireRole(['admin', 'coach']);
  const slug = clean(formData.get('slug'), 80);
  const runId = clean(formData.get('runId'), 80);
  const itemId = clean(formData.get('itemId'), 80);
  const supabase = await createClient();
  if (formData.get('done') === '1') await supabase.from('playbook_checks').delete().eq('run_id', runId).eq('item_id', itemId);
  else await supabase.from('playbook_checks').insert({ run_id: runId, item_id: itemId, done_by: me.id });
  back(slug, runId, `#s-${clean(formData.get('sectionId'), 80)}`);
}

export async function startRun(formData: FormData) {
  const me = await requireRole(['admin']);
  const slug = clean(formData.get('slug'), 80);
  const name = clean(formData.get('name'), 120) || 'New opening';
  const date = clean(formData.get('target_date'), 20);
  const supabase = await createClient();
  const { data } = await supabase
    .from('playbook_runs')
    .insert({ playbook: slug, name, target_date: date || null, created_by: me.id })
    .select('id')
    .single();
  back(slug, (data as { id: string } | null)?.id);
}

export async function archiveRun(formData: FormData) {
  await requireRole(['admin']);
  const slug = clean(formData.get('slug'), 80);
  const runId = clean(formData.get('runId'), 80);
  const supabase = await createClient();
  await supabase.from('playbook_runs').update({ archived: formData.get('archived') === '1' }).eq('id', runId);
  back(slug, runId);
}

export async function saveSection(formData: FormData) {
  await requireRole(['admin']);
  const slug = clean(formData.get('slug'), 80);
  const id = clean(formData.get('id'), 80);
  const row = {
    playbook: slug,
    title: clean(formData.get('title'), 200) || 'Untitled phase',
    timing: clean(formData.get('timing'), 120),
    body: clean(formData.get('body'), 40000),
    sort: Number(formData.get('sort')) || 0,
  };
  const supabase = await createClient();
  if (id) await supabase.from('playbook_sections').update(row).eq('id', id);
  else await supabase.from('playbook_sections').insert(row);
  back(slug, clean(formData.get('runId'), 80) || undefined, id ? `#s-${id}` : '');
}

export async function saveItem(formData: FormData) {
  await requireRole(['admin']);
  const slug = clean(formData.get('slug'), 80);
  const id = clean(formData.get('id'), 80);
  const sectionId = clean(formData.get('sectionId'), 80);
  const row = { section_id: sectionId, text: clean(formData.get('text'), 500) || 'Untitled step', owner: clean(formData.get('owner'), 80), sort: Number(formData.get('sort')) || 0 };
  const supabase = await createClient();
  if (id) await supabase.from('playbook_items').update(row).eq('id', id);
  else await supabase.from('playbook_items').insert(row);
  back(slug, clean(formData.get('runId'), 80) || undefined, `#s-${sectionId}`);
}

export async function deleteItem(formData: FormData) {
  await requireRole(['admin']);
  const slug = clean(formData.get('slug'), 80);
  const supabase = await createClient();
  await supabase.from('playbook_items').delete().eq('id', clean(formData.get('id'), 80));
  back(slug, clean(formData.get('runId'), 80) || undefined, `#s-${clean(formData.get('sectionId'), 80)}`);
}
