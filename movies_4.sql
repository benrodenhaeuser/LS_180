--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.films DROP CONSTRAINT title_unique;
DROP TABLE public.films;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: films; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE films (
    title character varying(255) NOT NULL,
    year integer NOT NULL,
    genre character varying(100) NOT NULL,
    director character varying(255) NOT NULL,
    duration integer NOT NULL,
    CONSTRAINT director_name CHECK (((length((director)::text) >= 1) AND ("position"((director)::text, ' '::text) > 0))),
    CONSTRAINT title_length CHECK ((length((title)::text) >= 1)),
    CONSTRAINT year_range CHECK (((year >= 1900) AND (year <= 2100)))
);


--
-- Data for Name: films; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO films VALUES ('Die Hard', 1988, 'action', 'John McTiernan', 132);
INSERT INTO films VALUES ('Casablanca', 1942, 'drama', 'Michael Curtiz', 102);
INSERT INTO films VALUES ('The Conversation', 1974, 'thriller', 'Francis Ford Coppola', 113);
INSERT INTO films VALUES ('1984', 1956, 'scifi', 'Michael Anderson', 90);
INSERT INTO films VALUES ('The Godfather', 1972, 'crime', 175, 3);
INSERT INTO films VALUES ('Tinker Tailor Soldier Spy', 2011, 'espionage', 'Tomas Alfredson', 127);
INSERT INTO films VALUES ('The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);


--
-- Name: title_unique; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY films
    ADD CONSTRAINT title_unique UNIQUE (title);


--
-- PostgreSQL database dump complete
--

-- Create a new directors table with an id column, and a name.

CREATE TABLE directors (
  id serial PRIMARY KEY,
  name text NOT NULL
);

-- Insert the directors we have in the new table:

INSERT INTO directors (name)
VALUES ('John McTiernan'),
       ('Michael Curtiz'),
       ('Francis Ford Coppola'),
       ('Michael Anderson'),
       ('Tomas Alfredson'),
       ('Mike Nichols');

-- Create an appropriate relationship between the two tables.

ALTER TABLE films
ADD COLUMN director_id int;

ALTER TABLE films
ADD FOREIGN KEY (director_id) references directors (id);

-- Or we could have done this in one go:

ALTER TABLE films
ADD COLUMN director_id integer REFERENCES directors (id);

-- insert the appropriate director ids in the films table

UPDATE films
SET director_id = '1'
WHERE director = 'John McTiernan';

UPDATE films
SET director_id = '2'
WHERE director = 'Michael Curtiz';

UPDATE films
SET director_id = '3'
WHERE director = 'Francis Ford Coppola';

UPDATE films
SET director_id = '4'
WHERE director = 'Michael Anderson';

UPDATE films
SET director_id = '5'
WHERE director = 'Tomas Alfredson';

UPDATE films
SET director_id = '6'
WHERE director = 'Mike Nichols';

-- Make the director_id NOT NULL

ALTER TABLE films
ALTER COLUMN director_id
SET NOT NULL;

-- Drop the director column from films

ALTER TABLE films
DROP COLUMN director;

-- restore the check constraint that was on the director column in the directors table:

ALTER TABLE directors
ADD CHECK (length(name) >= 1 AND "position"(name, ' ') > 0);


-- show the data the way it used to be.

SELECT title, year, genre, duration, name
FROM films INNER JOIN directors
ON films.director_id = directors.id;
