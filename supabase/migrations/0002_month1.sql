-- Month 1 of BaseCamp: full daily lessons for weeks 1-4, from the
-- "BaseCamp Month 1: Daily Lessons" review doc (approved Oct 19, 2026).
-- Adds a body column so a lesson can carry its full reading.

alter table public.tasks add column if not exists body text not null default '';

-- Refuse to run if any intern has already recorded work in weeks 1-4,
-- because replacing those tasks would erase their progress.
do $$
begin
  if exists (select 1 from public.task_progress p join public.tasks t on t.id = p.task_id where t.week_n <= 4) then
    raise exception 'Interns already have progress in weeks 1-4. Edit those weeks in the admin screen instead.';
  end if;
end $$;

delete from public.tasks where week_n <= 4;

update public.weeks set title = $md$Welcome to the profession$md$, summary = $md$Week 1 answers why District H exists, how it works, and what we expect of you, before you coach anyone. You'll spend the week observing every format on the floor and sitting in the client chair yourself.$md$, system_focus = $md$Slack (owned this week). All other logins are set up, and only Slack is taught.$md$, updated_at = now() where n = 1;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (1, 1, 'lesson', $md$Monday: Why we exist$md$, $md$On the floor today: Watch one session start to finish. Pick one member who looks like they're in that middle group and notice what the coach does to keep them coming back.$md$, $md$Most of the fitness industry serves two groups well. People who are genuinely sick get clinical care. The already-committed fifteen to twenty percent get an endless stream of new programs to chase.

Almost nobody serves the middle well. That's most adults: busy, often with a family, maybe carrying a few aches, and they've never found a routine that survived a hard season of life. They don't want to be athletes in the competitive sense. They want to get back into something and stay there, and they want it to make the rest of their life work better instead of competing with it.

That middle is who District H is for. It's also why this job matters. Writing a good program is getting easier every year, and software can do a reasonable version of it. What can't be automated is a person who helps someone change how they live and holds them to it over years. That is the job you're training for.

Our mission has two halves. For members, we build fitness that supports an elite life rather than competing with it, delivered in seasons instead of permanent maximum effort. For coaches, we build a real profession: a career with a provable number, learned on a real floor, with a job at the end. BaseCamp is the second half. It's paid, it's a trade apprenticeship, and it's the first stretch of what is realistically a five-year climb.

The industry hasn't earned its seat in preventive health yet. Medicine's skepticism of us is mostly deserved, and roughly eight in ten coaches leave the field within two years. That seat gets earned one serious coach at a time. You're here to be one of them.

**On the floor today:** Watch one session start to finish. Pick one member who looks like they're in that middle group and notice what the coach does to keep them coming back.

**Check yourself:** In one sentence, who does District H serve, and why does that need a professional?$md$),
  (1, 2, 'lesson', $md$Tuesday: The values, as behaviors$md$, $md$On the floor today: For each value, write down one thing you saw a coach do today that showed it.$md$, $md$We have five core values, and we hire, gate, and part ways by them. They only count when you can see them, so each one comes with behaviors.

- **Professionalism.** On time, prepared, and dressed for the job before the first member walks in. The plan is read and the floor is reset.
- **Team First.** Members belong to the house, not to a coach. You cover for teammates, hand off cleanly, and never build a personal following on someone else's floor.
- **Service to Others.** We're the guides and members are the heroes. The goal is that the person in front of you leaves better than they arrived, not that you look impressive.
- **Growth Minded.** You take feedback without defending yourself, and you ask for it before it's offered. Methods are tools, not identities.
- **Holistic Approach.** We coach the other 23 hours too. Sleep, stress, nutrition, and daily life are coaching territory.

The standard you'll hear all quarter is short on purpose: professional appearance, command of the room, and preparation, consistently. Consistently is the word that does the work. Anyone can be sharp on review day.

We're also clear about what we're not looking for: people building a personal brand under our name, and people who want coaching to be a side interest.

**On the floor today:** For each value, write down one thing you saw a coach do today that showed it.

**Check yourself:** Which value will be easiest for you, and which will be hardest?$md$),
  (1, 3, 'lesson', $md$Wednesday: How the gym works$md$, $md$On the floor today: Count how many members in one session are in each service (group, semi-private, one-on-one). Ask your mentor which ones you got wrong.$md$, $md$You should understand the economics of the place you work. Coaches who don't tend to misread every decision the business makes.

Members pay for small group, semi-private, personal training, nutrition coaching, and individual design. Each delivery mode does a different job. Group establishes the floor and funds the base. One-on-one buys precision and trust where presence matters most. Individual design and remote coaching are where a coach lifts into professional pay. Session quality is a business concern, not just a craft concern, because revenue per coached hour is what makes salaried jobs with benefits possible.

A W-2 coach typically receives about 30-35% of the revenue they generate. A similar share goes to the organization, and the rest pays for rent, equipment, staff, software, insurance, and everything else that keeps the doors open. Think of that split as a trade: you earn less per client than an independent coach would, and in exchange you never have to go find a client.

That trade is what we call the Agreement, and it runs both ways. The house provides the audience, the systems, the equipment, the development, and the risk. You take care of the clients, you don't build a personal brand on our floor, and you don't take members with you if you leave. Your name, your reputation, and your craft are yours to take anywhere. Leaving someday is fine, and we'll wish you well.

The part that matters most this week: finding clients, the thing that breaks most independent coaches, is handled for you here. Your job is to be worth the audience you're given.

**On the floor today:** Count how many members in one session are in each service (group, semi-private, one-on-one). Ask your mentor which ones you got wrong.

**Check yourself:** In your own words, what does the house give you, and what do you give back?$md$),
  (1, 4, 'lesson', $md$Thursday: The journey of a career coach$md$, $md$On the floor today: Ask one coach which stage they'd say they're in, and what moved them to it.$md$, $md$There are five stages in a District H career. They aren't titles. Each is a different relationship to the work.

- **Presenter.** You connect with people and carry a room, delivering from a written plan (BaseCamp weeks 1-12)
- **Instructor.** You communicate with the person in front of you and teach movement. This gate is the hiring decision. (BaseCamp weeks 13-24)
- **Trainer.** You apply the method, assess, and individualize. Floor coaching is mastered here. (About month 12)
- **Coach.** You change behavior and own the other 23 hours (Years 2-3)
- **Professional.** You build coaches and handle the hardest, most individualized work (Years 4-5)

The honest timeline: getting genuinely good at this takes about five years, the way a trade does. Someone who starts in their early to mid twenties can be approaching six figures by thirty without leaving the floor. We quote the realistic ranges on purpose, not the ceiling numbers.

**Our commitment to you.** We invest in you and give you a pathway to a sustainable career: stable income with a path to Professional, benefits, paid time off, CEU funding, and a schedule that leaves room for a life. BaseCamp is paid, has no tuition, and has no repayment agreement if it doesn't work out. Some people finish BaseCamp and decide they'd rather train than coach, and that's a respectable outcome. This quarter is built to either commit you or be honest enough that you choose differently.

**On the floor today:** Ask one coach which stage they'd say they're in, and what moved them to it.

**Check yourself:** What will be true about you at the Instructor gate that isn't true today?$md$),
  (1, 5, 'lesson', $md$Friday: The professionalism standard$md$, $md$On the floor today: Run every daily non-negotiable for the full shift, then tell your mentor which one slipped.$md$, $md$Professionalism at District H is a set of habits you can see, not an attitude.

**Presentation.** Staff apparel, clean and ready, every shift. Arrive 15 minutes before your first session with the plan already read.

**Processes.** Professionals control outcomes by running the same steps every time. Greet every member who walks in, by name when you know it. Reset equipment to standard after every session. Write your floor journal before you leave: one thing you observed, one thing you learned, one question.

**Time blocking.** Your library, drill, and floor time are scheduled inside your shift. Protect them the way you'd protect a client's session.

**Propriety.** Act like someone a member trusts with their body and their goals. That means appropriate language, appropriate touch (always with permission), and keeping your phone away on the floor.

**Respectful disengaging.** Sometimes a member wants your attention when the room needs it. Being present doesn't mean being available to everyone at once. Acknowledge them, tell them when you'll come back, and then actually come back. You can handle an interruption without being rude or disappearing.

**Slack, starting today.** Slack is the nervous system of the team. Film, homework, huddle notes, and questions all go through it. Post film in your BaseCamp channel with your self-review written first, before anyone comments.

**On the floor today:** Run every daily non-negotiable for the full shift, then tell your mentor which one slipped.

**Check yourself:** Which habit on this page will take the most effort for you to make automatic?$md$),
  (1, 6, 'lesson', $md$On the floor this week$md$, $md$Observe every format, both time slots. No coaching yet. Start your name deck (photo, name, and one detail for every member in your slots).$md$, $md$$md$),
  (1, 7, 'lesson', $md$The client chair$md$, $md$Sit in on one discovery call. Go through your own consultation and Elevate MAP with a senior coach, and set up your six-pillar baseline in the HSN app.$md$, $md$$md$),
  (1, 8, 'film', $md$Filmed rep (unscored)$md$, $md$Film your greeting and session open on your phone. Self-review only. The point is getting comfortable on camera before it counts.$md$, $md$$md$),
  (1, 9, 'homework', $md$Homework$md$, $md$Your Prompt 0 answer from the Field Guide Worksheet, plus a one-page values response: your easiest value, your hardest value, and what you'll do about the hard one. Your mentor keeps it and gives it back at the gate.$md$, $md$$md$),
  (1, 10, 'huddle', $md$Huddle$md$, $md$Introductions, and what the intake felt like from the client's side.$md$, $md$$md$),
  (1, 11, 'lesson', $md$Reading$md$, $md$Start The Coaching Habit.$md$, $md$$md$);

update public.weeks set title = $md$The client journey$md$, summary = $md$Week 2 teaches the path every member walks, and your safe place on it as a Presenter. By Friday you'll know 20 members by name and one fact each, and you'll be running check-ins in PushPress.$md$, system_focus = $md$PushPress member basics (look up members, read attendance, run check-ins).$md$, updated_at = now() where n = 2;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (2, 1, 'lesson', $md$Monday: Reclaim, Ascend, Self-Mastery$md$, $md$On the floor today: Pick three members and guess which part of the journey each is in. Check your guesses with your mentor.$md$, $md$Every District H member is somewhere on a three-part journey, and knowing where they are tells you what they need from you today.

**Reclaim** is getting back. Someone is coming off a long layoff, an injury, a pregnancy, or years of a desk job. The goal is a body that moves well without pain and a routine that actually sticks. Wins here are small and they matter more than they look: three sessions in a week, a hinge that no longer bothers their back.

**Ascend** is building. The routine is stable and the member wants to get stronger, fitter, and more capable. This is where most of the progress people picture when they think about fitness happens, and where a coach's eye for progression matters most.

**Self-Mastery** is owning it. The member understands their training, works in seasons (a race, a hiking trip, a strength block), and leans on the coach for direction and accountability more than instruction.

Members don't move in a straight line. A busy season at work or a new baby can send an Ascend member back to Reclaim for a while, and that's normal. We work in seasons, not permanence. Nobody is supposed to train at maximum effort forever.

As a Presenter, you won't decide where someone sits. But you'll talk to them differently once you know. A Reclaim member needs to feel safe and seen. An Ascend member wants to know the work is going somewhere.

**On the floor today:** Pick three members and guess which part of the journey each is in. Check your guesses with your mentor.

**Check yourself:** What does a Reclaim member most need from the first five minutes of a session?$md$),
  (2, 2, 'lesson', $md$Tuesday: Coaching the whole person$md$, $md$On the floor today: When a member seems off, ask one open question ("How's the week going?") and just listen. Don't fix anything.$md$, $md$We coach with a biopsychosocial model. It sounds academic, but the idea is simple: what happens in a session is shaped by the body, the mind, and the life around them, all at once.

- **Bio** is the body: movement, pain, recovery, sleep, how they slept last night.
- **Psycho** is the mind: confidence, fear, motivation, how they feel about being watched.
- **Social** is their life: work, family, money, who's supporting them and who isn't.

A member who shows up flat might be under-recovered. They might also be dreading a meeting, or in the middle of a hard week at home. If you only see the body, you'll coach the wrong thing. The squat might not be the problem today.

This is why our first question is usually about the person, not the program. It's also why we never assume. You don't diagnose, and you don't counsel. You notice, you ask, and when something is outside your lane you pass it to the coach on the floor.

**On the floor today:** When a member seems off, ask one open question ("How's the week going?") and just listen. Don't fix anything.

**Check yourself:** Think of one member today. What was going on in each of the three areas, as far as you could tell?$md$),
  (2, 3, 'lesson', $md$Wednesday: Fundamentals first$md$, $md$On the floor today: Log today in the HSN app before your shift ends. Notice which pillar is hardest for you to log honestly.$md$, $md$People love to optimize. They want the perfect program, the right supplement, the clever new method. At District H we start with the basics, because the basics are where almost all of the results live.

We track six pillars of health in the HSN app: sleep, nutrition, movement, stress, hydration, and recovery. Someone sleeping five hours a night won't be rescued by a smarter set-and-rep scheme. The pillars come before the programming.

The second rule is that progressive change beats overhauls. A member who tries to change everything on January 2nd is usually back where they started by February. A member who adds one habit, keeps it, then adds another, is still with us in a year. Our job is to help people take the next small step, then the one after it.

This is also why you track your own six pillars, starting this month. You can't coach habits you don't live. Members can tell the difference.

**On the floor today:** Log today in the HSN app before your shift ends. Notice which pillar is hardest for you to log honestly.

**Check yourself:** Which pillar is weakest for you right now, and what's one small step you'll take this week?$md$),
  (2, 4, 'lesson', $md$Thursday: Safety and scope$md$, $md$On the floor today: Walk the space and find every first aid kit and the AED. Then practice the hand-off line out loud with your mentor five times.$md$, $md$A Presenter's most important skill is knowing exactly what is and isn't your job.

**Your boundary:** you assist and support, and you never freelance. You deliver what's in the plan. You don't invent new movements, change loading on your own, or give advice about pain or injury. If something isn't in the plan, it goes to the coach running the floor.

**The hand-off.** When a member tells you something hurts, or asks a question outside your lane, you stay calm and hand it up cleanly. For example: "Thanks for telling me. Let's get Sam over here, they'll know the best option." Then stay with the member until the coach arrives. You never brush it off, and you never guess.

**When something goes wrong.** Know where the first aid kit and AED are at both locations. Know the emergency procedure, and who calls 911. CPR/AED/First Aid is complete this week. Nobody assists on the floor past week 2 without it.

**The common hazards** in our space are worth knowing by heart: loaded barbells and plates on the floor, boxes and bands in walkways, and someone pushing past what's safe late in a conditioning piece. Most of preventing injury is just a clean floor and a watchful eye.

**On the floor today:** Walk the space and find every first aid kit and the AED. Then practice the hand-off line out loud with your mentor five times.

**Check yourself:** What are the three most likely ways someone gets hurt in our space, and what does a Presenter do about each?$md$),
  (2, 5, 'lesson', $md$Friday: Knowing your members$md$, $md$On the floor today: Run check-ins for one session in PushPress, greeting each member by name as they arrive.$md$, $md$Names aren't a nice touch. They're the job. A member who's greeted by name feels like they belong, and belonging is why people stay.

**PushPress.** This week you learn the basics of member management: looking up a member, reading their attendance, and running check-ins. Attendance tells you a story before you say a word. Someone who used to come four times a week and has come once in the last two weeks is telling you something.

**Your name deck.** By Friday you know 20 members by name, plus one fact about each that isn't about training. Your mentor will spot-test you every Friday from now on.

**The first question.** *The Coaching Habit* opens with a question that works almost anywhere: "What's on your mind?" It's open, it's about them, and it lets the member decide what matters. It works much better than "How are you?", which gets you "Good" every time. Use it this week before a session and between sets.

Connection comes before advice, and questions are how you build it. The fastest way to lose a client is to be right too early.

**On the floor today:** Run check-ins for one session in PushPress, greeting each member by name as they arrive.

**Check yourself:** Which member surprised you this week with what they said when you asked a real question?$md$),
  (2, 6, 'lesson', $md$On the floor this week$md$, $md$Greet and check in members. Own the equipment reset for every session you're on.$md$, $md$$md$),
  (2, 7, 'lesson', $md$Drill$md$, $md$"What's on your mind?" Use it at least once per session.$md$, $md$$md$),
  (2, 8, 'film', $md$Filmed rep (unscored)$md$, $md$The hand-off drill. Your mentor plays a member reporting knee pain mid-set, and you film the hand-off.$md$, $md$$md$),
  (2, 9, 'homework', $md$Homework$md$, $md$A connection log of 5 conversations. For each one: what you asked, what they said, and what it did to the relationship.$md$, $md$$md$),
  (2, 10, 'huddle', $md$Huddle$md$, $md$Present your one-page values response from Week 1.$md$, $md$$md$),
  (2, 11, 'lesson', $md$Certification$md$, $md$CPR/AED/First Aid complete.$md$, $md$$md$);

update public.weeks set title = $md$Anatomy of a session$md$, summary = $md$Week 3 is where you start delivering, with your mentor beside you. You'll learn what each block of a District H session is for, lead warm-ups, and write a session note for every segment you coach. That last habit is for good.$md$, system_focus = $md$PushPress class ops (rosters, reservations, attendance) and session notes for every coached segment.$md$, updated_at = now() where n = 3;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (3, 1, 'lesson', $md$Monday: The shape of a session$md$, $md$On the floor today: Before each session, read the plan and say each block's job out loud to your mentor.$md$, $md$Every District H session is built from blocks, and each block has one job. When you know the job, you know what good looks like.

1. **Arrival and open.** Members are greeted by name, checked in, and told what today is about. Done well, people feel welcome and know what's coming.
2. **Warm-up.** Raise body temperature, prime the day's patterns, and set the energy. Done well, the room is moving well and paying attention.
3. **Strength or skill block.** The main work. Quality over speed, loading guided by the plan. Done well, the reps are clean and progress is recorded.
4. **Conditioning.** Work capacity, pacing, and effort. Done well, everyone is scaled correctly and still moving well at the end.
5. **Close.** Cool down, a quick recap, and what's next. Done well, members leave feeling better than when they walked in, and know when they're coming back.

The written session plan tells you what goes in each block. Read it before your shift, every shift. You should be able to explain each block's purpose to your mentor in one sentence.

As a Presenter, you'll lead parts of the open and the warm-up first. The main blocks come later in the phase, once your mentor is confident you can run them safely from the plan.

**On the floor today:** Before each session, read the plan and say each block's job out loud to your mentor.

**Check yourself:** Which block did the coach spend the most words on today, and why do you think that was?$md$),
  (3, 2, 'lesson', $md$Tuesday: The warm-up's real job$md$, $md$On the floor today: Deliver one warm-up with your mentor beside you. Use every member's name once.$md$, $md$A lot of coaches treat the warm-up as filler before the real work. At District H it's the first impression of the session, and it sets up everything after it.

A good warm-up does three things. It gets people warm, so they're ready to move. It primes the patterns for the day: if today's main lift is a squat, the warm-up has squatting in it. And it sets the energy of the room. A flat warm-up usually means a flat session.

The warm-up is also your best chance to connect with every member. Use each person's name at least once, and notice how they're moving compared to their normal. Someone who's guarding a shoulder in the warm-up is going to need watching during the press.

Keep the logistics clean. Know where everyone is going before you send them there. Give the full instruction before people start moving, not while they're already scattered across the room. Then watch and adjust.

**On the floor today:** Deliver one warm-up with your mentor beside you. Use every member's name once.

**Check yourself:** Did your warm-up prime the day's main pattern? How could you tell?$md$),
  (3, 3, 'lesson', $md$Wednesday: How we organize movement$md$, $md$On the floor today: Watch one pattern all day across every body in the room. Write down what varied from person to person.$md$, $md$We organize movement around seven patterns: squat, hinge, push, pull, carry, brace, and locomotion. Almost everything a member does in a session is one of these or a combination of them.

The patterns sit inside our Capability Hierarchy, which is how we decide what a member is ready for. Think of it as a map, not a ladder. Complexity is earned, and a member doesn't get a more advanced version just because they've been here a while.

Inside every movement, the order of operations is the same: mechanics, then consistency, then intensity. A movement has to look right before it gets repeated a lot. It has to be repeated well before it gets heavier or faster. For a Presenter, that means one simple rule: you never add intensity to a movement that isn't consistent yet. If you see someone's form break down as the weight goes up, you flag it to the coach. You don't fix it yourself yet.

Right now your job is to see, not to correct. You'll practice naming faults on film this week. Seeing comes before correcting, and good coaches see a lot more than they say.

**On the floor today:** Watch one pattern all day across every body in the room. Write down what varied from person to person.

**Check yourself:** Why does consistency come before intensity?$md$),
  (3, 4, 'lesson', $md$Thursday: Time, transitions, and the floor$md$, $md$On the floor today: Set up and break down for one full session, timed. Compare your time to the house standard.$md$, $md$The best session in the plan doesn't matter if it runs ten minutes over or the room spends half of it waiting.

**Time.** Know the clock for every block before you start. If one block runs long, the next one gets shorter. Never cut the close, because the close is what people remember.

**Transitions.** Most wasted time happens between blocks. Set up the next block's equipment before you need it. Give clear instructions: where to go, what to grab, and how to set it up. Then start a countdown. "Two minutes to set up, then we start" moves a room much better than "OK, whenever you're ready."

**The floor itself.** Open and close follow a checklist, every time. Equipment goes back where it lives. A clean, reset floor is a safety habit, and it's the first thing a member sees when they walk in.

**When the plan breaks.** Equipment will be short, or a member will arrive late. Keep the room moving first, then solve the problem. If you're not sure what to do, ask the coach. Don't stall the room while you think.

**On the floor today:** Set up and break down for one full session, timed. Compare your time to the house standard.

**Check yourself:** Where did the room lose the most time today?$md$),
  (3, 5, 'lesson', $md$Friday: Every segment gets a note$md$, $md$On the floor today: Write a session note for every segment you touched today. Show your mentor before you leave.$md$, $md$Starting this week, every segment you coach gets a session note in PushPress. That habit is for good. A note that isn't written is information the next coach doesn't have.

**What goes in a note.** Who was there, anything that changed from the plan, and anything the next coach should know. That includes a member who mentioned their knee, someone who was clearly ready to go heavier, or someone who seemed off. Keep it short and factual. Write "Left knee bothered her on box step-ups, swapped to split squats," not "Bad knee day."

**PushPress class ops.** This week you learn rosters, reservations, and attendance for a class. Before a session, look at who's booked. After it, confirm who actually came.

**The second question.** *The Coaching Habit* has a follow-up question that changes conversations: "And what else?" The first thing someone tells you is rarely the whole story. When a member says the session was fine, "And what else?" is often where the real answer comes out.

**On the floor today:** Write a session note for every segment you touched today. Show your mentor before you leave.

**Check yourself:** What did "And what else?" get you this week that the first answer didn't?$md$),
  (3, 6, 'lesson', $md$On the floor this week$md$, $md$Deliver warm-ups with your mentor beside you. Shadow one discovery call.$md$, $md$$md$),
  (3, 7, 'lesson', $md$Drill$md$, $md$"Name the fault." Watch 20 short film clips and name what you see. This is scored for accuracy. Also practice "And what else?"$md$, $md$$md$),
  (3, 8, 'film', $md$Filmed rep$md$, $md$Film one warm-up you deliver. Write a self-review against the Presenter rubric, then post it.$md$, $md$$md$),
  (3, 9, 'homework', $md$Homework$md$, $md$Log everything you touched this week: sessions, notes, check-ins, and resets.$md$, $md$$md$),
  (3, 10, 'huddle', $md$Huddle$md$, $md$Name-the-fault results, and the most interesting answer "And what else?" got you.$md$, $md$$md$);

update public.weeks set title = $md$Presence and energy$md$, summary = $md$Week 4 is about being heard and being watchable. You'll lead a warm-up plus one coached block every day, and you'll work on how you sound, where you stand, and how you demonstrate. Presence is a skill you practice, not a personality you either have or don't.$md$, system_focus = $md$What a useful session note looks like, checked by your mentor.$md$, updated_at = now() where n = 4;
insert into public.tasks (week_n, sort, kind, title, details, body) values
  (4, 1, 'lesson', $md$Monday: Your voice$md$, $md$On the floor today: Deliver your warm-up instructions at a slower pace than feels natural. Ask your mentor if it sounded slow.$md$, $md$Members will forget most of what you say. They remember how you said it.

**Projection, not volume.** Your voice should reach the back of the room without shouting. Breathe from your belly and aim your voice at the farthest person. Shouting sounds stressed. Projection sounds calm and in charge.

**Pace.** Most new coaches talk too fast when they're nervous. Slow down by about a third, especially for instructions. If people are asking you to repeat yourself, you're going too fast.

**The held silence.** After you give an instruction, stop talking. A two-second pause tells the room you're done and it's their turn. Filling every gap with "OK, so, um" makes your words worth less.

**Fewer words.** Say it once, clearly, and stop. "Grab one kettlebell and meet me at the wall" beats a long explanation every time.

Your voice also carries energy. Start one gear above the room. Then bring the room up to you.

**On the floor today:** Deliver your warm-up instructions at a slower pace than feels natural. Ask your mentor if it sounded slow.

**Check yourself:** What filler word do you use most? Count it in your next film.$md$),
  (4, 2, 'lesson', $md$Tuesday: Where you stand and how you look$md$, $md$On the floor today: Before you start each block, check your position: can every member see you, and can you see every member?$md$, $md$Where you stand tells the room who's running it.

**Positioning.** Stand where everyone can see you and you can see everyone. That usually means at the front edge of the group with the room in front of you, never in the middle with half of them behind you. During work, move around the room. Don't plant yourself in one corner.

**Body language.** Keep it open: arms uncrossed, shoulders back, facing the room. Crossed arms read as closed off, and hands in pockets read as checked out.

**Eye contact.** Aim for about 60-70% of the time when you're talking to someone. Less feels evasive, and more starts to feel intense. When you talk to the group, sweep the room so everyone feels included.

**Taking up space.** When you demonstrate, own the space. Make the movement big, clear, and visible from the back row. A small, rushed demo tells people the movement isn't important.

None of this is about looking tough. It's about making it easy for members to follow you and trust you. Calm, open, and clear is the goal.

**On the floor today:** Before you start each block, check your position: can every member see you, and can you see every member?

**Check yourself:** Watch your last film with the sound off. What does your body language say?$md$),
  (4, 3, 'lesson', $md$Wednesday: Commanding attention$md$, $md$On the floor today: Use a countdown for every transition today, and start exactly at zero each time.$md$, $md$You can't coach a room that isn't listening. Getting attention, and keeping it, is a technical skill.

**Command versus question.** An instruction delivered as a question invites a debate. "Can everybody come over here?" sounds optional. "Everybody, come over to the rig" sounds like the plan. Use statements for instructions and save questions for checking in with people.

**Countdowns.** Countdowns move a room better than requests do. "Ten seconds, then we start" gives people a deadline and a reason to finish their conversation. Then actually start at zero, every time. If you don't, the countdown stops working.

**Getting the room back.** When the noise is high, don't talk over it. Stand in your spot, wait, and use a short, clear signal. That might be a clap or "Eyes on me," whatever your floor uses. Speak once the room is quiet.

**Reducing distraction.** Face the members toward you and away from the mirror, the TV, and the door. Give instructions before you hand out equipment, not after. People stop listening once there's a kettlebell in their hand.

**On the floor today:** Use a countdown for every transition today, and start exactly at zero each time.

**Check yourself:** Did any instruction you gave today come out as a question? How did the room respond?$md$),
  (4, 4, 'lesson', $md$Thursday: Demonstration as a skill$md$, $md$On the floor today: Demo the day's main movement once in complete silence, then name one thing to watch for.$md$, $md$Most members learn more from your demo than from your words. A good demo is planned, not improvised.

**Angles.** Show the movement from the angle where the important part is easiest to see. A hinge is best shown from the side, so people can see the hips go back. A squat stance is best shown from the front. If it matters, show it from two angles.

**Tempo.** Demo slower than the movement is performed. Members need time to see each position.

**Silence while you demonstrate.** Show first, then talk. When you talk and move at the same time, people try to do both and catch neither. A clean pattern is: "Watch this," then demo in silence, then name the one thing to look for.

**Scaled versions without stigma.** When you show a scaled option, show it with the same care as the main version. Never call it the "easy" version. Present options as choices for today, like "Here's the box squat, here's the back squat, pick the one that fits today." Anyone in the room might take the scaled option, and they should feel good about it.

Your own movement matters too. You'll be asked to demo every foundational movement to standard. If something doesn't feel right in your body, tell your mentor now, and you'll agree on a documented modification.

**On the floor today:** Demo the day's main movement once in complete silence, then name one thing to watch for.

**Check yourself:** Which foundational movement is hardest for you to demo well, and what's your plan?$md$),
  (4, 5, 'lesson', $md$Friday: Notes worth reading, and a look back$md$, $md$On the floor today: Rewrite one of your Week 3 notes so it would actually help the next coach.$md$, $md$You've written session notes for two weeks. Today is about writing ones the next coach can actually use.

**A useful note is specific.** Compare "Good session" with "Jordan's hips shifted left on heavy deadlifts, cued 'push the floor away,' cleaned up by set 3." The second one is a note the next coach can act on.

**A useful note is factual.** Write what you saw and did, not your opinion of the person. "Seemed annoyed when told to scale" is a fact. "Bad attitude" isn't.

**A useful note is timely.** Write it before you leave, while you still remember. A note from memory two days later is mostly guessing.

**Month 1 in review.** You've learned why we exist, how the gym works, the client journey, the shape of a session, and how to carry yourself in front of a room. Before your 1-on-1, look back at your Week 1 film. Compare it to this week's. The difference is the point of this whole program. Small improvements, made consistently, add up to a coach.

**On the floor today:** Rewrite one of your Week 3 notes so it would actually help the next coach.

**Check yourself:** What's the biggest difference between your Week 1 film and this week's?$md$),
  (4, 6, 'lesson', $md$On the floor this week$md$, $md$A warm-up plus one coached block every day.$md$, $md$$md$),
  (4, 7, 'film', $md$Filmed rep$md$, $md$Film your warm-up and block. Your mentor reviews it with you on Friday, after you've written your self-review.$md$, $md$$md$),
  (4, 8, 'homework', $md$Homework$md$, $md$Pick one presence habit to build and one to break, with a specific plan for each.$md$, $md$$md$),
  (4, 9, 'huddle', $md$Huddle$md$, $md$Coaching Habit translation huddle #1. Bring one question from the book you used this month in gym language, and what it did to the relationship.$md$, $md$$md$),
  (4, 10, 'lesson', $md$Reading$md$, $md$Keep going with The Coaching Habit (finish by week 8).$md$, $md$$md$),
  (4, 11, 'huddle', $md$Week 4 checkpoint with the GM$md$, $md$A 30-minute check-in at the end of the week. Not a gate. Read what to bring.$md$, $md$At the end of Week 4 you sit down with the General Manager for about 30 minutes. It's a check-in, not a gate. Nobody passes or fails it. The point is to catch anything that's drifting while it's still small, and to make sure you know exactly where you stand before the work gets harder in Month 2.

Bring these with you:

- **Your Week 1 film and your Week 4 film**, side by side. You'll talk through the difference.
- **Your Presenter rubric self-score**, next to your mentor's score from the same film. Where the two scores disagree is usually where the best conversation is.
- **Your name deck.** The GM will pick five members from your slots at random. Name and one fact each.
- **Two session notes** you're proud of and one you'd rewrite.
- **Your values response from Week 1.** You'll look at the hard value again and talk about what's changed.

You'll leave with one of three outcomes. **On track** means keep going as planned. **On track with a focus** means one specific skill gets extra reps in Weeks 5 and 6, written down so your mentor can see it. **Needs a plan** means something basic isn't there yet (attendance, preparation, CPR not complete), and you'll agree on a short written plan with a date to check it again. The formal checkpoint is still Week 8. This one exists so Week 8 holds no surprises.$md$);
