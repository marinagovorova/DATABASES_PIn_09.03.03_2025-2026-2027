--
-- PostgreSQL database dump
--

\restrict oR6g964XSsck3IdKD6OSV7oOdLsZTulz5vSih9PbrLb90xTlIiwsSBF0pkv2Hbd

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-03-31 12:12:42

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

-- 1. КОМАНДЫ СОЗДАНИЯ БАЗЫ ДАННЫХ
-- Перед запуском убедитесь, что вы не подключены к этой БД
DROP DATABASE IF EXISTS "TranLien";
CREATE DATABASE "TranLien" 
    WITH OWNER = postgres 
    ENCODING = 'UTF8';

-- Переключение контекста на созданную БД (в psql)
\c TranLien

-- 2. СОЗДАНИЕ СХЕМЫ
-- Создание логического пространства для таблиц пассажирских перевозок

--
-- TOC entry 6 (class 2615 OID 16389)
-- Name: Passengers; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "Passengers";


ALTER SCHEMA "Passengers" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

-- 3. СОЗДАНИЕ ТАБЛИЦ

--
-- TOC entry 223 (class 1259 OID 16412)
-- Name: Билет; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Билет" (
    "ID_билета" integer NOT NULL,
    "ID_типа билета" integer NOT NULL,
    "ID_паспорта" integer NOT NULL,
    "ID_кассы" integer NOT NULL,
    "Дата прибытия" date,
    "Точка посадки" character varying,
    "Точка высадки" character varying,
    "Способ оплаты" character varying,
    "Статус" character varying,
    CONSTRAINT "check_билет" CHECK (("Дата прибытия" >= '2026-03-31'::date))
);


ALTER TABLE "Passengers"."Билет" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16457)
-- Name: Вагон; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Вагон" (
    "ID_вагона" integer NOT NULL,
    "ID_типа вагона" integer NOT NULL,
    "Номер вагона" integer,
    "Название вагона" character varying,
    "Количество мест" integer
);


ALTER TABLE "Passengers"."Вагон" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16470)
-- Name: Вагон в рейсе; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Вагон в рейсе" (
    "ID_вагон в рейсе" integer NOT NULL,
    "ID_вагона" integer NOT NULL,
    "ID_рейса" integer NOT NULL,
    "Название вагона" character varying
);


ALTER TABLE "Passengers"."Вагон в рейсе" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16421)
-- Name: Касса; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Касса" (
    "ID_кассы" integer NOT NULL,
    "Тип продаж" character varying,
    "Город" character varying,
    "Адрес" character varying,
    "Номер тел" character varying,
    "Статус" character varying
);


ALTER TABLE "Passengers"."Касса" OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16491)
-- Name: Маршрут; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Маршрут" (
    "ID_маршрута" integer NOT NULL,
    "Название маршрута" character varying,
    "Точка отправления" character varying,
    "Точка назначения" character varying,
    "Время отправления" time with time zone,
    "Время назначения" time with time zone
);


ALTER TABLE "Passengers"."Маршрут" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16441)
-- Name: Место; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Место" (
    "ID_места" integer NOT NULL,
    "ID_билета" integer NOT NULL,
    "ID_типа места" integer NOT NULL,
    "Номер места" integer,
    "Статус" character varying
);


ALTER TABLE "Passengers"."Место" OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16512)
-- Name: Остановка; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Остановка" (
    "ID_остановка" integer NOT NULL,
    "Название" character varying,
    "Тип населенного пункта" character varying,
    "Время отправления" time with time zone,
    "Время прибытия" time with time zone,
    "Время стоянки" time with time zone,
    "Статус" character varying
);


ALTER TABLE "Passengers"."Остановка" OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16504)
-- Name: Остановка в маршруте; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Остановка в маршруте" (
    "ID_остановка в маршруте" integer CONSTRAINT "Остановка в ма_ID_остановка в _not_null" NOT NULL,
    "ID_остановок" integer CONSTRAINT "Остановка в маршр_ID_остановок_not_null" NOT NULL,
    "ID_маршрута" integer CONSTRAINT "Остановка в маршру_ID_маршрута_not_null" NOT NULL,
    "Название остановок" character varying,
    "Количество остановок" integer
);


ALTER TABLE "Passengers"."Остановка в маршруте" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16399)
-- Name: Паспорт; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Паспорт" (
    "ID_паспорта" integer CONSTRAINT "Паспорт_ID_паспорт_not_null" NOT NULL,
    "ID_пассажира" integer NOT NULL,
    "Номер серии" integer,
    "Тип" character varying,
    "Кем выдан" character varying,
    "Гражданство" character varying,
    "Дата окончания" date
);


ALTER TABLE "Passengers"."Паспорт" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16393)
-- Name: Пассажир; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Пассажир" (
    "ID_пассажира" integer NOT NULL,
    "Фамилия" character varying,
    "Имя" character varying,
    "Отчество" character varying,
    "День рождения" date,
    "Телефон" character varying,
    "Почта" character varying
);


ALTER TABLE "Passengers"."Пассажир" OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16497)
-- Name: Расписание; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Расписание" (
    "ID_расписания" integer NOT NULL,
    "ID_маршрута" integer NOT NULL,
    "Тип действия" character varying,
    "Дата начала" date,
    "Дата окончания" date,
    "Примечание" character varying
);


ALTER TABLE "Passengers"."Расписание" OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16478)
-- Name: Рейс; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Рейс" (
    "ID_рейса" integer NOT NULL,
    "ID_типа поезда" integer NOT NULL,
    "Номер поезда" integer,
    "Плановая дата" date,
    "Фактическая дата" date,
    "Плановое время" time with time zone,
    "Фактическое время" time with time zone,
    "Статус" character varying
);


ALTER TABLE "Passengers"."Рейс" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16449)
-- Name: Состав типа вагона; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Состав типа вагона" (
    "ID_состав вагона" integer CONSTRAINT "Состав типа ва_ID_состав вагон_not_null" NOT NULL,
    "ID_типа вагона" integer CONSTRAINT "Состав типа ваг_ID_типа вагона_not_null" NOT NULL,
    "ID_типа места" integer CONSTRAINT "Состав типа ваго_ID_типа места_not_null" NOT NULL
);


ALTER TABLE "Passengers"."Состав типа вагона" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16406)
-- Name: Тип билета; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Тип билета" (
    "ID_типа билета" integer NOT NULL,
    "Название" character varying,
    "Базовая цена" integer,
    "Правила скидок" character varying
);


ALTER TABLE "Passengers"."Тип билета" OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16464)
-- Name: Тип вагона; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Тип вагона" (
    "ID_типа вагона" integer NOT NULL,
    "Название" character varying,
    "Услуги" character varying
);


ALTER TABLE "Passengers"."Тип вагона" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16435)
-- Name: Тип места; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Тип места" (
    "ID_типа места" integer NOT NULL,
    "Название" character varying,
    "Ярус" character varying
);


ALTER TABLE "Passengers"."Тип места" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16485)
-- Name: Тип поезда; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Тип поезда" (
    "ID_типа поезда" integer NOT NULL,
    "Название" character varying,
    "Периодичность" character varying,
    "Скорость" character varying,
    "Дальность следования" character varying
);


ALTER TABLE "Passengers"."Тип поезда" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16427)
-- Name: Цена; Type: TABLE; Schema: Passengers; Owner: postgres
--

CREATE TABLE "Passengers"."Цена" (
    "ID_цены" integer NOT NULL,
    "ID_типа места" integer NOT NULL,
    "ID_типа билета" integer NOT NULL
);


ALTER TABLE "Passengers"."Цена" OWNER TO postgres;

-- 4. ОГРАНИЧЕНИЯ НА ЗНАЧЕНИЯ ПОЛЕЙ (CHECK)

--
-- TOC entry 4928 (class 2606 OID 16520)
-- Name: Вагон check_вагон; Type: CHECK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE "Passengers"."Вагон"
    ADD CONSTRAINT "check_вагон" CHECK (("Количество мест" > 0)) NOT VALID;


--
-- TOC entry 4929 (class 2606 OID 16521)
-- Name: Маршрут check_маршрут; Type: CHECK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE "Passengers"."Маршрут"
    ADD CONSTRAINT "check_маршрут" CHECK (("Время отправления" > "Время назначения")) NOT VALID;


--
-- TOC entry 4931 (class 2606 OID 16523)
-- Name: Остановка в маршруте check_оста в маршруте; Type: CHECK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE "Passengers"."Остановка в маршруте"
    ADD CONSTRAINT "check_оста в маршруте" CHECK (("Количество остановок" > 0)) NOT VALID;


--
-- TOC entry 4932 (class 2606 OID 16522)
-- Name: Остановка check_остановка; Type: CHECK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE "Passengers"."Остановка"
    ADD CONSTRAINT "check_остановка" CHECK (("Время отправления" < "Время прибытия")) NOT VALID;


--
-- TOC entry 4925 (class 2606 OID 16524)
-- Name: Паспорт check_паспорт; Type: CHECK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE "Passengers"."Паспорт"
    ADD CONSTRAINT "check_паспорт" CHECK (("Дата окончания" >= '2026-03-31'::date)) NOT VALID;


--
-- TOC entry 4924 (class 2606 OID 16525)
-- Name: Пассажир check_пассажир; Type: CHECK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE "Passengers"."Пассажир"
    ADD CONSTRAINT "check_пассажир" CHECK (("День рождения" <= '2026-03-31'::date)) NOT VALID;


--
-- TOC entry 4930 (class 2606 OID 16526)
-- Name: Расписание check_расписание; Type: CHECK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE "Passengers"."Расписание"
    ADD CONSTRAINT "check_расписание" CHECK (("Дата начала" < "Дата окончания")) NOT VALID;


--
-- TOC entry 4926 (class 2606 OID 16527)
-- Name: Тип билета check_тип билета; Type: CHECK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE "Passengers"."Тип билета"
    ADD CONSTRAINT "check_тип билета" CHECK (("Базовая цена" > 0)) NOT VALID;

-- 5. СОЗДАНИЕ ПЕРВИЧНЫХ КЛЮЧЕЙ

--
-- TOC entry 4940 (class 2606 OID 16420)
-- Name: Билет Билет_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Билет"
    ADD CONSTRAINT "Билет_pkey" PRIMARY KEY ("ID_билета");


--
-- TOC entry 4956 (class 2606 OID 16477)
-- Name: Вагон в рейсе Вагон в рейсе_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Вагон в рейсе"
    ADD CONSTRAINT "Вагон в рейсе_pkey" PRIMARY KEY ("ID_вагон в рейсе");


--
-- TOC entry 4952 (class 2606 OID 16463)
-- Name: Вагон Вагон_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Вагон"
    ADD CONSTRAINT "Вагон_pkey" PRIMARY KEY ("ID_вагона");


--
-- TOC entry 4942 (class 2606 OID 16426)
-- Name: Касса Касса_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Касса"
    ADD CONSTRAINT "Касса_pkey" PRIMARY KEY ("ID_кассы");


--
-- TOC entry 4962 (class 2606 OID 16496)
-- Name: Маршрут Маршрут_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Маршрут"
    ADD CONSTRAINT "Маршрут_pkey" PRIMARY KEY ("ID_маршрута");


--
-- TOC entry 4948 (class 2606 OID 16448)
-- Name: Место Место_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Место"
    ADD CONSTRAINT "Место_pkey" PRIMARY KEY ("ID_места");


--
-- TOC entry 4966 (class 2606 OID 16511)
-- Name: Остановка в маршруте Остановка в маршруте_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Остановка в маршруте"
    ADD CONSTRAINT "Остановка в маршруте_pkey" PRIMARY KEY ("ID_остановка в маршруте");


--
-- TOC entry 4968 (class 2606 OID 16517)
-- Name: Остановка Остановка_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Остановка"
    ADD CONSTRAINT "Остановка_pkey" PRIMARY KEY ("ID_остановка");


--
-- TOC entry 4936 (class 2606 OID 16405)
-- Name: Паспорт Паспорт_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Паспорт"
    ADD CONSTRAINT "Паспорт_pkey" PRIMARY KEY ("ID_паспорта");


--
-- TOC entry 4934 (class 2606 OID 16398)
-- Name: Пассажир Пассажир_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Пассажир"
    ADD CONSTRAINT "Пассажир_pkey" PRIMARY KEY ("ID_пассажира");


--
-- TOC entry 4964 (class 2606 OID 16503)
-- Name: Расписание Расписание_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Расписание"
    ADD CONSTRAINT "Расписание_pkey" PRIMARY KEY ("ID_расписания");


--
-- TOC entry 4958 (class 2606 OID 16484)
-- Name: Рейс Рейс_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Рейс"
    ADD CONSTRAINT "Рейс_pkey" PRIMARY KEY ("ID_рейса");


--
-- TOC entry 4950 (class 2606 OID 16456)
-- Name: Состав типа вагона Состав типа вагона_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Состав типа вагона"
    ADD CONSTRAINT "Состав типа вагона_pkey" PRIMARY KEY ("ID_состав вагона");


--
-- TOC entry 4938 (class 2606 OID 16411)
-- Name: Тип билета Тип билета_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Тип билета"
    ADD CONSTRAINT "Тип билета_pkey" PRIMARY KEY ("ID_типа билета");


--
-- TOC entry 4954 (class 2606 OID 16469)
-- Name: Тип вагона Тип вагона_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Тип вагона"
    ADD CONSTRAINT "Тип вагона_pkey" PRIMARY KEY ("ID_типа вагона");


--
-- TOC entry 4946 (class 2606 OID 16440)
-- Name: Тип места Тип места_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Тип места"
    ADD CONSTRAINT "Тип места_pkey" PRIMARY KEY ("ID_типа места");


--
-- TOC entry 4960 (class 2606 OID 16490)
-- Name: Тип поезда Тип поезда_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Тип поезда"
    ADD CONSTRAINT "Тип поезда_pkey" PRIMARY KEY ("ID_типа поезда");


--
-- TOC entry 4944 (class 2606 OID 16434)
-- Name: Цена Цена_pkey; Type: CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Цена"
    ADD CONSTRAINT "Цена_pkey" PRIMARY KEY ("ID_цены");

-- 6. ОГРАНИЧЕНИЯ ВНЕШНИХ КЛЮЧЕЙ

--
-- TOC entry 4970 (class 2606 OID 16600)
-- Name: Билет FK_ID_паспорта; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Билет"
    ADD CONSTRAINT "FK_ID_паспорта" FOREIGN KEY ("ID_паспорта") REFERENCES "Passengers"."Паспорт"("ID_паспорта") NOT VALID;


--
-- TOC entry 4979 (class 2606 OID 16580)
-- Name: Вагон FK_Вагон; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Вагон"
    ADD CONSTRAINT "FK_Вагон" FOREIGN KEY ("ID_типа вагона") REFERENCES "Passengers"."Тип вагона"("ID_типа вагона") NOT VALID;


--
-- TOC entry 4969 (class 2606 OID 16575)
-- Name: Паспорт FK_Паспорт; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Паспорт"
    ADD CONSTRAINT "FK_Паспорт" FOREIGN KEY ("ID_пассажира") REFERENCES "Passengers"."Пассажир"("ID_пассажира") NOT VALID;


--
-- TOC entry 4983 (class 2606 OID 16590)
-- Name: Расписание FK_Расписание; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Расписание"
    ADD CONSTRAINT "FK_Расписание" FOREIGN KEY ("ID_маршрута") REFERENCES "Passengers"."Маршрут"("ID_маршрута") NOT VALID;


--
-- TOC entry 4982 (class 2606 OID 16585)
-- Name: Рейс FK_Рейс; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Рейс"
    ADD CONSTRAINT "FK_Рейс" FOREIGN KEY ("ID_типа поезда") REFERENCES "Passengers"."Тип поезда"("ID_типа поезда") NOT VALID;


--
-- TOC entry 4975 (class 2606 OID 16620)
-- Name: Место FK_билет; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Место"
    ADD CONSTRAINT "FK_билет" FOREIGN KEY ("ID_билета") REFERENCES "Passengers"."Билет"("ID_билета") NOT VALID;


--
-- TOC entry 4980 (class 2606 OID 16640)
-- Name: Вагон в рейсе FK_вагон; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Вагон в рейсе"
    ADD CONSTRAINT "FK_вагон" FOREIGN KEY ("ID_вагона") REFERENCES "Passengers"."Вагон"("ID_вагона") NOT VALID;


--
-- TOC entry 4971 (class 2606 OID 16605)
-- Name: Билет FK_касса; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Билет"
    ADD CONSTRAINT "FK_касса" FOREIGN KEY ("ID_кассы") REFERENCES "Passengers"."Касса"("ID_кассы") NOT VALID;


--
-- TOC entry 4984 (class 2606 OID 16655)
-- Name: Остановка в маршруте FK_маршрут; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Остановка в маршруте"
    ADD CONSTRAINT "FK_маршрут" FOREIGN KEY ("ID_маршрута") REFERENCES "Passengers"."Маршрут"("ID_маршрута") NOT VALID;


--
-- TOC entry 4985 (class 2606 OID 16650)
-- Name: Остановка в маршруте FK_остановка; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Остановка в маршруте"
    ADD CONSTRAINT "FK_остановка" FOREIGN KEY ("ID_остановок") REFERENCES "Passengers"."Остановка"("ID_остановка") NOT VALID;


--
-- TOC entry 4981 (class 2606 OID 16645)
-- Name: Вагон в рейсе FK_рейс; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Вагон в рейсе"
    ADD CONSTRAINT "FK_рейс" FOREIGN KEY ("ID_рейса") REFERENCES "Passengers"."Рейс"("ID_рейса") NOT VALID;


--
-- TOC entry 4972 (class 2606 OID 16595)
-- Name: Билет FK_тип билет; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Билет"
    ADD CONSTRAINT "FK_тип билет" FOREIGN KEY ("ID_типа билета") REFERENCES "Passengers"."Тип билета"("ID_типа билета") NOT VALID;


--
-- TOC entry 4973 (class 2606 OID 16615)
-- Name: Цена FK_тип билета; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Цена"
    ADD CONSTRAINT "FK_тип билета" FOREIGN KEY ("ID_типа билета") REFERENCES "Passengers"."Тип билета"("ID_типа билета") NOT VALID;


--
-- TOC entry 4977 (class 2606 OID 16630)
-- Name: Состав типа вагона FK_тип вагона; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Состав типа вагона"
    ADD CONSTRAINT "FK_тип вагона" FOREIGN KEY ("ID_типа вагона") REFERENCES "Passengers"."Тип вагона"("ID_типа вагона") NOT VALID;


--
-- TOC entry 4976 (class 2606 OID 16625)
-- Name: Место FK_тип места; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Место"
    ADD CONSTRAINT "FK_тип места" FOREIGN KEY ("ID_типа места") REFERENCES "Passengers"."Тип места"("ID_типа места") NOT VALID;


--
-- TOC entry 4978 (class 2606 OID 16635)
-- Name: Состав типа вагона FK_тип места; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Состав типа вагона"
    ADD CONSTRAINT "FK_тип места" FOREIGN KEY ("ID_типа места") REFERENCES "Passengers"."Тип места"("ID_типа места") NOT VALID;


--
-- TOC entry 4974 (class 2606 OID 16610)
-- Name: Цена FK_тип места; Type: FK CONSTRAINT; Schema: Passengers; Owner: postgres
--

ALTER TABLE ONLY "Passengers"."Цена"
    ADD CONSTRAINT "FK_тип места" FOREIGN KEY ("ID_типа места") REFERENCES "Passengers"."Тип места"("ID_типа места") NOT VALID;


-- Completed on 2026-03-31 12:12:42

--
-- PostgreSQL database dump complete
--

\unrestrict oR6g964XSsck3IdKD6OSV7oOdLsZTulz5vSih9PbrLb90xTlIiwsSBF0pkv2Hbd

