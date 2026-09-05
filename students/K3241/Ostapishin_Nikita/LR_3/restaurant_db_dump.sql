--
-- PostgreSQL database dump
--

\restrict sCmHlU96ARPftPXej8nvO0mIHidN99pfs7vYpgtdJciqe5XpKcn9eKDQNBK24Jp

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2026-04-22 14:06:13

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 25262)
-- Name: dish; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dish (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(50) NOT NULL,
    description text,
    cooking_time integer NOT NULL,
    CONSTRAINT chk_cooking_time CHECK ((cooking_time > 0))
);


ALTER TABLE public.dish OWNER TO postgres;

--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE dish; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.dish IS 'Меню ресторана';


--
-- TOC entry 225 (class 1259 OID 25261)
-- Name: dish_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dish_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dish_id_seq OWNER TO postgres;

--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 225
-- Name: dish_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dish_id_seq OWNED BY public.dish.id;


--
-- TOC entry 218 (class 1259 OID 25219)
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    id integer NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    middle_name character varying(50),
    birth_date date NOT NULL,
    phone character varying(20) NOT NULL,
    CONSTRAINT chk_employee_birth_date CHECK ((birth_date > '1920-01-01'::date)),
    CONSTRAINT chk_employee_phone CHECK (((phone)::text ~ '^\+?[0-9\-\(\)\s]{10,20}$'::text))
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE employee; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.employee IS 'Сотрудники ресторана';


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN employee.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employee.id IS 'Уникальный идентификатор сотрудника (суррогатный ключ)';


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN employee.phone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employee.phone IS 'Номер телефона, уникальный для каждого сотрудника';


--
-- TOC entry 217 (class 1259 OID 25218)
-- Name: employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_id_seq OWNER TO postgres;

--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 217
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_id_seq OWNED BY public.employee.id;


--
-- TOC entry 222 (class 1259 OID 25243)
-- Name: employee_position; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_position (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    employee_id integer NOT NULL,
    salary numeric(10,2) NOT NULL,
    start_date date DEFAULT CURRENT_DATE NOT NULL,
    end_date date,
    CONSTRAINT chk_dates CHECK (((end_date IS NULL) OR (start_date <= end_date))),
    CONSTRAINT chk_salary_positive CHECK ((salary > (0)::numeric))
);


ALTER TABLE public.employee_position OWNER TO postgres;

--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE employee_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.employee_position IS 'История должностей сотрудников';


--
-- TOC entry 221 (class 1259 OID 25242)
-- Name: employee_position_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_position_id_seq OWNER TO postgres;

--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 221
-- Name: employee_position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_position_id_seq OWNED BY public.employee_position.id;


--
-- TOC entry 228 (class 1259 OID 25274)
-- Name: ingredient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredient (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    type character varying(50) NOT NULL,
    stock_quantity numeric(12,3) DEFAULT 0 NOT NULL,
    required_stock numeric(12,3) DEFAULT 0 NOT NULL,
    calories integer,
    unit character varying(20) NOT NULL,
    shelf_life_days integer,
    CONSTRAINT chk_required_stock_nonnegative CHECK ((required_stock >= (0)::numeric)),
    CONSTRAINT chk_stock_nonnegative CHECK ((stock_quantity >= (0)::numeric))
);


ALTER TABLE public.ingredient OWNER TO postgres;

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE ingredient; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ingredient IS 'Складские ингредиенты';


--
-- TOC entry 227 (class 1259 OID 25273)
-- Name: ingredient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ingredient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredient_id_seq OWNER TO postgres;

--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 227
-- Name: ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ingredient_id_seq OWNED BY public.ingredient.id;


--
-- TOC entry 232 (class 1259 OID 25297)
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    id integer NOT NULL,
    table_id integer NOT NULL,
    employee_id integer NOT NULL,
    order_date date DEFAULT CURRENT_DATE NOT NULL,
    order_time time without time zone DEFAULT CURRENT_TIME NOT NULL,
    status character varying(30) DEFAULT 'active'::character varying NOT NULL,
    CONSTRAINT chk_order_status CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'paid'::character varying, 'cancelled'::character varying, 'completed'::character varying])::text[])))
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE "order"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."order" IS 'Заказы клиентов';


--
-- TOC entry 231 (class 1259 OID 25296)
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_id_seq OWNER TO postgres;

--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 231
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_id_seq OWNED BY public."order".id;


--
-- TOC entry 234 (class 1259 OID 25308)
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    id integer NOT NULL,
    order_id integer NOT NULL,
    dish_id integer NOT NULL,
    cook_id integer,
    quantity integer DEFAULT 1 NOT NULL,
    special_requests text,
    cooking_status character varying(30) DEFAULT 'pending'::character varying NOT NULL,
    CONSTRAINT chk_cooking_status CHECK (((cooking_status)::text = ANY ((ARRAY['pending'::character varying, 'cooking'::character varying, 'ready'::character varying, 'served'::character varying])::text[]))),
    CONSTRAINT chk_order_item_quantity CHECK ((quantity > 0))
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE order_item; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.order_item IS 'Блюда в составе заказа';


--
-- TOC entry 233 (class 1259 OID 25307)
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_item_id_seq OWNER TO postgres;

--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 233
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_item_id_seq OWNED BY public.order_item.id;


--
-- TOC entry 220 (class 1259 OID 25230)
-- Name: passport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passport (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    series character varying(4) NOT NULL,
    number character varying(6) NOT NULL,
    issue_date date NOT NULL,
    CONSTRAINT chk_passport_number CHECK (((number)::text ~ '^[0-9]{6}$'::text)),
    CONSTRAINT chk_passport_series CHECK (((series)::text ~ '^[0-9]{4}$'::text))
);


ALTER TABLE public.passport OWNER TO postgres;

--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE passport; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.passport IS 'Паспортные данные сотрудников (1:1)';


--
-- TOC entry 219 (class 1259 OID 25229)
-- Name: passport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.passport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passport_id_seq OWNER TO postgres;

--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 219
-- Name: passport_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.passport_id_seq OWNED BY public.passport.id;


--
-- TOC entry 236 (class 1259 OID 25321)
-- Name: recipe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipe (
    id integer NOT NULL,
    dish_id integer NOT NULL,
    ingredient_id integer NOT NULL,
    quantity numeric(10,3) NOT NULL,
    unit character varying(20) NOT NULL,
    CONSTRAINT chk_recipe_quantity CHECK ((quantity > (0)::numeric))
);


ALTER TABLE public.recipe OWNER TO postgres;

--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE recipe; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.recipe IS 'Состав блюд (рецепты)';


--
-- TOC entry 235 (class 1259 OID 25320)
-- Name: recipe_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipe_id_seq OWNER TO postgres;

--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 235
-- Name: recipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipe_id_seq OWNED BY public.recipe.id;


--
-- TOC entry 230 (class 1259 OID 25287)
-- Name: supply_ingredient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supply_ingredient (
    id integer NOT NULL,
    ingredient_id integer NOT NULL,
    purchase_date date DEFAULT CURRENT_DATE NOT NULL,
    quantity numeric(12,3) NOT NULL,
    price numeric(10,2) NOT NULL,
    expiration_date date,
    supplier character varying(100),
    CONSTRAINT chk_supply_price CHECK ((price > (0)::numeric)),
    CONSTRAINT chk_supply_quantity CHECK ((quantity > (0)::numeric))
);


ALTER TABLE public.supply_ingredient OWNER TO postgres;

--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE supply_ingredient; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.supply_ingredient IS 'История поставок ингредиентов';


--
-- TOC entry 229 (class 1259 OID 25286)
-- Name: supply_ingredient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supply_ingredient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.supply_ingredient_id_seq OWNER TO postgres;

--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 229
-- Name: supply_ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supply_ingredient_id_seq OWNED BY public.supply_ingredient.id;


--
-- TOC entry 224 (class 1259 OID 25254)
-- Name: table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."table" (
    id integer NOT NULL,
    seats integer NOT NULL,
    location character varying(100) NOT NULL,
    CONSTRAINT chk_seats CHECK (((seats >= 1) AND (seats <= 20)))
);


ALTER TABLE public."table" OWNER TO postgres;

--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE "table"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."table" IS 'Столы в ресторане';


--
-- TOC entry 223 (class 1259 OID 25253)
-- Name: table_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.table_id_seq OWNER TO postgres;

--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 223
-- Name: table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.table_id_seq OWNED BY public."table".id;


--
-- TOC entry 4792 (class 2604 OID 25265)
-- Name: dish id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dish ALTER COLUMN id SET DEFAULT nextval('public.dish_id_seq'::regclass);


--
-- TOC entry 4787 (class 2604 OID 25222)
-- Name: employee id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee ALTER COLUMN id SET DEFAULT nextval('public.employee_id_seq'::regclass);


--
-- TOC entry 4789 (class 2604 OID 25246)
-- Name: employee_position id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_position ALTER COLUMN id SET DEFAULT nextval('public.employee_position_id_seq'::regclass);


--
-- TOC entry 4793 (class 2604 OID 25277)
-- Name: ingredient id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient ALTER COLUMN id SET DEFAULT nextval('public.ingredient_id_seq'::regclass);


--
-- TOC entry 4798 (class 2604 OID 25300)
-- Name: order id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN id SET DEFAULT nextval('public.order_id_seq'::regclass);


--
-- TOC entry 4802 (class 2604 OID 25311)
-- Name: order_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item ALTER COLUMN id SET DEFAULT nextval('public.order_item_id_seq'::regclass);


--
-- TOC entry 4788 (class 2604 OID 25233)
-- Name: passport id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passport ALTER COLUMN id SET DEFAULT nextval('public.passport_id_seq'::regclass);


--
-- TOC entry 4805 (class 2604 OID 25324)
-- Name: recipe id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe ALTER COLUMN id SET DEFAULT nextval('public.recipe_id_seq'::regclass);


--
-- TOC entry 4796 (class 2604 OID 25290)
-- Name: supply_ingredient id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supply_ingredient ALTER COLUMN id SET DEFAULT nextval('public.supply_ingredient_id_seq'::regclass);


--
-- TOC entry 4791 (class 2604 OID 25257)
-- Name: table id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."table" ALTER COLUMN id SET DEFAULT nextval('public.table_id_seq'::regclass);


--
-- TOC entry 5017 (class 0 OID 25262)
-- Dependencies: 226
-- Data for Name: dish; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dish VALUES (1, 'Цезарь с курицей', 'Салат', 'Классический салат с курицей, пармезаном и соусом цезарь', 10);
INSERT INTO public.dish VALUES (2, 'Суп-пюре грибной', 'Суп', 'Нежный грибной суп со сливками', 15);
INSERT INTO public.dish VALUES (3, 'Стейк Рибай', 'Горячее', 'Мраморная говядина на гриле', 25);
INSERT INTO public.dish VALUES (4, 'Паста Карбонара', 'Горячее', 'Спагетти с беконом и сливочным соусом', 20);
INSERT INTO public.dish VALUES (5, 'Тирамису', 'Десерт', 'Классический итальянский десерт', 10);
INSERT INTO public.dish VALUES (6, 'Греческий салат', 'Салат', 'Салат с фетой, оливками и овощами', 8);


--
-- TOC entry 5009 (class 0 OID 25219)
-- Dependencies: 218
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employee VALUES (1, 'Иванов', 'Иван', 'Иванович', '1985-05-15', '+7-916-123-45-67');
INSERT INTO public.employee VALUES (2, 'Петрова', 'Екатерина', 'Алексеевна', '1990-08-22', '+7-915-234-56-78');
INSERT INTO public.employee VALUES (3, 'Сидоров', 'Алексей', 'Владимирович', '1988-03-10', '+7-917-345-67-89');
INSERT INTO public.employee VALUES (4, 'Кузнецова', 'Мария', 'Сергеевна', '1995-11-30', '+7-916-456-78-90');
INSERT INTO public.employee VALUES (5, 'Волков', 'Дмитрий', 'Николаевич', '1992-07-18', '+7-915-567-89-01');


--
-- TOC entry 5013 (class 0 OID 25243)
-- Dependencies: 222
-- Data for Name: employee_position; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.employee_position VALUES (1, 'Администратор', 1, 60000.00, '2020-01-10', NULL);
INSERT INTO public.employee_position VALUES (2, 'Официант', 2, 40000.00, '2021-03-15', NULL);
INSERT INTO public.employee_position VALUES (3, 'Повар', 3, 55000.00, '2019-11-20', NULL);
INSERT INTO public.employee_position VALUES (4, 'Официант', 4, 40000.00, '2022-02-01', NULL);
INSERT INTO public.employee_position VALUES (5, 'Повар', 5, 55000.00, '2021-07-10', NULL);


--
-- TOC entry 5019 (class 0 OID 25274)
-- Dependencies: 228
-- Data for Name: ingredient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredient VALUES (1, 'Куриное филе', 'Мясо', 25.500, 10.000, 165, 'кг', 3);
INSERT INTO public.ingredient VALUES (2, 'Салат Айсберг', 'Овощи', 5.000, 3.000, 15, 'кг', 5);
INSERT INTO public.ingredient VALUES (3, 'Пармезан', 'Молочные', 3.200, 2.000, 431, 'кг', 30);
INSERT INTO public.ingredient VALUES (4, 'Говядина Рибай', 'Мясо', 12.000, 8.000, 250, 'кг', 5);
INSERT INTO public.ingredient VALUES (5, 'Спагетти', 'Бакалея', 20.000, 10.000, 350, 'кг', 365);
INSERT INTO public.ingredient VALUES (6, 'Бекон', 'Мясо', 8.000, 4.000, 540, 'кг', 14);
INSERT INTO public.ingredient VALUES (7, 'Маскарпоне', 'Молочные', 5.000, 3.000, 429, 'кг', 14);
INSERT INTO public.ingredient VALUES (8, 'Грибы шампиньоны', 'Овощи', 10.000, 5.000, 22, 'кг', 5);
INSERT INTO public.ingredient VALUES (9, 'Сливки 33%', 'Молочные', 15.000, 8.000, 330, 'л', 7);


--
-- TOC entry 5023 (class 0 OID 25297)
-- Dependencies: 232
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."order" VALUES (1, 1, 2, '2026-04-22', '12:30:00', 'completed');
INSERT INTO public."order" VALUES (2, 3, 4, '2026-04-22', '13:15:00', 'active');
INSERT INTO public."order" VALUES (3, 5, 2, '2026-04-21', '19:00:00', 'paid');
INSERT INTO public."order" VALUES (4, 2, 4, '2026-04-22', '14:00:00', 'active');
INSERT INTO public."order" VALUES (5, 6, 2, '2026-04-20', '20:30:00', 'completed');


--
-- TOC entry 5025 (class 0 OID 25308)
-- Dependencies: 234
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_item VALUES (1, 1, 1, 3, 2, 'Без крутонов', 'served');
INSERT INTO public.order_item VALUES (2, 1, 3, 5, 1, 'Медиум прожарка', 'served');
INSERT INTO public.order_item VALUES (3, 2, 2, 3, 1, NULL, 'cooking');
INSERT INTO public.order_item VALUES (4, 2, 5, 5, 2, 'Больше какао', 'pending');
INSERT INTO public.order_item VALUES (5, 3, 4, 3, 1, 'Добавить пармезан', 'ready');
INSERT INTO public.order_item VALUES (6, 4, 6, NULL, 1, NULL, 'pending');
INSERT INTO public.order_item VALUES (7, 4, 1, 3, 1, NULL, 'cooking');
INSERT INTO public.order_item VALUES (8, 5, 3, 5, 2, 'Медиум-велл', 'served');
INSERT INTO public.order_item VALUES (9, 5, 5, 5, 1, NULL, 'served');


--
-- TOC entry 5011 (class 0 OID 25230)
-- Dependencies: 220
-- Data for Name: passport; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.passport VALUES (1, 1, '4501', '123456', '2010-06-20');
INSERT INTO public.passport VALUES (2, 2, '4502', '234567', '2011-09-15');
INSERT INTO public.passport VALUES (3, 3, '4503', '345678', '2009-12-10');
INSERT INTO public.passport VALUES (4, 4, '4504', '456789', '2013-05-25');
INSERT INTO public.passport VALUES (5, 5, '4505', '567890', '2012-08-14');


--
-- TOC entry 5027 (class 0 OID 25321)
-- Dependencies: 236
-- Data for Name: recipe; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.recipe VALUES (1, 1, 1, 0.150, 'кг');
INSERT INTO public.recipe VALUES (2, 1, 2, 0.100, 'кг');
INSERT INTO public.recipe VALUES (3, 1, 3, 0.030, 'кг');
INSERT INTO public.recipe VALUES (4, 2, 8, 0.200, 'кг');
INSERT INTO public.recipe VALUES (5, 2, 9, 0.100, 'л');
INSERT INTO public.recipe VALUES (6, 3, 4, 0.300, 'кг');
INSERT INTO public.recipe VALUES (7, 4, 5, 0.150, 'кг');
INSERT INTO public.recipe VALUES (8, 4, 6, 0.050, 'кг');
INSERT INTO public.recipe VALUES (9, 4, 9, 0.080, 'л');
INSERT INTO public.recipe VALUES (10, 5, 7, 0.120, 'кг');


--
-- TOC entry 5021 (class 0 OID 25287)
-- Dependencies: 230
-- Data for Name: supply_ingredient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.supply_ingredient VALUES (1, 1, '2026-04-20', 30.000, 350.00, '2026-04-23', 'Мясная Лавка');
INSERT INTO public.supply_ingredient VALUES (2, 2, '2026-04-21', 10.000, 120.00, '2026-04-26', 'Овощи-Фрукты');
INSERT INTO public.supply_ingredient VALUES (3, 4, '2026-04-19', 15.000, 1200.00, '2026-04-24', 'Мясная Лавка');
INSERT INTO public.supply_ingredient VALUES (4, 6, '2026-04-20', 10.000, 450.00, '2026-05-04', 'Мясная Лавка');
INSERT INTO public.supply_ingredient VALUES (5, 8, '2026-04-21', 12.000, 180.00, '2026-04-26', 'Грибной Рай');


--
-- TOC entry 5015 (class 0 OID 25254)
-- Dependencies: 224
-- Data for Name: table; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."table" VALUES (1, 2, 'У окна');
INSERT INTO public."table" VALUES (2, 4, 'У окна');
INSERT INTO public."table" VALUES (3, 4, 'В центре зала');
INSERT INTO public."table" VALUES (4, 6, 'В центре зала');
INSERT INTO public."table" VALUES (5, 2, 'У стены');
INSERT INTO public."table" VALUES (6, 8, 'VIP-зона');


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 225
-- Name: dish_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dish_id_seq', 6, true);


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 217
-- Name: employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_id_seq', 5, true);


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 221
-- Name: employee_position_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_position_id_seq', 5, true);


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 227
-- Name: ingredient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredient_id_seq', 9, true);


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 231
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_id_seq', 5, true);


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 233
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_item_id_seq', 9, true);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 219
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passport_id_seq', 5, true);


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 235
-- Name: recipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipe_id_seq', 10, true);


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 229
-- Name: supply_ingredient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supply_ingredient_id_seq', 5, true);


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 223
-- Name: table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.table_id_seq', 6, true);


--
-- TOC entry 4838 (class 2606 OID 25271)
-- Name: dish dish_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dish
    ADD CONSTRAINT dish_name_key UNIQUE (name);


--
-- TOC entry 4840 (class 2606 OID 25269)
-- Name: dish dish_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dish
    ADD CONSTRAINT dish_pkey PRIMARY KEY (id);


--
-- TOC entry 4823 (class 2606 OID 25226)
-- Name: employee employee_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_phone_key UNIQUE (phone);


--
-- TOC entry 4825 (class 2606 OID 25224)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 25249)
-- Name: employee_position employee_position_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_position
    ADD CONSTRAINT employee_position_pkey PRIMARY KEY (id);


--
-- TOC entry 4842 (class 2606 OID 25283)
-- Name: ingredient ingredient_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient
    ADD CONSTRAINT ingredient_name_key UNIQUE (name);


--
-- TOC entry 4844 (class 2606 OID 25281)
-- Name: ingredient ingredient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredient
    ADD CONSTRAINT ingredient_pkey PRIMARY KEY (id);


--
-- TOC entry 4850 (class 2606 OID 25317)
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4848 (class 2606 OID 25305)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 25237)
-- Name: passport passport_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passport
    ADD CONSTRAINT passport_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 4829 (class 2606 OID 25235)
-- Name: passport passport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY (id);


--
-- TOC entry 4852 (class 2606 OID 25326)
-- Name: recipe recipe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe
    ADD CONSTRAINT recipe_pkey PRIMARY KEY (id);


--
-- TOC entry 4846 (class 2606 OID 25293)
-- Name: supply_ingredient supply_ingredient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supply_ingredient
    ADD CONSTRAINT supply_ingredient_pkey PRIMARY KEY (id);


--
-- TOC entry 4836 (class 2606 OID 25259)
-- Name: table table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT table_pkey PRIMARY KEY (id);


--
-- TOC entry 4831 (class 2606 OID 25241)
-- Name: passport uk_passport_series_number; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passport
    ADD CONSTRAINT uk_passport_series_number UNIQUE (series, number);


--
-- TOC entry 4834 (class 1259 OID 25252)
-- Name: uk_employee_active_position; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uk_employee_active_position ON public.employee_position USING btree (employee_id) WHERE (end_date IS NULL);


--
-- TOC entry 4854 (class 2606 OID 25333)
-- Name: employee_position fk_employee_position_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_position
    ADD CONSTRAINT fk_employee_position_employee FOREIGN KEY (employee_id) REFERENCES public.employee(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4856 (class 2606 OID 25343)
-- Name: order fk_order_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT fk_order_employee FOREIGN KEY (employee_id) REFERENCES public.employee(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4858 (class 2606 OID 25358)
-- Name: order_item fk_order_item_cook; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT fk_order_item_cook FOREIGN KEY (cook_id) REFERENCES public.employee(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4859 (class 2606 OID 25353)
-- Name: order_item fk_order_item_dish; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT fk_order_item_dish FOREIGN KEY (dish_id) REFERENCES public.dish(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4860 (class 2606 OID 25348)
-- Name: order_item fk_order_item_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4857 (class 2606 OID 25338)
-- Name: order fk_order_table; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT fk_order_table FOREIGN KEY (table_id) REFERENCES public."table"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4853 (class 2606 OID 25328)
-- Name: passport fk_passport_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passport
    ADD CONSTRAINT fk_passport_employee FOREIGN KEY (employee_id) REFERENCES public.employee(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4861 (class 2606 OID 25368)
-- Name: recipe fk_recipe_dish; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe
    ADD CONSTRAINT fk_recipe_dish FOREIGN KEY (dish_id) REFERENCES public.dish(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4862 (class 2606 OID 25373)
-- Name: recipe fk_recipe_ingredient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipe
    ADD CONSTRAINT fk_recipe_ingredient FOREIGN KEY (ingredient_id) REFERENCES public.ingredient(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4855 (class 2606 OID 25363)
-- Name: supply_ingredient fk_supply_ingredient; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supply_ingredient
    ADD CONSTRAINT fk_supply_ingredient FOREIGN KEY (ingredient_id) REFERENCES public.ingredient(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2026-04-22 14:06:14

--
-- PostgreSQL database dump complete
--

\unrestrict sCmHlU96ARPftPXej8nvO0mIHidN99pfs7vYpgtdJciqe5XpKcn9eKDQNBK24Jp

