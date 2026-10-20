-- Link The Craft's site in orientation so candidates can download or buy it.
update public.orientation_modules
set body = replace(body,
  'Your General Manager will get you a copy.',
  'You can download or purchase it at [thecraft.coach](https://thecraft.coach/).')
where title = 'Read The Craft';
