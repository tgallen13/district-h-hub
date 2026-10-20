# District H Coach Hub

BaseCamp and coach development for District H Strength & Fitness, live at
**basecamp.districthsf.com**.

Next.js on Vercel, with Supabase for email-link sign-in and the database.
Every push to `main` deploys to production automatically.

## What's in version one

- **Email-link sign-in.** No passwords. Access is invite-only: only people an
  admin has added can get in.
- **Interns** see their open week, mark lessons done, submit homework and
  filmed-rep links, and read their coach's sign-off notes. Weeks unlock in order.
- **Candidates** see orientation and their Professional Path Call.
- **Coaches** see every intern, who's waiting on a sign-off, and each intern's
  submissions. Signing off a week unlocks the next one. The latest sign-off can
  be undone.
- **Admins** add people and set roles, and edit all 24 weeks, the work inside
  each week, and the orientation sections.

The rules are enforced in the database with row-level security, not just the
screens: an intern can't load or complete a locked week, a coach can't skip an
intern ahead, and nobody can change their own role. `npm run test:db` checks
27 of these rules against the real schema.

## One-time setup

1. **Database.** In Vercel, open the project, go to Storage, and create a
   Supabase database. That adds the Supabase keys to the project.
2. **Schema.** In Supabase, open the SQL Editor, paste
   `supabase/migrations/0001_basecamp.sql`, and run it once. (Already done for
   the live project.)
3. **Owner access.** Set `ADMIN_EMAILS` in Vercel to the owner's email (comma
   separated for more than one). Those emails can sign in before anyone has
   invited them and become admins on first sign-in.
4. **Sign-in links.** In Supabase, go to Authentication, then URL
   Configuration. Set Site URL to `https://basecamp.districthsf.com` and add
   `https://basecamp.districthsf.com/auth/confirm` to Redirect URLs.
5. **Email links** need no template changes to work. Sign-in links use Supabase's implicit
   flow, so the default emails work in any browser, including a phone's mail
   app (`/auth/confirm` reads the session from the link; `/auth/callback`
   handles `token_hash` and PKCE links if templates are customized later).
6. **Sign-ups.** In Supabase, under Authentication, then Sign In / Providers,
   turn off "Allow new users to sign up". The hub creates logins only through
   admin invites and `ADMIN_EMAILS`.

7. **Email sender.** Auth emails go out through Resend from
   `basecamp@districthsf.com` (Authentication, then Emails, then SMTP Settings:
   host `smtp.resend.com`, port 465, user `resend`, password is the Resend API
   key). The email rate limit is 100 an hour, matching Resend's free daily cap.
8. **Branded emails.** The HTML for the sign-in, invite, and confirm emails
   lives in `supabase/templates/`. Paste a changed file into the matching
   template under Authentication, then Emails, then Templates.

## Working on it

```bash
npm install
npm run dev        # needs the Supabase env vars in .env.local
npm run typecheck
npm run test:db    # row-level security tests, no Supabase needed
npm run build
```

Pages are rendered per request for the signed-in person (`cacheComponents` is
off in `next.config.ts`). Request auth refresh lives in `proxy.ts`, which is
what Next.js 16 calls middleware.

## Not built yet

- The coach side from the prototype: Today (outreach and recognitions),
  Playbooks, and My Path.
- File uploads for filmed reps. Interns paste a link for now.
- Email or Slack notifications when an intern is ready for sign-off.
