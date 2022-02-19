--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    question_id bigint NOT NULL,
    content_japanese character varying,
    content_english character varying,
    content_german character varying,
    content_french character varying,
    content_spanish character varying,
    content_italian character varying,
    content_dutch character varying,
    content_portuguese character varying,
    content_french_canada character varying,
    choice1_japanese character varying,
    choice1_english character varying,
    choice1_german character varying,
    choice1_french character varying,
    choice1_spanish character varying,
    choice1_italian character varying,
    choice1_dutch character varying,
    choice1_portuguese character varying,
    choice1_french_canada character varying,
    choice2_japanese character varying,
    choice2_english character varying,
    choice2_german character varying,
    choice2_french character varying,
    choice2_spanish character varying,
    choice2_italian character varying,
    choice2_dutch character varying,
    choice2_portuguese character varying,
    choice2_french_canada character varying,
    type integer,
    category integer,
    region_code integer,
    start_date bigint,
    end_date bigint
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- Name: suggestions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suggestions (
    id integer NOT NULL,
    country_code integer NOT NULL,
    region_code integer NOT NULL,
    language_code integer NOT NULL,
    content character varying NOT NULL,
    choice1 character varying NOT NULL,
    choice2 character varying NOT NULL,
    wii_no bigint NOT NULL
);


ALTER TABLE public.suggestions OWNER TO postgres;

--
-- Name: suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suggestions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suggestions_id_seq OWNER TO postgres;

--
-- Name: suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suggestions_id_seq OWNED BY public.suggestions.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.votes (
    id integer NOT NULL,
    type_cd integer NOT NULL,
    question_id integer NOT NULL,
    wii_no bigint NOT NULL,
    country_id integer NOT NULL,
    region_id integer NOT NULL,
    ans_cnt integer NOT NULL
);


ALTER TABLE public.votes OWNER TO postgres;

--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.votes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.votes_id_seq OWNER TO postgres;

--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.votes_id_seq OWNED BY public.votes.id;


--
-- Name: suggestions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suggestions ALTER COLUMN id SET DEFAULT nextval('public.suggestions_id_seq'::regclass);


--
-- Name: votes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votes ALTER COLUMN id SET DEFAULT nextval('public.votes_id_seq'::regclass);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- Name: suggestions suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suggestions
    ADD CONSTRAINT suggestions_pkey PRIMARY KEY (id);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

