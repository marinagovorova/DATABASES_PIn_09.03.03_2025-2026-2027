--
-- PostgreSQL database dump
--

\restrict vaZJgPtWvRX6gTgl8WHKVX7MxhRCs5R9M28cJV2e9zMYRPVmwHYbF4t696Odhj2

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-06-14 14:35:56

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
-- TOC entry 269 (class 1255 OID 25139)
-- Name: enroll_student(bigint, bigint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.enroll_student(IN p_student_id bigint, IN p_group_id bigint)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_current_count INT;
    v_max_students INT;
    v_group_start DATE;
    v_group_end DATE;
    v_already_enrolled INT;
BEGIN
    -- Проверка: существует ли группа и получаем её лимиты
    SELECT max_students, start_date, end_date
    INTO v_max_students, v_group_start, v_group_end
    FROM student_group
    WHERE id = p_group_id;

    IF NOT FOUND THEN
        RAISE NOTICE 'Ошибка: группа с ID % не найдена', p_group_id;
        RETURN;
    END IF;

    -- Проверка: существует ли студент
    IF NOT EXISTS (SELECT 1 FROM student WHERE id = p_student_id) THEN
        RAISE NOTICE 'Ошибка: студент с ID % не найден', p_student_id;
        RETURN;
    END IF;

    -- Проверка: не записан ли уже
    SELECT COUNT(*) INTO v_already_enrolled
    FROM student_in_group
    WHERE student_id = p_student_id AND group_id = p_group_id;

    IF v_already_enrolled > 0 THEN
        RAISE NOTICE 'Ошибка: студент уже записан в эту группу';
        RETURN;
    END IF;

    -- Проверка: не превышен ли лимит
    SELECT COUNT(*) INTO v_current_count
    FROM student_in_group
    WHERE group_id = p_group_id;

    IF v_current_count >= v_max_students THEN
        RAISE NOTICE 'Ошибка: группа заполнена (максимум: %)', v_max_students;
        RETURN;
    END IF;

    -- Запись студента
    INSERT INTO student_in_group (student_id, group_id, start_date, end_date)
    VALUES (p_student_id, p_group_id, v_group_start, v_group_end);

    RAISE NOTICE 'Студент % успешно записан в группу %', p_student_id, p_group_id;
END;
$$;


ALTER PROCEDURE public.enroll_student(IN p_student_id bigint, IN p_group_id bigint) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 25150)
-- Name: get_free_lecture_rooms(integer, refcursor); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.get_free_lecture_rooms(IN p_day_of_week integer, INOUT ref refcursor)
    LANGUAGE plpgsql
    AS $$
BEGIN
    OPEN ref FOR
        SELECT c.id, c.room_number, loc.name AS location, loc.address
        FROM classroom c
        JOIN location loc ON loc.id = c.location_id
        WHERE c.type = 'лекционная'
          AND c.id NOT IN (
              SELECT l.classroom_id
              FROM lesson l
              WHERE EXTRACT(DOW FROM l.lesson_date) = p_day_of_week
          )
        ORDER BY loc.name, c.room_number;
END;
$$;


ALTER PROCEDURE public.get_free_lecture_rooms(IN p_day_of_week integer, INOUT ref refcursor) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 25147)
-- Name: get_free_lecture_rooms(integer, time without time zone, refcursor); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.get_free_lecture_rooms(IN p_day_of_week integer, IN p_time time without time zone, INOUT ref refcursor)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_free_count INT;
BEGIN
    SELECT COUNT(*) INTO v_free_count
    FROM classroom c
    WHERE c.type = 'лекционная'
      AND NOT EXISTS (
          SELECT 1
          FROM lesson l
          WHERE l.classroom_id = c.id
            AND EXTRACT(DOW FROM l.lesson_date) = p_day_of_week
            AND l.lesson_date::TIME < (p_time + INTERVAL '1 hour 30 minutes')
            AND (l.lesson_date::TIME + INTERVAL '1 hour 30 minutes') > p_time
      );

    IF v_free_count = 0 THEN
        RAISE NOTICE 'Свободных лекционных аудиторий нет';
    ELSE
        RAISE NOTICE 'Найдено свободных аудиторий: %', v_free_count;
    END IF;

    OPEN ref FOR
        SELECT c.room_number, loc.name AS location, loc.address
        FROM classroom c
        JOIN location loc ON loc.id = c.location_id
        WHERE c.type = 'лекционная'
          AND NOT EXISTS (
              SELECT 1
              FROM lesson l
              WHERE l.classroom_id = c.id
                AND EXTRACT(DOW FROM l.lesson_date) = p_day_of_week
                AND l.lesson_date::TIME < (p_time + INTERVAL '1 hour 30 minutes')
                AND (l.lesson_date::TIME + INTERVAL '1 hour 30 minutes') > p_time
          )
        ORDER BY loc.name, c.room_number;
END;
$$;


ALTER PROCEDURE public.get_free_lecture_rooms(IN p_day_of_week integer, IN p_time time without time zone, INOUT ref refcursor) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 25138)
-- Name: get_group_schedule_by_day(character varying, integer, refcursor); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.get_group_schedule_by_day(IN p_group_number character varying, IN p_day_of_week integer, INOUT ref refcursor)
    LANGUAGE plpgsql
    AS $$
BEGIN
    OPEN ref FOR
        SELECT
            sg.group_number,
            l.lesson_date::DATE AS lesson_date,
            lt.name AS lesson_type,
            c.room_number,
            loc.name AS location,
            t.last_name || ' ' || t.first_name AS teacher_name,
            d.description AS discipline
        FROM lesson l
        JOIN classroom c ON c.id = l.classroom_id
        JOIN location loc ON loc.id = c.location_id
        JOIN lesson_type lt ON lt.id = l.lesson_type_id
        JOIN group_lesson_teacher glt ON glt.lesson_id = l.id
        JOIN teacher t ON t.id = glt.teacher_id
        JOIN student_group sg ON sg.id = glt.group_id
        LEFT JOIN discipline d ON d.id = l.discipline_id
        WHERE sg.group_number = p_group_number
          AND EXTRACT(DOW FROM l.lesson_date) = p_day_of_week
        ORDER BY l.lesson_date;
END;
$$;


ALTER PROCEDURE public.get_group_schedule_by_day(IN p_group_number character varying, IN p_day_of_week integer, INOUT ref refcursor) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 17360)
-- Name: get_schedule_by_day(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_schedule_by_day(p_day_of_week integer) RETURNS TABLE(group_number character varying, lesson_date date, lesson_type character varying, room_number character varying, location character varying, teacher text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT sg.group_number, l.lesson_date, lt.name, 
           c.room_number, loc.name, t.last_name || ' ' || t.first_name
    FROM lesson l
    JOIN classroom c ON c.id = l.classroom_id
    JOIN location loc ON loc.id = c.location_id
    JOIN lesson_type lt ON lt.id = l.lesson_type_id
    JOIN group_lesson_teacher glt ON glt.lesson_id = l.id
    JOIN teacher t ON t.id = glt.teacher_id
    JOIN student_group sg ON sg.id = glt.group_id
    WHERE EXTRACT(DOW FROM l.lesson_date) = p_day_of_week
    ORDER BY sg.group_number, l.lesson_date;
END;
$$;


ALTER FUNCTION public.get_schedule_by_day(p_day_of_week integer) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 25184)
-- Name: trg_auto_fill_dates(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_auto_fill_dates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.start_date IS NULL OR NEW.end_date IS NULL THEN
        SELECT start_date, end_date
        INTO NEW.start_date, NEW.end_date
        FROM student_group
        WHERE id = NEW.group_id;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_auto_fill_dates() OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 25188)
-- Name: trg_check_classroom_busy(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_check_classroom_busy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM lesson
        WHERE classroom_id = NEW.classroom_id
          AND lesson_date = NEW.lesson_date
          AND id != NEW.id
    ) THEN
        RAISE EXCEPTION 'Аудитория занята в это время';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_check_classroom_busy() OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 25166)
-- Name: trg_check_max_students(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_check_max_students() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_current INT;
    v_max INT;
BEGIN
    SELECT COUNT(*), sg.max_students
    INTO v_current, v_max
    FROM student_in_group sig
    JOIN student_group sg ON sg.id = sig.group_id
    WHERE sig.group_id = NEW.group_id
    GROUP BY sg.max_students;

    IF v_current >= v_max THEN
        RAISE EXCEPTION 'Группа заполнена (максимум: %)', v_max;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_check_max_students() OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 25180)
-- Name: trg_check_student_dates(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_check_student_dates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_group_start DATE;
    v_group_end DATE;
BEGIN
    SELECT start_date, end_date
    INTO v_group_start, v_group_end
    FROM student_group
    WHERE id = NEW.group_id;

    IF NEW.start_date < v_group_start OR NEW.end_date > v_group_end THEN
        RAISE EXCEPTION 'Даты студента (%) выходят за рамки дат группы (% – %)',
            NEW.start_date || ' – ' || NEW.end_date,
            v_group_start, v_group_end;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_check_student_dates() OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 25182)
-- Name: trg_check_teacher_discipline(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_check_teacher_discipline() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_discipline_id BIGINT;
BEGIN
    SELECT discipline_id INTO v_discipline_id
    FROM lesson
    WHERE id = NEW.lesson_id;

    IF v_discipline_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM teacher_discipline
        WHERE teacher_id = NEW.teacher_id AND discipline_id = v_discipline_id
    ) THEN
        RAISE EXCEPTION 'Преподаватель % не может вести эту дисциплину', NEW.teacher_id;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_check_teacher_discipline() OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 25178)
-- Name: trg_lesson_audit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_lesson_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO lesson_audit (lesson_id, old_date, new_date, old_classroom_id, new_classroom_id)
    VALUES (OLD.id, OLD.lesson_date, NEW.lesson_date, OLD.classroom_id, NEW.classroom_id);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_lesson_audit() OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 25186)
-- Name: trg_prevent_group_delete(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_prevent_group_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM student_in_group
    WHERE group_id = OLD.id;

    IF v_count > 0 THEN
        RAISE EXCEPTION 'Нельзя удалить группу, в которой есть студенты (сейчас: %)', v_count;
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION public.trg_prevent_group_delete() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 16647)
-- Name: attestation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attestation (
    format character varying(50) NOT NULL,
    att_date date NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.attestation OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 17068)
-- Name: attestation_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attestation_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attestation_new_id_seq OWNER TO postgres;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 242
-- Name: attestation_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attestation_new_id_seq OWNED BY public.attestation.id;


--
-- TOC entry 225 (class 1259 OID 16483)
-- Name: classroom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classroom (
    room_number character varying(30) NOT NULL,
    type character varying(50) NOT NULL,
    location_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.classroom OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 17086)
-- Name: classroom_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classroom_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.classroom_new_id_seq OWNER TO postgres;

--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 244
-- Name: classroom_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classroom_new_id_seq OWNED BY public.classroom.id;


--
-- TOC entry 222 (class 1259 OID 16439)
-- Name: discipline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discipline (
    description character varying(1000) NOT NULL,
    hours_volume_id bigint NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.discipline OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16656)
-- Name: discipline_attestation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discipline_attestation (
    discipline_id bigint NOT NULL,
    attestation_id bigint NOT NULL
);


ALTER TABLE public.discipline_attestation OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17050)
-- Name: discipline_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.discipline_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.discipline_new_id_seq OWNER TO postgres;

--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 241
-- Name: discipline_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.discipline_new_id_seq OWNED BY public.discipline.id;


--
-- TOC entry 233 (class 1259 OID 16609)
-- Name: document_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document_type (
    type_name character varying(100) NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.document_type OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17162)
-- Name: document_type_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.document_type_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.document_type_new_id_seq OWNER TO postgres;

--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 250
-- Name: document_type_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.document_type_new_id_seq OWNED BY public.document_type.id;


--
-- TOC entry 234 (class 1259 OID 16618)
-- Name: graduation_document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.graduation_document (
    program_id bigint NOT NULL,
    document_type_id bigint NOT NULL,
    student_id bigint NOT NULL,
    doc_number integer NOT NULL,
    issue_date date NOT NULL,
    id bigint NOT NULL,
    CONSTRAINT graduation_document_doc_number_check CHECK ((doc_number > 0))
);


ALTER TABLE public.graduation_document OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17171)
-- Name: graduation_document_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.graduation_document_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.graduation_document_new_id_seq OWNER TO postgres;

--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 251
-- Name: graduation_document_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.graduation_document_new_id_seq OWNED BY public.graduation_document.id;


--
-- TOC entry 237 (class 1259 OID 16673)
-- Name: group_lesson_teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_lesson_teacher (
    group_id bigint NOT NULL,
    lesson_id bigint NOT NULL,
    teacher_id bigint NOT NULL
);


ALTER TABLE public.group_lesson_teacher OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16423)
-- Name: hours_volume; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hours_volume (
    lectures integer NOT NULL,
    lab_works integer NOT NULL,
    practical integer NOT NULL,
    internship integer NOT NULL,
    id bigint NOT NULL,
    CONSTRAINT hours_volume_internship_check CHECK ((internship >= 0)),
    CONSTRAINT hours_volume_lab_works_check CHECK ((lab_works >= 0)),
    CONSTRAINT hours_volume_lectures_check CHECK ((lectures >= 0)),
    CONSTRAINT hours_volume_practical_check CHECK ((practical >= 0))
);


ALTER TABLE public.hours_volume OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 17041)
-- Name: hours_volume_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hours_volume_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hours_volume_new_id_seq OWNER TO postgres;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 240
-- Name: hours_volume_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hours_volume_new_id_seq OWNED BY public.hours_volume.id;


--
-- TOC entry 227 (class 1259 OID 16508)
-- Name: lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson (
    classroom_id bigint NOT NULL,
    lesson_type_id bigint NOT NULL,
    id bigint NOT NULL,
    lesson_date timestamp without time zone NOT NULL,
    discipline_id bigint
);


ALTER TABLE public.lesson OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 25169)
-- Name: lesson_audit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson_audit (
    id integer NOT NULL,
    lesson_id bigint NOT NULL,
    changed_at timestamp without time zone DEFAULT now(),
    old_date timestamp without time zone,
    new_date timestamp without time zone,
    old_classroom_id bigint,
    new_classroom_id bigint
);


ALTER TABLE public.lesson_audit OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 25168)
-- Name: lesson_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lesson_audit_id_seq OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 254
-- Name: lesson_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_audit_id_seq OWNED BY public.lesson_audit.id;


--
-- TOC entry 246 (class 1259 OID 17109)
-- Name: lesson_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lesson_new_id_seq OWNER TO postgres;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 246
-- Name: lesson_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_new_id_seq OWNED BY public.lesson.id;


--
-- TOC entry 226 (class 1259 OID 16499)
-- Name: lesson_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson_type (
    name character varying(30) NOT NULL,
    id bigint NOT NULL,
    CONSTRAINT lesson_type_name_check CHECK (((name)::text = ANY ((ARRAY['лекция'::character varying, 'лабораторная работа'::character varying, 'практическое занятие'::character varying])::text[])))
);


ALTER TABLE public.lesson_type OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 17100)
-- Name: lesson_type_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_type_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lesson_type_new_id_seq OWNER TO postgres;

--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 245
-- Name: lesson_type_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_type_new_id_seq OWNED BY public.lesson_type.id;


--
-- TOC entry 224 (class 1259 OID 16473)
-- Name: location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location (
    name character varying(50) NOT NULL,
    address character varying(1000) NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.location OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17077)
-- Name: location_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.location_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.location_new_id_seq OWNER TO postgres;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 243
-- Name: location_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.location_new_id_seq OWNED BY public.location.id;


--
-- TOC entry 220 (class 1259 OID 16401)
-- Name: program; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program (
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(1000),
    total_hours integer NOT NULL,
    cost integer NOT NULL,
    program_type_id bigint NOT NULL,
    id bigint NOT NULL,
    CONSTRAINT program_cost_check CHECK ((cost >= 0)),
    CONSTRAINT program_total_hours_check CHECK ((total_hours >= 0))
);


ALTER TABLE public.program OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16455)
-- Name: program_discipline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_discipline (
    discipline_id bigint NOT NULL,
    program_id bigint NOT NULL
);


ALTER TABLE public.program_discipline OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17023)
-- Name: program_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.program_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.program_new_id_seq OWNER TO postgres;

--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 239
-- Name: program_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.program_new_id_seq OWNED BY public.program.id;


--
-- TOC entry 219 (class 1259 OID 16392)
-- Name: program_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_type (
    type_name character varying(100) NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.program_type OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17014)
-- Name: program_type_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.program_type_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.program_type_new_id_seq OWNER TO postgres;

--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 238
-- Name: program_type_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.program_type_new_id_seq OWNED BY public.program_type.id;


--
-- TOC entry 228 (class 1259 OID 16529)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    middle_name character varying(100),
    phone character varying(30) NOT NULL,
    passport character varying(30) NOT NULL,
    education character varying(30),
    id bigint NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16573)
-- Name: student_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_group (
    program_id bigint NOT NULL,
    max_students integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    group_number character varying(30) NOT NULL,
    id bigint NOT NULL,
    CONSTRAINT student_group_dates_check CHECK ((start_date <= end_date)),
    CONSTRAINT student_group_max_students_check CHECK ((max_students > 0))
);


ALTER TABLE public.student_group OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17148)
-- Name: student_group_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_group_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_group_new_id_seq OWNER TO postgres;

--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 249
-- Name: student_group_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_group_new_id_seq OWNED BY public.student_group.id;


--
-- TOC entry 232 (class 1259 OID 16591)
-- Name: student_in_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_in_group (
    student_id bigint NOT NULL,
    group_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    CONSTRAINT student_in_group_dates_check CHECK ((start_date <= end_date))
);


ALTER TABLE public.student_in_group OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17128)
-- Name: student_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_new_id_seq OWNER TO postgres;

--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 247
-- Name: student_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_new_id_seq OWNED BY public.student.id;


--
-- TOC entry 229 (class 1259 OID 16541)
-- Name: teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher (
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    middle_name character varying(100),
    phone character varying(30) NOT NULL,
    passport character varying(30) NOT NULL,
    "position" character varying(200) NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.teacher OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16555)
-- Name: teacher_discipline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_discipline (
    discipline_id bigint NOT NULL,
    teacher_id bigint NOT NULL
);


ALTER TABLE public.teacher_discipline OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 17137)
-- Name: teacher_new_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teacher_new_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teacher_new_id_seq OWNER TO postgres;

--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 248
-- Name: teacher_new_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teacher_new_id_seq OWNED BY public.teacher.id;


--
-- TOC entry 253 (class 1259 OID 17353)
-- Name: view_program_income; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_program_income AS
 SELECT p.id,
    p.name,
    p.cost,
    count(DISTINCT sig.student_id) AS student_count,
    (p.cost * count(DISTINCT sig.student_id)) AS total_income
   FROM ((public.program p
     JOIN public.student_group sg ON ((sg.program_id = p.id)))
     JOIN public.student_in_group sig ON ((sig.group_id = sg.id)))
  WHERE (sig.start_date >= (date_trunc('year'::text, (CURRENT_DATE)::timestamp with time zone) - '1 year'::interval))
  GROUP BY p.id, p.name, p.cost;


ALTER VIEW public.view_program_income OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 17348)
-- Name: view_programs_disciplines; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_programs_disciplines AS
 SELECT p.name AS program_name,
    d.description AS discipline_name,
    (((h.lectures + h.lab_works) + h.practical) + h.internship) AS total_hours
   FROM (((public.program p
     JOIN public.program_discipline pd ON ((pd.program_id = p.id)))
     JOIN public.discipline d ON ((d.id = pd.discipline_id)))
     JOIN public.hours_volume h ON ((h.id = d.hours_volume_id)));


ALTER VIEW public.view_programs_disciplines OWNER TO postgres;

--
-- TOC entry 4878 (class 2604 OID 17069)
-- Name: attestation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attestation ALTER COLUMN id SET DEFAULT nextval('public.attestation_new_id_seq'::regclass);


--
-- TOC entry 4870 (class 2604 OID 17087)
-- Name: classroom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom ALTER COLUMN id SET DEFAULT nextval('public.classroom_new_id_seq'::regclass);


--
-- TOC entry 4868 (class 2604 OID 17051)
-- Name: discipline id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline ALTER COLUMN id SET DEFAULT nextval('public.discipline_new_id_seq'::regclass);


--
-- TOC entry 4876 (class 2604 OID 17163)
-- Name: document_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_type ALTER COLUMN id SET DEFAULT nextval('public.document_type_new_id_seq'::regclass);


--
-- TOC entry 4877 (class 2604 OID 17172)
-- Name: graduation_document id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduation_document ALTER COLUMN id SET DEFAULT nextval('public.graduation_document_new_id_seq'::regclass);


--
-- TOC entry 4867 (class 2604 OID 17042)
-- Name: hours_volume id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hours_volume ALTER COLUMN id SET DEFAULT nextval('public.hours_volume_new_id_seq'::regclass);


--
-- TOC entry 4872 (class 2604 OID 17110)
-- Name: lesson id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN id SET DEFAULT nextval('public.lesson_new_id_seq'::regclass);


--
-- TOC entry 4879 (class 2604 OID 25172)
-- Name: lesson_audit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_audit ALTER COLUMN id SET DEFAULT nextval('public.lesson_audit_id_seq'::regclass);


--
-- TOC entry 4871 (class 2604 OID 17101)
-- Name: lesson_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_type ALTER COLUMN id SET DEFAULT nextval('public.lesson_type_new_id_seq'::regclass);


--
-- TOC entry 4869 (class 2604 OID 17078)
-- Name: location id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location ALTER COLUMN id SET DEFAULT nextval('public.location_new_id_seq'::regclass);


--
-- TOC entry 4866 (class 2604 OID 17024)
-- Name: program id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program ALTER COLUMN id SET DEFAULT nextval('public.program_new_id_seq'::regclass);


--
-- TOC entry 4865 (class 2604 OID 17015)
-- Name: program_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_type ALTER COLUMN id SET DEFAULT nextval('public.program_type_new_id_seq'::regclass);


--
-- TOC entry 4873 (class 2604 OID 17129)
-- Name: student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_new_id_seq'::regclass);


--
-- TOC entry 4875 (class 2604 OID 17149)
-- Name: student_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_group ALTER COLUMN id SET DEFAULT nextval('public.student_group_new_id_seq'::regclass);


--
-- TOC entry 4874 (class 2604 OID 17138)
-- Name: teacher id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher ALTER COLUMN id SET DEFAULT nextval('public.teacher_new_id_seq'::regclass);


--
-- TOC entry 5133 (class 0 OID 16647)
-- Dependencies: 235
-- Data for Name: attestation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attestation (format, att_date, id) FROM stdin;
экзамен	2027-03-03	1
дифзачет	2026-05-13	2
зачет	2025-06-16	3
\.


--
-- TOC entry 5123 (class 0 OID 16483)
-- Dependencies: 225
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classroom (room_number, type, location_id, id) FROM stdin;
295	обычная	3	1
214	лабораторная	4	2
453	обычная	4	3
363	обычная	1	4
207	компьютерная	1	5
469	обычная	3	6
251	обычная	3	7
388	лабораторная	1	8
105	компьютерная	2	9
434	лекционная	3	10
282	лабораторная	3	11
364	лекционная	1	12
252	лекционная	3	13
103	компьютерная	4	14
251	компьютерная	4	15
372	лекционная	1	16
119	компьютерная	2	17
261	лекционная	2	18
482	компьютерная	2	19
499	лабораторная	3	20
175	компьютерная	3	21
434	компьютерная	1	22
215	лекционная	3	23
492	лекционная	2	24
156	лекционная	4	25
478	лекционная	3	26
415	обычная	2	27
381	обычная	1	28
402	лабораторная	1	29
190	лабораторная	3	30
\.


--
-- TOC entry 5120 (class 0 OID 16439)
-- Dependencies: 222
-- Data for Name: discipline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discipline (description, hours_volume_id, id) FROM stdin;
Основы Python	1	1
Базы данных SQL	2	2
Веб-разработка	3	3
Алгоритмы и структуры данных	4	4
Linux администрирование	5	5
Сетевое программирование	6	6
Машинное обучение	7	7
Кибербезопасность	8	8
DevOps и CI/CD	9	9
Docker и контейнеризация	10	10
Java Core	11	11
Фронтенд на React	12	12
Бэкенд на Node.js	13	13
Мобильная разработка	14	14
Тестирование ПО	15	15
Облачные технологии AWS	16	16
Big Data	17	17
Микросервисная архитектура	18	18
Git и командная работа	19	19
Английский для IT	20	20
\.


--
-- TOC entry 5134 (class 0 OID 16656)
-- Dependencies: 236
-- Data for Name: discipline_attestation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discipline_attestation (discipline_id, attestation_id) FROM stdin;
1	2
2	2
3	2
4	1
5	2
6	1
7	2
8	3
9	1
10	3
11	2
12	3
13	2
14	3
15	1
16	3
17	2
18	1
19	3
20	3
\.


--
-- TOC entry 5131 (class 0 OID 16609)
-- Dependencies: 233
-- Data for Name: document_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_type (type_name, id) FROM stdin;
Сертификат	1
Удостоверение	2
Диплом	3
\.


--
-- TOC entry 5132 (class 0 OID 16618)
-- Dependencies: 234
-- Data for Name: graduation_document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.graduation_document (program_id, document_type_id, student_id, doc_number, issue_date, id) FROM stdin;
2	2	75	6194	2025-07-16	1
8	2	80	5519	2026-02-11	2
1	3	66	8953	2026-03-02	3
8	2	10	2630	2026-01-13	4
3	2	96	1917	2025-07-01	5
4	1	90	2440	2026-06-08	6
5	3	51	6474	2025-11-05	7
9	3	96	3539	2025-12-25	8
4	2	66	2124	2026-05-04	9
8	3	41	6573	2025-12-01	10
7	2	63	3281	2026-01-27	11
4	1	75	2519	2025-06-21	12
10	2	76	4967	2025-08-11	13
5	1	75	7997	2025-11-30	14
7	1	63	6783	2025-12-02	15
4	3	2	2910	2026-06-13	16
2	2	87	9777	2026-03-31	17
1	3	3	6590	2025-09-13	18
5	1	64	1799	2025-08-23	19
4	1	73	3167	2026-02-26	20
9	3	3	2008	2025-10-12	21
6	1	19	3421	2025-09-01	22
6	3	60	8600	2025-12-17	23
2	2	92	5973	2025-12-29	24
4	3	66	2901	2026-01-01	25
3	3	10	4022	2025-12-23	26
3	3	66	9467	2026-01-12	27
3	1	61	1259	2025-08-17	28
3	3	98	3399	2026-01-08	29
9	2	73	4782	2026-02-01	30
\.


--
-- TOC entry 5135 (class 0 OID 16673)
-- Dependencies: 237
-- Data for Name: group_lesson_teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_lesson_teacher (group_id, lesson_id, teacher_id) FROM stdin;
14	1	13
3	2	12
12	3	13
10	3	1
1	4	5
5	4	5
11	5	20
9	5	8
11	6	4
1	6	19
10	7	16
5	8	16
6	8	2
10	9	3
6	9	8
5	10	1
11	10	19
10	11	15
11	11	3
8	12	20
3	12	9
3	13	3
2	13	14
13	14	15
4	15	11
10	16	2
12	16	5
6	17	4
15	18	7
13	18	16
6	19	19
10	20	8
6	20	5
6	21	19
6	22	16
9	22	4
5	23	18
13	24	15
8	24	5
7	25	10
2	26	8
8	26	13
6	27	13
12	27	19
15	28	19
8	29	1
15	30	14
10	30	11
7	31	16
4	31	5
14	32	15
1	32	17
9	33	6
14	33	1
15	34	15
10	34	14
14	35	4
11	36	5
4	37	9
7	38	9
7	39	2
1	40	4
13	41	12
7	41	5
5	42	7
13	43	2
15	43	16
4	44	15
1	44	8
10	45	11
13	46	11
9	46	6
3	47	2
7	47	11
15	48	19
6	49	15
5	50	4
1	50	16
4	51	16
8	51	20
4	52	7
12	53	19
1	54	4
2	54	7
7	55	11
14	56	14
10	57	18
2	58	5
8	59	19
4	60	20
12	61	18
1	61	17
11	62	17
12	63	12
1	63	15
8	64	11
4	64	3
5	65	11
2	65	9
14	66	9
10	66	6
8	67	19
5	68	17
11	69	5
14	69	20
7	70	19
15	70	13
14	71	6
6	71	15
6	72	3
4	72	7
11	73	1
10	73	18
12	74	7
2	74	12
15	75	14
15	76	13
2	77	15
3	78	10
5	78	8
7	79	13
11	79	18
14	80	10
10	80	19
2	81	20
14	81	20
8	82	12
4	82	8
7	83	7
4	83	17
1	84	7
8	85	4
2	86	16
4	87	19
12	87	2
2	88	7
12	89	10
15	89	11
3	90	5
4	90	16
5	91	2
12	91	20
9	92	16
6	93	18
8	94	18
2	95	2
8	96	5
5	96	2
4	97	19
11	97	7
2	98	12
11	98	7
9	99	17
7	99	19
3	100	3
7	101	3
3	102	8
1	103	14
11	103	12
9	104	20
11	105	20
10	106	4
7	106	4
1	107	3
4	107	5
12	108	17
5	109	5
12	109	6
6	110	5
8	111	13
10	112	10
15	113	14
8	114	12
10	115	6
3	115	10
11	116	8
6	116	1
2	117	4
6	118	15
1	118	12
12	119	19
13	120	10
12	120	20
14	121	12
8	121	17
5	122	18
11	122	1
9	123	16
6	124	6
3	125	8
6	125	6
4	126	14
6	126	13
1	127	1
3	128	1
4	129	13
3	129	1
5	130	11
3	131	6
8	132	3
3	132	16
4	133	1
6	134	16
5	135	8
13	135	18
7	136	19
4	136	15
2	137	17
5	137	6
2	138	4
3	138	15
6	139	19
11	140	12
12	140	11
1	141	3
14	142	12
5	143	15
4	143	6
14	144	7
11	145	10
15	146	5
10	147	17
1	148	2
1	149	17
13	150	4
4	150	11
3	151	1
10	151	7
5	152	19
7	153	9
8	153	17
11	154	7
13	154	4
14	155	13
15	155	12
6	156	6
4	157	9
3	158	6
1	158	15
9	159	8
3	159	10
6	160	20
7	161	7
11	162	9
14	163	7
13	163	5
2	164	6
13	165	6
4	165	6
1	166	14
6	166	20
15	167	4
4	168	15
13	169	1
11	170	5
13	170	15
15	171	3
9	172	20
4	172	4
15	173	1
5	173	12
7	174	18
4	174	20
14	175	12
5	176	3
10	177	11
14	178	15
6	178	18
15	179	12
1	179	16
11	180	2
3	180	10
7	181	3
12	182	13
9	183	19
2	184	16
7	184	9
9	185	6
14	185	5
12	186	11
15	186	13
11	187	4
3	187	19
9	188	10
9	189	15
2	189	10
4	190	14
4	191	10
12	192	9
10	193	15
13	193	11
6	194	8
6	195	18
2	195	2
14	196	15
3	197	15
15	198	2
1	198	3
14	199	13
2	200	20
6	200	8
\.


--
-- TOC entry 5119 (class 0 OID 16423)
-- Dependencies: 221
-- Data for Name: hours_volume; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hours_volume (lectures, lab_works, practical, internship, id) FROM stdin;
32	32	8	32	1
24	8	8	0	2
8	8	8	0	3
8	16	24	0	4
32	24	16	32	5
24	16	8	16	6
24	8	16	0	7
16	24	24	0	8
16	16	16	16	9
24	16	24	16	10
24	8	8	0	11
24	8	24	0	12
32	24	8	16	13
16	16	24	16	14
8	32	8	16	15
32	24	24	16	16
8	24	24	16	17
32	16	8	32	18
16	24	16	32	19
24	24	24	16	20
\.


--
-- TOC entry 5125 (class 0 OID 16508)
-- Dependencies: 227
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson (classroom_id, lesson_type_id, id, lesson_date, discipline_id) FROM stdin;
26	1	1	2026-05-09 10:00:00	11
14	1	2	2026-04-27 16:30:00	12
16	2	3	2026-08-06 14:00:00	15
6	3	4	2026-04-25 11:00:00	4
22	1	5	2026-07-08 16:00:00	3
2	1	6	2026-04-28 09:00:00	9
4	1	7	2026-06-25 16:30:00	2
9	3	8	2026-07-27 16:00:00	6
23	3	9	2026-08-10 16:00:00	7
9	1	10	2026-05-07 09:00:00	17
3	3	11	2026-05-09 14:30:00	4
11	1	12	2026-06-10 16:30:00	9
24	2	13	2026-04-28 09:30:00	1
7	1	14	2026-06-01 11:00:00	13
5	3	15	2026-07-24 16:30:00	3
7	3	16	2026-05-02 14:00:00	13
1	1	17	2026-04-19 09:00:00	11
25	3	18	2026-06-01 11:00:00	4
7	1	19	2026-05-09 16:30:00	9
9	1	20	2026-06-22 14:30:00	2
26	3	21	2026-05-17 16:30:00	18
2	3	22	2026-05-15 14:00:00	13
27	1	23	2026-06-03 16:30:00	19
30	3	24	2026-07-07 14:30:00	13
1	1	25	2026-07-22 09:00:00	6
4	2	26	2026-05-21 16:00:00	8
5	1	27	2026-06-13 09:30:00	13
7	2	28	2026-07-02 09:00:00	12
13	1	29	2026-05-03 09:00:00	14
5	1	30	2026-04-17 09:30:00	7
7	3	31	2026-07-22 16:30:00	20
6	3	32	2026-07-28 16:00:00	15
2	1	33	2026-06-25 14:30:00	11
8	3	34	2026-05-17 14:00:00	12
21	1	35	2026-05-27 16:00:00	20
11	3	36	2026-06-21 09:30:00	15
15	3	37	2026-05-07 14:00:00	13
9	3	38	2026-04-23 11:30:00	8
24	3	39	2026-06-01 11:00:00	18
21	2	40	2026-06-08 09:30:00	2
12	1	41	2026-07-25 16:30:00	8
29	2	42	2026-04-19 14:30:00	16
7	2	43	2026-08-05 14:30:00	3
2	3	44	2026-08-11 14:30:00	5
12	1	45	2026-04-23 16:30:00	4
21	1	46	2026-05-12 16:00:00	5
10	1	47	2026-07-02 14:30:00	7
8	3	48	2026-07-08 09:30:00	5
18	1	49	2026-06-09 09:30:00	2
3	3	50	2026-05-20 14:00:00	1
28	1	51	2026-05-29 11:30:00	19
20	1	52	2026-06-10 11:30:00	2
6	1	53	2026-06-04 11:30:00	5
21	1	54	2026-07-17 11:30:00	9
2	3	55	2026-07-28 09:30:00	11
28	1	56	2026-08-11 14:00:00	17
22	3	57	2026-07-23 16:30:00	6
27	2	58	2026-06-12 16:00:00	8
10	3	59	2026-06-21 11:00:00	14
11	1	60	2026-07-10 14:00:00	13
28	3	61	2026-07-03 11:00:00	12
21	2	62	2026-07-06 16:30:00	8
4	2	63	2026-04-29 16:00:00	13
17	3	64	2026-04-18 16:00:00	11
25	3	65	2026-08-07 09:00:00	10
30	1	66	2026-05-19 09:30:00	18
14	1	67	2026-06-25 16:30:00	11
26	3	68	2026-04-30 16:00:00	20
29	2	69	2026-07-25 11:30:00	15
22	1	70	2026-06-10 14:30:00	4
21	1	71	2026-06-02 16:00:00	13
19	2	72	2026-04-21 11:30:00	6
14	2	73	2026-08-08 09:30:00	10
8	2	74	2026-06-21 16:30:00	8
19	3	75	2026-07-02 16:30:00	6
25	1	76	2026-04-26 09:00:00	10
26	2	77	2026-05-05 09:00:00	17
3	3	78	2026-07-23 09:30:00	10
3	2	79	2026-05-23 11:00:00	16
5	3	80	2026-04-25 14:00:00	17
21	2	81	2026-05-16 09:00:00	10
14	1	82	2026-06-05 16:30:00	2
7	3	83	2026-06-17 11:30:00	3
23	1	84	2026-08-12 11:00:00	1
10	1	85	2026-04-15 16:00:00	15
24	3	86	2026-07-10 09:30:00	14
14	3	87	2026-04-30 14:30:00	15
22	2	88	2026-05-26 14:30:00	17
4	3	89	2026-05-16 16:00:00	18
19	3	90	2026-05-27 11:00:00	10
12	2	91	2026-07-19 09:30:00	16
15	3	92	2026-07-28 11:30:00	13
4	2	93	2026-07-15 11:30:00	4
3	3	94	2026-05-29 16:00:00	16
20	3	95	2026-05-06 09:00:00	1
17	1	96	2026-07-25 09:30:00	7
15	2	97	2026-05-18 14:00:00	19
24	1	98	2026-04-17 16:00:00	15
3	1	99	2026-05-04 09:00:00	7
17	3	100	2026-05-27 11:00:00	14
21	1	101	2026-08-06 14:30:00	6
13	3	102	2026-06-21 16:30:00	14
27	1	103	2026-08-06 11:30:00	4
17	3	104	2026-07-08 09:00:00	12
23	1	105	2026-05-23 09:00:00	6
26	2	106	2026-08-02 14:00:00	7
25	1	107	2026-07-24 14:30:00	8
1	2	108	2026-07-19 11:30:00	5
18	2	109	2026-07-18 16:00:00	7
24	1	110	2026-05-16 09:30:00	18
4	1	111	2026-06-09 14:30:00	5
9	2	112	2026-07-23 16:30:00	5
5	1	113	2026-05-14 14:30:00	18
16	2	114	2026-08-11 09:30:00	7
9	3	115	2026-06-23 11:00:00	18
20	2	116	2026-05-26 11:00:00	5
12	1	117	2026-07-21 09:30:00	18
2	2	118	2026-08-03 14:30:00	16
9	1	119	2026-07-04 16:00:00	19
22	3	120	2026-04-16 11:30:00	10
28	3	121	2026-06-25 16:30:00	4
5	2	122	2026-04-27 09:00:00	16
18	3	123	2026-04-28 16:30:00	16
24	3	124	2026-07-10 14:30:00	15
12	2	125	2026-07-11 14:00:00	9
27	3	126	2026-06-06 16:00:00	5
24	3	127	2026-08-10 11:30:00	2
7	1	128	2026-07-31 14:30:00	4
9	3	129	2026-08-12 14:30:00	11
15	1	130	2026-06-10 16:30:00	7
12	3	131	2026-07-29 14:30:00	17
21	2	132	2026-06-27 11:30:00	14
28	3	133	2026-05-06 16:30:00	8
23	1	134	2026-07-15 11:00:00	8
4	1	135	2026-06-12 14:30:00	7
8	2	136	2026-04-19 14:00:00	12
24	2	137	2026-06-26 09:30:00	1
9	2	138	2026-04-22 11:00:00	8
12	2	139	2026-05-12 16:00:00	13
23	3	140	2026-06-05 14:30:00	8
5	1	141	2026-07-06 11:00:00	16
12	1	142	2026-06-02 09:30:00	10
14	1	143	2026-08-09 09:30:00	6
8	1	144	2026-08-09 14:00:00	7
4	3	145	2026-05-04 11:30:00	15
23	3	146	2026-06-13 14:30:00	16
22	3	147	2026-07-23 11:00:00	18
18	1	148	2026-05-25 14:30:00	13
29	3	149	2026-05-12 14:30:00	13
30	3	150	2026-05-06 16:00:00	7
6	2	151	2026-05-30 11:30:00	20
2	2	152	2026-06-24 16:30:00	13
27	1	153	2026-07-11 16:00:00	4
14	1	154	2026-04-25 11:30:00	6
16	3	155	2026-05-06 11:00:00	17
16	1	156	2026-06-23 11:30:00	2
2	2	157	2026-04-26 16:00:00	3
5	3	158	2026-05-11 16:00:00	6
25	1	159	2026-05-13 16:30:00	6
12	2	160	2026-06-10 11:00:00	8
26	3	161	2026-04-27 09:30:00	8
2	3	162	2026-07-11 14:30:00	7
21	3	163	2026-05-15 11:00:00	2
4	3	164	2026-08-01 09:30:00	1
27	2	165	2026-08-02 11:30:00	19
21	2	166	2026-05-03 16:30:00	20
28	2	167	2026-07-25 14:00:00	17
18	3	168	2026-08-10 16:00:00	10
6	2	169	2026-04-24 09:00:00	5
8	3	170	2026-05-22 16:30:00	15
7	3	171	2026-07-31 11:00:00	18
20	2	172	2026-07-05 09:00:00	13
25	1	173	2026-07-23 11:30:00	20
25	3	174	2026-07-15 14:30:00	13
21	2	175	2026-06-24 11:00:00	19
9	1	176	2026-07-25 09:00:00	10
19	3	177	2026-07-27 16:00:00	6
14	3	178	2026-05-12 14:30:00	2
2	1	179	2026-07-16 16:00:00	14
27	2	180	2026-05-24 09:00:00	17
28	3	181	2026-06-04 11:00:00	4
1	1	182	2026-07-02 11:00:00	2
22	3	183	2026-05-29 11:30:00	19
25	2	184	2026-06-05 16:30:00	6
20	3	185	2026-04-25 11:30:00	8
30	3	186	2026-05-06 14:30:00	12
3	3	187	2026-06-22 16:30:00	17
29	1	188	2026-05-09 16:00:00	3
3	3	189	2026-05-29 16:30:00	8
12	2	190	2026-05-23 14:00:00	14
23	2	191	2026-08-10 14:30:00	5
7	2	192	2026-05-10 16:00:00	16
14	1	193	2026-05-27 09:00:00	10
17	2	194	2026-07-16 09:30:00	10
25	3	195	2026-06-07 16:30:00	9
7	3	196	2026-05-30 16:30:00	2
26	1	197	2026-07-20 09:00:00	12
11	2	198	2026-07-16 16:00:00	8
9	1	199	2026-07-20 11:00:00	16
24	2	200	2026-08-09 11:00:00	16
\.


--
-- TOC entry 5151 (class 0 OID 25169)
-- Dependencies: 255
-- Data for Name: lesson_audit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson_audit (id, lesson_id, changed_at, old_date, new_date, old_classroom_id, new_classroom_id) FROM stdin;
1	1	2026-06-14 14:16:51.321573	2026-05-09 10:00:00	2026-05-09 10:00:00	26	26
\.


--
-- TOC entry 5124 (class 0 OID 16499)
-- Dependencies: 226
-- Data for Name: lesson_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson_type (name, id) FROM stdin;
лекция	1
лабораторная работа	2
практическое занятие	3
\.


--
-- TOC entry 5122 (class 0 OID 16473)
-- Dependencies: 224
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location (name, address, id) FROM stdin;
Корпус на Ленина	ул. Ленина, 10	1
Корпус на Мира	пр. Мира, 25	2
Корпус на Гагарина	ул. Гагарина, 5	3
Корпус на Советской	ул. Советская, 88	4
\.


--
-- TOC entry 5118 (class 0 OID 16401)
-- Dependencies: 220
-- Data for Name: program; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program (code, name, description, total_hours, cost, program_type_id, id) FROM stdin;
PY-101	Python разработчик	Курс по Python с нуля до junior	256	45000	1	1
DB-201	Администратор БД	SQL и администрирование PostgreSQL	200	38000	2	2
WEB-301	Fullstack веб-разработчик	React + Node.js	320	60000	2	3
ML-401	Data Science	Python, ML, анализ данных	280	55000	1	4
SEC-501	Специалист по кибербезопасности	Защита сетей и систем	240	50000	2	5
DEV-601	DevOps инженер	CI/CD, Docker, Kubernetes	180	42000	1	6
JAV-701	Java разработчик	Java Core + Spring	300	58000	1	7
MOB-801	Мобильный разработчик	Android/iOS разработка	260	52000	2	8
QA-901	Тестировщик ПО	Manual + Automation testing	160	30000	1	9
ENG-001	IT English	Технический английский	120	20000	3	10
\.


--
-- TOC entry 5121 (class 0 OID 16455)
-- Dependencies: 223
-- Data for Name: program_discipline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program_discipline (discipline_id, program_id) FROM stdin;
4	1
5	1
12	1
17	1
11	2
10	2
15	2
4	2
18	2
1	3
20	3
18	3
6	3
5	3
20	4
8	4
6	4
7	5
13	5
17	5
1	5
17	6
14	6
15	6
2	6
10	6
4	7
7	7
1	7
14	7
8	7
7	8
11	8
9	8
13	8
12	9
14	9
5	9
10	10
1	10
19	10
17	10
12	10
\.


--
-- TOC entry 5117 (class 0 OID 16392)
-- Dependencies: 219
-- Data for Name: program_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program_type (type_name, id) FROM stdin;
Повышение квалификации	1
Профессиональная переподготовка	2
Общеразвивающая программа	3
\.


--
-- TOC entry 5126 (class 0 OID 16529)
-- Dependencies: 228
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (first_name, last_name, middle_name, phone, passport, education, id) FROM stdin;
Кир	Романов	Ильясович	+7 785 445 37 34	2427 500012	среднее	1
Гаврила	Бобров	Адрианович	8 (119) 016-6729	30 54 203344	высшее	2
Ярополк	Туров	Игоревич	8 (888) 706-08-84	7644 861266	среднее	3
Жанна	Макарова	Вячеславовна	8 533 102 1455	2150 118331	неоконченное высшее	4
Татьяна	Стрелкова	Васильевна	+7 (121) 859-65-32	59 88 461748	среднее	5
Евгения	Михеева	Федоровна	8 (410) 121-49-63	99 02 345108	высшее	6
Милица	Дроздова	Вячеславовна	8 966 493 31 90	45 81 508047	высшее	7
Акулина	Прохорова	Михайловна	+76782462503	8915 377737	высшее	8
Марфа	Наумова	Ниловна	+7 (175) 600-7927	90 67 204238	высшее	9
Максим	Лазарев	Федосеевич	8 357 638 61 92	4844 578650	неоконченное высшее	10
Жанна	Боброва	Кузьминична	85445340894	11 68 522793	среднее	11
Иванна	Мясникова	Петровна	8 532 133 3127	26 27 942403	неоконченное высшее	12
Всеволод	Лаврентьев	Викторович	+7 052 933 33 22	91 43 963916	неоконченное высшее	13
Елизар	Панфилов	Валерьянович	8 391 441 22 01	42 82 860659	высшее	14
Януарий	Федотов	Архипович	8 (246) 434-52-50	71 27 941238	неоконченное высшее	15
Екатерина	Одинцова	Викторовна	8 (905) 040-5455	62 18 897593	среднее	16
Жанна	Котова	Вячеславовна	8 (370) 830-4360	4284 391346	неоконченное высшее	17
Зинаида	Селиверстова	Григорьевна	+7 815 899 7740	84 98 494650	неоконченное высшее	18
Фортунат	Никонов	Матвеевич	+7 333 845 96 55	14 48 153761	среднее	19
Юлия	Жукова	Альбертовна	+7 (267) 674-94-31	90 95 432051	среднее	20
Алла	Брагина	Владимировна	+70804433993	44 47 386366	неоконченное высшее	21
Виктор	Андреев	Ефимович	8 296 095 32 54	5399 477533	неоконченное высшее	22
Трофим	Пономарев	Алексеевич	+79132065120	27 33 501912	неоконченное высшее	23
Никон	Туров	Демидович	8 908 958 1476	5299 567016	высшее	24
Владлен	Суворов	Августович	+7 (325) 497-20-26	00 02 279587	высшее	25
Валентин	Кузьмин	Фадеевич	8 (004) 628-1152	8818 299683	высшее	26
Артем	Брагин	Ярославович	8 (804) 220-01-64	24 05 339698	неоконченное высшее	27
Мирослав	Борисов	Викентьевич	8 792 044 14 07	68 22 812669	высшее	28
Куприян	Сафонов	Филатович	+76273272362	4019 264094	неоконченное высшее	29
Аггей	Чернов	Даниилович	+70398946916	66 59 512229	неоконченное высшее	30
Александра	Веселова	Рудольфовна	89408202588	2061 491662	среднее	31
Таисия	Евсеева	Робертовна	+7 (194) 618-35-91	49 59 611081	высшее	32
Тит	Носков	Августович	+7 (745) 271-0953	20 12 598290	высшее	33
Александра	Самсонова	Семеновна	+7 (282) 549-0997	76 33 964106	высшее	34
Юрий	Белозеров	Чеславович	8 579 929 14 14	92 11 914666	неоконченное высшее	35
Любим	Петухов	Марсович	+7 (164) 038-3879	83 62 526815	среднее	36
Татьяна	Копылова	Викторовна	8 096 429 5966	22 23 983321	неоконченное высшее	37
Пелагея	Тетерина	Ефимовна	86672330503	0113 575418	неоконченное высшее	38
Надежда	Котова	Станиславовна	+7 (356) 075-13-63	34 25 614711	высшее	39
Парамон	Лыткин	Арсеньевич	+77211003607	87 47 625667	высшее	40
Евфросиния	Федотова	Игоревна	82996941578	93 64 371187	неоконченное высшее	41
Трофим	Мухин	Димитриевич	8 481 811 6746	2544 532928	среднее	42
Тихон	Воробьев	Валерьянович	8 (570) 076-42-18	21 59 192812	высшее	43
Надежда	Нестерова	Афанасьевна	8 002 680 1489	95 03 375067	неоконченное высшее	44
Клавдия	Дементьева	Альбертовна	+7 (139) 223-6907	44 45 533943	среднее	45
Фотий	Макаров	Фокич	+7 (684) 803-6098	01 51 511026	неоконченное высшее	46
Любим	Сидоров	Ерофеевич	8 852 296 89 70	0859 625647	высшее	47
Олимпиада	Шилова	Борисовна	+7 184 955 4350	01 25 297576	среднее	48
Григорий	Герасимов	Гаврилович	+79622885663	6067 440562	неоконченное высшее	49
Маргарита	Ситникова	Антоновна	89971767400	0709 887707	неоконченное высшее	50
Таисия	Третьякова	Болеславовна	8 (209) 218-0396	22 63 145224	высшее	51
Надежда	Панова	Геннадьевна	8 402 435 6201	9994 297042	высшее	52
Валентина	Алексеева	Аскольдовна	+7 (736) 407-6135	43 02 656732	высшее	53
Кира	Антонова	Эльдаровна	+7 (395) 076-1229	6827 278399	среднее	54
Герман	Беляков	Феликсович	83471452583	8692 042066	высшее	55
Фома	Пестов	Авдеевич	+7 289 150 8162	9488 692108	высшее	56
Синклитикия	Медведева	Аркадьевна	+75313206050	21 28 780233	неоконченное высшее	57
Милий	Коновалов	Фёдорович	+7 318 379 8406	4701 662381	неоконченное высшее	58
Август	Яковлев	Бориславович	8 (508) 621-5839	08 27 675721	высшее	59
Герасим	Рыбаков	Андреевич	8 (769) 204-00-96	06 12 315061	высшее	60
Наина	Некрасова	Матвеевна	+7 814 814 1671	6124 814927	высшее	61
Тит	Копылов	Иосипович	+7 (521) 971-45-23	9165 083069	высшее	62
Адриан	Зуев	Архипович	+74563645902	54 75 348948	высшее	63
Александра	Зиновьева	Семеновна	8 (495) 919-81-37	4926 301429	неоконченное высшее	64
Панфил	Суворов	Евсеевич	8 265 018 8599	71 02 100052	среднее	65
Эммануил	Сазонов	Артурович	+7 (520) 490-9823	70 74 252858	среднее	66
Флорентин	Дорофеев	Виленович	8 (966) 084-40-40	37 85 056663	среднее	67
Милий	Воробьев	Елисеевич	8 186 139 86 65	9580 378420	высшее	68
Светлана	Маслова	Егоровна	8 (738) 066-44-70	92 88 801424	высшее	69
Нинель	Капустина	Борисовна	+70470506384	3542 193853	высшее	70
Эрнст	Емельянов	Антонович	+79577504865	7399 205212	высшее	71
Мефодий	Абрамов	Гавриилович	+7 (682) 307-49-37	18 20 845529	неоконченное высшее	72
Надежда	Гаврилова	Натановна	+7 (936) 201-63-95	2815 446073	высшее	73
Велимир	Щукин	Исидорович	+72576157274	54 86 327961	неоконченное высшее	74
Ладислав	Громов	Тарасович	+76259465927	9083 722320	высшее	75
Артемий	Шаров	Исидорович	8 017 839 8224	5467 423419	неоконченное высшее	76
Бажен	Ситников	Эдгарович	+7 907 083 22 10	7724 937185	неоконченное высшее	77
Марфа	Крюкова	Вениаминовна	+7 (398) 071-67-62	7855 530889	высшее	78
Аникей	Лаврентьев	Евстигнеевич	+7 (602) 007-45-74	23 66 790345	среднее	79
Георгий	Матвеев	Бенедиктович	8 876 314 1925	89 91 516181	среднее	80
Лукия	Осипова	Вадимовна	87401554838	87 26 402658	среднее	81
Онуфрий	Мясников	Валерьевич	+7 (529) 466-9931	6007 502808	неоконченное высшее	82
Элеонора	Антонова	Борисовна	8 424 567 0806	84 98 781019	неоконченное высшее	83
Аким	Григорьев	Артурович	83268828970	4794 811465	среднее	84
Евгения	Кононова	Константиновна	+78783112057	15 34 324933	высшее	85
Эраст	Исаев	Ерофеевич	84110253629	32 06 103842	высшее	86
Кузьма	Евдокимов	Трофимович	+7 899 302 58 93	75 90 334117	неоконченное высшее	87
Валерия	Назарова	Яковлевна	8 (353) 367-70-66	4432 026204	высшее	88
Эдуард	Туров	Тарасович	8 793 706 2983	8620 969061	среднее	89
Елена	Воронцова	Георгиевна	8 030 792 7890	7814 026333	неоконченное высшее	90
Анжелика	Жданова	Алексеевна	+7 702 691 88 47	85 58 571158	среднее	91
Евграф	Петров	Елисеевич	+73903080692	64 57 676047	высшее	92
Юлия	Иванова	Феликсовна	+7 972 460 7108	0436 001841	среднее	93
Арефий	Веселов	Феоктистович	8 (673) 878-9014	1191 972736	среднее	94
Акулина	Фадеева	Васильевна	84426394898	4669 310618	среднее	95
Ерофей	Ефремов	Тимурович	8 (917) 431-2552	87 43 575766	высшее	96
Всеслав	Сорокин	Давидович	+7 (484) 874-0382	6159 079627	неоконченное высшее	97
Аникей	Орехов	Авдеевич	+73745618550	10 23 926478	среднее	98
Синклитикия	Лукина	Архиповна	89206742416	5834 231404	среднее	99
Вероника	Емельянова	Ивановна	8 (740) 846-2170	6370 139404	высшее	100
\.


--
-- TOC entry 5129 (class 0 OID 16573)
-- Dependencies: 231
-- Data for Name: student_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_group (program_id, max_students, start_date, end_date, group_number, id) FROM stdin;
7	15	2025-10-20	2025-12-19	B5-25	1
10	30	2026-01-24	2026-07-23	E5-26	2
9	25	2025-10-08	2026-02-05	B3-25	3
3	15	2026-04-22	2026-08-20	C2-26	4
4	25	2025-09-07	2026-01-05	D3-25	5
2	15	2025-10-05	2026-02-02	A1-25	6
10	20	2026-02-02	2026-06-02	E3-26	7
5	20	2025-09-14	2025-12-13	A4-25	8
1	30	2025-07-01	2025-09-29	B4-25	9
6	15	2025-06-27	2025-08-26	F3-25	10
1	25	2025-10-03	2026-01-01	A5-25	11
9	20	2026-06-07	2026-08-06	F4-26	12
7	20	2026-04-14	2026-07-13	A5-26	14
6	25	2026-04-03	2026-07-02	D1-26	15
10	14	2025-11-16	2026-02-14	C3-25	13
\.


--
-- TOC entry 5130 (class 0 OID 16591)
-- Dependencies: 232
-- Data for Name: student_in_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_in_group (student_id, group_id, start_date, end_date) FROM stdin;
2	1	2025-10-20	2025-12-19
1	3	2025-10-08	2026-02-05
2	14	2026-04-14	2026-07-13
2	6	2025-10-05	2026-02-02
3	4	2026-04-22	2026-08-20
3	12	2026-06-07	2026-08-06
4	4	2026-04-22	2026-08-20
4	1	2025-10-20	2025-12-19
5	9	2025-07-01	2025-09-29
5	12	2026-06-07	2026-08-06
6	7	2026-02-02	2026-06-02
6	9	2025-07-01	2025-09-29
7	13	2025-11-16	2026-02-14
8	11	2025-10-03	2026-01-01
8	3	2025-10-08	2026-02-05
9	11	2025-10-03	2026-01-01
10	6	2025-10-05	2026-02-02
11	13	2025-11-16	2026-02-14
11	5	2025-09-07	2026-01-05
12	3	2025-10-08	2026-02-05
12	2	2026-01-24	2026-07-23
13	13	2025-11-16	2026-02-14
14	4	2026-04-22	2026-08-20
14	13	2025-11-16	2026-02-14
15	1	2025-10-20	2025-12-19
16	8	2025-09-14	2025-12-13
17	8	2025-09-14	2025-12-13
17	1	2025-10-20	2025-12-19
18	11	2025-10-03	2026-01-01
18	9	2025-07-01	2025-09-29
19	3	2025-10-08	2026-02-05
19	9	2025-07-01	2025-09-29
20	10	2025-06-27	2025-08-26
20	15	2026-04-03	2026-07-02
21	9	2025-07-01	2025-09-29
21	1	2025-10-20	2025-12-19
22	9	2025-07-01	2025-09-29
22	3	2025-10-08	2026-02-05
23	7	2026-02-02	2026-06-02
23	11	2025-10-03	2026-01-01
24	7	2026-02-02	2026-06-02
25	14	2026-04-14	2026-07-13
26	3	2025-10-08	2026-02-05
26	14	2026-04-14	2026-07-13
27	5	2025-09-07	2026-01-05
27	3	2025-10-08	2026-02-05
28	3	2025-10-08	2026-02-05
29	14	2026-04-14	2026-07-13
29	9	2025-07-01	2025-09-29
30	7	2026-02-02	2026-06-02
31	10	2025-06-27	2025-08-26
32	11	2025-10-03	2026-01-01
33	10	2025-06-27	2025-08-26
33	7	2026-02-02	2026-06-02
34	10	2025-06-27	2025-08-26
35	5	2025-09-07	2026-01-05
36	11	2025-10-03	2026-01-01
37	2	2026-01-24	2026-07-23
38	13	2025-11-16	2026-02-14
39	12	2026-06-07	2026-08-06
40	12	2026-06-07	2026-08-06
41	1	2025-10-20	2025-12-19
41	8	2025-09-14	2025-12-13
42	2	2026-01-24	2026-07-23
42	14	2026-04-14	2026-07-13
43	11	2025-10-03	2026-01-01
43	9	2025-07-01	2025-09-29
44	1	2025-10-20	2025-12-19
44	11	2025-10-03	2026-01-01
45	9	2025-07-01	2025-09-29
45	4	2026-04-22	2026-08-20
46	13	2025-11-16	2026-02-14
46	11	2025-10-03	2026-01-01
47	15	2026-04-03	2026-07-02
48	10	2025-06-27	2025-08-26
48	7	2026-02-02	2026-06-02
49	8	2025-09-14	2025-12-13
49	11	2025-10-03	2026-01-01
50	15	2026-04-03	2026-07-02
51	6	2025-10-05	2026-02-02
52	14	2026-04-14	2026-07-13
53	4	2026-04-22	2026-08-20
54	7	2026-02-02	2026-06-02
55	13	2025-11-16	2026-02-14
55	10	2025-06-27	2025-08-26
56	10	2025-06-27	2025-08-26
56	14	2026-04-14	2026-07-13
57	9	2025-07-01	2025-09-29
57	10	2025-06-27	2025-08-26
58	11	2025-10-03	2026-01-01
58	10	2025-06-27	2025-08-26
59	15	2026-04-03	2026-07-02
60	3	2025-10-08	2026-02-05
60	10	2025-06-27	2025-08-26
61	13	2025-11-16	2026-02-14
62	13	2025-11-16	2026-02-14
62	14	2026-04-14	2026-07-13
63	14	2026-04-14	2026-07-13
64	5	2025-09-07	2026-01-05
64	1	2025-10-20	2025-12-19
65	10	2025-06-27	2025-08-26
66	14	2026-04-14	2026-07-13
66	9	2025-07-01	2025-09-29
67	13	2025-11-16	2026-02-14
67	8	2025-09-14	2025-12-13
68	5	2025-09-07	2026-01-05
69	14	2026-04-14	2026-07-13
70	12	2026-06-07	2026-08-06
70	13	2025-11-16	2026-02-14
71	13	2025-11-16	2026-02-14
71	2	2026-01-24	2026-07-23
72	5	2025-09-07	2026-01-05
73	1	2025-10-20	2025-12-19
73	8	2025-09-14	2025-12-13
74	6	2025-10-05	2026-02-02
74	11	2025-10-03	2026-01-01
75	11	2025-10-03	2026-01-01
75	8	2025-09-14	2025-12-13
76	1	2025-10-20	2025-12-19
77	5	2025-09-07	2026-01-05
77	7	2026-02-02	2026-06-02
78	7	2026-02-02	2026-06-02
79	6	2025-10-05	2026-02-02
80	13	2025-11-16	2026-02-14
80	15	2026-04-03	2026-07-02
81	4	2026-04-22	2026-08-20
81	5	2025-09-07	2026-01-05
82	2	2026-01-24	2026-07-23
83	11	2025-10-03	2026-01-01
84	5	2025-09-07	2026-01-05
84	3	2025-10-08	2026-02-05
85	1	2025-10-20	2025-12-19
86	1	2025-10-20	2025-12-19
87	5	2025-09-07	2026-01-05
87	15	2026-04-03	2026-07-02
88	10	2025-06-27	2025-08-26
88	4	2026-04-22	2026-08-20
89	7	2026-02-02	2026-06-02
90	15	2026-04-03	2026-07-02
91	4	2026-04-22	2026-08-20
92	1	2025-10-20	2025-12-19
92	9	2025-07-01	2025-09-29
93	4	2026-04-22	2026-08-20
94	5	2025-09-07	2026-01-05
95	2	2026-01-24	2026-07-23
95	4	2026-04-22	2026-08-20
96	12	2026-06-07	2026-08-06
96	2	2026-01-24	2026-07-23
97	11	2025-10-03	2026-01-01
98	7	2026-02-02	2026-06-02
98	14	2026-04-14	2026-07-13
99	13	2025-11-16	2026-02-14
99	5	2025-09-07	2026-01-05
100	11	2025-10-03	2026-01-01
100	3	2025-10-08	2026-02-05
\.


--
-- TOC entry 5127 (class 0 OID 16541)
-- Dependencies: 229
-- Data for Name: teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher (first_name, last_name, middle_name, phone, passport, "position", id) FROM stdin;
Ладислав	Кондратьев	Ермолаевич	+7 (707) 084-3672	7997 634006	ассистент	1
Варвара	Захарова	Руслановна	+7 (441) 846-61-34	4567 448557	старший преподаватель	2
Элеонора	Савельева	Станиславовна	8 137 787 1067	1486 427104	ведущий преподаватель	3
Евпраксия	Муравьева	Вадимовна	+7 (366) 556-11-43	3815 965788	старший преподаватель	4
Евгений	Капустин	Ильич	8 (473) 811-46-10	0230 196772	ассистент	5
Феврония	Соколова	Болеславовна	8 (208) 279-1375	89 84 192990	старший преподаватель	6
Пантелеймон	Белозеров	Иосипович	8 456 981 5522	09 46 267911	ассистент	7
Наталья	Белова	Ждановна	8 (882) 768-80-70	74 05 164218	ассистент	8
Ия	Игнатьева	Ждановна	+7 (484) 182-4326	0740 299935	старший преподаватель	9
Кирилл	Гришин	Антонович	87943540480	01 12 806675	профессор	10
Иванна	Потапова	Семеновна	8 (404) 709-2307	49 40 560085	старший преподаватель	11
Агафья	Никитина	Ефимовна	8 726 149 32 72	80 66 493060	профессор	12
Антонина	Михеева	Вячеславовна	+7 (993) 623-79-94	2710 596510	ассистент	13
Оксана	Евдокимова	Анатольевна	+7 (952) 800-30-48	56 80 792171	доцент	14
Федот	Федоров	Ефимьевич	+7 (801) 543-14-96	82 34 775219	доцент	15
Селиверст	Семенов	Ефимьевич	+7 (853) 136-28-41	6699 727944	доцент	16
Любомир	Лазарев	Ермолаевич	8 894 876 2861	75 53 301478	ассистент	17
Евпраксия	Ширяева	Кузьминична	8 638 426 80 26	7365 641376	ассистент	18
Агафья	Некрасова	Викторовна	8 602 910 68 51	9019 958069	ассистент	19
Валентин	Юдин	Терентьевич	8 (976) 752-46-41	62 12 160970	профессор	20
\.


--
-- TOC entry 5128 (class 0 OID 16555)
-- Dependencies: 230
-- Data for Name: teacher_discipline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher_discipline (discipline_id, teacher_id) FROM stdin;
16	1
3	1
6	1
2	2
5	2
8	3
5	3
12	3
14	4
17	4
18	4
19	5
15	5
11	6
14	6
20	6
7	7
4	7
8	8
6	8
11	9
3	9
5	10
14	10
3	10
1	11
20	11
11	12
11	13
15	13
20	14
4	14
10	14
18	15
9	16
11	17
4	17
13	18
20	18
17	19
1	20
4	20
\.


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 242
-- Name: attestation_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attestation_new_id_seq', 3, true);


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 244
-- Name: classroom_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classroom_new_id_seq', 30, true);


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 241
-- Name: discipline_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discipline_new_id_seq', 20, true);


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 250
-- Name: document_type_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_type_new_id_seq', 3, true);


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 251
-- Name: graduation_document_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.graduation_document_new_id_seq', 30, true);


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 240
-- Name: hours_volume_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hours_volume_new_id_seq', 20, true);


--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 254
-- Name: lesson_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_audit_id_seq', 1, true);


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 246
-- Name: lesson_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_new_id_seq', 201, true);


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 245
-- Name: lesson_type_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_type_new_id_seq', 3, true);


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 243
-- Name: location_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.location_new_id_seq', 4, true);


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 239
-- Name: program_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_new_id_seq', 10, true);


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 238
-- Name: program_type_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_type_new_id_seq', 3, true);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 249
-- Name: student_group_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_group_new_id_seq', 15, true);


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 247
-- Name: student_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_new_id_seq', 100, true);


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 248
-- Name: teacher_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_new_id_seq', 20, true);


--
-- TOC entry 4933 (class 2606 OID 17076)
-- Name: attestation attestation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attestation
    ADD CONSTRAINT attestation_pkey PRIMARY KEY (id);


--
-- TOC entry 4905 (class 2606 OID 17094)
-- Name: classroom classroom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_pkey PRIMARY KEY (id);


--
-- TOC entry 4935 (class 2606 OID 17217)
-- Name: discipline_attestation discipline_attestation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline_attestation
    ADD CONSTRAINT discipline_attestation_pkey PRIMARY KEY (discipline_id, attestation_id);


--
-- TOC entry 4899 (class 2606 OID 17060)
-- Name: discipline discipline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline
    ADD CONSTRAINT discipline_pkey PRIMARY KEY (id);


--
-- TOC entry 4929 (class 2606 OID 17170)
-- Name: document_type document_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_type
    ADD CONSTRAINT document_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4931 (class 2606 OID 17179)
-- Name: graduation_document graduation_document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduation_document
    ADD CONSTRAINT graduation_document_pkey PRIMARY KEY (id);


--
-- TOC entry 4937 (class 2606 OID 17266)
-- Name: group_lesson_teacher group_lesson_teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson_teacher
    ADD CONSTRAINT group_lesson_teacher_pkey PRIMARY KEY (group_id, lesson_id, teacher_id);


--
-- TOC entry 4897 (class 2606 OID 17049)
-- Name: hours_volume hours_volume_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hours_volume
    ADD CONSTRAINT hours_volume_pkey PRIMARY KEY (id);


--
-- TOC entry 4939 (class 2606 OID 25177)
-- Name: lesson_audit lesson_audit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_audit
    ADD CONSTRAINT lesson_audit_pkey PRIMARY KEY (id);


--
-- TOC entry 4910 (class 2606 OID 17117)
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (id);


--
-- TOC entry 4907 (class 2606 OID 17108)
-- Name: lesson_type lesson_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_type
    ADD CONSTRAINT lesson_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4903 (class 2606 OID 17085)
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- TOC entry 4901 (class 2606 OID 17203)
-- Name: program_discipline program_discipline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_discipline
    ADD CONSTRAINT program_discipline_pkey PRIMARY KEY (discipline_id, program_id);


--
-- TOC entry 4895 (class 2606 OID 17033)
-- Name: program program_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_pkey PRIMARY KEY (id);


--
-- TOC entry 4893 (class 2606 OID 17022)
-- Name: program_type program_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_type
    ADD CONSTRAINT program_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4923 (class 2606 OID 17156)
-- Name: student_group student_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_group
    ADD CONSTRAINT student_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4925 (class 2606 OID 17336)
-- Name: student_group student_group_program_number_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_group
    ADD CONSTRAINT student_group_program_number_unique UNIQUE (program_id, group_number);


--
-- TOC entry 4927 (class 2606 OID 17245)
-- Name: student_in_group student_in_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_in_group
    ADD CONSTRAINT student_in_group_pkey PRIMARY KEY (student_id, group_id);


--
-- TOC entry 4913 (class 2606 OID 17332)
-- Name: student student_passport_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_passport_unique UNIQUE (passport);


--
-- TOC entry 4915 (class 2606 OID 17136)
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- TOC entry 4921 (class 2606 OID 17231)
-- Name: teacher_discipline teacher_discipline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_discipline
    ADD CONSTRAINT teacher_discipline_pkey PRIMARY KEY (discipline_id, teacher_id);


--
-- TOC entry 4917 (class 2606 OID 17334)
-- Name: teacher teacher_passport_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_passport_unique UNIQUE (passport);


--
-- TOC entry 4919 (class 2606 OID 17147)
-- Name: teacher teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (id);


--
-- TOC entry 4908 (class 1259 OID 17361)
-- Name: idx_lesson_classroom_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lesson_classroom_id ON public.lesson USING btree (classroom_id);


--
-- TOC entry 4911 (class 1259 OID 17381)
-- Name: idx_student_id_lastname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_student_id_lastname ON public.student USING btree (first_name);


--
-- TOC entry 4964 (class 2620 OID 25185)
-- Name: student_in_group trg_auto_fill_dates; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_auto_fill_dates BEFORE INSERT ON public.student_in_group FOR EACH ROW EXECUTE FUNCTION public.trg_auto_fill_dates();


--
-- TOC entry 4961 (class 2620 OID 25189)
-- Name: lesson trg_check_classroom_busy; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_check_classroom_busy BEFORE INSERT OR UPDATE ON public.lesson FOR EACH ROW EXECUTE FUNCTION public.trg_check_classroom_busy();


--
-- TOC entry 4965 (class 2620 OID 25167)
-- Name: student_in_group trg_check_max_students; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_check_max_students BEFORE INSERT ON public.student_in_group FOR EACH ROW EXECUTE FUNCTION public.trg_check_max_students();


--
-- TOC entry 4966 (class 2620 OID 25181)
-- Name: student_in_group trg_check_student_dates; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_check_student_dates BEFORE INSERT OR UPDATE ON public.student_in_group FOR EACH ROW EXECUTE FUNCTION public.trg_check_student_dates();


--
-- TOC entry 4967 (class 2620 OID 25183)
-- Name: group_lesson_teacher trg_check_teacher_discipline; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_check_teacher_discipline BEFORE INSERT ON public.group_lesson_teacher FOR EACH ROW EXECUTE FUNCTION public.trg_check_teacher_discipline();


--
-- TOC entry 4962 (class 2620 OID 25179)
-- Name: lesson trg_lesson_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_lesson_audit AFTER UPDATE ON public.lesson FOR EACH ROW EXECUTE FUNCTION public.trg_lesson_audit();


--
-- TOC entry 4963 (class 2620 OID 25187)
-- Name: student_group trg_prevent_group_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_prevent_group_delete BEFORE DELETE ON public.student_group FOR EACH ROW EXECUTE FUNCTION public.trg_prevent_group_delete();


--
-- TOC entry 4944 (class 2606 OID 17282)
-- Name: classroom classroom_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(id);


--
-- TOC entry 4956 (class 2606 OID 17387)
-- Name: discipline_attestation discipline_attestation_attestation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline_attestation
    ADD CONSTRAINT discipline_attestation_attestation_id_fkey FOREIGN KEY (attestation_id) REFERENCES public.attestation(id);


--
-- TOC entry 4957 (class 2606 OID 17382)
-- Name: discipline_attestation discipline_attestation_discipline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline_attestation
    ADD CONSTRAINT discipline_attestation_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES public.discipline(id);


--
-- TOC entry 4941 (class 2606 OID 17277)
-- Name: discipline discipline_hours_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline
    ADD CONSTRAINT discipline_hours_volume_id_fkey FOREIGN KEY (hours_volume_id) REFERENCES public.hours_volume(id);


--
-- TOC entry 4953 (class 2606 OID 17307)
-- Name: graduation_document graduation_document_document_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduation_document
    ADD CONSTRAINT graduation_document_document_type_id_fkey FOREIGN KEY (document_type_id) REFERENCES public.document_type(id);


--
-- TOC entry 4954 (class 2606 OID 17302)
-- Name: graduation_document graduation_document_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduation_document
    ADD CONSTRAINT graduation_document_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id);


--
-- TOC entry 4955 (class 2606 OID 17312)
-- Name: graduation_document graduation_document_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduation_document
    ADD CONSTRAINT graduation_document_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- TOC entry 4958 (class 2606 OID 17392)
-- Name: group_lesson_teacher group_lesson_teacher_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson_teacher
    ADD CONSTRAINT group_lesson_teacher_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.student_group(id);


--
-- TOC entry 4959 (class 2606 OID 17397)
-- Name: group_lesson_teacher group_lesson_teacher_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson_teacher
    ADD CONSTRAINT group_lesson_teacher_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id);


--
-- TOC entry 4960 (class 2606 OID 17402)
-- Name: group_lesson_teacher group_lesson_teacher_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson_teacher
    ADD CONSTRAINT group_lesson_teacher_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teacher(id);


--
-- TOC entry 4945 (class 2606 OID 17287)
-- Name: lesson lesson_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_classroom_id_fkey FOREIGN KEY (classroom_id) REFERENCES public.classroom(id);


--
-- TOC entry 4946 (class 2606 OID 24727)
-- Name: lesson lesson_discipline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES public.discipline(id);


--
-- TOC entry 4947 (class 2606 OID 17292)
-- Name: lesson lesson_lesson_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_lesson_type_id_fkey FOREIGN KEY (lesson_type_id) REFERENCES public.lesson_type(id);


--
-- TOC entry 4942 (class 2606 OID 17407)
-- Name: program_discipline program_discipline_discipline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_discipline
    ADD CONSTRAINT program_discipline_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES public.discipline(id);


--
-- TOC entry 4943 (class 2606 OID 17412)
-- Name: program_discipline program_discipline_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_discipline
    ADD CONSTRAINT program_discipline_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id);


--
-- TOC entry 4940 (class 2606 OID 17272)
-- Name: program program_program_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_program_type_id_fkey FOREIGN KEY (program_type_id) REFERENCES public.program_type(id);


--
-- TOC entry 4950 (class 2606 OID 17297)
-- Name: student_group student_group_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_group
    ADD CONSTRAINT student_group_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id);


--
-- TOC entry 4951 (class 2606 OID 17422)
-- Name: student_in_group student_in_group_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_in_group
    ADD CONSTRAINT student_in_group_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.student_group(id);


--
-- TOC entry 4952 (class 2606 OID 17417)
-- Name: student_in_group student_in_group_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_in_group
    ADD CONSTRAINT student_in_group_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- TOC entry 4948 (class 2606 OID 17427)
-- Name: teacher_discipline teacher_discipline_discipline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_discipline
    ADD CONSTRAINT teacher_discipline_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES public.discipline(id);


--
-- TOC entry 4949 (class 2606 OID 17432)
-- Name: teacher_discipline teacher_discipline_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_discipline
    ADD CONSTRAINT teacher_discipline_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teacher(id);


-- Completed on 2026-06-14 14:35:56

--
-- PostgreSQL database dump complete
--

\unrestrict vaZJgPtWvRX6gTgl8WHKVX7MxhRCs5R9M28cJV2e9zMYRPVmwHYbF4t696Odhj2

