--
-- PostgreSQL database dump
--

\restrict QvhkoISEhAUFe0WvKhOKPLByo8vJO3p0f2M6B2NYcIpQXbzvXPFBIZjYTm03ysC

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

-- Started on 2026-05-08 14:14:50

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

DROP DATABASE "lab3 database";
--
-- TOC entry 5021 (class 1262 OID 16394)
-- Name: lab3 database; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE "lab3 database" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1251';


\unrestrict QvhkoISEhAUFe0WvKhOKPLByo8vJO3p0f2M6B2NYcIpQXbzvXPFBIZjYTm03ysC
\encoding SQL_ASCII
\connect -reuse-previous=on "dbname='lab3 database'"
\restrict QvhkoISEhAUFe0WvKhOKPLByo8vJO3p0f2M6B2NYcIpQXbzvXPFBIZjYTm03ysC

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
-- TOC entry 6 (class 2615 OID 24925)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 2 (class 3079 OID 24926)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 25010)
-- Name: availability_slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.availability_slots (
    slot_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    profile_id uuid NOT NULL,
    start_datetime timestamp without time zone NOT NULL,
    end_datetime timestamp without time zone NOT NULL,
    status character varying(20) NOT NULL,
    CONSTRAINT chk_slot_dates CHECK ((end_datetime > start_datetime)),
    CONSTRAINT chk_slot_status CHECK (((status)::text = ANY ((ARRAY['свободен'::character varying, 'забронирован'::character varying, 'недоступен'::character varying])::text[])))
);


--
-- TOC entry 218 (class 1259 OID 24971)
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    category_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(50) NOT NULL,
    CONSTRAINT chk_category_name_len CHECK ((length((name)::text) <= 50))
);


--
-- TOC entry 226 (class 1259 OID 25093)
-- Name: course_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_reviews (
    review_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    purchased_course_id uuid NOT NULL,
    rating integer NOT NULL,
    comment text,
    created_date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT chk_crs_review_date CHECK ((created_date <= CURRENT_DATE)),
    CONSTRAINT chk_crs_review_rating CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- TOC entry 224 (class 1259 OID 25057)
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    course_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    profile_id uuid NOT NULL,
    title character varying(100) NOT NULL,
    description text NOT NULL,
    price numeric(10,2) NOT NULL,
    created_date date DEFAULT CURRENT_DATE NOT NULL,
    updated_date date,
    status character varying(20),
    CONSTRAINT chk_course_created_date CHECK ((created_date <= CURRENT_DATE)),
    CONSTRAINT chk_course_price CHECK ((price >= (0)::numeric)),
    CONSTRAINT chk_course_updated_date CHECK ((updated_date >= created_date))
);


--
-- TOC entry 225 (class 1259 OID 25074)
-- Name: purchased_courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchased_courses (
    purchased_course_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    course_id uuid NOT NULL,
    purchase_date date DEFAULT CURRENT_DATE NOT NULL,
    access_expires date,
    status character varying(20) NOT NULL,
    CONSTRAINT chk_access_expires CHECK ((access_expires >= purchase_date)),
    CONSTRAINT chk_purchased_date CHECK ((purchase_date <= CURRENT_DATE))
);


--
-- TOC entry 222 (class 1259 OID 25023)
-- Name: service_bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_bookings (
    booking_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    service_id uuid NOT NULL,
    user_id uuid NOT NULL,
    scheduled_start timestamp without time zone NOT NULL,
    scheduled_end timestamp without time zone NOT NULL,
    status character varying(20) NOT NULL,
    CONSTRAINT chk_booking_dates CHECK ((scheduled_end > scheduled_start)),
    CONSTRAINT chk_booking_status CHECK (((status)::text = ANY ((ARRAY['создано'::character varying, 'подтверждено'::character varying, 'отменено'::character varying, 'завершено'::character varying])::text[])))
);


--
-- TOC entry 223 (class 1259 OID 25041)
-- Name: service_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_reviews (
    review_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    booking_id uuid NOT NULL,
    rating integer NOT NULL,
    comment text,
    created_date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT chk_srv_review_date CHECK ((created_date <= CURRENT_DATE)),
    CONSTRAINT chk_srv_review_rating CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- TOC entry 220 (class 1259 OID 24995)
-- Name: services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.services (
    service_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    profile_id uuid NOT NULL,
    title character varying(100) NOT NULL,
    description text NOT NULL,
    duration integer NOT NULL,
    price numeric(10,2) NOT NULL,
    CONSTRAINT chk_service_duration CHECK ((duration > 0)),
    CONSTRAINT chk_service_price CHECK ((price > (0)::numeric))
);


--
-- TOC entry 219 (class 1259 OID 24978)
-- Name: specialist_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specialist_categories (
    profile_id uuid NOT NULL,
    category_id uuid NOT NULL,
    specification text
);


--
-- TOC entry 217 (class 1259 OID 24955)
-- Name: specialist_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specialist_profiles (
    profile_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    bio text NOT NULL,
    experience_years integer NOT NULL,
    created_date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20),
    CONSTRAINT chk_experience_years CHECK (((experience_years >= 0) AND (experience_years < 100))),
    CONSTRAINT chk_profile_created_date CHECK ((created_date <= CURRENT_DATE))
);


--
-- TOC entry 216 (class 1259 OID 24937)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(254) NOT NULL,
    login character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    name character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    phone_number character varying(15),
    registration_date date DEFAULT CURRENT_DATE NOT NULL,
    role character varying(20),
    CONSTRAINT chk_users_email_format CHECK (((email)::text ~* '^[A-Za-z0-9._+%\-]+@[A-Za-z0-9.\-]+[.][A-Za-z]+$'::text)),
    CONSTRAINT chk_users_name_cyrillic CHECK (((name)::text ~ '^[А-Яа-яЁё\s\-]+$'::text)),
    CONSTRAINT chk_users_password_len CHECK ((length((password)::text) > 5)),
    CONSTRAINT chk_users_reg_date CHECK ((registration_date <= CURRENT_DATE)),
    CONSTRAINT chk_users_surname_cyrillic CHECK (((surname)::text ~ '^[А-Яа-яЁё\s\-]+$'::text))
);


--
-- TOC entry 5010 (class 0 OID 25010)
-- Dependencies: 221
-- Data for Name: availability_slots; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.availability_slots VALUES ('163e8c08-6d09-4d5a-8c82-df4b6d9ef207', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-03-23 12:00:00', '2026-03-23 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('faa82b1d-1d55-4845-997e-0ee1c60e575b', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-06-11 12:00:00', '2026-06-11 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('76c077cf-dfd1-4970-a76f-6b6541719050', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-05-22 17:00:00', '2026-05-22 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('e2f08237-9113-4ce7-b95b-5c4ab639fd79', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-06-10 14:00:00', '2026-06-10 15:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('42828800-c8bf-4d6e-8388-36599f1a2863', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-03-10 16:00:00', '2026-03-10 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('183d5fa7-bd40-4ecc-94fe-1f3af77ab5ed', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-06-23 12:00:00', '2026-06-23 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('0075b417-3cc8-4c81-b65a-b67705b7775b', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-05-05 10:00:00', '2026-05-05 11:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('9f0a41a4-10b7-442a-908c-a2b3691483f4', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-02-19 18:00:00', '2026-02-19 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('6d5de135-758a-4a1b-8521-0ce5c10743ad', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-05-28 11:00:00', '2026-05-28 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('fdbc1439-24a3-4b23-859b-d56b8a0fecdf', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-06-16 16:00:00', '2026-06-16 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('61b7d8d0-d437-445f-adb5-37361a8b008a', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-04-08 18:00:00', '2026-04-08 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('50e96e61-4f48-4d24-b17b-e4392c202ff2', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-04-11 14:00:00', '2026-04-11 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('f35a7d80-303b-49e8-bdc1-25a68446ab43', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-07-05 14:00:00', '2026-07-05 15:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('44d49c21-b9c6-4039-aabf-33889deadc5b', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-04-28 11:00:00', '2026-04-28 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('a8bd69aa-dcf2-4ae5-ac40-ba08be196d2e', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-06-14 13:00:00', '2026-06-14 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('5f6d558a-b6f2-4052-bc20-0f101e6b86a7', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2026-03-03 13:00:00', '2026-03-03 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('e3f600a8-18c9-43f0-b2fa-715a57836420', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-06-21 15:00:00', '2026-06-21 16:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('3f74289f-4f6c-47b3-bad4-d93cf3f5c63b', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-05-21 13:00:00', '2026-05-21 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('8a46a18d-2ac1-4da0-991e-875276c99f3e', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-05-26 17:00:00', '2026-05-26 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('71b4e88e-6872-4aed-802d-cd95567b7840', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-05-18 11:00:00', '2026-05-18 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('61f9e110-731d-47bf-8710-38715907cc6c', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-06-23 13:00:00', '2026-06-23 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('32612f58-ca62-4254-9ba4-e86fc47deab5', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-03-17 13:00:00', '2026-03-17 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2d9faa47-51bd-4b06-b3e3-6755ad486618', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-05-21 13:00:00', '2026-05-21 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('3d261049-7e1f-46a5-ab6b-2b2f1d19849d', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-03-27 15:00:00', '2026-03-27 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('73d9593a-39bb-459c-b4f8-6a1a338d663c', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-04-04 18:00:00', '2026-04-04 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('07af336f-046e-4515-ae53-9d61aef31191', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-06-20 16:00:00', '2026-06-20 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('320390a5-2af4-4dd6-a1ce-f8e5135cb287', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-02-19 17:00:00', '2026-02-19 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('df65d9c4-cbc9-4a9f-a3d4-d6157f6fd4d3', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-03-19 15:00:00', '2026-03-19 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('563081d0-92e6-4310-8e06-5d43ac40461d', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-05-27 09:00:00', '2026-05-27 10:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('bec30f22-fce6-497f-b639-59846e813a1d', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-07-06 15:00:00', '2026-07-06 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('fbdcef20-5b18-4daf-afed-17c1a85e7536', '2b122c6b-e3d8-4b39-b165-aa8b61834322', '2026-04-27 16:00:00', '2026-04-27 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('efb35fc5-5015-45df-8695-b59b03b93469', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-06-28 16:00:00', '2026-06-28 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('1114be61-2147-4571-bd27-8b71e59cc094', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-05-16 13:00:00', '2026-05-16 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('36440b85-9d1f-4272-9756-8fe19c14185c', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-06-13 15:00:00', '2026-06-13 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('b5cf6cf3-1e1b-436d-b923-b0a86626007b', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-05-15 14:00:00', '2026-05-15 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('2ef0c9cb-d516-45b4-970a-942daaaae092', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-02-14 18:00:00', '2026-02-14 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('30f689f5-5c0d-4167-b5b6-79dff8cff6ab', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-03-20 09:00:00', '2026-03-20 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('d599802a-a353-4413-8c88-0cf29c85924d', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-07-03 14:00:00', '2026-07-03 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('248758c6-e15b-4f89-8a13-f91c8b7fa716', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-04-29 11:00:00', '2026-04-29 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('6c221a57-3277-4999-8c70-bc0cf030bfef', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-02-25 15:00:00', '2026-02-25 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('5b81020a-6729-411f-8ed3-191ba9569349', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-03-25 15:00:00', '2026-03-25 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('7d05fdbd-2cec-4a27-885a-57fee63f35fa', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-04-26 09:00:00', '2026-04-26 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('10b2c24d-be6b-4e36-8ad8-d71d09ebce2f', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-02-21 17:00:00', '2026-02-21 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('fffeef2c-7013-484a-a0fc-6dfe4301b378', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', '2026-06-18 13:00:00', '2026-06-18 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('36d2ab46-8aaa-4709-af68-f293a14a77d6', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-06-29 09:00:00', '2026-06-29 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('02a3e468-1593-4b3a-9ffa-4ef4ffc4ed6a', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-02-18 09:00:00', '2026-02-18 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('bfcf0c50-0bd5-4b2f-92ad-218f30585766', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-03-23 14:00:00', '2026-03-23 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('36f29ad8-bf10-4033-bba2-109425fa3a93', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-03-28 10:00:00', '2026-03-28 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('4f32d1c5-b9c3-4895-8ad9-e56ad5d4ecf9', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-05-26 13:00:00', '2026-05-26 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('f14bea7a-d89a-4860-8567-3dd6b7b60b6d', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-07-05 15:00:00', '2026-07-05 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('4fb52b59-15da-4cbd-b45b-66ac35cfb178', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-04-15 14:00:00', '2026-04-15 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('53d2a603-9c57-4192-a02c-4ab9fb528dcc', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-04-21 09:00:00', '2026-04-21 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('04c58932-e0e2-4cc8-9306-5a9b0d7b048d', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-02-18 12:00:00', '2026-02-18 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('855d6c20-0e69-4493-b85b-7fd85aed2863', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-07-02 10:00:00', '2026-07-02 11:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('ee41d220-eab8-4c57-bd10-8a87a08ab519', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-05-24 13:00:00', '2026-05-24 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('831f5f3d-18bd-4163-852e-fa259ab3c945', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '2026-05-24 10:00:00', '2026-05-24 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('f9674236-40b4-4ddb-b0ba-6364fc41670b', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-02-19 17:00:00', '2026-02-19 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('3f68b50f-6b9b-48be-bcc0-2e895c858848', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-03-23 10:00:00', '2026-03-23 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('02aa93e8-4143-4911-9ddd-b09df30ef4d1', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-03-23 14:00:00', '2026-03-23 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('cde8c29a-65d4-4202-87ca-cd7614f02252', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-02-11 16:00:00', '2026-02-11 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('ad74ba97-eeb5-45f7-ba4f-592df2cc893b', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-04-10 13:00:00', '2026-04-10 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('c34321dc-0d6b-4216-9421-db922c55256f', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-02-19 18:00:00', '2026-02-19 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('5c8cbaa8-9c38-4433-8525-06dc1c729a25', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-03-14 16:00:00', '2026-03-14 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('494f042d-63b9-43c2-9073-de7cb110bdfc', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-05-12 17:00:00', '2026-05-12 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('6c0c8818-3fad-4173-976c-d4e0cbbe2d98', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-04-14 14:00:00', '2026-04-14 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('fde7d1a8-3d77-4c63-aa5e-615ab49dd794', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-03-09 12:00:00', '2026-03-09 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('448e0b18-2ab1-4416-bfb8-50ef2fc177e8', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-06-06 17:00:00', '2026-06-06 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('bb942412-db57-4b8d-b540-502e0b611fdc', '8bdb45be-5e06-4224-904e-ca10724599f0', '2026-02-23 17:00:00', '2026-02-23 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('03212a76-bd7d-4110-be6a-f1f8e3bd4fd1', '2521227e-be29-4c74-b38b-29c6a5741457', '2026-06-21 13:00:00', '2026-06-21 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('ba0c7b3e-af7e-486c-9f1b-b5ebcaa12ba4', '2521227e-be29-4c74-b38b-29c6a5741457', '2026-04-11 18:00:00', '2026-04-11 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2e02065d-f3e7-4c13-b8ff-69f04dbf1560', '2521227e-be29-4c74-b38b-29c6a5741457', '2026-03-14 10:00:00', '2026-03-14 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('b8d137d5-81e3-47a6-84a2-01846c759cf4', '2521227e-be29-4c74-b38b-29c6a5741457', '2026-05-26 16:00:00', '2026-05-26 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('9ce8bd3a-a9c0-4ddd-af40-cdc7d1fa50bc', '2521227e-be29-4c74-b38b-29c6a5741457', '2026-02-15 09:00:00', '2026-02-15 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('ea18829e-985a-4642-960e-a7a651961fe4', '2521227e-be29-4c74-b38b-29c6a5741457', '2026-05-17 10:00:00', '2026-05-17 11:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('3e7b07ee-9870-4f9a-a46b-a71ff83e71bd', '2521227e-be29-4c74-b38b-29c6a5741457', '2026-04-15 18:00:00', '2026-04-15 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('978482ba-8ff7-41c4-a575-1f8f538ff57c', '2521227e-be29-4c74-b38b-29c6a5741457', '2026-05-05 16:00:00', '2026-05-05 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('03a99acb-c63f-4a8d-8a8a-12ee37c4f1df', '2521227e-be29-4c74-b38b-29c6a5741457', '2026-05-28 09:00:00', '2026-05-28 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('98e01f48-b245-4256-93f1-b719c641db22', '2521227e-be29-4c74-b38b-29c6a5741457', '2026-02-27 17:00:00', '2026-02-27 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('e1e8cdb9-0419-4ca6-9c9c-a9f17093f4d4', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-03-05 12:00:00', '2026-03-05 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('f39fa0de-023f-4709-9e36-8d6678ef32f7', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-04-19 15:00:00', '2026-04-19 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('9d985e98-7ab8-40a6-9b70-42f5e04745c4', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-05-03 17:00:00', '2026-05-03 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('3a117832-dfdc-40ad-a0cf-bd1ff6194edb', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-03-30 12:00:00', '2026-03-30 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('7ba4bdbc-52f4-4bfe-9871-5fda5e3faf7e', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-04-11 14:00:00', '2026-04-11 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('4c0b9987-e0bc-4a1e-a34f-545323bc9555', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-06-14 17:00:00', '2026-06-14 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('b6745785-b0e0-4565-979f-301717376ecf', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-02-09 16:00:00', '2026-02-09 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('75cc5f53-2f71-4355-a518-c9e943a397d8', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-02-22 17:00:00', '2026-02-22 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('013dd1ce-d472-4d48-b751-f2ab63f56f90', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-05-20 11:00:00', '2026-05-20 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('1546fc37-43e6-4081-94cd-bdf05dcd43fe', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-05-08 09:00:00', '2026-05-08 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('90bb2338-7f3b-405e-ba99-b1430de0b8d0', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-06-13 15:00:00', '2026-06-13 16:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('9ef88419-25eb-438e-9947-c0eff3bc5d7c', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-06-15 09:00:00', '2026-06-15 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('34b6c37c-2117-41c7-b0c0-14cdc06c2834', 'd9b6402e-b747-4701-86a2-4e70537eaeec', '2026-04-18 12:00:00', '2026-04-18 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('89755f11-e85b-4849-999a-6a7f9ce2f35d', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-04-04 14:00:00', '2026-04-04 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('64d4d554-6309-4399-bb22-b7553d47531a', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-06-05 15:00:00', '2026-06-05 16:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('9322c659-7663-46ed-a1f2-a0e037fb3658', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-02-09 16:00:00', '2026-02-09 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('c1c1170b-0040-4577-9c07-9ad126546749', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-03-09 11:00:00', '2026-03-09 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('dff88b13-93de-4df3-97c5-f66c5ecbf6c8', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-07-03 13:00:00', '2026-07-03 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('f3c05c96-dfbf-484f-91d4-8a4f745c17d9', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-03-03 11:00:00', '2026-03-03 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('2f00ca03-2314-40fb-a81d-1ff0afc44ad2', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-05-23 09:00:00', '2026-05-23 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('340c0a97-ca8d-4321-8627-bfab6cdfd6c6', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-06-13 11:00:00', '2026-06-13 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('f379f502-4934-4eba-9c40-aa00265c21d4', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-04-12 15:00:00', '2026-04-12 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('ab7c0e74-e4ce-4d15-bb44-ad825ae749ec', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-04-30 11:00:00', '2026-04-30 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('67686b13-cab7-4270-866e-e62b77bbcb6b', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-05-02 11:00:00', '2026-05-02 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2376fafb-b4e4-4c08-ae3b-24d758ee425c', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-02-23 15:00:00', '2026-02-23 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('8e99602c-7a30-4d9e-b246-69845832490d', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-03-02 14:00:00', '2026-03-02 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('0887d50f-df16-4388-8c1e-7de34176628f', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-02-13 15:00:00', '2026-02-13 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('f128ec1e-428a-4092-92f7-f6bfce235118', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-03-30 17:00:00', '2026-03-30 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('ba89e1e0-0278-4c2b-9b73-c5c9f6d36339', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '2026-05-04 09:00:00', '2026-05-04 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('1e27c24b-45d7-4512-b460-5471ac3fc76d', '43326f8a-d949-430c-aea3-735d47979c13', '2026-05-21 14:00:00', '2026-05-21 15:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('9895870b-d146-409f-935a-fa46d173cae5', '43326f8a-d949-430c-aea3-735d47979c13', '2026-07-02 18:00:00', '2026-07-02 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('08952b0b-04cd-4d88-a7e7-83ac1fce3467', '43326f8a-d949-430c-aea3-735d47979c13', '2026-05-22 11:00:00', '2026-05-22 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('bf02508f-a61b-4384-9567-c33924b83f42', '43326f8a-d949-430c-aea3-735d47979c13', '2026-04-04 12:00:00', '2026-04-04 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('c09f4159-df63-4446-a5bd-dd78e348e944', '43326f8a-d949-430c-aea3-735d47979c13', '2026-03-27 12:00:00', '2026-03-27 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('7a75b964-aea4-4522-ba8d-ce0d3ecfb678', '43326f8a-d949-430c-aea3-735d47979c13', '2026-04-11 14:00:00', '2026-04-11 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('0ad4ba86-f2e9-4982-9719-e1d2a4f56764', '43326f8a-d949-430c-aea3-735d47979c13', '2026-02-19 15:00:00', '2026-02-19 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('f264faee-6572-4657-983a-179851194fab', '43326f8a-d949-430c-aea3-735d47979c13', '2026-05-25 12:00:00', '2026-05-25 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('9639eff6-41d2-4116-ad6d-20512e82df21', '43326f8a-d949-430c-aea3-735d47979c13', '2026-02-11 18:00:00', '2026-02-11 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2bc44170-a0f8-41b1-a760-6d68403c28b5', '43326f8a-d949-430c-aea3-735d47979c13', '2026-04-17 17:00:00', '2026-04-17 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('475ff98e-1b6a-48a7-a424-fc42e28f4b55', '43326f8a-d949-430c-aea3-735d47979c13', '2026-04-12 17:00:00', '2026-04-12 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('67a31b72-2fad-48d2-94e2-49b0a6512eab', '43326f8a-d949-430c-aea3-735d47979c13', '2026-02-27 14:00:00', '2026-02-27 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('a3d3e6c1-3657-4022-ba87-6ee0ab9b19fd', '43326f8a-d949-430c-aea3-735d47979c13', '2026-02-09 13:00:00', '2026-02-09 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('c5aebb9d-238a-4736-99b0-9b271181e306', '43326f8a-d949-430c-aea3-735d47979c13', '2026-05-20 15:00:00', '2026-05-20 16:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('74de428d-8d65-4f0e-be73-7cb8e66627f1', '43326f8a-d949-430c-aea3-735d47979c13', '2026-06-15 09:00:00', '2026-06-15 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('e39e48d7-a1bb-41d2-8d85-fa7af69768ae', '43326f8a-d949-430c-aea3-735d47979c13', '2026-03-10 12:00:00', '2026-03-10 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('a23bbb78-f699-455d-8b9c-594ab01599b3', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-06-24 14:00:00', '2026-06-24 15:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('7ba8a7d8-478a-4340-a680-226905e345af', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-03-04 15:00:00', '2026-03-04 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('cf5644db-615f-491f-9407-50d0b0464b86', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-03-01 16:00:00', '2026-03-01 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('ce1599f2-7e8c-4c2b-9849-d6ebe498d37d', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-04-16 18:00:00', '2026-04-16 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('3e499c42-75c8-47a8-afc6-87c9c68f0634', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-02-16 10:00:00', '2026-02-16 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('45fc9440-7a04-4d4a-ae2e-d34ea295eff8', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-05-25 13:00:00', '2026-05-25 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('bda39c29-ecb8-4cde-adbc-6aeee1c6c2e1', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-02-14 18:00:00', '2026-02-14 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('989715d6-679a-4f0d-b418-193d221e8a3e', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-02-13 09:00:00', '2026-02-13 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('b231177b-55d4-4c29-a80b-c9a176d82a44', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-06-24 17:00:00', '2026-06-24 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('43bfc0a6-bfbc-4bae-9e3c-f2726797a7fc', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-02-24 14:00:00', '2026-02-24 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('7fda3e04-8ff2-4449-b659-9337217db066', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-04-13 11:00:00', '2026-04-13 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('ab2a357c-ff5b-418a-94c9-867f3265891d', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-05-15 12:00:00', '2026-05-15 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('625ec456-c361-4a51-bdfc-ecc1f86f3107', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-03-20 18:00:00', '2026-03-20 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('fd20462f-86e3-4faf-80d8-683b222570f5', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-07-01 13:00:00', '2026-07-01 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('d1bd9883-ceb4-4f42-bb62-b344f9aecc04', '9e2538b1-105a-41e5-93b5-958545f78e43', '2026-02-13 15:00:00', '2026-02-13 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('7de0f32a-7507-4a66-b987-db9dce020edf', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-05-17 12:00:00', '2026-05-17 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('34cd5674-8043-4a2a-bc69-60d75d54d8cc', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-06-30 10:00:00', '2026-06-30 11:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('8bc4dd2f-c15e-41eb-bb86-ecbb46504247', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-05-13 10:00:00', '2026-05-13 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('6bd75e5c-6b0f-4c3a-af69-301f8b4e0127', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-02-11 15:00:00', '2026-02-11 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('e7a3058d-0dce-4ecd-9679-250dc281ef08', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-04-13 18:00:00', '2026-04-13 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('e0cb3ca6-7044-4033-ae25-bd76812ea595', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-04-11 12:00:00', '2026-04-11 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('f0f2cca2-74d4-4425-8bf6-89cc3f7c74c9', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-03-14 10:00:00', '2026-03-14 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('378318e1-0eb0-4827-b050-44db2821ef6c', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-05-07 12:00:00', '2026-05-07 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('a0dbefb6-e974-4068-81fe-a9b33a43ad14', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-03-25 15:00:00', '2026-03-25 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('5e4d0f32-48d6-489a-a656-e96d95766d81', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-04-04 09:00:00', '2026-04-04 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('9fadebf7-1bc1-4468-b101-77ebbf820836', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-03-27 14:00:00', '2026-03-27 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('c5529604-d6ec-48e5-858b-0458d19d9623', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-06-29 18:00:00', '2026-06-29 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('305d041b-e963-419e-8d9b-c4b5e1adfcd2', '035c6559-1715-4f72-91a1-9b8ec53abb80', '2026-02-16 11:00:00', '2026-02-16 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('1ba032d1-1d30-429e-8320-047a79e7118d', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-03-12 09:00:00', '2026-03-12 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('a840f43f-5694-43b3-b1b2-f7ce0d398f98', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-03-02 10:00:00', '2026-03-02 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('8be5f670-fa3f-41ac-a007-70b6ab50c6b9', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-07-04 11:00:00', '2026-07-04 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('aa013705-907e-4b6e-826d-cea1c1ecc67b', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-03-23 09:00:00', '2026-03-23 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('b914249d-8994-421b-b11a-d85978b0f771', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-03-15 15:00:00', '2026-03-15 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('350c97ca-26fa-4069-a989-ba632bb51bcc', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-04-05 16:00:00', '2026-04-05 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('7be9ce44-c6f1-46ef-ab5d-63290bbc2a86', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-05-03 12:00:00', '2026-05-03 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('622c0a53-ed45-4ed8-be31-93e739168636', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-03-04 15:00:00', '2026-03-04 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('62387849-4d03-4628-948e-c7a2507112b3', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-02-09 11:00:00', '2026-02-09 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('ebe977c1-3a1d-4424-9186-11685be67513', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-02-13 16:00:00', '2026-02-13 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('942cd7e4-00bc-467f-b182-b14382a8c339', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-04-12 09:00:00', '2026-04-12 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('34a3957b-54e9-40fd-b1cf-8db067d64b0e', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-07-06 14:00:00', '2026-07-06 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('f0e4dd26-90b2-41f4-8ee6-ef032f0a63a2', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-05-08 18:00:00', '2026-05-08 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('c9e2144f-89a4-4830-9e33-e7dd67180322', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '2026-03-14 10:00:00', '2026-03-14 11:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('a8dc1c47-d02b-465a-b825-8f61068f5fb3', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-04-21 15:00:00', '2026-04-21 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('7b34b45f-421b-410e-972b-7266e6c22dca', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-03-11 12:00:00', '2026-03-11 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('4867d952-791e-4d12-a23b-b69ae8e71af7', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-06-22 17:00:00', '2026-06-22 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('44d16e0e-08a1-4392-b559-6f2a7fbf2a77', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-02-27 13:00:00', '2026-02-27 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('0b58eab7-c72f-40c2-9ff9-2130898de7d4', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-04-25 09:00:00', '2026-04-25 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2514fbaa-2750-40e6-92d5-46a58a4fc78b', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-06-18 11:00:00', '2026-06-18 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('347238de-067f-402b-8589-6ecb6cb54011', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-06-05 11:00:00', '2026-06-05 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('5ad46af6-1d7f-4ff7-9e0f-cbb63bf15deb', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-03-10 17:00:00', '2026-03-10 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('06004544-9017-45d8-befb-aae3ee2ddf1f', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-04-16 17:00:00', '2026-04-16 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('48eba622-9501-4644-8e72-defec6a514be', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-04-29 14:00:00', '2026-04-29 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('7976fc8a-65cd-4d06-b954-7a15e4c6e120', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-06-09 16:00:00', '2026-06-09 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('52a6682f-f35c-4a6e-aa4f-15d2e4ae3ba7', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-06-18 11:00:00', '2026-06-18 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('ab8115ec-69bf-462f-8424-5fffaf1e2a3b', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-04-09 09:00:00', '2026-04-09 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('4a702611-9a5f-44a4-a461-b64cbc54f2a6', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-04-23 15:00:00', '2026-04-23 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('dce2454e-bc72-4961-b488-ee5871b20888', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '2026-06-09 11:00:00', '2026-06-09 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('376b6aec-378c-4e06-9729-57cbace4d9bd', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-02-18 15:00:00', '2026-02-18 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('f6ee920f-26a8-41d2-b2e9-b9ce8db02998', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-03-08 12:00:00', '2026-03-08 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('cb5f3734-e424-48e0-863d-29da0f6f5dbd', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-05-29 11:00:00', '2026-05-29 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('a3a5c2d1-eabe-4b31-9ca4-7cb3f114867e', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-06-27 14:00:00', '2026-06-27 15:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('c13e1138-7982-42f4-9474-5c02875b9b9f', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-04-24 16:00:00', '2026-04-24 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('afbc23d8-11f7-4717-859f-0a750b912157', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-05-11 17:00:00', '2026-05-11 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('c2064e4e-12cd-4cec-bbae-8cf6362f44a6', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-02-17 11:00:00', '2026-02-17 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('92c47e5d-6793-4652-b359-e8f43fa77350', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-05-08 15:00:00', '2026-05-08 16:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('4011f4df-dcde-4d5e-8d27-5cd8c3e986eb', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-06-14 15:00:00', '2026-06-14 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('36aea5a1-9801-4772-890b-ad92b508e136', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-06-16 13:00:00', '2026-06-16 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('b8376567-3aad-4c1b-bbcd-84d5350e3993', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-03-23 12:00:00', '2026-03-23 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('567f1433-1f74-46e3-a036-cffbbcea98f8', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-03-10 12:00:00', '2026-03-10 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('73e34136-e450-4d9a-9f15-d2e168c64b7f', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-03-13 18:00:00', '2026-03-13 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('89a3c4ef-fc35-469e-9260-c8a833b85d29', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-06-23 12:00:00', '2026-06-23 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('3c16cc8d-8cae-4d83-8b7b-4d98d33acbba', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-02-13 16:00:00', '2026-02-13 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('6bbbba6c-0fa3-4a92-9d43-aa9620057165', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', '2026-04-09 09:00:00', '2026-04-09 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('43bcea98-8e80-413d-8b50-cc435a73e40b', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-06-04 12:00:00', '2026-06-04 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('94b0d5d5-2745-4216-977e-ba09ec95aad8', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-02-16 11:00:00', '2026-02-16 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('6bd3bee6-99b2-4232-9d90-b9104000604d', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-03-31 17:00:00', '2026-03-31 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('41846040-824c-40f9-8197-4166995fbaae', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-04-19 15:00:00', '2026-04-19 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('26a0bed4-a01e-4557-a32a-56baaf07d44a', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-04-07 15:00:00', '2026-04-07 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('977f8136-1f42-4531-a0cb-8b53daff4890', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-07-01 15:00:00', '2026-07-01 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('c10dc9e6-2fdb-4211-a031-d2c90c104eb6', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-02-18 12:00:00', '2026-02-18 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('d312bc31-dca0-464f-a960-70494e97bfa6', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-03-19 10:00:00', '2026-03-19 11:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('ec3cad52-5bbf-4219-af1e-512943baa9c4', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-02-13 17:00:00', '2026-02-13 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('9230d358-877d-41e4-a1be-ed6e9a0e1a7b', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-04-15 11:00:00', '2026-04-15 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('a5f3b153-19ed-4c50-882a-8fb56077c732', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-02-25 17:00:00', '2026-02-25 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2fe9d23b-77b9-4ef6-860d-155b73aef119', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-04-21 16:00:00', '2026-04-21 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('c93b0a2d-0b5c-4e62-9e1a-6f665c69ff8c', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-02-14 17:00:00', '2026-02-14 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('69994be4-605b-4cba-996e-d8e12cb6d006', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-04-09 16:00:00', '2026-04-09 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('3dbe73fd-0c91-4f08-a580-94827faa684b', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-04-01 11:00:00', '2026-04-01 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('ed56f44d-b9ac-48f0-bce6-b1c8406f14ba', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', '2026-05-13 17:00:00', '2026-05-13 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('a969fa92-4b5c-46f4-bf39-a7dae578c4b9', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-03-15 15:00:00', '2026-03-15 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('fce2f784-1ad3-454e-a3c4-48226e819e0b', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-04-24 10:00:00', '2026-04-24 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2263ec44-6db6-4cc6-9283-a2444e862b68', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-03-12 15:00:00', '2026-03-12 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('4037973d-e8fa-47a7-a516-839b9fead88f', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-06-16 18:00:00', '2026-06-16 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('3501e5b4-a0ba-4a29-80fb-d25f5521b816', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-04-01 10:00:00', '2026-04-01 11:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('6d665fab-65b6-4b24-ae91-d083425a96c3', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-04-12 09:00:00', '2026-04-12 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('60137c1d-8f8b-4260-b4de-b69604c03399', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-03-24 09:00:00', '2026-03-24 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('1eaac23b-15b3-45cc-b627-5322461bc2fb', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-05-03 10:00:00', '2026-05-03 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('278456ee-e966-4137-8abe-eface38027ba', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-03-22 16:00:00', '2026-03-22 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('6c078a54-4e92-4368-a644-d45204742145', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-03-18 12:00:00', '2026-03-18 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('6a875c45-e62f-4f1b-a4a5-de9e35b85ca4', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-05-08 12:00:00', '2026-05-08 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('d0d4f085-fa46-4c38-aa14-31792326aeb9', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-05-10 14:00:00', '2026-05-10 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('33b7e4ef-d043-4a74-ad6c-18f37bcc4ae3', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-04-10 13:00:00', '2026-04-10 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('eeba7937-a6cc-4801-b1da-8d7ef7a67c2f', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-06-26 18:00:00', '2026-06-26 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('17243db7-c67b-4e8f-a453-8c6ee8270329', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', '2026-03-24 13:00:00', '2026-03-24 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('858633a6-f414-4d0f-bd0f-eaa97240ed00', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-04-19 13:00:00', '2026-04-19 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('dbc82ee0-bb95-4550-96b4-65595af79895', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-04-20 14:00:00', '2026-04-20 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('236e4580-6018-448a-944f-bab6463ff263', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-03-24 09:00:00', '2026-03-24 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('39e416b8-f0c9-4573-89f9-840ace48ce82', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-04-23 12:00:00', '2026-04-23 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('028ecb6d-4011-4841-81a0-4c4aef76c370', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-04-28 13:00:00', '2026-04-28 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('eaaedb64-aca7-479f-996e-0ccf90be8c4a', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-05-17 14:00:00', '2026-05-17 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('9f224ff2-5a70-4996-b547-946f2516c009', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-06-03 13:00:00', '2026-06-03 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('b5328d6b-3d5b-4e82-b5ce-23d4f1395c2a', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-03-15 10:00:00', '2026-03-15 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('8d79e771-e155-41b1-93c1-b1fd6fd1340b', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-06-07 17:00:00', '2026-06-07 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('143731f4-fa3b-4f58-9306-b8479f0b77c4', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-07-01 13:00:00', '2026-07-01 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('cb254d93-5b01-4885-b2f9-40b1bf586a70', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-06-02 13:00:00', '2026-06-02 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('f924509f-d6a5-4fd9-9c63-a95484818663', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-03-11 12:00:00', '2026-03-11 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('75240de9-e5eb-4e34-a3a5-d6ad9111e6bc', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-02-24 18:00:00', '2026-02-24 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('f04f3148-fc65-4b62-9360-9c624c6fc825', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-04-23 16:00:00', '2026-04-23 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('b12343e7-fb8e-4794-be09-d26d88ac1286', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '2026-02-17 13:00:00', '2026-02-17 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('38b41f17-e220-4bc6-bbf0-306b355a862a', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-06-04 12:00:00', '2026-06-04 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('ba27a1bc-e8c9-4bae-a51a-acf15989f04b', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-03-08 18:00:00', '2026-03-08 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('1f98c692-2459-42a0-a59d-9ec927a90d0b', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-05-06 15:00:00', '2026-05-06 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('18c346d9-b4df-4d57-9c5c-980adddb2809', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-03-04 09:00:00', '2026-03-04 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('c6579913-0bb6-448a-abde-48831ff59afb', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-05-01 11:00:00', '2026-05-01 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('3837a023-8a05-4931-b4d1-738300658bf5', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-05-09 11:00:00', '2026-05-09 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('71038725-3e1e-4f34-a2c6-c4bc7bd8b829', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-04-05 11:00:00', '2026-04-05 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('cc9a1943-16ef-4df8-8d0f-57e6ead39075', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-04-21 17:00:00', '2026-04-21 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('1035808f-6354-44fd-a5eb-ab3dd42464bd', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-03-10 10:00:00', '2026-03-10 11:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('dfe312f3-4037-4a31-97af-ddbc5e6e05a0', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-05-21 11:00:00', '2026-05-21 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('bb08ad65-f327-4494-a197-1f2b4e9c6f8c', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-05-08 16:00:00', '2026-05-08 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('18373946-aa9a-4b66-a7e1-fc5a96e877fb', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-04-03 16:00:00', '2026-04-03 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('ea5310c7-b9cf-4175-abf3-4e275d5c80bb', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-06-02 13:00:00', '2026-06-02 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('a5259614-f3d1-4a06-b35e-1019fc7268cc', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-07-01 16:00:00', '2026-07-01 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('b7a48b3c-b077-4a3b-984e-b82a15ba43a2', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-04-07 11:00:00', '2026-04-07 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('51b7eab8-821a-4a25-b580-7d288ada7f30', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-05-29 17:00:00', '2026-05-29 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('fc0e0ca7-4aeb-4e6f-b76c-686826a4e8a5', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '2026-06-08 18:00:00', '2026-06-08 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('ca3144a3-df9b-4238-ba73-1a00398ee8f1', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-05-25 14:00:00', '2026-05-25 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('249c7375-871f-4735-ae10-136e239c73da', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-02-13 09:00:00', '2026-02-13 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('b2b47948-bb51-443f-8535-b95078c6f573', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-04-06 12:00:00', '2026-04-06 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('fac0e4ac-de68-419d-a7ed-dd14750804ad', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-02-22 16:00:00', '2026-02-22 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('a7f14c67-2e08-4b75-b6c3-ec07786f8dd1', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-05-05 10:00:00', '2026-05-05 11:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('72968f06-c287-4cb8-8694-f2b9b097d1af', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-04-26 14:00:00', '2026-04-26 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('1222004b-77c2-4a42-b638-00979a7fc8c8', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-03-16 15:00:00', '2026-03-16 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('39e09023-df72-463d-b252-d60ead109a79', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-03-17 18:00:00', '2026-03-17 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('7648caff-9695-44f0-88ac-992a3cbde9c0', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-04-12 16:00:00', '2026-04-12 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('88dd08be-a5e6-4ee5-89a6-4cec6636aafa', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-04-20 15:00:00', '2026-04-20 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('1bfd44b4-9952-4a13-9634-346695ec528f', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-02-10 15:00:00', '2026-02-10 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('3f1ade43-3b22-4792-910f-a652fd036254', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-06-10 10:00:00', '2026-06-10 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('38638880-4f01-49e3-a0f0-c01dbba2d9ba', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-05-21 18:00:00', '2026-05-21 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('0778fad2-ce7d-40e1-ab0e-c0d241527cd6', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-05-24 11:00:00', '2026-05-24 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('3d84809f-42a3-4727-8ec8-905a0a46e9df', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-06-18 13:00:00', '2026-06-18 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('15af4025-7146-407b-ae4f-06f60cc73c60', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-03-23 18:00:00', '2026-03-23 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('15972bf1-bebf-4abc-b84e-a1958828dc2a', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-05-22 15:00:00', '2026-05-22 16:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('372a847e-5883-426f-807e-866d66a65071', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-06-18 13:00:00', '2026-06-18 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('6f5b4880-2dc2-4c88-affe-9d9c0c1208d0', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2026-05-07 18:00:00', '2026-05-07 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('d90f682c-7683-4d3e-bbba-b94f20eaae2a', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-06-20 11:00:00', '2026-06-20 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('ddaa0c3f-6b11-4a89-8791-3b0f8f3146d4', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-03-12 09:00:00', '2026-03-12 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('f322bb3d-258e-41ef-82a3-8ce473cb8cc4', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-04-25 10:00:00', '2026-04-25 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('fd3fc250-c816-448d-b27e-f8c86fd34f71', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-06-12 11:00:00', '2026-06-12 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('2baa8f94-2e44-487f-b1b6-b53415d0d08b', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-04-08 18:00:00', '2026-04-08 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('71f7dfbd-25f7-4786-9fcb-bfe47c134e5f', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-03-06 14:00:00', '2026-03-06 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('a83ebc78-4ff6-4954-8081-324584b9d466', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-05-11 13:00:00', '2026-05-11 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('7b6d2ffd-57d6-4dfe-8cfd-6bccdf6253ef', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-06-10 14:00:00', '2026-06-10 15:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('2c50fd85-361b-4745-8a8a-dbb3107d079d', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-04-03 12:00:00', '2026-04-03 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('ca419dfd-a23a-472a-a6e0-e962a19e2d78', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-06-28 11:00:00', '2026-06-28 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('ceca616d-f5b2-4136-a292-edf954c73ff2', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-05-11 09:00:00', '2026-05-11 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('1c1ea002-32d8-4258-bf30-e2b4b3988eea', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-04-02 11:00:00', '2026-04-02 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('3067e536-ea6f-434a-bab0-86ac7247d6d3', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-06-25 12:00:00', '2026-06-25 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('8ccd16bd-6aba-4b63-b381-12949cf0838d', '09697d5c-94af-460c-a1bb-de10bc92f737', '2026-03-17 16:00:00', '2026-03-17 17:00:00', 'недоступен');


--
-- TOC entry 5007 (class 0 OID 24971)
-- Dependencies: 218
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categories VALUES ('603cc426-250e-4dce-ba28-5fc6c575363a', 'Маркетинг');
INSERT INTO public.categories VALUES ('b288d33d-10e4-4185-9e90-a9251f14d584', 'Финансы');
INSERT INTO public.categories VALUES ('0bc40aae-f266-4c5f-af6a-3127f26c7257', 'Логистика');
INSERT INTO public.categories VALUES ('2971d7fd-2f27-4e7a-8b8d-2dbf8bf8c3d8', 'IT и Разработка');
INSERT INTO public.categories VALUES ('c6988c7c-3d75-4631-a4d8-b721558b3cf1', 'Менеджмент');
INSERT INTO public.categories VALUES ('7a45023d-107d-4c63-8aeb-173fbf9e1244', 'Дизайн');
INSERT INTO public.categories VALUES ('76fecc11-c995-420a-a666-ba17ea0e30ff', 'Юриспруденция');
INSERT INTO public.categories VALUES ('298f0067-0647-45e9-a10e-27ff78711092', 'HR');


--
-- TOC entry 5015 (class 0 OID 25093)
-- Dependencies: 226
-- Data for Name: course_reviews; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.course_reviews VALUES ('76a8ed3f-5844-42f6-a96c-27ce2925ffd6', '85ced628-d46e-416e-88ee-a71d2f6c74f2', 1, 'Много воды, хотелось бы больше практики.', '2026-05-06');
INSERT INTO public.course_reviews VALUES ('d742df09-684a-4d51-a6da-03aecc479334', 'b5e87f77-5540-4bfa-8f20-d3428827cba6', 3, 'Материал хороший, но подача немного сухая.', '2026-04-16');
INSERT INTO public.course_reviews VALUES ('416b55c3-89fd-44a2-af3b-a5d3cd844e71', '3f6787c7-5a5d-4ae0-81d1-6c8f9d333b85', 5, 'Спасибо, всё четко и по делу.', '2026-03-04');
INSERT INTO public.course_reviews VALUES ('2357d6ae-a9f7-4d8b-88ba-1498a2c861e5', '4d0401f5-de03-437f-b8ce-6aa6c73e40e2', 5, 'Лучшая инвестиция в мой бизнес!', '2026-04-11');
INSERT INTO public.course_reviews VALUES ('3a7f5855-dd2d-40b8-abec-4f52e3e7e27e', 'fd6043c9-4920-4fb1-ab2f-f83537c2547d', 3, 'Материал хороший, но подача немного сухая.', '2025-12-06');
INSERT INTO public.course_reviews VALUES ('6a7f358d-bf79-409a-a9c7-503893eb4b0a', '4de6a1b4-0cca-4b61-a3eb-a1fb4f3c3aaa', 2, 'Много воды, хотелось бы больше практики.', '2026-04-02');
INSERT INTO public.course_reviews VALUES ('901073db-32d7-42eb-a380-1c96abcc27ca', '5afc479f-e4fe-47ab-93a4-af1e7278adb9', 1, 'Зря потратил время и деньги.', '2025-09-03');
INSERT INTO public.course_reviews VALUES ('4c608d18-0e3b-4c35-b904-be52d455d5fc', '3322de6f-3fe8-406d-9a16-a5008d364361', 4, 'Лучшая инвестиция в мой бизнес!', '2026-04-30');
INSERT INTO public.course_reviews VALUES ('e79733ba-9e37-43f1-a6e6-a479c660ab83', 'eff71e10-5a68-4a79-a300-fbbbb261e28a', 1, 'Зря потратил время и деньги.', '2025-06-09');
INSERT INTO public.course_reviews VALUES ('893ae274-5e89-4486-ada6-25cc11b89f72', '613415c4-eb18-4725-b300-ad062fc83bbc', 2, 'Зря потратил время и деньги.', '2025-12-25');
INSERT INTO public.course_reviews VALUES ('7c17668a-c54c-4079-885e-d9a92469a530', 'e51d33fa-3727-4da7-a225-b9618366df19', 2, 'Зря потратил время и деньги.', '2025-10-29');
INSERT INTO public.course_reviews VALUES ('1cf973a4-3db8-483e-b7ef-993c07f64cb9', '90b38d09-713d-4c17-bcb6-e0bc5d1d9680', 1, 'Зря потратил время и деньги.', '2024-12-22');
INSERT INTO public.course_reviews VALUES ('ad7e7eae-8fbd-482f-92a4-ade5032366cd', 'a8062dee-14a2-4d13-99e2-c49962f0d10c', 1, 'Зря потратил время и деньги.', '2024-12-06');
INSERT INTO public.course_reviews VALUES ('5e7f7fe9-5793-4fce-b72b-c9a6ad0e09a1', '1aa5c578-e0e9-4519-9b17-a5dd0ac8b238', 5, 'Полный восторг, превзошло все ожидания!', '2025-09-04');
INSERT INTO public.course_reviews VALUES ('c8a855f6-bbae-4051-b804-555f56f9abd5', '37614b93-a016-467d-bd45-5ccaa54d02ee', 1, 'Зря потратил время и деньги.', '2026-02-24');
INSERT INTO public.course_reviews VALUES ('84a594f9-7429-4994-9c37-59f3f609460b', '55b55f9d-d068-4144-ad7e-2e68f8320cb3', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-12-14');
INSERT INTO public.course_reviews VALUES ('92ec5ff5-971e-4d93-92df-ad82767438a9', 'da8a6074-cd03-450b-80aa-2b74a816de01', 2, 'Зря потратил время и деньги.', '2026-01-29');
INSERT INTO public.course_reviews VALUES ('a86ebeed-f8e7-420b-b391-5834b4170310', '85c08abb-c693-4ba0-9d31-26b59ddf9a99', 1, 'Зря потратил время и деньги.', '2025-07-26');
INSERT INTO public.course_reviews VALUES ('384c9a86-6e7e-4921-a3ba-b3069b59f8cb', '7ece4690-2efa-4880-9612-8cecdc942aac', 3, 'Цена полностью оправдывает качество.', '2025-11-26');
INSERT INTO public.course_reviews VALUES ('29484e52-4b5a-46a6-b6c7-d42d70833cf5', '8cdeca98-3659-4de7-b314-48e95893df46', 2, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-12-18');
INSERT INTO public.course_reviews VALUES ('8e4c0a77-0098-478e-a9dd-add511803bc5', '77ed399a-fe57-4108-b9a8-8701a683bdef', 3, 'Цена полностью оправдывает качество.', '2025-12-29');
INSERT INTO public.course_reviews VALUES ('da3fb088-b0c5-4706-a395-43c98a2038fc', 'c6a145d9-46da-44c9-849f-71a0cda698ff', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-07-08');
INSERT INTO public.course_reviews VALUES ('d9696958-14bb-4767-b02a-aaef02d4bda3', '4eccc7d4-39ae-4bf3-acbc-d73bda7c4667', 1, 'Зря потратил время и деньги.', '2024-09-21');
INSERT INTO public.course_reviews VALUES ('87c3f581-ecaa-497c-8e46-85e746324511', 'eb16013b-5d3c-41b6-98f4-2932e4433fb5', 4, 'Полный восторг, превзошло все ожидания!', '2026-02-03');
INSERT INTO public.course_reviews VALUES ('ab3f8755-13f5-40bd-9851-84882da280cd', '33cee59c-db75-47ac-8c27-c2321a3f20aa', 4, 'Профессионал своего дела, рекомендую.', '2026-02-22');
INSERT INTO public.course_reviews VALUES ('9afe7622-58a8-4347-9ef2-cc20dce57a9a', '1bbbcc2d-62ec-4007-a46c-18231123d9c9', 1, 'Много воды, хотелось бы больше практики.', '2025-07-30');
INSERT INTO public.course_reviews VALUES ('51d5d801-eba1-488e-8a58-cafbb31510e6', 'e2d99d9f-3042-4796-aeba-b0c90a70cbe0', 5, 'Спасибо, всё четко и по делу.', '2025-04-08');
INSERT INTO public.course_reviews VALUES ('9580b61b-c01a-4516-aa45-7fed5965a670', 'b82e84ee-f3c5-40e3-a4fc-caa5e6365a49', 2, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-04-02');
INSERT INTO public.course_reviews VALUES ('ec468dc7-23ed-4d89-aa69-8a09263d4166', '7b1d0a27-769c-4fc4-a138-05983a950e41', 4, 'Профессионал своего дела, рекомендую.', '2026-04-16');
INSERT INTO public.course_reviews VALUES ('690cebbf-aeee-4ad8-98e9-1c13c73d2e17', '7074f20c-2072-423b-a6de-ab6a97c9dcf9', 4, 'Профессионал своего дела, рекомендую.', '2026-04-27');
INSERT INTO public.course_reviews VALUES ('8f687c42-9771-44d7-8947-6ef8d0a1df38', '3e14a9b3-2531-4761-b52a-982d1e6db334', 3, 'Цена полностью оправдывает качество.', '2026-03-13');
INSERT INTO public.course_reviews VALUES ('824c28a8-53fe-41fe-8efe-96e6d9711a0b', '46438033-17c0-4bef-b15d-ef0ca2091178', 5, 'Профессионал своего дела, рекомендую.', '2025-02-13');
INSERT INTO public.course_reviews VALUES ('1e5d1028-5432-4fd2-b896-5e58735b5024', '8fc23ccc-90a8-4fe0-8d6e-cdb57f3daf99', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2025-04-11');
INSERT INTO public.course_reviews VALUES ('9fabb280-cd49-4534-8f49-01bb228b214f', 'bd4cb567-25f4-4ee0-945e-7767d1afb2b4', 3, 'Цена полностью оправдывает качество.', '2025-07-13');
INSERT INTO public.course_reviews VALUES ('fbf3d8a2-1380-4d1f-b923-e203aedca76e', 'd7a4006b-ae07-4b54-9a1e-0e259281b044', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2024-12-28');
INSERT INTO public.course_reviews VALUES ('d566ba30-8977-4def-9474-1e1c55290309', 'ba23a387-3594-444a-a770-d5dcac49f3ef', 4, 'Отличный материал, очень помогло!', '2025-10-28');
INSERT INTO public.course_reviews VALUES ('ac4d81c1-d013-482b-b54d-a7f06c619c7b', '9482dcbb-2820-4595-8acc-109fbc5c3992', 2, 'Много воды, хотелось бы больше практики.', '2026-04-03');
INSERT INTO public.course_reviews VALUES ('93cb2418-5eec-4600-a6db-0aae7f6fbeba', '67da5ff2-8982-4c71-a9e6-18fbc598ab4a', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2026-03-14');
INSERT INTO public.course_reviews VALUES ('c9119a9f-01ae-49fc-a39f-203d5b132da3', '8b2da6ac-8786-476f-afdc-ed35b1bbcc86', 2, 'Много воды, хотелось бы больше практики.', '2026-05-07');
INSERT INTO public.course_reviews VALUES ('4a05779b-8a9e-4649-949b-e7215da17b24', '6f5bb3c7-2b9d-4f95-aef3-09412bea97d8', 2, 'Зря потратил время и деньги.', '2026-04-30');
INSERT INTO public.course_reviews VALUES ('080c13b6-7774-4d82-8f9c-21b0b0ce513c', 'e106ceeb-8990-4305-a55c-3068a8ed14ce', 1, 'Зря потратил время и деньги.', '2026-05-05');


--
-- TOC entry 5013 (class 0 OID 25057)
-- Dependencies: 224
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.courses VALUES ('c17c7717-5766-4873-91f2-ff097b60167c', '035c6559-1715-4f72-91a1-9b8ec53abb80', 'Основы фин. грамотности', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 29241.82, '2024-11-20', NULL, 'published');
INSERT INTO public.courses VALUES ('1b906bc2-ae85-4091-a7e7-22615ebe7c5e', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', 'Мастер-класс: B2B продажи', 'Практический курс по современным методам управления. Только рабочие инструменты. Доступ навсегда.', 43185.59, '2026-01-06', NULL, 'published');
INSERT INTO public.courses VALUES ('63eed6eb-74da-4fe8-a7ad-ac01a69bab9c', '035c6559-1715-4f72-91a1-9b8ec53abb80', 'Тайм-менеджмент', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов.', 46759.46, '2024-12-27', NULL, 'published');
INSERT INTO public.courses VALUES ('2ee9e287-795c-4b62-bbad-70cb4d0ff748', '035c6559-1715-4f72-91a1-9b8ec53abb80', 'Основы фин. грамотности', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов.', 13075.03, '2025-12-09', NULL, 'published');
INSERT INTO public.courses VALUES ('52a60d7d-9df4-4266-82e2-371213b8c5c0', '2b122c6b-e3d8-4b39-b165-aa8b61834322', 'Excel для финансиста', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов.', 29569.92, '2026-04-10', NULL, 'published');
INSERT INTO public.courses VALUES ('4496ee09-31dc-43a6-a587-7b2e3d42dad8', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', 'Основы фин. грамотности', 'Практический курс по современным методам управления. Только рабочие инструменты. Доступ навсегда.', 40038.10, '2025-12-28', NULL, 'published');
INSERT INTO public.courses VALUES ('59d11679-2a48-4372-a15a-13154cd3557d', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', 'Тайм-менеджмент', 'Практический курс по современным методам управления. Только рабочие инструменты. Доступ навсегда.', 36051.31, '2026-01-08', NULL, 'published');
INSERT INTO public.courses VALUES ('502bd0fa-6477-4259-a5a4-fe8da3a4d8c6', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'Управление командой', 'Практический курс по современным методам управления. Только рабочие инструменты. Доступ навсегда.', 43338.38, '2025-03-23', NULL, 'published');
INSERT INTO public.courses VALUES ('bac90a60-c4fd-4814-adfd-a561386ae7f9', '43326f8a-d949-430c-aea3-735d47979c13', 'Excel для финансиста', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов.', 26611.60, '2025-09-29', NULL, 'archived');
INSERT INTO public.courses VALUES ('3f8a1462-322e-4aa3-a466-68fa16bdf47a', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'Тайм-менеджмент', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов.', 12249.03, '2025-11-12', NULL, 'published');
INSERT INTO public.courses VALUES ('65d9571a-365b-41a5-b3b7-efc625a01e37', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', 'Мастер-класс: B2B продажи', 'Интенсивный курс для начинающих. Вы узнаете, как правильно считать юнит-экономику и составлять P&L отчеты.', 19177.11, '2025-06-27', NULL, 'published');
INSERT INTO public.courses VALUES ('ffece5ef-9d37-4a84-93b9-a17a4e4ba2c2', '8bdb45be-5e06-4224-904e-ca10724599f0', 'Мастер-класс: B2B продажи', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов.', 30414.49, '2025-07-01', NULL, 'published');
INSERT INTO public.courses VALUES ('7a30fcb1-fad3-492c-899f-dc2abb339635', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', 'Управление командой', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов.', 10414.49, '2026-03-19', NULL, 'published');
INSERT INTO public.courses VALUES ('1c3a0c9c-0c16-43c7-ae3b-b702ded59709', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'Мастер-класс: B2B продажи', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 40850.84, '2025-05-12', NULL, 'published');
INSERT INTO public.courses VALUES ('0909ea3b-f59e-4297-9b33-5b37130bb152', '035c6559-1715-4f72-91a1-9b8ec53abb80', 'Безопасность бизнеса', 'Практический курс по современным методам управления. Только рабочие инструменты. Доступ навсегда.', 9461.00, '2025-11-29', NULL, 'published');
INSERT INTO public.courses VALUES ('19bd6c99-2cfd-4986-9986-4935b90c17fa', '8bdb45be-5e06-4224-904e-ca10724599f0', 'Автоматизация склада', 'Практический курс по современным методам управления. Только рабочие инструменты. Доступ навсегда.', 28127.10, '2025-07-08', NULL, 'published');
INSERT INTO public.courses VALUES ('940c2c75-ef20-4875-96ff-2241ef5882ba', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', 'SMM для бизнеса 2024', 'Интенсивный курс для начинающих. Вы узнаете, как правильно считать юнит-экономику и составлять P&L отчеты.', 32537.43, '2025-11-08', NULL, 'published');
INSERT INTO public.courses VALUES ('f49ceefc-95d1-493d-8eb4-e5384641c09c', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', 'SMM для бизнеса 2024', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов.', 13880.19, '2025-10-16', NULL, 'published');
INSERT INTO public.courses VALUES ('9a65d469-d61c-4059-be28-56d91345973d', '2b122c6b-e3d8-4b39-b165-aa8b61834322', 'Тайм-менеджмент', 'Интенсивный курс для начинающих. Вы узнаете, как правильно считать юнит-экономику и составлять P&L отчеты.', 24596.04, '2026-01-11', NULL, 'published');
INSERT INTO public.courses VALUES ('bd935bd4-bcc2-4322-a727-deb2ad6262ef', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', 'Мастер-класс: B2B продажи', 'Практический курс по современным методам управления. Только рабочие инструменты. Доступ навсегда.', 48204.18, '2025-05-19', NULL, 'published');
INSERT INTO public.courses VALUES ('f3daa59f-3ea2-4cd4-a3f8-c574868d257b', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', 'Мастер-класс: B2B продажи', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов.', 21226.60, '2025-11-29', NULL, 'published');
INSERT INTO public.courses VALUES ('5b7b495a-0c06-4f90-8635-c6958511d829', '8bdb45be-5e06-4224-904e-ca10724599f0', 'Безопасность бизнеса', 'Интенсивный курс для начинающих. Вы узнаете, как правильно считать юнит-экономику и составлять P&L отчеты.', 49478.95, '2025-06-09', NULL, 'published');
INSERT INTO public.courses VALUES ('0dcee391-2bc9-4439-8e8b-d7afb7c8e53e', '035c6559-1715-4f72-91a1-9b8ec53abb80', 'Основы фин. грамотности', 'Интенсивный курс для начинающих. Вы узнаете, как правильно считать юнит-экономику и составлять P&L отчеты.', 16360.08, '2025-07-04', NULL, 'published');
INSERT INTO public.courses VALUES ('46b29ac9-92c1-4d60-a863-789dbdd0b757', '9e2538b1-105a-41e5-93b5-958545f78e43', 'SMM для бизнеса 2024', 'Интенсивный курс для начинающих. Вы узнаете, как правильно считать юнит-экономику и составлять P&L отчеты.', 26300.98, '2026-01-17', NULL, 'published');
INSERT INTO public.courses VALUES ('d9d4b197-9d22-404a-8f3e-c1ec2a5e91f1', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', 'Тайм-менеджмент', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 34054.51, '2025-12-23', NULL, 'published');
INSERT INTO public.courses VALUES ('a092b310-c25c-4ff9-9620-a966924916eb', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', 'SMM для бизнеса 2024', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 23291.45, '2025-10-26', NULL, 'published');
INSERT INTO public.courses VALUES ('7eeec75d-9957-4d36-a8ac-006b9d4ffb39', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', 'Управление командой', 'Практический курс по современным методам управления. Только рабочие инструменты. Доступ навсегда.', 17206.58, '2025-09-05', NULL, 'published');
INSERT INTO public.courses VALUES ('eaf11106-bbf1-4b5a-8fc0-8b625ad6254c', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', 'SMM для бизнеса 2024', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 44066.18, '2026-01-24', NULL, 'published');
INSERT INTO public.courses VALUES ('2d3829b6-a24c-4d94-8b1b-9a3eb7c3a631', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', 'Управление командой', 'Практический курс по современным методам управления. Только рабочие инструменты. Доступ навсегда.', 24661.14, '2025-06-03', NULL, 'published');
INSERT INTO public.courses VALUES ('ee1a7c0c-7565-49ba-89ef-1cd66c87123e', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', 'Управление командой', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов.', 20011.43, '2025-06-14', NULL, 'archived');


--
-- TOC entry 5014 (class 0 OID 25074)
-- Dependencies: 225
-- Data for Name: purchased_courses; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.purchased_courses VALUES ('85ced628-d46e-416e-88ee-a71d2f6c74f2', '8a1743d9-d8b2-419e-9fa2-9d3190e8562d', 'a092b310-c25c-4ff9-9620-a966924916eb', '2026-05-03', '2027-05-03', 'active');
INSERT INTO public.purchased_courses VALUES ('39b4e763-3004-429e-b0d6-a3bd6841873b', 'dffd8773-f4f0-43a0-ab4d-b759a9f421b5', 'c17c7717-5766-4873-91f2-ff097b60167c', '2026-01-13', '2027-01-13', 'active');
INSERT INTO public.purchased_courses VALUES ('4cf4d0da-3f72-4915-8c30-a25151653384', 'dffd8773-f4f0-43a0-ab4d-b759a9f421b5', '2d3829b6-a24c-4d94-8b1b-9a3eb7c3a631', '2025-11-07', '2026-11-07', 'active');
INSERT INTO public.purchased_courses VALUES ('4e6b641a-f7c3-46e0-99cc-0dd44bd22e7d', '9014c974-8569-4f65-a9fe-38cac12e5f34', '0dcee391-2bc9-4439-8e8b-d7afb7c8e53e', '2026-03-23', '2027-03-23', 'active');
INSERT INTO public.purchased_courses VALUES ('71cf7236-a150-4882-b74d-f98062f53ba9', '9014c974-8569-4f65-a9fe-38cac12e5f34', '502bd0fa-6477-4259-a5a4-fe8da3a4d8c6', '2025-08-24', '2026-08-24', 'active');
INSERT INTO public.purchased_courses VALUES ('3292895c-13b9-468f-876b-c6aa8025bff6', '29525e9d-0979-4b60-aa79-81a6388253d2', 'ee1a7c0c-7565-49ba-89ef-1cd66c87123e', '2025-09-20', '2026-09-20', 'active');
INSERT INTO public.purchased_courses VALUES ('b5e87f77-5540-4bfa-8f20-d3428827cba6', '29525e9d-0979-4b60-aa79-81a6388253d2', 'd9d4b197-9d22-404a-8f3e-c1ec2a5e91f1', '2026-04-06', '2027-04-06', 'active');
INSERT INTO public.purchased_courses VALUES ('fa22f99d-2dd6-47d5-9add-ed591b2b196a', 'e02e7c9e-3a62-4f24-b451-bf4e6a107772', '59d11679-2a48-4372-a15a-13154cd3557d', '2026-02-01', '2027-02-01', 'active');
INSERT INTO public.purchased_courses VALUES ('3f6787c7-5a5d-4ae0-81d1-6c8f9d333b85', 'e02e7c9e-3a62-4f24-b451-bf4e6a107772', '5b7b495a-0c06-4f90-8635-c6958511d829', '2026-02-17', '2027-02-17', 'active');
INSERT INTO public.purchased_courses VALUES ('4d0401f5-de03-437f-b8ce-6aa6c73e40e2', 'e02e7c9e-3a62-4f24-b451-bf4e6a107772', '2d3829b6-a24c-4d94-8b1b-9a3eb7c3a631', '2026-04-05', '2027-04-05', 'active');
INSERT INTO public.purchased_courses VALUES ('fd6043c9-4920-4fb1-ab2f-f83537c2547d', 'd7e2fe70-8cf4-41ce-8bac-252223a8da58', 'a092b310-c25c-4ff9-9620-a966924916eb', '2025-11-19', '2026-11-19', 'active');
INSERT INTO public.purchased_courses VALUES ('4de6a1b4-0cca-4b61-a3eb-a1fb4f3c3aaa', '27ebd45b-a30e-4187-9a86-8599643dbc39', '9a65d469-d61c-4059-be28-56d91345973d', '2026-03-24', '2027-03-24', 'active');
INSERT INTO public.purchased_courses VALUES ('5afc479f-e4fe-47ab-93a4-af1e7278adb9', '27ebd45b-a30e-4187-9a86-8599643dbc39', 'f49ceefc-95d1-493d-8eb4-e5384641c09c', '2025-08-26', '2026-08-26', 'active');
INSERT INTO public.purchased_courses VALUES ('1a98aa1c-4257-4498-8b16-d72b062b3b58', '27ebd45b-a30e-4187-9a86-8599643dbc39', 'f49ceefc-95d1-493d-8eb4-e5384641c09c', '2026-01-21', '2027-01-21', 'active');
INSERT INTO public.purchased_courses VALUES ('3322de6f-3fe8-406d-9a16-a5008d364361', '1e42b90f-c81b-48cb-84a2-f013166ae6d9', '63eed6eb-74da-4fe8-a7ad-ac01a69bab9c', '2026-04-12', '2027-04-12', 'active');
INSERT INTO public.purchased_courses VALUES ('eff71e10-5a68-4a79-a300-fbbbb261e28a', '1e42b90f-c81b-48cb-84a2-f013166ae6d9', '63eed6eb-74da-4fe8-a7ad-ac01a69bab9c', '2025-05-25', '2026-05-25', 'active');
INSERT INTO public.purchased_courses VALUES ('7e080016-1286-4955-a2e3-27b4e5ff6fb9', '764b1b70-3f86-4bf9-b319-d1c54c85fbcd', 'c17c7717-5766-4873-91f2-ff097b60167c', '2025-03-24', '2026-03-24', 'expired');
INSERT INTO public.purchased_courses VALUES ('613415c4-eb18-4725-b300-ad062fc83bbc', '227aba69-4fb9-462c-ad73-18f5f50eda76', 'a092b310-c25c-4ff9-9620-a966924916eb', '2025-12-11', '2026-12-11', 'active');
INSERT INTO public.purchased_courses VALUES ('e51d33fa-3727-4da7-a225-b9618366df19', 'cee489f7-4c40-4ae3-9677-c1b06b2a19f8', '1c3a0c9c-0c16-43c7-ae3b-b702ded59709', '2025-10-17', '2026-10-17', 'active');
INSERT INTO public.purchased_courses VALUES ('5dbb3927-67d4-44d0-90a1-237411e486f0', '6deec448-f858-4f38-adcd-2bc549ac8c94', 'f3daa59f-3ea2-4cd4-a3f8-c574868d257b', '2026-04-23', '2027-04-23', 'active');
INSERT INTO public.purchased_courses VALUES ('90b38d09-713d-4c17-bcb6-e0bc5d1d9680', '61214456-60d4-40c6-8f3d-8c027c9508ce', '940c2c75-ef20-4875-96ff-2241ef5882ba', '2024-12-15', '2025-12-15', 'expired');
INSERT INTO public.purchased_courses VALUES ('a8062dee-14a2-4d13-99e2-c49962f0d10c', '5717db47-232f-41f6-88cc-7bb96027de15', '52a60d7d-9df4-4266-82e2-371213b8c5c0', '2024-11-25', '2025-11-25', 'expired');
INSERT INTO public.purchased_courses VALUES ('1aa5c578-e0e9-4519-9b17-a5dd0ac8b238', '5717db47-232f-41f6-88cc-7bb96027de15', '2d3829b6-a24c-4d94-8b1b-9a3eb7c3a631', '2025-08-16', '2026-08-16', 'active');
INSERT INTO public.purchased_courses VALUES ('d7b6863b-f52e-4506-8af6-0c72fb93a842', '5717db47-232f-41f6-88cc-7bb96027de15', 'd9d4b197-9d22-404a-8f3e-c1ec2a5e91f1', '2025-11-22', '2026-11-22', 'active');
INSERT INTO public.purchased_courses VALUES ('37614b93-a016-467d-bd45-5ccaa54d02ee', 'edd62666-5cde-4157-b012-733f6a6fadce', '1b906bc2-ae85-4091-a7e7-22615ebe7c5e', '2026-02-10', '2027-02-10', 'active');
INSERT INTO public.purchased_courses VALUES ('ce72a77e-b3d1-4c8e-948e-9875215024f2', '8a05a3b4-e0f0-46f4-b84b-9d2873ab4cb4', '502bd0fa-6477-4259-a5a4-fe8da3a4d8c6', '2026-01-17', '2027-01-17', 'active');
INSERT INTO public.purchased_courses VALUES ('55b55f9d-d068-4144-ad7e-2e68f8320cb3', '8a05a3b4-e0f0-46f4-b84b-9d2873ab4cb4', 'f3daa59f-3ea2-4cd4-a3f8-c574868d257b', '2025-12-04', '2026-12-04', 'active');
INSERT INTO public.purchased_courses VALUES ('da8a6074-cd03-450b-80aa-2b74a816de01', 'bb4a53e9-3e22-46e1-b20b-10c8847435ad', 'c17c7717-5766-4873-91f2-ff097b60167c', '2026-01-15', '2027-01-15', 'active');
INSERT INTO public.purchased_courses VALUES ('48fec336-dd0a-4d1c-8251-550f32fa8778', '56c50fa2-ea25-4330-89b3-a5c0c77ec289', '940c2c75-ef20-4875-96ff-2241ef5882ba', '2025-09-27', '2026-09-27', 'active');
INSERT INTO public.purchased_courses VALUES ('483133f8-ca58-4a76-9c6d-2507974d76bc', '36746652-9b70-40e4-b691-5b60fd28cee0', '4496ee09-31dc-43a6-a587-7b2e3d42dad8', '2026-04-30', '2027-04-30', 'active');
INSERT INTO public.purchased_courses VALUES ('b4c4b388-aff3-4fc6-b8e1-cbe982fb5f94', '36746652-9b70-40e4-b691-5b60fd28cee0', '65d9571a-365b-41a5-b3b7-efc625a01e37', '2026-04-28', '2027-04-28', 'active');
INSERT INTO public.purchased_courses VALUES ('230b09c6-ec9c-4180-8872-422c2eeacf74', '36746652-9b70-40e4-b691-5b60fd28cee0', 'f3daa59f-3ea2-4cd4-a3f8-c574868d257b', '2026-04-09', '2027-04-09', 'active');
INSERT INTO public.purchased_courses VALUES ('85c08abb-c693-4ba0-9d31-26b59ddf9a99', 'dd9e2228-2f05-427b-acb8-421f3860572f', 'f3daa59f-3ea2-4cd4-a3f8-c574868d257b', '2025-07-20', '2026-07-20', 'active');
INSERT INTO public.purchased_courses VALUES ('7ece4690-2efa-4880-9612-8cecdc942aac', 'dd9e2228-2f05-427b-acb8-421f3860572f', 'eaf11106-bbf1-4b5a-8fc0-8b625ad6254c', '2025-11-06', '2026-11-06', 'active');
INSERT INTO public.purchased_courses VALUES ('8cdeca98-3659-4de7-b314-48e95893df46', '5a5164e4-57b7-4ff3-889d-7cbee44a010e', '3f8a1462-322e-4aa3-a466-68fa16bdf47a', '2025-12-08', '2026-12-08', 'active');
INSERT INTO public.purchased_courses VALUES ('b1d04456-960d-4515-afaa-bc572754750a', '69d028ed-807f-4946-be09-d4985c44c241', '1b906bc2-ae85-4091-a7e7-22615ebe7c5e', '2026-04-27', '2027-04-27', 'active');
INSERT INTO public.purchased_courses VALUES ('2cb288ac-8be1-4fb1-84a6-26065c2152d6', '54e25d8d-dab3-49c4-b863-53621351924a', 'c17c7717-5766-4873-91f2-ff097b60167c', '2025-06-02', '2026-06-02', 'active');
INSERT INTO public.purchased_courses VALUES ('a5b33be5-8870-4062-9d18-8c73727246fa', '05afcd6a-1ad5-4311-8bf6-7139d634ee48', '59d11679-2a48-4372-a15a-13154cd3557d', '2025-04-02', '2026-04-02', 'expired');
INSERT INTO public.purchased_courses VALUES ('b94059bc-64a3-4929-8edb-08ac0dafd7cb', '05afcd6a-1ad5-4311-8bf6-7139d634ee48', '0dcee391-2bc9-4439-8e8b-d7afb7c8e53e', '2026-04-23', '2027-04-23', 'active');
INSERT INTO public.purchased_courses VALUES ('77ed399a-fe57-4108-b9a8-8701a683bdef', '4113404c-81b0-46a9-83ea-89ba7863b0aa', '502bd0fa-6477-4259-a5a4-fe8da3a4d8c6', '2025-12-17', '2026-12-17', 'active');
INSERT INTO public.purchased_courses VALUES ('c73b2c3d-605a-4296-a920-8adfce5afcdc', '4113404c-81b0-46a9-83ea-89ba7863b0aa', '1c3a0c9c-0c16-43c7-ae3b-b702ded59709', '2026-05-04', '2027-05-04', 'active');
INSERT INTO public.purchased_courses VALUES ('c6a145d9-46da-44c9-849f-71a0cda698ff', '050ce4dc-e30d-4d5c-b887-1306202c2b3e', '19bd6c99-2cfd-4986-9986-4935b90c17fa', '2025-06-19', '2026-06-19', 'active');
INSERT INTO public.purchased_courses VALUES ('4eccc7d4-39ae-4bf3-acbc-d73bda7c4667', '04d223ea-6797-49bd-8e05-0e0de94c5563', '63eed6eb-74da-4fe8-a7ad-ac01a69bab9c', '2024-09-07', '2025-09-07', 'expired');
INSERT INTO public.purchased_courses VALUES ('df94e5f0-8081-41e7-999c-42a9a5025f37', '04d223ea-6797-49bd-8e05-0e0de94c5563', '0909ea3b-f59e-4297-9b33-5b37130bb152', '2024-10-28', '2025-10-28', 'expired');
INSERT INTO public.purchased_courses VALUES ('eb16013b-5d3c-41b6-98f4-2932e4433fb5', '9f0b0f39-853f-4da8-9687-b9357d440d20', '2ee9e287-795c-4b62-bbad-70cb4d0ff748', '2026-02-01', '2027-02-01', 'active');
INSERT INTO public.purchased_courses VALUES ('33cee59c-db75-47ac-8c27-c2321a3f20aa', '9f0b0f39-853f-4da8-9687-b9357d440d20', 'eaf11106-bbf1-4b5a-8fc0-8b625ad6254c', '2026-02-05', '2027-02-05', 'active');
INSERT INTO public.purchased_courses VALUES ('7613e8da-0f4e-46e6-ad38-3577aefad1fe', '9f0b0f39-853f-4da8-9687-b9357d440d20', '4496ee09-31dc-43a6-a587-7b2e3d42dad8', '2026-03-31', '2027-03-31', 'active');
INSERT INTO public.purchased_courses VALUES ('1bbbcc2d-62ec-4007-a46c-18231123d9c9', 'fbfb3025-8aaf-47ed-b65b-cfedbadffcc5', 'f49ceefc-95d1-493d-8eb4-e5384641c09c', '2025-07-16', '2026-07-16', 'active');
INSERT INTO public.purchased_courses VALUES ('e2d99d9f-3042-4796-aeba-b0c90a70cbe0', 'fbfb3025-8aaf-47ed-b65b-cfedbadffcc5', 'bac90a60-c4fd-4814-adfd-a561386ae7f9', '2025-03-23', '2026-03-23', 'expired');
INSERT INTO public.purchased_courses VALUES ('b82e84ee-f3c5-40e3-a4fc-caa5e6365a49', 'fbfb3025-8aaf-47ed-b65b-cfedbadffcc5', 'a092b310-c25c-4ff9-9620-a966924916eb', '2025-03-31', '2026-03-31', 'expired');
INSERT INTO public.purchased_courses VALUES ('38b13c9c-2d99-4738-bae0-ee7c8ecae9f2', 'e68cd796-3311-4c5f-ba19-375f0c970472', 'f3daa59f-3ea2-4cd4-a3f8-c574868d257b', '2026-05-02', '2027-05-02', 'active');
INSERT INTO public.purchased_courses VALUES ('7b1d0a27-769c-4fc4-a138-05983a950e41', '519cbc73-b49c-47dc-8c6e-369322853020', '1c3a0c9c-0c16-43c7-ae3b-b702ded59709', '2026-03-29', '2027-03-29', 'active');
INSERT INTO public.purchased_courses VALUES ('7074f20c-2072-423b-a6de-ab6a97c9dcf9', '519cbc73-b49c-47dc-8c6e-369322853020', '7eeec75d-9957-4d36-a8ac-006b9d4ffb39', '2026-04-11', '2027-04-11', 'active');
INSERT INTO public.purchased_courses VALUES ('3e14a9b3-2531-4761-b52a-982d1e6db334', 'ce5886d8-7aa0-4991-a422-29edbab37a75', '2ee9e287-795c-4b62-bbad-70cb4d0ff748', '2026-02-22', '2027-02-22', 'active');
INSERT INTO public.purchased_courses VALUES ('dddfd87b-500d-457b-aaca-7ff60ac7a724', '6862b025-a58b-42f2-8fa4-e5bfab4abb07', '59d11679-2a48-4372-a15a-13154cd3557d', '2025-02-03', '2026-02-03', 'expired');
INSERT INTO public.purchased_courses VALUES ('46438033-17c0-4bef-b15d-ef0ca2091178', '6862b025-a58b-42f2-8fa4-e5bfab4abb07', '59d11679-2a48-4372-a15a-13154cd3557d', '2025-02-07', '2026-02-07', 'expired');
INSERT INTO public.purchased_courses VALUES ('8fc23ccc-90a8-4fe0-8d6e-cdb57f3daf99', '6862b025-a58b-42f2-8fa4-e5bfab4abb07', '46b29ac9-92c1-4d60-a863-789dbdd0b757', '2025-03-31', '2026-03-31', 'expired');
INSERT INTO public.purchased_courses VALUES ('bd4cb567-25f4-4ee0-945e-7767d1afb2b4', '0c54cece-e296-47fe-aea2-129343a57dce', '0909ea3b-f59e-4297-9b33-5b37130bb152', '2025-07-01', '2026-07-01', 'active');
INSERT INTO public.purchased_courses VALUES ('5f13defd-919b-499f-b0a5-a981ecef3534', '1ffc4454-7b78-4499-9f9f-dd1fb738879c', '940c2c75-ef20-4875-96ff-2241ef5882ba', '2026-03-21', '2027-03-21', 'active');
INSERT INTO public.purchased_courses VALUES ('f948cde8-9ecb-4eb4-b154-7435ffede787', 'fc2fff95-b416-4220-908b-31e45099635e', '1c3a0c9c-0c16-43c7-ae3b-b702ded59709', '2026-01-05', '2027-01-05', 'active');
INSERT INTO public.purchased_courses VALUES ('d7a4006b-ae07-4b54-9a1e-0e259281b044', 'fc2fff95-b416-4220-908b-31e45099635e', 'a092b310-c25c-4ff9-9620-a966924916eb', '2024-12-19', '2025-12-19', 'expired');
INSERT INTO public.purchased_courses VALUES ('ba23a387-3594-444a-a770-d5dcac49f3ef', '9b419dee-9aeb-4942-b66d-0b29b21361b3', '940c2c75-ef20-4875-96ff-2241ef5882ba', '2025-10-24', '2026-10-24', 'active');
INSERT INTO public.purchased_courses VALUES ('c4ceefd5-7806-480c-9780-43f50be9674f', '9b419dee-9aeb-4942-b66d-0b29b21361b3', '4496ee09-31dc-43a6-a587-7b2e3d42dad8', '2026-02-05', '2027-02-05', 'active');
INSERT INTO public.purchased_courses VALUES ('0aa25bf8-b611-4e81-a25f-757abbc8bd93', 'a833f183-973d-4b88-a2f1-d80022585c74', '46b29ac9-92c1-4d60-a863-789dbdd0b757', '2026-01-19', '2027-01-19', 'active');
INSERT INTO public.purchased_courses VALUES ('9482dcbb-2820-4595-8acc-109fbc5c3992', 'a833f183-973d-4b88-a2f1-d80022585c74', '2d3829b6-a24c-4d94-8b1b-9a3eb7c3a631', '2026-03-31', '2027-03-31', 'active');
INSERT INTO public.purchased_courses VALUES ('67da5ff2-8982-4c71-a9e6-18fbc598ab4a', 'cb30e94f-9889-4642-bd79-2fadad64209f', 'bac90a60-c4fd-4814-adfd-a561386ae7f9', '2026-02-24', '2027-02-24', 'active');
INSERT INTO public.purchased_courses VALUES ('f63bf5ea-4856-4a7f-9a4c-e0e7c535f6db', '236f2990-98cb-4f2d-9b66-48d8c66b50c1', '19bd6c99-2cfd-4986-9986-4935b90c17fa', '2025-10-26', '2026-10-26', 'active');
INSERT INTO public.purchased_courses VALUES ('8b2da6ac-8786-476f-afdc-ed35b1bbcc86', 'eb71afcf-4697-422f-83fc-6398f9de6a2e', 'eaf11106-bbf1-4b5a-8fc0-8b625ad6254c', '2026-04-22', '2027-04-22', 'active');
INSERT INTO public.purchased_courses VALUES ('6f5bb3c7-2b9d-4f95-aef3-09412bea97d8', 'eb71afcf-4697-422f-83fc-6398f9de6a2e', '3f8a1462-322e-4aa3-a466-68fa16bdf47a', '2026-04-25', '2027-04-25', 'active');
INSERT INTO public.purchased_courses VALUES ('14a52eee-9629-4087-aa12-bd6fd4529e4d', 'eb71afcf-4697-422f-83fc-6398f9de6a2e', '940c2c75-ef20-4875-96ff-2241ef5882ba', '2026-05-02', '2027-05-02', 'active');
INSERT INTO public.purchased_courses VALUES ('e106ceeb-8990-4305-a55c-3068a8ed14ce', 'eb71afcf-4697-422f-83fc-6398f9de6a2e', '5b7b495a-0c06-4f90-8635-c6958511d829', '2026-04-22', '2027-04-22', 'active');
INSERT INTO public.purchased_courses VALUES ('b502d50d-24f6-4d05-a4c4-5fc6675faf86', '9e67818e-1015-48b6-91fe-0f3e2a76054e', 'd9d4b197-9d22-404a-8f3e-c1ec2a5e91f1', '2025-05-25', '2026-05-25', 'active');
INSERT INTO public.purchased_courses VALUES ('54ed12f1-329f-4d80-9ae9-f37e7e176943', '9e67818e-1015-48b6-91fe-0f3e2a76054e', '63eed6eb-74da-4fe8-a7ad-ac01a69bab9c', '2025-07-09', '2026-07-09', 'active');
INSERT INTO public.purchased_courses VALUES ('8a006393-f5ef-4384-8e24-4402c391fbe4', '9879eed8-286a-498a-bac6-8f91bbf48bba', 'ffece5ef-9d37-4a84-93b9-a17a4e4ba2c2', '2026-05-05', '2027-05-05', 'active');


--
-- TOC entry 5011 (class 0 OID 25023)
-- Dependencies: 222
-- Data for Name: service_bookings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.service_bookings VALUES ('1087d531-b9f0-4fba-8db4-a194888b7be3', '2008d077-82f6-494c-9c59-ab5251c68a53', '8a1743d9-d8b2-419e-9fa2-9d3190e8562d', '2026-06-04 04:06:20.400269', '2026-06-04 05:06:20.400269', 'создано');
INSERT INTO public.service_bookings VALUES ('db0ac34d-8521-4afc-a6b5-7d7cfa2523cf', '9af34294-5370-4d17-9b09-f0ec550fdfcb', '29525e9d-0979-4b60-aa79-81a6388253d2', '2025-09-14 13:39:52.056883', '2025-09-14 14:39:52.056883', 'завершено');
INSERT INTO public.service_bookings VALUES ('32042c9f-9f08-4ef6-9ef6-04835496c720', '3ad1ce20-4213-47dc-970e-e3ca53d120e2', '55617455-aa81-4a19-b876-21b9c3c07966', '2026-02-12 06:52:27.024582', '2026-02-12 07:52:27.024582', 'завершено');
INSERT INTO public.service_bookings VALUES ('05b64f09-42d9-4209-9ba7-ba66d3becf38', 'af7631bf-5f76-4722-90fe-a564aef80f6e', '55617455-aa81-4a19-b876-21b9c3c07966', '2026-03-10 01:47:22.259505', '2026-03-10 02:47:22.259505', 'отменено');
INSERT INTO public.service_bookings VALUES ('aa213c24-7bbd-4c6a-9b6c-85ed7fdf831b', '3ad1ce20-4213-47dc-970e-e3ca53d120e2', '27ebd45b-a30e-4187-9a86-8599643dbc39', '2024-06-21 04:49:32.073057', '2024-06-21 05:49:32.073057', 'отменено');
INSERT INTO public.service_bookings VALUES ('fe7c9900-3c56-4458-b0ff-558a4b0654e0', '1d954e15-47df-4d82-9681-3832748878a9', '27ebd45b-a30e-4187-9a86-8599643dbc39', '2026-05-11 09:56:40.122059', '2026-05-11 10:56:40.122059', 'создано');
INSERT INTO public.service_bookings VALUES ('e7cd6a11-f503-4b52-b62f-5e40f74ceec3', '1d954e15-47df-4d82-9681-3832748878a9', '227aba69-4fb9-462c-ad73-18f5f50eda76', '2025-12-24 09:59:26.031531', '2025-12-24 10:59:26.031531', 'завершено');
INSERT INTO public.service_bookings VALUES ('22555f12-f067-40f0-b0c6-d0aa1ddaf96c', 'f33ed11d-5efa-41e8-bbf6-2d0c1031f131', '227aba69-4fb9-462c-ad73-18f5f50eda76', '2025-10-13 02:38:35.2461', '2025-10-13 03:38:35.2461', 'отменено');
INSERT INTO public.service_bookings VALUES ('96737a80-02e1-4169-967d-a8417bada2ec', '9af34294-5370-4d17-9b09-f0ec550fdfcb', '61214456-60d4-40c6-8f3d-8c027c9508ce', '2025-07-10 01:50:25.315129', '2025-07-10 02:50:25.315129', 'завершено');
INSERT INTO public.service_bookings VALUES ('fc824156-0b9b-4315-b666-96a9cd05eb8b', '80bfcd5e-1a7e-451c-b275-76930405a265', '5717db47-232f-41f6-88cc-7bb96027de15', '2025-05-16 18:47:24.932858', '2025-05-16 19:47:24.932858', 'завершено');
INSERT INTO public.service_bookings VALUES ('46e6eda4-f702-4afa-b8f7-124d013a07e3', '5b4d720d-8a57-4721-95e8-e6e2bdef4102', '5717db47-232f-41f6-88cc-7bb96027de15', '2025-10-11 05:04:25.661871', '2025-10-11 06:04:25.661871', 'отменено');
INSERT INTO public.service_bookings VALUES ('9a184893-33ca-4786-b804-473ea13f59e1', 'c694dbb1-9268-43a7-8cf5-8d18720d9fa8', '5717db47-232f-41f6-88cc-7bb96027de15', '2024-12-24 08:30:52.182285', '2024-12-24 09:30:52.182285', 'отменено');
INSERT INTO public.service_bookings VALUES ('5ac9245d-3d59-4841-b2f4-fb33a8d0b206', 'c8bb5df8-f3e4-42dc-8dfa-a43daaa9925f', 'edd62666-5cde-4157-b012-733f6a6fadce', '2026-02-09 17:32:14.719315', '2026-02-09 18:32:14.719315', 'отменено');
INSERT INTO public.service_bookings VALUES ('4395c0b9-b95c-4573-a251-5cc27476474f', 'a9ced920-780e-4682-96c3-a2f8e68a25c1', 'edd62666-5cde-4157-b012-733f6a6fadce', '2026-01-26 15:54:16.81886', '2026-01-26 16:54:16.81886', 'отменено');
INSERT INTO public.service_bookings VALUES ('22a8902a-84b1-4ac0-9241-4014b5f7c12a', '0b04a18e-f2da-4cfb-aeeb-40ab285d36ae', '8a05a3b4-e0f0-46f4-b84b-9d2873ab4cb4', '2026-03-06 21:53:10.037688', '2026-03-06 22:53:10.037688', 'завершено');
INSERT INTO public.service_bookings VALUES ('f8ce08e1-9a4a-4609-8694-ebeb61f3c3fa', '15fb1219-b2ba-4a3c-9876-f59390460ffc', 'bb4a53e9-3e22-46e1-b20b-10c8847435ad', '2026-02-14 05:19:27.273738', '2026-02-14 06:19:27.273738', 'отменено');
INSERT INTO public.service_bookings VALUES ('47be21a2-172a-4956-8223-b2cb2f85eb03', '350509d5-1403-4e0c-a12d-9f6512c48959', 'bb4a53e9-3e22-46e1-b20b-10c8847435ad', '2026-05-15 08:45:02.971525', '2026-05-15 09:45:02.971525', 'создано');
INSERT INTO public.service_bookings VALUES ('b6e2f1f9-9432-4bad-bbac-e447aad97875', 'a370ad97-788b-4fb9-8f0b-dc88506a237b', '38f03b0a-bb5e-49f3-9fc6-4d1910f74989', '2026-03-22 04:07:47.807559', '2026-03-22 05:07:47.807559', 'завершено');
INSERT INTO public.service_bookings VALUES ('6660ac26-863c-4ed8-9020-d0d6ae41108e', '0ad041eb-bad2-44ef-8d47-cfa8e5165196', '56c50fa2-ea25-4330-89b3-a5c0c77ec289', '2025-11-13 17:29:52.823159', '2025-11-13 18:29:52.823159', 'завершено');
INSERT INTO public.service_bookings VALUES ('ac6596e9-144f-496b-bcce-3047e6d05d47', 'a65c4917-a962-47ba-9692-e654177c4388', '36746652-9b70-40e4-b691-5b60fd28cee0', '2026-04-06 20:48:09.789765', '2026-04-06 21:48:09.789765', 'завершено');
INSERT INTO public.service_bookings VALUES ('aa7921f5-b0d3-4f29-b493-edb814e91a9c', '3ede3b53-72ff-4512-82cd-af8ce7b204be', '69d028ed-807f-4946-be09-d4985c44c241', '2025-06-14 01:18:57.707635', '2025-06-14 02:18:57.707635', 'отменено');
INSERT INTO public.service_bookings VALUES ('05c9b9b3-8a58-42da-b655-966e6aeb70d7', '350509d5-1403-4e0c-a12d-9f6512c48959', '54e25d8d-dab3-49c4-b863-53621351924a', '2025-07-07 12:14:54.450674', '2025-07-07 13:14:54.450674', 'завершено');
INSERT INTO public.service_bookings VALUES ('3f571ec0-7033-4515-ab00-c4738409a32d', '123688f1-5265-478d-8f35-c5866d42fcdc', '05afcd6a-1ad5-4311-8bf6-7139d634ee48', '2026-05-17 16:46:45.928971', '2026-05-17 17:46:45.928971', 'подтверждено');
INSERT INTO public.service_bookings VALUES ('41d504f0-5a19-4e2a-8810-0a551b4d047e', 'a65c4917-a962-47ba-9692-e654177c4388', '05afcd6a-1ad5-4311-8bf6-7139d634ee48', '2024-10-26 07:59:24.278008', '2024-10-26 08:59:24.278008', 'завершено');
INSERT INTO public.service_bookings VALUES ('4f327c08-298c-478c-a1bb-d5e03ebb2ff2', '0b04a18e-f2da-4cfb-aeeb-40ab285d36ae', '4113404c-81b0-46a9-83ea-89ba7863b0aa', '2025-04-19 12:55:16.477043', '2025-04-19 13:55:16.477043', 'завершено');
INSERT INTO public.service_bookings VALUES ('a234c8c5-9cf9-431e-8b50-60686bf794c5', 'de82bd12-1b3a-4e99-ac12-71cc713f041c', '4113404c-81b0-46a9-83ea-89ba7863b0aa', '2026-02-12 23:22:58.743916', '2026-02-13 00:22:58.743916', 'завершено');
INSERT INTO public.service_bookings VALUES ('2a472d3e-b280-425d-ba5a-41079083a86d', 'a370ad97-788b-4fb9-8f0b-dc88506a237b', '04d223ea-6797-49bd-8e05-0e0de94c5563', '2024-12-19 04:17:02.130512', '2024-12-19 05:17:02.130512', 'завершено');
INSERT INTO public.service_bookings VALUES ('047082e6-13f1-4826-af28-d0daa9904ec8', '2900cece-8809-471c-9b05-9d9f82051bdc', '9f0b0f39-853f-4da8-9687-b9357d440d20', '2026-05-19 14:34:17.556461', '2026-05-19 15:34:17.556461', 'подтверждено');
INSERT INTO public.service_bookings VALUES ('4d0bd085-a891-4f3b-bb7e-41f41f59bc13', 'cf30ae16-e60b-4cbf-9bfe-7b2afaff3ade', '9f0b0f39-853f-4da8-9687-b9357d440d20', '2026-04-22 17:02:21.82074', '2026-04-22 18:02:21.82074', 'отменено');
INSERT INTO public.service_bookings VALUES ('d782e57c-76ba-45ae-a9b9-fa32f82a8d4b', '15fb1219-b2ba-4a3c-9876-f59390460ffc', '5cbfb257-6e90-49d2-b424-0eb6d87c94ef', '2025-09-02 00:05:00.810014', '2025-09-02 01:05:00.810014', 'завершено');
INSERT INTO public.service_bookings VALUES ('b8ce01d8-6be5-4b7b-a649-949c3d0c9f02', 'ab80e721-b57f-4cd8-99c5-d44cdd56e34c', '5cbfb257-6e90-49d2-b424-0eb6d87c94ef', '2026-01-03 06:52:21.176545', '2026-01-03 07:52:21.176545', 'отменено');
INSERT INTO public.service_bookings VALUES ('0ff93f3a-1af6-4477-bf30-d4c9466ad71d', 'c187ba36-7781-4b31-acc2-984a668d1df0', 'e68cd796-3311-4c5f-ba19-375f0c970472', '2026-03-31 11:13:38.136274', '2026-03-31 12:13:38.136274', 'завершено');
INSERT INTO public.service_bookings VALUES ('1de6bcaf-fbdc-4886-bb33-b76872fde5fc', '61d9e6d7-5fc7-4a6b-ba49-8ccc8111252b', 'e68cd796-3311-4c5f-ba19-375f0c970472', '2026-02-21 10:56:40.653388', '2026-02-21 11:56:40.653388', 'отменено');
INSERT INTO public.service_bookings VALUES ('f384c17b-f31d-43a9-8e15-0b1b63e84075', '25197915-9332-4516-97bc-b26a9bc03ba1', '519cbc73-b49c-47dc-8c6e-369322853020', '2026-05-18 01:45:01.323228', '2026-05-18 02:45:01.323228', 'подтверждено');
INSERT INTO public.service_bookings VALUES ('1c51da20-d9d9-4e09-b569-92525baf293e', '9ac57164-dc0b-44c5-852a-8f51691f7e44', '519cbc73-b49c-47dc-8c6e-369322853020', '2026-04-21 04:42:36.354498', '2026-04-21 05:42:36.354498', 'отменено');
INSERT INTO public.service_bookings VALUES ('da08e877-4ba1-4eea-bd11-8b6cf8a47b3e', '0e7a8c72-5fae-4f11-8bbf-83a7ae6ef156', '4af05f5c-988b-4660-a84e-a869955f66ef', '2026-05-09 20:31:57.135303', '2026-05-09 21:31:57.135303', 'подтверждено');
INSERT INTO public.service_bookings VALUES ('ff3eefd4-0e41-4820-b0d9-73871892e0f7', 'cda12fd2-602a-4c84-89fb-e009dec9a7c5', '4af05f5c-988b-4660-a84e-a869955f66ef', '2025-09-29 16:22:10.95423', '2025-09-29 17:22:10.95423', 'отменено');
INSERT INTO public.service_bookings VALUES ('a1a48ac2-5891-4e3f-9f06-9b606bd9f1b7', 'de82bd12-1b3a-4e99-ac12-71cc713f041c', 'ce5886d8-7aa0-4991-a422-29edbab37a75', '2025-03-02 03:18:42.141257', '2025-03-02 04:18:42.141257', 'завершено');
INSERT INTO public.service_bookings VALUES ('8650afa9-3a58-4f5b-a92c-68ca04459087', 'ad39b699-1bfd-4e98-963d-06f04a908357', 'ce5886d8-7aa0-4991-a422-29edbab37a75', '2026-02-04 00:20:15.13474', '2026-02-04 01:20:15.13474', 'отменено');
INSERT INTO public.service_bookings VALUES ('71fd5584-233d-488f-b239-2d780fab9004', '2337ae54-f86b-4b7b-8df4-c12f88828e1d', '6862b025-a58b-42f2-8fa4-e5bfab4abb07', '2025-12-21 19:27:06.211602', '2025-12-21 20:27:06.211602', 'завершено');
INSERT INTO public.service_bookings VALUES ('857996e4-0e98-44e1-bdcb-66268103ed13', 'c694dbb1-9268-43a7-8cf5-8d18720d9fa8', '6862b025-a58b-42f2-8fa4-e5bfab4abb07', '2026-03-01 23:20:40.987448', '2026-03-02 00:20:40.987448', 'отменено');
INSERT INTO public.service_bookings VALUES ('193f51b3-5d83-4075-aaeb-5d75c7a9b664', '658ed569-36b0-4247-a7cd-03a5e78261d0', '1ffc4454-7b78-4499-9f9f-dd1fb738879c', '2026-05-17 03:25:00.13593', '2026-05-17 04:25:00.13593', 'создано');
INSERT INTO public.service_bookings VALUES ('44023cb4-9617-4a89-99a3-c3235a55259c', 'c8bb5df8-f3e4-42dc-8dfa-a43daaa9925f', 'a833f183-973d-4b88-a2f1-d80022585c74', '2026-02-13 08:43:24.50195', '2026-02-13 09:43:24.50195', 'завершено');
INSERT INTO public.service_bookings VALUES ('302c2584-db42-4af0-8c5f-8c2d078cf1e3', '384ea40c-13d6-4460-8763-318591f77fc9', 'cb30e94f-9889-4642-bd79-2fadad64209f', '2026-03-30 21:10:38.691341', '2026-03-30 22:10:38.691341', 'отменено');
INSERT INTO public.service_bookings VALUES ('a688bd4f-d792-4d4d-819f-180baae46a59', '2008d077-82f6-494c-9c59-ab5251c68a53', 'cb30e94f-9889-4642-bd79-2fadad64209f', '2026-05-26 17:44:33.575312', '2026-05-26 18:44:33.575312', 'создано');
INSERT INTO public.service_bookings VALUES ('855906e2-037a-444e-b6bc-5500f04e201e', 'f98aa21d-1923-4658-9273-522cf637f043', 'cb30e94f-9889-4642-bd79-2fadad64209f', '2026-02-28 01:59:08.765453', '2026-02-28 02:59:08.765453', 'завершено');
INSERT INTO public.service_bookings VALUES ('2088b905-da38-45b4-b43a-7afcbf8dfcb3', '53c2ac7a-9de8-4557-92d7-6e18e448d084', '236f2990-98cb-4f2d-9b66-48d8c66b50c1', '2026-04-12 14:35:52.931007', '2026-04-12 15:35:52.931007', 'завершено');
INSERT INTO public.service_bookings VALUES ('fd4104b8-c525-46f9-b543-4595b9d8bcea', '123688f1-5265-478d-8f35-c5866d42fcdc', '236f2990-98cb-4f2d-9b66-48d8c66b50c1', '2026-03-19 02:57:50.517023', '2026-03-19 03:57:50.517023', 'отменено');
INSERT INTO public.service_bookings VALUES ('9291fcc7-7385-4081-8ddb-b10448fdbf53', '0e7a8c72-5fae-4f11-8bbf-83a7ae6ef156', 'eb71afcf-4697-422f-83fc-6398f9de6a2e', '2026-04-18 06:59:01.890038', '2026-04-18 07:59:01.890038', 'завершено');
INSERT INTO public.service_bookings VALUES ('cdb61c80-057e-46b9-834f-6fa6dc5c78de', '2008d077-82f6-494c-9c59-ab5251c68a53', '9e67818e-1015-48b6-91fe-0f3e2a76054e', '2026-04-01 12:09:43.462335', '2026-04-01 13:09:43.462335', 'завершено');
INSERT INTO public.service_bookings VALUES ('e8c7b2b2-45f2-4663-bef1-7380c10a0882', '9a444534-769b-4efc-a176-e14092345b0d', '9c43afd4-020a-4815-adfc-49909da3c895', '2026-04-18 14:09:29.960077', '2026-04-18 15:09:29.960077', 'отменено');
INSERT INTO public.service_bookings VALUES ('3e6db98c-48d5-468e-a463-688f47fc7ba8', '97c99327-5f39-4585-94b4-2a4d7372f698', '9c43afd4-020a-4815-adfc-49909da3c895', '2026-04-05 07:53:19.375473', '2026-04-05 08:53:19.375473', 'отменено');
INSERT INTO public.service_bookings VALUES ('8aa09516-8e1d-4781-9827-6fd732efbeb3', '9af34294-5370-4d17-9b09-f0ec550fdfcb', '9879eed8-286a-498a-bac6-8f91bbf48bba', '2026-04-06 21:28:46.843129', '2026-04-06 22:28:46.843129', 'завершено');


--
-- TOC entry 5012 (class 0 OID 25041)
-- Dependencies: 223
-- Data for Name: service_reviews; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.service_reviews VALUES ('83858be5-a947-4728-943f-bcf2fec5187e', 'db0ac34d-8521-4afc-a6b5-7d7cfa2523cf', 4, 'Спасибо, всё четко и по делу.', '2025-09-19');
INSERT INTO public.service_reviews VALUES ('925f675c-16b2-437e-95b0-6ced6fa2a06c', '32042c9f-9f08-4ef6-9ef6-04835496c720', 3, 'Материал хороший, но подача немного сухая.', '2026-02-16');
INSERT INTO public.service_reviews VALUES ('f889e630-9ca9-4cba-bf48-811423e5d961', '05b64f09-42d9-4209-9ba7-ba66d3becf38', 4, 'Профессионал своего дела, рекомендую.', '2026-03-14');
INSERT INTO public.service_reviews VALUES ('4dccfd68-7a89-4f24-bc81-1d4c03d566f3', 'aa213c24-7bbd-4c6a-9b6c-85ed7fdf831b', 5, 'Лучшая инвестиция в мой бизнес!', '2024-06-26');
INSERT INTO public.service_reviews VALUES ('49b90700-9048-44e9-80c3-970b7d864270', '22555f12-f067-40f0-b0c6-d0aa1ddaf96c', 4, 'Отличный материал, очень помогло!', '2025-10-15');
INSERT INTO public.service_reviews VALUES ('60ab2d44-e72b-4447-9ada-971e53e20c09', '96737a80-02e1-4169-967d-a8417bada2ec', 1, 'Зря потратил время и деньги.', '2025-07-11');
INSERT INTO public.service_reviews VALUES ('b3c532ad-f500-4386-bc66-07825bfcb53d', 'fc824156-0b9b-4315-b666-96a9cd05eb8b', 5, 'Лучшая инвестиция в мой бизнес!', '2025-05-18');
INSERT INTO public.service_reviews VALUES ('9aac1e8c-3424-4609-b7e8-c6c53b1b0a6e', '46e6eda4-f702-4afa-b8f7-124d013a07e3', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2025-10-15');
INSERT INTO public.service_reviews VALUES ('45442dd3-43c9-4d74-99ca-889e4d7a33a4', '5ac9245d-3d59-4841-b2f4-fb33a8d0b206', 2, 'Много воды, хотелось бы больше практики.', '2026-02-10');
INSERT INTO public.service_reviews VALUES ('6ae8cd25-ec79-45de-8d02-dec6b1a8ea3c', '4395c0b9-b95c-4573-a251-5cc27476474f', 1, 'Много воды, хотелось бы больше практики.', '2026-01-31');
INSERT INTO public.service_reviews VALUES ('8c789fd4-6009-4b37-9b6f-7b344bfa6c09', '22a8902a-84b1-4ac0-9241-4014b5f7c12a', 5, 'Спасибо, всё четко и по делу.', '2026-03-08');
INSERT INTO public.service_reviews VALUES ('63597751-0d91-447d-a4d7-ccf749223747', 'f8ce08e1-9a4a-4609-8694-ebeb61f3c3fa', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2026-02-19');
INSERT INTO public.service_reviews VALUES ('388bb0b8-a844-4f8d-82a6-f2f01d6f6d06', '6660ac26-863c-4ed8-9020-d0d6ae41108e', 2, 'Зря потратил время и деньги.', '2025-11-17');
INSERT INTO public.service_reviews VALUES ('67300c15-b920-4620-a72d-e43e3082e581', 'ac6596e9-144f-496b-bcce-3047e6d05d47', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2026-04-09');
INSERT INTO public.service_reviews VALUES ('016bf267-6751-40d5-807f-ba4ffefa3961', '41d504f0-5a19-4e2a-8810-0a551b4d047e', 5, 'Лучшая инвестиция в мой бизнес!', '2024-10-30');
INSERT INTO public.service_reviews VALUES ('7bba1cb6-c0bd-489c-830a-eaf27a03608c', '4f327c08-298c-478c-a1bb-d5e03ebb2ff2', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2025-04-21');
INSERT INTO public.service_reviews VALUES ('70757970-bf8d-4261-a2af-f4dcf0f46464', 'a234c8c5-9cf9-431e-8b50-60686bf794c5', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2026-02-16');
INSERT INTO public.service_reviews VALUES ('370b85a4-1804-41fa-95d8-9b8ba031000a', '2a472d3e-b280-425d-ba5a-41079083a86d', 2, 'Много воды, хотелось бы больше практики.', '2024-12-23');
INSERT INTO public.service_reviews VALUES ('c2757f06-9a9d-4354-a140-b043bc2e2f05', '4d0bd085-a891-4f3b-bb7e-41f41f59bc13', 4, 'Спасибо, всё четко и по делу.', '2026-04-24');
INSERT INTO public.service_reviews VALUES ('ea93edcf-b1d5-4f32-8762-c163f58bc72d', 'b8ce01d8-6be5-4b7b-a649-949c3d0c9f02', 5, 'Спасибо, всё четко и по делу.', '2026-01-04');
INSERT INTO public.service_reviews VALUES ('ae9f5a6b-74d8-4642-95c3-a476e44153aa', '0ff93f3a-1af6-4477-bf30-d4c9466ad71d', 3, 'Цена полностью оправдывает качество.', '2026-04-02');
INSERT INTO public.service_reviews VALUES ('ada27d70-5c54-4654-9288-ccfdf6686c1d', '1c51da20-d9d9-4e09-b569-92525baf293e', 5, 'Спасибо, всё четко и по делу.', '2026-04-25');
INSERT INTO public.service_reviews VALUES ('16ea559b-d460-495b-bc6a-7540b054bbd9', 'ff3eefd4-0e41-4820-b0d9-73871892e0f7', 5, 'Профессионал своего дела, рекомендую.', '2025-10-01');
INSERT INTO public.service_reviews VALUES ('bf6a6eae-8175-40e7-beb1-8b21b1949893', 'a1a48ac2-5891-4e3f-9f06-9b606bd9f1b7', 4, 'Лучшая инвестиция в мой бизнес!', '2025-03-04');
INSERT INTO public.service_reviews VALUES ('9d328391-63a6-4abc-a76e-a6be848d32a3', '8650afa9-3a58-4f5b-a92c-68ca04459087', 5, 'Профессионал своего дела, рекомендую.', '2026-02-09');
INSERT INTO public.service_reviews VALUES ('45f53ac2-1450-43ef-ba48-de11ea214437', '71fd5584-233d-488f-b239-2d780fab9004', 3, 'Материал хороший, но подача немного сухая.', '2025-12-22');
INSERT INTO public.service_reviews VALUES ('fe78c136-bc8a-4e2d-a669-cc26bba02408', '857996e4-0e98-44e1-bdcb-66268103ed13', 1, 'Зря потратил время и деньги.', '2026-03-05');
INSERT INTO public.service_reviews VALUES ('1134ca15-d3d6-4501-a431-4736fca08803', '44023cb4-9617-4a89-99a3-c3235a55259c', 1, 'Много воды, хотелось бы больше практики.', '2026-02-18');
INSERT INTO public.service_reviews VALUES ('2fab7fe2-d15c-4cad-8207-d6eff832a255', '855906e2-037a-444e-b6bc-5500f04e201e', 3, 'Цена полностью оправдывает качество.', '2026-03-01');
INSERT INTO public.service_reviews VALUES ('c5f5ab85-aef6-4751-9f7c-65644ccd6848', '2088b905-da38-45b4-b43a-7afcbf8dfcb3', 2, 'Зря потратил время и деньги.', '2026-04-15');
INSERT INTO public.service_reviews VALUES ('944a5165-9c9b-4092-b3cc-045c11863684', 'fd4104b8-c525-46f9-b543-4595b9d8bcea', 1, 'Зря потратил время и деньги.', '2026-03-24');
INSERT INTO public.service_reviews VALUES ('ef18a2b4-5f96-4391-8419-2ff89521d9cb', '9291fcc7-7385-4081-8ddb-b10448fdbf53', 1, 'Много воды, хотелось бы больше практики.', '2026-04-21');
INSERT INTO public.service_reviews VALUES ('497a17c5-ac44-4873-9060-70c64e222b93', 'e8c7b2b2-45f2-4663-bef1-7380c10a0882', 2, 'Много воды, хотелось бы больше практики.', '2026-04-20');
INSERT INTO public.service_reviews VALUES ('c9c864c7-655f-4957-b4f3-df821ae0eb5c', '3e6db98c-48d5-468e-a463-688f47fc7ba8', 5, 'Полный восторг, превзошло все ожидания!', '2026-04-06');


--
-- TOC entry 5009 (class 0 OID 24995)
-- Dependencies: 220
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.services VALUES ('123688f1-5265-478d-8f35-c5866d42fcdc', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', 'Анализ конкурентов', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 90, 5558.18);
INSERT INTO public.services VALUES ('af7631bf-5f76-4722-90fe-a564aef80f6e', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', 'Оптимизация логистики', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 45, 3400.36);
INSERT INTO public.services VALUES ('a65c4917-a962-47ba-9692-e654177c4388', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', 'Построение отдела продаж', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 180, 17526.97);
INSERT INTO public.services VALUES ('fee37b65-d9c8-4fec-b90b-f8afa54c59f8', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', 'Построение отдела продаж', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 90, 5694.00);
INSERT INTO public.services VALUES ('1d954e15-47df-4d82-9681-3832748878a9', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', 'Разработка бизнес-плана', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 150, 13855.79);
INSERT INTO public.services VALUES ('c694dbb1-9268-43a7-8cf5-8d18720d9fa8', '9e2538b1-105a-41e5-93b5-958545f78e43', 'HR-стратегия и найм', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 45, 19602.68);
INSERT INTO public.services VALUES ('53c2ac7a-9de8-4557-92d7-6e18e448d084', '9e2538b1-105a-41e5-93b5-958545f78e43', 'Оптимизация логистики', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 90, 18692.74);
INSERT INTO public.services VALUES ('0e7a8c72-5fae-4f11-8bbf-83a7ae6ef156', '455d3a9e-0b1c-43f1-91ae-97904ec21f35', 'Консультация по налогам', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим план по увеличению выручки.', 60, 19657.89);
INSERT INTO public.services VALUES ('47bfe791-5dfe-4f70-bba6-79b00a1e5588', '2b122c6b-e3d8-4b39-b165-aa8b61834322', 'Консультация по налогам', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим план по увеличению выручки.', 45, 10332.09);
INSERT INTO public.services VALUES ('9af34294-5370-4d17-9b09-f0ec550fdfcb', '8bdb45be-5e06-4224-904e-ca10724599f0', 'Разработка бизнес-плана', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 45, 14938.72);
INSERT INTO public.services VALUES ('15fb1219-b2ba-4a3c-9876-f59390460ffc', '8bdb45be-5e06-4224-904e-ca10724599f0', 'HR-стратегия и найм', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 45, 10292.50);
INSERT INTO public.services VALUES ('350509d5-1403-4e0c-a12d-9f6512c48959', '035c6559-1715-4f72-91a1-9b8ec53abb80', 'Разработка бизнес-плана', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 120, 12491.93);
INSERT INTO public.services VALUES ('2900cece-8809-471c-9b05-9d9f82051bdc', '43326f8a-d949-430c-aea3-735d47979c13', 'Разработка бизнес-плана', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим план по увеличению выручки.', 45, 11189.35);
INSERT INTO public.services VALUES ('faf1540a-cead-4809-96e6-65e2344219b0', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', 'Оптимизация логистики', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим план по увеличению выручки.', 150, 19189.64);
INSERT INTO public.services VALUES ('2a76aea4-9ef4-4024-a6f8-ee02515ba359', '2b122c6b-e3d8-4b39-b165-aa8b61834322', 'Анализ конкурентов', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим план по увеличению выручки.', 30, 15876.01);
INSERT INTO public.services VALUES ('5b4d720d-8a57-4721-95e8-e6e2bdef4102', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', 'Построение отдела продаж', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 60, 15346.31);
INSERT INTO public.services VALUES ('5a321b36-6dd7-454b-9e19-7648fbcfe92d', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'Консультация по налогам', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 30, 12997.89);
INSERT INTO public.services VALUES ('ab80e721-b57f-4cd8-99c5-d44cdd56e34c', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', 'Оптимизация логистики', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 150, 15003.60);
INSERT INTO public.services VALUES ('9a444534-769b-4efc-a176-e14092345b0d', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', 'Разработка бизнес-плана', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 45, 1956.14);
INSERT INTO public.services VALUES ('1d5bbcbc-7d0b-439f-86e9-2ba158868f76', 'ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', 'Консультация по налогам', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 45, 6967.61);
INSERT INTO public.services VALUES ('cf30ae16-e60b-4cbf-9bfe-7b2afaff3ade', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', 'Анализ конкурентов', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 120, 4935.01);
INSERT INTO public.services VALUES ('2008d077-82f6-494c-9c59-ab5251c68a53', '2521227e-be29-4c74-b38b-29c6a5741457', 'Построение отдела продаж', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 60, 19976.85);
INSERT INTO public.services VALUES ('a9ced920-780e-4682-96c3-a2f8e68a25c1', '43326f8a-d949-430c-aea3-735d47979c13', 'Консультация по налогам', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 30, 9648.73);
INSERT INTO public.services VALUES ('f98aa21d-1923-4658-9273-522cf637f043', '09697d5c-94af-460c-a1bb-de10bc92f737', 'Внедрение CRM', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 180, 7717.97);
INSERT INTO public.services VALUES ('0ad041eb-bad2-44ef-8d47-cfa8e5165196', '2521227e-be29-4c74-b38b-29c6a5741457', 'Разбор фин. модели', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 120, 13999.01);
INSERT INTO public.services VALUES ('039bb914-b310-4b2d-b430-d5af05d55526', 'df5bc45a-5a71-4988-89c5-cfc8704a0a07', 'Аудит маркетинговой стратегии', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 30, 6042.97);
INSERT INTO public.services VALUES ('af3aa745-453f-4998-9360-5c0b9ff229fa', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', 'HR-стратегия и найм', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 60, 17093.52);
INSERT INTO public.services VALUES ('658ed569-36b0-4247-a7cd-03a5e78261d0', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', 'Разбор фин. модели', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 150, 2279.76);
INSERT INTO public.services VALUES ('0b04a18e-f2da-4cfb-aeeb-40ab285d36ae', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', 'Построение отдела продаж', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 60, 19398.94);
INSERT INTO public.services VALUES ('6066bdef-af10-492d-8846-c1ffb137074e', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', 'Разработка бизнес-плана', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 120, 5563.64);
INSERT INTO public.services VALUES ('ceb86536-7d65-46c5-b5a6-17ea48285b8d', 'b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', 'HR-стратегия и найм', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 150, 4612.49);
INSERT INTO public.services VALUES ('c187ba36-7781-4b31-acc2-984a668d1df0', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', 'Разработка бизнес-плана', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим план по увеличению выручки.', 45, 12531.56);
INSERT INTO public.services VALUES ('c8bb5df8-f3e4-42dc-8dfa-a43daaa9925f', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', 'Анализ конкурентов', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 90, 12870.27);
INSERT INTO public.services VALUES ('2e8cc8c8-ec54-45bd-a3aa-5970a45bd965', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', 'Разработка бизнес-плана', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 180, 7077.60);
INSERT INTO public.services VALUES ('f3392a2e-c769-4980-b370-2722372625bb', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', 'Разработка бизнес-плана', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим план по увеличению выручки.', 45, 7142.11);
INSERT INTO public.services VALUES ('054f7025-2424-46b8-af4d-62e0eb23993c', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', 'Разбор фин. модели', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 120, 5695.13);
INSERT INTO public.services VALUES ('25197915-9332-4516-97bc-b26a9bc03ba1', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'Разбор фин. модели', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 90, 19870.09);
INSERT INTO public.services VALUES ('a370ad97-788b-4fb9-8f0b-dc88506a237b', '1cfc4b5b-97e4-471d-b512-6d25abf9e85d', 'Разработка бизнес-плана', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 30, 11822.23);
INSERT INTO public.services VALUES ('2337ae54-f86b-4b7b-8df4-c12f88828e1d', '2b122c6b-e3d8-4b39-b165-aa8b61834322', 'Аудит маркетинговой стратегии', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 90, 15015.02);
INSERT INTO public.services VALUES ('f33ed11d-5efa-41e8-bbf6-2d0c1031f131', '9e2538b1-105a-41e5-93b5-958545f78e43', 'Анализ конкурентов', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 90, 1605.88);
INSERT INTO public.services VALUES ('42e4a7a9-d047-4f19-a62e-83b8da19ee0f', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'Разработка бизнес-плана', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 150, 12650.17);
INSERT INTO public.services VALUES ('80bfcd5e-1a7e-451c-b275-76930405a265', '9e2538b1-105a-41e5-93b5-958545f78e43', 'HR-стратегия и найм', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим план по увеличению выручки.', 45, 9039.94);
INSERT INTO public.services VALUES ('384ea40c-13d6-4460-8763-318591f77fc9', 'f9ff0172-e1df-44c3-862e-6f55b5753cdc', 'Построение отдела продаж', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 30, 5129.84);
INSERT INTO public.services VALUES ('97c99327-5f39-4585-94b4-2a4d7372f698', '40ce8df9-88ba-4316-ba21-16c38a2bd93d', 'Разбор фин. модели', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 90, 5513.27);
INSERT INTO public.services VALUES ('7c40b300-64db-4256-9fdb-42f3344f8cf7', 'e8eba8f7-b98a-441e-853e-ca158c4a3e9d', 'HR-стратегия и найм', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 90, 9100.98);
INSERT INTO public.services VALUES ('4cc82d59-f8ae-49dd-ab2b-348b63f2526f', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', 'Аудит маркетинговой стратегии', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 30, 2833.07);
INSERT INTO public.services VALUES ('a34db8f1-9d20-4475-b375-11fd7a8f51ba', '09697d5c-94af-460c-a1bb-de10bc92f737', 'Разбор фин. модели', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 180, 15088.18);
INSERT INTO public.services VALUES ('ad39b699-1bfd-4e98-963d-06f04a908357', 'c3d9e5d9-c728-4111-ba0e-3e5837247d22', 'Внедрение CRM', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 30, 5514.17);
INSERT INTO public.services VALUES ('3ad1ce20-4213-47dc-970e-e3ca53d120e2', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', 'Аудит маркетинговой стратегии', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 120, 15635.36);
INSERT INTO public.services VALUES ('78f869bf-054d-454c-9e22-e9690c248d68', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', 'Построение отдела продаж', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 45, 5949.68);
INSERT INTO public.services VALUES ('3ede3b53-72ff-4512-82cd-af8ce7b204be', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'Разбор фин. модели', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 180, 13635.42);
INSERT INTO public.services VALUES ('73fc0b01-833c-49f0-a83d-7202bb14b691', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', 'Построение отдела продаж', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 30, 9348.29);
INSERT INTO public.services VALUES ('9ac57164-dc0b-44c5-852a-8f51691f7e44', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'Анализ конкурентов', 'Анализ ваших бизнес-процессов с отчетом и рекомендациями по автоматизации и снижению издержек.', 150, 13005.18);
INSERT INTO public.services VALUES ('cda12fd2-602a-4c84-89fb-e009dec9a7c5', '9e2538b1-105a-41e5-93b5-958545f78e43', 'Анализ конкурентов', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 150, 8837.15);
INSERT INTO public.services VALUES ('ae28e0e8-35a3-4c67-ac9c-bc352d5bcd02', 'd9b6402e-b747-4701-86a2-4e70537eaeec', 'Построение отдела продаж', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 90, 10215.59);
INSERT INTO public.services VALUES ('61d9e6d7-5fc7-4a6b-ba49-8ccc8111252b', '98e27bfe-a371-4fae-8dd4-a3a92e14ac14', 'Построение отдела продаж', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 90, 1586.91);
INSERT INTO public.services VALUES ('b9a7fa81-ee26-419a-aba0-57bd9c2557b2', '49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', 'Консультация по налогам', 'Выстроим прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 45, 6898.99);
INSERT INTO public.services VALUES ('de82bd12-1b3a-4e99-ac12-71cc713f041c', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'Построение отдела продаж', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 180, 11572.94);
INSERT INTO public.services VALUES ('235b2436-b20b-4e3a-a50b-54913d810e4d', 'ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'Внедрение CRM', 'Индивидуальная онлайн-встреча. Подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 150, 13755.87);
INSERT INTO public.services VALUES ('be374a73-fc5b-4b09-8aae-433f0e43f0cf', '9e2538b1-105a-41e5-93b5-958545f78e43', 'Оптимизация логистики', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 90, 14823.29);


--
-- TOC entry 5008 (class 0 OID 24978)
-- Dependencies: 219
-- Data for Name: specialist_categories; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.specialist_categories VALUES ('c3d9e5d9-c728-4111-ba0e-3e5837247d22', '76fecc11-c995-420a-a666-ba17ea0e30ff', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('2b122c6b-e3d8-4b39-b165-aa8b61834322', 'c6988c7c-3d75-4631-a4d8-b721558b3cf1', 'Уровень Middle');
INSERT INTO public.specialist_categories VALUES ('2b122c6b-e3d8-4b39-b165-aa8b61834322', '76fecc11-c995-420a-a666-ba17ea0e30ff', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('f9ff0172-e1df-44c3-862e-6f55b5753cdc', '603cc426-250e-4dce-ba28-5fc6c575363a', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', 'c6988c7c-3d75-4631-a4d8-b721558b3cf1', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '0bc40aae-f266-4c5f-af6a-3127f26c7257', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '7a45023d-107d-4c63-8aeb-173fbf9e1244', 'Уровень Middle');
INSERT INTO public.specialist_categories VALUES ('8bdb45be-5e06-4224-904e-ca10724599f0', '298f0067-0647-45e9-a10e-27ff78711092', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('2521227e-be29-4c74-b38b-29c6a5741457', '0bc40aae-f266-4c5f-af6a-3127f26c7257', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('2521227e-be29-4c74-b38b-29c6a5741457', 'c6988c7c-3d75-4631-a4d8-b721558b3cf1', 'Независимый аудитор');
INSERT INTO public.specialist_categories VALUES ('d9b6402e-b747-4701-86a2-4e70537eaeec', '7a45023d-107d-4c63-8aeb-173fbf9e1244', 'Уровень Middle');
INSERT INTO public.specialist_categories VALUES ('d9b6402e-b747-4701-86a2-4e70537eaeec', '603cc426-250e-4dce-ba28-5fc6c575363a', 'Независимый аудитор');
INSERT INTO public.specialist_categories VALUES ('1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '0bc40aae-f266-4c5f-af6a-3127f26c7257', 'Уровень Middle');
INSERT INTO public.specialist_categories VALUES ('1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '298f0067-0647-45e9-a10e-27ff78711092', 'Независимый аудитор');
INSERT INTO public.specialist_categories VALUES ('43326f8a-d949-430c-aea3-735d47979c13', '76fecc11-c995-420a-a666-ba17ea0e30ff', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('43326f8a-d949-430c-aea3-735d47979c13', '7a45023d-107d-4c63-8aeb-173fbf9e1244', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('9e2538b1-105a-41e5-93b5-958545f78e43', '2971d7fd-2f27-4e7a-8b8d-2dbf8bf8c3d8', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('9e2538b1-105a-41e5-93b5-958545f78e43', 'b288d33d-10e4-4185-9e90-a9251f14d584', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('9e2538b1-105a-41e5-93b5-958545f78e43', 'c6988c7c-3d75-4631-a4d8-b721558b3cf1', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('035c6559-1715-4f72-91a1-9b8ec53abb80', 'c6988c7c-3d75-4631-a4d8-b721558b3cf1', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('035c6559-1715-4f72-91a1-9b8ec53abb80', 'b288d33d-10e4-4185-9e90-a9251f14d584', 'Lead-специалист');
INSERT INTO public.specialist_categories VALUES ('e8eba8f7-b98a-441e-853e-ca158c4a3e9d', 'c6988c7c-3d75-4631-a4d8-b721558b3cf1', 'Уровень Senior');
INSERT INTO public.specialist_categories VALUES ('98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '7a45023d-107d-4c63-8aeb-173fbf9e1244', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('98e27bfe-a371-4fae-8dd4-a3a92e14ac14', 'c6988c7c-3d75-4631-a4d8-b721558b3cf1', 'Уровень Middle');
INSERT INTO public.specialist_categories VALUES ('df5bc45a-5a71-4988-89c5-cfc8704a0a07', '298f0067-0647-45e9-a10e-27ff78711092', 'Независимый аудитор');
INSERT INTO public.specialist_categories VALUES ('40ce8df9-88ba-4316-ba21-16c38a2bd93d', '298f0067-0647-45e9-a10e-27ff78711092', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('40ce8df9-88ba-4316-ba21-16c38a2bd93d', '603cc426-250e-4dce-ba28-5fc6c575363a', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('455d3a9e-0b1c-43f1-91ae-97904ec21f35', '0bc40aae-f266-4c5f-af6a-3127f26c7257', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('455d3a9e-0b1c-43f1-91ae-97904ec21f35', '7a45023d-107d-4c63-8aeb-173fbf9e1244', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '298f0067-0647-45e9-a10e-27ff78711092', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '7a45023d-107d-4c63-8aeb-173fbf9e1244', 'Lead-специалист');
INSERT INTO public.specialist_categories VALUES ('ffd80e04-bf76-41a2-baf5-6125374f4cf6', '0bc40aae-f266-4c5f-af6a-3127f26c7257', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('ffd80e04-bf76-41a2-baf5-6125374f4cf6', '2971d7fd-2f27-4e7a-8b8d-2dbf8bf8c3d8', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('09697d5c-94af-460c-a1bb-de10bc92f737', '603cc426-250e-4dce-ba28-5fc6c575363a', 'Lead-специалист');


--
-- TOC entry 5006 (class 0 OID 24955)
-- Dependencies: 217
-- Data for Name: specialist_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.specialist_profiles VALUES ('c3d9e5d9-c728-4111-ba0e-3e5837247d22', '2a531c5b-089d-46b3-84d8-b1b72f5d8386', 'Специалист по инвестициям и привлечению капитала. Помог 5 стартапам привлечь раунды от венчурных фондов.', 3, '2025-02-15', 'active');
INSERT INTO public.specialist_profiles VALUES ('2b122c6b-e3d8-4b39-b165-aa8b61834322', 'fad620eb-e964-4616-be8a-c92e3d8cc332', 'Кризис-менеджер с опытом работы в ритейле. Оптимизирую расходы и сохраняю эффективность команды в турбулентные времена.', 13, '2025-09-11', 'active');
INSERT INTO public.specialist_profiles VALUES ('f9ff0172-e1df-44c3-862e-6f55b5753cdc', 'dafecfa2-6953-4a7e-8f9c-7f0579219430', 'Специалист по инвестициям и привлечению капитала. Помог 5 стартапам привлечь раунды от венчурных фондов.', 9, '2025-06-24', 'active');
INSERT INTO public.specialist_profiles VALUES ('ac7ea9aa-7d89-4a24-ab04-38bc2c2eceb6', '5d4dd4f4-f5b6-4a30-aced-131f81dda96f', 'Профессиональный HR-партнер. Знаю, как схантить лучших специалистов на рынке и снизить текучку кадров в 2 раза.', 10, '2025-11-05', 'suspended');
INSERT INTO public.specialist_profiles VALUES ('8bdb45be-5e06-4224-904e-ca10724599f0', '149b86a6-dad3-45e3-a4c7-73798d607eb8', 'Сертифицированный аудитор. Разберу ваши финансы, найду кассовые разрывы и легально снижу налоговую нагрузку.', 10, '2025-01-13', 'suspended');
INSERT INTO public.specialist_profiles VALUES ('2521227e-be29-4c74-b38b-29c6a5741457', '9690c905-e5f6-4821-9734-5a534ef83438', 'Специалист по инвестициям и привлечению капитала. Помог 5 стартапам привлечь раунды от венчурных фондов.', 4, '2025-06-09', 'active');
INSERT INTO public.specialist_profiles VALUES ('d9b6402e-b747-4701-86a2-4e70537eaeec', '1a0bc815-fd32-45c9-b429-2a17f76bf8b9', 'Специалист по инвестициям и привлечению капитала. Помог 5 стартапам привлечь раунды от венчурных фондов.', 18, '2025-04-17', 'inactive');
INSERT INTO public.specialist_profiles VALUES ('1cfc4b5b-97e4-471d-b512-6d25abf9e85d', '22c7d845-68b9-4852-b533-c209e2c1656c', 'Эксперт по маркетплейсам. Вывожу товары в ТОП на Wildberries и Ozon. Управляю рекламными бюджетами от 1 млн рублей.', 15, '2024-11-06', 'active');
INSERT INTO public.specialist_profiles VALUES ('43326f8a-d949-430c-aea3-735d47979c13', '636f7fc0-02d3-405f-a3bb-c6496fd37a04', 'Профессиональный HR-партнер. Знаю, как схантить лучших специалистов на рынке и снизить текучку кадров в 2 раза.', 10, '2025-04-09', 'inactive');
INSERT INTO public.specialist_profiles VALUES ('9e2538b1-105a-41e5-93b5-958545f78e43', '738b8b06-6c51-440d-aa85-e0bb39168ef7', 'Специалист по инвестициям и привлечению капитала. Помог 5 стартапам привлечь раунды от венчурных фондов.', 15, '2024-12-20', 'suspended');
INSERT INTO public.specialist_profiles VALUES ('035c6559-1715-4f72-91a1-9b8ec53abb80', 'd4b5eecc-486b-4dda-bcaa-0cf993190744', 'Эксперт по маркетплейсам. Вывожу товары в ТОП на Wildberries и Ozon. Управляю рекламными бюджетами от 1 млн рублей.', 8, '2024-11-13', 'active');
INSERT INTO public.specialist_profiles VALUES ('e8eba8f7-b98a-441e-853e-ca158c4a3e9d', '10d255cd-a73b-429c-85f0-edb4a0cadaa5', 'Кризис-менеджер с опытом работы в ритейле. Оптимизирую расходы и сохраняю эффективность команды в турбулентные времена.', 12, '2024-11-14', 'active');
INSERT INTO public.specialist_profiles VALUES ('98e27bfe-a371-4fae-8dd4-a3a92e14ac14', '8a5d891a-6766-4d76-bb94-c8cbfd7dd087', 'Профессиональный HR-партнер. Знаю, как схантить лучших специалистов на рынке и снизить текучку кадров в 2 раза.', 7, '2025-11-04', 'inactive');
INSERT INTO public.specialist_profiles VALUES ('df5bc45a-5a71-4988-89c5-cfc8704a0a07', '42eff525-bcb2-4b78-8ab3-9e5f7b743f23', 'Профессиональный HR-партнер. Знаю, как схантить лучших специалистов на рынке и снизить текучку кадров в 2 раза.', 14, '2025-08-03', 'active');
INSERT INTO public.specialist_profiles VALUES ('40ce8df9-88ba-4316-ba21-16c38a2bd93d', 'fe876d02-9d46-44a4-849f-c56f6bddc134', 'Корпоративный юрист с 15-летним стажем. Защита интеллектуальной собственности, составление сложных договоров и представительство в суде.', 5, '2025-04-22', 'active');
INSERT INTO public.specialist_profiles VALUES ('455d3a9e-0b1c-43f1-91ae-97904ec21f35', 'a8096d12-c4fa-40be-a9cc-3ccfb65eac00', 'Эксперт по маркетплейсам. Вывожу товары в ТОП на Wildberries и Ozon. Управляю рекламными бюджетами от 1 млн рублей.', 6, '2024-06-02', 'active');
INSERT INTO public.specialist_profiles VALUES ('b665a9b3-32b8-4cea-a3ef-5aa03dfbda7f', '80c8ca11-4c3e-4686-bfaf-0f516ab644a4', 'Корпоративный юрист с 15-летним стажем. Защита интеллектуальной собственности, составление сложных договоров и представительство в суде.', 11, '2025-06-03', 'active');
INSERT INTO public.specialist_profiles VALUES ('49cb9cd8-5035-4aef-a9af-4f161cc9b8eb', '44c7af7a-ae02-4357-b839-393ed4c1ab33', 'Специалист по инвестициям и привлечению капитала. Помог 5 стартапам привлечь раунды от венчурных фондов.', 6, '2025-02-07', 'active');
INSERT INTO public.specialist_profiles VALUES ('ffd80e04-bf76-41a2-baf5-6125374f4cf6', 'da907fa2-4802-4e6a-ad74-58c38da3e8d0', 'Корпоративный юрист с 15-летним стажем. Защита интеллектуальной собственности, составление сложных договоров и представительство в суде.', 14, '2024-10-23', 'active');
INSERT INTO public.specialist_profiles VALUES ('09697d5c-94af-460c-a1bb-de10bc92f737', '2e41139f-dc96-4663-927b-b598282733f5', 'Специалист по инвестициям и привлечению капитала. Помог 5 стартапам привлечь раунды от венчурных фондов.', 10, '2024-06-05', 'active');


--
-- TOC entry 5005 (class 0 OID 24937)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES ('2a531c5b-089d-46b3-84d8-b1b72f5d8386', 'brookemcclure@davis.org', 'Kuhic466278', 'UuULzjY8y_i$', 'Иван', 'Лебедев', '79526583229', '2025-02-06', 'specialist');
INSERT INTO public.users VALUES ('fad620eb-e964-4616-be8a-c92e3d8cc332', 'elveragaylord@langosh.name', 'Cummings8438276', '7dvxhy*764?l', 'Илья', 'Морозов', '71349251986', '2025-09-07', 'specialist');
INSERT INTO public.users VALUES ('dafecfa2-6953-4a7e-8f9c-7f0579219430', 'viviantromp@green.info', 'Walker6967487', '4pRS?G_728-#', 'Анастасия', 'Иванова', '73790780846', '2025-06-20', 'specialist');
INSERT INTO public.users VALUES ('5d4dd4f4-f5b6-4a30-aced-131f81dda96f', 'ottobeahan@corkery.net', 'Labadie858822', 'MeD7amdQy*z9', 'Анна', 'Фёдорова', '77964263012', '2025-11-05', 'specialist');
INSERT INTO public.users VALUES ('149b86a6-dad3-45e3-a4c7-73798d607eb8', 'georgianahickle@parisian.info', 'Douglas7872989', 'YZt2Z1FnafQ9', 'Виктория', 'Васильева', '72849686677', '2025-01-10', 'specialist');
INSERT INTO public.users VALUES ('9690c905-e5f6-4821-9734-5a534ef83438', 'dimitristeuber@metz.org', 'Pacocha9876530', '7kEUr!Am_6mV', 'Юлия', 'Морозова', '77380354703', '2025-06-05', 'specialist');
INSERT INTO public.users VALUES ('1a0bc815-fd32-45c9-b429-2a17f76bf8b9', 'luralind@hettinger.net', 'Koepp8130752', 'YZBxHWV8!p1U', 'Анна', 'Волкова', '73319334277', '2025-04-10', 'specialist');
INSERT INTO public.users VALUES ('22c7d845-68b9-4852-b533-c209e2c1656c', 'codymertz@keebler.info', 'Smith5905489', 'j$PbB_i1oz4-', 'Александр', 'Петров', '71788359564', '2024-11-06', 'specialist');
INSERT INTO public.users VALUES ('636f7fc0-02d3-405f-a3bb-c6496fd37a04', 'wallaceritchie@krajcik.info', 'Kling8774555', 'VGA5QOpI3$!f', 'Сергей', 'Новиков', '72795027677', '2025-04-01', 'specialist');
INSERT INTO public.users VALUES ('738b8b06-6c51-440d-aa85-e0bb39168ef7', 'trevermclaughlin@hand.info', 'Doyle8996678', '2q?PriY&?7Q7', 'Виктор', 'Васильев', '71850649876', '2024-12-12', 'specialist');
INSERT INTO public.users VALUES ('d4b5eecc-486b-4dda-bcaa-0cf993190744', 'meggiehowell@mayer.net', 'Beier1113117', 'yjUR@@i_7Bvw', 'Александр', 'Лебедев', '71439514448', '2024-11-08', 'specialist');
INSERT INTO public.users VALUES ('10d255cd-a73b-429c-85f0-edb4a0cadaa5', 'leonwyman@tillman.org', 'Stanton2613812', '?ab1?73*8-Ic', 'Наталья', 'Фёдорова', '75437719646', '2024-11-09', 'specialist');
INSERT INTO public.users VALUES ('8a5d891a-6766-4d76-bb94-c8cbfd7dd087', 'josefarohan@conn.io', 'Batz688634', '_lyRO06$K4JB', 'Алина', 'Новикова', '73595142174', '2025-10-28', 'specialist');
INSERT INTO public.users VALUES ('42eff525-bcb2-4b78-8ab3-9e5f7b743f23', 'nikolubowitz@kunde.name', 'Schultz1217795', 'Ba!#$-..iH84', 'Дарья', 'Михайлова', '77017136550', '2025-08-02', 'specialist');
INSERT INTO public.users VALUES ('fe876d02-9d46-44a4-849f-c56f6bddc134', 'jacksonblock@mcclure.com', 'Borer698158', '-8Iykm6vVIPl', 'Юлия', 'Михайлова', '74618201390', '2025-04-17', 'specialist');
INSERT INTO public.users VALUES ('a8096d12-c4fa-40be-a9cc-3ccfb65eac00', 'mozellemcclure@heaney.com', 'Osinski6386642', 'fGu.2B_V9KnH', 'Иван', 'Кузнецов', '76863900869', '2024-05-27', 'specialist');
INSERT INTO public.users VALUES ('80c8ca11-4c3e-4686-bfaf-0f516ab644a4', 'nicholausmorissette@torp.name', 'Jenkins1144566', 'a-y_W7T7vL?_', 'Екатерина', 'Петрова', '71976411764', '2025-05-28', 'specialist');
INSERT INTO public.users VALUES ('44c7af7a-ae02-4357-b839-393ed4c1ab33', 'borisking@hyatt.net', 'Krajcik851290', 'qCB2@FPq8M$2', 'Михаил', 'Попов', '77934650783', '2025-01-29', 'specialist');
INSERT INTO public.users VALUES ('da907fa2-4802-4e6a-ad74-58c38da3e8d0', 'ciaramills@reynolds.org', 'Wisoky5183964', '3lmkb49!#A8m', 'Илья', 'Смирнов', '72564876984', '2024-10-18', 'specialist');
INSERT INTO public.users VALUES ('2e41139f-dc96-4663-927b-b598282733f5', 'kittyziemann@langworth.org', 'Lang6633785', 'Vkx4sD&KNLZX', 'Екатерина', 'Соколова', '74233309526', '2024-06-02', 'specialist');
INSERT INTO public.users VALUES ('8a1743d9-d8b2-419e-9fa2-9d3190e8562d', 'orphalind@zboncak.com', 'Stracke8346406', '7gqNR&_w1b@6', 'Мария', 'Волкова', '72104639461', '2025-11-16', 'client');
INSERT INTO public.users VALUES ('dffd8773-f4f0-43a0-ab4d-b759a9f421b5', 'flaviohuel@parisian.com', 'Purdy7710516', 'F3p84J$.zzLV', 'Михаил', 'Васильев', '77466093943', '2024-12-25', 'client');
INSERT INTO public.users VALUES ('9014c974-8569-4f65-a9fe-38cac12e5f34', 'turnersanford@sporer.biz', 'Kozey8091570', 'di_r*7Hl*N$t', 'Алина', 'Васильева', '73679555127', '2025-01-12', 'client');
INSERT INTO public.users VALUES ('29525e9d-0979-4b60-aa79-81a6388253d2', 'ashleyjerde@gorczany.info', 'Moen5150462', 'WF-_SBj@p7i*', 'Виктор', 'Фёдоров', '71176724837', '2025-08-15', 'client');
INSERT INTO public.users VALUES ('e02e7c9e-3a62-4f24-b451-bf4e6a107772', 'harmonyfadel@mccullough.com', 'Predovic213856', '7-10l06ubdt9', 'Елена', 'Михайлова', '75858536065', '2025-12-23', 'client');
INSERT INTO public.users VALUES ('d7e2fe70-8cf4-41ce-8bac-252223a8da58', 'juwantoy@hills.info', 'Fisher8522461', 'x5BD#XB_kbT7', 'Ирина', 'Петрова', '76097995590', '2025-01-22', 'client');
INSERT INTO public.users VALUES ('55617455-aa81-4a19-b876-21b9c3c07966', 'anthonyharber@swaniawski.name', 'Mayer4450233', 'Zdam#mh@1mRN', 'Алексей', 'Соколов', '75244722580', '2025-05-29', 'client');
INSERT INTO public.users VALUES ('27ebd45b-a30e-4187-9a86-8599643dbc39', 'guswalker@gutmann.biz', 'Metz9583234', 'm0gMuPoCXevW', 'Александр', 'Михайлов', '76701861968', '2024-05-14', 'client');
INSERT INTO public.users VALUES ('1e42b90f-c81b-48cb-84a2-f013166ae6d9', 'kennithtorphy@cummerata.com', 'Goyette2096659', '@l7daHssO5v&', 'Иван', 'Лебедев', '73281309527', '2024-11-26', 'client');
INSERT INTO public.users VALUES ('764b1b70-3f86-4bf9-b319-d1c54c85fbcd', 'aiyanarutherford@welch.org', 'Daniel338751', '@UTlmPvt.lt*', 'Мария', 'Новикова', '71750469168', '2025-03-11', 'client');
INSERT INTO public.users VALUES ('227aba69-4fb9-462c-ad73-18f5f50eda76', 'terrilldeckow@kuhn.biz', 'Considine4861379', 'I2VMR879X4DJ', 'Андрей', 'Новиков', '74057861594', '2025-07-07', 'client');
INSERT INTO public.users VALUES ('cee489f7-4c40-4ae3-9677-c1b06b2a19f8', 'theresiapurdy@goyette.io', 'Hilpert3184987', '#dwn&ZwJ-PD8', 'Роман', 'Новиков', '77105928265', '2025-01-06', 'client');
INSERT INTO public.users VALUES ('6deec448-f858-4f38-adcd-2bc549ac8c94', 'kyleighkutch@klocko.com', 'Terry5061379', '!vCMbRrg@gkE', 'Илья', 'Соколов', '73620238189', '2026-04-20', 'client');
INSERT INTO public.users VALUES ('61214456-60d4-40c6-8f3d-8c027c9508ce', 'bennyschamberger@trantow.org', 'Kessler2683238', '2n&d-08@09Ef', 'Сергей', 'Новиков', '72785469281', '2024-10-25', 'client');
INSERT INTO public.users VALUES ('5717db47-232f-41f6-88cc-7bb96027de15', 'stuartbeer@abernathy.io', 'Flatley4791344', '7Y99Wway2g_1', 'Ирина', 'Васильева', '73578855443', '2024-05-12', 'client');
INSERT INTO public.users VALUES ('edd62666-5cde-4157-b012-733f6a6fadce', 'jadenhauck@ankunding.com', 'Flatley8633781', 'SeZ6FG#h1Z*l', 'Юлия', 'Попова', '79863198092', '2025-10-23', 'client');
INSERT INTO public.users VALUES ('8a05a3b4-e0f0-46f4-b84b-9d2873ab4cb4', 'zachariahmills@lang.net', 'Schroeder869992', 'eG!qv&Sd?Mx_', 'Сергей', 'Морозов', '71875494152', '2025-08-07', 'client');
INSERT INTO public.users VALUES ('bb4a53e9-3e22-46e1-b20b-10c8847435ad', 'einolockman@crist.info', 'Lueilwitz762936', 'vx?.642Hfr62', 'Дмитрий', 'Новиков', '77754156129', '2025-05-15', 'client');
INSERT INTO public.users VALUES ('6b0f1b05-021e-4f1e-97bf-44751975c45a', 'karsonkrajcik@mann.net', 'King7988659', 'F$367yoXRq?i', 'Роман', 'Кузнецов', '71188698269', '2026-01-08', 'client');
INSERT INTO public.users VALUES ('38f03b0a-bb5e-49f3-9fc6-4d1910f74989', 'elodyjerde@brekke.org', 'Hegmann6878794', '07?7g5a8A7I#', 'Наталья', 'Морозова', '77686149821', '2025-09-06', 'client');
INSERT INTO public.users VALUES ('56c50fa2-ea25-4330-89b3-a5c0c77ec289', 'cristaldooley@balistreri.org', 'Mohr7586692', '3SvoJDfL98aK', 'Алексей', 'Васильев', '74418877418', '2025-09-14', 'client');
INSERT INTO public.users VALUES ('36746652-9b70-40e4-b691-5b60fd28cee0', 'seanbalistreri@heathcote.net', 'Gutkowski8725451', 'oawx#E3Iq@Pf', 'Екатерина', 'Васильева', '71987971379', '2026-03-04', 'client');
INSERT INTO public.users VALUES ('dd9e2228-2f05-427b-acb8-421f3860572f', 'valentincorwin@buckridge.com', 'Schoen7833954', '6LAc?ukuUkYH', 'Наталья', 'Иванова', '73909731960', '2025-01-07', 'client');
INSERT INTO public.users VALUES ('5a5164e4-57b7-4ff3-889d-7cbee44a010e', 'vernleannon@herman.net', 'Kulas7807567', '3kleP_eyJ-Ch', 'Ирина', 'Фёдорова', '75478950728', '2025-11-11', 'client');
INSERT INTO public.users VALUES ('69d028ed-807f-4946-be09-d4985c44c241', 'vernonemard@stiedemann.com', 'Gislason7420541', 'q3RQe97!09V-', 'Иван', 'Смирнов', '72871085571', '2025-06-14', 'client');
INSERT INTO public.users VALUES ('54e25d8d-dab3-49c4-b863-53621351924a', 'jeaniejakubowski@turner.name', 'Runte2214171', 'zS_C2P8sDVW4', 'Виктор', 'Волков', '74310074018', '2025-05-11', 'client');
INSERT INTO public.users VALUES ('05afcd6a-1ad5-4311-8bf6-7139d634ee48', 'marcelobecker@cruickshank.info', 'Beatty1029233', 'YQXSIr5lx$5Z', 'Анастасия', 'Волкова', '73058604061', '2024-05-23', 'client');
INSERT INTO public.users VALUES ('4113404c-81b0-46a9-83ea-89ba7863b0aa', 'gregoriakoelpin@wiza.net', 'Mertz4833904', 'zyP$QBp&68fi', 'Илья', 'Михайлов', '79588748728', '2024-07-23', 'client');
INSERT INTO public.users VALUES ('050ce4dc-e30d-4d5c-b887-1306202c2b3e', 'rahsaanwindler@larson.biz', 'Emmerich1006538', 'j4e4QL_6WdCb', 'Роман', 'Васильев', '75085600985', '2025-03-18', 'client');
INSERT INTO public.users VALUES ('04d223ea-6797-49bd-8e05-0e0de94c5563', 'cheyannefriesen@ruecker.net', 'Erdman5779885', '&sj2j7Z-4r-3', 'Роман', 'Новиков', '73669544375', '2024-07-05', 'client');
INSERT INTO public.users VALUES ('9f0b0f39-853f-4da8-9687-b9357d440d20', 'ottilielittle@mann.com', 'Bayer5824807', '?yT0CX5Wdza8', 'Юлия', 'Васильева', '76133750040', '2025-10-19', 'client');
INSERT INTO public.users VALUES ('fbfb3025-8aaf-47ed-b65b-cfedbadffcc5', 'stephengorczany@larkin.com', 'Feeney2131536', 'fdM6Nk09HM_m', 'Татьяна', 'Соколова', '76246227984', '2025-03-11', 'client');
INSERT INTO public.users VALUES ('5cbfb257-6e90-49d2-b424-0eb6d87c94ef', 'astridjenkins@schroeder.info', 'Hayes3209516', 'P@-42RpNcMIR', 'Максим', 'Михайлов', '78985989846', '2025-02-11', 'client');
INSERT INTO public.users VALUES ('e68cd796-3311-4c5f-ba19-375f0c970472', 'craiglittle@rowe.net', 'Jenkins7918834', 'gijzCPX$xh?r', 'Татьяна', 'Волкова', '79568694408', '2025-08-19', 'client');
INSERT INTO public.users VALUES ('519cbc73-b49c-47dc-8c6e-369322853020', 'thelmamayert@strosin.org', 'Gleichner2646687', '$0q7t8JC4PDI', 'Юлия', 'Волкова', '76139907389', '2026-03-27', 'client');
INSERT INTO public.users VALUES ('4af05f5c-988b-4660-a84e-a869955f66ef', 'monserratbrown@koss.net', 'Pfeffer8684147', 'eYrGDDOz4T9&', 'Роман', 'Иванов', '73564084311', '2025-07-23', 'client');
INSERT INTO public.users VALUES ('ce5886d8-7aa0-4991-a422-29edbab37a75', 'gianniwintheiser@weber.biz', 'Quitzon6533390', '2YW4ph528brE', 'Максим', 'Петров', '73050886940', '2025-01-16', 'client');
INSERT INTO public.users VALUES ('6862b025-a58b-42f2-8fa4-e5bfab4abb07', 'kamrynyost@larson.info', 'Schuppe9142540', 'boiI2NQce&Ku', 'Наталья', 'Морозова', '73319785737', '2025-01-15', 'client');
INSERT INTO public.users VALUES ('0c54cece-e296-47fe-aea2-129343a57dce', 'deltafranecki@senger.com', 'Powlowski6156905', 'N50l1Z5n1MoY', 'Алина', 'Кузнецова', '72264517884', '2024-12-28', 'client');
INSERT INTO public.users VALUES ('1ffc4454-7b78-4499-9f9f-dd1fb738879c', 'helenlabadie@bernhard.net', 'Collins8145619', 'fZ25d1bln##G', 'Кирилл', 'Волков', '74202953548', '2026-03-09', 'client');
INSERT INTO public.users VALUES ('fc2fff95-b416-4220-908b-31e45099635e', 'aaliyahjenkins@effertz.io', 'Zboncak5120541', 'gR*7fWOY5$uG', 'Мария', 'Васильева', '71715667836', '2024-10-05', 'client');
INSERT INTO public.users VALUES ('6cc5b1c3-f4f2-462a-8e98-9c1d64fdb568', 'jesusharber@padberg.com', 'Bechtelar4304299', '*U.Bn7gP*#!O', 'Иван', 'Иванов', '74336726665', '2025-05-04', 'client');
INSERT INTO public.users VALUES ('9b419dee-9aeb-4942-b66d-0b29b21361b3', 'maeganweber@willms.com', 'Yost5226353', 'PV&rU_.5V$H3', 'Татьяна', 'Попова', '75882411345', '2025-05-12', 'client');
INSERT INTO public.users VALUES ('a833f183-973d-4b88-a2f1-d80022585c74', 'elwynabernathy@jerde.org', 'Turner4739243', 'u_XX@o$P4X27', 'Мария', 'Соколова', '72214936105', '2025-05-05', 'client');
INSERT INTO public.users VALUES ('cb30e94f-9889-4642-bd79-2fadad64209f', 'cliffordhaley@von.net', 'Blanda3795178', '7uuj.a4vwGoM', 'Юлия', 'Иванова', '73175654037', '2026-01-18', 'client');
INSERT INTO public.users VALUES ('236f2990-98cb-4f2d-9b66-48d8c66b50c1', 'goldennienow@considine.io', 'Jacobi7927665', 'U69fMHPaz*Lp', 'Артем', 'Лебедев', '72246908770', '2025-03-07', 'client');
INSERT INTO public.users VALUES ('eb71afcf-4697-422f-83fc-6398f9de6a2e', 'jaycepfeffer@moore.biz', 'Miller3935931', '@fr6LDi0#s-9', 'Дарья', 'Петрова', '77184676967', '2026-04-07', 'client');
INSERT INTO public.users VALUES ('9e67818e-1015-48b6-91fe-0f3e2a76054e', 'samarapfeffer@senger.net', 'Gaylord4625319', 'tn0Q60Y#pdtS', 'Артем', 'Михайлов', '74877677262', '2025-01-18', 'client');
INSERT INTO public.users VALUES ('9c43afd4-020a-4815-adfc-49909da3c895', 'miraclestrosin@brekke.biz', 'Fisher566098', 'h5u0n1m9Bxp4', 'Юлия', 'Попова', '75446149526', '2026-01-15', 'client');
INSERT INTO public.users VALUES ('9879eed8-286a-498a-bac6-8f91bbf48bba', 'jacynthecremin@mertz.org', 'Will8770310', '$enNI&?I0Pm8', 'Андрей', 'Новиков', '76914162773', '2026-01-17', 'client');


--
-- TOC entry 4839 (class 2606 OID 25017)
-- Name: availability_slots availability_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.availability_slots
    ADD CONSTRAINT availability_slots_pkey PRIMARY KEY (slot_id);


--
-- TOC entry 4833 (class 2606 OID 24977)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 4849 (class 2606 OID 25103)
-- Name: course_reviews course_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_reviews
    ADD CONSTRAINT course_reviews_pkey PRIMARY KEY (review_id);


--
-- TOC entry 4845 (class 2606 OID 25068)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- TOC entry 4847 (class 2606 OID 25082)
-- Name: purchased_courses purchased_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchased_courses
    ADD CONSTRAINT purchased_courses_pkey PRIMARY KEY (purchased_course_id);


--
-- TOC entry 4841 (class 2606 OID 25030)
-- Name: service_bookings service_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_bookings
    ADD CONSTRAINT service_bookings_pkey PRIMARY KEY (booking_id);


--
-- TOC entry 4843 (class 2606 OID 25051)
-- Name: service_reviews service_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT service_reviews_pkey PRIMARY KEY (review_id);


--
-- TOC entry 4837 (class 2606 OID 25004)
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (service_id);


--
-- TOC entry 4835 (class 2606 OID 24984)
-- Name: specialist_categories specialist_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_categories
    ADD CONSTRAINT specialist_categories_pkey PRIMARY KEY (profile_id, category_id);


--
-- TOC entry 4831 (class 2606 OID 24965)
-- Name: specialist_profiles specialist_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_profiles
    ADD CONSTRAINT specialist_profiles_pkey PRIMARY KEY (profile_id);


--
-- TOC entry 4825 (class 2606 OID 24952)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4827 (class 2606 OID 24954)
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- TOC entry 4829 (class 2606 OID 24950)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4854 (class 2606 OID 25018)
-- Name: availability_slots availability_slots_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.availability_slots
    ADD CONSTRAINT availability_slots_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.specialist_profiles(profile_id) ON DELETE CASCADE;


--
-- TOC entry 4861 (class 2606 OID 25104)
-- Name: course_reviews course_reviews_purchased_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_reviews
    ADD CONSTRAINT course_reviews_purchased_course_id_fkey FOREIGN KEY (purchased_course_id) REFERENCES public.purchased_courses(purchased_course_id) ON DELETE CASCADE;


--
-- TOC entry 4858 (class 2606 OID 25069)
-- Name: courses courses_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.specialist_profiles(profile_id) ON DELETE CASCADE;


--
-- TOC entry 4859 (class 2606 OID 25088)
-- Name: purchased_courses purchased_courses_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchased_courses
    ADD CONSTRAINT purchased_courses_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- TOC entry 4860 (class 2606 OID 25083)
-- Name: purchased_courses purchased_courses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchased_courses
    ADD CONSTRAINT purchased_courses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4855 (class 2606 OID 25031)
-- Name: service_bookings service_bookings_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_bookings
    ADD CONSTRAINT service_bookings_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(service_id) ON DELETE CASCADE;


--
-- TOC entry 4856 (class 2606 OID 25036)
-- Name: service_bookings service_bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_bookings
    ADD CONSTRAINT service_bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4857 (class 2606 OID 25052)
-- Name: service_reviews service_reviews_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT service_reviews_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.service_bookings(booking_id) ON DELETE CASCADE;


--
-- TOC entry 4853 (class 2606 OID 25005)
-- Name: services services_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.specialist_profiles(profile_id) ON DELETE CASCADE;


--
-- TOC entry 4851 (class 2606 OID 24990)
-- Name: specialist_categories specialist_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_categories
    ADD CONSTRAINT specialist_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 4852 (class 2606 OID 24985)
-- Name: specialist_categories specialist_categories_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_categories
    ADD CONSTRAINT specialist_categories_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.specialist_profiles(profile_id) ON DELETE CASCADE;


--
-- TOC entry 4850 (class 2606 OID 24966)
-- Name: specialist_profiles specialist_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_profiles
    ADD CONSTRAINT specialist_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


-- Completed on 2026-05-08 14:14:50

--
-- PostgreSQL database dump complete
--

\unrestrict QvhkoISEhAUFe0WvKhOKPLByo8vJO3p0f2M6B2NYcIpQXbzvXPFBIZjYTm03ysC

