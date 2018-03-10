-- Write a SQL query to list the ten states with the most rows in the people table in descending order.

SELECT state, count(id)
FROM people
GROUP BY state
ORDER BY count(id) DESC
LIMIT 10;

-- Write a SQL query that lists each domain used in an email address in the people table and how many people in the database have an email address containing that domain. Domains should be listed with the most popular first.

-- My solution (using regex):

SELECT count(id), substring(email FROM '@(.+)') as domain
FROM people
GROUP BY domain
ORDER BY count DESC;

-- LS solution (using strpos):

SELECT substr(email, strpos(email, '@') + 1) AS domain, COUNT(id)
FROM people
GROUP BY domain
ORDER BY count DESC;

-- Delete the record with the id 3399

DELETE FROM people
WHERE id = 3399;

-- Write a SQL statement that will delete all users that are located in the state of California (CA).

DELETE FROM people
WHERE state = 'CA';

-- Write a SQL statement that will update the given_name values to be all uppercase for all users with an email address that contains teleworm.us.

UPDATE people
SET given_name = upper(given_name)
WHERE email LIKE '%@teleworm.us';

-- Write a SQL statement that will update the given_name values to be all uppercase for all users with an email address that contains teleworm.us.

DELETE from people;
