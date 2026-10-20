import { PGlite } from '@electric-sql/pglite';
import { readFileSync } from 'fs';

const db = new PGlite();
// Minimal stand-in for Supabase's auth schema and roles.
await db.exec(`
  create schema auth;
  create table auth.users (id uuid primary key);
  create function auth.uid() returns uuid language sql stable as $$ select nullif(current_setting('request.uid', true), '')::uuid $$;
  create role authenticated nologin;
  grant usage on schema public, auth to authenticated;
`);
await db.exec(readFileSync(process.argv[2], 'utf8'));
await db.exec(`
  grant all on all tables in schema public to authenticated;
  grant execute on all functions in schema public to authenticated;
  grant execute on all functions in schema auth to authenticated;
`);

const A = '00000000-0000-0000-0000-00000000000a', C = '00000000-0000-0000-0000-00000000000c',
  I = '00000000-0000-0000-0000-000000000001', I2 = '00000000-0000-0000-0000-000000000002', K = '00000000-0000-0000-0000-00000000000d',
  X = '00000000-0000-0000-0000-0000000000ff';
await db.exec(`
  insert into auth.users values ('${A}'),('${C}'),('${I}'),('${I2}'),('${K}'),('${X}');
  insert into public.profiles (id,email,role) values ('${A}','a@x','admin'),('${C}','c@x','coach'),('${I}','i@x','intern'),('${I2}','i2@x','intern'),('${K}','k@x','candidate');
`);

let pass = 0, fail = 0;
async function as(uid, sql) {
  await db.exec(`reset role; select set_config('request.uid', '${uid}', false); set role authenticated;`);
  try { const r = await db.query(sql); return { ok: true, rows: r.rows, n: r.affectedRows }; }
  catch (e) { return { ok: false, err: e.message }; }
  finally { await db.exec('reset role;'); }
}
function check(name, cond, info) { if (cond) { pass++; console.log('PASS', name); } else { fail++; console.log('FAIL', name, JSON.stringify(info)); } }
const taskIn = async (w) => (await db.query(`select id from public.tasks where week_n=${w} order by sort limit 1`)).rows[0].id;

let r;
r = await as(I, `select max(week_n) m, count(*) c from public.tasks`);
check('intern sees only week 1 tasks', r.ok && r.rows[0].m === 1 && Number(r.rows[0].c) === 8, r);
r = await as(I, `select count(*) c from public.weeks`);
check('intern sees 24-week outline', r.ok && Number(r.rows[0].c) === 24, r);
r = await as(K, `select count(*) c from public.weeks`);
check('candidate cannot see weeks', r.ok && Number(r.rows[0].c) === 0, r);
r = await as(K, `select count(*) c from public.orientation_modules`);
check('candidate sees orientation', r.ok && Number(r.rows[0].c) === 6, r);
r = await as(X, `select count(*) c from public.orientation_modules`);
check('user without profile sees nothing', r.ok && Number(r.rows[0].c) === 0, r);

const t1 = await taskIn(1), t2 = await taskIn(2);
r = await as(I, `insert into public.task_progress (user_id, task_id) values ('${I}','${t1}')`);
check('intern completes week-1 task', r.ok, r);
r = await as(I, `insert into public.task_progress (user_id, task_id) values ('${I}','${t2}')`);
check('intern blocked from week-2 task', !r.ok, r);
r = await as(I, `insert into public.task_progress (user_id, task_id) values ('${I2}','${t1}')`);
check('intern cannot write for another intern', !r.ok, r);
r = await as(I2, `select count(*) c from public.task_progress`);
check('intern cannot read another intern progress', r.ok && Number(r.rows[0].c) === 0, r);

r = await as(I, `insert into public.week_signoffs (user_id, week_n, signed_by) values ('${I}',1,'${I}')`);
check('intern cannot sign off self', !r.ok, r);
r = await as(C, `insert into public.week_signoffs (user_id, week_n, signed_by) values ('${I}',2,'${C}')`);
check('coach cannot skip ahead to week 2', !r.ok, r);
r = await as(C, `insert into public.week_signoffs (user_id, week_n, signed_by) values ('${I}',1,'${A}')`);
check('coach cannot sign as someone else', !r.ok, r);
r = await as(C, `insert into public.week_signoffs (user_id, week_n, signed_by) values ('${K}',1,'${C}')`);
check('cannot sign off a candidate', !r.ok, r);
r = await as(C, `insert into public.week_signoffs (user_id, week_n, signed_by) values ('${I}',1,'${C}')`);
check('coach signs off week 1', r.ok, r);

r = await as(I, `select max(week_n) m from public.tasks`);
check('week 2 now visible to intern', r.ok && r.rows[0].m === 2, r);
r = await as(I, `insert into public.task_progress (user_id, task_id) values ('${I}','${t2}')`);
check('intern completes week-2 task', r.ok, r);
r = await as(I, `delete from public.task_progress where task_id='${t1}'`);
check('signed-off week is locked from edits', r.ok && r.n === 0, r);

r = await as(C, `insert into public.week_signoffs (user_id, week_n, signed_by) values ('${I}',2,'${C}')`);
check('coach signs off week 2', r.ok, r);
r = await as(C, `delete from public.week_signoffs where user_id='${I}' and week_n=1`);
check('cannot undo a non-latest sign-off', r.ok && r.n === 0, r);
r = await as(C, `delete from public.week_signoffs where user_id='${I}' and week_n=2`);
check('coach undoes latest sign-off', r.ok && r.n === 1, r);

r = await as(I, `update public.profiles set role='admin' where id='${I}'`);
check('intern cannot promote self', r.ok && r.n === 0, r);
r = await as(C, `update public.profiles set role='admin' where id='${C}'`);
check('coach cannot promote self', r.ok && r.n === 0, r);
r = await as(C, `update public.weeks set title='x' where n=1`);
check('coach cannot edit curriculum', r.ok && r.n === 0, r);
r = await as(A, `update public.weeks set title='Orientation' where n=1`);
check('admin edits curriculum', r.ok && r.n === 1, r);
r = await as(A, `update public.profiles set role='coach' where id='${I2}'`);
check('admin changes a role', r.ok && r.n === 1, r);

for (let w = 2; w <= 24; w++) await as(C, `insert into public.week_signoffs (user_id, week_n, signed_by) values ('${I}',${w},'${C}')`);
r = await as(I, `select count(*) c from public.week_signoffs where user_id='${I}'`);
check('all 24 weeks signed off in order', r.ok && Number(r.rows[0].c) === 24, r);
const t24 = await taskIn(24);
r = await as(I, `insert into public.task_progress (user_id, task_id) values ('${I}','${t24}')`);
check('finished intern cannot edit week 24', !r.ok, r);

console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail ? 1 : 0);
