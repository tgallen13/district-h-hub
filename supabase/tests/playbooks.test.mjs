// Row-level security tests for Playbooks.
// Run: node supabase/tests/playbooks.test.mjs
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
for (const f of ['0001_basecamp', '0013_playbooks']) await db.exec(readFileSync(new URL(`../migrations/${f}.sql`, import.meta.url), 'utf8'));
await db.exec(`
  grant all on all tables in schema public to authenticated;
  grant execute on all functions in schema public to authenticated;
  grant execute on all functions in schema auth to authenticated;
`);
const A = '00000000-0000-0000-0000-00000000000a', C = '00000000-0000-0000-0000-00000000000c', I = '00000000-0000-0000-0000-000000000001';
await db.exec(`
  insert into auth.users values ('${A}'),('${C}'),('${I}');
  insert into public.profiles (id,email,role) values ('${A}','a@x','admin'),('${C}','c@x','coach'),('${I}','i@x','intern');
  insert into public.playbooks (slug,title) values ('opening','Opening Playbook');
  insert into public.playbook_sections (id,playbook,title) values ('10000000-0000-0000-0000-000000000001','opening','Phase 1');
  insert into public.playbook_items (id,section_id,text) values ('20000000-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000001','Sign the lease');
  insert into public.playbook_runs (id,playbook,name) values ('30000000-0000-0000-0000-000000000001','opening','Location 3'),('30000000-0000-0000-0000-000000000002','opening','Old');
  update public.playbook_runs set archived = true where name = 'Old';
`);
let pass = 0, fail = 0;
async function as(uid, sql) {
  await db.exec(`reset role; select set_config('request.uid', '${uid}', false); set role authenticated;`);
  try { const r = await db.query(sql); return { ok: true, rows: r.rows, n: r.affectedRows }; }
  catch (e) { return { ok: false, err: e.message }; }
  finally { await db.exec('reset role;'); }
}
function check(name, cond, info) { if (cond) { pass++; console.log('PASS', name); } else { fail++; console.log('FAIL', name, JSON.stringify(info)); } }
const RUN = '30000000-0000-0000-0000-000000000001', OLD = '30000000-0000-0000-0000-000000000002', ITEM = '20000000-0000-0000-0000-000000000001';
let r;
r = await as(C, `select count(*)::int c from public.playbook_items`); check('coach reads playbook', r.ok && r.rows[0].c === 1, r);
r = await as(I, `select count(*)::int c from public.playbooks`); check('intern cannot see playbooks', r.ok && r.rows[0].c === 0, r);
r = await as(C, `insert into public.playbook_checks (run_id,item_id,done_by) values ('${RUN}','${ITEM}','${C}')`); check('coach ticks an item', r.ok, r);
r = await as(C, `insert into public.playbook_checks (run_id,item_id,done_by) values ('${OLD}','${ITEM}','${C}')`); check('cannot tick an archived run', !r.ok, r);
r = await as(C, `insert into public.playbook_checks (run_id,item_id,done_by) values ('${OLD}','${ITEM}','${A}')`); check('cannot tick as someone else', !r.ok, r);
r = await as(I, `insert into public.playbook_checks (run_id,item_id,done_by) values ('${RUN}','${ITEM}','${I}')`); check('intern cannot tick', !r.ok, r);
r = await as(C, `update public.playbook_items set text='x'`); check('coach cannot edit content', r.ok && r.n === 0, r);
r = await as(C, `insert into public.playbook_runs (playbook,name) values ('opening','Mine')`); check('coach cannot start a run', !r.ok, r);
r = await as(A, `insert into public.playbook_runs (playbook,name) values ('opening','Location 4')`); check('admin starts a run', r.ok, r);
r = await as(A, `update public.playbook_items set text='Sign the lease and get keys'`); check('admin edits content', r.ok && r.n === 1, r);
r = await as(C, `delete from public.playbook_checks where run_id='${RUN}'`); check('coach unticks', r.ok && r.n === 1, r);
console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail ? 1 : 0);
