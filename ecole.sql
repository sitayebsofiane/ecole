--
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

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

--
-- Name: emira(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.emira(e text, p text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare 
	em text;
	pa text;
BEGIN
   select email into em from users where email=e and password=p;
   select password into pa from users where email=e and password=p;
   if (em not in ('') and pa not in ('')) then
   	return TRUE;
   else
   	return FALSE;
   end if;
END;
$$;


ALTER FUNCTION public.emira(e text, p text) OWNER TO postgres;

--
-- Name: fibo(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fibo(n integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare compteur integer := 0;
i integer := 0;
j integer := 1;
begin 
if(n<1) then
return 0;
end if;
loop
exit when compteur =n;
compteur =compteur +1;
select j,i+j into i,j;
end loop;
return i;
end;
$$;


ALTER FUNCTION public.fibo(n integer) OWNER TO postgres;

--
-- Name: somme_n_produits(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.somme_n_produits(x integer, y integer, OUT somme integer, OUT produit integer) RETURNS record
    LANGUAGE plpgsql
    AS $$
BEGIN
    somme := x + y;
    produit := x * y;
END;
$$;


ALTER FUNCTION public.somme_n_produits(x integer, y integer, OUT somme integer, OUT produit integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: absence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.absence (
    id integer NOT NULL,
    etudiant_id integer NOT NULL,
    motif character varying(255) DEFAULT NULL::character varying,
    cour_id integer NOT NULL
);


ALTER TABLE public.absence OWNER TO postgres;

--
-- Name: absence_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.absence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.absence_id_seq OWNER TO postgres;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    email character varying(180) NOT NULL,
    roles json NOT NULL,
    password character varying(255) NOT NULL,
    nom character varying(60) DEFAULT NULL::character varying,
    prenom character varying(60) DEFAULT NULL::character varying,
    adresse character varying(255) DEFAULT NULL::character varying,
    photo character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_enseigne; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_enseigne (
    admin_id integer NOT NULL,
    enseigne_id integer NOT NULL
);


ALTER TABLE public.admin_enseigne OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_id_seq OWNER TO postgres;

--
-- Name: cour; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cour (
    id integer NOT NULL,
    date timestamp(0) without time zone,
    durre_en_minte integer NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    promotion_id integer NOT NULL,
    matiere_id integer NOT NULL
);


ALTER TABLE public.cour OWNER TO postgres;

--
-- Name: cour_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cour_id_seq OWNER TO postgres;

--
-- Name: enseigne; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enseigne (
    id integer NOT NULL,
    nom character varying(255) NOT NULL,
    libelle character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.enseigne OWNER TO postgres;

--
-- Name: enseigne_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enseigne_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enseigne_id_seq OWNER TO postgres;

--
-- Name: etudiant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.etudiant (
    id integer NOT NULL,
    promotion_id integer,
    nom character varying(60) DEFAULT NULL::character varying,
    prenom character varying(60) DEFAULT NULL::character varying,
    email character varying(255) DEFAULT NULL::character varying,
    photo character varying(255) DEFAULT NULL::character varying,
    adresses character varying(255) DEFAULT NULL::character varying,
    date_de_naissance date,
    password character varying(255) DEFAULT NULL::character varying,
    inscrit boolean NOT NULL
);


ALTER TABLE public.etudiant OWNER TO postgres;

--
-- Name: etudiant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.etudiant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.etudiant_id_seq OWNER TO postgres;

--
-- Name: matiere; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matiere (
    id integer NOT NULL,
    enseigne_id integer,
    nom character varying(255) NOT NULL
);


ALTER TABLE public.matiere OWNER TO postgres;

--
-- Name: matiere_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.matiere_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.matiere_id_seq OWNER TO postgres;

--
-- Name: migration_versions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migration_versions (
    version character varying(14) NOT NULL,
    executed_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.migration_versions OWNER TO postgres;

--
-- Name: COLUMN migration_versions.executed_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.migration_versions.executed_at IS '(DC2Type:datetime_immutable)';


--
-- Name: promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion (
    id integer NOT NULL,
    libelle character varying(255) NOT NULL,
    enseigne_id integer NOT NULL
);


ALTER TABLE public.promotion OWNER TO postgres;

--
-- Name: promotion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promotion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.promotion_id_seq OWNER TO postgres;

--
-- Data for Name: absence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.absence (id, etudiant_id, motif, cour_id) FROM stdin;
13	5		28
16	2		32
17	1		32
19	2	f<sf<F<SV<S<VHQQEH	28
20	2	QREGEGRQEGQEG	21
21	5	aaaaaaa	21
22	1		21
\.


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, email, roles, password, nom, prenom, adresse, photo) FROM stdin;
1	sitayebsofiane51@gmail.com	["ROLE_SUPER_ADMIN"]	$argon2id$v=19$m=65536,t=4,p=1$SXFKYkNwV0VBWWJCQzl4Lw$XZOq1EDriuc5crssuLUJOkEtrvtB0DBOYNImwDVWRv4	\N	\N	\N	\N
10	michel@melody.fr	["ROLE_ADMIN"]	$argon2id$v=19$m=65536,t=4,p=1$Z0ZyYnBkWW82cG1ZTGozQQ$SwOm8I4TaU6gjv++b+PjY/WNSd+Bj+R9mg4BWCX7ppU	michel	melody	lille	https://zupimages.net/up/20/19/8nc2.jpg
12	immigred59@gmail.com	["ROLE_ADMIN"]	$argon2id$v=19$m=65536,t=4,p=1$eFBYb1B0bWMxNEZoajJPZQ$dGzAWa5dW1loDYc0UxYnvKMMLqryG4272L/fn2q/LAg	si-tayeb	sofiane	44 rue kl├®ber	photo
\.


--
-- Data for Name: admin_enseigne; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin_enseigne (admin_id, enseigne_id) FROM stdin;
\.


--
-- Data for Name: cour; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cour (id, date, durre_en_minte, description, promotion_id, matiere_id) FROM stdin;
21	2015-01-01 00:00:00	120	programation web cot├® serveur	2	19
28	2015-01-01 00:00:00	120	programation web cot├® serveur	2	1
31	2015-01-01 00:00:00	120	arf├®daz	4	27
32	2022-05-05 06:11:00	120	programation web cot├® serveur	4	47
35	2015-01-01 00:01:00	12	jjjj	2	26
38	2015-02-01 00:00:00	120	programation web cot├® serveur	2	36
40	2015-01-01 00:00:00	120	ddd	7	39
\.


--
-- Data for Name: enseigne; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enseigne (id, nom, libelle) FROM stdin;
4	classe 15	mathematiques
2	Math	libelle_enseinge
5	salle22	pysique15
6	salle19	libelle_nfa021
7	salle36	chimie
\.


--
-- Data for Name: etudiant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.etudiant (id, promotion_id, nom, prenom, email, photo, adresses, date_de_naissance, password, inscrit) FROM stdin;
6	\N	mouloud	mouloud	mouloud@mouloud.fr	https://zupimages.net/up/20/19/xpxb.jpg	roubaix	2015-01-01	$2y$10$mk8hWz.qFlLgiCJ.4HA8duaLk8/60iNpFWaUuiEI9UHMNtiQr8xEC	f
5	4	amina	amina	amina@amina.fr	https://zupimages.net/up/20/19/8nc2.jpg	roubaix	2020-05-10	$2y$10$4ghKByz5QS1Ozm3VrCrHpO7RVdvvVFZ28sj78El1qQ5M9R7TzQtp6	t
7	\N	mazari	fadhila	assia.noureddine@yahoo.fr	eee	44 rue d'alger	2015-01-01	$2y$10$dGUAOIOg0JUK74jzwfWHYupQOMSQZgXx5gGhU2KZSXmXUxCOI64Om	t
2	4	brunolemaire	bruno	emira@emira.fr	https://zupimages.net/up/20/19/y3zw.jpg	roubaix	2020-05-10	$2y$10$D90LgIky7q/WYhzIYuvL3OwUpqgNx5NRGw4rJoGJVs23rPEUfIJuK	t
1	2	melody	melody	bruno@bruno.fr	https://zupimages.net/up/20/15/tshm.jpg	roubaix	2020-06-08	$2y$10$0tluz9tYHPF7/JDUGR9Hkufbd4oCHPUlXW8xI/JSKQm.bFKMK31.m	t
\.


--
-- Data for Name: matiere; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matiere (id, enseigne_id, nom) FROM stdin;
1	2	math
24	5	matiere24
47	5	matiere47
43	6	matiere43
42	5	matiere42
41	4	matiere41
39	7	matiere39
4	2	matiere4
5	2	matiere5
6	2	matiere6
7	2	matiere7
8	2	matiere8
9	2	matiere9
10	2	matiere10
11	2	matiere11
12	2	matiere12
13	2	matiere13
14	2	matiere14
15	2	matiere15
16	2	matiere16
17	2	matiere17
18	2	matiere18
19	2	matiere19
20	2	matiere20
21	2	matiere21
22	2	matiere22
23	2	matiere23
25	2	matiere25
26	2	matiere26
27	2	matiere27
28	2	matiere28
29	2	matiere29
30	2	matiere30
31	2	matiere31
32	2	matiere32
33	2	matiere33
34	2	matiere34
35	2	matiere35
36	2	matiere36
37	2	matiere37
38	2	matiere38
40	2	matiere40
\.


--
-- Data for Name: migration_versions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migration_versions (version, executed_at) FROM stdin;
20200315181342	2020-03-15 18:14:22
20200315183755	2020-03-15 18:38:27
20200315184157	2020-03-15 18:42:09
20200324134859	2020-03-24 13:51:22
20200324135657	2020-03-24 13:57:18
20200324135900	2020-03-24 13:59:07
20200324140607	2020-03-24 14:06:13
20200324145912	2020-03-24 14:59:20
20200324151301	2020-03-24 15:13:11
20200324151521	2020-03-24 15:15:32
20200324152701	2020-03-24 15:27:17
20200324152751	2020-03-24 15:28:18
20200324155219	2020-03-24 15:52:26
20200324172739	2020-03-24 17:27:58
20200324175536	2020-03-24 17:55:45
20200324175844	2020-03-24 17:59:42
20200325093339	2020-03-25 09:34:00
20200325121139	2020-03-25 12:11:58
20200325135051	2020-03-25 13:51:01
20200330103049	2020-03-30 10:31:20
20200330103251	2020-03-30 10:32:58
20200330104200	2020-03-30 10:42:12
20200330121115	2020-03-30 12:11:30
20200330121247	2020-03-30 12:13:01
20200330121412	2020-03-30 12:14:20
20200330131238	2020-03-30 13:12:48
20200330131337	2020-03-30 13:13:43
20200331124811	2020-03-31 12:49:53
20200331135406	2020-03-31 13:54:16
20200331140730	2020-03-31 14:07:36
20200403125336	2020-04-03 12:53:48
20200403203010	2020-04-03 20:30:19
20200403212044	2020-04-03 21:20:53
20200405172526	2020-04-05 17:26:19
20200405180134	2020-04-05 18:01:43
20200405185710	2020-04-05 18:57:28
20200406161705	2020-04-06 16:17:14
20200406181558	2020-04-06 18:16:13
20200406182102	2020-04-06 18:21:36
20200406191627	2020-04-06 19:16:36
20200406192639	2020-04-06 19:26:58
20200406194349	2020-04-06 19:43:59
20200406221936	2020-04-06 22:19:55
20200406235625	2020-04-06 23:56:34
20200406235845	2020-04-06 23:58:55
20200407000025	2020-04-07 00:00:30
20200407000928	2020-04-07 00:09:40
20200407001749	2020-04-07 00:17:58
20200407002349	2020-04-07 00:23:54
20200407002706	2020-04-07 00:27:11
20200407004032	2020-04-07 00:40:37
20200407004158	2020-04-07 00:42:49
20200407004803	2020-04-07 00:48:42
20200407135333	2020-04-07 13:53:44
20200407140304	2020-04-07 14:03:09
20200407141910	2020-04-07 14:19:15
20200407142012	2020-04-07 14:20:18
20200407145250	2020-04-07 14:52:59
20200407145527	2020-04-07 14:55:34
20200408091304	2020-04-08 09:13:17
20200408091711	2020-04-08 09:17:22
20200426223840	2020-04-26 22:39:04
20200428034538	2020-04-28 03:45:48
20200501142000	2020-05-01 14:21:00
20200509195537	2020-05-09 19:55:48
20200509195724	2020-05-09 19:57:32
20200509221118	2020-05-09 22:11:25
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion (id, libelle, enseigne_id) FROM stdin;
2	promo2	4
4	promo1	6
6	promo3	7
7	QGEWBQWB	2
\.


--
-- Name: absence_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.absence_id_seq', 23, true);


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 12, true);


--
-- Name: cour_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cour_id_seq', 40, true);


--
-- Name: enseigne_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enseigne_id_seq', 7, true);


--
-- Name: etudiant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.etudiant_id_seq', 7, true);


--
-- Name: matiere_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matiere_id_seq', 64, true);


--
-- Name: promotion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotion_id_seq', 7, true);


--
-- Name: absence absence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.absence
    ADD CONSTRAINT absence_pkey PRIMARY KEY (id);


--
-- Name: admin_enseigne admin_enseigne_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enseigne
    ADD CONSTRAINT admin_enseigne_pkey PRIMARY KEY (admin_id, enseigne_id);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: cour cour_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cour
    ADD CONSTRAINT cour_pkey PRIMARY KEY (id);


--
-- Name: enseigne enseigne_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enseigne
    ADD CONSTRAINT enseigne_pkey PRIMARY KEY (id);


--
-- Name: etudiant etudiant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etudiant
    ADD CONSTRAINT etudiant_pkey PRIMARY KEY (id);


--
-- Name: matiere matiere_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matiere
    ADD CONSTRAINT matiere_pkey PRIMARY KEY (id);


--
-- Name: migration_versions migration_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migration_versions
    ADD CONSTRAINT migration_versions_pkey PRIMARY KEY (version);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: idx_717e22e3139df194; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_717e22e3139df194 ON public.etudiant USING btree (promotion_id);


--
-- Name: idx_765ae0c9b7942f03; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_765ae0c9b7942f03 ON public.absence USING btree (cour_id);


--
-- Name: idx_765ae0c9ddeab1a3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_765ae0c9ddeab1a3 ON public.absence USING btree (etudiant_id);


--
-- Name: idx_9014574a6c2a0a71; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_9014574a6c2a0a71 ON public.matiere USING btree (enseigne_id);


--
-- Name: idx_a3747088642b8210; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_a3747088642b8210 ON public.admin_enseigne USING btree (admin_id);


--
-- Name: idx_a37470886c2a0a71; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_a37470886c2a0a71 ON public.admin_enseigne USING btree (enseigne_id);


--
-- Name: idx_a71f964f139df194; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_a71f964f139df194 ON public.cour USING btree (promotion_id);


--
-- Name: idx_a71f964ff46cd258; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_a71f964ff46cd258 ON public.cour USING btree (matiere_id);


--
-- Name: idx_c11d7dd16c2a0a71; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_c11d7dd16c2a0a71 ON public.promotion USING btree (enseigne_id);


--
-- Name: uniq_880e0d76e7927c74; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_880e0d76e7927c74 ON public.admin USING btree (email);


--
-- Name: etudiant fk_717e22e3139df194; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etudiant
    ADD CONSTRAINT fk_717e22e3139df194 FOREIGN KEY (promotion_id) REFERENCES public.promotion(id);


--
-- Name: absence fk_765ae0c9b7942f03; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.absence
    ADD CONSTRAINT fk_765ae0c9b7942f03 FOREIGN KEY (cour_id) REFERENCES public.cour(id);


--
-- Name: absence fk_765ae0c9ddeab1a3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.absence
    ADD CONSTRAINT fk_765ae0c9ddeab1a3 FOREIGN KEY (etudiant_id) REFERENCES public.etudiant(id);


--
-- Name: matiere fk_9014574a6c2a0a71; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matiere
    ADD CONSTRAINT fk_9014574a6c2a0a71 FOREIGN KEY (enseigne_id) REFERENCES public.enseigne(id);


--
-- Name: admin_enseigne fk_a3747088642b8210; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enseigne
    ADD CONSTRAINT fk_a3747088642b8210 FOREIGN KEY (admin_id) REFERENCES public.admin(id) ON DELETE CASCADE;


--
-- Name: admin_enseigne fk_a37470886c2a0a71; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_enseigne
    ADD CONSTRAINT fk_a37470886c2a0a71 FOREIGN KEY (enseigne_id) REFERENCES public.enseigne(id) ON DELETE CASCADE;


--
-- Name: cour fk_a71f964f139df194; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cour
    ADD CONSTRAINT fk_a71f964f139df194 FOREIGN KEY (promotion_id) REFERENCES public.promotion(id);


--
-- Name: cour fk_a71f964ff46cd258; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cour
    ADD CONSTRAINT fk_a71f964ff46cd258 FOREIGN KEY (matiere_id) REFERENCES public.matiere(id);


--
-- Name: promotion fk_c11d7dd16c2a0a71; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT fk_c11d7dd16c2a0a71 FOREIGN KEY (enseigne_id) REFERENCES public.enseigne(id);


--
-- PostgreSQL database dump complete
--

