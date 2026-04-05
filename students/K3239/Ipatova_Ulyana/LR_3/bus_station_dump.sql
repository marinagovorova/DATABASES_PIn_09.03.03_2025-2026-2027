--
-- PostgreSQL database dump
--

\restrict FHbmqtODi8RkMkAf6ltQWdLGCSMuvZMlIOSKgec5JqUbax9iG5N2kVwz5AaDBNK

-- Dumped from database version 15.17
-- Dumped by pg_dump version 15.17

-- Started on 2026-03-26 23:46:00

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
-- TOC entry 3432 (class 1262 OID 16398)
-- Name: bus_station; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE bus_station WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE bus_station OWNER TO postgres;

\unrestrict FHbmqtODi8RkMkAf6ltQWdLGCSMuvZMlIOSKgec5JqUbax9iG5N2kVwz5AaDBNK
\connect bus_station
\restrict FHbmqtODi8RkMkAf6ltQWdLGCSMuvZMlIOSKgec5JqUbax9iG5N2kVwz5AaDBNK

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
-- Name: bus_station_sch; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA bus_station_sch;


ALTER SCHEMA bus_station_sch OWNER TO postgres;

--
-- TOC entry 3433 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA bus_station_sch; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA bus_station_sch IS 'Схема БД Автовокзал ';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16417)
-- Name: avtobus; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.avtobus (
    "bus_ID" character(10) NOT NULL,
    year_of_release integer NOT NULL,
    "model_ID" integer NOT NULL,
    CONSTRAINT chk_year_of_release CHECK ((year_of_release > 1980))
);


ALTER TABLE bus_station_sch.avtobus OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16521)
-- Name: bilet; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.bilet (
    "ticket_ID" integer NOT NULL,
    place_number integer,
    purchase_date date NOT NULL,
    ticket_price numeric NOT NULL,
    purchase_method character(1) NOT NULL,
    "flight_ID" integer NOT NULL,
    "ID_passenger" integer NOT NULL,
    "stop_ID" integer NOT NULL,
    CONSTRAINT place_number_chk CHECK (((place_number IS NULL) OR (place_number > 0))),
    CONSTRAINT purchase_method_chk CHECK ((purchase_method = ANY (ARRAY['K'::bpchar, 'O'::bpchar]))),
    CONSTRAINT ticket_price_chk CHECK ((ticket_price > (0)::numeric))
);


ALTER TABLE bus_station_sch.bilet OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16503)
-- Name: ekipazh; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.ekipazh (
    "ID_crew" integer NOT NULL,
    "flight_ID" integer NOT NULL,
    "driver_ID" integer NOT NULL,
    driver_role character varying(20) NOT NULL,
    date_medical_examination date NOT NULL,
    medical_check_up_status character(1) NOT NULL,
    reason_non_admission character varying(200),
    CONSTRAINT driver_role_chk CHECK (((driver_role)::text = ANY ((ARRAY['первый водитель'::character varying, 'второй водитель'::character varying])::text[]))),
    CONSTRAINT medical_check_up_status_chk CHECK ((medical_check_up_status = ANY (ARRAY['P'::bpchar, 'N'::bpchar]))),
    CONSTRAINT reason_non_admission_chk CHECK ((((medical_check_up_status = 'N'::bpchar) AND (reason_non_admission IS NOT NULL)) OR ((medical_check_up_status = 'P'::bpchar) AND (reason_non_admission IS NULL))))
);


ALTER TABLE bus_station_sch.ekipazh OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16405)
-- Name: model_avtobusa; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.model_avtobusa (
    "model_ID" integer NOT NULL,
    bus_type character varying(30) NOT NULL,
    place_number integer NOT NULL,
    id_manufacturerr integer NOT NULL,
    CONSTRAINT chk_model_bus_type CHECK (((bus_type)::text = ANY ((ARRAY['городской'::character varying, 'междугородний'::character varying, 'туристический'::character varying])::text[]))),
    CONSTRAINT chk_model_place_number CHECK ((place_number > 0))
);


ALTER TABLE bus_station_sch.model_avtobusa OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16460)
-- Name: passazhir; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.passazhir (
    "ID_passenger" integer NOT NULL,
    last_name character varying(30) NOT NULL,
    name character varying(30) NOT NULL,
    middle_name character varying(30),
    "ID_passport" integer NOT NULL
);


ALTER TABLE bus_station_sch.passazhir OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16445)
-- Name: passportnye_dannye_passazhira; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.passportnye_dannye_passazhira (
    "ID_passport" integer NOT NULL,
    batch integer NOT NULL,
    number integer NOT NULL,
    date_of_issue date NOT NULL,
    authority_issued character varying(100) NOT NULL,
    registration character varying(100) NOT NULL
);


ALTER TABLE bus_station_sch.passportnye_dannye_passazhira OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16437)
-- Name: passportnye_dannye_voditelya; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.passportnye_dannye_voditelya (
    "ID_passport" integer NOT NULL,
    batch integer NOT NULL,
    number integer NOT NULL,
    date_of_issue date NOT NULL,
    authority_issued character varying(100) NOT NULL,
    registration character varying(100) NOT NULL
);


ALTER TABLE bus_station_sch.passportnye_dannye_voditelya OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16400)
-- Name: proizvoditel; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.proizvoditel (
    id_manufacturerr integer NOT NULL,
    name character varying(100) NOT NULL,
    country character varying(50) NOT NULL
);


ALTER TABLE bus_station_sch.proizvoditel OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16486)
-- Name: promezhutochnye_ostanovki; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.promezhutochnye_ostanovki (
    "stop_ID" integer NOT NULL,
    "flight_ID" integer NOT NULL,
    stop_number integer NOT NULL,
    arrival_time time without time zone,
    departure_time time without time zone,
    stop_time integer NOT NULL,
    "destination_ID" integer NOT NULL,
    travel_time time without time zone NOT NULL,
    CONSTRAINT stop_number_chk CHECK ((stop_number > 0)),
    CONSTRAINT stop_time_chk CHECK (((stop_time >= 0) OR (stop_time IS NULL)))
);


ALTER TABLE bus_station_sch.promezhutochnye_ostanovki OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16431)
-- Name: punkt_naznacheniya; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.punkt_naznacheniya (
    "destination_ID" integer NOT NULL,
    destination_name character varying(100) NOT NULL,
    distination_type character varying(30) NOT NULL,
    CONSTRAINT chk_distination_type CHECK (((distination_type)::text = ANY ((ARRAY['страна'::character varying, 'город'::character varying, 'посёлок'::character varying, 'деревня'::character varying, 'село'::character varying])::text[])))
);


ALTER TABLE bus_station_sch.punkt_naznacheniya OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16470)
-- Name: reis; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.reis (
    "flight_ID" integer NOT NULL,
    departure_date date NOT NULL,
    departure_time time without time zone NOT NULL,
    flight_type character(1) NOT NULL,
    "bus_ID" character(10) NOT NULL,
    "destination_ID" integer NOT NULL,
    CONSTRAINT flight_type_chk CHECK ((flight_type = ANY (ARRAY['R'::bpchar, 'D'::bpchar])))
);


ALTER TABLE bus_station_sch.reis OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16450)
-- Name: voditel; Type: TABLE; Schema: bus_station_sch; Owner: postgres
--

CREATE TABLE bus_station_sch.voditel (
    "driver_ID" integer NOT NULL,
    last_name character varying(30) NOT NULL,
    name character varying(30) NOT NULL,
    middle_name character varying(30),
    "ID_passport" integer NOT NULL
);


ALTER TABLE bus_station_sch.voditel OWNER TO postgres;

--
-- TOC entry 3417 (class 0 OID 16417)
-- Dependencies: 217
-- Data for Name: avtobus; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.avtobus VALUES ('BUS001    ', 2018, 1);
INSERT INTO bus_station_sch.avtobus VALUES ('BUS002    ', 2020, 2);
INSERT INTO bus_station_sch.avtobus VALUES ('BUS003    ', 2017, 3);


--
-- TOC entry 3426 (class 0 OID 16521)
-- Dependencies: 226
-- Data for Name: bilet; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.bilet VALUES (1, 12, '2025-04-05', 1500.00, 'K', 1, 1, 1);
INSERT INTO bus_station_sch.bilet VALUES (2, 18, '2025-04-07', 1500.00, 'O', 1, 2, 2);
INSERT INTO bus_station_sch.bilet VALUES (3, NULL, '2025-04-08', 1080.00, 'O', 2, 3, 4);


--
-- TOC entry 3425 (class 0 OID 16503)
-- Dependencies: 225
-- Data for Name: ekipazh; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.ekipazh VALUES (1, 1, 1, 'первый водитель', '2025-04-10', 'P', NULL);
INSERT INTO bus_station_sch.ekipazh VALUES (2, 1, 2, 'второй водитель', '2025-04-10', 'P', NULL);
INSERT INTO bus_station_sch.ekipazh VALUES (3, 2, 1, 'первый водитель', '2025-04-10', 'P', NULL);
INSERT INTO bus_station_sch.ekipazh VALUES (4, 2, 2, 'второй водитель', '2025-04-10', 'N', 'Повышенное давление');


--
-- TOC entry 3416 (class 0 OID 16405)
-- Dependencies: 216
-- Data for Name: model_avtobusa; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.model_avtobusa VALUES (1, 'туристический', 50, 1);
INSERT INTO bus_station_sch.model_avtobusa VALUES (2, 'междугородний', 45, 2);
INSERT INTO bus_station_sch.model_avtobusa VALUES (3, 'городской', 30, 3);


--
-- TOC entry 3422 (class 0 OID 16460)
-- Dependencies: 222
-- Data for Name: passazhir; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.passazhir VALUES (1, 'Петрова', 'Анна', 'Сергеевна', 1);
INSERT INTO bus_station_sch.passazhir VALUES (2, 'Смирнов', 'Дмитрий', 'Олегович', 2);
INSERT INTO bus_station_sch.passazhir VALUES (3, 'Кузнецова', 'Мария', 'Игоревна', 3);


--
-- TOC entry 3420 (class 0 OID 16445)
-- Dependencies: 220
-- Data for Name: passportnye_dannye_passazhira; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.passportnye_dannye_passazhira VALUES (1, 4501, 111111, '2017-03-10', 'УМВД России по г. Москве', 'г. Москва, ул. Мира, д. 15');
INSERT INTO bus_station_sch.passportnye_dannye_passazhira VALUES (2, 4502, 222222, '2018-07-21', 'УМВД России по Тверской области', 'г. Тверь, ул. Победы, д. 22');
INSERT INTO bus_station_sch.passportnye_dannye_passazhira VALUES (3, 4503, 333333, '2020-01-30', 'УМВД России по Новгородской области', 'г. Валдай, ул. Озерная, д. 8');


--
-- TOC entry 3419 (class 0 OID 16437)
-- Dependencies: 219
-- Data for Name: passportnye_dannye_voditelya; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.passportnye_dannye_voditelya VALUES (1, 4010, 123456, '2018-05-12', 'УМВД России по Тверской области', 'г. Тверь, ул. Центральная, д. 10');
INSERT INTO bus_station_sch.passportnye_dannye_voditelya VALUES (2, 4011, 654321, '2019-08-20', 'УМВД России по Новгородской области', 'г. Валдай, ул. Лесная, д. 5');


--
-- TOC entry 3415 (class 0 OID 16400)
-- Dependencies: 215
-- Data for Name: proizvoditel; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.proizvoditel VALUES (1, 'NESAN', 'Германия');
INSERT INTO bus_station_sch.proizvoditel VALUES (2, 'Neoplan', 'Германия');
INSERT INTO bus_station_sch.proizvoditel VALUES (3, 'ПАЗ', 'Россия');


--
-- TOC entry 3424 (class 0 OID 16486)
-- Dependencies: 224
-- Data for Name: promezhutochnye_ostanovki; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.promezhutochnye_ostanovki VALUES (1, 1, 1, '10:30:00', '10:40:00', 15, 2, '02:00:00');
INSERT INTO bus_station_sch.promezhutochnye_ostanovki VALUES (2, 1, 2, '13:20:00', '13:30:00', 20, 4, '04:50:00');
INSERT INTO bus_station_sch.promezhutochnye_ostanovki VALUES (3, 1, 3, '16:00:00', '16:00:00', 0, 1, '07:30:00');
INSERT INTO bus_station_sch.promezhutochnye_ostanovki VALUES (4, 2, 1, '13:30:00', '13:40:00', 10, 4, '01:30:00');
INSERT INTO bus_station_sch.promezhutochnye_ostanovki VALUES (5, 2, 2, '15:00:00', '15:00:00', 0, 2, '03:00:00');


--
-- TOC entry 3418 (class 0 OID 16431)
-- Dependencies: 218
-- Data for Name: punkt_naznacheniya; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.punkt_naznacheniya VALUES (1, 'Москва', 'город');
INSERT INTO bus_station_sch.punkt_naznacheniya VALUES (2, 'Тверь', 'город');
INSERT INTO bus_station_sch.punkt_naznacheniya VALUES (3, 'Валдай', 'город');
INSERT INTO bus_station_sch.punkt_naznacheniya VALUES (4, 'Крестцы', 'посёлок');
INSERT INTO bus_station_sch.punkt_naznacheniya VALUES (5, 'Выползово', 'село');


--
-- TOC entry 3423 (class 0 OID 16470)
-- Dependencies: 223
-- Data for Name: reis; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.reis VALUES (1, '2025-04-10', '08:30:00', 'R', 'BUS001    ', 1);
INSERT INTO bus_station_sch.reis VALUES (2, '2025-04-10', '12:00:00', 'D', 'BUS002    ', 2);
INSERT INTO bus_station_sch.reis VALUES (3, '2025-04-11', '09:15:00', 'R', 'BUS003    ', 3);


--
-- TOC entry 3421 (class 0 OID 16450)
-- Dependencies: 221
-- Data for Name: voditel; Type: TABLE DATA; Schema: bus_station_sch; Owner: postgres
--

INSERT INTO bus_station_sch.voditel VALUES (1, 'Иванов', 'Иван', 'Петрович', 1);
INSERT INTO bus_station_sch.voditel VALUES (2, 'Сидоров', 'Алексей', 'Михайлович', 2);


--
-- TOC entry 3257 (class 2606 OID 16510)
-- Name: ekipazh ID_crew_prkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.ekipazh
    ADD CONSTRAINT "ID_crew_prkey" PRIMARY KEY ("ID_crew");


--
-- TOC entry 3249 (class 2606 OID 16464)
-- Name: passazhir ID_passenger_prkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.passazhir
    ADD CONSTRAINT "ID_passenger_prkey" PRIMARY KEY ("ID_passenger");


--
-- TOC entry 3243 (class 2606 OID 16449)
-- Name: passportnye_dannye_passazhira ID_passport_pas_prkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.passportnye_dannye_passazhira
    ADD CONSTRAINT "ID_passport_pas_prkey" PRIMARY KEY ("ID_passport");


--
-- TOC entry 3239 (class 2606 OID 16441)
-- Name: passportnye_dannye_voditelya ID_passport_prkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.passportnye_dannye_voditelya
    ADD CONSTRAINT "ID_passport_prkey" PRIMARY KEY ("ID_passport");


--
-- TOC entry 3237 (class 2606 OID 16436)
-- Name: punkt_naznacheniya destination_ID_prkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.punkt_naznacheniya
    ADD CONSTRAINT "destination_ID_prkey" PRIMARY KEY ("destination_ID");


--
-- TOC entry 3247 (class 2606 OID 16454)
-- Name: voditel driver_ID_prkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.voditel
    ADD CONSTRAINT "driver_ID_prkey" PRIMARY KEY ("driver_ID");


--
-- TOC entry 3251 (class 2606 OID 16475)
-- Name: reis flight_ID_prkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.reis
    ADD CONSTRAINT "flight_ID_prkey" PRIMARY KEY ("flight_ID");


--
-- TOC entry 3233 (class 2606 OID 16411)
-- Name: model_avtobusa model_avtobusa_pkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.model_avtobusa
    ADD CONSTRAINT model_avtobusa_pkey PRIMARY KEY ("model_ID");


--
-- TOC entry 3235 (class 2606 OID 16422)
-- Name: avtobus prkey_bus_ID; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.avtobus
    ADD CONSTRAINT "prkey_bus_ID" PRIMARY KEY ("bus_ID");


--
-- TOC entry 3231 (class 2606 OID 16404)
-- Name: proizvoditel proizvoditel_pkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.proizvoditel
    ADD CONSTRAINT proizvoditel_pkey PRIMARY KEY (id_manufacturerr);


--
-- TOC entry 3253 (class 2606 OID 16492)
-- Name: promezhutochnye_ostanovki stop_ID_prkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.promezhutochnye_ostanovki
    ADD CONSTRAINT "stop_ID_prkey" PRIMARY KEY ("stop_ID");


--
-- TOC entry 3259 (class 2606 OID 16530)
-- Name: bilet ticket_ID_prkey; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.bilet
    ADD CONSTRAINT "ticket_ID_prkey" PRIMARY KEY ("ticket_ID");


--
-- TOC entry 3241 (class 2606 OID 16547)
-- Name: passportnye_dannye_voditelya uq_driver_passport_batch; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.passportnye_dannye_voditelya
    ADD CONSTRAINT uq_driver_passport_batch UNIQUE (batch, number);


--
-- TOC entry 3245 (class 2606 OID 16549)
-- Name: passportnye_dannye_passazhira uq_passenger_passport_batch_number; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.passportnye_dannye_passazhira
    ADD CONSTRAINT uq_passenger_passport_batch_number UNIQUE (batch, number);


--
-- TOC entry 3255 (class 2606 OID 16551)
-- Name: promezhutochnye_ostanovki uq_stop_flight_stopnumber; Type: CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.promezhutochnye_ostanovki
    ADD CONSTRAINT uq_stop_flight_stopnumber UNIQUE ("flight_ID", stop_number);


--
-- TOC entry 3270 (class 2606 OID 16536)
-- Name: bilet ID_passenger_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.bilet
    ADD CONSTRAINT "ID_passenger_fk" FOREIGN KEY ("ID_passenger") REFERENCES bus_station_sch.passazhir("ID_passenger");


--
-- TOC entry 3262 (class 2606 OID 16455)
-- Name: voditel ID_passport_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.voditel
    ADD CONSTRAINT "ID_passport_fk" FOREIGN KEY ("ID_passport") REFERENCES bus_station_sch.passportnye_dannye_voditelya("ID_passport");


--
-- TOC entry 3263 (class 2606 OID 16465)
-- Name: passazhir ID_passport_pas_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.passazhir
    ADD CONSTRAINT "ID_passport_pas_fk" FOREIGN KEY ("ID_passport") REFERENCES bus_station_sch.passportnye_dannye_passazhira("ID_passport");


--
-- TOC entry 3264 (class 2606 OID 16476)
-- Name: reis bus_ID_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.reis
    ADD CONSTRAINT "bus_ID_fk" FOREIGN KEY ("bus_ID") REFERENCES bus_station_sch.avtobus("bus_ID");


--
-- TOC entry 3266 (class 2606 OID 16498)
-- Name: promezhutochnye_ostanovki destination_ID_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.promezhutochnye_ostanovki
    ADD CONSTRAINT "destination_ID_fk" FOREIGN KEY ("destination_ID") REFERENCES bus_station_sch.punkt_naznacheniya("destination_ID");


--
-- TOC entry 3265 (class 2606 OID 16481)
-- Name: reis destination_ID_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.reis
    ADD CONSTRAINT "destination_ID_fk" FOREIGN KEY ("destination_ID") REFERENCES bus_station_sch.punkt_naznacheniya("destination_ID");


--
-- TOC entry 3268 (class 2606 OID 16516)
-- Name: ekipazh driver_ID_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.ekipazh
    ADD CONSTRAINT "driver_ID_fk" FOREIGN KEY ("driver_ID") REFERENCES bus_station_sch.voditel("driver_ID");


--
-- TOC entry 3261 (class 2606 OID 16423)
-- Name: avtobus fk_avtobus_model; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.avtobus
    ADD CONSTRAINT fk_avtobus_model FOREIGN KEY ("model_ID") REFERENCES bus_station_sch.model_avtobusa("model_ID");


--
-- TOC entry 3260 (class 2606 OID 16412)
-- Name: model_avtobusa fk_model_manufacture; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.model_avtobusa
    ADD CONSTRAINT fk_model_manufacture FOREIGN KEY (id_manufacturerr) REFERENCES bus_station_sch.proizvoditel(id_manufacturerr);


--
-- TOC entry 3271 (class 2606 OID 16531)
-- Name: bilet flight_ID_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.bilet
    ADD CONSTRAINT "flight_ID_fk" FOREIGN KEY ("flight_ID") REFERENCES bus_station_sch.reis("flight_ID");


--
-- TOC entry 3269 (class 2606 OID 16511)
-- Name: ekipazh flight_ID_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.ekipazh
    ADD CONSTRAINT "flight_ID_fk" FOREIGN KEY ("flight_ID") REFERENCES bus_station_sch.reis("flight_ID");


--
-- TOC entry 3267 (class 2606 OID 16493)
-- Name: promezhutochnye_ostanovki flight_ID_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.promezhutochnye_ostanovki
    ADD CONSTRAINT "flight_ID_fk" FOREIGN KEY ("flight_ID") REFERENCES bus_station_sch.reis("flight_ID");


--
-- TOC entry 3272 (class 2606 OID 16541)
-- Name: bilet stop_ID_fk; Type: FK CONSTRAINT; Schema: bus_station_sch; Owner: postgres
--

ALTER TABLE ONLY bus_station_sch.bilet
    ADD CONSTRAINT "stop_ID_fk" FOREIGN KEY ("stop_ID") REFERENCES bus_station_sch.promezhutochnye_ostanovki("stop_ID");


-- Completed on 2026-03-26 23:46:01

--
-- PostgreSQL database dump complete
--

\unrestrict FHbmqtODi8RkMkAf6ltQWdLGCSMuvZMlIOSKgec5JqUbax9iG5N2kVwz5AaDBNK

