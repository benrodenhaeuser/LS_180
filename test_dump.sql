--
-- PostgreSQL database dump
--

-- Dumped from database version 10.2
-- Dumped by pg_dump version 10.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: birds; Type: TABLE; Schema: public; Owner: rodenhaeuser
--

CREATE TABLE birds (
    name text,
    length numeric(3,1),
    wingspan numeric(3,1),
    family text,
    extinct boolean
);


ALTER TABLE birds OWNER TO rodenhaeuser;

--
-- Name: films; Type: TABLE; Schema: public; Owner: rodenhaeuser
--

CREATE TABLE films (
    title character varying(255),
    year integer,
    genre character varying(100),
    director text,
    duraction integer
);


ALTER TABLE films OWNER TO rodenhaeuser;

--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: rodenhaeuser
--

CREATE TABLE menu_items (
    item text,
    prep_time integer,
    ingredient_cost numeric(4,2),
    sales integer,
    menu_price numeric(4,2)
);


ALTER TABLE menu_items OWNER TO rodenhaeuser;

--
-- Name: people; Type: TABLE; Schema: public; Owner: rodenhaeuser
--

CREATE TABLE people (
    name text,
    age integer,
    occupation text
);


ALTER TABLE people OWNER TO rodenhaeuser;

--
-- Data for Name: birds; Type: TABLE DATA; Schema: public; Owner: rodenhaeuser
--

COPY birds (name, length, wingspan, family, extinct) FROM stdin;
Spotted Towhee	21.6	26.7	Emberizidae	f
American Robin	25.5	36.0	Turdidae	f
Greater Koa Finch	19.0	24.0	Fringilidae	t
Carolina Parakeet	33.0	55.8	Psittacidae	t
Common Kestrel	35.5	73.5	Falconidae	f
\.


--
-- Data for Name: films; Type: TABLE DATA; Schema: public; Owner: rodenhaeuser
--

COPY films (title, year, genre, director, duraction) FROM stdin;
Die Hard	1988	action	\N	\N
Casablanca	1942	drama	\N	\N
The Conversation	1974	thriller	\N	\N
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: rodenhaeuser
--

COPY menu_items (item, prep_time, ingredient_cost, sales, menu_price) FROM stdin;
omelette	10	1.50	182	7.99
tacos	5	2.00	254	8.99
oatmeal	1	0.50	79	5.99
\.


--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: rodenhaeuser
--

COPY people (name, age, occupation) FROM stdin;
Abby	34	biologist
Mu'nisah	26	\N
Mirabelle	40	contractor
\.


--
-- PostgreSQL database dump complete
--

