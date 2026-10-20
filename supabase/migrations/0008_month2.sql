-- Month 2 of BaseCamp (weeks 5-8): full daily lessons from the
-- "BaseCamp Month 2: Daily Lessons" review doc (Oct 20, 2026), replacing the
-- placeholder tasks. Refuses to run if any intern already has progress in
-- weeks 5-8, so nobody's recorded work is lost.

do $chk$
begin
  if exists (select 1 from public.task_progress p join public.tasks t on t.id = p.task_id where t.week_n between 5 and 8) then
    raise exception 'Interns already have progress in weeks 5-8. Edit those weeks in the admin screen instead.';
  end if;
end $chk$;

delete from public.tasks where week_n between 5 and 8;

update public.weeks set title = $md$Owning a block$md$, summary = $md$Week 5 is when you stop only assisting. Your mentor still leads the session, but two blocks are yours every day. You'll also choose your certification and start learning exactly what good looks like for the movements you'll coach most.$md$, system_focus = $md$No new system this week. Keep a session note in PushPress for every segment you touch.$md$, updated_at = now() where n = 5;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (5, 1, 'lesson', $md$Monday: Choosing your certification$md$, $md$On the floor today: Ask two coaches which certification they did first and what they wish they'd done differently.$md$, $md$Before the Instructor gate, you'll complete one of two certifications: CrossFit Level 1 (CF-L1) or the NASM Certified Personal Trainer (NASM-CPT). We fund it. This week you and your mentor pick one and put a study plan on the calendar.

This isn't an administrative choice, so don't let it be one. The real question is what your first two years on our floor are most likely to look like.

**CF-L1** is the better fit if most of your coaching will be group and semi-private. It's a two-day live course built around coaching a room: the foundational movements, how to see faults across a group, and how to scale a workout so everyone gets the same stimulus.

**NASM-CPT** is the better fit if you're leaning toward personal training and one-on-one work. It's self-paced, heavier on anatomy, assessment, and program design for an individual, and it ends with a proctored exam.

Either way, the second one gets funded in your first months after you're hired, so you're not choosing forever. You're choosing what to learn first.

A study plan that works has three parts. A fixed time on your calendar, ideally the same slot four or five days a week. A small target for each session (one chapter, one movement, one practice quiz) rather than "study for an hour." And a halfway date. Yours is the end of Week 8, when the checkpoint will ask whether you're on pace.

**On the floor today:** Ask two coaches which certification they did first and what they wish they'd done differently.

**Check yourself:** Which kind of coaching do you expect to be doing most in two years, and which cert serves that better?$md$),
  (5, 2, 'lesson', $md$Tuesday: What points of performance are for$md$, $md$On the floor today: Pick one movement in today's session and, for every member, decide whether they hit the setup before the first rep.$md$, $md$A point of performance is one of the few things that has to be true for a rep to count as good. Not every detail of the movement, only the ones that matter most for safety and effectiveness.

They're how you see. Without them, a squat is just "looks fine" or "looks off." With them, you can say exactly which part is off and what to look at first.

They're also how you talk. In a class, you'll name one or two points of performance for the day's main movement, not ten. The members who need more get it from you one-on-one during the work. A coach who explains everything up front has lost the room before anyone picks up a weight.

Remember the order from Week 3: mechanics, then consistency, then intensity. Points of performance are the mechanics. A member's rep has to hit them before it gets repeated a lot, and it has to hit them every time before it gets heavier or faster.

For each movement this week and next, you'll learn three things: the setup, the points of performance through the rep, and the faults you'll see most. Learn them in that order. Most faults start in a bad setup.

As a Presenter, you're still seeing more than correcting. When you see a fault, you can give the one cue from the plan. If that doesn't fix it, or if load is involved, flag it to the coach.

**On the floor today:** Pick one movement in today's session and, for every member, decide whether they hit the setup before the first rep.

**Check yourself:** Why does a class get one or two points of performance and not the whole list?$md$),
  (5, 3, 'lesson', $md$Wednesday: The squat family$md$, $md$On the floor today: Watch every squat in today's session and note the single most common fault you saw.$md$, $md$Our squat progression runs from the air squat to the goblet squat, then the front squat, then the back squat. The points of performance are the same all the way up. The load just makes them harder to keep.

**Setup.** Feet about shoulder width, toes turned out slightly, weight across the whole foot. Brace before you descend: a breath into the belly and a tight midline.

**Points of performance.**

- Hips move back and down together.
- Knees track in line with the toes.
- The heels stay down and the whole foot stays on the floor.
- The spine stays neutral and the chest stays tall.
- Depth is hip crease below the top of the knee when the member's mobility allows it.
- The rep finishes at full hip and knee extension.

**Faults you'll see most.** Knees caving in. Heels rising. The lower back rounding at the bottom. Cutting depth short. In a goblet or front squat, the elbows dropping and the chest falling forward with them.

The progression matters. A member who can't keep their heels down in an air squat isn't ready for a barbell on their back. That's not a judgment, it's the Capability Hierarchy doing its job.

**On the floor today:** Watch every squat in today's session and note the single most common fault you saw.

**Check yourself:** A member's knees cave on heavy goblet squats but not on air squats. What does that tell you?$md$),
  (5, 4, 'lesson', $md$Thursday: The hinge family$md$, $md$On the floor today: Do ten kettlebell RDLs yourself in front of a mirror, slowly, and feel where your hamstrings load.$md$, $md$The hinge is the pattern most beginners do worst and most people need most. Picking a bag of groceries up off the floor is a hinge. Our progression runs from the good morning to the kettlebell Romanian deadlift, then the double kettlebell and trap bar deadlifts, then the sumo and conventional barbell deadlifts.

**Setup.** Feet about hip width. The load starts close: over the middle of the foot for a deadlift, against the thighs for an RDL. Shoulders back, lats tight ("bend the bar" or "put your armpits in your back pockets"), and brace before the weight moves.

**Points of performance.**

- The hips move back, not down. It's a hinge, not a squat.
- The spine stays neutral from the head to the hips the whole way.
- The load stays close to the body.
- The knees soften but stay quiet. In an RDL they barely bend.
- The rep finishes with the hips through and the glutes squeezed, standing tall, without leaning back.

**Faults you'll see most.** A rounded back, usually the lower back as the weight leaves the floor. The load drifting away from the legs. Squatting the weight up instead of hinging. Leaning back at the top to "finish."

A hinge fault under load is one of the most common ways people get hurt in a gym. If you see a rounding back on a heavy pull, flag it to the coach right away. Don't wait for the next set.

**On the floor today:** Do ten kettlebell RDLs yourself in front of a mirror, slowly, and feel where your hamstrings load.

**Check yourself:** How would you explain the difference between a hinge and a squat to a member in one sentence?$md$),
  (5, 5, 'lesson', $md$Friday: The push family$md$, $md$On the floor today: In one session, count how many members keep their ribs down on their last set of presses.$md$, $md$Pushing covers the push-up and the presses: the strict press, the push press, and the push jerk, plus combinations like the thruster and the wall ball. The common thread is a stable trunk that lets the arms do their job.

**Push-up.** Hands just outside the shoulders, body in one straight line from head to heels, the midline braced. Elbows track back at roughly 45 degrees, not flared straight out. Chest to the floor (or to the box for an incline), then lock the arms out at the top. Faults: hips sagging, the head reaching for the floor, cutting the range short.

**Strict press.** The bar rests on the front of the shoulders, hands just outside them, elbows slightly in front of the bar. Glutes and midline tight. The head moves back so the bar travels in a straight line, then forward "through the window" as the bar passes. Finish with the bar over the middle of the foot, arms locked, biceps by the ears. Faults: leaning back and turning it into a standing bench press, the bar drifting forward, not finishing overhead.

**Push press.** Same setup. A short, straight dip with the knees, heels down, torso upright, then drive hard with the legs and press to finish. Faults: dipping forward onto the toes, pressing before the legs finish their drive.

The press is where you'll see the most "cheating" as people get tired: the lower back arches and the ribs flare. That's usually a sign the load is too heavy for their trunk, not that they need to try harder.

**On the floor today:** In one session, count how many members keep their ribs down on their last set of presses.

**Check yourself:** A member's lower back arches on the last reps of a strict press. Is that a cue problem or a load problem, and why?$md$),
  (5, 6, 'lesson', $md$On the floor this week$md$, $md$Co-coach every session. Your mentor leads, and you own two blocks each day.$md$, $md$$md$),
  (5, 7, 'film', $md$Filmed rep$md$, $md$Film one block you own. Write your self-review first, then post it in Slack.$md$, $md$$md$),
  (5, 8, 'homework', $md$Homework$md$, $md$Your certification choice, your study plan on the calendar, and your first study block finished.$md$, $md$$md$),
  (5, 9, 'huddle', $md$Huddle$md$, $md$Bring one fault you saw this week and what you did about it.$md$, $md$$md$),
  (5, 10, 'lesson', $md$Reading$md$, $md$Keep going with The Coaching Habit, plus your certification text.$md$, $md$$md$);

update public.weeks set title = $md$Connection at scale$md$, summary = $md$Week 6 finishes the movement standards and puts them to the test in the demo audit. Then it turns back to people. Knowing 20 members was Week 2. Now the job is making every person in a full class feel seen in under an hour, and earning the kind of trust that comes from being straight with them.$md$, system_focus = $md$The PushPress class roster. Your connection log is checked against it this week.$md$, updated_at = now() where n = 6;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (6, 1, 'lesson', $md$Monday: The pull family$md$, $md$On the floor today: Watch every pull in today's session and note who's finishing each rep at straight arms.$md$, $md$Our pulling progression runs from the ring row to the banded pull-up, then the chin-up, then the strict pull-up. Rows with dumbbells and kettlebells live here too. Most adults are far weaker at pulling than pushing, which is a big part of why it gets so much attention in our programming.

**Ring row.** Rings at a height where the member can do clean reps. Body in one straight line from heels to head, like a moving plank. Pull the chest to the rings with the shoulder blades squeezing back, then lower under control to straight arms. The more horizontal the body, the harder it gets. Faults: hips sagging, shrugging up toward the ears, half reps.

**Banded pull-up and pull-up.** Start from a full hang, arms straight. Pull the shoulder blades down and back first, then pull the chin over the bar. Lower all the way to straight arms. The band should make the rep possible, not make it easy. Faults: kipping or swinging when the plan calls for strict, chin reaching instead of the body rising, skipping the bottom half.

When a member can't do any version cleanly, the answer is a ring row at a steeper angle, not a band so thick it does the work for them.

**On the floor today:** Watch every pull in today's session and note who's finishing each rep at straight arms.

**Check yourself:** Why does a ring row usually teach the pull better than a thick band does?$md$),
  (6, 2, 'lesson', $md$Tuesday: Carry, brace, and locomotion$md$, $md$On the floor today: Set up the rower and the bike for three members of different heights and check each one with your mentor.$md$, $md$These three are less glamorous than a barbell and matter more for daily life than almost anything else we teach.

**Carry.** Farmer, suitcase, and waiter carries. Pick the weight up with a good hinge. Stand tall with the shoulders down and back and the ribs stacked over the hips. Walk with short, controlled steps. In a suitcase carry (one side loaded), the trunk stays level and doesn't lean away from the weight. Overhead in a waiter carry, the arm stays locked with the biceps by the ear. Faults: leaning, shrugging, rushing.

**Brace.** Planks, side planks, hollow holds, and dead bugs. The goal is a midline that stays still while the arms and legs move. The lower back stays where it is, the ribs stay down, and the member keeps breathing. A plank that's held by holding the breath isn't a brace. Faults: the lower back arching, the hips sagging or piking, breath-holding.

**Locomotion.** Running, rowing, biking, and the sled. On the rower, the stroke is legs, then body, then arms on the way out, and arms, then body, then legs on the way back, with the feet strapped across the ball of the foot. On the bike, set the seat so the knee keeps a slight bend at the bottom of the pedal stroke. On the sled, the body leans into it at about 45 degrees with short, driving steps. Faults on the rower: pulling with the arms first, and the knees rising before the handle clears them on the way back.

Notice how often the brace shows up inside the other patterns. A strong carry, a clean press, and a safe deadlift all depend on it.

**On the floor today:** Set up the rower and the bike for three members of different heights and check each one with your mentor.

**Check yourself:** Why do we call a breath-holding plank "not a brace"?$md$),
  (6, 3, 'lesson', $md$Wednesday: The demo audit$md$, $md$On the floor today: Film yourself doing every foundational movement and mark any rep you wouldn't want a member to copy.$md$, $md$This week you'll demonstrate every foundational movement to standard while your mentor watches and films. That's the demo audit. It comes back at Week 11, and passing it is part of the Presenter gate.

The standard is a 3 or better on every movement: competent and reliable. If something doesn't work in your own body (an old shoulder injury, a hip that won't let you squat to depth), that's fine. You and your mentor write down a modification and a plan, and that counts. What doesn't count is skipping a movement or hoping no one notices.

Three things to remember from Week 4's lesson on demonstration:

- **Show the important part from the right angle.** A hinge from the side, a squat stance from the front.
- **Move slower than real speed.** Members need time to see each position.
- **Show first, then talk.** Demo in silence, then name the one thing to watch for.

Prepare by filming yourself on every movement first, then reviewing it against the points of performance before your mentor sees it. Most people find two or three things they'd never have noticed otherwise. That's the point.

One more thing. Your demo is a promise. When you show a scaled version, show it with the same care as the main version. Members watch how you talk about the easier option as closely as they watch the movement.

**On the floor today:** Film yourself doing every foundational movement and mark any rep you wouldn't want a member to copy.

**Check yourself:** Which movement is your weakest demo, and what's your plan before the audit?$md$),
  (6, 4, 'lesson', $md$Thursday: Every member, every class$md$, $md$On the floor today: Track your touchpoints for one full class. Who did you miss?$md$, $md$Knowing members by name was the start. The harder skill is making every person in a full class feel coached, not only the ones who are easy to talk to.

Aim for at least one real touchpoint with every member, every session. A touchpoint is a name plus something specific: a cue, a question, an observation. "Nice work" doesn't count. "That was your smoothest set of rows yet, Maria" does.

Watch for the quiet member. In every class there's someone who doesn't ask for anything, doesn't cause problems, and leaves without anyone really talking to them. They're often the member who quietly cancels three months later. Find them early in the session and get to them first.

The opposite problem is the member who wants all of your attention. Be warm, and then move on. Your energy is a resource, and the room needs it spread evenly. You learned to disengage respectfully in Week 1. This is where it gets used every day.

The fastest way to connect with someone new is commonality: genuine common ground, found quickly. Maybe it's the same neighborhood, the same kid's school, the same terrible knee. It has to be real. People can tell when you're pretending to care about their fantasy football team.

**On the floor today:** Track your touchpoints for one full class. Who did you miss?

**Check yourself:** Who's the quiet member in your most common slot, and what do you know about them?$md$),
  (6, 5, 'lesson', $md$Friday: Credibility$md$, $md$On the floor today: Count how many times you use a technical word with a member. Replace each one with plain language.$md$, $md$Members trust coaches who are clear, who are honest, and who follow through. That's credibility, and it's built in small moments.

The first rule is saying only what the member needs. Nine times out of ten, the member doesn't need the anatomy or the jargon. They need one clear thing to do. "Push the floor away" is more useful than a lesson on knee extension, and it doesn't make them feel like they should already know what you're talking about.

The second rule is what to do when you don't know. You'll get asked about supplements, injuries, diets, and programs you've never heard of. The worst answer is a confident guess. The best one sounds like this: "I'll be honest. I have some ideas, but I don't want to give you a BS answer. Let me check and get back to you by tomorrow." Then actually get back to them by tomorrow, after you've asked your mentor or the coach on the floor.

That answer builds more trust than a perfect guess would, because it shows the member you care more about being right for them than about looking smart. And when you follow through, it proves you meant it.

The third rule is that credibility is lost faster than it's built. One promise you don't keep, one name you forget after they told you twice, one cue that contradicts what the coach said a minute ago, and you're back to the start with that member.

**On the floor today:** Count how many times you use a technical word with a member. Replace each one with plain language.

**Check yourself:** When did you last guess at an answer instead of saying you'd find out?$md$),
  (6, 6, 'lesson', $md$On the floor this week$md$, $md$Own the room's energy for one full segment every day.$md$, $md$$md$),
  (6, 7, 'film', $md$Filmed rep$md$, $md$Your demo audit. Every foundational movement, filmed, with your self-review written before your mentor scores it.$md$, $md$$md$),
  (6, 8, 'homework', $md$Homework$md$, $md$Connection log v2. Every member in one class, one touchpoint each, cross-checked against the PushPress roster.$md$, $md$$md$),
  (6, 9, 'huddle', $md$Huddle$md$, $md$Bring your weakest demo and get feedback on it from the group.$md$, $md$$md$),
  (6, 10, 'lesson', $md$Reading$md$, $md$The Coaching Habit and your certification text.$md$, $md$$md$);

update public.weeks set title = $md$The front door of coaching$md$, summary = $md$Every member's relationship with District H starts before they walk in, on a discovery call. Week 7 is about that first conversation: what it's for, how it's structured, what happens after it, and how we debrief it. You'll shadow two discovery calls and one consultation, and you'll see where every lead lives in Lead Connector.$md$, system_focus = $md$Lead Connector front of funnel: where leads live, the pipeline stages, and what happens after the call. Kinotek, observed during a MAP.$md$, updated_at = now() where n = 7;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (7, 1, 'lesson', $md$Monday: Triage, not sales$md$, $md$On the floor today: Ask the coach who runs most of our discovery calls what makes a call go well.$md$, $md$The discovery call is a 15-20 minute phone or video call with someone who raised their hand: they filled out a form, took the quiz, or asked about getting started. Before the call, they've filled in an intake form and been sent a short video about how we work.

The most important thing to understand about this call is what it isn't. It isn't a sales call. It's triage. Our job is to figure out how much coaching this person needs, not which membership we can sell them. We sort people by coaching complexity, not by how price-sensitive they seem.

Every call ends in one of four places:

- **Not a good fit.** We help them find the right place, even if it isn't us.
- **A good fit who needs in-person support.** They book a consultation.
- **A good fit who wants remote coaching.** They can sign up on the call.
- **A good fit with training experience who's ready to go.** They book a free trial with a short consultation afterward.

What decides it? Their why, and how complex their situation is. Someone with pain, limited range of motion, or a long layoff needs an in-person assessment before anyone writes them a program. Someone who needs help with sleep, stress, and eating as much as training needs a consultation. Someone with no major limitations who has trained before can often start with a trial.

The product is the prescription. On the call, we talk about what they need, not the details of how we'll deliver it. That comes later.

The one number that matters on a discovery call is a next step booked. Not a sale. A next step.

**On the floor today:** Ask the coach who runs most of our discovery calls what makes a call go well.

**Check yourself:** Why does sorting by coaching complexity serve the member better than sorting by price?$md$),
  (7, 2, 'lesson', $md$Tuesday: The shape of the call$md$, $md$On the floor today: Listen for the frame and the why on the first call you shadow, and write down the exact words the person used for their why.$md$, $md$Our discovery calls follow the same structure every time. You won't run one until Week 10, but you need to know the shape now so you can follow along when you shadow.

1. **The frame.** "Today's goal is just to clarify some of your goals and make sure we're the very best people to help you. Sound like a plan?" Then wait for their answer.
2. **Their why.** "You mentioned X is most important to you. Can you tell me more about why that matters?" This is the emotional driver, and the coach keeps asking until they find it.
3. **Training experience.** What they've done before, and what happened.
4. **Aches and pains.** "What movements tend to bother you?"
5. **Consistency.** What's gotten in the way before. When it comes up, the line we use is: "Most people don't struggle with effort. They struggle with structure and accountability."
6. **Support.** What kind of help they want.
7. **Success.** "In a perfect world, if we look at one year from today, what would success look like for you?"
8. **The next step.** A consultation, a trial, or a referral.

If weight loss or energy comes up, the coach asks them to grade their habits outside the gym from A to F. That's the other 23 hours showing up on day one.

Notice how much of this is questions. The coach talks maybe 20 percent of the time. You'll recognize the habit from *The Coaching Habit*: stay curious a little longer, and don't rush to advice.

Price only comes up if the person asks, and then the coach gives ranges, not a pitch.

**On the floor today:** Listen for the frame and the why on the first call you shadow, and write down the exact words the person used for their why.

**Check yourself:** Which step of the call do you think is hardest to do well, and why?$md$),
  (7, 3, 'lesson', $md$Wednesday: The consultation and the Elevate MAP$md$, $md$On the floor today: Shadow a consultation or MAP if one is scheduled. If not, ask a coach to walk you through a recent MAP result.$md$, $md$When a discovery call ends with "book a consultation," this is what that person walks into.

The consultation is an in-person meeting with a senior coach. It's where we learn the whole person: their goals, history, schedule, and the life around their training. For many members it includes the Elevate MAP, our assessment.

The MAP looks at four things: how well someone moves (a battery of movements scored for competency), their body composition, their aerobic capacity, and their lifestyle. The result places them in the Capability Hierarchy, which tells us where they start and what comes next. You'll also see Kinotek, the 3D movement scan we use during the MAP. Pay attention to what it captures and how the coach uses it in the conversation.

The part to watch most closely is the results conversation. A good coach doesn't read numbers to a member. They turn the results into a story the member recognizes about themselves, and then into a plan. "Your hips don't love deep squats yet, which is probably why your back gets tight on long drives. Here's how we'll work on that."

You won't administer a MAP until well after you're hired. That's Trainer work. Right now you're learning what good looks like, so that when a member tells you about their consultation, you know what they went through.

**On the floor today:** Shadow a consultation or MAP if one is scheduled. If not, ask a coach to walk you through a recent MAP result.

**Check yourself:** What's the difference between reporting results and coaching them?$md$),
  (7, 4, 'lesson', $md$Thursday: Debriefing with NEPA$md$, $md$On the floor today: Run NEPA on one interaction from today's session: something you noticed, what it meant, what you did, and what you'd do next time.$md$, $md$After every call or consultation you shadow, you'll debrief it with your mentor. We use a four-step loop called NEPA.

**Notice without judgment.** What actually happened? What did the person say, and what did they not say? "She seemed nervous about cost" is an observation. "She's cheap" is a judgment.

**Explain through questions.** Why did the coach ask what they asked? What was each question meant to build? What changed in the conversation after the why came out?

**Prescribe from findings.** Based on what was said, was the next step the right one? Would you have chosen differently, and why?

**Act with a plan.** What will you do differently the next time you're in that conversation, or the next time you meet this person on the floor?

NEPA isn't only for calls. It's the same shape as the Floor Loop you'll learn in Week 13: see clearly before you decide what it means. Getting the habit now, with low stakes, makes it automatic later.

The homework for this week is a NEPA debrief of each call you shadow, plus one extra question: where did each answer the person gave end up in our system? A detail that doesn't get written down is lost the moment the call ends.

**On the floor today:** Run NEPA on one interaction from today's session: something you noticed, what it meant, what you did, and what you'd do next time.

**Check yourself:** Which step of NEPA do you tend to skip?$md$),
  (7, 5, 'lesson', $md$Friday: Intent, and where leads live$md$, $md$On the floor today: With your mentor, follow one recent lead through Lead Connector from first form to where they are today.$md$, $md$The last of our four kinds of trust is intent. People can tell, quickly and accurately, whether you're trying to help them or trying to get something from them. If the person on a discovery call senses that the coach wants a sale more than a good outcome for them, nothing else on the call matters.

That's why the best discovery calls sound like curiosity, not persuasion. The coach is genuinely trying to figure out what this person needs, including when the answer is "not us."

Now the machine behind the conversation. Every lead lives in Lead Connector, our CRM. When someone fills out a form, they land in a pipeline: a series of stages that shows where each person is, from new lead to booked call to consultation to member. After a call, the coach updates the stage, writes the notes, and sets the next step, the same day.

If a consultation or trial is booked, the call notes go in PushPress. If nothing is booked, they go on the person's profile in Lead Connector. When someone cancels or doesn't show, they move to a nurture stage where an automated sequence tries to rebook them. After a free trial, there's a text an hour later, another the next day, and a call on day two.

You'll own call logging in Week 10. The rule then will be the same as for session notes: a call that isn't logged didn't happen. This week, just learn where everything lives.

**On the floor today:** With your mentor, follow one recent lead through Lead Connector from first form to where they are today.

**Check yourself:** How could a member tell, in the first two minutes, whether a coach cared more about them or about the sale?$md$),
  (7, 6, 'lesson', $md$On the floor this week$md$, $md$Shadow two discovery calls and one consultation or MAP. Keep owning two blocks a day.$md$, $md$$md$),
  (7, 7, 'film', $md$Filmed rep$md$, $md$Film one block you own. Self-review first.$md$, $md$$md$),
  (7, 8, 'homework', $md$Homework$md$, $md$A NEPA debrief of each call you shadowed, including what each question built and where each answer landed in our system.$md$, $md$$md$),
  (7, 9, 'huddle', $md$Huddle$md$, $md$Share one thing a prospect said on a call that changed how you think about our members.$md$, $md$$md$),
  (7, 10, 'lesson', $md$Reading$md$, $md$The Coaching Habit and your certification text.$md$, $md$$md$);

update public.weeks set title = $md$The checkpoint$md$, summary = $md$Week 8 is the halfway point of the Presenter phase and the first formal checkpoint. Your mentor and Morrill will review your film, your records, and how you handle feedback. The lessons this week are about the things that checkpoint looks at most closely.$md$, system_focus = $md$The first records spot-check: your session notes and Slack posts, reviewed like film.$md$, updated_at = now() where n = 8;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (8, 1, 'lesson', $md$Monday: Correction Tuesday, evidence Thursday$md$, $md$On the floor today: Pick the most recent correction your mentor gave you and make it the only thing you focus on today.$md$, $md$If we had to pick one thing that predicts whether someone becomes a great coach, it wouldn't be talent, charisma, or how much they already know. It would be how fast they apply feedback.

Here's how we look at it. If your mentor gives you a correction on Tuesday, can we see it on the floor or on film by Thursday? Not perfectly, but clearly. That's the single strongest hiring signal we have, and it's a big part of what the Week 8 checkpoint looks at.

Applying feedback fast takes a few habits.

**Write it down.** Feedback you only heard is feedback you'll forget. Put each correction in your floor journal the same day, in your own words.

**Pick one thing.** If you got five notes, choose the one that matters most and work on that first. Trying to fix everything at once usually fixes nothing.

**Make it visible.** Tell your mentor what you're working on, and ask them to watch for it. "I'm working on pausing after instructions. Can you watch my warm-up and tell me if I did it?"

**Don't defend.** When you hear a correction, the only words you need are "Thanks, got it." If you have context, share it later. Explaining why you did something in the moment sounds like you're arguing with the feedback, even when you're not.

This is the Growth Minded value in practice. It's also the habit that makes the next four years of your development go faster.

**On the floor today:** Pick the most recent correction your mentor gave you and make it the only thing you focus on today.

**Check yourself:** What was the last piece of feedback you got, and where's the evidence that you applied it?$md$),
  (8, 2, 'lesson', $md$Tuesday: Scaling as service$md$, $md$On the floor today: Offer every scaled option today as a choice or a plan, never as "just do this instead."$md$, $md$Every foundational movement has a scaled-down version and a scaled-up version in our group template. By the checkpoint you should know the options for every movement without looking them up.

Knowing the menu is the easy part. The hard part is offering a scaled option so the member takes it without feeling like they failed.

Compare these:

- "Just do this instead." (Sounds like a demotion.)
- "You're not ready for that yet." (Sounds like a judgment.)
- "Today let's use the box squat. It'll let you go a little heavier with great depth." (Sounds like a plan.)

The third one works because it gives a reason that's about their goal, not about their limits. You can also offer it as a choice: "Here's the box squat, here's the back squat. Which one fits today?" Most people pick well when they're asked respectfully.

Two more rules. Scale the movement or the load to keep the intended stimulus, not just to make it easier. And remember that a member scaling today isn't the same as a member who can't. Bad sleep, a stressful week, or a sore back from moving furniture are all good reasons to scale, and someone who scales smartly is a member who'll still be here next year.

As a Presenter, you're offering the option the coach has already chosen. Choosing it yourself comes later.

**On the floor today:** Offer every scaled option today as a choice or a plan, never as "just do this instead."

**Check yourself:** When was the last time someone offered you an easier option in a way that felt respectful?$md$),
  (8, 3, 'lesson', $md$Wednesday: Hearing yourself$md$, $md$On the floor today: Transcribe two minutes of your film, circle your most common tic, and give the same instructions again without it.$md$, $md$Most new coaches have no idea how they actually sound. This week you'll find out.

There are three habits to listen for. **Softeners** are words that make an instruction sound optional: "maybe," "kind of," "if you want," "just." **Negations** tell people what not to do instead of what to do: "don't let your knees cave" instead of "push your knees out." **Filler** fills silence: "um," "so," "like," "OK," "you know."

None of these make you a bad coach. Everyone has them. But together they make your instructions weaker, longer, and harder to follow. A member hears "So, um, maybe try to kind of keep your chest up?" as a suggestion. They hear "Chest tall" as the plan.

The fix is a simple drill. Take two minutes of your own film and transcribe it word for word. Mark every softener, negation, and filler word. Then deliver the same segment again, clean, and film it. Compare the two. Most people are surprised by how much better the second one sounds, and by how much shorter it is.

Start with your own speech, not members'. You'll learn to listen for this in other people later. For now, the only mouth you're working on is yours.

**On the floor today:** Transcribe two minutes of your film, circle your most common tic, and give the same instructions again without it.

**Check yourself:** What are your three most frequent verbal tics, and what are you replacing each one with?$md$),
  (8, 4, 'lesson', $md$Thursday: Your records are film too$md$, $md$On the floor today: Read back every session note you wrote this week and rewrite the weakest one.$md$, $md$This week is the first records spot-check. Your mentor will review a sample of your session notes and your Slack posts the same way they review your film: for what's there, what's missing, and what it says about you as a professional.

Here's what they'll look for.

**Session notes.** Is there a note for every segment you coached? Is each one specific and factual, written the same day? Would the next coach know what to do with it? "Left knee bothered her on step-ups, swapped to split squats" passes. "Good session" doesn't.

**Film posts.** Is your self-review written before anyone else commented? Is it honest, and does it name what you'll work on next?

**Homework and huddle notes.** On time, complete, and in the right channel.

**Tone.** Your Slack posts are professional communication. They're read by your mentor, the GM, and eventually by people deciding whether to hire you.

Records matter for a reason that's bigger than the checkpoint. A coach with great floor skills and messy records is hard to trust with members, because everyone who coaches that member after them is working blind. Our whole model depends on any coach being able to serve any member to the same standard. That only works if the notes are good.

**On the floor today:** Read back every session note you wrote this week and rewrite the weakest one.

**Check yourself:** If a coach you've never met read only your notes, what would they think of you?$md$),
  (8, 5, 'lesson', $md$Friday: Halfway$md$, $md$On the floor today: Write down the three things you're proudest of from the last eight weeks and the one thing you most want help with.$md$, $md$You're halfway through the Presenter phase. The checkpoint at the end of this week is with your mentor and Morrill. Here's what it is, and what it isn't.

It isn't a pass or fail. It's an honest early warning. Experience says that someone who isn't on track at Week 8 rarely closes the gap by Week 12, and it's kinder to say so now, while there's time to do something about it, than to surprise you at the gate.

It looks at:

- your filmed warm-up and coached block, scored against the rubric
- how fast you apply feedback
- your records spot-check
- your scaling knowledge and your demo audit
- names: every member in your core slots
- your certification progress (you should be halfway)
- whether you've finished *The Coaching Habit*
- the professional standard: on time, prepared, dressed, consistent

You'll leave with one of three outcomes, the same as Week 4: on track, on track with a focus, or a written plan with a date to check again.

Look back at your Week 1 film once more before you walk in. Whatever the checkpoint says, that difference is real, and you built it.

**On the floor today:** Write down the three things you're proudest of from the last eight weeks and the one thing you most want help with.

**Check yourself:** If you were your mentor, what would you say is your biggest strength and your biggest gap?$md$),
  (8, 6, 'lesson', $md$On the floor this week$md$, $md$Lead the warm-up and one coached block every day, and offer the scaled options the coach has chosen.$md$, $md$$md$),
  (8, 7, 'film', $md$Filmed rep$md$, $md$Your filmed warm-up and block for the checkpoint. Self-review first.$md$, $md$$md$),
  (8, 8, 'homework', $md$Homework$md$, $md$Your certification halfway milestone, The Coaching Habit finished, and your three verbal tics with the replacement you're practicing.$md$, $md$$md$),
  (8, 9, 'huddle', $md$Huddle$md$, $md$Coaching Habit translation huddle #2: the question from the book you use most now, and how you say it in gym language.$md$, $md$$md$),
  (8, 10, 'lesson', $md$Reading$md$, $md$Finish The Coaching Habit.$md$, $md$$md$),
  (8, 11, 'huddle', $md$Week 8 checkpoint with your mentor and Morrill$md$, $md$A 45-minute review at the end of the week. Read what it looks at.$md$, $md$A 45-minute review with your mentor and Morrill. Each row is scored 1 (unsafe or absent) to 5 (an example for others).

- **Warm-up and block delivery.** Scored film and floor observation (3 or better, zero safety flags)
- **Applying feedback.** A correction given, and evidence two days later (Visible change)
- **Records.** The records spot-check (Complete, specific, on time)
- **Scaling and demos.** Oral check and the demo audit (Knows every option; 3 or better on every demo or a documented modification)
- **Names.** Spot-test (Every member in your core slots)
- **Certification.** Your study tracker (Halfway, on pace)
- **Professional standard.** Mentor and GM observation (Consistent)

Outcome: on track, on track with a focus, or a written plan with a date to check again.$md$);
