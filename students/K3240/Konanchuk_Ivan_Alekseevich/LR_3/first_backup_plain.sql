--
-- PostgreSQL database dump
--

\restrict gelD0cPkLHhOmTKTbhlHbMeVn3nENEs2Ms2OUgzd3WnpzyaUUdEwdJEvIHilQYN

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-04-10 03:23:05

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
-- Name: azs; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA azs;


ALTER SCHEMA azs OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 16590)
-- Name: card_account; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.card_account (
    id_card integer NOT NULL,
    id_customer integer NOT NULL,
    issue_date date NOT NULL,
    valid_until date NOT NULL,
    balance numeric(12,2) NOT NULL,
    CONSTRAINT ck_card_account_balance CHECK ((balance >= (0)::numeric)),
    CONSTRAINT ck_card_account_id_positive CHECK ((id_card > 0)),
    CONSTRAINT ck_card_account_issue_date CHECK ((issue_date <= CURRENT_DATE)),
    CONSTRAINT ck_card_account_valid_until CHECK ((valid_until >= issue_date))
);


ALTER TABLE azs.card_account OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16477)
-- Name: city; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.city (
    id_city integer NOT NULL,
    city_name character varying(50) NOT NULL,
    region_code integer NOT NULL,
    CONSTRAINT ck_city_id_positive CHECK ((id_city > 0)),
    CONSTRAINT ck_city_name_not_blank CHECK (((char_length(btrim((city_name)::text)) >= 1) AND (char_length(btrim((city_name)::text)) <= 50))),
    CONSTRAINT ck_city_region_code CHECK (((region_code >= 1) AND (region_code <= 999)))
);


ALTER TABLE azs.city OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16490)
-- Name: company; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.company (
    id_company integer NOT NULL,
    company_name character varying(100) NOT NULL,
    company_address character varying(200) NOT NULL,
    company_phone character varying(16) NOT NULL,
    company_email character varying(254) NOT NULL,
    CONSTRAINT ck_company_address_len CHECK (((char_length(btrim((company_address)::text)) >= 1) AND (char_length(btrim((company_address)::text)) <= 200))),
    CONSTRAINT ck_company_email_format CHECK (((company_email)::text ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$'::text)),
    CONSTRAINT ck_company_id_positive CHECK ((id_company > 0)),
    CONSTRAINT ck_company_name_len CHECK (((char_length(btrim((company_name)::text)) >= 1) AND (char_length(btrim((company_name)::text)) <= 100))),
    CONSTRAINT ck_company_phone_format CHECK (((company_phone)::text ~ '^\+?[0-9]{10,15}$'::text))
);


ALTER TABLE azs.company OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16567)
-- Name: company_fuel; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.company_fuel (
    id_company_fuel integer NOT NULL,
    id_company integer NOT NULL,
    id_fuel_type integer NOT NULL,
    fuel_name character varying(60) NOT NULL,
    CONSTRAINT ck_company_fuel_id_positive CHECK ((id_company_fuel > 0)),
    CONSTRAINT ck_company_fuel_name_len CHECK (((char_length(btrim((fuel_name)::text)) >= 1) AND (char_length(btrim((fuel_name)::text)) <= 60)))
);


ALTER TABLE azs.company_fuel OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16526)
-- Name: customer; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.customer (
    id_customer integer NOT NULL,
    full_name character varying(100) NOT NULL,
    customer_email character varying(254) NOT NULL,
    customer_phone character varying(16) NOT NULL,
    CONSTRAINT ck_customer_email_format CHECK (((customer_email)::text ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$'::text)),
    CONSTRAINT ck_customer_full_name_len CHECK (((char_length(btrim((full_name)::text)) >= 1) AND (char_length(btrim((full_name)::text)) <= 100))),
    CONSTRAINT ck_customer_full_name_words CHECK (((full_name)::text ~ '^[A-Za-z]+([ -][A-Za-z]+)+$'::text)),
    CONSTRAINT ck_customer_id_positive CHECK ((id_customer > 0)),
    CONSTRAINT ck_customer_phone_format CHECK (((customer_phone)::text ~ '^\+?[0-9]{10,15}$'::text))
);


ALTER TABLE azs.customer OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16628)
-- Name: discount; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.discount (
    id_discount integer NOT NULL,
    id_card integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    discount_percent smallint NOT NULL,
    discount_type character varying(30) NOT NULL,
    CONSTRAINT ck_discount_dates CHECK (((end_date IS NULL) OR (end_date >= start_date))),
    CONSTRAINT ck_discount_id_positive CHECK ((id_discount > 0)),
    CONSTRAINT ck_discount_percent CHECK (((discount_percent >= 0) AND (discount_percent <= 100))),
    CONSTRAINT ck_discount_type_len CHECK (((char_length(btrim((discount_type)::text)) >= 1) AND (char_length(btrim((discount_type)::text)) <= 30)))
);


ALTER TABLE azs.discount OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16509)
-- Name: fuel_type; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.fuel_type (
    id_fuel_type integer NOT NULL,
    fuel_kind character varying(20) NOT NULL,
    fuel_group character varying(30),
    brand character varying(20) NOT NULL,
    octane_number smallint,
    eco_class smallint NOT NULL,
    seasonality character varying(10),
    standard_name character varying(50),
    CONSTRAINT ck_fuel_type_brand_len CHECK (((char_length(btrim((brand)::text)) >= 1) AND (char_length(btrim((brand)::text)) <= 20))),
    CONSTRAINT ck_fuel_type_eco_class CHECK (((eco_class >= 0) AND (eco_class <= 6))),
    CONSTRAINT ck_fuel_type_group_len CHECK (((fuel_group IS NULL) OR (char_length(btrim((fuel_group)::text)) <= 30))),
    CONSTRAINT ck_fuel_type_id_positive CHECK ((id_fuel_type > 0)),
    CONSTRAINT ck_fuel_type_kind CHECK (((fuel_kind)::text = ANY ((ARRAY['gasoline'::character varying, 'diesel'::character varying, 'gas'::character varying])::text[]))),
    CONSTRAINT ck_fuel_type_octane CHECK (((octane_number IS NULL) OR ((octane_number >= 40) AND (octane_number <= 120)))),
    CONSTRAINT ck_fuel_type_seasonality CHECK (((seasonality IS NULL) OR ((seasonality)::text = ANY ((ARRAY['L'::character varying, 'E'::character varying, 'Z'::character varying, 'A'::character varying, 'VS'::character varying])::text[])))),
    CONSTRAINT ck_fuel_type_standard_len CHECK (((standard_name IS NULL) OR (char_length(btrim((standard_name)::text)) <= 50)))
);


ALTER TABLE azs.fuel_type OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16609)
-- Name: price_history; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.price_history (
    id_price integer NOT NULL,
    id_company_fuel integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    price_per_unit numeric(10,2) NOT NULL,
    CONSTRAINT ck_price_history_dates CHECK (((end_date IS NULL) OR (end_date >= start_date))),
    CONSTRAINT ck_price_history_id_positive CHECK ((id_price > 0)),
    CONSTRAINT ck_price_history_price CHECK ((price_per_unit > (0)::numeric))
);


ALTER TABLE azs.price_history OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16649)
-- Name: sale; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.sale (
    id_sale integer NOT NULL,
    id_card integer NOT NULL,
    id_station integer NOT NULL,
    id_company_fuel integer NOT NULL,
    sale_datetime timestamp without time zone NOT NULL,
    liters numeric(10,3) NOT NULL,
    total_amount numeric(12,2) NOT NULL,
    status character varying(15) NOT NULL,
    CONSTRAINT ck_sale_datetime CHECK ((sale_datetime <= now())),
    CONSTRAINT ck_sale_id_positive CHECK ((id_sale > 0)),
    CONSTRAINT ck_sale_liters CHECK (((liters > (0)::numeric) AND (liters <= (500)::numeric))),
    CONSTRAINT ck_sale_status CHECK (((status)::text = ANY ((ARRAY['completed'::character varying, 'cancelled'::character varying, 'processing'::character varying])::text[]))),
    CONSTRAINT ck_sale_total_amount CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE azs.sale OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16540)
-- Name: station; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.station (
    id_station integer NOT NULL,
    id_company integer NOT NULL,
    id_city integer NOT NULL,
    station_type character varying(10) NOT NULL,
    station_address character varying(200) NOT NULL,
    station_phone character varying(16) NOT NULL,
    CONSTRAINT ck_station_address_len CHECK (((char_length(btrim((station_address)::text)) >= 1) AND (char_length(btrim((station_address)::text)) <= 200))),
    CONSTRAINT ck_station_id_positive CHECK ((id_station > 0)),
    CONSTRAINT ck_station_phone_format CHECK (((station_phone)::text ~ '^\+?[0-9]{10,15}$'::text)),
    CONSTRAINT ck_station_type CHECK (((station_type)::text = ANY ((ARRAY['AZS'::character varying, 'AZGS'::character varying])::text[])))
);


ALTER TABLE azs.station OWNER TO postgres;

--
-- TOC entry 5130 (class 0 OID 16590)
-- Dependencies: 226
-- Data for Name: card_account; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.card_account (id_card, id_customer, issue_date, valid_until, balance) FROM stdin;
1	1	2025-01-15	2028-01-15	5000.00
2	2	2025-03-10	2028-03-10	3200.00
3	3	2025-05-20	2028-05-20	1500.00
\.


--
-- TOC entry 5124 (class 0 OID 16477)
-- Dependencies: 220
-- Data for Name: city; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.city (id_city, city_name, region_code) FROM stdin;
1	Saint Petersburg	78
2	Moscow	77
3	Kazan	16
\.


--
-- TOC entry 5125 (class 0 OID 16490)
-- Dependencies: 221
-- Data for Name: company; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.company (id_company, company_name, company_address, company_phone, company_email) FROM stdin;
1	Lukoil	Saint Petersburg, Nevsky Ave, 100	+78120000001	office@lukoil.test
2	Gazprom Neft	Moscow, Leningradsky Ave, 50	+74950000002	info@gpn.test
\.


--
-- TOC entry 5129 (class 0 OID 16567)
-- Dependencies: 225
-- Data for Name: company_fuel; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.company_fuel (id_company_fuel, id_company, id_fuel_type, fuel_name) FROM stdin;
1	1	1	AI-92 Lukoil
2	1	2	AI-95 Lukoil
3	2	2	AI-95 G-Drive
4	2	3	DT Gazprom Neft
\.


--
-- TOC entry 5127 (class 0 OID 16526)
-- Dependencies: 223
-- Data for Name: customer; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.customer (id_customer, full_name, customer_email, customer_phone) FROM stdin;
1	Ivan Ivanov	ivanov@test.ru	+79000000001
2	Petr Petrov	petrov@test.ru	+79000000002
3	Anna Sidorova	sidorova@test.ru	+79000000003
\.


--
-- TOC entry 5132 (class 0 OID 16628)
-- Dependencies: 228
-- Data for Name: discount; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.discount (id_discount, id_card, start_date, end_date, discount_percent, discount_type) FROM stdin;
1	1	2026-01-01	\N	5	permanent
2	2	2026-02-01	\N	7	personal
3	3	2026-03-01	2026-12-31	3	promo
\.


--
-- TOC entry 5126 (class 0 OID 16509)
-- Dependencies: 222
-- Data for Name: fuel_type; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.fuel_type (id_fuel_type, fuel_kind, fuel_group, brand, octane_number, eco_class, seasonality, standard_name) FROM stdin;
1	gasoline	liquid	AI-92	92	5	\N	Euro-5
2	gasoline	liquid	AI-95	95	5	\N	Euro-5
3	diesel	liquid	DT	\N	5	Z	Euro-5
4	gas	gas	Propan	\N	5	\N	GOST
\.


--
-- TOC entry 5131 (class 0 OID 16609)
-- Dependencies: 227
-- Data for Name: price_history; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.price_history (id_price, id_company_fuel, start_date, end_date, price_per_unit) FROM stdin;
1	1	2026-01-01	2026-02-28	56.90
2	1	2026-03-01	\N	57.90
3	2	2026-03-01	\N	61.40
4	3	2026-03-01	\N	63.20
5	4	2026-03-01	\N	68.90
\.


--
-- TOC entry 5133 (class 0 OID 16649)
-- Dependencies: 229
-- Data for Name: sale; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.sale (id_sale, id_card, id_station, id_company_fuel, sale_datetime, liters, total_amount, status) FROM stdin;
1	1	1	1	2026-03-05 10:15:00	30.500	1677.65	completed
2	2	2	2	2026-03-06 12:40:00	20.000	1142.04	completed
3	3	4	4	2026-03-07 09:20:00	35.000	2339.16	completed
4	1	3	3	2026-03-08 18:05:00	15.250	915.61	completed
\.


--
-- TOC entry 5128 (class 0 OID 16540)
-- Dependencies: 224
-- Data for Name: station; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.station (id_station, id_company, id_city, station_type, station_address, station_phone) FROM stdin;
1	1	1	AZS	Saint Petersburg, Nevsky Ave, 10	+78125550001
2	1	2	AZS	Moscow, Leningradsky Ave, 15	+74955550002
3	2	1	AZS	Saint Petersburg, Moskovsky Ave, 25	+78125550003
4	2	3	AZGS	Kazan, Pobedy Ave, 40	+78435550004
\.


--
-- TOC entry 4956 (class 2606 OID 16603)
-- Name: card_account card_account_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.card_account
    ADD CONSTRAINT card_account_pkey PRIMARY KEY (id_card);


--
-- TOC entry 4936 (class 2606 OID 16487)
-- Name: city city_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (id_city);


--
-- TOC entry 4952 (class 2606 OID 16577)
-- Name: company_fuel company_fuel_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.company_fuel
    ADD CONSTRAINT company_fuel_pkey PRIMARY KEY (id_company_fuel);


--
-- TOC entry 4940 (class 2606 OID 16506)
-- Name: company company_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id_company);


--
-- TOC entry 4946 (class 2606 OID 16539)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id_customer);


--
-- TOC entry 4962 (class 2606 OID 16641)
-- Name: discount discount_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.discount
    ADD CONSTRAINT discount_pkey PRIMARY KEY (id_discount);


--
-- TOC entry 4944 (class 2606 OID 16525)
-- Name: fuel_type fuel_type_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.fuel_type
    ADD CONSTRAINT fuel_type_pkey PRIMARY KEY (id_fuel_type);


--
-- TOC entry 4958 (class 2606 OID 16620)
-- Name: price_history price_history_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.price_history
    ADD CONSTRAINT price_history_pkey PRIMARY KEY (id_price);


--
-- TOC entry 4966 (class 2606 OID 16666)
-- Name: sale sale_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.sale
    ADD CONSTRAINT sale_pkey PRIMARY KEY (id_sale);


--
-- TOC entry 4948 (class 2606 OID 16554)
-- Name: station station_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.station
    ADD CONSTRAINT station_pkey PRIMARY KEY (id_station);


--
-- TOC entry 4938 (class 2606 OID 16489)
-- Name: city uq_city_name_region; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.city
    ADD CONSTRAINT uq_city_name_region UNIQUE (city_name, region_code);


--
-- TOC entry 4942 (class 2606 OID 16508)
-- Name: company uq_company_email; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.company
    ADD CONSTRAINT uq_company_email UNIQUE (company_email);


--
-- TOC entry 4954 (class 2606 OID 16579)
-- Name: company_fuel uq_company_fuel_company_type; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.company_fuel
    ADD CONSTRAINT uq_company_fuel_company_type UNIQUE (id_company, id_fuel_type);


--
-- TOC entry 4964 (class 2606 OID 16643)
-- Name: discount uq_discount_business; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.discount
    ADD CONSTRAINT uq_discount_business UNIQUE (id_card, start_date);


--
-- TOC entry 4960 (class 2606 OID 16622)
-- Name: price_history uq_price_history_business; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.price_history
    ADD CONSTRAINT uq_price_history_business UNIQUE (id_company_fuel, start_date);


--
-- TOC entry 4950 (class 2606 OID 16556)
-- Name: station uq_station_company_address; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.station
    ADD CONSTRAINT uq_station_company_address UNIQUE (id_company, station_address);


--
-- TOC entry 4971 (class 2606 OID 16604)
-- Name: card_account fk_card_account_customer; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.card_account
    ADD CONSTRAINT fk_card_account_customer FOREIGN KEY (id_customer) REFERENCES azs.customer(id_customer) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4969 (class 2606 OID 16580)
-- Name: company_fuel fk_company_fuel_company; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.company_fuel
    ADD CONSTRAINT fk_company_fuel_company FOREIGN KEY (id_company) REFERENCES azs.company(id_company) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4970 (class 2606 OID 16585)
-- Name: company_fuel fk_company_fuel_fuel_type; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.company_fuel
    ADD CONSTRAINT fk_company_fuel_fuel_type FOREIGN KEY (id_fuel_type) REFERENCES azs.fuel_type(id_fuel_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4973 (class 2606 OID 16644)
-- Name: discount fk_discount_card; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.discount
    ADD CONSTRAINT fk_discount_card FOREIGN KEY (id_card) REFERENCES azs.card_account(id_card) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4972 (class 2606 OID 16623)
-- Name: price_history fk_price_history_company_fuel; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.price_history
    ADD CONSTRAINT fk_price_history_company_fuel FOREIGN KEY (id_company_fuel) REFERENCES azs.company_fuel(id_company_fuel) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4974 (class 2606 OID 16667)
-- Name: sale fk_sale_card; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.sale
    ADD CONSTRAINT fk_sale_card FOREIGN KEY (id_card) REFERENCES azs.card_account(id_card) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4975 (class 2606 OID 16677)
-- Name: sale fk_sale_company_fuel; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.sale
    ADD CONSTRAINT fk_sale_company_fuel FOREIGN KEY (id_company_fuel) REFERENCES azs.company_fuel(id_company_fuel) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4976 (class 2606 OID 16672)
-- Name: sale fk_sale_station; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.sale
    ADD CONSTRAINT fk_sale_station FOREIGN KEY (id_station) REFERENCES azs.station(id_station) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4967 (class 2606 OID 16562)
-- Name: station fk_station_city; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.station
    ADD CONSTRAINT fk_station_city FOREIGN KEY (id_city) REFERENCES azs.city(id_city) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4968 (class 2606 OID 16557)
-- Name: station fk_station_company; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.station
    ADD CONSTRAINT fk_station_company FOREIGN KEY (id_company) REFERENCES azs.company(id_company) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2026-04-10 03:23:06

--
-- PostgreSQL database dump complete
--

\unrestrict gelD0cPkLHhOmTKTbhlHbMeVn3nENEs2Ms2OUgzd3WnpzyaUUdEwdJEvIHilQYN

