--
-- PostgreSQL database dump
--

\restrict zh06zgI5tFerzhMil5iSujdi6lYY0lMfombqQul6747U5CPQbDkwCItgkrzuwcw

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-04-08 20:05:14

-- настройки времени и кодировки
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
-- Name: university; Type: SCHEMA; Schema: -; Owner: postgres
--

-- создание схемы university
CREATE SCHEMA university;


ALTER SCHEMA university OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 241 (class 1259 OID 16535)
-- Name: classrooms; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы classrooms
CREATE TABLE university.classrooms (
    classroom_id integer NOT NULL,
    room_number character varying NOT NULL,
    capacity integer NOT NULL,
    site_id integer NOT NULL,
    CONSTRAINT check_capacity CHECK ((capacity >= 0))
);


ALTER TABLE university.classrooms OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16534)
-- Name: classrooms_classroom_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для classrooms
CREATE SEQUENCE university.classrooms_classroom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.classrooms_classroom_id_seq OWNER TO postgres;

--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 240
-- Name: classrooms_classroom_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.classrooms_classroom_id_seq OWNED BY university.classrooms.classroom_id;


--
-- TOC entry 237 (class 1259 OID 16499)
-- Name: curriculums; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы curriculums
CREATE TABLE university.curriculums (
    curriculum_id integer NOT NULL,
    program_id integer NOT NULL,
    admission_year integer NOT NULL
);


ALTER TABLE university.curriculums OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16498)
-- Name: curriculums_curriculum_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для curriculums
CREATE SEQUENCE university.curriculums_curriculum_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.curriculums_curriculum_id_seq OWNER TO postgres;

--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 236
-- Name: curriculums_curriculum_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.curriculums_curriculum_id_seq OWNED BY university.curriculums.curriculum_id;


--
-- TOC entry 247 (class 1259 OID 16613)
-- Name: discipline_in_curriculum; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы discipline_in_curriculum
CREATE TABLE university.discipline_in_curriculum (
    dis_id integer NOT NULL,
    curriculum_id integer NOT NULL,
    discipline_id integer NOT NULL,
    semester integer NOT NULL,
    CONSTRAINT check_semester CHECK (((semester >= 1) AND (semester <= 12)))
);


ALTER TABLE university.discipline_in_curriculum OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16612)
-- Name: discipline_in_curriculum_dis_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для discipline_in_curriculum
CREATE SEQUENCE university.discipline_in_curriculum_dis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.discipline_in_curriculum_dis_id_seq OWNER TO postgres;

--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 246
-- Name: discipline_in_curriculum_dis_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.discipline_in_curriculum_dis_id_seq OWNED BY university.discipline_in_curriculum.dis_id;


--
-- TOC entry 231 (class 1259 OID 16446)
-- Name: disciplines; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы disciplines
CREATE TABLE university.disciplines (
    discipline_id integer NOT NULL,
    name character varying(50) NOT NULL,
    lesson_type character varying(50) NOT NULL,
    hours_lectures integer NOT NULL,
    hours_practice integer NOT NULL,
    hours_labs integer NOT NULL,
    hours_seminars integer NOT NULL,
    teacher_id integer NOT NULL,
    full_hours integer NOT NULL,
    CONSTRAINT check_hours_labs CHECK ((hours_labs >= 0)),
    CONSTRAINT check_hours_lectures CHECK ((hours_lectures >= 0)),
    CONSTRAINT check_hours_practice CHECK ((hours_practice >= 0)),
    CONSTRAINT check_hours_seminars CHECK ((hours_seminars >= 0))
);


ALTER TABLE university.disciplines OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16445)
-- Name: disciplines_discipline_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для disciplines
CREATE SEQUENCE university.disciplines_discipline_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.disciplines_discipline_id_seq OWNER TO postgres;

--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 230
-- Name: disciplines_discipline_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.disciplines_discipline_id_seq OWNED BY university.disciplines.discipline_id;


--
-- TOC entry 235 (class 1259 OID 16475)
-- Name: education_programs; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы education_programs
CREATE TABLE university.education_programs (
    program_id integer NOT NULL,
    name character varying(100) NOT NULL,
    subdivision_id integer NOT NULL,
    spec_id integer NOT NULL,
    degree character varying(30) NOT NULL,
    duration_years integer NOT NULL,
    CONSTRAINT check_duration_years CHECK ((duration_years >= 2))
);


ALTER TABLE university.education_programs OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16474)
-- Name: education_programs_program_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для education_programs
CREATE SEQUENCE university.education_programs_program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.education_programs_program_id_seq OWNER TO postgres;

--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 234
-- Name: education_programs_program_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.education_programs_program_id_seq OWNED BY university.education_programs.program_id;


--
-- TOC entry 245 (class 1259 OID 16591)
-- Name: job_history; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы job_history
CREATE TABLE university.job_history (
    history_id integer NOT NULL,
    position_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    person_id integer NOT NULL,
    subdivision_id integer NOT NULL,
    CONSTRAINT check_end_date CHECK ((end_date >= start_date))
);


ALTER TABLE university.job_history OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16590)
-- Name: job_history_history_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для job_history
CREATE SEQUENCE university.job_history_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.job_history_history_id_seq OWNER TO postgres;

--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 244
-- Name: job_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.job_history_history_id_seq OWNED BY university.job_history.history_id;


--
-- TOC entry 225 (class 1259 OID 16413)
-- Name: people; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы people
CREATE TABLE university.people (
    person_id integer NOT NULL,
    last_name character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    patronymic character varying(30),
    email character varying NOT NULL
);


ALTER TABLE university.people OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16412)
-- Name: people_person_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для people
CREATE SEQUENCE university.people_person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.people_person_id_seq OWNER TO postgres;

--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 224
-- Name: people_person_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.people_person_id_seq OWNED BY university.people.person_id;


--
-- TOC entry 227 (class 1259 OID 16423)
-- Name: positions; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы positions
CREATE TABLE university.positions (
    position_id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE university.positions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16422)
-- Name: positions_position_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для positions
CREATE SEQUENCE university.positions_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.positions_position_id_seq OWNER TO postgres;

--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 226
-- Name: positions_position_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.positions_position_id_seq OWNED BY university.positions.position_id;


--
-- TOC entry 249 (class 1259 OID 16636)
-- Name: schedules; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы schedules
CREATE TABLE university.schedules (
    schedule_id integer NOT NULL,
    dis_id integer NOT NULL,
    classroom_id integer NOT NULL,
    event_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    event_type character varying(50) NOT NULL,
    job_id integer NOT NULL,
    CONSTRAINT check_end_time CHECK ((end_time > start_time))
);


ALTER TABLE university.schedules OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16635)
-- Name: schedules_schedule_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для schedules
CREATE SEQUENCE university.schedules_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.schedules_schedule_id_seq OWNER TO postgres;

--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 248
-- Name: schedules_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.schedules_schedule_id_seq OWNED BY university.schedules.schedule_id;


--
-- TOC entry 251 (class 1259 OID 16666)
-- Name: scholarship_assignments; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы scholarship_assignments
CREATE TABLE university.scholarship_assignments (
    assignment_id integer NOT NULL,
    student_id integer NOT NULL,
    scholarship_id integer NOT NULL,
    assignment_date date NOT NULL,
    is_active boolean NOT NULL
);


ALTER TABLE university.scholarship_assignments OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 16665)
-- Name: scholarship_assignments_assignment_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для scholarship_assignments
CREATE SEQUENCE university.scholarship_assignments_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.scholarship_assignments_assignment_id_seq OWNER TO postgres;

--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 250
-- Name: scholarship_assignments_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.scholarship_assignments_assignment_id_seq OWNED BY university.scholarship_assignments.assignment_id;


--
-- TOC entry 229 (class 1259 OID 16432)
-- Name: scholarships; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы scholarships
CREATE TABLE university.scholarships (
    scholarship_id integer NOT NULL,
    type character varying(100) NOT NULL,
    amount numeric(10,2) NOT NULL,
    conditions text NOT NULL,
    CONSTRAINT check_scholarship_amount CHECK ((amount >= (0)::numeric))
);


ALTER TABLE university.scholarships OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16431)
-- Name: scholarships_scholarship_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для scholarships
CREATE SEQUENCE university.scholarships_scholarship_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.scholarships_scholarship_id_seq OWNER TO postgres;

--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 228
-- Name: scholarships_scholarship_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.scholarships_scholarship_id_seq OWNED BY university.scholarships.scholarship_id;


--
-- TOC entry 253 (class 1259 OID 16688)
-- Name: session_results; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы session_results
CREATE TABLE university.session_results (
    result_id integer NOT NULL,
    student_id integer NOT NULL,
    grade integer,
    assessment_type character varying NOT NULL,
    attempt_number integer NOT NULL,
    exam_date date NOT NULL,
    status character varying NOT NULL,
    discipline_id integer NOT NULL,
    teacher_id integer NOT NULL,
    CONSTRAINT check_attempt CHECK (((attempt_number >= 1) AND (attempt_number <= 3)))
);


ALTER TABLE university.session_results OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 16687)
-- Name: session_results_result_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для session_results
CREATE SEQUENCE university.session_results_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.session_results_result_id_seq OWNER TO postgres;

--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 252
-- Name: session_results_result_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.session_results_result_id_seq OWNED BY university.session_results.result_id;


--
-- TOC entry 233 (class 1259 OID 16465)
-- Name: sites; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы sites
CREATE TABLE university.sites (
    site_id integer NOT NULL,
    city character varying(50) NOT NULL,
    address character varying(100) NOT NULL
);


ALTER TABLE university.sites OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16464)
-- Name: sites_site_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для sites
CREATE SEQUENCE university.sites_site_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.sites_site_id_seq OWNER TO postgres;

--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 232
-- Name: sites_site_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.sites_site_id_seq OWNED BY university.sites.site_id;


--
-- TOC entry 223 (class 1259 OID 16401)
-- Name: specializations; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы specializations
CREATE TABLE university.specializations (
    spec_id integer NOT NULL,
    spec_code character varying NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE university.specializations OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16400)
-- Name: specializations_spec_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для specializations
CREATE SEQUENCE university.specializations_spec_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.specializations_spec_id_seq OWNER TO postgres;

--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 222
-- Name: specializations_spec_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.specializations_spec_id_seq OWNED BY university.specializations.spec_id;


--
-- TOC entry 239 (class 1259 OID 16514)
-- Name: student_groups; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы student_groups
CREATE TABLE university.student_groups (
    group_id integer NOT NULL,
    group_number character varying NOT NULL,
    course integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    CONSTRAINT check_course CHECK (((course >= 1) AND (course <= 6)))
);


ALTER TABLE university.student_groups OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16513)
-- Name: student_groups_group_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для student_groups
CREATE SEQUENCE university.student_groups_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.student_groups_group_id_seq OWNER TO postgres;

--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 238
-- Name: student_groups_group_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.student_groups_group_id_seq OWNED BY university.student_groups.group_id;


--
-- TOC entry 243 (class 1259 OID 16554)
-- Name: students; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы students
CREATE TABLE university.students (
    student_id integer NOT NULL,
    person_id integer NOT NULL,
    group_id integer NOT NULL,
    status character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);


ALTER TABLE university.students OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16553)
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для students
CREATE SEQUENCE university.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.students_student_id_seq OWNER TO postgres;

--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 242
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.students_student_id_seq OWNED BY university.students.student_id;


--
-- TOC entry 221 (class 1259 OID 16391)
-- Name: subdivisions; Type: TABLE; Schema: university; Owner: postgres
--

-- создание таблицы subdivisions
CREATE TABLE university.subdivisions (
    subdivision_id integer NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(100) NOT NULL
);


ALTER TABLE university.subdivisions OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: subdivisions_subdivision_id_seq; Type: SEQUENCE; Schema: university; Owner: postgres
--

-- создание последовательности для subdivisions
CREATE SEQUENCE university.subdivisions_subdivision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE university.subdivisions_subdivision_id_seq OWNER TO postgres;

--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 220
-- Name: subdivisions_subdivision_id_seq; Type: SEQUENCE OWNED BY; Schema: university; Owner: postgres
--

ALTER SEQUENCE university.subdivisions_subdivision_id_seq OWNED BY university.subdivisions.subdivision_id;


-- установка значений по умолчанию для колонок с последовательностями
ALTER TABLE ONLY university.classrooms ALTER COLUMN classroom_id SET DEFAULT nextval('university.classrooms_classroom_id_seq'::regclass);
ALTER TABLE ONLY university.curriculums ALTER COLUMN curriculum_id SET DEFAULT nextval('university.curriculums_curriculum_id_seq'::regclass);
ALTER TABLE ONLY university.discipline_in_curriculum ALTER COLUMN dis_id SET DEFAULT nextval('university.discipline_in_curriculum_dis_id_seq'::regclass);
ALTER TABLE ONLY university.disciplines ALTER COLUMN discipline_id SET DEFAULT nextval('university.disciplines_discipline_id_seq'::regclass);
ALTER TABLE ONLY university.education_programs ALTER COLUMN program_id SET DEFAULT nextval('university.education_programs_program_id_seq'::regclass);
ALTER TABLE ONLY university.job_history ALTER COLUMN history_id SET DEFAULT nextval('university.job_history_history_id_seq'::regclass);
ALTER TABLE ONLY university.people ALTER COLUMN person_id SET DEFAULT nextval('university.people_person_id_seq'::regclass);
ALTER TABLE ONLY university.positions ALTER COLUMN position_id SET DEFAULT nextval('university.positions_position_id_seq'::regclass);
ALTER TABLE ONLY university.schedules ALTER COLUMN schedule_id SET DEFAULT nextval('university.schedules_schedule_id_seq'::regclass);
ALTER TABLE ONLY university.scholarship_assignments ALTER COLUMN assignment_id SET DEFAULT nextval('university.scholarship_assignments_assignment_id_seq'::regclass);
ALTER TABLE ONLY university.scholarships ALTER COLUMN scholarship_id SET DEFAULT nextval('university.scholarships_scholarship_id_seq'::regclass);
ALTER TABLE ONLY university.session_results ALTER COLUMN result_id SET DEFAULT nextval('university.session_results_result_id_seq'::regclass);
ALTER TABLE ONLY university.sites ALTER COLUMN site_id SET DEFAULT nextval('university.sites_site_id_seq'::regclass);
ALTER TABLE ONLY university.specializations ALTER COLUMN spec_id SET DEFAULT nextval('university.specializations_spec_id_seq'::regclass);
ALTER TABLE ONLY university.student_groups ALTER COLUMN group_id SET DEFAULT nextval('university.student_groups_group_id_seq'::regclass);
ALTER TABLE ONLY university.students ALTER COLUMN student_id SET DEFAULT nextval('university.students_student_id_seq'::regclass);
ALTER TABLE ONLY university.subdivisions ALTER COLUMN subdivision_id SET DEFAULT nextval('university.subdivisions_subdivision_id_seq'::regclass);


--
-- TOC entry 5212 (class 0 OID 16535)
-- Dependencies: 241
-- Data for Name: classrooms; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы classrooms
INSERT INTO university.classrooms (classroom_id, room_number, capacity, site_id) VALUES (1, '2304', 50, 1);
INSERT INTO university.classrooms (classroom_id, room_number, capacity, site_id) VALUES (2, '4210', 80, 2);
INSERT INTO university.classrooms (classroom_id, room_number, capacity, site_id) VALUES (3, '1221', 100, 2);
INSERT INTO university.classrooms (classroom_id, room_number, capacity, site_id) VALUES (4, '2201', 60, 1);
INSERT INTO university.classrooms (classroom_id, room_number, capacity, site_id) VALUES (5, '2219', 60, 2);


--
-- TOC entry 5208 (class 0 OID 16499)
-- Dependencies: 237
-- Data for Name: curriculums; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы curriculums
INSERT INTO university.curriculums (curriculum_id, program_id, admission_year) VALUES (1, 1, 2024);


--
-- TOC entry 5218 (class 0 OID 16613)
-- Dependencies: 247
-- Data for Name: discipline_in_curriculum; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы discipline_in_curriculum
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (1, 1, 2, 1);
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (2, 1, 3, 1);
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (3, 1, 4, 1);
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (4, 1, 5, 1);
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (5, 1, 6, 1);
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (6, 1, 7, 1);
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (7, 1, 8, 1);
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (8, 1, 9, 1);
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (9, 1, 10, 1);
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (10, 1, 11, 1);
INSERT INTO university.discipline_in_curriculum (dis_id, curriculum_id, discipline_id, semester) VALUES (11, 1, 12, 1);


--
-- TOC entry 5202 (class 0 OID 16446)
-- Dependencies: 231
-- Data for Name: disciplines; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы disciplines
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (2, 'Жизненный цикл программного обеспечения', 'Очная', 32, 16, 16, 0, 1, 64);
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (3, 'Техники публичных выступлений и презентаций', 'Очная', 32, 16, 16, 0, 2, 64);
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (4, 'Механика', 'Очная', 32, 16, 16, 0, 3, 64);
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (5, 'Объектно-ориентированное программирование', 'Очная', 32, 16, 16, 0, 4, 64);
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (6, 'Теория вероятностей', 'Очная', 32, 16, 16, 0, 5, 64);
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (7, 'Проектирование взаимодействия в UX/UI дизайне', 'Очная', 32, 16, 16, 0, 6, 64);
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (8, 'Облачные технологии и услуги', 'Очная', 32, 16, 16, 0, 7, 64);
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (9, 'Дифференциальные уравнения', 'Очная', 32, 16, 16, 0, 8, 64);
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (10, 'Проектирование и реализация баз данных', 'Очная', 32, 16, 16, 0, 9, 64);
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (11, 'Английский язык B2', 'Очная', 32, 16, 16, 0, 10, 64);
INSERT INTO university.disciplines (discipline_id, name, lesson_type, hours_lectures, hours_practice, hours_labs, hours_seminars, teacher_id, full_hours) VALUES (12, 'Введение в технологическое предпринимательство', 'Очная', 32, 16, 16, 0, 11, 64);


--
-- TOC entry 5206 (class 0 OID 16475)
-- Dependencies: 235
-- Data for Name: education_programs; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы education_programs
INSERT INTO university.education_programs (program_id, name, subdivision_id, spec_id, degree, duration_years) VALUES (1, 'Мобильные и сетевые технологии', 1, 1, 'Бакалавр', 4);


--
-- TOC entry 5216 (class 0 OID 16591)
-- Dependencies: 245
-- Data for Name: job_history; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы job_history
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (1, 1, '2020-01-01', NULL, 41, 1);
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (2, 1, '2020-01-01', NULL, 42, 1);
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (3, 1, '2020-01-01', NULL, 43, 1);
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (4, 1, '2020-01-01', NULL, 44, 1);
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (5, 1, '2020-01-01', NULL, 45, 1);
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (6, 1, '2020-01-01', NULL, 46, 1);
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (7, 1, '2020-01-01', NULL, 47, 1);
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (8, 1, '2020-01-01', NULL, 48, 1);
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (9, 1, '2020-01-01', NULL, 49, 1);
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (10, 1, '2020-01-01', NULL, 50, 1);
INSERT INTO university.job_history (history_id, position_id, start_date, end_date, person_id, subdivision_id) VALUES (11, 1, '2020-01-01', NULL, 51, 1);


--
-- TOC entry 5196 (class 0 OID 16413)
-- Dependencies: 225
-- Data for Name: people; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы people
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (1, 'Шнейдерис', 'Пётр', 'Константинович', '311597@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (2, 'Гуань', 'Андрей', 'Евгеньевич', '409707@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (3, 'Максудов', 'Михаил', 'Романович', '368781@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (4, 'Яхина', 'Алексей', 'Валерьевич', '409813@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (5, 'Хайкин', 'Елизавета', 'Олеговна', '336642@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (6, 'Беломытцев', 'Никита', 'Сергеевич', '312962@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (7, 'Демидов', 'Владимир', 'Алексеевич', '367661@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (8, 'Петров', 'Цзясюань', '', '345555@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (9, 'Богачёв', 'Максим', 'Евгеньевич', '334568@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (10, 'Мещанов', 'Даниил', 'Дмитриевич', '373411@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (11, 'Шестаков', 'Василий', 'Михайлович', '367680@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (12, 'Орешин', 'Михаил', 'Евгеньевич', '334235@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (13, 'Шевченко', 'Данила', 'Александрович', '334908@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (14, 'Ши', 'Никита', 'Сергеевич', '311413@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (15, 'Никитин', 'Эрик', '', '336275@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (16, 'Рахмани', 'Бяо', '', '321908@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (17, 'Дубинин', 'Николай', 'Романович', '368366@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (18, 'Каспер', 'Николай', 'Кириллович', '333332@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (19, 'Пань', 'Ханчжэ', '', '345595@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (20, 'Прохорова', 'Татьяна', 'Александровна', '336480@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (21, 'Хуан', 'Эл', 'Дин Амир Ахмед Али', '408395@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (22, 'Чжоу', 'Семён', 'Олегович', '367888@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (23, 'Лемешко', 'Клим', 'Олегович', '413965@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (24, 'Васляев', 'Степан', 'Сергеевич', '412148@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (25, 'Яворский', 'Владимир', 'Дмитриевич', '313251@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (26, 'Попышева', 'Лена', 'Рустемовна', '368461@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (27, 'Рахимов', 'Бинь', '', '321391@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (28, 'Дагаев', 'Дмитрий', 'Алексеевич', '367566@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (29, 'Ведерников', 'Даниял', 'Алимович', '408270@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (30, 'Ян', 'Константин', 'Сергеевич', '409733@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (31, 'Митрик', 'Родион', 'Андреевич', '338264@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (32, 'Никитин', 'Антон', 'Сергеевич', '333828@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (33, 'Чупрова', 'Ирина', 'Алексеевна', '368648@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (34, 'Люсин', 'Михаил', 'Анатольевич', '368392@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (35, 'Семёнов', 'Павел', 'Евгеньевич', '368286@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (36, 'Ларионова', 'Ксения', 'Андреевна', '368279@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (37, 'Лапушкина', 'Галина', 'Григорьевна', '335959@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (38, 'Семынин', 'Алексей', 'Леонидович', '368825@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (39, 'Чжоу', 'Яков', 'Сергеевич', '334809@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (40, 'Шаланов', 'Захарий', 'Евгеньевич', '336782@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (41, 'Осетрова', 'Ирина', 'Станиславовна', '500201@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (42, 'Тихомирова', 'Наталья', 'Вячеславовна', '500202@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (43, 'Курашова', 'Светлана', 'Александровна', '500203@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (44, 'Слюсаренко', 'Сергей', 'Владимирович', '500204@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (45, 'Блейхер', 'Оксана', 'Владимировна', '500205@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (46, 'Кокорев', 'Алексей', 'Юрьевич', '500206@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (47, 'Меркушев', 'Александр', 'Евгеньевич', '500207@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (48, 'Лукина', 'Марина', 'Владимировна', '500208@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (49, 'Говорова', 'Марина', 'Михайловна', '500209@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (50, 'Джалалова', 'Камила', 'Исроиловна', '500210@itmo.ru');
INSERT INTO university.people (person_id, last_name, first_name, patronymic, email) VALUES (51, 'Бойцова', 'Юлия', 'Сергеевна', '500211@itmo.ru');


--
-- TOC entry 5198 (class 0 OID 16423)
-- Dependencies: 227
-- Data for Name: positions; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы positions
INSERT INTO university.positions (position_id, name) VALUES (1, 'Преподаватель');
INSERT INTO university.positions (position_id, name) VALUES (2, 'Доцент');


--
-- TOC entry 5220 (class 0 OID 16636)
-- Dependencies: 249
-- Data for Name: schedules; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы schedules
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (2, 1, 2, '2026-01-12', '11:30:00', '15:00:00', 'Зачет', 1);
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (4, 2, 4, '2026-01-22', '15:30:00', '18:40:00', 'Зачет', 2);
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (5, 3, 5, '2026-01-31', '13:30:00', '17:00:00', 'Экзамен', 3);
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (6, 4, 2, '2026-01-03', '15:30:00', '18:40:00', 'Экзамен', 4);
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (7, 5, 1, '2026-01-10', '11:30:00', '15:00:00', 'Экзамен', 5);
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (8, 6, 5, '2026-01-14', '13:30:00', '17:00:00', 'Экзамен', 6);
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (9, 7, 2, '2026-01-26', '11:30:00', '15:00:00', 'Экзамен', 7);
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (10, 8, 4, '2026-01-07', '15:30:00', '18:40:00', 'Экзамен', 8);
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (11, 9, 2, '2026-01-05', '11:30:00', '15:00:00', 'Зачет', 9);
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (12, 10, 5, '2026-01-23', '13:30:00', '17:00:00', 'Зачет', 10);
INSERT INTO university.schedules (schedule_id, dis_id, classroom_id, event_date, start_time, end_time, event_type, job_id) VALUES (13, 11, 3, '2026-01-01', '13:30:00', '17:00:00', 'Экзамен', 11);


--
-- TOC entry 5222 (class 0 OID 16666)
-- Dependencies: 251
-- Data for Name: scholarship_assignments; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы scholarship_assignments
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (1, 1, 3, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (2, 2, 1, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (3, 3, 4, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (4, 4, 2, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (5, 5, 1, '2026-02-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (6, 6, 3, '2026-02-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (7, 7, 2, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (8, 8, 3, '2026-02-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (9, 9, 3, '2026-02-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (10, 10, 1, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (11, 11, 4, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (12, 12, 1, '2026-02-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (13, 13, 4, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (14, 14, 2, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (15, 15, 4, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (16, 16, 3, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (17, 17, 1, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (18, 18, 4, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (19, 19, 1, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (20, 20, 2, '2026-02-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (21, 21, 2, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (22, 22, 2, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (23, 23, 3, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (24, 24, 1, '2026-02-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (25, 25, 4, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (26, 26, 2, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (27, 27, 3, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (28, 28, 2, '2026-02-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (29, 29, 4, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (30, 30, 2, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (31, 31, 1, '2026-02-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (32, 32, 1, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (33, 33, 2, '2026-02-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (34, 34, 3, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (35, 35, 2, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (36, 36, 1, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (37, 37, 4, '2026-02-01', false);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (38, 38, 3, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (39, 39, 3, '2025-09-01', true);
INSERT INTO university.scholarship_assignments (assignment_id, student_id, scholarship_id, assignment_date, is_active) VALUES (40, 40, 2, '2026-02-01', true);


--
-- TOC entry 5200 (class 0 OID 16432)
-- Dependencies: 229
-- Data for Name: scholarships; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы scholarships
INSERT INTO university.scholarships (scholarship_id, type, amount, conditions) VALUES (1, 'Академическая', 2300.00, 'Успеваемость без троек, сессия на "4" и "5"');
INSERT INTO university.scholarships (scholarship_id, type, amount, conditions) VALUES (2, 'Повышенная академическая', 4300.00, 'Только отличники (все оценки "5")');
INSERT INTO university.scholarships (scholarship_id, type, amount, conditions) VALUES (3, 'Президентская', 7000.00, 'Победители олимпиад, особые научные достижения');
INSERT INTO university.scholarships (scholarship_id, type, amount, conditions) VALUES (4, 'Именная стипендия', 6000.00, 'Участие в проектах, хакатонах, научных работах');


--
-- TOC entry 5224 (class 0 OID 16688)
-- Dependencies: 253
-- Data for Name: session_results; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы session_results
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (1, 1, 4, 'Зачет', 1, '2026-01-21', 'Не сдано', 1, 1);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (2, 1, 7, 'Зачет', 1, '2026-01-17', 'Не сдано', 2, 2);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (3, 1, 30, 'Экзамен', 1, '2026-01-02', 'Сдано', 3, 3);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (4, 1, 29, 'Экзамен', 1, '2026-01-23', 'Сдано', 4, 4);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (5, 1, 12, 'Экзамен', 1, '2026-01-16', 'Не сдано', 5, 5);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (6, 1, 18, 'Экзамен', 1, '2026-01-30', 'Сдано', 6, 6);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (7, 1, 4, 'Экзамен', 1, '2026-01-19', 'Не сдано', 7, 7);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (8, 1, 13, 'Экзамен', 1, '2026-01-21', 'Не сдано', 8, 8);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (9, 1, 7, 'Зачет', 1, '2026-01-09', 'Не сдано', 9, 9);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (10, 1, 3, 'Зачет', 1, '2026-01-03', 'Не сдано', 10, 10);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (11, 1, 1, 'Экзамен', 1, '2026-01-08', 'Не сдано', 11, 11);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (12, 2, 1, 'Зачет', 1, '2026-01-15', 'Не сдано', 1, 1);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (13, 2, 5, 'Зачет', 1, '2026-01-30', 'Не сдано', 2, 2);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (14, 2, 12, 'Экзамен', 1, '2026-01-31', 'Не сдано', 3, 3);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (15, 2, 0, 'Экзамен', 1, '2026-01-22', 'Не сдано', 4, 4);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (16, 2, 25, 'Экзамен', 1, '2026-01-19', 'Сдано', 5, 5);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (17, 2, 0, 'Экзамен', 1, '2026-01-19', 'Не сдано', 6, 6);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (18, 2, 1, 'Экзамен', 1, '2026-01-27', 'Не сдано', 7, 7);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (19, 2, 7, 'Экзамен', 1, '2026-01-02', 'Не сдано', 8, 8);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (20, 2, 4, 'Зачет', 1, '2026-01-12', 'Не сдано', 9, 9);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (21, 2, 2, 'Зачет', 1, '2026-01-13', 'Не сдано', 10, 10);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (22, 2, 7, 'Экзамен', 1, '2026-01-30', 'Не сдано', 11, 11);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (23, 3, 19, 'Зачет', 1, '2026-01-17', 'Сдано', 1, 1);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (24, 3, 19, 'Зачет', 1, '2026-01-02', 'Сдано', 2, 2);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (25, 3, 26, 'Экзамен', 1, '2026-01-29', 'Сдано', 3, 3);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (26, 3, 25, 'Экзамен', 1, '2026-01-27', 'Сдано', 4, 4);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (27, 3, 12, 'Экзамен', 1, '2026-01-29', 'Не сдано', 5, 5);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (28, 3, 6, 'Экзамен', 1, '2026-01-09', 'Не сдано', 6, 6);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (29, 3, 20, 'Экзамен', 1, '2026-01-15', 'Сдано', 7, 7);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (30, 3, 0, 'Экзамен', 1, '2026-01-17', 'Не сдано', 8, 8);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (31, 3, 7, 'Зачет', 1, '2026-01-28', 'Не сдано', 9, 9);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (32, 3, 8, 'Зачет', 1, '2026-01-19', 'Не сдано', 10, 10);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (33, 3, 29, 'Экзамен', 1, '2026-01-13', 'Сдано', 11, 11);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (34, 4, 10, 'Зачет', 1, '2026-01-12', 'Сдано', 1, 1);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (35, 4, 7, 'Зачет', 1, '2026-01-07', 'Не сдано', 2, 2);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (36, 4, 5, 'Экзамен', 1, '2026-01-30', 'Не сдано', 3, 3);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (37, 4, 18, 'Экзамен', 1, '2026-01-31', 'Сдано', 4, 4);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (38, 4, 0, 'Экзамен', 1, '2026-01-07', 'Не сдано', 5, 5);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (39, 4, 17, 'Экзамен', 1, '2026-01-28', 'Сдано', 6, 6);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (40, 4, 26, 'Экзамен', 1, '2026-01-21', 'Сдано', 7, 7);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (41, 4, 8, 'Экзамен', 1, '2026-01-12', 'Не сдано', 8, 8);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (42, 4, 15, 'Зачет', 1, '2026-01-28', 'Сдано', 9, 9);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (43, 4, 20, 'Зачет', 1, '2026-01-24', 'Сдано', 10, 10);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (44, 4, 23, 'Экзамен', 1, '2026-01-20', 'Сдано', 11, 11);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (45, 5, 7, 'Зачет', 1, '2026-01-08', 'Не сдано', 1, 1);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (46, 5, 9, 'Зачет', 1, '2026-01-20', 'Не сдано', 2, 2);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (47, 5, 23, 'Экзамен', 1, '2026-01-10', 'Сдано', 3, 3);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (48, 5, 13, 'Экзамен', 1, '2026-01-23', 'Не сдано', 4, 4);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (49, 5, 7, 'Экзамен', 1, '2026-01-20', 'Не сдано', 5, 5);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (50, 5, 14, 'Экзамен', 1, '2026-01-07', 'Не сдано', 6, 6);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (51, 5, 11, 'Экзамен', 1, '2026-01-19', 'Не сдано', 7, 7);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (52, 5, 1, 'Экзамен', 1, '2026-01-05', 'Не сдано', 8, 8);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (53, 5, 11, 'Зачет', 1, '2026-01-31', 'Сдано', 9, 9);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (54, 5, 13, 'Зачет', 1, '2026-01-30', 'Сдано', 10, 10);
INSERT INTO university.session_results (result_id, student_id, grade, assessment_type, attempt_number, exam_date, status, discipline_id, teacher_id) VALUES (55, 5, 26, 'Экзамен', 1, '2026-01-17', 'Сдано', 11, 11);


--
-- TOC entry 5204 (class 0 OID 16465)
-- Dependencies: 233
-- Data for Name: sites; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы sites
INSERT INTO university.sites (site_id, city, address) VALUES (1, 'Санкт-Петербург', 'Кронверкский пр., д.49');
INSERT INTO university.sites (site_id, city, address) VALUES (2, 'Санкт-Петербург', 'ул. Ломоносова, д.9');
INSERT INTO university.sites (site_id, city, address) VALUES (3, 'Санкт-Петербург', 'Биржевая линия, д.14');


--
-- TOC entry 5194 (class 0 OID 16401)
-- Dependencies: 223
-- Data for Name: specializations; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы specializations
INSERT INTO university.specializations (spec_id, spec_code, name) VALUES (1, '09.03.03', 'Прикладная информатика');


--
-- TOC entry 5210 (class 0 OID 16514)
-- Dependencies: 239
-- Data for Name: student_groups; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы student_groups
INSERT INTO university.student_groups (group_id, group_number, course, start_date, end_date) VALUES (1, 'K3241', 2, '2024-09-01', '2028-06-30');
INSERT INTO university.student_groups (group_id, group_number, course, start_date, end_date) VALUES (2, 'K3240', 2, '2024-09-01', '2028-06-30');


--
-- TOC entry 5214 (class 0 OID 16554)
-- Dependencies: 243
-- Data for Name: students; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы students
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (1, 1, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (2, 2, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (3, 3, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (4, 4, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (5, 5, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (6, 6, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (7, 7, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (8, 8, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (9, 9, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (10, 10, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (11, 11, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (12, 12, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (13, 13, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (14, 14, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (15, 15, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (16, 16, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (17, 17, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (18, 18, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (19, 19, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (20, 20, 1, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (21, 21, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (22, 22, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (23, 23, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (24, 24, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (25, 25, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (26, 26, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (27, 27, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (28, 28, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (29, 29, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (30, 30, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (31, 31, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (32, 32, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (33, 33, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (34, 34, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (35, 35, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (36, 36, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (37, 37, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (38, 38, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (39, 39, 2, 'Активен', '2024-09-01', '2028-06-30');
INSERT INTO university.students (student_id, person_id, group_id, status, start_date, end_date) VALUES (40, 40, 2, 'Активен', '2024-09-01', '2028-06-30');


--
-- TOC entry 5192 (class 0 OID 16391)
-- Dependencies: 221
-- Data for Name: subdivisions; Type: TABLE DATA; Schema: university; Owner: postgres
--

-- заполнение таблицы subdivisions
INSERT INTO university.subdivisions (subdivision_id, name, type) VALUES (1, 'Факультет прикладной информатики', 'Факультет');


-- установка текущих значений последовательностей
SELECT pg_catalog.setval('university.classrooms_classroom_id_seq', 5, true);
SELECT pg_catalog.setval('university.curriculums_curriculum_id_seq', 1, true);
SELECT pg_catalog.setval('university.discipline_in_curriculum_dis_id_seq', 11, true);
SELECT pg_catalog.setval('university.disciplines_discipline_id_seq', 12, true);
SELECT pg_catalog.setval('university.education_programs_program_id_seq', 1, true);
SELECT pg_catalog.setval('university.job_history_history_id_seq', 11, true);
SELECT pg_catalog.setval('university.people_person_id_seq', 51, true);
SELECT pg_catalog.setval('university.positions_position_id_seq', 2, true);
SELECT pg_catalog.setval('university.schedules_schedule_id_seq', 13, true);
SELECT pg_catalog.setval('university.scholarship_assignments_assignment_id_seq', 40, true);
SELECT pg_catalog.setval('university.scholarships_scholarship_id_seq', 4, true);
SELECT pg_catalog.setval('university.session_results_result_id_seq', 55, true);
SELECT pg_catalog.setval('university.sites_site_id_seq', 3, true);
SELECT pg_catalog.setval('university.specializations_spec_id_seq', 1, true);
SELECT pg_catalog.setval('university.student_groups_group_id_seq', 2, true);
SELECT pg_catalog.setval('university.students_student_id_seq', 40, true);
SELECT pg_catalog.setval('university.subdivisions_subdivision_id_seq', 1, true);

-- добавление проверочных ограничений (не проверены)
ALTER TABLE university.students
    ADD CONSTRAINT check_dates CHECK ((end_date > start_date)) NOT VALID;

ALTER TABLE university.disciplines
    ADD CONSTRAINT check_full_hours CHECK ((full_hours >= (((hours_lectures + hours_practice) + hours_labs) + hours_seminars))) NOT VALID;

-- добавление первичных ключей
ALTER TABLE ONLY university.classrooms
    ADD CONSTRAINT classrooms_pkey PRIMARY KEY (classroom_id);

ALTER TABLE ONLY university.curriculums
    ADD CONSTRAINT curriculums_pkey PRIMARY KEY (curriculum_id);

ALTER TABLE ONLY university.discipline_in_curriculum
    ADD CONSTRAINT discipline_in_curriculum_pkey PRIMARY KEY (dis_id);

ALTER TABLE ONLY university.disciplines
    ADD CONSTRAINT disciplines_pkey PRIMARY KEY (discipline_id);

ALTER TABLE ONLY university.education_programs
    ADD CONSTRAINT education_programs_pkey PRIMARY KEY (program_id);

ALTER TABLE ONLY university.job_history
    ADD CONSTRAINT job_history_pkey PRIMARY KEY (history_id);

ALTER TABLE ONLY university.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (person_id);

ALTER TABLE ONLY university.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (position_id);

ALTER TABLE ONLY university.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (schedule_id);

ALTER TABLE ONLY university.scholarship_assignments
    ADD CONSTRAINT scholarship_assignments_pkey PRIMARY KEY (assignment_id);

ALTER TABLE ONLY university.scholarships
    ADD CONSTRAINT scholarships_pkey PRIMARY KEY (scholarship_id);

ALTER TABLE ONLY university.session_results
    ADD CONSTRAINT session_results_pkey PRIMARY KEY (result_id);

ALTER TABLE ONLY university.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (site_id);

ALTER TABLE ONLY university.specializations
    ADD CONSTRAINT specializations_pkey PRIMARY KEY (spec_id);

ALTER TABLE ONLY university.student_groups
    ADD CONSTRAINT student_groups_pkey PRIMARY KEY (group_id);

ALTER TABLE ONLY university.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);

ALTER TABLE ONLY university.subdivisions
    ADD CONSTRAINT subdivisions_pkey PRIMARY KEY (subdivision_id);

-- добавление уникальных ограничений
ALTER TABLE ONLY university.classrooms
    ADD CONSTRAINT uq_classroom_site UNIQUE (room_number, site_id);

ALTER TABLE ONLY university.curriculums
    ADD CONSTRAINT uq_curriculum_program_year UNIQUE (program_id, admission_year);

ALTER TABLE ONLY university.discipline_in_curriculum
    ADD CONSTRAINT uq_dis_curriculum_semester UNIQUE (curriculum_id, discipline_id, semester);

ALTER TABLE ONLY university.positions
    ADD CONSTRAINT uq_position_name UNIQUE (name);

ALTER TABLE ONLY university.education_programs
    ADD CONSTRAINT uq_program_name UNIQUE (name);

ALTER TABLE ONLY university.schedules
    ADD CONSTRAINT uq_schedule UNIQUE (classroom_id, event_date, start_time);

ALTER TABLE ONLY university.scholarships
    ADD CONSTRAINT uq_scholarship_type UNIQUE (type);

ALTER TABLE ONLY university.specializations
    ADD CONSTRAINT uq_spec UNIQUE (spec_code, name);

ALTER TABLE ONLY university.students
    ADD CONSTRAINT uq_student_person UNIQUE (person_id);

ALTER TABLE ONLY university.scholarship_assignments
    ADD CONSTRAINT uq_student_scholarship_date UNIQUE (student_id, scholarship_id, assignment_date);

ALTER TABLE ONLY university.subdivisions
    ADD CONSTRAINT uq_subdivision_name UNIQUE (name);

-- добавление внешних ключей
ALTER TABLE ONLY university.schedules
    ADD CONSTRAINT classroom_id FOREIGN KEY (classroom_id) REFERENCES university.classrooms(classroom_id);

ALTER TABLE ONLY university.discipline_in_curriculum
    ADD CONSTRAINT curriculum_id FOREIGN KEY (curriculum_id) REFERENCES university.curriculums(curriculum_id);

ALTER TABLE ONLY university.schedules
    ADD CONSTRAINT dis_id FOREIGN KEY (dis_id) REFERENCES university.discipline_in_curriculum(dis_id);

ALTER TABLE ONLY university.discipline_in_curriculum
    ADD CONSTRAINT discipline_id FOREIGN KEY (discipline_id) REFERENCES university.disciplines(discipline_id);

ALTER TABLE ONLY university.session_results
    ADD CONSTRAINT discipline_id FOREIGN KEY (discipline_id) REFERENCES university.discipline_in_curriculum(dis_id) NOT VALID;

ALTER TABLE ONLY university.students
    ADD CONSTRAINT group_id FOREIGN KEY (group_id) REFERENCES university.student_groups(group_id);

ALTER TABLE ONLY university.schedules
    ADD CONSTRAINT job_id FOREIGN KEY (job_id) REFERENCES university.job_history(history_id) NOT VALID;

ALTER TABLE ONLY university.job_history
    ADD CONSTRAINT person_id FOREIGN KEY (person_id) REFERENCES university.people(person_id) NOT VALID;

ALTER TABLE ONLY university.students
    ADD CONSTRAINT person_id FOREIGN KEY (person_id) REFERENCES university.people(person_id);

ALTER TABLE ONLY university.job_history
    ADD CONSTRAINT position_id FOREIGN KEY (position_id) REFERENCES university.positions(position_id);

ALTER TABLE ONLY university.curriculums
    ADD CONSTRAINT program_id FOREIGN KEY (program_id) REFERENCES university.education_programs(program_id);

ALTER TABLE ONLY university.scholarship_assignments
    ADD CONSTRAINT scholarship_id FOREIGN KEY (scholarship_id) REFERENCES university.scholarships(scholarship_id);

ALTER TABLE ONLY university.classrooms
    ADD CONSTRAINT site_id FOREIGN KEY (site_id) REFERENCES university.sites(site_id);

ALTER TABLE ONLY university.education_programs
    ADD CONSTRAINT spec_id FOREIGN KEY (spec_id) REFERENCES university.specializations(spec_id);

ALTER TABLE ONLY university.scholarship_assignments
    ADD CONSTRAINT student_id FOREIGN KEY (student_id) REFERENCES university.students(student_id);

ALTER TABLE ONLY university.session_results
    ADD CONSTRAINT student_id FOREIGN KEY (student_id) REFERENCES university.students(student_id);

ALTER TABLE ONLY university.education_programs
    ADD CONSTRAINT subdivision_id FOREIGN KEY (subdivision_id) REFERENCES university.subdivisions(subdivision_id);

ALTER TABLE ONLY university.job_history
    ADD CONSTRAINT subdivision_id FOREIGN KEY (subdivision_id) REFERENCES university.subdivisions(subdivision_id) NOT VALID;

ALTER TABLE ONLY university.disciplines
    ADD CONSTRAINT teacher_id FOREIGN KEY (teacher_id) REFERENCES university.job_history(history_id) NOT VALID;

ALTER TABLE ONLY university.session_results
    ADD CONSTRAINT teacher_id FOREIGN KEY (teacher_id) REFERENCES university.job_history(history_id) NOT VALID;

-- Completed on 2026-04-08 20:05:14

--
-- PostgreSQL database dump complete
--

\unrestrict zh06zgI5tFerzhMil5iSujdi6lYY0lMfombqQul6747U5CPQbDkwCItgkrzuwcw