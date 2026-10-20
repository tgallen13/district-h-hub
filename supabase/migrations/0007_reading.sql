-- Reading additions approved Oct 19, 2026: The Craft as the candidate read
-- before the Professional Path Call, and Start Where You Are in Presenter
-- Week 2. The orientation setup section moves to the end.

update public.orientation_modules set sort = 8 where title = 'Getting set up';

insert into public.orientation_modules (sort, title, summary, body, interns_only)
select 7, 'Read The Craft', 'The book to finish before your Path Call', $md$Before your Professional Path Call, read *The Craft*, Tommy Allen's book for people thinking seriously about coaching as a career. Your General Manager will get you a copy.

It covers why this profession matters now, what the work is really like day to day, the honest economics of the different roads a coach can take, the five stages from Presenter to Professional, and the Agreement between a coach and the house. Every chapter ends with a Field Guide Prompt.

The book is built to do one of two things: help you commit, or be honest enough that you decide this isn't for you. Both are good outcomes. Come to your Path Call ready to talk about the prompts that hit hardest, and anything in the book you disagree with.$md$, false
where not exists (select 1 from public.orientation_modules where title = 'Read The Craft');

insert into public.tasks (week_n, sort, kind, title, details)
select 2, 12, 'lesson', 'Reading', $md$Read Start Where You Are this week. It's the book we give members, so you should know what they've read and the language it uses.$md$
where not exists (select 1 from public.tasks where week_n = 2 and title = 'Reading');
