'use server';

import { headers } from 'next/headers';
import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { createAdminClient, createClient } from '@/lib/supabase/server';
import { requireRole, type Role } from '@/lib/auth';
import { isEmail, isHttpUrl } from '@/lib/validate';

const ROLES: Role[] = ['admin', 'coach', 'intern', 'candidate'];
const KINDS = ['lesson', 'film', 'homework', 'huddle'];

function clean(v: FormDataEntryValue | null, max = 2000): string {
  return String(v ?? '').trim().slice(0, max);
}
function location(v: FormDataEntryValue | null): 'heights' | 'oak_forest' | null {
  const s = String(v ?? '');
  return s === 'heights' || s === 'oak_forest' ? s : null;
}

// People ---------------------------------------------------------------------

export async function addPerson(formData: FormData) {
  await requireRole(['admin']);
  const email = clean(formData.get('email'), 320).toLowerCase();
  const fullName = clean(formData.get('full_name'), 200);
  const role = String(formData.get('role')) as Role;
  if (!isEmail(email) || !ROLES.includes(role)) redirect('/admin?e=input');

  const admin = createAdminClient();
  const h = await headers();
  const host = h.get('x-forwarded-host') ?? h.get('host') ?? 'basecamp.districthsf.com';
  const proto = h.get('x-forwarded-proto') ?? 'https';

  // New people get an invite email. Someone who already has a login just gets a role.
  let userId: string | null = null;
  let invited = false;
  const { data: inv, error: invErr } = await admin.auth.admin.inviteUserByEmail(email, {
    redirectTo: `${proto}://${host}/auth/confirm`,
    data: { full_name: fullName },
  });
  if (inv?.user) {
    userId = inv.user.id;
    invited = true;
  } else if (invErr) {
    for (let page = 1; page <= 20 && !userId; page++) {
      const { data } = await admin.auth.admin.listUsers({ page, perPage: 200 });
      const found = data?.users.find((u) => u.email?.toLowerCase() === email);
      if (found) userId = found.id;
      if (!data || data.users.length < 200) break;
    }
  }
  if (!userId) redirect('/admin?e=invite');

  const { error } = await admin
    .from('profiles')
    .upsert({ id: userId, email, full_name: fullName, role, location: location(formData.get('location')) });
  if (error) redirect('/admin?e=save');
  revalidatePath('/admin');
  redirect(`/admin?ok=${invited ? 'invited' : 'added'}`);
}

export async function updatePerson(formData: FormData) {
  const me = await requireRole(['admin']);
  const id = String(formData.get('id'));
  const role = String(formData.get('role')) as Role;
  if (!ROLES.includes(role)) redirect('/admin?e=input');
  if (id === me.id && role !== 'admin') redirect('/admin?e=self');
  const supabase = await createClient();
  await supabase
    .from('profiles')
    .update({ role, full_name: clean(formData.get('full_name'), 200), location: location(formData.get('location')) })
    .eq('id', id);
  revalidatePath('/admin');
  redirect('/admin?ok=saved');
}

export async function removePerson(formData: FormData) {
  const me = await requireRole(['admin']);
  const id = String(formData.get('id'));
  if (id === me.id) redirect('/admin?e=self');
  // Removing the profile ends their access. Their login stays, so they can be re-added later.
  const supabase = await createClient();
  await supabase.from('profiles').delete().eq('id', id);
  revalidatePath('/admin');
  redirect('/admin?ok=removed');
}

// Curriculum -----------------------------------------------------------------

export async function saveWeek(formData: FormData) {
  await requireRole(['admin']);
  const n = Number(formData.get('n'));
  const supabase = await createClient();
  await supabase
    .from('weeks')
    .update({
      title: clean(formData.get('title'), 200) || `Week ${n}`,
      system_focus: clean(formData.get('system_focus'), 200),
      summary: clean(formData.get('summary'), 4000),
      is_gate: formData.get('is_gate') === 'on',
      updated_at: new Date().toISOString(),
    })
    .eq('n', n);
  revalidatePath('/admin/weeks');
  redirect(`/admin/weeks/${n}?ok=week`);
}

export async function saveTask(formData: FormData) {
  await requireRole(['admin']);
  const n = Number(formData.get('week_n'));
  const id = String(formData.get('id') ?? '');
  const kind = String(formData.get('kind'));
  const row = {
    week_n: n,
    kind: KINDS.includes(kind) ? kind : 'lesson',
    title: clean(formData.get('title'), 200) || 'Untitled',
    details: clean(formData.get('details'), 4000),
    body: clean(formData.get('body'), 40000),
    sort: Number(formData.get('sort')) || 0,
  };
  const supabase = await createClient();
  if (id) await supabase.from('tasks').update(row).eq('id', id);
  else await supabase.from('tasks').insert(row);
  revalidatePath(`/admin/weeks/${n}`);
  redirect(`/admin/weeks/${n}?ok=task`);
}

export async function deleteTask(formData: FormData) {
  await requireRole(['admin']);
  const n = Number(formData.get('week_n'));
  const supabase = await createClient();
  await supabase.from('tasks').delete().eq('id', String(formData.get('id')));
  revalidatePath(`/admin/weeks/${n}`);
  redirect(`/admin/weeks/${n}?ok=deleted`);
}

// Orientation ----------------------------------------------------------------

export async function saveModule(formData: FormData) {
  await requireRole(['admin']);
  const id = String(formData.get('id') ?? '');
  const video = clean(formData.get('video_url'), 1000);
  const row = {
    title: clean(formData.get('title'), 200) || 'Untitled',
    summary: clean(formData.get('summary'), 300),
    body: clean(formData.get('body'), 20000),
    interns_only: formData.get('interns_only') === 'on',
    video_url: isHttpUrl(video) ? video : '',
    sort: Number(formData.get('sort')) || 0,
  };
  const supabase = await createClient();
  if (id) await supabase.from('orientation_modules').update(row).eq('id', id);
  else await supabase.from('orientation_modules').insert(row);
  revalidatePath('/admin/orientation');
  redirect('/admin/orientation?ok=saved');
}

export async function deleteModule(formData: FormData) {
  await requireRole(['admin']);
  const supabase = await createClient();
  await supabase.from('orientation_modules').delete().eq('id', String(formData.get('id')));
  revalidatePath('/admin/orientation');
  redirect('/admin/orientation?ok=deleted');
}
