import { redirect } from 'next/navigation';
import { getViewer, homeFor } from '@/lib/auth';
import LoginForm from './LoginForm';
import { LOGO_URL } from '@/lib/brand';

const NOTICES: Record<string, string> = {
  expired: 'That link expired or was already used. Ask for a new one below.',
  device: 'That link was opened in a different browser than the one that asked for it. Ask for a new link below.',
};

export default async function LoginPage({ searchParams }: { searchParams: Promise<{ e?: string }> }) {
  const viewer = await getViewer();
  if (viewer?.profile) redirect(homeFor(viewer.profile.role));
  const { e } = await searchParams;

  return (
    <div className="login">
      <div className="login-left">
        {/* eslint-disable-next-line @next/next/no-img-element */}
        <img className="logo" src={LOGO_URL} alt="District H, established 2012" width={220} height={140} />
        <div className="stack" style={{ maxWidth: 440, gap: 20 }}>
          <h1 className="display">BaseCamp</h1>
          <p className="login-lede">
            The District H coaching apprenticeship. Your weekly work, your coach’s notes, and your path, all in one place.
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
