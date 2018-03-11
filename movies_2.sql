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
INSERT INTO films VALUES ('Tinker Tailor Soldier Spy', 2011, 'espionage', 'Tomas Alfredson', 127);
INSERT INTO films VALUES ('The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);


--
-- PostgreSQL database dump complete
--


-- now, let's talk about keys.

-- let's add two movies

INSERT INTO films(title, year, genre, director, duration) VALUES ('Godzilla', 1998, 'scifi', 'Roland Emmerich', 139);
INSERT INTO films(title, year, genre, director, duration) VALUES ('Godzilla', 2014, 'scifi', 'Gareth Edwards', 123);

-- suppose we found out that Godzilla has a different length than we originally thought.

UPDATE TABLE films
SET duration = 145
WHERE title = 'Godzilla';

-- ... but wait. There are two Godzilla movies. I meant the Emmerich one.

UPDATE TABLE films
SET duration = 145
WHERE title = 'Godzilla' AND director = 'Roland Emmerich';

-- this solves the issue, but in a non-great way. what we really need is a way of uniquely identifying a record (row). It should be guaranteed that we can do this.

CREATE TABLE colors (id serial UNIQUE, name text);

INSERT INTO colors(id, name)
VALUES (NULL, 'the name');

--> ERROR:  null value in column "id" violates not-null constraint

-- IMPORTANT TO KNOW:

-- This statement:
CREATE TABLE colors (id serial, name text);

-- is actually interpreted as if it were this one:
CREATE SEQUENCE colors_id_seq;
CREATE TABLE colors (
    id integer NOT NULL DEFAULT nextval('colors_id_seq'),
    name text
);

-- so serial is not actually a basic data type.

CREATE TABLE more_colors (id serial PRIMARY KEY, name text);

-- this is more or less the same as:

CREATE TABLE more_colors (id serial NOT NULL UNIQUE, name text);

-- create a sequence:

CREATE SEQUENCE counter;

-- get the next value

SELECT nextval('counter');

-- drop the sequence

DROP SEQUENCE counter;

-- sequence that gives even numbers;

CREATE SEQUENCE counter
INCREMENT BY 2
START WITH 2;

-- now let's return to the films table

ALTER TABLE films
ADD COLUMN id serial PRIMARY KEY;

-- remove primary key from films table while preserving the column

ALTER TABLE films 
DROP constraint films_pkey;
