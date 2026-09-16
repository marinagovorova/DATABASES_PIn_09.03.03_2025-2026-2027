--
-- PostgreSQL database dump
--

\restrict svgbmm39LBrme1dFbpp1Rr7LEJNrdDfkzX3QQ8s0frA2NIHo6JCysykxwN8WldK

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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
-- Name: customerorders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customerorders (
    orderno integer NOT NULL,
    customerid integer NOT NULL,
    orderdate date NOT NULL,
    shipdate date,
    tabno integer NOT NULL,
    CONSTRAINT customerorders_check CHECK ((shipdate >= orderdate))
);


ALTER TABLE public.customerorders OWNER TO postgres;

--
-- Name: customerorders_orderno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customerorders_orderno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customerorders_orderno_seq OWNER TO postgres;

--
-- Name: customerorders_orderno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customerorders_orderno_seq OWNED BY public.customerorders.orderno;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customerid integer NOT NULL,
    customername character varying(255) NOT NULL,
    customeraddress text,
    customerphone character varying(20),
    email character varying(255),
    CONSTRAINT customers_customerphone_check CHECK (((customerphone)::text ~ '^[0-9+\-() ]+$'::text)),
    CONSTRAINT customers_email_check CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_customerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customerid_seq OWNER TO postgres;

--
-- Name: customers_customerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customerid_seq OWNED BY public.customers.customerid;


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliveries (
    deliveryid integer NOT NULL,
    invoiceno character varying(100) NOT NULL,
    deliverydate date NOT NULL,
    supplierid integer NOT NULL,
    tabno integer NOT NULL,
    CONSTRAINT deliveries_deliverydate_check CHECK ((deliverydate <= CURRENT_DATE))
);


ALTER TABLE public.deliveries OWNER TO postgres;

--
-- Name: deliveries_deliveryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deliveries_deliveryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deliveries_deliveryid_seq OWNER TO postgres;

--
-- Name: deliveries_deliveryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deliveries_deliveryid_seq OWNED BY public.deliveries.deliveryid;


--
-- Name: deliveryitems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliveryitems (
    deliveryitemid integer NOT NULL,
    deliveryid integer NOT NULL,
    lineno integer NOT NULL,
    productid integer NOT NULL,
    quantity integer NOT NULL,
    purchaseprice numeric(15,2) NOT NULL,
    CONSTRAINT deliveryitems_purchaseprice_check CHECK ((purchaseprice > (0)::numeric)),
    CONSTRAINT deliveryitems_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.deliveryitems OWNER TO postgres;

--
-- Name: deliveryitems_deliveryitemid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deliveryitems_deliveryitemid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deliveryitems_deliveryitemid_seq OWNER TO postgres;

--
-- Name: deliveryitems_deliveryitemid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deliveryitems_deliveryitemid_seq OWNED BY public.deliveryitems.deliveryitemid;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    tabno integer NOT NULL,
    empid character varying(50) NOT NULL,
    fullname character varying(255) NOT NULL,
    passport character varying(50) NOT NULL,
    birthdate date,
    email character varying(255),
    phone character varying(20),
    positionid integer NOT NULL,
    CONSTRAINT employees_birthdate_check CHECK ((birthdate > '1900-01-01'::date)),
    CONSTRAINT employees_phone_check CHECK (((phone)::text ~ '^[0-9+\-() ]+$'::text))
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manufacturers (
    manufacturerid integer NOT NULL,
    manufacturername character varying(255) NOT NULL,
    manufactureraddress text
);


ALTER TABLE public.manufacturers OWNER TO postgres;

--
-- Name: manufacturers_manufacturerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manufacturers_manufacturerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.manufacturers_manufacturerid_seq OWNER TO postgres;

--
-- Name: manufacturers_manufacturerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manufacturers_manufacturerid_seq OWNED BY public.manufacturers.manufacturerid;


--
-- Name: orderitems; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderitems (
    orderitemid integer NOT NULL,
    orderno integer NOT NULL,
    lineno integer NOT NULL,
    productid integer NOT NULL,
    supplierid integer NOT NULL,
    batchno character varying(100),
    quantity integer NOT NULL,
    saleprice numeric(15,2) NOT NULL,
    CONSTRAINT orderitems_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.orderitems OWNER TO postgres;

--
-- Name: orderitems_orderitemid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orderitems_orderitemid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orderitems_orderitemid_seq OWNER TO postgres;

--
-- Name: orderitems_orderitemid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orderitems_orderitemid_seq OWNED BY public.orderitems.orderitemid;


--
-- Name: positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions (
    positionid integer NOT NULL,
    positionname character varying(255) NOT NULL,
    ratecount numeric(5,2) NOT NULL,
    CONSTRAINT positions_ratecount_check CHECK ((ratecount > (0)::numeric))
);


ALTER TABLE public.positions OWNER TO postgres;

--
-- Name: positions_positionid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.positions_positionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.positions_positionid_seq OWNER TO postgres;

--
-- Name: positions_positionid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.positions_positionid_seq OWNED BY public.positions.positionid;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    productid integer NOT NULL,
    productname character varying(255) NOT NULL,
    unit character varying(50) NOT NULL,
    description text,
    manufacturerid integer NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_productid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_productid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_productid_seq OWNER TO postgres;

--
-- Name: products_productid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_productid_seq OWNED BY public.products.productid;


--
-- Name: stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock (
    productid integer NOT NULL,
    stockqty integer NOT NULL,
    avgpurchaseprice numeric(15,2),
    currentsaleprice numeric(15,2),
    lastdeliverydate date,
    CONSTRAINT stock_avgpurchaseprice_check CHECK ((avgpurchaseprice >= (0)::numeric)),
    CONSTRAINT stock_currentsaleprice_check CHECK ((currentsaleprice >= (0)::numeric)),
    CONSTRAINT stock_stockqty_check CHECK ((stockqty >= 0))
);


ALTER TABLE public.stock OWNER TO postgres;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    supplierid integer NOT NULL,
    suppliername character varying(255) NOT NULL,
    supplieraddress text,
    supplierphone character varying(20),
    email character varying(255),
    CONSTRAINT suppliers_email_check CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text)),
    CONSTRAINT suppliers_supplierphone_check CHECK (((supplierphone)::text ~ '^[0-9+\-() ]+$'::text))
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: suppliers_supplierid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_supplierid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_supplierid_seq OWNER TO postgres;

--
-- Name: suppliers_supplierid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_supplierid_seq OWNED BY public.suppliers.supplierid;


--
-- Name: customerorders orderno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customerorders ALTER COLUMN orderno SET DEFAULT nextval('public.customerorders_orderno_seq'::regclass);


--
-- Name: customers customerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customerid SET DEFAULT nextval('public.customers_customerid_seq'::regclass);


--
-- Name: deliveries deliveryid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries ALTER COLUMN deliveryid SET DEFAULT nextval('public.deliveries_deliveryid_seq'::regclass);


--
-- Name: deliveryitems deliveryitemid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveryitems ALTER COLUMN deliveryitemid SET DEFAULT nextval('public.deliveryitems_deliveryitemid_seq'::regclass);


--
-- Name: manufacturers manufacturerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers ALTER COLUMN manufacturerid SET DEFAULT nextval('public.manufacturers_manufacturerid_seq'::regclass);


--
-- Name: orderitems orderitemid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitems ALTER COLUMN orderitemid SET DEFAULT nextval('public.orderitems_orderitemid_seq'::regclass);


--
-- Name: positions positionid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions ALTER COLUMN positionid SET DEFAULT nextval('public.positions_positionid_seq'::regclass);


--
-- Name: products productid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN productid SET DEFAULT nextval('public.products_productid_seq'::regclass);


--
-- Name: suppliers supplierid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN supplierid SET DEFAULT nextval('public.suppliers_supplierid_seq'::regclass);


--
-- Data for Name: customerorders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customerorders (orderno, customerid, orderdate, shipdate, tabno) FROM stdin;
1	1	2025-04-14	2025-04-15	101
2	2	2025-04-14	2025-04-16	102
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customerid, customername, customeraddress, customerphone, email) FROM stdin;
1	ООО "Розница-М"	г. Екатеринбург, ул. Ленина, 100	+7(343)222-33-44	shop@roznica.ru
2	ИП Петров	г. Нижний Новгород, ул. Советская, 8	+7(831)555-66-77	petrov@nn.ru
\.


--
-- Data for Name: deliveries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deliveries (deliveryid, invoiceno, deliverydate, supplierid, tabno) FROM stdin;
1	INV-001	2025-04-10	1	101
2	INV-002	2025-04-12	2	102
\.


--
-- Data for Name: deliveryitems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deliveryitems (deliveryitemid, deliveryid, lineno, productid, quantity, purchaseprice) FROM stdin;
1	1	1	1	50	45000.00
2	1	2	2	200	1200.00
3	2	1	1	30	46000.00
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (tabno, empid, fullname, passport, birthdate, email, phone, positionid) FROM stdin;
101	EMP001	Иванов Иван Иванович	1234 567890	1985-05-15	ivanov@company.ru	+7(812)111-22-33	1
102	EMP002	Петрова Мария Сергеевна	9876 543210	1990-10-20	petrova@company.ru	+7(812)444-55-66	2
\.


--
-- Data for Name: manufacturers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manufacturers (manufacturerid, manufacturername, manufactureraddress) FROM stdin;
1	ООО "Технопром"	г. Москва, ул. Ленина, 1
2	ЗАО "КомплектСервис"	г. Санкт-Петербург, Невский пр., 10
\.


--
-- Data for Name: orderitems; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orderitems (orderitemid, orderno, lineno, productid, supplierid, batchno, quantity, saleprice) FROM stdin;
1	1	1	1	1	BATCH-001	5	47250.00
2	1	2	2	1	BATCH-002	10	1260.00
3	2	1	1	2	BATCH-003	3	48300.00
\.


--
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.positions (positionid, positionname, ratecount) FROM stdin;
1	Менеджер по продажам	1.00
2	Логист	0.75
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (productid, productname, unit, description, manufacturerid) FROM stdin;
1	Ноутбук "SuperBook Pro"	шт.	Мощный ноутбук для работы	1
2	Мышь "ClickMaster"	шт.	Беспроводная мышь	2
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock (productid, stockqty, avgpurchaseprice, currentsaleprice, lastdeliverydate) FROM stdin;
1	75	45375.00	48300.00	2025-04-12
2	190	1200.00	1260.00	2025-04-10
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (supplierid, suppliername, supplieraddress, supplierphone, email) FROM stdin;
1	ООО "Поставка-Сервис"	г. Казань, ул. Гагарина, 5	+7(843)123-45-67	info@postavka.ru
2	ИП Иванов	г. Новосибирск, пр. Мира, 20	+7(383)987-65-43	ivanov@mail.ru
\.


--
-- Name: customerorders_orderno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customerorders_orderno_seq', 2, true);


--
-- Name: customers_customerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customerid_seq', 2, true);


--
-- Name: deliveries_deliveryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deliveries_deliveryid_seq', 2, true);


--
-- Name: deliveryitems_deliveryitemid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deliveryitems_deliveryitemid_seq', 3, true);


--
-- Name: manufacturers_manufacturerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manufacturers_manufacturerid_seq', 2, true);


--
-- Name: orderitems_orderitemid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orderitems_orderitemid_seq', 3, true);


--
-- Name: positions_positionid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.positions_positionid_seq', 2, true);


--
-- Name: products_productid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_productid_seq', 2, true);


--
-- Name: suppliers_supplierid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_supplierid_seq', 2, true);


--
-- Name: customerorders customerorders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customerorders
    ADD CONSTRAINT customerorders_pkey PRIMARY KEY (orderno);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customerid);


--
-- Name: deliveries deliveries_invoiceno_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_invoiceno_key UNIQUE (invoiceno);


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (deliveryid);


--
-- Name: deliveryitems deliveryitems_deliveryid_lineno_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveryitems
    ADD CONSTRAINT deliveryitems_deliveryid_lineno_key UNIQUE (deliveryid, lineno);


--
-- Name: deliveryitems deliveryitems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveryitems
    ADD CONSTRAINT deliveryitems_pkey PRIMARY KEY (deliveryitemid);


--
-- Name: employees employees_empid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_empid_key UNIQUE (empid);


--
-- Name: employees employees_passport_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_passport_key UNIQUE (passport);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (tabno);


--
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (manufacturerid);


--
-- Name: orderitems orderitems_orderno_lineno_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitems
    ADD CONSTRAINT orderitems_orderno_lineno_key UNIQUE (orderno, lineno);


--
-- Name: orderitems orderitems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitems
    ADD CONSTRAINT orderitems_pkey PRIMARY KEY (orderitemid);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (positionid);


--
-- Name: positions positions_positionname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_positionname_key UNIQUE (positionname);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (productid);


--
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (productid);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplierid);


--
-- Name: customerorders customerorders_customerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customerorders
    ADD CONSTRAINT customerorders_customerid_fkey FOREIGN KEY (customerid) REFERENCES public.customers(customerid);


--
-- Name: customerorders customerorders_tabno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customerorders
    ADD CONSTRAINT customerorders_tabno_fkey FOREIGN KEY (tabno) REFERENCES public.employees(tabno);


--
-- Name: deliveries deliveries_supplierid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_supplierid_fkey FOREIGN KEY (supplierid) REFERENCES public.suppliers(supplierid);


--
-- Name: deliveries deliveries_tabno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_tabno_fkey FOREIGN KEY (tabno) REFERENCES public.employees(tabno);


--
-- Name: deliveryitems deliveryitems_deliveryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveryitems
    ADD CONSTRAINT deliveryitems_deliveryid_fkey FOREIGN KEY (deliveryid) REFERENCES public.deliveries(deliveryid) ON DELETE CASCADE;


--
-- Name: deliveryitems deliveryitems_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveryitems
    ADD CONSTRAINT deliveryitems_productid_fkey FOREIGN KEY (productid) REFERENCES public.products(productid);


--
-- Name: employees employees_positionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_positionid_fkey FOREIGN KEY (positionid) REFERENCES public.positions(positionid);


--
-- Name: orderitems orderitems_orderno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitems
    ADD CONSTRAINT orderitems_orderno_fkey FOREIGN KEY (orderno) REFERENCES public.customerorders(orderno) ON DELETE CASCADE;


--
-- Name: orderitems orderitems_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitems
    ADD CONSTRAINT orderitems_productid_fkey FOREIGN KEY (productid) REFERENCES public.products(productid);


--
-- Name: orderitems orderitems_supplierid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderitems
    ADD CONSTRAINT orderitems_supplierid_fkey FOREIGN KEY (supplierid) REFERENCES public.suppliers(supplierid);


--
-- Name: products products_manufacturerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_manufacturerid_fkey FOREIGN KEY (manufacturerid) REFERENCES public.manufacturers(manufacturerid);


--
-- Name: stock stock_productid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_productid_fkey FOREIGN KEY (productid) REFERENCES public.products(productid) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict svgbmm39LBrme1dFbpp1Rr7LEJNrdDfkzX3QQ8s0frA2NIHo6JCysykxwN8WldK

