--
-- PostgreSQL database dump
--

\restrict KWH2JgEzWvgKgomtYdFxXksWiY5F0ae0eAWxelOLxsjBpjHs2gAVGdwPn5apxvC

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

-- Started on 2026-05-09 01:43:22

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

DROP DATABASE "CloudMonet";
--
-- TOC entry 5203 (class 1262 OID 16417)
-- Name: CloudMonet; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE "CloudMonet" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


\unrestrict KWH2JgEzWvgKgomtYdFxXksWiY5F0ae0eAWxelOLxsjBpjHs2gAVGdwPn5apxvC
\connect "CloudMonet"
\restrict KWH2JgEzWvgKgomtYdFxXksWiY5F0ae0eAWxelOLxsjBpjHs2gAVGdwPn5apxvC

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
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 5203
-- Name: DATABASE "CloudMonet"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE "CloudMonet" IS 'бд для обслуживания клиентов ресторана';


--
-- TOC entry 6 (class 2615 OID 16418)
-- Name: v1; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA v1;


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA v1; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA v1 IS 'первая версия бд ';


--
-- TOC entry 976 (class 1247 OID 34182)
-- Name: batch_status_enum; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.batch_status_enum AS ENUM (
    'Available',
    'Quarantine',
    'Reserved',
    'Expired',
    'Depleted',
    'Written_Off'
);


--
-- TOC entry 967 (class 1247 OID 34058)
-- Name: measure_unit; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.measure_unit AS ENUM (
    'кг',
    'л',
    'шт',
    'г',
    'мл',
    'упак'
);


--
-- TOC entry 979 (class 1247 OID 34229)
-- Name: order_item_status; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.order_item_status AS ENUM (
    'Pending',
    'Cooking',
    'Ready',
    'Served',
    'Returned',
    'Cancelled'
);


--
-- TOC entry 964 (class 1247 OID 34022)
-- Name: shift_type; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.shift_type AS ENUM (
    'Day',
    'Night'
);


--
-- TOC entry 973 (class 1247 OID 34140)
-- Name: shipment_status; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.shipment_status AS ENUM (
    'Ordered',
    'In_Transit',
    'Arrived',
    'Accepted',
    'Disputed',
    'Returned'
);


--
-- TOC entry 970 (class 1247 OID 34089)
-- Name: storage_type; Type: TYPE; Schema: v1; Owner: -
--

CREATE TYPE v1.storage_type AS ENUM (
    'Сухой склад',
    'Холодильник',
    'Морозилка',
    'Барная стойка',
    'Овощной цех'
);


--
-- TOC entry 275 (class 1255 OID 34243)
-- Name: fn_refresh_ingredient_cost(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.fn_refresh_ingredient_cost() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Обновляем цену ингредиента, который был затронут (добавлен, изменен или удален в складе)
    UPDATE v1.ingredient
    SET current_unit_cost = (
        SELECT b.ingr_unit_cost
        FROM v1.batch b
        JOIN v1.storage_scoup ss ON b.batch_id = ss.batch_id
        WHERE b.ingr_id = COALESCE(NEW.ingr_id, OLD.ingr_id) -- Обработка INSERT/UPDATE/DELETE
          AND ss.amount > 0             -- Берем только те, где остаток не нулевой
          AND b.batch_exp_data > NOW()  -- Только не просроченные
        ORDER BY b.batch_exp_data ASC   -- Принцип FEFO: берем ту, что сгниет первой
        LIMIT 1
    )
    WHERE ingr_id = COALESCE(NEW.ingr_id, OLD.ingr_id);

    RETURN NULL; -- Для AFTER-триггера возвращаемое значение не важно
END;
$$;


--
-- TOC entry 274 (class 1255 OID 32947)
-- Name: trg_check_med_book_on_shift(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_check_med_book_on_shift() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Проверяем, есть ли у работника действующая и АКТИВНАЯ медкнижка
    IF NOT EXISTS (
        SELECT 1 FROM v1.med_book
        WHERE worker_id = NEW.worker_id
          AND is_active = true  -- Вот тут мы поменяли имя
          AND expires_date >= CURRENT_DATE
    ) THEN
        RAISE EXCEPTION 'Работник % не может быть назначен на смену: отсутствует действующая или активная медицинская книжка.', NEW.worker_id
        USING ERRCODE = 'P0001';
    END IF;

    RETURN NEW;
END;
$$;


--
-- TOC entry 261 (class 1255 OID 32906)
-- Name: trg_check_waiter_on_shift(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_check_waiter_on_shift() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM v1.worker_shift
        WHERE worker_id = NEW.waiter_id
          AND shift_id  = NEW.shift_id
    ) THEN
        RAISE EXCEPTION
            'Официант % не числится на смене %. '
            'Сначала добавьте его в worker_shift.',
            NEW.waiter_id, NEW.shift_id;
    END IF;
    RETURN NEW;
END;
$$;


--
-- TOC entry 273 (class 1255 OID 33987)
-- Name: trg_enforce_single_active_record(); Type: FUNCTION; Schema: v1; Owner: -
--

CREATE FUNCTION v1.trg_enforce_single_active_record() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    active_count INT;
BEGIN
    -- Считаем, сколько уже есть активных записей для этого работника
    -- Исключаем саму текущую строку (при обновлении), чтобы не считать её саму
    SELECT COUNT(*) 
    INTO active_count
    FROM v1.med_book 
    WHERE worker_id = NEW.worker_id 
      AND is_active = true
      AND (TG_OP = 'INSERT' OR med_book_id != OLD.med_book_id);

    -- Если мы пытаемся вставить/обновить запись как активную (true)
    -- Но счетчик уже показал, что такая запись есть
    IF NEW.is_active = true AND active_count >= 1 THEN
        -- Вместо ошибки мы просто принудительно ставим false
        NEW.is_active := false;
        
        -- (Опционально) Можно вывести уведомление в консоль
        RAISE NOTICE 'У работника % уже есть активная запись. Новая запись сохранена как неактивная.', NEW.worker_id;
    END IF;

    RETURN NEW;
END;
$$;


SET default_tablespace = '';

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
    batch_status v1.batch_status_enum NOT NULL,
    batch_exp_data date NOT NULL,
    ingr_unit_vol numeric(12,3) NOT NULL,
    total_batch_cost numeric(19,4) GENERATED ALWAYS AS ((ingr_unit_cost * ingr_count)) STORED
);


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE batch; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.batch IS 'a batch of a specific ingredient in a supply that stores information about its status for subsequent distribution to storages';


--
-- TOC entry 5207 (class 0 OID 0)
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
-- TOC entry 5208 (class 0 OID 0)
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
-- TOC entry 5209 (class 0 OID 0)
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
    requires_med_book boolean DEFAULT false,
    has_storage_access boolean DEFAULT false,
    dress_code character varying(100)
);


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE category; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.category IS 'restaurant responsibility area: Kitchen, Floor, Management';


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN category.requires_med_book; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.category.requires_med_book IS 'Все сотрудники этой категории обязаны иметь действующую медкнижку.';


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN category.has_storage_access; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.category.has_storage_access IS 'Сотрудники категории имеют право на списание со склада (storage_scoup).';


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 232
-- Name: COLUMN category.dress_code; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.category.dress_code IS 'Требования к форме одежды для категории. NULL = свободный стиль.';


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
-- TOC entry 5214 (class 0 OID 0)
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
-- TOC entry 5215 (class 0 OID 0)
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
    dish_weight numeric(8,2) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    category_id integer NOT NULL
);


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE dish; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.dish IS 'general information about the dish: calculated weight and calories, name, and fixed price at the current moment according to the restaurant''s standards';


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN dish.dish_weight; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.dish.dish_weight IS 'Расчётный вес блюда в граммах согласно стандарту ресторана.';


--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 226
-- Name: COLUMN dish.is_active; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.dish.is_active IS 'dish in actal menu';


--
-- TOC entry 252 (class 1259 OID 32815)
-- Name: dish_category; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.dish_category (
    category_id integer NOT NULL,
    category_name character varying(30) NOT NULL
);


--
-- TOC entry 251 (class 1259 OID 32814)
-- Name: dish_category_category_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.dish_category_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 251
-- Name: dish_category_category_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.dish_category_category_id_seq OWNED BY v1.dish_category.category_id;


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
-- TOC entry 5220 (class 0 OID 0)
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
    ingr_vol numeric(12,3) NOT NULL
);


--
-- TOC entry 5221 (class 0 OID 0)
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
-- TOC entry 5222 (class 0 OID 0)
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
    ingr_unit v1.measure_unit NOT NULL,
    ingr_proteins numeric(8,2) NOT NULL,
    ingr_fats numeric(8,2) NOT NULL,
    ingr_carb numeric(8,2) NOT NULL,
    ingr_storage_req v1.storage_type NOT NULL,
    ingr_ccal integer NOT NULL,
    ingr_min_qty numeric(10,3) NOT NULL,
    ingr_name character varying(100) NOT NULL
);


--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE ingredient; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.ingredient IS 'general information about the ingredient: kcal - according to the restaurant''s standards, the unit of measurement';


--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 248
-- Name: COLUMN ingredient.ingr_unit; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.ingredient.ingr_unit IS 'the unit of measurement for an ingredient according to the standard for calculating the cost in the menu';


--
-- TOC entry 5225 (class 0 OID 0)
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
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 247
-- Name: ingredient_ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.ingredient_ingredient_id_seq OWNED BY v1.ingredient.ingredient_id;


--
-- TOC entry 258 (class 1259 OID 32930)
-- Name: med_book; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.med_book (
    med_book_id integer NOT NULL,
    worker_id integer NOT NULL,
    issued_date date NOT NULL,
    expires_date date NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    notes text,
    CONSTRAINT chk_med_book_dates CHECK ((expires_date > issued_date))
);


--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 258
-- Name: TABLE med_book; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.med_book IS 'История медицинских книжек сотрудников. Актуальная — последняя запись с is_valid = true.';


--
-- TOC entry 257 (class 1259 OID 32929)
-- Name: med_book_med_book_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.med_book_med_book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 257
-- Name: med_book_med_book_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.med_book_med_book_id_seq OWNED BY v1.med_book.med_book_id;


--
-- TOC entry 242 (class 1259 OID 24599)
-- Name: order; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1."order" (
    order_id integer NOT NULL,
    order_status character varying(9) DEFAULT 'Open'::character varying NOT NULL,
    order_from_table integer NOT NULL,
    order_wishes character varying(300),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    closed_at time with time zone
);


--
-- TOC entry 241 (class 1259 OID 24598)
-- Name: order_order_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.order_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 241
-- Name: order_order_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.order_order_id_seq OWNED BY v1."order".order_id;


--
-- TOC entry 250 (class 1259 OID 24684)
-- Name: order_scoup; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.order_scoup (
    order_sc_id integer NOT NULL,
    chef_id integer NOT NULL,
    order_id integer NOT NULL,
    dish_id integer NOT NULL,
    dish_price_snapshot numeric(19,4) NOT NULL,
    dish_count integer NOT NULL,
    dish_wishes character varying(300),
    row_total numeric(19,4) GENERATED ALWAYS AS ((dish_price_snapshot * (dish_count)::numeric)) STORED,
    status v1.order_item_status DEFAULT 'Pending'::v1.order_item_status NOT NULL
);


--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 250
-- Name: COLUMN order_scoup.dish_price_snapshot; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.order_scoup.dish_price_snapshot IS 'Цена блюда на момент оформления заказа (снимок из dish.dish_price). Намеренно денормализована для исторической точности.';


--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 250
-- Name: COLUMN order_scoup.status; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.order_scoup.status IS 'Текущий статус позиции в заказе: от ожидания до подачи или возврата';


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
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 249
-- Name: order_scoup_order_sc_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.order_scoup_order_sc_id_seq OWNED BY v1.order_scoup.order_sc_id;


--
-- TOC entry 255 (class 1259 OID 32885)
-- Name: order_with_total; Type: VIEW; Schema: v1; Owner: -
--

CREATE VIEW v1.order_with_total AS
 SELECT o.order_id,
    o.order_status,
    o.order_from_table AS order_p_table,
    o.order_wishes AS order_notes,
    o.created_at,
    COALESCE(sum(os.row_total), (0)::numeric) AS order_total
   FROM (v1."order" o
     LEFT JOIN v1.order_scoup os ON ((os.order_id = o.order_id)))
  GROUP BY o.order_id, o.order_status, o.order_from_table, o.order_wishes, o.created_at;


--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 255
-- Name: VIEW order_with_total; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON VIEW v1.order_with_total IS 'Заказы с актуальной суммой, вычисляемой из order_scoup.row_total.';


--
-- TOC entry 236 (class 1259 OID 16543)
-- Name: passport; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.passport (
    passport_id integer NOT NULL,
    worker_id integer,
    passport_num character varying(15) NOT NULL,
    passport_series character varying(10) NOT NULL,
    issued_by character varying(300),
    issued_date character varying(15),
    department_code character varying(10),
    registartion_address character varying(500),
    passport_status character varying(11),
    CONSTRAINT chk_passport_status CHECK (((passport_status)::text = ANY ((ARRAY['Active'::character varying, 'Expired'::character varying, 'Lost'::character varying])::text[])))
);


--
-- TOC entry 5234 (class 0 OID 0)
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
-- TOC entry 5235 (class 0 OID 0)
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
    pinning_status character varying(8) NOT NULL,
    table_id integer NOT NULL,
    ws_id integer NOT NULL,
    pinned_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_pin_table_status CHECK (((pinning_status)::text = ANY ((ARRAY['waiting'::character varying, 'active'::character varying, 'serviced'::character varying])::text[])))
);


--
-- TOC entry 5236 (class 0 OID 0)
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
-- TOC entry 5237 (class 0 OID 0)
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
-- TOC entry 5238 (class 0 OID 0)
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
-- TOC entry 5239 (class 0 OID 0)
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
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE provider; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.provider IS 'минимальная информация о поставщиках ингредиентов: наименование организации, телефонный номер, идентификатор';


--
-- TOC entry 244 (class 1259 OID 24619)
-- Name: shift; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.shift (
    shift_id integer NOT NULL,
    shift_status character varying(11) NOT NULL,
    shift_type v1.shift_type NOT NULL,
    shift_start timestamp with time zone NOT NULL,
    shift_end timestamp with time zone NOT NULL
);


--
-- TOC entry 243 (class 1259 OID 24618)
-- Name: shift_shift_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.shift_shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 243
-- Name: shift_shift_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.shift_shift_id_seq OWNED BY v1.shift.shift_id;


--
-- TOC entry 218 (class 1259 OID 16436)
-- Name: shipment; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.shipment (
    shipment_id integer NOT NULL,
    ship_date date DEFAULT now() NOT NULL,
    ship_status v1.shipment_status NOT NULL,
    ship_total_cost numeric(19,4) NOT NULL,
    provider_id integer NOT NULL
);


--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE shipment; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.shipment IS 'поставки';


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN shipment.ship_total_cost; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.shipment.ship_total_cost IS 'Итоговая стоимость поставки согласно накладной. Фиксируется на момент приёмки и может отличаться от SUM(batch.total_batch_cost) при частичных поставках.';


--
-- TOC entry 256 (class 1259 OID 32890)
-- Name: shipment_cost_check; Type: VIEW; Schema: v1; Owner: -
--

CREATE VIEW v1.shipment_cost_check AS
 SELECT s.shipment_id,
    s.ship_total_cost AS declared_cost,
    COALESCE(sum(b.total_batch_cost), (0)::numeric) AS computed_cost,
    (s.ship_total_cost - COALESCE(sum(b.total_batch_cost), (0)::numeric)) AS delta
   FROM (v1.shipment s
     LEFT JOIN v1.batch b ON ((b.shipment_id = s.shipment_id)))
  GROUP BY s.shipment_id, s.ship_total_cost;


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 256
-- Name: VIEW shipment_cost_check; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON VIEW v1.shipment_cost_check IS 'Контроль расхождений между заявленной и фактической стоимостью поставки.';


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
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 217
-- Name: shipments_shipment_ID_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."shipments_shipment_ID_seq" OWNED BY v1.shipment.shipment_id;


--
-- TOC entry 222 (class 1259 OID 16465)
-- Name: storage; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.storage (
    storage_id integer NOT NULL,
    stor_address character varying(100) NOT NULL,
    stor_type v1.storage_type NOT NULL
);


--
-- TOC entry 5246 (class 0 OID 0)
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
    st_sc_curr_qty numeric(12,3) NOT NULL
);


--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE storage_scoup; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.storage_scoup IS 'Состав склада — ингредиенты. Минимальный остаток берётся из ingredient.ingr_min_qty.';


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
-- TOC entry 5248 (class 0 OID 0)
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
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 221
-- Name: storgage_ store_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."storgage_ store_id_seq" OWNED BY v1.storage.storage_id;


--
-- TOC entry 240 (class 1259 OID 24591)
-- Name: table_unit; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.table_unit (
    table_id integer NOT NULL,
    table_status character varying(12) NOT NULL,
    table_code integer NOT NULL,
    CONSTRAINT chk_table_status CHECK (((table_status)::text = ANY ((ARRAY['Free'::character varying, 'Occupied'::character varying, 'Booked'::character varying, 'Out_of_Order'::character varying])::text[])))
);


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN table_unit.table_code; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.table_unit.table_code IS 'реальный номер стола в зале ';


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
-- TOC entry 5251 (class 0 OID 0)
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
    phone character varying(15) NOT NULL,
    email character varying NOT NULL
);


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE worker; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.worker IS 'сотрудники двух возможных категорий: повар и официант ';


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 230
-- Name: COLUMN worker.is_active; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker.is_active IS 'Is the person currently working in the specified position?';


--
-- TOC entry 254 (class 1259 OID 32844)
-- Name: worker_shift; Type: TABLE; Schema: v1; Owner: -
--

CREATE TABLE v1.worker_shift (
    ws_id integer NOT NULL,
    worker_id integer NOT NULL,
    shift_id integer NOT NULL,
    checked_in boolean DEFAULT false NOT NULL,
    position_in_shift integer
);


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE worker_shift; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON TABLE v1.worker_shift IS 'Связующая таблица: какой сотрудник работает на какой смене (M:M)';


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 254
-- Name: COLUMN worker_shift.checked_in; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON COLUMN v1.worker_shift.checked_in IS 'Факт явки на смену. FALSE = назначен, но ещё не отметился (или не пришёл).';


--
-- TOC entry 260 (class 1259 OID 33995)
-- Name: v_active_staff_shifts; Type: VIEW; Schema: v1; Owner: -
--

CREATE VIEW v1.v_active_staff_shifts AS
 SELECT w.full_name,
    p.position_name,
    s.shift_start
   FROM (((v1.worker w
     JOIN v1."position" p ON ((w.position_id = p.position_id)))
     JOIN v1.worker_shift ws ON ((w.worker_id = ws.worker_id)))
     JOIN v1.shift s ON ((ws.shift_id = s.shift_id)))
  WHERE (((s.shift_status)::text = 'in progress'::text) AND (ws.checked_in = true));


--
-- TOC entry 259 (class 1259 OID 32949)
-- Name: v_med_book_status; Type: VIEW; Schema: v1; Owner: -
--

CREATE VIEW v1.v_med_book_status AS
 SELECT w.worker_id,
    w.full_name,
    c.category_name,
    p.position_name,
    c.requires_med_book,
    mb.med_book_id,
    mb.issued_date,
    mb.expires_date,
    mb.is_valid,
    (mb.expires_date - CURRENT_DATE) AS days_until_expiry,
        CASE
            WHEN (NOT c.requires_med_book) THEN 'не требуется'::text
            WHEN (mb.med_book_id IS NULL) THEN 'отсутствует'::text
            WHEN (mb.expires_date < CURRENT_DATE) THEN 'просрочена'::text
            WHEN ((mb.expires_date - CURRENT_DATE) <= 30) THEN 'истекает скоро'::text
            ELSE 'действующая'::text
        END AS med_book_status
   FROM (((v1.worker w
     JOIN v1."position" p ON ((p.position_id = w.position_id)))
     JOIN v1.category c ON ((c.category_id = p.category_id)))
     LEFT JOIN LATERAL ( SELECT mb2.med_book_id,
            mb2.worker_id,
            mb2.issued_date,
            mb2.expires_date,
            mb2.is_active AS is_valid,
            mb2.notes
           FROM v1.med_book mb2
          WHERE ((mb2.worker_id = w.worker_id) AND (mb2.is_active = true))
          ORDER BY mb2.expires_date DESC
         LIMIT 1) mb ON (true))
  ORDER BY
        CASE
            WHEN (NOT c.requires_med_book) THEN 4
            WHEN (mb.med_book_id IS NULL) THEN 0
            WHEN (mb.expires_date < CURRENT_DATE) THEN 1
            WHEN ((mb.expires_date - CURRENT_DATE) <= 30) THEN 2
            ELSE 3
        END, mb.expires_date;


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 259
-- Name: VIEW v_med_book_status; Type: COMMENT; Schema: v1; Owner: -
--

COMMENT ON VIEW v1.v_med_book_status IS 'Статус медкнижек всех сотрудников. Сортировка: сначала проблемные (отсутствует → просрочена → истекает).';


--
-- TOC entry 253 (class 1259 OID 32843)
-- Name: worker_shift_ws_id_seq; Type: SEQUENCE; Schema: v1; Owner: -
--

CREATE SEQUENCE v1.worker_shift_ws_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 253
-- Name: worker_shift_ws_id_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1.worker_shift_ws_id_seq OWNED BY v1.worker_shift.ws_id;


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
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 229
-- Name: worker_worker_ID_seq; Type: SEQUENCE OWNED BY; Schema: v1; Owner: -
--

ALTER SEQUENCE v1."worker_worker_ID_seq" OWNED BY v1.worker.worker_id;


--
-- TOC entry 4875 (class 2604 OID 16456)
-- Name: batch batch_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.batch ALTER COLUMN batch_id SET DEFAULT nextval('v1.delivery_scoup_batch_num_seq'::regclass);


--
-- TOC entry 4889 (class 2604 OID 16556)
-- Name: career_log note_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.career_log ALTER COLUMN note_id SET DEFAULT nextval('v1.career_log_note_id_seq'::regclass);


--
-- TOC entry 4884 (class 2604 OID 16523)
-- Name: category category_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.category ALTER COLUMN category_id SET DEFAULT nextval('v1.category_id_seq'::regclass);


--
-- TOC entry 4879 (class 2604 OID 16487)
-- Name: dish dish_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish ALTER COLUMN dish_id SET DEFAULT nextval('v1.dish_dish_code_seq'::regclass);


--
-- TOC entry 4902 (class 2604 OID 32818)
-- Name: dish_category category_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_category ALTER COLUMN category_id SET DEFAULT nextval('v1.dish_category_category_id_seq'::regclass);


--
-- TOC entry 4881 (class 2604 OID 16496)
-- Name: dish_scoup dish_sc_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.dish_scoup ALTER COLUMN dish_sc_id SET DEFAULT nextval('v1."dish_scoup_volume_ID_seq"'::regclass);


--
-- TOC entry 4898 (class 2604 OID 24664)
-- Name: ingredient ingredient_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.ingredient ALTER COLUMN ingredient_id SET DEFAULT nextval('v1.ingredient_ingredient_id_seq'::regclass);


--
-- TOC entry 4905 (class 2604 OID 32933)
-- Name: med_book med_book_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.med_book ALTER COLUMN med_book_id SET DEFAULT nextval('v1.med_book_med_book_id_seq'::regclass);


--
-- TOC entry 4892 (class 2604 OID 24602)
-- Name: order order_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."order" ALTER COLUMN order_id SET DEFAULT nextval('v1.order_order_id_seq'::regclass);


--
-- TOC entry 4899 (class 2604 OID 24687)
-- Name: order_scoup order_sc_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.order_scoup ALTER COLUMN order_sc_id SET DEFAULT nextval('v1.order_scoup_order_sc_id_seq'::regclass);


--
-- TOC entry 4888 (class 2604 OID 16546)
-- Name: passport passport_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.passport ALTER COLUMN passport_id SET DEFAULT nextval('v1.passport_passport_id_seq'::regclass);


--
-- TOC entry 4896 (class 2604 OID 24631)
-- Name: pinned_table pinning_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.pinned_table ALTER COLUMN pinning_id SET DEFAULT nextval('v1.pinned_table_pinning_id_seq'::regclass);


--
-- TOC entry 4887 (class 2604 OID 16531)
-- Name: position position_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1."position" ALTER COLUMN position_id SET DEFAULT nextval('v1.position_position_id_seq'::regclass);


--
-- TOC entry 4895 (class 2604 OID 24622)
-- Name: shift shift_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shift ALTER COLUMN shift_id SET DEFAULT nextval('v1.shift_shift_id_seq'::regclass);


--
-- TOC entry 4873 (class 2604 OID 16439)
-- Name: shipment shipment_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.shipment ALTER COLUMN shipment_id SET DEFAULT nextval('v1."shipments_shipment_ID_seq"'::regclass);


--
-- TOC entry 4877 (class 2604 OID 16468)
-- Name: storage storage_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage ALTER COLUMN storage_id SET DEFAULT nextval('v1."storgage_ store_id_seq"'::regclass);


--
-- TOC entry 4878 (class 2604 OID 16476)
-- Name: storage_scoup st_scoup_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.storage_scoup ALTER COLUMN st_scoup_id SET DEFAULT nextval('v1."storage_scoup_rest_ID_seq"'::regclass);


--
-- TOC entry 4891 (class 2604 OID 24594)
-- Name: table_unit table_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.table_unit ALTER COLUMN table_id SET DEFAULT nextval('v1.table_unit_table_id_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 16503)
-- Name: worker worker_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker ALTER COLUMN worker_id SET DEFAULT nextval('v1."worker_worker_ID_seq"'::regclass);


--
-- TOC entry 4903 (class 2604 OID 32847)
-- Name: worker_shift ws_id; Type: DEFAULT; Schema: v1; Owner: -
--

ALTER TABLE ONLY v1.worker_shift ALTER COLUMN ws_id SET DEFAULT nextval('v1.worker_shift_ws_id_seq'::regclass);


-- Completed on 2026-05-09 01:43:23

--
-- PostgreSQL database dump complete
--

\unrestrict KWH2JgEzWvgKgomtYdFxXksWiY5F0ae0eAWxelOLxsjBpjHs2gAVGdwPn5apxvC

