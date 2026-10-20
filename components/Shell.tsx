import Link from 'next/link';
import type { Profile } from '@/lib/auth';

type NavItem = { href: string; label: string };

function navFor(profile: Profile): NavItem[] {
  switch (profile.role) {
    case 'admin':
      return [
        { href: '/coach', label: 'Interns' },
        { href: '/admin', label: 'People' },
        { href: '/admin/weeks', label: 'Curriculum' },
        { href: '/admin/orientation', label: 'Orientation' },
      ];
    case 'coach':
      return [{ href: '/coach', label: 'Interns' }];
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
        <div className="brand">
          <div className="mark">H</div>
          {learner ? 'BaseCamp' : 'Coach Hub'}
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
