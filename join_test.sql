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
    director_id integer,
    duration integer NOT NULL,
    CONSTRAINT title_length CHECK ((length((title)::text) >= 1)),
    CONSTRAINT year_range CHECK (((year >= 1900) AND (year <= 2100)))
);


--
-- Data for Name: films; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO films VALUES ('Die Hard', 1988, 'action', 1, 132);
INSERT INTO films VALUES ('Casablanca', 1942, 'drama', 2, 102);
INSERT INTO films VALUES ('The Conversation', 1974, 'thriller', 3, 113);
INSERT INTO films VALUES ('The Godfather', 1970, 'thriller', 3, 220);
INSERT INTO films VALUES ('1984', 1956, 'scifi', 4, 90);
;


CREATE TABLE directors (
  id serial,
  name text,
  review text
);

INSERT INTO directors (name, review)
  VALUES ('John McTiernan', 'great guy'),
         ('Michael Curtiz', 'mediocre'),
         ('Francis Ford Coppola', 'so talented'),
         ('Michael Anderson', 'don''t know him');

--
-- PostgreSQL database dump complete
--

-- add a primary key to the directors table

ALTER TABLE directors
ADD PRIMARY KEY (id);

-- the director_id column of films is a foreign key referencing directors

ALTER TABLE films
ADD FOREIGN KEY (director_id) REFERENCES directors (id) ON DELETE CASCADE;

-- adding a film with a director_id that does not match any director will lead
-- to an error, because it violates "referential integrity", i.e., we would have a record in the films table with no matching record in the directors table.

INSERT INTO films
VALUES ('Some movie', 1940, 'drama', 10, 100);

-- ERROR:  insert or update on table "films" violates foreign key constraint "films_director_id_fkey"
-- DETAIL:  Key (director_id)=(10) is not present in table "directors".

-- However, we can add another Coppola movie:

INSERT INTO films
VALUES ('Gangs of New York', 2010, 'drama', 3, 120);

-- When we join the two tables, we see the correct result:

SELECT *
FROM films
INNER JOIN directors
ON films.director_id = directors.id;

-- Now how about this?

SELECT *
FROM films, directors
WHERE films.director_id = directors.id;

-- same result. according to the wikipedia page on joins, this is essentially a cross join restricted by a where clause. wikipedia also says this is "implicit join" notation.
