-- Orientation: add an interns-only "Getting set up" section covering
-- Gusto, Slack, Liftr, and GoHighLevel (Oct 19, 2026). Candidates are not
-- hired yet, so sections marked interns_only are hidden from them.

alter table public.orientation_modules add column if not exists interns_only boolean not null default false;

insert into public.orientation_modules (sort, title, summary, body, interns_only)
select 7, 'Getting set up', 'Payroll, Slack, Liftr, and GoHighLevel', $md$Before your first shift, you'll get email invitations to the four tools every District H coach uses. Your General Manager sends them. Set all four up during orientation, so your first week goes to the floor and not to logins. Mark this section complete once everything works.

- **Gusto (payroll).** This is how you get paid, and it's where your hiring paperwork lives. Accept the invite and finish onboarding: your personal details, tax withholding (the W-4), and direct deposit. Have your bank's routing and account numbers handy, and bring the original documents for your I-9 employment check to your first shift. Your pay stubs and year-end W-2 live in Gusto too.
- **Slack (team communication).** Install it on your phone and your computer, then join with your District H invite. Add a photo and your full name so the team knows who you are, and turn on notifications for your BaseCamp channel. Starting in Week 1, your film, homework, huddle notes, and questions all go here.
- **Liftr (gym operations).** Liftr runs the day-to-day of the gym: the schedule, members, and the coach side of operations. Accept your staff invite and log in on your phone. Your mentor will show you how coaches use it on the floor.
- **GoHighLevel (leads and follow-up).** GoHighLevel is where new leads, discovery call notes, and follow-up messages live. In your first months you'll mostly watch how it's used, and you'll use it more once you start sitting in on discovery calls.

A few ground rules. Use a strong, different password for each tool, and turn on two-step verification wherever it's offered. Never share a login, and never keep member information anywhere outside these tools. If an invite doesn't show up or something won't work, tell your GM in Slack, or by text if Slack is the problem.$md$, true
where not exists (select 1 from public.orientation_modules where title = 'Getting set up');
