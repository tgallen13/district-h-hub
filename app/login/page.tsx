import { redirect } from 'next/navigation';
import { getViewer, homeFor } from '@/lib/auth';
import LoginForm from './LoginForm';

const NOTICES: Record<string, string> = {
  expired: 'That link expired or was already used. Ask for a new one below.',
  device: 'That link was opened in a different browser than the one that asked for it. Ask for a new link and open it on this device.',
};

export default async function LoginPage({ searchParams }: { searchParams: Promise<{ e?: string }> }) {
  const viewer = await getViewer();
  if (viewer?.profile) redirect(homeFor(viewer.profile.role));
  const { e } = await searchParams;

  return (
    <div className="login">
      <div className="login-left">
        <div className="brand">
          <div className="mark mark-lg">H</div>
          <span className="brand-word">District H</span>
        </div>
        <div className="stack" style={{ maxWidth: 440, gap: 20 }}>
          <h1 className="display">Coach Hub</h1>
          <p className="login-lede">
            BaseCamp, your weekly work, and your path as a coach. Sign in with the email District H has on file for you.
          </p>
        </div>
        <div className="muted-dark">Real Training. Better Living.</div>
      </div>
      <div className="login-right">
        <div className="login-form">
          <div>
            <h2 style={{ fontSize: 32 }}>Sign in</h2>
            <p className="sub" style={{ fontSize: 16, marginTop: 8 }}>We&rsquo;ll email you a link. Tap it and you&rsquo;re in.</p>
          </div>
          <LoginForm notice={e ? NOTICES[e] : undefined} />
        </div>
      </div>
    </div>
  );
}
