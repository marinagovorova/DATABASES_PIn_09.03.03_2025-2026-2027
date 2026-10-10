--
-- PostgreSQL database dump
--

\restrict zHfzVYNHwb6rxDaU6YUMbY1q8VzHSjoQFRuHLBvpvEsoPPyVqJhaAQKvY8jHipL

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-04-05 18:35:52

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
-- Name: bank; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA bank;


ALTER SCHEMA bank OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16408)
-- Name: client; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank.client (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    phone_number character varying(20),
    email character varying(100),
    passport character varying(11) NOT NULL,
    address character varying(150),
    CONSTRAINT client_id_positive CHECK ((id > 0)),
    CONSTRAINT client_phone_check CHECK (phone_number ~ '^\+?[0-9]{11}$'),
    CONSTRAINT client_email_check CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT client_passport_format_check CHECK (passport ~ '^[0-9]{4}\s?[0-9]{6}$')
);



ALTER TABLE bank.client OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16496)
-- Name: credit_contract; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank.credit_contract (
    id integer NOT NULL,
    date_start date NOT NULL,
    date_end date NOT NULL,
    client_id integer NOT NULL,
    employee_id integer NOT NULL,
    currency_id integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    credit_type_id integer NOT NULL,
    CONSTRAINT positive_credit_amount CHECK ((amount > (0)::numeric)),
    CONSTRAINT valid_deposit_dates CHECK ((date_end > date_start))
);


ALTER TABLE bank.credit_contract OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16448)
-- Name: credit_type; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank.credit_type (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255),
    minimum_amount numeric(12,2) NOT NULL,
    minimum_term integer NOT NULL,
    interest_rate numeric(5,2) NOT NULL,
    CONSTRAINT positive_interest_rate CHECK ((interest_rate >= (0)::numeric)),
    CONSTRAINT positive_minimum_amount CHECK ((minimum_amount > (0)::numeric)),
    CONSTRAINT positive_minimum_term CHECK ((minimum_term > 0))
);


ALTER TABLE bank.credit_type OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16399)
-- Name: currency; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank.currency (
    id integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE bank.currency OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16461)
-- Name: deposit_contract; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank.deposit_contract (
    id integer NOT NULL,
    date_start date NOT NULL,
    date_end date NOT NULL,
    amount numeric(12,2) NOT NULL,
    currency_id integer NOT NULL,
    deposit_type_id integer NOT NULL,
    employee_id integer NOT NULL,
    client_id integer NOT NULL,
    CONSTRAINT positive_deposit_amount CHECK ((amount > (0)::numeric)),
    CONSTRAINT valid_deposit_dates CHECK ((date_end > date_start))
);


ALTER TABLE bank.deposit_contract OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16563)
-- Name: deposit_interest; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank.deposit_interest (
    id integer NOT NULL,
    deposit_contract_id integer NOT NULL,
    month integer NOT NULL,
    accrued_amount numeric(12,2) NOT NULL,
    accrued_interest numeric(12,2) NOT NULL,
    CONSTRAINT deposit_interest_amount_nonnegative CHECK ((accrued_amount >= (0)::numeric)),
    CONSTRAINT deposit_interest_interest_nonnegative CHECK ((accrued_interest >= (0)::numeric)),
    CONSTRAINT deposit_interest_month CHECK ((month >= 1))
);


ALTER TABLE bank.deposit_interest OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16435)
-- Name: deposit_type; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank.deposit_type (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255),
    minimum_term integer NOT NULL,
    minimum_amount numeric(12,2) NOT NULL,
    interest_rate numeric(5,2) NOT NULL,
    CONSTRAINT positive_interest_rate CHECK ((interest_rate >= (0)::numeric)),
    CONSTRAINT positive_minimum_amount CHECK ((minimum_amount > (0)::numeric)),
    CONSTRAINT positive_minimum_term CHECK ((minimum_term > 0))
);


ALTER TABLE bank.deposit_type OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16419)
-- Name: employee; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank.employee (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    phone_number character varying(20),
    address character varying(150),
    id_position integer NOT NULL,
    passport character varying(11) NOT NULL,
    CONSTRAINT employee_phone_check CHECK (phone_number ~ '^\+?[0-9]{11}$'),
    CONSTRAINT employee_passport_check CHECK (passport ~ '^[0-9]{4}\s?[0-9]{6}$')

);


ALTER TABLE bank.employee OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16550)
-- Name: payment_fact; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank.payment_fact (
    id integer NOT NULL,
    is_overdue boolean NOT NULL,
    payment_date date,
    payment_id integer NOT NULL
);


ALTER TABLE bank.payment_fact OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16531)
-- Name: payment_schedule; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank.payment_schedule (
    id integer NOT NULL,
    contract_id integer NOT NULL,
    month_number integer NOT NULL,
    payment_date date NOT NULL,
    principal_amount numeric(12,2) NOT NULL,
    interest_amount numeric(12,2) NOT NULL,
    CONSTRAINT positive_interest_amount CHECK ((interest_amount >= (0)::numeric)),
    CONSTRAINT "positive_month_number " CHECK ((month_number >= 1)),
    CONSTRAINT "positive_principal_amount " CHECK ((principal_amount >= (0)::numeric))
);


ALTER TABLE bank.payment_schedule OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: position; Type: TABLE; Schema: bank; Owner: postgres
--

CREATE TABLE bank."position" (
    id integer NOT NULL,
    "name" character varying(50) NOT NULL,
    salary numeric(10,2) NOT NULL,
    CONSTRAINT salary_positive CHECK ((salary > (0)::numeric))
);


ALTER TABLE bank."position" OWNER TO postgres;

--
-- TOC entry 5103 (class 0 OID 16408)
-- Dependencies: 222
-- Data for Name: client; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank.client (id, name, phone_number, email, passport, address) FROM stdin;
1	Иванов Иван Иванович	+79990000001	ivanov1@mail.ru	4010 123456	Санкт-Петербург, Невский пр., 1
2	Петров Петр Петрович	+79990000002	petrov2@mail.ru	4011 123457	Санкт-Петербург, Литейный пр., 15
3	Сидорова Анна Викторовна	+79990000003	sidorova3@mail.ru	4012 123458	Санкт-Петербург, Московский пр., 24
4	Кузнецов Алексей Сергеевич	+79990000004	kuznetsov4@mail.ru	4013 123459	Санкт-Петербург, ул. Марата, 7
5	Смирнова Мария Олеговна	+79990000005	smirnova5@mail.ru	4014 123460	Санкт-Петербург, ул. Савушкина, 18
\.


--
-- TOC entry 5108 (class 0 OID 16496)
-- Dependencies: 227
-- Data for Name: credit_contract; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank.credit_contract (id, date_start, date_end, client_id, employee_id, currency_id, amount, credit_type_id) FROM stdin;
1	2026-04-01	2026-10-01	2	2	1	100000.00	1
2	2026-02-01	2027-02-01	4	2	1	450000.00	2
3	2026-01-10	2031-01-10	5	2	1	2500000.00	3
\.


--
-- TOC entry 5106 (class 0 OID 16448)
-- Dependencies: 225
-- Data for Name: credit_type; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank.credit_type (id, name, description, minimum_amount, minimum_term, interest_rate) FROM stdin;
1	Потребительский	Кредит на личные нужды	30000.00	6	19.90
2	Автокредит	Кредит на покупку автомобиля	200000.00	12	14.50
3	Ипотека	Кредит на недвижимость	1000000.00	60	11.20
\.


--
-- TOC entry 5102 (class 0 OID 16399)
-- Dependencies: 221
-- Data for Name: currency; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank.currency (id, name) FROM stdin;
1	RUB
2	USD
3	EUR
\.


--
-- TOC entry 5107 (class 0 OID 16461)
-- Dependencies: 226
-- Data for Name: deposit_contract; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank.deposit_contract (id, date_start, date_end, amount, currency_id, deposit_type_id, employee_id, client_id) FROM stdin;
1	2026-04-01	2026-10-01	120000.00	1	1	1	1
2	2026-03-15	2027-03-15	300000.00	1	2	1	3
3	2026-04-05	2026-07-05	15000.00	1	3	3	5
\.


--
-- TOC entry 5111 (class 0 OID 16563)
-- Dependencies: 230
-- Data for Name: deposit_interest; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank.deposit_interest (id, deposit_contract_id, month, accrued_amount, accrued_interest) FROM stdin;
1	1	4	850.00	8.50
2	1	5	850.00	8.50
3	2	3	2500.00	10.00
4	3	4	90.00	7.20
\.


--
-- TOC entry 5105 (class 0 OID 16435)
-- Dependencies: 224
-- Data for Name: deposit_type; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank.deposit_type (id, name, description, minimum_term, minimum_amount, interest_rate) FROM stdin;
1	Накопительный	Пополняемый вклад	6	10000.00	8.50
2	Срочный	Без пополнения	12	50000.00	10.00
3	Пенсионный	Льготный вклад	3	5000.00	7.20
\.


--
-- TOC entry 5104 (class 0 OID 16419)
-- Dependencies: 223
-- Data for Name: employee; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank.employee (id, name, phone_number, address, id_position, passport) FROM stdin;
1	Орлова Наталья Игоревна	+79000000001	Санкт-Петербург, ул. Типанова, 10	1	5001 111111
2	Федоров Максим Андреевич	+79000000002	Санкт-Петербург, ул. Бассейная, 21	2	5002 111112
3	Егорова Елена Павловна	+79000000003	Санкт-Петербург, ул. Варшавская, 33	3	5003 111113
\.


--
-- TOC entry 5110 (class 0 OID 16550)
-- Dependencies: 229
-- Data for Name: payment_fact; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank.payment_fact (id, is_overdue, payment_date, payment_id) FROM stdin;
1	f	2026-05-01	1
2	t	\N	2
3	f	2026-03-01	3
4	f	2026-04-02	4
\.


--
-- TOC entry 5109 (class 0 OID 16531)
-- Dependencies: 228
-- Data for Name: payment_schedule; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank.payment_schedule (id, contract_id, month_number, payment_date, principal_amount, interest_amount) FROM stdin;
1	1	1	2026-05-01	15000.00	2500.00
2	1	2	2026-06-01	15000.00	2200.00
3	2	1	2026-03-01	30000.00	5000.00
4	2	2	2026-04-01	30000.00	4700.00
5	3	1	2026-02-10	20000.00	15000.00
6	3	2	2026-03-10	20000.00	14800.00
\.


--
-- TOC entry 5101 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: position; Type: TABLE DATA; Schema: bank; Owner: postgres
--

COPY bank."position" (id, "name ", salary) FROM stdin;
1	Менеджер	70000.00
2	Кредитный специалист	85000.00
3	Консультант	60000.00
\.


--
-- TOC entry 4921 (class 2606 OID 16418)
-- Name: client client_passport_unique; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.client
    ADD CONSTRAINT client_passport_unique UNIQUE (passport);


--
-- TOC entry 4923 (class 2606 OID 16416)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


--
-- TOC entry 4935 (class 2606 OID 16510)
-- Name: credit_contract credit_contract_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.credit_contract
    ADD CONSTRAINT credit_contract_pkey PRIMARY KEY (id);


--
-- TOC entry 4931 (class 2606 OID 16460)
-- Name: credit_type credit_type_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.credit_type
    ADD CONSTRAINT credit_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4917 (class 2606 OID 16407)
-- Name: currency currency_name_unique; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.currency
    ADD CONSTRAINT currency_name_unique UNIQUE (name);


--
-- TOC entry 4919 (class 2606 OID 16405)
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (id);


--
-- TOC entry 4933 (class 2606 OID 16475)
-- Name: deposit_contract deposit_contract_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.deposit_contract
    ADD CONSTRAINT deposit_contract_pkey PRIMARY KEY (id);


--
-- TOC entry 4941 (class 2606 OID 16575)
-- Name: deposit_interest deposit_interest_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.deposit_interest
    ADD CONSTRAINT deposit_interest_pkey PRIMARY KEY (id);


--
-- TOC entry 4929 (class 2606 OID 16447)
-- Name: deposit_type deposit_type_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.deposit_type
    ADD CONSTRAINT deposit_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4925 (class 2606 OID 16429)
-- Name: employee employee_passport_unique; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.employee
    ADD CONSTRAINT employee_passport_unique UNIQUE (passport);


--
-- TOC entry 4927 (class 2606 OID 16427)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- TOC entry 4939 (class 2606 OID 16557)
-- Name: payment_fact payment_fact_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.payment_fact
    ADD CONSTRAINT payment_fact_pkey PRIMARY KEY (id);


--
-- TOC entry 4937 (class 2606 OID 16544)
-- Name: payment_schedule payment_schedule_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.payment_schedule
    ADD CONSTRAINT payment_schedule_pkey PRIMARY KEY (id);


--
-- TOC entry 4915 (class 2606 OID 16398)
-- Name: position position_pkey; Type: CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (id);


--
-- TOC entry 4947 (class 2606 OID 16511)
-- Name: credit_contract credit_contract_currency_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.credit_contract
    ADD CONSTRAINT credit_contract_currency_fk FOREIGN KEY (currency_id) REFERENCES bank.currency(id);


--
-- TOC entry 4948 (class 2606 OID 16526)
-- Name: credit_contract credit_contract_employee_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.credit_contract
    ADD CONSTRAINT credit_contract_employee_fk FOREIGN KEY (employee_id) REFERENCES bank.employee(id);


--
-- TOC entry 4949 (class 2606 OID 16516)
-- Name: credit_contract credit_contract_type_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.credit_contract
    ADD CONSTRAINT credit_contract_type_fk FOREIGN KEY (credit_type_id) REFERENCES bank.credit_type(id);


--
-- TOC entry 4950 (class 2606 OID 16521)
-- Name: credit_contract credt_contract_client_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.credit_contract
    ADD CONSTRAINT credt_contract_client_fk FOREIGN KEY (client_id) REFERENCES bank.client(id);


--
-- TOC entry 4943 (class 2606 OID 16486)
-- Name: deposit_contract deposit_contract_client_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.deposit_contract
    ADD CONSTRAINT deposit_contract_client_fk FOREIGN KEY (client_id) REFERENCES bank.client(id);


--
-- TOC entry 4944 (class 2606 OID 16476)
-- Name: deposit_contract deposit_contract_currency_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.deposit_contract
    ADD CONSTRAINT deposit_contract_currency_fk FOREIGN KEY (currency_id) REFERENCES bank.currency(id);


--
-- TOC entry 4945 (class 2606 OID 16491)
-- Name: deposit_contract deposit_contract_employee_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.deposit_contract
    ADD CONSTRAINT deposit_contract_employee_fk FOREIGN KEY (employee_id) REFERENCES bank.employee(id);


--
-- TOC entry 4946 (class 2606 OID 16481)
-- Name: deposit_contract deposit_contract_type_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.deposit_contract
    ADD CONSTRAINT deposit_contract_type_fk FOREIGN KEY (deposit_type_id) REFERENCES bank.deposit_type(id);


--
-- TOC entry 4953 (class 2606 OID 16576)
-- Name: deposit_interest deposit_interest_contract_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.deposit_interest
    ADD CONSTRAINT deposit_interest_contract_fk FOREIGN KEY (deposit_contract_id) REFERENCES bank.deposit_contract(id);


--
-- TOC entry 4942 (class 2606 OID 16430)
-- Name: employee employee_position_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.employee
    ADD CONSTRAINT employee_position_fk FOREIGN KEY (id_position) REFERENCES bank."position"(id);


--
-- TOC entry 4952 (class 2606 OID 16558)
-- Name: payment_fact payment_fact_schedule_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.payment_fact
    ADD CONSTRAINT payment_fact_schedule_fk FOREIGN KEY (payment_id) REFERENCES bank.payment_schedule(id);


--
-- TOC entry 4951 (class 2606 OID 16545)
-- Name: payment_schedule payment_schedule_contract_fk; Type: FK CONSTRAINT; Schema: bank; Owner: postgres
--

ALTER TABLE ONLY bank.payment_schedule
    ADD CONSTRAINT payment_schedule_contract_fk FOREIGN KEY (contract_id) REFERENCES bank.credit_contract(id);


-- Completed on 2026-04-05 18:35:52

--
-- PostgreSQL database dump complete
--

\unrestrict zHfzVYNHwb6rxDaU6YUMbY1q8VzHSjoQFRuHLBvpvEsoPPyVqJhaAQKvY8jHipL

