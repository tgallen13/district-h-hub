import type { NextConfig } from 'next';

// Every page in the hub is personal to the signed-in person, so pages render
// per request instead of using Cache Components' prerendered shells.
const nextConfig: NextConfig = {
  cacheComponents: false,
  outputFileTracingIncludes: {
    '/setup/migrate': ['./supabase/migrations/**'],
  },
  async headers() {
    return [{ source: '/:path*', headers: [{ key: 'X-Robots-Tag', value: 'noindex, nofollow' }] }];
  },
};

export default nextConfig;
