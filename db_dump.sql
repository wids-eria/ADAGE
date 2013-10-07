--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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
-- Name: access_tokens; Type: TABLE; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE TABLE access_tokens (
    id integer NOT NULL,
    consumer_token character varying(255),
    consumer_secret character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer,
    client_id integer
);


ALTER TABLE public.access_tokens OWNER TO isaacgoodin;

--
-- Name: access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: isaacgoodin
--

CREATE SEQUENCE access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_tokens_id_seq OWNER TO isaacgoodin;

--
-- Name: access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: isaacgoodin
--

ALTER SEQUENCE access_tokens_id_seq OWNED BY access_tokens.id;


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE TABLE assignments (
    id integer NOT NULL,
    user_id integer,
    role_id integer,
    disabled_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    assigner_id integer
);


ALTER TABLE public.assignments OWNER TO isaacgoodin;

--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: isaacgoodin
--

CREATE SEQUENCE assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assignments_id_seq OWNER TO isaacgoodin;

--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: isaacgoodin
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE TABLE clients (
    id integer NOT NULL,
    name character varying(255),
    app_token character varying(255),
    app_secret character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.clients OWNER TO isaacgoodin;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: isaacgoodin
--

CREATE SEQUENCE clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_id_seq OWNER TO isaacgoodin;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: isaacgoodin
--

ALTER SEQUENCE clients_id_seq OWNED BY clients.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE TABLE games (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.games OWNER TO isaacgoodin;

--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: isaacgoodin
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.games_id_seq OWNER TO isaacgoodin;

--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: isaacgoodin
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: implementations; Type: TABLE; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE TABLE implementations (
    id integer NOT NULL,
    name character varying(255),
    game_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.implementations OWNER TO isaacgoodin;

--
-- Name: implementations_id_seq; Type: SEQUENCE; Schema: public; Owner: isaacgoodin
--

CREATE SEQUENCE implementations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.implementations_id_seq OWNER TO isaacgoodin;

--
-- Name: implementations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: isaacgoodin
--

ALTER SEQUENCE implementations_id_seq OWNED BY implementations.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying(255),
    game_id integer
);


ALTER TABLE public.roles OWNER TO isaacgoodin;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: isaacgoodin
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO isaacgoodin;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: isaacgoodin
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE TABLE roles_users (
    role_id integer,
    user_id integer
);


ALTER TABLE public.roles_users OWNER TO isaacgoodin;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO isaacgoodin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(128) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    authentication_token character varying(255),
    consented boolean DEFAULT false,
    control_group boolean,
    player_name character varying(255) DEFAULT ''::character varying
);


ALTER TABLE public.users OWNER TO isaacgoodin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: isaacgoodin
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO isaacgoodin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: isaacgoodin
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY access_tokens ALTER COLUMN id SET DEFAULT nextval('access_tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY clients ALTER COLUMN id SET DEFAULT nextval('clients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY implementations ALTER COLUMN id SET DEFAULT nextval('implementations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: access_tokens; Type: TABLE DATA; Schema: public; Owner: isaacgoodin
--

COPY access_tokens (id, consumer_token, consumer_secret, created_at, updated_at, user_id, client_id) FROM stdin;
\.


--
-- Name: access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: isaacgoodin
--

SELECT pg_catalog.setval('access_tokens_id_seq', 1, false);


--
-- Data for Name: assignments; Type: TABLE DATA; Schema: public; Owner: isaacgoodin
--

COPY assignments (id, user_id, role_id, disabled_at, created_at, updated_at, assigner_id) FROM stdin;
\.


--
-- Name: assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: isaacgoodin
--

SELECT pg_catalog.setval('assignments_id_seq', 1, false);


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: isaacgoodin
--

COPY clients (id, name, app_token, app_secret, created_at, updated_at) FROM stdin;
\.


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: isaacgoodin
--

SELECT pg_catalog.setval('clients_id_seq', 1, false);


--
-- Data for Name: games; Type: TABLE DATA; Schema: public; Owner: isaacgoodin
--

COPY games (id, name, created_at, updated_at) FROM stdin;
1	TESTGAME	2013-09-10 15:28:37.321941	2013-09-10 15:28:37.321941
\.


--
-- Name: games_id_seq; Type: SEQUENCE SET; Schema: public; Owner: isaacgoodin
--

SELECT pg_catalog.setval('games_id_seq', 1, true);


--
-- Data for Name: implementations; Type: TABLE DATA; Schema: public; Owner: isaacgoodin
--

COPY implementations (id, name, game_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: implementations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: isaacgoodin
--

SELECT pg_catalog.setval('implementations_id_seq', 1, false);


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: isaacgoodin
--

COPY roles (id, name, created_at, updated_at, type, game_id) FROM stdin;
1	player	2013-09-10 14:30:32.366623	2013-09-10 14:30:32.366623	\N	\N
2	admin	2013-09-10 14:41:15.106843	2013-09-10 14:41:15.106843	\N	\N
3	TESTGAME	2013-09-10 15:28:37.369762	2013-09-10 15:28:37.369762	ResearcherRole	1
4	TESTGAME	2013-09-10 15:28:37.389345	2013-09-10 15:28:37.389345	ParticipantRole	1
\.


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: isaacgoodin
--

SELECT pg_catalog.setval('roles_id_seq', 4, true);


--
-- Data for Name: roles_users; Type: TABLE DATA; Schema: public; Owner: isaacgoodin
--

COPY roles_users (role_id, user_id) FROM stdin;
2	1
1	1
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: isaacgoodin
--

COPY schema_migrations (version) FROM stdin;
20130625185315
20111219185837
20111223151802
20120203205030
20120206231816
20120606213858
20120606214027
20120618211823
20120618213031
20120618213647
20120618213743
20120711164247
20130226233427
20130619191407
20130619201211
20130621195932
20130624194924
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: isaacgoodin
--

COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, authentication_token, consented, control_group, player_name) FROM stdin;
1	igoodin@stu.de.nt	$2a$10$AIXK00mbysW4sj5n71LTP.aiDJ33pSEq2ZXOaH.8AAH75FsM.FrvW	\N	\N	\N	1	2013-09-10 14:30:32.415106	2013-09-10 14:30:32.415106	127.0.0.1	127.0.0.1	2013-09-10 14:30:32.408893	2013-09-10 14:30:32.416015	L2xtqPrFsxppjivpoStH	f	f	igoodin
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: isaacgoodin
--

SELECT pg_catalog.setval('users_id_seq', 1, true);


--
-- Name: access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: isaacgoodin; Tablespace: 
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT access_tokens_pkey PRIMARY KEY (id);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: isaacgoodin; Tablespace: 
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: clients_pkey; Type: CONSTRAINT; Schema: public; Owner: isaacgoodin; Tablespace: 
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: isaacgoodin; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: implementations_pkey; Type: CONSTRAINT; Schema: public; Owner: isaacgoodin; Tablespace: 
--

ALTER TABLE ONLY implementations
    ADD CONSTRAINT implementations_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: isaacgoodin; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: isaacgoodin; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: fk__assignments_assigner_id; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE INDEX fk__assignments_assigner_id ON assignments USING btree (assigner_id);


--
-- Name: index_access_tokens_on_client_id; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE INDEX index_access_tokens_on_client_id ON access_tokens USING btree (client_id);


--
-- Name: index_access_tokens_on_user_id; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE INDEX index_access_tokens_on_user_id ON access_tokens USING btree (user_id);


--
-- Name: index_assignments_on_role_id; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE INDEX index_assignments_on_role_id ON assignments USING btree (role_id);


--
-- Name: index_assignments_on_user_id; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE INDEX index_assignments_on_user_id ON assignments USING btree (user_id);


--
-- Name: index_implementations_on_game_id; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE INDEX index_implementations_on_game_id ON implementations USING btree (game_id);


--
-- Name: index_roles_on_game_id; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE INDEX index_roles_on_game_id ON roles USING btree (game_id);


--
-- Name: index_roles_users_on_role_id; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE INDEX index_roles_users_on_role_id ON roles_users USING btree (role_id);


--
-- Name: index_roles_users_on_user_id; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE INDEX index_roles_users_on_user_id ON roles_users USING btree (user_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON users USING btree (authentication_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_player_name; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_player_name ON users USING btree (lower((player_name)::text));


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: isaacgoodin; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: access_tokens_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT access_tokens_client_id_fkey FOREIGN KEY (client_id) REFERENCES clients(id);


--
-- Name: access_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT access_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: assignments_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- Name: assignments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_assignments_assigner_id; Type: FK CONSTRAINT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT fk_assignments_assigner_id FOREIGN KEY (assigner_id) REFERENCES users(id);


--
-- Name: implementations_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY implementations
    ADD CONSTRAINT implementations_game_id_fkey FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: roles_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_game_id_fkey FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: roles_users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT roles_users_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- Name: roles_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: isaacgoodin
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT roles_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: isaacgoodin
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM isaacgoodin;
GRANT ALL ON SCHEMA public TO isaacgoodin;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

