import 'server-only';
import { createClient } from '@/lib/supabase/server';

export type Playbook = { slug: string; title: string; summary: string; sort: number };
export type PlaybookSection = { id: string; playbook: string; sort: number; title: string; timing: string; body: string };
export type PlaybookItem = { id: string; section_id: string; sort: number; text: string; owner: string };
export type PlaybookRun = { id: string; playbook: string; name: string; target_date: string | null; archived: boolean; created_at: string };

export async function loadPlaybook(slug: string, runId: string | null) {
  const supabase = await createClient();
  const { data: pb } = await supabase.from('playbooks').select('*').eq('slug', slug).maybeSingle();
  if (!pb) return null;
  const [{ data: sections }, { data: runs }] = await Promise.all([
    supabase.from('playbook_sections').select('*').eq('playbook', slug).order('sort'),
    supabase.from('playbook_runs').select('*').eq('playbook', slug).order('created_at', { ascending: false }),
  ]);
  const secs = (sections ?? []) as PlaybookSection[];
  const { data: items } = secs.length
    ? await supabase.from('playbook_items').select('*').in('section_id', secs.map((s) => s.id)).order('sort')
    : { data: [] };
  const runList = (runs ?? []) as PlaybookRun[];
  const run = runList.find((r) => r.id === runId) ?? runList.find((r) => !r.archived) ?? null;
  const { data: checks } = run
    ? await supabase.from('playbook_checks').select('item_id, done_at').eq('run_id', run.id)
    : { data: [] };
  return {
    playbook: pb as Playbook,
    sections: secs,
    items: (items ?? []) as PlaybookItem[],
    runs: runList,
    run,
    checked: new Set(((checks ?? []) as { item_id: string }[]).map((c) => c.item_id)),
  };
}
