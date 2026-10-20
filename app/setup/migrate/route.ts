import { readFile } from 'node:fs/promises';
import path from 'node:path';
import { timingSafeEqual } from 'node:crypto';
import postgres from 'postgres';
import { NextResponse, type NextRequest } from 'next/server';

// One-time database setup. Runs the BaseCamp schema with the server-side
// Postgres connection from the Supabase integration. Needs the SETUP_TOKEN
// header, and does nothing if the schema is already in place.
export async function POST(request: NextRequest) {
  const expected = process.env.SETUP_TOKEN ?? '';
  const given = request.headers.get('x-setup-token') ?? '';
  const ok = expected.length >= 32 && given.length === expected.length && timingSafeEqual(Buffer.from(given), Buffer.from(expected));
  if (!ok) return NextResponse.json({ error: 'not allowed' }, { status: 403 });

  const url = process.env.POSTGRES_URL_NON_POOLING ?? process.env.POSTGRES_URL;
  if (!url) return NextResponse.json({ error: 'no database connection configured' }, { status: 500 });

  const sql = postgres(url, { ssl: 'require', max: 1, prepare: false, onnotice: () => {} });
  try {
    const [{ exists }] = await sql`select to_regclass('public.profiles') is not null as exists`;
    if (exists) return NextResponse.json({ status: 'already set up' });

    const file = await readFile(path.join(process.cwd(), 'supabase/migrations/0001_basecamp.sql'), 'utf8');
    await sql.begin(async (tx) => {
      await tx.unsafe(file);
    });
    const [{ weeks }] = await sql`select count(*)::int as weeks from public.weeks`;
    const [{ tasks }] = await sql`select count(*)::int as tasks from public.tasks`;
    return NextResponse.json({ status: 'created', weeks, tasks });
  } catch (e) {
    return NextResponse.json({ error: e instanceof Error ? e.message : String(e) }, { status: 500 });
  } finally {
    await sql.end({ timeout: 5 });
  }
}
