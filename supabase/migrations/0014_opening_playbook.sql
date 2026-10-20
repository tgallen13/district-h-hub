-- Opening Playbook content: launching a new District H location, built
-- from the Oak Forest opening (Oct 20, 2026). Safe to re-run: content is
-- only loaded if the playbook doesn't exist yet.

do $pb$
begin
  if exists (select 1 from public.playbooks where slug = 'opening') then
    return;
  end if;
  insert into public.playbooks (slug, title, summary, sort) values ('opening', $md$Opening a New Location$md$, $md$Everything it takes to open a District H location well, from choosing the site to the first 90 days, built from what we learned opening Oak Forest.$md$, 1);

  insert into public.playbook_sections (id, playbook, sort, title, timing, body) values (gen_random_uuid(), 'opening', 1, $md$What Oak Forest taught us$md$, $md$Read this first$md$, $md$This playbook is built from the Oak Forest opening, which went well in the ways that mattered and taught us some expensive lessons along the way. Read this before you start, because most of the playbook exists to avoid repeating them.

**The date will move.** Oak Forest was planned to open October 1, 2025. It opened January 3, 2026. Almost all of that slip came from the building, not the business: a parking analysis the city required, an elevator rule for the upper floor, whether the electrical service could carry the AC, and the final fire marshal sign-off. Plan for permits and inspections to take longer than anyone tells you, and build the pre-sale so a moving date doesn't break it.

**A moving date hurts the pre-sale.** Every slip gave "wait and see" prospects a reason to keep waiting, and founders who had committed started asking questions. Have a plan for communicating delays before you need it.

**In-person sells.** Consultations on site closed far better than anything done remotely, and owners closed better than managers. Prospects responded well to hearing price ranges up front.

**A dollar isn't a commitment.** A $1 deposit lowered the barrier to saying yes, but it didn't tell us who would actually start or give us any cash visibility. Next time, move founders to a real commitment, such as a post-dated membership, well before opening.

**The launch burst works; steady state is different.** Paid social during the pre-sale produced most of the founding members. After opening, the same ads converted far worse, and most of the growth came from referrals, the website, and in-person.

**Systems need to be ready early.** Leads landed in the wrong pipeline, automations misfired, and website leads were flagged as spam after a cutover. Test every path a lead can take, end to end, before the first dollar of ad spend.

**Community doesn't move with the equipment.** Oak Forest opened with great coaching and a less established community feel than Heights. Building that is a job, with an owner and a plan, from day one.$md$);
  insert into public.playbook_sections (id, playbook, sort, title, timing, body) values (gen_random_uuid(), 'opening', 2, $md$Decide and underwrite$md$, $md$12 or more months out$md$, $md$Before anything is signed, the location has to make sense on paper and fit the way District H works.

**The footprint standard.** New locations are 4,000 square feet or less, split roughly into a semi-private room (about 1,250 sf), a small group room (about 2,200 sf), and a lobby with bathrooms (about 550 sf). Smaller is a feature: lower rent, a fuller-feeling room, and a faster path to break-even. Look closely at width. Oak Forest's 28-foot-wide building forced a wall-mounted rig, which worked, but it shaped everything.

**The numbers to underwrite.** Open with about 100 members on day one, which is close to break-even, grow to about 175 in year one, and reach full at 230 to 240. Build the pro forma around the real service mix (roughly 60 percent small group and 35 percent semi-private in new members) and realistic churn, and run it with the opening three months late.

**Where.** The territories we've looked at most are Rice Military, Spring Branch and Memorial City, Bellaire, and West University. The member we serve is a busy professional, often with a family, who wants a coach, not a crowded gym.

**The building.** Before signing, find out what the city will require: parking analysis, accessibility rules for any second floor, electrical capacity for full AC, sprinklers and fire marshal requirements. Each one of these cost Oak Forest weeks.

**The lease.** Ask for free rent after opening (Oak Forest got three months, which let it be cash-flow positive sooner), and write in protection for delays that aren't ours. A separate LLC for each location keeps the risk contained.

**The team.** The goal is to open with people we already have plus one or two hires, so the new location starts with District H's culture instead of trying to build it from scratch.$md$);
  insert into public.playbook_items (section_id, sort, text, owner) select id, 1, $md$Choose the territory and confirm it fits the member we serve$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 2;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 2, $md$Find a site at or under 4,000 sf with enough width, parking, and power$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 2;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 3, $md$Check permitting risk before signing: parking, second-floor rules, electrical for AC, fire marshal$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 2;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 4, $md$Build the pro forma: 100 members day one, 175 by year one, full at 230-240, opening three months late$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 2;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 5, $md$Line up financing and form the location LLC$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 2;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 6, $md$Negotiate the lease: free rent after opening and protection for delays$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 2;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 7, $md$Decide who leads the location and which one or two hires it needs$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 2;
  insert into public.playbook_sections (id, playbook, sort, title, timing, body) values (gen_random_uuid(), 'opening', 3, $md$Design, permits, and buildout$md$, $md$9 to 4 months out$md$, $md$Design the space around the two rooms, then give permitting and construction more time than you think they need.

**The room program.** The small group room runs one coach to up to 14 members, built around a wall run of rack and cable bays at two or three members per bay. The semi-private room runs one to three coaches with up to about eight members at stations, each with its own tablet. Flooring, sound, network, and climate matter more than finishes. Air conditioning is a real advantage in Houston: most gyms in a warehouse space don't have it.

**Equipment.** Order from the house list (rigs and racks, selectorized or smart trainers for semi-private, bikes, rowers, adjustable dumbbells, sleds, and small equipment). Ask vendors for bulk pricing. Oak Forest got a meaningful discount on its main order. Order early enough that equipment is waiting for the building, not the other way around.

**Timeline.** Plan on 8 to 12 weeks for permits and 6 to 8 weeks for construction, then add buffer for inspections. The last inspections, especially fire marshal, are where Oak Forest lost the most time.

**Signage and look.** Exterior signage, door and window decals, and wall graphics in District H branding. Order signage early because permits can apply to it too.

**Keep everyone informed.** Hold a short weekly building meeting with the contractor and write the decisions down. When a date changes, the marketing and pre-sale plan has to change with it the same week.$md$);
  insert into public.playbook_items (section_id, sort, text, owner) select id, 1, $md$Lay out both rooms and the lobby; confirm capacity for small group and semi-private$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 3;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 2, $md$Hire the contractor and agree on a schedule with inspection buffer$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 3;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 3, $md$Submit permits; track parking, accessibility, electrical, and fire requirements$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 3;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 4, $md$Order equipment from the house list with bulk pricing$md$, $md$Ops$md$ from public.playbook_sections where playbook = 'opening' and sort = 3;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 5, $md$Order exterior signage, decals, and wall graphics$md$, $md$Marketing$md$ from public.playbook_sections where playbook = 'opening' and sort = 3;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 6, $md$Hold a weekly building meeting and log every decision and date change$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 3;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 7, $md$Pass final inspections, including fire marshal$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 3;
  insert into public.playbook_sections (id, playbook, sort, title, timing, body) values (gen_random_uuid(), 'opening', 4, $md$People$md$, $md$6 to 2 months out$md$, $md$A new location opens with the District H standard only if the people running it already live it.

**The location lead.** Oak Forest opened with Morrill as the face of the business instead of an outside manager. That's the model: someone who knows how District H works leads the new floor from day one, sells in person, and owns the community.

**Coaches.** Staff the opening schedule mostly with coaches who already work at District H, plus any new hires. Every new coach goes through the normal standard: two live coaching evaluations and about three weeks of shadowing before they coach on their own. A BaseCamp cohort timed to finish near opening is a good source.

**Sales and setting.** Decide who books appointments, who runs consultations, and who closes, before the pre-sale starts. Keep pre-opening payroll lean, but don't leave the consultation schedule thin, because in-person consultations are where founders are won.

**Training.** Everyone on the new floor knows the location's opening, closing, cleaning, and emergency procedures before the first session, and every coach has walked the space and found the first aid kit and AED.$md$);
  insert into public.playbook_items (section_id, sort, text, owner) select id, 1, $md$Name the location lead$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 4;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 2, $md$Build the opening coach schedule and identify hires$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 4;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 3, $md$Hire and run new coaches through two live evaluations and shadowing$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 4;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 4, $md$Assign who sets appointments, runs consultations, and closes during the pre-sale$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 4;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 5, $md$Train every coach on the location procedures, first aid kit, and AED$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 4;
  insert into public.playbook_sections (id, playbook, sort, title, timing, body) values (gen_random_uuid(), 'opening', 5, $md$Systems$md$, $md$4 to 2 months out, before any ad spend$md$, $md$Every system has to work for the new location before the first lead arrives. Test each path a lead or member can take, end to end, with a real test contact.

**Member system.** Set up the location in our member system (PushPress today, moving to Liftr), including memberships, founding-member pricing tiers, class schedule, and staff accounts. Make sure the founding discounts are set up so billing is right on day one and so we know when they roll off.

**CRM.** In GoHighLevel, give the location its own pipeline, forms tagged by location, appointment calendars, and automations (lead follow-up, appointment reminders, no-show and long-term nurture). Connect the member system to the CRM for the new location.

**Website.** Add the location page, the location-specific confirmation page, and the tracking that fires on a lead, then submit a test lead from every form and confirm it lands in the right pipeline. Add the location to the area pages and the neighborhood guide.

**Google Business Profile.** Set it up as early as allowed, with photos, hours, and the right categories, and ask the first members for reviews. Map-pack visibility for the new location started weak at Oak Forest and is worth working on from the first month.

**The rest.** Phone number, email, a Slack channel for the location, music and TV setup, tablets for semi-private and check-in, and the location's opening, closing, cleaning, and emergency SOPs.$md$);
  insert into public.playbook_items (section_id, sort, text, owner) select id, 1, $md$Set up the location in the member system, with founding tiers and the schedule$md$, $md$Ops$md$ from public.playbook_sections where playbook = 'opening' and sort = 5;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 2, $md$Build the location pipeline, tagged forms, calendars, and automations in GoHighLevel$md$, $md$Marketing$md$ from public.playbook_sections where playbook = 'opening' and sort = 5;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 3, $md$Connect the member system to the CRM for this location$md$, $md$Ops$md$ from public.playbook_sections where playbook = 'opening' and sort = 5;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 4, $md$Publish the location page, confirmation page, and lead tracking$md$, $md$Marketing$md$ from public.playbook_sections where playbook = 'opening' and sort = 5;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 5, $md$Submit a test lead from every form and confirm it lands in the right pipeline$md$, $md$Marketing$md$ from public.playbook_sections where playbook = 'opening' and sort = 5;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 6, $md$Set up the Google Business Profile with photos, hours, and categories$md$, $md$Marketing$md$ from public.playbook_sections where playbook = 'opening' and sort = 5;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 7, $md$Set up the phone number, Slack channel, tablets, music, and TVs$md$, $md$Ops$md$ from public.playbook_sections where playbook = 'opening' and sort = 5;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 8, $md$Write the location opening, closing, cleaning, and emergency SOPs$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 5;
  insert into public.playbook_sections (id, playbook, sort, title, timing, body) values (gen_random_uuid(), 'opening', 6, $md$The pre-sale$md$, $md$4 months out to opening$md$, $md$The goal is about 100 founding members by opening day. Most of them will commit in the last few weeks, so the pre-sale has to build steadily and then close hard.

**The offer.** Oak Forest used founding tiers on the first year (the first 50 members at the deepest discount, the next 50 at a little less, the next 50 at a little less again), 13 months for a 12-month commitment, a short risk-free trial, and a small bonus for people who reached out directly. Tiers selling out created real urgency: the first tier sold out more than a month before opening. Use the same structure, but move founders to a real commitment, like a post-dated membership, well before opening day.

**The phases.** Across District H and the gyms we've helped open, the pattern holds: build awareness for four to six weeks, build interest for another three to six, and save the biggest share of the budget for the last three weeks, when most people decide. Paid social does the heavy lifting. Tag every entry point so you know what's working.

**The ground game.** Tabling at local businesses and events, partner events where we treat people (buying the first few coffees or items works), posts in neighborhood community groups, door hangers and mailers near the site, and a visible presence at the building once there's something to see. Early weekend pop-ups helped and then stopped working, so watch the numbers and drop what isn't producing.

**The conversation.** Give price ranges up front. Book in-person consultations whenever possible, because they close far better. Keep an FAQ and pricing sheet ready to send.

**The scoreboard.** Track leads, appointments set, shows, and closes every day, and hold a short weekly huddle on the numbers. Oak Forest's pre-sale ran about 219 leads to 37 closes, with tier one selling out before opening.

**When the date moves.** Tell founders quickly and personally, give them something for their patience, and keep the event calendar and content going so momentum doesn't die.$md$);
  insert into public.playbook_items (section_id, sort, text, owner) select id, 1, $md$Set the founding offer: tiers, 13-for-12, trial, and the commitment step$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 6;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 2, $md$Build the pre-sale page and FAQ and pricing sheet$md$, $md$Marketing$md$ from public.playbook_sections where playbook = 'opening' and sort = 6;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 3, $md$Launch paid social in phases, with the biggest share in the last three weeks$md$, $md$Marketing$md$ from public.playbook_sections where playbook = 'opening' and sort = 6;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 4, $md$Book tabling, partner events, and community group posts$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 6;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 5, $md$Run door hangers and mailers within one to three miles$md$, $md$Marketing$md$ from public.playbook_sections where playbook = 'opening' and sort = 6;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 6, $md$Run in-person consultations and track every one$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 6;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 7, $md$Update the daily scoreboard and hold the weekly numbers huddle$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 6;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 8, $md$Move founders from deposits to real commitments before opening$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 6;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 9, $md$Write the delay message in advance, just in case$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 6;
  insert into public.playbook_sections (id, playbook, sort, title, timing, body) values (gen_random_uuid(), 'opening', 7, $md$Opening month$md$, $md$The last two weeks through the first month$md$, $md$Open quietly, then celebrate loudly.

**Soft open.** Give founders a free first week to come in, learn the space, and meet the coaches before billing starts. It doubles as a dry run of every procedure: opening, closing, check-in, the class schedule, and semi-private stations.

**Onboard every founder.** Every founding member gets a real start: a consultation or assessment, their place in the Capability Hierarchy, and a coach who knows their name and their goal. The first 30 days decide whether a founder becomes a long-term member.

**Grand opening.** Hold the grand opening event a few weeks after the doors open, once the place is running smoothly and full of members who can bring friends. Invite neighbors, partners, and local businesses.

**Reviews and referrals.** Ask happy founders for a review and give them a simple way to bring a friend. Referrals and in-person conversations drove most of the growth after opening.

**Members from other locations.** If members are moving over from an existing location, plan it with them so it feels like an upgrade, not a transfer.$md$);
  insert into public.playbook_items (section_id, sort, text, owner) select id, 1, $md$Run the soft-open week before billing starts$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 7;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 2, $md$Dry-run opening, closing, check-in, and semi-private before the first paid day$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 7;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 3, $md$Give every founder a consultation or assessment and a placement$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 7;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 4, $md$Hold the grand opening event a few weeks after opening$md$, $md$Marketing$md$ from public.playbook_sections where playbook = 'opening' and sort = 7;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 5, $md$Ask founders for reviews and start the referral offer$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 7;
  insert into public.playbook_sections (id, playbook, sort, title, timing, body) values (gen_random_uuid(), 'opening', 8, $md$The first 90 days$md$, $md$Opening through month three$md$, $md$The first three months decide whether the location settles at a healthy size or plateaus early. Oak Forest climbed quickly and then flattened, so plan for the flattening before it arrives.

**Retention first.** New members are most likely to leave in their first few months. Run the on-ramp, check in personally at the touchpoints, and work the at-risk list three times a week.

**Build the community on purpose.** Name who owns it. Member events, shout-outs, partner events, and getting members to know each other. This is the thing that doesn't come with the equipment.

**Keep growing after the launch.** The pre-sale ads won't keep working the same way. Shift to referrals, local search, partnerships, and the website, and keep working the Google Business Profile until the location shows up in the map pack.

**Watch the ratios.** Labor will run high while membership ramps up. Track it monthly against the plan and add hours using the hiring trigger, not before.

**Plan for month twelve.** Founding discounts roll off after the first year. Decide now how and when you'll talk to founders about it.

**Write the lessons down.** At day 90, hold a short retrospective and update this playbook with what you learned.$md$);
  insert into public.playbook_items (section_id, sort, text, owner) select id, 1, $md$Run the on-ramp and personal check-ins for every new member$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 8;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 2, $md$Work the at-risk list three times a week$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 8;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 3, $md$Name the community owner and plan the first member events$md$, $md$Location lead$md$ from public.playbook_sections where playbook = 'opening' and sort = 8;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 4, $md$Shift growth to referrals, local search, partners, and the website$md$, $md$Marketing$md$ from public.playbook_sections where playbook = 'opening' and sort = 8;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 5, $md$Track labor and membership monthly against the plan$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 8;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 6, $md$Plan the founding-discount roll-off conversation for month 12$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 8;
  insert into public.playbook_items (section_id, sort, text, owner) select id, 7, $md$Hold the 90-day retrospective and update this playbook$md$, $md$Owner$md$ from public.playbook_sections where playbook = 'opening' and sort = 8;
end $pb$;
