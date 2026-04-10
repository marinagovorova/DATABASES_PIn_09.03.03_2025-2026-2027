--
-- PostgreSQL database dump
--

\restrict m9DyZj9mpviq98vcTqAqazTdmGt6aA60lC3pOj8fbXC8bbwKfaqrMrnONGoW5G5

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

-- Started on 2026-04-10 09:52:30

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
-- TOC entry 5240 (class 1262 OID 16407)
-- Name: db_restaurant; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE db_restaurant WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


\unrestrict m9DyZj9mpviq98vcTqAqazTdmGt6aA60lC3pOj8fbXC8bbwKfaqrMrnONGoW5G5
\connect db_restaurant
\restrict m9DyZj9mpviq98vcTqAqazTdmGt6aA60lC3pOj8fbXC8bbwKfaqrMrnONGoW5G5

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 250 (class 1259 OID 16632)
-- Name: dish; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dish (
    id_dish integer NOT NULL,
    dish_name character varying(50) NOT NULL,
    id_category integer NOT NULL,
    dish_code character(6) NOT NULL,
    recipe text NOT NULL,
    CONSTRAINT dish_code_latin_numbers CHECK ((dish_code ~ '^[A-Za-z0-9]+$'::text)),
    CONSTRAINT dish_name_cyrillic CHECK (((dish_name)::text ~ '^[А-Яа-яЁё ]+$'::text)),
    CONSTRAINT recipe_text CHECK ((recipe ~ '^[А-Яа-яЁё0-9 ,\.]+$'::text))
);


--
-- TOC entry 260 (class 1259 OID 24597)
-- Name: dish_order; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dish_order (
    id_dish_order bigint NOT NULL,
    id_dish integer NOT NULL,
    id_employee integer NOT NULL,
    id_order bigint NOT NULL,
    wishes text,
    dish_number integer DEFAULT 1 NOT NULL,
    CONSTRAINT dish_number_greater_than_zero CHECK ((dish_number > 0)),
    CONSTRAINT wishes_text_cyrillic CHECK ((wishes ~ '^[А-Яа-яЁё0-9 ,\.]+$'::text))
);


--
-- TOC entry 229 (class 1259 OID 16482)
-- Name: employee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee (
    id_employee integer NOT NULL,
    employee_number character varying(10) NOT NULL,
    surname character varying(20) NOT NULL,
    name character varying(20) NOT NULL,
    patronymic character varying(20),
    passport_series character(4) NOT NULL,
    passport_num character(6) NOT NULL,
    issued_by character varying(60) NOT NULL,
    issue_date date NOT NULL,
    birth_date date NOT NULL,
    valid_for date,
    entry_date date NOT NULL,
    CONSTRAINT employee_number_latin_numbers CHECK (((employee_number)::text ~ '^[A-Za-z0-9]+$'::text)),
    CONSTRAINT name_cyrillic_latin CHECK (((name)::text ~ '^[A-Za-zА-Яа-яЁё\- ]+$'::text)),
    CONSTRAINT patronymic_cyrillic_latin CHECK (((patronymic)::text ~ '^[A-Za-zА-Яа-яЁё\- ]+$'::text)),
    CONSTRAINT surname_cyrillic_latin CHECK (((surname)::text ~ '^[A-Za-zА-Яа-яЁё\- ]+$'::text))
);


--
-- TOC entry 238 (class 1259 OID 16520)
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id_order bigint NOT NULL,
    id_employee_shift bigint NOT NULL,
    order_code character(10) NOT NULL,
    order_time timestamp without time zone NOT NULL,
    id_reserv bigint NOT NULL,
    id_table_shift bigint NOT NULL,
    order_cost money NOT NULL,
    CONSTRAINT order_code_latin_numbers CHECK ((order_code ~ '^[A-Za-z0-9]+$'::text))
);


--
-- TOC entry 252 (class 1259 OID 16645)
-- Name: dish_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dish_category (
    id_category integer NOT NULL,
    category_name character varying(30) NOT NULL,
    CONSTRAINT category_name_cyrillic CHECK (((category_name)::text ~ '^[А-Яа-яЁё ]+$'::text))
);


--
-- TOC entry 251 (class 1259 OID 16644)
-- Name: dish_category_id_category_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_category_id_category_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 251
-- Name: dish_category_id_category_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_category_id_category_seq OWNED BY public.dish_category.id_category;


--
-- TOC entry 279 (class 1259 OID 24764)
-- Name: dish_employee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dish_employee (
    id_dish_employee integer NOT NULL,
    id_dish integer NOT NULL,
    id_employee integer NOT NULL,
    cooking_level character varying(20) NOT NULL,
    CONSTRAINT cooking_level_cyrillic CHECK (((cooking_level)::text ~ '^[А-Яа-яЁё ]+$'::text))
);


--
-- TOC entry 276 (class 1259 OID 24761)
-- Name: dish_employee_id_dish_employee_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_employee_id_dish_employee_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 276
-- Name: dish_employee_id_dish_employee_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_employee_id_dish_employee_seq OWNED BY public.dish_employee.id_dish_employee;


--
-- TOC entry 277 (class 1259 OID 24762)
-- Name: dish_employee_id_dish_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_employee_id_dish_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 277
-- Name: dish_employee_id_dish_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_employee_id_dish_seq OWNED BY public.dish_employee.id_dish;


--
-- TOC entry 278 (class 1259 OID 24763)
-- Name: dish_employee_id_employee_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_employee_id_employee_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 278
-- Name: dish_employee_id_employee_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_employee_id_employee_seq OWNED BY public.dish_employee.id_employee;


--
-- TOC entry 249 (class 1259 OID 16631)
-- Name: dish_id_category_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_id_category_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 249
-- Name: dish_id_category_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_id_category_seq OWNED BY public.dish.id_category;


--
-- TOC entry 248 (class 1259 OID 16630)
-- Name: dish_id_dish_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_id_dish_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 248
-- Name: dish_id_dish_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_id_dish_seq OWNED BY public.dish.id_dish;


--
-- TOC entry 271 (class 1259 OID 24706)
-- Name: ingredient_dish; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ingredient_dish (
    id_ingredient_dish bigint NOT NULL,
    id_dish integer NOT NULL,
    id_product integer NOT NULL,
    ingredient_value numeric NOT NULL,
    measurement_units character varying(20) NOT NULL,
    CONSTRAINT ingredient_value_greater_than_zero CHECK ((ingredient_value > (0)::numeric))
);


--
-- TOC entry 283 (class 1259 OID 65565)
-- Name: supply_product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supply_product (
    id_product_supply bigint NOT NULL,
    id_product integer NOT NULL,
    id_supply integer NOT NULL,
    quantity numeric NOT NULL,
    origin_country character varying(30) NOT NULL,
    calorie_content numeric NOT NULL,
    producter character varying(60) NOT NULL,
    status character varying(20) NOT NULL,
    price money NOT NULL,
    production_time timestamp without time zone NOT NULL,
    expiration_time timestamp without time zone NOT NULL
);


--
-- TOC entry 256 (class 1259 OID 24593)
-- Name: dish_order_id_dish_order_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_order_id_dish_order_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 256
-- Name: dish_order_id_dish_order_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_order_id_dish_order_seq OWNED BY public.dish_order.id_dish_order;


--
-- TOC entry 257 (class 1259 OID 24594)
-- Name: dish_order_id_dish_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_order_id_dish_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 257
-- Name: dish_order_id_dish_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_order_id_dish_seq OWNED BY public.dish_order.id_dish;


--
-- TOC entry 258 (class 1259 OID 24595)
-- Name: dish_order_id_employee_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_order_id_employee_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 258
-- Name: dish_order_id_employee_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_order_id_employee_seq OWNED BY public.dish_order.id_employee;


--
-- TOC entry 259 (class 1259 OID 24596)
-- Name: dish_order_id_order_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_order_id_order_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 259
-- Name: dish_order_id_order_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_order_id_order_seq OWNED BY public.dish_order.id_order;


--
-- TOC entry 255 (class 1259 OID 24585)
-- Name: dish_price; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dish_price (
    id_dish_price integer NOT NULL,
    id_dish integer NOT NULL,
    change_date date NOT NULL,
    dish_price money NOT NULL,
    CONSTRAINT dish_price_greater_than_zero CHECK ((dish_price > money(0)))
);


--
-- TOC entry 253 (class 1259 OID 24583)
-- Name: dish_price_id_dish_price_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_price_id_dish_price_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 253
-- Name: dish_price_id_dish_price_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_price_id_dish_price_seq OWNED BY public.dish_price.id_dish_price;


--
-- TOC entry 254 (class 1259 OID 24584)
-- Name: dish_price_id_dish_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dish_price_id_dish_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 254
-- Name: dish_price_id_dish_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dish_price_id_dish_seq OWNED BY public.dish_price.id_dish;


--
-- TOC entry 228 (class 1259 OID 16481)
-- Name: employee_id_employee_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employee_id_employee_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 228
-- Name: employee_id_employee_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_id_employee_seq OWNED BY public.employee.id_employee;


--
-- TOC entry 233 (class 1259 OID 16497)
-- Name: employee_shift; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_shift (
    id_employee_shift bigint NOT NULL,
    id_shift bigint NOT NULL,
    id_employee integer NOT NULL,
    employee_status character varying(20) NOT NULL,
    CONSTRAINT employee_status CHECK (((employee_status)::text = ANY ((ARRAY['на смене'::character varying, 'не вышел'::character varying])::text[])))
);


--
-- TOC entry 232 (class 1259 OID 16496)
-- Name: employee_shift_id_employee_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employee_shift_id_employee_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 232
-- Name: employee_shift_id_employee_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_shift_id_employee_seq OWNED BY public.employee_shift.id_employee;


--
-- TOC entry 230 (class 1259 OID 16494)
-- Name: employee_shift_id_employee_shift_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employee_shift_id_employee_shift_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 230
-- Name: employee_shift_id_employee_shift_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_shift_id_employee_shift_seq OWNED BY public.employee_shift.id_employee_shift;


--
-- TOC entry 231 (class 1259 OID 16495)
-- Name: employee_shift_id_shift_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employee_shift_id_shift_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 231
-- Name: employee_shift_id_shift_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_shift_id_shift_seq OWNED BY public.employee_shift.id_shift;


--
-- TOC entry 247 (class 1259 OID 16608)
-- Name: employment_contract; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employment_contract (
    id_employment_contract integer NOT NULL,
    id_job integer NOT NULL,
    id_employee integer NOT NULL,
    rate numeric DEFAULT 1 NOT NULL,
    conclution_date date NOT NULL,
    contract_type character varying(20) NOT NULL,
    CONSTRAINT rate_greater_than_zero CHECK ((rate > (0)::numeric))
);


--
-- TOC entry 246 (class 1259 OID 16607)
-- Name: employment_contract_id_employee_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employment_contract_id_employee_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 246
-- Name: employment_contract_id_employee_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employment_contract_id_employee_seq OWNED BY public.employment_contract.id_employee;


--
-- TOC entry 244 (class 1259 OID 16605)
-- Name: employment_contract_id_employment_contract_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employment_contract_id_employment_contract_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 244
-- Name: employment_contract_id_employment_contract_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employment_contract_id_employment_contract_seq OWNED BY public.employment_contract.id_employment_contract;


--
-- TOC entry 245 (class 1259 OID 16606)
-- Name: employment_contract_id_job_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employment_contract_id_job_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 245
-- Name: employment_contract_id_job_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employment_contract_id_job_seq OWNED BY public.employment_contract.id_job;


--
-- TOC entry 269 (class 1259 OID 24704)
-- Name: id_ingredient_dish_id_dish_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.id_ingredient_dish_id_dish_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 269
-- Name: id_ingredient_dish_id_dish_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.id_ingredient_dish_id_dish_seq OWNED BY public.ingredient_dish.id_dish;


--
-- TOC entry 268 (class 1259 OID 24703)
-- Name: id_ingredient_dish_id_ingredient_dish_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.id_ingredient_dish_id_ingredient_dish_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 268
-- Name: id_ingredient_dish_id_ingredient_dish_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.id_ingredient_dish_id_ingredient_dish_seq OWNED BY public.ingredient_dish.id_ingredient_dish;


--
-- TOC entry 270 (class 1259 OID 24705)
-- Name: id_ingredient_dish_id_product_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.id_ingredient_dish_id_product_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 270
-- Name: id_ingredient_dish_id_product_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.id_ingredient_dish_id_product_seq OWNED BY public.ingredient_dish.id_product;


--
-- TOC entry 243 (class 1259 OID 16596)
-- Name: job; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job (
    id_job integer NOT NULL,
    job_title character varying(20) NOT NULL,
    salary money NOT NULL,
    CONSTRAINT job_title_list CHECK (((job_title)::text = ANY ((ARRAY['Повар'::character varying, 'Шеф-повар'::character varying, 'Кассир'::character varying, 'Официант'::character varying, 'Менеджер'::character varying])::text[]))),
    CONSTRAINT salary_greater_than_zero CHECK ((salary > money(0)))
);


--
-- TOC entry 242 (class 1259 OID 16595)
-- Name: job_id_job_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_id_job_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 242
-- Name: job_id_job_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_id_job_seq OWNED BY public.job.id_job;


--
-- TOC entry 235 (class 1259 OID 16517)
-- Name: order_id_employee_shift_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_id_employee_shift_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 235
-- Name: order_id_employee_shift_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_id_employee_shift_seq OWNED BY public.orders.id_employee_shift;


--
-- TOC entry 234 (class 1259 OID 16516)
-- Name: order_id_order_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_id_order_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 234
-- Name: order_id_order_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_id_order_seq OWNED BY public.orders.id_order;


--
-- TOC entry 236 (class 1259 OID 16518)
-- Name: order_id_reserv_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_id_reserv_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 236
-- Name: order_id_reserv_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_id_reserv_seq OWNED BY public.orders.id_reserv;


--
-- TOC entry 237 (class 1259 OID 16519)
-- Name: order_id_table_shift_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_id_table_shift_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 237
-- Name: order_id_table_shift_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_id_table_shift_seq OWNED BY public.orders.id_table_shift;


--
-- TOC entry 241 (class 1259 OID 16556)
-- Name: order_status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_status (
    id_order_status bigint NOT NULL,
    change_time timestamp with time zone NOT NULL,
    id_order bigint NOT NULL,
    status_name character varying(20) NOT NULL
);


--
-- TOC entry 240 (class 1259 OID 16555)
-- Name: order_status_id_order_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_status_id_order_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 240
-- Name: order_status_id_order_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_status_id_order_seq OWNED BY public.order_status.id_order;


--
-- TOC entry 239 (class 1259 OID 16554)
-- Name: order_status_id_order_status_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_status_id_order_status_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 239
-- Name: order_status_id_order_status_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_status_id_order_status_seq OWNED BY public.order_status.id_order_status;


--
-- TOC entry 264 (class 1259 OID 24636)
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product (
    id_product integer NOT NULL,
    min_stock numeric NOT NULL,
    product_name character varying(50) NOT NULL,
    current_stock numeric NOT NULL,
    storage_conditions text,
    product_code character(6) NOT NULL,
    id_product_type integer NOT NULL,
    CONSTRAINT current_stock_greater_than_zero CHECK ((current_stock > (0)::numeric)),
    CONSTRAINT min_stock_greater_than_zero CHECK ((min_stock > (0)::numeric)),
    CONSTRAINT product_code_latin_numbers CHECK ((product_code ~ '^[A-Za-z0-9]+$'::text)),
    CONSTRAINT product_name_cyrillic CHECK (((product_name)::text ~ '^[А-Яа-яЁё ]+$'::text))
);


--
-- TOC entry 263 (class 1259 OID 24634)
-- Name: product_id_product_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_id_product_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 263
-- Name: product_id_product_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_id_product_seq OWNED BY public.product.id_product;


--
-- TOC entry 265 (class 1259 OID 24672)
-- Name: product_id_product_type_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_id_product_type_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 265
-- Name: product_id_product_type_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_id_product_type_seq OWNED BY public.product.id_product_type;


--
-- TOC entry 262 (class 1259 OID 24627)
-- Name: product_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_type (
    id_product_type integer NOT NULL,
    type_name character varying(50) NOT NULL
);


--
-- TOC entry 261 (class 1259 OID 24626)
-- Name: product_type_id_product_type_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_type_id_product_type_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 261
-- Name: product_type_id_product_type_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_type_id_product_type_seq OWNED BY public.product_type.id_product_type;


--
-- TOC entry 275 (class 1259 OID 24740)
-- Name: replacement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.replacement (
    id_replacement integer NOT NULL,
    id_product integer NOT NULL,
    id_ingredient_dish bigint NOT NULL,
    replacement_value numeric NOT NULL,
    CONSTRAINT replacement_value_greater_than_zero CHECK ((replacement_value > (0)::numeric))
);


--
-- TOC entry 274 (class 1259 OID 24739)
-- Name: replacement_id_ingredient_dish_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.replacement_id_ingredient_dish_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 274
-- Name: replacement_id_ingredient_dish_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.replacement_id_ingredient_dish_seq OWNED BY public.replacement.id_ingredient_dish;


--
-- TOC entry 273 (class 1259 OID 24738)
-- Name: replacement_id_product_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.replacement_id_product_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 273
-- Name: replacement_id_product_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.replacement_id_product_seq OWNED BY public.replacement.id_product;


--
-- TOC entry 272 (class 1259 OID 24737)
-- Name: replacement_id_replacement_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.replacement_id_replacement_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 272
-- Name: replacement_id_replacement_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.replacement_id_replacement_seq OWNED BY public.replacement.id_replacement;


--
-- TOC entry 221 (class 1259 OID 16438)
-- Name: reservation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reservation (
    id_reserv bigint NOT NULL,
    client_name character varying(20) NOT NULL,
    reserv_time time without time zone,
    person_q integer,
    phone_num character varying(15),
    wishes text,
    reserv_date date,
    CONSTRAINT client_name_cyrillic CHECK (((client_name)::text ~ '^[A-Za-zА-Яа-яЁё\- ]+$'::text))
);


--
-- TOC entry 220 (class 1259 OID 16436)
-- Name: reservation_id_reserv_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reservation_id_reserv_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 220
-- Name: reservation_id_reserv_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reservation_id_reserv_seq OWNED BY public.reservation.id_reserv;


--
-- TOC entry 223 (class 1259 OID 16453)
-- Name: shift; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shift (
    id_shift bigint NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone
);


--
-- TOC entry 222 (class 1259 OID 16452)
-- Name: shift_id_shift_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shift_id_shift_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 222
-- Name: shift_id_shift_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shift_id_shift_seq OWNED BY public.shift.id_shift;


--
-- TOC entry 267 (class 1259 OID 24683)
-- Name: supply; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supply (
    id_supply bigint NOT NULL,
    supply_price money NOT NULL,
    supplier character varying(50) NOT NULL,
    receipt_date timestamp without time zone NOT NULL,
    supply_status character varying,
    CONSTRAINT supplier_cyrillic_latin CHECK (((supplier)::text ~ '^[А-Яа-яЁёA-Za-z ]+$'::text))
);


--
-- TOC entry 266 (class 1259 OID 24681)
-- Name: supply_id_supply_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.supply_id_supply_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 266
-- Name: supply_id_supply_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.supply_id_supply_seq OWNED BY public.supply.id_supply;


--
-- TOC entry 281 (class 1259 OID 65563)
-- Name: supply_product_id_product_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.supply_product_id_product_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 281
-- Name: supply_product_id_product_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.supply_product_id_product_seq OWNED BY public.supply_product.id_product;


--
-- TOC entry 280 (class 1259 OID 65562)
-- Name: supply_product_id_product_supply_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.supply_product_id_product_supply_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 280
-- Name: supply_product_id_product_supply_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.supply_product_id_product_supply_seq OWNED BY public.supply_product.id_product_supply;


--
-- TOC entry 282 (class 1259 OID 65564)
-- Name: supply_product_id_supply_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.supply_product_id_supply_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 282
-- Name: supply_product_id_supply_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.supply_product_id_supply_seq OWNED BY public.supply_product.id_supply;


--
-- TOC entry 216 (class 1259 OID 16409)
-- Name: tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tables (
    id_table integer NOT NULL,
    table_number integer NOT NULL,
    location text NOT NULL,
    seats_number integer NOT NULL,
    room_number integer NOT NULL,
    status character varying(20),
    CONSTRAINT location_is_cyrillic_text CHECK ((location ~ '^[А-Яа-яЁё0-9 ,\.]+$'::text)),
    CONSTRAINT room_num_natural CHECK ((room_number > 0)),
    CONSTRAINT seats_num_between_1_and_10 CHECK (((seats_number >= 1) AND (seats_number <= 10))),
    CONSTRAINT table_num_natural CHECK ((table_number > 0))
);


--
-- TOC entry 215 (class 1259 OID 16408)
-- Name: table_id_table_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.table_id_table_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 215
-- Name: table_id_table_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.table_id_table_seq OWNED BY public.tables.id_table;


--
-- TOC entry 227 (class 1259 OID 16463)
-- Name: tables_shift; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tables_shift (
    id_table_shift bigint NOT NULL,
    id_table integer NOT NULL,
    id_shift bigint NOT NULL,
    id_employee_shift bigint NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 16462)
-- Name: table_shift_id_shift_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.table_shift_id_shift_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 226
-- Name: table_shift_id_shift_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.table_shift_id_shift_seq OWNED BY public.tables_shift.id_shift;


--
-- TOC entry 225 (class 1259 OID 16461)
-- Name: table_shift_id_table_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.table_shift_id_table_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 225
-- Name: table_shift_id_table_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.table_shift_id_table_seq OWNED BY public.tables_shift.id_table;


--
-- TOC entry 224 (class 1259 OID 16460)
-- Name: table_shift_id_table_shift_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.table_shift_id_table_shift_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 224
-- Name: table_shift_id_table_shift_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.table_shift_id_table_shift_seq OWNED BY public.tables_shift.id_table_shift;


--
-- TOC entry 219 (class 1259 OID 16423)
-- Name: table_status; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.table_status (
    id_table_status bigint NOT NULL,
    id_table integer NOT NULL,
    status_name character varying(20) NOT NULL,
    change_time timestamp with time zone NOT NULL,
    CONSTRAINT status_name_in_list CHECK (((status_name)::text = ANY ((ARRAY['свободен'::character varying, 'занят'::character varying, 'забронирован'::character varying])::text[])))
);


--
-- TOC entry 218 (class 1259 OID 16422)
-- Name: table_status_id_table_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.table_status_id_table_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 218
-- Name: table_status_id_table_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.table_status_id_table_seq OWNED BY public.table_status.id_table;


--
-- TOC entry 217 (class 1259 OID 16421)
-- Name: table_status_id_table_status_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.table_status_id_table_status_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 217
-- Name: table_status_id_table_status_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.table_status_id_table_status_seq OWNED BY public.table_status.id_table_status;


--
-- TOC entry 284 (class 1259 OID 81920)
-- Name: tables_shift_id_employee_shift_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tables_shift_id_employee_shift_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 284
-- Name: tables_shift_id_employee_shift_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tables_shift_id_employee_shift_seq OWNED BY public.tables_shift.id_employee_shift;


--
-- TOC entry 4874 (class 2604 OID 16635)
-- Name: dish id_dish; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish ALTER COLUMN id_dish SET DEFAULT nextval('public.dish_id_dish_seq'::regclass);


--
-- TOC entry 4875 (class 2604 OID 16636)
-- Name: dish id_category; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish ALTER COLUMN id_category SET DEFAULT nextval('public.dish_id_category_seq'::regclass);


--
-- TOC entry 4876 (class 2604 OID 16648)
-- Name: dish_category id_category; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_category ALTER COLUMN id_category SET DEFAULT nextval('public.dish_category_id_category_seq'::regclass);


--
-- TOC entry 4894 (class 2604 OID 24767)
-- Name: dish_employee id_dish_employee; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_employee ALTER COLUMN id_dish_employee SET DEFAULT nextval('public.dish_employee_id_dish_employee_seq'::regclass);


--
-- TOC entry 4895 (class 2604 OID 24768)
-- Name: dish_employee id_dish; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_employee ALTER COLUMN id_dish SET DEFAULT nextval('public.dish_employee_id_dish_seq'::regclass);


--
-- TOC entry 4896 (class 2604 OID 24769)
-- Name: dish_employee id_employee; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_employee ALTER COLUMN id_employee SET DEFAULT nextval('public.dish_employee_id_employee_seq'::regclass);


--
-- TOC entry 4879 (class 2604 OID 24600)
-- Name: dish_order id_dish_order; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_order ALTER COLUMN id_dish_order SET DEFAULT nextval('public.dish_order_id_dish_order_seq'::regclass);


--
-- TOC entry 4880 (class 2604 OID 24601)
-- Name: dish_order id_dish; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_order ALTER COLUMN id_dish SET DEFAULT nextval('public.dish_order_id_dish_seq'::regclass);


--
-- TOC entry 4881 (class 2604 OID 24602)
-- Name: dish_order id_employee; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_order ALTER COLUMN id_employee SET DEFAULT nextval('public.dish_order_id_employee_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 24603)
-- Name: dish_order id_order; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_order ALTER COLUMN id_order SET DEFAULT nextval('public.dish_order_id_order_seq'::regclass);


--
-- TOC entry 4877 (class 2604 OID 24588)
-- Name: dish_price id_dish_price; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_price ALTER COLUMN id_dish_price SET DEFAULT nextval('public.dish_price_id_dish_price_seq'::regclass);


--
-- TOC entry 4878 (class 2604 OID 24589)
-- Name: dish_price id_dish; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_price ALTER COLUMN id_dish SET DEFAULT nextval('public.dish_price_id_dish_seq'::regclass);


--
-- TOC entry 4859 (class 2604 OID 16485)
-- Name: employee id_employee; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee ALTER COLUMN id_employee SET DEFAULT nextval('public.employee_id_employee_seq'::regclass);


--
-- TOC entry 4860 (class 2604 OID 16500)
-- Name: employee_shift id_employee_shift; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_shift ALTER COLUMN id_employee_shift SET DEFAULT nextval('public.employee_shift_id_employee_shift_seq'::regclass);


--
-- TOC entry 4861 (class 2604 OID 16501)
-- Name: employee_shift id_shift; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_shift ALTER COLUMN id_shift SET DEFAULT nextval('public.employee_shift_id_shift_seq'::regclass);


--
-- TOC entry 4862 (class 2604 OID 16502)
-- Name: employee_shift id_employee; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_shift ALTER COLUMN id_employee SET DEFAULT nextval('public.employee_shift_id_employee_seq'::regclass);


--
-- TOC entry 4870 (class 2604 OID 16611)
-- Name: employment_contract id_employment_contract; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employment_contract ALTER COLUMN id_employment_contract SET DEFAULT nextval('public.employment_contract_id_employment_contract_seq'::regclass);


--
-- TOC entry 4871 (class 2604 OID 16612)
-- Name: employment_contract id_job; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employment_contract ALTER COLUMN id_job SET DEFAULT nextval('public.employment_contract_id_job_seq'::regclass);


--
-- TOC entry 4872 (class 2604 OID 16613)
-- Name: employment_contract id_employee; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employment_contract ALTER COLUMN id_employee SET DEFAULT nextval('public.employment_contract_id_employee_seq'::regclass);


--
-- TOC entry 4888 (class 2604 OID 24709)
-- Name: ingredient_dish id_ingredient_dish; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredient_dish ALTER COLUMN id_ingredient_dish SET DEFAULT nextval('public.id_ingredient_dish_id_ingredient_dish_seq'::regclass);


--
-- TOC entry 4889 (class 2604 OID 24710)
-- Name: ingredient_dish id_dish; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredient_dish ALTER COLUMN id_dish SET DEFAULT nextval('public.id_ingredient_dish_id_dish_seq'::regclass);


--
-- TOC entry 4890 (class 2604 OID 24711)
-- Name: ingredient_dish id_product; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredient_dish ALTER COLUMN id_product SET DEFAULT nextval('public.id_ingredient_dish_id_product_seq'::regclass);


--
-- TOC entry 4869 (class 2604 OID 16599)
-- Name: job id_job; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job ALTER COLUMN id_job SET DEFAULT nextval('public.job_id_job_seq'::regclass);


--
-- TOC entry 4867 (class 2604 OID 16559)
-- Name: order_status id_order_status; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_status ALTER COLUMN id_order_status SET DEFAULT nextval('public.order_status_id_order_status_seq'::regclass);


--
-- TOC entry 4868 (class 2604 OID 16560)
-- Name: order_status id_order; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_status ALTER COLUMN id_order SET DEFAULT nextval('public.order_status_id_order_seq'::regclass);


--
-- TOC entry 4863 (class 2604 OID 16523)
-- Name: orders id_order; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id_order SET DEFAULT nextval('public.order_id_order_seq'::regclass);


--
-- TOC entry 4864 (class 2604 OID 16524)
-- Name: orders id_employee_shift; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id_employee_shift SET DEFAULT nextval('public.order_id_employee_shift_seq'::regclass);


--
-- TOC entry 4865 (class 2604 OID 16525)
-- Name: orders id_reserv; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id_reserv SET DEFAULT nextval('public.order_id_reserv_seq'::regclass);


--
-- TOC entry 4866 (class 2604 OID 16526)
-- Name: orders id_table_shift; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id_table_shift SET DEFAULT nextval('public.order_id_table_shift_seq'::regclass);


--
-- TOC entry 4885 (class 2604 OID 24639)
-- Name: product id_product; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product ALTER COLUMN id_product SET DEFAULT nextval('public.product_id_product_seq'::regclass);


--
-- TOC entry 4886 (class 2604 OID 24673)
-- Name: product id_product_type; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product ALTER COLUMN id_product_type SET DEFAULT nextval('public.product_id_product_type_seq'::regclass);


--
-- TOC entry 4884 (class 2604 OID 24630)
-- Name: product_type id_product_type; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_type ALTER COLUMN id_product_type SET DEFAULT nextval('public.product_type_id_product_type_seq'::regclass);


--
-- TOC entry 4891 (class 2604 OID 24743)
-- Name: replacement id_replacement; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.replacement ALTER COLUMN id_replacement SET DEFAULT nextval('public.replacement_id_replacement_seq'::regclass);


--
-- TOC entry 4892 (class 2604 OID 24744)
-- Name: replacement id_product; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.replacement ALTER COLUMN id_product SET DEFAULT nextval('public.replacement_id_product_seq'::regclass);


--
-- TOC entry 4893 (class 2604 OID 24745)
-- Name: replacement id_ingredient_dish; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.replacement ALTER COLUMN id_ingredient_dish SET DEFAULT nextval('public.replacement_id_ingredient_dish_seq'::regclass);


--
-- TOC entry 4853 (class 2604 OID 16441)
-- Name: reservation id_reserv; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation ALTER COLUMN id_reserv SET DEFAULT nextval('public.reservation_id_reserv_seq'::regclass);


--
-- TOC entry 4854 (class 2604 OID 16456)
-- Name: shift id_shift; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift ALTER COLUMN id_shift SET DEFAULT nextval('public.shift_id_shift_seq'::regclass);


--
-- TOC entry 4887 (class 2604 OID 24686)
-- Name: supply id_supply; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply ALTER COLUMN id_supply SET DEFAULT nextval('public.supply_id_supply_seq'::regclass);


--
-- TOC entry 4897 (class 2604 OID 65568)
-- Name: supply_product id_product_supply; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_product ALTER COLUMN id_product_supply SET DEFAULT nextval('public.supply_product_id_product_supply_seq'::regclass);


--
-- TOC entry 4898 (class 2604 OID 65569)
-- Name: supply_product id_product; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_product ALTER COLUMN id_product SET DEFAULT nextval('public.supply_product_id_product_seq'::regclass);


--
-- TOC entry 4899 (class 2604 OID 65570)
-- Name: supply_product id_supply; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_product ALTER COLUMN id_supply SET DEFAULT nextval('public.supply_product_id_supply_seq'::regclass);


--
-- TOC entry 4851 (class 2604 OID 16426)
-- Name: table_status id_table_status; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_status ALTER COLUMN id_table_status SET DEFAULT nextval('public.table_status_id_table_status_seq'::regclass);


--
-- TOC entry 4852 (class 2604 OID 16427)
-- Name: table_status id_table; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_status ALTER COLUMN id_table SET DEFAULT nextval('public.table_status_id_table_seq'::regclass);


--
-- TOC entry 4850 (class 2604 OID 16412)
-- Name: tables id_table; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables ALTER COLUMN id_table SET DEFAULT nextval('public.table_id_table_seq'::regclass);


--
-- TOC entry 4855 (class 2604 OID 16466)
-- Name: tables_shift id_table_shift; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_shift ALTER COLUMN id_table_shift SET DEFAULT nextval('public.table_shift_id_table_shift_seq'::regclass);


--
-- TOC entry 4856 (class 2604 OID 16467)
-- Name: tables_shift id_table; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_shift ALTER COLUMN id_table SET DEFAULT nextval('public.table_shift_id_table_seq'::regclass);


--
-- TOC entry 4857 (class 2604 OID 16468)
-- Name: tables_shift id_shift; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_shift ALTER COLUMN id_shift SET DEFAULT nextval('public.table_shift_id_shift_seq'::regclass);


--
-- TOC entry 4858 (class 2604 OID 81921)
-- Name: tables_shift id_employee_shift; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_shift ALTER COLUMN id_employee_shift SET DEFAULT nextval('public.tables_shift_id_employee_shift_seq'::regclass);


--
-- TOC entry 5200 (class 0 OID 16632)
-- Dependencies: 250
-- Data for Name: dish; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.dish VALUES (1, 'Куриный суп', 1, 'd51f52', 'Куриное филе, картофель, соль, специи. Варить 40 минут');
INSERT INTO public.dish VALUES (2, 'Уха', 1, '20e974', 'Рыба, картофель, специи. Варить 30 минут');
INSERT INTO public.dish VALUES (3, 'Овощной салат', 2, 'b6cdbe', 'Помидоры, огурцы, зелень, соль');
INSERT INTO public.dish VALUES (4, 'Салат с сыром', 2, 'def74e', 'Сыр, помидоры, зелень');
INSERT INTO public.dish VALUES (5, 'Курица с гарниром', 3, '0a3313', 'Куриное филе обжарить, подать с рисом');
INSERT INTO public.dish VALUES (6, 'Говядина тушёная', 3, 'f731f6', 'Говядина тушится 1.5 часа');
INSERT INTO public.dish VALUES (7, 'Паста с томатным соусом', 4, 'c480d9', 'Паста, томатный соус, специи');
INSERT INTO public.dish VALUES (8, 'Паста с сыром', 4, '10f9f1', 'Паста, сыр, сливки');
INSERT INTO public.dish VALUES (9, 'Сырный десерт', 5, '869758', 'Сыр, сливки, сахар');
INSERT INTO public.dish VALUES (10, 'Сырная тарелка', 6, '2877aa', 'Разные виды сыра');
INSERT INTO public.dish VALUES (11, 'Апельсиновый сок', 7, 'da31fb', 'Свежевыжатый сок');
INSERT INTO public.dish VALUES (12, 'Минеральная вода', 7, 'c64fb5', 'Охлаждённая вода');


--
-- TOC entry 5202 (class 0 OID 16645)
-- Dependencies: 252
-- Data for Name: dish_category; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.dish_category VALUES (1, 'Супы');
INSERT INTO public.dish_category VALUES (2, 'Салаты');
INSERT INTO public.dish_category VALUES (3, 'Горячие блюда');
INSERT INTO public.dish_category VALUES (4, 'Паста');
INSERT INTO public.dish_category VALUES (5, 'Десерты');
INSERT INTO public.dish_category VALUES (6, 'Закуски');
INSERT INTO public.dish_category VALUES (7, 'Напитки');


--
-- TOC entry 5229 (class 0 OID 24764)
-- Dependencies: 279
-- Data for Name: dish_employee; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.dish_employee VALUES (1, 1, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (2, 2, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (3, 3, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (4, 4, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (5, 5, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (6, 6, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (7, 7, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (8, 8, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (9, 9, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (10, 10, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (11, 11, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (12, 12, 1, 'высокий');
INSERT INTO public.dish_employee VALUES (13, 2, 2, 'средний');
INSERT INTO public.dish_employee VALUES (14, 2, 3, 'средний');
INSERT INTO public.dish_employee VALUES (15, 3, 2, 'средний');
INSERT INTO public.dish_employee VALUES (16, 3, 3, 'низкий');
INSERT INTO public.dish_employee VALUES (17, 4, 2, 'низкий');
INSERT INTO public.dish_employee VALUES (18, 4, 3, 'средний');
INSERT INTO public.dish_employee VALUES (19, 5, 2, 'низкий');
INSERT INTO public.dish_employee VALUES (20, 5, 3, 'низкий');
INSERT INTO public.dish_employee VALUES (21, 5, 4, 'средний');
INSERT INTO public.dish_employee VALUES (22, 6, 2, 'средний');
INSERT INTO public.dish_employee VALUES (23, 6, 3, 'низкий');
INSERT INTO public.dish_employee VALUES (24, 6, 4, 'низкий');
INSERT INTO public.dish_employee VALUES (25, 7, 2, 'низкий');
INSERT INTO public.dish_employee VALUES (26, 7, 3, 'низкий');
INSERT INTO public.dish_employee VALUES (27, 7, 4, 'средний');
INSERT INTO public.dish_employee VALUES (28, 8, 3, 'низкий');
INSERT INTO public.dish_employee VALUES (29, 8, 4, 'средний');
INSERT INTO public.dish_employee VALUES (30, 9, 3, 'средний');
INSERT INTO public.dish_employee VALUES (31, 10, 2, 'средний');
INSERT INTO public.dish_employee VALUES (32, 10, 3, 'низкий');
INSERT INTO public.dish_employee VALUES (33, 10, 4, 'средний');
INSERT INTO public.dish_employee VALUES (34, 11, 2, 'низкий');
INSERT INTO public.dish_employee VALUES (35, 11, 3, 'низкий');
INSERT INTO public.dish_employee VALUES (36, 11, 4, 'средний');


--
-- TOC entry 5210 (class 0 OID 24597)
-- Dependencies: 260
-- Data for Name: dish_order; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.dish_order VALUES (141, 11, 2, 1, 'острое', 1);
INSERT INTO public.dish_order VALUES (142, 9, 3, 5, 'без соли', 1);
INSERT INTO public.dish_order VALUES (143, 12, 1, 1, NULL, 1);
INSERT INTO public.dish_order VALUES (144, 6, 2, 2, 'острое', 1);
INSERT INTO public.dish_order VALUES (145, 9, 3, 4, NULL, 1);
INSERT INTO public.dish_order VALUES (146, 9, 1, 4, 'без соли', 1);
INSERT INTO public.dish_order VALUES (147, 1, 1, 1, NULL, 1);
INSERT INTO public.dish_order VALUES (148, 9, 1, 1, 'без соли', 1);
INSERT INTO public.dish_order VALUES (149, 4, 3, 3, 'острое', 1);
INSERT INTO public.dish_order VALUES (150, 3, 1, 5, NULL, 1);
INSERT INTO public.dish_order VALUES (151, 6, 2, 1, NULL, 1);
INSERT INTO public.dish_order VALUES (152, 4, 2, 3, 'острое', 1);


--
-- TOC entry 5205 (class 0 OID 24585)
-- Dependencies: 255
-- Data for Name: dish_price; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.dish_price VALUES (2, 1, '2026-03-01', '320,00 ?');
INSERT INTO public.dish_price VALUES (3, 2, '2026-03-01', '450,00 ?');
INSERT INTO public.dish_price VALUES (4, 3, '2026-03-01', '280,00 ?');
INSERT INTO public.dish_price VALUES (5, 4, '2026-03-01', '350,00 ?');
INSERT INTO public.dish_price VALUES (6, 5, '2026-03-01', '650,00 ?');
INSERT INTO public.dish_price VALUES (7, 6, '2026-03-01', '750,00 ?');
INSERT INTO public.dish_price VALUES (8, 7, '2026-03-01', '480,00 ?');
INSERT INTO public.dish_price VALUES (9, 8, '2026-03-01', '520,00 ?');
INSERT INTO public.dish_price VALUES (10, 9, '2026-03-01', '380,00 ?');
INSERT INTO public.dish_price VALUES (11, 10, '2026-03-01', '600,00 ?');
INSERT INTO public.dish_price VALUES (12, 11, '2026-03-01', '220,00 ?');
INSERT INTO public.dish_price VALUES (13, 12, '2026-03-01', '150,00 ?');


--
-- TOC entry 5179 (class 0 OID 16482)
-- Dependencies: 229
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.employee VALUES (1, 'EMP001', 'Новиков', 'Виктор', 'Андреевич', '5518', '841103', 'ОВД Москвы', '2015-09-06', '1995-09-06', NULL, '2015-10-01');
INSERT INTO public.employee VALUES (2, 'EMP002', 'Фёдоров', 'Максим', 'Антонович', '6810', '771178', 'ОВД Санкт-Петербурга', '2021-09-20', '1976-09-20', NULL, '2021-10-15');
INSERT INTO public.employee VALUES (3, 'EMP003', 'Михайлов', 'Дмитрий', 'Кириллович', '6844', '611865', 'ОВД Новосибирска', '2024-12-16', '1979-12-16', NULL, '2024-12-17');
INSERT INTO public.employee VALUES (4, 'EMP004', 'Смирнов', 'Артём', 'Евгеньевич', '6252', '786454', 'ОВД Казани', '2020-02-25', '1975-02-25', NULL, '2020-03-24');
INSERT INTO public.employee VALUES (5, 'EMP005', 'Смирнов', 'Пётр', 'Викторович', '7688', '619921', 'ОВД Екатеринбурга', '2017-12-30', '1997-12-30', NULL, '2018-01-19');
INSERT INTO public.employee VALUES (6, 'EMP006', 'Михайлов', 'Кирилл', 'Романович', '2351', '463805', 'ОВД Казани', '2015-03-29', '1970-03-29', NULL, '2015-04-27');
INSERT INTO public.employee VALUES (7, 'EMP007', 'Сидоров', 'Максим', 'Викторович', '6018', '375977', 'ОВД Москвы', '2016-07-23', '1971-07-23', NULL, '2016-08-03');
INSERT INTO public.employee VALUES (8, 'EMP008', 'Морозов', 'Евгений', 'Олегович', '3173', '328066', 'ОВД Новосибирска', '2026-02-12', '2006-02-12', NULL, '2026-03-10');
INSERT INTO public.employee VALUES (9, 'EMP009', 'Волков', 'Дмитрий', 'Николаевич', '7653', '002067', 'ОВД Екатеринбурга', '2020-03-28', '2000-03-28', NULL, '2020-04-21');
INSERT INTO public.employee VALUES (10, 'EMP010', 'Морозов', 'Максим', 'Андреевич', '4059', '463140', 'ОВД Москвы', '2023-02-22', '2003-02-22', NULL, '2023-03-15');
INSERT INTO public.employee VALUES (11, 'EMP011', 'Волков', 'Антон', 'Петрович', '1115', '682679', 'ОВД Екатеринбурга', '2021-07-06', '1976-07-06', NULL, '2021-07-26');
INSERT INTO public.employee VALUES (12, 'EMP012', 'Павлов', 'Кирилл', 'Алексеевич', '2231', '468545', 'ОВД Москвы', '2015-09-07', '1995-09-07', NULL, '2015-09-25');
INSERT INTO public.employee VALUES (13, 'EMP013', 'Волков', 'Артём', 'Алексеевич', '5381', '404392', 'ОВД Казани', '2022-02-23', '2002-02-23', NULL, '2022-03-08');
INSERT INTO public.employee VALUES (14, 'EMP014', 'Козлов', 'Максим', 'Дмитриевич', '8509', '171280', 'ОВД Казани', '2022-11-05', '2002-11-05', NULL, '2022-11-07');
INSERT INTO public.employee VALUES (15, 'EMP015', 'Волков', 'Антон', 'Петрович', '8206', '311259', 'ОВД Новосибирска', '2016-02-10', '1971-02-10', NULL, '2016-02-23');
INSERT INTO public.employee VALUES (16, 'EMP016', 'Петров', 'Виктор', 'Алексеевич', '2568', '459966', 'ОВД Екатеринбурга', '2022-08-25', '1977-08-25', NULL, '2022-09-09');


--
-- TOC entry 5183 (class 0 OID 16497)
-- Dependencies: 233
-- Data for Name: employee_shift; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.employee_shift VALUES (261, 1, 1, 'не вышел');
INSERT INTO public.employee_shift VALUES (262, 1, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (263, 1, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (264, 1, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (265, 1, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (266, 1, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (267, 2, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (268, 2, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (269, 2, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (270, 2, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (271, 2, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (272, 2, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (273, 3, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (274, 3, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (275, 3, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (276, 3, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (277, 3, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (278, 3, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (279, 4, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (280, 4, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (281, 4, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (282, 4, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (283, 4, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (284, 4, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (285, 5, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (286, 5, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (287, 5, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (288, 5, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (289, 5, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (290, 5, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (291, 6, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (292, 6, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (293, 6, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (294, 6, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (295, 6, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (296, 6, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (297, 7, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (298, 7, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (299, 7, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (300, 7, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (301, 7, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (302, 7, 15, 'не вышел');
INSERT INTO public.employee_shift VALUES (303, 8, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (304, 8, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (305, 8, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (306, 8, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (307, 8, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (308, 8, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (309, 9, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (310, 9, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (311, 9, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (312, 9, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (313, 9, 14, 'не вышел');
INSERT INTO public.employee_shift VALUES (314, 9, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (315, 10, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (316, 10, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (317, 10, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (318, 10, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (319, 10, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (320, 10, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (321, 11, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (322, 11, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (323, 11, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (324, 11, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (325, 11, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (326, 11, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (327, 12, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (328, 12, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (329, 12, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (330, 12, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (331, 12, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (332, 12, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (333, 13, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (334, 13, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (335, 13, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (336, 13, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (337, 13, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (338, 13, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (339, 14, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (340, 14, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (341, 14, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (342, 14, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (343, 14, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (344, 14, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (345, 15, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (346, 15, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (347, 15, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (348, 15, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (349, 15, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (350, 15, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (351, 16, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (352, 16, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (353, 16, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (354, 16, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (355, 16, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (356, 16, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (357, 17, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (358, 17, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (359, 17, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (360, 17, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (361, 17, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (362, 17, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (363, 18, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (364, 18, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (365, 18, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (366, 18, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (367, 18, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (368, 18, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (369, 19, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (370, 19, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (371, 19, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (372, 19, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (373, 19, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (374, 19, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (375, 20, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (376, 20, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (377, 20, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (378, 20, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (379, 20, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (380, 20, 15, 'на смене');
INSERT INTO public.employee_shift VALUES (381, 21, 1, 'на смене');
INSERT INTO public.employee_shift VALUES (382, 21, 4, 'на смене');
INSERT INTO public.employee_shift VALUES (383, 21, 12, 'на смене');
INSERT INTO public.employee_shift VALUES (384, 21, 10, 'на смене');
INSERT INTO public.employee_shift VALUES (385, 21, 14, 'на смене');
INSERT INTO public.employee_shift VALUES (386, 21, 15, 'на смене');


--
-- TOC entry 5197 (class 0 OID 16608)
-- Dependencies: 247
-- Data for Name: employment_contract; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.employment_contract VALUES (1, 2, 1, 1, '2025-10-23', 'бессрочный');
INSERT INTO public.employment_contract VALUES (2, 1, 2, 1, '2025-09-08', 'бессрочный');
INSERT INTO public.employment_contract VALUES (3, 1, 3, 1, '2025-05-22', 'бессрочный');
INSERT INTO public.employment_contract VALUES (4, 1, 4, 1, '2025-06-13', 'бессрочный');
INSERT INTO public.employment_contract VALUES (5, 5, 5, 1, '2026-03-18', 'бессрочный');
INSERT INTO public.employment_contract VALUES (6, 5, 6, 1, '2025-11-20', 'бессрочный');
INSERT INTO public.employment_contract VALUES (7, 5, 7, 1, '2025-06-22', 'бессрочный');
INSERT INTO public.employment_contract VALUES (8, 5, 8, 1, '2026-02-23', 'бессрочный');
INSERT INTO public.employment_contract VALUES (9, 5, 9, 1, '2025-10-16', 'бессрочный');
INSERT INTO public.employment_contract VALUES (10, 5, 10, 1, '2025-12-28', 'бессрочный');
INSERT INTO public.employment_contract VALUES (11, 5, 11, 1, '2025-12-18', 'бессрочный');
INSERT INTO public.employment_contract VALUES (12, 5, 12, 1, '2025-12-16', 'бессрочный');
INSERT INTO public.employment_contract VALUES (13, 3, 13, 1, '2025-08-15', 'бессрочный');
INSERT INTO public.employment_contract VALUES (14, 3, 14, 1, '2025-04-09', 'бессрочный');
INSERT INTO public.employment_contract VALUES (15, 4, 15, 1, '2026-01-11', 'бессрочный');
INSERT INTO public.employment_contract VALUES (16, 4, 16, 1, '2025-11-06', 'бессрочный');


--
-- TOC entry 5221 (class 0 OID 24706)
-- Dependencies: 271
-- Data for Name: ingredient_dish; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.ingredient_dish VALUES (2, 1, 16, 5, 'г');
INSERT INTO public.ingredient_dish VALUES (3, 1, 6, 200, 'г');
INSERT INTO public.ingredient_dish VALUES (4, 1, 2, 150, 'г');
INSERT INTO public.ingredient_dish VALUES (5, 2, 16, 5, 'г');
INSERT INTO public.ingredient_dish VALUES (6, 2, 6, 150, 'г');
INSERT INTO public.ingredient_dish VALUES (7, 2, 4, 200, 'г');
INSERT INTO public.ingredient_dish VALUES (8, 3, 8, 150, 'г');
INSERT INTO public.ingredient_dish VALUES (9, 3, 7, 150, 'г');
INSERT INTO public.ingredient_dish VALUES (10, 4, 11, 100, 'г');
INSERT INTO public.ingredient_dish VALUES (11, 4, 7, 120, 'г');
INSERT INTO public.ingredient_dish VALUES (12, 5, 13, 150, 'г');
INSERT INTO public.ingredient_dish VALUES (13, 5, 2, 200, 'г');
INSERT INTO public.ingredient_dish VALUES (14, 6, 16, 5, 'г');
INSERT INTO public.ingredient_dish VALUES (15, 6, 3, 250, 'г');
INSERT INTO public.ingredient_dish VALUES (16, 7, 15, 100, 'мл');
INSERT INTO public.ingredient_dish VALUES (17, 7, 14, 150, 'г');
INSERT INTO public.ingredient_dish VALUES (18, 8, 14, 150, 'г');
INSERT INTO public.ingredient_dish VALUES (19, 8, 12, 100, 'г');
INSERT INTO public.ingredient_dish VALUES (20, 8, 10, 50, 'мл');
INSERT INTO public.ingredient_dish VALUES (21, 9, 12, 120, 'г');
INSERT INTO public.ingredient_dish VALUES (22, 9, 10, 80, 'мл');
INSERT INTO public.ingredient_dish VALUES (23, 10, 12, 100, 'г');
INSERT INTO public.ingredient_dish VALUES (24, 10, 11, 100, 'г');
INSERT INTO public.ingredient_dish VALUES (25, 11, 19, 200, 'мл');
INSERT INTO public.ingredient_dish VALUES (26, 12, 18, 250, 'мл');


--
-- TOC entry 5193 (class 0 OID 16596)
-- Dependencies: 243
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.job VALUES (1, 'Повар', '120 000,00 ?');
INSERT INTO public.job VALUES (2, 'Шеф-повар', '180 000,00 ?');
INSERT INTO public.job VALUES (3, 'Кассир', '70 000,00 ?');
INSERT INTO public.job VALUES (4, 'Менеджер', '150 000,00 ?');
INSERT INTO public.job VALUES (5, 'Официант', '80 000,00 ?');


--
-- TOC entry 5191 (class 0 OID 16556)
-- Dependencies: 241
-- Data for Name: order_status; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.order_status VALUES (1, '2026-03-20 11:38:49.4533+03', 1, 'принят');
INSERT INTO public.order_status VALUES (2, '2026-03-20 13:04:15.726625+03', 2, 'принят');
INSERT INTO public.order_status VALUES (3, '2026-03-20 11:00:17.981057+03', 3, 'принят');
INSERT INTO public.order_status VALUES (4, '2026-03-20 12:06:25.572181+03', 4, 'принят');
INSERT INTO public.order_status VALUES (5, '2026-03-20 16:14:47.409629+03', 5, 'принят');
INSERT INTO public.order_status VALUES (6, '2026-03-20 11:43:49.4533+03', 1, 'готовится');
INSERT INTO public.order_status VALUES (7, '2026-03-20 13:10:15.726625+03', 2, 'готовится');
INSERT INTO public.order_status VALUES (8, '2026-03-20 11:03:17.981057+03', 3, 'готовится');
INSERT INTO public.order_status VALUES (9, '2026-03-20 12:12:25.572181+03', 4, 'готовится');
INSERT INTO public.order_status VALUES (10, '2026-03-20 16:20:47.409629+03', 5, 'готовится');
INSERT INTO public.order_status VALUES (11, '2026-03-20 11:58:49.4533+03', 1, 'выполнен');
INSERT INTO public.order_status VALUES (12, '2026-03-20 13:24:15.726625+03', 2, 'выполнен');
INSERT INTO public.order_status VALUES (13, '2026-03-20 11:20:17.981057+03', 3, 'выполнен');
INSERT INTO public.order_status VALUES (14, '2026-03-20 12:26:25.572181+03', 4, 'выполнен');
INSERT INTO public.order_status VALUES (15, '2026-03-20 16:34:47.409629+03', 5, 'выполнен');


--
-- TOC entry 5188 (class 0 OID 16520)
-- Dependencies: 238
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.orders VALUES (1, 330, '8d0b34676d', '2026-03-20 11:38:49.4533', 200, 22, '1 820,00 ?');
INSERT INTO public.orders VALUES (2, 270, '0d58947b45', '2026-03-20 13:04:15.726625', 271, 43, '750,00 ?');
INSERT INTO public.orders VALUES (3, 295, '9589430500', '2026-03-20 11:00:17.981057', 270, 43, '700,00 ?');
INSERT INTO public.orders VALUES (4, 310, 'cbd7d833e6', '2026-03-20 12:06:25.572181', 243, 64, '760,00 ?');
INSERT INTO public.orders VALUES (5, 365, '9f6666675b', '2026-03-20 16:14:47.409629', 213, 85, '660,00 ?');
INSERT INTO public.orders VALUES (12, 323, '99ab133642', '2026-04-13 22:57:00', 293, 189, '0,00 ?');
INSERT INTO public.orders VALUES (13, 336, '78320811f1', '2026-04-09 13:54:00', 271, 189, '0,00 ?');


--
-- TOC entry 5214 (class 0 OID 24636)
-- Dependencies: 264
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.product VALUES (2, 10, 'Куриное филе', 25, 'охлаждённое, 0-4°C', '939b9d', 1);
INSERT INTO public.product VALUES (3, 8, 'Говядина', 20, 'охлаждённое, 0-4°C', '95b441', 1);
INSERT INTO public.product VALUES (4, 5, 'Лосось', 12, 'охлаждённое, 0-2°C', '7b4685', 2);
INSERT INTO public.product VALUES (5, 5, 'Треска', 10, 'замороженное, -18°C', 'df7a19', 2);
INSERT INTO public.product VALUES (6, 15, 'Картофель', 50, 'сухое место, +5-10°C', 'ab1bb7', 4);
INSERT INTO public.product VALUES (7, 10, 'Помидоры', 30, 'охлаждённое, +4-8°C', '1161c0', 4);
INSERT INTO public.product VALUES (8, 10, 'Огурцы', 25, 'охлаждённое, +4-8°C', '2b75c6', 4);
INSERT INTO public.product VALUES (9, 10, 'Молоко', 20, 'охлаждённое, +2-6°C', '02671a', 7);
INSERT INTO public.product VALUES (10, 8, 'Сливки', 15, 'охлаждённое, +2-6°C', '34f97c', 7);
INSERT INTO public.product VALUES (11, 5, 'Сыр Чеддер', 10, 'охлаждённое, +2-6°C', 'f59110', 8);
INSERT INTO public.product VALUES (12, 5, 'Сыр Моцарелла', 12, 'охлаждённое, +2-6°C', 'b17373', 8);
INSERT INTO public.product VALUES (13, 10, 'Рис', 40, 'сухое место', '7c6a9d', 10);
INSERT INTO public.product VALUES (14, 10, 'Паста', 35, 'сухое место', '2c55bb', 10);
INSERT INTO public.product VALUES (15, 5, 'Томатный соус', 15, 'охлаждённое после вскрытия', 'e5d733', 12);
INSERT INTO public.product VALUES (16, 3, 'Соль', 20, 'сухое место', 'b28cd5', 13);
INSERT INTO public.product VALUES (17, 3, 'Чёрный перец', 15, 'сухое место', '485bfe', 13);
INSERT INTO public.product VALUES (18, 10, 'Минеральная вода', 50, 'комнатная температура', '14621e', 14);
INSERT INTO public.product VALUES (19, 10, 'Сок апельсиновый', 30, 'охлаждённое', 'b52582', 14);
INSERT INTO public.product VALUES (20, 5, 'Куриное бедро', 20, 'охлаждённое, 0-4°C', 'b21529', 1);
INSERT INTO public.product VALUES (21, 5, 'Форель', 10, 'охлаждённое, 0-2°C', 'dd06b9', 2);
INSERT INTO public.product VALUES (22, 5, 'Сыр Пармезан', 8, 'охлаждённое, +2-6°C', '18170d', 8);


--
-- TOC entry 5212 (class 0 OID 24627)
-- Dependencies: 262
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.product_type VALUES (1, 'Мясо');
INSERT INTO public.product_type VALUES (2, 'Рыба');
INSERT INTO public.product_type VALUES (3, 'Морепродукты');
INSERT INTO public.product_type VALUES (4, 'Овощи');
INSERT INTO public.product_type VALUES (5, 'Фрукты');
INSERT INTO public.product_type VALUES (6, 'Зелень');
INSERT INTO public.product_type VALUES (7, 'Молочные продукты');
INSERT INTO public.product_type VALUES (8, 'Сыры');
INSERT INTO public.product_type VALUES (9, 'Яйца');
INSERT INTO public.product_type VALUES (10, 'Крупы и макароны');
INSERT INTO public.product_type VALUES (11, 'Хлебобулочные изделия');
INSERT INTO public.product_type VALUES (12, 'Соусы');
INSERT INTO public.product_type VALUES (13, 'Специи');
INSERT INTO public.product_type VALUES (14, 'Напитки');
INSERT INTO public.product_type VALUES (15, 'Алкоголь');
INSERT INTO public.product_type VALUES (16, 'Замороженные продукты');
INSERT INTO public.product_type VALUES (17, 'Полуфабрикаты');
INSERT INTO public.product_type VALUES (18, 'Десерты');
INSERT INTO public.product_type VALUES (19, 'Кондитерские изделия');


--
-- TOC entry 5225 (class 0 OID 24740)
-- Dependencies: 275
-- Data for Name: replacement; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.replacement VALUES (1, 20, 4, 150);
INSERT INTO public.replacement VALUES (2, 21, 7, 200);
INSERT INTO public.replacement VALUES (3, 20, 13, 200);
INSERT INTO public.replacement VALUES (4, 22, 19, 100);
INSERT INTO public.replacement VALUES (5, 22, 21, 120);
INSERT INTO public.replacement VALUES (6, 22, 23, 100);


--
-- TOC entry 5171 (class 0 OID 16438)
-- Dependencies: 221
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.reservation VALUES (164, 'Алексей', '12:17:00', 2, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (165, 'Сергей', '21:02:00', 2, NULL, NULL, '2026-04-14');
INSERT INTO public.reservation VALUES (166, 'Мария', '12:25:00', 3, NULL, NULL, '2026-04-14');
INSERT INTO public.reservation VALUES (167, 'Дмитрий', '17:50:00', 3, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (168, 'Ольга', '22:28:00', 2, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (169, 'Анна', '13:00:00', 2, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (170, 'Мария', '20:27:00', 3, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (171, 'Иван', '22:33:00', 3, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (172, 'Алексей', '16:09:00', 2, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (173, 'Елена', '22:43:00', 1, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (174, 'Елена', '12:42:00', 2, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (175, 'Иван', '14:57:00', 3, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (176, 'Сергей', '19:25:00', 3, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (177, 'Елена', '22:32:00', 1, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (178, 'Дмитрий', '13:35:00', 1, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (179, 'Алексей', '21:58:00', 3, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (180, 'Ольга', '13:40:00', 3, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (181, 'Анна', '17:25:00', 2, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (182, 'Дмитрий', '17:50:00', 1, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (183, 'Анна', '11:55:00', 1, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (184, 'Ольга', '20:35:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (185, 'Сергей', '14:48:00', 4, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (186, 'Дмитрий', '20:09:00', 4, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (187, 'Сергей', '17:37:00', 2, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (188, 'Сергей', '15:14:00', 2, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (189, 'Иван', '18:14:00', 3, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (190, 'Сергей', '12:21:00', 1, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (191, 'Сергей', '17:51:00', 1, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (192, 'Ольга', '22:53:00', 2, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (193, 'Ольга', '16:19:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (194, 'Ольга', '21:12:00', 2, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (195, 'Мария', '12:04:00', 3, NULL, NULL, '2026-04-14');
INSERT INTO public.reservation VALUES (196, 'Анна', '14:22:00', 2, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (197, 'Алексей', '17:35:00', 2, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (198, 'Дмитрий', '22:25:00', 2, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (199, 'Ольга', '11:48:00', 2, NULL, NULL, '2026-04-18');
INSERT INTO public.reservation VALUES (200, 'Сергей', '13:09:00', 3, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (201, 'Дмитрий', '20:40:00', 3, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (202, 'Сергей', '14:07:00', 1, NULL, NULL, '2026-04-18');
INSERT INTO public.reservation VALUES (203, 'Дмитрий', '17:53:00', 2, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (204, 'Елена', '20:28:00', 2, NULL, NULL, '2026-04-14');
INSERT INTO public.reservation VALUES (205, 'Анна', '19:33:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (206, 'Сергей', '16:56:00', 3, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (207, 'Иван', '20:20:00', 4, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (208, 'Иван', '21:10:00', 2, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (209, 'Ольга', '14:05:00', 4, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (210, 'Анна', '14:41:00', 3, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (211, 'Иван', '17:27:00', 2, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (212, 'Сергей', '14:30:00', 1, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (213, 'Елена', '18:20:00', 1, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (214, 'Дмитрий', '20:31:00', 2, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (215, 'Анна', '14:55:00', 4, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (216, 'Сергей', '13:12:00', 3, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (217, 'Ольга', '20:50:00', 2, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (218, 'Мария', '20:02:00', 3, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (219, 'Иван', '17:17:00', 1, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (220, 'Елена', '14:59:00', 2, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (221, 'Алексей', '16:22:00', 3, NULL, NULL, '2026-04-18');
INSERT INTO public.reservation VALUES (222, 'Дмитрий', '19:14:00', 4, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (223, 'Сергей', '12:10:00', 2, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (224, 'Дмитрий', '16:49:00', 2, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (225, 'Иван', '13:52:00', 3, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (226, 'Ольга', '18:01:00', 2, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (227, 'Алексей', '20:46:00', 3, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (228, 'Дмитрий', '13:01:00', 1, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (229, 'Сергей', '18:39:00', 1, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (230, 'Сергей', '14:52:00', 3, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (231, 'Анна', '19:39:00', 3, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (232, 'Дмитрий', '16:53:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (233, 'Ольга', '20:51:00', 2, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (234, 'Иван', '18:21:00', 2, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (235, 'Ольга', '21:21:00', 4, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (236, 'Анна', '12:03:00', 3, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (237, 'Елена', '21:44:00', 2, NULL, NULL, '2026-04-18');
INSERT INTO public.reservation VALUES (238, 'Алексей', '19:24:00', 3, NULL, NULL, '2026-04-18');
INSERT INTO public.reservation VALUES (239, 'Ольга', '12:52:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (240, 'Елена', '22:17:00', 3, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (241, 'Алексей', '12:26:00', 3, NULL, NULL, '2026-04-14');
INSERT INTO public.reservation VALUES (242, 'Сергей', '19:02:00', 2, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (243, 'Мария', '13:11:00', 3, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (244, 'Мария', '18:03:00', 3, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (245, 'Анна', '20:22:00', 3, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (246, 'Ольга', '21:08:00', 2, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (247, 'Иван', '13:25:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (248, 'Елена', '18:38:00', 1, NULL, NULL, '2026-04-18');
INSERT INTO public.reservation VALUES (249, 'Мария', '22:15:00', 3, NULL, NULL, '2026-04-14');
INSERT INTO public.reservation VALUES (250, 'Ольга', '13:07:00', 3, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (251, 'Сергей', '16:44:00', 4, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (252, 'Дмитрий', '14:48:00', 3, NULL, NULL, '2026-04-14');
INSERT INTO public.reservation VALUES (253, 'Елена', '17:00:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (254, 'Елена', '19:58:00', 3, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (255, 'Анна', '15:12:00', 2, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (256, 'Елена', '18:08:00', 4, NULL, NULL, '2026-04-14');
INSERT INTO public.reservation VALUES (257, 'Мария', '12:35:00', 1, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (258, 'Дмитрий', '17:45:00', 3, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (259, 'Ольга', '22:07:00', 2, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (260, 'Ольга', '22:20:00', 3, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (261, 'Ольга', '11:39:00', 4, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (262, 'Мария', '13:56:00', 2, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (263, 'Иван', '19:05:00', 1, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (264, 'Анна', '12:48:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (265, 'Алексей', '20:15:00', 1, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (266, 'Иван', '18:07:00', 2, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (267, 'Алексей', '12:02:00', 1, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (268, 'Мария', '13:01:00', 1, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (269, 'Анна', '12:32:00', 2, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (270, 'Дмитрий', '11:36:00', 1, NULL, NULL, '2026-04-11');
INSERT INTO public.reservation VALUES (271, 'Дмитрий', '13:54:00', 2, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (272, 'Мария', '22:28:00', 2, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (273, 'Анна', '13:06:00', 3, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (274, 'Сергей', '15:43:00', 2, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (275, 'Алексей', '20:15:00', 2, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (276, 'Сергей', '15:14:00', 3, NULL, NULL, '2026-04-18');
INSERT INTO public.reservation VALUES (277, 'Дмитрий', '17:58:00', 3, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (278, 'Елена', '21:32:00', 2, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (279, 'Елена', '15:50:00', 1, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (280, 'Дмитрий', '17:32:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (281, 'Мария', '21:33:00', 2, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (282, 'Елена', '11:55:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (283, 'Ольга', '19:16:00', 3, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (284, 'Сергей', '20:41:00', 4, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (285, 'Елена', '14:06:00', 1, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (286, 'Иван', '18:14:00', 1, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (287, 'Алексей', '16:57:00', 1, NULL, NULL, '2026-04-15');
INSERT INTO public.reservation VALUES (288, 'Мария', '19:16:00', 2, NULL, NULL, '2026-04-12');
INSERT INTO public.reservation VALUES (289, 'Ольга', '22:40:00', 4, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (290, 'Анна', '12:15:00', 4, NULL, NULL, '2026-04-10');
INSERT INTO public.reservation VALUES (291, 'Сергей', '14:55:00', 3, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (292, 'Алексей', '18:10:00', 2, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (293, 'Сергей', '22:57:00', 3, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (294, 'Елена', '19:47:00', 1, NULL, NULL, '2026-04-09');
INSERT INTO public.reservation VALUES (295, 'Иван', '13:04:00', 1, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (296, 'Елена', '19:21:00', 1, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (297, 'Дмитрий', '13:37:00', 3, NULL, NULL, '2026-04-16');
INSERT INTO public.reservation VALUES (298, 'Дмитрий', '14:20:00', 2, NULL, NULL, '2026-04-18');
INSERT INTO public.reservation VALUES (299, 'Анна', '17:51:00', 4, NULL, NULL, '2026-04-14');
INSERT INTO public.reservation VALUES (300, 'Мария', '20:16:00', 1, NULL, NULL, '2026-04-17');
INSERT INTO public.reservation VALUES (301, 'Ольга', '14:17:00', 3, NULL, NULL, '2026-04-13');
INSERT INTO public.reservation VALUES (302, 'Анна', '20:50:00', 3, NULL, NULL, '2026-04-12');


--
-- TOC entry 5173 (class 0 OID 16453)
-- Dependencies: 223
-- Data for Name: shift; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.shift VALUES (1, '2026-03-20 08:00:00', '2026-03-20 16:00:00');
INSERT INTO public.shift VALUES (2, '2026-03-20 12:00:00', '2026-03-20 20:00:00');
INSERT INTO public.shift VALUES (3, '2026-03-20 16:00:00', '2026-03-20 23:00:00');
INSERT INTO public.shift VALUES (4, '2026-03-21 08:00:00', '2026-03-21 16:00:00');
INSERT INTO public.shift VALUES (5, '2026-03-21 12:00:00', '2026-03-21 20:00:00');
INSERT INTO public.shift VALUES (6, '2026-03-21 16:00:00', '2026-03-21 23:00:00');
INSERT INTO public.shift VALUES (7, '2026-03-22 08:00:00', '2026-03-22 16:00:00');
INSERT INTO public.shift VALUES (8, '2026-03-22 12:00:00', '2026-03-22 20:00:00');
INSERT INTO public.shift VALUES (9, '2026-03-22 16:00:00', '2026-03-22 23:00:00');
INSERT INTO public.shift VALUES (10, '2026-03-23 08:00:00', '2026-03-23 16:00:00');
INSERT INTO public.shift VALUES (11, '2026-03-23 12:00:00', '2026-03-23 20:00:00');
INSERT INTO public.shift VALUES (12, '2026-03-23 16:00:00', '2026-03-23 23:00:00');
INSERT INTO public.shift VALUES (13, '2026-03-24 08:00:00', '2026-03-24 16:00:00');
INSERT INTO public.shift VALUES (14, '2026-03-24 12:00:00', '2026-03-24 20:00:00');
INSERT INTO public.shift VALUES (15, '2026-03-24 16:00:00', '2026-03-24 23:00:00');
INSERT INTO public.shift VALUES (16, '2026-03-25 08:00:00', '2026-03-25 16:00:00');
INSERT INTO public.shift VALUES (17, '2026-03-25 12:00:00', '2026-03-25 20:00:00');
INSERT INTO public.shift VALUES (18, '2026-03-25 16:00:00', '2026-03-25 23:00:00');
INSERT INTO public.shift VALUES (19, '2026-03-26 08:00:00', '2026-03-26 16:00:00');
INSERT INTO public.shift VALUES (20, '2026-03-26 12:00:00', '2026-03-26 20:00:00');
INSERT INTO public.shift VALUES (21, '2026-03-26 16:00:00', '2026-03-26 23:00:00');


--
-- TOC entry 5217 (class 0 OID 24683)
-- Dependencies: 267
-- Data for Name: supply; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.supply VALUES (12, '99 386,00 ?', 'FoodLine', '2026-03-18 00:00:00', NULL);
INSERT INTO public.supply VALUES (41, '104 482,50 ?', 'FoodLine', '2026-03-18 00:00:00', NULL);
INSERT INTO public.supply VALUES (50, '67 699,00 ?', 'FoodLine', '2026-03-18 00:00:00', NULL);


--
-- TOC entry 5233 (class 0 OID 65565)
-- Dependencies: 283
-- Data for Name: supply_product; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.supply_product VALUES (7, 2, 41, 25, 'Турция', 156, 'GreenFarm', 'принято', '614,00 ?', '2026-04-03 00:00:00', '2026-03-09 00:00:00');
INSERT INTO public.supply_product VALUES (8, 3, 50, 20, 'Беларусь', 189, 'GreenFarm', 'принято', '915,50 ?', '2026-04-01 00:00:00', '2026-03-08 00:00:00');
INSERT INTO public.supply_product VALUES (9, 3, 41, 20, 'Италия', 244, 'ООО АгроФерма', 'принято', '378,50 ?', '2026-04-15 00:00:00', '2026-03-13 00:00:00');
INSERT INTO public.supply_product VALUES (10, 3, 12, 20, 'Россия', 256, 'FreshFood', 'принято', '1 112,00 ?', '2026-04-01 00:00:00', '2026-03-10 00:00:00');
INSERT INTO public.supply_product VALUES (11, 4, 50, 12, 'Беларусь', 340, 'GreenFarm', 'принято', '529,00 ?', '2026-03-30 00:00:00', '2026-03-09 00:00:00');
INSERT INTO public.supply_product VALUES (12, 4, 12, 12, 'Россия', 261, 'FreshFood', 'принято', '388,00 ?', '2026-04-13 00:00:00', '2026-03-08 00:00:00');
INSERT INTO public.supply_product VALUES (13, 5, 41, 10, 'Италия', 141, 'FreshFood', 'принято', '710,00 ?', '2026-04-12 00:00:00', '2026-03-13 00:00:00');
INSERT INTO public.supply_product VALUES (14, 6, 12, 50, 'Италия', 118, 'GreenFarm', 'принято', '280,50 ?', '2026-03-30 00:00:00', '2026-03-12 00:00:00');
INSERT INTO public.supply_product VALUES (15, 9, 50, 20, 'Турция', 191, 'GreenFarm', 'принято', '699,50 ?', '2026-03-23 00:00:00', '2026-03-12 00:00:00');
INSERT INTO public.supply_product VALUES (16, 9, 41, 20, 'Беларусь', 104, 'FreshFood', 'принято', '1 057,00 ?', '2026-03-26 00:00:00', '2026-03-09 00:00:00');
INSERT INTO public.supply_product VALUES (17, 9, 12, 20, 'Турция', 229, 'GreenFarm', 'принято', '423,00 ?', '2026-04-08 00:00:00', '2026-03-13 00:00:00');
INSERT INTO public.supply_product VALUES (18, 11, 50, 10, 'Турция', 321, 'ООО АгроФерма', 'принято', '576,50 ?', '2026-03-24 00:00:00', '2026-03-10 00:00:00');
INSERT INTO public.supply_product VALUES (19, 12, 50, 12, 'Россия', 98, 'FreshFood', 'принято', '361,00 ?', '2026-04-11 00:00:00', '2026-03-10 00:00:00');
INSERT INTO public.supply_product VALUES (20, 14, 41, 35, 'Турция', 220, 'ООО АгроФерма', 'принято', '737,50 ?', '2026-03-30 00:00:00', '2026-03-13 00:00:00');
INSERT INTO public.supply_product VALUES (21, 14, 12, 35, 'Россия', 73, 'GreenFarm', 'принято', '837,00 ?', '2026-04-07 00:00:00', '2026-03-14 00:00:00');
INSERT INTO public.supply_product VALUES (22, 15, 50, 15, 'Россия', 254, 'GreenFarm', 'принято', '666,00 ?', '2026-04-18 00:00:00', '2026-03-13 00:00:00');
INSERT INTO public.supply_product VALUES (23, 15, 41, 15, 'Турция', 126, 'FreshFood', 'принято', '323,00 ?', '2026-03-30 00:00:00', '2026-03-13 00:00:00');
INSERT INTO public.supply_product VALUES (24, 20, 41, 20, 'Беларусь', 70, 'FreshFood', 'принято', '733,00 ?', '2026-04-15 00:00:00', '2026-03-13 00:00:00');
INSERT INTO public.supply_product VALUES (25, 20, 12, 20, 'Италия', 80, 'GreenFarm', 'принято', '829,50 ?', '2026-03-24 00:00:00', '2026-03-10 00:00:00');
INSERT INTO public.supply_product VALUES (26, 21, 41, 10, 'Турция', 304, 'GreenFarm', 'принято', '800,50 ?', '2026-04-04 00:00:00', '2026-03-14 00:00:00');
INSERT INTO public.supply_product VALUES (27, 22, 50, 8, 'Италия', 274, 'ООО АгроФерма', 'принято', '1 120,50 ?', '2026-04-09 00:00:00', '2026-03-11 00:00:00');
INSERT INTO public.supply_product VALUES (28, 22, 12, 8, 'Италия', 307, 'FreshFood', 'принято', '515,00 ?', '2026-04-19 00:00:00', '2026-03-16 00:00:00');


--
-- TOC entry 5169 (class 0 OID 16423)
-- Dependencies: 219
-- Data for Name: table_status; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.table_status VALUES (3240, 1, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3241, 1, 'занят', '2026-03-20 10:19:00+03');
INSERT INTO public.table_status VALUES (3242, 1, 'свободен', '2026-03-20 11:56:00+03');
INSERT INTO public.table_status VALUES (3243, 1, 'занят', '2026-03-20 12:28:00+03');
INSERT INTO public.table_status VALUES (3244, 1, 'свободен', '2026-03-20 14:25:00+03');
INSERT INTO public.table_status VALUES (3245, 1, 'занят', '2026-03-20 14:55:00+03');
INSERT INTO public.table_status VALUES (3246, 1, 'свободен', '2026-03-20 16:33:00+03');
INSERT INTO public.table_status VALUES (3247, 1, 'занят', '2026-03-20 18:04:00+03');
INSERT INTO public.table_status VALUES (3248, 1, 'свободен', '2026-03-20 19:18:00+03');
INSERT INTO public.table_status VALUES (3249, 1, 'забронирован', '2026-03-20 19:54:00+03');
INSERT INTO public.table_status VALUES (3250, 1, 'занят', '2026-03-20 20:35:00+03');
INSERT INTO public.table_status VALUES (3251, 1, 'свободен', '2026-03-20 22:20:00+03');
INSERT INTO public.table_status VALUES (3252, 1, 'занят', '2026-03-20 22:53:00+03');
INSERT INTO public.table_status VALUES (3253, 2, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3254, 2, 'забронирован', '2026-03-20 10:36:00+03');
INSERT INTO public.table_status VALUES (3255, 2, 'занят', '2026-03-20 11:36:00+03');
INSERT INTO public.table_status VALUES (3256, 2, 'свободен', '2026-03-20 13:09:00+03');
INSERT INTO public.table_status VALUES (3257, 2, 'занят', '2026-03-20 13:22:00+03');
INSERT INTO public.table_status VALUES (3258, 2, 'свободен', '2026-03-20 15:08:00+03');
INSERT INTO public.table_status VALUES (3259, 2, 'занят', '2026-03-20 17:03:00+03');
INSERT INTO public.table_status VALUES (3260, 2, 'свободен', '2026-03-20 18:48:00+03');
INSERT INTO public.table_status VALUES (3261, 2, 'забронирован', '2026-03-20 19:01:00+03');
INSERT INTO public.table_status VALUES (3262, 2, 'занят', '2026-03-20 19:32:00+03');
INSERT INTO public.table_status VALUES (3263, 2, 'свободен', '2026-03-20 20:40:00+03');
INSERT INTO public.table_status VALUES (3264, 2, 'занят', '2026-03-20 22:20:00+03');
INSERT INTO public.table_status VALUES (3265, 3, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3266, 3, 'забронирован', '2026-03-20 10:26:00+03');
INSERT INTO public.table_status VALUES (3267, 3, 'занят', '2026-03-20 10:53:00+03');
INSERT INTO public.table_status VALUES (3268, 3, 'свободен', '2026-03-20 11:36:00+03');
INSERT INTO public.table_status VALUES (3269, 3, 'забронирован', '2026-03-20 12:13:00+03');
INSERT INTO public.table_status VALUES (3270, 3, 'занят', '2026-03-20 13:03:00+03');
INSERT INTO public.table_status VALUES (3271, 3, 'свободен', '2026-03-20 13:54:00+03');
INSERT INTO public.table_status VALUES (3272, 3, 'занят', '2026-03-20 14:28:00+03');
INSERT INTO public.table_status VALUES (3273, 3, 'свободен', '2026-03-20 15:51:00+03');
INSERT INTO public.table_status VALUES (3274, 3, 'занят', '2026-03-20 17:33:00+03');
INSERT INTO public.table_status VALUES (3275, 3, 'свободен', '2026-03-20 18:33:00+03');
INSERT INTO public.table_status VALUES (3276, 3, 'занят', '2026-03-20 19:08:00+03');
INSERT INTO public.table_status VALUES (3277, 3, 'свободен', '2026-03-20 20:09:00+03');
INSERT INTO public.table_status VALUES (3278, 3, 'забронирован', '2026-03-20 20:24:00+03');
INSERT INTO public.table_status VALUES (3279, 3, 'занят', '2026-03-20 21:01:00+03');
INSERT INTO public.table_status VALUES (3280, 3, 'свободен', '2026-03-20 22:28:00+03');
INSERT INTO public.table_status VALUES (3281, 4, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3282, 4, 'забронирован', '2026-03-20 10:40:00+03');
INSERT INTO public.table_status VALUES (3283, 4, 'занят', '2026-03-20 11:32:00+03');
INSERT INTO public.table_status VALUES (3284, 4, 'свободен', '2026-03-20 13:11:00+03');
INSERT INTO public.table_status VALUES (3285, 4, 'занят', '2026-03-20 14:45:00+03');
INSERT INTO public.table_status VALUES (3286, 4, 'свободен', '2026-03-20 16:00:00+03');
INSERT INTO public.table_status VALUES (3287, 4, 'забронирован', '2026-03-20 16:22:00+03');
INSERT INTO public.table_status VALUES (3288, 4, 'занят', '2026-03-20 17:09:00+03');
INSERT INTO public.table_status VALUES (3289, 4, 'свободен', '2026-03-20 18:03:00+03');
INSERT INTO public.table_status VALUES (3290, 4, 'забронирован', '2026-03-20 18:28:00+03');
INSERT INTO public.table_status VALUES (3291, 4, 'занят', '2026-03-20 19:05:00+03');
INSERT INTO public.table_status VALUES (3292, 4, 'свободен', '2026-03-20 20:22:00+03');
INSERT INTO public.table_status VALUES (3293, 5, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3294, 5, 'занят', '2026-03-20 10:28:00+03');
INSERT INTO public.table_status VALUES (3295, 5, 'свободен', '2026-03-20 12:23:00+03');
INSERT INTO public.table_status VALUES (3296, 5, 'забронирован', '2026-03-20 12:36:00+03');
INSERT INTO public.table_status VALUES (3297, 5, 'занят', '2026-03-20 13:16:00+03');
INSERT INTO public.table_status VALUES (3298, 5, 'свободен', '2026-03-20 14:30:00+03');
INSERT INTO public.table_status VALUES (3299, 5, 'забронирован', '2026-03-20 15:39:00+03');
INSERT INTO public.table_status VALUES (3300, 5, 'занят', '2026-03-20 16:28:00+03');
INSERT INTO public.table_status VALUES (3301, 5, 'свободен', '2026-03-20 18:20:00+03');
INSERT INTO public.table_status VALUES (3302, 5, 'забронирован', '2026-03-20 18:38:00+03');
INSERT INTO public.table_status VALUES (3303, 5, 'занят', '2026-03-20 19:00:00+03');
INSERT INTO public.table_status VALUES (3304, 5, 'свободен', '2026-03-20 20:31:00+03');
INSERT INTO public.table_status VALUES (3305, 6, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3306, 6, 'занят', '2026-03-20 10:36:00+03');
INSERT INTO public.table_status VALUES (3307, 6, 'свободен', '2026-03-20 12:18:00+03');
INSERT INTO public.table_status VALUES (3308, 6, 'забронирован', '2026-03-20 12:51:00+03');
INSERT INTO public.table_status VALUES (3309, 6, 'занят', '2026-03-20 13:13:00+03');
INSERT INTO public.table_status VALUES (3310, 6, 'свободен', '2026-03-20 14:52:00+03');
INSERT INTO public.table_status VALUES (3311, 6, 'забронирован', '2026-03-20 17:08:00+03');
INSERT INTO public.table_status VALUES (3312, 6, 'занят', '2026-03-20 17:47:00+03');
INSERT INTO public.table_status VALUES (3313, 6, 'свободен', '2026-03-20 19:39:00+03');
INSERT INTO public.table_status VALUES (3314, 6, 'занят', '2026-03-20 21:09:00+03');
INSERT INTO public.table_status VALUES (3315, 6, 'свободен', '2026-03-20 22:53:00+03');
INSERT INTO public.table_status VALUES (3316, 7, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3317, 7, 'забронирован', '2026-03-20 10:19:00+03');
INSERT INTO public.table_status VALUES (3318, 7, 'занят', '2026-03-20 11:11:00+03');
INSERT INTO public.table_status VALUES (3319, 7, 'свободен', '2026-03-20 12:15:00+03');
INSERT INTO public.table_status VALUES (3320, 7, 'забронирован', '2026-03-20 12:31:00+03');
INSERT INTO public.table_status VALUES (3321, 7, 'занят', '2026-03-20 13:07:00+03');
INSERT INTO public.table_status VALUES (3322, 7, 'свободен', '2026-03-20 14:55:00+03');
INSERT INTO public.table_status VALUES (3323, 7, 'забронирован', '2026-03-20 15:31:00+03');
INSERT INTO public.table_status VALUES (3324, 7, 'занят', '2026-03-20 16:20:00+03');
INSERT INTO public.table_status VALUES (3325, 7, 'свободен', '2026-03-20 18:10:00+03');
INSERT INTO public.table_status VALUES (3326, 7, 'занят', '2026-03-20 19:14:00+03');
INSERT INTO public.table_status VALUES (3327, 7, 'свободен', '2026-03-20 21:12:00+03');
INSERT INTO public.table_status VALUES (3328, 7, 'забронирован', '2026-03-20 21:23:00+03');
INSERT INTO public.table_status VALUES (3329, 7, 'занят', '2026-03-20 21:46:00+03');
INSERT INTO public.table_status VALUES (3330, 7, 'свободен', '2026-03-20 22:57:00+03');
INSERT INTO public.table_status VALUES (3331, 8, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3332, 8, 'занят', '2026-03-20 10:18:00+03');
INSERT INTO public.table_status VALUES (3333, 8, 'свободен', '2026-03-20 11:42:00+03');
INSERT INTO public.table_status VALUES (3334, 8, 'забронирован', '2026-03-20 13:28:00+03');
INSERT INTO public.table_status VALUES (3335, 8, 'занят', '2026-03-20 14:02:00+03');
INSERT INTO public.table_status VALUES (3336, 8, 'свободен', '2026-03-20 14:59:00+03');
INSERT INTO public.table_status VALUES (3337, 8, 'занят', '2026-03-20 16:37:00+03');
INSERT INTO public.table_status VALUES (3338, 8, 'свободен', '2026-03-20 17:55:00+03');
INSERT INTO public.table_status VALUES (3339, 8, 'занят', '2026-03-20 20:06:00+03');
INSERT INTO public.table_status VALUES (3340, 8, 'свободен', '2026-03-20 21:18:00+03');
INSERT INTO public.table_status VALUES (3341, 8, 'занят', '2026-03-20 22:31:00+03');
INSERT INTO public.table_status VALUES (3342, 9, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3343, 9, 'забронирован', '2026-03-20 10:19:00+03');
INSERT INTO public.table_status VALUES (3344, 9, 'занят', '2026-03-20 10:45:00+03');
INSERT INTO public.table_status VALUES (3345, 9, 'свободен', '2026-03-20 11:55:00+03');
INSERT INTO public.table_status VALUES (3346, 9, 'занят', '2026-03-20 12:50:00+03');
INSERT INTO public.table_status VALUES (3347, 9, 'свободен', '2026-03-20 14:49:00+03');
INSERT INTO public.table_status VALUES (3348, 9, 'занят', '2026-03-20 16:48:00+03');
INSERT INTO public.table_status VALUES (3349, 9, 'свободен', '2026-03-20 17:44:00+03');
INSERT INTO public.table_status VALUES (3350, 9, 'занят', '2026-03-20 18:05:00+03');
INSERT INTO public.table_status VALUES (3351, 9, 'свободен', '2026-03-20 18:55:00+03');
INSERT INTO public.table_status VALUES (3352, 9, 'занят', '2026-03-20 19:23:00+03');
INSERT INTO public.table_status VALUES (3353, 9, 'свободен', '2026-03-20 20:49:00+03');
INSERT INTO public.table_status VALUES (3354, 9, 'занят', '2026-03-20 21:43:00+03');
INSERT INTO public.table_status VALUES (3355, 10, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3356, 10, 'занят', '2026-03-20 11:45:00+03');
INSERT INTO public.table_status VALUES (3357, 10, 'свободен', '2026-03-20 13:11:00+03');
INSERT INTO public.table_status VALUES (3358, 10, 'забронирован', '2026-03-20 13:27:00+03');
INSERT INTO public.table_status VALUES (3359, 10, 'занят', '2026-03-20 14:18:00+03');
INSERT INTO public.table_status VALUES (3360, 10, 'свободен', '2026-03-20 15:14:00+03');
INSERT INTO public.table_status VALUES (3361, 10, 'занят', '2026-03-20 17:52:00+03');
INSERT INTO public.table_status VALUES (3362, 10, 'свободен', '2026-03-20 19:28:00+03');
INSERT INTO public.table_status VALUES (3363, 10, 'занят', '2026-03-20 19:59:00+03');
INSERT INTO public.table_status VALUES (3364, 10, 'свободен', '2026-03-20 20:45:00+03');
INSERT INTO public.table_status VALUES (3365, 11, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3366, 11, 'забронирован', '2026-03-20 10:30:00+03');
INSERT INTO public.table_status VALUES (3367, 11, 'занят', '2026-03-20 11:29:00+03');
INSERT INTO public.table_status VALUES (3368, 11, 'свободен', '2026-03-20 12:17:00+03');
INSERT INTO public.table_status VALUES (3369, 11, 'занят', '2026-03-20 12:56:00+03');
INSERT INTO public.table_status VALUES (3370, 11, 'свободен', '2026-03-20 14:36:00+03');
INSERT INTO public.table_status VALUES (3371, 11, 'занят', '2026-03-20 16:17:00+03');
INSERT INTO public.table_status VALUES (3372, 11, 'свободен', '2026-03-20 18:13:00+03');
INSERT INTO public.table_status VALUES (3373, 11, 'забронирован', '2026-03-20 18:48:00+03');
INSERT INTO public.table_status VALUES (3374, 11, 'занят', '2026-03-20 19:14:00+03');
INSERT INTO public.table_status VALUES (3375, 11, 'свободен', '2026-03-20 21:02:00+03');
INSERT INTO public.table_status VALUES (3376, 11, 'забронирован', '2026-03-20 22:26:00+03');
INSERT INTO public.table_status VALUES (3377, 12, 'свободен', '2026-03-20 10:00:00+03');
INSERT INTO public.table_status VALUES (3378, 12, 'забронирован', '2026-03-20 11:42:00+03');
INSERT INTO public.table_status VALUES (3379, 12, 'занят', '2026-03-20 12:38:00+03');
INSERT INTO public.table_status VALUES (3380, 12, 'свободен', '2026-03-20 13:40:00+03');
INSERT INTO public.table_status VALUES (3381, 12, 'занят', '2026-03-20 14:05:00+03');
INSERT INTO public.table_status VALUES (3382, 12, 'свободен', '2026-03-20 15:38:00+03');
INSERT INTO public.table_status VALUES (3383, 12, 'забронирован', '2026-03-20 16:11:00+03');
INSERT INTO public.table_status VALUES (3384, 12, 'занят', '2026-03-20 16:43:00+03');
INSERT INTO public.table_status VALUES (3385, 12, 'свободен', '2026-03-20 17:25:00+03');
INSERT INTO public.table_status VALUES (3386, 12, 'занят', '2026-03-20 17:57:00+03');
INSERT INTO public.table_status VALUES (3387, 12, 'свободен', '2026-03-20 19:42:00+03');
INSERT INTO public.table_status VALUES (3388, 12, 'занят', '2026-03-20 20:02:00+03');
INSERT INTO public.table_status VALUES (3389, 12, 'свободен', '2026-03-20 21:02:00+03');
INSERT INTO public.table_status VALUES (3390, 1, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3391, 1, 'забронирован', '2026-03-21 10:33:00+03');
INSERT INTO public.table_status VALUES (3392, 1, 'занят', '2026-03-21 10:57:00+03');
INSERT INTO public.table_status VALUES (3393, 1, 'свободен', '2026-03-21 11:39:00+03');
INSERT INTO public.table_status VALUES (3394, 1, 'забронирован', '2026-03-21 12:17:00+03');
INSERT INTO public.table_status VALUES (3395, 1, 'занят', '2026-03-21 12:51:00+03');
INSERT INTO public.table_status VALUES (3396, 1, 'свободен', '2026-03-21 13:56:00+03');
INSERT INTO public.table_status VALUES (3397, 1, 'забронирован', '2026-03-21 16:28:00+03');
INSERT INTO public.table_status VALUES (3398, 1, 'занят', '2026-03-21 17:07:00+03');
INSERT INTO public.table_status VALUES (3399, 1, 'свободен', '2026-03-21 19:05:00+03');
INSERT INTO public.table_status VALUES (3400, 1, 'занят', '2026-03-21 19:15:00+03');
INSERT INTO public.table_status VALUES (3401, 1, 'свободен', '2026-03-21 20:44:00+03');
INSERT INTO public.table_status VALUES (3402, 2, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3403, 2, 'занят', '2026-03-21 10:15:00+03');
INSERT INTO public.table_status VALUES (3404, 2, 'свободен', '2026-03-21 11:56:00+03');
INSERT INTO public.table_status VALUES (3405, 2, 'забронирован', '2026-03-21 12:31:00+03');
INSERT INTO public.table_status VALUES (3406, 2, 'занят', '2026-03-21 13:12:00+03');
INSERT INTO public.table_status VALUES (3407, 2, 'свободен', '2026-03-21 14:07:00+03');
INSERT INTO public.table_status VALUES (3408, 2, 'забронирован', '2026-03-21 16:45:00+03');
INSERT INTO public.table_status VALUES (3409, 2, 'занят', '2026-03-21 17:10:00+03');
INSERT INTO public.table_status VALUES (3410, 2, 'свободен', '2026-03-21 17:53:00+03');
INSERT INTO public.table_status VALUES (3411, 2, 'забронирован', '2026-03-21 18:20:00+03');
INSERT INTO public.table_status VALUES (3412, 2, 'занят', '2026-03-21 19:06:00+03');
INSERT INTO public.table_status VALUES (3413, 2, 'свободен', '2026-03-21 20:28:00+03');
INSERT INTO public.table_status VALUES (3414, 2, 'занят', '2026-03-21 21:47:00+03');
INSERT INTO public.table_status VALUES (3415, 3, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3416, 3, 'занят', '2026-03-21 10:36:00+03');
INSERT INTO public.table_status VALUES (3417, 3, 'свободен', '2026-03-21 11:17:00+03');
INSERT INTO public.table_status VALUES (3418, 3, 'забронирован', '2026-03-21 11:41:00+03');
INSERT INTO public.table_status VALUES (3419, 3, 'занят', '2026-03-21 12:24:00+03');
INSERT INTO public.table_status VALUES (3420, 3, 'свободен', '2026-03-21 13:06:00+03');
INSERT INTO public.table_status VALUES (3421, 3, 'занят', '2026-03-21 13:22:00+03');
INSERT INTO public.table_status VALUES (3422, 3, 'свободен', '2026-03-21 14:10:00+03');
INSERT INTO public.table_status VALUES (3423, 3, 'забронирован', '2026-03-21 14:22:00+03');
INSERT INTO public.table_status VALUES (3424, 3, 'занят', '2026-03-21 14:54:00+03');
INSERT INTO public.table_status VALUES (3425, 3, 'свободен', '2026-03-21 15:43:00+03');
INSERT INTO public.table_status VALUES (3426, 3, 'забронирован', '2026-03-21 17:44:00+03');
INSERT INTO public.table_status VALUES (3427, 3, 'занят', '2026-03-21 18:28:00+03');
INSERT INTO public.table_status VALUES (3428, 3, 'свободен', '2026-03-21 20:15:00+03');
INSERT INTO public.table_status VALUES (3429, 3, 'занят', '2026-03-21 20:45:00+03');
INSERT INTO public.table_status VALUES (3430, 3, 'свободен', '2026-03-21 21:55:00+03');
INSERT INTO public.table_status VALUES (3431, 3, 'занят', '2026-03-21 22:34:00+03');
INSERT INTO public.table_status VALUES (3432, 4, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3433, 4, 'занят', '2026-03-21 12:52:00+03');
INSERT INTO public.table_status VALUES (3434, 4, 'свободен', '2026-03-21 14:24:00+03');
INSERT INTO public.table_status VALUES (3435, 4, 'занят', '2026-03-21 14:50:00+03');
INSERT INTO public.table_status VALUES (3436, 4, 'свободен', '2026-03-21 15:37:00+03');
INSERT INTO public.table_status VALUES (3437, 4, 'забронирован', '2026-03-21 18:57:00+03');
INSERT INTO public.table_status VALUES (3438, 4, 'занят', '2026-03-21 19:51:00+03');
INSERT INTO public.table_status VALUES (3439, 4, 'свободен', '2026-03-21 21:08:00+03');
INSERT INTO public.table_status VALUES (3440, 4, 'занят', '2026-03-21 21:31:00+03');
INSERT INTO public.table_status VALUES (3441, 5, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3442, 5, 'занят', '2026-03-21 10:12:00+03');
INSERT INTO public.table_status VALUES (3443, 5, 'свободен', '2026-03-21 10:58:00+03');
INSERT INTO public.table_status VALUES (3444, 5, 'забронирован', '2026-03-21 12:29:00+03');
INSERT INTO public.table_status VALUES (3445, 5, 'занят', '2026-03-21 13:24:00+03');
INSERT INTO public.table_status VALUES (3446, 5, 'свободен', '2026-03-21 14:55:00+03');
INSERT INTO public.table_status VALUES (3447, 5, 'занят', '2026-03-21 15:19:00+03');
INSERT INTO public.table_status VALUES (3448, 5, 'свободен', '2026-03-21 17:08:00+03');
INSERT INTO public.table_status VALUES (3449, 5, 'занят', '2026-03-21 17:36:00+03');
INSERT INTO public.table_status VALUES (3450, 5, 'свободен', '2026-03-21 19:02:00+03');
INSERT INTO public.table_status VALUES (3451, 5, 'занят', '2026-03-21 19:20:00+03');
INSERT INTO public.table_status VALUES (3452, 5, 'свободен', '2026-03-21 20:32:00+03');
INSERT INTO public.table_status VALUES (3453, 5, 'забронирован', '2026-03-21 22:14:00+03');
INSERT INTO public.table_status VALUES (3454, 6, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3455, 6, 'занят', '2026-03-21 10:34:00+03');
INSERT INTO public.table_status VALUES (3456, 6, 'свободен', '2026-03-21 12:06:00+03');
INSERT INTO public.table_status VALUES (3457, 6, 'занят', '2026-03-21 12:30:00+03');
INSERT INTO public.table_status VALUES (3458, 6, 'свободен', '2026-03-21 13:50:00+03');
INSERT INTO public.table_status VALUES (3459, 6, 'забронирован', '2026-03-21 14:15:00+03');
INSERT INTO public.table_status VALUES (3460, 6, 'занят', '2026-03-21 15:04:00+03');
INSERT INTO public.table_status VALUES (3461, 6, 'свободен', '2026-03-21 16:53:00+03');
INSERT INTO public.table_status VALUES (3462, 6, 'занят', '2026-03-21 17:23:00+03');
INSERT INTO public.table_status VALUES (3463, 6, 'свободен', '2026-03-21 18:19:00+03');
INSERT INTO public.table_status VALUES (3464, 6, 'забронирован', '2026-03-21 19:44:00+03');
INSERT INTO public.table_status VALUES (3465, 6, 'занят', '2026-03-21 20:09:00+03');
INSERT INTO public.table_status VALUES (3466, 6, 'свободен', '2026-03-21 20:51:00+03');
INSERT INTO public.table_status VALUES (3467, 7, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3468, 7, 'занят', '2026-03-21 10:32:00+03');
INSERT INTO public.table_status VALUES (3469, 7, 'свободен', '2026-03-21 12:15:00+03');
INSERT INTO public.table_status VALUES (3470, 7, 'занят', '2026-03-21 12:55:00+03');
INSERT INTO public.table_status VALUES (3471, 7, 'свободен', '2026-03-21 14:18:00+03');
INSERT INTO public.table_status VALUES (3472, 7, 'занят', '2026-03-21 14:38:00+03');
INSERT INTO public.table_status VALUES (3473, 7, 'свободен', '2026-03-21 16:07:00+03');
INSERT INTO public.table_status VALUES (3474, 7, 'занят', '2026-03-21 18:13:00+03');
INSERT INTO public.table_status VALUES (3475, 7, 'свободен', '2026-03-21 19:13:00+03');
INSERT INTO public.table_status VALUES (3476, 7, 'занят', '2026-03-21 19:33:00+03');
INSERT INTO public.table_status VALUES (3477, 7, 'свободен', '2026-03-21 21:21:00+03');
INSERT INTO public.table_status VALUES (3478, 7, 'занят', '2026-03-21 21:43:00+03');
INSERT INTO public.table_status VALUES (3479, 7, 'свободен', '2026-03-21 22:37:00+03');
INSERT INTO public.table_status VALUES (3480, 8, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3481, 8, 'занят', '2026-03-21 10:15:00+03');
INSERT INTO public.table_status VALUES (3482, 8, 'свободен', '2026-03-21 12:10:00+03');
INSERT INTO public.table_status VALUES (3483, 8, 'забронирован', '2026-03-21 14:06:00+03');
INSERT INTO public.table_status VALUES (3484, 8, 'занят', '2026-03-21 14:41:00+03');
INSERT INTO public.table_status VALUES (3485, 8, 'свободен', '2026-03-21 16:22:00+03');
INSERT INTO public.table_status VALUES (3486, 8, 'занят', '2026-03-21 17:59:00+03');
INSERT INTO public.table_status VALUES (3487, 8, 'свободен', '2026-03-21 19:12:00+03');
INSERT INTO public.table_status VALUES (3488, 8, 'занят', '2026-03-21 19:26:00+03');
INSERT INTO public.table_status VALUES (3489, 8, 'свободен', '2026-03-21 20:54:00+03');
INSERT INTO public.table_status VALUES (3490, 8, 'занят', '2026-03-21 21:34:00+03');
INSERT INTO public.table_status VALUES (3491, 8, 'свободен', '2026-03-21 22:16:00+03');
INSERT INTO public.table_status VALUES (3492, 8, 'занят', '2026-03-21 22:52:00+03');
INSERT INTO public.table_status VALUES (3493, 9, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3494, 9, 'занят', '2026-03-21 12:28:00+03');
INSERT INTO public.table_status VALUES (3495, 9, 'свободен', '2026-03-21 14:12:00+03');
INSERT INTO public.table_status VALUES (3496, 9, 'забронирован', '2026-03-21 17:58:00+03');
INSERT INTO public.table_status VALUES (3497, 9, 'занят', '2026-03-21 18:32:00+03');
INSERT INTO public.table_status VALUES (3498, 9, 'свободен', '2026-03-21 19:16:00+03');
INSERT INTO public.table_status VALUES (3499, 9, 'занят', '2026-03-21 19:31:00+03');
INSERT INTO public.table_status VALUES (3500, 9, 'свободен', '2026-03-21 20:19:00+03');
INSERT INTO public.table_status VALUES (3501, 9, 'занят', '2026-03-21 20:49:00+03');
INSERT INTO public.table_status VALUES (3502, 9, 'свободен', '2026-03-21 21:32:00+03');
INSERT INTO public.table_status VALUES (3503, 9, 'занят', '2026-03-21 21:56:00+03');
INSERT INTO public.table_status VALUES (3504, 10, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3505, 10, 'занят', '2026-03-21 12:38:00+03');
INSERT INTO public.table_status VALUES (3506, 10, 'свободен', '2026-03-21 13:42:00+03');
INSERT INTO public.table_status VALUES (3507, 10, 'занят', '2026-03-21 13:54:00+03');
INSERT INTO public.table_status VALUES (3508, 10, 'свободен', '2026-03-21 15:03:00+03');
INSERT INTO public.table_status VALUES (3509, 10, 'забронирован', '2026-03-21 15:32:00+03');
INSERT INTO public.table_status VALUES (3510, 10, 'занят', '2026-03-21 16:31:00+03');
INSERT INTO public.table_status VALUES (3511, 10, 'свободен', '2026-03-21 18:14:00+03');
INSERT INTO public.table_status VALUES (3512, 10, 'занят', '2026-03-21 18:48:00+03');
INSERT INTO public.table_status VALUES (3513, 10, 'свободен', '2026-03-21 20:45:00+03');
INSERT INTO public.table_status VALUES (3514, 10, 'занят', '2026-03-21 21:19:00+03');
INSERT INTO public.table_status VALUES (3515, 11, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3516, 11, 'забронирован', '2026-03-21 10:24:00+03');
INSERT INTO public.table_status VALUES (3517, 11, 'занят', '2026-03-21 11:15:00+03');
INSERT INTO public.table_status VALUES (3518, 11, 'свободен', '2026-03-21 12:25:00+03');
INSERT INTO public.table_status VALUES (3519, 11, 'занят', '2026-03-21 12:50:00+03');
INSERT INTO public.table_status VALUES (3520, 11, 'свободен', '2026-03-21 14:20:00+03');
INSERT INTO public.table_status VALUES (3521, 11, 'занят', '2026-03-21 14:49:00+03');
INSERT INTO public.table_status VALUES (3522, 11, 'свободен', '2026-03-21 15:54:00+03');
INSERT INTO public.table_status VALUES (3523, 11, 'забронирован', '2026-03-21 16:32:00+03');
INSERT INTO public.table_status VALUES (3524, 11, 'занят', '2026-03-21 16:59:00+03');
INSERT INTO public.table_status VALUES (3525, 11, 'свободен', '2026-03-21 17:50:00+03');
INSERT INTO public.table_status VALUES (3526, 11, 'занят', '2026-03-21 18:23:00+03');
INSERT INTO public.table_status VALUES (3527, 11, 'свободен', '2026-03-21 19:38:00+03');
INSERT INTO public.table_status VALUES (3528, 11, 'забронирован', '2026-03-21 19:50:00+03');
INSERT INTO public.table_status VALUES (3529, 11, 'занят', '2026-03-21 20:31:00+03');
INSERT INTO public.table_status VALUES (3530, 11, 'свободен', '2026-03-21 22:28:00+03');
INSERT INTO public.table_status VALUES (3531, 12, 'свободен', '2026-03-21 10:00:00+03');
INSERT INTO public.table_status VALUES (3532, 12, 'занят', '2026-03-21 10:33:00+03');
INSERT INTO public.table_status VALUES (3533, 12, 'свободен', '2026-03-21 12:24:00+03');
INSERT INTO public.table_status VALUES (3534, 12, 'занят', '2026-03-21 14:18:00+03');
INSERT INTO public.table_status VALUES (3535, 12, 'свободен', '2026-03-21 15:19:00+03');
INSERT INTO public.table_status VALUES (3536, 12, 'забронирован', '2026-03-21 15:58:00+03');
INSERT INTO public.table_status VALUES (3537, 12, 'занят', '2026-03-21 16:37:00+03');
INSERT INTO public.table_status VALUES (3538, 12, 'свободен', '2026-03-21 17:50:00+03');
INSERT INTO public.table_status VALUES (3539, 12, 'занят', '2026-03-21 22:49:00+03');
INSERT INTO public.table_status VALUES (3540, 1, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3541, 1, 'забронирован', '2026-03-22 10:15:00+03');
INSERT INTO public.table_status VALUES (3542, 1, 'занят', '2026-03-22 11:04:00+03');
INSERT INTO public.table_status VALUES (3543, 1, 'свободен', '2026-03-22 12:48:00+03');
INSERT INTO public.table_status VALUES (3544, 1, 'занят', '2026-03-22 13:55:00+03');
INSERT INTO public.table_status VALUES (3545, 1, 'свободен', '2026-03-22 15:33:00+03');
INSERT INTO public.table_status VALUES (3546, 1, 'забронирован', '2026-03-22 18:55:00+03');
INSERT INTO public.table_status VALUES (3547, 1, 'занят', '2026-03-22 19:31:00+03');
INSERT INTO public.table_status VALUES (3548, 1, 'свободен', '2026-03-22 20:15:00+03');
INSERT INTO public.table_status VALUES (3549, 1, 'занят', '2026-03-22 21:33:00+03');
INSERT INTO public.table_status VALUES (3550, 2, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3551, 2, 'занят', '2026-03-22 11:59:00+03');
INSERT INTO public.table_status VALUES (3552, 2, 'свободен', '2026-03-22 13:00:00+03');
INSERT INTO public.table_status VALUES (3553, 2, 'занят', '2026-03-22 14:51:00+03');
INSERT INTO public.table_status VALUES (3554, 2, 'свободен', '2026-03-22 16:16:00+03');
INSERT INTO public.table_status VALUES (3555, 2, 'забронирован', '2026-03-22 17:54:00+03');
INSERT INTO public.table_status VALUES (3556, 2, 'занят', '2026-03-22 18:50:00+03');
INSERT INTO public.table_status VALUES (3557, 2, 'свободен', '2026-03-22 19:33:00+03');
INSERT INTO public.table_status VALUES (3558, 2, 'занят', '2026-03-22 20:11:00+03');
INSERT INTO public.table_status VALUES (3559, 2, 'свободен', '2026-03-22 20:56:00+03');
INSERT INTO public.table_status VALUES (3560, 2, 'занят', '2026-03-22 21:32:00+03');
INSERT INTO public.table_status VALUES (3561, 2, 'свободен', '2026-03-22 22:54:00+03');
INSERT INTO public.table_status VALUES (3562, 3, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3563, 3, 'занят', '2026-03-22 11:35:00+03');
INSERT INTO public.table_status VALUES (3564, 3, 'свободен', '2026-03-22 12:30:00+03');
INSERT INTO public.table_status VALUES (3565, 3, 'забронирован', '2026-03-22 13:00:00+03');
INSERT INTO public.table_status VALUES (3566, 3, 'занят', '2026-03-22 13:45:00+03');
INSERT INTO public.table_status VALUES (3567, 3, 'свободен', '2026-03-22 15:14:00+03');
INSERT INTO public.table_status VALUES (3568, 3, 'забронирован', '2026-03-22 15:40:00+03');
INSERT INTO public.table_status VALUES (3569, 3, 'занят', '2026-03-22 16:38:00+03');
INSERT INTO public.table_status VALUES (3570, 3, 'свободен', '2026-03-22 17:58:00+03');
INSERT INTO public.table_status VALUES (3571, 3, 'занят', '2026-03-22 22:19:00+03');
INSERT INTO public.table_status VALUES (3572, 4, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3573, 4, 'забронирован', '2026-03-22 11:19:00+03');
INSERT INTO public.table_status VALUES (3574, 4, 'занят', '2026-03-22 11:42:00+03');
INSERT INTO public.table_status VALUES (3575, 4, 'свободен', '2026-03-22 13:25:00+03');
INSERT INTO public.table_status VALUES (3576, 4, 'забронирован', '2026-03-22 16:26:00+03');
INSERT INTO public.table_status VALUES (3577, 4, 'занят', '2026-03-22 16:55:00+03');
INSERT INTO public.table_status VALUES (3578, 4, 'свободен', '2026-03-22 18:38:00+03');
INSERT INTO public.table_status VALUES (3579, 4, 'забронирован', '2026-03-22 20:28:00+03');
INSERT INTO public.table_status VALUES (3580, 4, 'занят', '2026-03-22 21:17:00+03');
INSERT INTO public.table_status VALUES (3581, 4, 'свободен', '2026-03-22 22:15:00+03');
INSERT INTO public.table_status VALUES (3582, 5, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3583, 5, 'забронирован', '2026-03-22 10:37:00+03');
INSERT INTO public.table_status VALUES (3584, 5, 'занят', '2026-03-22 11:21:00+03');
INSERT INTO public.table_status VALUES (3585, 5, 'свободен', '2026-03-22 13:12:00+03');
INSERT INTO public.table_status VALUES (3586, 5, 'занят', '2026-03-22 13:48:00+03');
INSERT INTO public.table_status VALUES (3587, 5, 'свободен', '2026-03-22 15:47:00+03');
INSERT INTO public.table_status VALUES (3588, 5, 'занят', '2026-03-22 16:23:00+03');
INSERT INTO public.table_status VALUES (3589, 5, 'свободен', '2026-03-22 17:31:00+03');
INSERT INTO public.table_status VALUES (3590, 5, 'занят', '2026-03-22 20:25:00+03');
INSERT INTO public.table_status VALUES (3591, 5, 'свободен', '2026-03-22 21:32:00+03');
INSERT INTO public.table_status VALUES (3592, 5, 'занят', '2026-03-22 21:50:00+03');
INSERT INTO public.table_status VALUES (3593, 6, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3594, 6, 'занят', '2026-03-22 14:31:00+03');
INSERT INTO public.table_status VALUES (3595, 6, 'свободен', '2026-03-22 16:08:00+03');
INSERT INTO public.table_status VALUES (3596, 6, 'забронирован', '2026-03-22 16:29:00+03');
INSERT INTO public.table_status VALUES (3597, 6, 'занят', '2026-03-22 17:09:00+03');
INSERT INTO public.table_status VALUES (3598, 6, 'свободен', '2026-03-22 18:21:00+03');
INSERT INTO public.table_status VALUES (3599, 6, 'забронирован', '2026-03-22 19:58:00+03');
INSERT INTO public.table_status VALUES (3600, 6, 'занят', '2026-03-22 20:19:00+03');
INSERT INTO public.table_status VALUES (3601, 6, 'свободен', '2026-03-22 21:21:00+03');
INSERT INTO public.table_status VALUES (3602, 6, 'занят', '2026-03-22 21:31:00+03');
INSERT INTO public.table_status VALUES (3603, 7, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3604, 7, 'занят', '2026-03-22 12:51:00+03');
INSERT INTO public.table_status VALUES (3605, 7, 'свободен', '2026-03-22 14:11:00+03');
INSERT INTO public.table_status VALUES (3606, 7, 'занят', '2026-03-22 15:38:00+03');
INSERT INTO public.table_status VALUES (3607, 7, 'свободен', '2026-03-22 16:24:00+03');
INSERT INTO public.table_status VALUES (3608, 7, 'забронирован', '2026-03-22 17:25:00+03');
INSERT INTO public.table_status VALUES (3609, 7, 'занят', '2026-03-22 18:25:00+03');
INSERT INTO public.table_status VALUES (3610, 7, 'свободен', '2026-03-22 19:47:00+03');
INSERT INTO public.table_status VALUES (3611, 7, 'занят', '2026-03-22 22:44:00+03');
INSERT INTO public.table_status VALUES (3612, 8, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3613, 8, 'занят', '2026-03-22 10:40:00+03');
INSERT INTO public.table_status VALUES (3614, 8, 'свободен', '2026-03-22 11:58:00+03');
INSERT INTO public.table_status VALUES (3615, 8, 'занят', '2026-03-22 16:43:00+03');
INSERT INTO public.table_status VALUES (3616, 8, 'свободен', '2026-03-22 17:51:00+03');
INSERT INTO public.table_status VALUES (3617, 8, 'забронирован', '2026-03-22 18:10:00+03');
INSERT INTO public.table_status VALUES (3618, 8, 'занят', '2026-03-22 18:33:00+03');
INSERT INTO public.table_status VALUES (3619, 8, 'свободен', '2026-03-22 19:14:00+03');
INSERT INTO public.table_status VALUES (3620, 8, 'занят', '2026-03-22 19:42:00+03');
INSERT INTO public.table_status VALUES (3621, 8, 'свободен', '2026-03-22 20:42:00+03');
INSERT INTO public.table_status VALUES (3622, 8, 'занят', '2026-03-22 22:54:00+03');
INSERT INTO public.table_status VALUES (3623, 9, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3624, 9, 'занят', '2026-03-22 10:14:00+03');
INSERT INTO public.table_status VALUES (3625, 9, 'свободен', '2026-03-22 12:06:00+03');
INSERT INTO public.table_status VALUES (3626, 9, 'занят', '2026-03-22 13:59:00+03');
INSERT INTO public.table_status VALUES (3627, 9, 'свободен', '2026-03-22 15:24:00+03');
INSERT INTO public.table_status VALUES (3628, 9, 'занят', '2026-03-22 15:57:00+03');
INSERT INTO public.table_status VALUES (3629, 9, 'свободен', '2026-03-22 17:45:00+03');
INSERT INTO public.table_status VALUES (3630, 9, 'забронирован', '2026-03-22 18:14:00+03');
INSERT INTO public.table_status VALUES (3631, 9, 'занят', '2026-03-22 19:03:00+03');
INSERT INTO public.table_status VALUES (3632, 9, 'свободен', '2026-03-22 20:41:00+03');
INSERT INTO public.table_status VALUES (3633, 9, 'занят', '2026-03-22 22:03:00+03');
INSERT INTO public.table_status VALUES (3634, 10, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3635, 10, 'забронирован', '2026-03-22 10:37:00+03');
INSERT INTO public.table_status VALUES (3636, 10, 'занят', '2026-03-22 11:09:00+03');
INSERT INTO public.table_status VALUES (3637, 10, 'свободен', '2026-03-22 12:21:00+03');
INSERT INTO public.table_status VALUES (3638, 10, 'занят', '2026-03-22 14:07:00+03');
INSERT INTO public.table_status VALUES (3639, 10, 'свободен', '2026-03-22 15:44:00+03');
INSERT INTO public.table_status VALUES (3640, 10, 'занят', '2026-03-22 16:54:00+03');
INSERT INTO public.table_status VALUES (3641, 10, 'свободен', '2026-03-22 17:53:00+03');
INSERT INTO public.table_status VALUES (3642, 10, 'занят', '2026-03-22 18:26:00+03');
INSERT INTO public.table_status VALUES (3643, 10, 'свободен', '2026-03-22 19:20:00+03');
INSERT INTO public.table_status VALUES (3644, 10, 'занят', '2026-03-22 20:22:00+03');
INSERT INTO public.table_status VALUES (3645, 10, 'свободен', '2026-03-22 21:26:00+03');
INSERT INTO public.table_status VALUES (3646, 11, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3647, 11, 'забронирован', '2026-03-22 10:28:00+03');
INSERT INTO public.table_status VALUES (3648, 11, 'занят', '2026-03-22 11:07:00+03');
INSERT INTO public.table_status VALUES (3649, 11, 'свободен', '2026-03-22 13:00:00+03');
INSERT INTO public.table_status VALUES (3650, 11, 'занят', '2026-03-22 14:11:00+03');
INSERT INTO public.table_status VALUES (3651, 11, 'свободен', '2026-03-22 15:23:00+03');
INSERT INTO public.table_status VALUES (3652, 11, 'занят', '2026-03-22 15:33:00+03');
INSERT INTO public.table_status VALUES (3653, 11, 'свободен', '2026-03-22 16:41:00+03');
INSERT INTO public.table_status VALUES (3654, 11, 'забронирован', '2026-03-22 17:53:00+03');
INSERT INTO public.table_status VALUES (3655, 11, 'занят', '2026-03-22 18:44:00+03');
INSERT INTO public.table_status VALUES (3656, 11, 'свободен', '2026-03-22 20:27:00+03');
INSERT INTO public.table_status VALUES (3657, 11, 'забронирован', '2026-03-22 20:56:00+03');
INSERT INTO public.table_status VALUES (3658, 11, 'занят', '2026-03-22 21:23:00+03');
INSERT INTO public.table_status VALUES (3659, 12, 'свободен', '2026-03-22 10:00:00+03');
INSERT INTO public.table_status VALUES (3660, 12, 'забронирован', '2026-03-22 10:28:00+03');
INSERT INTO public.table_status VALUES (3661, 12, 'занят', '2026-03-22 10:48:00+03');
INSERT INTO public.table_status VALUES (3662, 12, 'свободен', '2026-03-22 11:55:00+03');
INSERT INTO public.table_status VALUES (3663, 12, 'занят', '2026-03-22 15:09:00+03');
INSERT INTO public.table_status VALUES (3664, 12, 'свободен', '2026-03-22 16:57:00+03');
INSERT INTO public.table_status VALUES (3665, 12, 'занят', '2026-03-22 17:27:00+03');
INSERT INTO public.table_status VALUES (3666, 12, 'свободен', '2026-03-22 19:08:00+03');
INSERT INTO public.table_status VALUES (3667, 12, 'занят', '2026-03-22 19:22:00+03');
INSERT INTO public.table_status VALUES (3668, 12, 'свободен', '2026-03-22 20:07:00+03');
INSERT INTO public.table_status VALUES (3669, 1, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3670, 1, 'занят', '2026-03-23 12:31:00+03');
INSERT INTO public.table_status VALUES (3671, 1, 'свободен', '2026-03-23 14:14:00+03');
INSERT INTO public.table_status VALUES (3672, 1, 'забронирован', '2026-03-23 16:12:00+03');
INSERT INTO public.table_status VALUES (3673, 1, 'занят', '2026-03-23 17:10:00+03');
INSERT INTO public.table_status VALUES (3674, 1, 'свободен', '2026-03-23 18:07:00+03');
INSERT INTO public.table_status VALUES (3675, 1, 'занят', '2026-03-23 19:36:00+03');
INSERT INTO public.table_status VALUES (3676, 1, 'свободен', '2026-03-23 20:24:00+03');
INSERT INTO public.table_status VALUES (3677, 1, 'занят', '2026-03-23 20:44:00+03');
INSERT INTO public.table_status VALUES (3678, 1, 'свободен', '2026-03-23 21:34:00+03');
INSERT INTO public.table_status VALUES (3679, 1, 'занят', '2026-03-23 22:28:00+03');
INSERT INTO public.table_status VALUES (3680, 2, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3681, 2, 'занят', '2026-03-23 10:31:00+03');
INSERT INTO public.table_status VALUES (3682, 2, 'свободен', '2026-03-23 12:11:00+03');
INSERT INTO public.table_status VALUES (3683, 2, 'забронирован', '2026-03-23 14:50:00+03');
INSERT INTO public.table_status VALUES (3684, 2, 'занят', '2026-03-23 15:33:00+03');
INSERT INTO public.table_status VALUES (3685, 2, 'свободен', '2026-03-23 16:56:00+03');
INSERT INTO public.table_status VALUES (3686, 2, 'забронирован', '2026-03-23 18:44:00+03');
INSERT INTO public.table_status VALUES (3687, 2, 'занят', '2026-03-23 19:38:00+03');
INSERT INTO public.table_status VALUES (3688, 2, 'свободен', '2026-03-23 20:20:00+03');
INSERT INTO public.table_status VALUES (3689, 2, 'занят', '2026-03-23 22:02:00+03');
INSERT INTO public.table_status VALUES (3690, 3, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3691, 3, 'занят', '2026-03-23 10:59:00+03');
INSERT INTO public.table_status VALUES (3692, 3, 'свободен', '2026-03-23 12:40:00+03');
INSERT INTO public.table_status VALUES (3693, 3, 'забронирован', '2026-03-23 19:21:00+03');
INSERT INTO public.table_status VALUES (3694, 3, 'занят', '2026-03-23 19:53:00+03');
INSERT INTO public.table_status VALUES (3695, 3, 'свободен', '2026-03-23 21:32:00+03');
INSERT INTO public.table_status VALUES (3696, 3, 'занят', '2026-03-23 21:48:00+03');
INSERT INTO public.table_status VALUES (3697, 4, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3698, 4, 'забронирован', '2026-03-23 10:13:00+03');
INSERT INTO public.table_status VALUES (3699, 4, 'занят', '2026-03-23 11:11:00+03');
INSERT INTO public.table_status VALUES (3700, 4, 'свободен', '2026-03-23 13:07:00+03');
INSERT INTO public.table_status VALUES (3701, 4, 'забронирован', '2026-03-23 14:04:00+03');
INSERT INTO public.table_status VALUES (3702, 4, 'занят', '2026-03-23 14:48:00+03');
INSERT INTO public.table_status VALUES (3703, 4, 'свободен', '2026-03-23 16:44:00+03');
INSERT INTO public.table_status VALUES (3704, 4, 'занят', '2026-03-23 17:14:00+03');
INSERT INTO public.table_status VALUES (3705, 4, 'свободен', '2026-03-23 19:07:00+03');
INSERT INTO public.table_status VALUES (3706, 4, 'занят', '2026-03-23 20:19:00+03');
INSERT INTO public.table_status VALUES (3707, 4, 'свободен', '2026-03-23 21:02:00+03');
INSERT INTO public.table_status VALUES (3708, 5, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3709, 5, 'занят', '2026-03-23 11:36:00+03');
INSERT INTO public.table_status VALUES (3710, 5, 'свободен', '2026-03-23 12:46:00+03');
INSERT INTO public.table_status VALUES (3711, 5, 'занят', '2026-03-23 15:43:00+03');
INSERT INTO public.table_status VALUES (3712, 5, 'свободен', '2026-03-23 16:33:00+03');
INSERT INTO public.table_status VALUES (3713, 5, 'забронирован', '2026-03-23 18:18:00+03');
INSERT INTO public.table_status VALUES (3714, 5, 'занят', '2026-03-23 18:55:00+03');
INSERT INTO public.table_status VALUES (3715, 5, 'свободен', '2026-03-23 20:50:00+03');
INSERT INTO public.table_status VALUES (3716, 5, 'занят', '2026-03-23 21:00:00+03');
INSERT INTO public.table_status VALUES (3717, 5, 'свободен', '2026-03-23 22:13:00+03');
INSERT INTO public.table_status VALUES (3718, 5, 'забронирован', '2026-03-23 22:24:00+03');
INSERT INTO public.table_status VALUES (3719, 6, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3720, 6, 'забронирован', '2026-03-23 10:38:00+03');
INSERT INTO public.table_status VALUES (3721, 6, 'занят', '2026-03-23 11:10:00+03');
INSERT INTO public.table_status VALUES (3722, 6, 'свободен', '2026-03-23 12:03:00+03');
INSERT INTO public.table_status VALUES (3723, 6, 'занят', '2026-03-23 14:56:00+03');
INSERT INTO public.table_status VALUES (3724, 6, 'свободен', '2026-03-23 15:42:00+03');
INSERT INTO public.table_status VALUES (3725, 6, 'занят', '2026-03-23 17:09:00+03');
INSERT INTO public.table_status VALUES (3726, 6, 'свободен', '2026-03-23 17:58:00+03');
INSERT INTO public.table_status VALUES (3727, 6, 'забронирован', '2026-03-23 19:20:00+03');
INSERT INTO public.table_status VALUES (3728, 6, 'занят', '2026-03-23 20:06:00+03');
INSERT INTO public.table_status VALUES (3729, 6, 'свободен', '2026-03-23 21:44:00+03');
INSERT INTO public.table_status VALUES (3730, 7, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3731, 7, 'забронирован', '2026-03-23 10:11:00+03');
INSERT INTO public.table_status VALUES (3732, 7, 'занят', '2026-03-23 11:10:00+03');
INSERT INTO public.table_status VALUES (3733, 7, 'свободен', '2026-03-23 13:04:00+03');
INSERT INTO public.table_status VALUES (3734, 7, 'занят', '2026-03-23 13:14:00+03');
INSERT INTO public.table_status VALUES (3735, 7, 'свободен', '2026-03-23 14:45:00+03');
INSERT INTO public.table_status VALUES (3736, 7, 'забронирован', '2026-03-23 16:32:00+03');
INSERT INTO public.table_status VALUES (3737, 7, 'занят', '2026-03-23 17:26:00+03');
INSERT INTO public.table_status VALUES (3738, 7, 'свободен', '2026-03-23 19:21:00+03');
INSERT INTO public.table_status VALUES (3739, 7, 'занят', '2026-03-23 19:42:00+03');
INSERT INTO public.table_status VALUES (3740, 7, 'свободен', '2026-03-23 20:47:00+03');
INSERT INTO public.table_status VALUES (3741, 8, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3742, 8, 'забронирован', '2026-03-23 10:25:00+03');
INSERT INTO public.table_status VALUES (3743, 8, 'занят', '2026-03-23 11:20:00+03');
INSERT INTO public.table_status VALUES (3744, 8, 'свободен', '2026-03-23 12:10:00+03');
INSERT INTO public.table_status VALUES (3745, 8, 'занят', '2026-03-23 12:50:00+03');
INSERT INTO public.table_status VALUES (3746, 8, 'свободен', '2026-03-23 13:48:00+03');
INSERT INTO public.table_status VALUES (3747, 8, 'забронирован', '2026-03-23 15:18:00+03');
INSERT INTO public.table_status VALUES (3748, 8, 'занят', '2026-03-23 16:01:00+03');
INSERT INTO public.table_status VALUES (3749, 8, 'свободен', '2026-03-23 16:49:00+03');
INSERT INTO public.table_status VALUES (3750, 8, 'занят', '2026-03-23 17:05:00+03');
INSERT INTO public.table_status VALUES (3751, 8, 'свободен', '2026-03-23 18:04:00+03');
INSERT INTO public.table_status VALUES (3752, 8, 'занят', '2026-03-23 18:25:00+03');
INSERT INTO public.table_status VALUES (3753, 8, 'свободен', '2026-03-23 20:13:00+03');
INSERT INTO public.table_status VALUES (3754, 8, 'занят', '2026-03-23 21:25:00+03');
INSERT INTO public.table_status VALUES (3755, 8, 'свободен', '2026-03-23 22:28:00+03');
INSERT INTO public.table_status VALUES (3756, 9, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3757, 9, 'забронирован', '2026-03-23 11:37:00+03');
INSERT INTO public.table_status VALUES (3758, 9, 'занят', '2026-03-23 12:09:00+03');
INSERT INTO public.table_status VALUES (3759, 9, 'свободен', '2026-03-23 14:06:00+03');
INSERT INTO public.table_status VALUES (3760, 9, 'занят', '2026-03-23 15:37:00+03');
INSERT INTO public.table_status VALUES (3761, 9, 'свободен', '2026-03-23 17:27:00+03');
INSERT INTO public.table_status VALUES (3762, 9, 'занят', '2026-03-23 18:01:00+03');
INSERT INTO public.table_status VALUES (3763, 9, 'свободен', '2026-03-23 19:16:00+03');
INSERT INTO public.table_status VALUES (3764, 9, 'занят', '2026-03-23 20:15:00+03');
INSERT INTO public.table_status VALUES (3765, 9, 'свободен', '2026-03-23 22:13:00+03');
INSERT INTO public.table_status VALUES (3766, 10, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3767, 10, 'занят', '2026-03-23 10:11:00+03');
INSERT INTO public.table_status VALUES (3768, 10, 'свободен', '2026-03-23 11:43:00+03');
INSERT INTO public.table_status VALUES (3769, 10, 'занят', '2026-03-23 11:55:00+03');
INSERT INTO public.table_status VALUES (3770, 10, 'свободен', '2026-03-23 13:31:00+03');
INSERT INTO public.table_status VALUES (3771, 10, 'занят', '2026-03-23 13:57:00+03');
INSERT INTO public.table_status VALUES (3772, 10, 'свободен', '2026-03-23 14:55:00+03');
INSERT INTO public.table_status VALUES (3773, 10, 'забронирован', '2026-03-23 15:24:00+03');
INSERT INTO public.table_status VALUES (3774, 10, 'занят', '2026-03-23 16:18:00+03');
INSERT INTO public.table_status VALUES (3775, 10, 'свободен', '2026-03-23 17:51:00+03');
INSERT INTO public.table_status VALUES (3776, 10, 'занят', '2026-03-23 18:20:00+03');
INSERT INTO public.table_status VALUES (3777, 10, 'свободен', '2026-03-23 19:07:00+03');
INSERT INTO public.table_status VALUES (3778, 10, 'забронирован', '2026-03-23 21:17:00+03');
INSERT INTO public.table_status VALUES (3779, 10, 'занят', '2026-03-23 21:51:00+03');
INSERT INTO public.table_status VALUES (3780, 10, 'свободен', '2026-03-23 22:53:00+03');
INSERT INTO public.table_status VALUES (3781, 11, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3782, 11, 'занят', '2026-03-23 10:25:00+03');
INSERT INTO public.table_status VALUES (3783, 11, 'свободен', '2026-03-23 11:13:00+03');
INSERT INTO public.table_status VALUES (3784, 11, 'занят', '2026-03-23 11:36:00+03');
INSERT INTO public.table_status VALUES (3785, 11, 'свободен', '2026-03-23 12:28:00+03');
INSERT INTO public.table_status VALUES (3786, 11, 'занят', '2026-03-23 14:12:00+03');
INSERT INTO public.table_status VALUES (3787, 11, 'свободен', '2026-03-23 15:39:00+03');
INSERT INTO public.table_status VALUES (3788, 11, 'занят', '2026-03-23 15:59:00+03');
INSERT INTO public.table_status VALUES (3789, 11, 'свободен', '2026-03-23 17:40:00+03');
INSERT INTO public.table_status VALUES (3790, 11, 'занят', '2026-03-23 17:59:00+03');
INSERT INTO public.table_status VALUES (3791, 11, 'свободен', '2026-03-23 19:58:00+03');
INSERT INTO public.table_status VALUES (3792, 11, 'забронирован', '2026-03-23 20:20:00+03');
INSERT INTO public.table_status VALUES (3793, 11, 'занят', '2026-03-23 21:10:00+03');
INSERT INTO public.table_status VALUES (3794, 11, 'свободен', '2026-03-23 22:33:00+03');
INSERT INTO public.table_status VALUES (3795, 11, 'забронирован', '2026-03-23 22:43:00+03');
INSERT INTO public.table_status VALUES (3796, 12, 'свободен', '2026-03-23 10:00:00+03');
INSERT INTO public.table_status VALUES (3797, 12, 'занят', '2026-03-23 11:16:00+03');
INSERT INTO public.table_status VALUES (3798, 12, 'свободен', '2026-03-23 12:18:00+03');
INSERT INTO public.table_status VALUES (3799, 12, 'занят', '2026-03-23 16:42:00+03');
INSERT INTO public.table_status VALUES (3800, 12, 'свободен', '2026-03-23 18:04:00+03');
INSERT INTO public.table_status VALUES (3801, 12, 'забронирован', '2026-03-23 18:22:00+03');
INSERT INTO public.table_status VALUES (3802, 12, 'занят', '2026-03-23 19:15:00+03');
INSERT INTO public.table_status VALUES (3803, 12, 'свободен', '2026-03-23 20:35:00+03');
INSERT INTO public.table_status VALUES (3804, 12, 'забронирован', '2026-03-23 21:13:00+03');
INSERT INTO public.table_status VALUES (3805, 12, 'занят', '2026-03-23 21:46:00+03');
INSERT INTO public.table_status VALUES (3806, 1, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3807, 1, 'забронирован', '2026-03-24 10:22:00+03');
INSERT INTO public.table_status VALUES (3808, 1, 'занят', '2026-03-24 10:43:00+03');
INSERT INTO public.table_status VALUES (3809, 1, 'свободен', '2026-03-24 12:02:00+03');
INSERT INTO public.table_status VALUES (3810, 1, 'занят', '2026-03-24 15:21:00+03');
INSERT INTO public.table_status VALUES (3811, 1, 'свободен', '2026-03-24 16:31:00+03');
INSERT INTO public.table_status VALUES (3812, 1, 'занят', '2026-03-24 16:44:00+03');
INSERT INTO public.table_status VALUES (3813, 1, 'свободен', '2026-03-24 18:43:00+03');
INSERT INTO public.table_status VALUES (3814, 1, 'занят', '2026-03-24 19:40:00+03');
INSERT INTO public.table_status VALUES (3815, 1, 'свободен', '2026-03-24 21:32:00+03');
INSERT INTO public.table_status VALUES (3816, 1, 'забронирован', '2026-03-24 21:53:00+03');
INSERT INTO public.table_status VALUES (3817, 1, 'занят', '2026-03-24 22:30:00+03');
INSERT INTO public.table_status VALUES (3818, 2, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3819, 2, 'занят', '2026-03-24 10:12:00+03');
INSERT INTO public.table_status VALUES (3820, 2, 'свободен', '2026-03-24 11:39:00+03');
INSERT INTO public.table_status VALUES (3821, 2, 'занят', '2026-03-24 14:32:00+03');
INSERT INTO public.table_status VALUES (3822, 2, 'свободен', '2026-03-24 15:12:00+03');
INSERT INTO public.table_status VALUES (3823, 2, 'занят', '2026-03-24 15:31:00+03');
INSERT INTO public.table_status VALUES (3824, 2, 'свободен', '2026-03-24 16:45:00+03');
INSERT INTO public.table_status VALUES (3825, 2, 'занят', '2026-03-24 17:13:00+03');
INSERT INTO public.table_status VALUES (3826, 2, 'свободен', '2026-03-24 19:04:00+03');
INSERT INTO public.table_status VALUES (3827, 2, 'забронирован', '2026-03-24 19:39:00+03');
INSERT INTO public.table_status VALUES (3828, 2, 'занят', '2026-03-24 20:21:00+03');
INSERT INTO public.table_status VALUES (3829, 2, 'свободен', '2026-03-24 21:10:00+03');
INSERT INTO public.table_status VALUES (3830, 2, 'занят', '2026-03-24 21:22:00+03');
INSERT INTO public.table_status VALUES (3831, 3, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3832, 3, 'занят', '2026-03-24 13:40:00+03');
INSERT INTO public.table_status VALUES (3833, 3, 'свободен', '2026-03-24 15:39:00+03');
INSERT INTO public.table_status VALUES (3834, 3, 'занят', '2026-03-24 18:40:00+03');
INSERT INTO public.table_status VALUES (3835, 3, 'свободен', '2026-03-24 19:31:00+03');
INSERT INTO public.table_status VALUES (3836, 3, 'занят', '2026-03-24 20:08:00+03');
INSERT INTO public.table_status VALUES (3837, 3, 'свободен', '2026-03-24 21:21:00+03');
INSERT INTO public.table_status VALUES (3838, 3, 'забронирован', '2026-03-24 22:00:00+03');
INSERT INTO public.table_status VALUES (3839, 3, 'занят', '2026-03-24 22:28:00+03');
INSERT INTO public.table_status VALUES (3840, 4, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3841, 4, 'занят', '2026-03-24 10:34:00+03');
INSERT INTO public.table_status VALUES (3842, 4, 'свободен', '2026-03-24 12:06:00+03');
INSERT INTO public.table_status VALUES (3843, 4, 'забронирован', '2026-03-24 12:39:00+03');
INSERT INTO public.table_status VALUES (3844, 4, 'занят', '2026-03-24 13:26:00+03');
INSERT INTO public.table_status VALUES (3845, 4, 'свободен', '2026-03-24 14:48:00+03');
INSERT INTO public.table_status VALUES (3846, 4, 'забронирован', '2026-03-24 15:14:00+03');
INSERT INTO public.table_status VALUES (3847, 4, 'занят', '2026-03-24 15:41:00+03');
INSERT INTO public.table_status VALUES (3848, 4, 'свободен', '2026-03-24 17:00:00+03');
INSERT INTO public.table_status VALUES (3849, 4, 'забронирован', '2026-03-24 17:34:00+03');
INSERT INTO public.table_status VALUES (3850, 4, 'занят', '2026-03-24 18:21:00+03');
INSERT INTO public.table_status VALUES (3851, 4, 'свободен', '2026-03-24 19:58:00+03');
INSERT INTO public.table_status VALUES (3852, 4, 'занят', '2026-03-24 21:42:00+03');
INSERT INTO public.table_status VALUES (3853, 5, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3854, 5, 'занят', '2026-03-24 12:29:00+03');
INSERT INTO public.table_status VALUES (3855, 5, 'свободен', '2026-03-24 14:27:00+03');
INSERT INTO public.table_status VALUES (3856, 5, 'занят', '2026-03-24 14:57:00+03');
INSERT INTO public.table_status VALUES (3857, 5, 'свободен', '2026-03-24 15:57:00+03');
INSERT INTO public.table_status VALUES (3858, 5, 'занят', '2026-03-24 16:19:00+03');
INSERT INTO public.table_status VALUES (3859, 5, 'свободен', '2026-03-24 17:33:00+03');
INSERT INTO public.table_status VALUES (3860, 5, 'занят', '2026-03-24 19:01:00+03');
INSERT INTO public.table_status VALUES (3861, 5, 'свободен', '2026-03-24 19:57:00+03');
INSERT INTO public.table_status VALUES (3862, 5, 'занят', '2026-03-24 20:21:00+03');
INSERT INTO public.table_status VALUES (3863, 5, 'свободен', '2026-03-24 21:46:00+03');
INSERT INTO public.table_status VALUES (3864, 5, 'забронирован', '2026-03-24 22:21:00+03');
INSERT INTO public.table_status VALUES (3865, 6, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3866, 6, 'занят', '2026-03-24 10:26:00+03');
INSERT INTO public.table_status VALUES (3867, 6, 'свободен', '2026-03-24 12:13:00+03');
INSERT INTO public.table_status VALUES (3868, 6, 'занят', '2026-03-24 12:51:00+03');
INSERT INTO public.table_status VALUES (3869, 6, 'свободен', '2026-03-24 14:19:00+03');
INSERT INTO public.table_status VALUES (3870, 6, 'занят', '2026-03-24 14:31:00+03');
INSERT INTO public.table_status VALUES (3871, 6, 'свободен', '2026-03-24 15:32:00+03');
INSERT INTO public.table_status VALUES (3872, 6, 'забронирован', '2026-03-24 16:37:00+03');
INSERT INTO public.table_status VALUES (3873, 6, 'занят', '2026-03-24 17:33:00+03');
INSERT INTO public.table_status VALUES (3874, 6, 'свободен', '2026-03-24 19:24:00+03');
INSERT INTO public.table_status VALUES (3875, 6, 'занят', '2026-03-24 20:45:00+03');
INSERT INTO public.table_status VALUES (3876, 6, 'свободен', '2026-03-24 22:13:00+03');
INSERT INTO public.table_status VALUES (3877, 6, 'занят', '2026-03-24 22:27:00+03');
INSERT INTO public.table_status VALUES (3878, 7, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3879, 7, 'забронирован', '2026-03-24 11:08:00+03');
INSERT INTO public.table_status VALUES (3880, 7, 'занят', '2026-03-24 11:47:00+03');
INSERT INTO public.table_status VALUES (3881, 7, 'свободен', '2026-03-24 13:37:00+03');
INSERT INTO public.table_status VALUES (3882, 7, 'занят', '2026-03-24 15:03:00+03');
INSERT INTO public.table_status VALUES (3883, 7, 'свободен', '2026-03-24 15:53:00+03');
INSERT INTO public.table_status VALUES (3884, 7, 'занят', '2026-03-24 16:27:00+03');
INSERT INTO public.table_status VALUES (3885, 7, 'свободен', '2026-03-24 18:02:00+03');
INSERT INTO public.table_status VALUES (3886, 7, 'занят', '2026-03-24 18:12:00+03');
INSERT INTO public.table_status VALUES (3887, 7, 'свободен', '2026-03-24 19:24:00+03');
INSERT INTO public.table_status VALUES (3888, 7, 'занят', '2026-03-24 20:54:00+03');
INSERT INTO public.table_status VALUES (3889, 7, 'свободен', '2026-03-24 22:13:00+03');
INSERT INTO public.table_status VALUES (3890, 7, 'занят', '2026-03-24 22:26:00+03');
INSERT INTO public.table_status VALUES (3891, 8, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3892, 8, 'занят', '2026-03-24 10:25:00+03');
INSERT INTO public.table_status VALUES (3893, 8, 'свободен', '2026-03-24 11:35:00+03');
INSERT INTO public.table_status VALUES (3894, 8, 'забронирован', '2026-03-24 11:53:00+03');
INSERT INTO public.table_status VALUES (3895, 8, 'занят', '2026-03-24 12:29:00+03');
INSERT INTO public.table_status VALUES (3896, 8, 'свободен', '2026-03-24 13:52:00+03');
INSERT INTO public.table_status VALUES (3897, 8, 'занят', '2026-03-24 14:04:00+03');
INSERT INTO public.table_status VALUES (3898, 8, 'свободен', '2026-03-24 14:52:00+03');
INSERT INTO public.table_status VALUES (3899, 8, 'забронирован', '2026-03-24 15:17:00+03');
INSERT INTO public.table_status VALUES (3900, 8, 'занят', '2026-03-24 16:09:00+03');
INSERT INTO public.table_status VALUES (3901, 8, 'свободен', '2026-03-24 18:01:00+03');
INSERT INTO public.table_status VALUES (3902, 8, 'забронирован', '2026-03-24 18:41:00+03');
INSERT INTO public.table_status VALUES (3903, 8, 'занят', '2026-03-24 19:24:00+03');
INSERT INTO public.table_status VALUES (3904, 8, 'свободен', '2026-03-24 20:46:00+03');
INSERT INTO public.table_status VALUES (3905, 9, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3906, 9, 'занят', '2026-03-24 10:17:00+03');
INSERT INTO public.table_status VALUES (3907, 9, 'свободен', '2026-03-24 12:12:00+03');
INSERT INTO public.table_status VALUES (3908, 9, 'занят', '2026-03-24 15:03:00+03');
INSERT INTO public.table_status VALUES (3909, 9, 'свободен', '2026-03-24 16:13:00+03');
INSERT INTO public.table_status VALUES (3910, 9, 'занят', '2026-03-24 16:25:00+03');
INSERT INTO public.table_status VALUES (3911, 9, 'свободен', '2026-03-24 17:10:00+03');
INSERT INTO public.table_status VALUES (3912, 9, 'занят', '2026-03-24 17:22:00+03');
INSERT INTO public.table_status VALUES (3913, 9, 'свободен', '2026-03-24 18:14:00+03');
INSERT INTO public.table_status VALUES (3914, 9, 'занят', '2026-03-24 18:43:00+03');
INSERT INTO public.table_status VALUES (3915, 9, 'свободен', '2026-03-24 20:35:00+03');
INSERT INTO public.table_status VALUES (3916, 9, 'занят', '2026-03-24 20:45:00+03');
INSERT INTO public.table_status VALUES (3917, 9, 'свободен', '2026-03-24 21:56:00+03');
INSERT INTO public.table_status VALUES (3918, 9, 'занят', '2026-03-24 22:16:00+03');
INSERT INTO public.table_status VALUES (3919, 10, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3920, 10, 'занят', '2026-03-24 11:31:00+03');
INSERT INTO public.table_status VALUES (3921, 10, 'свободен', '2026-03-24 12:22:00+03');
INSERT INTO public.table_status VALUES (3922, 10, 'забронирован', '2026-03-24 14:47:00+03');
INSERT INTO public.table_status VALUES (3923, 10, 'занят', '2026-03-24 15:10:00+03');
INSERT INTO public.table_status VALUES (3924, 10, 'свободен', '2026-03-24 16:19:00+03');
INSERT INTO public.table_status VALUES (3925, 10, 'занят', '2026-03-24 16:50:00+03');
INSERT INTO public.table_status VALUES (3926, 10, 'свободен', '2026-03-24 18:01:00+03');
INSERT INTO public.table_status VALUES (3927, 10, 'забронирован', '2026-03-24 19:32:00+03');
INSERT INTO public.table_status VALUES (3928, 10, 'занят', '2026-03-24 20:14:00+03');
INSERT INTO public.table_status VALUES (3929, 10, 'свободен', '2026-03-24 21:12:00+03');
INSERT INTO public.table_status VALUES (3930, 10, 'забронирован', '2026-03-24 21:24:00+03');
INSERT INTO public.table_status VALUES (3931, 10, 'занят', '2026-03-24 21:51:00+03');
INSERT INTO public.table_status VALUES (3932, 11, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3933, 11, 'забронирован', '2026-03-24 13:35:00+03');
INSERT INTO public.table_status VALUES (3934, 11, 'занят', '2026-03-24 14:22:00+03');
INSERT INTO public.table_status VALUES (3935, 11, 'свободен', '2026-03-24 16:09:00+03');
INSERT INTO public.table_status VALUES (3936, 11, 'занят', '2026-03-24 18:10:00+03');
INSERT INTO public.table_status VALUES (3937, 11, 'свободен', '2026-03-24 18:58:00+03');
INSERT INTO public.table_status VALUES (3938, 11, 'забронирован', '2026-03-24 20:28:00+03');
INSERT INTO public.table_status VALUES (3939, 11, 'занят', '2026-03-24 21:06:00+03');
INSERT INTO public.table_status VALUES (3940, 11, 'свободен', '2026-03-24 22:43:00+03');
INSERT INTO public.table_status VALUES (3941, 11, 'занят', '2026-03-24 22:57:00+03');
INSERT INTO public.table_status VALUES (3942, 12, 'свободен', '2026-03-24 10:00:00+03');
INSERT INTO public.table_status VALUES (3943, 12, 'занят', '2026-03-24 10:16:00+03');
INSERT INTO public.table_status VALUES (3944, 12, 'свободен', '2026-03-24 11:45:00+03');
INSERT INTO public.table_status VALUES (3945, 12, 'забронирован', '2026-03-24 12:21:00+03');
INSERT INTO public.table_status VALUES (3946, 12, 'занят', '2026-03-24 13:19:00+03');
INSERT INTO public.table_status VALUES (3947, 12, 'свободен', '2026-03-24 14:48:00+03');
INSERT INTO public.table_status VALUES (3948, 12, 'занят', '2026-03-24 15:05:00+03');
INSERT INTO public.table_status VALUES (3949, 12, 'свободен', '2026-03-24 16:46:00+03');
INSERT INTO public.table_status VALUES (3950, 12, 'занят', '2026-03-24 19:47:00+03');
INSERT INTO public.table_status VALUES (3951, 12, 'свободен', '2026-03-24 21:45:00+03');
INSERT INTO public.table_status VALUES (3952, 12, 'занят', '2026-03-24 22:03:00+03');
INSERT INTO public.table_status VALUES (3953, 1, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (3954, 1, 'занят', '2026-03-25 10:31:00+03');
INSERT INTO public.table_status VALUES (3955, 1, 'свободен', '2026-03-25 11:16:00+03');
INSERT INTO public.table_status VALUES (3956, 1, 'забронирован', '2026-03-25 11:50:00+03');
INSERT INTO public.table_status VALUES (3957, 1, 'занят', '2026-03-25 12:20:00+03');
INSERT INTO public.table_status VALUES (3958, 1, 'свободен', '2026-03-25 13:01:00+03');
INSERT INTO public.table_status VALUES (3959, 1, 'занят', '2026-03-25 16:40:00+03');
INSERT INTO public.table_status VALUES (3960, 1, 'свободен', '2026-03-25 18:06:00+03');
INSERT INTO public.table_status VALUES (3961, 1, 'занят', '2026-03-25 18:23:00+03');
INSERT INTO public.table_status VALUES (3962, 1, 'свободен', '2026-03-25 19:23:00+03');
INSERT INTO public.table_status VALUES (3963, 2, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (3964, 2, 'занят', '2026-03-25 10:34:00+03');
INSERT INTO public.table_status VALUES (3965, 2, 'свободен', '2026-03-25 11:18:00+03');
INSERT INTO public.table_status VALUES (3966, 2, 'забронирован', '2026-03-25 11:56:00+03');
INSERT INTO public.table_status VALUES (3967, 2, 'занят', '2026-03-25 12:44:00+03');
INSERT INTO public.table_status VALUES (3968, 2, 'свободен', '2026-03-25 14:05:00+03');
INSERT INTO public.table_status VALUES (3969, 2, 'занят', '2026-03-25 15:55:00+03');
INSERT INTO public.table_status VALUES (3970, 2, 'свободен', '2026-03-25 16:43:00+03');
INSERT INTO public.table_status VALUES (3971, 3, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (3972, 3, 'занят', '2026-03-25 11:26:00+03');
INSERT INTO public.table_status VALUES (3973, 3, 'свободен', '2026-03-25 13:05:00+03');
INSERT INTO public.table_status VALUES (3974, 3, 'забронирован', '2026-03-25 13:38:00+03');
INSERT INTO public.table_status VALUES (3975, 3, 'занят', '2026-03-25 14:17:00+03');
INSERT INTO public.table_status VALUES (3976, 3, 'свободен', '2026-03-25 15:50:00+03');
INSERT INTO public.table_status VALUES (3977, 3, 'занят', '2026-03-25 18:34:00+03');
INSERT INTO public.table_status VALUES (3978, 3, 'свободен', '2026-03-25 20:16:00+03');
INSERT INTO public.table_status VALUES (3979, 3, 'занят', '2026-03-25 21:51:00+03');
INSERT INTO public.table_status VALUES (3980, 4, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (3981, 4, 'занят', '2026-03-25 10:12:00+03');
INSERT INTO public.table_status VALUES (3982, 4, 'свободен', '2026-03-25 11:58:00+03');
INSERT INTO public.table_status VALUES (3983, 4, 'занят', '2026-03-25 12:11:00+03');
INSERT INTO public.table_status VALUES (3984, 4, 'свободен', '2026-03-25 13:17:00+03');
INSERT INTO public.table_status VALUES (3985, 4, 'забронирован', '2026-03-25 13:52:00+03');
INSERT INTO public.table_status VALUES (3986, 4, 'занят', '2026-03-25 14:32:00+03');
INSERT INTO public.table_status VALUES (3987, 4, 'свободен', '2026-03-25 15:12:00+03');
INSERT INTO public.table_status VALUES (3988, 4, 'забронирован', '2026-03-25 15:37:00+03');
INSERT INTO public.table_status VALUES (3989, 4, 'занят', '2026-03-25 16:19:00+03');
INSERT INTO public.table_status VALUES (3990, 4, 'свободен', '2026-03-25 18:08:00+03');
INSERT INTO public.table_status VALUES (3991, 4, 'занят', '2026-03-25 18:34:00+03');
INSERT INTO public.table_status VALUES (3992, 4, 'свободен', '2026-03-25 20:14:00+03');
INSERT INTO public.table_status VALUES (3993, 5, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (3994, 5, 'занят', '2026-03-25 10:34:00+03');
INSERT INTO public.table_status VALUES (3995, 5, 'свободен', '2026-03-25 11:39:00+03');
INSERT INTO public.table_status VALUES (3996, 5, 'занят', '2026-03-25 12:10:00+03');
INSERT INTO public.table_status VALUES (3997, 5, 'свободен', '2026-03-25 13:23:00+03');
INSERT INTO public.table_status VALUES (3998, 5, 'занят', '2026-03-25 14:49:00+03');
INSERT INTO public.table_status VALUES (3999, 5, 'свободен', '2026-03-25 16:26:00+03');
INSERT INTO public.table_status VALUES (4000, 5, 'забронирован', '2026-03-25 17:54:00+03');
INSERT INTO public.table_status VALUES (4001, 5, 'занят', '2026-03-25 18:14:00+03');
INSERT INTO public.table_status VALUES (4002, 5, 'свободен', '2026-03-25 20:02:00+03');
INSERT INTO public.table_status VALUES (4003, 5, 'забронирован', '2026-03-25 21:44:00+03');
INSERT INTO public.table_status VALUES (4004, 5, 'занят', '2026-03-25 22:34:00+03');
INSERT INTO public.table_status VALUES (4005, 6, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (4006, 6, 'забронирован', '2026-03-25 10:24:00+03');
INSERT INTO public.table_status VALUES (4007, 6, 'занят', '2026-03-25 11:21:00+03');
INSERT INTO public.table_status VALUES (4008, 6, 'свободен', '2026-03-25 12:52:00+03');
INSERT INTO public.table_status VALUES (4009, 6, 'занят', '2026-03-25 13:10:00+03');
INSERT INTO public.table_status VALUES (4010, 6, 'свободен', '2026-03-25 14:35:00+03');
INSERT INTO public.table_status VALUES (4011, 6, 'забронирован', '2026-03-25 19:48:00+03');
INSERT INTO public.table_status VALUES (4012, 6, 'занят', '2026-03-25 20:17:00+03');
INSERT INTO public.table_status VALUES (4013, 6, 'свободен', '2026-03-25 22:17:00+03');
INSERT INTO public.table_status VALUES (4014, 6, 'занят', '2026-03-25 22:50:00+03');
INSERT INTO public.table_status VALUES (4015, 7, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (4016, 7, 'занят', '2026-03-25 10:15:00+03');
INSERT INTO public.table_status VALUES (4017, 7, 'свободен', '2026-03-25 11:31:00+03');
INSERT INTO public.table_status VALUES (4018, 7, 'забронирован', '2026-03-25 11:50:00+03');
INSERT INTO public.table_status VALUES (4019, 7, 'занят', '2026-03-25 12:22:00+03');
INSERT INTO public.table_status VALUES (4020, 7, 'свободен', '2026-03-25 14:20:00+03');
INSERT INTO public.table_status VALUES (4021, 7, 'занят', '2026-03-25 14:37:00+03');
INSERT INTO public.table_status VALUES (4022, 7, 'свободен', '2026-03-25 15:49:00+03');
INSERT INTO public.table_status VALUES (4023, 7, 'забронирован', '2026-03-25 16:12:00+03');
INSERT INTO public.table_status VALUES (4024, 7, 'занят', '2026-03-25 16:40:00+03');
INSERT INTO public.table_status VALUES (4025, 7, 'свободен', '2026-03-25 17:51:00+03');
INSERT INTO public.table_status VALUES (4026, 7, 'забронирован', '2026-03-25 18:22:00+03');
INSERT INTO public.table_status VALUES (4027, 7, 'занят', '2026-03-25 18:53:00+03');
INSERT INTO public.table_status VALUES (4028, 7, 'свободен', '2026-03-25 20:16:00+03');
INSERT INTO public.table_status VALUES (4029, 7, 'занят', '2026-03-25 22:04:00+03');
INSERT INTO public.table_status VALUES (4030, 8, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (4031, 8, 'забронирован', '2026-03-25 10:14:00+03');
INSERT INTO public.table_status VALUES (4032, 8, 'занят', '2026-03-25 11:13:00+03');
INSERT INTO public.table_status VALUES (4033, 8, 'свободен', '2026-03-25 13:01:00+03');
INSERT INTO public.table_status VALUES (4034, 8, 'занят', '2026-03-25 13:37:00+03');
INSERT INTO public.table_status VALUES (4035, 8, 'свободен', '2026-03-25 14:39:00+03');
INSERT INTO public.table_status VALUES (4036, 8, 'занят', '2026-03-25 15:00:00+03');
INSERT INTO public.table_status VALUES (4037, 8, 'свободен', '2026-03-25 16:35:00+03');
INSERT INTO public.table_status VALUES (4038, 8, 'забронирован', '2026-03-25 17:06:00+03');
INSERT INTO public.table_status VALUES (4039, 8, 'занят', '2026-03-25 17:36:00+03');
INSERT INTO public.table_status VALUES (4040, 8, 'свободен', '2026-03-25 18:39:00+03');
INSERT INTO public.table_status VALUES (4041, 8, 'занят', '2026-03-25 21:24:00+03');
INSERT INTO public.table_status VALUES (4042, 9, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (4043, 9, 'занят', '2026-03-25 12:19:00+03');
INSERT INTO public.table_status VALUES (4044, 9, 'свободен', '2026-03-25 13:24:00+03');
INSERT INTO public.table_status VALUES (4045, 9, 'занят', '2026-03-25 14:49:00+03');
INSERT INTO public.table_status VALUES (4046, 9, 'свободен', '2026-03-25 16:10:00+03');
INSERT INTO public.table_status VALUES (4047, 9, 'забронирован', '2026-03-25 16:34:00+03');
INSERT INTO public.table_status VALUES (4048, 9, 'занят', '2026-03-25 17:15:00+03');
INSERT INTO public.table_status VALUES (4049, 9, 'свободен', '2026-03-25 18:14:00+03');
INSERT INTO public.table_status VALUES (4050, 9, 'занят', '2026-03-25 20:46:00+03');
INSERT INTO public.table_status VALUES (4051, 9, 'свободен', '2026-03-25 21:56:00+03');
INSERT INTO public.table_status VALUES (4052, 10, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (4053, 10, 'забронирован', '2026-03-25 10:29:00+03');
INSERT INTO public.table_status VALUES (4054, 10, 'занят', '2026-03-25 11:19:00+03');
INSERT INTO public.table_status VALUES (4055, 10, 'свободен', '2026-03-25 12:04:00+03');
INSERT INTO public.table_status VALUES (4056, 10, 'забронирован', '2026-03-25 12:17:00+03');
INSERT INTO public.table_status VALUES (4057, 10, 'занят', '2026-03-25 12:48:00+03');
INSERT INTO public.table_status VALUES (4058, 10, 'свободен', '2026-03-25 14:22:00+03');
INSERT INTO public.table_status VALUES (4059, 10, 'забронирован', '2026-03-25 15:00:00+03');
INSERT INTO public.table_status VALUES (4060, 10, 'занят', '2026-03-25 15:45:00+03');
INSERT INTO public.table_status VALUES (4061, 10, 'свободен', '2026-03-25 17:35:00+03');
INSERT INTO public.table_status VALUES (4062, 10, 'занят', '2026-03-25 18:10:00+03');
INSERT INTO public.table_status VALUES (4063, 10, 'свободен', '2026-03-25 20:04:00+03');
INSERT INTO public.table_status VALUES (4064, 10, 'забронирован', '2026-03-25 20:35:00+03');
INSERT INTO public.table_status VALUES (4065, 10, 'занят', '2026-03-25 21:23:00+03');
INSERT INTO public.table_status VALUES (4066, 10, 'свободен', '2026-03-25 22:25:00+03');
INSERT INTO public.table_status VALUES (4067, 10, 'забронирован', '2026-03-25 22:49:00+03');
INSERT INTO public.table_status VALUES (4068, 11, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (4069, 11, 'забронирован', '2026-03-25 10:12:00+03');
INSERT INTO public.table_status VALUES (4070, 11, 'занят', '2026-03-25 11:01:00+03');
INSERT INTO public.table_status VALUES (4071, 11, 'свободен', '2026-03-25 12:42:00+03');
INSERT INTO public.table_status VALUES (4072, 11, 'забронирован', '2026-03-25 13:16:00+03');
INSERT INTO public.table_status VALUES (4073, 11, 'занят', '2026-03-25 14:12:00+03');
INSERT INTO public.table_status VALUES (4074, 11, 'свободен', '2026-03-25 14:57:00+03');
INSERT INTO public.table_status VALUES (4075, 11, 'забронирован', '2026-03-25 16:58:00+03');
INSERT INTO public.table_status VALUES (4076, 11, 'занят', '2026-03-25 17:37:00+03');
INSERT INTO public.table_status VALUES (4077, 11, 'свободен', '2026-03-25 19:25:00+03');
INSERT INTO public.table_status VALUES (4078, 11, 'забронирован', '2026-03-25 21:04:00+03');
INSERT INTO public.table_status VALUES (4079, 11, 'занят', '2026-03-25 21:29:00+03');
INSERT INTO public.table_status VALUES (4080, 11, 'свободен', '2026-03-25 22:32:00+03');
INSERT INTO public.table_status VALUES (4081, 11, 'занят', '2026-03-25 22:44:00+03');
INSERT INTO public.table_status VALUES (4082, 12, 'свободен', '2026-03-25 10:00:00+03');
INSERT INTO public.table_status VALUES (4083, 12, 'занят', '2026-03-25 16:54:00+03');
INSERT INTO public.table_status VALUES (4084, 12, 'свободен', '2026-03-25 17:37:00+03');
INSERT INTO public.table_status VALUES (4085, 12, 'занят', '2026-03-25 17:50:00+03');
INSERT INTO public.table_status VALUES (4086, 12, 'свободен', '2026-03-25 18:35:00+03');
INSERT INTO public.table_status VALUES (4087, 12, 'забронирован', '2026-03-25 19:01:00+03');
INSERT INTO public.table_status VALUES (4088, 12, 'занят', '2026-03-25 19:25:00+03');
INSERT INTO public.table_status VALUES (4089, 12, 'свободен', '2026-03-25 20:09:00+03');
INSERT INTO public.table_status VALUES (4090, 12, 'занят', '2026-03-25 20:29:00+03');
INSERT INTO public.table_status VALUES (4091, 12, 'свободен', '2026-03-25 21:11:00+03');
INSERT INTO public.table_status VALUES (4092, 12, 'забронирован', '2026-03-25 21:26:00+03');
INSERT INTO public.table_status VALUES (4093, 12, 'занят', '2026-03-25 22:15:00+03');
INSERT INTO public.table_status VALUES (4094, 1, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4095, 1, 'забронирован', '2026-03-26 10:18:00+03');
INSERT INTO public.table_status VALUES (4096, 1, 'занят', '2026-03-26 10:49:00+03');
INSERT INTO public.table_status VALUES (4097, 1, 'свободен', '2026-03-26 12:32:00+03');
INSERT INTO public.table_status VALUES (4098, 1, 'занят', '2026-03-26 15:31:00+03');
INSERT INTO public.table_status VALUES (4099, 1, 'свободен', '2026-03-26 17:28:00+03');
INSERT INTO public.table_status VALUES (4100, 1, 'занят', '2026-03-26 17:49:00+03');
INSERT INTO public.table_status VALUES (4101, 1, 'свободен', '2026-03-26 18:42:00+03');
INSERT INTO public.table_status VALUES (4102, 1, 'занят', '2026-03-26 19:07:00+03');
INSERT INTO public.table_status VALUES (4103, 1, 'свободен', '2026-03-26 21:04:00+03');
INSERT INTO public.table_status VALUES (4104, 1, 'забронирован', '2026-03-26 21:21:00+03');
INSERT INTO public.table_status VALUES (4105, 1, 'занят', '2026-03-26 22:07:00+03');
INSERT INTO public.table_status VALUES (4106, 2, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4107, 2, 'занят', '2026-03-26 11:40:00+03');
INSERT INTO public.table_status VALUES (4108, 2, 'свободен', '2026-03-26 12:57:00+03');
INSERT INTO public.table_status VALUES (4109, 2, 'забронирован', '2026-03-26 13:30:00+03');
INSERT INTO public.table_status VALUES (4110, 2, 'занят', '2026-03-26 13:54:00+03');
INSERT INTO public.table_status VALUES (4111, 2, 'свободен', '2026-03-26 14:41:00+03');
INSERT INTO public.table_status VALUES (4112, 2, 'забронирован', '2026-03-26 14:54:00+03');
INSERT INTO public.table_status VALUES (4113, 2, 'занят', '2026-03-26 15:37:00+03');
INSERT INTO public.table_status VALUES (4114, 2, 'свободен', '2026-03-26 17:27:00+03');
INSERT INTO public.table_status VALUES (4115, 2, 'занят', '2026-03-26 17:59:00+03');
INSERT INTO public.table_status VALUES (4116, 2, 'свободен', '2026-03-26 18:55:00+03');
INSERT INTO public.table_status VALUES (4117, 2, 'занят', '2026-03-26 20:18:00+03');
INSERT INTO public.table_status VALUES (4118, 2, 'свободен', '2026-03-26 21:12:00+03');
INSERT INTO public.table_status VALUES (4119, 2, 'занят', '2026-03-26 21:38:00+03');
INSERT INTO public.table_status VALUES (4120, 3, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4121, 3, 'занят', '2026-03-26 12:54:00+03');
INSERT INTO public.table_status VALUES (4122, 3, 'свободен', '2026-03-26 14:34:00+03');
INSERT INTO public.table_status VALUES (4123, 3, 'забронирован', '2026-03-26 15:03:00+03');
INSERT INTO public.table_status VALUES (4124, 3, 'занят', '2026-03-26 15:33:00+03');
INSERT INTO public.table_status VALUES (4125, 3, 'свободен', '2026-03-26 17:32:00+03');
INSERT INTO public.table_status VALUES (4126, 3, 'занят', '2026-03-26 17:44:00+03');
INSERT INTO public.table_status VALUES (4127, 3, 'свободен', '2026-03-26 18:43:00+03');
INSERT INTO public.table_status VALUES (4128, 3, 'забронирован', '2026-03-26 19:19:00+03');
INSERT INTO public.table_status VALUES (4129, 3, 'занят', '2026-03-26 19:46:00+03');
INSERT INTO public.table_status VALUES (4130, 3, 'свободен', '2026-03-26 21:33:00+03');
INSERT INTO public.table_status VALUES (4131, 3, 'забронирован', '2026-03-26 22:04:00+03');
INSERT INTO public.table_status VALUES (4132, 3, 'занят', '2026-03-26 22:56:00+03');
INSERT INTO public.table_status VALUES (4133, 4, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4134, 4, 'забронирован', '2026-03-26 10:20:00+03');
INSERT INTO public.table_status VALUES (4135, 4, 'занят', '2026-03-26 11:05:00+03');
INSERT INTO public.table_status VALUES (4136, 4, 'свободен', '2026-03-26 12:35:00+03');
INSERT INTO public.table_status VALUES (4137, 4, 'занят', '2026-03-26 13:00:00+03');
INSERT INTO public.table_status VALUES (4138, 4, 'свободен', '2026-03-26 14:24:00+03');
INSERT INTO public.table_status VALUES (4139, 4, 'забронирован', '2026-03-26 16:05:00+03');
INSERT INTO public.table_status VALUES (4140, 4, 'занят', '2026-03-26 16:48:00+03');
INSERT INTO public.table_status VALUES (4141, 4, 'свободен', '2026-03-26 17:45:00+03');
INSERT INTO public.table_status VALUES (4142, 4, 'занят', '2026-03-26 18:01:00+03');
INSERT INTO public.table_status VALUES (4143, 4, 'свободен', '2026-03-26 19:32:00+03');
INSERT INTO public.table_status VALUES (4144, 4, 'забронирован', '2026-03-26 20:33:00+03');
INSERT INTO public.table_status VALUES (4145, 4, 'занят', '2026-03-26 21:16:00+03');
INSERT INTO public.table_status VALUES (4146, 4, 'свободен', '2026-03-26 22:07:00+03');
INSERT INTO public.table_status VALUES (4147, 5, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4148, 5, 'занят', '2026-03-26 11:46:00+03');
INSERT INTO public.table_status VALUES (4149, 5, 'свободен', '2026-03-26 13:23:00+03');
INSERT INTO public.table_status VALUES (4150, 5, 'занят', '2026-03-26 13:43:00+03');
INSERT INTO public.table_status VALUES (4151, 5, 'свободен', '2026-03-26 14:55:00+03');
INSERT INTO public.table_status VALUES (4152, 5, 'забронирован', '2026-03-26 15:32:00+03');
INSERT INTO public.table_status VALUES (4153, 5, 'занят', '2026-03-26 16:28:00+03');
INSERT INTO public.table_status VALUES (4154, 5, 'свободен', '2026-03-26 17:17:00+03');
INSERT INTO public.table_status VALUES (4155, 5, 'занят', '2026-03-26 19:57:00+03');
INSERT INTO public.table_status VALUES (4156, 5, 'свободен', '2026-03-26 21:52:00+03');
INSERT INTO public.table_status VALUES (4157, 5, 'забронирован', '2026-03-26 22:21:00+03');
INSERT INTO public.table_status VALUES (4158, 5, 'занят', '2026-03-26 22:45:00+03');
INSERT INTO public.table_status VALUES (4159, 6, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4160, 6, 'забронирован', '2026-03-26 10:35:00+03');
INSERT INTO public.table_status VALUES (4161, 6, 'занят', '2026-03-26 11:06:00+03');
INSERT INTO public.table_status VALUES (4162, 6, 'свободен', '2026-03-26 12:26:00+03');
INSERT INTO public.table_status VALUES (4163, 6, 'занят', '2026-03-26 13:44:00+03');
INSERT INTO public.table_status VALUES (4164, 6, 'свободен', '2026-03-26 14:59:00+03');
INSERT INTO public.table_status VALUES (4165, 6, 'занят', '2026-03-26 15:18:00+03');
INSERT INTO public.table_status VALUES (4166, 6, 'свободен', '2026-03-26 15:58:00+03');
INSERT INTO public.table_status VALUES (4167, 6, 'забронирован', '2026-03-26 16:27:00+03');
INSERT INTO public.table_status VALUES (4168, 6, 'занят', '2026-03-26 17:21:00+03');
INSERT INTO public.table_status VALUES (4169, 6, 'свободен', '2026-03-26 19:02:00+03');
INSERT INTO public.table_status VALUES (4170, 6, 'забронирован', '2026-03-26 21:33:00+03');
INSERT INTO public.table_status VALUES (4171, 6, 'занят', '2026-03-26 22:08:00+03');
INSERT INTO public.table_status VALUES (4172, 7, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4173, 7, 'забронирован', '2026-03-26 11:50:00+03');
INSERT INTO public.table_status VALUES (4174, 7, 'занят', '2026-03-26 12:27:00+03');
INSERT INTO public.table_status VALUES (4175, 7, 'свободен', '2026-03-26 14:17:00+03');
INSERT INTO public.table_status VALUES (4176, 7, 'занят', '2026-03-26 14:56:00+03');
INSERT INTO public.table_status VALUES (4177, 7, 'свободен', '2026-03-26 16:51:00+03');
INSERT INTO public.table_status VALUES (4178, 7, 'забронирован', '2026-03-26 18:11:00+03');
INSERT INTO public.table_status VALUES (4179, 7, 'занят', '2026-03-26 19:10:00+03');
INSERT INTO public.table_status VALUES (4180, 7, 'свободен', '2026-03-26 20:50:00+03');
INSERT INTO public.table_status VALUES (4181, 8, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4182, 8, 'занят', '2026-03-26 10:56:00+03');
INSERT INTO public.table_status VALUES (4183, 8, 'свободен', '2026-03-26 12:29:00+03');
INSERT INTO public.table_status VALUES (4184, 8, 'занят', '2026-03-26 13:04:00+03');
INSERT INTO public.table_status VALUES (4185, 8, 'свободен', '2026-03-26 14:35:00+03');
INSERT INTO public.table_status VALUES (4186, 8, 'занят', '2026-03-26 16:22:00+03');
INSERT INTO public.table_status VALUES (4187, 8, 'свободен', '2026-03-26 17:15:00+03');
INSERT INTO public.table_status VALUES (4188, 8, 'занят', '2026-03-26 19:03:00+03');
INSERT INTO public.table_status VALUES (4189, 8, 'свободен', '2026-03-26 19:46:00+03');
INSERT INTO public.table_status VALUES (4190, 8, 'занят', '2026-03-26 20:02:00+03');
INSERT INTO public.table_status VALUES (4191, 8, 'свободен', '2026-03-26 21:59:00+03');
INSERT INTO public.table_status VALUES (4192, 8, 'забронирован', '2026-03-26 22:21:00+03');
INSERT INTO public.table_status VALUES (4193, 9, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4194, 9, 'занят', '2026-03-26 13:19:00+03');
INSERT INTO public.table_status VALUES (4195, 9, 'свободен', '2026-03-26 14:15:00+03');
INSERT INTO public.table_status VALUES (4196, 9, 'забронирован', '2026-03-26 14:29:00+03');
INSERT INTO public.table_status VALUES (4197, 9, 'занят', '2026-03-26 15:06:00+03');
INSERT INTO public.table_status VALUES (4198, 9, 'свободен', '2026-03-26 16:57:00+03');
INSERT INTO public.table_status VALUES (4199, 9, 'забронирован', '2026-03-26 17:15:00+03');
INSERT INTO public.table_status VALUES (4200, 9, 'занят', '2026-03-26 17:47:00+03');
INSERT INTO public.table_status VALUES (4201, 9, 'свободен', '2026-03-26 19:16:00+03');
INSERT INTO public.table_status VALUES (4202, 9, 'забронирован', '2026-03-26 21:00:00+03');
INSERT INTO public.table_status VALUES (4203, 9, 'занят', '2026-03-26 21:49:00+03');
INSERT INTO public.table_status VALUES (4204, 9, 'свободен', '2026-03-26 22:40:00+03');
INSERT INTO public.table_status VALUES (4205, 10, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4206, 10, 'забронирован', '2026-03-26 10:10:00+03');
INSERT INTO public.table_status VALUES (4207, 10, 'занят', '2026-03-26 11:08:00+03');
INSERT INTO public.table_status VALUES (4208, 10, 'свободен', '2026-03-26 11:48:00+03');
INSERT INTO public.table_status VALUES (4209, 10, 'занят', '2026-03-26 11:58:00+03');
INSERT INTO public.table_status VALUES (4210, 10, 'свободен', '2026-03-26 13:42:00+03');
INSERT INTO public.table_status VALUES (4211, 10, 'занят', '2026-03-26 15:42:00+03');
INSERT INTO public.table_status VALUES (4212, 10, 'свободен', '2026-03-26 16:42:00+03');
INSERT INTO public.table_status VALUES (4213, 10, 'занят', '2026-03-26 18:10:00+03');
INSERT INTO public.table_status VALUES (4214, 10, 'свободен', '2026-03-26 19:09:00+03');
INSERT INTO public.table_status VALUES (4215, 10, 'занят', '2026-03-26 21:20:00+03');
INSERT INTO public.table_status VALUES (4216, 11, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4217, 11, 'занят', '2026-03-26 10:37:00+03');
INSERT INTO public.table_status VALUES (4218, 11, 'свободен', '2026-03-26 11:22:00+03');
INSERT INTO public.table_status VALUES (4219, 11, 'забронирован', '2026-03-26 11:47:00+03');
INSERT INTO public.table_status VALUES (4220, 11, 'занят', '2026-03-26 12:24:00+03');
INSERT INTO public.table_status VALUES (4221, 11, 'свободен', '2026-03-26 13:35:00+03');
INSERT INTO public.table_status VALUES (4222, 11, 'занят', '2026-03-26 16:58:00+03');
INSERT INTO public.table_status VALUES (4223, 11, 'свободен', '2026-03-26 18:15:00+03');
INSERT INTO public.table_status VALUES (4224, 11, 'забронирован', '2026-03-26 19:12:00+03');
INSERT INTO public.table_status VALUES (4225, 11, 'занят', '2026-03-26 20:01:00+03');
INSERT INTO public.table_status VALUES (4226, 11, 'свободен', '2026-03-26 21:58:00+03');
INSERT INTO public.table_status VALUES (4227, 11, 'забронирован', '2026-03-26 22:26:00+03');
INSERT INTO public.table_status VALUES (4228, 12, 'свободен', '2026-03-26 10:00:00+03');
INSERT INTO public.table_status VALUES (4229, 12, 'занят', '2026-03-26 12:14:00+03');
INSERT INTO public.table_status VALUES (4230, 12, 'свободен', '2026-03-26 13:45:00+03');
INSERT INTO public.table_status VALUES (4231, 12, 'забронирован', '2026-03-26 15:44:00+03');
INSERT INTO public.table_status VALUES (4232, 12, 'занят', '2026-03-26 16:33:00+03');
INSERT INTO public.table_status VALUES (4233, 12, 'свободен', '2026-03-26 17:37:00+03');
INSERT INTO public.table_status VALUES (4234, 12, 'занят', '2026-03-26 19:17:00+03');
INSERT INTO public.table_status VALUES (4235, 12, 'свободен', '2026-03-26 20:11:00+03');
INSERT INTO public.table_status VALUES (4236, 12, 'занят', '2026-03-26 20:48:00+03');
INSERT INTO public.table_status VALUES (4237, 12, 'свободен', '2026-03-26 22:28:00+03');


--
-- TOC entry 5166 (class 0 OID 16409)
-- Dependencies: 216
-- Data for Name: tables; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tables VALUES (1, 1, 'у входа', 2, 1, 'свободен');
INSERT INTO public.tables VALUES (2, 2, 'у стены', 2, 1, 'свободен');
INSERT INTO public.tables VALUES (3, 3, 'у окна', 4, 1, 'свободен');
INSERT INTO public.tables VALUES (4, 4, 'у стены', 4, 1, 'свободен');
INSERT INTO public.tables VALUES (5, 5, 'в центре', 6, 1, 'свободен');
INSERT INTO public.tables VALUES (6, 6, 'в центре', 4, 1, 'свободен');
INSERT INTO public.tables VALUES (7, 7, 'у стены', 2, 1, 'свободен');
INSERT INTO public.tables VALUES (8, 8, 'у входа', 2, 2, 'свободен');
INSERT INTO public.tables VALUES (9, 9, 'в центре', 4, 2, 'свободен');
INSERT INTO public.tables VALUES (10, 10, 'у входа', 4, 2, 'свободен');
INSERT INTO public.tables VALUES (11, 11, 'в центре', 6, 2, 'свободен');
INSERT INTO public.tables VALUES (12, 12, 'у стены', 2, 2, 'свободен');


--
-- TOC entry 5177 (class 0 OID 16463)
-- Dependencies: 227
-- Data for Name: tables_shift; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tables_shift VALUES (2, 1, 2, 271);
INSERT INTO public.tables_shift VALUES (23, 2, 2, 270);
INSERT INTO public.tables_shift VALUES (44, 3, 2, 271);
INSERT INTO public.tables_shift VALUES (65, 4, 2, 268);
INSERT INTO public.tables_shift VALUES (86, 5, 2, 267);
INSERT INTO public.tables_shift VALUES (107, 6, 2, 268);
INSERT INTO public.tables_shift VALUES (3, 1, 3, 275);
INSERT INTO public.tables_shift VALUES (24, 2, 3, 275);
INSERT INTO public.tables_shift VALUES (45, 3, 3, 273);
INSERT INTO public.tables_shift VALUES (66, 4, 3, 273);
INSERT INTO public.tables_shift VALUES (87, 5, 3, 273);
INSERT INTO public.tables_shift VALUES (108, 6, 3, 273);
INSERT INTO public.tables_shift VALUES (129, 7, 3, 274);
INSERT INTO public.tables_shift VALUES (4, 1, 4, 283);
INSERT INTO public.tables_shift VALUES (25, 2, 4, 280);
INSERT INTO public.tables_shift VALUES (46, 3, 4, 282);
INSERT INTO public.tables_shift VALUES (67, 4, 4, 281);
INSERT INTO public.tables_shift VALUES (88, 5, 4, 285);
INSERT INTO public.tables_shift VALUES (109, 6, 4, 283);
INSERT INTO public.tables_shift VALUES (5, 1, 5, 288);
INSERT INTO public.tables_shift VALUES (26, 2, 5, 287);
INSERT INTO public.tables_shift VALUES (47, 3, 5, 287);
INSERT INTO public.tables_shift VALUES (68, 4, 5, 286);
INSERT INTO public.tables_shift VALUES (89, 5, 5, 287);
INSERT INTO public.tables_shift VALUES (110, 6, 5, 291);
INSERT INTO public.tables_shift VALUES (131, 7, 5, 291);
INSERT INTO public.tables_shift VALUES (6, 1, 6, 295);
INSERT INTO public.tables_shift VALUES (27, 2, 6, 291);
INSERT INTO public.tables_shift VALUES (48, 3, 6, 292);
INSERT INTO public.tables_shift VALUES (69, 4, 6, 294);
INSERT INTO public.tables_shift VALUES (90, 5, 6, 292);
INSERT INTO public.tables_shift VALUES (111, 6, 6, 292);
INSERT INTO public.tables_shift VALUES (7, 1, 7, 300);
INSERT INTO public.tables_shift VALUES (28, 2, 7, 298);
INSERT INTO public.tables_shift VALUES (49, 3, 7, 302);
INSERT INTO public.tables_shift VALUES (70, 4, 7, 303);
INSERT INTO public.tables_shift VALUES (91, 5, 7, 297);
INSERT INTO public.tables_shift VALUES (112, 6, 7, 302);
INSERT INTO public.tables_shift VALUES (133, 7, 7, 298);
INSERT INTO public.tables_shift VALUES (8, 1, 8, 308);
INSERT INTO public.tables_shift VALUES (29, 2, 8, 308);
INSERT INTO public.tables_shift VALUES (50, 3, 8, 304);
INSERT INTO public.tables_shift VALUES (71, 4, 8, 306);
INSERT INTO public.tables_shift VALUES (92, 5, 8, 307);
INSERT INTO public.tables_shift VALUES (113, 6, 8, 304);
INSERT INTO public.tables_shift VALUES (9, 1, 9, 311);
INSERT INTO public.tables_shift VALUES (30, 2, 9, 314);
INSERT INTO public.tables_shift VALUES (51, 3, 9, 313);
INSERT INTO public.tables_shift VALUES (72, 4, 9, 314);
INSERT INTO public.tables_shift VALUES (93, 5, 9, 312);
INSERT INTO public.tables_shift VALUES (114, 6, 9, 312);
INSERT INTO public.tables_shift VALUES (135, 7, 9, 311);
INSERT INTO public.tables_shift VALUES (10, 1, 10, 318);
INSERT INTO public.tables_shift VALUES (31, 2, 10, 321);
INSERT INTO public.tables_shift VALUES (52, 3, 10, 319);
INSERT INTO public.tables_shift VALUES (73, 4, 10, 317);
INSERT INTO public.tables_shift VALUES (94, 5, 10, 321);
INSERT INTO public.tables_shift VALUES (115, 6, 10, 316);
INSERT INTO public.tables_shift VALUES (11, 1, 11, 325);
INSERT INTO public.tables_shift VALUES (32, 2, 11, 323);
INSERT INTO public.tables_shift VALUES (53, 3, 11, 324);
INSERT INTO public.tables_shift VALUES (74, 4, 11, 323);
INSERT INTO public.tables_shift VALUES (95, 5, 11, 324);
INSERT INTO public.tables_shift VALUES (116, 6, 11, 325);
INSERT INTO public.tables_shift VALUES (12, 1, 12, 328);
INSERT INTO public.tables_shift VALUES (33, 2, 12, 331);
INSERT INTO public.tables_shift VALUES (54, 3, 12, 331);
INSERT INTO public.tables_shift VALUES (75, 4, 12, 328);
INSERT INTO public.tables_shift VALUES (96, 5, 12, 331);
INSERT INTO public.tables_shift VALUES (117, 6, 12, 328);
INSERT INTO public.tables_shift VALUES (13, 1, 13, 334);
INSERT INTO public.tables_shift VALUES (34, 2, 13, 339);
INSERT INTO public.tables_shift VALUES (55, 3, 13, 334);
INSERT INTO public.tables_shift VALUES (76, 4, 13, 337);
INSERT INTO public.tables_shift VALUES (97, 5, 13, 338);
INSERT INTO public.tables_shift VALUES (118, 6, 13, 336);
INSERT INTO public.tables_shift VALUES (14, 1, 14, 343);
INSERT INTO public.tables_shift VALUES (35, 2, 14, 345);
INSERT INTO public.tables_shift VALUES (56, 3, 14, 342);
INSERT INTO public.tables_shift VALUES (77, 4, 14, 344);
INSERT INTO public.tables_shift VALUES (98, 5, 14, 341);
INSERT INTO public.tables_shift VALUES (119, 6, 14, 340);
INSERT INTO public.tables_shift VALUES (15, 1, 15, 350);
INSERT INTO public.tables_shift VALUES (36, 2, 15, 348);
INSERT INTO public.tables_shift VALUES (57, 3, 15, 350);
INSERT INTO public.tables_shift VALUES (78, 4, 15, 351);
INSERT INTO public.tables_shift VALUES (99, 5, 15, 346);
INSERT INTO public.tables_shift VALUES (16, 1, 16, 353);
INSERT INTO public.tables_shift VALUES (37, 2, 16, 354);
INSERT INTO public.tables_shift VALUES (58, 3, 16, 352);
INSERT INTO public.tables_shift VALUES (79, 4, 16, 355);
INSERT INTO public.tables_shift VALUES (100, 5, 16, 351);
INSERT INTO public.tables_shift VALUES (121, 6, 16, 352);
INSERT INTO public.tables_shift VALUES (17, 1, 17, 362);
INSERT INTO public.tables_shift VALUES (38, 2, 17, 362);
INSERT INTO public.tables_shift VALUES (59, 3, 17, 361);
INSERT INTO public.tables_shift VALUES (80, 4, 17, 358);
INSERT INTO public.tables_shift VALUES (101, 5, 17, 358);
INSERT INTO public.tables_shift VALUES (122, 6, 17, 362);
INSERT INTO public.tables_shift VALUES (18, 1, 18, 369);
INSERT INTO public.tables_shift VALUES (39, 2, 18, 366);
INSERT INTO public.tables_shift VALUES (60, 3, 18, 367);
INSERT INTO public.tables_shift VALUES (81, 4, 18, 367);
INSERT INTO public.tables_shift VALUES (102, 5, 18, 364);
INSERT INTO public.tables_shift VALUES (19, 1, 19, 373);
INSERT INTO public.tables_shift VALUES (40, 2, 19, 374);
INSERT INTO public.tables_shift VALUES (61, 3, 19, 370);
INSERT INTO public.tables_shift VALUES (82, 4, 19, 371);
INSERT INTO public.tables_shift VALUES (103, 5, 19, 374);
INSERT INTO public.tables_shift VALUES (124, 6, 19, 372);
INSERT INTO public.tables_shift VALUES (20, 1, 20, 376);
INSERT INTO public.tables_shift VALUES (41, 2, 20, 376);
INSERT INTO public.tables_shift VALUES (62, 3, 20, 379);
INSERT INTO public.tables_shift VALUES (83, 4, 20, 380);
INSERT INTO public.tables_shift VALUES (104, 5, 20, 380);
INSERT INTO public.tables_shift VALUES (21, 1, 21, 382);
INSERT INTO public.tables_shift VALUES (42, 2, 21, 383);
INSERT INTO public.tables_shift VALUES (63, 3, 21, 383);
INSERT INTO public.tables_shift VALUES (84, 4, 21, 382);
INSERT INTO public.tables_shift VALUES (105, 5, 21, 385);
INSERT INTO public.tables_shift VALUES (126, 6, 21, 382);
INSERT INTO public.tables_shift VALUES (1, 1, 1, 263);
INSERT INTO public.tables_shift VALUES (22, 2, 1, 261);
INSERT INTO public.tables_shift VALUES (43, 3, 1, 264);
INSERT INTO public.tables_shift VALUES (64, 4, 1, 263);
INSERT INTO public.tables_shift VALUES (85, 5, 1, 263);
INSERT INTO public.tables_shift VALUES (106, 6, 1, 267);
INSERT INTO public.tables_shift VALUES (127, 7, 1, 266);
INSERT INTO public.tables_shift VALUES (148, 8, 1, 264);
INSERT INTO public.tables_shift VALUES (169, 9, 1, 264);
INSERT INTO public.tables_shift VALUES (190, 10, 1, 266);
INSERT INTO public.tables_shift VALUES (211, 11, 1, 262);
INSERT INTO public.tables_shift VALUES (232, 12, 1, 264);
INSERT INTO public.tables_shift VALUES (128, 7, 2, 268);
INSERT INTO public.tables_shift VALUES (149, 8, 2, 273);
INSERT INTO public.tables_shift VALUES (170, 9, 2, 271);
INSERT INTO public.tables_shift VALUES (191, 10, 2, 269);
INSERT INTO public.tables_shift VALUES (212, 11, 2, 270);
INSERT INTO public.tables_shift VALUES (233, 12, 2, 271);
INSERT INTO public.tables_shift VALUES (150, 8, 3, 277);
INSERT INTO public.tables_shift VALUES (171, 9, 3, 278);
INSERT INTO public.tables_shift VALUES (192, 10, 3, 275);
INSERT INTO public.tables_shift VALUES (213, 11, 3, 275);
INSERT INTO public.tables_shift VALUES (234, 12, 3, 276);
INSERT INTO public.tables_shift VALUES (130, 7, 4, 281);
INSERT INTO public.tables_shift VALUES (151, 8, 4, 283);
INSERT INTO public.tables_shift VALUES (172, 9, 4, 282);
INSERT INTO public.tables_shift VALUES (193, 10, 4, 283);
INSERT INTO public.tables_shift VALUES (214, 11, 4, 283);
INSERT INTO public.tables_shift VALUES (235, 12, 4, 281);
INSERT INTO public.tables_shift VALUES (152, 8, 5, 288);
INSERT INTO public.tables_shift VALUES (173, 9, 5, 290);
INSERT INTO public.tables_shift VALUES (194, 10, 5, 290);
INSERT INTO public.tables_shift VALUES (215, 11, 5, 289);
INSERT INTO public.tables_shift VALUES (236, 12, 5, 287);
INSERT INTO public.tables_shift VALUES (132, 7, 6, 294);
INSERT INTO public.tables_shift VALUES (153, 8, 6, 292);
INSERT INTO public.tables_shift VALUES (174, 9, 6, 295);
INSERT INTO public.tables_shift VALUES (195, 10, 6, 295);
INSERT INTO public.tables_shift VALUES (216, 11, 6, 293);
INSERT INTO public.tables_shift VALUES (237, 12, 6, 291);
INSERT INTO public.tables_shift VALUES (154, 8, 7, 297);
INSERT INTO public.tables_shift VALUES (175, 9, 7, 299);
INSERT INTO public.tables_shift VALUES (196, 10, 7, 301);
INSERT INTO public.tables_shift VALUES (217, 11, 7, 300);
INSERT INTO public.tables_shift VALUES (238, 12, 7, 301);
INSERT INTO public.tables_shift VALUES (134, 7, 8, 309);
INSERT INTO public.tables_shift VALUES (155, 8, 8, 305);
INSERT INTO public.tables_shift VALUES (176, 9, 8, 304);
INSERT INTO public.tables_shift VALUES (197, 10, 8, 306);
INSERT INTO public.tables_shift VALUES (218, 11, 8, 306);
INSERT INTO public.tables_shift VALUES (239, 12, 8, 307);
INSERT INTO public.tables_shift VALUES (156, 8, 9, 309);
INSERT INTO public.tables_shift VALUES (177, 9, 9, 314);
INSERT INTO public.tables_shift VALUES (198, 10, 9, 314);
INSERT INTO public.tables_shift VALUES (219, 11, 9, 310);
INSERT INTO public.tables_shift VALUES (240, 12, 9, 309);
INSERT INTO public.tables_shift VALUES (136, 7, 10, 317);
INSERT INTO public.tables_shift VALUES (157, 8, 10, 318);
INSERT INTO public.tables_shift VALUES (178, 9, 10, 318);
INSERT INTO public.tables_shift VALUES (199, 10, 10, 318);
INSERT INTO public.tables_shift VALUES (220, 11, 10, 320);
INSERT INTO public.tables_shift VALUES (241, 12, 10, 318);
INSERT INTO public.tables_shift VALUES (137, 7, 11, 326);
INSERT INTO public.tables_shift VALUES (158, 8, 11, 322);
INSERT INTO public.tables_shift VALUES (179, 9, 11, 322);
INSERT INTO public.tables_shift VALUES (200, 10, 11, 323);
INSERT INTO public.tables_shift VALUES (138, 7, 12, 329);
INSERT INTO public.tables_shift VALUES (159, 8, 12, 331);
INSERT INTO public.tables_shift VALUES (180, 9, 12, 329);
INSERT INTO public.tables_shift VALUES (201, 10, 12, 330);
INSERT INTO public.tables_shift VALUES (222, 11, 12, 332);
INSERT INTO public.tables_shift VALUES (243, 12, 12, 330);
INSERT INTO public.tables_shift VALUES (139, 7, 13, 336);
INSERT INTO public.tables_shift VALUES (160, 8, 13, 337);
INSERT INTO public.tables_shift VALUES (181, 9, 13, 336);
INSERT INTO public.tables_shift VALUES (202, 10, 13, 336);
INSERT INTO public.tables_shift VALUES (223, 11, 13, 337);
INSERT INTO public.tables_shift VALUES (244, 12, 13, 339);
INSERT INTO public.tables_shift VALUES (140, 7, 14, 342);
INSERT INTO public.tables_shift VALUES (161, 8, 14, 342);
INSERT INTO public.tables_shift VALUES (182, 9, 14, 345);
INSERT INTO public.tables_shift VALUES (203, 10, 14, 342);
INSERT INTO public.tables_shift VALUES (224, 11, 14, 345);
INSERT INTO public.tables_shift VALUES (141, 7, 15, 350);
INSERT INTO public.tables_shift VALUES (162, 8, 15, 346);
INSERT INTO public.tables_shift VALUES (183, 9, 15, 345);
INSERT INTO public.tables_shift VALUES (204, 10, 15, 349);
INSERT INTO public.tables_shift VALUES (225, 11, 15, 346);
INSERT INTO public.tables_shift VALUES (246, 12, 15, 350);
INSERT INTO public.tables_shift VALUES (142, 7, 16, 353);
INSERT INTO public.tables_shift VALUES (163, 8, 16, 356);
INSERT INTO public.tables_shift VALUES (184, 9, 16, 352);
INSERT INTO public.tables_shift VALUES (205, 10, 16, 351);
INSERT INTO public.tables_shift VALUES (226, 11, 16, 356);
INSERT INTO public.tables_shift VALUES (143, 7, 17, 360);
INSERT INTO public.tables_shift VALUES (164, 8, 17, 358);
INSERT INTO public.tables_shift VALUES (185, 9, 17, 362);
INSERT INTO public.tables_shift VALUES (206, 10, 17, 360);
INSERT INTO public.tables_shift VALUES (227, 11, 17, 358);
INSERT INTO public.tables_shift VALUES (248, 12, 17, 357);
INSERT INTO public.tables_shift VALUES (144, 7, 18, 364);
INSERT INTO public.tables_shift VALUES (165, 8, 18, 367);
INSERT INTO public.tables_shift VALUES (186, 9, 18, 365);
INSERT INTO public.tables_shift VALUES (207, 10, 18, 363);
INSERT INTO public.tables_shift VALUES (228, 11, 18, 363);
INSERT INTO public.tables_shift VALUES (249, 12, 18, 368);
INSERT INTO public.tables_shift VALUES (145, 7, 19, 372);
INSERT INTO public.tables_shift VALUES (166, 8, 19, 373);
INSERT INTO public.tables_shift VALUES (187, 9, 19, 370);
INSERT INTO public.tables_shift VALUES (208, 10, 19, 375);
INSERT INTO public.tables_shift VALUES (229, 11, 19, 371);
INSERT INTO public.tables_shift VALUES (146, 7, 20, 377);
INSERT INTO public.tables_shift VALUES (167, 8, 20, 380);
INSERT INTO public.tables_shift VALUES (188, 9, 20, 376);
INSERT INTO public.tables_shift VALUES (209, 10, 20, 377);
INSERT INTO public.tables_shift VALUES (230, 11, 20, 377);
INSERT INTO public.tables_shift VALUES (251, 12, 20, 379);
INSERT INTO public.tables_shift VALUES (147, 7, 21, 383);
INSERT INTO public.tables_shift VALUES (168, 8, 21, 382);
INSERT INTO public.tables_shift VALUES (189, 9, 21, 382);
INSERT INTO public.tables_shift VALUES (210, 10, 21, 384);
INSERT INTO public.tables_shift VALUES (231, 11, 21, 382);
INSERT INTO public.tables_shift VALUES (221, 11, 11, 323);
INSERT INTO public.tables_shift VALUES (242, 12, 11, 326);
INSERT INTO public.tables_shift VALUES (245, 12, 14, 341);
INSERT INTO public.tables_shift VALUES (120, 6, 15, 350);
INSERT INTO public.tables_shift VALUES (247, 12, 16, 355);
INSERT INTO public.tables_shift VALUES (123, 6, 18, 365);
INSERT INTO public.tables_shift VALUES (250, 12, 19, 371);
INSERT INTO public.tables_shift VALUES (125, 6, 20, 379);
INSERT INTO public.tables_shift VALUES (252, 12, 21, 385);


--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 251
-- Name: dish_category_id_category_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_category_id_category_seq', 7, true);


--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 276
-- Name: dish_employee_id_dish_employee_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_employee_id_dish_employee_seq', 36, true);


--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 277
-- Name: dish_employee_id_dish_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_employee_id_dish_seq', 1, false);


--
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 278
-- Name: dish_employee_id_employee_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_employee_id_employee_seq', 1, false);


--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 249
-- Name: dish_id_category_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_id_category_seq', 1, false);


--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 248
-- Name: dish_id_dish_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_id_dish_seq', 12, true);


--
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 256
-- Name: dish_order_id_dish_order_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_order_id_dish_order_seq', 152, true);


--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 257
-- Name: dish_order_id_dish_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_order_id_dish_seq', 1, false);


--
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 258
-- Name: dish_order_id_employee_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_order_id_employee_seq', 1, false);


--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 259
-- Name: dish_order_id_order_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_order_id_order_seq', 35, true);


--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 253
-- Name: dish_price_id_dish_price_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_price_id_dish_price_seq', 13, true);


--
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 254
-- Name: dish_price_id_dish_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dish_price_id_dish_seq', 1, false);


--
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 228
-- Name: employee_id_employee_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employee_id_employee_seq', 100, true);


--
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 232
-- Name: employee_shift_id_employee_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employee_shift_id_employee_seq', 1, false);


--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 230
-- Name: employee_shift_id_employee_shift_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employee_shift_id_employee_shift_seq', 386, true);


--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 231
-- Name: employee_shift_id_shift_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employee_shift_id_shift_seq', 1, false);


--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 246
-- Name: employment_contract_id_employee_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employment_contract_id_employee_seq', 1, false);


--
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 244
-- Name: employment_contract_id_employment_contract_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employment_contract_id_employment_contract_seq', 16, true);


--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 245
-- Name: employment_contract_id_job_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employment_contract_id_job_seq', 1, false);


--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 269
-- Name: id_ingredient_dish_id_dish_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.id_ingredient_dish_id_dish_seq', 1, false);


--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 268
-- Name: id_ingredient_dish_id_ingredient_dish_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.id_ingredient_dish_id_ingredient_dish_seq', 26, true);


--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 270
-- Name: id_ingredient_dish_id_product_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.id_ingredient_dish_id_product_seq', 1, false);


--
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 242
-- Name: job_id_job_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.job_id_job_seq', 5, true);


--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 235
-- Name: order_id_employee_shift_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_id_employee_shift_seq', 1, false);


--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 234
-- Name: order_id_order_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_id_order_seq', 13, true);


--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 236
-- Name: order_id_reserv_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_id_reserv_seq', 1, false);


--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 237
-- Name: order_id_table_shift_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_id_table_shift_seq', 1, false);


--
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 240
-- Name: order_status_id_order_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_status_id_order_seq', 1, false);


--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 239
-- Name: order_status_id_order_status_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_status_id_order_status_seq', 15, true);


--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 263
-- Name: product_id_product_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_id_product_seq', 22, true);


--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 265
-- Name: product_id_product_type_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_id_product_type_seq', 1, false);


--
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 261
-- Name: product_type_id_product_type_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_type_id_product_type_seq', 19, true);


--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 274
-- Name: replacement_id_ingredient_dish_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.replacement_id_ingredient_dish_seq', 1, false);


--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 273
-- Name: replacement_id_product_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.replacement_id_product_seq', 1, false);


--
-- TOC entry 5323 (class 0 OID 0)
-- Dependencies: 272
-- Name: replacement_id_replacement_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.replacement_id_replacement_seq', 6, true);


--
-- TOC entry 5324 (class 0 OID 0)
-- Dependencies: 220
-- Name: reservation_id_reserv_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reservation_id_reserv_seq', 302, true);


--
-- TOC entry 5325 (class 0 OID 0)
-- Dependencies: 222
-- Name: shift_id_shift_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.shift_id_shift_seq', 21, true);


--
-- TOC entry 5326 (class 0 OID 0)
-- Dependencies: 266
-- Name: supply_id_supply_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.supply_id_supply_seq', 54, true);


--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 281
-- Name: supply_product_id_product_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.supply_product_id_product_seq', 1, false);


--
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 280
-- Name: supply_product_id_product_supply_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.supply_product_id_product_supply_seq', 28, true);


--
-- TOC entry 5329 (class 0 OID 0)
-- Dependencies: 282
-- Name: supply_product_id_supply_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.supply_product_id_supply_seq', 1, false);


--
-- TOC entry 5330 (class 0 OID 0)
-- Dependencies: 215
-- Name: table_id_table_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.table_id_table_seq', 12, true);


--
-- TOC entry 5331 (class 0 OID 0)
-- Dependencies: 226
-- Name: table_shift_id_shift_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.table_shift_id_shift_seq', 1, false);


--
-- TOC entry 5332 (class 0 OID 0)
-- Dependencies: 225
-- Name: table_shift_id_table_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.table_shift_id_table_seq', 1, false);


--
-- TOC entry 5333 (class 0 OID 0)
-- Dependencies: 224
-- Name: table_shift_id_table_shift_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.table_shift_id_table_shift_seq', 252, true);


--
-- TOC entry 5334 (class 0 OID 0)
-- Dependencies: 218
-- Name: table_status_id_table_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.table_status_id_table_seq', 1, false);


--
-- TOC entry 5335 (class 0 OID 0)
-- Dependencies: 217
-- Name: table_status_id_table_status_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.table_status_id_table_status_seq', 4237, true);


--
-- TOC entry 5336 (class 0 OID 0)
-- Dependencies: 284
-- Name: tables_shift_id_employee_shift_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tables_shift_id_employee_shift_seq', 252, true);


--
-- TOC entry 4941 (class 2606 OID 65586)
-- Name: supply_product calorie_content_rule; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.supply_product
    ADD CONSTRAINT calorie_content_rule CHECK ((calorie_content > (0)::numeric)) NOT VALID;


--
-- TOC entry 4974 (class 2606 OID 16651)
-- Name: dish_category dish_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_category
    ADD CONSTRAINT dish_category_pkey PRIMARY KEY (id_category);


--
-- TOC entry 4991 (class 2606 OID 24772)
-- Name: dish_employee dish_employee_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_employee
    ADD CONSTRAINT dish_employee_pkey PRIMARY KEY (id_dish_employee);


--
-- TOC entry 4978 (class 2606 OID 24610)
-- Name: dish_order dish_order_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_order
    ADD CONSTRAINT dish_order_pkey PRIMARY KEY (id_dish_order);


--
-- TOC entry 4972 (class 2606 OID 16643)
-- Name: dish dish_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish
    ADD CONSTRAINT dish_pkey PRIMARY KEY (id_dish);


--
-- TOC entry 4976 (class 2606 OID 24592)
-- Name: dish_price dish_price_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_price
    ADD CONSTRAINT dish_price_pkey PRIMARY KEY (id_dish_price);


--
-- TOC entry 4958 (class 2606 OID 16493)
-- Name: employee employee_num_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_num_unique UNIQUE (employee_number);


--
-- TOC entry 4960 (class 2606 OID 16491)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id_employee);


--
-- TOC entry 4962 (class 2606 OID 16505)
-- Name: employee_shift employee_shift_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_shift
    ADD CONSTRAINT employee_shift_pkey PRIMARY KEY (id_employee_shift);


--
-- TOC entry 4970 (class 2606 OID 16619)
-- Name: employment_contract employment_contract_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employment_contract
    ADD CONSTRAINT employment_contract_pkey PRIMARY KEY (id_employment_contract);


--
-- TOC entry 4909 (class 2606 OID 73731)
-- Name: employee entry_date_greater_than_issue_date; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.employee
    ADD CONSTRAINT entry_date_greater_than_issue_date CHECK ((entry_date > issue_date)) NOT VALID;


--
-- TOC entry 4942 (class 2606 OID 65589)
-- Name: supply_product exp_time_greater_than_prod_time; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.supply_product
    ADD CONSTRAINT exp_time_greater_than_prod_time CHECK ((production_time > expiration_time)) NOT VALID;


--
-- TOC entry 4986 (class 2606 OID 24717)
-- Name: ingredient_dish id_ingredient_dish_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredient_dish
    ADD CONSTRAINT id_ingredient_dish_pkey PRIMARY KEY (id_ingredient_dish);


--
-- TOC entry 4910 (class 2606 OID 73732)
-- Name: employee issued_by_cyrillic; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.employee
    ADD CONSTRAINT issued_by_cyrillic CHECK (((issued_by)::text ~ '^[А-Яа-яЁё -]+$'::text)) NOT VALID;


--
-- TOC entry 4968 (class 2606 OID 16603)
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (id_job);


--
-- TOC entry 4938 (class 2606 OID 49152)
-- Name: ingredient_dish measurement_units_list; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.ingredient_dish
    ADD CONSTRAINT measurement_units_list CHECK (((measurement_units)::text = ANY (ARRAY[('г'::character varying)::text, ('мл'::character varying)::text]))) NOT VALID;


--
-- TOC entry 4964 (class 2606 OID 16529)
-- Name: orders order_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT order_pkey PRIMARY KEY (id_order);


--
-- TOC entry 4966 (class 2606 OID 16562)
-- Name: order_status order_status_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_status
    ADD CONSTRAINT order_status_pkey PRIMARY KEY (id_order_status);


--
-- TOC entry 4912 (class 2606 OID 73733)
-- Name: employee passport_number_length_numbers; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.employee
    ADD CONSTRAINT passport_number_length_numbers CHECK ((passport_num ~ '^[0-9]{6}$'::text)) NOT VALID;


--
-- TOC entry 4907 (class 2606 OID 65560)
-- Name: reservation person_q; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.reservation
    ADD CONSTRAINT person_q CHECK (((person_q > 0) AND (person_q < 500))) NOT VALID;


--
-- TOC entry 4982 (class 2606 OID 24680)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id_product);


--
-- TOC entry 4980 (class 2606 OID 24633)
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id_product_type);


--
-- TOC entry 4943 (class 2606 OID 65585)
-- Name: supply_product quantity_rule; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.supply_product
    ADD CONSTRAINT quantity_rule CHECK ((quantity > (0)::numeric)) NOT VALID;


--
-- TOC entry 4989 (class 2606 OID 24750)
-- Name: replacement replacement_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.replacement
    ADD CONSTRAINT replacement_pkey PRIMARY KEY (id_replacement);


--
-- TOC entry 4952 (class 2606 OID 16446)
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (id_reserv);


--
-- TOC entry 4914 (class 2606 OID 73734)
-- Name: employee series_length_numbers; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.employee
    ADD CONSTRAINT series_length_numbers CHECK ((passport_series ~ '^[0-9]{4}$'::text)) NOT VALID;


--
-- TOC entry 4954 (class 2606 OID 16459)
-- Name: shift shift_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pkey PRIMARY KEY (id_shift);


--
-- TOC entry 4903 (class 2606 OID 90112)
-- Name: tables status_list; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.tables
    ADD CONSTRAINT status_list CHECK (((status)::text = ANY (ARRAY[('свободен'::character varying)::text, ('занят'::character varying)::text, ('забронирован'::character varying)::text]))) NOT VALID;


--
-- TOC entry 4918 (class 2606 OID 16568)
-- Name: order_status status_name_list; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.order_status
    ADD CONSTRAINT status_name_list CHECK (((status_name)::text = ANY ((ARRAY['принят'::character varying, 'готовится'::character varying, 'выполнен'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4944 (class 2606 OID 65587)
-- Name: supply_product status_rule; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.supply_product
    ADD CONSTRAINT status_rule CHECK (((status)::text = ANY ((ARRAY['принято'::character varying, 'не принято'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4934 (class 2606 OID 40961)
-- Name: product storage_conditions_text; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.product
    ADD CONSTRAINT storage_conditions_text CHECK ((storage_conditions ~ '^[A-Za-zА-Яа-яЁё0-9 +\-°,]+$'::text)) NOT VALID;


--
-- TOC entry 4984 (class 2606 OID 24697)
-- Name: supply supply_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply
    ADD CONSTRAINT supply_pkey PRIMARY KEY (id_supply);


--
-- TOC entry 4993 (class 2606 OID 65574)
-- Name: supply_product supply_product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_product
    ADD CONSTRAINT supply_product_pkey PRIMARY KEY (id_product_supply);


--
-- TOC entry 4936 (class 2606 OID 65588)
-- Name: supply supply_status_rule; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.supply
    ADD CONSTRAINT supply_status_rule CHECK (((supply_status)::text = ANY ((ARRAY['принято'::character varying, 'не принято'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4946 (class 2606 OID 16420)
-- Name: tables table_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables
    ADD CONSTRAINT table_pkey PRIMARY KEY (id_table);


--
-- TOC entry 4956 (class 2606 OID 16470)
-- Name: tables_shift table_shift_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_shift
    ADD CONSTRAINT table_shift_pkey PRIMARY KEY (id_table_shift);


--
-- TOC entry 4950 (class 2606 OID 16430)
-- Name: table_status table_status_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_status
    ADD CONSTRAINT table_status_pkey PRIMARY KEY (id_table_status);


--
-- TOC entry 4922 (class 2606 OID 65561)
-- Name: employment_contract type_rule; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.employment_contract
    ADD CONSTRAINT type_rule CHECK (((contract_type)::text = ANY ((ARRAY['срочный'::character varying, 'бессрочный'::character varying, 'ГПХ'::character varying, 'внутреннее совм'::character varying, 'внешн совм'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4947 (class 1259 OID 90119)
-- Name: idx_table_status_table_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_table_status_table_time ON public.table_status USING btree (id_table, change_time DESC);


--
-- TOC entry 4987 (class 1259 OID 90117)
-- Name: ind_ingredient_dish_id_dish; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ind_ingredient_dish_id_dish ON public.ingredient_dish USING btree (id_dish);


--
-- TOC entry 4948 (class 1259 OID 90118)
-- Name: ind_table_status_table_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ind_table_status_table_time ON public.table_status USING btree (id_table, change_time DESC);


--
-- TOC entry 5006 (class 2606 OID 16652)
-- Name: dish fk_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish
    ADD CONSTRAINT fk_category FOREIGN KEY (id_category) REFERENCES public.dish_category(id_category) NOT VALID;


--
-- TOC entry 5016 (class 2606 OID 24773)
-- Name: dish_employee fk_dish; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_employee
    ADD CONSTRAINT fk_dish FOREIGN KEY (id_dish) REFERENCES public.dish(id_dish);


--
-- TOC entry 5008 (class 2606 OID 24611)
-- Name: dish_order fk_dish; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_order
    ADD CONSTRAINT fk_dish FOREIGN KEY (id_dish) REFERENCES public.dish(id_dish);


--
-- TOC entry 5007 (class 2606 OID 65541)
-- Name: dish_price fk_dish; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_price
    ADD CONSTRAINT fk_dish FOREIGN KEY (id_dish) REFERENCES public.dish(id_dish) NOT VALID;


--
-- TOC entry 5012 (class 2606 OID 24718)
-- Name: ingredient_dish fk_dish; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredient_dish
    ADD CONSTRAINT fk_dish FOREIGN KEY (id_dish) REFERENCES public.dish(id_dish);


--
-- TOC entry 4995 (class 2606 OID 81926)
-- Name: tables_shift fk_emp_shift; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_shift
    ADD CONSTRAINT fk_emp_shift FOREIGN KEY (id_employee_shift) REFERENCES public.employee_shift(id_employee_shift) NOT VALID;


--
-- TOC entry 5017 (class 2606 OID 24778)
-- Name: dish_employee fk_employee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_employee
    ADD CONSTRAINT fk_employee FOREIGN KEY (id_employee) REFERENCES public.employee(id_employee);


--
-- TOC entry 5009 (class 2606 OID 24616)
-- Name: dish_order fk_employee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_order
    ADD CONSTRAINT fk_employee FOREIGN KEY (id_employee) REFERENCES public.employee(id_employee);


--
-- TOC entry 4998 (class 2606 OID 16511)
-- Name: employee_shift fk_employee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_shift
    ADD CONSTRAINT fk_employee FOREIGN KEY (id_employee) REFERENCES public.employee(id_employee);


--
-- TOC entry 5004 (class 2606 OID 16625)
-- Name: employment_contract fk_employee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employment_contract
    ADD CONSTRAINT fk_employee FOREIGN KEY (id_employee) REFERENCES public.employee(id_employee);


--
-- TOC entry 5000 (class 2606 OID 16540)
-- Name: orders fk_employee_shift; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_employee_shift FOREIGN KEY (id_employee_shift) REFERENCES public.employee_shift(id_employee_shift);


--
-- TOC entry 5014 (class 2606 OID 24756)
-- Name: replacement fk_ingredient_dish; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.replacement
    ADD CONSTRAINT fk_ingredient_dish FOREIGN KEY (id_ingredient_dish) REFERENCES public.ingredient_dish(id_ingredient_dish);


--
-- TOC entry 5005 (class 2606 OID 16620)
-- Name: employment_contract fk_job; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employment_contract
    ADD CONSTRAINT fk_job FOREIGN KEY (id_job) REFERENCES public.job(id_job);


--
-- TOC entry 5010 (class 2606 OID 24621)
-- Name: dish_order fk_order; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dish_order
    ADD CONSTRAINT fk_order FOREIGN KEY (id_order) REFERENCES public.orders(id_order);


--
-- TOC entry 5003 (class 2606 OID 16563)
-- Name: order_status fk_order; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_status
    ADD CONSTRAINT fk_order FOREIGN KEY (id_order) REFERENCES public.orders(id_order);


--
-- TOC entry 5013 (class 2606 OID 24723)
-- Name: ingredient_dish fk_product; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredient_dish
    ADD CONSTRAINT fk_product FOREIGN KEY (id_product) REFERENCES public.product(id_product);


--
-- TOC entry 5015 (class 2606 OID 24751)
-- Name: replacement fk_product; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.replacement
    ADD CONSTRAINT fk_product FOREIGN KEY (id_product) REFERENCES public.product(id_product);


--
-- TOC entry 5018 (class 2606 OID 65580)
-- Name: supply_product fk_product; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_product
    ADD CONSTRAINT fk_product FOREIGN KEY (id_product) REFERENCES public.product(id_product) NOT VALID;


--
-- TOC entry 5011 (class 2606 OID 65536)
-- Name: product fk_product_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_product_type FOREIGN KEY (id_product_type) REFERENCES public.product_type(id_product_type) NOT VALID;


--
-- TOC entry 5001 (class 2606 OID 16530)
-- Name: orders fk_reserv; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_reserv FOREIGN KEY (id_reserv) REFERENCES public.reservation(id_reserv);


--
-- TOC entry 4999 (class 2606 OID 16506)
-- Name: employee_shift fk_shift; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_shift
    ADD CONSTRAINT fk_shift FOREIGN KEY (id_shift) REFERENCES public.shift(id_shift);


--
-- TOC entry 4996 (class 2606 OID 16476)
-- Name: tables_shift fk_shift; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_shift
    ADD CONSTRAINT fk_shift FOREIGN KEY (id_shift) REFERENCES public.shift(id_shift);


--
-- TOC entry 5019 (class 2606 OID 65575)
-- Name: supply_product fk_supply; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supply_product
    ADD CONSTRAINT fk_supply FOREIGN KEY (id_supply) REFERENCES public.supply(id_supply) NOT VALID;


--
-- TOC entry 4997 (class 2606 OID 16471)
-- Name: tables_shift fk_table; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_shift
    ADD CONSTRAINT fk_table FOREIGN KEY (id_table) REFERENCES public.tables(id_table);


--
-- TOC entry 5002 (class 2606 OID 16535)
-- Name: orders fk_table_shift; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_table_shift FOREIGN KEY (id_table_shift) REFERENCES public.tables_shift(id_table_shift);


--
-- TOC entry 4994 (class 2606 OID 16431)
-- Name: table_status fk_tables; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.table_status
    ADD CONSTRAINT fk_tables FOREIGN KEY (id_table) REFERENCES public.tables(id_table);


-- Completed on 2026-04-10 09:52:30

--
-- PostgreSQL database dump complete
--

\unrestrict m9DyZj9mpviq98vcTqAqazTdmGt6aA60lC3pOj8fbXC8bbwKfaqrMrnONGoW5G5

