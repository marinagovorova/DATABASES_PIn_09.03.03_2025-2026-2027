-- ===================================================================
-- ЛР 3.2. Создание БД TelecomDB
-- Вариант 17. Телефонный провайдер
-- Студент: Лукис В.В.
-- ===================================================================

--
-- PostgreSQL database dump
--

\restrict BWlZtjZs94q774SqMLtrIO0aiqQZbe1fERE4Z7lR6F5o7gDd6PbTFW9ilCY6e75

-- Dumped from database version 13.23
-- Dumped by pg_dump version 13.23

-- Started on 2026-03-30 13:54:04

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

DROP DATABASE IF EXISTS "TelecomDB";
--
-- TOC entry 3152 (class 1262 OID 16394)
-- Name: TelecomDB; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "TelecomDB" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Russian_Russia.1251';


ALTER DATABASE "TelecomDB" OWNER TO postgres;

\unrestrict BWlZtjZs94q774SqMLtrIO0aiqQZbe1fERE4Z7lR6F5o7gDd6PbTFW9ilCY6e75
\connect "TelecomDB"
\restrict BWlZtjZs94q774SqMLtrIO0aiqQZbe1fERE4Z7lR6F5o7gDd6PbTFW9ilCY6e75

--
-- ===================================================================
-- 1. СОЗДАНИЕ СХЕМЫ И ТАБЛИЦ
-- ===================================================================
--

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
-- TOC entry 4 (class 2615 OID 17136)
-- Name: telecom; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA telecom;


ALTER SCHEMA telecom OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- -------------------------------------------------------------------
-- Создание таблиц
-- -------------------------------------------------------------------
--

--
-- TOC entry 210 (class 1259 OID 17204)
-- Name: call_log; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.call_log (
    call_id integer NOT NULL,
    contract_number character varying(20) NOT NULL,
    zone_code integer NOT NULL,
    call_date date NOT NULL,
    call_time time without time zone NOT NULL,
    duration integer NOT NULL,
    CONSTRAINT chk_call_date CHECK ((call_date <= CURRENT_DATE)),
    CONSTRAINT chk_duration CHECK ((duration > 0))
);


ALTER TABLE telecom.call_log OWNER TO postgres;

--
-- TOC entry 3153 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE call_log; Type: COMMENT; Schema: telecom; Owner: postgres
--

COMMENT ON TABLE telecom.call_log IS 'Журнал звонков';


--
-- TOC entry 209 (class 1259 OID 17202)
-- Name: call_log_call_id_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.call_log_call_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.call_log_call_id_seq OWNER TO postgres;

--
-- TOC entry 3154 (class 0 OID 0)
-- Dependencies: 209
-- Name: call_log_call_id_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.call_log_call_id_seq OWNED BY telecom.call_log.call_id;


--
-- TOC entry 216 (class 1259 OID 17251)
-- Name: charge; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.charge (
    charge_id integer NOT NULL,
    contract_number character varying(20) NOT NULL,
    amount numeric(10,2) NOT NULL,
    charge_date date NOT NULL,
    charge_type character varying(50) NOT NULL,
    description text,
    resource_code integer,
    CONSTRAINT chk_ch_amount CHECK ((amount > (0)::numeric)),
    CONSTRAINT chk_ch_type CHECK (((charge_type)::text = ANY ((ARRAY['звонок'::character varying, 'услуга'::character varying, 'ресурс'::character varying])::text[])))
);


ALTER TABLE telecom.charge OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 17249)
-- Name: charge_charge_id_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.charge_charge_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.charge_charge_id_seq OWNER TO postgres;

--
-- TOC entry 3155 (class 0 OID 0)
-- Dependencies: 215
-- Name: charge_charge_id_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.charge_charge_id_seq OWNED BY telecom.charge.charge_id;


--
-- TOC entry 204 (class 1259 OID 17156)
-- Name: contract; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.contract (
    contract_number character varying(20) NOT NULL,
    phone_number character varying(12) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    status character varying(20) NOT NULL,
    tariff_code integer NOT NULL,
    terms text,
    CONSTRAINT chk_cont_status CHECK (((status)::text = ANY ((ARRAY['активный'::character varying, 'приостановлен'::character varying, 'расторгнут'::character varying])::text[]))),
    CONSTRAINT chk_dates CHECK ((start_date <= COALESCE(end_date, CURRENT_DATE)))
);


ALTER TABLE telecom.contract OWNER TO postgres;

--
-- TOC entry 3156 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE contract; Type: COMMENT; Schema: telecom; Owner: postgres
--

COMMENT ON TABLE telecom.contract IS 'Договоры обслуживания';


--
-- TOC entry 218 (class 1259 OID 17274)
-- Name: extra_service; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.extra_service (
    service_code integer NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    period character varying(20) NOT NULL
);


ALTER TABLE telecom.extra_service OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 17272)
-- Name: extra_service_service_code_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.extra_service_service_code_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.extra_service_service_code_seq OWNER TO postgres;

--
-- TOC entry 3157 (class 0 OID 0)
-- Dependencies: 217
-- Name: extra_service_service_code_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.extra_service_service_code_seq OWNED BY telecom.extra_service.service_code;


--
-- TOC entry 206 (class 1259 OID 17178)
-- Name: passport_data; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.passport_data (
    passport_id integer NOT NULL,
    phone_number character varying(12) NOT NULL,
    series character varying(4) NOT NULL,
    number character varying(6) NOT NULL,
    issue_date date NOT NULL,
    issued_by character varying(100) NOT NULL,
    reg_place character varying(255) NOT NULL,
    CONSTRAINT chk_pass_number CHECK (((number)::text ~ '^[0-9]{6}$'::text)),
    CONSTRAINT chk_pass_series CHECK (((series)::text ~ '^[0-9]{4}$'::text))
);


ALTER TABLE telecom.passport_data OWNER TO postgres;

--
-- TOC entry 3158 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE passport_data; Type: COMMENT; Schema: telecom; Owner: postgres
--

COMMENT ON TABLE telecom.passport_data IS 'Паспортные данные абонентов';


--
-- TOC entry 205 (class 1259 OID 17176)
-- Name: passport_data_passport_id_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.passport_data_passport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.passport_data_passport_id_seq OWNER TO postgres;

--
-- TOC entry 3159 (class 0 OID 0)
-- Dependencies: 205
-- Name: passport_data_passport_id_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.passport_data_passport_id_seq OWNED BY telecom.passport_data.passport_id;


--
-- TOC entry 212 (class 1259 OID 17224)
-- Name: payment; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.payment (
    payment_id integer NOT NULL,
    contract_number character varying(20) NOT NULL,
    amount numeric(10,2) NOT NULL,
    pay_date date NOT NULL,
    method character varying(50) NOT NULL,
    CONSTRAINT chk_amount CHECK ((amount > (0)::numeric)),
    CONSTRAINT chk_method CHECK (((method)::text = ANY ((ARRAY['наличные'::character varying, 'карта'::character varying, 'онлайн'::character varying])::text[])))
);


ALTER TABLE telecom.payment OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 17222)
-- Name: payment_payment_id_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.payment_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.payment_payment_id_seq OWNER TO postgres;

--
-- TOC entry 3160 (class 0 OID 0)
-- Dependencies: 211
-- Name: payment_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.payment_payment_id_seq OWNED BY telecom.payment.payment_id;


--
-- TOC entry 220 (class 1259 OID 17285)
-- Name: service_connection; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.service_connection (
    conn_id integer NOT NULL,
    contract_number character varying(20) NOT NULL,
    service_code integer NOT NULL,
    conn_date date NOT NULL,
    status character varying(20) NOT NULL,
    CONSTRAINT chk_conn_status CHECK (((status)::text = ANY ((ARRAY['активно'::character varying, 'приостановлено'::character varying, 'отключено'::character varying])::text[])))
);


ALTER TABLE telecom.service_connection OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17283)
-- Name: service_connection_conn_id_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.service_connection_conn_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.service_connection_conn_id_seq OWNER TO postgres;

--
-- TOC entry 3161 (class 0 OID 0)
-- Dependencies: 219
-- Name: service_connection_conn_id_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.service_connection_conn_id_seq OWNED BY telecom.service_connection.conn_id;


--
-- TOC entry 224 (class 1259 OID 17318)
-- Name: service_history; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.service_history (
    hist_id integer NOT NULL,
    service_code integer NOT NULL,
    cost numeric(8,2) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    CONSTRAINT chk_serv_cost CHECK ((cost >= (0)::numeric))
);


ALTER TABLE telecom.service_history OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17316)
-- Name: service_history_hist_id_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.service_history_hist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.service_history_hist_id_seq OWNER TO postgres;

--
-- TOC entry 3162 (class 0 OID 0)
-- Dependencies: 223
-- Name: service_history_hist_id_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.service_history_hist_id_seq OWNED BY telecom.service_history.hist_id;


--
-- TOC entry 201 (class 1259 OID 17137)
-- Name: subscriber; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.subscriber (
    phone_number character varying(12) NOT NULL,
    full_name character varying(100) NOT NULL,
    address character varying(255) NOT NULL,
    city character varying(50) NOT NULL,
    reg_date date NOT NULL,
    status character varying(20) NOT NULL,
    CONSTRAINT chk_reg_date CHECK ((reg_date <= CURRENT_DATE)),
    CONSTRAINT chk_sub_status CHECK (((status)::text = ANY ((ARRAY['активный'::character varying, 'приостановлен'::character varying, 'заблокирован'::character varying])::text[])))
);


ALTER TABLE telecom.subscriber OWNER TO postgres;

--
-- TOC entry 3163 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE subscriber; Type: COMMENT; Schema: telecom; Owner: postgres
--

COMMENT ON TABLE telecom.subscriber IS 'Справочник абонентов';


--
-- TOC entry 203 (class 1259 OID 17146)
-- Name: tariff; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.tariff (
    tariff_code integer NOT NULL,
    name character varying(50) NOT NULL,
    validity_period character varying(20) NOT NULL,
    minutes integer NOT NULL,
    gigabytes numeric(5,2) NOT NULL,
    sms integer NOT NULL,
    description text,
    CONSTRAINT chk_tariff_vals CHECK (((minutes >= 0) AND (gigabytes >= (0)::numeric) AND (sms >= 0)))
);


ALTER TABLE telecom.tariff OWNER TO postgres;

--
-- TOC entry 3164 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE tariff; Type: COMMENT; Schema: telecom; Owner: postgres
--

COMMENT ON TABLE telecom.tariff IS 'Справочник тарифных планов';


--
-- TOC entry 222 (class 1259 OID 17304)
-- Name: tariff_history; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.tariff_history (
    hist_id integer NOT NULL,
    tariff_code integer NOT NULL,
    cost numeric(8,2) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    CONSTRAINT chk_cost CHECK ((cost > (0)::numeric))
);


ALTER TABLE telecom.tariff_history OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17302)
-- Name: tariff_history_hist_id_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.tariff_history_hist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.tariff_history_hist_id_seq OWNER TO postgres;

--
-- TOC entry 3165 (class 0 OID 0)
-- Dependencies: 221
-- Name: tariff_history_hist_id_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.tariff_history_hist_id_seq OWNED BY telecom.tariff_history.hist_id;


--
-- TOC entry 202 (class 1259 OID 17144)
-- Name: tariff_tariff_code_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.tariff_tariff_code_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.tariff_tariff_code_seq OWNER TO postgres;

--
-- TOC entry 3166 (class 0 OID 0)
-- Dependencies: 202
-- Name: tariff_tariff_code_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.tariff_tariff_code_seq OWNED BY telecom.tariff.tariff_code;


--
-- TOC entry 214 (class 1259 OID 17239)
-- Name: third_party_resources; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.third_party_resources (
    resource_code integer NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    cost numeric(8,2) NOT NULL,
    CONSTRAINT chk_res_cost CHECK ((cost >= (0)::numeric))
);


ALTER TABLE telecom.third_party_resources OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 17237)
-- Name: third_party_resources_resource_code_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.third_party_resources_resource_code_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.third_party_resources_resource_code_seq OWNER TO postgres;

--
-- TOC entry 3167 (class 0 OID 0)
-- Dependencies: 213
-- Name: third_party_resources_resource_code_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.third_party_resources_resource_code_seq OWNED BY telecom.third_party_resources.resource_code;


--
-- TOC entry 208 (class 1259 OID 17195)
-- Name: zone; Type: TABLE; Schema: telecom; Owner: postgres
--

CREATE TABLE telecom.zone (
    zone_code integer NOT NULL,
    zone_name character varying(50) NOT NULL,
    country character varying(50) NOT NULL,
    price_per_min numeric(6,2) NOT NULL,
    CONSTRAINT chk_price CHECK ((price_per_min > (0)::numeric))
);


ALTER TABLE telecom.zone OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 17193)
-- Name: zone_zone_code_seq; Type: SEQUENCE; Schema: telecom; Owner: postgres
--

CREATE SEQUENCE telecom.zone_zone_code_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE telecom.zone_zone_code_seq OWNER TO postgres;

--
-- TOC entry 3168 (class 0 OID 0)
-- Dependencies: 207
-- Name: zone_zone_code_seq; Type: SEQUENCE OWNED BY; Schema: telecom; Owner: postgres
--

ALTER SEQUENCE telecom.zone_zone_code_seq OWNED BY telecom.zone.zone_code;


--
-- TOC entry 2935 (class 2604 OID 17207)
-- Name: call_log call_id; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.call_log ALTER COLUMN call_id SET DEFAULT nextval('telecom.call_log_call_id_seq'::regclass);


--
-- TOC entry 2943 (class 2604 OID 17254)
-- Name: charge charge_id; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.charge ALTER COLUMN charge_id SET DEFAULT nextval('telecom.charge_charge_id_seq'::regclass);


--
-- TOC entry 2946 (class 2604 OID 17277)
-- Name: extra_service service_code; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.extra_service ALTER COLUMN service_code SET DEFAULT nextval('telecom.extra_service_service_code_seq'::regclass);


--
-- TOC entry 2930 (class 2604 OID 17181)
-- Name: passport_data passport_id; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.passport_data ALTER COLUMN passport_id SET DEFAULT nextval('telecom.passport_data_passport_id_seq'::regclass);


--
-- TOC entry 2938 (class 2604 OID 17227)
-- Name: payment payment_id; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.payment ALTER COLUMN payment_id SET DEFAULT nextval('telecom.payment_payment_id_seq'::regclass);


--
-- TOC entry 2947 (class 2604 OID 17288)
-- Name: service_connection conn_id; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.service_connection ALTER COLUMN conn_id SET DEFAULT nextval('telecom.service_connection_conn_id_seq'::regclass);


--
-- TOC entry 2951 (class 2604 OID 17321)
-- Name: service_history hist_id; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.service_history ALTER COLUMN hist_id SET DEFAULT nextval('telecom.service_history_hist_id_seq'::regclass);


--
-- TOC entry 2926 (class 2604 OID 17149)
-- Name: tariff tariff_code; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.tariff ALTER COLUMN tariff_code SET DEFAULT nextval('telecom.tariff_tariff_code_seq'::regclass);


--
-- TOC entry 2949 (class 2604 OID 17307)
-- Name: tariff_history hist_id; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.tariff_history ALTER COLUMN hist_id SET DEFAULT nextval('telecom.tariff_history_hist_id_seq'::regclass);


--
-- TOC entry 2941 (class 2604 OID 17242)
-- Name: third_party_resources resource_code; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.third_party_resources ALTER COLUMN resource_code SET DEFAULT nextval('telecom.third_party_resources_resource_code_seq'::regclass);


--
-- TOC entry 2933 (class 2604 OID 17198)
-- Name: zone zone_code; Type: DEFAULT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.zone ALTER COLUMN zone_code SET DEFAULT nextval('telecom.zone_zone_code_seq'::regclass);

--
-- ===================================================================
-- 2. ЗАПОЛНЕНИЕ ТАБЛИЦ ДАННЫМИ
-- ===================================================================
--

--
-- TOC entry 3132 (class 0 OID 17204)
-- Dependencies: 210
-- Data for Name: call_log; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.call_log VALUES (1, 'ДОГ-000001', 1, '2024-01-10', '14:30:00', 120) ON CONFLICT DO NOTHING;
INSERT INTO telecom.call_log VALUES (2, 'ДОГ-000001', 2, '2024-01-11', '09:15:00', 300) ON CONFLICT DO NOTHING;
INSERT INTO telecom.call_log VALUES (3, 'ДОГ-000002', 1, '2024-01-12', '18:45:00', 60) ON CONFLICT DO NOTHING;
INSERT INTO telecom.call_log VALUES (4, 'ДОГ-000002', 3, '2024-01-13', '20:00:00', 450) ON CONFLICT DO NOTHING;
INSERT INTO telecom.call_log VALUES (5, 'ДОГ-000003', 4, '2024-01-14', '11:00:00', 180) ON CONFLICT DO NOTHING;


--
-- TOC entry 3138 (class 0 OID 17251)
-- Dependencies: 216
-- Data for Name: charge; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.charge VALUES (1, 'ДОГ-000001', 300.00, '2024-01-01', 'услуга', 'Абонентская плата за тариф', NULL) ON CONFLICT DO NOTHING;
INSERT INTO telecom.charge VALUES (2, 'ДОГ-000001', 180.00, '2024-01-11', 'звонок', 'Звонки сверх пакета', NULL) ON CONFLICT DO NOTHING;
INSERT INTO telecom.charge VALUES (3, 'ДОГ-000002', 600.00, '2024-01-01', 'услуга', 'Абонентская плата за тариф', NULL) ON CONFLICT DO NOTHING;
INSERT INTO telecom.charge VALUES (4, 'ДОГ-000002', 6750.00, '2024-01-13', 'звонок', 'Международный звонок в Европу', NULL) ON CONFLICT DO NOTHING;
INSERT INTO telecom.charge VALUES (5, 'ДОГ-000003', 1200.00, '2024-01-01', 'услуга', 'Абонентская плата за тариф', NULL) ON CONFLICT DO NOTHING;
INSERT INTO telecom.charge VALUES (6, 'ДОГ-000003', 4500.00, '2024-01-14', 'звонок', 'Международный звонок в США', NULL) ON CONFLICT DO NOTHING;
INSERT INTO telecom.charge VALUES (7, 'ДОГ-000001', 50.00, '2024-01-15', 'ресурс', 'Голосовая почта', 1) ON CONFLICT DO NOTHING;
INSERT INTO telecom.charge VALUES (8, 'ДОГ-000002', 30.00, '2024-01-15', 'ресурс', 'Определитель номера', 2) ON CONFLICT DO NOTHING;


--
-- TOC entry 3126 (class 0 OID 17156)
-- Dependencies: 204
-- Data for Name: contract; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.contract VALUES ('ДОГ-000001', '+79001112233', '2023-01-15', NULL, 'активный', 1, 'Стандартные условия обслуживания') ON CONFLICT DO NOTHING;
INSERT INTO telecom.contract VALUES ('ДОГ-000002', '+79004445566', '2023-02-20', '2024-02-20', 'активный', 2, 'Расширенные условия обслуживания') ON CONFLICT DO NOTHING;
INSERT INTO telecom.contract VALUES ('ДОГ-000003', '+79007778899', '2023-03-10', NULL, 'активный', 3, 'Премиум обслуживание 24/7') ON CONFLICT DO NOTHING;


--
-- TOC entry 3140 (class 0 OID 17274)
-- Dependencies: 218
-- Data for Name: extra_service; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.extra_service VALUES (1, 'Антиопределитель', 'Скрытие номера при исходящих вызовах', 'месяц') ON CONFLICT DO NOTHING;
INSERT INTO telecom.extra_service VALUES (2, 'Безлимитные соцсети', 'Трафик в соцсетях не тарифицируется', 'месяц') ON CONFLICT DO NOTHING;
INSERT INTO telecom.extra_service VALUES (3, 'Роуминг-пакет', 'Сниженные тарифы в роуминге', 'квартал') ON CONFLICT DO NOTHING;


--
-- TOC entry 3128 (class 0 OID 17178)
-- Dependencies: 206
-- Data for Name: passport_data; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.passport_data VALUES (1, '+79001112233', '4501', '123456', '2015-05-20', 'УФМС России по г. Москва', 'г. Москва, ул. Ленина, д. 1') ON CONFLICT DO NOTHING;
INSERT INTO telecom.passport_data VALUES (2, '+79004445566', '4005', '654321', '2018-10-15', 'УФМС России по г. Санкт-Петербург', 'г. Санкт-Петербург, пр. Мира, д. 25') ON CONFLICT DO NOTHING;
INSERT INTO telecom.passport_data VALUES (3, '+79007778899', '9210', '112233', '2020-01-10', 'УФМС России по Республике Татарстан', 'г. Казань, ул. Гагарина, д. 7') ON CONFLICT DO NOTHING;


--
-- TOC entry 3134 (class 0 OID 17224)
-- Dependencies: 212
-- Data for Name: payment; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.payment VALUES (1, 'ДОГ-000001', 500.00, '2024-01-05', 'онлайн') ON CONFLICT DO NOTHING;
INSERT INTO telecom.payment VALUES (2, 'ДОГ-000001', 300.00, '2024-01-20', 'карта') ON CONFLICT DO NOTHING;
INSERT INTO telecom.payment VALUES (3, 'ДОГ-000002', 1000.00, '2024-01-10', 'онлайн') ON CONFLICT DO NOTHING;
INSERT INTO telecom.payment VALUES (4, 'ДОГ-000003', 1500.00, '2024-01-15', 'карта') ON CONFLICT DO NOTHING;


--
-- TOC entry 3142 (class 0 OID 17285)
-- Dependencies: 220
-- Data for Name: service_connection; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.service_connection VALUES (1, 'ДОГ-000001', 1, '2023-01-15', 'активно') ON CONFLICT DO NOTHING;
INSERT INTO telecom.service_connection VALUES (2, 'ДОГ-000002', 2, '2023-02-20', 'активно') ON CONFLICT DO NOTHING;
INSERT INTO telecom.service_connection VALUES (3, 'ДОГ-000003', 3, '2023-03-10', 'активно') ON CONFLICT DO NOTHING;
INSERT INTO telecom.service_connection VALUES (4, 'ДОГ-000003', 1, '2023-03-15', 'активно') ON CONFLICT DO NOTHING;


--
-- TOC entry 3146 (class 0 OID 17318)
-- Dependencies: 224
-- Data for Name: service_history; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.service_history VALUES (1, 1, 50.00, '2023-01-01', NULL) ON CONFLICT DO NOTHING;
INSERT INTO telecom.service_history VALUES (2, 2, 150.00, '2023-01-01', NULL) ON CONFLICT DO NOTHING;
INSERT INTO telecom.service_history VALUES (3, 3, 300.00, '2023-01-01', NULL) ON CONFLICT DO NOTHING;


--
-- TOC entry 3123 (class 0 OID 17137)
-- Dependencies: 201
-- Data for Name: subscriber; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.subscriber VALUES ('+79001112233', 'Иванов Иван Иванович', 'ул. Ленина, д. 1, кв. 10', 'Москва', '2023-01-15', 'активный') ON CONFLICT DO NOTHING;
INSERT INTO telecom.subscriber VALUES ('+79004445566', 'Петров Петр Петрович', 'пр. Мира, д. 25, кв. 5', 'Санкт-Петербург', '2023-02-20', 'активный') ON CONFLICT DO NOTHING;
INSERT INTO telecom.subscriber VALUES ('+79007778899', 'Сидорова Анна Сергеевна', 'ул. Гагарина, д. 7, кв. 100', 'Казань', '2023-03-10', 'активный') ON CONFLICT DO NOTHING;


--
-- TOC entry 3125 (class 0 OID 17146)
-- Dependencies: 203
-- Data for Name: tariff; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.tariff VALUES (1, 'Стартовый', 'месяц', 100, 5.00, 50, 'Базовый тариф для новых абонентов') ON CONFLICT DO NOTHING;
INSERT INTO telecom.tariff VALUES (2, 'Безлимит', 'месяц', 500, 20.00, 100, 'Тариф для активных пользователей') ON CONFLICT DO NOTHING;
INSERT INTO telecom.tariff VALUES (3, 'Премиум', 'месяц', 1000, 50.00, 500, 'Максимальный пакет услуг') ON CONFLICT DO NOTHING;


--
-- TOC entry 3144 (class 0 OID 17304)
-- Dependencies: 222
-- Data for Name: tariff_history; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.tariff_history VALUES (1, 1, 300.00, '2023-01-01', NULL) ON CONFLICT DO NOTHING;
INSERT INTO telecom.tariff_history VALUES (2, 2, 600.00, '2023-01-01', NULL) ON CONFLICT DO NOTHING;
INSERT INTO telecom.tariff_history VALUES (3, 3, 1200.00, '2023-01-01', NULL) ON CONFLICT DO NOTHING;


--
-- TOC entry 3136 (class 0 OID 17239)
-- Dependencies: 214
-- Data for Name: third_party_resources; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.third_party_resources VALUES (1, 'Голосовая почта', 'Услуга хранения голосовых сообщений', 50.00) ON CONFLICT DO NOTHING;
INSERT INTO telecom.third_party_resources VALUES (2, 'Определитель номера', 'База данных номеров спамеров', 30.00) ON CONFLICT DO NOTHING;
INSERT INTO telecom.third_party_resources VALUES (3, 'Облачное хранилище', '5 ГБ в облаке провайдера', 100.00) ON CONFLICT DO NOTHING;


--
-- TOC entry 3130 (class 0 OID 17195)
-- Dependencies: 208
-- Data for Name: zone; Type: TABLE DATA; Schema: telecom; Owner: postgres
--

INSERT INTO telecom.zone VALUES (1, 'Москва и МО', 'Россия', 1.50) ON CONFLICT DO NOTHING;
INSERT INTO telecom.zone VALUES (2, 'Санкт-Петербург', 'Россия', 1.50) ON CONFLICT DO NOTHING;
INSERT INTO telecom.zone VALUES (3, 'Европа', 'Германия', 15.00) ON CONFLICT DO NOTHING;
INSERT INTO telecom.zone VALUES (4, 'США', 'США', 25.00) ON CONFLICT DO NOTHING;

--
-- -------------------------------------------------------------------
-- Установка последовательностей
-- -------------------------------------------------------------------
--

--
-- TOC entry 3169 (class 0 OID 0)
-- Dependencies: 209
-- Name: call_log_call_id_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.call_log_call_id_seq', 5, true);


--
-- TOC entry 3170 (class 0 OID 0)
-- Dependencies: 215
-- Name: charge_charge_id_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.charge_charge_id_seq', 8, true);


--
-- TOC entry 3171 (class 0 OID 0)
-- Dependencies: 217
-- Name: extra_service_service_code_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.extra_service_service_code_seq', 3, true);


--
-- TOC entry 3172 (class 0 OID 0)
-- Dependencies: 205
-- Name: passport_data_passport_id_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.passport_data_passport_id_seq', 3, true);


--
-- TOC entry 3173 (class 0 OID 0)
-- Dependencies: 211
-- Name: payment_payment_id_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.payment_payment_id_seq', 4, true);


--
-- TOC entry 3174 (class 0 OID 0)
-- Dependencies: 219
-- Name: service_connection_conn_id_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.service_connection_conn_id_seq', 4, true);


--
-- TOC entry 3175 (class 0 OID 0)
-- Dependencies: 223
-- Name: service_history_hist_id_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.service_history_hist_id_seq', 3, true);


--
-- TOC entry 3176 (class 0 OID 0)
-- Dependencies: 221
-- Name: tariff_history_hist_id_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.tariff_history_hist_id_seq', 3, true);


--
-- TOC entry 3177 (class 0 OID 0)
-- Dependencies: 202
-- Name: tariff_tariff_code_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.tariff_tariff_code_seq', 3, true);


--
-- TOC entry 3178 (class 0 OID 0)
-- Dependencies: 213
-- Name: third_party_resources_resource_code_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.third_party_resources_resource_code_seq', 3, true);


--
-- TOC entry 3179 (class 0 OID 0)
-- Dependencies: 207
-- Name: zone_zone_code_seq; Type: SEQUENCE SET; Schema: telecom; Owner: postgres
--

SELECT pg_catalog.setval('telecom.zone_zone_code_seq', 4, true);

--
-- ===================================================================
-- 3. ОГРАНИЧЕНИЯ ЦЕЛОСТНОСТИ
-- ===================================================================
-- Первичные ключи, внешние ключи, уникальные ограничения
-- ===================================================================
--

--
-- TOC entry 2966 (class 2606 OID 17211)
-- Name: call_log call_log_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.call_log
    ADD CONSTRAINT call_log_pkey PRIMARY KEY (call_id);


--
-- TOC entry 2972 (class 2606 OID 17261)
-- Name: charge charge_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.charge
    ADD CONSTRAINT charge_pkey PRIMARY KEY (charge_id);


--
-- TOC entry 2958 (class 2606 OID 17165)
-- Name: contract contract_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (contract_number);


--
-- TOC entry 2974 (class 2606 OID 17282)
-- Name: extra_service extra_service_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.extra_service
    ADD CONSTRAINT extra_service_pkey PRIMARY KEY (service_code);


--
-- TOC entry 2960 (class 2606 OID 17187)
-- Name: passport_data passport_data_phone_number_key; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.passport_data
    ADD CONSTRAINT passport_data_phone_number_key UNIQUE (phone_number);


--
-- TOC entry 2962 (class 2606 OID 17185)
-- Name: passport_data passport_data_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.passport_data
    ADD CONSTRAINT passport_data_pkey PRIMARY KEY (passport_id);


--
-- TOC entry 2968 (class 2606 OID 17231)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 2976 (class 2606 OID 17291)
-- Name: service_connection service_connection_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.service_connection
    ADD CONSTRAINT service_connection_pkey PRIMARY KEY (conn_id);


--
-- TOC entry 2980 (class 2606 OID 17324)
-- Name: service_history service_history_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.service_history
    ADD CONSTRAINT service_history_pkey PRIMARY KEY (hist_id);


--
-- TOC entry 2954 (class 2606 OID 17143)
-- Name: subscriber subscriber_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.subscriber
    ADD CONSTRAINT subscriber_pkey PRIMARY KEY (phone_number);


--
-- TOC entry 2978 (class 2606 OID 17310)
-- Name: tariff_history tariff_history_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.tariff_history
    ADD CONSTRAINT tariff_history_pkey PRIMARY KEY (hist_id);


--
-- TOC entry 2956 (class 2606 OID 17155)
-- Name: tariff tariff_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.tariff
    ADD CONSTRAINT tariff_pkey PRIMARY KEY (tariff_code);


--
-- TOC entry 2970 (class 2606 OID 17248)
-- Name: third_party_resources third_party_resources_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.third_party_resources
    ADD CONSTRAINT third_party_resources_pkey PRIMARY KEY (resource_code);


--
-- TOC entry 2964 (class 2606 OID 17201)
-- Name: zone zone_pkey; Type: CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.zone
    ADD CONSTRAINT zone_pkey PRIMARY KEY (zone_code);


--
-- TOC entry 2984 (class 2606 OID 17212)
-- Name: call_log fk_call_cont; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.call_log
    ADD CONSTRAINT fk_call_cont FOREIGN KEY (contract_number) REFERENCES telecom.contract(contract_number);


--
-- TOC entry 2985 (class 2606 OID 17217)
-- Name: call_log fk_call_zone; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.call_log
    ADD CONSTRAINT fk_call_zone FOREIGN KEY (zone_code) REFERENCES telecom.zone(zone_code);


--
-- TOC entry 2987 (class 2606 OID 17262)
-- Name: charge fk_ch_cont; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.charge
    ADD CONSTRAINT fk_ch_cont FOREIGN KEY (contract_number) REFERENCES telecom.contract(contract_number);


--
-- TOC entry 2988 (class 2606 OID 17267)
-- Name: charge fk_ch_resource; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.charge
    ADD CONSTRAINT fk_ch_resource FOREIGN KEY (resource_code) REFERENCES telecom.third_party_resources(resource_code);


--
-- TOC entry 2989 (class 2606 OID 17292)
-- Name: service_connection fk_conn_cont; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.service_connection
    ADD CONSTRAINT fk_conn_cont FOREIGN KEY (contract_number) REFERENCES telecom.contract(contract_number);


--
-- TOC entry 2990 (class 2606 OID 17297)
-- Name: service_connection fk_conn_serv; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.service_connection
    ADD CONSTRAINT fk_conn_serv FOREIGN KEY (service_code) REFERENCES telecom.extra_service(service_code);


--
-- TOC entry 2981 (class 2606 OID 17166)
-- Name: contract fk_contract_sub; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.contract
    ADD CONSTRAINT fk_contract_sub FOREIGN KEY (phone_number) REFERENCES telecom.subscriber(phone_number) ON DELETE CASCADE;


--
-- TOC entry 2982 (class 2606 OID 17171)
-- Name: contract fk_contract_tar; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.contract
    ADD CONSTRAINT fk_contract_tar FOREIGN KEY (tariff_code) REFERENCES telecom.tariff(tariff_code);


--
-- TOC entry 2992 (class 2606 OID 17325)
-- Name: service_history fk_hist_serv; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.service_history
    ADD CONSTRAINT fk_hist_serv FOREIGN KEY (service_code) REFERENCES telecom.extra_service(service_code);


--
-- TOC entry 2991 (class 2606 OID 17311)
-- Name: tariff_history fk_hist_tar; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.tariff_history
    ADD CONSTRAINT fk_hist_tar FOREIGN KEY (tariff_code) REFERENCES telecom.tariff(tariff_code);


--
-- TOC entry 2983 (class 2606 OID 17188)
-- Name: passport_data fk_pass_sub; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.passport_data
    ADD CONSTRAINT fk_pass_sub FOREIGN KEY (phone_number) REFERENCES telecom.subscriber(phone_number) ON DELETE CASCADE;


--
-- TOC entry 2986 (class 2606 OID 17232)
-- Name: payment fk_pay_cont; Type: FK CONSTRAINT; Schema: telecom; Owner: postgres
--

ALTER TABLE ONLY telecom.payment
    ADD CONSTRAINT fk_pay_cont FOREIGN KEY (contract_number) REFERENCES telecom.contract(contract_number);


-- Completed on 2026-03-30 13:54:05

--
-- PostgreSQL database dump complete
--

\unrestrict BWlZtjZs94q774SqMLtrIO0aiqQZbe1fERE4Z7lR6F5o7gDd6PbTFW9ilCY6e75

