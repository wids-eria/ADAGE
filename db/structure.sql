--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: access_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE access_tokens (
    id integer NOT NULL,
    consumer_token character varying(255),
    consumer_secret character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    client_id integer
);


--
-- Name: access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE access_tokens_id_seq OWNED BY access_tokens.id;


--
-- Name: achievements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE achievements (
    id integer NOT NULL,
    data hstore,
    game_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE achievements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE achievements_id_seq OWNED BY achievements.id;


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignments (
    id integer NOT NULL,
    user_id integer,
    role_id integer,
    disabled_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    assigner_id integer
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clients (
    id integer NOT NULL,
    name character varying(255),
    app_token character varying(255),
    app_secret character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    implementation_id integer
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clients_id_seq OWNED BY clients.id;


--
-- Name: dashboards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dashboards (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dashboards_id_seq OWNED BY dashboards.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: graphs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE graphs (
    id integer NOT NULL,
    settings json,
    metrics json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: graphs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE graphs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: graphs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE graphs_id_seq OWNED BY graphs.id;


--
-- Name: group_ownerships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE group_ownerships (
    id integer NOT NULL,
    user_id integer,
    group_id integer
);


--
-- Name: group_ownerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_ownerships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_ownerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_ownerships_id_seq OWNED BY group_ownerships.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups (
    id integer NOT NULL,
    code character varying(255),
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    playsquad boolean DEFAULT true
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: groups_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups_users (
    group_id integer,
    user_id integer
);


--
-- Name: implementations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE implementations (
    id integer NOT NULL,
    name character varying(255),
    game_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    schema json
);


--
-- Name: implementations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE implementations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: implementations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE implementations_id_seq OWNED BY implementations.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying(255),
    game_id integer
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles_users (
    role_id integer,
    user_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: social_access_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE social_access_tokens (
    id integer NOT NULL,
    uid character varying(255),
    provider character varying(255),
    access_token character varying(255),
    expired_at timestamp without time zone,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: social_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE social_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: social_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE social_access_tokens_id_seq OWNED BY social_access_tokens.id;


--
-- Name: stats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stats (
    id integer NOT NULL,
    data hstore,
    game_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stats_id_seq OWNED BY stats.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(128) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_token character varying(255),
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    authentication_token character varying(255),
    consented boolean DEFAULT false,
    control_group boolean,
    player_name character varying(255) DEFAULT ''::character varying,
    guest boolean DEFAULT false,
    teacher_status_cd integer
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_tokens ALTER COLUMN id SET DEFAULT nextval('access_tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY achievements ALTER COLUMN id SET DEFAULT nextval('achievements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients ALTER COLUMN id SET DEFAULT nextval('clients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dashboards ALTER COLUMN id SET DEFAULT nextval('dashboards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY graphs ALTER COLUMN id SET DEFAULT nextval('graphs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_ownerships ALTER COLUMN id SET DEFAULT nextval('group_ownerships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY implementations ALTER COLUMN id SET DEFAULT nextval('implementations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY social_access_tokens ALTER COLUMN id SET DEFAULT nextval('social_access_tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stats ALTER COLUMN id SET DEFAULT nextval('stats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT access_tokens_pkey PRIMARY KEY (id);


--
-- Name: achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: graphs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY graphs
    ADD CONSTRAINT graphs_pkey PRIMARY KEY (id);


--
-- Name: group_ownerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY group_ownerships
    ADD CONSTRAINT group_ownerships_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: implementations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY implementations
    ADD CONSTRAINT implementations_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: social_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY social_access_tokens
    ADD CONSTRAINT social_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: fk__access_tokens_client_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__access_tokens_client_id ON access_tokens USING btree (client_id);


--
-- Name: fk__access_tokens_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__access_tokens_user_id ON access_tokens USING btree (user_id);


--
-- Name: fk__achievements_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__achievements_game_id ON achievements USING btree (game_id);


--
-- Name: fk__achievements_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__achievements_user_id ON achievements USING btree (user_id);


--
-- Name: fk__assignments_assigner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__assignments_assigner_id ON assignments USING btree (assigner_id);


--
-- Name: fk__assignments_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__assignments_role_id ON assignments USING btree (role_id);


--
-- Name: fk__assignments_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__assignments_user_id ON assignments USING btree (user_id);


--
-- Name: fk__clients_implementation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__clients_implementation_id ON clients USING btree (implementation_id);


--
-- Name: fk__group_ownerships_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__group_ownerships_group_id ON group_ownerships USING btree (group_id);


--
-- Name: fk__group_ownerships_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__group_ownerships_user_id ON group_ownerships USING btree (user_id);


--
-- Name: fk__groups_users_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__groups_users_group_id ON groups_users USING btree (group_id);


--
-- Name: fk__groups_users_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__groups_users_user_id ON groups_users USING btree (user_id);


--
-- Name: fk__implementations_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__implementations_game_id ON implementations USING btree (game_id);


--
-- Name: fk__roles_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__roles_game_id ON roles USING btree (game_id);


--
-- Name: fk__roles_users_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__roles_users_role_id ON roles_users USING btree (role_id);


--
-- Name: fk__roles_users_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__roles_users_user_id ON roles_users USING btree (user_id);


--
-- Name: fk__social_access_tokens_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__social_access_tokens_user_id ON social_access_tokens USING btree (user_id);


--
-- Name: fk__stats_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__stats_game_id ON stats USING btree (game_id);


--
-- Name: fk__stats_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk__stats_user_id ON stats USING btree (user_id);


--
-- Name: index_achievements_on_data; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_achievements_on_data ON achievements USING gist (data);


--
-- Name: index_social_access_tokens_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_social_access_tokens_on_user_id ON social_access_tokens USING btree (user_id);


--
-- Name: index_stats_on_data; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stats_on_data ON stats USING gist (data);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON users USING btree (authentication_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_player_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_player_name ON users USING btree (lower((player_name)::text));


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_access_tokens_client_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT fk_access_tokens_client_id FOREIGN KEY (client_id) REFERENCES clients(id);


--
-- Name: fk_access_tokens_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT fk_access_tokens_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_achievements_game_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY achievements
    ADD CONSTRAINT fk_achievements_game_id FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: fk_achievements_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY achievements
    ADD CONSTRAINT fk_achievements_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_assignments_assigner_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT fk_assignments_assigner_id FOREIGN KEY (assigner_id) REFERENCES users(id);


--
-- Name: fk_assignments_role_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT fk_assignments_role_id FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- Name: fk_assignments_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT fk_assignments_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_clients_implementation_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT fk_clients_implementation_id FOREIGN KEY (implementation_id) REFERENCES implementations(id);


--
-- Name: fk_group_ownerships_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_ownerships
    ADD CONSTRAINT fk_group_ownerships_group_id FOREIGN KEY (group_id) REFERENCES groups(id);


--
-- Name: fk_group_ownerships_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_ownerships
    ADD CONSTRAINT fk_group_ownerships_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_groups_users_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups_users
    ADD CONSTRAINT fk_groups_users_group_id FOREIGN KEY (group_id) REFERENCES groups(id);


--
-- Name: fk_groups_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups_users
    ADD CONSTRAINT fk_groups_users_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_implementations_game_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY implementations
    ADD CONSTRAINT fk_implementations_game_id FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: fk_roles_game_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT fk_roles_game_id FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: fk_roles_users_role_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT fk_roles_users_role_id FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- Name: fk_roles_users_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles_users
    ADD CONSTRAINT fk_roles_users_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_social_access_tokens_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY social_access_tokens
    ADD CONSTRAINT fk_social_access_tokens_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_stats_game_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT fk_stats_game_id FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: fk_stats_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT fk_stats_user_id FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20111219185837');

INSERT INTO schema_migrations (version) VALUES ('20111223151802');

INSERT INTO schema_migrations (version) VALUES ('20120203205030');

INSERT INTO schema_migrations (version) VALUES ('20120206231816');

INSERT INTO schema_migrations (version) VALUES ('20120606213858');

INSERT INTO schema_migrations (version) VALUES ('20120606214027');

INSERT INTO schema_migrations (version) VALUES ('20120618211823');

INSERT INTO schema_migrations (version) VALUES ('20120618213031');

INSERT INTO schema_migrations (version) VALUES ('20120618213647');

INSERT INTO schema_migrations (version) VALUES ('20120618213743');

INSERT INTO schema_migrations (version) VALUES ('20120711164247');

INSERT INTO schema_migrations (version) VALUES ('20130226233427');

INSERT INTO schema_migrations (version) VALUES ('20130619191407');

INSERT INTO schema_migrations (version) VALUES ('20130619201211');

INSERT INTO schema_migrations (version) VALUES ('20130621195932');

INSERT INTO schema_migrations (version) VALUES ('20130624194924');

INSERT INTO schema_migrations (version) VALUES ('20130625185315');

INSERT INTO schema_migrations (version) VALUES ('20130919174153');

INSERT INTO schema_migrations (version) VALUES ('20130923203258');

INSERT INTO schema_migrations (version) VALUES ('20131003205714');

INSERT INTO schema_migrations (version) VALUES ('20131011192826');

INSERT INTO schema_migrations (version) VALUES ('20131014165930');

INSERT INTO schema_migrations (version) VALUES ('20131015214850');

INSERT INTO schema_migrations (version) VALUES ('20131017184506');

INSERT INTO schema_migrations (version) VALUES ('20131018184315');

INSERT INTO schema_migrations (version) VALUES ('20140507183222');

INSERT INTO schema_migrations (version) VALUES ('20140509211600');

INSERT INTO schema_migrations (version) VALUES ('20140708210113');

INSERT INTO schema_migrations (version) VALUES ('20140709183815');

INSERT INTO schema_migrations (version) VALUES ('20150107220957');

INSERT INTO schema_migrations (version) VALUES ('20150109222014');