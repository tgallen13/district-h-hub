// Row-level security tests for My Path (Trainer and Coach units).
// Run: node supabase/tests/path.test.mjs
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
for (const f of ['0001_basecamp', '0005_path']) await db.exec(readFileSync(new URL(`../migrations/${f}.sql`, import.meta.url), 'utf8'));
await db.exec(`
  grant all on all tables in schema public to authenticated;
  grant execute on all functions in schema public to authenticated;
  grant execute on all functions in schema auth to authenticated;
`);

const A = '00000000-0000-0000-0000-00000000000a', G = '00000000-0000-0000-0000-000000000011', N = '00000000-0000-0000-0000-000000000012',
  V = '00000000-0000-0000-0000-000000000013', I = '00000000-0000-0000-0000-000000000001';
await db.exec(`
  insert into auth.users values ('${A}'),('${G}'),('${N}'),('${V}'),('${I}');
  insert into public.profiles (id,email,role,path_access) values ('${A}','a@x','admin',false),('${G}','grad@x','coach',false),('${N}','new@x','coach',false),('${V}','vet@x','coach',true),('${I}','i@x','intern',false);
  insert into public.week_signoffs (user_id, week_n, signed_by) select '${G}', n, '${A}' from generate_series(1,24) n;
  insert into public.week_signoffs (user_id, week_n, signed_by) select '${N}', n, '${A}' from generate_series(1,23) n;
  insert into public.path_units (n, title) select n, 'Unit ' || n from generate_series(1,14) n;
  insert into public.path_tasks (unit_n, sort, kind, title) select n, 1, 'lesson', 'Lesson ' || n from generate_series(1,14) n;
`);

let pass = 0, fail = 0;
async function as(uid, sql) {
  await db.exec(`reset role; select set_config('request.uid', '${uid}', false); set role authenticated;`);
  try { const r = await db.query(sql); return { ok: true, rows: r.rows, n: r.affectedRows }; }
  catch (e) { return { ok: false, err: e.message }; }
  finally { await db.exec('reset role;'); }
}
function check(name, cond, info) { if (cond) { pass++; console.log('PASS', name); } else { fail++; console.log('FAIL', name, JSON.stringify(info)); } }
const task = async (u) => (await db.query(`select id from public.path_tasks where unit_n=${u}`)).rows[0].id;
const count = (r) => (r.ok ? Number(r.rows[0].c) : -1);

let r;
r = await as(G, `select count(*) c, max(unit_n) m from public.path_tasks`);
check('graduate sees only unit 1 work', r.ok && count(r) === 1 && r.rows[0].m === 1, r);
r = await as(N, `select count(*) c from public.path_tasks`);
check('coach without week 24 signed off sees no path work', count(r) === 0, r);
r = await as(V, `select count(*) c from public.path_tasks`);
check('coach given access by admin sees unit 1', count(r) === 1, r);
r = await as(I, `select count(*) c from public.path_units`);
check('intern cannot see the path outline', count(r) === 0, r);
r = await as(G, `select count(*) c from public.path_units`);
check('coach sees the 14-unit outline', count(r) === 14, r);

const u1 = await task(1), u2 = await task(2);
r = await as(G, `insert into public.path_progress (user_id, task_id) values ('${G}','${u1}')`);
check('graduate completes unit 1 work', r.ok, r);
r = await as(G, `insert into public.path_progress (user_id, task_id) values ('${G}','${u2}')`);
check('graduate blocked from unit 2 work', !r.ok, r);
r = await as(N, `insert into public.path_progress (user_id, task_id) values ('${N}','${u1}')`);
check('coach not on path cannot record work', !r.ok, r);
r = await as(V, `insert into public.path_progress (user_id, task_id) values ('${G}','${u1}')`);
check('cannot record work for someone else', !r.ok, r);

r = await as(G, `insert into public.path_signoffs (user_id, unit_n, signed_by) values ('${G}',1,'${G}')`);
check('coach cannot sign off self', !r.ok, r);
r = await as(V, `insert into public.path_signoffs (user_id, unit_n, signed_by) values ('${G}',1,'${V}')`);
check('coach who has not finished unit 1 cannot sign it off', !r.ok, r);
r = await as(A, `insert into public.path_signoffs (user_id, unit_n, signed_by) values ('${G}',2,'${A}')`);
check('admin cannot skip ahead to unit 2', !r.ok, r);
r = await as(A, `insert into public.path_signoffs (user_id, unit_n, signed_by) values ('${N}',1,'${A}')`);
check('cannot sign off someone not on the path', !r.ok, r);
r = await as(A, `insert into public.path_signoffs (user_id, unit_n, signed_by) values ('${G}',1,'${A}')`);
check('admin signs off unit 1', r.ok, r);

r = await as(G, `select count(*) c from public.path_tasks`);
check('graduate now sees units 1 and 2', count(r) === 2, r);
r = await as(G, `insert into public.path_progress (user_id, task_id) values ('${G}','${u2}')`);
check('graduate completes unit 2 work', r.ok, r);
r = await as(G, `delete from public.path_progress where user_id='${G}' and task_id='${u1}'`);
check('signed-off unit is locked', r.ok && r.n === 0, r);

r = await as(G, `insert into public.path_signoffs (user_id, unit_n, signed_by) values ('${V}',1,'${G}')`);
check('coach who finished unit 1 can sign off a peer in unit 1', r.ok, r);
r = await as(V, `select count(*) c from public.path_tasks`);
check('peer now sees unit 2', count(r) === 2, r);
r = await as(V, `insert into public.path_signoffs (user_id, unit_n, signed_by) values ('${G}',2,'${V}')`);
check('coach cannot sign off a unit they have not finished', !r.ok, r);
r = await as(G, `delete from public.path_signoffs where user_id='${V}' and unit_n=1`);
check('signer can undo their latest sign-off', r.ok && r.n === 1, r);

r = await as(N, `update public.profiles set path_access=true where id='${N}'`);
check('coach cannot grant themselves access', r.ok && r.n === 0, r);
r = await as(A, `update public.profiles set path_access=true where id='${N}'`);
check('admin grants access', r.ok && r.n === 1, r);
r = await as(N, `select count(*) c from public.path_tasks`);
check('granted coach sees unit 1', count(r) === 1, r);
r = await as(G, `update public.path_tasks set title='x'`);
check('coach cannot edit path content', r.ok && r.n === 0, r);

console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail ? 1 : 0);
