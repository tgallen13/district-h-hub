-- Month 6 of BaseCamp (weeks 21-24): full daily lessons from the
-- "BaseCamp Month 6: Daily Lessons" review doc (Oct 20, 2026), replacing the
-- placeholder tasks. Refuses to run if any intern already has progress in
-- weeks 21-24, so nobody's recorded work is lost.

do $chk$
begin
  if exists (select 1 from public.task_progress p join public.tasks t on t.id = p.task_id where t.week_n between 21 and 24) then
    raise exception 'Interns already have progress in weeks 21-24. Edit those weeks in the admin screen instead.';
  end if;
end $chk$;

delete from public.tasks where week_n between 21 and 24;

update public.weeks set title = $md$Solo sessions$md$, summary = $md$Week 21 is the first week you run whole sessions on your own, every day, with your mentor watching but not stepping in. Every system gets handled without anyone reminding you. The lessons turn to what happens between sessions, because that's where members are kept or lost.$md$, system_focus = $md$Recovr literacy: reading a member's recovery and readiness data before their session and letting it set the day's dial.$md$, updated_at = now() where n = 21;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (21, 1, 'lesson', $md$Monday: The whole session, alone$md$, $md$On the floor today: Before your first session, write down the one member you most want to reach today and why. After the session, note whether you did.$md$, $md$You've run warm-ups, then blocks, then full segments, then co-led sessions with your mentor silent. This week the whole session is yours, start to finish, every day.

It helps to think of a session as four parts, not one.

**Before.** Read the plan the night before and again that morning. Pull up every booked member's notes and their program in Semi-Private Pro. Know who's coming back from a bad week, who mentioned their knee, and who's close to a milestone. Set up the floor before the first member arrives.

**The open.** Purpose, process, payoff. What today is for, what we're doing, and what it'll feel like done right. Then greet everyone by name and get them moving.

**The work.** Every block run to the clock, every member reached, the right cue for the right person. The Floor Loop at full speed.

**The close and after.** A real close, never cut. Then the part nobody sees: session notes, Semi-Private Pro logs, and follow-ups, done the same day.

Your mentor is in the room this week, but they're watching, not helping. If something goes wrong, handle it the way you've been taught, and pull in a senior coach only when the situation calls for it. They'll tell you afterward what they saw.

The standard this week isn't a perfect session. It's a session you could run again tomorrow, and the day after, at the same level. That's what a coach the house can count on looks like.

**On the floor today:** Before your first session, write down the one member you most want to reach today and why. After the session, note whether you did.

**Check yourself:** Which of the four parts of a session is weakest for you when nobody is helping?$md$),
  (21, 2, 'lesson', $md$Tuesday: What happens between sessions$md$, $md$On the floor today: Pick two members from your sessions this week who've come less than usual, and send each one a short, specific message.$md$, $md$A member spends about three hours a week with us. The other 165 hours decide whether they keep coming.

Most members don't quit because of a bad session. They drift. A busy week turns into two, a missed Monday turns into a missed month, and one day they cancel without anyone having noticed they were leaving. Retention isn't a sales skill. It's noticing early and caring out loud.

Three habits do most of the work.

**Notice the pattern before it becomes a problem.** Someone who came four times a week and has come once in two weeks is telling you something. So is the member who used to stay and chat and now leaves the second the close ends.

**Reach out like a person.** A short, specific message beats a generic one every time. "Missed you Thursday, Dana. Hope the work trip went OK. Your front squats were really moving last week, so let's keep that going." No guilt, and no pitch.

**Close the loop.** If you said you'd check on something, check on it. If a member told you about a big week, ask how it went. Follow-through is how people learn they matter here.

The At Risk list and the Celebrations list in our system help, but they're a backstop. The best coaches notice before the list does.

**On the floor today:** Pick two members from your sessions this week who've come less than usual, and send each one a short, specific message.

**Check yourself:** Which member in your slots is drifting right now, and what's the first sign you noticed?$md$),
  (21, 3, 'lesson', $md$Wednesday: Reading recovery and readiness data$md$, $md$On the floor today: Check the recovery data for three members before their session, decide each one's dial, and compare with how they actually moved.$md$, $md$Recovr shows what happened to a member between sessions: sleep, recovery, readiness, and how their body is handling the load. This week you learn to read it before a session and let it shape the day.

The idea is simple. Two members can walk in with the same program on the same day and need different sessions. One slept seven hours and feels great. The other slept four hours, has a sick kid at home, and their readiness has been sliding all week. Pushing both of them the same way serves one and buries the other.

When you look at a member's data before their session, you're asking one question: what dial should today be on? Most days the answer is the plan as written. Some days it's pushing a little more because they're clearly fresh. Some days it's pulling back: lighter load, more rest, a different conditioning option.

Two cautions.

**The data informs. It doesn't decide.** A number is a reason to ask, not a verdict. "Your recovery's been low this week. How are you feeling today?" usually tells you more than the score does.

**Stay in scope.** You're reading readiness to choose the day's dial. You're not interpreting health data or diagnosing anything. If something looks concerning, mention it to the coach.

As a Presenter you learned that someone showing up flat might be under-recovered or might be dreading a meeting. Now you have a way to tell the difference before they walk in.

**On the floor today:** Check the recovery data for three members before their session, decide each one's dial, and compare with how they actually moved.

**Check yourself:** When the data said one thing and the member said another, which did you trust, and why?$md$),
  (21, 4, 'lesson', $md$Thursday: The quarterly client report$md$, $md$On the floor today: Write one session note today specific enough that it could go straight into a member's quarterly report.$md$, $md$Every quarter, members get a report on their progress: what they did, what changed, and what's next. You'll help write these once you're hired. This week you learn what goes into them, because everything you log feeds the report.

A good quarterly report answers three questions for the member.

**What did I do?** Attendance, consistency, and the work they put in.

**What changed?** Strength numbers, movement quality, recovery trends, and the things that don't show up on a scoreboard, like a hinge that no longer bothers their back or sleeping better since they started training in the mornings.

**What's next?** The focus for the next quarter, tied to what they told us matters to them.

Notice where all of that comes from. Attendance from our member records. Results and modifications from Semi-Private Pro. Recovery trends from Recovr. The things that don't show up on a scoreboard come from your session notes. If those notes say "good session," there's nothing to put in the report. If they say "first time she got through the warm-up without her knee bothering her," that line might be the most meaningful thing in it.

This is the clearest reason yet for why we're so particular about records. A note you write on a Tuesday in Week 21 can end up being the moment a member realizes how far they've come.

**On the floor today:** Write one session note today specific enough that it could go straight into a member's quarterly report.

**Check yourself:** If you had to write a report for one of your members tomorrow, what would be missing from your notes?$md$),
  (21, 5, 'lesson', $md$Friday: Every system, unprompted$md$, $md$On the floor today: Run the end-of-day routine before you leave, and time it.$md$, $md$This week every system gets handled without anyone asking: session notes in our member records, results and modifications in Semi-Private Pro, follow-ups sent and logged, discovery calls logged in Lead Connector, and film posted to Slack with your self-review first.

The word unprompted matters. At the Presenter gate, the records check came without warning. At the Instructor gate, the standard is higher. A coach who coaches beautifully and logs nothing is not at hiring standard. That sentence is in the gate for a reason.

Here's a simple end-of-day routine that keeps most people out of trouble.

1. Before you leave, open your schedule for the day and go member by member.
2. Session note written? Semi-Private Pro updated, including every modification?
3. Anyone you promised to follow up with? Send it now or schedule it.
4. Any calls you ran? Logged, with the next step and the pipeline stage?
5. Film from today posted with your self-review?

It takes ten to fifteen minutes. Skip it once and it takes an hour, because by tomorrow you won't remember the details. Skip it for a week and the records are gone.

The homework this week is two filmed full sessions. When you review them, review the trail too: everything that happened after the close.

**On the floor today:** Run the end-of-day routine before you leave, and time it.

**Check yourself:** Which system are you most likely to skip on a long day, and what will you do about it?$md$),
  (21, 6, 'lesson', $md$On the floor this week$md$, $md$Run full sessions on your own every day, under observation, with every system handled without being asked.$md$, $md$$md$),
  (21, 7, 'film', $md$Filmed rep$md$, $md$Two filmed full sessions, reviewed together with the records trail behind them.$md$, $md$$md$),
  (21, 8, 'homework', $md$Homework$md$, $md$Your end-of-day routine, written down and used every day this week.$md$, $md$$md$),
  (21, 9, 'huddle', $md$Huddle$md$, $md$Bring one member you reached out to between sessions this week and what happened.$md$, $md$$md$),
  (21, 10, 'lesson', $md$Reading$md$, $md$Conscious Coaching.$md$, $md$$md$);

update public.weeks set title = $md$Assessments and the mock gate$md$, summary = $md$Week 22 is the full rehearsal for the Instructor gate. You'll finish the Kolbe A and PI assessments, rerun the archetype drill, and have a month of your records reviewed like film. Then you run the mock gate. Whatever it shows, there are still two weeks to act on it.$md$, system_focus = $md$The systems hygiene audit: a month of session notes, Semi-Private Pro logs, and Slack posts, reviewed like film.$md$, updated_at = now() where n = 22;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (22, 1, 'lesson', $md$Monday: Kolbe and PI$md$, $md$On the floor today: Complete one of the two assessments today, in a quiet place, without rushing.$md$, $md$Before the gate panel, you'll complete two assessments: the Kolbe A Index and the PI Behavioral Assessment. Neither is pass or fail. Nobody gets hired or turned away because of a result.

They measure different things.

**Kolbe A** looks at how you naturally take action when you're solving a problem. Do you dig into detail before you start, or jump in and figure it out as you go? Do you like to build a system, or improvise?

**PI Behavioral** looks at your behavioral drives: how much you like to lead or support, how much you want variety or steadiness, how much you lean toward people or toward the task.

At the gate, the leadership panel will talk through your results with you. The purpose is to understand you better: how you'll work best on our team, what kind of support helps you, and where your natural style will make the work easier or harder. A coach whose drives pull toward fast action might need help slowing down for notes. A coach who loves structure might need practice with sessions that go off-plan.

Take them honestly. There's no right profile to aim for, and trying to answer the way you think a coach should only makes the conversation less useful.

One note on language. Kolbe and PI stay in the hiring room. On the floor, we use our own vocabulary for reading members: the people-reading map and the archetypes you learned this phase.

**On the floor today:** Complete one of the two assessments today, in a quiet place, without rushing.

**Check yourself:** Before you see your results, what do you expect them to say about how you work?$md$),
  (22, 2, 'lesson', $md$Tuesday: The archetype drill, rescored$md$, $md$On the floor today: Pick two members with very different styles and give each the same correction in the way that fits them. Note what you changed.$md$, $md$In Week 16 you filmed the archetype drill: the same correction coached to two very different members, reviewed entirely on how your delivery changed and whether each one landed. This week you do it again, and it's scored the way it will be at the gate.

The drill is the clearest test of the Instructor phase. Presenter taught you to connect with a room. Instructor taught you to communicate with a person. If the same correction sounds identical to an analytical member who wants the reason and to a member who mainly wants to feel safe, the drill shows it right away.

What the reviewers look for:

- **The read.** Did you correctly notice what each member needed from you before you spoke?
- **The choice.** Did the package change: the words, the amount of detail, the tone, public or private, demo or explanation?
- **The landing.** Did each correction actually change the rep? And when it didn't, did you go back and choose differently instead of repeating yourself louder?

Compare this week's film to your Week 16 film before you hand it in. The improvement between the two is part of the evidence for the gate.

**On the floor today:** Pick two members with very different styles and give each the same correction in the way that fits them. Note what you changed.

**Check yourself:** What's the biggest difference between your Week 16 drill and this one?$md$),
  (22, 3, 'lesson', $md$Wednesday: A month of records, reviewed like film$md$, $md$On the floor today: Before your mentor starts the audit, audit one week of your own records and write down what you find.$md$, $md$This week is the systems hygiene audit. Your mentor reviews a full month of your session notes, your Semi-Private Pro logs, and your Slack posts, the same way they review your film.

A spot-check looks at a sample. An audit looks at everything, which means it finds patterns a sample misses: the Fridays where notes got thin, the modifications that were made on the floor but never logged, the follow-ups promised and never sent.

Here's what the audit asks, record by record.

- **Is it there?** A note for every segment, a log for every semi-private session, and every result and modification recorded.
- **Is it useful?** Would the next coach know what to do with it?
- **Is it on time?** Same day.
- **Does it match the floor?** If your film shows a modification, your log should too.

The last question is the important one. An unrecorded scale is invisible to the next coach. A member who had their split squat swapped on Tuesday can get the wrong version on Thursday because nobody wrote it down.

If the audit finds gaps, fill in what you honestly can, label it as added late, and fix the habit behind it. Never backdate, and never invent details you don't remember.

**On the floor today:** Before your mentor starts the audit, audit one week of your own records and write down what you find.

**Check yourself:** What pattern did the audit show you that a single spot-check never would have?$md$),
  (22, 4, 'lesson', $md$Thursday: The Instructor mock gate$md$, $md$On the floor today: After the mock gate, write down your two lowest rows and the specific thing you'll do about each one every day until Week 24.$md$, $md$Today you run the Instructor gate once, for real, except that it doesn't count.

You'll run a full solo session, filmed. Your mentor scores it on the gate rubric, including the full operational trail behind it: the notes, the Semi-Private Pro logs, and the follow-ups. Then you sit down together and go through every row.

The Instructor rubric asks more than the Presenter rubric did. It still scores safety, presence, and connection. Now it also scores whether you can teach a movement, see what's actually happening, correct it with the right cue, tailor your delivery to the person, manage a room of people doing different things, and leave a complete trail behind you.

Treat it exactly like the real gate. Same preparation, same standard, no do-overs. How you handle the moment something goes wrong is part of what's being scored.

The no-surprises rule applies here too. If your mentor expects a "not yet" at Week 24, you'll hear it now, with the reasons and a plan. Two weeks is enough time to change a lot, especially when you know exactly what to work on.

**On the floor today:** After the mock gate, write down your two lowest rows and the specific thing you'll do about each one every day until Week 24.

**Check yourself:** Which row surprised you, in either direction?$md$),
  (22, 5, 'lesson', $md$Friday: Using the time well$md$, $md$On the floor today: Write a one-paragraph plan for the next two weeks and share it with your mentor.$md$, $md$Week 22 is built to flex. If the mock gate showed gaps, the rest of this week and next week are for closing them.

The interns who close gaps fastest tend to do the same few things.

**They narrow the target.** Not "get better at cueing," but "one cue per correction, external first, and stop talking after it."

**They practice on purpose.** Every session becomes a rep on the weak row. If it's the trail, they run the end-of-day routine before leaving, every single day. If it's tailoring, they pick two members per session to deliberately adjust for.

**They make the change visible.** They tell their mentor what they're working on and ask for one observation a day on it.

**They film it.** A short clip of the weak row, reviewed the same day, beats a long session reviewed a week later.

If the mock gate went well, the job is different but just as important: don't coast. The gate is two weeks away, and the trail is where strong coaches most often slip when they feel ready.

Either way, this is the last stretch of BaseCamp. The habits you build in these two weeks are the ones you take into your first months on the job.

**On the floor today:** Write a one-paragraph plan for the next two weeks and share it with your mentor.

**Check yourself:** What's the one change that would move your score the most if you made it every day?$md$),
  (22, 6, 'lesson', $md$On the floor this week$md$, $md$Keep running full sessions on your own every day. Run the mock gate session on Thursday.$md$, $md$$md$),
  (22, 7, 'film', $md$Filmed rep$md$, $md$Your mock gate session and your rescored archetype drill.$md$, $md$$md$),
  (22, 8, 'homework', $md$Homework$md$, $md$Kolbe A and PI Behavioral completed, plus your two-week plan from the mock gate.$md$, $md$$md$),
  (22, 9, 'huddle', $md$Huddle$md$, $md$Bring the one row you're working hardest on before the gate and ask the group for one idea.$md$, $md$$md$),
  (22, 10, 'lesson', $md$Reading$md$, $md$Conscious Coaching.$md$, $md$$md$);

update public.weeks set title = $md$Teach-back and polish$md$, summary = $md$In Week 23 you teach the staff. You'll lead a full staff huddle on a topic drawn from your strongest film moment. You'll also have your final discovery-call evaluation, score yourself against the Instructor rubric, and answer the Field Guide prompt about where you honestly are right now.$md$, system_focus = $md$Discovery-call logging, reviewed as part of your final call evaluation: notes, next step, pipeline stage, and follow-up.$md$, updated_at = now() where n = 23;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (23, 1, 'lesson', $md$Monday: Teaching your coaches$md$, $md$On the floor today: Go through your BaseCamp film and shortlist three moments where something went right. Write one sentence on why each one worked.$md$, $md$This week you lead a full staff huddle. Every coach in the room, including your mentor and people who have been coaching for years, will be learning from you for that hour.

That can feel backwards. You're the newest person on the floor. But the teach-back isn't asking you to know more than they do. It's asking you to take one thing you do well, understand why it works, and explain it clearly enough that someone else can use it. That's a different skill from coaching, and it's the beginning of the one that matters most later in your career: developing other coaches.

Pick your topic from your strongest film moment. Look back through your BaseCamp film and find the clip where something went really right. Maybe it's a correction that landed on a member who'd struggled for weeks, a sideways moment you handled cleanly, or the way you reached a quiet member. Then ask why it worked. The answer to that question is your huddle.

Good teach-back topics are narrow. "How I get the quiet member talking in the first five minutes" is a better huddle than "Connection." A narrow topic gives you room to show film, explain your reasoning, and let the group try it.

The experienced coaches in the room aren't there to judge you. Most of them remember their first teach-back, and they want it to go well. Some of them will learn something.

**On the floor today:** Go through your BaseCamp film and shortlist three moments where something went right. Write one sentence on why each one worked.

**Check yourself:** Which of your three moments would be most useful to a coach who's been here five years?$md$),
  (23, 2, 'lesson', $md$Tuesday: Building the teach-back$md$, $md$On the floor today: Draft your teach-back outline: purpose in two sentences, the clip and where you'll pause it, the group activity, and the payoff.$md$, $md$A teach-back runs about 15 to 20 minutes of the huddle, with time for the group to talk. The structure is the same one you've used to open sessions all phase: purpose, process, payoff.

**Purpose.** In one or two sentences, what is this, and why should a busy coach care? "Most of us lose the quiet member without noticing. Here's what I've been doing about it."

**Process.** Show it. Play the clip. Pause it at the moment that matters and explain what you noticed, what you chose, and why. Then give the group a way to try it: a role-play in pairs, or a question to answer about their own members.

**Payoff.** What will they see if they use it? Be honest about the limits, too. "This works best with members who are new. It didn't work at all with one veteran, and here's what I think happened."

A few things that make teach-backs land:

- One idea, not five.
- Real film beats description.
- Ask the room a question early, so it's a conversation and not a lecture.
- End on time.

You already did a version of this when you taught back your speaking workshop. This one is bigger because the topic is yours and the evidence is your own coaching.

**On the floor today:** Draft your teach-back outline: purpose in two sentences, the clip and where you'll pause it, the group activity, and the payoff.

**Check yourself:** What question will you ask the room in the first two minutes?$md$),
  (23, 3, 'lesson', $md$Wednesday: Your final discovery-call evaluation$md$, $md$On the floor today: Before your evaluated call, reread the caller's intake form and write down what you expect their real why to be. After the call, compare.$md$, $md$This week your mentor evaluates one of your discovery calls for the last time before the gate. At Week 24, part of the gate is a discovery-call sign-off, including how the call was logged.

You've run calls since Week 10, so the structure should feel natural by now: the frame, their why, training history, aches and pains, consistency, support, success a year from now, and the next step. The evaluation looks past the structure to the things that separate a good call from a great one.

- **Whose agenda ran the call?** The caller should do most of the talking.
- **Did you find the real why?** Not the first answer, but the reason underneath it.
- **Did you sort by complexity?** Was the next step chosen because of what they need, not what's easiest to sell?
- **Intent.** Could they tell you cared more about getting it right for them than about the outcome for us?
- **The log.** Notes, next step, pipeline stage, and follow-up, all done the same day.

The log isn't a footnote. A great call with no record behind it fails the sign-off. A coach who connects beautifully and leaves nothing for the next person isn't at hiring standard on calls any more than on the floor.

**On the floor today:** Before your evaluated call, reread the caller's intake form and write down what you expect their real why to be. After the call, compare.

**Check yourself:** On your last three calls, how often did the next step match what the person told you they needed?$md$),
  (23, 4, 'lesson', $md$Thursday: Scoring yourself against the Instructor rubric$md$, $md$On the floor today: Score yourself on the rubric's tailoring row using only your two archetype drill films as evidence.$md$, $md$Before the gate, you score yourself against the Instructor rubric, row by row, with evidence. Your mentor does the same, separately, and then you compare.

The point isn't to guess the score you'll get. It's to show that you can see your own coaching clearly. A coach who can look at their own film honestly and name what's strong and what isn't will keep improving long after BaseCamp, when nobody is reviewing every session.

For each row, write:

- **Your score**, from 1 to 5.
- **Your evidence.** A specific film moment, a record, or a call. Not a feeling.
- **What would move it up one point.**

Watch for the two usual mistakes. Some people score themselves low everywhere to look humble, and that's no more accurate than scoring high everywhere. The other mistake is giving yourself credit for what you intend to do instead of what's on the film.

When your scores and your mentor's differ, that's the most useful part. Usually one of you saw something the other missed. Find out which.

**On the floor today:** Score yourself on the rubric's tailoring row using only your two archetype drill films as evidence.

**Check yourself:** Where do you expect your score and your mentor's to differ most, and why?$md$),
  (23, 5, 'lesson', $md$Friday: Where you are, honestly$md$, $md$On the floor today: Write your Prompt 13 answer with at least three pieces of evidence from your film or records.$md$, $md$This week you also answer Prompt 13 from your Field Guide Worksheet, earlier than you otherwise would: which tier are you on right now, and what's the evidence?

You know the five stages: Presenter, Instructor, Trainer, Coach, Professional. You also know they aren't titles. Each one is a different relationship to the work. Answering honestly means looking at what you actually do on the floor, not what you understand or intend.

Most interns at Week 23 are solidly Presenter and becoming Instructor: they can carry a room, and they're getting reliable at teaching movement and tailoring to the person. Some have a few Trainer moments. Very few are further along than that, and that's exactly as it should be. Getting genuinely good at this takes about five years, the way a trade does.

The gate panel will ask about this answer. They're not looking for a particular tier. They're looking for whether your answer matches your film, and whether you know what the next stage asks of you.

One more thing to prepare this week. At the panel, you'll look back at the Prompt 0 answer you wrote before you started BaseCamp. Read it again before Week 24, and think about what's changed in how you see this work.

**On the floor today:** Write your Prompt 13 answer with at least three pieces of evidence from your film or records.

**Check yourself:** What's one thing a Trainer does that you don't do yet?$md$),
  (23, 6, 'lesson', $md$On the floor this week$md$, $md$Keep running full sessions on your own every day. Run your evaluated discovery call.$md$, $md$$md$),
  (23, 7, 'film', $md$Filmed rep$md$, $md$Your evaluated discovery call, plus the film clip you'll use in your teach-back.$md$, $md$$md$),
  (23, 8, 'homework', $md$Homework$md$, $md$Your self-assessment against the Instructor rubric, and your Prompt 13 answer with evidence.$md$, $md$$md$),
  (23, 9, 'huddle', $md$Huddle$md$, $md$Your teach-back. You lead the full staff huddle on a topic from your strongest film moment.$md$, $md$$md$),
  (23, 10, 'lesson', $md$Reading$md$, $md$Conscious Coaching, plus your Prompt 0 answer before the gate.$md$, $md$$md$),
  (23, 11, 'lesson', $md$Certification: CF-L2$md$, $md$Attend your CrossFit Level 2 course this week (or the closest available date). Its group-coaching assessment is good preparation for the Instructor gate. Bring the takeaways to a huddle within 30 days.$md$, $md$$md$);

update public.weeks set title = $md$The Instructor gate$md$, summary = $md$This is the last week of BaseCamp. You'll run a full solo session on film with the complete records trail behind it, run the archetype drill one more time, get signed off on discovery calls, and sit down with the leadership panel: Morrill, Tommy, Dustin, Christy, and Jonathan. The Instructor gate is the hiring decision.$md$, system_focus = $md$The complete operational trail, reviewed without warning after your gate session: session notes, Semi-Private Pro logs, follow-ups, and call logs.$md$, updated_at = now() where n = 24;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (24, 1, 'lesson', $md$Monday: What the Instructor gate decides$md$, $md$On the floor today: Read the plan for your gate session and pull every booked member's notes and program, the way you will on the day.$md$, $md$The Presenter gate asked whether you could carry a room. The Instructor gate asks something bigger: would we trust you to coach our members, on your own, as a member of this team?

It answers that with four kinds of evidence.

**The solo session.** A full session, run by you, filmed, and scored on the Instructor rubric: teaching, seeing, correcting, tailoring to the person, managing the room, and safety.

**The trail behind it.** Every note, every Semi-Private Pro log, every follow-up. A coach who coaches beautifully and logs nothing is not at hiring standard. That line is in the gate because the whole house depends on any coach being able to pick up where you left off.

**The archetype drill and the call sign-off.** The same correction to two different members, and a discovery call that's run well and logged completely.

**The panel.** A conversation with the leadership panel about who you are as a coach and where you're headed.

The rubric runs from 1 to 5, the same as before. To pass, no row is below 3 and the safety row has zero flags. A safety concern or a values concern is enough on its own to mean not yet.

None of this is new. Every piece of the gate is something you've done for weeks. The gate just asks you to do it all at once, at the standard, without help.

**On the floor today:** Read the plan for your gate session and pull every booked member's notes and program, the way you will on the day.

**Check yourself:** Which part of the gate do you feel most ready for, and which least?$md$),
  (24, 2, 'lesson', $md$Tuesday: The solo session and its trail$md$, $md$On the floor today: Run today's session as a full dress rehearsal, including the end-of-day routine, and time how long the trail takes.$md$, $md$Your gate session is a normal session. Same plan, same members, same floor. That's on purpose: we want to see how you coach on an ordinary day, because ordinary days are most of the job.

Prepare the way you've prepared all month. Read the plan the night before and again that morning. Review every booked member's notes, their program in Semi-Private Pro, and their readiness data. Set up the floor early.

During the session, the reviewers will be watching for the Instructor skills you've built all phase:

- **Teaching.** Tell, show, do, with the purpose clear.
- **Seeing.** Noticing what's actually happening before deciding what it means.
- **Correcting.** One cue at a time, the right type for the person, and checking that it landed.
- **Tailoring.** Different members getting the delivery they need.
- **The room.** Every member reached, the clock kept, and the close never cut.

After the session, the trail gets reviewed without warning. Notes written the same day, every modification logged in Semi-Private Pro, and follow-ups sent or scheduled. Run your end-of-day routine exactly like you have every day since Week 21.

If something goes sideways mid-session, handle it the way you were taught. The reviewers aren't looking for a session where nothing goes wrong. They're looking for a coach who handles it well when something does.

**On the floor today:** Run today's session as a full dress rehearsal, including the end-of-day routine, and time how long the trail takes.

**Check yourself:** If your gate session were today, what would the trail check find?$md$),
  (24, 3, 'lesson', $md$Wednesday: The panel$md$, $md$On the floor today: Write one or two sentences for each of the seven whys, using something from your BaseCamp experience as evidence for each.$md$, $md$The panel is a conversation with the leadership team: Morrill, Tommy, Dustin, Christy, and Jonathan. It's less about your coaching skills, which the session and the drill already show, and more about who you are as a coach and whether this is the right place and path for you.

Expect three parts.

**Your Kolbe and PI results.** You'll talk through what they say about how you work, where your natural style helps, and where you'll need support. There's no right profile.

**The seven whys.** Your purpose, vision, mission, values, principles, the outcomes you want, and your coaching personality. You first talked about these on your Professional Path Call. Now you have six months of evidence to answer them with.

**Prompt 0 and now.** The panel will look at the answer you wrote before you started BaseCamp, and ask what's changed.

The best preparation is honesty. The panel has seen your film, your records, and your mentor's reviews. They're not trying to catch you out. They want to understand how you think about this work, what you want from it, and whether it fits what District H asks of its coaches.

It's also your chance to ask questions. This is a two-way decision. If you're hired, you're committing to a multi-year climb with us. Ask about anything that matters to you.

**On the floor today:** Write one or two sentences for each of the seven whys, using something from your BaseCamp experience as evidence for each.

**Check yourself:** Which of the seven whys is hardest for you to answer, and why?$md$),
  (24, 4, 'lesson', $md$Thursday: Prompt 0 and now$md$, $md$On the floor today: Write a half-page response to your own Prompt 0 answer, as if you were writing to the person who wrote it.$md$, $md$Before you started BaseCamp, you answered Prompt 0 from the Field Guide Worksheet. At the panel, you'll put that answer next to who you are now.

Read it again this week, slowly. Most people react in one of two ways. Some are surprised by how much they've changed: what they thought coaching was, what they thought they'd be good at, why they wanted to do it. Others are surprised by how much they haven't, and find that the reason they started is still the reason they're here, only clearer.

Both are good answers. What the panel wants to hear is the honest one.

A few questions that help:

- What did you think the job was when you wrote this? What do you think it is now?
- What were you right about? What were you wrong about?
- What's harder than you expected? What's more rewarding?
- If you could tell the person who wrote Prompt 0 one thing, what would it be?

There's a reason we bookend BaseCamp this way. This program was built either to commit you or to be honest enough that you choose differently. Looking at where you started, and where you are now, is how you find out which one happened.

**On the floor today:** Write a half-page response to your own Prompt 0 answer, as if you were writing to the person who wrote it.

**Check yourself:** What were you most wrong about when you started?$md$),
  (24, 5, 'lesson', $md$Friday: What comes next$md$, $md$On the floor today: Thank your mentor, specifically, for one thing they did that changed how you coach.$md$, $md$At the end of the gate, you'll hear one of three outcomes.

**Pass.** You're hired into Coach I. Your role changes in the hub, and My Path opens: the Trainer phase starts with Month 1, where you learn to own the floor on your own. The first lesson is about the hardest part of being hired, which is keeping every standard when nobody is checking anymore.

**Not yet.** One or more rows aren't at the standard. You'll get specific reasons, a written plan, and a date to re-gate. You keep working on the floor while you close the gap. Strong coaches sometimes need a second attempt, and what matters is how you use the time.

**Parting well.** Sometimes the gate makes it clear that this path isn't the right fit. If that happens, it'll be an honest, respectful conversation, never a sudden one, and we'll help you figure out what comes next. Some people finish BaseCamp and decide they'd rather train than coach. That's a respectable outcome, and leaving well matters to us.

Whatever the outcome, look at what you've built in 24 weeks. You learned to carry a room, then to communicate with a person. You can teach movement, see faults, tailor your delivery, run a session on your own, take discovery calls, and leave a trail the next coach can trust.

That's the end of BaseCamp. If you're hired, it's also the start of a five-year climb, and the next stretch is yours.

**On the floor today:** Thank your mentor, specifically, for one thing they did that changed how you coach.

**Check yourself:** What's the first thing you want to work on in the Trainer phase?$md$),
  (24, 6, 'lesson', $md$On the floor this week$md$, $md$Your gate session: a full solo session, filmed, with every system handled. Keep running full sessions every day.$md$, $md$$md$),
  (24, 7, 'film', $md$Filmed rep$md$, $md$Your gate session and your final archetype drill.$md$, $md$$md$),
  (24, 8, 'homework', $md$Homework$md$, $md$Your seven whys and your response to your own Prompt 0 answer, ready for the panel.$md$, $md$$md$),
  (24, 9, 'huddle', $md$Huddle$md$, $md$Share the one moment from BaseCamp that changed how you coach.$md$, $md$$md$),
  (24, 10, 'lesson', $md$Reading$md$, $md$Your Prompt 0 answer, one more time before the panel.$md$, $md$$md$),
  (24, 11, 'huddle', $md$The Instructor gate$md$, $md$Your gate conversation with Morrill, Tommy, Dustin, Christy, and Jonathan. Read what it scores.$md$, $md$A working draft until the Instructor rubric is finished. Each row is scored 1 (unsafe or absent) to 5 (an example for others). To pass: no row below 3, the safety row at 3 or better with zero flags, and sign-off from the leadership panel. A safety flag or a values concern is enough on its own to mean not yet.

- **Teaching.** Gate session film (3 or better)
- **Seeing and correcting.** Gate session film (3 or better, cues land)
- **Tailoring.** Gate session film and the archetype drill (3 or better, delivery changes by person)
- **Managing the room.** Gate session film (3 or better, every member reached, close never cut)
- **Safety.** Gate session film and floor record (3 or better, zero flags)
- **Operational trail.** Unprompted records check (Complete, specific, same day)
- **Discovery calls.** Final call evaluation and Lead Connector logs (Signed off, including logging)
- **Certification.** Records (CF-L1 or NASM-CPT complete, speaking workshop teach-back delivered)
- **Teach-back.** Staff huddle (Delivered)
- **Personal practice.** Training log and HSN tracking (Current)
- **Values.** Mentor and every senior coach worked with (No concerns)
- **The panel.** Kolbe and PI discussion, the seven whys, Prompt 0 and now (A clear fit for the path)

Outcome: hired into Coach I, and My Path opens. Or not yet, with a written plan and a date to re-gate. Or parting well, with an honest conversation and help with what comes next.$md$);
