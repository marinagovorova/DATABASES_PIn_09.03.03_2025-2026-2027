--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

-- Started on 2026-05-09 20:18:14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 73729)
-- Name: provider_schema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA provider_schema;


ALTER SCHEMA provider_schema OWNER TO postgres;

--
-- TOC entry 857 (class 1247 OID 73731)
-- Name: payment_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status_enum AS ENUM (
    'Оплачен',
    'Просрочен',
    'Ожидает'
);


ALTER TYPE public.payment_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 73800)
-- Name: calls; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.calls (
    call_id bigint NOT NULL,
    subscriber_id integer NOT NULL,
    dialed_number character varying(20) NOT NULL,
    call_date date NOT NULL,
    call_time time without time zone NOT NULL,
    duration_minutes numeric(8,2) NOT NULL,
    zone_code character varying(10) NOT NULL,
    tariff_id_at_call integer NOT NULL,
    cost numeric(8,2) NOT NULL,
    CONSTRAINT calls_cost_check CHECK ((cost >= (0)::numeric)),
    CONSTRAINT calls_duration_minutes_check CHECK ((duration_minutes >= (0)::numeric))
);


ALTER TABLE provider_schema.calls OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 73799)
-- Name: calls_call_id_seq; Type: SEQUENCE; Schema: provider_schema; Owner: postgres
--

CREATE SEQUENCE provider_schema.calls_call_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE provider_schema.calls_call_id_seq OWNER TO postgres;

--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 223
-- Name: calls_call_id_seq; Type: SEQUENCE OWNED BY; Schema: provider_schema; Owner: postgres
--

ALTER SEQUENCE provider_schema.calls_call_id_seq OWNED BY provider_schema.calls.call_id;


--
-- TOC entry 228 (class 1259 OID 73839)
-- Name: extra_services; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.extra_services (
    service_id integer NOT NULL,
    service_name character varying(100) NOT NULL,
    monthly_cost numeric(6,2) NOT NULL,
    is_active boolean DEFAULT true,
    CONSTRAINT extra_services_monthly_cost_check CHECK ((monthly_cost >= (0)::numeric))
);


ALTER TABLE provider_schema.extra_services OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 73838)
-- Name: extra_services_service_id_seq; Type: SEQUENCE; Schema: provider_schema; Owner: postgres
--

CREATE SEQUENCE provider_schema.extra_services_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE provider_schema.extra_services_service_id_seq OWNER TO postgres;

--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 227
-- Name: extra_services_service_id_seq; Type: SEQUENCE OWNED BY; Schema: provider_schema; Owner: postgres
--

ALTER SEQUENCE provider_schema.extra_services_service_id_seq OWNED BY provider_schema.extra_services.service_id;


--
-- TOC entry 226 (class 1259 OID 73825)
-- Name: payments; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.payments (
    payment_id integer NOT NULL,
    subscriber_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_date date NOT NULL,
    due_date date NOT NULL,
    payment_status public.payment_status_enum NOT NULL,
    CONSTRAINT payments_amount_check CHECK ((amount > (0)::numeric))
);


ALTER TABLE provider_schema.payments OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 73824)
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: provider_schema; Owner: postgres
--

CREATE SEQUENCE provider_schema.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE provider_schema.payments_payment_id_seq OWNER TO postgres;

--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 225
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: provider_schema; Owner: postgres
--

ALTER SEQUENCE provider_schema.payments_payment_id_seq OWNED BY provider_schema.payments.payment_id;


--
-- TOC entry 232 (class 1259 OID 73875)
-- Name: subscriber_resources; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.subscriber_resources (
    subscriber_id integer NOT NULL,
    resource_id integer NOT NULL,
    subscription_date date NOT NULL,
    cancellation_date date
);


ALTER TABLE provider_schema.subscriber_resources OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 73860)
-- Name: subscriber_services; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.subscriber_services (
    subscriber_id integer NOT NULL,
    service_id integer NOT NULL,
    activation_date date NOT NULL,
    deactivation_date date
);


ALTER TABLE provider_schema.subscriber_services OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 73783)
-- Name: subscriber_tariffs; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.subscriber_tariffs (
    subscriber_id integer NOT NULL,
    tariff_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE provider_schema.subscriber_tariffs OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 73738)
-- Name: subscribers; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.subscribers (
    subscriber_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    phone_number character varying(20) NOT NULL,
    address character varying(200) NOT NULL,
    city character varying(50) NOT NULL,
    country character varying(50) NOT NULL,
    registration_date date NOT NULL,
    current_balance numeric(10,2) DEFAULT 0.00,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE provider_schema.subscribers OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 73737)
-- Name: subscribers_subscriber_id_seq; Type: SEQUENCE; Schema: provider_schema; Owner: postgres
--

CREATE SEQUENCE provider_schema.subscribers_subscriber_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE provider_schema.subscribers_subscriber_id_seq OWNER TO postgres;

--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 216
-- Name: subscribers_subscriber_id_seq; Type: SEQUENCE OWNED BY; Schema: provider_schema; Owner: postgres
--

ALTER SEQUENCE provider_schema.subscribers_subscriber_id_seq OWNED BY provider_schema.subscribers.subscriber_id;


--
-- TOC entry 219 (class 1259 OID 73749)
-- Name: tariff_plans; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.tariff_plans (
    tariff_id integer NOT NULL,
    tariff_name character varying(50) NOT NULL,
    monthly_cost numeric(8,2) NOT NULL,
    included_minutes integer DEFAULT 0,
    included_gb numeric(6,2) DEFAULT 0,
    included_sms integer DEFAULT 0,
    is_active boolean DEFAULT true,
    CONSTRAINT tariff_plans_monthly_cost_check CHECK ((monthly_cost >= (0)::numeric))
);


ALTER TABLE provider_schema.tariff_plans OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 73748)
-- Name: tariff_plans_tariff_id_seq; Type: SEQUENCE; Schema: provider_schema; Owner: postgres
--

CREATE SEQUENCE provider_schema.tariff_plans_tariff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE provider_schema.tariff_plans_tariff_id_seq OWNER TO postgres;

--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 218
-- Name: tariff_plans_tariff_id_seq; Type: SEQUENCE OWNED BY; Schema: provider_schema; Owner: postgres
--

ALTER SEQUENCE provider_schema.tariff_plans_tariff_id_seq OWNED BY provider_schema.tariff_plans.tariff_id;


--
-- TOC entry 221 (class 1259 OID 73767)
-- Name: tariff_zone_prices; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.tariff_zone_prices (
    tariff_id integer NOT NULL,
    zone_code character varying(10) NOT NULL,
    price_per_minute numeric(6,4) NOT NULL,
    CONSTRAINT tariff_zone_prices_price_per_minute_check CHECK ((price_per_minute >= (0)::numeric))
);


ALTER TABLE provider_schema.tariff_zone_prices OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 73762)
-- Name: tariff_zones; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.tariff_zones (
    zone_code character varying(10) NOT NULL,
    zone_name character varying(50) NOT NULL,
    country character varying(50) NOT NULL
);


ALTER TABLE provider_schema.tariff_zones OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 73850)
-- Name: third_party_services; Type: TABLE; Schema: provider_schema; Owner: postgres
--

CREATE TABLE provider_schema.third_party_services (
    resource_id integer NOT NULL,
    resource_name character varying(100) NOT NULL,
    monthly_cost numeric(6,2) NOT NULL,
    is_active boolean DEFAULT true,
    CONSTRAINT third_party_services_monthly_cost_check CHECK ((monthly_cost >= (0)::numeric))
);


ALTER TABLE provider_schema.third_party_services OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 73849)
-- Name: third_party_services_resource_id_seq; Type: SEQUENCE; Schema: provider_schema; Owner: postgres
--

CREATE SEQUENCE provider_schema.third_party_services_resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE provider_schema.third_party_services_resource_id_seq OWNER TO postgres;

--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 229
-- Name: third_party_services_resource_id_seq; Type: SEQUENCE OWNED BY; Schema: provider_schema; Owner: postgres
--

ALTER SEQUENCE provider_schema.third_party_services_resource_id_seq OWNED BY provider_schema.third_party_services.resource_id;


--
-- TOC entry 4746 (class 2604 OID 73803)
-- Name: calls call_id; Type: DEFAULT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.calls ALTER COLUMN call_id SET DEFAULT nextval('provider_schema.calls_call_id_seq'::regclass);


--
-- TOC entry 4748 (class 2604 OID 73842)
-- Name: extra_services service_id; Type: DEFAULT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.extra_services ALTER COLUMN service_id SET DEFAULT nextval('provider_schema.extra_services_service_id_seq'::regclass);


--
-- TOC entry 4747 (class 2604 OID 73828)
-- Name: payments payment_id; Type: DEFAULT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.payments ALTER COLUMN payment_id SET DEFAULT nextval('provider_schema.payments_payment_id_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 73741)
-- Name: subscribers subscriber_id; Type: DEFAULT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscribers ALTER COLUMN subscriber_id SET DEFAULT nextval('provider_schema.subscribers_subscriber_id_seq'::regclass);


--
-- TOC entry 4740 (class 2604 OID 73752)
-- Name: tariff_plans tariff_id; Type: DEFAULT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.tariff_plans ALTER COLUMN tariff_id SET DEFAULT nextval('provider_schema.tariff_plans_tariff_id_seq'::regclass);


--
-- TOC entry 4750 (class 2604 OID 73853)
-- Name: third_party_services resource_id; Type: DEFAULT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.third_party_services ALTER COLUMN resource_id SET DEFAULT nextval('provider_schema.third_party_services_resource_id_seq'::regclass);


--
-- TOC entry 4954 (class 0 OID 73800)
-- Dependencies: 224
-- Data for Name: calls; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--

INSERT INTO provider_schema.calls VALUES (1, 1, '+79001112233', '2025-03-01', '12:00:00', 10.50, 'RU-SPB', 3, 0.00);
INSERT INTO provider_schema.calls VALUES (2, 2, '+375291112233', '2025-03-02', '15:30:00', 5.00, 'INT-BY', 1, 75.00);


--
-- TOC entry 4958 (class 0 OID 73839)
-- Dependencies: 228
-- Data for Name: extra_services; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--

INSERT INTO provider_schema.extra_services VALUES (1, 'Антиопределитель', 50.00, true);
INSERT INTO provider_schema.extra_services VALUES (2, 'Вторая линия', 20.00, true);


--
-- TOC entry 4956 (class 0 OID 73825)
-- Dependencies: 226
-- Data for Name: payments; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--

INSERT INTO provider_schema.payments VALUES (1, 1, 1200.00, '2025-01-10', '2025-01-10', 'Оплачен');
INSERT INTO provider_schema.payments VALUES (2, 2, 350.00, '2025-02-15', '2025-02-15', 'Оплачен');


--
-- TOC entry 4962 (class 0 OID 73875)
-- Dependencies: 232
-- Data for Name: subscriber_resources; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--



--
-- TOC entry 4961 (class 0 OID 73860)
-- Dependencies: 231
-- Data for Name: subscriber_services; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--

INSERT INTO provider_schema.subscriber_services VALUES (1, 1, '2025-01-12', NULL);


--
-- TOC entry 4952 (class 0 OID 73783)
-- Dependencies: 222
-- Data for Name: subscriber_tariffs; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--

INSERT INTO provider_schema.subscriber_tariffs VALUES (1, 3, '2025-01-10', NULL, '2026-05-09 19:26:14.287895');
INSERT INTO provider_schema.subscriber_tariffs VALUES (2, 1, '2025-02-15', NULL, '2026-05-09 19:26:14.287895');


--
-- TOC entry 4947 (class 0 OID 73738)
-- Dependencies: 217
-- Data for Name: subscribers; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--

INSERT INTO provider_schema.subscribers VALUES (1, 'Голинский Данила Владимирович', '+79111234567', 'Кронверкский пр., 49', 'Санкт-Петербург', 'Россия', '2025-01-10', 450.00, '2026-05-09 19:26:14.287895');
INSERT INTO provider_schema.subscribers VALUES (2, 'Иванов Иван Иванович', '+79217654321', 'ул. Ленина, 10', 'Москва', 'Россия', '2025-02-15', 120.00, '2026-05-09 19:26:14.287895');


--
-- TOC entry 4949 (class 0 OID 73749)
-- Dependencies: 219
-- Data for Name: tariff_plans; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--

INSERT INTO provider_schema.tariff_plans VALUES (1, 'Старт', 350.00, 200, 5.00, 50, true);
INSERT INTO provider_schema.tariff_plans VALUES (2, 'Мегабайт+', 600.00, 500, 30.00, 100, true);
INSERT INTO provider_schema.tariff_plans VALUES (3, 'Безлимит 2026', 1200.00, 1000, 100.00, 1000, true);


--
-- TOC entry 4951 (class 0 OID 73767)
-- Dependencies: 221
-- Data for Name: tariff_zone_prices; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--



--
-- TOC entry 4950 (class 0 OID 73762)
-- Dependencies: 220
-- Data for Name: tariff_zones; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--

INSERT INTO provider_schema.tariff_zones VALUES ('RU-MOS', 'Москва', 'Россия');
INSERT INTO provider_schema.tariff_zones VALUES ('RU-SPB', 'Санкт-Петербург', 'Россия');
INSERT INTO provider_schema.tariff_zones VALUES ('INT-BY', 'Беларусь', 'Беларусь');


--
-- TOC entry 4960 (class 0 OID 73850)
-- Dependencies: 230
-- Data for Name: third_party_services; Type: TABLE DATA; Schema: provider_schema; Owner: postgres
--

INSERT INTO provider_schema.third_party_services VALUES (1, 'Музыка', 150.00, true);
INSERT INTO provider_schema.third_party_services VALUES (2, 'Онлайн-кинотеатр', 300.00, true);


--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 223
-- Name: calls_call_id_seq; Type: SEQUENCE SET; Schema: provider_schema; Owner: postgres
--

SELECT pg_catalog.setval('provider_schema.calls_call_id_seq', 2, true);


--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 227
-- Name: extra_services_service_id_seq; Type: SEQUENCE SET; Schema: provider_schema; Owner: postgres
--

SELECT pg_catalog.setval('provider_schema.extra_services_service_id_seq', 2, true);


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 225
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: provider_schema; Owner: postgres
--

SELECT pg_catalog.setval('provider_schema.payments_payment_id_seq', 2, true);


--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 216
-- Name: subscribers_subscriber_id_seq; Type: SEQUENCE SET; Schema: provider_schema; Owner: postgres
--

SELECT pg_catalog.setval('provider_schema.subscribers_subscriber_id_seq', 2, true);


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 218
-- Name: tariff_plans_tariff_id_seq; Type: SEQUENCE SET; Schema: provider_schema; Owner: postgres
--

SELECT pg_catalog.setval('provider_schema.tariff_plans_tariff_id_seq', 3, true);


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 229
-- Name: third_party_services_resource_id_seq; Type: SEQUENCE SET; Schema: provider_schema; Owner: postgres
--

SELECT pg_catalog.setval('provider_schema.third_party_services_resource_id_seq', 2, true);


--
-- TOC entry 4774 (class 2606 OID 73807)
-- Name: calls calls_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.calls
    ADD CONSTRAINT calls_pkey PRIMARY KEY (call_id);


--
-- TOC entry 4780 (class 2606 OID 73846)
-- Name: extra_services extra_services_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.extra_services
    ADD CONSTRAINT extra_services_pkey PRIMARY KEY (service_id);


--
-- TOC entry 4782 (class 2606 OID 73848)
-- Name: extra_services extra_services_service_name_key; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.extra_services
    ADD CONSTRAINT extra_services_service_name_key UNIQUE (service_name);


--
-- TOC entry 4778 (class 2606 OID 73831)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 4790 (class 2606 OID 73879)
-- Name: subscriber_resources subscriber_resources_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscriber_resources
    ADD CONSTRAINT subscriber_resources_pkey PRIMARY KEY (subscriber_id, resource_id, subscription_date);


--
-- TOC entry 4788 (class 2606 OID 73864)
-- Name: subscriber_services subscriber_services_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscriber_services
    ADD CONSTRAINT subscriber_services_pkey PRIMARY KEY (subscriber_id, service_id, activation_date);


--
-- TOC entry 4772 (class 2606 OID 73788)
-- Name: subscriber_tariffs subscriber_tariffs_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscriber_tariffs
    ADD CONSTRAINT subscriber_tariffs_pkey PRIMARY KEY (subscriber_id, tariff_id, start_date);


--
-- TOC entry 4760 (class 2606 OID 73747)
-- Name: subscribers subscribers_phone_number_key; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscribers
    ADD CONSTRAINT subscribers_phone_number_key UNIQUE (phone_number);


--
-- TOC entry 4762 (class 2606 OID 73745)
-- Name: subscribers subscribers_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscribers
    ADD CONSTRAINT subscribers_pkey PRIMARY KEY (subscriber_id);


--
-- TOC entry 4764 (class 2606 OID 73759)
-- Name: tariff_plans tariff_plans_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.tariff_plans
    ADD CONSTRAINT tariff_plans_pkey PRIMARY KEY (tariff_id);


--
-- TOC entry 4766 (class 2606 OID 73761)
-- Name: tariff_plans tariff_plans_tariff_name_key; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.tariff_plans
    ADD CONSTRAINT tariff_plans_tariff_name_key UNIQUE (tariff_name);


--
-- TOC entry 4770 (class 2606 OID 73772)
-- Name: tariff_zone_prices tariff_zone_prices_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.tariff_zone_prices
    ADD CONSTRAINT tariff_zone_prices_pkey PRIMARY KEY (tariff_id, zone_code);


--
-- TOC entry 4768 (class 2606 OID 73766)
-- Name: tariff_zones tariff_zones_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.tariff_zones
    ADD CONSTRAINT tariff_zones_pkey PRIMARY KEY (zone_code);


--
-- TOC entry 4784 (class 2606 OID 73857)
-- Name: third_party_services third_party_services_pkey; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.third_party_services
    ADD CONSTRAINT third_party_services_pkey PRIMARY KEY (resource_id);


--
-- TOC entry 4786 (class 2606 OID 73859)
-- Name: third_party_services third_party_services_resource_name_key; Type: CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.third_party_services
    ADD CONSTRAINT third_party_services_resource_name_key UNIQUE (resource_name);


--
-- TOC entry 4775 (class 1259 OID 73823)
-- Name: idx_subscriber_date; Type: INDEX; Schema: provider_schema; Owner: postgres
--

CREATE INDEX idx_subscriber_date ON provider_schema.calls USING btree (subscriber_id, call_date);


--
-- TOC entry 4776 (class 1259 OID 73837)
-- Name: idx_subscriber_status; Type: INDEX; Schema: provider_schema; Owner: postgres
--

CREATE INDEX idx_subscriber_status ON provider_schema.payments USING btree (subscriber_id, payment_status);


--
-- TOC entry 4795 (class 2606 OID 73808)
-- Name: calls calls_subscriber_id_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.calls
    ADD CONSTRAINT calls_subscriber_id_fkey FOREIGN KEY (subscriber_id) REFERENCES provider_schema.subscribers(subscriber_id) ON DELETE CASCADE;


--
-- TOC entry 4796 (class 2606 OID 73818)
-- Name: calls calls_tariff_id_at_call_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.calls
    ADD CONSTRAINT calls_tariff_id_at_call_fkey FOREIGN KEY (tariff_id_at_call) REFERENCES provider_schema.tariff_plans(tariff_id);


--
-- TOC entry 4797 (class 2606 OID 73813)
-- Name: calls calls_zone_code_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.calls
    ADD CONSTRAINT calls_zone_code_fkey FOREIGN KEY (zone_code) REFERENCES provider_schema.tariff_zones(zone_code);


--
-- TOC entry 4798 (class 2606 OID 73832)
-- Name: payments payments_subscriber_id_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.payments
    ADD CONSTRAINT payments_subscriber_id_fkey FOREIGN KEY (subscriber_id) REFERENCES provider_schema.subscribers(subscriber_id) ON DELETE CASCADE;


--
-- TOC entry 4801 (class 2606 OID 73885)
-- Name: subscriber_resources subscriber_resources_resource_id_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscriber_resources
    ADD CONSTRAINT subscriber_resources_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES provider_schema.third_party_services(resource_id);


--
-- TOC entry 4802 (class 2606 OID 73880)
-- Name: subscriber_resources subscriber_resources_subscriber_id_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscriber_resources
    ADD CONSTRAINT subscriber_resources_subscriber_id_fkey FOREIGN KEY (subscriber_id) REFERENCES provider_schema.subscribers(subscriber_id) ON DELETE CASCADE;


--
-- TOC entry 4799 (class 2606 OID 73870)
-- Name: subscriber_services subscriber_services_service_id_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscriber_services
    ADD CONSTRAINT subscriber_services_service_id_fkey FOREIGN KEY (service_id) REFERENCES provider_schema.extra_services(service_id);


--
-- TOC entry 4800 (class 2606 OID 73865)
-- Name: subscriber_services subscriber_services_subscriber_id_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscriber_services
    ADD CONSTRAINT subscriber_services_subscriber_id_fkey FOREIGN KEY (subscriber_id) REFERENCES provider_schema.subscribers(subscriber_id) ON DELETE CASCADE;


--
-- TOC entry 4793 (class 2606 OID 73789)
-- Name: subscriber_tariffs subscriber_tariffs_subscriber_id_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscriber_tariffs
    ADD CONSTRAINT subscriber_tariffs_subscriber_id_fkey FOREIGN KEY (subscriber_id) REFERENCES provider_schema.subscribers(subscriber_id) ON DELETE CASCADE;


--
-- TOC entry 4794 (class 2606 OID 73794)
-- Name: subscriber_tariffs subscriber_tariffs_tariff_id_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.subscriber_tariffs
    ADD CONSTRAINT subscriber_tariffs_tariff_id_fkey FOREIGN KEY (tariff_id) REFERENCES provider_schema.tariff_plans(tariff_id);


--
-- TOC entry 4791 (class 2606 OID 73773)
-- Name: tariff_zone_prices tariff_zone_prices_tariff_id_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.tariff_zone_prices
    ADD CONSTRAINT tariff_zone_prices_tariff_id_fkey FOREIGN KEY (tariff_id) REFERENCES provider_schema.tariff_plans(tariff_id);


--
-- TOC entry 4792 (class 2606 OID 73778)
-- Name: tariff_zone_prices tariff_zone_prices_zone_code_fkey; Type: FK CONSTRAINT; Schema: provider_schema; Owner: postgres
--

ALTER TABLE ONLY provider_schema.tariff_zone_prices
    ADD CONSTRAINT tariff_zone_prices_zone_code_fkey FOREIGN KEY (zone_code) REFERENCES provider_schema.tariff_zones(zone_code);


-- Completed on 2026-05-09 20:18:14

--
-- PostgreSQL database dump complete
--

