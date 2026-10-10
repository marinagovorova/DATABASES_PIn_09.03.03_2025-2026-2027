--
-- PostgreSQL database dump
--

\restrict cPnCGZ2EGTummOA8Za8WYW54YbbTxtLalxvrGxhx9gXpyKZb527n309klfP0YjQ

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-04-13 17:49:57 MSK

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
-- TOC entry 6 (class 2615 OID 16572)
-- Name: wb_schema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA wb_schema;


ALTER SCHEMA wb_schema OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 16592)
-- Name: buyer; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema.buyer (
    organization_id integer NOT NULL,
    company_name character varying(100) NOT NULL,
    address character varying(255)
);


ALTER TABLE wb_schema.buyer OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16591)
-- Name: buyer_organization_id_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.buyer_organization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.buyer_organization_id_seq OWNER TO postgres;

--
-- TOC entry 3947 (class 0 OID 0)
-- Dependencies: 224
-- Name: buyer_organization_id_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.buyer_organization_id_seq OWNED BY wb_schema.buyer.organization_id;


--
-- TOC entry 239 (class 1259 OID 16706)
-- Name: delivery; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema.delivery (
    delivery_id integer NOT NULL,
    supplier_id integer NOT NULL,
    personnel_number integer NOT NULL,
    delivery_date date NOT NULL,
    invoice_number character varying(20),
    batch_number character varying(50)
);


ALTER TABLE wb_schema.delivery OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16705)
-- Name: delivery_delivery_id_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.delivery_delivery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.delivery_delivery_id_seq OWNER TO postgres;

--
-- TOC entry 3948 (class 0 OID 0)
-- Dependencies: 238
-- Name: delivery_delivery_id_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.delivery_delivery_id_seq OWNED BY wb_schema.delivery.delivery_id;


--
-- TOC entry 241 (class 1259 OID 16727)
-- Name: delivery_item; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema.delivery_item (
    delivery_item_id integer NOT NULL,
    delivery_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_cost numeric(10,2) NOT NULL,
    CONSTRAINT delivery_item_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT delivery_item_unit_cost_check CHECK ((unit_cost > (0)::numeric))
);


ALTER TABLE wb_schema.delivery_item OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16726)
-- Name: delivery_item_delivery_item_id_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.delivery_item_delivery_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.delivery_item_delivery_item_id_seq OWNER TO postgres;

--
-- TOC entry 3949 (class 0 OID 0)
-- Dependencies: 240
-- Name: delivery_item_delivery_item_id_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.delivery_item_delivery_item_id_seq OWNED BY wb_schema.delivery_item.delivery_item_id;


--
-- TOC entry 231 (class 1259 OID 16621)
-- Name: employee; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema.employee (
    personnel_number integer NOT NULL,
    position_id integer NOT NULL,
    passport_data character varying(9)
);


ALTER TABLE wb_schema.employee OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16620)
-- Name: employee_personnel_number_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.employee_personnel_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.employee_personnel_number_seq OWNER TO postgres;

--
-- TOC entry 3950 (class 0 OID 0)
-- Dependencies: 230
-- Name: employee_personnel_number_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.employee_personnel_number_seq OWNED BY wb_schema.employee.personnel_number;


--
-- TOC entry 223 (class 1259 OID 16583)
-- Name: manufacturer; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema.manufacturer (
    manufacturer_id integer NOT NULL,
    company_name character varying(100) NOT NULL,
    address character varying(255)
);


ALTER TABLE wb_schema.manufacturer OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16582)
-- Name: manufacturer_manufacturer_id_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.manufacturer_manufacturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.manufacturer_manufacturer_id_seq OWNER TO postgres;

--
-- TOC entry 3951 (class 0 OID 0)
-- Dependencies: 222
-- Name: manufacturer_manufacturer_id_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.manufacturer_manufacturer_id_seq OWNED BY wb_schema.manufacturer.manufacturer_id;


--
-- TOC entry 235 (class 1259 OID 16660)
-- Name: order; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema."order" (
    order_id integer NOT NULL,
    organization_id integer NOT NULL,
    personnel_number integer NOT NULL,
    order_date date NOT NULL,
    pickup_date date,
    CONSTRAINT chk_dates CHECK (((pickup_date IS NULL) OR (pickup_date >= order_date)))
);


ALTER TABLE wb_schema."order" OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16682)
-- Name: order_item; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema.order_item (
    order_item_id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    CONSTRAINT order_item_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT order_item_unit_price_check CHECK ((unit_price > (0)::numeric))
);


ALTER TABLE wb_schema.order_item OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16681)
-- Name: order_item_order_item_id_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.order_item_order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.order_item_order_item_id_seq OWNER TO postgres;

--
-- TOC entry 3952 (class 0 OID 0)
-- Dependencies: 236
-- Name: order_item_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.order_item_order_item_id_seq OWNED BY wb_schema.order_item.order_item_id;


--
-- TOC entry 234 (class 1259 OID 16659)
-- Name: order_order_id_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.order_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.order_order_id_seq OWNER TO postgres;

--
-- TOC entry 3953 (class 0 OID 0)
-- Dependencies: 234
-- Name: order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.order_order_id_seq OWNED BY wb_schema."order".order_id;


--
-- TOC entry 229 (class 1259 OID 16610)
-- Name: position; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema."position" (
    position_id integer NOT NULL,
    position_name character varying(50) NOT NULL,
    slot_count integer NOT NULL,
    CONSTRAINT position_slot_count_check CHECK ((slot_count > 0))
);


ALTER TABLE wb_schema."position" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16609)
-- Name: position_position_id_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.position_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.position_position_id_seq OWNER TO postgres;

--
-- TOC entry 3954 (class 0 OID 0)
-- Dependencies: 228
-- Name: position_position_id_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.position_position_id_seq OWNED BY wb_schema."position".position_id;


--
-- TOC entry 233 (class 1259 OID 16637)
-- Name: product; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema.product (
    product_id integer NOT NULL,
    unit_id integer NOT NULL,
    manufacturer_id integer NOT NULL,
    name character varying(255) NOT NULL,
    notes text
);


ALTER TABLE wb_schema.product OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16636)
-- Name: product_product_id_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.product_product_id_seq OWNER TO postgres;

--
-- TOC entry 3955 (class 0 OID 0)
-- Dependencies: 232
-- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.product_product_id_seq OWNED BY wb_schema.product.product_id;


--
-- TOC entry 227 (class 1259 OID 16601)
-- Name: supplier; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema.supplier (
    supplier_id integer NOT NULL,
    company_name character varying(100) NOT NULL,
    address character varying(255)
);


ALTER TABLE wb_schema.supplier OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16600)
-- Name: supplier_supplier_id_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.supplier_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.supplier_supplier_id_seq OWNER TO postgres;

--
-- TOC entry 3956 (class 0 OID 0)
-- Dependencies: 226
-- Name: supplier_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.supplier_supplier_id_seq OWNED BY wb_schema.supplier.supplier_id;


--
-- TOC entry 221 (class 1259 OID 16574)
-- Name: unit_of_measure; Type: TABLE; Schema: wb_schema; Owner: postgres
--

CREATE TABLE wb_schema.unit_of_measure (
    unit_id integer NOT NULL,
    name character varying(10) NOT NULL
);


ALTER TABLE wb_schema.unit_of_measure OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16573)
-- Name: unit_of_measure_unit_id_seq; Type: SEQUENCE; Schema: wb_schema; Owner: postgres
--

CREATE SEQUENCE wb_schema.unit_of_measure_unit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wb_schema.unit_of_measure_unit_id_seq OWNER TO postgres;

--
-- TOC entry 3957 (class 0 OID 0)
-- Dependencies: 220
-- Name: unit_of_measure_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: wb_schema; Owner: postgres
--

ALTER SEQUENCE wb_schema.unit_of_measure_unit_id_seq OWNED BY wb_schema.unit_of_measure.unit_id;


--
-- TOC entry 3723 (class 2604 OID 16595)
-- Name: buyer organization_id; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.buyer ALTER COLUMN organization_id SET DEFAULT nextval('wb_schema.buyer_organization_id_seq'::regclass);


--
-- TOC entry 3730 (class 2604 OID 16709)
-- Name: delivery delivery_id; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.delivery ALTER COLUMN delivery_id SET DEFAULT nextval('wb_schema.delivery_delivery_id_seq'::regclass);


--
-- TOC entry 3731 (class 2604 OID 16730)
-- Name: delivery_item delivery_item_id; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.delivery_item ALTER COLUMN delivery_item_id SET DEFAULT nextval('wb_schema.delivery_item_delivery_item_id_seq'::regclass);


--
-- TOC entry 3726 (class 2604 OID 16624)
-- Name: employee personnel_number; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.employee ALTER COLUMN personnel_number SET DEFAULT nextval('wb_schema.employee_personnel_number_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 16586)
-- Name: manufacturer manufacturer_id; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.manufacturer ALTER COLUMN manufacturer_id SET DEFAULT nextval('wb_schema.manufacturer_manufacturer_id_seq'::regclass);


--
-- TOC entry 3728 (class 2604 OID 16663)
-- Name: order order_id; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema."order" ALTER COLUMN order_id SET DEFAULT nextval('wb_schema.order_order_id_seq'::regclass);


--
-- TOC entry 3729 (class 2604 OID 16685)
-- Name: order_item order_item_id; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.order_item ALTER COLUMN order_item_id SET DEFAULT nextval('wb_schema.order_item_order_item_id_seq'::regclass);


--
-- TOC entry 3725 (class 2604 OID 16613)
-- Name: position position_id; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema."position" ALTER COLUMN position_id SET DEFAULT nextval('wb_schema.position_position_id_seq'::regclass);


--
-- TOC entry 3727 (class 2604 OID 16640)
-- Name: product product_id; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.product ALTER COLUMN product_id SET DEFAULT nextval('wb_schema.product_product_id_seq'::regclass);


--
-- TOC entry 3724 (class 2604 OID 16604)
-- Name: supplier supplier_id; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.supplier ALTER COLUMN supplier_id SET DEFAULT nextval('wb_schema.supplier_supplier_id_seq'::regclass);


--
-- TOC entry 3721 (class 2604 OID 16577)
-- Name: unit_of_measure unit_id; Type: DEFAULT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.unit_of_measure ALTER COLUMN unit_id SET DEFAULT nextval('wb_schema.unit_of_measure_unit_id_seq'::regclass);


--
-- TOC entry 3925 (class 0 OID 16592)
-- Dependencies: 225
-- Data for Name: buyer; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema.buyer (organization_id, company_name, address) FROM stdin;
1	ООО Технологии	Москва, ул. Ленина 1
2	ЗАО Прогресс	Санкт-Петербург, пр. Невский 10
3	ИП Иванов	Казань, ул. Баумана 5
\.


--
-- TOC entry 3939 (class 0 OID 16706)
-- Dependencies: 239
-- Data for Name: delivery; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema.delivery (delivery_id, supplier_id, personnel_number, delivery_date, invoice_number, batch_number) FROM stdin;
1	1	3	2024-01-10	СЧ-001	ПАР-2024-001
2	2	3	2024-02-05	СЧ-002	ПАР-2024-002
3	3	4	2024-03-01	СЧ-003	ПАР-2024-003
\.


--
-- TOC entry 3941 (class 0 OID 16727)
-- Dependencies: 241
-- Data for Name: delivery_item; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema.delivery_item (delivery_item_id, delivery_id, product_id, quantity, unit_cost) FROM stdin;
1	1	1	5	75000.00
2	1	2	10	95000.00
3	2	3	3	45000.00
4	2	4	6	22000.00
5	3	5	10	9500.00
\.


--
-- TOC entry 3931 (class 0 OID 16621)
-- Dependencies: 231
-- Data for Name: employee; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema.employee (personnel_number, position_id, passport_data) FROM stdin;
1	1	АА123456
2	1	ББ234567
3	2	ВВ345678
4	2	ГГ456789
5	3	ДД567890
\.


--
-- TOC entry 3923 (class 0 OID 16583)
-- Dependencies: 223
-- Data for Name: manufacturer; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema.manufacturer (manufacturer_id, company_name, address) FROM stdin;
1	Samsung Electronics	Южная Корея, Сеул
2	Apple Inc	США, Купертино
3	LG Electronics	Южная Корея, Сеул
4	Sony Corporation	Япония, Токио
5	Bosch GmbH	Германия, Штутгарт
\.


--
-- TOC entry 3935 (class 0 OID 16660)
-- Dependencies: 235
-- Data for Name: order; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema."order" (order_id, organization_id, personnel_number, order_date, pickup_date) FROM stdin;
1	1	1	2024-01-15	2024-01-20
2	2	2	2024-02-10	2024-02-15
3	3	1	2024-03-05	2024-03-10
\.


--
-- TOC entry 3937 (class 0 OID 16682)
-- Dependencies: 237
-- Data for Name: order_item; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema.order_item (order_item_id, order_id, product_id, quantity, unit_price) FROM stdin;
1	1	1	2	89990.00
2	1	2	3	119990.00
3	2	3	1	54990.00
4	2	4	2	29990.00
5	3	5	4	12990.00
\.


--
-- TOC entry 3929 (class 0 OID 16610)
-- Dependencies: 229
-- Data for Name: position; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema."position" (position_id, position_name, slot_count) FROM stdin;
1	Менеджер по продажам	5
2	Менеджер по поставкам	3
3	Бухгалтер	2
4	Директор	1
\.


--
-- TOC entry 3933 (class 0 OID 16637)
-- Dependencies: 233
-- Data for Name: product; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema.product (product_id, unit_id, manufacturer_id, name, notes) FROM stdin;
1	1	1	Телевизор Samsung 55"	OLED, 4K
2	1	2	iPhone 15 Pro	256GB, черный
3	1	3	Холодильник LG	двухкамерный
4	1	4	Наушники Sony WH-1000XM5	с шумоподавлением
5	1	5	Дрель Bosch GSB 21-2	ударная
\.


--
-- TOC entry 3927 (class 0 OID 16601)
-- Dependencies: 227
-- Data for Name: supplier; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema.supplier (supplier_id, company_name, address) FROM stdin;
1	ООО Поставка Плюс	Москва, ул. Тверская 20
2	ЗАО ТехСнаб	Новосибирск, ул. Красный пр. 15
3	ИП Петров	Екатеринбург, ул. Малышева 3
\.


--
-- TOC entry 3921 (class 0 OID 16574)
-- Dependencies: 221
-- Data for Name: unit_of_measure; Type: TABLE DATA; Schema: wb_schema; Owner: postgres
--

COPY wb_schema.unit_of_measure (unit_id, name) FROM stdin;
1	шт
2	кг
3	л
4	м
5	упак
\.


--
-- TOC entry 3958 (class 0 OID 0)
-- Dependencies: 224
-- Name: buyer_organization_id_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.buyer_organization_id_seq', 3, true);


--
-- TOC entry 3959 (class 0 OID 0)
-- Dependencies: 238
-- Name: delivery_delivery_id_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.delivery_delivery_id_seq', 3, true);


--
-- TOC entry 3960 (class 0 OID 0)
-- Dependencies: 240
-- Name: delivery_item_delivery_item_id_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.delivery_item_delivery_item_id_seq', 5, true);


--
-- TOC entry 3961 (class 0 OID 0)
-- Dependencies: 230
-- Name: employee_personnel_number_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.employee_personnel_number_seq', 5, true);


--
-- TOC entry 3962 (class 0 OID 0)
-- Dependencies: 222
-- Name: manufacturer_manufacturer_id_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.manufacturer_manufacturer_id_seq', 5, true);


--
-- TOC entry 3963 (class 0 OID 0)
-- Dependencies: 236
-- Name: order_item_order_item_id_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.order_item_order_item_id_seq', 5, true);


--
-- TOC entry 3964 (class 0 OID 0)
-- Dependencies: 234
-- Name: order_order_id_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.order_order_id_seq', 3, true);


--
-- TOC entry 3965 (class 0 OID 0)
-- Dependencies: 228
-- Name: position_position_id_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.position_position_id_seq', 4, true);


--
-- TOC entry 3966 (class 0 OID 0)
-- Dependencies: 232
-- Name: product_product_id_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.product_product_id_seq', 5, true);


--
-- TOC entry 3967 (class 0 OID 0)
-- Dependencies: 226
-- Name: supplier_supplier_id_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.supplier_supplier_id_seq', 3, true);


--
-- TOC entry 3968 (class 0 OID 0)
-- Dependencies: 220
-- Name: unit_of_measure_unit_id_seq; Type: SEQUENCE SET; Schema: wb_schema; Owner: postgres
--

SELECT pg_catalog.setval('wb_schema.unit_of_measure_unit_id_seq', 5, true);


--
-- TOC entry 3743 (class 2606 OID 16599)
-- Name: buyer buyer_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.buyer
    ADD CONSTRAINT buyer_pkey PRIMARY KEY (organization_id);


--
-- TOC entry 3761 (class 2606 OID 16739)
-- Name: delivery_item delivery_item_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.delivery_item
    ADD CONSTRAINT delivery_item_pkey PRIMARY KEY (delivery_item_id);


--
-- TOC entry 3759 (class 2606 OID 16715)
-- Name: delivery delivery_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.delivery
    ADD CONSTRAINT delivery_pkey PRIMARY KEY (delivery_id);


--
-- TOC entry 3749 (class 2606 OID 16630)
-- Name: employee employee_passport_data_key; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.employee
    ADD CONSTRAINT employee_passport_data_key UNIQUE (passport_data);


--
-- TOC entry 3751 (class 2606 OID 16628)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (personnel_number);


--
-- TOC entry 3741 (class 2606 OID 16590)
-- Name: manufacturer manufacturer_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.manufacturer
    ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (manufacturer_id);


--
-- TOC entry 3757 (class 2606 OID 16694)
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (order_item_id);


--
-- TOC entry 3755 (class 2606 OID 16670)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (order_id);


--
-- TOC entry 3747 (class 2606 OID 16619)
-- Name: position position_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (position_id);


--
-- TOC entry 3753 (class 2606 OID 16648)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- TOC entry 3745 (class 2606 OID 16608)
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (supplier_id);


--
-- TOC entry 3739 (class 2606 OID 16581)
-- Name: unit_of_measure unit_of_measure_pkey; Type: CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.unit_of_measure
    ADD CONSTRAINT unit_of_measure_pkey PRIMARY KEY (unit_id);


--
-- TOC entry 3771 (class 2606 OID 16740)
-- Name: delivery_item delivery_item_delivery_id_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.delivery_item
    ADD CONSTRAINT delivery_item_delivery_id_fkey FOREIGN KEY (delivery_id) REFERENCES wb_schema.delivery(delivery_id);


--
-- TOC entry 3772 (class 2606 OID 16745)
-- Name: delivery_item delivery_item_product_id_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.delivery_item
    ADD CONSTRAINT delivery_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES wb_schema.product(product_id);


--
-- TOC entry 3769 (class 2606 OID 16721)
-- Name: delivery delivery_personnel_number_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.delivery
    ADD CONSTRAINT delivery_personnel_number_fkey FOREIGN KEY (personnel_number) REFERENCES wb_schema.employee(personnel_number);


--
-- TOC entry 3770 (class 2606 OID 16716)
-- Name: delivery delivery_supplier_id_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.delivery
    ADD CONSTRAINT delivery_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES wb_schema.supplier(supplier_id);


--
-- TOC entry 3762 (class 2606 OID 16631)
-- Name: employee employee_position_id_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.employee
    ADD CONSTRAINT employee_position_id_fkey FOREIGN KEY (position_id) REFERENCES wb_schema."position"(position_id);


--
-- TOC entry 3767 (class 2606 OID 16695)
-- Name: order_item order_item_order_id_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.order_item
    ADD CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id) REFERENCES wb_schema."order"(order_id);


--
-- TOC entry 3768 (class 2606 OID 16700)
-- Name: order_item order_item_product_id_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.order_item
    ADD CONSTRAINT order_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES wb_schema.product(product_id);


--
-- TOC entry 3765 (class 2606 OID 16671)
-- Name: order order_organization_id_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema."order"
    ADD CONSTRAINT order_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES wb_schema.buyer(organization_id);


--
-- TOC entry 3766 (class 2606 OID 16676)
-- Name: order order_personnel_number_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema."order"
    ADD CONSTRAINT order_personnel_number_fkey FOREIGN KEY (personnel_number) REFERENCES wb_schema.employee(personnel_number);


--
-- TOC entry 3763 (class 2606 OID 16654)
-- Name: product product_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.product
    ADD CONSTRAINT product_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES wb_schema.manufacturer(manufacturer_id);


--
-- TOC entry 3764 (class 2606 OID 16649)
-- Name: product product_unit_id_fkey; Type: FK CONSTRAINT; Schema: wb_schema; Owner: postgres
--

ALTER TABLE ONLY wb_schema.product
    ADD CONSTRAINT product_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES wb_schema.unit_of_measure(unit_id);


-- Completed on 2026-04-13 17:49:57 MSK

--
-- PostgreSQL database dump complete
--

\unrestrict cPnCGZ2EGTummOA8Za8WYW54YbbTxtLalxvrGxhx9gXpyKZb527n309klfP0YjQ

