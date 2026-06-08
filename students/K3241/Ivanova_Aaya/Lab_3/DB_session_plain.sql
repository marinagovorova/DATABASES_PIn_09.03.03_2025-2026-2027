--
-- PostgreSQL database dump
--

\restrict O72dE3U4abbtROHODFh8hzGuMCq1urJm50IeXRInBQbvK20XhJMEs9caNdFdAYb

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-06-03 21:28:27 MSK

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

ALTER TABLE IF EXISTS ONLY session_schema."Учебный_план" DROP CONSTRAINT IF EXISTS "Учебный_план_id_ОП_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Студент" DROP CONSTRAINT IF EXISTS "Студент_номер_группы_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Студент" DROP CONSTRAINT IF EXISTS "Студент_id_человека_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Сессия" DROP CONSTRAINT IF EXISTS "Сессия_id_человека_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Сессия" DROP CONSTRAINT IF EXISTS "Сессия_id_расписания_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Сессия" DROP CONSTRAINT IF EXISTS "Сессия_id_дисциплины_в_УП_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Расписание" DROP CONSTRAINT IF EXISTS "Расписание_id_аудитории_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Преподаватель" DROP CONSTRAINT IF EXISTS "Преподаватель_id_человека_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Преподаватель" DROP CONSTRAINT IF EXISTS "Преподаватель_id_истории_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Образовательная_программа" DROP CONSTRAINT IF EXISTS "Образовательная__id_направления_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Образовательная_программа" DROP CONSTRAINT IF EXISTS "Образовательна_id_подразделени_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Назначение_стипендии" DROP CONSTRAINT IF EXISTS "Назначение_стипенди_id_человека_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Назначение_стипендии" DROP CONSTRAINT IF EXISTS "Назначение_стипенд_id_стипендии_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Должностная_история" DROP CONSTRAINT IF EXISTS "Должностная_истори_id_должности_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Дисциплина_в_учебном_плане" DROP CONSTRAINT IF EXISTS "Дисциплина_в_учебн_id_дисциплины_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Дисциплина_в_учебном_плане" DROP CONSTRAINT IF EXISTS "Дисциплина_в_уч_id_учебного_план_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Группа" DROP CONSTRAINT IF EXISTS "Группа_id_направления_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Аудитория" DROP CONSTRAINT IF EXISTS "Аудитория_id_площадки_fkey";
ALTER TABLE IF EXISTS ONLY session_schema."Человек" DROP CONSTRAINT IF EXISTS "Человек_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Учебный_план" DROP CONSTRAINT IF EXISTS "Учебный_план_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Студент" DROP CONSTRAINT IF EXISTS "Студент_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Стипендия" DROP CONSTRAINT IF EXISTS "Стипендия_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Сессия" DROP CONSTRAINT IF EXISTS "Сессия_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Расписание" DROP CONSTRAINT IF EXISTS "Расписание_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Преподаватель" DROP CONSTRAINT IF EXISTS "Преподаватель_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Подразделение" DROP CONSTRAINT IF EXISTS "Подразделение_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Площадка" DROP CONSTRAINT IF EXISTS "Площадка_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Образовательная_программа" DROP CONSTRAINT IF EXISTS "Образовательная_программа_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Направление" DROP CONSTRAINT IF EXISTS "Направление_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Назначение_стипендии" DROP CONSTRAINT IF EXISTS "Назначение_стипендии_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Должность" DROP CONSTRAINT IF EXISTS "Должность_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Должностная_история" DROP CONSTRAINT IF EXISTS "Должностная_история_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Дисциплина_в_учебном_плане" DROP CONSTRAINT IF EXISTS "Дисциплина_в_учебном_плане_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Дисциплина" DROP CONSTRAINT IF EXISTS "Дисциплина_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Группа" DROP CONSTRAINT IF EXISTS "Группа_pkey";
ALTER TABLE IF EXISTS ONLY session_schema."Аудитория" DROP CONSTRAINT IF EXISTS "Аудитория_pkey";
DROP TABLE IF EXISTS session_schema."Человек";
DROP TABLE IF EXISTS session_schema."Учебный_план";
DROP TABLE IF EXISTS session_schema."Студент";
DROP TABLE IF EXISTS session_schema."Стипендия";
DROP TABLE IF EXISTS session_schema."Сессия";
DROP TABLE IF EXISTS session_schema."Расписание";
DROP TABLE IF EXISTS session_schema."Преподаватель";
DROP TABLE IF EXISTS session_schema."Подразделение";
DROP TABLE IF EXISTS session_schema."Площадка";
DROP TABLE IF EXISTS session_schema."Образовательная_программа";
DROP TABLE IF EXISTS session_schema."Направление";
DROP TABLE IF EXISTS session_schema."Назначение_стипендии";
DROP TABLE IF EXISTS session_schema."Должность";
DROP TABLE IF EXISTS session_schema."Должностная_история";
DROP TABLE IF EXISTS session_schema."Дисциплина_в_учебном_плане";
DROP TABLE IF EXISTS session_schema."Дисциплина";
DROP TABLE IF EXISTS session_schema."Группа";
DROP TABLE IF EXISTS session_schema."Аудитория";
DROP SCHEMA IF EXISTS session_schema;
DROP SCHEMA IF EXISTS public;
--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3979 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 6 (class 2615 OID 16389)
-- Name: session_schema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA session_schema;


ALTER SCHEMA session_schema OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 16511)
-- Name: Аудитория; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Аудитория" (
    "id_аудитории" character varying(18) NOT NULL,
    "id_площадки" character varying(18) NOT NULL,
    "номер_аудитории" character varying(18) NOT NULL,
    "вместимость" integer NOT NULL,
    CONSTRAINT "chk_вместимость" CHECK (("вместимость" >= 0))
);


ALTER TABLE session_schema."Аудитория" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16479)
-- Name: Группа; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Группа" (
    "номер_группы" character varying(18) NOT NULL,
    "id_направления" character varying(18) NOT NULL,
    "курс" integer NOT NULL,
    "учебный_год" character varying(18) NOT NULL,
    "семестр" integer NOT NULL,
    CONSTRAINT "chk_группа_курс" CHECK ((("курс" >= 1) AND ("курс" <= 4))),
    CONSTRAINT "chk_группа_семестр" CHECK ((("семестр" >= 1) AND ("семестр" <= 10)))
);


ALTER TABLE session_schema."Группа" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16440)
-- Name: Дисциплина; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Дисциплина" (
    "id_дисциплины" character varying(18) NOT NULL,
    "название_дисциплины" character varying(50) CONSTRAINT "Дисциплина_название_дисципли_not_null" NOT NULL,
    "тип_аттестации" character varying(18) NOT NULL,
    "тип_занятия" character varying(50) NOT NULL,
    "часы_лекций" integer NOT NULL,
    "часы_практики" integer NOT NULL,
    "часы_лабораторных" integer NOT NULL,
    "часы_практ_занятий" integer CONSTRAINT "Дисциплина_часы_практ_заняти_not_null" NOT NULL,
    CONSTRAINT "chk_часы_лабораторных" CHECK (("часы_лабораторных" >= 0)),
    CONSTRAINT "chk_часы_лекций" CHECK (("часы_лекций" >= 0)),
    CONSTRAINT "chk_часы_практ_занятий" CHECK (("часы_практ_занятий" >= 0)),
    CONSTRAINT "chk_часы_практики" CHECK (("часы_практики" >= 0))
);


ALTER TABLE session_schema."Дисциплина" OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16596)
-- Name: Дисциплина_в_учебном_плане; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Дисциплина_в_учебном_плане" (
    "id_дисциплины_в_УП" character varying(18) CONSTRAINT "Дисциплина_в_у_id_дисциплины_в_not_null" NOT NULL,
    "id_учебного_плана" character varying(18) CONSTRAINT "Дисциплина_в_у_id_учебного_пла_not_null" NOT NULL,
    "id_дисциплины" character varying(18) CONSTRAINT "Дисциплина_в_уче_id_дисциплины_not_null" NOT NULL,
    "семестр" integer CONSTRAINT "Дисциплина_в_учебном__семестр_not_null" NOT NULL,
    CONSTRAINT "chk_дисц_семестр" CHECK ((("семестр" >= 1) AND ("семестр" <= 12)))
);


ALTER TABLE session_schema."Дисциплина_в_учебном_плане" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16496)
-- Name: Должностная_история; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Должностная_история" (
    "id_истории" character varying(18) CONSTRAINT "Должностная_истори_id_истории_not_null" NOT NULL,
    "id_должности" character varying(18) CONSTRAINT "Должностная_исто_id_должности_not_null" NOT NULL,
    "дата_начала" date CONSTRAINT "Должностная_исто_дата_начала_not_null" NOT NULL,
    "дата_конца" date CONSTRAINT "Должностная_истор_дата_конца_not_null" NOT NULL,
    CONSTRAINT "chk_даты_истории" CHECK (("дата_конца" > "дата_начала"))
);


ALTER TABLE session_schema."Должностная_история" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16413)
-- Name: Должность; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Должность" (
    "id_должности" character varying(18) NOT NULL,
    "название_должности" character varying(100) NOT NULL
);


ALTER TABLE session_schema."Должность" OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16577)
-- Name: Назначение_стипендии; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Назначение_стипендии" (
    "id_назначения" character varying(18) CONSTRAINT "Назначение_стип_id_назначения_not_null" NOT NULL,
    "id_стипендии" character varying(18) CONSTRAINT "Назначение_стипе_id_стипендии_not_null" NOT NULL,
    "id_человека" character varying(18) CONSTRAINT "Назначение_стипен_id_человека_not_null" NOT NULL,
    "дата_назначения" date CONSTRAINT "Назначение_сти_дата_назначен_not_null" NOT NULL
);


ALTER TABLE session_schema."Назначение_стипендии" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16398)
-- Name: Направление; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Направление" (
    "id_направления" character varying(18) NOT NULL,
    "название_направления" character varying(100) CONSTRAINT "Направление_название_направл_not_null" NOT NULL
);


ALTER TABLE session_schema."Направление" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16457)
-- Name: Образовательная_программа; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Образовательная_программа" (
    "id_ОП" character varying(18) CONSTRAINT "Образовательная_програм_id_ОП_not_null" NOT NULL,
    "id_направления" character varying(18) CONSTRAINT "Образовательна_id_направления_not_null" NOT NULL,
    "id_подразделения" character varying(18) CONSTRAINT "Образовательн_id_подразделен_not_null" NOT NULL,
    "название_ОП" character varying(100) CONSTRAINT "Образовательная__название_ОП_not_null" NOT NULL,
    "срок_обучения" integer CONSTRAINT "Образовательна_срок_обучения_not_null" NOT NULL,
    "степень_образования" character varying(30) CONSTRAINT "Образовательн_степень_образ_not_null" NOT NULL,
    CONSTRAINT "chk_срок_обучения" CHECK ((("срок_обучения" >= 2) AND ("срок_обучения" <= 6)))
);


ALTER TABLE session_schema."Образовательная_программа" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16432)
-- Name: Площадка; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Площадка" (
    "id_площадки" character varying(18) NOT NULL,
    "город" character varying(50) NOT NULL,
    "адрес" character varying(100) NOT NULL
);


ALTER TABLE session_schema."Площадка" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16405)
-- Name: Подразделение; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Подразделение" (
    "id_подразделения" character varying(18) CONSTRAINT "Подразделение_id_подразделени_not_null" NOT NULL,
    "название_подразделения" character varying(100) CONSTRAINT "Подразделение_название_подра_not_null" NOT NULL,
    "тип_подразделения" character varying(100) CONSTRAINT "Подразделение_тип_подразделе_not_null" NOT NULL
);


ALTER TABLE session_schema."Подразделение" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16560)
-- Name: Преподаватель; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Преподаватель" (
    "id_человека" character varying(18) NOT NULL,
    "id_истории" character varying(18) NOT NULL
);


ALTER TABLE session_schema."Преподаватель" OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16616)
-- Name: Расписание; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Расписание" (
    "id_расписания" character varying(18) NOT NULL,
    "id_аудитории" character varying(18) NOT NULL,
    "тип_события" character varying(50) NOT NULL,
    "дата_проведения" date NOT NULL,
    "время_начала" time without time zone NOT NULL,
    "время_конца" time without time zone NOT NULL,
    CONSTRAINT "chk_время_расписания" CHECK (("время_конца" > "время_начала"))
);


ALTER TABLE session_schema."Расписание" OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16633)
-- Name: Сессия; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Сессия" (
    "id_сессии" character varying(18) NOT NULL,
    "id_человека" character varying(18) NOT NULL,
    "id_дисциплины_в_УП" character varying(18) NOT NULL,
    "id_расписания" character varying(18) NOT NULL,
    "учебный_год" character varying(18) NOT NULL,
    "семестр" integer NOT NULL,
    "оценка" integer,
    "статус_сдачи" character varying(18) NOT NULL,
    "номер_попытки" integer NOT NULL,
    "дата_начала" date NOT NULL,
    "дата_конца" date NOT NULL,
    CONSTRAINT "chk_даты_сессии" CHECK (("дата_конца" > "дата_начала")),
    CONSTRAINT "chk_номер_попытки" CHECK ((("номер_попытки" >= 1) AND ("номер_попытки" <= 3))),
    CONSTRAINT "chk_оценка" CHECK ((("оценка" >= 2) AND ("оценка" <= 5))),
    CONSTRAINT "chk_семестр_сессия" CHECK ((("семестр" >= 1) AND ("семестр" <= 12)))
);


ALTER TABLE session_schema."Сессия" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16420)
-- Name: Стипендия; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Стипендия" (
    "id_стипендии" character varying(18) NOT NULL,
    "тип_стипендии" character varying(50) NOT NULL,
    "размер_стипендии" numeric(10,2) NOT NULL,
    "условие_назначения" text NOT NULL,
    CONSTRAINT "chk_размер_стипендии" CHECK (("размер_стипендии" >= (0)::numeric))
);


ALTER TABLE session_schema."Стипендия" OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16539)
-- Name: Студент; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Студент" (
    "id_человека" character varying(18) NOT NULL,
    "номер_группы" character varying(18) NOT NULL,
    "год_поступления" integer NOT NULL,
    "статус" character varying(10) NOT NULL,
    "курс" integer NOT NULL,
    CONSTRAINT "chk_студент_курс" CHECK ((("курс" >= 1) AND ("курс" <= 5)))
);


ALTER TABLE session_schema."Студент" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16526)
-- Name: Учебный_план; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Учебный_план" (
    "id_учебного_плана" character varying(18) NOT NULL,
    "id_ОП" character varying(18) NOT NULL,
    "год_приема" integer NOT NULL
);


ALTER TABLE session_schema."Учебный_план" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: Человек; Type: TABLE; Schema: session_schema; Owner: postgres
--

CREATE TABLE session_schema."Человек" (
    "id_человека" character varying(18) NOT NULL,
    "фамилия" character varying(30) NOT NULL,
    "имя" character varying(30) NOT NULL,
    "отчество" character varying(30)
);


ALTER TABLE session_schema."Человек" OWNER TO postgres;

--
-- TOC entry 3966 (class 0 OID 16511)
-- Dependencies: 230
-- Data for Name: Аудитория; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Аудитория" VALUES ('AUD_01', 'LOC_01', '312', 30);
INSERT INTO session_schema."Аудитория" VALUES ('AUD_02', 'LOC_02', '501', 40);


--
-- TOC entry 3964 (class 0 OID 16479)
-- Dependencies: 228
-- Data for Name: Группа; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Группа" VALUES ('K3241', 'DIR_01', 3, '2025/2026', 5);


--
-- TOC entry 3962 (class 0 OID 16440)
-- Dependencies: 226
-- Data for Name: Дисциплина; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Дисциплина" VALUES ('SUB_01', 'Базы данных', 'Экзамен', 'Лекции', 32, 16, 16, 0);
INSERT INTO session_schema."Дисциплина" VALUES ('SUB_02', 'Программирование', 'Дифзачёт', 'Практика', 16, 32, 0, 16);
INSERT INTO session_schema."Дисциплина" VALUES ('SUB_03', 'Математика', 'Экзамен', 'Лекции', 48, 16, 0, 0);


--
-- TOC entry 3971 (class 0 OID 16596)
-- Dependencies: 235
-- Data for Name: Дисциплина_в_учебном_плане; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Дисциплина_в_учебном_плане" VALUES ('DUP_01', 'PLN_01', 'SUB_01', 5);
INSERT INTO session_schema."Дисциплина_в_учебном_плане" VALUES ('DUP_02', 'PLN_01', 'SUB_02', 5);


--
-- TOC entry 3965 (class 0 OID 16496)
-- Dependencies: 229
-- Data for Name: Должностная_история; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Должностная_история" VALUES ('HIS_01', 'POS_01', '2020-09-01', '2025-08-31');
INSERT INTO session_schema."Должностная_история" VALUES ('HIS_02', 'POS_02', '2018-09-01', '2025-08-31');


--
-- TOC entry 3959 (class 0 OID 16413)
-- Dependencies: 223
-- Data for Name: Должность; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Должность" VALUES ('POS_01', 'Доцент');
INSERT INTO session_schema."Должность" VALUES ('POS_02', 'Профессор');


--
-- TOC entry 3970 (class 0 OID 16577)
-- Dependencies: 234
-- Data for Name: Назначение_стипендии; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Назначение_стипендии" VALUES ('APP_01', 'SCH_01', 'STU_01', '2025-09-01');
INSERT INTO session_schema."Назначение_стипендии" VALUES ('APP_02', 'SCH_02', 'STU_02', '2025-10-15');


--
-- TOC entry 3957 (class 0 OID 16398)
-- Dependencies: 221
-- Data for Name: Направление; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Направление" VALUES ('DIR_01', '09.03.03 Прикладная информатика');
INSERT INTO session_schema."Направление" VALUES ('DIR_02', '09.03.01 Информатика и Вычислительная техника');


--
-- TOC entry 3963 (class 0 OID 16457)
-- Dependencies: 227
-- Data for Name: Образовательная_программа; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Образовательная_программа" VALUES ('EDU_01', 'DIR_01', 'FAC_01', 'Мобильные и сетевые технологии', 4, 'Бакалавр');


--
-- TOC entry 3961 (class 0 OID 16432)
-- Dependencies: 225
-- Data for Name: Площадка; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Площадка" VALUES ('LOC_01', 'Санкт-Петербург', 'Кронверкский пр., 49');
INSERT INTO session_schema."Площадка" VALUES ('LOC_02', 'Санкт-Петербург', 'ул. Ломоносова, 9');


--
-- TOC entry 3958 (class 0 OID 16405)
-- Dependencies: 222
-- Data for Name: Подразделение; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Подразделение" VALUES ('FAC_01', 'Факультет прикладной информатики', 'Факультет');
INSERT INTO session_schema."Подразделение" VALUES ('UNI_01', 'Университет ИТМО', 'Университет');


--
-- TOC entry 3969 (class 0 OID 16560)
-- Dependencies: 233
-- Data for Name: Преподаватель; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Преподаватель" VALUES ('TEA_01', 'HIS_01');
INSERT INTO session_schema."Преподаватель" VALUES ('TEA_02', 'HIS_02');


--
-- TOC entry 3972 (class 0 OID 16616)
-- Dependencies: 236
-- Data for Name: Расписание; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Расписание" VALUES ('SCH_01', 'AUD_01', 'Экзамен', '2026-01-15', '09:00:00', '11:00:00');
INSERT INTO session_schema."Расписание" VALUES ('SCH_02', 'AUD_02', 'Дифзачёт', '2026-01-16', '10:00:00', '11:30:00');


--
-- TOC entry 3973 (class 0 OID 16633)
-- Dependencies: 237
-- Data for Name: Сессия; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Сессия" VALUES ('SES_01', 'STU_01', 'DUP_01', 'SCH_01', '2025/2026', 5, 5, 'сдано', 1, '2026-01-15', '2026-01-16');
INSERT INTO session_schema."Сессия" VALUES ('SES_02', 'STU_02', 'DUP_01', 'SCH_01', '2025/2026', 5, 4, 'сдано', 1, '2026-01-15', '2026-01-16');
INSERT INTO session_schema."Сессия" VALUES ('SES_03', 'STU_01', 'DUP_02', 'SCH_02', '2025/2026', 5, 5, 'сдано', 1, '2026-01-16', '2026-01-17');


--
-- TOC entry 3960 (class 0 OID 16420)
-- Dependencies: 224
-- Data for Name: Стипендия; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Стипендия" VALUES ('SCH_01', 'Академическая', 3500.00, 'Без троек в сессии');
INSERT INTO session_schema."Стипендия" VALUES ('SCH_02', 'Повышенная', 7000.00, 'За олимпиады');
INSERT INTO session_schema."Стипендия" VALUES ('SCH_03', 'Социальная', 2500.00, 'Льготная категория');


--
-- TOC entry 3968 (class 0 OID 16539)
-- Dependencies: 232
-- Data for Name: Студент; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Студент" VALUES ('STU_01', 'K3241', 2022, 'обучается', 3);
INSERT INTO session_schema."Студент" VALUES ('STU_02', 'K3241', 2022, 'обучается', 3);
INSERT INTO session_schema."Студент" VALUES ('STU_03', 'K3241', 2022, 'отчислен', 2);


--
-- TOC entry 3967 (class 0 OID 16526)
-- Dependencies: 231
-- Data for Name: Учебный_план; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Учебный_план" VALUES ('PLN_01', 'EDU_01', 2022);


--
-- TOC entry 3956 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: Человек; Type: TABLE DATA; Schema: session_schema; Owner: postgres
--

INSERT INTO session_schema."Человек" VALUES ('STU_01', 'Бэггинс', 'Фродо', 'Иванович');
INSERT INTO session_schema."Человек" VALUES ('STU_02', 'Зеленый', 'Леголас', 'Трандуилович');
INSERT INTO session_schema."Человек" VALUES ('STU_03', 'Грозный', 'Гимли', 'Глоинович');
INSERT INTO session_schema."Человек" VALUES ('TEA_01', 'Серый', 'Гендальф', 'Сергеевич');
INSERT INTO session_schema."Человек" VALUES ('TEA_02', 'Элессар', 'Арагорн', 'Араторнович');


--
-- TOC entry 3776 (class 2606 OID 16888)
-- Name: Аудитория Аудитория_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Аудитория"
    ADD CONSTRAINT "Аудитория_pkey" PRIMARY KEY ("id_аудитории");


--
-- TOC entry 3772 (class 2606 OID 16844)
-- Name: Группа Группа_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Группа"
    ADD CONSTRAINT "Группа_pkey" PRIMARY KEY ("номер_группы");


--
-- TOC entry 3768 (class 2606 OID 16778)
-- Name: Дисциплина Дисциплина_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Дисциплина"
    ADD CONSTRAINT "Дисциплина_pkey" PRIMARY KEY ("id_дисциплины");


--
-- TOC entry 3786 (class 2606 OID 16910)
-- Name: Дисциплина_в_учебном_плане Дисциплина_в_учебном_плане_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Дисциплина_в_учебном_плане"
    ADD CONSTRAINT "Дисциплина_в_учебном_плане_pkey" PRIMARY KEY ("id_дисциплины_в_УП");


--
-- TOC entry 3774 (class 2606 OID 16790)
-- Name: Должностная_история Должностная_история_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Должностная_история"
    ADD CONSTRAINT "Должностная_история_pkey" PRIMARY KEY ("id_истории");


--
-- TOC entry 3762 (class 2606 OID 16740)
-- Name: Должность Должность_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Должность"
    ADD CONSTRAINT "Должность_pkey" PRIMARY KEY ("id_должности");


--
-- TOC entry 3784 (class 2606 OID 17008)
-- Name: Назначение_стипендии Назначение_стипендии_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Назначение_стипендии"
    ADD CONSTRAINT "Назначение_стипендии_pkey" PRIMARY KEY ("id_назначения");


--
-- TOC entry 3758 (class 2606 OID 16711)
-- Name: Направление Направление_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Направление"
    ADD CONSTRAINT "Направление_pkey" PRIMARY KEY ("id_направления");


--
-- TOC entry 3770 (class 2606 OID 16812)
-- Name: Образовательная_программа Образовательная_программа_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Образовательная_программа"
    ADD CONSTRAINT "Образовательная_программа_pkey" PRIMARY KEY ("id_ОП");


--
-- TOC entry 3766 (class 2606 OID 16766)
-- Name: Площадка Площадка_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Площадка"
    ADD CONSTRAINT "Площадка_pkey" PRIMARY KEY ("id_площадки");


--
-- TOC entry 3760 (class 2606 OID 16728)
-- Name: Подразделение Подразделение_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Подразделение"
    ADD CONSTRAINT "Подразделение_pkey" PRIMARY KEY ("id_подразделения");


--
-- TOC entry 3782 (class 2606 OID 16986)
-- Name: Преподаватель Преподаватель_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Преподаватель"
    ADD CONSTRAINT "Преподаватель_pkey" PRIMARY KEY ("id_человека");


--
-- TOC entry 3788 (class 2606 OID 16942)
-- Name: Расписание Расписание_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Расписание"
    ADD CONSTRAINT "Расписание_pkey" PRIMARY KEY ("id_расписания");


--
-- TOC entry 3790 (class 2606 OID 17035)
-- Name: Сессия Сессия_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Сессия"
    ADD CONSTRAINT "Сессия_pkey" PRIMARY KEY ("id_сессии");


--
-- TOC entry 3764 (class 2606 OID 16752)
-- Name: Стипендия Стипендия_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Стипендия"
    ADD CONSTRAINT "Стипендия_pkey" PRIMARY KEY ("id_стипендии");


--
-- TOC entry 3780 (class 2606 OID 16964)
-- Name: Студент Студент_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Студент"
    ADD CONSTRAINT "Студент_pkey" PRIMARY KEY ("id_человека");


--
-- TOC entry 3778 (class 2606 OID 16866)
-- Name: Учебный_план Учебный_план_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Учебный_план"
    ADD CONSTRAINT "Учебный_план_pkey" PRIMARY KEY ("id_учебного_плана");


--
-- TOC entry 3756 (class 2606 OID 16684)
-- Name: Человек Человек_pkey; Type: CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Человек"
    ADD CONSTRAINT "Человек_pkey" PRIMARY KEY ("id_человека");


--
-- TOC entry 3795 (class 2606 OID 16900)
-- Name: Аудитория Аудитория_id_площадки_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Аудитория"
    ADD CONSTRAINT "Аудитория_id_площадки_fkey" FOREIGN KEY ("id_площадки") REFERENCES session_schema."Площадка"("id_площадки");


--
-- TOC entry 3793 (class 2606 OID 16856)
-- Name: Группа Группа_id_направления_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Группа"
    ADD CONSTRAINT "Группа_id_направления_fkey" FOREIGN KEY ("id_направления") REFERENCES session_schema."Направление"("id_направления");


--
-- TOC entry 3803 (class 2606 OID 16922)
-- Name: Дисциплина_в_учебном_плане Дисциплина_в_уч_id_учебного_план_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Дисциплина_в_учебном_плане"
    ADD CONSTRAINT "Дисциплина_в_уч_id_учебного_план_fkey" FOREIGN KEY ("id_учебного_плана") REFERENCES session_schema."Учебный_план"("id_учебного_плана");


--
-- TOC entry 3804 (class 2606 OID 16932)
-- Name: Дисциплина_в_учебном_плане Дисциплина_в_учебн_id_дисциплины_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Дисциплина_в_учебном_плане"
    ADD CONSTRAINT "Дисциплина_в_учебн_id_дисциплины_fkey" FOREIGN KEY ("id_дисциплины") REFERENCES session_schema."Дисциплина"("id_дисциплины");


--
-- TOC entry 3794 (class 2606 OID 16802)
-- Name: Должностная_история Должностная_истори_id_должности_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Должностная_история"
    ADD CONSTRAINT "Должностная_истори_id_должности_fkey" FOREIGN KEY ("id_должности") REFERENCES session_schema."Должность"("id_должности");


--
-- TOC entry 3801 (class 2606 OID 17015)
-- Name: Назначение_стипендии Назначение_стипенд_id_стипендии_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Назначение_стипендии"
    ADD CONSTRAINT "Назначение_стипенд_id_стипендии_fkey" FOREIGN KEY ("id_стипендии") REFERENCES session_schema."Стипендия"("id_стипендии");


--
-- TOC entry 3802 (class 2606 OID 17025)
-- Name: Назначение_стипендии Назначение_стипенди_id_человека_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Назначение_стипендии"
    ADD CONSTRAINT "Назначение_стипенди_id_человека_fkey" FOREIGN KEY ("id_человека") REFERENCES session_schema."Человек"("id_человека");


--
-- TOC entry 3791 (class 2606 OID 16834)
-- Name: Образовательная_программа Образовательна_id_подразделени_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Образовательная_программа"
    ADD CONSTRAINT "Образовательна_id_подразделени_fkey" FOREIGN KEY ("id_подразделения") REFERENCES session_schema."Подразделение"("id_подразделения");


--
-- TOC entry 3792 (class 2606 OID 16824)
-- Name: Образовательная_программа Образовательная__id_направления_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Образовательная_программа"
    ADD CONSTRAINT "Образовательная__id_направления_fkey" FOREIGN KEY ("id_направления") REFERENCES session_schema."Направление"("id_направления");


--
-- TOC entry 3799 (class 2606 OID 16998)
-- Name: Преподаватель Преподаватель_id_истории_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Преподаватель"
    ADD CONSTRAINT "Преподаватель_id_истории_fkey" FOREIGN KEY ("id_истории") REFERENCES session_schema."Должностная_история"("id_истории");


--
-- TOC entry 3800 (class 2606 OID 16988)
-- Name: Преподаватель Преподаватель_id_человека_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Преподаватель"
    ADD CONSTRAINT "Преподаватель_id_человека_fkey" FOREIGN KEY ("id_человека") REFERENCES session_schema."Человек"("id_человека");


--
-- TOC entry 3805 (class 2606 OID 16954)
-- Name: Расписание Расписание_id_аудитории_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Расписание"
    ADD CONSTRAINT "Расписание_id_аудитории_fkey" FOREIGN KEY ("id_аудитории") REFERENCES session_schema."Аудитория"("id_аудитории");


--
-- TOC entry 3806 (class 2606 OID 17052)
-- Name: Сессия Сессия_id_дисциплины_в_УП_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Сессия"
    ADD CONSTRAINT "Сессия_id_дисциплины_в_УП_fkey" FOREIGN KEY ("id_дисциплины_в_УП") REFERENCES session_schema."Дисциплина_в_учебном_плане"("id_дисциплины_в_УП");


--
-- TOC entry 3807 (class 2606 OID 17062)
-- Name: Сессия Сессия_id_расписания_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Сессия"
    ADD CONSTRAINT "Сессия_id_расписания_fkey" FOREIGN KEY ("id_расписания") REFERENCES session_schema."Расписание"("id_расписания");


--
-- TOC entry 3808 (class 2606 OID 17042)
-- Name: Сессия Сессия_id_человека_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Сессия"
    ADD CONSTRAINT "Сессия_id_человека_fkey" FOREIGN KEY ("id_человека") REFERENCES session_schema."Человек"("id_человека");


--
-- TOC entry 3797 (class 2606 OID 16966)
-- Name: Студент Студент_id_человека_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Студент"
    ADD CONSTRAINT "Студент_id_человека_fkey" FOREIGN KEY ("id_человека") REFERENCES session_schema."Человек"("id_человека");


--
-- TOC entry 3798 (class 2606 OID 16976)
-- Name: Студент Студент_номер_группы_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Студент"
    ADD CONSTRAINT "Студент_номер_группы_fkey" FOREIGN KEY ("номер_группы") REFERENCES session_schema."Группа"("номер_группы");


--
-- TOC entry 3796 (class 2606 OID 16878)
-- Name: Учебный_план Учебный_план_id_ОП_fkey; Type: FK CONSTRAINT; Schema: session_schema; Owner: postgres
--

ALTER TABLE ONLY session_schema."Учебный_план"
    ADD CONSTRAINT "Учебный_план_id_ОП_fkey" FOREIGN KEY ("id_ОП") REFERENCES session_schema."Образовательная_программа"("id_ОП");


-- Completed on 2026-06-03 21:28:28 MSK

--
-- PostgreSQL database dump complete
--

\unrestrict O72dE3U4abbtROHODFh8hzGuMCq1urJm50IeXRInBQbvK20XhJMEs9caNdFdAYb

