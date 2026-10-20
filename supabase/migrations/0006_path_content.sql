-- My Path content: the six Trainer months and eight Coach quarters from the
-- "My Path: Trainer and Coach Phases" review doc (Oct 19, 2026), with
-- Trainer Month 1 written in full. Safe to re-run: units are upserted and
-- a unit's tasks are only (re)loaded while no coach has recorded work in it.


insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (1, $md$Month 1$md$, $md$Owning the floor$md$, $md$Coaching your sessions independently, running the Floor Loop at full speed.$md$, $md$$md$, $md$Start *Peak* (Ericsson and Pool).$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 1) then
    delete from public.path_tasks where unit_n = 1;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (1, 1, 'lesson', $md$Week 1: From Instructor to Trainer$md$, $md$On the floor this week: Coach every session as if your mentor were watching the film tonight. Then actually film one.$md$, $md$You passed the Instructor gate, and you were hired. Congratulations. That gate asked one question: can you run a safe, clear session and teach the person in front of you? The answer was yes.

The Trainer phase asks a harder one. Can you do that every time, for every member, without anyone watching? That's what mastery means here. Not a new trick, but a standard you hold on a Tuesday at 6 a.m. when you slept badly and the room is flat.

Here's what changes this month. You coach your sessions on your own. Your mentor isn't beside you anymore, and the film becomes the place where you get feedback. Members start thinking of you as one of their coaches, not the new person. That's earned trust, and it's easy to spend.

Here's what doesn't change. The house standard is the same as it was in Week 1 of BaseCamp: on time, prepared, the plan read, the floor reset, every member greeted by name. The Floor Loop is the same loop. The values are the same values. What's different is that nobody is going to remind you.

One honest note. A lot of new coaches get worse for a month or two after they're hired. Not because they forgot anything, but because they relax. The checklist feels beneath them. The pre-session review gets skipped because they "know these people." Then a member gets hurt in a way the notes would have warned about, or someone who was drifting quietly leaves. The Trainer phase is where good habits either become automatic or quietly die. Six months from now, floor coaching is supposed to be finished as a curriculum. That only works if it's finished in you.

**On the floor this week:** Coach every session as if your mentor were watching the film tonight. Then actually film one.

**Check yourself:** Which BaseCamp habit are you most tempted to drop now that nobody is checking?$md$),
  (1, 2, 'lesson', $md$Week 2: The Floor Loop at full speed$md$, $md$On the floor this week: In one session, deliberately slow down Beat 1. Before every correction, say to yourself what you actually noticed.$md$, $md$You learned the Floor Loop in Week 13: Notice, Read, Choose, Deliver, Confirm. You've drilled it and you've been reviewed in its language. This month the goal is speed and accuracy, because great coaches don't do something different. They run the same loop faster, read more precisely, and have more options at each beat.

Watch for the three ways the loop usually breaks.

**Skipping Notice.** You see a fault and fire a cue before you've seen what's actually happening. "She's lazy" isn't a notice. "She's moved slower every round" is. The first leads to a push. The second might lead to a question, because she might be under-recovered, or in pain, or dreading something after class.

**Using the same cue, louder.** Confirm told you it didn't land. Instead of going back to Choose, you repeat yourself with more volume. If a cue didn't work, the loop runs again with a different choice: a different cue type, a demo instead of words, a question instead of an instruction.

**Correcting more than three things.** When you're good at seeing, you see everything. Pick the one fault that matters most today and stop at three cues, preferably external ones ("push the floor away" beats "extend your knees"). And if a member says it feels wrong while it looks right, believe them and investigate.

Underneath the whole loop is one rule: it serves their goal, not your program. You're reading the person to help them climb their mountain, never to win the interaction.

**On the floor this week:** In one session, deliberately slow down Beat 1. Before every correction, say to yourself what you actually noticed.

**Check yourself:** Where did the loop break for you this week, and which beat should you have gone back to?$md$),
  (1, 3, 'lesson', $md$Week 3: Reading your own members$md$, $md$On the floor this week: Pick three members you think you know well. Write down their quadrant, likely drive, and trust pillar, then watch them for a week and see what you got wrong.$md$, $md$In BaseCamp you used the people-reading map on members you saw a few times a week. Now you have a group of people you coach regularly, and the map gets more useful and more dangerous.

The quick read still comes first. Pace (fast or deliberate) and orientation (task or feeling) give you a quadrant in about 30 seconds. Drivers want the headline, the standard, and the scoreboard. Expressives want enthusiasm, variety, and an audience of one. Analytics want the reason, the data, and time to process. Amiables want warmth, patience, and no public spotlight. The quadrant tells you how to package Tuesday's cue.

The deeper read takes months. What is this person protecting? The skeptic who must not be fooled. The achiever who must not fall behind. The anxious beginner who must not be embarrassed. The veteran who must not be condescended to. The drive tells you what to build for their year.

Then ask which kind of trust this person weighs most. Our starting guesses: Analytics are won with credibility, Amiables read intent, Expressives bond through commonality, and Drivers respect propriety and economy. You'll test these against real members.

Two rules matter more now that you know people well. Types are hypotheses, not verdicts. People change, and a hard month can make a Driver look like an Amiable. And read to serve, never to manipulate. The test: would you be comfortable if the member could hear your reasoning?

**On the floor this week:** Pick three members you think you know well. Write down their quadrant, likely drive, and trust pillar, then watch them for a week and see what you got wrong.

**Check yourself:** Which member did you misread, and what did it cost the session?$md$),
  (1, 4, 'lesson', $md$Week 4: Owning the session, start to finish$md$, $md$On the floor this week: For one full day, review every booked member's notes before each session and log your points of contact.$md$, $md$A Presenter delivers parts of a session. A Trainer owns the whole thing, including the parts that happen before and after the clock.

**Before.** Review the member notes for everyone booked, every session. Who mentioned a knee last week? Who's back after two weeks away? Who hit a PR? Two minutes of review changes the first thing you say to each person, and the first thing you say is most of what they remember.

**The warm-up is the first chapter.** It warms people up, primes the day's patterns, and sets the energy, and it's also your first read on how everyone is moving compared to their normal.

**During.** Aim for two or three real points of contact with every member during strength work and two during conditioning. A point of contact isn't "nice job." It's a cue, a question, or a specific observation about them.

**The close.** Never cut it. A quick recap, one thing to be proud of, and when you'll see them next. People remember how a session ended.

**After.** Notes within 24 hours, factual and useful to the next coach. Follow up with anyone who seemed off.

You've had one month of coaching on your own. Look back at your Week 1 film. The difference is the point.

**On the floor this week:** For one full day, review every booked member's notes before each session and log your points of contact.

**Check yourself:** Who did you have the fewest points of contact with this week, and why?$md$),
  (1, 5, 'lesson', $md$On the floor this month$md$, $md$Coach every session on your schedule independently, with two or three points of contact per member during strength work.$md$, $md$$md$),
  (1, 6, 'film', $md$Filmed session$md$, $md$Film one full session. Write your self-review in Floor Loop language before your mentor watches it, then paste the link.$md$, $md$$md$),
  (1, 7, 'homework', $md$People-reading map$md$, $md$For ten members you coach: quick read, likely drive, trust pillar, and one thing you will do differently for each.$md$, $md$$md$),
  (1, 8, 'huddle', $md$Mentor conversation$md$, $md$A 30-minute review of your film and your map.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (2, $md$Month 2$md$, $md$The Elevate MAP$md$, $md$Administering the assessment and placing someone in the Capability Hierarchy.$md$, $md$$md$, $md$Finish *Peak*.$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 2) then
    delete from public.path_tasks where unit_n = 2;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (2, 1, 'homework', $md$The work$md$, $md$Run three Elevate MAPs with a senior coach observing, scored accurately. Deliver one results conversation as coaching, not a report. Write up what you did and what you learned.$md$, $md$$md$),
  (2, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (2, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (3, $md$Month 3$md$, $md$Program design$md$, $md$Prioritize, plan, periodize, with the minimum effective dose calibrated to each person's purpose.$md$, $md$$md$, $md$$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 3) then
    delete from public.path_tasks where unit_n = 3;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (3, 1, 'homework', $md$The work$md$, $md$Write a four-week block for one member and defend every choice to your mentor. Pick your Capstone client this month. Write up what you did and what you learned.$md$, $md$$md$),
  (3, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (3, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$),
  (3, 4, 'lesson', $md$Certification$md$, $md$The second of CF-L1 or NASM-CPT begins (finish by month 9 of employment).$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (4, $md$Month 4$md$, $md$Individualizing inside the system$md$, $md$Modifications inside group and semi-private, deconditioned and formerly injured members, red flags, and when to refer up.$md$, $md$$md$, $md$Start *Bought In* (Bartholomew).$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 4) then
    delete from public.path_tasks where unit_n = 4;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (4, 1, 'homework', $md$The work$md$, $md$Keep a modification log for two weeks. Your Capstone client starts their 12-week program. Write up what you did and what you learned.$md$, $md$$md$),
  (4, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (4, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$),
  (4, 4, 'lesson', $md$Certification$md$, $md$The biomechanics slot, either Pre-Script L1 or BirdBox TCC Level 2, chosen for how you learn. Never both.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (5, $md$Month 5$md$, $md$The intake and the first 30 days$md$, $md$Owning Reclaim onboarding: intake, MAP, placement, the first habit, and the first 30 days of belonging. Motivational interviewing foundations (open questions, affirmations, reflections, summaries).$md$, $md$$md$, $md$$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 5) then
    delete from public.path_tasks where unit_n = 5;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (5, 1, 'homework', $md$The work$md$, $md$Two onboardings with a senior coach observing. Film one intake and score yourself on how well you drew out their purpose instead of assigning one. Write up what you did and what you learned.$md$, $md$$md$),
  (5, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (5, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$),
  (5, 4, 'lesson', $md$Certification$md$, $md$PN Level 1 or the HSN nutrition certification.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (6, $md$Month 6$md$, $md$The Capstone (Trainer gate)$md$, $md$One real member through intake, assessment, a 12-week program, and the delivered sessions.$md$, $md$Gate standard: rubric average of 3.5 or better with delivery rows at 4, three accurate MAPs, two supervised onboardings at 3 or better, and the Capstone defended.$md$, $md$$md$, true)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 6) then
    delete from public.path_tasks where unit_n = 6;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (6, 1, 'homework', $md$Capstone$md$, $md$Present the case to leadership: what you saw, what you chose, what happened, and what you'd change. Passing closes the floor-coaching curriculum. Write up what you did and what you learned.$md$, $md$$md$),
  (6, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (6, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (7, $md$Year 2, Q1$md$, $md$The other 23 hours$md$, $md$Behavior change as the product. Sleep, stress, nutrition, and daily life become part of how you coach, not a detour from it.$md$, $md$$md$, $md$*Atomic Habits* (Clear).$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 7) then
    delete from public.path_tasks where unit_n = 7;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (7, 1, 'homework', $md$The work$md$, $md$Run a six-pillar conversation with five members and agree on one small next step with each. Follow up every week for the quarter. Write up what you did and what you learned.$md$, $md$$md$),
  (7, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (7, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (8, $md$Year 2, Q2$md$, $md$Motivational interviewing$md$, $md$MI to working proficiency: open questions, reflections, drawing out change talk, and resisting the urge to fix.$md$, $md$$md$, $md$*Motivational Interviewing in Nutrition and Fitness* (Clifford and Curtis), suggested.$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 8) then
    delete from public.path_tasks where unit_n = 8;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (8, 1, 'homework', $md$The work$md$, $md$Film one real conversation with a member each month and score it against an MI checklist. Your mentor scores the third one. Write up what you did and what you learned.$md$, $md$$md$),
  (8, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (8, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (9, $md$Year 2, Q3$md$, $md$Nutrition coaching$md$, $md$Nutrition inside the house system: habits first, then hand portions, then precision tools only when they're earned. The coach side of the HSN app.$md$, $md$$md$, $md$$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 9) then
    delete from public.path_tasks where unit_n = 9;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (9, 1, 'homework', $md$The work$md$, $md$Coach three members through a nutrition habit for twelve weeks, logged in the app. Write up what you did and what you learned.$md$, $md$$md$),
  (9, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (9, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$),
  (9, 4, 'lesson', $md$Certification$md$, $md$HSN nutrition certification or PN Level 1, whichever wasn't done in Trainer.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (10, $md$Year 2, Q4$md$, $md$Consultations and ethical enrollment$md$, $md$Discovery calls and consultations on your own. Strategy sessions that help people make a decision that fits them, and handling objections without pressure.$md$, $md$$md$, $md$$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 10) then
    delete from public.path_tasks where unit_n = 10;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (10, 1, 'homework', $md$The work$md$, $md$Run consultations independently; the measure is consultations completed with a next step booked. Film one and review it with your GM. Write up what you did and what you learned.$md$, $md$$md$),
  (10, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (10, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (11, $md$Year 3, Q1$md$, $md$Individual design$md$, $md$Second chair on an individual-design client under a Professional. The communication rhythm: feedback daily, face time weekly, focus monthly.$md$, $md$$md$, $md$$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 11) then
    delete from public.path_tasks where unit_n = 11;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (11, 1, 'homework', $md$The work$md$, $md$Carry one individual-design client with a Professional reviewing every program and check-in. Write up what you did and what you learned.$md$, $md$$md$),
  (11, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (11, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$),
  (11, 4, 'lesson', $md$Certification$md$, $md$OPEX CCP begins (it may run into the Professional years).$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (12, $md$Year 3, Q2$md$, $md$Retention and hard conversations$md$, $md$Keeping members through life changes. At-risk outreach, the re-commitment conversation, and accountability that keeps the relationship intact. Avoidance isn't kindness.$md$, $md$$md$, $md$*The Anti-Hero Advantage* (Bartholomew).$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 12) then
    delete from public.path_tasks where unit_n = 12;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (12, 1, 'homework', $md$The work$md$, $md$Own the At Risk follow-up for your caseload for the quarter. Film or role-play two hard conversations. Write up what you did and what you learned.$md$, $md$$md$),
  (12, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (12, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$),
  (12, 4, 'lesson', $md$Live event$md$, $md$Art of Coaching Apprenticeship, attended in pairs.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (13, $md$Year 3, Q3$md$, $md$Recovery, pain, and referral$md$, $md$Coaching sleep, stress, and recovery, and knowing exactly when something belongs to a physical therapist, a physician, or MEDgevity.$md$, $md$$md$, $md$$md$, false)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 13) then
    delete from public.path_tasks where unit_n = 13;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (13, 1, 'homework', $md$The work$md$, $md$Build your own refer-up map with names and the words you'd use, and walk it through with your GM. Write up what you did and what you learned.$md$, $md$$md$),
  (13, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (13, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$),
  (13, 4, 'lesson', $md$Certification$md$, $md$PN Sleep, Stress Management and Recovery.$md$, $md$$md$);
  end if;
end $do$;

insert into public.path_units (n, label, title, focus, summary, reading, is_gate) values (14, $md$Year 3, Q4$md$, $md$Mentoring and the Coach gate$md$, $md$Developing the next coach. You mentor a Presenter or Instructor through at least one BaseCamp phase, including their film reviews.$md$, $md$Gate standard: retention and results across member types and formats; a caseload of 15 or more with documented outcomes and strong retention; consultations run independently; NCI Applied Nutrition Level 1 or equivalent; and a junior coach you've mentored consistently.$md$, $md$*Valued* (Bartholomew).$md$, true)
  on conflict (n) do update set label = excluded.label, title = excluded.title, focus = excluded.focus, summary = excluded.summary, reading = excluded.reading, is_gate = excluded.is_gate, updated_at = now();

do $do$ begin
  if not exists (select 1 from public.path_progress p join public.path_tasks t on t.id = p.task_id where t.unit_n = 14) then
    delete from public.path_tasks where unit_n = 14;
    insert into public.path_tasks (unit_n, sort, kind, title, details, body) values
  (14, 1, 'homework', $md$Coach gate$md$, $md$Mentor a Presenter or Instructor through at least one BaseCamp phase, including their film reviews, and bring your case for the Coach gate. Write up what you did and what you learned.$md$, $md$$md$),
  (14, 2, 'film', $md$Filmed review$md$, $md$Film one session or conversation from this unit. Write your self-review first, then paste the link.$md$, $md$$md$),
  (14, 3, 'huddle', $md$Mentor conversation$md$, $md$Review this unit with your mentor or GM before asking for sign-off.$md$, $md$$md$);
  end if;
end $do$;
