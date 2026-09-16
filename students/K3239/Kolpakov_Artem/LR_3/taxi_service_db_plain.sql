--
-- PostgreSQL database dump
--

\restrict 4MXN32Sr7RW4Jy9Uh3aBEVCAOjQdA01CjSRtWc71aIvyVXaiMZNYq4Bm4V3f0a8

-- Dumped from database version 18.3 (Homebrew)
-- Dumped by pg_dump version 18.2

-- Started on 2026-03-29 17:36:33 MSK

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
-- TOC entry 3889 (class 1262 OID 16391)
-- Name: taxi_service_db; Type: DATABASE; Schema: -; Owner: admin
--

CREATE DATABASE taxi_service_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE taxi_service_db OWNER TO admin;

\unrestrict 4MXN32Sr7RW4Jy9Uh3aBEVCAOjQdA01CjSRtWc71aIvyVXaiMZNYq4Bm4V3f0a8
\connect taxi_service_db
\restrict 4MXN32Sr7RW4Jy9Uh3aBEVCAOjQdA01CjSRtWc71aIvyVXaiMZNYq4Bm4V3f0a8

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
-- TOC entry 6 (class 2615 OID 16392)
-- Name: taxi; Type: SCHEMA; Schema: -; Owner: admin
--

CREATE SCHEMA taxi;


ALTER SCHEMA taxi OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 239 (class 1259 OID 16457)
-- Name: car; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.car (
    car_id integer NOT NULL,
    owner_id integer,
    model_id integer,
    last_inspection_date date,
    car_status character varying(20),
    plate_number character varying(20),
    cost numeric(10,2),
    mileage integer,
    CONSTRAINT chk_car_cost CHECK ((cost >= (0)::numeric)),
    CONSTRAINT chk_car_mileage CHECK ((mileage >= 0))
);


ALTER TABLE taxi.car OWNER TO admin;

--
-- TOC entry 238 (class 1259 OID 16456)
-- Name: car_car_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.car ALTER COLUMN car_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.car_car_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 16450)
-- Name: car_model; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.car_model (
    model_id integer NOT NULL,
    technical_specs character varying(255),
    country_of_production character varying(50),
    production_year integer,
    make character varying(50),
    model_name character varying(50),
    body_type character varying(20)
);


ALTER TABLE taxi.car_model OWNER TO admin;

--
-- TOC entry 236 (class 1259 OID 16449)
-- Name: car_model_model_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.car_model ALTER COLUMN model_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.car_model_model_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 16436)
-- Name: employee; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.employee (
    employee_id integer NOT NULL,
    employee_category_id integer,
    employee_position_code integer,
    phone character varying(20),
    address character varying(50),
    full_name character varying(50),
    passport_data character varying(50),
    status character varying(20),
    CONSTRAINT chk_employee_status CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying, 'vacation'::character varying, 'dismissed'::character varying])::text[])))
);


ALTER TABLE taxi.employee OWNER TO admin;

--
-- TOC entry 229 (class 1259 OID 16422)
-- Name: employee_category; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.employee_category (
    employee_category_id integer NOT NULL,
    category_name character varying(50),
    description character varying(255)
);


ALTER TABLE taxi.employee_category OWNER TO admin;

--
-- TOC entry 228 (class 1259 OID 16421)
-- Name: employee_category_employee_category_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.employee_category ALTER COLUMN employee_category_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.employee_category_employee_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 16435)
-- Name: employee_employee_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.employee ALTER COLUMN employee_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.employee_employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 16443)
-- Name: employee_position; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.employee_position (
    contract_number integer NOT NULL,
    employee_id integer,
    position_id integer,
    start_date date,
    end_date date,
    contract_type character varying(50),
    CONSTRAINT chk_employee_position_dates CHECK (((end_date IS NULL) OR (end_date >= start_date)))
);


ALTER TABLE taxi.employee_position OWNER TO admin;

--
-- TOC entry 234 (class 1259 OID 16442)
-- Name: employee_position_contract_number_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.employee_position ALTER COLUMN contract_number ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.employee_position_contract_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 241 (class 1259 OID 16464)
-- Name: employee_work_schedule; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.employee_work_schedule (
    work_schedule_id integer NOT NULL,
    employee_id integer,
    car_id integer,
    work_date date,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    status character varying(20),
    CONSTRAINT chk_employee_work_schedule_time CHECK ((end_time > start_time))
);


ALTER TABLE taxi.employee_work_schedule OWNER TO admin;

--
-- TOC entry 240 (class 1259 OID 16463)
-- Name: employee_work_schedule_work_schedule_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.employee_work_schedule ALTER COLUMN work_schedule_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.employee_work_schedule_work_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 16471)
-- Name: orders; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.orders (
    order_id integer NOT NULL,
    passenger_id integer,
    car_id integer,
    driver_id integer,
    tariff_id integer,
    administrator_id integer,
    card_id integer,
    order_status character varying(20),
    call_datetime timestamp without time zone,
    actual_pickup_time timestamp without time zone,
    planned_pickup_time timestamp without time zone,
    pickup_address character varying(50),
    destination_address character varying(50),
    distance_km numeric(10,2),
    order_cost numeric(10,2),
    payment_type character varying(10),
    client_review character varying(255),
    CONSTRAINT chk_orders_cost CHECK ((order_cost >= (0)::numeric)),
    CONSTRAINT chk_orders_distance CHECK ((distance_km >= (0)::numeric)),
    CONSTRAINT chk_orders_payment_type CHECK (((payment_type)::text = ANY ((ARRAY['cash'::character varying, 'card'::character varying])::text[]))),
    CONSTRAINT chk_orders_pickup_time CHECK (((actual_pickup_time IS NULL) OR (actual_pickup_time >= call_datetime)))
);


ALTER TABLE taxi.orders OWNER TO admin;

--
-- TOC entry 242 (class 1259 OID 16470)
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.orders ALTER COLUMN order_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 16394)
-- Name: passenger; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.passenger (
    passenger_id integer NOT NULL,
    full_name character varying(50),
    phone character varying(20),
    email character varying(50),
    notes character varying(100)
);


ALTER TABLE taxi.passenger OWNER TO admin;

--
-- TOC entry 220 (class 1259 OID 16393)
-- Name: passenger_passenger_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.passenger ALTER COLUMN passenger_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.passenger_passenger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 16401)
-- Name: payment_card; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.payment_card (
    card_id integer NOT NULL,
    passenger_id integer,
    card_number character varying(16),
    cvv integer,
    expiration_date date,
    holder_name character varying(50),
    CONSTRAINT chk_payment_card_cvv CHECK (((cvv >= 100) AND (cvv <= 999))),
    CONSTRAINT chk_payment_card_number_length CHECK ((char_length((card_number)::text) = 16))
);


ALTER TABLE taxi.payment_card OWNER TO admin;

--
-- TOC entry 222 (class 1259 OID 16400)
-- Name: payment_card_card_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.payment_card ALTER COLUMN card_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.payment_card_card_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 16429)
-- Name: position; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi."position" (
    position_id integer NOT NULL,
    position_name character varying(50),
    duties_description character varying(255)
);


ALTER TABLE taxi."position" OWNER TO admin;

--
-- TOC entry 230 (class 1259 OID 16428)
-- Name: position_position_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi."position" ALTER COLUMN position_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.position_position_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 16408)
-- Name: tariff; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.tariff (
    tariff_id integer NOT NULL,
    car_class character varying(50),
    price_per_km numeric(10,2),
    tariff_name character varying(30),
    waiting_fee_per_minute numeric(10,2),
    CONSTRAINT chk_tariff_price_per_km CHECK ((price_per_km >= (0)::numeric)),
    CONSTRAINT chk_tariff_waiting_fee_per_minute CHECK ((waiting_fee_per_minute >= (0)::numeric))
);


ALTER TABLE taxi.tariff OWNER TO admin;

--
-- TOC entry 227 (class 1259 OID 16415)
-- Name: tariff_surcharge; Type: TABLE; Schema: taxi; Owner: admin
--

CREATE TABLE taxi.tariff_surcharge (
    tariff_surcharge_id integer NOT NULL,
    tariff_id integer,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    comment_text character varying(100),
    km_price_coefficient numeric(5,2),
    CONSTRAINT chk_tariff_surcharge_coefficient CHECK ((km_price_coefficient > (0)::numeric)),
    CONSTRAINT chk_tariff_surcharge_time CHECK ((end_time > start_time))
);


ALTER TABLE taxi.tariff_surcharge OWNER TO admin;

--
-- TOC entry 226 (class 1259 OID 16414)
-- Name: tariff_surcharge_tariff_surcharge_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.tariff_surcharge ALTER COLUMN tariff_surcharge_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.tariff_surcharge_tariff_surcharge_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 16407)
-- Name: tariff_tariff_id_seq; Type: SEQUENCE; Schema: taxi; Owner: admin
--

ALTER TABLE taxi.tariff ALTER COLUMN tariff_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME taxi.tariff_tariff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3879 (class 0 OID 16457)
-- Dependencies: 239
-- Data for Name: car; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.car (car_id, owner_id, model_id, last_inspection_date, car_status, plate_number, cost, mileage) OVERRIDING SYSTEM VALUE VALUES (1, 1, 1, '2026-02-10', 'active', 'А111АА178', 2500000.00, 85000);
INSERT INTO taxi.car (car_id, owner_id, model_id, last_inspection_date, car_status, plate_number, cost, mileage) OVERRIDING SYSTEM VALUE VALUES (2, 2, 2, '2026-02-18', 'active', 'В222ВВ178', 1700000.00, 112000);
INSERT INTO taxi.car (car_id, owner_id, model_id, last_inspection_date, car_status, plate_number, cost, mileage) OVERRIDING SYSTEM VALUE VALUES (3, 2, 3, '2026-03-01', 'repair', 'С333СС178', 2800000.00, 64000);


--
-- TOC entry 3877 (class 0 OID 16450)
-- Dependencies: 237
-- Data for Name: car_model; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.car_model (model_id, technical_specs, country_of_production, production_year, make, model_name, body_type) OVERRIDING SYSTEM VALUE VALUES (1, '1.6 бензин, АКПП', 'Япония', 2020, 'Toyota', 'Camry', 'sedan');
INSERT INTO taxi.car_model (model_id, technical_specs, country_of_production, production_year, make, model_name, body_type) OVERRIDING SYSTEM VALUE VALUES (2, '1.4 бензин, АКПП', 'Германия', 2019, 'Volkswagen', 'Polo', 'sedan');
INSERT INTO taxi.car_model (model_id, technical_specs, country_of_production, production_year, make, model_name, body_type) OVERRIDING SYSTEM VALUE VALUES (3, '2.0 бензин, АКПП', 'Корея', 2021, 'Kia', 'K5', 'sedan');


--
-- TOC entry 3873 (class 0 OID 16436)
-- Dependencies: 233
-- Data for Name: employee; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.employee (employee_id, employee_category_id, employee_position_code, phone, address, full_name, passport_data, status) OVERRIDING SYSTEM VALUE VALUES (1, 1, 1, '+79991110001', 'Санкт-Петербург, Невский пр., 10', 'Дмитрий Волков', '4010 123456', 'active');
INSERT INTO taxi.employee (employee_id, employee_category_id, employee_position_code, phone, address, full_name, passport_data, status) OVERRIDING SYSTEM VALUE VALUES (2, 1, 2, '+79991110002', 'Санкт-Петербург, Лиговский пр., 25', 'Артем Кузнецов', '4011 654321', 'active');
INSERT INTO taxi.employee (employee_id, employee_category_id, employee_position_code, phone, address, full_name, passport_data, status) OVERRIDING SYSTEM VALUE VALUES (3, 2, 3, '+79991110003', 'Санкт-Петербург, ул. Марата, 8', 'Ольга Романова', '4012 112233', 'active');


--
-- TOC entry 3869 (class 0 OID 16422)
-- Dependencies: 229
-- Data for Name: employee_category; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.employee_category (employee_category_id, category_name, description) OVERRIDING SYSTEM VALUE VALUES (1, 'driver', 'Водитель такси');
INSERT INTO taxi.employee_category (employee_category_id, category_name, description) OVERRIDING SYSTEM VALUE VALUES (2, 'administrator', 'Оператор и администратор заказов');


--
-- TOC entry 3875 (class 0 OID 16443)
-- Dependencies: 235
-- Data for Name: employee_position; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.employee_position (contract_number, employee_id, position_id, start_date, end_date, contract_type) OVERRIDING SYSTEM VALUE VALUES (1, 1, 1, '2024-01-10', NULL, 'Основной');
INSERT INTO taxi.employee_position (contract_number, employee_id, position_id, start_date, end_date, contract_type) OVERRIDING SYSTEM VALUE VALUES (2, 2, 3, '2024-03-15', NULL, 'Основной');
INSERT INTO taxi.employee_position (contract_number, employee_id, position_id, start_date, end_date, contract_type) OVERRIDING SYSTEM VALUE VALUES (3, 3, 2, '2024-02-01', NULL, 'Основной');


--
-- TOC entry 3881 (class 0 OID 16464)
-- Dependencies: 241
-- Data for Name: employee_work_schedule; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.employee_work_schedule (work_schedule_id, employee_id, car_id, work_date, start_time, end_time, status) OVERRIDING SYSTEM VALUE VALUES (1, 1, 1, '2026-03-29', '2026-03-29 08:00:00', '2026-03-29 20:00:00', 'planned');
INSERT INTO taxi.employee_work_schedule (work_schedule_id, employee_id, car_id, work_date, start_time, end_time, status) OVERRIDING SYSTEM VALUE VALUES (2, 2, 2, '2026-03-29', '2026-03-29 09:00:00', '2026-03-29 21:00:00', 'working');


--
-- TOC entry 3883 (class 0 OID 16471)
-- Dependencies: 243
-- Data for Name: orders; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.orders (order_id, passenger_id, car_id, driver_id, tariff_id, administrator_id, card_id, order_status, call_datetime, actual_pickup_time, planned_pickup_time, pickup_address, destination_address, distance_km, order_cost, payment_type, client_review) OVERRIDING SYSTEM VALUE VALUES (1, 1, 1, 1, 1, 3, 1, 'done', '2026-03-29 08:15:00', '2026-03-29 08:25:00', '2026-03-29 08:30:00', 'Невский пр., 15', 'Московский вокзал', 6.50, 220.00, 'card', 'Поездка прошла отлично');
INSERT INTO taxi.orders (order_id, passenger_id, car_id, driver_id, tariff_id, administrator_id, card_id, order_status, call_datetime, actual_pickup_time, planned_pickup_time, pickup_address, destination_address, distance_km, order_cost, payment_type, client_review) OVERRIDING SYSTEM VALUE VALUES (2, 2, 2, 2, 2, 3, 2, 'new', '2026-03-29 12:05:00', NULL, '2026-03-29 12:20:00', 'ул. Рубинштейна, 12', 'Аэропорт Пулково', 18.00, 680.00, 'card', NULL);
INSERT INTO taxi.orders (order_id, passenger_id, car_id, driver_id, tariff_id, administrator_id, card_id, order_status, call_datetime, actual_pickup_time, planned_pickup_time, pickup_address, destination_address, distance_km, order_cost, payment_type, client_review) OVERRIDING SYSTEM VALUE VALUES (3, 3, 1, 1, 1, 3, 3, 'done', '2026-03-29 15:40:00', '2026-03-29 15:50:00', '2026-03-29 15:55:00', 'Лиговский пр., 50', 'ИТМО, Кронверкский пр., 49', 4.20, 160.00, 'card', 'Водитель приехал быстро');


--
-- TOC entry 3861 (class 0 OID 16394)
-- Dependencies: 221
-- Data for Name: passenger; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.passenger (passenger_id, full_name, phone, email, notes) OVERRIDING SYSTEM VALUE VALUES (1, 'Иван Петров', '+79990000001', 'ivan.petrov@mail.ru', 'частый клиент');
INSERT INTO taxi.passenger (passenger_id, full_name, phone, email, notes) OVERRIDING SYSTEM VALUE VALUES (2, 'Мария Соколова', '+79990000002', 'maria.sokolova@mail.ru', 'предпочитает оплату картой');
INSERT INTO taxi.passenger (passenger_id, full_name, phone, email, notes) OVERRIDING SYSTEM VALUE VALUES (3, 'Алексей Смирнов', '+79990000003', 'alex.smirnov@mail.ru', 'нуждается в детском кресле');


--
-- TOC entry 3863 (class 0 OID 16401)
-- Dependencies: 223
-- Data for Name: payment_card; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.payment_card (card_id, passenger_id, card_number, cvv, expiration_date, holder_name) OVERRIDING SYSTEM VALUE VALUES (1, 1, '1111222233334444', 123, '2028-12-31', 'IVAN PETROV');
INSERT INTO taxi.payment_card (card_id, passenger_id, card_number, cvv, expiration_date, holder_name) OVERRIDING SYSTEM VALUE VALUES (2, 2, '5555666677778888', 456, '2027-11-30', 'MARIA SOKOLOVA');
INSERT INTO taxi.payment_card (card_id, passenger_id, card_number, cvv, expiration_date, holder_name) OVERRIDING SYSTEM VALUE VALUES (3, 3, '9999000011112222', 789, '2029-06-30', 'ALEXEY SMIRNOV');


--
-- TOC entry 3871 (class 0 OID 16429)
-- Dependencies: 231
-- Data for Name: position; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi."position" (position_id, position_name, duties_description) OVERRIDING SYSTEM VALUE VALUES (1, 'Водитель', 'Выполняет пассажирские перевозки');
INSERT INTO taxi."position" (position_id, position_name, duties_description) OVERRIDING SYSTEM VALUE VALUES (2, 'Администратор', 'Обрабатывает входящие заказы');
INSERT INTO taxi."position" (position_id, position_name, duties_description) OVERRIDING SYSTEM VALUE VALUES (3, 'Старший водитель', 'Контролирует водителей и выполняет перевозки');


--
-- TOC entry 3865 (class 0 OID 16408)
-- Dependencies: 225
-- Data for Name: tariff; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.tariff (tariff_id, car_class, price_per_km, tariff_name, waiting_fee_per_minute) OVERRIDING SYSTEM VALUE VALUES (1, 'economy', 25.00, 'Эконом', 5.00);
INSERT INTO taxi.tariff (tariff_id, car_class, price_per_km, tariff_name, waiting_fee_per_minute) OVERRIDING SYSTEM VALUE VALUES (2, 'comfort', 35.00, 'Комфорт', 7.00);
INSERT INTO taxi.tariff (tariff_id, car_class, price_per_km, tariff_name, waiting_fee_per_minute) OVERRIDING SYSTEM VALUE VALUES (3, 'business', 50.00, 'Бизнес', 10.00);


--
-- TOC entry 3867 (class 0 OID 16415)
-- Dependencies: 227
-- Data for Name: tariff_surcharge; Type: TABLE DATA; Schema: taxi; Owner: admin
--

INSERT INTO taxi.tariff_surcharge (tariff_surcharge_id, tariff_id, start_time, end_time, comment_text, km_price_coefficient) OVERRIDING SYSTEM VALUE VALUES (1, 1, '2026-03-29 07:00:00', '2026-03-29 10:00:00', 'Утренний час пик', 1.20);
INSERT INTO taxi.tariff_surcharge (tariff_surcharge_id, tariff_id, start_time, end_time, comment_text, km_price_coefficient) OVERRIDING SYSTEM VALUE VALUES (2, 2, '2026-03-29 18:00:00', '2026-03-29 21:00:00', 'Вечерний час пик', 1.30);


--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 238
-- Name: car_car_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.car_car_id_seq', 3, true);


--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 236
-- Name: car_model_model_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.car_model_model_id_seq', 3, true);


--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 228
-- Name: employee_category_employee_category_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.employee_category_employee_category_id_seq', 2, true);


--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 232
-- Name: employee_employee_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.employee_employee_id_seq', 3, true);


--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 234
-- Name: employee_position_contract_number_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.employee_position_contract_number_seq', 3, true);


--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 240
-- Name: employee_work_schedule_work_schedule_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.employee_work_schedule_work_schedule_id_seq', 2, true);


--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 242
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.orders_order_id_seq', 3, true);


--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 220
-- Name: passenger_passenger_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.passenger_passenger_id_seq', 3, true);


--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 222
-- Name: payment_card_card_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.payment_card_card_id_seq', 3, true);


--
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 230
-- Name: position_position_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.position_position_id_seq', 3, true);


--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 226
-- Name: tariff_surcharge_tariff_surcharge_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.tariff_surcharge_tariff_surcharge_id_seq', 2, true);


--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 224
-- Name: tariff_tariff_id_seq; Type: SEQUENCE SET; Schema: taxi; Owner: admin
--

SELECT pg_catalog.setval('taxi.tariff_tariff_id_seq', 3, true);


--
-- TOC entry 3689 (class 2606 OID 16455)
-- Name: car_model car_model_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.car_model
    ADD CONSTRAINT car_model_pkey PRIMARY KEY (model_id);


--
-- TOC entry 3691 (class 2606 OID 16462)
-- Name: car car_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.car
    ADD CONSTRAINT car_pkey PRIMARY KEY (car_id);


--
-- TOC entry 3693 (class 2606 OID 16486)
-- Name: car car_plate_number_uq; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.car
    ADD CONSTRAINT car_plate_number_uq UNIQUE (plate_number);


--
-- TOC entry 3677 (class 2606 OID 16488)
-- Name: employee_category employee_category_name_uq; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.employee_category
    ADD CONSTRAINT employee_category_name_uq UNIQUE (category_name);


--
-- TOC entry 3679 (class 2606 OID 16427)
-- Name: employee_category employee_category_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.employee_category
    ADD CONSTRAINT employee_category_pkey PRIMARY KEY (employee_category_id);


--
-- TOC entry 3685 (class 2606 OID 16441)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 3687 (class 2606 OID 16448)
-- Name: employee_position employee_position_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.employee_position
    ADD CONSTRAINT employee_position_pkey PRIMARY KEY (contract_number);


--
-- TOC entry 3695 (class 2606 OID 16469)
-- Name: employee_work_schedule employee_work_schedule_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.employee_work_schedule
    ADD CONSTRAINT employee_work_schedule_pkey PRIMARY KEY (work_schedule_id);


--
-- TOC entry 3697 (class 2606 OID 16476)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 3660 (class 2606 OID 16480)
-- Name: passenger passenger_email_uq; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.passenger
    ADD CONSTRAINT passenger_email_uq UNIQUE (email);


--
-- TOC entry 3662 (class 2606 OID 16478)
-- Name: passenger passenger_phone_uq; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.passenger
    ADD CONSTRAINT passenger_phone_uq UNIQUE (phone);


--
-- TOC entry 3664 (class 2606 OID 16399)
-- Name: passenger passenger_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.passenger
    ADD CONSTRAINT passenger_pkey PRIMARY KEY (passenger_id);


--
-- TOC entry 3667 (class 2606 OID 16482)
-- Name: payment_card payment_card_number_uq; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.payment_card
    ADD CONSTRAINT payment_card_number_uq UNIQUE (card_number);


--
-- TOC entry 3669 (class 2606 OID 16406)
-- Name: payment_card payment_card_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.payment_card
    ADD CONSTRAINT payment_card_pkey PRIMARY KEY (card_id);


--
-- TOC entry 3681 (class 2606 OID 16490)
-- Name: position position_name_uq; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi."position"
    ADD CONSTRAINT position_name_uq UNIQUE (position_name);


--
-- TOC entry 3683 (class 2606 OID 16434)
-- Name: position position_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (position_id);


--
-- TOC entry 3671 (class 2606 OID 16484)
-- Name: tariff tariff_name_uq; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.tariff
    ADD CONSTRAINT tariff_name_uq UNIQUE (tariff_name);


--
-- TOC entry 3673 (class 2606 OID 16413)
-- Name: tariff tariff_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.tariff
    ADD CONSTRAINT tariff_pkey PRIMARY KEY (tariff_id);


--
-- TOC entry 3675 (class 2606 OID 16420)
-- Name: tariff_surcharge tariff_surcharge_pkey; Type: CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.tariff_surcharge
    ADD CONSTRAINT tariff_surcharge_pkey PRIMARY KEY (tariff_surcharge_id);


--
-- TOC entry 3665 (class 1259 OID 16511)
-- Name: fki_fk_payment_card_passenger; Type: INDEX; Schema: taxi; Owner: admin
--

CREATE INDEX fki_fk_payment_card_passenger ON taxi.payment_card USING btree (passenger_id);


--
-- TOC entry 3703 (class 2606 OID 16537)
-- Name: car fk_car_model; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.car
    ADD CONSTRAINT fk_car_model FOREIGN KEY (model_id) REFERENCES taxi.car_model(model_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3704 (class 2606 OID 16532)
-- Name: car fk_car_owner; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.car
    ADD CONSTRAINT fk_car_owner FOREIGN KEY (owner_id) REFERENCES taxi.employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3700 (class 2606 OID 16517)
-- Name: employee fk_employee_category; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.employee
    ADD CONSTRAINT fk_employee_category FOREIGN KEY (employee_category_id) REFERENCES taxi.employee_category(employee_category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3701 (class 2606 OID 16522)
-- Name: employee_position fk_employee_position_employee; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.employee_position
    ADD CONSTRAINT fk_employee_position_employee FOREIGN KEY (employee_id) REFERENCES taxi.employee(employee_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3702 (class 2606 OID 16527)
-- Name: employee_position fk_employee_position_position; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.employee_position
    ADD CONSTRAINT fk_employee_position_position FOREIGN KEY (position_id) REFERENCES taxi."position"(position_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3705 (class 2606 OID 16547)
-- Name: employee_work_schedule fk_employee_work_schedule_car; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.employee_work_schedule
    ADD CONSTRAINT fk_employee_work_schedule_car FOREIGN KEY (car_id) REFERENCES taxi.car(car_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3706 (class 2606 OID 16542)
-- Name: employee_work_schedule fk_employee_work_schedule_employee; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.employee_work_schedule
    ADD CONSTRAINT fk_employee_work_schedule_employee FOREIGN KEY (employee_id) REFERENCES taxi.employee(employee_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3707 (class 2606 OID 16567)
-- Name: orders fk_orders_administrator; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT fk_orders_administrator FOREIGN KEY (administrator_id) REFERENCES taxi.employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3708 (class 2606 OID 16557)
-- Name: orders fk_orders_car; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT fk_orders_car FOREIGN KEY (car_id) REFERENCES taxi.car(car_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3709 (class 2606 OID 16577)
-- Name: orders fk_orders_card; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT fk_orders_card FOREIGN KEY (card_id) REFERENCES taxi.payment_card(card_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3710 (class 2606 OID 16562)
-- Name: orders fk_orders_driver; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT fk_orders_driver FOREIGN KEY (driver_id) REFERENCES taxi.employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3711 (class 2606 OID 16552)
-- Name: orders fk_orders_passenger; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT fk_orders_passenger FOREIGN KEY (passenger_id) REFERENCES taxi.passenger(passenger_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3712 (class 2606 OID 16572)
-- Name: orders fk_orders_tariff; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.orders
    ADD CONSTRAINT fk_orders_tariff FOREIGN KEY (tariff_id) REFERENCES taxi.tariff(tariff_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3698 (class 2606 OID 16582)
-- Name: payment_card fk_payment_card_passenger; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.payment_card
    ADD CONSTRAINT fk_payment_card_passenger FOREIGN KEY (passenger_id) REFERENCES taxi.passenger(passenger_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3699 (class 2606 OID 16512)
-- Name: tariff_surcharge fk_tariff_surcharge_tariff; Type: FK CONSTRAINT; Schema: taxi; Owner: admin
--

ALTER TABLE ONLY taxi.tariff_surcharge
    ADD CONSTRAINT fk_tariff_surcharge_tariff FOREIGN KEY (tariff_id) REFERENCES taxi.tariff(tariff_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-03-29 17:36:33 MSK

--
-- PostgreSQL database dump complete
--

\unrestrict 4MXN32Sr7RW4Jy9Uh3aBEVCAOjQdA01CjSRtWc71aIvyVXaiMZNYq4Bm4V3f0a8

