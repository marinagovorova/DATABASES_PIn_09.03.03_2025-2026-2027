--
-- PostgreSQL database dump
--

\restrict yEJOPJiaRnwhhyCR1esrUICp7SW5kSebMjfStonfHZSuEP2I9fgZcjMIuXYba37

-- Dumped from database version 14.22
-- Dumped by pg_dump version 14.22

-- Started on 2026-03-29 13:54:48

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
-- TOC entry 5 (class 2615 OID 16395)
-- Name: airport_schema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA airport_schema;


ALTER SCHEMA airport_schema OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 16457)
-- Name: aircraft; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.aircraft (
    aircraft_id integer NOT NULL,
    board_number character varying(20) NOT NULL,
    aircraft_type character varying(80) NOT NULL,
    seats_count integer NOT NULL,
    manufacturer_id integer NOT NULL,
    payload_capacity numeric(10,0) NOT NULL,
    speed_kmh numeric(10,0) NOT NULL,
    production_date date NOT NULL,
    flight_hours numeric(10,0) NOT NULL,
    last_repair_date date,
    purpose character varying(100) NOT NULL,
    fuel_consumption_per_hour numeric(10,0) NOT NULL
);


ALTER TABLE airport_schema.aircraft OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16456)
-- Name: aircraft_aircraft_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.aircraft_aircraft_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.aircraft_aircraft_id_seq OWNER TO postgres;

--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 220
-- Name: aircraft_aircraft_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.aircraft_aircraft_id_seq OWNED BY airport_schema.aircraft.aircraft_id;


--
-- TOC entry 215 (class 1259 OID 16420)
-- Name: airport; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.airport (
    airport_id integer NOT NULL,
    airport_code character varying(10) NOT NULL,
    airport_name character varying(150) NOT NULL,
    city character varying(100) NOT NULL,
    country_id integer NOT NULL
);


ALTER TABLE airport_schema.airport OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16419)
-- Name: airport_airport_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.airport_airport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.airport_airport_id_seq OWNER TO postgres;

--
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 214
-- Name: airport_airport_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.airport_airport_id_seq OWNED BY airport_schema.airport.airport_id;


--
-- TOC entry 227 (class 1259 OID 16526)
-- Name: cash_desk; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.cash_desk (
    cash_desk_id integer NOT NULL,
    desk_number character varying(20) NOT NULL,
    airport_id integer NOT NULL,
    address character varying(200) NOT NULL
);


ALTER TABLE airport_schema.cash_desk OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16525)
-- Name: cash_desk_cash_desk_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.cash_desk_cash_desk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.cash_desk_cash_desk_id_seq OWNER TO postgres;

--
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 226
-- Name: cash_desk_cash_desk_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.cash_desk_cash_desk_id_seq OWNED BY airport_schema.cash_desk.cash_desk_id;


--
-- TOC entry 211 (class 1259 OID 16397)
-- Name: country; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.country (
    country_id integer NOT NULL,
    country_name character varying(100) NOT NULL
);


ALTER TABLE airport_schema.country OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16396)
-- Name: country_country_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.country_country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.country_country_id_seq OWNER TO postgres;

--
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 210
-- Name: country_country_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.country_country_id_seq OWNED BY airport_schema.country.country_id;


--
-- TOC entry 233 (class 1259 OID 16579)
-- Name: crew_assignment; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.crew_assignment (
    crew_assignment_id integer NOT NULL,
    flight_id integer NOT NULL,
    employee_id integer NOT NULL,
    crew_role character varying(30) NOT NULL,
    CONSTRAINT chk_crew_role CHECK (((crew_role)::text = ANY ((ARRAY['first_pilot'::character varying, 'second_pilot'::character varying, 'chief_flight_attendant'::character varying, 'flight_attendant'::character varying])::text[])))
);


ALTER TABLE airport_schema.crew_assignment OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16578)
-- Name: crew_assignment_crew_assignment_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.crew_assignment_crew_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.crew_assignment_crew_assignment_id_seq OWNER TO postgres;

--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 232
-- Name: crew_assignment_crew_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.crew_assignment_crew_assignment_id_seq OWNED BY airport_schema.crew_assignment.crew_assignment_id;


--
-- TOC entry 219 (class 1259 OID 16443)
-- Name: employee; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.employee (
    employee_id integer NOT NULL,
    last_name character varying(60) NOT NULL,
    first_name character varying(60) NOT NULL,
    middle_name character varying(60),
    passport_data character varying(30) NOT NULL,
    position_id integer NOT NULL
);


ALTER TABLE airport_schema.employee OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16442)
-- Name: employee_employee_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.employee_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.employee_employee_id_seq OWNER TO postgres;

--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 218
-- Name: employee_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.employee_employee_id_seq OWNED BY airport_schema.employee.employee_id;


--
-- TOC entry 223 (class 1259 OID 16477)
-- Name: flight; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.flight (
    flight_id integer NOT NULL,
    flight_number character varying(20) NOT NULL,
    departure_date date NOT NULL,
    departure_time time without time zone NOT NULL,
    departure_airport_id integer NOT NULL,
    arrival_airport_id integer NOT NULL,
    aircraft_id integer NOT NULL,
    distance_km numeric(10,0) NOT NULL,
    flight_kind character varying(20) NOT NULL,
    CONSTRAINT chk_flight_airports CHECK ((departure_airport_id <> arrival_airport_id)),
    CONSTRAINT chk_flight_distance CHECK ((distance_km > (0)::numeric)),
    CONSTRAINT chk_flight_kind CHECK (((flight_kind)::text = ANY ((ARRAY['scheduled'::character varying, 'periodic'::character varying, 'one_time'::character varying])::text[])))
);


ALTER TABLE airport_schema.flight OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16476)
-- Name: flight_flight_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.flight_flight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.flight_flight_id_seq OWNER TO postgres;

--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 222
-- Name: flight_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.flight_flight_id_seq OWNED BY airport_schema.flight.flight_id;


--
-- TOC entry 213 (class 1259 OID 16406)
-- Name: manufacturer; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.manufacturer (
    manufacturer_id integer NOT NULL,
    manufacturer_name character varying(150) NOT NULL,
    country_id integer NOT NULL
);


ALTER TABLE airport_schema.manufacturer OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16405)
-- Name: manufacturer_manufacturer_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.manufacturer_manufacturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.manufacturer_manufacturer_id_seq OWNER TO postgres;

--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 212
-- Name: manufacturer_manufacturer_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.manufacturer_manufacturer_id_seq OWNED BY airport_schema.manufacturer.manufacturer_id;


--
-- TOC entry 235 (class 1259 OID 16599)
-- Name: medical_exam; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.medical_exam (
    medical_exam_id integer NOT NULL,
    crew_assignment_id integer NOT NULL,
    exam_date date NOT NULL,
    exam_status character varying(20) NOT NULL,
    rejection_reason character varying(200),
    CONSTRAINT chk_medical_exam_reason CHECK (((((exam_status)::text = 'allowed'::text) AND (rejection_reason IS NULL)) OR ((exam_status)::text = 'not_allowed'::text))),
    CONSTRAINT chk_medical_exam_status CHECK (((exam_status)::text = ANY ((ARRAY['allowed'::character varying, 'not_allowed'::character varying])::text[])))
);


ALTER TABLE airport_schema.medical_exam OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16598)
-- Name: medical_exam_medical_exam_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.medical_exam_medical_exam_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.medical_exam_medical_exam_id_seq OWNER TO postgres;

--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 234
-- Name: medical_exam_medical_exam_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.medical_exam_medical_exam_id_seq OWNED BY airport_schema.medical_exam.medical_exam_id;


--
-- TOC entry 229 (class 1259 OID 16540)
-- Name: passenger; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.passenger (
    passenger_id integer NOT NULL,
    last_name character varying(60) NOT NULL,
    first_name character varying(60) NOT NULL,
    middle_name character varying(60),
    passport_data character varying(30) NOT NULL
);


ALTER TABLE airport_schema.passenger OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16539)
-- Name: passenger_passenger_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.passenger_passenger_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.passenger_passenger_id_seq OWNER TO postgres;

--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 228
-- Name: passenger_passenger_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.passenger_passenger_id_seq OWNED BY airport_schema.passenger.passenger_id;


--
-- TOC entry 217 (class 1259 OID 16434)
-- Name: position; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema."position" (
    position_id integer NOT NULL,
    position_name character varying(50) NOT NULL
);


ALTER TABLE airport_schema."position" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16433)
-- Name: position_position_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.position_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.position_position_id_seq OWNER TO postgres;

--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 216
-- Name: position_position_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.position_position_id_seq OWNED BY airport_schema."position".position_id;


--
-- TOC entry 231 (class 1259 OID 16549)
-- Name: ticket; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.ticket (
    ticket_id integer NOT NULL,
    ticket_number character varying(30) NOT NULL,
    flight_id integer NOT NULL,
    passenger_id integer NOT NULL,
    seat_number character varying(10),
    seat_type character varying(20) NOT NULL,
    base_price numeric(10,0) NOT NULL,
    extra_fee numeric(10,0) NOT NULL,
    purchase_date date NOT NULL,
    sale_type character varying(10) NOT NULL,
    cash_desk_id integer,
    ticket_status character varying(20) NOT NULL,
    CONSTRAINT chk_ticket_extra_fee CHECK ((extra_fee >= (0)::numeric)),
    CONSTRAINT chk_ticket_price CHECK ((base_price > (0)::numeric)),
    CONSTRAINT chk_ticket_sale_logic CHECK (((((sale_type)::text = 'online'::text) AND (cash_desk_id IS NULL)) OR (((sale_type)::text = 'desk'::text) AND (cash_desk_id IS NOT NULL)))),
    CONSTRAINT chk_ticket_sale_type CHECK (((sale_type)::text = ANY ((ARRAY['online'::character varying, 'desk'::character varying])::text[]))),
    CONSTRAINT chk_ticket_seat_type CHECK (((seat_type)::text = ANY ((ARRAY['economy'::character varying, 'business'::character varying, 'first'::character varying])::text[]))),
    CONSTRAINT chk_ticket_status CHECK (((ticket_status)::text = ANY ((ARRAY['booked'::character varying, 'paid'::character varying, 'checked_in'::character varying, 'cancelled'::character varying])::text[])))
);


ALTER TABLE airport_schema.ticket OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16548)
-- Name: ticket_ticket_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.ticket_ticket_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.ticket_ticket_id_seq OWNER TO postgres;

--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 230
-- Name: ticket_ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.ticket_ticket_id_seq OWNED BY airport_schema.ticket.ticket_id;


--
-- TOC entry 225 (class 1259 OID 16504)
-- Name: transit_stop; Type: TABLE; Schema: airport_schema; Owner: postgres
--

CREATE TABLE airport_schema.transit_stop (
    transit_stop_id integer NOT NULL,
    flight_id integer NOT NULL,
    stop_order integer NOT NULL,
    airport_id integer NOT NULL,
    arrival_time time without time zone NOT NULL,
    departure_time time without time zone NOT NULL,
    ground_time_minutes integer NOT NULL
);


ALTER TABLE airport_schema.transit_stop OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16503)
-- Name: transit_stop_transit_stop_id_seq; Type: SEQUENCE; Schema: airport_schema; Owner: postgres
--

CREATE SEQUENCE airport_schema.transit_stop_transit_stop_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE airport_schema.transit_stop_transit_stop_id_seq OWNER TO postgres;

--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 224
-- Name: transit_stop_transit_stop_id_seq; Type: SEQUENCE OWNED BY; Schema: airport_schema; Owner: postgres
--

ALTER SEQUENCE airport_schema.transit_stop_transit_stop_id_seq OWNED BY airport_schema.transit_stop.transit_stop_id;


--
-- TOC entry 3230 (class 2604 OID 16460)
-- Name: aircraft aircraft_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.aircraft ALTER COLUMN aircraft_id SET DEFAULT nextval('airport_schema.aircraft_aircraft_id_seq'::regclass);


--
-- TOC entry 3227 (class 2604 OID 16423)
-- Name: airport airport_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.airport ALTER COLUMN airport_id SET DEFAULT nextval('airport_schema.airport_airport_id_seq'::regclass);


--
-- TOC entry 3245 (class 2604 OID 16529)
-- Name: cash_desk cash_desk_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.cash_desk ALTER COLUMN cash_desk_id SET DEFAULT nextval('airport_schema.cash_desk_cash_desk_id_seq'::regclass);


--
-- TOC entry 3225 (class 2604 OID 16400)
-- Name: country country_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.country ALTER COLUMN country_id SET DEFAULT nextval('airport_schema.country_country_id_seq'::regclass);


--
-- TOC entry 3254 (class 2604 OID 16582)
-- Name: crew_assignment crew_assignment_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.crew_assignment ALTER COLUMN crew_assignment_id SET DEFAULT nextval('airport_schema.crew_assignment_crew_assignment_id_seq'::regclass);


--
-- TOC entry 3229 (class 2604 OID 16446)
-- Name: employee employee_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.employee ALTER COLUMN employee_id SET DEFAULT nextval('airport_schema.employee_employee_id_seq'::regclass);


--
-- TOC entry 3237 (class 2604 OID 16480)
-- Name: flight flight_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.flight ALTER COLUMN flight_id SET DEFAULT nextval('airport_schema.flight_flight_id_seq'::regclass);


--
-- TOC entry 3226 (class 2604 OID 16409)
-- Name: manufacturer manufacturer_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.manufacturer ALTER COLUMN manufacturer_id SET DEFAULT nextval('airport_schema.manufacturer_manufacturer_id_seq'::regclass);


--
-- TOC entry 3256 (class 2604 OID 16602)
-- Name: medical_exam medical_exam_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.medical_exam ALTER COLUMN medical_exam_id SET DEFAULT nextval('airport_schema.medical_exam_medical_exam_id_seq'::regclass);


--
-- TOC entry 3246 (class 2604 OID 16543)
-- Name: passenger passenger_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.passenger ALTER COLUMN passenger_id SET DEFAULT nextval('airport_schema.passenger_passenger_id_seq'::regclass);


--
-- TOC entry 3228 (class 2604 OID 16437)
-- Name: position position_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema."position" ALTER COLUMN position_id SET DEFAULT nextval('airport_schema.position_position_id_seq'::regclass);


--
-- TOC entry 3247 (class 2604 OID 16552)
-- Name: ticket ticket_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.ticket ALTER COLUMN ticket_id SET DEFAULT nextval('airport_schema.ticket_ticket_id_seq'::regclass);


--
-- TOC entry 3241 (class 2604 OID 16507)
-- Name: transit_stop transit_stop_id; Type: DEFAULT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.transit_stop ALTER COLUMN transit_stop_id SET DEFAULT nextval('airport_schema.transit_stop_transit_stop_id_seq'::regclass);


--
-- TOC entry 3475 (class 0 OID 16457)
-- Dependencies: 221
-- Data for Name: aircraft; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.aircraft (aircraft_id, board_number, aircraft_type, seats_count, manufacturer_id, payload_capacity, speed_kmh, production_date, flight_hours, last_repair_date, purpose, fuel_consumption_per_hour) FROM stdin;
1	RA-96001	Sukhoi Superjet 100	98	1	12000	830	2018-05-10	5401	2024-02-15	Пассажирский	2300
2	RA-96002	МС-21	160	1	18000	870	2020-07-20	3100	2024-06-01	Пассажирский	2600
3	N-73701	Boeing 737-800	189	2	21000	850	2017-03-14	7200	2023-12-10	Пассажирский	2500
4	F-A3201	Airbus A320	180	3	19000	840	2019-09-01	4900	2024-03-05	Пассажирский	2450
\.


--
-- TOC entry 3469 (class 0 OID 16420)
-- Dependencies: 215
-- Data for Name: airport; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.airport (airport_id, airport_code, airport_name, city, country_id) FROM stdin;
1	SVO	Шереметьево	Москва	1
2	LED	Пулково	Санкт-Петербург	1
3	AER	Сочи	Сочи	1
4	JFK	John F. Kennedy International Airport	Нью-Йорк	2
5	CDG	Charles de Gaulle	Париж	3
\.


--
-- TOC entry 3481 (class 0 OID 16526)
-- Dependencies: 227
-- Data for Name: cash_desk; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.cash_desk (cash_desk_id, desk_number, airport_id, address) FROM stdin;
1	K1	1	Москва, терминал B, 1 этаж
2	K2	1	Москва, терминал D, 1 этаж
3	K1	2	Санкт-Петербург, центральный зал
4	K1	3	Сочи, ул. Авиационная, 10
\.


--
-- TOC entry 3465 (class 0 OID 16397)
-- Dependencies: 211
-- Data for Name: country; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.country (country_id, country_name) FROM stdin;
1	Россия
2	США
3	Франция
4	Германия
\.


--
-- TOC entry 3487 (class 0 OID 16579)
-- Dependencies: 233
-- Data for Name: crew_assignment; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.crew_assignment (crew_assignment_id, flight_id, employee_id, crew_role) FROM stdin;
1	1	1	first_pilot
2	1	2	second_pilot
3	1	3	chief_flight_attendant
4	1	4	flight_attendant
5	1	5	flight_attendant
6	2	1	first_pilot
7	2	2	second_pilot
8	2	3	chief_flight_attendant
9	2	4	flight_attendant
\.


--
-- TOC entry 3473 (class 0 OID 16443)
-- Dependencies: 219
-- Data for Name: employee; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.employee (employee_id, last_name, first_name, middle_name, passport_data, position_id) FROM stdin;
1	Иванов	Алексей	Петрович	4010 123456	1
2	Смирнов	Дмитрий	Олегович	4011 123457	2
3	Кузнецова	Мария	Игоревна	4012 123458	3
4	Соколова	Анна	Сергеевна	4013 123459	4
5	Павлов	Илья	Николаевич	4014 123460	4
\.


--
-- TOC entry 3477 (class 0 OID 16477)
-- Dependencies: 223
-- Data for Name: flight; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.flight (flight_id, flight_number, departure_date, departure_time, departure_airport_id, arrival_airport_id, aircraft_id, distance_km, flight_kind) FROM stdin;
1	SU1001	2026-03-27	08:30:00	1	2	1	635	scheduled
2	SU1002	2026-03-27	12:45:00	2	3	2	1950	scheduled
3	SU1003	2026-03-28	09:15:00	3	1	4	1380	periodic
4	SU1004	2026-03-29	15:00:00	1	5	3	2480	one_time
\.


--
-- TOC entry 3467 (class 0 OID 16406)
-- Dependencies: 213
-- Data for Name: manufacturer; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.manufacturer (manufacturer_id, manufacturer_name, country_id) FROM stdin;
1	ОАК	1
2	Boeing	2
3	Airbus	3
\.


--
-- TOC entry 3489 (class 0 OID 16599)
-- Dependencies: 235
-- Data for Name: medical_exam; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.medical_exam (medical_exam_id, crew_assignment_id, exam_date, exam_status, rejection_reason) FROM stdin;
1	1	2026-03-27	allowed	\N
2	2	2026-03-27	allowed	\N
3	3	2026-03-27	allowed	\N
4	4	2026-03-27	allowed	\N
5	5	2026-03-27	not_allowed	Повышенное давление
\.


--
-- TOC entry 3483 (class 0 OID 16540)
-- Dependencies: 229
-- Data for Name: passenger; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.passenger (passenger_id, last_name, first_name, middle_name, passport_data) FROM stdin;
1	Петров	Егор	Андреевич	5001 111111
2	Орлова	Светлана	Ивановна	5002 111112
3	Морозов	Кирилл	Олегович	5003 111113
4	Васильева	Дарья	Сергеевна	5004 111114
5	Никитин	Роман	Павлович	5005 111115
\.


--
-- TOC entry 3471 (class 0 OID 16434)
-- Dependencies: 217
-- Data for Name: position; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema."position" (position_id, position_name) FROM stdin;
1	Первый пилот
2	Второй пилот
3	Старший стюард
4	Стюард
\.


--
-- TOC entry 3485 (class 0 OID 16549)
-- Dependencies: 231
-- Data for Name: ticket; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.ticket (ticket_id, ticket_number, flight_id, passenger_id, seat_number, seat_type, base_price, extra_fee, purchase_date, sale_type, cash_desk_id, ticket_status) FROM stdin;
5	T100001	1	1	12A	economy	8500	500	2026-03-20	online	\N	paid
6	T100002	1	2	12B	economy	8500	0	2026-03-21	desk	1	paid
7	T100003	2	3	2A	business	15500	1500	2026-03-22	online	\N	paid
8	T100004	2	4	\N	economy	9000	0	2026-03-23	desk	3	booked
9	T100005	4	5	1C	first	35000	3000	2026-03-24	online	\N	paid
\.


--
-- TOC entry 3479 (class 0 OID 16504)
-- Dependencies: 225
-- Data for Name: transit_stop; Type: TABLE DATA; Schema: airport_schema; Owner: postgres
--

COPY airport_schema.transit_stop (transit_stop_id, flight_id, stop_order, airport_id, arrival_time, departure_time, ground_time_minutes) FROM stdin;
1	4	1	2	16:20:00	17:00:00	40
2	4	2	4	20:30:00	21:10:00	40
\.


--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 220
-- Name: aircraft_aircraft_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.aircraft_aircraft_id_seq', 4, true);


--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 214
-- Name: airport_airport_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.airport_airport_id_seq', 5, true);


--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 226
-- Name: cash_desk_cash_desk_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.cash_desk_cash_desk_id_seq', 4, true);


--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 210
-- Name: country_country_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.country_country_id_seq', 4, true);


--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 232
-- Name: crew_assignment_crew_assignment_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.crew_assignment_crew_assignment_id_seq', 9, true);


--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 218
-- Name: employee_employee_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.employee_employee_id_seq', 6, true);


--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 222
-- Name: flight_flight_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.flight_flight_id_seq', 4, true);


--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 212
-- Name: manufacturer_manufacturer_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.manufacturer_manufacturer_id_seq', 3, true);


--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 234
-- Name: medical_exam_medical_exam_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.medical_exam_medical_exam_id_seq', 5, true);


--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 228
-- Name: passenger_passenger_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.passenger_passenger_id_seq', 5, true);


--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 216
-- Name: position_position_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.position_position_id_seq', 4, true);


--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 230
-- Name: ticket_ticket_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.ticket_ticket_id_seq', 9, true);


--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 224
-- Name: transit_stop_transit_stop_id_seq; Type: SEQUENCE SET; Schema: airport_schema; Owner: postgres
--

SELECT pg_catalog.setval('airport_schema.transit_stop_transit_stop_id_seq', 2, true);


--
-- TOC entry 3280 (class 2606 OID 16462)
-- Name: aircraft aircraft_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.aircraft
    ADD CONSTRAINT aircraft_pkey PRIMARY KEY (aircraft_id);


--
-- TOC entry 3268 (class 2606 OID 16425)
-- Name: airport airport_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.airport
    ADD CONSTRAINT airport_pkey PRIMARY KEY (airport_id);


--
-- TOC entry 3292 (class 2606 OID 16531)
-- Name: cash_desk cash_desk_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.cash_desk
    ADD CONSTRAINT cash_desk_pkey PRIMARY KEY (cash_desk_id);


--
-- TOC entry 3231 (class 2606 OID 16474)
-- Name: aircraft chk_aircraft_fuel; Type: CHECK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE airport_schema.aircraft
    ADD CONSTRAINT chk_aircraft_fuel CHECK ((fuel_consumption_per_hour > (0)::numeric)) NOT VALID;


--
-- TOC entry 3232 (class 2606 OID 16473)
-- Name: aircraft chk_aircraft_hours; Type: CHECK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE airport_schema.aircraft
    ADD CONSTRAINT chk_aircraft_hours CHECK ((flight_hours >= (0)::numeric)) NOT VALID;


--
-- TOC entry 3233 (class 2606 OID 16471)
-- Name: aircraft chk_aircraft_payload; Type: CHECK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE airport_schema.aircraft
    ADD CONSTRAINT chk_aircraft_payload CHECK ((payload_capacity > (0)::numeric)) NOT VALID;


--
-- TOC entry 3234 (class 2606 OID 16475)
-- Name: aircraft chk_aircraft_repair_date; Type: CHECK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE airport_schema.aircraft
    ADD CONSTRAINT chk_aircraft_repair_date CHECK (((last_repair_date IS NULL) OR (last_repair_date >= production_date))) NOT VALID;


--
-- TOC entry 3235 (class 2606 OID 16470)
-- Name: aircraft chk_aircraft_seats; Type: CHECK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE airport_schema.aircraft
    ADD CONSTRAINT chk_aircraft_seats CHECK ((seats_count > 0)) NOT VALID;


--
-- TOC entry 3236 (class 2606 OID 16472)
-- Name: aircraft chk_aircraft_speed; Type: CHECK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE airport_schema.aircraft
    ADD CONSTRAINT chk_aircraft_speed CHECK ((speed_kmh > (0)::numeric)) NOT VALID;


--
-- TOC entry 3242 (class 2606 OID 16523)
-- Name: transit_stop chk_transit_ground_time; Type: CHECK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE airport_schema.transit_stop
    ADD CONSTRAINT chk_transit_ground_time CHECK ((ground_time_minutes >= 0)) NOT VALID;


--
-- TOC entry 3243 (class 2606 OID 16522)
-- Name: transit_stop chk_transit_stop_order; Type: CHECK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE airport_schema.transit_stop
    ADD CONSTRAINT chk_transit_stop_order CHECK (((stop_order >= 1) AND (stop_order <= 3))) NOT VALID;


--
-- TOC entry 3244 (class 2606 OID 16524)
-- Name: transit_stop chk_transit_time_logic; Type: CHECK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE airport_schema.transit_stop
    ADD CONSTRAINT chk_transit_time_logic CHECK ((departure_time > arrival_time)) NOT VALID;


--
-- TOC entry 3260 (class 2606 OID 16402)
-- Name: country country_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);


--
-- TOC entry 3304 (class 2606 OID 16585)
-- Name: crew_assignment crew_assignment_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.crew_assignment
    ADD CONSTRAINT crew_assignment_pkey PRIMARY KEY (crew_assignment_id);


--
-- TOC entry 3276 (class 2606 OID 16448)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 3284 (class 2606 OID 16485)
-- Name: flight flight_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.flight
    ADD CONSTRAINT flight_pkey PRIMARY KEY (flight_id);


--
-- TOC entry 3264 (class 2606 OID 16411)
-- Name: manufacturer manufacturer_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.manufacturer
    ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (manufacturer_id);


--
-- TOC entry 3308 (class 2606 OID 16606)
-- Name: medical_exam medical_exam_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.medical_exam
    ADD CONSTRAINT medical_exam_pkey PRIMARY KEY (medical_exam_id);


--
-- TOC entry 3296 (class 2606 OID 16545)
-- Name: passenger passenger_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.passenger
    ADD CONSTRAINT passenger_pkey PRIMARY KEY (passenger_id);


--
-- TOC entry 3272 (class 2606 OID 16439)
-- Name: position position_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (position_id);


--
-- TOC entry 3300 (class 2606 OID 16560)
-- Name: ticket ticket_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (ticket_id);


--
-- TOC entry 3288 (class 2606 OID 16509)
-- Name: transit_stop transit_stop_pkey; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.transit_stop
    ADD CONSTRAINT transit_stop_pkey PRIMARY KEY (transit_stop_id);


--
-- TOC entry 3282 (class 2606 OID 16464)
-- Name: aircraft uq_aircraft_board_number; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.aircraft
    ADD CONSTRAINT uq_aircraft_board_number UNIQUE (board_number);


--
-- TOC entry 3270 (class 2606 OID 16427)
-- Name: airport uq_airport_code; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.airport
    ADD CONSTRAINT uq_airport_code UNIQUE (airport_code);


--
-- TOC entry 3294 (class 2606 OID 16533)
-- Name: cash_desk uq_cash_desk_airport_number; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.cash_desk
    ADD CONSTRAINT uq_cash_desk_airport_number UNIQUE (airport_id, desk_number);


--
-- TOC entry 3262 (class 2606 OID 16404)
-- Name: country uq_country_name; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.country
    ADD CONSTRAINT uq_country_name UNIQUE (country_name);


--
-- TOC entry 3306 (class 2606 OID 16587)
-- Name: crew_assignment uq_crew_assignment_flight_employee; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.crew_assignment
    ADD CONSTRAINT uq_crew_assignment_flight_employee UNIQUE (flight_id, employee_id);


--
-- TOC entry 3278 (class 2606 OID 16450)
-- Name: employee uq_employee_passport; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.employee
    ADD CONSTRAINT uq_employee_passport UNIQUE (passport_data);


--
-- TOC entry 3286 (class 2606 OID 16487)
-- Name: flight uq_flight_number; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.flight
    ADD CONSTRAINT uq_flight_number UNIQUE (flight_number);


--
-- TOC entry 3266 (class 2606 OID 16413)
-- Name: manufacturer uq_manufacturer_name; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.manufacturer
    ADD CONSTRAINT uq_manufacturer_name UNIQUE (manufacturer_name);


--
-- TOC entry 3298 (class 2606 OID 16547)
-- Name: passenger uq_passenger_passport; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.passenger
    ADD CONSTRAINT uq_passenger_passport UNIQUE (passport_data);


--
-- TOC entry 3274 (class 2606 OID 16441)
-- Name: position uq_position_name; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema."position"
    ADD CONSTRAINT uq_position_name UNIQUE (position_name);


--
-- TOC entry 3302 (class 2606 OID 16562)
-- Name: ticket uq_ticket_number; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.ticket
    ADD CONSTRAINT uq_ticket_number UNIQUE (ticket_number);


--
-- TOC entry 3290 (class 2606 OID 16511)
-- Name: transit_stop uq_transit_stop_flight_order; Type: CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.transit_stop
    ADD CONSTRAINT uq_transit_stop_flight_order UNIQUE (flight_id, stop_order);


--
-- TOC entry 3312 (class 2606 OID 16465)
-- Name: aircraft fk_aircraft_manufacturer; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.aircraft
    ADD CONSTRAINT fk_aircraft_manufacturer FOREIGN KEY (manufacturer_id) REFERENCES airport_schema.manufacturer(manufacturer_id) NOT VALID;


--
-- TOC entry 3310 (class 2606 OID 16428)
-- Name: airport fk_airport_country; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.airport
    ADD CONSTRAINT fk_airport_country FOREIGN KEY (country_id) REFERENCES airport_schema.country(country_id);


--
-- TOC entry 3318 (class 2606 OID 16534)
-- Name: cash_desk fk_cash_desk_airport; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.cash_desk
    ADD CONSTRAINT fk_cash_desk_airport FOREIGN KEY (airport_id) REFERENCES airport_schema.airport(airport_id);


--
-- TOC entry 3322 (class 2606 OID 16593)
-- Name: crew_assignment fk_crew_assignment_employee; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.crew_assignment
    ADD CONSTRAINT fk_crew_assignment_employee FOREIGN KEY (employee_id) REFERENCES airport_schema.employee(employee_id);


--
-- TOC entry 3323 (class 2606 OID 16588)
-- Name: crew_assignment fk_crew_assignment_flight; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.crew_assignment
    ADD CONSTRAINT fk_crew_assignment_flight FOREIGN KEY (flight_id) REFERENCES airport_schema.flight(flight_id);


--
-- TOC entry 3311 (class 2606 OID 16451)
-- Name: employee fk_employee_position; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.employee
    ADD CONSTRAINT fk_employee_position FOREIGN KEY (position_id) REFERENCES airport_schema."position"(position_id);


--
-- TOC entry 3313 (class 2606 OID 16498)
-- Name: flight fk_flight_aircraft; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.flight
    ADD CONSTRAINT fk_flight_aircraft FOREIGN KEY (aircraft_id) REFERENCES airport_schema.aircraft(aircraft_id);


--
-- TOC entry 3314 (class 2606 OID 16493)
-- Name: flight fk_flight_arrival_airport; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.flight
    ADD CONSTRAINT fk_flight_arrival_airport FOREIGN KEY (arrival_airport_id) REFERENCES airport_schema.airport(airport_id);


--
-- TOC entry 3315 (class 2606 OID 16488)
-- Name: flight fk_flight_departure_airport; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.flight
    ADD CONSTRAINT fk_flight_departure_airport FOREIGN KEY (departure_airport_id) REFERENCES airport_schema.airport(airport_id);


--
-- TOC entry 3309 (class 2606 OID 16414)
-- Name: manufacturer fk_manufacturer_country; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.manufacturer
    ADD CONSTRAINT fk_manufacturer_country FOREIGN KEY (country_id) REFERENCES airport_schema.country(country_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3324 (class 2606 OID 16607)
-- Name: medical_exam fk_medical_exam_assignment; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.medical_exam
    ADD CONSTRAINT fk_medical_exam_assignment FOREIGN KEY (crew_assignment_id) REFERENCES airport_schema.crew_assignment(crew_assignment_id);


--
-- TOC entry 3319 (class 2606 OID 16573)
-- Name: ticket fk_ticket_cash_desk; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.ticket
    ADD CONSTRAINT fk_ticket_cash_desk FOREIGN KEY (cash_desk_id) REFERENCES airport_schema.cash_desk(cash_desk_id);


--
-- TOC entry 3320 (class 2606 OID 16563)
-- Name: ticket fk_ticket_flight; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.ticket
    ADD CONSTRAINT fk_ticket_flight FOREIGN KEY (flight_id) REFERENCES airport_schema.flight(flight_id);


--
-- TOC entry 3321 (class 2606 OID 16568)
-- Name: ticket fk_ticket_passenger; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.ticket
    ADD CONSTRAINT fk_ticket_passenger FOREIGN KEY (passenger_id) REFERENCES airport_schema.passenger(passenger_id);


--
-- TOC entry 3316 (class 2606 OID 16517)
-- Name: transit_stop fk_transit_stop_airport; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.transit_stop
    ADD CONSTRAINT fk_transit_stop_airport FOREIGN KEY (airport_id) REFERENCES airport_schema.airport(airport_id) NOT VALID;


--
-- TOC entry 3317 (class 2606 OID 16512)
-- Name: transit_stop fk_transit_stop_flight; Type: FK CONSTRAINT; Schema: airport_schema; Owner: postgres
--

ALTER TABLE ONLY airport_schema.transit_stop
    ADD CONSTRAINT fk_transit_stop_flight FOREIGN KEY (flight_id) REFERENCES airport_schema.flight(flight_id) NOT VALID;


-- Completed on 2026-03-29 13:54:49

--
-- PostgreSQL database dump complete
--

\unrestrict yEJOPJiaRnwhhyCR1esrUICp7SW5kSebMjfStonfHZSuEP2I9fgZcjMIuXYba37

