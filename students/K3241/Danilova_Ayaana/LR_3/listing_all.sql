--
-- PostgreSQL database dump
--

\restrict 0C7lvSw4fbhKnWhZmKhxJxU3KdWetIK8WygRzVRgdWM5GQnIatl1Unexd7hleTI

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

-- Started on 2026-03-30 22:52:50

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
-- TOC entry 5118 (class 1262 OID 16417)
-- Name: CloudMonet; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE "CloudMonet" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


\unrestrict 0C7lvSw4fbhKnWhZmKhxJxU3KdWetIK8WygRzVRgdWM5GQnIatl1Unexd7hleTI
\connect "CloudMonet"
\restrict 0C7lvSw4fbhKnWhZmKhxJxU3KdWetIK8WygRzVRgdWM5GQnIatl1Unexd7hleTI

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
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 5118
-- Name: DATABASE "CloudMonet"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE "CloudMonet" IS 'бд для обслуживания клиентов ресторана';


--
-- TOC entry 6 (class 2615 OID 16418)
-- Name: v1; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA v1;


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA v1; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA v1 IS 'первая версия бд ';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16453)
-- Name: batch; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.batch (
    batch_id integer NOT NULL,
    shipment_id integer NOT NULL,
    ingr_id integer NOT NULL,
    ingr_unit_cost numeric(19,4) NOT NULL,
    ingr_count numeric(12,3) NOT NULL,
    ingr_unit numeric(12,3) NOT NULL,
    batch_status character varying NOT NULL,
    batch_exp_data date NOT NULL,
    ingr_unit_vol numeric(12,3) NOT NULL,
    total_batch_cost numeric(19,4) GENERATED ALWAYS AS ((ingr_unit_cost * ingr_count)) STORED
);


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE batch; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.batch IS 'a batch of a specific ingredient in a supply that stores information about its status for subsequent distribution to storages';


--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN batch.ingr_unit_vol; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.batch.ingr_unit_vol IS 'volume of the ingredient in the specified unit of measurement per package';


--
-- TOC entry 238 (class 1259 OID 16553)
-- Name: career_log; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.career_log (
    note_id integer NOT NULL,
    worker_id integer NOT NULL,
    event_type character varying(20) NOT NULL,
    new_val character varying(100),
    desciption character varying(300),
    command_num integer,
    event_date date DEFAULT now() NOT NULL
);


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE career_log; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.career_log IS 'employee background information: job changes, dismissals, reprimands, vacations etc';


--
-- TOC entry 237 (class 1259 OID 16552)
-- Name: career_log_note_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.career_log_note_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 237
-- Name: career_log_note_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.career_log_note_id_seq OWNED BY v1.career_log.note_id;


--
-- TOC entry 232 (class 1259 OID 16520)
-- Name: category; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.category (
    category_id integer NOT NULL,
    category_name character varying(50) NOT NULL,
    storage_access boolean NOT NULL,
    has_health_cert boolean NOT NULL
);


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE category; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.category IS 'restaurant responsibility area: Kitchen, Floor, Management';


--
-- TOC entry 231 (class 1259 OID 16519)
-- Name: category_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 231
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.category_id_seq OWNED BY v1.category.category_id;


--
-- TOC entry 219 (class 1259 OID 16452)
-- Name: delivery_scoup_batch_num_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.delivery_scoup_batch_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 219
-- Name: delivery_scoup_batch_num_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.delivery_scoup_batch_num_seq OWNED BY v1.batch.batch_id;


--
-- TOC entry 226 (class 1259 OID 16484)
-- Name: dish; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.dish (
    dish_id integer NOT NULL,
    dish_name character varying(100) NOT NULL,
    dish_price numeric(19,4) NOT NULL,
    dish_ccal integer NOT NULL,
    dish_weight numeric(8,2) NOT NULL
);


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE dish; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.dish IS 'general information about the dish: calculated weight and calories, name, and fixed price at the current moment according to the restaurant''s standards';


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN dish.dish_weight; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.dish.dish_weight IS 'calculated cost of the dish according to the cost of the ingredients multiplied by the quantity';


--
-- TOC entry 225 (class 1259 OID 16483)
-- Name: dish_dish_code_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.dish_dish_code_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 225
-- Name: dish_dish_code_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.dish_dish_code_seq OWNED BY v1.dish.dish_id;


--
-- TOC entry 228 (class 1259 OID 16493)
-- Name: dish_scoup; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.dish_scoup (
    dish_sc_id integer NOT NULL,
    dish_id integer NOT NULL,
    ingr_id integer NOT NULL,
    ingr_vol numeric(8,1) NOT NULL
);


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE dish_scoup; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.dish_scoup IS 'dish composition with the dish''s external key and ingredient''s quantity in its units of measurement';


--
-- TOC entry 227 (class 1259 OID 16492)
-- Name: dish_scoup_volume_ID_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."dish_scoup_volume_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 227
-- Name: dish_scoup_volume_ID_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."dish_scoup_volume_ID_seq" OWNED BY v1.dish_scoup.dish_sc_id;


--
-- TOC entry 248 (class 1259 OID 24661)
-- Name: ingredient; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.ingredient (
    ingredient_id integer NOT NULL,
    ingr_unit character varying(10) NOT NULL,
    ingr_proteins numeric(8,2) NOT NULL,
    ingr_fats numeric(8,2) NOT NULL,
    ingr_carb numeric(8,2) NOT NULL,
    ingr_storage_req character varying(7) NOT NULL,
    ingr_ccal integer NOT NULL,
    ingr_min_qty numeric(10,3) NOT NULL,
    ingr_name character varying(100) NOT NULL,
    CONSTRAINT chk_ingredient_storage_req CHECK (((ingr_storage_req)::text = ANY ((ARRAY['Cold'::character varying, 'Dry'::character varying, 'Ambient'::character varying])::text[])))
);


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE ingredient; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.ingredient IS 'general information about the ingredient: kcal - according to the restaurant''s standards, the unit of measurement';


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN ingredient.ingr_unit; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_unit IS 'the unit of measurement for an ingredient according to the standard for calculating the cost in the menu';


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN ingredient.ingr_min_qty; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_min_qty IS 'minimum stock in all storages';


--
-- TOC entry 247 (class 1259 OID 24660)
-- Name: ingredient_ingredient_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.ingredient_ingredient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 247
-- Name: ingredient_ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.ingredient_ingredient_id_seq OWNED BY v1.ingredient.ingredient_id;


--
-- TOC entry 242 (class 1259 OID 24599)
-- Name: order; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1."order" (
    order_id integer NOT NULL,
    order_status character varying(9) NOT NULL,
    order_p_table integer NOT NULL,
    order_price numeric(19,4) NOT NULL,
    order_notes character varying(300),
    created_at date DEFAULT now() NOT NULL
);


--
-- TOC entry 241 (class 1259 OID 24598)
-- Name: order _order_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."order _order_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 241
-- Name: order _order_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."order _order_id_seq" OWNED BY v1."order".order_id;


--
-- TOC entry 250 (class 1259 OID 24684)
-- Name: order_scoup; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.order_scoup (
    order_sc_id integer NOT NULL,
    chef_id integer NOT NULL,
    order_id integer NOT NULL,
    dish_id integer NOT NULL,
    dish_price numeric(19,4) NOT NULL,
    dish_count integer NOT NULL,
    dish_wishes character varying(300),
    row_total numeric(19,4) GENERATED ALWAYS AS ((dish_price * (dish_count)::numeric)) STORED
);


--
-- TOC entry 249 (class 1259 OID 24683)
-- Name: order_scoup_order_sc_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.order_scoup_order_sc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 249
-- Name: order_scoup_order_sc_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.order_scoup_order_sc_id_seq OWNED BY v1.order_scoup.order_sc_id;


--
-- TOC entry 236 (class 1259 OID 16543)
-- Name: passport; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.passport (
    passport_id integer NOT NULL,
    worker_id integer,
    passport_num character varying(15),
    passport_series character varying(10),
    issued_by character varying(300),
    issued_date character varying(15),
    department_code character varying(10),
    registartion_address character varying(500),
    passport_status character varying(11)
);


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE passport; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.passport IS 'passport data of employees';


--
-- TOC entry 235 (class 1259 OID 16542)
-- Name: passport_passport_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.passport_passport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 235
-- Name: passport_passport_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.passport_passport_id_seq OWNED BY v1.passport.passport_id;


--
-- TOC entry 246 (class 1259 OID 24628)
-- Name: pinned_table; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.pinned_table (
    pinning_id integer NOT NULL,
    waiter_id integer NOT NULL,
    shift_id integer NOT NULL,
    pinning_status character varying(8) NOT NULL,
    table_id integer NOT NULL,
    CONSTRAINT chk_pin_table_status CHECK (((pinning_status)::text = ANY ((ARRAY['waiting'::character varying, 'active'::character varying, 'serviced'::character varying])::text[])))
);


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE pinned_table; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.pinned_table IS 'pinned tables by waiter on the shift';


--
-- TOC entry 245 (class 1259 OID 24627)
-- Name: pinned_table_pinning_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.pinned_table_pinning_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 245
-- Name: pinned_table_pinning_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.pinned_table_pinning_id_seq OWNED BY v1.pinned_table.pinning_id;


--
-- TOC entry 234 (class 1259 OID 16528)
-- Name: position; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1."position" (
    position_id integer NOT NULL,
    category_id integer NOT NULL,
    payment_type character varying(20) NOT NULL,
    work_format character varying(20) NOT NULL,
    position_name character varying(100) NOT NULL,
    CONSTRAINT fk_payment_type CHECK (((payment_type)::text = ANY ((ARRAY['Salary'::character varying, 'Hourly'::character varying, 'Commission'::character varying])::text[]))),
    CONSTRAINT fk_work_format CHECK (((work_format)::text = ANY ((ARRAY['Full-time'::character varying, 'Part-time'::character varying, 'Remote'::character varying, 'Flexible'::character varying])::text[])))
);


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE "position"; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1."position" IS 'должность сотрудника';


--
-- TOC entry 233 (class 1259 OID 16527)
-- Name: position_position_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.position_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 233
-- Name: position_position_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.position_position_id_seq OWNED BY v1."position".position_id;


--
-- TOC entry 216 (class 1259 OID 16419)
-- Name: provider; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.provider (
    provider_id integer NOT NULL,
    organization character varying(100) NOT NULL,
    contacts character varying(13) NOT NULL,
    CONSTRAINT check_phone_format CHECK (((contacts)::text ~ '^\+\d{1,3}\d{10}$'::text))
);


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE provider; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.provider IS 'минимальная информация о поставщиках ингредиентов: наименование организации, телефонный номер, идентификатор';


--
-- TOC entry 244 (class 1259 OID 24619)
-- Name: shift ; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1."shift " (
    shift_id integer NOT NULL,
    shift_status character varying(11) NOT NULL,
    shift_type character varying(5) NOT NULL,
    shift_start date NOT NULL,
    shift_end date NOT NULL,
    admin_id integer NOT NULL,
    CONSTRAINT chk_shift_status CHECK (((shift_status)::text = ANY ((ARRAY['Waiting'::character varying, 'In progress'::character varying, 'Cancelled'::character varying])::text[]))),
    CONSTRAINT chk_shift_type CHECK (((shift_type)::text = ANY ((ARRAY['Night'::character varying, 'Day'::character varying])::text[])))
);


--
-- TOC entry 243 (class 1259 OID 24618)
-- Name: shift _shift_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."shift _shift_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 243
-- Name: shift _shift_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."shift _shift_id_seq" OWNED BY v1."shift ".shift_id;


--
-- TOC entry 218 (class 1259 OID 16436)
-- Name: shipment; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.shipment (
    shipment_id integer NOT NULL,
    ship_date date DEFAULT now() NOT NULL,
    ship_status character varying(15) NOT NULL,
    ship_total_cost numeric(19,4) NOT NULL,
    provider_id integer NOT NULL
);


--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE shipment; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.shipment IS 'поставки';


--
-- TOC entry 217 (class 1259 OID 16435)
-- Name: shipments_shipment_ID_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."shipments_shipment_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 217
-- Name: shipments_shipment_ID_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."shipments_shipment_ID_seq" OWNED BY v1.shipment.shipment_id;


--
-- TOC entry 222 (class 1259 OID 16465)
-- Name: storage; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.storage (
    " storage_id" integer NOT NULL,
    stor_address character varying(100) NOT NULL,
    stor_type character varying(7) NOT NULL
);


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE storage; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.storage IS 'minimal information about the restaurant''s storages';


--
-- TOC entry 224 (class 1259 OID 16473)
-- Name: storage_scoup; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.storage_scoup (
    st_scoup_id integer NOT NULL,
    storage_id integer NOT NULL,
    batch_id integer NOT NULL,
    st_sc_status character varying(9) NOT NULL,
    st_sc_curr_qty numeric(12,3) NOT NULL,
    st_sc_min_qty numeric(12,3) NOT NULL
);


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE storage_scoup; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.storage_scoup IS 'состав склада - ингредиенты';


--
-- TOC entry 223 (class 1259 OID 16472)
-- Name: storage_scoup_rest_ID_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."storage_scoup_rest_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 223
-- Name: storage_scoup_rest_ID_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."storage_scoup_rest_ID_seq" OWNED BY v1.storage_scoup.st_scoup_id;


--
-- TOC entry 221 (class 1259 OID 16464)
-- Name: storgage_ store_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."storgage_ store_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 221
-- Name: storgage_ store_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."storgage_ store_id_seq" OWNED BY v1.storage." storage_id";


--
-- TOC entry 240 (class 1259 OID 24591)
-- Name: table_unit; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.table_unit (
    table_id integer NOT NULL,
    table_status character varying(12) NOT NULL,
    wishes character varying(300),
    CONSTRAINT chk_table_status CHECK (((table_status)::text = ANY ((ARRAY['Free'::character varying, 'Occupied'::character varying, 'Booked'::character varying, 'Out_of_Order'::character varying])::text[])))
);


--
-- TOC entry 239 (class 1259 OID 24590)
-- Name: table_unit_table_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.table_unit_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 239
-- Name: table_unit_table_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.table_unit_table_id_seq OWNED BY v1.table_unit.table_id;


--
-- TOC entry 230 (class 1259 OID 16500)
-- Name: worker; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.worker (
    worker_id integer NOT NULL,
    full_name character varying(200) NOT NULL,
    timesheet_num integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    position_id integer NOT NULL,
    phone_number character varying(15),
    email character varying
);


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE worker; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.worker IS 'сотрудники двух возможных категорий: повар и официант ';


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN worker.is_active; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker.is_active IS 'Is the person currently working in the specified position?';


--
-- TOC entry 229 (class 1259 OID 16499)
-- Name: worker_worker_ID_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1."worker_worker_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 229
-- Name: worker_worker_ID_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."worker_worker_ID_seq" OWNED BY v1.worker.worker_id;


--
-- TOC entry 4822 (class 2604 OID 16456)
-- Name: batch batch_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.batch ALTER COLUMN batch_id SET DEFAULT nextval('v1.delivery_scoup_batch_num_seq'::regclass);


--
-- TOC entry 4833 (class 2604 OID 16556)
-- Name: career_log note_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.career_log ALTER COLUMN note_id SET DEFAULT nextval('v1.career_log_note_id_seq'::regclass);


--
-- TOC entry 4830 (class 2604 OID 16523)
-- Name: category category_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.category ALTER COLUMN category_id SET DEFAULT nextval('v1.category_id_seq'::regclass);


--
-- TOC entry 4826 (class 2604 OID 16487)
-- Name: dish dish_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish ALTER COLUMN dish_id SET DEFAULT nextval('v1.dish_dish_code_seq'::regclass);


--
-- TOC entry 4827 (class 2604 OID 16496)
-- Name: dish_scoup dish_sc_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_scoup ALTER COLUMN dish_sc_id SET DEFAULT nextval('v1."dish_scoup_volume_ID_seq"'::regclass);


--
-- TOC entry 4840 (class 2604 OID 24664)
-- Name: ingredient ingredient_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.ingredient ALTER COLUMN ingredient_id SET DEFAULT nextval('v1.ingredient_ingredient_id_seq'::regclass);


--
-- TOC entry 4836 (class 2604 OID 24602)
-- Name: order order_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."order" ALTER COLUMN order_id SET DEFAULT nextval('v1."order _order_id_seq"'::regclass);


--
-- TOC entry 4841 (class 2604 OID 24687)
-- Name: order_scoup order_sc_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.order_scoup ALTER COLUMN order_sc_id SET DEFAULT nextval('v1.order_scoup_order_sc_id_seq'::regclass);


--
-- TOC entry 4832 (class 2604 OID 16546)
-- Name: passport passport_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.passport ALTER COLUMN passport_id SET DEFAULT nextval('v1.passport_passport_id_seq'::regclass);


--
-- TOC entry 4839 (class 2604 OID 24631)
-- Name: pinned_table pinning_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.pinned_table ALTER COLUMN pinning_id SET DEFAULT nextval('v1.pinned_table_pinning_id_seq'::regclass);


--
-- TOC entry 4831 (class 2604 OID 16531)
-- Name: position position_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."position" ALTER COLUMN position_id SET DEFAULT nextval('v1.position_position_id_seq'::regclass);


--
-- TOC entry 4838 (class 2604 OID 24622)
-- Name: shift  shift_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."shift " ALTER COLUMN shift_id SET DEFAULT nextval('v1."shift _shift_id_seq"'::regclass);


--
-- TOC entry 4820 (class 2604 OID 16439)
-- Name: shipment shipment_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shipment ALTER COLUMN shipment_id SET DEFAULT nextval('v1."shipments_shipment_ID_seq"'::regclass);


--
-- TOC entry 4824 (class 2604 OID 16468)
-- Name: storage  storage_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage ALTER COLUMN " storage_id" SET DEFAULT nextval('v1."storgage_ store_id_seq"'::regclass);


--
-- TOC entry 4825 (class 2604 OID 16476)
-- Name: storage_scoup st_scoup_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup ALTER COLUMN st_scoup_id SET DEFAULT nextval('v1."storage_scoup_rest_ID_seq"'::regclass);


--
-- TOC entry 4835 (class 2604 OID 24594)
-- Name: table_unit table_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.table_unit ALTER COLUMN table_id SET DEFAULT nextval('v1.table_unit_table_id_seq'::regclass);


--
-- TOC entry 4828 (class 2604 OID 16503)
-- Name: worker worker_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker ALTER COLUMN worker_id SET DEFAULT nextval('v1."worker_worker_ID_seq"'::regclass);


--
-- TOC entry 5082 (class 0 OID 16453)
-- Dependencies: 220
-- Data for Name: batch; Type: TABLE DATA; Schema: v1; Owner: -
--

INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (1, 1, 36, 504.8158, 38.937, 1.000, 'Reserved', '2026-03-31', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (2, 1, 36, 156.0574, 20.239, 1.000, 'Quarantine', '2026-04-01', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (3, 1, 36, 319.9072, 1.456, 1.000, 'Available', '2026-04-02', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (4, 1, 36, 349.6564, 10.501, 1.000, 'Quarantine', '2026-04-03', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (5, 1, 36, 210.7829, 37.631, 1.000, 'Quarantine', '2026-04-04', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (6, 1, 36, 44.9720, 22.310, 1.000, 'Quarantine', '2026-04-05', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (7, 1, 36, 379.6458, 7.433, 1.000, 'Quarantine', '2026-04-06', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (8, 1, 36, 320.7895, 14.605, 1.000, 'Reserved', '2026-04-07', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (9, 1, 36, 227.2137, 45.047, 1.000, 'Quarantine', '2026-04-08', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (10, 1, 36, 307.7598, 39.933, 1.000, 'Quarantine', '2026-04-09', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (11, 1, 36, 65.9162, 7.311, 1.000, 'Quarantine', '2026-04-10', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (12, 1, 36, 240.5240, 10.605, 1.000, 'Quarantine', '2026-04-11', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (13, 1, 36, 177.8174, 29.775, 1.000, 'Quarantine', '2026-04-12', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (14, 1, 36, 398.6716, 17.057, 1.000, 'Quarantine', '2026-04-13', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (15, 1, 36, 269.0689, 4.601, 1.000, 'Reserved', '2026-04-14', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (16, 1, 36, 23.8307, 42.139, 1.000, 'Reserved', '2026-04-15', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (17, 1, 36, 129.3983, 25.958, 1.000, 'Available', '2026-04-16', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (18, 1, 36, 304.2063, 21.194, 1.000, 'Quarantine', '2026-04-17', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (19, 1, 36, 265.0130, 13.049, 1.000, 'Quarantine', '2026-04-18', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (20, 1, 36, 415.2225, 34.261, 1.000, 'Available', '2026-04-19', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (21, 1, 36, 191.2932, 45.918, 1.000, 'Available', '2026-04-20', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (22, 1, 36, 131.5544, 31.173, 1.000, 'Quarantine', '2026-04-21', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (23, 1, 36, 259.0236, 36.602, 1.000, 'Available', '2026-04-22', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (24, 1, 36, 505.8917, 32.975, 1.000, 'Quarantine', '2026-04-23', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (25, 1, 36, 231.3986, 33.952, 1.000, 'Quarantine', '2026-04-24', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (26, 1, 36, 100.2823, 8.164, 1.000, 'Quarantine', '2026-04-25', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (27, 1, 36, 124.0687, 14.585, 1.000, 'Available', '2026-04-26', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (28, 1, 36, 358.0375, 25.029, 1.000, 'Quarantine', '2026-04-27', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (29, 1, 36, 160.8395, 15.311, 1.000, 'Quarantine', '2026-04-28', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (30, 1, 36, 210.5662, 31.328, 1.000, 'Reserved', '2026-04-29', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (31, 1, 36, 57.8832, 35.231, 1.000, 'Available', '2026-04-30', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (32, 1, 36, 167.2269, 24.526, 1.000, 'Available', '2026-05-01', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (33, 1, 36, 59.3953, 22.814, 1.000, 'Quarantine', '2026-05-02', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (34, 1, 36, 309.2547, 19.464, 1.000, 'Quarantine', '2026-05-03', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (35, 1, 36, 165.5452, 18.311, 1.000, 'Quarantine', '2026-05-04', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (36, 1, 36, 422.4055, 42.854, 1.000, 'Available', '2026-05-05', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (37, 1, 36, 328.2639, 31.278, 1.000, 'Quarantine', '2026-05-06', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (38, 1, 36, 109.5300, 23.271, 1.000, 'Quarantine', '2026-05-07', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (39, 1, 36, 53.1934, 35.955, 1.000, 'Quarantine', '2026-05-08', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (40, 1, 36, 156.4899, 28.285, 1.000, 'Reserved', '2026-05-09', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (41, 1, 36, 383.8890, 10.944, 1.000, 'Reserved', '2026-05-10', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (42, 1, 36, 466.3591, 36.896, 1.000, 'Quarantine', '2026-05-11', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (43, 1, 36, 291.8549, 42.073, 1.000, 'Available', '2026-05-12', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (44, 1, 36, 207.5921, 17.303, 1.000, 'Quarantine', '2026-05-13', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (45, 1, 36, 472.7616, 26.328, 1.000, 'Quarantine', '2026-05-14', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (46, 1, 36, 149.8186, 21.048, 1.000, 'Reserved', '2026-05-15', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (47, 1, 36, 172.8129, 9.667, 1.000, 'Quarantine', '2026-05-16', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (48, 1, 36, 184.7517, 47.365, 1.000, 'Available', '2026-05-17', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (49, 1, 36, 63.8155, 46.811, 1.000, 'Available', '2026-05-18', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (50, 1, 36, 465.0895, 6.749, 1.000, 'Reserved', '2026-05-19', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (51, 1, 36, 288.9515, 5.546, 1.000, 'Available', '2026-05-20', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (52, 1, 36, 253.4795, 16.001, 1.000, 'Quarantine', '2026-05-21', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (53, 1, 36, 152.0432, 20.784, 1.000, 'Reserved', '2026-05-22', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (54, 1, 36, 234.0119, 11.562, 1.000, 'Reserved', '2026-05-23', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (55, 1, 36, 215.7707, 31.723, 1.000, 'Reserved', '2026-05-24', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (56, 1, 36, 480.6212, 41.634, 1.000, 'Available', '2026-05-25', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (57, 1, 36, 160.7195, 35.574, 1.000, 'Available', '2026-05-26', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (58, 1, 36, 163.3705, 29.824, 1.000, 'Available', '2026-05-27', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (59, 1, 36, 189.8569, 4.201, 1.000, 'Reserved', '2026-05-28', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (60, 1, 36, 410.1547, 7.628, 1.000, 'Reserved', '2026-05-29', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (61, 1, 36, 446.6863, 26.474, 1.000, 'Available', '2026-05-30', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (62, 1, 36, 287.3346, 6.400, 1.000, 'Available', '2026-05-31', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (63, 1, 36, 462.8470, 44.175, 1.000, 'Reserved', '2026-06-01', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (64, 1, 36, 29.4286, 8.112, 1.000, 'Quarantine', '2026-06-02', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (65, 1, 36, 308.3602, 21.151, 1.000, 'Reserved', '2026-06-03', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (66, 1, 36, 117.5329, 45.127, 1.000, 'Available', '2026-06-04', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (67, 1, 36, 439.4516, 49.791, 1.000, 'Quarantine', '2026-06-05', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (68, 1, 36, 301.6799, 8.347, 1.000, 'Reserved', '2026-06-06', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (69, 1, 36, 431.8256, 7.646, 1.000, 'Quarantine', '2026-06-07', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (70, 1, 36, 475.8223, 7.286, 1.000, 'Reserved', '2026-06-08', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (71, 1, 36, 295.8407, 20.901, 1.000, 'Quarantine', '2026-06-09', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (72, 1, 36, 306.1821, 11.268, 1.000, 'Reserved', '2026-06-10', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (73, 1, 36, 277.7591, 2.814, 1.000, 'Reserved', '2026-06-11', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (74, 1, 36, 376.3557, 28.572, 1.000, 'Available', '2026-06-12', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (75, 1, 36, 65.6167, 31.522, 1.000, 'Quarantine', '2026-06-13', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (76, 1, 36, 46.7464, 1.534, 1.000, 'Available', '2026-06-14', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (77, 1, 36, 428.2614, 33.622, 1.000, 'Quarantine', '2026-06-15', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (78, 1, 36, 390.7273, 13.417, 1.000, 'Reserved', '2026-06-16', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (79, 1, 36, 434.1675, 19.378, 1.000, 'Available', '2026-06-17', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (80, 1, 36, 89.0971, 35.578, 1.000, 'Quarantine', '2026-06-18', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (81, 1, 36, 150.5237, 2.384, 1.000, 'Reserved', '2026-06-19', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (82, 1, 36, 402.6980, 13.861, 1.000, 'Available', '2026-06-20', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (83, 1, 36, 455.1961, 26.797, 1.000, 'Available', '2026-06-21', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (84, 1, 36, 400.2089, 4.031, 1.000, 'Quarantine', '2026-06-22', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (85, 1, 36, 180.7163, 42.806, 1.000, 'Reserved', '2026-06-23', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (86, 1, 36, 246.6232, 20.762, 1.000, 'Available', '2026-06-24', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (87, 1, 36, 429.1447, 32.642, 1.000, 'Quarantine', '2026-06-25', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (88, 1, 36, 372.7101, 15.067, 1.000, 'Reserved', '2026-06-26', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (89, 1, 36, 199.8795, 27.886, 1.000, 'Reserved', '2026-06-27', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (90, 1, 36, 136.1597, 5.875, 1.000, 'Available', '2026-06-28', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (91, 1, 36, 314.3835, 1.084, 1.000, 'Quarantine', '2026-06-29', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (92, 1, 36, 263.5866, 2.164, 1.000, 'Reserved', '2026-06-30', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (93, 1, 36, 174.5769, 16.687, 1.000, 'Reserved', '2026-07-01', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (94, 1, 36, 169.6347, 44.095, 1.000, 'Reserved', '2026-07-02', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (95, 1, 36, 418.1454, 21.284, 1.000, 'Available', '2026-07-03', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (96, 1, 36, 294.7787, 37.216, 1.000, 'Reserved', '2026-07-04', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (97, 1, 36, 314.3549, 30.370, 1.000, 'Available', '2026-07-05', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (98, 1, 36, 181.4380, 23.607, 1.000, 'Quarantine', '2026-07-06', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (99, 1, 36, 202.4487, 20.612, 1.000, 'Reserved', '2026-07-07', 1.000);
INSERT INTO v1.batch (batch_id, shipment_id, ingr_id, ingr_unit_cost, ingr_count, ingr_unit, batch_status, batch_exp_data, ingr_unit_vol) VALUES (100, 1, 36, 106.2898, 48.671, 1.000, 'Reserved', '2026-07-08', 1.000);


--
-- TOC entry 5100 (class 0 OID 16553)
-- Dependencies: 238
-- Data for Name: career_log; Type: TABLE DATA; Schema: v1; Owner: -
--



--
-- TOC entry 5094 (class 0 OID 16520)
-- Dependencies: 232
-- Data for Name: category; Type: TABLE DATA; Schema: v1; Owner: -
--

INSERT INTO v1.category (category_id, category_name, storage_access, has_health_cert) VALUES (1, 'Kitchen', true, true);
INSERT INTO v1.category (category_id, category_name, storage_access, has_health_cert) VALUES (2, 'Floor', false, false);
INSERT INTO v1.category (category_id, category_name, storage_access, has_health_cert) VALUES (3, 'Management', true, false);


--
-- TOC entry 5088 (class 0 OID 16484)
-- Dependencies: 226
-- Data for Name: dish; Type: TABLE DATA; Schema: v1; Owner: -
--

INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (1, 'Десерт от шефа №1', 1510.5742, 537, 285.44);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (2, 'Горячее от шефа №2', 438.4103, 253, 509.35);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (3, 'Суп от шефа №3', 595.2804, 344, 504.70);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (4, 'Салат от шефа №4', 580.0583, 205, 454.98);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (5, 'Салат от шефа №5', 789.0477, 823, 553.50);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (6, 'Суп от шефа №6', 647.7390, 68, 202.83);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (7, 'Десерт от шефа №7', 1543.2603, 223, 277.01);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (8, 'Горячее от шефа №8', 1521.7750, 76, 532.54);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (9, 'Напиток от шефа №9', 1075.6618, 627, 483.06);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (10, 'Салат от шефа №10', 1205.1937, 517, 486.83);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (11, 'Десерт от шефа №11', 1323.2693, 655, 213.36);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (12, 'Суп от шефа №12', 1053.8586, 698, 359.26);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (13, 'Напиток от шефа №13', 139.8895, 545, 152.77);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (14, 'Горячее от шефа №14', 1546.4510, 573, 274.80);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (15, 'Суп от шефа №15', 1429.9747, 413, 550.61);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (16, 'Десерт от шефа №16', 174.9777, 623, 104.70);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (17, 'Салат от шефа №17', 656.0282, 811, 222.93);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (18, 'Десерт от шефа №18', 495.2989, 365, 243.47);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (19, 'Суп от шефа №19', 1337.8791, 798, 567.21);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (20, 'Десерт от шефа №20', 633.9706, 332, 327.84);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (21, 'Суп от шефа №21', 430.2888, 251, 507.38);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (22, 'Горячее от шефа №22', 908.6470, 649, 234.04);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (23, 'Десерт от шефа №23', 1335.1985, 196, 481.46);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (24, 'Напиток от шефа №24', 963.2820, 381, 400.42);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (25, 'Напиток от шефа №25', 1455.4182, 832, 528.14);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (26, 'Салат от шефа №26', 439.6546, 213, 360.70);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (27, 'Суп от шефа №27', 1364.8603, 82, 206.94);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (28, 'Салат от шефа №28', 768.7781, 494, 342.85);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (29, 'Салат от шефа №29', 280.8403, 539, 109.11);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (30, 'Суп от шефа №30', 524.8320, 747, 319.53);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (31, 'Напиток от шефа №31', 1415.0684, 731, 308.67);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (32, 'Суп от шефа №32', 1546.2234, 551, 235.07);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (33, 'Десерт от шефа №33', 663.7094, 391, 308.58);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (34, 'Суп от шефа №34', 367.6654, 539, 306.19);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (35, 'Суп от шефа №35', 1022.8436, 289, 584.76);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (36, 'Десерт от шефа №36', 571.1436, 148, 121.89);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (37, 'Салат от шефа №37', 1473.5060, 548, 536.34);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (38, 'Салат от шефа №38', 1348.7035, 433, 467.77);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (39, 'Десерт от шефа №39', 1336.7925, 303, 115.14);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (40, 'Горячее от шефа №40', 1219.9746, 779, 197.46);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (41, 'Суп от шефа №41', 1162.7053, 493, 184.27);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (42, 'Горячее от шефа №42', 384.7551, 343, 542.55);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (43, 'Напиток от шефа №43', 564.6203, 349, 318.49);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (44, 'Напиток от шефа №44', 1328.7645, 735, 460.22);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (45, 'Напиток от шефа №45', 299.3839, 65, 454.55);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (46, 'Горячее от шефа №46', 319.0732, 348, 515.62);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (47, 'Суп от шефа №47', 733.9545, 231, 462.17);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (48, 'Десерт от шефа №48', 919.5976, 610, 124.90);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (49, 'Горячее от шефа №49', 1221.3862, 311, 276.11);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (50, 'Горячее от шефа №50', 1245.5666, 53, 398.51);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (51, 'Салат от шефа №51', 190.1138, 286, 317.55);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (52, 'Десерт от шефа №52', 197.1759, 140, 126.10);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (53, 'Напиток от шефа №53', 431.1982, 379, 267.55);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (54, 'Десерт от шефа №54', 696.2676, 832, 236.60);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (55, 'Напиток от шефа №55', 103.3732, 434, 216.93);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (56, 'Суп от шефа №56', 519.0344, 649, 131.63);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (57, 'Десерт от шефа №57', 152.6323, 647, 467.56);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (58, 'Напиток от шефа №58', 1073.6393, 92, 247.60);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (59, 'Суп от шефа №59', 628.7765, 325, 219.88);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (60, 'Салат от шефа №60', 183.0099, 123, 175.82);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (61, 'Десерт от шефа №61', 191.3552, 96, 594.68);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (62, 'Горячее от шефа №62', 1415.4398, 161, 245.45);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (63, 'Салат от шефа №63', 233.1424, 744, 263.99);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (64, 'Горячее от шефа №64', 382.2159, 524, 327.08);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (65, 'Десерт от шефа №65', 182.8379, 399, 278.75);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (66, 'Десерт от шефа №66', 117.7197, 723, 382.90);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (67, 'Десерт от шефа №67', 968.2433, 625, 484.94);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (68, 'Десерт от шефа №68', 617.5863, 79, 337.37);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (69, 'Салат от шефа №69', 525.0969, 814, 111.44);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (70, 'Горячее от шефа №70', 1416.6141, 720, 103.80);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (71, 'Суп от шефа №71', 1266.8763, 370, 298.21);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (72, 'Салат от шефа №72', 1438.2304, 109, 573.77);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (73, 'Десерт от шефа №73', 373.4855, 437, 348.26);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (74, 'Горячее от шефа №74', 1535.5221, 207, 427.93);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (75, 'Напиток от шефа №75', 583.5176, 352, 112.85);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (76, 'Салат от шефа №76', 1008.0753, 782, 142.90);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (77, 'Десерт от шефа №77', 916.5961, 666, 227.23);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (78, 'Напиток от шефа №78', 109.8063, 339, 244.14);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (79, 'Салат от шефа №79', 1110.1377, 432, 489.19);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (80, 'Десерт от шефа №80', 1097.5293, 664, 127.93);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (81, 'Напиток от шефа №81', 1457.5744, 104, 271.87);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (82, 'Горячее от шефа №82', 253.3810, 321, 248.52);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (83, 'Напиток от шефа №83', 535.6145, 520, 109.50);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (84, 'Напиток от шефа №84', 1595.4184, 680, 498.31);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (85, 'Суп от шефа №85', 607.3411, 70, 530.05);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (86, 'Салат от шефа №86', 1264.6485, 96, 189.22);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (87, 'Горячее от шефа №87', 422.6710, 638, 569.53);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (88, 'Горячее от шефа №88', 1205.5800, 549, 360.88);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (89, 'Десерт от шефа №89', 1551.0277, 274, 375.18);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (90, 'Суп от шефа №90', 1069.5176, 713, 212.40);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (91, 'Салат от шефа №91', 1509.5715, 193, 569.09);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (92, 'Горячее от шефа №92', 631.9897, 150, 223.50);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (93, 'Салат от шефа №93', 836.4395, 643, 155.19);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (94, 'Напиток от шефа №94', 528.2237, 304, 153.44);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (95, 'Салат от шефа №95', 1001.3100, 61, 323.12);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (96, 'Напиток от шефа №96', 1162.6944, 413, 548.02);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (97, 'Горячее от шефа №97', 1210.8907, 735, 122.36);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (98, 'Суп от шефа №98', 495.5935, 136, 596.44);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (99, 'Салат от шефа №99', 1064.9942, 730, 102.13);
INSERT INTO v1.dish (dish_id, dish_name, dish_price, dish_ccal, dish_weight) VALUES (100, 'Салат от шефа №100', 717.6169, 807, 122.85);


--
-- TOC entry 5090 (class 0 OID 16493)
-- Dependencies: 228
-- Data for Name: dish_scoup; Type: TABLE DATA; Schema: v1; Owner: -
--



--
-- TOC entry 5110 (class 0 OID 24661)
-- Dependencies: 248
-- Data for Name: ingredient; Type: TABLE DATA; Schema: v1; Owner: -
--

INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (1, 'кг', 0.29, 4.69, 6.33, 'Ambient', 354, 5.000, 'Масло сорт 1');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (2, 'кг', 14.15, 10.72, 9.85, 'Ambient', 64, 5.000, 'Мука сорт 2');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (3, 'л', 18.95, 18.87, 2.77, 'Dry', 53, 5.000, 'Сыр сорт 3');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (4, 'шт', 17.76, 18.69, 13.25, 'Cold', 303, 5.000, 'Томат сорт 4');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (5, 'кг', 13.37, 13.05, 7.82, 'Dry', 427, 5.000, 'Перец сорт 5');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (6, 'кг', 18.26, 2.06, 6.45, 'Ambient', 259, 5.000, 'Соль сорт 6');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (7, 'кг', 2.04, 17.19, 2.90, 'Dry', 311, 5.000, 'Перец сорт 7');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (8, 'шт', 17.85, 4.77, 16.96, 'Dry', 499, 5.000, 'Мясо сорт 8');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (9, 'шт', 14.07, 1.61, 3.98, 'Cold', 110, 5.000, 'Мука сорт 9');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (10, 'л', 6.19, 1.11, 3.90, 'Cold', 439, 5.000, 'Томат сорт 10');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (11, 'кг', 10.62, 7.11, 3.08, 'Cold', 333, 5.000, 'Томат сорт 11');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (12, 'шт', 19.50, 12.00, 0.17, 'Dry', 242, 5.000, 'Зелень сорт 12');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (13, 'л', 0.72, 9.42, 12.94, 'Cold', 507, 5.000, 'Лук сорт 13');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (14, 'кг', 3.30, 10.79, 4.81, 'Dry', 141, 5.000, 'Мясо сорт 14');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (15, 'кг', 9.55, 7.02, 12.43, 'Dry', 452, 5.000, 'Лук сорт 15');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (16, 'кг', 13.56, 5.54, 4.23, 'Dry', 196, 5.000, 'Мясо сорт 16');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (17, 'кг', 9.77, 5.44, 4.25, 'Ambient', 209, 5.000, 'Томат сорт 17');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (18, 'кг', 11.49, 11.03, 12.05, 'Dry', 245, 5.000, 'Соль сорт 18');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (19, 'л', 6.89, 15.50, 17.34, 'Cold', 360, 5.000, 'Сыр сорт 19');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (20, 'л', 6.39, 7.32, 14.50, 'Ambient', 218, 5.000, 'Масло сорт 20');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (21, 'шт', 4.00, 18.98, 14.30, 'Ambient', 345, 5.000, 'Лук сорт 21');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (22, 'кг', 14.39, 15.20, 13.29, 'Dry', 416, 5.000, 'Томат сорт 22');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (23, 'л', 8.07, 13.84, 0.80, 'Cold', 256, 5.000, 'Огурец сорт 23');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (24, 'л', 11.14, 0.18, 11.37, 'Cold', 185, 5.000, 'Лук сорт 24');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (25, 'кг', 9.05, 13.19, 18.62, 'Ambient', 35, 5.000, 'Мясо сорт 25');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (26, 'шт', 8.84, 16.54, 6.09, 'Dry', 478, 5.000, 'Лук сорт 26');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (27, 'л', 17.08, 10.08, 11.93, 'Dry', 67, 5.000, 'Томат сорт 27');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (28, 'кг', 13.27, 8.25, 18.61, 'Ambient', 202, 5.000, 'Сыр сорт 28');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (29, 'кг', 9.34, 3.01, 14.86, 'Ambient', 121, 5.000, 'Томат сорт 29');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (30, 'л', 17.20, 19.15, 15.33, 'Dry', 176, 5.000, 'Сыр сорт 30');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (31, 'л', 19.77, 18.01, 19.96, 'Dry', 415, 5.000, 'Сыр сорт 31');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (32, 'л', 6.18, 8.07, 1.14, 'Dry', 420, 5.000, 'Мясо сорт 32');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (33, 'шт', 12.85, 19.94, 4.75, 'Dry', 276, 5.000, 'Масло сорт 33');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (34, 'л', 13.49, 11.22, 19.63, 'Ambient', 375, 5.000, 'Соль сорт 34');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (35, 'л', 5.78, 12.24, 6.27, 'Dry', 427, 5.000, 'Масло сорт 35');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (36, 'кг', 12.48, 10.63, 18.58, 'Cold', 478, 5.000, 'Лук сорт 36');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (37, 'кг', 5.17, 0.50, 7.49, 'Dry', 291, 5.000, 'Масло сорт 37');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (38, 'л', 15.97, 3.35, 11.90, 'Ambient', 104, 5.000, 'Мясо сорт 38');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (39, 'л', 19.36, 5.31, 4.54, 'Cold', 42, 5.000, 'Мука сорт 39');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (40, 'кг', 11.39, 8.35, 9.29, 'Cold', 402, 5.000, 'Томат сорт 40');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (41, 'шт', 13.18, 15.66, 14.87, 'Ambient', 281, 5.000, 'Зелень сорт 41');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (42, 'л', 15.58, 19.57, 5.62, 'Cold', 479, 5.000, 'Масло сорт 42');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (43, 'кг', 13.37, 18.03, 5.55, 'Dry', 177, 5.000, 'Перец сорт 43');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (44, 'шт', 9.15, 5.75, 14.94, 'Dry', 24, 5.000, 'Мясо сорт 44');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (45, 'шт', 8.92, 8.74, 5.03, 'Cold', 59, 5.000, 'Сыр сорт 45');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (46, 'л', 1.62, 15.16, 2.29, 'Ambient', 322, 5.000, 'Соль сорт 46');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (47, 'кг', 19.00, 12.90, 18.71, 'Dry', 72, 5.000, 'Зелень сорт 47');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (48, 'л', 14.09, 3.56, 13.83, 'Ambient', 389, 5.000, 'Лук сорт 48');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (49, 'кг', 10.57, 17.23, 19.91, 'Ambient', 178, 5.000, 'Соль сорт 49');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (50, 'шт', 11.73, 15.05, 7.68, 'Dry', 99, 5.000, 'Мясо сорт 50');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (51, 'кг', 5.36, 18.72, 4.40, 'Dry', 227, 5.000, 'Мука сорт 51');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (52, 'л', 2.34, 17.87, 16.57, 'Dry', 82, 5.000, 'Зелень сорт 52');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (53, 'шт', 9.72, 12.71, 12.91, 'Cold', 182, 5.000, 'Лук сорт 53');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (54, 'кг', 8.45, 19.77, 17.17, 'Ambient', 379, 5.000, 'Сыр сорт 54');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (55, 'кг', 7.92, 16.12, 10.04, 'Dry', 437, 5.000, 'Лук сорт 55');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (56, 'шт', 6.32, 12.56, 6.20, 'Cold', 183, 5.000, 'Перец сорт 56');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (57, 'кг', 1.83, 18.58, 13.89, 'Cold', 393, 5.000, 'Мясо сорт 57');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (58, 'шт', 19.18, 1.83, 9.78, 'Ambient', 333, 5.000, 'Томат сорт 58');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (59, 'кг', 13.84, 16.58, 3.27, 'Ambient', 139, 5.000, 'Масло сорт 59');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (60, 'шт', 0.78, 1.35, 4.50, 'Dry', 261, 5.000, 'Сыр сорт 60');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (61, 'л', 19.63, 4.29, 9.86, 'Cold', 30, 5.000, 'Томат сорт 61');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (62, 'кг', 1.53, 4.38, 1.69, 'Ambient', 305, 5.000, 'Мука сорт 62');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (63, 'шт', 7.53, 19.99, 19.83, 'Ambient', 332, 5.000, 'Томат сорт 63');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (64, 'кг', 3.31, 3.90, 13.68, 'Cold', 122, 5.000, 'Лук сорт 64');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (65, 'шт', 5.69, 14.04, 3.71, 'Dry', 280, 5.000, 'Масло сорт 65');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (66, 'л', 7.73, 5.52, 7.59, 'Dry', 235, 5.000, 'Сыр сорт 66');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (67, 'шт', 19.46, 10.99, 14.45, 'Ambient', 419, 5.000, 'Перец сорт 67');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (68, 'кг', 9.99, 8.62, 17.27, 'Cold', 278, 5.000, 'Сыр сорт 68');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (69, 'шт', 7.81, 17.60, 7.88, 'Dry', 97, 5.000, 'Масло сорт 69');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (70, 'л', 0.32, 13.94, 8.71, 'Dry', 453, 5.000, 'Лук сорт 70');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (71, 'шт', 11.76, 8.95, 7.39, 'Dry', 219, 5.000, 'Масло сорт 71');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (72, 'шт', 14.54, 2.17, 9.28, 'Cold', 370, 5.000, 'Масло сорт 72');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (73, 'л', 17.12, 15.48, 16.81, 'Cold', 226, 5.000, 'Мясо сорт 73');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (74, 'шт', 8.41, 10.01, 18.87, 'Dry', 308, 5.000, 'Зелень сорт 74');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (75, 'шт', 19.30, 10.26, 3.03, 'Cold', 271, 5.000, 'Мука сорт 75');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (76, 'л', 9.17, 1.92, 4.13, 'Ambient', 270, 5.000, 'Мясо сорт 76');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (77, 'л', 4.37, 3.81, 11.97, 'Cold', 434, 5.000, 'Лук сорт 77');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (78, 'л', 5.72, 9.19, 8.21, 'Dry', 254, 5.000, 'Соль сорт 78');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (79, 'кг', 18.24, 9.16, 11.60, 'Dry', 494, 5.000, 'Перец сорт 79');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (80, 'л', 5.62, 9.28, 11.58, 'Cold', 187, 5.000, 'Томат сорт 80');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (81, 'шт', 11.35, 15.69, 19.86, 'Ambient', 92, 5.000, 'Лук сорт 81');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (82, 'л', 18.87, 16.86, 5.29, 'Dry', 488, 5.000, 'Сыр сорт 82');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (83, 'кг', 12.27, 14.37, 11.28, 'Ambient', 63, 5.000, 'Огурец сорт 83');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (84, 'кг', 15.05, 4.52, 16.54, 'Cold', 257, 5.000, 'Перец сорт 84');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (85, 'л', 4.35, 10.29, 18.70, 'Dry', 344, 5.000, 'Перец сорт 85');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (86, 'кг', 7.58, 14.33, 16.96, 'Cold', 137, 5.000, 'Томат сорт 86');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (87, 'л', 1.34, 10.25, 12.41, 'Ambient', 374, 5.000, 'Огурец сорт 87');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (88, 'л', 8.64, 0.37, 12.52, 'Cold', 53, 5.000, 'Соль сорт 88');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (89, 'шт', 18.57, 7.85, 3.43, 'Cold', 439, 5.000, 'Перец сорт 89');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (90, 'кг', 19.07, 11.72, 17.17, 'Ambient', 405, 5.000, 'Соль сорт 90');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (91, 'кг', 6.68, 2.58, 13.04, 'Dry', 159, 5.000, 'Томат сорт 91');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (92, 'л', 12.29, 3.27, 15.66, 'Cold', 398, 5.000, 'Сыр сорт 92');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (93, 'шт', 15.87, 4.28, 19.44, 'Ambient', 417, 5.000, 'Лук сорт 93');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (94, 'шт', 12.97, 4.79, 17.19, 'Cold', 408, 5.000, 'Огурец сорт 94');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (95, 'кг', 1.14, 2.81, 11.63, 'Ambient', 466, 5.000, 'Огурец сорт 95');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (96, 'кг', 10.68, 16.12, 8.28, 'Dry', 468, 5.000, 'Лук сорт 96');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (97, 'л', 4.83, 18.57, 5.72, 'Cold', 122, 5.000, 'Огурец сорт 97');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (98, 'кг', 17.45, 3.68, 17.19, 'Ambient', 488, 5.000, 'Мука сорт 98');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (99, 'кг', 12.61, 7.11, 7.26, 'Ambient', 344, 5.000, 'Мука сорт 99');
INSERT INTO v1.ingredient (ingredient_id, ingr_unit, ingr_proteins, ingr_fats, ingr_carb, ingr_storage_req, ingr_ccal, ingr_min_qty, ingr_name) VALUES (100, 'кг', 16.63, 0.51, 18.83, 'Cold', 97, 5.000, 'Томат сорт 100');


--
-- TOC entry 5104 (class 0 OID 24599)
-- Dependencies: 242
-- Data for Name: order; Type: TABLE DATA; Schema: v1; Owner: -
--



--
-- TOC entry 5112 (class 0 OID 24684)
-- Dependencies: 250
-- Data for Name: order_scoup; Type: TABLE DATA; Schema: v1; Owner: -
--



--
-- TOC entry 5098 (class 0 OID 16543)
-- Dependencies: 236
-- Data for Name: passport; Type: TABLE DATA; Schema: v1; Owner: -
--



--
-- TOC entry 5108 (class 0 OID 24628)
-- Dependencies: 246
-- Data for Name: pinned_table; Type: TABLE DATA; Schema: v1; Owner: -
--



--
-- TOC entry 5096 (class 0 OID 16528)
-- Dependencies: 234
-- Data for Name: position; Type: TABLE DATA; Schema: v1; Owner: -
--

INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (1, 2, 'Commission', 'Remote', 'Cleaner №1');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (2, 3, 'Commission', 'Flexible', 'Hostess №2');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (3, 1, 'Salary', 'Flexible', 'Hostess №3');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (4, 2, 'Salary', 'Flexible', 'Manager №4');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (5, 3, 'Hourly', 'Full-time', 'Hostess №5');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (6, 1, 'Hourly', 'Remote', 'Manager №6');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (7, 2, 'Salary', 'Full-time', 'Cook №7');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (8, 3, 'Salary', 'Full-time', 'Barista №8');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (9, 1, 'Salary', 'Full-time', 'Hostess №9');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (10, 2, 'Hourly', 'Flexible', 'Waiter №10');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (11, 3, 'Commission', 'Part-time', 'Sommelier №11');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (12, 1, 'Salary', 'Remote', 'Cleaner №12');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (13, 2, 'Commission', 'Remote', 'Cook №13');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (14, 3, 'Hourly', 'Flexible', 'Cook №14');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (15, 1, 'Salary', 'Part-time', 'Chef №15');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (16, 2, 'Hourly', 'Remote', 'Cook №16');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (17, 3, 'Commission', 'Full-time', 'Cleaner №17');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (18, 1, 'Commission', 'Part-time', 'Waiter №18');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (19, 2, 'Commission', 'Part-time', 'Manager №19');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (20, 3, 'Hourly', 'Part-time', 'Cleaner №20');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (21, 1, 'Salary', 'Full-time', 'Chef №21');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (22, 2, 'Salary', 'Part-time', 'Barista №22');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (23, 3, 'Hourly', 'Flexible', 'Barista №23');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (24, 1, 'Hourly', 'Flexible', 'Manager №24');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (25, 2, 'Hourly', 'Part-time', 'Waiter №25');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (26, 3, 'Salary', 'Full-time', 'Manager №26');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (27, 1, 'Hourly', 'Remote', 'Hostess №27');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (28, 2, 'Hourly', 'Full-time', 'Barista №28');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (29, 3, 'Salary', 'Part-time', 'Chef №29');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (30, 1, 'Hourly', 'Full-time', 'Barista №30');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (31, 2, 'Commission', 'Full-time', 'Manager №31');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (32, 3, 'Commission', 'Flexible', 'Chef №32');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (33, 1, 'Hourly', 'Flexible', 'Cook №33');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (34, 2, 'Hourly', 'Full-time', 'Sommelier №34');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (35, 3, 'Hourly', 'Full-time', 'Manager №35');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (36, 1, 'Hourly', 'Part-time', 'Cook №36');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (37, 2, 'Hourly', 'Remote', 'Hostess №37');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (38, 3, 'Salary', 'Remote', 'Cleaner №38');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (39, 1, 'Commission', 'Part-time', 'Cleaner №39');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (40, 2, 'Commission', 'Full-time', 'Cleaner №40');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (41, 3, 'Salary', 'Remote', 'Chef №41');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (42, 1, 'Salary', 'Full-time', 'Waiter №42');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (43, 2, 'Hourly', 'Flexible', 'Sommelier №43');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (44, 3, 'Salary', 'Full-time', 'Barista №44');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (45, 1, 'Hourly', 'Flexible', 'Sommelier №45');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (46, 2, 'Salary', 'Full-time', 'Cleaner №46');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (47, 3, 'Hourly', 'Flexible', 'Chef №47');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (48, 1, 'Commission', 'Full-time', 'Chef №48');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (49, 2, 'Salary', 'Full-time', 'Hostess №49');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (50, 3, 'Commission', 'Full-time', 'Hostess №50');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (51, 1, 'Salary', 'Remote', 'Chef №51');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (52, 2, 'Salary', 'Full-time', 'Chef №52');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (53, 3, 'Commission', 'Full-time', 'Manager №53');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (54, 1, 'Commission', 'Part-time', 'Chef №54');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (55, 2, 'Commission', 'Part-time', 'Sommelier №55');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (56, 3, 'Commission', 'Full-time', 'Waiter №56');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (57, 1, 'Hourly', 'Remote', 'Sommelier №57');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (58, 2, 'Commission', 'Remote', 'Hostess №58');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (59, 3, 'Salary', 'Full-time', 'Cook №59');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (60, 1, 'Commission', 'Part-time', 'Cook №60');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (61, 2, 'Hourly', 'Remote', 'Hostess №61');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (62, 3, 'Hourly', 'Remote', 'Chef №62');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (63, 1, 'Commission', 'Remote', 'Waiter №63');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (64, 2, 'Commission', 'Part-time', 'Sommelier №64');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (65, 3, 'Hourly', 'Full-time', 'Chef №65');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (66, 1, 'Hourly', 'Remote', 'Waiter №66');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (67, 2, 'Hourly', 'Flexible', 'Sommelier №67');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (68, 3, 'Salary', 'Part-time', 'Sommelier №68');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (69, 1, 'Commission', 'Flexible', 'Manager №69');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (70, 2, 'Salary', 'Full-time', 'Barista №70');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (71, 3, 'Salary', 'Flexible', 'Chef №71');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (72, 1, 'Salary', 'Flexible', 'Sommelier №72');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (73, 2, 'Hourly', 'Flexible', 'Barista №73');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (74, 3, 'Commission', 'Remote', 'Waiter №74');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (75, 1, 'Hourly', 'Flexible', 'Chef №75');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (76, 2, 'Salary', 'Remote', 'Cleaner №76');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (77, 3, 'Salary', 'Remote', 'Waiter №77');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (78, 1, 'Commission', 'Part-time', 'Barista №78');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (79, 2, 'Hourly', 'Remote', 'Barista №79');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (80, 3, 'Commission', 'Remote', 'Waiter №80');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (81, 1, 'Commission', 'Full-time', 'Hostess №81');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (82, 2, 'Hourly', 'Part-time', 'Barista №82');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (83, 3, 'Hourly', 'Full-time', 'Cook №83');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (84, 1, 'Hourly', 'Part-time', 'Barista №84');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (85, 2, 'Salary', 'Full-time', 'Cleaner №85');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (86, 3, 'Salary', 'Full-time', 'Hostess №86');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (87, 1, 'Salary', 'Part-time', 'Cleaner №87');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (88, 2, 'Salary', 'Remote', 'Manager №88');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (89, 3, 'Commission', 'Remote', 'Cook №89');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (90, 1, 'Commission', 'Remote', 'Barista №90');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (91, 2, 'Commission', 'Full-time', 'Hostess №91');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (92, 3, 'Commission', 'Part-time', 'Hostess №92');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (93, 1, 'Salary', 'Part-time', 'Barista №93');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (94, 2, 'Commission', 'Full-time', 'Manager №94');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (95, 3, 'Salary', 'Flexible', 'Waiter №95');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (96, 1, 'Commission', 'Flexible', 'Waiter №96');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (97, 2, 'Commission', 'Part-time', 'Sommelier №97');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (98, 3, 'Hourly', 'Full-time', 'Sommelier №98');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (99, 1, 'Salary', 'Full-time', 'Barista №99');
INSERT INTO v1."position" (position_id, category_id, payment_type, work_format, position_name) VALUES (100, 2, 'Hourly', 'Full-time', 'Waiter №100');


--
-- TOC entry 5078 (class 0 OID 16419)
-- Dependencies: 216
-- Data for Name: provider; Type: TABLE DATA; Schema: v1; Owner: -
--

INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (1, 'ООО ОвощнойРай №1', '+70000000001');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (2, 'ООО ФудСервис №2', '+70000000002');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (3, 'ООО ПродТорг №3', '+70000000003');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (4, 'ООО ОвощнойРай №4', '+70000000004');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (5, 'ООО ОвощнойРай №5', '+70000000005');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (6, 'ООО МяснойМир №6', '+70000000006');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (7, 'ООО ПродТорг №7', '+70000000007');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (8, 'ООО ПродТорг №8', '+70000000008');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (9, 'ООО ОвощнойРай №9', '+70000000009');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (10, 'ООО ФудСервис №10', '+70000000010');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (11, 'ООО ПродТорг №11', '+70000000011');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (12, 'ООО ФудСервис №12', '+70000000012');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (13, 'ООО МяснойМир №13', '+70000000013');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (14, 'ООО ФудСервис №14', '+70000000014');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (15, 'ООО ФудСервис №15', '+70000000015');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (16, 'ООО ФудСервис №16', '+70000000016');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (17, 'ООО ФудСервис №17', '+70000000017');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (18, 'ООО ОвощнойРай №18', '+70000000018');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (19, 'ООО ФудСервис №19', '+70000000019');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (20, 'ООО ПродТорг №20', '+70000000020');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (21, 'ООО МяснойМир №21', '+70000000021');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (22, 'ООО ОвощнойРай №22', '+70000000022');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (23, 'ООО ПродТорг №23', '+70000000023');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (24, 'ООО МяснойМир №24', '+70000000024');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (25, 'ООО МяснойМир №25', '+70000000025');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (26, 'ООО ПродТорг №26', '+70000000026');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (27, 'ООО МяснойМир №27', '+70000000027');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (28, 'ООО МяснойМир №28', '+70000000028');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (29, 'ООО МяснойМир №29', '+70000000029');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (30, 'ООО ОвощнойРай №30', '+70000000030');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (31, 'ООО ОвощнойРай №31', '+70000000031');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (32, 'ООО ФудСервис №32', '+70000000032');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (33, 'ООО ПродТорг №33', '+70000000033');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (34, 'ООО ПродТорг №34', '+70000000034');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (35, 'ООО ОвощнойРай №35', '+70000000035');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (36, 'ООО МяснойМир №36', '+70000000036');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (37, 'ООО ПродТорг №37', '+70000000037');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (38, 'ООО ПродТорг №38', '+70000000038');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (39, 'ООО ОвощнойРай №39', '+70000000039');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (40, 'ООО ПродТорг №40', '+70000000040');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (41, 'ООО МяснойМир №41', '+70000000041');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (42, 'ООО ФудСервис №42', '+70000000042');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (43, 'ООО ФудСервис №43', '+70000000043');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (44, 'ООО ПродТорг №44', '+70000000044');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (45, 'ООО ПродТорг №45', '+70000000045');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (46, 'ООО ПродТорг №46', '+70000000046');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (47, 'ООО ПродТорг №47', '+70000000047');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (48, 'ООО ОвощнойРай №48', '+70000000048');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (49, 'ООО ОвощнойРай №49', '+70000000049');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (50, 'ООО МяснойМир №50', '+70000000050');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (51, 'ООО ФудСервис №51', '+70000000051');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (52, 'ООО МяснойМир №52', '+70000000052');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (53, 'ООО ФудСервис №53', '+70000000053');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (54, 'ООО ПродТорг №54', '+70000000054');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (55, 'ООО МяснойМир №55', '+70000000055');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (56, 'ООО МяснойМир №56', '+70000000056');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (57, 'ООО ПродТорг №57', '+70000000057');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (58, 'ООО МяснойМир №58', '+70000000058');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (59, 'ООО ФудСервис №59', '+70000000059');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (60, 'ООО ПродТорг №60', '+70000000060');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (61, 'ООО МяснойМир №61', '+70000000061');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (62, 'ООО ОвощнойРай №62', '+70000000062');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (63, 'ООО ФудСервис №63', '+70000000063');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (64, 'ООО ОвощнойРай №64', '+70000000064');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (65, 'ООО ПродТорг №65', '+70000000065');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (66, 'ООО ПродТорг №66', '+70000000066');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (67, 'ООО ПродТорг №67', '+70000000067');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (68, 'ООО ФудСервис №68', '+70000000068');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (69, 'ООО ОвощнойРай №69', '+70000000069');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (70, 'ООО ПродТорг №70', '+70000000070');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (71, 'ООО ОвощнойРай №71', '+70000000071');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (72, 'ООО МяснойМир №72', '+70000000072');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (73, 'ООО МяснойМир №73', '+70000000073');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (74, 'ООО ПродТорг №74', '+70000000074');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (75, 'ООО ПродТорг №75', '+70000000075');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (76, 'ООО ОвощнойРай №76', '+70000000076');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (77, 'ООО ФудСервис №77', '+70000000077');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (78, 'ООО МяснойМир №78', '+70000000078');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (79, 'ООО МяснойМир №79', '+70000000079');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (80, 'ООО ОвощнойРай №80', '+70000000080');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (81, 'ООО МяснойМир №81', '+70000000081');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (82, 'ООО ПродТорг №82', '+70000000082');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (83, 'ООО МяснойМир №83', '+70000000083');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (84, 'ООО ОвощнойРай №84', '+70000000084');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (85, 'ООО ПродТорг №85', '+70000000085');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (86, 'ООО МяснойМир №86', '+70000000086');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (87, 'ООО ПродТорг №87', '+70000000087');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (88, 'ООО ОвощнойРай №88', '+70000000088');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (89, 'ООО ПродТорг №89', '+70000000089');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (90, 'ООО ФудСервис №90', '+70000000090');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (91, 'ООО ОвощнойРай №91', '+70000000091');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (92, 'ООО ПродТорг №92', '+70000000092');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (93, 'ООО ПродТорг №93', '+70000000093');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (94, 'ООО ФудСервис №94', '+70000000094');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (95, 'ООО ОвощнойРай №95', '+70000000095');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (96, 'ООО МяснойМир №96', '+70000000096');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (97, 'ООО ПродТорг №97', '+70000000097');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (98, 'ООО ПродТорг №98', '+70000000098');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (99, 'ООО ФудСервис №99', '+70000000099');
INSERT INTO v1.provider (provider_id, organization, contacts) VALUES (100, 'ООО ПродТорг №100', '+70000000100');


--
-- TOC entry 5106 (class 0 OID 24619)
-- Dependencies: 244
-- Data for Name: shift ; Type: TABLE DATA; Schema: v1; Owner: -
--



--
-- TOC entry 5080 (class 0 OID 16436)
-- Dependencies: 218
-- Data for Name: shipment; Type: TABLE DATA; Schema: v1; Owner: -
--

INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (1, '2026-03-29', 'Accepted', 4701.1197, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (2, '2026-03-28', 'Ordered', 5062.2771, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (3, '2026-03-27', 'Arrived', 9415.5264, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (4, '2026-03-26', 'Ordered', 5181.0670, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (5, '2026-03-25', 'Ordered', 5440.3823, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (6, '2026-03-24', 'Ordered', 3068.5737, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (7, '2026-03-23', 'Arrived', 2732.5761, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (8, '2026-03-22', 'Ordered', 6469.8691, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (9, '2026-03-21', 'Ordered', 7100.5788, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (10, '2026-03-20', 'Accepted', 9618.9386, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (11, '2026-03-19', 'Accepted', 830.1103, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (12, '2026-03-18', 'Accepted', 8117.5183, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (13, '2026-03-17', 'Ordered', 5207.0746, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (14, '2026-03-16', 'Ordered', 9564.4939, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (15, '2026-03-15', 'Ordered', 5125.2376, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (16, '2026-03-14', 'Accepted', 1121.5484, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (17, '2026-03-13', 'Arrived', 4570.5552, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (18, '2026-03-12', 'Ordered', 8656.0040, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (19, '2026-03-11', 'Ordered', 5721.3740, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (20, '2026-03-10', 'Accepted', 5883.5376, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (21, '2026-03-09', 'Accepted', 3017.9972, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (22, '2026-03-08', 'Ordered', 1007.7430, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (23, '2026-03-07', 'Ordered', 7636.6263, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (24, '2026-03-06', 'Ordered', 1205.0507, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (25, '2026-03-05', 'Accepted', 2695.4863, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (26, '2026-03-04', 'Accepted', 4723.7953, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (27, '2026-03-03', 'Ordered', 8663.3087, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (28, '2026-03-02', 'Ordered', 7229.3891, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (29, '2026-03-01', 'Ordered', 3366.6469, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (30, '2026-02-28', 'Ordered', 2671.9961, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (31, '2026-02-27', 'Ordered', 5107.2660, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (32, '2026-02-26', 'Ordered', 2980.3515, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (33, '2026-02-25', 'Accepted', 1715.1924, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (34, '2026-02-24', 'Arrived', 3579.1180, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (35, '2026-02-23', 'Accepted', 3994.4364, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (36, '2026-02-22', 'Arrived', 2193.8869, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (37, '2026-02-21', 'Accepted', 6076.7813, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (38, '2026-02-20', 'Arrived', 927.7240, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (39, '2026-02-19', 'Ordered', 6720.7617, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (40, '2026-02-18', 'Accepted', 3240.0108, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (41, '2026-02-17', 'Ordered', 4738.4942, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (42, '2026-02-16', 'Arrived', 9987.0291, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (43, '2026-02-15', 'Ordered', 8251.4101, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (44, '2026-02-14', 'Ordered', 6007.4490, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (45, '2026-02-13', 'Arrived', 3505.0628, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (46, '2026-02-12', 'Arrived', 9765.6822, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (47, '2026-02-11', 'Ordered', 5609.9504, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (48, '2026-02-10', 'Arrived', 3624.2873, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (49, '2026-02-09', 'Ordered', 9785.0426, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (50, '2026-02-08', 'Accepted', 3293.8709, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (51, '2026-02-07', 'Ordered', 6745.4500, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (52, '2026-02-06', 'Accepted', 8577.9318, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (53, '2026-02-05', 'Ordered', 2839.4442, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (54, '2026-02-04', 'Arrived', 5041.3228, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (55, '2026-02-03', 'Ordered', 4906.1319, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (56, '2026-02-02', 'Ordered', 2678.4974, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (57, '2026-02-01', 'Arrived', 6832.0613, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (58, '2026-01-31', 'Ordered', 8322.9678, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (59, '2026-01-30', 'Arrived', 4299.8723, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (60, '2026-01-29', 'Accepted', 9836.1619, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (61, '2026-01-28', 'Ordered', 8040.8734, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (62, '2026-01-27', 'Ordered', 9548.7325, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (63, '2026-01-26', 'Arrived', 7130.4873, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (64, '2026-01-25', 'Accepted', 1183.3997, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (65, '2026-01-24', 'Ordered', 594.2622, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (66, '2026-01-23', 'Accepted', 3624.8932, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (67, '2026-01-22', 'Accepted', 4482.2321, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (68, '2026-01-21', 'Arrived', 7608.6547, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (69, '2026-01-20', 'Arrived', 5878.0553, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (70, '2026-01-19', 'Ordered', 222.7174, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (71, '2026-01-18', 'Ordered', 541.3498, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (72, '2026-01-17', 'Ordered', 1667.1562, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (73, '2026-01-16', 'Arrived', 9032.8628, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (74, '2026-01-15', 'Arrived', 1009.5131, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (75, '2026-01-14', 'Ordered', 4252.4942, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (76, '2026-01-13', 'Arrived', 5458.0380, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (77, '2026-01-12', 'Ordered', 7610.7802, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (78, '2026-01-11', 'Accepted', 435.8531, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (79, '2026-01-10', 'Accepted', 2301.3323, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (80, '2026-01-09', 'Accepted', 6509.1162, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (81, '2026-01-08', 'Ordered', 3225.6002, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (82, '2026-01-07', 'Arrived', 6337.4895, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (83, '2026-01-06', 'Ordered', 5125.3963, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (84, '2026-01-05', 'Arrived', 7587.3587, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (85, '2026-01-04', 'Accepted', 9098.4491, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (86, '2026-01-03', 'Accepted', 8573.5821, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (87, '2026-01-02', 'Ordered', 311.1652, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (88, '2026-01-01', 'Accepted', 2611.7194, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (89, '2025-12-31', 'Accepted', 3018.4156, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (90, '2025-12-30', 'Ordered', 1903.2516, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (91, '2025-12-29', 'Arrived', 5890.9104, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (92, '2025-12-28', 'Accepted', 9773.9767, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (93, '2025-12-27', 'Arrived', 5165.9710, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (94, '2025-12-26', 'Arrived', 677.9971, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (95, '2025-12-25', 'Ordered', 4556.6650, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (96, '2025-12-24', 'Ordered', 6953.7454, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (97, '2025-12-23', 'Arrived', 291.8689, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (98, '2025-12-22', 'Arrived', 9997.2859, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (99, '2025-12-21', 'Accepted', 2097.3503, 76);
INSERT INTO v1.shipment (shipment_id, ship_date, ship_status, ship_total_cost, provider_id) VALUES (100, '2025-12-20', 'Ordered', 5987.2749, 76);


--
-- TOC entry 5084 (class 0 OID 16465)
-- Dependencies: 222
-- Data for Name: storage; Type: TABLE DATA; Schema: v1; Owner: -
--

INSERT INTO v1.storage (" storage_id", stor_address, stor_type) VALUES (1, 'Главная кухня', 'Cold');
INSERT INTO v1.storage (" storage_id", stor_address, stor_type) VALUES (2, 'Сухой склад', 'Dry');
INSERT INTO v1.storage (" storage_id", stor_address, stor_type) VALUES (3, 'Бар', 'Ambient');


--
-- TOC entry 5086 (class 0 OID 16473)
-- Dependencies: 224
-- Data for Name: storage_scoup; Type: TABLE DATA; Schema: v1; Owner: -
--



--
-- TOC entry 5102 (class 0 OID 24591)
-- Dependencies: 240
-- Data for Name: table_unit; Type: TABLE DATA; Schema: v1; Owner: -
--



--
-- TOC entry 5092 (class 0 OID 16500)
-- Dependencies: 230
-- Data for Name: worker; Type: TABLE DATA; Schema: v1; Owner: -
--

INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (1, 'Петр Сидоров', 1001, true, 64, '+79990000001', 'staff1@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (2, 'Мария Иванов', 1002, true, 64, '+79990000002', 'staff2@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (3, 'Анна Иванов', 1003, true, 64, '+79990000003', 'staff3@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (4, 'Алексей Смирнов', 1004, true, 64, '+79990000004', 'staff4@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (5, 'Мария Смирнов', 1005, true, 64, '+79990000005', 'staff5@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (6, 'Анна Кузнецов', 1006, true, 64, '+79990000006', 'staff6@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (7, 'Иван Петров', 1007, true, 64, '+79990000007', 'staff7@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (8, 'Петр Кузнецов', 1008, true, 64, '+79990000008', 'staff8@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (9, 'Петр Иванов', 1009, true, 64, '+79990000009', 'staff9@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (10, 'Петр Петров', 1010, true, 64, '+79990000010', 'staff10@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (11, 'Петр Петров', 1011, true, 64, '+79990000011', 'staff11@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (12, 'Дмитрий Петров', 1012, true, 64, '+79990000012', 'staff12@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (13, 'Дмитрий Смирнов', 1013, true, 64, '+79990000013', 'staff13@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (14, 'Анна Иванов', 1014, true, 64, '+79990000014', 'staff14@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (15, 'Дмитрий Иванов', 1015, true, 64, '+79990000015', 'staff15@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (16, 'Петр Петров', 1016, true, 64, '+79990000016', 'staff16@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (17, 'Мария Кузнецов', 1017, true, 64, '+79990000017', 'staff17@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (18, 'Алексей Петров', 1018, true, 64, '+79990000018', 'staff18@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (19, 'Петр Петров', 1019, true, 64, '+79990000019', 'staff19@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (20, 'Анна Петров', 1020, true, 64, '+79990000020', 'staff20@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (21, 'Мария Смирнов', 1021, true, 64, '+79990000021', 'staff21@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (22, 'Алексей Сидоров', 1022, true, 64, '+79990000022', 'staff22@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (23, 'Дмитрий Сидоров', 1023, true, 64, '+79990000023', 'staff23@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (24, 'Иван Смирнов', 1024, true, 64, '+79990000024', 'staff24@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (25, 'Алексей Петров', 1025, true, 64, '+79990000025', 'staff25@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (26, 'Алексей Сидоров', 1026, true, 64, '+79990000026', 'staff26@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (27, 'Анна Смирнов', 1027, true, 64, '+79990000027', 'staff27@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (28, 'Иван Петров', 1028, true, 64, '+79990000028', 'staff28@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (29, 'Анна Кузнецов', 1029, true, 64, '+79990000029', 'staff29@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (30, 'Алексей Петров', 1030, true, 64, '+79990000030', 'staff30@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (31, 'Алексей Смирнов', 1031, true, 64, '+79990000031', 'staff31@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (32, 'Иван Иванов', 1032, true, 64, '+79990000032', 'staff32@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (33, 'Алексей Петров', 1033, true, 64, '+79990000033', 'staff33@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (34, 'Иван Петров', 1034, true, 64, '+79990000034', 'staff34@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (35, 'Дмитрий Смирнов', 1035, true, 64, '+79990000035', 'staff35@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (36, 'Иван Кузнецов', 1036, true, 64, '+79990000036', 'staff36@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (37, 'Дмитрий Смирнов', 1037, true, 64, '+79990000037', 'staff37@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (38, 'Алексей Сидоров', 1038, true, 64, '+79990000038', 'staff38@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (39, 'Дмитрий Смирнов', 1039, true, 64, '+79990000039', 'staff39@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (40, 'Иван Смирнов', 1040, true, 64, '+79990000040', 'staff40@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (41, 'Дмитрий Иванов', 1041, true, 64, '+79990000041', 'staff41@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (42, 'Мария Петров', 1042, true, 64, '+79990000042', 'staff42@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (43, 'Петр Иванов', 1043, true, 64, '+79990000043', 'staff43@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (44, 'Алексей Смирнов', 1044, true, 64, '+79990000044', 'staff44@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (45, 'Алексей Петров', 1045, true, 64, '+79990000045', 'staff45@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (46, 'Анна Смирнов', 1046, true, 64, '+79990000046', 'staff46@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (47, 'Дмитрий Петров', 1047, true, 64, '+79990000047', 'staff47@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (48, 'Петр Кузнецов', 1048, true, 64, '+79990000048', 'staff48@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (49, 'Дмитрий Сидоров', 1049, true, 64, '+79990000049', 'staff49@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (50, 'Петр Смирнов', 1050, true, 64, '+79990000050', 'staff50@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (51, 'Иван Сидоров', 1051, true, 64, '+79990000051', 'staff51@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (52, 'Анна Сидоров', 1052, true, 64, '+79990000052', 'staff52@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (53, 'Алексей Иванов', 1053, true, 64, '+79990000053', 'staff53@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (54, 'Мария Петров', 1054, true, 64, '+79990000054', 'staff54@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (55, 'Мария Кузнецов', 1055, true, 64, '+79990000055', 'staff55@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (56, 'Мария Сидоров', 1056, true, 64, '+79990000056', 'staff56@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (57, 'Иван Сидоров', 1057, true, 64, '+79990000057', 'staff57@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (58, 'Иван Иванов', 1058, true, 64, '+79990000058', 'staff58@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (59, 'Алексей Петров', 1059, true, 64, '+79990000059', 'staff59@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (60, 'Анна Сидоров', 1060, true, 64, '+79990000060', 'staff60@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (61, 'Мария Иванов', 1061, true, 64, '+79990000061', 'staff61@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (62, 'Иван Кузнецов', 1062, true, 64, '+79990000062', 'staff62@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (63, 'Дмитрий Кузнецов', 1063, true, 64, '+79990000063', 'staff63@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (64, 'Дмитрий Смирнов', 1064, true, 64, '+79990000064', 'staff64@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (65, 'Дмитрий Кузнецов', 1065, true, 64, '+79990000065', 'staff65@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (66, 'Мария Петров', 1066, true, 64, '+79990000066', 'staff66@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (67, 'Петр Иванов', 1067, true, 64, '+79990000067', 'staff67@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (68, 'Дмитрий Петров', 1068, true, 64, '+79990000068', 'staff68@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (69, 'Иван Петров', 1069, true, 64, '+79990000069', 'staff69@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (70, 'Иван Сидоров', 1070, true, 64, '+79990000070', 'staff70@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (71, 'Анна Сидоров', 1071, true, 64, '+79990000071', 'staff71@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (72, 'Иван Сидоров', 1072, true, 64, '+79990000072', 'staff72@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (73, 'Алексей Кузнецов', 1073, true, 64, '+79990000073', 'staff73@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (74, 'Петр Петров', 1074, true, 64, '+79990000074', 'staff74@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (75, 'Мария Иванов', 1075, true, 64, '+79990000075', 'staff75@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (76, 'Иван Смирнов', 1076, true, 64, '+79990000076', 'staff76@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (77, 'Дмитрий Иванов', 1077, true, 64, '+79990000077', 'staff77@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (78, 'Петр Иванов', 1078, true, 64, '+79990000078', 'staff78@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (79, 'Алексей Иванов', 1079, true, 64, '+79990000079', 'staff79@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (80, 'Иван Кузнецов', 1080, true, 64, '+79990000080', 'staff80@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (81, 'Анна Иванов', 1081, true, 64, '+79990000081', 'staff81@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (82, 'Иван Сидоров', 1082, true, 64, '+79990000082', 'staff82@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (83, 'Алексей Петров', 1083, true, 64, '+79990000083', 'staff83@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (84, 'Алексей Сидоров', 1084, true, 64, '+79990000084', 'staff84@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (85, 'Петр Петров', 1085, true, 64, '+79990000085', 'staff85@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (86, 'Иван Иванов', 1086, true, 64, '+79990000086', 'staff86@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (87, 'Иван Сидоров', 1087, true, 64, '+79990000087', 'staff87@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (88, 'Мария Петров', 1088, true, 64, '+79990000088', 'staff88@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (89, 'Алексей Петров', 1089, true, 64, '+79990000089', 'staff89@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (90, 'Иван Кузнецов', 1090, true, 64, '+79990000090', 'staff90@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (91, 'Анна Кузнецов', 1091, true, 64, '+79990000091', 'staff91@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (92, 'Петр Иванов', 1092, true, 64, '+79990000092', 'staff92@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (93, 'Алексей Кузнецов', 1093, true, 64, '+79990000093', 'staff93@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (94, 'Иван Сидоров', 1094, true, 64, '+79990000094', 'staff94@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (95, 'Дмитрий Смирнов', 1095, true, 64, '+79990000095', 'staff95@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (96, 'Дмитрий Сидоров', 1096, true, 64, '+79990000096', 'staff96@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (97, 'Алексей Петров', 1097, true, 64, '+79990000097', 'staff97@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (98, 'Дмитрий Петров', 1098, true, 64, '+79990000098', 'staff98@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (99, 'Алексей Петров', 1099, true, 64, '+79990000099', 'staff99@restaurant.ru');
INSERT INTO v1.worker (worker_id, full_name, timesheet_num, is_active, position_id, phone_number, email) VALUES (100, 'Анна Петров', 1100, true, 64, '+79990000100', 'staff100@restaurant.ru');


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 237
-- Name: career_log_note_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1.career_log_note_id_seq', 1, false);


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 231
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1.category_id_seq', 3, true);


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 219
-- Name: delivery_scoup_batch_num_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1.delivery_scoup_batch_num_seq', 100, true);


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 225
-- Name: dish_dish_code_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1.dish_dish_code_seq', 100, true);


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 227
-- Name: dish_scoup_volume_ID_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1."dish_scoup_volume_ID_seq"', 1, false);


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 247
-- Name: ingredient_ingredient_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1.ingredient_ingredient_id_seq', 100, true);


--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 241
-- Name: order _order_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1."order _order_id_seq"', 1, false);


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 249
-- Name: order_scoup_order_sc_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1.order_scoup_order_sc_id_seq', 1, false);


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 235
-- Name: passport_passport_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1.passport_passport_id_seq', 1, false);


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 245
-- Name: pinned_table_pinning_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1.pinned_table_pinning_id_seq', 1, false);


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 233
-- Name: position_position_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1.position_position_id_seq', 100, true);


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 243
-- Name: shift _shift_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1."shift _shift_id_seq"', 1, false);


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 217
-- Name: shipments_shipment_ID_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1."shipments_shipment_ID_seq"', 100, true);


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 223
-- Name: storage_scoup_rest_ID_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1."storage_scoup_rest_ID_seq"', 1, false);


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 221
-- Name: storgage_ store_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1."storgage_ store_id_seq"', 3, true);


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 239
-- Name: table_unit_table_id_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1.table_unit_table_id_seq', 1, false);


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 229
-- Name: worker_worker_ID_seq; Type: SEQUENCE SET; Schema: v1; Owner: -
--

SELECT pg_catalog.setval('v1."worker_worker_ID_seq"', 100, true);


--
-- TOC entry 4902 (class 2606 OID 16558)
-- Name: career_log career_log_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.career_log
    ADD CONSTRAINT career_log_pkey PRIMARY KEY (note_id);


--
-- TOC entry 4869 (class 2606 OID 16424)
-- Name: provider check_id_unique; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.provider
    ADD CONSTRAINT check_id_unique PRIMARY KEY (provider_id);


--
-- TOC entry 4846 (class 2606 OID 24717)
-- Name: batch chk_batch_status; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.batch
    ADD CONSTRAINT chk_batch_status CHECK (((batch_status)::text = ANY ((ARRAY['Available'::character varying, 'Quarantine'::character varying, 'Reserved'::character varying, 'Expired'::character varying, 'Depleted'::character varying, 'Written_Off'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4857 (class 2606 OID 24739)
-- Name: category chk_category_name; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.category
    ADD CONSTRAINT chk_category_name CHECK (((category_name)::text = ANY ((ARRAY['Kitchen'::character varying, 'Floor'::character varying, 'Management'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4852 (class 2606 OID 24670)
-- Name: dish chk_dish_ccal; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.dish
    ADD CONSTRAINT chk_dish_ccal CHECK ((dish_ccal > 0)) NOT VALID;


--
-- TOC entry 4853 (class 2606 OID 24671)
-- Name: dish chk_dish_price; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.dish
    ADD CONSTRAINT chk_dish_price CHECK ((dish_price > (0)::numeric)) NOT VALID;


--
-- TOC entry 4865 (class 2606 OID 24802)
-- Name: ingredient chk_ingr_ckal; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.ingredient
    ADD CONSTRAINT chk_ingr_ckal CHECK (((ingr_ccal > 0) AND (ingr_proteins > (0)::numeric) AND (ingr_fats > (0)::numeric) AND (ingr_carb > (0)::numeric))) NOT VALID;


--
-- TOC entry 4866 (class 2606 OID 24801)
-- Name: ingredient chk_ingr_min_qty ; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.ingredient
    ADD CONSTRAINT "chk_ingr_min_qty " CHECK ((ingr_min_qty > (0)::numeric)) NOT VALID;


--
-- TOC entry 4847 (class 2606 OID 24818)
-- Name: batch chk_ingr_vol; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.batch
    ADD CONSTRAINT chk_ingr_vol CHECK ((ingr_unit_vol > (0)::numeric)) NOT VALID;


--
-- TOC entry 4854 (class 2606 OID 24839)
-- Name: dish_scoup chk_ingr_vol; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.dish_scoup
    ADD CONSTRAINT chk_ingr_vol CHECK ((ingr_vol > (0)::numeric)) NOT VALID;


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 4854
-- Name: CONSTRAINT chk_ingr_vol ON dish_scoup; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON CONSTRAINT chk_ingr_vol ON v1.dish_scoup IS 'checking the positive value of the ingredient volume in the dish';


--
-- TOC entry 4861 (class 2606 OID 24682)
-- Name: order chk_order_status; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1."order"
    ADD CONSTRAINT chk_order_status CHECK (((order_status)::text = ANY ((ARRAY['Pending'::character varying, 'Confirmed'::character varying, 'Served'::character varying, 'Paid'::character varying, 'Cancelled'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4844 (class 2606 OID 24817)
-- Name: shipment chk_ship_total_cost; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.shipment
    ADD CONSTRAINT chk_ship_total_cost CHECK ((ship_total_cost >= (0)::numeric)) NOT VALID;


--
-- TOC entry 4845 (class 2606 OID 24718)
-- Name: shipment chk_shipment_status; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.shipment
    ADD CONSTRAINT chk_shipment_status CHECK (((ship_status)::text = ANY ((ARRAY['Ordered'::character varying, 'In_Transit'::character varying, 'Arrived'::character varying, 'Accepted'::character varying, 'Disputed'::character varying, 'Returned'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4849 (class 2606 OID 24822)
-- Name: storage_scoup chk_st_sc_curr_qty; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.storage_scoup
    ADD CONSTRAINT chk_st_sc_curr_qty CHECK ((st_sc_curr_qty >= (0)::numeric)) NOT VALID;


--
-- TOC entry 4850 (class 2606 OID 24823)
-- Name: storage_scoup chk_st_sc_min_qty; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.storage_scoup
    ADD CONSTRAINT chk_st_sc_min_qty CHECK ((st_sc_min_qty >= (0)::numeric)) NOT VALID;


--
-- TOC entry 4851 (class 2606 OID 24783)
-- Name: storage_scoup chk_st_scoup_status; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.storage_scoup
    ADD CONSTRAINT chk_st_scoup_status CHECK (((st_sc_status)::text = ANY ((ARRAY['available'::character varying, 'reserved'::character varying, 'expired'::character varying, 'damaged'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4848 (class 2606 OID 24721)
-- Name: storage chk_storage_type; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.storage
    ADD CONSTRAINT chk_storage_type CHECK (((stor_type)::text = ANY (ARRAY[('Dry'::character varying)::text, ('Cold'::character varying)::text, ('Ambient'::character varying)::text]))) NOT VALID;


--
-- TOC entry 4855 (class 2606 OID 24748)
-- Name: worker chk_worker_email; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.worker
    ADD CONSTRAINT chk_worker_email CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text)) NOT VALID;


--
-- TOC entry 4856 (class 2606 OID 24747)
-- Name: worker chk_worker_phone; Type: CHECK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE v1.worker
    ADD CONSTRAINT chk_worker_phone CHECK (((phone_number)::text ~ '^\+?[0-9]{10,15}$'::text)) NOT VALID;


--
-- TOC entry 4910 (class 2606 OID 24634)
-- Name: pinned_table pinned_table_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.pinned_table
    ADD CONSTRAINT pinned_table_pkey PRIMARY KEY (pinning_id);


--
-- TOC entry 4876 (class 2606 OID 16458)
-- Name: batch pk_batch; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.batch
    ADD CONSTRAINT pk_batch PRIMARY KEY (batch_id);


--
-- TOC entry 4894 (class 2606 OID 16526)
-- Name: category pk_category; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.category
    ADD CONSTRAINT pk_category PRIMARY KEY (category_id);


--
-- TOC entry 4884 (class 2606 OID 16491)
-- Name: dish pk_dish; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish
    ADD CONSTRAINT pk_dish PRIMARY KEY (dish_id);


--
-- TOC entry 4886 (class 2606 OID 16498)
-- Name: dish_scoup pk_dish_scoup; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_scoup
    ADD CONSTRAINT pk_dish_scoup PRIMARY KEY (dish_sc_id);


--
-- TOC entry 4912 (class 2606 OID 24668)
-- Name: ingredient pk_ingredient; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.ingredient
    ADD CONSTRAINT pk_ingredient PRIMARY KEY (ingredient_id);


--
-- TOC entry 4906 (class 2606 OID 24606)
-- Name: order pk_order; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."order"
    ADD CONSTRAINT pk_order PRIMARY KEY (order_id);


--
-- TOC entry 4916 (class 2606 OID 24689)
-- Name: order_scoup pk_order_scoup; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.order_scoup
    ADD CONSTRAINT pk_order_scoup PRIMARY KEY (order_sc_id);


--
-- TOC entry 4900 (class 2606 OID 24850)
-- Name: passport pk_passport; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.passport
    ADD CONSTRAINT pk_passport PRIMARY KEY (passport_id);


--
-- TOC entry 4898 (class 2606 OID 16535)
-- Name: position pk_position; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."position"
    ADD CONSTRAINT pk_position PRIMARY KEY (position_id);


--
-- TOC entry 4872 (class 2606 OID 16443)
-- Name: shipment pk_shipment; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shipment
    ADD CONSTRAINT pk_shipment PRIMARY KEY (shipment_id);


--
-- TOC entry 4878 (class 2606 OID 16471)
-- Name: storage pk_storage; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage
    ADD CONSTRAINT pk_storage PRIMARY KEY (" storage_id");


--
-- TOC entry 4880 (class 2606 OID 16482)
-- Name: storage_scoup pk_storage_scoup; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup
    ADD CONSTRAINT pk_storage_scoup PRIMARY KEY (st_scoup_id);


--
-- TOC entry 4904 (class 2606 OID 24597)
-- Name: table_unit pk_table_unit; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.table_unit
    ADD CONSTRAINT pk_table_unit PRIMARY KEY (table_id);


--
-- TOC entry 4908 (class 2606 OID 24626)
-- Name: shift  shift _pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."shift "
    ADD CONSTRAINT "shift _pkey" PRIMARY KEY (shift_id);


--
-- TOC entry 4874 (class 2606 OID 16445)
-- Name: shipment shipments_shipment_ID_shipment_ID1_key; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shipment
    ADD CONSTRAINT "shipments_shipment_ID_shipment_ID1_key" UNIQUE (shipment_id) INCLUDE (shipment_id);


--
-- TOC entry 4882 (class 2606 OID 24820)
-- Name: storage_scoup uq_batch_in_storage; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup
    ADD CONSTRAINT uq_batch_in_storage UNIQUE (batch_id, storage_id);


--
-- TOC entry 4896 (class 2606 OID 24750)
-- Name: category uq_category_name; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.category
    ADD CONSTRAINT uq_category_name UNIQUE (category_name);


--
-- TOC entry 4888 (class 2606 OID 24842)
-- Name: worker uq_email_and_phone; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker
    ADD CONSTRAINT uq_email_and_phone UNIQUE (phone_number, email);


--
-- TOC entry 4914 (class 2606 OID 24825)
-- Name: ingredient uq_ingr_name; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.ingredient
    ADD CONSTRAINT uq_ingr_name UNIQUE (ingr_name);


--
-- TOC entry 4890 (class 2606 OID 16508)
-- Name: worker uq_timesheet_num; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker
    ADD CONSTRAINT uq_timesheet_num UNIQUE (timesheet_num);


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 4890
-- Name: CONSTRAINT uq_timesheet_num ON worker; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON CONSTRAINT uq_timesheet_num ON v1.worker IS 'checking for the uniqueness of the service number';


--
-- TOC entry 4892 (class 2606 OID 16506)
-- Name: worker worker_pkey; Type: CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker
    ADD CONSTRAINT worker_pkey PRIMARY KEY (worker_id);


--
-- TOC entry 4870 (class 1259 OID 16451)
-- Name: fki_provider_ID; Type: INDEX; Schema: v1; Owner: -
--

CREATE INDEX "fki_provider_ID" ON v1.shipment USING btree (provider_id);


--
-- TOC entry 4920 (class 2606 OID 24771)
-- Name: storage_scoup fk_batch; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup
    ADD CONSTRAINT fk_batch FOREIGN KEY (batch_id) REFERENCES v1.batch(batch_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4925 (class 2606 OID 24756)
-- Name: position fk_category; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."position"
    ADD CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES v1.category(category_id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4932 (class 2606 OID 24690)
-- Name: order_scoup fk_chef; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.order_scoup
    ADD CONSTRAINT fk_chef FOREIGN KEY (chef_id) REFERENCES v1.worker(worker_id);


--
-- TOC entry 4922 (class 2606 OID 24655)
-- Name: dish_scoup fk_dish; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_scoup
    ADD CONSTRAINT fk_dish FOREIGN KEY (dish_id) REFERENCES v1.dish(dish_id) NOT VALID;


--
-- TOC entry 4933 (class 2606 OID 24695)
-- Name: order_scoup fk_dish; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.order_scoup
    ADD CONSTRAINT fk_dish FOREIGN KEY (dish_id) REFERENCES v1.dish(dish_id);


--
-- TOC entry 4918 (class 2606 OID 24712)
-- Name: batch fk_ingr; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.batch
    ADD CONSTRAINT fk_ingr FOREIGN KEY (ingr_id) REFERENCES v1.ingredient(ingredient_id) NOT VALID;


--
-- TOC entry 4923 (class 2606 OID 24677)
-- Name: dish_scoup fk_ingredient; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_scoup
    ADD CONSTRAINT fk_ingredient FOREIGN KEY (ingr_id) REFERENCES v1.ingredient(ingredient_id) NOT VALID;


--
-- TOC entry 4934 (class 2606 OID 24700)
-- Name: order_scoup fk_order; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.order_scoup
    ADD CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES v1."order"(order_id);


--
-- TOC entry 4928 (class 2606 OID 24650)
-- Name: order fk_order_table; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."order"
    ADD CONSTRAINT fk_order_table FOREIGN KEY (order_p_table) REFERENCES v1.pinned_table(pinning_id) NOT VALID;


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 4928
-- Name: CONSTRAINT fk_order_table ON "order"; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON CONSTRAINT fk_order_table ON v1."order" IS 'table which pinned by the waiter ';


--
-- TOC entry 4924 (class 2606 OID 24742)
-- Name: worker fk_position; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker
    ADD CONSTRAINT fk_position FOREIGN KEY (position_id) REFERENCES v1."position"(position_id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4917 (class 2606 OID 24761)
-- Name: shipment fk_provider; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shipment
    ADD CONSTRAINT fk_provider FOREIGN KEY (provider_id) REFERENCES v1.provider(provider_id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4929 (class 2606 OID 24640)
-- Name: pinned_table fk_shift; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.pinned_table
    ADD CONSTRAINT fk_shift FOREIGN KEY (shift_id) REFERENCES v1."shift "(shift_id) NOT VALID;


--
-- TOC entry 4919 (class 2606 OID 24766)
-- Name: batch fk_shipment; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.batch
    ADD CONSTRAINT fk_shipment FOREIGN KEY (shipment_id) REFERENCES v1.shipment(shipment_id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4921 (class 2606 OID 24776)
-- Name: storage_scoup fk_storage; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup
    ADD CONSTRAINT fk_storage FOREIGN KEY (storage_id) REFERENCES v1.storage(" storage_id") ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 4930 (class 2606 OID 24645)
-- Name: pinned_table fk_table; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.pinned_table
    ADD CONSTRAINT fk_table FOREIGN KEY (table_id) REFERENCES v1.table_unit(table_id) NOT VALID;


--
-- TOC entry 4931 (class 2606 OID 24635)
-- Name: pinned_table fk_waiter; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.pinned_table
    ADD CONSTRAINT fk_waiter FOREIGN KEY (waiter_id) REFERENCES v1.worker(worker_id);


--
-- TOC entry 4927 (class 2606 OID 24751)
-- Name: career_log fk_worker; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.career_log
    ADD CONSTRAINT fk_worker FOREIGN KEY (worker_id) REFERENCES v1.worker(worker_id) ON DELETE SET NULL NOT VALID;


--
-- TOC entry 4926 (class 2606 OID 16547)
-- Name: passport fk_worker; Type: FK CONSTRAINT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.passport
    ADD CONSTRAINT fk_worker FOREIGN KEY (worker_id) REFERENCES v1.worker(worker_id);


-- Completed on 2026-03-30 22:52:50

--
-- PostgreSQL database dump complete
--

\unrestrict 0C7lvSw4fbhKnWhZmKhxJxU3KdWetIK8WygRzVRgdWM5GQnIatl1Unexd7hleTI

