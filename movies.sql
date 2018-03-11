DROP TABLE IF EXISTS public.films;
CREATE TABLE films (title varchar(255), year integer, genre varchar(100), director varchar(255), duration integer);

INSERT INTO films(title, year, genre, director, duration) VALUES ('Die Hard', 1988, 'action', 'John McTiernan', 132);
INSERT INTO films(title, year, genre, director, duration) VALUES ('Casablanca', 1942, 'drama', 'Michael Curtiz', 102);
INSERT INTO films(title, year, genre, director, duration) VALUES ('The Conversation', 1974, 'thriller', 'Francis Ford Coppola', 113);
INSERT INTO films(title, year, genre, director, duration) VALUES ('1984', 1956, 'scifi', 'Michael Anderson', 90);
INSERT INTO films(title, year, genre, director, duration) VALUES ('Tinker Tailor Soldier Spy', 2011, 'espionage', 'Tomas Alfredson', 127);
INSERT INTO films(title, year, genre, director, duration) VALUES ('The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);


-- modify all columns to be NOT NULL (a column constraint for each column)

ALTER TABLE films
ALTER COLUMN title
SET NOT NULL;

ALTER TABLE films
ALTER COLUMN year
SET NOT NULL;

ALTER TABLE films
ALTER COLUMN genre
SET NOT NULL;

ALTER TABLE films
ALTER COLUMN director
SET NOT NULL;

ALTER TABLE films
ALTER COLUMN duration
SET NOT NULL;

-- the above constraint is displayed in the table schema in the "Nullable" column.

-- make titles UNIQUE (a table constraint)

ALTER TABLE films
ADD UNIQUE (title);

-- this constraint is displayed as an index in the schema.

-- remove the constraint you just added

ALTER TABLE films
DROP CONSTRAINT films_title_key;

-- add a constraint to films that requires title to be at least one char long

ALTER TABLE films
ADD CONSTRAINT length_title
CHECK (length(title) <> 0);

-- we could also write:

ALTER TABLE films
ADD CHECK (length(title) <> 0);

-- then sql will come up with a title on its own.

-- demonstrate the constraint by trying to insert invalid data.

INSERT INTO films
VALUES ('', 1988, 'genre', 'director', 200);

-- error says: "violates check constraint films_title_check"

-- the above constraint is shown as a check constraint.

-- remove the constraint

ALTER TABLE films
DROP CONSTRAINT films_title_check;

-- add a constraint that ensures that all films are from year 1900-2100

ALTER TABLE films
ADD CONSTRAINT check_year
CHECK (year BETWEEN 1900 AND 2100);

-- this is displayed as a check constraint.

-- add a constraint that ensures that director is at least three chars long and has one space.

-- my solution:

ALTER TABLE films
ADD CONSTRAINT check_director
CHECK (director LIKE '%___%' AND director LIKE '% %');

-- ls solution:

ALTER TABLE films
ADD CONSTRAINT director_name
CHECK (length(director) >= 3 AND position(' ' in director) > 0);

-- List three ways to use the schema to restrict what values can be stored in a
-- column.

-- 1. Data type
-- 2. NON NULL constraint
-- 3. CHECK constraint

-- Is it possible to define a default value for a column that will be considered invalid by a constraint? Create a table that tests this.

CREATE TABLE test(
  the_row integer DEFAULT 0
);

ALTER TABLE test
ADD CONSTRAINT val_cons
CHECK (the_row <> 0);


-- yes, this just means that trying to set the default value raises an error.

ALTER TABLE films
ADD CONSTRAINT unique_titles
UNIQUE (title);
