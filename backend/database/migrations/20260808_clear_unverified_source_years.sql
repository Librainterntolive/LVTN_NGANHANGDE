-- Do not invent publication years when an official online source does not state one.
UPDATE sources
SET published_year = ''
WHERE url IN (
  'https://go.dev/doc/tutorial/getting-started',
  'https://go.dev/ref/spec'
);
