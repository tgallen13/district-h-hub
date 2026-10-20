import type { ReactNode } from 'react';

// Renders a lesson written in a small subset of Markdown: paragraphs,
// "### " subheads, "- " bullets, "1. " numbered lists, **bold** and *italic*.
// Everything becomes React text nodes, so nothing in a lesson can inject HTML.

function inline(text: string): ReactNode[] {
  const out: ReactNode[] = [];
  let rest = text;
  let key = 0;
  while (rest.length) {
    const b = rest.indexOf('**');
    const i = rest.indexOf('*');
    if (b === -1 && i === -1) {
      out.push(rest);
      break;
    }
    const bold = b !== -1 && b <= i;
    const start = bold ? b : i;
    const mark = bold ? '**' : '*';
    const end = rest.indexOf(mark, start + mark.length);
    if (end === -1) {
      out.push(rest);
      break;
    }
    if (start > 0) out.push(rest.slice(0, start));
    const inner = rest.slice(start + mark.length, end);
    out.push(bold ? <strong key={key++}>{inner}</strong> : <em key={key++}>{inner}</em>);
    rest = rest.slice(end + mark.length);
  }
  return out;
}

function isOrdered(line: string) {
  const dot = line.indexOf('. ');
  return dot > 0 && dot < 4 && [...line.slice(0, dot)].every((c) => c >= '0' && c <= '9');
}

export default function Lesson({ text }: { text: string }) {
  const blocks = text.split('\n\n').map((b) => b.trim()).filter(Boolean);
  return (
    <div className="lesson">
      {blocks.map((block, n) => {
        const lines = block.split('\n');
        if (block.startsWith('### ')) return <h4 key={n}>{inline(block.slice(4))}</h4>;
        if (lines.every((l) => l.startsWith('- '))) {
          return <ul key={n}>{lines.map((l, j) => <li key={j}>{inline(l.slice(2))}</li>)}</ul>;
        }
        if (lines.every(isOrdered)) {
          return <ol key={n}>{lines.map((l, j) => <li key={j}>{inline(l.slice(l.indexOf('. ') + 2))}</li>)}</ol>;
        }
        return <p key={n}>{inline(lines.join(' '))}</p>;
      })}
    </div>
  );
}
