import Link from 'next/link';
import { TOTAL_WEEKS } from '@/lib/basecamp';

export default function WeekGrid({ open, done, selected, basePath }: { open: number; done: boolean; selected: number; basePath: string }) {
  return (
    <div className="weeks">
      {Array.from({ length: TOTAL_WEEKS }, (_, i) => i + 1).map((n) => {
        const signed = n < open || (done && n === open);
        const locked = n > open;
        const cls = `wk${signed ? ' done' : locked ? ' lock' : ' cur'}${n === selected ? ' sel' : ''}`;
        const label = `Week ${n}${locked ? ', locked' : signed ? ', signed off' : ', open'}`;
        return locked ? (
          <span key={n} className={cls} aria-label={label} role="img">{n}</span>
        ) : (
          <Link key={n} href={`${basePath}?week=${n}`} className={cls} aria-label={label} aria-current={n === selected ? 'true' : undefined}>
            {n}
          </Link>
        );
      })}
    </div>
  );
}
