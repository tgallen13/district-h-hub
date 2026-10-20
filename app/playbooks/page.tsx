import Link from 'next/link';
import Shell from '@/components/Shell';
import { requireRole } from '@/lib/auth';
import { createClient } from '@/lib/supabase/server';
import type { Playbook } from '@/lib/playbooks';

export const metadata = { title: 'Playbooks' };

export default async function Playbooks() {
  const me = await requireRole(['admin', 'coach']);
  const supabase = await createClient();
  const { data } = await supabase.from('playbooks').select('*').order('sort');
  const list = (data ?? []) as Playbook[];
  return (
    <Shell profile={me} active="/playbooks">
      <div className="stack" style={{ gap: 6 }}>
        <h1 className="h1">Playbooks</h1>
        <p className="lede">How District H runs the big things, step by step, with a checklist you can work from.</p>
      </div>
      <section className="card" style={{ gap: 0 }}>
        {list.length === 0 ? <p className="sub">No playbooks yet.</p> : null}
        {list.map((p) => (
          <div className="item" key={p.slug}>
            <div className="grow">
              <span className="t">{p.title}</span>
              {p.summary ? <span className="sub">{p.summary}</span> : null}
            </div>
            <Link className="btn" href={`/playbooks/${p.slug}`}>Open</Link>
          </div>
        ))}
      </section>
    </Shell>
  );
}
