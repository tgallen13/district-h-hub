import Shell from '@/components/Shell';
import Orientation from '@/components/Orientation';
import { requireRole } from '@/lib/auth';

export const metadata = { title: 'Orientation' };

export default async function OrientationPage() {
  const me = await requireRole(['intern', 'candidate']);
  return (
    <Shell profile={me} active={me.role === 'candidate' ? '/basecamp' : '/basecamp/orientation'}>
      <div className="stack" style={{ gap: 6 }}>
        <h1 className="h1">Orientation</h1>
        <p className="lede">Who we are, how the gym works, and what we commit to you. Come back to it anytime.</p>
      </div>
      <Orientation userId={me.id} role={me.role} />
    </Shell>
  );
}
