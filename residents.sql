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


-- Make department and vacation_remaining cols not null cols.

ALTER TABLE employees
ALTER COLUMN department
SET NOT NULL;

-- make 0 the default number of vacation days

ALTER TABLE employees
ALTER COLUMN vacation_remaining
SET DEFAULT 0;

ALTER TABLE employees
ALTER COLUMN department
SET DEFAULT 'unassigned';

-- make a table "temperatures" with three columns:
-- date (date), low (int), high (int)

CREATE TABLE temperatures(date date, low int, high int);

-- defaults: not null for all the columns

INSERT INTO temperatures(date, low, high)
VALUES ('2016-03-01', 34, 43),
       ('2016-03-02', 32, 44),
       ('2016-03-03', 31, 47),
       ('2016-03-04', 33, 42),
       ('2016-03-05', 39, 46),
       ('2016-03-06', 32, 43),
       ('2016-03-07', 29, 32),
       ('2016-03-08', 23, 31),
       ('2016-03-09', 17, 28);


-- Write a SQL statement to determine the average (mean) temperature for the days from March 2, 2016 through March 8, 2016.

-- all the records from march 2 to march 8:

SELECT date
FROM temperatures
WHERE date BETWEEN '2016-03-02' AND '2016-03-08';


SELECT round(avg(low), 2) AS mean_low, round(avg(high), 2) as mean_high
FROM temperatures
WHERE date BETWEEN '2016-03-02' AND '2016-03-08';


-- gemeint war aber:

SELECT date, (high + low) / 2 as mean
FROM temperatures
WHERE date BETWEEN '2016-03-02' AND '2016-03-08';

-- 6. Write a SQL statement to add a new column, rainfall, to the temperatures table. It should store millimeters of rain as integers and have a default value of 0.

ALTER TABLE temperatures
ADD COLUMN rainfall integer DEFAULT 0;

-- 7. Each day, it rains one millimeter for every degree the average temperature goes above 35. Write a SQL statement to update the data in the table temperatures to reflect this.

-- what's the expression that calculates the rainfall in millimeters?

UPDATE temperatures
SET rainfall = ((high + low) / 2) - 35
WHERE temperatur > 35;

-- 8. A decision has been made to store rainfall data in inches. Write the SQL statements required to modify the rainfall column to reflect these new requirements.
