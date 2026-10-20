import Shell from '@/components/Shell';
import { requireRole, type Profile } from '@/lib/auth';
import { createClient } from '@/lib/supabase/server';
import { addPerson, removePerson, updatePerson } from './actions';

export const metadata = { title: 'People' };

const OK: Record<string, string> = {
  invited: 'Invite sent. They’ll get an email with a link to sign in.',
  added: 'Added. They already had a login, so no email went out. Tell them to sign in at basecamp.districthsf.com.',
  saved: 'Saved.',
  removed: 'Access removed.',
};
const ERR: Record<string, string> = {
  input: 'Check the email and role, then try again.',
  invite: 'Couldn’t create that login. Check the email address.',
  save: 'Couldn’t save that person. Try again.',
  self: 'You can’t remove your own admin access.',
};
const ROLE_LABEL = { admin: 'Admin', coach: 'Coach', intern: 'Intern', candidate: 'Candidate' } as const;
const LOC: Record<string, string> = { heights: 'Heights', oak_forest: 'Oak Forest' };

function RoleSelect({ id, value }: { id: string; value?: string }) {
  return (
    <select id={id} name="role" className="select" defaultValue={value ?? 'candidate'}>
      <option value="candidate">Candidate</option>
      <option value="intern">Intern</option>
      <option value="coach">Coach</option>
      <option value="admin">Admin</option>
    </select>
  );
}
function LocSelect({ id, value }: { id: string; value?: string | null }) {
  return (
    <select id={id} name="location" className="select" defaultValue={value ?? ''}>
      <option value="">Both or none</option>
      <option value="heights">Heights</option>
      <option value="oak_forest">Oak Forest</option>
    </select>
  );
}

export default async function People({ searchParams }: { searchParams: Promise<{ ok?: string; e?: string }> }) {
  const me = await requireRole(['admin']);
  const { ok, e } = await searchParams;
  const supabase = await createClient();
  const { data } = await supabase.from('profiles').select('*').order('role').order('full_name');
  const people = (data ?? []) as Profile[];

  return (
    <Shell profile={me} active="/admin">
      <div className="stack" style={{ gap: 6 }}>
        <h1 className="h1">People</h1>
        <p className="lede">Only people listed here can sign in. Their role decides what they see.</p>
      </div>
      {ok && OK[ok] ? <div className="note" role="status">{OK[ok]}</div> : null}
      {e && ERR[e] ? <div className="warn" role="alert">{ERR[e]}</div> : null}

      <form action={addPerson} className="card">
        <h2 style={{ fontSize: 20 }}>Add someone</h2>
        <div className="row" style={{ gap: 12 }}>
          <div className="field" style={{ flex: '1 1 220px' }}>
            <label htmlFor="add-name">Full name</label>
            <input id="add-name" name="full_name" className="input" required />
          </div>
          <div className="field" style={{ flex: '1 1 240px' }}>
            <label htmlFor="add-email">Email</label>
            <input id="add-email" name="email" type="email" className="input" required />
          </div>
          <div className="field" style={{ flex: '1 1 150px' }}>
            <label htmlFor="add-role">Role</label>
            <RoleSelect id="add-role" />
          </div>
          <div className="field" style={{ flex: '1 1 150px' }}>
            <label htmlFor="add-loc">Location</label>
            <LocSelect id="add-loc" />
          </div>
        </div>
        <button className="btn primary" type="submit" style={{ alignSelf: 'flex-start' }}>Add and send invite</button>
      </form>

      <section className="card" style={{ gap: 0 }}>
        <h2 style={{ fontSize: 20, marginBottom: 6 }}>Everyone with access ({people.length})</h2>
        {people.map((p) => (
          <div className="item" key={p.id}>
            <div className="grow">
              <span className="t">{p.full_name || p.email}{p.id === me.id ? ' (you)' : ''}</span>
              <span className="sub">{p.email} · {ROLE_LABEL[p.role]}{p.location ? ` · ${LOC[p.location]}` : ''}</span>
            </div>
            <details style={{ flex: '1 1 100%' }}>
              <summary className="btn" style={{ listStyle: 'none', display: 'inline-flex' }}>Edit</summary>
              <form action={updatePerson} className="row" style={{ gap: 12, marginTop: 12, alignItems: 'flex-end' }}>
                <input type="hidden" name="id" value={p.id} />
                <div className="field" style={{ flex: '1 1 200px' }}>
                  <label htmlFor={`n-${p.id}`}>Full name</label>
                  <input id={`n-${p.id}`} name="full_name" className="input" defaultValue={p.full_name} />
                </div>
                <div className="field" style={{ flex: '1 1 140px' }}>
                  <label htmlFor={`r-${p.id}`}>Role</label>
                  <RoleSelect id={`r-${p.id}`} value={p.role} />
                </div>
                <div className="field" style={{ flex: '1 1 140px' }}>
                  <label htmlFor={`l-${p.id}`}>Location</label>
                  <LocSelect id={`l-${p.id}`} value={p.location} />
                </div>
                <button className="btn blue" type="submit" style={{ flex: '0 0 auto' }}>Save</button>
              </form>
              {p.id !== me.id ? (
                <form action={removePerson} style={{ marginTop: 10 }}>
                  <input type="hidden" name="id" value={p.id} />
                  <button className="btn quiet" type="submit" style={{ color: 'var(--warn)' }}>Remove access</button>
                </form>
              ) : null}
            </details>
          </div>
        ))}
      </section>
    </Shell>
  );
}
