import Link from 'next/link';
import { TOTAL_UNITS, TRAINER_UNITS, unitLabel } from '@/lib/path';

// The 14 path units in two rows: Trainer months, then Coach quarters.
export default function UnitGrid({ open, done, selected, basePath }: { open: number; done: boolean; selected: number; basePath: string }) {
  const cell = (n: number) => {
    const signed = n < open || (done && n === open);
    const locked = n > open;
    const cls = `wk${signed ? ' done' : locked ? ' lock' : ' cur'}${n === selected ? ' sel' : ''}`;
    const short = n <= TRAINER_UNITS ? `M${n}` : `Q${n - TRAINER_UNITS}`;
    const label = `${n <= TRAINER_UNITS ? 'Trainer' : 'Coach'}, ${unitLabel(n)}${locked ? ', locked' : signed ? ', signed off' : ', open'}`;
    return locked ? (
      <span key={n} className={cls} aria-label={label} role="img">{short}</span>
    ) : (
      <Link key={n} href={`${basePath}?unit=${n}`} className={cls} aria-label={label} aria-current={n === selected ? 'true' : undefined}>
        {short}
      </Link>
    );
  };
  const range = (a: number, b: number) => Array.from({ length: b - a + 1 }, (_, i) => a + i);
  return (
    <div className="stack" style={{ gap: 10 }}>
      <div className="eyebrow">Trainer · 6 months</div>
      <div className="weeks">{range(1, TRAINER_UNITS).map(cell)}</div>
      <div className="eyebrow">Coach · 2 years</div>
      <div className="weeks">{range(TRAINER_UNITS + 1, TOTAL_UNITS).map(cell)}</div>
    </div>
  );
}
