export function isEmail(value: string): boolean {
  const s = value.trim();
  if (!s || s.length > 320 || /[ <>,;]/.test(s)) return false;
  const parts = s.split('@');
  if (parts.length !== 2 || !parts[0]) return false;
  const domain = parts[1];
  const dot = domain.lastIndexOf('.');
  return dot > 0 && dot < domain.length - 2;
}

export function isHttpUrl(value: string): boolean {
  try {
    const u = new URL(value.trim());
    return u.protocol === 'https:' || u.protocol === 'http:';
  } catch {
    return false;
  }
}
