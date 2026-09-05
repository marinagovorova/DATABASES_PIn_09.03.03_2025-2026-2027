--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2026-03-30 12:47:05

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
-- TOC entry 4966 (class 1262 OID 54962)
-- Name: TaxiService; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "TaxiService" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE "TaxiService" OWNER TO postgres;

\connect "TaxiService"

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
-- TOC entry 6 (class 2615 OID 54963)
-- Name: taxi; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA taxi;


ALTER SCHEMA taxi OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 229 (class 1259 OID 55016)
-- Name: cars; Type: TABLE; Schema: taxi; Owner: postgres
--

CREATE TABLE taxi.cars (
    car_id integer NOT NULL,
    model_mark character varying(100) NOT NULL,
    specs text,
    country_id integer,
    cost numeric(15,2),
    plate_number character varying(15),
    year_produced integer,
    mileage integer,
    last_service_date date,
    owner_type character varying(50),
    CONSTRAINT chk_car_cost CHECK ((cost > (0)::numeric)),
    CONSTRAINT chk_car_mileage CHECK ((mileage >= 0)),
    CONSTRAINT chk_plate_format CHECK (((plate_number)::text ~ '^[А-Я][0-9]{3}[А-Я]{2}[0-9]{2,3}$'::text)),
    CONSTRAINT chk_service_date CHECK ((last_service_date >= '2000-01-01'::date))
);


ALTER TABLE taxi.cars OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 55015)
-- Name: cars_car_id_seq; Type: SEQUENCE; Schema: taxi; Owner: postgres
--

CREATE SEQUENCE taxi.cars_car_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi.cars_car_id_seq OWNER TO postgres;

--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 228
-- Name: cars_car_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi; Owner: postgres
--

ALTER SEQUENCE taxi.cars_car_id_seq OWNED BY taxi.cars.car_id;


--
-- TOC entry 223 (class 1259 OID 54979)
-- Name: clients; Type: TABLE; Schema: taxi; Owner: postgres
--

CREATE TABLE taxi.clients (
    client_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    phone_number character varying(20) NOT NULL,
    bank_card character varying(20),
    CONSTRAINT chk_bank_card CHECK (((bank_card)::text ~ '^[0-9]{16,19}$'::text)),
    CONSTRAINT chk_client_phone CHECK (((phone_number)::text ~ '^\+7[0-9]{10}$'::text))
);


ALTER TABLE taxi.clients OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 54978)
-- Name: clients_client_id_seq; Type: SEQUENCE; Schema: taxi; Owner: postgres
--

CREATE SEQUENCE taxi.clients_client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi.clients_client_id_seq OWNER TO postgres;

--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 222
-- Name: clients_client_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi; Owner: postgres
--

ALTER SEQUENCE taxi.clients_client_id_seq OWNED BY taxi.clients.client_id;


--
-- TOC entry 219 (class 1259 OID 54965)
-- Name: countries; Type: TABLE; Schema: taxi; Owner: postgres
--

CREATE TABLE taxi.countries (
    country_id integer NOT NULL,
    country_name character varying(100) NOT NULL
);


ALTER TABLE taxi.countries OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 54964)
-- Name: countries_country_id_seq; Type: SEQUENCE; Schema: taxi; Owner: postgres
--

CREATE SEQUENCE taxi.countries_country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi.countries_country_id_seq OWNER TO postgres;

--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 218
-- Name: countries_country_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi; Owner: postgres
--

ALTER SEQUENCE taxi.countries_country_id_seq OWNED BY taxi.countries.country_id;


--
-- TOC entry 233 (class 1259 OID 55044)
-- Name: orders; Type: TABLE; Schema: taxi; Owner: postgres
--

CREATE TABLE taxi.orders (
    order_id integer NOT NULL,
    order_date date DEFAULT CURRENT_DATE,
    pickup_time timestamp without time zone,
    dropoff_time timestamp without time zone,
    from_address text,
    to_address text,
    distance_km numeric(10,2),
    wait_penalty_min integer DEFAULT 0,
    payment_type character varying(20),
    feedback text,
    admin_id integer,
    driver_id integer,
    car_id integer,
    client_id integer,
    tariff_id integer,
    CONSTRAINT chk_order_distance CHECK ((distance_km > (0)::numeric)),
    CONSTRAINT chk_order_payment CHECK (((payment_type)::text = ANY ((ARRAY['Наличные'::character varying, 'Онлайн'::character varying])::text[]))),
    CONSTRAINT chk_order_times CHECK (((dropoff_time IS NULL) OR (dropoff_time >= pickup_time))),
    CONSTRAINT chk_wait_penalty CHECK ((wait_penalty_min >= 0))
);


ALTER TABLE taxi.orders OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 55043)
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: taxi; Owner: postgres
--

CREATE SEQUENCE taxi.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi.orders_order_id_seq OWNER TO postgres;

--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 232
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi; Owner: postgres
--

ALTER SEQUENCE taxi.orders_order_id_seq OWNED BY taxi.orders.order_id;


--
-- TOC entry 227 (class 1259 OID 55000)
-- Name: passport_data; Type: TABLE; Schema: taxi; Owner: postgres
--

CREATE TABLE taxi.passport_data (
    passport_id integer NOT NULL,
    staff_id integer,
    series character varying(10),
    number character varying(10),
    issue_date date,
    issued_by text,
    CONSTRAINT chk_pass_date CHECK ((issue_date <= CURRENT_DATE)),
    CONSTRAINT chk_pass_number CHECK (((number)::text ~ '^[0-9]{6}$'::text)),
    CONSTRAINT chk_pass_series CHECK (((series)::text ~ '^[0-9]{4}$'::text))
);


ALTER TABLE taxi.passport_data OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 54999)
-- Name: passport_data_passport_id_seq; Type: SEQUENCE; Schema: taxi; Owner: postgres
--

CREATE SEQUENCE taxi.passport_data_passport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi.passport_data_passport_id_seq OWNER TO postgres;

--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 226
-- Name: passport_data_passport_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi; Owner: postgres
--

ALTER SEQUENCE taxi.passport_data_passport_id_seq OWNED BY taxi.passport_data.passport_id;


--
-- TOC entry 235 (class 1259 OID 55081)
-- Name: salary; Type: TABLE; Schema: taxi; Owner: postgres
--

CREATE TABLE taxi.salary (
    salary_id integer NOT NULL,
    staff_id integer,
    calc_date date,
    total_amount numeric(15,2),
    CONSTRAINT chk_salary_amount CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE taxi.salary OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 55080)
-- Name: salary_salary_id_seq; Type: SEQUENCE; Schema: taxi; Owner: postgres
--

CREATE SEQUENCE taxi.salary_salary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi.salary_salary_id_seq OWNER TO postgres;

--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 234
-- Name: salary_salary_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi; Owner: postgres
--

ALTER SEQUENCE taxi.salary_salary_id_seq OWNED BY taxi.salary.salary_id;


--
-- TOC entry 225 (class 1259 OID 54986)
-- Name: staff; Type: TABLE; Schema: taxi; Owner: postgres
--

CREATE TABLE taxi.staff (
    staff_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    address text,
    phone_number character varying(20),
    job_title character varying(100),
    category character varying(50),
    client_id integer,
    CONSTRAINT chk_job_title CHECK (((job_title)::text = ANY ((ARRAY['Администратор'::character varying, 'Водитель'::character varying])::text[]))),
    CONSTRAINT chk_staff_phone CHECK (((phone_number)::text ~ '^\+7[0-9]{10}$'::text))
);


ALTER TABLE taxi.staff OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 54985)
-- Name: staff_staff_id_seq; Type: SEQUENCE; Schema: taxi; Owner: postgres
--

CREATE SEQUENCE taxi.staff_staff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi.staff_staff_id_seq OWNER TO postgres;

--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 224
-- Name: staff_staff_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi; Owner: postgres
--

ALTER SEQUENCE taxi.staff_staff_id_seq OWNED BY taxi.staff.staff_id;


--
-- TOC entry 221 (class 1259 OID 54972)
-- Name: tariffs; Type: TABLE; Schema: taxi; Owner: postgres
--

CREATE TABLE taxi.tariffs (
    tariff_id integer NOT NULL,
    tariff_name character varying(50) NOT NULL,
    price_per_km numeric(10,2) NOT NULL,
    start_date date,
    end_date date,
    CONSTRAINT chk_tariff_dates CHECK (((end_date IS NULL) OR (end_date >= start_date))),
    CONSTRAINT chk_tariff_price CHECK ((price_per_km > (0)::numeric))
);


ALTER TABLE taxi.tariffs OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 54971)
-- Name: tariffs_tariff_id_seq; Type: SEQUENCE; Schema: taxi; Owner: postgres
--

CREATE SEQUENCE taxi.tariffs_tariff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi.tariffs_tariff_id_seq OWNER TO postgres;

--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 220
-- Name: tariffs_tariff_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi; Owner: postgres
--

ALTER SEQUENCE taxi.tariffs_tariff_id_seq OWNED BY taxi.tariffs.tariff_id;


--
-- TOC entry 231 (class 1259 OID 55032)
-- Name: work_schedule; Type: TABLE; Schema: taxi; Owner: postgres
--

CREATE TABLE taxi.work_schedule (
    schedule_id integer NOT NULL,
    staff_id integer,
    work_date date NOT NULL,
    shift_start time without time zone,
    shift_end time without time zone,
    CONSTRAINT chk_shift_time CHECK ((shift_end > shift_start))
);


ALTER TABLE taxi.work_schedule OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 55031)
-- Name: work_schedule_schedule_id_seq; Type: SEQUENCE; Schema: taxi; Owner: postgres
--

CREATE SEQUENCE taxi.work_schedule_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi.work_schedule_schedule_id_seq OWNER TO postgres;

--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 230
-- Name: work_schedule_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi; Owner: postgres
--

ALTER SEQUENCE taxi.work_schedule_schedule_id_seq OWNED BY taxi.work_schedule.schedule_id;


--
-- TOC entry 4741 (class 2604 OID 55019)
-- Name: cars car_id; Type: DEFAULT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.cars ALTER COLUMN car_id SET DEFAULT nextval('taxi.cars_car_id_seq'::regclass);


--
-- TOC entry 4738 (class 2604 OID 54982)
-- Name: clients client_id; Type: DEFAULT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.clients ALTER COLUMN client_id SET DEFAULT nextval('taxi.clients_client_id_seq'::regclass);


--
-- TOC entry 4736 (class 2604 OID 54968)
-- Name: countries country_id; Type: DEFAULT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.countries ALTER COLUMN country_id SET DEFAULT nextval('taxi.countries_country_id_seq'::regclass);


--
-- TOC entry 4743 (class 2604 OID 55047)
-- Name: orders order_id; Type: DEFAULT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.orders ALTER COLUMN order_id SET DEFAULT nextval('taxi.orders_order_id_seq'::regclass);


--
-- TOC entry 4740 (class 2604 OID 55003)
-- Name: passport_data passport_id; Type: DEFAULT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.passport_data ALTER COLUMN passport_id SET DEFAULT nextval('taxi.passport_data_passport_id_seq'::regclass);


--
-- TOC entry 4746 (class 2604 OID 55084)
-- Name: salary salary_id; Type: DEFAULT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.salary ALTER COLUMN salary_id SET DEFAULT nextval('taxi.salary_salary_id_seq'::regclass);


--
-- TOC entry 4739 (class 2604 OID 54989)
-- Name: staff staff_id; Type: DEFAULT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.staff ALTER COLUMN staff_id SET DEFAULT nextval('taxi.staff_staff_id_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 54975)
-- Name: tariffs tariff_id; Type: DEFAULT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.tariffs ALTER COLUMN tariff_id SET DEFAULT nextval('taxi.tariffs_tariff_id_seq'::regclass);


--
-- TOC entry 4742 (class 2604 OID 55035)
-- Name: work_schedule schedule_id; Type: DEFAULT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.work_schedule ALTER COLUMN schedule_id SET DEFAULT nextval('taxi.work_schedule_schedule_id_seq'::regclass);


--
-- TOC entry 4954 (class 0 OID 55016)
-- Dependencies: 229
-- Data for Name: cars; Type: TABLE DATA; Schema: taxi; Owner: postgres
--

COPY taxi.cars (car_id, model_mark, specs, country_id, cost, plate_number, year_produced, mileage, last_service_date, owner_type) FROM stdin;
1	Hyundai Solaris	\N	1	\N	А123РТ77	\N	\N	\N	Компания
2	Mercedes E-Class	\N	2	\N	О777ОО99	\N	\N	\N	Таксист
\.


--
-- TOC entry 4948 (class 0 OID 54979)
-- Dependencies: 223
-- Data for Name: clients; Type: TABLE DATA; Schema: taxi; Owner: postgres
--

COPY taxi.clients (client_id, full_name, phone_number, bank_card) FROM stdin;
1	Иванов И.И.	+79001112233	4444555566667777
2	Петров П.П.	+79005556677	\N
\.


--
-- TOC entry 4944 (class 0 OID 54965)
-- Dependencies: 219
-- Data for Name: countries; Type: TABLE DATA; Schema: taxi; Owner: postgres
--

COPY taxi.countries (country_id, country_name) FROM stdin;
1	Россия
2	Германия
3	Япония
\.


--
-- TOC entry 4958 (class 0 OID 55044)
-- Dependencies: 233
-- Data for Name: orders; Type: TABLE DATA; Schema: taxi; Owner: postgres
--

COPY taxi.orders (order_id, order_date, pickup_time, dropoff_time, from_address, to_address, distance_km, wait_penalty_min, payment_type, feedback, admin_id, driver_id, car_id, client_id, tariff_id) FROM stdin;
1	2026-03-27	\N	\N	ул. Ленина 1	аэропорт Домодедово	45.50	0	Онлайн	\N	\N	2	2	1	3
\.


--
-- TOC entry 4952 (class 0 OID 55000)
-- Dependencies: 227
-- Data for Name: passport_data; Type: TABLE DATA; Schema: taxi; Owner: postgres
--

COPY taxi.passport_data (passport_id, staff_id, series, number, issue_date, issued_by) FROM stdin;
\.


--
-- TOC entry 4960 (class 0 OID 55081)
-- Dependencies: 235
-- Data for Name: salary; Type: TABLE DATA; Schema: taxi; Owner: postgres
--

COPY taxi.salary (salary_id, staff_id, calc_date, total_amount) FROM stdin;
\.


--
-- TOC entry 4950 (class 0 OID 54986)
-- Dependencies: 225
-- Data for Name: staff; Type: TABLE DATA; Schema: taxi; Owner: postgres
--

COPY taxi.staff (staff_id, full_name, address, phone_number, job_title, category, client_id) FROM stdin;
1	Смирнова А.В.	\N	\N	Администратор	Высшая	\N
2	Быков Д.С.	\N	\N	Водитель	1 класс	\N
\.


--
-- TOC entry 4946 (class 0 OID 54972)
-- Dependencies: 221
-- Data for Name: tariffs; Type: TABLE DATA; Schema: taxi; Owner: postgres
--

COPY taxi.tariffs (tariff_id, tariff_name, price_per_km, start_date, end_date) FROM stdin;
1	Эконом	25.00	\N	\N
2	Комфорт	45.00	\N	\N
3	Бизнес	80.00	\N	\N
\.


--
-- TOC entry 4956 (class 0 OID 55032)
-- Dependencies: 231
-- Data for Name: work_schedule; Type: TABLE DATA; Schema: taxi; Owner: postgres
--

COPY taxi.work_schedule (schedule_id, staff_id, work_date, shift_start, shift_end) FROM stdin;
\.


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 228
-- Name: cars_car_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: postgres
--

SELECT pg_catalog.setval('taxi.cars_car_id_seq', 2, true);


--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 222
-- Name: clients_client_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: postgres
--

SELECT pg_catalog.setval('taxi.clients_client_id_seq', 2, true);


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 218
-- Name: countries_country_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: postgres
--

SELECT pg_catalog.setval('taxi.countries_country_id_seq', 3, true);


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 232
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: postgres
--

SELECT pg_catalog.setval('taxi.orders_order_id_seq', 1, true);


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 226
-- Name: passport_data_passport_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: postgres
--

SELECT pg_catalog.setval('taxi.passport_data_passport_id_seq', 1, false);


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 234
-- Name: salary_salary_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: postgres
--

SELECT pg_catalog.setval('taxi.salary_salary_id_seq', 1, false);


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 224
-- Name: staff_staff_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: postgres
--

SELECT pg_catalog.setval('taxi.staff_staff_id_seq', 2, true);


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 220
-- Name: tariffs_tariff_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: postgres
--

SELECT pg_catalog.setval('taxi.tariffs_tariff_id_seq', 3, true);


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 230
-- Name: work_schedule_schedule_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: postgres
--

SELECT pg_catalog.setval('taxi.work_schedule_schedule_id_seq', 1, false);


--
-- TOC entry 4779 (class 2606 OID 55023)
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (car_id);


--
-- TOC entry 4781 (class 2606 OID 55025)
-- Name: cars cars_plate_number_key; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.cars
    ADD CONSTRAINT cars_plate_number_key UNIQUE (plate_number);


--
-- TOC entry 4771 (class 2606 OID 54984)
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (client_id);


--
-- TOC entry 4767 (class 2606 OID 54970)
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- TOC entry 4785 (class 2606 OID 55054)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4775 (class 2606 OID 55007)
-- Name: passport_data passport_data_pkey; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.passport_data
    ADD CONSTRAINT passport_data_pkey PRIMARY KEY (passport_id);


--
-- TOC entry 4777 (class 2606 OID 55009)
-- Name: passport_data passport_data_staff_id_key; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.passport_data
    ADD CONSTRAINT passport_data_staff_id_key UNIQUE (staff_id);


--
-- TOC entry 4787 (class 2606 OID 55086)
-- Name: salary salary_pkey; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.salary
    ADD CONSTRAINT salary_pkey PRIMARY KEY (salary_id);


--
-- TOC entry 4773 (class 2606 OID 54993)
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.staff
    ADD CONSTRAINT staff_pkey PRIMARY KEY (staff_id);


--
-- TOC entry 4769 (class 2606 OID 54977)
-- Name: tariffs tariffs_pkey; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.tariffs
    ADD CONSTRAINT tariffs_pkey PRIMARY KEY (tariff_id);


--
-- TOC entry 4783 (class 2606 OID 55037)
-- Name: work_schedule work_schedule_pkey; Type: CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.work_schedule
    ADD CONSTRAINT work_schedule_pkey PRIMARY KEY (schedule_id);


--
-- TOC entry 4790 (class 2606 OID 55026)
-- Name: cars cars_country_id_fkey; Type: FK CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.cars
    ADD CONSTRAINT cars_country_id_fkey FOREIGN KEY (country_id) REFERENCES taxi.countries(country_id);


--
-- TOC entry 4792 (class 2606 OID 55055)
-- Name: orders orders_admin_id_fkey; Type: FK CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT orders_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES taxi.staff(staff_id);


--
-- TOC entry 4793 (class 2606 OID 55065)
-- Name: orders orders_car_id_fkey; Type: FK CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT orders_car_id_fkey FOREIGN KEY (car_id) REFERENCES taxi.cars(car_id);


--
-- TOC entry 4794 (class 2606 OID 55070)
-- Name: orders orders_client_id_fkey; Type: FK CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT orders_client_id_fkey FOREIGN KEY (client_id) REFERENCES taxi.clients(client_id);


--
-- TOC entry 4795 (class 2606 OID 55060)
-- Name: orders orders_driver_id_fkey; Type: FK CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT orders_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES taxi.staff(staff_id);


--
-- TOC entry 4796 (class 2606 OID 55075)
-- Name: orders orders_tariff_id_fkey; Type: FK CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT orders_tariff_id_fkey FOREIGN KEY (tariff_id) REFERENCES taxi.tariffs(tariff_id);


--
-- TOC entry 4789 (class 2606 OID 55010)
-- Name: passport_data passport_data_staff_id_fkey; Type: FK CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.passport_data
    ADD CONSTRAINT passport_data_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES taxi.staff(staff_id);


--
-- TOC entry 4797 (class 2606 OID 55087)
-- Name: salary salary_staff_id_fkey; Type: FK CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.salary
    ADD CONSTRAINT salary_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES taxi.staff(staff_id);


--
-- TOC entry 4788 (class 2606 OID 54994)
-- Name: staff staff_client_id_fkey; Type: FK CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.staff
    ADD CONSTRAINT staff_client_id_fkey FOREIGN KEY (client_id) REFERENCES taxi.clients(client_id);


--
-- TOC entry 4791 (class 2606 OID 55038)
-- Name: work_schedule work_schedule_staff_id_fkey; Type: FK CONSTRAINT; Schema: taxi; Owner: postgres
--

ALTER TABLE ONLY taxi.work_schedule
    ADD CONSTRAINT work_schedule_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES taxi.staff(staff_id);


-- Completed on 2026-03-30 12:47:06

--
-- PostgreSQL database dump complete
--

