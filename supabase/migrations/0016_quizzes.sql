-- End-of-lesson quizzes.
-- Each daily lesson (BaseCamp task or My Path task) can carry multiple-choice
-- questions and short-answer reflections. A lesson is only marked done once
-- every multiple-choice answer is right (retries are unlimited) and every
-- reflection has an answer. Reflections aren't graded; leadership reads them,
-- marks them reviewed and can leave a note the learner sees.
-- Answer keys live in their own table that only admins can read, and grading
-- happens in submit_quiz() on the server, so the key never reaches a browser.

create table public.quiz_questions (
  id uuid primary key default gen_random_uuid(),
  task_id uuid references public.tasks (id) on delete cascade,
  path_task_id uuid references public.path_tasks (id) on delete cascade,
  sort int not null default 0,
  kind text not null check (kind in ('mc', 'short')),
  prompt text not null,
  choices jsonb not null default '[]'::jsonb,
  check (num_nonnulls(task_id, path_task_id) = 1),
  check (kind = 'short' or jsonb_array_length(choices) between 2 and 6)
);
create index quiz_questions_task_idx on public.quiz_questions (task_id, sort);
create index quiz_questions_path_idx on public.quiz_questions (path_task_id, sort);

create table public.quiz_keys (
  question_id uuid primary key references public.quiz_questions (id) on delete cascade,
  correct int not null check (correct >= 0)
);

-- A pass is recorded the first time someone gets every multiple-choice
-- question right with all reflections filled in.
create table public.quiz_passes (
  user_id uuid not null references public.profiles (id) on delete cascade,
  task_id uuid references public.tasks (id) on delete cascade,
  path_task_id uuid references public.path_tasks (id) on delete cascade,
  passed_at timestamptz not null default now(),
  check (num_nonnulls(task_id, path_task_id) = 1)
);
create unique index quiz_passes_task_uq on public.quiz_passes (user_id, task_id) where task_id is not null;
create unique index quiz_passes_path_uq on public.quiz_passes (user_id, path_task_id) where path_task_id is not null;

-- Every try, so the learner sees which questions to look at again (never the
-- right answer) and leadership can see how many tries it took.
create table public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  task_id uuid references public.tasks (id) on delete cascade,
  path_task_id uuid references public.path_tasks (id) on delete cascade,
  answers jsonb not null default '{}'::jsonb,
  correct int not null,
  total int not null,
  wrong uuid[] not null default '{}',
  at timestamptz not null default now(),
  check (num_nonnulls(task_id, path_task_id) = 1)
);
create index quiz_attempts_user_idx on public.quiz_attempts (user_id, at desc);

create table public.quiz_responses (
  user_id uuid not null references public.profiles (id) on delete cascade,
  question_id uuid not null references public.quiz_questions (id) on delete cascade,
  answer text not null,
  submitted_at timestamptz not null default now(),
  reviewed_by uuid references public.profiles (id),
  reviewed_at timestamptz,
  comment text not null default '',
  primary key (user_id, question_id)
);
create index quiz_responses_review_idx on public.quiz_responses (reviewed_at, submitted_at);

alter table public.quiz_questions enable row level security;
alter table public.quiz_keys enable row level security;
alter table public.quiz_passes enable row level security;
alter table public.quiz_attempts enable row level security;
alter table public.quiz_responses enable row level security;

-- Questions are visible wherever their lesson is (the lesson tables' own
-- policies decide that). Only admins write.
create policy quiz_questions_select on public.quiz_questions for select using (
  exists (select 1 from public.tasks t where t.id = task_id)
  or exists (select 1 from public.path_tasks p where p.id = path_task_id)
);
create policy quiz_questions_admin_write on public.quiz_questions for all using (public.is_admin()) with check (public.is_admin());
create policy quiz_keys_admin on public.quiz_keys for all using (public.is_admin()) with check (public.is_admin());

-- Passes, attempts and reflections are written only by submit_quiz().
create policy quiz_passes_select on public.quiz_passes for select using (user_id = auth.uid() or public.is_staff());
create policy quiz_attempts_select on public.quiz_attempts for select using (user_id = auth.uid() or public.is_staff());
create policy quiz_responses_select on public.quiz_responses for select using (user_id = auth.uid() or public.is_staff());

-- Does this lesson have a multiple-choice quiz, and has this person passed it?
create or replace function public.quiz_cleared(uid uuid, t_id uuid, p_id uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select not exists (
      select 1 from public.quiz_questions q
      where q.task_id is not distinct from t_id and q.path_task_id is not distinct from p_id
    )
    or exists (
      select 1 from public.quiz_passes s
      where s.user_id = uid and s.task_id is not distinct from t_id and s.path_task_id is not distinct from p_id
    )
$$;

-- Every quiz in a week (or unit) passed?
create or replace function public.week_quizzes_cleared(uid uuid, w int) returns boolean
language sql stable security definer set search_path = public as $$
  select not exists (select 1 from public.tasks t where t.week_n = w and not public.quiz_cleared(uid, t.id, null))
$$;
create or replace function public.unit_quizzes_cleared(uid uuid, u int) returns boolean
language sql stable security definer set search_path = public as $$
  select not exists (select 1 from public.path_tasks t where t.unit_n = u and not public.quiz_cleared(uid, null, t.id))
$$;

-- Marking a lesson done needs its quiz passed.
drop policy progress_insert on public.task_progress;
create policy progress_insert on public.task_progress for insert
  with check (
    user_id = auth.uid()
    and public.my_role() = 'intern'
    and exists (select 1 from public.tasks t where t.id = task_id and t.week_n = public.current_week(auth.uid()) and not exists (select 1 from public.week_signoffs s where s.user_id = auth.uid() and s.week_n = t.week_n))
    and public.quiz_cleared(auth.uid(), task_id, null)
  );
drop policy path_progress_insert on public.path_progress;
create policy path_progress_insert on public.path_progress for insert with check (
  user_id = auth.uid() and public.on_path(auth.uid())
  and exists (select 1 from public.path_tasks t where t.id = task_id and t.unit_n = public.current_unit(auth.uid()) and not public.finished_unit(auth.uid(), t.unit_n))
  and public.quiz_cleared(auth.uid(), null, task_id)
);

-- A week or unit can't be signed off until every quiz in it is passed.
drop policy signoff_insert on public.week_signoffs;
create policy signoff_insert on public.week_signoffs for insert
  with check (
    public.is_staff()
    and signed_by = auth.uid()
    and week_n = public.current_week(user_id)
    and exists (select 1 from public.profiles p where p.id = user_id and p.role = 'intern')
    and public.week_quizzes_cleared(user_id, week_n)
  );
drop policy path_signoff_insert on public.path_signoffs;
create policy path_signoff_insert on public.path_signoffs for insert with check (
  signed_by = auth.uid()
  and user_id <> auth.uid()
  and public.on_path(user_id)
  and unit_n = public.current_unit(user_id)
  and not public.finished_unit(user_id, unit_n)
  and (public.is_admin() or (public.my_role() = 'coach' and public.finished_unit(auth.uid(), unit_n)))
  and public.unit_quizzes_cleared(user_id, unit_n)
);

-- Grade a quiz. answers is {"<question id>": <choice index or reflection text>}.
-- Returns {ok, passed, correct, total, wrong[], error}.
create or replace function public.submit_quiz(t_id uuid, p_id uuid, answers jsonb) returns jsonb
language plpgsql volatile security definer set search_path = public as $$
declare
  uid uuid := auth.uid();
  q record;
  a text;
  n_total int := 0;
  n_right int := 0;
  missed uuid[] := '{}';
  missing_reflection boolean := false;
  is_passed boolean;
begin
  if uid is null or num_nonnulls(t_id, p_id) <> 1 then
    return jsonb_build_object('ok', false, 'error', 'input');
  end if;

  -- Only your own open week or unit.
  if t_id is not null then
    if not (public.my_role() = 'intern' and exists (
      select 1 from public.tasks t where t.id = t_id and t.week_n = public.current_week(uid)
        and not exists (select 1 from public.week_signoffs s where s.user_id = uid and s.week_n = t.week_n))) then
      return jsonb_build_object('ok', false, 'error', 'locked');
    end if;
  else
    if not (public.on_path(uid) and exists (
      select 1 from public.path_tasks t where t.id = p_id and t.unit_n = public.current_unit(uid)
        and not public.finished_unit(uid, t.unit_n))) then
      return jsonb_build_object('ok', false, 'error', 'locked');
    end if;
  end if;

  for q in
    select qq.id, qq.kind, k.correct from public.quiz_questions qq
    left join public.quiz_keys k on k.question_id = qq.id
    where qq.task_id is not distinct from t_id and qq.path_task_id is not distinct from p_id
    order by qq.sort
  loop
    a := btrim(coalesce(answers ->> q.id::text, ''));
    if q.kind = 'short' then
      if a = '' then
        missing_reflection := true;
      else
        insert into public.quiz_responses (user_id, question_id, answer, submitted_at)
        values (uid, q.id, left(a, 4000), now())
        on conflict (user_id, question_id) do update
          set answer = excluded.answer, submitted_at = now(),
              reviewed_at = case when quiz_responses.answer = excluded.answer then quiz_responses.reviewed_at end,
              reviewed_by = case when quiz_responses.answer = excluded.answer then quiz_responses.reviewed_by end;
      end if;
    else
      n_total := n_total + 1;
      if a ~ '^[0-9]{1,2}$' and q.correct is not null and a::int = q.correct then
        n_right := n_right + 1;
      else
        missed := missed || q.id;
      end if;
    end if;
  end loop;

  if n_total = 0 and not exists (
    select 1 from public.quiz_questions qq where qq.task_id is not distinct from t_id and qq.path_task_id is not distinct from p_id) then
    return jsonb_build_object('ok', false, 'error', 'noquiz');
  end if;

  insert into public.quiz_attempts (user_id, task_id, path_task_id, answers, correct, total, wrong)
  values (uid, t_id, p_id, coalesce(answers, '{}'::jsonb), n_right, n_total, missed);

  is_passed := n_right = n_total and not missing_reflection;
  if is_passed then
    insert into public.quiz_passes (user_id, task_id, path_task_id) values (uid, t_id, p_id) on conflict do nothing;
    if t_id is not null then
      insert into public.task_progress (user_id, task_id, submission) values (uid, t_id, '') on conflict do nothing;
    else
      insert into public.path_progress (user_id, task_id, submission) values (uid, p_id, '') on conflict do nothing;
    end if;
  end if;

  return jsonb_build_object('ok', true, 'passed', is_passed, 'correct', n_right, 'total', n_total,
    'wrong', to_jsonb(missed), 'error', case when missing_reflection then 'reflection' end);
end;
$$;

-- Leadership marks a reflection reviewed, with an optional note back.
create or replace function public.review_reflection(learner uuid, q_id uuid, note text, done boolean) returns boolean
language plpgsql volatile security definer set search_path = public as $$
begin
  if not public.is_staff() then return false; end if;
  update public.quiz_responses
     set reviewed_at = case when done then now() end,
         reviewed_by = case when done then auth.uid() end,
         comment = left(coalesce(note, ''), 2000)
   where user_id = learner and question_id = q_id;
  return found;
end;
$$;

revoke execute on function public.submit_quiz(uuid, uuid, jsonb) from public;
revoke execute on function public.review_reflection(uuid, uuid, text, boolean) from public;
grant execute on function public.submit_quiz(uuid, uuid, jsonb) to authenticated;
grant execute on function public.review_reflection(uuid, uuid, text, boolean) to authenticated;
