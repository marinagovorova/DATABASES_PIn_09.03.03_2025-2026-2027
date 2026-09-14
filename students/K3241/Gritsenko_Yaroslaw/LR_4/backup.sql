--
-- PostgreSQL database dump
--

\restrict AwgT16A6KnIh82SQXIcJ797989g6XkUUCLc5c2rjLBwSkwdI19f72zM7bJ97L3a

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-24 15:50:00

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
-- TOC entry 265 (class 1255 OID 17360)
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
-- TOC entry 5127 (class 0 OID 0)
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
-- TOC entry 5128 (class 0 OID 0)
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
-- TOC entry 5129 (class 0 OID 0)
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
-- TOC entry 5130 (class 0 OID 0)
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
-- TOC entry 5131 (class 0 OID 0)
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
-- TOC entry 5132 (class 0 OID 0)
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
    lesson_date timestamp without time zone NOT NULL
);


ALTER TABLE public.lesson OWNER TO postgres;

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
-- TOC entry 5133 (class 0 OID 0)
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
-- TOC entry 5134 (class 0 OID 0)
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
    address character varying(50) NOT NULL,
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
-- TOC entry 5135 (class 0 OID 0)
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
-- TOC entry 5136 (class 0 OID 0)
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
-- TOC entry 5137 (class 0 OID 0)
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
-- TOC entry 5138 (class 0 OID 0)
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
-- TOC entry 5139 (class 0 OID 0)
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
-- TOC entry 5140 (class 0 OID 0)
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
-- TOC entry 4862 (class 2604 OID 17069)
-- Name: attestation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attestation ALTER COLUMN id SET DEFAULT nextval('public.attestation_new_id_seq'::regclass);


--
-- TOC entry 4854 (class 2604 OID 17087)
-- Name: classroom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom ALTER COLUMN id SET DEFAULT nextval('public.classroom_new_id_seq'::regclass);


--
-- TOC entry 4852 (class 2604 OID 17051)
-- Name: discipline id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline ALTER COLUMN id SET DEFAULT nextval('public.discipline_new_id_seq'::regclass);


--
-- TOC entry 4860 (class 2604 OID 17163)
-- Name: document_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_type ALTER COLUMN id SET DEFAULT nextval('public.document_type_new_id_seq'::regclass);


--
-- TOC entry 4861 (class 2604 OID 17172)
-- Name: graduation_document id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduation_document ALTER COLUMN id SET DEFAULT nextval('public.graduation_document_new_id_seq'::regclass);


--
-- TOC entry 4851 (class 2604 OID 17042)
-- Name: hours_volume id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hours_volume ALTER COLUMN id SET DEFAULT nextval('public.hours_volume_new_id_seq'::regclass);


--
-- TOC entry 4856 (class 2604 OID 17110)
-- Name: lesson id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN id SET DEFAULT nextval('public.lesson_new_id_seq'::regclass);


--
-- TOC entry 4855 (class 2604 OID 17101)
-- Name: lesson_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_type ALTER COLUMN id SET DEFAULT nextval('public.lesson_type_new_id_seq'::regclass);


--
-- TOC entry 4853 (class 2604 OID 17078)
-- Name: location id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location ALTER COLUMN id SET DEFAULT nextval('public.location_new_id_seq'::regclass);


--
-- TOC entry 4850 (class 2604 OID 17024)
-- Name: program id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program ALTER COLUMN id SET DEFAULT nextval('public.program_new_id_seq'::regclass);


--
-- TOC entry 4849 (class 2604 OID 17015)
-- Name: program_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_type ALTER COLUMN id SET DEFAULT nextval('public.program_type_new_id_seq'::regclass);


--
-- TOC entry 4857 (class 2604 OID 17129)
-- Name: student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_new_id_seq'::regclass);


--
-- TOC entry 4859 (class 2604 OID 17149)
-- Name: student_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_group ALTER COLUMN id SET DEFAULT nextval('public.student_group_new_id_seq'::regclass);


--
-- TOC entry 4858 (class 2604 OID 17138)
-- Name: teacher id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher ALTER COLUMN id SET DEFAULT nextval('public.teacher_new_id_seq'::regclass);


--
-- TOC entry 5105 (class 0 OID 16647)
-- Dependencies: 235
-- Data for Name: attestation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attestation (format, att_date, id) FROM stdin;
зачет	2026-07-27	1
зачет	2026-03-12	2
экзамен	2025-10-27	3
экзамен	2026-08-20	4
зачет	2025-10-31	5
зачет	2026-06-24	6
дифзачет	2025-08-26	7
дифзачет	2026-05-04	8
зачет	2026-02-17	9
дифзачет	2025-06-15	10
экзамен	2026-01-14	11
дифзачет	2025-10-03	12
зачет	2026-10-16	13
экзамен	2026-07-28	14
экзамен	2026-03-25	15
экзамен	2026-03-29	16
дифзачет	2026-07-09	17
дифзачет	2026-01-15	18
экзамен	2026-06-21	19
экзамен	2026-10-16	20
дифзачет	2025-10-25	21
дифзачет	2025-09-06	22
экзамен	2026-09-21	23
дифзачет	2026-09-27	24
дифзачет	2025-06-24	25
дифзачет	2026-07-14	26
дифзачет	2026-05-07	27
зачет	2025-07-22	28
зачет	2026-07-28	29
зачет	2026-07-31	30
экзамен	2026-04-19	31
дифзачет	2026-01-02	32
зачет	2026-06-30	33
дифзачет	2025-07-09	34
зачет	2026-04-05	35
экзамен	2025-09-08	36
экзамен	2025-12-20	37
зачет	2026-03-06	38
экзамен	2025-06-18	39
дифзачет	2026-08-02	40
дифзачет	2025-07-18	41
экзамен	2026-10-09	42
дифзачет	2026-08-01	43
зачет	2026-02-13	44
зачет	2026-01-04	45
зачет	2026-05-13	46
дифзачет	2026-09-07	47
зачет	2026-09-19	48
экзамен	2025-06-11	49
зачет	2025-07-04	50
дифзачет	2025-10-11	51
дифзачет	2025-08-10	52
зачет	2026-07-20	53
экзамен	2026-09-01	54
экзамен	2025-04-25	55
экзамен	2025-08-16	56
дифзачет	2026-09-20	57
экзамен	2025-08-18	58
дифзачет	2026-04-11	59
зачет	2026-06-11	60
зачет	2025-12-07	61
дифзачет	2026-02-21	62
дифзачет	2026-08-16	63
зачет	2026-07-17	64
зачет	2026-04-07	65
дифзачет	2025-09-23	66
зачет	2025-10-01	67
зачет	2026-10-06	68
экзамен	2025-12-26	69
экзамен	2025-12-13	70
зачет	2026-07-11	71
зачет	2026-10-04	72
экзамен	2025-12-17	73
зачет	2026-03-28	74
дифзачет	2026-01-17	75
зачет	2025-07-03	76
зачет	2026-07-21	77
дифзачет	2025-05-01	78
экзамен	2026-08-12	79
зачет	2026-05-26	80
экзамен	2026-03-04	81
экзамен	2025-08-02	82
зачет	2025-12-09	83
зачет	2025-06-12	84
экзамен	2026-02-05	85
зачет	2026-06-25	86
зачет	2025-06-05	87
экзамен	2025-04-25	88
экзамен	2026-10-23	89
дифзачет	2026-07-03	90
зачет	2026-01-29	91
дифзачет	2025-07-19	92
экзамен	2025-11-30	93
зачет	2025-05-19	94
экзамен	2025-10-24	95
зачет	2026-03-26	96
зачет	2026-10-22	97
дифзачет	2026-07-27	98
экзамен	2026-02-25	99
зачет	2026-08-23	100
\.


--
-- TOC entry 5095 (class 0 OID 16483)
-- Dependencies: 225
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classroom (room_number, type, location_id, id) FROM stdin;
333	аудитория	5	1
532	компьютерный класс	10	2
254	лаборатория	4	3
201	компьютерный класс	10	4
296	лаборатория	3	5
536	лекционная	1	6
347	лаборатория	8	7
154	лекционная	10	8
221	лаборатория	3	9
295	лекционная	5	10
392	лаборатория	7	11
283	компьютерный класс	4	12
394	компьютерный класс	9	13
251	лаборатория	9	14
458	лаборатория	3	15
251	лаборатория	8	16
111	лаборатория	6	17
524	лекционная	8	18
437	лекционная	3	19
302	компьютерный класс	7	20
240	лаборатория	2	21
104	аудитория	1	22
389	лаборатория	9	23
542	лекционная	8	24
451	лаборатория	5	25
498	аудитория	6	26
481	лекционная	4	27
598	аудитория	1	28
125	лаборатория	10	29
566	компьютерный класс	2	30
\.


--
-- TOC entry 5092 (class 0 OID 16439)
-- Dependencies: 222
-- Data for Name: discipline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discipline (description, hours_volume_id, id) FROM stdin;
Дисциплина 1: Актриса совет равнодушный выкинуть.	24	1
Дисциплина 2: За четко дальний спасть.	40	2
Дисциплина 3: Цепочка о рай успокоиться блин.	49	3
Дисциплина 4: Пятеро пропасть сустав рис умолять карман.	32	4
Дисциплина 5: Потянуться командование аллея находить.	41	5
Дисциплина 6: Вздрагивать механический ребятишки.	29	6
Дисциплина 7: Поймать песенка счастье славный прелесть.	49	7
Дисциплина 8: Торопливый нож дружно житель покинуть жестокий.	4	8
Дисциплина 9: Зима важный пища кольцо помимо дошлый.	14	9
Дисциплина 10: Написать спорт исследование горький собеседник военный.	18	10
Дисциплина 11: Заявление командование провал.	36	11
Дисциплина 12: Тута изучить поезд нервно.	9	12
Дисциплина 13: Дремать теория дремать.	19	13
Дисциплина 14: Промолчать приятель рай обида вздрагивать рис.	29	14
Дисциплина 59: Ведь металл ручей.	22	59
Дисциплина 15: Ремень вздрагивать задрать бабочка демократия некоторый.	45	15
Дисциплина 16: Набор господь кожа.	32	16
Дисциплина 17: Смертельный багровый крутой дальний угроза жить.	8	17
Дисциплина 18: Провинция металл палата командующий господь написать.	2	18
Дисциплина 19: Прощение стакан механический.	41	19
Дисциплина 20: Металл четко болото.	39	20
Дисциплина 21: Банда отъезд ремень дорогой дрогнуть.	16	21
Дисциплина 22: Ночь беспомощный протягивать.	46	22
Дисциплина 23: Холодно пастух собеседник новый прошептать аллея.	11	23
Дисциплина 24: Помолчать монета приятель.	20	24
Дисциплина 25: Угроза применяться мелочь потрясти.	36	25
Дисциплина 26: Палата аллея посидеть.	1	26
Дисциплина 27: Четыре магазин кпсс трясти еврейский.	36	27
Дисциплина 28: Очередной указанный полевой.	27	28
Дисциплина 29: Уничтожение возмутиться пасть цель парень.	6	29
Дисциплина 30: Правление рабочий еврейский природа ученый.	15	30
Дисциплина 31: Через столетие подземный инфекция разуметься.	8	31
Дисциплина 32: Мелочь болото рассуждение бригада.	30	32
Дисциплина 33: Трясти чувство более.	8	33
Дисциплина 34: Ход художественный умолять.	42	34
Дисциплина 35: Неожиданно смеяться висеть.	10	35
Дисциплина 36: Адвокат развитый сынок сохранять миллиард инструкция.	32	36
Дисциплина 37: Вытаскивать командование угол банк научить.	46	37
Дисциплина 38: Очутиться бок о кольцо.	19	38
Дисциплина 39: Картинка плавно сомнительный необычный.	33	39
Дисциплина 40: Умирать возмутиться сверкать тюрьма.	46	40
Дисциплина 41: Поставить дремать нервно вперед желание премьера пространство.	18	41
Дисциплина 42: Роса грудь степь багровый левый.	27	42
Дисциплина 43: Зато карман печатать правильный легко полностью.	31	43
Дисциплина 44: Район за природа невозможно провинция.	31	44
Дисциплина 45: Ягода инструкция вскакивать изредка выбирать.	16	45
Дисциплина 46: Помолчать конференция изба бак ход наслаждение.	30	46
Дисциплина 47: Кидать коммунизм наткнуться зеленый.	36	47
Дисциплина 48: Кольцо триста темнеть рассуждение князь бегать.	10	48
Дисциплина 49: Написать выкинуть освобождение зарплата боец.	25	49
Дисциплина 50: Поговорить еврейский успокоиться дрогнуть чем.	13	50
Дисциплина 51: Спорт низкий редактор.	39	51
Дисциплина 52: Изменение мера а четыре.	33	52
Дисциплина 53: Покинуть отъезд граница близко ленинград.	48	53
Дисциплина 54: Расстройство инвалид спешить невозможно.	9	54
Дисциплина 55: Растеряться заработать столетие недостаток изучить.	5	55
Дисциплина 56: Выгнать поймать боец.	18	56
Дисциплина 57: Совет исполнять передо.	50	57
Дисциплина 58: Жидкий инструкция интеллектуальный поколение.	27	58
Дисциплина 60: Мера бригада точно жидкий.	33	60
Дисциплина 61: Четыре порода а.	18	61
Дисциплина 62: Задержать домашний отъезд головка.	1	62
Дисциплина 63: Счастье наступать дошлый жестокий господь.	19	63
Дисциплина 64: Палка пятеро висеть.	47	64
Дисциплина 65: Реклама предоставить издали применяться вывести.	20	65
Дисциплина 66: Порядок ставить чем.	38	66
Дисциплина 67: Неправда нервно степь коричневый смертельный.	38	67
Дисциплина 68: Миллиард засунуть угроза художественный мусор.	43	68
Дисциплина 69: Неудобно означать смелый набор цвет означать.	32	69
Дисциплина 70: Совет штаб пробовать протягивать расстройство.	10	70
Дисциплина 71: Миллиард невозможно князь иной чем.	29	71
Дисциплина 72: Сохранять космос передо легко.	35	72
Дисциплина 73: Разуметься потом снимать умирать танцевать.	31	73
Дисциплина 74: Актриса функция поставить нож девка.	23	74
Дисциплина 75: Космос болото художественный умолять скрытый.	22	75
Дисциплина 76: Горький юный ботинок прежний.	36	76
Дисциплина 77: Построить ответить освободить цепочка товар мимо.	49	77
Дисциплина 78: Умолять падаль поезд.	35	78
Дисциплина 79: Развитый кидать дыхание строительство равнодушный.	25	79
Дисциплина 80: Степь коричневый голубчик потом совет.	30	80
Дисциплина 81: Наслаждение палка шлем хлеб.	21	81
Дисциплина 82: Процесс порода кольцо запустить запустить забирать.	13	82
Дисциплина 83: Рай миллиард бок посвятить скрытый.	45	83
Дисциплина 84: Крутой левый доставать столетие прежде актриса.	16	84
Дисциплина 85: Набор еврейский страсть ярко страсть.	37	85
Дисциплина 86: Табак деньги тюрьма провал.	25	86
Дисциплина 87: Космос порядок картинка девка лапа.	15	87
Дисциплина 88: Покидать перебивать за.	50	88
Дисциплина 89: Слишком космос спешить виднеться наткнуться.	27	89
Дисциплина 90: Назначить серьезный редактор.	3	90
Дисциплина 91: Монета зеленый дальний сверкающий неправда.	21	91
Дисциплина 92: Картинка командующий возбуждение порядок посидеть умирать.	48	92
Дисциплина 93: Дрогнуть мягкий мера анализ слать.	31	93
Дисциплина 94: Приличный бровь падаль.	46	94
Дисциплина 95: Написать головка призыв.	25	95
Дисциплина 96: Пятеро миг костер.	25	96
Дисциплина 97: Прощение вряд болото редактор.	43	97
Дисциплина 98: Мелькнуть постоянный банк июнь.	42	98
Дисциплина 99: Торопливый четко войти единый неожиданно.	10	99
Дисциплина 100: Инвалид художественный экзамен жидкий.	32	100
\.


--
-- TOC entry 5106 (class 0 OID 16656)
-- Dependencies: 236
-- Data for Name: discipline_attestation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discipline_attestation (discipline_id, attestation_id) FROM stdin;
89	59
44	36
25	32
65	43
72	100
63	98
2	66
49	53
37	97
80	95
7	1
55	50
40	77
62	10
58	58
64	62
88	93
10	45
28	5
79	53
16	49
99	65
8	75
14	24
84	43
1	8
96	81
38	18
13	37
54	72
57	43
22	39
23	93
5	87
69	90
52	19
14	99
51	29
94	98
27	93
73	60
73	69
50	49
61	49
20	17
39	30
39	94
93	10
60	7
89	22
66	2
87	98
44	8
13	5
50	24
67	95
24	69
77	41
26	20
41	39
36	70
91	70
17	11
83	20
98	2
77	98
47	45
88	83
100	48
10	90
29	79
75	64
33	58
69	32
34	32
32	77
90	18
30	31
53	8
53	72
74	40
49	20
85	49
29	99
26	45
7	96
75	66
6	51
95	53
52	91
46	72
71	71
70	51
51	31
82	71
40	74
3	73
4	72
87	33
91	24
61	87
90	22
83	38
31	9
86	64
97	9
100	8
92	68
23	87
35	52
72	37
16	48
1	59
79	6
81	3
11	70
42	85
82	75
21	1
17	49
3	59
18	84
59	12
27	25
5	40
20	68
12	9
68	96
15	99
59	69
48	41
56	33
36	30
19	23
54	54
48	68
78	48
66	28
76	93
43	53
24	49
45	81
9	6
19	16
76	13
46	64
74	34
41	31
\.


--
-- TOC entry 5103 (class 0 OID 16609)
-- Dependencies: 233
-- Data for Name: document_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.document_type (type_name, id) FROM stdin;
сертификат о повышении квалификации	1
удостоверение о повышении квалификации	2
диплом о профпереподготовке	3
\.


--
-- TOC entry 5104 (class 0 OID 16618)
-- Dependencies: 234
-- Data for Name: graduation_document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.graduation_document (program_id, document_type_id, student_id, doc_number, issue_date, id) FROM stdin;
19	3	12	90125	2025-08-26	1
10	1	35	61451	2026-01-26	2
11	2	139	86939	2025-09-20	3
7	2	119	24972	2025-09-29	4
8	2	78	55603	2025-09-20	5
6	1	3	56135	2025-10-11	6
3	3	36	70012	2025-11-22	7
20	3	88	90918	2025-07-16	8
13	2	72	32613	2026-01-07	9
10	2	2	98288	2025-07-01	10
16	3	64	48986	2025-10-26	11
15	3	19	90541	2025-06-18	12
6	3	91	87354	2025-07-07	13
20	2	81	21108	2025-11-26	14
9	3	30	98094	2025-09-21	15
11	2	103	27556	2026-03-18	16
13	1	111	51049	2026-04-19	17
18	1	108	25448	2025-09-11	18
8	1	112	41270	2026-03-17	19
14	2	40	50026	2025-10-04	20
1	1	106	25328	2025-06-23	21
7	2	84	33992	2025-08-15	22
6	3	140	58929	2026-03-29	23
1	3	141	28528	2026-01-10	24
12	2	20	76954	2025-06-12	25
1	1	27	60916	2025-06-16	26
6	2	138	64819	2025-04-29	27
10	2	69	88174	2025-05-22	28
4	1	22	28070	2026-01-01	29
13	2	96	85340	2025-05-01	30
5	1	127	60293	2025-06-19	31
17	1	147	65448	2026-01-30	32
19	2	55	34347	2026-04-03	33
15	3	111	73788	2025-10-31	34
13	1	150	93296	2026-01-05	35
19	1	17	80435	2025-10-11	36
18	3	93	94575	2025-06-16	37
8	3	67	32706	2025-05-27	38
13	2	46	82733	2025-06-17	39
7	3	62	31871	2025-12-30	40
12	3	59	74178	2026-03-03	41
13	1	84	47858	2025-10-03	42
15	1	51	28388	2026-03-25	43
9	3	136	34523	2025-10-19	44
18	3	2	51232	2026-04-07	45
15	2	70	69113	2026-02-25	46
14	2	75	91187	2026-01-20	47
3	2	75	17026	2025-12-15	48
6	3	28	57059	2026-04-21	49
6	2	142	11256	2025-10-07	50
10	1	18	73518	2025-12-23	51
10	2	35	27895	2025-07-03	52
16	2	52	35575	2025-10-18	53
15	3	51	60324	2025-11-08	54
2	1	70	83607	2025-10-06	55
16	1	90	76248	2025-11-25	56
17	2	143	95599	2026-03-09	57
11	2	63	74876	2025-10-16	58
19	1	85	63626	2025-09-21	59
5	3	128	99744	2025-09-09	60
14	1	76	74451	2025-07-21	61
13	3	60	64477	2025-07-06	62
13	2	40	68176	2025-10-06	63
8	3	76	74054	2025-12-15	64
9	2	135	31922	2025-04-27	65
4	1	93	20835	2025-12-05	66
11	1	102	84107	2025-11-04	67
8	3	145	14044	2026-03-19	68
16	3	75	38905	2026-02-02	69
14	2	43	48284	2025-07-25	70
14	3	86	14285	2026-01-26	71
8	2	148	46025	2025-11-05	72
14	1	97	39470	2025-08-07	73
18	1	22	80465	2025-10-01	74
13	1	37	47836	2026-04-19	75
7	2	55	32047	2025-11-23	76
5	2	30	69942	2025-12-04	77
13	1	110	84140	2025-09-14	78
6	3	77	74921	2025-05-07	79
18	1	91	82053	2025-05-09	80
2	1	21	76952	2025-12-01	81
17	3	137	24838	2025-10-29	82
15	2	113	85066	2026-01-23	83
3	1	34	24969	2025-09-15	84
14	3	128	45112	2025-06-07	85
5	2	129	81186	2025-12-06	86
11	2	98	58085	2025-10-29	87
14	2	144	81046	2026-01-18	88
6	3	48	15453	2025-05-26	89
1	3	74	67850	2025-06-19	90
3	2	19	81611	2026-02-02	91
10	3	58	38644	2026-02-03	92
2	1	136	65725	2025-11-15	93
7	3	5	23423	2026-03-24	94
19	2	62	95678	2026-02-10	95
1	2	30	42444	2026-02-21	96
6	2	9	49021	2025-08-11	97
19	2	123	14224	2025-10-22	98
17	1	63	68947	2025-11-11	99
16	1	142	44447	2025-05-25	100
2	1	89	55688	2025-11-14	101
1	1	28	21401	2026-04-05	102
17	1	25	67549	2025-12-17	103
16	1	7	25386	2025-05-29	104
18	3	133	41056	2025-07-29	105
11	3	102	37509	2025-10-25	106
19	1	30	87060	2025-12-25	107
13	2	104	55957	2026-02-07	108
13	3	40	89988	2026-01-07	109
6	1	98	92938	2026-01-09	110
18	3	72	66120	2025-05-25	111
10	2	108	31755	2026-01-15	112
6	1	111	90760	2025-12-27	113
16	1	124	28249	2025-11-20	114
9	1	93	37082	2026-02-28	115
17	2	53	37124	2025-12-06	116
13	1	69	17780	2025-08-24	117
11	2	80	84720	2025-12-19	118
17	3	126	55982	2025-05-15	119
\.


--
-- TOC entry 5107 (class 0 OID 16673)
-- Dependencies: 237
-- Data for Name: group_lesson_teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_lesson_teacher (group_id, lesson_id, teacher_id) FROM stdin;
8	145	21
4	145	1
24	84	28
20	7	1
27	8	20
2	37	29
27	115	2
24	38	15
20	105	11
30	91	5
13	138	3
20	139	22
4	141	26
19	117	16
22	164	8
16	128	29
27	39	3
15	43	9
28	162	9
9	99	18
8	167	30
30	45	19
6	34	11
5	110	29
19	63	8
24	56	13
3	188	27
23	28	10
3	117	3
21	72	15
11	100	25
26	24	14
4	125	4
24	11	1
2	83	14
27	98	20
23	198	7
8	185	15
1	153	25
4	83	2
28	36	12
12	11	14
18	83	8
17	4	28
7	27	5
2	64	13
19	52	7
5	167	13
11	108	1
18	129	25
27	110	21
17	63	2
28	5	1
10	156	16
13	101	23
18	147	15
27	91	16
18	64	26
13	21	27
2	101	21
12	56	25
3	24	7
12	68	17
13	72	19
15	198	16
1	69	21
14	169	26
9	26	5
25	57	19
15	69	19
6	1	15
14	187	24
5	52	21
29	64	19
19	78	18
30	180	2
1	35	5
13	40	21
29	121	18
28	125	29
29	15	9
17	99	30
17	46	24
10	53	26
1	138	26
14	157	6
30	92	10
6	20	23
19	119	5
23	52	18
7	188	28
14	62	6
22	112	26
5	22	21
16	43	22
8	43	14
12	102	23
18	14	10
22	16	30
2	162	3
22	20	9
28	64	13
30	61	27
1	174	23
29	41	25
28	98	11
19	142	19
9	90	20
6	58	4
5	93	8
26	33	19
2	183	21
4	175	28
14	23	23
23	189	4
17	94	26
2	126	26
21	61	28
3	72	23
1	83	30
9	151	3
5	177	6
24	24	17
9	81	24
29	60	2
20	60	25
23	116	15
30	179	18
18	70	3
20	163	28
7	123	5
21	27	30
1	147	28
13	131	21
19	145	29
18	20	29
19	23	12
3	95	28
5	96	3
30	8	6
30	145	2
18	58	6
26	17	15
23	35	12
25	119	13
11	82	25
22	35	5
3	178	12
7	81	21
28	52	19
23	70	11
24	183	18
12	161	21
7	23	25
10	200	10
18	96	28
19	3	25
22	152	28
7	95	22
5	1	22
21	183	12
27	55	14
1	181	2
28	165	17
15	188	21
15	200	23
26	51	2
4	34	15
12	74	3
1	44	14
2	148	25
4	148	27
1	25	28
7	19	13
9	187	8
12	4	23
26	85	27
16	41	4
3	132	21
15	33	3
30	189	16
7	77	5
25	51	30
20	3	24
21	37	29
8	3	24
14	15	4
27	72	16
24	64	24
24	68	12
4	87	21
3	192	22
8	113	20
30	82	29
1	132	5
20	89	13
14	117	1
18	31	10
5	65	14
25	32	21
24	31	13
28	123	1
15	192	9
7	99	27
2	38	9
21	136	29
23	20	4
12	16	14
11	93	6
28	183	20
23	84	6
10	133	8
9	23	26
17	12	30
11	4	22
25	4	21
30	181	16
26	114	30
21	53	8
12	130	13
13	22	21
15	96	17
10	49	4
25	16	3
11	146	3
8	90	22
29	197	30
22	101	10
14	63	1
13	84	10
13	53	22
18	82	13
28	92	8
9	193	9
7	59	25
3	199	14
9	110	20
27	175	8
27	71	18
5	71	24
3	149	13
24	181	9
30	146	3
4	196	6
25	27	12
5	41	10
2	174	3
8	136	7
17	39	23
27	45	10
16	146	19
29	26	8
16	66	8
24	78	10
27	48	29
19	160	26
14	112	5
21	24	24
10	7	2
24	155	6
15	31	3
5	34	2
24	41	2
29	136	27
14	80	12
4	13	15
3	118	16
3	1	7
16	27	17
14	156	16
18	173	28
15	8	15
18	185	2
28	140	6
5	24	23
29	150	24
5	78	21
11	136	18
25	34	9
3	84	18
11	34	16
25	25	27
15	110	12
6	133	28
16	198	24
25	200	19
27	128	20
10	177	21
6	55	1
23	200	25
22	130	22
23	150	15
23	82	15
6	123	1
30	152	26
10	78	29
20	178	24
23	60	14
2	195	15
22	146	11
10	131	13
21	16	23
21	108	17
29	169	28
9	32	21
16	95	24
14	171	17
26	166	6
26	32	24
27	9	9
28	135	11
21	12	3
4	88	30
14	30	23
10	169	26
19	190	25
28	108	30
10	101	16
8	157	5
14	190	17
4	73	4
11	94	19
3	125	26
25	36	22
6	152	27
17	121	18
19	75	24
30	46	7
18	107	17
29	62	26
26	6	2
24	176	22
23	180	5
24	179	27
1	75	9
13	80	25
15	86	17
9	36	8
29	92	26
19	95	25
21	126	14
6	175	14
5	168	25
10	192	8
\.


--
-- TOC entry 5091 (class 0 OID 16423)
-- Dependencies: 221
-- Data for Name: hours_volume; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hours_volume (lectures, lab_works, practical, internship, id) FROM stdin;
20	7	34	5	1
12	13	30	8	2
46	37	33	19	3
18	6	12	9	4
14	23	11	9	5
0	34	8	8	6
2	3	35	9	7
44	8	40	15	8
6	0	36	9	9
30	30	28	10	10
11	3	16	15	11
7	4	25	15	12
4	36	40	1	13
9	9	36	9	14
5	15	7	17	15
48	26	38	19	16
50	39	14	16	17
24	28	28	9	18
55	37	27	9	19
36	39	3	19	20
47	6	13	20	21
13	16	5	5	22
15	11	35	2	23
10	0	26	14	24
44	38	30	9	25
2	14	18	9	26
44	29	4	7	27
59	16	40	18	28
42	12	27	3	29
34	14	9	8	30
52	9	4	1	31
10	19	38	18	32
58	18	28	3	33
29	19	25	8	34
32	34	31	14	35
5	38	2	13	36
47	20	38	8	37
1	5	14	18	38
37	1	17	18	39
2	11	30	16	40
41	28	17	5	41
37	27	40	15	42
5	30	22	13	43
21	20	6	5	44
21	26	31	9	45
42	25	35	1	46
29	5	20	8	47
20	7	25	16	48
52	0	34	14	49
26	3	12	16	50
\.


--
-- TOC entry 5097 (class 0 OID 16508)
-- Dependencies: 227
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson (classroom_id, lesson_type_id, id, lesson_date) FROM stdin;
21	2	1	2025-09-01 17:10:00
30	3	2	2025-09-02 09:50:00
10	3	3	2025-09-03 18:50:00
14	1	4	2025-09-04 11:30:00
5	1	5	2025-09-05 13:30:00
2	2	6	2025-09-06 13:30:00
16	1	7	2025-09-07 11:30:00
4	1	8	2025-09-08 11:30:00
29	3	9	2025-09-09 17:10:00
5	2	10	2025-09-10 11:30:00
15	2	11	2025-09-11 09:50:00
22	3	12	2025-09-12 18:50:00
23	3	13	2025-09-13 11:30:00
14	3	14	2025-09-14 08:10:00
24	3	15	2025-09-15 09:50:00
5	2	16	2025-09-16 18:50:00
21	1	17	2025-09-17 18:50:00
27	2	18	2025-09-18 09:50:00
20	2	19	2025-09-19 08:10:00
9	1	20	2025-09-20 18:50:00
23	2	21	2025-09-21 09:50:00
7	2	22	2025-09-22 17:10:00
15	1	23	2025-09-23 11:30:00
28	2	24	2025-09-24 17:10:00
4	3	25	2025-09-25 09:50:00
12	3	26	2025-09-26 11:30:00
29	3	27	2025-09-27 17:10:00
12	1	28	2025-09-28 11:30:00
13	2	29	2025-09-29 13:30:00
7	1	30	2025-09-30 18:50:00
28	2	31	2025-10-01 09:50:00
3	3	32	2025-10-02 18:30:00
7	3	33	2025-10-03 13:30:00
21	3	34	2025-10-04 09:50:00
1	1	35	2025-10-05 13:30:00
26	2	36	2025-10-06 09:50:00
8	1	37	2025-10-07 13:30:00
26	3	38	2025-10-08 09:50:00
7	1	39	2025-10-09 08:10:00
27	3	40	2025-10-10 09:50:00
7	3	41	2025-10-11 09:50:00
7	1	42	2025-10-12 11:30:00
11	1	43	2025-10-13 08:10:00
26	3	44	2025-10-14 18:50:00
1	2	45	2025-10-15 11:30:00
28	1	46	2025-10-16 13:30:00
5	3	47	2025-10-17 11:30:00
9	1	48	2025-10-18 15:30:00
4	3	49	2025-10-19 17:10:00
28	1	50	2025-10-20 09:50:00
5	1	51	2025-10-21 18:50:00
12	1	52	2025-10-22 11:30:00
19	2	53	2025-10-23 11:30:00
1	1	54	2025-10-24 08:10:00
9	1	55	2025-10-25 08:10:00
5	3	56	2025-10-26 18:00:00
14	3	57	2025-10-27 08:10:00
4	3	58	2025-10-28 11:30:00
3	2	59	2025-10-29 13:30:00
15	2	60	2025-10-30 08:10:00
17	3	61	2025-10-31 13:30:00
4	2	62	2025-11-01 17:10:00
17	1	63	2025-11-02 09:50:00
20	1	64	2025-11-03 15:30:00
24	3	65	2025-11-04 18:50:00
17	2	66	2025-11-05 08:10:00
15	3	67	2025-11-06 17:10:00
1	1	68	2025-11-07 09:50:00
16	2	69	2025-11-08 13:30:00
14	3	70	2025-11-09 18:50:00
4	2	71	2025-11-10 13:30:00
23	2	72	2025-11-11 17:10:00
3	1	73	2025-11-12 11:30:00
11	3	74	2025-11-13 17:10:00
5	1	75	2025-11-14 18:50:00
5	2	76	2025-11-15 08:10:00
20	3	77	2025-11-16 18:50:00
19	3	78	2025-11-17 15:30:00
23	2	79	2025-11-18 18:50:00
13	3	80	2025-11-19 08:10:00
17	2	81	2025-11-20 18:50:00
15	3	82	2025-11-21 15:30:00
20	2	83	2025-11-22 15:30:00
4	3	84	2025-11-23 18:50:00
4	3	85	2025-11-24 09:50:00
21	3	86	2025-11-25 13:30:00
24	1	87	2025-11-26 09:50:00
14	2	88	2025-11-27 18:50:00
29	1	89	2025-11-28 15:30:00
14	2	90	2025-11-29 17:10:00
27	2	91	2025-11-30 11:30:00
13	2	92	2025-12-01 08:10:00
24	1	93	2025-12-02 17:10:00
11	2	94	2025-12-03 18:50:00
11	3	95	2025-12-04 09:50:00
9	2	96	2025-12-05 13:30:00
5	3	97	2025-12-06 15:30:00
30	2	98	2025-12-07 15:30:00
3	1	99	2025-12-08 08:10:00
27	1	100	2025-12-09 17:10:00
3	2	101	2025-12-10 08:00:00
4	3	102	2025-12-11 18:50:00
24	2	103	2025-12-12 13:30:00
26	1	104	2025-12-13 16:30:00
18	1	105	2025-12-14 17:10:00
19	3	106	2025-12-15 08:10:00
18	2	107	2025-12-16 13:30:00
22	1	108	2025-12-17 17:10:00
14	2	109	2025-12-18 08:10:00
28	3	110	2025-12-19 17:10:00
25	2	111	2025-12-20 17:10:00
28	3	112	2025-12-21 17:10:00
2	2	113	2025-12-22 09:50:00
20	2	114	2025-12-23 17:10:00
12	1	115	2025-12-24 08:10:00
19	3	116	2025-12-25 18:50:00
7	1	117	2025-12-26 18:50:00
22	2	118	2025-12-27 15:30:00
8	1	119	2025-12-28 09:00:00
12	3	120	2025-12-29 09:00:00
12	1	121	2025-12-30 11:30:00
25	2	122	2025-12-31 18:50:00
19	1	123	2026-01-01 11:30:00
26	2	124	2026-01-02 11:30:00
28	3	125	2026-01-03 13:30:00
25	3	126	2026-01-04 17:10:00
20	3	127	2026-01-05 15:30:00
21	3	128	2026-01-06 17:10:00
1	3	129	2026-01-07 18:50:00
30	3	130	2026-01-08 11:30:00
27	3	131	2026-01-09 18:50:00
9	1	132	2026-01-10 18:50:00
6	2	133	2026-01-11 17:10:00
23	2	134	2026-01-12 09:50:00
30	2	135	2026-01-13 13:30:00
12	1	136	2026-01-14 11:30:00
6	1	137	2026-01-15 08:10:00
19	3	138	2026-01-16 08:10:00
13	1	139	2026-01-17 13:30:00
5	3	140	2026-01-18 13:30:00
21	1	141	2026-01-19 11:30:00
3	3	142	2026-01-20 11:30:00
17	1	143	2026-01-21 17:10:00
13	2	144	2026-01-22 17:10:00
15	2	145	2026-01-23 09:50:00
6	2	146	2026-01-24 08:10:00
10	3	147	2026-01-25 13:30:00
11	3	148	2026-01-26 09:50:00
20	1	149	2026-01-27 10:00:00
29	1	150	2026-01-28 17:10:00
5	1	151	2026-01-29 08:10:00
25	3	152	2026-01-30 09:50:00
2	3	153	2026-01-31 15:30:00
3	2	154	2026-02-01 09:50:00
15	3	155	2026-02-02 18:50:00
14	2	156	2026-02-03 09:50:00
20	2	157	2026-02-04 09:50:00
14	2	158	2026-02-05 17:10:00
7	3	159	2026-02-06 08:10:00
4	2	160	2026-02-07 08:10:00
14	1	161	2026-02-08 17:10:00
10	3	162	2026-02-09 11:30:00
22	3	163	2026-02-10 09:50:00
16	3	164	2026-02-11 17:10:00
22	2	165	2026-02-12 14:30:00
2	1	166	2026-02-13 15:30:00
13	3	167	2026-02-14 18:50:00
2	1	168	2026-02-15 15:30:00
7	2	169	2026-02-16 13:30:00
7	1	170	2026-02-17 13:30:00
25	2	171	2026-02-18 17:10:00
10	2	172	2026-02-19 13:30:00
4	1	173	2026-02-20 08:10:00
16	3	174	2026-02-21 15:30:00
14	1	175	2026-02-22 17:10:00
5	2	176	2026-02-23 17:10:00
18	3	177	2026-02-24 13:30:00
8	3	178	2026-02-25 13:30:00
18	3	179	2026-02-26 18:50:00
26	2	180	2026-02-27 15:00:00
3	2	181	2026-02-28 08:10:00
28	3	182	2026-03-01 15:30:00
2	2	183	2026-03-02 15:30:00
1	2	184	2026-03-03 09:50:00
30	1	185	2026-03-04 15:30:00
28	2	186	2026-03-05 11:30:00
19	2	187	2026-03-06 09:50:00
19	2	188	2026-03-07 13:30:00
23	3	189	2026-03-08 11:30:00
14	2	190	2026-03-09 13:30:00
4	2	191	2026-03-10 18:50:00
1	2	192	2026-03-11 09:50:00
6	3	193	2026-03-12 15:30:00
15	3	194	2026-03-13 13:30:00
30	2	195	2026-03-14 15:30:00
3	2	196	2026-03-15 18:50:00
28	1	197	2026-03-16 08:10:00
8	2	198	2026-03-17 15:30:00
19	2	199	2026-03-18 08:10:00
17	1	200	2026-03-19 09:50:00
\.


--
-- TOC entry 5096 (class 0 OID 16499)
-- Dependencies: 226
-- Data for Name: lesson_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson_type (name, id) FROM stdin;
лекция	1
лабораторная работа	2
практическое занятие	3
\.


--
-- TOC entry 5094 (class 0 OID 16473)
-- Dependencies: 224
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location (name, address, id) FROM stdin;
Мосинжпроект	п. Кизилюрт, бул. Кузнечный, д. 196, 133890	1
Афанасьев Лимитед	с. Чикола, ш. Лесное, д. 66 к. 3, 511615	2
ЗАО «Лобанов-Кабанова»	д. Гремячинск (Бурят.), ул. Кирова, д. 4 к. 503, 3	3
ИП «Рогов Гаврилов»	д. Златоуст, бул. Владимирский, д. 77 стр. 9, 5030	4
РАО «Родионов-Якушева»	клх Тамбов, бул. Гафури, д. 34 к. 98, 969653	5
ЗАО «Кузнецова Королев»	п. Ямбург, ш. Челюскинцев, д. 866, 801845	6
ИП «Беспалов»	г. Кулу, ш. Водопроводное, д. 448 стр. 35, 957015	7
АО «Андреев-Трофимов»	клх Ступино, ш. Кедровое, д. 97, 489638	8
ГК Агро-Белогорье	клх Одинцово, пер. Микрорайон, д. 233 к. 1, 930103	9
РАО «Кононова»	д. Когалым, бул. Вахитова, д. 38 к. 4/8, 311656	10
\.


--
-- TOC entry 5090 (class 0 OID 16401)
-- Dependencies: 220
-- Data for Name: program; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program (code, name, description, total_hours, cost, program_type_id, id) FROM stdin;
PRG-009	Программа 9: Эргономичная и гибкая сеть Интранет	\N	187	64634	1	9
PRG-001	Программа 1: Разнообразный и заметный модератор	Ночь сынок роса развитый. Слишком зато сопровождаться применяться неожиданно еврейский. Коммунизм аллея засунуть порода.\nТерапия изучить обида команда левый. Сбросить передо вчера назначить. Актриса легко кольцо армейский инфекция механический.\nМонета исполнять изба наткнуться костер издали непривычный упорно. Поймать другой сбросить невыносимый поставить ответить. Развернуться решение неожиданный вытаскивать вряд чувство пол. Второй помимо неудобно что хозяйка плод угроза.\nКосмос райком командир дальний естественный.\nКнязь покидать жестокий чем тяжелый болото. Расстройство намерение вывести чем. Угроза мягкий коллектив интернет полюбить отметить.\nПрелесть новый освободить цель. Возможно уронить уронить проход.\nСветило казнь исследование. Сомнительный ярко ботинок картинка тусклый.\nДемократия зачем народ мелочь порядок возмутиться.\nВряд услать посидеть мимо солнце развитый лететь. Ночь выдержать мера коричневый. Мера аж боец помолчать уточнить.	104	136672	5	1
PRG-007	Программа 7: Оцифрованный и национальный эталон	Гулять интернет покидать дьявол серьезный смелый висеть.\nЧувство один основание вздрагивать покидать изображать построить. Еврейский актриса металл плясать. Запустить упор снимать аж другой гулять слишком.\nГорький пересечь аж каюта хотеть промолчать монета ученый. Помимо угроза более сбросить функция. Более засунуть смеяться волк школьный нервно.\nБолее девка скользить слать оставить сопровождаться. Нервно оставить функция актриса вскинуть палка механический.\nВыгнать выдержать боец отдел выразить назначить белье пол. Непривычный карман слишком головной угодный протягивать низкий дальний. Мотоцикл каюта неожиданно командование сутки перебивать.\nХлеб бригада понятный процесс правильный постоянный район. Боец неожиданно бригада указанный отдел поговорить.\nУмолять аллея сынок ход. Бабочка дурацкий рай заведение князь вытаскивать. Заплакать плавно упор выбирать.\nВитрина табак народ инструкция издали. Мучительно багровый развитый виднеться трясти потом витрина.	202	169311	4	7
PRG-013	Программа 13: Цельная и нейтральная миграция	Спорт виднеться жестокий руководитель второй цель наступать тревога. Что ночь чувство район. Пасть премьера тусклый ботинок остановить.\nПолностью командование пробовать точно бак пламя исполнять. Крыса дальний прежде пропаганда. Построить изба дальний заявление болото степь рассуждение. Возможно тюрьма монета анализ кузнец горький.\nПламя хлеб неправда.\nУказанный магазин рабочий художественный сверкающий металл отдел. Нервно перебивать заведение результат развернуться рай некоторый мрачно. Роса падаль вскакивать настать триста.\nБагровый наткнуться жидкий плод экзамен райком печатать.\nЭкзамен через скрытый счастье желание. Упорно пятеро отметить низкий выраженный банда. Находить достоинство постоянный появление ставить цель.\nКоллектив вариант картинка упорно коммунизм. Юный металл дремать рабочий.	114	69014	5	13
PRG-018	Программа 18: Открытая и итернациональная база данных	Освободить висеть аж исследование. Бак указанный цель идея домашний опасность.\nПрежний промолчать изучить виднеться помолчать мелочь. Возможно назначить уточнить юный поздравлять прошептать.\nСовещание темнеть серьезный. Поговорить вскинуть пятеро коробка оставить холодно обида.\nТрубка прелесть помимо разуметься отражение неправда факультет число. Фонарик место теория горький палата боец.\nВыражаться помолчать означать засунуть.\nПрисесть отдел слишком выразить волк прощение палата. Сбросить житель избегать провал соответствие что. За необычный смертельный господь. Цель спорт передо терапия хозяйка.\nИзредка хозяйка естественный угодный чувство господь призыв пища. Запретить оборот передо оборот. Пятеро уничтожение район затянуться.\nЭффект граница палка. Ставить равнодушный девка возникновение тесно.\nЖестокий недостаток солнце. Ломать зарплата деньги желание.	278	80400	5	18
PRG-002	Программа 2: Универсальный и прибыльный доступ	Означать полевой гулять задержать мера освобождение заведение. Сопровождаться полюбить голубчик нервно падать.\nИнструкция трясти провинция падать мотоцикл увеличиваться цепочка. Умолять прелесть желание обида уничтожение художественный горький.\nВойти разводить торговля бак развитый спичка.\nФункция забирать увеличиваться бригада прощение боец. Командование дрогнуть серьезный да спешить функция металл.\nЦвет народ пламя кузнец. Блин легко смелый сутки правление. Каюта уничтожение ход зато свежий спорт.\nВисеть легко палец успокоиться. Лапа заработать место пространство демократия.\nГрустный лиловый сравнение пространство низкий ученый адвокат четыре. Житель неудобно казнь спалить сохранять.\nПрежде даль порог палец рот. Кузнец товар угроза приятель банда. Угроза валюта собеседник увеличиваться песенка банда вывести пространство.\nОпасность зима сомнительный лететь. Оборот кпсс головка пища некоторый необычный. Пятеро изображать разуметься прелесть поймать обида домашний.	91	132465	1	2
PRG-003	Программа 3: Переосмысленная и широкопрофильная служба техподдержки	Зачем изба миллиард правление конструкция ягода. Спичка конференция равнодушный дорогой даль разводить крутой. Заявление печатать невозможно а.\nПонятный написать неудобно коробка ручей трясти. Нажать правление сутки печатать аллея аллея. Слать конструкция мотоцикл поговорить советовать.\nВыраженный трубка куча единый.\nПравильный кузнец пересечь набор мусор деньги порт угроза. Цепочка наткнуться хлеб уточнить. Предоставить пламя угроза возбуждение деньги указанный.\nКоллектив советовать сверкающий протягивать руководитель присесть гулять. Багровый стакан важный поймать отдел войти четко лететь. Мучительно подробность боец покинуть находить прежний пропаганда.\nОснование коробка а сомнительный мальчишка сынок. Правый самостоятельно низкий тута дружно спорт.\nНыне важный сверкающий.\nСлишком расстегнуть растеряться командующий решетка выразить избегать. Светило плод мусор поймать ручей. Собеседник очко растеряться назначить.	273	9925	2	3
PRG-004	Программа 4: Настраиваемая и двунаправленная иерархия	Очутиться горький тяжелый вряд головка поймать.\nМрачно хотеть запустить развернуться ремень висеть освободить инструкция. Космос подземный пространство полоска дошлый мальчишка падать. Мера ведь степь слать прежний изучить металл. Инфекция жидкий магазин мотоцикл.\nМеханический пространство направо головной одиннадцать. Лететь дьявол палата премьера место изображать очутиться. Смелый четыре приходить палец бетонный неудобно доставать. Вывести ярко князь носок результат.\nЛиловый дружно термин видимо. Голубчик отражение механический бровь. Серьезный способ присесть совещание исследование головной девка. Посидеть сынок полностью даль.\nУгол инструкция страсть слишком заведение самостоятельно торопливый. Угодный фонарик необычный мгновение угодный протягивать миф.\nФакультет холодно картинка угроза возбуждение. Полюбить провал левый нож дорогой. Вперед указанный покидать неправда картинка.	119	27077	4	4
PRG-005	Программа 5: Бизнес-ориентированная и пошаговая реализация	Падать эффект дальний райком разнообразный. Угроза парень отдел роскошный угроза.\nСветило дрогнуть перебивать шлем монета пол. Место угол космос находить. Четыре картинка какой порт ботинок.\nТермин изменение трубка экзамен темнеть роса штаб.\nДрогнуть монета серьезный поезд триста интеллектуальный. Дальний развитый расстройство пламя провал растеряться изменение угодный.\nМрачно возбуждение армейский неправда. Блин бригада дурацкий палата число.\nРоса сустав трубка подземный. Вообще торопливый увеличиваться настать.\nРеклама изображать запеть лететь упорно бак. Команда развернуться холодно исполнять успокоиться. Мусор пространство заведение поздравлять хотеть.\nБанк научить нажать печатать прошептать. Гулять гулять роскошный второй.\nБлин поймать монета что страсть сынок. Решение неожиданный очередной страсть о палата другой спалить. Еврейский жидкий хозяйка дурацкий.	175	103126	5	5
PRG-006	Программа 6: Превентивная и аналитическая служба поддержки	Выбирать угроза приятель деньги заложить вздрогнуть четыре.\nБочок заведение человечек развитый медицина. Сомнительный товар палата район бак. Господь господь команда неожиданно увеличиваться природа дыхание порода. Куча горький доставать крыса порт функция.\nБригада порог растеряться жестокий свежий совещание. Призыв подземный устройство куча шлем выражаться о помимо.\nИздали нож экзамен второй. Пламя картинка пасть зато. Расстройство дремать около инструкция.\nУгодный выражение кидать дорогой секунда. Поймать миф оборот запустить изредка отъезд. Вытаскивать сынок эпоха.\nЧисло пространство расстройство рис даль солнце счастье. Самостоятельно мелькнуть задрать костер место. Смелый человечек трясти прежде избегать мера.\nГрудь дрогнуть невыносимый картинка. Угроза жидкий ответить освобождение.\nЛиловый шлем выкинуть второй тусклый. Ответить металл забирать ход. Развитый термин выгнать славный.\nЗасунуть угол засунуть коричневый. Выгнать космос тусклый падаль. Блин легко предоставить четыре.	81	100244	5	6
PRG-008	Программа 8: Эргономичное и прибыльное ядро	Трясти песенка банк затянуться висеть а собеседник. Правление проход грустный труп. Кузнец сынок солнце отъезд запеть. Миф руководитель миллиард сопровождаться.\nПровал миг решетка домашний плод тысяча господь спорт. Коммунизм функция девка чем пространство находить лететь. Отъезд скрытый снимать разуметься холодно тесно. Освободить художественный кожа.\nПровинция миф мальчишка о граница ответить дружно рис. Термин товар растеряться. Художественный опасность прошептать затянуться адвокат командир сомнительный. Рай анализ крыса терапия лететь нож лиловый.\nКомандующий пропадать уронить результат военный плод команда. Серьезный отъезд голубчик.\nЗеленый научить невозможно бочок.\nРеклама приятель господь вздрагивать означать одиннадцать. Народ основание мера торговля секунда медицина юный нож.\nЯгода скользить о товар. Висеть рай зато. Граница торговля поймать академик палата тусклый. Спорт налоговый костер передо грустный лететь.	58	183549	1	8
PRG-010	Программа 10: Виртуальная и мультимедийная защищенная линия	Банк иной отъезд белье торопливый. Монета коммунизм затянуться умирать.\nПромолчать протягивать тяжелый посидеть демократия тревога бок человечек. Мелочь жестокий армейский успокоиться столетие. Заведение заработать успокоиться штаб домашний советовать.\nПространство левый передо манера. Важный анализ бак дурацкий торговля. Художественный спешить наступать цвет тревога домашний поговорить равнодушный. Устройство число школьный плясать оставить бровь неожиданно.\nПространство аж налоговый спасть полностью один нож. Передо идея посидеть прежний способ табак важный. Грустный умолять счастье самостоятельно дьявол карандаш.\nРеклама валюта слишком миф коллектив развитый. Процесс рабочий уронить выразить очутиться бегать стакан. Устройство лиловый появление бегать тревога появление пища страсть.\nТусклый желание пятеро ведь ночь задержать ягода. Смеяться аж пересечь проход. Девка отъезд ответить бабочка выкинуть.	90	188246	1	10
PRG-011	Программа 11: Сосредоточенное и наглядное решение	Райком миллиард коммунизм стакан неожиданно вздрагивать. Левый функция головной число хотеть холодно запретить.\nМедицина совет выгнать кузнец подробность материя сбросить.\nВторой костер металл привлекать остановить выгнать встать. Оставить уронить умолять металл хотеть неожиданно. Заявление термин болото горький поговорить дружно вскинуть.\nИсследование инвалид растеряться издали роса какой более.\nТемнеть спалить князь вскакивать необычный разнообразный июнь командование. Выгнать потянуться сохранять темнеть ломать сынок предоставить. Спалить промолчать да правый.\nКосмос освобождение деловой домашний. Что полностью вскинуть.\nЧто трубка сынок степь. Господь фонарик ныне доставать цель интеллектуальный.\nГоспожа житель жестокий ведь. Монета волк инвалид танцевать ложиться. Задержать счастье бок фонарик спасть войти салон. Угол пища премьера угроза появление.\nПостроить бак научить сынок. Актриса армейский непривычный танцевать руководитель невозможно.	193	13847	1	11
PRG-012	Программа 12: Общедоступная и составная эмуляция	Выгнать провинция деловой цепочка разнообразный сбросить коричневый. Совет тута процесс призыв четыре ночь легко. Появление экзамен заложить низкий прощение означать.\nСохранять помолчать человечек поезд. Картинка печатать витрина некоторый услать выбирать правление. Запустить намерение низкий разуметься рассуждение.\nБоец бабочка пламя цель. Спорт торговля потянуться легко прошептать слишком невозможно.\nПробовать заявление расстройство дальний дыхание белье господь. Выкинуть магазин медицина школьный команда советовать.\nЗима шлем налоговый крыса спешить неправда цель. Смеяться степь картинка тревога жидкий.\nКнязь головной применяться вскакивать освобождение лапа очутиться. Команда багровый вообще роса сохранять бровь песенка.\nРоса отдел услать призыв торговля появление вообще. Миг аллея посидеть потрясти недостаток рот задрать.	68	90094	3	12
PRG-014	Программа 14: Новый и промежуточный модератор	Палка мучительно зима свежий интеллектуальный. Висеть разнообразный человечек деньги терапия. Основание построить вчера.\nВыбирать тусклый коричневый радость ответить. Неправда сомнительный армейский проход решетка экзамен. Спешить недостаток шлем.\nСвежий низкий услать нож деловой сверкающий. Рот ученый тяжелый чем более иной чувство научить.\nВажный порт бегать банк сверкать миф. Научить поговорить природа посидеть поговорить деньги. Необычный кидать видимо сохранять коммунизм рассуждение поймать.\nМимо войти развернуться стакан дошлый куча бровь. Спасть вообще промолчать манера пол господь оборот домашний.\nДеньги жестокий эпоха исследование тута. Помолчать художественный более вздрогнуть. Очутиться слать разводить. Совещание цвет факультет находить пересечь вытаскивать боец.\nПлод развернуться вряд витрина. Товар зеленый забирать дремать спичка правление. Возмутиться космос инвалид даль счастье.	132	54516	2	14
PRG-015	Программа 15: Фундаментальная и составная установка	\N	235	184198	2	15
PRG-016	Программа 16: Ориентированная и основная локальная сеть	Заявление через банк угодный аллея лететь. Скользить солнце уточнить правый дальний бак а. Вздрагивать вперед плясать желание доставать космос легко свежий.\nРасстройство очутиться очутиться прежде зима салон самостоятельно. Низкий дружно миг очутиться славный радость возмутиться неправда.\nКосмос прошептать четко направо. Парень миг назначить порядок. Ботинок боец степь пропадать.\nВолк палец свежий да торговля руководитель. Кпсс штаб грустный манера число медицина находить мелькнуть. Мотоцикл применяться невозможно пространство через присесть.\nВозбуждение холодно основание построить. Инфекция очередной сопровождаться кузнец вперед.\nИной устройство песенка запретить правление. Провинция крутой через нож порядок. Упор князь поколение карман.\nВстать бок поколение. Совещание падаль новый уничтожение нож рассуждение. Ответить другой командир скользить. Вытаскивать протягивать эпоха лапа точно.\nКрыса помимо дыхание построить совещание еврейский за. Бегать тревога смертельный.	113	72453	4	16
PRG-017	Программа 17: Опциональный и промежуточный альянс	Выдержать запеть рота умирать миллиард сынок. Очередной нервно скользить порт тюрьма.\nВозникновение школьный салон художественный расстегнуть. Триста призыв посвятить необычный народ дружно пол равнодушный. Госпожа командир горький.\nРазводить голубчик кпсс уточнить цель постоянный. Выражаться лететь головка человечек пасть. Поговорить запустить кольцо магазин смелый коричневый возможно.\nЧерез некоторый свежий разводить. Валюта чувство отражение командир проход чувство пропадать. Заявление слишком девка.\nПокидать изредка дрогнуть изредка рабочий. Более дошлый мягкий засунуть крутой. Цель миллиард счастье изба достоинство угол вперед.\nМелочь угроза место природа зато затянуться мучительно. Новый снимать гулять. Бетонный тута скользить доставать страсть. Команда страсть тусклый головка выражение непривычный неправда.\nЗасунуть витрина налево господь костер присесть. Спорт нервно заведение заведение прелесть чем а. Отражение появление приятель.\nРайон потрясти штаб материя зима.	275	79125	1	17
PRG-019	Программа 19: Ориентированное и яркое сотрудничество	\N	266	105146	5	19
PRG-020	Программа 20: Многоканальный и отказостойкий альянс	\N	257	204557	3	20
\.


--
-- TOC entry 5093 (class 0 OID 16455)
-- Dependencies: 223
-- Data for Name: program_discipline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program_discipline (discipline_id, program_id) FROM stdin;
21	16
56	19
45	19
37	15
5	10
65	15
24	8
7	1
84	4
45	3
83	5
85	2
9	1
37	17
92	17
66	7
13	1
38	9
95	6
26	16
22	12
3	8
83	7
85	4
14	17
75	3
30	13
83	16
68	6
51	20
49	11
16	17
71	17
54	19
80	10
51	4
58	19
44	8
98	18
18	16
7	16
48	17
21	18
43	2
44	10
99	10
72	1
18	9
31	12
21	11
17	4
67	17
13	9
35	18
87	1
57	15
68	15
40	8
77	11
12	19
24	11
48	14
95	10
86	7
77	4
37	2
29	19
100	15
58	18
60	15
61	14
93	12
90	4
81	1
33	16
79	13
68	10
49	15
20	9
83	1
47	8
70	10
43	1
4	19
96	13
85	10
90	6
19	19
25	14
57	12
40	5
20	2
6	12
20	11
40	14
31	20
78	16
58	13
69	13
17	6
19	3
33	2
85	3
10	9
72	5
48	20
97	13
87	12
55	7
47	12
28	8
25	9
65	20
29	9
86	6
78	2
53	12
87	14
93	2
37	13
88	6
99	15
49	5
\.


--
-- TOC entry 5089 (class 0 OID 16392)
-- Dependencies: 219
-- Data for Name: program_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program_type (type_name, id) FROM stdin;
Повышение квалификации	1
Профессиональная переподготовка	2
Краткосрочный курс	3
Семинар	4
Мастер-класс	5
\.


--
-- TOC entry 5098 (class 0 OID 16529)
-- Dependencies: 228
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (first_name, last_name, middle_name, phone, passport, education, id) FROM stdin;
Никодим	Титова	\N	8 046 362 8719	4765 650012	высшее	151
Федот	Степанова	\N	+7 382 785 0471	3082 429615	\N	152
Конон	Комарова	Леонидовна	8 568 829 84 04	9503 622090	\N	153
Харитон	Щукин	\N	+7 (441) 771-6984	7504 598865	среднее профессиональное	154
Агап	Ермакова	Богданович	+7 637 330 5445	2168 899539	среднее	155
Варвара	Медведев	\N	+7 909 837 5523	9256 353426	высшее	156
Ярополк	Лобанов	Изотович	+70688619747	3544 950757	высшее	157
Ираида	Гордеева	Глебович	+73225353013	7603 104626	неоконченное высшее	158
Марфа	Андреева	Демидович	+7 (196) 527-6538	2870 642841	высшее	159
Агап	Русаков	Бенедиктович	+7 (959) 501-16-84	6262 800658	\N	160
Самуил	Горбунова	\N	8 (546) 693-50-60	2284 106638	среднее профессиональное	161
Феврония	Фадеев	\N	+7 (535) 982-54-14	9652 968316	\N	162
Евпраксия	Исаков	Антонович	8 207 611 38 32	6402 577861	среднее профессиональное	163
Елизар	Тихонов	Руслановна	8 286 083 0618	3111 493522	неоконченное высшее	164
Надежда	Миронова	\N	8 659 974 55 80	5825 309546	среднее	165
Валентина	Кондратьева	Измаилович	+7 554 998 30 56	5748 819184	\N	166
Милован	Горшков	\N	8 236 765 89 44	2239 853810	неоконченное высшее	167
Нестор	Бирюкова	\N	8 (014) 008-52-48	2257 194704	неоконченное высшее	168
Данила	Аксенов	\N	+7 (731) 163-8070	8010 512888	неоконченное высшее	169
Сократ	Гусева	\N	+7 (136) 973-93-94	5381 936527	среднее профессиональное	170
Олег	Шарова	Матвеевич	+7 902 087 6907	2463 152186	среднее профессиональное	171
Лев	Моисеев	Эдгарович	+7 387 317 67 46	6256 695299	высшее	172
Любовь	Одинцов	\N	87153403563	4669 196380	высшее	173
Валентин	Доронин	Феликсовна	+7 (848) 178-21-20	1838 842411	\N	174
Геннадий	Ершова	Арсенович	+7 (579) 335-8075	5421 854590	неоконченное высшее	175
Нифонт	Суханов	Фролович	8 (329) 241-4969	4076 323856	среднее профессиональное	176
Панкратий	Хохлова	Архипович	+79398479606	5016 931086	высшее	177
Мартьян	Ермакова	Еремеевич	+7 331 237 42 15	6210 283566	среднее профессиональное	178
Эдуард	Гуляева	Евстигнеевич	8 (821) 065-60-41	9848 851625	неоконченное высшее	179
Александра	Голубев	\N	8 (615) 392-76-66	6939 130352	высшее	180
Моисей	Копылов	Егорович	+7 (909) 899-4047	9511 600364	среднее профессиональное	181
Федор	Шубин	Давыдович	+72440919224	6707 662700	среднее профессиональное	182
Михей	Зимина	Егоровна	+7 988 552 16 11	6864 470444	высшее	183
Влас	Павлов	Викторовна	8 (276) 551-42-65	5827 270054	среднее профессиональное	184
Вероника	Егорова	Тарасович	84337242789	7223 627095	\N	185
Татьяна	Ильина	Ефимьевич	+7 514 069 98 36	1659 269146	\N	186
Тит	Коновалова	\N	+75199936365	1815 811073	неоконченное высшее	187
Емельян	Сергеев	Руслановна	8 (027) 699-51-91	2893 847220	неоконченное высшее	188
Юрий	Дементьева	\N	8 (907) 996-3514	2496 191835	\N	189
Савватий	Крюкова	\N	8 592 905 9721	5104 910562	неоконченное высшее	190
Авдей	Кабанов	Марсович	8 476 147 9908	2703 523103	неоконченное высшее	191
Ульяна	Романова	\N	+7 (535) 415-9155	4177 435787	высшее	192
Савва	Носова	\N	+72943736295	2800 430964	неоконченное высшее	193
Селиверст	Гусева	\N	+7 (540) 077-15-95	8609 865412	высшее	194
Матвей	Родионова	\N	+7 353 576 0815	7576 662529	высшее	195
Никанор	Жданов	Федосеевич	+7 (087) 602-28-89	1816 303949	среднее	196
Агафон	Крылов	\N	+7 512 076 86 11	4799 186527	среднее	197
Павел	Мамонтов	\N	80354757061	4875 338627	среднее профессиональное	198
Захар	Доронин	Эдуардович	+74361528305	9443 486390	неоконченное высшее	199
Прокл	Фадеев	\N	86600198389	4440 206714	среднее профессиональное	200
Изяслав	Афанасьев	Бориславович	8 507 958 4685	6459 651227	\N	201
Николай	Михайлов	\N	8 829 124 15 97	1746 703505	среднее	202
Аверьян	Соболева	\N	+7 741 840 8644	4959 336675	среднее	203
Дмитрий	Константинова	Николаевна	+7 (825) 666-9107	7495 771466	высшее	204
Соломон	Галкин	Архипович	8 (871) 764-40-09	5150 905693	среднее профессиональное	205
Мариан	Хохлова	\N	8 (661) 709-3298	1719 232780	\N	206
Алина	Макаров	\N	+75923291726	6459 846503	неоконченное высшее	207
Изот	Богданов	Ефимович	8 (086) 061-6672	9192 615389	среднее	208
Наталья	Семенов	\N	+7 (819) 399-63-38	3683 647439	среднее профессиональное	209
Олимпиада	Устинова	Виленович	+71062087331	6072 375163	высшее	210
Борислав	Куликов	Архипович	8 (863) 885-1573	2952 987531	неоконченное высшее	211
Соломон	Крылов	Эльдаровна	8 (139) 756-0818	7828 926300	среднее профессиональное	212
Анастасия	Сафонов	Тимофеевна	8 (500) 850-91-41	1467 831196	неоконченное высшее	213
Марк	Дмитриева	\N	+7 762 976 4276	7564 794773	среднее	214
Селиван	Кононов	Харитоновна	8 941 686 44 13	7892 591316	среднее	215
Эмилия	Константинова	Игнатьевич	+70431868656	9875 963405	\N	216
Варлаам	Панова	\N	+7 006 321 02 38	8452 856279	неоконченное высшее	217
Конон	Носков	\N	+7 (256) 998-39-03	5760 964552	неоконченное высшее	218
Анатолий	Никонова	\N	8 779 565 7795	8186 346991	\N	219
Николай	Яковлева	Измаилович	8 (370) 219-31-45	4869 661908	неоконченное высшее	220
Варвара	Яковлева	\N	+7 081 309 6978	7377 811437	\N	221
Аверьян	Сазонова	\N	+7 (649) 819-92-68	9062 424490	среднее профессиональное	222
Якуб	Мамонтов	\N	8 (653) 941-32-53	3211 889934	среднее	223
Мирослав	Ковалев	Демьянович	8 109 752 6676	8884 566260	среднее профессиональное	224
Тимур	Виноградова	Максимовна	+7 (276) 703-3546	1623 264551	неоконченное высшее	225
Игнатий	Владимиров	\N	+7 101 233 93 64	5958 224254	среднее профессиональное	226
Юлий	Соловьев	\N	8 060 066 87 64	2053 490434	неоконченное высшее	227
Творимир	Дементьева	Арсенович	+7 686 129 4128	5694 250616	неоконченное высшее	228
Наина	Кондратьева	\N	8 (314) 373-05-68	1777 851706	высшее	229
Трофим	Соколова	\N	+7 (876) 998-88-13	1495 947621	высшее	230
Данила	Наумов	Матвеевич	81692579008	5774 774926	среднее профессиональное	231
Феврония	Алексеева	Фомич	+7 (623) 513-7052	2337 285458	среднее профессиональное	232
Ян	Гусева	Гертрудович	8 115 565 1169	4512 248414	неоконченное высшее	233
Милица	Копылова	Викторовна	8 459 881 42 89	8746 937776	высшее	234
Людмила	Баранов	Даниловна	+7 (796) 645-74-64	1376 421349	\N	235
Иван	Третьяков	Якубович	+7 840 693 13 47	3934 209588	неоконченное высшее	236
Карп	Владимиров	Дмитриевич	+7 520 079 98 06	8311 594732	\N	237
Нестор	Герасимова	\N	8 466 721 6132	6480 851658	среднее	238
Николай	Овчинников	Фролович	+7 926 484 6460	6677 864993	неоконченное высшее	239
Болеслав	Логинов	Эдгарович	8 (919) 713-2507	2907 126874	среднее	240
Оксана	Петухова	Владленович	+7 649 290 64 41	1172 370935	\N	241
Валентин	Пономарев	\N	+7 800 425 7179	2285 806888	неоконченное высшее	242
Родион	Архипова	Иосифович	8 691 654 25 41	8417 845856	неоконченное высшее	243
Леон	Мясникова	Ааронович	8 (804) 497-9334	8033 630257	высшее	244
Кондрат	Ильин	Вилорович	84831520353	1478 660926	среднее	245
Виталий	Рябова	Кирилловна	8 (369) 310-91-79	1758 774939	\N	246
Алла	Щербакова	Владленович	8 293 035 48 72	3753 686818	среднее	247
Тарас	Капустина	\N	8 (704) 678-71-21	9862 208316	среднее профессиональное	248
Казимир	Богданов	Владиславович	8 830 411 45 74	7597 672590	среднее профессиональное	249
Андрон	Кузнецов	Анисимович	8 835 307 64 02	2204 510150	среднее	250
Демид	Третьяков	\N	+7 (396) 885-5074	8598 934899	высшее	251
Станислав	Шестакова	Викторович	8 (285) 251-63-48	8372 367860	среднее профессиональное	252
Леон	Власова	Терентьевич	8 (883) 789-9812	3115 279439	среднее профессиональное	253
Филимон	Гусев	\N	+7 (939) 756-15-86	7145 243652	неоконченное высшее	254
Мартын	Лебедев	\N	8 452 174 0131	4266 848006	высшее	255
Карп	Муравьев	Тимуровна	+7 (661) 114-6681	9545 509306	\N	256
Макар	Шестаков	Кирилловна	+7 (372) 872-8402	6717 107070	высшее	257
Мариан	Зайцева	\N	85438810613	7968 894897	\N	258
Гостомысл	Ситников	\N	89100012040	1331 400094	среднее	259
Мартьян	Антонова	Альбертовна	+7 376 213 2379	1184 794826	среднее	260
Аскольд	Борисова	\N	8 061 278 6339	2024 522895	среднее профессиональное	261
Мина	Белякова	\N	8 286 497 2057	4339 293795	среднее профессиональное	262
Софон	Селезнев	\N	8 (431) 204-3420	6353 944807	среднее профессиональное	263
Пров	Полякова	Александрович	87892427653	2764 869573	среднее	264
Макар	Горбачева	Абрамович	+7 (158) 478-33-02	6370 269327	среднее профессиональное	265
Михаил	Пахомов	Ефимовна	8 012 540 0843	1498 475008	среднее	266
Лука	Евдокимова	Елисеевич	8 709 426 3371	3746 658869	среднее	267
Ипат	Горбунов	Теймуразович	+76078747273	7571 201774	\N	268
Светлана	Кудрявцев	Рубеновна	8 (928) 168-28-15	9129 698267	\N	269
Евдоким	Бурова	\N	82020152874	9716 528905	среднее	270
Сильвестр	Федосеев	Болеславовна	+7 (725) 078-4494	2538 312777	неоконченное высшее	271
Андроник	Евдокимов	\N	+78687403450	9486 587115	среднее	124
Валерия	Нестеров	Егорович	+7 566 765 27 75	2988 578634	высшее	125
Спартак	Лукин	Феликсовна	+7 616 928 45 11	9702 686075	неоконченное высшее	126
Макар	Коновалова	Ерофеевич	+77962757059	8251 742412	\N	127
Платон	Хохлов	Егоровна	+7 165 820 2970	9976 567574	высшее	128
Владлен	Кузьмин	Данилович	8 569 092 7557	8777 571932	неоконченное высшее	129
София	Степанов	Борисовна	+7 (856) 543-10-27	5543 903013	\N	130
Спартак	Носов	Артемовна	+7 447 394 73 12	5499 561239	среднее	131
Афанасий	Лихачев	Всеволодович	8 (155) 188-44-22	4841 384913	неоконченное высшее	132
Митофан	Волкова	Давидович	+7 323 705 89 57	9849 184491	высшее	133
Устин	Осипов	\N	81146786691	7275 827659	высшее	134
Владлен	Меркушева	Жоресович	+7 778 528 92 26	2052 535020	\N	135
Сила	Сазонова	Антонович	+7 824 225 35 84	8633 535970	среднее	136
Богдан	Овчинников	\N	+7 (842) 498-1829	7883 508396	среднее	137
Фома	Тимофеев	Власович	89590010943	7232 600149	среднее	138
Тамара	Сергеева	Фёдорович	80784473647	5892 890075	\N	139
Афанасий	Власова	Ануфриевич	+7 (767) 735-92-55	7865 664365	высшее	140
Наталья	Кононова	Изотович	8 258 815 37 14	5471 557007	\N	141
Радим	Горшков	\N	+7 (104) 696-32-59	6507 801364	\N	142
Марина	Исаев	Геннадиевич	+7 (787) 747-01-68	8657 233827	среднее	143
Ратмир	Пестова	Демидович	+7 (950) 047-9748	1444 188025	\N	144
Авксентий	Терентьева	\N	+7 624 565 06 09	8564 290556	среднее	145
Феликс	Колесников	\N	8 841 687 8499	6363 321941	\N	146
Викторин	Сидоров	Богданович	8 558 523 98 68	7211 391773	\N	147
Андрон	Тарасов	\N	+7 257 872 9825	2341 593152	среднее	148
Юлий	Кабанов	Владиславович	8 949 588 87 94	1853 466960	высшее	149
Савелий	Лапина	Аверьянович	8 516 940 9749	1659 890870	среднее	150
Якуб	Осипов	\N	84385984709	8862 773857	неоконченное высшее	272
Илья	Дьячков	Натановна	8 696 789 3751	3842 236041	среднее	273
Наркис	Владимиров	Игоревна	+70417467897	2490 737781	среднее профессиональное	274
Варфоломей	Анисимова	\N	82537917016	7294 719887	\N	275
Майя	Игнатов	\N	+7 988 011 21 68	3255 905456	неоконченное высшее	276
Любим	Лапина	\N	+7 (509) 018-90-74	2747 565302	среднее	277
Наркис	Панфилов	\N	8 418 267 95 91	3664 790282	среднее профессиональное	278
Епифан	Агафонова	\N	8 420 295 69 28	8495 830623	неоконченное высшее	279
Милан	Стрелков	\N	8 922 919 66 38	9202 549010	высшее	280
Самуил	Кошелева	Архипович	89475465118	2236 641819	неоконченное высшее	281
Матвей	Романова	Егорович	+79416049742	1037 626030	среднее профессиональное	282
Денис	Пономарева	\N	+7 744 229 28 28	7351 265726	\N	283
Аким	Богданов	Натановна	8 (877) 273-6667	4037 209877	\N	284
Радим	Вишняков	\N	+7 (709) 745-7889	1323 569964	среднее	285
Карп	Кондратьева	Владиславовна	8 (080) 449-28-69	9001 280113	среднее профессиональное	286
Фока	Ковалев	\N	8 289 180 57 32	6821 283156	высшее	287
Вера	Иванова	Елисеевич	+72089533909	2191 311322	высшее	288
Феоктист	Волков	\N	8 (709) 066-51-85	1600 320271	\N	289
Галактион	Гуляева	Ермолаевич	8 557 459 61 76	4080 702432	среднее профессиональное	290
Прокл	Молчанов	Валерианович	+7 (433) 301-2727	5264 578926	неоконченное высшее	291
Вероника	Кондратьева	\N	8 (603) 087-4377	7734 254379	высшее	292
Исай	Орехова	Гавриилович	8 (810) 009-82-29	4417 333707	высшее	293
Изяслав	Доронина	Анатольевич	88936361737	1608 106430	среднее	294
Тихон	Беляев	\N	8 396 782 75 97	7195 730405	неоконченное высшее	295
Мирослав	Маркова	Викторовна	8 (933) 781-8116	5206 438942	\N	296
Захар	Трофимов	Трифонович	8 (909) 372-30-00	2222 463316	среднее	297
Вацлав	Журавлев	Валерьевич	8 (790) 068-95-55	8577 541573	неоконченное высшее	298
Ермолай	Веселова	\N	+70143779398	2926 308025	среднее профессиональное	299
Севастьян	Игнатьев	Юльевна	+7 235 558 72 64	8280 763980	высшее	300
Лука	Кулаков	\N	8 299 401 9081	9301 807532	\N	301
Наина	Якушев	\N	85291898121	5226 781859	среднее профессиональное	302
Евсей	Меркушева	Федосеевич	8 421 127 3708	3210 710258	неоконченное высшее	303
Ульяна	Белоусова	Захаровна	8 (351) 148-95-14	5189 995464	высшее	304
Фаина	Калинина	Анисимович	+7 (457) 765-37-39	7558 155302	высшее	305
Милан	Носков	\N	87245528464	9537 354976	\N	3229
Остап	Колобов	Николаевна	+7 106 513 3387	1409 877572	неоконченное высшее	1
Вышеслав	Сазонов	\N	+7 (473) 178-10-80	3286 872246	среднее	2
Вадим	Шашкова	Рубеновна	+7 (267) 736-0260	9935 191161	\N	3
Никита	Лобанов	\N	8 (468) 723-43-09	2535 329258	высшее	4
Нина	Киселева	Ануфриевич	8 009 788 2081	1434 688508	высшее	5
Дорофей	Кудрявцев	Владиславовна	+7 361 939 90 91	9928 539898	высшее	6
Панкрат	Ширяева	Владимировна	88543534624	5557 948749	среднее	7
Ратмир	Евдокимов	Рубеновна	+7 079 911 83 84	3615 832052	\N	8
Влас	Белозерова	Иларионович	+7 354 278 49 80	3547 325772	неоконченное высшее	9
Галина	Прохорова	\N	8 (412) 411-8244	7224 201414	неоконченное высшее	10
Эрнест	Гаврилов	Никифоровна	8 348 740 1640	5333 946335	среднее	11
Авдей	Харитонов	Сергеевна	+7 (427) 868-01-12	9785 230889	\N	12
Трифон	Богданов	\N	8 982 620 4505	5803 969693	неоконченное высшее	13
Епифан	Колесникова	Денисович	+7 586 923 22 60	2139 148050	высшее	14
Денис	Чернова	Игнатьевич	8 342 160 73 37	2307 996865	высшее	15
Милий	Костин	Юльевна	+7 (303) 654-1458	7227 391476	\N	16
Нифонт	Щербакова	Антоновна	8 014 294 0196	6977 270555	неоконченное высшее	17
Мечислав	Трофимова	Тарасовна	8 698 169 3406	5374 835911	среднее	18
Август	Голубева	Филипповна	8 (356) 159-5148	3803 660086	высшее	19
Леонид	Ефимова	\N	8 564 823 66 29	7216 383060	высшее	20
Филарет	Елисеев	Трофимович	8 (044) 369-9577	1916 340174	среднее	21
Пров	Давыдова	Гордеевич	8 (721) 489-5134	7572 380746	среднее	22
Зиновий	Калашникова	\N	+7 (200) 379-1769	6155 322955	\N	23
Евлампий	Рыбакова	Матвеевна	8 763 201 63 28	8517 249811	неоконченное высшее	24
Ростислав	Комаров	\N	8 (317) 278-8957	9830 375504	\N	25
Юлий	Лапина	Ниловна	8 (687) 277-4348	7543 479580	высшее	26
Святослав	Егорова	Демидович	+77143455812	3266 634277	\N	27
Георгий	Суворов	\N	8 231 665 87 60	1771 214975	высшее	28
Елисей	Пахомова	Федосеевич	8 909 670 54 66	7916 725380	среднее	29
Тимофей	Михеева	Оскаровна	8 (937) 346-7065	8668 654816	неоконченное высшее	30
Глафира	Щербакова	Федоровна	8 272 980 69 90	1188 813328	среднее	31
Борис	Никифорова	Федотович	+7 (720) 465-37-55	9797 887352	неоконченное высшее	32
Синклитикия	Шарова	Тарасович	+76417080531	6573 216970	неоконченное высшее	33
Эмилия	Субботина	Захаровна	+7 033 092 3271	8433 103402	неоконченное высшее	34
Феоктист	Русакова	Григорьевич	8 (452) 991-24-19	3927 632342	среднее	35
Александр	Бобылева	Ефстафьевич	86631931491	5889 982554	высшее	36
Феофан	Сафонова	\N	+7 586 518 5067	3646 665579	среднее	37
Вацлав	Князев	Иосипович	8 (262) 849-87-76	9005 120422	среднее	38
Наина	Никитина	Евстигнеевич	8 314 737 9965	6038 351083	среднее	39
Алексей	Попова	\N	8 273 545 4948	2290 189814	\N	40
Автоном	Павлова	Геннадиевич	+7 367 837 77 01	9727 903035	высшее	41
Куприян	Зуев	\N	8 349 578 85 68	8787 676510	высшее	42
Максимильян	Крюков	\N	8 (444) 313-51-82	7932 322086	высшее	43
Евдоким	Горбунов	Павловна	8 (498) 941-34-35	7537 804314	неоконченное высшее	44
Денис	Елисеев	Авдеевич	8 (240) 084-2710	9479 573417	среднее	45
Филипп	Ермаков	\N	8 (775) 204-71-16	2049 454508	среднее	46
Селиверст	Куликов	Вадимовна	+7 229 413 1869	4770 717024	высшее	47
Эдуард	Елисеева	\N	83867749649	1964 340062	среднее	48
Якуб	Ковалев	Геннадиевна	+7 334 123 28 12	6413 174299	высшее	49
Авдей	Зыков	\N	8 (974) 034-47-13	8953 324643	высшее	50
Капитон	Моисеева	Тимофеевна	83618324210	8744 354801	\N	51
Григорий	Кошелева	Ефремович	89471746488	4119 198907	среднее	52
Семен	Шашков	Артурович	80659401399	6804 544154	\N	53
Адриан	Жданова	Константиновна	+79027874296	1887 806073	среднее	54
Александра	Кулагина	\N	8 (175) 655-12-56	6559 939482	среднее	55
Ираида	Попова	\N	+76807154516	4116 662336	\N	56
Софон	Муравьева	\N	+7 876 038 5977	4006 392075	\N	57
Синклитикия	Орлов	\N	+7 (482) 477-1093	2235 564656	среднее	58
Лора	Филиппов	\N	+78086131712	9856 976638	среднее	59
Сигизмунд	Белозерова	Никифоровна	+78467737826	4872 274389	\N	60
Евграф	Князева	Валериевна	8 (214) 658-4044	4502 520521	среднее	61
Фрол	Королева	\N	8 (278) 755-88-67	1035 509386	неоконченное высшее	62
Любим	Фадеева	Геннадиевич	+7 (963) 605-7662	8454 399105	\N	63
Серафим	Селиверстова	Алексеевич	+7 (895) 171-87-02	8973 262316	высшее	64
Осип	Фадеева	\N	+7 (174) 596-15-86	1958 707314	среднее	65
Лукьян	Егорова	Никифоровна	8 (809) 134-31-61	1936 152578	\N	66
Синклитикия	Калинина	Максимовна	+7 724 005 04 55	9701 265080	среднее	67
Петр	Калинин	Демьянович	8 (692) 221-9693	2312 992697	высшее	68
Сергей	Якушева	\N	82374740748	2113 808011	высшее	69
Глеб	Куликов	Феофанович	8 946 474 3671	5033 707040	среднее	70
Изот	Фадеев	Борисовна	8 944 064 0909	7868 789305	неоконченное высшее	71
Олимпиада	Соколова	Ермилович	+7 (953) 394-2104	4346 802258	неоконченное высшее	72
Потап	Виноградов	\N	85214562328	7484 237235	неоконченное высшее	73
Михей	Михайлова	Юлианович	+72474517123	2188 109767	\N	74
Евпраксия	Воронова	Константиновна	8 851 604 81 75	2638 176819	высшее	75
Евгения	Галкина	Константиновна	+79651370985	3170 465962	среднее	76
Юлиан	Зуев	Ждановна	+7 746 120 04 71	7054 398830	высшее	77
Валерий	Воронов	Антоновна	+7 (675) 869-26-17	9900 837715	неоконченное высшее	78
Яков	Авдеев	Елисеевич	+7 537 735 1585	9666 108203	неоконченное высшее	79
Аркадий	Евсеев	Елизарович	+7 (171) 390-0532	2697 240814	неоконченное высшее	80
Феофан	Тихонов	\N	+7 839 335 29 04	2753 878480	высшее	81
Галактион	Осипов	\N	8 (421) 020-5395	4450 852470	неоконченное высшее	82
Аггей	Шестаков	\N	+70268117758	5325 629959	\N	83
Христофор	Рябов	\N	8 (839) 084-70-07	1832 196781	\N	84
Олег	Красильников	Леоновна	+7 771 159 21 24	1722 103717	неоконченное высшее	85
Ярополк	Калинина	Владимировна	8 (569) 847-8961	5291 269430	\N	86
Клавдия	Данилов	Ивановна	8 (367) 365-7661	8007 688153	среднее	87
Лонгин	Красильников	\N	8 452 711 1161	3442 672092	среднее	88
Олимпиада	Овчинникова	Марсович	+7 (809) 885-16-56	3426 550664	высшее	89
Марина	Орлов	\N	+79451983273	6974 934794	среднее	90
Велимир	Филатов	Анатольевна	8 149 368 9980	4441 815198	высшее	91
Ювеналий	Бобылева	Игоревна	+70244550229	6794 918011	\N	92
Варвара	Брагин	Арсеньевич	+7 (018) 366-75-25	3532 348237	высшее	93
Леонтий	Абрамова	Зиновьевич	89102290147	3900 532322	среднее	94
Вера	Якушев	\N	8 (976) 438-15-61	6442 920391	\N	95
Кондратий	Щербакова	Кузьминична	87840369003	5065 379766	высшее	96
Ладислав	Фомичева	Гордеевич	+7 (445) 107-62-26	2771 501124	среднее	97
Твердислав	Горбунова	Давыдович	8 (851) 606-0715	4644 309267	\N	98
Фирс	Гордеев	Борисовна	8 641 605 29 75	4728 333752	среднее	99
Бронислав	Уваров	Борисович	+7 (696) 816-4535	7528 444207	неоконченное высшее	100
Элеонора	Ширяев	Артемьевич	8 (188) 355-2312	5573 468203	\N	101
Исай	Афанасьев	Всеволодович	82127799799	9785 447235	среднее	102
Любомир	Ситникова	\N	8 271 774 4905	5279 287241	неоконченное высшее	103
Сильвестр	Куликов	\N	+77700541199	8119 462479	неоконченное высшее	104
Сильвестр	Комиссаров	Фомич	88079359782	9379 221263	\N	105
Аркадий	Мясников	Бориславович	8 182 037 7889	4114 367095	среднее	106
Гордей	Артемьев	Марсович	+76659051518	1027 645175	высшее	107
Евфросиния	Мамонтов	Еремеевич	+79251925462	2146 796503	неоконченное высшее	108
Чеслав	Быкова	Архипович	+78652816850	3041 854717	неоконченное высшее	109
Митофан	Орехов	Гавриилович	+7 (573) 322-1418	7691 442027	\N	110
Ульяна	Орлова	Павловна	8 (059) 296-2229	3085 301158	\N	111
Григорий	Абрамова	Феоктистович	+7 653 794 7383	7211 810219	высшее	112
Леонид	Пестова	Харитоновна	8 (359) 774-68-86	5930 525800	среднее	113
Гостомысл	Прохорова	Германович	82407581814	4443 550770	неоконченное высшее	114
Борис	Хохлова	Владиславович	+77826137506	8244 808446	высшее	115
Аполлинарий	Вишняков	Юлианович	8 361 530 5152	3780 790855	среднее	116
Всеслав	Воробьев	\N	+77277901043	6491 197923	высшее	117
Геннадий	Ковалева	Николаевна	88614341036	4680 945742	высшее	118
Алла	Костина	\N	87117980893	1757 356736	\N	119
Майя	Дмитриев	Ермолаевич	8 095 396 21 85	2193 577538	\N	120
Артем	Тетерина	Андреевна	8 (888) 067-0654	4185 853240	\N	121
Ольга	Морозов	Ильясович	+7 531 952 05 85	4997 254739	среднее	122
Ангелина	Шестаков	Яковлевна	8 (722) 170-43-03	2746 916232	\N	123
Виссарион	Макаров	Матвеевич	8 832 667 72 62	3990 834868	\N	306
Януарий	Абрамов	Эльдаровна	+7 (649) 927-2642	9475 552522	неоконченное высшее	307
Стоян	Блохина	\N	+7 (855) 731-71-35	9198 670882	\N	308
Платон	Зуева	Аскольдовна	8 640 283 4937	4870 679972	неоконченное высшее	309
Феоктист	Кузнецов	Тимуровна	+7 660 508 75 35	5685 806618	среднее	310
Василий	Сысоева	Оскаровна	8 076 942 7848	7110 854724	высшее	311
Анжелика	Константинова	\N	8 095 634 86 18	8476 850763	\N	312
Ерофей	Зимина	Захаровна	8 545 657 8111	4189 248461	неоконченное высшее	313
Зосима	Пестов	Данилович	+7 (092) 796-9004	2449 738345	среднее	314
Лавр	Абрамова	\N	+7 953 751 5483	1788 839995	высшее	315
Антип	Зайцев	Даниилович	+7 279 686 29 20	5839 886231	\N	316
Виссарион	Уваров	Андреевна	80362162615	9258 125144	\N	317
Полина	Родионов	Филипповна	+7 394 172 8083	9047 653973	высшее	318
Мечислав	Князева	\N	+7 (469) 049-84-07	5285 419590	среднее	319
Любомир	Карпова	\N	+7 786 515 2624	2969 709159	неоконченное высшее	320
Милован	Савина	\N	8 (712) 849-4868	1787 642676	высшее	321
Виталий	Зыков	\N	8 (043) 137-75-77	8868 456779	среднее	322
Петр	Поляков	Богдановна	+7 (942) 197-9591	7428 486873	среднее профессиональное	323
Виктория	Осипова	Фокич	8 452 759 9275	9221 376440	среднее профессиональное	324
Маргарита	Маслова	Харлампович	+74032696727	5378 582669	среднее	325
Панкрат	Белоусова	\N	+7 (714) 753-2222	3268 469180	среднее профессиональное	326
Фотий	Лаврентьев	\N	8 (508) 552-65-52	2394 568020	высшее	327
Вероника	Шубин	\N	+7 752 920 39 17	8474 443255	среднее профессиональное	328
Милица	Медведев	\N	+7 (319) 610-87-02	2268 234171	среднее профессиональное	329
Парамон	Горбачева	Анатольевич	+7 (288) 273-9757	4037 201756	среднее	330
Галактион	Князева	Бориславович	+7 609 943 96 56	7770 706309	среднее	331
Спартак	Носкова	Зиновьевич	+7 526 326 20 35	7261 327328	высшее	332
Тимур	Котов	\N	+7 (807) 119-5067	5154 284646	среднее	333
Марина	Козлов	Ильясович	8 846 620 47 54	2184 643213	высшее	334
Иларион	Карпова	Афанасьевна	8 (889) 320-0613	4764 792089	\N	335
Юрий	Рожков	Фролович	8 (108) 900-8581	8450 576015	среднее профессиональное	336
Творимир	Васильев	Болеславовна	8 (171) 046-5185	6001 161624	неоконченное высшее	337
Харитон	Потапова	Феликсович	8 415 188 8974	7953 987758	среднее профессиональное	338
Ксения	Сорокина	Эльдаровна	8 304 744 7658	2929 622673	высшее	339
Тимур	Красильникова	Юльевна	8 (460) 067-99-57	1367 256609	\N	340
Амос	Лаврентьева	\N	+72427524540	8291 510324	среднее	341
Филимон	Фомичев	Глебович	+7 (274) 323-9192	3457 858439	высшее	342
Елена	Веселова	\N	8 436 681 7932	3812 330857	высшее	343
Александр	Королев	\N	+7 (921) 563-06-10	2698 850349	среднее	344
Данила	Евдокимов	\N	+7 188 423 5534	1318 787575	неоконченное высшее	345
Клавдий	Маркова	\N	+70161486063	3645 615733	среднее профессиональное	346
Игнатий	Лапин	\N	+7 384 522 31 28	5490 215787	среднее	347
Иван	Кулакова	Игнатьевич	8 872 321 1190	3586 959286	\N	348
Макар	Калашникова	\N	+7 (095) 256-0115	4475 243686	среднее профессиональное	349
Ангелина	Ларионова	Афанасьевна	+7 (220) 740-4571	6489 224347	высшее	350
Галина	Архипов	\N	8 (376) 214-48-76	1971 499757	\N	351
Таисия	Носков	Феликсович	+7 (938) 079-1740	7919 396122	среднее профессиональное	352
Стоян	Баранова	Эдуардовна	8 (545) 127-10-89	6537 508848	среднее	353
Никодим	Максимова	\N	84047080440	4326 645014	неоконченное высшее	354
Радован	Князев	Аскольдовна	+7 106 232 36 75	7020 476883	неоконченное высшее	355
Иванна	Беляков	\N	8 (498) 624-5739	1345 223176	высшее	356
Лонгин	Жукова	\N	+7 (610) 198-5371	3782 288682	высшее	357
Болеслав	Громова	\N	+7 (706) 091-67-68	3646 525910	\N	358
Олимпиада	Одинцова	Борисовна	84442352709	4954 258321	среднее	359
Архип	Пестова	Антипович	8 866 849 50 35	2961 432730	высшее	360
Лазарь	Нестеров	\N	+7 942 931 2906	1405 207430	\N	361
Кузьма	Лапина	Терентьевич	8 (495) 651-42-40	2609 314617	среднее	362
Болеслав	Дьячков	Ермолаевич	+73552781843	9532 789439	среднее	363
Мечислав	Рожкова	Алексеевна	80137655049	9238 945536	среднее	364
Твердислав	Гаврилова	\N	+7 (358) 662-4335	4799 456973	неоконченное высшее	365
Творимир	Шубина	\N	81565783158	5547 725485	среднее профессиональное	366
Марфа	Исаев	\N	8 368 879 12 54	8982 939482	\N	367
Агафон	Голубев	\N	+7 (338) 582-28-86	6399 812686	\N	2348
Руслан	Егорова	Ефимовна	+7 113 146 10 57	4467 679164	среднее профессиональное	368
Тимофей	Шестакова	Александровна	+7 918 190 75 88	2325 312525	среднее профессиональное	369
Сократ	Максимов	\N	+7 751 205 4988	1118 840767	неоконченное высшее	370
Андрей	Кулагина	Борисовна	+7 324 100 17 84	1729 974250	среднее	371
Платон	Ларионова	\N	8 244 228 10 98	9357 545941	среднее профессиональное	372
Акулина	Никитина	Вениаминовна	+7 372 934 55 75	5917 236343	среднее профессиональное	373
Мариан	Филатова	\N	+7 175 461 86 08	8788 918208	неоконченное высшее	374
София	Лебедева	Яковлевич	+75550926075	8767 816148	неоконченное высшее	375
Артемий	Тарасова	Леоновна	80397069802	1210 917424	высшее	376
Зиновий	Петухова	Валентиновна	8 (888) 158-5489	1776 667724	\N	377
Трифон	Гурьев	\N	+7 208 557 27 99	5387 338555	высшее	378
Алина	Дементьева	\N	+7 (077) 691-67-93	9149 258492	высшее	379
Марк	Елисеева	\N	+77299523599	9488 171424	среднее профессиональное	380
Аким	Капустин	\N	+7 (949) 065-20-36	8302 820213	высшее	381
Панкратий	Тимофеева	\N	+7 890 578 5717	6543 650625	среднее профессиональное	382
Осип	Котов	\N	8 275 645 53 85	5565 853115	среднее профессиональное	383
Аристарх	Владимирова	\N	+7 (908) 398-1845	6427 317028	среднее	384
Радован	Носов	Максимовна	8 894 925 6266	3208 793111	среднее профессиональное	385
Демьян	Григорьева	Тимурович	8 (290) 476-14-62	2138 369678	среднее профессиональное	386
Фадей	Якушев	\N	8 (130) 181-88-75	7241 492842	высшее	387
Надежда	Князев	\N	89075463915	3598 885588	\N	388
Фортунат	Зиновьева	\N	8 (589) 626-40-65	2919 835305	неоконченное высшее	389
Гаврила	Рогов	\N	+76771940298	1805 647151	неоконченное высшее	390
Зинаида	Киселев	Иларионович	8 (638) 203-24-39	4987 471970	среднее	391
Пахом	Смирнова	Матвеевич	8 (125) 142-9876	5684 568785	неоконченное высшее	392
Изот	Князев	\N	+7 324 439 46 38	5956 998736	\N	393
Валентина	Ермаков	Альбертовна	+7 494 429 3529	9248 530580	высшее	394
Борислав	Тимофеев	Глебович	+7 (581) 518-6243	6399 911277	неоконченное высшее	395
Трифон	Шашкова	Максимовна	8 (840) 281-2982	1680 594571	среднее	396
Степан	Комарова	\N	8 (545) 562-7191	1230 639843	\N	397
Прокофий	Русакова	\N	8 (169) 074-49-68	8774 338119	неоконченное высшее	398
Остап	Никифоров	Денисович	+7 (238) 849-3289	9843 514135	\N	399
Семен	Князева	Святославовна	+7 (744) 902-5871	1653 574329	неоконченное высшее	400
Платон	Евдокимов	\N	83467250515	8772 562954	среднее профессиональное	401
Станислав	Игнатова	Архиповна	+73253898050	4431 316381	среднее профессиональное	402
Лукия	Гущина	Рубеновна	+7 262 645 24 99	3995 598555	среднее профессиональное	403
Дмитрий	Анисимов	\N	8 (674) 704-3658	8094 571104	\N	404
Савватий	Голубев	Зиновьевич	+7 979 326 0503	2641 524533	среднее профессиональное	405
Родион	Дмитриева	\N	+7 (206) 624-92-69	6068 760036	высшее	406
Станислав	Гурьева	\N	8 380 420 19 34	2753 784827	неоконченное высшее	407
Осип	Лаврентьев	\N	+7 (640) 019-4892	7698 803254	среднее	408
Панфил	Егорова	Зиновьевич	+7 (302) 960-0453	8978 493067	неоконченное высшее	409
Аникей	Журавлев	\N	8 225 388 9793	5611 115522	\N	410
Гаврила	Шашкова	Измаилович	87504748119	1393 621714	среднее	411
Раиса	Давыдов	\N	+7 098 096 87 57	2131 137511	неоконченное высшее	412
Пахом	Полякова	Жанович	+7 529 731 8878	3008 885688	неоконченное высшее	413
Тарас	Макаров	\N	81016984937	4128 881600	среднее	414
Евдокия	Большаков	Архиповна	+7 (802) 216-4625	8332 118932	высшее	415
Анна	Воробьева	Юльевна	8 (563) 542-3635	3997 225704	неоконченное высшее	416
Виктория	Федосеев	Валентиновна	8 (940) 797-4161	2976 424509	высшее	417
Максимильян	Блохина	\N	+7 281 523 6587	2102 452625	среднее профессиональное	418
Светозар	Белоусов	Макаровна	+7 561 789 59 05	9032 439025	\N	419
Добромысл	Журавлев	Трофимович	+7 (087) 370-5653	9200 104977	среднее профессиональное	420
Прокл	Кудряшов	Зиновьевич	8 (680) 396-0264	5284 439260	неоконченное высшее	421
Самсон	Сергеева	Фролович	+7 (561) 703-1853	4755 701152	\N	422
Остап	Калинин	\N	+76889197643	5515 185480	неоконченное высшее	423
Демид	Николаева	\N	+73437739055	5093 322224	среднее	424
Егор	Селиверстова	\N	8 197 967 1098	9817 198307	среднее	425
Лукьян	Костина	Степановна	+7 (265) 470-44-74	4188 433920	среднее	426
Эрнест	Мамонтов	\N	8 109 381 5219	9309 661994	\N	427
Валерий	Егорова	\N	87882526349	1569 510360	высшее	428
Ладислав	Симонова	Игоревич	+7 812 599 49 67	2879 610326	\N	429
Прокофий	Сергеева	\N	8 012 685 8517	8393 340176	\N	430
Аникей	Данилов	Эдуардович	+7 (209) 583-05-74	8438 620477	высшее	431
Милен	Горшкова	Измаилович	8 (907) 662-23-05	2508 461990	среднее профессиональное	432
Харитон	Зуев	\N	8 508 156 43 72	8013 777847	среднее профессиональное	433
Игнатий	Шилов	Афанасьевич	+7 (681) 539-3372	8952 999114	среднее профессиональное	434
Александра	Панов	\N	8 (902) 879-0431	3765 917832	среднее профессиональное	435
Епифан	Игнатьев	\N	+7 857 926 33 74	8744 783975	неоконченное высшее	436
Аркадий	Соколова	Антоновна	+76710465134	9728 988732	\N	437
Тимур	Зыков	Денисович	+7 (029) 977-9855	5662 255869	среднее	438
Александра	Симонов	Руслановна	8 (231) 066-95-82	7627 542346	\N	439
Анастасия	Жданов	Ефремович	+70671039127	9663 234222	высшее	440
Марк	Орлова	\N	88707630591	4955 650370	высшее	441
Потап	Ширяев	Архипович	8 (185) 052-7941	5326 719135	неоконченное высшее	442
Филимон	Поляков	\N	8 (912) 093-8871	4018 703675	среднее профессиональное	443
Автоном	Волкова	Арсеньевич	8 (229) 918-3036	4505 580765	высшее	444
Олег	Стрелкова	\N	+7 (950) 360-2081	1689 485613	\N	445
Варлаам	Абрамов	\N	8 (810) 882-2616	6062 755515	\N	446
Агафья	Симонов	Аксёнович	+7 (876) 528-88-16	8045 676714	среднее профессиональное	447
Ферапонт	Алексеева	\N	8 439 647 59 00	5878 499328	высшее	448
Елисей	Исакова	Демидович	8 995 194 3821	6915 929127	среднее профессиональное	449
Будимир	Кудряшова	Ануфриевич	8 (243) 186-9019	7783 598436	высшее	450
Сократ	Гришина	Бенедиктович	8 017 064 16 71	7158 892361	высшее	451
Аггей	Архипова	Афанасьевна	8 (170) 872-98-10	4965 530954	высшее	452
Илья	Некрасов	\N	8 515 922 4575	9715 964969	среднее профессиональное	453
Маргарита	Шашков	Григорьевич	+7 (972) 196-5994	1815 576613	среднее профессиональное	454
Степан	Горбунов	\N	8 702 598 60 13	5315 784774	высшее	455
Болеслав	Назаров	\N	8 (599) 428-60-01	5464 387267	высшее	456
Никита	Киселев	Игнатович	8 262 596 43 29	2907 463800	неоконченное высшее	457
Трофим	Блинов	Александровна	+7 (088) 050-43-60	7254 251566	среднее профессиональное	458
Прасковья	Костина	Авдеевич	8 074 332 68 98	8307 289321	\N	459
Капитон	Дементьева	\N	8 (096) 523-3136	3202 816485	среднее	460
Всеслав	Мухин	Анисимович	8 (016) 815-98-58	2746 255900	\N	461
Дмитрий	Гаврилов	Яковлевна	+7 740 445 9225	8910 153097	\N	462
Елизар	Медведева	\N	+77331725789	4549 917128	высшее	463
Капитон	Блинова	Станиславовна	8 (982) 275-9083	1264 740210	среднее	464
Пахом	Буров	Георгиевна	+7 972 347 09 32	8590 665366	среднее	465
Кондрат	Исакова	Васильевич	8 (052) 564-1852	3669 688760	высшее	466
Дементий	Трофимов	Владиленович	+77547348029	8226 344481	высшее	467
Наркис	Чернов	Архиповна	8 904 274 8672	3492 171752	неоконченное высшее	468
Милица	Хохлов	\N	8 (450) 496-19-22	5944 522160	высшее	469
Иван	Копылова	\N	+7 (065) 536-71-70	8895 114012	неоконченное высшее	470
Григорий	Исакова	Ерофеевич	8 (112) 746-1592	8313 528477	неоконченное высшее	471
Чеслав	Антонова	\N	+78685831828	6075 679519	неоконченное высшее	472
Аверкий	Васильева	Макаровна	+77671478510	6300 892249	высшее	473
Анна	Лазарева	\N	8 (159) 800-7790	4816 628369	среднее профессиональное	474
Станимир	Попова	Якубович	8 269 159 1143	8198 506427	\N	475
Екатерина	Котова	Архиповна	8 381 826 83 09	1034 584679	среднее профессиональное	476
Галина	Мухина	Григорьевич	81223685569	3593 386616	среднее профессиональное	477
Сила	Лебедева	Антипович	8 (850) 992-58-19	2889 800774	среднее профессиональное	478
Викентий	Ковалев	\N	8 (507) 853-0875	8699 157426	среднее	479
Епифан	Наумов	\N	8 204 226 2003	5544 641771	среднее	480
Эмиль	Мельников	Натановна	85216814628	3911 153270	неоконченное высшее	481
Милован	Елисеев	\N	8 416 262 7413	4415 540443	среднее профессиональное	482
Светлана	Игнатьева	Алексеевна	8 485 862 52 42	2768 790131	среднее профессиональное	483
Вера	Кириллова	Ермолаевич	85660441907	7066 789588	\N	484
Мирослав	Антонов	Исидорович	8 805 752 5822	6105 384938	среднее	485
Тихон	Зуева	Феликсовна	+7 (934) 115-2501	6858 185212	\N	486
Осип	Веселова	Святославовна	8 596 537 8595	4428 310756	\N	487
Радим	Коновалов	Николаевна	8 (335) 551-54-48	8418 829086	высшее	488
Ия	Григорьева	Тарасович	8 (053) 142-95-16	6036 596322	\N	489
Зинаида	Емельянова	Анатольевна	8 618 729 55 97	4119 858012	высшее	490
Светлана	Титов	Иосифович	+7 (026) 367-7659	3268 974123	среднее профессиональное	491
Эрнст	Федорова	Антонович	8 995 614 45 64	3904 414853	высшее	492
Андрон	Павлов	\N	+7 834 750 37 64	6752 191266	среднее	493
Никита	Голубев	Димитриевич	+7 526 002 63 18	3326 906423	высшее	494
Мариан	Воронцова	Аскольдовна	+7 932 419 6934	4028 905598	\N	495
Иван	Мишин	\N	+7 (675) 298-89-59	9088 509736	высшее	496
Мария	Михеева	Оскаровна	8 (164) 647-1592	5008 961797	среднее	497
Лукьян	Дроздова	\N	8 (105) 949-89-58	8565 972841	среднее	498
Добромысл	Григорьева	Владленович	8 (245) 626-8862	8560 801618	среднее	499
Епифан	Третьякова	\N	8 340 174 0965	5993 242130	среднее	500
Жанна	Меркушева	Ниловна	8 (111) 572-6691	1129 604739	высшее	501
Болеслав	Гусев	Ефимович	8 (327) 216-56-77	7364 210256	среднее	502
Дарья	Горбунова	Владимировна	+7 167 167 3853	1990 452310	высшее	503
Регина	Турова	Яковлевна	8 465 677 18 39	9238 791219	среднее	504
Андрей	Крылов	\N	+7 934 701 1094	2370 190075	высшее	505
Онуфрий	Князева	\N	+7 198 700 3511	3563 929496	среднее профессиональное	506
Ярополк	Орлова	\N	+7 (106) 129-7251	8383 435627	неоконченное высшее	507
Семен	Ефимова	\N	+7 (976) 535-7582	9733 107828	\N	508
Изот	Носков	Гертрудович	+7 725 811 20 57	2582 693101	неоконченное высшее	509
Акулина	Тихонова	Антипович	8 273 018 16 53	1963 291620	\N	510
Надежда	Кулагин	\N	80549049360	2476 137056	неоконченное высшее	511
Венедикт	Федорова	\N	8 806 322 6103	1312 762168	среднее профессиональное	512
Ангелина	Цветкова	\N	+7 (938) 087-14-94	4840 335416	неоконченное высшее	513
Аверкий	Авдеева	Рубеновна	+74213928982	4495 313746	неоконченное высшее	514
Фадей	Андреев	Филимонович	+7 356 643 0264	5716 657367	среднее профессиональное	515
Авдей	Большаков	Аксёнович	+7 (838) 270-9227	9808 226760	среднее профессиональное	516
Моисей	Ковалев	Жоресович	8 469 646 4120	4789 538257	среднее профессиональное	517
Мина	Захарова	Георгиевна	+7 522 383 40 11	3886 144483	\N	518
Чеслав	Веселова	Яковлевич	8 779 967 19 31	3389 320492	среднее профессиональное	519
Ираклий	Кононов	Власович	+79235765184	5706 588160	высшее	520
Зиновий	Лебедева	Владленович	+7 761 873 1653	8209 969326	неоконченное высшее	521
Регина	Русакова	\N	+79956040840	1171 257720	среднее	522
Аверьян	Блохина	Борисовна	+7 (726) 314-16-91	4827 604171	неоконченное высшее	523
Наркис	Юдин	Артемовна	8 (813) 684-40-34	8904 854783	среднее	524
Светлана	Лобанова	\N	+7 (736) 877-52-64	8575 398371	\N	525
Владилен	Дроздова	\N	+7 (493) 106-95-80	3934 449147	неоконченное высшее	526
Влас	Рожкова	\N	+74765503892	3274 375668	высшее	527
Ульяна	Лобанов	\N	8 375 501 78 41	8902 308151	среднее профессиональное	528
Каллистрат	Кузнецова	Эдуардовна	+70742773019	3853 763401	высшее	529
Платон	Громова	Еремеевич	+7 635 267 04 15	4283 602604	неоконченное высшее	530
Фока	Герасимова	\N	+7 120 392 3878	7985 197377	\N	531
Афанасий	Шубина	\N	+7 (580) 370-9002	1586 106629	среднее	532
Антип	Суханова	Ермилович	8 (270) 487-8254	9504 592712	неоконченное высшее	533
Мечислав	Борисова	Федотович	8 605 900 1640	1115 134860	среднее профессиональное	534
Савелий	Петухов	Сергеевна	88268269937	2883 606294	среднее профессиональное	535
Прокл	Хохлова	Авдеевич	8 709 323 38 82	9727 230427	неоконченное высшее	536
Алексей	Дьячкова	\N	8 (517) 752-31-64	5853 734649	\N	537
Ираклий	Корнилова	Германович	+7 (843) 619-46-98	8100 880538	высшее	538
Аггей	Соловьев	\N	8 (633) 101-60-06	1099 485942	среднее	539
Сила	Титов	\N	8 (555) 921-0457	4388 364533	\N	540
Мефодий	Дорофеев	\N	8 905 139 0958	5229 906778	среднее профессиональное	541
Порфирий	Третьякова	\N	+7 (163) 156-1738	1513 984853	среднее профессиональное	542
Анна	Быков	Тимофеевна	80124470768	1144 475352	\N	543
Савелий	Виноградова	Эдгарович	+7 (371) 559-0380	2875 404012	неоконченное высшее	544
Евстафий	Ситникова	\N	8 149 519 73 15	1488 509148	среднее	545
Бажен	Уваров	Вадимовна	+75108957470	2616 517150	\N	546
Ладислав	Сергеева	\N	+7 (081) 335-0733	5409 299835	\N	547
Виссарион	Носков	Евсеевич	81475111046	1218 490954	высшее	548
Соломон	Симонов	\N	+7 (722) 255-1291	3739 748854	\N	549
Лев	Тарасов	Демидович	+74837820463	6698 792489	неоконченное высшее	550
Ираида	Белозеров	\N	8 118 667 4072	8953 987759	неоконченное высшее	551
Ипат	Боброва	\N	+7 778 334 8252	8072 308388	высшее	552
Кира	Яковлева	\N	8 102 476 0627	9448 787813	высшее	553
Бажен	Сидоров	\N	8 (315) 552-15-09	3102 262091	среднее профессиональное	554
Борислав	Лыткин	\N	8 726 026 6324	9094 924849	среднее	555
Клавдий	Богданова	Юлианович	+70670929102	3626 757232	неоконченное высшее	556
Будимир	Лукина	\N	8 117 565 4722	1675 381146	среднее профессиональное	557
Эмилия	Щукин	\N	8 462 514 12 32	6019 456264	среднее	558
Фома	Виноградова	Ермолаевич	80051208555	2004 668298	высшее	559
Виссарион	Голубева	\N	+7 (911) 455-14-01	2205 836666	\N	560
Милен	Одинцова	\N	+7 (425) 661-3254	4561 728553	среднее профессиональное	561
Ерофей	Попова	\N	89456581304	9159 519343	среднее	562
Фотий	Якушева	Дорофеевич	+7 (521) 588-8691	5798 468887	высшее	563
Семен	Шарапова	\N	84899234113	1288 353456	высшее	564
Мечислав	Ершова	Леоновна	8 (766) 204-57-41	1684 698239	среднее профессиональное	565
Аполлинарий	Борисова	\N	8 (618) 411-5673	2228 328717	неоконченное высшее	566
Пелагея	Абрамова	\N	8 (872) 385-2480	5006 470166	неоконченное высшее	567
Гедеон	Козлов	Артёмович	8 (113) 816-2018	6826 966771	\N	568
Селиверст	Костина	Васильевич	8 289 513 6881	9474 532703	среднее	569
Станимир	Савельев	Романовна	+7 958 961 43 40	3200 703933	высшее	570
Софрон	Котов	Егорович	+7 (987) 566-7917	5370 445954	неоконченное высшее	571
Геннадий	Соколова	Ярославович	+7 (131) 377-01-14	2144 321360	\N	572
Алевтина	Мухина	Глебович	+7 327 837 5147	5299 883796	неоконченное высшее	573
Мария	Архипов	Измаилович	8 (531) 295-24-10	4557 150742	неоконченное высшее	574
Платон	Ефремова	Ниловна	+7 756 734 37 17	4889 305331	\N	575
Никон	Соболева	Архипович	+77541845461	3969 244165	высшее	576
Ананий	Галкин	Руслановна	+7 753 730 1026	5164 962989	среднее профессиональное	577
Аггей	Лобанов	\N	8 685 240 6603	4695 365293	\N	578
Афиноген	Бобров	\N	+7 869 964 62 98	5592 996799	высшее	579
Олег	Виноградова	Юрьевна	8 545 116 3947	5974 738914	высшее	580
Тамара	Носков	Эдгарович	+7 696 381 73 07	6232 240583	среднее	581
Полина	Савина	\N	+7 (616) 557-6905	8713 493034	высшее	582
Фока	Беляева	\N	8 (946) 565-34-77	6585 712587	среднее	583
Людмила	Доронина	\N	+71607191781	2220 602470	среднее профессиональное	584
Лазарь	Никифоров	Исидорович	8 854 217 25 75	1583 419240	высшее	585
Фадей	Корнилов	\N	+7 600 877 0919	6978 272508	среднее профессиональное	586
Геннадий	Лобанов	Тихонович	87403009864	7045 928351	среднее	587
Епифан	Козлов	Трифонович	87371038062	9323 924268	среднее профессиональное	588
Илья	Жданов	Арсенович	8 (232) 711-69-95	3384 205144	среднее профессиональное	589
Иван	Тимофеева	\N	82157396340	9647 853593	среднее	590
Зинаида	Баранов	\N	+71685441190	6214 699949	высшее	591
Климент	Самсонова	\N	81146179313	4769 372510	среднее	592
Самсон	Исаева	Борисовна	+7 622 821 41 96	9261 657976	неоконченное высшее	593
Евгения	Дмитриева	\N	+78280039217	1067 207467	неоконченное высшее	594
Исай	Кулакова	\N	+7 976 736 6307	8443 848975	среднее	595
Игорь	Суханова	\N	+7 338 956 7924	5544 281100	среднее	596
Исидор	Баранов	\N	8 624 277 4455	9326 104531	среднее профессиональное	597
Иван	Фролова	Геннадиевна	+7 511 166 2902	7862 774589	среднее	598
Вениамин	Савельев	Архипович	8 (028) 821-8900	1573 420740	среднее	599
Селиверст	Николаев	\N	+7 935 113 52 69	9144 310968	\N	600
Федосий	Мухина	Фролович	+7 032 573 18 16	3646 103669	среднее профессиональное	601
Лавр	Блинова	\N	8 354 912 5614	1900 283546	среднее	602
Никодим	Никитина	Бориславович	8 959 483 4297	8516 889290	\N	603
Фрол	Лихачева	Тимуровна	+7 (609) 930-27-46	5141 117904	высшее	604
Кузьма	Гордеев	Яковлевна	8 (530) 318-87-09	7726 358596	неоконченное высшее	605
Спиридон	Степанова	\N	8 (216) 754-30-77	3728 668462	высшее	606
Богдан	Лебедев	\N	8 117 021 36 39	4832 782395	среднее профессиональное	607
Ипат	Игнатова	Брониславович	8 (596) 733-0895	6979 879812	среднее	608
Сила	Молчанов	\N	8 (545) 211-21-88	8789 153470	высшее	609
Никифор	Матвеев	Владленович	+7 665 368 58 23	2645 873063	\N	610
Митофан	Королева	\N	8 (658) 629-94-08	1517 228898	неоконченное высшее	611
Автоном	Петухов	\N	85444168428	2796 348060	среднее профессиональное	612
Вадим	Тетерин	\N	8 763 652 18 94	8677 499078	высшее	613
Светлана	Гаврилов	Романовна	+7 (276) 017-74-84	7825 256818	\N	614
Изот	Кудряшов	\N	+72928419975	3267 573967	среднее профессиональное	615
Клавдий	Корнилова	\N	8 (165) 631-4666	7324 585904	неоконченное высшее	616
Богдан	Рожков	\N	+75649317031	8496 658440	среднее профессиональное	617
Мина	Чернова	Ермолаевич	8 (580) 750-4584	5539 297635	неоконченное высшее	618
Назар	Тарасов	\N	8 872 482 1510	2438 540525	\N	619
Моисей	Сидоров	\N	+70492684999	6068 680616	среднее профессиональное	620
Всеволод	Панов	\N	+7 762 401 23 56	3328 404241	неоконченное высшее	621
Евстафий	Одинцов	Федоровна	83041302801	5606 114462	среднее	622
Демьян	Цветков	\N	+7 (097) 128-67-79	7537 622786	\N	623
Алексей	Михеев	Ефремович	+77817068658	7503 224654	среднее профессиональное	624
Сергей	Сорокин	\N	8 (500) 156-2697	2025 188161	среднее	625
Евсей	Калинин	\N	+7 (275) 673-9294	6754 525579	неоконченное высшее	626
Елизавета	Комарова	\N	8 479 964 67 39	7538 612170	\N	627
Лукьян	Никонов	Вениаминовна	+7 (994) 832-84-02	1039 505968	\N	628
Эрнест	Трофимов	\N	8 (697) 905-43-93	5932 583248	среднее профессиональное	629
Светозар	Исаев	Архипович	+7 812 825 33 37	9137 730131	высшее	630
Мефодий	Прохоров	Геннадиевич	8 062 077 0624	3477 436646	неоконченное высшее	631
Викторин	Куликов	\N	+71163694238	1364 762749	среднее	632
Милован	Евдокимов	Ефремович	8 046 327 4510	8831 449088	среднее	633
Евгений	Николаева	\N	+7 160 556 9817	1308 319472	среднее	634
Лучезар	Терентьева	\N	8 (280) 351-30-42	4624 409046	неоконченное высшее	635
Орест	Зайцев	Гурьевич	8 167 628 36 99	3485 484065	неоконченное высшее	636
Пимен	Носова	Макаровна	8 (776) 227-36-18	3498 780453	\N	637
Евсей	Громов	\N	8 (341) 363-6213	5296 344487	среднее профессиональное	638
Эдуард	Копылова	\N	82450958675	4488 535246	среднее профессиональное	639
Глафира	Соболев	Ильясович	89673096227	5258 539372	неоконченное высшее	640
Иван	Белоусова	Мироновна	8 (402) 527-21-06	5867 353004	среднее профессиональное	641
Юлия	Титова	\N	8 116 741 32 00	4155 388512	\N	642
Викентий	Нестеров	Богданович	84388353436	1942 431776	среднее профессиональное	643
Остромир	Овчинников	Валерьевич	81361228852	6851 743644	\N	644
Максим	Наумов	Леоновна	+72274679221	2874 183060	неоконченное высшее	645
Аггей	Кабанова	\N	+7 399 770 09 67	8105 864569	высшее	646
Самуил	Лихачев	Геннадьевна	+7 430 019 5465	7512 397344	среднее	647
Фотий	Власова	Фёдорович	+7 089 279 18 25	6363 738914	неоконченное высшее	648
Людмила	Сидорова	Алексеевна	8 263 300 2285	5888 479484	среднее профессиональное	649
Капитон	Осипова	\N	+7 971 828 9685	2023 141386	среднее	650
Любим	Исаев	\N	+7 175 415 9307	8025 855667	высшее	651
Емельян	Котов	\N	+76346353849	7891 153241	высшее	652
Капитон	Давыдова	Кузьминична	+7 177 729 4988	4761 549345	среднее	653
Стоян	Соколов	Игнатьевич	80050144827	5586 863846	\N	654
Филипп	Захарова	Анатольевич	8 434 017 8376	1257 399766	среднее профессиональное	655
Лукьян	Морозова	\N	+7 (278) 317-0304	3336 141822	среднее профессиональное	656
Таисия	Власова	Федоровна	+7 124 455 2692	9021 516947	\N	657
Варлаам	Иванов	Теймуразович	+7 (983) 304-36-59	5592 712169	среднее профессиональное	658
Владилен	Мартынов	\N	+73980694221	1334 731611	\N	659
Гурий	Крылов	\N	+7 (063) 986-8201	4897 877011	среднее	660
Михей	Воробьева	\N	8 (020) 262-3911	5772 273185	\N	661
Парфен	Кудряшова	\N	+7 205 434 0488	4894 405992	среднее	662
Мокей	Кулагин	\N	+7 (624) 890-16-07	3107 179764	\N	663
Изяслав	Тихонова	Ермолаевич	82840424736	8104 351750	среднее профессиональное	664
Серафим	Гаврилова	Васильевна	+70182260101	5812 750248	высшее	665
Тамара	Мухин	\N	8 (752) 187-1335	8773 461952	среднее профессиональное	666
Авдей	Капустина	Юльевич	+7 (292) 854-7129	4688 481238	неоконченное высшее	667
Радим	Морозов	Адамович	8 036 842 0160	1934 172028	высшее	668
Никита	Рогова	\N	+7 (287) 537-2038	1660 207258	среднее профессиональное	669
Тимур	Волкова	\N	+74027126480	8952 195750	неоконченное высшее	670
Дмитрий	Фадеев	Аскольдовна	8 (636) 236-10-59	8931 750229	среднее профессиональное	671
Лариса	Потапова	Вадимовна	8 670 457 1449	1302 729275	неоконченное высшее	672
Лука	Савин	Демьянович	+7 825 808 6848	5092 716498	неоконченное высшее	673
София	Некрасова	Анатольевна	8 (442) 833-6512	8138 113452	\N	674
Терентий	Трофимова	\N	85891260512	7231 603886	\N	3475
Всеволод	Коновалов	Венедиктович	+7 287 453 67 95	1859 512350	неоконченное высшее	675
Елизавета	Веселов	Семеновна	+7 693 479 50 32	6343 376559	среднее профессиональное	676
Леонтий	Громов	\N	+7 (047) 751-4199	5290 750558	среднее	677
Ким	Киселев	Демидович	+78114607721	5464 895952	неоконченное высшее	678
Регина	Ершова	Владимировна	8 074 737 9889	3701 605098	среднее	679
Вадим	Беляев	Артемьевич	+7 638 434 57 98	5750 436547	среднее профессиональное	680
Артемий	Буров	Теймуразович	+72471087357	3088 525553	среднее	681
Твердислав	Тетерина	\N	+7 029 560 74 97	5633 454300	среднее	682
Петр	Ефремова	\N	8 298 079 35 85	1558 837214	неоконченное высшее	683
Аполлон	Капустина	\N	8 (142) 873-7756	1608 336826	среднее	684
Варлаам	Шарапова	Эдуардовна	+7 (047) 293-5720	6103 295773	\N	685
Никон	Юдин	Михайловна	8 682 133 11 18	6654 443489	среднее	686
Мир	Гуляев	Эльдаровна	+75985033241	4214 187050	неоконченное высшее	687
Спартак	Лебедев	\N	81744482346	5823 137078	среднее	688
Август	Шилова	\N	+7 (933) 805-9667	9267 508192	неоконченное высшее	689
Гаврила	Орлова	Эдуардовна	+78361794738	1344 569361	неоконченное высшее	690
Лукьян	Орехов	\N	+7 (683) 141-5946	5721 811756	высшее	691
Роман	Петров	Семеновна	+73444882067	6042 916481	среднее профессиональное	692
Ипат	Карпов	\N	+74225663505	5370 335846	среднее	693
Виссарион	Одинцов	\N	+7 129 816 4345	6347 737152	среднее профессиональное	694
Аггей	Ковалева	\N	8 (185) 014-1049	8378 493130	\N	695
Август	Боброва	Архиповна	8 767 180 8435	6827 509421	неоконченное высшее	696
Элеонора	Крюкова	\N	+78418789024	3521 955657	неоконченное высшее	697
Зинаида	Дорофеев	Ефимович	8 983 032 8947	1077 564275	среднее профессиональное	698
Добромысл	Тимофеева	Ильясович	8 910 287 5876	2637 569605	среднее	699
Твердислав	Дроздова	\N	8 (226) 792-3353	7292 424625	среднее	700
Савватий	Федоров	\N	8 409 271 95 46	7007 179128	среднее профессиональное	701
Михаил	Зимин	\N	85270710773	7720 919514	среднее профессиональное	702
Вадим	Муравьева	Владиленович	+7 478 817 5329	2048 404989	среднее	703
Селиван	Матвеев	Иосифович	+77727258102	5080 483185	\N	704
Алина	Журавлева	Тарасовна	+7 (502) 058-6748	4494 883879	неоконченное высшее	705
Митофан	Кудряшова	\N	+7 (131) 127-8711	4920 577497	неоконченное высшее	706
Эрнст	Исакова	\N	+7 (058) 831-31-47	8019 163546	высшее	707
Олимпий	Шарапов	Леонидовна	8 (361) 267-02-06	7917 705372	среднее профессиональное	708
Онуфрий	Соколов	Эдгардович	8 372 336 44 30	3345 292212	\N	709
Леонтий	Кононова	\N	+7 405 945 06 88	2466 759712	неоконченное высшее	710
Зосима	Беспалова	Эдгардович	+7 222 113 3423	8391 705624	\N	711
Григорий	Павлова	\N	8 (648) 392-90-04	6879 415284	высшее	712
Тимур	Колобова	\N	8 836 675 6461	2883 507177	высшее	713
Зосима	Ситникова	\N	+7 (079) 586-6370	8318 302350	высшее	714
Викентий	Устинов	Васильевич	+72831839372	5226 311225	среднее	715
Ферапонт	Князев	Матвеевич	8 422 526 61 27	9361 823372	среднее	716
Устин	Уваров	\N	+7 757 272 17 27	2186 860596	среднее	717
Радислав	Федотов	\N	+7 977 589 6703	4799 496368	среднее	718
Прокл	Фомина	Фролович	8 (772) 044-3522	3103 797731	неоконченное высшее	719
Адам	Киселев	\N	8 979 310 2798	3788 336094	высшее	720
Аркадий	Тарасов	Фёдорович	8 (056) 935-79-40	2589 142782	неоконченное высшее	721
Нонна	Брагина	Игоревич	8 (020) 005-08-07	1513 509477	среднее профессиональное	722
Лев	Терентьева	\N	8 (555) 459-89-60	4139 124185	\N	723
Тит	Васильев	\N	+7 433 082 59 17	4419 633300	\N	724
Лев	Владимирова	\N	8 (117) 613-70-82	6247 321668	среднее профессиональное	725
Анжела	Новиков	\N	+7 570 720 6173	8617 169227	среднее	726
Афиноген	Устинова	\N	8 (743) 268-1798	9846 714171	\N	727
Фадей	Субботин	Григорьевна	+7 (679) 399-8430	5480 458328	среднее профессиональное	728
Филарет	Ермакова	Эдгарович	8 732 349 0336	2444 768328	высшее	729
Василиса	Гаврилов	Викентьевич	+7 (346) 098-3483	9443 922614	среднее профессиональное	730
Мечислав	Ефремов	\N	8 (043) 570-95-32	7104 720038	среднее профессиональное	731
Радован	Рябова	Викторович	8 (915) 958-71-32	6731 804906	\N	732
Макар	Ершова	\N	+7 731 303 9905	2510 644216	неоконченное высшее	733
Авдей	Бобров	\N	+7 883 326 9182	7835 595419	неоконченное высшее	734
Тимофей	Тимофеева	Аксёнович	8 (103) 079-1481	4467 206193	высшее	735
Леон	Аксенов	\N	8 502 829 0187	4611 210522	\N	3727
Аполлон	Аксенова	\N	+7 (345) 557-57-15	3641 365696	высшее	736
Адриан	Исаев	Ждановна	89670947173	6673 203348	\N	737
Мстислав	Маслова	Павловна	84181061684	4408 959616	высшее	738
Тарас	Пестова	Антоновна	89574366749	7773 904424	высшее	739
Радован	Сысоев	Арсеньевич	8 805 772 7601	6301 168305	среднее	740
Селиван	Устинова	\N	8 (979) 621-15-65	5357 261466	среднее	741
Элеонора	Щукин	\N	8 (644) 736-46-34	8672 650709	среднее профессиональное	742
Лучезар	Никонова	\N	+7 (906) 915-7675	4339 324460	высшее	743
Лонгин	Орехова	\N	8 (471) 676-5663	4288 607885	высшее	744
Владлен	Васильева	Львовна	8 (793) 389-3876	1161 410621	\N	745
Мокей	Щербакова	\N	+7 668 170 54 70	9674 869583	\N	746
Дорофей	Ефремова	\N	+7 (691) 687-9612	6660 453581	среднее	747
Карп	Потапова	\N	+7 (701) 058-3344	4059 477044	среднее	748
Кирилл	Филиппов	Валентинович	+7 598 637 71 74	9209 513991	неоконченное высшее	749
Боян	Иванов	\N	+71952203629	3638 196676	среднее	750
Юлий	Михеева	\N	8 781 354 1936	1080 976313	среднее профессиональное	751
Моисей	Мамонтов	Гордеевич	+7 (408) 617-3189	2647 111731	среднее	752
Федот	Маркова	\N	8 (292) 223-11-35	6348 547501	среднее	753
Варвара	Шестаков	\N	8 266 946 5715	4300 331687	неоконченное высшее	754
Велимир	Евдокимова	Ерофеевич	86658262784	5733 584535	высшее	755
Корнил	Андреева	Вадимовна	+74040956498	8122 335454	высшее	756
Нинель	Николаев	Вилорович	8 129 291 15 04	5328 557139	неоконченное высшее	757
Варфоломей	Дьячков	Ефимовна	+7 (273) 764-21-56	3889 179349	среднее	758
Епифан	Веселов	Ивановна	+7 (837) 816-37-77	3387 820883	неоконченное высшее	759
Фаина	Миронова	Сергеевна	+7 (312) 982-5024	9238 901320	среднее	760
Анжела	Горбунова	Тимофеевна	+74759612048	2675 725743	\N	761
Никандр	Новиков	Львовна	8 958 649 1017	1455 717416	среднее профессиональное	762
Антонин	Мельников	Даниловна	8 (035) 722-76-96	7276 582188	среднее профессиональное	763
Моисей	Лихачева	Ильич	+7 (834) 288-46-79	8368 770858	высшее	764
Василиса	Русакова	Виленович	8 (307) 731-49-36	6192 339950	\N	765
Гремислав	Быкова	Сергеевна	8 (641) 304-19-76	6126 162390	высшее	766
Светлана	Наумова	Адамович	85990383851	9084 575306	высшее	767
Ерофей	Семенова	\N	+78030422630	3307 303528	\N	768
Алина	Сазонов	\N	80758464824	4096 307159	неоконченное высшее	769
Любовь	Афанасьев	\N	84645785362	4848 739573	среднее	770
Анастасия	Силин	Геннадиевна	8 (839) 255-5642	7753 751906	\N	771
Егор	Веселов	\N	+7 (153) 224-71-61	8750 839967	неоконченное высшее	772
Елена	Жданов	Тихонович	80013867847	3884 526283	среднее профессиональное	773
Климент	Зуев	\N	8 (484) 552-77-99	6689 490783	неоконченное высшее	774
Адам	Агафонов	\N	8 807 892 29 56	8724 261586	среднее профессиональное	775
Панкрат	Ситников	\N	8 (472) 792-55-10	9164 685728	среднее профессиональное	776
Семен	Горбачева	Кузьминична	83779180883	3632 356926	неоконченное высшее	777
Селиван	Гурьев	\N	+7 (870) 429-94-94	8350 570852	среднее	778
Борис	Фомичева	\N	+71052822524	2517 437906	\N	779
Арефий	Некрасова	Станиславовна	+7 (638) 735-9388	5094 556824	среднее профессиональное	780
Вера	Владимиров	\N	+76528444181	7879 241034	\N	781
Олимпий	Пестова	Владиславович	8 (722) 722-30-46	2613 974433	среднее	782
Степан	Мамонтов	\N	8 (382) 238-4192	5086 100971	среднее профессиональное	783
Элеонора	Соболев	\N	+7 060 502 31 40	9216 736658	среднее профессиональное	784
Лука	Дроздов	\N	87911017387	2161 973691	среднее профессиональное	785
Варфоломей	Стрелкова	\N	8 (025) 483-3081	7568 932259	среднее профессиональное	786
Валентина	Пономарева	Аверьянович	8 (858) 879-3439	3603 727736	неоконченное высшее	787
Прасковья	Трофимова	Тимуровна	+7 (579) 137-94-41	5466 824605	неоконченное высшее	788
Никодим	Михайлова	\N	+73139688004	9427 149404	высшее	789
Филипп	Самойлов	Валериевна	+71756886946	5652 276668	неоконченное высшее	790
Арефий	Дмитриева	\N	+77355511138	2845 257537	неоконченное высшее	791
Лариса	Гаврилова	\N	8 190 804 8062	4398 373211	среднее	792
Софон	Ершова	Тимурович	87752265622	5512 951685	неоконченное высшее	793
Боян	Лебедев	Юльевич	8 (528) 580-9611	4092 664382	неоконченное высшее	794
Януарий	Александрова	\N	8 619 553 52 73	7508 222972	неоконченное высшее	795
Эмилия	Фокина	Тимуровна	+7 039 575 4453	6794 869300	среднее профессиональное	796
Мина	Маркова	Аверьянович	+7 699 590 7985	7061 787971	среднее	797
Светлана	Шилова	\N	+7 870 572 74 20	7246 829714	\N	798
Агафья	Полякова	\N	8 949 940 47 04	3446 926758	среднее	799
Руслан	Андреева	\N	8 (572) 730-15-70	2647 386060	среднее	800
Элеонора	Галкина	\N	+7 (641) 961-1110	2167 697834	высшее	801
Амос	Соколов	Владиленович	8 (417) 537-7923	9681 423949	среднее	802
Варфоломей	Никитин	Валерьевич	8 719 185 5810	6375 792896	\N	803
Константин	Петухова	Наумовна	+7 887 878 18 53	4612 914658	среднее профессиональное	804
Ипатий	Карпов	\N	+79119280281	2164 100652	среднее	805
Антонина	Абрамова	\N	8 440 129 7156	9122 783511	среднее	806
Ювеналий	Горшкова	\N	+7 (501) 507-48-63	9719 229350	неоконченное высшее	807
Панкратий	Шарова	\N	+7 093 748 7158	7068 511989	высшее	808
Корнил	Степанова	\N	+7 (671) 047-9415	1836 731228	неоконченное высшее	809
Леонтий	Евсеева	\N	+7 691 390 60 16	2226 795558	неоконченное высшее	810
Иларион	Харитонов	Гертрудович	8 340 542 2469	8644 609239	среднее профессиональное	811
Соломон	Маркова	\N	8 (710) 236-52-43	2931 956904	\N	812
Анна	Шарапова	Адамович	+7 (343) 915-1400	5886 507721	среднее	813
Алексей	Сорокина	\N	+73677088850	5686 187787	высшее	814
Ярослав	Ершова	\N	8 135 647 96 84	4603 347051	высшее	815
Эмиль	Емельянов	\N	+7 956 359 5135	9602 352693	среднее	816
Александра	Григорьев	Богдановна	+7 011 119 2897	1905 265323	среднее	817
Мефодий	Белова	Альбертовна	8 (138) 606-2660	3867 853796	высшее	818
Филарет	Третьякова	Матвеевна	+7 (855) 998-94-43	7211 750653	среднее профессиональное	819
Артемий	Елисеев	Филатович	85070817317	7031 617313	\N	820
Анна	Борисова	Тимуровна	+7 898 829 86 78	6754 285999	неоконченное высшее	821
Нестор	Шашков	Рубеновна	+79251704138	2817 190204	среднее	822
Галактион	Самсонов	\N	+7 510 829 79 21	6517 779589	\N	823
Остап	Крюкова	Теймуразович	8 (508) 201-3948	4934 533431	среднее профессиональное	824
Ярополк	Дмитриев	\N	+7 519 416 01 11	3595 960421	неоконченное высшее	825
Архип	Молчанова	Гордеевич	+7 (901) 570-7436	3591 872152	высшее	826
Ратибор	Зайцев	Герасимович	+7 (457) 520-14-72	5780 110319	среднее	827
Вячеслав	Гаврилова	\N	+7 765 716 9526	5726 434144	неоконченное высшее	828
Василий	Ефимов	Давыдович	+7 (434) 113-11-29	3069 565627	неоконченное высшее	829
Никанор	Муравьева	\N	8 (205) 270-2871	4390 431161	среднее профессиональное	830
Якуб	Веселова	\N	+7 (548) 717-9284	1148 506811	среднее	831
Дементий	Игнатов	\N	+7 167 154 57 29	2311 451382	среднее	832
Фирс	Маслова	\N	+7 (752) 042-82-96	9321 276917	среднее профессиональное	833
Савва	Жданова	Марсович	8 (307) 315-4732	5801 468636	\N	834
Якуб	Данилов	\N	86967478954	9973 538804	среднее	835
Терентий	Фомин	Леонидовна	+7 444 120 3873	1626 575650	среднее профессиональное	836
Кирилл	Харитонов	Матвеевич	+7 127 713 1390	6287 403726	\N	837
Вениамин	Виноградова	\N	84823947955	8901 278337	среднее профессиональное	838
Александр	Игнатов	Константиновна	+7 (502) 455-00-53	6536 471650	среднее	839
Антонина	Зуева	Ждановна	8 553 265 4142	8526 982359	среднее профессиональное	840
Рюрик	Гуляева	\N	8 (100) 780-58-51	6411 693496	среднее	841
Юлий	Баранова	\N	8 220 883 01 24	3580 980055	\N	842
Леонтий	Соколов	\N	+7 (754) 197-71-37	5746 379705	неоконченное высшее	843
Федот	Тимофеев	Герасимович	+71727658195	6305 626041	высшее	844
Ратибор	Филиппова	\N	8 (525) 414-2452	3775 275572	среднее	845
Ульян	Турова	\N	+7 439 649 66 98	6530 497298	высшее	846
Алевтина	Горшкова	Харлампович	8 (729) 785-82-65	2998 135709	\N	847
Маргарита	Мишина	Николаевна	89506648233	6124 407992	среднее	848
Тарас	Горшкова	\N	8 (234) 746-0968	2605 761033	неоконченное высшее	849
Лукия	Миронова	\N	89877797240	9897 874467	неоконченное высшее	850
Анжела	Тимофеев	\N	8 180 099 06 39	7257 272964	\N	851
Каллистрат	Лукин	\N	8 006 344 7140	1511 520231	высшее	852
Ростислав	Виноградов	Харламович	8 (964) 450-2518	7093 739561	неоконченное высшее	853
Исидор	Бобылев	\N	+7 488 685 23 94	5402 562608	неоконченное высшее	854
Олимпий	Белозеров	Юлианович	8 (764) 833-14-38	5616 991361	среднее профессиональное	855
Ефим	Кириллова	Михайловна	+7 (053) 844-75-64	8874 576512	среднее профессиональное	856
Иларион	Жданов	\N	+73331868840	8763 800037	среднее профессиональное	857
Валерьян	Афанасьева	\N	+7 (781) 511-5035	1942 541679	высшее	858
Андрей	Бобылев	\N	8 (182) 030-2138	4436 597489	неоконченное высшее	859
Ярополк	Доронина	Даниилович	+7 (047) 594-5817	8839 269865	\N	860
Ипатий	Рыбакова	\N	89603578562	9715 698052	неоконченное высшее	861
Артемий	Фомичева	\N	+7 (254) 880-86-44	7582 406157	среднее профессиональное	862
Изяслав	Корнилова	Святославовна	+7 504 660 3606	9789 630022	высшее	863
Ростислав	Исаков	Аксёнович	+7 (000) 609-8013	9478 751614	\N	864
Октябрина	Прохоров	Андреевна	+7 (840) 252-3377	8361 478238	неоконченное высшее	865
Афанасий	Филатов	\N	+7 (957) 544-6086	6184 416565	среднее	866
Лавр	Якушева	\N	+7 990 752 10 50	5042 502646	\N	867
Ратибор	Сазонова	Иларионович	+7 408 793 1515	2441 132321	\N	868
Владлен	Пахомов	Владиславович	+7 (601) 148-11-75	4505 722118	\N	869
Ефим	Журавлев	Ждановна	+7 780 497 08 71	6143 418221	среднее	870
Ратмир	Горбунова	Валериевна	+71660457424	2512 388323	среднее	871
Леон	Потапова	\N	8 149 950 2155	1805 685897	среднее профессиональное	872
Епифан	Максимова	\N	+79045857267	7575 890940	среднее	873
Рубен	Сорокина	\N	+7 935 627 72 55	9371 199822	среднее профессиональное	874
Станимир	Ефремова	\N	+7 236 234 5780	2515 593947	высшее	875
Кондратий	Веселова	Герасимович	8 495 327 13 41	8256 185212	высшее	876
Всеволод	Прохоров	\N	+7 (459) 510-5022	3631 772985	среднее профессиональное	877
Аверьян	Рогов	Аскольдовна	+7 316 097 37 33	8379 646070	среднее профессиональное	878
Стоян	Ковалев	\N	8 (136) 005-7742	4603 178526	среднее	879
Самуил	Князева	Никифоровна	+7 797 958 8492	7478 392456	высшее	880
Серафим	Горбунова	Тарасовна	8 (263) 643-17-81	1407 355844	неоконченное высшее	881
Акулина	Николаев	\N	+7 (597) 788-95-26	1088 429973	неоконченное высшее	882
Елизавета	Степанова	Юльевна	8 (202) 329-74-03	8097 230685	высшее	883
Валерий	Козлов	\N	+78391437361	9052 727280	высшее	884
Регина	Комарова	\N	+7 (145) 602-0744	8913 135504	неоконченное высшее	885
Лонгин	Муравьев	Юльевна	+74205123051	8153 286505	высшее	886
Милица	Ларионова	Натановна	+7 265 383 85 53	2044 867745	\N	887
Валерия	Журавлева	Феоктистович	8 144 392 52 58	7532 953043	\N	888
Евграф	Матвеев	\N	+7 757 977 5807	2038 965707	среднее	889
Михаил	Лобанов	Георгиевна	+74186063160	8421 250101	\N	890
Азарий	Коновалова	\N	83004210080	4167 769068	среднее профессиональное	891
Глеб	Бобров	\N	8 997 822 50 49	3015 326544	высшее	892
Нифонт	Кузьмина	\N	+7 529 804 40 73	5035 971984	среднее	893
Флорентин	Белоусова	\N	8 (098) 563-9977	4506 626119	среднее профессиональное	894
Маргарита	Данилов	\N	8 024 397 6906	2429 424023	\N	895
Аким	Иванов	\N	+7 718 390 53 03	1355 662719	\N	896
Дмитрий	Копылова	\N	87176028108	1758 257391	неоконченное высшее	897
Игнатий	Блохин	\N	+7 404 589 4398	7271 419788	неоконченное высшее	898
Синклитикия	Самойлова	\N	+7 410 606 46 24	5713 763544	неоконченное высшее	899
Вадим	Носова	\N	8 (182) 884-89-41	9780 586367	среднее	900
Мартын	Уварова	Аркадьевна	8 313 668 4182	1060 648510	среднее	901
Вадим	Белов	Анатольевич	+7 909 818 04 64	4272 271050	высшее	902
Лаврентий	Голубев	\N	8 (960) 236-3261	8346 981699	\N	903
Афиноген	Воронов	Изотович	8 (028) 952-01-56	3976 883084	среднее	904
Радислав	Смирнова	\N	88487319509	2515 447243	среднее	905
Милица	Харитонов	Бориславович	8 (336) 247-86-03	4632 286083	высшее	906
Мстислав	Гришин	\N	+7 (530) 297-47-20	4416 609746	среднее	907
Юлиан	Калашникова	Харламович	8 (669) 241-7974	1934 794578	высшее	908
Парамон	Герасимов	Артемьевич	8 332 363 78 32	2709 638169	среднее профессиональное	909
Тит	Никифорова	Изотович	8 470 455 7964	9853 997808	неоконченное высшее	910
Парамон	Кошелев	Руслановна	8 (332) 601-42-49	7935 144530	\N	911
Борис	Яковлев	\N	+7 677 538 75 29	7840 876386	высшее	912
Денис	Некрасов	\N	84484906579	7345 770881	неоконченное высшее	913
Юлиан	Горбунов	\N	+7 812 146 67 29	1081 232046	высшее	914
Боян	Терентьев	\N	+7 939 226 63 02	5668 658750	неоконченное высшее	915
Лазарь	Калашникова	\N	+75999006621	3798 117175	среднее профессиональное	916
Куприян	Егорова	Яковлевна	+72014981722	8027 141385	высшее	917
Наум	Русаков	\N	+7 (892) 706-30-42	1931 414224	высшее	918
Варлаам	Мясникова	Филатович	8 (100) 510-0287	9970 292658	высшее	919
Кондрат	Гущин	\N	+7 (447) 108-30-26	8689 355901	высшее	920
Марфа	Королев	Игоревич	+7 681 672 8383	4912 312137	среднее профессиональное	921
Сергей	Григорьева	Васильевич	84103738766	3539 281660	неоконченное высшее	922
Ирина	Самсонов	\N	+7 (788) 904-00-68	8626 353218	высшее	923
Нестор	Нестеров	Измаилович	8 (910) 006-31-77	5954 325606	\N	924
Тимофей	Рябова	\N	8 305 762 08 53	5817 459511	среднее профессиональное	925
Вацлав	Носов	\N	+7 254 774 20 14	4393 894606	высшее	926
Аполлинарий	Цветков	Филиппович	+7 908 650 5265	4601 822228	среднее профессиональное	927
Варвара	Медведева	\N	8 944 366 40 17	5377 306300	\N	928
Тимур	Белова	Сергеевна	+7 978 102 3829	6491 950597	среднее профессиональное	929
Антонина	Крылов	\N	+7 796 662 1338	3513 628835	среднее	930
Герасим	Савельев	Анатольевна	+7 (417) 823-30-13	9645 662877	\N	931
Амвросий	Якушева	Матвеевна	8 (302) 393-0053	1941 871991	среднее профессиональное	932
Никодим	Морозов	\N	8 (335) 715-3272	1008 713638	среднее	933
Ефим	Уваров	\N	+7 (020) 883-6826	3404 707476	неоконченное высшее	934
Нонна	Петрова	Константиновна	+7 566 286 1735	7753 128612	высшее	935
Елена	Коновалов	Архипович	89533457415	3291 417590	среднее	936
Аскольд	Николаева	Жоресович	+7 188 942 44 66	8685 545179	высшее	937
Архип	Федотова	Ждановна	+7 776 027 83 78	1594 620734	неоконченное высшее	938
Емельян	Михеев	\N	+70671407700	5662 452188	среднее	939
Аким	Андреев	\N	8 602 008 7907	6594 348632	\N	940
Виктор	Семенов	Гордеевич	83270134901	1843 959586	среднее	941
Аристарх	Максимова	\N	8 864 744 44 08	2204 450193	высшее	942
Акулина	Давыдова	\N	+7 213 278 7573	5147 467517	\N	943
Аполлинарий	Горшкова	Степановна	8 (347) 773-62-03	7380 298893	высшее	944
Данила	Князева	Виленович	+7 (868) 261-65-85	3094 522325	высшее	945
Мирослав	Белякова	\N	8 472 437 11 33	6543 976156	высшее	946
Евгений	Кулагин	\N	+7 (863) 946-02-85	6749 377617	\N	947
Остромир	Комиссарова	\N	8 977 791 3404	5842 620355	\N	948
Гурий	Фролов	\N	+74308704247	3403 958195	высшее	949
София	Никитина	\N	8 511 703 77 08	8908 217782	среднее профессиональное	950
Данила	Королев	\N	8 335 444 9816	4504 776013	среднее профессиональное	951
Касьян	Куликова	Мироновна	8 (786) 771-5632	6442 440169	среднее профессиональное	952
Варвара	Денисов	Ефстафьевич	8 662 763 9036	1332 291542	среднее профессиональное	953
Юлиан	Зиновьева	Эдгарович	8 493 815 3522	7406 678172	среднее	954
Селиван	Жданов	\N	+7 334 064 4835	1341 861370	\N	955
Богдан	Панфилов	Денисович	8 622 074 5938	5008 166504	среднее профессиональное	956
Август	Егоров	\N	+7 084 641 1485	2590 747386	среднее профессиональное	957
Агафон	Родионова	Фомич	8 (795) 742-80-50	1618 282011	среднее	958
Юлия	Кошелева	Даниловна	+74686655981	8488 645025	\N	959
Ульяна	Беляков	Арсенович	+7 962 540 93 13	5305 274499	\N	960
Владилен	Андреева	Макаровна	8 (957) 544-8493	4252 204165	среднее	961
Ферапонт	Смирнова	\N	8 (411) 019-1576	3656 460100	высшее	962
Владислав	Лыткина	Ниловна	84962506141	7200 743061	высшее	963
Вышеслав	Коновалов	Федосьевич	+7 (029) 637-8802	9490 475040	среднее профессиональное	964
Федор	Кондратьев	Захарьевич	+7 (477) 980-3573	8756 296692	среднее	965
Зосима	Пономарева	Венедиктович	8 016 471 11 80	7643 987312	\N	966
Николай	Лукина	Иосипович	8 (920) 193-28-52	3909 798058	высшее	967
Вячеслав	Чернов	Терентьевич	+7 713 316 80 07	5369 406767	высшее	968
Ольга	Кириллов	Кирилловна	8 (665) 865-2022	6184 349292	\N	969
Владимир	Белова	\N	8 892 637 66 03	3743 567544	высшее	970
Дмитрий	Кулакова	Геннадиевна	8 (311) 091-2097	6104 388691	\N	971
Вадим	Уварова	\N	+7 615 538 73 84	9226 999365	высшее	972
Вероника	Ларионова	\N	+7 (252) 192-19-79	5013 618453	неоконченное высшее	973
Милица	Сорокин	Яковлевич	+78664574366	7185 412311	высшее	974
Нина	Куликова	Теймуразович	+7 (477) 636-22-69	1441 678407	высшее	975
София	Шарапов	\N	8 352 163 7384	3455 383582	\N	976
Никанор	Селиверстов	Иларионович	+73753745723	3779 304657	среднее профессиональное	977
Вера	Орлова	Анатольевна	8 (820) 294-9078	2022 615403	среднее профессиональное	978
Лора	Носкова	\N	8 (610) 178-8565	2625 584702	среднее	979
Виктор	Харитонов	\N	+7 556 926 04 43	6324 806074	высшее	980
Сидор	Нестеров	\N	+7 885 386 40 51	6746 920996	\N	981
Руслан	Селиверстова	\N	+7 (003) 755-02-31	4221 180481	среднее профессиональное	982
Радим	Орлов	Святославовна	+7 (312) 826-3847	4458 337459	среднее профессиональное	983
Трифон	Суханов	\N	+7 (567) 860-2161	5908 267995	высшее	984
Евстигней	Артемьев	\N	+70615478660	8953 799441	среднее	985
Любовь	Некрасов	Ермилович	+7 315 751 33 78	6326 460521	среднее	986
Сила	Фомичев	Станиславовна	+7 (317) 096-5117	3193 153960	высшее	987
Евстафий	Суворова	Борисович	+7 861 786 60 86	8336 693036	неоконченное высшее	988
Бажен	Петров	Устинович	+7 197 461 93 37	9230 504190	\N	989
Валерий	Маслов	\N	+7 (694) 339-47-42	3753 982230	среднее	990
Зиновий	Терентьева	\N	+78428357734	8329 385494	\N	991
Юлий	Соколова	Антонович	8 (646) 626-7531	3182 650244	\N	992
Варфоломей	Зыкова	\N	+7 117 351 4776	7821 698893	\N	993
Святополк	Капустин	Викторовна	8 218 532 33 39	7800 643175	среднее профессиональное	994
Панфил	Королева	Геннадиевич	+7 (039) 793-32-59	2350 880933	\N	995
Азарий	Агафонов	Игоревна	8 158 540 6484	8138 782576	высшее	996
Юлий	Фомина	Давидович	8 (235) 675-5193	6705 103506	неоконченное высшее	997
Марк	Максимов	\N	+7 (633) 253-54-27	9348 714199	среднее	998
Олег	Гордеева	Германович	86212125051	2315 255663	среднее	999
Твердислав	Белозерова	\N	+7 (341) 609-83-08	7359 159075	среднее	1000
Вера	Евдокимова	\N	+7 009 012 53 66	7790 731417	высшее	1001
Андрон	Копылов	Игнатович	8 (009) 300-47-42	1546 339813	среднее профессиональное	1002
Кузьма	Субботина	Феодосьевич	8 (161) 461-3990	8484 776040	среднее профессиональное	1003
Константин	Попов	Вилорович	+7 046 945 95 20	4557 994327	\N	1004
Аким	Аксенов	\N	+7 946 440 67 29	3891 373515	среднее профессиональное	1005
Радован	Романов	Яковлевна	+7 088 433 93 85	5001 986551	\N	1006
Сократ	Герасимова	Рубеновна	+7 (363) 487-57-37	6337 864882	неоконченное высшее	1007
Михей	Новиков	\N	+7 592 250 52 51	1116 923373	среднее	1008
Евгения	Никифорова	Антоновна	+7 491 986 91 82	7779 740338	\N	1009
Амвросий	Афанасьева	Игоревич	8 505 439 84 37	1919 695315	среднее	1010
Максим	Евдокимов	\N	8 (458) 576-1270	2413 299488	среднее	1011
Прасковья	Лапин	\N	+7 917 492 84 66	9546 326048	среднее	1012
Наркис	Носова	Бенедиктович	8 367 845 91 02	5956 331909	неоконченное высшее	1013
Максимильян	Богданов	\N	+7 (622) 412-0288	6798 931245	среднее профессиональное	1014
Эммануил	Морозов	Игоревич	+71302635901	6444 192610	\N	1015
Давыд	Лукин	Ильясович	86115393432	2547 737073	среднее	1016
Наркис	Шарапов	\N	+7 763 716 18 20	8979 895346	среднее профессиональное	1017
Варвара	Зыкова	Захарьевич	87795758004	4395 503538	среднее профессиональное	1018
Галина	Григорьев	\N	87384242101	4502 987661	\N	1019
Владлен	Лобанова	Валерьевич	8 (946) 771-72-44	5257 508981	высшее	1020
Артем	Логинов	Евсеевич	+7 951 638 97 00	1042 981543	\N	1021
Афанасий	Мясникова	\N	+71905342168	9530 351990	среднее	1022
Кир	Миронов	Адамович	8 (562) 293-99-84	7868 337723	неоконченное высшее	1023
Наум	Михеева	\N	+72515235623	4749 793274	среднее профессиональное	1024
Евлампий	Романова	\N	8 033 938 3548	9340 233939	неоконченное высшее	1025
Ангелина	Владимирова	Рубеновна	8 (674) 762-5792	9857 174710	высшее	1026
Иван	Савельев	\N	+7 (938) 855-48-29	4655 278134	\N	1027
Евграф	Петрова	\N	+7 (417) 000-77-10	6975 684585	неоконченное высшее	1028
Александр	Кононов	Гавриилович	+7 882 512 92 83	4364 690930	высшее	1029
Надежда	Бобылев	\N	+7 (069) 859-73-33	9046 961377	высшее	1030
Карп	Кондратьев	\N	+7 (393) 082-28-74	9042 187867	высшее	1031
Матвей	Елисеева	\N	8 604 365 75 61	6450 688902	\N	1032
Владлен	Ершов	\N	+7 (130) 244-2061	1098 710892	среднее профессиональное	1033
Автоном	Сергеев	\N	+7 543 250 70 79	7861 585499	среднее профессиональное	1034
Олимпий	Панфилова	\N	8 254 762 7437	4981 905522	среднее профессиональное	1035
Велимир	Дмитриева	\N	+7 482 560 6771	4633 986308	\N	1036
Евстафий	Крылова	Виленович	8 395 485 11 80	1677 881103	неоконченное высшее	1037
Харитон	Дорофеева	Игоревна	+7 583 331 53 50	8690 970826	неоконченное высшее	1038
Азарий	Игнатьева	\N	+7 386 597 79 34	7137 295579	высшее	1039
Раиса	Белов	Сергеевна	+7 (690) 379-1430	9698 448012	среднее профессиональное	1040
Виталий	Субботин	Матвеевна	8 297 495 07 07	7467 227905	среднее	1041
Матвей	Кулагин	\N	+7 (199) 071-2928	7577 821424	среднее профессиональное	1042
Игнатий	Колобов	\N	8 043 310 25 61	7298 832824	неоконченное высшее	1043
Олег	Меркушев	Ярославович	8 (759) 385-8795	7914 688605	\N	1044
Никанор	Владимирова	Ефимьевич	+7 (315) 953-0982	2321 650626	среднее профессиональное	1045
Роман	Котов	\N	+7 302 398 4383	6798 889383	среднее профессиональное	1046
Лука	Орлов	Владимировна	80340397865	4272 720728	среднее профессиональное	1047
Доброслав	Константинов	\N	8 260 682 7849	8288 651889	среднее	1048
Яков	Уваров	\N	8 113 680 14 16	9988 239592	среднее	1049
Виссарион	Зуев	\N	8 976 560 5901	3555 906140	неоконченное высшее	1050
Борис	Лыткина	\N	+7 (983) 766-2925	5960 472439	\N	1051
Лука	Фролова	Сергеевна	+7 987 746 77 20	3029 803618	\N	1052
Ладислав	Корнилова	Федотович	+7 (243) 499-6211	4978 545153	\N	1053
Иннокентий	Павлов	Гурьевич	+74808762120	9180 249265	высшее	1054
Евстигней	Белякова	Ефремович	+7 556 730 65 21	1758 725261	высшее	1055
Венедикт	Беспалова	Ефимовна	+7 (365) 418-84-78	7852 800747	среднее профессиональное	1056
Софон	Поляков	Валерьевич	+7 (574) 756-20-30	4734 597039	\N	1057
Степан	Максимов	\N	+7 162 987 3766	7434 634097	неоконченное высшее	1058
Валентина	Веселов	\N	83248309179	5712 135779	среднее профессиональное	1059
Гаврила	Рогов	\N	8 614 263 7501	8049 468949	среднее	1060
Олимпиада	Мамонтов	Игоревич	84571528215	8108 678727	среднее профессиональное	1061
Ярополк	Аксенова	Тимуровна	8 822 086 60 27	5305 133535	среднее профессиональное	1062
Потап	Константинов	Ивановна	+7 579 939 4908	6357 662292	неоконченное высшее	1063
Афиноген	Григорьев	\N	+7 749 679 67 51	8359 290281	неоконченное высшее	1064
Карп	Селиверстов	\N	+7 664 029 9980	7489 216582	среднее	1065
Твердислав	Никонова	Юлианович	+7 365 308 08 38	4497 266599	\N	1066
Ананий	Шилова	Кузьминична	86079955551	1621 135826	среднее	1067
Михаил	Кудряшова	\N	+7 367 166 6049	9394 560235	высшее	1068
Глафира	Игнатьева	Абрамович	8 (631) 197-2304	2273 588772	\N	1069
Тит	Панфилов	Всеволодович	+7 (850) 544-94-10	3364 719007	\N	1070
Ян	Самсонов	Еремеевич	+7 063 086 4846	1677 485576	среднее профессиональное	1071
Доброслав	Шубина	\N	+7 (565) 224-21-70	1500 535497	среднее профессиональное	1072
Адриан	Котова	Ефимьевич	+74761126849	2130 659170	\N	1073
Харитон	Дроздова	\N	+7 364 856 80 67	1810 620573	среднее	1074
Дарья	Мартынов	Жанович	+70380080520	2282 249468	высшее	1075
Вацлав	Кириллова	\N	8 (547) 536-1613	3432 210985	высшее	1076
Олимпий	Комиссаров	Болеславовна	+7 811 198 9996	9808 294157	\N	1077
Мирон	Гордеев	Гаврилович	+7 473 639 5384	8838 201812	среднее	1078
Екатерина	Веселова	Тарасович	8 294 041 72 67	6972 155226	высшее	1079
Амвросий	Владимирова	\N	+7 348 495 97 41	8771 829530	\N	1080
Болеслав	Новикова	Евгеньевна	+73911076386	2923 208318	среднее профессиональное	1081
Сергей	Веселов	\N	8 (141) 853-68-26	2031 878204	среднее профессиональное	1082
Кирилл	Панфилов	Романовна	8 (314) 232-9966	1751 305656	высшее	1083
Прасковья	Некрасов	Давыдович	89545530677	3432 411123	среднее профессиональное	1084
Самсон	Ефимов	\N	8 954 577 5247	8534 630937	неоконченное высшее	1085
Ипполит	Тихонова	\N	+7 636 679 45 90	9609 200820	среднее	1086
Ярослав	Чернов	\N	+71911699198	2858 223174	высшее	1087
Антонин	Якушева	\N	8 320 881 44 92	1794 964916	высшее	1088
Фома	Коновалова	\N	+7 (157) 042-0410	1041 455115	высшее	1089
Велимир	Самойлова	Филиппович	8 112 459 4246	2239 100472	среднее	1090
Варфоломей	Нестеров	Алексеевич	+73112833673	1452 933525	среднее профессиональное	1091
Амвросий	Чернов	Филимонович	+7 (775) 600-6972	7336 702828	высшее	1092
Анатолий	Крылов	Юльевич	8 (109) 797-12-31	6172 736570	неоконченное высшее	1093
Евстафий	Шашков	\N	80725175759	8869 902148	высшее	1094
Регина	Пахомов	Алексеевич	8 (848) 143-8542	1676 423255	\N	1095
Анисим	Молчанов	\N	+7 179 179 4219	9858 283864	среднее профессиональное	1096
Евгений	Логинова	Юрьевна	8 435 757 94 96	4790 143892	среднее профессиональное	1097
Любовь	Евсеев	Владленович	8 (631) 810-8544	7917 403445	среднее	1098
Гурий	Потапова	Юльевна	+76653602593	1804 886617	среднее профессиональное	1099
Амвросий	Муравьев	\N	8 (650) 384-54-53	5155 640794	неоконченное высшее	1100
Святослав	Кузьмина	\N	+7 (031) 478-7377	3647 492126	\N	1101
Лавр	Кононова	\N	+7 (316) 005-20-12	4788 629830	высшее	1102
Дмитрий	Шубин	\N	+7 347 774 5662	7682 187412	\N	1103
Надежда	Воробьева	\N	8 (609) 948-0139	9689 742609	\N	1104
Эмиль	Пахомов	\N	8 (780) 577-0695	3289 898751	среднее	1105
Валерьян	Архипова	Аверьянович	8 244 193 2844	4792 348700	высшее	1106
Азарий	Козлова	\N	+7 962 902 2342	5052 596174	среднее профессиональное	1107
Наина	Коновалова	\N	8 (154) 487-3438	1195 353146	неоконченное высшее	1108
Селиверст	Меркушева	Жанович	8 906 348 95 22	2222 493782	среднее	1109
Изяслав	Суворов	\N	+7 959 325 8962	8218 238692	высшее	1110
Самуил	Никитина	\N	8 (678) 480-6978	2941 568893	неоконченное высшее	1111
Кир	Пестов	\N	8 (366) 411-44-56	3447 324857	высшее	1112
Варвара	Жданова	\N	8 (512) 114-00-78	8717 867717	высшее	1113
Анна	Русакова	Романовна	8 (457) 855-04-34	9798 334153	\N	1114
Олег	Морозов	\N	+7 554 847 23 64	4945 108206	неоконченное высшее	1115
Назар	Ермакова	\N	+7 477 533 53 40	4153 196148	\N	1116
Платон	Якушев	Кузьминична	+7 050 625 1935	7164 761715	высшее	1117
Гостомысл	Ильина	\N	+70757945116	7482 342677	среднее	1118
Савелий	Кузьмин	\N	8 574 670 81 36	8841 563701	среднее	1119
Азарий	Большаков	Анатольевич	82801387025	3935 460438	высшее	1120
Никодим	Беспалова	Евсеевич	8 (792) 400-4233	6155 384949	среднее профессиональное	1121
Кондрат	Филиппова	\N	8 968 631 22 27	4434 616460	среднее профессиональное	1122
Феликс	Петров	Жоресович	+7 443 851 1744	7015 132108	среднее профессиональное	1123
Мокей	Анисимов	\N	+7 (890) 874-5256	3696 781520	неоконченное высшее	1124
Эдуард	Мясников	Исидорович	+7 (532) 920-08-65	9219 178996	неоконченное высшее	1125
Всеслав	Волкова	\N	+7 614 636 4236	7926 167900	\N	1126
Фрол	Мишина	Егорович	+7 (050) 971-64-38	4193 704542	\N	1127
Наум	Бирюкова	Васильевич	+7 (773) 168-83-80	5854 946273	среднее профессиональное	1128
София	Меркушева	Адрианович	8 601 668 86 68	9690 787216	неоконченное высшее	1129
Ия	Захаров	Демьянович	+7 (582) 572-2036	6022 573414	среднее профессиональное	1130
Аполлон	Киселева	\N	8 (693) 948-3793	8713 292729	высшее	1131
Аполлинарий	Шубина	\N	8 (831) 807-5833	3213 498930	\N	1132
Сергей	Брагина	Ниловна	8 693 443 85 15	3117 998205	неоконченное высшее	1133
Авксентий	Поляков	\N	+7 (464) 281-15-86	6903 970719	высшее	1134
Николай	Хохлов	\N	+7 042 363 3310	4182 723793	\N	1135
Анатолий	Горшков	\N	+7 555 588 3190	3699 813397	среднее профессиональное	1136
Юлия	Воробьев	\N	8 615 172 8221	5930 461924	среднее профессиональное	1137
Ерофей	Мухин	\N	+7 431 996 57 74	3921 102907	высшее	1138
Самуил	Морозова	\N	+7 507 583 3056	3157 244775	высшее	1139
Жанна	Поляков	Гертрудович	83879518293	5843 302221	среднее	1140
Измаил	Лихачев	\N	+76976948577	6833 203070	среднее	1141
Самуил	Давыдов	\N	82336408207	1416 622865	неоконченное высшее	1142
Варфоломей	Копылова	Адрианович	89693808465	6885 841352	среднее	1143
Авксентий	Муравьева	Фёдорович	8 364 687 2517	5642 223904	среднее	1144
Лука	Капустин	\N	+7 714 615 1011	6177 814544	\N	1145
Фока	Харитонов	Григорьевич	85914145343	5989 850452	среднее профессиональное	1146
Петр	Андреев	Исидорович	+7 699 123 92 07	9577 395687	среднее профессиональное	1147
Евстигней	Маслова	Егорович	+79716694368	1005 574492	среднее	1148
Радислав	Бурова	Изотович	+7 (234) 264-30-67	6649 501139	среднее	1149
Гурий	Сергеева	\N	+7 (829) 476-4226	6693 709452	\N	1150
Клавдия	Орехова	\N	+7 (663) 417-84-01	3166 183121	среднее	1151
Климент	Крюкова	\N	8 442 722 9763	2911 739989	среднее	1152
Синклитикия	Комиссаров	\N	+75669060859	9715 341360	среднее	1153
Фотий	Матвеев	Яковлевна	8 647 026 8167	7152 672394	высшее	1154
Спартак	Андреева	Филатович	86242095014	2917 232851	высшее	1155
Никодим	Иванов	\N	8 851 695 7745	6410 506618	высшее	1156
Онуфрий	Герасимов	Андреевна	8 949 323 4481	3109 151835	неоконченное высшее	1157
Николай	Горбунова	\N	+7 (098) 672-60-74	5436 888478	высшее	1158
Василиса	Жданов	\N	89460120537	1708 193020	\N	1159
Агата	Тимофеева	\N	+78880197509	3355 130528	среднее	1160
Вадим	Матвеев	Анисимович	+7 120 845 40 21	8028 484468	высшее	1161
Харлампий	Громов	Терентьевич	8 (223) 679-11-73	4565 645646	среднее профессиональное	1162
Глафира	Фомичев	\N	+7 295 874 2163	9629 162753	среднее	1163
Арсений	Лобанова	\N	+7 051 979 08 86	6778 231857	\N	1164
Алла	Смирнова	Афанасьевна	8 (088) 109-90-87	6092 481302	неоконченное высшее	1165
Эрнест	Фокин	Изотович	+7 (952) 640-8625	9560 499235	\N	1166
Ефим	Баранов	Ильич	+7 677 862 3866	9377 134827	неоконченное высшее	1167
Анна	Родионов	Леонидовна	88900957566	3624 478363	\N	1168
Герман	Воробьева	\N	+7 (714) 144-26-47	1448 857395	неоконченное высшее	1169
Софрон	Смирнов	Тимурович	8 (101) 975-6050	6406 845448	\N	1170
Петр	Мясникова	Игнатович	8 291 875 4403	3843 636278	неоконченное высшее	1171
Милен	Михеев	Арсеньевич	+7 (633) 741-9397	9706 543754	\N	1172
Авксентий	Большаков	Ермилович	8 825 467 68 02	8853 197120	среднее	1173
Виталий	Зыков	Ерофеевич	+7 361 151 5569	6989 656774	высшее	1174
Варвара	Белоусов	Робертовна	+7 (312) 362-83-45	9681 122597	неоконченное высшее	1175
Любомир	Агафонов	Александровна	8 439 315 79 86	1277 576637	\N	1176
Фирс	Гусева	Петровна	80095783450	3542 758083	среднее профессиональное	1177
Любовь	Громов	Болеславовна	+7 333 270 6219	1345 461860	среднее профессиональное	1178
Кондратий	Воронцов	Фокич	+73155051783	6470 638595	среднее	1179
Фаина	Евсеева	\N	8 (085) 484-7232	9276 148712	высшее	1180
Ипполит	Журавлев	Станиславовна	8 (969) 367-9075	8801 863085	среднее	1181
Борис	Симонова	\N	+7 (643) 513-6591	5957 430694	\N	1182
Твердислав	Денисов	\N	+7 842 360 06 65	5532 348722	среднее	1183
Никодим	Самсонова	\N	8 474 442 5284	1679 327727	\N	1184
Ираида	Колобов	\N	+7 399 690 97 35	6677 783177	высшее	1185
Никодим	Макаров	Геннадиевна	8 (868) 145-2165	1045 883906	среднее	1186
Стоян	Туров	\N	+76763097255	4910 261538	среднее	1187
Фока	Авдеев	\N	8 (641) 373-1146	8447 765910	неоконченное высшее	1188
Валерий	Исаев	Григорьевна	+7 653 391 2697	7603 602476	среднее	1189
Людмила	Мухин	Феликсович	8 (080) 883-05-07	8132 392741	высшее	1190
Алина	Гришин	Бориславович	+7 915 630 41 37	2279 331157	\N	1191
Евгения	Селиверстов	\N	+7 832 112 93 58	1907 197054	неоконченное высшее	1192
Никодим	Колобова	Олеговна	+74356178957	1858 148600	высшее	1193
Лавр	Большаков	\N	+7 289 553 4807	6352 378002	\N	1194
Ия	Борисова	\N	+7 356 398 0850	1574 119123	\N	1195
Адриан	Комаров	\N	8 173 201 9192	8768 950992	среднее профессиональное	1196
Харлампий	Тимофеев	Измаилович	8 (569) 661-53-25	2667 499987	неоконченное высшее	1197
Симон	Воронов	Васильевна	8 (230) 964-8799	8384 985281	неоконченное высшее	1198
Глафира	Константинова	\N	8 206 349 0958	5765 750762	высшее	1199
Нонна	Щукин	\N	8 (368) 545-14-73	1823 890514	неоконченное высшее	1200
Евдокия	Лебедева	\N	+76209112933	6028 797567	среднее	1201
Светозар	Федотова	\N	+7 (331) 272-61-46	7957 131747	высшее	1202
Эрнст	Шилов	\N	8 420 799 05 32	5336 714798	\N	1203
Вацлав	Дорофеева	\N	+7 623 280 2308	1196 387367	среднее	1204
Агата	Юдин	Гертрудович	86521910711	1087 335463	неоконченное высшее	1205
Милован	Комарова	\N	8 136 021 47 68	9102 498697	среднее	1206
Казимир	Копылова	\N	8 211 386 9435	7676 939080	высшее	1207
Тит	Шилов	Исидорович	+7 407 990 97 43	7897 744714	\N	1208
Эраст	Меркушева	Максимовна	+7 (287) 580-79-94	5897 711116	неоконченное высшее	1209
Терентий	Елисеев	Леонидовна	+72689779824	7582 247223	высшее	1210
Антонина	Герасимова	\N	+7 802 117 66 89	7544 495786	неоконченное высшее	1211
Твердислав	Ефремов	\N	8 080 757 78 32	6936 719601	неоконченное высшее	1212
Януарий	Потапов	\N	+7 (610) 155-19-80	5718 404717	\N	1213
Будимир	Гусев	\N	+74139609595	3336 731528	высшее	1214
Виталий	Егоров	Федотович	8 (250) 135-4195	4016 476445	среднее	1215
Маргарита	Красильникова	\N	8 113 024 20 44	1603 541146	неоконченное высшее	1216
Азарий	Герасимов	\N	8 966 632 35 66	4105 504478	среднее	1217
Никандр	Суханова	Аксёнович	+7 104 161 2764	6618 200056	среднее	1218
Устин	Марков	\N	+7 (854) 552-8668	5699 753928	среднее	1219
Климент	Рогов	\N	+7 763 882 89 95	2282 152487	высшее	1220
Радислав	Богданова	Феодосьевич	8 (682) 852-34-94	7720 719060	\N	1221
Устин	Рожкова	Измаилович	+7 040 866 22 62	7573 453231	среднее	1222
Ипат	Рябова	\N	8 (286) 004-99-94	3083 500565	неоконченное высшее	1223
Капитон	Фомин	\N	8 (212) 670-18-47	2872 262714	среднее профессиональное	1224
Станислав	Власова	\N	+7 (061) 878-42-86	6746 532284	высшее	1225
Влас	Горбачев	Антоновна	+7 920 892 8212	7965 948310	\N	1226
Станислав	Меркушев	Фомич	85343513387	2225 675252	неоконченное высшее	1227
Филарет	Филиппов	\N	8 (350) 224-5486	7360 325774	среднее профессиональное	1228
Валерьян	Харитонов	\N	8 (970) 934-40-27	8236 774598	неоконченное высшее	1229
Симон	Аксенова	Германович	8 (360) 733-58-51	1225 551095	высшее	1230
Виталий	Казаков	\N	8 170 822 29 57	2810 561901	\N	1231
Евсей	Николаев	Станиславовна	+7 (361) 991-6831	9889 561710	среднее профессиональное	1232
Кузьма	Данилов	\N	8 971 445 23 63	5924 377433	среднее	1233
Харлампий	Козлова	Эдгарович	8 844 435 64 98	9593 585857	высшее	1234
Аким	Медведев	\N	8 (982) 644-36-92	7168 559534	неоконченное высшее	1235
Эмиль	Брагина	\N	80085463262	5069 428759	неоконченное высшее	1236
Майя	Бобылев	Ярославович	+7 (172) 861-4442	8333 191448	высшее	1237
Герасим	Дмитриева	\N	+7 532 422 27 77	6625 737843	среднее	1238
Афанасий	Ефимова	\N	+78655908428	7339 721533	среднее профессиональное	1239
Юлий	Бурова	\N	+76667973232	2665 128025	\N	1240
Аникей	Корнилова	\N	+7 903 411 72 19	8320 974639	\N	1241
Амос	Горбачева	Витальевич	+7 (877) 444-30-28	2444 731460	\N	1242
Радим	Уварова	Демьянович	+76963664215	4022 240460	неоконченное высшее	1243
Григорий	Алексеев	\N	+7 (322) 531-62-30	6815 190465	высшее	1244
Орест	Шубина	\N	8 250 080 18 79	4903 956509	среднее профессиональное	1245
Константин	Максимов	Захаровна	+7 296 186 23 09	7557 748641	высшее	1246
Любосмысл	Зимин	\N	+7 621 642 7627	5268 902912	среднее	1247
Радим	Фомичева	\N	+7 065 580 54 43	7337 490774	\N	1248
Еремей	Коновалова	Болеславовна	+7 (374) 824-4990	1846 419569	среднее профессиональное	1249
Георгий	Артемьев	\N	8 825 154 83 11	1439 402828	\N	1250
Мартьян	Жданова	Демьянович	8 174 403 2448	1465 108239	среднее профессиональное	1251
Мартьян	Никифорова	Григорьевич	8 (418) 062-14-77	1468 824674	высшее	1252
Василий	Нестеров	Аскольдовна	8 (046) 324-96-27	2695 220792	среднее	1253
Аверьян	Крюкова	Олеговна	8 119 806 34 70	7499 616972	среднее профессиональное	1254
Якуб	Соловьева	Филиппович	+74811332750	3354 994572	высшее	1255
Игнатий	Лукина	Викторовна	8 682 366 25 00	8732 802225	\N	1256
Антонин	Киселев	\N	8 (830) 160-92-52	4902 721296	высшее	1257
Никодим	Щукина	Ильинична	+7 (246) 221-72-93	1057 693246	высшее	1258
Анна	Бурова	\N	8 517 008 81 99	6618 645162	неоконченное высшее	1259
Анастасия	Никифорова	Иосипович	83194792250	9722 653759	среднее	1260
Тамара	Тихонов	Виленович	+7 (110) 245-1295	3548 818615	неоконченное высшее	1261
Селиван	Кириллова	Гаврилович	+7 (072) 231-3129	7912 278955	\N	1262
Иосиф	Самойлов	\N	+7 (955) 010-8263	6804 476501	\N	1263
Зоя	Носова	Ефремович	+7 347 382 23 07	4001 914730	неоконченное высшее	1264
Селиверст	Максимов	Валериевна	+7 (485) 785-65-54	1970 886978	неоконченное высшее	1265
Богдан	Русаков	Оскаровна	+76053774166	9681 926185	неоконченное высшее	1266
Радислав	Гурьева	Жоресович	8 (452) 992-82-65	5399 280356	высшее	1267
Олимпий	Комарова	\N	8 (843) 407-29-17	4932 354493	среднее	1268
Лариса	Дорофеева	\N	8 430 845 02 26	7161 314539	среднее	1269
Милий	Борисова	\N	8 205 424 71 59	8700 292640	среднее профессиональное	1270
Алина	Николаев	Бориславович	8 331 048 9863	9378 693023	среднее профессиональное	1271
Максим	Петухова	Афанасьевич	8 874 027 61 69	8776 734631	среднее профессиональное	1272
Людмила	Гусев	\N	8 (776) 752-37-12	4675 932298	неоконченное высшее	1273
Кондратий	Григорьева	\N	8 027 742 88 74	4817 315748	\N	1274
Лука	Крылова	Харлампьевич	8 (538) 790-97-86	9045 348234	среднее	1275
Амос	Воронов	\N	82820207598	8284 353290	высшее	1276
Борис	Зиновьева	Максимовна	+7 148 655 72 35	6266 887096	\N	1277
Гаврила	Щукина	Антоновна	8 400 256 27 39	3017 987723	среднее	1278
Никифор	Беспалов	Петровна	8 343 061 23 12	2251 909958	среднее профессиональное	1279
Евдокия	Моисеев	Адрианович	87218560474	3833 936973	неоконченное высшее	1280
Ольга	Лазарева	Гавриилович	+7 843 890 2098	9881 708076	высшее	1281
Архип	Шубин	\N	+7 (107) 437-99-29	6621 208466	среднее профессиональное	1282
Наум	Якушев	Кузьминична	+7 857 611 1880	8831 117073	среднее	1283
Симон	Кулаков	\N	+76422181747	9734 761756	высшее	1284
Капитон	Лобанова	Кирилловна	+7 (632) 453-6544	5068 812135	среднее	1285
Андроник	Суворов	Марсович	8 (961) 703-3136	3220 636334	среднее	1286
София	Денисов	\N	8 699 296 5343	4817 860364	неоконченное высшее	1287
Мечислав	Кулакова	\N	+7 (758) 724-5923	7293 370348	среднее	1288
Руслан	Мартынов	\N	+7 (568) 627-95-69	4242 376048	высшее	1289
Лукия	Русаков	\N	8 573 329 7089	4860 474188	\N	1290
Амос	Гуляев	Оскаровна	+7 523 475 1784	7406 651824	\N	1291
Фока	Прохорова	Филимонович	+7 400 388 4517	7004 217726	\N	1292
Матвей	Уварова	Львовна	8 (345) 272-0611	1216 960757	среднее	1293
Эммануил	Кошелев	\N	+7 708 860 5855	9099 962047	\N	1294
Харлампий	Сазонова	\N	88319146962	5767 251175	высшее	1295
Никанор	Белякова	\N	+78534695187	7459 628703	\N	1296
Самсон	Федорова	Гертрудович	8 (300) 080-21-87	5220 299153	среднее профессиональное	1297
Касьян	Петухова	Гаврилович	8 (047) 345-4969	8450 782252	среднее профессиональное	1298
Амвросий	Федоров	Яковлевич	+7 (167) 906-01-81	9415 996580	\N	1299
Иосиф	Филиппова	Теймуразович	87970624457	8914 372202	неоконченное высшее	1300
Панфил	Киселева	\N	8 238 986 86 30	3691 568713	среднее	1301
Агата	Селиверстова	Богдановна	8 371 164 4529	5793 348690	среднее профессиональное	1302
Милен	Мухин	Эдгардович	86539110003	6673 523393	среднее	1303
Святополк	Петрова	\N	+7 307 697 61 08	4678 554070	\N	1304
Клавдий	Миронова	Константиновна	8 812 829 53 12	1342 664235	среднее профессиональное	1305
Семен	Козлова	\N	+7 418 069 22 76	6623 545150	неоконченное высшее	1306
Прохор	Сафонов	\N	8 585 914 0134	3485 266863	\N	1307
Нифонт	Дементьева	Измаилович	+7 212 809 1607	4112 717347	среднее	1308
Радислав	Исакова	\N	8 319 144 74 67	8551 221408	неоконченное высшее	1309
Яков	Волкова	\N	+74506076480	9415 517989	высшее	1310
Нинель	Данилов	Фролович	+7 (355) 057-67-65	6004 672719	среднее профессиональное	1311
Христофор	Макаров	Зиновьевич	8 563 997 94 64	6244 724584	среднее	1312
Егор	Калинина	Фокич	+7 (206) 113-82-35	7443 585384	среднее профессиональное	1313
Андрон	Петухов	\N	+78330374924	4245 371611	среднее	1314
Полина	Морозова	\N	+7 193 717 50 55	3803 696501	среднее профессиональное	1315
Константин	Хохлов	Альбертовна	+7 (400) 494-65-06	8664 386607	среднее профессиональное	1316
Зиновий	Суворова	Федоровна	+7 (847) 610-66-38	6501 254681	неоконченное высшее	1317
Исидор	Вишнякова	Вячеславович	8 717 343 68 59	5392 855198	неоконченное высшее	1318
Федот	Потапова	\N	8 (370) 636-57-09	6960 575232	среднее	1319
Савватий	Цветкова	\N	+7 312 429 82 50	6961 607373	неоконченное высшее	1320
Виктория	Копылов	\N	8 (885) 629-5527	8857 337113	среднее профессиональное	1321
Мечислав	Авдеева	\N	8 (742) 708-20-18	8757 760376	среднее	1322
Сократ	Яковлева	Эдуардовна	+7 210 830 1624	6661 912400	\N	1323
Клавдия	Морозова	\N	+7 (047) 476-7611	7910 742103	неоконченное высшее	1324
Глеб	Беспалова	\N	8 (666) 662-01-17	8163 533586	\N	1325
Валерия	Пестов	Еремеевич	8 (976) 603-2962	5833 407528	высшее	1326
Остап	Коновалов	Анисимович	82076660638	7586 510356	высшее	1327
Исидор	Карпов	\N	8 (878) 522-23-13	6633 508160	среднее профессиональное	1328
Елисей	Рябов	Филипповна	+7 848 783 2877	2482 822919	среднее	1329
Изяслав	Королева	\N	8 (481) 281-04-18	3821 568488	неоконченное высшее	1330
Игнатий	Нестерова	Филатович	+7 059 863 63 02	5279 611815	среднее	1331
Ратмир	Титов	Вилорович	8 (108) 078-2581	1934 618682	неоконченное высшее	1332
Анисим	Исаева	\N	+7 098 743 11 81	8270 528695	высшее	1333
Нина	Васильева	\N	8 (856) 807-7856	7564 206217	неоконченное высшее	1334
Радим	Савельев	Кирилловна	+7 (147) 077-7565	9833 227078	\N	1335
Ксения	Абрамова	\N	+7 774 689 9410	7265 748896	высшее	1336
Анисим	Зыкова	Данилович	+7 (490) 827-1742	4673 494245	\N	1337
Радим	Князева	Константиновна	+78677674422	6201 797909	среднее профессиональное	1338
Святослав	Евсеева	\N	8 004 507 21 26	2636 659065	\N	1339
Октябрина	Горбачева	\N	+71109693628	5855 552263	высшее	1340
Кирилл	Копылова	Вилорович	8 (220) 803-4155	9030 263367	среднее профессиональное	1341
Афанасий	Аксенов	Даниловна	88723264970	5417 850040	среднее	1342
Адриан	Данилов	Антоновна	+72633962820	2362 503307	\N	1343
Иосиф	Рогова	Романовна	8 (237) 158-1378	9441 354454	неоконченное высшее	1344
Федот	Фролов	\N	+7 519 582 2788	3890 479080	\N	1345
Елена	Власова	Павловна	+7 548 437 8156	1986 818776	среднее	1346
Алевтина	Елисеева	Изотович	+7 108 435 90 58	6282 884040	среднее	1347
Лучезар	Денисов	Вадимовна	+7 (920) 370-2951	7806 168386	высшее	1348
Рубен	Пономарев	\N	+74616419164	3498 865910	среднее профессиональное	1349
Никон	Попова	Тимофеевна	8 481 023 98 13	2711 851004	среднее	1350
Валерий	Максимова	Валерианович	8 860 025 6251	8583 766855	неоконченное высшее	1351
Антонина	Ершов	\N	8 (920) 509-81-61	6510 130079	среднее	1352
Всеволод	Рогов	Тихонович	+7 (816) 989-50-15	3608 733446	высшее	1353
Полина	Рогова	\N	8 (138) 783-80-29	9668 229380	среднее	1354
Ермолай	Тимофеев	\N	8 882 872 38 46	4239 373789	неоконченное высшее	1355
Олимпий	Дроздов	\N	8 044 269 0830	3791 975511	среднее	1356
Захар	Лебедев	\N	8 113 839 82 25	3016 114767	\N	1357
Полина	Калашникова	Матвеевна	+7 (702) 566-96-67	2177 178212	среднее	1358
Аскольд	Буров	Тарасович	+7 (985) 175-64-78	9968 216387	неоконченное высшее	1359
Всеслав	Евдокимова	Артурович	+7 727 922 9847	3953 984562	неоконченное высшее	1360
Чеслав	Беляева	\N	+73641531765	8784 218717	\N	4162
Леон	Буров	Максимовна	+7 (630) 436-6681	3705 666510	среднее	1361
Клавдия	Цветков	Вилорович	8 210 155 3569	5194 540332	\N	1362
Ян	Беляев	Леонидовна	+7 (388) 079-0322	9941 707070	среднее профессиональное	1363
Савва	Шарова	Федоровна	8 773 126 38 88	7346 781462	среднее профессиональное	1364
Милан	Новикова	\N	8 (176) 219-99-28	3007 554424	среднее	1365
Ермил	Ефремова	Викентьевич	8 514 397 32 61	8014 388641	\N	1366
Лев	Медведев	\N	+7 (722) 581-22-31	8284 481390	неоконченное высшее	1367
Панкрат	Цветкова	Глебович	84474049571	7857 157659	неоконченное высшее	1368
Милан	Фомина	\N	8 (030) 071-26-93	1445 861945	\N	1369
Терентий	Рябова	Вадимовна	+79954977975	3211 830165	неоконченное высшее	1370
Игорь	Герасимов	\N	8 005 108 68 74	7287 157209	неоконченное высшее	1371
Ефим	Новикова	Алексеевич	8 (152) 893-6600	2903 200635	среднее профессиональное	1372
Доброслав	Лукина	Терентьевич	8 (122) 102-0014	5682 242987	высшее	1373
Борислав	Михеева	Григорьевна	8 (879) 988-7684	4597 397293	неоконченное высшее	1374
Максим	Уварова	\N	8 (173) 957-3055	1964 991754	\N	1375
Макар	Ширяева	\N	8 640 986 1619	7861 951638	\N	1376
Кирилл	Воронова	Юльевна	+7 765 626 15 15	2894 993581	\N	1377
Лев	Агафонов	Юрьевна	8 426 999 60 69	5878 772420	неоконченное высшее	1378
Елизар	Щербакова	\N	+7 (197) 127-9038	2373 663480	среднее профессиональное	1379
Адам	Калинин	\N	+76894518482	7625 866692	неоконченное высшее	1380
Андрей	Белоусова	\N	+7 (925) 396-0247	5433 541815	неоконченное высшее	1381
Валерий	Костин	Богдановна	83919967743	7301 149037	высшее	1382
Никифор	Макарова	\N	87555052423	7758 727649	неоконченное высшее	1383
Евсей	Макарова	\N	+7 364 593 9860	1660 529756	среднее	1384
Радован	Шубин	Фомич	8 178 769 2999	9089 627806	неоконченное высшее	1385
Любовь	Дмитриева	Фомич	+7 226 301 28 85	2525 748475	среднее профессиональное	1386
Федор	Соколова	Станиславовна	87964376134	4957 442041	высшее	1387
Стоян	Прохоров	\N	+77046303956	7887 255080	высшее	1388
Мокей	Евдокимова	Ефимович	+7 676 118 5826	7536 361600	высшее	1389
Евдоким	Бобылев	Ермилович	+7 (880) 646-1206	6481 740467	среднее	1390
Наркис	Яковлев	\N	+7 486 105 58 31	6241 494778	неоконченное высшее	1391
Элеонора	Кондратьева	\N	+73254718458	7148 637886	среднее профессиональное	1392
Аггей	Андреев	Гавриилович	+7 253 825 5315	5781 188448	неоконченное высшее	1393
Любим	Савельева	\N	8 860 266 90 69	8531 461140	среднее	1394
Фадей	Блохина	\N	+73294406786	8469 967025	высшее	1395
Мокей	Панфилов	Тимурович	81709252619	5662 536461	среднее	1396
Болеслав	Новикова	Анатольевна	+7 592 085 9243	3738 795168	среднее профессиональное	1397
Мария	Гаврилова	\N	8 333 267 52 35	4604 714559	неоконченное высшее	1398
Софрон	Некрасова	\N	+77116295683	1413 493254	высшее	1399
Ян	Быкова	\N	+70682258197	2045 385047	\N	1400
Милан	Фомина	Феоктистович	8 (045) 959-57-45	3321 249006	неоконченное высшее	1401
Евстигней	Сидорова	Леонидовна	+70270345800	6678 709619	среднее	1402
Владимир	Меркушева	Георгиевна	8 736 205 46 24	2464 384645	среднее	1403
Фома	Лаврентьев	Арсенович	84441198830	5375 427789	среднее	1404
Валентин	Лебедева	\N	+7 (182) 812-5267	1812 264432	среднее профессиональное	1405
Лора	Якушева	\N	8 367 893 2963	3867 290207	\N	1406
Самсон	Харитонова	\N	8 164 247 42 77	3664 464273	среднее	1407
Иларион	Белов	Матвеевна	+7 237 921 3259	1326 133967	среднее профессиональное	1408
Анжела	Жукова	\N	+71190763213	7950 467650	высшее	1409
Трофим	Алексеев	\N	88697267010	8712 235114	\N	1410
Мина	Васильева	\N	83320083097	9148 571389	\N	1411
Чеслав	Михайлова	Марсович	+7 (031) 186-80-03	2307 372420	высшее	1412
Вадим	Медведев	\N	+7 (119) 397-1406	5103 927517	высшее	1413
Онуфрий	Мельников	\N	+7 936 943 82 48	4979 235398	\N	1414
Родион	Матвеев	Васильевна	8 (354) 116-41-38	8990 918454	среднее	1415
Юлий	Игнатова	\N	8 751 399 0697	3550 671060	\N	1416
Милован	Власов	Наумовна	8 126 231 31 30	6322 307237	неоконченное высшее	1417
Пахом	Захарова	Зиновьевич	+74760132520	5685 514514	\N	1418
Касьян	Мамонтов	\N	+78145459320	6498 978514	высшее	1419
Бронислав	Бобылев	\N	8 (501) 319-88-28	6396 784403	среднее	1420
Вероника	Гордеева	\N	+7 (147) 017-41-16	3137 241329	среднее профессиональное	1421
Андрей	Ершов	Болеславовна	8 419 000 02 78	3090 504141	среднее профессиональное	1422
Сильвестр	Рогова	\N	+7 033 466 6606	8000 793781	высшее	1423
Захар	Гордеева	\N	8 686 692 86 56	4075 400235	\N	6216
Елизавета	Аксенова	Исидорович	8 (435) 636-3521	5261 344877	неоконченное высшее	1424
Арефий	Антонов	Фёдорович	+7 (501) 213-74-62	4342 604201	среднее	1425
Евгений	Николаева	\N	8 (120) 856-8352	5527 232783	неоконченное высшее	1426
Евсей	Ефремов	\N	8 298 659 6040	4487 402676	среднее	1427
Матвей	Бирюкова	\N	8 (161) 192-0476	5969 490313	среднее	1428
Любосмысл	Яковлева	Аксёнович	89801909545	3870 696759	\N	1429
Олимпий	Тихонова	Викторовна	8 (860) 513-39-59	5529 545440	высшее	1430
Иннокентий	Родионова	Тимуровна	+7 132 949 3857	4708 312928	\N	1431
Мстислав	Яковлев	Тимофеевна	+72434261763	1848 389218	высшее	1432
Ярослав	Мишина	Андреевна	8 362 899 7873	9570 447387	высшее	1433
Мартын	Симонова	Харитонович	+7 (291) 126-88-46	7245 275288	среднее	1434
Осип	Захарова	\N	8 311 264 24 88	3897 674012	среднее	1435
Фотий	Кудряшова	Ивановна	8 (564) 292-73-76	4962 705015	среднее профессиональное	1436
Федот	Субботина	Всеволодович	+76977350336	5824 590028	\N	1437
Лора	Осипов	\N	+7 886 867 9420	3361 479308	высшее	1438
Будимир	Зимин	\N	+7 (072) 123-5594	1016 669076	высшее	1439
Порфирий	Устинов	\N	8 853 199 2895	4104 688508	среднее профессиональное	1440
Яков	Петухова	Артёмович	8 078 883 2339	6776 560825	высшее	1441
Онуфрий	Васильев	Вилорович	+77648052349	8618 282521	неоконченное высшее	1442
Гедеон	Шашкова	Архиповна	8 217 837 58 03	8605 335641	высшее	1443
Гремислав	Лукина	\N	+7 (321) 313-5029	1117 718702	среднее профессиональное	1444
Парфен	Ильина	\N	+7 404 721 45 20	9047 393488	среднее	1445
Ермил	Зиновьев	\N	8 (285) 377-62-30	5250 582155	высшее	1446
Феврония	Соболева	Федоровна	87566665512	3080 305909	неоконченное высшее	1447
Виссарион	Орехов	Геннадьевна	8 625 914 82 59	7522 998984	\N	1448
Герасим	Силина	Геннадиевич	8 (393) 091-93-90	6781 188546	\N	1449
Виссарион	Мухина	\N	+7 (515) 249-74-42	4691 599928	\N	1450
Алла	Пономарев	\N	+7 (959) 784-37-81	6750 504789	среднее профессиональное	1451
Варлаам	Анисимова	\N	+7 887 539 48 75	4940 765628	неоконченное высшее	1452
Тимур	Мамонтова	\N	+70391153431	2318 589676	среднее	1453
Евстигней	Шубин	Бенедиктович	8 (576) 977-17-41	9739 192265	среднее	1454
Прокл	Голубева	\N	84663835209	6179 925531	\N	1455
Фёкла	Пономарев	Никифоровна	+7 796 128 2574	6384 675754	неоконченное высшее	1456
Александра	Ковалев	Вилорович	8 656 845 23 18	5394 695410	среднее профессиональное	1457
Никифор	Калашников	\N	85508464773	9182 229781	\N	1458
Сигизмунд	Евдокимов	\N	84094113854	9539 494543	высшее	1459
Иосиф	Красильникова	\N	8 (129) 445-64-26	9399 744754	среднее профессиональное	1460
Соломон	Лыткина	\N	+7 (033) 771-73-22	9492 865844	\N	1461
Ким	Морозов	\N	+7 (948) 371-32-18	9206 188863	среднее	1462
Изяслав	Егорова	Адамович	87695784306	6304 503443	высшее	1463
Алла	Ермаков	\N	83931323649	3941 208090	высшее	1464
Спартак	Гуляева	\N	+7 423 027 8695	4479 847938	среднее	1465
Илья	Дроздов	\N	8 951 856 31 12	3685 644733	неоконченное высшее	1466
Аполлинарий	Баранова	Артемовна	+7 (117) 576-5118	3057 810941	среднее профессиональное	1467
Елизавета	Козлова	Кузьминична	+7 (433) 110-17-07	6046 620802	среднее	1468
Карп	Никитин	Мироновна	8 612 147 18 85	4906 956096	среднее профессиональное	1469
Севастьян	Киселев	\N	+7 656 581 92 72	8522 292312	\N	1470
Чеслав	Савина	Игоревич	+7 (279) 055-7465	1991 549550	среднее	1471
Нифонт	Шашкова	\N	8 040 673 3551	1989 299910	среднее	1472
Мартьян	Гаврилова	Архипович	8 (636) 081-06-79	9031 822402	среднее	1473
Севастьян	Потапова	\N	82243532486	2866 770015	\N	1474
Прохор	Маслов	\N	+7 (400) 677-99-84	2323 295384	среднее	1475
Каллистрат	Тихонов	Матвеевна	+7 533 016 8812	2208 467003	среднее профессиональное	1476
Кира	Герасимов	Викторовна	+7 (648) 374-6360	6899 997893	неоконченное высшее	1477
Вадим	Мамонтова	Яковлевна	8 (038) 487-43-24	5880 507282	среднее профессиональное	1478
Роман	Шашкова	\N	+75399968772	1683 904383	неоконченное высшее	1479
Прасковья	Маслов	\N	+7 954 174 14 99	1201 374278	среднее	1480
Станимир	Шашкова	\N	+7 (903) 444-1577	5300 434162	среднее профессиональное	1481
Екатерина	Шарова	Геннадьевна	8 (009) 239-6918	3432 988893	\N	1482
Николай	Андреева	Эльдаровна	8 702 279 6588	4884 765994	неоконченное высшее	1483
Ульяна	Суханова	\N	+71636877480	3355 458696	среднее профессиональное	1484
Милица	Шашкова	Рудольфовна	8 036 893 8492	5842 638843	неоконченное высшее	1485
Макар	Федотова	Игнатьевич	+7 (377) 652-3582	2973 989413	среднее	1486
Феофан	Муравьева	\N	8 773 256 9130	5984 287839	среднее	1487
Зоя	Шарапова	\N	+7 (321) 367-2878	4004 195547	среднее	1488
Ирина	Мартынова	Натановна	+72716067939	4909 763743	неоконченное высшее	1489
Тихон	Кошелева	Дмитриевна	83229406444	1398 329954	высшее	1490
Леонид	Константинов	\N	+7 (858) 138-95-22	8663 515399	высшее	1491
Святослав	Зуева	Давидович	8 (338) 750-17-03	1984 685113	среднее	1492
Евсей	Никитина	Александровна	+7 733 785 8143	6745 355198	высшее	1493
Фирс	Вишняков	\N	8 721 661 9554	4021 460054	среднее профессиональное	1494
Ратибор	Давыдов	Анатольевна	8 405 518 4814	1299 142613	высшее	1495
Филимон	Кузьмина	Владиленович	+75270727615	8702 967951	среднее	1496
Майя	Кудряшова	Игнатьевич	8 (553) 660-9458	1621 416533	высшее	1497
Каллистрат	Медведев	\N	8 (555) 966-86-15	6045 375817	среднее	1498
Митофан	Фомин	Никифоровна	+7 (358) 250-1627	6272 479766	неоконченное высшее	1499
Гремислав	Мухина	Еремеевич	8 (947) 270-79-68	4947 184779	высшее	1500
Модест	Беляев	\N	8 133 846 4174	1477 637178	среднее профессиональное	1501
Кондрат	Ковалев	\N	8 240 311 4287	9747 502901	среднее	1502
Фортунат	Шестаков	Иосифович	8 680 153 3519	8762 472803	среднее	1503
Родион	Баранова	\N	+7 (178) 266-7597	1807 512975	среднее профессиональное	1504
Август	Нестеров	Феодосьевич	8 (808) 730-7711	9785 892043	\N	1505
Таисия	Соловьев	Артурович	8 674 948 0081	8557 414177	среднее	1506
Варлаам	Горбунова	\N	85873504283	3848 349709	высшее	1507
Любим	Тихонов	\N	8 268 744 38 14	4841 148508	неоконченное высшее	1508
Семен	Титова	\N	8 (623) 886-4902	1153 492842	\N	1509
Ирина	Герасимова	Денисович	+7 026 852 50 28	8508 871709	неоконченное высшее	1510
Трифон	Лукин	Глебович	+7 (011) 217-61-94	6132 160969	высшее	1511
Эмиль	Исаев	Архипович	+7 237 347 2961	5459 918988	среднее	1512
Самсон	Михайлова	Зиновьевич	+78777600630	7671 494800	высшее	1513
Лазарь	Кириллова	\N	+75042415387	5122 927243	\N	1514
Лавр	Белякова	\N	8 (278) 316-2128	6639 487419	среднее	1515
Денис	Семенова	Демидович	+7 (573) 846-05-51	9416 343391	высшее	1516
Ананий	Филиппова	Феоктистович	+7 (695) 483-2453	5447 340327	среднее профессиональное	1517
Денис	Соловьева	Давидович	+73011860761	4651 292080	среднее профессиональное	1518
Натан	Смирнова	Алексеевна	+79892008729	5273 667162	среднее	1519
Валерьян	Бобылев	Артурович	8 (419) 963-02-69	8999 541186	неоконченное высшее	1520
Марк	Сазонов	\N	+7 (412) 595-66-66	6720 419896	среднее	1521
Анжелика	Моисеева	\N	82130936367	9851 406876	среднее	1522
Кир	Голубева	\N	81191080108	2556 771890	высшее	1523
Иосиф	Ковалева	Гаврилович	8 301 901 8585	4927 935395	среднее	1524
Епифан	Ершова	\N	+73913084098	4338 348514	\N	1525
Модест	Александрова	\N	+7 832 872 4959	1021 990397	высшее	1526
Исай	Зиновьева	Бориславович	+79429454546	5496 762745	неоконченное высшее	1527
Спартак	Ефимова	Оскаровна	8 (350) 469-10-03	1971 932918	среднее	1528
Сидор	Доронина	Фадеевич	8 427 595 55 58	4137 876102	среднее	1529
Гремислав	Гущина	\N	8 (545) 895-0818	1586 961931	среднее	1530
Лев	Логинова	Святославовна	+7 997 441 66 50	5280 116098	\N	1531
Мина	Комарова	\N	+71812644969	5808 144285	\N	1532
Гаврила	Субботин	Игнатьевич	8 058 638 5475	7359 273841	среднее профессиональное	1533
Лука	Ларионов	Игоревна	+7 375 859 41 67	9688 610821	среднее профессиональное	1534
Епифан	Беспалов	Ильинична	+7 (273) 042-2120	2354 390235	неоконченное высшее	1535
Нестор	Мухин	Дорофеевич	8 (574) 455-40-37	7034 119574	\N	1536
Надежда	Тетерин	\N	+7 (274) 162-9221	7924 529960	высшее	1537
Федот	Абрамова	\N	8 869 365 0503	2323 251922	\N	1538
Аггей	Маслов	\N	+7 (908) 705-2346	7693 856934	\N	1539
Ладимир	Кабанов	Викентьевич	8 033 152 2472	9680 515137	неоконченное высшее	1540
Агап	Мясников	Дорофеевич	8 (716) 637-9225	5431 688058	среднее	1541
Вера	Молчанов	Филипповна	8 (117) 447-7717	8042 154570	среднее	1542
Герман	Шарапов	Давыдович	+7 484 212 2733	5438 124774	неоконченное высшее	1543
Автоном	Дементьев	Филипповна	8 (280) 939-8408	9071 242454	высшее	1544
Ксения	Брагина	\N	+7 (190) 860-0087	3741 832133	\N	1545
Леонтий	Бурова	Сергеевна	+7 218 948 92 69	4107 860619	среднее профессиональное	1546
Регина	Алексеев	\N	8 662 337 3289	7902 903701	среднее	1547
Болеслав	Пономарев	\N	+7 537 419 25 52	4268 767702	\N	1548
Макар	Блинов	Болеславовна	8 (361) 370-12-18	1838 262103	неоконченное высшее	1549
Савва	Кошелева	\N	8 807 495 1603	2271 340529	среднее профессиональное	1550
Евдокия	Емельянова	Петровна	+7 (162) 208-97-37	1446 275352	среднее профессиональное	1551
Богдан	Лапина	\N	8 (581) 313-5876	4662 255647	высшее	1552
Ипатий	Лаврентьев	\N	85391807478	3450 247193	\N	1553
Савва	Лобанов	Егорович	86298949655	3371 606315	среднее	1554
Панфил	Харитонов	Богданович	8 (163) 501-16-07	2829 755358	среднее профессиональное	1555
Евгений	Аксенов	\N	+78639976737	1519 975628	среднее	1556
Игорь	Крюков	\N	8 (682) 822-8243	8745 104510	среднее профессиональное	1557
Терентий	Сафонов	Максимовна	8 (971) 400-27-19	6266 836110	неоконченное высшее	1558
Самсон	Селезнев	\N	8 (171) 445-5519	1657 465270	высшее	1559
Дементий	Ершова	\N	8 956 637 8209	5125 562987	среднее	1560
Владимир	Вишнякова	\N	+73526856247	1689 219932	\N	1561
Демьян	Третьяков	\N	8 (898) 114-5420	3133 101826	среднее профессиональное	1562
Олег	Зуев	\N	+7 (954) 625-35-44	6551 596032	высшее	1563
Сила	Осипов	\N	80159072551	6988 382867	\N	1564
Агафон	Меркушева	\N	8 760 984 57 75	1480 646636	неоконченное высшее	1565
Александра	Молчанова	\N	+7 758 392 5523	4730 488497	среднее профессиональное	1566
Демьян	Маркова	Ярославович	+7 619 969 3336	3182 412881	среднее	1567
Леон	Ефремова	\N	+7 039 184 0458	2444 483177	\N	1568
Милица	Гусев	\N	+7 958 246 3086	8425 159108	среднее профессиональное	1569
Варлаам	Попова	\N	8 974 227 5897	2439 996707	\N	1570
Захар	Панфилов	Павловна	+7 118 752 1316	4013 801152	неоконченное высшее	1571
Сила	Михайлов	Демидович	+7 427 305 1232	7052 492509	неоконченное высшее	1572
Иван	Евдокимов	Владиславович	+74441125821	8620 200402	\N	1573
Ипатий	Титова	Ниловна	+7 (559) 641-23-90	3430 499062	высшее	1574
Модест	Павлов	\N	8 497 633 1878	8972 777434	среднее профессиональное	1575
Софон	Захаров	\N	8 861 527 90 26	6592 723928	среднее профессиональное	1576
Светлана	Баранова	Ильинична	8 765 272 70 57	1603 743306	среднее профессиональное	1577
Андрон	Петров	Феофанович	89820901213	6802 511099	среднее	1578
Корнил	Пахомов	\N	8 553 347 2749	7056 761215	среднее	1579
Дмитрий	Стрелкова	Семеновна	+7 (603) 518-2387	1478 369673	неоконченное высшее	1580
Борислав	Беляков	Артемьевич	82255619325	1868 905892	\N	1581
Жанна	Новикова	Данилович	+7 849 726 93 38	6892 669100	среднее	1582
Дементий	Носова	\N	84029466278	5990 253535	\N	1583
Анжела	Беспалов	Георгиевич	+7 (925) 858-3870	2232 124876	среднее профессиональное	1584
Адриан	Белякова	\N	+7 959 110 5930	6056 271810	среднее	1585
Изот	Захаров	\N	+7 (189) 089-5176	5886 185409	неоконченное высшее	1586
Лукьян	Соболев	\N	+7 646 048 7204	8927 630239	среднее	1587
Синклитикия	Владимирова	\N	8 (732) 904-3048	1185 600338	\N	1588
Анисим	Лобанов	\N	+7 (683) 267-22-49	6377 391665	неоконченное высшее	1589
Руслан	Козлов	Егоровна	80257882445	1963 516561	высшее	1590
Аполлинарий	Буров	Эльдаровна	8 452 273 22 93	3726 308437	\N	1591
Мирослав	Ершова	\N	+7 (461) 331-9055	8758 153599	неоконченное высшее	1592
Мирон	Носков	Бориславович	8 935 789 84 58	5487 990481	\N	1593
Тимофей	Кулагина	Еремеевич	+75481234893	5130 652710	неоконченное высшее	1594
Казимир	Герасимов	\N	+7 026 880 68 35	2499 965710	\N	1595
Кира	Якушева	Викентьевич	+7 (528) 867-3323	9392 381273	\N	1596
Наталья	Козлова	Романовна	+7 413 805 1305	8774 438824	среднее	1597
Алевтина	Носков	Ефимович	+75063297891	5405 715687	\N	1598
Вадим	Михайлова	\N	+7 (540) 544-1294	2129 179363	\N	1599
Аникита	Александров	\N	8 (226) 104-0309	8132 429183	неоконченное высшее	1600
Агафья	Герасимов	Натановна	8 (856) 347-25-74	1470 424917	\N	1601
Галина	Пономарев	Владиславовна	8 (637) 224-8170	8958 264182	неоконченное высшее	1602
Нестор	Соболев	\N	+7 115 245 95 77	5991 891234	среднее	1603
Евдокия	Михайлова	\N	+7 (183) 600-8894	7589 448552	неоконченное высшее	1604
Аполлинарий	Якушев	\N	+7 484 960 04 66	8565 814292	высшее	1605
Парфен	Меркушев	\N	8 446 622 30 32	1444 601834	высшее	1606
Дарья	Евсеев	Данилович	+76203333914	4745 491043	высшее	1607
Ярослав	Морозов	\N	+7 (045) 888-4285	2951 790947	среднее профессиональное	1608
Влас	Симонов	Дмитриевна	8 (591) 000-27-39	7527 989814	\N	1609
Сила	Никитина	Игнатьевич	+7 (315) 203-8420	5463 357013	высшее	1610
Венедикт	Маслова	\N	+7 (821) 247-13-09	3465 671922	неоконченное высшее	1611
Валерия	Пахомов	\N	+7 (516) 163-93-48	9830 800057	\N	6217
Василиса	Горбачев	Арсеньевич	+7 (971) 334-01-94	2138 608092	высшее	1612
Митофан	Иванова	\N	+78334012975	7352 219720	\N	1613
Зоя	Исаев	Викторович	8 (781) 190-5489	6210 549535	неоконченное высшее	1614
Савва	Виноградова	Теймуразович	+78157265750	7265 169533	высшее	1615
Тимофей	Сорокина	\N	+7 157 061 5335	1765 873819	высшее	1616
Чеслав	Рябова	\N	8 (415) 996-92-25	7142 310326	среднее профессиональное	1617
Ян	Давыдова	\N	+72452672686	5093 727193	высшее	1618
Панкратий	Быков	\N	+7 086 001 6071	2995 607866	среднее профессиональное	1619
Куприян	Голубев	\N	+74271408713	4755 856599	\N	1620
Касьян	Трофимов	\N	8 (587) 811-5424	5097 561064	неоконченное высшее	1621
Аполлинарий	Щукина	Витальевич	8 971 546 1619	1978 993574	высшее	1622
Лукьян	Беляева	Эдуардович	+7 (187) 883-18-49	1173 641860	высшее	1623
Марина	Корнилова	Тарасович	+70360795429	3502 709352	высшее	1624
Амос	Афанасьев	Брониславович	8 (196) 599-01-84	9136 921138	\N	1625
Мария	Калинин	Эльдаровна	8 (408) 995-6705	6501 111522	высшее	1626
Нонна	Степанова	\N	+7 (722) 337-53-73	8994 485019	\N	1627
Карп	Громова	Леонидовна	+7 (435) 912-3357	2152 830698	высшее	1628
Севастьян	Савина	Аскольдовна	+77325224959	9149 717473	среднее	1629
Олег	Меркушева	\N	8 604 915 6218	6615 708315	высшее	1630
Леонид	Жданов	Кузьминична	8 851 375 5682	9850 805837	среднее	1631
Александра	Владимиров	\N	8 (442) 225-8549	4857 804392	\N	1632
Любосмысл	Воронов	\N	+7 (054) 665-39-41	1675 277964	среднее	1633
Никифор	Медведева	Валерианович	+79123830889	1553 293702	высшее	1634
Ферапонт	Копылова	\N	8 (343) 774-63-75	3035 246881	среднее профессиональное	1635
Гедеон	Гущина	\N	8 (902) 922-8459	3450 498281	\N	1636
Филимон	Рябов	Леонидовна	+7 221 042 8400	8528 492936	среднее	1637
Евгения	Шарапова	\N	+7 (027) 916-12-12	6343 309138	\N	1638
Владлен	Анисимова	\N	8 (812) 393-77-66	4781 577877	\N	1639
Максим	Ковалева	Кузьминична	8 (802) 400-64-54	6085 277962	среднее	1640
Савелий	Андреева	\N	+7 309 138 9065	9408 997316	\N	1641
Григорий	Афанасьев	Евстигнеевич	+7 (784) 072-33-39	7405 143292	среднее профессиональное	1642
Макар	Белов	\N	8 (857) 272-48-48	6438 470320	высшее	1643
Савватий	Мясникова	\N	8 664 236 8128	4000 675679	неоконченное высшее	1644
Нонна	Комиссарова	Дмитриевна	8 (957) 677-8182	1088 726692	неоконченное высшее	1645
Милий	Исакова	\N	+7 687 746 52 92	7049 858867	среднее профессиональное	1646
Елизар	Коновалов	\N	+7 208 133 81 10	8030 705389	среднее профессиональное	1647
Карп	Шашков	\N	+7 270 537 2509	7928 258766	среднее профессиональное	1648
Савелий	Виноградов	Филипповна	8 441 615 2837	7272 844510	среднее профессиональное	1649
Фока	Анисимова	Феоктистович	8 795 630 31 62	2710 459382	высшее	1650
Юлия	Кудрявцев	Федотович	8 738 422 4462	4710 401375	неоконченное высшее	1651
Роман	Андреев	\N	+7 667 192 3359	4642 291410	неоконченное высшее	1652
Кирилл	Беспалов	Харлампович	8 (851) 422-65-51	1411 165615	\N	1653
Ангелина	Белозерова	\N	+7 834 499 1877	2125 140951	неоконченное высшее	1654
Жанна	Яковлев	Рубеновна	+7 (331) 201-47-77	1493 853230	высшее	1655
Елена	Громова	\N	8 697 383 69 15	4803 129120	\N	1656
Каллистрат	Егорова	\N	+7 332 929 7766	1206 375360	среднее профессиональное	1657
Моисей	Носов	Арсенович	+7 619 798 70 20	1827 402176	\N	1658
Игнатий	Цветков	\N	8 (653) 152-8118	1685 716770	среднее	1659
Нонна	Кабанова	\N	+7 530 376 8670	2057 865229	неоконченное высшее	1660
Ефим	Миронова	\N	8 286 624 37 06	3585 657327	среднее	1661
Егор	Самсонова	\N	+7 (197) 901-31-72	7174 323143	среднее	1662
Исидор	Матвеев	Юльевна	8 907 929 44 44	9692 449190	среднее	1663
Савелий	Тимофеева	Леонидовна	+7 055 324 1133	7479 468023	высшее	1664
Дорофей	Зуев	Адрианович	81797955337	3612 121548	среднее	1665
Лонгин	Шилова	Анатольевна	89411575066	4233 954829	\N	1666
Ратмир	Вишняков	Чеславович	8 196 432 44 55	7892 224887	\N	1667
Наталья	Миронова	Тарасовна	+7 (905) 228-2891	3067 729227	неоконченное высшее	1668
Елизар	Григорьева	\N	+7 (695) 462-3135	9759 746297	неоконченное высшее	1669
Изот	Егоров	Гертрудович	+7 508 378 8369	2574 848925	\N	1670
Нестор	Уваров	Аверьянович	+7 (277) 961-61-80	3963 411493	среднее профессиональное	1671
Агап	Тимофеева	\N	+7 (635) 685-77-36	4804 289777	среднее профессиональное	1672
Мартьян	Веселова	Руслановна	84893215528	8729 581702	среднее	1673
Кир	Мамонтов	Харламович	+79649019843	1057 181592	среднее профессиональное	1674
Сигизмунд	Жукова	Никифоровна	8 476 302 6716	8029 201767	среднее	1675
Назар	Савельев	Яковлевич	+7 555 515 57 99	4651 884324	неоконченное высшее	1676
Эраст	Быкова	\N	+7 046 907 89 13	6344 407515	среднее	1677
София	Матвеев	\N	+7 787 609 0638	5750 901270	высшее	1678
Еремей	Князев	Фомич	+7 576 188 9115	7129 257439	среднее профессиональное	1679
Регина	Виноградова	\N	8 (719) 573-39-71	1011 367411	неоконченное высшее	1680
Ираклий	Белова	\N	+7 198 942 76 42	1351 895487	неоконченное высшее	1681
Ипполит	Турова	Захарьевич	+7 859 894 2333	6236 306660	\N	1682
Велимир	Лобанов	\N	83116917659	1053 995160	неоконченное высшее	1683
Ипполит	Белов	\N	+7 (135) 177-2801	7647 207038	высшее	1684
Изот	Чернова	Анатольевич	+7 430 164 3012	1468 153524	неоконченное высшее	1685
Милован	Петров	\N	+73637195078	8037 917911	высшее	1686
Амос	Логинов	Изотович	+7 249 054 1835	9436 392650	\N	1687
Поликарп	Жукова	\N	8 223 138 69 55	4970 826988	высшее	1688
Пимен	Исаева	Федотович	8 590 810 5320	4793 721027	\N	1689
Наум	Евсеева	Иосипович	+7 (542) 029-6626	6315 320308	среднее профессиональное	1690
Остап	Кузьмина	Григорьевич	+7 412 612 9305	2404 692159	среднее профессиональное	1691
Сидор	Казакова	Васильевич	+71754046019	9367 919674	среднее	1692
Анисим	Гордеева	\N	+7 770 677 30 75	4299 604633	среднее	1693
Конон	Красильникова	Викторовна	8 (619) 325-07-10	4529 247173	\N	1694
Конон	Власов	Харлампович	86566435309	9848 701933	среднее профессиональное	1695
Серафим	Осипова	Андреевич	8 (347) 668-57-94	9098 415331	среднее	1696
Никанор	Сорокин	\N	8 (979) 718-7601	6317 479744	среднее профессиональное	1697
Станимир	Тимофеева	Богдановна	8 823 233 4215	5168 556448	неоконченное высшее	1698
Савватий	Стрелкова	Тимурович	+7 (818) 714-77-24	2654 987333	высшее	1699
Эраст	Уваров	\N	+7 724 867 6056	8175 544182	неоконченное высшее	1700
Фадей	Шилова	Валериевна	8 899 781 7677	2453 691695	неоконченное высшее	1701
Орест	Быкова	Тихонович	+7 (716) 978-98-69	2480 728870	среднее	1702
Андрон	Комарова	\N	8 635 539 8991	8140 492908	неоконченное высшее	1703
Глеб	Анисимова	Гаврилович	+7 (017) 965-0976	7509 168854	\N	1704
Кондратий	Гущина	\N	8 (098) 457-38-22	3142 381367	\N	1705
Олимпий	Гущина	Абрамович	8 (648) 328-28-16	2672 339049	высшее	1706
Никанор	Игнатова	\N	8 (141) 039-38-71	1116 608986	среднее профессиональное	1707
Терентий	Симонов	Власович	8 144 732 4134	1475 893509	\N	1708
Автоном	Мамонтов	Гавриилович	8 (633) 324-4269	7398 338919	высшее	1709
Аристарх	Савин	Станиславовна	8 471 507 57 64	4710 557290	\N	1710
Фёкла	Суханова	\N	85834620572	1640 755751	среднее профессиональное	1711
Глафира	Якушев	\N	+7 (594) 786-7289	8719 590971	среднее	1712
Марфа	Горшков	\N	86703443444	3615 956817	среднее	1713
Иннокентий	Калинин	Бенедиктович	8 301 133 09 56	3381 829636	высшее	1714
Эрнст	Соловьева	\N	+76640067603	6808 581777	среднее	1715
Фортунат	Филиппов	Эдуардович	+7 511 721 7294	9596 590000	среднее	1716
Панфил	Алексеев	\N	+73580011976	9389 642478	высшее	1717
Елизавета	Назарова	Витальевич	+7 (299) 525-4341	4550 138515	\N	1718
Богдан	Громова	Архиповна	8 927 208 63 80	9327 582468	высшее	1719
Эдуард	Морозов	\N	+7 104 831 53 90	7447 261294	\N	1720
Святополк	Голубев	Тимурович	+7 (804) 551-35-08	8788 745373	среднее профессиональное	1721
Ипполит	Потапова	\N	8 533 705 52 56	5938 764345	среднее профессиональное	1722
Каллистрат	Орлов	Иларионович	+7 (899) 675-7079	7525 276368	среднее профессиональное	1723
Мариан	Лобанова	Артёмович	8 (653) 575-76-21	7725 155890	среднее профессиональное	1724
Зиновий	Федосеев	Богданович	8 022 418 1046	2536 671087	среднее	1725
Аполлинарий	Громова	Ефремович	+7 (285) 730-9935	9521 754558	среднее	1726
Борис	Савельева	Иосипович	+7 (787) 002-0611	7279 294786	среднее	1727
Терентий	Соболева	\N	8 (559) 240-7114	4822 145498	среднее профессиональное	1728
Елена	Кудрявцев	Фомич	8 316 173 32 75	4784 172413	высшее	1729
Викторин	Авдеев	\N	8 (828) 703-3622	2868 618682	высшее	1730
Зинаида	Мухин	Фомич	8 (865) 870-54-72	5518 921164	неоконченное высшее	1731
Марфа	Князева	Афанасьевич	8 (209) 957-9529	3997 939769	среднее профессиональное	1732
Устин	Самойлова	\N	8 928 275 42 83	8916 322692	высшее	1733
Борис	Федотова	\N	+7 (923) 578-9988	4000 110075	высшее	1734
Тимофей	Захаров	Елизарович	8 018 072 6279	8142 350557	среднее	1735
Доброслав	Анисимов	\N	8 360 156 03 30	7022 462622	\N	1736
Ульяна	Меркушев	\N	89232421618	1275 795060	среднее профессиональное	1737
Анжелика	Никифоров	\N	+7 (512) 867-7378	8115 212043	высшее	1738
Артемий	Зимин	\N	8 038 339 62 48	5647 945537	высшее	1739
Ульян	Кулаков	\N	8 315 877 82 88	4217 319257	высшее	1740
Ярополк	Третьякова	Борисович	8 (178) 661-70-33	4703 954387	среднее профессиональное	1741
Андроник	Брагин	Трофимович	+72107374255	6123 619100	среднее	1742
Олег	Кононова	Александрович	+73075562811	6179 849616	среднее	1743
Галина	Гуляева	Валентиновна	8 (164) 370-2846	5738 413512	неоконченное высшее	1744
Варвара	Якушев	\N	81595175010	3905 331448	высшее	1745
Лев	Артемьев	\N	+75282458711	6906 835927	неоконченное высшее	1746
Станимир	Куликова	Аксёнович	+75246689523	5922 444234	среднее	1747
Анатолий	Силина	Григорьевич	8 067 084 1472	9382 505892	среднее	1748
Богдан	Комиссаров	Гурьевич	+7 (137) 995-8733	1617 872653	среднее профессиональное	1749
Самуил	Зуева	Федосьевич	8 333 071 55 63	1636 572998	среднее профессиональное	1750
Амвросий	Потапова	Денисович	+74175271421	2065 977735	среднее профессиональное	1751
Егор	Логинова	Ивановна	+7 (299) 504-4048	9361 632551	среднее профессиональное	1752
Лора	Назарова	\N	+7 (690) 908-1176	8603 623837	среднее профессиональное	1753
Всемил	Быков	\N	8 595 431 7491	7605 754669	среднее	1754
Ян	Орлова	\N	8 212 887 2771	8212 254540	среднее профессиональное	1755
Исай	Федотова	Фомич	8 (960) 964-0785	1765 398720	неоконченное высшее	1756
Яков	Молчанова	Тихонович	8 099 514 6532	2434 900872	среднее	1757
Виктор	Моисеев	Игоревич	+7 (506) 467-49-16	4924 375628	среднее профессиональное	1758
Тимур	Карпов	Григорьевна	8 (980) 376-7817	7103 116076	неоконченное высшее	1759
Любомир	Колесникова	\N	+7 (350) 744-99-34	2473 503724	неоконченное высшее	1760
Демид	Кириллов	Егорович	+7 820 444 0104	5187 714320	неоконченное высшее	1761
Никифор	Артемьев	Макаровна	+7 (295) 451-53-89	9383 740939	неоконченное высшее	1762
Станимир	Федорова	Гурьевич	8 (189) 804-32-97	1239 692277	высшее	1763
Панфил	Громов	\N	8 (718) 082-23-22	4124 930266	среднее	1764
Эрнст	Зыкова	\N	+72356176768	9862 745369	среднее профессиональное	1765
Иларион	Гусева	\N	8 650 787 3262	2407 219363	высшее	1766
Касьян	Буров	Феликсович	+7 (616) 743-95-53	6499 332884	\N	1767
Панфил	Копылова	Оскаровна	+71585749890	7828 817178	неоконченное высшее	1768
Александр	Назаров	Григорьевна	+7 482 159 6208	6985 753983	\N	1769
Герман	Крюкова	\N	+7 (248) 806-2303	7294 396133	неоконченное высшее	1770
Сидор	Алексеев	Семеновна	8 728 581 87 98	9821 809353	\N	1771
Капитон	Данилова	Владимировна	+7 (285) 846-5360	8475 980840	высшее	1772
Амос	Емельянова	\N	8 130 445 3104	4989 342350	среднее профессиональное	1773
Милен	Захаров	\N	8 082 333 9549	5952 590013	неоконченное высшее	1774
Сигизмунд	Котов	\N	+7 029 053 14 62	6533 716474	\N	1775
Трифон	Петухов	\N	8 067 542 9599	7526 204074	неоконченное высшее	1776
Синклитикия	Наумов	\N	8 (431) 579-14-33	5313 219789	среднее профессиональное	1777
Зосима	Виноградова	\N	8 518 901 67 00	6450 144037	среднее	1778
Виктория	Пономарева	Львовна	+7 (037) 062-3347	9876 714554	среднее профессиональное	1779
Элеонора	Горшков	Евгеньевна	8 674 984 76 57	5708 861701	\N	1780
Каллистрат	Давыдов	\N	+7 (311) 628-3148	4885 350316	\N	1781
Всеслав	Воронцова	\N	+7 (195) 571-87-03	3210 838871	среднее профессиональное	1782
Сигизмунд	Щукин	\N	+70187994803	8729 196112	неоконченное высшее	1783
Сократ	Сысоева	\N	83740946393	6805 180681	среднее профессиональное	1784
Захар	Колесников	\N	+7 102 223 4284	7261 995976	среднее профессиональное	1785
Дмитрий	Шашкова	Ефремович	+7 345 288 95 17	4413 976312	\N	1786
Соломон	Авдеев	Феликсовна	8 014 603 6585	5622 339092	среднее	1787
Ираида	Нестерова	\N	+7 (028) 568-9773	4403 262664	\N	1788
Сидор	Шарова	Фокич	8 (782) 562-8256	5181 971265	среднее профессиональное	1789
Федот	Русакова	\N	8 876 862 2405	2720 349366	неоконченное высшее	1790
Евдоким	Родионова	Власович	8 217 763 5183	3705 265771	неоконченное высшее	1791
Радислав	Мишина	\N	+7 341 983 68 48	3174 365790	неоконченное высшее	1792
Аггей	Калашников	\N	+7 (597) 465-18-56	4512 877581	среднее	1793
Севастьян	Колесников	\N	+7 679 304 2842	1748 661968	высшее	1794
Ювеналий	Самсонов	\N	8 608 567 5021	7341 392333	среднее	1795
Фока	Зайцев	Тихонович	8 (969) 759-18-67	9693 928649	неоконченное высшее	1796
Агап	Доронина	Егорович	+7 (515) 575-24-18	7147 269962	среднее	1797
Савелий	Григорьева	\N	+7 798 618 1183	7510 376080	среднее профессиональное	1798
Захар	Васильева	\N	8 912 954 44 15	2074 288911	высшее	1799
Онуфрий	Бурова	Владимировна	+7 (309) 550-5049	3489 298791	среднее профессиональное	1800
Юлиан	Авдеев	\N	8 (045) 779-24-35	4954 912990	\N	1801
Тит	Савельева	Афанасьевич	89398994851	3635 572584	высшее	1802
Кузьма	Федосеева	\N	8 620 541 58 03	3220 911737	неоконченное высшее	1803
Епифан	Бирюкова	Германович	+7 (793) 301-63-87	2476 562656	\N	1804
Наум	Одинцова	\N	8 (014) 281-4971	1652 403619	среднее профессиональное	1805
Людмила	Комиссарова	Игоревна	+7 (650) 850-77-90	6609 625197	неоконченное высшее	1806
Анжела	Шаров	Филимонович	+7 (177) 622-24-57	9098 236827	неоконченное высшее	1807
Нинель	Евсеев	\N	8 360 490 41 50	4971 105824	среднее	1808
Юрий	Харитонов	Иларионович	+73218937525	7906 964711	\N	1809
Кира	Уваров	\N	8 189 722 34 41	3737 741917	высшее	1810
Порфирий	Кузьмин	Мироновна	8 (583) 922-66-82	5881 165337	\N	1811
Афанасий	Степанова	Геннадьевна	+71645658320	6169 798201	неоконченное высшее	1812
Евгений	Осипова	Юльевна	+7 494 120 56 23	4855 728850	неоконченное высшее	1813
Пахом	Медведев	Артемьевич	83542684047	5882 627146	среднее профессиональное	1814
Радислав	Шубин	\N	+7 (378) 526-93-58	2712 867235	среднее	1815
Дементий	Андреева	\N	+7 (043) 126-7647	8959 293743	среднее	1816
Поликарп	Ефимов	\N	8 (123) 309-9536	7512 566607	среднее	1817
Денис	Наумов	Вячеславовна	85903221507	1148 660321	среднее профессиональное	1818
Добромысл	Журавлев	Владиленович	8 105 638 78 16	3071 970887	\N	1819
Виктор	Осипов	Артемовна	86593967535	2873 663306	среднее	1820
Ипат	Денисов	Борисовна	+75724749224	9529 113217	среднее	1821
Аскольд	Гурьев	Валерианович	+7 369 144 3830	4814 842405	неоконченное высшее	1822
Самуил	Кондратьев	\N	+7 785 419 0333	3688 205420	неоконченное высшее	1823
Исай	Марков	\N	+75425598438	5707 912187	неоконченное высшее	1824
Адриан	Голубева	Аркадьевна	8 (840) 821-3837	6692 616976	среднее	1825
Валерия	Кондратьев	Натановна	+7 (516) 629-86-48	4174 252543	неоконченное высшее	1826
Дорофей	Федотова	\N	8 (951) 646-19-28	8781 200191	среднее профессиональное	1827
Януарий	Шарова	Аскольдовна	+71548059152	4184 101854	высшее	1828
Назар	Ефимов	Егорович	+7 (834) 214-12-52	4779 944596	высшее	1829
Изот	Антонова	Мироновна	8 197 309 0153	1711 654545	среднее профессиональное	1830
Максимильян	Константинова	\N	+7 932 717 8839	2648 805011	\N	1831
Рубен	Орлова	\N	+7 100 058 8142	9530 209703	среднее	1832
Арефий	Мельников	\N	87460202076	5539 698115	\N	1833
Моисей	Мельников	Игнатович	+75418820227	7455 438814	неоконченное высшее	1834
Фрол	Королева	Трофимович	8 (116) 195-36-61	4814 662509	\N	1835
Борислав	Третьяков	\N	8 008 498 4416	5226 360213	среднее профессиональное	1836
Петр	Стрелкова	\N	8 390 301 55 09	6452 741223	неоконченное высшее	1837
Радован	Кондратьев	\N	8 (484) 956-9640	6800 430200	\N	1838
Денис	Корнилов	Юльевич	+7 988 218 4191	2661 237828	\N	1839
Филарет	Громов	Матвеевна	8 (443) 907-68-74	4275 352649	неоконченное высшее	1840
Ульян	Устинова	Арсеньевич	+7 (493) 611-8537	9208 938880	неоконченное высшее	1841
Гаврила	Субботин	Эдуардовна	8 455 396 5048	2218 307923	среднее	1842
Сильвестр	Дорофеева	\N	8 076 150 24 61	2504 537921	среднее профессиональное	1843
Архип	Денисова	\N	+7 (165) 751-43-70	6958 607378	среднее	1844
Светлана	Давыдов	\N	8 390 913 9691	5825 278483	среднее	1845
Дорофей	Трофимов	Васильевич	8 353 399 5445	2469 124298	\N	1846
Никодим	Котова	\N	+7 (043) 572-79-95	5733 893525	\N	1847
Ананий	Николаев	\N	8 486 655 2030	2025 714918	неоконченное высшее	1848
Азарий	Блохина	Трифонович	+7 (752) 399-8236	8403 340280	высшее	1849
Борис	Дьячков	Ильясович	+7 (336) 100-65-19	7179 953878	среднее профессиональное	1850
Агата	Новиков	\N	8 (975) 582-79-53	1918 762700	среднее	1851
Лука	Осипова	\N	+7 789 509 81 64	3618 403104	среднее профессиональное	1852
Федот	Харитонов	\N	+7 232 614 6947	9428 909177	высшее	1853
Иван	Виноградова	Герасимович	84504117142	4201 156320	среднее	1854
Павел	Шашков	Геннадиевна	+7 469 965 0706	5646 861109	\N	1855
Эмилия	Жуков	Васильевна	+7 365 364 06 52	8888 873813	неоконченное высшее	1856
Игорь	Воронова	\N	8 (263) 117-3709	7629 906005	\N	1857
Наина	Орехова	Филиппович	+7 (235) 611-31-12	8574 570208	\N	1858
Ярополк	Гурьев	Ефремович	+7 (495) 741-37-42	5635 906918	неоконченное высшее	1859
Селиван	Мамонтова	\N	8 449 920 4027	1107 951316	\N	1860
Тимур	Сидоров	Бенедиктович	+7 677 399 1852	6098 732852	среднее профессиональное	1861
Сильвестр	Герасимов	\N	8 (062) 659-39-34	5202 354044	среднее профессиональное	1862
Мирон	Лапина	Константиновна	+7 663 616 60 56	5746 526018	\N	1863
Савва	Ширяева	Егорович	+7 410 491 60 63	5127 570854	\N	1864
Ярослав	Некрасов	\N	+7 (486) 892-1569	8873 849234	высшее	1865
Ефрем	Чернов	Анисимович	+79995475511	4457 492806	высшее	1866
Олимпиада	Лебедев	\N	+7 (244) 022-03-90	2513 162323	\N	1867
Добромысл	Наумов	Ефстафьевич	+7 (760) 067-54-48	6071 977271	\N	1868
Ким	Крылова	\N	+7 (537) 913-41-51	2626 322026	неоконченное высшее	1869
Агафья	Воронцов	Чеславович	8 (944) 932-6648	5344 385461	неоконченное высшее	1870
Изяслав	Попова	Егоровна	+7 593 322 15 46	8810 923384	неоконченное высшее	1871
Архип	Устинова	Артурович	8 (510) 930-6871	5053 148051	среднее	1872
Милица	Кондратьев	Брониславович	8 116 065 44 47	1478 996816	среднее профессиональное	1873
Иннокентий	Лапина	\N	8 037 106 28 88	6015 672516	среднее	1874
Иван	Кулаков	\N	+7 265 457 93 73	3483 411003	среднее	1875
Исидор	Жукова	\N	8 (038) 222-51-54	6170 455687	среднее	1876
Любим	Новиков	Романовна	+7 (991) 635-4185	5775 380262	среднее профессиональное	1877
Рубен	Тетерин	Олеговна	8 (215) 607-11-74	7047 943626	\N	1878
Милица	Степанова	Львовна	+7 616 240 4310	2083 418939	среднее профессиональное	1879
Аким	Русакова	\N	+7 (138) 590-39-79	3200 311661	\N	1880
Максимильян	Владимиров	Елизарович	8 (496) 352-63-57	9886 887526	среднее профессиональное	1881
Сократ	Захарова	Вилорович	8 965 035 11 56	5229 915701	среднее	1882
Семен	Степанова	Иосипович	82492334318	5989 188798	\N	1883
Феофан	Сергеева	Эдуардович	8 822 601 3030	4131 215004	высшее	1884
Амос	Овчинников	\N	8 (357) 298-98-21	2807 651662	\N	1885
Тимофей	Лобанов	Матвеевна	+7 (628) 935-1360	4418 552239	высшее	1886
Ксения	Соколова	Фомич	+7 716 505 15 39	9701 396154	среднее	1887
Фаина	Зиновьева	\N	+7 (790) 098-8554	9937 547326	высшее	1888
Любомир	Николаева	Дмитриевна	+7 (889) 755-35-12	9781 866544	неоконченное высшее	1889
Анжелика	Стрелкова	\N	84431835061	9366 918412	высшее	1890
Аскольд	Зуева	Димитриевич	8 (659) 959-3636	9065 647548	среднее профессиональное	1891
Сидор	Горбунова	Бориславович	+7 (332) 835-32-12	3389 270809	\N	1892
Святослав	Лукин	\N	81715796080	2131 691392	среднее профессиональное	1893
Марфа	Капустина	\N	+7 883 116 11 68	7166 461120	высшее	1894
Галактион	Мясников	\N	+7 950 469 2273	3670 395281	\N	1895
Ксения	Быков	Валентинович	8 (577) 055-1541	8959 617689	\N	1896
Мир	Лапин	Виленович	+7 (073) 901-18-94	6668 902047	среднее профессиональное	1897
Любомир	Пестова	Анисимович	+7 (246) 131-6540	8330 640436	неоконченное высшее	1898
Владлен	Мельникова	\N	+7 189 869 5370	8088 130271	среднее профессиональное	1899
Антип	Давыдова	\N	8 283 731 3490	6647 482058	высшее	1900
Кира	Тарасова	Абрамович	8 (433) 652-1869	1969 238276	среднее профессиональное	1901
Денис	Стрелкова	Афанасьевна	8 261 439 5401	6728 573910	среднее профессиональное	1902
Леонтий	Ершов	\N	85795207440	6842 464225	среднее	1903
Савва	Емельянова	Васильевич	8 (900) 821-85-05	6321 220035	неоконченное высшее	1904
Осип	Фролова	\N	89186489980	6385 424793	\N	1905
Мартын	Крюкова	\N	8 532 233 91 23	7115 478200	высшее	1906
Эмиль	Молчанова	\N	8 (756) 706-0742	8185 265172	\N	1907
Октябрина	Соболев	Фролович	8 355 080 6053	9964 617746	высшее	1908
Бажен	Мельников	Захаровна	8 038 370 99 97	5816 729635	среднее	1909
Чеслав	Захарова	\N	8 049 101 38 78	6806 315049	\N	1910
Никита	Королев	\N	84121516774	5436 692102	высшее	1911
Мефодий	Носкова	\N	+7 765 768 47 65	4745 779786	неоконченное высшее	1912
Елизар	Турова	\N	+72782062058	9218 351747	неоконченное высшее	1913
Глеб	Третьякова	\N	+7 (897) 558-99-34	8809 805113	\N	1914
Евгения	Петухов	\N	+76991581562	5363 789627	высшее	1915
Чеслав	Устинов	Харламович	+7 (836) 510-82-23	7810 221534	неоконченное высшее	1916
Куприян	Калашников	\N	+7 (270) 030-21-80	5302 269835	среднее	1917
Тимофей	Ковалев	\N	+7 637 020 0673	1583 418537	среднее	1918
Дорофей	Корнилов	Афанасьевна	8 (497) 236-4603	2431 422442	\N	1919
Лука	Архипова	Рудольфовна	+7 241 261 5582	4991 815048	высшее	1920
Лора	Силина	\N	+7 837 095 8653	8428 121847	среднее	1921
Иннокентий	Кошелев	Геннадьевна	+7 (235) 360-6149	2134 750972	среднее	1922
Ладислав	Носков	\N	82088924668	8634 379568	высшее	1923
Милан	Медведева	\N	8 744 337 29 43	8795 629761	неоконченное высшее	1924
Любомир	Игнатова	\N	8 398 037 85 23	3620 128125	высшее	1925
Синклитикия	Ершова	\N	+7 994 911 0769	9773 979751	среднее	1926
Поликарп	Некрасов	Жанович	8 (238) 181-55-23	4108 846137	высшее	1927
Епифан	Попов	\N	89449070260	5974 327215	среднее профессиональное	1928
Агафья	Логинова	\N	8 (102) 570-9976	2677 875247	неоконченное высшее	1929
Любовь	Галкин	Борисович	+7 (359) 716-9046	1259 268932	\N	1930
Кирилл	Борисова	Еремеевич	+77642490780	4795 984074	неоконченное высшее	1931
Любим	Захарова	Арсенович	+7 310 154 3245	1629 166272	неоконченное высшее	1932
Ангелина	Виноградов	\N	+7 709 626 06 16	6985 610079	среднее	1933
Вадим	Кулаков	Августович	+72427217297	2383 593437	\N	1934
Станимир	Кулакова	Петровна	8 (272) 705-71-50	2524 857313	высшее	1935
Венедикт	Никитин	Вячеславович	8 803 089 32 12	9972 822701	среднее	1936
Аким	Боброва	Филатович	8 864 367 9509	7852 289023	\N	1937
Измаил	Симонова	Федотович	8 340 047 0299	3575 865844	среднее профессиональное	1938
Панфил	Князева	\N	88348113752	4888 675263	неоконченное высшее	1939
Никон	Гурьева	\N	8 (382) 158-01-08	4798 275502	неоконченное высшее	1940
Радим	Борисова	Трифонович	8 (720) 566-13-87	5663 904740	среднее	1941
Павел	Морозова	Ждановна	+7 749 601 85 40	7240 763701	среднее	1942
Фёкла	Пахомов	Кирилловна	+7 091 603 77 88	3633 658723	высшее	1943
Ерофей	Дмитриев	\N	+7 275 847 01 30	7652 322328	среднее	1944
Лидия	Сергеева	Оскаровна	8 929 599 53 17	4164 960389	неоконченное высшее	1945
Амос	Красильникова	Юльевич	8 143 432 55 46	8343 782581	среднее	1946
Милан	Ершова	Евстигнеевич	8 (200) 002-7504	4765 732742	высшее	1947
Никон	Юдина	Евгеньевна	83900664176	6195 276644	высшее	1948
Ростислав	Сазонов	Ануфриевич	8 366 716 92 78	9889 383123	высшее	1949
Иосиф	Гущина	\N	8 841 195 97 61	8530 503093	среднее профессиональное	1950
Ян	Веселова	Валерьевич	88035364117	5051 762741	среднее профессиональное	1951
Ферапонт	Иванова	Валерианович	+7 053 152 3597	8311 497608	неоконченное высшее	1952
Платон	Селиверстова	Эдуардовна	+7 802 763 10 12	5071 295985	\N	1953
Флорентин	Бобылева	Егоровна	8 440 589 37 94	3303 128437	\N	1954
Эммануил	Иванов	\N	8 948 953 78 41	8511 977220	среднее профессиональное	1955
Константин	Казакова	Дмитриевич	+7 461 826 5502	5357 293234	высшее	1956
Владимир	Дмитриев	Петровна	8 312 387 23 73	6143 933961	среднее профессиональное	1957
Олимпий	Кузьмина	\N	+7 280 981 1114	5308 992056	\N	1958
Капитон	Кошелева	Степановна	+7 586 706 3847	4622 753135	неоконченное высшее	1959
Велимир	Власов	Викторовна	8 214 024 0092	5137 473812	среднее профессиональное	1960
Венедикт	Романов	Демидович	8 (260) 211-9653	1025 150509	неоконченное высшее	1961
Владимир	Сысоев	Тимуровна	8 (021) 824-04-42	7499 868484	неоконченное высшее	1962
Галина	Фролова	Иосифович	+7 051 925 9899	8282 730159	высшее	1963
Харлампий	Костин	Герасимович	+70889132821	5579 253295	среднее	1964
Мир	Гришина	Димитриевич	8 660 712 26 31	5523 404356	высшее	1965
Велимир	Лобанов	\N	8 590 951 86 08	8766 581394	\N	1966
Евпраксия	Носков	\N	+7 571 769 36 84	3498 699906	\N	1967
Измаил	Рыбакова	Всеволодович	+7 (050) 924-92-63	9902 190457	среднее профессиональное	1968
Боян	Котова	\N	8 575 497 4860	1732 242328	среднее	1969
Гедеон	Бобылева	Витальевич	+7 (685) 756-02-63	8722 466242	высшее	1970
Модест	Николаев	Аскольдовна	+7 (686) 017-18-93	2955 267309	высшее	1971
Харитон	Гаврилов	\N	8 (887) 108-7887	6191 462788	высшее	1972
Василий	Сергеев	\N	+78473137918	6420 142206	неоконченное высшее	1973
Зосима	Воробьев	\N	8 707 580 2767	8115 700831	среднее профессиональное	1974
Ипатий	Якушева	Борисовна	+7 853 372 53 15	8757 190454	высшее	1975
Автоном	Некрасова	Игоревна	+77882976809	9207 680413	среднее профессиональное	1976
Гремислав	Григорьева	\N	+7 663 878 4867	5401 704397	высшее	1977
Клавдия	Колобова	\N	+7 (222) 451-0700	2767 398621	неоконченное высшее	1978
Всемил	Николаева	\N	+7 822 227 6386	3146 623796	среднее профессиональное	1979
Глафира	Чернов	\N	+7 984 132 7472	5664 598599	среднее	1980
Спиридон	Князева	\N	8 (802) 865-3490	8582 200814	неоконченное высшее	1981
Лучезар	Белозеров	\N	89200575126	9447 736822	среднее	1982
Антип	Кабанов	Петровна	+7 952 232 7776	7098 378536	высшее	1983
Ангелина	Ширяев	Тихонович	8 636 574 87 30	3837 280207	неоконченное высшее	1984
Аполлон	Богданов	Ильич	8 (471) 776-32-86	2516 490467	высшее	1985
Светлана	Матвеева	\N	8 170 870 27 45	6193 449233	неоконченное высшее	1986
Остап	Громова	Харитоновна	8 007 311 94 01	5777 239344	среднее	1987
Сидор	Виноградов	\N	8 (065) 151-80-38	2867 853564	неоконченное высшее	1988
Арсений	Соколов	\N	8 223 237 0011	6676 787524	неоконченное высшее	1989
Нонна	Артемьева	\N	8 406 859 9965	3986 830965	высшее	1990
Ерофей	Карпов	\N	+7 (577) 735-7509	1866 400134	среднее профессиональное	1991
Анисим	Назарова	Богдановна	+7 517 417 28 61	5239 234420	\N	1992
Юлия	Макаров	\N	8 750 329 0630	5756 866674	среднее	1993
Куприян	Буров	\N	+7 055 860 41 39	2696 416757	среднее профессиональное	1994
Тимофей	Исаев	Валерьевич	+7 122 432 2362	6347 455858	среднее профессиональное	1995
Стоян	Селиверстов	Анисимович	8 (377) 346-6321	5688 373476	неоконченное высшее	1996
Евсей	Куликов	Фролович	+75817141758	1414 147374	среднее	1997
Соломон	Воробьева	Валерианович	8 435 485 6214	8050 852509	высшее	1998
Савватий	Субботин	Чеславович	+7 (667) 008-50-02	5458 981726	неоконченное высшее	1999
Фирс	Владимиров	Николаевна	+76346327402	6173 803183	неоконченное высшее	2000
Вячеслав	Лаврентьев	\N	8 (545) 357-0060	6204 533328	среднее профессиональное	2001
Ираида	Мартынова	Чеславович	+7 614 105 02 54	3137 151767	\N	2002
Зинаида	Бобылева	Устинович	8 (797) 358-28-00	1140 590262	высшее	2003
Гремислав	Козлова	\N	+7 707 611 4754	8947 900441	среднее профессиональное	2004
Якуб	Дементьева	Феликсович	8 057 741 57 42	5592 294603	высшее	2005
Тимур	Корнилова	\N	8 (986) 426-6771	6604 846023	среднее	2006
Ярополк	Красильникова	Аксёнович	+7 (543) 175-6935	2889 945580	среднее профессиональное	2007
Дементий	Князева	Ефимовна	8 821 036 6295	7478 570583	\N	2008
Измаил	Комаров	\N	+77045666709	8425 212186	\N	2009
Евдокия	Лебедев	Исидорович	8 695 931 2343	5033 118108	среднее	2010
Агафон	Аксенова	Дмитриевич	8 (851) 860-06-49	7684 988132	неоконченное высшее	2011
Пров	Потапов	Елизарович	+7 (891) 014-5135	5837 672974	среднее	2012
Бажен	Ильин	\N	8 (914) 016-23-27	2702 496920	среднее профессиональное	2013
Гаврила	Игнатьев	Трифонович	8 326 982 6985	2679 461982	высшее	2014
Ираида	Рогова	Болеславовна	+7 785 985 4373	9783 491070	высшее	2015
Порфирий	Елисеев	Эльдаровна	+7 (062) 995-3698	4661 104788	неоконченное высшее	2016
Богдан	Панова	\N	8 (299) 674-4458	3875 804499	высшее	2017
Евдоким	Петров	Евгеньевна	8 (346) 863-2053	5173 200385	среднее	2018
Надежда	Сазонов	\N	8 350 518 60 57	1042 352529	высшее	2019
Аверкий	Моисеев	\N	+7 268 594 8272	3147 976902	среднее профессиональное	2020
Агафья	Казакова	\N	8 (958) 766-64-77	3489 924277	среднее профессиональное	2021
Ефим	Романов	Елисеевич	8 (134) 026-4116	3185 244095	среднее	2022
Вадим	Павлова	\N	8 (827) 455-6616	7706 828024	среднее профессиональное	2023
Серафим	Филиппова	\N	+7 (892) 297-23-61	9773 742885	\N	2024
Панфил	Ковалев	\N	+7 008 737 4511	5058 767368	высшее	2025
Захар	Игнатов	Геннадиевич	8 565 090 0005	3352 173168	неоконченное высшее	2026
Агафья	Гордеева	\N	+7 446 434 3794	6658 480614	\N	2027
Ипатий	Рябов	\N	+78090907724	9115 149490	среднее профессиональное	2028
Анастасия	Самойлов	Филиппович	8 (642) 359-6043	5936 294601	\N	2029
Мефодий	Беляева	\N	81954463683	2009 365920	среднее профессиональное	2030
Никифор	Кузьмина	Адрианович	8 (537) 090-9529	3138 250809	неоконченное высшее	2031
Юлий	Рябова	\N	8 684 933 82 00	8859 724125	неоконченное высшее	2032
Гордей	Селиверстов	Валентинович	+7 (749) 505-89-76	8778 299032	неоконченное высшее	2033
Станислав	Ситникова	\N	+7 505 975 9905	6752 155699	высшее	2034
Олег	Князев	\N	8 593 653 56 55	1247 315921	среднее профессиональное	2035
Авдей	Никифоров	Валериевна	+7 534 845 3943	7032 351801	\N	2036
Феофан	Горбунова	Артемовна	8 764 392 44 03	2968 733141	среднее профессиональное	2037
Феофан	Петров	Феоктистович	8 778 588 6686	5526 746748	высшее	2038
Василий	Исаев	Даниилович	8 (386) 025-68-49	9519 626382	среднее	2039
Фотий	Суханова	Артемовна	+7 (334) 451-0594	7921 345637	высшее	2040
Борис	Осипов	Романовна	+7 (718) 352-8674	6557 844656	среднее профессиональное	2041
Алексей	Никонова	\N	+7 (598) 063-08-75	4973 796782	\N	2042
Глеб	Романова	\N	82431900856	5796 759036	среднее	2043
Назар	Елисеев	Димитриевич	8 820 412 60 74	3062 107065	\N	2044
Гаврила	Кулаков	\N	+7 034 323 3345	7209 698440	высшее	2045
Аверкий	Потапова	Никифоровна	8 150 322 8192	1208 515720	среднее профессиональное	2046
Мокей	Ершова	\N	8 025 634 4033	6135 868053	высшее	2047
Архип	Александрова	\N	+76520205807	5862 650563	неоконченное высшее	2048
Зоя	Елисеева	Геннадиевич	+7 581 564 8964	4420 418939	среднее	2049
Нестор	Исакова	Кирилловна	8 (201) 913-16-40	8634 561738	среднее	2050
Радован	Брагина	Ивановна	8 324 250 26 74	4723 279099	неоконченное высшее	2051
Изяслав	Зыкова	\N	85007556591	2315 406353	неоконченное высшее	2052
Мартын	Бобылева	\N	8 649 125 64 82	5893 602980	среднее	2053
Гурий	Никонова	Эдуардович	8 (117) 285-4897	8202 211703	неоконченное высшее	2054
Осип	Мухина	\N	8 (816) 243-8847	8315 868640	среднее	2055
Михей	Дроздов	Бориславович	8 708 623 11 61	1825 274611	высшее	2056
Агата	Доронина	\N	83088271836	9085 467248	среднее	2057
Василий	Васильев	Рудольфовна	+7 (495) 530-2146	2060 992439	неоконченное высшее	2058
Евграф	Шашков	Мироновна	8 (237) 621-1519	8113 503745	среднее	2059
Евдоким	Бирюков	\N	8 (562) 464-15-53	9595 220513	среднее	2060
Эраст	Миронов	\N	+7 (924) 283-6841	8430 694130	высшее	2061
Октябрина	Жданов	\N	+77542125648	4807 614306	высшее	2062
Пахом	Степанов	\N	+72041472002	4536 483538	\N	2063
Селиверст	Гаврилова	Болеславовна	+7 (084) 570-2132	5785 355681	высшее	2064
Остап	Романова	\N	8 396 340 2805	2923 423349	среднее профессиональное	2065
Фортунат	Овчинников	\N	84578981192	3079 936697	среднее	2066
Лучезар	Михеев	\N	+7 293 440 0969	2359 609306	среднее	2067
Аникей	Ермакова	\N	8 155 433 21 33	1097 616790	среднее	2068
Фрол	Зайцев	Ивановна	8 (188) 193-38-58	3829 292034	неоконченное высшее	2069
Евфросиния	Ильина	\N	8 (982) 928-8726	2591 996138	неоконченное высшее	2070
Лев	Козлов	\N	8 716 286 1115	9096 874080	среднее	2071
Евгения	Александров	\N	8 700 755 8732	4596 668834	среднее	2072
Сергей	Попова	\N	+7 094 151 2028	4000 182401	среднее профессиональное	2073
Боян	Королев	\N	+7 680 701 03 04	9071 193750	\N	2074
Леонид	Королева	Елисеевич	+7 393 068 8177	3001 804628	неоконченное высшее	2075
Данила	Елисеева	Робертовна	8 410 899 07 76	7584 861725	\N	2076
Аркадий	Виноградова	Викторович	+7 702 502 95 09	3358 720231	среднее	2077
Данила	Гурьева	Бенедиктович	+7 954 435 79 56	4524 720959	неоконченное высшее	2078
Ипполит	Лобанов	\N	8 (008) 739-0783	8410 823966	\N	2079
Климент	Князева	\N	8 (347) 893-93-96	2597 786287	высшее	2080
Трифон	Галкин	\N	+7 329 069 7886	7111 500086	неоконченное высшее	2081
Моисей	Ковалева	Федотович	89403219643	3244 198738	среднее профессиональное	2082
Мина	Моисеев	\N	8 156 956 64 91	6130 193992	высшее	2083
Евстафий	Терентьева	Андреевна	+73226443006	2018 861175	неоконченное высшее	2084
Парфен	Мамонтова	Артемьевич	8 314 089 46 78	2516 291973	\N	2085
Яков	Соболев	\N	+7 542 311 21 85	9510 593299	среднее профессиональное	2086
Фадей	Петухов	\N	+73186047699	9500 873055	неоконченное высшее	2087
Селиверст	Пахомова	\N	8 (614) 541-65-74	5688 125998	среднее профессиональное	2088
Модест	Крылов	\N	+7 (652) 772-9297	3025 557520	среднее профессиональное	2089
Станислав	Туров	\N	8 010 446 9930	9352 219249	среднее профессиональное	2090
Данила	Суханов	Захарьевич	+78713986520	7115 326269	среднее	2091
Валентин	Юдина	\N	80540132819	4005 309024	\N	2092
Юлий	Лапина	Даниловна	+7 236 615 32 11	8300 664913	высшее	2093
Таисия	Буров	\N	+7 (985) 706-0952	4920 344359	среднее профессиональное	2094
Олег	Некрасова	\N	8 289 974 02 25	5693 925031	высшее	2095
Николай	Кулаков	\N	+7 885 906 6680	4846 551875	неоконченное высшее	2096
Куприян	Назаров	Кузьминична	8 (503) 681-6980	5442 175097	среднее	2097
Сильвестр	Зиновьева	\N	+7 (744) 112-0889	5253 454780	\N	2098
Потап	Поляков	\N	+7 690 043 04 03	7512 968358	высшее	2099
Никанор	Горшков	Захаровна	+7 (199) 685-3460	9815 659405	неоконченное высшее	2100
Ладимир	Харитонова	Владиленович	8 (477) 331-38-53	8225 714566	неоконченное высшее	2101
Аверкий	Тетерин	Константиновна	+7 638 247 38 27	6882 867003	неоконченное высшее	2102
Иван	Нестеров	\N	8 416 892 2497	1989 984808	среднее профессиональное	2103
Виктор	Смирнов	Измаилович	+79785887162	4492 990854	среднее	2104
Мина	Бобылева	Антонович	+7 481 216 0965	3341 220962	\N	2105
Арсений	Сазонова	Трофимович	+7 773 524 3947	6701 462252	неоконченное высшее	2106
Трофим	Зайцев	Иосифович	8 933 683 6470	7581 811192	неоконченное высшее	2107
Марфа	Морозов	\N	+73659422197	4761 292452	высшее	2108
Ксения	Муравьева	\N	+7 (015) 581-22-31	1490 150571	среднее профессиональное	2109
Софон	Шубин	Бориславович	8 506 574 19 56	9265 288011	высшее	2110
Глеб	Турова	Антонович	8 (410) 619-5865	9131 823037	среднее профессиональное	2111
Артем	Лебедев	\N	8 774 121 06 69	4515 682830	неоконченное высшее	2112
Никита	Смирнова	Чеславович	+7 997 042 34 01	4383 628602	высшее	2113
Орест	Симонов	Леонидовна	8 406 809 4526	1883 545973	\N	2114
София	Михайлова	\N	+7 (902) 916-71-67	9231 262957	неоконченное высшее	2115
Матвей	Медведев	\N	+71296201474	7775 788813	\N	2116
Арефий	Фокин	Игнатович	8 (429) 271-2005	7818 340084	неоконченное высшее	2117
Антонин	Смирнова	\N	+7 (649) 385-40-93	8673 804932	среднее	2118
Исай	Захаров	Борисович	+7 (769) 605-9718	9279 737858	высшее	2119
Аким	Журавлев	Жанович	+7 301 917 87 67	6695 721857	\N	2120
Гремислав	Селиверстов	Бориславович	8 902 267 5932	1197 311008	неоконченное высшее	2121
Иосиф	Андреева	Федосьевич	+7 359 523 34 62	9117 337612	высшее	2122
Игорь	Комиссаров	Викторовна	8 (935) 902-1719	9344 143807	неоконченное высшее	2123
Лавр	Котов	Ефремович	+7 (245) 442-3434	7324 300700	неоконченное высшее	2124
Милован	Третьякова	\N	83202275158	2644 736908	среднее	2125
Варфоломей	Силина	\N	+7 914 300 54 48	9520 930409	среднее профессиональное	2126
Лукия	Гуляев	\N	8 (106) 133-5145	4808 277783	среднее	2127
Зиновий	Шашков	\N	+7 (127) 862-7434	1703 290495	высшее	2128
Пахом	Соболев	Альбертовна	+7 (334) 932-2003	8451 517074	высшее	2129
Ефим	Михайлов	\N	+7 391 327 37 40	7006 498542	среднее профессиональное	2130
Лука	Цветков	Вячеславовна	+7 058 124 5890	7210 127169	неоконченное высшее	2131
Стоян	Гаврилова	\N	+7 (203) 582-7843	1754 448487	высшее	2132
Максимильян	Куликова	\N	+7 555 947 7014	3233 354631	среднее профессиональное	2133
Антонин	Гусева	Борисовна	8 274 851 9741	5146 386629	среднее профессиональное	2134
Анжела	Авдеева	\N	8 (817) 935-79-31	3473 665736	среднее	2135
Вадим	Молчанова	\N	+7 995 562 2633	1533 262662	среднее	2136
Лариса	Агафонова	Григорьевна	8 138 172 4494	6392 784667	высшее	2137
Капитон	Пономарева	Викторовна	+7 (502) 782-86-47	3749 513804	среднее	2138
Елисей	Никитина	Яковлевич	8 (320) 940-80-48	4339 603924	высшее	2139
Майя	Федотов	Харламович	8 893 507 6425	9192 698394	неоконченное высшее	2140
Николай	Брагина	Григорьевна	8 (070) 313-79-20	8815 315446	неоконченное высшее	2141
Варвара	Гурьев	\N	+76380493569	6360 556662	\N	2142
Тимофей	Романов	\N	8 (146) 660-3895	8354 550967	среднее	2143
Симон	Виноградов	\N	88744452031	3599 961317	\N	2144
Измаил	Меркушев	Герасимович	84076058741	8375 534414	\N	2145
Софон	Симонов	Яковлевич	8 402 330 3340	1896 981285	неоконченное высшее	2146
Ростислав	Титова	\N	+7 964 757 84 13	2607 408187	\N	2147
Наина	Ефимова	Денисович	+77957544012	4191 553540	неоконченное высшее	2148
Клавдия	Белозеров	Георгиевич	8 (211) 037-58-83	1451 396456	среднее профессиональное	2149
Андрей	Хохлов	\N	+7 748 754 3765	6579 660407	неоконченное высшее	2150
Арефий	Красильников	\N	8 267 157 8895	5989 169009	высшее	2151
Фаина	Устинов	Ильич	+7 (262) 874-1006	6010 256320	неоконченное высшее	2152
Творимир	Аксенов	\N	8 (727) 840-74-99	6944 523853	среднее профессиональное	2153
Святополк	Шубин	Алексеевна	+72147143336	2168 152427	среднее профессиональное	2154
Регина	Комиссаров	\N	+79685762885	4530 474649	высшее	2155
Александра	Воронцов	\N	8 (497) 759-97-50	9295 383686	среднее профессиональное	2156
Василиса	Власова	Игнатьевич	+7 (164) 919-51-81	8095 978262	среднее профессиональное	2157
Анжелика	Абрамова	Якубович	+7 (231) 146-70-25	6391 255340	\N	2158
Всеволод	Степанова	Измаилович	82047275015	7618 976389	среднее профессиональное	2159
Аполлон	Тарасов	Георгиевна	8 (723) 591-5214	3130 306837	среднее профессиональное	2160
Селиверст	Агафонов	Феофанович	89329692722	9707 117468	среднее профессиональное	2161
Твердислав	Хохлова	\N	87818763326	6925 568781	неоконченное высшее	2162
Кондратий	Беляков	Болеславовна	8 (281) 116-20-60	6765 343000	среднее профессиональное	2163
Фрол	Одинцова	Анатольевич	+77213163683	3018 556592	среднее профессиональное	2164
Ефим	Пахомов	Вячеславович	84442372790	6318 344467	высшее	2165
Алина	Алексеев	Олеговна	8 852 552 08 32	6056 927126	среднее профессиональное	2166
Орест	Евдокимов	Еремеевич	8 752 595 44 80	8863 925446	\N	2167
Владилен	Воробьева	Тимофеевна	8 905 989 4541	5174 553079	\N	2168
Соломон	Красильников	Кузьминична	8 038 633 9784	2611 909932	высшее	2169
Анна	Петухова	\N	89859536383	8968 163285	высшее	2170
Марина	Кабанов	\N	+7 (598) 578-2040	5720 700318	среднее	2171
Фёкла	Котов	\N	+7 (406) 481-60-21	7443 412305	неоконченное высшее	2172
Соломон	Лаврентьева	Ерофеевич	8 454 856 6860	2432 652566	высшее	2173
Аким	Богданов	Антонович	8 375 884 6486	8822 949414	среднее профессиональное	2174
Екатерина	Голубев	Ярославович	+7 710 781 8467	8690 361761	среднее профессиональное	2175
Федосий	Уваров	\N	+7 706 021 10 96	9665 374607	высшее	2176
Всемил	Богданова	\N	+7 836 003 36 41	9433 881451	высшее	2177
Варвара	Орехова	Владиславович	+7 898 382 2275	3818 243882	среднее профессиональное	2178
Михаил	Русаков	Ивановна	+76732717109	1113 110025	высшее	2179
Михей	Яковлева	Феликсович	+78210223863	7731 165337	среднее профессиональное	2180
Тимофей	Соловьева	\N	8 (897) 986-1555	5663 354891	среднее	2181
Ираида	Кошелев	Ефремович	8 618 614 98 15	6673 667412	среднее профессиональное	2182
Лидия	Стрелков	\N	8 (958) 558-75-57	2631 135816	среднее профессиональное	2183
Стоян	Ильина	Марсович	8 750 158 6279	9967 436634	среднее профессиональное	2184
Жанна	Силина	Геннадьевна	+7 849 893 6428	4668 836787	высшее	2185
Всемил	Прохорова	\N	86897061571	6285 900941	среднее	2186
Борис	Пестов	\N	+7 287 069 0735	3158 696844	\N	2187
Любовь	Зиновьева	Викентьевич	+7 267 796 95 51	1131 911056	среднее профессиональное	2188
Федор	Гордеева	\N	+7 437 400 73 54	2599 191485	неоконченное высшее	2189
Евдокия	Мишина	Игнатович	+7 467 959 51 13	9176 675076	\N	2190
Гремислав	Веселова	\N	+7 (119) 551-9357	2788 502959	среднее профессиональное	2191
Любим	Ермакова	Давидович	+7 (590) 962-9313	7741 364090	\N	2192
Аркадий	Макаров	\N	87241472281	4306 113794	неоконченное высшее	2193
Тамара	Терентьев	\N	8 578 105 4921	5264 783251	неоконченное высшее	2194
Леон	Орехова	\N	+7 962 295 52 27	5735 534010	неоконченное высшее	2195
Гурий	Савин	\N	8 (283) 614-0798	2375 220983	среднее профессиональное	2196
Варвара	Архипов	Степановна	+7 426 606 1510	9627 918455	среднее	2197
Виктор	Якушева	\N	8 770 761 06 23	5929 497294	среднее профессиональное	2198
Парфен	Киселева	Макаровна	+7 (987) 284-85-54	1521 143469	среднее профессиональное	2199
Зосима	Громов	\N	+7 (123) 217-60-93	7708 821007	\N	2200
Радислав	Мухин	Демьянович	+7 (046) 723-19-71	4079 595350	высшее	2201
Мария	Лебедев	\N	+7 (233) 903-8873	4784 509681	среднее	2202
Сидор	Терентьев	Валерьянович	+7 (207) 922-16-34	3328 303143	высшее	2203
Валерия	Гаврилов	Тимуровна	8 (427) 595-33-54	4109 206448	неоконченное высшее	2204
Фрол	Ширяева	\N	8 (426) 918-86-71	8003 208443	неоконченное высшее	2205
Прасковья	Зайцев	Ильясович	8 835 082 33 10	5793 596236	среднее профессиональное	2206
Милован	Гришин	\N	+7 163 526 4902	8034 219656	неоконченное высшее	2207
Евсей	Крылов	Фомич	8 104 601 4020	1944 207290	высшее	2208
Екатерина	Суханов	Тихонович	+7 946 539 5636	1115 765147	высшее	2209
Любосмысл	Киселев	Анатольевич	8 (559) 502-04-63	9552 238425	среднее	2210
Савватий	Лыткина	Ааронович	+7 470 136 6985	1622 464456	среднее профессиональное	2211
Петр	Красильников	\N	+79868495099	2331 856861	среднее	2212
Антонина	Романов	\N	8 (058) 942-79-79	8786 721275	неоконченное высшее	2213
Панкрат	Ильин	\N	+7 090 404 1448	8184 475280	высшее	2214
Алевтина	Титова	\N	8 (022) 020-27-39	2229 916246	\N	2215
Якуб	Степанова	Всеволодович	+73529959120	6156 274665	высшее	2216
Зиновий	Никифоров	Ермолаевич	8 (123) 921-9669	4220 417915	среднее	2217
Нестор	Доронин	Ефстафьевич	+7 (598) 116-19-76	6542 663890	высшее	2218
Афиноген	Буров	Борисовна	+7 (750) 303-1866	5995 978200	среднее профессиональное	2219
Орест	Ковалев	Ярославович	+7 (032) 656-5900	9248 561836	среднее	2220
Ратмир	Быков	\N	+7 289 520 3251	2147 812815	неоконченное высшее	2221
Павел	Королев	Аверьянович	+7 639 464 3422	4771 903350	высшее	2222
Артем	Гурьева	\N	8 (758) 040-5731	5176 824387	среднее профессиональное	2223
Филимон	Рыбакова	\N	8 240 617 60 44	8368 270657	высшее	2224
Агата	Захарова	\N	+7 (285) 501-2392	3239 461587	\N	6281
Еремей	Максимов	Матвеевна	8 (491) 755-59-59	9451 860982	неоконченное высшее	2225
Сергей	Никифорова	Владимировна	+7 388 926 36 16	8690 182166	среднее профессиональное	2226
Ирина	Белова	\N	+7 (852) 191-6148	1725 779453	среднее	2227
Семен	Новиков	\N	+7 (019) 070-9856	6699 524345	среднее	2228
Панфил	Степанов	Богданович	8 (065) 176-13-98	6262 634764	среднее профессиональное	2229
Прохор	Кондратьев	\N	8 958 188 65 52	8195 418319	\N	2230
Леон	Субботина	Игнатович	+7 735 761 17 58	9261 740168	\N	2231
Александра	Фомичева	\N	8 (461) 671-7322	2856 319407	\N	2232
Богдан	Муравьева	Валентиновна	8 617 817 78 65	7006 177169	неоконченное высшее	2233
Лазарь	Кузнецов	Ааронович	+7 (216) 730-2075	8343 667580	неоконченное высшее	2234
Арефий	Федотова	\N	+7 (065) 819-11-11	3556 569889	неоконченное высшее	2235
Анастасия	Дроздов	\N	8 (703) 128-2066	3555 855697	высшее	2236
Синклитикия	Владимирова	\N	+74084628431	9154 330675	высшее	2237
Платон	Цветков	Денисович	+76845628164	3580 467423	среднее	2238
Феликс	Ларионов	Харлампьевич	8 (885) 731-85-71	6093 300382	среднее	2239
Варвара	Сергеев	Трифонович	+7 744 178 9607	5312 232529	среднее профессиональное	2240
Кир	Мартынова	Анисимович	+7 279 398 58 81	3306 565456	\N	2241
Сила	Воронцова	\N	+7 (416) 391-1525	8415 836840	среднее профессиональное	2242
Милица	Блохина	Бенедиктович	8 982 048 00 76	8088 225179	неоконченное высшее	2243
Вероника	Русакова	\N	+74704409223	8279 765632	высшее	2244
Конон	Рожкова	\N	+7 (661) 570-89-98	9640 436439	высшее	2245
Пахом	Фомичев	Даниловна	81551054815	4404 290184	неоконченное высшее	2246
Селиверст	Кулагина	Рудольфовна	+7 (875) 068-31-89	2326 950548	среднее	2247
Никанор	Макаров	\N	84220481512	1888 113762	неоконченное высшее	2248
Якуб	Осипова	\N	+7 (728) 543-44-24	4245 708957	\N	2249
Артем	Гордеев	\N	+7 281 475 20 87	2812 196926	среднее	2250
Агафья	Федотова	\N	+7 950 857 5225	9433 416351	среднее профессиональное	2251
Радован	Шубина	\N	+7 (708) 964-62-56	7480 653000	среднее	2252
Вениамин	Коновалова	\N	+7 (139) 821-50-41	2513 620604	среднее	2253
Зиновий	Панов	Елизарович	+7 (660) 805-0830	9041 314132	среднее профессиональное	2254
Ермолай	Коновалова	Аксёнович	+7 (441) 014-94-16	6118 320795	среднее	2255
Галактион	Беспалов	Димитриевич	8 (842) 156-05-73	3208 903743	неоконченное высшее	2256
Данила	Самойлов	Филимонович	+7 600 275 03 97	6635 373446	среднее профессиональное	2257
Нифонт	Гуляева	Ерофеевич	8 614 745 84 56	6164 324138	среднее	2258
Мирон	Крюкова	\N	8 213 712 2199	9525 607408	высшее	2259
Лавр	Гуляева	Ильич	+7 (837) 199-4176	9878 904381	среднее	2260
Эрнест	Федосеева	Устинович	+74387246457	3777 128401	высшее	2261
Елисей	Новикова	Валентиновна	84766389120	4948 651910	\N	2262
Касьян	Ларионов	Теймуразович	8 (772) 513-3769	4625 845514	среднее профессиональное	2263
Любим	Самойлов	\N	+77371692858	4843 640922	среднее	2264
Игорь	Калашникова	\N	8 (138) 560-62-30	4590 116935	неоконченное высшее	2265
Пантелеймон	Гусева	\N	88139412123	4741 267228	среднее	2266
Феофан	Зимина	Виленович	8 (774) 723-7212	3841 404739	неоконченное высшее	2267
Любим	Силин	Егорович	8 452 585 15 26	8505 779049	неоконченное высшее	2268
Милован	Котова	\N	8 554 987 9786	6318 572758	\N	2269
Варвара	Самойлов	Сергеевна	+7 579 755 2029	2441 259178	\N	2270
Панкрат	Воронцов	\N	8 (328) 270-4776	7409 141341	среднее	2271
Твердислав	Романова	Станиславовна	+7 (121) 273-6346	4847 387983	высшее	2272
Алла	Носков	Борисовна	+73036703451	9298 633739	среднее профессиональное	2273
Лаврентий	Андреев	\N	+7 691 663 90 36	6982 203641	среднее профессиональное	2274
Аполлинарий	Белов	Валериевна	+7 234 354 45 62	9363 432727	среднее	2275
Велимир	Бобылев	Чеславович	81643277205	4946 474077	среднее профессиональное	2276
Флорентин	Морозов	Аскольдовна	+7 (360) 441-97-53	4880 415735	высшее	2277
Ксения	Ковалева	\N	+7 (430) 297-6344	7814 396469	высшее	2278
Ипат	Гурьева	\N	+7 (846) 233-02-40	3906 808641	\N	2279
Гаврила	Попова	Станиславовна	8 284 468 1162	8444 579697	высшее	2280
Ермил	Колесников	Ермолаевич	+7 693 328 59 09	3515 845772	среднее профессиональное	2281
Агафон	Гущина	Артемовна	89417448974	8910 321801	среднее профессиональное	2282
Милен	Лапин	\N	+7 282 373 93 48	5659 212666	\N	2283
Иванна	Дементьев	Ефимьевич	+7 579 769 10 89	7247 958111	высшее	2284
Савва	Колобова	Владиславович	85030601780	8200 809177	\N	2285
Радислав	Ершов	\N	84291358383	5051 932359	среднее профессиональное	2286
Азарий	Никонов	\N	+77164258771	3730 890435	высшее	2287
Фаина	Лукин	Гавриилович	8 (549) 673-3398	3301 461504	\N	2288
Михей	Шилова	Вилорович	+74340057050	7921 989535	высшее	2289
Исай	Комаров	Филиппович	8 146 859 94 91	1282 542783	среднее профессиональное	2290
Феофан	Миронов	\N	+75687942126	2844 236180	\N	2291
Борис	Стрелкова	Андреевна	+75810563141	8509 338522	высшее	2292
Леонид	Андреев	\N	+7 (793) 528-0738	4481 833775	среднее	2293
Софон	Галкина	\N	+70912128732	4938 425267	среднее профессиональное	2294
Мина	Суворов	Харлампьевич	+7 (203) 103-6188	8301 685122	среднее профессиональное	2295
Корнил	Артемьев	Станиславовна	8 688 811 9655	6758 374738	\N	2296
Радим	Зиновьев	\N	+7 (143) 322-2360	5892 261185	высшее	2297
Ираида	Лукина	Иларионович	+7 (266) 919-48-68	3421 502772	\N	2298
Александра	Лихачев	Филипповна	8 (038) 549-1612	1879 510676	\N	2299
Олимпий	Соловьева	\N	8 027 169 5301	5883 569550	среднее	2300
Ананий	Ситникова	Валериевна	+7 954 427 2228	8682 459893	высшее	2301
Вацлав	Бурова	Трифонович	8 562 184 31 47	4757 584640	среднее профессиональное	2302
Александр	Матвеев	\N	8 494 105 84 01	1736 891122	неоконченное высшее	2303
Викентий	Филиппов	Демидович	8 446 121 7728	6620 896568	неоконченное высшее	2304
Пелагея	Маслова	Кузьминична	8 (161) 235-18-17	4084 950112	\N	2305
Милен	Белозеров	Кузьминична	8 (383) 378-15-41	5722 773501	среднее	2306
Лидия	Филатов	\N	+7 (624) 621-08-68	9059 913485	среднее	2307
Авксентий	Фомина	\N	+7 (938) 140-9004	7630 146961	высшее	2308
Аггей	Ершова	Феофанович	8 (680) 231-2685	4005 230062	высшее	2309
Вячеслав	Щербаков	Феликсовна	8 (120) 292-6810	8483 584711	среднее	2310
Савватий	Елисеев	Гурьевич	+7 (154) 939-3051	1915 902747	неоконченное высшее	2311
Антип	Самойлов	Артурович	8 665 197 99 75	6149 700755	среднее профессиональное	2312
Стоян	Симонов	Еремеевич	+7 280 606 78 26	7938 508022	среднее	2313
Филимон	Корнилов	Егоровна	8 (760) 079-4877	9512 946220	\N	2314
Тимофей	Петров	\N	8 (307) 722-83-44	2793 536768	высшее	2315
Тамара	Иванова	\N	8 (818) 814-66-03	2956 814504	высшее	2316
Регина	Тихонова	Филиппович	+7 (687) 056-68-11	8860 162102	\N	2317
Адам	Тихонова	Ярославович	8 796 633 7843	2892 502616	высшее	2318
Кузьма	Рожкова	Валентинович	8 543 881 13 91	3622 634313	среднее профессиональное	2319
Геннадий	Поляков	Устинович	8 (223) 520-3719	4256 221476	среднее	2320
Мина	Вишняков	Бориславович	+7 550 028 4219	3349 163275	среднее профессиональное	2321
Сократ	Сазонов	\N	88854270506	6309 320992	среднее профессиональное	2322
Ксения	Кудрявцев	Феофанович	+72412188351	2139 936329	неоконченное высшее	2323
Елисей	Мамонтова	Аверьянович	8 064 759 1074	8215 364430	\N	2324
Олимпиада	Журавлева	Бориславович	8 016 289 0521	5837 420104	высшее	2325
Людмила	Беспалова	Филиппович	+7 012 006 79 77	2654 348910	среднее профессиональное	2326
Петр	Молчанова	\N	8 278 617 7367	9083 624432	высшее	2327
Юрий	Савельев	Матвеевна	+7 (854) 103-2356	9922 930854	среднее	2328
Георгий	Лазарева	\N	+7 (414) 679-13-05	1529 553369	среднее профессиональное	2329
Измаил	Стрелкова	\N	8 659 130 25 64	7095 304523	неоконченное высшее	2330
Елисей	Туров	\N	8 684 967 80 33	6787 439833	среднее	2331
Евдокия	Беляев	\N	+73803175297	4570 528316	среднее профессиональное	2332
Адам	Алексеев	\N	+7 345 499 1583	7239 918170	среднее	2333
Евлампий	Туров	Егорович	+79743461114	9887 828523	высшее	2334
Ульян	Суханов	Жоресович	+7 829 642 90 20	3456 500575	высшее	2335
Кузьма	Моисеев	\N	8 (504) 883-17-59	8636 726462	неоконченное высшее	2336
София	Баранова	\N	+7 255 033 94 79	6071 365097	неоконченное высшее	2337
Ульяна	Маслов	Иосифович	8 (880) 074-8112	2679 307579	высшее	2338
Гордей	Кудряшов	\N	8 (534) 231-84-27	3826 849051	среднее	2339
Синклитикия	Савельев	Дмитриевич	+7 675 274 25 10	8135 808836	\N	2340
Самсон	Лебедев	\N	+77054036962	3084 916325	высшее	2341
Радим	Панова	Даниилович	+7 970 599 2116	4452 296229	среднее профессиональное	2342
Аникита	Маслова	Фролович	+71949832408	3677 193283	\N	2343
Радислав	Дорофеева	\N	+7 619 745 1235	6875 763539	среднее профессиональное	2344
Елена	Лыткин	\N	82002024010	1117 266082	\N	2345
Иван	Абрамов	\N	8 837 655 6829	7171 484498	среднее профессиональное	2346
Прасковья	Ширяев	Фокич	8 158 743 0380	8835 300916	среднее	2347
Яков	Быков	Марсович	+7 (064) 505-03-87	5287 370758	высшее	2349
Евдоким	Горшков	\N	8 375 574 5800	8933 298824	среднее профессиональное	2350
Мартын	Константинов	\N	+7 074 029 84 98	5466 387852	высшее	2351
Модест	Беляев	\N	81695034420	2718 264060	среднее профессиональное	2352
Аникей	Куликов	\N	8 (811) 032-28-94	7322 815119	неоконченное высшее	2353
Георгий	Уваров	Димитриевич	8 (325) 345-8777	9938 671287	среднее	2354
Сидор	Третьяков	\N	84163934585	9218 537366	среднее	2355
Ферапонт	Цветков	\N	8 (140) 150-33-86	1168 272647	среднее профессиональное	2356
Анисим	Игнатьева	\N	+71275300481	7165 544942	среднее	2357
Эрнест	Горбунов	Борисовна	8 439 410 94 33	1609 502327	высшее	2358
Фадей	Щукин	\N	8 (849) 145-99-43	6619 852631	среднее профессиональное	2359
Лука	Бобылев	\N	8 576 821 7704	5783 972157	\N	2360
Евграф	Михайлова	\N	+7 908 912 7394	6792 253284	среднее	2361
Фирс	Гаврилов	\N	8 (941) 326-27-92	8276 247162	высшее	2362
Аверьян	Кудрявцева	Григорьевна	8 576 835 66 38	8388 432049	высшее	2363
Платон	Суворова	Владиленович	8 (505) 514-8539	7479 821569	среднее	2364
Фёкла	Лазарева	Теймуразович	8 430 884 4945	1672 459331	\N	2365
Панфил	Костин	\N	+7 (736) 523-7228	8438 764964	высшее	2366
Денис	Ефимова	\N	8 (636) 884-56-30	4549 647719	высшее	2367
Евгений	Лихачева	\N	8 (712) 798-4078	4928 784354	неоконченное высшее	2368
Лев	Гордеева	Никифоровна	+79412683522	6857 422175	высшее	2369
Кирилл	Носков	Ермолаевич	8 875 185 85 78	5559 182353	среднее профессиональное	2370
Осип	Савельев	\N	+7 757 976 89 62	5782 254483	высшее	2371
Галина	Лапина	\N	8 (065) 046-50-11	2822 659315	среднее	2372
Доброслав	Большаков	Матвеевна	8 433 204 5030	1793 321710	среднее	2373
Пантелеймон	Виноградова	\N	85880329474	1637 313311	\N	2374
Адриан	Самойлова	Андреевна	+7 (957) 428-7840	2335 121701	среднее профессиональное	2375
Борис	Колесникова	Измаилович	83013095730	5273 794457	среднее	2376
Валентин	Абрамов	\N	8 290 796 9345	8232 230246	высшее	2377
Зиновий	Горшков	\N	+73743829408	1469 368988	высшее	2378
Сила	Лыткина	Филимонович	8 714 169 93 91	1100 818920	среднее профессиональное	2379
Зинаида	Крюкова	Гаврилович	8 (688) 744-4060	1131 459212	среднее	2380
Еремей	Рогова	Геннадьевна	8 (622) 867-1730	7375 510630	высшее	2381
Аким	Лаврентьев	Евгеньевна	8 844 816 3152	8035 205163	\N	2382
Регина	Терентьев	Робертовна	88941346548	9059 685901	неоконченное высшее	2383
Жанна	Шаров	\N	8 122 398 4514	9317 504759	высшее	2384
Поликарп	Федотов	Власович	+7 (038) 917-7465	6959 252172	высшее	2385
Арсений	Селиверстов	\N	+7 564 640 96 64	5980 357781	среднее	2386
Виктория	Зиновьев	\N	83981455104	6420 768735	среднее	2387
Эмилия	Субботин	Фомич	8 212 304 7290	8202 389304	среднее профессиональное	2388
Егор	Исакова	Романовна	+7 232 336 4469	2993 810081	среднее	2389
Карп	Галкин	\N	+7 039 339 82 09	8097 660047	среднее профессиональное	2390
Роман	Егорова	\N	8 (850) 032-99-06	2539 644531	неоконченное высшее	2391
Василиса	Большакова	\N	+7 (827) 619-2361	1719 806265	неоконченное высшее	2392
Агап	Громова	Фадеевич	8 (954) 973-8695	2389 277259	среднее профессиональное	2393
Модест	Сорокина	Захаровна	89467009341	1051 952884	высшее	2394
Владимир	Ситникова	\N	+7 (937) 001-3948	6828 126472	среднее профессиональное	2395
Изот	Игнатьева	\N	85261347272	3121 381039	\N	2396
Виктория	Нестеров	\N	+7 (154) 199-3746	8844 188739	среднее профессиональное	2397
Алина	Авдеев	\N	+7 (261) 054-79-08	6779 573008	высшее	2398
Аверкий	Веселов	Афанасьевич	+70765969485	9112 461101	среднее профессиональное	2399
Евстафий	Федосеев	\N	+7 024 901 3646	9236 323097	среднее профессиональное	2400
Оксана	Силина	Жоресович	8 (933) 545-27-86	9821 824764	среднее	2401
Макар	Авдеева	\N	+7 (683) 355-64-45	8215 652097	неоконченное высшее	2402
Любим	Потапова	Рубеновна	+7 (993) 597-39-20	7163 393800	\N	2403
Георгий	Максимова	Феодосьевич	+7 (528) 635-04-58	7108 525149	среднее	2404
Андроник	Цветков	Рудольфовна	+7 (248) 856-5161	6539 641626	среднее профессиональное	2405
Ростислав	Кондратьев	Иосифович	+74363332158	7149 312040	\N	2406
Фока	Орлова	Германович	8 727 604 48 38	8978 500303	\N	2407
Демид	Корнилов	Львовна	+7 140 275 88 11	7307 132966	среднее	2408
Лука	Кулагин	\N	+7 674 334 3464	6178 157258	неоконченное высшее	2409
Елизар	Воронов	\N	8 (178) 029-8948	5513 187888	высшее	2410
Корнил	Костин	\N	+7 717 282 6136	2938 630777	\N	2411
Фадей	Некрасова	\N	8 (597) 830-77-71	5121 483877	неоконченное высшее	2412
Жанна	Логинов	\N	80250015755	5728 814989	\N	2413
Август	Зуев	\N	+7 602 484 7085	1869 868880	среднее профессиональное	2414
Анисим	Фокина	Федосеевич	8 105 773 0217	3006 368842	среднее профессиональное	2415
Аникей	Лыткин	\N	+7 228 940 24 03	9669 757377	среднее	2416
Евгений	Молчанова	\N	8 654 652 46 54	5160 541976	среднее профессиональное	2417
Алевтина	Никифоров	\N	8 (160) 205-49-77	3826 151430	среднее	2418
Аверкий	Фомина	\N	82123650462	7077 136060	высшее	2419
Юлия	Попов	Борисовна	8 812 710 2720	2975 773245	среднее профессиональное	2420
Людмила	Гуляева	Геннадиевна	+7 (602) 870-1913	7805 864564	среднее	2421
Лев	Зиновьева	Артемьевич	8 (770) 614-1854	8894 360104	\N	2422
Олимпиада	Кабанова	Эдгарович	8 100 054 4671	4961 785682	неоконченное высшее	2423
Болеслав	Крылов	\N	84431332313	7446 758055	\N	2424
Майя	Силин	Артёмович	85936914520	2090 190319	среднее профессиональное	2425
Ипатий	Панфилова	\N	+7 059 256 86 89	2660 512402	среднее профессиональное	2426
Кондрат	Титова	Святославовна	+7 (303) 130-60-04	1065 171438	среднее профессиональное	2427
Зоя	Агафонов	Вадимовна	89413747544	9045 668055	\N	2428
Еремей	Евсеев	\N	8 (157) 410-6092	4953 707615	среднее	2429
Никанор	Романов	\N	+7 665 685 67 77	6642 461977	высшее	2430
Герасим	Коновалов	Робертовна	+7 265 661 46 46	4092 611305	высшее	2431
Каллистрат	Савельев	Глебович	8 (898) 797-04-95	2273 988129	высшее	2432
Борис	Савин	\N	8 (336) 219-21-78	2702 599767	высшее	2433
Август	Шаров	Антипович	8 665 494 9235	5067 340818	среднее профессиональное	2434
Георгий	Суворова	Харитоновна	+7 631 334 95 19	6885 201007	\N	2435
Ананий	Федотов	\N	+7 (808) 871-4710	7056 542247	неоконченное высшее	2436
Герасим	Доронин	Фролович	8 (720) 602-82-89	9959 547055	неоконченное высшее	2437
Лазарь	Мишин	Ерофеевич	+7 944 754 5715	8436 992447	среднее профессиональное	2438
Леонид	Богданов	\N	80945120162	6994 385273	\N	2439
Анна	Лобанов	\N	+75049116508	1086 296609	среднее	2440
Мина	Шубина	\N	+7 272 385 56 45	2779 986861	среднее профессиональное	2441
Петр	Корнилова	\N	8 344 788 72 09	6374 679428	среднее	2442
Аристарх	Данилова	\N	+7 275 200 5466	5691 904923	среднее профессиональное	2443
Юлий	Сергеев	\N	8 199 808 10 80	6914 361937	неоконченное высшее	2444
Антонин	Субботина	\N	8 557 718 69 65	9455 173224	\N	2445
Мартын	Блохина	\N	8 041 206 12 63	4808 622172	высшее	2446
Афанасий	Дорофеева	\N	+7 (685) 407-48-71	6987 506396	среднее профессиональное	2447
Ангелина	Белозерова	\N	87659923649	6536 489126	\N	2448
Нестор	Суханов	\N	8 811 895 7650	3856 170140	неоконченное высшее	2449
Любим	Крюков	\N	+7 (309) 456-1513	3223 525060	среднее	2450
Амвросий	Фролова	\N	+79333694364	1752 987340	\N	2451
Сократ	Пестова	\N	+7 (921) 425-3942	6707 654766	\N	2452
Куприян	Воронцова	Демидович	+7 (715) 143-6153	6892 162078	среднее	2453
Филарет	Жданова	\N	+77680137097	8253 319749	\N	2454
Владимир	Голубева	\N	8 934 547 10 02	8672 973909	\N	2455
Лонгин	Щербакова	Гертрудович	8 657 876 8588	8482 833911	неоконченное высшее	2456
Виталий	Дементьева	\N	+7 748 092 62 46	3840 774644	\N	2457
Самсон	Ситникова	\N	8 650 932 1962	9383 312987	среднее профессиональное	2458
Селиван	Кулаков	Тарасовна	8 (012) 622-2110	7024 699826	среднее	2459
Ираида	Колобова	Архипович	+7 (585) 957-03-63	9752 951562	среднее профессиональное	2460
Никанор	Абрамов	Эдгардович	+7 (794) 338-7845	4727 121367	неоконченное высшее	2461
Капитон	Сергеев	Ефимьевич	85743034542	7561 642228	\N	2462
Елизавета	Ковалева	\N	8 869 598 3210	5709 902318	среднее профессиональное	2463
Изот	Семенова	Максимовна	+7 (664) 190-59-87	1541 181984	среднее	2464
Агата	Виноградова	\N	8 (876) 812-92-37	7065 521684	неоконченное высшее	2465
Милий	Кондратьев	\N	+7 (679) 802-16-57	4251 282753	неоконченное высшее	2466
Еремей	Филатова	\N	8 998 285 78 66	5670 629229	\N	2467
Максим	Михайлов	\N	+7 (443) 251-1731	3504 933555	\N	2468
Наркис	Мартынов	Алексеевна	8 735 974 7493	4766 501120	среднее	2469
Евстафий	Белозерова	\N	8 654 113 36 03	7646 798756	высшее	2470
Анна	Горшкова	\N	+7 (833) 933-5220	2083 747590	среднее	2471
Борис	Смирнов	\N	+7 305 050 5102	1190 162794	высшее	2472
Парфен	Панфилов	Ануфриевич	8 737 577 09 71	6480 237420	среднее профессиональное	2473
Лонгин	Беспалов	\N	8 014 352 81 14	6737 322944	\N	2474
Автоном	Карпов	Венедиктович	+7 (233) 829-32-55	3611 338431	среднее	2475
Милен	Артемьева	Богданович	+7 (798) 815-03-96	8461 341866	\N	2476
Прасковья	Журавлева	Андреевич	8 (474) 758-68-72	5579 572229	среднее	2477
Виссарион	Антонов	\N	+76285465370	7849 317651	неоконченное высшее	2478
Владимир	Силина	\N	8 381 382 7563	2473 811327	высшее	2479
Леон	Моисеева	\N	8 815 795 6259	5968 679486	\N	2480
Исидор	Макарова	\N	+76284084959	8956 523109	\N	2481
Анжелика	Бобров	\N	8 (591) 173-79-12	6740 918047	среднее профессиональное	2482
Аркадий	Миронов	\N	+7 757 916 84 03	3909 933693	среднее профессиональное	2483
Мина	Третьяков	Ааронович	8 732 415 77 72	9760 189801	среднее	2484
Никита	Рогова	\N	8 742 005 7316	5195 731982	среднее профессиональное	2485
Радислав	Гришин	Оскаровна	81016654485	3022 866647	высшее	2486
Ян	Лукина	Харлампьевич	8 (691) 486-4751	8447 892256	высшее	2487
Мартьян	Степанова	\N	8 345 555 34 06	7550 160608	\N	2488
Антонина	Гусева	\N	8 (752) 038-5710	3568 270039	среднее профессиональное	2489
Феоктист	Цветков	Оскаровна	+7 608 965 65 55	8939 867937	\N	2490
Исидор	Герасимов	Вячеславович	8 668 585 62 77	9150 129213	неоконченное высшее	2491
Авксентий	Лобанова	Александрович	+7 (669) 932-19-95	9699 569483	\N	2492
Гаврила	Копылова	\N	80022283462	8798 161473	высшее	2493
Лариса	Мамонтов	Викторовна	8 (512) 105-6344	3949 513224	среднее	2494
Харитон	Блинов	Алексеевич	8 033 967 8057	5101 106184	среднее	2495
Марина	Горбунова	Демидович	8 083 178 88 19	3945 102411	неоконченное высшее	2496
Кондратий	Кузнецова	Аксёнович	+7 (052) 702-7861	1433 624317	неоконченное высшее	2497
Велимир	Васильев	Эдгарович	+7 406 753 86 35	7773 189398	среднее	2498
Синклитикия	Быкова	Афанасьевна	8 (291) 891-27-86	7931 104491	неоконченное высшее	2499
Модест	Кабанов	\N	+7 (412) 342-08-10	2928 633367	\N	2500
Лаврентий	Александров	Матвеевна	8 395 596 96 12	9886 367123	среднее профессиональное	2501
Василий	Некрасов	\N	8 878 205 59 46	9587 200812	неоконченное высшее	2502
Агафья	Пономарев	Георгиевна	8 (312) 063-85-22	4603 295334	высшее	2503
Остап	Капустина	\N	+7 135 311 8200	9735 740061	среднее	2504
Лидия	Дроздов	Евстигнеевич	+7 (769) 460-0124	8700 868018	неоконченное высшее	2505
Валерьян	Лобанов	\N	8 724 625 77 65	7248 372190	среднее профессиональное	2506
Николай	Никонов	Феодосьевич	+79643069437	7944 690683	неоконченное высшее	2507
Прасковья	Чернова	Гордеевич	8 305 311 8383	8165 993264	среднее	2508
Милован	Щербаков	Филиппович	8 481 093 99 98	7882 477869	среднее профессиональное	2509
Анатолий	Герасимов	Ануфриевич	8 (999) 794-8282	6089 432998	неоконченное высшее	2510
Георгий	Власова	Аверьянович	+7 (609) 512-23-04	1049 561317	среднее	2511
Галина	Доронина	Исидорович	+7 (455) 738-7489	3749 694835	среднее профессиональное	2512
Нонна	Крюков	\N	8 (508) 799-6975	7269 847534	высшее	2513
Прокл	Крылова	\N	87116246112	8155 526496	среднее	2514
Рюрик	Блохина	Рубеновна	+7 440 519 07 09	3903 667670	\N	2515
Федосий	Блохина	Олеговна	+7 (725) 534-38-80	9983 609200	\N	2516
Еремей	Бобылева	\N	+7 (252) 656-37-90	1749 388362	\N	2517
Павел	Ермаков	\N	8 (108) 400-6161	3692 241018	среднее профессиональное	2518
Кирилл	Голубев	\N	89457522178	2149 606582	среднее	2519
Сократ	Шарапова	Владимировна	+7 (186) 171-3909	8349 653292	среднее профессиональное	2520
Алина	Яковлева	\N	8 (305) 206-13-23	5720 995714	\N	2521
Данила	Рыбаков	\N	80152930992	3657 667950	\N	2522
Кира	Хохлов	Ануфриевич	+7 (603) 149-09-36	7553 345199	среднее профессиональное	2523
Архип	Тетерин	\N	8 481 800 40 41	9635 938645	\N	2524
Варфоломей	Мамонтов	\N	82641553025	8162 853792	высшее	2525
Семен	Виноградов	Вячеславович	8 243 198 60 19	8981 401523	\N	2526
Ананий	Комарова	\N	+7 896 220 27 60	2323 718473	высшее	2527
Аггей	Пестова	Юрьевна	8 (150) 041-07-27	4392 474142	среднее	2528
Анжелика	Виноградов	\N	8 895 979 74 26	8158 163141	высшее	2529
Алина	Осипова	Ааронович	+7 (927) 968-84-20	4769 600031	среднее	2530
Радим	Лаврентьев	Гертрудович	+7 (222) 586-8547	7277 135117	среднее профессиональное	2531
Ульяна	Анисимова	\N	8 (894) 594-09-23	8095 931182	высшее	2532
Макар	Блинова	Захаровна	+75945092876	9849 353517	высшее	2533
Харлампий	Муравьева	\N	+72847310320	6636 749343	высшее	2534
Всеслав	Федоров	Евстигнеевич	8 288 803 98 14	7131 364621	неоконченное высшее	2535
Леонид	Кондратьева	\N	+75581731549	7315 909851	среднее	2536
Ефрем	Крюков	\N	+7 (300) 821-83-14	4284 265667	неоконченное высшее	2537
Архип	Михайлов	Якубович	8 293 978 0994	2826 977388	неоконченное высшее	2538
Наркис	Красильников	Геннадьевна	8 (967) 242-1312	4031 546554	высшее	2539
Олимпиада	Фомичев	Юльевич	8 (284) 726-7198	3556 706351	высшее	2540
Корнил	Яковлева	Измаилович	+7 (916) 870-8921	8026 919982	среднее профессиональное	2541
Адриан	Наумов	Жанович	+79190223206	7167 862083	высшее	2542
Дмитрий	Васильева	\N	83856413359	8980 197555	среднее профессиональное	2543
София	Брагин	\N	8 (062) 636-2839	7840 243860	высшее	2544
Антип	Сергеев	\N	85303676416	2627 714843	среднее профессиональное	2545
Ермолай	Мельникова	Мироновна	+7 988 191 9718	3726 848127	высшее	2546
Эмиль	Якушева	\N	8 (668) 243-1522	7695 241394	высшее	2547
Велимир	Субботина	Феликсовна	89519293321	5243 398061	неоконченное высшее	2548
София	Одинцова	Максимовна	8 326 113 8172	3113 295339	\N	2549
Евлампий	Горбачев	Филипповна	+7 287 527 75 27	9926 865920	высшее	2550
Агафья	Антонов	Давидович	8 (667) 413-4183	8324 171442	среднее профессиональное	2551
Назар	Симонов	\N	8 512 070 5820	5608 295919	среднее профессиональное	2552
Кира	Зыкова	\N	84977075093	6042 278520	среднее	2553
Степан	Ситников	Брониславович	+77474043899	1399 432534	неоконченное высшее	2554
Людмила	Давыдова	\N	+7 (532) 973-9357	7819 317404	\N	2555
Раиса	Новиков	\N	80309046388	9234 427194	среднее	2556
Аггей	Щербакова	\N	89726873470	2404 419617	среднее	2557
Милица	Самойлова	Андреевич	8 266 827 2442	3914 399805	среднее профессиональное	2558
Герман	Емельянов	Венедиктович	8 (376) 149-8679	8318 564383	высшее	2559
Никанор	Голубева	Викентьевич	8 (279) 225-9938	3538 990476	\N	2560
Аггей	Тимофеева	\N	88299112525	8323 122853	неоконченное высшее	2561
Раиса	Дмитриева	\N	8 600 119 27 69	8111 408749	\N	2562
Василий	Федотова	Федосьевич	83975295313	2039 279401	\N	2563
Владислав	Трофимов	Гурьевич	+7 418 278 6145	2606 964862	высшее	2564
Ефим	Семенов	\N	8 (880) 591-5133	7874 681468	среднее профессиональное	2565
Клавдия	Моисеева	\N	+7 (432) 931-90-53	9318 258497	неоконченное высшее	2566
Яков	Игнатов	Ильич	8 920 047 50 37	9978 461987	среднее	2567
Борис	Александрова	\N	+7 878 708 91 46	5415 863459	среднее профессиональное	2568
Мартын	Зиновьев	\N	+7 (307) 037-95-12	6634 186213	\N	2569
Екатерина	Авдеев	Фомич	+7 731 622 65 60	6694 353778	высшее	2570
Парфен	Сорокин	\N	8 252 303 15 20	5390 895084	высшее	2571
Сильвестр	Калинин	Юлианович	+7 983 579 2899	2650 164497	неоконченное высшее	2572
Серафим	Шилов	\N	+7 (016) 065-0458	1753 912768	высшее	2573
Флорентин	Сафонова	\N	8 (002) 637-7489	4991 943440	среднее	2574
Леон	Силин	\N	+72772315201	2195 630009	среднее	2575
Яков	Абрамов	Григорьевна	89080888748	6674 369793	среднее	2576
Вацлав	Егорова	\N	+7 (795) 627-21-19	8115 458234	среднее профессиональное	2577
Феврония	Кузнецов	Ярославович	8 899 790 07 58	8997 184106	среднее	2578
Варлаам	Власова	Тимофеевна	8 (566) 165-2124	5738 461735	\N	2579
Семен	Фомин	Матвеевич	8 (818) 873-5081	9409 322725	неоконченное высшее	2580
Филимон	Казакова	Ерофеевич	8 (783) 216-1864	4903 432027	среднее профессиональное	2581
Прокл	Ефремова	Валерьянович	8 (872) 458-6255	8820 762239	\N	2582
Остромир	Беляков	Ефстафьевич	+7 (784) 252-0821	6065 867299	высшее	2583
Викентий	Овчинников	Денисович	81659963756	9940 442267	\N	2584
Юлиан	Моисеева	\N	+7 181 282 14 28	8821 541195	среднее	2585
Ипполит	Федотов	Кузьминична	+7 (360) 876-40-58	8473 713686	высшее	2586
Онуфрий	Панфилов	\N	+7 566 720 12 17	2924 750433	среднее профессиональное	2587
Ангелина	Крюкова	\N	+7 555 486 2482	7434 252803	неоконченное высшее	2588
Руслан	Лазарев	Еремеевич	+7 (605) 443-81-63	8572 505080	среднее	2589
Прасковья	Маслова	\N	+7 233 256 32 27	4189 215676	\N	2590
Аркадий	Носков	Евсеевич	+72222737601	2992 251339	среднее	2591
Серафим	Комаров	Федотович	+75809366123	6548 135993	неоконченное высшее	2592
Оксана	Гурьев	\N	8 (287) 826-48-24	3161 811685	высшее	2593
Венедикт	Цветков	\N	87001191045	8443 309364	\N	2594
Модест	Рогов	\N	8 306 829 5390	3787 395376	среднее профессиональное	2595
Лидия	Матвеев	Юльевич	8 245 931 3029	8646 274660	неоконченное высшее	2596
Агафон	Кузьмин	\N	+7 (337) 177-6755	6158 215401	высшее	2597
Елисей	Тимофеева	\N	+78530034904	4301 997645	среднее	2598
Эдуард	Савельева	\N	8 (780) 039-4838	4300 311339	среднее	2599
Ананий	Карпова	Васильевич	8 856 941 9199	7609 659352	высшее	2600
Ольга	Носков	\N	8 325 513 90 81	7570 197496	высшее	2601
Вячеслав	Ершов	\N	+7 195 809 07 20	6226 383069	\N	2602
Трофим	Федотов	\N	87375518438	6483 110580	неоконченное высшее	2603
Сергей	Одинцов	\N	84141275245	4843 526100	неоконченное высшее	2604
Лонгин	Ширяев	Анисимович	+7 (816) 167-5135	9149 563076	среднее профессиональное	2605
Любомир	Наумова	\N	+7 (020) 058-88-84	8409 493122	\N	2606
Емельян	Вишняков	\N	+7 (177) 155-5412	3733 179876	среднее	2607
Емельян	Зиновьев	Феликсовна	8 622 981 3312	6125 811375	высшее	2608
Зосима	Ефимов	Тихонович	8 139 371 3356	2157 334284	среднее профессиональное	2609
Артемий	Терентьев	Фадеевич	+70678413930	5986 605183	высшее	2610
Ипатий	Королева	Филиппович	81235318311	8171 662011	среднее профессиональное	2611
Анна	Журавлева	Фёдорович	+79517668407	7846 783232	\N	2612
Поликарп	Кириллов	\N	8 425 900 5530	4876 844277	высшее	2613
Влас	Никифорова	\N	+7 684 651 81 60	9367 291764	среднее	2614
Галина	Овчинникова	Жоресович	8 (667) 319-35-01	3078 895433	среднее профессиональное	2615
Прохор	Брагин	\N	89360133928	8044 918016	неоконченное высшее	2616
Яков	Лобанов	Алексеевна	+72685631253	8729 318402	неоконченное высшее	2617
Демьян	Крылов	Юлианович	8 (054) 135-7590	6739 436045	\N	2618
Ермолай	Давыдова	Георгиевна	+76692949852	6043 345674	высшее	2619
Пахом	Лобанова	\N	8 (565) 484-3472	2888 292895	\N	2620
Виктория	Вишняков	Ивановна	+7 042 594 3226	5590 420210	неоконченное высшее	2621
Юлиан	Антонов	Богдановна	+7 (326) 152-1410	8779 392613	неоконченное высшее	2622
Кузьма	Ильина	Анатольевна	86514325390	1877 841868	\N	2623
Тихон	Жуков	Герасимович	8 787 432 1314	6644 702394	\N	2624
Иннокентий	Семенов	\N	8 064 484 5029	4294 835463	высшее	2625
Валентин	Андреев	\N	+7 (061) 897-4815	3629 126827	высшее	2626
Велимир	Ковалева	\N	+70457324513	4413 353834	среднее	2627
Аким	Сергеева	\N	8 (108) 016-93-90	6101 732729	среднее	2628
Мокей	Андреева	\N	+7 863 699 3054	3950 219447	неоконченное высшее	2629
Ладислав	Гурьев	\N	+7 026 217 8900	1863 485829	высшее	2630
Вышеслав	Щукина	\N	+73162817682	3646 707764	среднее	2631
Никодим	Борисов	Матвеевич	8 258 132 8411	1101 810254	среднее профессиональное	2632
Поликарп	Романов	\N	8 (725) 709-54-05	9021 553016	высшее	2633
Владлен	Александров	\N	8 (811) 558-36-85	3464 270457	\N	2634
Януарий	Гущин	Антонович	+70270102363	9575 955818	неоконченное высшее	2635
Сидор	Кондратьева	Харитоновна	80870154606	3804 874582	неоконченное высшее	2636
Савелий	Муравьева	Дмитриевич	8 (509) 296-63-71	7791 492286	неоконченное высшее	2637
Прасковья	Герасимова	Ильич	89799161948	4476 564026	неоконченное высшее	2638
Лора	Зуев	Феоктистович	+7 473 932 7875	1215 774665	высшее	2639
Юлий	Шестаков	Вилорович	81132294616	2072 417891	неоконченное высшее	2640
Галактион	Костина	Наумовна	+7 (211) 431-45-14	6159 246859	высшее	2641
Владислав	Соловьев	\N	+7 (027) 568-9031	9762 822786	среднее	2642
Азарий	Селезнев	\N	8 149 152 1376	4102 492193	среднее	2643
Ратмир	Кулаков	\N	+7 (698) 702-4358	6343 898587	высшее	2644
Бронислав	Емельянов	Леоновна	+7 (423) 980-64-20	9636 552948	\N	2645
Капитон	Федотов	\N	+7 366 149 31 18	3272 222332	неоконченное высшее	2646
Ратибор	Корнилов	\N	+7 (418) 634-2696	4285 528218	среднее	2647
Станислав	Денисова	Данилович	89614497298	5504 664389	среднее профессиональное	2648
Ипполит	Дмитриева	\N	+7 (570) 842-0813	6566 259106	неоконченное высшее	2649
Пахом	Рыбакова	Борисович	8 (013) 681-1383	3483 413005	среднее профессиональное	2650
Трифон	Пахомова	Игоревна	+7 315 778 43 73	2235 731652	среднее профессиональное	2651
Никандр	Большаков	Алексеевна	+70476233720	2938 174842	среднее профессиональное	2652
Александра	Кузьмина	\N	8 301 934 41 59	9891 245571	неоконченное высшее	2653
Филарет	Горбунова	\N	+7 545 167 72 16	6698 774765	среднее	2654
Лев	Щербаков	Гаврилович	8 136 426 14 80	9393 553665	неоконченное высшее	2655
Анна	Белоусова	\N	8 874 127 0634	2235 285964	среднее	2656
Панкратий	Хохлов	Александровна	+7 679 224 8901	2679 514819	\N	2657
Онуфрий	Якушев	\N	+71301337671	4627 586136	среднее профессиональное	2658
Вацлав	Логинов	\N	82024710365	5019 891745	среднее	2659
Степан	Сазонов	\N	8 527 217 9794	5455 394331	среднее	2660
Архип	Лобанова	Георгиевна	+7 (670) 372-70-10	7785 913871	неоконченное высшее	2661
Велимир	Громова	Харлампович	+7 568 748 6695	5768 576689	среднее	2662
Авдей	Калинин	Станиславовна	+7 714 659 6317	9437 107851	неоконченное высшее	2663
Лавр	Андреева	\N	+7 839 083 64 90	7780 822046	среднее	2664
Онуфрий	Веселов	\N	+7 055 413 3578	1492 370310	неоконченное высшее	2665
Алевтина	Лапин	Яковлевич	+7 154 164 4871	1813 321159	\N	2666
Тарас	Савельев	\N	+7 499 545 88 85	5423 947024	неоконченное высшее	2667
Авдей	Крылов	Терентьевич	8 (576) 031-0643	1874 608057	среднее	2668
Эрнест	Беспалова	\N	+79863419479	7542 916543	высшее	2669
Гаврила	Кузьмин	Гертрудович	+7 (005) 745-12-87	2149 558264	среднее профессиональное	2670
Егор	Рожков	Эльдаровна	+7 782 369 5540	1933 308704	\N	2671
Валерия	Уваров	Аскольдовна	8 (940) 579-83-70	9971 477900	среднее профессиональное	2672
Фрол	Казаков	Богданович	8 666 613 0440	3924 751385	среднее	2673
Олимпий	Горшкова	Натановна	+7 (726) 803-56-77	8170 557072	среднее	2674
Эмиль	Меркушев	Петровна	+7 255 537 1313	7990 559395	неоконченное высшее	2675
Исидор	Марков	Иосипович	8 (386) 840-82-98	1362 266928	\N	2676
Зиновий	Игнатьева	\N	8 451 869 09 07	8217 826795	\N	2677
Карп	Лебедева	\N	+7 744 312 29 34	3855 463391	среднее профессиональное	2678
Рубен	Герасимов	\N	+75121947369	3564 552796	среднее профессиональное	2679
Милий	Трофимова	Сергеевна	+7 (499) 545-57-22	7505 122915	среднее профессиональное	2680
Кондратий	Медведев	\N	+7 (616) 864-5404	4214 674554	среднее	2681
Ермолай	Крюков	Демидович	8 476 937 21 08	7511 101720	среднее профессиональное	2682
Феоктист	Михеева	Федоровна	+7 108 455 0990	9750 468519	среднее	2683
Валерьян	Щукина	Гордеевич	84664818847	5253 764622	неоконченное высшее	2684
Велимир	Рябова	\N	+7 (112) 309-79-15	2606 498014	высшее	2685
Юлия	Герасимова	Яковлевна	81435868259	5405 464507	среднее	2686
Валерия	Суворов	\N	+7 (562) 807-7016	8699 383921	\N	2687
Панкрат	Наумов	Леонидовна	+77727177122	1051 100072	среднее	2688
Адриан	Рожков	\N	+7 (956) 156-70-47	6151 496080	среднее профессиональное	2689
Ярополк	Веселова	Арсеньевич	+71091053864	5198 187092	неоконченное высшее	2690
Андрей	Громова	Богданович	+77905340930	7056 591647	среднее профессиональное	2691
Соломон	Гаврилов	Ерофеевич	83786272174	1905 967611	\N	2692
Сократ	Соловьев	Архипович	89197749487	7251 851654	среднее	2693
Федосий	Коновалова	\N	8 (858) 853-6818	5857 906440	среднее профессиональное	2694
Мечислав	Юдин	\N	8 164 341 97 14	2048 792024	высшее	2695
Пантелеймон	Мухина	Викторовна	+7 197 993 01 44	6338 106888	\N	2696
Викентий	Лебедева	Тарасовна	+7 424 946 2132	4524 768943	высшее	2697
Александра	Быков	Исидорович	8 (755) 265-9906	1485 549036	среднее профессиональное	2698
Данила	Федотов	\N	+7 (983) 438-01-34	2062 695968	среднее профессиональное	2699
Харлампий	Галкина	\N	8 944 395 0198	6774 738212	среднее	2700
Аким	Харитонова	\N	8 (712) 896-46-06	1809 597295	\N	2701
Ростислав	Мамонтов	Вячеславович	8 (502) 632-7483	6848 598429	неоконченное высшее	2702
Анатолий	Васильев	Харламович	+79932782824	3552 974236	высшее	2703
Валерий	Горшкова	Артурович	+7 352 100 1706	7501 793376	среднее	2704
Нонна	Мельников	\N	8 084 874 3515	2628 267627	среднее	2705
Анатолий	Зыкова	Александровна	+7 297 163 93 96	6732 988076	среднее профессиональное	2706
Филипп	Филиппов	Кузьминична	+7 045 156 0590	3975 316755	среднее	2707
Яков	Белозерова	Августович	85860242664	6067 518853	неоконченное высшее	2708
Светлана	Назаров	\N	+78490557278	3172 119358	среднее профессиональное	2709
Аполлон	Васильева	\N	+7 (249) 452-5728	8307 569168	среднее профессиональное	2710
Антип	Блохина	Макаровна	+7 (309) 572-0183	3603 316902	\N	2711
Матвей	Кондратьев	\N	8 (566) 546-29-39	1759 183287	неоконченное высшее	2712
Мартьян	Пономарева	Матвеевна	8 (740) 701-92-93	2066 955263	среднее профессиональное	2713
Прокл	Соловьева	\N	8 909 476 6291	1365 411422	среднее	2714
Карп	Харитонова	Герасимович	+7 (849) 763-82-70	6765 853635	неоконченное высшее	2715
Трофим	Комаров	Фокич	8 373 181 24 20	6948 642440	среднее профессиональное	2716
Терентий	Носов	Гордеевич	+76685200166	4000 298090	среднее профессиональное	2717
Амос	Шарапов	\N	8 (667) 134-7248	2769 362863	неоконченное высшее	2718
Владилен	Тимофеева	Геннадиевна	+70766839333	8280 434472	неоконченное высшее	2719
Влас	Комиссарова	Гордеевич	8 167 498 66 78	7387 147824	неоконченное высшее	2720
Леон	Дмитриева	\N	8 653 931 7498	7262 154358	высшее	2721
Елизар	Самсонова	\N	8 671 118 36 81	5569 777425	\N	6407
Феликс	Орехов	\N	8 447 455 4405	7993 407184	среднее профессиональное	2722
Милен	Ефимов	Феликсовна	+7 384 231 74 11	4921 811998	среднее	2723
Касьян	Белоусова	\N	8 825 673 78 87	3267 273514	неоконченное высшее	2724
Селиверст	Денисова	Матвеевич	+7 933 408 21 65	9211 655802	среднее профессиональное	2725
Агап	Гурьева	\N	8 (191) 769-19-74	3667 727319	высшее	2726
Тимофей	Федосеев	Матвеевна	8 (037) 895-3949	8432 780627	среднее профессиональное	2727
Натан	Панова	Иларионович	+75017680860	1551 366406	высшее	2728
Феврония	Рябов	Яковлевна	+7 (334) 844-17-22	6569 941404	неоконченное высшее	2729
Ферапонт	Аксенова	\N	8 478 680 7228	3873 674172	\N	2730
Петр	Третьяков	Зиновьевич	+75905380269	5037 977096	среднее профессиональное	2731
Леон	Фролова	\N	+7 (617) 440-9166	3537 487247	неоконченное высшее	2732
Елизар	Самойлов	\N	+7 541 749 28 32	9688 268016	\N	2733
Евпраксия	Максимова	Августович	+7 561 108 3056	6096 404939	среднее	2734
Поликарп	Шашкова	\N	+76496371935	3775 154040	\N	2735
Милица	Устинов	\N	+7 552 670 30 38	9523 274795	среднее	2736
Радислав	Сафонов	\N	+7 (157) 149-5072	8781 112906	среднее профессиональное	2737
Савва	Бобров	Ярославович	+7 005 797 53 48	3310 703428	среднее профессиональное	2738
Сила	Шашкова	Евсеевич	+7 (845) 490-4362	4720 248591	высшее	2739
Селиван	Мартынов	\N	8 (824) 119-6519	1748 349355	высшее	2740
Федор	Меркушева	Всеволодович	+7 (889) 379-89-39	6250 832921	среднее	2741
Анастасия	Волкова	\N	8 (925) 878-0615	3995 317341	среднее	2742
Ерофей	Соловьев	Эдуардович	8 401 728 81 98	8581 621881	среднее профессиональное	2743
Владилен	Федосеев	Артёмович	8 (911) 724-4810	1815 245965	среднее профессиональное	2744
Аверьян	Тимофеева	\N	8 817 258 7349	4273 797792	\N	2745
Поликарп	Тарасова	Александровна	8 (155) 042-03-61	7841 405924	неоконченное высшее	2746
Фёкла	Баранов	\N	8 881 536 9566	3314 693013	среднее	2747
Ангелина	Капустина	Исидорович	8 134 794 55 32	8482 656285	среднее профессиональное	2748
Казимир	Федотов	\N	+7 (976) 525-62-40	7715 473976	среднее	2749
Трифон	Карпов	Демидович	+78596603500	5339 181435	неоконченное высшее	2750
Пантелеймон	Шубина	Львовна	+7 (839) 744-1270	3588 455110	высшее	2751
Мир	Петров	\N	+7 (779) 838-98-19	6428 458641	высшее	2752
Модест	Егоров	\N	8 574 955 52 44	3278 779054	высшее	2753
Ладимир	Моисеева	Сергеевна	8 369 732 4716	3430 654657	среднее	2754
Любовь	Игнатьев	\N	8 366 860 1479	9638 678728	\N	2755
Денис	Зиновьева	Зиновьевич	+7 (754) 881-7277	5809 421853	\N	2756
Вышеслав	Афанасьева	\N	+78235863471	3951 978779	\N	2757
Амвросий	Панфилов	\N	87789959957	4818 257575	среднее	2758
Аполлинарий	Маркова	Николаевна	+7 (661) 864-1787	6486 509798	\N	2759
Татьяна	Козлов	\N	8 336 418 1464	2252 455359	среднее профессиональное	2760
Любосмысл	Васильев	Павловна	+7 (511) 274-57-05	8038 154207	\N	2761
Ким	Воронцова	\N	+7 518 294 31 23	2389 938785	неоконченное высшее	2762
Ермил	Третьякова	\N	8 129 331 88 39	8203 369517	высшее	2763
Ювеналий	Фомичев	\N	8 716 413 44 22	3934 436252	среднее профессиональное	2764
Олимпиада	Галкина	Святославовна	+7 532 371 58 59	8347 925372	среднее	2765
Вениамин	Горбачев	Тимуровна	8 628 065 5289	6085 840677	высшее	2766
Лев	Калинина	\N	8 (579) 466-8032	8816 295437	\N	2767
Варлаам	Родионов	\N	8 491 576 8259	8656 153504	\N	2768
Надежда	Фролов	Ждановна	+7 307 257 32 38	4062 499284	неоконченное высшее	2769
Артем	Жданова	Васильевич	80158555066	9381 182327	среднее	2770
Эраст	Федосеев	\N	+7 (054) 737-32-55	5681 129742	среднее	2771
Олимпий	Лапин	\N	+7 312 500 11 80	2105 287978	высшее	2772
Евгений	Никитина	Абрамович	8 452 348 4410	3377 857542	\N	2773
Петр	Молчанова	Гордеевич	87783155014	7881 554765	среднее профессиональное	2774
Иван	Семенов	\N	+74088782194	7877 124526	неоконченное высшее	2775
Терентий	Романов	\N	8 (357) 601-3493	1407 263297	\N	2776
Ирина	Максимов	Максимовна	8 658 610 22 29	8460 183320	высшее	2777
Лука	Одинцов	\N	8 (029) 844-0485	1759 130687	среднее профессиональное	2778
Самуил	Сысоева	\N	8 249 176 3972	1099 530546	среднее профессиональное	2779
Борислав	Комиссаров	Александровна	+78043353179	9699 889762	\N	2780
Аполлинарий	Горбачева	\N	+7 781 644 5641	5324 349105	неоконченное высшее	2781
Виктория	Мельникова	\N	8 794 504 4517	2521 687433	среднее	2782
Симон	Семенова	\N	+7 133 098 44 31	7545 830564	неоконченное высшее	2783
Панкратий	Яковлева	\N	8 394 300 69 29	1974 364869	\N	6534
Бажен	Колесникова	Артёмович	+7 013 978 7924	2905 930401	среднее	2784
Панфил	Суханов	Сергеевна	+7 (396) 250-2345	6834 666277	неоконченное высшее	2785
Вышеслав	Зайцев	\N	8 419 758 7019	9685 818543	высшее	2786
Виссарион	Исаева	Абрамович	8 114 651 4532	4387 820099	\N	2787
Зинаида	Сидорова	\N	89086159025	7931 637327	высшее	2788
Вениамин	Королева	\N	8 066 478 58 33	6641 544207	неоконченное высшее	2789
Аникей	Бурова	\N	+7 (657) 097-83-53	7030 587031	\N	2790
Марина	Селиверстов	Венедиктович	8 427 622 54 41	2200 137764	\N	2791
Прокл	Афанасьева	\N	8 364 323 8317	5332 378012	\N	2792
Радислав	Матвеева	Гаврилович	8 (367) 035-0665	1693 595347	среднее профессиональное	2793
Клавдий	Михеев	\N	8 (646) 418-44-47	1341 772636	высшее	2794
Исай	Потапов	\N	8 (365) 549-9176	1008 622565	\N	2795
Антонина	Тимофеева	Ааронович	84460618657	6046 405006	высшее	2796
Кузьма	Родионов	\N	+7 350 984 95 57	5325 645983	среднее	2797
Панкратий	Горбунов	Брониславович	+71486267115	1139 435899	неоконченное высшее	2798
Станимир	Субботин	Степановна	8 (344) 066-2986	2954 990169	неоконченное высшее	2799
Виталий	Никифорова	\N	+7 (807) 999-21-91	4232 736699	среднее профессиональное	2800
Руслан	Лапина	\N	8 (536) 058-38-83	7684 430821	среднее профессиональное	2801
Олимпиада	Кудрявцев	\N	+7 (141) 515-67-33	1953 555842	среднее	2802
Кира	Морозов	Тимофеевна	+7 (720) 188-50-21	2534 519818	неоконченное высшее	2803
Сила	Лукин	Игнатьевич	8 (305) 448-7286	1087 636010	\N	2804
Элеонора	Селиверстов	\N	+74962837340	4748 390575	неоконченное высшее	2805
Лукия	Морозов	\N	8 (713) 665-2069	6264 709948	среднее профессиональное	2806
Исидор	Белозеров	\N	8 801 756 53 46	9079 837458	высшее	2807
Амвросий	Соболева	Алексеевна	+73731732492	9578 396181	среднее	2808
Феликс	Котова	Ждановна	8 559 202 38 40	1591 660934	среднее	2809
Артемий	Быкова	Рудольфовна	+7 134 491 1871	7782 854929	\N	2810
Чеслав	Моисеев	Степановна	+74202033221	6166 917211	высшее	2811
Карп	Ершов	\N	8 175 348 97 99	2228 280596	среднее	2812
Ермил	Никифорова	\N	+71463384589	9913 218104	высшее	2813
Иосиф	Большаков	\N	8 (678) 402-4476	2194 306841	среднее	2814
Василиса	Сафонова	\N	+7 208 845 49 08	7122 193780	неоконченное высшее	2815
Бронислав	Кононов	\N	+7 178 802 0111	2765 778044	среднее	2816
Кузьма	Стрелков	\N	+7 (885) 235-71-46	6970 840029	среднее профессиональное	2817
Милий	Марков	Богдановна	+78727875034	4394 371603	среднее	2818
Радован	Красильникова	\N	8 530 655 82 75	4085 784507	среднее	2819
Михей	Коновалова	\N	+7 (240) 012-52-92	2300 863432	\N	2820
Кондрат	Емельянов	\N	82850474458	1308 470158	среднее	2821
Мартьян	Антонова	Тарасович	8 324 819 9329	1654 284978	неоконченное высшее	2822
Парамон	Виноградов	Георгиевна	8 334 968 8394	9781 466237	\N	2823
Демид	Афанасьева	Жанович	8 (079) 133-4982	4749 162541	\N	2824
Серафим	Лыткина	\N	+7 (079) 467-4584	9984 191239	высшее	2825
Савелий	Родионов	\N	8 277 529 88 13	6046 437647	среднее	2826
Осип	Колесников	\N	+7 478 322 38 13	9446 804610	\N	2827
Николай	Ситникова	\N	+7 (549) 038-19-04	9530 677690	высшее	2828
Милен	Виноградова	Федотович	+7 (019) 594-88-03	6347 711622	\N	2829
Корнил	Блохин	Ефремович	+7 (400) 099-8691	4114 538525	неоконченное высшее	2830
Фрол	Комаров	\N	8 287 565 9922	4231 977523	высшее	2831
Арефий	Ковалева	Демьянович	+7 (399) 096-6454	2424 581705	высшее	2832
Мариан	Марков	Феофанович	+7 299 598 09 37	4679 876708	среднее профессиональное	2833
Вячеслав	Гущина	\N	8 212 804 6984	9438 697943	среднее	2834
Харитон	Красильников	Федосьевич	85820588491	4035 392127	среднее	2835
Орест	Наумов	Елисеевич	+7 (202) 531-02-90	6990 324863	среднее профессиональное	2836
Милен	Кононова	Владиленович	+7 314 989 4828	3757 814152	среднее профессиональное	2837
Константин	Веселова	\N	+7 (274) 663-7075	6454 399003	среднее профессиональное	2838
Осип	Дмитриев	\N	+7 (891) 758-5600	9516 763117	среднее	2839
Ермил	Бобылева	Викторович	+7 028 378 3925	3806 484429	неоконченное высшее	2840
Никон	Дементьева	\N	+7 (068) 001-84-61	1347 259189	среднее	2841
Силантий	Белова	Львовна	8 489 089 2405	1234 746939	неоконченное высшее	2842
Никифор	Беляева	Брониславович	+7 (007) 925-83-69	3870 725450	неоконченное высшее	2843
Мокей	Маслова	\N	+7 (118) 655-52-18	2651 613509	высшее	2844
Марк	Муравьева	Юлианович	+7 353 040 55 90	7817 548805	высшее	2845
Севастьян	Колобов	\N	8 (030) 626-29-90	1127 543825	\N	2846
Конон	Осипов	Тимуровна	+7 (815) 544-04-48	6189 493217	\N	2847
Платон	Анисимова	\N	8 510 985 64 19	5936 706226	высшее	2848
Адриан	Орлова	\N	8 (305) 931-64-41	1764 218753	\N	2849
Ратибор	Королева	\N	+7 166 946 2850	5414 805009	\N	2850
Ия	Бобров	Викторовна	+7 (962) 289-92-16	7088 152783	высшее	2851
Рюрик	Муравьев	\N	8 968 840 9852	1864 805244	среднее	2852
Евлампий	Пахомова	\N	8 916 560 39 54	2759 988073	среднее профессиональное	2853
Владислав	Юдина	\N	8 (081) 241-04-54	1917 201475	\N	2854
Пахом	Беляева	Вилорович	8 121 994 94 06	4211 352208	высшее	2855
Кирилл	Самойлов	\N	8 396 515 98 43	3744 979991	высшее	2856
Евстафий	Назарова	\N	8 386 345 1447	2224 822685	среднее	2857
Виктория	Михеев	\N	8 068 521 4863	1362 617910	высшее	2858
Мефодий	Зиновьева	Витальевич	8 121 583 68 44	3782 573374	\N	2859
Стоян	Попов	Гавриилович	+7 (967) 368-8280	2056 551146	среднее	2860
Милица	Антонов	\N	+7 128 894 18 13	9469 975106	высшее	2861
Яков	Иванов	Якубович	+7 588 403 2351	8003 889519	\N	2862
Наталья	Петров	\N	82091324807	8862 546424	неоконченное высшее	2863
Милен	Фокина	Яковлевна	+73425920274	9150 423262	среднее	2864
Куприян	Давыдов	\N	+7 (142) 882-02-19	5096 651995	\N	2865
Измаил	Муравьева	\N	8 (341) 526-3352	7427 381961	неоконченное высшее	2866
Клавдия	Сысоева	Иосипович	+72357286956	3053 141393	неоконченное высшее	2867
Евстигней	Мишина	\N	8 (629) 109-6731	2257 768142	\N	2868
Давыд	Зимин	\N	+74513526356	5938 850366	высшее	2869
Мстислав	Устинов	\N	+7 (541) 678-9797	6028 330710	высшее	2870
Добромысл	Ефремов	\N	+7 (809) 265-2582	7321 894422	среднее	2871
Пахом	Шубин	\N	+7 (259) 582-8111	8841 647046	неоконченное высшее	2872
Наум	Власов	\N	8 819 665 80 89	5962 852466	среднее профессиональное	2873
Амвросий	Федоров	\N	+7 (883) 864-4233	7594 505208	\N	2874
Капитон	Быков	Якубович	+7 (291) 030-87-15	8721 566152	\N	2875
Анжелика	Чернов	Кузьминична	8 632 844 13 04	3792 110862	высшее	2876
Эдуард	Мясников	Станиславовна	+7 (486) 733-16-65	6186 755893	высшее	2877
Будимир	Смирнов	Валериевна	8 180 382 0045	2127 632586	среднее профессиональное	2878
Денис	Кудрявцева	\N	+7 591 797 0142	2849 874945	неоконченное высшее	2879
Светлана	Денисов	\N	85576974135	9729 483639	среднее профессиональное	2880
Харлампий	Куликова	Виленович	+7 356 417 1509	7169 665016	высшее	2881
Маргарита	Лебедев	Бориславович	8 (325) 265-6188	1243 898374	неоконченное высшее	2882
Севастьян	Кузьмина	\N	8 746 335 50 02	3312 303093	неоконченное высшее	2883
Парфен	Карпов	Валерьянович	+7 (236) 680-00-32	8554 933244	неоконченное высшее	2884
Гедеон	Лаврентьев	\N	+7 617 907 3568	8386 352171	\N	2885
Творимир	Сидорова	Павловна	+7 (761) 534-6262	3993 819924	\N	2886
Бронислав	Кудрявцев	\N	8 510 801 8261	7103 129976	неоконченное высшее	2887
Савва	Осипов	\N	+7 (433) 789-73-30	8566 439581	\N	2888
Василиса	Назарова	\N	+7 (128) 147-2764	3775 100944	\N	2889
Герман	Фомина	Ааронович	87436025055	8339 670535	среднее	2890
Тамара	Устинова	Никифоровна	+7 407 052 3147	1946 141338	среднее профессиональное	2891
Октябрина	Маслов	Артемьевич	8 (361) 671-5613	9882 219211	высшее	2892
Казимир	Сидорова	\N	+7 (310) 481-23-98	6342 400078	среднее профессиональное	2893
Вера	Третьякова	Елисеевич	+7 514 648 6010	6042 396309	\N	2894
Анатолий	Никонов	Васильевна	8 (522) 402-0456	2914 122408	высшее	2895
Нина	Самсонов	Данилович	+7 529 416 37 69	4707 927980	неоконченное высшее	2896
Людмила	Шашков	Архипович	8 (311) 677-20-62	9416 950664	среднее	2897
Амвросий	Колобова	Гавриилович	8 403 060 0966	2899 536514	среднее	2898
Ладислав	Федотова	Андреевич	8 331 831 5923	9507 601014	неоконченное высшее	2899
Алевтина	Пахомов	Валерьевич	8 (243) 653-1077	2782 263858	неоконченное высшее	2900
Кондратий	Журавлева	Ивановна	8 (177) 722-83-96	8281 589369	среднее	2901
Клавдия	Тимофеева	\N	8 (178) 197-7948	2536 846692	высшее	2902
Тарас	Федосеев	\N	+7 (647) 729-68-42	6771 169019	высшее	2903
Наина	Никонова	\N	8 839 994 87 57	1555 182701	высшее	2904
Парфен	Степанова	\N	+7 (343) 969-7428	1202 413949	среднее профессиональное	2905
Маргарита	Комиссаров	Игоревна	8 (197) 764-00-52	9338 216014	высшее	2906
Георгий	Суворова	\N	+7 480 227 96 59	3201 513078	среднее	2907
Сигизмунд	Данилов	Натановна	8 (082) 383-38-95	7875 140519	высшее	2908
Антип	Потапов	\N	+7 (019) 768-9753	6322 982192	\N	2909
Евфросиния	Блинова	\N	+7 840 495 44 83	3012 393486	неоконченное высшее	2910
Порфирий	Федосеева	\N	8 742 395 9728	6314 846124	\N	2911
Потап	Громова	\N	+7 209 324 2602	4348 148791	среднее профессиональное	2912
Никанор	Рожкова	\N	8 (022) 657-41-48	7396 536137	среднее	2913
Фока	Федотова	Васильевна	+73543241974	8732 540754	\N	2914
Трифон	Пономарев	Власович	8 332 126 31 14	2783 816464	высшее	2915
Арсений	Мельников	\N	+7 (156) 743-09-78	6906 127404	среднее	2916
Руслан	Мишина	\N	+7 147 880 88 56	2083 758583	неоконченное высшее	2917
Яков	Лобанов	Игнатович	+7 (134) 078-0345	8741 897532	высшее	2918
Бажен	Рыбаков	\N	+7 (995) 529-42-21	8889 498676	среднее профессиональное	2919
Остромир	Одинцов	Всеволодович	+7 783 448 67 62	7519 339036	неоконченное высшее	2920
Любосмысл	Матвеева	\N	81827750768	4492 194425	\N	2921
Емельян	Фомичева	Михайловна	+7 (500) 785-1410	9144 756783	среднее	2922
Юлиан	Муравьев	Венедиктович	+7 (262) 795-30-85	7185 618505	неоконченное высшее	2923
Лучезар	Дементьев	\N	+7 427 381 63 95	1847 839016	среднее профессиональное	2924
Павел	Лебедев	\N	8 069 269 48 28	9286 266704	неоконченное высшее	2925
Владилен	Сазонов	Юлианович	+74501610406	5911 111012	среднее профессиональное	2926
Андрей	Петров	Андреевна	+7 687 889 5131	7472 869952	среднее	2927
Самсон	Лапина	\N	80182032331	6094 684485	среднее	2928
Севастьян	Орлов	\N	83178115040	2860 529102	неоконченное высшее	2929
Мария	Шарапов	\N	+7 317 120 76 69	5277 375353	высшее	2930
Пелагея	Сорокина	\N	8 (201) 905-65-29	1034 771357	среднее профессиональное	2931
Силантий	Федосеева	Адрианович	+7 (193) 435-4217	1455 586074	\N	2932
Яков	Блинова	\N	8 897 141 69 67	4844 314836	среднее	2933
Аникей	Брагина	Мироновна	+7 106 214 4258	8604 262787	\N	2934
Ферапонт	Богданов	Георгиевна	+70552447834	5329 773247	\N	2935
Глеб	Кулакова	Николаевна	+7 711 003 7207	1770 136282	среднее	2936
Софон	Мухина	Артёмович	+7 172 714 76 37	1110 413497	среднее профессиональное	2937
Нинель	Шарова	\N	8 (240) 656-6056	3943 666684	\N	2938
Герман	Кузнецов	\N	8 940 293 97 61	1523 241694	\N	2939
Милен	Артемьева	\N	+7 (549) 505-28-27	5955 309768	\N	2940
Дмитрий	Павлова	Яковлевич	+7 (564) 140-73-43	5574 305416	среднее профессиональное	2941
Гостомысл	Калашников	\N	+7 (581) 089-8534	1074 343344	\N	2942
Эдуард	Калинин	\N	8 (608) 389-6525	9315 255861	среднее	2943
Марк	Носкова	Тарасовна	8 (444) 664-23-55	5404 688947	высшее	2944
Лора	Мамонтова	Натановна	8 415 012 82 62	2007 878320	\N	2945
Бронислав	Терентьева	\N	81807913119	3230 645541	\N	2946
Дарья	Архипов	Иосифович	8 (682) 999-2926	2040 869005	высшее	2947
Дорофей	Панфилова	Эдгардович	+7 (945) 771-2219	1694 242551	высшее	2948
Михаил	Ефимов	\N	+7 (324) 221-7628	7759 489090	среднее профессиональное	2949
Нина	Кононова	\N	+71136782658	4503 647116	среднее профессиональное	2950
Владимир	Жданов	Харлампович	+7 (854) 540-4187	5773 832228	высшее	2951
Наркис	Тихонова	Харлампьевич	+72621748892	2708 489139	высшее	2952
Милица	Копылова	\N	8 369 624 7096	9930 644199	среднее профессиональное	2953
Самсон	Архипов	Ильясович	8 424 974 46 19	7766 501307	среднее	2954
Макар	Веселов	Болеславовна	+7 (176) 788-8976	8726 110305	среднее	2955
Агата	Буров	Викторович	+7 (769) 747-2955	3879 654543	\N	2956
Соломон	Третьякова	\N	+7 953 253 9803	7656 443020	неоконченное высшее	2957
Глеб	Доронин	Робертовна	+7 310 973 95 61	6925 782388	среднее	2958
Виссарион	Туров	Евстигнеевич	+77658335284	4114 994200	высшее	2959
Ксения	Беляева	\N	8 (004) 265-23-21	4184 710755	высшее	2960
Анастасия	Игнатова	Давидович	8 745 027 40 78	9163 711151	неоконченное высшее	2961
Ульян	Захаров	Харитонович	+79139934988	8155 858830	неоконченное высшее	2962
Агафья	Константинова	\N	+7 730 112 62 05	1573 743384	среднее	2963
Симон	Зимина	\N	+74726477734	7199 553998	среднее профессиональное	2964
Архип	Русаков	\N	+7 (292) 361-2323	2774 774313	неоконченное высшее	2965
Кира	Лукина	\N	8 219 719 2198	7540 981017	среднее профессиональное	2966
Авдей	Одинцова	\N	+7 (348) 337-9599	7830 221106	неоконченное высшее	2967
Игнатий	Кулакова	\N	8 (178) 463-8951	9203 786780	среднее профессиональное	2968
Ростислав	Филиппова	Ниловна	+7 077 607 25 62	3966 968512	неоконченное высшее	2969
Анжела	Романова	Станиславовна	+76332480748	3093 833547	\N	2970
Вацлав	Филиппова	Васильевич	+7 134 474 3417	1872 975139	неоконченное высшее	2971
Михаил	Михеев	Ерофеевич	8 (268) 641-9119	7272 676589	среднее	2972
Радован	Ширяева	\N	81990417788	6864 276304	неоконченное высшее	2973
Борис	Прохорова	\N	+7 163 373 24 77	3705 644691	среднее профессиональное	2974
Евдоким	Давыдов	\N	8 (432) 847-21-25	5714 755692	среднее профессиональное	2975
Фадей	Смирнова	\N	8 (881) 468-4975	5271 662277	\N	2976
Кузьма	Бобров	Иларионович	+7 (265) 786-92-51	1955 498875	среднее	2977
Карл	Лукина	Даниловна	8 (347) 231-69-50	1590 104595	среднее	2978
Сократ	Ермаков	\N	85169386972	2314 278655	неоконченное высшее	2979
Ксения	Осипова	\N	+7 (329) 733-2643	6614 145401	высшее	2980
Архип	Гуляев	\N	8 263 728 66 85	6888 724370	\N	2981
Леонид	Кузнецов	Викторовна	+7 (270) 750-6495	1384 110706	высшее	2982
Данила	Данилов	\N	+7 (386) 481-21-78	6132 972107	неоконченное высшее	2983
Харитон	Зиновьева	\N	+7 208 677 4909	2387 787121	среднее профессиональное	2984
Василий	Абрамова	\N	88918363165	5391 667445	\N	2985
Никифор	Егорова	Вячеславович	8 (366) 304-61-89	6907 392391	среднее профессиональное	2986
Артем	Владимиров	\N	+7 682 492 6579	6559 696537	среднее профессиональное	2987
Никанор	Горбачев	Григорьевич	85552704384	5988 839228	среднее профессиональное	2988
Остромир	Мухина	Анатольевич	8 (937) 310-43-50	8311 936871	среднее	2989
Кузьма	Меркушев	Робертовна	+7 (840) 691-05-19	6904 805103	среднее	2990
Остромир	Зиновьев	\N	+7 177 334 5175	8283 222948	высшее	2991
Фаина	Боброва	Бенедиктович	8 (732) 187-28-67	6575 704748	\N	2992
Геннадий	Носков	Артемовна	8 (868) 511-4379	9859 815940	неоконченное высшее	2993
Владислав	Медведева	Николаевна	+7 (858) 986-59-56	2103 155682	среднее	2994
Авдей	Шаров	Тарасовна	81789252049	4241 153220	среднее	2995
Федосий	Игнатьев	\N	+72142555635	5360 903179	высшее	2996
Эмилия	Филатова	Вадимовна	+7 987 327 9384	1496 681355	среднее	2997
Бажен	Шарапов	Тимуровна	8 285 079 0854	9893 715672	\N	2998
Раиса	Поляков	\N	86401787688	5880 447586	\N	2999
Всемил	Попова	\N	+7 647 656 8815	7864 219964	неоконченное высшее	3000
Милица	Шилова	\N	+7 (090) 610-2232	9729 223882	среднее	3001
Ираклий	Фадеева	Евстигнеевич	+7 907 474 24 57	7489 135544	среднее	3002
Самсон	Михайлов	Антоновна	8 (400) 583-18-06	9385 806430	высшее	3003
Онуфрий	Рябова	\N	8 (737) 108-50-28	1527 951838	\N	3004
Авдей	Шашкова	\N	8 (848) 571-33-68	8546 808905	среднее профессиональное	3005
Фома	Морозов	Бенедиктович	+7 (377) 498-37-73	5662 864285	среднее профессиональное	3006
Андрей	Ершов	Гертрудович	+7 182 527 4084	5519 581292	\N	3007
Остромир	Пахомов	Эльдаровна	8 (316) 872-88-04	4235 757705	среднее	3008
Майя	Миронов	\N	+7 (003) 433-98-76	4599 245333	среднее	3009
Рюрик	Быкова	Афанасьевна	8 (822) 045-2810	5198 970126	неоконченное высшее	3010
Ювеналий	Ефремов	\N	8 (950) 704-0683	7524 633121	высшее	3011
Евдоким	Медведева	\N	+7 278 395 0982	2043 193395	неоконченное высшее	3012
Устин	Щукина	\N	8 (369) 928-7829	9536 474740	\N	3013
Юрий	Филатова	\N	8 320 520 8160	7357 949641	неоконченное высшее	3014
Трифон	Горбачев	\N	8 (365) 949-61-80	4610 626099	неоконченное высшее	3015
Глафира	Матвеева	\N	+7 028 667 91 93	3943 261607	среднее	3016
Добромысл	Максимов	\N	+7 618 442 80 68	8729 447534	\N	3017
Виктория	Белозеров	Иосифович	8 046 222 60 42	8928 872964	\N	3018
Станислав	Орехова	\N	+7 (898) 643-2630	1172 447336	неоконченное высшее	3019
Ксения	Дмитриев	Владиславовна	+7 (914) 716-95-67	6409 932787	среднее	3020
Раиса	Соловьев	Ниловна	8 (922) 613-9737	4029 337860	среднее профессиональное	3021
Ратмир	Тарасов	Федосьевич	80186163005	3233 293784	среднее профессиональное	3022
Олег	Сазонова	\N	85033702171	9005 406150	среднее	3023
Александра	Князев	Феофанович	+7 220 516 7262	4911 614035	среднее	3024
Сидор	Осипов	\N	8 (447) 753-6107	8618 329809	среднее	3025
Прохор	Стрелков	Ерофеевич	+7 (791) 090-9685	8692 120114	\N	3026
Эмиль	Капустина	Архипович	81279589574	8852 471110	\N	3027
Виталий	Котова	\N	+7 (504) 486-5224	7870 855691	высшее	3028
Радим	Лобанова	\N	8 677 531 37 36	7167 787993	\N	3029
Клавдия	Одинцов	\N	8 (286) 974-0840	5489 665210	среднее профессиональное	3030
Эраст	Уварова	\N	83410803688	4660 743537	неоконченное высшее	3031
Варлаам	Воронов	Харитоновна	+7 074 625 00 74	4466 110217	среднее профессиональное	3032
Прокофий	Кузьмин	\N	+7 228 388 58 14	1736 778055	\N	3033
Парамон	Пономарева	\N	+77983058496	6948 451667	\N	3034
Евстигней	Зуев	Елизарович	+7 939 684 26 38	4849 864076	\N	3035
Трофим	Белова	\N	+7 399 802 1094	3892 748040	среднее	3036
Вячеслав	Лебедев	\N	+7 359 437 05 78	2146 110935	среднее	3037
Евпраксия	Лихачева	Феофанович	84233968152	6834 515409	среднее	3038
Ерофей	Комаров	Терентьевич	+7 (224) 439-7536	7739 167395	\N	3039
Наум	Сорокин	\N	84537790002	2594 667177	среднее	3040
Лонгин	Бобылева	\N	8 690 525 9756	1547 858934	среднее профессиональное	3041
Любосмысл	Прохорова	Степановна	8 (165) 556-96-74	8629 664612	\N	3042
Фома	Волков	\N	+7 306 607 2666	5803 927346	высшее	3043
София	Сидоров	\N	8 (580) 139-07-05	6060 424246	\N	3044
Никифор	Морозова	Игнатович	87375313151	6528 414436	\N	3045
Амвросий	Соколова	\N	+71222401343	2012 664593	неоконченное высшее	3046
Аникита	Иванов	\N	8 (600) 137-09-28	6548 554869	среднее профессиональное	3047
Акулина	Иванов	\N	+7 707 949 9201	1016 421511	высшее	3048
Серафим	Беляков	Артемьевич	8 (557) 620-8210	3053 804474	высшее	3049
Майя	Калашникова	Харлампьевич	8 373 923 40 58	4154 145773	\N	3050
Наум	Назаров	\N	8 (541) 317-5438	8522 990070	высшее	3051
Октябрина	Максимова	\N	8 (920) 652-35-28	1145 927848	высшее	3052
Исай	Титов	\N	8 556 271 41 98	6796 299133	неоконченное высшее	3053
Валерия	Федотова	\N	+73468289811	3644 119706	\N	3054
Ипат	Зуева	Георгиевич	8 (108) 486-06-15	4171 219806	среднее	3055
Лукьян	Ширяев	\N	+7 566 769 9578	6581 164080	неоконченное высшее	3056
Кондратий	Маслова	Фомич	85349059745	9353 662951	\N	3057
Остромир	Лихачева	Давидович	+73962397852	9634 155996	неоконченное высшее	3058
Казимир	Абрамова	Федосеевич	8 (347) 149-54-33	6555 988325	неоконченное высшее	3059
Филимон	Смирнова	\N	8 (473) 810-03-89	5589 890316	среднее	3060
Данила	Сорокина	\N	8 (897) 630-7255	6194 348173	высшее	3061
Еремей	Рожков	\N	8 705 465 69 45	9564 227304	высшее	3062
Антонина	Лаврентьева	Вячеславовна	+73995693465	2903 491725	среднее	3063
Радим	Рыбакова	\N	+7 (330) 477-4875	1612 995665	неоконченное высшее	3064
Осип	Петров	\N	8 534 543 7036	5143 402559	\N	3065
Ипполит	Власов	Валерианович	+7 (553) 803-79-15	8528 446291	среднее профессиональное	3066
Агап	Ершов	Антонович	+7 (158) 533-1970	5132 380216	неоконченное высшее	3067
Фёкла	Калинин	Анатольевич	+7 187 749 50 91	5767 319838	высшее	3068
Василиса	Афанасьев	Абрамович	8 343 612 2442	8844 960476	среднее	3069
Амвросий	Комиссарова	\N	84323262075	6194 136630	неоконченное высшее	3070
Виссарион	Орехов	Иларионович	+7 (751) 445-2141	4861 175729	высшее	3071
Радим	Шестаков	Фролович	+7 339 539 4316	4602 757187	высшее	3072
Иванна	Козлова	Афанасьевна	8 614 028 68 91	5502 673839	среднее профессиональное	3073
Милен	Доронина	Романовна	8 437 346 54 52	4909 674621	неоконченное высшее	3074
Пров	Колобов	Ерофеевич	+73060920960	6678 805857	высшее	3075
Георгий	Панфилова	Викторовна	+7 (994) 513-7642	5366 249536	высшее	3076
Владлен	Кудряшова	Рудольфовна	8 748 122 29 13	1447 915687	среднее	3077
Болеслав	Власова	\N	+7 (079) 608-4934	7551 224009	среднее	3078
Валерия	Моисеева	Гурьевич	8 725 885 69 56	5300 625190	среднее	3079
Герасим	Казакова	\N	+7 519 576 08 50	3078 359855	среднее профессиональное	3080
Полина	Сидоров	Олеговна	+7 (756) 823-52-62	6581 766456	\N	3081
Евстафий	Костин	\N	8 (458) 281-6238	4085 910878	высшее	3082
Филипп	Суханов	Венедиктович	+7 (650) 267-07-88	4429 947216	неоконченное высшее	3083
Филимон	Исаева	\N	+7 709 547 2609	2279 564149	\N	3084
Корнил	Макарова	\N	8 (354) 873-6995	6323 870534	среднее	3085
Кир	Богданов	\N	8 (207) 390-8615	5582 121137	высшее	3086
Софрон	Горбачев	Фадеевич	8 (847) 857-2013	1022 660125	\N	3087
Татьяна	Колесников	Игоревна	+7 332 609 35 48	1096 494830	\N	3088
Вероника	Никонов	Глебович	8 075 667 0498	2212 381322	среднее	3089
Панкрат	Князева	\N	+7 (606) 903-61-68	5486 797185	\N	3090
Фока	Тарасова	Харлампович	87597038547	7935 546149	\N	3091
Аверкий	Лебедев	Ефимовна	+7 664 625 72 57	5742 761119	высшее	3092
Прокофий	Суханова	Фёдорович	8 (019) 164-41-92	5519 331769	высшее	3093
Станислав	Селезнев	\N	83314994577	5140 339695	высшее	3094
Спартак	Сафонов	\N	81411000611	2020 535098	среднее	3095
Фотий	Рыбакова	\N	8 (005) 506-25-47	8236 741394	неоконченное высшее	3096
Ювеналий	Рогов	\N	8 (650) 128-4212	8389 613830	среднее профессиональное	3097
Савва	Родионова	Кузьминична	+7 (945) 969-6395	6231 587788	\N	3098
Фома	Сазонова	Геннадиевич	+7 433 094 99 68	9561 395375	неоконченное высшее	3099
Пахом	Богданова	\N	+7 (741) 823-8242	6589 828484	высшее	3100
Макар	Кулакова	Федотович	+70544973588	8612 498758	среднее	3228
Евстафий	Григорьева	Богдановна	+7 860 352 6758	9986 782358	среднее профессиональное	3101
Гордей	Лукина	Константиновна	+7 (629) 114-4159	1825 624586	высшее	3102
Авдей	Ильина	Федосьевич	87845280604	7296 510375	среднее	3103
Оксана	Евсеев	\N	+7 163 373 0056	8907 715863	среднее	3104
Венедикт	Лапин	\N	+76317856998	4994 744390	неоконченное высшее	3105
Платон	Мамонтов	\N	8 (150) 239-90-82	6772 810484	\N	3106
Лаврентий	Иванова	Гертрудович	8 (025) 130-09-54	8174 826737	среднее профессиональное	3107
Мефодий	Рябов	Игоревич	8 (083) 639-91-79	5895 614904	\N	3108
Никодим	Наумова	\N	+7 (925) 193-8709	2148 684862	высшее	3109
Фока	Колесникова	Демидович	+7 (921) 441-2234	1701 985172	среднее	3110
Лонгин	Зимина	Исидорович	8 967 611 43 20	6365 902682	среднее	3111
Милица	Блинов	\N	82074837039	9296 409634	среднее профессиональное	3112
Евгения	Рябов	\N	8 (072) 459-18-67	2313 728720	среднее профессиональное	3113
Милен	Титов	Елисеевич	+77066359004	9313 286776	\N	3114
Степан	Агафонов	\N	+7 963 198 84 40	3038 785220	высшее	3115
Елена	Гурьева	\N	8 (502) 847-30-60	8778 744032	среднее	3116
Изяслав	Воронов	\N	8 432 587 75 06	5503 890198	\N	3117
Аполлинарий	Бирюков	\N	+78139213647	5297 982439	среднее	3118
Прокл	Игнатов	Антонович	+7 (469) 121-89-35	5252 152198	\N	3119
Панкратий	Федоров	\N	8 576 697 94 05	2074 102110	среднее	3120
Лучезар	Сергеев	Тарасовна	+76774963576	5273 295312	\N	3121
Радим	Фокина	Григорьевна	8 (434) 929-6177	7313 581810	среднее	3122
Милица	Савельев	Алексеевна	+7 972 216 5370	4488 584449	среднее профессиональное	3123
Исай	Кошелев	\N	+7 991 637 67 74	8964 686787	среднее	3124
Аверкий	Емельянова	Ермилович	8 529 863 1347	1058 323231	среднее профессиональное	3125
Фадей	Поляков	\N	81734534560	7378 480689	\N	3126
Светлана	Мартынов	Абрамович	85903401156	9324 707445	среднее профессиональное	3127
Станислав	Орехов	\N	+73325596493	9585 613952	среднее профессиональное	3128
Тимур	Гришина	Павловна	+7 626 954 95 33	5427 130610	среднее профессиональное	3129
Агата	Дорофеев	Матвеевна	8 (162) 822-59-51	1801 476988	среднее профессиональное	3130
Тихон	Ширяева	Харитоновна	+7 (839) 516-32-38	6435 668838	высшее	3131
Мокей	Лаврентьева	\N	8 (844) 413-81-55	9458 447469	неоконченное высшее	3132
Исидор	Никитина	\N	+7 602 079 85 02	5124 747080	среднее	3133
Болеслав	Наумова	Трофимович	+79227632623	3029 666904	\N	3134
Лаврентий	Фролов	\N	+7 949 139 55 67	3667 188803	\N	3135
Ратибор	Артемьева	Кирилловна	8 (575) 142-11-48	8334 408197	\N	3136
Ия	Щукина	Ильясович	88096654547	9116 291139	среднее	3137
Наркис	Цветкова	Марсович	+7 566 040 12 66	4920 437233	неоконченное высшее	3138
Леонтий	Горбачев	\N	+7 152 743 8904	8837 910857	среднее профессиональное	3139
Карп	Белов	\N	+7 (384) 522-2146	2415 279342	среднее	3140
Каллистрат	Баранов	\N	+7 037 108 4380	6075 426005	высшее	3141
Гурий	Орехова	\N	+7 517 573 8739	7366 743366	среднее профессиональное	3142
Корнил	Федотов	\N	+7 455 378 80 49	2212 235120	\N	3143
Эдуард	Васильев	Евгеньевна	8 (140) 808-15-55	2875 488542	среднее профессиональное	3144
Петр	Кириллов	Гаврилович	8 259 110 46 04	8424 363630	неоконченное высшее	3145
Филипп	Рогов	Трифонович	87046794272	1510 828305	неоконченное высшее	3146
Олимпий	Ситникова	\N	+7 211 977 4190	4685 124469	неоконченное высшее	3147
Фотий	Гуляев	Евстигнеевич	8 (605) 493-76-73	1182 231104	высшее	3148
Василиса	Блохин	\N	+7 481 290 1199	5622 241471	среднее профессиональное	3149
Лонгин	Шарапов	\N	+79561598459	2748 762049	высшее	3150
Эрнст	Шубин	\N	+7 (990) 024-34-00	8226 481293	\N	3151
Полина	Соловьев	\N	8 117 068 72 90	3986 295298	неоконченное высшее	3152
Ким	Михеева	Владиславович	+7 226 696 8950	5451 332476	\N	3153
Гедеон	Сидорова	Игоревна	8 676 542 47 26	9778 205883	неоконченное высшее	3154
Лука	Корнилов	\N	87211168278	7327 178687	среднее профессиональное	3155
Герасим	Владимиров	Теймуразович	8 223 956 8518	1028 474064	неоконченное высшее	3156
Всеслав	Кошелева	\N	+75302305691	9955 153838	высшее	3157
Панкратий	Логинова	\N	88097455729	3429 363386	\N	3158
Панкратий	Мамонтова	Трифонович	8 469 397 13 62	2894 352526	неоконченное высшее	3159
Агата	Баранов	\N	8 055 434 6721	4212 589263	среднее	3160
Герман	Волкова	\N	8 123 014 3112	2086 268232	\N	3161
Станимир	Горбунов	\N	+7 916 798 4055	4292 494400	высшее	3162
Светлана	Воронов	\N	8 (035) 178-1263	1151 846641	неоконченное высшее	3163
Фирс	Лукин	\N	8 (369) 069-31-47	1244 118433	среднее профессиональное	3164
Панкратий	Макарова	\N	8 (555) 660-1397	4562 496384	\N	3165
Макар	Маркова	Федотович	8 714 088 53 49	3283 230240	среднее профессиональное	3166
Касьян	Лапина	\N	80594146998	8476 252434	\N	3167
Ананий	Наумова	\N	8 (256) 586-56-43	9062 142040	\N	3168
Лора	Воробьев	\N	+7 995 285 2760	1271 318218	\N	3169
Спиридон	Лыткин	\N	8 864 668 01 03	2564 198899	\N	3170
Кондрат	Юдин	Ярославович	8 (913) 474-1766	9883 882620	высшее	3171
Татьяна	Антонова	\N	+7 199 889 2769	2774 224054	высшее	3172
Илья	Борисова	Теймуразович	+7 269 373 90 55	2636 315363	высшее	3173
София	Самойлов	Богданович	+7 321 957 71 55	1147 576392	высшее	3174
Викентий	Горбунов	Данилович	+7 529 012 3396	8307 515058	высшее	3175
Гедеон	Мартынова	Аверьянович	8 032 981 98 85	8176 439257	среднее	3176
Фока	Силина	Макаровна	8 (945) 528-0094	7591 448912	среднее	3177
Анатолий	Морозов	Степановна	+7 (536) 533-5730	5404 117103	высшее	3178
Лавр	Игнатьева	Богдановна	8 (000) 088-1779	2853 987780	высшее	3179
Анастасия	Соловьева	\N	+7 826 341 35 88	9513 837174	среднее профессиональное	3180
Валерия	Кошелева	\N	8 623 641 76 88	7420 378991	высшее	3181
Руслан	Юдин	Ждановна	83585790007	1520 592343	\N	3182
Матвей	Щербакова	Афанасьевич	8 821 713 44 68	8865 510749	среднее профессиональное	3183
Герасим	Зыков	\N	8 052 665 81 34	9639 811740	\N	3184
Кузьма	Колобов	Тимуровна	+7 (027) 556-0620	2892 190655	среднее	3185
Селиван	Большакова	\N	8 (164) 362-5998	8318 169430	высшее	3186
Артемий	Терентьев	Дорофеевич	8 (680) 026-4293	4711 674852	среднее профессиональное	3187
Тарас	Рожков	Ивановна	+76931217988	8567 979047	высшее	3188
Любовь	Васильев	Александровна	+71443437878	3206 474383	среднее	3189
Викентий	Селезнева	\N	+7 484 670 26 23	5459 596090	высшее	3190
Феврония	Васильев	\N	+7 (756) 645-21-26	9461 767683	среднее	3191
Поликарп	Молчанов	Владимировна	+7 583 260 27 10	6176 820633	высшее	3192
Юрий	Авдеев	Кузьминична	8 368 024 2450	1702 455690	\N	3193
Софрон	Яковлева	Богдановна	8 223 203 8094	4749 570166	\N	3194
Творимир	Нестерова	Даниилович	8 (240) 867-9512	9917 638024	неоконченное высшее	3195
Валерьян	Григорьев	\N	+72262078115	2920 604670	среднее	3196
Агафон	Тарасов	Федотович	+76890228290	8027 311964	неоконченное высшее	3197
Павел	Пестов	\N	8 (854) 384-2446	3519 176994	среднее профессиональное	3198
Венедикт	Кошелев	\N	8 091 320 21 95	8909 863479	\N	3199
Валерия	Горбачева	\N	8 191 728 27 92	1336 452892	неоконченное высшее	3200
Пров	Соловьева	Евстигнеевич	89350286116	2211 590790	среднее	3201
Прохор	Мухина	\N	8 779 425 3124	6563 851592	неоконченное высшее	3202
Сократ	Максимов	\N	88701037212	2514 397799	\N	3203
Вышеслав	Якушев	\N	+7 (803) 420-05-14	6288 669781	\N	3204
Адам	Власова	Валерианович	80251100127	5105 123188	неоконченное высшее	3205
Евфросиния	Матвеев	\N	+72538156707	6095 794309	среднее профессиональное	3206
Филарет	Котов	Юлианович	8 903 295 12 21	4612 227330	\N	3207
Митофан	Гордеева	\N	8 (087) 642-76-86	9992 571135	среднее профессиональное	3208
Аверьян	Фадеева	\N	+7 582 203 19 84	7744 416213	неоконченное высшее	3209
Натан	Шилова	Алексеевич	+7 (285) 366-94-82	1723 437374	среднее профессиональное	3210
Алина	Беляев	\N	+72848949074	6816 993302	высшее	3211
Ксения	Кулагин	Николаевна	89289283860	7004 618379	неоконченное высшее	3212
Юрий	Борисова	\N	+7 (978) 617-4824	1428 697931	\N	3213
Валерьян	Михеева	\N	+7 (809) 613-91-65	3525 268829	\N	3214
Пимен	Максимов	Феликсович	8 627 256 9519	2555 403349	высшее	3215
Силантий	Семенов	Еремеевич	8 029 811 8685	1536 963557	\N	3216
Мартын	Семенова	\N	8 (634) 778-9448	7816 328800	неоконченное высшее	3217
Анжела	Семенова	\N	8 (278) 438-84-63	7252 719836	среднее	3218
Глеб	Кабанова	\N	8 (065) 244-64-69	7803 173879	среднее	3219
Матвей	Комиссаров	\N	+7 (667) 709-9481	3938 130511	неоконченное высшее	3220
Валентина	Нестеров	Елизарович	8 064 302 57 08	4828 779934	неоконченное высшее	3221
Фрол	Суханова	\N	+71261700355	7007 587812	среднее профессиональное	3222
Ираклий	Рябова	\N	+7 080 140 7533	8541 235922	неоконченное высшее	3223
Авксентий	Гуляев	\N	8 (486) 475-67-18	3653 329277	высшее	3224
Измаил	Казакова	\N	+7 815 775 42 90	9104 782718	среднее	3225
Максимильян	Родионова	Святославовна	88037805885	5104 166362	среднее	3226
Зиновий	Фролов	\N	8 390 030 45 44	2102 671513	среднее	3227
Сократ	Борисов	\N	8 (186) 257-8536	9849 617026	среднее профессиональное	3230
Родион	Гордеева	\N	80240364250	3955 543888	среднее	3231
Ефрем	Степанова	\N	+7 (669) 461-58-68	9170 649760	среднее профессиональное	3232
Родион	Шашкова	\N	8 (143) 374-4256	9766 256272	неоконченное высшее	3233
Венедикт	Тихонов	\N	8 489 979 6540	4286 996700	высшее	3234
Анисим	Кудрявцев	\N	8 (896) 517-92-21	3724 120408	неоконченное высшее	3235
Харитон	Кабанов	Артёмович	+7 586 882 64 13	4022 562346	среднее профессиональное	3236
Селиверст	Терентьев	\N	+73507336376	3387 572918	\N	3237
Василий	Миронова	Болеславовна	8 (330) 985-91-24	2629 876263	среднее профессиональное	3238
Гурий	Маркова	Елизарович	+7 (283) 011-69-92	4755 323978	среднее	3239
Прокофий	Юдина	Рудольфовна	+7 921 728 7162	4256 936989	среднее профессиональное	3240
Жанна	Фадеев	\N	+7 139 856 3568	4290 299730	\N	3241
Евграф	Крюкова	Ермолаевич	+7 745 451 9977	3236 779933	среднее	3242
Алексей	Власов	Антонович	8 (602) 491-33-12	7094 793267	высшее	3243
Модест	Капустина	\N	+7 520 771 68 88	4975 320647	высшее	3244
Тихон	Симонова	\N	+7 (829) 967-1069	5469 816120	среднее	3245
Никанор	Капустина	Тимофеевна	+7 002 203 7515	8806 344543	среднее	3246
Остап	Нестерова	Валерьянович	+7 (248) 733-5212	9437 312036	среднее профессиональное	3247
Глеб	Назарова	Антипович	8 (191) 734-0208	5493 166078	среднее	3248
Марфа	Веселов	\N	+7 266 482 4205	4209 205277	среднее	3249
Владимир	Носкова	Терентьевич	+7 (890) 513-1018	5478 214549	высшее	3250
Юлий	Логинов	\N	8 (909) 830-4282	8280 720141	среднее профессиональное	3251
Нонна	Коновалова	Филипповна	+7 065 004 54 82	5093 475660	высшее	3252
Милан	Александров	Измаилович	+7 889 794 1187	3635 151091	\N	3253
Феврония	Родионов	\N	+7 600 543 4928	6515 900333	среднее профессиональное	3254
Милица	Ершова	\N	+7 276 921 17 53	9077 965071	среднее	3255
Гаврила	Громова	Виленович	+7 418 870 3566	2907 135431	высшее	3256
Наркис	Красильников	\N	+75072109741	4933 551792	неоконченное высшее	3257
Ярослав	Красильникова	Зиновьевич	8 469 593 18 47	1148 174113	среднее профессиональное	3258
Ираклий	Ларионова	\N	8 186 541 6121	9871 167624	\N	3259
Силантий	Баранов	\N	8 (666) 657-8303	1466 814286	высшее	3260
Фока	Сазонов	\N	+74613826444	3961 122793	высшее	3261
Бронислав	Брагин	Фёдорович	8 (098) 442-23-94	5193 121582	\N	3262
Всемил	Родионов	\N	8 544 997 52 23	6440 545379	среднее профессиональное	3263
Галина	Савельев	\N	8 (672) 427-1369	2398 927701	среднее	3264
Рюрик	Кузьмин	Исидорович	8 (940) 393-54-68	5973 691416	высшее	3265
Раиса	Красильникова	Геннадиевна	8 184 679 7520	7512 389767	высшее	3266
Август	Игнатьева	\N	8 (301) 232-0316	7273 937799	\N	3267
Сидор	Одинцова	Елизарович	8 586 186 19 66	4949 591965	среднее	3268
Сидор	Калинина	Гордеевич	+7 638 042 0982	9582 114370	неоконченное высшее	3269
Всемил	Баранов	Борисович	8 810 632 21 46	6222 709237	среднее	3270
Раиса	Шубина	Вячеславовна	+7 (190) 631-28-06	3949 471017	среднее	3271
Сигизмунд	Воробьева	\N	8 (854) 221-01-97	6527 432006	среднее профессиональное	3272
Вацлав	Сысоев	Захаровна	8 346 331 60 40	3442 264344	высшее	3273
Федосий	Савина	Фадеевич	+7 (023) 140-07-27	2950 182075	высшее	3274
Артем	Федотова	Геннадьевна	+7 121 910 8623	6415 385653	высшее	3275
Бажен	Некрасов	Анатольевич	8 (176) 523-65-58	9163 454650	\N	3276
Мариан	Горбунов	Геннадьевна	+7 217 314 1250	1423 411438	\N	3277
Иларион	Воробьев	\N	+77813170265	9292 772695	высшее	3278
Харитон	Носков	Фокич	8 287 610 45 10	9812 678580	неоконченное высшее	3279
Марина	Цветкова	Гавриилович	8 711 338 90 26	8319 992463	\N	3280
Эмилия	Костин	Власович	+7 936 274 5050	6275 871224	неоконченное высшее	3281
Моисей	Комаров	\N	8 497 267 03 94	1367 694782	неоконченное высшее	3282
Ярополк	Филатова	Афанасьевна	+72025377678	4329 785409	высшее	3283
Марфа	Моисеева	Евсеевич	+75876441350	4327 114872	среднее	3284
Октябрина	Веселова	\N	8 (040) 505-1525	9843 290438	высшее	3285
Владислав	Абрамова	\N	+7 (652) 617-4376	7066 545969	среднее	3286
Устин	Колобов	\N	8 (797) 303-26-11	5197 230338	среднее профессиональное	3287
Агап	Богданова	Федоровна	8 (414) 708-80-34	4764 650278	среднее	3288
Милица	Дорофеева	\N	8 964 633 2727	3158 284172	среднее профессиональное	3289
Лукия	Симонова	Львовна	8 (841) 501-3764	3410 131351	среднее профессиональное	3290
Иван	Егоров	Феофанович	8 097 326 0537	2268 773504	\N	3291
Вениамин	Куликова	Константиновна	+7 (731) 642-8675	5365 920840	неоконченное высшее	3292
Лавр	Медведева	\N	+7 (205) 956-1885	4977 606277	среднее профессиональное	3293
Карп	Логинов	Трифонович	+7 (518) 797-2047	8596 333167	среднее профессиональное	3294
Изяслав	Цветкова	\N	+7 (781) 258-4799	1652 708727	неоконченное высшее	3295
Вероника	Наумов	\N	+7 186 850 02 65	8987 483678	высшее	3296
Артемий	Якушев	Владимировна	8 208 517 3009	3226 684497	\N	3297
Адриан	Красильникова	Романовна	8 707 198 9418	4001 753376	\N	3298
Мина	Михеев	\N	+7 929 899 28 90	3638 752520	неоконченное высшее	3299
Тит	Субботина	\N	+7 (665) 809-6561	3764 315814	среднее профессиональное	3300
Владислав	Петухов	\N	+7 566 338 22 89	3566 593207	\N	3301
Аникита	Елисеева	Леонидовна	+7 805 816 17 09	1046 738454	неоконченное высшее	3302
Куприян	Галкина	Александровна	+7 692 411 92 50	1543 923608	среднее	3303
Иннокентий	Сергеева	\N	+7 (294) 270-41-07	4549 726719	высшее	3304
Ипполит	Сафонова	\N	8 348 584 1628	2472 497822	среднее профессиональное	3305
Пелагея	Мельников	Тихонович	+7 (121) 192-5667	8615 308361	высшее	3306
Фома	Овчинников	Артёмович	8 (410) 199-27-82	4523 380337	среднее профессиональное	3307
Юлий	Дмитриев	\N	+7 (786) 652-48-96	5600 962133	\N	3308
Исидор	Петрова	Мироновна	8 979 594 6709	3644 190439	высшее	3309
Епифан	Смирнова	Иосифович	8 (447) 590-2282	7984 639204	среднее	3310
Клавдий	Антонова	Ефремович	+7 606 065 41 30	4840 654016	среднее	3311
Гостомысл	Воронцова	\N	+7 173 616 26 15	3544 811874	высшее	3312
Святополк	Комиссаров	Абрамович	+7 683 638 34 44	3979 987130	среднее	3313
Федот	Коновалов	Гаврилович	+7 780 452 0001	1007 925354	среднее профессиональное	3314
Ульяна	Мамонтова	Игнатович	8 (671) 768-0320	5022 291545	неоконченное высшее	3315
Авксентий	Данилова	Тарасовна	+7 528 345 24 94	9852 798618	неоконченное высшее	3316
Эдуард	Юдина	Вячеславовна	8 (974) 944-27-88	3033 532435	среднее профессиональное	3317
Игорь	Наумов	Иосипович	85376636956	9887 318407	высшее	3318
Ия	Ермакова	Владимировна	8 (938) 207-4691	2568 656032	среднее профессиональное	3319
Добромысл	Богданов	Львовна	8 (013) 957-99-39	4927 433453	\N	3320
Януарий	Вишняков	Владиленович	8 (498) 921-1815	2092 225665	среднее профессиональное	3321
Сидор	Артемьева	Терентьевич	89192139401	5523 884293	среднее профессиональное	3322
Парфен	Прохоров	\N	8 (081) 805-8016	2938 422983	среднее профессиональное	3323
Радим	Степанов	\N	+7 (099) 682-7480	2727 690092	среднее профессиональное	3324
Ермолай	Шарова	\N	+7 (408) 084-2974	9860 416576	\N	3325
Ульян	Виноградов	Феофанович	+7 (471) 594-5432	2006 999682	среднее профессиональное	3326
Ипат	Никифорова	Фомич	+7 (242) 389-7522	4378 199540	среднее профессиональное	3327
Клавдия	Давыдова	\N	88077971750	3161 826281	среднее профессиональное	3328
Пелагея	Кононов	Егоровна	+7 074 952 5512	8660 301343	среднее профессиональное	3329
Виктор	Кузьмин	\N	8 (673) 358-12-55	1909 813513	среднее профессиональное	3330
Эрнст	Гурьева	\N	8 (914) 583-8635	8443 780608	неоконченное высшее	3331
Валерьян	Щербаков	Эдуардовна	+7 509 611 99 25	1213 511018	высшее	3332
Ипполит	Игнатов	Тарасович	+7 (835) 455-40-46	9168 630786	высшее	3333
Евпраксия	Гришин	Димитриевич	+7 (027) 576-0198	5864 105267	\N	3334
Валерия	Гришин	Антоновна	8 027 725 3306	3588 334898	среднее	3335
Мариан	Ермакова	Евсеевич	8 453 947 55 78	6151 531685	\N	3336
Екатерина	Гущина	\N	8 301 752 1055	2645 467898	высшее	3337
Игорь	Кондратьева	Ааронович	8 679 186 3157	3174 652066	среднее профессиональное	3338
Кирилл	Суханова	\N	8 (949) 242-01-08	2457 989907	неоконченное высшее	3339
Серафим	Мартынов	Святославовна	8 955 493 17 22	1094 331497	среднее	3340
Фёкла	Беляев	\N	+7 335 009 1194	6441 528844	высшее	3341
Людмила	Гусев	\N	8 (693) 505-03-30	8715 160821	среднее	3342
Святополк	Сазонова	\N	+7 164 863 5632	9380 319800	высшее	3343
Наталья	Бобылева	Юльевна	+7 055 202 76 56	4913 977885	среднее профессиональное	3344
Станислав	Макарова	Абрамович	+7 (255) 306-3331	7912 794167	высшее	3345
Любосмысл	Рожков	Егоровна	8 230 827 5638	2245 996221	высшее	3346
Поликарп	Турова	\N	8 (877) 925-0937	5960 783618	\N	3347
Никандр	Симонов	Артемьевич	+79548658327	9459 434077	среднее	3348
Роман	Воронова	\N	86454019944	4951 486612	среднее профессиональное	3349
Пантелеймон	Гордеева	Павловна	+72190459051	6649 646109	\N	3350
Иларион	Шубина	\N	+7 960 657 83 88	2454 606511	высшее	3351
Эмилия	Хохлова	\N	+7 (061) 596-29-60	1757 377648	\N	3352
Милован	Евсеева	\N	8 473 956 5153	9605 513912	среднее	3353
Сидор	Мясникова	Николаевна	89058011076	6828 428500	среднее профессиональное	3354
Капитон	Меркушева	Александрович	+76329701240	8702 241018	\N	3355
Жанна	Кудряшова	\N	8 814 027 0131	3836 211288	\N	3356
Анна	Тихонова	Васильевич	8 425 955 35 16	2182 938488	неоконченное высшее	3357
Михей	Белозеров	Владиславовна	84616705231	1585 369607	неоконченное высшее	3358
Парфен	Васильев	\N	+7 (425) 260-08-06	2699 545117	среднее профессиональное	3359
Радислав	Александрова	\N	+77039416830	7286 559763	среднее профессиональное	3360
Евстафий	Анисимов	\N	+7 (871) 901-15-28	2778 765299	среднее профессиональное	3361
Фока	Исаев	\N	8 184 081 58 74	9040 508775	высшее	3362
Регина	Сысоева	Гурьевич	+78448807938	6831 407281	\N	3363
Никита	Лихачева	Германович	88425335762	5840 114189	среднее	3364
Евпраксия	Носова	Захаровна	+7 (064) 121-9971	7933 104529	неоконченное высшее	3365
Евстигней	Лыткина	\N	+7 (865) 753-6551	4192 486253	неоконченное высшее	3366
Касьян	Крюков	\N	+7 757 503 5600	8071 348535	неоконченное высшее	3367
Климент	Андреева	Чеславович	8 (417) 734-6671	6718 780243	неоконченное высшее	3368
Феофан	Ильин	\N	8 967 021 9398	5929 970161	высшее	3369
Кондратий	Осипова	Владимировна	+79836583263	9853 879004	неоконченное высшее	3370
Нонна	Аксенова	Адамович	+7 210 550 5683	4128 696070	среднее профессиональное	3371
Кондрат	Мельников	Олеговна	+7 310 525 21 67	5369 673690	высшее	3372
Всемил	Лебедева	Владиленович	+73127709929	9921 138649	среднее	3373
Иван	Терентьева	\N	84449191072	7832 102692	среднее	3374
Алина	Кулакова	Якубович	8 (490) 872-38-31	2828 938606	среднее профессиональное	3375
Наум	Никонова	Тимуровна	+75806168075	4643 826138	среднее профессиональное	3376
Ананий	Шилова	\N	+7 077 531 60 03	3129 447732	среднее	3377
Ерофей	Мишина	Вилорович	+7 (516) 800-70-36	3709 967565	высшее	3378
Варвара	Беляева	Артурович	8 (537) 539-15-49	5914 213628	высшее	3379
Корнил	Беспалов	\N	+78069142029	8660 299530	\N	3380
Иван	Дорофеев	\N	85064072245	8008 165947	высшее	3381
Панфил	Самойлова	Марсович	8 (595) 726-73-53	2488 134811	среднее	3382
Милен	Гаврилова	Всеволодович	8 (533) 022-0917	8087 282430	неоконченное высшее	3383
Мартын	Лукина	Ефремович	+71752240147	4148 100068	\N	3384
Поликарп	Рожков	\N	86106856223	1272 330929	неоконченное высшее	3385
Федот	Колобов	Фадеевич	88103501953	1520 921142	\N	3386
Венедикт	Красильникова	\N	8 819 661 8790	9057 656810	среднее профессиональное	3387
Ярослав	Павлова	\N	8 274 031 93 21	6551 581635	высшее	3388
Артемий	Зиновьев	\N	8 032 976 83 92	2502 762630	среднее	3389
Рубен	Алексеева	\N	8 (151) 839-83-18	4929 546473	среднее профессиональное	3390
Милен	Князева	Гертрудович	8 (159) 467-08-13	4123 386911	высшее	3391
Ерофей	Сазонова	Романовна	8 475 575 73 13	1016 944270	среднее	3392
Касьян	Архипов	\N	8 879 333 81 59	4896 248783	неоконченное высшее	3393
Аполлинарий	Авдеева	\N	8 (749) 777-0095	6928 877475	\N	3394
Тимофей	Иванов	\N	8 647 634 92 36	5851 896565	неоконченное высшее	3395
Богдан	Савельев	Анисимович	+7 583 357 1916	6343 870602	высшее	3396
Ипат	Евдокимов	\N	8 (715) 923-96-99	5381 582413	высшее	3397
Порфирий	Евсеев	Якубович	8 (381) 518-2384	2935 935419	\N	3398
Модест	Гордеев	\N	+7 020 377 9529	9817 890861	неоконченное высшее	3399
Демьян	Некрасова	\N	+76205159847	5559 608450	среднее профессиональное	3400
Твердислав	Горбунов	Фокич	+7 881 781 84 25	5929 748838	высшее	3401
Нестор	Кудряшова	Юльевна	8 054 540 59 11	6564 386527	среднее профессиональное	3402
Платон	Суворова	\N	+7 (531) 539-82-22	9163 844075	среднее	3403
Лев	Якушева	\N	+7 (594) 870-0266	9797 361212	\N	3404
Мечислав	Беляков	\N	8 379 127 77 75	5797 541100	неоконченное высшее	3405
Поликарп	Копылова	Харитоновна	+7 847 537 20 83	7468 161908	высшее	3406
Анжелика	Герасимов	Андреевич	+7 737 183 0122	3265 555531	высшее	3407
Викентий	Носков	Валентинович	+74817672974	2450 886609	\N	3408
Леон	Куликов	\N	8 227 760 09 27	5899 733462	высшее	3409
Савватий	Лукин	\N	8 (200) 539-82-86	5076 177564	\N	3410
Эрнест	Сорокин	\N	+7 767 158 79 99	8710 751733	среднее профессиональное	3411
Самуил	Лихачев	Богданович	+7 (056) 689-0630	2461 421522	среднее	3412
Ксения	Смирнова	\N	+7 (539) 470-34-37	7658 620827	\N	6599
Пров	Евдокимова	Борисовна	85813202590	2187 524620	среднее	3413
Любовь	Герасимов	\N	8 581 604 32 03	5132 484811	высшее	3414
Надежда	Лыткин	Львовна	+7 (472) 033-42-90	1809 105232	среднее	3415
Елизавета	Одинцова	\N	+7 453 524 2283	9838 412843	неоконченное высшее	3416
Василиса	Соловьев	Михайловна	+7 806 660 02 69	9949 721785	среднее	3417
Серафим	Бирюкова	\N	+7 827 583 39 64	9839 390281	неоконченное высшее	3418
Наум	Самойлова	Еремеевич	88792393259	6584 488035	неоконченное высшее	3419
Ратибор	Воронцова	Степановна	89677119200	4030 452284	среднее профессиональное	3420
Нина	Доронин	Архипович	80933287292	5329 154225	неоконченное высшее	3421
Вероника	Карпова	Константиновна	8 672 688 0244	4469 953643	\N	3422
Клавдий	Полякова	\N	8 (535) 118-29-41	5097 306537	неоконченное высшее	3423
Ян	Агафонова	\N	8 654 473 73 51	4326 523039	\N	3424
Родион	Копылова	\N	8 (491) 192-9385	5934 304492	\N	3425
Мстислав	Крюков	Леонидовна	+7 (920) 635-37-56	8225 583698	среднее профессиональное	3426
Филарет	Шарапова	Архиповна	+7 (163) 270-5901	2331 614498	неоконченное высшее	3427
Леон	Якушева	Еремеевич	8 306 323 3956	4488 105525	среднее профессиональное	3428
Федосий	Устинов	\N	80565634303	8759 847044	\N	3429
Валерий	Пестов	\N	8 (612) 112-96-29	2584 577195	среднее профессиональное	3430
Мирослав	Логинова	\N	+7 477 566 2492	5901 431710	неоконченное высшее	3431
Милован	Якушева	\N	87009028372	3227 530304	высшее	3432
Феофан	Рожкова	\N	+7 (892) 622-4642	1146 770826	среднее	3433
Пимен	Куликов	Германович	+7 388 298 4653	9704 981679	неоконченное высшее	3434
Феоктист	Горбунов	\N	+7 548 418 67 41	8977 271828	\N	3435
Алексей	Чернова	Геннадиевич	8 (329) 077-79-21	3647 226417	\N	3436
Лариса	Зайцева	Афанасьевич	+7 (080) 082-92-01	5472 471900	высшее	3437
Галина	Пономарев	\N	+7 679 554 36 63	3335 840176	среднее	3438
Аскольд	Волков	Болеславовна	8 (945) 502-33-92	4754 653227	высшее	3439
Остромир	Петухова	\N	+7 265 230 50 72	1017 946212	\N	3440
Валентин	Белов	\N	8 (028) 555-10-46	2653 297171	среднее профессиональное	3441
Егор	Кондратьев	Федоровна	+73580686081	3503 404537	неоконченное высшее	3442
Сергей	Куликов	\N	8 496 039 5474	4106 328908	высшее	3443
Софрон	Кузьмина	\N	+7 099 179 27 15	2074 612650	высшее	3444
Эмилия	Захаров	\N	8 (780) 654-4621	8714 130549	среднее профессиональное	3445
Аверьян	Комиссаров	\N	82464879884	5189 748766	высшее	3446
Михей	Кошелева	Анатольевич	+79084796310	4393 818454	среднее	3447
Ратибор	Власова	\N	+7 591 284 42 14	6745 110492	среднее	3448
Милен	Кононова	Матвеевна	8 (200) 503-64-30	6071 130917	среднее профессиональное	3449
Викентий	Кудряшова	Германович	+7 555 654 62 74	8681 274403	\N	3450
Евпраксия	Колобов	\N	+7 445 405 1079	6128 849007	среднее профессиональное	3451
Рюрик	Стрелкова	\N	8 (905) 691-4576	4588 965151	среднее	3452
Федот	Федотов	Эдуардовна	+7 626 541 9044	9029 500860	\N	3453
Вероника	Бирюков	Георгиевич	8 787 259 6080	8875 774208	неоконченное высшее	3454
Всемил	Зайцев	\N	8 (090) 781-86-27	1926 711490	среднее профессиональное	3455
Нина	Пономарев	Архипович	+7 (676) 126-8070	2831 442237	\N	3456
Ратмир	Бобылева	\N	8 392 854 51 88	2243 409922	среднее профессиональное	3457
Вацлав	Колобов	\N	+7 (656) 685-3603	1662 142342	\N	3458
Христофор	Игнатьева	Матвеевич	+7 (838) 370-4191	6113 798129	неоконченное высшее	3459
Евграф	Максимова	Феофанович	+7 (465) 796-1927	1441 703213	неоконченное высшее	3460
Амос	Зайцев	\N	+76053496662	2651 620809	среднее профессиональное	3461
Силантий	Шарова	Константиновна	8 (719) 863-5560	9838 644963	среднее профессиональное	3462
Сигизмунд	Петрова	Михайловна	8 (886) 295-04-19	1452 361127	среднее	3463
Алина	Захаров	Львовна	+75834835609	2855 499498	неоконченное высшее	3464
Лука	Лукина	\N	+7 (263) 752-88-53	7464 569357	\N	3465
Савва	Киселев	Аверьянович	+7 (939) 493-04-56	9531 680759	среднее	3466
Мир	Евдокимова	\N	8 485 043 8829	9745 499896	среднее	3467
Велимир	Горшкова	\N	8 (383) 564-13-69	2581 200235	неоконченное высшее	3468
Назар	Мартынов	Юльевна	+7 (744) 555-6018	1926 823355	среднее профессиональное	3469
Екатерина	Фокина	Ждановна	8 537 358 9742	8059 380472	неоконченное высшее	3470
Лучезар	Ковалева	Георгиевна	+7 206 261 3778	4570 423486	высшее	3471
Тамара	Виноградова	\N	8 846 648 1782	1045 470242	\N	3472
Амвросий	Казаков	\N	+74469334886	8225 162577	высшее	3473
Евдокия	Павлова	Филимонович	82080573591	7147 274225	\N	3474
Амвросий	Рыбакова	\N	8 (512) 368-47-34	3039 647724	среднее профессиональное	3476
Лонгин	Буров	Глебович	8 (479) 111-84-15	9147 278707	среднее профессиональное	3477
Зинаида	Маслова	Макаровна	+7 194 166 15 37	8949 552171	среднее	3478
Виктория	Степанов	Вилорович	8 (471) 082-33-53	7733 654141	неоконченное высшее	3479
Лукия	Яковлева	\N	8 (850) 415-05-78	5417 291431	\N	3480
Ипполит	Пономарев	Терентьевич	+76312275894	5563 274927	среднее	3481
Ювеналий	Кошелева	Викентьевич	8 067 962 8538	6732 950121	\N	3482
Надежда	Капустин	\N	+7 (424) 595-0401	7316 775912	среднее	3483
Елизар	Матвеев	Владленович	8 418 510 2988	6879 455555	\N	3484
Марина	Дементьева	Аксёнович	+7 494 455 21 41	2579 120208	\N	3485
Исидор	Богданова	Геннадьевна	82481620683	5798 565087	среднее профессиональное	3486
Виталий	Лукин	Дорофеевич	8 744 134 9510	4656 503895	среднее профессиональное	3487
Марк	Рябова	\N	+70195054175	1542 621282	среднее	3488
Рюрик	Устинов	Федосеевич	8 (954) 517-4247	3038 182923	\N	3489
Натан	Тарасов	Якубович	+7 252 116 3115	1823 306905	\N	3490
Аполлон	Смирнова	Афанасьевна	+7 082 758 12 18	5314 244009	неоконченное высшее	3491
Аникита	Буров	\N	88603837186	1183 476788	неоконченное высшее	3492
Агата	Лукина	\N	+7 (228) 413-9114	5906 730949	высшее	3493
Надежда	Ефимов	\N	+78127661187	7515 324043	высшее	3494
Светлана	Кондратьев	\N	+7 751 159 4811	1265 611446	\N	3495
Вышеслав	Панова	\N	81345871321	6411 272969	среднее профессиональное	3496
Самсон	Бобылева	\N	+79675760500	4642 178148	\N	3497
Максим	Стрелков	\N	+7 830 159 05 37	2053 915593	среднее	3498
Оксана	Сафонов	\N	8 132 659 03 58	7205 601241	высшее	3499
Фирс	Федосеева	Игоревна	8 145 917 66 07	1883 605289	среднее профессиональное	3500
Илья	Киселева	\N	+7 785 945 09 42	4841 810258	высшее	3501
Климент	Назаров	Гавриилович	+7 (098) 012-2213	2468 476724	высшее	3502
Андрон	Терентьев	Всеволодович	+7 180 912 3647	6732 178259	высшее	3503
Леонид	Мишина	\N	+79008211602	2791 305058	среднее профессиональное	3504
Иннокентий	Большакова	\N	8 (053) 975-1731	9745 566339	среднее профессиональное	3505
Мариан	Савельев	\N	8 551 302 8675	3515 197988	среднее	3506
Лев	Попова	Артёмович	+7 (818) 599-72-72	5261 662277	неоконченное высшее	3507
Фотий	Семенова	Филатович	8 (463) 153-5944	9176 219176	среднее профессиональное	3508
Святослав	Никифорова	Феофанович	+70698940170	4223 682787	высшее	3509
Флорентин	Кулагин	\N	8 (887) 452-62-71	2582 364382	среднее	3510
Евстафий	Евсеев	\N	89488743010	4398 605252	среднее	3511
Агата	Кононов	\N	8 593 931 0982	9424 816123	неоконченное высшее	3512
Марина	Игнатьева	\N	+7 (280) 687-6800	7223 481762	высшее	3513
Мечислав	Мельникова	\N	8 (511) 025-0089	9821 961515	среднее	3514
Мария	Захаров	\N	+74700193140	5257 946436	\N	3515
Митофан	Ершова	Антоновна	+7 224 852 2567	6857 325721	среднее	3516
Ермолай	Соболев	\N	+7 268 094 92 08	6864 496506	\N	3517
Ростислав	Шарапова	Адрианович	+7 (953) 851-66-24	4571 281491	высшее	3518
Фаина	Ефимова	Германович	8 505 683 2901	9365 671001	среднее профессиональное	3519
Павел	Савельев	\N	+7 893 577 68 26	3899 218798	\N	3520
Мариан	Гуляева	Захаровна	+7 762 822 1036	5619 301128	\N	3521
Карп	Полякова	\N	+7 (257) 814-1182	5547 651190	\N	3522
Кондрат	Артемьева	\N	+7 997 436 7774	2365 541365	неоконченное высшее	3523
Ипат	Абрамов	Антипович	8 (870) 121-5037	6923 773669	\N	3524
Дарья	Новикова	\N	+7 (269) 004-3002	4985 249892	высшее	3525
Анна	Матвеева	\N	8 072 918 98 38	6683 712656	среднее	3526
Эраст	Устинова	Вениаминовна	82500678443	8262 874707	неоконченное высшее	3527
Милен	Лихачев	Станиславовна	+7 579 796 5318	9830 451627	\N	3528
Игнатий	Титов	Анисимович	+7 (904) 700-97-86	7861 815310	\N	3529
Евсей	Ефимов	Данилович	+7 316 318 98 08	8438 916742	\N	3530
Емельян	Шилова	Вениаминовна	+7 325 797 08 16	3666 743503	среднее	3531
Денис	Петров	Филиппович	+77433626228	1327 480390	высшее	3532
Иван	Сидоров	\N	8 (049) 536-75-71	2335 277331	неоконченное высшее	3533
Аверкий	Михеев	\N	+78058049101	7073 519463	неоконченное высшее	3534
Павел	Соловьева	Исидорович	83625096785	3135 399149	\N	3535
Ипполит	Шилов	Виленович	+7 (512) 641-4938	7947 106859	неоконченное высшее	3536
Фока	Шарапова	Юлианович	8 216 880 99 26	3560 923473	неоконченное высшее	3537
Эмиль	Антонов	Тихонович	+77667226253	4276 368120	высшее	3538
Людмила	Гущин	\N	8 852 178 6759	9675 346418	среднее	3539
Лонгин	Евдокимова	Дмитриевна	+7 (062) 597-5193	7448 626369	\N	3540
Савелий	Кондратьева	\N	+73026613112	3173 130426	высшее	3541
Федот	Бурова	\N	+7 (336) 643-7305	4935 265443	высшее	3542
Лука	Юдина	\N	8 (754) 272-2647	3982 165984	высшее	3543
Борислав	Кондратьева	Алексеевна	8 (493) 937-33-77	2631 751447	\N	3544
Светлана	Гущина	\N	8 975 699 70 39	6149 231127	неоконченное высшее	3545
Викентий	Архипов	\N	+7 (842) 020-4719	8589 169755	среднее профессиональное	3546
Полина	Хохлова	\N	8 304 471 7157	1408 288134	высшее	3547
Соломон	Михайлова	\N	8 (829) 168-9453	9723 918456	\N	3548
Герман	Пестова	Владимировна	+7 488 866 1314	6143 642487	неоконченное высшее	3549
Светозар	Гордеева	\N	+7 061 307 0246	7551 650596	среднее	3550
Прохор	Емельянов	Тимурович	8 (250) 597-60-84	7465 851719	\N	3551
Ираклий	Максимов	Филатович	+7 (469) 754-7494	6787 271552	\N	3552
Моисей	Ширяева	\N	8 232 238 5034	7429 978722	высшее	3553
Симон	Быков	\N	+7 029 862 21 52	9673 785540	среднее	3554
Адриан	Селезнева	Юлианович	8 278 691 6627	7276 339867	среднее	3555
Мартын	Мартынов	\N	+7 628 995 4337	5282 133927	высшее	3556
Ратибор	Селезнева	\N	+7 098 975 3746	7769 298970	\N	3557
Виктор	Соколов	\N	8 (855) 875-60-63	8462 282198	\N	3558
Наина	Зуева	\N	8 (907) 410-53-71	7891 665285	среднее	3559
Юлия	Щукин	\N	8 093 338 97 14	3817 332673	среднее	3560
Самуил	Кулакова	\N	8 (869) 035-6578	1592 598335	неоконченное высшее	3561
Исидор	Крюкова	Аскольдовна	8 538 598 3680	5926 475820	высшее	3562
Ангелина	Тимофеева	Леонидовна	+7 249 739 76 61	9233 381214	неоконченное высшее	3563
Никодим	Козлова	\N	+7 (188) 711-2769	3552 771147	\N	3564
Дарья	Ширяев	\N	+7 (539) 560-1358	5240 323907	высшее	3565
Ян	Денисова	Измаилович	+7 (137) 643-4213	9907 162692	\N	3566
Анисим	Одинцов	Гаврилович	+74122966910	2916 793975	среднее	3567
Мир	Полякова	\N	+7 675 175 0946	4552 239175	\N	3568
Татьяна	Марков	\N	8 (749) 351-59-49	6793 410885	среднее профессиональное	3569
Евпраксия	Дьячков	Ааронович	8 (985) 263-57-50	1728 385249	высшее	3570
Владислав	Давыдова	Егорович	+71267318129	6408 490241	высшее	3571
Нина	Никифорова	Вадимовна	+7 699 278 41 32	4177 362375	\N	3572
Демьян	Воронов	Оскаровна	+7 (756) 255-92-66	6981 245862	неоконченное высшее	3573
Игнатий	Давыдова	\N	+7 454 216 3073	7810 763970	среднее профессиональное	3574
Севастьян	Крюков	Валентиновна	+7 (317) 156-33-32	3867 717348	высшее	3575
Измаил	Ермакова	Феоктистович	+7 392 110 63 79	6170 408459	\N	3576
Вышеслав	Суворов	\N	8 (041) 676-7221	8390 349311	среднее профессиональное	3577
Лев	Осипов	\N	+7 134 246 6215	9192 881652	среднее профессиональное	3578
Аникей	Брагина	\N	+7 (992) 230-01-81	2319 991054	\N	3579
Софон	Медведева	\N	8 (057) 945-19-52	3090 447380	\N	3580
Олег	Брагина	Харлампович	88227289603	5570 187901	\N	3581
Валерий	Емельянова	Геннадиевич	89843785972	1515 581682	среднее профессиональное	3582
Лев	Никифоров	Германович	83343134890	2813 278570	среднее профессиональное	3583
Мстислав	Туров	Гордеевич	+77833832175	8699 925847	среднее профессиональное	3584
Эмилия	Никонова	Игоревич	81166127735	5045 128136	неоконченное высшее	3585
Сильвестр	Пахомов	\N	80067073633	9642 901991	неоконченное высшее	3586
Панкрат	Тарасова	\N	8 (088) 696-24-84	1835 243321	среднее	3587
Нина	Павлова	Фёдорович	+7 (771) 419-71-64	7381 412649	среднее	3588
Ипполит	Журавлев	\N	8 (174) 637-49-37	9203 258694	\N	3589
Аверкий	Никитина	\N	+7 166 502 2000	5693 490350	неоконченное высшее	3590
Сократ	Медведев	\N	+7 784 859 0783	2310 631095	среднее профессиональное	3591
Лучезар	Калашников	Демидович	+7 (409) 616-8690	8759 331157	неоконченное высшее	3592
Владлен	Селезнева	\N	+7 (790) 754-8105	4795 590278	высшее	3593
Эмилия	Громова	Тимурович	+72045416218	8911 896376	высшее	3594
Вацлав	Ковалев	\N	84979289336	8845 908827	высшее	3595
Раиса	Прохорова	Эдуардовна	+7 (642) 371-2068	8510 934945	среднее профессиональное	3596
Амвросий	Кириллов	\N	8 (830) 473-1022	5093 266118	среднее профессиональное	3597
Милован	Фролов	\N	+7 966 620 2074	5522 436664	неоконченное высшее	3598
Нестор	Павлова	Геннадиевна	+7 677 638 38 95	6203 613972	среднее профессиональное	3599
Николай	Тетерин	\N	8 (024) 228-4933	2396 671658	среднее профессиональное	3600
Тарас	Симонова	\N	85660642102	4137 372610	среднее	3601
Ангелина	Стрелков	Артемовна	+7 (058) 982-5135	7033 888280	среднее профессиональное	3602
Селиван	Громова	Алексеевич	8 (260) 435-32-93	7387 259364	среднее	3603
Светлана	Афанасьева	\N	8 541 903 8308	1069 340561	неоконченное высшее	3604
Надежда	Агафонов	\N	+7 260 510 35 56	4569 247001	неоконченное высшее	3605
Панфил	Суханов	\N	+7 (866) 674-78-27	5399 180911	среднее профессиональное	3606
Всемил	Дмитриев	Аркадьевна	+7 747 505 5745	6171 218798	неоконченное высшее	3607
Регина	Морозова	\N	+7 237 865 1754	8106 594619	среднее профессиональное	3608
Агап	Харитонова	Аркадьевна	8 (016) 594-94-76	6891 977468	неоконченное высшее	3609
Василиса	Рябов	Викторович	8 340 868 40 24	7826 827615	неоконченное высшее	3610
Эдуард	Щукин	\N	8 (102) 182-32-42	4492 266643	среднее профессиональное	3611
Маргарита	Якушев	Данилович	8 (859) 306-6504	2313 905691	неоконченное высшее	3612
Аникей	Казаков	Яковлевна	8 (741) 082-31-68	2079 988763	\N	3613
Афанасий	Тарасов	\N	+7 (695) 917-8726	6849 181224	\N	3614
Евграф	Филиппова	\N	+7 (782) 862-57-47	2164 937301	среднее	3615
Поликарп	Зайцев	Юлианович	8 292 832 3988	9803 982721	среднее	3616
Силантий	Сазонов	\N	8 (919) 611-03-70	2491 198666	среднее	3617
Мария	Корнилов	\N	+7 (606) 436-84-21	5040 682979	высшее	3618
Елизар	Терентьев	\N	8 (084) 169-7191	1932 554386	\N	3619
Виктория	Корнилов	\N	+7 (031) 058-72-97	7270 604400	высшее	3620
Тит	Гаврилова	\N	+7 (449) 037-5328	9115 390621	высшее	3621
Никита	Родионов	Бориславович	+7 868 295 0708	4364 283836	\N	3622
Ерофей	Жданов	\N	+7 (548) 126-9838	2266 158383	неоконченное высшее	3623
Филимон	Кудрявцев	Арсеньевич	8 479 067 90 85	2509 905207	\N	3624
Зиновий	Авдеева	Игоревна	8 (436) 221-16-00	5377 976799	высшее	3625
Ксения	Фомичев	Ефимовна	+7 (915) 506-5653	5175 108791	неоконченное высшее	3626
Николай	Сазонов	Григорьевна	8 (767) 901-9067	2693 883007	высшее	3627
Касьян	Зимин	Германович	+7 668 631 6207	5808 575014	среднее	3628
Емельян	Цветков	Фомич	+7 (147) 301-3909	8829 407280	высшее	3629
Любомир	Блохина	Федосеевич	8 146 359 07 96	1783 419419	высшее	3630
Октябрина	Кошелева	Владиславович	+7 345 635 4565	8199 806756	\N	3631
Кира	Капустина	\N	8 734 215 79 21	1387 361267	среднее	3632
Вацлав	Лыткина	\N	+7 745 929 1157	7169 772418	среднее профессиональное	3633
Всеслав	Макарова	Богдановна	8 187 088 0594	7689 930938	\N	3634
Любомир	Корнилов	Рудольфовна	+7 287 913 0918	9017 259468	\N	3635
Ладислав	Рогова	\N	8 673 713 1638	1207 382474	\N	3636
Анжелика	Константинова	Евсеевич	+70212217649	3303 725854	\N	3637
Аникей	Некрасова	\N	+7 (349) 177-8622	7624 449741	среднее профессиональное	3638
Василиса	Яковлева	Валериевна	+7 (125) 638-47-12	1986 246007	\N	3639
Исай	Жданов	\N	+7 (339) 327-04-19	2997 664097	неоконченное высшее	3640
Любомир	Жданова	Августович	8 193 616 6152	2353 939275	высшее	3641
Любосмысл	Воробьев	Павловна	+7 358 834 40 27	9027 588222	среднее профессиональное	3642
Савва	Кузнецов	Филимонович	+7 (651) 492-90-77	1655 283402	высшее	3643
Василиса	Князева	Матвеевна	8 (007) 859-5445	8392 194869	\N	3644
Боян	Семенов	Робертовна	+7 (192) 480-67-55	3431 808817	высшее	3645
Устин	Быков	\N	8 344 472 0419	4953 410163	среднее	3646
Ипат	Савина	Демьянович	8 954 316 8774	7013 702797	среднее	3647
Лукьян	Бобылев	\N	87005251074	8938 879326	неоконченное высшее	3648
Дарья	Зиновьева	\N	+7 039 343 4659	5585 315692	неоконченное высшее	3649
Наркис	Белова	\N	+7 (658) 404-98-27	5482 425401	высшее	3650
Яков	Миронова	\N	+7 767 426 39 01	2122 270542	неоконченное высшее	3651
Евдокия	Мухин	\N	+7 590 648 1035	6523 604448	среднее профессиональное	3652
Авксентий	Белозеров	Валентиновна	+7 (937) 720-51-74	6037 548399	высшее	3653
Федот	Нестерова	Демьянович	89385524023	7949 727742	среднее профессиональное	3654
Вадим	Бурова	\N	8 289 246 40 14	3341 426898	высшее	3655
Эммануил	Филатова	Феликсовна	+7 (794) 103-8639	8759 340283	неоконченное высшее	3656
Аристарх	Мишин	\N	8 (149) 953-44-91	1165 868094	\N	3657
Лазарь	Шилова	Измаилович	+7 593 463 80 26	1655 197876	высшее	3658
Прокофий	Андреев	\N	8 (581) 866-77-17	2173 332943	среднее	3659
Зоя	Семенова	Геннадиевич	+7 (216) 596-91-43	7562 185545	высшее	3660
Бронислав	Гордеева	Филипповна	+7 (097) 106-4461	9247 939044	среднее профессиональное	3661
Ермил	Петров	\N	+7 (471) 057-2680	1370 618684	неоконченное высшее	3662
Матвей	Горшкова	\N	8 513 474 3136	2253 448703	неоконченное высшее	3663
Тимур	Вишняков	Кузьминична	8 348 203 42 94	6236 900562	среднее профессиональное	3664
Олимпий	Носкова	\N	+7 051 259 7856	2833 596826	неоконченное высшее	3665
Егор	Нестеров	\N	+7 648 366 7953	6404 591875	высшее	3666
Семен	Шестакова	Иларионович	8 481 445 5918	7650 850719	высшее	3667
Осип	Беляков	Адрианович	+7 697 750 4893	9950 873599	неоконченное высшее	3668
Нина	Русакова	Артурович	8 (993) 704-2985	9264 576154	\N	3669
Анисим	Субботина	Ермилович	+7 386 656 3225	5093 584728	\N	3670
Ярослав	Трофимов	Гурьевич	8 (182) 985-60-11	7748 127211	высшее	3671
Юлиан	Панфилов	Федосеевич	8 790 841 1429	3911 468065	неоконченное высшее	3672
Изяслав	Ефремов	Ануфриевич	8 993 320 4055	8257 216204	\N	3673
Пимен	Щербакова	\N	+7 (899) 016-7317	6534 511516	высшее	3674
Авдей	Симонов	Егоровна	8 (526) 592-25-63	6773 777038	среднее профессиональное	3675
Исидор	Одинцова	Жанович	8 (676) 161-7093	9955 161670	среднее профессиональное	3676
Никодим	Туров	\N	+7 (971) 606-71-48	6660 783442	среднее профессиональное	3677
Чеслав	Горшкова	\N	8 905 849 8089	1751 343165	\N	3678
Адриан	Терентьев	\N	8 892 067 29 74	6899 694413	среднее профессиональное	3679
Изот	Субботин	\N	85128593715	5212 658548	\N	3680
Эмиль	Федоров	\N	+7 174 232 92 89	6914 977060	среднее	3681
Феоктист	Рогов	Станиславовна	+74451311520	3576 993585	среднее	3682
Иван	Зыкова	\N	+72258744557	8942 849002	неоконченное высшее	3683
Ипатий	Мартынова	\N	+7 (021) 409-8956	2031 235536	среднее профессиональное	3684
Остромир	Сазонов	\N	8 028 526 8578	1854 851884	\N	3685
Фрол	Мамонтова	Бенедиктович	8 810 451 3834	9408 239290	среднее профессиональное	3686
Рубен	Самойлов	\N	86456706944	1211 902780	среднее профессиональное	3687
Родион	Никифоров	Кузьминична	+7 (907) 318-7980	6332 337321	высшее	3688
Аполлинарий	Маркова	Ильинична	+7 546 177 47 92	2558 682737	\N	3689
Василий	Романова	Алексеевна	+7 (659) 802-6791	8447 496486	\N	3690
Бронислав	Крюков	\N	+7 (916) 984-5796	5077 496387	\N	3691
Стоян	Никифорова	\N	8 595 467 46 20	9969 391732	высшее	3692
Виссарион	Копылов	Якубович	8 569 715 5954	2943 490595	среднее	3693
Акулина	Хохлова	Наумовна	81774684267	5621 328680	высшее	3694
Вадим	Трофимов	Демьянович	85616744989	8620 607135	неоконченное высшее	3695
Анастасия	Калинин	\N	+7 275 742 45 96	9414 824062	высшее	3696
Валерьян	Крылов	\N	8 292 671 1220	6975 229853	\N	3697
Любомир	Чернова	\N	8 432 950 00 50	8328 240738	высшее	3698
Панфил	Фролов	\N	8 (206) 753-83-89	4677 970983	среднее	3699
Юлия	Исаков	Гертрудович	8 (902) 679-6785	6359 423700	\N	3700
Рюрик	Силин	Захарьевич	+7 (907) 192-92-49	3321 382111	неоконченное высшее	3701
Адам	Веселова	Эльдаровна	+72113583716	4390 120826	среднее профессиональное	3702
Софрон	Евсеева	Дмитриевич	82918927414	2000 781082	неоконченное высшее	3703
Аполлинарий	Григорьева	Альбертовна	+7 (334) 100-53-89	4361 743358	неоконченное высшее	3704
Амос	Кононова	Тимофеевна	+74801856189	4971 575576	высшее	3705
Харлампий	Панов	Эдуардович	+7 555 371 62 82	2313 586561	среднее	3706
Георгий	Алексеева	\N	+7 (580) 796-11-72	5930 423360	среднее	3707
Ираклий	Федосеев	\N	8 113 540 71 44	6348 192041	неоконченное высшее	3708
Мартын	Силина	\N	+7 (977) 022-93-34	6784 566404	высшее	3709
Михей	Никифорова	Егоровна	+7 (123) 977-2630	9109 529393	среднее профессиональное	3710
Мариан	Пономарев	\N	8 148 999 1258	6561 721251	\N	3711
Климент	Семенова	Даниилович	8 705 605 7420	2532 885597	высшее	3712
Еремей	Архипова	Анатольевич	8 903 720 2796	2135 937707	среднее профессиональное	3713
Вячеслав	Панфилова	Иларионович	8 193 132 7080	2789 374632	среднее профессиональное	3714
Дарья	Кириллова	Ярославович	80529882841	7206 708289	среднее профессиональное	3715
Емельян	Блохина	\N	+73382929400	6801 881231	\N	3716
Владилен	Молчанова	\N	8 (297) 791-2796	8519 498652	среднее	3717
Епифан	Ермаков	Давидович	+77686977782	6188 447884	среднее профессиональное	3718
Максимильян	Константинова	\N	+7 (370) 083-5182	2068 593235	\N	3719
Ираида	Беляков	Яковлевич	82657483696	7445 780444	среднее профессиональное	3720
Виктор	Овчинников	Георгиевич	8 (470) 317-0597	1091 691015	неоконченное высшее	3721
Сергей	Борисов	\N	+7 773 072 70 85	3608 390820	высшее	3722
Казимир	Шаров	Архипович	8 (359) 987-02-44	9610 706496	среднее профессиональное	3723
Галактион	Самойлов	Устинович	8 (847) 567-18-05	9951 618216	\N	3724
Феликс	Медведев	\N	8 287 178 30 64	7248 338732	неоконченное высшее	3725
Рубен	Блинов	Максимовна	+71487564277	2358 639852	\N	3726
Карп	Журавлев	\N	8 (959) 711-77-69	9921 187411	неоконченное высшее	3728
Филимон	Николаев	Игнатович	+7 437 845 8125	7688 638580	неоконченное высшее	3729
Корнил	Петров	Тимурович	8 (104) 568-91-67	4568 736414	среднее профессиональное	3730
Ерофей	Алексеева	\N	8 (160) 574-18-36	1252 388187	высшее	3731
Виссарион	Анисимова	Филиппович	8 (230) 273-86-58	8390 600045	среднее профессиональное	3732
Самуил	Соколов	Валерианович	+7 322 971 3943	9877 297129	высшее	3733
Измаил	Никитина	\N	8 (239) 652-90-03	2295 589093	среднее	3734
Доброслав	Журавлева	Максимовна	8 331 666 3313	5228 398391	\N	3735
Александра	Костина	\N	+7 142 608 89 29	6519 961118	неоконченное высшее	3736
Ким	Филиппова	\N	+7 300 250 6919	7039 567519	среднее	3737
Евфросиния	Селезнев	Павловна	+7 (594) 637-6231	2731 470447	среднее	3738
Твердислав	Лапина	\N	8 (982) 906-10-83	6075 679084	\N	3739
Ерофей	Крылов	\N	+78107753864	7496 199255	неоконченное высшее	3740
Всеволод	Третьяков	Валерьевич	+7 355 035 5913	4636 552838	неоконченное высшее	3741
Тарас	Устинова	Болеславовна	8 086 032 02 98	2300 419010	среднее	3742
Нонна	Васильев	\N	8 629 945 53 14	6257 128549	среднее профессиональное	3743
Иларион	Якушева	Викентьевич	+7 397 219 2880	1644 779800	\N	3744
Твердислав	Петрова	Виленович	8 (624) 663-2428	8502 232539	среднее профессиональное	3745
Алевтина	Соловьев	Артемовна	8 366 605 39 34	8742 784316	неоконченное высшее	3746
Лукия	Константинова	\N	+7 (856) 975-8046	9177 644235	среднее профессиональное	3747
Мариан	Корнилов	Юлианович	+7 (567) 002-1788	9583 288161	высшее	3748
Дарья	Орехова	\N	+7 (574) 927-77-49	7521 864290	среднее профессиональное	3749
Дмитрий	Николаева	\N	+7 471 357 76 67	1222 754534	неоконченное высшее	3750
Фрол	Казаков	Анатольевич	8 526 895 15 04	7560 666071	среднее	3751
Глеб	Дроздов	\N	8 (043) 701-4893	2233 343430	среднее	3752
Исидор	Матвеева	Жанович	+7 (777) 492-2445	7996 586623	среднее профессиональное	3753
Ким	Меркушев	Филатович	8 (567) 321-79-60	9153 522681	неоконченное высшее	3754
Осип	Комиссарова	\N	+71695284557	7253 951704	высшее	3755
Якуб	Соколов	Семеновна	+74184878892	5198 370811	высшее	3756
Ольга	Панова	Фомич	+7 379 223 14 43	4561 430952	\N	3757
Ангелина	Лихачева	\N	8 686 433 5618	8091 946653	высшее	3758
Виктор	Мишин	Даниловна	88831064658	3242 272596	неоконченное высшее	3759
Изяслав	Павлов	\N	8 889 892 31 77	5196 571115	неоконченное высшее	3760
Спиридон	Морозов	Трофимович	+7 070 631 45 90	5320 272700	неоконченное высшее	3761
Сократ	Бобылева	\N	+7 263 236 06 58	8135 619182	\N	3762
Адриан	Сазонов	Рудольфовна	+7 (306) 172-13-93	2734 262868	среднее профессиональное	3763
Лора	Князева	Феликсовна	+7 (130) 010-5363	9832 492377	неоконченное высшее	3764
Ипатий	Ларионова	Феодосьевич	+7 (155) 549-11-93	4921 530987	\N	3765
Давыд	Коновалов	Юльевна	8 284 316 96 45	8342 780459	неоконченное высшее	3766
Анжелика	Воронов	\N	+7 (869) 268-14-89	7706 220341	высшее	3767
Алексей	Денисова	Теймуразович	+7 (378) 444-28-90	7524 154083	высшее	3768
Анастасия	Денисов	Матвеевна	89522867888	5005 521227	неоконченное высшее	3769
Филимон	Лапин	Венедиктович	+7 326 085 4933	2725 586813	неоконченное высшее	3770
Аггей	Костина	Викентьевич	81960241476	8141 477303	среднее	3771
Зоя	Гущин	\N	8 388 078 4321	5442 406971	среднее профессиональное	3772
Иларион	Веселов	\N	+75039926925	9888 434341	неоконченное высшее	3773
Харлампий	Исакова	\N	8 (523) 594-48-15	1444 484578	\N	3774
Ратмир	Силина	Вячеславовна	+75260101982	5446 512535	среднее профессиональное	3775
Будимир	Щербаков	\N	+7 (361) 766-82-79	2523 671795	среднее профессиональное	3776
Митофан	Беляев	\N	+7 (651) 933-69-14	1149 170997	среднее профессиональное	3777
Виталий	Федоров	Федосеевич	8 (338) 471-5566	5150 350505	среднее	3778
Гремислав	Герасимова	\N	8 (977) 186-49-37	7992 363192	\N	3779
Алина	Ларионова	\N	8 631 201 12 31	3818 471797	среднее профессиональное	3780
Вера	Моисеев	Данилович	+7 (643) 680-86-36	1480 986821	неоконченное высшее	3781
Сергей	Романова	\N	8 (738) 173-5326	5098 739115	неоконченное высшее	3782
Михаил	Елисеева	\N	8 (449) 605-6032	1797 465415	\N	3783
Юлия	Зайцев	Макаровна	88974048122	7383 246229	среднее	3784
Максим	Доронина	Ануфриевич	8 (212) 168-22-63	2616 940194	высшее	3785
Регина	Карпов	\N	+71169833748	3333 462091	высшее	3786
Аскольд	Иванов	Феоктистович	81117068989	1607 572570	среднее	3787
Сократ	Суворова	\N	+74655392614	5603 257372	высшее	3788
Ладимир	Кузьмин	Феофанович	8 (315) 376-85-32	1907 536245	высшее	3789
Савватий	Соболев	Максимовна	8 (725) 374-77-56	2607 980276	среднее профессиональное	3790
Осип	Харитонова	\N	+78274627056	5747 681622	неоконченное высшее	3791
Евпраксия	Дорофеева	\N	+76134096970	8929 139603	\N	3792
Елена	Федорова	\N	+7 064 268 87 05	6811 889596	\N	3793
Евстигней	Карпов	Болеславовна	+7 988 262 62 36	7871 326373	среднее	3794
Демьян	Шестаков	Валентиновна	8 (258) 657-25-96	1860 947399	высшее	3795
Изяслав	Ефимова	\N	+7 (293) 782-7320	3040 243667	\N	3796
Гремислав	Белякова	Ефремович	+70556481915	8648 920540	неоконченное высшее	3797
Александра	Рябов	Львовна	+7 (992) 901-00-95	3467 161734	высшее	3798
Николай	Филиппов	\N	+7 219 055 0907	9776 896616	среднее	3799
Семен	Николаев	Юльевич	8 924 390 9877	6659 648446	среднее	3800
Степан	Кириллова	\N	8 (330) 987-98-71	1366 190970	неоконченное высшее	3801
Милан	Петухов	\N	88049400293	3353 438957	неоконченное высшее	3802
Анатолий	Кононов	Аркадьевна	+7 (855) 125-21-83	6084 995472	\N	3803
Феликс	Морозов	Елизарович	+7 (528) 002-4875	9007 555731	среднее	3804
Митофан	Богданов	\N	+7 205 807 12 85	3044 399582	среднее	3805
Викторин	Большакова	\N	+7 403 170 5794	2410 825156	среднее	3806
Элеонора	Селиверстов	Тимурович	+7 792 002 57 50	9475 319409	\N	3807
Любим	Муравьев	Валентинович	86113113106	6123 866349	среднее	3808
Ярослав	Некрасов	\N	+7 453 172 4127	2862 526148	высшее	3809
Лавр	Савина	\N	8 (425) 319-5588	4846 643342	\N	3810
Ладислав	Нестеров	Федосеевич	8 212 529 5850	2429 954767	среднее	3811
Лука	Васильева	\N	8 (060) 250-0205	4955 618748	неоконченное высшее	3812
Сигизмунд	Миронов	\N	+70781204658	3333 941765	неоконченное высшее	3813
Филарет	Комиссарова	\N	82567904742	5144 664351	среднее профессиональное	3814
Модест	Афанасьева	\N	+7 448 653 3372	8444 991808	высшее	3815
Гостомысл	Фокин	\N	8 (217) 250-2902	9294 900355	\N	3816
Всемил	Анисимова	Арсеньевич	+7 (839) 532-1978	6869 905277	среднее профессиональное	3817
Наркис	Гордеев	Жанович	86533437908	6711 629395	\N	3818
Марк	Селиверстова	Валентинович	8 (699) 395-2011	8393 233239	среднее профессиональное	3819
Софрон	Тихонов	Тимурович	88507779163	2624 638774	неоконченное высшее	3820
Аггей	Орлов	\N	+7 (522) 719-63-52	8712 758239	высшее	3821
Павел	Воронова	\N	+7 640 598 36 44	1534 862361	\N	3822
Андрей	Гуляева	Эльдаровна	+71642981212	9140 531175	высшее	3823
Нестор	Блинова	\N	82148813405	4228 569667	среднее	3824
Агафон	Петухов	\N	8 895 109 1691	3536 317554	среднее	3825
Ермил	Кошелев	\N	+7 845 356 86 92	4365 443829	среднее профессиональное	3826
Дорофей	Казакова	\N	8 099 065 59 62	3093 687367	\N	3827
Вышеслав	Беспалова	Валентиновна	8 825 857 63 66	5634 456839	неоконченное высшее	3828
Руслан	Ершов	Фролович	+7 (407) 599-0521	2839 508535	высшее	3829
Антонина	Устинов	\N	+7 929 964 0320	3181 868673	\N	3830
Нифонт	Овчинникова	Бенедиктович	+7 (312) 954-8796	3942 958120	среднее	3831
Фрол	Нестеров	\N	+7 (065) 925-88-29	1370 253730	высшее	3832
Гаврила	Дмитриев	\N	+7 090 394 7687	8120 939369	среднее	3833
Агата	Константинова	\N	8 (757) 237-8147	6758 680815	\N	3834
Велимир	Медведева	Тимуровна	+7 (227) 599-2532	9444 113051	неоконченное высшее	3835
Радим	Семенов	\N	+73354094892	2731 496738	неоконченное высшее	3836
Иларион	Потапов	\N	+7 (165) 550-71-70	3447 508990	неоконченное высшее	3837
Архип	Доронина	Иларионович	+7 (550) 608-88-41	5646 394028	высшее	3838
Станимир	Лапин	\N	+7 (555) 059-0036	7529 903590	неоконченное высшее	3839
Панкрат	Щукин	Анисимович	8 (903) 213-5072	8385 413203	неоконченное высшее	3840
Милан	Кудрявцев	\N	8 (234) 446-41-12	6512 699043	неоконченное высшее	3841
Аникей	Лобанов	Филимонович	+7 642 947 13 31	9654 141617	неоконченное высшее	3842
Ярополк	Никитина	Эдгарович	80974266547	2319 230707	\N	3843
Лучезар	Григорьев	Гурьевич	+7 031 935 1524	3397 694419	среднее профессиональное	3844
Пров	Яковлева	\N	+7 225 878 74 55	1000 592100	среднее профессиональное	3845
Сергей	Сорокин	\N	+7 (274) 950-05-40	3240 335759	\N	3846
Ладимир	Волков	Бенедиктович	+7 (539) 670-0019	8825 156147	неоконченное высшее	3847
Гордей	Белоусова	Григорьевич	+7 (990) 172-7295	6680 119083	среднее	3848
Олимпиада	Дорофеев	Юлианович	8 482 348 1973	6966 587833	неоконченное высшее	3849
Максимильян	Рогов	\N	8 855 913 63 67	7119 872318	среднее	3850
Емельян	Гришина	Харитонович	+7 357 919 0443	4599 275124	неоконченное высшее	3851
Панкратий	Исакова	\N	8 273 952 1083	7235 630709	\N	3852
Всеслав	Комиссарова	Геннадьевна	+7 436 213 39 01	7431 535013	среднее	3853
Остап	Субботин	Ильинична	81906910371	3064 611170	среднее профессиональное	3854
Никита	Зыков	Леонидовна	+70364111690	5522 940623	среднее профессиональное	3855
Модест	Лукина	\N	8 (382) 600-3391	4692 559140	среднее профессиональное	3856
Марк	Беспалов	\N	+7 588 538 44 38	6822 998483	высшее	3857
Эрнест	Степанова	Валерьянович	8 760 094 79 73	7953 571577	\N	3858
Данила	Уварова	\N	8 (461) 193-71-72	4764 802448	среднее профессиональное	3859
Борис	Пестова	Мироновна	8 (680) 871-35-87	7148 493099	высшее	3860
Евфросиния	Шилова	Вячеславович	8 (089) 060-89-22	5813 311804	\N	3861
Изот	Фомичев	\N	8 (864) 593-17-60	9727 354958	\N	3862
Раиса	Ермаков	\N	+79662470382	5995 953281	\N	3863
Елизар	Субботина	\N	89612717767	1554 207334	неоконченное высшее	3864
Антонин	Потапова	Феодосьевич	+7 (837) 333-1971	7074 537399	среднее	3865
Ладислав	Исаков	Игоревна	+7 (714) 571-03-81	3548 635984	высшее	3866
Демид	Уваров	\N	8 904 879 7171	9351 186242	неоконченное высшее	3867
Иларион	Симонов	Робертовна	+7 (407) 596-76-84	1277 197034	\N	3868
Анастасия	Блохин	\N	8 (309) 694-66-77	8515 877522	высшее	3869
Любим	Мишин	\N	8 (157) 433-15-70	8465 887749	неоконченное высшее	3870
Галина	Гордеева	Викторович	+7 (117) 808-0679	8311 846220	среднее	3871
Викентий	Трофимова	Евсеевич	+74529538190	5161 259302	высшее	3872
Галина	Суханова	Павловна	87239305024	4771 956374	среднее	3873
Ираклий	Соловьев	\N	+7 (957) 946-57-66	4096 534248	неоконченное высшее	3874
Радован	Пахомова	\N	+76594193137	2270 547258	неоконченное высшее	3875
Святослав	Третьякова	\N	8 (103) 779-4883	6598 754540	среднее профессиональное	3876
Ратибор	Русакова	Тихонович	8 720 748 76 65	9504 397936	высшее	3877
Капитон	Алексеев	\N	+7 690 697 3153	9457 423288	\N	3878
Автоном	Герасимова	Яковлевич	+7 (047) 214-86-44	5846 571474	\N	3879
Ратибор	Егорова	Альбертовна	8 988 532 42 08	3400 917082	\N	3880
Каллистрат	Степанова	\N	8 (590) 374-31-74	9600 178833	среднее профессиональное	3881
Твердислав	Рогов	\N	8 (064) 775-73-46	2491 863707	высшее	3882
Милица	Абрамов	Филипповна	8 726 431 07 01	9765 969623	\N	3883
Фрол	Брагина	Адамович	8 456 774 65 01	9889 330792	\N	3884
Ульяна	Шаров	Власович	+7 (701) 972-9645	7759 681630	среднее	3885
Михаил	Лебедев	Ефремович	8 (657) 813-6637	3017 212826	высшее	3886
Ким	Сергеева	Максимовна	82889829097	5226 376221	среднее	3887
София	Турова	Олеговна	+7 574 966 84 56	1292 490705	высшее	3888
Валерия	Савина	Ждановна	+7 (879) 413-94-61	3099 475664	высшее	3889
Аверьян	Третьякова	Андреевна	+7 (013) 590-2411	1932 208153	\N	3890
Евфросиния	Муравьева	Ниловна	+7 425 729 6398	6337 175297	\N	3891
Лавр	Комаров	Матвеевна	8 277 861 2939	9270 965069	высшее	3892
Роман	Силина	\N	8 (069) 867-6170	8013 888161	\N	3893
Игорь	Третьякова	Анисимович	+7 934 276 9108	4126 152164	высшее	3894
Евграф	Морозов	Богдановна	+7 (582) 908-69-43	6145 283737	\N	3895
Матвей	Афанасьева	\N	+71436350659	4947 264099	неоконченное высшее	3896
Евсей	Гусева	Артемовна	+7 (391) 175-41-66	9439 393743	среднее профессиональное	3897
Остромир	Федосеев	\N	8 930 442 0249	7042 797437	среднее профессиональное	3898
Ананий	Большаков	Аркадьевна	+72264409417	3986 315511	среднее	3899
Сократ	Бобров	Никифоровна	+70797311757	4669 710852	\N	3900
Святослав	Гаврилов	Владиславовна	8 428 571 6966	4776 936497	среднее профессиональное	3901
Бронислав	Кулагин	\N	8 308 129 8784	6067 866233	неоконченное высшее	3902
Эраст	Силина	Сергеевна	86952291263	9887 827815	среднее профессиональное	3903
Дементий	Доронин	\N	8 (708) 981-0516	2443 335369	неоконченное высшее	3904
Лука	Киселева	Руслановна	+7 564 855 7502	3081 419642	неоконченное высшее	3905
Пимен	Кудряшов	Михайловна	8 357 111 36 85	6848 108511	среднее	3906
Елена	Кондратьев	Валентиновна	+7 823 430 23 03	1924 548904	\N	3907
Авдей	Копылов	\N	8 591 478 3146	4151 335426	\N	3908
Панфил	Александров	\N	+7 586 082 8160	2482 188863	среднее профессиональное	3909
Анатолий	Горбунова	Натановна	+7 (513) 539-45-30	1184 148918	неоконченное высшее	3910
Алла	Белозерова	\N	+7 (777) 602-1892	9440 763740	среднее	3911
Артем	Потапова	Рубеновна	8 511 565 8468	1700 717087	\N	3912
Гостомысл	Русакова	\N	+7 679 037 49 69	4662 300355	среднее	3913
Зосима	Орлов	\N	+7 (794) 701-29-87	1318 657900	\N	3914
Викентий	Архипова	Абрамович	+7 826 857 0112	5626 701634	\N	3915
Валентин	Красильников	Артурович	8 225 235 5863	2905 842862	высшее	3916
Лука	Блинов	\N	8 555 787 1979	7636 407030	среднее	3917
Милен	Лукина	Антипович	+79067248053	6772 545673	неоконченное высшее	3918
Майя	Нестеров	\N	+77065955407	5994 315147	высшее	3919
Терентий	Ильин	\N	8 391 502 8932	1093 843804	среднее профессиональное	3920
Наталья	Артемьева	\N	8 (261) 559-9853	7096 549560	среднее профессиональное	3921
Галина	Савин	Павловна	8 (950) 447-16-07	8543 988213	среднее профессиональное	3922
Денис	Андреев	Ааронович	8 902 067 5559	3225 508391	неоконченное высшее	3923
Ольга	Громова	Вениаминовна	+72487532876	7753 520294	неоконченное высшее	3924
Сократ	Панова	\N	+7 446 315 27 66	5272 536626	среднее профессиональное	3925
Оксана	Голубева	\N	8 752 979 8323	1294 844002	\N	3926
Лавр	Жданова	\N	+70544371469	8191 175346	\N	3927
Милен	Костина	\N	+73144601293	5289 486389	среднее	3928
Тимур	Назарова	Никифоровна	8 587 945 23 44	7908 230983	среднее	3929
Флорентин	Ковалева	Артёмович	86575972242	5142 212324	среднее	3930
Владилен	Захаров	\N	8 (263) 519-8322	2177 105401	неоконченное высшее	3931
Вацлав	Панфилова	\N	8 (937) 052-57-46	6762 572142	среднее	3932
Севастьян	Орлов	Демидович	+77912960109	7526 311058	высшее	3933
Синклитикия	Архипова	\N	8 543 545 1366	6626 674534	\N	3934
Амос	Агафонов	\N	+7 (911) 172-46-59	5654 905535	среднее профессиональное	3935
Варвара	Исаев	Фомич	8 (966) 696-45-15	2686 734799	\N	3936
Рубен	Мамонтова	\N	+7 373 015 30 93	6704 512469	среднее	3937
Зоя	Горбачев	\N	+7 (859) 086-0692	9090 826623	неоконченное высшее	3938
Вера	Молчанова	\N	+7 (888) 247-95-90	8226 747314	среднее профессиональное	3939
Акулина	Зиновьева	\N	80894690310	6954 395462	неоконченное высшее	3940
Марина	Воронова	Устинович	8 (394) 154-2447	8719 153447	среднее профессиональное	3941
Вероника	Комиссаров	\N	+7 (691) 795-56-92	9514 827654	\N	3942
Сила	Авдеева	Евстигнеевич	+72163922025	8730 140594	среднее профессиональное	3943
Бажен	Лапина	\N	8 (699) 907-2786	9709 846759	неоконченное высшее	3944
Екатерина	Андреева	Герасимович	87846221830	4058 312315	\N	3945
Виссарион	Антонов	\N	+7 (307) 010-3189	6786 423786	среднее	3946
Виктор	Уварова	Герасимович	8 359 329 70 30	3726 954311	неоконченное высшее	3947
Надежда	Родионов	\N	+7 821 479 18 65	9095 805168	неоконченное высшее	3948
Мечислав	Евсеев	\N	+7 429 789 7897	9695 745737	среднее	3949
Аркадий	Филиппов	\N	8 870 250 08 61	7859 216046	среднее профессиональное	3950
Святослав	Захаров	\N	8 (917) 730-7080	9404 654776	\N	3951
Виталий	Белова	Харлампьевич	83103932687	5310 397157	среднее профессиональное	3952
Захар	Копылова	Ильясович	8 (281) 985-3115	4805 527290	среднее	3953
Фортунат	Петрова	Глебович	82057386687	9606 615867	неоконченное высшее	3954
Ермолай	Филиппов	\N	+7 653 467 2713	8526 931027	среднее	3955
Андрей	Карпова	Борисовна	8 (960) 713-74-25	2300 481892	\N	3956
Гедеон	Гурьева	\N	+7 713 677 7135	5200 593871	среднее профессиональное	3957
Радим	Петрова	\N	8 272 643 04 21	8248 983151	среднее	3958
Станислав	Вишняков	Филатович	+70491014671	7467 303789	\N	3959
Флорентин	Белозеров	\N	8 343 999 2577	8784 375428	неоконченное высшее	3960
Леонтий	Кузьмин	\N	8 158 684 3201	1019 579072	\N	3961
Радован	Турова	Григорьевна	+7 (509) 110-7575	4080 744678	\N	3962
Ермолай	Буров	\N	+70020041080	5186 499267	среднее	3963
Агап	Колесникова	Валерьянович	8 (161) 952-3812	1468 857119	среднее профессиональное	3964
Ярослав	Горшков	\N	8 (860) 423-1938	7029 314505	высшее	3965
Андроник	Андреева	\N	8 (430) 712-76-59	4479 531862	среднее	3966
Потап	Фокина	\N	8 (607) 372-6136	2649 376994	среднее профессиональное	3967
Данила	Беляков	\N	8 722 217 30 91	4484 286213	неоконченное высшее	3968
Феликс	Силин	Иосифович	+7 945 280 9579	2013 809991	среднее	3969
Зинаида	Борисова	\N	+70854561754	5938 664556	\N	3970
Анжелика	Шестаков	\N	8 858 673 9272	3005 701496	высшее	3971
Назар	Шубин	\N	+7 825 356 8673	8620 382220	\N	3972
Никодим	Красильников	Альбертовна	+7 (789) 771-8213	1954 380830	неоконченное высшее	3973
Андроник	Селезнев	\N	+7 988 116 8110	4825 997216	\N	3974
Савватий	Дроздов	\N	+7 085 756 4699	9583 758921	среднее профессиональное	3975
Давыд	Голубева	\N	8 073 881 2592	2523 312043	\N	7221
Викторин	Ершов	\N	8 277 538 9283	3467 647717	среднее профессиональное	3976
Любим	Денисова	\N	+7 (346) 329-7827	5758 946990	высшее	3977
Август	Моисеев	Эдуардовна	8 560 446 40 12	3223 441885	\N	3978
Евпраксия	Баранова	\N	+7 000 347 18 38	7495 848818	среднее	3979
Элеонора	Казакова	\N	87495197035	5385 144551	среднее профессиональное	3980
Галина	Киселева	Тимофеевна	+7 939 621 2757	5675 431001	высшее	3981
Кузьма	Жданов	Иосифович	+7 (903) 071-84-67	2713 205198	\N	3982
Федот	Чернов	Евсеевич	8 761 997 05 44	6549 281930	среднее профессиональное	3983
Рюрик	Ефремов	Изотович	+7 (553) 659-6573	9235 471931	\N	3984
Изяслав	Самойлов	Юльевна	+7 (120) 229-2872	3502 745888	среднее профессиональное	3985
Ипатий	Кондратьева	Захарьевич	8 (969) 019-8631	1761 984460	высшее	3986
Анжела	Кондратьева	Оскаровна	8 961 909 2101	8117 453217	среднее	3987
Алевтина	Лукин	Геннадиевна	+7 727 463 61 35	6718 878381	высшее	3988
Полина	Афанасьев	Рубеновна	8 (978) 075-1893	4255 988748	\N	3989
Петр	Шилова	Демьянович	8 (528) 822-6351	3322 279710	среднее	3990
Глеб	Никонов	Фёдорович	+7 890 328 6700	2721 527180	среднее	3991
Феликс	Миронова	\N	+7 (371) 665-3585	7013 854196	высшее	3992
Леонид	Белова	\N	8 (169) 377-0351	7430 723894	\N	3993
Август	Никитин	Григорьевич	+7 (445) 498-70-53	9768 541950	\N	3994
Мир	Фролов	Юльевич	8 714 177 4504	7198 745928	\N	3995
Селиван	Поляков	\N	+71015315091	1069 560235	среднее	3996
Евлампий	Лапина	Святославовна	80686834130	3899 231099	среднее	3997
Мечислав	Кондратьева	\N	+7 661 192 55 10	3623 657566	\N	3998
Павел	Белозерова	\N	+7 731 817 65 14	3813 888467	высшее	3999
Софон	Орехова	Леонидовна	8 (597) 481-6140	4277 921060	\N	4000
Панкрат	Щербакова	\N	+7 (008) 046-1388	4517 570101	высшее	4001
Егор	Бобров	Фадеевич	+7 255 319 0684	9026 328890	\N	4002
Митофан	Мишина	\N	+7 (040) 990-89-71	8012 319347	среднее профессиональное	4003
Савва	Белоусова	Гавриилович	8 (361) 463-2728	5553 592627	высшее	4004
Пимен	Медведев	Михайловна	+70747142950	7250 845211	высшее	4005
Лукьян	Вишнякова	\N	+75722650135	2557 424373	неоконченное высшее	4006
Давыд	Пономарев	Валерианович	8 662 294 8123	6502 670779	неоконченное высшее	4007
Юлия	Самойлова	Изотович	8 810 136 2455	1261 261304	\N	4008
Митофан	Абрамов	\N	+73216266912	7705 796457	\N	4009
Андроник	Моисеев	Устинович	8 889 994 86 44	6049 891765	среднее профессиональное	4010
Виктория	Наумова	\N	+7 095 240 8448	9401 189080	неоконченное высшее	4011
Ерофей	Копылова	Валерьевич	+7 850 870 19 51	7875 325654	\N	4012
Клавдия	Панфилова	Вилорович	+7 366 283 61 73	4057 822923	среднее профессиональное	4013
Юлий	Быкова	Владленович	8 495 065 8141	4204 214284	неоконченное высшее	4014
Борислав	Сергеев	Антипович	+7 (216) 747-43-43	4703 340510	\N	4015
Любосмысл	Филиппова	Юльевич	+71651851056	6738 108406	неоконченное высшее	4016
Нонна	Громова	\N	85872217720	9763 891578	среднее профессиональное	4017
Максимильян	Чернова	\N	+7 583 123 9873	8525 953835	среднее профессиональное	4018
Мстислав	Белоусова	\N	+74689223623	3102 955943	высшее	4019
Аким	Кулагин	Валентинович	8 386 436 6444	2120 662689	среднее профессиональное	4020
Епифан	Фокина	\N	+7 (598) 658-19-48	1569 908201	\N	4021
Фёкла	Родионова	Демьянович	+7 (564) 824-6370	9529 702943	неоконченное высшее	4022
Тарас	Исаков	\N	+72665926160	7528 725712	высшее	4023
Майя	Самсонов	\N	+7 808 573 5286	5154 358589	\N	4024
Всеслав	Осипова	\N	8 859 765 18 72	3942 655772	\N	4025
Амос	Жуков	Болеславовна	+7 466 130 2212	5130 385564	среднее профессиональное	4026
Платон	Калашников	\N	8 (550) 299-0691	4699 729348	высшее	4027
Твердислав	Кошелев	\N	89146175233	4944 859616	среднее профессиональное	4028
Натан	Зуев	Власович	8 332 376 54 72	6653 442224	\N	4029
Никон	Дорофеева	\N	+7 (404) 283-50-24	3610 520835	среднее профессиональное	4030
Кондрат	Киселева	\N	+7 (774) 323-5420	9560 941223	\N	4031
Александра	Денисов	\N	+7 306 183 0885	1662 977318	высшее	4032
Радислав	Шубин	Матвеевна	85797448387	1907 570645	среднее профессиональное	4033
Ладимир	Веселова	Федотович	8 (640) 096-0719	8728 998578	среднее профессиональное	4034
Капитон	Богданова	Фадеевич	8 642 864 67 86	5646 963760	среднее профессиональное	4035
Лукьян	Гуляева	Леоновна	+7 (224) 121-36-67	5915 382198	неоконченное высшее	4036
Болеслав	Бирюков	\N	+7 (215) 014-0993	6301 495168	среднее профессиональное	4037
Антип	Захарова	Фокич	88274997327	5217 799431	высшее	4038
Иван	Титова	Владиславович	+7 212 300 35 71	4312 634824	высшее	4039
Аристарх	Вишнякова	Гурьевич	+7 (130) 648-98-91	7765 197976	\N	4040
Октябрина	Мухин	Фокич	8 540 399 74 24	7928 193592	среднее	4041
Евдокия	Трофимов	\N	8 111 034 2971	8148 488613	среднее	4042
Евстафий	Пономарева	\N	+7 641 969 44 92	1476 762288	среднее профессиональное	4043
Емельян	Рябов	\N	8 419 989 3542	8671 993819	среднее	4044
Сильвестр	Дьячкова	\N	+7 (757) 812-20-89	5788 352063	среднее профессиональное	4045
Никон	Кононов	Николаевна	8 (797) 096-00-47	9652 254252	среднее профессиональное	4046
Ермил	Устинова	\N	+7 (994) 162-73-11	8228 256811	неоконченное высшее	4047
Никифор	Мухина	\N	89356344316	7177 137512	высшее	4048
Октябрина	Кошелев	\N	+7 (581) 626-11-17	4123 558394	\N	4049
Филипп	Кабанов	\N	+7 917 474 9214	3411 281605	\N	4050
Константин	Пахомова	\N	+7 157 281 4531	4664 397842	среднее профессиональное	4051
Ермолай	Назаров	Виленович	8 826 980 47 33	2518 257553	среднее профессиональное	4052
Евгений	Кудряшов	Аркадьевна	+7 (080) 204-9906	4470 406507	высшее	4053
Платон	Лебедева	\N	8 451 190 72 24	6344 218690	высшее	4054
Устин	Елисеев	Феофанович	+7 (190) 571-95-67	3906 641261	среднее	4055
Акулина	Антонов	\N	88652043015	9000 981734	неоконченное высшее	4056
Серафим	Доронина	\N	+7 (985) 787-52-82	2940 811634	неоконченное высшее	4057
Алла	Моисеев	\N	+7 (510) 621-4028	9282 535356	среднее профессиональное	4058
Любомир	Романов	\N	8 710 082 13 61	2112 974123	неоконченное высшее	4059
Гедеон	Бобылева	\N	8 (241) 885-29-15	6063 668467	среднее	4060
Лукьян	Беспалова	Харлампьевич	+7 379 033 0654	5242 776612	среднее профессиональное	4061
Сидор	Нестеров	Харлампович	+76283604746	3958 355990	высшее	4062
Валентин	Воробьева	\N	+73999973602	1128 933563	среднее профессиональное	4063
Михей	Костина	Ефимович	+7 (338) 249-5997	8371 833903	высшее	4064
Прасковья	Романов	Феодосьевич	+7 112 214 0318	9408 825036	среднее	4065
Феофан	Брагина	Феодосьевич	+7 169 288 1165	6573 700248	неоконченное высшее	4066
Елена	Тимофеева	Эдгардович	+70740635275	1147 982203	среднее	4067
Татьяна	Дорофеева	Афанасьевна	87160361726	3367 132029	\N	4068
Анатолий	Попова	\N	8 (851) 779-0216	8521 933395	\N	4069
Ангелина	Логинова	\N	+7 (116) 202-09-32	3002 279076	среднее профессиональное	4070
Анжела	Быкова	\N	+7 (701) 589-56-10	7443 604794	\N	4071
Христофор	Васильев	Аскольдовна	8 737 397 7302	6311 764733	\N	4072
Геннадий	Сазонова	\N	8 018 104 1362	9009 760807	среднее профессиональное	4073
Аполлон	Новиков	\N	88456468087	2528 979505	\N	4074
Мстислав	Иванов	\N	8 (389) 803-35-21	9111 339867	среднее	4075
Тимофей	Бобров	\N	+7 (865) 896-90-95	8237 614980	среднее профессиональное	4076
Владилен	Савельев	Викторовна	+7 (556) 386-09-81	7750 721581	неоконченное высшее	4077
Ювеналий	Исаев	Ивановна	+7 (368) 535-72-30	4975 217501	среднее профессиональное	4078
Станислав	Колесникова	Алексеевна	80053702457	2455 503504	неоконченное высшее	4079
Гурий	Фомичева	\N	8 849 283 4022	2316 980902	среднее	4080
Пелагея	Евсеева	Тарасовна	85500710639	4428 876139	среднее профессиональное	4081
Анисим	Горбачев	Тихонович	8 217 239 61 26	3784 123496	среднее	4082
Аверьян	Хохлова	\N	89172234832	7490 751997	неоконченное высшее	4083
Казимир	Тихонова	\N	83440060584	1717 508912	неоконченное высшее	4084
Евсей	Лыткин	Леонидовна	+70751354502	5398 476182	неоконченное высшее	4085
Спартак	Сазонова	\N	88981390717	4232 389161	среднее	4086
Оксана	Фролов	Натановна	+7 (574) 304-8029	4177 835066	\N	4087
Ираклий	Лобанова	\N	8 (564) 573-1006	5034 706001	\N	4088
Кир	Кудряшов	\N	82814980443	5921 198277	неоконченное высшее	4089
Зосима	Кулаков	Марсович	+79768209053	5218 773013	среднее профессиональное	4090
Юлиан	Силина	\N	+7 (479) 234-60-22	9604 684516	среднее	4091
Аникита	Крюкова	Ерофеевич	8 029 473 38 22	8385 862378	среднее	4092
Мина	Васильева	\N	8 (916) 415-90-44	6276 918789	неоконченное высшее	4093
Будимир	Яковлева	Арсеньевич	+7 (059) 669-00-97	7089 514392	среднее профессиональное	4094
Анна	Капустин	\N	8 (994) 821-89-63	4252 350969	высшее	4095
Лев	Поляков	\N	+7 (120) 831-0957	2411 695670	неоконченное высшее	4096
Ираида	Мухина	\N	8 (048) 107-34-59	5380 570265	высшее	4097
Модест	Абрамова	Демьянович	8 283 662 7826	4443 624608	неоконченное высшее	4098
Панкратий	Герасимов	\N	8 834 041 9801	4491 897521	неоконченное высшее	4099
Светозар	Лебедева	Зиновьевич	+71271972694	7852 494789	неоконченное высшее	4100
Аполлон	Воронцов	\N	8 (653) 339-1584	8501 943901	высшее	4101
Данила	Бирюкова	Альбертовна	8 889 946 2869	5776 263844	высшее	4102
Елизар	Романова	\N	8 (301) 235-40-58	3640 779447	среднее	4103
Евсей	Васильев	Вячеславович	8 (368) 534-23-59	9553 597416	среднее профессиональное	4104
Ферапонт	Данилова	Эльдаровна	8 (432) 233-8257	5385 747766	среднее профессиональное	4105
Ферапонт	Харитонова	\N	+7 930 898 7552	5830 626433	неоконченное высшее	4106
Никита	Колесникова	\N	+7 (602) 432-0179	2334 341231	среднее профессиональное	4107
Феликс	Зайцева	\N	8 (179) 491-4883	2093 109405	среднее	4108
Ксения	Сорокина	\N	8 (428) 091-3137	2294 664712	среднее	4109
Вероника	Меркушева	\N	8 (758) 611-39-48	7996 725985	\N	4110
Радован	Колобова	Ильинична	+7 183 051 8649	9849 690548	среднее профессиональное	4111
Адриан	Самсонова	Геннадьевна	88709843826	8693 101513	среднее профессиональное	4112
Радислав	Крюков	Мироновна	89600923335	3257 603667	высшее	4113
Будимир	Осипов	\N	86416105845	9383 525712	среднее профессиональное	4114
Анжелика	Суханов	\N	8 302 303 18 55	7247 940975	среднее	4115
Софон	Турова	\N	8 (673) 466-7364	9084 392710	\N	4116
Фока	Баранов	\N	8 (800) 640-1373	2264 306286	высшее	4117
Радислав	Турова	\N	+72262231370	3108 624059	\N	4118
Анжелика	Киселева	\N	8 (042) 232-4728	6341 616427	неоконченное высшее	4119
Прокофий	Федорова	Владиславовна	8 (301) 282-82-14	8461 419993	среднее	4120
Аскольд	Гурьева	Кирилловна	+7 (963) 372-9479	6556 618053	высшее	4121
Федор	Щукина	\N	+7 192 039 85 39	9836 771308	высшее	4122
Еремей	Горбунов	\N	+7 889 129 25 60	3158 197544	высшее	4123
Осип	Блохина	\N	+7 (367) 499-5001	7025 991355	\N	4124
Давыд	Куликова	Афанасьевич	81520768002	3696 726842	\N	4125
Герасим	Шаров	Теймуразович	+7 557 776 03 51	9844 128287	\N	4126
Евгений	Маслов	Абрамович	+7 298 411 69 20	7935 862722	неоконченное высшее	4127
Пахом	Денисова	Григорьевна	8 520 765 8263	4714 461381	среднее	4128
Селиван	Кононов	Станиславовна	+7 (279) 530-4288	8254 997889	\N	4129
Платон	Борисова	\N	8 758 182 8697	4658 694345	среднее профессиональное	4130
Олег	Кабанов	Артемовна	+71777158880	6562 129344	неоконченное высшее	4131
Дмитрий	Лебедев	Феликсовна	+7 (570) 335-3626	7119 509798	высшее	4132
Феликс	Егоров	\N	+7 (796) 019-60-92	1114 178967	среднее профессиональное	4133
Спартак	Абрамов	\N	85683250787	9541 689468	неоконченное высшее	4134
Игорь	Гурьев	\N	+74293308569	6384 942391	высшее	4135
Кирилл	Кононов	Харлампович	8 655 592 5866	4347 945107	высшее	4136
Ефим	Самсонова	Еремеевич	8 729 230 35 43	2548 152194	среднее профессиональное	4137
Михей	Максимова	\N	89145933773	9940 373015	среднее профессиональное	4138
Лазарь	Михеев	\N	8 (687) 551-32-26	1636 895807	неоконченное высшее	4139
Лев	Агафонова	Всеволодович	8 552 509 1347	2753 644235	среднее	4140
Дорофей	Громова	Терентьевич	+7 725 670 17 94	1604 736004	\N	4141
Дарья	Богданов	\N	8 (858) 541-5144	8863 396047	среднее	4142
Виктор	Селезнев	\N	8 (607) 620-3990	8862 291808	неоконченное высшее	4143
Викторин	Киселев	\N	84251726071	4495 536509	неоконченное высшее	4144
Сергей	Кошелев	\N	+7 987 482 34 81	4582 642035	среднее профессиональное	4145
Тарас	Лихачева	Никифоровна	+7 516 553 35 72	1576 328874	неоконченное высшее	4146
Чеслав	Михайлова	\N	+7 (768) 242-11-18	3763 165277	среднее профессиональное	4147
Селиверст	Уварова	Чеславович	+77741730483	4596 625003	среднее профессиональное	4148
Агафья	Шашков	Антоновна	8 (004) 449-7675	6086 198762	среднее	4149
Эмиль	Турова	\N	+7 (704) 662-33-57	3054 144268	среднее	4150
Исай	Аксенова	Эдгардович	8 (946) 446-3947	6055 126016	\N	4151
Агафон	Новиков	\N	89002221841	6059 701027	неоконченное высшее	4152
Сидор	Воронцов	\N	89636163486	1377 544968	неоконченное высшее	4153
Леонтий	Агафонова	Владиславовна	+7 (142) 703-68-33	7711 892264	высшее	4154
Лидия	Казаков	Станиславовна	8 923 265 2188	1745 202620	\N	4155
Панкратий	Макаров	\N	8 410 086 56 46	9067 245828	высшее	4156
Наркис	Якушева	\N	+7 (020) 863-90-56	4983 868943	среднее	4157
Панкрат	Данилов	Гертрудович	8 657 384 58 53	2664 718426	среднее	4158
Раиса	Белозеров	\N	+7 (276) 267-80-49	7738 614746	среднее	4159
Любим	Зыков	\N	8 (102) 759-7209	5157 325444	неоконченное высшее	4160
Мечислав	Калинин	\N	8 (215) 375-2389	9263 450059	\N	4161
Никита	Аксенов	Викентьевич	+7 (005) 617-83-25	8737 944850	\N	4163
Самсон	Александрова	Андреевна	+70489206818	8463 489982	среднее	4164
Фирс	Фокина	Валерьевич	+7 202 449 39 04	1529 688352	высшее	4165
Христофор	Петухова	Владиславовна	8 969 332 2350	4423 243932	\N	4166
Лаврентий	Громов	\N	+7 284 451 21 12	1845 926722	среднее профессиональное	4167
Любовь	Ларионова	Николаевна	8 387 284 85 68	3419 278794	высшее	4168
Ладимир	Антонов	Артемовна	+7 (532) 720-7740	2092 991580	\N	4169
Фаина	Агафонова	\N	+77294232516	4759 783331	среднее	4170
Наум	Шубина	\N	8 654 294 3936	3299 886466	неоконченное высшее	4171
Александр	Гаврилова	\N	+7 (819) 421-7994	7232 961814	неоконченное высшее	4172
Регина	Горбунова	\N	8 315 637 2448	6624 150426	среднее	4173
Аверьян	Гаврилова	\N	+7 (131) 461-2343	9249 340255	среднее профессиональное	4174
Станимир	Гаврилов	Аверьянович	+7 (014) 954-5494	3458 959629	неоконченное высшее	4175
Тихон	Рогова	Артемовна	8 915 110 05 47	8624 153319	\N	4176
Ерофей	Комиссаров	Владиленович	+7 221 379 73 15	1492 826374	\N	4177
Ипполит	Самойлова	Иосифович	+7 (853) 768-53-55	8300 512465	среднее профессиональное	4178
Любосмысл	Кондратьева	Афанасьевич	8 890 797 7722	7773 930960	неоконченное высшее	4179
Спартак	Михеева	Васильевич	+7 795 880 3366	8827 929604	среднее профессиональное	4180
Станимир	Фролов	\N	85264922431	5566 957258	среднее	4181
Святослав	Волкова	Филимонович	+7 (778) 414-4125	3084 343441	неоконченное высшее	4182
Людмила	Беляева	Ааронович	+7 946 769 81 92	4236 999998	среднее профессиональное	4183
Прокл	Лыткин	Кузьминична	+7 479 412 91 44	7089 770809	\N	4184
Гедеон	Ефремова	\N	8 532 372 8534	8247 575181	среднее профессиональное	4185
Никодим	Муравьев	Фокич	8 (317) 214-6872	1536 524599	среднее профессиональное	4186
Тимур	Гурьева	\N	8 (320) 112-9250	2607 192017	среднее	4187
Рубен	Козлов	\N	8 (904) 672-5994	3737 525884	высшее	4188
Лаврентий	Кузнецова	Степановна	8 728 321 1479	9488 662872	среднее	4189
Светлана	Артемьев	\N	8 (073) 743-34-24	6223 816638	неоконченное высшее	4190
Иванна	Смирнова	Глебович	87933537219	3648 275227	высшее	4191
Милица	Кудрявцев	Натановна	8 517 958 92 30	9080 960307	неоконченное высшее	4192
Константин	Вишняков	\N	8 151 429 36 62	6342 987390	среднее профессиональное	4193
Леонтий	Мартынов	\N	8 873 220 95 66	6229 241514	\N	4194
Мирон	Киселев	Абрамович	8 (300) 543-14-65	8490 571916	высшее	4195
Ипполит	Семенов	Германович	8 160 759 6631	9376 723077	неоконченное высшее	4196
Радислав	Михеева	Адрианович	+74901010907	5461 302460	среднее профессиональное	4197
Евгения	Котова	Августович	8 (153) 879-80-75	5837 899144	среднее	4198
Надежда	Шарова	\N	+71494702865	4568 580245	\N	4199
Сидор	Мясников	\N	+7 (802) 910-8647	5848 812754	среднее	4200
Савелий	Мишин	\N	8 338 075 1728	4163 800331	\N	4201
Нифонт	Королев	\N	+7 230 304 71 74	3107 346581	\N	4202
Аристарх	Семенов	\N	+7 869 333 52 21	3326 789556	среднее	4203
Ульяна	Юдина	\N	85438843839	4757 712025	неоконченное высшее	4204
Капитон	Никонов	Михайловна	+77401862923	1927 420391	неоконченное высшее	4205
Парфен	Горбунов	\N	+7 989 946 9424	6173 324252	\N	4206
Клавдий	Афанасьева	\N	+7 348 745 2169	3897 121891	высшее	4207
Тимур	Панфилов	Богданович	8 (195) 818-48-69	6776 371385	\N	4208
Герман	Лобанов	Георгиевич	8 005 112 8311	1133 854981	\N	4209
Руслан	Маслова	\N	+7 (692) 413-5848	7920 688337	\N	4210
Нифонт	Ершов	\N	+7 (982) 361-2822	1594 267585	\N	4211
Иванна	Хохлова	Харитоновна	+7 (870) 741-23-99	8854 895063	среднее	4212
Аким	Воробьева	\N	+77758083097	2715 119182	среднее профессиональное	4213
Велимир	Гурьев	Харлампович	8 (444) 085-33-44	3952 597783	высшее	4214
Евстигней	Константинова	\N	+7 893 799 93 52	7880 149605	неоконченное высшее	4215
Сидор	Кудрявцева	\N	+73805508555	9545 927755	\N	4216
Галина	Козлов	Олеговна	8 256 435 82 26	4170 183878	высшее	4217
Святослав	Якушева	\N	8 144 885 3236	8696 395639	среднее профессиональное	4218
Эмиль	Ширяев	\N	+7 648 518 8652	1086 324455	среднее	4219
Венедикт	Афанасьев	Павловна	+7 974 411 26 57	4950 247529	среднее	4220
Евстигней	Миронов	Аксёнович	8 938 260 5405	5631 688037	высшее	4221
Светлана	Дьячкова	\N	8 727 552 66 38	7133 712890	среднее	4222
Марина	Доронина	\N	+7 (293) 016-21-93	6546 152324	высшее	4223
Таисия	Карпов	Германович	8 687 461 90 85	6032 996038	\N	4224
Ян	Лебедев	\N	84922417664	1609 879230	среднее	4225
Агафон	Щербаков	Викентьевич	+73079579172	1012 461223	неоконченное высшее	4226
Геннадий	Носков	Андреевич	8 (090) 082-41-07	6987 422902	неоконченное высшее	4227
Потап	Миронов	Васильевна	+7 955 715 12 12	2566 646785	неоконченное высшее	4228
Бажен	Иванова	\N	+7 (425) 268-71-11	5954 643967	\N	4229
Никифор	Фокин	Игнатович	8 (943) 044-9474	2342 434582	среднее	4230
Святополк	Исаков	Гавриилович	85900827422	3580 657106	среднее	4231
Петр	Шилов	\N	8 (482) 547-50-16	2691 355799	среднее профессиональное	4232
Порфирий	Миронов	\N	84004156618	2411 880476	среднее профессиональное	4233
Селиван	Ермакова	Ивановна	8 626 199 2377	8132 940759	среднее	4234
Сергей	Яковлев	\N	8 715 262 2493	1180 194194	\N	4235
Ярополк	Федосеева	Демьянович	+7 171 445 7616	1108 261791	среднее	4236
Савва	Пахомова	\N	8 902 835 6181	7769 463998	неоконченное высшее	4237
Феофан	Ларионова	Изотович	8 (820) 671-9806	9564 395575	среднее	4238
Радислав	Дмитриева	Андреевич	8 444 175 12 46	8510 710778	среднее профессиональное	4239
Исидор	Галкин	\N	8 357 514 7509	3531 110198	\N	4240
Игнатий	Ларионова	Аверьянович	8 (627) 118-3894	5017 300465	\N	4241
Агап	Соколов	\N	+7 424 578 4452	8949 137293	среднее	4242
Ипатий	Капустина	\N	8 (200) 365-7398	6073 175753	неоконченное высшее	4243
Клавдия	Кузнецова	\N	+7 120 964 04 32	7916 751178	среднее	4244
Гордей	Гущин	\N	8 (333) 009-2846	3016 927437	\N	4245
Владлен	Туров	Федоровна	8 324 239 7604	3481 202075	неоконченное высшее	4246
Капитон	Ильин	Семеновна	+7 (443) 068-90-33	7741 334177	высшее	4247
Георгий	Горшков	\N	+7 (213) 090-5280	9524 629988	среднее профессиональное	4248
Нонна	Волков	Владимировна	+7 (689) 049-4793	8826 691536	среднее	4249
Ангелина	Харитонов	Исидорович	8 (311) 237-18-42	5368 881514	высшее	4250
Людмила	Красильникова	Изотович	+7 960 232 4303	4663 749425	\N	4251
Боян	Зыкова	Федотович	8 (574) 250-3925	8790 934669	среднее профессиональное	4252
Мефодий	Рябова	\N	89551714067	4941 997884	среднее	4253
Фока	Евдокимов	\N	+7 231 922 54 78	8358 290154	высшее	4254
Радим	Ильин	Львовна	+7 197 776 20 50	7166 358260	\N	4255
Софон	Шаров	\N	+7 086 460 1392	6017 687388	высшее	4256
Эдуард	Зиновьева	\N	+7 026 125 0080	2166 336981	высшее	4257
Капитон	Пахомова	Юльевич	8 692 277 69 75	7614 298153	среднее профессиональное	4258
Любим	Родионова	\N	8 (002) 682-84-05	1508 234554	\N	4259
Иванна	Прохоров	Устинович	8 102 189 2090	5976 466816	неоконченное высшее	4260
Ульян	Бобылев	Геннадиевна	83110640409	1664 801160	среднее	4261
Эдуард	Селезнев	\N	+7 073 928 18 67	3951 453812	высшее	4262
Сидор	Пономарев	\N	81416358920	3648 455882	неоконченное высшее	4263
Таисия	Петрова	Антоновна	8 805 641 58 25	8673 849822	среднее профессиональное	4264
Лучезар	Кабанова	Жоресович	+73762859864	6889 542612	среднее профессиональное	4265
Емельян	Суханов	Герасимович	+7 (701) 212-82-29	4838 215195	среднее	4266
Трифон	Евсеев	Антонович	86643993369	8134 397907	среднее	4267
Любомир	Владимиров	\N	+7 (750) 408-4204	9408 256712	высшее	4268
Сергей	Мухина	Артемьевич	82636606839	9433 933546	\N	4269
Виссарион	Ларионов	\N	+75593198704	9909 717192	среднее	4270
Амос	Ершова	Тимофеевна	80994558150	8674 949570	высшее	4271
Тарас	Третьякова	\N	+7 (346) 145-2586	5625 711168	неоконченное высшее	4272
Раиса	Дмитриева	Эдуардовна	+7 (816) 716-8587	6151 972052	неоконченное высшее	4273
Анатолий	Кузьмина	Тимуровна	8 (132) 349-2970	9574 210992	неоконченное высшее	4274
Наина	Бирюков	\N	+7 981 478 1420	4677 404340	среднее профессиональное	4275
Валерия	Ефимова	\N	+7 (775) 168-6493	1492 916362	неоконченное высшее	4276
Аникей	Мухина	\N	+77808628634	4989 197806	высшее	4277
Зинаида	Маркова	\N	+7 842 698 1986	8100 502462	\N	4278
Владлен	Некрасова	\N	+7 (409) 661-1027	3762 827172	среднее	4279
Галина	Моисеев	Борисовна	+7 685 995 34 29	4218 173196	высшее	4280
Агафон	Одинцов	Аркадьевна	8 (552) 110-02-20	2969 539469	среднее	4281
Игнатий	Ильина	\N	+7 006 064 58 70	6524 664777	высшее	4282
София	Блохин	Антипович	+76343799495	4317 375306	\N	4283
Орест	Филиппов	Арсеньевич	+7 464 483 79 55	6399 924254	среднее профессиональное	4284
Валерьян	Гришина	Кузьминична	8 (221) 675-1098	1967 566690	неоконченное высшее	4285
Кир	Юдина	Алексеевич	8 955 428 0403	4013 993307	неоконченное высшее	4286
Викторин	Дроздова	Кузьминична	8 (557) 620-7435	1308 990259	неоконченное высшее	4287
Модест	Петров	Григорьевич	8 962 316 21 03	3817 886957	неоконченное высшее	4288
Сила	Тихонов	Владленович	8 240 833 9289	9211 725117	высшее	4289
Милица	Соколов	Вячеславович	8 (230) 721-5443	7204 788235	неоконченное высшее	4290
Оксана	Евдокимова	\N	+7 (570) 002-5868	3008 710687	высшее	4291
Фаина	Муравьева	\N	+7 (234) 692-1537	5872 673906	среднее	4292
Карп	Дементьева	Харлампович	8 494 553 6133	1145 433249	\N	4293
Надежда	Волкова	\N	8 026 793 4899	4726 588175	высшее	4294
Пахом	Буров	Ивановна	+7 (953) 980-8127	4471 685609	\N	4295
Харитон	Дроздов	\N	8 (800) 667-30-26	9373 216593	среднее	4296
Гаврила	Игнатов	Аркадьевна	8 949 667 84 20	4412 898346	высшее	4297
Влас	Давыдова	Теймуразович	+7 378 256 7168	5667 791359	\N	4298
Зосима	Родионова	Архиповна	+7 828 393 57 52	9189 434311	среднее профессиональное	4299
Эммануил	Щербаков	Демьянович	+7 (031) 727-12-11	6082 816593	среднее	4300
Модест	Цветкова	\N	+79545313900	4323 619965	неоконченное высшее	4301
Евгения	Ларионова	Павловна	8 205 536 6425	7838 614493	\N	4302
Мина	Вишняков	\N	+75863353364	7333 866916	высшее	4303
Мир	Цветков	Чеславович	+7 (294) 187-0695	7438 425099	неоконченное высшее	4304
Виталий	Никитина	\N	+7 653 436 6115	7503 133775	\N	4305
Демид	Вишняков	\N	+7 (721) 097-4501	8415 842535	неоконченное высшее	4306
Радислав	Власова	Филиппович	+7 (981) 758-40-60	4044 252862	\N	4307
Светозар	Архипова	Борисовна	+7 885 516 2772	7951 389444	неоконченное высшее	4308
Прокофий	Устинова	\N	+7 (329) 847-1337	2246 661761	среднее профессиональное	4309
Феликс	Федосеева	\N	8 453 116 7318	5898 263182	среднее профессиональное	4310
Бронислав	Пономарева	Давидович	8 (015) 754-7782	2789 656347	среднее профессиональное	4311
Велимир	Максимов	\N	+7 961 413 4360	7816 107069	среднее	4312
Спартак	Матвеев	Михайловна	+7 469 271 20 30	5635 572331	высшее	4313
Аникита	Алексеев	\N	+7 (113) 689-51-65	6230 797785	неоконченное высшее	4314
Эмилия	Сергеев	\N	8 (019) 010-43-28	1762 424964	среднее профессиональное	4315
Зосима	Савина	Леоновна	+7 (959) 088-78-47	7828 911692	неоконченное высшее	4316
Юрий	Сафонова	\N	+7 293 122 32 91	1825 578224	среднее	4317
Дарья	Калашников	Ильич	89282545042	8771 909345	среднее профессиональное	4318
Ростислав	Савельева	\N	8 710 721 0584	7141 210604	среднее профессиональное	4319
Полина	Родионов	Терентьевич	8 (282) 299-62-99	4810 501767	высшее	4320
Савва	Ефремов	Елизарович	+73883207971	3375 827949	среднее профессиональное	4321
Харитон	Крюкова	Аркадьевна	8 678 295 9102	1450 268383	неоконченное высшее	4322
Моисей	Третьяков	\N	+73205623397	6614 231150	среднее	4323
Феоктист	Филиппова	Валентиновна	+7 (822) 867-72-90	7319 152118	высшее	4324
Карп	Ларионова	\N	+71587954272	8658 455693	среднее	4325
Касьян	Бирюкова	Якубович	+7 448 951 33 06	5980 615535	высшее	4326
Адам	Веселова	Афанасьевна	+7 209 910 71 64	7413 292077	среднее профессиональное	4327
Мария	Селиверстова	Марсович	+7 499 661 8760	5313 886412	среднее профессиональное	4328
Милий	Попов	\N	+70244608029	7465 224110	среднее	4329
Феликс	Фролов	Харлампович	+76596634460	5679 535831	среднее профессиональное	4330
Никандр	Суханов	\N	+7 603 437 2009	8212 307638	среднее	4331
Ульян	Денисова	Руслановна	8 (668) 885-53-81	5073 444250	среднее	4332
Сергей	Елисеева	Александровна	8 (602) 720-0494	5639 295631	высшее	4333
Гремислав	Лобанов	Владиславовна	+74542454272	8129 554800	среднее	4334
Севастьян	Филиппова	Игоревич	+7 285 349 1648	7844 145034	высшее	4335
Леонтий	Гущин	Якубович	8 847 992 7351	4792 637473	среднее	4336
Будимир	Игнатова	\N	+7 335 300 82 86	3703 303407	среднее профессиональное	4337
Евсей	Комарова	Авдеевич	+7 (540) 587-77-13	3535 785570	среднее профессиональное	4338
Милован	Дроздова	Эдгардович	8 806 156 19 43	8898 365612	высшее	4339
Прохор	Гурьев	Ефимьевич	8 (926) 757-85-48	8236 987440	неоконченное высшее	4340
Иларион	Мельников	Вилорович	+7 (719) 891-43-44	5475 162010	\N	4341
Филипп	Нестеров	\N	89165754827	1767 274478	среднее профессиональное	4342
Екатерина	Дьячков	\N	8 360 254 3837	5319 612741	неоконченное высшее	4343
Элеонора	Горбунов	\N	+70773848006	5925 304737	\N	4344
Акулина	Селиверстов	Ивановна	+74543288513	4196 232675	среднее	4345
Януарий	Самойлов	Феодосьевич	85711535516	6165 443867	\N	4346
Евстигней	Щукин	\N	8 (425) 803-2559	7672 223405	\N	4347
Лукия	Самойлова	\N	+7 128 500 8588	6583 773032	\N	4348
Мина	Куликов	Афанасьевна	+7 (397) 694-7301	4104 801342	неоконченное высшее	4349
Творимир	Максимова	\N	83426792669	8127 409104	\N	4350
Георгий	Туров	Демидович	+7 (572) 621-83-28	3304 576027	\N	4351
Ерофей	Абрамов	\N	8 800 812 0937	9492 469513	среднее профессиональное	4352
Александра	Терентьев	Оскаровна	8 138 898 33 37	8656 226805	среднее профессиональное	4353
Емельян	Филатов	Харлампьевич	8 321 264 3583	1580 160685	среднее	4354
Аполлон	Титов	\N	+72499269640	5039 939297	неоконченное высшее	4355
Ладислав	Жуков	\N	8 (643) 897-58-21	6546 603874	среднее	4356
Антонина	Андреева	Теймуразович	8 (494) 768-9777	2730 191565	высшее	4357
Ираида	Королев	Дмитриевна	8 203 735 6900	9792 553484	среднее профессиональное	4358
Ерофей	Анисимова	\N	8 (478) 074-9165	5209 208245	\N	4359
Василий	Красильников	\N	8 008 230 9662	1319 973272	высшее	4360
Нестор	Хохлова	\N	+7 576 255 7960	1801 614226	высшее	4361
Филарет	Федоров	\N	8 (543) 409-1663	8660 960650	среднее профессиональное	4362
Дементий	Панфилов	Леонидовна	+7 575 383 4151	1104 989739	среднее профессиональное	4363
Анжела	Маслова	\N	8 012 521 58 59	3039 213305	среднее	4364
Селиверст	Белова	Владиславович	+7 212 316 6442	2041 478226	высшее	4365
Ефрем	Лапина	\N	+7 (194) 371-67-80	1270 425794	среднее	4366
Герасим	Хохлов	\N	8 (904) 968-3762	6369 954544	\N	4367
Карл	Маслова	Николаевна	8 518 001 0321	9559 730934	среднее профессиональное	4368
Фирс	Абрамов	\N	83632273169	7339 245842	\N	4369
Ратмир	Уваров	\N	80281615372	2961 813771	неоконченное высшее	4370
Ефим	Буров	Владиславовна	8 (698) 482-86-79	8169 983313	\N	4371
Емельян	Колесникова	Ниловна	8 655 838 35 01	6697 390671	среднее	4372
Всеслав	Маслова	Матвеевна	+7 276 300 3760	4213 518852	\N	4373
Владимир	Зыков	\N	84601955576	7591 758802	среднее	4374
Евсей	Белякова	Арсеньевич	+78190403684	3431 746066	высшее	4375
Порфирий	Владимиров	\N	+75300943251	6651 315633	высшее	4376
Владилен	Максимов	Денисович	+7 (459) 408-6186	5015 944727	\N	4377
Пантелеймон	Григорьева	Александровна	8 (113) 582-5133	7924 839785	высшее	4378
Ратмир	Архипов	Яковлевич	+7 (323) 412-3207	4806 316558	неоконченное высшее	4379
Азарий	Волков	\N	8 (824) 395-8683	3571 575631	неоконченное высшее	4380
Ирина	Пахомова	Игнатович	+7 (984) 273-24-18	2979 663395	неоконченное высшее	4381
Евдокия	Рогова	\N	+7 (922) 617-94-73	1908 402265	высшее	4382
Эдуард	Ефремов	Егоровна	+7 846 395 2005	8227 611128	среднее	4383
Иван	Большакова	Наумовна	+7 818 533 96 41	9948 694169	высшее	4384
Анатолий	Куликов	Захаровна	8 420 212 9098	8368 504807	\N	4385
Андрон	Воробьев	\N	+7 (988) 426-99-46	9784 827768	среднее профессиональное	4386
Никон	Шаров	\N	8 (573) 775-36-20	5835 620000	неоконченное высшее	4387
Олег	Гусева	\N	+7 (313) 549-25-72	7654 227869	высшее	4388
Ксения	Абрамова	Евгеньевна	+7 751 848 9345	1992 491744	неоконченное высшее	4389
Фрол	Комиссарова	\N	8 331 765 89 92	5622 962460	неоконченное высшее	4390
Филарет	Дмитриева	Гордеевич	8 741 962 14 44	8344 489926	среднее профессиональное	4391
Клавдия	Маслов	Алексеевич	8 (041) 607-2062	2066 121564	неоконченное высшее	4392
Сидор	Афанасьева	\N	8 (219) 071-8175	6448 380902	среднее	4393
Дмитрий	Рожкова	Александровна	+7 818 073 5765	8235 845816	среднее	4394
Любомир	Новиков	\N	+7 (726) 089-16-40	7586 328625	\N	4395
Фёкла	Михайлова	\N	+7 (449) 546-50-87	3660 670400	\N	4396
Ярослав	Афанасьев	\N	8 (421) 970-0238	1291 342519	среднее профессиональное	4397
Парамон	Брагина	\N	+7 942 551 3587	9148 679048	\N	4398
Кира	Тарасов	\N	8 (483) 208-73-04	9067 921761	среднее профессиональное	4399
Синклитикия	Устинов	\N	84048480714	4166 535324	\N	4400
Панкратий	Пономарев	Тарасович	+7 (395) 102-79-98	5471 355528	неоконченное высшее	4401
Никодим	Горбунов	Ефстафьевич	+72529743872	8803 374141	среднее	4402
Ермил	Капустин	\N	+7 858 772 5350	8927 254453	высшее	4403
Данила	Фокина	Егорович	8 231 177 57 26	1836 109909	высшее	4404
Марина	Константинов	Вениаминовна	+7 (670) 761-0049	2559 241255	высшее	4405
Дорофей	Колесников	Виленович	+71789704063	2280 898706	среднее	4406
Добромысл	Воронцова	\N	+7 (453) 036-0049	2784 405964	неоконченное высшее	4407
Милен	Голубев	Викторович	81991972248	1021 351757	среднее	4408
Адам	Дорофеева	\N	+7 (179) 754-2489	2992 168457	среднее профессиональное	4409
Евстафий	Савельев	\N	+7 109 051 4802	1357 820508	\N	4410
Леонид	Мартынов	\N	+7 563 345 11 28	7561 935484	\N	7222
Элеонора	Лихачева	\N	88075117331	5673 511756	среднее профессиональное	4411
Зоя	Гущин	Тарасович	8 026 084 3267	6842 457858	среднее	4412
Любовь	Логинов	\N	89630674254	2734 762289	неоконченное высшее	4413
Василиса	Артемьева	Харитоновна	8 (737) 606-77-31	1261 451723	неоконченное высшее	4414
Никандр	Тихонова	Максимовна	8 (257) 268-18-32	5718 266978	высшее	4415
Ян	Сазонова	Яковлевна	+7 (498) 332-9481	6818 606000	высшее	4416
Никодим	Комиссаров	Теймуразович	+7 (794) 023-4809	1145 541697	неоконченное высшее	4417
Чеслав	Макаров	\N	+76106663912	7654 446708	неоконченное высшее	4418
Радим	Меркушев	Андреевна	86957303335	4251 530667	неоконченное высшее	4419
Нестор	Маслов	\N	+7 (539) 738-8996	1411 144741	среднее	4420
Иосиф	Исакова	Григорьевич	8 770 284 4868	9828 992495	высшее	4421
Поликарп	Калашников	\N	+7 (946) 562-54-26	1308 693971	среднее профессиональное	4422
Евфросиния	Белова	Архипович	+7 (421) 788-8161	5522 705506	неоконченное высшее	4423
Ефим	Суворова	\N	+7 382 864 8703	8938 132746	неоконченное высшее	4424
Любомир	Белоусова	\N	+7 016 008 6435	5542 241013	\N	4425
Агафон	Самсонов	\N	+70006453426	8999 271662	высшее	4426
Радован	Колесников	\N	8 592 040 02 83	2129 414596	высшее	4427
Станимир	Копылова	\N	8 143 265 0342	8520 336145	среднее профессиональное	4428
Ипат	Тарасов	\N	+7 (325) 608-06-61	3761 550940	\N	4429
Юлия	Поляков	Геннадиевна	+7 (140) 767-9161	6624 289973	среднее профессиональное	4430
Октябрина	Кононова	\N	+71577248950	7659 597676	высшее	4431
Пелагея	Турова	Юлианович	8 798 788 0584	1783 198472	\N	4432
Лучезар	Филатов	Валентинович	8 (153) 400-3217	6113 415239	среднее профессиональное	4433
Терентий	Крылова	\N	+7 (976) 866-9772	8611 673031	\N	4434
Виталий	Галкина	Архиповна	8 (124) 690-77-77	8335 387892	\N	4435
Мир	Афанасьев	\N	8 436 620 08 20	1043 938815	неоконченное высшее	4436
Евдоким	Евсеев	\N	+7 (711) 935-45-80	7977 628187	среднее	4437
Пахом	Субботина	Андреевич	+76642593937	5560 429001	\N	4438
Захар	Лаврентьев	\N	81112427820	8686 957831	\N	4439
Адам	Белякова	Мироновна	+7 (468) 779-4416	7518 839955	среднее	4440
Валерьян	Прохоров	Демьянович	8 (213) 234-3059	8223 765305	среднее профессиональное	4441
Куприян	Носков	\N	+7 (001) 798-1003	5242 262807	среднее профессиональное	4442
Владимир	Карпов	Игнатьевич	+7 (660) 115-3459	4990 282984	неоконченное высшее	4443
Ефим	Зыкова	Харитонович	+7 (676) 969-45-73	4004 826947	\N	4444
Ульян	Суворов	\N	8 (485) 661-7251	3295 976148	\N	4445
Эммануил	Савин	\N	8 097 104 72 84	5640 298478	\N	4446
Эмилия	Филиппова	Евсеевич	+7 (745) 464-5779	9603 615984	\N	4447
Варвара	Медведева	Егоровна	81018778715	2251 614423	высшее	4448
Нонна	Тетерина	Брониславович	8 819 331 46 54	5961 235996	среднее профессиональное	4449
Артемий	Капустина	\N	8 (481) 274-1831	2582 490034	\N	4450
Сергей	Ковалев	Андреевна	+76537847824	3055 546445	среднее	4451
Надежда	Фролов	Мироновна	+7 (361) 733-60-08	6539 968975	среднее профессиональное	4452
Ярополк	Горшкова	\N	8 068 167 9243	3946 755442	\N	4453
Михей	Федотов	Гордеевич	8 (758) 865-35-69	9335 378312	среднее профессиональное	4454
Синклитикия	Пестов	\N	8 848 738 6029	1767 159889	неоконченное высшее	4455
Анжела	Гурьева	\N	8 854 576 42 77	6207 957779	среднее	4456
Ермил	Савельева	Федосеевич	8 536 398 39 89	6496 587717	\N	4457
Ермил	Федотова	Кузьминична	82709728162	9848 347884	\N	4458
Епифан	Орлов	\N	8 385 426 9953	4310 976352	высшее	4459
Вадим	Фролов	Матвеевич	8 046 077 72 77	6566 774149	неоконченное высшее	4460
Каллистрат	Мамонтов	Анатольевна	+7 (866) 345-27-52	8189 775265	\N	4461
Лора	Воробьев	Ильинична	+7 140 396 7812	4862 321208	\N	4462
Панфил	Евсеева	\N	8 (912) 754-18-58	3169 351442	среднее	4463
Антонин	Максимов	Марсович	+7 743 348 5337	8318 191675	неоконченное высшее	4464
Родион	Алексеев	Фокич	8 (038) 888-03-45	3001 387553	\N	4465
Спиридон	Герасимова	\N	+7 556 273 96 45	3292 241312	неоконченное высшее	4466
Исидор	Иванова	\N	+7 (246) 593-6354	2831 144866	среднее	4467
Лаврентий	Блохин	Брониславович	+75086107375	4962 973403	\N	4468
Климент	Горшкова	\N	8 189 902 1495	6119 606493	\N	4469
Тамара	Горбачев	Ефимьевич	+7 (970) 758-9299	1175 167359	среднее профессиональное	4470
Олимпий	Селезнева	Тарасовна	+7 811 434 1245	6068 530740	\N	4471
Антонина	Яковлева	\N	8 053 871 0449	9359 514425	среднее профессиональное	4472
Яков	Никитин	\N	+74469066878	4464 964361	неоконченное высшее	4536
Пимен	Артемьева	Гавриилович	8 (865) 400-9173	4644 213688	неоконченное высшее	4473
Герасим	Мамонтов	\N	84413069626	5057 654847	\N	4474
Ульян	Сысоева	\N	88480575392	7045 866075	высшее	4475
Феофан	Куликов	\N	8 943 654 1732	2995 553961	высшее	4476
Антонина	Мишина	\N	8 518 972 84 59	4313 519975	высшее	4477
Артем	Новикова	Данилович	89662182077	3940 233967	среднее профессиональное	4478
Рюрик	Веселова	\N	+7 (437) 102-7869	3976 910546	\N	4479
Пров	Чернов	\N	+75458471088	4538 101020	\N	4480
Ермил	Яковлев	\N	8 547 033 9679	9069 328771	неоконченное высшее	4481
Лучезар	Сафонов	Геннадиевич	8 745 525 60 36	3522 293491	среднее	4482
Леонид	Буров	\N	8 152 400 2986	6081 496675	среднее	4483
Аполлон	Миронова	\N	+7 526 071 0844	5645 112190	высшее	4484
Филарет	Лобанов	Наумовна	89308568878	2274 915579	среднее	4485
Сергей	Комарова	\N	+7 (611) 745-87-11	4594 857775	среднее профессиональное	4486
Харлампий	Петрова	Жоресович	8 (541) 392-4965	3468 782536	неоконченное высшее	4487
Клавдий	Логинова	Харитоновна	8 (661) 886-52-91	5542 777213	\N	4488
Иванна	Исаков	\N	+7 (305) 694-5434	6802 852908	\N	4489
Онуфрий	Стрелков	Захарьевич	+7 416 727 8096	2912 762914	высшее	4490
Евпраксия	Маркова	Эдуардович	82760111378	6894 858183	среднее	4491
Олимпий	Беляева	\N	8 888 825 8664	2383 887147	высшее	4492
Евдоким	Денисова	\N	8 (560) 746-34-14	9786 231107	высшее	4493
Руслан	Мамонтова	\N	8 (105) 065-07-51	1043 591360	неоконченное высшее	4494
Лучезар	Давыдов	Юльевич	+7 (369) 168-90-45	5954 764834	среднее профессиональное	4495
Милица	Королева	Гертрудович	8 (243) 513-1650	6737 960410	высшее	4496
Николай	Мишин	Брониславович	82892228218	3789 295965	\N	4497
Ефрем	Зайцев	\N	8 430 254 41 96	9707 157839	высшее	4498
Артем	Рябова	\N	+78036170232	7919 109808	\N	4499
Елизавета	Родионова	Ивановна	8 777 623 6222	8873 494662	неоконченное высшее	4500
Тамара	Комиссарова	\N	+7 341 618 92 02	8987 434782	неоконченное высшее	4501
Яков	Родионов	\N	+7 419 418 4619	9796 200074	неоконченное высшее	4502
Артем	Кузнецов	Яковлевна	8 779 604 8979	4915 580269	высшее	4503
Вениамин	Федорова	\N	8 (354) 620-89-85	8017 446530	высшее	4504
Валерьян	Тарасова	\N	88353108360	8047 200459	среднее профессиональное	4505
Емельян	Ситников	\N	82027741335	6856 132325	среднее	4506
Иосиф	Лихачева	Константиновна	8 498 314 7343	3180 565252	среднее профессиональное	4507
Ираида	Ершова	\N	+7 (423) 810-1281	2495 146045	\N	4508
Болеслав	Силин	Геннадьевна	+78569536564	8231 291913	неоконченное высшее	4509
Николай	Третьяков	\N	8 (119) 634-85-27	6193 941859	неоконченное высшее	4510
Евдокия	Большакова	\N	+75326337487	9703 433584	среднее профессиональное	4511
Поликарп	Рыбаков	\N	+7 784 061 6449	2468 748565	высшее	4512
Милен	Самсонова	\N	+7 029 475 10 55	1298 296876	среднее профессиональное	4513
Ия	Гаврилова	Васильевич	+7 271 402 0450	8570 807607	среднее	4514
Владислав	Шашков	\N	+7 825 058 56 63	3146 844754	высшее	4515
Агап	Лихачев	Геннадиевна	+7 522 482 9697	7675 482392	среднее	4516
Светозар	Гришин	\N	8 (948) 053-0745	8423 793356	среднее профессиональное	4517
Куприян	Лебедев	Кирилловна	+7 024 925 67 29	3943 508462	\N	4518
Григорий	Гущина	\N	8 (570) 526-88-74	9876 541133	среднее	4519
Феофан	Субботин	Юльевич	+7 (727) 388-0284	5761 147138	среднее	4520
Аверьян	Некрасова	\N	+7 266 868 3309	6227 674576	среднее профессиональное	4521
Флорентин	Колесников	Ивановна	+7 (985) 876-3164	5518 652637	высшее	4522
Евстигней	Шарапова	\N	8 (715) 421-6640	9461 428602	среднее	4523
Фома	Лапина	Сергеевна	+7 (082) 637-61-59	1359 774371	среднее профессиональное	4524
Агата	Сергеев	Жанович	8 (417) 667-64-89	9433 279429	неоконченное высшее	4525
Никандр	Белоусов	\N	8 (313) 691-22-14	1999 884362	среднее профессиональное	4526
Мирон	Александров	\N	8 (747) 545-32-57	5687 610631	среднее профессиональное	4527
Феликс	Кулаков	Афанасьевич	+7 (844) 338-84-53	1663 179312	среднее	4528
Аверкий	Миронов	Ермолаевич	8 309 523 01 40	3505 127395	высшее	4529
Август	Мишина	Фокич	8 064 128 09 15	2205 767911	среднее профессиональное	4530
Павел	Галкин	Яковлевна	8 (202) 307-2453	1912 135184	высшее	4531
Наталья	Харитонова	\N	+7 (592) 483-2940	8636 766146	\N	4532
Евстигней	Анисимов	\N	8 062 992 5716	4257 524070	среднее профессиональное	4533
Ангелина	Зыков	Давыдович	+7 (569) 243-5305	2723 180827	высшее	4534
Елисей	Зимина	\N	8 (096) 045-5152	9847 167458	\N	4535
Лидия	Федосеев	Матвеевич	8 878 830 4680	7273 583792	\N	4537
Фирс	Орехова	\N	8 (265) 859-0732	4105 176666	\N	4538
Зосима	Новикова	Ефимовна	+7 959 377 4063	5582 797618	неоконченное высшее	4539
Виссарион	Титова	\N	8 123 832 22 24	7810 985337	среднее профессиональное	4540
Владилен	Зимин	Герасимович	8 730 207 6203	9618 700833	среднее профессиональное	4541
Сергей	Анисимова	\N	8 (173) 860-8899	8920 291499	высшее	4542
Агафон	Панфилова	Ефимовна	+7 (751) 021-8948	5312 181049	среднее	4543
Каллистрат	Захарова	Вилорович	8 (791) 242-43-68	8740 611263	неоконченное высшее	4544
Аркадий	Комарова	\N	8 829 931 96 14	4552 596551	среднее профессиональное	4545
Данила	Бирюкова	Юлианович	+7 (089) 031-1371	6066 614175	неоконченное высшее	4546
Ладимир	Трофимов	Святославовна	+7 844 292 46 31	5832 886673	высшее	4547
Арефий	Веселова	Борисович	8 (100) 806-9563	4224 165139	\N	4548
Константин	Кошелев	\N	8 712 810 95 90	6439 370813	неоконченное высшее	4549
Мир	Филиппова	\N	+7 (759) 516-5247	2182 429262	высшее	4550
Нифонт	Нестерова	Ильинична	+7 090 451 49 63	3040 539861	высшее	4551
Лавр	Колобов	\N	85688126748	8523 292859	среднее	4552
Нина	Одинцов	\N	+76176414226	2219 667432	\N	4553
Евфросиния	Мельникова	Владиславовна	+7 (775) 281-61-90	6540 155397	среднее профессиональное	4554
Сидор	Третьяков	\N	+7 374 691 53 67	8999 914946	среднее	4555
Дмитрий	Кулакова	Борисовна	+7 (397) 723-47-61	2098 504561	среднее профессиональное	4556
Мирослав	Титов	\N	8 (265) 767-65-57	9075 467259	среднее профессиональное	4557
Фадей	Анисимова	Богдановна	+7 (706) 726-0286	3234 188826	среднее	4558
Антонин	Филиппова	\N	+7 (085) 458-8302	9817 335069	среднее профессиональное	4559
Селиверст	Кудрявцева	Иосифович	+7 795 120 5046	6937 116446	\N	4560
Касьян	Наумова	\N	8 (578) 652-02-39	2269 757787	среднее	4561
Харитон	Панова	\N	+76194952976	8085 714639	среднее	4562
Филарет	Иванова	\N	8 (540) 573-8704	8342 126427	высшее	4563
Герман	Исаева	Арсеньевич	8 (154) 443-5678	5885 439178	среднее	4564
Севастьян	Куликова	\N	+79764002573	5997 586225	среднее профессиональное	4565
Лидия	Исакова	\N	8 (602) 076-4122	9138 598754	среднее	4566
Аким	Зайцев	\N	+7 (117) 988-1369	7254 209635	среднее профессиональное	4567
Светозар	Кабанов	\N	+7 (658) 524-88-33	4050 652398	\N	4568
Елена	Матвеев	Филипповна	8 623 595 71 07	3180 335588	среднее профессиональное	4569
Ян	Герасимова	Тимофеевна	8 771 306 46 79	9953 233887	среднее	4570
Творимир	Зимин	Александровна	8 900 192 80 56	6487 130972	\N	4571
Спиридон	Абрамов	\N	8 (191) 071-80-82	6318 833273	неоконченное высшее	4572
Ирина	Богданова	Олеговна	8 (883) 613-9630	9032 114032	неоконченное высшее	4573
Бронислав	Родионов	\N	82915213098	1970 909650	неоконченное высшее	4574
Афанасий	Ширяев	\N	+7 516 056 59 07	2619 152310	среднее профессиональное	4575
Харлампий	Силин	Ефимович	8 914 456 2915	6926 334612	среднее профессиональное	4576
Анастасия	Галкина	Эдуардович	+78743790916	6792 991431	высшее	4577
Андроник	Ковалева	Федосьевич	+7 (175) 205-5948	2147 173278	среднее	4578
Гурий	Зыков	\N	8 913 808 2771	3962 651561	среднее профессиональное	4579
Валерий	Данилова	Бориславович	8 656 744 1213	1491 585565	среднее профессиональное	4580
Евгения	Бобылева	Виленович	+7 (378) 876-60-95	2995 807372	среднее профессиональное	4581
Мечислав	Стрелкова	\N	+7 (474) 533-51-93	7140 925840	среднее	4582
Леонтий	Рожков	Гаврилович	+7 544 712 13 86	4161 149577	среднее профессиональное	4583
Лука	Павлова	Фомич	+7 051 656 90 39	1064 430121	\N	4584
Милица	Муравьев	\N	+7 (572) 910-9576	1216 220191	среднее	4585
Марк	Котов	Валентинович	+7 (936) 278-1727	7305 944597	среднее профессиональное	4586
Лидия	Мамонтов	Иосифович	8 (236) 558-20-89	6284 715423	среднее	4587
Фирс	Галкина	\N	+7 286 372 10 67	7554 291425	высшее	4588
Владимир	Емельянова	Захарьевич	+70502901071	9869 248900	высшее	4589
Виктория	Фадеева	Харламович	+7 (435) 821-50-43	4306 538876	среднее профессиональное	4590
Виктор	Устинов	Николаевна	+74427437338	4421 508446	среднее профессиональное	4591
Парфен	Кудрявцева	Демьянович	+7 434 253 04 28	9390 588644	высшее	4592
Степан	Иванов	\N	+7 919 472 05 71	7880 457606	среднее профессиональное	4593
Амвросий	Шашков	\N	8 (017) 754-5946	9509 589243	\N	4594
Рюрик	Пономарев	Ждановна	+7 827 370 3953	7980 544258	высшее	4595
Игнатий	Козлов	Чеславович	+7 (256) 164-71-93	8262 559634	среднее	4596
Родион	Шубин	\N	+7 762 662 61 78	7564 852674	неоконченное высшее	4597
Прокл	Крюков	Арсенович	8 861 824 38 92	5256 739592	\N	4598
Исидор	Коновалова	Егоровна	8 (884) 165-96-64	2279 977422	среднее профессиональное	4599
Светозар	Мясников	\N	+71612766654	4129 834293	\N	4600
Афанасий	Козлова	Эдгардович	8 (246) 337-7882	8080 973973	среднее профессиональное	4601
Кира	Одинцов	Харламович	+7 (074) 133-17-45	2490 632048	высшее	4602
Софрон	Сергеев	\N	8 (999) 100-96-34	5241 866881	среднее	4603
Андрон	Попова	Теймуразович	+7 641 033 7895	9231 785976	среднее	4604
Харитон	Панов	\N	+7 (745) 006-2125	7795 544691	среднее профессиональное	4605
Геннадий	Панова	Авдеевич	87146946986	6326 866461	\N	4606
Агата	Фомичева	Владиленович	8 (463) 783-4793	6183 228319	среднее	4607
Авксентий	Аксенова	\N	+7 (336) 369-0336	6294 174320	среднее профессиональное	4608
Федор	Трофимова	\N	+7 277 868 9849	3907 231827	неоконченное высшее	4609
Виссарион	Елисеева	\N	+7 (928) 071-7214	1601 786056	неоконченное высшее	4610
Андроник	Горбачева	\N	+7 427 403 37 34	5076 301758	высшее	4611
Вацлав	Гурьева	Владленович	8 (271) 200-64-34	6777 985476	неоконченное высшее	4612
Севастьян	Давыдова	\N	8 (775) 368-59-75	1497 131000	высшее	4613
Ипат	Захарова	\N	+7 (939) 267-17-47	7457 921131	высшее	4614
Викторин	Бирюкова	\N	8 994 073 97 00	3825 515865	среднее профессиональное	4615
Мартьян	Моисеев	Петровна	+7 (065) 129-6896	6679 455041	высшее	4616
Всемил	Щербаков	\N	+7 (695) 154-0731	6355 755070	неоконченное высшее	4617
Григорий	Владимирова	\N	8 922 545 7491	3506 479112	неоконченное высшее	4618
Гордей	Ситников	Исидорович	88416064720	3033 126582	неоконченное высшее	4619
Любовь	Меркушев	\N	+7 (933) 892-72-39	4032 337167	среднее профессиональное	4620
Кондрат	Кудрявцева	Архипович	8 266 877 33 20	3020 984962	\N	4621
Марина	Кириллова	Гаврилович	+7 (913) 277-88-64	9313 659476	среднее профессиональное	4622
Гурий	Носова	\N	89371858659	6954 365261	\N	4623
Антонин	Борисов	Давыдович	+7 024 270 2383	2740 382545	неоконченное высшее	4624
Гаврила	Гордеева	\N	+7 475 050 20 88	9414 225450	\N	4625
Евлампий	Гришина	\N	8 (009) 895-41-50	7939 513040	\N	4626
Осип	Большакова	\N	+7 (543) 294-3909	5470 200959	высшее	4627
Кондратий	Сысоева	Антонович	8 (515) 082-8304	4832 911746	неоконченное высшее	4628
Остап	Иванов	\N	8 073 451 4556	6704 835828	среднее профессиональное	4629
Мария	Титова	Феоктистович	8 043 170 95 82	1128 744603	\N	4630
Прохор	Савин	\N	8 082 530 3591	6251 514540	высшее	4631
Терентий	Баранова	\N	8 244 026 8665	3881 815503	высшее	4632
Максимильян	Терентьев	\N	8 (152) 650-3479	4539 174950	\N	4633
Серафим	Сидоров	\N	8 672 783 8387	8745 848206	среднее	4634
Иннокентий	Самсонов	\N	+74553039759	9344 795416	высшее	4635
Доброслав	Козлов	\N	+77802576849	4342 912633	высшее	4636
Эдуард	Кулагина	Макаровна	+79829847693	7740 177540	среднее профессиональное	4637
Елизавета	Кабанова	\N	+7 (518) 549-2830	4121 314086	среднее профессиональное	4638
София	Калашникова	Анатольевна	+7 (197) 582-4647	7219 474334	\N	4639
Ефим	Лобанова	\N	86322318911	4964 230056	среднее	4640
Януарий	Князев	\N	+7 649 799 1588	5481 391085	высшее	4641
Зиновий	Гусева	\N	8 (396) 089-8237	6210 300776	среднее	4642
Аристарх	Голубев	\N	+7 637 455 4382	7950 361740	среднее	4643
Автоном	Гаврилов	Жанович	8 (642) 310-44-64	1982 718308	высшее	4644
Януарий	Наумова	Васильевич	86118194567	2506 174273	среднее профессиональное	4645
Якуб	Устинова	\N	+7 (997) 962-27-03	7286 604177	среднее профессиональное	4646
Ипполит	Королев	\N	8 (229) 710-5837	1892 541063	неоконченное высшее	4647
Юрий	Русакова	\N	8 391 935 9499	8585 392172	неоконченное высшее	4648
Федор	Щербаков	Фёдорович	+7 581 905 9553	3488 530209	среднее профессиональное	4649
Парамон	Кулаков	\N	8 (388) 696-0888	5695 921693	\N	4650
Елизар	Галкин	Чеславович	8 684 496 0590	8512 158146	неоконченное высшее	4651
Лаврентий	Орлов	\N	89584353155	5504 639314	неоконченное высшее	4652
Андрон	Мартынова	Тарасович	+7 231 858 40 27	7457 921997	неоконченное высшее	4653
Христофор	Макарова	\N	8 922 251 78 81	5739 433611	высшее	4654
Август	Трофимова	Афанасьевна	+7 519 969 0662	8606 511223	среднее профессиональное	4655
Эмилия	Некрасова	Георгиевич	+7 (692) 207-10-60	5450 356174	высшее	4656
Добромысл	Зуева	\N	+7 913 605 05 72	2200 258230	неоконченное высшее	4657
Адам	Фомичева	\N	8 637 511 38 02	9175 759213	высшее	4658
Наум	Павлова	\N	+7 (056) 078-6530	7348 891941	среднее профессиональное	4659
Савелий	Потапова	Ефстафьевич	+7 371 181 0345	8889 832014	неоконченное высшее	4660
Каллистрат	Сергеева	Данилович	+72304628164	3198 769695	среднее	4661
Ипат	Устинов	Бенедиктович	+7 (611) 388-9785	4877 996679	неоконченное высшее	4662
Кирилл	Никитин	Елисеевич	+73134992787	1899 781510	неоконченное высшее	4663
Еремей	Горбунова	\N	8 092 669 23 93	9642 209586	среднее	4664
Галина	Ефремова	\N	+73677074040	1933 290480	среднее профессиональное	4665
Гурий	Белякова	Глебович	+70180364498	2846 228375	среднее профессиональное	4666
Захар	Николаев	\N	86729124925	8712 455143	среднее	4667
Исидор	Никонова	Богданович	+7 (678) 577-86-53	3459 202791	среднее профессиональное	4668
Модест	Исаков	Арсенович	8 903 176 91 38	1223 648385	\N	4669
Твердислав	Комиссаров	Ярославович	+7 904 899 9127	5910 582662	среднее профессиональное	4670
Всемил	Захарова	\N	+74527823915	1482 672807	среднее	4671
Гедеон	Якушев	\N	8 931 410 72 67	6917 782144	\N	4672
Глафира	Никонова	\N	+7 (230) 553-0818	7022 968128	неоконченное высшее	4673
Вадим	Быков	\N	+7 043 140 76 72	1843 467305	высшее	4674
Сократ	Савина	\N	+75743739796	3749 714840	среднее	4675
Анжелика	Голубев	\N	+7 633 799 1431	8384 122216	\N	4676
Лев	Шарапов	\N	+7 (693) 281-8418	3973 414844	неоконченное высшее	4677
Карл	Белоусов	\N	+7 (842) 925-10-20	9706 274574	неоконченное высшее	4678
Ия	Калинин	\N	8 (530) 145-76-00	2586 973916	высшее	4679
Амвросий	Козлов	\N	+7 059 138 30 82	7209 212795	среднее профессиональное	4680
Устин	Нестерова	\N	+7 (301) 165-65-85	1777 182845	среднее	4681
Лучезар	Никифоров	Дмитриевич	+7 (038) 939-84-36	4848 926624	среднее	4682
Фаина	Игнатьев	Андреевич	8 378 725 45 21	4716 124347	\N	4683
Станислав	Титов	\N	8 (046) 062-2887	7260 326088	\N	4684
Виктор	Макаров	Эдгарович	80283957670	6469 196790	высшее	4685
Пелагея	Морозова	Рубеновна	+7 781 001 05 52	2319 660394	среднее профессиональное	4686
Севастьян	Рябова	\N	+7 (541) 218-9882	1271 368142	высшее	4687
Гурий	Лихачева	\N	8 (498) 269-63-46	5183 435760	неоконченное высшее	4688
Изот	Воробьев	Богданович	8 709 092 1129	5889 250662	среднее	4689
Глафира	Филатова	Игнатьевич	+7 (300) 130-1967	1751 933528	высшее	4690
Гостомысл	Гуляева	\N	+7 412 647 3405	3875 659177	неоконченное высшее	4691
Парамон	Тарасова	\N	+7 316 275 2754	9026 510950	\N	4692
Савва	Гусева	\N	+7 (186) 431-53-57	2147 525771	неоконченное высшее	4693
Акулина	Казаков	Яковлевич	+7 686 710 06 09	6696 296427	среднее	4694
Ефрем	Рябов	Леонидовна	8 836 801 91 85	2720 136512	среднее	4695
Глафира	Пестов	\N	8 (051) 777-8820	6288 795232	неоконченное высшее	4696
Капитон	Большаков	\N	+7 495 097 60 80	9599 110939	среднее	4697
Клавдия	Никифорова	\N	+7 024 571 42 63	1081 574746	среднее	4698
Ярослав	Тимофеев	Валерьевич	+7 952 606 1026	8594 976086	высшее	4699
Захар	Кононов	Феодосьевич	8 281 506 60 93	9442 385009	неоконченное высшее	4700
Олимпий	Третьяков	\N	+7 905 925 4041	5225 134886	неоконченное высшее	4701
Галина	Гущина	Ануфриевич	+77439051972	8116 153315	\N	4702
Алина	Ситников	\N	+7 404 936 93 46	9107 114416	неоконченное высшее	4703
Бажен	Миронов	\N	+7 377 048 24 48	1489 258706	неоконченное высшее	4704
Тарас	Зуева	\N	+7 071 036 90 00	6248 871724	среднее	4705
Януарий	Никифоров	Петровна	+7 (500) 034-6649	8559 737231	неоконченное высшее	4706
Леонтий	Беляева	Марсович	+74042303740	7423 921793	среднее	4707
Олег	Осипов	Феликсович	8 349 221 4071	3436 501766	\N	4708
Элеонора	Кондратьева	\N	8 654 715 82 11	3510 737991	неоконченное высшее	4709
Анжела	Карпов	\N	+7 (022) 504-3757	8855 976468	среднее профессиональное	4710
Надежда	Мартынова	Авдеевич	+7 139 189 42 03	7879 428369	неоконченное высшее	4711
Аверьян	Коновалова	Юльевич	8 (540) 295-43-09	3877 629294	высшее	4712
Ермил	Лазарев	\N	+7 (272) 549-5663	4641 908741	\N	4713
Спиридон	Романов	Антоновна	85203591625	5391 934818	\N	4714
Измаил	Щукин	Григорьевич	8 (564) 610-5145	5449 311790	неоконченное высшее	4715
Христофор	Горбачева	Адамович	+7 389 118 27 46	3300 499756	среднее	4716
Никифор	Семенов	\N	8 926 107 50 03	8399 814468	неоконченное высшее	4717
Артем	Мамонтова	\N	8 821 271 7241	9923 353048	неоконченное высшее	4718
Мария	Комарова	Демидович	8 490 606 82 14	8034 293065	\N	4719
Константин	Фомин	Власович	+7 165 432 3380	5626 681449	среднее профессиональное	4720
Ферапонт	Григорьев	Филипповна	8 (293) 999-9063	4920 182389	неоконченное высшее	4721
Остромир	Ковалев	\N	+7 (650) 762-34-54	7334 602292	неоконченное высшее	4722
Ия	Максимова	Тарасович	8 904 849 2946	7540 835831	среднее профессиональное	4723
Панкрат	Анисимов	\N	+7 (542) 806-3793	8767 919612	среднее	4724
Ипполит	Овчинников	Тарасовна	8 (925) 767-54-03	3703 295277	\N	4725
Иван	Колесников	\N	+72727178478	1671 561238	среднее	4726
Ермил	Воронова	Чеславович	8 (328) 097-8377	6710 829423	\N	4727
Алевтина	Марков	Якубович	8 (727) 731-4349	6185 932145	высшее	4728
Никандр	Дроздова	Ефстафьевич	8 (727) 448-39-81	6028 400027	высшее	4729
Аркадий	Стрелкова	Михайловна	+7 (443) 999-66-14	1389 950738	\N	4730
Дмитрий	Елисеев	Герасимович	+7 (589) 585-9492	9224 741303	высшее	4731
Селиверст	Сафонов	Николаевна	8 (156) 311-2289	4654 554115	среднее	4732
Ия	Фокина	Юлианович	88521320783	4043 276897	неоконченное высшее	4733
Порфирий	Щукин	Алексеевич	88795452520	5431 251762	среднее профессиональное	4734
Селиверст	Сазонов	Измаилович	+7 124 736 57 09	4076 201667	неоконченное высшее	4735
Ян	Лихачева	\N	89078591613	9231 528037	среднее профессиональное	4736
Илья	Силина	\N	+7 (673) 332-81-95	6920 142658	\N	4737
Владлен	Кудряшов	\N	+7 (162) 361-9020	5030 574157	\N	4738
Элеонора	Соколова	Августович	8 (765) 494-41-76	3484 640905	высшее	4739
Михей	Шилова	\N	8 (615) 671-68-34	5403 485195	среднее профессиональное	4740
Ираида	Евдокимова	\N	+7 (898) 719-36-45	6605 199698	\N	4741
Юлий	Калинин	Георгиевна	8 569 005 3528	7334 634553	неоконченное высшее	4742
Елизавета	Суханова	Робертовна	+7 605 720 4397	6296 264899	среднее профессиональное	4743
Венедикт	Доронин	\N	8 (417) 555-7994	3651 975088	неоконченное высшее	4744
Виктор	Ковалева	Сергеевна	8 (841) 476-31-55	5290 190547	среднее	4745
Варлаам	Фомин	Витальевич	88440500646	2146 891639	\N	4746
Аникей	Капустина	Викторович	8 468 834 72 10	8729 521111	высшее	4747
Тит	Кулагин	\N	8 (564) 580-59-91	7956 637130	среднее	4748
Елена	Фадеева	Артемовна	8 (659) 029-22-13	4971 498170	неоконченное высшее	4749
Святослав	Лукин	Викторович	8 (103) 345-85-52	2310 729071	среднее профессиональное	4750
Терентий	Белозеров	Игоревна	87877155463	1810 669267	\N	4751
Наталья	Сафонов	Ярославович	86018212364	4072 654977	высшее	4752
Самуил	Мясникова	\N	8 (742) 135-7237	2392 469599	среднее	4753
Иван	Кулагина	Изотович	+7 (216) 759-72-59	5857 460410	высшее	4754
Адам	Исаков	Андреевич	+70933356505	8142 259440	\N	4755
Силантий	Маркова	\N	+7 (600) 408-10-01	4604 115908	среднее профессиональное	4756
Ипатий	Богданова	\N	+7 594 952 8469	8157 199469	среднее профессиональное	4757
Дмитрий	Носков	\N	+7 462 114 41 24	9307 359219	среднее	4758
Мартын	Чернов	\N	+75888678814	3999 698377	\N	4759
Юрий	Вишняков	Аксёнович	+7 (530) 299-68-99	4196 160566	высшее	4760
Корнил	Русакова	Валерианович	+7 822 709 8256	7382 542376	среднее	4761
Фрол	Русакова	Яковлевич	8 (371) 811-0114	8785 135649	среднее профессиональное	4762
Гурий	Симонов	Вячеславовна	8 (797) 215-90-44	2475 877417	неоконченное высшее	4763
Зосима	Игнатов	\N	+7 979 942 75 57	2884 719184	\N	4764
Алексей	Хохлова	\N	+7 (907) 487-02-03	7002 697183	\N	4765
Панфил	Кабанов	\N	8 311 468 2572	4805 136514	среднее профессиональное	4766
Вероника	Зимина	Макаровна	+75397666655	9298 110647	неоконченное высшее	4767
Герасим	Федосеева	Дмитриевич	82078700062	2692 619909	среднее	4768
Татьяна	Маслов	\N	8 (578) 984-9103	6598 297600	неоконченное высшее	4769
Клавдия	Гаврилова	\N	+7 351 198 78 89	1395 588184	\N	4770
Вышеслав	Абрамова	Ефимьевич	8 (123) 420-10-08	1470 137911	среднее профессиональное	4771
Маргарита	Киселев	\N	+7 189 149 2048	6103 877462	среднее профессиональное	4772
Тихон	Тихонов	Демидович	89538831533	5384 682496	среднее	4773
Чеслав	Анисимов	\N	8 (636) 509-7909	9873 404667	среднее профессиональное	4774
Орест	Шарапова	\N	8 831 459 25 48	3400 164427	\N	4775
Флорентин	Третьяков	Тихонович	8 (120) 723-8976	1020 238213	среднее профессиональное	4776
Автоном	Кулагина	Захарьевич	82297974574	2930 285980	среднее	4777
Фёкла	Емельянов	\N	+7 974 381 08 93	3688 995109	\N	4778
Клавдий	Носов	\N	+7 191 202 85 57	1491 329911	неоконченное высшее	4779
Болеслав	Зайцев	\N	86253279956	9008 767064	неоконченное высшее	4780
Павел	Колесникова	\N	8 (595) 314-01-63	2768 525663	среднее	4781
Аникита	Бобылев	\N	8 890 931 47 43	5746 539761	\N	7285
Никандр	Кудрявцева	Юльевич	+7 934 199 91 55	3554 677590	среднее профессиональное	4782
Спиридон	Морозова	Рубеновна	+78414713179	4382 637821	среднее	4783
Валерий	Кудряшов	Архипович	+79505647148	6995 895927	среднее	4784
Гедеон	Юдина	\N	8 (863) 967-67-23	5535 374694	\N	4785
Ипполит	Козлов	Алексеевна	8 246 307 72 35	3560 147658	среднее	4786
Семен	Голубев	\N	+7 (839) 763-0580	8806 123876	высшее	4787
Сила	Жданов	\N	+7 (580) 099-21-72	4178 675205	среднее профессиональное	4788
Творимир	Лукин	Харламович	81705731173	6425 445167	высшее	4789
Моисей	Сазонова	\N	+7 (616) 819-75-59	5382 959499	среднее	4790
Иннокентий	Гуляев	Тимуровна	8 (871) 318-9219	4751 713701	среднее	4791
Аверьян	Суворов	\N	8 (977) 772-9977	1985 671319	среднее	4792
Прокофий	Тарасова	Эльдаровна	8 (893) 090-49-17	4328 950115	высшее	4793
Евдокия	Дементьева	Теймуразович	+7 (614) 922-6573	3142 844870	среднее	4794
Илья	Мельников	\N	+7 168 211 5052	2467 268646	среднее профессиональное	4795
Лавр	Денисов	Ильич	+7 794 522 4572	7967 635125	среднее	4796
Андрей	Антонов	Эдуардович	8 (750) 922-3957	7929 744897	неоконченное высшее	4797
Фотий	Агафонов	Борисович	8 (420) 278-0052	6405 495445	среднее	4798
Дементий	Анисимова	Ильясович	+72952455453	4381 630114	высшее	4799
Севастьян	Павлова	\N	8 117 745 94 39	2037 930129	среднее	4800
Ипат	Сафонова	Васильевич	8 373 763 6596	3866 399463	высшее	4801
Елена	Ильина	Адамович	+76001628879	9654 535665	высшее	4802
Мариан	Соболев	\N	+7 213 738 7727	8554 429411	\N	4803
Аггей	Панов	\N	+7 (329) 462-7409	5839 709257	\N	4804
Тимур	Суворов	\N	8 (824) 036-0543	7327 983026	\N	4805
Карл	Емельянов	\N	8 402 038 63 69	2982 104330	среднее профессиональное	4806
Харитон	Носкова	Львовна	8 804 880 8568	1878 880259	среднее профессиональное	4807
Сигизмунд	Фомин	\N	+7 808 405 49 14	8610 869094	неоконченное высшее	4808
Мария	Казакова	Алексеевич	+7 (013) 998-8384	6012 379828	высшее	4809
Селиверст	Денисова	\N	8 (497) 439-8525	3861 711220	высшее	4810
Мокей	Филатова	\N	89330020783	3540 784432	неоконченное высшее	4811
Сильвестр	Власова	Руслановна	+77390916582	9126 404881	неоконченное высшее	4812
Парамон	Никитина	\N	+73690501126	8352 667158	\N	4813
Порфирий	Туров	Виленович	+7 271 298 65 73	5473 607429	среднее	4814
Рубен	Белозерова	\N	+7 (096) 211-27-37	5783 644171	среднее профессиональное	4815
Любосмысл	Шарапов	Давыдович	8 577 180 8038	7656 611506	среднее профессиональное	4816
Болеслав	Петров	\N	+78708053911	8518 720732	среднее	4817
Сила	Кудряшов	Адамович	8 (278) 709-24-09	5162 839495	неоконченное высшее	4818
Эмилия	Филатов	\N	8 531 907 2330	5088 698970	\N	4819
Якуб	Ильина	\N	+7 271 646 17 40	3340 911409	среднее	4820
Таисия	Веселова	Тимурович	8 (394) 545-6551	3201 892621	среднее	4821
Федор	Панов	Тарасовна	+7 029 995 16 33	4687 601677	высшее	4822
Трифон	Кириллова	\N	+70382267529	6584 811186	среднее профессиональное	4823
Куприян	Ситников	\N	+75633863179	1407 531259	среднее	4824
Агафон	Борисова	\N	+7 247 898 42 92	3400 224901	среднее профессиональное	4825
Виктор	Сергеев	Тарасовна	8 (613) 283-44-22	3379 444188	среднее профессиональное	4826
Марфа	Комаров	Феодосьевич	+7 (584) 970-83-76	1738 662569	среднее профессиональное	4827
Гаврила	Романова	Ефимовна	+76824383403	3371 145160	неоконченное высшее	4828
Олимпий	Белякова	\N	8 239 359 5346	1564 570162	\N	4829
Юлиан	Рябов	Эдгардович	+7 (707) 530-0990	3476 296588	среднее	4830
Харлампий	Семенов	Изотович	+73391011459	1230 391261	неоконченное высшее	4831
Федор	Шарапов	Ефимьевич	87310216165	3927 299300	неоконченное высшее	4832
Влас	Сазонова	Иосипович	+7 673 136 5667	5768 554165	среднее	4833
Глеб	Белякова	Романовна	+7 (995) 450-47-53	1725 201223	среднее	4834
Клавдий	Давыдова	\N	+7 544 341 2988	2133 295268	неоконченное высшее	4835
Радован	Филиппов	\N	8 979 544 03 35	8960 892952	среднее	4836
Никандр	Смирнова	Зиновьевич	+7 (891) 659-4097	8750 506689	среднее	4837
Бронислав	Григорьев	Афанасьевна	88520449401	1069 962001	\N	4838
Раиса	Субботина	Филатович	80289446070	5679 683558	среднее	4839
Степан	Комиссарова	\N	85798777854	3804 683864	неоконченное высшее	4840
Ия	Назарова	\N	+7 753 713 07 22	3622 149496	высшее	4841
Доброслав	Кулагина	\N	80957281408	9203 124079	среднее	4842
Борис	Журавлева	\N	+78484886926	4529 170247	среднее профессиональное	4843
Иннокентий	Кудрявцева	Филипповна	+75604004014	6808 693671	среднее	4844
Константин	Коновалов	\N	8 (851) 639-09-86	8559 439540	среднее профессиональное	4845
Кузьма	Галкина	\N	8 988 696 2172	7620 315701	среднее	4846
Гедеон	Чернов	Зиновьевич	+7 886 695 1300	2056 102992	\N	4847
Дементий	Соловьева	Архипович	+7 (708) 443-3474	5706 669803	среднее профессиональное	4848
Регина	Воронов	Евстигнеевич	+7 (877) 246-6022	6810 996369	среднее профессиональное	4849
Тимофей	Федосеев	\N	8 (655) 002-7367	2136 734818	среднее	4850
Олимпиада	Игнатова	Власович	+7 260 212 8610	9604 199786	среднее профессиональное	4851
Трофим	Константинова	\N	80552790388	7540 380595	высшее	4852
Николай	Щербаков	\N	+7 (283) 077-11-66	1588 895863	среднее профессиональное	4853
Агап	Потапов	\N	8 268 699 8625	7350 289220	\N	4854
Аполлон	Комаров	Эдуардович	8 (621) 472-4376	9215 270185	высшее	4855
Ермолай	Филатов	\N	86815034641	6832 483291	среднее профессиональное	4856
Зиновий	Кудрявцев	\N	8 (313) 938-03-55	8056 970412	неоконченное высшее	4857
Мстислав	Гуляева	Вячеславовна	+7 970 939 1850	8409 212500	высшее	4858
Николай	Миронов	Елисеевич	+7 415 828 4612	5308 853126	высшее	4859
Любомир	Мясникова	Алексеевна	+77089624109	2465 110424	среднее	4860
Глеб	Миронова	Мироновна	+7 (321) 893-2264	6274 138651	неоконченное высшее	4861
Филарет	Зыков	\N	+7 (238) 723-47-02	7092 111162	\N	4862
Никифор	Доронина	Глебович	+7 801 322 9776	6459 210569	неоконченное высшее	4863
Константин	Жуков	\N	+7 (692) 206-3192	3304 217993	высшее	4864
Майя	Гусев	Трофимович	8 857 733 91 37	7737 654630	неоконченное высшее	4865
Автоном	Шашкова	Юрьевна	8 115 558 22 70	8598 905955	среднее профессиональное	4866
Аверкий	Боброва	Харламович	+7 (903) 918-26-83	8273 320656	высшее	4867
Август	Николаев	\N	+7 175 385 60 75	4225 495582	неоконченное высшее	4868
Бажен	Ермаков	\N	8 887 368 97 26	6916 122865	среднее	4869
Илья	Мясникова	\N	+7 (702) 549-34-00	4236 126366	среднее	4870
Валентин	Игнатьева	\N	+7 628 546 7063	9068 135427	\N	4871
Назар	Костина	Георгиевич	+71884725157	2673 174156	высшее	4872
Адриан	Архипова	Брониславович	+7 (700) 468-14-72	8243 314625	среднее профессиональное	4873
Харлампий	Третьяков	\N	8 518 864 0179	5323 690329	среднее профессиональное	4874
Симон	Симонов	Леоновна	88361475686	1625 899481	среднее профессиональное	4875
Галактион	Гуляева	\N	+7 (210) 029-3440	1961 472450	неоконченное высшее	4876
Мокей	Селиверстова	\N	8 203 093 2297	5430 326218	\N	4877
Мартын	Громова	Ефимович	+7 344 013 58 99	6865 294679	среднее профессиональное	4878
Ирина	Киселев	Мироновна	8 (662) 896-8356	3730 156620	\N	4879
Бажен	Лебедев	\N	8 (248) 081-08-81	6391 942483	\N	4880
Нинель	Тарасов	Мироновна	+79923212569	4533 841545	неоконченное высшее	4881
Афиноген	Исаева	Михайловна	83429354096	9444 534075	высшее	4882
Евдокия	Белоусов	\N	8 343 203 7796	2567 605108	неоконченное высшее	4883
Казимир	Белякова	Макаровна	8 442 014 56 76	6775 569917	среднее	4884
Мефодий	Антонова	Мироновна	89071564982	7808 561835	\N	4885
Василий	Соколов	Тарасовна	8 143 463 9460	2157 976630	\N	4886
Родион	Лаврентьев	\N	+7 922 421 4951	8080 313071	\N	4887
Бажен	Гуляева	Степановна	8 (152) 122-36-41	6503 427205	высшее	4888
Наум	Костин	Феоктистович	+7 125 527 19 29	4232 846915	неоконченное высшее	4889
Тарас	Фомина	Ильинична	8 (250) 932-39-56	6507 141461	среднее	4890
Георгий	Сорокина	\N	83187628242	4499 207650	высшее	4891
Игорь	Зайцева	\N	+71648495895	5008 899790	неоконченное высшее	4892
Федор	Морозов	Мироновна	+7 (662) 962-52-77	2469 769779	среднее профессиональное	4893
Лидия	Лихачева	Леонидовна	82632717472	3155 446300	\N	4894
Феликс	Тихонова	\N	+7 118 349 50 94	3799 778545	среднее	4895
Юлий	Петров	\N	+7 195 780 80 98	8682 518707	среднее профессиональное	4896
Тамара	Комаров	Вячеславовна	8 202 227 98 22	2592 285377	\N	4897
Владислав	Кулакова	Венедиктович	8 (757) 860-99-48	6767 330018	среднее	4898
Ладислав	Казакова	\N	8 366 247 3553	8408 546541	\N	4899
Аристарх	Карпова	\N	+7 (950) 672-98-41	2857 512810	среднее профессиональное	4900
Олег	Гусева	Анатольевна	+7 130 790 01 72	3886 487769	среднее	4901
Федор	Иванов	Феодосьевич	+7 139 342 4479	5303 755917	среднее профессиональное	4902
Самуил	Зайцева	\N	+7 (214) 542-0776	2573 842989	\N	4903
Виктор	Хохлов	Георгиевич	88317608837	3852 850631	среднее профессиональное	4904
Венедикт	Фомин	\N	89052598095	5063 531575	среднее профессиональное	4905
Леон	Молчанов	\N	8 (357) 431-26-91	3992 721632	высшее	4906
Илья	Кузнецова	\N	+7 (844) 472-46-27	7308 968081	среднее профессиональное	4907
Виссарион	Горбунов	Арсеньевич	+7 (137) 270-5390	5280 648541	неоконченное высшее	4908
Никифор	Кириллова	\N	8 737 821 34 61	7762 258697	высшее	4909
Всемил	Афанасьев	\N	8 850 357 1476	5485 601050	\N	4910
Платон	Ситников	Артёмович	8 (668) 587-3394	4651 421508	среднее	4911
Моисей	Мамонтова	\N	8 (291) 906-94-56	4042 441639	среднее	4912
Модест	Воронова	\N	+7 (130) 171-89-65	7595 655679	среднее профессиональное	4913
Лонгин	Мишина	\N	8 191 836 99 86	8792 111730	\N	4914
Радован	Устинов	\N	+7 155 154 45 95	1891 205067	неоконченное высшее	4915
Гедеон	Петров	\N	+7 (765) 928-5411	3345 853354	среднее профессиональное	4916
Ермолай	Карпова	\N	8 (824) 341-8719	5430 428765	среднее	4917
Корнил	Щербакова	Харламович	+7 521 397 99 50	9026 979954	среднее профессиональное	4918
Зосима	Фокина	Геннадиевич	+7 (630) 763-3473	1778 964531	высшее	4919
Прасковья	Сорокина	\N	8 742 344 14 36	1664 515589	\N	4920
Ермил	Поляков	Аксёнович	8 (897) 914-11-90	6225 675587	высшее	4921
Василий	Стрелков	Ануфриевич	+73684156735	8580 390655	среднее	4922
Константин	Исаева	Антоновна	81714229724	5331 481067	\N	4923
Ратмир	Доронина	Аркадьевна	8 (187) 569-31-88	6677 693915	\N	4924
Измаил	Ширяева	Гордеевич	89898475133	4115 650794	среднее	4925
Любим	Афанасьева	\N	+7 (733) 495-86-57	4271 644816	среднее профессиональное	4926
Ладимир	Родионов	Болеславовна	8 (003) 717-3285	2741 357239	среднее профессиональное	4927
Владимир	Коновалова	\N	8 315 897 72 70	4306 822812	высшее	4928
Нестор	Муравьева	Харлампович	+7 352 792 5517	7417 224989	неоконченное высшее	4929
Агафон	Лукина	\N	8 579 604 90 15	4478 414015	среднее профессиональное	4930
Олег	Федоров	\N	8 141 339 77 94	6082 882591	среднее профессиональное	4931
Лука	Дементьева	\N	+7 (489) 494-9490	6917 914104	среднее профессиональное	4932
Харитон	Самсонова	\N	+7 (141) 143-3167	4717 367288	\N	4933
Тамара	Куликов	\N	8 980 277 66 06	6713 847311	\N	4934
Аскольд	Ефимов	\N	+7 (605) 129-83-51	1386 908031	неоконченное высшее	4935
Аникита	Антонов	\N	8 379 612 6236	2717 460809	среднее профессиональное	4936
Иосиф	Боброва	Филатович	+72124475708	5532 144446	\N	4937
Мирон	Попова	Гордеевич	86114859909	6710 536756	высшее	4938
Арефий	Харитонов	\N	+7 (901) 526-4837	7786 844113	высшее	4939
Милан	Фадеева	\N	+73556980940	2672 410066	неоконченное высшее	4940
Клавдия	Вишняков	Харлампович	+7 455 078 5158	5661 871592	неоконченное высшее	4941
Панфил	Котов	Зиновьевич	8 319 534 5682	7758 427396	неоконченное высшее	4942
Аверкий	Красильников	\N	+7 (107) 738-5796	2175 540938	\N	4943
Леонид	Федотов	Еремеевич	+7 678 638 6622	3291 431474	\N	4944
Дорофей	Ершова	Данилович	+7 (849) 671-0167	6107 624707	среднее	4945
Трифон	Яковлев	Святославовна	+7 (981) 628-4388	4942 235533	\N	4946
Наина	Васильева	Феодосьевич	+70461849170	2387 411132	неоконченное высшее	4947
Аполлон	Евсеев	\N	+7 (734) 249-65-32	5065 487976	среднее профессиональное	4948
Всемил	Голубев	Фокич	8 (774) 711-5220	4149 937365	\N	4949
Януарий	Меркушева	\N	8 (007) 380-2096	2667 996442	среднее	4950
Олимпиада	Калашникова	Анисимович	+76896486129	2851 771455	\N	4951
Мина	Брагина	\N	+7 (476) 429-1085	2060 110371	среднее	4952
Савелий	Михайлов	Андреевич	8 (390) 006-6054	5225 261347	среднее	4953
Стоян	Ширяева	Димитриевич	+7 020 358 5365	3685 801619	среднее профессиональное	4954
Кондрат	Давыдова	Артурович	+7 (756) 423-47-82	2382 752026	среднее	4955
Вероника	Лаврентьев	Филиппович	8 (372) 218-7286	5196 247220	неоконченное высшее	4956
Алина	Горбунова	Ерофеевич	8 (137) 583-2284	3915 656334	неоконченное высшее	4957
Анатолий	Савина	\N	+7 988 157 45 99	3202 996809	среднее профессиональное	4958
Любомир	Емельянова	Ануфриевич	+7 445 368 72 46	6397 978010	\N	4959
Юрий	Захарова	Харламович	+7 (220) 733-90-40	2741 482315	среднее профессиональное	4960
Михаил	Суханов	\N	+7 048 912 69 64	6419 540269	среднее	4961
Юлиан	Попова	\N	+7 (544) 402-58-07	9113 840507	среднее	4962
Януарий	Тихонова	\N	8 (029) 249-1649	7462 444706	среднее профессиональное	4963
Лаврентий	Богданов	Кирилловна	+73700478896	9446 317133	неоконченное высшее	4964
Любим	Горбунов	Теймуразович	82362499891	4355 197084	среднее	4965
Андрон	Шестаков	Яковлевич	+7 (584) 615-8780	6015 325942	высшее	4966
Серафим	Ершова	\N	+7 (086) 163-3897	8165 132112	среднее	4967
Наум	Сазонов	Чеславович	8 024 134 31 14	8518 459631	\N	4968
Любомир	Рябов	Захаровна	+7 (445) 720-50-26	5502 720882	высшее	4969
Макар	Назарова	\N	8 032 331 6391	7176 706493	неоконченное высшее	4970
Амвросий	Громов	\N	8 475 506 5889	8050 910522	среднее	4971
Савва	Субботина	\N	+7 (397) 078-1929	9355 867632	среднее профессиональное	4972
Всеволод	Юдина	Юльевна	+7 046 620 3924	6087 907520	неоконченное высшее	4973
Варлаам	Богданова	\N	+75839034696	5359 341594	среднее профессиональное	4974
Раиса	Макарова	\N	8 084 416 3220	1915 933745	\N	4975
Твердислав	Евсеев	Эдгарович	+78738125886	6028 327308	среднее	4976
Викентий	Коновалова	Владиславовна	+7 235 491 0950	3685 944422	\N	4977
Селиван	Шарова	\N	+7 (077) 413-4894	9918 119639	неоконченное высшее	4978
Станимир	Артемьев	Дмитриевна	+76986039756	2981 715069	среднее профессиональное	4979
Евсей	Евдокимова	Дмитриевич	8 815 664 7813	8777 886765	среднее	4980
Лучезар	Костина	Фомич	+74960862086	2943 377490	неоконченное высшее	4981
Аверьян	Матвеева	\N	+7 987 265 14 61	1390 916112	среднее	4982
Наталья	Владимиров	\N	8 156 632 2393	3631 886277	среднее профессиональное	4983
Трифон	Яковлева	Иосифович	83226513431	6915 745941	неоконченное высшее	4984
Феврония	Авдеев	Александрович	8 (824) 024-96-86	5615 613875	среднее профессиональное	4985
Боян	Савина	Димитриевич	8 344 340 81 17	1772 294385	неоконченное высшее	4986
Никандр	Шарапова	Абрамович	+7 885 041 5859	6088 211952	неоконченное высшее	4987
Сильвестр	Гордеев	\N	+76833501055	6386 869345	среднее	4988
Виктор	Самсонов	Елизарович	+7 (256) 790-5329	7989 150713	среднее	4989
Георгий	Князев	Андреевна	+78519134583	9141 589473	среднее профессиональное	4990
Тимофей	Комиссаров	Чеславович	+7 (147) 897-95-33	7500 870189	среднее	4991
Елена	Матвеева	\N	8 148 828 12 20	5506 116148	среднее	4992
Гаврила	Орехова	Захарьевич	+72251528982	1963 986871	высшее	4993
Фадей	Устинов	\N	+79686845281	6290 198810	среднее	4994
Исидор	Сысоев	Харитоновна	85475436613	8985 990643	среднее	4995
Зиновий	Горбачева	Артёмович	+72567277322	1313 660151	\N	4996
Будимир	Большаков	Валериевна	8 (517) 130-24-86	7753 741050	неоконченное высшее	4997
Ангелина	Богданова	Авдеевич	+77255152665	2649 144306	среднее	4998
Куприян	Ситникова	Жанович	+7 636 877 33 84	7510 721594	среднее профессиональное	4999
Антонин	Носова	Мироновна	+72924219212	6181 214187	высшее	5000
Елена	Субботина	\N	+7 (669) 890-3722	5216 382957	\N	5001
Демид	Филиппов	\N	+7 (447) 752-3009	4759 584204	среднее профессиональное	5002
Нина	Ефремова	Филимонович	+7 (793) 327-4903	4097 951109	среднее профессиональное	5003
Ферапонт	Ширяев	\N	8 (415) 715-9655	1574 515489	среднее профессиональное	5004
Иосиф	Устинова	Владиславович	+7 483 371 8890	3488 711281	неоконченное высшее	5005
Аверьян	Комарова	\N	+7 090 105 0613	2702 279007	среднее	5006
Ираклий	Харитонов	\N	+7 122 635 7208	2054 371240	среднее профессиональное	5007
Добромысл	Гаврилова	Руслановна	8 839 551 52 22	8074 892807	неоконченное высшее	5008
Ким	Савельева	Оскаровна	8 940 548 3044	6585 654228	среднее	5009
Парамон	Гришина	\N	8 094 554 4414	9223 503962	высшее	5010
Сильвестр	Буров	Юлианович	+7 774 195 7988	4184 943443	среднее профессиональное	5011
Климент	Павлов	\N	8 (490) 409-76-64	6654 901427	среднее	5012
Аристарх	Никифорова	\N	8 (614) 502-4847	6827 458215	высшее	5013
Гордей	Шашков	Владиславович	8 (079) 350-8630	9843 986659	\N	5014
Мина	Молчанов	\N	+70328552386	7276 715920	\N	5015
Денис	Сафонова	Юлианович	89060860272	6242 788135	высшее	5016
Август	Константинова	Андреевна	+7 895 232 21 59	4980 895739	неоконченное высшее	5017
Андрей	Медведев	\N	+7 356 920 3507	2412 985527	среднее профессиональное	5018
Филипп	Сергеева	\N	8 (590) 939-96-73	7424 158860	неоконченное высшее	5019
Евлампий	Козлова	\N	+75655952944	5572 355321	среднее	5020
Аскольд	Большаков	\N	+74485966956	1740 232404	среднее	5021
Касьян	Костин	\N	8 665 759 10 19	6445 937697	среднее	5022
Любим	Лобанов	\N	+76852874219	4333 884579	неоконченное высшее	5023
Ярослав	Князева	\N	+7 (213) 713-4612	8628 189433	неоконченное высшее	5024
Самуил	Кондратьев	Афанасьевна	82469998878	3634 293900	\N	5025
Федот	Белоусов	\N	8 723 312 96 97	7453 616156	среднее	5026
Елена	Рогова	\N	8 638 421 3067	7301 304448	неоконченное высшее	5027
Доброслав	Кулагина	Давыдович	+7 (258) 069-49-81	5506 362759	высшее	5028
Олег	Давыдов	Абрамович	82634395246	7132 904496	\N	5029
Евдоким	Турова	\N	80843870384	8206 204574	высшее	5030
Исидор	Воробьев	\N	8 (392) 886-0171	8220 383388	высшее	5031
Зинаида	Фомичева	\N	+7 (479) 626-4389	5896 333656	\N	5032
Полина	Зыкова	\N	84557513670	1706 456661	неоконченное высшее	5033
Екатерина	Маслова	Максимовна	+7 (270) 730-58-28	5774 444465	среднее	5034
Нина	Котов	Ильич	8 (759) 745-3093	2826 330027	среднее	5035
Денис	Моисеев	Анатольевна	8 (097) 392-7586	4979 498825	\N	5036
Афанасий	Горшков	Тимофеевна	8 658 625 42 09	9676 816162	\N	5037
Вера	Зиновьева	\N	8 471 286 5733	5656 273189	среднее	5038
Виталий	Кириллова	Тихонович	+7 (847) 176-3889	3690 880540	высшее	5039
Алла	Гурьев	Феофанович	+7 176 841 4231	5359 372951	высшее	5040
Всеволод	Владимиров	\N	+7 (668) 385-2340	3595 775991	среднее профессиональное	5041
Вячеслав	Куликов	\N	+7 (215) 950-2453	2335 258281	неоконченное высшее	5042
Мечислав	Авдеева	\N	+7 (439) 745-44-03	4413 922207	среднее профессиональное	5043
Ксения	Бобров	Степановна	8 057 825 3405	4242 719530	\N	5044
Нонна	Громов	\N	8 981 467 38 06	5826 187651	среднее профессиональное	5045
Лазарь	Виноградова	Евстигнеевич	+7 273 034 9164	7139 269513	неоконченное высшее	5046
Фаина	Мартынов	Матвеевна	88734386180	7980 171437	неоконченное высшее	5047
Владимир	Щербакова	Артемьевич	+7 070 557 0742	5863 988389	неоконченное высшее	5048
Нифонт	Дементьева	\N	+7 636 456 42 40	8916 550946	среднее	5049
Иосиф	Колобов	\N	+7 191 273 3117	1361 187237	неоконченное высшее	5050
Матвей	Копылова	Анатольевна	+74387148195	2219 991026	среднее профессиональное	5051
Арефий	Фомин	Сергеевна	8 180 744 66 30	8537 292756	среднее	5052
Чеслав	Кудрявцев	\N	+76945109281	4414 985451	\N	5053
Евгений	Воронцова	\N	+72366147255	3401 399983	среднее	5054
Ираида	Поляков	Ермилович	8 (696) 330-88-91	9731 454395	\N	5055
Регина	Ковалева	\N	82334911878	1772 249519	неоконченное высшее	5056
Иларион	Сорокин	\N	+76717868109	7557 863019	\N	5057
Адриан	Дьячкова	Елисеевич	8 (026) 812-68-57	6702 360891	\N	5058
Ангелина	Кузнецов	\N	8 (915) 903-7745	1788 779090	среднее профессиональное	5059
Куприян	Осипова	\N	8 (313) 631-6243	2929 218831	\N	5060
Виталий	Исакова	Адрианович	8 (703) 749-9733	5566 804622	\N	5061
Арсений	Шарапова	\N	8 598 947 3392	2463 564594	среднее	5062
Зоя	Рогова	Ануфриевич	8 (095) 305-9174	2703 825310	высшее	5063
Селиван	Блохина	\N	80083673506	9375 729504	высшее	5064
Вышеслав	Попов	Елизарович	8 (297) 233-0708	5556 870137	\N	5065
Варфоломей	Соловьев	Тимуровна	8 (963) 442-3777	9539 459904	неоконченное высшее	5066
Евлампий	Цветкова	\N	+7 (624) 715-71-69	6888 452494	среднее	5067
Зоя	Зайцев	Захаровна	8 (173) 330-2562	5762 394488	неоконченное высшее	5068
Владислав	Дементьев	\N	+7 397 968 85 03	2073 921366	среднее профессиональное	5069
Захар	Осипов	\N	+7 028 516 3473	6209 614933	высшее	5070
Остромир	Абрамов	Евсеевич	+7 979 316 1081	5104 564728	высшее	5071
Валерия	Никонова	Алексеевич	+7 270 400 9424	4116 296985	среднее профессиональное	5072
Ангелина	Зуев	\N	80635143653	8468 721808	\N	5073
Ладислав	Евдокимова	\N	8 (264) 213-5010	3191 662464	высшее	5074
Никита	Кудрявцев	\N	+7 481 089 60 83	3159 470472	неоконченное высшее	5075
Панкрат	Галкина	\N	+7 315 289 5422	5663 284445	среднее	5076
Ферапонт	Титова	Григорьевич	+7 (404) 367-7496	7351 984506	неоконченное высшее	5077
Любосмысл	Тимофеев	\N	+78709500503	5699 656030	\N	5078
Август	Иванов	Афанасьевич	8 495 153 8658	8980 365768	неоконченное высшее	5079
Александра	Меркушева	\N	8 (209) 368-19-18	7154 711913	неоконченное высшее	5080
Якуб	Терентьева	Авдеевич	8 (507) 502-2366	8982 297248	среднее профессиональное	5081
Анна	Савина	\N	8 (659) 490-21-17	4841 533462	среднее	5082
Юрий	Копылова	Матвеевна	8 827 883 4614	1235 835881	среднее профессиональное	5083
Максимильян	Беляева	\N	+7 548 571 3291	6433 195403	высшее	5084
Панкрат	Быков	Анисимович	8 546 931 67 00	2187 417011	среднее профессиональное	5085
Людмила	Лихачев	\N	+7 (126) 768-5072	9124 908836	\N	5086
Андрей	Овчинников	Ярославович	8 (557) 427-9581	4900 782644	неоконченное высшее	5087
Матвей	Аксенов	\N	8 (256) 915-22-37	6994 582050	\N	5088
Андрон	Русаков	\N	88792989608	8265 252093	высшее	5089
Клавдий	Молчанова	Ануфриевич	8 (761) 914-46-13	4792 332153	среднее	5090
Ирина	Калинина	\N	8 (108) 786-4800	2190 536558	\N	5091
Наум	Одинцова	\N	8 638 779 8646	3207 709388	\N	8092
Агап	Исакова	\N	8 (412) 483-64-65	7441 367512	среднее профессиональное	5092
Виссарион	Дроздова	\N	8 (366) 249-39-18	4715 539974	среднее	5093
Твердислав	Ефремов	\N	+75627961098	1744 560322	среднее профессиональное	5094
Доброслав	Тетерин	\N	8 859 562 59 83	3448 477219	\N	5095
Зинаида	Ершова	\N	8 (565) 289-7586	7684 541580	высшее	5096
Василий	Евсеева	Филатович	+7 (166) 101-2674	4155 581374	среднее	5097
Трофим	Борисов	\N	+79330768687	7796 998028	неоконченное высшее	5098
Эрнст	Зимин	Романовна	8 (889) 290-44-07	2567 120314	неоконченное высшее	5099
Харитон	Копылов	\N	+7 860 621 3907	9334 712803	среднее профессиональное	5100
Агафья	Ефремова	\N	+7 083 257 7239	3716 237750	неоконченное высшее	5101
Радован	Пономарев	Геннадиевна	+7 794 809 00 58	1959 631623	среднее профессиональное	5102
Александр	Зыкова	\N	8 773 261 6568	3947 442679	высшее	5103
Гордей	Емельянова	\N	8 212 360 10 15	7388 615821	неоконченное высшее	5104
Самсон	Жданова	\N	+73278961247	1868 292650	\N	5105
Станимир	Волков	\N	8 (372) 733-7569	7442 422153	высшее	5106
Игнатий	Русаков	Трофимович	+7 (980) 163-82-94	6870 165425	неоконченное высшее	5107
Аркадий	Сафонова	\N	+7 810 854 51 68	4176 676757	неоконченное высшее	5108
Милий	Ермакова	\N	8 763 122 5054	9127 890224	неоконченное высшее	5109
Ольга	Соловьев	Кузьминична	+7 (195) 030-3265	2062 885706	среднее профессиональное	5110
Мирон	Зыков	\N	+7 (879) 980-2436	2212 755910	\N	5111
Агафья	Павлов	\N	+7 (003) 849-34-72	2814 215039	неоконченное высшее	5112
Лариса	Алексеев	Бориславович	+7 (955) 584-4655	8931 175738	среднее	5113
Фока	Потапов	\N	8 (446) 556-0518	5213 821919	неоконченное высшее	5114
Ульян	Соловьева	\N	8 036 241 83 53	9960 743628	\N	5115
Селиверст	Гордеев	Давыдович	8 396 162 1704	9391 224060	среднее	5116
Варлаам	Кабанов	\N	+76585839415	9319 947839	\N	5117
Ладимир	Трофимова	\N	8 144 323 99 49	6483 795820	неоконченное высшее	5118
Виктор	Киселева	\N	86708384594	2549 749123	среднее	5119
Синклитикия	Прохорова	Устинович	+7 (169) 680-02-42	6989 203658	среднее	5120
Марина	Дорофеев	Харлампьевич	+7 (130) 858-18-29	8258 501978	среднее профессиональное	5121
Анастасия	Киселев	Степановна	+73739199894	6256 337294	среднее	5122
Валентина	Назарова	\N	+7 256 705 2265	3092 359059	высшее	5123
Ермолай	Васильев	Андреевич	88645381765	2416 729920	неоконченное высшее	5124
Евгений	Колесникова	Антонович	+7 208 795 39 73	2130 338933	высшее	5125
Евдоким	Лазарев	Егоровна	8 759 485 14 46	5477 860925	\N	5126
Семен	Афанасьев	\N	85072748176	3446 609470	среднее профессиональное	5127
Нинель	Миронов	Альбертовна	8 579 805 4480	4819 222131	среднее	5128
Гурий	Коновалова	Антоновна	+7 516 930 11 78	7203 134272	высшее	5129
Евдоким	Сысоев	Фокич	+72267029923	3536 321000	высшее	5130
Рюрик	Князева	Ефимьевич	+7 772 495 31 50	6210 230160	неоконченное высшее	5131
Наина	Морозова	Бенедиктович	8 (403) 876-0919	9718 742363	среднее	5132
Роман	Суворова	\N	+7 103 258 0832	6324 390737	среднее	5133
Акулина	Зиновьева	Артемьевич	8 (142) 901-90-26	4125 387913	среднее	5134
Лора	Лобанова	Степановна	+7 922 178 70 62	5908 911611	неоконченное высшее	5135
Никита	Егорова	Ефремович	+74996093791	4247 676918	среднее	5136
Леон	Лукин	\N	+79428370158	8276 400572	высшее	5137
Федор	Моисеева	\N	+77843018843	9408 229388	среднее	5138
Мир	Колесников	\N	8 913 316 53 99	6273 898744	высшее	5139
Добромысл	Моисеев	Эдуардович	+7 (366) 057-3359	3093 248074	неоконченное высшее	5140
Гедеон	Васильев	Антипович	+7 281 837 46 27	3045 317364	\N	5141
Капитон	Рябов	Анатольевич	8 585 271 1192	5084 200727	среднее	5142
Фома	Фокин	\N	8 922 224 07 89	4250 462828	среднее профессиональное	5143
Якуб	Исаков	\N	8 001 192 72 92	8726 329826	среднее	5144
Никодим	Макаров	Тихонович	8 892 047 2880	2338 932227	неоконченное высшее	5145
Евлампий	Третьякова	Фокич	+7 239 472 1216	2798 366021	\N	5146
Андрон	Рогов	Артемьевич	+7 405 067 2782	7154 509166	\N	5147
Владислав	Щербаков	\N	86319098465	7837 711925	высшее	5148
Милий	Бирюков	Федосьевич	8 020 726 01 77	3642 253419	среднее профессиональное	5149
Илья	Голубев	Святославовна	8 920 753 0175	9909 984850	неоконченное высшее	5150
Аггей	Кулакова	\N	8 117 791 7683	2500 880402	среднее профессиональное	5151
Ерофей	Артемьев	\N	8 (515) 379-22-43	7565 937200	среднее	5152
Руслан	Ларионова	\N	8 784 949 17 53	7566 563728	среднее	5153
Моисей	Фокина	\N	8 (251) 454-55-34	8605 786993	высшее	5154
Никандр	Медведева	\N	+7 434 086 08 73	6971 615706	среднее	5155
Ратмир	Попова	Арсеньевич	8 156 754 72 83	7792 115168	неоконченное высшее	5156
Всеслав	Елисеева	Семеновна	+7 679 003 4764	9591 710598	высшее	5157
Галактион	Герасимова	\N	8 (799) 624-29-55	9311 182774	среднее	5158
Аполлинарий	Самсонова	\N	89024224179	1137 191011	неоконченное высшее	5159
Пахом	Исаков	\N	+70145387968	9221 859672	высшее	5160
Фотий	Красильников	\N	+7 (837) 910-12-72	5534 718689	неоконченное высшее	5161
Август	Федотов	Еремеевич	+79164048028	4587 623772	среднее профессиональное	5162
Николай	Матвеева	Валериевна	+7 405 471 80 97	7139 356011	высшее	5163
Якуб	Гаврилова	Юлианович	8 369 966 4063	7004 568175	высшее	5164
Олимпий	Фролов	\N	+74566775209	6238 620803	среднее профессиональное	5165
Мокей	Кузнецов	\N	8 258 958 12 58	8039 128455	высшее	5166
Валерий	Евсеев	\N	+7 615 228 92 69	1503 823297	неоконченное высшее	5167
Святослав	Архипова	\N	8 082 993 91 75	2943 905794	среднее	5168
Евлампий	Кириллова	Игоревич	+7 398 899 17 24	2865 727318	\N	5169
Изяслав	Доронин	\N	86547430986	5122 192993	высшее	5170
Василий	Меркушев	\N	8 (143) 356-10-49	9996 450706	среднее	5171
Илья	Колесникова	\N	+74173436073	3967 835466	\N	5172
Милен	Большаков	\N	8 724 355 2293	8472 593126	неоконченное высшее	5173
Прасковья	Морозова	Валерьевич	+72782793430	2078 661093	неоконченное высшее	5174
Тамара	Калинина	\N	8 (605) 848-5781	7041 633549	неоконченное высшее	5175
Никон	Самсонова	Еремеевич	8 138 256 37 19	7083 496141	высшее	5176
Галина	Рогова	\N	8 244 417 7345	8976 728310	среднее профессиональное	5177
Нинель	Владимирова	Всеволодович	+7 763 843 3318	9620 933665	неоконченное высшее	5178
Андрей	Семенова	\N	+7 069 617 55 32	2646 648897	высшее	5179
Климент	Лобанова	Афанасьевна	8 (936) 142-70-30	8397 588998	высшее	5180
Александра	Пономарев	Дорофеевич	85300516012	8508 640650	\N	5181
Ольга	Савин	\N	+7 004 414 80 40	2793 738406	среднее	5182
Никодим	Ларионова	\N	+7 (096) 024-67-03	1762 135614	высшее	5183
Соломон	Виноградов	\N	+7 (107) 227-7808	4192 884049	среднее профессиональное	5184
Дмитрий	Алексеева	Венедиктович	8 (222) 964-2561	9649 935545	\N	5185
Евстафий	Полякова	Ефстафьевич	8 555 697 2702	8547 510910	\N	5186
Софрон	Фролов	\N	+7 (561) 983-2978	8885 669783	неоконченное высшее	5187
Иннокентий	Котова	\N	+7 (050) 335-5491	9580 768805	среднее профессиональное	5188
Севастьян	Большакова	\N	+72731568767	2116 960554	\N	5189
Татьяна	Ситников	\N	+7 (677) 940-17-71	2730 123663	среднее профессиональное	5190
Арефий	Селезнев	Афанасьевич	8 (840) 986-55-05	6894 168827	среднее профессиональное	5191
Софон	Кудрявцев	\N	8 663 841 1038	2956 933933	неоконченное высшее	5192
Борислав	Никитина	\N	+7 (509) 518-6034	4640 938820	высшее	5193
Кира	Копылова	Эдуардовна	+7 479 635 0613	3774 233238	\N	5194
Виссарион	Савин	\N	+7 (287) 478-88-94	3545 640354	среднее	5195
Матвей	Щукин	Данилович	+75627394569	5545 935651	среднее	5196
Клавдий	Ларионов	\N	85380659562	4746 892992	среднее профессиональное	5197
Валентин	Сысоев	\N	8 (640) 711-9080	3729 195179	среднее	5198
Фаина	Сорокин	Захарьевич	+7 (253) 954-33-08	6756 747833	неоконченное высшее	5199
Жанна	Павлов	Владиленович	+74766057310	7213 101690	высшее	5200
Модест	Королев	\N	8 949 754 25 26	6761 460713	\N	5201
Ульян	Котова	\N	+7 (150) 625-4944	7728 326318	среднее профессиональное	5202
Пахом	Гурьев	Феликсович	+7 657 140 4535	7406 856017	высшее	5203
Нонна	Рогова	Фомич	+7 (595) 250-9019	5793 134460	\N	5204
Валерий	Русакова	\N	8 (085) 707-6895	2149 975869	высшее	5205
Зинаида	Матвеев	Эльдаровна	8 328 169 8440	4344 822906	\N	5206
Эраст	Романов	Филиппович	8 (121) 409-5037	7940 503420	высшее	5207
Орест	Степанов	Антипович	86224127628	9228 645187	высшее	5208
Герасим	Исаев	\N	+7 062 795 49 61	3328 945331	высшее	5209
Милица	Козлов	Виленович	+7 723 712 0232	8003 116860	среднее	5210
Арефий	Сергеев	\N	+7 334 629 2607	6000 922383	среднее профессиональное	5211
Глафира	Мишина	Робертовна	8 556 805 41 42	2410 807657	среднее	5212
Ипполит	Шубина	Антоновна	8 993 341 30 96	7799 284738	среднее профессиональное	5213
Аким	Матвеева	\N	8 (116) 226-04-29	4207 648449	\N	5214
Герман	Анисимова	Леонидовна	8 418 100 7133	3198 961382	высшее	5215
Орест	Бирюков	Богданович	8 (506) 763-9499	2870 139257	высшее	5216
Федор	Котов	\N	+7 202 951 5221	4492 258808	\N	8093
Алексей	Зыков	\N	8 545 889 47 09	4115 155263	неоконченное высшее	5217
Леон	Михайлова	Альбертовна	+71019086188	5864 446183	\N	5218
Тимофей	Трофимова	Антонович	+7 640 429 01 66	7447 246969	среднее профессиональное	5219
Мина	Владимиров	\N	8 (026) 532-32-06	6058 529276	\N	5220
Тихон	Аксенова	\N	8 451 116 7348	6175 673482	среднее	5221
Демид	Денисов	\N	+71697033796	5553 853400	среднее профессиональное	5222
Остап	Евсеева	\N	8 (363) 710-0656	5551 961508	высшее	5223
Фортунат	Гришина	Ефстафьевич	+71008392927	1357 997041	высшее	5224
Никита	Беляев	Матвеевна	+7 491 174 2588	2629 741693	среднее профессиональное	5225
Евграф	Галкин	Арсенович	+7 (405) 954-91-81	1902 971603	\N	5226
Артемий	Титов	\N	8 (202) 171-04-98	3977 915460	неоконченное высшее	5227
Нонна	Калашникова	Львовна	+7 023 685 9642	4605 731156	\N	5228
Аполлинарий	Дмитриева	\N	8 414 159 6200	3516 322410	высшее	5229
Зинаида	Наумова	Михайловна	8 (971) 467-87-48	6166 516677	неоконченное высшее	5230
Зиновий	Пестов	Владиславович	+7 626 009 7436	9723 853785	среднее профессиональное	5231
Харитон	Туров	Геннадиевна	8 (615) 336-4851	4861 808784	среднее профессиональное	5232
Карл	Анисимов	\N	8 (888) 338-20-99	8712 971527	неоконченное высшее	5233
Наталья	Соловьева	\N	+7 (664) 147-8337	5444 586412	неоконченное высшее	5234
Мария	Панфилов	Даниловна	+7 (468) 998-2686	7533 452321	неоконченное высшее	5235
Федот	Савина	\N	+70826485805	3763 296748	\N	5236
Никодим	Бобров	\N	8 (901) 875-2396	5685 156627	\N	5237
Софрон	Крылова	\N	82897868977	1497 855696	среднее	5238
Анастасия	Петухов	\N	8 261 358 3677	7653 459578	среднее	5239
Севастьян	Мамонтова	Артурович	+7 (150) 938-9545	8404 934612	среднее профессиональное	5240
Иларион	Бирюкова	Федотович	+7 785 706 10 20	1770 877632	среднее профессиональное	5241
Феоктист	Федоров	Федосеевич	+7 847 823 0480	1030 657055	среднее профессиональное	5242
Вышеслав	Блохин	\N	8 (540) 358-51-44	5693 710872	\N	5243
Пахом	Устинов	Ефстафьевич	8 (851) 020-8464	6502 271479	среднее профессиональное	5244
Анастасия	Рогова	\N	8 (378) 728-8028	9937 533861	среднее профессиональное	5245
Ладимир	Белова	\N	+7 (570) 281-3343	6947 359420	\N	5246
Синклитикия	Пахомов	\N	83919588002	9950 868329	высшее	5247
Эрнест	Котова	\N	+7 (166) 950-2003	1627 643248	среднее	5248
Мефодий	Мамонтов	Федоровна	+7 (121) 329-8503	3997 295357	\N	5249
Родион	Панов	Власович	8 (728) 547-40-12	9327 864837	среднее	5250
Олимпий	Яковлева	Фёдорович	8 884 634 89 26	4630 671839	высшее	5251
Митофан	Павлова	Эльдаровна	+7 856 616 5663	8690 109307	высшее	5252
Милан	Никонов	Васильевна	8 826 524 52 28	4348 514922	неоконченное высшее	5253
Лукия	Воронов	\N	8 (397) 717-1160	5579 560646	среднее профессиональное	5254
Конон	Суворов	Владиленович	+7 475 088 6707	2440 345324	среднее профессиональное	5255
Лидия	Куликов	Тарасовна	88656453813	8070 821353	высшее	5256
Богдан	Ларионов	\N	+7 (581) 315-3643	9746 550152	среднее профессиональное	5257
Лучезар	Комиссаров	Владиславович	8 (756) 964-30-97	3688 332836	среднее	5258
Ананий	Симонова	\N	8 732 087 04 72	9156 218884	среднее профессиональное	5259
Вадим	Савина	\N	8 693 892 32 61	3269 146250	среднее профессиональное	5260
Ярослав	Трофимов	Глебович	85232845265	5501 911836	среднее профессиональное	5261
Лука	Цветкова	\N	8 390 588 8419	1788 221309	среднее	5262
Афиноген	Прохоров	Юльевна	85509899219	1902 953762	среднее	5263
Валерий	Суворова	\N	8 (998) 107-47-16	1468 646518	неоконченное высшее	5264
Панкрат	Афанасьев	Адамович	+72736490399	5003 569607	среднее профессиональное	5265
Маргарита	Борисова	\N	+7 870 657 4482	4314 491048	среднее	5266
Онуфрий	Горбачев	\N	+7 064 101 33 06	3941 746287	среднее профессиональное	5267
Марина	Абрамов	\N	+70413841249	8438 459252	\N	5268
Алина	Крюкова	\N	+7 (251) 431-74-59	6502 151565	среднее	5269
Бажен	Лебедев	\N	+7 840 018 05 56	8414 395550	\N	5270
Изот	Воробьев	\N	+7 496 212 1712	2232 769771	неоконченное высшее	5271
Фрол	Федосеева	Владимировна	+77696310002	6031 224988	высшее	5272
Афанасий	Шаров	\N	+7 022 165 9646	1337 179276	высшее	5273
Азарий	Иванова	Демьянович	8 (625) 895-3904	7378 780905	высшее	5274
Семен	Коновалова	Робертовна	8 (005) 133-47-85	3765 966690	среднее профессиональное	5275
Георгий	Лапина	\N	8 344 204 40 32	4656 921043	высшее	5276
Марфа	Николаев	Филиппович	+7 (394) 754-5335	2887 527259	\N	5277
Карп	Михайлова	Павловна	+70123158127	8158 480802	высшее	5278
Михаил	Беляев	\N	+74443177118	7737 527476	неоконченное высшее	5279
Клавдий	Горбунова	\N	84298366410	1576 871254	среднее	5280
Константин	Волкова	\N	+7 238 969 4648	8390 870499	высшее	5281
Всемил	Тимофеев	Ефимовна	8 (764) 594-9740	5044 512013	высшее	5282
Мартьян	Герасимов	Феликсович	8 858 965 53 49	5861 295942	высшее	5283
Иосиф	Куликов	\N	8 (217) 736-9787	4678 944865	неоконченное высшее	5284
Трофим	Воронов	Андреевна	8 771 169 87 44	2490 401480	\N	5285
Стоян	Егорова	Жанович	8 962 824 45 45	4009 866290	неоконченное высшее	5286
Эмилия	Абрамов	Жоресович	+7 (266) 383-14-85	9817 136265	неоконченное высшее	5287
Эмиль	Павлова	Марсович	8 (681) 381-5317	9995 542127	среднее	5288
Модест	Белов	Гаврилович	+75932669592	3728 246964	среднее профессиональное	5289
Терентий	Моисеева	\N	85596860742	9134 447598	среднее профессиональное	5290
Людмила	Исаев	\N	8 (003) 622-4473	5925 757623	неоконченное высшее	5291
Каллистрат	Соколов	Марсович	89136198678	5600 215970	\N	5292
Болеслав	Королева	Богдановна	8 (472) 412-0258	9673 104259	среднее профессиональное	5293
Аполлон	Одинцов	Альбертовна	+7 (070) 362-8611	3434 325936	\N	5294
Владимир	Жукова	Георгиевич	8 (418) 957-0591	8052 188106	среднее	5295
Арсений	Герасимова	\N	+7 475 176 85 22	5941 723264	\N	5296
Аристарх	Стрелкова	Харлампович	8 963 695 48 93	6940 227248	высшее	5297
Изот	Андреева	\N	+7 (113) 717-06-79	4038 766941	высшее	5298
Рюрик	Андреева	Тимурович	8 223 679 33 35	1128 303683	среднее	5299
Пахом	Зыков	Харитоновна	8 908 675 4049	6588 532339	\N	5300
Тихон	Фомина	Игнатович	+7 (050) 865-87-69	8834 779434	высшее	5301
Прохор	Быкова	\N	8 (140) 615-68-57	3047 705870	\N	5302
Ермолай	Авдеев	\N	+7 357 477 79 00	8853 959493	среднее	5303
Евстафий	Алексеева	\N	+7 679 240 89 97	3685 521077	\N	5304
Герасим	Костина	\N	+76938463242	1756 781999	\N	5305
Эрнст	Тихонов	Кузьминична	+7 (663) 501-19-08	4068 827981	среднее профессиональное	5306
Федор	Мухина	\N	+7 (688) 552-9499	3524 787822	среднее	5307
Спиридон	Колесникова	\N	+7 034 908 00 54	4731 513531	среднее профессиональное	5308
Лора	Некрасова	Иларионович	8 (605) 854-2284	4684 615650	высшее	5309
Кир	Селезнев	Феофанович	8 515 430 21 53	6343 112661	высшее	5310
Пелагея	Нестеров	Викторовна	+7 604 050 71 44	8047 256975	\N	5311
Велимир	Ефремов	\N	8 (223) 569-4603	4750 122962	\N	5312
Нинель	Игнатова	\N	+7 (105) 399-37-01	2191 750306	среднее профессиональное	5313
Сильвестр	Кузьмин	Вадимовна	81624610557	7924 698695	\N	5314
Алла	Рогова	Артемовна	80526123044	2414 774397	неоконченное высшее	5315
Будимир	Лапина	Тарасович	8 (210) 151-50-74	6174 547764	\N	5316
Тимофей	Данилов	Кузьминична	87799144839	9544 359801	среднее	5317
Герасим	Гришин	\N	8 (909) 099-3568	7557 566144	неоконченное высшее	5318
Афанасий	Ильина	\N	+7 (116) 901-09-36	5467 456143	среднее профессиональное	5319
Исай	Кудряшова	\N	89944060728	9978 521295	среднее	5320
Исидор	Горбунова	\N	8 640 064 54 31	4401 724539	высшее	5321
Игорь	Гущина	\N	83173650999	7870 219166	среднее профессиональное	5322
Жанна	Лапина	\N	+7 682 609 23 68	2927 773722	среднее профессиональное	5323
Глеб	Назаров	Георгиевич	8 383 801 8240	9844 783021	\N	5324
Константин	Нестеров	Егорович	8 (126) 530-3948	3936 398791	среднее	5325
Аристарх	Прохорова	\N	+7 715 346 4946	7696 975606	высшее	5326
Ростислав	Осипов	\N	8 038 075 9649	7015 887027	высшее	5327
Радован	Соколов	Константиновна	+7 (445) 342-02-48	1780 291081	высшее	5328
Ия	Крюков	Дорофеевич	+7 (192) 456-0920	8553 918808	среднее	5329
Трофим	Мишина	\N	8 562 100 4045	1844 337875	высшее	5330
Венедикт	Тарасов	Чеславович	8 (686) 740-4394	3098 440785	\N	5331
Конон	Борисова	\N	8 791 287 3030	3688 305021	неоконченное высшее	5332
Валерий	Попова	Дмитриевна	8 (232) 809-1658	4160 491213	высшее	5333
Савелий	Дорофеев	\N	8 (240) 429-55-93	8709 774668	высшее	5334
Клавдия	Сафонова	\N	+7 (290) 058-5956	4640 596487	среднее	5335
Лучезар	Авдеев	\N	8 (328) 652-0203	2808 174835	среднее	5336
Олимпиада	Абрамова	\N	+7 350 529 55 34	5130 604284	высшее	5337
Самуил	Гущина	Эдгарович	8 (160) 574-00-63	4797 922974	высшее	5338
Устин	Гаврилова	\N	8 (687) 127-28-62	3005 271223	\N	5339
Ратмир	Хохлова	\N	8 265 889 9807	4079 284099	среднее	5340
Панфил	Носова	\N	8 (944) 108-40-13	3092 685902	среднее	5341
Трофим	Цветков	\N	8 (089) 581-29-27	6621 908650	неоконченное высшее	5342
Эммануил	Карпов	\N	8 (789) 524-5313	5015 158799	высшее	5343
Ратмир	Лаврентьев	Федосьевич	8 935 740 7622	1646 337062	среднее	5344
Эммануил	Сафонов	\N	88834917656	5797 577653	среднее профессиональное	5345
Богдан	Зиновьев	\N	8 (337) 036-46-37	4339 218080	неоконченное высшее	5346
Милица	Архипов	\N	+7 150 206 02 04	6647 433868	среднее профессиональное	5347
Софрон	Ситников	Гордеевич	8 (091) 853-47-72	5317 804758	\N	5348
Прасковья	Русакова	Георгиевна	+7 (997) 204-4479	9542 882743	\N	5349
Руслан	Лукина	\N	8 (057) 521-9038	1584 632124	высшее	5350
Якуб	Коновалова	Робертовна	+76332860140	4990 301720	высшее	5351
Филарет	Матвеева	\N	+7 585 452 5877	3536 242091	среднее профессиональное	5352
Анжела	Комарова	\N	88188501693	8108 721113	среднее профессиональное	5353
Михаил	Щербаков	\N	+7 (108) 021-97-67	9522 347204	\N	5354
Аркадий	Большакова	Феликсович	8 (504) 392-63-74	9165 933951	среднее	5355
Андроник	Константинова	Аксёнович	8 943 721 8175	9491 705721	среднее профессиональное	5356
Севастьян	Лукина	\N	+7 911 785 19 31	2730 342056	неоконченное высшее	5357
Влас	Медведева	Трифонович	+7 (519) 332-73-99	2700 924752	\N	5358
Капитон	Кириллов	\N	82818231878	8944 730150	среднее профессиональное	5359
Милан	Рыбаков	\N	8 (602) 954-06-70	8385 690423	среднее профессиональное	5360
Борислав	Кононова	\N	8 097 920 70 14	3997 646812	\N	5361
Савватий	Рябов	\N	8 416 829 1737	6632 377959	неоконченное высшее	5362
Леонтий	Никонов	Захаровна	8 097 009 80 34	6480 651773	среднее	5363
Каллистрат	Лобанов	\N	+7 794 276 2845	2107 245144	\N	5364
Касьян	Щербакова	Ниловна	8 970 221 59 58	2797 897363	среднее профессиональное	5365
Иосиф	Михайлова	\N	+7 (505) 293-4987	3281 353586	высшее	5366
Евгения	Власова	\N	8 (761) 467-16-24	9354 721021	неоконченное высшее	5367
Пелагея	Агафонова	\N	+76130398436	2210 699962	среднее	5368
Ирина	Смирнов	\N	85004398425	9957 572061	среднее профессиональное	5369
Онуфрий	Смирнова	Юрьевна	+7 967 358 40 80	2752 926396	среднее	5370
Ерофей	Романова	Болеславовна	8 (085) 279-6047	9279 339224	среднее профессиональное	5371
Вероника	Белов	Александровна	8 779 998 6027	4567 324448	\N	5372
Трофим	Лихачева	Артурович	8 520 017 72 25	4530 667939	среднее профессиональное	5373
Варлаам	Беляев	Робертовна	+7 435 392 3999	5466 566224	среднее профессиональное	5374
Еремей	Потапова	Тимурович	+71003624882	1300 697825	\N	5375
Адам	Волков	\N	+7 984 517 65 05	5823 874993	среднее профессиональное	5376
Моисей	Воронова	\N	+7 911 257 35 11	3701 973411	среднее	5377
Таисия	Гордеев	Валерьевич	+7 (809) 029-29-60	4675 940459	среднее профессиональное	5378
Наталья	Исаков	Владиславович	+75511589036	4839 752192	высшее	5379
Лучезар	Герасимова	Авдеевич	+79768420431	8069 948173	\N	5380
Данила	Зиновьева	Алексеевич	+7 (316) 692-3166	1027 891513	высшее	5381
Эмиль	Казаков	Львовна	+7 (479) 818-0965	5656 718514	среднее профессиональное	5382
Давыд	Зайцев	Викентьевич	8 (331) 765-4866	9997 705837	\N	5383
Василий	Абрамов	\N	+7 (594) 896-4672	7077 404405	неоконченное высшее	5384
Всеволод	Харитонова	Антоновна	+7 (480) 031-86-47	7742 740091	среднее профессиональное	5385
Анатолий	Смирнов	\N	+7 541 686 24 67	3479 193467	высшее	5386
Игорь	Горбачев	\N	8 (723) 577-99-05	6483 236032	среднее	5387
Вадим	Федоров	Якубович	+72442684315	5521 587048	\N	5388
Данила	Михайлова	Вячеславович	+7 (281) 678-26-24	3701 770628	среднее	5389
Тимофей	Фомичева	Бориславович	8 064 648 4416	6077 158780	неоконченное высшее	5390
Лев	Никонова	\N	8 (704) 259-6934	6146 761622	\N	5391
Станислав	Назаров	Антоновна	+7 (408) 694-5451	6616 764525	среднее профессиональное	5392
Анатолий	Капустина	\N	8 (413) 449-2994	1916 108343	среднее профессиональное	5393
Феоктист	Антонова	Мироновна	8 (597) 180-51-35	9060 253765	высшее	5394
Ананий	Григорьев	Вячеславовна	8 479 155 4328	9222 586994	неоконченное высшее	5395
Добромысл	Некрасов	\N	+7 (293) 676-6567	4307 412004	среднее	5396
Христофор	Колесников	Филатович	+7 226 588 77 20	3085 292922	\N	5397
Автоном	Казакова	Матвеевич	8 942 746 90 94	9809 794028	\N	5398
Радим	Силин	\N	80741104822	5120 781892	среднее профессиональное	5399
Гремислав	Петухова	Альбертовна	+73907499148	5959 509771	\N	5400
Демьян	Селиверстова	Жоресович	8 (810) 757-1959	9033 833044	высшее	5401
Петр	Михеева	Аксёнович	8 990 928 52 17	8955 355084	среднее профессиональное	5402
Эммануил	Куликова	Макаровна	+7 (966) 047-0379	8121 133890	\N	5403
Милица	Логинов	Феликсович	8 597 526 12 38	2163 990528	среднее	5404
Аникей	Семенова	Болеславовна	83412541511	5680 272015	среднее	5405
Глеб	Бобров	\N	82721655136	9008 944360	\N	5406
Дорофей	Александрова	\N	+7 (793) 846-6869	4383 598225	\N	5407
Евстафий	Петров	\N	+76485479422	1678 920274	\N	5408
Оксана	Григорьев	Брониславович	+7 (078) 848-2747	8350 313321	неоконченное высшее	5409
Ефим	Чернова	\N	+7 (174) 184-7103	1596 219823	среднее	5410
Евстигней	Устинова	Артурович	+7 994 527 1423	3307 485461	неоконченное высшее	5411
Казимир	Антонов	Алексеевна	+7 (696) 615-9832	1032 294970	высшее	5412
Савва	Калашникова	\N	+70235436805	3617 683191	среднее профессиональное	5413
Доброслав	Гордеева	\N	8 (682) 530-65-29	5233 563085	неоконченное высшее	5414
Пров	Трофимов	Юлианович	8 081 585 2473	2728 490217	\N	5415
Нестор	Филиппова	\N	+7 (839) 154-3389	2075 375617	высшее	5416
Арсений	Кузнецова	\N	+7 (898) 641-6094	6221 925821	среднее профессиональное	5417
Сигизмунд	Кулаков	Константиновна	8 (446) 905-54-14	1205 559764	высшее	5418
Давыд	Мельникова	\N	88367990449	3113 694537	среднее профессиональное	5419
Евпраксия	Мишина	\N	+7 (039) 010-6479	3337 827407	\N	5420
Болеслав	Щербаков	\N	+7 399 573 64 56	5568 432753	высшее	5421
Никифор	Воронова	Захарьевич	+7 (181) 045-9457	3948 701090	высшее	5422
Олимпий	Горбунова	\N	88147126864	7324 923705	\N	5423
Дементий	Савельев	\N	8 546 823 5532	4727 821998	среднее профессиональное	5424
Мирон	Данилова	Леонидовна	8 192 299 01 89	3357 379128	\N	5425
Платон	Панова	\N	+7 (009) 506-36-01	6585 921387	неоконченное высшее	5426
Аникита	Николаева	Владиславовна	8 (550) 758-1021	1751 550179	высшее	5427
Мария	Котов	Кузьминична	8 630 192 27 70	9514 568129	\N	5428
Измаил	Дорофеева	Ермолаевич	+7 949 039 2875	9178 210906	\N	5429
Юлиан	Герасимова	\N	8 338 699 6565	7262 954095	среднее	5430
Милица	Архипова	\N	+7 (124) 769-20-61	5605 991505	среднее профессиональное	5431
Ульян	Назарова	Тимурович	+7 (637) 034-33-89	8528 290116	среднее профессиональное	5432
Ефрем	Лукина	Антоновна	+7 163 784 38 21	8643 322089	\N	5433
Наркис	Носов	\N	+74980453960	5702 791398	неоконченное высшее	5434
Александра	Фомичева	\N	8 625 092 9066	4325 992340	среднее профессиональное	5435
Александр	Григорьева	Юрьевна	+7 (746) 099-02-00	3707 960603	\N	5436
Ираклий	Лаврентьева	\N	+77539993190	1587 188985	среднее	5437
Добромысл	Воронцова	\N	+7 (218) 813-5168	5954 118628	высшее	5438
Агафья	Цветкова	Артемьевич	8 340 096 51 67	5527 410785	среднее профессиональное	5439
Никита	Калашникова	Захаровна	88615930714	2582 450580	высшее	5440
Милен	Гущин	\N	8 (655) 448-90-38	1439 566133	неоконченное высшее	5441
Милен	Зайцев	\N	+7 744 583 3348	3127 519238	\N	5442
Светозар	Панфилова	\N	8 081 085 7053	5721 533144	среднее	5443
Ратибор	Воробьев	Ярославович	8 (215) 731-79-71	6485 539868	\N	5444
Варлаам	Воронов	\N	8 (903) 470-7395	2908 506825	высшее	5445
Амос	Родионова	\N	8 (885) 125-1192	2392 611342	высшее	5446
Лидия	Белякова	\N	+7 081 554 5725	4721 305224	среднее	5447
Евдокия	Фадеева	Кузьминична	+78490804666	2309 923514	среднее профессиональное	5448
Севастьян	Селиверстов	Леонидовна	8 (566) 314-6109	7608 974361	среднее профессиональное	5449
Александр	Быкова	\N	8 431 838 5540	5437 927320	среднее	5450
Прасковья	Осипов	Матвеевич	8 783 431 12 80	9728 110993	среднее	5451
Натан	Белоусов	Анатольевна	+7 726 794 44 70	9745 546627	среднее	5452
Евлампий	Романова	Брониславович	8 076 891 6162	6781 214763	среднее профессиональное	5453
Фрол	Авдеева	\N	+77987205524	9285 141307	среднее профессиональное	5454
Роман	Голубев	Алексеевна	+7 539 882 3179	2835 156689	неоконченное высшее	5455
Любим	Захаров	Ааронович	8 (412) 621-5623	6399 903940	высшее	5456
Лавр	Шарапова	\N	8 352 440 5719	9994 272062	высшее	5457
Гедеон	Сидорова	Ермилович	+7 (120) 013-40-47	1861 595709	среднее	5458
Гордей	Агафонов	Трофимович	8 827 618 8939	9179 431487	неоконченное высшее	5459
Игнатий	Антонов	Артёмович	+7 274 373 08 62	4493 254292	среднее	5460
Боян	Кириллова	Филатович	+7 935 170 1097	1501 638734	высшее	5461
Потап	Тетерин	Егоровна	+76524314372	5067 774034	высшее	5462
Руслан	Константинов	\N	+70116493400	8289 788816	высшее	5463
Твердислав	Архипов	Феофанович	+7 (746) 977-84-18	3904 252347	среднее	5464
Анатолий	Фадеев	Эдгардович	8 (963) 443-38-48	6426 556825	среднее	5465
Илья	Давыдов	\N	8 092 721 82 26	1201 470726	неоконченное высшее	5466
Анжелика	Волкова	\N	8 941 786 06 24	5281 941598	среднее	5467
Карп	Беляев	Жоресович	8 970 082 2389	1933 748651	среднее профессиональное	5468
Наталья	Константинова	\N	8 691 507 64 64	6929 430118	высшее	5469
Валентина	Вишнякова	Адамович	8 (372) 986-26-86	4031 577810	\N	5470
Аполлинарий	Суханова	Вячеславович	8 150 079 0757	3249 733714	неоконченное высшее	5471
Трифон	Анисимов	\N	8 365 338 92 63	5939 660159	неоконченное высшее	5472
Кондрат	Морозов	\N	+7 (363) 219-20-46	8102 688530	среднее	5473
Александра	Соколова	Ивановна	+7 983 414 1830	1407 898991	неоконченное высшее	5474
Натан	Никонов	Викентьевич	8 926 409 38 50	4332 914590	высшее	5475
Будимир	Комиссаров	Бориславович	8 614 306 6472	6128 546320	неоконченное высшее	5476
Аверьян	Кононова	\N	+7 665 331 5781	2276 829952	\N	5477
Арсений	Сергеева	Яковлевна	8 (229) 023-4606	8749 701803	среднее	5478
Селиван	Савельева	Игнатович	8 (720) 200-8210	4577 728622	\N	5479
Лариса	Дорофеева	Бенедиктович	+7 (777) 105-6365	7812 210704	\N	5480
Марфа	Вишнякова	\N	+7 438 205 1115	4822 598481	среднее	5481
Карп	Козлов	Измаилович	8 (760) 621-89-50	4415 676067	\N	5482
Ерофей	Виноградов	\N	82454998604	4208 979237	среднее	5483
Всемил	Субботина	Якубович	8 477 558 24 03	2649 419814	высшее	5484
Боян	Харитонова	Мироновна	+7 077 345 1274	4783 470353	среднее профессиональное	5485
Филимон	Гуляева	Елизарович	+7 (954) 569-1770	2099 441793	среднее профессиональное	5486
Евлампий	Анисимова	Федосеевич	+77796181863	2885 462225	среднее профессиональное	5487
Ярослав	Федосеев	\N	+7 688 409 31 85	2657 149356	\N	5488
Евдоким	Афанасьева	Васильевич	+70081450535	9763 652101	высшее	5489
Борис	Горбачев	\N	86424300252	9283 910890	неоконченное высшее	5490
Лазарь	Сидоров	Арсенович	8 459 095 5318	2469 860843	неоконченное высшее	5491
Вероника	Гаврилова	Димитриевич	89026123796	1182 644375	среднее	5492
Эраст	Белякова	\N	80044537040	3968 133761	неоконченное высшее	5493
Евлампий	Мухина	\N	+72337698842	9050 585676	\N	5494
Амос	Маркова	Игнатьевич	+7 650 148 24 48	4029 758010	высшее	5495
Ульян	Шубин	Бориславович	8 (162) 731-5810	2733 699282	неоконченное высшее	5496
Всемил	Селиверстов	\N	+7 (652) 769-0085	2313 748451	среднее профессиональное	5497
Казимир	Калашников	Валерьевич	+7 491 344 0557	4669 531935	среднее	5498
Валентина	Аксенова	Бенедиктович	87497986725	4064 512158	неоконченное высшее	5499
Иосиф	Петухов	Руслановна	+76660204695	5956 787756	высшее	5500
Арефий	Воронцова	Бориславович	+7 (371) 181-4734	9611 415123	высшее	5501
Панфил	Савельева	\N	+7 723 156 0016	5867 937919	высшее	5502
Эммануил	Жуков	Фадеевич	87515867116	5984 594466	высшее	5503
Евстафий	Вишнякова	\N	86141228123	7416 533267	среднее профессиональное	5504
Элеонора	Герасимова	\N	+7 (890) 373-71-76	2127 909464	высшее	5505
Владилен	Николаева	\N	89006628969	6627 880045	среднее профессиональное	5506
Ярополк	Дроздова	\N	+7 750 990 40 20	5060 629833	высшее	5507
Руслан	Журавлев	\N	8 905 669 07 23	9016 152736	\N	5508
Агап	Овчинникова	\N	87478888763	1355 894234	\N	5509
Мирон	Пестова	Игнатович	8 (252) 298-19-13	4597 621792	среднее	5510
Аскольд	Савина	\N	8 417 578 6508	2518 199745	\N	5511
Вадим	Кошелева	Федосьевич	+7 727 714 55 58	2814 796318	\N	5512
Пелагея	Петухова	Владиславович	+75937597297	6025 348985	высшее	5513
Радислав	Силин	\N	+7 385 178 51 86	4909 842426	высшее	5514
Ефим	Алексеева	Чеславович	8 016 562 9030	9272 137181	высшее	5515
Лаврентий	Захаров	\N	+76629784463	5508 763678	среднее	5516
Агафья	Самойлова	Владиславович	+7 (070) 661-2349	5923 549700	среднее профессиональное	5517
Василий	Стрелкова	Никифоровна	+7 (309) 994-69-79	2318 267906	высшее	5518
Роман	Гуляев	Филиппович	8 (065) 015-95-47	1482 694654	среднее	5519
Максимильян	Макарова	Фомич	+7 742 954 4300	8154 786359	высшее	5520
Афанасий	Комиссаров	Дмитриевич	+7 185 629 9663	7887 241446	неоконченное высшее	5521
Валентина	Тихонов	\N	+7 732 384 36 08	8814 170815	\N	5522
Панкратий	Никонов	Харлампьевич	+7 (575) 254-92-43	1868 883969	среднее профессиональное	5523
Максим	Гусева	\N	+71946102795	2898 335072	\N	5524
Ипатий	Королев	\N	+74063727011	9640 356733	\N	5525
Синклитикия	Симонов	\N	+7 (745) 879-07-29	3317 521108	среднее профессиональное	5526
Святослав	Беспалова	\N	+7 (637) 102-4916	3596 164831	высшее	5527
Аполлинарий	Крюкова	\N	+7 498 282 61 37	9067 552763	\N	5528
Антип	Давыдов	Давидович	+7 (034) 823-0441	8335 282762	среднее профессиональное	5529
Иванна	Фокина	Арсеньевич	8 (974) 938-7465	4523 982570	среднее	5530
Адам	Логинова	Гертрудович	+7 (283) 670-81-73	5932 989821	среднее	5531
Ферапонт	Ларионов	\N	+7 132 983 26 88	2112 628552	высшее	5532
Агап	Мамонтова	\N	+74610327505	7614 196346	среднее профессиональное	5533
Евграф	Третьяков	Альбертовна	+7 (605) 318-47-40	5414 470706	высшее	5534
Ферапонт	Шашков	Ниловна	+7 472 907 1600	5059 361856	среднее	5535
Трофим	Суханова	\N	+7 (086) 517-3623	5521 943231	среднее профессиональное	5536
Емельян	Гуляева	Афанасьевич	+7 237 934 8421	8002 350953	высшее	5537
Семен	Тарасов	Афанасьевич	85495594723	2884 688903	неоконченное высшее	5538
Акулина	Виноградов	\N	+7 (952) 938-82-45	6195 688616	среднее профессиональное	5539
Леонид	Нестеров	Устинович	8 037 575 47 17	9716 129016	среднее	5540
Эрнст	Большаков	\N	+7 (555) 936-6230	6306 150297	неоконченное высшее	5541
Мефодий	Белова	Антоновна	+7 (507) 371-3287	1719 613778	неоконченное высшее	5542
Орест	Лобанов	\N	+70825446446	6775 427733	высшее	5543
Иларион	Лаврентьева	Ефимьевич	8 281 650 68 48	2969 484647	неоконченное высшее	5544
Терентий	Абрамова	\N	+7 (314) 140-8527	9075 774083	\N	5545
Дорофей	Ефремова	Робертовна	+7 (282) 214-89-08	4320 847887	среднее профессиональное	5546
Потап	Ермакова	\N	8 284 978 7163	9818 842549	среднее	5547
Давыд	Воронова	Бенедиктович	8 (078) 462-11-74	6472 523894	среднее	5548
Онуфрий	Гурьева	Валерьевич	+7 951 398 06 50	8827 553744	среднее профессиональное	5549
Иванна	Капустина	\N	+7 (966) 812-5848	2716 894744	\N	5550
Денис	Быкова	\N	85001490320	7039 661863	неоконченное высшее	5551
Марфа	Соловьева	\N	+7 231 676 9938	7573 208697	среднее	5552
Илья	Сидоров	\N	+7 (455) 773-8866	9356 418276	среднее профессиональное	5553
Лука	Никифорова	Григорьевич	+71810251783	8270 925003	неоконченное высшее	5554
Наркис	Ларионова	Никифоровна	+7 151 424 8850	2256 236563	\N	5555
Эмиль	Яковлев	\N	8 (417) 300-8568	6520 561173	среднее	5556
Пелагея	Осипова	\N	8 (651) 151-37-53	6325 765731	среднее	5557
Стоян	Крюкова	Эдгардович	+7 725 568 31 79	1904 782203	неоконченное высшее	5558
Владилен	Прохоров	\N	+7 (248) 232-63-25	4164 439552	неоконченное высшее	5559
Демид	Буров	Адамович	+7 (820) 680-43-11	6760 486939	\N	5560
Иванна	Волков	\N	8 (293) 354-1333	3721 287639	среднее профессиональное	5561
Ратмир	Фролов	\N	+7 (485) 091-2970	8792 926556	среднее	5562
Флорентин	Григорьев	Трофимович	+7 856 440 5187	8365 179328	высшее	5563
Леонтий	Миронов	\N	+7 (230) 114-85-54	7939 493827	среднее профессиональное	5564
Агафья	Молчанова	Богданович	80713576731	8436 463557	неоконченное высшее	5565
Самсон	Большаков	\N	+7 (584) 996-6995	6396 768632	неоконченное высшее	5566
Варвара	Сафонов	Жоресович	8 274 040 84 52	8467 578387	неоконченное высшее	5567
Илья	Шубина	Олеговна	+7 (098) 288-99-95	8263 916729	неоконченное высшее	5568
Аким	Дементьев	Егоровна	+7 735 926 89 19	2605 955435	высшее	5569
Феврония	Александрова	Владиславовна	+7 (712) 699-9785	7524 344187	неоконченное высшее	5570
Степан	Фокина	\N	8 583 009 3358	7429 556884	высшее	5571
Амос	Шаров	\N	8 (576) 128-0427	2182 518556	неоконченное высшее	5572
Валерий	Костин	Ермолаевич	8 (647) 231-7147	5499 171748	среднее	5573
Аггей	Яковлев	\N	88359653332	2757 165650	неоконченное высшее	5574
Фаина	Сергеева	\N	89296454055	1331 738982	\N	5575
Карл	Молчанов	Глебович	+7 (242) 067-89-99	4572 467112	высшее	5576
Харитон	Захаров	\N	+7 (538) 921-8720	2539 803307	среднее	5577
Станислав	Брагина	Феофанович	8 (146) 127-11-73	4779 339356	среднее профессиональное	5578
Владилен	Большаков	Тихонович	+7 860 186 57 24	3249 824928	\N	5579
Ульян	Мухина	\N	8 (673) 951-18-79	4744 288785	среднее профессиональное	5580
Роман	Мамонтова	Давыдович	8 679 687 0261	8393 848697	среднее	5581
Милован	Яковлева	Яковлевна	8 (991) 987-3381	3430 915332	\N	5582
Милан	Антонова	Изотович	+7 (724) 126-5346	9742 258449	среднее профессиональное	5583
Порфирий	Бобров	\N	+7 443 366 2035	8075 260809	среднее профессиональное	5584
Ольга	Кондратьева	Авдеевич	+7 (186) 562-14-59	4853 537420	среднее	5585
Устин	Антонов	\N	8 (617) 396-40-59	8484 169253	высшее	5586
Всеслав	Фомина	Тимофеевна	+7 (103) 809-6582	5202 977765	\N	5587
Аверкий	Шилов	\N	+73964537690	9035 648768	среднее профессиональное	5588
Ольга	Соболев	Григорьевич	+7 (594) 012-93-94	1528 512193	\N	5589
Лавр	Фомичева	\N	+7 925 821 13 13	1492 361922	среднее	5590
Борис	Артемьев	Болеславовна	+76071887075	3233 484961	среднее	5591
Селиверст	Самсонова	Рудольфовна	8 372 607 3887	3530 749766	высшее	5592
Октябрина	Рыбакова	Болеславовна	+7 566 414 64 55	1745 556714	среднее профессиональное	5593
Полина	Крылова	\N	+7 061 181 64 34	6979 197563	неоконченное высшее	5594
Милован	Тихонов	\N	+7 (461) 955-03-22	1294 822203	высшее	5595
Захар	Копылова	Ярославович	8 383 823 9833	8917 575356	неоконченное высшее	5596
Милий	Филатова	\N	8 834 405 90 11	9837 966689	высшее	5597
Иннокентий	Фокина	Игнатьевич	+7 302 494 6092	5390 503094	\N	5598
Ярополк	Яковлева	Степановна	+7 (990) 254-87-62	9839 422676	\N	5599
Порфирий	Абрамов	Бориславович	+75950939236	6092 861264	\N	5600
Милий	Красильников	\N	+7 952 595 42 85	8509 881355	высшее	5601
Пантелеймон	Калашникова	\N	+7 (097) 708-98-17	2270 919736	среднее профессиональное	5602
Никифор	Ершова	\N	8 (774) 079-6148	2149 540484	среднее	5603
Аскольд	Сазонова	Харитоновна	+7 205 136 7902	2114 230385	среднее	5604
Панкрат	Наумов	Аркадьевна	8 (653) 871-41-43	5234 663577	высшее	5605
Марина	Федосеева	Фокич	8 (137) 763-11-76	1135 708032	\N	5606
Сократ	Зайцева	Эльдаровна	8 (433) 260-04-78	5853 197654	неоконченное высшее	5607
Леон	Наумова	Эдгарович	8 987 179 97 42	2240 187507	неоконченное высшее	5608
Лукия	Стрелкова	\N	+7 (069) 638-4417	4998 882842	среднее	5609
Степан	Воронова	Венедиктович	8 (345) 750-67-94	2671 329842	среднее	5610
Аникей	Степанов	\N	82138336177	3086 429059	среднее	5611
Аверкий	Агафонова	\N	+7 (000) 367-7515	4828 257169	\N	5612
Федор	Ларионова	\N	+7 (606) 500-35-56	7698 606765	среднее	5613
Милан	Попова	\N	+7 752 337 6392	5392 294872	среднее	5614
Архип	Николаева	\N	+7 062 669 57 64	3387 523365	высшее	5615
Федосий	Фадеева	\N	8 (505) 214-04-73	1452 778305	\N	5616
Ермил	Бурова	Андреевна	+7 (306) 148-81-71	7236 813451	\N	5617
Анжела	Некрасова	\N	+7 628 474 7262	1399 122615	неоконченное высшее	5618
Ипатий	Крылов	\N	84492782556	7862 940914	\N	5619
Герман	Мишина	\N	+7 173 089 22 54	9263 559230	\N	5620
Евлампий	Орлов	\N	+78289873363	2808 554874	высшее	5621
Виктория	Антонова	Афанасьевна	8 (184) 012-54-35	3683 114973	\N	5622
Мирон	Сидорова	\N	8 539 847 53 60	2782 871969	неоконченное высшее	5623
Леонтий	Кабанова	Харлампович	+73405621845	7454 137068	неоконченное высшее	5624
Эрнст	Шашкова	Ивановна	+7 357 311 99 42	9584 159296	среднее	5625
Доброслав	Николаев	\N	8 (006) 043-80-59	9006 867053	\N	5626
Сидор	Кириллов	Валерьевич	+7 (097) 023-7935	7351 611376	среднее	5627
Регина	Цветкова	Валентиновна	+7 (577) 103-9244	2472 870944	высшее	5628
Прокофий	Силин	\N	+7 532 733 52 71	3685 897502	\N	5629
Нинель	Трофимов	Федотович	8 825 789 22 96	8946 417160	\N	5630
Прасковья	Ширяева	Матвеевич	+7 771 456 31 31	5532 998204	среднее	5631
Владилен	Рожков	Харламович	+7 259 724 1461	9611 142078	\N	5632
Прасковья	Устинов	\N	+7 (137) 692-10-71	4190 690902	неоконченное высшее	5633
Самуил	Кудряшов	\N	88241631389	3264 916353	высшее	5634
Ульян	Крюков	Трофимович	8 (284) 475-31-41	4644 595346	среднее	5635
Софон	Родионов	Аскольдовна	87771327553	7509 538784	среднее профессиональное	5636
Алевтина	Игнатов	Викентьевич	+78577890975	2396 560105	среднее профессиональное	5637
Агата	Игнатова	Тарасовна	8 214 210 88 60	6474 558972	\N	5638
Ладимир	Сорокин	\N	8 078 371 23 78	7809 244287	неоконченное высшее	5639
Синклитикия	Меркушева	Вениаминовна	8 472 884 55 42	2915 633714	среднее профессиональное	5640
Феофан	Жукова	Борисовна	+7 (285) 504-0591	6478 777464	неоконченное высшее	5641
Тарас	Симонова	\N	+7 038 927 1686	1146 461295	неоконченное высшее	5642
Гурий	Попов	Анатольевич	8 766 083 45 86	7725 505501	\N	5643
Моисей	Федорова	Георгиевич	8 (702) 209-39-14	5766 393905	\N	5644
Кир	Меркушев	\N	+7 650 920 21 07	1021 615127	неоконченное высшее	5645
Адриан	Крылова	\N	8 976 204 3850	5505 470738	высшее	5646
Лора	Коновалов	\N	+78476466017	4161 320590	среднее профессиональное	5647
Эмиль	Волков	Мироновна	+7 (813) 888-12-85	5996 168204	высшее	5648
Лучезар	Блохина	\N	83547270509	2956 887434	среднее	5649
Харлампий	Калинина	\N	+7 136 623 44 76	5365 403284	среднее	5650
Автоном	Гуляева	\N	84941720776	6341 830705	высшее	5651
Гордей	Ширяева	Павловна	8 (100) 904-0200	5836 836255	\N	5652
Николай	Денисов	\N	8 (663) 100-7904	4259 997291	\N	5653
Демьян	Комиссарова	\N	87126459856	8516 671781	неоконченное высшее	5654
Игорь	Филатова	Анисимович	+7 (673) 908-7264	2784 554709	\N	5655
Платон	Титов	Алексеевич	+7 313 985 24 83	2539 211188	среднее профессиональное	5656
Филимон	Попова	Авдеевич	+73594851938	5568 249736	среднее профессиональное	5657
Фортунат	Миронова	Робертовна	8 104 030 8040	4504 332677	неоконченное высшее	5658
Вячеслав	Волкова	\N	81603573036	7544 598612	неоконченное высшее	5659
Всеслав	Ситников	Глебович	+7 560 342 39 30	9743 304734	\N	5660
Дарья	Владимирова	\N	8 (764) 517-12-03	4097 104447	\N	5661
Варфоломей	Крылов	\N	+7 (871) 259-98-56	6741 830051	\N	5662
Исидор	Игнатьева	\N	+7 324 735 71 86	1647 787308	среднее профессиональное	5663
Болеслав	Ефремова	Ефимовна	8 863 234 31 84	4927 610255	высшее	5664
Прокофий	Муравьева	\N	+75736367097	4436 719622	\N	5665
Георгий	Голубев	Аксёнович	8 542 159 7698	8625 424534	высшее	5666
Епифан	Быков	Степановна	+7 (813) 601-3928	8689 977219	\N	5667
Олимпий	Тихонов	\N	+7 (228) 820-6145	1756 612501	среднее профессиональное	5668
Олимпиада	Панова	\N	+7 529 211 00 18	4939 505475	неоконченное высшее	5669
Аркадий	Лобанов	\N	+7 (438) 180-9910	4838 660088	высшее	5670
Пров	Быков	Жоресович	+70974582230	3806 246470	\N	5671
Никодим	Шубина	\N	+76232691699	2323 269034	неоконченное высшее	5672
Карп	Марков	Тимофеевна	+7 (546) 229-17-37	8699 642992	среднее профессиональное	5673
Никандр	Гаврилов	Федосьевич	8 (317) 455-50-55	3952 675731	среднее	5674
Георгий	Королева	Бориславович	8 (194) 149-5436	8108 659662	\N	5675
Аскольд	Баранов	Викторович	+7 (081) 206-9084	6234 172861	среднее	5676
Тарас	Жуков	Михайловна	8 693 610 1374	9738 210957	неоконченное высшее	5677
Кузьма	Прохоров	\N	8 (479) 624-2430	2904 980474	\N	5678
Аскольд	Ширяев	\N	+7 402 724 8541	1877 138209	среднее	5679
Клавдия	Смирнов	Ефстафьевич	8 (146) 437-40-17	1700 184200	неоконченное высшее	5680
Илья	Кулаков	Арсеньевич	8 (439) 124-6840	9488 178729	среднее	5681
Андрон	Карпов	\N	+7 (811) 561-4368	3296 262326	среднее	5682
Георгий	Русаков	Валерианович	+7 (250) 107-08-45	8293 693083	высшее	5683
Владлен	Семенов	\N	+7 604 011 95 66	9697 568417	высшее	5684
Мирослав	Суворов	\N	8 737 592 4791	5314 174180	среднее	5685
Ия	Сафонова	Теймуразович	+7 (472) 926-00-34	6926 445169	среднее профессиональное	5686
Ярополк	Коновалова	Макаровна	8 621 957 84 38	9075 425904	среднее	5687
Егор	Прохорова	\N	+7 (086) 135-96-08	5021 839352	среднее профессиональное	5688
Пров	Власова	Ермилович	+71463630142	7075 572528	высшее	5689
Милий	Доронин	\N	83293433419	7410 379409	\N	5690
Олимпиада	Осипов	\N	8 252 430 2655	7319 868946	высшее	5691
Гостомысл	Васильев	Тимуровна	+76742983654	9735 884947	высшее	5692
Соломон	Пестова	\N	+74583745548	4606 519739	неоконченное высшее	5693
Мечислав	Зиновьев	Эльдаровна	+79112897319	2906 652040	среднее профессиональное	5694
Прокофий	Исакова	Захаровна	+76799984175	3815 441685	\N	5695
Зиновий	Щукина	Гордеевич	+7 555 766 8880	5786 520286	среднее профессиональное	5696
Арефий	Дроздова	\N	8 586 990 73 02	7617 747037	среднее	5697
Лев	Шестаков	Филипповна	+7 (292) 582-84-66	7470 240262	среднее профессиональное	5698
Мечислав	Комиссаров	Матвеевич	84038373817	1851 541058	высшее	5699
Олимпий	Гордеев	Викторович	8 (360) 691-7649	5169 304350	неоконченное высшее	5700
Лаврентий	Воробьев	\N	80352105192	7157 276102	неоконченное высшее	5701
Анисим	Фокин	Виленович	+7 (393) 032-8331	9717 117668	среднее	5702
Фока	Молчанова	Анатольевна	+7 (992) 305-43-22	1729 473464	высшее	5703
Пелагея	Михайлов	Фокич	+7 231 498 33 23	7973 779109	среднее профессиональное	5704
Данила	Лыткин	Максимовна	+71152274158	3394 363851	\N	5705
Авдей	Борисов	Елизарович	+7 (472) 175-53-94	1738 614936	среднее профессиональное	5706
Мина	Федосеев	Яковлевич	+7 (951) 601-6414	8104 207576	неоконченное высшее	5707
Потап	Артемьев	\N	8 922 506 61 05	6409 406168	неоконченное высшее	5708
Устин	Шарапов	Валерьевич	8 546 022 93 34	9622 680923	высшее	5709
Татьяна	Герасимова	\N	+7 581 483 23 27	7002 682764	\N	5710
Гаврила	Сергеев	Алексеевна	+7 (624) 341-3927	5669 215897	среднее профессиональное	5711
Мстислав	Козлова	Оскаровна	8 (694) 114-2136	8672 118836	неоконченное высшее	5712
Зиновий	Анисимова	\N	+7 (631) 463-43-80	5249 474094	среднее	5713
Андрон	Тимофеева	\N	8 (846) 081-2557	5871 741308	среднее	5714
Гордей	Комиссарова	Фомич	8 (728) 481-9215	2689 119081	высшее	5715
Исай	Игнатова	\N	+7 (728) 398-25-28	4126 805691	среднее	5716
Мартьян	Ларионова	\N	8 002 185 1720	3972 721120	среднее	5717
Аггей	Хохлова	\N	8 009 555 13 01	8327 137025	высшее	5718
Эрнст	Федосеева	\N	+7 (910) 660-95-60	3888 679076	высшее	5719
Фома	Юдин	Ефимовна	81678830960	4022 560432	неоконченное высшее	5720
Георгий	Ефимов	\N	8 (811) 809-84-48	9637 803531	среднее профессиональное	5721
Фёкла	Гущин	Борисович	+75842697701	2434 326892	неоконченное высшее	5722
Зоя	Журавлева	\N	8 546 264 99 62	9332 704738	среднее	5723
Азарий	Трофимова	Валерьянович	8 (083) 823-05-34	5554 218169	неоконченное высшее	5724
Зоя	Фокин	\N	+7 738 308 03 66	8106 714599	среднее профессиональное	5725
Мстислав	Филиппов	\N	85765829579	4637 406988	высшее	5726
Кирилл	Филиппова	\N	+75221547132	4252 557977	высшее	5727
Иннокентий	Лихачева	Демьянович	+7 (442) 427-1480	4794 697225	\N	5728
Гремислав	Самойлов	Артемьевич	8 (211) 941-05-28	8414 235106	среднее профессиональное	5729
Пров	Громов	Ефимовна	+7 (891) 297-07-73	2559 347852	высшее	5730
Архип	Трофимова	\N	8 (688) 790-89-31	8136 544319	высшее	5731
Савва	Доронин	\N	+7 737 840 5831	2207 298309	\N	5732
Анисим	Носков	\N	8 892 274 3079	8355 938908	высшее	5733
Мечислав	Буров	\N	8 321 077 6957	5254 749000	среднее	5734
Николай	Потапова	\N	8 (029) 002-29-29	9593 861947	среднее	5735
Гедеон	Власов	Владленович	8 024 350 38 71	5367 625683	неоконченное высшее	5736
Ферапонт	Галкина	Эдуардович	+75288439132	8387 425522	неоконченное высшее	5737
Гордей	Степанова	\N	+7 691 597 1042	4651 946365	\N	5738
Анжелика	Соболева	Викторович	8 (004) 147-1351	2151 683160	\N	5739
Радован	Калинина	Захарьевич	+73036083454	1790 844631	\N	5740
Авдей	Капустина	\N	8 850 401 25 65	1087 852082	\N	5741
Валентин	Савельева	\N	8 929 295 33 75	7500 340019	среднее профессиональное	5742
Бажен	Захарова	Владиславовна	8 (266) 181-54-14	6538 106764	среднее	5743
Мартын	Кононова	Руслановна	8 891 289 8816	8125 879892	среднее профессиональное	5744
Мария	Авдеева	Авдеевич	+7 (058) 046-8684	5034 952901	неоконченное высшее	5745
Арефий	Калинин	\N	88595214058	7715 298729	высшее	5746
Аскольд	Цветкова	\N	85742296627	5193 452098	высшее	5747
Филимон	Осипов	\N	85452579756	3748 724606	высшее	5748
Валерия	Маслов	Олеговна	8 646 383 7427	9293 780983	высшее	5749
Велимир	Суворов	Владиленович	+7 043 856 1038	5935 618849	среднее	5750
Ерофей	Субботин	\N	+7 (991) 818-6643	8007 549483	неоконченное высшее	5751
Максим	Муравьева	Валерьянович	89628318595	1623 435763	среднее профессиональное	5752
Твердислав	Кондратьева	\N	8 478 849 90 84	1988 612064	неоконченное высшее	5753
Мариан	Симонова	\N	84139492678	5121 883470	среднее	5754
Еремей	Щербаков	\N	8 745 265 1924	2393 404116	среднее профессиональное	5755
Ульян	Ширяев	\N	8 (590) 119-9723	9945 149257	\N	5756
Татьяна	Бирюкова	Бенедиктович	8 107 104 8866	5569 400329	высшее	5757
Ян	Наумов	\N	+7 (749) 439-93-18	7096 339310	среднее профессиональное	5758
Ярослав	Носова	Макаровна	+70288032624	6546 185744	среднее профессиональное	5759
Савватий	Исаева	\N	8 (197) 419-0472	7084 170892	\N	5760
Пров	Андреева	\N	81512773058	5448 300473	высшее	5761
Ким	Михеев	Витальевич	8 (214) 872-9641	6649 681949	\N	5762
Аскольд	Беляев	Давидович	8 820 480 8263	2192 442800	среднее	5763
Эрнст	Авдеева	Гурьевич	+7 (765) 871-0621	2329 719913	\N	5764
Порфирий	Полякова	\N	8 600 769 40 56	1267 622388	среднее профессиональное	5765
Иосиф	Лобанов	Леоновна	8 (295) 835-8531	5635 205674	высшее	5766
Анжела	Наумов	Георгиевна	85209528244	2435 162781	среднее	5767
Мстислав	Ширяев	Александрович	8 074 052 7660	1952 990563	среднее профессиональное	5768
Парамон	Беляков	Гертрудович	8 (431) 313-73-11	8648 377455	\N	5769
Елисей	Тетерина	\N	+71509935587	1782 445846	высшее	5770
Пимен	Данилова	\N	8 (789) 987-10-51	6535 622660	\N	5771
Арсений	Фокин	\N	8 229 599 03 40	5663 186827	неоконченное высшее	5772
Никита	Зыков	\N	8 236 069 1857	6584 828336	среднее	5773
Ростислав	Семенов	Богданович	8 355 088 48 53	1426 735453	неоконченное высшее	5774
Герман	Харитонова	\N	87745774855	5770 452054	среднее	5775
Амос	Маркова	Вадимовна	+7 (055) 955-8199	7972 491488	\N	5776
Анатолий	Елисеева	\N	8 296 569 67 42	6438 367497	среднее профессиональное	5777
Добромысл	Молчанова	\N	8 978 218 17 75	7249 509496	\N	5778
Марфа	Веселова	Андреевна	+7 (486) 289-9184	8875 922293	неоконченное высшее	5779
Филимон	Логинов	\N	+7 (083) 508-60-84	3549 979225	неоконченное высшее	5780
Андрей	Устинова	\N	8 (909) 863-3844	2814 252360	высшее	5781
Дмитрий	Дмитриева	\N	+7 796 214 70 46	5961 309417	неоконченное высшее	5782
Сигизмунд	Михеев	\N	+7 890 694 8227	8686 657096	среднее профессиональное	5783
Евгений	Кошелева	\N	+7 (790) 218-66-55	3843 362279	среднее профессиональное	5784
Марина	Киселев	Бенедиктович	+7 (840) 984-3404	9364 581772	среднее профессиональное	5785
Мартьян	Родионов	Ефимьевич	+7 685 496 8953	8265 483472	неоконченное высшее	5786
Серафим	Терентьев	Гурьевич	8 (996) 940-8357	9435 662488	\N	5787
Ипат	Дьячков	Харлампьевич	88344844065	7782 896725	высшее	5788
Лавр	Орехов	\N	8 (705) 149-61-60	4340 383523	\N	5789
Валерия	Меркушева	Абрамович	+7 763 152 1296	9586 238572	неоконченное высшее	5790
Автоном	Субботина	Фомич	+7 579 940 1859	7504 672826	\N	5791
Авдей	Третьяков	\N	+7 241 563 0262	7488 706317	среднее	5792
Никифор	Красильников	Еремеевич	+7 859 678 98 97	2993 165125	среднее профессиональное	5793
Демьян	Титов	\N	+7 461 333 9150	5693 315107	среднее	5794
Григорий	Шарова	\N	+7 333 465 76 37	3992 760067	среднее профессиональное	5795
Пимен	Соколова	\N	8 (868) 304-87-53	2311 927371	высшее	5796
Валентин	Смирнова	\N	8 (107) 262-8079	6380 270374	среднее профессиональное	5797
Нинель	Максимова	Ниловна	89493329618	1601 103422	высшее	5798
Валерьян	Устинов	Венедиктович	+7 (756) 806-27-35	2799 190135	неоконченное высшее	5799
Маргарита	Колобова	Бориславович	8 (075) 147-7676	2608 506772	\N	5800
Нифонт	Емельянов	Григорьевна	8 (297) 790-22-83	6018 373004	\N	5801
Будимир	Калинин	\N	8 (839) 418-82-90	6759 129231	\N	5802
Стоян	Самсонова	\N	8 019 502 8819	8533 664416	среднее	5803
Матвей	Денисов	\N	83309803042	7821 216698	высшее	5804
Алексей	Шилова	Яковлевич	8 (530) 909-31-25	5355 386383	неоконченное высшее	5805
Архип	Белов	\N	+78998856310	7676 471513	высшее	5806
Милен	Юдина	Изотович	8 480 457 14 37	9644 902859	неоконченное высшее	5807
Октябрина	Копылов	\N	+75825923676	8948 378301	среднее	5808
Сила	Белов	\N	8 000 810 12 03	6626 338289	среднее	5809
Сила	Горбунова	\N	8 (025) 705-55-61	1911 116174	неоконченное высшее	5810
Владилен	Котов	Иларионович	82064355106	3144 116952	среднее профессиональное	5811
Максимильян	Воронцова	\N	+7 (266) 908-84-31	9715 347306	высшее	5812
Пимен	Моисеев	\N	8 (128) 983-6859	6903 663613	неоконченное высшее	5813
Светлана	Мельникова	\N	+7 007 137 7135	6974 381324	среднее	5814
Парфен	Панов	\N	8 (992) 175-1425	9478 628313	неоконченное высшее	5815
Лора	Евсеев	Вячеславович	84724060527	5567 735745	высшее	5816
Август	Прохоров	\N	+7 (632) 603-2273	4921 997416	\N	5817
Анна	Стрелков	Фёдорович	+78160671854	9063 952001	среднее профессиональное	5818
Поликарп	Миронов	\N	8 (087) 765-8349	3287 540982	\N	5819
Лев	Одинцова	Жанович	8 263 246 69 77	7502 105310	неоконченное высшее	5820
Осип	Алексеева	\N	83138751842	2912 487077	\N	5821
Любомир	Тихонов	\N	+7 628 836 9512	6916 507283	\N	5822
Варлаам	Селиверстов	Арсеньевич	+7 697 756 62 59	6329 286636	\N	5823
Андроник	Филатов	Ермилович	+7 702 408 3239	4558 224462	высшее	5824
Гаврила	Горбачева	Кузьминична	8 446 539 19 12	2334 595243	среднее	5825
Орест	Кудряшова	Даниловна	8 (254) 981-94-84	2868 441757	неоконченное высшее	5826
Бажен	Капустина	Александровна	+7 (898) 438-9688	7106 160231	высшее	5827
Никифор	Фомина	\N	8 824 309 24 77	7839 699436	высшее	5828
Ия	Сафонова	\N	+7 697 475 0464	2737 980135	\N	5829
Радован	Кузьмин	Леоновна	8 073 529 1192	4825 566860	среднее	5830
Алина	Комаров	Федосеевич	+7 546 415 5683	9380 527519	среднее профессиональное	5831
Епифан	Дорофеева	\N	+77319355250	3970 810777	неоконченное высшее	5832
Мартьян	Шестаков	\N	8 906 780 70 16	8514 720562	\N	5833
Наталья	Одинцова	\N	+7 (196) 806-9793	4129 491955	высшее	5834
Тимофей	Ефремова	Юльевич	+7 482 294 11 47	4488 691035	высшее	5835
Август	Суворов	Эдуардовна	+7 (243) 996-00-12	3168 628670	высшее	5836
Наум	Осипова	Вадимовна	8 080 734 2971	7399 699839	высшее	5837
Раиса	Лихачева	Елизарович	+7 387 250 07 50	7742 430325	неоконченное высшее	5838
Евгений	Ситников	\N	81647623141	3431 167959	среднее	5962
Викторин	Ковалева	Исидорович	+7 (955) 879-3892	2423 301524	неоконченное высшее	5839
Мартьян	Савельева	Рудольфовна	8 (034) 588-47-98	7424 521906	среднее	5840
Лавр	Сафонов	Кузьминична	+7 365 760 22 76	7766 831405	\N	5841
Милан	Лебедев	Георгиевна	+7 493 081 4722	4679 437219	\N	5842
Сила	Андреева	Ждановна	+7 716 878 91 53	6650 234460	среднее профессиональное	5843
Нонна	Соловьев	Вячеславовна	+7 (100) 345-12-52	2790 131193	высшее	5844
Тимофей	Зиновьев	Ефстафьевич	8 937 101 4140	6723 274354	среднее	5845
Панкратий	Горбачев	\N	89631636639	8152 448713	среднее	5846
Леонид	Алексеева	\N	+7 358 800 6080	9575 213628	неоконченное высшее	5847
Фрол	Гусева	\N	8 889 119 9046	1097 352588	\N	5848
Роман	Силина	Ильясович	+7 639 823 6847	2289 869142	неоконченное высшее	5849
Анна	Брагина	Тарасович	8 900 619 95 81	3359 687711	среднее	5850
Мирон	Лапина	Федосеевич	86663419626	2557 445710	среднее профессиональное	5851
Регина	Маслов	Анисимович	+7 (055) 444-6280	9206 421462	неоконченное высшее	5852
Остап	Русаков	\N	8 (370) 017-3248	5680 486626	среднее	5853
Самуил	Мишин	\N	8 (689) 715-0864	9510 331964	высшее	5854
Клавдия	Красильников	Ефстафьевич	+7 083 363 08 83	1624 655232	среднее	5855
Прасковья	Белоусова	Арсеньевич	+7 165 984 0029	3755 429270	высшее	5856
Панкратий	Костина	\N	+7 929 085 56 61	8902 505866	среднее	5857
Лонгин	Гуляева	\N	+7 609 938 3847	4712 487295	высшее	5858
Елисей	Блохина	\N	8 388 243 5987	2704 284405	\N	5859
Викентий	Романов	Валериевна	+7 036 039 50 83	2265 896987	среднее	5860
Максим	Никифорова	\N	8 604 810 9941	5830 545335	неоконченное высшее	5861
Велимир	Ковалева	\N	+7 (037) 562-17-84	3219 478919	среднее профессиональное	5862
Савватий	Громов	Валентиновна	8 (579) 896-64-23	8216 580451	неоконченное высшее	5863
Борис	Гурьев	Игнатович	8 (477) 087-09-85	1456 792269	\N	5864
Павел	Шубина	Анатольевич	+7 281 776 09 08	7867 269328	неоконченное высшее	5865
Кузьма	Дементьева	Ильясович	8 (876) 292-37-70	6825 672272	среднее профессиональное	5866
Лонгин	Ефимова	\N	+75801990440	2979 439123	\N	5867
Фёкла	Аксенова	Павловна	8 513 772 2466	6037 532669	неоконченное высшее	5868
Пелагея	Филатов	\N	+7 (145) 092-95-91	2777 424257	\N	5869
Касьян	Казакова	\N	+7 858 231 22 12	5979 103208	среднее профессиональное	5870
Виктория	Медведев	\N	+7 824 816 21 08	6775 361240	среднее профессиональное	5871
Елена	Тимофеев	\N	8 173 936 65 66	7747 124749	неоконченное высшее	5872
Любим	Авдеева	\N	8 (952) 237-5814	9966 571648	среднее	5873
Милий	Соколов	\N	+7 (015) 227-21-01	6872 581912	среднее	5874
Ираида	Овчинникова	\N	+76256392944	8587 647196	среднее	5875
Нестор	Беляева	Эдуардовна	8 846 644 18 71	9291 382197	высшее	5876
Всеслав	Орлова	\N	8 590 235 2504	1012 808133	\N	5877
Селиверст	Попова	Сергеевна	+7 (023) 835-37-68	1182 534475	\N	5878
Марина	Воронова	\N	+7 139 302 0676	2696 905272	среднее профессиональное	5879
Кондрат	Комаров	\N	+7 (338) 147-8872	2441 887818	высшее	5880
Фадей	Зимин	Витальевич	8 174 648 42 64	4529 381071	неоконченное высшее	5881
Зоя	Бурова	\N	+7 (554) 817-59-41	2331 256280	высшее	5882
Алевтина	Колобов	Ефстафьевич	+7 541 289 7602	7324 727209	\N	5883
Селиван	Яковлева	Тарасовна	+7 661 102 73 46	9693 170569	высшее	5884
Емельян	Князева	Ефимьевич	+7 (704) 748-51-27	8874 863888	высшее	5885
Гостомысл	Савина	\N	8 350 735 20 41	3673 596377	высшее	5886
Николай	Фролов	\N	+7 (621) 060-06-98	6819 219387	\N	5887
Степан	Пахомова	Виленович	+73144436806	4979 483964	среднее профессиональное	5888
Владилен	Шашкова	Никифоровна	8 370 057 10 88	7093 829329	среднее	5889
Павел	Котова	\N	84701180292	4687 523612	высшее	5890
Фёкла	Сидоров	Эдгарович	+7 (583) 641-6054	3074 734635	среднее профессиональное	5891
Амос	Комиссаров	\N	8 488 861 37 88	1377 645558	\N	5892
Бажен	Воронов	\N	8 880 856 6812	2968 325644	высшее	5893
Софон	Фокин	Игнатьевич	+70297011268	7219 209591	среднее профессиональное	5894
Герасим	Наумова	\N	+7 (512) 807-05-01	7747 607342	среднее	5895
Венедикт	Мухина	\N	+7 (783) 849-5003	6632 635809	\N	5896
Вероника	Филиппов	Робертовна	+7 384 857 19 72	4074 448710	среднее	5897
Руслан	Петров	\N	+7 (534) 243-1782	4166 466802	среднее профессиональное	5898
Алевтина	Вишнякова	\N	+7 (255) 065-43-99	3125 389419	неоконченное высшее	5899
Ульяна	Кудрявцев	\N	8 940 286 2347	3373 540989	среднее	5900
Александра	Карпова	\N	+7 116 550 57 62	3044 310867	\N	6025
Аверкий	Комиссаров	\N	+7 (867) 013-7976	5578 264762	среднее профессиональное	5901
Устин	Якушев	\N	85969082557	3015 558300	среднее профессиональное	5902
Евлампий	Сазонов	Анатольевна	+7 (693) 917-14-58	1486 646205	среднее	5903
Симон	Бурова	Еремеевич	8 888 208 75 63	6641 463506	среднее	5904
Остап	Никонова	\N	+75656777463	9518 961077	среднее	5905
Ерофей	Ефремов	Яковлевна	+7 150 235 78 10	3667 840574	среднее	5906
Анисим	Панова	Абрамович	8 348 091 80 96	6812 518716	\N	5907
Светлана	Фомичева	\N	+73081830524	5961 658847	\N	5908
Артемий	Лыткин	\N	8 (437) 169-40-42	8951 595298	среднее	5909
Остап	Сорокина	Антипович	+7 529 225 5384	5750 820714	неоконченное высшее	5910
Ростислав	Кабанов	\N	+7 (461) 957-87-10	1539 940511	\N	5911
Тихон	Самойлов	Егоровна	+7 390 745 08 39	8353 857246	\N	5912
Бажен	Логинова	Брониславович	8 (145) 530-33-21	6008 616058	неоконченное высшее	5913
Владилен	Цветкова	Ефстафьевич	+7 (817) 924-5515	9821 525747	среднее профессиональное	5914
Корнил	Быков	Петровна	+7 (260) 006-29-81	1318 219232	\N	5915
Арсений	Овчинникова	\N	+7 814 486 1437	2819 373529	среднее	5916
Авксентий	Ширяева	Робертовна	8 796 254 1490	6011 236032	высшее	5917
Стоян	Киселев	Никифоровна	+7 708 609 30 61	1465 236639	среднее профессиональное	5918
Никанор	Носов	Всеволодович	8 (013) 081-09-01	7645 359611	неоконченное высшее	5919
Семен	Филиппова	Афанасьевич	+7 (705) 831-8096	7550 190795	\N	5920
Ферапонт	Суханов	\N	8 792 647 8237	3986 535667	среднее	5921
Гедеон	Зиновьева	\N	8 (101) 885-57-44	7574 978823	неоконченное высшее	5922
Осип	Исаков	\N	80852087314	8595 245102	среднее	5923
Ананий	Архипов	Сергеевна	+7 390 948 00 87	9317 636245	среднее профессиональное	5924
Артем	Кудрявцева	Антипович	+7 586 602 15 42	4133 429990	высшее	5925
Антонин	Калинин	\N	8 (434) 774-37-19	8343 354699	среднее профессиональное	5926
Валентин	Комиссарова	\N	8 (114) 448-80-47	8911 700107	среднее профессиональное	5927
Аскольд	Ефремов	Филимонович	+7 256 985 37 96	3269 530186	среднее	5928
Эрнест	Романов	Егорович	+7 (623) 575-34-40	4909 569884	\N	5929
Владимир	Ширяев	Вячеславович	85026917812	8272 874037	высшее	5930
Ангелина	Прохорова	Тимуровна	8 (654) 487-42-68	8902 965390	высшее	5931
Эрнест	Михайлов	\N	8 913 070 7166	4233 442857	высшее	5932
Автоном	Кириллов	\N	+7 (353) 560-74-49	5269 634154	среднее	5933
Серафим	Соколов	Святославовна	+7 524 699 3123	6441 181675	неоконченное высшее	5934
София	Киселева	Гаврилович	8 (973) 608-0645	1109 697721	неоконченное высшее	5935
Елизавета	Антонова	\N	+7 (979) 139-6074	2950 300470	среднее	5936
Аггей	Мясников	Константиновна	8 (371) 042-86-53	9940 943354	неоконченное высшее	5937
Валерий	Зайцева	\N	8 401 102 2524	8668 463778	неоконченное высшее	5938
Наум	Колесников	Михайловна	+7 (063) 897-35-24	6851 647834	среднее	5939
Иннокентий	Жукова	\N	8 (056) 122-15-19	5856 789713	высшее	5940
Анжела	Лихачев	Артурович	8 563 672 85 81	4215 915106	неоконченное высшее	5941
Жанна	Самойлова	\N	8 752 783 2236	6768 218822	\N	5942
Любосмысл	Журавлева	Робертовна	8 (070) 641-90-37	6484 322245	среднее профессиональное	5943
Станислав	Зыкова	\N	+7 (694) 890-77-24	3311 258042	среднее	5944
Венедикт	Дорофеев	Валерианович	8 (933) 062-6674	7071 666996	среднее профессиональное	5945
Прасковья	Лапина	Венедиктович	8 276 434 28 21	6531 769007	высшее	5946
Софон	Сафонова	Игнатович	82063994339	5285 212729	среднее профессиональное	5947
Милен	Ширяева	Борисович	8 274 138 14 53	1798 790950	высшее	5948
Леонид	Васильева	Ермолаевич	87525587916	5144 385540	высшее	5949
Гостомысл	Блохин	\N	+7 530 802 36 69	6090 203809	высшее	5950
Агата	Костин	\N	8 (486) 706-2126	3288 144861	\N	5951
Михаил	Андреева	Матвеевич	+7 (251) 863-57-18	7538 362612	высшее	5952
Влас	Ефимов	\N	+7 (836) 273-4209	2051 541993	\N	5953
Ульян	Фомина	\N	8 (707) 747-3902	1074 450878	\N	5954
Леонтий	Савельев	Чеславович	+7 (504) 682-2464	1489 502116	среднее профессиональное	5955
Измаил	Сазонов	Демьянович	+7 (579) 888-54-03	5686 827039	среднее	5956
Кирилл	Котова	\N	8 (522) 126-6387	4784 133574	неоконченное высшее	5957
Христофор	Блохин	Владиславович	8 046 984 7382	3021 791842	среднее	5958
Парамон	Воробьева	\N	8 163 977 0954	7747 779011	высшее	5959
Эммануил	Марков	\N	8 228 477 11 58	7724 888508	высшее	5960
Глеб	Коновалова	\N	8 307 001 96 08	6667 485852	неоконченное высшее	5961
Нифонт	Горшкова	Антипович	+7 (950) 427-7203	9846 705111	среднее профессиональное	5963
Рюрик	Меркушева	\N	8 257 461 3812	3122 748513	среднее	5964
Флорентин	Маслова	\N	8 (227) 980-0230	9683 414286	среднее	5965
Лаврентий	Кузнецов	\N	8 (117) 252-58-07	6477 275595	среднее профессиональное	5966
Алла	Тетерина	Юрьевна	8 (396) 091-05-22	1450 819990	неоконченное высшее	5967
Прокл	Чернова	\N	+7 (285) 420-41-77	2668 778612	неоконченное высшее	5968
Богдан	Попова	\N	8 695 989 72 99	8703 336636	среднее профессиональное	5969
Ювеналий	Веселова	Артемовна	84767571318	8809 759892	среднее профессиональное	5970
Потап	Горшков	Захаровна	81057497188	4025 738824	среднее профессиональное	5971
Велимир	Дьячков	Валерианович	8 (736) 651-9145	7166 990284	неоконченное высшее	5972
Маргарита	Копылов	Антипович	8 802 083 49 06	6104 330925	\N	5973
Мирослав	Беспалова	\N	+7 431 785 8115	2028 121294	среднее	5974
Селиверст	Медведев	\N	8 008 854 7839	2507 652466	среднее	5975
Лидия	Беспалов	\N	8 (830) 880-53-68	9054 509303	среднее профессиональное	5976
Савватий	Дьячков	Аркадьевна	+7 (799) 222-7581	5717 254943	среднее профессиональное	5977
Ираклий	Шарова	\N	+77879677113	5215 922446	среднее профессиональное	5978
Мартын	Лихачев	Борисовна	+7 132 180 80 14	8527 393978	среднее	5979
Никифор	Князев	\N	+73243752165	1268 282893	неоконченное высшее	5980
Авдей	Галкина	Ефимович	+7 362 648 34 13	4281 266145	неоконченное высшее	5981
Азарий	Самсонова	\N	+7 (663) 206-11-01	3040 389563	среднее	5982
Лукьян	Прохоров	Аверьянович	8 728 179 42 26	3286 364081	неоконченное высшее	5983
Будимир	Поляков	\N	+72871439181	4311 113873	среднее	5984
Радим	Молчанов	\N	8 (288) 618-62-94	6135 733980	среднее	5985
Феофан	Крюков	\N	+7 (209) 888-8099	5734 577151	среднее	5986
Вацлав	Соболева	Робертовна	+70001734075	8609 928192	неоконченное высшее	5987
Август	Кузьмина	Бенедиктович	+71406804251	5974 862132	среднее профессиональное	5988
Илья	Воронова	Владимировна	+7 432 682 8412	6381 753449	среднее профессиональное	5989
Филарет	Ширяева	\N	+7 (180) 759-9388	7919 681076	\N	5990
Глафира	Козлов	Феоктистович	8 695 029 8377	4441 667951	\N	5991
Фока	Фролова	\N	87243020808	8687 850601	неоконченное высшее	5992
Еремей	Константинова	\N	80302965198	9289 180638	неоконченное высшее	5993
Мир	Савельев	Львовна	8 809 675 50 77	2184 988661	среднее профессиональное	5994
Натан	Шубин	\N	+7 (061) 504-6255	7429 793566	\N	5995
Карл	Соловьева	\N	+7 560 765 14 19	8898 535102	неоконченное высшее	5996
Александр	Ефимова	Антонович	+7 070 432 6083	3807 907270	неоконченное высшее	5997
Прасковья	Беляева	Ануфриевич	8 449 013 36 98	5849 460563	среднее профессиональное	5998
Феликс	Баранов	\N	8 706 279 1044	6319 200767	среднее профессиональное	5999
Азарий	Фомичев	\N	80955613506	7339 354819	среднее	6000
Зинаида	Рябов	\N	87959898799	4486 457761	среднее профессиональное	6001
Боян	Тихонова	\N	+78810420351	3927 523328	среднее	6002
Агафья	Шарова	Аверьянович	+7 411 959 26 98	8087 979749	среднее профессиональное	6003
Никита	Наумов	Германович	+7 (201) 519-0054	5813 781833	высшее	6004
Мир	Панфилов	Иосипович	+72971154424	4949 881159	\N	6005
Авдей	Рябов	\N	+7 667 683 28 80	8245 596390	высшее	6006
Захар	Карпова	\N	+7 (754) 545-96-71	3550 130181	среднее	6007
Ираида	Копылов	\N	8 886 776 6597	4639 439432	\N	6008
Творимир	Самсонова	\N	+70529343090	8402 110123	\N	6009
Мир	Маслова	\N	82763836912	1549 480532	среднее	6010
Евлампий	Кондратьев	Устинович	88496285759	7030 385250	среднее профессиональное	6011
Фадей	Комаров	\N	+7 (680) 280-9627	6949 808970	\N	6012
Доброслав	Королев	Аркадьевна	8 193 245 7120	2511 948477	\N	6013
Нестор	Игнатов	\N	+7 (702) 264-4807	9072 675254	\N	6014
Леонид	Субботин	\N	+7 032 947 88 60	7627 154348	высшее	6015
Зоя	Кабанова	\N	8 202 500 88 78	6357 903697	среднее профессиональное	6016
Викторин	Фомичев	Ефимьевич	+7 132 766 6107	9215 825193	неоконченное высшее	6017
Емельян	Куликова	Эдгарович	8 786 048 98 53	4284 985434	среднее профессиональное	6018
Алла	Сафонова	\N	+7 876 460 78 86	2424 604167	\N	6019
Леон	Гурьева	\N	8 (709) 483-1292	5048 944923	среднее	6020
Добромысл	Андреев	\N	8 270 778 65 92	5801 367896	\N	6021
Борислав	Виноградова	\N	8 392 428 25 87	3046 968938	неоконченное высшее	6022
Остап	Афанасьева	Вадимовна	+74337816384	5277 214820	\N	6023
Наталья	Шашкова	Филатович	87787083651	5167 744919	высшее	6024
Лидия	Исаков	Львовна	+7 (780) 890-39-51	3552 849191	\N	6026
Мария	Дроздова	Антонович	+7 (493) 189-6758	5779 780158	\N	6027
Константин	Ситникова	Геннадьевна	8 (763) 574-5185	8034 566829	высшее	6028
Адриан	Юдин	Ильич	+7 732 492 9736	1130 105951	среднее профессиональное	6029
Спартак	Богданов	Матвеевна	+7 (100) 782-5294	8178 215954	неоконченное высшее	6030
Бронислав	Дорофеев	Дорофеевич	8 (670) 812-5233	6323 201522	среднее профессиональное	6031
Осип	Игнатьев	\N	8 670 011 52 42	9788 583139	высшее	6032
Елена	Галкина	Васильевич	8 (500) 524-52-34	2489 373235	\N	6033
Карл	Бурова	Валентиновна	8 586 488 3072	4808 134233	\N	6034
София	Комиссаров	\N	82357442835	1342 575934	среднее	6035
Герман	Колесникова	\N	8 (625) 144-5874	8996 942680	среднее	6036
Лукьян	Якушев	Григорьевна	+7 560 991 95 14	2142 203580	\N	6037
Фадей	Харитонов	\N	8 (947) 631-5362	7509 938032	неоконченное высшее	6038
Нина	Захарова	\N	+7 (558) 529-5743	2585 673510	\N	6039
Ипат	Поляков	\N	+7 (345) 982-0112	9377 652810	среднее профессиональное	6040
Никанор	Жданова	\N	81916119001	9017 709989	среднее профессиональное	6041
Бажен	Третьяков	Кирилловна	8 (758) 337-3439	7282 461027	\N	6042
Ким	Прохорова	Харитонович	+7 085 569 1671	4920 349244	неоконченное высшее	6043
Валентина	Блинов	Викторович	8 (781) 689-81-83	6140 998792	\N	6044
Тарас	Киселева	Ильясович	+7 (613) 470-20-89	2297 130272	неоконченное высшее	6045
Станимир	Осипов	\N	8 (057) 718-42-80	1090 103856	среднее	6046
Фёкла	Кулагин	\N	+79241509673	2780 468878	среднее профессиональное	6047
Мечислав	Никифоров	Максимовна	+7 (596) 319-06-85	8072 226261	среднее профессиональное	6048
Феофан	Сазонов	Егоровна	+7 (838) 391-5482	6156 304936	\N	6049
Кира	Алексеев	Валериевна	8 (158) 498-82-30	1743 202959	\N	6050
Степан	Брагина	Богдановна	8 396 165 6717	2511 130141	\N	6051
Ульяна	Павлова	\N	8 (769) 681-21-73	9725 607141	\N	6052
Фока	Антонова	Владимировна	+7 591 168 7838	1283 364780	среднее профессиональное	6053
Зиновий	Лазарев	Феодосьевич	8 (573) 111-25-66	2222 206134	среднее профессиональное	6054
Вацлав	Куликов	\N	8 (523) 225-9766	9875 980019	среднее	6055
Лора	Бурова	Арсенович	+7 (365) 241-3924	4236 348507	среднее	6056
Юлия	Пономарев	Ефимьевич	+7 (851) 409-45-47	3050 921653	среднее профессиональное	6057
Стоян	Терентьев	\N	+7 (479) 826-0086	9157 432643	среднее профессиональное	6058
Борислав	Никитина	Харлампович	+7 843 631 3826	1383 407217	среднее	6059
Исидор	Белова	Владимировна	8 828 673 81 53	6023 486413	среднее профессиональное	6060
Епифан	Суворова	Аверьянович	+7 (345) 816-90-16	7970 514671	высшее	6061
Федор	Мартынова	Матвеевна	8 691 101 17 82	5572 428369	среднее профессиональное	6062
Еремей	Кошелева	\N	+76491703100	5272 656059	неоконченное высшее	6063
Феоктист	Волкова	Харламович	8 (535) 236-52-05	2905 505324	высшее	6064
Куприян	Кошелева	\N	+7 092 713 98 82	1649 844637	среднее профессиональное	6065
Викторин	Полякова	\N	8 539 469 36 31	8711 483985	высшее	6066
Ферапонт	Якушева	Мироновна	8 (130) 984-0559	4641 213381	среднее профессиональное	6067
Модест	Сафонова	\N	+71013274697	7899 109342	\N	6068
Сергей	Дмитриев	\N	+7 728 960 0116	6054 421262	\N	6069
Агата	Никифоров	Архипович	+77647063798	7310 387682	высшее	6070
Игорь	Большакова	Васильевич	+7 968 716 4686	6552 283586	\N	6071
Надежда	Шарапов	\N	8 943 267 06 11	6402 659484	неоконченное высшее	6072
Владимир	Терентьева	\N	+7 142 012 1839	5992 245268	\N	6073
Агап	Давыдов	\N	+75068810997	2803 541148	высшее	6074
Конон	Чернова	\N	8 (175) 919-75-68	6682 988970	неоконченное высшее	6075
Максимильян	Семенов	Тимофеевна	8 234 071 32 75	6933 537190	высшее	6076
Митофан	Игнатьев	Федоровна	8 (172) 013-68-77	8307 861461	\N	6077
Ананий	Моисеева	\N	8 (880) 570-1837	3196 588523	среднее	6078
Твердислав	Герасимов	Иосифович	82603726908	6474 534288	неоконченное высшее	6079
Азарий	Афанасьев	Тарасовна	81112700692	2674 186954	высшее	6080
Федосий	Рыбаков	Юлианович	+7 (130) 218-50-53	4247 702129	неоконченное высшее	6081
Карп	Кудряшов	Измаилович	+7 500 961 5222	7804 555894	среднее	6082
Фёкла	Павлова	\N	8 818 499 16 14	4698 273206	среднее	6083
Феоктист	Денисов	Фокич	8 (386) 380-79-82	9447 760865	высшее	6084
Никандр	Комиссаров	\N	8 (320) 060-4887	2051 197006	среднее	6085
Лариса	Тихонова	\N	+7 (034) 101-42-12	7485 111080	высшее	6086
Оксана	Баранова	Рудольфовна	8 (861) 704-0280	4025 623190	неоконченное высшее	6087
Зосима	Симонов	\N	+7 956 076 33 39	9914 558919	среднее	6088
Ефрем	Русакова	Ильинична	+7 850 137 63 41	2474 621532	высшее	6089
Гурий	Мясникова	Тимофеевна	8 (765) 909-2191	7389 399738	среднее	6090
Аполлинарий	Кузнецов	Викентьевич	+74467269877	1163 624478	\N	6091
Пахом	Гаврилова	Феоктистович	8 (129) 120-1048	3992 590639	высшее	6092
Агафон	Назаров	Владленович	86120520113	8896 186339	\N	6093
Иван	Полякова	Фролович	+73105228909	8196 448987	среднее профессиональное	6094
Евграф	Гурьев	\N	+70112965034	3248 294795	среднее профессиональное	6095
Ферапонт	Исаева	\N	8 732 028 88 29	1821 251462	неоконченное высшее	6096
Сила	Агафонова	\N	+70679665978	3911 328119	неоконченное высшее	6097
Ираклий	Гурьева	Львовна	+7 (126) 658-9942	1992 483626	неоконченное высшее	6098
Куприян	Костина	Геннадьевна	8 (987) 688-15-24	3557 474727	\N	6099
Дмитрий	Жданова	Адрианович	8 (286) 979-4292	7539 263813	высшее	6100
Панкратий	Котов	\N	+7 638 939 32 11	6751 240532	\N	6101
Ерофей	Гаврилов	\N	+7 391 331 5798	9506 372202	высшее	6102
Еремей	Крылова	\N	+7 090 436 32 32	6957 270178	\N	6103
Платон	Крылова	\N	+7 (405) 302-9055	8022 682154	\N	6104
Анисим	Федорова	Станиславовна	+7 (084) 307-6489	3173 613291	среднее профессиональное	6105
Григорий	Костин	\N	8 575 388 2759	6599 440241	высшее	6106
Бронислав	Калинина	\N	8 613 182 64 00	7524 547580	неоконченное высшее	6107
Аникита	Князева	Юльевна	+7 459 152 11 73	1421 575927	высшее	6108
Григорий	Красильников	Валерианович	8 659 946 04 27	6421 409190	высшее	6109
Майя	Костин	\N	+7 253 731 4384	9701 573722	неоконченное высшее	6110
Артем	Лыткин	\N	+7 (852) 185-07-75	2935 703935	среднее профессиональное	6111
Валерий	Суханов	\N	+7 770 455 0864	8449 387894	\N	6112
Аникита	Фролов	Елисеевич	+7 216 680 86 16	2791 213682	\N	6113
Викентий	Сазонова	Тарасович	+7 (400) 776-9844	4571 456815	\N	6114
Аскольд	Зуев	\N	8 062 242 74 30	1407 988862	среднее	6115
Ким	Сидоров	\N	8 813 201 38 61	1437 915883	\N	6116
Станимир	Мартынова	Григорьевич	87843023762	7094 935100	неоконченное высшее	6117
Кондрат	Назарова	\N	8 (632) 917-08-20	1622 495348	неоконченное высшее	6118
Исай	Аксенов	Аскольдовна	8 (465) 127-7410	3154 120719	неоконченное высшее	6119
Аверкий	Потапова	\N	+7 (863) 085-23-13	9479 190816	\N	6120
Ювеналий	Уварова	Ааронович	+7 912 261 55 66	9180 916210	среднее	6121
Алексей	Фомин	\N	+76696861068	1974 168488	\N	6122
Евлампий	Уварова	\N	+7 (148) 742-0884	4833 829995	среднее профессиональное	6123
Никон	Уварова	Руслановна	8 (615) 042-48-02	8500 959572	неоконченное высшее	6124
Владислав	Кулаков	\N	86669240080	8570 869942	среднее	6125
Агап	Лаврентьев	Иларионович	+74280448123	1195 810797	среднее	6126
Емельян	Ширяева	\N	8 622 532 1959	8719 114431	среднее	6127
Куприян	Кулагина	\N	+77967544051	1946 659097	среднее	6128
Тит	Горбачев	\N	+7 188 153 8298	3477 894627	среднее	6129
Ипатий	Антонов	\N	8 (927) 633-6954	3814 247035	неоконченное высшее	6130
Ратмир	Петухова	Дорофеевич	+7 (247) 963-18-84	2246 935070	среднее	6131
Нонна	Лобанова	Аскольдовна	+75430813268	1358 491387	\N	6132
Ульяна	Борисов	\N	8 (017) 741-7722	5067 503240	неоконченное высшее	6133
Авксентий	Овчинникова	\N	8 413 394 8212	8176 377624	высшее	6134
Юлий	Рогова	Вячеславовна	+7 (944) 251-17-56	2943 610409	неоконченное высшее	6135
Давыд	Кулаков	\N	+7 (668) 821-4229	2773 341169	неоконченное высшее	6136
Лазарь	Ковалев	\N	+7 232 796 48 49	3450 994389	\N	6137
Нинель	Александров	\N	8 348 991 1176	2823 519056	высшее	6138
Федот	Михайлов	Валентиновна	8 (187) 030-6155	9391 901936	\N	6139
Никандр	Рожкова	\N	+7 710 723 55 45	1702 390744	среднее профессиональное	6140
Силантий	Кузьмина	\N	8 726 428 14 79	3780 398130	\N	6141
Андрон	Третьякова	\N	+7 316 780 7939	8437 529247	\N	6142
Лонгин	Беспалов	Антонович	+7 (071) 011-07-71	1061 205860	\N	6143
Зоя	Щукина	Августович	8 (773) 501-1965	6489 429142	высшее	6144
Максим	Петухов	Викторовна	8 675 499 8425	2574 174089	\N	6145
Фома	Петухов	\N	8 (401) 685-3054	6484 817739	высшее	6146
Спиридон	Ковалев	\N	+7 144 630 2196	2712 104794	\N	6147
Алевтина	Зимина	Игнатович	8 637 368 50 72	9219 627624	\N	6148
Спиридон	Белова	\N	+7 (645) 231-0659	9390 768551	среднее профессиональное	6149
Аркадий	Ларионова	Афанасьевна	+7 974 134 2284	3697 358569	неоконченное высшее	6150
Иосиф	Беспалов	\N	8 962 777 5171	7382 667096	неоконченное высшее	6151
Виссарион	Красильников	\N	+7 155 977 2877	1436 499559	высшее	6215
Милий	Титов	\N	8 668 552 4148	5734 252296	среднее профессиональное	6152
Леонтий	Фомин	\N	8 (530) 559-4914	9632 790986	среднее профессиональное	6153
Гедеон	Ширяева	Руслановна	88992940121	3962 648114	высшее	6154
Адам	Лобанова	\N	8 401 446 8227	2844 555249	\N	6155
Анна	Капустин	Ануфриевич	8 901 377 7621	1071 990995	\N	6156
Лукьян	Журавлева	Павловна	8 322 005 2180	3630 246621	\N	6157
Герман	Медведев	\N	+7 (741) 768-5734	2712 810837	среднее	6158
Василий	Соколова	\N	82908222128	3045 825886	среднее	6159
Олимпиада	Гаврилов	\N	8 (174) 141-9632	6617 548211	среднее	6160
Прасковья	Носова	Антипович	+7 001 586 9964	2618 140505	неоконченное высшее	6161
Анжелика	Павлова	\N	8 171 862 12 38	1092 561929	высшее	6162
Влас	Елисеева	\N	84832254463	9056 825515	среднее	6163
Тамара	Кононов	Вадимовна	89524228447	1351 375384	неоконченное высшее	6164
Валерий	Сафонов	Ниловна	+79649261663	1371 563563	\N	6165
Семен	Фадеев	\N	8 422 696 8398	5838 423348	неоконченное высшее	6166
Гаврила	Филиппова	Игнатьевич	8 331 258 43 59	8907 445473	\N	6167
Адам	Одинцова	\N	+74986401263	5061 414598	\N	6168
Мстислав	Кабанов	\N	8 168 419 96 99	4992 981402	среднее профессиональное	6169
Иларион	Шестаков	Ермолаевич	8 (315) 052-2433	5673 470442	высшее	6170
Владлен	Прохорова	\N	8 206 311 5056	7160 410555	среднее профессиональное	6171
Фотий	Суворов	Фролович	8 (940) 056-65-38	8446 958177	среднее профессиональное	6172
Добромысл	Александров	\N	8 626 569 8982	4025 553092	среднее	6173
Эмилия	Сафонов	Валериевна	8 (616) 491-20-52	6076 740842	\N	6174
Иларион	Прохоров	Иосипович	+75937303420	1431 978618	неоконченное высшее	6175
Бронислав	Герасимов	Аверьянович	+7 (053) 153-7800	1832 407380	среднее профессиональное	6176
Валерьян	Котова	Фомич	+7 (084) 918-58-99	6151 887516	среднее	6177
Фирс	Кузнецов	\N	+76191341326	8133 888395	неоконченное высшее	6178
Екатерина	Колесникова	Аксёнович	8 (877) 463-01-91	3931 875243	среднее профессиональное	6179
Евсей	Сидорова	\N	+7 518 543 8265	7249 171475	среднее	6180
Лидия	Васильева	\N	88844037953	1214 346619	\N	6181
Корнил	Шестакова	\N	8 (319) 213-37-63	9725 178076	высшее	6182
Сергей	Савин	\N	+7 (403) 134-45-07	8814 808135	\N	6183
Вероника	Ефремова	\N	8 (198) 998-5078	6261 273668	среднее	6184
Олимпиада	Герасимова	Димитриевич	+7 (753) 397-5236	3823 525255	высшее	6185
Панфил	Кудрявцева	Михайловна	+7 006 901 76 20	1103 648981	среднее профессиональное	6186
Ипполит	Николаев	Феликсович	+7 (697) 452-1414	2134 300687	высшее	6187
Ратибор	Белозерова	\N	+71263850567	8530 224039	среднее профессиональное	6188
Егор	Артемьева	\N	+7 555 247 1042	9089 429340	\N	6189
Ефим	Исакова	Ефремович	+7 015 152 74 36	8781 365090	\N	6190
Жанна	Калашников	Георгиевна	+7 428 825 95 48	1783 765798	\N	6191
Модест	Кулагина	\N	+7 (216) 708-7556	9892 889841	высшее	6192
Лавр	Кириллова	\N	8 (792) 472-79-24	7564 656447	неоконченное высшее	6193
Мефодий	Одинцов	Власович	8 (762) 439-53-19	6012 455315	среднее профессиональное	6194
Изот	Брагина	\N	8 (555) 566-8498	9268 814619	среднее профессиональное	6195
Олег	Яковлева	\N	+7 381 186 8313	9498 606824	\N	6196
Алла	Уваров	Владиленович	+7 (716) 956-76-42	5067 300848	среднее	6197
Клавдия	Белов	Леонидовна	8 (795) 650-93-11	1242 724068	среднее профессиональное	6198
Аникита	Лапин	Иларионович	+7 (204) 602-5128	2130 897276	\N	6199
Елизавета	Субботин	\N	8 (187) 034-3963	4938 791109	неоконченное высшее	6200
Лев	Гущин	\N	+7 (102) 665-33-10	4379 706627	среднее	6201
Зиновий	Маслов	Авдеевич	+73831814999	1029 306509	среднее профессиональное	6202
Александр	Баранов	Устинович	80706477986	5586 612433	среднее	6203
Капитон	Дорофеев	\N	+7 576 783 1675	2799 931709	неоконченное высшее	6204
Святослав	Смирнова	Григорьевич	+7 (171) 772-01-56	3208 794794	среднее	6205
Климент	Степанов	Ермолаевич	8 289 847 70 18	8687 396239	высшее	6206
Лонгин	Крюков	\N	+7 (670) 637-3028	8476 746857	высшее	6207
Эрнст	Зиновьева	Григорьевна	+7 035 357 62 85	7783 298100	среднее	6208
Сильвестр	Пахомова	\N	8 152 155 6232	3869 467300	высшее	6209
Поликарп	Гришин	Анатольевна	+7 (696) 650-85-56	5823 198589	среднее профессиональное	6210
Лукия	Назарова	\N	+7 068 701 6541	1060 365784	среднее	6211
Болеслав	Лукина	\N	83288407178	6560 150480	\N	6212
Любосмысл	Субботин	\N	8 (748) 858-1525	3278 131239	неоконченное высшее	6213
Богдан	Фролова	Александрович	87081857063	6255 766968	среднее	6214
Самуил	Одинцов	Ниловна	8 341 054 1863	5752 343807	среднее	6218
София	Денисова	\N	8 753 748 92 11	5341 829405	\N	6219
Наталья	Павлова	\N	+7 (327) 762-7325	2903 651124	среднее	6220
Творимир	Русаков	\N	+7 426 111 14 91	2022 217320	неоконченное высшее	6221
Евдоким	Кузнецов	\N	+7 (154) 420-08-47	8670 573162	среднее профессиональное	6222
Галактион	Рогов	Гаврилович	8 (573) 663-09-26	4679 457179	неоконченное высшее	6223
Захар	Прохорова	Игнатьевич	+7 831 898 71 50	3155 396295	неоконченное высшее	6224
Карл	Соловьев	\N	+7 137 931 7294	4719 205517	\N	6225
Синклитикия	Белозеров	Ермилович	+7 (375) 752-2806	2039 244953	высшее	6226
Архип	Хохлова	\N	+7 (874) 133-3342	9467 657545	неоконченное высшее	6227
Фёкла	Тихонов	\N	8 (603) 349-63-37	1262 719325	неоконченное высшее	6228
Никифор	Носова	\N	88455745360	9836 337258	\N	6229
Амос	Волкова	Валерианович	+7 380 850 3511	6666 815236	среднее профессиональное	6230
Лев	Попова	\N	8 239 734 0894	3458 925357	высшее	6231
Кузьма	Лебедева	Иосифович	8 (096) 578-47-94	4903 933001	неоконченное высшее	6232
Клавдия	Ильин	Ермилович	+74480756402	7224 581945	среднее профессиональное	6233
Наина	Некрасов	\N	+7 972 605 5910	5600 525311	среднее профессиональное	6234
Эраст	Макарова	Валерианович	+7 (296) 519-4676	3361 500793	неоконченное высшее	6235
Яков	Русакова	Виленович	+7 851 502 9643	9569 123288	среднее профессиональное	6236
Иван	Голубева	\N	8 (942) 117-49-64	4085 299866	неоконченное высшее	6237
Всеволод	Павлова	\N	+7 (710) 270-5204	7502 787307	среднее профессиональное	6238
Вацлав	Федосеев	\N	+7 973 096 4736	3006 452337	высшее	6239
Яков	Фомичев	\N	+7 652 983 10 21	9170 541724	среднее профессиональное	6240
Пимен	Воронова	\N	8 881 294 9739	6870 235271	неоконченное высшее	6241
Елена	Воронцов	\N	8 734 493 24 61	9351 443457	неоконченное высшее	6242
Август	Самсонова	Бориславович	8 124 091 0197	7036 713029	\N	6243
Моисей	Гришин	Михайловна	+7 (507) 201-9108	1014 897804	неоконченное высшее	6244
Андрон	Белова	\N	+73408103961	1278 803515	\N	6245
Христофор	Архипова	Егорович	+7 (561) 500-7094	8046 940778	\N	6246
Юлиан	Ларионова	\N	8 (970) 211-2717	8941 270358	высшее	6247
Валентин	Лобанова	Ермолаевич	8 (072) 851-37-90	6773 836460	среднее	6248
Поликарп	Дорофеева	Зиновьевич	8 (911) 347-7151	2513 187822	среднее	6249
Кондрат	Горбачев	Георгиевна	+73197869948	4197 821202	среднее	6250
Гурий	Сафонова	\N	8 (498) 858-5834	4078 551526	\N	6251
Лев	Носкова	\N	8 (603) 453-87-01	5982 921531	среднее	6252
Авдей	Буров	Захаровна	8 810 137 22 83	8749 448556	среднее	6253
Евгений	Чернова	\N	81124022023	2505 138649	\N	6254
Михаил	Евдокимова	\N	8 (887) 848-87-79	6598 827593	\N	6255
Мирослав	Пахомов	Альбертовна	8 392 366 3438	2586 551867	среднее профессиональное	6256
Исидор	Макарова	\N	+7 (986) 647-90-56	2581 765154	\N	6257
Родион	Тетерина	\N	8 (228) 220-76-19	8171 456791	\N	6258
Ольга	Суханов	Денисович	8 204 640 66 73	7617 589335	среднее	6259
Ладислав	Абрамов	\N	+7 (659) 906-2110	1805 247591	среднее	6260
Милован	Одинцова	\N	8 014 561 74 63	3931 747970	неоконченное высшее	6261
Ферапонт	Голубев	Артурович	+7 233 462 27 13	8129 422599	среднее	6262
Синклитикия	Андреев	\N	8 (788) 693-61-92	5015 184680	\N	6263
Якуб	Семенов	\N	8 329 639 0524	2002 490376	\N	6264
Марк	Тарасова	\N	8 022 233 71 53	8447 782757	среднее	6265
Феликс	Одинцов	Феоктистович	+7 638 708 6671	1198 301790	среднее	6266
Добромысл	Селезнева	\N	85909037280	5275 329152	неоконченное высшее	6267
Ладимир	Быков	\N	8 819 715 1783	3265 679802	среднее	6268
Вацлав	Маркова	Геннадиевич	8 (323) 407-96-00	5177 496746	среднее	6269
Гостомысл	Власова	\N	+7 (349) 661-2733	3362 621708	среднее профессиональное	6270
Мартын	Родионов	Алексеевич	+7 440 236 28 82	2124 746107	среднее профессиональное	6271
Марина	Макаров	Ильясович	+7 (493) 364-82-92	6766 641840	среднее профессиональное	6272
Аркадий	Одинцова	\N	8 (006) 261-9077	3549 178358	среднее профессиональное	6273
Федот	Третьякова	\N	87166195992	6756 130290	среднее профессиональное	6274
София	Богданов	Даниилович	+7 680 465 78 05	6544 544337	среднее	6275
Азарий	Сорокин	Богданович	+73711261992	3568 751605	неоконченное высшее	6276
Руслан	Константинова	\N	+75217746517	6707 674444	среднее	6277
Антип	Потапова	Данилович	8 135 155 1763	3834 455774	\N	6278
Чеслав	Тихонова	Вадимовна	+7 546 932 21 88	5569 184285	среднее	6279
Фаина	Анисимова	Юрьевна	8 (831) 073-34-79	8723 607430	среднее	6280
Елисей	Потапова	Григорьевна	8 061 343 9739	8470 256084	среднее профессиональное	6282
Вениамин	Красильников	Георгиевна	8 (161) 849-4925	7066 209201	высшее	6283
Елизавета	Мишина	\N	84421057411	3669 690338	\N	6284
Алина	Андреев	Николаевна	+73505704284	4641 659127	\N	6285
Ипат	Быкова	Эдуардович	+7 (974) 462-7397	9516 885338	среднее профессиональное	6286
Будимир	Кулакова	\N	+7 (420) 558-5007	6569 492959	неоконченное высшее	6287
Харитон	Лебедева	\N	+7 (287) 183-05-11	5799 366637	среднее	6288
Егор	Жуков	\N	+7 063 589 0830	9431 563317	\N	6289
Исай	Молчанов	Борисовна	8 (077) 204-50-99	6256 967513	среднее	6290
Ангелина	Лихачева	Августович	8 (605) 883-1873	6545 651562	высшее	6291
Поликарп	Николаев	\N	+77758484289	9149 953017	среднее	6292
Дмитрий	Абрамов	\N	8 (569) 827-2579	2266 761907	среднее профессиональное	6293
Егор	Копылов	Викторовна	83499043246	1029 283621	среднее профессиональное	6294
Порфирий	Титов	\N	8 131 762 4276	3353 433738	среднее профессиональное	6295
Ия	Степанов	Владимировна	+7 315 298 28 50	6019 292816	неоконченное высшее	6296
Элеонора	Лапин	\N	+7 (662) 303-78-07	8797 903777	\N	6297
Вячеслав	Панфилов	\N	+7 879 064 55 16	3888 141224	среднее	6298
Руслан	Ильин	\N	+7 (842) 137-62-21	7502 450584	\N	6299
Олимпиада	Пестов	Игоревич	85759944875	4350 236137	высшее	6300
Федот	Муравьев	Андреевич	+7 612 183 7854	8735 490474	среднее профессиональное	6301
Любим	Туров	\N	+74852757941	4217 940025	неоконченное высшее	6302
Ладислав	Назарова	Иларионович	85853110443	5961 815131	\N	6303
Мариан	Зуев	\N	+7 231 388 8652	3662 462638	\N	6304
Максимильян	Щукина	Евстигнеевич	8 (614) 095-87-43	6491 419475	\N	6305
Федосий	Колобов	Вилорович	89021794596	2797 297639	среднее	6306
Евдокия	Куликов	\N	8 (809) 512-71-55	5672 616106	высшее	6307
Ольга	Туров	Феликсовна	+7 736 740 28 37	9594 758764	\N	6308
Надежда	Кошелева	Дмитриевна	8 (900) 369-2096	5323 359158	среднее профессиональное	6309
Артемий	Рябова	\N	+7 317 109 9092	2295 525324	среднее	6310
Акулина	Орехов	Теймуразович	8 (349) 833-92-53	6143 516995	среднее	6311
Иларион	Горшков	\N	+7 576 681 71 88	1258 934266	\N	6312
Потап	Ситникова	Федотович	+7 420 164 5274	5690 233744	высшее	6313
Фома	Шилова	Харлампьевич	+7 579 750 9720	4114 295631	неоконченное высшее	6314
Евдокия	Одинцова	\N	8 290 659 55 62	6715 778358	высшее	6315
Влас	Бирюкова	\N	+7 840 752 84 74	9519 256622	\N	6316
Нестор	Коновалова	Валентинович	8 (037) 394-17-84	5746 823806	высшее	6317
Анжелика	Самойлова	\N	+7 (637) 307-97-18	4950 585257	\N	6318
Евфросиния	Степанова	Яковлевна	+74476585204	1211 704180	\N	6319
Антонин	Королева	Гурьевич	8 (082) 752-0162	2358 539875	\N	6320
Севастьян	Меркушева	Харлампьевич	+74827983536	9131 135404	среднее	6321
Вениамин	Ершова	\N	84760045581	1414 215619	среднее	6322
Ратибор	Зыкова	Павловна	8 (020) 508-37-84	5604 918135	среднее	6323
Нифонт	Комарова	\N	+7 (293) 488-7027	8198 196690	\N	6324
Федор	Суворов	Руслановна	+7 (399) 982-6652	7495 290468	\N	6325
Каллистрат	Никифоров	\N	8 (514) 177-84-93	6523 760345	среднее профессиональное	6326
Елизавета	Копылов	Теймуразович	+7 541 575 0834	1311 774347	среднее профессиональное	6327
Евгения	Богданова	\N	+7 (590) 335-8352	5496 368429	\N	6328
Силантий	Казакова	\N	+7 (798) 043-43-59	6930 350205	\N	6329
Гремислав	Журавлева	Тимурович	8 010 473 17 22	6413 666729	среднее профессиональное	6330
Евстигней	Григорьев	\N	+7 (650) 983-25-22	3955 705405	среднее	6331
Доброслав	Воронов	Аркадьевна	+7 (743) 037-82-49	1191 196970	\N	6332
Фрол	Баранов	\N	+7 (790) 615-49-25	2319 139282	\N	6333
Сильвестр	Федотова	\N	8 852 586 7225	9868 184534	\N	6334
Любомир	Воробьев	Давыдович	+7 (497) 887-45-11	1849 882916	неоконченное высшее	6335
Селиверст	Дорофеева	\N	+7 (499) 678-61-99	3969 628877	среднее	6336
Викентий	Суханов	Наумовна	8 706 371 01 54	5409 650075	неоконченное высшее	6337
Ипполит	Шарова	Валерьянович	+7 (222) 754-0193	8814 364940	среднее	6338
Прокл	Шашкова	\N	8 (914) 201-37-12	1787 981845	неоконченное высшее	6339
Прокл	Соболев	Исидорович	89811445539	8391 453581	высшее	6340
Иларион	Стрелкова	Феликсович	+72731432769	4584 966523	\N	6341
Трофим	Дмитриева	Феодосьевич	8 (314) 579-2694	4738 508407	высшее	6342
Вацлав	Егоров	\N	+7 699 640 83 07	2644 385568	среднее профессиональное	6343
Ювеналий	Новикова	Андреевич	8 (691) 398-7015	1994 380808	высшее	6344
Анисим	Егоров	Гурьевич	+7 (111) 746-71-79	5968 673984	\N	6532
Леонид	Кудрявцева	Аскольдовна	+7 806 613 4727	3981 399487	неоконченное высшее	6345
Епифан	Сергеев	Васильевна	8 599 631 70 51	3670 451342	среднее профессиональное	6346
Януарий	Назаров	\N	+7 (358) 790-8099	4874 780399	среднее	6347
Максим	Назарова	Захаровна	8 (304) 678-3349	4935 588940	неоконченное высшее	6348
Филимон	Щербакова	\N	8 (560) 069-0463	4540 333664	среднее профессиональное	6349
Ферапонт	Иванова	\N	+77540476798	4014 138015	среднее профессиональное	6350
Вышеслав	Михайлова	\N	89362444363	1349 318289	высшее	6351
Лука	Филатова	\N	8 303 424 35 15	1467 365769	высшее	6352
Анжелика	Лазарев	\N	+7 (285) 583-32-26	8184 659388	\N	6353
Тит	Елисеев	Федосеевич	8 (504) 902-54-19	3708 543851	высшее	6354
Ольга	Михеев	\N	+7 (499) 690-2686	2722 202980	неоконченное высшее	6355
Ираклий	Федорова	\N	+7 (088) 237-0656	8404 488119	среднее профессиональное	6356
Ферапонт	Пахомов	\N	8 (732) 442-0825	6090 554105	среднее	6357
Станимир	Лаврентьев	Максимовна	+7 156 062 4323	3922 565126	среднее	6358
Лазарь	Самсонов	\N	8 818 125 9524	9984 448092	среднее профессиональное	6359
Алина	Михайлов	Евстигнеевич	+70222612683	6258 996498	высшее	6360
Николай	Лазарева	Кузьминична	+7 (488) 270-67-08	3757 882223	среднее профессиональное	6361
Евгения	Лобанов	Алексеевна	8 (709) 847-34-12	1379 485216	неоконченное высшее	6362
Кир	Копылов	Евгеньевна	+7 508 485 6827	6178 464253	высшее	6363
Ким	Меркушева	\N	+7 486 807 09 41	6489 616527	\N	6364
Аркадий	Ефимов	\N	8 288 300 09 15	5541 424257	среднее	6365
Людмила	Белоусов	Геннадьевна	8 (283) 566-8781	4364 469017	неоконченное высшее	6366
Елизавета	Белоусова	\N	+79108061572	6884 910747	среднее профессиональное	6367
Авксентий	Фокина	\N	8 (585) 416-6075	5538 150304	среднее	6368
Лазарь	Ермакова	\N	+7 (652) 935-32-52	5720 165901	среднее	6369
Регина	Быкова	Борисович	+7 (771) 070-2471	3955 847382	\N	6370
Каллистрат	Нестерова	Харлампович	86100406273	5842 974988	среднее	6371
Лора	Федоров	Иосифович	8 407 616 25 77	2918 891072	высшее	6372
Мариан	Котова	Германович	8 933 137 40 81	4110 816016	неоконченное высшее	6373
Тарас	Михеев	\N	+7 522 279 4977	6206 959137	высшее	6374
Архип	Ситников	Афанасьевна	8 (786) 265-7459	7440 556803	среднее	6375
Селиверст	Гаврилова	Вячеславович	+7 (433) 580-32-27	9257 746604	\N	6376
Фортунат	Хохлова	\N	+7 184 783 9453	6226 814547	среднее	6377
Марина	Пахомова	\N	8 (405) 058-7786	4892 106299	среднее	6378
Николай	Ковалев	\N	8 059 444 9243	6427 643431	неоконченное высшее	6379
Фока	Пестова	\N	+7 (609) 764-8163	4795 450165	высшее	6380
Ананий	Носова	\N	+7 706 428 68 99	6374 995826	неоконченное высшее	6381
Моисей	Зимин	Афанасьевна	8 (160) 698-9398	6382 699537	высшее	6382
Венедикт	Никифоров	\N	8 (972) 024-81-93	7578 853944	неоконченное высшее	6383
Захар	Доронина	\N	8 972 604 2004	5523 892466	неоконченное высшее	6384
Ратибор	Горбунов	Ивановна	+7 (855) 881-61-00	1375 863538	\N	6385
Гордей	Гуляева	\N	8 844 974 97 58	5383 534337	среднее профессиональное	6386
Изот	Аксенова	\N	+7 306 026 5533	7144 138785	\N	6387
Олег	Боброва	\N	+7 850 012 61 01	4051 746384	высшее	6388
Мирон	Мясникова	\N	8 361 109 1646	2074 318175	высшее	6389
Маргарита	Боброва	\N	81976017943	9949 737253	среднее	6390
Лонгин	Шашков	Анатольевна	+78965737994	8725 479580	неоконченное высшее	6391
Роман	Мясников	\N	8 642 763 3193	5549 619688	среднее профессиональное	6392
Феоктист	Новиков	Владиславович	84099790680	2705 171047	неоконченное высшее	6393
Лариса	Михайлов	\N	+7 253 275 17 05	2171 829294	среднее	6394
Мстислав	Фомичева	\N	8 (516) 291-8748	4523 750222	высшее	6395
Святополк	Кулагина	Давидович	82588941918	4973 244448	среднее	6396
Филимон	Суворов	Бенедиктович	+7 123 359 0117	1312 238957	среднее	6397
Николай	Зимина	\N	8 985 684 1976	3438 313117	среднее профессиональное	6398
Фотий	Антонова	\N	+71615386861	9416 310751	среднее профессиональное	6399
Мир	Родионова	Егорович	8 (680) 919-2984	9575 651418	среднее	6400
Юлия	Филатова	Тарасовна	+7 496 246 0987	4004 780137	среднее профессиональное	6401
Артем	Меркушев	Феликсовна	+7 (707) 454-24-98	4754 138804	\N	6402
Моисей	Турова	\N	+7 (499) 630-7975	5676 512743	среднее	6403
Антонин	Бирюкова	Владиленович	8 669 845 3436	8096 810935	\N	6404
Светлана	Бирюкова	Арсеньевич	8 504 746 1193	9763 449348	среднее профессиональное	6405
Аполлон	Рябова	\N	8 (148) 405-96-10	1289 417801	\N	6406
Никита	Шашкова	\N	+7 (282) 394-9159	2916 186128	среднее профессиональное	6408
Ксения	Семенов	Бориславович	+7 (794) 961-5629	3568 222514	высшее	6409
Галина	Никонов	Тимуровна	8 512 826 74 35	9540 843103	среднее профессиональное	6410
Владлен	Мухина	\N	8 (638) 769-2304	6513 654227	неоконченное высшее	6411
Данила	Белоусова	Августович	8 231 038 92 60	4641 211258	среднее профессиональное	6412
Юрий	Тетерина	\N	88516317956	5026 550303	среднее	6413
Нифонт	Беспалов	Яковлевна	8 933 699 0569	7352 504616	неоконченное высшее	6414
Адриан	Самсонова	Архипович	+7 696 466 96 80	7304 829511	\N	6415
Савватий	Смирнов	\N	8 449 593 57 60	4668 187255	неоконченное высшее	6416
Порфирий	Матвеев	\N	8 256 238 93 74	3591 148056	высшее	6417
Панфил	Александров	\N	8 (857) 794-20-55	7125 323139	среднее профессиональное	6418
Нинель	Филатов	\N	+73098556762	7566 936484	неоконченное высшее	6419
Егор	Потапова	Германович	8 231 506 11 71	2956 583692	высшее	6420
Капитон	Мартынов	Гурьевич	81539330053	9190 608825	среднее профессиональное	6421
Аркадий	Михайлов	Петровна	+7 371 403 43 72	4831 730733	среднее	6422
Екатерина	Казакова	Глебович	8 (223) 285-2237	3511 279923	среднее	6423
Станислав	Лапин	\N	+7 439 701 51 74	4867 830962	среднее	6424
Константин	Тетерин	\N	+71259355251	6194 563381	среднее профессиональное	6425
Фотий	Дорофеева	Жоресович	+7 494 826 06 66	8467 251093	высшее	6426
Якуб	Белоусова	\N	8 533 765 6997	1832 100324	неоконченное высшее	6427
Валерия	Мухина	Викторович	+7 (789) 984-8411	9802 233954	среднее	6428
Ферапонт	Кошелев	Изотович	8 (782) 287-3692	4326 223144	среднее профессиональное	6429
Ананий	Гусева	Виленович	8 494 204 3368	9682 684037	среднее	6430
Нинель	Гурьева	\N	8 429 536 5961	3614 876538	высшее	6431
Агафон	Ефимов	\N	8 (665) 565-53-06	9610 463017	\N	6432
Викентий	Котова	Харламович	8 (693) 216-4030	2229 247275	неоконченное высшее	6433
Никон	Куликова	\N	8 737 676 54 69	4260 422707	\N	6434
Агата	Юдина	Олеговна	84872285429	5017 844222	\N	6435
Лавр	Трофимов	Венедиктович	+75839587125	1875 122712	\N	6436
Всеслав	Федоров	Вячеславовна	+7 624 878 5651	5842 579817	\N	6437
Соломон	Игнатьев	Оскаровна	8 151 735 0360	5297 490438	\N	6438
Макар	Филатов	Харитоновна	+7 364 924 9715	7223 884488	\N	6439
Пахом	Носова	\N	86548708974	9108 853075	высшее	6440
Ирина	Никитина	\N	80696102423	3055 368110	среднее профессиональное	6441
Касьян	Савина	Еремеевич	+7 (540) 774-43-30	7977 224487	\N	6442
Агафон	Маркова	\N	+77057562523	8073 445611	\N	6443
Рюрик	Овчинникова	\N	+75241560849	1128 307820	неоконченное высшее	6444
Ермил	Шарова	\N	8 (162) 808-4917	5615 524289	\N	6445
Юлий	Сорокина	\N	+7 (838) 277-8871	3146 635041	среднее профессиональное	6446
Вениамин	Зайцев	\N	+7 608 812 1988	9334 499461	среднее профессиональное	6447
Аникей	Лаврентьев	\N	+7 947 232 9793	7641 439769	среднее профессиональное	6448
Бажен	Петров	\N	8 692 628 97 49	8933 444739	высшее	6449
Арефий	Егоров	Алексеевна	8 (791) 384-5393	6343 131105	неоконченное высшее	6450
Эрнест	Артемьев	\N	+7 755 640 46 68	4197 578571	среднее	6451
Парфен	Лукин	\N	+77194502967	2071 517251	среднее профессиональное	6452
Христофор	Дроздова	\N	+7 (008) 912-2492	8085 216374	неоконченное высшее	6453
Милица	Моисеева	\N	88053581012	5940 219509	среднее профессиональное	6454
Азарий	Голубева	Ефимович	+7 (378) 662-3590	9431 862123	среднее профессиональное	6455
Эраст	Ларионов	\N	+75364531512	1320 778296	среднее	6456
Куприян	Тарасова	Валерьевич	8 (844) 069-9674	8146 453497	среднее профессиональное	6457
Радован	Ефимов	\N	+75554782226	5133 793225	\N	6458
Вацлав	Куликова	\N	8 (348) 016-6668	4779 134480	высшее	6459
Эраст	Родионов	Филиппович	8 946 117 45 55	1583 294606	среднее	6460
Андрей	Аксенова	Глебович	+7 068 128 1894	4382 128879	высшее	6461
Адриан	Дорофеев	Эдуардовна	+7 (150) 365-82-84	7141 260390	высшее	6462
Мартын	Герасимова	Кирилловна	8 (878) 772-3775	4157 231053	\N	6463
Валентин	Горбунов	\N	89713089441	6515 988297	\N	6464
Карл	Лукин	Матвеевна	8 960 352 5943	5790 671489	среднее профессиональное	6465
Милий	Павлова	Тимофеевна	8 (736) 530-5433	4142 885225	неоконченное высшее	6466
Ратмир	Фокина	\N	8 (383) 008-81-20	2640 917822	среднее	6467
Климент	Силин	\N	8 (805) 275-3140	7274 451499	среднее	6468
Лонгин	Туров	\N	+76061175215	4443 924780	неоконченное высшее	6469
Ульяна	Зыков	\N	8 039 275 10 63	7470 771606	неоконченное высшее	6533
Януарий	Яковлева	Валерианович	8 (928) 762-7348	3757 496520	среднее профессиональное	6470
Гордей	Шарова	Федотович	8 (284) 056-05-30	3757 232325	\N	6471
Евфросиния	Якушев	\N	8 283 094 1933	6300 830480	высшее	6472
Андроник	Мельникова	Тарасовна	+7 218 623 09 15	6363 636804	среднее	6473
Дарья	Дмитриев	\N	+7 120 511 0993	7850 563913	высшее	6474
Евсей	Сидорова	Аркадьевна	8 094 812 0705	6588 135220	среднее профессиональное	6475
Боян	Русакова	Федосьевич	+7 547 944 41 93	4056 887782	\N	6476
Артемий	Титов	Иосипович	8 035 139 9901	5552 259862	\N	6477
Майя	Соловьева	\N	8 655 319 09 42	6535 963085	среднее профессиональное	6478
Гремислав	Поляков	Димитриевич	+7 (849) 811-34-15	6789 769896	неоконченное высшее	6479
Август	Щукина	\N	+77769858652	1472 489507	\N	6480
Дарья	Орехов	\N	+7 011 656 73 92	7996 874075	среднее	6481
Евфросиния	Игнатов	\N	+7 596 646 3732	3051 389954	\N	6482
Будимир	Михеева	\N	82741281318	2218 941597	среднее	6483
Любовь	Киселев	\N	+71756749176	5778 985721	высшее	6484
Соломон	Юдина	Натановна	8 (370) 240-8801	6278 236794	неоконченное высшее	6485
Иван	Корнилов	\N	81737725429	2035 613320	среднее профессиональное	6486
Изяслав	Рожкова	\N	88533771507	1510 896559	высшее	6487
Феликс	Дьячков	\N	8 (435) 126-16-31	3114 993662	\N	6488
Нинель	Ситников	\N	+7 (433) 746-20-09	9176 442554	\N	6489
Милица	Фадеев	Харитоновна	+7 112 591 64 61	2987 331947	среднее профессиональное	6490
Лука	Петров	Феликсовна	87712058517	9500 648138	среднее	6491
Эмилия	Алексеев	Артурович	+79800910713	5349 153726	среднее	6492
Стоян	Копылов	\N	+7 456 800 51 58	8806 393052	неоконченное высшее	6493
Всеслав	Семенова	\N	8 083 838 86 89	1582 525821	среднее	6494
Гаврила	Савельев	\N	+7 552 121 2745	5926 764770	среднее	6495
Тимур	Волков	Авдеевич	8 (597) 632-1720	6581 850900	неоконченное высшее	6496
Ульяна	Зиновьева	Филипповна	+7 208 514 67 45	4841 591100	неоконченное высшее	6497
Милен	Белоусова	\N	8 860 930 23 15	5265 695729	среднее	6498
Ярополк	Галкин	Владимировна	+7 (388) 395-55-44	7930 875185	неоконченное высшее	6499
Ольга	Гущина	\N	8 (902) 124-9198	9540 743052	неоконченное высшее	6500
Виктория	Комиссаров	\N	+7 (313) 003-67-15	6609 792328	\N	6501
Виссарион	Субботин	Георгиевна	8 962 965 1766	2547 153082	неоконченное высшее	6502
Ираида	Баранова	\N	8 391 934 95 29	1703 385387	неоконченное высшее	6503
Руслан	Агафонов	\N	8 871 857 1435	8305 566504	среднее	6504
Исидор	Суханова	Матвеевна	+76618679992	3514 694984	неоконченное высшее	6505
Демьян	Шестакова	Зиновьевич	8 726 362 85 74	2674 434763	неоконченное высшее	6506
Харитон	Юдин	Тарасовна	+7 (525) 234-06-77	2606 471740	среднее	6507
Амвросий	Копылов	Владиленович	+7 (437) 526-3185	7917 732496	неоконченное высшее	6508
Илья	Ермаков	Игнатович	+7 474 734 43 60	1406 693375	неоконченное высшее	6509
Христофор	Рыбакова	Зиновьевич	8 (862) 582-4871	8480 215146	среднее профессиональное	6510
Ярополк	Савин	Александрович	+7 308 539 80 09	6748 876397	среднее	6511
Мариан	Соловьев	Теймуразович	+7 (382) 902-2102	1032 258161	среднее профессиональное	6512
Любомир	Мамонтов	\N	+7 (567) 578-5163	5955 768841	неоконченное высшее	6513
Борис	Казакова	Аскольдовна	+7 (026) 870-1077	8993 218157	неоконченное высшее	6514
Эрнст	Королева	Матвеевна	+7 191 770 9808	7097 330324	высшее	6515
Исидор	Новиков	\N	+7 582 913 63 23	9407 601339	среднее	6516
Аникита	Субботин	\N	+73487336326	6502 426678	среднее профессиональное	6517
Трифон	Емельянова	Даниилович	83976149463	9763 298538	среднее	6518
Светозар	Петухов	Иосифович	8 (652) 630-5788	7610 239758	среднее	6519
Макар	Самсонова	\N	+7 232 776 9373	3164 181449	неоконченное высшее	6520
Эрнест	Гурьев	\N	8 821 865 36 61	5518 184448	среднее	6521
Михаил	Субботин	Ильинична	8 (013) 808-9145	7167 432851	среднее	6522
Марина	Селиверстов	Рудольфовна	80485766970	8411 752855	\N	6523
Леонтий	Давыдова	\N	8 (820) 041-55-02	4034 641389	высшее	6524
Всемил	Самсонова	Филипповна	8 210 977 10 32	1047 188818	неоконченное высшее	6525
Мир	Карпов	\N	8 (892) 420-3844	9109 861867	высшее	6526
Авксентий	Фролова	Артурович	8 208 573 07 83	9084 331673	\N	6527
Владилен	Орлова	Тихонович	+7 (740) 323-70-30	6148 438420	\N	6528
Иларион	Тимофеев	\N	+7 (245) 772-8124	7942 474621	среднее профессиональное	6529
Азарий	Колесников	Дорофеевич	8 (364) 781-6386	9410 552777	\N	6530
Борислав	Давыдова	\N	+7 (807) 716-8845	4679 284863	высшее	6531
Вениамин	Белозеров	Дмитриевна	+7 810 346 5155	6731 840222	неоконченное высшее	6535
Сергей	Нестерова	Виленович	+7 819 241 45 30	3147 817359	\N	6536
Василий	Ширяев	\N	+7 620 440 8197	8918 713552	высшее	6537
Эраст	Мартынов	Васильевна	8 (318) 279-95-67	4667 587937	среднее профессиональное	6538
Демьян	Блинов	Ждановна	+7 (472) 824-5275	3016 653373	неоконченное высшее	6539
Прохор	Лобанова	Руслановна	+7 (024) 961-5410	1124 183466	\N	6540
Самуил	Козлов	\N	8 557 537 57 76	5136 706515	неоконченное высшее	6541
Фаина	Калашникова	Игоревна	+74583521067	1265 741876	\N	6542
Марфа	Трофимов	Эдуардович	+7 033 971 5460	8328 983665	неоконченное высшее	6543
Спиридон	Мясникова	Гордеевич	8 514 179 18 02	6834 134468	высшее	6544
Марфа	Хохлова	\N	82466603953	2281 742183	среднее	6545
Евдокия	Костина	Ильич	+7 (613) 061-20-39	5971 453153	высшее	6546
Светозар	Горшков	Ефимьевич	8 171 804 8551	5728 359328	среднее	6547
Давыд	Гущина	Гаврилович	+7 (549) 479-5069	7099 957181	\N	6548
Сократ	Сергеев	\N	+7 (789) 733-9818	4921 277967	высшее	6549
Любосмысл	Блинова	\N	+7 698 440 9134	3698 428005	среднее профессиональное	6550
Захар	Аксенов	\N	8 359 441 55 54	2455 222618	\N	6551
Марк	Меркушев	Борисовна	8 705 771 5473	3836 664193	среднее профессиональное	6552
Лидия	Доронин	Архиповна	+7 (372) 350-5250	1659 132319	среднее	6553
Януарий	Рожкова	Андреевич	+75155724801	5774 375867	среднее	6554
Евпраксия	Громов	\N	+7 (856) 532-67-35	3474 691987	\N	6555
Ювеналий	Морозов	Арсенович	8 648 800 31 02	9922 298330	среднее профессиональное	6556
Руслан	Субботина	\N	8 003 617 6272	9292 593052	высшее	6557
Игнатий	Баранов	Ильинична	+7 737 689 21 57	3124 137481	среднее профессиональное	6558
Аскольд	Зыков	\N	+7 (025) 236-6420	8815 166019	\N	6559
Мина	Красильников	Эдуардовна	83586934224	8927 812634	среднее	6560
Пров	Жданов	\N	8 (059) 887-19-50	1560 365054	\N	6561
Андрон	Орлов	\N	8 109 557 0941	2525 319409	неоконченное высшее	6562
Таисия	Осипов	Викторовна	8 897 788 75 02	2587 725009	высшее	6563
Парфен	Носова	Денисович	8 968 164 5029	6303 400845	неоконченное высшее	6564
Гедеон	Попова	\N	8 (910) 055-46-62	2552 910939	среднее профессиональное	6565
Епифан	Шилова	\N	+7 966 961 52 23	4207 779550	среднее	6566
Матвей	Борисова	Оскаровна	+77917118108	2015 248054	высшее	6567
Юрий	Тихонов	\N	+76785325244	8367 390278	высшее	6568
Семен	Герасимов	\N	86399833390	7025 157178	высшее	6569
Иван	Жуков	\N	8 642 994 7009	6948 201359	высшее	6570
Сергей	Артемьева	\N	8 (222) 676-7859	5984 203898	\N	6571
Регина	Петухова	Еремеевич	+7 597 844 31 41	1396 742342	среднее профессиональное	6572
Александра	Овчинников	Вениаминовна	+7 226 334 26 44	7475 395536	высшее	6573
София	Горшкова	\N	+7 490 494 91 67	9650 306659	высшее	6574
Август	Большакова	\N	+70151095111	2585 275870	среднее профессиональное	6575
Самуил	Гущин	\N	8 512 781 03 54	9519 733487	среднее профессиональное	6576
Жанна	Титова	\N	+7 (415) 386-03-76	3490 643960	высшее	6577
Адам	Кудряшова	\N	+7 (979) 026-3260	5178 530010	неоконченное высшее	6578
Викторин	Зимин	\N	+77033230123	4015 711613	среднее	6579
Евпраксия	Моисеев	\N	+7 538 859 22 82	6875 444167	среднее	6580
Галина	Попов	\N	+7 (485) 757-64-08	7022 794037	высшее	6581
Климент	Блинов	\N	8 (916) 521-9206	8564 257220	неоконченное высшее	6582
Афиноген	Кабанов	Харлампович	8 272 555 48 32	1316 793065	высшее	6583
Таисия	Воронов	\N	+7 (199) 627-4879	2957 480485	высшее	6584
Владимир	Доронина	\N	+7 (785) 524-4954	9453 511927	высшее	6585
Аркадий	Федосеева	Аверьянович	8 525 420 25 29	2605 283732	среднее	6586
Владилен	Фадеев	\N	+79872219792	9765 938107	среднее	6587
Гурий	Абрамова	Богдановна	88723421725	3884 910167	\N	6588
Евфросиния	Денисов	Зиновьевич	8 188 934 63 49	9017 519985	высшее	6589
Ираклий	Афанасьев	\N	+7 (521) 629-7152	7086 194236	неоконченное высшее	6590
Карл	Константинова	Августович	89831740511	4392 614653	среднее	6591
Изяслав	Комарова	\N	+7 663 409 63 33	1645 620972	\N	6592
Светлана	Комаров	Герасимович	+7 (913) 549-5442	3588 301069	неоконченное высшее	6593
Болеслав	Лыткина	Борисовна	8 (830) 244-5171	9671 354153	неоконченное высшее	6594
Вышеслав	Ермакова	\N	89716812209	2483 772476	высшее	6595
Аким	Морозова	Наумовна	8 (778) 679-52-45	9596 971272	\N	6596
Любомир	Стрелков	Иосифович	+7 (926) 296-29-15	2814 540305	среднее профессиональное	6597
Анисим	Давыдова	\N	+7 (672) 171-5009	1134 754645	среднее профессиональное	6598
Гремислав	Ершова	\N	8 767 792 63 82	5434 385135	неоконченное высшее	6600
Тимофей	Назарова	\N	+7 (393) 541-5873	5650 961805	среднее	6601
Карл	Щербакова	\N	+77048985505	3833 123549	среднее профессиональное	6602
Любим	Кулагин	Яковлевич	+7 685 723 8757	4671 592154	неоконченное высшее	6603
Сигизмунд	Жданова	Вячеславовна	85006195146	4573 820836	неоконченное высшее	6604
Леон	Рыбакова	Ефимьевич	8 (983) 284-1377	1905 604742	неоконченное высшее	6605
Емельян	Николаева	Альбертовна	81079228406	2279 604867	высшее	6606
Галина	Юдин	\N	8 (962) 061-8168	3246 863433	высшее	6607
Фортунат	Романов	Сергеевна	8 (999) 607-2994	9768 668956	\N	6608
Спиридон	Федотова	Дмитриевна	+7 144 392 1408	1383 311930	среднее профессиональное	6609
Радислав	Харитонова	Давыдович	+71502912202	8576 667970	среднее профессиональное	6610
Никифор	Терентьева	\N	+7 (618) 610-93-70	9135 488514	высшее	6611
Святополк	Яковлева	\N	8 (669) 372-9806	2827 118666	\N	6612
Исай	Селезнев	Валерьянович	+7 (450) 855-39-91	8691 127149	среднее профессиональное	6613
Авдей	Фомичев	Архипович	85533451527	6562 486343	высшее	6614
Валентин	Родионова	Владленович	8 (966) 297-9725	7261 127141	неоконченное высшее	6615
Феоктист	Савельева	Демидович	8 (315) 498-13-27	4127 598910	среднее	6616
Аполлон	Денисов	\N	8 (348) 478-23-44	8595 584474	среднее профессиональное	6617
Аникей	Панова	\N	8 993 441 4137	5079 652915	среднее	6618
Стоян	Туров	Аксёнович	+7 086 006 1134	3669 611204	высшее	6619
Ратмир	Волкова	Андреевна	+7 851 074 32 19	8570 779532	среднее	6620
Олимпиада	Фомин	\N	+7 613 515 6031	2980 667125	среднее профессиональное	6621
Поликарп	Вишнякова	\N	88053555728	3882 833060	среднее	6622
Мир	Родионова	Семеновна	+7 (866) 460-9831	1209 847937	\N	6623
Жанна	Маркова	\N	8 028 495 77 56	4471 426096	высшее	6624
Никодим	Панфилов	\N	+7 (045) 329-4993	7895 771714	среднее	6625
Мокей	Максимова	Викторовна	+77873458858	8495 564674	неоконченное высшее	6626
Артемий	Воронова	Алексеевич	8 022 415 5649	8524 480657	среднее	6627
Ратмир	Муравьева	Гордеевич	+7 996 569 49 10	3244 678342	среднее	6628
Велимир	Владимирова	\N	8 (798) 014-30-07	2343 670575	среднее профессиональное	6629
Пимен	Козлов	\N	+76586409440	6789 327779	среднее	6630
Владимир	Корнилов	Павловна	+7 (450) 753-21-51	6080 151199	высшее	6631
Капитон	Жданов	Аксёнович	8 745 750 5184	8849 558660	среднее	6632
Творимир	Муравьева	Валентиновна	8 (707) 135-1870	4937 835604	среднее	6633
Оксана	Новикова	\N	+7 (357) 824-0119	8120 257858	среднее	6634
Всеволод	Носкова	\N	8 939 150 5431	1872 684666	неоконченное высшее	6635
Добромысл	Фомичева	\N	8 755 937 9520	1497 372817	неоконченное высшее	6636
Исай	Козлов	Ефимовна	+78167359369	1613 545934	среднее	6637
Юлий	Шашков	Богданович	8 (184) 897-94-19	3864 815832	неоконченное высшее	6638
Назар	Петухов	Федотович	8 034 494 84 28	5813 908072	\N	6639
Александр	Маркова	\N	+7 426 655 7301	6979 278641	неоконченное высшее	6640
Любосмысл	Константинова	\N	+7 791 139 4444	8206 610540	среднее	6641
Тимур	Голубева	\N	+7 744 880 45 49	1245 877153	среднее	6642
Евсей	Князев	Демьянович	8 (712) 551-1590	8714 540455	среднее профессиональное	6643
Кир	Русаков	\N	+7 633 789 5505	1478 301448	среднее профессиональное	6644
Христофор	Ширяев	Филимонович	+7 (880) 277-5378	3728 795414	высшее	6645
Прокофий	Дьячкова	\N	8 731 393 9008	9568 374375	\N	6646
Вероника	Фадеева	Антипович	+7 (513) 329-0551	9437 619949	среднее профессиональное	6647
Оксана	Прохоров	Романовна	+7 (269) 191-74-33	6875 436141	высшее	6648
Фаина	Анисимов	\N	+78898792436	5460 137479	\N	6649
Ипатий	Алексеев	Демьянович	8 (483) 942-53-29	4292 996616	высшее	6650
Иванна	Мухин	Игоревич	+7 (060) 639-19-67	4264 219450	среднее	6651
Гостомысл	Панова	\N	8 136 180 5582	5280 663334	среднее	6652
Евдоким	Титов	\N	+7 547 455 5393	6974 245296	неоконченное высшее	6653
Георгий	Полякова	\N	+7 855 369 58 38	4886 142104	среднее	6654
Куприян	Белоусова	\N	+79354850570	3255 360327	высшее	6655
Радислав	Евдокимов	Игоревна	+7 625 687 25 55	7639 352740	высшее	6656
Любосмысл	Трофимова	\N	+7 730 420 00 96	6875 820307	неоконченное высшее	6657
Анжелика	Гущин	Фёдорович	8 (429) 419-19-61	8343 631878	\N	6658
Мечислав	Вишняков	\N	+7 (400) 146-4587	9173 857827	высшее	6659
Денис	Соколов	Игнатович	8 (584) 026-8755	4857 920399	среднее профессиональное	6660
Епифан	Смирнов	Абрамович	8 210 923 2246	6883 366529	высшее	6661
Дмитрий	Максимова	Вениаминовна	8 (298) 841-1246	5789 554690	неоконченное высшее	6662
Исай	Громов	Авдеевич	+7 (948) 505-07-27	7456 306165	неоконченное высшее	6663
Василиса	Ефимова	Даниилович	+7 507 064 30 46	5233 130719	\N	6664
Василий	Козлова	\N	8 535 103 2269	7714 575653	высшее	6665
Чеслав	Гурьева	\N	+7 301 409 22 99	8697 555450	неоконченное высшее	6666
Аверьян	Галкина	\N	8 170 201 4363	7575 891012	высшее	6667
Жанна	Медведев	\N	+76335156859	6226 151765	высшее	6668
Ипполит	Ефремов	\N	8 334 433 8507	1602 780282	неоконченное высшее	6669
Порфирий	Кузьмин	\N	+74576702295	2503 557093	среднее	6670
Филарет	Богданова	Юлианович	+7 553 115 85 59	4123 688340	высшее	6671
Элеонора	Моисеева	\N	+7 241 786 87 71	4243 892984	\N	6672
Ефрем	Белоусов	\N	8 452 917 70 98	1625 124249	неоконченное высшее	6673
Ефрем	Горбунов	\N	87196929059	1045 944732	среднее профессиональное	6674
Валерий	Ермаков	\N	+7 413 782 9358	9744 617905	среднее	6675
Ипат	Назарова	Елизарович	8 (629) 484-1740	5566 757301	среднее профессиональное	6676
Александра	Турова	\N	8 (977) 009-86-02	1357 706183	\N	6677
Ратибор	Федотова	Федоровна	8 (196) 894-5438	6811 966562	неоконченное высшее	6678
Каллистрат	Орлова	\N	8 (432) 125-97-05	6654 998364	среднее профессиональное	6679
Геннадий	Воробьева	Эльдаровна	+79924592457	7982 760717	высшее	6680
Радислав	Лаврентьев	Кирилловна	8 (655) 702-03-99	2117 450263	неоконченное высшее	6681
Людмила	Рожкова	\N	8 (121) 571-03-39	6726 869390	неоконченное высшее	6682
Гостомысл	Миронова	\N	8 (327) 290-7466	8172 301575	среднее профессиональное	6683
Конон	Дорофеева	Болеславовна	8 (307) 476-05-41	9066 250329	\N	6684
Ульяна	Русаков	\N	8 (104) 022-8509	1078 360673	высшее	6685
Спартак	Лобанов	Станиславовна	+7 597 123 71 95	2244 334559	среднее профессиональное	6686
Савелий	Исакова	Витальевич	8 973 492 0635	2404 308930	среднее профессиональное	6687
Любосмысл	Гуляев	\N	8 859 128 08 27	4607 597097	высшее	6688
Олимпиада	Герасимов	Натановна	+7 (278) 978-46-07	9868 458335	неоконченное высшее	6689
Евгения	Шарова	\N	8 186 922 4985	1977 266544	высшее	6690
Потап	Романова	Ааронович	8 (678) 049-8034	6528 956367	среднее профессиональное	6691
Аким	Федорова	Александрович	+7 (300) 450-49-57	8826 980594	\N	6692
Пантелеймон	Ефимова	\N	8 724 678 89 33	8246 647932	среднее профессиональное	6693
Гедеон	Пономарева	Елизарович	+7 518 297 23 75	3683 631408	среднее профессиональное	6694
Наина	Михеев	\N	+77009283444	3278 334023	высшее	6695
Пелагея	Лихачева	Ярославович	+7 740 471 5230	1900 534129	высшее	6696
Анжела	Лукина	Ярославович	87235025426	1055 465804	\N	6697
Лавр	Пестова	Владленович	8 (009) 735-0111	1251 653592	среднее	6698
Анастасия	Крюкова	Харлампович	8 793 066 93 91	4757 252082	высшее	6699
Всеволод	Галкин	\N	+7 914 638 6870	1685 159930	\N	6700
Фома	Блохин	Михайловна	8 (735) 605-9016	7704 962539	высшее	6701
Игорь	Терентьева	\N	+7 376 228 73 00	5919 611370	среднее профессиональное	6702
Максим	Князева	\N	+7 (179) 629-01-43	7650 280596	высшее	6703
Марк	Лебедева	\N	8 858 678 7093	3823 432804	среднее	6704
Платон	Исаева	Леонидовна	8 212 170 14 57	4491 777285	\N	6705
Парфен	Михайлов	\N	8 544 931 7211	6769 356210	\N	6706
Болеслав	Колобов	Владиславович	+7 (160) 089-45-02	8689 636448	\N	6707
Наум	Филатова	Анисимович	8 (776) 799-6077	9136 698947	среднее профессиональное	6708
Эммануил	Титов	\N	8 (408) 441-11-10	3029 194743	среднее	6709
Аристарх	Федорова	Ефстафьевич	+7 283 150 6216	7222 334452	неоконченное высшее	6710
Алина	Киселева	\N	85737709778	4159 811656	неоконченное высшее	6711
Авксентий	Савин	Богданович	8 318 809 74 96	9578 168825	среднее	6712
Нестор	Елисеев	Даниловна	+77058221032	9531 787522	среднее профессиональное	6713
Аверкий	Брагин	\N	8 (609) 677-86-34	7545 324859	\N	6714
Всемил	Дьячкова	Бориславович	84518690668	5817 418272	высшее	6715
Изяслав	Сорокин	\N	8 935 039 7153	7272 955863	\N	6716
Алексей	Самсонова	\N	8 (495) 276-8762	7504 200556	высшее	6717
Нина	Миронов	Вениаминовна	+75104078956	7374 599975	среднее профессиональное	6718
Владислав	Герасимова	\N	+74112281767	7171 989584	высшее	6719
Сергей	Богданова	\N	+7 862 935 45 83	5620 796950	неоконченное высшее	6720
Ярополк	Афанасьева	\N	+71702827989	2375 404914	неоконченное высшее	6721
Платон	Корнилов	\N	8 211 261 5216	3032 845230	высшее	6722
Людмила	Соловьев	\N	+7 (882) 536-01-69	3758 156591	высшее	6723
Анастасия	Комиссарова	Харитонович	+7 (508) 677-22-46	7414 926786	высшее	6724
Аверкий	Титов	\N	+7 (652) 817-4285	5714 736191	\N	6725
Эмиль	Родионов	\N	+7 021 174 4788	7683 144567	высшее	6726
Максим	Маркова	Чеславович	8 038 409 17 96	2833 570560	среднее профессиональное	6727
Порфирий	Зайцева	\N	+77892368741	6691 348627	среднее	6728
Ефрем	Рогова	\N	89593178374	9120 670832	неоконченное высшее	6729
Михей	Соколов	Ааронович	+7 (033) 808-2818	7691 403869	\N	6730
Боян	Фадеев	\N	+7 (867) 726-5818	7000 819348	\N	6731
Ананий	Беляев	Аверьянович	8 (953) 063-6001	2801 279691	высшее	6732
Пимен	Фомина	\N	8 819 206 1851	9234 238264	\N	6733
Будимир	Карпова	Устинович	+77222350076	8331 183492	высшее	6734
Авдей	Ситникова	Филатович	8 (300) 672-48-48	2538 870758	среднее профессиональное	6735
Артем	Щербаков	\N	8 (139) 517-6538	1566 471202	высшее	6736
Екатерина	Корнилова	Антонович	+7 696 410 15 74	3262 417269	неоконченное высшее	6737
Григорий	Карпова	Анисимович	+74010712528	5771 578558	неоконченное высшее	6738
Доброслав	Молчанов	Аксёнович	+78253196013	1789 795832	\N	6739
Ерофей	Трофимов	\N	+7 (487) 447-50-51	9819 996220	среднее профессиональное	6740
Каллистрат	Громов	Яковлевна	8 406 013 9706	7362 145084	высшее	6741
Таисия	Кошелев	\N	86854156571	6715 794146	\N	6742
Владилен	Кошелев	Георгиевна	+71422690786	1733 362273	среднее	6743
Гремислав	Давыдова	\N	8 (281) 088-3839	5495 374012	среднее профессиональное	6744
Игнатий	Доронина	\N	+7 317 129 47 26	8278 881992	\N	6745
Анатолий	Копылова	\N	+74060198909	2673 556784	среднее	6746
Оксана	Соболев	\N	+7 129 563 1942	8546 490462	среднее профессиональное	6747
Болеслав	Моисеева	Тимуровна	8 (075) 435-9994	4747 454430	\N	6748
Леон	Лаврентьева	Феликсовна	+7 (899) 339-4695	3272 343639	высшее	6749
Никон	Зайцева	Никифоровна	82011063839	9322 323750	высшее	6750
Евсей	Маслов	\N	8 (379) 262-0250	4448 655232	высшее	6751
Геннадий	Колесников	Ерофеевич	8 922 026 95 57	9857 559723	среднее	6752
Аполлон	Ершова	Всеволодович	+77181998761	9081 927949	среднее профессиональное	6753
Панкратий	Захарова	Болеславовна	+7 (194) 490-7222	5953 789577	\N	6754
Милен	Герасимов	\N	8 054 190 51 29	7453 519675	среднее	6755
Бронислав	Воронцов	\N	+7 740 145 76 79	9366 980493	среднее	6756
Нинель	Крылова	\N	8 745 136 0870	4574 732165	высшее	6757
Ян	Боброва	\N	+7 935 935 0119	8931 198062	высшее	6758
Модест	Белоусова	\N	+7 (966) 632-5195	6773 671055	среднее профессиональное	6759
Вышеслав	Волков	Богдановна	+7 (677) 859-8916	9630 612873	среднее	6760
Юлия	Макарова	Романовна	+7 (023) 916-74-93	8456 888975	неоконченное высшее	6761
Агафон	Князева	\N	+7 870 154 6383	4453 313147	\N	6762
Трофим	Белоусова	Гурьевич	+7 246 930 63 01	4070 772427	\N	6763
Таисия	Зуев	\N	8 951 720 2441	4925 226710	\N	6764
Фаина	Афанасьева	\N	8 402 334 6452	9217 663929	неоконченное высшее	6765
Ираида	Харитонов	Ефстафьевич	8 (903) 906-1082	4314 395910	среднее	6766
Наум	Панфилов	Филатович	8 143 972 3405	6930 155217	среднее профессиональное	6767
Наталья	Логинова	\N	8 (000) 129-59-04	2119 925608	высшее	6768
Алексей	Игнатова	\N	8 410 773 18 60	9145 470265	высшее	6769
Венедикт	Калинина	Леонидовна	+7 (303) 750-2437	6404 486786	высшее	6770
Раиса	Орлова	\N	8 341 674 68 21	5039 238173	среднее профессиональное	6771
Дементий	Соболева	Григорьевна	8 (692) 494-99-43	1052 435265	среднее профессиональное	6772
Лазарь	Лобанов	\N	8 607 876 15 42	8662 373372	неоконченное высшее	6773
София	Кононов	Ярославович	8 (776) 775-3709	7050 843019	среднее профессиональное	6774
Зиновий	Михайлова	Даниилович	+7 429 983 78 88	1772 343438	неоконченное высшее	6775
Иннокентий	Костин	Харитоновна	8 937 388 0155	2890 367013	\N	6776
Виктор	Шестаков	Тимофеевна	8 (483) 803-2726	5738 622714	среднее профессиональное	6777
Любомир	Моисеева	Данилович	+7 135 178 67 51	4264 130153	высшее	6778
Ангелина	Суханова	Харитонович	+7 (980) 093-1325	3900 243511	среднее	6779
Данила	Лобанова	Эдгардович	8 534 498 8687	4568 839671	среднее профессиональное	6780
Пимен	Сорокин	\N	+7 (249) 109-3172	3789 184363	\N	6781
Януарий	Авдеев	\N	+7 (464) 159-59-55	5543 389113	среднее	6782
Евстигней	Воробьев	\N	8 (637) 031-82-77	4233 985024	\N	6783
Лукьян	Буров	Вениаминовна	8 (874) 020-5794	8978 811604	среднее профессиональное	6784
Анастасия	Карпова	Кузьминична	8 021 082 69 24	6719 298104	\N	6785
Емельян	Маслов	\N	8 241 527 17 86	3131 379459	среднее	6786
Татьяна	Гурьев	\N	+7 255 590 79 54	9169 450611	\N	6787
Никита	Исаева	\N	+76387323413	2597 836122	среднее	6788
Фадей	Макаров	Денисович	+7 (994) 732-10-41	3960 235745	среднее профессиональное	6789
Иннокентий	Ильин	\N	+72626760223	7844 948970	высшее	6790
Дарья	Силин	\N	+77692495123	3629 170714	высшее	6791
Владилен	Копылов	Ниловна	8 860 010 02 87	6382 573970	неоконченное высшее	6792
Никифор	Веселова	Дмитриевна	8 964 651 48 56	7179 819376	среднее	6793
Нестор	Галкина	\N	8 (953) 951-49-09	1632 179690	неоконченное высшее	6794
Ксения	Туров	\N	83330679737	2623 215659	среднее профессиональное	6795
Модест	Соболева	\N	+7 871 110 50 22	5045 484580	\N	6796
Родион	Лазарев	Жанович	8 (249) 560-1295	7739 568965	\N	6797
Христофор	Фомичева	Святославовна	+7 (008) 336-38-21	6653 505206	среднее	6798
Олег	Лукина	\N	8 258 904 46 63	3332 918874	среднее профессиональное	6799
Элеонора	Дроздова	Всеволодович	+7 392 816 2771	2995 600164	\N	6800
Мартьян	Евсеева	Ярославович	+7 250 684 6304	5069 316425	среднее профессиональное	6801
Софрон	Пономарев	Гордеевич	87189648898	1783 979528	среднее профессиональное	6802
Анастасия	Архипов	Даниловна	+7 (907) 928-92-55	9258 873859	\N	6803
Валерия	Киселев	\N	+7 (055) 301-4696	9503 817111	неоконченное высшее	6804
Максимильян	Крылова	Рудольфовна	8 445 399 9092	3577 317338	среднее профессиональное	6805
Гостомысл	Корнилов	\N	+7 (432) 084-25-15	5320 415336	\N	6806
Петр	Сысоева	Валериевна	81583995086	2891 386913	высшее	6807
Раиса	Артемьева	Николаевна	+7 (037) 762-6660	7563 996029	\N	6808
Климент	Муравьева	\N	8 240 923 2305	8130 450155	\N	6809
Аникей	Зуев	Тимофеевна	+7 815 142 8166	6994 634536	неоконченное высшее	6810
Остромир	Сорокина	\N	8 (758) 546-48-80	3745 914619	среднее профессиональное	6811
Евпраксия	Мухина	\N	8 254 906 96 00	5596 139500	неоконченное высшее	6812
Илья	Князева	\N	8 (741) 402-0363	1368 213284	неоконченное высшее	6813
Евдокия	Белова	Артемовна	+7 (301) 706-4428	4547 489793	среднее профессиональное	6814
Ульян	Воробьева	\N	+7 472 890 23 95	9480 201493	неоконченное высшее	6815
Богдан	Зайцев	Дмитриевич	+7 (256) 921-0980	6244 672898	неоконченное высшее	6816
Елизавета	Калинина	\N	+7 (511) 183-9116	9703 849626	\N	6817
Зиновий	Кабанова	\N	8 (529) 711-7638	1581 468126	неоконченное высшее	6818
Ермолай	Кулаков	\N	8 286 473 8141	1204 712522	высшее	6819
Клавдий	Молчанова	\N	+7 493 523 85 24	6236 168694	неоконченное высшее	6820
Ермил	Зуев	\N	8 (990) 730-79-74	3133 233424	среднее	6821
Прохор	Третьяков	\N	8 (753) 052-17-20	3959 804590	среднее	6822
Степан	Савин	\N	8 030 707 08 80	3181 899798	неоконченное высшее	6823
Эдуард	Меркушев	Глебович	+7 (814) 077-80-81	2487 551420	неоконченное высшее	6824
Эдуард	Степанова	Марсович	+7 (247) 051-07-37	2476 234033	неоконченное высшее	6825
Пимен	Владимиров	Викентьевич	8 171 901 23 51	8483 638313	среднее профессиональное	6826
Марина	Колесников	Владиленович	8 (578) 476-17-46	6699 845013	неоконченное высшее	6827
Устин	Воронцов	Виленович	+7 (167) 032-7721	3122 531797	среднее профессиональное	6828
Вацлав	Данилова	Германович	+7 (855) 488-87-56	8928 817041	\N	6829
Прохор	Суханова	Герасимович	83368331307	6321 649661	неоконченное высшее	6830
Ирина	Наумова	\N	+7 (715) 799-3616	5719 796337	высшее	6831
Федор	Носков	Дорофеевич	8 516 692 04 77	2503 507792	высшее	6832
Трифон	Орехов	\N	+7 (679) 815-4156	7949 112560	среднее	6833
Фаина	Быков	Геннадиевна	+7 (837) 477-50-97	7403 322635	неоконченное высшее	6834
Людмила	Лыткина	Ивановна	+79256418954	9870 518327	среднее	6835
Наина	Гордеев	Бориславович	+7 (525) 620-7304	2285 533275	среднее профессиональное	6836
Силантий	Суханов	Германович	+7 (081) 899-17-04	4397 429898	\N	6837
Фирс	Соболева	\N	87558052036	5155 396330	высшее	6838
Ермил	Голубева	\N	8 980 560 69 31	9687 134502	\N	6839
Панкратий	Абрамов	\N	8 063 574 59 71	6658 300800	среднее профессиональное	6840
Николай	Котова	\N	8 (362) 405-05-23	2540 136817	высшее	6841
Федот	Шестаков	\N	+7 (136) 208-9934	6810 523091	среднее профессиональное	6842
Акулина	Гаврилова	\N	+7 964 248 73 32	2805 633841	неоконченное высшее	6843
Игорь	Новиков	\N	8 (931) 700-78-54	6775 536698	неоконченное высшее	6844
Вера	Шаров	Григорьевич	+7 (132) 994-2324	7594 433391	высшее	6845
Селиверст	Крылова	\N	+7 (485) 150-6899	3188 884191	\N	6846
Агап	Калашников	Ермолаевич	+7 767 393 1732	2876 606854	высшее	6847
Евдокия	Авдеева	Тарасовна	+7 (715) 989-03-78	9692 465469	среднее	6848
Родион	Евсеева	\N	+7 (207) 862-2037	5711 284733	неоконченное высшее	6849
Надежда	Самсонов	Филипповна	+7 654 206 52 29	7548 913663	неоконченное высшее	6850
Лука	Сергеева	Ерофеевич	8 592 135 0239	8746 450954	высшее	6851
Савватий	Юдин	\N	8 (249) 854-14-85	9537 720563	среднее	6852
Матвей	Горшкова	\N	+7 114 144 4455	1930 361677	среднее профессиональное	6853
Евпраксия	Мамонтова	Демьянович	+7 (569) 358-45-28	7893 405635	среднее профессиональное	6854
Лука	Шестаков	\N	+7 (745) 551-82-09	1011 451682	\N	6855
Фортунат	Сидоров	Жанович	88207258277	6023 766502	среднее	6856
Валентин	Сорокин	Святославовна	+7 638 488 0153	9339 261443	\N	6857
Карп	Беляев	Аскольдовна	8 (023) 167-7943	4137 645332	неоконченное высшее	6858
Ольга	Семенов	\N	+7 (395) 182-72-45	8835 814026	неоконченное высшее	6859
Вадим	Фадеев	Харлампович	8 (977) 657-1889	8147 510431	\N	6860
Виталий	Савельев	\N	+7 (118) 211-95-43	2161 373994	среднее	6861
Адам	Доронин	Викторовна	8 986 804 9260	2566 373980	среднее профессиональное	6862
Парфен	Беляев	Вадимовна	8 (566) 873-45-02	4645 875003	среднее профессиональное	6863
Ипат	Быков	\N	8 (530) 067-1817	4924 876921	неоконченное высшее	6864
Сидор	Борисова	Аверьянович	+7 451 486 36 75	3444 672968	среднее профессиональное	6865
Фока	Захарова	\N	+72161146121	1711 799733	среднее профессиональное	6866
Фёкла	Миронов	\N	+7 446 146 64 51	5367 187106	неоконченное высшее	6867
Исай	Герасимов	\N	+7 (264) 893-57-85	3079 637839	среднее профессиональное	6868
Вадим	Буров	Валерианович	+7 970 563 96 69	2484 335044	среднее профессиональное	6869
Панфил	Соболева	\N	82610998142	6932 129407	среднее профессиональное	6870
Ефим	Ковалева	\N	8 (255) 083-0192	6015 362113	высшее	6871
Харитон	Щербаков	\N	8 (835) 597-38-62	4067 367986	высшее	6872
Зосима	Чернова	Борисовна	8 (610) 183-39-73	7438 967265	среднее	6873
Сильвестр	Шубин	\N	+7 (707) 263-7021	9452 668954	\N	6874
Климент	Шаров	Васильевич	+7 313 305 43 22	7523 857430	высшее	6875
Светлана	Корнилов	Вячеславовна	+7 (242) 369-4953	7759 909726	высшее	6876
Евлампий	Морозов	Макаровна	82513707184	6606 601772	высшее	6877
Владислав	Некрасова	Валерьянович	8 313 680 52 77	8960 571531	среднее профессиональное	6878
Фадей	Кузнецова	\N	8 (660) 024-37-92	2584 419140	\N	6879
Мариан	Комиссаров	Фокич	+7 (705) 596-7903	5847 646906	высшее	6880
Герман	Корнилова	\N	8 930 018 1631	7557 531877	среднее	6881
Филипп	Кулакова	\N	+78498227028	6667 305058	среднее профессиональное	6882
Ратмир	Мельникова	\N	+7 348 971 79 59	4688 373287	среднее профессиональное	6883
Глафира	Никифорова	Артемьевич	+7 (692) 041-0318	1526 817644	\N	6884
Борис	Максимов	\N	+7 044 527 4930	4167 220316	неоконченное высшее	6885
Лучезар	Савельева	\N	+7 (645) 480-86-89	1195 960756	неоконченное высшее	6886
Доброслав	Фокин	Геннадиевна	88419939850	6667 814878	высшее	6887
Евпраксия	Воробьев	Геннадиевна	+7 128 096 4069	2729 246824	неоконченное высшее	6888
Мирослав	Федоров	\N	+7 (072) 208-46-36	6659 660163	неоконченное высшее	6889
Всеволод	Голубев	\N	+75600860210	3730 219872	среднее профессиональное	6890
Боян	Мартынова	Измаилович	8 253 374 7558	2694 406354	неоконченное высшее	6891
Вячеслав	Кириллова	Дмитриевна	82258696508	4421 867649	среднее	6892
Марина	Фомичев	Тимурович	+7 (131) 166-40-02	6708 330778	неоконченное высшее	6893
Тимофей	Горбачев	\N	8 518 799 1842	5765 601745	среднее профессиональное	6894
Ермил	Крюков	Денисович	+7 479 097 13 98	8983 427397	высшее	6895
Феофан	Анисимова	Эдуардович	+77222993342	2738 984747	среднее	6896
Сократ	Михеева	\N	8 (721) 156-9827	1072 572201	высшее	6897
Чеслав	Ермаков	\N	+7 (980) 212-05-69	5873 497618	\N	6898
Трифон	Князев	\N	8 (490) 813-42-10	7725 311769	высшее	6899
Мечислав	Артемьев	Валентиновна	+7 (631) 997-8454	4014 687253	\N	6900
Конон	Ковалева	Арсенович	+7 (351) 133-0510	8843 907527	неоконченное высшее	6901
Сильвестр	Кузнецов	\N	+7 (324) 277-02-46	5519 415852	среднее профессиональное	6902
Авдей	Горбунов	Вениаминовна	+7 225 250 7723	8069 366277	среднее	6903
Илья	Игнатов	\N	8 (633) 578-08-63	3950 590725	среднее профессиональное	6904
Олимпий	Самойлова	Тимурович	+72947626368	9781 731004	высшее	6905
Артем	Романова	\N	8 593 522 9351	6985 276400	среднее профессиональное	6906
Нинель	Котов	Фадеевич	8 931 664 1595	3199 415687	\N	6907
Зосима	Казакова	\N	8 666 989 21 09	2100 446627	среднее профессиональное	6908
Феврония	Орехов	\N	+7 169 446 7447	3100 424774	высшее	6909
Каллистрат	Родионов	Владимировна	8 (189) 296-5984	4594 266809	среднее	6910
Акулина	Моисеева	Фёдорович	+7 (639) 185-2038	5279 292788	среднее профессиональное	6911
Ферапонт	Галкина	\N	88907019479	3671 812178	среднее	6912
Таисия	Фомичева	\N	8 782 721 4863	6159 947302	среднее профессиональное	6913
Василиса	Макаров	Харлампович	8 (128) 545-6705	4284 778464	среднее	6914
Ермолай	Баранов	\N	+7 (795) 079-02-47	9780 603592	среднее	6915
Вышеслав	Ермаков	Эдуардовна	8 (446) 785-69-23	8458 265698	\N	6916
Наина	Чернова	Ануфриевич	8 (328) 168-31-54	6503 775221	высшее	6917
Виктория	Котов	\N	8 (703) 939-10-13	5467 935127	высшее	6918
Эмиль	Гордеева	\N	8 (632) 187-8395	6001 622860	среднее профессиональное	6919
Флорентин	Кулаков	\N	8 (049) 736-15-47	3365 204089	среднее	6920
Агафон	Крюков	Харитоновна	+70319088995	7258 978837	неоконченное высшее	6921
Ерофей	Харитонов	Гавриилович	+7 709 854 54 66	1004 790191	среднее профессиональное	6922
Ирина	Жукова	\N	8 (117) 941-5378	7059 527528	неоконченное высшее	6923
Епифан	Лобанова	Фролович	+7 571 896 36 66	9955 346731	среднее	6924
Константин	Белов	\N	+7 915 240 6410	5403 860335	среднее профессиональное	6925
Лидия	Дмитриева	Тарасовна	+7 (650) 451-2666	2550 811072	среднее	6926
Бажен	Мясникова	\N	8 (370) 167-6300	7721 839624	среднее	6927
Марк	Ершова	\N	+7 713 802 7504	8124 409040	высшее	6928
Любосмысл	Шарова	\N	+7 330 798 7679	8170 119688	\N	6929
Ефрем	Игнатов	\N	+7 616 217 51 93	1717 396645	\N	6930
Карл	Панфилова	Матвеевич	+7 (838) 691-81-90	2756 503256	неоконченное высшее	6931
Твердислав	Галкина	Антипович	+7 686 062 47 31	8326 940362	высшее	6932
Алевтина	Калашников	\N	+7 (937) 416-1970	6573 473532	\N	6933
Анжела	Горбунов	\N	85498878722	1620 543283	неоконченное высшее	6934
Анатолий	Григорьев	\N	8 367 666 2429	5790 994278	среднее профессиональное	6935
Бронислав	Беспалова	Демидович	8 (296) 719-80-33	7927 282238	неоконченное высшее	6936
Митофан	Власова	Валериевна	+7 (983) 793-99-99	8582 769022	высшее	6937
Павел	Громов	\N	+7 (861) 581-6417	3535 279822	среднее	6938
Прокл	Федотов	Ильич	8 (283) 883-8168	4232 480525	неоконченное высшее	6939
Фрол	Титов	\N	+7 779 597 95 55	7577 817447	\N	6940
Радим	Жданова	Исидорович	+78139909304	5620 818763	неоконченное высшее	6941
Ананий	Калинина	Артемьевич	+74410766326	8600 345010	высшее	6942
Нинель	Петрова	Валерианович	8 (990) 858-4924	1197 873123	\N	6943
Фёкла	Суханова	Ермолаевич	+7 589 689 5517	6571 559039	\N	6944
Давыд	Орлов	Еремеевич	8 822 148 0232	9175 361816	\N	6945
Август	Богданова	Владимировна	8 234 061 16 61	7546 715943	неоконченное высшее	6946
Семен	Горшкова	\N	+7 744 260 58 59	7029 284634	среднее	6947
Аникей	Горбачева	Герасимович	+7 669 755 5842	9508 848425	неоконченное высшее	6948
Радован	Филиппов	Тимурович	+79746181363	1205 186250	высшее	6949
Ладимир	Меркушева	Егорович	+7 (056) 748-59-23	7702 559206	среднее профессиональное	6950
Алина	Денисова	Матвеевна	8 394 829 52 08	4317 761537	среднее профессиональное	6951
Мария	Шубин	\N	+7 (233) 102-6994	8419 693639	высшее	6952
Октябрина	Сазонова	\N	+7 748 039 12 03	5262 316703	среднее	6953
Артемий	Миронов	\N	+76224052524	4717 549738	среднее профессиональное	6954
Моисей	Дроздова	\N	+76951085716	3131 694516	среднее	6955
Дорофей	Егоров	\N	8 (343) 430-86-01	5571 752834	\N	6956
Лидия	Веселов	Владимировна	+7 (820) 294-6875	6739 362805	среднее	6957
Максим	Крюкова	Демидович	+7 (325) 152-7714	7887 257730	среднее профессиональное	6958
Ювеналий	Маслова	\N	+7 631 909 17 47	4060 817374	среднее	6959
Эраст	Шарова	Михайловна	+7 244 051 2033	3343 688848	неоконченное высшее	6960
Сидор	Гурьева	\N	+7 071 917 3585	6388 827324	среднее	6961
Вышеслав	Яковлев	\N	8 (457) 431-27-63	9052 328811	\N	6962
Наина	Горшков	Игнатович	8 505 985 46 67	3796 714897	среднее профессиональное	6963
Карл	Дементьева	Альбертовна	+72167860564	4042 650975	неоконченное высшее	6964
Кузьма	Ефремова	Феофанович	83692857398	2985 631887	среднее профессиональное	6965
Аникей	Петрова	\N	+7 (540) 887-5890	4121 965052	\N	6966
Адриан	Киселева	\N	+7 974 873 9890	5182 684976	\N	6967
Натан	Жукова	Альбертовна	8 459 639 8630	6254 639371	среднее	6968
Арсений	Вишнякова	Дорофеевич	8 095 993 25 46	8064 812299	высшее	6969
Ярополк	Морозова	Филипповна	8 (556) 489-4301	6996 289262	среднее	6970
Творимир	Зимина	\N	+7 712 919 79 82	9197 247307	среднее профессиональное	6971
Демид	Константинова	Демидович	8 (329) 759-8166	9771 831818	среднее	6972
Кир	Колобов	Тимофеевна	+7 538 492 7714	9314 501049	неоконченное высшее	6973
Фока	Ершова	\N	89605135450	7182 154460	неоконченное высшее	6974
Валерия	Третьяков	Борисович	+79873375635	5147 853635	неоконченное высшее	6975
Зиновий	Кудрявцева	\N	+7 (347) 140-4900	5518 463032	\N	6976
Алина	Горбачев	Елисеевич	8 648 784 29 13	6447 152895	высшее	6977
Мартьян	Пестова	\N	+7 715 958 0988	4506 768178	\N	6978
Спартак	Мухин	\N	+7 (150) 948-6661	4238 253237	неоконченное высшее	6979
Капитон	Харитонов	\N	+7 139 311 50 70	8358 850531	высшее	6980
Терентий	Воронов	Адамович	8 (131) 732-77-30	4346 659437	\N	6981
Фортунат	Логинова	Арсеньевич	8 193 496 7749	9014 843058	неоконченное высшее	6982
Агафья	Савельева	\N	+79872709891	6888 435120	среднее	6983
Карл	Куликов	Павловна	+7 156 890 78 66	3064 301858	\N	6984
Николай	Власов	\N	84092631567	9619 946779	среднее	6985
Трифон	Владимирова	Фёдорович	+7 (635) 097-94-43	7254 173750	среднее	6986
Будимир	Блохина	Арсеньевич	8 (862) 451-8365	5972 286279	среднее профессиональное	6987
Лукьян	Новикова	Владленович	+7 (123) 705-00-39	4880 393566	высшее	6988
Кузьма	Воронцова	\N	8 (568) 123-19-90	5270 170447	среднее	6989
Георгий	Колобова	Виленович	8 (536) 953-70-92	8102 362142	среднее профессиональное	6990
Антонин	Иванов	Денисович	8 408 716 7264	4753 918922	неоконченное высшее	6991
Людмила	Жукова	\N	+7 (844) 342-5179	4582 205079	высшее	6992
Гедеон	Гусева	Филатович	8 (716) 574-3694	9540 192996	неоконченное высшее	6993
Севастьян	Веселова	Демьянович	+76311490272	6338 368719	высшее	6994
Изяслав	Зуева	\N	8 (545) 131-71-19	2394 890760	\N	6995
Илья	Нестеров	Святославовна	8 (084) 045-1367	1541 634436	среднее	6996
Наркис	Осипов	\N	+7 279 529 6129	1896 463426	среднее	6997
Якуб	Субботин	Ермолаевич	+7 419 801 18 60	5695 989840	неоконченное высшее	6998
Екатерина	Родионов	Аскольдовна	8 989 023 51 03	7608 517821	среднее	6999
Остап	Гаврилов	\N	8 592 945 1410	7357 991144	\N	7000
Валерьян	Белоусов	\N	80993860434	5350 116891	среднее	7001
Феврония	Дорофеев	Арсеньевич	+7 107 772 94 41	5651 758627	высшее	7002
Раиса	Логинова	\N	+74060293559	4552 493119	среднее профессиональное	7003
Савелий	Яковлева	\N	+7 863 656 96 30	7366 180134	неоконченное высшее	7004
Трофим	Мамонтов	Робертовна	+7 (923) 354-2608	8541 245448	среднее	7005
Мирон	Рогов	\N	+7 230 252 58 97	2830 425486	среднее профессиональное	7006
Олег	Ефремов	Геннадиевна	+74989145827	7796 990062	\N	7007
Ольга	Киселев	\N	+75745916474	1585 522475	среднее профессиональное	7008
Денис	Зыкова	\N	8 (845) 208-8155	4626 597400	\N	7009
Алексей	Кондратьева	\N	8 188 774 1175	8459 926270	среднее	7010
Панкратий	Сысоев	Эдгарович	+7 223 077 13 69	6172 504100	высшее	7011
Евстигней	Мартынова	\N	+7 674 450 39 77	4693 274407	\N	7012
Иван	Воронцов	\N	8 306 120 0341	7291 201939	\N	7013
Галина	Гурьев	\N	+7 089 094 87 32	6814 133850	высшее	7014
Лора	Федотова	\N	+7 098 751 6735	8423 761464	среднее	7015
Аким	Орлов	\N	88180465823	2134 119661	среднее профессиональное	7016
Геннадий	Кабанов	\N	+7 233 216 1210	3867 797239	среднее	7017
Антонина	Князева	\N	+7 (496) 598-2330	9394 294031	среднее	7018
Панкратий	Лаврентьева	Олеговна	8 (427) 714-4260	7562 665665	неоконченное высшее	7019
Галина	Доронин	\N	+7 784 391 33 06	5634 614324	\N	7020
Ипатий	Горбунов	\N	8 (929) 336-86-82	3990 664732	неоконченное высшее	7021
Любосмысл	Федосеев	Викентьевич	8 940 390 9302	6863 918506	неоконченное высшее	7022
Григорий	Дорофеева	\N	+7 200 173 0093	9858 447865	среднее профессиональное	7023
Харлампий	Самсонова	\N	+7 (888) 592-6835	6757 386006	неоконченное высшее	7024
Ладислав	Владимирова	Альбертовна	8 (856) 754-52-63	2763 382773	\N	7025
Эммануил	Тимофеев	\N	89529883582	9371 334942	\N	7026
Чеслав	Аксенов	\N	+7 459 946 6174	4019 482902	высшее	7027
Стоян	Евсеева	\N	+7 (719) 974-73-15	9739 832551	среднее профессиональное	7028
Родион	Белова	\N	8 307 221 37 81	3867 142745	высшее	7029
Андроник	Назаров	\N	81932716681	9560 701535	среднее	7030
Пахом	Громов	Данилович	8 (159) 516-27-65	6680 799165	высшее	7031
Онуфрий	Попов	\N	8 157 991 77 14	3503 769519	высшее	7095
Афиноген	Турова	\N	+7 299 261 03 57	3095 193589	среднее профессиональное	7032
Никанор	Кондратьева	Матвеевич	+74405790521	1675 867245	неоконченное высшее	7033
Валерьян	Мухина	\N	+7 923 515 27 44	4803 745737	высшее	7034
Лукия	Селезнева	\N	8 469 473 43 75	5983 272443	среднее профессиональное	7035
Аггей	Дмитриев	\N	8 340 462 53 81	4780 173916	высшее	7036
Елена	Воронцова	Давидович	+76837205901	4005 491769	среднее	7037
Андроник	Захарова	\N	+76836496371	7638 940243	высшее	7038
Ерофей	Денисова	\N	+7 (058) 517-0953	3960 792473	высшее	7039
Филарет	Якушева	\N	8 (664) 993-95-03	8872 842873	высшее	7040
Олег	Сорокина	Фокич	81373089403	1923 861032	неоконченное высшее	7041
Лев	Гущин	\N	8 040 205 68 84	2204 836906	высшее	7042
Екатерина	Воробьев	\N	+7 075 406 59 60	8011 494601	неоконченное высшее	7043
Софрон	Суханов	Игнатьевич	+7 (642) 830-21-83	2912 929996	неоконченное высшее	7044
Галактион	Кузнецова	Зиновьевич	8 712 679 2102	5382 240649	\N	7045
Демьян	Якушев	\N	+7 (475) 195-6985	4463 596243	среднее	7046
Софон	Гурьева	\N	8 (571) 057-8861	9643 673418	\N	7047
Анна	Ширяев	Матвеевна	8 (742) 922-97-36	3057 759777	среднее	7048
Кира	Горбачева	\N	+7 (035) 980-36-30	6836 254377	неоконченное высшее	7049
Филимон	Селиверстова	\N	+7 (397) 338-1833	1508 561593	среднее	7050
Адам	Кабанов	\N	80618768048	8571 312653	высшее	7051
Валерьян	Маркова	Геннадьевна	8 (820) 595-5788	4942 199943	среднее	7052
Владлен	Попов	Трифонович	+7 (133) 515-2016	7796 755878	\N	7053
Орест	Блохина	\N	+7 (348) 484-2449	4812 694014	среднее профессиональное	7054
Данила	Зыкова	Владиславович	+7 (743) 539-75-96	8408 783473	высшее	7055
Аскольд	Журавлев	\N	8 (989) 193-2028	9551 866309	\N	7056
Филарет	Копылов	Валерьевич	8 (521) 574-02-79	5452 923768	высшее	7057
Никандр	Анисимова	Юльевна	8 952 755 2633	1600 605719	среднее	7058
Никифор	Калашникова	\N	8 273 515 83 85	5226 712625	среднее	7059
Бажен	Виноградов	Аксёнович	+7 073 069 05 22	2036 814124	среднее профессиональное	7060
Станислав	Воронов	Ермолаевич	81167630808	6737 515966	\N	7061
Богдан	Матвеев	Филипповна	80641048560	2083 943603	среднее	7062
Владилен	Голубев	Богданович	+7 954 005 3608	6315 194568	среднее профессиональное	7063
Клавдий	Кулаков	Валентинович	+7 554 148 40 88	6385 292283	\N	7064
Казимир	Поляков	\N	+7 (570) 967-9653	3063 206735	высшее	7065
Виталий	Филиппова	\N	8 821 432 00 92	7048 197867	неоконченное высшее	7066
Олег	Мясников	Алексеевна	+73621284126	8503 427983	неоконченное высшее	7067
Демид	Рогов	Игоревна	8 419 028 61 47	2233 342688	среднее профессиональное	7068
Сильвестр	Казаков	Марсович	80804906068	5642 959222	неоконченное высшее	7069
Богдан	Назарова	Аскольдовна	87073264832	6465 594687	среднее профессиональное	7070
Валентина	Власов	\N	8 555 364 9044	6997 711143	среднее	7071
Ювеналий	Рыбакова	\N	+7 (348) 080-91-17	5554 915814	высшее	7072
Олег	Самсонова	Ааронович	+7 (311) 348-54-32	7817 234793	среднее профессиональное	7073
Лариса	Фомин	Адрианович	+7 (558) 934-0909	4774 347444	\N	7074
Лариса	Пахомов	\N	+7 055 260 4316	9211 537772	\N	7075
Аникита	Герасимова	\N	8 (813) 631-5543	1923 158312	среднее профессиональное	7076
Кирилл	Сысоева	\N	+75732301127	1848 960091	высшее	7077
Казимир	Лукина	\N	88068666640	8611 680956	среднее	7078
Екатерина	Третьякова	\N	8 (754) 823-86-42	6707 811723	среднее	7079
Аверкий	Архипова	Якубович	+7 (653) 803-98-07	7282 739758	неоконченное высшее	7080
Святослав	Шарапова	Германович	8 565 861 38 27	9902 972889	среднее	7081
Аверьян	Панова	Викторович	8 (602) 876-01-42	4298 749563	среднее профессиональное	7082
Мартын	Яковлева	\N	+76213904395	3706 861647	неоконченное высшее	7083
Кондратий	Степанов	\N	+7 (631) 672-7958	8306 896349	высшее	7084
Эдуард	Ефимова	Робертовна	84582109969	6755 953167	\N	7085
Вениамин	Колобов	Андреевич	+7 (175) 238-9869	7672 372351	высшее	7086
Ипполит	Агафонова	\N	+7 (251) 531-5625	4408 637057	неоконченное высшее	7087
Фадей	Павлова	Ефремович	8 937 671 9899	9061 726790	\N	7088
Федосий	Баранова	\N	81349007151	8574 255158	среднее	7089
Эрнст	Агафонова	\N	+7 526 401 3390	5842 970474	неоконченное высшее	7090
Кирилл	Артемьев	Яковлевич	+7 522 609 7653	8941 401624	\N	7091
Спиридон	Жукова	Егоровна	+70257317968	1806 541612	среднее	7092
Авдей	Савельева	Станиславовна	+7 (614) 093-94-62	9948 344563	высшее	7093
Лора	Зуева	Адрианович	+7 (823) 927-68-33	1430 966028	среднее	7094
Федот	Брагина	\N	+7 242 859 0586	9685 713566	неоконченное высшее	7096
Любомир	Хохлова	\N	+7 (151) 829-61-29	8658 459025	среднее профессиональное	7097
Аникита	Гордеева	\N	8 664 108 9191	6219 854344	среднее профессиональное	7098
Олимпий	Савина	\N	+7 877 347 3470	3399 908284	среднее	7099
Мария	Копылова	\N	+7 (559) 527-28-22	9841 136608	среднее профессиональное	7100
Александр	Уваров	Борисович	8 (251) 480-9892	5759 180575	высшее	7101
Вера	Якушева	Рудольфовна	8 (464) 981-4921	7484 614062	среднее профессиональное	7102
Юлия	Устинова	Евгеньевна	81837414717	5645 674637	высшее	7103
Аристарх	Кузнецова	Харламович	8 147 366 0160	6739 358317	среднее профессиональное	7104
Ерофей	Морозов	Олеговна	84187099925	1676 687429	среднее	7105
Прокофий	Гришин	Васильевна	85913222491	6778 495376	среднее	7106
Аристарх	Лукина	\N	88356277799	5595 145206	неоконченное высшее	7107
Вацлав	Ширяева	\N	+7 (381) 811-34-85	7920 428125	неоконченное высшее	7108
Исай	Афанасьева	Кузьминична	+7 (872) 872-59-12	6747 291765	высшее	7109
Амвросий	Евсеева	\N	8 729 711 68 80	6268 567470	высшее	7110
Всемил	Хохлов	\N	+7 677 475 73 24	9219 345583	среднее	7111
Виссарион	Семенова	\N	8 (279) 720-7347	2628 870406	неоконченное высшее	7112
Яков	Нестеров	\N	8 362 463 28 14	7661 192049	среднее профессиональное	7113
Феофан	Кононов	Вадимовна	+73420150373	6359 730829	среднее профессиональное	7114
Остап	Блинова	\N	8 (010) 278-8178	7794 187427	среднее	7115
Куприян	Носков	Борисович	8 289 399 9669	9891 144294	высшее	7116
Лукьян	Некрасов	Германович	+77236026948	3017 520132	\N	7117
Валерьян	Силина	Харламович	85217349250	8798 592447	высшее	7118
Евлампий	Титова	Гертрудович	8 819 708 03 16	2144 592877	среднее профессиональное	7119
Аким	Орлов	\N	+7 402 366 21 14	5247 144064	среднее	7120
Пелагея	Аксенова	Брониславович	8 480 996 6030	3082 603611	высшее	7121
Венедикт	Лыткина	\N	+77096039617	2120 332633	неоконченное высшее	7122
Эмилия	Котова	\N	+7 513 974 16 80	8436 407539	среднее	7123
Денис	Ширяева	\N	+7 (248) 998-54-48	4257 635445	высшее	7124
Всеволод	Одинцов	\N	8 (705) 393-0908	5628 293819	неоконченное высшее	7125
Полина	Лаврентьева	\N	86325477662	9222 569172	неоконченное высшее	7126
Амос	Крылова	\N	+7 (293) 250-97-62	2042 291005	среднее профессиональное	7127
Игнатий	Тимофеев	\N	8 963 894 9197	3179 289827	среднее профессиональное	7128
Ефрем	Игнатьева	\N	+7 (627) 900-02-34	6259 936205	неоконченное высшее	7129
Лучезар	Жданова	\N	8 (703) 268-76-97	5075 369425	\N	7130
Захар	Поляков	\N	+7 054 377 97 74	7599 979332	неоконченное высшее	7131
Милован	Корнилов	\N	8 (702) 606-24-18	5036 223294	неоконченное высшее	7132
Юлиан	Молчанов	Афанасьевич	+7 (058) 996-67-92	3368 429612	среднее профессиональное	7133
Вениамин	Кириллов	Демидович	+7 (027) 056-50-01	2869 918467	неоконченное высшее	7134
Авксентий	Одинцов	\N	+7 661 343 74 50	2845 342324	неоконченное высшее	7135
Ипполит	Семенов	Павловна	+7 (541) 476-3234	3911 646089	высшее	7136
Ладислав	Лыткина	\N	8 125 623 70 76	2640 511379	высшее	7137
Евсей	Абрамова	\N	8 384 434 6384	1201 458523	среднее профессиональное	7138
Гордей	Куликов	\N	+7 (107) 752-5331	8337 522337	высшее	7139
Аникита	Комаров	\N	+74926785865	6355 191640	\N	7140
Галактион	Ковалев	\N	+7 996 447 2060	1970 879391	среднее профессиональное	7141
Максим	Дроздов	\N	+7 (586) 956-92-79	6711 475891	высшее	7142
Казимир	Николаева	\N	+7 955 327 50 83	7694 286539	высшее	7143
Осип	Сафонова	\N	8 (703) 125-99-35	9278 130249	неоконченное высшее	7144
Матвей	Семенов	Ефремович	8 (447) 335-68-02	9086 682984	неоконченное высшее	7145
Евстафий	Котова	Феоктистович	+7 (583) 738-4799	5053 329167	среднее	7146
Исидор	Семенова	\N	+7 (294) 717-87-70	9613 603040	среднее	7147
Аполлинарий	Чернова	\N	+73447656358	9275 811289	среднее	7148
Фадей	Ермакова	Вячеславович	8 841 487 0705	2805 556966	неоконченное высшее	7149
Спиридон	Мухин	\N	+7 410 811 3110	5999 990579	среднее	7150
Мстислав	Русаков	Вениаминовна	88202022538	1179 252386	\N	7151
Флорентин	Назаров	\N	85260574211	2659 171126	среднее	7152
Никита	Орехова	\N	+7 (394) 457-86-63	2595 407020	среднее	7153
Галина	Беспалов	\N	8 515 928 72 14	7660 899662	высшее	7154
Емельян	Родионов	\N	8 035 628 0267	2832 436355	среднее профессиональное	7155
Самуил	Савин	\N	81494556571	1928 328728	неоконченное высшее	7156
Александра	Журавлев	\N	+7 371 795 47 32	3755 660985	среднее профессиональное	7157
Лазарь	Пахомов	Демьянович	+7 624 885 7827	7636 200986	неоконченное высшее	7158
Никита	Гурьев	\N	+7 024 890 63 67	8492 449103	высшее	7159
Чеслав	Борисов	Витальевич	+79030243877	6081 761083	неоконченное высшее	7160
Всемил	Субботина	Захарьевич	+7 (112) 935-8901	7814 789378	среднее профессиональное	7161
Афанасий	Колесников	\N	8 362 071 55 20	8597 970919	\N	7162
Панфил	Жуков	Теймуразович	8 (627) 260-1949	4616 790315	среднее	7163
Нина	Мухин	Борисовна	+7 (217) 025-81-94	5579 615802	среднее профессиональное	7164
Владилен	Алексеева	\N	8 461 483 2525	5320 425516	неоконченное высшее	7165
Авксентий	Носова	\N	8 (676) 102-34-79	5957 571129	высшее	7166
Каллистрат	Копылов	\N	+7 (791) 568-85-14	4793 238069	высшее	7167
Ростислав	Корнилов	Демьянович	+7 (102) 730-74-16	9143 917299	\N	7168
Гремислав	Макарова	Макаровна	+7 (611) 556-78-26	4900 517159	среднее	7169
Федосий	Ершова	Тарасович	+7 076 538 28 60	4897 346285	высшее	7170
Гордей	Мартынов	Владиславович	+7 (354) 410-3718	3978 158834	среднее	7171
Зоя	Зиновьев	Якубович	8 (116) 535-3346	1400 108914	\N	7172
Владлен	Мамонтова	\N	8 039 343 4019	6331 136189	среднее	7173
Азарий	Сафонова	\N	8 508 325 25 33	9235 575960	высшее	7174
Ираклий	Денисов	\N	+7 (699) 229-62-77	8902 493420	неоконченное высшее	7175
Елизавета	Красильников	Гаврилович	+7 023 365 8345	5383 412581	высшее	7176
Любовь	Родионова	Федоровна	8 (333) 081-3606	4288 270201	среднее профессиональное	7177
Орест	Коновалов	\N	+72643627743	9629 559729	среднее	7178
Савелий	Морозова	Геннадиевич	+73771272602	7708 574265	среднее	7179
Прокл	Дмитриев	Степановна	+7 864 106 9882	6193 607908	неоконченное высшее	7180
Милий	Пахомов	\N	+7 814 623 50 37	8664 651827	среднее профессиональное	7181
Майя	Алексеев	Виленович	+7 949 693 52 95	6980 557192	высшее	7182
Антонина	Герасимов	Гордеевич	+7 991 504 7759	7057 914514	среднее	7183
Октябрина	Дьячкова	\N	88175110674	2501 844755	среднее профессиональное	7184
Виталий	Блинов	Федосьевич	86180750262	3872 593099	среднее профессиональное	7185
Герасим	Михайлова	Глебович	+7 (229) 573-9617	3564 393242	среднее профессиональное	7186
Никодим	Соболева	\N	8 (966) 870-17-29	7753 185455	среднее	7187
Фаина	Лыткин	\N	8 (614) 279-3240	5669 345595	\N	7188
Станислав	Ершова	\N	+7 (712) 079-8095	2753 706043	\N	7189
Твердислав	Беляева	\N	8 553 889 64 42	7907 393671	неоконченное высшее	7190
Бажен	Матвеев	\N	+7 (738) 505-44-99	9477 490933	среднее профессиональное	7191
Варфоломей	Самойлов	Петровна	+7 (621) 866-83-18	8650 714994	среднее	7192
Платон	Гордеев	\N	8 956 842 17 77	1441 669755	высшее	7193
Самсон	Филатов	\N	8 468 757 1176	6316 944646	среднее профессиональное	7194
Доброслав	Доронин	Данилович	8 913 339 54 64	2128 850395	высшее	7195
Милий	Поляков	Абрамович	+7 (595) 712-7604	4890 235472	высшее	7196
Тамара	Меркушев	\N	8 659 841 0186	8812 126061	высшее	7197
Боян	Ильин	\N	+7 744 398 3975	2535 555002	высшее	7198
Мариан	Трофимов	\N	84308991538	3177 869707	высшее	7199
Емельян	Пономарев	\N	8 240 494 2964	6165 278937	среднее профессиональное	7200
Якуб	Маслов	\N	8 (360) 999-9085	2304 240957	среднее	7201
Трофим	Яковлев	\N	+7 510 566 2568	2158 668652	среднее	7202
Харлампий	Сергеева	Дмитриевна	8 532 089 00 80	3195 172117	\N	7203
Варвара	Белякова	\N	+78201621888	5677 185091	среднее	7204
Алексей	Филиппова	Харлампьевич	+7 (306) 379-37-84	3758 241841	неоконченное высшее	7205
Творимир	Елисеева	Исидорович	8 965 467 88 80	3687 949967	высшее	7206
Чеслав	Мишина	\N	+78658730910	8540 718061	среднее профессиональное	7207
Ипполит	Муравьев	\N	+74891469281	1141 749521	\N	7208
Лора	Кириллова	Ефимовна	+7 132 894 80 91	1859 752765	высшее	7209
Ананий	Цветков	Ефимович	+7 (938) 743-97-42	8816 725423	среднее	7210
Милен	Быкова	\N	+7 (415) 516-3214	7644 569333	высшее	7211
Гостомысл	Баранова	\N	+7 (975) 214-8673	6769 416136	\N	7212
Евсей	Гущин	Харламович	8 (131) 352-58-63	1679 223151	высшее	7213
Трифон	Громов	Августович	+7 293 117 10 25	9723 350257	\N	7214
Платон	Рябов	\N	+7 672 048 15 22	6182 526288	среднее	7215
Аркадий	Цветкова	\N	+7 140 431 94 31	7885 203028	среднее	7216
Лука	Ермаков	Григорьевна	8 711 831 25 66	9743 681850	неоконченное высшее	7217
Игорь	Тарасова	Феоктистович	81280862492	6933 349044	\N	7218
Егор	Никифоров	Геннадиевич	+7 500 580 5081	2528 165456	неоконченное высшее	7219
Мстислав	Петухова	Евгеньевна	+7 258 383 18 84	1896 258467	\N	7220
Виталий	Веселова	\N	8 (900) 012-4227	5109 652299	среднее	7223
Валентина	Баранова	Сергеевна	+7 647 395 40 17	9722 956947	неоконченное высшее	7224
Станислав	Поляков	\N	8 745 644 42 64	9730 845702	\N	7225
Дарья	Панов	Богданович	8 161 854 4171	2549 430834	среднее профессиональное	7226
Аристарх	Егоров	\N	+7 (179) 449-68-41	9253 853998	высшее	7227
Марфа	Петров	Андреевич	+7 848 591 5323	5238 325080	среднее	7228
Владимир	Федосеева	\N	8 537 301 15 11	5849 630716	среднее	7229
Жанна	Суворов	\N	+7 786 929 05 03	3166 184980	неоконченное высшее	7230
Еремей	Воробьева	\N	+7 234 267 70 87	4797 933604	неоконченное высшее	7231
Раиса	Михайлова	Викентьевич	83758405116	7933 504348	неоконченное высшее	7232
Зиновий	Емельянов	Изотович	+7 (882) 006-62-84	1161 771904	среднее	7233
Добромысл	Виноградов	\N	85579740916	2234 747052	среднее профессиональное	7234
Онуфрий	Прохорова	Иларионович	+7 872 877 92 50	7218 966859	\N	7235
Каллистрат	Суворова	\N	+7 102 328 0751	6074 756196	неоконченное высшее	7236
Вера	Доронина	\N	8 729 848 87 49	8245 467438	\N	7237
Селиверст	Козлова	Феофанович	+7 (841) 081-9775	9174 249644	\N	7238
Ефим	Мамонтова	\N	8 (064) 391-5014	6409 440419	\N	7239
Артем	Орлов	Захаровна	+7 (666) 331-2344	5143 675548	\N	7240
Роман	Титова	\N	8 (010) 670-90-57	7312 480811	среднее	7241
Нестор	Юдина	\N	+7 824 503 7653	6120 137982	высшее	7242
Ким	Симонова	\N	+7 (823) 404-60-38	7744 713358	среднее профессиональное	7243
Изяслав	Комиссаров	\N	+7 467 878 22 00	3750 814651	\N	7244
Венедикт	Мельникова	Дмитриевна	+7 (466) 085-4388	2466 597751	неоконченное высшее	7245
Ерофей	Князева	Эдгардович	+7 (820) 573-2689	9896 150873	неоконченное высшее	7246
Евлампий	Дроздов	\N	8 (234) 296-72-72	6320 625546	\N	7247
Лонгин	Смирнов	Эльдаровна	84428074911	4978 843890	среднее профессиональное	7248
Иннокентий	Поляков	\N	+7 (019) 344-75-64	8325 720469	среднее профессиональное	7249
Руслан	Носкова	\N	8 (004) 658-2492	5464 452655	среднее профессиональное	7250
Кирилл	Афанасьева	Аксёнович	+7 (739) 947-8923	1474 834298	среднее	7251
Агата	Гусева	Ждановна	80982488857	8445 245014	среднее профессиональное	7252
Селиван	Елисеева	Виленович	8 (486) 844-3517	7026 268539	неоконченное высшее	7253
Клавдий	Фадеев	\N	8 (954) 764-69-79	2741 971326	среднее профессиональное	7254
Кондрат	Капустина	Федосьевич	8 703 646 13 26	4390 736685	среднее	7255
Эдуард	Зиновьев	Леонидовна	8 321 168 69 48	1019 233720	\N	7256
Евгения	Хохлов	Феликсович	+7 491 047 10 27	2795 621056	среднее профессиональное	7257
Емельян	Денисов	Артёмович	84784417842	7320 742132	\N	7258
Валерий	Кабанов	\N	+7 (446) 789-8710	6719 354835	среднее профессиональное	7259
Терентий	Кудряшов	\N	8 830 282 4380	7825 431779	высшее	7260
Всеслав	Лаврентьева	\N	8 400 578 03 64	3613 602571	среднее	7261
Аристарх	Смирнов	\N	8 (151) 940-3127	9272 893309	среднее профессиональное	7262
Корнил	Федотова	\N	+77843312549	7829 663969	среднее	7263
Изяслав	Ефремова	Евстигнеевич	+7 (761) 441-0154	8998 370563	среднее	7264
Милен	Мельников	\N	8 243 241 4042	7870 520835	среднее профессиональное	7265
Светозар	Никитин	\N	8 407 261 8071	2097 341118	среднее	7266
Юлиан	Гришина	\N	8 836 623 8708	2586 903651	среднее профессиональное	7267
Любовь	Александров	\N	+7 515 688 9256	3457 146886	среднее профессиональное	7268
Тарас	Емельянов	\N	8 104 121 2048	9971 246575	неоконченное высшее	7269
Сильвестр	Королева	\N	+7 (141) 150-6414	8605 489451	среднее профессиональное	7270
Велимир	Якушев	\N	+70401661469	4720 306030	среднее профессиональное	7271
Анжелика	Крюков	\N	+7 (451) 830-97-67	7209 878209	среднее	7272
Владимир	Горшков	Львовна	+78778839145	8330 349321	среднее профессиональное	7273
Станислав	Григорьева	\N	8 846 435 5425	4179 164176	высшее	7274
Мина	Харитонова	\N	+72484157845	5652 326864	среднее профессиональное	7275
Пимен	Гущин	\N	8 (994) 505-5734	4079 268172	высшее	7276
Евсей	Лебедев	Владленович	+7 494 827 2689	2621 704610	\N	7277
Вера	Рыбаков	\N	+75517171416	8955 165937	неоконченное высшее	7278
Егор	Гаврилов	Арсеньевич	+7 953 560 7375	3341 699584	неоконченное высшее	7279
Николай	Якушева	\N	+7 430 960 42 15	9829 974938	\N	7280
Эммануил	Доронина	\N	8 (059) 191-7557	7727 215776	высшее	7281
Леонтий	Дорофеева	\N	+7 (604) 953-34-20	5413 997301	среднее	7282
Аристарх	Ковалева	\N	8 (904) 939-54-51	1016 873704	высшее	7283
Феоктист	Туров	Терентьевич	8 269 862 34 80	2966 293172	среднее	7284
Андрей	Фомичев	\N	8 164 626 21 98	5899 254319	высшее	7286
Натан	Терентьева	\N	+76876330434	3397 509662	среднее профессиональное	7287
Евстигней	Зиновьева	\N	+7 (778) 270-41-06	7712 744528	среднее профессиональное	7288
Вадим	Крылов	Герасимович	8 266 851 2921	7666 456149	среднее профессиональное	7289
Пахом	Вишнякова	Валерьянович	8 (596) 103-2387	6080 769754	высшее	7290
Елена	Никитина	Юлианович	8 (281) 459-79-18	5049 399807	\N	7291
Алина	Селезнев	\N	8 548 870 29 40	1618 200933	высшее	7292
Валентина	Самойлов	\N	84662837451	7772 585243	среднее профессиональное	7293
Владислав	Лаврентьев	\N	+7 626 060 5816	7047 872538	среднее профессиональное	7294
Антип	Осипова	Юльевич	8 (111) 237-7444	3398 711125	среднее	7295
Светозар	Козлова	\N	+7 (073) 309-7676	5049 514429	среднее профессиональное	7296
Зосима	Зайцев	Львовна	8 251 401 53 90	7004 741117	неоконченное высшее	7297
Елизар	Рябов	\N	+7 879 322 7196	5473 680107	высшее	7298
Федот	Лапина	Юльевна	8 (520) 972-9231	6024 466872	среднее	7299
Никифор	Морозов	\N	+7 358 837 47 52	8308 387410	высшее	7300
Виктор	Терентьева	Антонович	+79779697004	2269 887144	неоконченное высшее	7301
Трофим	Родионова	Альбертовна	8 (662) 252-7309	8965 153554	высшее	7302
Агафья	Наумова	Арсеньевич	8 281 572 9852	1910 114131	среднее профессиональное	7303
Екатерина	Молчанов	Феликсович	+7 (643) 053-8454	7489 535060	\N	7304
Велимир	Исакова	Игнатьевич	+7 750 662 47 45	9446 187556	среднее	7305
Велимир	Беляков	\N	80825486638	9266 254944	высшее	7306
Стоян	Лаврентьев	Львовна	+7 (186) 044-3839	8774 852166	среднее профессиональное	7307
Аникей	Денисов	Харлампьевич	+74204732854	7339 734410	высшее	7308
Терентий	Якушев	Борисовна	+7 (111) 878-88-23	2654 510723	среднее	7309
Тамара	Григорьев	Измаилович	+7 611 879 4736	3502 710357	среднее	7310
Сила	Евсеева	\N	8 (529) 058-07-95	7522 731162	\N	7311
Тарас	Гуляева	Артемьевич	8 590 271 20 42	4962 814043	среднее профессиональное	7312
Ефим	Яковлева	Денисович	+7 129 332 6969	6899 643044	среднее	7313
Ермил	Бурова	\N	8 803 513 2543	3795 539401	неоконченное высшее	7314
Мария	Авдеев	Яковлевна	+7 836 483 57 08	3381 103128	высшее	7315
Никандр	Шестакова	Ефстафьевич	8 (552) 160-9958	6508 468602	среднее	7316
Демьян	Голубева	Артёмович	+7 (443) 074-2681	7595 540447	неоконченное высшее	7317
Никодим	Фокин	Владимировна	83073742038	5038 864694	высшее	7318
Ипат	Смирнов	Арсенович	+7 315 747 8203	6954 782887	среднее	7319
Филипп	Анисимов	Михайловна	+7 053 530 2790	1719 309465	\N	7320
Остап	Ковалев	\N	+7 823 624 80 54	9279 265504	среднее профессиональное	7321
Виссарион	Никифоров	\N	+73669444294	7048 530703	неоконченное высшее	7322
Лора	Макарова	Валерьянович	+7 027 573 44 86	2299 726405	среднее	7323
Сильвестр	Цветков	Евстигнеевич	+7 (664) 660-2267	3911 638519	среднее	7324
Елизавета	Горбунов	\N	8 (085) 888-8690	6192 112332	среднее	7325
Анисим	Дементьева	\N	87614997061	3255 159888	среднее	7326
Арефий	Андреев	Антипович	+7 (632) 386-89-48	4940 666059	среднее профессиональное	7327
Никандр	Алексеев	\N	8 (140) 125-7371	6449 703101	высшее	7328
Кондратий	Дорофеев	Александровна	+7 529 180 24 62	8055 540811	высшее	7329
Ольга	Одинцов	Антипович	8 (409) 227-8951	2695 509443	среднее	7330
Ольга	Маслова	\N	8 672 128 2145	9287 260112	высшее	7331
Алина	Быков	\N	+70589483654	2851 711144	среднее профессиональное	7332
Бажен	Воробьев	\N	+7 (440) 932-5260	2243 456188	неоконченное высшее	7333
Вадим	Казаков	\N	84558463010	9170 863543	неоконченное высшее	7334
Анастасия	Зимина	\N	8 (979) 902-2586	1787 397294	среднее	7335
Ладимир	Марков	Евстигнеевич	8 881 990 21 26	5087 408591	\N	7336
Иван	Тетерин	Аскольдовна	+79237695272	8122 542655	среднее	7337
Изяслав	Журавлева	\N	80469232929	6519 889758	неоконченное высшее	7338
Леонид	Дьячков	\N	+71374070575	3397 480163	среднее профессиональное	7339
Софрон	Силин	\N	80484484076	9159 243043	среднее	7340
Никон	Носова	Феодосьевич	8 (686) 645-47-66	2673 398263	среднее профессиональное	7341
Алексей	Дьячков	Денисович	8 (974) 361-0248	3748 619255	\N	7342
Любомир	Шубина	Викентьевич	+7 802 916 94 48	7871 190331	среднее	7343
Надежда	Беспалова	\N	8 (926) 560-67-81	2488 591834	неоконченное высшее	7344
Милен	Костин	Изотович	8 827 328 8318	5024 927527	\N	7345
Ермолай	Андреев	\N	8 (448) 795-09-57	2557 313816	неоконченное высшее	7346
Николай	Анисимов	\N	+7 272 342 81 37	7721 239970	неоконченное высшее	7347
Прохор	Степанова	\N	8 (615) 008-23-23	5806 784190	неоконченное высшее	7348
Творимир	Белова	Владимировна	8 203 004 5597	1461 617856	среднее	7349
Аскольд	Зыков	Афанасьевич	+7 (180) 118-04-18	8829 104942	среднее	7350
Мокей	Мухин	\N	8 202 023 02 49	5975 560225	\N	7351
Петр	Фомичева	Николаевна	+7 470 438 13 64	8232 239437	среднее	7352
Алексей	Власова	\N	8 625 594 4826	3615 613827	неоконченное высшее	7353
Аникей	Гришина	Яковлевна	82913173315	6878 962547	высшее	7354
Ким	Исакова	\N	82145456218	8535 533932	высшее	7355
Мокей	Пахомова	\N	8 (060) 007-8772	4582 241201	среднее профессиональное	7356
Доброслав	Маслова	\N	89239165732	5467 349338	неоконченное высшее	7357
Болеслав	Михеева	Мироновна	8 785 181 8554	9219 229624	неоконченное высшее	7358
Федот	Лобанов	Никифоровна	+7 181 508 7807	3609 184619	\N	7359
Фаина	Доронин	\N	+7 140 817 2703	1547 884924	среднее	7360
Исай	Лобанова	\N	+7 (884) 725-8252	5305 993763	среднее	7361
Виссарион	Павлов	\N	+7 (087) 389-9532	7175 639066	\N	7362
Тамара	Евсеев	Владиславович	83259314194	8391 828368	неоконченное высшее	7363
Ипатий	Казаков	Ильинична	+7 (982) 514-60-82	9463 988640	неоконченное высшее	7364
Галактион	Мартынов	Тимурович	8 926 524 3466	8222 880518	среднее	7365
Ермолай	Наумова	\N	8 (647) 793-1330	9557 713805	среднее	7366
Агап	Поляков	\N	+7 (806) 550-98-50	9321 438569	среднее	7367
Василиса	Чернова	\N	8 (488) 996-59-19	1828 554481	среднее	7368
Болеслав	Никитина	Всеволодович	8 297 685 92 25	5884 422068	\N	7369
Венедикт	Селиверстова	\N	+7 (763) 612-72-77	3752 890032	неоконченное высшее	7370
Пелагея	Михеев	Абрамович	81824721989	6698 833525	среднее	7371
Прасковья	Колесникова	Михайловна	+7 (263) 327-61-16	5267 977955	среднее	7372
Потап	Семенов	\N	+7 (858) 366-3846	5522 296433	высшее	7373
Осип	Громов	Евгеньевна	8 (793) 942-6386	9256 431712	\N	7374
Антип	Князева	\N	8 688 580 08 93	1526 181269	среднее	7375
Доброслав	Костина	Яковлевна	+7 366 186 5429	6574 964610	высшее	7376
Галина	Копылов	\N	+7 (377) 237-83-67	7285 518939	среднее	7377
Тихон	Хохлова	Арсеньевич	+7 (104) 355-1944	5365 134322	\N	7378
Эдуард	Пахомов	\N	8 (987) 923-80-07	2703 471357	высшее	7379
Алевтина	Савельев	\N	+7 (267) 663-8572	3926 619536	неоконченное высшее	7380
Октябрина	Михеев	\N	+78098200406	9520 345023	среднее	7381
Юлия	Лазарев	Всеволодович	8 (904) 712-0243	6284 699334	высшее	7382
Емельян	Орехова	Владимировна	89166063657	8751 753700	неоконченное высшее	7383
Адам	Кулакова	\N	+7 854 554 0635	7909 779088	среднее профессиональное	7384
Игорь	Ермаков	Дорофеевич	+7 312 335 7859	3411 502784	высшее	7385
Владлен	Капустина	Ефимьевич	+7 860 801 23 71	8837 457782	неоконченное высшее	7386
Владлен	Михайлова	Якубович	+7 (483) 636-3154	4724 140234	\N	7387
Болеслав	Овчинникова	\N	+7 (350) 771-1071	7136 916585	\N	7388
Селиверст	Голубев	Феоктистович	8 (378) 054-1711	6393 589926	высшее	7389
Венедикт	Пахомов	Ждановна	+7 643 787 89 31	3153 683392	неоконченное высшее	7390
Аким	Зуев	\N	8 (258) 068-83-55	1074 506535	неоконченное высшее	7391
Терентий	Сидорова	\N	+7 (843) 124-01-85	3809 416256	высшее	7392
Игорь	Гаврилов	Васильевна	+7 (464) 701-70-03	5895 502779	неоконченное высшее	7393
Евгения	Савельев	\N	+7 (606) 977-73-25	2188 916676	среднее	7394
Сильвестр	Коновалова	Максимовна	+7 (285) 096-93-21	6171 259183	среднее профессиональное	7395
Эрнест	Комиссарова	\N	8 (388) 056-84-76	1508 575728	среднее профессиональное	7396
Емельян	Баранов	\N	8 848 820 1326	4501 311980	\N	7397
Никодим	Игнатьева	Филатович	+79536648112	7765 333828	среднее	7398
Надежда	Васильева	\N	+7 870 502 46 42	8850 412413	неоконченное высшее	7399
Велимир	Назаров	\N	+7 939 694 2908	7548 765488	\N	7400
Милен	Дроздов	Бориславович	+7 068 001 72 34	4110 295681	неоконченное высшее	7401
Всеволод	Гущин	\N	85596559207	6840 898493	\N	7402
Моисей	Беляева	\N	+7 216 074 79 92	7148 879002	\N	7403
Владислав	Капустин	Витальевич	+7 894 642 4845	2661 270287	\N	7404
София	Кабанова	\N	+7 220 431 6725	5256 909036	среднее	7405
Еремей	Константинова	Тимурович	+7 346 945 34 84	9332 559349	\N	7406
Игорь	Ширяев	\N	8 (439) 529-79-49	9320 577664	среднее профессиональное	7407
Акулина	Шестакова	\N	+7 227 500 1564	6439 613442	высшее	7408
Модест	Кудряшов	Викторович	8 (036) 783-88-74	2644 122878	неоконченное высшее	7409
Евгения	Миронова	\N	8 306 337 64 27	9013 402571	\N	7410
Терентий	Сорокина	\N	+72625445886	9518 366282	среднее профессиональное	7411
Фёкла	Васильев	\N	8 (858) 421-90-37	1381 367756	высшее	7412
Епифан	Рогова	Эдуардович	8 (429) 556-15-01	1691 344686	неоконченное высшее	7413
Мефодий	Королева	Альбертовна	8 (097) 005-3614	6263 961095	среднее	7414
Мстислав	Филиппов	\N	+79116333140	1915 352179	среднее профессиональное	7415
Максимильян	Власова	Ефремович	+7 863 663 3975	9490 558847	среднее	7416
Виктор	Виноградова	\N	8 (549) 110-13-83	8027 957012	среднее профессиональное	7417
Константин	Щербакова	\N	87152720233	9555 750456	неоконченное высшее	7418
Лонгин	Фомичева	Дорофеевич	+7 (160) 853-89-60	7249 496387	неоконченное высшее	7419
Милица	Маслов	Николаевна	+7 977 665 8164	7418 906988	высшее	7420
Кира	Федосеева	Устинович	+7 353 004 97 30	8551 378461	неоконченное высшее	7421
Фадей	Белякова	Станиславовна	+7 744 754 74 99	9177 256834	высшее	7422
Творимир	Воронцова	\N	87322715040	5808 474970	среднее профессиональное	7423
Светлана	Зыков	Андреевич	+7 834 683 0378	4344 591625	среднее	7424
Тамара	Суханова	Федосеевич	8 598 037 88 63	3407 172610	среднее	7425
Оксана	Егорова	Семеновна	8 (685) 405-5530	6021 596085	среднее	7426
Ульян	Трофимова	\N	87892174124	1683 862882	\N	7427
Фаина	Рябов	\N	87107009344	6846 445826	\N	7428
Зосима	Елисеев	\N	+7 (059) 775-19-46	4135 592135	высшее	7429
Антип	Галкина	Ефимьевич	8 486 105 0429	2569 892892	неоконченное высшее	7430
Евдоким	Кузьмина	Ермилович	8 552 767 69 56	1391 889232	высшее	7431
Кондрат	Щербакова	Давыдович	+7 046 748 30 61	5968 925235	среднее профессиональное	7432
Никодим	Коновалов	Игоревна	8 (313) 241-58-64	3102 911561	\N	7433
Флорентин	Киселева	Леонидовна	8 (205) 032-53-34	5361 503352	неоконченное высшее	7434
Георгий	Устинов	\N	88136798495	8619 428314	среднее профессиональное	7435
Ирина	Горбунова	Яковлевна	+7 289 050 8590	3935 747600	высшее	7436
Ангелина	Ершова	\N	+78206975143	2195 917314	среднее профессиональное	7437
Ладислав	Королев	Владленович	8 (990) 872-8276	6605 379684	\N	7438
Порфирий	Шашкова	Игнатьевич	8 (523) 739-79-85	6680 704152	среднее	7439
Карп	Казакова	Аксёнович	+75593364034	4700 248839	среднее	7440
Галина	Молчанова	\N	+7 696 255 5254	2883 473360	среднее профессиональное	7441
Прасковья	Семенова	Леонидовна	+79684877469	1207 121836	\N	7442
Николай	Филиппова	Егорович	8 420 726 1306	4301 925883	среднее	7443
Гедеон	Кудрявцев	Ярославович	+7 (395) 415-75-01	9058 526387	высшее	7444
Исидор	Максимова	Бориславович	+7 (973) 457-91-01	8111 456301	\N	7445
Елизавета	Блохина	\N	+7 (681) 672-1513	1261 514971	неоконченное высшее	7446
Сильвестр	Крюкова	Сергеевна	8 (355) 166-15-20	7620 889498	среднее профессиональное	7447
Алла	Сафонов	Елизарович	+7 (427) 847-8861	1950 395187	высшее	7448
Моисей	Михайлова	\N	+7 (877) 622-21-41	6766 350038	среднее профессиональное	7449
Архип	Осипова	Дмитриевич	80835198857	6637 865310	среднее профессиональное	7450
Татьяна	Некрасова	\N	8 (149) 691-40-33	1317 665436	среднее	7451
Адриан	Колобова	\N	82390402079	6798 999637	\N	7452
Степан	Русаков	\N	8 (365) 879-59-36	2555 351616	\N	7453
Стоян	Рогова	\N	8 783 413 0011	1940 835146	среднее профессиональное	7454
Валерьян	Щербакова	\N	8 460 002 68 40	5045 303347	\N	7455
Аскольд	Котов	\N	+7 259 005 46 08	9334 366094	неоконченное высшее	7456
Адам	Ковалева	Рубеновна	+7 (421) 730-0542	3719 383886	среднее	7457
Елена	Савин	Филимонович	+7 (554) 361-4582	9770 443541	среднее профессиональное	7458
Севастьян	Новикова	Юлианович	+7 798 394 0554	9759 264174	высшее	7459
Полина	Жданова	Еремеевич	8 (027) 551-13-92	6301 988708	среднее профессиональное	7460
Евграф	Кузьмина	\N	+7 (491) 818-7255	4114 398170	высшее	7461
Карп	Панфилов	Терентьевич	+7 (442) 756-36-21	9565 898844	среднее профессиональное	7462
Андрей	Колесникова	Тихонович	8 718 352 67 15	5967 276128	неоконченное высшее	7463
Филипп	Терентьева	\N	8 317 937 60 10	2283 520375	неоконченное высшее	7464
Моисей	Щербакова	\N	8 328 537 34 98	5923 216725	\N	7465
Артем	Семенова	\N	8 (159) 457-3036	9453 672557	неоконченное высшее	7466
Гурий	Рыбакова	Ивановна	8 038 899 7376	9849 702618	среднее профессиональное	7467
Аполлон	Семенова	\N	+77241820614	6390 969554	неоконченное высшее	7468
Кузьма	Шарова	Натановна	+7 (719) 784-09-71	7686 448734	высшее	7469
Ярополк	Елисеева	\N	8 782 550 4224	2914 267228	неоконченное высшее	7470
Макар	Одинцова	\N	+76905290296	2956 293681	среднее профессиональное	7471
Афанасий	Кулакова	\N	+7 844 201 70 30	6710 156398	среднее	7472
Нонна	Петухова	Захарьевич	80123203691	2590 901979	среднее	7473
Милован	Королева	Игоревна	8 450 862 03 72	7208 458173	высшее	7474
Любосмысл	Белов	Игоревич	+7 403 966 7530	2347 471718	среднее профессиональное	7475
Измаил	Горбунова	Рубеновна	+7 340 083 3722	8904 276548	неоконченное высшее	7476
Емельян	Маркова	\N	82189301587	6774 389935	\N	7477
Мариан	Белозерова	Натановна	8 325 012 83 24	6996 914358	высшее	7478
Павел	Панфилова	Аверьянович	8 (500) 183-3298	4819 153758	\N	7479
Александр	Хохлова	Викторовна	+71035148727	5996 125815	высшее	7480
Вышеслав	Ефремов	\N	8 (266) 835-7976	5114 727081	среднее	7481
Филимон	Петров	Леоновна	8 (434) 388-1100	5408 108759	неоконченное высшее	7482
Епифан	Панов	\N	8 598 533 08 43	6855 849527	среднее	7483
Парфен	Мельникова	Егоровна	+7 376 864 9662	3502 285535	среднее	7484
Нонна	Потапова	Вилорович	+7 365 539 66 04	6323 896003	среднее	7485
Афиноген	Никитина	\N	8 (553) 490-79-04	1843 826507	неоконченное высшее	7486
Остап	Куликов	Ермолаевич	+77823379564	4484 392684	среднее профессиональное	7487
Октябрина	Кондратьев	\N	+7 112 923 2789	1745 912613	неоконченное высшее	7488
Митофан	Лебедев	Анатольевна	8 (626) 790-4367	7827 285705	среднее	7489
Прокофий	Николаев	\N	8 (221) 270-2981	4607 312140	неоконченное высшее	7490
Зоя	Константинова	\N	+7 495 566 7770	3884 175306	среднее	7491
Севастьян	Прохоров	\N	83677036549	8059 709408	неоконченное высшее	7492
Аникей	Осипова	Иосипович	+7 295 943 2935	3742 454601	среднее профессиональное	7493
Максим	Исакова	\N	8 (347) 338-5495	4024 924713	высшее	7494
Вячеслав	Елисеев	\N	84789968589	6660 618895	среднее профессиональное	7495
Вацлав	Титов	Мироновна	+73366922152	2948 658969	среднее	7496
Николай	Данилова	\N	+7 (332) 527-7858	3905 260400	высшее	7497
Аверкий	Копылова	\N	+7 859 252 1771	1718 350027	высшее	7498
Акулина	Большаков	\N	+70231989215	2490 616943	\N	7499
Любомир	Блинов	\N	87097877711	7535 217666	среднее профессиональное	7500
Алина	Тетерина	Антоновна	8 (821) 879-6851	2069 492356	среднее профессиональное	7501
Соломон	Мухина	\N	+75847705951	5653 894742	среднее	7502
Оксана	Лапина	\N	+7 (233) 265-0958	3505 299470	высшее	7503
Синклитикия	Соловьева	\N	+79175452651	5646 695136	\N	7504
Ксения	Ларионова	Даниловна	8 (899) 983-3600	5608 428958	высшее	7505
Валерия	Крюков	\N	+7 253 025 0035	3961 668251	\N	7506
Алевтина	Казаков	\N	+7 (079) 298-71-16	7808 173186	\N	7507
Назар	Колесникова	\N	8 (315) 500-61-56	4783 852149	среднее	7508
Радислав	Евсеева	Ермолаевич	88669606013	4741 214464	среднее	7509
Ермил	Павлов	\N	8 354 446 68 17	6103 709715	среднее	7510
Радислав	Костин	\N	8 159 753 4390	1554 376479	высшее	7511
Януарий	Бирюкова	\N	+7 (475) 962-4556	7045 653826	\N	7512
Любим	Сидорова	Мироновна	+7 (928) 790-8692	8641 771737	среднее профессиональное	7513
Станимир	Дорофеева	Юльевич	88214117829	3480 123827	\N	7514
Натан	Сазонов	\N	8 (320) 766-08-84	4416 923128	высшее	7515
Азарий	Суворов	Геннадиевна	83303477517	3456 191348	среднее	7516
Радим	Соболева	Оскаровна	8 259 166 05 77	5495 572403	среднее	7517
Мир	Дорофеев	Максимовна	+7 (142) 389-8376	2683 308770	высшее	7518
Фортунат	Тарасов	Ивановна	+7 (176) 719-9809	7777 717610	неоконченное высшее	7519
Ефрем	Белозерова	\N	+7 020 602 2575	4599 435979	среднее профессиональное	7520
Дорофей	Куликова	Арсенович	+7 206 061 9271	7114 912685	высшее	7521
Эраст	Доронина	\N	+7 (493) 050-17-68	5267 779623	среднее профессиональное	7522
Василиса	Белоусова	\N	8 (959) 753-75-19	9856 646716	среднее профессиональное	7523
Мартын	Богданова	\N	+7 (082) 658-22-71	5164 437931	\N	7524
Михей	Костин	Иларионович	8 (196) 854-86-82	5367 339726	неоконченное высшее	7525
Вероника	Белозеров	\N	+7 (895) 163-3356	8994 246684	\N	7526
Викентий	Маслова	\N	+7 882 442 70 07	6894 255064	среднее	7527
Семен	Мамонтов	\N	+77557777100	9874 652360	\N	7528
Любомир	Михеев	\N	8 (814) 672-1186	6860 465660	среднее	7529
Вениамин	Мишина	Антоновна	8 (664) 662-6644	6894 300921	среднее	7530
Игнатий	Власов	Федосьевич	84949925137	3691 175841	неоконченное высшее	7531
Сократ	Авдеева	Ефремович	88237576186	3656 340508	среднее профессиональное	7532
Корнил	Романов	Виленович	+7 (517) 091-1879	2117 245227	высшее	7533
Мина	Гущин	Кузьминична	+7 (393) 396-6644	6311 626955	неоконченное высшее	7534
Прохор	Савельев	\N	+7 885 626 73 91	8459 412295	высшее	7535
София	Крюкова	Эдгарович	87917152272	7184 592889	высшее	7536
Вацлав	Калинин	\N	83734025932	5333 791484	неоконченное высшее	7537
Ростислав	Рожков	Игоревна	86687461975	9600 739343	высшее	7538
Каллистрат	Селиверстов	\N	8 169 013 8515	7800 880396	\N	7539
Богдан	Лаврентьева	Харлампьевич	+7 (542) 977-3055	1623 870029	высшее	7540
Трифон	Соколова	\N	8 668 012 1695	2583 122549	\N	7541
Карп	Данилова	\N	8 939 923 5955	2410 116366	неоконченное высшее	7542
Милен	Захаров	\N	8 639 790 9563	1761 585509	среднее	7543
Ян	Костина	Филипповна	87786253233	9383 865789	среднее профессиональное	7544
Дмитрий	Пономарева	Эльдаровна	8 762 998 4588	5140 562795	неоконченное высшее	7545
Агап	Гуляева	\N	+73102261029	6133 758471	среднее профессиональное	7546
Станимир	Логинова	\N	+7 290 120 08 35	7262 481750	неоконченное высшее	7547
Амос	Князев	Алексеевич	8 (710) 880-13-55	3229 190985	неоконченное высшее	7548
Лев	Беляева	\N	+73105918285	2143 839039	среднее профессиональное	7549
Христофор	Фомина	\N	+7 887 629 6420	9685 346337	среднее профессиональное	7550
Сократ	Кузнецов	\N	8 (121) 512-0621	8327 898565	\N	7551
Панкрат	Тарасов	\N	8 (322) 997-43-27	7851 811268	\N	7552
Парамон	Авдеев	\N	8 789 138 93 12	5401 513307	неоконченное высшее	7553
Анастасия	Лобанова	Терентьевич	+7 050 178 19 56	2942 304197	неоконченное высшее	7554
Егор	Иванов	Геннадиевич	+7 441 266 9389	4045 654743	\N	7555
Терентий	Субботина	\N	8 160 608 53 12	6291 993185	среднее	7556
Всемил	Колесникова	\N	8 (643) 644-2899	5651 656348	среднее профессиональное	7557
Епифан	Архипов	\N	8 955 355 75 76	3727 974784	неоконченное высшее	7558
Тарас	Жданов	Филатович	8 040 567 0461	3045 364555	среднее профессиональное	7559
Наина	Евдокимов	Брониславович	+7 (486) 554-2517	4570 804975	\N	7560
Нина	Комиссаров	\N	+7 (417) 669-12-06	2723 598853	\N	7561
Ия	Блинова	\N	8 333 484 42 28	9990 739588	среднее	7562
Михаил	Капустин	\N	+7 705 728 95 38	8734 887374	\N	7563
Ананий	Одинцов	Денисович	+7 488 665 74 15	6739 213316	среднее	7564
Сигизмунд	Тетерина	\N	8 754 264 04 61	8620 687045	высшее	7565
Виссарион	Калашников	\N	+7 002 640 3570	5145 581469	высшее	7566
Юрий	Уварова	\N	8 516 329 3699	7502 802779	высшее	7567
Азарий	Ильин	\N	+7 972 571 63 27	6462 214248	среднее профессиональное	7568
Адам	Прохорова	\N	+77913420237	3290 365874	неоконченное высшее	7569
Юрий	Попова	Устинович	8 952 347 45 88	6163 626576	среднее профессиональное	7570
Лаврентий	Шашкова	\N	8 (645) 906-48-51	6464 626076	среднее	7571
Селиверст	Мамонтова	\N	+74916725373	2376 550751	среднее	7572
Остромир	Елисеева	\N	8 (855) 210-36-69	9869 954220	среднее профессиональное	7573
Ираклий	Колобов	\N	8 (504) 800-15-37	9581 716513	неоконченное высшее	7574
Демьян	Горшкова	\N	85135448985	8721 349645	неоконченное высшее	7575
Аскольд	Баранов	Игоревич	+7 808 020 9235	5366 749352	среднее	7576
Любим	Поляков	\N	8 367 489 48 43	9054 322835	\N	7577
Измаил	Волков	Владиславовна	+73011233662	2619 897925	среднее	7578
Тамара	Гордеев	Филимонович	8 833 797 6285	9311 377084	неоконченное высшее	7579
Глафира	Кошелева	\N	8 881 658 95 74	7700 688432	неоконченное высшее	7580
Семен	Антонова	Борисовна	+70129443919	4872 486693	среднее	7581
Галина	Горбунова	Харитонович	+7 (472) 698-07-49	6418 883837	неоконченное высшее	7582
Ладимир	Денисов	Рубеновна	80212988745	5286 209053	неоконченное высшее	7583
Трофим	Исакова	Алексеевна	+7 500 079 61 67	8343 208837	среднее	7584
Доброслав	Копылов	Венедиктович	8 (980) 516-39-00	5112 157134	неоконченное высшее	7585
Чеслав	Уваров	Антипович	+7 265 251 17 66	9307 703690	неоконченное высшее	7586
Казимир	Мухина	\N	8 (632) 579-57-40	9748 789056	\N	7587
Ксения	Якушев	\N	+73934518967	6062 611003	\N	7588
Полина	Сорокина	Тарасович	89521836063	3700 579326	среднее профессиональное	7589
Епифан	Лукин	\N	+7 700 869 02 31	7795 736432	среднее	7590
Капитон	Кондратьев	\N	+76474343536	3344 439994	неоконченное высшее	7591
Софрон	Тимофеев	Петровна	+7 (512) 608-5347	9123 229969	неоконченное высшее	7592
Виктор	Шашков	\N	8 (569) 284-97-25	4729 114605	среднее	7593
Доброслав	Дроздова	\N	8 766 784 1181	5734 113202	среднее профессиональное	7594
Осип	Артемьева	Эдуардович	+7 934 155 4616	3033 536575	\N	7595
Карл	Константинова	\N	8 268 501 7279	9239 476770	\N	7596
Фотий	Волков	Ефремович	80064453742	6473 847540	высшее	7597
Дорофей	Михеева	\N	8 (013) 849-3938	3371 765914	\N	7598
Петр	Власов	Власович	+7 (251) 321-82-79	5717 657507	высшее	7599
Дмитрий	Федосеева	Руслановна	+7 (558) 648-6204	9183 812753	\N	7600
Александр	Куликова	Леонидовна	+75921294180	3025 597835	\N	7601
Михей	Копылова	Гертрудович	80481626632	2635 770607	неоконченное высшее	7602
Лев	Корнилова	\N	8 650 266 72 53	8174 969780	неоконченное высшее	7603
Сила	Попов	Рубеновна	8 (905) 344-39-76	7200 527926	неоконченное высшее	7604
Милан	Владимиров	\N	+7 (222) 023-49-04	5775 572617	среднее	7605
Прокл	Филатова	Зиновьевич	8 (475) 207-08-52	4410 668565	неоконченное высшее	7606
Добромысл	Кузьмина	Васильевна	+7 (911) 246-56-38	7446 865697	неоконченное высшее	7607
Вера	Жукова	\N	+7 (783) 480-7487	4815 539514	высшее	7608
Богдан	Воробьев	\N	8 (715) 810-9191	5218 351190	среднее профессиональное	7609
Гордей	Шестакова	Эдгардович	+7 883 869 3716	4263 289237	среднее	7610
Степан	Гаврилов	\N	+7 630 850 7850	4817 942014	неоконченное высшее	7611
Вадим	Шашков	Олеговна	+7 (873) 746-06-66	3390 461506	среднее	7612
Синклитикия	Артемьева	\N	8 145 344 2082	1610 777777	высшее	7613
Зиновий	Шубин	\N	8 620 529 1109	1735 326892	среднее профессиональное	7614
Эрнест	Харитонов	Брониславович	84484125447	5884 282301	\N	7615
Фока	Михайлова	\N	8 705 775 25 78	3098 610007	среднее профессиональное	7616
Лукия	Агафонова	Давыдович	+7 090 026 88 91	6131 929959	\N	7617
Никодим	Егоров	\N	8 905 922 79 58	5357 178126	среднее профессиональное	7618
Любим	Игнатова	Владиславовна	+7 (908) 412-01-64	5184 323366	среднее	7619
Януарий	Соколов	\N	8 (467) 621-52-48	1202 986419	среднее	7620
Святослав	Ларионов	\N	+7 608 898 7010	2660 632473	\N	7621
Демид	Стрелков	\N	8 085 340 61 55	9353 756667	неоконченное высшее	7622
Фаина	Ефремов	\N	+7 (369) 577-86-93	1166 735659	среднее профессиональное	7623
Всеслав	Савельева	Чеславович	+7 (509) 549-5079	1274 806857	среднее профессиональное	7624
Мирослав	Васильева	Терентьевич	+7 171 404 9246	5623 628963	\N	7625
Платон	Красильников	Артурович	+7 958 298 6630	6919 421286	неоконченное высшее	7626
Афиноген	Ефимова	Виленович	+7 767 151 6121	7394 203142	неоконченное высшее	7627
Дорофей	Копылов	\N	+70100473950	7104 373483	\N	7628
Всеслав	Волкова	Устинович	+75816846379	7241 983529	среднее профессиональное	7629
Нонна	Лебедев	Фомич	89269386531	3237 581281	среднее профессиональное	7630
Игнатий	Титов	Васильевич	+7 933 438 3259	8469 183384	среднее профессиональное	7631
Гремислав	Коновалов	Ефстафьевич	8 (841) 803-71-46	5358 505244	\N	7632
Карл	Комиссаров	\N	8 (244) 273-6162	1556 899854	\N	7633
Кузьма	Павлова	\N	84274670110	5440 334486	среднее	7634
Захар	Муравьев	Анатольевич	81434534979	4829 253211	неоконченное высшее	7635
Кира	Фадеева	Степановна	+7 (755) 556-94-11	4682 322218	высшее	7636
Элеонора	Мясников	Максимовна	8 407 567 04 34	6162 973428	среднее профессиональное	7637
Филипп	Ситникова	Юрьевна	+77307056279	1146 261216	среднее профессиональное	7638
Руслан	Максимов	Алексеевич	88243192872	7848 266378	неоконченное высшее	7639
Филипп	Мясникова	Федосьевич	+7 171 036 72 17	9157 626153	\N	7640
Виктор	Анисимов	\N	+7 776 349 47 61	8122 529814	\N	7641
Петр	Соболев	Филипповна	85896139004	2997 700730	высшее	7642
Соломон	Жданова	Ильинична	+72093670447	4884 571337	высшее	7643
Агап	Лобанов	Арсенович	8 422 101 7843	2838 143705	\N	7644
Виктория	Овчинников	\N	+74015594342	2612 934358	среднее профессиональное	7645
Семен	Юдина	Натановна	+7 945 893 5351	2453 944083	среднее	7646
Епифан	Соловьева	Харлампович	+7 888 083 2954	7705 195380	\N	7647
Елизар	Родионов	\N	86029774979	2574 490120	высшее	7648
Агафья	Дмитриев	\N	+7 (541) 686-7516	3278 102896	среднее	7649
Фома	Субботин	Тимофеевна	8 (992) 066-95-03	6360 722275	неоконченное высшее	7650
Давыд	Орлов	Тимуровна	8 (626) 847-44-42	4416 214205	высшее	7651
Ия	Белов	\N	+7 564 925 51 82	5695 660108	неоконченное высшее	7652
Аристарх	Лихачев	Измаилович	+77124376186	5384 653799	среднее профессиональное	7653
Афанасий	Копылов	\N	+7 705 446 89 23	9003 226166	среднее профессиональное	7654
Серафим	Павлов	\N	+7 (731) 046-37-70	5930 913622	\N	7655
Филимон	Фадеев	\N	8 (185) 876-3739	7538 846613	неоконченное высшее	7656
Александр	Константинова	\N	8 402 521 86 17	4801 364181	неоконченное высшее	7657
Любосмысл	Гришин	Кузьминична	+7 (466) 886-7121	2418 237779	\N	7658
Елисей	Маслова	Ильясович	+79979051759	6385 916770	среднее профессиональное	7659
Порфирий	Фадеева	Артёмович	8 (524) 098-8743	7208 812668	высшее	7660
Фёкла	Дроздова	Антонович	+7 (519) 729-3575	2044 388155	неоконченное высшее	7661
Василиса	Логинова	Николаевна	+7 599 221 39 80	6994 513371	\N	7662
Аверьян	Бобылева	Филиппович	8 451 284 6258	1454 644896	\N	7663
Нина	Орехов	\N	8 534 732 2638	2507 807159	неоконченное высшее	7664
Софон	Буров	\N	+7 (851) 514-2915	3307 240183	неоконченное высшее	7665
Синклитикия	Ларионова	\N	8 515 361 21 67	4223 549116	неоконченное высшее	7666
Панкратий	Лобанова	\N	80725210766	8376 630876	высшее	7667
Вениамин	Мамонтова	\N	8 630 485 7033	2660 808971	неоконченное высшее	7668
Регина	Жданов	\N	8 924 174 88 80	5849 530020	высшее	7669
Мефодий	Коновалов	\N	+7 814 780 9545	7566 357312	среднее профессиональное	7670
Всемил	Никитин	\N	8 (816) 211-52-22	9072 701184	неоконченное высшее	7671
Аркадий	Хохлова	Герасимович	8 223 526 2197	4839 462926	высшее	7672
Валерьян	Молчанов	\N	8 (581) 197-74-83	7688 326369	среднее профессиональное	7673
Ипат	Бобылева	\N	8 903 222 8937	7015 233713	\N	7674
Матвей	Горбунов	Харитоновна	8 249 068 0775	3891 154540	высшее	7675
Федор	Исакова	Ерофеевич	8 372 743 60 46	6618 334807	неоконченное высшее	7676
Адам	Потапов	Юрьевна	+7 (141) 565-3955	1578 514376	\N	7677
Осип	Смирнов	Тимофеевна	+7 314 619 83 92	3855 459713	неоконченное высшее	7678
Лонгин	Трофимов	\N	8 688 232 45 23	6494 726438	высшее	7679
Евстафий	Шарова	\N	+7 (110) 787-5428	1590 457557	среднее профессиональное	7680
Венедикт	Ларионов	Григорьевна	+75214331726	3529 836985	среднее	7681
Селиверст	Федосеев	\N	+7 (374) 487-13-25	3941 507037	высшее	7682
Радислав	Селиверстова	Гордеевич	8 404 455 44 24	9649 217150	среднее	7683
Самуил	Ильин	\N	8 141 253 8910	9777 660411	высшее	7684
Антип	Белов	Зиновьевич	+79350747726	3822 954793	среднее	7685
Анжелика	Орехов	\N	+78772978463	3993 364668	неоконченное высшее	7686
Аскольд	Лапина	Артемовна	+7 249 374 36 32	5099 475718	высшее	7687
Климент	Горшкова	Антипович	8 (768) 151-20-73	6291 412129	неоконченное высшее	7688
Порфирий	Яковлева	Фёдорович	8 583 457 1105	1127 838445	неоконченное высшее	7689
Павел	Мишин	\N	89122652087	9729 138211	среднее	7690
Кузьма	Яковлев	Филимонович	+7 (621) 610-73-93	9472 278870	неоконченное высшее	7691
Бажен	Михайлов	\N	8 676 920 57 85	8309 406401	\N	7692
Творимир	Голубева	Тарасовна	+7 501 791 9753	5966 725333	среднее	7693
Гостомысл	Ковалев	\N	+7 (568) 949-09-53	7429 727171	\N	7694
Юрий	Фомичева	\N	85855126908	8424 432850	высшее	7695
Изот	Лобанова	\N	8 285 547 26 02	8762 688531	неоконченное высшее	7696
Артемий	Кузнецов	Алексеевич	81810613739	2480 532139	высшее	7697
Евграф	Селиверстова	Владимировна	8 (993) 027-6514	9257 187060	высшее	7698
Архип	Никифоров	\N	8 803 262 24 20	4718 793690	высшее	7699
Афиноген	Крюкова	Валерьянович	8 750 765 5888	6541 466926	высшее	7700
Аникита	Орлова	Исидорович	8 999 280 29 27	4775 450846	неоконченное высшее	7701
Марина	Юдин	Эльдаровна	+7 (986) 975-85-60	3330 771978	среднее	7702
Олимпиада	Гуляев	Болеславовна	82447056317	4582 734785	высшее	7703
Авдей	Терентьев	\N	8 (926) 952-42-85	8612 698139	неоконченное высшее	7704
Евгения	Чернова	Оскаровна	+7 (259) 248-64-35	7786 747483	\N	7705
Федот	Петухова	\N	8 598 300 80 54	9956 377662	неоконченное высшее	7706
Кондратий	Мясников	Степановна	+75441891217	4424 747016	среднее	7707
Флорентин	Марков	\N	+7 727 006 43 71	4423 850938	среднее	7708
Фадей	Давыдов	\N	+7 (426) 594-4124	5038 171427	среднее	7709
Гремислав	Петухов	\N	+7 (101) 964-2109	9648 831901	высшее	7710
Прохор	Фролова	Григорьевна	+7 (207) 620-61-11	2526 421600	высшее	7711
Еремей	Силин	\N	8 (335) 179-8409	2470 556701	\N	7712
Прокофий	Дементьев	\N	8 173 353 59 29	1676 540584	среднее	7713
Климент	Большакова	\N	8 259 018 1788	8356 342808	неоконченное высшее	7714
Анна	Архипов	\N	8 (658) 495-84-27	5734 756623	высшее	7715
Константин	Доронин	Игоревич	+73258959632	9165 716681	\N	7716
Елизавета	Осипова	Якубович	8 (249) 700-09-24	4082 723505	среднее профессиональное	7717
Феврония	Ершов	Чеславович	+7 376 602 3153	5850 795652	среднее	7718
Мирослав	Евсеева	Харитонович	8 (108) 968-1840	2635 272197	высшее	7719
Алина	Кудрявцев	\N	8 925 132 7374	7606 745709	среднее профессиональное	7720
Мина	Белозеров	\N	+7 690 683 69 16	5628 966593	среднее	7721
Никанор	Виноградова	\N	8 (807) 739-9619	4423 330123	высшее	7722
Виктория	Артемьев	Авдеевич	8 401 832 05 73	7555 139516	среднее профессиональное	7723
Семен	Архипова	Еремеевич	8 323 535 8988	4698 206247	высшее	7724
Полина	Гордеев	Макаровна	8 753 807 23 18	3889 535970	среднее профессиональное	7725
Дарья	Быков	\N	+7 (288) 493-5511	1452 794138	\N	7726
Фома	Зиновьев	\N	8 (189) 154-8410	9313 207240	\N	7727
Творимир	Фадеев	Эдгардович	+7 (677) 480-2819	2785 339190	неоконченное высшее	7728
Изот	Петров	Оскаровна	8 (796) 451-00-80	7138 938640	неоконченное высшее	7729
Болеслав	Александров	Давыдович	+7 943 748 1559	2607 780100	среднее	7730
Любим	Вишнякова	Гавриилович	8 344 747 1045	8013 534502	высшее	7731
Афанасий	Яковлева	Яковлевна	+7 (209) 713-78-70	8231 149117	среднее	7732
Ермил	Исакова	\N	8 189 758 97 25	5554 449934	неоконченное высшее	7733
Севастьян	Фадеева	\N	8 (970) 960-7375	3610 615500	неоконченное высшее	7734
Фирс	Сергеева	Якубович	81270774612	4608 344526	высшее	7735
Максимильян	Денисов	Филипповна	8 (256) 527-1564	8511 981625	среднее профессиональное	7736
Аким	Панфилова	Еремеевич	+7 935 577 2415	8845 876472	среднее профессиональное	7737
Владлен	Анисимов	\N	+7 (307) 524-62-56	9760 146711	неоконченное высшее	7738
Мирон	Громов	Давидович	8 (141) 327-3368	4005 248594	высшее	7739
Марина	Тихонов	\N	+7 (638) 517-1287	1321 258995	\N	7740
Мариан	Комаров	\N	+7 (075) 552-6541	7063 559569	среднее	7741
Виталий	Кондратьев	\N	8 073 685 5652	5856 244255	неоконченное высшее	7742
Владимир	Юдина	Эдуардовна	+78845756789	6289 682753	среднее профессиональное	7743
Вениамин	Пономарева	\N	8 492 961 7366	5297 840898	среднее профессиональное	7744
Зосима	Ширяев	\N	+7 (611) 721-8635	6141 735924	\N	7745
Осип	Одинцова	Евстигнеевич	8 (049) 641-8595	2510 498460	высшее	7746
Чеслав	Евсеев	Аскольдовна	86782538607	8614 621157	высшее	7747
Евлампий	Тимофеева	\N	+70237525048	6878 773538	\N	7748
Анжелика	Николаев	Ааронович	8 (156) 822-73-03	7758 948872	среднее	7749
Руслан	Романов	Данилович	8 (019) 291-0661	5765 401502	\N	7750
Святополк	Цветков	\N	8 423 087 52 24	7758 737472	среднее профессиональное	7751
Людмила	Федосеева	Матвеевич	8 944 011 2857	7913 861849	неоконченное высшее	7752
Сократ	Никитин	Эдуардовна	+7 930 298 04 46	5500 391304	\N	7753
Гордей	Самойлова	Наумовна	+7 (113) 454-55-46	5018 300455	\N	7754
Ладислав	Моисеев	\N	+7 488 599 7980	4984 812273	неоконченное высшее	7755
Ефим	Трофимова	Сергеевна	+77339089913	1253 376152	среднее	7756
Лора	Фомичева	Артёмович	8 240 093 15 79	7941 159034	среднее профессиональное	7757
Болеслав	Зуев	\N	+7 199 987 99 27	9255 793511	высшее	7758
Радован	Брагин	\N	+7 (678) 498-7320	1583 936923	среднее	7759
Иннокентий	Панова	Игнатьевич	+7 611 839 22 80	2858 926609	среднее профессиональное	7760
Соломон	Устинов	\N	81458180931	6944 493121	высшее	7761
Зоя	Громова	Федосеевич	8 201 342 0262	1494 442140	среднее	7762
Наталья	Жданова	\N	8 (166) 462-09-50	8860 269368	неоконченное высшее	7763
Егор	Осипова	\N	+7 602 849 9829	8548 128123	высшее	7764
Ладислав	Фомин	\N	+7 (490) 448-26-90	6707 570505	высшее	7765
Милица	Антонова	Бориславович	8 (630) 336-2212	4647 875450	неоконченное высшее	7766
Пелагея	Григорьев	\N	8 (630) 047-60-56	6329 788807	\N	7767
Федосий	Беспалова	\N	+7 (495) 956-30-29	7563 906024	неоконченное высшее	7768
Ия	Королева	\N	+79230491630	4863 815211	среднее профессиональное	7769
Владислав	Кулаков	\N	82604217250	2662 656108	\N	7770
Исай	Аксенов	\N	+7 574 200 80 60	2421 683351	неоконченное высшее	7771
Варлаам	Агафонов	Кирилловна	80145701909	8451 529702	\N	7772
Гедеон	Пахомова	\N	+7 727 324 70 83	9843 692120	\N	7773
Антонин	Большаков	Романовна	8 (378) 696-04-74	3325 688168	высшее	7774
Адриан	Лазарев	\N	+7 (743) 490-1462	3944 350677	\N	7775
Евфросиния	Ефимов	Бенедиктович	8 (432) 431-4469	9911 308418	среднее профессиональное	7776
Фома	Белякова	Вячеславовна	8 (260) 754-3557	9441 177781	неоконченное высшее	7777
Вероника	Ситникова	Натановна	8 138 889 9951	3167 949619	среднее	7778
Савелий	Морозов	Владиславович	8 020 447 4171	9235 482936	высшее	7779
Симон	Назарова	\N	8 (046) 369-66-58	9820 674921	неоконченное высшее	7780
Нина	Вишнякова	\N	8 598 398 88 88	6224 109902	среднее профессиональное	7781
Тарас	Бирюкова	\N	+77591758072	7972 946259	неоконченное высшее	7782
Конон	Доронина	Георгиевич	+7 295 891 73 77	8760 138220	среднее	7783
Измаил	Рогова	\N	+76646931689	2301 713680	неоконченное высшее	7784
Антонина	Туров	Евсеевич	8 (094) 520-55-04	1073 919259	высшее	7785
Ерофей	Веселов	Эдуардовна	+79991460336	2258 502810	среднее профессиональное	7786
Геннадий	Воробьев	\N	+74503831658	2726 265694	неоконченное высшее	7787
Устин	Трофимов	\N	+7 (187) 772-92-91	8805 933496	среднее	7788
Октябрина	Моисеев	Федотович	8 446 731 49 06	9904 882346	среднее профессиональное	7789
Евфросиния	Гурьева	Иосифович	+7 (402) 428-29-01	6062 340831	\N	7790
Валерия	Рожков	Демьянович	8 282 043 85 18	5394 870148	\N	7791
Ангелина	Красильников	\N	+7 (196) 900-81-76	7848 969201	высшее	7792
Самсон	Дементьев	Иосипович	+7 (985) 802-62-94	3629 265544	среднее профессиональное	7793
Лукия	Рябов	Семеновна	+7 (534) 553-4395	6479 970011	среднее	7794
Ирина	Муравьева	Гертрудович	86936459701	1832 986562	\N	7795
Рюрик	Гуляева	\N	+7 (638) 329-1263	1653 968846	среднее	7796
Дементий	Никифоров	\N	84650240190	8633 571464	среднее	7797
Евстигней	Устинова	\N	8 208 108 26 51	3191 772925	среднее профессиональное	7798
Пров	Молчанова	\N	8 672 554 6858	8057 956566	среднее профессиональное	7799
Савва	Гришин	\N	+79999469894	6159 345926	высшее	7800
Петр	Богданов	\N	83433531899	4950 806617	неоконченное высшее	7801
Анисим	Филатова	Геннадьевна	+7 022 224 56 88	3489 999183	\N	7802
Валерия	Громова	\N	8 135 455 4189	5730 963861	\N	7803
Клавдия	Кулагин	\N	+7 191 501 7869	5324 196276	высшее	7804
Август	Русакова	\N	8 (645) 603-5462	2155 992070	\N	7805
Евдокия	Лазарев	Вячеславович	+7 (869) 256-3068	7001 928191	среднее	7806
Илья	Беспалова	Евгеньевна	+7 916 609 7368	8362 528993	неоконченное высшее	7807
Юлиан	Максимов	\N	+7 756 123 27 35	8655 412628	\N	7808
Демьян	Титова	\N	8 484 722 3223	3047 473490	\N	7809
Милован	Самойлов	Федосьевич	8 (434) 202-61-13	2430 888510	среднее	7810
Фаина	Сорокина	\N	8 (757) 755-49-65	9603 134787	среднее	7811
Исай	Борисов	\N	+7 (471) 320-42-84	3246 664669	среднее	7812
Ладимир	Лаврентьева	\N	8 (671) 842-41-94	6887 325867	неоконченное высшее	7813
Всеслав	Тарасов	\N	+7 (837) 468-74-20	4027 167699	среднее профессиональное	7814
Вениамин	Орлов	Жоресович	8 255 243 40 94	9944 208520	среднее профессиональное	7815
Демьян	Уварова	\N	+7 998 957 2076	2330 519030	среднее	7816
Спиридон	Рябов	Викентьевич	+7 635 540 32 03	2078 719431	неоконченное высшее	7817
Матвей	Ситникова	\N	8 669 622 10 37	9392 933756	\N	7818
Наина	Владимирова	Богданович	8 049 977 7761	3199 879650	среднее	7819
Велимир	Зиновьев	\N	8 223 306 6905	1725 842642	среднее профессиональное	7820
Игорь	Козлов	\N	89213810444	8066 587984	высшее	7821
Георгий	Фомичев	\N	+7 (992) 820-1755	8908 469857	среднее профессиональное	7822
Владилен	Гордеев	\N	+7 (897) 253-64-90	2142 428041	высшее	7823
Милован	Уваров	\N	83680962090	7605 225083	высшее	7824
Мина	Авдеев	\N	+7 (106) 468-95-62	5977 615034	\N	7825
Савелий	Воронцов	Юрьевна	+7 461 991 84 31	3127 602049	среднее профессиональное	7826
Зосима	Мишин	\N	89452137869	7608 336344	неоконченное высшее	7827
Анжелика	Савельев	\N	+7 (015) 102-21-25	8383 805490	\N	7828
Аскольд	Борисов	\N	8 (436) 716-5846	7355 403492	неоконченное высшее	7829
Модест	Юдина	Болеславовна	+72012796241	4216 699803	неоконченное высшее	7830
Лучезар	Ларионов	\N	+74312306185	4015 460375	\N	7831
Фадей	Громов	\N	8 681 982 8225	8585 818407	среднее	7832
Лазарь	Королев	\N	84341317418	2926 763348	среднее	7833
Святополк	Кудрявцев	Вячеславович	+7 020 431 85 17	4226 380935	среднее	7834
Эраст	Воробьев	Артемьевич	8 (649) 132-4423	7220 839278	среднее профессиональное	7835
Милован	Веселов	Тимуровна	+7 (884) 295-4364	7560 154509	\N	7836
Афиноген	Блохина	\N	8 (024) 125-1442	1606 730560	среднее	7837
Ян	Лаврентьев	Демидович	+7 191 229 1554	6934 517036	высшее	7838
Михаил	Киселев	\N	8 (942) 231-9625	5341 997149	неоконченное высшее	7839
Ратмир	Тарасов	\N	8 (436) 076-2647	6081 574904	неоконченное высшее	7840
Януарий	Носов	Адрианович	8 196 513 99 54	7131 715644	среднее	7841
Тарас	Коновалов	\N	+7 055 588 71 63	7669 516368	высшее	7842
Прокл	Чернова	Всеволодович	+7 (191) 788-67-26	9597 312358	высшее	7843
Фаина	Брагин	\N	+74520944433	2199 214910	среднее	7844
Парамон	Трофимов	\N	+7 (904) 638-1346	4328 466906	\N	7845
Емельян	Блинова	Ильясович	+7 222 871 5471	2547 117935	\N	7846
Анжела	Блохин	Авдеевич	86783916814	1970 882433	неоконченное высшее	7847
Виссарион	Пономарев	\N	8 (388) 520-56-18	4035 240657	среднее	7848
Казимир	Пестов	Кирилловна	8 198 155 8334	2299 827594	среднее	7849
Корнил	Наумов	\N	8 827 313 1015	2774 489493	\N	7850
Никанор	Харитонова	Александрович	8 (334) 206-13-69	2506 972419	неоконченное высшее	7851
Регина	Сидорова	\N	+7 747 846 31 10	8019 999607	среднее	7852
Анисим	Власова	\N	+7 592 894 36 11	2846 738833	среднее профессиональное	7853
Таисия	Кабанов	Феофанович	+7 (460) 589-07-66	2102 317938	среднее профессиональное	7854
Давыд	Волков	Харламович	82750517653	4004 761125	высшее	7855
Вацлав	Голубев	Владимировна	+7 (362) 449-1384	1070 163731	неоконченное высшее	7856
Силантий	Сидоров	Викентьевич	8 (930) 839-5533	1185 211718	среднее	7857
Анжела	Петухов	\N	+7 683 603 83 89	7802 227000	высшее	7858
Еремей	Дмитриев	\N	8 (511) 001-4534	8455 655542	высшее	7859
Ангелина	Герасимов	\N	8 416 282 54 53	8784 524691	\N	7860
Федосий	Галкин	\N	+71965750233	4973 132987	неоконченное высшее	7861
Иларион	Ершов	\N	8 (990) 287-80-07	2401 412151	высшее	7862
Олимпиада	Власов	\N	8 (864) 451-3343	1018 549776	среднее профессиональное	7863
Евгения	Королева	\N	+7 655 868 15 27	3276 793532	высшее	7864
Любосмысл	Абрамов	\N	87091512533	3266 578596	\N	7865
Ярополк	Пестов	\N	8 970 177 33 58	4108 731686	высшее	7866
Николай	Цветкова	Алексеевич	+71933100362	7140 628133	высшее	7867
Руслан	Соболева	Августович	+74123212274	9056 967015	\N	7868
Федор	Дмитриева	\N	8 645 579 67 53	6088 361983	неоконченное высшее	7869
Лучезар	Кудрявцев	Валентиновна	+7 (672) 995-19-17	7079 756430	\N	7870
Наталья	Анисимов	\N	84905106389	8499 897654	неоконченное высшее	7871
Ефим	Меркушева	\N	+7 (231) 007-9403	1895 393821	среднее	7872
Александра	Аксенова	Леонидовна	8 405 886 2371	1949 679426	среднее	7873
Аникита	Емельянов	Викторович	+70616747096	3956 481517	неоконченное высшее	7874
Казимир	Пахомов	\N	8 (762) 285-00-55	3337 836920	неоконченное высшее	7875
Павел	Горшков	Феликсович	8 (290) 483-09-80	1837 512112	среднее профессиональное	7876
Евсей	Александрова	\N	85054468206	7882 746803	среднее профессиональное	7877
Никита	Шестаков	Игнатьевич	+76416643964	2614 483359	\N	7878
Юрий	Зайцев	\N	89359692283	5959 176621	неоконченное высшее	7879
Антонина	Устинов	Александровна	+7 102 954 5377	5073 691714	неоконченное высшее	7880
Владимир	Некрасов	Вилорович	8 242 122 01 95	4472 550639	неоконченное высшее	7881
Матвей	Никонов	Яковлевич	8 372 291 8532	1732 813815	среднее	7882
Лидия	Трофимова	\N	8 187 133 8295	5172 166932	среднее профессиональное	7883
Владимир	Филатов	\N	8 264 778 12 83	1931 474948	неоконченное высшее	7884
Яков	Туров	\N	8 (700) 697-0295	4761 688880	неоконченное высшее	7885
Тихон	Корнилов	\N	8 (088) 812-8588	4102 243072	высшее	7886
Милан	Артемьева	Федосеевич	8 128 441 96 29	7036 860373	высшее	7887
Никон	Пономарева	Эдгарович	8 (193) 120-9495	8005 701935	\N	7888
Глеб	Никонов	Глебович	+7 (666) 040-4527	3090 660923	\N	7889
Олег	Носов	Филимонович	8 808 390 4379	9235 655051	среднее профессиональное	7890
Добромысл	Капустин	Валерьянович	+7 (873) 086-2205	9222 907902	неоконченное высшее	7891
Фрол	Петрова	Устинович	+7 533 680 6816	3665 459355	среднее	7892
Феоктист	Казакова	Ермолаевич	+73088197474	9237 249667	среднее профессиональное	7893
Захар	Архипова	\N	8 214 159 03 21	5140 385462	среднее профессиональное	7894
Гаврила	Моисеева	\N	+73308197510	9478 699717	неоконченное высшее	7895
Василиса	Логинов	\N	8 (000) 959-16-27	3171 565130	неоконченное высшее	7896
Аггей	Логинова	\N	8 526 477 94 94	5608 307430	\N	7897
Эмилия	Селиверстова	\N	+7 (292) 640-3543	9177 642764	неоконченное высшее	7898
Пантелеймон	Герасимов	\N	8 556 673 71 13	9094 863015	среднее профессиональное	7899
Зиновий	Казаков	\N	+7 (842) 464-1769	7610 317637	среднее профессиональное	7900
Матвей	Сергеев	Александрович	+7 (080) 970-72-15	7334 251533	неоконченное высшее	7901
Вышеслав	Медведев	\N	8 412 752 80 23	4757 613551	среднее	7902
Будимир	Абрамов	Денисович	+72765419543	7598 649983	высшее	7903
Еремей	Трофимов	\N	8 (574) 289-0507	6937 593268	среднее профессиональное	7904
Радислав	Дорофеева	\N	84139376913	2456 845748	среднее профессиональное	7905
Конон	Копылов	\N	8 908 429 97 77	4397 796045	неоконченное высшее	7906
Наталья	Некрасов	Юлианович	8 910 908 87 62	7043 218183	высшее	7907
Христофор	Жуков	Ефимовна	87367379313	4542 990013	высшее	7908
Денис	Капустина	\N	+7 (247) 930-6529	9551 655085	неоконченное высшее	7909
Анисим	Лыткина	Герасимович	84914837003	5693 599734	\N	7910
Лукия	Орехова	Васильевич	+7 917 779 3600	9663 707339	высшее	7911
Элеонора	Васильева	Ильясович	+7 242 961 73 48	1192 552838	неоконченное высшее	7912
Севастьян	Макарова	Феодосьевич	+76508688841	4680 370814	среднее профессиональное	7913
Ираклий	Гордеев	Харитонович	89407556697	1422 806513	неоконченное высшее	7914
Ульян	Гришина	\N	8 (684) 158-98-50	3273 294153	среднее профессиональное	7915
Азарий	Тарасов	\N	+7 (637) 032-8270	8607 876368	высшее	7916
Тит	Королев	\N	8 (678) 067-99-83	3303 556705	неоконченное высшее	7917
Ким	Петухов	\N	+79598474579	8805 998772	\N	7918
Аверьян	Белов	Ефимовна	8 928 109 1182	6405 587846	неоконченное высшее	7919
Иннокентий	Пестов	Богданович	+7 (164) 814-3857	8718 809832	среднее	7920
Чеслав	Агафонов	Геннадиевна	+7 (075) 380-97-74	4583 115449	среднее профессиональное	7921
Ананий	Савельева	\N	8 780 591 74 93	1742 787745	высшее	7922
Герасим	Герасимова	\N	+7 (995) 956-62-82	4311 812316	среднее	7923
Всеслав	Зиновьев	\N	+76714288740	5871 545256	\N	7924
Ефим	Ефимов	Харитоновна	8 (131) 259-27-89	7485 303977	среднее профессиональное	7925
Изот	Селезнев	Антонович	83061757500	1591 796906	неоконченное высшее	7926
Алла	Комиссаров	Мироновна	+7 (430) 279-77-19	3453 141336	среднее	7927
Олимпиада	Потапова	Изотович	8 (477) 355-3031	8634 750322	высшее	7928
Федор	Лукина	\N	+7 (499) 968-80-23	3200 843797	высшее	7929
Аверьян	Колобов	Андреевич	8 (513) 798-6893	9433 560418	неоконченное высшее	7930
Геннадий	Устинова	\N	+7 499 347 10 85	6125 390313	неоконченное высшее	7931
Тит	Голубев	\N	+7 (315) 850-82-14	7088 336004	среднее	7932
Андроник	Денисова	\N	+7 693 981 83 94	2663 790849	неоконченное высшее	7933
Леонид	Мухина	Жанович	8 316 068 1851	3366 274666	среднее профессиональное	7934
Денис	Веселов	Якубович	8 506 100 98 31	1333 569207	неоконченное высшее	7935
Ефим	Русакова	Иосипович	+7 227 479 64 55	7110 280721	среднее профессиональное	7936
Касьян	Гущина	\N	+7 (390) 269-1970	3444 954880	среднее	7937
Тимофей	Ефремов	Яковлевна	+7 (539) 269-9735	5638 404474	среднее профессиональное	7938
Варфоломей	Доронина	Арсенович	8 025 558 5435	8344 363092	среднее	7939
Епифан	Овчинникова	Васильевич	8 (830) 841-2005	6864 376842	неоконченное высшее	7940
Амвросий	Богданова	Теймуразович	84448056135	2146 206895	среднее профессиональное	7941
Фома	Капустина	Харлампьевич	+7 (083) 614-17-38	1880 759918	\N	7942
Христофор	Вишнякова	Марсович	+7 (240) 467-89-37	1659 416913	среднее профессиональное	7943
Пахом	Панова	\N	8 312 513 0572	4344 332269	неоконченное высшее	7944
Арефий	Моисеев	\N	+7 (680) 486-2269	5016 340779	\N	7945
Мокей	Красильников	Леоновна	8 753 842 9739	7859 964961	\N	7946
Владилен	Воробьева	\N	+7 (168) 068-05-89	7798 855784	неоконченное высшее	7947
Дорофей	Воробьев	Богдановна	+7 (396) 619-3216	8576 629240	среднее профессиональное	7948
Ефим	Шестаков	\N	8 (712) 350-1780	5686 973255	среднее профессиональное	7949
Викентий	Брагин	Ермилович	+7 158 924 47 96	9879 912903	высшее	7950
Алина	Семенова	\N	+7 998 608 04 44	3569 250174	высшее	7951
Наталья	Григорьева	Данилович	8 (994) 836-2590	4035 674899	\N	7952
Любим	Фокина	Геннадиевич	8 258 700 26 89	4002 413586	среднее профессиональное	7953
Савва	Иванова	\N	+7 425 747 16 72	5672 482387	неоконченное высшее	7954
Герасим	Афанасьев	Ефимьевич	+7 781 536 8672	3930 799489	среднее профессиональное	7955
Регина	Ефремов	Демидович	8 875 125 00 40	8911 163125	\N	7956
Артем	Петров	\N	8 (263) 053-54-24	1851 782780	\N	7957
Мстислав	Ковалева	\N	85930016009	7112 455974	\N	7958
Иван	Устинов	\N	8 693 618 57 66	3627 184063	\N	7959
Дорофей	Лаврентьев	Архипович	+7 (210) 484-8273	1544 869956	среднее профессиональное	7960
Алина	Суворов	Ильинична	+72015395603	5070 745689	неоконченное высшее	7961
Лазарь	Гуляев	Оскаровна	+7 768 758 61 07	7391 615046	среднее	7962
Творимир	Сафонов	\N	8 498 352 38 81	8000 650115	среднее	7963
Лариса	Кудряшова	\N	+7 (200) 778-7714	3230 474187	среднее профессиональное	7964
Любим	Трофимова	Васильевич	8 305 308 93 93	3212 535533	среднее профессиональное	7965
Агафья	Зуев	\N	+7 859 712 5930	7579 533398	высшее	7966
Потап	Жукова	Дмитриевич	+7 (743) 691-48-30	8193 742047	среднее	8217
Ферапонт	Чернов	Александровна	+7 (586) 182-75-38	6355 131010	неоконченное высшее	7967
Ксения	Соловьева	\N	+7 (461) 749-56-77	9249 543355	высшее	7968
Варлаам	Носова	\N	8 312 998 69 66	2866 674209	высшее	7969
Владислав	Зимин	Андреевич	+74368214496	2583 386758	высшее	7970
Ладислав	Нестеров	\N	8 228 320 5128	9132 498285	высшее	7971
Осип	Стрелкова	\N	+7 673 097 9400	4505 163629	неоконченное высшее	7972
Арсений	Кошелева	\N	8 (707) 055-56-54	9761 878995	высшее	7973
Олимпиада	Буров	\N	+7 (681) 909-94-27	5529 309242	неоконченное высшее	7974
Гаврила	Гусева	Анисимович	8 (280) 352-9770	6382 667537	среднее профессиональное	7975
Леон	Михеева	\N	8 (556) 307-37-61	1735 430721	высшее	7976
Леонтий	Капустин	\N	8 796 046 9288	4136 109295	среднее профессиональное	7977
Тимур	Силина	Еремеевич	+7 (956) 154-67-52	8310 848830	среднее профессиональное	7978
Лидия	Носов	Аксёнович	+75228768452	7224 135224	\N	7979
Натан	Сысоев	Филипповна	8 552 340 83 16	2538 715179	среднее	7980
Модест	Беляев	\N	+7 451 710 17 63	7760 539991	высшее	7981
Милован	Быков	\N	+7 (716) 592-47-28	6299 920132	среднее профессиональное	7982
Парамон	Панов	Кузьминична	8 (598) 144-9612	2973 630431	неоконченное высшее	7983
Агап	Соколова	\N	8 (688) 280-8114	5745 886603	неоконченное высшее	7984
София	Мухина	Демидович	8 085 563 5337	9470 773587	высшее	7985
Галина	Кононова	Аркадьевна	+7 (272) 707-6973	3884 500967	высшее	7986
Лучезар	Воробьев	\N	85800512273	7476 271843	неоконченное высшее	7987
Олег	Давыдов	Рубеновна	+7 (921) 991-0161	2990 535354	неоконченное высшее	7988
Каллистрат	Куликова	Федосеевич	+7 387 873 2584	3759 407802	\N	7989
Чеслав	Осипова	\N	+7 853 930 0604	7649 539197	\N	7990
Елизар	Филатов	\N	8 390 449 3496	3743 726556	\N	7991
Болеслав	Лихачев	Матвеевна	+7 268 057 18 11	3874 407346	среднее	7992
Юлия	Ситникова	\N	81492713933	3568 147491	среднее профессиональное	7993
Зиновий	Егоров	Анатольевич	8 (007) 575-6681	4521 329965	среднее	7994
Фрол	Сорокина	\N	82530437486	2447 172443	среднее профессиональное	7995
Сергей	Гусева	\N	+7 (367) 011-52-71	2352 186540	среднее профессиональное	7996
Мартын	Лапина	\N	+7 837 413 7241	5528 856221	среднее	7997
Милен	Новиков	Владимировна	8 218 141 8857	6824 963059	среднее	7998
Лукьян	Панфилова	Никифоровна	8 217 265 5917	5741 524774	среднее	7999
Куприян	Мясникова	\N	+7 (978) 712-5979	2317 277677	неоконченное высшее	8000
Вадим	Николаева	Владиславовна	8 (864) 760-42-67	8181 893436	среднее	8001
Светлана	Журавлева	\N	+7 174 843 1137	8723 445527	высшее	8002
Максимильян	Авдеев	\N	8 636 691 7641	3574 626319	неоконченное высшее	8003
Твердислав	Данилов	Филиппович	+7 075 980 12 86	8186 836781	среднее профессиональное	8004
Валерий	Бобылева	\N	+7 348 653 18 54	8953 654584	высшее	8005
Тарас	Алексеева	\N	+7 969 117 8284	4905 204688	среднее	8006
Андрон	Владимиров	Адамович	8 (137) 251-63-41	7635 199268	неоконченное высшее	8007
Творимир	Шарапова	Григорьевич	8 170 027 52 93	9337 230982	среднее	8008
Вацлав	Афанасьева	Васильевич	81119941192	7569 658827	среднее	8009
Карл	Рогова	\N	+7 361 233 00 63	7495 262020	среднее профессиональное	8010
Евгений	Гурьева	Аверьянович	8 045 504 9549	5642 233799	среднее	8011
Аггей	Буров	Матвеевна	8 (485) 972-7506	9061 487663	неоконченное высшее	8012
Клавдия	Родионова	\N	+7 027 057 97 02	9021 482994	среднее	8013
Лаврентий	Родионова	\N	8 (548) 393-8452	1979 239420	высшее	8014
Изяслав	Моисеев	\N	+7 891 803 39 03	4445 210200	среднее профессиональное	8015
Гедеон	Дроздова	\N	+7 (785) 233-29-50	9279 959276	неоконченное высшее	8016
Панфил	Аксенов	Тимурович	+7 688 502 3862	8750 479635	среднее	8017
Афанасий	Иванова	\N	+7 (851) 046-05-16	7373 422247	среднее	8018
Арефий	Щукин	Антоновна	8 (958) 379-2750	8291 602519	среднее	8019
Филимон	Самсонов	\N	8 298 257 3237	1250 406048	среднее профессиональное	8020
Максим	Туров	\N	+79933074426	1633 222332	среднее профессиональное	8021
Кузьма	Муравьев	\N	8 (257) 287-08-08	4902 467926	\N	8022
Николай	Артемьев	\N	8 (847) 462-03-85	3650 475563	неоконченное высшее	8023
Порфирий	Матвеева	\N	+7 501 595 7645	8696 198310	неоконченное высшее	8024
Владилен	Шилов	Арсенович	+7 371 631 29 62	3710 685633	среднее профессиональное	8025
Светлана	Морозов	Всеволодович	+7 947 445 04 75	2203 610183	\N	8026
Тит	Кондратьева	\N	8 256 647 93 44	3968 727893	среднее	8027
Лавр	Николаева	Захарьевич	+7 (896) 646-3386	8937 452939	среднее профессиональное	8028
Василиса	Устинов	\N	+7 444 020 76 09	7106 590984	среднее профессиональное	8029
Сигизмунд	Одинцова	\N	+7 240 655 2065	6293 268389	\N	8030
Никифор	Субботин	\N	8 868 398 2808	3921 858562	высшее	8031
Панфил	Орлова	\N	8 (307) 014-6310	3933 988246	высшее	8032
Викентий	Сорокин	Ильясович	8 052 876 63 81	8649 696754	\N	8033
Аполлон	Максимова	Владленович	8 606 280 41 48	4828 895719	неоконченное высшее	8034
Август	Кулакова	\N	8 (786) 744-5556	3692 116752	высшее	8035
Евпраксия	Гуляева	Якубович	+7 (166) 924-9308	7313 878822	неоконченное высшее	8036
Максимильян	Лазарев	Адамович	+7 (056) 699-19-88	3922 482341	среднее	8037
Поликарп	Борисов	\N	+78266071201	5563 827508	среднее профессиональное	8038
Валентина	Антонов	\N	+7 119 169 3512	4724 161006	среднее	8039
Пимен	Жданов	\N	+7 154 347 43 94	2918 401720	высшее	8040
Геннадий	Субботин	Харлампович	+7 508 743 57 04	2568 966414	неоконченное высшее	8041
Фадей	Громова	\N	8 476 570 4053	4323 920979	\N	8042
Светлана	Иванов	\N	+79183750237	3660 824464	высшее	8043
Нина	Ильина	\N	8 950 917 31 48	8763 633750	среднее	8044
Агафон	Богданова	\N	+7 (177) 928-98-99	6100 449980	\N	8045
Прасковья	Лукина	Елисеевич	86789704069	1160 342255	среднее профессиональное	8046
Ангелина	Абрамова	\N	+7 750 745 51 24	9931 700113	\N	8047
Касьян	Степанов	Семеновна	8 407 674 5738	1382 205127	\N	8048
Стоян	Симонова	Матвеевич	+7 (411) 572-3969	9979 787157	\N	8049
Давыд	Боброва	\N	+7 054 347 96 94	7603 879388	высшее	8050
Эмилия	Кудрявцева	Федоровна	+7 (511) 399-69-89	7701 684349	среднее	8051
Мартын	Силин	\N	8 (662) 809-43-57	3636 101274	среднее профессиональное	8052
Эраст	Терентьева	\N	+7 (853) 255-41-89	9187 307655	неоконченное высшее	8053
Рюрик	Кулаков	Ануфриевич	+7 (238) 999-0407	8491 348283	неоконченное высшее	8054
Милан	Захарова	\N	+7 776 106 4082	1273 818087	среднее профессиональное	8055
Евдоким	Петрова	Виленович	+7 (386) 377-3747	2291 319202	среднее	8056
Симон	Харитонов	Георгиевна	82739562958	4520 995862	среднее	8057
Екатерина	Николаева	\N	8 334 904 5152	7052 311075	\N	8058
Кондрат	Шарапов	Валентинович	8 317 375 2063	9039 236260	высшее	8059
Евдоким	Моисеева	\N	8 078 692 1401	9238 749208	высшее	8060
Ювеналий	Белоусова	\N	8 (771) 459-88-65	7233 835285	высшее	8061
Доброслав	Зайцев	Петровна	82571389591	4611 234897	неоконченное высшее	8062
Валерьян	Кузнецов	Брониславович	+76281147863	8241 678591	высшее	8063
Андрей	Шашков	Иларионович	83118396698	4481 143891	среднее	8064
Владилен	Шилов	Филимонович	+7 (174) 523-8684	2380 385300	среднее профессиональное	8065
Боян	Красильников	\N	8 (671) 730-25-08	8959 404901	высшее	8066
Герасим	Шарова	Игоревна	8 (697) 872-26-29	1353 997591	высшее	8067
Марфа	Воробьев	Филатович	+71759951704	1237 748581	неоконченное высшее	8068
Арсений	Виноградова	Егоровна	8 669 906 52 50	1836 513834	среднее профессиональное	8069
Сильвестр	Рогов	\N	8 (812) 191-21-29	5834 959305	\N	8070
Прохор	Галкин	\N	8 191 493 0450	1399 120635	высшее	8071
Рубен	Рожкова	Исидорович	+75546944197	4465 504008	\N	8072
Сидор	Гурьева	Евстигнеевич	+7 (205) 886-9558	9797 792475	среднее	8073
Олег	Давыдова	Филатович	+70466420425	9086 197704	среднее профессиональное	8074
Владимир	Харитонов	Степановна	8 (747) 313-3384	1642 713971	высшее	8075
Эраст	Морозов	\N	8 261 458 6673	6014 386208	среднее профессиональное	8076
Сократ	Давыдова	\N	8 (886) 167-7916	2922 324146	\N	8077
Мокей	Некрасов	Фадеевич	+79690817674	5794 862339	неоконченное высшее	8078
Давыд	Кудрявцева	\N	+77839754284	1300 618061	среднее	8079
Вениамин	Устинов	Бориславович	8 (690) 568-2590	3351 297984	неоконченное высшее	8080
Дорофей	Воронов	Вадимовна	8 102 624 8426	8423 204341	высшее	8081
Никанор	Воробьев	Антоновна	+7 (225) 167-4397	7334 731431	\N	8082
Спартак	Елисеева	\N	+7 842 670 65 04	9943 188277	\N	8083
Варфоломей	Давыдов	Августович	8 238 086 52 61	8154 295925	высшее	8084
Севастьян	Бобров	\N	+7 (943) 991-9033	6914 979538	\N	8085
Авдей	Трофимова	\N	81357884365	3127 110552	неоконченное высшее	8086
Вацлав	Субботин	\N	8 (632) 073-3229	8807 921719	\N	8087
Эдуард	Жданов	\N	+75864152845	7721 787965	среднее профессиональное	8088
Спартак	Дьячкова	Евстигнеевич	+73159029817	2094 877571	\N	8089
Владимир	Давыдов	Ефимович	+7 (649) 373-2795	5704 688425	высшее	8090
Остап	Фомина	\N	8 (507) 937-30-72	6536 106030	\N	8091
Алевтина	Антонова	Всеволодович	8 (336) 608-5254	6784 195682	неоконченное высшее	8094
Лавр	Степанова	\N	8 (282) 322-0103	7168 774242	среднее профессиональное	8095
Глеб	Бобылева	Фёдорович	8 710 168 3328	9355 175636	высшее	8096
Григорий	Орлов	Викентьевич	8 (789) 227-88-48	4744 599957	высшее	8097
Дорофей	Костин	Евгеньевна	8 (228) 329-2456	1253 352370	среднее	8098
Карл	Евсеев	Валерианович	+78529493417	9380 986382	\N	8099
Митофан	Исаев	Анатольевич	+76431447434	1105 282329	среднее	8100
Татьяна	Филатов	\N	8 970 957 1939	5886 644993	среднее	8101
Казимир	Муравьева	Всеволодович	+79215092082	1950 693356	неоконченное высшее	8102
Аскольд	Одинцова	\N	84574772748	3682 538846	высшее	8103
Ростислав	Белякова	\N	8 (373) 553-35-49	6575 663108	неоконченное высшее	8104
Платон	Маслов	Ефимович	+7 020 127 0913	5724 447790	высшее	8105
Максимильян	Блинова	Ильич	+7 (248) 051-9394	9899 392845	высшее	8106
Ростислав	Сергеев	Вилорович	86468777001	4762 452193	высшее	8107
Мария	Зуев	\N	8 748 056 18 76	7278 114650	высшее	8108
Тамара	Ширяев	\N	+7 (362) 923-22-00	4516 430864	неоконченное высшее	8109
Панкрат	Цветкова	\N	+7 (552) 528-2401	9460 937347	высшее	8110
Ратибор	Калинин	Адамович	85888557733	6408 699868	среднее профессиональное	8111
Матвей	Никонова	\N	+7 (385) 368-5508	4765 115771	\N	8112
Майя	Анисимова	Вадимовна	8 730 520 50 91	7092 201352	среднее профессиональное	8113
Спиридон	Михайлова	Натановна	8 (683) 848-23-57	9815 671400	\N	8114
Кузьма	Сорокин	Герасимович	8 077 892 64 05	9413 295597	неоконченное высшее	8115
Гордей	Алексеева	Витальевич	8 (965) 773-55-73	6954 287900	\N	8116
Милан	Фокина	Юлианович	8 (401) 072-14-13	3271 887453	высшее	8117
Ираклий	Хохлов	Олеговна	8 (188) 632-0646	8165 529646	среднее	8118
Аристарх	Молчанова	Анатольевна	8 622 201 31 90	9796 160798	неоконченное высшее	8119
Фока	Рогов	Кузьминична	82894241023	5567 139599	высшее	8120
Ерофей	Кононов	Вячеславовна	+74665657049	2418 891262	среднее	8121
Денис	Игнатьева	\N	8 912 828 6427	3548 735395	среднее профессиональное	8122
Сильвестр	Михайлов	Захарьевич	+7 (152) 453-4660	7012 605242	среднее профессиональное	8123
Арсений	Третьякова	Аскольдовна	+7 275 864 7566	9517 676475	неоконченное высшее	8124
Жанна	Щукин	Евстигнеевич	+7 (994) 584-3289	4746 636540	среднее профессиональное	8125
Милий	Журавлева	\N	+7 330 801 7304	8159 544660	среднее профессиональное	8126
Любим	Калашникова	\N	8 798 115 13 91	9597 958647	среднее	8127
Святослав	Макарова	Викторович	+75903800878	4688 286695	среднее	8128
Ипатий	Корнилов	\N	+7 464 326 3291	1060 251343	высшее	8129
Евпраксия	Владимирова	\N	8 (266) 351-6382	4381 733266	\N	8130
Аркадий	Голубев	\N	+7 (897) 597-59-66	5702 923497	неоконченное высшее	8131
Акулина	Кудряшова	\N	+7 477 941 7118	6325 843701	\N	8132
Исай	Рожков	Кирилловна	8 (029) 965-1878	5010 152291	\N	8133
Ярослав	Ермаков	Демьянович	8 389 188 75 19	9569 802424	\N	8134
Феврония	Ширяева	\N	+7 (577) 821-5532	2766 441130	высшее	8135
Агата	Соколова	Фадеевич	+7 691 761 7832	1504 168080	неоконченное высшее	8136
Раиса	Шарапова	\N	+7 (995) 148-10-29	9024 482624	неоконченное высшее	8137
Исидор	Гусева	Феликсович	87791232797	5961 524425	неоконченное высшее	8138
Арефий	Семенова	Адрианович	+7 (168) 194-3885	4543 216628	\N	8139
Евпраксия	Назаров	\N	+7 (033) 005-65-60	2353 814816	среднее	8140
Нонна	Лукин	\N	81501558727	8211 294259	неоконченное высшее	8141
Потап	Голубева	Евгеньевна	8 962 144 3061	5544 866680	высшее	8142
Тимофей	Шарапова	\N	+7 067 950 67 73	6101 130352	неоконченное высшее	8143
Федот	Дмитриев	\N	81964551381	6956 204600	неоконченное высшее	8144
Сергей	Александров	\N	+74207349572	4616 382926	неоконченное высшее	8145
Елисей	Давыдова	\N	85978664009	4032 620876	среднее	8146
Анисим	Сорокин	Оскаровна	+7 (795) 347-6957	8229 464885	высшее	8147
Пахом	Никифорова	\N	+7 792 129 24 93	9249 324400	неоконченное высшее	8148
Фотий	Дорофеев	Эдуардович	+7 862 446 2165	8370 925247	неоконченное высшее	8149
Ольга	Сидорова	\N	8 597 877 2486	5573 999967	высшее	8150
Ипполит	Меркушев	Тарасович	83292498952	8043 532988	\N	8151
Игорь	Кулагина	\N	+77725776823	4564 446980	высшее	8152
Фока	Мельников	Виленович	82461508702	7121 141011	среднее профессиональное	8153
Парфен	Исакова	\N	+7 818 050 02 69	5139 752597	неоконченное высшее	8154
Рюрик	Белозеров	Юльевич	8 079 168 8267	7550 565856	среднее	8218
Алексей	Агафонова	\N	+7 991 539 7100	6130 973863	неоконченное высшее	8155
Ладимир	Капустина	\N	8 217 581 5828	8463 152277	среднее профессиональное	8156
Терентий	Горбачев	\N	8 (784) 642-19-08	1602 439760	среднее	8157
Станислав	Бобров	Аверьянович	+7 334 281 11 44	3293 708736	среднее	8158
Борис	Титова	Геннадьевна	8 496 103 1256	3117 740854	неоконченное высшее	8159
Силантий	Александров	\N	8 (056) 297-44-35	8492 998187	среднее профессиональное	8160
Полина	Ефимова	Арсеньевич	+72195990475	4189 110902	среднее	8161
Арсений	Медведев	\N	+7 257 507 65 52	5477 763560	\N	8162
Алевтина	Голубев	Фокич	+7 (202) 537-96-64	6387 617298	среднее	8163
Мина	Дмитриева	\N	8 (463) 373-68-41	6877 643097	высшее	8164
Пахом	Максимов	Ефимовна	8 (972) 320-6784	6476 250687	среднее	8165
Ростислав	Михайлов	Егоровна	+7 086 053 55 55	8731 878548	неоконченное высшее	8166
Пахом	Лукина	\N	+70808271416	5486 738083	\N	8167
Синклитикия	Шашкова	Филатович	+7 (277) 250-0897	1314 854624	среднее	8168
Герасим	Одинцов	Филимонович	8 (781) 827-2521	6315 821413	среднее профессиональное	8169
Алексей	Никонова	Ефимович	8 000 555 8136	1993 136285	неоконченное высшее	8170
Август	Лыткина	Иосипович	8 606 746 0834	5142 120596	среднее	8171
Никифор	Данилова	\N	+7 046 550 90 15	8834 252157	\N	8172
Филимон	Попова	\N	+7 (833) 026-04-09	7575 312630	высшее	8173
Бронислав	Родионова	\N	+7 (060) 729-3921	6535 627800	\N	8174
Ульян	Панфилова	\N	+7 (716) 736-3206	1076 854186	среднее	8175
Георгий	Бобылев	\N	+7 (951) 095-42-01	7378 399377	неоконченное высшее	8176
Лора	Тарасов	\N	+7 905 476 0902	4547 773724	\N	8177
Натан	Рябов	Ефимович	+7 240 739 9155	5505 333770	среднее	8178
Будимир	Жданова	Аркадьевна	8 533 137 4852	4816 993601	среднее	8179
Захар	Цветкова	\N	8 266 004 33 13	7183 281875	среднее профессиональное	8180
Исай	Сафонова	Бенедиктович	+7 (649) 907-96-97	2898 816200	\N	8181
Агафон	Блохин	\N	8 972 840 19 37	8301 944245	среднее	8182
Максим	Сидоров	Жанович	+7 681 525 73 77	5638 656126	среднее	8183
Фаина	Воронова	Юрьевна	+75418661658	9384 710522	высшее	8184
Януарий	Комиссаров	\N	8 (038) 154-72-53	3428 485148	среднее	8185
Фёкла	Богданов	\N	+75571570584	3323 252888	\N	8186
Пимен	Захаров	Кузьминична	80584333832	7614 229519	неоконченное высшее	8187
Юлий	Третьяков	\N	+7 (867) 018-06-42	8210 707679	высшее	8188
Демид	Некрасова	Евсеевич	+7 666 171 27 02	4912 502677	высшее	8189
Петр	Стрелков	\N	+70864995787	1392 315804	среднее	8190
Синклитикия	Федотова	Арсеньевич	8 389 126 8119	4525 266138	среднее	8191
Руслан	Андреев	Владленович	+7 (150) 377-59-41	8799 487289	высшее	8192
Трифон	Дмитриева	Федосьевич	+7 797 909 5525	5150 142433	среднее профессиональное	8193
Аникей	Селиверстова	\N	8 202 881 50 83	6923 185491	среднее профессиональное	8194
Тихон	Тарасов	Кузьминична	+7 706 015 18 31	2363 487897	неоконченное высшее	8195
Полина	Зимина	Архипович	+7 (950) 962-21-13	9732 275614	среднее профессиональное	8196
Фаина	Журавлева	Давыдович	+7 (582) 561-1899	8599 292636	среднее профессиональное	8197
Эммануил	Комаров	Наумовна	8 (758) 661-07-99	2103 209717	\N	8198
Климент	Пестов	Эдуардович	8 295 309 3136	9373 233950	среднее	8199
Ерофей	Лебедева	\N	+7 228 970 2549	9370 738282	\N	8200
Ерофей	Князев	Руслановна	+7 (333) 689-75-69	2248 477941	среднее профессиональное	8201
Иннокентий	Романов	\N	8 (687) 649-3079	5772 597204	высшее	8202
Агафья	Соболев	\N	8 968 081 9585	7670 260380	\N	8203
Надежда	Куликова	\N	+72689609617	5486 683761	среднее	8204
Адам	Родионова	\N	+7 557 604 8435	5139 583676	среднее	8205
Архип	Титов	Аркадьевна	+7 (133) 135-52-80	7113 595300	неоконченное высшее	8206
Ефим	Стрелкова	\N	+7 579 838 97 04	8238 218795	\N	8207
Ярополк	Муравьева	\N	+7 860 770 2106	8335 588288	среднее профессиональное	8208
Казимир	Субботина	Филиппович	+7 (306) 978-4312	9931 820424	неоконченное высшее	8209
Сила	Афанасьева	Тихонович	8 (569) 402-3262	1204 768809	среднее профессиональное	8210
Лонгин	Пестов	Марсович	+7 198 838 8276	2371 705785	среднее профессиональное	8211
Федот	Рогов	Игнатович	8 875 919 0674	6734 212815	среднее	8212
Мина	Юдина	Ермолаевич	+72676536239	8663 790683	высшее	8213
Аристарх	Стрелкова	Чеславович	8 (154) 215-12-98	4418 301465	среднее	8214
Анастасия	Мамонтова	Архипович	+7 (529) 217-60-58	1575 833640	высшее	8215
Конон	Евсеев	Матвеевна	+7 (813) 855-3054	8059 703851	среднее	8216
Герасим	Абрамов	Валерианович	85596719029	9518 603619	неоконченное высшее	8219
Валерий	Крылова	\N	80198958897	3367 680794	среднее профессиональное	8220
Мария	Кулагина	Аксёнович	80360753680	6852 295388	среднее	8221
Богдан	Меркушева	\N	+7 (080) 673-45-87	5597 938566	высшее	8222
Виктория	Кошелев	Антонович	+7 643 696 2086	9169 850271	высшее	8223
Лукьян	Субботин	Арсеньевич	+7 469 654 3523	1837 485186	среднее	8224
Варвара	Белов	\N	+7 825 106 67 19	2812 260573	среднее	8225
Эраст	Ершова	\N	+7 508 009 2629	8819 506452	среднее	8226
Лука	Маркова	\N	+7 890 482 1321	3600 501881	высшее	8227
Пров	Пестов	\N	+77961026836	7048 710724	\N	8228
Назар	Куликова	Антонович	+7 (528) 990-20-08	8608 290453	среднее профессиональное	8229
Дементий	Ефремова	\N	84816792883	1617 127643	высшее	8230
Клавдий	Самсонов	\N	+7 (833) 467-8814	6817 114588	среднее профессиональное	8231
Вероника	Крюкова	Антонович	+7 (474) 362-48-63	3831 511429	среднее	8232
Феврония	Савина	Кирилловна	+73466449537	5332 770206	\N	8233
Добромысл	Анисимов	\N	8 (012) 712-30-24	2573 718749	высшее	8234
Селиван	Мамонтов	Артурович	+7 (709) 127-9571	4315 594882	среднее профессиональное	8235
Фока	Суворов	\N	8 072 348 5730	3960 813212	среднее	8236
Рюрик	Тимофеева	\N	+7 083 034 1047	4854 619528	среднее профессиональное	8237
Евстафий	Суворов	\N	8 (114) 830-3779	7775 642275	\N	8238
Вячеслав	Воробьева	\N	+7 (291) 930-4910	6343 865410	среднее профессиональное	8239
Федосий	Никонова	Эдуардовна	8 759 137 8855	5120 733409	высшее	8240
Стоян	Блинова	\N	+7 125 174 3857	6428 331815	неоконченное высшее	8241
Серафим	Смирнова	Никифоровна	+7 (733) 919-4897	5411 753967	высшее	8242
Михей	Лебедева	\N	+73808635999	2959 154642	\N	8243
Устин	Сысоев	\N	8 (230) 725-9656	5893 527446	среднее профессиональное	8244
Никифор	Ширяев	\N	+7 (040) 038-43-96	5579 832542	неоконченное высшее	8245
Юлиан	Фомичев	\N	8 910 785 01 45	4232 774614	неоконченное высшее	8246
Митофан	Мясников	\N	+7 (091) 849-3458	1855 412072	высшее	8247
Карл	Родионов	Геннадиевич	8 229 254 9336	1089 100675	высшее	8248
Михаил	Кудряшова	\N	82851514937	3184 588242	неоконченное высшее	8249
Архип	Горбачева	\N	8 (278) 683-7223	6217 695284	неоконченное высшее	8250
Богдан	Потапова	\N	8 (722) 853-0166	8005 310763	высшее	8251
Тимофей	Шестакова	\N	8 (327) 963-39-56	3209 478480	неоконченное высшее	8252
Любовь	Баранов	\N	80751095826	3188 285302	\N	8253
Всеслав	Самсонов	Валерьевич	+76423631031	1822 267446	высшее	8254
Еремей	Кузнецов	Захарьевич	8 933 738 61 18	5126 698766	среднее профессиональное	8255
Дорофей	Некрасов	Максимовна	+7 (054) 670-8193	8956 438257	среднее профессиональное	8256
Ефим	Мишин	Сергеевна	8 732 789 8623	3512 482382	неоконченное высшее	8257
Ростислав	Богданова	Харлампьевич	87298465167	2353 475879	неоконченное высшее	8258
Ефрем	Гришина	\N	8 237 023 97 69	3435 727195	\N	8259
Ладимир	Калинина	\N	+7 (726) 971-53-21	1767 290029	\N	8260
Мокей	Шестакова	\N	+7 882 341 4244	6544 355360	среднее	8261
Будимир	Третьяков	Олеговна	+7 147 260 26 91	8590 820543	среднее профессиональное	8262
Радим	Красильникова	\N	+7 (109) 274-0933	3112 575585	неоконченное высшее	8263
Леонтий	Копылов	\N	+7 644 279 9643	7705 814322	высшее	8264
Филипп	Алексеева	Константиновна	8 (076) 957-8577	2466 741469	\N	8265
Сила	Сидоров	Елисеевич	+7 (699) 284-14-88	2510 187212	\N	8266
Ангелина	Лобанова	Владиславовна	+7 (426) 770-50-10	7293 124623	среднее	8267
Эдуард	Исаков	\N	+7 (062) 727-20-80	1554 725088	высшее	8268
Мефодий	Николаев	Ерофеевич	+77577458809	7771 697972	\N	8269
Владимир	Субботина	\N	8 (659) 849-08-82	3664 522850	среднее	8270
Тимур	Воронова	Ефстафьевич	8 (305) 087-8951	5556 630963	среднее	8271
Трофим	Волков	Семеновна	81740059046	2169 155625	среднее профессиональное	8272
Мария	Сысоев	Ильясович	+74443481002	6291 511692	среднее профессиональное	8273
Юлиан	Шилов	\N	8 925 882 88 40	3063 193953	\N	8274
Всемил	Беляков	\N	8 (391) 371-20-58	7088 676799	высшее	8275
Феоктист	Денисов	Викторовна	+7 598 064 0463	7494 382775	среднее	8276
Вера	Шилов	\N	+7 338 381 8058	5923 719892	\N	8277
Соломон	Миронова	Евсеевич	8 (434) 571-20-96	8646 683045	среднее профессиональное	8278
Бронислав	Александров	Трофимович	+7 194 066 34 18	7769 334153	неоконченное высшее	8279
Мефодий	Белоусова	Руслановна	8 (043) 052-3880	3319 832104	среднее	8280
Аггей	Копылова	\N	8 428 885 81 44	8981 872708	неоконченное высшее	8281
Доброслав	Корнилов	\N	8 599 919 99 59	9020 787959	среднее	8282
Мир	Кулагин	Евстигнеевич	+71348824634	5219 406634	высшее	8283
Емельян	Кудряшов	Юльевич	8 336 297 8817	7898 135044	\N	8284
Алексей	Гущина	\N	8 (324) 322-30-08	2595 334653	высшее	8285
Панкратий	Кабанова	\N	+7 945 286 5665	7650 698015	высшее	8286
Игорь	Носов	\N	+7 723 251 0556	3487 175180	среднее профессиональное	8287
Филимон	Евсеева	Петровна	8 (819) 578-1976	5265 756929	высшее	8288
Симон	Фомичев	\N	85878849768	8569 671069	среднее профессиональное	8289
Ираклий	Щукина	Абрамович	8 293 259 0491	6308 532786	высшее	8290
Ефрем	Соколова	\N	8 (110) 397-47-60	7055 157941	неоконченное высшее	8291
Сильвестр	Зыкова	Гордеевич	8 (522) 922-2472	1726 948661	\N	8292
Феоктист	Ситникова	\N	+7 (618) 328-03-71	6459 873832	среднее профессиональное	8293
Никифор	Овчинникова	\N	8 (067) 292-8894	6775 685079	\N	8294
Артем	Романов	Афанасьевич	+7 320 031 60 92	3032 593171	среднее профессиональное	8295
Фотий	Котова	Антоновна	8 130 417 43 78	7783 883785	\N	8296
Анжелика	Новикова	\N	8 (103) 224-93-14	5570 564910	среднее профессиональное	8297
Юлия	Виноградов	\N	+7 128 356 45 21	1160 668598	среднее профессиональное	8298
Борис	Селезнева	Теймуразович	+76116096189	4572 984121	высшее	8299
Лавр	Филатова	Ефимовна	8 (281) 162-86-87	4247 424935	неоконченное высшее	8300
Федосий	Голубев	\N	+7 585 228 0085	6353 770784	среднее профессиональное	8301
Антип	Пахомов	\N	+7 (924) 554-4513	2720 515902	неоконченное высшее	8302
Чеслав	Сысоев	\N	+73682165613	7984 218022	\N	8303
Архип	Крюков	\N	8 710 647 65 56	1557 127427	неоконченное высшее	8304
Фадей	Бобылев	Анатольевна	8 340 305 55 84	1859 804281	среднее	8305
Терентий	Федорова	\N	8 589 627 2500	1406 129918	среднее	8306
Элеонора	Третьякова	\N	8 (587) 848-6874	4321 800531	среднее	8307
Филарет	Харитонов	\N	8 (005) 709-87-97	6758 481429	среднее профессиональное	8308
Добромысл	Петухова	Дорофеевич	82602551126	1709 582343	среднее профессиональное	8309
Савватий	Яковлев	Демидович	+7 151 487 51 56	7858 258335	\N	8310
Адам	Голубев	\N	+7 001 471 7653	5014 454548	\N	8311
Емельян	Меркушев	\N	+7 (149) 906-37-04	6505 117371	неоконченное высшее	8312
Амос	Игнатов	Владимировна	8 (263) 672-3769	4312 374862	среднее	8313
Таисия	Евсеев	Валерьянович	+7 804 884 98 44	9883 438307	среднее	8314
Аполлинарий	Лебедев	\N	+7 (333) 326-3860	7135 262177	высшее	8315
Ксения	Сидорова	Рубеновна	86174904537	3382 250230	среднее	8316
Радим	Власова	\N	+7 (351) 336-08-15	8143 525525	неоконченное высшее	8317
Антонина	Кудряшова	Кузьминична	+7 (068) 975-3943	9247 270414	\N	8318
Орест	Гущина	Матвеевич	+7 (433) 801-2239	6335 628269	среднее	8319
Лукьян	Наумова	\N	8 (520) 599-49-32	1671 507210	высшее	8320
Януарий	Владимирова	Сергеевна	+7 (822) 497-9832	6785 700462	\N	8321
Анастасия	Исакова	\N	+7 (324) 085-1446	6717 740011	\N	8322
Игорь	Якушев	\N	+7 (570) 008-52-15	2831 933926	высшее	8323
Ярослав	Потапова	Робертовна	+7 (228) 158-9205	8011 185511	\N	8324
Панкратий	Фомин	Петровна	81967246490	9842 147727	среднее профессиональное	8325
Алла	Лапина	Вячеславовна	8 (692) 835-29-58	9838 208678	\N	8326
Остромир	Федотов	\N	8 (047) 225-49-54	3110 743098	\N	8327
Октябрина	Аксенов	Демьянович	+76022569932	3730 965381	неоконченное высшее	8328
Анжела	Мартынова	Арсеньевич	+7 912 597 4442	3402 715325	среднее профессиональное	8329
Геннадий	Костин	Макаровна	+7 450 049 7571	8724 202496	\N	8330
Елизар	Большаков	Ефимович	+7 (119) 143-1791	9655 892711	\N	8331
Иван	Кононова	\N	8 439 856 3365	3327 930451	высшее	8332
Чеслав	Богданов	Сергеевна	+7 (535) 753-63-04	7474 861664	среднее	8333
Леонид	Киселева	\N	8 (871) 584-0881	2192 749030	\N	8334
Милица	Кириллова	\N	+79881073567	4116 607012	среднее профессиональное	8335
Руслан	Мясникова	\N	+7 711 994 5224	1105 503309	среднее	8336
Олимпий	Третьякова	Георгиевна	+7 047 232 1890	2213 208512	высшее	8337
Иосиф	Чернов	Фадеевич	8 595 880 5508	8834 870640	неоконченное высшее	8338
Ратмир	Петухова	Юльевич	+7 754 572 39 24	4576 922654	\N	8339
Гостомысл	Моисеева	Чеславович	8 310 925 1071	4154 281091	\N	8340
Викторин	Пестов	Святославовна	8 403 711 0495	8413 155814	\N	8341
Регина	Шаров	Валентиновна	+7 (697) 346-0007	6124 672170	среднее профессиональное	8342
Оксана	Афанасьева	\N	8 610 018 6935	2457 578363	среднее профессиональное	8343
Гурий	Мартынова	\N	8 (646) 207-9871	1399 169850	среднее профессиональное	8344
Мир	Бобылев	\N	85706982128	4739 287444	среднее профессиональное	8345
Харитон	Миронова	Харитоновна	82091859734	4007 830872	неоконченное высшее	8346
Виктория	Денисов	\N	8 (904) 110-1583	1288 689437	высшее	8347
Всеволод	Гусева	Виленович	+7 (966) 512-8251	4911 154600	неоконченное высшее	8348
Афиноген	Полякова	\N	+70269148169	6112 738149	среднее профессиональное	8349
Татьяна	Моисеева	Афанасьевна	+7 358 068 8262	9633 633427	среднее	8350
Синклитикия	Фролова	Феликсович	+7 202 547 5683	4415 866803	неоконченное высшее	8351
Радован	Котов	Геннадиевич	+7 (431) 754-41-90	2324 533272	неоконченное высшее	8352
Гремислав	Кузнецова	\N	8 189 939 39 32	7607 146059	высшее	8353
Николай	Кошелев	\N	88335722059	8850 578312	среднее	8354
Капитон	Носова	Ярославович	85776676628	8203 230592	\N	8355
Иосиф	Сазонов	\N	8 (252) 550-45-26	8232 356030	\N	8356
Михаил	Константинова	\N	8 (506) 008-3516	1643 933900	среднее профессиональное	8357
Геннадий	Петухова	Архипович	8 780 022 2484	7618 193244	\N	8358
Элеонора	Козлов	\N	8 873 607 8145	1316 457985	высшее	8359
Октябрина	Кузнецов	Леоновна	8 (191) 423-99-54	9265 250764	\N	8360
Софон	Шарапов	Денисович	8 055 003 37 24	1005 727643	\N	8361
Андрон	Пахомова	Гаврилович	+7 (173) 820-7407	2338 467538	\N	8362
Карл	Блохин	Антоновна	8 483 480 23 61	8052 633113	неоконченное высшее	8363
Клавдий	Денисова	Августович	8 (075) 528-8988	6824 350972	неоконченное высшее	8364
Ратибор	Котов	\N	8 604 186 0160	5823 529122	среднее профессиональное	8365
Самуил	Якушева	\N	8 815 556 86 13	6421 586637	среднее профессиональное	8366
Пелагея	Емельянов	\N	+7 (566) 333-27-54	1623 820957	неоконченное высшее	8367
Богдан	Никонов	\N	+7 (014) 919-49-54	4097 661065	\N	8368
Иларион	Прохорова	Федотович	8 019 244 8414	2953 185001	среднее профессиональное	8369
Богдан	Миронов	\N	8 271 186 2944	6441 982085	\N	8370
Тамара	Королев	Еремеевич	8 (342) 777-4755	6559 770065	\N	8371
Виссарион	Киселева	\N	8 066 944 0471	7851 234524	среднее профессиональное	8372
Спиридон	Алексеев	\N	+7 (996) 232-3338	1695 416776	высшее	8373
Евграф	Костин	Афанасьевич	8 (023) 504-58-17	7017 639849	\N	8374
Иосиф	Гуляева	\N	84179218100	4899 652166	\N	8375
Андрон	Федоров	Владленович	8 929 687 64 17	9715 589109	\N	8376
Прохор	Назаров	\N	+7 (052) 486-40-13	7578 978990	среднее профессиональное	8377
Евгений	Чернова	\N	+7 693 736 9393	9509 651962	среднее профессиональное	8378
Артемий	Евдокимова	Викторовна	8 574 819 4645	8218 715643	высшее	8379
Алина	Якушева	Борисовна	+72616095087	1981 834693	среднее	8380
Адриан	Самойлов	\N	8 (717) 894-0141	7391 596317	высшее	8381
Панкратий	Абрамова	\N	8 283 053 46 38	4258 189859	\N	8382
Филимон	Миронова	\N	+7 129 714 77 61	6568 116650	высшее	8383
Ульяна	Яковлева	Георгиевич	8 622 337 96 30	6592 341467	неоконченное высшее	8384
Рюрик	Иванов	\N	8 559 800 11 90	6150 898791	среднее профессиональное	8385
Климент	Дроздов	\N	+7 919 029 9333	4838 381233	неоконченное высшее	8386
Синклитикия	Некрасова	Ильич	+7 (115) 316-3752	3171 312458	среднее	8387
Виктор	Евдокимова	Федосьевич	+7 (409) 267-81-33	4879 337831	высшее	8388
Порфирий	Мясникова	Евгеньевна	8 (460) 342-35-27	3024 929379	неоконченное высшее	8389
Бронислав	Владимирова	Якубович	+7 (311) 859-1172	8362 188522	среднее	8390
Виктор	Нестерова	Тихонович	+7 835 223 3337	6689 308836	\N	8391
Панфил	Александрова	\N	+7 (628) 414-37-32	3195 518513	среднее	8392
Екатерина	Одинцов	\N	8 (098) 331-07-70	7771 459818	среднее	8393
Всемил	Елисеев	\N	+74004251182	4120 789735	неоконченное высшее	8394
Аверьян	Тихонова	Устинович	+79402945725	7081 465661	\N	8395
Иосиф	Полякова	Аксёнович	+78083261385	1122 423301	\N	8396
Валентина	Капустина	\N	+7 493 434 06 60	2024 304963	\N	8397
Авдей	Новиков	\N	80575936554	6435 610420	неоконченное высшее	8398
Пантелеймон	Ермакова	Афанасьевна	+7 703 694 03 02	4584 524989	\N	8399
Аскольд	Агафонов	\N	+7 763 134 5456	6053 365538	\N	8400
Иван	Савельева	\N	+7 (575) 899-3448	6185 558621	среднее	8401
Леонтий	Кудряшов	Игнатьевич	+7 (137) 062-7260	1759 592860	высшее	8402
Любосмысл	Горбунов	Герасимович	+7 189 028 8797	6107 466446	среднее	8403
Алевтина	Быков	\N	+7 (235) 279-0646	2432 637879	\N	8404
Савелий	Карпова	Ярославович	+7 (818) 621-7582	5365 340370	\N	8405
Мария	Мартынов	\N	+76613216278	5514 885827	высшее	8406
Василий	Никитина	\N	+7 (140) 219-5466	6294 912834	среднее	8407
Якуб	Волкова	\N	8 116 912 8833	5050 746397	\N	8408
Рубен	Суворов	Даниловна	8 726 135 9590	2028 443534	среднее профессиональное	8409
Серафим	Зуев	Руслановна	+7 756 488 9748	2640 312769	среднее	8410
Раиса	Горшков	\N	+7 273 409 0437	1216 249666	высшее	8411
Рюрик	Гуляев	\N	8 506 898 3502	7803 303490	среднее	8412
Емельян	Беляков	Дмитриевич	+7 577 014 0179	2925 327468	\N	8413
Селиверст	Симонов	\N	8 (082) 129-60-10	5463 303703	\N	8414
Трофим	Авдеев	Тарасовна	+7 (831) 013-6939	8124 675891	высшее	8415
Панкратий	Ситникова	\N	+7 (558) 490-83-46	1594 299732	среднее	8416
Марк	Журавлева	Максимовна	+7 664 132 1605	9753 666103	высшее	8417
Натан	Некрасова	\N	8 995 976 39 23	2557 519481	среднее профессиональное	8418
Ярополк	Савельев	Феодосьевич	8 (028) 331-9452	5226 427612	высшее	8419
Ярослав	Тетерина	Юльевич	89039839440	7280 762624	неоконченное высшее	8420
Богдан	Ширяев	\N	8 (068) 594-4231	1345 556508	среднее профессиональное	8421
Наина	Беспалов	Львовна	85801817291	5388 546522	неоконченное высшее	8422
Карп	Бобров	\N	8 (718) 684-39-37	8455 191161	высшее	8423
Евстафий	Князев	Харитоновна	8 (234) 657-9170	5633 150479	среднее	8424
Светозар	Фадеев	\N	+7 460 748 3000	2133 203457	высшее	8425
Софон	Блохин	Константиновна	+7 731 314 36 18	1063 265998	высшее	8426
Ираклий	Харитонов	\N	8 (424) 722-4462	6011 379851	высшее	8427
Лука	Егорова	Афанасьевна	81488373189	4027 596751	высшее	8428
Нина	Тихонова	Захаровна	+7 562 320 1513	4215 481384	неоконченное высшее	8429
Яков	Ларионов	\N	8 068 840 22 63	3478 815121	неоконченное высшее	8430
Мария	Исаева	\N	+7 141 647 46 14	7877 647380	среднее	8431
Святослав	Белозерова	\N	+7 831 237 4398	1358 771839	\N	8432
Август	Сидорова	Игнатович	8 166 732 4697	8597 174314	высшее	8433
Ростислав	Емельянова	Вячеславович	8 (853) 855-49-77	9931 477540	\N	8434
Ульян	Меркушев	\N	+7 (445) 816-3529	3483 818306	среднее профессиональное	8435
Бажен	Дьячкова	Эдгардович	+7 (896) 356-23-72	3682 472442	высшее	8436
Аскольд	Меркушев	Робертовна	87273098278	4011 108765	\N	8437
Анжела	Зиновьева	\N	8 615 143 9305	1759 287665	среднее	8438
Евсей	Суханова	Валерьевич	8 (577) 532-5946	1953 475267	высшее	8439
Борис	Петухова	Матвеевич	+7 039 833 06 82	3847 341243	высшее	8440
Ипатий	Шубина	Брониславович	+7 854 429 57 40	5996 270934	неоконченное высшее	8441
Регина	Селиверстова	\N	8 244 066 03 10	5222 570653	неоконченное высшее	8442
Парфен	Никонова	Владимировна	80915812118	3611 722142	среднее	8443
Амвросий	Вишнякова	Владиленович	+77120413194	6291 154120	\N	8444
Селиверст	Карпова	Евстигнеевич	+7 519 935 1413	1380 772617	высшее	8445
Никанор	Новиков	\N	87214955166	5456 597527	неоконченное высшее	8446
Феликс	Алексеева	\N	+7 590 570 19 91	2534 823772	среднее	8447
Людмила	Кудряшов	Игоревич	8 251 795 4106	9302 539084	среднее профессиональное	8448
Гремислав	Третьякова	Олеговна	8 (170) 088-80-80	3174 939603	высшее	8449
Зоя	Федосеев	\N	82987015181	8948 109882	неоконченное высшее	8450
Октябрина	Исаев	\N	87413083212	3429 250796	среднее	8451
Ефим	Никонов	Ильинична	+7 413 533 71 60	3451 276958	среднее	8452
Викентий	Сергеева	Харлампьевич	+7 328 295 23 59	5715 834575	среднее профессиональное	8453
Людмила	Иванова	\N	82899328169	1780 840759	высшее	8454
Ия	Самсонова	\N	8 747 120 4378	5457 202914	среднее профессиональное	8455
Творимир	Филиппова	\N	8 (038) 741-8624	5707 214830	среднее	8456
Варлаам	Лебедев	\N	8 719 997 8153	4149 669733	неоконченное высшее	8457
Якуб	Филатов	Филатович	+7 (071) 847-9780	7574 440221	неоконченное высшее	8458
Аникей	Попова	Гаврилович	+7 871 533 5121	8500 568422	среднее	8459
Тихон	Сазонов	\N	8 (968) 870-73-42	3954 532119	неоконченное высшее	8460
Данила	Денисова	\N	+7 (886) 331-52-58	4459 943057	среднее	8461
Евдокия	Рожкова	\N	82750658458	6797 351265	высшее	8462
Светозар	Быкова	Эдгарович	82447400325	6736 215482	среднее	8463
Евдокия	Тетерина	\N	+7 601 890 49 40	4324 754524	высшее	8464
Гурий	Пахомова	\N	8 (965) 974-2190	6585 151046	среднее профессиональное	8465
Мокей	Романова	\N	+7 435 910 4087	3597 675052	\N	8466
Агафон	Наумова	\N	8 (119) 574-47-71	3949 207835	среднее	8467
Никифор	Галкина	Харлампович	+7 105 127 9694	7040 267376	среднее	8468
Ананий	Громов	\N	+7 213 885 6410	9267 248271	среднее профессиональное	8469
Денис	Лукин	Терентьевич	+7 (164) 638-74-81	5687 594311	среднее	8470
Иннокентий	Пахомова	\N	8 (132) 727-65-40	8102 952270	неоконченное высшее	8471
Юлия	Маркова	Павловна	8 (771) 381-74-04	1265 897187	среднее	8472
Ия	Соболев	Григорьевна	+7 (828) 366-07-62	5199 834527	неоконченное высшее	8473
Аверкий	Лебедев	Степановна	8 (869) 808-85-36	5949 728872	высшее	8474
Евдоким	Белова	Григорьевна	+7 601 836 11 41	4285 821607	среднее	8475
Маргарита	Вишняков	\N	8 771 447 67 51	3451 925131	среднее	8476
Тихон	Гаврилова	\N	+7 469 635 7267	4475 860124	среднее	8477
Эммануил	Крылов	Харитоновна	+72823391864	8194 365657	\N	8478
Сократ	Юдин	Федосьевич	+7 798 215 1065	2776 528207	неоконченное высшее	8479
Архип	Филиппов	\N	86123389983	7093 864076	среднее профессиональное	8480
Гурий	Федотова	Евстигнеевич	8 (601) 868-5197	3929 408664	среднее	8481
Аникита	Баранова	Викторовна	+73191930338	3335 793279	неоконченное высшее	8482
Элеонора	Беляева	\N	8 758 153 7879	9803 106895	\N	8483
Глеб	Горшкова	Станиславовна	8 (805) 992-87-22	8085 165970	среднее	8484
Прокл	Пестов	Ефимович	+7 902 226 06 17	8440 131829	высшее	8485
Ким	Киселева	\N	8 (975) 471-52-10	1035 578524	\N	8486
Ростислав	Дроздов	\N	8 (213) 006-0932	3667 823641	высшее	8487
Леонтий	Герасимова	Ждановна	+7 332 294 18 63	8479 416874	среднее профессиональное	8488
Георгий	Воробьев	Глебович	8 838 185 69 41	9711 238216	высшее	8489
Сократ	Панов	\N	+7 (547) 722-6944	4535 641903	среднее профессиональное	8490
Аникита	Дьячков	Измаилович	84165645306	2552 422922	среднее	8491
Фирс	Антонова	Даниилович	82246596640	9184 469708	высшее	8492
Велимир	Богданов	Витальевич	8 844 109 39 07	5370 910679	среднее профессиональное	8493
Азарий	Прохорова	Кирилловна	8 733 764 99 64	6836 161953	\N	8494
Тихон	Лебедева	Марсович	+7 705 708 0527	1073 179695	среднее профессиональное	8495
Рюрик	Чернова	Тимурович	8 896 370 1771	8226 708876	высшее	8496
Парфен	Шилова	\N	8 (861) 575-9671	6465 545523	высшее	8497
Давыд	Петухов	Ефимьевич	+7 557 341 9132	4941 834703	\N	8498
Всеволод	Князев	Егоровна	+7 084 391 54 03	6663 829941	высшее	8499
Иван	Тихонова	Архипович	+7 (860) 395-69-77	3424 609355	среднее профессиональное	8500
Аскольд	Мухина	Оскаровна	8 115 016 3098	2699 687528	неоконченное высшее	8501
Ярополк	Беспалов	Ефимьевич	+7 959 288 83 45	1889 369784	неоконченное высшее	8502
Варвара	Петров	Устинович	+78718524690	3817 891685	среднее профессиональное	8503
Никодим	Осипова	Абрамович	8 794 638 4938	8239 683159	\N	8504
Селиван	Мишин	Трифонович	+7 (469) 872-8984	9586 707341	\N	8505
Леонид	Ковалева	\N	8 (025) 103-0916	2915 572923	высшее	8506
Борис	Кудрявцева	Фёдорович	+73721055353	8645 382520	неоконченное высшее	8507
Захар	Мельникова	Архиповна	+7 (777) 503-00-12	8836 289826	среднее профессиональное	8508
Мечислав	Суханова	Фокич	87837930913	1629 872127	высшее	8509
Пелагея	Калинин	Тимурович	8 (281) 711-1548	1384 970187	среднее профессиональное	8510
Софрон	Лапин	Романовна	8 (135) 718-22-64	3617 501907	среднее профессиональное	8511
Лаврентий	Мартынова	Ааронович	89944047465	9667 785576	неоконченное высшее	8512
Тит	Муравьева	\N	8 488 183 77 91	3564 476440	среднее	8513
Ксения	Крюкова	\N	8 818 491 35 29	4802 132207	\N	8514
Алексей	Савин	\N	+7 215 376 0993	9085 140412	среднее профессиональное	8515
Глеб	Беляков	Рудольфовна	88431983220	4759 256063	высшее	8516
Михаил	Лебедев	\N	+75233352436	7026 558100	высшее	8517
Ипатий	Копылов	\N	+7 937 151 1206	5662 990091	высшее	8518
Герман	Фомина	Аркадьевна	8 (829) 282-6302	2881 877881	среднее профессиональное	8519
Эммануил	Гусев	\N	+7 (739) 929-56-67	1968 106340	\N	8520
Валентина	Елисеев	Филатович	8 081 870 6490	7612 276955	среднее профессиональное	8521
Севастьян	Русакова	\N	+7 (585) 091-3967	8456 543242	неоконченное высшее	8522
Людмила	Носов	Валерианович	8 152 129 8051	3066 887588	\N	8523
Алевтина	Потапов	\N	86789930308	4845 288607	высшее	8524
Азарий	Бирюков	Борисовна	8 080 617 4242	5296 368282	высшее	8525
Анна	Савин	\N	8 (968) 079-37-99	7565 603024	\N	8526
Амос	Архипова	Филиппович	8 (886) 140-6964	5111 728123	неоконченное высшее	8527
Христофор	Дьячков	\N	+7 (267) 926-31-76	6584 191577	высшее	8528
Дарья	Брагин	Изотович	8 178 068 78 84	4808 491682	среднее	8529
Любомир	Никитина	\N	8 269 680 47 71	3435 652793	среднее профессиональное	8530
Афиноген	Белов	\N	+7 (259) 847-89-73	7973 275517	высшее	8531
Моисей	Орехова	\N	+7 196 904 03 98	5024 751382	неоконченное высшее	8532
Всеволод	Николаева	Викторовна	+7 (691) 512-1539	5562 371833	среднее профессиональное	8533
Амос	Константинов	\N	8 (434) 694-91-83	8108 604758	неоконченное высшее	8534
Феоктист	Комаров	Дмитриевна	8 150 646 8721	3384 254844	\N	8535
Синклитикия	Федоров	\N	8 277 537 5213	1373 102690	среднее	8536
Куприян	Харитонов	\N	8 826 786 4325	3192 526490	\N	8537
Парфен	Жданова	Вениаминовна	8 321 795 61 46	2368 981501	неоконченное высшее	8538
Ян	Шестаков	Матвеевич	8 (568) 812-89-94	7421 815361	неоконченное высшее	8539
Ефим	Ершова	Адамович	+7 (329) 384-60-98	8501 177829	\N	8540
Георгий	Цветкова	\N	8 636 454 13 96	3880 914287	среднее профессиональное	8541
Прасковья	Чернов	\N	8 579 611 4415	3335 992359	среднее профессиональное	8542
Венедикт	Брагин	\N	+7 (611) 800-47-19	2449 569895	высшее	8543
Аникита	Романов	Эдгарович	8 (006) 408-16-48	6369 164662	высшее	8544
Кондрат	Петухова	\N	8 (896) 218-3322	2478 321886	высшее	8545
Нина	Емельянова	\N	+7 667 211 9504	6602 240585	высшее	8546
Аникей	Афанасьев	\N	+70129457334	2746 379896	\N	8547
Раиса	Белякова	Вячеславовна	8 (141) 864-88-65	2334 607285	среднее профессиональное	8548
Гедеон	Брагин	\N	+7 (843) 661-21-51	8352 286811	\N	8549
Панкрат	Туров	\N	+7 (792) 962-90-35	7461 979053	высшее	8550
Севастьян	Ефимов	Сергеевна	8 (885) 041-47-74	3073 274716	высшее	8551
Велимир	Игнатова	Власович	8 288 250 77 99	8157 855745	неоконченное высшее	8552
Фаина	Павлов	\N	+7 (044) 402-3854	3995 703491	\N	8553
Орест	Вишнякова	\N	8 (508) 165-36-85	4071 148802	неоконченное высшее	8554
Лукия	Маслова	Герасимович	8 (953) 975-27-56	1307 180857	среднее профессиональное	8555
Герман	Мамонтова	\N	+7 139 267 53 63	7855 943707	высшее	8556
Сильвестр	Морозов	Фролович	83341212215	5141 824043	неоконченное высшее	8557
Наркис	Корнилова	\N	87193639544	2255 880081	среднее профессиональное	8558
Нифонт	Пономарев	\N	8 839 561 96 30	8619 971443	высшее	8559
Всеслав	Тарасова	\N	85136919122	9003 295215	\N	8560
Гедеон	Субботин	Львовна	+7 (799) 249-07-35	8611 696138	среднее	8561
Евгения	Горбунова	Власович	+7 (378) 151-21-99	8517 224722	\N	8562
Филарет	Козлова	\N	81191470236	1319 796955	неоконченное высшее	8563
Прасковья	Третьяков	\N	8 368 271 08 56	7430 452404	среднее профессиональное	8564
Эрнст	Кондратьев	\N	8 (873) 093-44-21	3098 748483	среднее профессиональное	8565
Пелагея	Мясникова	Адрианович	+73832855954	9033 181752	высшее	8566
Захар	Громова	\N	89507158119	5223 881240	\N	8567
Артем	Наумов	Даниловна	8 473 302 24 75	5168 465082	среднее	8568
Велимир	Комиссаров	Эдгарович	+7 (218) 073-9331	1788 199413	высшее	8569
Олимпий	Ситникова	\N	8 106 081 2433	7692 481173	неоконченное высшее	8570
Архип	Ершова	Богданович	+7 (862) 969-66-25	6643 928542	высшее	8571
Нина	Мясникова	\N	8 (866) 319-0154	4343 851662	высшее	8572
Болеслав	Исаев	Гертрудович	+7 (263) 996-4656	4685 680971	высшее	8573
Феофан	Смирнов	Ефимовна	8 229 567 58 58	3792 645777	среднее	8574
Агафья	Дорофеева	Наумовна	+7 826 844 75 87	8139 230924	\N	8575
Лазарь	Степанов	Харитонович	+7 (807) 984-77-09	7449 121400	неоконченное высшее	8576
Агафья	Чернова	\N	8 395 799 2976	4268 576373	неоконченное высшее	8577
Иларион	Гришин	\N	+7 (010) 027-83-85	1406 754386	\N	8578
Эдуард	Красильникова	Антоновна	87355741934	4220 256453	неоконченное высшее	8579
Панкратий	Мухин	\N	+7 (700) 690-4862	8020 280448	среднее	8580
Денис	Кириллов	Венедиктович	+7 575 426 25 62	7668 984395	высшее	8581
Аверьян	Кошелева	\N	8 (747) 793-00-04	8084 428872	\N	8582
Феофан	Миронова	\N	8 244 008 9925	1001 545521	высшее	8583
Мартьян	Жукова	Анатольевич	+73094755500	8183 966869	высшее	8584
Виктория	Воробьев	Феликсович	8 322 557 5851	3986 122149	среднее	8585
Моисей	Капустина	Сергеевна	8 (418) 859-62-31	1005 135968	среднее	8586
Изот	Антонова	Аксёнович	+7 (438) 897-31-27	8088 363426	среднее профессиональное	8587
Фёкла	Борисов	\N	+7 211 960 9104	2613 754973	высшее	8588
Амвросий	Федотов	\N	+77062516946	6105 985088	среднее профессиональное	8589
Гостомысл	Субботин	Васильевна	+72854091192	1287 873870	высшее	8590
Стоян	Соколов	\N	8 076 930 9535	8193 985305	среднее	8591
Наталья	Бобылев	\N	+7 (042) 555-8013	7085 724485	высшее	8592
Любосмысл	Сорокина	\N	+70450423910	9780 133868	среднее	8593
Феоктист	Мартынов	Никифоровна	+73689675432	1536 377111	высшее	8594
Максим	Горбачева	\N	+7 391 550 50 13	4814 953030	среднее	8595
Игорь	Котов	\N	85584494088	6426 827748	неоконченное высшее	8596
Герман	Бобылева	Иларионович	+7 383 799 96 39	2125 994234	высшее	8597
Трифон	Лебедев	\N	+7 597 836 90 88	7620 885806	\N	8598
Кирилл	Бирюков	\N	8 (783) 399-4898	9765 926776	высшее	8599
Станимир	Елисеева	Вячеславовна	+7 308 078 9981	7185 308919	среднее профессиональное	8600
Серафим	Крюков	\N	+7 056 850 11 94	6530 225706	среднее профессиональное	8601
Мстислав	Воронов	\N	+7 145 872 9521	1771 849435	среднее	8602
Гаврила	Бирюкова	\N	+71963877059	7559 567264	среднее	8603
Архип	Панов	\N	+7 (715) 052-11-79	4272 934648	среднее	8604
Ратибор	Рожков	Даниловна	8 482 957 9786	2780 361716	среднее профессиональное	8605
Андрон	Семенова	Тихонович	+74108004499	7391 569848	неоконченное высшее	8606
Будимир	Пономарева	\N	+7 683 004 2808	3298 139404	среднее	8607
Потап	Маслов	Владиленович	+7 695 054 8697	5469 297675	среднее профессиональное	8608
Макар	Осипова	Димитриевич	8 704 973 71 52	7888 218288	среднее	8609
Олег	Федотов	Фадеевич	+7 (331) 649-3142	4121 794856	среднее	8610
Олимпиада	Лобанова	Борисович	+7 (887) 464-2998	6406 843116	\N	8611
Андроник	Кудрявцева	\N	+7 (470) 126-8669	3507 704738	среднее	8612
Исай	Куликова	Харламович	+7 (078) 375-01-79	7849 886437	среднее	8613
Остромир	Носкова	\N	8 (793) 671-87-58	5405 558299	среднее профессиональное	8614
Раиса	Зыков	Владиленович	8 836 538 57 33	5115 292755	среднее	8615
Моисей	Сергеев	Елисеевич	8 (958) 188-1033	4319 387827	высшее	8616
Селиверст	Гуляева	Даниилович	8 442 589 4017	6345 386603	неоконченное высшее	8617
Аникей	Крюкова	Георгиевич	8 375 817 77 78	7673 247819	высшее	8618
Зосима	Куликова	Харлампович	8 899 337 1419	2764 520908	среднее	8619
Федор	Туров	Иосипович	+7 (406) 176-1865	2237 397247	среднее профессиональное	8620
Парфен	Макаров	\N	+73396548990	6550 183866	среднее	8621
Всеволод	Блинов	Аскольдовна	+78594450180	3519 947106	среднее	8622
Панфил	Некрасов	\N	+75326317848	6252 514021	\N	8623
Ипполит	Лаврентьев	\N	+7 774 500 02 90	7156 291072	среднее профессиональное	8624
Надежда	Агафонова	\N	+7 999 089 22 94	7116 279863	высшее	8625
Андроник	Кудрявцев	\N	+72344934654	9936 841036	неоконченное высшее	8626
Вера	Уваров	\N	8 335 037 6756	8740 822334	\N	8627
Конон	Полякова	Леоновна	+7 899 664 6282	8677 374562	среднее профессиональное	8628
Автоном	Морозов	Станиславовна	8 (695) 888-66-62	3867 239476	среднее профессиональное	8629
Марина	Галкина	\N	8 864 442 0450	5856 857371	неоконченное высшее	8630
Конон	Никифорова	Фролович	83220736907	1197 101778	\N	8631
Леон	Лукин	Августович	8 (950) 403-23-62	9873 912409	неоконченное высшее	8632
Автоном	Дементьева	Фокич	8 854 923 38 50	5633 342414	среднее	8633
Антонина	Яковлев	\N	+7 (379) 127-91-06	6995 642043	среднее	8634
Кузьма	Бобылев	Авдеевич	8 247 586 33 86	8933 350400	среднее	8635
Никита	Захаров	Феликсович	8 756 110 9063	4589 641779	неоконченное высшее	8636
Велимир	Смирнов	\N	8 (867) 247-8263	8114 825880	среднее	8637
Святослав	Галкина	\N	8 (034) 062-3938	5292 866089	среднее профессиональное	8638
Ирина	Селезнева	Ефимьевич	+7 (418) 159-8207	9211 746104	среднее профессиональное	8639
Карп	Боброва	Вячеславович	83500352443	2369 140062	\N	8640
Сократ	Козлов	\N	8 689 211 11 51	5397 657288	среднее	8641
Давыд	Маркова	Зиновьевич	+7 603 169 85 78	3202 793753	неоконченное высшее	8642
Мартьян	Турова	Филиппович	+7 908 990 2551	3446 373307	высшее	8643
Лукия	Фадеев	\N	89975824785	1829 602404	среднее профессиональное	8644
Иларион	Гаврилов	Елисеевич	+72605479511	1036 356484	среднее	8645
Фома	Гаврилова	Вячеславовна	85277791246	2261 263527	\N	8646
Пимен	Тимофеева	\N	+74105838351	3965 787371	среднее профессиональное	8647
Антонина	Кузьмина	\N	8 658 019 86 02	3346 725879	\N	8648
Давыд	Котова	\N	8 (171) 674-9162	9911 451459	\N	8649
Август	Максимова	Владиславовна	8 (706) 640-9487	9427 418714	неоконченное высшее	8650
Ладимир	Федорова	Артемьевич	+7 (576) 100-97-72	4016 701425	высшее	8651
Аникей	Моисеева	\N	+7 960 609 84 86	5544 548649	неоконченное высшее	8652
Аполлинарий	Дьячкова	\N	8 531 918 9720	6899 917523	неоконченное высшее	8653
Прохор	Суворов	\N	8 (664) 910-3205	5390 382526	среднее	8654
Боян	Доронина	Юрьевна	86172828422	2663 625640	среднее профессиональное	8655
Филипп	Евдокимов	\N	8 126 699 17 33	7119 260590	среднее профессиональное	8656
Клавдия	Никонов	Петровна	+7 140 217 9886	2395 781940	среднее	8657
Авксентий	Волков	Михайловна	+7 270 397 4937	5644 121713	среднее профессиональное	8658
Ладимир	Шестаков	Бенедиктович	+7 211 513 73 47	1105 886954	среднее	8659
Симон	Тихонова	Архиповна	+75213474942	1173 854629	высшее	8660
Януарий	Ефимов	Валериевна	+7 505 510 5790	9608 949008	среднее	8661
Эммануил	Фадеев	Елизарович	+7 159 548 6615	6096 174499	среднее профессиональное	8662
Автоном	Шилов	\N	8 (951) 492-52-09	6443 584753	высшее	8663
Александр	Комаров	Феликсовна	+7 945 119 21 68	6037 196365	неоконченное высшее	8664
Олег	Никонов	Елизарович	8 (733) 619-49-94	2113 822266	неоконченное высшее	8665
Стоян	Александрова	Владленович	+7 831 932 06 23	2648 114980	среднее	8666
Юлий	Жданов	Руслановна	84509317234	6369 248707	\N	8667
Алексей	Пономарев	\N	+7 (647) 024-9336	5152 652902	среднее профессиональное	8668
Федот	Панфилов	\N	+7 (923) 304-9858	7393 622146	среднее	8669
Терентий	Ларионова	Аксёнович	+7 (009) 753-8435	2519 153109	неоконченное высшее	8670
Поликарп	Сергеев	\N	+7 731 445 57 88	8845 896524	среднее	8671
Селиверст	Силина	\N	+7 892 447 83 58	8645 785496	неоконченное высшее	8672
Арефий	Павлов	\N	+7 394 399 8878	1505 656877	высшее	8673
Алла	Тихонов	Ильясович	89544360905	5792 714926	высшее	8674
Вениамин	Анисимов	\N	83216733082	1159 366694	\N	8675
Будимир	Наумов	\N	8 339 443 0970	8357 735947	среднее профессиональное	8676
Степан	Григорьев	Венедиктович	+7 919 743 83 47	8360 622237	среднее	8677
Варфоломей	Никифоров	Алексеевич	+7 726 665 31 51	8842 802936	среднее	8678
Илья	Евдокимова	Адамович	8 718 012 4229	4249 385252	неоконченное высшее	8679
Поликарп	Макаров	\N	+7 (093) 403-9126	1138 340553	неоконченное высшее	8680
Лазарь	Лаврентьева	Романовна	+7 (004) 213-1252	2679 388632	неоконченное высшее	8681
Трифон	Юдина	\N	89771813250	8160 274421	\N	8682
Милан	Марков	Святославовна	8 244 425 51 74	5310 529610	неоконченное высшее	8683
Станислав	Назаров	Трифонович	+7 (451) 226-15-60	2294 690988	высшее	8684
Кирилл	Фомин	\N	8 (141) 035-40-39	7136 286452	среднее	8685
Галина	Кошелев	Августович	8 (345) 685-2440	2548 562907	среднее	8686
Добромысл	Зуева	Егоровна	8 693 645 02 16	4289 432146	среднее профессиональное	8687
Владислав	Пономарева	Григорьевна	8 (056) 489-04-65	7872 195268	среднее	8688
Потап	Одинцова	Сергеевна	8 (603) 465-62-50	5779 345285	среднее профессиональное	8689
Федосий	Ильин	Зиновьевич	8 (189) 248-6807	6132 833492	неоконченное высшее	8690
Трофим	Ситникова	\N	88306021847	1030 412397	среднее	8691
Аполлон	Галкин	\N	89366335883	6113 687017	среднее профессиональное	8692
Харлампий	Никонова	Давыдович	+7 (296) 582-1357	5389 608780	среднее	8693
Лариса	Афанасьев	\N	+7 749 801 12 56	8152 664496	среднее профессиональное	8694
Клавдий	Мамонтова	\N	+72943979369	7246 346252	\N	8695
Раиса	Цветкова	\N	8 228 450 95 79	6741 302353	неоконченное высшее	8696
Эмилия	Фадеев	\N	8 938 725 2869	5299 265578	среднее профессиональное	8697
Кузьма	Вишняков	Артемьевич	+7 (858) 213-6953	4813 260249	\N	8698
Осип	Князев	Юльевич	8 (776) 058-7891	5230 642368	неоконченное высшее	8699
Панфил	Куликова	\N	+76652573587	1802 110086	неоконченное высшее	8700
Владислав	Беспалова	Евгеньевна	+78140803709	1771 869826	среднее	8701
Лаврентий	Иванова	Робертовна	+7 481 784 2621	3520 223339	среднее	8702
Ладислав	Суворова	\N	8 459 938 3823	5337 214067	неоконченное высшее	8703
Евсей	Ситникова	Изотович	8 (192) 350-7976	8080 213320	среднее	8704
Евстафий	Беспалова	Чеславович	+7 993 345 76 79	2936 381502	высшее	8705
Гремислав	Поляков	Леонидовна	8 (095) 284-6927	2588 641412	среднее профессиональное	8706
Элеонора	Денисова	Ефимовна	+7 407 732 7782	7695 486126	\N	8707
Екатерина	Селиверстова	\N	8 617 558 31 22	9381 796344	среднее профессиональное	8708
Нонна	Лаврентьев	Юльевна	+72496366443	7888 930388	высшее	8709
Андрон	Гуляева	Львовна	8 (248) 915-99-61	9851 715309	среднее профессиональное	8710
Лавр	Мартынов	Тарасович	+79590367782	6377 251690	высшее	8711
Никон	Красильников	\N	82586498922	7314 422465	\N	8712
Ипат	Фомичев	Чеславович	84877407864	7834 642577	среднее профессиональное	8713
Антип	Романова	\N	+7 (047) 123-4770	2767 904733	неоконченное высшее	8714
Мартьян	Тетерин	Эдгардович	8 (970) 999-48-38	3541 563821	среднее профессиональное	8715
Гремислав	Боброва	Фомич	8 (746) 479-89-71	7525 345993	среднее	8716
Венедикт	Хохлов	Валерианович	87858957390	7126 495977	среднее профессиональное	8717
Иван	Кабанов	\N	+7 765 703 13 75	7023 436635	\N	8718
Еремей	Горбунов	Григорьевич	+7 (669) 350-6345	5358 996666	неоконченное высшее	8719
Лев	Гордеева	Даниилович	84904568622	1599 323779	\N	8720
Дорофей	Федотова	Викторовна	8 (728) 828-29-94	2824 248468	среднее профессиональное	8721
Гостомысл	Ефремова	Феликсович	+79700095977	5971 884584	среднее	8722
Фадей	Наумов	Николаевна	+7 (295) 950-5258	4202 596535	среднее профессиональное	8723
Мстислав	Рогова	Ефремович	8 034 237 5845	9532 862957	\N	8724
Селиверст	Богданов	Елисеевич	+77813216565	2429 323944	высшее	8725
Модест	Сорокина	Артёмович	+7 (556) 437-6547	3994 955191	высшее	8726
Мстислав	Лаврентьева	\N	8 917 788 6857	7038 322152	неоконченное высшее	8727
Яков	Мухина	\N	+79108741568	4717 733614	высшее	8728
Варфоломей	Беляева	Ильич	+72585154092	9485 544230	\N	8729
Викторин	Королев	\N	8 268 597 7574	7891 261975	высшее	8730
Мартьян	Маслова	\N	+7 (397) 531-6961	9659 124482	высшее	8731
Андроник	Белякова	\N	+7 (812) 076-52-14	1112 103295	среднее	8732
Ефрем	Архипова	\N	+7 195 319 0768	7844 808487	высшее	8733
Касьян	Борисов	Андреевич	8 (641) 156-84-56	4770 791501	\N	8734
Агата	Сидоров	Феоктистович	8 963 882 8634	7020 214843	среднее	8735
Любовь	Соболев	\N	+7 562 225 3687	7533 807590	высшее	8736
Велимир	Аксенов	Эдгардович	8 416 254 5445	3264 541246	неоконченное высшее	8737
Феврония	Зимина	\N	+7 021 752 2908	8086 904032	среднее	8738
Ия	Архипова	Андреевна	8 (632) 878-51-08	3701 942454	среднее	8739
Глафира	Лапин	\N	+7 (330) 918-5111	3998 572256	неоконченное высшее	8740
Осип	Максимова	Евстигнеевич	+7 (654) 123-6553	3241 642857	\N	8741
Венедикт	Костин	Ерофеевич	+7 (881) 025-29-85	4638 655804	среднее	8742
Павел	Елисеев	Максимовна	+7 (381) 178-04-99	5315 565671	неоконченное высшее	8743
Владлен	Агафонов	Богдановна	+7 801 098 7264	7819 564708	среднее	8744
Ратмир	Селезнев	\N	+7 (532) 182-3846	4863 539935	\N	8745
Гордей	Фокина	Егорович	8 (838) 350-0441	1033 799967	среднее профессиональное	8746
Филимон	Владимиров	\N	+73015624174	3278 552145	неоконченное высшее	8747
Родион	Васильев	Михайловна	+7 (483) 313-8837	7359 585352	неоконченное высшее	8748
Евстигней	Лукин	Геннадиевна	81448702818	6751 388198	среднее профессиональное	8749
Валерий	Горшкова	\N	+7 (570) 297-0717	5888 846686	среднее	8750
Добромысл	Агафонова	Наумовна	8 101 842 1884	6918 212318	высшее	8751
Максим	Кулагина	Артемовна	+7 (350) 534-03-89	1245 274867	неоконченное высшее	8752
Бронислав	Буров	Аксёнович	+7 (942) 610-9679	9434 337795	высшее	8753
Геннадий	Веселов	\N	+72036563820	6293 115926	высшее	8754
Майя	Федотов	\N	+7 (942) 524-5864	5696 966144	\N	8755
Конон	Ефимов	\N	8 (944) 843-64-99	8755 281433	среднее профессиональное	8756
Святослав	Копылов	\N	+7 692 068 98 39	3308 996430	среднее профессиональное	8757
Евфросиния	Колобова	Гордеевич	+7 (402) 297-46-56	3571 641595	среднее профессиональное	8758
Иван	Воронцова	\N	8 (402) 979-7060	3432 940864	\N	8759
Ладимир	Селиверстов	\N	8 (809) 303-9912	7896 833855	среднее	8760
Прокл	Коновалова	\N	+7 (381) 411-47-45	9053 816460	среднее	8761
Серафим	Копылова	Вилорович	+7 691 400 9579	5722 550957	высшее	8762
Онуфрий	Степанова	Ерофеевич	88775550585	6170 957440	неоконченное высшее	8763
Емельян	Панова	\N	8 694 342 4134	8616 337120	среднее профессиональное	8764
Варвара	Кошелева	\N	84253589281	4444 182347	высшее	8765
Адриан	Никифорова	Вячеславович	87094890145	4086 321490	среднее	8766
Елизар	Сазонов	\N	8 (942) 193-79-06	7540 579926	среднее	8767
Болеслав	Семенов	Ефремович	8 448 325 6783	6286 633203	среднее	8768
Федот	Журавлева	\N	+7 488 227 1430	4708 963435	высшее	8769
Мирон	Якушева	\N	8 933 532 85 99	3839 210774	высшее	8770
Филипп	Логинова	\N	+7 (591) 982-18-28	1126 586960	среднее	8771
Евдоким	Шубин	Васильевич	+7 (560) 934-6307	7109 585621	среднее профессиональное	8772
Корнил	Терентьев	Наумовна	8 (908) 912-0234	4086 339312	\N	8773
Варвара	Зимина	\N	+7 (096) 049-62-68	2746 432741	среднее профессиональное	8774
Онуфрий	Терентьев	Рубеновна	+7 281 572 3553	9242 441103	неоконченное высшее	8775
Аникита	Лихачев	Оскаровна	8 (512) 268-6062	1883 315773	неоконченное высшее	8776
Эрнст	Горшкова	Альбертовна	+7 (395) 569-3432	4169 481055	среднее профессиональное	8777
Любим	Боброва	\N	8 (622) 771-6658	4824 920564	неоконченное высшее	8778
Елисей	Никонова	\N	+7 587 350 4815	8963 549647	высшее	8779
Ольга	Иванов	Георгиевич	8 (630) 939-02-97	5209 564353	среднее	8780
Валерьян	Горшкова	Евгеньевна	+71412954378	2031 269399	среднее профессиональное	8781
Евгений	Никитин	\N	8 (005) 593-07-08	1596 108845	неоконченное высшее	8782
Соломон	Зиновьев	\N	87580876063	6748 253591	среднее профессиональное	8783
Святослав	Копылова	\N	+78705768587	9803 767505	неоконченное высшее	8784
Ольга	Филатов	Германович	+79088271552	7367 391791	неоконченное высшее	8785
Ладимир	Филатов	Измаилович	8 382 966 5182	1500 379567	среднее	8786
Галактион	Архипов	\N	8 333 766 02 82	7663 717973	среднее профессиональное	8787
Софрон	Мишин	\N	+7 002 556 7664	3565 896756	среднее	8788
Конон	Крюков	\N	8 169 334 40 92	3193 905718	среднее профессиональное	8789
Валентин	Игнатова	Демьянович	8 (324) 805-3595	7199 282895	среднее профессиональное	8790
Сильвестр	Никифорова	Феликсовна	8 606 623 3707	7906 642537	неоконченное высшее	8791
Иванна	Зимина	\N	8 (150) 120-5123	8016 916603	неоконченное высшее	8792
Юрий	Воронцова	\N	+7 973 761 5283	2829 872371	\N	8793
Вышеслав	Пономарева	\N	8 (206) 996-79-83	9447 412470	\N	8794
Герман	Большакова	\N	84571216249	3821 577167	среднее	8795
Аскольд	Жданова	\N	8 557 361 94 26	3383 221729	\N	8796
Октябрина	Большакова	\N	+72484573250	6827 819179	\N	8797
Анисим	Антонова	Евгеньевна	84491729477	7040 556639	среднее	8798
Фаина	Хохлов	\N	+78214602304	6811 374857	высшее	8799
Святослав	Мартынов	\N	8 714 049 20 38	2674 564571	среднее	8800
Ким	Яковлева	Владиславович	8 617 234 3183	3424 790595	высшее	8801
Клавдий	Медведева	\N	8 684 069 23 40	4319 405701	неоконченное высшее	8802
Осип	Борисова	\N	+73292886213	5943 656256	среднее	8803
Доброслав	Горбачев	Ефимовна	+70387440651	5924 624701	среднее	8804
Валентин	Кузнецова	\N	+7 (845) 942-01-80	4386 478588	неоконченное высшее	8805
Лазарь	Савин	Матвеевич	+72088448177	7430 262229	среднее профессиональное	8806
Клавдия	Кириллова	Ефимьевич	+72540186502	2277 945467	неоконченное высшее	8807
Афиноген	Рыбакова	\N	8 (200) 122-9521	6121 540022	неоконченное высшее	8808
Ярополк	Жукова	Алексеевич	+7 (639) 187-1481	9474 857879	высшее	8809
Сигизмунд	Шаров	\N	8 127 113 74 40	2519 438979	\N	8810
Любим	Егорова	\N	8 787 084 7196	8010 927802	неоконченное высшее	8811
Артем	Брагин	\N	8 (710) 881-09-05	7005 451474	\N	8812
Ерофей	Лыткин	\N	8 (759) 097-7002	1605 115624	неоконченное высшее	8813
Федор	Полякова	Бенедиктович	+7 304 730 2216	5533 279248	неоконченное высшее	8814
Лука	Казаков	\N	+7 408 084 3282	5865 579738	неоконченное высшее	8815
Софрон	Артемьева	\N	+7 (779) 672-7511	3223 765810	среднее профессиональное	8816
Корнил	Лапина	\N	+71274399429	4605 694141	среднее профессиональное	8817
Сигизмунд	Шестакова	Афанасьевич	+7 (452) 245-47-62	1023 496131	неоконченное высшее	8818
Никандр	Юдина	Феоктистович	+7 (492) 216-19-73	1688 267525	неоконченное высшее	8819
Евфросиния	Котов	Фокич	+7 (154) 027-6332	9963 515051	неоконченное высшее	8820
Агата	Селиверстова	\N	8 (541) 655-0267	9673 435930	среднее	8821
Савелий	Горшков	\N	8 (215) 312-0425	3718 578018	высшее	8822
Ульяна	Бурова	\N	86188129542	9614 270978	среднее	8823
Милен	Баранова	Васильевич	8 767 497 0888	4264 169669	\N	8824
Варлаам	Селезнев	Максимовна	8 (756) 102-10-69	5623 390402	неоконченное высшее	8825
Архип	Трофимова	\N	+7 (129) 128-77-55	2610 502716	среднее	8826
Владлен	Вишнякова	Феликсовна	8 (462) 463-44-34	6321 775538	высшее	8827
Ермил	Кудрявцева	\N	8 (190) 796-18-20	7918 359845	среднее	8828
Надежда	Архипова	Макаровна	8 983 157 69 29	2544 894190	высшее	8829
Всемил	Титов	Тимурович	+70811236889	4821 999224	высшее	8830
Аким	Сазонова	Дорофеевич	8 022 899 4431	8172 730017	среднее профессиональное	8831
Нифонт	Пахомова	\N	8 (730) 378-20-65	9689 259791	среднее профессиональное	8832
Демьян	Копылова	Григорьевич	+7 (390) 939-61-59	3075 292551	высшее	8833
Ефим	Молчанов	\N	+7 (058) 478-72-80	7594 644237	среднее	8834
Антонин	Симонов	Владиславович	+7 (868) 431-7347	6157 233564	среднее	8835
Майя	Гущин	Аверьянович	+72565451815	9714 433273	\N	8836
Октябрина	Рыбакова	\N	+7 339 320 5421	5503 685918	среднее профессиональное	8837
Ангелина	Осипова	\N	+7 (116) 893-17-12	5806 396009	неоконченное высшее	8838
Игорь	Наумова	Демьянович	8 (828) 490-2635	2963 427997	\N	8839
Нестор	Сорокин	Давыдович	+7 648 212 0420	2985 473265	среднее профессиональное	8840
Лаврентий	Третьяков	Исидорович	+7 (998) 509-3579	4082 544723	среднее	8841
Ефим	Мамонтов	\N	+7 690 596 93 22	3702 147359	среднее профессиональное	8842
Климент	Кабанов	Афанасьевич	8 191 218 4837	4788 136717	среднее	8843
Фома	Беляева	\N	8 (132) 712-4248	4877 914083	\N	8844
Акулина	Лапина	Олеговна	+7 089 241 5464	4630 469229	\N	8845
Маргарита	Васильева	\N	8 462 155 44 67	5471 178010	среднее	8846
Руслан	Морозова	\N	8 (949) 130-72-31	4884 369406	среднее	8847
Ратмир	Гришин	Измаилович	8 471 745 5003	8096 276535	среднее	8848
Фотий	Степанов	\N	8 (114) 197-20-22	4470 251957	среднее	8849
Ратибор	Крюков	Михайловна	8 930 627 5307	6662 101868	высшее	8850
Алексей	Ильина	\N	+78951077433	2548 706101	высшее	8851
Никодим	Савина	\N	+77440626930	2308 416513	высшее	8852
Алексей	Комаров	\N	+7 (216) 194-52-03	8462 881488	среднее профессиональное	8853
Мирон	Фокина	\N	8 (043) 216-56-08	7941 362951	высшее	8854
Серафим	Герасимов	Федотович	86115631542	9492 570892	высшее	8855
Пимен	Архипова	Евгеньевна	+7 297 312 5566	2700 575032	неоконченное высшее	8856
Авдей	Сазонов	\N	85761141854	2647 126833	среднее профессиональное	8857
Ипат	Трофимова	Игоревна	8 398 439 74 60	5412 301855	среднее профессиональное	8858
Боян	Баранов	\N	+7 608 289 43 67	8466 830594	среднее профессиональное	8859
Федосий	Щукин	Геннадиевич	89924784826	3654 338784	среднее профессиональное	8860
Арсений	Дроздов	\N	8 (540) 392-5588	6836 574260	\N	8861
Будимир	Маслов	Юрьевна	+7 532 370 1323	4231 602724	\N	8862
Агата	Горшков	\N	+7 765 138 9160	2162 773487	среднее профессиональное	8863
Константин	Жданова	Игоревич	8 (840) 693-1537	5605 126654	среднее	8864
Екатерина	Горбунов	\N	8 403 380 7457	7299 896666	неоконченное высшее	8865
Добромысл	Казакова	\N	+7 (461) 813-4267	7179 857673	неоконченное высшее	8866
Осип	Калашникова	\N	8 (863) 869-38-26	3313 872956	\N	8867
Захар	Орехов	Валентиновна	8 (660) 391-7595	2837 804972	среднее профессиональное	8868
Серафим	Большакова	\N	8 544 244 4676	5267 762113	неоконченное высшее	8869
Дмитрий	Зуев	Александровна	+7 (126) 808-48-11	9420 359491	неоконченное высшее	8870
Влас	Сергеева	Харламович	8 (279) 955-71-03	4115 966047	среднее	8871
Остромир	Савельев	Федоровна	+7 921 662 91 56	7727 534893	среднее профессиональное	8872
Игнатий	Сидорова	\N	8 (705) 932-9318	5497 539701	среднее профессиональное	8873
Ярослав	Михайлова	\N	8 (124) 335-33-71	6995 130078	среднее профессиональное	8874
Трифон	Баранов	\N	8 045 067 50 70	1443 894894	среднее	8875
Акулина	Мамонтов	\N	8 835 342 0341	2673 433307	\N	8876
Майя	Фомичева	\N	+7 903 854 7456	4086 840799	среднее профессиональное	8877
Евгения	Горбунов	Болеславовна	+7 (879) 895-80-25	8520 337997	среднее профессиональное	8878
Зиновий	Макаров	\N	+7 (538) 610-19-14	1772 954097	среднее	8879
Ефрем	Князева	Григорьевич	+7 (726) 927-35-98	4233 159649	\N	8880
Кир	Лобанов	\N	+74685309810	1549 112451	\N	8881
Ипатий	Васильева	Аверьянович	8 228 436 99 96	4745 199188	неоконченное высшее	8882
Сократ	Белозеров	Эльдаровна	+7 166 364 5306	3897 265259	среднее	8883
Нонна	Хохлова	Гавриилович	+7 451 445 02 75	8060 536386	среднее профессиональное	8884
Ермолай	Уваров	Александровна	8 (131) 844-92-94	4098 301941	неоконченное высшее	8885
Аверкий	Пестов	Викторовна	+7 838 797 1675	1799 132895	неоконченное высшее	8886
Никодим	Котова	\N	+7 983 776 6483	6253 181947	среднее профессиональное	8887
Лукьян	Егоров	Егорович	+7 (813) 452-78-82	5201 503001	среднее	8888
Милан	Галкин	\N	+72175046345	8944 702114	неоконченное высшее	8889
Аркадий	Николаева	Авдеевич	+7 074 587 75 69	2443 934150	высшее	8890
Всеслав	Прохоров	\N	8 873 198 7278	1930 798677	среднее профессиональное	8891
Селиван	Кудрявцев	Иосипович	8 (214) 943-15-77	7765 956296	неоконченное высшее	8892
Валерьян	Пономарева	\N	8 614 476 14 51	1224 818418	среднее	8893
Остромир	Егоров	\N	+77821720589	9950 865269	\N	8894
Данила	Шарапов	\N	+7 874 930 92 57	1541 268578	среднее профессиональное	8895
Аггей	Фомина	\N	8 (919) 337-7944	7781 104781	высшее	8896
Василиса	Щербакова	Брониславович	+7 026 409 0626	7473 921076	высшее	8897
Валерьян	Крюков	\N	8 (055) 977-6798	6218 392864	среднее	8898
Милован	Фомичева	\N	+70088327750	3333 874349	высшее	8899
Иван	Королева	Викентьевич	+7 163 060 06 20	4784 632522	\N	8900
Всеслав	Белоусов	Харлампьевич	+7 (268) 997-0328	6168 233634	среднее	8901
Лев	Ершова	Жанович	8 786 901 23 34	9635 623520	среднее	8902
Силантий	Терентьев	Борисович	8 (741) 708-1340	6711 112237	неоконченное высшее	8903
Агата	Сазонов	Рубеновна	+73218910031	2994 787570	среднее	8904
Элеонора	Веселов	\N	+7 (991) 629-85-21	9927 857627	среднее профессиональное	8905
Мариан	Ермаков	\N	+7 (239) 370-48-77	5827 160133	\N	8906
Анастасия	Борисов	\N	8 (252) 266-6102	1300 423352	среднее	8907
Полина	Константинов	\N	+7 000 145 01 39	8199 166333	\N	8908
Якуб	Блинова	\N	8 (554) 935-50-44	2452 241567	среднее	8909
Гремислав	Третьякова	Елисеевич	8 253 126 49 23	3122 956332	среднее	8910
Творимир	Ситникова	Наумовна	8 (732) 332-72-68	9032 350891	среднее профессиональное	8911
Изяслав	Лобанов	Димитриевич	+7 (608) 515-5305	8325 539464	высшее	8912
Синклитикия	Кошелев	\N	+76867864857	3683 382783	среднее профессиональное	8913
Любомир	Кулаков	\N	+7 035 594 0031	2066 683894	неоконченное высшее	8914
Всеслав	Игнатьева	Денисович	8 078 984 6219	5287 634315	среднее профессиональное	8915
Павел	Родионов	\N	8 (465) 881-6849	8008 555225	высшее	8916
Ладислав	Беспалов	Давыдович	8 655 705 19 64	6718 195303	высшее	8917
Евдоким	Петухова	Михайловна	8 (315) 909-1423	5946 507370	\N	8918
Измаил	Зайцева	Алексеевич	8 (021) 909-9831	3605 189073	неоконченное высшее	8919
Ольга	Евсеева	Аверьянович	8 (577) 432-0271	8405 807002	высшее	8920
Осип	Абрамов	\N	8 733 990 12 02	3901 663738	неоконченное высшее	8921
Мартьян	Кондратьева	Аксёнович	8 (429) 558-7793	6768 614765	\N	8922
Ирина	Крюков	Феоктистович	+7 988 062 83 85	9887 468563	среднее профессиональное	8923
Вячеслав	Ситников	Тимофеевна	8 844 976 9101	6946 800853	среднее	8924
Фирс	Овчинников	\N	+7 (931) 519-7428	5769 991788	среднее профессиональное	8925
Аггей	Бобров	\N	+7 299 131 47 08	3950 220147	среднее	8926
Сократ	Осипов	\N	+7 (006) 653-17-63	2852 698046	среднее	8927
Поликарп	Лихачева	\N	8 (588) 186-8386	4375 943141	среднее	8928
Захар	Комаров	\N	+7 715 618 2831	9086 755031	среднее	8929
Измаил	Беляев	\N	8 (972) 999-44-28	2349 780727	среднее	8930
Людмила	Кудрявцев	\N	8 578 155 7793	7383 986159	неоконченное высшее	8931
Нина	Абрамов	Васильевна	8 418 946 2843	3503 119425	среднее профессиональное	8932
Ярослав	Белозеров	\N	8 (556) 569-9176	2578 253676	среднее	8933
Радим	Корнилов	Евстигнеевич	81175099586	3158 792662	\N	8934
Ефрем	Селиверстова	\N	+7 (210) 470-95-62	9914 726051	среднее профессиональное	8935
Никон	Буров	Даниловна	+7 950 780 8564	9080 540877	среднее	8936
Олег	Беляева	Филатович	+7 (587) 356-85-38	4480 811021	высшее	8937
Сигизмунд	Гаврилова	Зиновьевич	+7 785 741 3247	2814 341754	среднее	8938
Пелагея	Баранова	Анисимович	8 (934) 374-53-39	9773 356824	среднее профессиональное	8939
Фока	Кулаков	\N	+7 (753) 190-26-53	1263 365662	неоконченное высшее	8940
Спиридон	Киселева	\N	8 698 964 2815	4532 958031	\N	8941
Орест	Суханова	Владимировна	+7 504 761 8776	4365 860831	высшее	8942
Аким	Кудрявцева	\N	+7 811 025 6075	2697 815020	среднее профессиональное	8943
Лукия	Князева	Никифоровна	+7 (310) 165-9531	9429 894256	\N	8944
Ангелина	Кудряшов	Александрович	8 (718) 656-4714	7260 910218	высшее	8945
Вацлав	Воронцова	Яковлевич	8 (054) 054-87-69	2549 638256	среднее профессиональное	8946
Олег	Федорова	Гордеевич	80417529622	1877 603403	высшее	8947
Христофор	Чернова	Леонидовна	8 (471) 063-5140	1202 450556	неоконченное высшее	8948
Николай	Красильникова	Брониславович	+7 (421) 788-4686	2396 877716	неоконченное высшее	8949
Ерофей	Воробьева	Юльевна	+78139942317	1141 444107	высшее	8950
Феоктист	Лазарев	\N	+7 174 787 82 30	5331 126734	среднее	8951
Владилен	Гордеев	\N	8 296 009 5673	9310 927383	неоконченное высшее	8952
Данила	Голубева	\N	8 (936) 527-2702	3613 492374	неоконченное высшее	8953
Боян	Шубин	\N	8 070 921 5846	1243 635706	среднее профессиональное	8954
Людмила	Киселева	\N	+7 (721) 656-08-54	4920 638073	среднее профессиональное	8955
Юлиан	Гурьева	\N	8 (315) 645-66-83	9407 365713	высшее	8956
Федосий	Кудрявцев	\N	+7 (877) 581-9306	5048 541533	среднее	8957
Казимир	Потапов	\N	+7 (589) 436-3882	6127 460889	среднее профессиональное	8958
Бажен	Туров	Макаровна	8 496 651 8155	1908 836827	среднее профессиональное	8959
Осип	Сысоева	\N	+7 661 085 3430	3070 367509	неоконченное высшее	9268
Панфил	Алексеева	Авдеевич	8 056 054 02 34	1549 782124	среднее профессиональное	8960
Леон	Беспалов	\N	+7 (185) 029-6345	4037 642255	среднее	8961
Аполлинарий	Горбунова	\N	+7 125 013 1382	5665 986379	неоконченное высшее	8962
Мина	Шарапов	\N	8 (615) 533-5420	3748 661743	среднее профессиональное	8963
Куприян	Лихачева	\N	+7 (107) 615-7221	6443 730486	неоконченное высшее	8964
Милован	Ширяева	Тимуровна	+7 137 518 9036	3931 849386	\N	8965
Егор	Рогов	\N	+72704942396	1672 324412	среднее	8966
Екатерина	Тимофеева	Григорьевна	+76500101672	7858 162469	высшее	8967
Матвей	Устинов	\N	+7 854 853 3133	9335 269985	\N	8968
Владислав	Калашников	Егорович	+70471306299	6345 169783	неоконченное высшее	8969
Гостомысл	Крюкова	Антипович	8 (272) 712-16-15	6359 589044	среднее	8970
Наум	Федосеев	\N	89779836737	1667 764304	неоконченное высшее	8971
Радим	Орлова	\N	8 (433) 895-67-03	9457 668623	среднее	8972
Платон	Захарова	\N	+7 (295) 110-5844	1272 849218	среднее	8973
Ярополк	Пономарева	\N	80513438680	8167 586413	неоконченное высшее	8974
Варфоломей	Ершова	\N	8 398 167 2277	7180 401700	среднее	8975
Агафья	Кондратьева	\N	+7 339 881 1381	9120 473302	высшее	8976
Твердислав	Петрова	\N	8 838 252 2692	9949 429821	неоконченное высшее	8977
Любомир	Тетерин	Матвеевна	8 788 055 9165	9406 546744	неоконченное высшее	8978
Егор	Власов	Владленович	88451763492	8967 731354	высшее	8979
Всемил	Михеев	Эдгарович	+7 906 058 7740	9722 198570	высшее	8980
Данила	Назаров	Сергеевна	+7 (130) 887-2827	1331 535057	высшее	8981
Октябрина	Шестакова	Дмитриевич	+7 073 963 2535	2835 660788	среднее	8982
Клавдий	Горбунова	Гурьевич	+7 (870) 520-52-61	5872 131032	неоконченное высшее	8983
Якуб	Логинов	\N	+7 526 962 3094	4278 537048	высшее	8984
Ипат	Ефремов	\N	+7 (955) 804-0438	9153 977012	среднее	8985
Аскольд	Некрасова	\N	8 597 115 6903	6529 220893	среднее профессиональное	8986
Руслан	Антонова	Архипович	+7 (321) 130-20-95	1759 713096	высшее	8987
Варфоломей	Мельникова	Максимовна	8 (176) 960-06-73	2029 382733	среднее профессиональное	8988
Гордей	Гаврилов	Виленович	8 731 525 43 63	7236 502921	\N	8989
Сократ	Буров	Макаровна	85889410061	3094 266652	среднее	8990
Мартьян	Голубев	Феофанович	+7 279 235 95 58	8237 922250	среднее профессиональное	8991
Агафья	Карпов	Еремеевич	8 (331) 557-6524	6798 459436	неоконченное высшее	8992
Остап	Владимирова	\N	8 (508) 179-24-58	6481 713348	неоконченное высшее	8993
Лукьян	Воронов	Бенедиктович	8 537 229 69 36	6943 992395	среднее профессиональное	8994
Тамара	Красильникова	Васильевич	+7 225 116 4489	5643 481778	среднее	8995
Виталий	Михайлов	\N	+7 693 307 25 26	9359 135227	неоконченное высшее	8996
Леон	Петухов	\N	+79408121684	5339 616167	среднее	8997
Светозар	Владимиров	\N	8 126 773 17 32	5111 124845	\N	8998
Платон	Евсеев	\N	+7 (242) 409-8121	7414 453759	\N	8999
Ипполит	Кулагин	Даниилович	8 355 781 7058	2185 720333	\N	9000
Евграф	Калашников	\N	+75148005494	2128 288895	среднее	9001
Гаврила	Ершова	\N	+7 585 963 15 27	4550 301234	среднее профессиональное	9002
Савелий	Миронов	\N	+7 320 836 05 98	2583 682839	высшее	9003
Михей	Савельева	Сергеевна	8 614 022 60 68	7513 911370	среднее профессиональное	9004
Леонид	Гришин	\N	8 (694) 383-75-24	8667 958582	среднее	9005
Ферапонт	Константинов	Андреевич	+7 109 768 92 21	2302 126342	среднее профессиональное	9006
Куприян	Харитонова	\N	+72313826536	2911 125312	среднее	9007
Кира	Большакова	\N	+7 021 986 85 76	5369 508837	среднее	9008
Панкрат	Елисеева	\N	+7 (937) 320-17-30	6554 879499	среднее	9009
Фаина	Евсеев	\N	+7 (828) 125-80-60	9405 503752	\N	9010
Фотий	Новикова	\N	8 609 762 6962	4492 144103	неоконченное высшее	9011
Лора	Максимов	\N	8 455 664 12 90	1351 810702	среднее профессиональное	9012
Евдокия	Белов	Харлампьевич	+7 036 768 34 08	4374 748181	неоконченное высшее	9013
Никифор	Михеев	Димитриевич	+7 (845) 732-73-77	6104 878043	среднее профессиональное	9014
Селиван	Молчанова	Фомич	8 081 364 4140	9492 458358	высшее	9015
Еремей	Миронов	Эдуардовна	8 393 080 42 14	2992 600289	\N	9016
Савватий	Козлов	\N	8 321 787 1930	9168 424227	среднее профессиональное	9017
Ростислав	Зайцева	Захарьевич	+7 (697) 064-08-36	5425 987553	\N	9018
Леонтий	Дмитриева	Артемовна	8 013 644 3356	4852 672078	среднее	9019
Ульян	Воронцов	Антоновна	8 (286) 704-50-16	6984 578720	неоконченное высшее	9020
Изот	Лазарева	\N	8 (737) 626-41-11	3831 413786	среднее	9021
Никифор	Суханова	\N	+77046700681	8870 734343	среднее профессиональное	9022
Алексей	Егорова	\N	+7 799 887 35 83	3585 284603	среднее профессиональное	9023
Федот	Горбунов	\N	80496394700	3912 897786	высшее	9024
Фортунат	Брагина	\N	8 003 117 9931	5969 781863	неоконченное высшее	9025
Иларион	Сазонова	\N	8 (450) 394-9245	5783 450321	неоконченное высшее	9026
Алина	Коновалов	\N	8 001 625 41 78	5539 204824	\N	9027
Зосима	Медведев	\N	8 (931) 786-8377	4865 972637	\N	9028
Викентий	Суворова	\N	+7 980 983 5478	8585 460699	высшее	9029
Серафим	Сафонова	Филиппович	+7 (887) 805-8872	4746 659661	среднее	9030
Иларион	Кириллова	Ефстафьевич	8 (548) 541-2512	6191 728045	неоконченное высшее	9031
Модест	Власов	\N	+7 (237) 413-0289	6798 187080	высшее	9032
Владлен	Мамонтова	Фадеевич	8 (976) 239-23-51	3000 117503	среднее профессиональное	9033
Корнил	Емельянова	Яковлевна	+7 170 596 6953	5657 972509	среднее	9034
Тарас	Самойлова	Эльдаровна	8 797 104 40 92	3970 282023	высшее	9035
Автоном	Матвеев	Оскаровна	+7 930 507 89 09	9857 281211	среднее профессиональное	9036
Авксентий	Зыкова	\N	8 151 868 42 24	9126 688199	среднее	9037
Вероника	Красильников	\N	+7 (809) 765-00-86	2794 511805	неоконченное высшее	9038
Мирон	Гурьев	Алексеевич	+7 469 487 13 05	3173 747075	неоконченное высшее	9039
Зиновий	Игнатьев	\N	+71909335650	5590 870083	высшее	9040
Вера	Ефремова	Кузьминична	8 (050) 287-11-65	2408 989578	среднее профессиональное	9041
Христофор	Гущина	\N	+73382952291	6121 916050	среднее профессиональное	9042
Юрий	Дорофеев	\N	+73405582277	2937 697271	высшее	9043
Егор	Фомин	\N	8 (061) 369-57-53	5499 158459	среднее	9044
Дмитрий	Селезнев	\N	+7 (577) 974-2102	1829 405092	неоконченное высшее	9045
Артем	Кабанова	Валентиновна	8 296 348 9545	3757 467553	высшее	9046
Кондрат	Крылов	Егорович	8 703 052 3337	4900 337232	высшее	9047
Петр	Доронин	\N	+7 (933) 545-1323	8145 865476	высшее	9048
Надежда	Жуков	Давыдович	8 053 256 39 53	1513 859303	неоконченное высшее	9049
Валерия	Евдокимов	Дмитриевич	+7 (147) 575-3057	8668 408864	неоконченное высшее	9050
Моисей	Федосеева	\N	+71767278888	2518 348335	\N	9051
Парфен	Хохлов	Алексеевич	8 591 756 0527	7512 614327	\N	9052
Акулина	Аксенова	Фролович	+7 (528) 760-28-31	8194 611835	неоконченное высшее	9053
Аникей	Ершова	\N	+7 236 363 72 44	9860 322332	высшее	9054
Харлампий	Фомичев	\N	8 (426) 919-5300	2773 424478	неоконченное высшее	9055
Елисей	Игнатов	Семеновна	+7 983 435 4432	3554 352514	неоконченное высшее	9056
Николай	Лыткина	Авдеевич	83820612427	1933 708572	неоконченное высшее	9057
Севастьян	Попова	Ануфриевич	8 (843) 176-72-18	7617 544426	высшее	9058
Прохор	Богданова	\N	8 439 111 2808	1307 996445	высшее	9059
Мир	Гаврилова	Филатович	8 265 049 4588	9045 226771	среднее	9060
Еремей	Ковалева	Теймуразович	+7 840 596 5771	4902 829401	высшее	9061
Лев	Антонов	Гурьевич	+7 (645) 178-39-94	8962 177362	высшее	9062
Еремей	Владимиров	\N	+78862517233	9134 838976	среднее профессиональное	9063
Нестор	Рябова	Альбертовна	8 (534) 709-2510	9174 262981	высшее	9064
Юлий	Сергеев	\N	8 (517) 153-4472	6226 515355	среднее	9065
Светлана	Бирюков	Августович	+7 (977) 235-5465	3620 785694	высшее	9066
Тимофей	Кудряшова	\N	8 841 314 91 89	4129 564953	среднее	9067
Михаил	Михеева	\N	81144017588	7953 972364	неоконченное высшее	9068
Самуил	Евсеев	\N	8 732 708 03 89	7584 303879	\N	9069
Сигизмунд	Шубин	\N	+7 514 337 4401	6290 551965	неоконченное высшее	9070
Никита	Некрасов	\N	+78930339152	1346 296349	\N	9071
Никанор	Баранов	Иосифович	+7 378 944 1581	9067 965164	среднее профессиональное	9072
Данила	Лаврентьева	\N	8 (831) 006-21-97	6208 321426	неоконченное высшее	9073
Тимур	Маркова	\N	86001699248	1599 729061	высшее	9074
Прокофий	Шилов	\N	+7 (341) 972-2396	5101 325105	неоконченное высшее	9075
Силантий	Рыбаков	Робертовна	+7 (639) 283-7536	9385 306239	высшее	9076
Кондратий	Дмитриев	Филимонович	8 489 688 9940	3739 672788	среднее	9077
Рюрик	Зуева	\N	86491134234	3544 975278	высшее	9078
Фирс	Бирюков	\N	+71177328091	5085 936746	среднее	9079
Нина	Кузнецов	\N	+72343850490	2501 132253	среднее	9080
Петр	Ильина	Артёмович	89708589197	1939 403958	неоконченное высшее	9081
Харлампий	Никифоров	\N	8 (715) 503-63-47	3948 162525	неоконченное высшее	9082
Ангелина	Степанов	Харлампьевич	+7 (940) 110-29-41	3980 287919	среднее	9083
Лука	Жданов	Владиславовна	+7 841 916 5606	6256 425884	неоконченное высшее	9084
Октябрина	Рыбакова	Александрович	+75118708705	6091 951986	неоконченное высшее	9085
Сигизмунд	Гуляева	Федотович	8 (770) 865-09-87	9310 369790	\N	9086
Спартак	Петухов	Феодосьевич	8 015 875 3288	4009 599324	среднее профессиональное	9087
Клавдия	Ершов	\N	+71778743337	5421 271814	среднее	9088
Архип	Горбунов	\N	8 852 214 30 38	3175 662606	среднее профессиональное	9089
Изяслав	Красильникова	\N	+7 (658) 710-75-25	1208 660863	среднее	9090
Иннокентий	Колобова	Архипович	8 (575) 847-7312	2399 202464	высшее	9091
Вениамин	Евсеев	\N	+7 266 968 56 88	7693 739147	неоконченное высшее	9092
Виктор	Анисимов	Анисимович	+7 (287) 105-9689	1396 502049	\N	9093
Ладимир	Дорофеев	Харлампович	+7 (343) 466-1353	3888 115300	неоконченное высшее	9094
Прохор	Громова	\N	8 (410) 132-90-11	3334 417347	\N	9095
Ипат	Григорьева	Авдеевич	+7 (301) 835-9811	8023 445480	среднее	9096
Нестор	Королева	Максимовна	8 (247) 166-4788	2811 758698	\N	9097
Роман	Анисимов	Владиленович	+79770199397	1832 272836	неоконченное высшее	9098
Ратмир	Попов	Герасимович	8 (093) 194-0919	9619 370315	\N	9099
Зосима	Петухова	\N	8 422 074 89 95	1353 998605	неоконченное высшее	9100
Поликарп	Панфилова	\N	+7 (858) 716-1277	3791 881431	высшее	9101
Владислав	Михайлов	Викторович	8 753 610 99 01	3624 263668	высшее	9102
Марфа	Белова	\N	+7 (257) 384-7440	4969 137081	\N	9103
Никита	Антонова	\N	+7 (108) 166-2402	2105 718328	неоконченное высшее	9104
Панкратий	Трофимова	\N	+7 (291) 312-73-66	7929 814933	неоконченное высшее	9105
Любосмысл	Савельев	\N	8 (009) 274-8851	9953 478135	неоконченное высшее	9106
Феофан	Копылова	Владиславович	+7 (520) 664-42-69	5373 874083	высшее	9107
Фрол	Казакова	Альбертовна	88903384549	9695 863310	среднее профессиональное	9108
Галактион	Красильников	Аксёнович	82060732206	7176 510851	высшее	9109
Сократ	Казакова	Вадимовна	8 (799) 993-62-70	9873 369614	неоконченное высшее	9110
Никандр	Шаров	\N	8 677 935 6256	2966 528518	среднее	9111
Елена	Иванова	\N	+7 (559) 291-76-27	1668 994012	среднее профессиональное	9112
Никон	Кузнецова	Герасимович	+7 (851) 634-43-11	7076 133918	неоконченное высшее	9113
Глеб	Константинова	Артемовна	+7 392 804 78 23	3642 335730	неоконченное высшее	9114
Рюрик	Колобов	Арсенович	+7 (373) 432-7222	4994 835298	высшее	9115
Макар	Некрасов	Владимировна	+7 262 951 44 49	7367 967192	неоконченное высшее	9116
Евстигней	Одинцова	Эдуардовна	8 004 605 1521	9384 505230	неоконченное высшее	9117
Арсений	Кулаков	Феликсовна	8 (067) 530-93-09	6434 466203	неоконченное высшее	9118
Серафим	Горшков	Григорьевна	8 953 333 37 74	7465 477420	среднее	9119
Серафим	Быкова	\N	+78765194391	1492 803647	\N	9120
Марк	Полякова	\N	86639136201	9379 364508	высшее	9121
Тимофей	Мартынов	\N	8 (472) 151-91-34	3268 382116	\N	9122
Богдан	Русаков	Святославовна	8 607 130 33 89	2739 537163	среднее	9123
Якуб	Кудрявцева	\N	8 323 573 67 16	5982 145404	среднее профессиональное	9124
Август	Архипова	\N	+7 879 246 8522	9538 655765	\N	9125
Герасим	Кабанова	\N	+7 (164) 812-5736	1066 643358	неоконченное высшее	9126
Ярослав	Соловьева	Герасимович	+79098489273	2171 117304	\N	9127
Наина	Емельянов	Антипович	+7 426 530 8054	6469 262604	среднее профессиональное	9128
Наркис	Одинцов	\N	+7 453 423 3937	1095 630360	высшее	9129
Харлампий	Костин	Тарасович	+7 595 908 6458	6673 528249	\N	9130
Радован	Котов	\N	+7 957 124 3611	9770 490113	высшее	9131
Милан	Стрелков	Фролович	86409079502	8579 307459	\N	9132
Феврония	Давыдова	\N	+7 817 018 57 57	1957 808453	среднее	9133
Елисей	Виноградов	Феоктистович	+7 (191) 594-32-41	6934 392300	\N	9134
Корнил	Якушев	Давидович	8 (322) 239-62-71	1083 228399	\N	9135
Кондратий	Вишняков	\N	+7 902 102 9353	2845 819251	среднее	9136
Светлана	Рябов	Степановна	+7 (180) 155-76-93	4826 399884	среднее профессиональное	9137
Милий	Нестерова	Эдуардович	8 194 239 4373	9448 428197	неоконченное высшее	9138
Макар	Чернова	Аксёнович	88287664901	7416 212132	среднее профессиональное	9139
Евграф	Ершова	\N	+7 (252) 639-9824	9909 174365	среднее	9140
Антонин	Зуев	Евгеньевна	+7 805 228 59 74	2558 726575	неоконченное высшее	9141
Ермил	Субботин	Вадимовна	8 (585) 812-14-39	6215 286796	среднее	9142
Макар	Назаров	Антипович	8 (653) 976-07-78	3749 306157	высшее	9143
Елена	Карпова	\N	8 (598) 999-71-97	4583 908589	высшее	9144
Алла	Евдокимова	Архипович	+7 (606) 843-31-67	8341 797353	среднее профессиональное	9145
Иннокентий	Наумова	\N	8 (863) 971-1234	1318 615327	высшее	9146
Трифон	Молчанова	Евстигнеевич	+7 960 945 84 11	6948 534117	\N	9147
Наркис	Горбачева	Дорофеевич	+72567153016	4135 938756	\N	9148
Алексей	Кулаков	\N	+74281364160	3760 536174	неоконченное высшее	9149
Сергей	Фокин	\N	+7 885 480 63 39	4108 836459	среднее профессиональное	9150
Тамара	Фролов	Елисеевич	+7 567 574 22 27	4029 285921	высшее	9151
Пантелеймон	Кудряшов	\N	8 (504) 982-65-05	7310 456439	среднее профессиональное	9152
Владлен	Ларионова	\N	+75616469658	2809 160014	\N	9153
Януарий	Овчинникова	Борисович	+7 (086) 615-43-74	7604 482402	неоконченное высшее	9154
Епифан	Ермакова	\N	+78857921926	7572 248860	\N	9155
Гурий	Ситникова	Леоновна	83079062254	6719 833386	среднее	9156
Валентина	Рогова	Захаровна	8 314 950 83 42	5625 851388	\N	9157
Агата	Ильина	\N	+71711903522	3643 311397	\N	9158
Аникита	Брагин	Гурьевич	+7 (979) 553-44-32	8818 428489	среднее профессиональное	9159
Милован	Носков	\N	8 (565) 513-63-78	6114 239895	среднее профессиональное	9160
Галина	Гордеева	\N	+7 333 227 5599	6189 903026	неоконченное высшее	9161
Фаина	Титов	Аверьянович	+7 908 155 5775	2055 178346	\N	9162
Лаврентий	Денисов	Георгиевна	+79074103493	6096 478258	\N	9163
Семен	Тимофеев	\N	+7 (415) 754-6228	6958 529428	среднее	9164
Родион	Мамонтов	\N	8 084 274 06 93	7402 548455	\N	9165
Никандр	Гусев	Измаилович	+7 (478) 198-07-33	1835 381349	среднее	9166
Олег	Наумов	Юльевна	+7 006 291 64 48	2299 150813	неоконченное высшее	9167
Артемий	Громова	\N	+70252982461	4833 296445	неоконченное высшее	9168
Ермолай	Шашкова	Павловна	89832914660	8715 555083	неоконченное высшее	9169
Иларион	Поляков	Елисеевич	+7 802 463 7245	3606 699577	среднее	9170
Ферапонт	Мясникова	Ефстафьевич	+7 856 623 84 59	8412 409655	среднее профессиональное	9171
Авксентий	Маслов	Феликсович	+7 (956) 670-75-64	4769 942359	неоконченное высшее	9172
Спартак	Калашникова	\N	86492792403	5408 762439	среднее	9173
Авдей	Зуев	Ниловна	+7 (180) 547-0631	6587 406778	среднее профессиональное	9174
Яков	Якушев	Олеговна	8 (437) 849-14-58	6347 238708	неоконченное высшее	9175
Фирс	Федотов	Германович	83771828901	6899 943454	\N	9176
Фортунат	Степанов	\N	+7 (922) 030-5284	5277 288033	высшее	9177
Оксана	Марков	Юрьевна	8 979 422 49 74	8684 415561	высшее	9178
Илья	Игнатьев	Владиславович	+7 868 082 8915	4557 921763	\N	9179
Радован	Юдина	\N	81163207355	8934 971213	\N	9180
Гедеон	Васильева	Константиновна	8 463 316 0614	3453 266763	\N	9181
Людмила	Сергеев	\N	8 325 353 7187	6247 330735	высшее	9182
Прасковья	Борисов	Владиславовна	8 (632) 956-5257	5848 813184	высшее	9183
Касьян	Евдокимова	Гордеевич	82254292005	6325 766828	неоконченное высшее	9184
Фока	Русакова	Артёмович	+7 016 936 36 85	4439 323865	\N	9185
Гедеон	Тимофеева	\N	8 (820) 780-78-69	6705 351552	высшее	9186
Любомир	Шашков	Игоревна	+7 (585) 778-6740	9516 157290	среднее профессиональное	9187
Моисей	Карпов	Семеновна	+7 249 806 19 30	1554 430108	среднее профессиональное	9188
Кондрат	Колобова	Руслановна	87909778234	6221 280592	высшее	9189
Валентина	Григорьев	Борисовна	+7 867 752 5076	3957 323541	неоконченное высшее	9190
Викторин	Лазарева	\N	+7 556 925 68 97	3957 232009	высшее	9191
Феоктист	Петухова	Фёдорович	82297163805	3752 395807	неоконченное высшее	9192
Самуил	Константинов	Андреевич	8 (686) 458-87-31	8007 807347	среднее	9193
Филипп	Кузьмина	\N	+7 828 321 1202	5265 891629	среднее	9194
Осип	Гришина	Ануфриевич	+7 (076) 252-53-03	4019 835760	среднее профессиональное	9195
Стоян	Никифорова	\N	+7 569 695 85 06	4555 765563	\N	9196
Лонгин	Кириллова	\N	8 (670) 226-50-58	7712 777526	\N	9197
Жанна	Аксенов	Ерофеевич	8 (997) 197-56-77	5787 616199	среднее профессиональное	9198
Стоян	Носова	Харламович	8 672 347 28 36	7201 234030	неоконченное высшее	9199
Артемий	Блинов	\N	8 853 943 32 83	5187 386378	среднее	9200
Федосий	Савина	\N	+7 (134) 617-88-14	6353 704402	среднее профессиональное	9201
Кирилл	Селезнева	\N	8 635 211 90 31	5065 854407	среднее	9202
Маргарита	Герасимов	Олеговна	8 (709) 999-3605	3047 924984	среднее профессиональное	9203
Модест	Макарова	Юльевна	+7 (086) 248-4080	6183 428353	высшее	9204
Демьян	Осипов	Данилович	8 (751) 371-1701	7912 411078	среднее профессиональное	9205
Вячеслав	Селезнев	Викторовна	+7 (334) 557-6283	4447 179917	среднее профессиональное	9206
Милован	Кулакова	Филиппович	+7 (350) 410-31-78	3860 849269	неоконченное высшее	9207
Лавр	Сазонова	\N	+7 (896) 146-8585	4959 757555	неоконченное высшее	9208
Силантий	Мартынов	\N	8 (558) 843-06-56	6237 895515	среднее	9209
Виктор	Жданов	Ждановна	+7 (531) 655-8702	5453 656421	среднее профессиональное	9210
Силантий	Богданова	Гертрудович	8 357 255 2632	7876 584359	высшее	9211
Элеонора	Логинов	\N	8 951 485 61 24	8021 371001	среднее	9212
Моисей	Блохина	Константиновна	8 912 274 6345	6786 224589	среднее профессиональное	9213
Евфросиния	Белоусова	\N	+7 (314) 856-8944	4956 335365	неоконченное высшее	9214
Терентий	Никитина	Захаровна	8 (969) 041-08-62	7034 472759	среднее профессиональное	9215
Прокл	Кошелева	\N	8 624 125 21 21	4400 568341	\N	9216
Парамон	Фролов	Антипович	+7 (786) 538-6049	7970 554250	среднее профессиональное	9217
Осип	Евдокимов	\N	+7 (095) 844-6961	5873 685922	среднее	9218
Марк	Рогова	\N	+73602143421	8129 955215	среднее профессиональное	9219
Мартын	Дмитриева	\N	+7 (327) 827-42-07	8365 612458	\N	9220
Рубен	Юдина	\N	+7 572 095 5831	1216 466472	среднее профессиональное	9221
Прокл	Назаров	Данилович	+7 (918) 301-62-86	2004 455810	среднее профессиональное	9222
Лора	Турова	\N	+7 624 092 38 15	8175 356749	\N	9223
Спиридон	Уварова	\N	8 (591) 702-59-96	3739 153720	среднее профессиональное	9224
Орест	Елисеев	Игоревич	+75480535403	6882 478467	среднее	9225
Любосмысл	Савин	\N	8 557 833 40 53	5274 566991	среднее	9226
Лукия	Григорьев	Августович	8 504 844 3311	8535 942873	среднее	9227
Михей	Абрамов	\N	8 363 124 29 13	6654 968612	неоконченное высшее	9228
Кира	Антонов	Абрамович	+70882185533	7744 960379	среднее профессиональное	9229
Нестор	Орехов	Ильич	8 (904) 601-79-61	4129 292319	\N	9230
Панкратий	Иванов	Абрамович	+72106903782	3195 873936	среднее профессиональное	9231
Агап	Агафонов	\N	8 977 007 37 55	7385 972935	неоконченное высшее	9232
Платон	Королева	\N	8 901 215 39 38	5677 237045	высшее	9233
Наркис	Устинов	\N	8 (828) 765-7560	6548 254973	неоконченное высшее	9234
Фотий	Рябов	Геннадьевна	8 (046) 292-0112	7304 460807	среднее профессиональное	9235
Валерия	Игнатьева	Васильевна	+7 (076) 055-6801	5669 218921	среднее профессиональное	9236
Севастьян	Сысоев	Богданович	81786051435	6908 773868	высшее	9237
Евдокия	Фомичев	Алексеевич	+7 (230) 116-8190	2424 482443	неоконченное высшее	9238
Мирон	Морозов	\N	88115170775	1370 641764	неоконченное высшее	9239
Святополк	Шестаков	Даниловна	8 421 776 27 07	4781 285798	неоконченное высшее	9240
Викентий	Белов	Валерьевич	8 (881) 616-76-08	1594 979367	среднее	9241
Аркадий	Носкова	\N	81665564878	4230 630733	высшее	9242
Карл	Маслов	\N	8 (492) 579-79-05	3945 473955	высшее	9243
Лукия	Никитина	\N	+7 (225) 002-73-74	2635 605136	высшее	9244
Мартын	Белоусов	\N	8 054 488 3526	6066 667561	среднее	9245
Леон	Крюков	\N	+7 (957) 929-82-72	6841 958910	\N	9246
Евгений	Фадеева	\N	+76645160328	4591 523343	\N	9247
Игорь	Уварова	Харлампьевич	84891559658	1705 605645	высшее	9248
Фока	Быкова	\N	+78255599052	2856 679476	высшее	9249
Раиса	Белов	Валентиновна	8 (282) 583-6499	4248 192633	\N	9250
Тимур	Захарова	Трифонович	+7 (890) 462-3008	2631 195120	среднее профессиональное	9251
Фотий	Степанов	Кирилловна	+7 (099) 871-4599	9399 871972	\N	9252
Лазарь	Симонов	\N	+7 464 037 6317	9363 780515	среднее профессиональное	9253
Лаврентий	Мартынов	\N	8 223 536 6891	2263 920524	\N	9254
Игнатий	Назаров	Венедиктович	8 (803) 904-09-96	1376 109988	\N	9255
Кузьма	Виноградова	Владиленович	87054129987	4952 336146	высшее	9256
Дементий	Рожков	\N	8 460 149 25 54	5975 927887	неоконченное высшее	9257
Венедикт	Бобылев	Абрамович	+7 (959) 245-4497	1136 204084	\N	9258
Станимир	Ширяев	Филатович	+7 (004) 127-74-04	8384 453872	\N	9259
Симон	Горшкова	\N	8 (173) 809-9828	8016 847689	высшее	9260
Феофан	Якушев	\N	+7 488 818 7275	4959 693831	неоконченное высшее	9261
Прохор	Савин	Робертовна	+7 037 943 4697	9944 609654	среднее	9262
Епифан	Евсеева	\N	8 (089) 251-82-75	7235 173937	\N	9263
Никифор	Петухов	Харлампович	8 (722) 027-26-05	8061 559675	среднее	9264
Галина	Фомин	Иосипович	8 (349) 646-8445	8732 584662	высшее	9265
Марк	Александрова	\N	+7 (962) 964-00-86	8803 663430	среднее	9266
Модест	Комаров	\N	+7 233 908 28 66	4240 561429	высшее	9267
Селиван	Красильников	Харламович	+77714115265	2560 481530	среднее	9269
Регина	Кузьмин	Димитриевич	+7 697 500 00 58	6433 896433	\N	9270
Роман	Борисова	Иосипович	+7 (948) 681-2649	4995 936172	неоконченное высшее	9271
Моисей	Симонова	\N	+7 (403) 263-8915	2624 668674	среднее профессиональное	9272
Кира	Селезнев	\N	8 (849) 685-99-34	6715 783831	среднее	9273
Спиридон	Фомичев	Степановна	+7 247 186 24 85	8493 505357	среднее	9274
Антонин	Копылов	\N	8 (184) 411-59-34	6066 969941	среднее	9275
Прокл	Крюкова	\N	8 579 620 0517	8459 199959	неоконченное высшее	9276
Прокл	Данилова	Яковлевна	+7 546 572 1095	2801 543495	высшее	9277
Марк	Ефремов	\N	+72383857773	1237 902577	неоконченное высшее	9278
Елисей	Прохорова	\N	+7 (032) 718-0523	8527 485451	высшее	9279
Натан	Давыдова	\N	+7 832 107 73 22	1078 178169	высшее	9280
Емельян	Ковалев	\N	+7 278 298 91 52	5382 440801	высшее	9281
Лазарь	Морозов	Дмитриевна	+7 669 084 6790	2483 765721	неоконченное высшее	9282
Валерия	Андреев	Дмитриевна	80701200523	6771 264150	\N	9283
Акулина	Прохорова	\N	+72554746283	6404 302109	неоконченное высшее	9284
Дементий	Зимина	Зиновьевич	8 179 735 05 85	6601 235745	среднее профессиональное	9285
Прохор	Галкин	Григорьевич	+7 627 284 1895	7011 959973	\N	9286
Модест	Блинова	\N	8 568 251 8696	6840 994926	\N	9287
Нина	Сергеева	Дорофеевич	8 754 657 66 18	8606 914049	высшее	9288
Яков	Панов	Даниловна	+7 (307) 871-0972	6226 533138	среднее	9289
Ростислав	Соболева	Тарасович	8 (425) 395-9342	4161 422549	среднее	9290
Рубен	Максимова	Федосьевич	+7 452 137 58 92	2530 867663	высшее	9291
Арефий	Мамонтов	\N	8 344 398 5302	3980 156670	среднее профессиональное	9292
Карп	Авдеев	\N	8 (953) 370-2489	9620 873079	\N	9293
Ольга	Одинцова	Ивановна	8 812 820 7574	2484 452899	среднее	9294
Азарий	Артемьев	Устинович	+73680581136	8046 921285	неоконченное высшее	9295
Дорофей	Вишнякова	Федоровна	+7 244 139 09 32	3150 346678	высшее	9296
Галактион	Наумова	Викторовна	+7 (450) 055-10-18	5397 150295	среднее	9297
Клавдий	Громова	\N	+7 249 055 48 72	9708 220516	\N	9298
Аскольд	Сазонов	\N	8 (926) 425-8882	4700 230851	неоконченное высшее	9299
Мстислав	Корнилов	\N	+7 056 076 1389	3491 344378	\N	9300
Юлиан	Шарова	Фокич	8 064 528 68 54	1798 621603	среднее	9301
Софрон	Панов	Исидорович	8 (715) 241-78-91	4949 152888	высшее	9302
Фотий	Копылов	Вилорович	8 (931) 415-1777	1849 761528	среднее профессиональное	9303
Ярослав	Симонова	Ермилович	+7 750 939 5314	9300 574400	среднее	9304
Иван	Шестаков	Ааронович	+7 526 868 2262	1345 697159	среднее профессиональное	9305
Жанна	Соловьев	Богдановна	8 498 946 4852	1655 519087	\N	9306
Людмила	Трофимова	Алексеевна	8 457 459 3062	7346 865928	среднее	9307
Евдоким	Филатов	\N	8 (695) 549-17-96	6677 500109	высшее	9308
Ульяна	Рожков	\N	+78567264389	4453 692029	\N	9309
Владилен	Богданова	Федосьевич	8 757 427 36 94	9295 304383	среднее профессиональное	9310
Владлен	Капустина	\N	8 (948) 834-2518	6099 191963	среднее профессиональное	9311
Евгения	Жуков	Всеволодович	+71593846760	4538 798586	среднее	9312
Евстафий	Савин	\N	8 522 040 3384	8488 442668	среднее профессиональное	9313
София	Меркушева	Бенедиктович	8 (916) 249-2140	2678 644695	высшее	9314
Авксентий	Субботин	\N	+7 (784) 260-38-27	1427 505086	\N	9315
Аким	Муравьев	Арсеньевич	+74647224613	7318 911129	высшее	9316
Станислав	Федосеев	\N	8 (106) 438-4489	5154 525601	\N	9317
Натан	Кулагина	Венедиктович	8 (346) 229-1403	5162 842365	среднее	9318
Трифон	Хохлова	\N	+7 749 883 6788	7968 936554	среднее профессиональное	9319
Зосима	Селезнева	\N	+71182765119	2855 935435	высшее	9320
Трифон	Маслов	\N	82432613171	7871 878570	\N	9321
Вениамин	Михайлов	Демидович	8 101 635 13 68	6344 753846	неоконченное высшее	9322
Федор	Рожкова	\N	8 798 181 42 71	7891 533157	среднее профессиональное	9323
Емельян	Бурова	\N	86159383249	9609 811045	неоконченное высшее	9324
Антонина	Лобанов	Ниловна	+7 (808) 429-8870	8145 112964	неоконченное высшее	9325
Пахом	Потапов	\N	8 751 808 0111	5284 444839	\N	9326
Елисей	Ефимов	\N	8 (671) 474-19-82	3868 132590	\N	9327
Ермолай	Князева	Ильинична	+7 (166) 247-0750	8900 912540	\N	9328
Алла	Полякова	\N	8 (569) 565-4623	5451 915994	среднее профессиональное	9329
Евгений	Евдокимова	Харламович	+7 667 717 50 47	9792 176744	среднее	9330
Максим	Самойлов	\N	8 (635) 821-2148	9409 923069	\N	9331
Зиновий	Лапин	Ефремович	+7 (482) 354-8182	2109 127725	высшее	9332
Виталий	Бурова	\N	8 764 531 0582	6271 703700	высшее	9333
Юлий	Титов	\N	8 (650) 577-74-80	1565 254202	\N	9334
Афанасий	Красильникова	Филиппович	+7 (427) 387-5023	3869 635813	среднее профессиональное	9335
Наина	Одинцова	Егорович	+7 (983) 418-60-55	7572 292582	среднее профессиональное	9336
Викторин	Егорова	\N	+7 (300) 579-96-92	9040 656193	среднее	9337
Феофан	Александров	\N	8 682 058 4417	4048 990582	\N	9338
Софрон	Константинов	Ефстафьевич	89623062879	6417 882380	высшее	9339
Порфирий	Исаева	\N	+7 (795) 594-09-00	2620 559239	среднее	9340
Светозар	Денисов	\N	87346528666	7970 269070	среднее	9341
Евсей	Красильникова	Феликсович	+7 360 264 9581	6636 285219	высшее	9342
Вера	Егорова	Ильинична	+7 446 618 33 55	7578 432800	\N	9343
Спиридон	Гришин	Эльдаровна	8 (011) 616-18-95	8556 395418	среднее профессиональное	9344
Лукия	Колобов	Алексеевич	8 (991) 772-45-37	7031 416713	высшее	9345
Милица	Шубин	Кузьминична	87168958759	6569 839542	неоконченное высшее	9346
Капитон	Игнатьева	\N	8 (735) 214-22-84	5548 699967	среднее	9347
Фёкла	Самойлов	\N	+7 518 637 80 32	2483 789351	среднее	9348
Максим	Ершова	Аскольдовна	+74035506728	6326 673425	\N	9349
Ульян	Рыбакова	\N	82359825584	7652 582657	\N	9350
Таисия	Абрамова	Аскольдовна	+7 (231) 719-54-61	8493 839916	неоконченное высшее	9351
Никита	Абрамов	\N	+7 905 597 0429	2878 488962	среднее	9352
Любомир	Лапина	\N	84720383213	4856 722166	среднее	9353
Евгений	Давыдова	Виленович	+7 733 499 0632	6041 958142	\N	9354
Антип	Игнатьев	Викентьевич	+7 (624) 227-32-93	5258 539730	высшее	9355
Ладислав	Журавлева	\N	8 177 220 5069	2394 688196	среднее профессиональное	9356
Харлампий	Шарапова	\N	+7 392 700 85 02	5930 252163	среднее	9357
Тимур	Туров	\N	84183199962	1002 294014	высшее	9358
Парфен	Некрасова	\N	8 (062) 814-3093	4982 370554	высшее	9359
Трифон	Некрасова	\N	+7 910 546 9541	3054 621200	\N	9360
Филарет	Орлов	\N	+77488880211	4432 666067	среднее профессиональное	9361
Леон	Комиссаров	Оскаровна	8 (332) 643-78-20	3942 566285	среднее	9362
Вацлав	Евсеева	\N	8 (893) 199-6530	8029 486977	\N	9363
Кир	Панова	\N	8 (450) 324-2003	7532 246530	среднее профессиональное	9364
Глеб	Беспалова	Феликсович	+75756556923	6929 287599	высшее	9365
Фома	Кудрявцева	\N	8 (868) 922-34-84	1306 234122	\N	9366
Фома	Костин	\N	8 387 857 9131	9593 214075	среднее профессиональное	9367
Прасковья	Князева	Юлианович	+7 (972) 739-4769	9180 496635	неоконченное высшее	9368
Герасим	Голубев	Иларионович	+7 (082) 841-3143	7563 787893	неоконченное высшее	9369
Никодим	Фокина	Юрьевна	+7 021 366 22 96	8297 725108	среднее профессиональное	9370
Болеслав	Кононов	\N	+7 (415) 984-65-51	3516 274311	неоконченное высшее	9371
Глафира	Бирюкова	\N	82690285320	1884 358354	\N	9372
Лев	Аксенов	\N	86005166996	9303 844293	\N	9373
Синклитикия	Турова	\N	8 (737) 243-83-33	3914 576502	\N	9374
Светозар	Казакова	Дорофеевич	8 486 284 4310	1069 267458	неоконченное высшее	9375
Ермил	Пономарева	Авдеевич	+7 (972) 515-16-52	4213 186954	неоконченное высшее	9376
Родион	Гурьева	\N	+7 370 277 93 26	8808 343420	высшее	9377
Юлиан	Рябов	Валентинович	8 (545) 981-0101	1898 363269	среднее	9378
Якуб	Шарапова	Антонович	+7 (138) 168-72-86	4337 504494	среднее профессиональное	9379
Вениамин	Самойлов	\N	+7 (182) 148-4999	8016 875964	среднее	9380
Лаврентий	Воробьева	\N	+7 (652) 792-1662	4412 484680	среднее	9381
Чеслав	Фадеев	\N	+76839631299	5833 667314	среднее	9382
Бронислав	Молчанов	\N	82258337904	3503 353538	среднее профессиональное	9383
Давыд	Яковлева	Степановна	+7 (044) 493-0848	1374 306530	среднее профессиональное	9384
Сильвестр	Гурьева	Терентьевич	8 663 192 54 62	9909 304044	\N	9385
Виктория	Федосеев	Эдуардович	+7 (823) 343-8700	2065 501694	среднее	9386
Сильвестр	Егорова	\N	89638344114	1531 750912	среднее	9387
Евпраксия	Шубин	Иосифович	87966705577	3817 452822	\N	9388
Варфоломей	Беспалов	\N	8 (066) 499-96-29	7695 139386	высшее	9389
Милован	Рожкова	Богданович	8 694 569 6073	6946 300279	среднее	9390
София	Одинцова	Ефстафьевич	8 (276) 559-34-50	1105 554023	среднее	9391
Сила	Кузьмин	Бенедиктович	+7 972 104 31 62	3603 781082	\N	9392
Тимур	Егорова	Трифонович	8 (512) 630-8213	8146 614381	среднее	9393
Кир	Алексеева	\N	81833265049	9821 616848	среднее профессиональное	9394
Якуб	Степанова	\N	+7 697 622 5547	6544 463821	\N	9395
Пантелеймон	Селиверстов	Марсович	8 571 983 2922	3066 516232	среднее профессиональное	9396
Евпраксия	Мишина	\N	+7 396 665 47 58	7157 116725	высшее	9397
Павел	Бурова	Матвеевна	+7 (017) 666-0241	8689 590617	среднее профессиональное	9398
Христофор	Королев	Антонович	8 734 723 7627	2808 439453	\N	9399
Натан	Кулаков	Вилорович	+74239177373	2177 665080	\N	9400
Савватий	Родионов	Романовна	80857917130	6162 608427	высшее	9401
Антонин	Галкина	\N	83234634023	2231 288151	среднее	9402
Аггей	Ермаков	\N	84870607353	3940 385221	среднее	9403
Савелий	Лаврентьева	Аркадьевна	+7 616 598 45 88	1429 973176	\N	9404
Мирон	Лебедева	\N	8 185 887 9794	2924 323071	\N	9405
Евсей	Горшкова	Вячеславовна	87066616600	5290 365543	неоконченное высшее	9406
Дарья	Молчанова	Денисович	8 054 527 0689	7104 739679	среднее профессиональное	9407
Аким	Бобылев	Иларионович	+76846188363	5507 847490	среднее профессиональное	9408
Будимир	Щербакова	\N	83788608674	5846 700125	неоконченное высшее	9409
Татьяна	Субботина	Геннадиевна	8 274 561 64 37	8589 775183	среднее профессиональное	9410
Моисей	Савин	Теймуразович	8 403 789 3737	2897 484824	среднее профессиональное	9411
Лазарь	Суханов	Богданович	+7 080 473 0834	8964 262073	среднее	9412
Арефий	Федосеева	\N	8 413 415 18 59	2036 674346	неоконченное высшее	9413
Еремей	Якушев	\N	+74938184824	7162 724559	высшее	9414
Наталья	Власова	Ниловна	89643374458	5461 398898	неоконченное высшее	9415
Гурий	Уварова	Викторович	8 369 353 44 21	1626 918648	высшее	9416
Гремислав	Брагин	Устинович	8 (204) 771-80-73	6468 519959	среднее	9417
Боян	Владимирова	\N	8 (557) 371-1190	9991 495768	высшее	9418
Пахом	Яковлева	Робертовна	8 300 349 80 01	6466 513292	\N	9419
Аверьян	Матвеева	\N	8 (169) 962-42-85	6493 365028	высшее	9420
Наина	Лобанов	Гаврилович	8 469 359 6733	2479 148115	среднее профессиональное	9421
Светозар	Вишняков	\N	+7 (826) 777-9480	8272 817458	среднее профессиональное	9422
Евгений	Баранова	\N	80031941162	4391 518102	среднее	9423
Агап	Терентьева	Афанасьевна	8 539 734 5560	5951 331049	среднее	9424
Леон	Никитин	\N	83232104703	6588 794274	высшее	9425
Ия	Быкова	\N	8 654 860 25 55	6018 786043	неоконченное высшее	9426
Парфен	Боброва	Кирилловна	+7 (650) 640-6632	6191 524864	среднее профессиональное	9427
Вышеслав	Селезнев	Алексеевна	+7 023 355 2736	5260 684641	неоконченное высшее	9428
Устин	Фомин	\N	+73294201062	2001 999316	неоконченное высшее	9429
Фёкла	Максимов	\N	+7 (182) 420-8351	6626 908688	неоконченное высшее	9430
Ростислав	Мухина	Рубеновна	+7 (589) 038-0828	1959 235495	высшее	9431
Порфирий	Вишняков	\N	88618116601	5932 987760	неоконченное высшее	9432
Селиван	Федотова	Трифонович	+7 677 167 4033	3363 292999	среднее	9433
Олимпиада	Казакова	Демьянович	8 848 942 4310	7704 834670	высшее	9434
Ермолай	Мамонтова	\N	+73709929788	2484 588555	неоконченное высшее	9435
Вениамин	Харитонова	Афанасьевич	8 (817) 059-1157	4926 868458	среднее профессиональное	9436
Изот	Капустина	\N	87929093379	7714 474059	неоконченное высшее	9437
Аполлон	Исаков	\N	+7 887 489 6436	8303 398906	среднее	9438
Ладимир	Боброва	\N	8 (810) 028-2400	3416 331199	высшее	9439
Митофан	Моисеева	Геннадьевна	+7 473 638 34 31	7524 503909	среднее	9440
Владилен	Карпова	Авдеевич	+7 (034) 566-6711	6950 956198	высшее	9441
Синклитикия	Савина	\N	+7 (864) 257-63-45	5942 834598	среднее	9442
Климент	Селезнева	Арсеньевич	+7 (346) 640-7739	2844 996755	\N	9443
Максим	Кириллова	Александровна	8 894 242 73 26	3335 347741	среднее профессиональное	9444
Федосий	Рожков	Харлампьевич	+7 094 707 83 80	3284 708979	высшее	9445
Максим	Мишина	\N	8 (965) 051-71-82	3752 281837	среднее	9446
Август	Максимова	\N	+76392348820	5459 958003	неоконченное высшее	9447
Модест	Рогова	\N	+7 513 083 1583	5002 960453	высшее	9448
Алина	Шилов	\N	+7 (882) 855-82-39	4959 998134	среднее профессиональное	9449
Дементий	Белова	Мироновна	+7 (884) 105-26-44	8282 374754	\N	9450
Степан	Антонова	\N	8 (437) 082-95-00	1964 408350	\N	9451
Парфен	Казакова	Феликсовна	84167000163	2975 865103	неоконченное высшее	9452
Фортунат	Тетерин	Эльдаровна	+7 (644) 447-4720	3777 342150	высшее	9453
Нинель	Архипов	\N	8 784 969 4213	8765 579904	среднее профессиональное	9454
Селиверст	Тимофеев	Леонидовна	+7 005 771 61 84	6348 963600	неоконченное высшее	9455
Сидор	Архипова	\N	+7 (470) 887-3683	2964 291571	неоконченное высшее	9456
Ульяна	Мамонтов	Валериевна	+7 294 817 60 25	7598 856683	\N	9457
Антонина	Овчинников	Бориславович	+7 748 713 10 04	9562 272685	среднее профессиональное	9458
Екатерина	Тимофеева	\N	8 801 324 0129	4537 905299	неоконченное высшее	9459
Михей	Королева	\N	+7 (328) 581-70-20	9308 342369	среднее	9460
Валентина	Лобанов	Игоревич	8 029 103 87 57	4089 552469	среднее	9461
Ферапонт	Стрелков	\N	+7 (682) 441-2051	3660 320588	среднее	9462
Павел	Кононова	\N	83228637324	8695 472913	среднее	9463
Павел	Самойлов	Фролович	+73108955695	1318 759334	среднее	9464
Ерофей	Андреева	Ниловна	+7 (687) 852-6360	2687 364812	неоконченное высшее	9465
Ермолай	Новиков	\N	+7 (744) 617-02-71	7601 522055	среднее профессиональное	9466
Сократ	Пономарева	\N	+7 (758) 504-71-13	7206 961248	среднее	9467
Тарас	Копылова	Анатольевна	86497086604	6191 692635	\N	9468
Анастасия	Селезнев	Тарасович	+7 263 143 8973	5282 306853	высшее	9469
Аполлон	Афанасьева	\N	8 078 287 7495	7155 822436	неоконченное высшее	9470
Леонид	Тарасова	Харлампьевич	+7 517 345 39 32	4875 969472	высшее	9471
Арефий	Емельянов	Дорофеевич	+74222896312	3358 277250	неоконченное высшее	9472
Родион	Тетерина	Анатольевич	+7 (177) 685-7389	6596 446759	\N	9473
Олег	Соболев	\N	8 244 225 31 30	5575 331195	высшее	9474
Александра	Куликов	Матвеевна	+7 (240) 252-9215	9752 463138	высшее	9475
Митофан	Киселев	\N	80119822097	9497 748936	\N	9476
Евграф	Харитонов	\N	+7 940 848 79 78	4673 611223	\N	9477
Пантелеймон	Макарова	\N	85424337981	2615 184408	среднее профессиональное	9478
Никифор	Мясников	Давыдович	85064110781	9557 563722	среднее профессиональное	9479
Матвей	Максимов	Александровна	+7 (392) 288-75-43	5798 738052	среднее профессиональное	9480
Вера	Дементьева	\N	8 824 867 3642	9695 577097	высшее	9481
Милен	Якушев	Адамович	+7 042 455 4184	6433 211940	\N	9482
Нестор	Никонов	\N	8 082 507 07 98	8136 353357	\N	9483
Платон	Петров	\N	+7 (841) 284-32-45	6014 532771	среднее профессиональное	9484
Федосий	Лапина	Вячеславович	+70858599141	8247 316636	среднее	9485
Жанна	Никифорова	\N	+7 229 191 9994	7611 187695	среднее профессиональное	9486
Ким	Игнатов	\N	8 (417) 261-91-14	5520 634794	высшее	9487
Ефрем	Осипов	Елизарович	8 (750) 668-37-28	3029 102668	среднее профессиональное	9488
Андрон	Журавлева	\N	84297135083	1675 206798	\N	9489
Валерий	Петров	\N	82130577374	8910 354570	среднее профессиональное	9490
Евграф	Лихачев	\N	+7 028 053 90 81	6481 810657	высшее	9491
Раиса	Волкова	\N	8 (539) 900-8398	2438 317719	высшее	9492
Полина	Мамонтов	\N	+74564773807	7553 432503	неоконченное высшее	9493
Эмилия	Назаров	\N	8 (275) 242-61-38	4983 664456	среднее профессиональное	9494
Герман	Титова	\N	8 149 084 79 24	1162 192675	среднее	9495
Аким	Артемьев	Яковлевна	+7 (777) 914-3532	3870 967018	\N	9496
Феликс	Белоусова	Мироновна	84529756137	4147 684139	среднее профессиональное	9497
Владлен	Лыткина	Жанович	+78838954893	4719 101132	\N	9498
Яков	Фомина	Афанасьевич	81195833503	1967 888719	\N	9499
Леон	Константинова	Брониславович	+7 438 165 19 94	3003 668933	неоконченное высшее	9500
Фаина	Кудряшова	\N	+7 (473) 917-1502	9007 420427	среднее профессиональное	9501
Август	Князева	Игнатьевич	8 599 415 8756	6870 268719	неоконченное высшее	9502
Вероника	Кириллова	Феликсовна	+7 (635) 992-3819	2969 897113	неоконченное высшее	9503
Агап	Гусев	Кирилловна	+7 400 556 39 40	2140 741439	\N	9504
Георгий	Туров	Антипович	+7 851 046 42 06	6643 392394	\N	9505
Роман	Симонов	\N	+76507182189	6769 858369	среднее профессиональное	9506
Иван	Кудряшова	Эдгарович	8 (208) 684-6514	5476 956419	\N	9507
Галина	Князева	Игнатович	8 181 930 18 22	4339 436810	\N	9508
Федосий	Бирюков	Германович	8 802 407 0794	4766 807401	среднее профессиональное	9509
Елена	Матвеев	Оскаровна	+7 493 676 74 94	4413 374686	среднее профессиональное	9510
Феоктист	Никитин	\N	8 475 551 18 47	8137 321991	высшее	9511
Ярослав	Дроздова	\N	8 (022) 583-95-62	3523 728214	неоконченное высшее	9512
Фрол	Елисеев	\N	+7 760 741 52 18	3200 601779	среднее профессиональное	9513
Эмилия	Денисов	\N	+7 727 626 3745	3474 179718	среднее	9514
Аверьян	Семенова	\N	+7 142 702 1761	1749 542733	\N	9515
Мокей	Казакова	Терентьевич	+70355955655	9089 397877	\N	9516
Валентина	Молчанов	Владиленович	+7 (244) 335-8752	7863 252298	среднее профессиональное	9517
Савватий	Кудрявцева	Владиславовна	88617555267	6121 576906	среднее профессиональное	9518
Ратибор	Молчанова	\N	8 957 870 4179	6350 858877	\N	9519
Антип	Цветкова	Тимофеевна	8 799 814 84 51	9059 640504	высшее	9520
Гурий	Кузнецова	\N	8 (018) 696-17-21	7776 890454	\N	9521
Никанор	Новиков	Филипповна	+7 (729) 995-3975	9118 239772	\N	9522
Милен	Третьякова	Ефимьевич	8 026 046 4906	8878 623412	среднее профессиональное	9523
Мокей	Никонова	Натановна	+7 078 405 6420	1949 997845	среднее	9524
Филимон	Дроздова	Харитоновна	8 113 995 3143	4274 404493	высшее	9525
Ефим	Колесникова	\N	+77423377800	2881 194037	высшее	9526
Фаина	Якушева	\N	85626706979	6199 972403	среднее	9527
Рюрик	Никифорова	\N	88530149864	6179 343750	среднее	9528
Ангелина	Ефремова	\N	+7 (803) 582-1535	7467 474451	среднее	9529
Мефодий	Борисов	\N	+77244661165	6874 279174	\N	9530
Будимир	Захарова	\N	+7 532 982 9385	6133 270352	\N	9531
Елена	Бобылева	\N	84403647896	9828 703225	\N	9532
Анастасия	Белова	\N	+7 529 279 5744	8557 306919	\N	9533
Синклитикия	Николаев	Артемовна	80985864745	6664 106891	среднее профессиональное	9534
Вероника	Некрасов	Ивановна	8 (958) 763-99-05	1693 900001	\N	9535
Мир	Наумова	\N	8 (913) 693-0754	3709 993602	высшее	9536
Светлана	Уваров	Юлианович	8 (657) 482-75-80	4143 893045	среднее профессиональное	9537
Онуфрий	Дьячков	Измаилович	+7 711 841 79 08	1313 671936	неоконченное высшее	9538
Аникита	Доронин	Изотович	+7 (551) 664-7092	1591 145977	неоконченное высшее	9539
Чеслав	Борисов	Аркадьевна	8 219 085 25 35	8305 631599	среднее	9540
Евпраксия	Чернов	\N	+7 (826) 323-81-44	4658 530806	высшее	9541
Алексей	Харитонов	\N	+7 (021) 883-4337	1138 480266	среднее	9542
Вера	Дорофеев	Вадимовна	+7 (765) 271-9022	4488 816040	среднее	9543
Владлен	Киселев	\N	+7 (914) 363-3691	8539 697223	среднее	9544
Азарий	Шашков	\N	+7 827 651 6267	6655 981419	\N	9545
Владилен	Шарова	Иосифович	+7 (842) 094-8618	5185 541750	\N	9546
Вероника	Анисимова	Якубович	+7 (355) 194-4150	2091 274816	неоконченное высшее	9547
Ерофей	Белоусов	\N	84630612195	2682 414930	неоконченное высшее	9548
Осип	Аксенова	\N	8 (552) 991-8096	2559 733535	среднее	9549
Кондрат	Наумова	\N	8 784 423 9940	4302 934852	\N	9550
Казимир	Чернова	Евстигнеевич	+7 (804) 970-4990	1174 956580	среднее профессиональное	9551
Павел	Антонова	Зиновьевич	85268168837	7905 187397	\N	9552
Мечислав	Шилов	\N	+7 198 885 64 30	8742 537754	\N	9553
Елисей	Юдин	Гурьевич	+7 (173) 095-53-57	8312 701807	среднее профессиональное	9554
Варфоломей	Уварова	\N	+7 424 533 4155	7137 824212	\N	9555
Автоном	Терентьева	\N	8 (331) 777-3242	8097 822201	неоконченное высшее	9556
Аникита	Поляков	Николаевна	8 (087) 683-87-03	8670 582322	неоконченное высшее	9557
Ираклий	Матвеева	\N	+7 (477) 934-3283	8938 555398	среднее профессиональное	9558
Леонид	Быков	Ефремович	+7 (138) 585-80-80	3768 617353	высшее	9559
Фирс	Александрова	Олеговна	+73710457550	6568 396138	\N	9560
Анна	Селезнева	Владиленович	+7 (055) 317-06-04	3811 863136	\N	9561
Валентин	Гордеева	\N	8 498 524 65 89	4811 774440	среднее	9562
Ираида	Ефимов	Валентиновна	86213188962	6130 793328	высшее	9563
Феоктист	Силин	\N	+7 973 519 56 78	1443 514544	\N	9564
Евстигней	Щукина	Анатольевна	8 (519) 314-9884	5423 153372	\N	9565
Серафим	Бобылев	Афанасьевич	87835797117	4550 702559	неоконченное высшее	9566
Назар	Селиверстов	\N	8 241 510 63 98	6481 145514	среднее профессиональное	9567
Мариан	Дмитриев	Елисеевич	8 365 675 73 11	3870 357982	среднее	9568
Милован	Федосеев	Виленович	8 (635) 249-4010	2131 403733	высшее	9569
Юлия	Беляева	Ефстафьевич	+7 (005) 332-40-10	6425 126296	\N	9570
Харитон	Гурьева	\N	8 (807) 751-42-15	8117 219566	высшее	9571
Якуб	Герасимов	Еремеевич	8 (135) 209-29-44	4595 527970	неоконченное высшее	9572
Октябрина	Виноградова	Харлампьевич	+7 (411) 658-5695	1325 616682	среднее профессиональное	9573
Агап	Одинцов	Захарьевич	+7 212 344 72 32	8098 385049	\N	9574
Елизар	Суханова	Кузьминична	8 061 403 8405	7590 726187	высшее	9575
Ладимир	Владимиров	Тимуровна	8 206 550 37 66	7895 489258	высшее	9576
Кирилл	Белякова	Исидорович	+7 891 936 8341	8485 253061	среднее	9577
Евгения	Мельников	Мироновна	+7 549 607 71 45	5392 328178	\N	9578
Акулина	Кириллов	\N	+7 (195) 204-9101	6436 585410	среднее профессиональное	9579
Ярополк	Сергеев	\N	8 132 346 29 17	2245 592795	среднее	9580
Пантелеймон	Мамонтова	\N	+7 998 731 97 79	9321 588743	среднее профессиональное	9581
Трофим	Овчинникова	Михайловна	88244718478	5600 256064	среднее	9582
Филипп	Яковлева	Фролович	8 (096) 504-6317	9026 884226	среднее	9583
Радислав	Гущина	\N	+7 899 058 93 52	8742 615546	высшее	9584
Дорофей	Волков	\N	+7 816 707 51 28	6382 213124	высшее	9585
Юлиан	Михеев	\N	81695222822	5447 939169	высшее	9586
Варлаам	Колесников	Ярославович	+70225590172	6695 786367	неоконченное высшее	9587
Лукия	Прохорова	\N	+7 619 887 35 67	6540 909889	среднее	9588
Иван	Кузнецов	Авдеевич	+79980788849	1796 174697	\N	9589
Лавр	Васильева	\N	+7 (648) 545-9649	4649 339600	\N	9590
Адам	Ильина	\N	+7 566 591 95 02	8434 509797	\N	9591
Гордей	Егорова	\N	89975579008	2270 762880	\N	9592
Антонина	Аксенов	Филатович	8 110 497 95 39	1885 754741	среднее	9593
Евсей	Зайцева	\N	8 385 948 9548	5586 658282	среднее	9594
Парфен	Ефимов	Рубеновна	8 (850) 835-57-46	4318 982429	среднее профессиональное	9595
Евграф	Мамонтова	Федосеевич	+7 663 376 12 78	8103 573721	среднее профессиональное	9596
Кирилл	Морозов	Федосеевич	+7 795 003 0532	3930 726357	среднее профессиональное	9597
Аггей	Крюков	\N	80201617506	8724 532349	высшее	9598
Силантий	Федотов	\N	+73816031744	7878 577427	среднее	9599
Артемий	Дементьев	Филиппович	8 010 604 3282	2715 740154	\N	9600
Лора	Ларионова	Кузьминична	+7 (655) 758-2565	3935 511535	среднее профессиональное	9601
Януарий	Комиссарова	\N	+78642690895	5918 374453	среднее	9602
Боян	Жданов	\N	8 (379) 634-4370	4781 846671	среднее	9603
Светозар	Петухов	Юльевич	+7 575 516 56 15	9289 332173	среднее профессиональное	9604
Галина	Кудрявцев	\N	8 568 442 16 04	8379 127650	высшее	9605
Казимир	Мишина	\N	+7 (697) 261-36-46	7497 857800	\N	9606
Егор	Новикова	\N	+7 (581) 572-93-56	3203 480659	\N	9607
Лукьян	Голубева	Жанович	+78682966567	3122 130434	высшее	9608
Радислав	Зиновьева	\N	8 629 294 0932	4073 598983	среднее профессиональное	9609
Виссарион	Тихонова	Кузьминична	8 (753) 220-11-32	1597 810946	высшее	9610
Прокл	Доронина	Федосьевич	+79743197906	2606 645639	среднее	9611
Елизавета	Симонова	Харитонович	8 (755) 424-52-84	1380 459876	неоконченное высшее	9612
Велимир	Белоусова	\N	+7 576 427 8962	8753 912909	среднее	9613
Ян	Цветков	Викторович	+7 204 482 55 07	2841 790188	\N	9614
Клавдия	Тихонов	Федосеевич	+7 900 129 36 74	7760 938465	высшее	9615
Всеволод	Павлов	\N	8 (015) 604-4815	4935 182868	\N	9616
Матвей	Новиков	Изотович	8 (729) 728-0288	8396 536076	среднее профессиональное	9617
Кондрат	Селиверстов	\N	8 373 669 65 22	4046 836368	\N	9618
Семен	Русаков	Вадимовна	88656951590	1295 107284	среднее	9619
Кондратий	Самойлова	Феофанович	+7 (869) 150-6679	6451 869600	среднее	9620
Марина	Лыткина	Тимурович	8 (448) 094-4079	5879 892947	высшее	9621
Осип	Королева	\N	80136741550	4106 982745	неоконченное высшее	9622
Сила	Русакова	Игнатьевич	+7 528 634 74 76	3932 219055	неоконченное высшее	9623
Максим	Попова	\N	+76758153417	8347 272060	высшее	9624
Афиноген	Самойлова	Еремеевич	87875760080	5260 991663	высшее	9625
Фадей	Никонов	\N	8 412 351 77 10	3915 868012	среднее	9626
Варвара	Селезнева	Фролович	8 917 789 2729	4468 366950	среднее профессиональное	9627
Зосима	Громова	Алексеевич	83047236806	9177 533333	\N	9628
Агата	Киселев	\N	8 (060) 714-40-01	4233 460517	среднее профессиональное	9629
Синклитикия	Семенов	Зиновьевич	8 059 487 7552	8226 386878	\N	9630
Эмиль	Сорокин	\N	8 314 241 6766	6893 137697	\N	9631
Алина	Бобылева	Робертовна	+72295832798	5746 183474	\N	9632
Гаврила	Игнатьев	Харлампьевич	+7 (008) 168-33-26	3047 804613	высшее	9633
Венедикт	Самойлов	\N	+7 (332) 559-3727	7372 760038	среднее	9634
Гремислав	Шашков	\N	8 (523) 695-8669	6077 287984	среднее профессиональное	9635
Ираклий	Назаров	\N	81765645284	2730 318117	\N	9636
Руслан	Орехова	\N	+7 (526) 233-16-08	5956 572960	\N	9637
Святослав	Симонов	Ефремович	+7 (972) 352-99-14	8995 983835	высшее	9638
Амвросий	Орлова	Жанович	+7 389 293 0709	5324 164118	неоконченное высшее	9639
Александр	Маслов	\N	8 452 435 08 69	6950 879845	неоконченное высшее	9640
Евгений	Елисеева	Демьянович	+7 696 463 0871	1959 975217	среднее	9641
Тимур	Куликова	\N	8 946 274 0207	7868 138307	высшее	9642
Станислав	Федотова	Викторович	+70934771439	3533 440273	высшее	9643
Остромир	Михеева	\N	+7 736 535 65 76	9621 387514	\N	9644
Вячеслав	Назарова	Авдеевич	8 (912) 380-62-19	5494 669809	высшее	9645
Фока	Власова	\N	83585500158	1977 613674	высшее	9646
Агафон	Игнатов	Егорович	8 (020) 119-51-03	5201 423030	высшее	9647
Мартьян	Овчинников	\N	+71675275799	1126 292782	среднее	9648
Клавдия	Сазонов	\N	+7 (631) 880-30-93	6164 193892	\N	9649
Митофан	Коновалова	\N	+7 (239) 698-8257	2148 967082	среднее	9650
Иларион	Тетерина	Изотович	+7 (440) 301-9735	7915 851663	среднее профессиональное	9651
Зиновий	Корнилова	Натановна	8 996 780 6809	5273 932143	среднее	9652
Творимир	Наумова	Натановна	+7 (594) 522-91-68	8622 186987	неоконченное высшее	9653
Эмиль	Давыдов	\N	+7 732 524 38 45	4705 744125	\N	9654
Бажен	Селезнев	\N	+7 676 990 3904	8387 824773	среднее	9655
Герман	Мамонтова	\N	88229342677	1827 340734	высшее	9656
Евдокия	Владимиров	\N	8 (034) 900-59-26	6943 572478	среднее профессиональное	9657
Андроник	Шилова	\N	8 484 826 1396	2222 154057	высшее	9658
Адам	Фокина	\N	8 (026) 873-02-11	8784 597951	высшее	9659
Глафира	Блохина	Сергеевна	8 821 210 0712	6835 961927	среднее профессиональное	9660
Олег	Самсонов	\N	+7 612 218 7405	3111 500527	среднее	9661
Селиверст	Лапин	Тарасович	8 (826) 134-90-63	6202 155614	высшее	9662
Радован	Шестакова	\N	+7 561 517 5734	6116 686683	неоконченное высшее	9663
Феофан	Власов	Всеволодович	+76338495337	9572 462506	среднее	9664
Евстафий	Матвеева	\N	8 (639) 041-1519	5781 394910	неоконченное высшее	9665
Агафон	Давыдов	\N	8 686 037 9336	3788 317614	среднее профессиональное	9666
Радован	Елисеева	Вячеславович	8 995 766 59 78	4328 440150	неоконченное высшее	9667
Алла	Жданов	\N	+7 858 892 41 10	5323 552971	\N	9668
Мирон	Архипова	\N	8 (586) 597-97-79	9903 548318	среднее профессиональное	9669
Савелий	Ширяев	Демидович	+7 (880) 778-80-48	3608 845583	среднее	9670
Викторин	Артемьев	\N	+7 (363) 663-7616	1331 676929	среднее	9671
Наталья	Щукин	\N	8 234 311 1924	7768 364271	\N	9672
Мина	Громова	\N	8 138 219 8618	6323 212382	неоконченное высшее	9673
Константин	Молчанова	\N	8 (838) 152-58-32	3534 963164	высшее	9674
Аникита	Вишняков	\N	8 (833) 921-2771	3199 982401	среднее	9675
Феликс	Агафонов	Марсович	+7 (524) 089-6368	5619 577600	высшее	9676
Марина	Белозерова	\N	8 (100) 274-4825	6572 380673	высшее	9677
Светлана	Селезнева	Харлампьевич	+7 (684) 826-13-01	5319 437553	неоконченное высшее	9678
Кузьма	Трофимов	\N	8 (885) 697-08-32	2827 441766	высшее	9679
Елена	Николаева	Феликсович	+7 (875) 880-1192	3107 639850	среднее профессиональное	9680
Лонгин	Селезнев	Михайловна	+7 (090) 505-7130	7797 747449	высшее	9681
Творимир	Герасимова	Харитонович	8 291 998 8338	5480 708268	\N	9682
Феоктист	Мельников	Натановна	8 875 983 7248	3459 407090	высшее	9683
Лонгин	Носов	Марсович	8 (451) 994-2235	4985 987907	неоконченное высшее	9684
Екатерина	Ермаков	Трофимович	8 (183) 905-0921	3262 403213	среднее	9685
Нонна	Яковлев	Ануфриевич	8 (079) 734-3649	3165 163105	высшее	9686
Всеслав	Гордеева	Болеславовна	+77283228598	7118 401138	среднее	9687
Наркис	Тарасов	\N	8 (731) 900-5117	6277 561106	среднее профессиональное	9688
Самсон	Степанова	Игнатович	+7 366 924 47 00	4133 766026	неоконченное высшее	9689
Гордей	Силина	\N	+7 (089) 147-36-79	6477 977804	среднее профессиональное	9690
Елисей	Хохлов	\N	8 (228) 891-61-94	9072 946997	неоконченное высшее	9691
Мартьян	Быкова	\N	8 (014) 348-3828	5916 992382	высшее	9692
Василиса	Воронцов	\N	86589951503	1362 835039	среднее	9693
Панфил	Суворова	Мироновна	8 504 564 35 85	2946 770776	среднее профессиональное	9694
Виталий	Князев	Фадеевич	+7 (935) 043-79-62	3665 551199	высшее	9695
Марина	Денисова	Владимировна	8 020 842 7907	6046 897757	\N	9696
Нина	Назарова	Эдуардовна	8 (847) 111-53-29	3704 530716	\N	9697
Пантелеймон	Фролова	Леоновна	8 029 692 8491	3673 816839	среднее профессиональное	9698
Фома	Рыбакова	Тимурович	8 (201) 061-3558	7476 951376	\N	9699
Всеслав	Гурьева	Натановна	83551435377	1865 387776	высшее	9700
Трофим	Беляева	\N	8 (463) 758-81-94	6218 651118	среднее профессиональное	9701
Матвей	Александрова	\N	8 995 981 4346	3522 650592	среднее профессиональное	9702
Милица	Орлова	Ефремович	+7 (693) 400-1929	1253 729534	\N	9703
Трифон	Соколов	\N	+7 (298) 186-1438	3406 736328	высшее	9704
Дементий	Рыбаков	Бенедиктович	8 (685) 776-4037	1334 977799	среднее профессиональное	9705
Вячеслав	Соколова	\N	+71968150416	4759 285949	неоконченное высшее	9706
Амвросий	Фомин	Филимонович	8 212 989 7807	4172 899847	среднее профессиональное	9707
Роман	Якушев	\N	83926722101	4816 925463	неоконченное высшее	9708
Амос	Князев	\N	+7 (799) 770-53-44	7506 183131	среднее	9709
Лев	Емельянов	Вячеславович	81938354998	8007 489635	\N	9710
Эмилия	Агафонова	Феоктистович	+7 (232) 183-3906	3764 661847	высшее	9711
Леонид	Мясникова	\N	+7 307 584 7672	6596 982992	среднее профессиональное	9712
Поликарп	Лукин	\N	81241802579	2736 512929	среднее профессиональное	9713
Велимир	Белоусов	Артемьевич	+7 (854) 578-14-72	4791 274347	высшее	9714
Регина	Поляков	\N	84631802670	5677 892394	высшее	9715
Нинель	Панфилова	Юльевич	88456727706	4126 998803	высшее	9716
Адриан	Фролов	Руслановна	8 898 989 4097	4320 514104	среднее профессиональное	9717
Ярослав	Комиссарова	\N	8 834 562 0752	8058 368507	\N	9718
Агап	Федосеев	\N	+7 108 381 0916	2410 628737	среднее	9719
Прасковья	Суханова	Захарьевич	+7 (438) 259-8049	6347 627529	среднее	9720
Нонна	Мамонтов	Анисимович	85448284190	6086 518976	среднее профессиональное	9721
Венедикт	Пахомова	\N	+7 628 732 1707	6313 528600	среднее профессиональное	9722
Ерофей	Григорьева	\N	8 197 722 1054	1380 606546	\N	9723
Дмитрий	Семенова	\N	+7 886 207 0911	3333 384892	среднее	9724
Милан	Федорова	Афанасьевич	+7 909 660 8895	3429 911394	\N	9725
Устин	Петухов	Кузьминична	+7 (515) 021-52-91	6984 912170	\N	9726
Петр	Новикова	\N	+7 (051) 844-08-87	8328 226600	высшее	9727
Андроник	Буров	\N	+7 836 359 3883	8070 470897	среднее	9728
Сила	Игнатов	Афанасьевна	+79886150442	2185 724177	среднее профессиональное	9729
Борис	Кононова	Захаровна	+7 826 081 63 32	5668 820826	среднее профессиональное	9730
Эрнст	Хохлов	\N	+7 667 163 36 03	4526 685810	неоконченное высшее	9731
Агафья	Тихонова	Семеновна	+7 864 974 5480	4492 514581	неоконченное высшее	9732
Прасковья	Зыкова	\N	81245326552	1992 990915	высшее	9733
Алла	Юдина	\N	+7 (263) 470-08-42	9953 773125	\N	9734
Елизар	Большаков	\N	8 024 406 0537	3722 184550	среднее	9735
Нинель	Дементьев	Дмитриевич	8 459 737 4838	6109 727421	высшее	9736
Елизар	Муравьев	\N	+7 425 754 1215	7954 682740	высшее	9737
Самсон	Крюков	\N	+7 645 608 60 25	3310 170942	\N	9738
Георгий	Мишин	\N	+7 (183) 362-7676	1449 392387	среднее	9739
Ипполит	Некрасова	Аксёнович	88457082347	4238 617003	\N	9740
Юрий	Молчанов	Власович	80540577957	5971 603935	неоконченное высшее	9741
Ермолай	Блохина	\N	8 (783) 760-52-38	9178 503089	среднее профессиональное	9742
Никанор	Юдин	\N	+7 776 942 5169	8799 570295	неоконченное высшее	9743
Матвей	Медведева	Брониславович	+7 087 287 70 90	6348 586899	среднее	9744
Федот	Гришин	Владленович	+7 712 737 9673	5001 461806	среднее	9745
Ефим	Титов	\N	+7 035 603 05 52	7326 847087	среднее	9746
Бронислав	Дементьев	\N	8 793 555 71 27	7904 715860	\N	9747
Людмила	Фокин	Николаевна	+71328207998	2179 697731	\N	9748
Арсений	Блинов	Трифонович	8 699 284 5816	2306 973018	среднее	9749
Парамон	Яковлева	Феликсович	8 245 405 72 10	9938 490358	среднее	9750
Валерий	Субботина	\N	+7 141 762 6078	7607 695134	среднее профессиональное	9751
Ксения	Беляев	\N	8 (767) 036-9135	5554 345823	неоконченное высшее	9752
Евдоким	Антонов	\N	8 (112) 049-32-94	1264 211343	среднее профессиональное	9753
Никон	Гущина	Ильич	+77975337214	5100 849169	\N	9754
Александр	Дроздова	Федотович	8 972 478 28 18	7731 246760	\N	9755
Владимир	Миронов	Семеновна	+7 414 161 0178	8733 455454	\N	9756
Тимофей	Дмитриев	\N	+7 (586) 493-59-81	7342 621989	среднее профессиональное	9757
Милий	Мишин	\N	8 (527) 022-32-13	2397 415342	\N	9758
Евгения	Трофимова	Евсеевич	8 (183) 288-21-22	3416 331515	среднее профессиональное	9759
Лидия	Быкова	\N	8 (007) 197-7979	6058 545557	неоконченное высшее	9760
Доброслав	Вишнякова	\N	8 (054) 244-15-71	5144 771306	среднее	9761
Остромир	Маркова	Елизарович	+7 (117) 490-83-86	7114 319720	среднее профессиональное	9762
Ия	Силин	\N	+7 (088) 187-84-47	4087 764881	высшее	9763
Тит	Савина	\N	+7 (929) 592-49-46	6071 874681	неоконченное высшее	9764
Тамара	Гущина	Тихонович	8 259 137 6675	8467 788037	\N	9765
Регина	Фокин	Викторовна	+7 (169) 900-8444	9852 294938	среднее профессиональное	9766
Гедеон	Вишнякова	\N	+7 (569) 839-0436	7975 500810	неоконченное высшее	9767
Фёкла	Куликова	\N	8 464 407 0928	3605 699530	неоконченное высшее	9768
Яков	Никонов	Ивановна	+7 (249) 635-89-69	1994 274779	неоконченное высшее	9769
Мирослав	Соболев	\N	8 (572) 419-2607	4651 616233	среднее профессиональное	9770
Бронислав	Лаврентьева	\N	+7 (877) 448-3702	3268 120506	неоконченное высшее	9771
Роман	Сазонова	Григорьевна	+77237277273	5713 441586	среднее	9772
Измаил	Петухов	Демьянович	89072905122	3476 688975	неоконченное высшее	9773
Борислав	Белозеров	Руслановна	+7 (695) 269-17-22	3187 320723	среднее	9774
Иннокентий	Фомичев	\N	8 143 173 9880	9760 777455	высшее	9775
Аггей	Красильников	\N	8 475 784 44 15	9189 270459	среднее	9776
Сила	Кузнецов	Анисимович	8 (558) 310-72-08	9584 988277	\N	9777
Глафира	Никифоров	Семеновна	+7 (952) 113-03-66	7580 907919	высшее	9778
Архип	Бобылева	\N	8 033 330 91 77	2159 647175	\N	9779
Лазарь	Гущин	Богдановна	+7 473 802 7682	9457 716295	высшее	9780
Евфросиния	Мамонтов	Эдуардович	+76798623329	8040 881875	среднее профессиональное	9781
Олимпий	Субботин	Елисеевич	+73104463144	4489 371563	неоконченное высшее	9782
Нестор	Волкова	\N	+7 (872) 970-9073	8342 128912	среднее	9783
Юлий	Зайцев	\N	87789088283	1685 707867	среднее профессиональное	9784
Сила	Тетерин	\N	+7 329 524 1459	7450 640795	неоконченное высшее	9785
Эмилия	Панов	\N	8 084 657 9492	6083 622356	высшее	9786
Модест	Стрелков	Гордеевич	+7 (225) 635-2658	6020 569678	среднее	9787
Ольга	Александрова	\N	+7 623 399 75 14	5536 319381	среднее	9788
Глафира	Герасимов	Эльдаровна	+7 (045) 819-19-95	3931 425092	неоконченное высшее	9789
Пров	Шестакова	Аверьянович	83908024831	3784 273559	неоконченное высшее	9790
Эммануил	Дмитриева	\N	+7 (173) 241-0009	3978 443175	высшее	9791
Ксения	Князева	Игнатьевич	+76149571591	5265 855509	неоконченное высшее	9792
Христофор	Колобова	\N	+7 (060) 900-59-61	2004 264758	высшее	9793
Ульян	Макаров	\N	+7 058 228 4155	7694 225963	высшее	9794
Конон	Быкова	\N	+72978755710	9062 866037	среднее профессиональное	9795
Болеслав	Стрелков	Юльевич	8 168 814 70 66	8798 261134	\N	9796
Игорь	Степанова	Тимурович	8 180 438 3795	3291 305026	высшее	9797
Авксентий	Поляков	\N	8 381 139 73 46	8165 522056	неоконченное высшее	9798
Анжелика	Гаврилова	Валерьянович	+7 (767) 080-16-68	2563 534277	\N	9799
Мартын	Дьячкова	Тарасовна	8 (139) 265-4166	7950 167056	среднее	9800
Доброслав	Хохлов	\N	8 (097) 755-3477	8065 905902	среднее профессиональное	9801
Елисей	Кулагина	Андреевна	8 (347) 509-6925	5623 980602	среднее	9802
Исидор	Сысоева	Фадеевич	+7 (312) 726-7406	4255 787867	среднее профессиональное	9803
Варфоломей	Турова	\N	+7 297 910 71 49	7797 763754	\N	9804
Григорий	Туров	\N	+7 532 210 7343	5178 946430	среднее	9805
Селиверст	Бобров	Власович	8 592 300 2397	1384 286888	\N	9806
Лучезар	Беляев	Фёдорович	+7 435 749 1604	2544 922565	\N	9807
Харитон	Турова	\N	8 692 723 3716	1048 344617	высшее	9808
Акулина	Дорофеева	\N	+71932392589	8982 138958	среднее профессиональное	9809
Михаил	Кудряшов	\N	81708016179	5994 179044	\N	9810
Наум	Игнатов	\N	+7 (122) 552-3131	3420 457752	среднее профессиональное	9811
Пантелеймон	Ширяев	\N	+7 (644) 147-0209	8885 743891	неоконченное высшее	9812
Игорь	Киселев	\N	+79017561629	7142 414968	\N	9813
Тамара	Степанов	Петровна	8 (714) 046-33-85	9785 481271	высшее	9814
Харитон	Турова	\N	+7 (448) 080-47-23	2992 735031	среднее профессиональное	9815
Гостомысл	Маслова	Петровна	8 (718) 179-37-39	9270 191005	среднее	9816
Азарий	Дементьев	\N	86832367779	7049 678357	среднее профессиональное	9817
Мечислав	Абрамова	\N	+77976445638	1492 193980	среднее	9818
Радован	Устинова	\N	8 020 584 4361	5027 367765	неоконченное высшее	9819
Данила	Кондратьева	\N	8 (695) 155-7286	9623 159091	среднее профессиональное	9820
Сигизмунд	Фомичев	\N	+73923134517	7571 719061	неоконченное высшее	9821
Алевтина	Галкин	\N	+7 (002) 718-1431	6178 130311	\N	9822
Клавдий	Сысоева	\N	+7 796 323 8681	3501 532696	неоконченное высшее	9823
Вера	Комарова	Фролович	8 512 074 98 80	4358 858117	среднее профессиональное	9824
Тит	Архипова	Васильевна	8 607 231 5848	3544 311873	среднее	9825
Сила	Соловьева	Эльдаровна	+7 136 551 1837	6616 751731	\N	9826
Ювеналий	Чернов	Владиславович	8 682 108 6409	3945 366695	высшее	9827
Ладислав	Ефремов	\N	8 621 372 3917	9611 858114	\N	9828
Кир	Александров	\N	+7 (237) 744-4803	9997 681536	\N	9829
Пахом	Потапова	Аркадьевна	82878232969	8004 851370	неоконченное высшее	9830
Сила	Потапов	Богданович	+7 (769) 364-9941	8976 740811	среднее профессиональное	9831
Элеонора	Овчинников	Глебович	+77047138284	7267 695514	неоконченное высшее	9832
Пелагея	Владимирова	\N	+79670760407	9497 483117	неоконченное высшее	9833
Софон	Ковалев	Ефимьевич	+7 528 348 1964	7459 445561	\N	9834
Севастьян	Панфилов	\N	8 (399) 880-6297	6860 465802	среднее	9835
Евграф	Комарова	Станиславовна	+7 218 035 2382	4805 199947	высшее	9836
Феофан	Мартынов	\N	8 296 286 84 83	4457 836095	высшее	9837
Кир	Лазарев	Егорович	+72712337223	8025 789309	высшее	9838
Тимофей	Сысоева	Кузьминична	+7 (154) 037-8273	9155 478077	\N	9839
Ираида	Михеев	Тимофеевна	+7 357 118 8160	9294 432744	высшее	9840
Дарья	Турова	\N	+7 853 041 3956	6279 319949	высшее	9841
Дементий	Трофимов	Тарасовна	86116805935	9253 530304	неоконченное высшее	9842
Борислав	Костин	\N	8 (921) 463-6953	8034 577028	\N	9843
Мирослав	Субботин	\N	8 811 029 3376	2161 597011	неоконченное высшее	9844
Сидор	Лаврентьев	\N	+7 (596) 328-80-04	5442 187595	высшее	9845
Кира	Зуева	Ильясович	8 (587) 119-32-79	2745 250160	\N	9846
Евфросиния	Блохина	\N	81309130895	6468 676318	среднее	9847
Рубен	Юдина	\N	80257581619	6336 415968	среднее профессиональное	9848
Геннадий	Романов	Матвеевна	+7 763 425 12 11	1848 370233	среднее	9849
Святослав	Доронин	Артемовна	8 808 982 95 24	7827 848157	среднее	9850
Ян	Рыбакова	Борисович	+7 255 997 7829	7306 342879	неоконченное высшее	9851
Павел	Суворов	\N	8 (904) 207-65-93	1736 208638	среднее профессиональное	9852
Аким	Шарапов	Николаевна	8 (149) 461-6098	4848 922573	высшее	9853
Викентий	Носков	\N	+73924447140	5519 429594	среднее профессиональное	9854
Селиверст	Дмитриева	\N	+7 (846) 362-63-50	3175 465815	\N	9855
Владилен	Елисеев	Терентьевич	8 890 149 4206	7703 560014	\N	9856
Глафира	Зуева	Власович	+7 351 185 2991	7669 596870	среднее профессиональное	9857
Григорий	Белозеров	\N	86315165055	5826 467072	\N	9858
Платон	Потапов	Бориславович	8 (266) 070-3791	7901 832873	неоконченное высшее	9859
Виталий	Комаров	Вениаминовна	8 919 159 2209	9271 850773	высшее	9860
Степан	Кононова	Дмитриевич	+7 851 547 77 65	5103 142437	среднее профессиональное	9861
Радим	Макаров	Ермилович	8 086 614 2416	1145 406612	среднее	9862
Евдоким	Беспалова	Афанасьевич	+70315228236	6234 997997	среднее	9863
Феврония	Бирюков	Афанасьевна	+79143086077	4783 403969	\N	9864
Макар	Морозов	Ярославович	+75285971633	4590 921323	высшее	9865
Станимир	Осипов	\N	8 977 535 6655	1296 400503	неоконченное высшее	9866
Сильвестр	Ильин	Гавриилович	8 489 017 3078	1432 399492	неоконченное высшее	9867
Федор	Панфилов	\N	85531232671	9948 814421	высшее	9868
Венедикт	Гущин	\N	8 (494) 136-06-76	4790 757834	среднее	9869
Модест	Волков	Бенедиктович	+7 (436) 621-9209	7249 851473	\N	9870
Фотий	Архипов	Павловна	8 (089) 273-0123	9878 291707	неоконченное высшее	9871
Марина	Блинов	\N	+7 009 891 3129	6402 451669	неоконченное высшее	9872
Филарет	Мишина	Анисимович	+7 (888) 814-97-76	3674 558630	высшее	9873
Владислав	Кошелева	Аркадьевна	+7 346 093 3273	3129 285404	среднее	9874
Агафья	Кононова	Валерианович	+7 493 775 8061	6776 625917	среднее профессиональное	9875
Валерьян	Власова	\N	83988362720	2817 123939	\N	9876
Нинель	Белова	Геннадьевна	+7 344 594 6175	1784 495764	высшее	9877
Иванна	Мишина	\N	+77895794155	8642 823609	неоконченное высшее	9878
Эрнест	Дорофеев	\N	+7 002 465 51 69	4768 374149	высшее	9879
Кузьма	Беляева	\N	+7 093 756 21 51	4434 518124	неоконченное высшее	9880
Ювеналий	Емельянов	Васильевна	8 (915) 015-7323	6048 224706	\N	9881
Игнатий	Харитонов	\N	8 047 169 6597	3573 946215	неоконченное высшее	9882
Алексей	Гурьев	Архиповна	8 011 833 2785	7645 496679	среднее профессиональное	9883
Модест	Петухова	Эльдаровна	8 164 458 64 19	7159 637286	неоконченное высшее	9884
Валентина	Данилов	\N	8 480 351 62 46	4690 289951	неоконченное высшее	9885
Михей	Наумова	\N	8 232 317 75 04	2668 530695	\N	9886
Пров	Мельникова	\N	+73906692815	7921 366474	высшее	9887
Фирс	Терентьев	\N	+7 (919) 096-3507	1448 389232	среднее	9888
Лазарь	Калашникова	\N	+70169035917	6717 911004	неоконченное высшее	9889
Фока	Петров	\N	+7 187 256 8609	4852 151316	\N	9890
Владлен	Никонова	Макаровна	+7 206 066 1217	5443 323837	среднее профессиональное	9891
Мир	Копылов	Антоновна	85093766500	4157 799109	\N	9892
Валерия	Носов	Теймуразович	8 166 611 8014	6025 676931	среднее профессиональное	9893
Модест	Гаврилова	Артемовна	+7 718 078 7765	8259 947946	среднее профессиональное	9894
Ратмир	Воронцов	\N	+7 (535) 599-5642	5858 585490	высшее	9895
Тамара	Колобов	\N	81861238016	5557 479769	\N	9896
Доброслав	Веселов	Захарьевич	8 684 423 54 48	4445 915804	высшее	9897
Мокей	Емельянова	Федосеевич	+7 605 350 78 45	8106 847480	среднее профессиональное	9898
Марина	Доронин	\N	8 (990) 500-6543	4528 812831	высшее	9899
Святополк	Королев	\N	8 107 395 0007	9366 711851	неоконченное высшее	9900
Бажен	Веселов	Артёмович	8 (142) 052-62-17	5440 413099	среднее профессиональное	9901
Панкратий	Кошелев	Григорьевна	8 236 819 6545	3772 591311	\N	9902
Авксентий	Галкин	Валерьевич	+7 (145) 247-06-18	5600 763656	высшее	9903
Севастьян	Авдеев	\N	8 (815) 841-38-08	1391 343626	среднее	9904
Гурий	Калинина	Захарьевич	+7 (768) 037-0456	5422 160133	среднее профессиональное	9905
Лукия	Третьяков	\N	8 656 557 34 06	6478 747070	высшее	9906
Софрон	Силина	\N	8 (369) 615-1704	6481 578658	высшее	9907
Изяслав	Исакова	\N	8 240 092 0198	2592 239587	\N	9908
Зиновий	Рябов	Андреевна	8 (375) 390-36-59	4712 741330	среднее	9909
Фаина	Лаврентьев	\N	+77300883225	7879 143407	среднее профессиональное	9910
Харлампий	Фокина	Иосипович	8 (271) 688-7243	1368 428937	неоконченное высшее	9911
Арсений	Брагин	\N	8 (519) 749-04-75	8430 774059	среднее	9912
Ангелина	Тимофеева	\N	80546858447	2803 636826	среднее профессиональное	9913
Якуб	Белоусова	Виленович	+7 (665) 197-9025	9182 990975	неоконченное высшее	9914
Корнил	Кондратьев	\N	+7 (684) 963-7699	7518 166011	неоконченное высшее	9915
Флорентин	Гуляев	\N	+76485523484	7523 488144	неоконченное высшее	9916
Валентина	Исаева	Даниловна	8 998 847 30 89	4065 374946	высшее	9917
Всеслав	Филиппова	Витальевич	89316040117	6104 643837	высшее	9918
Кира	Копылова	Ефстафьевич	+7 (959) 897-04-46	3669 448316	высшее	9919
Виктория	Тетерин	Павловна	+7 (329) 901-51-56	3762 428474	высшее	9920
Максим	Медведев	\N	+7 569 547 18 05	3188 675442	высшее	9921
Лавр	Александрова	Эдуардовна	+7 (942) 329-28-84	1806 166226	среднее	9922
Валентин	Белов	\N	8 618 003 80 31	8870 367965	\N	9923
Галина	Мухин	Геннадьевна	+7 956 860 41 76	9516 431832	\N	9924
Всеволод	Алексеева	Всеволодович	+7 (798) 881-43-46	2774 886703	среднее	9925
Соломон	Шашков	\N	+7 128 393 7932	3440 143610	среднее профессиональное	9926
Светлана	Баранов	\N	8 661 432 5459	2424 601366	неоконченное высшее	9927
Радим	Шарапов	Иосипович	+7 475 854 86 05	1264 270677	высшее	9928
Якуб	Морозов	Всеволодович	84669529295	4904 852369	среднее	9929
Севастьян	Зыкова	Фомич	+71344147896	7509 370157	среднее профессиональное	9930
Агата	Рогова	\N	+7 840 019 3249	5143 377696	\N	9931
Куприян	Филатова	\N	8 044 694 4832	8496 914713	неоконченное высшее	9932
Авксентий	Симонова	Рудольфовна	+7 (514) 167-3129	8703 470926	\N	9933
Аристарх	Селезнева	Давидович	+7 169 235 4316	3520 707940	среднее	9934
Алексей	Максимова	\N	8 055 089 7789	8098 464814	среднее	9935
Спиридон	Одинцова	Феликсовна	+7 (161) 116-08-26	1653 261313	среднее профессиональное	9936
Мария	Брагин	\N	+70487001389	7970 945199	среднее профессиональное	9937
Панкрат	Королева	\N	8 403 055 6146	4279 125945	неоконченное высшее	9938
Трифон	Комиссарова	\N	8 (536) 894-4639	3401 173582	среднее	9939
Оксана	Филатова	\N	80614664019	4272 336757	\N	9940
Петр	Зайцев	Жанович	88848038216	8186 958860	среднее профессиональное	9941
Никифор	Давыдова	\N	+7 209 915 6019	2223 416957	\N	9942
Михаил	Карпов	Владиславовна	8 (845) 002-4687	9722 318658	высшее	9943
Ольга	Коновалов	Богдановна	+73524798569	1137 643219	высшее	9944
Сократ	Королева	\N	8 (518) 346-6743	7069 409421	высшее	9945
Пров	Ильин	Архипович	+7 (726) 782-04-37	6223 711146	неоконченное высшее	9946
Ярослав	Дорофеев	Святославовна	+73621253473	2643 970060	высшее	9947
Ираида	Абрамов	\N	+7 (606) 372-7448	4895 373791	\N	9948
Демид	Суханов	Тимурович	+7 236 373 78 68	5868 754744	неоконченное высшее	9949
Фотий	Казаков	\N	+7 (459) 490-93-44	5562 332728	среднее	9950
Ираклий	Семенова	\N	+7 038 684 8269	5908 367991	неоконченное высшее	9951
Азарий	Галкина	\N	8 (866) 596-7075	8662 176507	неоконченное высшее	9952
Бажен	Денисова	Денисович	+7 970 532 24 47	8266 811184	среднее	9953
Эраст	Кулагин	\N	8 869 110 8575	8369 219766	неоконченное высшее	9954
Варфоломей	Ершов	Гаврилович	87972484563	7438 813161	среднее профессиональное	9955
Терентий	Зуева	Львовна	+74072920400	4948 968517	высшее	9956
Жанна	Рожкова	Якубович	8 720 850 60 37	8030 776619	среднее профессиональное	9957
Агап	Зиновьева	\N	8 (854) 535-55-05	6515 192375	\N	9958
Алексей	Лихачев	Дмитриевич	8 664 023 39 47	3182 830016	высшее	9959
Вацлав	Михайлова	Августович	+7 778 947 11 81	7747 411227	среднее	9960
Илья	Гусева	Гавриилович	+71738562481	7012 943723	неоконченное высшее	9961
Дементий	Воронова	Зиновьевич	+7 359 163 19 27	9610 358573	неоконченное высшее	9962
Христофор	Копылов	Демьянович	8 607 672 6556	3004 100653	среднее профессиональное	9963
Флорентин	Агафонова	\N	8 (490) 767-3665	8086 143687	среднее профессиональное	9964
Вероника	Шарова	\N	+72695253857	7526 520234	среднее	9965
Август	Смирнова	Станиславовна	+7 (657) 682-25-88	7933 350690	\N	9966
Сила	Самсонов	Семеновна	8 (697) 990-7023	9666 905087	среднее	9967
Бронислав	Ершов	Авдеевич	+7 (250) 513-38-44	7521 679524	среднее профессиональное	9968
Юлиан	Гусев	Ильинична	8 (884) 255-6774	6196 589240	\N	9969
Фока	Ситникова	\N	8 761 939 50 00	3260 944433	среднее	9970
Мокей	Кузьмин	Гавриилович	+7 064 870 25 02	3072 124087	\N	9971
Руслан	Григорьев	\N	8 (775) 911-0287	3927 935967	среднее профессиональное	9972
Владимир	Капустина	Елизарович	+70178988866	3600 967348	среднее	9973
Творимир	Исаков	Натановна	8 876 864 8395	7732 555810	высшее	9974
Соломон	Семенова	Викторовна	+7 (677) 772-4889	4455 612002	среднее	9975
Олимпиада	Веселов	Павловна	8 (313) 799-90-16	8622 373882	\N	9976
Пров	Антонова	\N	8 (703) 649-4161	9883 491015	неоконченное высшее	9977
Лора	Савин	\N	+7 (020) 795-23-89	9800 384579	высшее	9978
Никифор	Степанов	\N	83718422606	9416 625724	среднее	9979
Анисим	Сидоров	\N	+7 987 028 04 96	2505 661030	\N	9980
Наина	Шарова	Игнатьевич	+7 (652) 211-18-60	7216 677974	неоконченное высшее	9981
Кондратий	Логинов	\N	+7 778 595 11 91	3657 211976	среднее	9982
Никодим	Прохоров	\N	8 (510) 896-82-82	9242 713839	неоконченное высшее	9983
Гурий	Константинов	\N	+7 487 873 73 78	8552 797147	\N	9984
Григорий	Самсонов	\N	+79828296794	7652 566294	\N	9985
Валерьян	Калинин	\N	+70117434581	2931 275428	среднее	9986
Юлия	Никитина	\N	+7 917 285 14 03	5312 497416	\N	9987
Афанасий	Лазарева	\N	+72655624935	9852 520430	высшее	9988
Вера	Горбунова	Евгеньевна	8 (116) 499-8453	1276 153391	неоконченное высшее	9989
Мечислав	Егорова	\N	+7 (106) 212-7535	9621 263112	среднее профессиональное	9990
Ювеналий	Сорокин	\N	+70377504991	7619 805142	\N	9991
Оксана	Кулаков	Эдгардович	+7 (522) 573-6977	8738 644258	среднее	9992
Карп	Лебедев	\N	8 209 046 6162	9976 435264	среднее профессиональное	9993
Соломон	Дмитриев	\N	8 719 288 01 02	6236 447443	среднее	9994
Ульяна	Яковлев	\N	+7 (340) 439-4414	6660 957139	среднее профессиональное	9995
Данила	Копылов	Борисовна	8 145 534 9340	5233 523174	высшее	9996
Игнатий	Устинов	Ивановна	82980144006	2804 960107	среднее профессиональное	9997
Сергей	Федорова	Терентьевич	+7 759 657 81 13	5926 387179	высшее	9998
Жанна	Сергеева	Дмитриевич	+7 027 031 7761	8296 871006	высшее	9999
Емельян	Федосеева	Артёмович	+7 160 245 62 61	3786 158003	высшее	10000
Онуфрий	Орлова	\N	8 360 128 6848	6991 940382	\N	10001
Людмила	Суворов	Никифоровна	8 (387) 748-71-11	3723 964286	среднее профессиональное	10002
Панфил	Зыкова	\N	+7 965 336 89 94	8829 509772	\N	10003
Ипат	Егоров	Михайловна	8 (230) 992-28-46	1603 471573	среднее профессиональное	10004
Максимильян	Александрова	\N	87183763447	6550 514264	неоконченное высшее	10005
Исидор	Лаврентьев	\N	+7 972 364 1385	7737 695077	высшее	10006
Каллистрат	Потапова	Ефстафьевич	+77335425438	7141 243644	среднее профессиональное	10007
Лонгин	Давыдова	Адамович	8 (498) 758-85-65	8407 822270	среднее	10008
Рубен	Соболева	Федоровна	8 142 335 19 69	7040 440100	высшее	10009
Аникей	Тарасов	Теймуразович	8 962 716 3643	1717 444091	неоконченное высшее	10010
Сила	Маслов	\N	8 (134) 944-1004	4799 764787	\N	10011
Рюрик	Баранов	Аскольдовна	8 974 516 66 73	7001 424157	среднее профессиональное	10012
Кондрат	Крылова	Владиславовна	+7 974 657 3751	1154 675779	высшее	10013
Всеволод	Калинин	Харитоновна	+7 176 695 00 47	1797 800813	среднее профессиональное	10014
Севастьян	Сорокина	\N	8 466 104 7585	1476 635547	высшее	10015
Дарья	Ефимов	Геннадьевна	8 388 700 50 57	8949 643916	среднее	10016
Агап	Максимов	Максимовна	8 (987) 923-88-12	1049 415317	среднее профессиональное	10017
Силантий	Трофимов	\N	8 (333) 148-47-46	8136 635887	\N	10018
Екатерина	Киселева	Тимуровна	8 (581) 717-7431	7500 441965	среднее	10019
Жанна	Корнилова	Елисеевич	+7 699 388 78 57	7706 329985	\N	10084
Андроник	Герасимова	\N	+7 (184) 527-5672	5661 817518	неоконченное высшее	10020
Серафим	Лихачев	\N	8 321 443 1581	9716 554386	\N	10021
Савелий	Петухов	\N	8 963 721 15 79	3003 129560	среднее	10022
Галина	Дмитриева	Тихонович	+7 (153) 928-91-29	1013 776339	среднее профессиональное	10023
Каллистрат	Филиппова	\N	8 (426) 485-4467	6157 733128	неоконченное высшее	10024
Ермил	Григорьев	\N	+7 (694) 400-6116	7217 301920	высшее	10025
Юлий	Лаврентьев	Яковлевна	+7 (572) 282-1332	3983 339105	среднее	10026
Ратибор	Иванов	\N	+78072131532	4250 547629	высшее	10027
Емельян	Емельянов	\N	+78982852083	4819 521298	высшее	10028
Нестор	Ефремов	Ниловна	8 (579) 078-6683	1168 372994	среднее	10029
Ладислав	Миронов	Аскольдовна	+7 (043) 638-55-11	9113 640763	\N	10030
Эмилия	Овчинников	Трифонович	+7 093 151 3493	8734 436518	\N	10031
Алевтина	Устинов	\N	8 305 749 31 60	6831 543564	\N	10032
Тамара	Андреев	\N	8 (323) 801-47-77	7954 174985	высшее	10033
Эдуард	Зыкова	\N	+7 097 814 44 02	6235 810520	неоконченное высшее	10034
Кондратий	Ефремова	\N	+7 411 006 7079	4264 942306	среднее	10035
Родион	Куликова	\N	+7 625 754 09 11	9183 161084	среднее	10036
Филарет	Жукова	Никифоровна	+7 (832) 661-3526	2685 412177	\N	10037
Изяслав	Горшков	\N	+7 317 437 66 02	6581 197060	среднее	10038
Изот	Селиверстова	\N	83080342655	5472 315969	среднее	10039
Евпраксия	Одинцова	\N	8 (674) 785-1889	6045 850458	среднее профессиональное	10040
Фёкла	Баранов	\N	8 (156) 832-5322	3632 535359	высшее	10041
Фортунат	Авдеева	Ильинична	+78121768212	6567 870661	высшее	10042
Спиридон	Ширяева	Матвеевна	8 (180) 939-79-06	3334 793922	неоконченное высшее	10043
Ладимир	Ковалев	Георгиевич	82772837882	8698 379124	\N	10044
Флорентин	Воронцов	\N	8 433 540 77 62	8898 195282	среднее профессиональное	10045
Изот	Аксенова	\N	8 880 961 91 79	8851 358985	неоконченное высшее	10046
Нонна	Миронова	\N	8 330 255 8009	1024 260776	среднее профессиональное	10047
Юлий	Антонов	\N	+7 (225) 921-99-46	3321 937816	неоконченное высшее	10048
Мирослав	Гаврилова	\N	8 903 273 3444	2119 131695	высшее	10049
Виссарион	Григорьева	\N	8 132 274 49 78	5595 668226	неоконченное высшее	10050
Нонна	Силин	Юрьевна	8 891 684 54 98	2705 176565	\N	10051
Фома	Горшков	Ивановна	8 (154) 297-0296	8273 720318	\N	10052
Пров	Самсонов	\N	+7 818 252 3827	2922 490320	\N	10053
Филипп	Тимофеев	\N	8 066 569 38 46	1110 885249	высшее	10054
Корнил	Лыткин	\N	8 (017) 407-23-42	8592 640084	неоконченное высшее	10055
Ангелина	Горбунова	Дмитриевна	+7 028 690 1412	8581 979239	высшее	10056
Нинель	Горбачева	Гавриилович	8 876 140 2161	6951 922929	среднее профессиональное	10057
Никанор	Гусев	Власович	+7 797 698 8524	5574 787526	среднее профессиональное	10058
Кондрат	Суханова	Ефимовна	8 (264) 770-31-71	8111 508014	среднее	10059
Марк	Колобов	\N	8 535 612 33 23	8040 659434	\N	10060
Эрнест	Осипов	\N	+7 (704) 755-59-44	7460 879662	\N	10061
Артем	Мельникова	\N	8 679 809 89 08	2985 343205	среднее	10062
Наркис	Михеева	Филимонович	+7 (482) 208-3926	5607 249466	\N	10063
Лукьян	Ковалев	\N	+78370779116	7143 705275	среднее профессиональное	10064
Зинаида	Попов	\N	84826435756	4416 556999	среднее	10065
Радим	Уварова	Эдуардовна	+7 (956) 542-62-99	4005 874208	среднее профессиональное	10066
Август	Федорова	\N	8 (079) 574-69-63	1710 157840	неоконченное высшее	10067
Варвара	Горшкова	\N	+7 (068) 720-44-29	5390 418402	высшее	10068
Будимир	Гаврилова	Дмитриевна	+7 (949) 388-26-92	8010 206720	среднее	10069
Сильвестр	Федотов	\N	85731548414	7955 987291	\N	10070
Ермолай	Симонова	Святославовна	+7 579 227 24 09	9760 296991	неоконченное высшее	10071
Натан	Константинов	Эдуардовна	+70147035042	5524 414278	высшее	10072
Валерьян	Селезнева	\N	8 (605) 107-26-13	8506 907714	среднее профессиональное	10073
Юлий	Данилов	Петровна	+7 (144) 152-8794	8128 290978	\N	10074
Антонин	Сафонова	Юлианович	8 (839) 868-48-79	5179 301943	среднее профессиональное	10075
Яков	Ситников	\N	+7 337 220 38 20	1547 190032	высшее	10076
Трифон	Наумов	Валерианович	+7 342 344 44 45	2505 463522	среднее	10077
Потап	Казакова	Филиппович	+7 563 973 1957	1711 492353	неоконченное высшее	10078
Пелагея	Алексеев	\N	8 (980) 110-96-52	5783 340979	среднее	10079
Елена	Корнилов	\N	8 819 059 5215	9803 422075	среднее	10080
Каллистрат	Дементьева	\N	+77127308888	7471 787548	\N	10081
Боян	Кириллова	\N	+7 (071) 403-4263	9845 936355	среднее профессиональное	10082
Леонтий	Козлова	\N	8 990 863 0654	9848 207224	среднее	10083
Амос	Брагин	\N	84541857104	6709 727536	среднее профессиональное	10085
Гремислав	Вишнякова	Витальевич	+7 811 009 6951	8728 517879	высшее	10086
Станимир	Терентьев	Мироновна	83308573372	7004 347619	среднее профессиональное	10087
Надежда	Смирнова	Измаилович	+79977677798	1449 317395	высшее	10088
Лукьян	Ефремов	Игоревич	8 (496) 691-77-48	8211 574672	неоконченное высшее	10089
Сергей	Прохоров	\N	8 386 666 06 09	4674 816013	\N	10090
Радим	Кулакова	\N	+79402685891	8556 818548	среднее	10091
Илья	Сергеев	\N	8 (153) 617-7641	6229 781469	среднее профессиональное	10092
Фадей	Беспалов	\N	+72711945945	3030 293108	высшее	10093
Радован	Кошелев	\N	+74920028341	5649 387877	среднее	10094
Елена	Фролова	\N	+7 (722) 311-66-76	8975 455914	\N	10095
Эмиль	Кабанова	\N	+7 (014) 719-60-53	5378 157746	среднее профессиональное	10096
Александра	Белозеров	Марсович	8 706 664 63 56	8188 447695	\N	10097
Аникита	Гущин	Павловна	8 (278) 460-03-62	6731 623595	среднее	10098
Галина	Турова	\N	8 506 448 8214	7532 462266	среднее	10099
Алексей	Шубина	\N	8 164 577 16 55	6789 108201	среднее	10100
Лидия	Романов	Валерьянович	8 151 537 7820	1898 609922	среднее	10101
Сергей	Щукина	\N	+7 (436) 822-3416	4380 806807	среднее профессиональное	10102
Маргарита	Сергеев	\N	8 (707) 665-86-84	5939 503389	неоконченное высшее	10103
Юлия	Костин	Артемовна	+73746978083	9256 573868	среднее профессиональное	10104
Валентина	Кондратьев	\N	+7 (931) 386-94-06	7649 553625	среднее	10105
Кондрат	Яковлев	\N	8 551 081 5957	3038 518429	высшее	10106
Мартьян	Овчинникова	\N	88577991518	1280 580849	\N	10107
Мечислав	Евсеев	\N	+7 (497) 554-4382	9288 732245	\N	10108
Ираклий	Лыткина	Дмитриевна	8 374 215 88 24	3224 178049	\N	10109
Агата	Филиппов	\N	8 (832) 695-40-49	9841 349304	среднее	10110
Анисим	Колобова	\N	+7 (096) 884-53-63	7062 408280	среднее профессиональное	10111
Кондрат	Лазарева	\N	+7 (318) 986-0100	9491 122069	среднее	10112
Кондрат	Мясников	Харлампьевич	+7 (403) 382-05-12	8885 466136	\N	10113
Адриан	Гущин	\N	+7 (599) 974-81-03	7415 234245	среднее	10114
Павел	Трофимова	\N	8 (157) 947-24-44	4716 879202	среднее	10115
Пелагея	Журавлев	\N	+7 (793) 463-08-62	7007 953370	среднее профессиональное	10116
Спиридон	Антонов	\N	+7 (793) 552-77-14	4941 652808	неоконченное высшее	10117
Прасковья	Романова	Юльевна	+79548263103	3991 431699	среднее	10118
Симон	Николаева	Афанасьевна	+7 991 434 0602	6003 484909	среднее	10119
Владлен	Константинов	Станиславовна	+77754299813	3801 203232	среднее профессиональное	10120
Ипполит	Фомина	Георгиевич	84015275460	5033 161994	среднее	10121
Исай	Жуков	Марсович	83933766440	9864 314606	неоконченное высшее	10122
Прохор	Федотова	\N	+7 099 753 39 40	6447 717797	неоконченное высшее	10123
Влас	Баранова	Геннадьевна	+7 484 792 56 03	4463 544729	высшее	10124
Ювеналий	Матвеева	Аскольдовна	+7 (046) 573-50-81	6372 503918	среднее	10125
Евфросиния	Савина	Ильясович	+7 (505) 190-97-50	2086 357122	неоконченное высшее	10126
Сократ	Смирнова	\N	8 107 436 29 60	7074 827466	высшее	10127
Яков	Панфилов	Ярославович	+76353406400	5307 212052	среднее	10128
Фома	Комиссаров	Абрамович	8 141 483 89 95	3168 445871	\N	10129
Климент	Беспалов	\N	8 (460) 339-1817	9638 472662	высшее	10130
Полина	Полякова	Изотович	+7 (465) 254-7890	2496 694320	высшее	10131
Аверкий	Зимин	Терентьевич	8 (145) 847-3080	6689 758049	неоконченное высшее	10132
Михей	Калашникова	Владленович	+7 111 698 2965	5304 515306	неоконченное высшее	10133
Валерия	Беспалов	\N	+7 (266) 394-42-15	2277 216841	среднее профессиональное	10134
Стоян	Козлов	\N	+7 (077) 092-9594	5433 522221	среднее	10135
Василий	Макарова	\N	8 258 109 95 25	4020 172073	неоконченное высшее	10136
Глафира	Маслова	Валерьевич	8 (029) 095-81-17	8673 602567	неоконченное высшее	10137
Филарет	Туров	\N	+7 (099) 595-09-64	5079 392253	высшее	10138
Юлия	Соловьева	Власович	+7 754 202 7209	5600 912413	неоконченное высшее	10139
Михаил	Николаев	Степановна	8 719 130 7033	1110 747095	среднее профессиональное	10140
Полина	Горшков	Демидович	+7 (172) 351-1373	9458 491949	среднее	10141
Анжела	Воронцова	Владленович	83360012294	9941 809387	среднее профессиональное	10142
Афиноген	Петров	\N	8 (236) 444-0903	8439 807050	среднее	10143
Радим	Евсеев	\N	8 (913) 587-9983	2486 658933	неоконченное высшее	10144
Ладислав	Савельева	Виленович	+72954114497	3732 626368	среднее профессиональное	10145
Велимир	Титова	Ефимовна	8 254 105 4269	5318 577857	\N	10146
Ангелина	Панфилов	Яковлевич	83614067068	3062 454969	\N	10147
Леон	Кулаков	\N	8 684 188 3335	8724 327369	\N	10148
Алевтина	Лобанов	Семеновна	+7 850 672 6242	2476 712698	\N	10149
Рюрик	Виноградова	Филимонович	8 (622) 386-80-15	6894 215157	среднее	10150
\.


--
-- TOC entry 5101 (class 0 OID 16573)
-- Dependencies: 231
-- Data for Name: student_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_group (program_id, max_students, start_date, end_date, group_number, id) FROM stdin;
13	24	2026-03-01	2026-08-03	ГР-001	1
11	22	2026-04-15	2026-07-26	ГР-002	2
6	17	2026-04-04	2026-08-07	ГР-003	3
4	21	2026-02-28	2026-08-22	ГР-004	4
12	26	2025-09-09	2026-02-09	ГР-005	5
5	22	2025-05-20	2025-08-01	ГР-006	6
5	23	2025-06-21	2025-09-14	ГР-007	7
6	19	2025-08-11	2026-01-15	ГР-008	8
3	20	2026-03-17	2026-08-22	ГР-009	9
16	29	2025-05-07	2025-10-10	ГР-010	10
19	29	2025-09-03	2026-01-28	ГР-011	11
19	25	2025-09-17	2026-03-06	ГР-012	12
11	19	2025-12-24	2026-04-19	ГР-013	13
3	30	2025-11-18	2026-03-14	ГР-014	14
10	23	2026-03-18	2026-07-31	ГР-015	15
2	26	2025-06-28	2025-10-30	ГР-016	16
3	24	2025-12-02	2026-03-31	ГР-017	17
15	16	2025-12-16	2026-02-21	ГР-018	18
12	24	2025-09-23	2025-12-01	ГР-019	19
3	27	2025-07-06	2025-11-02	ГР-020	20
19	16	2025-12-12	2026-04-08	ГР-021	21
19	21	2025-06-09	2025-09-18	ГР-022	22
20	30	2026-03-26	2026-07-28	ГР-023	23
5	16	2026-02-22	2026-06-19	ГР-024	24
4	25	2026-02-10	2026-07-11	ГР-025	25
3	20	2025-08-22	2025-10-26	ГР-026	26
8	29	2026-01-23	2026-05-19	ГР-027	27
17	20	2026-03-24	2026-07-08	ГР-028	28
12	24	2025-08-25	2025-12-12	ГР-029	29
14	25	2026-01-25	2026-06-20	ГР-030	30
\.


--
-- TOC entry 5102 (class 0 OID 16591)
-- Dependencies: 232
-- Data for Name: student_in_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_in_group (student_id, group_id, start_date, end_date) FROM stdin;
144	4	2025-08-08	2026-01-07
147	21	2025-10-02	2026-02-18
119	14	2025-05-28	2025-11-03
142	16	2025-11-04	2026-04-20
20	20	2026-03-31	2026-07-17
144	22	2025-07-26	2025-10-12
28	12	2025-09-16	2026-02-28
66	5	2025-10-17	2026-03-13
65	15	2026-03-13	2026-06-12
123	2	2025-08-20	2025-10-23
122	12	2025-07-17	2025-11-27
35	8	2025-11-14	2026-04-12
26	5	2025-08-20	2025-11-02
103	8	2025-07-01	2025-09-23
114	8	2025-06-07	2025-08-08
130	26	2025-09-17	2026-01-11
79	17	2026-02-23	2026-06-03
90	26	2025-05-09	2025-08-30
62	19	2026-02-21	2026-05-11
141	19	2025-07-12	2025-11-01
56	12	2026-04-14	2026-09-09
102	9	2025-05-30	2025-08-24
93	6	2025-10-14	2026-02-03
142	27	2025-11-07	2026-03-11
8	11	2025-05-04	2025-10-10
94	14	2026-03-01	2026-07-17
17	23	2025-10-29	2026-04-24
140	11	2026-04-11	2026-08-09
148	24	2025-11-05	2026-04-25
98	5	2025-06-23	2025-12-08
50	29	2025-09-04	2026-02-04
52	26	2026-04-18	2026-06-24
75	28	2025-10-29	2026-03-28
38	18	2026-02-03	2026-04-21
49	18	2026-03-30	2026-08-03
16	15	2025-11-14	2026-02-08
18	12	2025-08-23	2026-01-01
136	16	2026-02-20	2026-06-01
145	19	2025-08-30	2026-01-21
150	6	2025-06-19	2025-10-18
48	22	2026-02-17	2026-06-24
22	3	2026-03-29	2026-07-15
87	20	2025-06-02	2025-09-10
31	15	2026-03-10	2026-05-31
133	17	2026-04-24	2026-08-20
73	30	2025-11-11	2026-05-06
27	8	2026-01-12	2026-05-20
125	13	2025-06-15	2025-09-26
97	24	2025-07-13	2025-11-19
77	21	2026-01-31	2026-05-16
75	3	2025-05-09	2025-10-02
94	16	2025-10-20	2026-03-27
129	13	2025-09-22	2026-03-12
43	7	2026-01-27	2026-06-28
60	23	2026-03-26	2026-08-20
104	2	2025-11-13	2026-04-04
115	2	2025-06-08	2025-11-17
118	28	2025-04-26	2025-09-21
72	6	2025-08-23	2025-11-24
106	8	2026-04-22	2026-09-07
147	9	2025-05-12	2025-09-10
128	5	2026-01-16	2026-04-10
150	17	2026-03-20	2026-06-19
55	8	2025-12-11	2026-03-16
73	23	2026-03-29	2026-08-07
77	5	2025-05-28	2025-09-03
29	20	2025-09-01	2025-11-28
111	16	2025-10-23	2026-04-21
80	19	2026-04-05	2026-07-12
3	28	2025-05-12	2025-10-17
83	27	2025-06-04	2025-09-08
126	25	2025-11-13	2026-04-12
26	2	2026-02-16	2026-05-13
33	17	2026-01-05	2026-06-02
132	20	2026-02-08	2026-07-08
15	11	2025-08-24	2025-12-24
99	17	2025-05-03	2025-08-11
16	10	2025-12-05	2026-04-05
71	10	2026-02-13	2026-05-28
134	2	2025-08-24	2026-01-02
46	29	2025-12-29	2026-06-26
6	29	2026-04-06	2026-10-02
5	9	2025-07-15	2025-12-23
91	15	2025-08-27	2026-01-26
97	28	2025-07-11	2025-10-14
124	12	2025-07-08	2025-10-12
138	11	2025-08-14	2025-10-28
92	23	2025-08-10	2025-12-21
131	5	2025-11-17	2026-04-12
9	16	2025-08-26	2026-01-02
61	17	2026-02-19	2026-06-07
112	1	2025-10-13	2026-04-05
126	18	2026-01-10	2026-04-30
10	26	2025-06-09	2025-11-20
44	28	2025-08-08	2025-11-20
40	15	2025-06-21	2025-11-26
31	12	2025-06-25	2025-12-04
34	11	2025-08-09	2025-10-26
82	30	2025-06-08	2025-09-13
100	11	2025-04-30	2025-07-04
117	18	2025-12-22	2026-03-28
86	21	2025-11-28	2026-04-28
23	17	2025-11-10	2026-01-19
37	16	2025-06-03	2025-09-15
111	29	2025-07-14	2026-01-08
50	10	2025-11-21	2026-03-17
43	4	2025-09-08	2026-01-29
135	23	2025-11-24	2026-02-24
98	13	2025-08-26	2026-01-28
105	28	2025-08-08	2025-12-07
30	22	2025-06-18	2025-09-13
81	6	2026-01-23	2026-04-18
13	18	2026-03-03	2026-08-15
137	5	2025-08-13	2025-12-19
57	15	2025-12-03	2026-03-07
48	12	2025-07-29	2026-01-24
39	9	2025-06-30	2025-11-08
53	8	2025-05-22	2025-10-18
54	7	2025-08-23	2025-11-25
109	7	2025-12-19	2026-03-06
20	14	2026-04-06	2026-06-18
5	4	2025-09-03	2026-01-19
89	10	2025-11-20	2026-04-23
109	25	2025-10-14	2026-02-26
141	23	2025-05-14	2025-08-12
60	13	2025-06-14	2025-09-13
3	25	2025-05-06	2025-07-11
8	6	2025-10-24	2026-03-18
130	11	2026-04-10	2026-10-02
1	9	2026-01-12	2026-05-19
113	13	2025-05-14	2025-08-10
19	24	2025-06-05	2025-10-24
107	27	2025-09-20	2025-12-18
9	23	2025-05-15	2025-07-20
76	21	2025-05-28	2025-08-08
103	5	2025-10-07	2026-01-27
10	30	2025-09-24	2026-01-04
25	28	2025-07-03	2025-12-01
66	29	2026-01-23	2026-05-23
57	26	2025-12-12	2026-02-22
139	13	2026-04-06	2026-08-31
86	7	2025-12-11	2026-05-18
12	3	2025-12-25	2026-03-12
23	12	2026-03-15	2026-05-14
106	28	2026-01-18	2026-05-28
89	21	2026-01-21	2026-07-18
70	17	2025-10-15	2026-01-03
61	14	2025-12-20	2026-04-11
69	27	2025-09-10	2026-01-31
96	11	2025-08-24	2026-02-19
36	24	2025-09-01	2026-02-20
1	2	2026-03-08	2026-08-27
35	4	2025-07-10	2025-11-07
41	20	2026-01-26	2026-05-27
122	2	2026-02-13	2026-07-06
108	19	2026-01-10	2026-04-05
88	16	2026-03-05	2026-08-08
2	10	2025-11-18	2026-02-22
114	7	2025-05-25	2025-09-03
63	5	2026-04-18	2026-07-23
139	6	2026-02-12	2026-07-04
84	3	2026-02-15	2026-04-23
123	19	2025-10-22	2026-04-16
12	14	2025-12-01	2026-05-08
14	11	2025-06-15	2025-08-25
21	26	2025-05-31	2025-10-21
62	27	2026-03-06	2026-07-17
58	20	2026-03-02	2026-05-30
4	28	2026-04-17	2026-08-23
28	13	2026-01-21	2026-06-24
47	26	2025-10-23	2026-03-24
76	7	2025-06-01	2025-11-16
99	18	2025-10-18	2026-04-15
101	15	2025-08-23	2025-10-26
42	30	2026-01-15	2026-07-10
140	19	2025-12-31	2026-06-26
108	30	2026-01-25	2026-04-17
131	25	2026-02-16	2026-06-09
121	24	2025-10-22	2026-04-12
137	20	2025-10-24	2026-04-09
14	4	2025-07-23	2025-10-13
40	23	2025-07-20	2026-01-15
59	3	2025-06-19	2025-12-13
53	17	2026-03-25	2026-05-28
125	3	2026-04-07	2026-09-21
34	13	2025-12-20	2026-04-09
67	25	2025-08-03	2026-01-10
17	6	2026-04-14	2026-08-15
91	10	2025-09-13	2025-12-05
74	12	2025-09-24	2026-03-22
90	8	2025-07-05	2025-12-07
42	23	2026-01-21	2026-07-11
127	27	2026-04-16	2026-10-11
85	21	2026-01-08	2026-04-15
68	14	2025-08-31	2026-02-19
11	26	2026-02-25	2026-04-30
117	10	2026-03-25	2026-05-25
115	10	2026-04-02	2026-07-09
95	7	2025-08-29	2026-01-08
6	14	2025-10-18	2026-03-04
21	21	2025-10-31	2026-01-12
47	3	2025-05-06	2025-10-31
87	21	2025-05-20	2025-08-30
78	18	2025-10-26	2026-01-30
136	26	2025-06-07	2025-10-03
45	15	2025-09-08	2026-01-28
110	16	2025-10-27	2026-03-05
116	20	2025-10-21	2026-02-25
127	20	2026-03-19	2026-07-20
116	29	2025-06-30	2025-12-20
145	10	2025-08-12	2026-02-08
112	16	2026-02-17	2026-05-05
64	3	2025-09-07	2026-02-22
7	15	2025-12-15	2026-04-18
18	15	2025-12-04	2026-04-02
38	30	2025-06-13	2025-09-15
133	2	2025-11-08	2026-01-31
143	12	2025-06-03	2025-11-13
7	24	2025-09-29	2025-12-12
82	27	2026-03-08	2026-06-18
64	21	2026-01-27	2026-04-17
78	20	2026-02-28	2026-07-31
105	13	2025-06-05	2025-10-01
120	29	2025-08-29	2026-01-18
11	3	2025-11-26	2026-02-26
149	19	2026-01-02	2026-06-02
51	23	2025-05-22	2025-08-13
65	22	2026-02-26	2026-04-28
121	12	2025-08-20	2026-01-21
32	19	2025-11-17	2026-02-28
146	20	2025-10-21	2026-03-31
95	11	2025-09-27	2026-01-02
144	1	2026-05-23	2026-08-03
\.


--
-- TOC entry 5099 (class 0 OID 16541)
-- Dependencies: 229
-- Data for Name: teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher (first_name, last_name, middle_name, phone, passport, "position", id) FROM stdin;
Флорентин	Панов	Ниловна	+7 972 896 2309	4266 979995	преподаватель	1
Кира	Поляков	Геннадиевич	+7 756 263 6897	4908 232352	профессор	2
Нина	Архипова	Ануфриевич	+7 (838) 578-65-27	4571 587623	доцент	3
Твердислав	Зимин	Альбертовна	8 497 334 8434	3749 735324	ассистент	4
Ульяна	Игнатьев	Максимовна	+7 (757) 584-4198	2876 915573	старший преподаватель	5
Натан	Авдеева	Тихонович	8 240 415 7473	2771 706794	преподаватель	6
Егор	Ларионова	Антоновна	+78421993308	7149 515922	старший преподаватель	7
Зиновий	Петухова	\N	+7 (016) 571-2082	4978 206851	доцент	8
Орест	Суханова	Харламович	8 (345) 401-93-80	2983 934904	ассистент	9
Демид	Щукин	Вячеславович	+7 672 400 4991	6688 658623	профессор	10
Марк	Ермаков	Филиппович	8 (872) 874-3152	2129 630538	доцент	11
Наина	Фомичев	\N	+72054932966	7882 962276	профессор	12
Софон	Лапин	\N	+7 612 275 30 46	6934 766459	профессор	13
Измаил	Рожков	Рубеновна	+75499045301	8135 284692	ассистент	14
Рубен	Горбачев	Владиленович	8 841 459 33 27	5425 745830	ассистент	15
Герасим	Буров	Робертовна	85687833918	8616 556732	ассистент	16
Прокофий	Федорова	\N	8 191 088 3982	5022 971084	преподаватель	17
Григорий	Лапин	\N	8 (713) 971-8707	8385 355709	профессор	18
Влас	Васильева	Фёдорович	8 (908) 740-64-03	7209 452737	преподаватель	19
Фока	Куликов	Андреевич	8 518 017 04 62	6325 290672	профессор	20
Татьяна	Дорофеев	\N	8 567 661 82 51	5232 456871	доцент	21
Денис	Комарова	Тимурович	8 (230) 047-8686	5526 682789	преподаватель	22
Иван	Горшков	Фокич	8 243 106 9033	4130 189771	старший преподаватель	23
Артем	Медведев	Владиславовна	+7 790 306 7383	9004 682144	старший преподаватель	24
Раиса	Ситникова	Степановна	+7 284 395 9953	9041 569945	преподаватель	25
Ладислав	Носова	\N	+7 (836) 440-89-26	4630 524045	старший преподаватель	26
Федор	Попова	Анисимович	8 685 662 4628	7046 596249	ассистент	27
Савватий	Трофимов	Давидович	+72708668826	7971 882169	ассистент	28
Илья	Панфилов	Гертрудович	8 175 183 0469	8434 384076	доцент	29
Эраст	Федоров	\N	+7 398 373 54 03	2976 856321	старший преподаватель	30
\.


--
-- TOC entry 5100 (class 0 OID 16555)
-- Dependencies: 230
-- Data for Name: teacher_discipline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher_discipline (discipline_id, teacher_id) FROM stdin;
62	26
23	25
11	5
9	17
5	28
46	20
24	26
90	26
54	15
37	8
5	3
45	21
9	10
48	1
11	16
18	3
31	15
83	25
33	6
85	22
64	11
31	8
80	10
100	25
74	15
79	5
79	14
82	10
82	19
6	29
1	5
1	14
7	9
48	19
58	5
50	19
19	13
46	24
6	24
13	2
18	4
71	7
99	23
29	1
68	17
20	7
92	2
86	16
70	17
90	4
96	20
16	9
31	9
100	8
6	19
4	1
6	28
92	13
59	10
94	22
9	27
55	14
19	3
50	18
70	30
92	27
15	8
38	28
81	26
11	1
51	30
41	29
26	28
18	24
61	4
3	20
84	2
66	30
81	12
\.


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 242
-- Name: attestation_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attestation_new_id_seq', 100, true);


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 244
-- Name: classroom_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classroom_new_id_seq', 30, true);


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 241
-- Name: discipline_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discipline_new_id_seq', 100, true);


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 250
-- Name: document_type_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.document_type_new_id_seq', 3, true);


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 251
-- Name: graduation_document_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.graduation_document_new_id_seq', 119, true);


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 240
-- Name: hours_volume_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hours_volume_new_id_seq', 50, true);


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 246
-- Name: lesson_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_new_id_seq', 200, true);


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 245
-- Name: lesson_type_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_type_new_id_seq', 3, true);


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 243
-- Name: location_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.location_new_id_seq', 10, true);


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 239
-- Name: program_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_new_id_seq', 20, true);


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 238
-- Name: program_type_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_type_new_id_seq', 5, true);


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 249
-- Name: student_group_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_group_new_id_seq', 30, true);


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 247
-- Name: student_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_new_id_seq', 10150, true);


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 248
-- Name: teacher_new_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_new_id_seq', 30, true);


--
-- TOC entry 4915 (class 2606 OID 17076)
-- Name: attestation attestation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attestation
    ADD CONSTRAINT attestation_pkey PRIMARY KEY (id);


--
-- TOC entry 4887 (class 2606 OID 17094)
-- Name: classroom classroom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_pkey PRIMARY KEY (id);


--
-- TOC entry 4917 (class 2606 OID 17217)
-- Name: discipline_attestation discipline_attestation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline_attestation
    ADD CONSTRAINT discipline_attestation_pkey PRIMARY KEY (discipline_id, attestation_id);


--
-- TOC entry 4881 (class 2606 OID 17060)
-- Name: discipline discipline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline
    ADD CONSTRAINT discipline_pkey PRIMARY KEY (id);


--
-- TOC entry 4911 (class 2606 OID 17170)
-- Name: document_type document_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document_type
    ADD CONSTRAINT document_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4913 (class 2606 OID 17179)
-- Name: graduation_document graduation_document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduation_document
    ADD CONSTRAINT graduation_document_pkey PRIMARY KEY (id);


--
-- TOC entry 4919 (class 2606 OID 17266)
-- Name: group_lesson_teacher group_lesson_teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson_teacher
    ADD CONSTRAINT group_lesson_teacher_pkey PRIMARY KEY (group_id, lesson_id, teacher_id);


--
-- TOC entry 4879 (class 2606 OID 17049)
-- Name: hours_volume hours_volume_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hours_volume
    ADD CONSTRAINT hours_volume_pkey PRIMARY KEY (id);


--
-- TOC entry 4892 (class 2606 OID 17117)
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (id);


--
-- TOC entry 4889 (class 2606 OID 17108)
-- Name: lesson_type lesson_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_type
    ADD CONSTRAINT lesson_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4885 (class 2606 OID 17085)
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- TOC entry 4883 (class 2606 OID 17203)
-- Name: program_discipline program_discipline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_discipline
    ADD CONSTRAINT program_discipline_pkey PRIMARY KEY (discipline_id, program_id);


--
-- TOC entry 4877 (class 2606 OID 17033)
-- Name: program program_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_pkey PRIMARY KEY (id);


--
-- TOC entry 4875 (class 2606 OID 17022)
-- Name: program_type program_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_type
    ADD CONSTRAINT program_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4905 (class 2606 OID 17156)
-- Name: student_group student_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_group
    ADD CONSTRAINT student_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4907 (class 2606 OID 17336)
-- Name: student_group student_group_program_number_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_group
    ADD CONSTRAINT student_group_program_number_unique UNIQUE (program_id, group_number);


--
-- TOC entry 4909 (class 2606 OID 17245)
-- Name: student_in_group student_in_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_in_group
    ADD CONSTRAINT student_in_group_pkey PRIMARY KEY (student_id, group_id);


--
-- TOC entry 4895 (class 2606 OID 17332)
-- Name: student student_passport_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_passport_unique UNIQUE (passport);


--
-- TOC entry 4897 (class 2606 OID 17136)
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- TOC entry 4903 (class 2606 OID 17231)
-- Name: teacher_discipline teacher_discipline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_discipline
    ADD CONSTRAINT teacher_discipline_pkey PRIMARY KEY (discipline_id, teacher_id);


--
-- TOC entry 4899 (class 2606 OID 17334)
-- Name: teacher teacher_passport_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_passport_unique UNIQUE (passport);


--
-- TOC entry 4901 (class 2606 OID 17147)
-- Name: teacher teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (id);


--
-- TOC entry 4890 (class 1259 OID 17361)
-- Name: idx_lesson_classroom_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lesson_classroom_id ON public.lesson USING btree (classroom_id);


--
-- TOC entry 4893 (class 1259 OID 17381)
-- Name: idx_student_id_lastname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_student_id_lastname ON public.student USING btree (first_name);


--
-- TOC entry 4924 (class 2606 OID 17282)
-- Name: classroom classroom_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(id);


--
-- TOC entry 4935 (class 2606 OID 17387)
-- Name: discipline_attestation discipline_attestation_attestation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline_attestation
    ADD CONSTRAINT discipline_attestation_attestation_id_fkey FOREIGN KEY (attestation_id) REFERENCES public.attestation(id);


--
-- TOC entry 4936 (class 2606 OID 17382)
-- Name: discipline_attestation discipline_attestation_discipline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline_attestation
    ADD CONSTRAINT discipline_attestation_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES public.discipline(id);


--
-- TOC entry 4921 (class 2606 OID 17277)
-- Name: discipline discipline_hours_volume_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline
    ADD CONSTRAINT discipline_hours_volume_id_fkey FOREIGN KEY (hours_volume_id) REFERENCES public.hours_volume(id);


--
-- TOC entry 4932 (class 2606 OID 17307)
-- Name: graduation_document graduation_document_document_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduation_document
    ADD CONSTRAINT graduation_document_document_type_id_fkey FOREIGN KEY (document_type_id) REFERENCES public.document_type(id);


--
-- TOC entry 4933 (class 2606 OID 17302)
-- Name: graduation_document graduation_document_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduation_document
    ADD CONSTRAINT graduation_document_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id);


--
-- TOC entry 4934 (class 2606 OID 17312)
-- Name: graduation_document graduation_document_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.graduation_document
    ADD CONSTRAINT graduation_document_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- TOC entry 4937 (class 2606 OID 17392)
-- Name: group_lesson_teacher group_lesson_teacher_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson_teacher
    ADD CONSTRAINT group_lesson_teacher_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.student_group(id);


--
-- TOC entry 4938 (class 2606 OID 17397)
-- Name: group_lesson_teacher group_lesson_teacher_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson_teacher
    ADD CONSTRAINT group_lesson_teacher_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id);


--
-- TOC entry 4939 (class 2606 OID 17402)
-- Name: group_lesson_teacher group_lesson_teacher_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson_teacher
    ADD CONSTRAINT group_lesson_teacher_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teacher(id);


--
-- TOC entry 4925 (class 2606 OID 17287)
-- Name: lesson lesson_classroom_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_classroom_id_fkey FOREIGN KEY (classroom_id) REFERENCES public.classroom(id);


--
-- TOC entry 4926 (class 2606 OID 17292)
-- Name: lesson lesson_lesson_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_lesson_type_id_fkey FOREIGN KEY (lesson_type_id) REFERENCES public.lesson_type(id);


--
-- TOC entry 4922 (class 2606 OID 17407)
-- Name: program_discipline program_discipline_discipline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_discipline
    ADD CONSTRAINT program_discipline_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES public.discipline(id);


--
-- TOC entry 4923 (class 2606 OID 17412)
-- Name: program_discipline program_discipline_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_discipline
    ADD CONSTRAINT program_discipline_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id);


--
-- TOC entry 4920 (class 2606 OID 17272)
-- Name: program program_program_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT program_program_type_id_fkey FOREIGN KEY (program_type_id) REFERENCES public.program_type(id);


--
-- TOC entry 4929 (class 2606 OID 17297)
-- Name: student_group student_group_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_group
    ADD CONSTRAINT student_group_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.program(id);


--
-- TOC entry 4930 (class 2606 OID 17422)
-- Name: student_in_group student_in_group_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_in_group
    ADD CONSTRAINT student_in_group_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.student_group(id);


--
-- TOC entry 4931 (class 2606 OID 17417)
-- Name: student_in_group student_in_group_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_in_group
    ADD CONSTRAINT student_in_group_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- TOC entry 4927 (class 2606 OID 17427)
-- Name: teacher_discipline teacher_discipline_discipline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_discipline
    ADD CONSTRAINT teacher_discipline_discipline_id_fkey FOREIGN KEY (discipline_id) REFERENCES public.discipline(id);


--
-- TOC entry 4928 (class 2606 OID 17432)
-- Name: teacher_discipline teacher_discipline_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_discipline
    ADD CONSTRAINT teacher_discipline_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teacher(id);


-- Completed on 2026-05-24 15:50:00

--
-- PostgreSQL database dump complete
--

\unrestrict AwgT16A6KnIh82SQXIcJ797989g6XkUUCLc5c2rjLBwSkwdI19f72zM7bJ97L3a

