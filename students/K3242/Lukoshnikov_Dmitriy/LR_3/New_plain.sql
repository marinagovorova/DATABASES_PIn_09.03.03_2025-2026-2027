--
-- PostgreSQL database dump
--

-- Dumped from database version 17.3
-- Dumped by pg_dump version 17.3

-- Started on 2026-03-29 15:33:12

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

DROP DATABASE "TaxiOrder";
--
-- TOC entry 5085 (class 1262 OID 25149)
-- Name: TaxiOrder; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "TaxiOrder" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'ru-RU';


ALTER DATABASE "TaxiOrder" OWNER TO postgres;

\connect "TaxiOrder"

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
-- TOC entry 6 (class 2615 OID 25150)
-- Name: Taxi; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "Taxi";


ALTER SCHEMA "Taxi" OWNER TO postgres;

--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA "Taxi"; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA "Taxi" IS 'Схема для базы данных таксопарка';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 25277)
-- Name: bank_card; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".bank_card (
    card_number integer NOT NULL,
    passenger_id integer NOT NULL,
    bank character varying(50) NOT NULL,
    cvv integer NOT NULL,
    year_to integer,
    month_to integer,
    CONSTRAINT card_cvv_check CHECK (((cvv >= 100) AND (cvv <= 999))),
    CONSTRAINT card_number_check CHECK ((card_number > 0))
);


ALTER TABLE "Taxi".bank_card OWNER TO postgres;

--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE bank_card; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".bank_card IS 'Банковские карты пассажиров';


--
-- TOC entry 230 (class 1259 OID 25233)
-- Name: car; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".car (
    car_id integer NOT NULL,
    model_id integer NOT NULL,
    license_plate character varying(20) NOT NULL,
    mileage integer NOT NULL,
    last_maintenance_date date,
    CONSTRAINT car_mileage_check CHECK ((mileage >= 0))
);


ALTER TABLE "Taxi".car OWNER TO postgres;

--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE car; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".car IS 'Автомобили таксопарка';


--
-- TOC entry 229 (class 1259 OID 25232)
-- Name: car_car_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".car_car_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".car_car_id_seq OWNER TO postgres;

--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 229
-- Name: car_car_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".car_car_id_seq OWNED BY "Taxi".car.car_id;


--
-- TOC entry 245 (class 1259 OID 25377)
-- Name: destination_address; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".destination_address (
    address_id integer NOT NULL,
    order_id integer NOT NULL,
    street character varying(50) NOT NULL,
    building integer NOT NULL,
    order_seq integer,
    CONSTRAINT address_building_check CHECK ((building > 0))
);


ALTER TABLE "Taxi".destination_address OWNER TO postgres;

--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE destination_address; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".destination_address IS 'Адреса назначения заказов';


--
-- TOC entry 244 (class 1259 OID 25376)
-- Name: destination_address_address_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".destination_address_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".destination_address_address_id_seq OWNER TO postgres;

--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 244
-- Name: destination_address_address_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".destination_address_address_id_seq OWNED BY "Taxi".destination_address.address_id;


--
-- TOC entry 219 (class 1259 OID 25152)
-- Name: employee; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".employee (
    "employee_id	" integer NOT NULL,
    address character varying(100) NOT NULL,
    phone character varying(12) NOT NULL,
    rating integer NOT NULL,
    birth_date date NOT NULL,
    citizenship character varying NOT NULL,
    CONSTRAINT employee_birth_date_check CHECK (((birth_date > '1900-01-01'::date) AND (birth_date <= CURRENT_DATE))),
    CONSTRAINT employee_phone_check CHECK (((phone)::text ~ '^\+7[0-9]{10}$'::text)),
    CONSTRAINT employee_rating_check CHECK (((rating >= 0) AND (rating <= 5)))
);


ALTER TABLE "Taxi".employee OWNER TO postgres;

--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE employee; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".employee IS 'Таблица сотрудников таксопарка';


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 219
-- Name: CONSTRAINT employee_birth_date_check ON employee; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON CONSTRAINT employee_birth_date_check ON "Taxi".employee IS 'Дата рождения после 01.01.1900 и не позже текущей';


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 219
-- Name: CONSTRAINT employee_phone_check ON employee; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON CONSTRAINT employee_phone_check ON "Taxi".employee IS 'Телефон должен быть в формате +7XXXXXXXXXX';


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 219
-- Name: CONSTRAINT employee_rating_check ON employee; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON CONSTRAINT employee_rating_check ON "Taxi".employee IS 'Рейтинг от 0 до 5';


--
-- TOC entry 218 (class 1259 OID 25151)
-- Name: employee_employee_id	_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi"."employee_employee_id	_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi"."employee_employee_id	_seq" OWNER TO postgres;

--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 218
-- Name: employee_employee_id	_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi"."employee_employee_id	_seq" OWNED BY "Taxi".employee."employee_id	";


--
-- TOC entry 224 (class 1259 OID 25186)
-- Name: employment_contract; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".employment_contract (
    contract_id integer NOT NULL,
    position_id integer NOT NULL,
    passport_series_number integer NOT NULL
);


ALTER TABLE "Taxi".employment_contract OWNER TO postgres;

--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE employment_contract; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".employment_contract IS 'Трудовые договоры сотрудников';


--
-- TOC entry 223 (class 1259 OID 25185)
-- Name: employment_contract_contract_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".employment_contract_contract_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".employment_contract_contract_id_seq OWNER TO postgres;

--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 223
-- Name: employment_contract_contract_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".employment_contract_contract_id_seq OWNED BY "Taxi".employment_contract.contract_id;


--
-- TOC entry 228 (class 1259 OID 25218)
-- Name: model; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".model (
    model_id integer NOT NULL,
    tariff_id integer NOT NULL,
    class character varying(20) NOT NULL,
    country character varying(50) NOT NULL,
    engine_power integer NOT NULL,
    fuel_consumption integer NOT NULL,
    brand character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    CONSTRAINT model_class_check CHECK (((class)::text = ANY ((ARRAY['эконом'::character varying, 'бизнес'::character varying, 'комфорт'::character varying, 'грузовой'::character varying])::text[]))),
    CONSTRAINT model_engine_power_check CHECK ((engine_power > 0)),
    CONSTRAINT model_fuel_consumption_check CHECK ((fuel_consumption >= 0))
);


ALTER TABLE "Taxi".model OWNER TO postgres;

--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE model; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".model IS 'Модели автомобилей';


--
-- TOC entry 227 (class 1259 OID 25217)
-- Name: model_model_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".model_model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".model_model_id_seq OWNER TO postgres;

--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 227
-- Name: model_model_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".model_model_id_seq OWNED BY "Taxi".model.model_id;


--
-- TOC entry 241 (class 1259 OID 25328)
-- Name: order; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi"."order" (
    order_id integer NOT NULL,
    schedule_id integer NOT NULL,
    tariff_id integer NOT NULL,
    passenger_id integer NOT NULL,
    status_id integer NOT NULL,
    cost integer NOT NULL,
    distance integer NOT NULL,
    planned_pickup_time time without time zone NOT NULL,
    pickup_time time without time zone,
    dropoff_time time without time zone,
    date date NOT NULL,
    CONSTRAINT order_date_check CHECK ((date <= CURRENT_DATE)),
    CONSTRAINT order_distance_check CHECK ((distance > 0)),
    CONSTRAINT order_times_check CHECK ((((pickup_time IS NULL) OR (pickup_time >= planned_pickup_time)) AND ((dropoff_time IS NULL) OR (dropoff_time >= pickup_time))))
);


ALTER TABLE "Taxi"."order" OWNER TO postgres;

--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE "order"; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi"."order" IS 'Заказы на поездки';


--
-- TOC entry 240 (class 1259 OID 25327)
-- Name: order_order_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".order_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".order_order_id_seq OWNER TO postgres;

--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 240
-- Name: order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".order_order_id_seq OWNED BY "Taxi"."order".order_id;


--
-- TOC entry 239 (class 1259 OID 25313)
-- Name: order_status; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".order_status (
    status_id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE "Taxi".order_status OWNER TO postgres;

--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE order_status; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".order_status IS 'Статусы заказов';


--
-- TOC entry 238 (class 1259 OID 25312)
-- Name: order_status_status_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".order_status_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".order_status_status_id_seq OWNER TO postgres;

--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 238
-- Name: order_status_status_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".order_status_status_id_seq OWNED BY "Taxi".order_status.status_id;


--
-- TOC entry 234 (class 1259 OID 25267)
-- Name: passenger; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".passenger (
    passenger_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    phone character varying(12) NOT NULL,
    rating integer NOT NULL,
    CONSTRAINT passenger_phone_check CHECK (((phone)::text ~ '^\+7[0-9]{10}$'::text))
);


ALTER TABLE "Taxi".passenger OWNER TO postgres;

--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE passenger; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".passenger IS 'Пассажиры такси';


--
-- TOC entry 233 (class 1259 OID 25266)
-- Name: passenger_passenger_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".passenger_passenger_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".passenger_passenger_id_seq OWNER TO postgres;

--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 233
-- Name: passenger_passenger_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".passenger_passenger_id_seq OWNED BY "Taxi".passenger.passenger_id;


--
-- TOC entry 220 (class 1259 OID 25165)
-- Name: passport_data; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".passport_data (
    series_number integer NOT NULL,
    employee_id integer NOT NULL,
    issued_by character varying(70) NOT NULL,
    country character varying(70) NOT NULL,
    full_name character varying(100) NOT NULL,
    issue_date date NOT NULL,
    CONSTRAINT passport_issue_date_check CHECK (((issue_date > '1900-01-01'::date) AND (issue_date <= CURRENT_DATE)))
);


ALTER TABLE "Taxi".passport_data OWNER TO postgres;

--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE passport_data; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".passport_data IS 'Паспортные данные сотрудников';


--
-- TOC entry 237 (class 1259 OID 25297)
-- Name: payment; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".payment (
    payment_id integer NOT NULL,
    card_number integer,
    date date NOT NULL,
    amount integer NOT NULL,
    payment_status character varying(40) NOT NULL,
    payment_type character varying(40) NOT NULL,
    order_id integer,
    CONSTRAINT payment_amount_check CHECK ((amount > 0)),
    CONSTRAINT payment_date_check CHECK (((date > '1900-01-01'::date) AND (date <= CURRENT_DATE))),
    CONSTRAINT payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['не оплачен'::character varying, 'в процессе'::character varying, 'оплачен'::character varying])::text[]))),
    CONSTRAINT payment_type_check CHECK (((payment_type)::text = ANY ((ARRAY['картой'::character varying, 'наличкой'::character varying])::text[])))
);


ALTER TABLE "Taxi".payment OWNER TO postgres;

--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE payment; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".payment IS 'Платежи за поездки';


--
-- TOC entry 236 (class 1259 OID 25296)
-- Name: payment_payment_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".payment_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".payment_payment_id_seq OWNER TO postgres;

--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 236
-- Name: payment_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".payment_payment_id_seq OWNED BY "Taxi".payment.payment_id;


--
-- TOC entry 222 (class 1259 OID 25177)
-- Name: position; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi"."position" (
    position_id integer NOT NULL,
    privileges character varying(100),
    order_percent integer NOT NULL,
    name character varying(60) NOT NULL,
    CONSTRAINT position_name_check CHECK (((name)::text = ANY ((ARRAY['водитель'::character varying, 'администратор'::character varying, 'грузчик'::character varying])::text[]))),
    CONSTRAINT position_percent_check CHECK (((order_percent >= 1) AND (order_percent <= 100)))
);


ALTER TABLE "Taxi"."position" OWNER TO postgres;

--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE "position"; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi"."position" IS 'Должности сотрудников';


--
-- TOC entry 221 (class 1259 OID 25176)
-- Name: position_position_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".position_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".position_position_id_seq OWNER TO postgres;

--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 221
-- Name: position_position_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".position_position_id_seq OWNED BY "Taxi"."position".position_id;


--
-- TOC entry 243 (class 1259 OID 25363)
-- Name: review; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".review (
    review_id integer NOT NULL,
    order_id integer NOT NULL,
    review_text character varying(200),
    comment character varying(100),
    status character varying(30) NOT NULL,
    date date NOT NULL,
    CONSTRAINT review_date_check CHECK (((date > '1900-01-01'::date) AND (date <= CURRENT_DATE))),
    CONSTRAINT review_status_check CHECK (((status)::text = ANY ((ARRAY['опубликован'::character varying, 'отклонен'::character varying, 'в процессе'::character varying])::text[])))
);


ALTER TABLE "Taxi".review OWNER TO postgres;

--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 243
-- Name: TABLE review; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".review IS 'Отзывы пассажиров';


--
-- TOC entry 242 (class 1259 OID 25362)
-- Name: review_review_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".review_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".review_review_id_seq OWNER TO postgres;

--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 242
-- Name: review_review_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".review_review_id_seq OWNED BY "Taxi".review.review_id;


--
-- TOC entry 226 (class 1259 OID 25209)
-- Name: tariff; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".tariff (
    tariff_id integer NOT NULL,
    price_per_km integer NOT NULL,
    name character varying(40) NOT NULL,
    date_from date NOT NULL,
    date_to date,
    CONSTRAINT tariff_dates_check CHECK (((date_from > '1900-01-01'::date) AND ((date_to IS NULL) OR (date_to >= date_from)))),
    CONSTRAINT tariff_price_check CHECK ((price_per_km > 0))
);


ALTER TABLE "Taxi".tariff OWNER TO postgres;

--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE tariff; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".tariff IS 'Тарифы на поездки';


--
-- TOC entry 225 (class 1259 OID 25208)
-- Name: tariff_tariff_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".tariff_tariff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".tariff_tariff_id_seq OWNER TO postgres;

--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 225
-- Name: tariff_tariff_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".tariff_tariff_id_seq OWNED BY "Taxi".tariff.tariff_id;


--
-- TOC entry 232 (class 1259 OID 25248)
-- Name: work_shedule; Type: TABLE; Schema: Taxi; Owner: postgres
--

CREATE TABLE "Taxi".work_shedule (
    schedule_id integer NOT NULL,
    contract_id integer NOT NULL,
    car_id integer,
    status character varying(50) NOT NULL,
    date_from date NOT NULL,
    date_to date,
    CONSTRAINT schedule_dates_check CHECK (((date_from > '1900-01-01'::date) AND ((date_to IS NULL) OR (date_to >= date_from)))),
    CONSTRAINT schedule_status_check CHECK (((status)::text = ANY ((ARRAY['не начат'::character varying, 'в процессе'::character varying, 'закончен'::character varying])::text[])))
);


ALTER TABLE "Taxi".work_shedule OWNER TO postgres;

--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE work_shedule; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON TABLE "Taxi".work_shedule IS 'График работы сотрудников';


--
-- TOC entry 231 (class 1259 OID 25247)
-- Name: work_shedule_schedule_id_seq; Type: SEQUENCE; Schema: Taxi; Owner: postgres
--

CREATE SEQUENCE "Taxi".work_shedule_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Taxi".work_shedule_schedule_id_seq OWNER TO postgres;

--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 231
-- Name: work_shedule_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: Taxi; Owner: postgres
--

ALTER SEQUENCE "Taxi".work_shedule_schedule_id_seq OWNED BY "Taxi".work_shedule.schedule_id;


--
-- TOC entry 4816 (class 2604 OID 25236)
-- Name: car car_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".car ALTER COLUMN car_id SET DEFAULT nextval('"Taxi".car_car_id_seq'::regclass);


--
-- TOC entry 4823 (class 2604 OID 25380)
-- Name: destination_address address_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".destination_address ALTER COLUMN address_id SET DEFAULT nextval('"Taxi".destination_address_address_id_seq'::regclass);


--
-- TOC entry 4811 (class 2604 OID 25155)
-- Name: employee employee_id	; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".employee ALTER COLUMN "employee_id	" SET DEFAULT nextval('"Taxi"."employee_employee_id	_seq"'::regclass);


--
-- TOC entry 4813 (class 2604 OID 25189)
-- Name: employment_contract contract_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".employment_contract ALTER COLUMN contract_id SET DEFAULT nextval('"Taxi".employment_contract_contract_id_seq'::regclass);


--
-- TOC entry 4815 (class 2604 OID 25221)
-- Name: model model_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".model ALTER COLUMN model_id SET DEFAULT nextval('"Taxi".model_model_id_seq'::regclass);


--
-- TOC entry 4821 (class 2604 OID 25331)
-- Name: order order_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi"."order" ALTER COLUMN order_id SET DEFAULT nextval('"Taxi".order_order_id_seq'::regclass);


--
-- TOC entry 4820 (class 2604 OID 25316)
-- Name: order_status status_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".order_status ALTER COLUMN status_id SET DEFAULT nextval('"Taxi".order_status_status_id_seq'::regclass);


--
-- TOC entry 4818 (class 2604 OID 25270)
-- Name: passenger passenger_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".passenger ALTER COLUMN passenger_id SET DEFAULT nextval('"Taxi".passenger_passenger_id_seq'::regclass);


--
-- TOC entry 4819 (class 2604 OID 25300)
-- Name: payment payment_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".payment ALTER COLUMN payment_id SET DEFAULT nextval('"Taxi".payment_payment_id_seq'::regclass);


--
-- TOC entry 4812 (class 2604 OID 25180)
-- Name: position position_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi"."position" ALTER COLUMN position_id SET DEFAULT nextval('"Taxi".position_position_id_seq'::regclass);


--
-- TOC entry 4822 (class 2604 OID 25366)
-- Name: review review_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".review ALTER COLUMN review_id SET DEFAULT nextval('"Taxi".review_review_id_seq'::regclass);


--
-- TOC entry 4814 (class 2604 OID 25212)
-- Name: tariff tariff_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".tariff ALTER COLUMN tariff_id SET DEFAULT nextval('"Taxi".tariff_tariff_id_seq'::regclass);


--
-- TOC entry 4817 (class 2604 OID 25251)
-- Name: work_shedule schedule_id; Type: DEFAULT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".work_shedule ALTER COLUMN schedule_id SET DEFAULT nextval('"Taxi".work_shedule_schedule_id_seq'::regclass);


--
-- TOC entry 5069 (class 0 OID 25277)
-- Dependencies: 235
-- Data for Name: bank_card; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (12345678, 3, 'Сбербанк', 123, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (23456789, 4, 'Тинькофф', 456, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (34567890, 5, 'ВТБ', 789, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (45678901, 6, 'Альфа-Банк', 234, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (56789012, 7, 'Сбербанк', 567, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (67890123, 8, 'Тинькофф', 890, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (78901234, 9, 'ВТБ', 345, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (89012345, 10, 'Газпромбанк', 678, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (90123456, 11, 'Райффайзенбанк', 901, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (11223344, 12, 'Сбербанк', 112, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (22334455, 13, 'Тинькофф', 223, NULL, NULL);
INSERT INTO "Taxi".bank_card (card_number, passenger_id, bank, cvv, year_to, month_to) VALUES (33445566, 14, 'ВТБ', 334, NULL, NULL);


--
-- TOC entry 5064 (class 0 OID 25233)
-- Dependencies: 230
-- Data for Name: car; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (1, 1, 'А123БВ777', 45000, '2024-05-15');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (2, 2, 'Б456ГД777', 67800, '2024-06-20');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (3, 3, 'В789ЕЖ777', 23400, '2024-07-10');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (4, 4, 'Г012ЗИ777', 89200, '2024-04-05');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (5, 5, 'Д345КЛ777', 56700, '2024-08-25');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (6, 6, 'Е678МН777', 12300, '2024-09-01');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (7, 7, 'Ж901ОП777', 112300, '2024-03-12');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (8, 8, 'З234РС777', 34500, '2024-07-30');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (9, 9, 'И567ТУ777', 67800, '2024-06-18');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (10, 10, 'Й890ФХ777', 23400, '2024-08-05');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (11, 1, 'К123ЦЧ777', 56700, '2024-05-22');
INSERT INTO "Taxi".car (car_id, model_id, license_plate, mileage, last_maintenance_date) VALUES (12, 3, 'Л456ШЩ777', 89000, '2024-04-10');


--
-- TOC entry 5079 (class 0 OID 25377)
-- Dependencies: 245
-- Data for Name: destination_address; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (1, 15, 'ул. Тверская', 15, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (2, 16, 'пр. Ленинский', 25, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (3, 17, 'ул. Арбат', 7, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (4, 18, 'пл. Красная', 1, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (5, 19, 'пр. Невский', 42, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (6, 20, 'ул. Мясницкая', 13, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (7, 21, 'ул. Пятницкая', 8, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (8, 22, 'пр. Мира', 32, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (9, 23, 'ул. Новый Арбат', 21, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (10, 24, 'наб. Москва-реки', 5, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (11, 25, 'ул. Воздвиженка', 9, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (12, 26, 'ул. Ильинка', 4, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (13, 27, 'ул. Большая Дмитровка', 12, NULL);
INSERT INTO "Taxi".destination_address (address_id, order_id, street, building, order_seq) VALUES (14, 28, 'ул. Малая Бронная', 18, NULL);


--
-- TOC entry 5053 (class 0 OID 25152)
-- Dependencies: 219
-- Data for Name: employee; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".employee ("employee_id	", address, phone, rating, birth_date, citizenship) VALUES (25, 'ул. Ленина, д. 10, кв. 5', '+79031234567', 5, '1985-03-15', 'Россия');
INSERT INTO "Taxi".employee ("employee_id	", address, phone, rating, birth_date, citizenship) VALUES (26, 'пр. Мира, д. 25, кв. 12', '+79037654321', 4, '1990-07-22', 'Россия');
INSERT INTO "Taxi".employee ("employee_id	", address, phone, rating, birth_date, citizenship) VALUES (27, 'ул. Гагарина, д. 7, кв. 3', '+79039876543', 5, '1982-11-30', 'Россия');
INSERT INTO "Taxi".employee ("employee_id	", address, phone, rating, birth_date, citizenship) VALUES (28, 'ул. Пушкина, д. 15, кв. 8', '+79031112233', 3, '1995-05-18', 'Россия');
INSERT INTO "Taxi".employee ("employee_id	", address, phone, rating, birth_date, citizenship) VALUES (29, 'пр. Победы, д. 3, кв. 21', '+79034445566', 4, '1988-09-10', 'Россия');
INSERT INTO "Taxi".employee ("employee_id	", address, phone, rating, birth_date, citizenship) VALUES (30, 'ул. Советская, д. 45, кв. 7', '+79037778899', 5, '1979-12-25', 'Россия');
INSERT INTO "Taxi".employee ("employee_id	", address, phone, rating, birth_date, citizenship) VALUES (31, 'ул. Кирова, д. 12, кв. 4', '+79039990011', 4, '1992-04-03', 'Россия');
INSERT INTO "Taxi".employee ("employee_id	", address, phone, rating, birth_date, citizenship) VALUES (32, 'пр. Ленинградский, д. 8, кв. 16', '+79036667788', 5, '1983-08-19', 'Россия');


--
-- TOC entry 5058 (class 0 OID 25186)
-- Dependencies: 224
-- Data for Name: employment_contract; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".employment_contract (contract_id, position_id, passport_series_number) VALUES (1, 1, 45);
INSERT INTO "Taxi".employment_contract (contract_id, position_id, passport_series_number) VALUES (2, 2, 450);
INSERT INTO "Taxi".employment_contract (contract_id, position_id, passport_series_number) VALUES (3, 1, 45);
INSERT INTO "Taxi".employment_contract (contract_id, position_id, passport_series_number) VALUES (4, 3, 45);
INSERT INTO "Taxi".employment_contract (contract_id, position_id, passport_series_number) VALUES (5, 4, 450);
INSERT INTO "Taxi".employment_contract (contract_id, position_id, passport_series_number) VALUES (6, 5, 45);
INSERT INTO "Taxi".employment_contract (contract_id, position_id, passport_series_number) VALUES (7, 3, 456);
INSERT INTO "Taxi".employment_contract (contract_id, position_id, passport_series_number) VALUES (8, 1, 45);


--
-- TOC entry 5062 (class 0 OID 25218)
-- Dependencies: 228
-- Data for Name: model; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (1, 1, 'эконом', 'Россия', 106, 7, 'Lada', 'Vesta');
INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (2, 1, 'эконом', 'Россия', 87, 6, 'Lada', 'Granta');
INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (3, 2, 'комфорт', 'Южная Корея', 150, 8, 'Hyundai', 'Solaris');
INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (4, 2, 'комфорт', 'Южная Корея', 128, 7, 'Kia', 'Rio');
INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (5, 3, 'бизнес', 'Германия', 190, 9, 'Mercedes-Benz', 'E-Class');
INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (6, 3, 'бизнес', 'Германия', 249, 10, 'BMW', '5 Series');
INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (7, 4, 'грузовой', 'Россия', 150, 12, 'ГАЗ', 'Газель Next');
INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (8, 4, 'грузовой', 'Россия', 215, 15, 'КамАЗ', '4308');
INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (9, 5, 'эконом', 'Франция', 110, 6, 'Renault', 'Logan');
INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (10, 2, 'комфорт', 'Япония', 140, 7, 'Toyota', 'Corolla');
INSERT INTO "Taxi".model (model_id, tariff_id, class, country, engine_power, fuel_consumption, brand, name) VALUES (11, 1, 'эконом', 'Китай', 100, 6, 'Haval', 'Jolion');


--
-- TOC entry 5075 (class 0 OID 25328)
-- Dependencies: 241
-- Data for Name: order; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (15, 13, 1, 3, 3, 450, 15, '10:00:00', '10:05:00', '10:35:00', '2024-10-01');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (16, 14, 2, 4, 3, 780, 16, '12:30:00', '12:35:00', '13:15:00', '2024-10-01');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (17, 15, 1, 5, 3, 320, 11, '14:00:00', '14:02:00', '14:30:00', '2024-10-02');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (18, 16, 2, 6, 3, 560, 12, '15:45:00', '15:50:00', '16:25:00', '2024-10-02');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (19, 17, 3, 7, 3, 890, 12, '09:15:00', '09:18:00', '09:55:00', '2024-10-03');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (20, 18, 1, 8, 3, 430, 15, '11:30:00', '11:35:00', '12:10:00', '2024-10-03');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (21, 19, 1, 9, 2, 1240, 16, '17:00:00', '17:10:00', NULL, '2024-10-04');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (22, 20, 2, 10, 3, 670, 14, '18:30:00', '18:32:00', '19:15:00', '2024-10-04');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (23, 21, 3, 11, 1, 350, 5, '20:00:00', NULL, NULL, '2024-10-05');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (24, 22, 4, 12, 3, 520, 6, '08:45:00', '08:47:00', '09:20:00', '2024-10-05');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (25, 23, 2, 13, 3, 980, 21, '13:15:00', '13:20:00', '14:10:00', '2024-10-06');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (26, 24, 1, 14, 3, 430, 15, '16:45:00', '16:48:00', '17:25:00', '2024-10-06');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (27, 23, 2, 12, 3, 670, 14, '11:00:00', '11:02:00', '11:45:00', '2024-10-07');
INSERT INTO "Taxi"."order" (order_id, schedule_id, tariff_id, passenger_id, status_id, cost, distance, planned_pickup_time, pickup_time, dropoff_time, date) VALUES (28, 21, 3, 3, 3, 890, 12, '15:30:00', '15:35:00', '16:10:00', '2024-10-07');


--
-- TOC entry 5073 (class 0 OID 25313)
-- Dependencies: 239
-- Data for Name: order_status; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".order_status (status_id, name) VALUES (1, 'не закончен');
INSERT INTO "Taxi".order_status (status_id, name) VALUES (2, 'в процессе');
INSERT INTO "Taxi".order_status (status_id, name) VALUES (3, 'закончен');


--
-- TOC entry 5068 (class 0 OID 25267)
-- Dependencies: 234
-- Data for Name: passenger; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (3, 'Иванов Иван Иванович', '+79161112233', 4);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (4, 'Петрова Мария Сергеевна', '+79162223344', 5);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (5, 'Сидоров Алексей Петрович', '+79163334455', 3);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (6, 'Козлова Елена Владимировна', '+79164445566', 4);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (7, 'Михайлов Дмитрий Андреевич', '+79165556677', 5);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (8, 'Федорова Ольга Николаевна', '+79166667788', 4);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (9, 'Николаев Павел Сергеевич', '+79167778899', 3);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (10, 'Алексеева Анна Викторовна', '+79168889900', 5);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (11, 'Степанов Артем Игоревич', '+79169990011', 4);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (12, 'Дмитриева Наталья Павловна', '+79160001122', 4);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (13, 'Андреев Максим Романович', '+79169991122', 4);
INSERT INTO "Taxi".passenger (passenger_id, full_name, phone, rating) VALUES (14, 'Романов Виктор Викторович', '+79162227788', 5);


--
-- TOC entry 5054 (class 0 OID 25165)
-- Dependencies: 220
-- Data for Name: passport_data; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".passport_data (series_number, employee_id, issued_by, country, full_name, issue_date) VALUES (45, 25, 'УФМС России по г. Москва', 'Россия', 'Сергеев Сергей Петрович', '2010-05-20');
INSERT INTO "Taxi".passport_data (series_number, employee_id, issued_by, country, full_name, issue_date) VALUES (456, 26, 'УФМС России по г. Санкт-Петербург', 'Россия', 'Петрова Анна Ивановна', '2012-08-15');
INSERT INTO "Taxi".passport_data (series_number, employee_id, issued_by, country, full_name, issue_date) VALUES (450, 27, 'УФМС России по г. Екатеринбург', 'Россия', 'Иванов Дмитрий Алексеевич', '2008-03-10');
INSERT INTO "Taxi".passport_data (series_number, employee_id, issued_by, country, full_name, issue_date) VALUES (56, 28, 'УФМС России по г. Казань', 'Россия', 'Смирнова Елена Викторовна', '2015-11-25');
INSERT INTO "Taxi".passport_data (series_number, employee_id, issued_by, country, full_name, issue_date) VALUES (567, 29, 'УФМС России по г. Нижний Новгород', 'Россия', 'Кузнецов Андрей Сергеевич', '2011-07-30');
INSERT INTO "Taxi".passport_data (series_number, employee_id, issued_by, country, full_name, issue_date) VALUES (2345, 30, 'УФМС России по г. Новосибирск', 'Россия', 'Попова Ольга Дмитриевна', '2005-12-05');
INSERT INTO "Taxi".passport_data (series_number, employee_id, issued_by, country, full_name, issue_date) VALUES (712, 31, 'УФМС России по г. Самара', 'Россия', 'Соколов Михаил Павлович', '2013-09-12');
INSERT INTO "Taxi".passport_data (series_number, employee_id, issued_by, country, full_name, issue_date) VALUES (123, 32, 'УФМС России по г. Челябинск', 'Россия', 'Лебедева Татьяна Николаевна', '2014-04-18');


--
-- TOC entry 5071 (class 0 OID 25297)
-- Dependencies: 237
-- Data for Name: payment; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (1, 12345678, '2024-10-01', 450, 'оплачен', 'картой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (2, 23456789, '2024-10-01', 780, 'оплачен', 'картой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (3, NULL, '2024-10-02', 320, 'оплачен', 'наличкой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (4, 34567890, '2024-10-02', 560, 'оплачен', 'картой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (5, 45678901, '2024-10-03', 890, 'оплачен', 'картой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (6, NULL, '2024-10-03', 430, 'оплачен', 'наличкой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (7, 56789012, '2024-10-04', 1240, 'в процессе', 'картой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (8, 67890123, '2024-10-04', 670, 'оплачен', 'картой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (9, 78901234, '2024-10-05', 350, 'не оплачен', 'картой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (10, NULL, '2024-10-05', 520, 'оплачен', 'наличкой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (11, 89012345, '2024-10-06', 980, 'оплачен', 'картой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (12, 90123456, '2024-10-06', 430, 'оплачен', 'картой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (13, 11223344, '2024-10-07', 670, 'оплачен', 'картой', NULL);
INSERT INTO "Taxi".payment (payment_id, card_number, date, amount, payment_status, payment_type, order_id) VALUES (14, 22334455, '2024-10-07', 890, 'оплачен', 'картой', NULL);


--
-- TOC entry 5056 (class 0 OID 25177)
-- Dependencies: 222
-- Data for Name: position; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi"."position" (position_id, privileges, order_percent, name) VALUES (1, 'Право управления автомобилями категории B', 10, 'водитель');
INSERT INTO "Taxi"."position" (position_id, privileges, order_percent, name) VALUES (2, 'Доступ к администрированию системы, управление персоналом', 5, 'администратор');
INSERT INTO "Taxi"."position" (position_id, privileges, order_percent, name) VALUES (3, 'Право погрузочно-разгрузочных работ', 8, 'грузчик');
INSERT INTO "Taxi"."position" (position_id, privileges, order_percent, name) VALUES (4, 'Право управления грузовыми автомобилями категории C', 12, 'водитель');
INSERT INTO "Taxi"."position" (position_id, privileges, order_percent, name) VALUES (5, 'Старший смены, контроль работы', 7, 'администратор');
INSERT INTO "Taxi"."position" (position_id, privileges, order_percent, name) VALUES (6, 'Работа с особо тяжелыми грузами', 9, 'грузчик');


--
-- TOC entry 5077 (class 0 OID 25363)
-- Dependencies: 243
-- Data for Name: review; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (1, 15, 'Отличная поездка, вежливый водитель', 'Всё понравилось', 'опубликован', '2024-10-01');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (2, 16, 'Машина чистая, приехали вовремя', 'Рекомендую', 'опубликован', '2024-10-01');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (3, 17, 'Хорошо, но немного опоздали', 'Могли бы и побыстрее', 'опубликован', '2024-10-02');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (4, 18, NULL, 'Без комментариев', 'отклонен', '2024-10-02');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (5, 19, 'Прекрасный сервис, буду пользоваться еще', 'Спасибо!', 'опубликован', '2024-10-03');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (6, 20, 'Нормально', NULL, 'опубликован', '2024-10-03');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (7, 21, NULL, NULL, 'в процессе', '2024-10-04');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (8, 22, 'Водитель профессионал, машина комфортная', NULL, 'опубликован', '2024-10-04');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (9, 23, NULL, NULL, 'отклонен', '2024-10-05');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (10, 24, 'Быстро и недорого', 'Цена/качество супер', 'опубликован', '2024-10-05');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (11, 25, 'Отличная поездка', NULL, 'опубликован', '2024-10-06');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (12, 26, 'Всё хорошо', 'Спасибо', 'опубликован', '2024-10-06');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (13, 27, 'Отлично', NULL, 'опубликован', '2024-10-07');
INSERT INTO "Taxi".review (review_id, order_id, review_text, comment, status, date) VALUES (14, 28, 'Хороший водитель', 'Понравилось', 'опубликован', '2024-10-07');


--
-- TOC entry 5060 (class 0 OID 25209)
-- Dependencies: 226
-- Data for Name: tariff; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".tariff (tariff_id, price_per_km, name, date_from, date_to) VALUES (1, 30, 'Эконом', '2024-01-01', NULL);
INSERT INTO "Taxi".tariff (tariff_id, price_per_km, name, date_from, date_to) VALUES (2, 50, 'Комфорт', '2024-01-01', NULL);
INSERT INTO "Taxi".tariff (tariff_id, price_per_km, name, date_from, date_to) VALUES (3, 80, 'Бизнес', '2024-01-01', NULL);
INSERT INTO "Taxi".tariff (tariff_id, price_per_km, name, date_from, date_to) VALUES (4, 40, 'Детский', '2024-01-01', NULL);
INSERT INTO "Taxi".tariff (tariff_id, price_per_km, name, date_from, date_to) VALUES (5, 100, 'Грузовой', '2024-01-01', NULL);
INSERT INTO "Taxi".tariff (tariff_id, price_per_km, name, date_from, date_to) VALUES (6, 35, 'Эконом (ночной)', '2024-01-01', NULL);
INSERT INTO "Taxi".tariff (tariff_id, price_per_km, name, date_from, date_to) VALUES (7, 70, 'Комфорт+', '2024-01-01', '2024-12-31');


--
-- TOC entry 5066 (class 0 OID 25248)
-- Dependencies: 232
-- Data for Name: work_shedule; Type: TABLE DATA; Schema: Taxi; Owner: postgres
--

INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (13, 1, 1, 'в процессе', '2024-10-01', NULL);
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (14, 2, NULL, 'в процессе', '2024-10-01', NULL);
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (15, 3, 2, 'в процессе', '2024-10-01', NULL);
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (16, 4, 7, 'закончен', '2024-09-01', '2024-09-30');
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (17, 4, 7, 'в процессе', '2024-10-01', NULL);
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (18, 5, 8, 'не начат', '2024-11-01', NULL);
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (19, 6, NULL, 'в процессе', '2024-10-01', NULL);
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (20, 7, 4, 'закончен', '2024-09-15', '2024-09-30');
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (21, 7, 5, 'в процессе', '2024-10-01', NULL);
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (22, 8, 3, 'в процессе', '2024-10-01', NULL);
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (23, 1, 6, 'не начат', '2024-10-15', NULL);
INSERT INTO "Taxi".work_shedule (schedule_id, contract_id, car_id, status, date_from, date_to) VALUES (24, 2, 9, 'закончен', '2024-09-10', '2024-09-20');


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 229
-- Name: car_car_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".car_car_id_seq', 12, true);


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 244
-- Name: destination_address_address_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".destination_address_address_id_seq', 14, true);


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 218
-- Name: employee_employee_id	_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi"."employee_employee_id	_seq"', 32, true);


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 223
-- Name: employment_contract_contract_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".employment_contract_contract_id_seq', 8, true);


--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 227
-- Name: model_model_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".model_model_id_seq', 11, true);


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 240
-- Name: order_order_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".order_order_id_seq', 28, true);


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 238
-- Name: order_status_status_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".order_status_status_id_seq', 3, true);


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 233
-- Name: passenger_passenger_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".passenger_passenger_id_seq', 14, true);


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 236
-- Name: payment_payment_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".payment_payment_id_seq', 14, true);


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 221
-- Name: position_position_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".position_position_id_seq', 6, true);


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 242
-- Name: review_review_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".review_review_id_seq', 14, true);


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 225
-- Name: tariff_tariff_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".tariff_tariff_id_seq', 7, true);


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 231
-- Name: work_shedule_schedule_id_seq; Type: SEQUENCE SET; Schema: Taxi; Owner: postgres
--

SELECT pg_catalog.setval('"Taxi".work_shedule_schedule_id_seq', 24, true);


--
-- TOC entry 4880 (class 2606 OID 25283)
-- Name: bank_card bank_card_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".bank_card
    ADD CONSTRAINT bank_card_pkey PRIMARY KEY (card_number);


--
-- TOC entry 4870 (class 2606 OID 25241)
-- Name: car car_license_plate_unique; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".car
    ADD CONSTRAINT car_license_plate_unique UNIQUE (license_plate);


--
-- TOC entry 4872 (class 2606 OID 25239)
-- Name: car car_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".car
    ADD CONSTRAINT car_pkey PRIMARY KEY (car_id);


--
-- TOC entry 4890 (class 2606 OID 25383)
-- Name: destination_address destination_address_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".destination_address
    ADD CONSTRAINT destination_address_pkey PRIMARY KEY (address_id);


--
-- TOC entry 4856 (class 2606 OID 25164)
-- Name: employee employee_phone_unique; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".employee
    ADD CONSTRAINT employee_phone_unique UNIQUE (phone);


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 4856
-- Name: CONSTRAINT employee_phone_unique ON employee; Type: COMMENT; Schema: Taxi; Owner: postgres
--

COMMENT ON CONSTRAINT employee_phone_unique ON "Taxi".employee IS 'Номер телефона должен быть уникальным';


--
-- TOC entry 4858 (class 2606 OID 25162)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY ("employee_id	");


--
-- TOC entry 4864 (class 2606 OID 25191)
-- Name: employment_contract employment_contract_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".employment_contract
    ADD CONSTRAINT employment_contract_pkey PRIMARY KEY (contract_id);


--
-- TOC entry 4868 (class 2606 OID 25226)
-- Name: model model_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".model
    ADD CONSTRAINT model_pkey PRIMARY KEY (model_id);


--
-- TOC entry 4842 (class 2606 OID 25647)
-- Name: bank_card month_check; Type: CHECK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE "Taxi".bank_card
    ADD CONSTRAINT month_check CHECK (((month_to >= 1) AND (month_to <= 12))) NOT VALID;


--
-- TOC entry 4886 (class 2606 OID 25336)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi"."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4884 (class 2606 OID 25319)
-- Name: order_status order_status_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".order_status
    ADD CONSTRAINT order_status_pkey PRIMARY KEY (status_id);


--
-- TOC entry 4876 (class 2606 OID 25276)
-- Name: passenger passenger_phone_unique; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".passenger
    ADD CONSTRAINT passenger_phone_unique UNIQUE (phone);


--
-- TOC entry 4878 (class 2606 OID 25274)
-- Name: passenger passenger_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".passenger
    ADD CONSTRAINT passenger_pkey PRIMARY KEY (passenger_id);


--
-- TOC entry 4839 (class 2606 OID 25406)
-- Name: passenger passenger_rating_check; Type: CHECK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE "Taxi".passenger
    ADD CONSTRAINT passenger_rating_check CHECK (((rating > 0) AND (rating <= 5))) NOT VALID;


--
-- TOC entry 4860 (class 2606 OID 25170)
-- Name: passport_data passport_data_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".passport_data
    ADD CONSTRAINT passport_data_pkey PRIMARY KEY (series_number);


--
-- TOC entry 4882 (class 2606 OID 25306)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 4862 (class 2606 OID 25184)
-- Name: position position_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi"."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (position_id);


--
-- TOC entry 4888 (class 2606 OID 25370)
-- Name: review review_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".review
    ADD CONSTRAINT review_pkey PRIMARY KEY (review_id);


--
-- TOC entry 4854 (class 2606 OID 25646)
-- Name: destination_address seq_check; Type: CHECK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE "Taxi".destination_address
    ADD CONSTRAINT seq_check CHECK (((order_seq >= 1) AND (order_seq < 100))) NOT VALID;


--
-- TOC entry 4866 (class 2606 OID 25216)
-- Name: tariff tariff_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".tariff
    ADD CONSTRAINT tariff_pkey PRIMARY KEY (tariff_id);


--
-- TOC entry 4874 (class 2606 OID 25255)
-- Name: work_shedule work_shedule_pkey; Type: CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".work_shedule
    ADD CONSTRAINT work_shedule_pkey PRIMARY KEY (schedule_id);


--
-- TOC entry 4843 (class 2606 OID 25648)
-- Name: bank_card year_check; Type: CHECK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE "Taxi".bank_card
    ADD CONSTRAINT year_check CHECK (((year_to > 0) AND (year_to < 100))) NOT VALID;


--
-- TOC entry 4906 (class 2606 OID 25384)
-- Name: destination_address fk_address_order; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".destination_address
    ADD CONSTRAINT fk_address_order FOREIGN KEY (order_id) REFERENCES "Taxi"."order"(order_id);


--
-- TOC entry 4895 (class 2606 OID 25242)
-- Name: car fk_car_model; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".car
    ADD CONSTRAINT fk_car_model FOREIGN KEY (model_id) REFERENCES "Taxi".model(model_id);


--
-- TOC entry 4898 (class 2606 OID 25284)
-- Name: bank_card fk_card_passenger; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".bank_card
    ADD CONSTRAINT fk_card_passenger FOREIGN KEY (passenger_id) REFERENCES "Taxi".passenger(passenger_id);


--
-- TOC entry 4892 (class 2606 OID 25202)
-- Name: employment_contract fk_contract_passport; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".employment_contract
    ADD CONSTRAINT fk_contract_passport FOREIGN KEY (passport_series_number) REFERENCES "Taxi".passport_data(series_number) NOT VALID;


--
-- TOC entry 4893 (class 2606 OID 25197)
-- Name: employment_contract fk_contract_position; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".employment_contract
    ADD CONSTRAINT fk_contract_position FOREIGN KEY (position_id) REFERENCES "Taxi"."position"(position_id) NOT VALID;


--
-- TOC entry 4894 (class 2606 OID 25227)
-- Name: model fk_model_tariff; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".model
    ADD CONSTRAINT fk_model_tariff FOREIGN KEY (tariff_id) REFERENCES "Taxi".tariff(tariff_id);


--
-- TOC entry 4901 (class 2606 OID 25347)
-- Name: order fk_order_passenger; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi"."order"
    ADD CONSTRAINT fk_order_passenger FOREIGN KEY (passenger_id) REFERENCES "Taxi".passenger(passenger_id);


--
-- TOC entry 4902 (class 2606 OID 25337)
-- Name: order fk_order_schedule; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi"."order"
    ADD CONSTRAINT fk_order_schedule FOREIGN KEY (schedule_id) REFERENCES "Taxi".work_shedule(schedule_id);


--
-- TOC entry 4903 (class 2606 OID 25352)
-- Name: order fk_order_status; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi"."order"
    ADD CONSTRAINT fk_order_status FOREIGN KEY (status_id) REFERENCES "Taxi".order_status(status_id);


--
-- TOC entry 4904 (class 2606 OID 25342)
-- Name: order fk_order_tariff; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi"."order"
    ADD CONSTRAINT fk_order_tariff FOREIGN KEY (tariff_id) REFERENCES "Taxi".tariff(tariff_id);


--
-- TOC entry 4891 (class 2606 OID 25171)
-- Name: passport_data fk_passport_employee; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".passport_data
    ADD CONSTRAINT fk_passport_employee FOREIGN KEY (employee_id) REFERENCES "Taxi".employee("employee_id	") ON DELETE CASCADE;


--
-- TOC entry 4899 (class 2606 OID 25641)
-- Name: payment fk_payment; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".payment
    ADD CONSTRAINT fk_payment FOREIGN KEY (order_id) REFERENCES "Taxi"."order"(order_id) NOT VALID;


--
-- TOC entry 4900 (class 2606 OID 25307)
-- Name: payment fk_payment_card; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".payment
    ADD CONSTRAINT fk_payment_card FOREIGN KEY (card_number) REFERENCES "Taxi".bank_card(card_number);


--
-- TOC entry 4905 (class 2606 OID 25371)
-- Name: review fk_review_order; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".review
    ADD CONSTRAINT fk_review_order FOREIGN KEY (order_id) REFERENCES "Taxi"."order"(order_id);


--
-- TOC entry 4896 (class 2606 OID 25261)
-- Name: work_shedule fk_schedule_car; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".work_shedule
    ADD CONSTRAINT fk_schedule_car FOREIGN KEY (car_id) REFERENCES "Taxi".car(car_id);


--
-- TOC entry 4897 (class 2606 OID 25256)
-- Name: work_shedule fk_schedule_contract; Type: FK CONSTRAINT; Schema: Taxi; Owner: postgres
--

ALTER TABLE ONLY "Taxi".work_shedule
    ADD CONSTRAINT fk_schedule_contract FOREIGN KEY (contract_id) REFERENCES "Taxi".employment_contract(contract_id);


-- Completed on 2026-03-29 15:33:13

--
-- PostgreSQL database dump complete
--

