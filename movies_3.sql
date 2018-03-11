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
ALTER TABLE ONLY public.films DROP CONSTRAINT films_pkey;
ALTER TABLE public.films ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.films_id_seq;
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
    id integer NOT NULL,
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
-- Name: films_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE films_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: films_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE films_id_seq OWNED BY films.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY films ALTER COLUMN id SET DEFAULT nextval('films_id_seq'::regclass);


--
-- Data for Name: films; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO films VALUES (1, 'Die Hard', 1988, 'action', 'John McTiernan', 132);
INSERT INTO films VALUES (2, 'Casablanca', 1942, 'drama', 'Michael Curtiz', 102);
INSERT INTO films VALUES (3, 'The Conversation', 1974, 'thriller', 'Francis Ford Coppola', 113);
INSERT INTO films VALUES (4, '1984', 1956, 'scifi', 'Michael Anderson', 90);
INSERT INTO films VALUES (5, 'Tinker Tailor Soldier Spy', 2011, 'espionage', 'Tomas Alfredson', 127);
INSERT INTO films VALUES (6, 'The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);
INSERT INTO films VALUES (7, '28 Days Later', 2002, 'horror', 'Danny Boyle', 113);
INSERT INTO films VALUES (8, 'The Godfather', 1972, 'crime', 'Francis Ford Coppola', 175);
INSERT INTO films VALUES (9, '12 Angry Men', 1957, 'drama', 'Sidney Lumet', 96);
INSERT INTO films VALUES (10, 'Interstellar', 2014, 'scifi', 'Christopher Nolan', 169);
INSERT INTO films VALUES (11, 'Midnight Special', 2016, 'scifi', 'Jeff Nicols', 111);
INSERT INTO films VALUES (12, 'Home Alone', 1990, 'comedy', 'John Wilden Hughes, Jr.', 102);
INSERT INTO films VALUES (13, 'Hairspray', 1988, 'comedy', 'John Waters', 92);
INSERT INTO films VALUES (14, 'Godzilla', 1998, 'scifi', 'Roland Emmerich', 139);
INSERT INTO films VALUES (15, 'Godzilla', 2014, 'scifi', 'Gareth Edwards', 123);



--
-- Name: films_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('films_id_seq', 15, true);


--
-- Name: films_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY films
    ADD CONSTRAINT films_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--


INSERT INTO films(title, year, genre, director, duration)
VALUES ('Wayne''s World', 1991, 'comedy', 'Penelope Spheeris', 95),
       ('Bourne Identity', 2002, 'espionage', 'Doug Liman', 118);


-- list the genres

SELECT genre
FROM films
GROUP BY genre;

-- oder:

SELECT DISTINCT genre
FROM films;

-- so distance essentially says 'no repetitions'


-- Write a SQL query that determines the average duration across all the movies in the films table, rounded to the nearest minute.

-- avg duration is: sum of all durations divided by number of films

SELECT round(1.0 * sum(duration) / count(*), 0) AS avg_duration
FROM films;

-- this gives us an integer, which is more or less fine. but what if we wanted the precise value? also, it seems this truncates.

-- or use avg:

SELECT round(avg(duration))
FROM films;


-- Write a SQL query that determines the average duration for each genre in the films table, rounded to the nearest minute.

SELECT round(avg(duration))
FROM films
GROUP BY genre;

-- Write a SQL query that determines the average duration of movies for each decade represented in the films table, rounded to the nearest minute and listed in chronological order.

-- step 1: get the decades.

SELECT title, year - mod(year, 10) AS decade
FROM films;

-- step 2: determine the average duration

-- my solution:

SELECT year - mod(year, 10) AS decade, round(avg(duration)) AS average
FROM films
GROUP BY decade
ORDER BY decade;

-- ls solution:

SELECT year / 10 * 10 AS decade, ROUND(AVG(duration)) AS average_duration
FROM films
GROUP BY decade
ORDER BY decade;

-- Write a SQL query that finds all films whose director has the first name John. (GROUP BY and Aggregate Functions, ex. 8)

SELECT title, director
FROM films
WHERE director LIKE 'John %';


SELECT genre, count(id)
FROM films
GROUP BY genre
ORDER BY count(genre) DESC;


-- write a query that returns the following relation:

-- decade |   genre   |                  films
-- --------+-----------+------------------------------------------
--    1940 | drama     | Casablanca
--    1950 | drama     | 12 Angry Men
--    1950 | scifi     | 1984
--    1970 | crime     | The Godfather
--    1970 | thriller  | The Conversation
--    1980 | action    | Die Hard
--    1980 | comedy    | Hairspray
--    1990 | comedy    | Home Alone, The Birdcage, Wayne's World
--    1990 | scifi     | Godzilla
--    2000 | espionage | Bourne Identity
--    2000 | horror    | 28 Days Later
--    2010 | espionage | Tinker Tailor Soldier Spy
--    2010 | scifi     | Midnight Special, Interstellar, Godzilla
-- (13 rows)


-- start with this:

SELECT year - mod(year, 10) AS decade, genre, title
FROM films
ORDER BY decade;

-- this yields:

-- decade |   genre   |           title
-- --------+-----------+---------------------------
--   1940 | drama     | Casablanca
--   1950 | scifi     | 1984
--   1950 | drama     | 12 Angry Men
--   1970 | crime     | The Godfather
--   1970 | thriller  | The Conversation
--   1980 | action    | Die Hard
--   1980 | comedy    | Hairspray
--   1990 | comedy    | Home Alone
--   1990 | comedy    | The Birdcage
--   1990 | comedy    | Wayne's World
--   1990 | scifi     | Godzilla
--   2000 | horror    | 28 Days Later
--   2000 | espionage | Bourne Identity
--   2010 | scifi     | Midnight Special
--   2010 | scifi     | Godzilla
--   2010 | scifi     | Interstellar
--   2010 | espionage | Tinker Tailor Soldier Spy

-- so what remains to be done is to make a list of films per genre per decade
-- (and group the table by genre?)

-- the following lists all films titles as a concatenated string:

SELECT string_agg(title, ', ' ORDER BY title)
FROM films;

SELECT year - mod(year, 10) AS decade, genre, title
FROM films
ORDER BY decade;

-- this is a list of the genres with the films listed:

SELECT year - mod(year, 10) AS decade, genre, string_agg(title, ', ' ORDER BY title) as films
FROM films
GROUP BY genre, decade;


-- decade |   genre   |                  films
-- --------+-----------+------------------------------------------
--   1980 | action    | Die Hard
--   1980 | comedy    | Hairspray
--   1990 | comedy    | Home Alone, The Birdcage, Wayne's World
--   1970 | crime     | The Godfather
--   1940 | drama     | Casablanca
--   1950 | drama     | 12 Angry Men
--   2000 | espionage | Bourne Identity
--   2010 | espionage | Tinker Tailor Soldier Spy
--
--   2000 | horror    | 28 Days Later
--   1950 | scifi     | 1984
--   1990 | scifi     | Godzilla
--   2010 | scifi     | Godzilla, Interstellar, Midnight Special
--   1970 | thriller  | The Conversation
-- (13 rows)

  SELECT year - mod(year, 10) AS decade,
         genre,
         string_agg(title, ', ' ORDER BY title) as films
    FROM films
GROUP BY genre, decade
ORDER BY decade, genre;


-- now we want a list of the genres, with the sum of the durations

SELECT genre, sum(duration) AS total_duration
FROM films
GROUP BY genre
ORDER BY total_duration;
