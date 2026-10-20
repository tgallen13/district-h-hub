import { redirect } from 'next/navigation';
import { getViewer, homeFor } from '@/lib/auth';

export default async function Home() {
  const viewer = await getViewer();
  if (!viewer) redirect('/login');
  if (!viewer.profile) redirect('/no-access');
  redirect(homeFor(viewer.profile.role));
}
