--
-- PostgreSQL database dump
--

\restrict EHcnjI78eMfeO4Hymj1Wwn5J8FmTC1GQeUAS3hdVQavbJJdl6IEZ9hrkhgTj5EN

-- Dumped from database version 18.3 (Postgres.app)
-- Dumped by pg_dump version 18.0

-- Started on 2026-04-27 14:22:05 MSK

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
-- TOC entry 6 (class 2615 OID 16897)
-- Name: wholesale; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA wholesale;


ALTER SCHEMA wholesale OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 16999)
-- Name: contracts; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.contracts (
    contract_number character varying(20) NOT NULL,
    contract_date date NOT NULL,
    position_id integer NOT NULL,
    contract_type character varying(50) NOT NULL,
    validity_period integer NOT NULL,
    contract_kind character varying(50) NOT NULL,
    employee_id integer NOT NULL,
    CONSTRAINT chk_contracts_kind CHECK (((contract_kind)::text = ANY ((ARRAY['One-time'::character varying, 'Long-term'::character varying])::text[]))),
    CONSTRAINT chk_contracts_type CHECK (((contract_type)::text = ANY ((ARRAY['Supply'::character varying, 'Sale'::character varying, 'Mixed'::character varying])::text[]))),
    CONSTRAINT chk_contracts_validity_period CHECK ((validity_period > 0))
);


ALTER TABLE wholesale.contracts OWNER TO postgres;

--
-- TOC entry 3923 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE contracts; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.contracts IS 'Contracts used for supplies and sales';


--
-- TOC entry 223 (class 1259 OID 16925)
-- Name: customers; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.customers (
    customer_id integer NOT NULL,
    customer_name character varying(100) NOT NULL,
    address character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(100) NOT NULL,
    customer_inn character varying(12) NOT NULL,
    CONSTRAINT chk_customers_email CHECK (((email)::text ~~ '%@%'::text)),
    CONSTRAINT chk_customers_inn CHECK ((((customer_inn)::text ~ '^[0-9]{10}$'::text) OR ((customer_inn)::text ~ '^[0-9]{12}$'::text))),
    CONSTRAINT chk_customers_phone CHECK (((phone)::text ~ '^\+7\([0-9]{3}\)[0-9]{3}-[0-9]{2}-[0-9]{2}$'::text))
);


ALTER TABLE wholesale.customers OWNER TO postgres;

--
-- TOC entry 3924 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE customers; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.customers IS 'Customers purchasing products from the wholesale base';


--
-- TOC entry 222 (class 1259 OID 16924)
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.customers ALTER COLUMN customer_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.customers_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 16972)
-- Name: employees; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.employees (
    employee_id integer NOT NULL,
    personnel_number integer NOT NULL,
    full_name character varying(100) NOT NULL,
    passport_data character varying(50) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(100) NOT NULL,
    position_id integer NOT NULL,
    CONSTRAINT chk_employees_email CHECK (((email)::text ~~ '%@%'::text)),
    CONSTRAINT chk_employees_phone CHECK (((phone)::text ~ '^\+7\([0-9]{3}\)[0-9]{3}-[0-9]{2}-[0-9]{2}$'::text))
);


ALTER TABLE wholesale.employees OWNER TO postgres;

--
-- TOC entry 3925 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE employees; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.employees IS 'Employees of the wholesale base';


--
-- TOC entry 228 (class 1259 OID 16971)
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.employees ALTER COLUMN employee_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.employees_employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 16899)
-- Name: manufacturers; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.manufacturers (
    manufacturer_id integer NOT NULL,
    manufacturer_name character varying(100) NOT NULL,
    manufacturer_inn character varying(12) NOT NULL,
    email character varying(100) NOT NULL,
    country character varying(50) NOT NULL,
    address character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    CONSTRAINT chk_manufacturers_email CHECK (((email)::text ~~ '%@%'::text)),
    CONSTRAINT chk_manufacturers_inn CHECK ((((manufacturer_inn)::text ~ '^[0-9]{10}$'::text) OR ((manufacturer_inn)::text ~ '^[0-9]{12}$'::text))),
    CONSTRAINT chk_manufacturers_phone CHECK (((phone)::text ~ '^\+7\([0-9]{3}\)[0-9]{3}-[0-9]{2}-[0-9]{2}$'::text))
);


ALTER TABLE wholesale.manufacturers OWNER TO postgres;

--
-- TOC entry 3926 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE manufacturers; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.manufacturers IS 'Manufacturers of products';


--
-- TOC entry 220 (class 1259 OID 16898)
-- Name: manufacturers_manufacturer_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.manufacturers ALTER COLUMN manufacturer_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.manufacturers_manufacturer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 16959)
-- Name: measurement_units; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.measurement_units (
    unit_id integer NOT NULL,
    unit_name character varying(50) NOT NULL,
    unit_symbol character varying(10) NOT NULL
);


ALTER TABLE wholesale.measurement_units OWNER TO postgres;

--
-- TOC entry 3927 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE measurement_units; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.measurement_units IS 'Product measurement units';


--
-- TOC entry 226 (class 1259 OID 16958)
-- Name: measurement_units_unit_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.measurement_units ALTER COLUMN unit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.measurement_units_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 246 (class 1259 OID 17195)
-- Name: order_invoices; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.order_invoices (
    invoice_id integer NOT NULL,
    order_id integer NOT NULL,
    invoice_amount numeric(12,2) NOT NULL,
    invoice_status character varying(30) NOT NULL,
    creation_date date NOT NULL,
    payment_date date,
    CONSTRAINT chk_order_invoices_amount CHECK ((invoice_amount > (0)::numeric)),
    CONSTRAINT chk_order_invoices_payment_date CHECK (((payment_date IS NULL) OR (payment_date >= creation_date))),
    CONSTRAINT chk_order_invoices_status CHECK (((invoice_status)::text = ANY ((ARRAY['Created'::character varying, 'Paid'::character varying, 'Overdue'::character varying, 'Cancelled'::character varying])::text[])))
);


ALTER TABLE wholesale.order_invoices OWNER TO postgres;

--
-- TOC entry 3928 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE order_invoices; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.order_invoices IS 'Invoices related to customer orders';


--
-- TOC entry 245 (class 1259 OID 17194)
-- Name: order_invoices_invoice_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.order_invoices ALTER COLUMN invoice_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.order_invoices_invoice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 17145)
-- Name: order_items; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.order_items (
    order_item_id integer NOT NULL,
    supply_id integer NOT NULL,
    product_id integer NOT NULL,
    batch_number character varying(20) NOT NULL,
    ordered_quantity numeric(12,3) NOT NULL,
    sale_unit_price numeric(12,2) NOT NULL,
    CONSTRAINT chk_order_items_quantity CHECK ((ordered_quantity > (0)::numeric)),
    CONSTRAINT chk_order_items_sale_price CHECK ((sale_unit_price > (0)::numeric))
);


ALTER TABLE wholesale.order_items OWNER TO postgres;

--
-- TOC entry 3929 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE order_items; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.order_items IS 'Products included in customer orders';


--
-- TOC entry 241 (class 1259 OID 17144)
-- Name: order_items_order_item_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.order_items ALTER COLUMN order_item_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.order_items_order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 240 (class 1259 OID 17123)
-- Name: orders; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.orders (
    order_id integer NOT NULL,
    order_status character varying(30) NOT NULL,
    customer_id integer NOT NULL,
    contract_number character varying(20) NOT NULL,
    order_date date NOT NULL,
    CONSTRAINT chk_orders_status CHECK (((order_status)::text = ANY ((ARRAY['Created'::character varying, 'Paid'::character varying, 'Assembled'::character varying, 'Picked up'::character varying, 'Cancelled'::character varying])::text[])))
);


ALTER TABLE wholesale.orders OWNER TO postgres;

--
-- TOC entry 3930 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE orders; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.orders IS 'Customer orders';


--
-- TOC entry 239 (class 1259 OID 17122)
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.orders ALTER COLUMN order_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 16946)
-- Name: positions; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.positions (
    position_id integer NOT NULL,
    position_name character varying(100) NOT NULL,
    duties character varying(255) NOT NULL,
    salary numeric(12,2) NOT NULL,
    CONSTRAINT chk_positions_salary CHECK ((salary >= (0)::numeric))
);


ALTER TABLE wholesale.positions OWNER TO postgres;

--
-- TOC entry 3931 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE positions; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.positions IS 'Employee positions';


--
-- TOC entry 224 (class 1259 OID 16945)
-- Name: positions_position_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.positions ALTER COLUMN position_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.positions_position_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 17044)
-- Name: products; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.products (
    product_id integer NOT NULL,
    manufacturer_id integer NOT NULL,
    unit_id integer NOT NULL,
    product_name character varying(100) NOT NULL,
    product_description character varying(255) NOT NULL,
    product_category character varying(50) NOT NULL
);


ALTER TABLE wholesale.products OWNER TO postgres;

--
-- TOC entry 3932 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE products; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.products IS 'Products purchased and sold by the wholesale base';


--
-- TOC entry 233 (class 1259 OID 17043)
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.products ALTER COLUMN product_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.products_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 17025)
-- Name: suppliers; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.suppliers (
    supplier_id integer NOT NULL,
    supplier_name character varying(100) NOT NULL,
    address character varying(255) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(100) NOT NULL,
    CONSTRAINT chk_suppliers_email CHECK (((email)::text ~~ '%@%'::text)),
    CONSTRAINT chk_suppliers_phone CHECK (((phone)::text ~ '^\+7\([0-9]{3}\)[0-9]{3}-[0-9]{2}-[0-9]{2}$'::text))
);


ALTER TABLE wholesale.suppliers OWNER TO postgres;

--
-- TOC entry 3933 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE suppliers; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.suppliers IS 'Supplier companies';


--
-- TOC entry 231 (class 1259 OID 17024)
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.suppliers ALTER COLUMN supplier_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.suppliers_supplier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 17068)
-- Name: supplies; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.supplies (
    supply_id integer NOT NULL,
    supplier_id integer NOT NULL,
    contract_number character varying(20) NOT NULL,
    invoice_id integer,
    supply_date date NOT NULL,
    status character varying(30) NOT NULL,
    description character varying(255) NOT NULL,
    waybill_number character varying(20) NOT NULL,
    actual_supply_date date,
    CONSTRAINT chk_supplies_actual_date CHECK (((actual_supply_date IS NULL) OR (actual_supply_date >= supply_date))),
    CONSTRAINT chk_supplies_status CHECK (((status)::text = ANY ((ARRAY['Planned'::character varying, 'In transit'::character varying, 'Received'::character varying, 'Cancelled'::character varying])::text[])))
);


ALTER TABLE wholesale.supplies OWNER TO postgres;

--
-- TOC entry 3934 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE supplies; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.supplies IS 'Product supplies to the wholesale base';


--
-- TOC entry 235 (class 1259 OID 17067)
-- Name: supplies_supply_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.supplies ALTER COLUMN supply_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.supplies_supply_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 17169)
-- Name: supply_invoices; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.supply_invoices (
    invoice_id integer NOT NULL,
    supply_id integer NOT NULL,
    invoice_amount numeric(12,2) NOT NULL,
    invoice_status character varying(30) NOT NULL,
    creation_date date NOT NULL,
    payment_date date,
    CONSTRAINT chk_supply_invoices_amount CHECK ((invoice_amount > (0)::numeric)),
    CONSTRAINT chk_supply_invoices_payment_date CHECK (((payment_date IS NULL) OR (payment_date >= creation_date))),
    CONSTRAINT chk_supply_invoices_status CHECK (((invoice_status)::text = ANY ((ARRAY['Created'::character varying, 'Paid'::character varying, 'Overdue'::character varying, 'Cancelled'::character varying])::text[])))
);


ALTER TABLE wholesale.supply_invoices OWNER TO postgres;

--
-- TOC entry 3935 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE supply_invoices; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.supply_invoices IS 'Invoices related to supplies';


--
-- TOC entry 243 (class 1259 OID 17168)
-- Name: supply_invoices_invoice_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.supply_invoices ALTER COLUMN invoice_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.supply_invoices_invoice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 17095)
-- Name: supply_items; Type: TABLE; Schema: wholesale; Owner: postgres
--

CREATE TABLE wholesale.supply_items (
    supply_item_id integer NOT NULL,
    supply_id integer NOT NULL,
    product_id integer NOT NULL,
    batch_number character varying(20) NOT NULL,
    supplied_quantity numeric(12,3) NOT NULL,
    purchase_unit_price numeric(12,2) NOT NULL,
    remaining_stock_quantity numeric(12,3) NOT NULL,
    CONSTRAINT chk_supply_items_price CHECK ((purchase_unit_price > (0)::numeric)),
    CONSTRAINT chk_supply_items_quantity CHECK ((supplied_quantity > (0)::numeric)),
    CONSTRAINT chk_supply_items_remaining_stock CHECK (((remaining_stock_quantity >= (0)::numeric) AND (remaining_stock_quantity <= supplied_quantity)))
);


ALTER TABLE wholesale.supply_items OWNER TO postgres;

--
-- TOC entry 3936 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE supply_items; Type: COMMENT; Schema: wholesale; Owner: postgres
--

COMMENT ON TABLE wholesale.supply_items IS 'Products and batches included in supplies';


--
-- TOC entry 237 (class 1259 OID 17094)
-- Name: supply_items_supply_item_id_seq; Type: SEQUENCE; Schema: wholesale; Owner: postgres
--

ALTER TABLE wholesale.supply_items ALTER COLUMN supply_item_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME wholesale.supply_items_supply_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3901 (class 0 OID 16999)
-- Dependencies: 230
-- Data for Name: contracts; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.contracts (contract_number, contract_date, position_id, contract_type, validity_period, contract_kind, employee_id) FROM stdin;
SUP-2025-001	2025-02-01	1	Supply	365	Long-term	1
SALE-2025-001	2025-02-10	2	Sale	180	Long-term	2
MIX-2025-001	2025-03-01	1	Mixed	90	One-time	1
\.


--
-- TOC entry 3894 (class 0 OID 16925)
-- Dependencies: 223
-- Data for Name: customers; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.customers (customer_id, customer_name, address, phone, email, customer_inn) FROM stdin;
1	Retail Market LLC	Saint Petersburg, Sadovaya St, 8	+7(812)444-55-66	orders@retailmarket.ru	7801112233
2	North Trade JSC	Murmansk, Mira St, 12	+7(815)555-66-77	purchase@northtrade.ru	5101234567
3	City Store LLC	Kazan, Bauman St, 20	+7(843)666-77-88	supply@citystore.ru	1609876543
\.


--
-- TOC entry 3900 (class 0 OID 16972)
-- Dependencies: 229
-- Data for Name: employees; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.employees (employee_id, personnel_number, full_name, passport_data, phone, email, position_id) FROM stdin;
1	1001	Ivan Petrov	4012 123456	+7(921)111-22-33	petrov@wholesale.ru	1
2	1002	Anna Smirnova	4013 234567	+7(921)222-33-44	smirnova@wholesale.ru	2
3	1003	Pavel Ivanov	4014 345678	+7(921)333-44-55	ivanov@wholesale.ru	3
\.


--
-- TOC entry 3892 (class 0 OID 16899)
-- Dependencies: 221
-- Data for Name: manufacturers; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.manufacturers (manufacturer_id, manufacturer_name, manufacturer_inn, email, country, address, phone) FROM stdin;
1	TechProm LLC	7812345678	info@techprom.ru	Russia	Saint Petersburg, Nevsky Ave, 10	+7(812)111-22-33
2	FoodLine JSC	7701234567	sales@foodline.ru	Russia	Moscow, Tverskaya St, 15	+7(495)222-33-44
3	OfficeWorld LLC	540987654321	contact@officeworld.ru	Russia	Novosibirsk, Lenina St, 25	+7(383)333-44-55
\.


--
-- TOC entry 3898 (class 0 OID 16959)
-- Dependencies: 227
-- Data for Name: measurement_units; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.measurement_units (unit_id, unit_name, unit_symbol) FROM stdin;
1	Piece	pcs
2	Kilogram	kg
3	Box	box
\.


--
-- TOC entry 3917 (class 0 OID 17195)
-- Dependencies: 246
-- Data for Name: order_invoices; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.order_invoices (invoice_id, order_id, invoice_amount, invoice_status, creation_date, payment_date) FROM stdin;
1	1	360000.00	Paid	2025-03-12	2025-03-13
2	2	4550.00	Created	2025-03-13	\N
3	3	27000.00	Paid	2025-03-14	2025-03-15
\.


--
-- TOC entry 3913 (class 0 OID 17145)
-- Dependencies: 242
-- Data for Name: order_items; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.order_items (order_item_id, supply_id, product_id, batch_number, ordered_quantity, sale_unit_price) FROM stdin;
1	1	1	BATCH-LAP-001	5.000	72000.00
2	2	2	BATCH-SUG-001	70.000	65.00
3	3	3	BATCH-PAP-001	20.000	1350.00
\.


--
-- TOC entry 3911 (class 0 OID 17123)
-- Dependencies: 240
-- Data for Name: orders; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.orders (order_id, order_status, customer_id, contract_number, order_date) FROM stdin;
1	Paid	1	SALE-2025-001	2025-03-12
2	Created	2	SALE-2025-001	2025-03-13
3	Assembled	3	MIX-2025-001	2025-03-14
\.


--
-- TOC entry 3896 (class 0 OID 16946)
-- Dependencies: 225
-- Data for Name: positions; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.positions (position_id, position_name, duties, salary) FROM stdin;
1	Supply Manager	Processing supplier contracts and controlling product deliveries	85000.00
2	Sales Manager	Processing customer orders and preparing sales documents	90000.00
3	Warehouse Manager	Controlling warehouse stock and product batches	78000.00
\.


--
-- TOC entry 3905 (class 0 OID 17044)
-- Dependencies: 234
-- Data for Name: products; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.products (product_id, manufacturer_id, unit_id, product_name, product_description, product_category) FROM stdin;
1	1	1	Laptop Model A	Business laptop with 16 GB RAM and SSD storage	Electronics
2	2	2	Sugar	White granulated sugar for retail sale	Food
3	3	3	Office Paper	A4 office paper, 5 packs per box	Office supplies
\.


--
-- TOC entry 3903 (class 0 OID 17025)
-- Dependencies: 232
-- Data for Name: suppliers; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.suppliers (supplier_id, supplier_name, address, phone, email) FROM stdin;
1	Alpha Supply LLC	Saint Petersburg, Industrial Ave, 5	+7(812)777-11-22	alpha@supply.ru
2	Beta Logistics JSC	Moscow, Warehouse St, 3	+7(495)888-22-33	beta@logistics.ru
3	Gamma Trade LLC	Kazan, Trade St, 7	+7(843)999-33-44	gamma@trade.ru
\.


--
-- TOC entry 3907 (class 0 OID 17068)
-- Dependencies: 236
-- Data for Name: supplies; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.supplies (supply_id, supplier_id, contract_number, invoice_id, supply_date, status, description, waybill_number, actual_supply_date) FROM stdin;
1	1	SUP-2025-001	1	2025-03-05	Received	Supply of laptops from supplier Alpha Supply LLC	WB-001	2025-03-06
2	2	SUP-2025-001	2	2025-03-07	Received	Supply of sugar from supplier Beta Logistics JSC	WB-002	2025-03-07
3	3	MIX-2025-001	3	2025-03-10	Received	Supply of office paper from supplier Gamma Trade LLC	WB-003	2025-03-11
\.


--
-- TOC entry 3915 (class 0 OID 17169)
-- Dependencies: 244
-- Data for Name: supply_invoices; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.supply_invoices (invoice_id, supply_id, invoice_amount, invoice_status, creation_date, payment_date) FROM stdin;
1	1	1300000.00	Paid	2025-03-05	2025-03-06
2	2	27500.00	Paid	2025-03-07	2025-03-08
3	3	120000.00	Created	2025-03-10	\N
\.


--
-- TOC entry 3909 (class 0 OID 17095)
-- Dependencies: 238
-- Data for Name: supply_items; Type: TABLE DATA; Schema: wholesale; Owner: postgres
--

COPY wholesale.supply_items (supply_item_id, supply_id, product_id, batch_number, supplied_quantity, purchase_unit_price, remaining_stock_quantity) FROM stdin;
1	1	1	BATCH-LAP-001	20.000	65000.00	15.000
2	2	2	BATCH-SUG-001	500.000	55.00	430.000
3	3	3	BATCH-PAP-001	100.000	1200.00	80.000
\.


--
-- TOC entry 3937 (class 0 OID 0)
-- Dependencies: 222
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.customers_customer_id_seq', 3, true);


--
-- TOC entry 3938 (class 0 OID 0)
-- Dependencies: 228
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.employees_employee_id_seq', 3, true);


--
-- TOC entry 3939 (class 0 OID 0)
-- Dependencies: 220
-- Name: manufacturers_manufacturer_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.manufacturers_manufacturer_id_seq', 3, true);


--
-- TOC entry 3940 (class 0 OID 0)
-- Dependencies: 226
-- Name: measurement_units_unit_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.measurement_units_unit_id_seq', 3, true);


--
-- TOC entry 3941 (class 0 OID 0)
-- Dependencies: 245
-- Name: order_invoices_invoice_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.order_invoices_invoice_id_seq', 3, true);


--
-- TOC entry 3942 (class 0 OID 0)
-- Dependencies: 241
-- Name: order_items_order_item_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.order_items_order_item_id_seq', 3, true);


--
-- TOC entry 3943 (class 0 OID 0)
-- Dependencies: 239
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.orders_order_id_seq', 3, true);


--
-- TOC entry 3944 (class 0 OID 0)
-- Dependencies: 224
-- Name: positions_position_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.positions_position_id_seq', 3, true);


--
-- TOC entry 3945 (class 0 OID 0)
-- Dependencies: 233
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.products_product_id_seq', 3, true);


--
-- TOC entry 3946 (class 0 OID 0)
-- Dependencies: 231
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.suppliers_supplier_id_seq', 3, true);


--
-- TOC entry 3947 (class 0 OID 0)
-- Dependencies: 235
-- Name: supplies_supply_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.supplies_supply_id_seq', 3, true);


--
-- TOC entry 3948 (class 0 OID 0)
-- Dependencies: 243
-- Name: supply_invoices_invoice_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.supply_invoices_invoice_id_seq', 3, true);


--
-- TOC entry 3949 (class 0 OID 0)
-- Dependencies: 237
-- Name: supply_items_supply_item_id_seq; Type: SEQUENCE SET; Schema: wholesale; Owner: postgres
--

SELECT pg_catalog.setval('wholesale.supply_items_supply_item_id_seq', 3, true);


--
-- TOC entry 3695 (class 2606 OID 17013)
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (contract_number);


--
-- TOC entry 3667 (class 2606 OID 16944)
-- Name: customers customers_customer_inn_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.customers
    ADD CONSTRAINT customers_customer_inn_key UNIQUE (customer_inn);


--
-- TOC entry 3669 (class 2606 OID 16942)
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- TOC entry 3671 (class 2606 OID 16940)
-- Name: customers customers_phone_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.customers
    ADD CONSTRAINT customers_phone_key UNIQUE (phone);


--
-- TOC entry 3673 (class 2606 OID 16938)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 3685 (class 2606 OID 16993)
-- Name: employees employees_email_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.employees
    ADD CONSTRAINT employees_email_key UNIQUE (email);


--
-- TOC entry 3687 (class 2606 OID 16989)
-- Name: employees employees_passport_data_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.employees
    ADD CONSTRAINT employees_passport_data_key UNIQUE (passport_data);


--
-- TOC entry 3689 (class 2606 OID 16987)
-- Name: employees employees_personnel_number_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.employees
    ADD CONSTRAINT employees_personnel_number_key UNIQUE (personnel_number);


--
-- TOC entry 3691 (class 2606 OID 16991)
-- Name: employees employees_phone_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.employees
    ADD CONSTRAINT employees_phone_key UNIQUE (phone);


--
-- TOC entry 3693 (class 2606 OID 16985)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 3657 (class 2606 OID 16921)
-- Name: manufacturers manufacturers_email_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.manufacturers
    ADD CONSTRAINT manufacturers_email_key UNIQUE (email);


--
-- TOC entry 3659 (class 2606 OID 16919)
-- Name: manufacturers manufacturers_manufacturer_inn_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.manufacturers
    ADD CONSTRAINT manufacturers_manufacturer_inn_key UNIQUE (manufacturer_inn);


--
-- TOC entry 3661 (class 2606 OID 16917)
-- Name: manufacturers manufacturers_manufacturer_name_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.manufacturers
    ADD CONSTRAINT manufacturers_manufacturer_name_key UNIQUE (manufacturer_name);


--
-- TOC entry 3663 (class 2606 OID 16923)
-- Name: manufacturers manufacturers_phone_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.manufacturers
    ADD CONSTRAINT manufacturers_phone_key UNIQUE (phone);


--
-- TOC entry 3665 (class 2606 OID 16915)
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (manufacturer_id);


--
-- TOC entry 3679 (class 2606 OID 16966)
-- Name: measurement_units measurement_units_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.measurement_units
    ADD CONSTRAINT measurement_units_pkey PRIMARY KEY (unit_id);


--
-- TOC entry 3681 (class 2606 OID 16968)
-- Name: measurement_units measurement_units_unit_name_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.measurement_units
    ADD CONSTRAINT measurement_units_unit_name_key UNIQUE (unit_name);


--
-- TOC entry 3683 (class 2606 OID 16970)
-- Name: measurement_units measurement_units_unit_symbol_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.measurement_units
    ADD CONSTRAINT measurement_units_unit_symbol_key UNIQUE (unit_symbol);


--
-- TOC entry 3725 (class 2606 OID 17209)
-- Name: order_invoices order_invoices_order_id_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.order_invoices
    ADD CONSTRAINT order_invoices_order_id_key UNIQUE (order_id);


--
-- TOC entry 3727 (class 2606 OID 17207)
-- Name: order_invoices order_invoices_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.order_invoices
    ADD CONSTRAINT order_invoices_pkey PRIMARY KEY (invoice_id);


--
-- TOC entry 3719 (class 2606 OID 17157)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);


--
-- TOC entry 3717 (class 2606 OID 17133)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 3675 (class 2606 OID 16955)
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (position_id);


--
-- TOC entry 3677 (class 2606 OID 16957)
-- Name: positions positions_position_name_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.positions
    ADD CONSTRAINT positions_position_name_key UNIQUE (position_name);


--
-- TOC entry 3705 (class 2606 OID 17054)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 3697 (class 2606 OID 17042)
-- Name: suppliers suppliers_email_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.suppliers
    ADD CONSTRAINT suppliers_email_key UNIQUE (email);


--
-- TOC entry 3699 (class 2606 OID 17040)
-- Name: suppliers suppliers_phone_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.suppliers
    ADD CONSTRAINT suppliers_phone_key UNIQUE (phone);


--
-- TOC entry 3701 (class 2606 OID 17036)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (supplier_id);


--
-- TOC entry 3703 (class 2606 OID 17038)
-- Name: suppliers suppliers_supplier_name_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.suppliers
    ADD CONSTRAINT suppliers_supplier_name_key UNIQUE (supplier_name);


--
-- TOC entry 3709 (class 2606 OID 17081)
-- Name: supplies supplies_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supplies
    ADD CONSTRAINT supplies_pkey PRIMARY KEY (supply_id);


--
-- TOC entry 3711 (class 2606 OID 17083)
-- Name: supplies supplies_waybill_number_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supplies
    ADD CONSTRAINT supplies_waybill_number_key UNIQUE (waybill_number);


--
-- TOC entry 3721 (class 2606 OID 17181)
-- Name: supply_invoices supply_invoices_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supply_invoices
    ADD CONSTRAINT supply_invoices_pkey PRIMARY KEY (invoice_id);


--
-- TOC entry 3723 (class 2606 OID 17183)
-- Name: supply_invoices supply_invoices_supply_id_key; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supply_invoices
    ADD CONSTRAINT supply_invoices_supply_id_key UNIQUE (supply_id);


--
-- TOC entry 3713 (class 2606 OID 17109)
-- Name: supply_items supply_items_pkey; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supply_items
    ADD CONSTRAINT supply_items_pkey PRIMARY KEY (supply_item_id);


--
-- TOC entry 3707 (class 2606 OID 17056)
-- Name: products uq_products_name_manufacturer; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.products
    ADD CONSTRAINT uq_products_name_manufacturer UNIQUE (product_name, manufacturer_id);


--
-- TOC entry 3715 (class 2606 OID 17111)
-- Name: supply_items uq_supply_items_batch; Type: CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supply_items
    ADD CONSTRAINT uq_supply_items_batch UNIQUE (supply_id, product_id, batch_number);


--
-- TOC entry 3729 (class 2606 OID 17019)
-- Name: contracts fk_contracts_employees; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.contracts
    ADD CONSTRAINT fk_contracts_employees FOREIGN KEY (employee_id) REFERENCES wholesale.employees(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3730 (class 2606 OID 17014)
-- Name: contracts fk_contracts_positions; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.contracts
    ADD CONSTRAINT fk_contracts_positions FOREIGN KEY (position_id) REFERENCES wholesale.positions(position_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3728 (class 2606 OID 16994)
-- Name: employees fk_employees_positions; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.employees
    ADD CONSTRAINT fk_employees_positions FOREIGN KEY (position_id) REFERENCES wholesale.positions(position_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3743 (class 2606 OID 17210)
-- Name: order_invoices fk_order_invoices_orders; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.order_invoices
    ADD CONSTRAINT fk_order_invoices_orders FOREIGN KEY (order_id) REFERENCES wholesale.orders(order_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3740 (class 2606 OID 17163)
-- Name: order_items fk_order_items_products; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.order_items
    ADD CONSTRAINT fk_order_items_products FOREIGN KEY (product_id) REFERENCES wholesale.products(product_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3741 (class 2606 OID 17158)
-- Name: order_items fk_order_items_supplies; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.order_items
    ADD CONSTRAINT fk_order_items_supplies FOREIGN KEY (supply_id) REFERENCES wholesale.supplies(supply_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3738 (class 2606 OID 17139)
-- Name: orders fk_orders_contracts; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.orders
    ADD CONSTRAINT fk_orders_contracts FOREIGN KEY (contract_number) REFERENCES wholesale.contracts(contract_number) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3739 (class 2606 OID 17134)
-- Name: orders fk_orders_customers; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.orders
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES wholesale.customers(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3731 (class 2606 OID 17057)
-- Name: products fk_products_manufacturers; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.products
    ADD CONSTRAINT fk_products_manufacturers FOREIGN KEY (manufacturer_id) REFERENCES wholesale.manufacturers(manufacturer_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3732 (class 2606 OID 17062)
-- Name: products fk_products_measurement_units; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.products
    ADD CONSTRAINT fk_products_measurement_units FOREIGN KEY (unit_id) REFERENCES wholesale.measurement_units(unit_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3733 (class 2606 OID 17089)
-- Name: supplies fk_supplies_contracts; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supplies
    ADD CONSTRAINT fk_supplies_contracts FOREIGN KEY (contract_number) REFERENCES wholesale.contracts(contract_number) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3734 (class 2606 OID 17084)
-- Name: supplies fk_supplies_suppliers; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supplies
    ADD CONSTRAINT fk_supplies_suppliers FOREIGN KEY (supplier_id) REFERENCES wholesale.suppliers(supplier_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3735 (class 2606 OID 17189)
-- Name: supplies fk_supplies_supply_invoices; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supplies
    ADD CONSTRAINT fk_supplies_supply_invoices FOREIGN KEY (invoice_id) REFERENCES wholesale.supply_invoices(invoice_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3742 (class 2606 OID 17184)
-- Name: supply_invoices fk_supply_invoices_supplies; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supply_invoices
    ADD CONSTRAINT fk_supply_invoices_supplies FOREIGN KEY (supply_id) REFERENCES wholesale.supplies(supply_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3736 (class 2606 OID 17117)
-- Name: supply_items fk_supply_items_products; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supply_items
    ADD CONSTRAINT fk_supply_items_products FOREIGN KEY (product_id) REFERENCES wholesale.products(product_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3737 (class 2606 OID 17112)
-- Name: supply_items fk_supply_items_supplies; Type: FK CONSTRAINT; Schema: wholesale; Owner: postgres
--

ALTER TABLE ONLY wholesale.supply_items
    ADD CONSTRAINT fk_supply_items_supplies FOREIGN KEY (supply_id) REFERENCES wholesale.supplies(supply_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-04-27 14:22:05 MSK

--
-- PostgreSQL database dump complete
--

\unrestrict EHcnjI78eMfeO4Hymj1Wwn5J8FmTC1GQeUAS3hdVQavbJJdl6IEZ9hrkhgTj5EN

