-- Playbooks: operational guides for staff, starting with the Opening
-- Playbook for launching a new location. A playbook is a set of phases
-- (sections), each with a reading and a checklist. A "run" is one real use
-- of a playbook (for example, "Location 3"), and checklist ticks are kept
-- per run so the team can execute an opening from the hub.

create table public.playbooks (
  slug text primary key check (slug ~ '^[a-z0-9-]+$'),
  title text not null,
  summary text not null default '',
  sort int not null default 0,
  updated_at timestamptz not null default now()
);

create table public.playbook_sections (
  id uuid primary key default gen_random_uuid(),
  playbook text not null references public.playbooks (slug) on delete cascade,
  sort int not null default 0,
  title text not null,
  timing text not null default '',
  body text not null default ''
);
create index playbook_sections_idx on public.playbook_sections (playbook, sort);

create table public.playbook_items (
  id uuid primary key default gen_random_uuid(),
  section_id uuid not null references public.playbook_sections (id) on delete cascade,
  sort int not null default 0,
  text text not null,
  owner text not null default ''
);
create index playbook_items_idx on public.playbook_items (section_id, sort);

create table public.playbook_runs (
  id uuid primary key default gen_random_uuid(),
  playbook text not null references public.playbooks (slug) on delete cascade,
  name text not null,
  target_date date,
  archived boolean not null default false,
  created_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now()
);

create table public.playbook_checks (
  run_id uuid not null references public.playbook_runs (id) on delete cascade,
  item_id uuid not null references public.playbook_items (id) on delete cascade,
  done_by uuid references public.profiles (id) on delete set null,
  done_at timestamptz not null default now(),
  primary key (run_id, item_id)
);

alter table public.playbooks enable row level security;
alter table public.playbook_sections enable row level security;
alter table public.playbook_items enable row level security;
alter table public.playbook_runs enable row level security;
alter table public.playbook_checks enable row level security;

-- Staff (admins and coaches) read everything; admins edit content and runs;
-- any staff member can tick items on an active run.
create policy playbooks_select on public.playbooks for select using (public.is_staff());
create policy playbooks_admin on public.playbooks for all using (public.is_admin()) with check (public.is_admin());
create policy pb_sections_select on public.playbook_sections for select using (public.is_staff());
create policy pb_sections_admin on public.playbook_sections for all using (public.is_admin()) with check (public.is_admin());
create policy pb_items_select on public.playbook_items for select using (public.is_staff());
create policy pb_items_admin on public.playbook_items for all using (public.is_admin()) with check (public.is_admin());
create policy pb_runs_select on public.playbook_runs for select using (public.is_staff());
create policy pb_runs_admin on public.playbook_runs for all using (public.is_admin()) with check (public.is_admin());
create policy pb_checks_select on public.playbook_checks for select using (public.is_staff());
create policy pb_checks_insert on public.playbook_checks for insert with check (
  public.is_staff() and done_by = auth.uid()
  and exists (select 1 from public.playbook_runs r where r.id = run_id and not r.archived)
);
create policy pb_checks_delete on public.playbook_checks for delete using (
  public.is_staff() and exists (select 1 from public.playbook_runs r where r.id = run_id and not r.archived)
);
