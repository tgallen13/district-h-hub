-- Use the District H archetype names for the quick read (Oct 20, 2026):
-- Driver, Energizer, Rock, Analyst. Updates the Trainer Month 1 lesson that
-- already uses the older names (BaseCamp months 4-6 ship with the new ones).

update public.path_tasks
set body = replace(replace(replace(replace(replace(replace(replace(replace(body,
  'an Amiable', 'a Rock'),
  'an Analytic', 'an Analyst'),
  'Amiables', 'Rocks'),
  'Amiable', 'Rock'),
  'Analytics', 'Analysts'),
  'Analytic', 'Analyst'),
  'Expressives', 'Energizers'),
  'Expressive', 'Energizer')
where body ~ '(Amiable|Analytic|Expressive)';
