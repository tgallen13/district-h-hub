-- Month 4 of BaseCamp (weeks 13-16): full daily lessons from the
-- "BaseCamp Month 4: Daily Lessons" review doc (Oct 20, 2026), replacing the
-- placeholder tasks. Refuses to run if any intern already has progress in
-- weeks 13-16, so nobody's recorded work is lost.

do $chk$
begin
  if exists (select 1 from public.task_progress p join public.tasks t on t.id = p.task_id where t.week_n between 13 and 16) then
    raise exception 'Interns already have progress in weeks 13-16. Edit those weeks in the admin screen instead.';
  end if;
end $chk$;

delete from public.tasks where week_n between 13 and 16;

update public.weeks set title = $md$The teaching model$md$, summary = $md$Week 13 starts the second half of BaseCamp. You'll start reading *Conscious Coaching*, learn the Floor Loop that every film review uses from now on, teach one movement pattern every day from scratch, and meet Semi-Private Pro, the system that carries each member's plan from coach to coach.$md$, system_focus = $md$Semi-Private Pro introduction: reading a member's program before every session.$md$, updated_at = now() where n = 13;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (13, 1, 'lesson', $md$Monday: From the room to the person$md$, $md$On the floor today: Pick two members who respond very differently to the same instruction, and write down what you think each one needs from you.$md$, $md$For twelve weeks you learned to connect with a room. You can greet everyone by name, carry the energy of a class, run a block to the clock, and hand things up cleanly. That's the Presenter's job, and you passed it.

The Instructor phase asks something different. A room is made of people, and each of them hears you a little differently. One member wants the reason behind every movement. Another wants you to stop explaining and let them work. One will try anything you suggest. Another is quietly sure they'll embarrass themselves. The same words from you will land well with one and badly with the next.

That's what this book is for. Your reading for the next twelve weeks is *Conscious Coaching* by Brett Bartholomew. Here's how we'd hand it to you: Presenter taught you to connect with a room. This book teaches you to communicate with a person. Read it for the archetypes.

The archetypes are descriptions of the patterns people bring into a coaching relationship, like the skeptic who has to be convinced or the achiever who can't stand falling behind. Treat them as starting guesses, not labels. Their value is that they give you a reason to try a different approach when your usual one isn't landing.

Over the next three months you'll also learn to teach movement from zero, choose the right kind of cue, and coach in the semi-private format. At Week 24, the Instructor gate is the hiring decision.

**On the floor today:** Pick two members who respond very differently to the same instruction, and write down what you think each one needs from you.

**Check yourself:** What's one thing you do as a coach that works for most people but not for everyone?$md$),
  (13, 2, 'lesson', $md$Tuesday: Tell, show, do$md$, $md$On the floor today: Teach one pattern from zero to a member or a coworker using tell, show, do, and count how many words you use during the do.$md$, $md$When you teach a movement to someone who has never done it, the order you do things in matters more than the words you choose. Our teaching model is tell, show, do.

**Tell.** Name the movement and say why it matters to them, in one or two sentences. "This is a hinge. It's how you'll pick things up off the floor without your back doing the work." Purpose first gives people a reason to pay attention.

**Show.** Demonstrate it, in silence, from the angle where the important part is easiest to see. Then name the one thing to watch. You learned this in Week 4, and it matters more now that you're teaching from zero.

**Do.** Let them try it, with very little load and very little talk. Watch the first few reps before saying anything. Most beginners need to feel the movement before a cue makes sense to them.

Then correct one thing, see whether it landed, and repeat.

The most common mistake new instructors make is talking too much during the do. When a member is moving, every word you say competes with what they're trying to feel. Give one cue, then let them work.

The second most common mistake is skipping the tell. A member who doesn't know why they're doing a movement tends to rush through it to get to the part they think matters.

**On the floor today:** Teach one pattern from zero to a member or a coworker using tell, show, do, and count how many words you use during the do.

**Check yourself:** Which of the three steps do you tend to rush, and what happens when you do?$md$),
  (13, 3, 'lesson', $md$Wednesday: The Floor Loop$md$, $md$On the floor today: Pick one correction you make today and walk through all five beats out loud with your mentor afterward.$md$, $md$From this week on, every film review uses the same language: the District H Floor Loop. Every coaching interaction on our floor, from a warm-up cue to a hard conversation, runs the same five beats. Great coaches don't do something different. They run this loop faster, more accurately, and with more tools at each beat.

1. **Notice.** See what's actually happening before deciding what it means. Movement, effort, face, energy, what they said and what they didn't. No judgment yet. "She's lazy" isn't a notice. "She's moved slower every round" is.
2. **Read.** Two quick reads before you act. State: what's their energy today, compared to their normal? Type: who is this person, and how do they like to be coached?
3. **Choose.** Pick the delivery this person needs right now: push or permission, detail or headline, humor or quiet, public or private, more challenge or less. Same message, different package.
4. **Deliver.** Teaching something new: tell, show, do. Correcting: the right cue type, preferably external, and no more than three. Opening a session: purpose, process, payoff.
5. **Confirm.** Did it land? Watch the next rep, ask one question, read their face. If it didn't land, go back to Choose and try something different, not the same cue louder.

One rule sits underneath the loop: it serves their goal, not your program. You're reading the person to help them get where they want to go, never to win the interaction.

The loop takes its ideas from three places you'll meet in more depth later in your career: the NEPA debrief from Week 7, *Conscious Coaching*, and Active Life's work on trust.

**On the floor today:** Pick one correction you make today and walk through all five beats out loud with your mentor afterward.

**Check yourself:** Which beat do you usually skip?$md$),
  (13, 4, 'lesson', $md$Thursday: Semi-Private Pro$md$, $md$On the floor today: Before one semi-private session, read every member's program and write down one thing it told you.$md$, $md$In semi-private, each member follows their own program, built for them, even though they train alongside a few other people. Semi-Private Pro is the system that holds those programs.

Think of it as service architecture, not software. It's how a member's plan follows them. A member might train with you on Monday, another coach on Wednesday, and someone else on Friday. Every one of those coaches needs to know what the member did last time, what weight they used, what hurt, and what comes next. Semi-Private Pro is where that lives.

This week you'll learn to read a program. For each member, look at:

- **Today's work:** the movements, sets, reps, and loads
- **The progression:** where today fits in the plan, and what changed from last time
- **Notes and modifications:** anything the last coach recorded, like a sore knee or a swapped movement

Before every semi-private session you coach this week, pull up each member's program and note one thing it told you that you'd have missed otherwise. Over time, that habit is what lets any coach serve any member to the same standard.

Next week you'll start logging results and modifications yourself. For now, read before you coach, every time.

**On the floor today:** Before one semi-private session, read every member's program and write down one thing it told you.

**Check yourself:** What would go wrong if a coach skipped reading the program before a session?$md$),
  (13, 5, 'lesson', $md$Friday: Introducing a movement from zero$md$, $md$On the floor today: Teach a movement from zero to someone who has never done it, and log what you taught.$md$, $md$Teaching a new member their first deadlift, or showing an experienced member a new variation, is a skill on its own. This week you've practiced it every day. Here's how to tie it together.

**Start with what they can already do.** Almost every movement has a simpler version the member already knows. A hinge starts from "push your hips back like you're closing a car door with them." A squat starts from sitting down onto a box. Begin there, then build.

**Pick one point of performance to teach first.** The one that matters most for safety. For a hinge, that's a neutral spine. The others come later.

**Use very little load.** A dowel, a light kettlebell, or just body weight. The goal of the first session is a pattern, not a workout.

**Let them succeed early.** A few good reps in the first two minutes builds the confidence to work on the harder parts.

**Log it.** Write down what you taught, which version they used, and what to work on next, in Semi-Private Pro or PushPress, so the next coach builds from where you left off.

Teaching from zero is where the people-reading work starts to matter. An anxious beginner needs lots of early success and no audience. An experienced lifter learning a new variation wants the reason and then the room to try it. Same teaching model, different delivery.

**On the floor today:** Teach a movement from zero to someone who has never done it, and log what you taught.

**Check yourself:** What type of member do you think you taught today, and what told you that?$md$),
  (13, 6, 'lesson', $md$On the floor this week$md$, $md$Teach one movement pattern every day using tell, show, do.$md$, $md$$md$),
  (13, 7, 'film', $md$Filmed rep$md$, $md$Film one teach from start to finish.$md$, $md$$md$),
  (13, 8, 'homework', $md$Homework$md$, $md$For your filmed teach, pull the member's program first and note one thing it told you, then write down the member type you think you were teaching and why.$md$, $md$$md$),
  (13, 9, 'huddle', $md$Huddle$md$, $md$Bring the moment from this week when your usual approach didn't land and what you tried instead.$md$, $md$$md$),
  (13, 10, 'lesson', $md$Reading$md$, $md$Start Conscious Coaching, plus your certification text.$md$, $md$$md$);

update public.weeks set title = $md$Cueing economy$md$, summary = $md$Week 14 is about getting more out of fewer words. You'll learn the four kinds of cues, when to use each, the difference between internal and external cues, and the rule that keeps corrections clean: no more than three. At the huddle, the cohort builds the District H archetype map together.$md$, system_focus = $md$Semi-Private Pro: keep reading every member's program before each session you coach.$md$, updated_at = now() where n = 14;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (14, 1, 'lesson', $md$Monday: The four cue types$md$, $md$On the floor today: For one fault you see today, try at least two different cue types and note which one worked.$md$, $md$A cue is anything you use to change how someone moves. Most new coaches only use one kind, words, and then wonder why some members never seem to get it. There are four.

**Verbal.** Words. "Push the floor away." Fast and easy to give to a whole room, and the easiest to overuse.

**Visual.** A demonstration, or pointing at something. "Watch my hips." Often the fastest way to fix a fault for someone who learns by seeing.

**Tactile, with permission.** A light touch to show where something should move. "Can I put my hand here? Push your hips back into it." Always ask first, every time, even with members you know well. Some members never want to be touched, and that's their call.

**Spatial.** Using the environment. A box behind them to sit back to, a target on the wall for a wall ball, a band around the knees to push against. The environment does the coaching, and nobody has to process an instruction.

Different people respond to different cue types. One member hears "knees out" and fixes it immediately. Another needs to see it. A third needs a band around their knees before it clicks. When a cue doesn't land, your first move should usually be to switch the type, not to repeat the words.

**On the floor today:** For one fault you see today, try at least two different cue types and note which one worked.

**Check yourself:** Which cue type do you reach for first, and which do you almost never use?$md$),
  (14, 2, 'lesson', $md$Tuesday: Internal and external cues$md$, $md$On the floor today: Take your three most common internal cues and write an external version of each. Use them today.$md$, $md$There's another way to sort cues that matters as much as the four types: whether a cue points the member's attention inside their body or outside it.

**Internal cues** focus on the body. "Extend your knees." "Squeeze your glutes." "Keep your elbows tucked."

**External cues** focus on the effect, or on something outside the body. "Push the floor away." "Drive your hips into the bar." "Bend the bar."

For most people, most of the time, external cues work better, especially once someone has the basic pattern. Focusing on the effect lets the body organize the movement on its own. Focusing on individual joints and muscles tends to make movement stiffer and slower, because the member is trying to think about too many parts at once.

That doesn't mean internal cues are wrong. They're useful when someone needs to feel a specific position for the first time, or when an external cue isn't working. "Feel your hamstrings stretch" can help a member find a hinge they've never felt before. The point is to choose on purpose.

The best external cues are short and vivid. "Be tall." "Explode up." "Spread the floor." Members remember them, and they work under fatigue, when nobody can process a sentence.

**On the floor today:** Take your three most common internal cues and write an external version of each. Use them today.

**Check yourself:** Which of your new external cues worked better than the original, and which didn't?$md$),
  (14, 3, 'lesson', $md$Wednesday: Three cues, then stop$md$, $md$On the floor today: Film one correction and count the cues you gave.$md$, $md$Here's the rule for corrections at District H: no more than three cues per correction.

When you get good at seeing movement, you'll see a lot of faults in a single rep. Knees caving, heels lifting, chest dropping, bar drifting. The temptation is to fix them all. But a member can only hold one or two things in mind while moving, and most people only one. If you give five cues, they'll remember the last one, or none.

So choose. Ask which fault matters most for safety, and which one, if fixed, might fix the others. Heels lifting in a squat often causes the chest to drop, so fixing the heels might fix both. Give that cue. Watch the next rep. If it landed, move on or add one more thing. If it didn't, go back to Choose in the Floor Loop and try a different cue, but don't pile on.

There's one more diagnostic to know, because you'll see it constantly: **looks right, feels wrong.** A member's rep looks fine to you, but they say it feels off, or something hurts. Believe them, and investigate. Ask where they feel it and when in the rep. Try a small change. If it involves pain, hand it up to the coach. The member's experience of the movement is information you can't see from the outside.

**On the floor today:** Film one correction and count the cues you gave.

**Check yourself:** When did you last give more than three cues, and what did the member actually change?$md$),
  (14, 4, 'lesson', $md$Thursday: Demonstrating to standard$md$, $md$On the floor today: Demonstrate today's main movement at the level of the newest member in the room, paired with your cue.$md$, $md$You've been demonstrating since Week 4 and passed the demo audit in Week 6. In the Instructor phase, your demos carry more weight, because you're teaching people from zero and they'll copy exactly what they see.

A few standards for demonstrating as an Instructor:

- **Demonstrate at the member's level.** If they're using a goblet squat, demonstrate a goblet squat, not a back squat. Show the version they'll actually do.
- **Show the fault, then the fix,** but only briefly and only for the fault you're working on. "This is what your knees are doing. This is what we want."
- **Pair the demo with your cue.** If your cue is "push the floor away," say it while you demonstrate, so the words and the picture connect.
- **Show scaled options with the same care.** A member deciding between two versions should see both done well.

Your demo also teaches without words. Members watch how you move between sets, how you set up, and how you reset your equipment. If your own setup is sloppy, theirs will be too.

**On the floor today:** Demonstrate today's main movement at the level of the newest member in the room, paired with your cue.

**Check yourself:** Did your demo today match the version your members actually did?$md$),
  (14, 5, 'lesson', $md$Friday: The archetype map$md$, $md$On the floor today: Fill in the map for five members you coach this week: quick read, likely drive, and which kind of trust matters most to them.$md$, $md$At this week's huddle, the cohort builds the District H archetype map together, using the people-reading map and *Conscious Coaching*.

The map has two layers. The **quick read** takes about 30 seconds. Is this person fast-paced or deliberate? Do they lead with the task or with how they feel? That gives you four quadrants: Drivers, who want the headline, the standard, and the scoreboard; Energizers, who want enthusiasm, variety, and an audience of one; Analysts, who want the reason, the data, and time to process; and Rocks, who want warmth, patience, and no public spotlight. The quadrant tells you how to package a cue.

The **deep read** takes months. What is this person protecting? The skeptic who must not be fooled, the achiever who must not fall behind, the anxious beginner who must not be embarrassed, the veteran who must not be condescended to. That's what *Conscious Coaching* calls their drives, and it tells you what to build for their year, not just how to say Tuesday's cue.

The huddle adds a third column: which kind of trust each type values most. Our starting guesses are that Analysts are won with credibility, Rocks read intent, Energizers bond through commonality, and Drivers respect propriety and economy. You'll test these against real members, and the map gets better every time a cohort builds it.

Two rules hold the whole thing together. Types are hypotheses, not verdicts. And read to serve, never to manipulate. Would you be comfortable if the member heard your reasoning?

**On the floor today:** Fill in the map for five members you coach this week: quick read, likely drive, and which kind of trust matters most to them.

**Check yourself:** Which member are you least sure about, and what would you need to see to know more?$md$),
  (14, 6, 'lesson', $md$On the floor this week$md$, $md$Teach and correct every day, with no more than three cues per correction.$md$, $md$$md$),
  (14, 7, 'film', $md$Filmed rep$md$, $md$Film one correction from start to finish.$md$, $md$$md$),
  (14, 8, 'homework', $md$Homework$md$, $md$Audit your filmed correction for cue count, cue type, and whether it landed.$md$, $md$$md$),
  (14, 9, 'huddle', $md$Huddle$md$, $md$Build the District H archetype map with the cohort.$md$, $md$$md$),
  (14, 10, 'lesson', $md$Reading$md$, $md$Conscious Coaching, plus your certification text.$md$, $md$$md$);

update public.weeks set title = $md$Scaling and managing twelve$md$, summary = $md$Week 15 is about coaching one person without losing everyone else. You'll learn to modify live without breaking the room, find the member who's struggling quietly, open a block with purpose, process, and payoff, log every modification so the next coach can see it, and run your first Kinotek scan with a senior coach beside you.$md$, system_focus = $md$Logging results and modifications in Semi-Private Pro, and running a Kinotek scan under supervision.$md$, updated_at = now() where n = 15;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (15, 1, 'lesson', $md$Monday: Modifying live$md$, $md$On the floor today: Make one live modification for a member you know well and explain your reasoning to your mentor afterward.$md$, $md$In the Presenter phase you offered the scaled option the coach had already chosen. As an Instructor, you'll start making some of those calls yourself, in the moment, for members you know.

A live modification is any change to the plan for one person during the session: a lighter load, a different variation, fewer reps, a longer rest. The question that guides every one is the same: what is this part of the session supposed to do for them, and what version of it does that today?

A few principles keep modifications safe and useful.

**Keep the intended stimulus.** If the block is meant to be heavy and slow, the modification should still be heavy and slow for that person, just within what they can do well. If it's meant to be fast and breathless, keep it fast and breathless with a simpler movement.

**Change one thing at a time.** Load, range, or movement. Change one and watch.

**Stay inside your scope.** You can choose from the scaling menu and adjust load within the plan's guidance. Pain, injury, or a movement that's not on the menu still go to the coach.

**Don't stop the room.** Make the change quickly and quietly, then get back to everyone else. If you need more than about 30 seconds with one person, tell them you'll come back, and do.

**On the floor today:** Make one live modification for a member you know well and explain your reasoning to your mentor afterward.

**Check yourself:** What was the intended stimulus of today's main block, and did your modification keep it?$md$),
  (15, 2, 'lesson', $md$Tuesday: The quiet struggler$md$, $md$On the floor today: Scan the room three times during the main block and note anyone who looks different from their normal.$md$, $md$In every room there's at least one member who's having a hard time and isn't saying so. They're the person whose form has quietly fallen apart, who's resting longer than the plan says, who's using lighter weights than they did last week without explanation, or who seems a little flat.

Quiet strugglers are easy to miss because they don't ask for anything. In a busy room your attention gets pulled to the loudest problems, and the quiet ones slip by. They're also often the members who are closest to leaving.

Finding them is a Notice skill. Scan the room on purpose a few times every block, and ask yourself who looks different from their normal. You can only spot a difference if you know their normal, which is one more reason to know your members well and read their notes before the session.

When you find one, the move is usually a quiet check-in, not a correction. "You look a little off today. How are you feeling?" Then listen. It might be a bad night's sleep, a sore shoulder, a hard week. Adjust the plan if you need to, note it afterward, and if something's going on that a coach should know about, pass it on.

The member will remember that you noticed.

**On the floor today:** Scan the room three times during the main block and note anyone who looks different from their normal.

**Check yourself:** Who did you find today that you might have missed a month ago?$md$),
  (15, 3, 'lesson', $md$Wednesday: Purpose, process, payoff$md$, $md$On the floor today: Open every block today with purpose, process, payoff in under 45 seconds.$md$, $md$Every block you open should answer three questions before anyone starts moving. We call it purpose, process, payoff.

**Purpose.** What this block is for. "This is our strength piece for the day. We're building the hinge so your back stays happy when you pick up your kids."

**Process.** How it'll work. "Four sets of six, resting about two minutes. Same weight as last week if all six looked clean, five pounds more if they felt easy."

**Payoff.** What done right feels like. "You should finish each set feeling like you had two more good reps in you. If the last rep looks different from the first, that's too heavy."

That's thirty seconds, and it changes the whole block. Members who know the purpose work with more intent. Members who know the process don't have to ask. Members who know what done right feels like can largely scale themselves.

For a group, purpose, process, payoff is also how you manage twelve people at once. When everyone knows what good looks like, you can spend your attention on the few who need you instead of answering the same question ten times.

**On the floor today:** Open every block today with purpose, process, payoff in under 45 seconds.

**Check yourself:** Which of the three did you find hardest to say clearly?$md$),
  (15, 4, 'lesson', $md$Thursday: An unrecorded scale is invisible$md$, $md$On the floor today: Log every semi-private member you coached today, including at least one modification and the reason for it.$md$, $md$This week you start logging results and modifications in Semi-Private Pro, not just reading them.

Here's why it matters. If you swap a member's back squat for a box squat because their knee was bothering them, and you don't write it down, the next coach puts them right back under the bar on Wednesday. The member gets hurt, or loses trust, or both. An unrecorded scale is invisible to the next coach.

For every semi-private member you coach, log:

- **What they did:** the actual loads, sets, and reps, not just what was planned
- **Any modification,** and why: "Swapped to box squat, left knee sore on descent"
- **Anything the next coach should know:** a new goal they mentioned, a movement that clicked, a bad week at work

Log during or right after the session, while it's fresh. The same rule you learned for session notes in Week 3 applies here: specific, factual, and useful to someone who wasn't there.

Good logs are also how a member's program improves. The coach who writes their next block is working from what actually happened, not from what was supposed to happen.

**On the floor today:** Log every semi-private member you coached today, including at least one modification and the reason for it.

**Check yourself:** If another coach picked up your members tomorrow, what would they know from your logs?$md$),
  (15, 5, 'lesson', $md$Friday: Running a Kinotek scan$md$, $md$On the floor today: After your supervised scan, write down one thing it showed and what you'd look for on the floor because of it.$md$, $md$In Week 7 you watched a Kinotek scan during an Elevate MAP. This week you run one yourself, with a senior coach supervising.

Kinotek is the 3D movement scan we use as part of the MAP. It captures how a person moves through a set of movements and shows things that are hard to see with the naked eye, like small differences between the left and right sides, or where a joint runs out of range.

Running the scan is the easy part. The skill is connecting what it shows to what you'll actually do with that member. If the scan shows the left hip moving less than the right, what will you look for when they squat? What cue might help? Which modification might they need?

That connection is the whole point. A scan that doesn't change how you coach is just a printout. A scan that tells you where to look turns into better coaching on the floor.

A few rules for running it:

- Follow the setup steps exactly every time, so results are comparable from one scan to the next.
- Explain each step to the member before they do it.
- Don't interpret results to the member yourself yet. That conversation belongs to the coach running the MAP.

**On the floor today:** After your supervised scan, write down one thing it showed and what you'd look for on the floor because of it.

**Check yourself:** How did the scan change what you'll watch for when you coach that member?$md$),
  (15, 6, 'lesson', $md$On the floor this week$md$, $md$Coach semi-private and group sessions, making live modifications within the plan and the scaling menu.$md$, $md$$md$),
  (15, 7, 'film', $md$Filmed rep$md$, $md$Film one block you open with purpose, process, payoff and coach through.$md$, $md$$md$),
  (15, 8, 'homework', $md$Homework$md$, $md$Schedule your certification exam, and write up your Kinotek scan: what it showed and what you'd look for on the floor.$md$, $md$$md$),
  (15, 9, 'huddle', $md$Huddle$md$, $md$Bring a quiet struggler you found this week and what you did.$md$, $md$$md$),
  (15, 10, 'lesson', $md$Reading$md$, $md$Conscious Coaching, plus your certification text.$md$, $md$$md$);

update public.weeks set title = $md$The archetype drill$md$, summary = $md$Week 16 puts the month together in one filmed drill: you coach the same correction to two very different members, and the review looks only at how your delivery changed and whether it landed for each of them. This drill comes back at the mock gate in Week 22 and the Instructor gate in Week 24, so this week is your first real rep at it.$md$, system_focus = $md$Semi-Private Pro: keep logging results and modifications for every member you coach.$md$, updated_at = now() where n = 16;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (16, 1, 'lesson', $md$Monday: Same correction, different person$md$, $md$On the floor today: Pick one correction and practice saying it four ways, one for each quadrant, before you coach today.$md$, $md$The archetype drill is simple to describe and hard to do well. You pick one correction, say a chest that drops in the squat, and coach it to two members who are very different people. Then you watch the film and ask two questions: did my delivery change, and did it land for each of them?

What stays the same is the movement standard. Both members need a tall chest. What changes is everything else in the Floor Loop: what you noticed about each person, how you read them, what you chose, and how you delivered it.

For an Analyst, you might give the reason first: "When your chest drops, the bar pulls you forward and your back takes the load. Keep it tall and your legs do the work." Then one clear cue and time to try it.

For a Rock, you might skip the explanation, come in quietly between sets, and use a spatial cue: "Try keeping your eyes on that mark on the wall. Nice. That's it."

For a Driver, the headline and the standard: "Chest up. Next set, every rep."

For an Energizer, energy and a little audience of one: "That last rep was your best one. Do that chest again."

None of these is better than the others. Each one fits a person. That's the whole idea of the Instructor phase.

**On the floor today:** Pick one correction and practice saying it four ways, one for each quadrant, before you coach today.

**Check yourself:** Which version would you naturally use for everyone, and who wouldn't it work for?$md$),
  (16, 2, 'lesson', $md$Tuesday: Reading before choosing$md$, $md$On the floor today: Before each block, take five seconds to read the state of one member you know well, and adjust one thing because of it.$md$, $md$The archetype drill depends on the Read beat of the Floor Loop. If you read the person wrong, you'll choose the wrong delivery, no matter how good your cue is.

Reading has two parts. **State** is about today. Are they energetic, tired, distracted, frustrated, sore? A Driver who slept four hours might need permission instead of a push. **Type** is about who they usually are, from the quick read and, over time, the deep read.

A few honest cautions about reading people:

- **Your first read is a guess.** Hold it loosely and update it when they surprise you.
- **State can hide type.** A bad week can make anyone look like a Rock. Don't reclassify someone on one session.
- **Your own type gets in the way.** A coach who is a Driver tends to coach everyone like a Driver. Knowing your own default helps you notice when you're doing it.

The question that makes reading useful is always: what does this person need from me right now to get better at this? Not what's the label, but what's the need.

**On the floor today:** Before each block, take five seconds to read the state of one member you know well, and adjust one thing because of it.

**Check yourself:** What's your own quick-read type, and how does it show up in the way you coach?$md$),
  (16, 3, 'lesson', $md$Wednesday: Did it land?$md$, $md$On the floor today: After every correction today, do one deliberate confirm, and note which of the three outcomes you got.$md$, $md$The last beat of the Floor Loop, Confirm, is the one coaches skip most, and it's the one the archetype drill is scored on.

Confirming means checking whether your coaching actually changed something. Watch the next rep. Did the chest stay up? Ask one question: "How did that feel?" Read their face. Did they look clear, confused, annoyed, encouraged?

There are three outcomes.

**It landed.** The rep changed and the member looks like they get it. Reinforce it briefly ("That's it") and move on.

**It didn't change the rep.** Go back to Choose. Try a different cue type, a different angle, a different level of detail. Not the same cue, louder.

**It changed the rep but cost the relationship.** The member fixed it, but they look embarrassed or irritated. That's information too. Next time, choose a different delivery for them: more private, less detail, more permission.

The third outcome is the one coaches miss most often, because the rep looks fine. But a correction that makes someone feel small works once and costs you the next month.

**On the floor today:** After every correction today, do one deliberate confirm, and note which of the three outcomes you got.

**Check yourself:** When did a correction work on the rep but not on the person?$md$),
  (16, 4, 'lesson', $md$Thursday: Filming the drill$md$, $md$On the floor today: Choose your two members and your correction with your mentor, and get permission to film.$md$, $md$This week you film your first archetype drill. Here's how to set it up so the review is useful.

**Choose your two members with your mentor.** They should be genuinely different, ideally from opposite quadrants, and both comfortable being filmed. Ask permission first.

**Choose a correction they both need,** something real you've seen in both of them, not one you invented for the film.

**Film each correction from start to finish:** the Notice, your delivery, and at least two reps after, so the Confirm is visible.

**Write your self-review before your mentor watches.** For each member, answer: what did I notice, how did I read them, what did I choose and why, how did I deliver it, and did it land?

The review is scored entirely on how your delivery changed between the two members and whether each landed. A technically perfect cue delivered the same way to both people scores lower than an imperfect cue that clearly fit each person.

Don't be discouraged if the first drill is clumsy. Most people's first archetype drill shows two nearly identical deliveries. Seeing that on film is how it starts to change.

**On the floor today:** Choose your two members and your correction with your mentor, and get permission to film.

**Check yourself:** Why did you pick these two members?$md$),
  (16, 5, 'lesson', $md$Friday: Putting it in words$md$, $md$On the floor today: Watch your drill film once with the sound off, and notice what your body language changed between the two members.$md$, $md$The homework for this week is a written reflection on your archetype drill, using the vocabulary from *Conscious Coaching*, and you'll present it at the huddle.

Writing it down does two things. It forces you to name what you actually did, which is harder than it sounds. And it builds a shared language with the rest of the cohort and your mentors, so that when someone says "I gave her the skeptic version," everybody knows what that means.

A good reflection covers:

- **The two members,** described by their quick read, likely drive, and the kind of trust that matters most to them
- **What you chose for each,** and why
- **What landed and what didn't,** with the moment on film
- **What you'd do differently** next time

Keep it to a page. Specific beats thorough.

You're four weeks into the Instructor phase. Look at how differently you think about a single correction now compared to Week 12, when the job was mostly delivering the plan clearly. That shift, from what to say to how this person needs to hear it, is the center of everything from here to the gate.

**On the floor today:** Watch your drill film once with the sound off, and notice what your body language changed between the two members.

**Check yourself:** What's the biggest difference between how you coached the two members, and was it on purpose?$md$),
  (16, 6, 'lesson', $md$On the floor this week$md$, $md$Coach every day, choosing your delivery deliberately for the members you know best.$md$, $md$$md$),
  (16, 7, 'film', $md$Filmed rep$md$, $md$The archetype drill: the same correction coached to two very different members, filmed start to finish.$md$, $md$$md$),
  (16, 8, 'homework', $md$Homework$md$, $md$A one-page reflection on your drill in Conscious Coaching vocabulary.$md$, $md$$md$),
  (16, 9, 'huddle', $md$Huddle$md$, $md$Present your archetype drill reflection to the cohort.$md$, $md$$md$),
  (16, 10, 'lesson', $md$Reading$md$, $md$Conscious Coaching, plus your certification text.$md$, $md$$md$);
