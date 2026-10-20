-- Month 5 of BaseCamp (weeks 17-20): full daily lessons from the
-- "BaseCamp Month 5: Daily Lessons" review doc (Oct 20, 2026), replacing the
-- placeholder tasks. Refuses to run if any intern already has progress in
-- weeks 17-20, so nobody's recorded work is lost.

do $chk$
begin
  if exists (select 1 from public.task_progress p join public.tasks t on t.id = p.task_id where t.week_n between 17 and 20) then
    raise exception 'Interns already have progress in weeks 17-20. Edit those weeks in the admin screen instead.';
  end if;
end $chk$;

delete from public.tasks where week_n between 17 and 20;

update public.weeks set title = $md$The speaking workshop$md$, summary = $md$Week 17 is built around your speaking workshop, usually Art of Coaching Speaker School, sometimes The Apprenticeship. You'll go with a partner from the cohort where we can make that work. We send you because commanding a room is part of the hiring standard at Week 24, and because the best way to get better at speaking is to do it in front of people who coach speakers for a living. The lessons this week help you get the most out of it and bring it home.$md$, system_focus = $md$No new system. Keep your PushPress notes and Semi-Private Pro logs current while you're away and the day you're back.$md$, updated_at = now() where n = 17;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (17, 1, 'lesson', $md$Monday: Why we send you$md$, $md$On the floor today: Watch your last filmed session open with the sound on and write down the one speaking habit you most want to change.$md$, $md$For sixteen weeks you've been speaking to rooms: warm-up instructions, whiteboard briefs, the open and the close. Most of that has been short, scripted, and in a room full of people who already know you. A speaking workshop stretches that muscle further than the gym can on its own.

We don't send people to events as a perk. Every event in your development is chosen because your film or your reviews show it's the next thing that will move you. For nearly every intern at this stage, that thing is the ability to hold attention for longer than a few minutes and to say something clearly enough that people remember it.

That skill shows up everywhere in a coaching career. It's the session open that gets a tired 6 a.m. class bought in. It's the consultation where a nervous new member decides to trust you. Later it's the staff huddle you lead, the workshop you run for members, and maybe the talk you give to other coaches.

Go in with a goal. Look back at your last three film reviews and pick the one speaking habit that keeps coming up. Maybe you rush, maybe you trail off at the end of sentences, maybe you over-explain. Write it down and bring it with you. A workshop gives you a lot, and the people who get the most out of it are the ones who arrive knowing what they need.

**On the floor today:** Watch your last filmed session open with the sound on and write down the one speaking habit you most want to change.

**Check yourself:** What would it look like in a session if the workshop worked?$md$),
  (17, 2, 'lesson', $md$Tuesday: The shape of a talk$md$, $md$On the floor today: Plan a two-minute talk on one movement you coach well, using one idea, one example, and one ask.$md$, $md$Every good talk, short or long, has a shape you can learn. You already know a small version of it from the session open: purpose, process, payoff. Say why we're here, what we're going to do, and what it will feel like when it's done right.

Longer talks use the same bones with more room.

**Start with the person, not the topic.** Who's listening, what do they already believe, and what do they need from you? A talk on squatting for new members and a talk on squatting for coaches are different talks, even with the same slides.

**One idea.** If someone remembers only one sentence, what should it be? Build everything else to support it. Most weak talks have five ideas fighting for the same ten minutes.

**A story or an example early.** People remember stories long after they forget points. A real member (with their permission, or with details changed), a real moment from the floor, or a mistake you made.

**Then the teaching.** The points that support your one idea, each with something concrete attached.

**Then the ask.** What do you want them to do differently tomorrow? Make it small and specific.

This is the same shape the workshop will teach in more depth. Knowing it going in means you'll spend the workshop refining it instead of meeting it for the first time.

**On the floor today:** Plan a two-minute talk on one movement you coach well, using one idea, one example, and one ask.

**Check yourself:** What's the one sentence you'd want a member to remember from your last session open?$md$),
  (17, 3, 'lesson', $md$Wednesday: Being coached in public$md$, $md$On the floor today: Ask your mentor for one piece of feedback on your speaking in front of another coach, and respond with only "Thanks, got it."$md$, $md$At a speaking workshop you'll stand up in front of strangers, speak, and get feedback on the spot, often with everyone watching. For most people that's uncomfortable, and it's meant to be.

You've been practicing for this since Week 8 without knowing it. The rule is the same one: "Thanks, got it." Take the note, write it down, and try it on the next rep. Don't explain why you did what you did. Nobody needs the backstory. They need to see whether you can change.

A few things help.

**Volunteer early.** The waiting is worse than the speaking. Going early also means you get more reps over the course of the workshop.

**Watch everyone else closely.** You'll learn as much from other people's feedback as from your own. When a coach gets a note, ask yourself whether you do the same thing.

**Notice how the coaches coach.** Pay attention to how the workshop leaders give feedback: how they open, how specific they are, and how they keep people willing to try again. That's a model for how you'll give feedback to members, and someday to the coaches you mentor.

**Be the partner who helps.** If you're attending with someone from the cohort, watch each other's reps and compare notes each evening. Two people bringing the same workshop home are much harder to ignore than one.

**On the floor today:** Ask your mentor for one piece of feedback on your speaking in front of another coach, and respond with only "Thanks, got it."

**Check yourself:** What's your honest first reaction when someone corrects you in front of others?$md$),
  (17, 4, 'lesson', $md$Thursday: Return and teach$md$, $md$On the floor today: Book your teach-back huddle date with your mentor and put it on the calendar.$md$, $md$Every live event in your development comes with one rule: within 30 days, you teach what you learned at a huddle. You'll book that huddle date before you leave for the workshop.

The return-and-teach rule exists for three reasons. Teaching something is the fastest way to find out whether you actually understood it. It means the whole team gets value from the event, not only the people who went. And it's practice for the job you're growing into, because Coaches and Professionals spend a lot of their time teaching other coaches.

A good teach-back isn't a summary of the workshop. Nobody needs a list of everything that was covered. Pick the one idea that changed how you'll coach, show it, and ask the team to try it.

A simple structure for a 15-minute teach-back:

- **The one idea.** What it is, in a sentence.
- **Why it matters on our floor.** A moment from a real session where it would have helped.
- **Show it.** Demonstrate it, or play a short clip of yourself before and after.
- **Let them try it.** Two minutes of practice in pairs.
- **The ask.** One thing to do differently this week.

Write notes during the workshop with this structure in mind. At the end of each day, write down the moment that hit hardest and why. By the time you're home, your teach-back is mostly written.

**On the floor today:** Book your teach-back huddle date with your mentor and put it on the calendar.

**Check yourself:** Of everything you expect to learn, what do you think will be hardest to teach someone else?$md$),
  (17, 5, 'lesson', $md$Friday: Bringing it to the floor$md$, $md$On the floor today: Name your one workshop habit, tell your mentor, and use it in every session you lead today.$md$, $md$The week after a workshop is when most of the value is won or lost. The ideas are fresh and you're motivated. Then real sessions start, the old habits come back, and three weeks later almost nothing has changed.

The way around that is to pick one thing and practice it on purpose, every session, until it's automatic. Not five things. One. You'll still have your notes for the rest.

Tell your mentor what you're working on so they can watch for it. Film a session open the first week back and compare it with the one you watched on Monday. Put the new habit into your floor journal every day, with a quick note on whether it showed up.

Also watch for overcorrecting. A lot of people come back from a speaking workshop and talk more, because they're excited about their new skills. Members came to train, not to listen to a talk. The goal is to say less, more clearly, with more presence, not to turn every warm-up into a keynote.

If your cohort includes someone who went to a different event, like a BirdBox seminar, compare notes. Different events often teach the same core ideas in different words, and seeing the overlap helps both of you remember them.

**On the floor today:** Name your one workshop habit, tell your mentor, and use it in every session you lead today.

**Check yourself:** A week from now, how will you know whether the workshop changed anything?$md$),
  (17, 6, 'lesson', $md$On the floor this week$md$, $md$Lead your usual sessions around the workshop dates. The first week back, use your one workshop habit in every session.$md$, $md$$md$),
  (17, 7, 'film', $md$Filmed rep$md$, $md$Film a session open before the workshop and another after it, and compare them.$md$, $md$$md$),
  (17, 8, 'homework', $md$Homework$md$, $md$Your workshop goal (the one speaking habit you're working on), your return-and-teach huddle date booked, and your daily workshop notes.$md$, $md$$md$),
  (17, 9, 'huddle', $md$Huddle$md$, $md$Share your workshop goal with the group, or, if you've already been, the one moment that hit hardest.$md$, $md$$md$),
  (17, 10, 'lesson', $md$Reading$md$, $md$Conscious Coaching and your certification text.$md$, $md$$md$);

update public.weeks set title = $md$When the session goes off-plan$md$, summary = $md$In Week 9 you learned to keep the room moving when logistics go sideways: a late member, missing equipment. Week 18 is the Instructor version. The plan meets a person whose body, energy, or week doesn't match what was written, and you have to decide in real time what to keep, what to change, and what to hand up. Full-session ops begin this week, and your mentor will deliberately throw disruptions at you.$md$, system_focus = $md$Full-session ops begin: roster, setup, every note, and every Semi-Private Pro modification logged the same day.$md$, updated_at = now() where n = 18;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (18, 1, 'lesson', $md$Monday: Guardrails with room to flex$md$, $md$On the floor today: Make one deliberate adjustment inside the guardrails for one member, and log what you changed and why in Semi-Private Pro or PushPress.$md$, $md$A session plan isn't a script you recite. It's a set of guardrails. Inside them, you have room to adapt for the person in front of you. Outside them, you hand it up.

The things you hold firm:

- **The intended stimulus.** If the plan is heavy strength, the member still gets heavy strength work, even if the movement changes.
- **The order of operations.** Mechanics, then consistency, then intensity. You never add load to a movement that's breaking down.
- **Scope.** Pain, injury, and anything clinical go to a senior coach every time.
- **Time.** The blocks still run to the clock, and the close is still never cut.

The things you can flex:

- **The movement variation**, using the scaling menu, to keep the stimulus the same.
- **Load and volume within the plan's ranges**, based on how the member is moving today.
- **Your delivery**: the cue type, the amount of talk, how much push or permission you offer, using what you've learned about reading people.
- **Rest and pacing** inside the block.

The skill is knowing which kind of change you're making. If you're adjusting inside the guardrails, do it confidently and note it. If you find yourself wanting to change the stimulus, skip a block, or work around pain, that's the signal to get the coach.

Good flexing usually looks invisible to the member. They just feel like the session fit them today.

**On the floor today:** Make one deliberate adjustment inside the guardrails for one member, and log what you changed and why in Semi-Private Pro or PushPress.

**Check yourself:** In your last session, did you make any change that was actually outside the guardrails?$md$),
  (18, 2, 'lesson', $md$Tuesday: Red flags go up$md$, $md$On the floor today: Review the hand-off line from Week 2 with your mentor and add one new red flag from today's list you'd want to recognize faster.$md$, $md$The more you can handle, the more important it is to know what you shouldn't. Instructors get trusted with more, and the cost of a missed red flag goes up with that trust.

These go to a senior coach immediately, every time, even mid-block:

- **New or sharp pain**, or pain that changes how someone moves.
- **Anything that sounds like nerve symptoms**: numbness, tingling, pain shooting down a limb.
- **Dizziness, chest discomfort, unusual shortness of breath**, or a member who looks gray or confused. Stop them first, then get help.
- **A member who mentions a new diagnosis, medication change, pregnancy, or surgery** you didn't know about.
- **A pattern you notice across sessions**: someone who's been tired and off for two weeks straight, a member whose weight or mood has changed sharply.

None of these are yours to solve. Your job is to notice, stop when safety requires it, hand it up clearly, and stay with the member until the coach arrives. Then write down what you saw, in plain facts.

Handing up isn't a sign that you couldn't handle it. It's what a professional does. The best coaches in the building hand things up all the time, to physical therapists, to physicians, to MEDgevity. Knowing the edge of your lane is part of being trusted inside it.

**On the floor today:** Review the hand-off line from Week 2 with your mentor and add one new red flag from today's list you'd want to recognize faster.

**Check yourself:** Is there a member you've worked with recently whose pattern should have been mentioned to a senior coach?$md$),
  (18, 3, 'lesson', $md$Wednesday: Gauging energy and pacing$md$, $md$On the floor today: For every member in one session, rate their energy against their normal (lower, same, higher) before the first block, and check whether you adjusted for each.$md$, $md$Every member walks in with a different tank. Two people on the same program can need very different sessions on the same day. Reading that quickly, and adjusting, is one of the clearest differences between a Presenter and an Instructor.

Start reading before the first rep. How did they walk in? How did they answer "What's on your mind?" How do they move in the warm-up compared with their normal? You only know their normal if you've been paying attention for weeks, which is why everything you've built since Week 2 matters here.

Then meet them where they are and bring them up. Start about one gear above their energy, not five. If someone walks in flat after a terrible night, matching a high-energy room at full volume usually pushes them further into their shell. Meet them close to where they are, then lift them a little at a time as the session goes on.

A flat day isn't a failure, theirs or yours. Log it as data. "Slept four hours, newborn, kept loads at last week's numbers, moved well" is a useful note. Over a few weeks, notes like that show patterns: the member who always struggles on Mondays, the one whose energy drops every time work gets busy. Those patterns change how the next coach programs and talks to them.

The opposite matters too. When someone walks in with more than usual, the plan may allow them to push a bit. That's a good day to notice, celebrate, and write down.

**On the floor today:** For every member in one session, rate their energy against their normal (lower, same, higher) before the first block, and check whether you adjusted for each.

**Check yourself:** Who in your sessions has a pattern you've noticed but haven't written down yet?$md$),
  (18, 4, 'lesson', $md$Thursday: Turning setbacks into evidence$md$, $md$On the floor today: Find one member who's had a recent setback and point out one specific piece of progress they might be missing.$md$, $md$Members have bad days, bad weeks, and setbacks. How you talk about them can change whether someone keeps going.

Here's a common case. A member has had five good months. Their back has felt great, they've been consistent, and they've gotten stronger. Then they have a flare-up, and they come in discouraged: "I thought we fixed this. Maybe this doesn't work for me."

The instinct is to reassure them quickly, or to start explaining. Try something else first. Ask what happened and listen. Then help them see the evidence they already have: five months ago a flare-up like this might have lasted weeks, and now they know what helps, they're still able to train around it, and they came in instead of disappearing. The flare-up didn't erase the progress. It's showing how much progress there is.

That's positive framing. It isn't spin or pretending something bad is good. It's helping someone see the true picture, which usually includes more progress than they're giving themselves credit for in a hard moment.

A few guardrails keep it honest:

- **Acknowledge first.** "That's frustrating" before anything else.
- **Use their facts, not general encouragement.** Point to what they've actually done.
- **Hand up anything clinical.** Positive framing is never a reason to skip the coach when pain is involved.

This is a case we'll discuss at this week's huddle. Bring a moment from your own sessions when a member lost confidence.

**On the floor today:** Find one member who's had a recent setback and point out one specific piece of progress they might be missing.

**Check yourself:** When a member is discouraged, do you tend to reassure, explain, or ask?$md$),
  (18, 5, 'lesson', $md$Friday: Full-session ops$md$, $md$On the floor today: Run one full session's ops yourself, before, during, and after, and ask your mentor what you missed.$md$, $md$This week you start owning the operational side of a whole session, not just your blocks. That means everything around the coaching that makes a session run.

**Before.** Read the plan and every booked member's notes and Semi-Private Pro history. Check the roster. Set up the floor so the first transition is ready before anyone walks in.

**During.** Run the clock for the whole session. Handle the late arrival, the equipment problem, and the member who needs a different version, while keeping the room moving.

**After.** Reset the floor. Write session notes for every member who needs one, the same day. Log every modification in Semi-Private Pro. Follow up on anything you promised.

This week your mentor will also introduce disruptions on purpose, without warning: a member with a surprise injury story, a missing piece of equipment, a member who wants to do something completely different. Some will be real and some will be staged. Handle them the way you'd handle the real thing.

What your mentor is watching isn't whether you solve every disruption perfectly. It's whether the room keeps moving, whether you stay inside your lane, and whether the record afterward tells the next coach what happened. A disruption you handled well but didn't write down is half handled.

Your homework this week is a film review of one off-plan moment, including how you documented it.

**On the floor today:** Run one full session's ops yourself, before, during, and after, and ask your mentor what you missed.

**Check yourself:** Which part of full-session ops do you find easiest to let slip?$md$),
  (18, 6, 'lesson', $md$On the floor this week$md$, $md$Lead full sessions with your mentor present. Expect disruptions introduced on purpose.$md$, $md$$md$),
  (18, 7, 'film', $md$Filmed rep$md$, $md$Film one session that goes off-plan.$md$, $md$$md$),
  (18, 8, 'homework', $md$Homework$md$, $md$A film review of one off-plan moment, including what you changed, what you handed up, and how you documented it.$md$, $md$$md$),
  (18, 9, 'huddle', $md$Huddle$md$, $md$The setback case: bring a moment from your sessions when a member lost confidence, and how it was framed.$md$, $md$$md$),
  (18, 10, 'lesson', $md$Reading$md$, $md$Conscious Coaching and your certification text.$md$, $md$$md$);

update public.weeks set title = $md$Toward the full session$md$, summary = $md$Week 19 puts the whole session in your hands. Your mentor co-leads but stays silent unless safety requires otherwise. The lessons follow the arc of a session from the open to the follow-up, because the session doesn't end when the clock does. You'll also learn the coach side of the HSN app, so your follow-up is based on what members actually did this week, and your supervised discovery calls continue.$md$, system_focus = $md$The follow-up loop (who, channel, and where it's logged) and the coach side of the HSN app.$md$, updated_at = now() where n = 19;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (19, 1, 'lesson', $md$Monday: The session arc$md$, $md$On the floor today: Write the four parts of the arc on a card, keep it in your pocket, and check them off in every session you lead.$md$, $md$A full session has four parts, and the last one happens after everyone has gone home.

**Open.** Purpose, process, payoff. Why today matters, what we're going to do, and what it will feel like when it's done right. Thirty to ninety seconds, said to the whole room, with everyone's attention before you start.

**Deliver.** The warm-up, the blocks, and the close, run to the clock, with every member reached and every adjustment logged. This is everything you've been building for eighteen weeks.

**Close.** A recap of what they did, one thing to be proud of, and when you'll see them next. For semi-private members, a quick word on what's next in their program.

**Follow up.** The message, the check-in, or the note that keeps the relationship going between sessions. What happens between sessions often decides what happens in them.

Most new coaches put almost all their attention on the second part. That makes sense, because it's the part people see. But members experience the whole arc. A great block with a rushed open and no close feels like a workout. The same block with a clear open, a real close, and a follow-up two days later feels like coaching.

This week your mentor will be silent unless safety requires otherwise. That means the arc is yours. If you forget the open, nobody will rescue it. Use the arc as a checklist until it's automatic.

**On the floor today:** Write the four parts of the arc on a card, keep it in your pocket, and check them off in every session you lead.

**Check yourself:** Which part of the arc do you most often shortchange?$md$),
  (19, 2, 'lesson', $md$Tuesday: Opening with purpose, process, payoff$md$, $md$On the floor today: Deliver your open in under 90 seconds, with all three parts, in every session you lead.$md$, $md$You've used purpose, process, payoff since you learned it in the teaching weeks. This lesson is about using it to open a whole session, where it does the most work.

**Purpose** answers why. Connect today's work to something members care about. Not "Today is lower body" but "Today we're building the strength that makes stairs, kids, and suitcases easy." For a group, tie it to the season or the block they're in.

**Process** answers what. A quick walk through the blocks so nobody is surprised. Name the main lift and the conditioning in one sentence each.

**Payoff** answers how it should feel. "The heavy sets should feel like a hard five reps with one left in the tank. The conditioning should leave you breathing hard but still moving well at the end." This is the line that keeps people inside the intended stimulus, and it's the one most coaches leave out.

Keep it short. If the open runs past two minutes, people start shifting their weight and looking at the clock. Practice it out loud before your first session of the day, the same way you'd warm up your body.

The open is also your first read of the room. While you're talking, watch faces. Who's here and ready? Who's somewhere else? That read tells you who to reach first in the warm-up.

**On the floor today:** Deliver your open in under 90 seconds, with all three parts, in every session you lead.

**Check yourself:** In today's opens, which of the three parts was weakest?$md$),
  (19, 3, 'lesson', $md$Wednesday: The follow-up loop$md$, $md$On the floor today: Send three specific follow-ups to members from today's sessions and log each one.$md$, $md$A follow-up is any contact between sessions that keeps the coaching going: a quick text after a tough session, a check-in on a member who mentioned a sore shoulder, a note of congratulations after a milestone, a message to someone who missed two classes in a row.

Good follow-up has three parts.

**Who.** Not everyone every week. Prioritize the member who had a hard day, the one who's new, the one who mentioned something worth checking on, and the one who's started slipping on attendance.

**Channel.** Use the channel we use for member communication, not your personal phone or social media. Members belong to the house, and so do the conversations.

**Logged.** Every follow-up gets a quick note where the next coach will see it. If a member tells you their shoulder is better, that information is worth a lot to whoever coaches them next. If it's only in your text thread, it's lost.

The best follow-up is specific. "Great job this week!" is fine. "Saw you hit all five sets of goblet squats at 35 on Tuesday. That's up from 25 a month ago. How's the knee feeling?" tells the member that someone is paying attention to them in particular. That's the feeling that keeps people coming back.

This week's homework is drafting your own follow-up habit: when you'll do it, who gets it, and where you'll log it.

**On the floor today:** Send three specific follow-ups to members from today's sessions and log each one.

**Check yourself:** Which member would most benefit from hearing from you this week?$md$),
  (19, 4, 'lesson', $md$Thursday: The coach side of the HSN app$md$, $md$On the floor today: With your mentor, look at the HSN check-ins for two members you'll coach this week and write down one thing you'd do differently because of it.$md$, $md$You've used the HSN app since Week 1 to track your own six pillars. This week you see the coach side: how a coach looks at a member's habits and check-ins.

Why now? Because the follow-up that lands is the one based on what the member actually did this week. If you can see that a member logged three nights of bad sleep, your follow-up and your coaching in their next session are different than if you'd guessed.

What you'll learn:

- **Seeing a member's habits.** Which pillars they're working on, and how consistent they've been.
- **Reading check-ins.** What they reported and when.
- **Spotting patterns.** A dip in sleep before a dip in attendance. A stressful week that shows up in their training.

What you won't do yet is coach nutrition or set targets. That's later in the development path, with the HSN nutrition certification. Right now your job is to look, notice, and let what you see shape how you show up for that member. If something looks like it needs a nutrition or health conversation, pass it to the coach who owns that member's plan.

The principle is the same as everything else you've learned: data is useful when it changes how you treat a person, and useless when it just sits there.

**On the floor today:** With your mentor, look at the HSN check-ins for two members you'll coach this week and write down one thing you'd do differently because of it.

**Check yourself:** What's one thing you learned from a member's check-ins that you wouldn't have known from the floor?$md$),
  (19, 5, 'lesson', $md$Friday: Coaching with a silent mentor$md$, $md$On the floor today: Watch your full-session film with your mentor and mark every moment you hesitated.$md$, $md$This week your mentor has been beside you but silent. If they stepped in, it was for safety. Everything else was yours.

It probably felt different from Week 9, when your mentor was mostly hands-off during a segment. Now it's the whole arc: the open, the full session, the close, and the follow-up. That's what you'll be doing every day after you're hired, and it's what the gate will test in five weeks.

Use the film. Watch your full session with your mentor and look for the moments where you hesitated, where a member waited for you, or where you went quiet. Those are the places you were still waiting for help that didn't come. They're usually where your next improvement is.

Your discovery calls also continue this week, supervised. By now you should be running the full call structure without notes and logging the same day. Notice how much of what you've learned on the floor shows up on the calls: reading the person, staying curious, not being right too early.

Next week your certification finishes and your speaking workshop teach-back is due. After that comes the final month: solo sessions, the mock gate, and the Instructor gate. You're closer than it feels.

**On the floor today:** Watch your full-session film with your mentor and mark every moment you hesitated.

**Check yourself:** Where in the session do you still wait for someone to help?$md$),
  (19, 6, 'lesson', $md$On the floor this week$md$, $md$Co-lead full sessions with your mentor silent unless safety requires otherwise. Supervised discovery calls continue.$md$, $md$$md$),
  (19, 7, 'film', $md$Filmed rep$md$, $md$Film one full session, open to close.$md$, $md$$md$),
  (19, 8, 'homework', $md$Homework$md$, $md$Draft your member follow-up habit: when you'll do it, who gets it, and where you log it.$md$, $md$$md$),
  (19, 9, 'huddle', $md$Huddle$md$, $md$Bring the best follow-up you sent this week and what came back.$md$, $md$$md$),
  (19, 10, 'lesson', $md$Reading$md$, $md$Conscious Coaching and your certification text.$md$, $md$$md$);

update public.weeks set title = $md$Certification complete$md$, summary = $md$By the end of Week 20, your certification is done: CF-L1 attended or NASM-CPT passed. Your speaking-workshop teach-back is delivered too. This week's lessons help you finish strong, translate what the certification taught you into how we coach here, and take stock before the final month.$md$, system_focus = $md$Your certification record in your file, and your notes, call logs, and Semi-Private Pro logs current.$md$, updated_at = now() where n = 20;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (20, 1, 'lesson', $md$Monday: The finish line$md$, $md$On the floor today: Send your mentor your certification status in one message: done, scheduled, or behind with a plan.$md$, $md$You opened your certification track in Week 5. This is the week it closes.

If you chose CF-L1, you've attended the two-day course and taken the test. If you chose NASM-CPT, you've sat the proctored exam. Either way, the goal for this week is simple: done, and recorded. Send your certificate or result to your mentor and post it in Slack so it's in your file before the gate.

If something has slipped, say so today, not on Friday. Maybe the exam date moved, or you didn't pass on the first try. That happens. NASM allows a retake, and CF-L1 dates come around regularly. What matters is that your mentor hears it from you early, with a plan: the new date, what you'll study, and how you'll fit it around the floor. The same rule that's applied since Week 8 applies here. A problem you raise early is a coaching conversation. A problem that surfaces at the gate is a much harder one.

If you're finished, take a minute to notice what that took. You studied around a full floor schedule for fifteen weeks. That's the kind of follow-through the rest of your career will ask for.

**On the floor today:** Send your mentor your certification status in one message: done, scheduled, or behind with a plan.

**Check yourself:** If your certification isn't finished, what's the date, and what has to happen before it?$md$),
  (20, 2, 'lesson', $md$Tuesday: What the cert gives you, and what it doesn't$md$, $md$On the floor today: Pick one idea from your certification and explain to your mentor how it shows up in the way we already coach.$md$, $md$A certification is a foundation, not a finish. It's worth being clear about what you just earned.

It gives you a shared vocabulary for movement, a framework for how the body adapts to training, and the basics of program structure. It gives members and other professionals a reason to trust that you've been through a recognized standard. And it gives you a test you passed on your own, which matters more than people admit.

What it doesn't give you is everything you've been learning on our floor for twenty weeks: reading the person in front of you, carrying a room, choosing the right cue for the right person, knowing when to hand something up, writing a note the next coach can use, running a discovery call. No certification can teach that, because it has to be learned on a real floor with real people.

The skill now is translation. Your certification may use different words for things we teach. CF-L1 talks about mechanics, consistency, and intensity, which you've known since Week 3. NASM has its own model for progressing a client. Where the language differs, use District H vocabulary on our floor, and use the certification to deepen your understanding of why. If something you learned seems to contradict how we coach, bring it to your mentor. Sometimes there's a good reason for the difference, and sometimes it's a good question.

**On the floor today:** Pick one idea from your certification and explain to your mentor how it shows up in the way we already coach.

**Check yourself:** What did your certification teach you that changed how you see something on our floor?$md$),
  (20, 3, 'lesson', $md$Wednesday: Delivering your teach-back$md$, $md$On the floor today: Rehearse your teach-back out loud for your mentor and time it.$md$, $md$Your speaking-workshop teach-back is due by the end of this week. You've had your huddle date booked since Week 17. This lesson is the final prep.

Remember the structure: the one idea, why it matters on our floor, show it, let them try it, and the ask. Fifteen minutes. Here's how to make it good.

**Rehearse out loud, twice.** Once for structure, once for time. Most first drafts run long. If you're over, cut the second-best point, not the practice.

**Use your own film if you can.** A before and after clip of your own session open, showing the habit you worked on, is more convincing than anything you could say.

**Make the practice real.** Two minutes in pairs, on something people will actually use the next morning. The test of a teach-back is whether anyone changes something on Thursday.

**Practice what you're teaching.** If your workshop was about pausing after instructions, pause after your instructions. If it was about one idea per talk, have one idea. People will notice whether you do it.

After you deliver it, ask two people for one note each. And notice how it felt to teach coaches instead of members. You'll be doing more of it every year from here.

**On the floor today:** Rehearse your teach-back out loud for your mentor and time it.

**Check yourself:** What's the one thing you want the team doing differently because of your teach-back?$md$),
  (20, 4, 'lesson', $md$Thursday: Twenty weeks$md$, $md$On the floor today: Watch your Week 13 film and today's film side by side and write down the three biggest differences.$md$, $md$Take stock. Twenty weeks ago you were learning names. Here's what you can do now that you couldn't then:

- run a full session from the open to the follow-up, with your mentor silent
- teach a movement from zero and correct it with the right cue for the person
- read a member and adjust your delivery for them
- keep a session moving when it goes off-plan, and know exactly what to hand up
- run a discovery call and log it the same day
- use PushPress, Lead Connector, Semi-Private Pro, Kinotek, and the coach side of the HSN app
- hold a certification and stand up in front of other coaches to teach

That's most of an Instructor. The final month is about doing all of it consistently, without help, and showing it on film and on paper.

This is also a good week for an honest check with yourself. Is this the work you want to do? Most people at this point are surer than ever. Some notice that the parts they love most are different from what they expected, maybe more one-on-one, maybe more teaching, maybe something else entirely. All of that is useful to know before Week 24, and your mentor would much rather hear it now.

**On the floor today:** Watch your Week 13 film and today's film side by side and write down the three biggest differences.

**Check yourself:** What part of this work do you enjoy most now, and is it what you expected?$md$),
  (20, 5, 'lesson', $md$Friday: The final month$md$, $md$On the floor today: Audit your notes, call logs, and Semi-Private Pro logs from the last two weeks, and fix any gaps you can honestly fill.$md$, $md$Next week starts the last month of BaseCamp. Here's what's ahead, so you can plan for it.

- **Week 21: Solo sessions.** You run full sessions every day, under observation, with every system handled without being asked. You'll also learn to read a member's recovery and readiness data before their session.
- **Week 22: The mock gate.** A full rehearsal of the Instructor gate, plus the archetype drill rescored and a month of your records reviewed like film. Your Kolbe and PI assessments are done this week too.
- **Week 23: Teach-back and polish.** You teach a full staff huddle and have your final discovery-call evaluation.
- **Week 24: The Instructor gate.** A full solo session, filmed and scored, including your complete records, the archetype drill, a discovery-call sign-off, and a panel conversation. This is the hiring decision.

The pattern will feel familiar from the Presenter gate: no surprises, a mock gate with time to fix what it finds, and a gate that asks you to show what you already do every day.

The best preparation starts now. Keep your records clean every day, not in a rush in Week 22. Keep filming. Keep asking for feedback and keep showing the change by Thursday. The habits that got you here are the ones the gate is looking for.

**On the floor today:** Audit your notes, call logs, and Semi-Private Pro logs from the last two weeks, and fix any gaps you can honestly fill.

**Check yourself:** If the Instructor gate were next week, which part would worry you most?$md$),
  (20, 6, 'lesson', $md$On the floor this week$md$, $md$Keep leading full sessions with your mentor silent unless safety requires otherwise. Supervised discovery calls continue.$md$, $md$$md$),
  (20, 7, 'film', $md$Filmed rep$md$, $md$Film your teach-back.$md$, $md$$md$),
  (20, 8, 'homework', $md$Homework$md$, $md$Your certification complete and recorded, and your teach-back outline submitted before you deliver it.$md$, $md$$md$),
  (20, 9, 'huddle', $md$Huddle$md$, $md$Deliver your speaking-workshop teach-back, if your date falls this week.$md$, $md$$md$),
  (20, 10, 'lesson', $md$Reading$md$, $md$Finish Conscious Coaching.$md$, $md$$md$);
