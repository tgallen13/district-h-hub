-- Month 3 of BaseCamp (weeks 9-12): full daily lessons from the
-- "BaseCamp Month 3: Daily Lessons" review doc (Oct 20, 2026), replacing the
-- placeholder tasks. Refuses to run if any intern already has progress in
-- weeks 9-12, so nobody's recorded work is lost.

do $chk$
begin
  if exists (select 1 from public.task_progress p join public.tasks t on t.id = p.task_id where t.week_n between 9 and 12) then
    raise exception 'Interns already have progress in weeks 9-12. Edit those weeks in the admin screen instead.';
  end if;
end $chk$;

delete from public.tasks where week_n between 9 and 12;

update public.weeks set title = $md$Running the full segment$md$, summary = $md$Week 9 is reps. Every day you lead the warm-up and one full segment, a strength block or a conditioning block, with your mentor on the floor but stepping in as little as possible. The lessons this week are about what a full segment asks of you that a warm-up doesn't, and what to do when the plan meets real life.$md$, system_focus = $md$No new system. Every segment you run gets a session note in PushPress the same day.$md$, updated_at = now() where n = 9;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (9, 1, 'lesson', $md$Monday: Running a strength block$md$, $md$On the floor today: In your strength block, count your points of contact per member and note anyone you reached only once.$md$, $md$A strength block is where most of the session's real work happens, and it's where your job changes the most from the warm-up. In the warm-up you're leading everyone through the same thing at the same time. In a strength block, ten people are doing ten slightly different things, and you're responsible for all of them.

Start with the plan. The loading guidance is already written in it: the sets, the reps, how heavy, and how to tell when someone should go up or stay put. Your job isn't to invent that. It's to deliver it and watch it happen.

**Setup.** Before anyone touches a bar, every member knows their equipment, their space, and their first weight. Walk the room once while people set up and check spacing. A loaded barbell needs room to fail safely.

**During the work.** Move. Get to every member during their sets, two or three real points of contact each. Give the one cue from the plan when you see the fault it's for. Watch for the last reps, because that's where form breaks down.

**Load.** As a Presenter, you're not choosing weights for anyone. If a member asks whether to go heavier, the answer comes from the plan ("if all five reps looked like the first one, add five pounds") or from the coach. Never from a guess.

**Your role and the coach's.** You run the block. The coach is still responsible for the room, and you pull them in for anything outside the plan: pain, a load decision you're unsure of, a member who needs a different movement entirely.

**On the floor today:** In your strength block, count your points of contact per member and note anyone you reached only once.

**Check yourself:** A member asks, "Should I go heavier?" What do you say, word for word?$md$),
  (9, 2, 'lesson', $md$Tuesday: Running a conditioning block$md$, $md$On the floor today: At the halfway point of a conditioning block, scan the room and decide for each member: on target, too easy, or too hard.$md$, $md$Conditioning is harder to coach well than it looks. Everyone is moving at once, the clock is running, and people get tired, which is exactly when movement gets sloppy and judgment gets worse.

**Before the clock starts.** Everyone knows the work, their scaled version, and their target pace. Say the purpose in one sentence: "This should feel like a hard 7 out of 10 the whole way. You should be able to talk in short sentences." That one line does more for safe, effective conditioning than any cue during it.

**Pacing language.** Most people go out too fast. Coach the first minute hard: "Settle in. If you're breathing like that at minute two, you won't make it to minute ten." Then remind them of the target as the work goes on.

**The clock.** Know the time cues the plan calls for and call them clearly. Know how much time is left without having to check every few seconds.

**What scaled correctly looks like at minute eight.** This is the real test. A member who is scaled right is still moving well, still roughly on pace, and working hard. A member who's scaled wrong is either cruising, or their form has fallen apart and they're grinding. If you see someone grinding through broken reps, that's a scaling problem. Flag it to the coach, and next time it'll be scaled better from the start.

End with a recovery minute and a word: what they just did, and why it mattered.

**On the floor today:** At the halfway point of a conditioning block, scan the room and decide for each member: on target, too easy, or too hard.

**Check yourself:** What did you see at minute eight today that you didn't see at minute two?$md$),
  (9, 3, 'lesson', $md$Wednesday: When things go sideways$md$, $md$On the floor today: Ask your mentor to create one disruption during a segment without warning you, and handle it without stopping the room.$md$, $md$Every session plan assumes everyone shows up on time, the equipment works, and members do what they're told. None of those are reliably true. A Presenter who can handle the sideways moments without stalling the room is much closer to an Instructor.

**A member arrives late.** Greet them by name, briefly, and get them warming up on their own with one clear instruction. Don't restart the room for them. Fold them in at the next transition.

**Not enough equipment.** You find out at the transition that you're two kettlebells short. Keep the room moving first. Pair people up, swap to a substitute from the plan's scaling options, or stagger the start. Then solve the problem properly afterward and tell the coach so it's fixed for next time.

**A member is visibly overreaching.** They're grinding through reps with form falling apart, or they've loaded something far too heavy. Step in calmly and privately: "Let's take ten pounds off and make these look like your first set." If they push back, or if pain is involved, get the coach.

**A member wants your attention when the room needs it.** You learned this in Week 1. Acknowledge them, tell them when you'll come back, and come back.

The common thread: the room comes first, then the problem. And when you're not sure, the coach is right there. Asking isn't a failure. Freelancing is.

**On the floor today:** Ask your mentor to create one disruption during a segment without warning you, and handle it without stopping the room.

**Check yourself:** Which kind of disruption throws you most, and what will you say the next time it happens?$md$),
  (9, 4, 'lesson', $md$Thursday: When to pull in a senior coach$md$, $md$On the floor today: Keep a tally of every time you pulled in the coach today, and why.$md$, $md$You're running more of the session now, which makes it more important, not less, that you know exactly where your lane ends.

Pull in the coach right away, every time, for:

- **Pain or injury.** Anything that hurts, anything that looks like a tweak, anything a member mentions about an injury. Use the hand-off line from Week 2.
- **Any load decision outside the plan.** Including "Can I go heavier than it says?"
- **A member who needs a different movement entirely.** Not a scaled version from the menu, but something else.
- **Health questions.** Dizziness, chest discomfort, a member who looks unwell. Stop them first, then get the coach.
- **Anything that feels off.** A member who seems upset, a conflict between members, a situation you don't understand.

You can handle on your own:

- delivering the plan as written
- the one cue the plan gives for a fault
- offering the scaled option the coach has already chosen
- logistics, time, equipment, and the energy of the room

The line isn't about trust. It's about scope. Presenters are trusted with a lot. They're trusted most when they hand things up cleanly and quickly, because that's how members stay safe and how coaches learn they can give you more.

**On the floor today:** Keep a tally of every time you pulled in the coach today, and why.

**Check yourself:** Was there a moment this week you should have pulled in the coach and didn't?$md$),
  (9, 5, 'lesson', $md$Friday: Owning it$md$, $md$On the floor today: Run your segment as if your mentor weren't in the building.$md$, $md$This week your mentor has been on the floor but mostly quiet. That changes how it feels. There's no one finishing your sentences, no one fixing the transition you fumbled. It's yours.

The first few days of minimal intervention usually feel worse, not better. You notice everything you used to get help with. That's normal, and it's the point. The skills you have are being tested without a net, which is the only way to know you have them.

Watch for two traps.

**Playing it safe.** Some interns respond to more independence by doing less: fewer cues, fewer points of contact, staying near the whiteboard. It feels safer, but members notice a coach who's gone quiet.

**Doing too much.** Others overcorrect: cueing everything, talking constantly, trying to prove they can handle it. Members notice that too.

What you want is the same standard you've been building for eight weeks, delivered without help: clear instructions, the right amount of contact, a clean clock, and a good close.

This week's homework is two filmed segments, one reviewed by you and one by your mentor. When you compare the two reviews, look for the gap between what you saw and what they saw. That gap is your blind spot, and it's the most useful thing on the page.

**On the floor today:** Run your segment as if your mentor weren't in the building.

**Check yourself:** What did your mentor see on your film that you didn't?$md$),
  (9, 6, 'lesson', $md$On the floor this week$md$, $md$Lead the warm-up and one full segment every day, with your mentor on the floor but stepping in as little as possible.$md$, $md$$md$),
  (9, 7, 'film', $md$Filmed rep$md$, $md$Two filmed segments, one you review and one your mentor reviews.$md$, $md$$md$),
  (9, 8, 'homework', $md$Homework$md$, $md$Compare the two reviews of your segments and write down the biggest gap between what you saw and what your mentor saw.$md$, $md$$md$),
  (9, 9, 'huddle', $md$Huddle$md$, $md$Bring the sideways moment from this week you handled best, and the one you'd handle differently.$md$, $md$$md$),
  (9, 10, 'lesson', $md$Reading$md$, $md$Your certification text.$md$, $md$$md$);

update public.weeks set title = $md$Your first discovery calls$md$, summary = $md$In Week 7 you watched discovery calls. This week you run them, with your mentor listening and a debrief straight after each one. You also take ownership of call logging in Lead Connector, which from now on is part of the job, not an extra.$md$, system_focus = $md$Lead Connector ownership. Every call you run is logged the same day: notes, next step, pipeline stage, and follow-up.$md$, updated_at = now() where n = 10;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (10, 1, 'lesson', $md$Monday: Running the call$md$, $md$On the floor today: Run a full role-play call with your mentor, start to finish, using the call structure.$md$, $md$The first call you run will feel different from the ones you shadowed. When you were listening, the structure seemed obvious. When you're the one talking, you'll forget a step, lose your place after a long answer, or rush to the next question before the last answer is finished. Everyone does.

A few things make the first calls go better.

**Prepare.** Read the intake form before the call. Know their name, how they found us, and what they said they want. Have the call structure in front of you. There's no prize for doing it from memory.

**Open with the frame and wait.** "Today's goal is just to clarify some of your goals and make sure we're the very best people to help you. Sound like a plan?" Then actually wait for them to say yes. That pause sets the tone for the whole call.

**Slow down on the why.** It's the most important part of the call and the one new callers rush. When they give you a surface answer ("I want to lose weight"), ask again: "Can you tell me more about why that matters to you right now?" The real answer usually comes on the second or third ask.

**Let silence work.** After a question, wait. People fill silence with the things they almost didn't say.

**End with a clear next step.** A consultation, a trial, or a referral, booked before you hang up.

Your mentor is on the line to listen, not to rescue you. If you lose your place, say so: "Let me make sure I've got that right." Then summarize what they've told you. It buys time and makes them feel heard.

**On the floor today:** Run a full role-play call with your mentor, start to finish, using the call structure.

**Check yourself:** Which part of the call structure did you skip or rush in your role-play?$md$),
  (10, 2, 'lesson', $md$Tuesday: Three kinds of callers$md$, $md$On the floor today: Role-play the price-anxious caller with your mentor, and practice the line that asks permission to ask questions first.$md$, $md$Most discovery calls go to one of three places early on. Knowing which one you're in helps you stay on track.

**The ready one.** They've trained before, they know what they want, and they're ready to start. The risk here is going too fast. Don't skip their why because they seem sure. Ready people still have reasons, and knowing them is how you keep them past month three.

**The price-anxious one.** They ask about cost early, maybe in the first minute. Don't dodge it, and don't lead with it either. "That's a fair question, and I'll give you real numbers. Can I ask you a few questions first so I can tell you which option actually fits? Otherwise I'd just be guessing." Most people say yes. If they still want a number, give the range honestly.

**The one who's been hurt before.** Hurt by an injury, or hurt by a gym, a coach, or a program that didn't work and made them feel like a failure. They're often guarded, and they may be testing whether we're different. Go slower here. Ask about what happened, and listen more than you talk. For this caller, the most important thing you can communicate is that we'll start where they are.

You'll role-play each of these with your mentor this week. Notice that the call structure doesn't change. What changes is pace, tone, and where you spend your time.

**On the floor today:** Role-play the price-anxious caller with your mentor, and practice the line that asks permission to ask questions first.

**Check yourself:** Which of the three callers would be hardest for you, and why?$md$),
  (10, 3, 'lesson', $md$Wednesday: Whose agenda ran the call?$md$, $md$On the floor today: After your next real conversation with a member, write down one thing they told you that you didn't ask about.$md$, $md$After every call, you'll debrief with your mentor using NEPA from Week 7. This week we add one question that cuts through almost everything: whose agenda ran the conversation?

In a good call, the member's agenda runs it. They talked most. Their words for their goals ended up in your notes. The next step fit what they told you, not what you hoped to sell.

In a weaker call, your agenda ran it. You talked more than they did. You steered toward the program you had in mind. You asked the next question on your list even when their answer pointed somewhere more important.

The second question to ask yourself: what did you hear that you didn't ask about? People tell you a lot without being asked. A mention of a new baby. A pause before answering about stress. "My last coach was fine, I guess." Those are often the most important things on the call, and the easiest to miss when you're focused on your next question.

This is the same posture you've been building since Week 2. Connection comes before advice, and the fastest way to lose someone is to be right too early. On a discovery call, being right too early sounds like recommending a program before you know why they called.

**On the floor today:** After your next real conversation with a member, write down one thing they told you that you didn't ask about.

**Check yourself:** In your last call, what percentage of the talking did you do?$md$),
  (10, 4, 'lesson', $md$Thursday: A call that isn't logged didn't happen$md$, $md$On the floor today: With your mentor, log a practice call end to end in Lead Connector: notes, next step, stage, and follow-up.$md$, $md$From this week on, you own the record of every call you run. The standard is simple: a call that isn't logged didn't happen.

Logging a call means four things, done the same day:

- **The notes.** What they told you, in their words where it matters: their why, their history, their aches and pains, what success looks like to them.
- **The next step.** What was booked, when, and with whom. Or why nothing was booked.
- **The pipeline stage.** Moved to where the person actually is now.
- **The follow-up.** Anything you promised ("I'll send you that video") with a date on it.

Where the notes go depends on the outcome. If a consultation or trial was booked, the notes go on their profile in PushPress, where the coach who meets them will see them. If nothing was booked, they go on the contact in Lead Connector. If they cancel or don't show, they move to the matching stage in Lead Connector, where an automated sequence tries to rebook them.

Why does this matter so much? Because the coach who runs the consultation shouldn't have to ask the same questions you already asked. When a member has to repeat their story, it tells them nobody was listening. Good notes are how the next person picks up exactly where you left off.

**On the floor today:** With your mentor, log a practice call end to end in Lead Connector: notes, next step, stage, and follow-up.

**Check yourself:** If the coach who meets your caller reads only your notes, will they know why this person called?$md$),
  (10, 5, 'lesson', $md$Friday: After the call$md$, $md$On the floor today: Check every call you've run this week. Is each one logged, and has every promised follow-up happened?$md$, $md$The call ends, but the work doesn't. What happens in the next 48 hours often decides whether someone actually shows up.

**After a booked consultation.** Make sure it's on the calendar and the notes are in PushPress. If you promised them anything, send it today.

**After a free trial.** The caller owns the follow-up. Schedule a text for about an hour after their session ("How did that feel?"). Text again the next day. Call on day two. Then keep an eye on them in the CRM until they've decided.

**After a no-show or cancellation.** Move them to the right stage in Lead Connector so the automated follow-up can try to rebook them. Don't take it personally. Life gets in the way, and many people who miss once come back.

**After a "not for us."** If we referred them somewhere else, make sure they have the name and the next step. Someone we helped find the right place is someone who tells their friends about us.

The theme for the whole week is that the discovery call is the start of a relationship, not a transaction. The way you follow up tells the person what kind of coaching they'd get from us before they've had a single session.

**On the floor today:** Check every call you've run this week. Is each one logged, and has every promised follow-up happened?

**Check yourself:** What's one follow-up you'd have forgotten if you hadn't written it down?$md$),
  (10, 6, 'lesson', $md$On the floor this week$md$, $md$Take two or more supervised discovery calls, with your mentor listening and a debrief right after. Keep leading the warm-up and a full segment every day.$md$, $md$$md$),
  (10, 7, 'film', $md$Filmed rep$md$, $md$Record one role-play call (the ready one, the price-anxious one, or the one who's been hurt before) and review it with your mentor.$md$, $md$$md$),
  (10, 8, 'homework', $md$Homework$md$, $md$A NEPA debrief of each call you ran, including whose agenda ran it and what you heard that you didn't ask about.$md$, $md$$md$),
  (10, 9, 'huddle', $md$Huddle$md$, $md$Bring the best question you asked on a call this week and what it opened up.$md$, $md$$md$),
  (10, 10, 'lesson', $md$Reading$md$, $md$Your certification text.$md$, $md$$md$);

update public.weeks set title = $md$The mock gate$md$, summary = $md$Week 11 is a full rehearsal of the Presenter gate, on film and scored the same way the real one will be, including your records. You'll also learn to score other people's film, build your portfolio, and get a look at what the Instructor phase asks of you. The rule this week is no surprises: if your mentor expects a "not yet," you'll hear it now, not at the gate.$md$, system_focus = $md$Your records trail: session notes, call logs, and Slack posts, checked without warning during the mock gate.$md$, updated_at = now() where n = 11;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (11, 1, 'lesson', $md$Monday: The gate, demystified$md$, $md$On the floor today: Watch an example film of a 3 and a 4 on the same row with your mentor, and say out loud what made the difference.$md$, $md$The Presenter gate isn't a mystery test. Every part of it is something you've already been doing for ten weeks. This lesson walks through it so nothing on gate day is new.

The gate asks one question: can you run a safe, connected, clear session from a written plan, consistently? It answers that question in four kinds of evidence.

**Live delivery.** You lead a warm-up and a full segment in a real session, filmed. This is scored on presence, safety, time, connection, communication economy, and client-first orientation, the same language you've been learning since Week 1.

**Your trail.** Your session notes, call logs, and Slack posts, checked without warning. Nobody asks you to tidy them up first. That's the point.

**Your portfolio.** The record of your twelve weeks: film, reviews, reading, certifications, hours, and your floor journal.

**The people who worked with you.** Your mentor and the senior coaches you've worked beside.

Each row is scored from 1 to 5. A 3 means competent and reliable. A 4 means adaptive in real time. The standard to pass is no row below 3, with zero safety flags. Two rows are absolute: a safety flag or a values concern is enough on its own to mean not yet.

One more thing worth knowing: steady 3s with an upward trend look better than a couple of 4s next to a 2. Consistency is the thing we're hiring for, eventually.

**On the floor today:** Watch an example film of a 3 and a 4 on the same row with your mentor, and say out loud what made the difference.

**Check yourself:** Which row of the gate are you least sure about right now?$md$),
  (11, 2, 'lesson', $md$Tuesday: Building your portfolio$md$, $md$On the floor today: Pull up your Week 1 film and today's film side by side and write the first draft of your one-page summary.$md$, $md$Your portfolio is the case you'll present at the gate. You build it this week so the gate itself can be a conversation, not a scramble.

It includes:

- your scored films, each with your self-review
- your floor journal, plus a one-page summary of what changed from Week 1 to Week 12
- your reading work: your Coaching Habit translation and anything else you've written up
- your certification record and where you are on your study plan
- your log: floor hours, warm-ups and segments led, discovery calls shadowed and run
- your own practice: your MAP done, your training consistent, your six pillars tracked in the HSN app

The one-page summary matters most. Don't list what you did. Describe what changed. "In Week 1 I stood in the middle of the room and said 'um' every other sentence. Now I set up at the front, pause after instructions, and my transcript drill dropped my filler words by half." Specific beats impressive.

Be honest about the gaps. A portfolio that admits a weak row and shows a plan for it is stronger than one that pretends everything is fine. Your mentor already knows where the gaps are. What they want to see is that you know too.

**On the floor today:** Pull up your Week 1 film and today's film side by side and write the first draft of your one-page summary.

**Check yourself:** What's the one change from Week 1 you're proudest of, and what's the evidence?$md$),
  (11, 3, 'lesson', $md$Wednesday: Scoring someone else's film$md$, $md$On the floor today: Score one of your own old films on the scorecard as if it belonged to someone else.$md$, $md$At this week's huddle, the cohort scores each other's film on the real scorecard, then compares those scores with the mentors'.

Scoring other people is one of the fastest ways to see your own coaching more clearly. It's easier to notice a coach standing in the wrong place, talking over the room, or missing the quiet member when it isn't you. Once you've seen it in someone else, you'll start seeing it in yourself.

A few rules make peer scoring useful instead of awkward.

**Score the film, not the person.** Every score should point to a moment: "At 4:10 she gave the instruction while people were still moving." Not "She seems nervous."

**Use the anchors.** A 3 is competent and reliable. A 4 is adaptive in real time. Don't give a 4 to be nice or a 2 to look rigorous.

**Give one strength and one thing to work on.** Be specific about both.

**When your score and the mentor's differ, find out why.** That's where the learning is. Usually one of you saw something the other missed.

And when it's your film on the screen, the same rule from Week 8 applies: "Thanks, got it." No defending.

**On the floor today:** Score one of your own old films on the scorecard as if it belonged to someone else.

**Check yourself:** When your score for someone else's film differed from the mentor's, who saw more, and what was it?$md$),
  (11, 4, 'lesson', $md$Thursday: The mock gate$md$, $md$On the floor today: After the mock gate, write down your lowest row and the three things you'll do about it before Week 12.$md$, $md$Today you run the whole gate once, for real, except that it doesn't count.

You lead a warm-up and a full segment in a live session, filmed. Your mentor scores it on the gate rubric. Then, without warning, they check your trail: a sample of your session notes, your call logs in Lead Connector, and your Slack posts. Then you sit down together and go through every row.

Treat it exactly like the real thing. Prepare the same way, arrive the same way, and don't ask for a do-over if something goes wrong. How you handle a mistake in the middle of a session is part of what's being scored.

The point of the mock gate is to find out where you really are with time to do something about it. If a row comes in below 3, you and your mentor make a plan for the next week, and you work that plan every day.

The no-surprises rule applies here. If your mentor thinks you're likely to hear "not yet" at the gate, they'll tell you this week, with the reasons. That conversation is uncomfortable, and it's one of the kindest things they can do. It gives you a week to change the answer, or time to prepare for a second attempt without being caught off guard.

**On the floor today:** After the mock gate, write down your lowest row and the three things you'll do about it before Week 12.

**Check yourself:** What did your trail check show that the film didn't?$md$),
  (11, 5, 'lesson', $md$Friday: What Instructor looks like$md$, $md$On the floor today: Ask one coach what changed most for them between running a room and coaching a person.$md$, $md$You're about to finish the first phase of a five-stage career. Before you walk into the gate, it's worth knowing what's on the other side, so that you're choosing the next stage, not just passing this one.

The Presenter phase taught you to connect with a room. The Instructor phase teaches you to communicate with a person. Same session, very different job.

Here's what changes in Weeks 13 to 24:

- **Reading people.** You'll read *Conscious Coaching* and learn to tell, quickly, what a particular member needs from you and how to deliver it.
- **The Floor Loop.** Notice, Read, Choose, Deliver, Confirm. It becomes the language of every film review.
- **Teaching movement.** Tell, show, do, and choosing the right kind of cue for the person in front of you.
- **Semi-private.** You'll learn Semi-Private Pro and start coaching in the semi-private format.
- **Your certification** finishes in this phase.
- **The Instructor gate in Week 24** is the hiring decision.

It's a bigger step than the one you're finishing. Some people find they love it. Some find that the Presenter work was the part they enjoyed, and that's worth knowing too. Either way, you'll go into Week 13 knowing what you're signing up for.

**On the floor today:** Ask one coach what changed most for them between running a room and coaching a person.

**Check yourself:** What are you most looking forward to in the Instructor phase, and what are you most nervous about?$md$),
  (11, 6, 'lesson', $md$On the floor this week$md$, $md$Lead the warm-up and a full segment every day, with your mentor present but hands-off. Expect an unannounced names spot-test.$md$, $md$$md$),
  (11, 7, 'film', $md$Filmed rep$md$, $md$Your mock gate session, filmed and scored on the gate rubric.$md$, $md$$md$),
  (11, 8, 'homework', $md$Homework$md$, $md$Your portfolio, assembled, with the one-page summary of what changed from Week 1 to Week 12.$md$, $md$$md$),
  (11, 9, 'huddle', $md$Huddle$md$, $md$Peer film scoring. The cohort scores each other's film and compares with the mentors.$md$, $md$$md$),
  (11, 10, 'lesson', $md$Reading$md$, $md$Your certification text.$md$, $md$$md$);

update public.weeks set title = $md$The Presenter gate$md$, summary = $md$This is the week you show what twelve weeks built. Your portfolio is due Monday. You lead your gate session live, on film, and you sit down with your mentor and the GM to present your case. The lessons this week are short and practical, built around what the gate will actually ask.$md$, system_focus = $md$The unprompted systems check: session notes, call logs, and Slack posts.$md$, updated_at = now() where n = 12;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (12, 1, 'lesson', $md$Monday: What the gate is scoring$md$, $md$On the floor today: Run today's session and, afterward, score yourself on each of the six with one sentence of evidence for each.$md$, $md$You've heard the four kinds of trust since Week 1. At the gate they become the language of the scoring, alongside safety and time.

- **Presence (propriety).** You look and act like someone a member trusts with their body. On time, prepared, dressed, standing where the room can see you, and in command of it.
- **Safety.** Every rep inside the plan, every fault flagged, every hand-off clean. Zero freelancing.
- **Time.** The blocks run to the clock and the close is never cut.
- **Connection (commonality).** Every member greeted by name and reached at least once. The quiet member gets found.
- **Communication economy (credibility).** Instructions that are short and clear, given once. Plain language. No filler.
- **Client-first orientation (intent).** Scaling offered as a plan for them, not a demotion. Their goal comes before your program.

None of this is new. What's different on gate day is that it's all happening at once, for the whole session, without help.

The best preparation now isn't learning anything. It's sleep, a normal routine, reading the plan the night before and again that morning, and arriving early enough to set up the floor without rushing.

**On the floor today:** Run today's session and, afterward, score yourself on each of the six with one sentence of evidence for each.

**Check yourself:** Which of the six is your strongest, and which needs the most attention this week?$md$),
  (12, 2, 'lesson', $md$Tuesday: The systems check$md$, $md$On the floor today: Audit your own records from the last two weeks the way the gate will, and write down anything missing.$md$, $md$Part of the gate is unprompted. Your mentor or the GM will look at your records without asking you to get them ready first: session notes from the last few weeks, your call logs in Lead Connector, and your Slack posts.

The word that matters is unprompted. The question isn't whether you can produce good records when someone asks. It's whether good records are what you do when nobody's asking. That's the same standard as the floor. A professional who's only professional while being watched isn't one yet.

Here's what they'll be looking at.

- A note for every segment you coached, written the same day, specific enough to help the next coach.
- Every discovery call logged: notes, next step, pipeline stage, and follow-up.
- Film posted with your self-review written first.
- Homework on time and in the right place.

If you find gaps in your records this week, fill in what you honestly can, and say so. Don't backdate notes or invent details you don't remember. A gap you own is a coaching conversation. A gap you cover up is a values conversation, and that's a much bigger problem.

**On the floor today:** Audit your own records from the last two weeks the way the gate will, and write down anything missing.

**Check yourself:** If the systems check happened today without warning, what would it find?$md$),
  (12, 3, 'lesson', $md$Wednesday: Presenting your own case$md$, $md$On the floor today: Practice your case out loud for your mentor in five minutes or less.$md$, $md$The gate conversation is about an hour, with your mentor and the GM. You go first. You present your own case before anyone scores you.

That order is deliberate. A coach who can look at their own work honestly and clearly is one who'll keep improving after BaseCamp, when there's no mentor walking them through every review.

A strong case usually sounds like this:

- **Where you started.** One or two specific things from Week 1, with evidence. Film is best.
- **What changed.** Specific improvements, with evidence. "My filler words dropped by half between my first and second transcript drill."
- **Where you are now.** Your honest read of each row, including the ones you're less sure about.
- **What's next.** The one or two things you'll work on first in the Instructor phase.

What weakens a case: talking in generalities ("I've grown so much"), overselling a row the film doesn't support, or explaining away feedback.

At the end of the conversation, your mentor will give you back the one-page values response you wrote in Week 1. Read it again before you walk in. It's a good reminder of who you were when you started, and why you came.

**On the floor today:** Practice your case out loud for your mentor in five minutes or less.

**Check yourself:** What's the most honest thing you can say about the row you're least confident in?$md$),
  (12, 4, 'lesson', $md$Thursday: If the answer is not yet$md$, $md$On the floor today: Write down how you want to respond in the room, whichever answer you get.$md$, $md$Most people who reach Week 12 pass. Some hear "not yet." It's worth knowing exactly what that means before you walk in.

"Not yet" means one or more rows aren't at the standard, or there's a safety or values concern. It comes with specific reasons and a written plan: what needs to change, how it'll be measured, and a date to try again, usually two to four weeks out. You keep working on the floor during that time. You're not starting over.

"Not yet" isn't a judgment about whether you can become a great coach. Plenty of strong coaches needed a second attempt at a gate somewhere along the way. What matters is how you use the next few weeks. The interns who do best after a "not yet" treat the plan exactly like feedback: they write it down, pick the most important thing first, and make the change visible fast.

Sometimes a gate conversation also brings up the bigger question of whether this path is right for you. If that happens, it'll be an honest conversation, not a sudden one. BaseCamp was built to either commit you or be honest enough that you choose differently, and both are good outcomes.

And if you pass, the same mindset applies. Passing means you're ready to start the Instructor phase, not that you're finished.

**On the floor today:** Write down how you want to respond in the room, whichever answer you get.

**Check yourself:** What would you do in the first week after a "not yet"?$md$),
  (12, 5, 'lesson', $md$Friday: Twelve weeks$md$, $md$On the floor today: Thank one coach or member who made a difference in your twelve weeks, and tell them specifically what it was.$md$, $md$Twelve weeks ago, you walked into the gym having never coached a session here. This week you ran one on your own, on film, and defended it.

At this week's huddle, you'll close out *The Coaching Habit*: the three questions you use most now, and what each one built. Most interns find that one of those questions has become automatic, something they say without thinking. That's what a habit is, and it's the whole point of the book.

Look at what you can do now that you couldn't in Week 1. You know why we exist and who we serve. You know the shape of a session and the job of each block. You can carry a room, deliver a warm-up and a full segment, see faults, offer a scaled option well, and know exactly when to hand something up. You've run discovery calls and logged them. You know most of your members by name and something real about each one.

That's the Presenter's job: connection, and carrying the room. Next week the work turns toward the person in front of you.

Whatever happened at your gate, take a minute this weekend to notice the distance you've covered. Then rest. Week 13 starts the second half.

**On the floor today:** Thank one coach or member who made a difference in your twelve weeks, and tell them specifically what it was.

**Check yourself:** What will you do differently in the next twelve weeks because of what you learned in these?$md$),
  (12, 6, 'lesson', $md$On the floor this week$md$, $md$Your gate session: a warm-up and a coached segment in a live room, filmed. Keep leading every day.$md$, $md$$md$),
  (12, 7, 'film', $md$Filmed rep$md$, $md$Your gate session, scored on the Presenter rubric.$md$, $md$$md$),
  (12, 8, 'homework', $md$Homework$md$, $md$Your portfolio, submitted Monday, with your one-page summary.$md$, $md$$md$),
  (12, 9, 'huddle', $md$Huddle$md$, $md$The closing Coaching Habit huddle: your three most-used questions and what each one built.$md$, $md$$md$),
  (12, 10, 'lesson', $md$Reading$md$, $md$Wrap up your certification study for the week. Conscious Coaching starts in Week 13.$md$, $md$$md$),
  (12, 11, 'huddle', $md$The Presenter gate$md$, $md$Your gate conversation with your mentor and the GM. Read what it scores.$md$, $md$A working draft until the Presenter rubric is finished. Each row is scored 1 (unsafe or absent) to 5 (an example for others). To pass: no row below 3, the safety row at 3 or better with zero flags, and sign-off from your mentor and the GM. A safety flag or a values concern is enough on its own to mean not yet.

- **Presence (propriety).** Gate film and floor observation (3 or better)
- **Safety.** Gate film, hand-off record, and floor record (3 or better, zero flags)
- **Time.** Gate film (3 or better, close never cut)
- **Connection (commonality).** Gate film and names spot-test (3 or better, every core-slot member by name)
- **Communication economy (credibility).** Gate film and transcript drills (3 or better)
- **Client-first orientation (intent).** Gate film, scaling, and call debriefs (3 or better)
- **Demos.** Demo audit (3 or better on every foundational movement, or a documented modification)
- **Systems.** Unprompted records check (Complete, specific, same day)
- **Discovery calls.** Call logs and mentor attestation (Two or more supervised calls at 3 or better)
- **Certification.** Study tracker (On pace for completion by Week 20)
- **Personal practice.** MAP, training log, and HSN tracking (Current)
- **Values.** Mentor and every senior coach worked with (No concerns)

Outcome: pass, and the Instructor phase starts in Week 13. Or not yet, with a written plan and a second attempt in two to four weeks.$md$);
