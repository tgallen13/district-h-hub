import Link from 'next/link';
import type { Profile } from '@/lib/auth';
import { LOGO_URL } from '@/lib/brand';

type NavItem = { href: string; label: string };

function navFor(profile: Profile): NavItem[] {
  switch (profile.role) {
    case 'admin':
      return [
        { href: '/coach', label: 'Development' },
        { href: '/admin', label: 'People' },
        { href: '/admin/weeks', label: 'BaseCamp weeks' },
        { href: '/admin/path', label: 'My Path units' },
        { href: '/admin/orientation', label: 'Orientation' },
        { href: '/playbooks', label: 'Playbooks' },
      ];
    case 'coach':
      return [
        { href: '/path', label: 'My Path' },
        { href: '/coach', label: 'Development' },
        { href: '/playbooks', label: 'Playbooks' },
      ];
    case 'intern':
      return [
        { href: '/basecamp', label: 'My week' },
        { href: '/basecamp/orientation', label: 'Orientation' },
      ];
    default:
      return [{ href: '/basecamp', label: 'Orientation' }];
  }
}

export default function Shell({ profile, active, children }: { profile: Profile; active: string; children: React.ReactNode }) {
  const learner = profile.role === 'intern' || profile.role === 'candidate';
  return (
    <div className="shell">
      <nav className={`side${learner ? ' blue' : ''}`} aria-label="Coach Hub">
        <div className="stack" style={{ gap: 6, padding: '0 8px' }}>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img className="logo" src={LOGO_URL} alt="District H" width={132} height={84} />
          <div className="brand" style={{ fontSize: 15, letterSpacing: '.06em', textTransform: 'uppercase' }}>
            {learner ? 'BaseCamp' : 'Coach Hub'}
          </div>
        </div>
        <div className="nav">
          {navFor(profile).map((item) => (
            <Link key={item.href} href={item.href} className={item.href === active ? 'on' : undefined} aria-current={item.href === active ? 'page' : undefined}>
              {item.label}
            </Link>
          ))}
        </div>
        <div style={{ marginTop: 'auto' }}>
          <div className="who">{profile.full_name || profile.email}</div>
          <form action="/auth/signout" method="post">
            <button className="signout" type="submit">Sign out</button>
          </form>
        </div>
      </nav>
      <main className="main">{children}</main>
    </div>
  );
}
