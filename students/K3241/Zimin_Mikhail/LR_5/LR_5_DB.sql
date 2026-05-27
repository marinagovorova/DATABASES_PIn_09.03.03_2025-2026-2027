--
-- PostgreSQL database dump
--

\restrict aiLehgkrFVyAqzbVJi1qcG7wPgGEmxJhcdJvwxVsa8MnC2mZXdtA8M2e3vWXsEe

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.1

-- Started on 2026-05-27 06:40:03

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
-- TOC entry 6 (class 2615 OID 17380)
-- Name: azs; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA azs;


ALTER SCHEMA azs OWNER TO postgres;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: azs_shem; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA azs_shem;


ALTER SCHEMA azs_shem OWNER TO pg_database_owner;

--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA azs_shem; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA azs_shem IS 'standard public schema';


--
-- TOC entry 250 (class 1255 OID 18304)
-- Name: add_klient(character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: azs; Owner: postgres
--

CREATE PROCEDURE azs.add_klient(IN p_fio character varying, IN p_telefon character varying, IN p_tip_klienta character varying, IN p_adres character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO azs.klient (fio, telefon, tip_klienta, adres)
    VALUES (p_fio, p_telefon, p_tip_klienta, p_adres);
    
    RAISE NOTICE 'Клиент % успешно добавлен.', p_fio;
END;
$$;


ALTER PROCEDURE azs.add_klient(IN p_fio character varying, IN p_telefon character varying, IN p_tip_klienta character varying, IN p_adres character varying) OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 18339)
-- Name: fn_audit_prodazha(); Type: FUNCTION; Schema: azs; Owner: postgres
--

CREATE FUNCTION azs.fn_audit_prodazha() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO azs.prodazha_audit 
            (id_prodazhi, kod_topliva, id_karty, 
             summa_do_izmeneniya, summa_posle_izmeneniya, tip_operatsii)
        VALUES (NEW.id_prodazhi, NEW.kod_topliva, NEW.id_karty, 
                0, NEW.summa_spisaniya, 'INSERT');
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO azs.prodazha_audit 
            (id_prodazhi, kod_topliva, id_karty, 
             summa_do_izmeneniya, summa_posle_izmeneniya, tip_operatsii)
        VALUES (NEW.id_prodazhi, NEW.kod_topliva, NEW.id_karty, 
                OLD.summa_spisaniya, NEW.summa_spisaniya, 'UPDATE');
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO azs.prodazha_audit 
            (id_prodazhi, kod_topliva, id_karty, 
             summa_do_izmeneniya, summa_posle_izmeneniya, tip_operatsii)
        VALUES (OLD.id_prodazhi, OLD.kod_topliva, OLD.id_karty, 
                OLD.summa_spisaniya, 0, 'DELETE');
        RETURN OLD;
    END IF;
END;
$$;


ALTER FUNCTION azs.fn_audit_prodazha() OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 18318)
-- Name: fn_check_klient_delete(); Type: FUNCTION; Schema: azs; Owner: postgres
--

CREATE FUNCTION azs.fn_check_klient_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM azs.karta_schet
    WHERE id_klienta = OLD.id_klienta
      AND status_karty = 'Активна';

    IF v_count > 0 THEN
        RAISE EXCEPTION 
            'Нельзя удалить клиента ID %. У него % активных карт.', 
            OLD.id_klienta, v_count;
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION azs.fn_check_klient_delete() OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 18326)
-- Name: fn_check_kolichestvo_topliva(); Type: FUNCTION; Schema: azs; Owner: postgres
--

CREATE FUNCTION azs.fn_check_kolichestvo_topliva() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.kolichestvo_topliva <= 0 THEN
        RAISE EXCEPTION 
            'Количество топлива должно быть положительным. Получено: %', 
            NEW.kolichestvo_topliva;
    END IF;

    IF NEW.summa_spisaniya <= 0 THEN
        RAISE EXCEPTION 
            'Сумма списания должна быть положительной. Получено: %', 
            NEW.summa_spisaniya;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION azs.fn_check_kolichestvo_topliva() OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 18322)
-- Name: fn_check_prodazha_summa(); Type: FUNCTION; Schema: azs; Owner: postgres
--

CREATE FUNCTION azs.fn_check_prodazha_summa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_balance INTEGER;
BEGIN
    SELECT summa_na_schete INTO v_balance
    FROM azs.karta_schet
    WHERE id_karty = NEW.id_karty;

    IF v_balance < NEW.summa_spisaniya THEN
        RAISE EXCEPTION 
            'Недостаточно средств на карте ID %. Баланс: %, Сумма списания: %',
            NEW.id_karty, v_balance, NEW.summa_spisaniya;
    END IF;

    NEW.ostatok_posle_operatsii := v_balance - NEW.summa_spisaniya;

    RETURN NEW;
END;
$$;


ALTER FUNCTION azs.fn_check_prodazha_summa() OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 18324)
-- Name: fn_log_klient_changes(); Type: FUNCTION; Schema: azs; Owner: postgres
--

CREATE FUNCTION azs.fn_log_klient_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_description TEXT;
BEGIN
    IF TG_OP = 'INSERT' THEN
        v_description := 'Добавлен новый клиент: ' || NEW.fio;
        INSERT INTO azs.audit_log 
            (table_name, operation, record_id, description)
        VALUES ('klient', 'INSERT', NEW.id_klienta, v_description);
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        v_description := 'Обновлён клиент ID ' || OLD.id_klienta 
                      || ': [' || OLD.fio || '] -> [' || NEW.fio || ']';
        INSERT INTO azs.audit_log 
            (table_name, operation, record_id, description)
        VALUES ('klient', 'UPDATE', NEW.id_klienta, v_description);
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_description := 'Удалён клиент: ' || OLD.fio;
        INSERT INTO azs.audit_log 
            (table_name, operation, record_id, description)
        VALUES ('klient', 'DELETE', OLD.id_klienta, v_description);
        RETURN OLD;
    END IF;
END;
$$;


ALTER FUNCTION azs.fn_log_klient_changes() OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 18328)
-- Name: fn_set_karta_expiry(); Type: FUNCTION; Schema: azs; Owner: postgres
--

CREATE FUNCTION azs.fn_set_karta_expiry() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.data_okonchaniya IS NULL THEN
        NEW.data_okonchaniya := NEW.data_nachala + INTERVAL '3 years';
        RAISE NOTICE 'Дата окончания карты установлена автоматически: %', 
                     NEW.data_okonchaniya;
    END IF;

    IF NEW.data_okonchaniya <= NEW.data_nachala THEN
        RAISE EXCEPTION 
            'Дата окончания карты (%) должна быть позже даты начала (%).',
            NEW.data_okonchaniya, NEW.data_nachala;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION azs.fn_set_karta_expiry() OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 18320)
-- Name: fn_update_balance_after_prodazha(); Type: FUNCTION; Schema: azs; Owner: postgres
--

CREATE FUNCTION azs.fn_update_balance_after_prodazha() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE azs.karta_schet
    SET summa_na_schete = summa_na_schete - NEW.summa_spisaniya
    WHERE id_karty = NEW.id_karty;

    RAISE NOTICE 'Баланс карты ID % уменьшен на % руб.', 
                 NEW.id_karty, NEW.summa_spisaniya;
    RETURN NEW;
END;
$$;


ALTER FUNCTION azs.fn_update_balance_after_prodazha() OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 18305)
-- Name: register_prodazha(integer, integer, integer, integer); Type: PROCEDURE; Schema: azs; Owner: postgres
--

CREATE PROCEDURE azs.register_prodazha(IN p_kod_topliva integer, IN p_id_karty integer, IN p_kolichestvo integer, IN p_summa integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_ostatok INTEGER;
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM azs.karta_schet 
        WHERE id_karty = p_id_karty
    ) THEN
        RAISE EXCEPTION 'Карта с ID % не найдена.', p_id_karty;
    END IF;

    SELECT summa_na_schete INTO v_ostatok
    FROM azs.karta_schet
    WHERE id_karty = p_id_karty;

    IF v_ostatok < p_summa THEN
        RAISE EXCEPTION 'Недостаточно средств на карте. Остаток: %, Требуется: %', 
                        v_ostatok, p_summa;
    END IF;

    INSERT INTO azs.prodazha (
        kod_topliva,
        id_karty,
        kolichestvo_topliva,
        summa_spisaniya,
        data_vremya_prodazhi,
        ostatok_posle_operatsii
    )
    VALUES (
        p_kod_topliva,
        p_id_karty,
        p_kolichestvo,
        p_summa,
        NOW(),
        v_ostatok - p_summa
    );

    UPDATE azs.karta_schet
    SET summa_na_schete = summa_na_schete - p_summa
    WHERE id_karty = p_id_karty;

    RAISE NOTICE 'Продажа зарегистрирована. Списано: % руб. Остаток: % руб.', 
                 p_summa, v_ostatok - p_summa;
END;
$$;


ALTER PROCEDURE azs.register_prodazha(IN p_kod_topliva integer, IN p_id_karty integer, IN p_kolichestvo integer, IN p_summa integer) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 18306)
-- Name: update_karta_status(integer, character varying); Type: PROCEDURE; Schema: azs; Owner: postgres
--

CREATE PROCEDURE azs.update_karta_status(IN p_id_karty integer, INOUT p_new_status character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_old_status VARCHAR(20);
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM azs.karta_schet 
        WHERE id_karty = p_id_karty
    ) THEN
        RAISE EXCEPTION 'Карта с ID % не найдена.', p_id_karty;
    END IF;

    SELECT status_karty INTO v_old_status
    FROM azs.karta_schet
    WHERE id_karty = p_id_karty;

    UPDATE azs.karta_schet
    SET status_karty = p_new_status
    WHERE id_karty = p_id_karty;

    RAISE NOTICE 'Статус карты ID % изменён с "%" на "%".', 
                 p_id_karty, v_old_status, p_new_status;
END;
$$;


ALTER PROCEDURE azs.update_karta_status(IN p_id_karty integer, INOUT p_new_status character varying) OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 18303)
-- Name: add_klient(character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: azs_shem; Owner: postgres
--

CREATE PROCEDURE azs_shem.add_klient(IN p_fio character varying, IN p_telefon character varying, IN p_tip_klienta character varying, IN p_adres character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO azs_shem.klient (fio, telefon, tip_klienta, adres)
    VALUES (p_fio, p_telefon, p_tip_klienta, p_adres);
    
    RAISE NOTICE 'Клиент % успешно добавлен.', p_fio;
END;
$$;


ALTER PROCEDURE azs_shem.add_klient(IN p_fio character varying, IN p_telefon character varying, IN p_tip_klienta character varying, IN p_adres character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 246 (class 1259 OID 18308)
-- Name: audit_log; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.audit_log (
    id integer NOT NULL,
    table_name character varying(50),
    operation character varying(10),
    record_id integer,
    description text,
    log_time timestamp without time zone DEFAULT now()
);


ALTER TABLE azs.audit_log OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 18307)
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.audit_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.audit_log_id_seq OWNER TO postgres;

--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 245
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.audit_log_id_seq OWNED BY azs.audit_log.id;


--
-- TOC entry 225 (class 1259 OID 17538)
-- Name: edinitsa_izmereniya; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.edinitsa_izmereniya (
    id_edinitsy_izmereniya integer NOT NULL,
    oboznachenie character varying(10) NOT NULL,
    naimenovanie character varying(20) NOT NULL
);


ALTER TABLE azs.edinitsa_izmereniya OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17537)
-- Name: edinitsa_izmereniya_id_edinitsy_izmereniya_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.edinitsa_izmereniya_id_edinitsy_izmereniya_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.edinitsa_izmereniya_id_edinitsy_izmereniya_seq OWNER TO postgres;

--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 224
-- Name: edinitsa_izmereniya_id_edinitsy_izmereniya_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.edinitsa_izmereniya_id_edinitsy_izmereniya_seq OWNED BY azs.edinitsa_izmereniya.id_edinitsy_izmereniya;


--
-- TOC entry 237 (class 1259 OID 17629)
-- Name: karta_schet; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.karta_schet (
    id_karty integer NOT NULL,
    id_klienta integer NOT NULL,
    nomer_karty integer NOT NULL,
    data_nachala date NOT NULL,
    status_karty character varying(20),
    skidka_protsentov integer,
    summa_na_schete integer,
    data_okonchaniya date,
    CONSTRAINT chk_daty_karty CHECK (((data_okonchaniya IS NULL) OR (data_okonchaniya > data_nachala))),
    CONSTRAINT chk_nomer_karty CHECK ((nomer_karty > 0)),
    CONSTRAINT chk_skidka CHECK (((skidka_protsentov >= 0) AND (skidka_protsentov <= 100))),
    CONSTRAINT chk_summa CHECK ((summa_na_schete >= 0))
);


ALTER TABLE azs.karta_schet OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 17628)
-- Name: karta_schet_id_karty_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.karta_schet_id_karty_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.karta_schet_id_karty_seq OWNER TO postgres;

--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 236
-- Name: karta_schet_id_karty_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.karta_schet_id_karty_seq OWNED BY azs.karta_schet.id_karty;


--
-- TOC entry 235 (class 1259 OID 17620)
-- Name: klient; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.klient (
    id_klienta integer NOT NULL,
    fio character varying(80) NOT NULL,
    telefon character varying(20),
    tip_klienta character varying(20),
    adres character varying(100)
);


ALTER TABLE azs.klient OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17619)
-- Name: klient_id_klienta_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.klient_id_klienta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.klient_id_klienta_seq OWNER TO postgres;

--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 234
-- Name: klient_id_klienta_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.klient_id_klienta_seq OWNED BY azs.klient.id_klienta;


--
-- TOC entry 221 (class 1259 OID 17519)
-- Name: postavshchik; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.postavshchik (
    id_postavshchika integer NOT NULL,
    telefon character varying(20) NOT NULL,
    yuridicheskiy_adres character varying(100),
    nazvanie_firmy character varying(50) NOT NULL,
    inn character varying(20),
    CONSTRAINT chk_inn CHECK ((length((inn)::text) >= 10))
);


ALTER TABLE azs.postavshchik OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17518)
-- Name: postavshchik_id_postavshchika_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.postavshchik_id_postavshchika_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.postavshchik_id_postavshchika_seq OWNER TO postgres;

--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 220
-- Name: postavshchik_id_postavshchika_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.postavshchik_id_postavshchika_seq OWNED BY azs.postavshchik.id_postavshchika;


--
-- TOC entry 227 (class 1259 OID 17548)
-- Name: prodavaemoe_toplivo; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.prodavaemoe_toplivo (
    kod_topliva integer NOT NULL,
    naimenovanie character varying(50) NOT NULL,
    id_tipa_topliva integer NOT NULL,
    oktanovoe_chislo integer,
    id_edinitsy_izmereniya integer NOT NULL,
    CONSTRAINT chk_oktanovoe_chislo CHECK (((oktanovoe_chislo IS NULL) OR ((oktanovoe_chislo >= 80) AND (oktanovoe_chislo <= 100))))
);


ALTER TABLE azs.prodavaemoe_toplivo OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17547)
-- Name: prodavaemoe_toplivo_kod_topliva_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.prodavaemoe_toplivo_kod_topliva_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.prodavaemoe_toplivo_kod_topliva_seq OWNER TO postgres;

--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 226
-- Name: prodavaemoe_toplivo_kod_topliva_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.prodavaemoe_toplivo_kod_topliva_seq OWNED BY azs.prodavaemoe_toplivo.kod_topliva;


--
-- TOC entry 239 (class 1259 OID 17645)
-- Name: prodazha; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.prodazha (
    id_prodazhi integer NOT NULL,
    kod_topliva integer NOT NULL,
    id_karty integer NOT NULL,
    kolichestvo_topliva integer NOT NULL,
    summa_spisaniya integer NOT NULL,
    data_vremya_prodazhi timestamp without time zone NOT NULL,
    ostatok_posle_operatsii integer,
    CONSTRAINT chk_kolichestvo_topliva CHECK ((kolichestvo_topliva > 0)),
    CONSTRAINT chk_ostatok CHECK ((ostatok_posle_operatsii >= 0)),
    CONSTRAINT chk_summa_spisaniya CHECK ((summa_spisaniya > 0))
);


ALTER TABLE azs.prodazha OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 18331)
-- Name: prodazha_audit; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.prodazha_audit (
    id integer NOT NULL,
    id_prodazhi integer,
    kod_topliva integer,
    id_karty integer,
    summa_do_izmeneniya integer,
    summa_posle_izmeneniya integer,
    tip_operatsii character varying(10),
    audit_time timestamp without time zone DEFAULT now()
);


ALTER TABLE azs.prodazha_audit OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 18330)
-- Name: prodazha_audit_id_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.prodazha_audit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.prodazha_audit_id_seq OWNER TO postgres;

--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 247
-- Name: prodazha_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.prodazha_audit_id_seq OWNED BY azs.prodazha_audit.id;


--
-- TOC entry 238 (class 1259 OID 17644)
-- Name: prodazha_id_prodazhi_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.prodazha_id_prodazhi_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.prodazha_id_prodazhi_seq OWNER TO postgres;

--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 238
-- Name: prodazha_id_prodazhi_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.prodazha_id_prodazhi_seq OWNED BY azs.prodazha.id_prodazhi;


--
-- TOC entry 223 (class 1259 OID 17529)
-- Name: tip_topliva; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.tip_topliva (
    id_tipa_topliva integer NOT NULL,
    naimenovanie_tipa character varying(30) NOT NULL
);


ALTER TABLE azs.tip_topliva OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17528)
-- Name: tip_topliva_id_tipa_topliva_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.tip_topliva_id_tipa_topliva_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.tip_topliva_id_tipa_topliva_seq OWNER TO postgres;

--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 222
-- Name: tip_topliva_id_tipa_topliva_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.tip_topliva_id_tipa_topliva_seq OWNED BY azs.tip_topliva.id_tipa_topliva;


--
-- TOC entry 231 (class 1259 OID 17591)
-- Name: tip_zapravki; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.tip_zapravki (
    id_tipa_zapravki integer NOT NULL,
    naimenovanie_tipa character varying(30) NOT NULL,
    opisanie character varying(100)
);


ALTER TABLE azs.tip_zapravki OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17590)
-- Name: tip_zapravki_id_tipa_zapravki_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.tip_zapravki_id_tipa_zapravki_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.tip_zapravki_id_tipa_zapravki_seq OWNER TO postgres;

--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 230
-- Name: tip_zapravki_id_tipa_zapravki_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.tip_zapravki_id_tipa_zapravki_seq OWNED BY azs.tip_zapravki.id_tipa_zapravki;


--
-- TOC entry 229 (class 1259 OID 17569)
-- Name: tsena_topliva; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.tsena_topliva (
    id_tseny integer NOT NULL,
    id_postavshchika integer NOT NULL,
    tsena_za_edinitsu integer NOT NULL,
    data_nachala date NOT NULL,
    kod_topliva integer NOT NULL,
    data_okonchaniya date,
    CONSTRAINT chk_daty_tseny CHECK (((data_okonchaniya IS NULL) OR (data_okonchaniya > data_nachala))),
    CONSTRAINT chk_tsena_polozhitelnaya CHECK ((tsena_za_edinitsu > 0))
);


ALTER TABLE azs.tsena_topliva OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17568)
-- Name: tsena_topliva_id_tseny_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.tsena_topliva_id_tseny_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.tsena_topliva_id_tseny_seq OWNER TO postgres;

--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 228
-- Name: tsena_topliva_id_tseny_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.tsena_topliva_id_tseny_seq OWNED BY azs.tsena_topliva.id_tseny;


--
-- TOC entry 243 (class 1259 OID 18000)
-- Name: v_aktualnyy_prays; Type: VIEW; Schema: azs; Owner: postgres
--

CREATE VIEW azs.v_aktualnyy_prays AS
 SELECT ps.nazvanie_firmy AS postavshchik,
    ps.telefon,
    pt.naimenovanie AS toplivo,
    tt.naimenovanie_tipa AS tip,
    ct.tsena_za_edinitsu AS tsena,
    ei.oboznachenie AS edinitsa,
    ct.data_nachala,
    ct.data_okonchaniya
   FROM ((((azs.tsena_topliva ct
     JOIN azs.postavshchik ps ON ((ct.id_postavshchika = ps.id_postavshchika)))
     JOIN azs.prodavaemoe_toplivo pt ON ((ct.kod_topliva = pt.kod_topliva)))
     JOIN azs.tip_topliva tt ON ((pt.id_tipa_topliva = tt.id_tipa_topliva)))
     JOIN azs.edinitsa_izmereniya ei ON ((pt.id_edinitsy_izmereniya = ei.id_edinitsy_izmereniya)))
  WHERE ((ct.data_nachala <= CURRENT_DATE) AND ((ct.data_okonchaniya IS NULL) OR (ct.data_okonchaniya >= CURRENT_DATE)));


ALTER VIEW azs.v_aktualnyy_prays OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 17901)
-- Name: v_prodazhi_detali; Type: VIEW; Schema: azs; Owner: postgres
--

CREATE VIEW azs.v_prodazhi_detali AS
 SELECT p.id_prodazhi,
    p.data_vremya_prodazhi,
    k.nomer_karty,
    cl.fio,
    t.naimenovanie AS toplivo,
    p.kolichestvo_topliva,
    p.summa_spisaniya,
    p.ostatok_posle_operatsii
   FROM (((azs.prodazha p
     JOIN azs.karta_schet k ON ((k.id_karty = p.id_karty)))
     JOIN azs.klient cl ON ((cl.id_klienta = k.id_klienta)))
     JOIN azs.prodavaemoe_toplivo t ON ((t.kod_topliva = p.kod_topliva)));


ALTER VIEW azs.v_prodazhi_detali OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 17995)
-- Name: v_prodazhi_full; Type: VIEW; Schema: azs; Owner: postgres
--

CREATE VIEW azs.v_prodazhi_full AS
 SELECT p.id_prodazhi,
    k.fio AS klient_fio,
    k.telefon AS klient_telefon,
    k.tip_klienta,
    ks.nomer_karty,
    ks.skidka_protsentov,
    tt.naimenovanie_tipa AS tip_topliva,
    pt.naimenovanie AS nazvanie_topliva,
    p.kolichestvo_topliva,
    ei.oboznachenie AS edinitsa_izm,
    p.summa_spisaniya,
    p.data_vremya_prodazhi,
    p.ostatok_posle_operatsii
   FROM (((((azs.prodazha p
     JOIN azs.karta_schet ks ON ((p.id_karty = ks.id_karty)))
     JOIN azs.klient k ON ((ks.id_klienta = k.id_klienta)))
     JOIN azs.prodavaemoe_toplivo pt ON ((p.kod_topliva = pt.kod_topliva)))
     JOIN azs.tip_topliva tt ON ((pt.id_tipa_topliva = tt.id_tipa_topliva)))
     JOIN azs.edinitsa_izmereniya ei ON ((pt.id_edinitsy_izmereniya = ei.id_edinitsy_izmereniya)));


ALTER VIEW azs.v_prodazhi_full OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17906)
-- Name: v_rashody_klientov; Type: VIEW; Schema: azs; Owner: postgres
--

CREATE VIEW azs.v_rashody_klientov AS
 SELECT cl.id_klienta,
    cl.fio,
    count(p.id_prodazhi) AS kolvo_prodazh,
    sum(p.summa_spisaniya) AS summa_vsego
   FROM ((azs.klient cl
     JOIN azs.karta_schet k ON ((k.id_klienta = cl.id_klienta)))
     JOIN azs.prodazha p ON ((p.id_karty = k.id_karty)))
  GROUP BY cl.id_klienta, cl.fio;


ALTER VIEW azs.v_rashody_klientov OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 18005)
-- Name: v_statistika_klientov; Type: VIEW; Schema: azs; Owner: postgres
--

CREATE VIEW azs.v_statistika_klientov AS
 SELECT k.id_klienta,
    k.fio,
    k.telefon,
    k.tip_klienta,
    ks.nomer_karty,
    ks.status_karty,
    ks.skidka_protsentov,
    ks.summa_na_schete,
    count(p.id_prodazhi) AS kolichestvo_pokupok,
    COALESCE(sum(p.summa_spisaniya), (0)::bigint) AS obshchaya_summa_pokupok,
    COALESCE(sum(p.kolichestvo_topliva), (0)::bigint) AS vsego_topliva
   FROM ((azs.klient k
     JOIN azs.karta_schet ks ON ((k.id_klienta = ks.id_klienta)))
     LEFT JOIN azs.prodazha p ON ((ks.id_karty = p.id_karty)))
  GROUP BY k.id_klienta, k.fio, k.telefon, k.tip_klienta, ks.nomer_karty, ks.status_karty, ks.skidka_protsentov, ks.summa_na_schete;


ALTER VIEW azs.v_statistika_klientov OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17600)
-- Name: zaprava; Type: TABLE; Schema: azs; Owner: postgres
--

CREATE TABLE azs.zaprava (
    kod_zapravki integer NOT NULL,
    id_postavshchika integer NOT NULL,
    rezhim_raboty character varying(50),
    adres_zapravki character varying(100),
    id_tipa_zapravki integer NOT NULL,
    kolichestvo_kolonok integer,
    CONSTRAINT chk_kolichestvo_kolonok CHECK ((kolichestvo_kolonok > 0))
);


ALTER TABLE azs.zaprava OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17599)
-- Name: zaprava_kod_zapravki_seq; Type: SEQUENCE; Schema: azs; Owner: postgres
--

CREATE SEQUENCE azs.zaprava_kod_zapravki_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE azs.zaprava_kod_zapravki_seq OWNER TO postgres;

--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 232
-- Name: zaprava_kod_zapravki_seq; Type: SEQUENCE OWNED BY; Schema: azs; Owner: postgres
--

ALTER SEQUENCE azs.zaprava_kod_zapravki_seq OWNED BY azs.zaprava.kod_zapravki;


--
-- TOC entry 4953 (class 2604 OID 18311)
-- Name: audit_log id; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.audit_log ALTER COLUMN id SET DEFAULT nextval('azs.audit_log_id_seq'::regclass);


--
-- TOC entry 4945 (class 2604 OID 18011)
-- Name: edinitsa_izmereniya id_edinitsy_izmereniya; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.edinitsa_izmereniya ALTER COLUMN id_edinitsy_izmereniya SET DEFAULT nextval('azs.edinitsa_izmereniya_id_edinitsy_izmereniya_seq'::regclass);


--
-- TOC entry 4951 (class 2604 OID 18012)
-- Name: karta_schet id_karty; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.karta_schet ALTER COLUMN id_karty SET DEFAULT nextval('azs.karta_schet_id_karty_seq'::regclass);


--
-- TOC entry 4950 (class 2604 OID 18013)
-- Name: klient id_klienta; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.klient ALTER COLUMN id_klienta SET DEFAULT nextval('azs.klient_id_klienta_seq'::regclass);


--
-- TOC entry 4943 (class 2604 OID 18014)
-- Name: postavshchik id_postavshchika; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.postavshchik ALTER COLUMN id_postavshchika SET DEFAULT nextval('azs.postavshchik_id_postavshchika_seq'::regclass);


--
-- TOC entry 4946 (class 2604 OID 18015)
-- Name: prodavaemoe_toplivo kod_topliva; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodavaemoe_toplivo ALTER COLUMN kod_topliva SET DEFAULT nextval('azs.prodavaemoe_toplivo_kod_topliva_seq'::regclass);


--
-- TOC entry 4952 (class 2604 OID 18016)
-- Name: prodazha id_prodazhi; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodazha ALTER COLUMN id_prodazhi SET DEFAULT nextval('azs.prodazha_id_prodazhi_seq'::regclass);


--
-- TOC entry 4955 (class 2604 OID 18334)
-- Name: prodazha_audit id; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodazha_audit ALTER COLUMN id SET DEFAULT nextval('azs.prodazha_audit_id_seq'::regclass);


--
-- TOC entry 4944 (class 2604 OID 18017)
-- Name: tip_topliva id_tipa_topliva; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tip_topliva ALTER COLUMN id_tipa_topliva SET DEFAULT nextval('azs.tip_topliva_id_tipa_topliva_seq'::regclass);


--
-- TOC entry 4948 (class 2604 OID 18018)
-- Name: tip_zapravki id_tipa_zapravki; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tip_zapravki ALTER COLUMN id_tipa_zapravki SET DEFAULT nextval('azs.tip_zapravki_id_tipa_zapravki_seq'::regclass);


--
-- TOC entry 4947 (class 2604 OID 18019)
-- Name: tsena_topliva id_tseny; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tsena_topliva ALTER COLUMN id_tseny SET DEFAULT nextval('azs.tsena_topliva_id_tseny_seq'::regclass);


--
-- TOC entry 4949 (class 2604 OID 18020)
-- Name: zaprava kod_zapravki; Type: DEFAULT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.zaprava ALTER COLUMN kod_zapravki SET DEFAULT nextval('azs.zaprava_kod_zapravki_seq'::regclass);


--
-- TOC entry 5190 (class 0 OID 18308)
-- Dependencies: 246
-- Data for Name: audit_log; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.audit_log (id, table_name, operation, record_id, description, log_time) FROM stdin;
1	klient	INSERT	42	Добавлен новый клиент: Тестов Тест Тестович	2026-05-27 04:56:27.542331
2	klient	UPDATE	42	Обновлён клиент ID 42: [Тестов Тест Тестович] -> [Тестов Тест Тестович (обновлён)]	2026-05-27 04:56:27.550689
\.


--
-- TOC entry 5174 (class 0 OID 17538)
-- Dependencies: 225
-- Data for Name: edinitsa_izmereniya; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.edinitsa_izmereniya (id_edinitsy_izmereniya, oboznachenie, naimenovanie) FROM stdin;
1	л	литр
2	кВтч	киловатт-час
\.


--
-- TOC entry 5186 (class 0 OID 17629)
-- Dependencies: 237
-- Data for Name: karta_schet; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.karta_schet (id_karty, id_klienta, nomer_karty, data_nachala, status_karty, skidka_protsentov, summa_na_schete, data_okonchaniya) FROM stdin;
4	4	700004	2025-07-23	Активна	5	54179	\N
5	5	700005	2026-01-31	Активна	11	24558	\N
6	6	700006	2025-11-08	Активна	1	164625	\N
7	7	700007	2026-03-10	Активна	1	133831	\N
8	8	700008	2025-11-06	Активна	10	33541	\N
9	9	700009	2025-12-28	Активна	5	143511	\N
10	10	700010	2025-07-25	Активна	4	51656	\N
11	11	700011	2026-04-21	Активна	11	164698	\N
12	12	700012	2025-11-14	Активна	2	125276	\N
13	13	700013	2025-05-23	Активна	1	101022	\N
14	14	700014	2026-02-02	Активна	4	193868	\N
15	15	700015	2025-07-01	Активна	1	141699	\N
16	16	700016	2025-10-31	Активна	1	158906	\N
17	17	700017	2026-02-04	Активна	6	148335	\N
18	18	700018	2025-06-03	Активна	8	97682	\N
19	19	700019	2026-02-01	Активна	2	159257	\N
20	20	700020	2026-03-27	Активна	8	75820	\N
21	21	700021	2026-03-18	Активна	13	50494	\N
22	22	700022	2025-07-23	Активна	6	174878	\N
24	24	700024	2025-06-27	Активна	15	33018	\N
25	25	700025	2026-04-04	Активна	8	165667	\N
26	26	700026	2026-04-19	Активна	3	34850	\N
27	27	700027	2026-03-31	Активна	1	60380	\N
28	28	700028	2025-10-07	Активна	6	52396	\N
29	29	700029	2025-06-25	Активна	6	44725	\N
30	30	700030	2026-01-18	Активна	3	116927	\N
31	31	700031	2025-07-18	Активна	7	90134	\N
32	32	700032	2025-09-15	Активна	11	39282	\N
33	33	700033	2026-04-25	Активна	12	91212	\N
34	34	700034	2025-06-25	Активна	2	161990	\N
35	35	700035	2026-02-24	Активна	9	161929	\N
36	36	700036	2025-08-31	Активна	3	203730	\N
37	37	700037	2025-07-21	Активна	2	165580	\N
38	38	700038	2025-07-16	Активна	11	197480	\N
39	39	700039	2026-01-13	Активна	6	157925	\N
40	40	700040	2025-12-22	Активна	8	40874	\N
23	23	700023	2025-08-22	Активна	13	211335	\N
2	2	700002	2025-09-23	Активна	8	95007	\N
3	3	700003	2025-10-15	Активна	1	74905	\N
41	1	9999	2024-01-01	Активна	5	1000	2027-01-01
1	1	700001	2025-12-24	Заблокирована	15	155812	\N
\.


--
-- TOC entry 5184 (class 0 OID 17620)
-- Dependencies: 235
-- Data for Name: klient; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.klient (id_klienta, fio, telefon, tip_klienta, adres) FROM stdin;
1	Иванов Иван Иванович	+7-911-101-01-01	Физическое лицо	Москва
2	Петров Петр Петрович	+7-911-102-02-02	Физическое лицо	Санкт-Петербург
3	Сидоров Алексей Дмитриевич	+7-911-103-03-03	Физическое лицо	Казань
4	Кузнецова Мария Сергеевна	+7-911-104-04-04	Физическое лицо	Екатеринбург
5	Смирнов Андрей Олегович	+7-911-105-05-05	Физическое лицо	Новосибирск
6	Попова Анна Викторовна	+7-911-106-06-06	Физическое лицо	Краснодар
7	Васильев Дмитрий Игоревич	+7-911-107-07-07	Физическое лицо	Тюмень
8	Морозова Елена Павловна	+7-911-108-08-08	Физическое лицо	Самара
9	Федоров Максим Сергеевич	+7-911-109-09-09	Физическое лицо	Челябинск
10	Николаев Артем Алексеевич	+7-911-110-10-10	Физическое лицо	Пермь
11	ООО "Транспорт"	+7-495-200-00-01	Юридическое лицо	Москва
12	ООО "Логистика"	+7-812-200-00-02	Юридическое лицо	Санкт-Петербург
13	ООО "СтройИнвест"	+7-343-200-00-03	Юридическое лицо	Екатеринбург
14	ООО "Автопарк"	+7-495-200-00-04	Юридическое лицо	Москва
15	ООО "Снабжение"	+7-812-200-00-05	Юридическое лицо	СПб
16	ЗАО "Доставка"	+7-495-200-00-06	Юридическое лицо	Москва
17	ООО "Такси-Экспресс"	+7-343-200-00-07	Юридическое лицо	Екатеринбург
18	ООО "ГрузТранс"	+7-812-200-00-08	Юридическое лицо	СПб
19	ООО "Магистраль"	+7-495-200-00-09	Юридическое лицо	Москва
20	ООО "Карго"	+7-812-200-00-10	Юридическое лицо	СПб
21	Алексеев Кирилл Павлович	+7-911-201-01-01	Физическое лицо	Москва
22	Орлова Наталья Игоревна	+7-911-202-02-02	Физическое лицо	Казань
23	Захаров Роман Олегович	+7-911-203-03-03	Физическое лицо	Самара
24	Белов Сергей Андреевич	+7-911-204-04-04	Физическое лицо	Омск
25	Киселева Ольга Дмитриевна	+7-911-205-05-05	Физическое лицо	Тула
26	Лебедев Артем Сергеевич	+7-911-206-06-06	Физическое лицо	Киров
27	Громова Ирина Алексеевна	+7-911-207-07-07	Физическое лицо	Рязань
28	Денисов Павел Максимович	+7-911-208-08-08	Физическое лицо	Тверь
29	Титова Марина Викторовна	+7-911-209-09-09	Физическое лицо	Сочи
30	Макаров Никита Евгеньевич	+7-911-210-10-10	Физическое лицо	Уфа
31	ООО "РегионТранс"	+7-495-300-00-01	Юридическое лицо	Москва
32	ООО "ГородСервис"	+7-812-300-00-02	Юридическое лицо	СПб
33	ООО "ПрофАвто"	+7-343-300-00-03	Юридическое лицо	Екатеринбург
34	ООО "СеверЛогистик"	+7-812-300-00-04	Юридическое лицо	СПб
35	ООО "АвтоПлюс"	+7-495-300-00-05	Юридическое лицо	Москва
36	ООО "ТехСнаб"	+7-495-300-00-06	Юридическое лицо	Москва
37	ООО "МоторСервис"	+7-812-300-00-07	Юридическое лицо	СПб
38	ООО "ЭкспрессТранс"	+7-343-300-00-08	Юридическое лицо	Екатеринбург
39	ООО "Драйв"	+7-495-300-00-09	Юридическое лицо	Москва
40	ООО "АвтоГрупп"	+7-812-300-00-10	Юридическое лицо	СПб
41	Иванов Иван Иванович	+7-900-000-00-00	Физическое лицо	г. Москва, ул. Тверская, д. 1
42	Тестов Тест Тестович (обновлён)	+7-111-111-11-11	Физическое лицо	г. Тест
\.


--
-- TOC entry 5170 (class 0 OID 17519)
-- Dependencies: 221
-- Data for Name: postavshchik; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.postavshchik (id_postavshchika, telefon, yuridicheskiy_adres, nazvanie_firmy, inn) FROM stdin;
1	+7-495-111-11-11	Москва	Роснефть	1234567890
2	+7-812-222-22-22	Санкт-Петербург	Лукойл	0987654321
3	+7-343-333-33-33	Екатеринбург	Газпром нефть	1122334455
\.


--
-- TOC entry 5176 (class 0 OID 17548)
-- Dependencies: 227
-- Data for Name: prodavaemoe_toplivo; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.prodavaemoe_toplivo (kod_topliva, naimenovanie, id_tipa_topliva, oktanovoe_chislo, id_edinitsy_izmereniya) FROM stdin;
1	АИ-92	1	92	1
2	АИ-95	1	95	1
3	ДТ Евро	2	\N	1
4	Пропан	3	\N	1
5	Электро AC	4	\N	2
\.


--
-- TOC entry 5188 (class 0 OID 17645)
-- Dependencies: 239
-- Data for Name: prodazha; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.prodazha (id_prodazhi, kod_topliva, id_karty, kolichestvo_topliva, summa_spisaniya, data_vremya_prodazhi, ostatok_posle_operatsii) FROM stdin;
1	2	2	12	1300	2025-12-04 15:40:56.861798	192081
2	3	3	14	2223	2026-01-17 18:37:59.352952	64141
3	4	4	43	2278	2026-01-29 00:09:03.876883	184881
4	5	5	27	2562	2026-03-07 22:56:17.385649	2131
5	1	6	11	1800	2026-03-16 21:20:14.321444	136511
6	2	7	35	341	2025-11-23 08:05:24.524495	53004
7	3	8	41	1664	2026-01-11 15:22:24.811045	18811
8	4	9	51	1240	2026-02-19 22:45:19.846328	123812
9	5	10	20	1078	2026-01-03 14:23:03.915102	75418
10	1	11	22	2211	2026-02-19 04:35:57.580885	84448
11	2	12	43	2128	2025-12-22 03:34:16.607445	9941
12	3	13	44	1104	2026-04-25 18:31:01.62284	192541
13	4	14	42	728	2026-02-22 17:04:18.337306	22281
14	5	15	57	2385	2026-04-22 07:53:13.779564	125752
15	1	16	46	2360	2026-02-21 19:09:22.742512	107081
16	2	17	52	3366	2026-01-12 08:07:35.076183	185720
17	3	18	35	722	2026-01-03 16:27:05.854036	196008
18	4	19	18	2640	2026-01-17 01:40:58.270967	65115
19	5	20	13	2301	2026-03-15 14:47:25.772391	21958
20	1	21	20	969	2026-03-01 14:43:24.853584	60307
21	2	22	47	1950	2025-12-21 16:57:05.943622	30814
22	3	23	21	2024	2025-11-26 22:17:51.464228	90194
23	4	24	58	1596	2026-01-24 23:49:17.510736	104201
24	5	25	26	1702	2026-04-29 19:50:59.115005	144583
25	1	26	40	3315	2026-04-03 10:27:47.364057	138348
26	2	27	14	1734	2026-05-16 23:14:00.977397	147750
27	3	28	24	1170	2026-03-13 23:44:23.158267	100806
28	4	29	28	528	2026-02-25 01:03:11.751819	40969
29	5	30	41	1425	2025-12-04 19:12:09.977113	54823
30	1	31	55	1656	2025-12-13 23:43:17.498722	90884
31	2	32	44	2835	2026-01-29 12:46:21.880321	10290
32	3	33	31	2440	2025-12-08 11:52:20.191707	165928
33	4	34	59	1408	2026-04-08 07:44:41.41885	119294
34	5	35	50	561	2026-04-30 10:38:56.475407	113828
35	1	36	18	1566	2026-04-05 15:38:49.587354	149094
36	2	37	58	858	2026-04-29 07:56:28.26802	195305
37	3	38	58	2747	2026-02-05 18:29:41.90657	161588
38	4	39	49	704	2026-03-18 14:54:14.633079	85260
39	5	40	21	396	2026-03-21 21:45:23.077621	171047
40	1	1	12	1444	2025-12-09 18:44:31.680745	63268
41	2	2	46	2397	2025-11-23 16:57:59.490482	73387
42	3	3	47	1575	2025-11-23 00:55:09.475476	75252
43	4	4	16	2585	2026-02-05 17:37:33.899544	69281
44	5	5	40	2135	2026-04-26 07:51:55.49096	125730
45	1	6	52	440	2026-02-07 06:33:54.828389	138263
46	2	7	36	1722	2026-01-25 05:18:30.583698	132311
47	3	8	43	2788	2026-03-28 07:41:30.852198	111946
48	4	9	31	1700	2026-03-25 05:13:45.728157	100846
49	5	10	17	3726	2026-03-22 23:30:43.698737	177186
50	1	11	32	744	2026-01-25 23:50:55.582384	136599
51	2	12	52	2438	2026-03-24 00:09:06.014536	96591
52	3	13	18	552	2026-01-21 06:57:17.428007	122017
53	4	14	25	1334	2026-05-07 15:51:31.526895	128692
54	5	15	67	550	2026-01-25 23:16:37.928278	101128
55	1	16	38	3306	2026-05-08 02:53:39.025908	145598
56	2	17	52	2109	2026-02-18 06:24:41.408657	123322
57	3	18	22	3795	2026-01-07 08:05:10.722659	13754
58	4	19	24	2688	2026-03-22 14:02:32.327421	198619
59	5	20	64	2537	2025-12-16 07:12:58.621948	1802
60	1	21	51	1904	2026-05-12 06:12:06.246496	197550
61	2	22	45	1254	2026-02-23 00:45:10.546627	188598
62	3	23	40	2788	2025-12-28 07:59:36.149954	169802
63	4	24	26	1848	2026-03-05 22:52:30.651427	47941
64	5	25	65	1710	2026-03-27 21:10:05.763362	30265
65	1	26	17	429	2026-01-12 00:59:23.548679	111842
66	2	27	53	637	2026-01-09 01:48:19.642945	20254
67	3	28	69	1064	2025-12-21 12:07:57.547109	2138
68	4	29	46	2438	2026-01-31 07:38:40.722956	149556
69	5	30	35	3264	2025-12-28 11:53:40.549358	161506
70	1	31	37	1026	2026-05-14 08:17:35.673823	63041
71	2	32	39	1517	2026-02-03 07:45:41.158651	85129
72	3	33	15	3074	2026-05-10 23:41:43.452975	193720
73	4	34	54	629	2026-01-13 06:54:23.690097	153759
74	5	35	19	784	2026-04-09 15:02:28.270408	190025
75	1	36	18	2279	2026-04-05 18:28:32.670704	51584
76	2	37	46	1870	2026-04-07 23:29:15.05481	140423
77	3	38	28	720	2026-05-11 19:11:50.174694	71465
78	4	39	29	944	2025-12-16 20:17:19.019806	11682
79	5	40	13	1584	2026-03-27 03:59:40.934684	170696
80	1	1	57	2491	2026-02-12 14:56:59.018216	157283
81	2	2	33	3190	2026-05-17 19:36:07.177335	2463
82	3	3	38	714	2026-03-31 04:56:46.809745	82223
83	4	4	65	1600	2026-01-13 16:50:48.557249	36135
84	5	5	67	1568	2026-03-17 19:28:05.691209	104288
85	1	6	66	1710	2026-04-11 15:09:55.068193	123323
86	2	7	28	3132	2026-03-21 17:26:16.502745	71764
87	3	8	36	1012	2026-01-07 15:25:04.545307	132631
88	4	9	52	2484	2026-02-19 13:27:58.583241	44679
89	5	10	58	2880	2025-11-25 23:04:05.86383	42952
90	1	11	55	3392	2026-03-07 16:04:41.231183	166459
91	2	12	29	1806	2026-02-26 04:11:27.498596	71838
92	3	13	45	2100	2025-12-31 09:38:25.96365	40368
93	4	14	59	2484	2025-12-23 04:18:31.210904	73551
94	5	15	64	3021	2026-03-10 07:19:29.248548	131974
95	1	16	23	962	2025-12-27 00:15:37.351472	33416
96	2	17	19	660	2025-12-04 16:36:01.854533	159682
97	3	18	31	1984	2026-02-22 08:19:43.885198	99501
98	4	19	12	451	2026-01-17 18:48:06.095513	159070
99	5	20	14	690	2026-05-06 01:50:31.659256	76748
100	1	21	59	2268	2026-02-28 18:06:57.928457	75673
101	2	22	29	910	2025-12-24 08:50:52.499014	20932
102	3	23	28	2115	2026-04-19 20:13:31.141812	171171
103	4	24	44	867	2026-04-19 07:45:28.332763	142140
104	5	25	20	1650	2026-05-01 02:14:20.722621	152195
105	1	26	68	2112	2026-02-19 02:05:36.830551	190996
106	2	27	44	1749	2026-02-28 06:57:18.887656	167275
107	3	28	38	1056	2025-12-20 16:35:48.744272	37904
108	4	29	21	2046	2025-11-30 05:57:50.479369	39127
109	5	30	37	2448	2025-12-24 19:31:20.131137	143822
111	2	32	14	1287	2026-05-18 22:41:26.707063	142817
112	3	33	29	2262	2026-04-20 21:52:35.7194	73513
113	4	34	63	1782	2026-05-02 03:34:24.964621	55517
114	5	35	35	600	2025-11-26 00:12:29.636506	185830
115	1	36	29	2160	2026-04-03 01:36:54.143936	170682
116	2	37	62	2665	2025-12-09 11:42:01.419702	57340
117	3	38	33	2850	2026-05-02 05:05:37.437676	51813
118	4	39	65	1064	2026-05-19 00:09:20.127982	24024
119	5	40	35	3162	2026-04-02 18:47:30.226469	7776
120	1	1	10	1056	2026-02-06 05:54:01.758176	162759
121	2	2	13	1849	2026-04-01 10:35:22.196879	115813
122	3	3	53	480	2026-05-21 00:53:04.110669	183543
123	4	4	30	990	2025-12-10 06:29:57.439406	38350
124	5	5	45	448	2026-03-11 20:00:56.34721	77697
125	1	6	21	2288	2025-12-09 13:28:09.768541	152883
126	2	7	55	957	2026-02-09 02:29:18.573239	92161
127	3	8	57	1960	2025-12-29 07:55:21.618972	1458
128	4	9	34	1974	2026-01-28 00:51:20.258863	124324
129	5	10	41	2736	2025-11-28 17:50:18.383417	26670
130	1	11	37	1600	2025-12-24 23:24:07.468527	55353
131	2	12	22	2204	2026-04-07 07:39:57.163174	140765
132	3	13	42	3420	2026-02-15 23:44:25.869866	177206
133	4	14	24	2166	2026-01-05 05:31:11.385891	195942
134	5	15	60	1197	2025-12-17 03:51:29.85631	133355
135	1	16	30	1936	2025-11-30 13:13:13.471193	162597
136	2	17	23	1330	2025-12-17 01:26:41.315984	20043
137	3	18	61	1239	2026-02-28 20:55:39.775106	54818
138	4	19	67	1924	2025-12-30 14:32:22.326879	75875
139	5	20	10	990	2026-03-16 01:06:29.436914	20803
140	1	21	10	390	2025-12-27 18:24:07.153234	132819
141	2	22	59	1650	2025-11-28 16:29:15.058728	59030
142	3	23	61	3828	2025-11-28 12:41:20.908177	98045
143	4	24	35	945	2026-03-22 14:14:41.282802	89688
144	5	25	46	1600	2026-05-17 17:57:16.98994	125039
145	1	26	29	840	2026-03-14 20:00:56.431125	66177
146	2	27	29	1824	2026-03-01 22:38:07.345231	140058
147	3	28	13	1305	2026-03-25 23:18:58.824463	94517
148	4	29	10	1700	2025-11-27 04:26:09.898909	101986
149	5	30	31	960	2026-05-17 02:11:32.06603	185540
150	1	31	27	1665	2026-05-16 04:18:08.746156	130449
151	2	32	28	777	2026-01-29 13:10:56.796666	70814
152	3	33	51	600	2026-05-07 19:00:26.252922	414
153	4	34	67	780	2026-04-11 18:28:53.212075	177249
154	5	35	67	2640	2026-03-04 12:48:50.175805	37405
155	1	36	14	3192	2026-01-05 09:56:45.692315	128603
156	2	37	43	1085	2025-12-29 12:40:37.363568	103749
157	3	38	59	3432	2026-03-05 08:54:03.008875	110569
158	4	39	32	616	2026-01-07 08:00:19.125603	42696
159	5	40	57	943	2026-04-28 16:13:58.734446	103670
160	1	1	48	1575	2026-04-25 18:05:25.442013	16721
161	2	2	69	3168	2026-03-02 15:56:59.14108	134630
162	3	3	60	2610	2026-02-01 15:22:35.913675	140909
163	4	4	15	2548	2026-01-13 04:15:44.846748	75439
164	5	5	22	3186	2026-03-14 08:27:46.737891	155296
165	1	6	68	3276	2026-05-21 02:40:34.152588	108921
166	2	7	61	2838	2026-05-17 10:15:22.805797	103160
167	3	8	44	3016	2026-03-16 18:30:27.522727	19184
168	4	9	12	1024	2026-01-18 22:44:29.957107	34911
169	5	10	26	2074	2026-03-24 10:35:01.216165	144934
170	1	11	30	3224	2026-01-30 12:36:03.034743	197635
171	2	12	43	1443	2026-01-12 22:12:11.372629	103964
172	3	13	46	1204	2026-04-17 01:57:48.595357	12998
173	4	14	60	420	2026-02-01 13:44:17.631227	156691
174	5	15	11	640	2026-01-29 22:55:13.475353	89875
175	1	16	20	2494	2026-03-24 05:50:36.40457	47561
176	2	17	42	1190	2026-04-27 23:02:31.058472	89212
177	3	18	38	1998	2026-02-12 22:12:37.465513	62888
178	4	19	42	2703	2025-11-30 15:04:46.236939	148244
179	5	20	48	518	2026-03-22 17:22:34.320115	59844
180	1	21	44	1920	2026-03-21 16:07:06.89602	63455
181	2	22	68	2484	2025-11-24 19:13:24.822196	181232
182	3	23	39	1287	2026-02-24 01:54:48.71347	25226
183	4	24	63	1806	2026-01-13 17:00:35.061608	62193
184	5	25	18	615	2026-03-24 13:19:18.630931	97344
185	1	26	35	2688	2026-05-21 00:04:36.185539	142437
186	2	27	43	2183	2026-03-06 02:13:41.838229	71603
187	3	28	42	1242	2026-03-12 18:34:07.837352	31154
188	4	29	19	2499	2026-04-14 06:13:31.215868	39182
189	5	30	47	570	2026-03-26 14:10:38.252615	85734
190	1	31	22	1088	2026-02-14 01:59:18.818655	147529
191	2	32	42	1881	2026-05-08 04:12:32.075754	133903
192	3	33	64	1638	2026-01-19 19:00:10.716268	187794
193	4	34	33	1672	2026-03-03 04:47:50.343321	99526
194	5	35	15	1122	2026-05-19 19:15:42.493616	30559
195	1	36	39	1386	2026-05-10 13:25:47.386341	194974
196	2	37	69	2088	2026-03-08 07:26:15.968045	14335
197	3	38	22	928	2026-04-25 21:43:11.242998	94919
198	4	39	59	1595	2026-05-18 01:12:26.586076	127016
199	5	40	17	2592	2026-02-22 17:49:36.642605	113879
200	1	1	49	850	2025-12-05 19:56:05.500322	60289
201	2	2	50	1632	2026-03-13 22:28:05.783019	116176
202	3	3	39	3339	2025-12-13 10:03:31.065119	166969
203	4	4	28	837	2026-05-05 05:15:02.91005	194136
204	5	5	69	1102	2026-05-01 09:45:30.963673	83970
205	1	6	13	2193	2025-12-05 16:29:18.557418	143108
206	2	7	17	2703	2026-03-01 00:17:22.205369	169617
207	3	8	22	1225	2026-03-04 16:28:41.607718	33736
208	4	9	38	884	2026-02-16 14:35:09.536557	57560
209	5	10	49	1564	2026-05-12 17:01:00.759355	72093
210	1	11	18	1800	2026-04-26 04:10:26.133222	141385
211	2	12	69	750	2026-04-23 06:47:19.228637	120683
212	3	13	68	561	2025-12-29 18:41:10.047541	98301
213	4	14	31	527	2026-01-24 08:36:15.019187	199301
214	5	15	13	1365	2026-04-03 09:01:30.606428	97391
215	1	16	62	1972	2026-02-19 14:15:39.288383	45273
216	2	17	21	1188	2026-05-06 17:58:26.792521	88271
217	3	18	24	1430	2025-12-17 23:52:39.508769	23147
218	4	19	55	2142	2025-11-25 08:23:53.980118	83516
219	5	20	22	1156	2026-01-31 07:16:29.602598	78971
220	1	21	53	912	2026-03-22 07:25:26.55994	92377
221	2	22	65	504	2025-12-25 06:50:35.132304	123138
222	3	23	64	460	2026-01-03 10:22:48.732678	60332
223	4	24	61	3008	2026-03-11 13:40:03.218313	22768
224	5	25	18	2992	2025-12-10 04:07:36.524716	167975
225	1	26	35	585	2026-01-20 11:25:51.500677	178143
226	2	27	68	1025	2025-12-31 06:11:58.330548	194987
227	3	28	59	627	2026-02-03 17:33:17.038473	156014
228	4	29	16	1290	2026-04-23 21:42:47.621617	134943
229	5	30	34	3604	2025-12-21 09:30:52.02008	93231
230	1	31	35	572	2026-03-01 23:52:23.039959	186197
231	2	32	36	720	2026-04-15 02:25:44.815302	167467
232	3	33	22	3162	2026-03-14 20:38:02.693979	116613
233	4	34	15	1575	2026-05-15 03:31:35.883397	90826
234	5	35	10	1888	2025-12-11 20:24:49.249818	116337
235	1	36	13	1537	2026-05-13 04:47:27.225234	81138
236	2	37	54	1519	2026-04-21 06:19:48.378727	50905
237	3	38	49	2793	2026-04-27 19:31:38.27512	108959
238	4	39	24	1394	2026-03-13 13:06:20.809615	189861
239	5	40	51	2070	2026-04-30 16:57:56.048194	64602
240	1	1	48	2400	2026-04-08 09:54:05.168473	65322
241	2	2	49	3306	2026-02-26 21:51:23.479619	118906
242	3	3	49	1710	2025-12-31 00:37:09.662199	67156
243	4	4	66	736	2025-12-22 01:39:15.211137	184287
244	5	5	37	2881	2026-01-12 20:03:27.679514	186445
245	1	6	42	2784	2026-02-19 11:01:05.679801	175818
246	2	7	21	825	2025-12-28 00:30:08.232378	60865
247	3	8	11	1947	2026-04-26 18:21:22.993068	114989
248	4	9	39	1705	2026-04-13 12:43:45.639445	76450
249	5	10	34	533	2026-03-13 13:42:21.271923	55520
250	1	11	62	860	2025-12-13 12:48:35.895513	151932
251	2	12	35	680	2025-11-30 04:10:03.416028	165037
252	3	13	50	2088	2026-02-25 21:58:09.612712	139781
253	4	14	40	2842	2026-01-28 14:15:06.156779	120700
254	5	15	15	2436	2026-02-16 04:11:20.714828	116294
255	1	16	52	1976	2026-01-31 11:44:55.080333	139074
256	2	17	49	2408	2026-04-01 23:55:47.132611	59271
257	3	18	63	810	2026-04-04 08:10:05.866215	73483
258	4	19	58	928	2026-03-31 02:09:09.667137	178626
259	5	20	62	576	2026-02-14 06:56:15.349223	137008
260	1	21	20	1122	2026-04-19 04:30:11.724876	45682
261	2	22	39	720	2026-04-02 11:18:24.418879	153992
262	3	23	36	1034	2026-03-07 05:18:26.53157	70057
263	4	24	38	1476	2026-02-20 17:26:15.114473	115375
264	5	25	49	2574	2025-12-23 08:55:56.162543	87789
265	1	26	69	925	2026-01-15 18:23:46.769806	133758
266	2	27	36	3528	2026-05-11 22:59:45.315973	642
267	3	28	46	510	2026-02-05 13:57:49.915478	76831
268	4	29	13	2107	2026-02-19 21:02:07.075625	48926
269	5	30	66	1344	2025-12-29 09:11:21.940404	31526
270	1	31	57	1700	2026-02-20 09:48:50.38231	48826
271	2	32	33	2800	2026-01-24 16:05:08.530783	126411
272	3	33	50	2408	2026-05-13 21:19:58.840963	164482
273	4	34	37	1320	2025-12-11 21:59:20.199112	99489
274	5	35	61	1617	2026-04-18 19:17:30.023879	38198
275	1	36	51	1333	2025-12-05 06:49:50.40741	158752
276	2	37	23	1705	2025-12-05 14:17:55.947751	191933
277	3	38	59	2250	2025-11-27 11:47:09.232735	5447
278	4	39	57	615	2026-03-28 14:33:00.921214	89555
279	5	40	57	2958	2026-01-18 10:30:19.989408	199243
280	1	1	44	490	2026-01-15 10:30:52.824153	155990
281	2	2	64	468	2026-02-02 05:13:07.869753	127372
282	3	3	53	1768	2026-05-09 07:47:36.989945	111627
283	4	4	69	3685	2025-11-23 20:51:04.721874	34556
284	5	5	68	1880	2026-03-31 03:23:32.431486	174602
285	1	6	50	1950	2025-12-24 03:56:14.078043	168171
286	2	7	16	1640	2026-04-07 16:59:46.564625	155312
287	3	8	34	1134	2026-05-07 10:23:18.100155	198171
288	4	9	60	1026	2026-01-05 22:52:39.54689	177846
289	5	10	12	1395	2026-01-15 00:41:54.377926	197994
290	1	11	28	644	2026-03-14 07:16:30.502755	116096
291	2	12	13	1904	2026-01-25 18:59:47.189877	20189
292	3	13	56	2145	2026-02-13 05:44:55.771496	107123
293	4	14	50	860	2026-02-08 02:00:28.170037	108892
294	5	15	64	1748	2026-02-14 12:57:15.341709	93504
295	1	16	51	2552	2026-01-07 14:47:06.267347	193409
296	2	17	26	1536	2026-02-11 11:19:19.754159	164509
297	3	18	22	1176	2026-01-28 13:07:16.06218	67220
298	4	19	43	1300	2025-12-23 09:08:08.906708	157558
299	5	20	62	2565	2025-11-28 21:25:14.525915	14413
300	1	21	55	1247	2026-04-19 06:40:49.517193	67093
301	2	22	52	1134	2025-11-26 18:23:00.460386	100922
302	3	23	54	1088	2025-12-09 19:43:49.242925	184283
303	4	24	69	2958	2026-05-14 17:18:16.161914	141990
304	5	25	46	1634	2026-02-07 03:58:57.87502	83936
305	1	26	54	1728	2026-03-28 04:55:04.510401	11631
306	2	27	43	2537	2026-04-09 16:35:48.498728	154096
307	3	28	44	608	2026-01-27 23:36:39.534973	107295
308	4	29	68	2392	2026-05-18 23:05:58.092284	123170
309	5	30	58	740	2026-03-07 04:46:24.243035	83037
310	1	31	67	2440	2026-04-09 17:15:41.9324	53857
311	2	32	61	972	2026-03-23 12:15:32.733623	143898
312	3	33	39	1173	2026-01-16 18:45:55.932493	4204
313	4	34	28	1881	2026-02-14 06:39:21.732256	1
314	5	35	53	2592	2026-01-22 14:42:20.73761	133524
315	1	36	13	2139	2026-05-01 22:40:19.980289	11852
316	2	37	11	2860	2026-04-17 02:53:09.010786	98988
317	3	38	64	2970	2026-01-16 09:48:46.219785	20295
318	4	39	29	1504	2026-03-29 09:45:34.219167	159483
319	5	40	14	2726	2025-12-11 14:09:05.168239	48493
320	1	1	26	3520	2025-12-01 09:02:08.670253	103878
321	2	2	51	403	2026-03-26 16:47:14.968109	72904
322	3	3	51	1763	2026-04-19 09:18:46.602553	121588
323	4	4	17	2460	2025-12-26 09:27:42.086341	110813
324	5	5	50	2520	2025-12-17 02:12:35.4687	182358
325	1	6	31	1176	2026-02-07 22:47:45.299781	183123
326	2	7	44	1406	2025-12-12 20:09:41.326942	91008
327	3	8	42	875	2026-03-03 13:29:21.390167	125641
328	4	9	50	2310	2026-04-18 18:08:25.812798	125995
329	5	10	22	1568	2026-04-05 09:39:11.283313	98046
330	1	11	34	1904	2026-01-11 04:31:26.524003	66039
331	2	12	51	3417	2026-05-06 16:45:10.69429	160109
332	3	13	14	1890	2026-01-01 06:35:21.481436	100354
333	4	14	48	1645	2026-03-24 18:13:33.936328	5731
334	5	15	48	2632	2026-02-18 15:07:33.586707	65336
335	1	16	51	928	2026-01-15 22:36:45.696199	189941
336	2	17	28	2544	2026-01-22 18:29:09.876801	49419
337	3	18	25	2196	2025-12-20 00:28:44.963062	129425
338	4	19	66	2907	2026-02-01 06:34:30.320925	139277
339	5	20	49	1485	2025-11-24 09:11:58.851709	117162
340	1	21	14	837	2026-04-08 04:29:44.630758	79197
341	2	22	25	1980	2026-03-12 10:00:50.380733	112984
342	3	23	66	1204	2026-03-12 07:24:06.157343	165231
343	4	24	40	2160	2026-03-11 19:58:09.661234	169410
344	5	25	65	1890	2025-12-29 12:58:49.119797	153972
345	1	26	12	530	2026-01-12 19:30:14.559272	33355
346	2	27	53	450	2026-04-02 01:03:52.52919	193235
347	3	28	60	697	2026-03-19 12:16:25.052516	166055
348	4	29	19	828	2026-04-11 10:05:50.991427	94738
349	5	30	52	1064	2026-01-29 12:37:15.647135	128540
350	1	31	23	748	2026-02-26 18:12:52.171533	54472
351	2	32	61	1100	2026-02-28 23:05:53.811596	150994
352	3	33	11	1976	2026-01-21 09:39:13.34771	83541
353	4	34	18	2691	2026-03-27 22:35:49.034216	198588
354	5	35	27	855	2026-02-03 07:13:19.794154	37144
355	1	36	38	1088	2025-12-31 11:16:41.742307	94680
356	2	37	39	616	2026-02-16 05:41:30.155592	3081
357	3	38	31	636	2026-01-12 01:11:07.479899	144472
358	4	39	18	858	2026-05-15 23:15:02.342827	35517
359	5	40	50	1248	2026-01-17 21:42:28.871029	175968
360	1	1	21	2160	2025-12-12 16:58:03.564093	121287
361	2	2	59	1720	2026-02-20 15:23:03.204088	163487
362	3	3	27	1518	2026-04-25 20:44:43.976157	54076
363	4	4	45	1440	2026-02-28 19:43:28.108458	39369
364	5	5	52	972	2026-03-13 00:35:37.502853	130191
365	1	6	49	578	2026-01-16 21:32:20.942656	180018
366	2	7	59	867	2026-03-14 17:46:59.517438	79255
367	3	8	36	920	2026-03-11 16:23:33.419328	88722
368	4	9	59	2478	2025-12-17 23:04:13.20104	65858
369	5	10	27	403	2026-02-01 22:19:42.932478	158376
370	1	11	66	2646	2026-02-07 21:12:22.479115	102180
371	2	12	55	814	2025-11-30 18:57:47.558051	46828
372	3	13	46	2040	2026-01-05 09:05:50.793345	109697
373	4	14	65	1798	2026-01-25 14:51:09.920705	75041
374	5	15	29	2160	2026-04-24 00:25:26.151818	21013
375	1	16	27	2862	2026-01-06 12:51:19.336867	104069
376	2	17	23	1152	2026-01-28 20:11:16.971074	3873
377	3	18	35	2546	2026-02-16 18:13:27.553877	176288
378	4	19	29	2146	2026-01-21 18:48:31.659523	75950
379	5	20	37	2610	2025-12-18 13:18:30.626748	175307
380	1	21	38	1584	2025-12-06 06:24:44.658214	98804
381	2	22	26	624	2026-03-31 01:29:51.159271	160139
382	3	23	66	1961	2026-04-02 17:53:19.305602	853
383	4	24	38	864	2026-05-12 18:12:57.908829	88402
384	5	25	44	1128	2026-04-29 00:42:05.102475	130570
385	1	26	15	765	2025-12-16 14:36:45.901176	66924
386	2	27	30	1748	2025-12-13 22:24:11.11147	111451
387	3	28	37	1504	2026-04-25 07:53:12.01623	83297
388	4	29	51	1656	2026-04-23 06:53:52.232504	123810
389	5	30	63	2450	2026-01-20 11:26:52.737865	30110
390	1	31	49	1716	2025-12-10 16:35:48.934872	15101
391	2	32	51	1740	2026-02-11 14:33:52.896451	49857
392	3	33	47	2028	2025-12-24 04:39:48.852147	119880
393	4	34	68	992	2026-05-09 23:04:07.890948	111899
394	5	35	20	912	2026-01-28 12:43:43.092587	196948
395	1	36	27	2106	2026-04-03 05:43:00.751398	118827
396	2	37	10	1536	2026-05-13 01:25:38.529316	171947
397	3	38	47	1305	2026-02-28 16:09:56.399116	65413
398	4	39	45	330	2026-02-05 07:13:36.567553	151374
399	5	40	20	2703	2026-01-01 04:48:12.065953	55394
400	1	1	68	2856	2026-03-04 20:44:43.522325	27121
401	2	2	16	2808	2026-04-12 09:06:38.245359	30120
402	3	3	46	1890	2025-12-12 09:44:23.769261	199360
403	4	4	13	624	2026-04-17 15:36:59.048702	187163
404	5	5	41	2108	2026-03-22 13:25:16.554958	196228
405	1	6	63	1148	2026-01-01 17:09:50.469252	34626
406	2	7	16	2530	2025-12-19 13:41:23.777794	99268
407	3	8	23	564	2026-04-23 21:09:17.141598	196103
408	4	9	54	931	2026-01-10 00:34:06.762662	184038
409	5	10	49	1722	2026-01-22 02:11:17.791527	156359
410	1	11	29	2585	2026-03-12 21:29:50.085088	193481
411	2	12	48	2021	2026-05-06 09:37:06.558833	59765
412	3	13	17	1116	2026-04-27 07:41:44.524593	98285
413	4	14	26	1350	2026-03-30 19:02:16.877097	4989
414	5	15	46	2000	2026-05-16 16:29:52.136625	18462
415	1	16	17	1653	2025-12-04 18:48:54.312408	156767
416	2	17	24	1599	2026-04-08 12:29:35.000763	24343
417	3	18	10	1325	2026-05-02 05:13:04.896213	91809
418	4	19	66	3276	2025-12-02 19:51:42.35697	123747
419	5	20	33	480	2026-04-21 04:46:07.085001	138107
420	1	21	66	1848	2026-03-27 19:58:44.27127	77755
421	2	22	65	1656	2025-12-26 14:42:58.220297	193496
422	3	23	34	2065	2026-01-15 04:09:04.386011	65390
423	4	24	30	2310	2026-02-06 00:21:24.021595	194196
424	5	25	33	690	2025-12-15 04:29:21.278925	62823
425	1	26	55	1368	2025-12-10 07:36:55.171012	178090
426	2	27	28	2640	2026-05-04 20:26:13.182847	79802
427	3	28	32	2068	2025-12-19 23:03:12.058887	126129
428	4	29	61	1652	2026-03-11 22:10:42.754733	76980
429	5	30	20	468	2025-12-04 13:28:06.992198	13432
430	1	31	68	1024	2026-02-03 05:28:53.018206	119146
431	2	32	53	583	2026-02-05 05:47:59.857707	85194
432	3	33	40	1416	2026-01-11 07:04:00.398768	108521
433	4	34	36	3068	2026-02-05 12:54:44.667926	76767
434	5	35	52	1560	2026-01-03 12:04:17.191018	133510
435	1	36	43	1558	2025-11-24 13:10:50.905762	141935
436	2	37	16	1968	2025-12-09 02:18:38.07444	138318
437	3	38	65	2750	2026-03-31 08:52:11.223305	144631
438	4	39	33	2088	2026-04-30 09:54:41.505746	88659
439	5	40	40	3192	2026-05-06 12:15:41.061816	94604
440	1	1	55	774	2025-12-27 05:07:55.37707	119365
441	2	2	58	1081	2026-02-07 18:50:03.839379	36013
442	3	3	42	3021	2026-04-28 18:47:36.05404	45984
443	4	4	57	2401	2025-12-30 09:04:46.478793	45533
444	5	5	21	1512	2026-04-15 10:07:09.800189	180123
445	1	6	65	2090	2026-05-19 19:04:55.797184	127634
446	2	7	33	3360	2025-12-26 22:35:31.322298	114926
447	3	8	60	697	2026-02-19 22:27:43.674115	153913
448	4	9	46	2279	2025-11-26 05:09:19.30735	83537
449	5	10	31	2310	2026-04-03 00:14:39.570215	48973
450	1	11	20	3564	2026-02-05 09:37:47.847849	43542
451	2	12	58	2278	2026-01-03 07:50:02.781496	134661
452	3	13	49	1372	2026-02-24 14:55:08.943091	66744
453	4	14	26	2703	2026-01-04 03:13:36.178011	108524
454	5	15	57	2304	2026-02-15 09:37:32.550954	6066
455	1	16	40	680	2026-04-11 14:01:01.214244	199556
456	2	17	62	4071	2026-01-01 07:15:48.319916	103062
457	3	18	45	2484	2025-12-30 10:49:21.864885	138463
458	4	19	25	1485	2025-12-05 11:20:20.4146	164832
459	5	20	69	1739	2026-05-10 10:17:07.999644	138458
460	1	21	55	1558	2026-03-14 07:05:54.642515	126706
461	2	22	51	1088	2025-12-08 03:23:30.173923	54239
462	3	23	25	893	2026-02-16 07:49:25.455062	20034
463	4	24	16	580	2026-03-18 20:17:32.367981	85882
464	5	25	12	1696	2025-12-29 03:54:18.25794	68648
465	1	26	38	1288	2026-02-02 22:01:08.481924	14095
466	2	27	57	1000	2026-02-14 22:10:50.765188	16511
467	3	28	66	672	2025-12-22 21:53:41.365435	184069
468	4	29	39	3536	2026-02-21 10:02:21.075936	80998
469	5	30	25	385	2026-02-13 17:27:59.950676	91880
470	1	31	13	2009	2026-02-18 17:47:20.181952	180131
471	2	32	67	1596	2025-12-08 17:20:03.465362	81161
472	3	33	41	1872	2026-03-18 08:55:49.348282	60209
473	4	34	39	1833	2025-11-30 09:30:01.722865	49576
474	5	35	65	2160	2025-12-06 18:05:44.630347	98340
475	1	36	57	3422	2026-03-30 16:41:04.651662	4328
476	2	37	47	1080	2026-05-13 12:01:51.516813	132664
477	3	38	58	600	2026-03-29 18:55:46.284104	27570
478	4	39	39	1710	2025-12-13 01:17:59.34705	197605
479	5	40	26	858	2026-05-04 00:37:13.898779	145119
480	1	1	17	1044	2026-01-23 20:07:28.41298	155344
481	2	2	33	1176	2025-12-07 17:41:21.501128	138557
482	3	3	21	1120	2026-03-13 15:55:02.0651	49533
483	4	4	22	495	2026-03-07 00:55:28.44569	158184
484	5	5	51	3944	2026-03-15 16:56:46.734049	49408
485	1	6	55	1767	2026-04-24 17:06:29.190358	59391
486	2	7	30	2703	2026-02-08 03:21:24.456738	38488
487	3	8	62	4002	2025-11-28 20:47:33.401145	155203
488	4	9	65	1938	2026-02-24 22:27:20.012638	31561
489	5	10	44	2967	2026-01-01 13:02:33.341552	67622
490	1	11	52	2160	2026-03-24 08:09:24.967022	38360
491	2	12	60	1920	2026-02-27 21:54:34.767705	27598
492	3	13	68	1377	2026-04-09 12:25:33.996831	146287
493	4	14	41	2184	2026-03-02 02:37:07.913803	139739
494	5	15	68	2052	2026-04-25 06:20:47.144391	151714
495	1	16	23	1914	2026-05-13 02:43:51.444967	170469
496	2	17	68	1176	2025-12-31 08:35:57.097687	97900
497	3	18	39	1558	2026-02-03 23:15:47.225105	31970
498	4	19	30	858	2026-01-18 12:24:48.287902	59963
499	5	20	26	1890	2025-12-31 02:13:05.550372	195602
500	1	21	64	3618	2026-04-03 16:23:19.23858	7279
501	2	22	63	1716	2025-12-10 12:55:11.075556	90495
502	3	23	28	1288	2026-01-09 18:36:51.175985	64219
503	4	24	57	2242	2026-02-18 19:11:26.972856	131545
504	5	25	19	658	2026-04-25 23:22:17.055739	47087
505	1	26	43	1081	2026-04-08 08:30:08.49508	5893
506	2	27	12	615	2026-02-04 10:27:36.026527	89583
507	3	28	22	3312	2026-03-23 15:35:50.341507	151102
508	4	29	31	2132	2026-05-01 12:54:39.965113	180412
509	5	30	49	2583	2025-12-14 17:01:56.985872	104220
510	1	31	18	1080	2026-05-03 05:23:51.966285	152982
511	2	32	53	1014	2025-12-17 13:43:58.259496	172344
512	3	33	42	1225	2026-03-09 09:30:23.928596	59532
513	4	34	66	2170	2025-12-02 01:07:08.935262	169857
514	5	35	13	1380	2026-05-03 09:48:50.201074	16087
515	1	36	27	720	2026-05-11 05:57:45.858365	118329
516	2	37	18	1204	2026-01-22 06:17:47.462902	53898
517	3	38	58	3618	2026-03-31 17:08:28.851054	80025
518	4	39	49	2160	2026-05-14 00:42:22.271958	180454
519	5	40	52	1804	2026-01-16 05:16:44.001204	36001
520	1	1	37	3417	2025-12-27 15:02:12.52551	136668
521	2	2	16	2405	2026-02-17 21:16:44.974941	95615
522	3	3	64	527	2026-02-24 09:20:12.952669	161198
523	4	4	43	3712	2026-03-15 12:04:40.736485	109892
524	5	5	61	704	2026-01-28 12:10:33.779954	99300
525	1	6	52	2700	2026-01-15 06:38:26.918755	19887
526	2	7	47	3245	2026-05-04 17:16:35.160312	423
527	3	8	18	1160	2025-12-01 20:15:31.282419	35251
528	4	9	56	2074	2026-05-17 02:44:41.115324	91612
529	5	10	30	720	2026-03-27 23:37:59.20389	57685
530	1	11	68	990	2026-04-02 01:56:37.810882	56786
531	2	12	54	2430	2026-02-26 13:06:11.943123	5404
532	3	13	45	2254	2026-03-16 10:00:25.04228	124701
533	4	14	30	2829	2026-01-27 22:25:37.508072	93723
534	5	15	47	2016	2026-04-13 16:17:40.044835	176832
535	1	16	18	720	2026-02-21 15:34:47.367851	40295
536	2	17	65	1558	2026-04-09 00:20:15.928116	106271
537	3	18	61	2090	2026-03-23 04:45:20.452787	152820
538	4	19	67	3100	2026-02-21 00:56:38.225248	108343
539	5	20	19	3484	2026-03-27 10:27:10.320039	127358
540	1	21	65	2360	2025-12-30 12:51:51.634728	6640
541	2	22	59	3776	2026-05-11 18:15:47.281878	663
542	3	23	55	3400	2025-12-31 01:33:04.151236	53331
543	4	24	45	931	2026-04-26 08:33:11.726411	49610
544	5	25	51	2604	2026-02-23 14:47:43.164696	58856
545	1	26	37	2499	2026-02-03 17:40:55.450036	11514
546	2	27	12	3596	2025-12-22 12:56:08.256112	90831
547	3	28	37	2106	2025-12-23 00:27:45.656812	157178
548	4	29	14	1728	2025-12-14 15:25:14.328009	55753
549	5	30	57	2173	2026-05-13 14:20:54.473391	117563
550	1	31	40	1100	2026-01-05 23:21:16.566272	141927
551	2	32	12	2295	2026-01-21 09:12:45.229031	86655
552	3	33	40	3000	2026-03-04 11:06:31.444369	151044
553	4	34	32	930	2026-03-27 04:44:46.876738	155237
554	5	35	14	1755	2026-02-16 17:50:19.189275	26802
555	1	36	58	1368	2026-02-06 13:24:30.64277	116720
556	2	37	28	1500	2026-05-02 06:56:58.628926	77339
557	3	38	20	1881	2025-12-19 16:44:49.436245	183822
558	4	39	23	320	2025-12-14 08:28:19.020192	28353
559	5	40	15	2772	2026-04-22 00:42:12.653499	140915
560	1	1	43	1978	2026-03-01 19:49:58.637576	56297
561	2	2	18	384	2026-05-16 21:05:16.403877	167533
562	3	3	11	2592	2026-02-25 16:11:39.416121	72368
563	4	4	37	3740	2026-01-15 13:12:34.353892	76417
564	5	5	40	767	2026-04-07 20:07:49.626391	124477
565	1	6	66	1035	2026-05-12 19:22:35.751934	81944
566	2	7	69	1368	2026-04-11 15:48:55.030089	182435
567	3	8	17	1062	2026-01-02 23:27:07.954288	91270
568	4	9	35	2350	2025-11-27 23:02:09.365997	103689
569	5	10	62	1968	2025-12-25 12:58:55.76479	115064
570	1	11	31	705	2026-01-01 12:23:26.105762	169032
571	2	12	26	2346	2025-12-05 15:30:48.69302	140197
572	3	13	42	1296	2026-01-03 16:32:44.985745	25371
573	4	14	67	1323	2026-03-15 09:28:17.043135	61695
574	5	15	62	992	2026-02-21 08:31:24.898502	72662
575	1	16	66	1998	2025-11-25 12:56:04.919792	141172
576	2	17	19	1000	2026-01-21 04:07:15.055095	126115
577	3	18	34	2597	2026-03-10 07:04:25.335499	16133
578	4	19	12	2520	2025-11-27 02:39:57.995056	23778
579	5	20	10	1215	2026-05-09 11:10:46.139984	142569
580	1	21	22	1482	2026-03-21 21:11:25.367624	89081
581	2	22	12	2520	2026-04-13 08:03:23.6321	29692
582	3	23	33	2244	2025-12-20 15:18:37.427975	84261
583	4	24	26	848	2026-03-02 17:42:16.268632	145342
584	5	25	13	2950	2026-02-03 02:11:07.632719	166441
585	1	26	52	2928	2026-01-18 04:49:51.46309	67449
586	2	27	14	962	2025-12-23 12:07:06.102872	144081
587	3	28	58	837	2026-04-09 23:46:07.681861	80020
588	4	29	55	2183	2026-04-23 12:43:31.525822	93375
589	5	30	46	2170	2026-01-26 00:50:35.828666	102104
590	1	31	21	1363	2026-04-19 09:21:04.872326	145443
591	2	32	63	1728	2026-04-14 13:48:13.587102	121808
592	3	33	48	520	2026-03-05 14:18:45.129354	104245
593	4	34	66	2706	2026-01-20 16:23:25.896944	48287
594	5	35	21	935	2026-03-22 21:13:45.15232	120719
595	1	36	63	775	2026-01-08 21:03:54.297948	148329
596	2	37	27	2204	2026-01-16 03:49:38.883573	124959
597	3	38	53	408	2026-04-20 19:42:12.790213	95894
598	4	39	36	559	2026-03-11 05:55:29.579696	22506
599	5	40	12	480	2026-03-04 15:43:29.390727	66952
600	1	1	38	3468	2026-03-14 10:21:41.69404	1527
601	2	2	23	2438	2025-12-30 02:07:58.225791	40853
602	3	3	29	3588	2026-05-20 19:15:55.651774	119502
603	4	4	57	1360	2026-03-13 19:02:32.726348	36736
604	5	5	62	1443	2026-04-10 08:55:46.551393	128563
605	1	6	32	2072	2026-04-25 16:40:59.865254	39758
606	2	7	33	2244	2026-03-06 20:12:01.357237	19513
607	3	8	38	578	2026-02-02 20:20:19.878047	63263
608	4	9	26	3672	2025-12-26 08:49:49.710132	192893
609	5	10	62	2880	2025-12-03 22:08:27.614039	116879
610	1	11	65	1932	2026-03-02 13:47:02.596262	109634
611	2	12	31	2745	2025-12-25 17:05:17.384631	10886
612	3	13	34	1160	2026-02-22 21:48:48.882032	23259
613	4	14	57	1978	2026-03-30 22:50:49.297329	3464
614	5	15	68	2040	2026-03-29 07:45:49.478721	155975
615	1	16	10	2450	2025-12-27 09:48:47.350148	131314
616	2	17	25	3132	2025-12-03 10:53:56.658294	81178
617	3	18	18	2250	2026-05-11 01:24:19.440916	56745
618	4	19	47	1364	2026-01-13 22:49:53.456091	46269
619	5	20	63	1188	2025-12-07 08:01:39.009033	90211
620	1	21	28	2860	2025-12-24 19:41:33.950009	97957
621	2	22	59	1680	2026-01-06 14:16:10.375909	178142
622	3	23	28	1881	2025-12-26 08:30:01.10133	34695
623	4	24	63	2352	2026-03-14 18:05:58.307626	158886
624	5	25	66	1368	2026-01-16 06:32:25.640157	183004
625	1	26	25	1536	2026-03-16 22:07:19.645977	132673
626	2	27	58	2940	2026-04-24 22:03:47.146522	21773
627	3	28	12	1260	2025-12-15 08:36:32.570553	45890
628	4	29	38	2295	2026-03-02 01:25:03.35349	185455
629	5	30	36	1978	2026-02-08 11:56:25.750609	168115
630	1	31	52	2052	2026-04-20 02:00:21.362144	176651
631	2	32	29	2090	2026-02-27 14:24:05.14869	65854
632	3	33	66	1330	2026-02-06 00:26:28.333447	192863
633	4	34	49	2209	2026-01-14 14:30:37.90693	18029
634	5	35	68	936	2026-01-20 15:14:53.514367	163567
635	1	36	22	825	2026-03-09 12:15:08.129274	192927
636	2	37	27	2990	2026-01-01 17:47:31.307553	146424
637	3	38	41	330	2026-04-09 22:39:15.356475	102826
638	4	39	57	2254	2026-04-06 14:29:57.929215	93858
639	5	40	56	1085	2025-11-29 12:50:13.29434	101112
640	1	1	69	1350	2025-12-02 13:43:01.495404	47525
641	2	2	59	1920	2026-01-24 02:16:24.698003	175106
642	3	3	50	2268	2026-02-17 23:55:18.92371	56181
643	4	4	59	888	2026-03-18 16:11:26.587074	193025
644	5	5	29	2610	2026-01-08 13:30:24.584923	59275
645	1	6	25	2805	2026-02-23 07:41:54.105528	40662
646	2	7	33	2304	2025-11-28 00:51:53.827614	146476
647	3	8	53	1330	2026-04-27 18:56:39.249048	184607
648	4	9	22	1519	2026-04-12 06:34:10.441857	193757
649	5	10	43	1333	2026-01-24 06:08:44.99176	149896
650	1	11	10	3400	2026-01-12 22:03:29.819627	67808
651	2	12	28	3036	2026-02-06 06:33:40.34683	2013
652	3	13	58	702	2026-05-02 10:41:10.746749	139907
653	4	14	17	3132	2026-04-05 19:26:31.309108	41288
654	5	15	58	1656	2026-05-13 05:22:33.825839	55907
655	1	16	57	680	2026-01-07 19:45:00.707179	173523
656	2	17	35	403	2026-01-21 04:15:33.273561	17086
657	3	18	19	1350	2026-05-10 02:58:48.432971	124495
658	4	19	29	480	2026-03-06 10:44:42.521737	34732
659	5	20	21	931	2026-01-01 23:23:39.333341	9201
660	1	21	10	2550	2026-01-10 11:02:56.594568	128296
661	2	22	47	1408	2025-12-10 01:28:38.80241	29311
662	3	23	54	1728	2026-05-14 22:31:36.159276	154463
663	4	24	48	1760	2026-03-23 15:59:07.603888	83809
664	5	25	57	3234	2025-12-14 04:32:20.154478	188203
665	1	26	47	2028	2025-12-25 11:48:47.840775	48708
666	2	27	63	492	2026-05-17 11:03:19.116704	88003
667	3	28	47	4012	2025-11-30 19:36:32.629526	159329
668	4	29	58	1365	2026-04-09 10:45:59.120531	74016
669	5	30	50	504	2026-03-12 01:21:36.6939	22000
670	1	31	31	2912	2025-11-30 12:59:27.532837	107093
671	2	32	18	2898	2026-03-13 08:06:09.631489	32799
672	3	33	36	920	2026-03-21 03:06:50.843775	36118
673	4	34	57	1155	2025-12-07 20:28:27.611715	81545
674	5	35	14	2079	2026-05-06 19:07:36.912856	69219
675	1	36	33	3416	2026-02-20 20:35:06.509186	5956
676	2	37	54	1326	2026-02-15 07:03:17.614227	181485
677	3	38	10	2752	2026-01-03 17:12:17.918254	186017
678	4	39	48	340	2026-01-15 22:58:52.297849	1100
679	5	40	10	972	2026-04-30 01:45:02.127249	151897
680	1	1	43	2304	2026-04-14 17:52:22.427563	124932
681	2	2	59	3808	2026-05-10 13:03:45.014005	21438
682	3	3	33	3400	2026-05-09 10:36:20.490307	104670
683	4	4	20	2992	2026-03-14 06:11:55.304448	29268
684	5	5	65	3190	2026-01-18 03:00:06.503362	35870
685	1	6	11	2499	2026-05-06 06:42:32.630645	172671
686	2	7	14	690	2026-03-15 20:24:05.797205	138925
687	3	8	47	1785	2026-02-01 23:38:17.777892	184498
688	4	9	44	2080	2026-04-14 07:54:34.816342	121472
689	5	10	67	2448	2026-03-18 18:26:15.795636	106516
690	1	11	28	1482	2025-12-12 14:37:58.820062	131551
691	2	12	24	885	2026-01-20 03:50:44.015024	76341
692	3	13	21	2296	2025-12-26 20:38:58.654858	34430
693	4	14	61	1054	2025-12-19 03:23:20.647481	96029
694	5	15	15	3648	2026-05-09 23:11:08.646607	95080
695	1	16	13	2279	2025-12-16 17:42:30.581894	53300
696	2	17	43	2352	2026-04-05 23:50:44.285496	97290
697	3	18	53	2166	2026-03-11 06:06:35.821575	5052
698	4	19	17	3294	2026-04-25 14:03:54.590249	124177
699	5	20	32	3528	2025-11-27 18:43:31.412178	46595
700	1	21	29	572	2026-04-26 22:22:02.40692	26863
701	2	22	55	1320	2026-05-13 06:50:41.233725	175592
702	3	23	45	2337	2026-05-19 19:36:48.774267	104358
703	4	24	29	912	2026-03-02 22:58:44.142969	95215
704	5	25	41	2124	2026-02-07 16:01:29.990898	153470
705	1	26	56	820	2025-12-19 02:25:32.026032	77674
706	2	27	12	3538	2026-05-17 19:16:22.593166	130236
707	3	28	15	2115	2026-01-04 10:17:20.814034	79067
708	4	29	53	2091	2026-03-07 01:28:58.323402	73708
709	5	30	12	1406	2026-05-21 05:29:07.06075	128042
710	1	31	58	2150	2026-02-24 21:12:10.275449	109506
711	2	32	30	1702	2026-03-22 13:30:10.490839	89385
712	3	33	56	798	2026-04-27 19:36:29.643119	198903
713	4	34	60	440	2026-05-10 04:41:18.445834	173555
714	5	35	24	1056	2026-04-15 05:56:30.078162	155653
715	1	36	38	492	2026-01-29 08:41:18.760926	58730
716	2	37	54	3216	2025-12-30 17:41:24.354524	115813
717	3	38	20	1677	2026-03-10 02:45:02.956436	57608
718	4	39	51	2160	2025-12-03 10:15:10.012149	163672
719	5	40	13	912	2026-02-02 00:04:30.020194	69910
720	1	1	54	2464	2025-12-27 11:09:48.109292	145294
721	2	2	45	611	2026-01-24 09:43:19.562026	64536
722	3	3	26	1088	2026-03-16 23:19:56.33769	91659
723	4	4	19	2565	2026-02-12 16:35:02.311457	77893
724	5	5	29	1519	2026-01-16 13:14:12.282968	105399
725	1	6	31	468	2026-04-06 12:43:28.642424	105714
726	2	7	32	396	2026-05-21 02:57:12.50304	68523
727	3	8	18	3762	2025-12-06 12:02:19.322156	166985
728	4	9	59	3534	2025-12-13 06:43:15.553785	40933
729	5	10	67	2788	2026-05-06 17:21:53.118879	59091
730	1	11	51	1734	2026-02-26 21:15:19.66994	14504
731	2	12	66	1900	2025-12-07 16:14:50.716028	45690
732	3	13	67	2709	2026-01-19 11:47:38.342196	197652
733	4	14	50	1672	2026-05-15 18:16:31.216014	163899
734	5	15	53	868	2026-02-14 11:02:12.546539	182616
735	1	16	49	624	2026-04-25 03:45:18.277611	41469
736	2	17	66	1813	2025-12-12 16:42:15.50479	95998
737	3	18	41	611	2026-03-19 20:54:28.344689	170441
738	4	19	14	1435	2025-12-07 01:35:16.380003	149033
739	5	20	68	2035	2026-03-07 16:55:14.466514	73573
740	1	21	45	2808	2025-12-03 05:50:05.051895	104589
741	2	22	33	520	2026-05-14 14:40:23.398758	19741
742	3	23	27	2704	2026-02-27 23:21:44.009962	198845
743	4	24	42	1944	2026-01-31 08:42:22.383467	62483
744	5	25	17	1920	2026-01-01 13:57:27.987342	194166
745	1	26	60	1288	2026-02-14 06:44:34.793384	161155
746	2	27	56	2160	2026-01-30 04:48:30.55078	140729
747	3	28	56	1254	2025-12-10 04:41:11.454692	40813
748	4	29	64	448	2026-03-27 20:31:00.385642	32495
749	5	30	50	533	2026-01-14 18:21:55.25738	175960
750	1	31	49	2016	2026-03-10 00:36:32.872115	92529
751	2	32	44	3192	2025-11-25 10:54:15.884855	20137
752	3	33	41	2279	2026-05-05 15:59:09.295113	24593
753	4	34	17	1664	2026-01-05 00:27:50.400535	138840
754	5	35	62	1650	2026-04-06 16:36:30.408235	184617
755	1	36	26	2709	2026-04-17 20:09:30.576813	164111
756	2	37	58	1904	2026-02-09 20:06:46.374934	190795
757	3	38	65	820	2026-03-11 18:53:23.750713	152601
758	4	39	28	2597	2026-05-06 02:20:59.582863	31366
759	5	40	29	1900	2026-02-11 13:51:13.47135	121113
760	1	1	15	1333	2025-12-26 10:08:55.680261	199091
761	2	2	23	1056	2025-12-25 11:03:42.378828	117049
762	3	3	32	3381	2026-01-09 14:13:21.501277	195388
763	4	4	10	1260	2026-01-13 07:11:06.068975	71625
764	5	5	46	1326	2026-01-12 17:19:07.64281	178031
765	1	6	63	2773	2026-04-25 15:25:44.37955	100508
766	2	7	52	2080	2026-05-14 22:36:04.949963	142887
767	3	8	65	864	2025-12-30 00:51:03.098995	26153
768	4	9	34	2337	2026-04-21 21:21:55.08613	41261
769	5	10	47	1830	2026-03-25 13:37:10.720155	57370
770	1	11	56	3172	2025-12-23 08:47:15.870639	172614
771	2	12	34	2968	2026-05-05 14:08:03.65708	186015
772	3	13	10	2160	2026-05-01 19:35:45.805406	158645
773	4	14	31	2736	2026-01-13 10:27:16.786933	25376
774	5	15	51	1554	2026-03-14 16:32:26.140143	116892
775	1	16	28	2560	2026-05-08 10:18:37.341877	150511
776	2	17	20	2754	2025-12-02 14:55:49.672172	128184
777	3	18	61	636	2026-02-09 03:06:33.579166	43227
778	4	19	13	3835	2026-01-28 07:28:55.232156	125522
779	5	20	62	1710	2026-05-18 10:15:00.92499	102487
780	1	21	52	1558	2025-12-29 16:47:11.593296	29764
781	2	22	62	3024	2026-02-15 17:44:23.938622	54375
782	3	23	34	1056	2025-11-30 01:49:42.310497	49101
783	4	24	43	1014	2026-02-12 20:33:52.627568	31111
784	5	25	41	2226	2025-11-30 13:27:58.127652	151189
785	1	26	62	2108	2026-01-22 23:53:09.517232	173175
786	2	27	31	1258	2026-01-31 19:57:05.310842	168518
787	3	28	18	3009	2025-12-19 20:26:13.259057	63462
788	4	29	25	576	2026-01-01 23:34:22.013443	92885
789	5	30	20	1610	2026-05-08 02:14:02.463219	21907
790	1	31	53	1794	2025-12-29 08:35:04.370426	111504
791	2	32	65	2142	2026-01-06 23:10:20.525328	116918
792	3	33	60	2881	2026-03-23 00:55:48.589533	88164
793	4	34	21	2240	2025-12-24 01:32:38.184602	120042
794	5	35	19	1457	2026-05-15 08:24:33.210396	87482
795	1	36	58	986	2026-01-21 15:53:17.363493	109787
796	2	37	34	1458	2026-02-02 02:26:38.153513	173180
797	3	38	53	1974	2026-03-23 14:33:04.502211	174439
798	4	39	63	2442	2026-05-13 01:46:28.439394	90785
799	5	40	58	2378	2026-04-09 16:58:27.813292	11269
800	1	1	15	2120	2025-12-05 10:27:13.257759	10340
801	2	2	14	1908	2025-12-25 05:32:07.662252	184625
802	3	3	45	2552	2026-04-15 09:42:01.642808	59052
803	4	4	50	456	2026-02-13 07:16:28.989832	2465
804	5	5	60	1472	2026-03-14 11:43:03.658566	33600
805	1	6	34	403	2026-02-09 10:59:28.379027	71113
806	2	7	50	910	2026-04-02 08:52:46.534453	101051
807	3	8	65	2288	2026-01-15 11:39:12.56357	14562
808	4	9	33	1334	2026-01-21 14:16:24.861047	119833
809	5	10	22	768	2026-04-13 02:57:52.916192	182091
810	1	11	65	2958	2026-04-12 22:01:01.317788	79661
811	2	12	43	429	2026-03-06 11:18:49.11855	95443
812	3	13	69	3276	2026-01-10 15:43:12.236212	60605
813	4	14	24	630	2026-04-04 10:23:25.656264	108430
814	5	15	65	3315	2026-03-22 08:17:31.342627	195025
815	1	16	30	507	2026-01-20 21:01:05.186173	75031
816	2	17	58	1485	2026-04-05 05:13:26.432073	39609
817	3	18	26	2967	2025-12-13 15:50:15.461266	146999
818	4	19	36	2303	2026-04-25 05:27:01.373283	85905
819	5	20	30	1350	2026-02-20 09:33:57.330616	110413
820	1	21	19	1176	2026-03-09 17:10:38.038299	10813
821	2	22	22	1593	2026-04-21 03:04:36.798364	15884
822	3	23	16	418	2026-03-07 10:19:36.313363	190650
823	4	24	25	1944	2026-02-08 20:51:53.323573	15235
824	5	25	12	1060	2025-12-11 11:07:08.627996	74262
825	1	26	58	3540	2026-03-16 10:33:23.337399	91937
826	2	27	40	2475	2026-03-04 04:30:34.595483	159904
827	3	28	32	660	2026-03-11 00:36:57.245858	157414
828	4	29	42	2016	2025-12-05 07:13:56.455565	196411
829	5	30	52	2928	2026-01-02 03:09:22.941654	26870
830	1	31	35	946	2025-12-03 05:24:20.045062	156626
831	2	32	67	1617	2025-12-15 03:25:55.644484	199829
832	3	33	15	396	2026-02-10 12:50:11.276334	4417
833	4	34	48	1333	2026-05-10 12:08:03.891661	103024
834	5	35	54	1100	2026-04-29 06:30:13.722148	166470
835	1	36	69	777	2026-05-19 12:16:27.085981	158363
836	2	37	26	1221	2026-05-01 18:29:28.371194	149351
837	3	38	46	1144	2026-01-27 07:58:56.279673	194111
838	4	39	63	1118	2026-05-04 06:15:37.422256	188268
839	5	40	15	2160	2026-01-17 12:18:16.754558	149367
840	1	1	35	2585	2026-02-19 23:39:36.293026	182654
841	2	2	33	1558	2026-01-13 01:45:54.344473	77321
842	3	3	47	1015	2026-03-14 18:00:12.440664	175159
843	4	4	49	799	2025-12-14 13:05:12.400586	87472
844	5	5	50	2640	2026-02-04 16:14:57.035701	107274
845	1	6	40	2793	2026-03-18 08:45:38.0478	197218
846	2	7	13	980	2026-04-06 05:43:09.271972	13336
847	3	8	43	2107	2026-05-05 20:06:41.807837	151046
848	4	9	66	1749	2026-05-15 20:07:02.606737	70421
849	5	10	37	2600	2025-11-30 20:55:16.819832	88696
850	1	11	15	2576	2025-12-05 08:58:25.963918	69354
851	2	12	55	1406	2026-04-07 22:17:40.117242	134558
852	3	13	17	2860	2025-11-25 16:47:32.744061	8305
853	4	14	30	2040	2026-04-13 09:31:15.218485	71352
854	5	15	59	1350	2025-11-24 08:13:29.591142	66040
855	1	16	66	1886	2026-05-01 08:11:06.538093	42205
856	2	17	11	1394	2025-12-15 10:34:39.940479	64518
857	3	18	68	1640	2026-04-26 01:13:17.465896	14810
858	4	19	14	1512	2026-01-31 02:35:12.749363	186428
859	5	20	40	3304	2026-01-10 15:54:41.396361	161807
860	1	21	69	2024	2025-12-17 20:57:57.379913	28788
861	2	22	20	624	2025-11-29 16:16:38.056477	37381
862	3	23	47	1767	2026-01-12 10:20:24.577264	193259
863	4	24	35	1584	2026-01-29 08:13:09.638248	169100
864	5	25	15	1947	2025-12-23 10:35:45.241461	59449
865	1	26	61	1287	2026-04-21 06:21:45.763704	44209
866	2	27	64	4002	2026-01-22 07:31:07.646313	118329
867	3	28	46	1505	2025-12-10 19:16:42.819675	181650
868	4	29	49	1224	2026-04-01 15:40:52.691001	124376
869	5	30	60	3078	2026-01-15 16:06:19.043958	146521
870	1	31	15	1598	2025-11-23 17:03:36.554974	140159
871	2	32	69	2948	2026-03-08 21:48:18.470895	101891
872	3	33	28	1925	2026-03-16 02:20:30.556001	85845
873	4	34	13	2754	2025-12-26 22:33:09.527309	135393
874	5	35	52	2912	2026-02-05 21:18:01.193953	145266
875	1	36	24	2976	2026-01-07 10:11:05.053886	158702
876	2	37	13	2108	2026-02-04 16:06:07.111098	158173
877	3	38	35	1862	2026-01-30 16:32:02.855039	82117
878	4	39	59	3016	2026-03-03 06:51:12.374695	8748
879	5	40	68	1452	2026-01-01 20:36:34.722108	37088
880	1	1	50	2296	2026-03-08 14:43:02.992561	199006
881	2	2	43	1680	2026-03-08 23:40:43.425808	90989
882	3	3	61	341	2026-04-11 13:56:37.370867	65997
883	4	4	48	2601	2026-03-15 22:55:45.413224	28945
884	5	5	49	2139	2026-02-22 19:04:35.831658	7066
885	1	6	52	2867	2026-02-14 23:05:11.945273	67195
886	2	7	37	1880	2025-12-05 08:48:42.950083	80001
887	3	8	60	1287	2025-12-01 16:08:05.102712	124841
888	4	9	68	1568	2025-12-22 22:32:28.025581	10065
889	5	10	30	1872	2026-04-09 03:08:15.008616	168153
890	1	11	19	3213	2026-03-31 04:01:56.204818	82820
891	2	12	48	468	2026-01-24 18:09:28.049238	169319
892	3	13	41	2220	2026-02-05 12:41:01.116836	113604
893	4	14	17	640	2026-02-18 20:28:23.268851	86596
894	5	15	51	2814	2025-11-29 04:13:10.003648	7556
895	1	16	14	2448	2026-01-06 19:12:17.345808	85342
896	2	17	45	2120	2026-05-15 13:25:18.004019	169432
897	3	18	22	588	2025-12-15 03:55:42.389867	8375
898	4	19	63	2976	2026-05-15 06:19:27.317257	195291
899	5	20	40	1440	2026-05-04 21:57:03.79547	4961
900	1	21	34	2747	2026-01-27 00:01:31.544525	96474
901	2	22	45	3584	2026-03-14 08:20:26.796236	43736
902	3	23	46	840	2026-03-29 20:40:23.652892	45012
903	4	24	57	1800	2026-01-12 08:46:29.098277	172893
904	5	25	25	2030	2026-01-04 22:15:11.560763	138707
905	1	26	41	1500	2025-12-07 21:02:45.803059	104939
906	2	27	50	1290	2026-02-19 21:10:17.75894	72249
907	3	28	44	3328	2026-01-13 17:00:12.597979	47594
908	4	29	16	1702	2026-02-03 06:42:13.731654	93649
909	5	30	29	1632	2026-01-16 01:06:38.6023	141629
910	1	31	17	1980	2026-05-11 07:11:41.507499	112628
911	2	32	39	1254	2026-02-07 08:16:40.377252	85462
912	3	33	60	3111	2026-03-10 07:11:25.094757	127114
913	4	34	22	1551	2026-01-22 02:32:18.980538	91756
914	5	35	51	3009	2026-02-10 14:39:33.240712	147881
915	1	36	14	987	2026-02-14 20:57:35.022024	174198
916	2	37	11	2332	2026-05-13 03:33:39.977049	112804
917	3	38	12	2756	2026-02-02 01:04:23.015657	186057
918	4	39	62	2209	2025-12-11 15:27:54.446266	73678
919	5	40	12	2303	2025-12-18 01:56:25.51755	174556
920	1	1	51	1925	2026-01-02 11:49:06.293678	18124
921	2	2	29	2072	2026-01-13 00:32:25.240604	101146
922	3	3	47	1800	2026-03-11 17:26:54.312727	42949
923	4	4	22	574	2025-11-24 22:28:05.400999	194268
924	5	5	66	828	2026-02-23 01:41:13.771957	152856
925	1	6	20	2968	2026-01-06 17:06:36.990183	154565
926	2	7	69	1419	2026-02-21 12:15:24.121302	14835
927	3	8	51	1927	2026-01-05 15:47:56.42333	93363
928	4	9	36	1518	2026-01-16 23:37:42.929714	124853
929	5	10	47	2475	2026-02-20 00:40:41.794706	106254
930	1	11	61	1425	2026-03-12 18:16:47.718442	175515
931	2	12	57	2688	2026-02-10 12:45:03.488078	177316
932	3	13	54	1344	2026-01-19 14:25:08.962651	182669
933	4	14	68	1260	2026-01-10 14:23:01.45591	196473
934	5	15	54	882	2026-03-18 21:35:45.594202	89792
935	1	16	22	817	2025-12-03 11:14:13.652905	54390
936	2	17	37	1426	2025-11-26 00:21:14.105191	175934
937	3	18	69	629	2026-01-14 11:40:06.844698	28047
938	4	19	24	1239	2026-03-17 04:02:28.534712	67934
939	5	20	36	1802	2026-05-15 06:49:27.448262	171884
940	1	21	66	540	2026-04-12 05:05:49.774687	159003
941	2	22	32	988	2026-01-26 09:30:55.784981	34506
942	3	23	46	3216	2026-02-09 22:16:05.59747	23308
943	4	24	46	1550	2025-12-15 02:15:43.534275	91502
944	5	25	27	2009	2026-03-30 11:35:32.249415	5576
945	1	26	53	1551	2025-11-30 08:44:09.253365	192704
946	2	27	54	1953	2026-05-05 18:18:58.188847	25350
947	3	28	59	1496	2025-12-13 05:57:20.710371	124559
948	4	29	59	2808	2025-12-23 01:55:32.355388	88043
949	5	30	37	1944	2026-02-06 05:23:30.40627	23115
950	1	31	28	2052	2026-02-26 01:29:12.819835	36426
951	2	32	34	2070	2025-12-11 13:54:10.971702	48652
952	3	33	51	3551	2026-01-27 04:19:38.805114	122028
953	4	34	42	2924	2026-04-25 22:08:41.776369	68626
954	5	35	41	3068	2026-03-15 16:45:33.876195	152347
955	1	36	11	3328	2025-11-28 18:50:22.133617	49230
956	2	37	13	2079	2026-05-11 07:01:44.124404	16198
957	3	38	60	600	2025-12-11 22:37:51.305099	55203
958	4	39	42	1008	2026-04-24 10:18:31.269463	94884
959	5	40	21	2475	2026-02-18 15:21:14.176452	59212
960	1	1	26	1054	2026-03-07 00:34:40.121096	46878
961	2	2	59	420	2026-05-16 13:15:13.440901	3122
962	3	3	54	920	2026-05-05 13:30:53.435048	103799
963	4	4	39	2009	2026-02-11 05:30:47.205765	186429
964	5	5	69	1750	2025-12-19 18:31:54.687559	182891
965	1	6	14	2301	2026-03-15 16:22:20.341352	161337
966	2	7	32	1848	2026-05-16 14:11:28.647684	156991
967	3	8	28	1944	2026-02-26 04:28:58.071384	103984
968	4	9	58	558	2025-12-20 12:50:02.545736	112424
969	5	10	40	2842	2026-05-16 23:42:34.505165	52890
970	1	11	13	1848	2026-03-12 12:16:16.610876	24481
971	2	12	17	2640	2026-01-03 15:09:22.983289	178374
972	3	13	23	2695	2026-01-29 00:35:22.845647	35658
973	4	14	49	2520	2026-04-20 18:37:31.641711	111703
974	5	15	24	1196	2026-04-30 05:18:44.845935	89026
975	1	16	54	840	2025-12-19 18:35:53.967	151003
976	2	17	10	3264	2026-05-14 01:06:30.875707	197238
977	3	18	28	3102	2026-03-28 10:39:48.198982	187253
978	4	19	16	1705	2026-04-12 16:59:45.201023	180934
979	5	20	24	2835	2026-03-03 11:58:05.993948	12861
980	1	21	23	768	2026-05-15 18:26:06.85757	11987
981	2	22	35	3105	2026-04-14 01:13:30.466697	188770
982	3	23	30	583	2026-04-10 10:57:48.069048	117103
983	4	24	17	910	2025-12-24 05:08:56.019018	162696
984	5	25	20	805	2026-05-13 07:54:48.355535	120038
985	1	26	63	3135	2026-05-17 17:33:50.301963	103972
986	2	27	49	3008	2025-12-21 06:13:44.620815	22864
987	3	28	39	1044	2026-04-29 23:11:23.083228	114359
988	4	29	50	2193	2026-04-26 06:45:52.693836	145367
989	5	30	34	1476	2025-11-24 02:07:02.956286	71634
990	1	31	50	403	2026-05-06 15:13:42.807129	198054
991	2	32	49	1364	2026-03-13 19:57:30.067132	37955
992	3	33	15	3283	2025-12-16 16:56:20.915401	98898
993	4	34	65	1652	2026-04-03 23:10:06.911658	133723
994	5	35	12	780	2026-03-08 15:23:21.451932	88214
995	1	36	33	1204	2026-05-04 07:12:29.006914	145403
996	2	37	33	1590	2026-04-08 06:47:46.625017	37832
997	3	38	59	1144	2026-02-24 15:08:56.837804	165210
998	4	39	38	1715	2026-02-26 06:56:36.754136	125151
999	5	40	53	2024	2026-04-18 23:51:01.366051	38177
1000	1	1	63	999	2025-12-07 00:39:58.523099	36159
1001	2	2	38	1325	2026-02-17 22:42:47.044001	42716
1002	3	3	51	2752	2026-03-16 13:32:11.488595	73177
1003	4	4	66	2183	2026-04-02 21:51:17.908472	74380
1004	5	5	15	600	2026-02-19 03:14:58.876624	154270
1005	1	6	46	960	2025-12-26 09:22:48.383411	91910
1006	2	7	33	972	2026-01-28 19:21:44.615238	5016
1007	3	8	14	784	2026-03-29 04:06:18.403165	61352
1008	4	9	60	1584	2025-12-24 07:02:23.259447	63375
1009	5	10	32	2376	2025-12-02 04:21:07.625073	167541
1010	1	11	52	3654	2025-12-22 15:00:50.433547	20938
1011	2	12	60	944	2026-01-30 18:47:41.157585	91518
1012	3	13	16	1380	2026-02-19 21:00:55.194923	176736
1013	4	14	42	440	2026-01-21 18:42:09.415196	19527
1014	5	15	36	2112	2025-12-21 18:28:40.503184	40262
1015	1	16	41	1539	2026-04-03 03:44:14.47391	147794
1016	2	17	63	2438	2026-01-30 09:46:47.542359	7483
1017	3	18	20	517	2026-03-13 10:05:16.659925	129115
1018	4	19	53	1456	2026-02-14 12:03:48.442003	68608
1019	5	20	43	1470	2026-02-15 22:41:55.468101	99486
1020	1	21	21	576	2026-03-03 06:54:45.296998	12842
1021	2	22	51	1332	2026-02-27 14:47:04.487888	56358
1022	3	23	56	2401	2026-03-03 06:04:05.440968	81635
1023	4	24	31	767	2026-05-13 22:30:36.576474	18943
1024	5	25	18	3551	2025-12-10 20:33:02.614576	7031
1025	1	26	22	896	2026-01-21 08:44:43.163452	20966
1026	2	27	58	390	2026-01-08 02:36:48.730263	88322
1027	3	28	29	2014	2026-02-02 23:55:48.796343	76162
1028	4	29	29	2183	2025-12-06 12:59:41.362389	156415
1029	5	30	46	1248	2026-01-15 19:00:13.799138	88393
1030	1	31	50	510	2026-05-16 19:31:18.524431	145746
1031	2	32	44	2150	2026-05-11 14:43:17.750286	162224
1032	3	33	64	2088	2026-05-06 02:46:00.850224	145158
1033	4	34	58	1375	2025-12-30 03:30:16.704473	15552
1034	5	35	25	1554	2026-05-03 22:37:59.641912	191954
1035	1	36	43	1020	2026-02-05 07:04:23.612445	20660
1036	2	37	30	1156	2025-12-11 04:08:24.329806	43273
1037	3	38	12	1296	2025-12-10 00:03:50.547872	151975
1038	4	39	50	1650	2026-03-13 22:48:44.725693	192651
1039	5	40	56	2940	2026-01-28 12:51:06.341249	79792
1040	1	1	22	370	2026-02-25 16:18:28.001597	38366
1041	2	2	37	1480	2025-12-30 12:43:26.111896	164107
1042	3	3	61	1160	2026-03-25 10:12:59.268406	51877
1043	4	4	69	990	2026-03-08 08:21:51.795359	187671
1044	5	5	44	2350	2026-01-18 14:42:23.659981	193089
1045	1	6	16	940	2026-01-02 01:10:45.19169	7826
1046	2	7	25	2385	2026-03-21 23:11:48.93637	172986
1047	3	8	66	455	2026-02-21 01:32:10.943772	27049
1048	4	9	34	2925	2025-12-30 01:59:55.475474	73521
1049	5	10	33	1715	2026-03-29 08:45:57.04226	173925
1050	1	11	34	1881	2026-02-05 07:47:10.122612	168501
1051	2	12	10	2100	2025-12-22 06:47:43.808546	135417
1052	3	13	42	648	2026-03-25 08:51:14.915329	22729
1053	4	14	63	3304	2026-01-25 00:12:36.064554	2469
1054	5	15	39	748	2025-12-30 16:56:32.357287	86727
1055	1	16	50	2655	2026-04-08 16:20:53.526516	140859
1056	2	17	37	1634	2026-05-10 23:43:00.291092	69833
1057	3	18	26	1665	2026-02-11 02:49:51.0226	47025
1058	4	19	64	1116	2026-02-06 12:30:48.313408	37020
1059	5	20	59	3120	2026-03-17 07:09:49.041481	80815
1060	1	21	54	910	2025-12-07 13:16:21.075648	7476
1061	2	22	59	680	2026-03-23 22:06:31.788063	50201
1062	3	23	39	875	2026-02-05 19:08:27.685145	142367
1063	4	24	64	1560	2026-02-03 04:01:08.468432	4339
1064	5	25	10	540	2026-02-11 13:15:47.294435	38512
1065	1	26	45	1215	2025-12-26 07:34:25.663451	129936
1066	2	27	25	3009	2026-04-27 16:30:41.935772	145708
1067	3	28	17	3422	2026-02-18 16:50:13.238391	15722
1068	4	29	20	2565	2026-05-19 04:05:05.016851	30895
1069	5	30	15	936	2026-04-21 12:39:32.823758	101393
1070	1	31	29	1716	2025-12-17 23:34:15.622442	183729
1071	2	32	28	2394	2026-03-17 18:09:15.168897	60006
1072	3	33	66	1656	2026-03-04 14:36:21.214347	2563
1073	4	34	60	656	2025-11-26 21:53:49.069877	7032
1074	5	35	45	1760	2026-04-04 12:10:12.889698	107688
1075	1	36	54	2655	2026-04-07 08:33:00.329403	123236
1076	2	37	59	2226	2026-04-21 19:00:30.281549	190652
1077	3	38	30	1120	2026-02-08 09:20:58.403744	115887
1078	4	39	29	2166	2026-01-17 07:41:31.089424	189109
1079	5	40	21	1922	2025-12-03 09:11:12.641391	95266
1080	1	1	48	660	2026-04-08 15:38:14.186114	168207
1081	2	2	58	736	2025-11-30 05:21:22.590605	58853
1082	3	3	51	2842	2026-03-10 16:45:59.893943	147084
1083	4	4	12	3484	2026-02-01 07:30:14.906026	123871
1084	5	5	45	1302	2026-04-22 04:02:13.713762	68924
1085	1	6	35	3654	2026-01-01 08:55:39.507254	106177
1086	2	7	45	418	2025-12-12 14:07:10.271217	93919
1087	3	8	41	390	2026-01-28 20:45:35.707645	146091
1088	4	9	21	2597	2026-05-17 07:05:13.987177	141011
1089	5	10	58	1734	2026-02-08 07:40:16.332984	8679
1090	1	11	22	1804	2026-03-14 23:58:43.247718	6389
1091	2	12	67	1650	2025-12-10 17:18:24.868096	129696
1092	3	13	40	510	2026-04-28 07:50:39.056692	51604
1093	4	14	18	1682	2026-02-12 08:53:16.393702	158391
1094	5	15	56	896	2026-01-24 01:50:10.844763	33207
1095	1	16	46	2356	2026-02-04 09:04:47.948895	100640
1096	2	17	44	2322	2026-02-01 18:25:46.639956	51168
1097	3	18	52	960	2026-04-17 10:07:43.102086	20598
1098	4	19	24	3243	2026-03-27 18:16:03.192069	24496
1099	5	20	60	2145	2026-02-17 04:13:16.589354	193161
1100	1	21	37	1682	2026-04-26 12:53:02.269572	122148
1101	2	22	34	1462	2026-01-16 20:00:10.196064	199533
1102	3	23	28	1025	2026-02-15 22:28:26.46879	132051
1103	4	24	37	3876	2026-03-09 03:24:30.316412	63977
1104	5	25	30	675	2026-01-27 10:58:19.015093	171682
1105	1	26	30	1475	2026-02-20 01:28:08.482176	136945
1106	2	27	44	1749	2025-12-27 07:07:32.676336	16781
1107	3	28	11	1512	2026-04-12 12:31:06.769341	150160
1108	4	29	60	2448	2026-02-12 07:27:22.955174	150454
1109	5	30	11	1848	2026-04-10 07:20:57.895226	136646
1110	1	31	12	574	2025-12-06 00:39:40.486235	43773
1111	2	32	31	1638	2025-11-30 01:05:05.780166	3263
1112	3	33	59	2430	2026-05-10 03:16:49.575215	136295
1113	4	34	66	2331	2026-02-13 17:24:44.891862	126952
1114	5	35	27	1221	2026-03-21 21:37:57.501653	77647
1115	1	36	65	2788	2025-12-01 10:31:42.992295	165495
1116	2	37	61	2100	2025-11-22 09:12:10.251465	170679
1117	3	38	17	646	2025-12-08 23:16:08.625284	69834
1118	4	39	63	384	2026-02-06 14:57:15.216854	23469
1119	5	40	54	2146	2026-02-08 19:06:17.989914	5059
1120	1	1	54	1425	2025-12-06 16:47:05.536433	72463
1121	2	2	47	3304	2026-01-28 10:16:22.53095	11007
1122	3	3	41	3105	2026-05-09 12:39:51.380136	34233
1123	4	4	59	1710	2025-11-25 05:43:49.873692	71801
1124	5	5	61	752	2026-02-23 16:41:41.563811	196321
1125	1	6	43	1755	2026-04-21 16:32:01.578716	108941
1126	2	7	50	480	2026-03-04 13:20:09.784421	147523
1127	3	8	23	708	2026-01-14 17:34:49.172881	97258
1128	4	9	11	1419	2026-04-02 21:03:30.14181	163586
1129	5	10	32	2604	2026-03-14 08:18:45.946934	174545
1130	1	11	28	1426	2026-03-29 06:54:10.264781	182838
1131	2	12	25	1034	2025-12-25 09:41:23.206208	135851
1132	3	13	16	1924	2026-03-09 05:04:17.818177	115418
1133	4	14	58	1320	2025-12-26 23:47:37.148605	47207
1134	5	15	20	720	2025-12-20 17:30:13.758329	186154
1135	1	16	36	1121	2025-12-25 17:26:27.713598	117802
1136	2	17	53	2714	2026-02-28 02:10:45.97049	143805
1137	3	18	17	1302	2026-02-09 04:34:44.191236	171427
1138	4	19	34	1815	2026-03-22 00:53:47.357026	160117
1139	5	20	62	3120	2026-01-17 02:56:51.612577	98485
1140	1	21	41	2622	2026-03-21 02:06:30.366051	193225
1141	2	22	24	1008	2025-12-27 23:15:25.092559	194902
1142	3	23	23	2655	2026-02-13 03:35:42.384031	109912
1143	4	24	40	2552	2026-02-20 18:22:48.642895	124869
1144	5	25	52	682	2026-01-08 04:26:12.670701	128065
1145	1	26	31	1989	2026-04-09 14:14:12.503083	175751
1146	2	27	50	1176	2026-03-04 11:41:37.101035	106274
1147	3	28	16	1848	2026-02-09 04:31:06.061981	8859
1148	4	29	13	1144	2026-03-13 22:16:36.85077	137049
1149	5	30	42	2162	2026-04-14 21:02:36.858904	63010
1150	1	31	65	2516	2026-02-25 20:45:41.785526	161017
1151	2	32	21	1020	2026-01-01 04:39:20.606558	180465
1152	3	33	52	1428	2026-05-11 04:36:57.257139	84273
1153	4	34	55	3315	2026-05-04 07:09:41.931231	52715
1154	5	35	14	3410	2025-12-23 00:11:09.301921	93238
1155	1	36	35	1700	2025-12-03 17:52:07.726133	73696
1156	2	37	42	2900	2026-04-19 21:05:41.687805	61114
1157	3	38	40	1944	2026-05-15 05:43:22.074276	169440
1158	4	39	15	880	2025-12-08 07:28:46.1395	31419
1159	5	40	34	2944	2026-03-30 16:46:14.603318	114611
1160	1	1	26	2562	2026-04-01 22:52:11.50124	130669
1161	2	2	60	902	2026-01-23 19:46:27.041857	82741
1162	3	3	57	2268	2026-03-24 07:00:31.015248	103269
1163	4	4	41	608	2026-04-14 11:59:12.34917	96993
1164	5	5	53	1026	2026-03-25 15:22:20.689566	184122
1165	1	6	30	700	2026-05-17 08:53:11.206814	124741
1166	2	7	47	2640	2025-12-23 19:34:09.874787	44947
1167	3	8	24	504	2025-12-04 20:05:24.875859	88906
1168	4	9	43	1760	2026-02-21 21:20:26.308872	63253
1169	5	10	26	1750	2026-02-16 01:39:35.997858	184119
1170	1	11	19	1443	2026-04-12 10:23:27.774758	101382
1171	2	12	11	462	2026-01-05 08:53:04.160026	75846
1172	3	13	61	2542	2026-01-30 11:27:43.997738	197814
1173	4	14	47	533	2026-05-19 14:33:00.209554	86970
1174	5	15	33	1872	2025-12-19 14:00:56.600541	25496
1175	1	16	43	2178	2026-03-23 04:32:07.780976	130164
1176	2	17	29	516	2026-03-22 12:24:11.004558	115318
1177	3	18	66	1488	2025-12-22 17:39:28.838747	51643
1178	4	19	21	3250	2025-12-30 19:45:47.344057	93837
1179	5	20	11	3410	2025-11-23 06:53:22.540525	47284
1180	1	21	69	784	2026-04-05 13:11:14.8678	85525
1181	2	22	33	2640	2026-02-17 18:47:37.120005	122218
1182	3	23	67	1008	2026-05-11 03:43:59.782929	116507
1183	4	24	65	465	2026-01-31 05:29:47.182246	169381
1184	5	25	38	2254	2026-05-15 15:22:19.309004	64979
1185	1	26	53	2860	2026-04-14 13:08:07.456797	82280
1186	2	27	39	649	2025-12-26 20:16:46.513266	59361
1187	3	28	11	1350	2025-12-10 02:26:05.387684	46492
1188	4	29	54	2040	2026-05-02 00:54:30.129355	158078
1189	5	30	13	1326	2025-12-19 08:05:42.658142	75528
1190	1	31	55	540	2026-04-29 15:58:36.003844	171840
1191	2	32	65	1760	2026-01-08 04:56:13.622118	85278
1192	3	33	68	3300	2026-02-21 01:59:28.660555	88731
1193	4	34	22	1760	2026-03-29 09:06:51.021497	16244
1194	5	35	52	1702	2026-04-17 09:29:45.142724	52975
1195	1	36	64	638	2026-04-20 12:08:00.125502	157032
1196	2	37	49	2322	2026-02-28 09:19:47.297721	106801
1197	3	38	50	1085	2025-12-15 21:37:22.282716	26695
1198	4	39	64	931	2025-12-13 06:37:12.264028	199369
1199	5	40	25	1170	2026-05-17 14:11:26.578949	64402
1200	1	1	49	1400	2026-01-04 10:10:07.870309	56975
1201	2	2	28	1476	2026-02-08 19:25:51.718796	130342
1202	3	3	48	2250	2025-12-03 05:00:02.374347	131576
1203	4	4	20	2183	2026-05-06 12:16:28.587439	64132
1204	5	5	24	1806	2026-02-26 03:57:42.515558	113686
1205	1	6	59	3588	2026-05-07 11:48:01.179847	67659
1206	2	7	54	2430	2026-03-22 07:46:49.930937	145666
1207	3	8	63	675	2026-03-25 11:37:13.470157	66505
1208	4	9	16	1696	2026-02-12 08:20:03.060947	74982
1209	5	10	40	2408	2026-04-13 15:39:06.031078	56137
1210	1	11	40	1887	2026-04-15 23:43:45.976176	28618
1211	2	12	24	3186	2026-01-22 23:43:56.171427	156862
1212	3	13	31	2279	2025-12-22 07:49:30.164133	107392
1213	4	14	18	2255	2026-01-10 11:17:36.113112	98821
1214	5	15	32	2747	2026-02-11 14:10:34.347101	12989
1215	1	16	36	2205	2026-03-22 14:58:43.49391	103796
1216	2	17	35	3591	2026-04-18 17:38:26.239382	100406
1217	3	18	61	2655	2026-01-01 16:27:45.856197	102783
1218	4	19	48	1485	2026-01-19 16:43:03.413443	110367
1219	5	20	48	3300	2026-03-07 20:27:26.502646	67006
1220	1	21	28	602	2025-12-31 01:41:24.65561	32115
1221	2	22	37	1452	2026-03-09 09:41:50.142152	174400
1222	3	23	61	2088	2026-03-03 07:05:29.844647	101900
1223	4	24	67	403	2026-04-22 20:55:05.60329	191931
1224	5	25	52	1508	2026-03-07 19:42:10.398636	173485
1225	1	26	67	2223	2026-05-19 18:39:07.636235	192151
1226	2	27	34	1240	2025-12-23 09:06:52.041045	16137
1227	3	28	23	1258	2026-03-08 10:24:36.04557	91081
1228	4	29	29	3894	2026-02-15 07:41:55.754627	30041
1229	5	30	68	2385	2026-04-24 18:17:41.660887	85313
1230	1	31	23	352	2026-03-29 06:25:01.474825	2418
1231	2	32	17	735	2026-04-05 14:00:04.956033	83418
1232	3	33	24	3087	2026-02-01 04:57:59.726608	139624
1233	4	34	57	2860	2025-12-28 07:48:57.920096	77046
1234	5	35	25	874	2026-03-21 02:26:13.097587	125756
1235	1	36	34	2106	2025-12-06 22:40:17.352278	163018
1236	2	37	28	2268	2026-04-12 15:26:09.378885	119187
1237	3	38	22	2464	2026-02-20 15:17:20.546122	129899
1238	4	39	64	3068	2026-03-20 22:44:27.524136	182333
1239	5	40	52	2226	2026-03-02 07:38:43.932683	57937
1240	1	1	20	2304	2026-03-14 23:44:45.486666	118376
1241	2	2	32	1023	2026-04-02 00:51:42.754312	106119
1242	3	3	42	2744	2025-12-02 01:01:32.741409	20920
1243	4	4	36	1551	2026-04-12 21:42:44.447819	128029
1244	5	5	27	680	2025-11-27 23:48:55.548744	45897
1245	1	6	15	864	2025-12-07 08:20:53.893473	183181
1246	2	7	68	1008	2026-03-23 00:42:40.563834	24742
1247	3	8	25	684	2026-05-02 08:04:11.352516	149201
1248	4	9	12	1519	2026-01-28 21:36:09.328917	112100
1249	5	10	41	649	2026-04-12 11:51:23.70783	150270
1250	1	11	61	1392	2025-12-11 19:45:49.949161	43298
1251	2	12	20	2352	2025-12-13 20:04:52.347308	112522
1252	3	13	13	1075	2026-04-26 19:49:39.470597	35984
1253	4	14	24	3348	2026-02-10 14:48:31.487796	63495
1254	5	15	23	3190	2026-03-04 03:47:16.196989	82256
1255	1	16	51	3136	2026-01-12 19:41:59.520181	21042
1256	2	17	55	1176	2025-12-06 13:38:56.019967	197755
1258	4	19	23	636	2026-03-20 19:56:03.31368	107849
1259	5	20	54	480	2026-01-07 08:59:09.346246	114919
1260	1	21	14	1683	2026-03-16 14:05:49.211642	199703
1261	2	22	27	2000	2025-11-30 07:09:13.075689	49277
1262	3	23	66	2915	2026-05-05 15:59:43.153251	6583
1263	4	24	37	3000	2026-01-25 15:16:35.080031	165548
1264	5	25	31	2048	2026-05-08 00:01:45.649448	149258
1265	1	26	38	1518	2025-12-10 15:22:29.279195	85527
1266	2	27	16	1550	2025-12-21 02:09:05.316064	32464
1267	3	28	22	1517	2025-12-01 11:12:53.983412	137437
1268	4	29	57	2679	2026-01-12 02:45:27.755034	5374
1269	5	30	17	992	2026-03-29 22:16:27.365717	198697
1270	1	31	31	1566	2026-01-29 13:49:44.223511	139179
1271	2	32	52	2750	2025-12-09 02:14:06.655062	159530
1272	3	33	32	2065	2026-03-09 15:09:19.130826	37885
1273	4	34	69	1705	2026-01-12 15:32:54.586747	12472
1274	5	35	46	989	2026-05-16 01:26:00.155202	186983
1275	1	36	37	1080	2025-11-28 12:06:27.347141	133500
1276	2	37	60	396	2026-01-31 21:44:12.006707	195340
1277	3	38	24	1900	2026-04-07 21:36:41.970039	135422
1278	4	39	23	1110	2025-11-29 23:50:08.650175	157158
1279	5	40	25	2046	2026-02-12 19:42:38.956151	168403
1280	1	1	32	434	2025-12-24 12:10:14.329285	147220
1281	2	2	42	2115	2026-04-17 14:41:20.227651	33725
1282	3	3	50	1134	2026-04-06 11:09:49.209951	178186
1283	4	4	25	1426	2026-05-04 16:36:26.731123	134042
1284	5	5	52	1763	2026-04-05 05:17:27.703327	174077
1285	1	6	44	1288	2026-03-13 10:55:57.970945	114738
1286	2	7	63	2552	2025-12-29 17:41:42.629994	64447
1287	3	8	62	3752	2026-02-11 21:39:47.632193	154471
1288	4	9	16	1820	2026-02-22 07:28:20.26698	42196
1289	5	10	44	1802	2025-12-09 16:52:08.683522	188434
1290	1	11	16	530	2025-12-05 00:42:00.153175	135670
1291	2	12	10	2418	2026-01-03 14:34:56.142821	192900
1292	3	13	45	2808	2025-12-08 05:30:26.171442	159718
1293	4	14	63	2496	2026-02-16 10:31:36.267056	43720
1294	5	15	27	782	2026-05-07 00:29:52.155901	102833
1295	1	16	10	3450	2026-01-12 13:34:50.444063	27162
1296	2	17	66	2080	2026-01-29 07:28:02.334968	126199
1297	3	18	43	1254	2026-03-04 02:17:36.105697	199304
1298	4	19	13	2000	2025-11-30 06:06:21.103003	53543
1299	5	20	40	3348	2026-01-10 04:00:49.917236	149880
1300	1	21	31	1768	2026-05-10 15:31:02.004451	123648
1301	2	22	32	1316	2026-02-13 20:23:06.075581	86174
1302	3	23	63	672	2026-04-07 09:35:11.906585	4652
1303	4	24	30	2310	2026-05-12 08:49:09.649424	140369
1304	5	25	16	540	2026-04-18 13:20:56.675294	36697
1305	1	26	16	1121	2026-03-11 05:11:25.773792	49098
1306	2	27	33	1254	2026-04-24 01:32:54.172345	121592
1307	3	28	29	3392	2026-02-05 14:42:54.727739	91175
1308	4	29	30	2035	2026-01-23 10:21:50.228506	5749
1309	5	30	60	1428	2026-04-21 22:11:39.538713	169393
1310	1	31	67	372	2025-12-09 22:21:37.333305	3232
1311	2	32	14	2288	2026-04-24 16:25:11.124572	92755
1312	3	33	37	2829	2026-04-12 05:16:24.568315	150818
1313	4	34	60	3055	2026-04-12 02:53:45.058574	123584
1314	5	35	54	1652	2026-03-25 01:35:07.882549	194179
1315	1	36	39	2184	2026-05-12 02:53:17.924458	36154
1316	2	37	59	1365	2026-04-18 22:28:56.278104	88781
1317	3	38	16	1900	2025-12-21 16:37:27.09317	88645
1318	4	39	57	1564	2026-03-07 13:02:19.272312	180899
1319	5	40	30	1476	2026-01-04 10:10:40.990174	137685
1320	1	1	30	1392	2026-01-30 07:50:17.480661	46616
1321	2	2	46	1674	2025-12-21 21:32:37.991028	74806
1322	3	3	28	500	2026-01-08 03:04:06.209461	184988
1323	4	4	20	960	2026-05-08 03:23:14.322855	93159
1324	5	5	60	2760	2026-02-13 20:49:25.699989	36514
1325	1	6	34	589	2026-04-12 05:39:21.605155	70958
1326	2	7	54	720	2026-04-29 07:31:32.845177	125810
1327	3	8	48	2816	2026-05-01 02:50:00.9183	27001
1328	4	9	31	2600	2026-01-14 23:31:49.677006	38029
1329	5	10	40	1722	2026-01-31 18:26:45.158397	108165
1330	1	11	53	2760	2026-04-01 10:12:58.752338	8311
1331	2	12	17	2350	2026-05-15 02:58:37.122924	24243
1332	3	13	41	2480	2026-03-19 07:10:45.596092	74345
1333	4	14	26	2900	2026-03-08 14:37:06.864963	147472
1334	5	15	48	700	2026-01-30 08:05:48.874473	15061
1335	1	16	18	1344	2026-03-16 02:25:08.985901	167376
1336	2	17	59	3016	2026-02-16 07:00:03.257651	114579
1337	3	18	60	2295	2026-05-21 00:39:51.553735	3624
1338	4	19	45	1404	2026-02-06 12:44:35.11998	18664
1339	5	20	27	2144	2026-01-02 15:53:41.497493	3631
1340	1	21	59	2565	2026-05-01 22:05:10.466498	118583
1341	2	22	58	1350	2026-01-21 03:52:41.83003	105832
1342	3	23	16	1092	2026-03-21 02:58:53.730935	35490
1343	4	24	34	1612	2026-01-11 06:52:50.646097	49564
1344	5	25	14	1368	2025-12-31 05:26:03.230013	85130
1345	1	26	66	966	2026-02-01 05:15:16.317318	12109
1346	2	27	17	2860	2026-04-16 01:38:00.072464	196630
1347	3	28	45	1215	2025-11-27 15:04:19.759663	136019
1348	4	29	44	1350	2026-01-04 11:16:32.984674	132795
1349	5	30	16	2226	2026-05-12 01:47:57.556917	118356
1350	1	31	46	3752	2025-12-04 17:57:00.142675	187319
1351	2	32	36	1485	2026-03-08 10:07:19.491105	35335
1352	3	33	64	2340	2026-03-18 08:54:55.383934	79491
1353	4	34	53	396	2026-04-27 07:32:59.153633	26946
1354	5	35	61	2365	2026-01-03 10:26:08.68773	34111
1355	1	36	35	2574	2026-01-27 23:52:23.666056	80922
1356	2	37	22	1505	2025-12-27 06:07:58.873958	175454
1357	3	38	43	1650	2025-12-21 19:01:12.511758	89542
1358	4	39	59	1536	2026-03-21 14:42:43.421337	171535
1359	5	40	36	1748	2026-04-20 09:48:24.581396	19384
1360	1	1	25	2542	2026-03-31 22:03:54.183094	17610
1361	2	2	50	1320	2026-04-27 21:18:38.696951	124748
1362	3	3	13	714	2025-12-09 07:34:28.514992	5967
1363	4	4	46	2160	2026-05-02 07:02:52.673843	22867
1364	5	5	40	2193	2026-05-04 07:45:42.373396	75705
1365	1	6	16	944	2026-01-16 06:42:52.13366	11630
1366	2	7	50	950	2026-02-03 08:22:11.309594	40802
1367	3	8	55	3933	2026-05-18 18:56:50.692937	62963
1368	4	9	54	2793	2026-02-15 18:26:43.565872	173952
1369	5	10	34	2583	2026-01-01 23:33:57.170545	53250
1370	1	11	28	1078	2026-01-02 16:40:46.142047	154166
1371	2	12	56	675	2026-01-02 13:45:24.825677	88180
1372	3	13	29	363	2026-03-08 17:25:18.070292	2957
1373	4	14	23	1000	2026-02-13 16:42:09.05222	39285
1374	5	15	64	703	2025-12-25 23:53:25.474828	57541
1375	1	16	26	2014	2025-12-24 07:05:08.869222	76234
1376	2	17	44	1050	2026-05-09 13:13:25.182364	19733
1377	3	18	56	1395	2026-04-24 14:19:36.543499	15596
1378	4	19	38	1628	2026-05-07 09:41:20.193666	72703
1379	5	20	56	2145	2026-02-03 20:14:33.526558	118153
1380	1	21	45	1400	2026-05-05 00:09:47.909756	68643
1381	2	22	49	2530	2026-02-23 09:05:53.322369	13003
1382	3	23	48	3417	2026-05-08 16:42:23.757034	75330
1383	4	24	29	3294	2026-04-18 17:50:05.073928	101163
1384	5	25	20	2397	2026-01-10 13:31:32.411035	190406
1385	1	26	22	1554	2026-02-08 18:13:22.813916	30898
1386	2	27	17	1353	2026-05-06 20:52:02.621939	128135
1387	3	28	36	1904	2026-04-07 13:20:48.11073	36830
1388	4	29	60	3477	2026-04-04 16:07:04.727254	135609
1389	5	30	12	1080	2026-01-22 08:30:39.699013	19087
1390	1	31	44	1764	2026-01-10 13:10:57.159491	23160
1391	2	32	26	2968	2025-12-24 17:33:46.399106	160807
1392	3	33	22	2652	2025-12-25 06:46:56.082135	57618
1393	4	34	44	980	2026-01-11 20:43:23.235016	107166
1394	5	35	22	672	2026-01-12 06:59:29.070049	45665
1395	1	36	39	2242	2025-12-18 09:54:02.695155	64453
1396	2	37	40	2597	2025-12-16 11:40:45.869865	154416
1397	3	38	62	962	2025-12-30 15:41:25.173277	65575
1398	4	39	50	2160	2026-01-12 09:01:14.625684	154062
1399	5	40	15	3008	2026-02-06 18:49:31.055978	7715
1400	1	1	14	2736	2026-01-12 12:39:22.327771	164143
1401	2	2	68	1000	2026-05-18 15:39:10.433354	191697
1402	3	3	32	688	2026-03-14 03:41:41.373752	184138
1403	4	4	26	2021	2026-02-04 02:12:25.32076	1110
1404	5	5	43	1425	2026-05-03 21:59:57.822088	131267
1405	1	6	22	1102	2026-02-18 05:57:58.112039	2912
1406	2	7	29	2070	2026-01-09 06:54:09.923521	116390
1407	3	8	68	2365	2026-03-10 10:46:36.167675	177032
1408	4	9	56	450	2026-02-11 23:42:50.010463	18819
1409	5	10	27	1080	2025-12-31 00:42:52.462425	66446
1410	1	11	36	550	2025-12-29 01:32:01.878264	40839
1411	2	12	13	1517	2026-03-27 09:24:27.394479	71890
1412	3	13	49	1722	2026-01-08 20:33:52.049761	144685
1413	4	14	45	2438	2026-02-02 14:26:24.190725	164984
1414	5	15	63	817	2026-03-24 00:21:36.948935	110561
1415	1	16	20	918	2026-03-23 10:35:21.520569	158054
1416	2	17	34	2256	2026-05-08 13:09:22.689379	130776
1417	3	18	15	1548	2026-05-08 10:26:28.786136	191866
1418	4	19	21	1950	2026-04-16 09:10:52.804658	103154
1419	5	20	46	798	2026-03-22 15:34:20.380537	110548
1420	1	21	24	1890	2026-01-09 12:57:16.672226	164604
1421	2	22	27	3135	2026-04-25 16:35:03.127226	177998
1422	3	23	60	1665	2026-05-20 13:51:58.2768	35586
1423	4	24	23	952	2026-04-09 12:23:16.074809	27562
1424	5	25	30	1140	2025-12-24 16:05:42.771101	93571
1425	1	26	63	720	2026-04-01 07:50:51.061218	109098
1426	2	27	41	2106	2025-12-22 02:05:37.356912	23748
1427	3	28	26	2124	2026-05-03 03:25:09.46613	4330
1428	4	29	69	1995	2026-04-06 03:59:33.191279	123427
1429	5	30	40	1462	2026-02-08 15:39:46.000272	198391
1430	1	31	28	594	2025-12-27 13:39:55.038689	54544
1431	2	32	67	1539	2026-04-28 22:37:56.371073	118869
1432	3	33	30	2992	2026-01-15 09:39:17.887919	96319
1433	4	34	68	1564	2026-05-12 11:44:20.174321	124085
1434	5	35	13	1372	2026-02-10 17:19:55.399509	155132
1435	1	36	67	2436	2026-05-07 07:53:51.009686	180044
1436	2	37	52	530	2026-01-12 13:21:36.48048	34776
1437	3	38	41	2250	2026-02-16 11:23:49.686806	93279
1438	4	39	14	2074	2025-12-07 05:16:21.031275	40180
1439	5	40	61	2597	2025-12-28 05:29:12.223884	31253
1440	1	1	18	3445	2026-01-24 23:06:09.563857	174908
1441	2	2	69	480	2026-02-22 20:28:37.560715	11578
1442	3	3	47	1200	2026-03-23 13:31:43.489996	49951
1443	4	4	64	1400	2025-12-27 15:28:27.575526	126251
1444	5	5	42	1225	2026-04-18 15:17:43.736198	8891
1445	1	6	68	1368	2025-12-20 19:35:19.597314	58473
1446	2	7	37	3192	2026-05-04 09:26:50.837259	43707
1447	3	8	24	1672	2026-01-29 00:22:36.660813	78038
1448	4	9	23	2832	2025-12-03 17:42:02.669843	115451
1449	5	10	48	1344	2025-12-01 22:48:24.540292	151803
1450	1	11	48	3016	2025-12-11 13:27:31.766769	127213
1451	2	12	49	3510	2026-04-07 00:56:01.414394	14960
1452	3	13	56	1947	2025-11-27 11:34:36.581883	146399
1453	4	14	47	867	2025-12-18 01:15:20.015237	100647
1454	5	15	49	2030	2025-12-21 05:05:59.318003	172212
1455	1	16	67	2052	2025-11-30 01:55:17.83741	97673
1456	2	17	49	2331	2026-05-15 16:29:32.616441	87372
1457	3	18	20	741	2026-01-16 07:44:05.920324	133061
1458	4	19	23	1323	2026-03-04 16:55:44.140284	71899
1459	5	20	55	912	2026-01-29 01:39:38.29205	71678
1460	1	21	40	2640	2025-12-29 10:43:12.777532	140114
1461	2	22	44	2208	2026-01-03 06:20:00.362845	150110
1462	3	23	63	384	2025-12-03 07:14:20.331035	54429
1463	4	24	54	480	2026-05-10 16:28:12.649897	195985
1464	5	25	43	1922	2026-03-05 15:54:30.793846	77055
1465	1	26	10	1476	2026-04-11 22:43:00.5039	91445
1466	2	27	16	1081	2026-03-25 05:52:37.10811	95158
1467	3	28	63	825	2026-01-23 00:57:51.843245	128116
1468	4	29	69	2360	2026-01-31 02:45:32.479447	182413
1469	5	30	59	1128	2026-04-13 20:21:25.322493	118943
1470	1	31	36	1617	2026-05-13 00:20:26.616186	193137
1471	2	32	51	2907	2026-03-18 21:33:17.432536	5268
1472	3	33	15	1850	2026-04-30 23:15:45.046937	136101
1473	4	34	55	1276	2025-12-05 18:27:42.284457	145304
1474	5	35	19	480	2026-02-13 00:40:29.446821	50897
1475	1	36	38	1056	2026-01-20 08:34:04.798842	116553
1476	2	37	45	3234	2025-12-04 15:58:35.844456	95461
1477	3	38	25	1755	2026-02-14 09:32:19.929848	130930
1478	4	39	65	3060	2025-11-29 15:02:39.448476	39059
1479	5	40	67	1786	2026-02-25 16:46:18.002998	854
1480	1	1	25	1020	2025-12-06 15:51:38.333463	193203
1481	2	2	67	1978	2026-04-07 06:28:07.372584	153292
1482	3	3	20	1088	2026-01-29 00:36:58.580681	177953
1483	4	4	59	1568	2026-03-29 21:34:14.608117	57848
1484	5	5	19	588	2026-03-14 10:40:06.685267	115693
1485	1	6	67	1560	2025-11-22 19:17:26.537041	50142
1486	2	7	51	1288	2026-05-05 14:53:56.596764	77714
1487	3	8	20	1196	2025-11-28 09:57:38.099099	32022
1488	4	9	61	1485	2026-01-20 11:47:24.955393	194079
1489	5	10	19	2254	2026-02-24 14:23:47.752597	31945
1490	1	11	31	1428	2025-12-16 14:40:35.011833	78370
1491	2	12	25	2714	2026-04-26 02:12:45.389937	56735
1492	3	13	62	1848	2026-01-05 16:56:47.351901	155665
1493	4	14	33	1711	2025-12-22 04:25:37.35397	162982
1494	5	15	54	588	2026-04-16 02:13:05.769389	4767
1495	1	16	34	1680	2026-05-14 07:00:42.068109	2357
1496	2	17	48	1118	2026-05-18 18:39:09.29578	65309
1497	3	18	28	468	2025-12-21 02:03:22.692997	22162
1498	4	19	19	3250	2026-01-14 03:05:39.903508	145138
1499	5	20	46	1672	2026-01-13 11:31:15.268117	109397
1500	1	21	26	2052	2026-05-05 04:03:37.259262	44799
1501	2	22	37	800	2026-03-25 09:55:07.059855	129360
1502	3	23	42	980	2026-02-14 21:25:34.973153	172026
1503	4	24	46	2838	2026-03-08 17:15:04.171099	187083
1504	5	25	18	1458	2026-02-19 15:46:37.169203	7200
1505	1	26	55	1947	2026-01-26 16:40:00.498972	48618
1506	2	27	64	2457	2026-03-22 09:05:25.158851	83478
1507	3	28	50	2132	2026-02-09 03:21:04.564936	80463
1508	4	29	24	3648	2026-04-27 06:35:58.724661	2766
1509	5	30	19	1632	2026-02-21 05:25:26.082302	155998
1510	1	31	22	812	2026-04-28 18:44:50.483091	115365
1511	2	32	57	2478	2026-05-19 11:16:54.542629	138903
1512	3	33	53	728	2026-02-02 04:39:40.221156	24929
1513	4	34	51	1088	2026-02-10 14:09:25.581109	36459
1514	5	35	21	2320	2026-02-16 06:41:44.440975	143881
1515	1	36	45	2613	2025-12-27 00:18:02.672204	195305
1516	2	37	23	2491	2025-12-24 17:50:20.719085	147213
1517	3	38	42	779	2025-12-03 23:21:18.551788	186759
1518	4	39	54	903	2026-02-23 22:07:39.411029	95471
1519	5	40	61	1280	2026-04-13 04:29:26.651657	95556
1520	1	1	49	2760	2025-12-11 13:20:52.606089	131761
1521	2	2	55	1131	2026-01-14 16:12:01.641545	55899
1522	3	3	55	1254	2026-04-09 15:51:48.233053	30207
1523	4	4	32	2200	2026-04-25 18:04:00.34987	58461
1524	5	5	43	2400	2026-02-24 22:32:21.538118	133483
1525	1	6	16	1856	2026-05-20 15:52:58.361863	193966
1526	2	7	19	539	2026-02-13 03:16:45.484861	152446
1527	3	8	45	930	2025-11-26 06:26:04.575396	52728
1528	4	9	13	1372	2026-01-15 11:46:31.7986	189120
1529	5	10	56	1333	2025-12-01 16:33:40.755264	126064
1530	1	11	57	1560	2026-04-18 07:30:22.196625	4994
1531	2	12	41	820	2026-02-07 09:27:31.388811	100814
1532	3	13	52	1645	2026-02-13 07:50:14.035337	72208
1533	4	14	13	3186	2026-04-17 22:02:02.309928	150140
1534	5	15	45	1197	2025-12-17 17:20:27.36881	87858
1535	1	16	58	1976	2026-05-07 12:22:12.769035	114351
1536	2	17	60	2077	2025-12-14 16:42:46.315929	99809
1537	3	18	16	943	2026-03-12 12:35:20.934775	4168
1538	4	19	67	1188	2026-01-10 18:48:05.912025	29087
1539	5	20	10	1512	2025-12-19 17:09:06.16517	51059
1540	1	21	15	1836	2026-03-30 07:57:05.310793	76375
1541	2	22	52	1428	2026-01-17 07:43:53.532957	160426
1542	3	23	63	885	2026-01-09 13:24:10.219234	152106
1543	4	24	57	1334	2026-02-22 22:50:17.412739	43275
1544	5	25	61	1274	2026-01-18 20:29:46.993402	144917
1545	1	26	60	1892	2025-11-28 20:30:26.180965	14025
1546	2	27	68	2530	2026-02-23 02:58:46.526577	3255
1547	3	28	62	578	2026-03-22 12:03:09.615569	69033
1548	4	29	28	494	2025-12-10 07:28:12.44186	198030
1549	5	30	14	2552	2026-03-21 03:10:27.119009	28054
1550	1	31	37	3480	2026-04-07 02:17:35.131264	151042
1551	2	32	30	1802	2026-04-14 11:21:02.691347	64489
1552	3	33	48	759	2026-04-23 15:00:09.210957	120699
1553	4	34	25	2255	2026-03-06 00:22:21.023494	17314
1554	5	35	55	1776	2026-03-31 22:05:20.919483	144024
1555	1	36	52	870	2026-01-29 23:52:02.960014	90983
1556	2	37	64	1715	2026-05-01 08:28:13.885574	115242
1557	3	38	33	2340	2026-03-13 13:39:31.378133	76818
1558	4	39	69	546	2026-02-18 02:26:24.95347	184607
1559	5	40	59	966	2025-11-25 10:26:27.26035	123230
1560	1	1	52	777	2026-02-15 08:15:38.356405	13678
1561	2	2	60	2115	2026-04-29 17:31:38.359836	125007
1562	3	3	57	2244	2026-05-08 18:34:54.264618	37192
1563	4	4	57	3180	2026-04-01 02:37:08.535568	34681
1564	5	5	14	2420	2026-04-15 05:45:03.302281	17097
1565	1	6	61	434	2026-05-12 00:05:27.159268	6788
1566	2	7	25	3264	2026-05-17 02:13:05.515141	150595
1567	3	8	40	3510	2026-01-27 15:15:05.933647	48270
1568	4	9	40	3276	2026-03-10 03:04:54.130292	120551
1569	5	10	13	560	2025-11-26 20:46:28.604819	140942
1570	1	11	38	2068	2026-04-23 20:27:36.430854	86417
1571	2	12	34	2365	2026-04-07 23:04:14.745735	106009
1572	3	13	45	2970	2026-03-04 22:10:40.220145	138847
1573	4	14	59	2173	2026-01-29 07:52:13.369243	114139
1574	5	15	61	1938	2026-03-01 07:12:01.592096	138394
1575	1	16	16	1416	2025-12-15 10:18:55.089615	49424
1576	2	17	54	533	2026-05-14 07:18:10.516767	159779
1577	3	18	68	2345	2026-05-06 21:39:45.432304	88552
1578	4	19	28	3538	2025-12-14 20:02:24.944294	112874
1579	5	20	12	1920	2026-01-16 09:01:51.127098	188616
1580	1	21	21	1054	2026-03-17 16:29:33.192088	137983
1581	2	22	21	896	2026-01-18 08:34:54.343207	131622
1582	3	23	14	1760	2026-05-16 14:54:51.542686	44799
1583	4	24	35	2548	2025-12-03 03:47:48.733071	56516
1584	5	25	33	3024	2026-04-07 12:08:30.597657	109280
1585	1	26	11	2652	2026-03-21 04:43:13.852663	71037
1586	2	27	51	1881	2026-02-05 14:42:42.450033	156511
1587	3	28	44	2124	2026-01-16 09:26:51.87973	101715
1588	4	29	27	1872	2026-03-16 07:25:22.189045	129360
1589	5	30	67	1890	2026-01-20 13:31:36.969284	3373
1590	1	31	15	559	2026-04-09 19:42:23.271824	190688
1591	2	32	39	1560	2026-02-28 08:50:37.120715	72352
1592	3	33	23	1170	2026-01-03 22:18:27.563949	59763
1593	4	34	35	1620	2025-12-18 00:43:13.638843	107926
1594	5	35	21	828	2026-01-24 14:38:27.357705	131708
1595	1	36	52	1836	2026-03-16 17:23:01.104048	179230
1596	2	37	10	1456	2026-03-13 11:29:12.018642	156745
1597	3	38	31	1890	2026-05-12 18:32:45.125738	47992
1598	4	39	52	1092	2025-11-24 10:03:37.175566	192583
1599	5	40	39	2166	2026-03-18 18:13:56.348826	35316
1600	1	1	53	1881	2025-12-07 07:15:38.809839	147027
1601	2	2	43	2142	2026-03-05 13:19:04.159038	141146
1602	3	3	52	2255	2026-02-28 04:05:33.854742	48487
1603	4	4	67	1980	2026-04-18 13:11:45.372312	23347
1604	5	5	23	3685	2026-04-20 01:33:24.047761	192931
1605	1	6	67	1634	2025-12-25 09:53:31.395282	75855
1606	2	7	47	720	2026-01-25 20:00:01.146083	136329
1607	3	8	15	2160	2026-04-06 06:38:07.531948	29650
1608	4	9	47	2415	2026-03-20 11:26:06.075424	64506
1609	5	10	61	480	2025-11-29 04:39:49.538768	39786
1610	1	11	46	2622	2026-03-16 20:17:23.784873	93102
1611	2	12	26	676	2026-02-06 22:35:21.16742	80211
1612	3	13	51	1590	2026-03-16 03:21:52.274189	192419
1613	4	14	34	2108	2026-04-11 20:03:28.99767	140514
1614	5	15	30	3551	2026-04-13 08:16:05.920766	93769
1615	1	16	42	2160	2026-04-18 12:27:26.443358	102546
1616	2	17	50	3740	2026-03-22 04:14:33.737628	46267
1617	3	18	36	936	2026-03-28 21:45:58.591682	38114
1618	4	19	38	1813	2026-01-05 01:10:31.358571	102799
1619	5	20	68	1085	2026-01-10 03:46:52.497419	11440
1620	1	21	46	1534	2026-02-27 03:02:01.289121	151285
1621	2	22	68	3080	2026-01-06 23:55:15.402855	62784
1622	3	23	37	2205	2025-12-15 18:35:29.927233	184125
1623	4	24	32	3136	2026-05-09 03:39:19.462884	160688
1624	5	25	54	1482	2025-12-14 05:17:17.02268	180917
1625	1	26	11	1813	2025-12-28 05:21:16.42661	58919
1626	2	27	68	3400	2026-05-01 17:19:13.428777	150005
1627	3	28	26	1332	2026-01-27 09:33:00.960697	138876
1628	4	29	11	3864	2026-03-17 12:34:31.06678	33817
1629	5	30	59	2378	2026-03-06 00:36:58.429724	133409
1630	1	31	51	1357	2025-12-27 18:52:43.92106	27751
1631	2	32	45	2379	2026-03-28 20:38:21.955632	45437
1632	3	33	21	3657	2026-03-28 06:49:36.739566	49088
1633	4	34	29	2622	2026-04-30 00:54:08.621634	8578
1634	5	35	33	704	2026-01-27 23:24:04.799621	22914
1635	1	36	31	2800	2025-12-01 13:31:30.436696	27151
1636	2	37	63	810	2026-03-10 14:15:14.553661	92715
1637	3	38	41	1540	2025-12-06 12:16:51.492214	98881
1638	4	39	63	2320	2025-12-20 02:34:14.76385	76710
1639	5	40	64	1197	2026-03-02 11:52:24.673428	16040
1640	1	1	29	1248	2026-03-27 07:23:54.114436	90107
1641	2	2	46	2950	2026-02-02 05:07:29.453151	18191
1642	3	3	11	1995	2026-01-09 23:20:43.14455	120357
1643	4	4	10	1968	2025-12-06 10:09:09.685856	137782
1644	5	5	13	578	2026-03-08 07:02:44.758686	64538
1645	1	6	23	1650	2026-01-07 03:50:40.572275	16319
1646	2	7	14	1102	2026-04-10 18:26:13.390839	142330
1647	3	8	15	2793	2025-12-19 12:24:31.422532	104425
1648	4	9	12	2079	2026-05-15 13:20:46.712738	41984
1649	5	10	44	2242	2025-12-24 06:12:37.109523	31899
1650	1	11	18	736	2026-01-14 03:54:17.829262	156985
1651	2	12	55	2310	2026-04-22 16:11:13.001423	172830
1652	3	13	32	1344	2026-04-27 15:51:22.408221	112379
1653	4	14	43	1416	2025-12-26 09:38:30.785037	46933
1654	5	15	58	2650	2026-04-01 16:01:01.17705	38559
1655	1	16	55	372	2025-12-30 21:47:43.234072	65367
1656	2	17	21	1760	2026-01-17 05:18:38.582485	65967
1657	3	18	63	2146	2026-04-21 09:38:59.267326	193176
1658	4	19	17	2400	2025-11-23 22:45:20.846642	144827
1659	5	20	26	1702	2026-03-02 03:09:39.785864	174800
1660	1	21	38	600	2026-05-07 14:01:06.683372	164510
1661	2	22	31	1880	2025-12-08 15:57:17.370608	110660
1662	3	23	48	900	2026-04-03 17:40:20.792724	191817
1663	4	24	64	1518	2025-12-07 10:53:50.441565	104207
1664	5	25	41	2310	2026-02-03 08:25:13.947471	37609
1665	1	26	53	2150	2026-03-24 05:13:38.974412	197964
1666	2	27	18	2546	2025-11-30 00:54:15.608514	28906
1667	3	28	43	2040	2026-02-03 01:27:36.65617	161855
1668	4	29	19	462	2026-05-03 00:26:21.618742	102847
1669	5	30	58	1036	2026-04-04 21:51:24.910277	87097
1670	1	31	54	675	2026-01-20 19:54:27.148279	106714
1671	2	32	58	1224	2026-03-14 20:19:24.33746	62602
1672	3	33	10	2109	2026-05-19 18:10:09.253958	18024
1673	4	34	63	2691	2026-04-09 03:17:33.172426	84692
1674	5	35	33	1702	2026-01-11 18:20:33.075956	121725
1675	1	36	31	555	2026-05-02 14:40:05.57208	118142
1676	2	37	20	812	2026-01-25 06:07:32.043054	124166
1677	3	38	48	585	2026-03-31 06:44:42.834982	43755
1678	4	39	31	1152	2026-03-14 22:41:12.736956	29812
1679	5	40	63	1591	2026-04-06 18:47:50.789362	158238
1680	1	1	16	1140	2026-04-30 02:40:37.148097	78829
1681	2	2	48	352	2026-01-01 10:17:03.556121	124900
1682	3	3	63	2646	2026-02-15 06:20:07.731486	83304
1683	4	4	14	1700	2026-05-13 11:00:41.152541	42043
1684	5	5	36	1650	2026-01-27 07:28:04.674726	151121
1685	1	6	12	2009	2025-12-11 09:18:10.450061	130799
1686	2	7	21	1584	2026-03-15 18:30:52.335055	55372
1687	3	8	45	2184	2026-01-07 06:02:41.978988	63360
1688	4	9	36	3248	2026-05-11 14:44:05.328652	148277
1689	5	10	68	1904	2025-12-29 19:45:44.112779	11037
1690	1	11	28	525	2026-03-17 19:16:36.72679	83693
1691	2	12	44	2015	2026-02-06 08:56:29.069257	42422
1692	3	13	58	572	2026-01-05 18:43:03.721102	122569
1693	4	14	24	1150	2025-12-23 18:47:18.685343	13643
1694	5	15	53	2124	2026-05-16 13:44:58.108018	85336
1695	1	16	38	1326	2026-01-02 19:18:18.669976	30263
1696	2	17	25	756	2025-12-04 21:23:23.974876	174239
1697	3	18	65	2135	2026-04-13 13:31:40.576683	174400
1698	4	19	55	2976	2026-03-20 12:29:26.178	100982
1699	5	20	39	1711	2026-03-22 18:26:47.745806	125571
1700	1	21	30	2256	2026-03-10 18:32:38.06482	9608
1701	2	22	30	1419	2026-03-15 18:44:50.601374	6544
1702	3	23	68	484	2026-05-04 20:23:05.939226	57433
1703	4	24	57	990	2026-05-02 17:51:19.109912	14586
1704	5	25	25	2394	2025-12-23 19:08:35.003028	162233
1705	1	26	14	756	2025-12-28 19:36:58.968353	140400
1706	2	27	13	1377	2025-12-11 07:01:19.104407	4838
1707	3	28	63	2537	2026-01-01 06:08:58.655029	157895
1708	4	29	30	2756	2026-02-14 14:55:22.544247	193754
1709	5	30	62	500	2026-01-06 00:27:19.882243	168082
1710	1	31	20	1927	2026-05-20 13:25:24.061475	83286
1711	2	32	67	3480	2026-05-19 13:12:06.702873	126385
1712	3	33	23	1045	2026-04-23 18:35:36.704459	196400
1713	4	34	27	680	2026-04-17 16:25:24.323351	41503
1714	5	35	19	1458	2025-12-07 09:08:33.185253	73622
1715	1	36	12	2112	2026-01-25 03:10:01.457584	11244
1716	2	37	30	1722	2026-04-18 01:26:08.611505	169966
1717	3	38	19	1881	2026-02-22 15:10:08.340385	193778
1718	4	39	33	1681	2026-01-08 22:44:45.726604	116186
1719	5	40	27	1260	2026-03-03 00:42:54.330066	86648
1720	1	1	42	372	2025-12-20 23:41:11.069897	120986
1721	2	2	54	3364	2026-01-08 06:48:55.507363	78549
1722	3	3	22	2964	2026-03-03 20:02:20.049797	157722
1723	4	4	33	2028	2026-04-11 05:40:39.539507	168602
1724	5	5	11	735	2026-05-04 22:07:16.667603	68431
1725	1	6	48	3604	2025-12-03 07:36:53.87144	169718
1726	2	7	52	2405	2026-01-19 17:52:10.691068	2434
1727	3	8	18	960	2026-02-06 06:25:44.076179	178075
1728	4	9	34	897	2026-04-24 10:47:10.58788	51941
1729	5	10	24	2501	2025-12-25 19:14:26.46034	63018
1730	1	11	50	988	2026-01-07 02:15:59.040321	49876
1731	2	12	36	576	2026-02-05 17:38:29.806146	3292
1732	3	13	16	1566	2025-12-14 06:49:32.566881	15453
1733	4	14	58	2479	2026-02-17 08:26:42.982356	54242
1734	5	15	46	702	2026-02-11 19:18:42.28916	107408
1735	1	16	33	715	2026-05-03 19:04:04.284781	138674
1736	2	17	62	1610	2026-01-26 03:27:36.662528	96596
1737	3	18	20	1085	2026-02-28 00:48:02.487339	69202
1738	4	19	46	945	2026-01-24 23:33:32.93245	138964
1739	5	20	59	1530	2026-04-21 03:24:00.546864	133862
1740	1	21	20	1680	2026-01-27 05:22:45.561935	117495
1741	2	22	56	2257	2026-04-22 21:29:53.89401	93026
1742	3	23	36	2068	2025-12-31 16:33:36.976585	93545
1743	4	24	59	640	2026-01-23 13:18:23.381548	150509
1744	5	25	69	1400	2026-03-04 14:48:59.111364	139997
1745	1	26	62	690	2026-02-10 04:28:44.971627	168081
1746	2	27	44	1920	2026-04-06 21:28:31.4253	1895
1747	3	28	34	1652	2026-04-09 01:12:51.194952	94249
1748	4	29	25	3468	2026-04-01 16:24:02.343293	31448
1749	5	30	30	1628	2025-12-25 09:26:19.092655	85902
1750	1	31	16	3111	2026-02-08 14:58:38.896778	181114
1751	2	32	24	1480	2025-12-30 06:02:32.091106	24995
1752	3	33	38	1520	2026-02-08 15:10:27.594971	28866
1753	4	34	20	1886	2025-11-29 21:31:30.911185	142580
1754	5	35	59	870	2026-02-10 06:58:45.471283	39582
1755	1	36	54	799	2026-05-02 12:02:24.350327	70767
1756	2	37	30	2024	2026-01-26 04:44:34.08302	7870
1757	3	38	16	1296	2025-11-30 08:41:39.478063	174945
1758	4	39	61	1476	2026-04-13 20:29:58.41176	136563
1759	5	40	51	741	2026-03-14 20:01:41.2303	68806
1760	1	1	47	2144	2025-12-09 23:22:51.36077	76148
1761	2	2	19	330	2026-01-13 04:40:24.755386	178808
1762	3	3	31	1452	2025-12-06 09:18:14.203696	148745
1763	4	4	66	688	2026-02-08 12:28:17.162056	197542
1764	5	5	49	1950	2025-11-28 21:55:38.255265	146828
1765	1	6	69	1764	2026-05-04 20:35:10.200144	57617
1766	2	7	61	1540	2026-04-11 07:28:48.114168	174802
1767	3	8	60	990	2026-05-05 11:20:02.689337	195231
1768	4	9	32	1060	2026-04-07 18:20:34.424035	168102
1769	5	10	27	2014	2026-01-10 20:24:27.627279	140042
1770	1	11	49	2072	2025-12-27 17:40:55.80152	134853
1771	2	12	60	1161	2026-01-29 09:20:51.336015	77227
1773	4	14	38	2268	2026-04-09 19:08:32.658266	148636
1774	5	15	13	2881	2026-02-10 19:34:36.881482	108410
1775	1	16	64	930	2026-04-28 13:45:18.93005	139788
1776	2	17	50	1750	2025-12-14 17:38:10.184982	149318
1777	3	18	35	988	2026-01-28 13:06:55.890101	119789
1778	4	19	65	1610	2025-12-08 10:51:23.129843	184162
1779	5	20	12	1656	2026-04-23 13:17:11.250696	72415
1780	1	21	14	3762	2026-02-28 06:37:31.228261	32199
1781	2	22	69	2346	2026-05-09 08:58:37.571117	51893
1782	3	23	45	2745	2026-04-19 11:25:10.956979	187961
1783	4	24	41	1998	2025-12-09 07:06:56.84036	120125
1784	5	25	40	780	2026-03-19 09:06:53.050593	127645
1785	1	26	56	3127	2025-11-28 20:24:02.882423	136092
1786	2	27	16	1702	2026-02-10 16:36:00.628118	99372
1787	3	28	23	3072	2026-05-15 00:18:02.237298	42646
1788	4	29	56	3717	2026-05-03 19:39:55.362191	72344
1789	5	30	29	2860	2026-01-15 15:39:41.436945	51584
1790	1	31	32	496	2026-03-12 01:23:59.42386	161430
1791	2	32	22	1408	2026-03-25 20:25:15.907432	191516
1792	3	33	39	3564	2026-03-17 02:22:35.158546	117998
1793	4	34	40	720	2026-02-17 23:02:00.773703	106146
1794	5	35	49	518	2026-04-06 16:47:21.710003	32267
1795	1	36	62	2499	2026-05-04 04:32:33.990258	184517
1796	2	37	68	3009	2026-02-17 07:13:45.142653	178473
1797	3	38	46	1175	2026-02-15 10:20:10.101479	30720
1798	4	39	64	1400	2026-03-11 00:00:57.191773	107264
1799	5	40	69	1610	2025-11-24 19:30:05.419332	171916
1800	1	1	39	1300	2026-02-23 10:32:42.316719	23303
1801	2	2	31	816	2026-03-20 12:31:35.707754	92855
1802	3	3	45	1976	2026-01-08 02:21:23.601433	105904
1803	4	4	56	627	2026-03-09 15:27:45.620519	9797
1804	5	5	69	2009	2026-01-19 17:56:25.286963	135411
1805	1	6	40	690	2026-03-14 22:50:03.459815	110615
1806	2	7	27	1976	2026-04-07 22:17:58.144424	97925
1807	3	8	19	2904	2026-02-13 14:20:38.11095	142184
1808	4	9	66	2346	2025-12-19 21:32:17.708675	6160
1809	5	10	17	1274	2025-12-17 08:23:50.513691	136535
1810	1	11	35	520	2026-04-05 23:10:36.718783	113406
1811	2	12	27	2250	2025-12-06 13:26:29.125382	36003
1812	3	13	68	2352	2026-02-17 21:49:39.917852	82184
1813	4	14	25	432	2026-03-25 12:25:14.266667	187113
1814	5	15	22	2520	2026-02-05 22:00:16.2149	107195
1815	1	16	55	1113	2025-12-23 00:24:26.447856	85725
1816	2	17	34	940	2025-12-04 20:33:42.054006	98688
1817	3	18	57	440	2026-02-14 08:56:17.055412	34548
1818	4	19	16	4071	2026-03-05 16:20:04.068248	17936
1819	5	20	22	2592	2025-12-06 13:32:24.169069	159651
1820	1	21	57	1914	2026-03-11 09:56:15.816075	109676
1821	2	22	29	2090	2026-03-06 03:20:07.65591	184053
1822	3	23	38	2052	2026-04-25 05:55:08.944716	55023
1823	4	24	38	944	2026-04-08 00:03:52.069782	36485
1824	5	25	13	646	2026-03-09 12:53:50.108945	13413
1825	1	26	35	1380	2026-02-12 01:00:00.768694	193927
1826	2	27	16	1404	2026-04-07 23:05:41.669599	107986
1828	4	29	14	496	2026-02-06 18:45:58.148748	2833
1829	5	30	18	530	2026-01-23 16:13:34.301389	173673
1830	1	31	10	574	2026-01-13 20:58:46.569238	14349
1831	2	32	23	1806	2025-12-27 11:39:31.554704	71393
1832	3	33	33	1408	2026-01-15 11:40:52.794282	135364
1833	4	34	28	1595	2026-03-04 22:03:08.992743	42833
1834	5	35	55	630	2026-04-29 08:46:19.671769	172694
1835	1	36	22	658	2025-12-13 01:56:21.608301	24555
1836	2	37	34	2772	2025-12-09 11:49:02.652821	131110
1837	3	38	53	864	2026-01-24 12:29:07.684354	15811
1838	4	39	69	1292	2026-03-07 14:32:32.368714	82288
1839	5	40	41	2223	2026-03-16 18:56:53.022794	39514
1840	1	1	62	1634	2026-01-01 02:15:19.412538	23653
1841	2	2	38	1620	2026-02-27 16:35:27.642021	211
1842	3	3	44	2788	2026-04-08 08:33:09.660417	172338
1843	4	4	13	2040	2026-05-04 00:08:13.591679	163443
1844	5	5	13	1972	2026-02-03 01:28:48.851884	76488
1845	1	6	30	1218	2026-03-21 07:07:48.840075	160581
1846	2	7	63	533	2026-02-24 00:36:55.954552	148731
1847	3	8	56	1972	2025-11-28 06:37:26.759181	50649
1848	4	9	60	684	2026-04-25 18:23:03.960788	13395
1849	5	10	43	1550	2026-03-23 07:48:35.074295	151076
1850	1	11	36	2695	2025-12-26 21:47:35.721955	86155
1851	2	12	64	1920	2026-05-11 10:33:30.953483	32473
1852	3	13	60	735	2025-11-23 21:17:21.913158	13341
1853	4	14	22	3136	2025-12-01 19:30:04.841518	77818
1854	5	15	34	540	2026-05-18 18:55:04.499125	167494
1855	1	16	22	2068	2025-11-27 01:53:16.268431	85194
1856	2	17	57	864	2025-12-08 08:26:32.143879	8875
1857	3	18	27	615	2026-02-03 15:49:53.539354	1435
1858	4	19	63	2006	2026-01-25 04:12:44.252631	106771
1859	5	20	14	2088	2026-03-29 13:02:58.244887	192721
1860	1	21	55	2244	2026-03-08 19:39:15.594306	194900
1861	2	22	60	1672	2026-04-21 16:18:33.596013	188248
1862	3	23	38	2916	2026-05-16 15:33:12.406508	19502
1863	4	24	52	1517	2026-03-23 02:41:46.680426	37916
1864	5	25	30	1518	2025-12-27 00:52:22.32058	72616
1865	1	26	12	2352	2025-11-28 01:05:54.937772	193398
1866	2	27	22	1980	2026-04-30 22:23:51.482654	1943
1867	3	28	22	2397	2025-12-29 21:13:33.375274	79798
1868	4	29	64	540	2026-05-08 03:45:11.66831	131400
1869	5	30	63	3060	2026-04-08 20:34:12.514078	71476
1870	1	31	56	1104	2026-03-28 01:37:56.113075	163247
1871	2	32	50	1682	2026-05-15 19:03:12.010222	180760
1872	3	33	31	1584	2026-05-11 20:15:38.560935	143507
1873	4	34	28	3286	2026-02-09 06:52:11.951316	55243
1874	5	35	47	2200	2026-05-11 05:54:15.866695	1107
1875	1	36	52	1222	2026-01-29 05:53:11.812729	729
1876	2	37	27	1100	2026-04-30 16:36:52.796637	183276
1877	3	38	69	714	2026-01-13 03:27:59.934125	58656
1878	4	39	47	1620	2026-04-21 04:12:32.90718	183903
1879	5	40	40	1640	2025-12-17 17:45:58.758849	123246
1880	1	1	43	1080	2026-05-02 16:32:19.269113	6594
1881	2	2	31	816	2026-02-15 16:57:33.117891	100171
1882	3	3	34	616	2026-03-23 20:03:27.464233	119160
1883	4	4	38	1792	2025-12-02 16:54:28.613199	122173
1884	5	5	30	2475	2025-12-28 13:26:36.974467	87541
1885	1	6	16	924	2025-11-27 12:47:28.882573	173021
1886	2	7	20	903	2026-01-26 03:26:54.602	191317
1887	3	8	66	2867	2026-03-18 13:14:36.184926	113044
1888	4	9	50	1178	2026-03-22 14:59:05.846038	143634
1889	5	10	39	403	2026-02-11 03:06:33.63635	190686
1890	1	11	33	3540	2025-11-22 13:59:12.324773	32265
1891	2	12	50	2340	2026-05-16 15:24:35.632829	41635
1892	3	13	31	2183	2026-04-09 12:17:42.976392	95594
1893	4	14	22	2360	2025-12-08 19:32:52.893498	36177
1894	5	15	21	1645	2026-01-04 06:13:33.959088	79247
1895	1	16	54	880	2026-03-22 05:09:12.170377	120251
1896	2	17	15	468	2026-03-11 20:16:35.833681	40549
1897	3	18	25	1426	2026-03-26 20:11:06.271814	31890
1898	4	19	65	1680	2026-02-21 00:05:49.20775	40492
1899	5	20	27	3450	2025-12-01 12:12:01.174465	139900
1900	1	21	11	1560	2026-01-25 23:25:09.875119	68786
1901	2	22	40	924	2026-01-05 21:45:47.761773	32235
1902	3	23	50	2346	2025-12-14 14:32:21.062771	100381
1903	4	24	24	1034	2025-12-12 00:07:44.694024	177321
1904	5	25	23	1748	2026-02-12 07:07:37.949236	125571
1905	1	26	28	1260	2026-04-13 23:41:23.497718	70469
1906	2	27	35	1763	2026-05-20 21:35:11.619843	46738
1907	3	28	29	2209	2025-12-23 07:37:12.49746	17875
1908	4	29	43	2112	2026-04-20 03:55:53.74259	8402
1909	5	30	33	434	2025-12-12 21:01:29.608572	190299
1910	1	31	58	1395	2026-03-25 20:52:45.511021	85172
1911	2	32	60	1054	2026-04-24 10:50:13.180627	159584
1912	3	33	37	2420	2026-03-03 21:55:53.686409	162971
1913	4	34	11	1813	2026-03-09 18:09:09.549761	13741
1914	5	35	28	1961	2026-03-01 20:59:13.020122	4131
1915	1	36	42	1290	2025-12-25 01:10:59.997922	164323
1916	2	37	18	680	2026-03-05 05:38:28.179952	159557
1917	3	38	31	2046	2025-12-17 01:17:01.017538	139506
1918	4	39	46	2280	2026-04-03 04:09:41.849772	153857
1919	5	40	44	3276	2026-02-20 15:27:04.841683	139626
1920	1	1	56	510	2026-05-19 14:33:26.679931	72371
1921	2	2	49	990	2026-04-11 11:01:47.164946	84665
1922	3	3	36	2915	2026-04-23 03:26:10.250999	33610
1923	4	4	13	1728	2026-01-14 11:53:36.731044	25586
1924	5	5	54	1333	2026-01-29 02:39:50.839997	57000
1925	1	6	29	1610	2025-12-28 08:13:49.091442	179416
1926	2	7	42	2365	2025-12-15 08:14:47.71716	158076
1927	3	8	53	2964	2026-05-16 08:56:32.893207	150658
1928	4	9	34	2205	2026-05-05 10:22:22.851961	101706
1929	5	10	13	884	2026-03-08 04:29:24.742518	151227
1930	1	11	35	968	2026-02-14 14:14:14.368573	31884
1931	2	12	61	945	2026-04-11 12:47:53.01213	180757
1932	3	13	22	3654	2026-01-24 14:34:03.219897	11212
1933	4	14	48	2146	2026-03-04 11:15:16.925346	31659
1934	5	15	32	1972	2025-12-31 18:10:26.040493	92932
1935	1	16	25	2106	2025-12-11 00:03:41.74591	52450
1936	2	17	31	2052	2026-01-18 09:17:48.806565	117205
1937	3	18	16	875	2025-12-21 01:32:16.639011	112567
1938	4	19	36	1500	2025-12-25 09:51:11.051627	24014
1939	5	20	47	2220	2026-01-13 19:14:23.372552	121354
1940	1	21	15	611	2025-12-25 10:55:45.935842	89242
1941	2	22	51	2560	2026-03-29 11:39:31.549231	156145
1942	3	23	13	580	2026-02-23 08:40:02.974126	106121
1943	4	24	43	2236	2026-04-27 08:09:01.957706	67301
1944	5	25	43	867	2026-01-24 01:31:08.191162	8815
1945	1	26	51	2408	2026-03-25 21:07:51.725015	148750
1946	2	27	13	2014	2026-04-15 12:14:40.247374	72908
1947	3	28	31	2480	2025-12-11 17:15:12.821655	79272
1948	4	29	23	518	2026-04-02 01:56:04.016412	160046
1949	5	30	57	611	2026-04-06 11:56:52.051568	43575
1950	1	31	55	2419	2026-04-08 11:34:04.006498	17104
1951	2	32	63	1596	2026-05-07 23:23:41.151847	114127
1952	3	33	53	2880	2025-12-23 00:20:45.725811	69739
1953	4	34	53	840	2026-01-14 01:18:17.389472	185410
1954	5	35	21	2646	2026-03-19 11:10:01.143031	55646
1955	1	36	23	550	2025-12-05 07:02:22.653776	137724
1956	2	37	12	2419	2026-04-15 05:21:13.094872	119140
1957	3	38	10	1645	2026-02-07 23:16:42.143449	94166
1958	4	39	15	558	2026-04-08 09:30:43.104032	11019
1959	5	40	57	1728	2026-03-30 08:56:38.599254	196618
1960	1	1	42	1480	2026-03-10 07:58:31.514602	49811
1961	2	2	52	3432	2026-02-16 00:07:52.231744	134128
1962	3	3	21	2408	2026-03-20 18:04:40.900161	192597
1963	4	4	46	1034	2026-03-05 15:12:56.916073	88676
1964	5	5	52	3599	2025-12-15 20:03:08.753701	86475
1965	1	6	62	561	2026-04-03 23:20:08.816943	74601
1966	2	7	66	1334	2026-01-17 02:19:19.424758	182687
1967	3	8	35	2070	2026-02-28 19:13:35.555438	84411
1968	4	9	62	1360	2026-04-23 06:00:33.191363	134079
1969	5	10	13	987	2026-03-12 22:37:01.647836	35509
1970	1	11	25	1386	2026-04-15 19:11:41.735929	156552
1971	2	12	21	1457	2026-01-02 09:43:32.091692	190642
1972	3	13	35	2944	2026-01-23 17:09:42.357422	11215
1973	4	14	45	3015	2025-12-06 15:51:03.650025	39785
1974	5	15	23	2970	2026-03-12 07:48:56.160393	79233
1975	1	16	30	2430	2026-03-24 10:44:19.423698	90286
1976	2	17	53	2240	2025-12-01 14:44:46.120838	136570
1977	3	18	13	3186	2026-01-27 15:43:22.098711	103671
1978	4	19	43	1150	2026-02-28 04:07:24.180105	181190
1979	5	20	41	2088	2026-01-25 10:49:32.910264	47312
1980	1	21	24	1080	2025-12-05 18:18:04.855946	830
1981	2	22	22	1440	2025-11-25 01:16:36.809141	99688
1982	3	23	44	825	2026-04-22 19:07:16.534813	100242
1983	4	24	10	2862	2025-11-24 06:04:36.343191	154557
1984	5	25	55	864	2026-01-24 13:59:26.536502	145001
1985	1	26	62	810	2026-03-25 08:49:48.472955	174539
1986	2	27	25	595	2026-03-16 10:29:12.972923	67719
1987	3	28	41	1175	2026-03-08 03:33:56.577666	154874
1988	4	29	53	3366	2026-04-24 06:12:28.665465	188486
1989	5	30	39	2914	2026-01-15 19:40:05.540101	105272
1990	1	31	65	2805	2026-01-23 01:24:15.575256	109105
1991	2	32	36	2304	2026-04-29 21:04:27.957384	149149
1992	3	33	64	1672	2025-12-23 16:21:32.272337	103934
1993	4	34	46	765	2026-03-16 03:14:23.540921	141085
1994	5	35	26	2220	2026-05-10 22:48:26.358626	100232
1995	1	36	38	2108	2026-05-12 13:20:21.015437	156970
1996	2	37	46	1568	2026-03-08 05:11:00.981051	32400
1997	3	38	56	492	2026-01-25 08:39:13.216505	10523
1998	4	39	58	2124	2026-01-08 07:13:34.263895	101107
1999	5	40	30	1711	2026-04-12 13:33:24.967323	528
2000	1	1	68	2736	2026-01-28 12:37:46.733144	156001
2001	2	2	39	3024	2025-12-09 03:15:26.624084	186380
2002	3	3	15	2553	2025-11-25 16:20:21.624868	155992
2003	4	4	39	2915	2026-05-10 04:39:16.139736	20981
2004	5	5	69	735	2026-05-17 06:03:45.551986	190219
2005	1	6	53	2562	2026-03-01 18:29:07.188586	170113
2006	2	7	62	2242	2025-12-30 09:44:47.860826	100161
2007	3	8	18	2475	2026-02-27 22:57:31.694334	77838
2008	4	9	67	3025	2026-05-20 23:05:44.301612	141010
2009	5	10	37	2881	2025-11-29 04:32:44.003152	66704
2010	1	11	49	3422	2026-01-11 23:28:36.610061	7988
2011	2	12	18	3808	2026-02-15 07:33:15.082235	171088
2012	3	13	18	1650	2025-12-26 11:13:29.272954	134637
2013	4	14	35	3575	2026-01-28 20:49:06.809786	105137
2014	5	15	69	370	2026-03-22 04:49:58.465554	119373
2015	1	16	44	2080	2025-11-29 17:45:34.205615	34292
2016	2	17	36	3953	2026-02-04 14:10:03.790963	67798
2017	3	18	36	2009	2026-04-07 08:23:20.50289	15357
2018	4	19	35	984	2026-05-18 16:53:24.136247	13039
2019	5	20	43	3657	2025-12-17 11:56:58.566318	91455
2020	1	21	17	2193	2026-04-16 03:19:35.299863	112149
2021	2	22	34	1568	2025-12-21 17:41:37.976499	139979
2022	3	23	42	1786	2026-05-07 08:49:11.434967	110190
2023	4	24	25	2128	2026-01-11 12:59:55.538852	90164
2024	5	25	45	1295	2025-12-07 12:50:45.982304	151442
2025	1	26	60	816	2026-02-02 09:23:11.492595	12726
2026	2	27	53	2360	2026-05-17 21:14:34.552437	119209
2027	3	28	52	660	2026-01-08 00:39:25.777691	38703
2028	4	29	52	1160	2026-03-11 18:42:17.03213	101295
2029	5	30	14	2160	2026-02-20 02:05:34.553148	89487
2030	1	31	27	2750	2025-11-30 07:08:02.183806	10767
2031	2	32	13	3819	2025-12-06 10:21:46.703618	36815
2032	3	33	61	1122	2026-04-14 14:19:54.151915	98974
2033	4	34	53	1395	2026-03-12 22:03:00.443203	164947
2034	5	35	53	2145	2026-01-30 01:25:02.684936	91571
2035	1	36	42	330	2026-04-09 02:12:01.949792	73153
2036	2	37	53	518	2025-11-23 15:21:21.7684	183275
2037	3	38	65	1219	2026-01-09 20:10:42.346645	105117
2038	4	39	27	2401	2026-04-06 11:41:54.242357	111571
2039	5	40	45	2145	2026-05-10 05:22:28.846747	59090
2040	1	1	14	810	2026-02-13 02:45:39.598168	1449
2041	2	2	52	2720	2026-01-11 18:31:29.238664	190146
2042	3	3	37	2516	2026-03-19 18:33:02.926672	134069
2043	4	4	63	380	2026-01-08 07:19:22.971562	170629
2044	5	5	40	2262	2026-04-04 15:28:47.919624	152350
2045	1	6	25	3770	2026-04-20 08:27:49.407264	98269
2046	2	7	51	1856	2025-12-04 09:07:48.81505	163086
2047	3	8	17	770	2026-03-17 02:14:39.842133	101194
2048	4	9	11	3078	2026-02-25 02:28:41.709543	180176
2049	5	10	66	627	2025-12-24 11:36:30.208294	37126
2050	1	11	61	2240	2026-05-07 23:50:03.936578	160131
2051	2	12	33	2632	2026-04-09 03:32:55.141015	159508
2052	3	13	53	468	2025-12-17 03:51:01.352842	142767
2053	4	14	21	2091	2026-05-13 15:27:27.384526	112740
2054	5	15	47	2262	2026-02-03 19:11:44.848518	127428
2055	1	16	51	798	2026-05-04 22:19:20.279281	48874
2056	2	17	11	1593	2026-04-07 08:38:37.723786	64964
2057	3	18	68	2583	2025-12-22 11:16:49.886499	87076
2058	4	19	56	2499	2026-03-01 09:11:34.163966	84393
2059	5	20	52	2552	2026-02-05 03:01:48.200428	116187
2060	1	21	18	1188	2026-03-27 18:00:13.341209	34023
2061	2	22	20	2135	2026-02-10 15:24:13.708387	69004
2062	3	23	44	1995	2026-04-06 18:47:40.052252	161750
2063	4	24	56	1924	2025-12-26 20:48:15.785592	177799
2064	5	25	59	3180	2026-03-12 20:00:57.177103	180944
2065	1	26	51	3016	2026-01-12 16:38:17.385093	19395
2066	2	27	35	2394	2025-11-30 05:36:49.330352	105817
2067	3	28	67	1450	2026-04-29 12:14:47.237415	178972
2068	4	29	53	1518	2026-03-06 21:01:16.350139	69859
2069	5	30	59	1426	2026-01-10 20:01:10.860214	139233
2070	1	31	59	3192	2026-01-13 14:51:42.902224	6518
2071	2	32	41	888	2026-05-20 07:20:02.42605	164401
2072	3	33	59	1344	2026-05-04 08:32:37.275373	116458
2073	4	34	45	1078	2025-12-10 08:03:02.013621	142149
2074	5	35	59	950	2026-03-03 12:04:36.488368	40495
2075	1	36	65	1881	2026-01-08 12:17:17.741639	147446
2076	2	37	38	2173	2026-02-03 18:14:36.670453	117058
2077	3	38	51	924	2026-03-08 22:40:09.490659	5129
2078	4	39	31	1089	2026-04-10 23:40:18.004591	71978
2079	5	40	65	1036	2026-03-13 16:53:58.705619	47846
2080	1	1	15	1720	2026-02-02 02:08:18.714107	26424
2081	2	2	59	1974	2025-11-23 01:55:58.292127	58064
2082	3	3	47	2000	2026-05-19 18:43:58.06388	30466
2083	4	4	39	1476	2026-03-15 02:14:08.396491	106833
2084	5	5	42	3717	2026-03-10 06:18:20.95206	136818
2085	1	6	27	1408	2025-11-30 03:11:47.919162	183357
2086	2	7	58	1276	2025-12-31 17:43:20.476094	177640
2087	3	8	61	1680	2026-02-21 14:04:27.747866	126895
2088	4	9	27	744	2025-12-16 14:31:33.984403	67936
2089	5	10	32	432	2026-03-29 23:01:17.493361	51145
2090	1	11	26	1782	2026-01-08 03:09:18.762087	58223
2091	2	12	58	2160	2025-12-12 05:51:34.736167	17597
2092	3	13	40	2915	2026-04-01 02:41:50.578915	143335
2093	4	14	47	3534	2026-05-09 12:12:03.726415	45856
2094	5	15	55	720	2026-02-20 15:42:11.818383	94682
2095	1	16	42	760	2025-12-27 04:07:49.298406	179303
2096	2	17	51	990	2026-01-01 02:37:23.150072	120842
2097	3	18	64	2646	2026-02-15 02:35:29.721974	121480
2098	4	19	45	418	2026-01-24 22:00:31.167527	66754
2099	5	20	40	2346	2026-03-10 22:48:44.879611	26435
2100	1	21	67	2200	2026-02-07 03:42:28.694515	155056
2101	2	22	14	450	2026-01-21 19:17:44.348348	174772
2102	3	23	68	2262	2026-01-09 20:00:58.64269	139673
2103	4	24	39	480	2026-01-26 02:09:35.035689	84545
2104	5	25	30	1558	2026-02-26 21:01:59.769932	77267
2105	1	26	33	476	2025-12-16 13:49:39.802256	38704
2106	2	27	66	2091	2025-11-28 01:52:12.066672	129375
2107	3	28	30	1188	2026-01-30 03:57:21.250146	109279
2108	4	29	37	1050	2026-05-16 15:15:06.748852	43849
2109	5	30	48	624	2026-02-20 02:59:46.398211	87564
2110	1	31	55	3162	2026-01-10 23:45:37.1808	160720
2111	2	32	49	2405	2026-02-06 01:05:58.434844	185155
2112	3	33	28	1334	2026-02-05 02:00:14.655028	78152
2113	4	34	32	960	2026-02-19 08:55:44.073332	132829
2114	5	35	35	2704	2026-02-05 05:35:03.054162	78898
2115	1	36	17	2814	2026-01-03 06:34:25.856971	27882
2116	2	37	15	810	2025-12-29 02:41:52.280589	145184
2117	3	38	61	480	2025-12-18 00:33:16.699893	40793
2118	4	39	30	2950	2026-04-30 09:19:55.63608	109293
2119	5	40	42	1121	2026-05-01 18:46:33.901949	115758
2120	1	1	14	2109	2026-01-27 08:50:30.138411	90718
2121	2	2	62	620	2026-03-02 03:11:15.042666	65271
2122	3	3	46	1652	2025-12-20 07:37:10.400189	86871
2123	4	4	31	1512	2026-04-08 04:51:06.63426	166981
2124	5	5	41	1320	2026-01-05 03:18:28.788428	106054
2126	2	7	35	1044	2025-12-26 15:42:09.34257	147899
2127	3	8	53	2784	2026-03-20 09:12:52.819219	34627
2128	4	9	55	2600	2026-01-15 12:12:45.732161	8580
2129	5	10	25	2156	2026-04-02 11:54:00.521327	4875
2130	1	11	69	1288	2026-03-21 12:10:57.510615	162183
2131	2	12	69	3286	2026-02-17 20:22:17.305802	26188
2132	3	13	34	1932	2026-04-11 13:55:36.377448	101347
2133	4	14	55	990	2026-01-03 09:19:39.721523	22599
2134	5	15	42	1060	2026-01-05 23:03:02.794799	141713
2135	1	16	54	2010	2026-03-07 05:02:33.762641	135558
2136	2	17	64	1836	2025-12-28 01:06:00.198427	174841
2137	3	18	58	4071	2025-11-30 19:16:33.431455	122200
2138	4	19	56	1247	2026-03-18 06:19:21.22722	145541
2139	5	20	17	2106	2026-02-02 14:00:56.196696	28708
2140	1	21	22	1007	2026-05-14 10:23:14.942967	176401
2141	2	22	38	3808	2026-02-06 22:21:47.633228	91521
2142	3	23	21	1560	2026-01-19 12:13:26.771652	182099
2143	4	24	11	2640	2025-12-09 04:02:21.568464	56612
2144	5	25	42	330	2026-03-25 12:59:17.908433	54682
2145	1	26	28	1196	2025-11-25 22:54:51.422639	26454
2146	2	27	53	1728	2026-02-22 08:01:54.788714	102097
2147	3	28	57	658	2026-04-18 23:08:25.72965	18201
2148	4	29	34	1400	2026-03-28 21:55:23.785273	116572
2149	5	30	34	2491	2026-01-13 03:40:23.241423	198140
2150	1	31	36	3658	2025-12-01 16:36:10.013366	126788
2151	2	32	58	2028	2026-05-10 03:16:19.830853	142988
2152	3	33	44	2538	2026-01-23 00:02:59.356808	78139
2153	4	34	69	1845	2025-12-14 11:29:13.714943	155426
2154	5	35	44	2500	2026-05-08 23:19:09.641128	87915
2155	1	36	54	792	2026-02-01 12:41:51.029875	40220
2156	2	37	49	1820	2026-05-03 09:50:43.818193	196902
2157	3	38	62	693	2026-04-19 08:56:50.636213	126690
2158	4	39	10	1287	2025-11-30 07:22:43.486005	22821
2159	5	40	63	496	2026-02-09 14:18:37.032598	126471
2160	1	1	47	407	2025-11-29 12:20:55.083268	110551
2161	2	2	14	943	2026-01-14 08:16:26.064154	2366
2162	3	3	15	2397	2026-03-15 01:37:25.787651	167066
2163	4	4	47	826	2026-05-19 21:18:40.2361	22148
2164	5	5	43	1450	2026-04-23 14:38:08.732635	51691
2165	1	6	13	1360	2026-02-15 20:33:58.965472	58155
2166	2	7	45	3060	2025-12-13 17:37:06.613789	112074
2167	3	8	14	444	2026-04-05 11:35:23.769411	37549
2168	4	9	31	528	2025-12-20 06:01:06.475694	82670
2169	5	10	63	1537	2025-12-14 02:25:00.868958	108174
2170	1	11	15	1456	2026-01-01 14:55:54.020354	41357
2171	2	12	11	2220	2026-04-28 15:59:47.760004	96742
2172	3	13	41	2496	2026-03-05 11:58:18.567457	14714
2173	4	14	22	2576	2026-04-15 02:37:52.214395	138251
2174	5	15	24	750	2026-01-12 14:43:06.187086	42157
2175	1	16	62	2478	2026-02-10 01:57:11.081883	104518
2176	2	17	30	2214	2026-03-16 12:55:56.357262	147146
2177	3	18	55	741	2026-03-20 20:19:06.65614	79802
2178	4	19	59	2484	2026-03-27 21:58:43.5469	180471
2179	5	20	24	726	2026-05-13 13:21:26.059312	161022
2180	1	21	15	750	2026-04-16 07:50:34.482473	130051
2181	2	22	67	2058	2026-01-12 20:12:45.78631	84659
2182	3	23	52	2091	2025-11-22 15:32:36.382883	121780
2183	4	24	42	874	2026-02-15 23:53:44.801738	108160
2184	5	25	51	2014	2026-02-10 01:49:12.809042	8999
2185	1	26	47	780	2026-02-14 23:59:38.620955	134045
2186	2	27	67	2256	2025-11-23 08:52:37.477037	57000
2187	3	28	64	1092	2025-12-07 08:54:48.123935	100571
2188	4	29	24	2262	2025-12-17 02:48:06.363925	177470
2189	5	30	64	350	2026-02-26 00:57:15.347142	140089
2190	1	31	39	2209	2026-03-26 03:11:47.563826	50893
2191	2	32	33	805	2025-12-22 14:40:09.5628	47819
2192	3	33	49	429	2026-01-01 00:16:35.678068	76829
2193	4	34	65	1200	2026-01-24 18:30:45.542827	95977
2194	5	35	62	1980	2025-12-12 16:21:19.50227	182941
2195	1	36	27	3216	2026-03-17 17:11:27.180319	196566
2196	2	37	29	2520	2026-01-17 09:14:33.671292	91524
2197	3	38	63	2760	2025-12-03 11:55:53.712131	194196
2198	4	39	47	2211	2026-05-13 05:15:27.834452	70993
2199	5	40	61	684	2025-12-28 19:12:17.751979	101959
2200	1	1	37	520	2026-04-23 03:11:22.523293	189337
2201	2	2	11	1950	2026-02-11 20:13:01.180756	190768
2202	3	3	56	2242	2025-12-09 17:51:22.543774	10745
2203	4	4	40	574	2026-03-09 00:17:35.821908	182881
2204	5	5	47	2958	2026-02-14 01:55:24.879952	61315
2205	1	6	62	1767	2026-04-06 16:57:21.783247	152566
2206	2	7	34	2772	2025-12-29 22:51:32.258717	47909
2207	3	8	60	1430	2026-01-14 17:48:12.990671	149738
2208	4	9	23	1924	2026-05-09 12:57:54.130689	44694
2209	5	10	23	2520	2026-05-06 22:31:27.898008	41851
2210	1	11	29	1377	2026-04-03 14:01:37.702952	102857
2211	2	12	25	2820	2026-02-16 06:41:57.365037	1825
2212	3	13	42	792	2026-04-12 04:58:12.555387	43120
2213	4	14	66	2310	2026-02-03 18:34:58.914138	87371
2214	5	15	14	1504	2026-02-05 08:04:44.179876	76270
2215	1	16	11	2412	2026-04-15 14:41:03.094464	73746
2216	2	17	12	704	2026-01-18 07:36:56.963908	111397
2217	3	18	31	1749	2026-04-12 16:07:15.755471	113774
2218	4	19	69	900	2026-01-17 14:51:14.882147	176219
2219	5	20	57	1344	2026-05-05 13:31:29.235047	41700
2220	1	21	57	2065	2026-05-09 07:48:33.658925	63228
2221	2	22	16	2277	2025-12-13 03:34:27.523179	126929
2222	3	23	44	1044	2026-02-11 18:55:21.696942	51150
2223	4	24	59	2360	2026-01-06 15:11:32.474693	190189
2224	5	25	62	1060	2026-01-15 02:49:48.463797	38450
2225	1	26	20	682	2026-02-17 22:44:58.399708	185277
2226	2	27	60	1872	2026-03-06 08:21:04.84489	140030
2227	3	28	29	2236	2026-01-18 05:40:06.691415	870
2228	4	29	65	3828	2025-12-04 16:05:01.728388	143342
2229	5	30	68	2223	2025-11-23 03:23:06.893676	24943
2230	1	31	49	1344	2026-04-20 15:57:17.39926	114136
2231	2	32	38	1485	2025-12-08 14:06:11.46578	170209
2232	3	33	34	741	2026-04-14 05:31:35.589227	167707
2233	4	34	27	1560	2026-03-06 12:03:20.580839	60068
2234	5	35	33	750	2026-03-15 18:47:22.148701	9105
2235	1	36	61	1892	2026-01-10 03:51:40.953181	6158
2236	2	37	21	1296	2026-01-05 15:34:05.376124	32799
2237	3	38	65	2784	2026-01-13 19:40:41.880099	129066
2238	4	39	43	407	2026-04-12 18:14:42.096975	182898
2239	5	40	34	1209	2026-02-22 22:20:27.302289	125501
2240	1	1	20	380	2026-04-07 17:55:22.494551	10803
2241	2	2	38	899	2025-12-05 19:54:45.044425	139293
2242	3	3	67	1804	2026-05-09 14:36:07.435488	32061
2243	4	4	67	2640	2026-04-19 12:08:53.176423	13694
2244	5	5	57	1406	2026-02-20 02:07:25.458479	199422
2245	1	6	39	1890	2026-01-22 02:33:27.626189	182462
2246	2	7	47	2592	2026-03-09 16:38:14.26286	108073
2247	3	8	48	1764	2026-02-14 04:12:31.510725	185087
2248	4	9	34	2760	2026-03-14 15:13:01.50588	115631
2249	5	10	46	1406	2026-01-28 13:50:49.580474	141386
2250	1	11	39	2418	2026-03-13 07:18:06.322667	145434
2251	2	12	64	1216	2026-01-31 23:31:50.552476	9566
2252	3	13	27	2128	2026-03-26 06:04:22.097669	149095
2253	4	14	26	3036	2026-03-23 00:15:58.687298	108464
2254	5	15	62	858	2026-04-10 16:25:55.300446	96766
2255	1	16	10	432	2026-01-04 19:28:46.16729	11372
2256	2	17	29	3400	2025-12-28 01:58:23.796769	67227
2257	3	18	15	2912	2025-12-13 11:58:08.293207	29450
2258	4	19	56	961	2025-12-06 18:51:48.601378	19223
2259	5	20	54	1792	2026-04-11 18:38:39.076118	86464
2260	1	21	39	2244	2026-02-20 03:23:15.331684	172761
2261	2	22	61	1512	2026-04-04 12:11:22.496413	13801
2262	3	23	12	952	2026-05-14 04:01:04.658404	46978
2263	4	24	53	1378	2026-01-17 16:14:48.982307	176904
2264	5	25	67	3016	2026-02-13 11:59:35.754208	97943
2265	1	26	19	868	2025-12-04 23:32:51.984879	71379
2266	2	27	20	2800	2026-04-02 08:35:47.194261	60825
2267	3	28	67	1216	2026-03-26 11:21:44.966124	31809
2268	4	29	34	1508	2025-12-14 22:16:47.565897	77149
2269	5	30	11	980	2026-02-23 01:49:35.506945	159890
2270	1	31	55	2116	2026-01-17 01:05:33.848369	10677
2271	2	32	18	360	2026-04-02 23:02:00.660334	182672
2272	3	33	41	837	2025-12-18 14:50:47.06618	20402
2273	4	34	44	1475	2026-03-09 18:26:54.271886	110534
2274	5	35	15	2436	2026-02-09 03:22:48.668812	184677
2275	1	36	47	1924	2026-01-12 15:04:33.366795	121286
2276	2	37	36	903	2026-05-20 16:24:36.158528	31845
2277	3	38	17	3332	2026-01-17 18:34:06.661236	154792
2278	4	39	69	1806	2025-12-22 00:41:23.168866	83559
2279	5	40	19	1634	2026-01-16 09:44:01.617386	23497
2280	1	1	23	1007	2026-01-11 12:18:59.110098	46024
2281	2	2	57	760	2026-02-20 06:16:13.092298	67009
2282	3	3	54	1116	2026-03-11 02:40:52.365474	109195
2283	4	4	69	1210	2026-04-15 02:04:12.38845	167962
2284	5	5	19	2613	2026-01-17 04:18:39.935941	55117
2285	1	6	35	3132	2026-04-13 13:00:56.322043	115350
2286	2	7	10	1450	2026-05-02 12:17:31.279364	136566
2287	3	8	24	544	2026-04-18 16:01:51.162598	86277
2288	4	9	55	1443	2026-03-14 17:58:59.128809	158169
2289	5	10	25	1190	2025-12-10 02:12:55.200138	97245
2290	1	11	45	992	2026-01-17 20:57:36.061099	170380
2291	2	12	23	837	2026-01-30 03:40:53.744518	101038
2292	3	13	39	4012	2026-04-13 05:15:01.201608	157246
2293	4	14	12	1368	2026-03-04 20:58:01.245773	188419
2294	5	15	36	2838	2026-05-03 15:18:36.968255	92722
2295	1	16	31	3410	2026-01-12 14:32:59.858685	178038
2296	2	17	34	840	2026-03-13 12:03:23.797443	24115
2297	3	18	58	676	2026-03-09 20:11:02.641285	160267
2298	4	19	36	860	2026-04-13 08:32:43.672084	107035
2299	5	20	65	864	2025-12-06 16:04:39.408293	90234
2300	1	21	30	1628	2025-12-27 02:43:06.30657	98895
2301	2	22	38	1092	2026-03-23 02:11:52.609255	160154
2302	3	23	28	708	2026-05-14 21:19:35.088844	44829
2303	4	24	37	2695	2026-05-06 00:10:00.909236	53031
2304	5	25	63	2970	2026-04-25 01:11:33.990402	48707
2305	1	26	17	2211	2026-03-14 18:38:41.537406	98265
2306	2	27	10	1620	2026-03-13 23:45:03.481455	189932
2307	3	28	19	390	2026-01-27 10:35:53.498237	130357
2308	4	29	23	2394	2026-03-07 07:42:42.4907	151460
2309	5	30	66	3456	2026-01-16 01:24:32.410575	66998
2310	1	31	64	1364	2026-02-05 09:41:02.068845	61016
2311	2	32	44	2829	2026-01-11 17:34:33.674866	191156
2312	3	33	19	2401	2026-01-28 23:19:53.09127	17859
2313	4	34	11	1512	2025-12-20 15:07:16.646702	104274
2314	5	35	24	2542	2025-12-11 05:09:29.307584	145076
2315	1	36	59	2754	2026-01-15 08:20:15.280217	112242
2316	2	37	45	1736	2026-02-05 07:53:39.3357	118609
2317	3	38	10	1395	2026-05-15 19:13:07.82851	67180
2318	4	39	33	2750	2026-05-06 20:57:53.114189	84958
2319	5	40	58	600	2026-04-25 01:45:15.813252	173256
2320	1	1	38	1025	2025-12-15 21:06:46.83895	97920
2321	2	2	43	576	2025-12-24 20:10:41.531393	199957
2322	3	3	60	2491	2025-12-08 16:05:19.45141	20157
2323	4	4	43	3150	2026-02-14 00:17:11.678903	104757
2324	5	5	28	1860	2026-03-26 02:07:27.532145	69181
2325	1	6	55	3402	2025-11-30 14:01:26.478333	104125
2326	2	7	32	3588	2026-04-14 16:56:38.06017	163006
2327	3	8	40	1075	2026-03-01 10:28:11.175295	41548
2328	4	9	49	840	2026-04-30 23:53:46.599095	140914
2329	5	10	66	1258	2026-04-17 18:20:31.576847	4123
2330	1	11	55	1792	2026-03-27 03:02:17.953859	80262
2331	2	12	10	1755	2026-01-06 22:13:23.78607	70665
2332	3	13	50	2565	2025-12-04 01:39:57.893045	196589
2333	4	14	67	861	2026-01-11 22:41:04.771335	7188
2334	5	15	21	1848	2026-01-20 08:11:11.153965	4614
2335	1	16	28	539	2026-05-18 11:41:46.450696	144770
2336	2	17	62	1978	2026-04-27 02:36:40.277804	7206
2337	3	18	46	2016	2026-02-01 11:59:17.379477	101179
2338	4	19	53	2666	2026-02-06 19:31:39.46645	51691
2339	5	20	62	576	2025-12-17 10:54:35.703624	125615
2340	1	21	44	1804	2025-12-21 06:52:12.584581	19997
2341	2	22	45	1575	2026-03-15 09:16:31.147191	192208
2342	3	23	66	2200	2026-05-13 21:10:48.39398	56700
2343	4	24	27	1470	2026-04-10 22:35:18.316388	66776
2344	5	25	54	1767	2025-12-26 00:41:41.883325	97034
2345	1	26	53	924	2026-01-17 00:51:04.829751	4492
2346	2	27	23	2091	2026-04-26 16:07:43.526392	145670
2347	3	28	52	2352	2025-11-24 09:43:24.344964	92406
2348	4	29	64	2691	2026-03-05 19:51:20.684473	1969
2349	5	30	10	1848	2026-03-21 23:05:20.898685	137913
2350	1	31	41	2016	2026-01-17 04:26:26.880945	4403
2351	2	32	40	2412	2026-04-25 02:08:19.847937	169799
2352	3	33	58	3150	2026-03-20 11:21:11.749862	112206
2353	4	34	56	2652	2026-02-19 15:03:29.519052	33935
2354	5	35	62	1887	2026-05-01 19:29:41.167269	17428
2355	1	36	35	572	2026-03-09 18:06:43.592738	172241
2356	2	37	30	630	2026-02-22 03:25:56.548958	144366
2357	3	38	24	528	2026-03-05 20:30:21.354931	194324
2358	4	39	18	1881	2026-04-25 15:50:55.829457	130556
2359	5	40	38	1444	2026-05-08 02:50:17.371949	65610
2360	1	1	66	1386	2026-01-01 21:53:01.501989	28494
2361	2	2	22	330	2026-04-30 02:51:22.553258	117975
2362	3	3	26	2068	2025-12-22 23:07:20.195737	108325
2363	4	4	44	2784	2026-01-13 08:28:29.483132	112461
2364	5	5	48	850	2025-12-19 04:56:43.396268	156413
2365	1	6	37	2196	2026-05-14 20:12:38.656097	113717
2366	2	7	41	1386	2026-03-25 02:26:51.206843	14114
2367	3	8	53	1406	2025-12-07 20:41:36.341065	159117
2368	4	9	13	1008	2026-03-05 11:22:26.16561	120771
2369	5	10	12	1023	2026-01-19 09:51:20.239112	81662
2370	1	11	23	2898	2026-05-16 08:33:25.473256	166412
2371	2	12	19	2091	2026-01-16 04:43:16.959992	15737
2372	3	13	13	3363	2026-03-09 04:22:51.235585	180001
2373	4	14	18	2832	2026-02-10 20:11:05.535051	185038
2374	5	15	62	1258	2025-12-30 08:52:26.689755	24632
2375	1	16	42	590	2026-05-05 17:33:09.244727	36153
2376	2	17	62	3472	2026-05-13 09:42:14.466731	90866
2377	3	18	26	320	2026-03-27 03:16:07.380021	174824
2378	4	19	26	930	2026-03-25 10:12:01.602756	29215
2379	5	20	69	1476	2025-12-10 02:04:28.93364	30072
2380	1	21	45	494	2026-03-14 23:30:44.390504	130121
2381	2	22	66	2552	2026-05-13 15:11:10.169764	8590
2382	3	23	24	620	2026-05-09 13:04:59.448125	85148
2383	4	24	11	2052	2026-02-14 10:56:28.583124	146570
2384	5	25	49	2448	2026-04-19 03:28:39.123376	50280
2385	1	26	34	2666	2025-12-09 16:03:47.502475	5583
2386	2	27	68	3000	2025-12-07 17:57:20.064101	115419
2387	3	28	62	2340	2026-01-24 17:34:35.347271	55676
2388	4	29	57	1480	2026-02-10 12:51:48.973041	71471
2389	5	30	69	1140	2026-02-01 09:57:11.890784	180809
2390	1	31	67	3381	2026-03-21 14:21:44.488422	158197
2391	2	32	25	1326	2026-03-04 23:57:30.354977	113155
2392	3	33	48	1386	2026-03-04 22:00:45.162106	191291
2393	4	34	30	550	2026-03-13 00:17:45.19937	137885
2394	5	35	29	2112	2026-03-18 00:29:18.509567	137773
2395	1	36	42	1496	2026-01-12 07:20:51.022616	107581
2396	2	37	41	2065	2025-12-16 03:12:46.334911	10137
2397	3	38	63	882	2026-04-26 16:47:46.978595	110938
2398	4	39	58	1428	2026-01-16 06:21:55.601993	107609
2399	5	40	58	2583	2026-04-07 13:17:37.584306	139382
2400	1	1	30	680	2026-02-24 09:51:28.784972	167899
2401	2	2	35	2300	2025-11-25 02:03:32.711877	91799
2402	3	3	35	3312	2026-01-25 18:24:00.812329	164912
2403	4	4	47	2322	2026-04-20 23:58:52.321493	130655
2404	5	5	37	1792	2026-02-14 11:00:30.606906	91270
2405	1	6	32	1984	2026-04-02 10:19:57.036729	9109
2406	2	7	30	3136	2026-01-16 09:01:02.180451	141677
2407	3	8	69	2050	2025-12-13 08:01:20.357584	17833
2408	4	9	56	2360	2026-02-22 11:43:15.497163	176048
2409	5	10	58	3102	2026-03-12 12:44:33.866714	103318
2410	1	11	24	1768	2026-05-06 07:21:49.320919	140021
2411	2	12	67	1480	2026-02-03 03:51:36.962095	75077
2412	3	13	69	500	2025-12-02 12:14:16.341152	110337
2413	4	14	41	3132	2026-04-17 00:10:05.723632	75258
2414	5	15	36	2240	2025-12-25 00:21:46.090198	78248
2415	1	16	47	1560	2025-12-05 13:56:06.438456	18500
2416	2	17	37	3456	2026-01-08 01:23:37.305848	126990
2417	3	18	13	2856	2026-04-08 21:39:03.498743	154106
2418	4	19	33	3008	2025-11-29 21:36:04.521275	18958
2419	5	20	65	1596	2026-05-17 15:36:59.589944	6631
2420	1	21	41	1848	2026-03-03 14:16:31.735451	126056
2421	2	22	57	3024	2026-03-11 20:37:13.469858	46299
2422	3	23	60	726	2026-03-10 16:34:49.711749	32783
2423	4	24	51	1830	2026-04-22 23:48:06.877109	126335
2424	5	25	31	2684	2025-12-10 09:23:21.056482	54502
2425	1	26	37	1551	2025-12-01 12:45:02.38877	63406
2426	2	27	65	2079	2026-03-21 17:05:05.790667	74239
2427	3	28	20	1575	2025-12-15 10:27:50.382094	58744
2428	4	29	50	832	2026-01-20 07:14:17.959458	17958
2430	1	31	65	1938	2026-02-07 22:33:17.72428	148386
2431	2	32	21	2860	2026-03-28 17:10:41.454576	105311
2432	3	33	67	1452	2026-05-05 08:46:02.166229	33956
2433	4	34	49	1947	2026-05-05 13:44:04.004456	101684
2434	5	35	51	2016	2026-03-07 23:58:10.882174	133024
2435	1	36	10	525	2026-03-16 14:24:04.21176	135684
2436	2	37	56	1230	2025-11-23 20:54:22.899321	173879
2437	3	38	46	1334	2026-04-02 18:07:10.849749	28234
2438	4	39	22	2438	2026-03-18 13:56:33.448247	177151
2439	5	40	37	1036	2025-12-31 00:22:27.467305	161648
2440	1	1	39	588	2026-01-31 08:29:50.27518	95626
2441	2	2	13	2436	2026-02-04 10:06:39.755897	165827
2442	3	3	28	1330	2025-12-04 05:34:05.970967	160908
2443	4	4	27	1683	2026-01-21 01:52:19.450347	188663
2444	5	5	15	1040	2026-05-07 11:09:35.48293	131519
2445	1	6	58	1125	2026-04-24 17:41:22.175309	178723
2446	2	7	30	2600	2026-03-29 16:52:49.194585	145412
2447	3	8	22	2040	2025-12-08 18:01:42.44478	44707
2448	4	9	44	1118	2026-01-06 08:12:38.196619	162510
2449	5	10	68	2706	2026-03-11 14:58:39.581665	55171
2450	1	11	61	1014	2026-02-18 05:00:17.993134	107393
2451	2	12	36	528	2026-02-19 13:13:36.467806	153562
2452	3	13	38	1643	2025-12-20 01:01:07.841064	154198
2453	4	14	65	2275	2025-12-21 11:17:19.882143	110420
2454	5	15	60	1664	2026-04-12 01:23:09.371289	97925
2455	1	16	62	924	2026-04-15 03:07:56.95128	36639
2456	2	17	43	3036	2025-12-22 14:06:48.437512	1679
2457	3	18	33	2401	2026-03-28 15:01:11.420351	136526
2458	4	19	51	990	2026-04-28 15:15:33.094146	182066
2459	5	20	46	2610	2026-04-25 20:06:24.775192	8265
2460	1	21	11	1332	2026-01-28 18:25:25.154185	148379
2461	2	22	17	1537	2026-01-21 06:25:24.817327	131337
2462	3	23	22	1296	2026-03-30 20:07:19.403953	81498
2463	4	24	62	1107	2025-12-24 16:36:49.088059	107758
2464	5	25	48	1496	2026-04-02 10:30:45.601749	158351
2465	1	26	20	1482	2026-01-29 11:40:26.745442	36704
2466	2	27	21	1512	2026-05-10 23:37:08.223967	167685
2467	3	28	44	2958	2026-04-02 23:07:40.56249	65143
2468	4	29	41	1575	2026-03-01 15:13:20.296194	23119
2469	5	30	51	1386	2026-03-30 15:11:53.656941	178269
2470	1	31	47	936	2026-04-06 08:00:10.565318	88916
2471	2	32	12	2340	2025-12-02 11:27:28.943571	100348
2472	3	33	29	2652	2026-03-26 03:56:46.539691	103866
2473	4	34	55	1225	2025-12-13 18:00:58.379551	159483
2474	5	35	57	2318	2026-03-04 22:04:31.611626	11399
2475	1	36	38	1947	2026-02-24 03:29:53.480769	84004
2476	2	37	34	3050	2026-04-30 19:20:53.643178	15373
2477	3	38	66	2912	2026-04-14 10:56:08.397488	46043
2478	4	39	12	2585	2026-02-25 15:19:34.584026	95734
2479	5	40	35	1150	2025-12-17 05:06:14.661131	152975
2480	1	1	65	3355	2026-02-07 02:58:51.054385	39548
2481	2	2	52	765	2026-02-10 02:02:42.876278	78414
2482	3	3	34	1584	2025-12-18 09:23:58.948548	182438
2483	4	4	25	516	2025-11-29 15:28:57.997252	13244
2484	5	5	24	2074	2026-02-13 04:11:07.880075	57817
2485	1	6	32	1710	2026-01-31 03:35:35.721095	136611
2487	3	8	14	759	2026-02-22 00:40:57.389284	18503
2488	4	9	46	2244	2025-12-08 01:24:24.492342	149776
2489	5	10	17	1209	2026-05-09 08:27:11.246318	117041
2490	1	11	13	2494	2025-12-09 16:10:16.147336	147217
2491	2	12	36	1683	2025-12-02 06:26:23.745377	178845
2492	3	13	66	2132	2026-01-09 14:22:31.941478	71543
2493	4	14	33	3136	2026-02-10 17:59:25.629525	17770
2494	5	15	48	1850	2026-03-13 23:23:57.743569	156836
2495	1	16	48	559	2026-02-17 02:28:11.210687	65489
2496	2	17	50	1190	2026-01-31 08:08:22.744968	185112
2497	3	18	43	1595	2025-12-21 22:57:51.620468	193851
2498	4	19	42	600	2026-04-21 21:26:30.895542	2868
2499	5	20	69	1980	2026-04-03 04:23:32.178291	31953
2500	1	21	11	1517	2026-03-30 08:27:13.809642	101394
2501	2	22	26	3835	2026-04-19 20:51:02.599572	72397
2502	3	23	45	3074	2025-12-30 17:44:01.325889	68338
2503	4	24	41	1102	2026-01-03 06:58:21.503563	153920
2504	5	25	53	2132	2026-01-04 22:14:58.364345	118445
2505	1	26	55	3808	2025-12-05 15:57:44.271821	108600
2506	2	27	15	3105	2026-03-28 14:26:24.766845	187286
2507	3	28	26	630	2025-12-20 12:12:58.504123	150420
2508	4	29	26	3074	2026-01-18 00:30:12.242583	49343
2509	5	30	26	1760	2026-02-05 03:46:07.141621	32267
2510	1	31	20	3120	2025-12-19 22:42:28.222094	11188
2511	2	32	38	1485	2026-02-14 05:09:19.626479	190156
2512	3	33	30	705	2026-01-16 21:43:34.968282	12475
2513	4	34	34	612	2026-02-04 11:15:15.214265	121251
2514	5	35	28	1014	2025-12-06 07:23:43.836327	147661
2515	1	36	68	1710	2025-12-13 00:08:03.192218	196680
2516	2	37	59	2184	2025-12-28 05:21:25.707617	184004
2517	3	38	61	1419	2025-12-04 20:42:13.629073	61125
2518	4	39	33	2166	2025-12-21 14:30:24.176182	110409
2519	5	40	16	2508	2026-01-18 20:41:21.508321	134437
2520	1	1	35	3306	2026-02-15 05:06:43.339323	129068
2521	2	2	31	752	2025-12-04 11:57:12.985073	197420
2522	3	3	33	720	2025-11-26 00:02:01.124862	88550
2523	4	4	41	408	2026-03-31 17:19:07.513323	18645
2524	5	5	15	460	2026-01-17 18:21:35.240745	45174
2525	1	6	44	3036	2026-01-13 23:52:48.663766	4054
2526	2	7	57	2666	2026-02-15 04:58:06.022776	173501
2527	3	8	21	1020	2026-04-20 23:38:20.071199	142260
2528	4	9	60	1680	2026-02-11 22:42:29.442015	137081
2529	5	10	30	2668	2026-03-01 19:49:31.659657	41278
2530	1	11	28	3551	2026-01-05 19:40:10.555187	76350
2531	2	12	21	1924	2026-02-03 15:26:09.005524	25657
2532	3	13	42	1530	2026-01-13 04:53:52.506823	89281
2533	4	14	33	910	2025-11-23 03:25:00.382025	59281
2534	5	15	28	1044	2026-04-22 21:04:46.360936	121786
2535	1	16	51	2150	2026-02-07 05:32:50.099725	68102
2536	2	17	38	1152	2026-02-14 22:40:17.13099	67515
2537	3	18	10	480	2026-01-15 18:11:34.636052	174378
2538	4	19	68	2496	2026-02-26 11:10:56.233896	41041
2539	5	20	16	902	2025-12-05 09:26:52.156818	13304
2540	1	21	32	1952	2026-02-15 17:32:31.47671	197493
2541	2	22	56	2601	2026-03-23 13:00:17.612345	63696
2542	3	23	65	2891	2026-01-20 11:56:56.338108	142007
2543	4	24	68	2970	2026-01-13 08:53:07.168961	183878
2544	5	25	19	1320	2026-03-22 04:16:33.5174	65283
2545	1	26	40	2000	2026-05-18 04:07:12.706692	163311
2546	2	27	16	527	2025-12-27 22:16:40.547536	105100
2547	3	28	18	1786	2026-03-26 06:16:09.99312	148026
2548	4	29	18	1457	2026-01-02 10:05:41.019027	145370
2549	5	30	51	2280	2026-01-01 09:59:19.671167	148444
2550	1	31	40	2809	2026-01-18 12:27:20.234171	62332
2551	2	32	59	1900	2026-02-13 05:27:03.134811	102788
2552	3	33	26	1156	2025-11-22 16:30:43.265239	150971
2553	4	34	28	1184	2026-04-30 11:52:57.427077	89276
2554	5	35	66	2958	2026-03-08 18:04:29.413175	36404
2555	1	36	39	2580	2025-12-26 13:49:01.41101	141202
2556	2	37	21	2107	2026-01-15 18:55:20.491234	158034
2557	3	38	60	1980	2026-03-03 07:25:54.271311	60730
2558	4	39	57	1505	2026-01-02 01:46:10.451938	169694
2559	5	40	59	1656	2025-12-26 08:05:05.265652	63700
2560	1	1	44	672	2026-05-15 04:07:34.602302	113726
2561	2	2	20	1008	2026-04-26 12:12:54.809306	160279
2562	3	3	11	2184	2026-01-14 22:27:30.924872	60256
2563	4	4	25	779	2025-11-26 16:25:54.663821	104386
2564	5	5	20	1734	2026-02-24 21:51:01.583211	136683
2565	1	6	30	3068	2026-02-06 18:27:19.46426	9916
2566	2	7	59	1435	2026-04-01 11:34:16.753659	198616
2567	3	8	21	880	2026-02-01 07:59:17.611489	46878
2568	4	9	55	987	2026-02-04 11:21:36.540015	21139
2569	5	10	51	1452	2026-03-03 13:30:42.43427	173864
2570	1	11	44	660	2026-04-29 12:15:36.294728	47692
2571	2	12	37	1120	2026-02-16 19:21:38.290186	124856
2572	3	13	18	975	2025-11-29 16:06:19.592102	161553
2573	4	14	24	870	2026-04-05 08:26:31.504797	75378
2574	5	15	38	928	2026-03-17 11:56:57.977418	55717
2575	1	16	44	2035	2026-05-06 00:27:15.85672	20886
2576	2	17	34	1872	2026-04-20 14:33:45.794789	66455
2577	3	18	62	3250	2026-01-24 06:47:34.481427	177342
2578	4	19	21	2650	2025-12-17 07:22:09.220779	167427
2579	5	20	36	864	2026-03-27 23:58:29.870925	109676
2580	1	21	12	740	2026-02-27 23:35:34.963219	45849
2581	2	22	67	1296	2026-02-21 14:17:46.480214	60243
2582	3	23	59	826	2026-03-31 10:23:43.305438	183605
2583	4	24	57	1274	2026-04-02 07:08:12.516534	48548
2584	5	25	19	2508	2026-01-04 12:23:53.224263	35417
2585	1	26	23	1247	2026-01-30 13:00:50.693914	49597
2586	2	27	56	550	2026-01-25 18:18:26.870201	123989
2587	3	28	39	3528	2025-12-23 10:29:36.232716	39526
2588	4	29	61	1643	2026-01-01 20:17:43.535579	128535
2589	5	30	35	2379	2026-04-27 03:37:29.700531	124855
2590	1	31	39	1530	2026-04-21 11:17:54.026243	105501
2591	2	32	21	768	2026-04-28 12:30:21.754513	113989
2592	3	33	39	1100	2026-05-12 14:50:34.093725	192399
2593	4	34	61	1269	2026-04-18 20:13:04.480433	77607
2594	5	35	48	1596	2026-04-05 15:58:05.494675	124971
2595	1	36	14	1280	2026-01-24 11:58:41.18937	48675
2596	2	37	52	3132	2026-03-08 15:50:36.943021	178618
2597	3	38	55	672	2026-04-06 05:24:34.541041	23041
2598	4	39	35	2385	2026-02-07 23:59:53.655179	93804
2599	5	40	45	651	2026-03-17 07:49:53.395391	102845
2600	1	1	35	1656	2026-04-09 09:21:52.291666	26529
2601	2	2	45	2448	2026-05-01 16:28:25.509105	920
2602	3	3	24	1435	2025-12-05 20:43:46.984518	184345
2603	4	4	53	1518	2025-12-21 20:56:56.681182	10560
2604	5	5	25	1860	2026-02-09 20:05:26.082564	183884
2605	1	6	51	1457	2025-12-11 22:28:50.662074	129873
2606	2	7	38	660	2026-02-01 22:37:26.822339	179777
2607	3	8	19	1806	2026-01-19 03:17:20.374423	174643
2608	4	9	43	1508	2026-04-24 01:20:14.545421	75335
2609	5	10	32	1056	2026-02-12 04:45:26.444167	21171
2610	1	11	46	1674	2025-12-27 04:36:24.03725	47489
2611	2	12	25	2052	2025-12-05 14:07:41.530783	11639
2612	3	13	13	1568	2025-12-23 00:05:17.281656	111561
2613	4	14	22	2254	2026-03-13 20:50:03.090472	1921
2614	5	15	30	1484	2025-12-18 13:16:00.641705	61670
2615	1	16	58	2900	2025-12-10 23:20:54.452083	167880
2616	2	17	35	912	2025-12-12 02:04:57.92041	11653
2617	3	18	39	779	2026-05-18 22:42:22.9138	80856
2618	4	19	60	1880	2026-03-14 06:31:43.3017	9652
2619	5	20	32	3021	2026-04-27 04:44:53.310116	101565
2620	1	21	57	3149	2026-02-13 10:09:10.798462	45794
2621	2	22	32	396	2025-12-15 02:44:51.625515	52710
2622	3	23	25	2430	2026-01-02 16:18:12.908591	164966
2623	4	24	31	1830	2026-02-17 00:57:41.118224	22905
2624	5	25	63	870	2026-04-27 20:24:29.815421	172403
2625	1	26	53	2014	2026-04-30 20:30:11.209464	134860
2626	2	27	33	969	2026-03-29 20:29:31.864102	137957
2627	3	28	30	1058	2025-12-14 05:45:32.322158	16820
2628	4	29	48	1200	2026-05-02 21:50:30.561242	81851
2629	5	30	30	1248	2026-02-21 09:31:23.071188	67445
2630	1	31	25	624	2025-12-31 11:46:40.277852	73917
2631	2	32	26	1840	2026-02-11 19:44:17.985845	14513
2632	3	33	49	1044	2026-01-01 15:25:37.28089	96018
2633	4	34	25	2205	2026-01-11 19:02:17.514172	180424
2634	5	35	64	1290	2026-05-17 09:56:20.428182	34132
2635	1	36	18	2484	2026-03-02 09:45:52.410161	126263
2636	2	37	48	3828	2026-03-25 23:14:19.977106	29965
2637	3	38	14	1768	2026-04-22 20:37:04.375554	79946
2638	4	39	29	2832	2026-05-08 00:00:32.782907	92403
2639	5	40	50	2624	2026-04-13 23:59:55.541285	98729
2640	1	1	33	2898	2026-04-12 22:36:07.003687	39541
2641	2	2	66	912	2025-12-30 12:31:48.003725	53135
2642	3	3	38	1512	2026-04-21 12:06:21.949018	84028
2643	4	4	52	2193	2025-12-14 20:10:12.867148	20443
2644	5	5	23	1064	2026-02-09 19:55:08.787774	177334
2645	1	6	26	1184	2026-04-10 10:00:38.863455	9474
2646	2	7	19	1540	2026-02-22 08:06:28.938195	75718
2647	3	8	24	2856	2026-02-11 00:41:41.09291	98867
2648	4	9	12	1530	2026-04-14 21:44:38.345298	5851
2649	5	10	13	2310	2026-03-26 04:09:32.853237	86386
2650	1	11	38	2392	2026-01-12 19:27:39.787521	193637
2651	2	12	34	574	2026-03-20 16:13:08.834336	173502
2652	3	13	55	1840	2026-02-17 01:54:04.674764	199194
2653	4	14	52	1121	2026-04-08 13:17:58.657758	188352
2654	5	15	55	2900	2026-01-05 11:12:52.507691	7521
2655	1	16	68	480	2026-02-18 15:27:59.061118	29116
2656	2	17	44	2368	2026-03-17 18:10:11.364075	99159
2657	3	18	26	2881	2026-05-18 04:36:47.785096	124305
2658	4	19	47	1222	2026-04-02 05:40:08.303918	2830
2659	5	20	66	2156	2025-11-28 22:01:38.906284	94686
2660	1	21	64	1564	2025-12-02 19:13:54.647416	27618
2661	2	22	48	2223	2025-12-01 22:39:18.39844	153629
2662	3	23	41	1500	2026-02-20 09:14:56.388172	59905
2663	4	24	41	462	2025-12-06 19:51:24.939567	147066
2664	5	25	13	1640	2026-04-22 21:48:47.358922	163868
2665	1	26	55	952	2025-12-15 08:32:48.269495	66891
2666	2	27	44	3538	2026-02-08 13:10:01.858626	91213
2667	3	28	46	1421	2026-01-28 15:16:14.348321	16041
2668	4	29	64	832	2026-03-19 06:09:33.030391	102974
2669	5	30	22	1312	2026-02-19 22:19:43.613458	16192
2670	1	31	14	2210	2026-01-16 11:12:02.973315	143176
2671	2	32	40	2964	2026-01-10 20:05:53.833564	35618
2672	3	33	68	1872	2026-04-30 13:45:12.861782	155215
2673	4	34	64	3712	2026-05-10 03:13:07.797958	11583
2674	5	35	62	1400	2025-12-02 07:05:06.890391	20958
2675	1	36	62	3717	2026-01-06 23:55:21.680233	125265
2676	2	37	13	2600	2026-03-25 12:38:51.01334	18304
2677	3	38	54	1363	2026-04-18 23:46:57.868107	156969
2678	4	39	16	2184	2026-02-24 01:40:44.09115	18196
2679	5	40	41	1974	2026-03-10 02:23:02.669721	138810
2680	1	1	41	1189	2026-03-14 15:17:04.565154	134048
2681	2	2	40	1050	2025-12-21 23:03:47.351356	61669
2682	3	3	13	3078	2026-02-23 05:34:28.014199	184709
2683	4	4	27	1512	2026-02-03 08:03:58.623864	191955
2684	5	5	10	1056	2025-12-21 14:21:35.849354	88879
2685	1	6	16	3060	2026-03-13 07:22:33.853437	50871
2686	2	7	28	640	2026-05-03 06:27:42.326636	147799
2687	3	8	16	990	2026-02-03 18:06:31.481897	72102
2688	4	9	68	2958	2025-11-29 13:40:02.415774	189224
2689	5	10	16	2860	2026-01-29 01:56:23.02978	149579
2690	1	11	42	1232	2026-05-13 16:35:34.566055	115981
2691	2	12	59	2516	2026-01-21 04:03:49.335204	26336
2692	3	13	33	2499	2026-01-05 09:56:36.379001	71158
2693	4	14	26	1722	2026-05-13 06:47:13.462637	199790
2694	5	15	61	918	2026-03-11 09:47:21.728907	146816
2695	1	16	41	1710	2025-12-16 23:27:47.075718	140498
2696	2	17	10	648	2026-03-12 06:58:44.62483	84084
2697	3	18	38	754	2026-01-23 09:05:55.570318	157833
2698	4	19	66	1785	2026-03-24 03:39:17.528547	118966
2699	5	20	61	1320	2026-02-11 09:22:54.191486	53350
2700	1	21	13	1024	2025-11-27 03:21:57.048366	146859
2701	2	22	62	3068	2026-03-14 02:30:28.614233	13968
2702	3	23	45	2035	2026-04-30 19:15:14.070874	38126
2703	4	24	67	1683	2026-01-15 23:27:29.603879	85252
2704	5	25	33	1960	2026-04-05 06:41:44.535736	176316
2705	1	26	20	2385	2026-04-28 14:57:26.848995	15969
2706	2	27	39	1813	2026-01-09 08:03:42.411449	56094
2707	3	28	15	2544	2026-01-02 11:36:15.893764	129620
2708	4	29	50	2412	2026-02-12 11:55:23.341046	120080
2709	5	30	41	2332	2026-01-26 16:47:36.863091	95893
2710	1	31	61	2478	2026-04-27 02:37:15.510433	150957
2711	2	32	60	2385	2025-12-16 22:03:08.236247	14115
2712	3	33	44	1225	2025-12-29 13:36:48.976702	134920
2713	4	34	35	714	2026-03-16 08:55:28.613773	171425
2714	5	35	20	899	2026-03-08 15:12:10.641245	158871
2715	1	36	13	1012	2026-04-22 22:01:01.045218	103587
2716	2	37	41	2809	2026-03-04 14:26:56.962072	68308
2717	3	38	38	2178	2025-11-26 20:11:13.166518	161145
2718	4	39	33	3248	2025-12-28 20:41:04.677595	186391
2719	5	40	54	1566	2026-03-17 00:18:47.178999	155930
2720	1	1	46	1862	2026-02-15 20:23:26.05557	135090
2721	2	2	27	2695	2026-05-17 19:30:33.224777	65888
2722	3	3	14	1378	2025-12-30 02:24:54.772695	134158
2723	4	4	50	1200	2026-04-18 09:18:34.363708	104981
2724	5	5	67	900	2026-04-25 05:06:44.93593	19212
2725	1	6	33	2860	2026-03-08 13:32:48.701018	130991
2726	2	7	12	2303	2026-02-09 14:34:59.732163	49254
2727	3	8	48	1880	2026-01-15 01:32:23.115659	172212
2728	4	9	18	3243	2026-01-16 19:12:47.473637	195262
2729	5	10	16	1394	2026-01-07 11:02:59.453218	178042
2730	1	11	38	1419	2026-01-21 02:19:08.056074	163620
2731	2	12	64	384	2026-01-29 11:11:33.314252	97751
2732	3	13	63	1755	2026-03-08 09:31:10.503009	7800
2733	4	14	51	1248	2025-12-14 00:29:58.191248	133919
2734	5	15	58	1344	2026-01-07 22:17:50.636265	73801
2735	1	16	40	2862	2026-03-09 15:52:15.740033	46292
2736	2	17	61	2176	2026-05-09 06:06:54.934102	100900
2737	3	18	51	2035	2026-04-09 21:30:36.826552	190881
2738	4	19	47	1802	2026-01-24 07:44:12.922168	93942
2739	5	20	59	782	2025-12-22 06:34:50.95958	17991
2740	1	21	64	2070	2026-05-02 08:08:15.373117	113617
2741	2	22	59	1537	2026-03-05 14:09:18.890477	96577
2742	3	23	18	1176	2025-12-28 21:59:16.742283	145837
2743	4	24	35	1272	2025-12-26 09:44:35.045858	115347
2744	5	25	47	2200	2025-12-28 15:33:26.919469	25772
2745	1	26	10	1369	2026-01-13 23:15:49.233296	102897
2746	2	27	29	2135	2025-12-24 07:07:03.978603	23357
2747	3	28	22	1764	2025-12-28 03:56:00.024109	6677
2748	4	29	32	3240	2026-04-17 04:57:06.423173	132711
2749	5	30	66	585	2026-05-02 04:09:36.330504	110054
2750	1	31	39	2596	2026-01-18 07:24:21.042959	91896
2751	2	32	11	1920	2025-12-25 10:56:23.635436	196465
2752	3	33	49	1204	2026-04-24 13:58:18.588521	9975
2753	4	34	47	735	2026-03-08 06:03:50.53407	167937
2754	5	35	18	770	2026-04-20 13:27:33.416053	106790
2755	1	36	40	2898	2026-01-17 10:29:20.954236	130472
2756	2	37	52	1302	2025-11-26 07:43:48.38769	8290
2757	3	38	55	1421	2026-04-26 09:55:04.452806	113046
2758	4	39	31	374	2026-03-04 18:14:01.9905	117099
2759	5	40	43	1368	2026-01-22 01:42:30.914352	59427
2760	1	1	49	1008	2026-05-01 22:44:46.307135	53995
2761	2	2	11	2112	2025-12-09 22:15:08.680918	114474
2762	3	3	19	1190	2026-04-12 23:54:51.334288	93063
2763	4	4	54	2491	2026-04-29 17:21:25.047168	144523
2764	5	5	20	1302	2026-01-14 20:28:41.568367	124695
2765	1	6	47	1505	2026-02-16 14:23:56.726896	15746
2766	2	7	57	1295	2025-11-27 23:29:07.161791	16469
2767	3	8	41	1440	2026-05-15 00:17:48.005886	186732
2768	4	9	43	476	2026-05-14 15:29:00.453585	174153
2769	5	10	55	3864	2026-03-12 03:38:04.283861	863
2770	1	11	50	550	2026-01-24 01:23:27.39057	124472
2771	2	12	46	1551	2026-02-10 14:53:34.53323	71816
2772	3	13	44	1845	2025-12-03 16:19:38.913513	93879
2773	4	14	59	703	2026-01-13 07:16:13.496999	193663
2774	5	15	44	2904	2026-03-09 01:32:46.572354	194819
2775	1	16	40	612	2026-03-14 00:58:08.429475	56018
2776	2	17	20	663	2026-04-20 08:35:48.46251	112554
2777	3	18	14	1485	2026-02-20 17:53:41.291635	155157
2778	4	19	20	690	2026-04-15 23:14:39.263589	173358
2779	5	20	13	3024	2026-02-28 04:00:51.935075	81951
2780	1	21	19	1845	2025-12-25 16:10:45.665532	141755
2781	2	22	65	1755	2025-12-24 07:11:35.904824	85670
2782	3	23	45	3080	2026-05-15 17:58:29.464999	16774
2783	4	24	31	2961	2026-04-03 08:02:18.56121	38277
2784	5	25	33	2850	2026-02-27 22:14:31.298015	123079
2785	1	26	15	1829	2025-11-30 12:31:47.487276	69828
2786	2	27	17	1029	2026-05-01 02:41:37.759214	146662
2787	3	28	44	3294	2026-03-11 08:47:01.119542	134857
2788	4	29	25	832	2025-12-02 16:02:45.46322	90826
2789	5	30	49	1856	2026-05-01 05:31:40.071825	173931
2790	1	31	62	1792	2026-04-10 19:22:38.141241	81698
2791	2	32	56	2867	2026-04-23 02:10:38.570861	45341
2792	3	33	33	888	2026-05-12 00:25:37.925839	96511
2793	4	34	26	1551	2026-02-14 05:51:00.43235	22100
2794	5	35	13	2585	2025-12-15 02:53:58.857321	151649
2795	1	36	67	528	2025-11-30 15:51:41.724144	57574
2796	2	37	57	2491	2026-02-12 15:47:21.040808	151209
2797	3	38	57	840	2026-03-26 15:45:06.849327	139592
2798	4	39	25	1085	2026-04-05 16:47:34.600927	133991
2799	5	40	57	1554	2026-03-11 20:10:58.214411	73272
2800	1	1	24	2048	2026-01-29 20:14:30.193499	122216
2801	2	2	22	924	2026-01-25 22:27:54.86172	194669
2802	3	3	22	2124	2025-12-07 04:18:37.434495	182921
2803	4	4	52	1012	2026-04-03 02:48:00.921712	87029
2804	5	5	11	1275	2026-02-02 03:06:01.981716	98883
2805	1	6	42	1271	2025-12-21 04:52:30.727727	729
2806	2	7	31	1862	2026-05-17 08:12:18.250709	160713
2807	3	8	33	3036	2026-02-23 14:47:07.117099	189962
2808	4	9	60	1643	2026-03-07 07:05:18.423528	54126
2809	5	10	22	1890	2026-02-16 13:03:05.831973	162062
2810	1	11	24	2668	2025-12-12 19:19:59.167944	33525
2811	2	12	69	2116	2025-12-17 16:10:34.518573	63597
2812	3	13	45	3132	2026-01-12 02:31:45.33221	111786
2813	4	14	64	2530	2026-01-18 09:42:40.566896	147233
2814	5	15	56	2301	2026-04-24 18:28:56.888035	87896
2815	1	16	55	945	2026-01-18 03:31:43.529146	170110
2816	2	17	31	1325	2026-04-21 22:32:45.837485	58535
2817	3	18	41	3894	2026-02-09 12:36:02.03565	178001
2818	4	19	66	3445	2026-03-06 19:51:25.829357	15825
2819	5	20	14	2016	2026-01-04 08:46:19.095135	165483
2820	1	21	16	1457	2026-04-17 06:49:53.902769	1775
2821	2	22	33	1850	2026-04-10 15:30:07.798563	169524
2822	3	23	51	1369	2026-03-25 07:52:05.098114	104166
2823	4	24	15	1080	2026-02-02 15:54:37.828342	112045
2824	5	25	42	1014	2026-01-06 08:48:30.943969	73712
2825	1	26	25	2695	2026-04-04 13:59:26.973816	55535
2826	2	27	44	1050	2025-12-17 00:33:31.221505	199747
2827	3	28	22	1296	2026-03-03 21:47:23.770028	49383
2828	4	29	21	714	2026-02-27 15:28:17.076565	51079
2829	5	30	60	1450	2026-01-17 16:14:34.181192	142336
2830	1	31	29	3105	2026-02-15 12:02:23.767685	854
2831	2	32	23	1323	2026-01-13 15:38:32.016781	175564
2832	3	33	25	3078	2025-11-24 01:02:09.212405	23182
2833	4	34	52	420	2026-05-10 09:02:11.537536	65239
2834	5	35	60	726	2026-03-02 12:54:12.645956	31277
2835	1	36	47	2120	2025-12-30 01:50:08.73865	7984
2836	2	37	69	800	2026-05-13 07:15:03.754196	124133
2837	3	38	49	1984	2026-05-03 18:20:46.622559	197196
2838	4	39	40	624	2026-03-08 07:55:28.532609	98026
2839	5	40	50	2244	2026-04-29 19:54:35.934054	85885
2840	1	1	53	1482	2026-03-30 17:30:18.959098	178836
2841	2	2	28	943	2025-12-29 11:29:04.72589	109055
2842	3	3	20	1110	2026-01-21 19:25:37.959708	95151
2843	4	4	42	2009	2026-01-18 00:51:51.617434	64181
2844	5	5	60	527	2026-01-18 20:08:05.454292	58028
2845	1	6	36	3127	2026-01-03 00:48:45.375834	104194
2846	2	7	55	2100	2026-05-04 04:36:28.144412	24079
2847	3	8	34	2242	2026-02-27 12:18:33.529963	183851
2848	4	9	39	636	2026-03-01 17:58:52.71961	66953
2849	5	10	26	2205	2026-03-21 10:59:31.231337	59784
2850	1	11	39	2288	2026-02-23 19:09:25.970652	45175
2851	2	12	22	576	2026-01-07 10:08:31.503949	149359
2852	3	13	28	2300	2026-04-11 11:59:46.220158	2597
2853	4	14	60	2145	2026-02-28 20:37:55.214484	160085
2854	5	15	33	450	2026-03-24 19:38:48.783333	103134
2855	1	16	23	2244	2026-05-20 00:33:36.109645	5309
2856	2	17	29	972	2026-04-16 15:47:59.352287	157995
2857	3	18	50	1540	2025-12-25 12:35:50.510297	78235
2858	4	19	67	1260	2026-03-19 22:24:03.500154	4027
2859	5	20	28	714	2025-12-30 19:30:33.78985	141464
2860	1	21	28	1612	2026-01-30 08:51:34.521118	26745
2861	2	22	38	1166	2026-02-09 16:26:52.728908	115519
2862	3	23	50	3953	2026-02-15 11:59:28.114993	76923
2863	4	24	13	1134	2025-11-30 11:33:44.495682	100049
2864	5	25	37	740	2026-04-01 10:28:04.502022	97073
2865	1	26	42	3416	2025-12-10 18:24:47.444377	193532
2866	2	27	49	2394	2026-02-13 17:07:01.902856	72722
2867	3	28	57	2303	2026-01-15 05:07:42.726626	30806
2868	4	29	36	2494	2025-12-23 01:25:54.021522	104408
2869	5	30	52	1176	2026-03-10 13:20:40.101672	63106
2870	1	31	21	3300	2026-01-21 12:15:32.314767	9171
2871	2	32	37	3068	2026-01-31 07:34:42.130812	91810
2872	3	33	58	528	2025-12-28 10:04:24.350603	14488
2873	4	34	12	3422	2025-12-19 04:23:14.776867	105354
2874	5	35	38	901	2026-05-12 05:49:03.102492	124388
2875	1	36	42	696	2025-12-18 21:54:34.395978	173319
2876	2	37	17	925	2026-04-01 21:35:17.699817	68005
2877	3	38	27	2444	2026-04-28 12:40:02.877533	22787
2878	4	39	51	2928	2026-04-02 17:01:58.437286	120007
2879	5	40	12	3149	2025-11-27 10:00:18.866614	29059
2880	1	1	32	1680	2026-03-18 15:44:52.29343	196567
2881	2	2	65	2211	2026-05-17 03:33:02.376339	195020
2882	3	3	67	1792	2026-05-21 04:52:20.413467	94723
2883	4	4	56	3213	2026-01-27 10:13:06.478226	67940
2884	5	5	26	3422	2026-03-31 03:27:26.635961	119360
2885	1	6	64	1496	2025-12-24 19:13:12.390669	165184
2886	2	7	36	450	2026-01-05 12:38:29.751989	33965
2887	3	8	30	2650	2025-12-07 12:50:46.005005	39340
2888	4	9	47	960	2026-04-20 14:31:25.080279	109140
2889	5	10	23	2500	2025-12-02 07:00:57.090881	77836
2890	1	11	28	989	2026-04-01 19:25:58.082125	10642
2891	2	12	62	2380	2026-01-30 18:06:26.565127	136692
2892	3	13	65	1914	2026-02-05 03:27:23.729291	180489
2893	4	14	59	2064	2025-12-20 20:54:43.880726	187466
2894	5	15	39	1938	2026-05-18 06:14:00.718421	8128
2895	1	16	17	2900	2026-02-26 10:11:43.413235	189297
2896	2	17	11	3008	2026-02-03 00:29:26.363529	104821
2897	3	18	10	1131	2025-12-11 01:28:46.53186	149675
2898	4	19	58	1292	2026-05-05 04:07:42.592658	51201
2899	5	20	13	2145	2025-12-02 14:29:19.655449	38871
2900	1	21	38	891	2026-02-24 22:59:01.701082	195330
2901	2	22	43	675	2026-01-16 00:54:43.662623	183891
2902	3	23	48	2312	2026-03-13 20:31:53.96706	39742
2903	4	24	41	490	2026-01-01 12:21:52.451752	156917
2904	5	25	42	1020	2026-04-27 21:46:05.068955	184942
2905	1	26	61	1740	2026-05-01 00:52:12.417493	172669
2906	2	27	69	1702	2026-03-31 03:11:40.955998	190384
2907	3	28	36	1225	2025-12-06 14:55:37.538158	25393
2908	4	29	18	760	2026-01-08 21:47:21.896071	100044
2909	5	30	52	1344	2026-02-20 18:56:13.272509	16850
2910	1	31	27	1026	2026-02-28 17:16:50.21091	160881
2911	2	32	19	2088	2025-12-26 00:19:29.218821	190696
2912	3	33	48	1230	2026-03-03 00:17:27.022369	45020
2913	4	34	29	893	2026-03-28 01:34:42.497656	40691
2914	5	35	58	1666	2025-12-11 12:55:05.148247	11138
2915	1	36	49	2352	2026-04-22 10:05:18.458913	145358
2916	2	37	23	2970	2025-12-25 14:56:18.853929	165981
2917	3	38	26	1972	2026-01-26 07:59:05.667551	108149
2918	4	39	21	624	2026-04-23 14:00:06.733539	153951
2919	5	40	54	2145	2026-04-22 15:49:13.271601	157280
2920	1	1	27	3588	2026-03-10 18:27:27.420284	183927
2921	2	2	53	2346	2026-03-06 16:44:03.054629	74873
2922	3	3	44	800	2026-01-01 02:19:30.649838	73887
2923	4	4	47	952	2026-04-17 06:05:00.596125	87227
2924	5	5	44	1476	2025-12-04 08:02:41.022727	179597
2925	1	6	16	756	2026-01-02 11:18:15.781261	124801
2926	2	7	52	2064	2025-12-29 14:04:31.118264	114143
2927	3	8	33	1872	2026-01-26 14:25:45.548612	172942
2928	4	9	68	3078	2025-11-23 07:32:46.645499	77280
2929	5	10	39	2378	2026-04-16 21:30:12.554149	25701
2930	1	11	33	2814	2026-01-26 06:02:33.423744	140575
2931	2	12	56	1144	2026-04-11 18:44:33.157236	22278
2932	3	13	67	1920	2026-02-22 08:09:48.153228	138811
2933	4	14	52	1944	2026-03-29 04:15:02.746533	10501
2934	5	15	67	2548	2026-02-25 05:54:43.69801	129757
2935	1	16	17	1404	2026-03-14 02:15:29.833297	148909
2936	2	17	62	1643	2026-02-14 21:56:38.918144	149511
2937	3	18	58	1008	2026-03-15 12:03:29.895598	190598
2938	4	19	17	1144	2026-05-01 15:26:14.597322	75004
2939	5	20	34	2795	2025-12-31 03:54:54.88339	164455
2940	1	21	25	608	2026-02-03 17:15:34.030325	41057
2941	2	22	29	1980	2026-04-03 04:26:10.292234	108463
2942	3	23	68	1600	2026-01-05 20:24:16.919653	101476
2943	4	24	47	1271	2026-05-04 16:30:43.821842	116256
2944	5	25	24	1080	2026-03-13 07:59:03.987423	27808
2945	1	26	49	2394	2026-03-04 06:04:29.38878	47792
2946	2	27	55	1683	2025-11-29 09:19:09.052578	155243
2947	3	28	54	1443	2025-12-10 11:00:29.071176	46816
2948	4	29	63	1705	2026-02-01 02:30:39.63205	74136
2949	5	30	27	3591	2026-05-07 05:15:03.021676	35525
2950	1	31	48	2090	2025-12-25 18:01:56.717731	58575
2951	2	32	15	527	2026-01-02 07:57:46.777486	53889
2952	3	33	68	644	2026-03-09 23:44:08.932023	168090
2953	4	34	38	741	2026-04-04 08:34:23.192931	80527
2954	5	35	59	374	2025-11-25 22:10:44.888884	64049
2955	1	36	45	1326	2026-04-28 02:28:36.832896	106820
2956	2	37	39	1591	2026-02-18 04:30:05.169089	151904
2957	3	38	36	663	2026-03-21 20:46:11.18537	19787
2958	4	39	41	1512	2026-04-07 09:42:03.766375	131308
2959	5	40	36	3068	2025-12-19 03:43:59.750727	118394
2960	1	1	68	1980	2025-12-06 02:08:59.242263	14677
2961	2	2	59	1750	2025-12-15 14:21:43.938326	103815
2962	3	3	42	1782	2026-02-04 02:37:39.978521	166865
2963	4	4	32	1575	2026-04-12 13:38:20.196734	41909
2964	5	5	42	969	2026-01-27 19:53:26.356158	8828
2965	1	6	13	506	2026-04-24 13:10:54.659981	148463
2966	2	7	67	2376	2025-11-29 01:53:05.377633	148225
2967	3	8	42	2976	2026-02-12 01:46:33.249868	49967
2968	4	9	46	1833	2026-04-20 13:00:44.910388	109471
2969	5	10	29	396	2025-12-07 00:58:29.967998	38113
2970	1	11	34	3584	2026-04-10 13:23:37.617876	152061
2971	2	12	21	2100	2026-01-13 21:17:40.696862	161519
2972	3	13	56	1548	2026-01-10 07:10:51.172317	197413
2973	4	14	67	2288	2025-11-23 12:05:53.59612	95152
2974	5	15	15	3933	2026-03-20 22:33:12.472879	61690
2975	1	16	30	2816	2025-12-15 05:25:33.135887	107458
2976	2	17	34	2450	2026-02-02 05:55:58.762904	77513
2977	3	18	32	598	2026-01-06 15:44:50.738532	75922
2978	4	19	41	1666	2026-04-20 11:50:02.765756	179321
2979	5	20	19	3243	2026-05-19 02:58:02.189384	23343
2980	1	21	24	1450	2026-04-14 23:14:13.717783	123554
2981	2	22	22	2100	2026-03-25 02:10:44.588381	97790
2982	3	23	28	990	2026-04-11 01:35:29.759931	191146
2983	4	24	28	2162	2026-04-20 13:03:25.502396	176713
2984	5	25	54	645	2026-04-10 16:25:38.186137	123499
2985	1	26	65	3021	2025-12-09 17:05:50.502683	132455
2986	2	27	21	3185	2026-04-18 00:41:46.394783	9808
2987	3	28	67	3465	2026-02-01 20:22:36.388883	33637
2988	4	29	64	2135	2026-04-30 14:54:50.161475	87617
2989	5	30	20	1512	2026-02-18 02:16:42.784895	74915
2990	1	31	39	966	2026-01-18 18:08:56.607788	43733
2991	2	32	28	3306	2026-05-05 08:13:46.958723	9510
2992	3	33	60	1702	2026-03-05 01:51:39.017904	174937
2993	4	34	62	1536	2026-02-11 16:50:52.144293	18075
2994	5	35	53	800	2026-01-06 20:21:09.678119	24891
2995	1	36	57	1440	2025-12-13 15:48:33.713057	154251
2996	2	37	40	520	2026-02-23 12:41:53.576817	116549
2997	3	38	13	636	2025-12-14 04:09:02.145781	57360
2998	4	39	22	1480	2026-02-27 20:54:29.873735	25184
2999	5	40	29	1056	2025-12-25 05:35:56.031424	53287
3000	1	1	30	1197	2026-04-19 01:53:29.787417	14937
3001	2	2	65	2565	2026-01-05 07:51:28.497035	147041
3002	3	3	66	2112	2025-12-18 21:17:16.772761	49340
3003	4	4	31	902	2025-12-26 07:06:20.462621	135275
3004	5	5	29	3944	2026-02-21 16:12:28.966373	146492
3005	1	6	16	1430	2026-04-08 07:17:35.977163	101361
3006	2	7	67	460	2026-02-08 11:52:30.302165	198317
3007	3	8	64	1197	2026-04-06 05:33:10.284823	194556
3008	4	9	19	2340	2026-04-27 17:52:12.93203	172758
3009	5	10	35	3300	2025-12-12 23:47:17.627072	123639
3010	1	11	15	800	2026-01-31 10:03:58.197575	61986
3011	2	12	36	1750	2026-05-06 06:15:51.742825	156409
3012	3	13	65	600	2026-02-02 03:39:11.131903	50232
3013	4	14	67	875	2025-12-28 00:37:06.379721	141493
3014	5	15	49	2090	2025-12-17 06:09:36.999301	15547
3015	1	16	58	592	2026-03-31 03:04:02.107361	41091
3016	2	17	59	1456	2026-03-21 21:14:51.971487	169742
3017	3	18	65	1892	2026-04-17 14:54:25.14124	188373
3018	4	19	12	646	2025-12-04 12:32:17.612534	14059
3019	5	20	22	638	2026-02-10 10:49:14.836542	60747
3020	1	21	33	1430	2026-01-31 11:18:01.599004	157960
3021	2	22	62	2596	2026-02-21 06:31:20.282058	13757
3022	3	23	63	2120	2026-05-12 15:00:30.195749	46906
3023	4	24	15	2632	2026-03-22 10:41:19.727039	61215
3024	5	25	59	2915	2026-02-09 10:02:10.280703	18871
3025	1	26	46	817	2025-12-21 19:55:51.655501	106307
3026	2	27	14	1820	2026-03-02 06:55:33.491352	134941
3027	3	28	15	1624	2026-03-23 05:25:59.61156	113564
3028	4	29	32	1380	2025-12-21 06:45:21.933433	61603
3029	5	30	47	1394	2026-04-13 05:30:46.373525	159552
3030	1	31	55	576	2025-12-01 05:00:57.061426	131267
3031	2	32	55	660	2026-04-22 16:43:16.269548	103298
3032	3	33	21	2025	2026-01-04 16:37:04.535182	180441
3033	4	34	69	840	2026-02-20 06:03:57.039901	34966
3034	5	35	68	1440	2026-03-05 16:06:55.330513	114306
3035	1	36	66	1830	2026-03-02 14:41:36.620074	31850
3036	2	37	12	2436	2026-04-19 20:28:38.972065	172749
3037	3	38	56	1023	2025-12-20 06:01:15.396901	9061
3038	4	39	34	1332	2026-02-20 02:05:15.726212	96508
3039	5	40	33	1116	2026-04-28 10:39:41.206134	71588
3040	1	1	48	2907	2026-05-12 08:21:00.62612	87340
3041	2	2	53	1176	2026-05-03 01:32:53.024962	26235
3042	3	3	10	1457	2025-12-25 00:42:31.589208	119769
3043	4	4	38	517	2026-03-20 17:43:06.400888	30663
3044	5	5	69	3060	2026-05-09 08:20:19.475259	160192
3045	1	6	15	924	2025-12-08 13:01:38.317659	43997
3046	2	7	49	2244	2026-02-19 17:48:12.393269	133155
3047	3	8	50	1680	2026-02-10 03:36:06.417543	117436
3048	4	9	63	1344	2026-05-18 14:29:49.897231	107726
3049	5	10	60	2340	2026-05-09 06:18:06.094751	143483
3050	1	11	10	2209	2026-04-16 04:30:53.956383	17719
3051	2	12	34	1110	2026-01-13 04:07:17.664738	89453
3052	3	13	48	2394	2026-01-02 23:37:01.580072	28146
3053	4	14	37	3363	2026-05-21 05:00:29.099775	117788
3054	5	15	45	1536	2026-04-09 13:10:39.316266	177625
3055	1	16	19	3726	2026-04-24 04:35:57.042706	186490
3056	2	17	58	602	2026-02-20 01:29:21.520674	167776
3057	3	18	38	1421	2026-02-08 19:30:14.008854	37118
3058	4	19	35	2655	2026-02-08 18:22:54.923921	71003
3059	5	20	68	1683	2026-05-17 16:45:52.75632	38955
3060	1	21	61	540	2025-12-06 03:04:37.125809	61456
3061	2	22	12	1104	2026-01-17 02:26:41.543683	176607
3062	3	23	17	440	2026-01-12 14:09:38.21629	165714
3063	4	24	50	2115	2026-04-10 12:01:29.353109	45378
3064	5	25	45	1012	2026-05-14 09:01:38.021064	164272
3065	1	26	43	2376	2026-04-28 06:20:15.621766	115455
3066	2	27	29	2546	2026-02-22 13:43:41.748599	161067
3067	3	28	29	517	2026-03-24 21:49:54.374123	60653
3068	4	29	66	700	2025-12-11 09:56:25.79368	15983
3069	5	30	67	2352	2026-04-14 15:13:20.537049	25782
3070	1	31	49	2860	2026-03-31 09:46:04.369001	179734
3071	2	32	58	1066	2026-04-26 07:28:45.018527	109581
3072	3	33	28	1470	2026-04-28 06:26:41.592455	112858
3073	4	34	69	2116	2026-04-03 15:16:59.025574	11142
3074	5	35	43	1480	2026-01-21 17:31:24.451775	81865
3075	1	36	57	799	2025-12-28 15:35:27.690061	61975
3076	2	37	64	1406	2026-04-21 02:34:03.184724	198418
3077	3	38	67	3102	2025-12-07 21:49:03.494993	140482
3078	4	39	52	3380	2026-02-22 00:05:23.196133	181844
3079	5	40	11	1804	2025-12-17 20:40:33.88105	72582
3080	1	1	45	576	2026-02-04 06:44:10.782503	6537
3081	2	2	45	648	2026-03-11 06:31:49.177389	166855
3082	3	3	22	2622	2026-02-24 06:41:18.425838	72493
3083	4	4	52	736	2026-03-09 10:54:21.858493	76107
3084	5	5	28	1566	2026-03-15 15:49:06.890409	92303
3085	1	6	40	1804	2026-02-04 19:39:25.032959	31543
3086	2	7	45	3162	2026-05-03 10:55:20.449661	122200
3087	3	8	14	672	2026-02-21 06:09:39.346766	182005
3088	4	9	22	2744	2026-02-16 07:14:40.023534	11107
3089	5	10	63	3528	2026-01-31 06:47:44.190962	85530
3090	1	11	60	1634	2026-04-17 00:44:44.661194	145187
3091	2	12	41	705	2026-04-28 00:34:14.18701	110307
3092	3	13	59	1408	2026-01-22 14:02:45.439487	117926
3093	4	14	43	1100	2025-12-04 04:52:58.424955	83531
3094	5	15	63	912	2026-02-11 21:12:29.071177	43318
3095	1	16	21	2491	2026-01-04 04:50:07.150937	101934
3096	2	17	65	920	2025-12-22 17:08:46.626617	164693
3097	3	18	36	960	2026-01-23 18:05:00.881405	168635
3098	4	19	36	3481	2026-02-11 08:30:02.883667	167409
3099	5	20	12	2050	2026-05-09 18:18:35.915476	119688
3100	1	21	55	630	2025-12-16 21:53:36.728096	2640
3101	2	22	21	2310	2025-11-27 18:45:48.596129	130927
3102	3	23	19	1088	2026-05-09 17:17:26.200321	47851
3103	4	24	53	1026	2026-05-20 22:38:30.599275	24033
3104	5	25	20	1820	2026-03-03 21:16:16.636977	143435
3105	1	26	11	1767	2026-02-19 21:04:35.226776	118974
3106	2	27	43	2773	2026-04-03 03:30:04.295613	19396
3107	3	28	28	2178	2026-04-19 06:47:48.015053	158751
3108	4	29	49	1302	2026-03-05 14:58:50.581291	94228
3109	5	30	40	1702	2026-01-30 07:22:36.690169	14924
3110	1	31	14	1104	2026-05-17 07:48:35.02955	45157
3111	2	32	46	2912	2026-01-23 05:53:17.432241	7371
3112	3	33	12	2262	2026-04-19 09:46:06.976101	73422
3113	4	34	67	2754	2026-02-13 07:29:35.106478	97310
3114	5	35	18	1045	2026-03-04 21:51:48.460188	169565
3115	1	36	44	2726	2026-04-30 02:19:19.664015	141181
3116	2	37	61	3380	2025-12-13 04:30:46.618344	121642
3117	3	38	52	456	2026-03-19 17:22:53.474364	41343
3118	4	39	66	3149	2026-04-01 11:13:56.671623	164317
3119	5	40	54	2950	2026-04-26 13:05:57.765982	140926
3120	1	1	46	1232	2026-01-10 16:14:46.11222	7625
3121	2	2	42	2772	2026-03-13 21:32:01.649668	75023
3122	3	3	47	2652	2026-02-01 22:33:34.40109	104243
3123	4	4	21	2040	2026-01-08 14:08:53.126756	103880
3124	5	5	39	3080	2025-12-07 18:52:12.52815	64265
3125	1	6	25	1680	2026-02-23 10:48:05.028919	12751
3126	2	7	55	2052	2025-12-16 16:28:54.234072	64377
3127	3	8	36	2132	2026-03-17 11:24:24.69061	100633
3128	4	9	25	1430	2025-11-29 15:41:12.395673	84379
3129	5	10	26	2760	2026-04-09 19:07:07.510596	114760
3130	1	11	41	2646	2025-11-24 23:42:43.280376	29900
3131	2	12	35	1786	2026-01-08 09:22:02.411835	143775
3132	3	13	42	2064	2026-03-08 15:32:03.098124	41881
3133	4	14	40	3481	2026-02-02 19:16:17.436079	86449
3134	5	15	17	990	2026-04-24 12:50:01.526853	162608
3135	1	16	44	2610	2026-01-28 07:25:10.830267	33405
3136	2	17	26	3304	2025-12-24 14:16:14.735062	191246
3137	3	18	19	2499	2026-05-10 04:02:52.475166	116713
3138	4	19	58	1035	2026-05-14 00:14:17.745645	190929
3139	5	20	30	3886	2026-04-12 16:20:19.012567	79077
3140	1	21	67	651	2025-11-30 23:54:33.483375	66473
3141	2	22	10	1122	2025-12-29 23:08:15.242008	125583
3142	3	23	69	961	2026-03-18 11:30:05.213968	197811
3143	4	24	50	954	2026-01-26 16:49:39.578983	104931
3144	5	25	20	3009	2026-03-24 07:05:23.655659	86435
3145	1	26	30	952	2026-04-09 15:44:11.723741	155478
3146	2	27	49	1680	2025-12-26 12:58:07.613137	47209
3147	3	28	51	3021	2026-04-10 01:58:12.30582	92812
3148	4	29	51	540	2026-05-19 01:09:08.565727	30805
3149	5	30	61	1150	2026-01-09 12:26:15.763947	112114
3150	1	31	19	1140	2025-12-09 15:11:29.77558	54368
3151	2	32	62	1984	2026-03-03 06:12:18.187601	16714
3152	3	33	47	2109	2026-03-29 06:20:39.510892	166051
3153	4	34	49	1020	2026-05-17 01:46:45.910335	117121
3154	5	35	51	495	2026-03-23 13:36:17.760427	111435
3155	1	36	38	572	2026-04-15 03:07:28.002287	117239
3156	2	37	27	3024	2026-01-09 20:17:02.272349	1545
3157	3	38	29	2867	2026-01-28 10:17:37.590826	28121
3158	4	39	36	1113	2026-03-25 00:03:46.270784	156620
3159	5	40	23	1147	2025-12-08 02:06:44.886046	102754
3160	1	1	22	1292	2026-01-21 15:52:11.610042	155470
3161	2	2	64	1665	2026-01-07 00:25:26.341923	177807
3162	3	3	13	1716	2026-01-12 20:23:30.950981	51839
3163	4	4	60	1035	2026-03-02 23:08:14.374048	136631
3164	5	5	32	2300	2026-05-13 13:36:04.098997	67465
3165	1	6	56	2256	2026-04-29 22:20:23.09683	146805
3166	2	7	10	2728	2026-04-21 19:28:55.653234	105302
3167	3	8	12	2756	2025-12-10 19:01:01.122904	34901
3168	4	9	53	3355	2026-03-19 02:02:24.056004	77001
3169	5	10	22	2835	2026-01-07 20:57:33.929794	177070
3170	1	11	13	624	2026-03-22 17:58:05.227784	97529
3171	2	12	50	1240	2026-01-26 21:49:45.511086	179518
3172	3	13	38	1188	2025-12-10 02:46:24.405518	87769
3173	4	14	41	2754	2026-03-05 16:48:37.14409	147189
3174	5	15	36	2640	2026-01-02 12:12:40.227384	14844
3175	1	16	21	2650	2026-01-17 02:09:43.828553	96438
3176	2	17	11	2256	2026-01-05 23:48:19.529265	90499
3177	3	18	61	690	2026-04-16 17:33:56.919854	137295
3178	4	19	58	1680	2026-05-12 10:54:13.364698	97662
3179	5	20	14	992	2025-12-04 12:58:41.51029	168800
3180	1	21	17	2208	2026-03-21 12:10:31.785688	82343
3181	2	22	35	1225	2026-03-14 00:54:09.225187	15962
3182	3	23	15	3480	2025-12-18 06:10:44.035647	184280
3183	4	24	64	1770	2026-04-12 10:10:21.284005	16929
3184	5	25	49	1386	2026-03-11 08:25:59.991094	190079
3185	1	26	34	2856	2025-12-28 04:51:46.277077	187121
3186	2	27	25	3264	2025-12-14 05:33:57.74167	156099
3187	3	28	10	741	2025-11-23 01:27:40.991135	91521
3188	4	29	12	550	2026-05-05 11:14:42.016307	120336
3189	5	30	52	420	2025-12-26 08:53:16.258239	100878
3190	1	31	55	418	2026-03-26 07:33:21.249156	28169
3191	2	32	52	2255	2026-02-05 22:33:13.813019	166157
3192	3	33	58	1782	2026-04-19 07:44:56.066291	59204
3193	4	34	17	2652	2025-12-06 21:11:04.922231	89180
3194	5	35	50	2565	2025-12-07 15:57:44.26477	191593
3195	1	36	29	930	2026-01-30 15:36:47.790398	154346
3196	2	37	57	2773	2026-02-18 12:31:38.743159	70880
3197	3	38	26	1911	2025-11-26 19:28:30.639625	178370
3198	4	39	30	385	2025-12-25 14:03:13.056469	28633
3199	5	40	59	980	2026-04-01 07:30:34.150527	112871
3200	1	1	14	1932	2026-03-30 22:16:03.573738	93433
3201	2	2	33	1023	2026-05-18 18:14:53.927423	2366
3202	3	3	10	1620	2026-03-22 07:51:13.359041	110427
3203	4	4	31	728	2026-05-12 20:53:45.419597	133429
3204	5	5	61	589	2026-03-15 11:29:29.573092	107570
3205	1	6	30	2788	2026-01-21 15:04:09.480549	163663
3206	2	7	42	1968	2026-04-29 12:09:37.090116	199201
3207	3	8	45	2226	2025-12-31 13:03:44.862467	91694
3208	4	9	27	1998	2026-03-14 14:10:14.815585	11283
3209	5	10	20	810	2026-01-13 14:51:16.000553	56594
3210	1	11	46	2100	2026-01-28 03:38:16.855502	95120
3211	2	12	68	2340	2026-05-17 08:25:44.649447	109167
3212	3	13	50	2009	2026-03-12 08:41:02.221024	93466
3213	4	14	45	1152	2026-04-03 19:25:47.324248	183446
3214	5	15	65	1887	2025-12-29 15:23:08.491569	49489
3215	1	16	35	2312	2026-05-11 01:49:22.214386	72426
3216	2	17	67	1225	2026-04-09 13:32:13.551466	153984
3217	3	18	43	1665	2026-02-06 13:12:28.496186	152911
3218	4	19	61	3036	2026-02-12 10:50:46.430211	44771
3219	5	20	27	2015	2026-02-23 20:06:45.337152	196466
3220	1	21	36	2376	2026-02-10 22:19:04.971379	143336
3221	2	22	27	605	2026-04-12 07:20:33.454901	156741
3222	3	23	33	3420	2026-05-20 12:41:13.221876	18599
3223	4	24	14	2223	2025-12-31 12:58:53.235467	130650
3224	5	25	16	960	2026-03-20 20:59:39.041824	119438
3225	1	26	21	2655	2025-12-19 03:18:09.521309	134110
3226	2	27	63	3465	2026-05-08 15:14:41.772804	39217
3227	3	28	22	1443	2026-05-18 23:44:04.18649	26204
3228	4	29	63	741	2025-12-30 07:26:24.264717	171841
3229	5	30	46	572	2026-01-14 18:01:08.077253	174806
3230	1	31	24	1656	2026-04-06 20:51:59.065532	184952
3231	2	32	55	2992	2026-04-09 17:57:45.40599	11612
3232	3	33	58	2135	2026-04-29 11:55:08.460096	23395
3233	4	34	69	578	2026-02-20 10:30:46.174478	197004
3234	5	35	68	1178	2025-12-09 00:35:13.332648	98213
3235	1	36	10	2204	2026-01-22 02:03:29.615136	92592
3236	2	37	13	2907	2026-03-08 19:21:26.895587	70195
3237	3	38	66	2989	2025-11-25 12:18:33.373372	48305
3238	4	39	10	2139	2026-02-20 17:25:34.721604	180621
3239	5	40	42	1860	2025-11-28 23:44:39.026814	7833
3240	1	1	68	3078	2026-05-16 05:23:03.876653	38724
3241	2	2	68	1560	2026-05-14 16:06:16.938706	124391
3242	3	3	51	770	2026-04-13 16:00:03.569126	87345
3243	4	4	56	816	2026-01-07 23:35:17.756077	7298
3244	5	5	21	1280	2026-05-20 16:23:15.425069	123345
3245	1	6	50	1100	2026-04-15 21:09:36.271465	74145
3246	2	7	39	680	2026-01-01 04:14:04.78481	29435
3247	3	8	61	2772	2026-03-21 09:06:55.844551	107564
3248	4	9	44	1440	2025-11-27 18:35:36.700304	83342
3249	5	10	68	2242	2026-05-18 19:47:49.728113	187626
3250	1	11	33	1064	2026-01-05 23:32:18.675087	80481
3251	2	12	35	1140	2026-03-12 11:22:27.238699	48313
3252	3	13	63	1178	2026-04-22 04:31:29.7332	125511
3253	4	14	54	1050	2026-05-01 17:35:19.366977	121933
3254	5	15	17	882	2026-04-12 04:01:24.704615	89665
3255	1	16	27	3024	2026-05-01 08:48:38.002052	106449
3256	2	17	68	1254	2025-11-28 18:42:52.830619	168081
3257	3	18	25	1596	2025-12-10 03:50:19.340375	129120
3258	4	19	17	1029	2026-02-28 01:37:43.006172	118336
3259	5	20	31	1408	2025-12-21 22:13:07.255448	90355
3260	1	21	35	2040	2026-01-03 23:59:33.977464	162079
3261	2	22	49	1350	2026-05-15 10:31:30.012867	161561
3262	3	23	65	836	2025-12-15 05:27:33.478025	58730
3263	4	24	48	1428	2026-04-29 02:07:18.044818	152702
3264	5	25	29	2255	2026-03-18 16:30:07.614798	83424
3265	1	26	46	825	2026-02-23 17:38:32.603987	156076
3266	2	27	16	1640	2026-02-08 20:18:40.622971	111292
3267	3	28	46	2772	2026-01-18 00:21:00.594019	191975
3268	4	29	41	1925	2026-05-10 16:44:44.82817	67244
3269	5	30	44	1470	2026-04-10 02:04:47.658621	45256
3270	1	31	60	370	2026-05-11 18:01:27.865918	152283
3271	2	32	13	2604	2026-01-06 16:47:54.974754	126811
3272	3	33	27	3306	2026-05-13 07:34:48.172315	43292
3273	4	34	62	2214	2026-03-26 08:00:29.490648	195861
3274	5	35	29	3192	2026-01-07 14:05:11.791396	40130
3275	1	36	38	510	2026-03-16 22:06:43.100328	97995
3276	2	37	39	1595	2026-01-13 00:07:14.115813	42859
3277	3	38	22	1643	2026-03-04 08:19:05.7002	106578
3278	4	39	29	2244	2026-02-14 22:35:56.876722	191601
3279	5	40	37	2915	2026-03-13 18:34:06.422341	199994
3280	1	1	21	1505	2026-04-30 21:28:40.432198	186879
3281	2	2	24	3294	2026-04-09 05:08:03.904994	157526
3282	3	3	35	1716	2026-01-09 01:33:02.399922	46704
3283	4	4	48	1395	2025-12-23 14:08:28.922588	169884
3284	5	5	46	1064	2026-04-11 13:55:04.037949	160046
3285	1	6	19	2280	2026-04-13 12:57:45.321989	120630
3286	2	7	10	2150	2026-05-09 01:42:43.627899	301
3287	3	8	19	930	2026-02-22 14:36:41.395599	132178
3288	4	9	19	1298	2026-05-13 23:49:49.555533	195195
3289	5	10	17	2601	2026-01-06 00:50:24.806465	51742
3290	1	11	47	2352	2026-01-24 05:38:31.781887	18781
3291	2	12	40	1815	2026-04-22 14:09:15.644024	187077
3292	3	13	38	986	2026-01-02 05:58:24.031741	170253
3293	4	14	25	2150	2026-04-07 16:48:41.640458	151870
3294	5	15	49	850	2026-02-10 15:49:46.579986	88592
3295	1	16	47	1770	2026-02-05 18:38:44.809183	182595
3296	2	17	49	2552	2026-03-17 20:23:22.257975	155298
3297	3	18	60	2585	2026-05-09 06:00:00.732718	60028
3298	4	19	46	2448	2026-02-24 15:24:38.864204	14032
3299	5	20	10	1364	2026-05-13 22:07:29.900459	155392
3300	1	21	22	2240	2026-01-30 21:32:34.38281	1429
3301	2	22	49	2064	2026-05-16 16:34:03.843667	156685
3302	3	23	67	1652	2025-12-12 06:51:36.800914	185600
3303	4	24	62	2444	2025-12-03 11:21:04.575656	165257
3304	5	25	42	2106	2026-05-08 18:14:58.728254	159848
3305	1	26	69	363	2026-01-08 20:19:22.352922	69472
3306	2	27	50	986	2026-01-10 02:18:32.724523	117755
3307	3	28	65	649	2026-02-09 11:33:50.113319	179290
3308	4	29	41	1380	2026-02-20 05:59:22.467944	137611
3309	5	30	36	2800	2025-11-27 16:55:29.40515	173797
3310	1	31	18	2904	2025-12-05 10:46:49.860135	15985
3311	2	32	42	420	2026-04-03 15:59:38.386937	155134
3312	3	33	69	2990	2026-03-05 19:57:10.4829	107928
3313	4	34	25	684	2026-04-02 07:35:45.955291	13917
3314	5	35	59	2580	2026-03-13 20:30:53.409968	72712
3315	1	36	33	2448	2026-04-22 01:33:01.50279	51202
3316	2	37	25	2016	2025-12-14 04:15:31.024263	102641
3317	3	38	46	1150	2025-11-28 23:09:48.692535	157524
3318	4	39	44	3234	2026-04-12 11:56:31.839148	8237
3319	5	40	52	1972	2026-01-15 22:23:47.994937	65704
3320	1	1	53	1856	2026-01-04 09:04:05.41571	41710
3321	2	2	23	2970	2026-04-18 20:14:44.764122	191714
3322	3	3	31	2706	2025-12-09 16:55:48.565212	177276
3323	4	4	24	3808	2025-12-25 20:49:19.510428	38948
3324	5	5	55	3264	2026-01-29 12:48:48.010753	164709
3325	1	6	10	1736	2026-02-18 04:47:26.222331	190556
3326	2	7	49	2091	2025-11-27 01:26:12.274412	123943
3327	3	8	31	1716	2026-01-25 05:53:59.034328	4435
3328	4	9	47	2668	2025-11-22 14:32:50.402109	168646
3329	5	10	60	2040	2026-04-21 06:30:42.811296	121436
3330	1	11	20	1305	2026-01-10 22:36:53.174173	167273
3331	2	12	34	2378	2026-05-16 08:54:46.454219	168801
3332	3	13	34	1450	2026-04-13 23:52:11.176328	18191
3333	4	14	31	1650	2026-05-19 19:06:50.539444	177647
3334	5	15	58	2128	2026-01-22 14:02:00.4391	64794
3335	1	16	50	3245	2026-04-12 22:10:59.575961	29857
3336	2	17	33	1334	2025-12-22 07:37:32.5011	113014
3337	3	18	34	1984	2026-01-16 10:44:47.659407	28198
3338	4	19	45	3422	2026-04-24 23:47:45.727942	47889
3339	5	20	46	690	2026-02-26 05:04:18.721628	149488
3340	1	21	11	780	2026-04-16 21:35:01.535561	133969
3341	2	22	42	1128	2026-02-24 23:07:39.218021	970
3342	3	23	21	1881	2026-05-16 02:53:13.338954	126679
3343	4	24	18	3534	2026-05-09 13:51:49.367097	181738
3344	5	25	41	2240	2026-02-22 00:39:16.161883	13041
3345	1	26	34	1836	2026-03-13 00:45:19.029084	145931
3346	2	27	59	516	2026-04-03 09:50:20.323811	23330
3347	3	28	15	3685	2026-03-15 01:54:41.2318	7527
3348	4	29	34	1716	2026-01-24 08:26:17.047017	44349
3349	5	30	54	2950	2025-11-28 12:14:17.484464	102293
3350	1	31	69	2128	2026-05-04 12:31:59.643035	145174
3351	2	32	43	2303	2026-05-18 11:47:05.364162	2225
3352	3	33	59	2747	2026-04-15 03:53:28.927752	24009
3353	4	34	61	1147	2025-12-27 00:12:40.549074	156364
3354	5	35	42	1829	2025-12-12 16:12:40.47608	12092
3355	1	36	20	403	2026-03-19 09:18:20.210633	173243
3356	2	37	11	2156	2026-02-15 09:38:36.526042	95316
3357	3	38	26	1071	2026-05-08 05:54:41.192237	172614
3358	4	39	30	385	2026-02-26 13:44:15.610443	953
3359	5	40	13	3264	2025-12-24 12:39:25.175303	59430
3360	1	1	23	1715	2026-03-03 21:21:56.607952	176295
3361	2	2	38	3712	2026-04-17 09:59:49.205793	163456
3362	3	3	49	2632	2026-04-10 07:01:08.461308	25634
3363	4	4	63	616	2025-12-30 22:45:38.465809	31477
3364	5	5	55	1320	2025-12-18 10:27:36.548949	194270
3365	1	6	67	2703	2026-04-09 11:15:38.385981	186769
3366	2	7	56	2862	2026-01-12 07:51:52.825101	83434
3367	3	8	55	1395	2026-02-28 06:13:06.546197	17390
3368	4	9	16	1020	2025-11-30 12:33:11.662692	126521
3369	5	10	49	2279	2026-05-09 13:59:05.948344	103228
3370	1	11	58	532	2026-04-07 19:06:34.984132	116765
3371	2	12	46	918	2026-02-12 17:04:12.55418	86225
3372	3	13	52	682	2026-04-30 09:54:55.569198	29895
3373	4	14	22	646	2026-04-16 23:16:45.087524	161807
3374	5	15	37	570	2026-01-20 05:25:15.646322	155453
3375	1	16	47	744	2026-04-26 18:01:48.553797	98450
3376	2	17	51	688	2025-12-10 18:30:56.373854	56815
3377	3	18	10	800	2026-04-15 21:32:49.683923	196101
3378	4	19	31	3036	2026-03-17 15:43:07.827999	98261
3379	5	20	60	1656	2026-01-19 10:19:54.691098	151907
3380	1	21	14	840	2025-12-03 19:16:06.673976	60755
3381	2	22	14	2562	2025-12-07 16:02:46.179772	190582
3382	3	23	66	1961	2025-11-24 12:24:05.965144	58483
3383	4	24	23	1880	2026-03-21 14:31:52.066456	44960
3384	5	25	15	972	2026-02-14 21:39:49.828719	96286
3385	1	26	65	1610	2026-04-10 13:57:48.829295	24453
3386	2	27	59	1450	2026-03-30 06:16:40.866031	32799
3387	3	28	39	2691	2026-03-19 08:02:09.620871	184394
3388	4	29	50	2898	2025-12-20 08:10:43.427446	51197
3389	5	30	67	2303	2026-04-07 13:42:27.547925	135708
3390	1	31	24	2970	2026-04-19 23:41:07.358146	85159
3391	2	32	22	2150	2026-01-06 20:11:07.55667	189090
3392	3	33	57	1617	2026-01-02 09:58:23.667426	172315
3393	4	34	16	1242	2026-04-01 17:04:56.669956	8693
3394	5	35	26	3762	2026-05-01 21:19:40.920602	61302
3395	1	36	63	3696	2026-04-19 16:54:57.490447	33710
3396	2	37	47	2730	2026-01-03 10:07:27.097789	12901
3397	3	38	47	1484	2026-01-28 05:46:11.066805	76470
3398	4	39	40	1428	2026-02-20 05:36:33.359115	185654
3399	5	40	68	3348	2026-04-30 06:04:06.269281	151883
3400	1	1	18	2900	2026-03-04 22:23:08.35449	173492
3401	2	2	30	2295	2026-03-08 05:21:18.849343	137831
3402	3	3	13	2000	2026-02-20 06:30:53.207575	110473
3403	4	4	56	1443	2026-01-13 01:18:59.746784	27838
3404	5	5	67	2592	2026-04-07 23:12:19.963158	115908
3405	1	6	54	2860	2026-03-30 09:15:04.817679	39976
3406	2	7	26	1638	2026-03-03 12:23:19.878006	176302
3407	3	8	61	1131	2026-04-18 11:39:57.084083	98811
3408	4	9	13	1575	2025-12-22 03:54:07.119286	51620
3409	5	10	61	1368	2026-01-22 03:18:51.912763	146819
3410	1	11	27	1845	2026-03-22 22:28:54.380794	129579
3411	2	12	44	1410	2026-02-01 08:41:56.593572	39960
3412	3	13	12	2040	2026-04-26 05:30:11.981786	65270
3413	4	14	39	944	2025-12-23 03:34:39.160837	197732
3414	5	15	64	2808	2026-05-12 00:33:54.465374	134050
3415	1	16	51	1100	2025-11-24 19:38:53.791742	106429
3416	2	17	11	891	2025-12-24 12:18:35.513701	83105
3417	3	18	67	3264	2026-03-09 00:49:06.172718	70430
3418	4	19	55	1288	2026-04-17 04:08:45.378074	27471
3419	5	20	13	3477	2026-02-16 19:49:51.197131	76215
3420	1	21	60	770	2026-02-28 19:37:09.707605	168594
3421	2	22	44	2300	2026-04-01 16:00:46.951715	81337
3422	3	23	25	430	2025-12-31 11:01:19.704949	159607
3423	4	24	68	1666	2026-01-20 19:31:06.954908	33528
3424	5	25	57	3025	2025-12-13 11:45:05.129305	17462
3425	1	26	46	429	2026-05-12 17:12:13.443911	186391
3426	2	27	21	1656	2026-02-23 08:11:13.390471	96792
3427	3	28	10	1782	2026-03-05 03:12:08.994892	37894
3428	4	29	41	1596	2026-05-10 01:16:11.970283	17128
3429	5	30	47	3072	2026-02-08 20:50:13.045218	125955
3430	1	31	22	1024	2026-01-22 20:40:17.683156	115475
3431	2	32	69	2805	2026-02-07 20:34:04.817635	176549
3432	3	33	47	2250	2026-05-15 11:08:59.931948	164908
3433	4	34	63	1920	2026-04-30 02:58:30.459242	127147
3434	5	35	14	1180	2026-04-22 15:39:43.389121	34908
3435	1	36	16	2028	2026-04-17 17:22:11.485299	52933
3436	2	37	15	533	2026-04-13 19:48:47.879968	8562
3437	3	38	31	1197	2026-04-11 13:19:56.352858	116577
3438	4	39	27	1326	2026-02-14 06:35:56.256152	38410
3439	5	40	37	1116	2026-04-07 06:47:35.021628	136673
3440	1	1	66	385	2026-04-30 17:10:03.627041	147582
3441	2	2	36	1798	2025-12-14 07:26:04.215403	16421
3442	3	3	46	2160	2026-04-02 00:39:38.133843	37328
3443	4	4	18	2058	2026-04-20 19:27:13.213769	70531
3444	5	5	46	3132	2026-01-16 09:31:49.871776	69743
3445	1	6	19	420	2026-02-22 02:41:16.203801	19662
3446	2	7	35	1173	2026-04-01 13:52:10.228844	164901
3447	3	8	22	2072	2026-05-13 00:19:03.712442	173945
3448	4	9	39	1705	2026-05-01 05:00:14.17831	22615
3449	5	10	56	2312	2026-04-02 05:10:47.536041	196970
3450	1	11	22	1260	2025-12-29 03:49:58.109889	29356
3451	2	12	62	500	2026-03-17 07:11:41.431593	495
3452	3	13	46	896	2026-01-10 06:43:25.11934	130883
3453	4	14	19	1435	2026-03-24 15:24:51.784986	176923
3454	5	15	53	2652	2026-01-26 09:35:34.111312	152112
3455	1	16	68	3185	2026-03-20 10:41:02.889349	137588
3456	2	17	40	1800	2026-02-07 05:19:27.409227	15130
3457	3	18	11	1760	2026-05-14 10:13:54.330505	88065
3458	4	19	47	1652	2026-04-15 16:25:29.540648	144931
3459	5	20	36	516	2026-01-03 22:13:02.306773	136465
3460	1	21	47	1134	2026-02-01 11:34:44.07242	173400
3461	2	22	64	2052	2026-01-09 14:43:14.642384	22363
3462	3	23	68	2100	2026-02-01 19:20:57.719322	15070
3463	4	24	24	3740	2026-05-17 13:27:04.402709	21648
3464	5	25	27	1295	2026-04-21 00:31:08.854401	54920
3465	1	26	22	2112	2026-01-18 01:17:55.434714	120836
3466	2	27	12	3306	2026-03-03 18:46:05.668832	10274
3467	3	28	45	2068	2025-12-03 23:59:44.29075	29937
3468	4	29	22	550	2026-04-23 17:43:32.623808	80270
3469	5	30	28	1748	2026-04-27 04:29:21.502337	180155
3470	1	31	24	1591	2026-01-08 00:39:33.6339	60995
3471	2	32	36	2597	2025-12-02 10:37:28.645961	132823
3472	3	33	36	800	2026-05-07 10:26:48.127729	154619
3473	4	34	62	1222	2026-02-12 21:46:29.868459	101196
3474	5	35	65	3068	2026-02-03 12:01:37.673025	84660
3475	1	36	11	1000	2026-01-27 03:08:00.903904	198347
3476	2	37	54	1140	2026-01-24 19:55:48.445512	169954
3477	3	38	24	1728	2026-04-19 17:30:27.201853	183602
3478	4	39	44	2268	2026-03-15 02:11:22.405979	175612
3479	5	40	42	1080	2026-04-24 15:16:04.711236	91471
3480	1	1	22	1938	2026-03-21 19:53:16.230934	99016
3481	2	2	25	806	2026-04-02 16:39:18.194281	138487
3482	3	3	16	3584	2026-02-04 19:23:42.262746	152240
3483	4	4	12	544	2026-02-05 08:50:07.510957	21294
3484	5	5	60	2394	2026-02-15 00:04:29.811637	44091
3485	1	6	33	1240	2026-05-19 19:15:19.991462	167690
3486	2	7	49	1575	2026-01-27 11:59:27.34345	122657
3487	3	8	27	2208	2026-03-22 12:01:24.379079	154769
3488	4	9	55	1749	2025-12-13 17:00:24.937114	99513
3489	5	10	32	2491	2026-02-21 01:16:09.430635	175078
3490	1	11	47	1904	2026-04-05 00:29:56.178852	195209
3491	2	12	61	1216	2026-03-01 02:44:13.208032	84973
3492	3	13	17	2464	2026-05-15 21:19:33.482923	188407
3493	4	14	59	986	2025-12-19 03:11:58.266048	90704
3494	5	15	38	2989	2026-03-04 11:10:09.46106	92058
3495	1	16	49	1320	2026-01-19 20:00:35.441164	138036
3496	2	17	17	572	2025-12-24 07:21:33.448354	81471
3497	3	18	41	3068	2026-03-27 09:59:36.082951	11599
3498	4	19	16	1768	2025-12-23 08:38:34.680951	172167
3499	5	20	60	836	2026-02-12 01:21:40.936263	134477
3500	1	21	22	855	2026-02-19 17:14:56.826073	168785
3501	2	22	61	2200	2026-04-24 11:16:08.62702	145384
3502	3	23	55	1224	2025-12-25 22:20:37.434758	190204
3503	4	24	12	2088	2026-01-07 04:47:20.19703	31669
3504	5	25	57	2990	2026-02-09 04:02:55.737366	195072
3505	1	26	67	675	2025-12-21 01:52:06.338601	68916
3506	2	27	37	1617	2026-03-02 15:42:49.140647	150580
3507	3	28	40	1995	2026-03-18 19:53:31.316314	133120
3508	4	29	24	396	2026-02-06 04:42:40.221577	104111
3509	5	30	69	805	2025-12-31 03:45:22.091915	14626
3510	1	31	21	2850	2026-05-16 22:41:31.906962	44361
3511	2	32	15	2464	2026-01-20 17:12:20.762157	110130
3512	3	33	26	2494	2026-05-14 16:04:17.82415	7836
3513	4	34	12	2244	2026-01-06 04:12:44.139361	98472
3514	5	35	39	2419	2026-03-22 19:11:02.427596	119827
3515	1	36	68	2142	2025-12-22 09:28:54.487938	160835
3516	2	37	28	702	2026-02-08 03:46:58.00411	110110
3517	3	38	30	611	2026-02-21 15:13:44.300293	182007
3518	4	39	23	2835	2026-04-22 23:58:28.811453	10466
3519	5	40	54	1632	2026-01-11 01:12:57.821881	69800
3520	1	1	31	924	2025-12-05 03:16:11.519288	130277
3521	2	2	66	3510	2026-04-01 21:27:04.122468	8994
3522	3	3	45	840	2026-01-12 22:04:09.220875	168453
3523	4	4	17	1120	2026-03-24 10:40:08.033298	29889
3525	1	6	27	2646	2026-02-23 01:45:22.914354	172725
3526	2	7	11	490	2026-02-28 13:02:03.892821	76667
3527	3	8	63	1056	2026-01-05 18:46:39.888008	106548
3528	4	9	40	530	2026-03-17 06:47:46.273561	119653
3529	5	10	16	3192	2026-01-15 22:34:45.523877	142930
3530	1	11	20	3186	2026-04-17 00:52:31.269849	135796
3531	2	12	36	1062	2026-01-08 22:19:41.544627	65398
3532	3	13	40	648	2026-04-17 12:29:17.651174	81610
3533	4	14	40	533	2026-01-14 19:00:08.63884	191075
3534	5	15	52	928	2026-05-21 04:24:09.535488	196389
3535	1	16	52	1247	2026-05-13 03:05:31.254915	142134
3536	2	17	45	1364	2025-11-24 00:36:08.616862	115331
3537	3	18	32	3762	2025-12-14 17:15:58.881156	136804
3538	4	19	36	658	2026-01-20 01:17:01.896428	152178
3539	5	20	67	2303	2026-05-16 12:30:34.011382	126046
3540	1	21	36	792	2026-03-14 04:28:56.27306	35569
3541	2	22	39	602	2026-01-06 09:57:45.386001	100712
3542	3	23	58	1736	2026-01-01 16:37:00.863318	162208
3543	4	24	58	2112	2026-01-27 15:42:02.798159	109268
3544	5	25	15	1548	2026-01-19 20:29:29.362527	170397
3545	1	26	68	1575	2025-12-03 23:57:49.868367	71815
3546	2	27	64	2070	2026-05-14 08:37:50.713859	41507
3547	3	28	31	1275	2026-05-09 13:45:25.011663	15957
3548	4	29	53	3933	2026-01-16 06:22:32.182673	122597
3549	5	30	40	3128	2026-01-08 21:41:34.532943	165580
3550	1	31	21	1643	2026-03-19 02:32:17.835858	82988
3551	2	32	13	2684	2026-01-10 15:36:27.893449	16005
3552	3	33	11	754	2025-12-02 16:31:59.824374	28271
3553	4	34	40	462	2026-05-15 07:16:01.735326	104353
3554	5	35	35	480	2025-12-11 22:51:30.932762	90989
3555	1	36	27	1326	2026-04-16 05:56:47.676021	181559
3556	2	37	27	3050	2026-03-27 15:44:23.906476	82730
3557	3	38	69	1100	2025-11-30 12:27:04.364653	14721
3558	4	39	61	3068	2025-12-27 13:06:58.612046	78924
3559	5	40	43	3584	2026-04-19 20:09:46.772564	133116
3560	1	1	52	1620	2025-11-26 06:08:52.691456	32078
3561	2	2	23	1300	2026-02-12 05:30:31.03223	20111
3562	3	3	37	882	2026-04-14 20:40:28.640673	101326
3563	4	4	49	1230	2026-04-17 18:25:38.816737	186608
3564	5	5	54	1085	2026-04-07 11:39:34.874651	130288
3565	1	6	50	742	2026-03-17 13:58:56.633199	64941
3566	2	7	68	1862	2026-02-13 04:10:34.784214	12423
3567	3	8	15	2448	2026-05-08 23:32:12.826941	28966
3568	4	9	64	1276	2026-01-07 21:28:22.512647	80812
3569	5	10	18	1440	2026-03-19 20:34:17.06484	11130
3570	1	11	66	1035	2026-03-14 06:00:40.183305	20707
3571	2	12	34	2400	2025-12-16 11:37:52.916766	21149
3572	3	13	48	1380	2026-01-23 12:38:50.942282	113196
3573	4	14	24	1764	2026-01-17 06:28:16.352705	116524
3574	5	15	49	1353	2025-12-25 04:28:25.3976	150036
3575	1	16	25	756	2026-03-29 15:59:55.16664	7532
3576	2	17	21	784	2026-05-18 23:32:40.711718	132549
3577	3	18	43	2376	2026-01-31 07:05:13.421811	32201
3578	4	19	45	1824	2026-01-24 02:36:35.615896	59836
3579	5	20	23	986	2026-05-15 04:19:18.637485	117396
3580	1	21	20	1700	2026-04-08 00:13:05.994817	71035
3581	2	22	33	2288	2026-03-24 23:38:15.361806	133416
3582	3	23	46	2244	2026-02-14 08:51:33.48633	178837
3583	4	24	30	3306	2026-02-27 20:13:55.901731	23036
3584	5	25	49	1856	2026-05-10 21:16:25.588677	148752
3585	1	26	24	2475	2026-02-18 16:41:58.175756	62951
3586	2	27	53	2176	2026-04-22 07:17:29.597624	99667
3587	3	28	51	1350	2026-03-18 13:15:30.967887	160284
3588	4	29	31	1596	2026-01-05 07:05:01.907984	48858
3589	5	30	41	3481	2026-04-27 22:40:10.043274	79936
3590	1	31	41	3024	2026-04-12 03:39:48.649613	124605
3591	2	32	31	2784	2026-03-14 16:37:20.925342	154497
3592	3	33	35	3432	2026-03-26 02:11:52.88879	19614
3593	4	34	19	1271	2026-02-05 11:20:12.761786	76290
3594	5	35	52	1836	2026-04-17 23:28:43.863062	156233
3595	1	36	49	925	2025-12-04 22:18:22.675203	108717
3596	2	37	40	1600	2026-01-09 02:33:28.68988	9643
3597	3	38	36	2576	2026-01-14 21:05:56.663793	153512
3598	4	39	16	2805	2025-12-24 08:48:04.71648	106245
3599	5	40	50	903	2025-12-13 07:56:39.330938	13374
3600	1	1	29	2013	2026-02-13 16:05:39.068868	125063
3601	2	2	45	2301	2025-12-03 23:38:40.090598	133257
3602	3	3	43	1914	2026-01-31 14:40:15.694633	50462
3603	4	4	61	2444	2026-01-02 11:44:23.537463	153293
3604	5	5	21	2040	2026-02-26 16:57:55.685271	19776
3605	1	6	48	990	2026-02-15 01:20:28.430939	79545
3606	2	7	41	2050	2026-03-28 02:29:39.129308	49359
3607	3	8	64	1645	2026-03-06 21:58:12.893589	157639
3608	4	9	62	3074	2026-01-02 13:34:48.125481	38667
3609	5	10	57	3795	2026-03-25 15:07:40.189883	173503
3610	1	11	25	2115	2026-01-27 03:21:00.522156	98393
3611	2	12	25	1430	2026-03-15 14:29:57.851066	162865
3612	3	13	22	2916	2026-03-10 13:45:54.757097	43170
3613	4	14	12	1519	2026-02-15 16:18:33.503505	60274
3614	5	15	66	1972	2026-05-09 10:22:23.053694	107224
3615	1	16	63	3078	2025-12-13 18:15:51.122992	176510
3616	2	17	41	2596	2026-01-09 16:18:04.241681	30495
3617	3	18	48	1785	2026-01-10 08:58:06.541864	134098
3618	4	19	59	1617	2026-02-05 11:38:41.567916	36615
3619	5	20	51	990	2026-05-17 16:59:18.30411	194007
3620	1	21	26	2160	2026-03-27 04:21:16.636221	33480
3621	2	22	67	1566	2025-12-26 15:24:08.534046	124569
3622	3	23	21	3186	2026-05-11 19:21:11.083084	92156
3623	4	24	54	1104	2026-01-02 15:36:20.585178	13888
3624	5	25	50	846	2026-04-24 06:45:44.9753	199187
3625	1	26	69	2128	2025-12-22 19:15:33.115989	3407
3626	2	27	37	810	2025-12-10 11:19:33.220092	7022
3628	4	29	66	2052	2026-01-05 08:04:40.979934	139332
3629	5	30	21	2666	2026-03-31 01:48:19.256805	92251
3630	1	31	11	2912	2026-02-24 23:21:09.607169	148
3631	2	32	14	2107	2025-12-05 07:16:07.939274	47524
3632	3	33	67	1334	2026-01-24 07:33:44.692238	117846
3633	4	34	30	1104	2026-01-24 05:14:48.251325	194282
3634	5	35	21	2278	2025-12-05 12:28:29.025988	41484
3635	1	36	53	2145	2026-04-26 00:08:31.717445	151696
3636	2	37	46	3400	2026-03-03 13:18:02.184083	115245
3637	3	38	65	2856	2026-03-14 20:02:00.868302	90778
3638	4	39	44	1023	2026-04-15 11:13:33.312925	142244
3639	5	40	48	630	2025-12-05 17:29:29.412523	15601
3640	1	1	69	1394	2026-03-20 17:27:51.411594	146904
3641	2	2	42	2714	2026-03-02 17:55:43.563796	29798
3642	3	3	63	720	2026-03-30 00:31:35.439084	31462
3643	4	4	33	912	2026-04-22 09:04:02.414936	6175
3644	5	5	27	2183	2026-03-16 11:31:06.685337	51598
3645	1	6	66	1932	2026-02-08 04:37:01.177404	169267
3646	2	7	65	675	2026-01-01 14:16:12.099526	97288
3647	3	8	22	1540	2026-01-20 02:54:04.584717	83093
3648	4	9	22	2790	2026-02-06 01:51:10.646347	39508
3649	5	10	26	992	2026-03-19 19:24:15.470383	142401
3650	1	11	37	1197	2026-04-22 02:34:36.18149	115726
3651	2	12	59	1740	2026-05-08 06:46:49.790456	46298
3652	3	13	29	1272	2026-02-15 03:32:54.249793	150056
3653	4	14	47	480	2026-01-17 00:40:07.180431	164933
3654	5	15	16	2226	2025-12-10 03:09:07.635794	199142
3655	1	16	68	1734	2026-02-07 16:20:11.861967	116254
3656	2	17	14	1352	2026-05-13 17:47:01.794984	73627
3657	3	18	47	675	2025-12-20 18:56:19.56046	12527
3658	4	19	65	2610	2026-01-07 09:25:39.276039	136823
3659	5	20	69	2000	2026-02-28 12:25:06.314221	136055
3660	1	21	13	600	2026-01-24 07:55:50.573175	19429
3661	2	22	37	3599	2026-01-06 07:52:13.824152	66509
3662	3	23	16	1326	2026-03-15 16:30:30.998143	50335
3663	4	24	21	2537	2025-12-15 01:55:31.018361	135951
3664	5	25	52	3021	2025-12-15 04:20:06.698708	130856
3665	1	26	36	3604	2026-02-16 06:23:11.224537	177271
3666	2	27	32	1034	2026-05-17 22:58:21.452247	89442
3667	3	28	43	2068	2025-12-20 12:48:04.722754	121693
3668	4	29	19	374	2026-05-07 05:28:39.124196	15841
3669	5	30	67	2028	2025-12-07 11:38:52.811206	52166
3670	1	31	37	1104	2025-12-17 20:17:26.908064	195829
3671	2	32	55	2296	2026-02-11 11:16:47.921521	189816
3672	3	33	31	2077	2025-12-06 21:44:14.726082	158588
3673	4	34	29	585	2026-05-17 02:28:53.618936	60186
3674	5	35	65	1071	2026-04-19 23:54:27.774839	17084
3675	1	36	23	2240	2026-01-15 20:42:42.553895	116187
3676	2	37	19	903	2026-01-22 12:12:06.339523	45756
3677	3	38	63	2262	2026-03-19 20:07:44.579587	99860
3678	4	39	54	1665	2026-05-20 09:50:52.114543	37977
3679	5	40	66	989	2025-12-02 13:31:16.74185	34549
3680	1	1	43	855	2026-03-26 09:28:24.512631	77880
3681	2	2	24	3240	2026-04-09 16:01:38.562085	106374
3682	3	3	50	637	2026-03-21 14:48:42.779754	111176
3683	4	4	28	903	2026-02-06 05:08:35.065636	26948
3684	5	5	54	2420	2025-11-26 20:58:10.84738	53148
3685	1	6	66	2115	2026-04-13 14:18:00.966853	78181
3686	2	7	23	2820	2026-03-27 04:03:56.134156	78757
3687	3	8	67	420	2026-05-12 08:13:08.028335	145845
3688	4	9	14	2788	2026-03-04 11:15:13.213036	4671
3689	5	10	69	1113	2025-12-02 03:37:04.149452	51123
3690	1	11	35	957	2026-02-14 21:37:47.672133	190451
3691	2	12	49	3306	2026-03-01 05:14:54.939719	69220
3692	3	13	69	1274	2026-05-13 18:16:06.558535	139197
3693	4	14	34	1680	2026-02-17 04:57:32.142769	30999
3694	5	15	66	1320	2025-12-18 19:06:43.354139	114806
3695	1	16	39	1504	2026-04-06 09:16:22.812289	170039
3696	2	17	57	1012	2026-01-30 08:36:23.607994	174307
3697	3	18	29	3752	2026-05-08 07:05:24.657523	198353
3698	4	19	20	2016	2025-12-03 04:45:03.783761	143296
3699	5	20	49	1520	2026-04-17 06:02:13.238805	173029
3700	1	21	40	968	2026-03-16 12:25:17.477625	20007
3701	2	22	38	880	2026-01-15 04:29:06.704721	31702
3702	3	23	55	1598	2026-05-04 09:41:27.356002	21544
3703	4	24	47	2070	2026-03-26 11:50:29.946032	77813
3704	5	25	18	1225	2026-04-10 06:25:02.11866	81644
3705	1	26	21	2035	2025-11-29 04:15:17.429018	165022
3706	2	27	37	864	2025-12-22 05:58:34.623309	37081
3707	3	28	41	896	2025-12-26 09:07:15.965929	179628
3708	4	29	22	1950	2026-05-17 13:53:28.208799	44629
3709	5	30	47	2891	2026-04-20 13:11:27.340431	53295
3710	1	31	59	2205	2026-02-11 01:29:56.237533	173999
3711	2	32	45	1320	2026-03-05 04:14:17.891188	124685
3712	3	33	52	390	2025-11-22 08:46:19.609993	135814
3713	4	34	13	780	2026-01-04 05:26:48.148232	32886
3714	5	35	63	2856	2026-04-28 13:20:27.50691	147700
3715	1	36	60	2948	2026-03-15 17:28:20.105983	11799
3716	2	37	43	2132	2026-04-24 06:18:50.34341	190438
3717	3	38	58	3498	2026-01-30 19:59:09.421848	102554
3718	4	39	41	1886	2026-01-02 08:46:34.553286	110479
3719	5	40	65	3186	2026-01-26 08:32:06.150404	20739
3720	1	1	33	2176	2025-12-24 00:29:24.417697	155976
3721	2	2	33	2400	2026-05-03 11:19:24.730135	153088
3722	3	3	50	360	2026-05-15 12:17:32.653057	14495
3723	4	4	13	3366	2026-01-22 16:00:19.771869	140677
3724	5	5	38	2968	2026-02-18 23:41:54.906063	167106
3725	1	6	64	1665	2025-12-17 11:15:45.239644	76238
3726	2	7	62	2552	2025-11-23 08:08:40.13937	17300
3727	3	8	52	2346	2026-02-27 17:37:08.57338	196706
3728	4	9	53	2115	2026-03-04 20:45:30.647746	105825
3729	5	10	13	3534	2026-01-25 16:43:09.993139	164775
3730	1	11	24	1755	2025-12-03 19:18:18.623624	84867
3731	2	12	22	1184	2026-04-30 14:44:30.133471	104210
3732	3	13	66	2989	2026-03-06 01:38:52.420358	54281
3733	4	14	49	1591	2026-01-31 00:30:32.103097	86585
3734	5	15	49	602	2026-03-16 09:04:24.497876	67410
3735	1	16	34	1406	2026-01-05 21:05:04.979583	76270
3736	2	17	35	1998	2026-05-05 15:47:30.613301	186818
3737	3	18	10	1352	2026-01-21 13:39:51.539105	124119
3738	4	19	13	2475	2025-11-30 06:23:39.360078	2087
3739	5	20	41	2065	2026-05-09 04:53:12.146028	135992
3740	1	21	23	1122	2026-03-01 19:21:45.374833	124999
3741	2	22	51	1014	2026-01-10 05:42:33.438568	92402
3742	3	23	60	1026	2026-05-20 23:26:44.598061	22206
3743	4	24	49	858	2026-02-06 22:56:05.868454	108538
3744	5	25	49	741	2026-03-20 14:41:22.850256	14708
3745	1	26	56	1125	2026-03-10 09:56:09.817028	51773
3746	2	27	14	1674	2025-12-02 06:23:21.102714	69745
3747	3	28	11	1012	2026-02-05 14:28:07.880867	141047
3748	4	29	39	1702	2026-05-16 02:53:31.905541	106688
3749	5	30	14	800	2026-03-23 14:32:40.848568	73531
3750	1	31	44	756	2026-03-24 01:44:36.74526	62282
3751	2	32	53	736	2026-05-10 22:07:56.256522	88556
3752	3	33	11	672	2026-05-02 10:00:13.949013	131469
3753	4	34	27	2068	2026-03-03 20:50:48.238553	198494
3754	5	35	30	1887	2026-03-30 01:50:41.004786	165646
3755	1	36	65	1710	2026-04-11 15:49:25.324027	83501
3756	2	37	39	2345	2025-12-23 22:19:00.178786	183140
3757	3	38	45	2214	2026-03-03 12:06:40.512469	81171
3758	4	39	25	680	2026-05-07 23:47:45.309676	167452
3759	5	40	48	3432	2025-11-27 18:57:30.925253	89927
3760	1	1	44	2666	2026-05-11 08:38:17.752686	180249
3761	2	2	26	1287	2025-12-01 06:12:02.891655	162862
3762	3	3	61	1776	2026-05-09 09:07:30.507071	179143
3763	4	4	33	1056	2026-01-22 12:27:33.063217	6803
3764	5	5	60	1710	2026-02-10 05:35:05.381286	11627
3765	1	6	56	1288	2026-04-14 05:02:42.805344	101439
3766	2	7	31	1295	2025-11-24 18:17:31.388279	150878
3767	3	8	19	2070	2025-12-16 06:06:55.898175	138357
3768	4	9	64	1638	2026-04-19 22:42:45.016318	12886
3769	5	10	11	992	2025-11-24 06:51:04.317075	44723
3770	1	11	34	594	2026-04-05 03:43:05.311626	65926
3771	2	12	52	1012	2026-05-17 00:48:22.825248	129559
3772	3	13	56	1521	2026-04-11 18:37:58.818054	93664
3773	4	14	42	1702	2026-04-12 03:29:07.012078	112493
3774	5	15	10	1470	2026-03-26 00:54:18.927799	155303
3775	1	16	63	629	2026-03-27 09:39:34.950257	133018
3776	2	17	64	2520	2026-05-16 17:44:47.814776	114507
3777	3	18	35	714	2026-03-14 04:51:07.371836	73312
3778	4	19	11	2392	2026-01-07 01:38:42.006959	26872
3779	5	20	47	1581	2026-03-05 09:25:21.200925	75693
3780	1	21	22	943	2026-01-01 17:07:31.261887	102489
3781	2	22	61	2296	2026-05-04 04:46:40.970708	132481
3782	3	23	40	1125	2025-12-18 13:19:01.479254	48318
3783	4	24	39	966	2026-04-26 21:38:16.202638	156740
3784	5	25	46	840	2026-04-27 05:09:37.70294	25626
3785	1	26	22	1440	2025-12-10 03:25:38.604027	165592
3786	2	27	58	2340	2026-02-25 04:22:13.661512	154141
3787	3	28	10	2601	2026-02-26 05:02:52.404295	178252
3788	4	29	61	2090	2025-12-02 03:08:11.292936	156436
3789	5	30	59	2120	2026-02-08 11:14:45.372125	139082
3790	1	31	14	2585	2026-01-28 13:59:07.215701	35867
3791	2	32	34	1032	2025-12-14 21:32:23.903608	163815
3792	3	33	47	703	2026-02-03 19:35:07.515288	163041
3793	4	34	37	1344	2026-01-08 12:59:52.069789	71405
3794	5	35	36	2640	2025-12-19 16:07:43.323608	52246
3795	1	36	22	1073	2025-12-29 00:17:05.661318	151370
3796	2	37	49	3111	2026-03-30 20:21:33.30759	17835
3797	3	38	20	2240	2026-03-08 21:43:03.665789	163789
3798	4	39	10	1440	2026-04-02 03:57:03.941127	81900
3799	5	40	33	3024	2026-02-20 09:13:00.43984	142847
3800	1	1	10	1845	2025-12-08 21:24:17.923074	40789
3801	2	2	44	2730	2026-01-27 09:54:11.957685	8541
3802	3	3	15	1888	2026-05-16 06:58:23.503473	18767
3803	4	4	37	2850	2025-12-17 03:19:40.726478	118615
3804	5	5	66	1836	2026-05-05 13:57:57.84285	100670
3805	1	6	69	2346	2026-04-08 23:57:14.373693	21143
3806	2	7	21	846	2026-01-02 08:21:52.087836	182483
3807	3	8	11	2378	2026-04-05 12:36:31.16589	121882
3808	4	9	35	407	2025-12-05 15:00:50.267848	68479
3809	5	10	43	1457	2026-03-07 03:50:39.902955	93256
3810	1	11	22	1080	2026-05-18 13:22:50.292519	174910
3811	2	12	30	1598	2026-05-20 02:10:27.648539	104812
3812	3	13	23	2318	2026-03-06 22:48:15.820589	17412
3813	4	14	31	1400	2026-03-30 19:09:07.137248	51712
3814	5	15	37	372	2026-05-20 17:17:04.775806	125222
3815	1	16	19	1740	2026-04-12 09:24:38.294999	186262
3816	2	17	44	1505	2026-02-15 22:49:05.265724	32548
3817	3	18	45	920	2026-04-27 07:21:27.991996	187284
3818	4	19	19	952	2026-03-04 09:27:59.559577	39530
3819	5	20	30	2499	2025-11-27 07:43:04.166903	111159
3820	1	21	24	1200	2026-01-05 16:06:54.721008	100218
3821	2	22	63	714	2026-02-08 16:52:49.378408	35964
3822	3	23	15	2400	2026-01-28 13:41:47.398622	15332
3823	4	24	48	1610	2026-04-27 01:23:10.248514	174952
3824	5	25	14	1428	2025-11-23 02:20:31.296525	159673
3825	1	26	17	1804	2026-03-17 11:07:55.936305	186816
3826	2	27	64	1504	2026-04-05 14:38:56.915788	57660
3827	3	28	32	1406	2026-04-17 10:48:55.887605	151362
3828	4	29	31	2318	2025-11-29 08:30:17.316501	46840
3829	5	30	34	943	2026-02-17 00:43:03.710428	37435
3830	1	31	59	1836	2026-02-04 01:07:35.069038	127905
3831	2	32	24	3417	2026-01-20 17:42:52.675973	125272
3832	3	33	60	2236	2026-01-23 00:38:36.466411	2008
3833	4	34	40	836	2025-11-24 09:17:58.702361	112411
3834	5	35	22	986	2025-12-17 15:05:45.33093	147060
3835	1	36	31	2496	2026-01-24 13:25:53.337627	107327
3836	2	37	39	1225	2025-12-16 14:18:50.635258	162458
3837	3	38	64	1652	2026-04-25 23:54:21.243041	150045
3838	4	39	13	680	2026-04-18 01:31:55.71904	24189
3839	5	40	30	2408	2026-04-10 19:37:48.211412	22258
3840	1	1	58	1643	2026-02-03 01:44:38.590845	171251
3841	2	2	30	1125	2025-12-09 14:36:36.706097	185308
3842	3	3	59	2360	2026-02-09 05:52:26.865194	163233
3843	4	4	54	2070	2026-02-26 23:09:58.731433	30662
3844	5	5	19	3186	2026-02-28 12:59:02.327348	75461
3845	1	6	37	2015	2025-12-14 09:45:25.372596	80967
3846	2	7	57	550	2026-03-05 12:24:20.60168	7467
3847	3	8	52	2728	2026-03-04 11:24:42.811319	2139
3848	4	9	30	1274	2026-04-28 14:53:40.631755	18724
3849	5	10	41	1922	2026-03-02 06:21:43.074347	146297
3850	1	11	66	2700	2026-02-11 19:07:01.335254	127895
3851	2	12	19	1728	2026-05-08 11:27:31.582919	84799
3852	3	13	35	2340	2025-11-24 08:40:57.77508	116089
3853	4	14	44	2346	2025-12-11 07:11:09.771606	45050
3854	5	15	30	1248	2026-03-02 20:30:01.509622	115205
3855	1	16	12	2546	2026-01-06 09:00:21.447745	127890
3856	2	17	30	779	2026-02-09 04:59:22.562835	139598
3857	3	18	20	1591	2026-02-28 19:31:36.370825	69732
3858	4	19	67	2346	2026-01-21 03:34:17.004436	198317
3859	5	20	47	546	2026-01-10 20:36:14.928594	169811
3860	1	21	28	1591	2026-02-09 23:34:41.449683	55233
3861	2	22	55	594	2026-02-12 00:33:53.863028	161486
3862	3	23	51	2438	2026-02-06 19:39:42.772757	114828
3863	4	24	27	754	2026-01-28 21:13:00.939242	7858
3864	5	25	24	2275	2025-12-07 19:00:14.797411	162186
3865	1	26	53	782	2026-02-19 08:11:31.732935	90643
3866	2	27	34	2016	2025-12-02 11:49:23.355234	131978
3867	3	28	56	924	2025-11-29 08:53:01.843114	129271
3868	4	29	42	1056	2026-05-06 12:23:32.353876	95307
3869	5	30	27	1250	2026-03-24 07:47:08.389366	23628
3870	1	31	55	1998	2025-12-27 05:18:16.008865	15190
3871	2	32	17	2610	2026-04-25 22:15:01.402231	6828
3872	3	33	29	3540	2026-02-13 22:20:24.436092	12335
3873	4	34	44	3944	2026-03-22 05:38:06.692983	111021
3874	5	35	48	1710	2026-01-28 10:36:04.709579	160165
3875	1	36	18	517	2026-04-27 12:23:49.482294	99716
3876	2	37	33	3120	2026-03-28 12:42:59.674075	138678
3877	3	38	28	1829	2026-02-04 10:09:58.770275	56287
3879	5	40	61	3060	2026-01-08 09:30:44.786125	173322
3880	1	1	55	3234	2025-12-08 07:27:00.920846	33319
3881	2	2	54	3510	2026-02-12 00:12:28.031343	91454
3882	3	3	63	3381	2025-12-27 17:59:14.452695	88156
3883	4	4	43	3016	2025-12-25 13:38:21.306708	48166
3884	5	5	10	1271	2026-04-09 04:53:03.641943	162640
3885	1	6	30	3294	2025-12-19 21:57:39.177304	31005
3886	2	7	25	510	2026-05-20 10:48:03.424406	127386
3887	3	8	67	2108	2026-02-18 09:23:31.93049	18091
3888	4	9	10	651	2026-02-09 06:59:41.619984	56248
3889	5	10	15	1026	2025-11-23 00:32:56.711272	142847
3890	1	11	30	624	2026-01-27 08:53:27.18763	66022
3891	2	12	45	726	2025-11-24 05:34:25.171289	181155
3892	3	13	37	1947	2026-01-04 02:15:45.203135	38077
3893	4	14	14	1624	2026-03-21 20:25:42.923816	82224
3894	5	15	59	1728	2025-11-28 20:39:44.497967	139022
3895	1	16	66	2132	2026-02-02 04:35:22.302497	92048
3896	2	17	58	850	2026-03-16 16:09:51.000683	102484
3897	3	18	29	1352	2026-05-04 22:36:55.606136	197417
3898	4	19	65	3068	2026-02-04 21:35:43.531791	177959
3899	5	20	24	2695	2025-12-25 18:32:38.557426	170389
3900	1	21	46	2160	2025-11-22 23:21:04.160925	109269
3901	2	22	32	2337	2026-02-04 15:10:47.700499	101207
3902	3	23	45	3245	2026-03-17 10:07:58.94395	47051
3903	4	24	15	990	2026-04-09 08:59:57.621605	89916
3904	5	25	14	750	2026-02-16 09:19:09.710345	159917
3905	1	26	64	2065	2025-12-16 23:45:52.494085	24979
3906	2	27	65	1128	2026-02-17 08:38:31.450531	24987
3907	3	28	10	1548	2026-04-28 11:08:49.6739	188565
3908	4	29	34	1435	2025-12-10 08:56:58.62469	149827
3909	5	30	23	1100	2026-04-07 09:45:16.341245	169862
3910	1	31	27	2184	2026-05-04 23:10:49.325819	70781
3911	2	32	35	675	2026-01-28 05:49:54.516717	17443
3912	3	33	62	1558	2026-02-10 06:15:45.676569	109522
3913	4	34	15	2160	2026-03-30 22:00:02.457466	138865
3914	5	35	41	1360	2026-02-13 03:23:45.574784	190502
3915	1	36	23	1275	2026-05-15 01:34:08.037415	128891
3916	2	37	43	3190	2025-12-16 10:21:50.687004	16812
3917	3	38	24	1824	2025-11-23 12:46:04.822588	164504
3918	4	39	22	920	2026-03-17 03:24:32.738982	5362
3919	5	40	10	3264	2026-01-13 05:43:49.393405	62155
3920	1	1	51	2256	2025-12-04 21:11:59.24031	159109
3921	2	2	49	2160	2026-04-10 20:05:59.080291	155362
3922	3	3	66	2242	2026-02-11 12:04:26.918967	162052
3923	4	4	42	2750	2026-05-14 21:51:12.960164	119124
3924	5	5	22	2332	2026-01-30 15:10:59.188849	198027
3925	1	6	58	2400	2026-02-11 11:19:32.248888	9652
3926	2	7	52	980	2025-12-11 15:25:42.207516	151183
3927	3	8	24	682	2026-04-13 08:00:49.182131	98656
3928	4	9	54	1638	2026-04-11 02:11:44.941449	183118
3929	5	10	61	1802	2026-04-28 09:15:40.001645	11986
3930	1	11	31	2496	2026-04-29 14:57:06.179608	13096
3931	2	12	32	1144	2026-01-14 07:04:50.903211	195866
3932	3	13	59	1316	2026-02-01 22:05:55.244794	69066
3933	4	14	64	1504	2026-04-02 17:54:57.673586	135146
3934	5	15	13	1776	2025-12-11 04:49:37.242933	97991
3935	1	16	65	800	2026-04-25 17:16:29.546327	62154
3936	2	17	31	1400	2026-02-25 12:24:47.521586	197814
3937	3	18	48	1015	2026-04-24 00:51:51.266861	65804
3938	4	19	56	697	2026-05-20 08:41:34.345329	33477
3939	5	20	48	1886	2026-04-20 09:40:16.47029	180603
3940	1	21	11	1920	2026-02-28 17:21:47.270265	154699
3941	2	22	33	589	2025-12-22 20:00:13.546859	188312
3942	3	23	30	988	2026-03-12 07:01:40.928187	115982
3943	4	24	10	1767	2026-02-14 06:21:15.943362	49719
3944	5	25	23	2560	2026-05-14 15:19:37.847305	150841
3945	1	26	53	2352	2026-02-15 02:37:23.78167	63181
3946	2	27	27	1296	2026-03-18 16:18:44.731252	174786
3947	3	28	51	1462	2025-12-19 03:08:25.797312	88474
3948	4	29	58	672	2026-01-15 02:09:41.421817	26149
3949	5	30	19	3795	2026-04-19 13:15:43.886365	161760
3950	1	31	10	1300	2026-02-25 08:34:13.290344	76587
3951	2	32	66	583	2026-01-10 23:01:32.051796	119918
3952	3	33	28	1239	2026-01-12 01:36:16.561566	16815
3953	4	34	58	2006	2026-01-27 22:01:02.955644	66989
3954	5	35	51	630	2026-02-06 17:30:49.852853	17671
3955	1	36	23	1008	2026-04-03 01:02:50.866184	50197
3956	2	37	43	560	2026-03-09 01:51:20.487407	199434
3957	3	38	23	624	2026-04-07 10:00:10.402919	135349
3958	4	39	51	1664	2025-12-02 12:49:36.183301	191861
3959	5	40	58	1628	2025-12-21 02:59:13.60376	7378
3960	1	1	42	1219	2026-02-21 19:32:33.028581	144817
3961	2	2	62	1947	2025-11-26 12:17:22.240533	177939
3962	3	3	61	1548	2025-11-25 10:19:30.589091	115556
3963	4	4	19	2400	2026-03-12 17:09:01.955549	10033
3964	5	5	10	1008	2026-01-15 08:28:38.184233	135291
3965	1	6	69	1012	2025-12-09 23:18:27.207475	5404
3966	2	7	19	2067	2026-02-26 07:51:57.433953	58267
3967	3	8	17	1166	2025-12-24 17:45:04.572116	131977
3968	4	9	64	1012	2025-12-26 09:50:21.300847	139379
3969	5	10	35	1008	2026-01-30 22:03:07.144223	149611
3970	1	11	29	1480	2026-03-28 16:16:48.881059	14315
3971	2	12	40	1645	2025-12-16 11:24:59.906162	162934
3972	3	13	27	1054	2026-03-27 17:38:13.995629	65264
3973	4	14	52	1107	2026-02-06 09:46:07.897061	177625
3974	5	15	24	616	2025-11-28 15:34:53.613894	50336
3975	1	16	29	1050	2026-03-22 23:00:16.814875	116464
3976	2	17	24	805	2025-12-28 00:06:17.688406	49427
3977	3	18	12	1230	2026-03-11 08:34:31.287456	198759
3978	4	19	38	4071	2026-05-07 20:41:33.009337	55532
3979	5	20	38	1426	2025-11-29 18:33:27.503184	116782
3980	1	21	38	2747	2026-04-05 13:54:31.655223	62352
3981	2	22	57	2784	2025-12-30 15:39:57.000665	84283
3982	3	23	31	620	2026-04-10 12:27:18.927929	147491
3983	4	24	38	2166	2026-01-03 19:49:17.599013	56763
3984	5	25	24	1176	2026-03-13 01:01:33.34512	54632
3985	1	26	10	1566	2026-03-31 03:06:38.111646	169981
3986	2	27	55	3481	2025-12-15 13:01:45.416596	4772
3987	3	28	54	396	2026-02-16 05:59:25.097819	113576
3988	4	29	36	960	2026-03-19 03:52:35.599457	167385
3989	5	30	60	2392	2026-03-16 13:35:35.436933	17043
3990	1	31	29	1365	2026-03-29 06:27:03.405718	22539
3991	2	32	15	900	2026-04-28 00:54:33.882658	1675
3992	3	33	58	1935	2026-02-25 10:58:30.470974	194891
3993	4	34	59	2142	2025-12-24 19:19:13.529234	171878
3994	5	35	11	1551	2026-03-23 20:11:48.159867	73106
3995	1	36	42	1749	2026-01-22 15:50:59.265153	157000
3996	2	37	68	2380	2026-04-20 21:14:46.199106	95785
3997	3	38	13	731	2025-12-10 13:22:51.42593	155059
3998	4	39	20	442	2026-05-07 12:08:41.64367	68582
3999	5	40	17	2204	2026-04-14 12:28:53.424281	145801
4000	1	1	44	3009	2026-05-01 09:35:02.633726	38694
4001	1	23	45	2250	2026-05-21 07:23:04.138503	209085
4002	2	23	999	99999	2026-05-21 07:29:35.275432	111336
4003	1	1	30	1500	2026-05-27 04:45:26.796366	155912
4004	1	2	10	500	2026-05-27 04:52:05.509439	0
4005	1	3	15	700	2026-05-27 04:53:58.915281	74905
4009	1	1	10	100	2026-05-27 05:05:21.418496	155812
\.


--
-- TOC entry 5192 (class 0 OID 18331)
-- Dependencies: 248
-- Data for Name: prodazha_audit; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.prodazha_audit (id, id_prodazhi, kod_topliva, id_karty, summa_do_izmeneniya, summa_posle_izmeneniya, tip_operatsii, audit_time) FROM stdin;
1	4009	1	1	0	100	INSERT	2026-05-27 05:05:21.418496
\.


--
-- TOC entry 5172 (class 0 OID 17529)
-- Dependencies: 223
-- Data for Name: tip_topliva; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.tip_topliva (id_tipa_topliva, naimenovanie_tipa) FROM stdin;
1	Бензин
2	Дизельное топливо
3	Газ
4	Электричество
\.


--
-- TOC entry 5180 (class 0 OID 17591)
-- Dependencies: 231
-- Data for Name: tip_zapravki; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.tip_zapravki (id_tipa_zapravki, naimenovanie_tipa, opisanie) FROM stdin;
1	АЗС	Автомобильная заправочная станция
2	АГЗС	Газовая заправка
3	Электрозаправка	Станция зарядки электромобилей
\.


--
-- TOC entry 5178 (class 0 OID 17569)
-- Dependencies: 229
-- Data for Name: tsena_topliva; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.tsena_topliva (id_tseny, id_postavshchika, tsena_za_edinitsu, data_nachala, kod_topliva, data_okonchaniya) FROM stdin;
1	1	55	2024-01-01	1	\N
2	1	60	2024-01-01	2	\N
3	2	58	2024-01-01	3	\N
4	2	32	2024-01-01	4	\N
5	3	15	2024-01-01	5	\N
6	1	55	2024-01-01	1	\N
7	1	60	2024-01-01	2	\N
8	2	58	2024-01-01	3	\N
9	2	32	2024-01-01	4	\N
10	3	15	2024-01-01	5	\N
\.


--
-- TOC entry 5182 (class 0 OID 17600)
-- Dependencies: 233
-- Data for Name: zaprava; Type: TABLE DATA; Schema: azs; Owner: postgres
--

COPY azs.zaprava (kod_zapravki, id_postavshchika, rezhim_raboty, adres_zapravki, id_tipa_zapravki, kolichestvo_kolonok) FROM stdin;
1	1	24/7	Москва, МКАД 10 км	1	8
2	2	06:00-23:00	СПб, Лиговский пр., 50	1	6
3	3	24/7	Екатеринбург, ул. Победы, 15	2	4
\.


--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 245
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.audit_log_id_seq', 2, true);


--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 224
-- Name: edinitsa_izmereniya_id_edinitsy_izmereniya_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.edinitsa_izmereniya_id_edinitsy_izmereniya_seq', 2, true);


--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 236
-- Name: karta_schet_id_karty_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.karta_schet_id_karty_seq', 42, true);


--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 234
-- Name: klient_id_klienta_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.klient_id_klienta_seq', 42, true);


--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 220
-- Name: postavshchik_id_postavshchika_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.postavshchik_id_postavshchika_seq', 3, true);


--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 226
-- Name: prodavaemoe_toplivo_kod_topliva_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.prodavaemoe_toplivo_kod_topliva_seq', 5, true);


--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 247
-- Name: prodazha_audit_id_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.prodazha_audit_id_seq', 1, true);


--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 238
-- Name: prodazha_id_prodazhi_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.prodazha_id_prodazhi_seq', 4009, true);


--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 222
-- Name: tip_topliva_id_tipa_topliva_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.tip_topliva_id_tipa_topliva_seq', 4, true);


--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 230
-- Name: tip_zapravki_id_tipa_zapravki_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.tip_zapravki_id_tipa_zapravki_seq', 3, true);


--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 228
-- Name: tsena_topliva_id_tseny_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.tsena_topliva_id_tseny_seq', 10, true);


--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 232
-- Name: zaprava_kod_zapravki_seq; Type: SEQUENCE SET; Schema: azs; Owner: postgres
--

SELECT pg_catalog.setval('azs.zaprava_kod_zapravki_seq', 3, true);


--
-- TOC entry 4998 (class 2606 OID 18317)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4978 (class 2606 OID 17546)
-- Name: edinitsa_izmereniya edinitsa_izmereniya_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.edinitsa_izmereniya
    ADD CONSTRAINT edinitsa_izmereniya_pkey PRIMARY KEY (id_edinitsy_izmereniya);


--
-- TOC entry 4992 (class 2606 OID 17638)
-- Name: karta_schet karta_schet_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.karta_schet
    ADD CONSTRAINT karta_schet_pkey PRIMARY KEY (id_karty);


--
-- TOC entry 4990 (class 2606 OID 17627)
-- Name: klient klient_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.klient
    ADD CONSTRAINT klient_pkey PRIMARY KEY (id_klienta);


--
-- TOC entry 4970 (class 2606 OID 17527)
-- Name: postavshchik postavshchik_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.postavshchik
    ADD CONSTRAINT postavshchik_pkey PRIMARY KEY (id_postavshchika);


--
-- TOC entry 4982 (class 2606 OID 17557)
-- Name: prodavaemoe_toplivo prodavaemoe_toplivo_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodavaemoe_toplivo
    ADD CONSTRAINT prodavaemoe_toplivo_pkey PRIMARY KEY (kod_topliva);


--
-- TOC entry 5000 (class 2606 OID 18338)
-- Name: prodazha_audit prodazha_audit_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodazha_audit
    ADD CONSTRAINT prodazha_audit_pkey PRIMARY KEY (id);


--
-- TOC entry 4996 (class 2606 OID 17656)
-- Name: prodazha prodazha_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodazha
    ADD CONSTRAINT prodazha_pkey PRIMARY KEY (id_prodazhi);


--
-- TOC entry 4974 (class 2606 OID 17536)
-- Name: tip_topliva tip_topliva_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tip_topliva
    ADD CONSTRAINT tip_topliva_pkey PRIMARY KEY (id_tipa_topliva);


--
-- TOC entry 4986 (class 2606 OID 17598)
-- Name: tip_zapravki tip_zapravki_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tip_zapravki
    ADD CONSTRAINT tip_zapravki_pkey PRIMARY KEY (id_tipa_zapravki);


--
-- TOC entry 4984 (class 2606 OID 17579)
-- Name: tsena_topliva tsena_topliva_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tsena_topliva
    ADD CONSTRAINT tsena_topliva_pkey PRIMARY KEY (id_tseny);


--
-- TOC entry 4972 (class 2606 OID 17683)
-- Name: postavshchik uk_inn; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.postavshchik
    ADD CONSTRAINT uk_inn UNIQUE (inn);


--
-- TOC entry 4976 (class 2606 OID 17685)
-- Name: tip_topliva uk_naimenovanie_tipa; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tip_topliva
    ADD CONSTRAINT uk_naimenovanie_tipa UNIQUE (naimenovanie_tipa);


--
-- TOC entry 4994 (class 2606 OID 17681)
-- Name: karta_schet uk_nomer_karty; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.karta_schet
    ADD CONSTRAINT uk_nomer_karty UNIQUE (nomer_karty);


--
-- TOC entry 4980 (class 2606 OID 17687)
-- Name: edinitsa_izmereniya uk_oboznachenie; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.edinitsa_izmereniya
    ADD CONSTRAINT uk_oboznachenie UNIQUE (oboznachenie);


--
-- TOC entry 4988 (class 2606 OID 17608)
-- Name: zaprava zaprava_pkey; Type: CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.zaprava
    ADD CONSTRAINT zaprava_pkey PRIMARY KEY (kod_zapravki);


--
-- TOC entry 5013 (class 2620 OID 18340)
-- Name: prodazha trg_audit_prodazha; Type: TRIGGER; Schema: azs; Owner: postgres
--

CREATE TRIGGER trg_audit_prodazha AFTER INSERT OR DELETE OR UPDATE ON azs.prodazha FOR EACH ROW EXECUTE FUNCTION azs.fn_audit_prodazha();


--
-- TOC entry 5010 (class 2620 OID 18319)
-- Name: klient trg_check_klient_delete; Type: TRIGGER; Schema: azs; Owner: postgres
--

CREATE TRIGGER trg_check_klient_delete BEFORE DELETE ON azs.klient FOR EACH ROW EXECUTE FUNCTION azs.fn_check_klient_delete();


--
-- TOC entry 5014 (class 2620 OID 18327)
-- Name: prodazha trg_check_kolichestvo_topliva; Type: TRIGGER; Schema: azs; Owner: postgres
--

CREATE TRIGGER trg_check_kolichestvo_topliva BEFORE INSERT OR UPDATE ON azs.prodazha FOR EACH ROW EXECUTE FUNCTION azs.fn_check_kolichestvo_topliva();


--
-- TOC entry 5015 (class 2620 OID 18323)
-- Name: prodazha trg_check_prodazha_summa; Type: TRIGGER; Schema: azs; Owner: postgres
--

CREATE TRIGGER trg_check_prodazha_summa BEFORE INSERT ON azs.prodazha FOR EACH ROW EXECUTE FUNCTION azs.fn_check_prodazha_summa();


--
-- TOC entry 5011 (class 2620 OID 18325)
-- Name: klient trg_log_klient_changes; Type: TRIGGER; Schema: azs; Owner: postgres
--

CREATE TRIGGER trg_log_klient_changes AFTER INSERT OR DELETE OR UPDATE ON azs.klient FOR EACH ROW EXECUTE FUNCTION azs.fn_log_klient_changes();


--
-- TOC entry 5012 (class 2620 OID 18329)
-- Name: karta_schet trg_set_karta_expiry; Type: TRIGGER; Schema: azs; Owner: postgres
--

CREATE TRIGGER trg_set_karta_expiry BEFORE INSERT ON azs.karta_schet FOR EACH ROW EXECUTE FUNCTION azs.fn_set_karta_expiry();


--
-- TOC entry 5016 (class 2620 OID 18321)
-- Name: prodazha trg_update_balance_after_prodazha; Type: TRIGGER; Schema: azs; Owner: postgres
--

CREATE TRIGGER trg_update_balance_after_prodazha AFTER INSERT ON azs.prodazha FOR EACH ROW EXECUTE FUNCTION azs.fn_update_balance_after_prodazha();


--
-- TOC entry 5007 (class 2606 OID 17639)
-- Name: karta_schet fk_karta_klient; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.karta_schet
    ADD CONSTRAINT fk_karta_klient FOREIGN KEY (id_klienta) REFERENCES azs.klient(id_klienta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5008 (class 2606 OID 17662)
-- Name: prodazha fk_prodazha_karta; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodazha
    ADD CONSTRAINT fk_prodazha_karta FOREIGN KEY (id_karty) REFERENCES azs.karta_schet(id_karty) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5009 (class 2606 OID 17657)
-- Name: prodazha fk_prodazha_toplivo; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodazha
    ADD CONSTRAINT fk_prodazha_toplivo FOREIGN KEY (kod_topliva) REFERENCES azs.prodavaemoe_toplivo(kod_topliva) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5001 (class 2606 OID 17563)
-- Name: prodavaemoe_toplivo fk_toplivo_edinitsa; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodavaemoe_toplivo
    ADD CONSTRAINT fk_toplivo_edinitsa FOREIGN KEY (id_edinitsy_izmereniya) REFERENCES azs.edinitsa_izmereniya(id_edinitsy_izmereniya) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5002 (class 2606 OID 17558)
-- Name: prodavaemoe_toplivo fk_toplivo_tip; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.prodavaemoe_toplivo
    ADD CONSTRAINT fk_toplivo_tip FOREIGN KEY (id_tipa_topliva) REFERENCES azs.tip_topliva(id_tipa_topliva) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5003 (class 2606 OID 17580)
-- Name: tsena_topliva fk_tsena_postavshchik; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tsena_topliva
    ADD CONSTRAINT fk_tsena_postavshchik FOREIGN KEY (id_postavshchika) REFERENCES azs.postavshchik(id_postavshchika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5004 (class 2606 OID 17585)
-- Name: tsena_topliva fk_tsena_toplivo; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.tsena_topliva
    ADD CONSTRAINT fk_tsena_toplivo FOREIGN KEY (kod_topliva) REFERENCES azs.prodavaemoe_toplivo(kod_topliva) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5005 (class 2606 OID 17609)
-- Name: zaprava fk_zaprava_postavshchik; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.zaprava
    ADD CONSTRAINT fk_zaprava_postavshchik FOREIGN KEY (id_postavshchika) REFERENCES azs.postavshchik(id_postavshchika) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5006 (class 2606 OID 17614)
-- Name: zaprava fk_zaprava_tip; Type: FK CONSTRAINT; Schema: azs; Owner: postgres
--

ALTER TABLE ONLY azs.zaprava
    ADD CONSTRAINT fk_zaprava_tip FOREIGN KEY (id_tipa_zapravki) REFERENCES azs.tip_zapravki(id_tipa_zapravki) ON UPDATE CASCADE ON DELETE RESTRICT;


-- Completed on 2026-05-27 06:40:04

--
-- PostgreSQL database dump complete
--

\unrestrict aiLehgkrFVyAqzbVJi1qcG7wPgGEmxJhcdJvwxVsa8MnC2mZXdtA8M2e3vWXsEe

