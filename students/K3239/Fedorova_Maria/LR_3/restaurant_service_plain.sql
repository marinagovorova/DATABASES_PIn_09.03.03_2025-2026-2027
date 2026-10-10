--
-- PostgreSQL database dump
--

\restrict xYl5kkdcCdqWQ3JcPsc7uitnTP9alSS9vrC392hZV2yd0mxuNtY6nOoLy6TxEyl

-- Dumped from database version 17.9
-- Dumped by pg_dump version 17.9

-- Started on 2026-03-20 16:16:53 MSK

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
-- TOC entry 6 (class 2615 OID 16389)
-- Name: restaurant; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA restaurant;


ALTER SCHEMA restaurant OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16396)
-- Name: cook; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.cook (
    id_cook integer NOT NULL
);


ALTER TABLE restaurant.cook OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16438)
-- Name: cooking_assignment; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.cooking_assignment (
    id_assignment integer NOT NULL,
    id_order_item integer NOT NULL,
    id_cook integer NOT NULL,
    id_head_chef integer NOT NULL,
    status character varying(40) NOT NULL,
    start_datetime timestamp without time zone NOT NULL,
    ready_datetime timestamp without time zone NOT NULL
);


ALTER TABLE restaurant.cooking_assignment OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16405)
-- Name: customer; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.customer (
    id_customer integer NOT NULL,
    full_name character varying(120) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(100)
);


ALTER TABLE restaurant.customer OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16426)
-- Name: customer_order; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.customer_order (
    id_order integer NOT NULL,
    id_restaurant_table integer NOT NULL,
    id_waiter integer NOT NULL,
    id_customer integer NOT NULL,
    id_work_shift integer NOT NULL,
    order_datetime timestamp without time zone NOT NULL,
    status character varying(40) NOT NULL,
    wishes character varying(255),
    markup numeric(5,2) NOT NULL,
    total_price numeric(10,2) NOT NULL
);


ALTER TABLE restaurant.customer_order OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16408)
-- Name: dish; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.dish (
    id_dish integer NOT NULL,
    dish_name character varying(100) NOT NULL,
    description character varying(255),
    is_available boolean NOT NULL
);


ALTER TABLE restaurant.dish OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16432)
-- Name: dish_ingredient; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.dish_ingredient (
    id_dish_ingredient integer NOT NULL,
    id_dish integer NOT NULL,
    id_ingredient integer NOT NULL,
    ingredient_amount numeric(10,3) NOT NULL
);


ALTER TABLE restaurant.dish_ingredient OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16390)
-- Name: employee; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.employee (
    id_employee integer NOT NULL,
    last_name character varying(60) NOT NULL,
    first_name character varying(60) NOT NULL,
    middle_name character varying(60),
    passport_data character(10) NOT NULL,
    category character(1) NOT NULL,
    salary_rate numeric(3,1) NOT NULL,
    salary numeric(10,2) NOT NULL,
    hire_date date NOT NULL
);


ALTER TABLE restaurant.employee OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16399)
-- Name: head_chef; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.head_chef (
    id_head_chef integer NOT NULL
);


ALTER TABLE restaurant.head_chef OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16420)
-- Name: ingredient; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.ingredient (
    id_ingredient integer NOT NULL,
    id_ingredient_type integer NOT NULL,
    ingredient_name character varying(120) NOT NULL,
    calories integer NOT NULL,
    unit_of_measure character varying(20) NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    stock_quantity numeric(12,3) NOT NULL,
    required_stock numeric(12,3) NOT NULL,
    storage_life date NOT NULL
);


ALTER TABLE restaurant.ingredient OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16414)
-- Name: ingredient_type; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.ingredient_type (
    id_ingredient_type integer NOT NULL,
    type_name character varying(60) NOT NULL,
    description character varying(255)
);


ALTER TABLE restaurant.ingredient_type OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16429)
-- Name: order_item; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.order_item (
    id_order_item integer NOT NULL,
    id_order integer NOT NULL,
    id_dish integer NOT NULL,
    quantity integer NOT NULL,
    cost_price numeric(10,2) NOT NULL,
    total_price numeric(10,2) NOT NULL,
    wishes character varying(255)
);


ALTER TABLE restaurant.order_item OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16435)
-- Name: purchase; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.purchase (
    id_purchase integer NOT NULL,
    id_ingredient integer NOT NULL,
    id_supplier integer NOT NULL,
    purchase_date date NOT NULL,
    purchase_volume numeric(12,3) NOT NULL,
    purchase_price numeric(10,2) NOT NULL,
    batch_balance numeric(12,3) NOT NULL,
    expiration_date date NOT NULL
);


ALTER TABLE restaurant.purchase OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16402)
-- Name: restaurant_table; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.restaurant_table (
    id_restaurant_table integer NOT NULL,
    table_number integer NOT NULL,
    seats_count integer NOT NULL
);


ALTER TABLE restaurant.restaurant_table OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16417)
-- Name: supplier; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.supplier (
    id_supplier integer NOT NULL,
    supplier_name character varying(120) NOT NULL,
    phone character varying(20),
    email character varying(100)
);


ALTER TABLE restaurant.supplier OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16423)
-- Name: table_reservation; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.table_reservation (
    id_reservation integer NOT NULL,
    id_restaurant_table integer NOT NULL,
    id_customer integer NOT NULL,
    reservation_datetime timestamp without time zone NOT NULL
);


ALTER TABLE restaurant.table_reservation OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16393)
-- Name: waiter; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.waiter (
    id_waiter integer NOT NULL
);


ALTER TABLE restaurant.waiter OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16411)
-- Name: work_shift; Type: TABLE; Schema: restaurant; Owner: postgres
--

CREATE TABLE restaurant.work_shift (
    id_work_shift integer NOT NULL,
    shift_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);


ALTER TABLE restaurant.work_shift OWNER TO postgres;

--
-- TOC entry 3748 (class 0 OID 16396)
-- Dependencies: 220
-- Data for Name: cook; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.cook (id_cook) FROM stdin;
2
\.


--
-- TOC entry 3762 (class 0 OID 16438)
-- Dependencies: 234
-- Data for Name: cooking_assignment; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.cooking_assignment (id_assignment, id_order_item, id_cook, id_head_chef, status, start_datetime, ready_datetime) FROM stdin;
1	1	2	3	assigned	2026-03-20 18:40:00	2026-03-20 18:55:00
2	2	2	3	in_progress	2026-03-20 18:42:00	2026-03-20 19:00:00
3	3	2	3	ready	2026-03-20 19:10:00	2026-03-20 19:25:00
\.


--
-- TOC entry 3751 (class 0 OID 16405)
-- Dependencies: 223
-- Data for Name: customer; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.customer (id_customer, full_name, phone, email) FROM stdin;
1	Fedorova Maria	+79991234567	maria@example.com
2	Pakhomov Gleb	+79997654321	gleb@example.com
3	Ivanova Olga	+79990001122	\N
\.


--
-- TOC entry 3758 (class 0 OID 16426)
-- Dependencies: 230
-- Data for Name: customer_order; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.customer_order (id_order, id_restaurant_table, id_waiter, id_customer, id_work_shift, order_datetime, status, wishes, markup, total_price) FROM stdin;
1	2	1	1	2	2026-03-20 18:35:00	принят	No onion	40.00	980.00
2	1	1	2	2	2026-03-20 19:05:00	готовится	\N	35.00	735.00
\.


--
-- TOC entry 3752 (class 0 OID 16408)
-- Dependencies: 224
-- Data for Name: dish; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.dish (id_dish, dish_name, description, is_available) FROM stdin;
1	Caesar Salad	Salad with chicken and sauce	t
2	Mushroom Soup	Cream soup with mushrooms	t
3	Pasta Carbonara	Pasta with bacon and sauce	t
\.


--
-- TOC entry 3760 (class 0 OID 16432)
-- Dependencies: 232
-- Data for Name: dish_ingredient; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.dish_ingredient (id_dish_ingredient, id_dish, id_ingredient, ingredient_amount) FROM stdin;
1	1	1	0.150
2	1	2	0.200
3	1	3	0.050
4	2	4	0.010
5	3	3	0.080
\.


--
-- TOC entry 3746 (class 0 OID 16390)
-- Dependencies: 218
-- Data for Name: employee; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.employee (id_employee, last_name, first_name, middle_name, passport_data, category, salary_rate, salary, hire_date) FROM stdin;
1	Ivanov	Ivan	Ivanovich	1234567890	A	1.0	90000.00	2024-01-10
2	Petrova	Anna	Sergeevna	2345678901	B	1.0	85000.00	2024-02-15
3	Sidorov	Pavel	Olegovich	3456789012	B	1.0	80000.00	2024-03-05
4	Smirnova	Elena	Igorevna	4567890123	C	0.5	45000.00	2024-04-01
\.


--
-- TOC entry 3749 (class 0 OID 16399)
-- Dependencies: 221
-- Data for Name: head_chef; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.head_chef (id_head_chef) FROM stdin;
3
\.


--
-- TOC entry 3756 (class 0 OID 16420)
-- Dependencies: 228
-- Data for Name: ingredient; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.ingredient (id_ingredient, id_ingredient_type, ingredient_name, calories, unit_of_measure, unit_price, stock_quantity, required_stock, storage_life) FROM stdin;
1	1	Tomato	18	kg	120.00	15.000	5.000	2026-03-30
2	2	Chicken	239	kg	420.00	10.000	4.000	2026-03-25
3	3	Parmesan	431	kg	900.00	3.000	1.000	2026-04-10
4	4	Black Pepper	251	kg	700.00	1.000	0.200	2026-12-31
\.


--
-- TOC entry 3754 (class 0 OID 16414)
-- Dependencies: 226
-- Data for Name: ingredient_type; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.ingredient_type (id_ingredient_type, type_name, description) FROM stdin;
1	Vegetable	Fresh vegetables
2	Meat	Meat products
3	Dairy	Milk products
4	Spice	Seasonings
\.


--
-- TOC entry 3759 (class 0 OID 16429)
-- Dependencies: 231
-- Data for Name: order_item; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.order_item (id_order_item, id_order, id_dish, quantity, cost_price, total_price, wishes) FROM stdin;
1	1	1	2	300.00	600.00	Less sauce
2	1	2	1	280.00	280.00	\N
3	2	3	1	525.00	525.00	Extra cheese
\.


--
-- TOC entry 3761 (class 0 OID 16435)
-- Dependencies: 233
-- Data for Name: purchase; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.purchase (id_purchase, id_ingredient, id_supplier, purchase_date, purchase_volume, purchase_price, batch_balance, expiration_date) FROM stdin;
1	1	1	2026-03-18	20.000	2400.00	15.000	2026-03-30
2	2	2	2026-03-18	12.000	5040.00	10.000	2026-03-25
3	3	1	2026-03-18	5.000	4500.00	3.000	2026-04-10
\.


--
-- TOC entry 3750 (class 0 OID 16402)
-- Dependencies: 222
-- Data for Name: restaurant_table; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.restaurant_table (id_restaurant_table, table_number, seats_count) FROM stdin;
1	1	2
2	2	4
3	3	6
\.


--
-- TOC entry 3755 (class 0 OID 16417)
-- Dependencies: 227
-- Data for Name: supplier; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.supplier (id_supplier, supplier_name, phone, email) FROM stdin;
1	FreshFood LLC	+79995554433	supply1@example.com
2	Farm Market	+79994443322	supply2@example.com
\.


--
-- TOC entry 3757 (class 0 OID 16423)
-- Dependencies: 229
-- Data for Name: table_reservation; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.table_reservation (id_reservation, id_restaurant_table, id_customer, reservation_datetime) FROM stdin;
1	2	1	2026-03-20 18:30:00
2	1	2	2026-03-20 19:00:00
\.


--
-- TOC entry 3747 (class 0 OID 16393)
-- Dependencies: 219
-- Data for Name: waiter; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.waiter (id_waiter) FROM stdin;
1
\.


--
-- TOC entry 3753 (class 0 OID 16411)
-- Dependencies: 225
-- Data for Name: work_shift; Type: TABLE DATA; Schema: restaurant; Owner: postgres
--

COPY restaurant.work_shift (id_work_shift, shift_date, start_time, end_time) FROM stdin;
1	2026-03-20	09:00:00	17:00:00
2	2026-03-20	17:00:00	23:00:00
\.


--
-- TOC entry 3542 (class 2606 OID 16604)
-- Name: cooking_assignment chk_cooking_assignment_status; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.cooking_assignment
    ADD CONSTRAINT chk_cooking_assignment_status CHECK (((status)::text = ANY ((ARRAY['assigned'::character varying, 'in_progress'::character varying, 'ready'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 3543 (class 2606 OID 16603)
-- Name: cooking_assignment chk_cooking_assignment_time; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.cooking_assignment
    ADD CONSTRAINT chk_cooking_assignment_time CHECK ((ready_datetime >= start_datetime)) NOT VALID;


--
-- TOC entry 3520 (class 2606 OID 16501)
-- Name: customer chk_customer_email; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.customer
    ADD CONSTRAINT chk_customer_email CHECK (((email IS NULL) OR ((email)::text ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))) NOT VALID;


--
-- TOC entry 3530 (class 2606 OID 16545)
-- Name: customer_order chk_customer_order_datetime; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.customer_order
    ADD CONSTRAINT chk_customer_order_datetime CHECK ((order_datetime >= CURRENT_TIMESTAMP)) NOT VALID;


--
-- TOC entry 3531 (class 2606 OID 16547)
-- Name: customer_order chk_customer_order_markup; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.customer_order
    ADD CONSTRAINT chk_customer_order_markup CHECK ((markup >= (0)::numeric)) NOT VALID;


--
-- TOC entry 3532 (class 2606 OID 16546)
-- Name: customer_order chk_customer_order_status; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.customer_order
    ADD CONSTRAINT chk_customer_order_status CHECK (((status)::text = ANY ((ARRAY['принят'::character varying, 'готовится'::character varying, 'подан'::character varying, 'закрыт'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 3533 (class 2606 OID 16548)
-- Name: customer_order chk_customer_order_total_price; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.customer_order
    ADD CONSTRAINT chk_customer_order_total_price CHECK ((total_price >= (0)::numeric)) NOT VALID;


--
-- TOC entry 3521 (class 2606 OID 16500)
-- Name: customer chk_customer_phone; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.customer
    ADD CONSTRAINT chk_customer_phone CHECK (((phone)::text ~ '^\+7[0-9]{10}$'::text)) NOT VALID;


--
-- TOC entry 3537 (class 2606 OID 16572)
-- Name: dish_ingredient chk_dish_ingredient_amount; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.dish_ingredient
    ADD CONSTRAINT chk_dish_ingredient_amount CHECK ((ingredient_amount > (0)::numeric)) NOT VALID;


--
-- TOC entry 3514 (class 2606 OID 16477)
-- Name: employee chk_employee_category; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.employee
    ADD CONSTRAINT chk_employee_category CHECK ((category = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar]))) NOT VALID;


--
-- TOC entry 3515 (class 2606 OID 16480)
-- Name: employee chk_employee_hire_date; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.employee
    ADD CONSTRAINT chk_employee_hire_date CHECK ((hire_date <= CURRENT_DATE)) NOT VALID;


--
-- TOC entry 3516 (class 2606 OID 16479)
-- Name: employee chk_employee_salary; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.employee
    ADD CONSTRAINT chk_employee_salary CHECK ((salary > (0)::numeric)) NOT VALID;


--
-- TOC entry 3517 (class 2606 OID 16478)
-- Name: employee chk_employee_salary_rate; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.employee
    ADD CONSTRAINT chk_employee_salary_rate CHECK (((salary_rate >= 0.1) AND (salary_rate <= 1.0))) NOT VALID;


--
-- TOC entry 3525 (class 2606 OID 16510)
-- Name: ingredient chk_ingredient_calories; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.ingredient
    ADD CONSTRAINT chk_ingredient_calories CHECK ((calories >= 0)) NOT VALID;


--
-- TOC entry 3526 (class 2606 OID 16513)
-- Name: ingredient chk_ingredient_required_stock; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.ingredient
    ADD CONSTRAINT chk_ingredient_required_stock CHECK ((required_stock >= (0)::numeric)) NOT VALID;


--
-- TOC entry 3527 (class 2606 OID 16512)
-- Name: ingredient chk_ingredient_stock_quantity; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.ingredient
    ADD CONSTRAINT chk_ingredient_stock_quantity CHECK ((stock_quantity >= (0)::numeric)) NOT VALID;


--
-- TOC entry 3528 (class 2606 OID 16514)
-- Name: ingredient chk_ingredient_storage_life; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.ingredient
    ADD CONSTRAINT chk_ingredient_storage_life CHECK ((storage_life >= CURRENT_DATE)) NOT VALID;


--
-- TOC entry 3529 (class 2606 OID 16511)
-- Name: ingredient chk_ingredient_unit_price; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.ingredient
    ADD CONSTRAINT chk_ingredient_unit_price CHECK ((unit_price > (0)::numeric)) NOT VALID;


--
-- TOC entry 3534 (class 2606 OID 16560)
-- Name: order_item chk_order_item_cost_price; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.order_item
    ADD CONSTRAINT chk_order_item_cost_price CHECK ((cost_price >= (0)::numeric)) NOT VALID;


--
-- TOC entry 3535 (class 2606 OID 16559)
-- Name: order_item chk_order_item_quantity; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.order_item
    ADD CONSTRAINT chk_order_item_quantity CHECK ((quantity > 0)) NOT VALID;


--
-- TOC entry 3536 (class 2606 OID 16561)
-- Name: order_item chk_order_item_total_price; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.order_item
    ADD CONSTRAINT chk_order_item_total_price CHECK ((total_price >= (0)::numeric)) NOT VALID;


--
-- TOC entry 3538 (class 2606 OID 16585)
-- Name: purchase chk_purchase_batch_balance; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.purchase
    ADD CONSTRAINT chk_purchase_batch_balance CHECK ((batch_balance >= (0)::numeric)) NOT VALID;


--
-- TOC entry 3539 (class 2606 OID 16586)
-- Name: purchase chk_purchase_expiration_date; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.purchase
    ADD CONSTRAINT chk_purchase_expiration_date CHECK ((expiration_date >= purchase_date)) NOT VALID;


--
-- TOC entry 3540 (class 2606 OID 16584)
-- Name: purchase chk_purchase_price; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.purchase
    ADD CONSTRAINT chk_purchase_price CHECK ((purchase_price > (0)::numeric)) NOT VALID;


--
-- TOC entry 3541 (class 2606 OID 16583)
-- Name: purchase chk_purchase_volume; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.purchase
    ADD CONSTRAINT chk_purchase_volume CHECK ((purchase_volume > (0)::numeric)) NOT VALID;


--
-- TOC entry 3518 (class 2606 OID 16498)
-- Name: restaurant_table chk_restaurant_table_number; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.restaurant_table
    ADD CONSTRAINT chk_restaurant_table_number CHECK (((table_number >= 1) AND (table_number <= 40))) NOT VALID;


--
-- TOC entry 3519 (class 2606 OID 16499)
-- Name: restaurant_table chk_restaurant_table_seats_count; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.restaurant_table
    ADD CONSTRAINT chk_restaurant_table_seats_count CHECK ((seats_count > 0)) NOT VALID;


--
-- TOC entry 3523 (class 2606 OID 16504)
-- Name: supplier chk_supplier_email; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.supplier
    ADD CONSTRAINT chk_supplier_email CHECK (((email IS NULL) OR ((email)::text ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))) NOT VALID;


--
-- TOC entry 3524 (class 2606 OID 16503)
-- Name: supplier chk_supplier_phone; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.supplier
    ADD CONSTRAINT chk_supplier_phone CHECK (((phone IS NULL) OR ((phone)::text ~ '^\+7[0-9]{10}$'::text))) NOT VALID;


--
-- TOC entry 3522 (class 2606 OID 16502)
-- Name: work_shift chk_work_shift_time; Type: CHECK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE restaurant.work_shift
    ADD CONSTRAINT chk_work_shift_time CHECK ((end_time > start_time)) NOT VALID;


--
-- TOC entry 3551 (class 2606 OID 16446)
-- Name: cook pk_cook; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.cook
    ADD CONSTRAINT pk_cook PRIMARY KEY (id_cook);


--
-- TOC entry 3581 (class 2606 OID 16472)
-- Name: cooking_assignment pk_cooking_assignment; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.cooking_assignment
    ADD CONSTRAINT pk_cooking_assignment PRIMARY KEY (id_assignment);


--
-- TOC entry 3559 (class 2606 OID 16454)
-- Name: customer pk_customer; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.customer
    ADD CONSTRAINT pk_customer PRIMARY KEY (id_customer);


--
-- TOC entry 3573 (class 2606 OID 16456)
-- Name: customer_order pk_customer_order; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.customer_order
    ADD CONSTRAINT pk_customer_order PRIMARY KEY (id_order);


--
-- TOC entry 3561 (class 2606 OID 16460)
-- Name: dish pk_dish; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.dish
    ADD CONSTRAINT pk_dish PRIMARY KEY (id_dish);


--
-- TOC entry 3577 (class 2606 OID 16462)
-- Name: dish_ingredient pk_dish_ingredient; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.dish_ingredient
    ADD CONSTRAINT pk_dish_ingredient PRIMARY KEY (id_dish_ingredient);


--
-- TOC entry 3545 (class 2606 OID 16442)
-- Name: employee pk_employee; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.employee
    ADD CONSTRAINT pk_employee PRIMARY KEY (id_employee);


--
-- TOC entry 3553 (class 2606 OID 16448)
-- Name: head_chef pk_head_chef; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.head_chef
    ADD CONSTRAINT pk_head_chef PRIMARY KEY (id_head_chef);


--
-- TOC entry 3569 (class 2606 OID 16466)
-- Name: ingredient pk_ingredient; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.ingredient
    ADD CONSTRAINT pk_ingredient PRIMARY KEY (id_ingredient);


--
-- TOC entry 3565 (class 2606 OID 16464)
-- Name: ingredient_type pk_ingredient_type; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.ingredient_type
    ADD CONSTRAINT pk_ingredient_type PRIMARY KEY (id_ingredient_type);


--
-- TOC entry 3575 (class 2606 OID 16458)
-- Name: order_item pk_order_item; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.order_item
    ADD CONSTRAINT pk_order_item PRIMARY KEY (id_order_item);


--
-- TOC entry 3579 (class 2606 OID 16470)
-- Name: purchase pk_purchase; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.purchase
    ADD CONSTRAINT pk_purchase PRIMARY KEY (id_purchase);


--
-- TOC entry 3555 (class 2606 OID 16450)
-- Name: restaurant_table pk_restaurant_table; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.restaurant_table
    ADD CONSTRAINT pk_restaurant_table PRIMARY KEY (id_restaurant_table);


--
-- TOC entry 3567 (class 2606 OID 16468)
-- Name: supplier pk_supplier; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.supplier
    ADD CONSTRAINT pk_supplier PRIMARY KEY (id_supplier);


--
-- TOC entry 3571 (class 2606 OID 16452)
-- Name: table_reservation pk_table_reservation; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.table_reservation
    ADD CONSTRAINT pk_table_reservation PRIMARY KEY (id_reservation);


--
-- TOC entry 3549 (class 2606 OID 16444)
-- Name: waiter pk_waiter; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.waiter
    ADD CONSTRAINT pk_waiter PRIMARY KEY (id_waiter);


--
-- TOC entry 3563 (class 2606 OID 16474)
-- Name: work_shift pk_work_shift; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.work_shift
    ADD CONSTRAINT pk_work_shift PRIMARY KEY (id_work_shift);


--
-- TOC entry 3547 (class 2606 OID 16476)
-- Name: employee uq_employee_passport_data; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.employee
    ADD CONSTRAINT uq_employee_passport_data UNIQUE (passport_data);


--
-- TOC entry 3557 (class 2606 OID 16497)
-- Name: restaurant_table uq_restaurant_table_table_number; Type: CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.restaurant_table
    ADD CONSTRAINT uq_restaurant_table_table_number UNIQUE (table_number);


--
-- TOC entry 3583 (class 2606 OID 16486)
-- Name: cook fk_cook_employee; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.cook
    ADD CONSTRAINT fk_cook_employee FOREIGN KEY (id_cook) REFERENCES restaurant.employee(id_employee) NOT VALID;


--
-- TOC entry 3598 (class 2606 OID 16593)
-- Name: cooking_assignment fk_cooking_assignment_cook; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.cooking_assignment
    ADD CONSTRAINT fk_cooking_assignment_cook FOREIGN KEY (id_cook) REFERENCES restaurant.cook(id_cook) NOT VALID;


--
-- TOC entry 3599 (class 2606 OID 16598)
-- Name: cooking_assignment fk_cooking_assignment_head_chef; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.cooking_assignment
    ADD CONSTRAINT fk_cooking_assignment_head_chef FOREIGN KEY (id_head_chef) REFERENCES restaurant.head_chef(id_head_chef) NOT VALID;


--
-- TOC entry 3600 (class 2606 OID 16588)
-- Name: cooking_assignment fk_cooking_assignment_order_item; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.cooking_assignment
    ADD CONSTRAINT fk_cooking_assignment_order_item FOREIGN KEY (id_order_item) REFERENCES restaurant.order_item(id_order_item) NOT VALID;


--
-- TOC entry 3588 (class 2606 OID 16535)
-- Name: customer_order fk_customer_order_customer; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.customer_order
    ADD CONSTRAINT fk_customer_order_customer FOREIGN KEY (id_customer) REFERENCES restaurant.customer(id_customer) NOT VALID;


--
-- TOC entry 3589 (class 2606 OID 16525)
-- Name: customer_order fk_customer_order_restaurant_table; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.customer_order
    ADD CONSTRAINT fk_customer_order_restaurant_table FOREIGN KEY (id_restaurant_table) REFERENCES restaurant.restaurant_table(id_restaurant_table) NOT VALID;


--
-- TOC entry 3590 (class 2606 OID 16530)
-- Name: customer_order fk_customer_order_waiter; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.customer_order
    ADD CONSTRAINT fk_customer_order_waiter FOREIGN KEY (id_waiter) REFERENCES restaurant.waiter(id_waiter) NOT VALID;


--
-- TOC entry 3591 (class 2606 OID 16540)
-- Name: customer_order fk_customer_order_work_shift; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.customer_order
    ADD CONSTRAINT fk_customer_order_work_shift FOREIGN KEY (id_work_shift) REFERENCES restaurant.work_shift(id_work_shift) NOT VALID;


--
-- TOC entry 3594 (class 2606 OID 16562)
-- Name: dish_ingredient fk_dish_ingredient_dish; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.dish_ingredient
    ADD CONSTRAINT fk_dish_ingredient_dish FOREIGN KEY (id_dish) REFERENCES restaurant.dish(id_dish) NOT VALID;


--
-- TOC entry 3595 (class 2606 OID 16567)
-- Name: dish_ingredient fk_dish_ingredient_ingredient; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.dish_ingredient
    ADD CONSTRAINT fk_dish_ingredient_ingredient FOREIGN KEY (id_ingredient) REFERENCES restaurant.ingredient(id_ingredient) NOT VALID;


--
-- TOC entry 3584 (class 2606 OID 16491)
-- Name: head_chef fk_head_chef_employee; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.head_chef
    ADD CONSTRAINT fk_head_chef_employee FOREIGN KEY (id_head_chef) REFERENCES restaurant.employee(id_employee) NOT VALID;


--
-- TOC entry 3585 (class 2606 OID 16505)
-- Name: ingredient fk_ingredient_ingredient_type; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.ingredient
    ADD CONSTRAINT fk_ingredient_ingredient_type FOREIGN KEY (id_ingredient_type) REFERENCES restaurant.ingredient_type(id_ingredient_type) NOT VALID;


--
-- TOC entry 3592 (class 2606 OID 16549)
-- Name: order_item fk_order_item_customer_order; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.order_item
    ADD CONSTRAINT fk_order_item_customer_order FOREIGN KEY (id_order) REFERENCES restaurant.customer_order(id_order) NOT VALID;


--
-- TOC entry 3593 (class 2606 OID 16554)
-- Name: order_item fk_order_item_dish; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.order_item
    ADD CONSTRAINT fk_order_item_dish FOREIGN KEY (id_dish) REFERENCES restaurant.dish(id_dish) NOT VALID;


--
-- TOC entry 3596 (class 2606 OID 16573)
-- Name: purchase fk_purchase_ingredient; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.purchase
    ADD CONSTRAINT fk_purchase_ingredient FOREIGN KEY (id_ingredient) REFERENCES restaurant.ingredient(id_ingredient) NOT VALID;


--
-- TOC entry 3597 (class 2606 OID 16578)
-- Name: purchase fk_purchase_supplier; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.purchase
    ADD CONSTRAINT fk_purchase_supplier FOREIGN KEY (id_supplier) REFERENCES restaurant.supplier(id_supplier) NOT VALID;


--
-- TOC entry 3586 (class 2606 OID 16520)
-- Name: table_reservation fk_table_reservation_customer; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.table_reservation
    ADD CONSTRAINT fk_table_reservation_customer FOREIGN KEY (id_customer) REFERENCES restaurant.customer(id_customer) NOT VALID;


--
-- TOC entry 3587 (class 2606 OID 16515)
-- Name: table_reservation fk_table_reservation_restaurant_table; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.table_reservation
    ADD CONSTRAINT fk_table_reservation_restaurant_table FOREIGN KEY (id_restaurant_table) REFERENCES restaurant.restaurant_table(id_restaurant_table) NOT VALID;


--
-- TOC entry 3582 (class 2606 OID 16481)
-- Name: waiter fk_waiter_employee; Type: FK CONSTRAINT; Schema: restaurant; Owner: postgres
--

ALTER TABLE ONLY restaurant.waiter
    ADD CONSTRAINT fk_waiter_employee FOREIGN KEY (id_waiter) REFERENCES restaurant.employee(id_employee) NOT VALID;


-- Completed on 2026-03-20 16:16:53 MSK

--
-- PostgreSQL database dump complete
--

\unrestrict xYl5kkdcCdqWQ3JcPsc7uitnTP9alSS9vrC392hZV2yd0mxuNtY6nOoLy6TxEyl

