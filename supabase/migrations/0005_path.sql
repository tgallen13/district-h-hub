-- My Path: the Trainer and Coach phases that follow BaseCamp.
-- Trainer is six monthly units (1-6), Coach is eight quarterly units (7-14).
-- A coach can open My Path only after their BaseCamp week 24 (the Instructor
-- gate) is signed off, or when an admin grants access to a coach who was
-- hired before BaseCamp existed. Units unlock in order: a unit opens when the
-- one before it is signed off by an admin or by a coach who has already
-- completed that unit themselves.

alter table public.profiles add column if not exists path_access boolean not null default false;

create table public.path_units (
  n int primary key check (n between 1 and 14),
  phase text not null generated always as (case when n <= 6 then 'Trainer' else 'Coach' end) stored,
  label text not null default '',
  title text not null,
  focus text not null default '',
  summary text not null default '',
  reading text not null default '',
  is_gate boolean not null default false,
  updated_at timestamptz not null default now()
);

create table public.path_tasks (
  id uuid primary key default gen_random_uuid(),
  unit_n int not null references public.path_units (n) on delete cascade,
  sort int not null default 0,
  kind public.task_kind not null,
  title text not null,
  details text not null default '',
  body text not null default '',
  created_at timestamptz not null default now()
);
create index path_tasks_unit_idx on public.path_tasks (unit_n, sort);

create table public.path_progress (
  user_id uuid not null references public.profiles (id) on delete cascade,
  task_id uuid not null references public.path_tasks (id) on delete cascade,
  submission text not null default '',
  completed_at timestamptz not null default now(),
  primary key (user_id, task_id)
);

create table public.path_signoffs (
  user_id uuid not null references public.profiles (id) on delete cascade,
  unit_n int not null references public.path_units (n) on delete cascade,
  signed_by uuid not null references public.profiles (id),
  note text not null default '',
  signed_at timestamptz not null default now(),
  primary key (user_id, unit_n)
);

-- Is this person on My Path? A coach whose Instructor gate is signed off, or
-- one an admin has let in.
create or replace function public.on_path(uid uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select coalesce((
    select p.role = 'coach' and (p.path_access or exists (select 1 from public.week_signoffs s where s.user_id = uid and s.week_n = 24))
    from public.profiles p where p.id = uid
  ), false)
$$;

create or replace function public.current_unit(uid uuid) returns int
language sql stable security definer set search_path = public as $$
  select least(coalesce(max(unit_n), 0) + 1, 14) from public.path_signoffs where user_id = uid
$$;

create or replace function public.finished_unit(uid uuid, u int) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.path_signoffs where user_id = uid and unit_n = u)
$$;

alter table public.path_units enable row level security;
alter table public.path_tasks enable row level security;
alter table public.path_progress enable row level security;
alter table public.path_signoffs enable row level security;

-- The outline is visible to staff; only admins edit it.
create policy path_units_select on public.path_units for select using (public.is_staff());
create policy path_units_admin_write on public.path_units for all using (public.is_admin()) with check (public.is_admin());

-- A coach sees a unit's work once it's open to them, or once they've finished
-- it (so a mentor can review someone else's work in a unit they've done).
create policy path_tasks_select on public.path_tasks for select using (
  public.is_admin()
  or (public.on_path(auth.uid()) and (unit_n <= public.current_unit(auth.uid()) or public.finished_unit(auth.uid(), unit_n)))
);
create policy path_tasks_admin_write on public.path_tasks for all using (public.is_admin()) with check (public.is_admin());

-- Progress: your own, only in your open unit that isn't signed off yet.
create policy path_progress_select on public.path_progress for select using (user_id = auth.uid() or public.is_staff());
create policy path_progress_insert on public.path_progress for insert with check (
  user_id = auth.uid() and public.on_path(auth.uid())
  and exists (select 1 from public.path_tasks t where t.id = task_id and t.unit_n = public.current_unit(auth.uid()) and not public.finished_unit(auth.uid(), t.unit_n))
);
create policy path_progress_update on public.path_progress for update using (
  user_id = auth.uid()
  and exists (select 1 from public.path_tasks t where t.id = task_id and t.unit_n = public.current_unit(auth.uid()) and not public.finished_unit(auth.uid(), t.unit_n))
) with check (user_id = auth.uid());
create policy path_progress_delete on public.path_progress for delete using (
  user_id = auth.uid()
  and exists (select 1 from public.path_tasks t where t.id = task_id and t.unit_n = public.current_unit(auth.uid()) and not public.finished_unit(auth.uid(), t.unit_n))
);

-- Sign-offs: never your own; the person's open unit only; by an admin or by a
-- coach who has finished that unit. Undo: the latest one, by an admin or the
-- person who signed it.
create policy path_signoff_select on public.path_signoffs for select using (user_id = auth.uid() or public.is_staff());
create policy path_signoff_insert on public.path_signoffs for insert with check (
  signed_by = auth.uid()
  and user_id <> auth.uid()
  and public.on_path(user_id)
  and unit_n = public.current_unit(user_id)
  and not public.finished_unit(user_id, unit_n)
  and (public.is_admin() or (public.my_role() = 'coach' and public.finished_unit(auth.uid(), unit_n)))
);
create policy path_signoff_delete on public.path_signoffs for delete using (
  (public.is_admin() or signed_by = auth.uid())
  and unit_n = (select max(s.unit_n) from public.path_signoffs s where s.user_id = path_signoffs.user_id)
);
