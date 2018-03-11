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
-- Name: employees; Type: TABLE; Schema: public; Owner: rodenhaeuser
--

CREATE TABLE employees (
    first_name character varying(100),
    last_name character varying(100),
    department character varying(100) DEFAULT 'unassigned'::character varying NOT NULL,
    vacation_remaining integer DEFAULT 0 NOT NULL
);


ALTER TABLE employees OWNER TO rodenhaeuser;

--
-- Name: weather; Type: TABLE; Schema: public; Owner: rodenhaeuser
--

CREATE TABLE weather (
    date date NOT NULL,
    low integer NOT NULL,
    high integer NOT NULL,
    rainfall numeric(5,3) DEFAULT 0
);


ALTER TABLE weather OWNER TO rodenhaeuser;

--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: rodenhaeuser
--

COPY employees (first_name, last_name, department, vacation_remaining) FROM stdin;
\.


--
-- Data for Name: weather; Type: TABLE DATA; Schema: public; Owner: rodenhaeuser
--

COPY weather (date, low, high, rainfall) FROM stdin;
2016-03-07	29	32	0.000
2016-03-08	23	31	0.000
2016-03-09	17	28	0.000
2016-03-01	34	43	0.117
2016-03-02	32	44	0.117
2016-03-03	31	47	0.156
2016-03-04	33	42	0.078
2016-03-05	39	46	0.273
2016-03-06	32	43	0.078
\.


--
-- PostgreSQL database dump complete
--

