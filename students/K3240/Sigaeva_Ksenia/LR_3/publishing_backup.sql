--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2026-04-23 23:42:47

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
-- TOC entry 246 (class 1259 OID 16883)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_id bigint NOT NULL,
    date_creation date NOT NULL,
    date_deposit date NOT NULL,
    account_number numeric(20,0) NOT NULL,
    status character varying(10) NOT NULL,
    contract_id bigint NOT NULL,
    CONSTRAINT account_number CHECK ((account_number = floor(account_number)))
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16882)
-- Name: accounts_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accounts_account_id_seq OWNER TO postgres;

--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 245
-- Name: accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_id_seq OWNED BY public.accounts.account_id;


--
-- TOC entry 228 (class 1259 OID 16555)
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    author_id bigint NOT NULL,
    surname character varying(20) NOT NULL,
    name character varying(20) NOT NULL,
    middle_name character varying(25),
    email character varying(30) NOT NULL
);


ALTER TABLE public.authors OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16554)
-- Name: authors_author_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authors_author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authors_author_id_seq OWNER TO postgres;

--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 227
-- Name: authors_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authors_author_id_seq OWNED BY public.authors.author_id;


--
-- TOC entry 231 (class 1259 OID 16563)
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    book_id bigint NOT NULL,
    title character varying(100) NOT NULL,
    first_edition_year bigint,
    category_id bigint NOT NULL
);


ALTER TABLE public.books OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16784)
-- Name: books_and_authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books_and_authors (
    books_and_authors_id bigint NOT NULL,
    book_id bigint NOT NULL,
    author_id bigint NOT NULL,
    num_ord bigint NOT NULL
);


ALTER TABLE public.books_and_authors OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16783)
-- Name: books_and_authors_books_and_authors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_and_authors_books_and_authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_and_authors_books_and_authors_id_seq OWNER TO postgres;

--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 237
-- Name: books_and_authors_books_and_authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_and_authors_books_and_authors_id_seq OWNED BY public.books_and_authors.books_and_authors_id;


--
-- TOC entry 229 (class 1259 OID 16561)
-- Name: books_book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_book_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_book_id_seq OWNER TO postgres;

--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 229
-- Name: books_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_book_id_seq OWNED BY public.books.book_id;


--
-- TOC entry 230 (class 1259 OID 16562)
-- Name: books_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_category_id_seq OWNER TO postgres;

--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 230
-- Name: books_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_category_id_seq OWNED BY public.books.category_id;


--
-- TOC entry 226 (class 1259 OID 16546)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id bigint NOT NULL,
    category_name character varying NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16545)
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_category_id_seq OWNER TO postgres;

--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 225
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- TOC entry 236 (class 1259 OID 16644)
-- Name: circulations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.circulations (
    number_of_copies bigint NOT NULL,
    requirement_id bigint NOT NULL,
    editions_id bigint NOT NULL,
    circulation_id bigint NOT NULL,
    copies_in_remain bigint NOT NULL,
    CONSTRAINT number_of_copies CHECK ((number_of_copies > 0))
);


ALTER TABLE public.circulations OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16854)
-- Name: circulations_circulation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.circulations_circulation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.circulations_circulation_id_seq OWNER TO postgres;

--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 244
-- Name: circulations_circulation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.circulations_circulation_id_seq OWNED BY public.circulations.circulation_id;


--
-- TOC entry 239 (class 1259 OID 16800)
-- Name: circulations_editions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.circulations ALTER COLUMN editions_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.circulations_editions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 16843)
-- Name: contract_content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contract_content (
    contract_content_id bigint NOT NULL,
    contract_id bigint NOT NULL,
    circulation_id bigint NOT NULL,
    number_of_books bigint NOT NULL,
    period bigint NOT NULL
);


ALTER TABLE public.contract_content OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16842)
-- Name: contract_content_contract_content_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contract_content_contract_content_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contract_content_contract_content_id_seq OWNER TO postgres;

--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 242
-- Name: contract_content_contract_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contract_content_contract_content_id_seq OWNED BY public.contract_content.contract_content_id;


--
-- TOC entry 222 (class 1259 OID 16519)
-- Name: contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contracts (
    contract_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    manager_id bigint NOT NULL,
    date_creation date NOT NULL,
    status character varying(13) NOT NULL,
    date_fulfillment date NOT NULL,
    date_completion date
);


ALTER TABLE public.contracts OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16518)
-- Name: contracts_contract_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contracts_contract_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contracts_contract_id_seq OWNER TO postgres;

--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 221
-- Name: contracts_contract_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contracts_contract_id_seq OWNED BY public.contracts.contract_id;


--
-- TOC entry 220 (class 1259 OID 16510)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id bigint NOT NULL,
    surname character varying(20) NOT NULL,
    name character varying(20) NOT NULL,
    middle_name character varying(25),
    phone_number character varying NOT NULL,
    email character varying(30) NOT NULL,
    address character varying(100) NOT NULL
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16509)
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;

--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 219
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- TOC entry 233 (class 1259 OID 16577)
-- Name: editions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editions (
    editions_id bigint NOT NULL,
    contract_id bigint NOT NULL,
    isbn numeric(13,0) NOT NULL,
    book_id bigint NOT NULL
);


ALTER TABLE public.editions OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16821)
-- Name: editions_and_editors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editions_and_editors (
    editions_and_editors_id bigint NOT NULL,
    editions_id bigint NOT NULL,
    editor_id bigint NOT NULL
);


ALTER TABLE public.editions_and_editors OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16820)
-- Name: editions_and_editors_editions_and_editors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.editions_and_editors_editions_and_editors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.editions_and_editors_editions_and_editors_id_seq OWNER TO postgres;

--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 240
-- Name: editions_and_editors_editions_and_editors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.editions_and_editors_editions_and_editors_id_seq OWNED BY public.editions_and_editors.editions_and_editors_id;


--
-- TOC entry 232 (class 1259 OID 16576)
-- Name: editions_editions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.editions_editions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.editions_editions_id_seq OWNER TO postgres;

--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 232
-- Name: editions_editions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.editions_editions_id_seq OWNED BY public.editions.editions_id;


--
-- TOC entry 218 (class 1259 OID 16495)
-- Name: editors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editors (
    editor_id bigint NOT NULL,
    surname character varying(20) NOT NULL,
    name character varying(20) NOT NULL,
    middle_name character varying(25),
    email character varying(30) NOT NULL,
    "position" character varying(7) NOT NULL,
    CONSTRAINT "position" CHECK ((("position")::text = ANY ((ARRAY['младший'::character varying, 'средний'::character varying, 'главный'::character varying])::text[])))
);


ALTER TABLE public.editors OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16494)
-- Name: editors_editor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.editors_editor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.editors_editor_id_seq OWNER TO postgres;

--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 217
-- Name: editors_editor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.editors_editor_id_seq OWNED BY public.editors.editor_id;


--
-- TOC entry 224 (class 1259 OID 16538)
-- Name: managers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.managers (
    manager_id bigint NOT NULL,
    name character varying(20) NOT NULL,
    surname character varying(20) NOT NULL,
    middle_name character varying(25),
    email character varying(30) NOT NULL,
    number_of_contracts bigint NOT NULL,
    CONSTRAINT number_of_contracts CHECK ((number_of_contracts > 0))
);


ALTER TABLE public.managers OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16537)
-- Name: managers_manager_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.managers_manager_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.managers_manager_id_seq OWNER TO postgres;

--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 223
-- Name: managers_manager_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.managers_manager_id_seq OWNED BY public.managers.manager_id;


--
-- TOC entry 235 (class 1259 OID 16594)
-- Name: requirements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requirements (
    requirement_id bigint NOT NULL,
    binding character varying(11) NOT NULL,
    pages_number bigint NOT NULL,
    pictures boolean NOT NULL,
    editions_id bigint NOT NULL,
    CONSTRAINT binding CHECK (((binding)::text = ANY ((ARRAY['мягкий'::character varying, 'твердый'::character varying, 'пружинный'::character varying, 'кольцевой'::character varying, 'французский'::character varying])::text[]))),
    CONSTRAINT pages_number CHECK ((pages_number > 0)),
    CONSTRAINT price CHECK ((editions_id > 0))
);


ALTER TABLE public.requirements OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16593)
-- Name: requirements_requirement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.requirements_requirement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requirements_requirement_id_seq OWNER TO postgres;

--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 234
-- Name: requirements_requirement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.requirements_requirement_id_seq OWNED BY public.requirements.requirement_id;


--
-- TOC entry 4823 (class 2604 OID 16886)
-- Name: accounts account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN account_id SET DEFAULT nextval('public.accounts_account_id_seq'::regclass);


--
-- TOC entry 4814 (class 2604 OID 16558)
-- Name: authors author_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors ALTER COLUMN author_id SET DEFAULT nextval('public.authors_author_id_seq'::regclass);


--
-- TOC entry 4815 (class 2604 OID 16566)
-- Name: books book_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN book_id SET DEFAULT nextval('public.books_book_id_seq'::regclass);


--
-- TOC entry 4816 (class 2604 OID 16567)
-- Name: books category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN category_id SET DEFAULT nextval('public.books_category_id_seq'::regclass);


--
-- TOC entry 4820 (class 2604 OID 16787)
-- Name: books_and_authors books_and_authors_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_and_authors ALTER COLUMN books_and_authors_id SET DEFAULT nextval('public.books_and_authors_books_and_authors_id_seq'::regclass);


--
-- TOC entry 4813 (class 2604 OID 16549)
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- TOC entry 4819 (class 2604 OID 16855)
-- Name: circulations circulation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circulations ALTER COLUMN circulation_id SET DEFAULT nextval('public.circulations_circulation_id_seq'::regclass);


--
-- TOC entry 4822 (class 2604 OID 16846)
-- Name: contract_content contract_content_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_content ALTER COLUMN contract_content_id SET DEFAULT nextval('public.contract_content_contract_content_id_seq'::regclass);


--
-- TOC entry 4811 (class 2604 OID 16522)
-- Name: contracts contract_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts ALTER COLUMN contract_id SET DEFAULT nextval('public.contracts_contract_id_seq'::regclass);


--
-- TOC entry 4810 (class 2604 OID 16513)
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- TOC entry 4817 (class 2604 OID 16580)
-- Name: editions editions_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editions ALTER COLUMN editions_id SET DEFAULT nextval('public.editions_editions_id_seq'::regclass);


--
-- TOC entry 4821 (class 2604 OID 16824)
-- Name: editions_and_editors editions_and_editors_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editions_and_editors ALTER COLUMN editions_and_editors_id SET DEFAULT nextval('public.editions_and_editors_editions_and_editors_id_seq'::regclass);


--
-- TOC entry 4809 (class 2604 OID 16498)
-- Name: editors editor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editors ALTER COLUMN editor_id SET DEFAULT nextval('public.editors_editor_id_seq'::regclass);


--
-- TOC entry 4812 (class 2604 OID 16541)
-- Name: managers manager_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.managers ALTER COLUMN manager_id SET DEFAULT nextval('public.managers_manager_id_seq'::regclass);


--
-- TOC entry 4818 (class 2604 OID 16597)
-- Name: requirements requirement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requirements ALTER COLUMN requirement_id SET DEFAULT nextval('public.requirements_requirement_id_seq'::regclass);


--
-- TOC entry 5055 (class 0 OID 16883)
-- Dependencies: 246
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (account_id, date_creation, date_deposit, account_number, status, contract_id) FROM stdin;
51	2024-01-10	2024-03-10	40817810009991004312	оплачен	51
52	2024-01-15	2024-02-20	40817810109991005345	оплачен	52
53	2024-01-20	2024-04-20	40817810209991006378	не оплачен	53
54	2024-01-25	2024-04-25	40817810309991007321	не оплачен	54
55	2024-02-01	2024-04-01	40817810409991008354	оплачен	55
56	2024-02-05	2024-05-05	40817810509991009387	не оплачен	56
57	2024-02-10	2024-05-10	40817810609991010410	не оплачен	57
58	2024-02-15	2024-03-30	40817810709991011443	оплачен	58
59	2024-02-20	2024-05-20	40817810809991012476	не оплачен	59
60	2024-02-25	2024-05-25	40817810909991013509	не оплачен	60
61	2024-03-01	2024-05-01	40702810009991014532	оплачен	61
62	2024-03-05	2024-06-05	40702810109991015565	не оплачен	62
63	2024-03-10	2024-06-10	40702810209991016598	не оплачен	63
64	2024-03-15	2024-04-25	40702810309991017621	оплачен	64
65	2024-03-20	2024-06-20	40702810409991018654	не оплачен	65
66	2024-03-25	2024-06-25	40702810509991019687	не оплачен	66
67	2024-04-01	2024-06-01	40702810609991020710	оплачен	67
68	2024-04-05	2024-07-05	40702810709991021743	не оплачен	68
69	2024-04-10	2024-07-10	40702810809991022776	не оплачен	69
70	2024-04-15	2024-05-30	40702810909991023809	оплачен	70
71	2024-04-20	2024-07-20	40702810009991024832	не оплачен	71
72	2024-04-25	2024-07-25	40702810109991025865	не оплачен	72
73	2024-05-01	2024-06-25	40702810209991026898	оплачен	73
74	2024-05-05	2024-08-05	40702810309991027921	не оплачен	74
75	2024-05-10	2024-08-10	40702810409991028954	не оплачен	75
76	2024-05-15	2024-07-05	40702810509991029987	оплачен	76
77	2024-05-20	2024-08-20	40702810609991031010	не оплачен	77
78	2024-05-25	2024-08-25	40702810709991032043	не оплачен	78
79	2024-06-01	2024-07-20	40702810809991033076	оплачен	79
80	2024-06-05	2024-09-05	40702810909991034109	не оплачен	80
81	2024-06-10	2024-09-10	40817811009991035132	не оплачен	81
82	2024-06-15	2024-08-05	40817811109991036165	оплачен	82
83	2024-06-20	2024-09-20	40817811209991037198	не оплачен	83
84	2024-06-25	2024-09-25	40817811309991038221	не оплачен	84
85	2024-07-01	2024-08-20	40817811409991039254	оплачен	85
86	2024-07-05	2024-10-05	40817811509991040287	не оплачен	86
87	2024-07-10	2024-10-10	40817811609991041310	не оплачен	87
88	2024-07-15	2024-09-05	40817811709991042343	оплачен	88
89	2024-07-20	2024-10-20	40817811809991043376	не оплачен	89
90	2024-07-25	2024-09-15	40802810909991035142	оплачен	90
91	2024-08-01	2024-11-01	40802810009991036164	не оплачен	91
92	2024-08-05	2024-11-05	40802810109991037197	не оплачен	92
93	2024-08-10	2024-10-01	40802810209991037175	оплачен	93
94	2024-08-15	2024-11-15	40802810309991038120	не оплачен	94
95	2024-08-20	2024-11-20	40802810409991039153	не оплачен	95
96	2024-08-25	2024-10-15	40802810509991039208	оплачен	96
97	2024-09-01	2024-12-01	40802810609991040186	не оплачен	97
98	2024-09-05	2024-12-05	40802810709991041219	не оплачен	98
99	2024-09-10	2024-11-01	40802810809991041231	оплачен	99
100	2024-09-15	2024-12-15	40802810909991042242	не оплачен	100
\.


--
-- TOC entry 5037 (class 0 OID 16555)
-- Dependencies: 228
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (author_id, surname, name, middle_name, email) FROM stdin;
1	Иванов	Иван	Иванович	ivanovii@mail.ru
2	Петров	Петр	Петрович	petrovpp@gmail.com
3	Сидоров	Алексей	Владимирович	sidorovav@mail.ru
4	Кузнецова	Елена	Андреевна	kuznetsovaea@gmail.com
5	Смирнов	Дмитрий	Сергеевич	smirnovds@mail.ru
6	Васильева	Ольга	Николаевна	vasilyevaon@gmail.com
7	Попов	Андрей	Михайлович	popovam@mail.ru
8	Соколова	Татьяна	Владимировна	sokolovatv@gmail.com
9	Михайлов	Сергей	Александрович	mikhailovsa@mail.ru
10	Новикова	Ирина	Дмитриевна	novikovaid@gmail.com
11	Федоров	Антон	Павлович	fedorovap@mail.ru
12	Морозова	Светлана	Евгеньевна	morozovase@gmail.com
13	Волков	Максим	Романович	volkovmr@mail.ru
14	Зайцева	Юлия	Васильевна	zaytsevayv@gmail.com
15	Павлов	Григорий	Игоревич	pavlovgi@mail.ru
16	Егорова	Анна	Петровна	egorovaan@gmail.com
17	Семенов	Николай	Викторович	semenovnv@mail.ru
18	Николаева	Мария	Алексеевна	nikolaevama@gmail.com
19	Морозов	Роман	Денисович	morozovrd@mail.ru
20	Александрова	Ксения	Борисовна	aleksandrovakb@gmail.com
21	Григорьев	Леонид	Станиславович	grigorievls@mail.ru
22	Сергеева	Наталья	Ильинична	sergeevar@gmail.com
23	Виноградов	Даниил	Олегович	vinogradovdo@mail.ru
24	Костин	Виталий	Анатольевич	kostinva@gmail.com
25	Баранов	Игорь	Юрьевич	baranoviy@mail.ru
26	Макарова	Евгения	Аркадьевна	makarovaea@gmail.com
27	Давыдов	Тимофей	Валерьевич	davydovtv@mail.ru
28	Тимофеева	Елизавета	Андреевна	timofeevaea@gmail.com
29	Кравцов	Артём	Кириллович	kravtsovak@mail.ru
30	Беляев	Вадим	Евгеньевич	belyaevve@gmail.com
31	Романова	Оксана	Федоровна	romanovaof@mail.ru
32	Комаров	Никита	Максимович	komarovnm@gmail.com
33	Орлова	Виктория	Дмитриевна	orlovavd@mail.ru
34	Жуков	Станислав	Константинович	zhukovsk@mail.ru
35	Крылов	Валерий	Викторович	krylovvv@gmail.com
36	Белова	Снежана	Романовна	belovasr@mail.ru
37	Тарасов	Фёдор	Иванович	tarasovfi@gmail.com
38	Мишина	Валерия	Сергеевна	mishinavs@mail.ru
39	Фокин	Александр	Вячеславович	fokinav@gmail.com
40	Андреева	Полина	Матвеевна	andreevapm@mail.ru
41	Доронин	Евгений	Алексеевич	doroninea@gmail.com
42	Гаврилова	Алина	Игоревна	gavrilovaii@mail.ru
43	Соловьев	Матвей	Андреевич	solovievma@gmail.com
44	Козлова	Алиса	Никитична	kozlova@gmail.com
45	Миронов	Артемий	Павлович	mironovap@mail.ru
46	Фролова	Жанна	Анатольевна	frolovaza@gmail.com
47	Нестеров	Владислав	Робертович	nesterovvr@mail.ru
48	Игнатьев	Борис	Степанович	ignatievbs@gmail.com
49	Константинова	Лидия	Витальевна	konstantinovalv@mail.ru
50	Лавров	Глеб	Александрович	lavrovga@gmail.com
\.


--
-- TOC entry 5040 (class 0 OID 16563)
-- Dependencies: 231
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (book_id, title, first_edition_year, category_id) FROM stdin;
1	Python: полное руководство	2019	1
2	Язык программирования C++	1998	1
3	Java: эффективное программирование	2014	1
4	Современный Go для программистов	2021	1
5	Rust: безопасная разработка	2019	1
6	Функциональное программирование на Scala	2018	1
7	Системное программирование на C	1988	1
8	Умные контракты и блокчейн на Solidity	2021	1
9	PostgreSQL: администрирование и оптимизация	2018	2
10	Базы данных: проектирование и реализация	2015	2
11	SQL для аналитики данных	2017	2
12	MongoDB в действии	2019	2
13	Введение в алгоритмы	1990	3
14	Алгоритмы на Python	2016	3
15	Структуры данных и алгоритмы	2012	3
16	Грокаем алгоритмы	2016	3
17	Веб-разработка на React и Node.js	2021	4
18	Современная веб-разработка	2020	4
19	Разработка на Swift для iOS	2020	5
20	Android: разработка приложений на Kotlin	2019	5
21	Современный JavaScript для профессионалов	2020	6
22	Фронтенд: HTML, CSS и JavaScript	2020	6
23	Vue.js в действии	2020	6
24	React: практический подход	2021	6
25	Бэкенд-разработка на Go	2021	7
26	Разработка API с FastAPI	2021	7
27	Node.js для бэкенда	2020	7
28	Fullstack-разработка на JavaScript	2020	8
29	Машинное обучение для начинающих	2018	9
30	Искусственный интеллект и нейронные сети	2021	9
31	Глубокое обучение на TensorFlow	2020	9
32	Data Science с нуля	2019	10
33	Анализ данных в Excel и Power BI	2018	10
34	Статистика для Data Science	2019	10
35	Основы DevOps и CI/CD	2020	11
36	Docker и Kubernetes для начинающих	2020	11
37	Автоматизация тестирования	2018	11
38	Облачные технологии: AWS для разработчиков	2022	12
39	Облачная инфраструктура: Terraform	2021	12
40	Безопасность веб-приложений	2017	13
41	Кибербезопасность: защита данных	2019	13
42	Криптография и безопасность сетей	2016	13
43	Linux для администраторов	2018	14
44	Администрирование серверов Windows	2019	14
45	Компьютерные сети	2017	15
46	Тестирование ПО: от теории к практике	2019	16
47	Архитектура современных приложений	2020	17
48	Микросервисная архитектура	2020	17
49	Паттерны проектирования	1994	17
50	Clean Code: создание качественного кода	2008	17
51	Управление IT-проектами: Agile и Scrum	2019	18
52	Разработка игр на Unity	2020	19
53	Встраиваемые системы и IoT	2019	20
54	Карьера программиста: от джуна до сеньора	2021	21
55	Собеседования в топовые IT-компании	2019	21
56	Математика для программистов	2015	22
57	Дискретная математика	2017	22
\.


--
-- TOC entry 5047 (class 0 OID 16784)
-- Dependencies: 238
-- Data for Name: books_and_authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books_and_authors (books_and_authors_id, book_id, author_id, num_ord) FROM stdin;
1	1	1	1
2	1	2	2
3	2	3	1
4	2	4	2
5	3	5	1
6	4	6	1
7	4	7	2
8	5	8	1
9	6	9	1
10	6	10	2
11	7	11	1
12	8	12	1
13	8	13	2
14	9	14	1
15	10	15	1
16	10	16	2
17	11	17	1
18	12	18	1
19	12	19	2
20	13	20	1
21	13	21	2
22	13	22	3
23	14	23	1
24	15	24	1
25	15	25	2
26	16	26	1
27	17	27	1
28	17	28	2
29	18	29	1
30	19	30	1
31	20	31	1
32	20	32	2
33	21	33	1
34	22	34	1
35	22	35	2
36	23	36	1
37	24	37	1
38	24	38	2
39	25	39	1
40	26	40	1
41	26	41	2
42	27	42	1
43	28	43	1
44	28	44	2
45	29	45	1
46	30	46	1
47	30	47	2
48	31	48	1
49	32	49	1
50	32	50	2
51	33	1	1
52	33	2	2
53	34	3	1
54	34	4	2
55	35	5	1
56	35	6	2
57	35	7	3
58	36	8	1
59	36	9	2
60	37	10	1
61	38	11	1
62	38	12	2
63	39	13	1
64	40	14	1
65	40	15	2
66	41	16	1
67	41	17	2
68	42	18	1
69	42	19	2
70	42	20	3
71	43	21	1
72	44	22	1
73	44	23	2
74	45	24	1
75	46	25	1
76	46	26	2
77	47	27	1
78	47	28	2
79	48	29	1
80	48	30	2
81	48	31	3
82	49	32	1
83	49	33	2
84	50	34	1
85	51	35	1
86	51	36	2
87	52	37	1
88	52	38	2
89	53	39	1
90	53	40	2
91	53	41	3
92	54	42	1
93	54	43	2
94	55	44	1
95	56	45	1
96	56	46	2
97	57	47	1
98	57	48	2
\.


--
-- TOC entry 5035 (class 0 OID 16546)
-- Dependencies: 226
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, category_name) FROM stdin;
1	Языки программирования
2	Базы данных
3	Алгоритмы и структуры данных
4	Веб-разработка
5	Мобильная разработка
6	Frontend
7	Backend
8	Fullstack-разработка
9	Искусственный интеллект и машинное обучение
10	Анализ данных и Data Science
11	DevOps и администрирование
12	Облачные технологии
13	Кибербезопасность и защита информации
14	Операционные системы
15	Сети и телекоммуникации
16	Тестирование и автоматизация QA
17	Архитектура ПО и паттерны
18	Управление проектами в IT
19	Разработка игр
20	Embedded и IoT (встраиваемые системы)
21	Карьера и собеседования в IT
22	Математика для программистов
\.


--
-- TOC entry 5045 (class 0 OID 16644)
-- Dependencies: 236
-- Data for Name: circulations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.circulations (number_of_copies, requirement_id, editions_id, circulation_id, copies_in_remain) FROM stdin;
5000	1	1	1	1200
3000	2	2	2	500
7000	3	3	3	2500
2000	4	4	4	300
4000	5	5	5	800
8000	6	6	6	3200
1500	7	7	7	200
6000	8	8	8	1800
2500	9	9	9	400
3500	10	10	10	900
5500	11	11	11	1500
2800	12	12	12	600
7500	13	13	13	2800
1800	14	14	14	250
4200	15	15	15	1000
6500	16	16	16	2200
2200	17	17	17	350
4800	18	18	18	1300
3200	19	19	19	700
5200	20	20	20	1600
5800	21	21	21	1700
2600	22	22	22	550
7200	23	23	23	2600
1900	24	24	24	280
4500	25	25	25	1100
6800	26	26	26	2400
2300	27	27	27	380
5000	28	28	28	1400
3400	29	29	29	750
5400	30	30	30	1650
5600	31	31	31	1550
2700	32	32	32	580
7300	33	33	33	2700
1700	34	34	34	220
4300	35	35	35	1050
6700	36	36	36	2350
2400	37	37	37	390
5100	38	38	38	1450
3300	39	39	39	720
5300	40	40	40	1580
5700	41	41	41	1680
2900	42	42	42	620
7400	43	43	43	2750
1600	44	44	44	210
4400	45	45	45	1080
6600	46	46	46	2300
2100	47	47	47	340
4900	48	48	48	1350
3100	49	49	49	690
3800	50	50	50	850
\.


--
-- TOC entry 5052 (class 0 OID 16843)
-- Dependencies: 243
-- Data for Name: contract_content; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contract_content (contract_content_id, contract_id, circulation_id, number_of_books, period) FROM stdin;
1	51	1	5000	90
2	52	2	3000	75
3	53	3	7000	120
4	54	4	2000	45
5	55	5	4000	60
6	56	6	8000	150
7	57	7	1500	30
8	58	8	6000	90
9	59	9	2500	45
10	60	10	3500	60
11	61	11	5500	100
12	62	12	2800	50
13	63	13	7500	120
14	64	14	1800	35
15	65	15	4200	65
16	66	16	6500	110
17	67	17	2200	40
18	68	18	4800	80
19	69	19	3200	55
20	70	20	5200	85
21	71	21	5800	95
22	72	22	2600	45
23	73	23	7200	115
24	74	24	1900	35
25	75	25	4500	70
26	76	26	6800	105
27	77	27	2300	40
28	78	28	5000	80
29	79	29	3400	55
30	80	30	5400	90
31	81	31	5600	90
32	82	32	2700	45
33	83	33	7300	120
34	84	34	1700	30
35	85	35	4300	65
36	86	36	6700	100
37	87	37	2400	40
38	88	38	5100	85
39	89	39	3300	55
40	90	40	5300	85
41	91	41	5700	95
42	92	42	2900	50
43	93	43	7400	120
44	94	44	1600	30
45	95	45	4400	70
46	96	46	6600	105
47	97	47	2100	35
48	98	48	4900	80
49	99	49	3100	50
50	100	50	3800	60
\.


--
-- TOC entry 5031 (class 0 OID 16519)
-- Dependencies: 222
-- Data for Name: contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contracts (contract_id, customer_id, manager_id, date_creation, status, date_fulfillment, date_completion) FROM stdin;
51	1	1	2024-01-10	закрыт	2024-01-20	2024-03-10
52	2	2	2024-01-15	закрыт	2024-01-25	2024-02-20
53	3	3	2024-01-20	на выполнении	2024-02-01	\N
54	4	4	2024-01-25	подписан	2024-01-30	\N
55	5	5	2024-02-01	закрыт	2024-02-11	2024-04-01
56	6	6	2024-02-05	на выполнении	2024-02-15	\N
57	7	7	2024-02-10	подписан	2024-02-15	\N
58	8	8	2024-02-15	закрыт	2024-02-25	2024-03-30
59	9	9	2024-02-20	на выполнении	2024-03-01	\N
60	10	10	2024-02-25	подписан	2024-03-01	\N
61	11	1	2024-03-01	закрыт	2024-03-11	2024-05-01
62	12	2	2024-03-05	на выполнении	2024-03-15	\N
63	13	3	2024-03-10	подписан	2024-03-15	\N
64	14	4	2024-03-15	закрыт	2024-03-25	2024-04-25
65	15	5	2024-03-20	на выполнении	2024-03-30	\N
66	16	6	2024-03-25	подписан	2024-03-30	\N
67	17	7	2024-04-01	закрыт	2024-04-11	2024-06-01
68	18	8	2024-04-05	на выполнении	2024-04-15	\N
69	19	9	2024-04-10	подписан	2024-04-15	\N
70	20	10	2024-04-15	закрыт	2024-04-25	2024-05-30
71	21	1	2024-04-20	на выполнении	2024-04-30	\N
72	22	2	2024-04-25	подписан	2024-04-30	\N
73	23	3	2024-05-01	закрыт	2024-05-11	2024-06-25
74	24	4	2024-05-05	на выполнении	2024-05-15	\N
75	25	5	2024-05-10	подписан	2024-05-15	\N
76	26	6	2024-05-15	закрыт	2024-05-25	2024-07-05
77	27	7	2024-05-20	на выполнении	2024-05-30	\N
78	28	8	2024-05-25	подписан	2024-05-30	\N
79	29	9	2024-06-01	закрыт	2024-06-11	2024-07-20
80	30	10	2024-06-05	на выполнении	2024-06-15	\N
81	31	1	2024-06-10	подписан	2024-06-15	\N
82	32	2	2024-06-15	закрыт	2024-06-25	2024-08-05
83	33	3	2024-06-20	на выполнении	2024-06-30	\N
84	34	4	2024-06-25	подписан	2024-06-30	\N
85	35	5	2024-07-01	закрыт	2024-07-11	2024-08-20
86	36	6	2024-07-05	на выполнении	2024-07-15	\N
87	37	7	2024-07-10	подписан	2024-07-15	\N
88	38	8	2024-07-15	закрыт	2024-07-25	2024-09-05
89	39	9	2024-07-20	на выполнении	2024-07-30	\N
90	40	10	2024-07-25	подписан	2024-07-30	\N
91	41	1	2024-08-01	закрыт	2024-08-11	2024-09-20
92	42	2	2024-08-05	на выполнении	2024-08-15	\N
93	43	3	2024-08-10	подписан	2024-08-15	\N
94	44	4	2024-08-15	закрыт	2024-08-25	2024-10-05
95	45	5	2024-08-20	на выполнении	2024-08-30	\N
96	46	6	2024-08-25	подписан	2024-08-30	\N
97	47	7	2024-09-01	закрыт	2024-09-11	2024-10-20
98	48	8	2024-09-05	на выполнении	2024-09-15	\N
99	49	9	2024-09-10	подписан	2024-09-15	\N
100	50	10	2024-09-15	закрыт	2024-09-25	2024-11-05
\.


--
-- TOC entry 5029 (class 0 OID 16510)
-- Dependencies: 220
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, surname, name, middle_name, phone_number, email, address) FROM stdin;
1	Иванов	Сергей	Александрович	+79161234567	ivanovsa@gmail.com	г. Москва, ул. Тверская, д. 15, кв. 48
2	Петрова	Елена	Владимировна	+79264567890	petrovaev@mail.ru	г. Санкт-Петербург, Невский пр., д. 25, кв. 12
3	Сидоров	Максим	Дмитриевич	+79031234567	sidorovmd@yandex.ru	г. Новосибирск, ул. Советская, д. 8, кв. 56
4	Кузнецова	Татьяна	Андреевна	+79182345678	kuznetsovata@mail.ru	г. Екатеринбург, ул. Ленина, д. 42, кв. 7
5	Смирнов	Андрей	Игоревич	+79273456789	smirnovai@gmail.com	г. Казань, ул. Баумана, д. 10, кв. 23
6	Васильева	Ольга	Николаевна	+79094567890	vasilyevaon@mail.ru	г. Нижний Новгород, ул. Большая Покровская, д. 17, кв. 34
7	Попов	Денис	Валерьевич	+79155678901	popovdv@gmail.com	г. Самара, ул. Ленинградская, д. 5, кв. 89
8	Соколова	Анастасия	Павловна	+79266789012	sokolovaap@yandex.ru	г. Ростов-на-Дону, ул. Пушкинская, д. 22, кв. 15
9	Михайлов	Владимир	Сергеевич	+79037890123	mikhailovvs@mail.ru	г. Уфа, пр. Октября, д. 33, кв. 41
10	Новикова	Ирина	Григорьевна	+79178901234	novikovaig@gmail.com	г. Красноярск, ул. Мира, д. 12, кв. 67
11	Федоров	Алексей	Константинович	+79289012345	fedorovak@mail.ru	г. Пермь, ул. Ленина, д. 54, кв. 9
12	Морозова	Юлия	Евгеньевна	+79090123456	morozovaye@gmail.com	г. Воронеж, ул. Плехановская, д. 7, кв. 28
13	Волков	Илья	Романович	+79161234567	volkovir@yandex.ru	г. Волгоград, пр. Ленина, д. 19, кв. 53
14	Зайцева	Анна	Витальевна	+79272345678	zaytsevaav@mail.ru	г. Краснодар, ул. Дзержинского, д. 8, кв. 76
15	Павлов	Артур	Даниилович	+79083456789	pavlovad@gmail.com	г. Саратов, ул. Московская, д. 26, кв. 34
16	Егорова	Ксения	Алексеевна	+79194567890	egorovaka@mail.ru	г. Тюмень, ул. Республики, д. 14, кв. 62
17	Семенов	Никита	Олегович	+79205678901	semenovno@gmail.com	г. Ижевск, ул. Пушкинская, д. 9, кв. 18
18	Николаева	Дарья	Максимовна	+79016789012	nikolaevadm@yandex.ru	г. Барнаул, пр. Ленина, д. 31, кв. 85
19	Морозов	Глеб	Андреевич	+79127890123	morozovga@gmail.com	г. Ульяновск, ул. Гончарова, д. 12, кв. 44
20	Александрова	Полина	Ильинична	+79238901234	aleksandrovapi@mail.ru	г. Ярославль, ул. Свободы, д. 5, кв. 21
21	Григорьев	Станислав	Викторович	+79049012345	grigorievsv@gmail.com	г. Иркутск, ул. Ленина, д. 48, кв. 73
22	Сергеева	Маргарита	Борисовна	+79150123456	sergeevamb@mail.ru	г. Хабаровск, ул. Муравьева-Амурского, д. 16, кв. 39
23	Виноградов	Роман	Денисович	+79261234567	vinogradovrd@gmail.com	г. Владивосток, ул. Светланская, д. 23, кв. 57
24	Костин	Евгений	Анатольевич	+79072345678	kostinea@yandex.ru	г. Томск, пр. Ленина, д. 37, кв. 82
25	Баранов	Кирилл	Юрьевич	+79183456789	baranovky@gmail.com	г. Омск, ул. Ленина, д. 44, кв. 11
26	Макарова	София	Аркадьевна	+79294567890	makarovasa@mail.ru	г. Кемерово, пр. Советский, д. 29, кв. 64
27	Давыдов	Тимофей	Валерьевич	+79005678901	davydovtv@gmail.com	г. Рязань, ул. Горького, д. 18, кв. 47
28	Тимофеева	Елизавета	Андреевна	+79116789012	timofeevaea@mail.ru	г. Пенза, ул. Московская, д. 10, кв. 33
29	Кравцов	Арсений	Кириллович	+79227890123	kravtsovak@gmail.com	г. Липецк, пр. Победы, д. 6, кв. 91
30	Беляев	Ростислав	Евгеньевич	+79038901234	belyaevro@yandex.ru	г. Киров, ул. Карла Маркса, д. 14, кв. 29
31	Романова	Оксана	Филипповна	+79149012345	romanovaof@mail.ru	г. Челябинск, ул. Кирова, д. 21, кв. 68
32	Комаров	Данил	Иванович	+79250123456	komarovdi@gmail.com	г. Благовещенск, ул. Ленина, д. 17, кв. 52
33	Орлова	Виктория	Руслановна	+79061234567	orlovavr@mail.ru	г. Махачкала, пр. Расула Гамзатова, д. 8, кв. 74
34	Жуков	Василий	Константинович	+79172345678	zhukovvk@gmail.com	г. Суздаль, ул. Ленина, д. 4, кв. 16
35	Крылов	Захар	Петрович	+79283456789	krylovzp@yandex.ru	г. Смоленск, ул. Большая Советская, д. 27, кв. 83
36	Белова	Алиса	Дмитриевна	+79094567890	belovaad@mail.ru	г. Тверь, ул. Советская, д. 11, кв. 49
37	Тарасов	Иннокентий	Степанович	+79105678901	tarasovis@gmail.com	г. Курск, ул. Ленина, д. 34, кв. 26
38	Мишина	Ева	Александровна	+79216789012	mishinaea@mail.ru	г. Белгород, пр. Богдана Хмельницкого, д. 19, кв. 71
39	Фокин	Платон	Вячеславович	+79027890123	fokinpv@gmail.com	г. Калуга, ул. Кирова, д. 13, кв. 37
40	Андреева	Арина	Матвеевна	+79138901234	andreevaam@yandex.ru	г. Тула, пр. Ленина, д. 22, кв. 64
41	Доронин	Герман	Алексеевич	+79249012345	doronengah@gmail.com	г. Сочи, ул. Навагинская, д. 6, кв. 88
42	Гаврилова	Стефания	Игоревна	+79050123456	gavrilovasi@mail.ru	г. Ставрополь, ул. Карла Маркса, д. 15, кв. 45
43	Соловьев	Матвей	Федорович	+79161123456	solovievmf@gmail.com	г. Петрозаводск, пр. Ленина, д. 24, кв. 31
44	Козлова	Варвара	Никитична	+79272234567	kozlova@gmail.com	г. Мурманск, пр. Ленина, д. 31, кв. 17
45	Миронов	Лев	Павлович	+79083345678	mironovlp@mail.ru	г. Архангельск, ул. Воскресенская, д. 12, кв. 59
46	Фролова	Амелия	Анатольевна	+79194456789	frolovaaa@gmail.com	г. Владимир, ул. Большая Московская, д. 8, кв. 42
47	Нестеров	Эрик	Робертович	+79205567890	nesterover@yandex.ru	г. Чита, ул. Ленина, д. 42, кв. 75
48	Игнатьев	Тихон	Степанович	+79016678901	ignatievts@gmail.com	г. Орёл, ул. Ленина, д. 17, кв. 23
49	Константинова	Злата	Витальевна	+79127789012	konstantinovazv@mail.ru	г. Псков, ул. Пушкина, д. 9, кв. 61
50	Лавров	Савелий	Григорьевич	+79238890123	lavrovsg@gmail.com	г. Новгород, ул. Ильина, д. 7, кв. 38
\.


--
-- TOC entry 5042 (class 0 OID 16577)
-- Dependencies: 233
-- Data for Name: editions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.editions (editions_id, contract_id, isbn, book_id) FROM stdin;
1	51	9785098765432	1
2	52	9785098765433	2
3	53	9785098765434	3
4	54	9785098765435	4
5	55	9785098765436	5
6	56	9785098765437	6
7	57	9785098765438	7
8	58	9785098765439	8
9	59	9785098765440	9
10	60	9785098765441	10
11	61	9785098765442	11
12	62	9785098765443	12
13	63	9785098765444	13
14	64	9785098765445	14
15	65	9785098765446	15
16	66	9785098765447	16
17	67	9785098765448	17
18	68	9785098765449	18
19	69	9785098765450	19
20	70	9785098765451	20
21	71	9785098765452	21
22	72	9785098765453	22
23	73	9785098765454	23
24	74	9785098765455	24
25	75	9785098765456	25
26	76	9785098765457	26
27	77	9785098765458	27
28	78	9785098765459	28
29	79	9785098765460	29
30	80	9785098765461	30
31	81	9785098765462	31
32	82	9785098765463	32
33	83	9785098765464	33
34	84	9785098765465	34
35	85	9785098765466	35
36	86	9785098765467	36
37	87	9785098765468	37
38	88	9785098765469	38
39	89	9785098765470	39
40	90	9785098765471	40
41	91	9785098765472	41
42	92	9785098765473	42
43	93	9785098765474	43
44	94	9785098765475	44
45	95	9785098765476	45
46	96	9785098765477	46
47	97	9785098765478	47
48	98	9785098765479	48
49	99	9785098765480	49
50	100	9785098765481	50
\.


--
-- TOC entry 5050 (class 0 OID 16821)
-- Dependencies: 241
-- Data for Name: editions_and_editors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.editions_and_editors (editions_and_editors_id, editions_id, editor_id) FROM stdin;
1	1	1
2	1	2
3	2	3
4	2	4
5	3	5
6	4	6
7	4	7
8	5	8
9	6	9
10	6	10
11	7	11
12	8	12
13	8	13
14	9	14
15	10	15
16	10	16
17	11	17
18	12	18
19	12	19
20	13	20
21	13	21
22	14	22
23	15	23
24	15	24
25	16	25
26	17	26
27	17	27
28	18	28
29	19	29
30	20	30
31	20	31
32	21	32
33	22	33
34	22	34
35	23	35
36	24	36
37	24	37
38	25	38
39	26	39
40	26	40
41	27	41
42	28	42
43	28	43
44	29	44
45	30	45
46	30	46
47	31	47
48	32	48
49	32	49
50	33	50
51	34	1
52	34	2
53	35	3
54	36	4
55	36	5
56	37	6
57	38	7
58	38	8
59	39	9
60	40	10
61	40	11
62	41	12
63	42	13
64	42	14
65	43	15
66	44	16
67	44	17
68	45	18
69	46	19
70	46	20
71	47	21
72	48	22
73	48	23
74	49	24
75	50	25
76	50	26
\.


--
-- TOC entry 5027 (class 0 OID 16495)
-- Dependencies: 218
-- Data for Name: editors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.editors (editor_id, surname, name, middle_name, email, "position") FROM stdin;
1	Смирнова	Анна	Александровна	smirnovaaa@mail.ru	главный
2	Кузнецов	Дмитрий	Сергеевич	kuznetsovds@gmail.com	средний
3	Попова	Екатерина	Владимировна	popovaev@mail.ru	младший
4	Васильев	Андрей	Николаевич	vasilyevan@gmail.com	средний
5	Соколова	Мария	Петровна	sokolovamp@mail.ru	главный
6	Михайлов	Илья	Романович	mikhailovir@gmail.com	средний
7	Федорова	Ольга	Дмитриевна	fedorovaod@mail.ru	младший
8	Новиков	Павел	Андреевич	novikovpa@gmail.com	средний
9	Морозова	Татьяна	Игоревна	morozovati@mail.ru	главный
10	Волкова	Наталья	Евгеньевна	volkovane@mail.ru	младший
11	Алексеев	Константин	Викторович	alekseevkv@gmail.com	средний
12	Лебедева	Юлия	Анатольевна	lebedevaya@mail.ru	главный
13	Козлов	Максим	Валентинович	kozlovmv@gmail.com	младший
14	Егорова	Алина	Станиславовна	egorovaas@mail.ru	средний
15	Павлов	Артем	Васильевич	pavlovav@gmail.com	главный
16	Семенова	Ирина	Григорьевна	semenovaig@mail.ru	младший
17	Голубев	Никита	Петрович	golubevnp@gmail.com	средний
18	Виноградова	Светлана	Михайловна	vinogradovasm@mail.ru	главный
19	Беляев	Роман	Алексеевич	belyaevra@gmail.com	младший
20	Тарасова	Елена	Борисовна	tarasovaeb@mail.ru	средний
21	Орлов	Владимир	Денисович	orlovvd@gmail.com	главный
22	Киселева	Виктория	Андреевна	kiselevava@mail.ru	младший
23	Макаров	Евгений	Игоревич	makarovei@gmail.com	средний
24	Андреева	Полина	Максимовна	andreevapm@mail.ru	главный
25	Ковалев	Вячеслав	Олегович	kovalevvo@gmail.com	младший
26	Ильина	Александра	Дмитриевна	ilinaad@mail.ru	средний
27	Григорьев	Юрий	Витальевич	grigorievyv@gmail.com	главный
28	Никитина	Валерия	Павловна	nikitinavp@mail.ru	младший
29	Лазарев	Эдуард	Геннадьевич	lazareveg@gmail.com	средний
30	Медведева	Ангелина	Руслановна	medvedevaar@mail.ru	главный
31	Захаров	Кирилл	Вадимович	zakharovkv@gmail.com	младший
32	Степанова	Вероника	Олеговна	stepanovavo@mail.ru	средний
33	Фролов	Данила	Максимович	frolovdm@gmail.com	главный
34	Жукова	Антонина	Сергеевна	zhukovaas@mail.ru	младший
35	Тихонов	Георгий	Аркадьевич	tikhongo@gmail.com	средний
36	Соболева	Лариса	Федоровна	sobolevalf@mail.ru	главный
37	Борисов	Олег	Викторович	borisovov@gmail.com	младший
38	Воробьева	Таисия	Артемовна	vorobievata@mail.ru	средний
39	Емельянов	Руслан	Ильдарович	emelyanovri@gmail.com	главный
40	Калинина	Зоя	Альбертовна	kalininaza@mail.ru	младший
41	Гаврилов	Виталий	Александрович	gavrilovva@gmail.com	средний
42	Тимофеева	Снежана	Матвеевна	timofeevasm@mail.ru	главный
43	Чернов	Тимур	Евгеньевич	chernovte@gmail.com	младший
44	Абрамова	Диана	Станиславовна	abramovads@mail.ru	средний
45	Крылов	Ярослав	Владиславович	krylovyv@gmail.com	главный
46	Мартынова	Карина	Игоревна	martynovaki@mail.ru	младший
47	Осипов	Леонид	Федорович	osipovlf@gmail.com	средний
48	Комарова	Алиса	Олеговна	komarovaoa@mail.ru	главный
49	Сорокин	Матвей	Николаевич	sorokinmn@gmail.com	младший
50	Панкратова	Людмила	Васильевна	pankratovalv@mail.ru	средний
\.


--
-- TOC entry 5033 (class 0 OID 16538)
-- Dependencies: 224
-- Data for Name: managers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.managers (manager_id, name, surname, middle_name, email, number_of_contracts) FROM stdin;
1	Анна	Смирнова	Александровна	smirnova.anna@mail.ru	3
2	Дмитрий	Кузнецов	Сергеевич	kuznetsov.dmitry@gmail.com	5
3	Екатерина	Попова	Владимировна	popova.ekaterina@mail.ru	2
4	Андрей	Васильев	Николаевич	vasilyev.andrey@gmail.com	4
5	Мария	Соколова	Петровна	sokolova.maria@yandex.ru	5
6	Илья	Михайлов	Романович	mikhailov.ilya@mail.ru	1
7	Ольга	Федорова	Дмитриевна	fedorova.olga@gmail.com	4
8	Павел	Новиков	Андреевич	novikov.pavel@mail.ru	3
9	Татьяна	Морозова	Игоревна	morozova.tatiana@gmail.com	5
10	Константин	Алексеев	Викторович	alekseev.konstantin@mail.ru	2
\.


--
-- TOC entry 5044 (class 0 OID 16594)
-- Dependencies: 235
-- Data for Name: requirements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requirements (requirement_id, binding, pages_number, pictures, editions_id) FROM stdin;
1	твердый	350	t	1
2	мягкий	280	f	2
3	твердый	450	t	3
4	пружинный	200	t	4
5	мягкий	320	f	5
6	твердый	500	t	6
7	кольцевой	180	f	7
8	твердый	400	t	8
9	мягкий	260	f	9
10	французский	220	t	10
11	твердый	380	t	11
12	мягкий	300	f	12
13	твердый	480	t	13
14	пружинный	190	f	14
15	мягкий	340	f	15
16	твердый	420	t	16
17	кольцевой	210	t	17
18	твердый	370	f	18
19	мягкий	290	t	19
20	французский	240	f	20
21	твердый	410	t	21
22	мягкий	310	f	22
23	твердый	460	t	23
24	пружинный	195	f	24
25	мягкий	330	t	25
26	твердый	440	f	26
27	кольцевой	230	t	27
28	твердый	360	f	28
29	мягкий	270	t	29
30	французский	250	f	30
31	твердый	430	t	31
32	мягкий	295	f	32
33	твердый	490	t	33
34	пружинный	185	f	34
35	мягкий	345	t	35
36	твердый	415	f	36
37	кольцевой	225	t	37
38	твердый	375	f	38
39	мягкий	285	t	39
40	французский	235	f	40
41	твердый	405	t	41
42	мягкий	315	f	42
43	твердый	455	t	43
44	пружинный	205	f	44
45	мягкий	325	t	45
46	твердый	435	f	46
47	кольцевой	215	t	47
48	твердый	365	f	48
49	мягкий	275	t	49
50	французский	245	f	50
\.


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 245
-- Name: accounts_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_id_seq', 100, true);


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 227
-- Name: authors_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authors_author_id_seq', 50, true);


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 237
-- Name: books_and_authors_books_and_authors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_and_authors_books_and_authors_id_seq', 98, true);


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 229
-- Name: books_book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_book_id_seq', 57, true);


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 230
-- Name: books_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_category_id_seq', 1, false);


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 225
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 22, true);


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 244
-- Name: circulations_circulation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.circulations_circulation_id_seq', 150, true);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 239
-- Name: circulations_editions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.circulations_editions_id_seq', 150, true);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 242
-- Name: contract_content_contract_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contract_content_contract_content_id_seq', 50, true);


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 221
-- Name: contracts_contract_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contracts_contract_id_seq', 100, true);


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 219
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 50, true);


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 240
-- Name: editions_and_editors_editions_and_editors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.editions_and_editors_editions_and_editors_id_seq', 76, true);


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 232
-- Name: editions_editions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.editions_editions_id_seq', 50, true);


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 217
-- Name: editors_editor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.editors_editor_id_seq', 50, true);


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 223
-- Name: managers_manager_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.managers_manager_id_seq', 10, true);


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 234
-- Name: requirements_requirement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.requirements_requirement_id_seq', 50, true);


--
-- TOC entry 4865 (class 2606 OID 16889)
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- TOC entry 4848 (class 2606 OID 16560)
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (author_id);


--
-- TOC entry 4859 (class 2606 OID 16789)
-- Name: books_and_authors books_and_authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_and_authors
    ADD CONSTRAINT books_and_authors_pkey PRIMARY KEY (books_and_authors_id);


--
-- TOC entry 4850 (class 2606 OID 16570)
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (book_id);


--
-- TOC entry 4846 (class 2606 OID 16553)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 4856 (class 2606 OID 16861)
-- Name: circulations circulations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circulations
    ADD CONSTRAINT circulations_pkey PRIMARY KEY (circulation_id);


--
-- TOC entry 4863 (class 2606 OID 16848)
-- Name: contract_content contract_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_content
    ADD CONSTRAINT contract_content_pkey PRIMARY KEY (contract_content_id);


--
-- TOC entry 4842 (class 2606 OID 16526)
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (contract_id);


--
-- TOC entry 4840 (class 2606 OID 16517)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4825 (class 2606 OID 16947)
-- Name: contracts date_creation; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.contracts
    ADD CONSTRAINT date_creation CHECK (((date_creation < date_fulfillment) AND (date_creation < date_completion))) NOT VALID;


--
-- TOC entry 4861 (class 2606 OID 16826)
-- Name: editions_and_editors editions_and_editors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editions_and_editors
    ADD CONSTRAINT editions_and_editors_pkey PRIMARY KEY (editions_and_editors_id);


--
-- TOC entry 4852 (class 2606 OID 16582)
-- Name: editions editions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editions
    ADD CONSTRAINT editions_pkey PRIMARY KEY (editions_id);


--
-- TOC entry 4838 (class 2606 OID 16500)
-- Name: editors editors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editors
    ADD CONSTRAINT editors_pkey PRIMARY KEY (editor_id);


--
-- TOC entry 4828 (class 2606 OID 16948)
-- Name: books first_edition_year; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.books
    ADD CONSTRAINT first_edition_year CHECK ((first_edition_year > 1940)) NOT VALID;


--
-- TOC entry 4829 (class 2606 OID 16814)
-- Name: editions isbn; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.editions
    ADD CONSTRAINT isbn CHECK ((isbn = floor(isbn))) NOT VALID;


--
-- TOC entry 4844 (class 2606 OID 16544)
-- Name: managers managers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.managers
    ADD CONSTRAINT managers_pkey PRIMARY KEY (manager_id);


--
-- TOC entry 4834 (class 2606 OID 16813)
-- Name: books_and_authors num_ord; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.books_and_authors
    ADD CONSTRAINT num_ord CHECK (((num_ord >= 1) AND (num_ord <= 10))) NOT VALID;


--
-- TOC entry 4854 (class 2606 OID 16601)
-- Name: requirements requirements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requirements
    ADD CONSTRAINT requirements_pkey PRIMARY KEY (requirement_id);


--
-- TOC entry 4826 (class 2606 OID 16890)
-- Name: contracts status; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.contracts
    ADD CONSTRAINT status CHECK (((status)::text = ANY ((ARRAY['подписан'::character varying, 'закрыт'::character varying, 'на выполнении'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4836 (class 2606 OID 16941)
-- Name: accounts status; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.accounts
    ADD CONSTRAINT status CHECK (((status)::text = ANY ((ARRAY['оплачен'::character varying, 'не оплачен'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4857 (class 1259 OID 16810)
-- Name: fki_editions_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_editions_id ON public.circulations USING btree (editions_id);


--
-- TOC entry 4874 (class 2606 OID 16795)
-- Name: books_and_authors author_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_and_authors
    ADD CONSTRAINT author_id FOREIGN KEY (author_id) REFERENCES public.authors(author_id);


--
-- TOC entry 4875 (class 2606 OID 16790)
-- Name: books_and_authors book_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books_and_authors
    ADD CONSTRAINT book_id FOREIGN KEY (book_id) REFERENCES public.books(book_id);


--
-- TOC entry 4869 (class 2606 OID 16815)
-- Name: editions book_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editions
    ADD CONSTRAINT book_id FOREIGN KEY (book_id) REFERENCES public.books(book_id) NOT VALID;


--
-- TOC entry 4868 (class 2606 OID 16571)
-- Name: books books_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- TOC entry 4878 (class 2606 OID 16862)
-- Name: contract_content circulation_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_content
    ADD CONSTRAINT circulation_id FOREIGN KEY (circulation_id) REFERENCES public.circulations(circulation_id) NOT VALID;


--
-- TOC entry 4872 (class 2606 OID 16651)
-- Name: circulations circulations_requirement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circulations
    ADD CONSTRAINT circulations_requirement_id_fkey FOREIGN KEY (requirement_id) REFERENCES public.requirements(requirement_id);


--
-- TOC entry 4879 (class 2606 OID 16849)
-- Name: contract_content contract_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_content
    ADD CONSTRAINT contract_id FOREIGN KEY (contract_id) REFERENCES public.contracts(contract_id);


--
-- TOC entry 4880 (class 2606 OID 16942)
-- Name: accounts contract_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT contract_id FOREIGN KEY (contract_id) REFERENCES public.contracts(contract_id) NOT VALID;


--
-- TOC entry 4866 (class 2606 OID 16867)
-- Name: contracts customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) NOT VALID;


--
-- TOC entry 4870 (class 2606 OID 16583)
-- Name: editions editions_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editions
    ADD CONSTRAINT editions_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES public.contracts(contract_id);


--
-- TOC entry 4873 (class 2606 OID 16805)
-- Name: circulations editions_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.circulations
    ADD CONSTRAINT editions_id FOREIGN KEY (editions_id) REFERENCES public.editions(editions_id);


--
-- TOC entry 4876 (class 2606 OID 16827)
-- Name: editions_and_editors editions_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editions_and_editors
    ADD CONSTRAINT editions_id FOREIGN KEY (editions_id) REFERENCES public.editions(editions_id);


--
-- TOC entry 4871 (class 2606 OID 16877)
-- Name: requirements editions_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requirements
    ADD CONSTRAINT editions_id FOREIGN KEY (editions_id) REFERENCES public.editions(editions_id) NOT VALID;


--
-- TOC entry 4877 (class 2606 OID 16832)
-- Name: editions_and_editors editor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editions_and_editors
    ADD CONSTRAINT editor_id FOREIGN KEY (editor_id) REFERENCES public.editors(editor_id);


--
-- TOC entry 4867 (class 2606 OID 16872)
-- Name: contracts manger_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT manger_id FOREIGN KEY (manager_id) REFERENCES public.managers(manager_id) NOT VALID;


-- Completed on 2026-04-23 23:42:48

--
-- PostgreSQL database dump complete
--

