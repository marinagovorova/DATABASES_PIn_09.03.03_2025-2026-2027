--
-- PostgreSQL database dump
--

\restrict dZbS5IeEb2K4qr6iRmj9bc5ZMY97JYRnXPVftKhCAYbKVnLSztnZwBuiqDYyvG7

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

-- Started on 2026-03-27 13:58:12 MSK

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
-- TOC entry 3831 (class 1262 OID 16398)
-- Name: lab3_bd; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE lab3_bd WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE lab3_bd OWNER TO postgres;

\unrestrict dZbS5IeEb2K4qr6iRmj9bc5ZMY97JYRnXPVftKhCAYbKVnLSztnZwBuiqDYyvG7
\connect lab3_bd
\restrict dZbS5IeEb2K4qr6iRmj9bc5ZMY97JYRnXPVftKhCAYbKVnLSztnZwBuiqDYyvG7

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
-- TOC entry 6 (class 2615 OID 16399)
-- Name: hotel_schema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hotel_schema;


ALTER SCHEMA hotel_schema OWNER TO postgres;

--
-- TOC entry 3832 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA hotel_schema; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA hotel_schema IS 'Схема для БД Отель';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 16602)
-- Name: additional_services; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.additional_services (
    "id_удобства" integer NOT NULL,
    "id_бронирования" integer NOT NULL
);


ALTER TABLE hotel_schema.additional_services OWNER TO postgres;

--
-- TOC entry 3833 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE additional_services; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.additional_services IS 'Дополнительные услуги';


--
-- TOC entry 218 (class 1259 OID 16414)
-- Name: amenity; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.amenity (
    "id_удобства" integer NOT NULL,
    "название" character varying(50) NOT NULL,
    "описание" character varying(255),
    "количество" integer NOT NULL
);


ALTER TABLE hotel_schema.amenity OWNER TO postgres;

--
-- TOC entry 3834 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE amenity; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.amenity IS 'Удобство';


--
-- TOC entry 226 (class 1259 OID 16520)
-- Name: amenity_price; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.amenity_price (
    "id_цены_удобства" integer NOT NULL,
    "id_удобства" integer NOT NULL,
    "цена_за_сутки" numeric(8,2) NOT NULL,
    "дата_начала" date NOT NULL,
    "дата_конца" date NOT NULL,
    CONSTRAINT check_amenity_price_dates CHECK (("дата_конца" >= "дата_начала")),
    CONSTRAINT check_amenity_price_positive CHECK (("цена_за_сутки" > (0)::numeric))
);


ALTER TABLE hotel_schema.amenity_price OWNER TO postgres;

--
-- TOC entry 3835 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE amenity_price; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.amenity_price IS 'Цена удобств';


--
-- TOC entry 228 (class 1259 OID 16544)
-- Name: booking; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.booking (
    "id_бронирования" integer NOT NULL,
    "id_отеля" integer NOT NULL,
    "id_паспорта" integer NOT NULL,
    "id_комнаты" integer NOT NULL,
    "номер_договора" integer NOT NULL,
    "дата_бронирования" date NOT NULL,
    "дата_оплаты" date NOT NULL,
    "план_дата_заезда" date NOT NULL,
    "план_дата_выезда" date NOT NULL,
    "факт_дата_заезда" date,
    "факт_дата_выезда" date,
    "предоплата" numeric(10,2) NOT NULL,
    "статус_оплаты" character varying(20) NOT NULL,
    "статус_отмены" character varying(20) NOT NULL,
    "статус_отмены_оплаты" character varying(20) NOT NULL,
    CONSTRAINT check_booking_cancel_status CHECK ((("статус_отмены")::text = ANY ((ARRAY['активен'::character varying, 'отменен'::character varying])::text[]))),
    CONSTRAINT check_booking_dates CHECK (("план_дата_выезда" >= "план_дата_заезда")),
    CONSTRAINT check_booking_payment_cancel CHECK ((("статус_отмены_оплаты")::text = ANY ((ARRAY['отменена'::character varying, 'не отменена'::character varying])::text[]))),
    CONSTRAINT check_booking_payment_status CHECK ((("статус_оплаты")::text = ANY ((ARRAY['оплачено'::character varying, 'не оплачено'::character varying, 'частично'::character varying])::text[]))),
    CONSTRAINT check_booking_prepayment CHECK (("предоплата" >= (0)::numeric))
);


ALTER TABLE hotel_schema.booking OWNER TO postgres;

--
-- TOC entry 3836 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE booking; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.booking IS 'Бронирование';


--
-- TOC entry 229 (class 1259 OID 16574)
-- Name: cleaning; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.cleaning (
    "id_уборки" integer NOT NULL,
    "id_комнаты" integer NOT NULL,
    "номер_договора" integer NOT NULL,
    "статус_уборки" character varying(15) NOT NULL,
    "дата_время_уборки" timestamp without time zone NOT NULL,
    CONSTRAINT check_cleaning_status CHECK ((("статус_уборки")::text = ANY ((ARRAY['запланирована'::character varying, 'выполнена'::character varying, 'отменена'::character varying])::text[])))
);


ALTER TABLE hotel_schema.cleaning OWNER TO postgres;

--
-- TOC entry 3837 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE cleaning; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.cleaning IS 'Уборка';


--
-- TOC entry 223 (class 1259 OID 16479)
-- Name: employment_contract; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.employment_contract (
    "номер_договора" integer NOT NULL,
    "id_паспорта" integer NOT NULL,
    "дата_заключения" date NOT NULL,
    "дата_окончания" date,
    "вид_найма" character varying(15) NOT NULL,
    "условия_договора" character varying(255) NOT NULL
);


ALTER TABLE hotel_schema.employment_contract OWNER TO postgres;

--
-- TOC entry 3838 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE employment_contract; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.employment_contract IS 'Договор найма';


--
-- TOC entry 216 (class 1259 OID 16400)
-- Name: hotel; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.hotel (
    "id_отеля" integer NOT NULL,
    "город" character varying(50) NOT NULL,
    "адрес" character varying(150) NOT NULL,
    "почта" character varying(50) NOT NULL,
    "телефон" character varying(12) NOT NULL
);


ALTER TABLE hotel_schema.hotel OWNER TO postgres;

--
-- TOC entry 3839 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE hotel; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.hotel IS 'Информация об отелях сети';


--
-- TOC entry 221 (class 1259 OID 16435)
-- Name: passport; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.passport (
    "id_паспорта" integer NOT NULL,
    "id_персоны" integer NOT NULL,
    "дата_выдачи" date NOT NULL,
    "кем_выдан" character varying(255) NOT NULL,
    "место_выдачи" character varying(255) NOT NULL,
    "серия_номер" character varying(20) NOT NULL,
    "дата_рождения" date NOT NULL
);


ALTER TABLE hotel_schema.passport OWNER TO postgres;

--
-- TOC entry 3840 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE passport; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.passport IS 'Паспорт';


--
-- TOC entry 220 (class 1259 OID 16428)
-- Name: person; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.person (
    "id_персоны" integer NOT NULL,
    "фамилия" character varying(50) NOT NULL,
    "имя" character varying(50) NOT NULL,
    "отчество" character varying(50),
    "адрес_проживания" character varying(150) NOT NULL,
    "почта" character varying(50)
);


ALTER TABLE hotel_schema.person OWNER TO postgres;

--
-- TOC entry 3841 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE person; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.person IS 'Персона';


--
-- TOC entry 217 (class 1259 OID 16407)
-- Name: position; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema."position" (
    "id_должности" integer NOT NULL,
    "название" character varying(50) NOT NULL,
    "базовый_оклад" integer NOT NULL,
    "количество_ставок" integer NOT NULL
);


ALTER TABLE hotel_schema."position" OWNER TO postgres;

--
-- TOC entry 3842 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE "position"; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema."position" IS 'Должность сотрудника';


--
-- TOC entry 225 (class 1259 OID 16509)
-- Name: price; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.price (
    "id_цены" integer NOT NULL,
    "id_типа_комнаты" integer NOT NULL,
    "цена_за_сутки" numeric(8,2) NOT NULL,
    "дата_начала" date NOT NULL,
    "дата_конца" date NOT NULL,
    CONSTRAINT check_price_positive CHECK (("цена_за_сутки" > (0)::numeric))
);


ALTER TABLE hotel_schema.price OWNER TO postgres;

--
-- TOC entry 3843 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE price; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.price IS 'Цена';


--
-- TOC entry 227 (class 1259 OID 16532)
-- Name: promotion; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.promotion (
    "id_акции" integer NOT NULL,
    "id_типа_комнаты" integer NOT NULL,
    "скидка" numeric(5,2) NOT NULL,
    "дата_начала" date NOT NULL,
    "дата_конца" date NOT NULL,
    "условия" character varying(255) NOT NULL,
    CONSTRAINT check_discount_range CHECK ((("скидка" >= (0)::numeric) AND ("скидка" <= (100)::numeric))),
    CONSTRAINT check_promotion_dates CHECK (("дата_конца" >= "дата_начала"))
);


ALTER TABLE hotel_schema.promotion OWNER TO postgres;

--
-- TOC entry 3844 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE promotion; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.promotion IS 'Акция';


--
-- TOC entry 222 (class 1259 OID 16459)
-- Name: room; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.room (
    "id_комнаты" integer NOT NULL,
    "id_отеля" integer NOT NULL,
    "id_типа_комнаты" integer NOT NULL,
    "номер_комнаты" integer NOT NULL,
    "статус_уборки" character varying(30) NOT NULL,
    "статус_состояния" character varying(30) NOT NULL,
    "статус_занятости" character varying(30) NOT NULL
);


ALTER TABLE hotel_schema.room OWNER TO postgres;

--
-- TOC entry 3845 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE room; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.room IS 'Комната';


--
-- TOC entry 224 (class 1259 OID 16491)
-- Name: room_amenities; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.room_amenities (
    "id_удобства" integer NOT NULL,
    "id_типа_комнаты" integer NOT NULL
);


ALTER TABLE hotel_schema.room_amenities OWNER TO postgres;

--
-- TOC entry 3846 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE room_amenities; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.room_amenities IS 'Состав удобств';


--
-- TOC entry 219 (class 1259 OID 16421)
-- Name: room_type; Type: TABLE; Schema: hotel_schema; Owner: postgres
--

CREATE TABLE hotel_schema.room_type (
    "id_типа_комнаты" integer NOT NULL,
    "название" character varying(50) NOT NULL,
    "количество_мест" integer NOT NULL
);


ALTER TABLE hotel_schema.room_type OWNER TO postgres;

--
-- TOC entry 3847 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE room_type; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON TABLE hotel_schema.room_type IS 'Тип комнаты';


--
-- TOC entry 3825 (class 0 OID 16602)
-- Dependencies: 230
-- Data for Name: additional_services; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.additional_services ("id_удобства", "id_бронирования") FROM stdin;
2	1
3	1
2	2
\.


--
-- TOC entry 3813 (class 0 OID 16414)
-- Dependencies: 218
-- Data for Name: amenity; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.amenity ("id_удобства", "название", "описание", "количество") FROM stdin;
1	Wi-Fi	Бесплатный интернет	100
2	Кондиционер	Сплит-система	50
3	Мини-бар	Холодильник с напитками	30
\.


--
-- TOC entry 3821 (class 0 OID 16520)
-- Dependencies: 226
-- Data for Name: amenity_price; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.amenity_price ("id_цены_удобства", "id_удобства", "цена_за_сутки", "дата_начала", "дата_конца") FROM stdin;
1	1	100.00	2024-01-01	2024-12-31
2	2	500.00	2024-01-01	2024-12-31
3	3	300.00	2024-01-01	2024-12-31
\.


--
-- TOC entry 3823 (class 0 OID 16544)
-- Dependencies: 228
-- Data for Name: booking; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.booking ("id_бронирования", "id_отеля", "id_паспорта", "id_комнаты", "номер_договора", "дата_бронирования", "дата_оплаты", "план_дата_заезда", "план_дата_выезда", "факт_дата_заезда", "факт_дата_выезда", "предоплата", "статус_оплаты", "статус_отмены", "статус_отмены_оплаты") FROM stdin;
1	1	2	2	2	2024-05-01	2024-05-02	2024-06-01	2024-06-05	\N	\N	8000.00	частично	активен	не отменена
2	2	3	3	3	2024-04-15	2024-04-16	2024-05-10	2024-05-15	2024-05-10	\N	14000.00	оплачено	активен	не отменена
\.


--
-- TOC entry 3824 (class 0 OID 16574)
-- Dependencies: 229
-- Data for Name: cleaning; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.cleaning ("id_уборки", "id_комнаты", "номер_договора", "статус_уборки", "дата_время_уборки") FROM stdin;
1	1	1	выполнена	2024-05-20 10:00:00
2	2	1	запланирована	2024-05-21 11:00:00
3	3	2	выполнена	2024-05-20 14:00:00
\.


--
-- TOC entry 3818 (class 0 OID 16479)
-- Dependencies: 223
-- Data for Name: employment_contract; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.employment_contract ("номер_договора", "id_паспорта", "дата_заключения", "дата_окончания", "вид_найма", "условия_договора") FROM stdin;
1	1	2023-01-10	\N	постоянный	Полная занятость
2	2	2024-06-01	2024-09-30	сезонный	Летний сезон
3	3	2023-05-15	\N	постоянный	Полная занятость
\.


--
-- TOC entry 3811 (class 0 OID 16400)
-- Dependencies: 216
-- Data for Name: hotel; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.hotel ("id_отеля", "город", "адрес", "почта", "телефон") FROM stdin;
1	Санкт-Петербург	Невский пр., 10	hotel1@otel.ru	+79991234567
2	Москва	Тверская ул., 5	hotel2@otel.ru	+79997654321
\.


--
-- TOC entry 3816 (class 0 OID 16435)
-- Dependencies: 221
-- Data for Name: passport; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.passport ("id_паспорта", "id_персоны", "дата_выдачи", "кем_выдан", "место_выдачи", "серия_номер", "дата_рождения") FROM stdin;
1	1	2020-01-15	УФМС СПб	Санкт-Петербург	1234 567890	1990-05-10
2	2	2019-03-20	УФМС Москва	Москва	2345 678901	1988-08-15
3	3	2021-06-10	УФМС СПб	Санкт-Петербург	3456 789012	1995-12-01
\.


--
-- TOC entry 3815 (class 0 OID 16428)
-- Dependencies: 220
-- Data for Name: person; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.person ("id_персоны", "фамилия", "имя", "отчество", "адрес_проживания", "почта") FROM stdin;
1	Иванов	Иван	Иванович	СПб, ул. Ленина 1	ivanov@mail.ru
2	Петрова	Анна	Сергеевна	Москва, ул. Пушкина 5	petrova@mail.ru
3	Сидоров	Петр	Алексеевич	СПб, Невский 20	sidorov@mail.ru
\.


--
-- TOC entry 3812 (class 0 OID 16407)
-- Dependencies: 217
-- Data for Name: position; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema."position" ("id_должности", "название", "базовый_оклад", "количество_ставок") FROM stdin;
1	Горничная	35000	5
2	Администратор	45000	3
3	Менеджер	60000	2
\.


--
-- TOC entry 3820 (class 0 OID 16509)
-- Dependencies: 225
-- Data for Name: price; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.price ("id_цены", "id_типа_комнаты", "цена_за_сутки", "дата_начала", "дата_конца") FROM stdin;
1	1	2500.00	2024-01-01	2024-12-31
2	2	4000.00	2024-01-01	2024-12-31
3	3	7000.00	2024-01-01	2024-12-31
\.


--
-- TOC entry 3822 (class 0 OID 16532)
-- Dependencies: 227
-- Data for Name: promotion; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.promotion ("id_акции", "id_типа_комнаты", "скидка", "дата_начала", "дата_конца", "условия") FROM stdin;
1	1	10.00	2024-01-01	2024-03-31	Раннее бронирование
2	3	15.00	2024-06-01	2024-08-31	Летняя скидка
\.


--
-- TOC entry 3817 (class 0 OID 16459)
-- Dependencies: 222
-- Data for Name: room; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.room ("id_комнаты", "id_отеля", "id_типа_комнаты", "номер_комнаты", "статус_уборки", "статус_состояния", "статус_занятости") FROM stdin;
1	1	1	101	убран	готов	свободен
2	1	2	102	убран	готов	забронирован
3	2	3	201	не убран	готов	занят
\.


--
-- TOC entry 3819 (class 0 OID 16491)
-- Dependencies: 224
-- Data for Name: room_amenities; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.room_amenities ("id_удобства", "id_типа_комнаты") FROM stdin;
1	1
1	2
2	2
1	3
2	3
3	3
\.


--
-- TOC entry 3814 (class 0 OID 16421)
-- Dependencies: 219
-- Data for Name: room_type; Type: TABLE DATA; Schema: hotel_schema; Owner: postgres
--

COPY hotel_schema.room_type ("id_типа_комнаты", "название", "количество_мест") FROM stdin;
1	эконом	2
2	стандарт	3
3	люкс	4
\.


--
-- TOC entry 3626 (class 2606 OID 16420)
-- Name: amenity amenity_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.amenity
    ADD CONSTRAINT amenity_pkey PRIMARY KEY ("id_удобства");


--
-- TOC entry 3642 (class 2606 OID 16526)
-- Name: amenity_price amenity_price_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.amenity_price
    ADD CONSTRAINT amenity_price_pkey PRIMARY KEY ("id_цены_удобства", "id_удобства", "дата_начала", "дата_конца", "цена_за_сутки");


--
-- TOC entry 3646 (class 2606 OID 16601)
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY ("id_бронирования");


--
-- TOC entry 3606 (class 2606 OID 16618)
-- Name: room check_status_занятости; Type: CHECK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE hotel_schema.room
    ADD CONSTRAINT "check_status_занятости" CHECK ((("статус_занятости")::text = ANY ((ARRAY['свободен'::character varying, 'занят'::character varying, 'забронирован'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 3607 (class 2606 OID 16620)
-- Name: room check_status_состояния; Type: CHECK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE hotel_schema.room
    ADD CONSTRAINT "check_status_состояния" CHECK ((("статус_состояния")::text = ANY ((ARRAY['новый'::character varying, 'ремонт'::character varying, 'готов'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 3608 (class 2606 OID 16619)
-- Name: room check_status_уборки; Type: CHECK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE hotel_schema.room
    ADD CONSTRAINT "check_status_уборки" CHECK ((("статус_уборки")::text = ANY ((ARRAY['убран'::character varying, 'не убран'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 3609 (class 2606 OID 16617)
-- Name: employment_contract check_вид_найма; Type: CHECK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE hotel_schema.employment_contract
    ADD CONSTRAINT "check_вид_найма" CHECK ((("вид_найма")::text = ANY ((ARRAY['сезонный'::character varying, 'постоянный'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 3648 (class 2606 OID 16579)
-- Name: cleaning cleaning_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.cleaning
    ADD CONSTRAINT cleaning_pkey PRIMARY KEY ("id_уборки", "id_комнаты", "статус_уборки", "дата_время_уборки", "номер_договора");


--
-- TOC entry 3636 (class 2606 OID 16485)
-- Name: employment_contract employment_contract_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.employment_contract
    ADD CONSTRAINT employment_contract_pkey PRIMARY KEY ("номер_договора");


--
-- TOC entry 3622 (class 2606 OID 16406)
-- Name: hotel hotel_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.hotel
    ADD CONSTRAINT hotel_pkey PRIMARY KEY ("id_отеля");


--
-- TOC entry 3632 (class 2606 OID 16441)
-- Name: passport passport_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY ("id_паспорта");


--
-- TOC entry 3630 (class 2606 OID 16434)
-- Name: person person_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.person
    ADD CONSTRAINT person_pkey PRIMARY KEY ("id_персоны");


--
-- TOC entry 3650 (class 2606 OID 16606)
-- Name: additional_services pk_additional_services; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.additional_services
    ADD CONSTRAINT pk_additional_services PRIMARY KEY ("id_удобства", "id_бронирования");


--
-- TOC entry 3638 (class 2606 OID 16495)
-- Name: room_amenities pk_room_amenities; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.room_amenities
    ADD CONSTRAINT pk_room_amenities PRIMARY KEY ("id_удобства", "id_типа_комнаты");


--
-- TOC entry 3624 (class 2606 OID 16413)
-- Name: position position_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY ("id_должности");


--
-- TOC entry 3640 (class 2606 OID 16514)
-- Name: price price_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.price
    ADD CONSTRAINT price_pkey PRIMARY KEY ("id_цены");


--
-- TOC entry 3644 (class 2606 OID 16538)
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY ("id_акции", "id_типа_комнаты", "скидка", "дата_конца", "условия", "дата_начала");


--
-- TOC entry 3634 (class 2606 OID 16465)
-- Name: room room_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.room
    ADD CONSTRAINT room_pkey PRIMARY KEY ("id_комнаты");


--
-- TOC entry 3628 (class 2606 OID 16427)
-- Name: room_type room_type_pkey; Type: CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.room_type
    ADD CONSTRAINT room_type_pkey PRIMARY KEY ("id_типа_комнаты");


--
-- TOC entry 3666 (class 2606 OID 16607)
-- Name: additional_services fk_add_services_amenity; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.additional_services
    ADD CONSTRAINT fk_add_services_amenity FOREIGN KEY ("id_удобства") REFERENCES hotel_schema.amenity("id_удобства") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3667 (class 2606 OID 16612)
-- Name: additional_services fk_add_services_booking; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.additional_services
    ADD CONSTRAINT fk_add_services_booking FOREIGN KEY ("id_бронирования") REFERENCES hotel_schema.booking("id_бронирования") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3655 (class 2606 OID 16496)
-- Name: room_amenities fk_amenities_convenience; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.room_amenities
    ADD CONSTRAINT fk_amenities_convenience FOREIGN KEY ("id_удобства") REFERENCES hotel_schema.amenity("id_удобства") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3656 (class 2606 OID 16501)
-- Name: room_amenities fk_amenities_room_type; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.room_amenities
    ADD CONSTRAINT fk_amenities_room_type FOREIGN KEY ("id_типа_комнаты") REFERENCES hotel_schema.room_type("id_типа_комнаты") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3658 (class 2606 OID 16527)
-- Name: amenity_price fk_amenity_price_convenience; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.amenity_price
    ADD CONSTRAINT fk_amenity_price_convenience FOREIGN KEY ("id_удобства") REFERENCES hotel_schema.amenity("id_удобства") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3660 (class 2606 OID 16569)
-- Name: booking fk_booking_contract; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.booking
    ADD CONSTRAINT fk_booking_contract FOREIGN KEY ("номер_договора") REFERENCES hotel_schema.employment_contract("номер_договора") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3661 (class 2606 OID 16554)
-- Name: booking fk_booking_hotel; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.booking
    ADD CONSTRAINT fk_booking_hotel FOREIGN KEY ("id_отеля") REFERENCES hotel_schema.hotel("id_отеля") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3662 (class 2606 OID 16559)
-- Name: booking fk_booking_passport; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.booking
    ADD CONSTRAINT fk_booking_passport FOREIGN KEY ("id_паспорта") REFERENCES hotel_schema.passport("id_паспорта") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3663 (class 2606 OID 16564)
-- Name: booking fk_booking_room; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.booking
    ADD CONSTRAINT fk_booking_room FOREIGN KEY ("id_комнаты") REFERENCES hotel_schema.room("id_комнаты") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3664 (class 2606 OID 16585)
-- Name: cleaning fk_cleaning_contract; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.cleaning
    ADD CONSTRAINT fk_cleaning_contract FOREIGN KEY ("номер_договора") REFERENCES hotel_schema.employment_contract("номер_договора") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3665 (class 2606 OID 16580)
-- Name: cleaning fk_cleaning_room; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.cleaning
    ADD CONSTRAINT fk_cleaning_room FOREIGN KEY ("id_комнаты") REFERENCES hotel_schema.room("id_комнаты") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3654 (class 2606 OID 16486)
-- Name: employment_contract fk_contract_passport; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.employment_contract
    ADD CONSTRAINT fk_contract_passport FOREIGN KEY ("id_паспорта") REFERENCES hotel_schema.passport("id_паспорта") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3651 (class 2606 OID 16442)
-- Name: passport fk_passport_person; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.passport
    ADD CONSTRAINT fk_passport_person FOREIGN KEY ("id_персоны") REFERENCES hotel_schema.person("id_персоны") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3848 (class 0 OID 0)
-- Dependencies: 3651
-- Name: CONSTRAINT fk_passport_person ON passport; Type: COMMENT; Schema: hotel_schema; Owner: postgres
--

COMMENT ON CONSTRAINT fk_passport_person ON hotel_schema.passport IS 'Ссылка на таблицу "Персона"';


--
-- TOC entry 3657 (class 2606 OID 16515)
-- Name: price fk_price_room_type; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.price
    ADD CONSTRAINT fk_price_room_type FOREIGN KEY ("id_типа_комнаты") REFERENCES hotel_schema.room_type("id_типа_комнаты") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3659 (class 2606 OID 16539)
-- Name: promotion fk_promotion_room_type; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.promotion
    ADD CONSTRAINT fk_promotion_room_type FOREIGN KEY ("id_типа_комнаты") REFERENCES hotel_schema.room_type("id_типа_комнаты") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3652 (class 2606 OID 16466)
-- Name: room fk_room_hotel; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.room
    ADD CONSTRAINT fk_room_hotel FOREIGN KEY ("id_отеля") REFERENCES hotel_schema.hotel("id_отеля") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3653 (class 2606 OID 16471)
-- Name: room fk_room_room_type; Type: FK CONSTRAINT; Schema: hotel_schema; Owner: postgres
--

ALTER TABLE ONLY hotel_schema.room
    ADD CONSTRAINT fk_room_room_type FOREIGN KEY ("id_типа_комнаты") REFERENCES hotel_schema.room_type("id_типа_комнаты") ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-03-27 13:58:12 MSK

--
-- PostgreSQL database dump complete
--

\unrestrict dZbS5IeEb2K4qr6iRmj9bc5ZMY97JYRnXPVftKhCAYbKVnLSztnZwBuiqDYyvG7

