--
-- PostgreSQL database dump
--

\restrict v9kAJzyymsHgAKY5ESF0mjDYEFDuCmrFhPdAO7A1tvVcsg1nF3cJTa4S0JI3gUC

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-03-30 21:56:35

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
-- TOC entry 6 (class 2615 OID 16391)
-- Name: publishing; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA publishing;


ALTER SCHEMA publishing OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 245 (class 1259 OID 16704)
-- Name: act; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.act (
    id_act integer NOT NULL,
    id_contract integer,
    sign_date date NOT NULL,
    copies integer NOT NULL,
    notes character varying(300),
    CONSTRAINT act_copies_check CHECK ((copies = 2)),
    CONSTRAINT act_sign_date_check CHECK ((sign_date <= CURRENT_DATE))
);


ALTER TABLE publishing.act OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16703)
-- Name: act_id_act_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.act_id_act_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.act_id_act_seq OWNER TO postgres;

--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 244
-- Name: act_id_act_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.act_id_act_seq OWNED BY publishing.act.id_act;


--
-- TOC entry 225 (class 1259 OID 16454)
-- Name: author; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.author (
    id_author integer NOT NULL,
    biography text NOT NULL,
    last_name character varying(100) NOT NULL,
    patronymic character varying(100) NOT NULL,
    first_name character varying(100) NOT NULL,
    email character varying(200)
);


ALTER TABLE publishing.author OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16453)
-- Name: author_id_author_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.author_id_author_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.author_id_author_seq OWNER TO postgres;

--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 224
-- Name: author_id_author_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.author_id_author_seq OWNED BY publishing.author.id_author;


--
-- TOC entry 222 (class 1259 OID 16405)
-- Name: book; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.book (
    isbn character varying NOT NULL,
    id_category integer NOT NULL,
    title character varying(200) NOT NULL,
    type character varying(50) NOT NULL,
    edition_number integer,
    num_pages integer NOT NULL,
    stock_quantity integer NOT NULL,
    retail_price numeric NOT NULL,
    has_illustration boolean NOT NULL,
    year_first_publish integer NOT NULL,
    CONSTRAINT book_edition_number_check CHECK ((edition_number > 0)),
    CONSTRAINT book_num_pages_check CHECK ((num_pages > 0)),
    CONSTRAINT book_retail_price_check CHECK ((retail_price > (0)::numeric)),
    CONSTRAINT book_stock_quantity_check CHECK ((stock_quantity > 0)),
    CONSTRAINT book_type_check CHECK (((type)::text = ANY ((ARRAY['учебник'::character varying, 'учебное пособие'::character varying])::text[]))),
    CONSTRAINT book_year_first_publish_check CHECK (((year_first_publish)::numeric <= EXTRACT(year FROM CURRENT_DATE)))
);


ALTER TABLE publishing.book OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16469)
-- Name: book_author; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.book_author (
    isbn character(13) NOT NULL,
    id_author integer NOT NULL,
    role character varying(50) NOT NULL,
    main_author character varying NOT NULL,
    author_order character varying NOT NULL,
    CONSTRAINT book_author_role_check CHECK (((role)::text = ANY ((ARRAY['автор'::character varying, 'редактор'::character varying])::text[])))
);


ALTER TABLE publishing.book_author OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16432)
-- Name: book_category; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.book_category (
    isbn character(13) NOT NULL,
    id_category integer NOT NULL,
    assigned_at date NOT NULL,
    comment character varying(500),
    CONSTRAINT book_category_assigned_at_check CHECK ((assigned_at <= CURRENT_DATE))
);


ALTER TABLE publishing.book_category OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16393)
-- Name: category; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.category (
    id_category integer NOT NULL,
    category_name character varying(200) NOT NULL,
    description character varying(500)
);


ALTER TABLE publishing.category OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16392)
-- Name: category_id_category_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.category_id_category_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.category_id_category_seq OWNER TO postgres;

--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 220
-- Name: category_id_category_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.category_id_category_seq OWNED BY publishing.category.id_category;


--
-- TOC entry 228 (class 1259 OID 16493)
-- Name: circulation; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.circulation (
    id_circulation integer NOT NULL,
    isbn character(13),
    print_type character varying(50) NOT NULL,
    circulation_quantity integer NOT NULL,
    circulation_date date NOT NULL,
    notes character varying(300),
    CONSTRAINT circulation_circulation_date_check CHECK ((circulation_date <= CURRENT_DATE)),
    CONSTRAINT circulation_circulation_quantity_check CHECK ((circulation_quantity > 0)),
    CONSTRAINT circulation_print_type_check CHECK (((print_type)::text = ANY ((ARRAY['оригинальный'::character varying, 'дополнительный'::character varying])::text[])))
);


ALTER TABLE publishing.circulation OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16492)
-- Name: circulation_id_circulation_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.circulation_id_circulation_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.circulation_id_circulation_seq OWNER TO postgres;

--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 227
-- Name: circulation_id_circulation_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.circulation_id_circulation_seq OWNED BY publishing.circulation.id_circulation;


--
-- TOC entry 241 (class 1259 OID 16653)
-- Name: contract; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.contract (
    id_contract integer NOT NULL,
    id_order integer,
    id_manager integer,
    id_customer integer,
    contract_status character varying(50) NOT NULL,
    contract_date date NOT NULL,
    copies integer NOT NULL,
    CONSTRAINT contract_contract_date_check CHECK ((contract_date <= CURRENT_DATE)),
    CONSTRAINT contract_contract_status_check CHECK (((contract_status)::text = ANY ((ARRAY['активный'::character varying, 'закрытый'::character varying, 'ожидающий'::character varying])::text[]))),
    CONSTRAINT contract_copies_check CHECK ((copies = 2))
);


ALTER TABLE publishing.contract OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16652)
-- Name: contract_id_contract_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.contract_id_contract_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.contract_id_contract_seq OWNER TO postgres;

--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 240
-- Name: contract_id_contract_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.contract_id_contract_seq OWNED BY publishing.contract.id_contract;


--
-- TOC entry 232 (class 1259 OID 16527)
-- Name: customer; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.customer (
    id_customer integer NOT NULL,
    contact_legal_entity character varying(200) NOT NULL,
    company_name character varying(200) NOT NULL,
    id_tax character varying(10) NOT NULL,
    phone character varying(20) NOT NULL,
    address character varying(300) NOT NULL,
    email character varying(200) NOT NULL
);


ALTER TABLE publishing.customer OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16526)
-- Name: customer_id_customer_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.customer_id_customer_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.customer_id_customer_seq OWNER TO postgres;

--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 231
-- Name: customer_id_customer_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.customer_id_customer_seq OWNED BY publishing.customer.id_customer;


--
-- TOC entry 239 (class 1259 OID 16629)
-- Name: editing_ta; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.editing_ta (
    id_editing integer NOT NULL,
    id_ta integer,
    id_editor integer,
    participation_start date NOT NULL,
    order_editor character varying(100) NOT NULL,
    main_editor character varying(100) NOT NULL,
    comment character varying(300),
    CONSTRAINT editing_ta_participation_start_check CHECK ((participation_start <= CURRENT_DATE))
);


ALTER TABLE publishing.editing_ta OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16628)
-- Name: editing_ta_id_editing_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.editing_ta_id_editing_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.editing_ta_id_editing_seq OWNER TO postgres;

--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 238
-- Name: editing_ta_id_editing_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.editing_ta_id_editing_seq OWNED BY publishing.editing_ta.id_editing;


--
-- TOC entry 230 (class 1259 OID 16512)
-- Name: employee; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.employee (
    id_employee integer NOT NULL,
    name character varying(100) NOT NULL,
    "position" character varying(100) NOT NULL,
    employment_rate numeric NOT NULL,
    contact character varying(100),
    CONSTRAINT employee_employment_rate_check CHECK (((employment_rate >= 0.5) AND (employment_rate <= (3)::numeric))),
    CONSTRAINT employee_position_check CHECK ((("position")::text = ANY ((ARRAY['менеджер'::character varying, 'редактор'::character varying, 'бухгалтер'::character varying])::text[])))
);


ALTER TABLE publishing.employee OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16511)
-- Name: employee_id_employee_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.employee_id_employee_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.employee_id_employee_seq OWNER TO postgres;

--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 229
-- Name: employee_id_employee_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.employee_id_employee_seq OWNED BY publishing.employee.id_employee;


--
-- TOC entry 243 (class 1259 OID 16682)
-- Name: invoice; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.invoice (
    id_invoice integer NOT NULL,
    id_contract integer,
    invoice_type character varying(50) NOT NULL,
    sign_date date NOT NULL,
    amount numeric NOT NULL,
    payment_status boolean NOT NULL,
    CONSTRAINT invoice_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT invoice_invoice_type_check CHECK (((invoice_type)::text = ANY ((ARRAY['предоплата'::character varying, 'частичная оплата'::character varying])::text[]))),
    CONSTRAINT invoice_sign_date_check CHECK ((sign_date <= CURRENT_DATE))
);


ALTER TABLE publishing.invoice OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16681)
-- Name: invoice_id_invoice_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.invoice_id_invoice_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.invoice_id_invoice_seq OWNER TO postgres;

--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 242
-- Name: invoice_id_invoice_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.invoice_id_invoice_seq OWNED BY publishing.invoice.id_invoice;


--
-- TOC entry 235 (class 1259 OID 16576)
-- Name: order_item; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.order_item (
    id_order integer NOT NULL,
    isbn character(13) NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric NOT NULL,
    total_amount numeric NOT NULL,
    CONSTRAINT order_item_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT order_item_total_amount_check CHECK ((total_amount > (0)::numeric)),
    CONSTRAINT order_item_unit_price_check CHECK ((unit_price > (0)::numeric))
);


ALTER TABLE publishing.order_item OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16547)
-- Name: orders; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.orders (
    id_order integer NOT NULL,
    id_manager integer NOT NULL,
    id_customer integer NOT NULL,
    order_date date NOT NULL,
    status character varying(50) NOT NULL,
    due_date date NOT NULL,
    total_amount numeric NOT NULL,
    CONSTRAINT orders_check CHECK ((due_date >= order_date)),
    CONSTRAINT orders_order_date_check CHECK ((order_date <= CURRENT_DATE)),
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['получено'::character varying, 'обработано'::character varying, 'завершено'::character varying, 'доставлено'::character varying, 'отменено'::character varying])::text[]))),
    CONSTRAINT orders_total_amount_check CHECK ((total_amount > (0)::numeric))
);


ALTER TABLE publishing.orders OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16546)
-- Name: orders_id_order_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.orders_id_order_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.orders_id_order_seq OWNER TO postgres;

--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 233
-- Name: orders_id_order_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.orders_id_order_seq OWNED BY publishing.orders.id_order;


--
-- TOC entry 237 (class 1259 OID 16602)
-- Name: technical_assignment; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.technical_assignment (
    id_ta integer NOT NULL,
    isbn character(13),
    id_author_ta integer,
    has_illustration boolean NOT NULL,
    binding_type character varying(100) NOT NULL,
    created_date date NOT NULL,
    paper_type character varying(100) NOT NULL,
    notes character varying(300),
    CONSTRAINT technical_assignment_binding_type_check CHECK (((binding_type)::text = ANY ((ARRAY['твердый'::character varying, 'мягкий'::character varying])::text[]))),
    CONSTRAINT technical_assignment_created_date_check CHECK ((created_date <= CURRENT_DATE)),
    CONSTRAINT technical_assignment_paper_type_check CHECK (((paper_type)::text = ANY ((ARRAY['офсетная'::character varying, 'мелованная'::character varying])::text[])))
);


ALTER TABLE publishing.technical_assignment OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16601)
-- Name: technical_assignment_id_ta_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.technical_assignment_id_ta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.technical_assignment_id_ta_seq OWNER TO postgres;

--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 236
-- Name: technical_assignment_id_ta_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.technical_assignment_id_ta_seq OWNED BY publishing.technical_assignment.id_ta;


--
-- TOC entry 4933 (class 2604 OID 16707)
-- Name: act id_act; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.act ALTER COLUMN id_act SET DEFAULT nextval('publishing.act_id_act_seq'::regclass);


--
-- TOC entry 4924 (class 2604 OID 16457)
-- Name: author id_author; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.author ALTER COLUMN id_author SET DEFAULT nextval('publishing.author_id_author_seq'::regclass);


--
-- TOC entry 4923 (class 2604 OID 16396)
-- Name: category id_category; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.category ALTER COLUMN id_category SET DEFAULT nextval('publishing.category_id_category_seq'::regclass);


--
-- TOC entry 4925 (class 2604 OID 16496)
-- Name: circulation id_circulation; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.circulation ALTER COLUMN id_circulation SET DEFAULT nextval('publishing.circulation_id_circulation_seq'::regclass);


--
-- TOC entry 4931 (class 2604 OID 16656)
-- Name: contract id_contract; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.contract ALTER COLUMN id_contract SET DEFAULT nextval('publishing.contract_id_contract_seq'::regclass);


--
-- TOC entry 4927 (class 2604 OID 16530)
-- Name: customer id_customer; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.customer ALTER COLUMN id_customer SET DEFAULT nextval('publishing.customer_id_customer_seq'::regclass);


--
-- TOC entry 4930 (class 2604 OID 16632)
-- Name: editing_ta id_editing; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.editing_ta ALTER COLUMN id_editing SET DEFAULT nextval('publishing.editing_ta_id_editing_seq'::regclass);


--
-- TOC entry 4926 (class 2604 OID 16515)
-- Name: employee id_employee; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.employee ALTER COLUMN id_employee SET DEFAULT nextval('publishing.employee_id_employee_seq'::regclass);


--
-- TOC entry 4932 (class 2604 OID 16685)
-- Name: invoice id_invoice; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.invoice ALTER COLUMN id_invoice SET DEFAULT nextval('publishing.invoice_id_invoice_seq'::regclass);


--
-- TOC entry 4928 (class 2604 OID 16550)
-- Name: orders id_order; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.orders ALTER COLUMN id_order SET DEFAULT nextval('publishing.orders_id_order_seq'::regclass);


--
-- TOC entry 4929 (class 2604 OID 16605)
-- Name: technical_assignment id_ta; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.technical_assignment ALTER COLUMN id_ta SET DEFAULT nextval('publishing.technical_assignment_id_ta_seq'::regclass);


--
-- TOC entry 5193 (class 0 OID 16704)
-- Dependencies: 245
-- Data for Name: act; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.act (id_act, id_contract, sign_date, copies, notes) FROM stdin;
1	1	2024-01-05	2	\N
\.


--
-- TOC entry 5173 (class 0 OID 16454)
-- Dependencies: 225
-- Data for Name: author; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.author (id_author, biography, last_name, patronymic, first_name, email) FROM stdin;
3	Expert in DB	Ivanov	Ivanovich	Ivan	ivan@mail.com
4	SQL specialist	Petrov	Petrovich	Petr	petr@mail.com
\.


--
-- TOC entry 5170 (class 0 OID 16405)
-- Dependencies: 222
-- Data for Name: book; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.book (isbn, id_category, title, type, edition_number, num_pages, stock_quantity, retail_price, has_illustration, year_first_publish) FROM stdin;
9781234567890	1	PostgreSQL Guide	учебник	1	300	10	25.5	t	2020
9781234567891	2	SQL Basics	учебное пособие	1	200	5	15.0	f	2019
\.


--
-- TOC entry 5174 (class 0 OID 16469)
-- Dependencies: 226
-- Data for Name: book_author; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.book_author (isbn, id_author, role, main_author, author_order) FROM stdin;
\.


--
-- TOC entry 5171 (class 0 OID 16432)
-- Dependencies: 223
-- Data for Name: book_category; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.book_category (isbn, id_category, assigned_at, comment) FROM stdin;
\.


--
-- TOC entry 5169 (class 0 OID 16393)
-- Dependencies: 221
-- Data for Name: category; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.category (id_category, category_name, description) FROM stdin;
1	Программирование	\N
2	Базы данных	\N
\.


--
-- TOC entry 5176 (class 0 OID 16493)
-- Dependencies: 228
-- Data for Name: circulation; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.circulation (id_circulation, isbn, print_type, circulation_quantity, circulation_date, notes) FROM stdin;
\.


--
-- TOC entry 5189 (class 0 OID 16653)
-- Dependencies: 241
-- Data for Name: contract; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.contract (id_contract, id_order, id_manager, id_customer, contract_status, contract_date, copies) FROM stdin;
1	1	1	1	активный	2024-01-02	2
\.


--
-- TOC entry 5180 (class 0 OID 16527)
-- Dependencies: 232
-- Data for Name: customer; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.customer (id_customer, contact_legal_entity, company_name, id_tax, phone, address, email) FROM stdin;
1	Никита Владимирович Лебедев	ABC Company	1234567890	123456789	Москва	abc@mail.com
\.


--
-- TOC entry 5187 (class 0 OID 16629)
-- Dependencies: 239
-- Data for Name: editing_ta; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.editing_ta (id_editing, id_ta, id_editor, participation_start, order_editor, main_editor, comment) FROM stdin;
\.


--
-- TOC entry 5178 (class 0 OID 16512)
-- Dependencies: 230
-- Data for Name: employee; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.employee (id_employee, name, "position", employment_rate, contact) FROM stdin;
1	Анна Михайловна Иванова	менеджер	1	\N
2	Дмитрий Андреевич Морозов	редактор	1	\N
\.


--
-- TOC entry 5191 (class 0 OID 16682)
-- Dependencies: 243
-- Data for Name: invoice; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.invoice (id_invoice, id_contract, invoice_type, sign_date, amount, payment_status) FROM stdin;
1	1	предоплата	2024-01-03	100	t
\.


--
-- TOC entry 5183 (class 0 OID 16576)
-- Dependencies: 235
-- Data for Name: order_item; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.order_item (id_order, isbn, quantity, unit_price, total_amount) FROM stdin;
1	9781234567890	2	25	50
\.


--
-- TOC entry 5182 (class 0 OID 16547)
-- Dependencies: 234
-- Data for Name: orders; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.orders (id_order, id_manager, id_customer, order_date, status, due_date, total_amount) FROM stdin;
1	1	1	2024-01-01	получено	2024-01-10	100
\.


--
-- TOC entry 5185 (class 0 OID 16602)
-- Dependencies: 237
-- Data for Name: technical_assignment; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.technical_assignment (id_ta, isbn, id_author_ta, has_illustration, binding_type, created_date, paper_type, notes) FROM stdin;
\.


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 244
-- Name: act_id_act_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.act_id_act_seq', 1, true);


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 224
-- Name: author_id_author_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.author_id_author_seq', 4, true);


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 220
-- Name: category_id_category_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.category_id_category_seq', 2, true);


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 227
-- Name: circulation_id_circulation_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.circulation_id_circulation_seq', 1, false);


--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 240
-- Name: contract_id_contract_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.contract_id_contract_seq', 1, true);


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 231
-- Name: customer_id_customer_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.customer_id_customer_seq', 1, true);


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 238
-- Name: editing_ta_id_editing_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.editing_ta_id_editing_seq', 1, false);


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 229
-- Name: employee_id_employee_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.employee_id_employee_seq', 2, true);


--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 242
-- Name: invoice_id_invoice_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.invoice_id_invoice_seq', 1, true);


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 233
-- Name: orders_id_order_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.orders_id_order_seq', 1, true);


--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 236
-- Name: technical_assignment_id_ta_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.technical_assignment_id_ta_seq', 1, false);


--
-- TOC entry 5003 (class 2606 OID 16714)
-- Name: act act_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.act
    ADD CONSTRAINT act_pkey PRIMARY KEY (id_act);


--
-- TOC entry 4975 (class 2606 OID 16468)
-- Name: author author_email_key; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.author
    ADD CONSTRAINT author_email_key UNIQUE (email);


--
-- TOC entry 4977 (class 2606 OID 16466)
-- Name: author author_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.author
    ADD CONSTRAINT author_pkey PRIMARY KEY (id_author);


--
-- TOC entry 4979 (class 2606 OID 16481)
-- Name: book_author book_author_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book_author
    ADD CONSTRAINT book_author_pkey PRIMARY KEY (isbn, id_author);


--
-- TOC entry 4973 (class 2606 OID 16442)
-- Name: book_category book_category_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book_category
    ADD CONSTRAINT book_category_pkey PRIMARY KEY (isbn, id_category);


--
-- TOC entry 4971 (class 2606 OID 17244)
-- Name: book book_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (isbn);


--
-- TOC entry 4967 (class 2606 OID 16404)
-- Name: category category_category_name_key; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.category
    ADD CONSTRAINT category_category_name_key UNIQUE (category_name);


--
-- TOC entry 4969 (class 2606 OID 16402)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id_category);


--
-- TOC entry 4981 (class 2606 OID 16505)
-- Name: circulation circulation_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.circulation
    ADD CONSTRAINT circulation_pkey PRIMARY KEY (id_circulation);


--
-- TOC entry 4999 (class 2606 OID 16665)
-- Name: contract contract_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (id_contract);


--
-- TOC entry 4985 (class 2606 OID 16545)
-- Name: customer customer_email_key; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.customer
    ADD CONSTRAINT customer_email_key UNIQUE (email);


--
-- TOC entry 4987 (class 2606 OID 16543)
-- Name: customer customer_id_tax_key; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.customer
    ADD CONSTRAINT customer_id_tax_key UNIQUE (id_tax);


--
-- TOC entry 4989 (class 2606 OID 16541)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id_customer);


--
-- TOC entry 4997 (class 2606 OID 16641)
-- Name: editing_ta editing_ta_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.editing_ta
    ADD CONSTRAINT editing_ta_pkey PRIMARY KEY (id_editing);


--
-- TOC entry 4983 (class 2606 OID 16525)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id_employee);


--
-- TOC entry 5001 (class 2606 OID 16697)
-- Name: invoice invoice_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id_invoice);


--
-- TOC entry 4993 (class 2606 OID 16590)
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id_order, isbn);


--
-- TOC entry 4991 (class 2606 OID 16565)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id_order);


--
-- TOC entry 4995 (class 2606 OID 16617)
-- Name: technical_assignment technical_assignment_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.technical_assignment
    ADD CONSTRAINT technical_assignment_pkey PRIMARY KEY (id_ta);


--
-- TOC entry 5020 (class 2606 OID 16715)
-- Name: act act_id_contract_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.act
    ADD CONSTRAINT act_id_contract_fkey FOREIGN KEY (id_contract) REFERENCES publishing.contract(id_contract);


--
-- TOC entry 5006 (class 2606 OID 16487)
-- Name: book_author book_author_id_author_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book_author
    ADD CONSTRAINT book_author_id_author_fkey FOREIGN KEY (id_author) REFERENCES publishing.author(id_author);


--
-- TOC entry 5007 (class 2606 OID 17251)
-- Name: book_author book_author_isbn_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book_author
    ADD CONSTRAINT book_author_isbn_fkey FOREIGN KEY (isbn) REFERENCES publishing.book(isbn);


--
-- TOC entry 5004 (class 2606 OID 16448)
-- Name: book_category book_category_id_category_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book_category
    ADD CONSTRAINT book_category_id_category_fkey FOREIGN KEY (id_category) REFERENCES publishing.category(id_category);


--
-- TOC entry 5005 (class 2606 OID 17246)
-- Name: book_category book_category_isbn_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book_category
    ADD CONSTRAINT book_category_isbn_fkey FOREIGN KEY (isbn) REFERENCES publishing.book(isbn);


--
-- TOC entry 5008 (class 2606 OID 17256)
-- Name: circulation circulation_isbn_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.circulation
    ADD CONSTRAINT circulation_isbn_fkey FOREIGN KEY (isbn) REFERENCES publishing.book(isbn);


--
-- TOC entry 5016 (class 2606 OID 16676)
-- Name: contract contract_id_customer_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.contract
    ADD CONSTRAINT contract_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES publishing.customer(id_customer);


--
-- TOC entry 5017 (class 2606 OID 16671)
-- Name: contract contract_id_manager_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.contract
    ADD CONSTRAINT contract_id_manager_fkey FOREIGN KEY (id_manager) REFERENCES publishing.employee(id_employee);


--
-- TOC entry 5018 (class 2606 OID 16666)
-- Name: contract contract_id_order_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.contract
    ADD CONSTRAINT contract_id_order_fkey FOREIGN KEY (id_order) REFERENCES publishing.orders(id_order);


--
-- TOC entry 5014 (class 2606 OID 16647)
-- Name: editing_ta editing_ta_id_editor_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.editing_ta
    ADD CONSTRAINT editing_ta_id_editor_fkey FOREIGN KEY (id_editor) REFERENCES publishing.employee(id_employee);


--
-- TOC entry 5015 (class 2606 OID 16642)
-- Name: editing_ta editing_ta_id_ta_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.editing_ta
    ADD CONSTRAINT editing_ta_id_ta_fkey FOREIGN KEY (id_ta) REFERENCES publishing.technical_assignment(id_ta);


--
-- TOC entry 5019 (class 2606 OID 16698)
-- Name: invoice invoice_id_contract_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.invoice
    ADD CONSTRAINT invoice_id_contract_fkey FOREIGN KEY (id_contract) REFERENCES publishing.contract(id_contract);


--
-- TOC entry 5011 (class 2606 OID 16591)
-- Name: order_item order_item_id_order_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.order_item
    ADD CONSTRAINT order_item_id_order_fkey FOREIGN KEY (id_order) REFERENCES publishing.orders(id_order);


--
-- TOC entry 5012 (class 2606 OID 17261)
-- Name: order_item order_item_isbn_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.order_item
    ADD CONSTRAINT order_item_isbn_fkey FOREIGN KEY (isbn) REFERENCES publishing.book(isbn);


--
-- TOC entry 5009 (class 2606 OID 16571)
-- Name: orders orders_id_customer_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.orders
    ADD CONSTRAINT orders_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES publishing.customer(id_customer);


--
-- TOC entry 5010 (class 2606 OID 16566)
-- Name: orders orders_id_manager_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.orders
    ADD CONSTRAINT orders_id_manager_fkey FOREIGN KEY (id_manager) REFERENCES publishing.employee(id_employee);


--
-- TOC entry 5013 (class 2606 OID 17266)
-- Name: technical_assignment technical_assignment_isbn_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.technical_assignment
    ADD CONSTRAINT technical_assignment_isbn_fkey FOREIGN KEY (isbn) REFERENCES publishing.book(isbn);


-- Completed on 2026-03-30 21:56:36

--
-- PostgreSQL database dump complete
--

\unrestrict v9kAJzyymsHgAKY5ESF0mjDYEFDuCmrFhPdAO7A1tvVcsg1nF3cJTa4S0JI3gUC

