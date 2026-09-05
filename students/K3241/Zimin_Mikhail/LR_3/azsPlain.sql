--
-- PostgreSQL database dump
--

\restrict npmPywvKOGczmdxupWvXknwvnYVV5lFtpl8zoKvadeJybdPQjwnZ1EB0iuooqN2

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.1

-- Started on 2026-04-13 21:38:49

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

--
-- TOC entry 5133 (class 1262 OID 17379)
-- Name: azs; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE azs WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE azs OWNER TO postgres;

\unrestrict npmPywvKOGczmdxupWvXknwvnYVV5lFtpl8zoKvadeJybdPQjwnZ1EB0iuooqN2
\connect azs
\restrict npmPywvKOGczmdxupWvXknwvnYVV5lFtpl8zoKvadeJybdPQjwnZ1EB0iuooqN2

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

--
-- TOC entry 6 (class 2615 OID 17380)
-- Name: azs; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA azs;


ALTER SCHEMA azs OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 17538)
-- Name: edinitsa_izmereniya; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.edinitsa_izmereniya (
    id_edinitsy_izmereniya integer NOT NULL,
    oboznachenie character varying(10) NOT NULL,
    naimenovanie character varying(20) NOT NULL
);


ALTER TABLE azs.edinitsa_izmereniya OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17537)
-- Name: edinitsa_izmereniya_id_edinitsy_izmereniya_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.edinitsa_izmereniya_id_edinitsy_izmereniya_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.edinitsa_izmereniya_id_edinitsy_izmereniya_seq OWNER TO postgres;

--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 224
-- Name: edinitsa_izmereniya_id_edinitsy_izmereniya_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.edinitsa_izmereniya_id_edinitsy_izmereniya_seq OWNED BY azs.edinitsa_izmereniya.id_edinitsy_izmereniya;


--
-- TOC entry 237 (class 1259 OID 17629)
-- Name: karta_schet; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.karta_schet (
    id_karty integer NOT NULL,
    id_klienta integer NOT NULL,
    nomer_karty integer NOT NULL,
    data_nachala date NOT NULL,
    status_karty character varying(20),
    skidka_protsentov integer,
    summa_na_schete integer,
    data_okonchaniya date,
    CONSTRAINT chk_daty_karty CHECK (((data_okonchaniya IS NULL) OR (data_okonchaniya > data_nachala))),
    CONSTRAINT chk_nomer_karty CHECK ((nomer_karty > 0)),
    CONSTRAINT chk_skidka CHECK (((skidka_protsentov >= 0) AND (skidka_protsentov <= 100))),
    CONSTRAINT chk_summa CHECK ((summa_na_schete >= 0))
);


ALTER TABLE azs.karta_schet OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 17628)
-- Name: karta_schet_id_karty_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.karta_schet_id_karty_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.karta_schet_id_karty_seq OWNER TO postgres;

--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 236
-- Name: karta_schet_id_karty_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.karta_schet_id_karty_seq OWNED BY azs.karta_schet.id_karty;


--
-- TOC entry 235 (class 1259 OID 17620)
-- Name: klient; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.klient (
    id_klienta integer NOT NULL,
    fio character varying(80) NOT NULL,
    telefon character varying(20),
    tip_klienta character varying(20),
    adres character varying(100)
);


ALTER TABLE azs.klient OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17619)
-- Name: klient_id_klienta_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.klient_id_klienta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.klient_id_klienta_seq OWNER TO postgres;

--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 234
-- Name: klient_id_klienta_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.klient_id_klienta_seq OWNED BY azs.klient.id_klienta;


--
-- TOC entry 221 (class 1259 OID 17519)
-- Name: postavshchik; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.postavshchik (
    id_postavshchika integer NOT NULL,
    telefon character varying(20) NOT NULL,
    yuridicheskiy_adres character varying(100),
    nazvanie_firmy character varying(50) NOT NULL,
    inn character varying(20),
    CONSTRAINT chk_inn CHECK ((length((inn)::text) >= 10))
);


ALTER TABLE azs.postavshchik OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17518)
-- Name: postavshchik_id_postavshchika_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.postavshchik_id_postavshchika_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.postavshchik_id_postavshchika_seq OWNER TO postgres;

--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 220
-- Name: postavshchik_id_postavshchika_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.postavshchik_id_postavshchika_seq OWNED BY azs.postavshchik.id_postavshchika;


--
-- TOC entry 227 (class 1259 OID 17548)
-- Name: prodavaemoe_toplivo; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.prodavaemoe_toplivo (
    kod_topliva integer NOT NULL,
    naimenovanie character varying(50) NOT NULL,
    id_tipa_topliva integer NOT NULL,
    oktanovoe_chislo integer,
    id_edinitsy_izmereniya integer NOT NULL,
    CONSTRAINT chk_oktanovoe_chislo CHECK (((oktanovoe_chislo IS NULL) OR ((oktanovoe_chislo >= 80) AND (oktanovoe_chislo <= 100))))
);


ALTER TABLE azs.prodavaemoe_toplivo OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17547)
-- Name: prodavaemoe_toplivo_kod_topliva_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.prodavaemoe_toplivo_kod_topliva_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.prodavaemoe_toplivo_kod_topliva_seq OWNER TO postgres;

--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 226
-- Name: prodavaemoe_toplivo_kod_topliva_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.prodavaemoe_toplivo_kod_topliva_seq OWNED BY azs.prodavaemoe_toplivo.kod_topliva;


--
-- TOC entry 239 (class 1259 OID 17645)
-- Name: prodazha; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.prodazha (
    id_prodazhi integer NOT NULL,
    kod_topliva integer NOT NULL,
    id_karty integer NOT NULL,
    kolichestvo_topliva integer NOT NULL,
    summa_spisaniya integer NOT NULL,
    data_vremya_prodazhi timestamp without time zone NOT NULL,
    ostatok_posle_operatsii integer,
    CONSTRAINT chk_kolichestvo_topliva CHECK ((kolichestvo_topliva > 0)),
    CONSTRAINT chk_ostatok CHECK ((ostatok_posle_operatsii >= 0)),
    CONSTRAINT chk_summa_spisaniya CHECK ((summa_spisaniya > 0))
);


ALTER TABLE azs.prodazha OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17644)
-- Name: prodazha_id_prodazhi_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.prodazha_id_prodazhi_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.prodazha_id_prodazhi_seq OWNER TO postgres;

--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 238
-- Name: prodazha_id_prodazhi_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.prodazha_id_prodazhi_seq OWNED BY azs.prodazha.id_prodazhi;


--
-- TOC entry 223 (class 1259 OID 17529)
-- Name: tip_topliva; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.tip_topliva (
    id_tipa_topliva integer NOT NULL,
    naimenovanie_tipa character varying(30) NOT NULL
);


ALTER TABLE azs.tip_topliva OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17528)
-- Name: tip_topliva_id_tipa_topliva_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.tip_topliva_id_tipa_topliva_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.tip_topliva_id_tipa_topliva_seq OWNER TO postgres;

--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 222
-- Name: tip_topliva_id_tipa_topliva_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.tip_topliva_id_tipa_topliva_seq OWNED BY azs.tip_topliva.id_tipa_topliva;


--
-- TOC entry 231 (class 1259 OID 17591)
-- Name: tip_zapravki; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.tip_zapravki (
    id_tipa_zapravki integer NOT NULL,
    naimenovanie_tipa character varying(30) NOT NULL,
    opisanie character varying(100)
);


ALTER TABLE azs.tip_zapravki OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17590)
-- Name: tip_zapravki_id_tipa_zapravki_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.tip_zapravki_id_tipa_zapravki_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.tip_zapravki_id_tipa_zapravki_seq OWNER TO postgres;

--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 230
-- Name: tip_zapravki_id_tipa_zapravki_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.tip_zapravki_id_tipa_zapravki_seq OWNED BY azs.tip_zapravki.id_tipa_zapravki;


--
-- TOC entry 229 (class 1259 OID 17569)
-- Name: tsena_topliva; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.tsena_topliva (
    id_tseny integer NOT NULL,
    id_postavshchika integer NOT NULL,
    tsena_za_edinitsu integer NOT NULL,
    data_nachala date NOT NULL,
    kod_topliva integer NOT NULL,
    data_okonchaniya date,
    CONSTRAINT chk_daty_tseny CHECK (((data_okonchaniya IS NULL) OR (data_okonchaniya > data_nachala))),
    CONSTRAINT chk_tsena_polozhitelnaya CHECK ((tsena_za_edinitsu > 0))
);


ALTER TABLE azs.tsena_topliva OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17568)
-- Name: tsena_topliva_id_tseny_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.tsena_topliva_id_tseny_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.tsena_topliva_id_tseny_seq OWNER TO postgres;

--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 228
-- Name: tsena_topliva_id_tseny_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.tsena_topliva_id_tseny_seq OWNED BY azs.tsena_topliva.id_tseny;


--
-- TOC entry 233 (class 1259 OID 17600)
-- Name: zaprava; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.zaprava (
    kod_zapravki integer NOT NULL,
    id_postavshchika integer NOT NULL,
    rezhim_raboty character varying(50),
    adres_zapravki character varying(100),
    id_tipa_zapravki integer NOT NULL,
    kolichestvo_kolonok integer,
    CONSTRAINT chk_kolichestvo_kolonok CHECK ((kolichestvo_kolonok > 0))
);


ALTER TABLE azs.zaprava OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17599)
-- Name: zaprava_kod_zapravki_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.zaprava_kod_zapravki_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.zaprava_kod_zapravki_seq OWNER TO postgres;

--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 232
-- Name: zaprava_kod_zapravki_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.zaprava_kod_zapravki_seq OWNED BY azs.zaprava.kod_zapravki;


--
-- TOC entry 4904 (class 2604 OID 17541)
-- Name: edinitsa_izmereniya id_edinitsy_izmereniya; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.edinitsa_izmereniya ALTER COLUMN id_edinitsy_izmereniya SET DEFAULT nextval('azs.edinitsa_izmereniya_id_edinitsy_izmereniya_seq'::regclass);


--
-- TOC entry 4910 (class 2604 OID 17632)
-- Name: karta_schet id_karty; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.karta_schet ALTER COLUMN id_karty SET DEFAULT nextval('azs.karta_schet_id_karty_seq'::regclass);


--
-- TOC entry 4909 (class 2604 OID 17623)
-- Name: klient id_klienta; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.klient ALTER COLUMN id_klienta SET DEFAULT nextval('azs.klient_id_klienta_seq'::regclass);


--
-- TOC entry 4902 (class 2604 OID 17522)
-- Name: postavshchik id_postavshchika; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.postavshchik ALTER COLUMN id_postavshchika SET DEFAULT nextval('azs.postavshchik_id_postavshchika_seq'::regclass);


--
-- TOC entry 4905 (class 2604 OID 17551)
-- Name: prodavaemoe_toplivo kod_topliva; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodavaemoe_toplivo ALTER COLUMN kod_topliva SET DEFAULT nextval('azs.prodavaemoe_toplivo_kod_topliva_seq'::regclass);


--
-- TOC entry 4911 (class 2604 OID 17648)
-- Name: prodazha id_prodazhi; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodazha ALTER COLUMN id_prodazhi SET DEFAULT nextval('azs.prodazha_id_prodazhi_seq'::regclass);


--
-- TOC entry 4903 (class 2604 OID 17532)
-- Name: tip_topliva id_tipa_topliva; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tip_topliva ALTER COLUMN id_tipa_topliva SET DEFAULT nextval('azs.tip_topliva_id_tipa_topliva_seq'::regclass);


--
-- TOC entry 4907 (class 2604 OID 17594)
-- Name: tip_zapravki id_tipa_zapravki; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tip_zapravki ALTER COLUMN id_tipa_zapravki SET DEFAULT nextval('azs.tip_zapravki_id_tipa_zapravki_seq'::regclass);


--
-- TOC entry 4906 (class 2604 OID 17572)
-- Name: tsena_topliva id_tseny; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tsena_topliva ALTER COLUMN id_tseny SET DEFAULT nextval('azs.tsena_topliva_id_tseny_seq'::regclass);


--
-- TOC entry 4908 (class 2604 OID 17603)
-- Name: zaprava kod_zapravki; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.zaprava ALTER COLUMN kod_zapravki SET DEFAULT nextval('azs.zaprava_kod_zapravki_seq'::regclass);


--
-- TOC entry 5113 (class 0 OID 17538)
-- Dependencies: 225
-- Data for Name: edinitsa_izmereniya; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.edinitsa_izmereniya (id_edinitsy_izmereniya, oboznachenie, naimenovanie) FROM stdin;
1	л	литр
2	кг	килограмм
3	м³	кубический метр
\.


--
-- TOC entry 5125 (class 0 OID 17629)
-- Dependencies: 237
-- Data for Name: karta_schet; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.karta_schet (id_karty, id_klienta, nomer_karty, data_nachala, status_karty, skidka_protsentov, summa_na_schete, data_okonchaniya) FROM stdin;
1	1	1001	2024-01-15	Активна	5	5000	\N
2	2	1002	2024-02-01	Активна	3	3000	\N
3	3	1003	2024-01-10	Активна	10	50000	\N
4	4	1004	2024-03-01	Активна	2	2000	\N
\.


--
-- TOC entry 5123 (class 0 OID 17620)
-- Dependencies: 235
-- Data for Name: klient; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.klient (id_klienta, fio, telefon, tip_klienta, adres) FROM stdin;
1	Иванов Иван Иванович	+7-911-111-11-11	Физическое лицо	г. Москва, ул. Пушкина, д. 1, кв. 10
2	Петров Петр Петрович	+7-922-222-22-22	Физическое лицо	г. Санкт-Петербург, ул. Гоголя, д. 5
3	ООО "Транспорт"	+7-343-333-33-33	Юридическое лицо	г. Екатеринбург, ул. Ленина, д. 20
4	Сидорова Мария Ивановна	+7-900-444-44-44	Физическое лицо	г. Москва, пр. Мира, д. 15, кв. 42
\.


--
-- TOC entry 5109 (class 0 OID 17519)
-- Dependencies: 221
-- Data for Name: postavshchik; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.postavshchik (id_postavshchika, telefon, yuridicheskiy_adres, nazvanie_firmy, inn) FROM stdin;
1	+7-495-123-45-67	г. Москва, ул. Ленина, д. 10	Роснефть	1234567890
2	+7-812-987-65-43	г. Санкт-Петербург, пр. Невский, д. 25	Лукойл	0987654321
3	+7-343-555-44-33	г. Екатеринбург, ул. Малышева, д. 5	Газпром нефть	1122334455
\.


--
-- TOC entry 5115 (class 0 OID 17548)
-- Dependencies: 227
-- Data for Name: prodavaemoe_toplivo; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.prodavaemoe_toplivo (kod_topliva, naimenovanie, id_tipa_topliva, oktanovoe_chislo, id_edinitsy_izmereniya) FROM stdin;
1	АИ-92	1	92	1
2	АИ-95	1	95	1
3	АИ-98	1	98	1
4	Дизель	2	\N	1
5	Пропан	3	\N	1
6	Электричество	4	\N	1
\.


--
-- TOC entry 5127 (class 0 OID 17645)
-- Dependencies: 239
-- Data for Name: prodazha; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.prodazha (id_prodazhi, kod_topliva, id_karty, kolichestvo_topliva, summa_spisaniya, data_vremya_prodazhi, ostatok_posle_operatsii) FROM stdin;
1	2	1	40	2090	2024-03-15 10:30:00	2910
2	1	2	30	1470	2024-03-15 12:15:00	1530
3	3	1	20	1140	2024-03-16 08:45:00	1770
4	2	3	500	26250	2024-03-16 14:20:00	23750
5	4	4	50	1470	2024-03-17 09:00:00	530
6	1	1	25	1188	2024-03-17 16:30:00	582
\.


--
-- TOC entry 5111 (class 0 OID 17529)
-- Dependencies: 223
-- Data for Name: tip_topliva; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.tip_topliva (id_tipa_topliva, naimenovanie_tipa) FROM stdin;
1	Бензин
2	Дизельное топливо
3	Газ
4	Электричество
\.


--
-- TOC entry 5119 (class 0 OID 17591)
-- Dependencies: 231
-- Data for Name: tip_zapravki; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.tip_zapravki (id_tipa_zapravki, naimenovanie_tipa, opisanie) FROM stdin;
1	АЗС	Автомобильная заправочная станция
2	АГЗС	Автомобильная газозаправочная станция
3	Электрозаправка	Станция зарядки электромобилей
\.


--
-- TOC entry 5117 (class 0 OID 17569)
-- Dependencies: 229
-- Data for Name: tsena_topliva; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.tsena_topliva (id_tseny, id_postavshchika, tsena_za_edinitsu, data_nachala, kod_topliva, data_okonchaniya) FROM stdin;
1	1	50	2024-01-01	1	\N
2	1	55	2024-01-01	2	\N
3	1	60	2024-01-01	3	\N
4	2	52	2024-01-01	1	\N
5	2	57	2024-01-01	2	\N
6	3	30	2024-01-01	4	\N
\.


--
-- TOC entry 5121 (class 0 OID 17600)
-- Dependencies: 233
-- Data for Name: zaprava; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.zaprava (kod_zapravki, id_postavshchika, rezhim_raboty, adres_zapravki, id_tipa_zapravki, kolichestvo_kolonok) FROM stdin;
1	1	24/7	г. Москва, МКАД, 15 км	1	8
2	1	06:00-23:00	г. Москва, ул. Тверская, д. 50	1	4
3	2	24/7	г. Санкт-Петербург, КАД, 10 км	1	10
4	3	07:00-22:00	г. Екатеринбург, ул. Куйбышева, д. 30	2	3
\.


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 224
-- Name: edinitsa_izmereniya_id_edinitsy_izmereniya_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.edinitsa_izmereniya_id_edinitsy_izmereniya_seq', 3, true);


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 236
-- Name: karta_schet_id_karty_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.karta_schet_id_karty_seq', 4, true);


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 234
-- Name: klient_id_klienta_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.klient_id_klienta_seq', 4, true);


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 220
-- Name: postavshchik_id_postavshchika_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.postavshchik_id_postavshchika_seq', 3, true);


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 226
-- Name: prodavaemoe_toplivo_kod_topliva_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.prodavaemoe_toplivo_kod_topliva_seq', 6, true);


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 238
-- Name: prodazha_id_prodazhi_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.prodazha_id_prodazhi_seq', 6, true);


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 222
-- Name: tip_topliva_id_tipa_topliva_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.tip_topliva_id_tipa_topliva_seq', 4, true);


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 230
-- Name: tip_zapravki_id_tipa_zapravki_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.tip_zapravki_id_tipa_zapravki_seq', 3, true);


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 228
-- Name: tsena_topliva_id_tseny_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.tsena_topliva_id_tseny_seq', 6, true);


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 232
-- Name: zaprava_kod_zapravki_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.zaprava_kod_zapravki_seq', 4, true);


--
-- TOC entry 4933 (class 2606 OID 17546)
-- Name: edinitsa_izmereniya edinitsa_izmereniya_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.edinitsa_izmereniya
    ADD CONSTRAINT edinitsa_izmereniya_pkey PRIMARY KEY (id_edinitsy_izmereniya);


--
-- TOC entry 4947 (class 2606 OID 17638)
-- Name: karta_schet karta_schet_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.karta_schet
    ADD CONSTRAINT karta_schet_pkey PRIMARY KEY (id_karty);


--
-- TOC entry 4945 (class 2606 OID 17627)
-- Name: klient klient_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.klient
    ADD CONSTRAINT klient_pkey PRIMARY KEY (id_klienta);


--
-- TOC entry 4925 (class 2606 OID 17527)
-- Name: postavshchik postavshchik_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.postavshchik
    ADD CONSTRAINT postavshchik_pkey PRIMARY KEY (id_postavshchika);


--
-- TOC entry 4937 (class 2606 OID 17557)
-- Name: prodavaemoe_toplivo prodavaemoe_toplivo_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodavaemoe_toplivo
    ADD CONSTRAINT prodavaemoe_toplivo_pkey PRIMARY KEY (kod_topliva);


--
-- TOC entry 4951 (class 2606 OID 17656)
-- Name: prodazha prodazha_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodazha
    ADD CONSTRAINT prodazha_pkey PRIMARY KEY (id_prodazhi);


--
-- TOC entry 4929 (class 2606 OID 17536)
-- Name: tip_topliva tip_topliva_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tip_topliva
    ADD CONSTRAINT tip_topliva_pkey PRIMARY KEY (id_tipa_topliva);


--
-- TOC entry 4941 (class 2606 OID 17598)
-- Name: tip_zapravki tip_zapravki_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tip_zapravki
    ADD CONSTRAINT tip_zapravki_pkey PRIMARY KEY (id_tipa_zapravki);


--
-- TOC entry 4939 (class 2606 OID 17579)
-- Name: tsena_topliva tsena_topliva_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tsena_topliva
    ADD CONSTRAINT tsena_topliva_pkey PRIMARY KEY (id_tseny);


--
-- TOC entry 4927 (class 2606 OID 17683)
-- Name: postavshchik uk_inn; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.postavshchik
    ADD CONSTRAINT uk_inn UNIQUE (inn);


--
-- TOC entry 4931 (class 2606 OID 17685)
-- Name: tip_topliva uk_naimenovanie_tipa; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tip_topliva
    ADD CONSTRAINT uk_naimenovanie_tipa UNIQUE (naimenovanie_tipa);


--
-- TOC entry 4949 (class 2606 OID 17681)
-- Name: karta_schet uk_nomer_karty; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.karta_schet
    ADD CONSTRAINT uk_nomer_karty UNIQUE (nomer_karty);


--
-- TOC entry 4935 (class 2606 OID 17687)
-- Name: edinitsa_izmereniya uk_oboznachenie; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.edinitsa_izmereniya
    ADD CONSTRAINT uk_oboznachenie UNIQUE (oboznachenie);


--
-- TOC entry 4943 (class 2606 OID 17608)
-- Name: zaprava zaprava_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.zaprava
    ADD CONSTRAINT zaprava_pkey PRIMARY KEY (kod_zapravki);


--
-- TOC entry 4958 (class 2606 OID 17639)
-- Name: karta_schet fk_karta_klient; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.karta_schet
    ADD CONSTRAINT fk_karta_klient FOREIGN KEY (id_klienta) REFERENCES azs.klient(id_klienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4959 (class 2606 OID 17662)
-- Name: prodazha fk_prodazha_karta; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodazha
    ADD CONSTRAINT fk_prodazha_karta FOREIGN KEY (id_karty) REFERENCES azs.karta_schet(id_karty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4960 (class 2606 OID 17657)
-- Name: prodazha fk_prodazha_toplivo; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodazha
    ADD CONSTRAINT fk_prodazha_toplivo FOREIGN KEY (kod_topliva) REFERENCES azs.prodavaemoe_toplivo(kod_topliva) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4952 (class 2606 OID 17563)
-- Name: prodavaemoe_toplivo fk_toplivo_edinitsa; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodavaemoe_toplivo
    ADD CONSTRAINT fk_toplivo_edinitsa FOREIGN KEY (id_edinitsy_izmereniya) REFERENCES azs.edinitsa_izmereniya(id_edinitsy_izmereniya) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4953 (class 2606 OID 17558)
-- Name: prodavaemoe_toplivo fk_toplivo_tip; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodavaemoe_toplivo
    ADD CONSTRAINT fk_toplivo_tip FOREIGN KEY (id_tipa_topliva) REFERENCES azs.tip_topliva(id_tipa_topliva) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4954 (class 2606 OID 17580)
-- Name: tsena_topliva fk_tsena_postavshchik; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tsena_topliva
    ADD CONSTRAINT fk_tsena_postavshchik FOREIGN KEY (id_postavshchika) REFERENCES azs.postavshchik(id_postavshchika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4955 (class 2606 OID 17585)
-- Name: tsena_topliva fk_tsena_toplivo; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tsena_topliva
    ADD CONSTRAINT fk_tsena_toplivo FOREIGN KEY (kod_topliva) REFERENCES azs.prodavaemoe_toplivo(kod_topliva) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4956 (class 2606 OID 17609)
-- Name: zaprava fk_zaprava_postavshchik; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.zaprava
    ADD CONSTRAINT fk_zaprava_postavshchik FOREIGN KEY (id_postavshchika) REFERENCES azs.postavshchik(id_postavshchika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4957 (class 2606 OID 17614)
-- Name: zaprava fk_zaprava_tip; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.zaprava
    ADD CONSTRAINT fk_zaprava_tip FOREIGN KEY (id_tipa_zapravki) REFERENCES azs.tip_zapravki(id_tipa_zapravki) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2026-04-13 21:38:49

--
-- PostgreSQL database dump complete
--

\unrestrict npmPywvKOGczmdxupWvXknwvnYVV5lFtpl8zoKvadeJybdPQjwnZ1EB0iuooqN2

