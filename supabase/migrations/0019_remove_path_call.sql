-- The Professional Path Call happens before anyone gets a login, so the portal
-- no longer asks people to book it or prepare for it.
update public.orientation_modules
set summary = 'The book every District H coach reads',
    body = replace(replace(body,
      'Before your Professional Path Call, read *The Craft*,',
      'Read *The Craft*,'),
      'Come to your Path Call ready to talk about the prompts that hit hardest, and anything in the book you disagree with.',
      'Bring the prompts that hit hardest, and anything in the book you disagree with, to a conversation with your General Manager in your first weeks.')
where title = 'Read The Craft';

update public.tasks
set body = replace(body, 'You first talked about these on your Professional Path Call.', 'You first talked about these before you started.')
where body like '%Professional Path Call%';

update public.path_tasks
set body = replace(body, 'You first talked about these on your Professional Path Call.', 'You first talked about these before you started.')
where body like '%Professional Path Call%';
