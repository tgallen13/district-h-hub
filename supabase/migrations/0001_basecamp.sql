-- District H Coach Hub: BaseCamp schema
-- Run once in the Supabase SQL editor (or with `supabase db push`).
-- Access is invite-only: a person can use the hub only once an admin has
-- created their profile. Roles live in public.profiles and are never read
-- from user-editable metadata.

create type public.hub_role as enum ('admin', 'coach', 'intern', 'candidate');
create type public.task_kind as enum ('lesson', 'film', 'homework', 'huddle');

-- People -------------------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null unique,
  full_name text not null default '',
  role public.hub_role not null,
  location text check (location in ('heights', 'oak_forest')),
  created_at timestamptz not null default now()
);

-- Curriculum ---------------------------------------------------------------
create table public.weeks (
  n int primary key check (n between 1 and 24),
  phase text not null generated always as (case when n <= 12 then 'Presenter' else 'Instructor' end) stored,
  title text not null,
  system_focus text not null default '',
  summary text not null default '',
  is_gate boolean not null default false,
  updated_at timestamptz not null default now()
);

create table public.tasks (
  id uuid primary key default gen_random_uuid(),
  week_n int not null references public.weeks (n) on delete cascade,
  sort int not null default 0,
  kind public.task_kind not null,
  title text not null,
  details text not null default '',
  created_at timestamptz not null default now()
);
create index tasks_week_idx on public.tasks (week_n, sort);

create table public.orientation_modules (
  id uuid primary key default gen_random_uuid(),
  sort int not null default 0,
  title text not null,
  summary text not null default '',
  body text not null default '',
  video_url text not null default ''
);

-- Progress -----------------------------------------------------------------
create table public.task_progress (
  user_id uuid not null references public.profiles (id) on delete cascade,
  task_id uuid not null references public.tasks (id) on delete cascade,
  submission text not null default '',
  completed_at timestamptz not null default now(),
  primary key (user_id, task_id)
);

create table public.week_signoffs (
  user_id uuid not null references public.profiles (id) on delete cascade,
  week_n int not null references public.weeks (n) on delete cascade,
  signed_by uuid not null references public.profiles (id),
  note text not null default '',
  signed_at timestamptz not null default now(),
  primary key (user_id, week_n)
);

create table public.orientation_progress (
  user_id uuid not null references public.profiles (id) on delete cascade,
  module_id uuid not null references public.orientation_modules (id) on delete cascade,
  completed_at timestamptz not null default now(),
  primary key (user_id, module_id)
);

-- Helpers (security definer so policies can call them without recursion) ---
create or replace function public.my_role() returns public.hub_role
language sql stable security definer set search_path = public as $$
  select role from public.profiles where id = auth.uid()
$$;

create or replace function public.is_staff() returns boolean
language sql stable security definer set search_path = public as $$
  select coalesce((select role in ('admin', 'coach') from public.profiles where id = auth.uid()), false)
$$;

create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select coalesce((select role = 'admin' from public.profiles where id = auth.uid()), false)
$$;

-- An intern's open week: one past their highest signed-off week, capped at 24.
-- Weeks unlock strictly in order because a coach can only sign off the open week.
create or replace function public.current_week(uid uuid) returns int
language sql stable security definer set search_path = public as $$
  select least(coalesce(max(week_n), 0) + 1, 24) from public.week_signoffs where user_id = uid
$$;

-- Row-level security -------------------------------------------------------
alter table public.profiles enable row level security;
alter table public.weeks enable row level security;
alter table public.tasks enable row level security;
alter table public.orientation_modules enable row level security;
alter table public.task_progress enable row level security;
alter table public.week_signoffs enable row level security;
alter table public.orientation_progress enable row level security;

-- profiles: see yourself; staff see everyone; only admins change people.
create policy profiles_select on public.profiles for select
  using (id = auth.uid() or public.is_staff());
create policy profiles_admin_write on public.profiles for all
  using (public.is_admin()) with check (public.is_admin());

-- weeks: interns and staff can see the 24-week outline; admins edit it.
create policy weeks_select on public.weeks for select
  using (public.is_staff() or public.my_role() = 'intern');
create policy weeks_admin_write on public.weeks for all
  using (public.is_admin()) with check (public.is_admin());

-- tasks: interns only see tasks for weeks they have unlocked.
create policy tasks_select on public.tasks for select
  using (public.is_staff() or (public.my_role() = 'intern' and week_n <= public.current_week(auth.uid())));
create policy tasks_admin_write on public.tasks for all
  using (public.is_admin()) with check (public.is_admin());

-- orientation: everyone with a profile reads; admins edit.
create policy orientation_select on public.orientation_modules for select
  using (public.my_role() is not null);
create policy orientation_admin_write on public.orientation_modules for all
  using (public.is_admin()) with check (public.is_admin());

-- task_progress: interns record their own work, only in their open week.
create policy progress_select on public.task_progress for select
  using (user_id = auth.uid() or public.is_staff());
create policy progress_insert on public.task_progress for insert
  with check (
    user_id = auth.uid()
    and public.my_role() = 'intern'
    and exists (select 1 from public.tasks t where t.id = task_id and t.week_n = public.current_week(auth.uid()) and not exists (select 1 from public.week_signoffs s where s.user_id = auth.uid() and s.week_n = t.week_n))
  );
create policy progress_update on public.task_progress for update
  using (user_id = auth.uid() and exists (select 1 from public.tasks t where t.id = task_id and t.week_n = public.current_week(auth.uid()) and not exists (select 1 from public.week_signoffs s where s.user_id = auth.uid() and s.week_n = t.week_n)))
  with check (user_id = auth.uid());
create policy progress_delete on public.task_progress for delete
  using (user_id = auth.uid() and exists (select 1 from public.tasks t where t.id = task_id and t.week_n = public.current_week(auth.uid()) and not exists (select 1 from public.week_signoffs s where s.user_id = auth.uid() and s.week_n = t.week_n)));

-- week_signoffs: staff sign off the intern's open week only; staff can undo the latest.
create policy signoff_select on public.week_signoffs for select
  using (user_id = auth.uid() or public.is_staff());
create policy signoff_insert on public.week_signoffs for insert
  with check (
    public.is_staff()
    and signed_by = auth.uid()
    and week_n = public.current_week(user_id)
    and exists (select 1 from public.profiles p where p.id = user_id and p.role = 'intern')
  );
create policy signoff_delete on public.week_signoffs for delete
  using (public.is_staff() and week_n = (select max(s.week_n) from public.week_signoffs s where s.user_id = week_signoffs.user_id));

-- orientation_progress: your own rows.
create policy oprog_select on public.orientation_progress for select
  using (user_id = auth.uid() or public.is_staff());
create policy oprog_insert on public.orientation_progress for insert
  with check (user_id = auth.uid());
create policy oprog_delete on public.orientation_progress for delete
  using (user_id = auth.uid());

-- Seed content (placeholders the admin screen replaces) --------------------
insert into public.weeks (n, title, system_focus, is_gate) values
  (1, 'Orientation and the professionalism standard', 'Slack and the HSN app', false),
  (2, 'The client journey', 'PushPress member basics', false),
  (3, 'Class ops and session notes', 'PushPress', false),
  (4, 'Presence', '', false),
  (5, 'Commonality', '', false),
  (6, 'Credibility', '', false),
  (7, 'Front of funnel', 'Lead Connector', false),
  (8, 'Call debriefs and a records spot-check', 'Lead Connector', false),
  (9, 'Call debriefs', 'Lead Connector', false),
  (10, 'Logging every call', 'Lead Connector CRM', false),
  (11, 'Supervised discovery calls', 'Lead Connector CRM', false),
  (12, 'Presenter gate', '', true),
  (13, 'The District H Floor Loop', 'Semi-Private Pro', false),
  (14, 'Reading people', 'Semi-Private Pro', false),
  (15, 'Cueing: tell, show, do', 'Semi-Private Pro', false),
  (16, 'Archetypes on the floor', '', false),
  (17, 'Speaker School', '', false),
  (18, 'Room reading and full-session ops', '', false),
  (19, 'The coach side of the HSN app', 'HSN app', false),
  (20, 'Certification complete', '', false),
  (21, 'Recovery and readiness data', '', false),
  (22, 'Records hygiene audit', 'PushPress', false),
  (23, 'CF-L2', '', false),
  (24, 'Instructor gate', '', true);

insert into public.tasks (week_n, sort, kind, title, details)
select w.n, t.sort, t.kind::public.task_kind, t.title, t.details
from public.weeks w
cross join (values
  (1, 'lesson', 'Monday lesson', ''),
  (2, 'lesson', 'Tuesday lesson', ''),
  (3, 'lesson', 'Wednesday lesson', ''),
  (4, 'lesson', 'Thursday lesson', ''),
  (5, 'lesson', 'Friday lesson', ''),
  (6, 'film', 'Filmed rep', 'Paste a link to this week''s filmed rep for review.'),
  (7, 'homework', 'Homework', 'Required before your coach can sign off the week.'),
  (8, 'huddle', 'Huddle', 'Bring one thing you noticed on the floor.')
) as t (sort, kind, title, details);

insert into public.orientation_modules (sort, title, summary) values
  (1, 'Vision', 'Where District H is going'),
  (2, 'Mission', 'What we do every day and why'),
  (3, 'Core values', 'What we hire and coach for'),
  (4, 'Business model', 'How the gym works and how you fit'),
  (5, 'Journey of a Career Coach', 'The five levels, from Presenter to Professional'),
  (6, 'Our commitment to you', 'Stable income, benefits, time off, and a real pathway');
