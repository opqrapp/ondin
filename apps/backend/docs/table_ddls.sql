--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: conditions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conditions (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    operator character varying(255) NOT NULL,
    value character varying(255),
    "values" character varying(255)[],
    rule_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conditions_id_seq OWNED BY public.conditions.id;


--
-- Name: features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.features (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    default_variation jsonb NOT NULL,
    project_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.features_id_seq OWNED BY public.features.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rules (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    priority integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    feature_id bigint NOT NULL,
    variation jsonb NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rules_id_seq OWNED BY public.rules.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    description text,
    type character varying(255) DEFAULT 'string'::character varying,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: conditions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conditions ALTER COLUMN id SET DEFAULT nextval('public.conditions_id_seq'::regclass);


--
-- Name: features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.features ALTER COLUMN id SET DEFAULT nextval('public.features_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rules ALTER COLUMN id SET DEFAULT nextval('public.rules_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: conditions conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conditions
    ADD CONSTRAINT conditions_pkey PRIMARY KEY (id);


--
-- Name: features features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.features
    ADD CONSTRAINT features_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: rules rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: conditions_key_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX conditions_key_index ON public.conditions USING btree (key);


--
-- Name: conditions_rule_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX conditions_rule_id_index ON public.conditions USING btree (rule_id);


--
-- Name: features_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX features_name_index ON public.features USING btree (name);


--
-- Name: features_project_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX features_project_id_index ON public.features USING btree (project_id);


--
-- Name: features_project_id_key_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX features_project_id_key_index ON public.features USING btree (project_id, key);


--
-- Name: projects_key_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_key_index ON public.projects USING btree (key);


--
-- Name: projects_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX projects_name_index ON public.projects USING btree (name);


--
-- Name: rules_feature_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rules_feature_id_index ON public.rules USING btree (feature_id);


--
-- Name: rules_priority_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rules_priority_index ON public.rules USING btree (priority);


--
-- Name: settings_key_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX settings_key_index ON public.settings USING btree (key);


--
-- Name: conditions conditions_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conditions
    ADD CONSTRAINT conditions_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.rules(id) ON DELETE CASCADE;


--
-- Name: features features_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.features
    ADD CONSTRAINT features_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: rules rules_feature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rules
    ADD CONSTRAINT rules_feature_id_fkey FOREIGN KEY (feature_id) REFERENCES public.features(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

