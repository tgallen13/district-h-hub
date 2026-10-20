// Tests for end-of-lesson quizzes: answer keys stay hidden, grading needs
// 100% on multiple choice plus reflections, and lessons/weeks stay locked
// until the quiz is passed.
// Run: node supabase/tests/quiz.test.mjs
import { PGlite } from '@electric-sql/pglite';
import { readFileSync } from 'fs';

const db = new PGlite();
await db.exec(`
  create schema auth;
  create table auth.users (id uuid primary key);
  create function auth.uid() returns uuid language sql stable as $$ select nullif(current_setting('request.uid', true), '')::uuid $$;
  create role authenticated nologin;
  grant usage on schema public, auth to authenticated;
`);
for (const f of ['0001_basecamp', '0005_path', '0016_quizzes']) await db.exec(readFileSync(new URL(`../migrations/${f}.sql`, import.meta.url), 'utf8'));
await db.exec(`
  grant all on all tables in schema public to authenticated;
  grant execute on all functions in schema public to authenticated;
  grant execute on all functions in schema auth to authenticated;
`);

const A = '00000000-0000-0000-0000-00000000000a', C = '00000000-0000-0000-0000-00000000000c',
  I = '00000000-0000-0000-0000-000000000001', J = '00000000-0000-0000-0000-000000000002', G = '00000000-0000-0000-0000-000000000011';
await db.exec(`
  insert into auth.users values ('${A}'),('${C}'),('${I}'),('${J}'),('${G}');
  insert into public.profiles (id,email,role,path_access) values ('${A}','a@x','admin',false),('${C}','c@x','coach',false),('${I}','i@x','intern',false),('${J}','j@x','intern',false),('${G}','g@x','coach',true);
  insert into public.tasks (week_n, sort, kind, title) values (1,1,'lesson','Quiz lesson'),(1,2,'lesson','Plain lesson'),(2,1,'lesson','Week 2 lesson');
  insert into public.path_units (n, title) select n, 'Unit ' || n from generate_series(1,14) n;
  insert into public.path_tasks (unit_n, sort, kind, title) values (1,1,'lesson','Path lesson');
`);
const id = async (sql) => (await db.query(sql)).rows[0].id;
const T1 = await id(`select id from public.tasks where title='Quiz lesson'`);
const T2 = await id(`select id from public.tasks where title='Plain lesson'`);
const W2 = await id(`select id from public.tasks where title='Week 2 lesson'`);
const P1 = await id(`select id from public.path_tasks where title='Path lesson'`);
const q = async (task, col, sort, kind, correct) => {
  const qid = await id(`insert into public.quiz_questions (${col}, sort, kind, prompt, choices) values ('${task}', ${sort}, '${kind}', 'Q${sort}', '${kind === 'mc' ? '["a","b","c","d"]' : '[]'}') returning id`);
  if (kind === 'mc') await db.exec(`insert into public.quiz_keys values ('${qid}', ${correct})`);
  return qid;
};
const m1 = await q(T1, 'task_id', 1, 'mc', 2), m2 = await q(T1, 'task_id', 2, 'mc', 0), s1 = await q(T1, 'task_id', 3, 'short');
const w2 = await q(W2, 'task_id', 1, 'mc', 1);
const pm = await q(P1, 'path_task_id', 1, 'mc', 3), ps = await q(P1, 'path_task_id', 2, 'short');

let pass = 0, fail = 0;
async function as(uid, sql, params) {
  await db.exec(`reset role; select set_config('request.uid', '${uid}', false); set role authenticated;`);
  try { const r = await db.query(sql, params); return { ok: true, rows: r.rows, n: r.affectedRows }; }
  catch (e) { return { ok: false, err: e.message }; }
  finally { await db.exec('reset role;'); }
}
function check(name, cond, info) { if (cond) { pass++; console.log('PASS', name); } else { fail++; console.log('FAIL', name, JSON.stringify(info)); } }
const submit = (uid, t, p, ans) => as(uid, `select public.submit_quiz($1, $2, $3::jsonb) r`, [t, p, JSON.stringify(ans)]);
const res = (r) => (r.ok ? r.rows[0].r : { err: r.err });

let r;
r = await as(I, `select count(*) c from public.quiz_keys`);
check('intern cannot read answer keys', r.ok && Number(r.rows[0].c) === 0, r);
r = await as(C, `select count(*) c from public.quiz_keys`);
check('coach cannot read answer keys', r.ok && Number(r.rows[0].c) === 0, r);
r = await as(I, `select count(*) c from public.quiz_questions`);
check('intern sees questions for week 1 only', r.ok && Number(r.rows[0].c) === 3, r);

r = await as(I, `insert into public.task_progress (user_id, task_id) values ('${I}','${T1}')`);
check('cannot mark a quiz lesson done without passing', !r.ok, r);
r = await as(I, `insert into public.task_progress (user_id, task_id) values ('${I}','${T2}')`);
check('lesson without a quiz still marks done', r.ok, r);
r = await as(I, `insert into public.quiz_passes (user_id, task_id) values ('${I}','${T1}')`);
check('cannot write a pass directly', !r.ok, r);

r = res(await submit(I, T1, null, { [m1]: 2, [m2]: 1, [s1]: 'I rushed my cues on Tuesday.' }));
check('one wrong answer does not pass', r.ok && !r.passed && r.correct === 1 && r.total === 2 && r.wrong.length === 1 && r.wrong[0] === m2, r);
r = res(await submit(I, T1, null, { [m1]: 2, [m2]: 0, [s1]: '   ' }));
check('all right but blank reflection does not pass', r.ok && !r.passed && r.error === 'reflection', r);
r = res(await submit(I, W2, null, { [w2]: 1 }));
check('cannot take a quiz in a locked week', r.ok === false && r.error === 'locked', r);
r = res(await submit(I, T1, null, { [m1]: '2', [m2]: 0, [s1]: 'I rushed my cues on Tuesday.' }));
check('100% with a reflection passes', r.ok && r.passed && r.correct === 2, r);
r = await as(I, `select count(*) c from public.task_progress where user_id='${I}' and task_id='${T1}'`);
check('passing marks the lesson done', r.ok && Number(r.rows[0].c) === 1, r);
r = await as(I, `select count(*) c from public.quiz_attempts where user_id='${I}'`);
check('every try is recorded (3)', r.ok && Number(r.rows[0].c) === 3, r);
r = await as(I, `delete from public.task_progress where user_id='${I}' and task_id='${T1}'`);
r = await as(I, `insert into public.task_progress (user_id, task_id) values ('${I}','${T1}')`);
check('after passing the lesson can be re-marked done', r.ok, r);

r = await as(J, `select count(*) c from public.quiz_responses`);
check('another intern cannot read reflections', r.ok && Number(r.rows[0].c) === 0, r);
r = await as(C, `select answer from public.quiz_responses where user_id='${I}'`);
check('coach reads the reflection', r.ok && r.rows[0]?.answer === 'I rushed my cues on Tuesday.', r);
r = await as(I, `update public.quiz_responses set comment='self review' where user_id='${I}'`);
check('intern cannot write a review note', r.ok && r.n === 0, r);
r = await as(I, `select public.review_reflection('${I}','${s1}','nice',true) r`);
check('intern cannot review via function', r.ok && r.rows[0].r === false, r);
r = await as(C, `select public.review_reflection('${I}','${s1}','Good catch. Slow the first cue down.',true) r`);
check('coach marks reviewed with a note', r.ok && r.rows[0].r === true, r);
r = await as(I, `select comment, reviewed_at is not null rv from public.quiz_responses where user_id='${I}'`);
check('intern sees the note', r.ok && r.rows[0].rv && r.rows[0].comment.startsWith('Good catch'), r);
r = res(await submit(I, T1, null, { [m1]: 2, [m2]: 0, [s1]: 'Rewrote: I rushed my cues on Tuesday and Thursday.' }));
r = await as(I, `select reviewed_at is null u from public.quiz_responses where user_id='${I}'`);
check('editing a reviewed reflection reopens it for review', r.ok && r.rows[0].u === true, r);

r = await as(C, `insert into public.week_signoffs (user_id, week_n, signed_by) values ('${J}',1,'${C}')`);
check('week cannot be signed off with a quiz not passed', !r.ok, r);
r = await as(C, `insert into public.week_signoffs (user_id, week_n, signed_by) values ('${I}',1,'${C}')`);
check('week signs off once every quiz is passed', r.ok, r);
r = res(await submit(I, T1, null, { [m1]: 2, [m2]: 0, [s1]: 'x' }));
check('signed-off week quiz is locked', r.ok === false && r.error === 'locked', r);

// My Path
r = await as(G, `insert into public.path_progress (user_id, task_id) values ('${G}','${P1}')`);
check('path lesson locked until quiz passed', !r.ok, r);
r = await as(A, `insert into public.path_signoffs (user_id, unit_n, signed_by) values ('${G}',1,'${A}')`);
check('path unit cannot be signed off with a quiz not passed', !r.ok, r);
r = res(await submit(G, null, P1, { [pm]: 3, [ps]: 'Used the quick read with a new Rock.' }));
check('path quiz passes', r.ok && r.passed, r);
r = await as(A, `insert into public.path_signoffs (user_id, unit_n, signed_by) values ('${G}',1,'${A}')`);
check('path unit signs off after the quiz', r.ok, r);
r = res(await submit(I, null, P1, { [pm]: 3 }));
check('intern cannot take a path quiz', r.ok === false && r.error === 'locked', r);

console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail ? 1 : 0);
