DROP TABLE IF EXISTS public.films;
CREATE TABLE films (title varchar(255), year integer, genre varchar(100));

INSERT INTO films(title, year, genre) VALUES ('Die Hard', 1988, 'action');
INSERT INTO films(title, year, genre) VALUES ('Casablanca', 1942, 'drama');
INSERT INTO films(title, year, genre) VALUES ('The Conversation', 1974, 'thriller');


SELECT * FROM films WHERE length(title) < 12;


-- add a director and a duration field to the films table

ALTER TABLE films
 ADD COLUMN director text;

ALTER TABLE films
 ADD COLUMN duraction integer;

-- fill in values for the three films we have into the films table.

UPDATE films
   SET director = 'John McTiernan'
 WHERE title = 'Die Hard';

 UPDATE films
    SET director = 'Michael Curtiz'
  WHERE title = 'Casablanca';

  UPDATE films
     SET director = 'Francis Ford Coppola'
   WHERE title = 'The Conversation';

-- fix typo

  ALTER TABLE films
RENAME COLUMN duraction
           TO duration;

-- fill in some new films

INSERT INTO films (title, year, genre, director, duration)
     VALUES ('1984', 1956, 'scifi', 'Michael Anderson', 90),
            ('Tinker Tailor Soldier Spy', 2011, 'espionage', 'Tomas Alfredson', 127),
            ('The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);


-- set duration for initial three films

UPDATE films
   SET duration = 132
 WHERE title = 'Die Hard';

UPDATE films
   SET duration = 102
 WHERE title = 'Casablanca';

UPDATE films
   SET duration = 113
 WHERE title = 'The Conversation';


-- list title and age in years of each move, sort by newest first

  SELECT title, extract(year from current_date) - year AS age
    FROM films
ORDER BY age;

-- list title and duration of films longer than two hours, longest first


SELECT title, duration
FROM films
WHERE duration > 120
ORDER BY duration DESC;


-- show the title of the longest film

SELECT title
FROM films
ORDER BY duration DESC
LIMIT 1;
