--
-- PostgreSQL database dump
--

\restrict 2WkbU1fa7cy6RjLnN00Ua29FQ8Qd9C4FzzimOHvHm2tP0fRxm462a0uh9R4jEnG

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

-- Started on 2026-05-08 12:43:25

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
-- TOC entry 5006 (class 1262 OID 16394)
-- Name: lab3 database; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE "lab3 database" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1251';


\unrestrict 2WkbU1fa7cy6RjLnN00Ua29FQ8Qd9C4FzzimOHvHm2tP0fRxm462a0uh9R4jEnG
\encoding SQL_ASCII
\connect -reuse-previous=on "dbname='lab3 database'"
\restrict 2WkbU1fa7cy6RjLnN00Ua29FQ8Qd9C4FzzimOHvHm2tP0fRxm462a0uh9R4jEnG

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
-- TOC entry 2 (class 3079 OID 24755)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 24766)
-- Name: availability_slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.availability_slots (
    slot_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    profile_id uuid NOT NULL,
    start_datetime timestamp without time zone,
    end_datetime timestamp without time zone,
    status character varying(20)
);


--
-- TOC entry 217 (class 1259 OID 24770)
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    category_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(50) NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 24774)
-- Name: course_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_reviews (
    review_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    rating integer,
    comment text,
    created_date date DEFAULT CURRENT_DATE,
    purchased_course_id uuid NOT NULL,
    CONSTRAINT course_reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- TOC entry 219 (class 1259 OID 24782)
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    course_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title character varying(100) NOT NULL,
    description text,
    price numeric(10,2),
    created_date date DEFAULT CURRENT_DATE,
    updated_date date,
    profile_id uuid NOT NULL,
    status character varying(20)
);


--
-- TOC entry 220 (class 1259 OID 24789)
-- Name: purchased_courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchased_courses (
    purchased_course_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    course_id uuid NOT NULL,
    purchase_date date DEFAULT CURRENT_DATE,
    access_expires date,
    status character varying(20)
);


--
-- TOC entry 221 (class 1259 OID 24794)
-- Name: service_bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_bookings (
    booking_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    service_id uuid NOT NULL,
    user_id uuid NOT NULL,
    scheduled_start timestamp without time zone,
    scheduled_end timestamp without time zone,
    status character varying(20)
);


--
-- TOC entry 222 (class 1259 OID 24798)
-- Name: service_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_reviews (
    review_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    rating integer,
    comment text,
    created_date date DEFAULT CURRENT_DATE,
    booking_id uuid NOT NULL,
    CONSTRAINT service_reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- TOC entry 223 (class 1259 OID 24806)
-- Name: services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.services (
    service_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    profile_id uuid NOT NULL,
    title character varying(100),
    description text,
    duration integer,
    price numeric(10,2)
);


--
-- TOC entry 224 (class 1259 OID 24812)
-- Name: specialist_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specialist_categories (
    profile_id uuid NOT NULL,
    category_id uuid NOT NULL,
    specification text
);


--
-- TOC entry 225 (class 1259 OID 24817)
-- Name: specialist_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specialist_profiles (
    profile_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    bio text,
    experience_years integer,
    created_date date DEFAULT CURRENT_DATE,
    status character varying(20)
);


--
-- TOC entry 226 (class 1259 OID 24824)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(254) NOT NULL,
    login character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    name character varying(50),
    surname character varying(50),
    phone_number character varying(11),
    registration_date date DEFAULT CURRENT_DATE,
    role character varying(20)
);


--
-- TOC entry 4990 (class 0 OID 24766)
-- Dependencies: 216
-- Data for Name: availability_slots; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.availability_slots VALUES ('7f9a5b98-4ef8-4b7b-8305-1e31c8c67af2', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-07-03 12:00:00', '2026-07-03 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('68a54576-69f4-46a5-886c-c703b71297e9', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-02-23 18:00:00', '2026-02-23 19:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('a5284cc4-102d-4410-ac88-ccaa1675e089', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-03-25 09:00:00', '2026-03-25 10:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('9c39f96f-6340-403f-b50b-93eca6010826', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-02-27 15:00:00', '2026-02-27 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('8c178989-5273-471f-a27a-acbd844e3710', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-05-03 09:00:00', '2026-05-03 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('cd1d60b5-4cdc-4bb0-a5bb-b904a17bd39c', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-02-25 13:00:00', '2026-02-25 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('fa9f1d5a-373c-48ce-9ea4-dd42e82e18e6', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-06-14 11:00:00', '2026-06-14 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('64125ec6-ed0d-4c5f-b37e-8039cf21cd27', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-02-16 09:00:00', '2026-02-16 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('c18580e5-7ee0-40c4-a224-bfa78eba433b', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-02-27 11:00:00', '2026-02-27 12:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('fe0bfa47-3ff6-4bb7-9be0-482ed556d036', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-02-14 09:00:00', '2026-02-14 10:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('1a633a42-2c81-40ca-b9ed-05c5ddd3a1e3', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-03-16 18:00:00', '2026-03-16 19:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('75e605ed-afeb-4135-8933-b5af5714c4dc', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-03-26 11:00:00', '2026-03-26 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('44ef61c0-6aa4-47cf-9adf-e4c2814a56d9', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-04-13 16:00:00', '2026-04-13 17:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('99a4cdc8-9aac-448f-9622-81bd34207474', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-06-16 12:00:00', '2026-06-16 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('fdb71676-c293-437c-8003-48b909b1d3fa', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-03-25 15:00:00', '2026-03-25 16:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('865d7042-5fc2-44e1-82b3-37a9d7ee69b5', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-04-22 09:00:00', '2026-04-22 10:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('ce2d487b-1b07-4115-aa0a-c39292b6e040', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '2026-03-28 16:00:00', '2026-03-28 17:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('43e76dbd-1619-441f-bf07-16c66b090eea', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-06-29 17:00:00', '2026-06-29 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('716de168-8f32-40c9-80c8-7a71951967a3', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-03-30 10:00:00', '2026-03-30 11:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('96504f72-dfb8-485f-b6cd-0356d841bc67', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-06-22 13:00:00', '2026-06-22 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('8d65416a-ceee-4958-a3bc-4a1ab569087f', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-04-15 13:00:00', '2026-04-15 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('75a77395-a5c4-4629-ab9b-ea038ff9a245', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-05-26 09:00:00', '2026-05-26 10:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('ba58cdb2-9a99-4690-a78a-c70685bbe98c', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-03-15 15:00:00', '2026-03-15 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('a6a85dfc-64ee-40df-a24e-6945c71c30e4', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-06-07 15:00:00', '2026-06-07 16:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('50b58f2b-bf40-405d-bf8e-fad8a07a2e70', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-05-18 16:00:00', '2026-05-18 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('c8b94d18-bdf6-4949-9131-50accb49729a', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-07-05 10:00:00', '2026-07-05 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('09726399-d21a-4329-b020-27a0899a8ca9', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-03-01 12:00:00', '2026-03-01 13:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('e357fb1e-ca9d-4f31-aac7-3717414da0e8', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-03-12 17:00:00', '2026-03-12 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('36bc523f-6130-4128-a3d4-4d8eacc281a1', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-03-19 18:00:00', '2026-03-19 19:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('35d2440e-837e-4e5b-86fb-de7bae9bfbe4', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-05-14 16:00:00', '2026-05-14 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('8727c39b-0552-48b1-a789-b8a00a17606d', 'b407ec89-876f-43ed-ba50-289e55fbd869', '2026-05-12 10:00:00', '2026-05-12 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('b3791f40-ae56-41bf-8cb9-9b6020c75470', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-02-17 09:00:00', '2026-02-17 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('803cb9f3-2d4d-469d-8fe8-4c9f8c6ea2ed', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-05-30 12:00:00', '2026-05-30 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('50f465f6-863b-412f-8df9-015737321943', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-03-29 14:00:00', '2026-03-29 15:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('1a64b54d-76a4-4e53-84d9-75f8282db8d1', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-03-11 13:00:00', '2026-03-11 14:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('c68ca699-5dc9-4b8c-8034-b2aba06b469f', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-07-07 13:00:00', '2026-07-07 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('e0ee8342-b31c-43cc-9ec2-5f15700dca92', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-04-26 17:00:00', '2026-04-26 18:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('ec028e44-02d4-4b2f-a7cd-c3576d95ca75', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-02-25 17:00:00', '2026-02-25 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('07669686-5ff1-4b1a-8fbb-9768feabbc47', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-04-03 12:00:00', '2026-04-03 13:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('c064b5a1-2eb0-40ab-b13d-182018fdfd76', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-06-07 17:00:00', '2026-06-07 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('c87e593d-4fde-46c7-8fc3-f1e5ff0aadb1', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-05-04 15:00:00', '2026-05-04 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('bcd32c4a-92c9-47a8-9047-4d6d10113c37', '07beb9d4-b4e3-407d-b017-c892dc1f769a', '2026-03-08 13:00:00', '2026-03-08 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('0fb6acc2-c7c3-4573-97c2-fba105af0406', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-05-03 12:00:00', '2026-05-03 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('11172841-5ee0-471f-bf3f-f8a30e0229bb', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-03-07 11:00:00', '2026-03-07 12:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('7f7dbfc2-6747-423e-8b44-82dfb503d4b4', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-06-02 15:00:00', '2026-06-02 16:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('742298a7-53d8-4a3c-8a88-80e1f2bf7d4b', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-03-12 16:00:00', '2026-03-12 17:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('13c85352-ff93-44ab-95f5-37bc557d27a0', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-04-09 10:00:00', '2026-04-09 11:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('5556827b-7fc6-42cd-aa5d-dfa7879b70e9', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-05-01 10:00:00', '2026-05-01 11:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('d8a602ce-ab58-45e1-8431-408002e781d0', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-03-15 13:00:00', '2026-03-15 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('33df51ae-1708-420d-9e7f-9412d2583092', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-05-09 10:00:00', '2026-05-09 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('4fa54a3c-8947-4561-80a1-166e1956b7ed', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-05-27 13:00:00', '2026-05-27 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('80d35ad4-4952-4444-a439-cfff5058d20b', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-04-02 17:00:00', '2026-04-02 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2a4a1d6b-fcb5-4807-a6fa-6438750a94c6', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-06-05 16:00:00', '2026-06-05 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('62b05f33-9431-4789-8634-e50589bf79a0', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-02-10 15:00:00', '2026-02-10 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('765e5e98-1399-4d57-8b40-8925c9a527b0', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-05-07 13:00:00', '2026-05-07 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('05b9b58d-cb4e-4f00-8b05-f0df25161e99', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-07-06 17:00:00', '2026-07-06 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('b9c907f9-51da-4754-8e74-bdebba6d8a06', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-03-04 18:00:00', '2026-03-04 19:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('8c4c7733-b9d9-455e-a851-b9a97b4d9608', '174f4d28-2b01-4a54-b27a-76a50b600e50', '2026-03-27 13:00:00', '2026-03-27 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('17417110-b868-44ba-a017-9de951e34014', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-04-08 09:00:00', '2026-04-08 10:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('489d037d-4e80-46b1-874d-14dba253afa8', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-02-11 13:00:00', '2026-02-11 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('bdfbe686-ca6a-4e04-b274-9dc94e6155e6', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-06-27 10:00:00', '2026-06-27 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('1ecbff87-24a8-4a7e-af1f-3c9281d9a8e5', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-04-03 13:00:00', '2026-04-03 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('e470f51a-d0eb-4076-8c12-baf5c86c80ae', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-04-30 09:00:00', '2026-04-30 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('121858ca-20e8-4527-b23f-cb7e7aa241f4', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-05-11 14:00:00', '2026-05-11 15:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('cb1ab417-2aec-4d41-816c-59941ba51827', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-06-29 09:00:00', '2026-06-29 10:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('42e31563-156c-4a1a-aff9-d8c12cdb58bb', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-03-17 17:00:00', '2026-03-17 18:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('56ea2f8e-cf31-4543-97b4-062577e22232', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-04-18 16:00:00', '2026-04-18 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('a2127c64-b225-43f4-8b0d-4e3efb46c5a1', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-06-04 16:00:00', '2026-06-04 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('33c4897d-a4fd-4da4-8c73-97ad0b202a9f', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-02-27 17:00:00', '2026-02-27 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('b6dbef80-d859-4603-921e-e4342838cc40', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-04-25 15:00:00', '2026-04-25 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('8a5017a1-153d-4dc4-a61f-f184f1d8fd55', 'a50c19d0-a789-473b-994d-52b9212cee87', '2026-03-17 16:00:00', '2026-03-17 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('91b62879-7d10-4c28-98f0-bffd43e06998', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-02-22 15:00:00', '2026-02-22 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('17dfc93d-af62-480f-811f-22de7846a2a0', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-03-08 14:00:00', '2026-03-08 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('bd8b7428-e8ea-4437-ad4a-10acc3943f51', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-03-17 18:00:00', '2026-03-17 19:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('6d2707b6-0619-4834-918a-871dd7c8bb85', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-04-20 09:00:00', '2026-04-20 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('e240f1a0-5e37-40c6-9ca2-805f6eca4cb2', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-06-04 18:00:00', '2026-06-04 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('c6279627-c4f3-4c3e-b908-a6ab475f15cd', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-02-13 15:00:00', '2026-02-13 16:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('e6ea2958-3929-4bb6-a09c-27e6be8368c2', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-05-14 13:00:00', '2026-05-14 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('7222f543-8229-43b5-8433-344c7e1dbf51', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-03-19 09:00:00', '2026-03-19 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('bb1a554d-1046-4323-b038-15576187d1bc', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-04-12 15:00:00', '2026-04-12 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('31cb897c-6a62-4c21-8b0f-7dce081b9987', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-05-26 12:00:00', '2026-05-26 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('a3926972-6092-488b-8643-2e0835e30297', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-07-06 13:00:00', '2026-07-06 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('825947c8-eac3-48b8-8945-f60efb12815e', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-05-28 14:00:00', '2026-05-28 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('e5e8cd78-4092-4201-8b0d-7741fc49ba15', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-02-17 15:00:00', '2026-02-17 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('d4d149a4-bceb-4eee-9a1b-d59534dedd32', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-07-05 17:00:00', '2026-07-05 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('c3e6cbcc-492d-4387-9ea2-90cdfc13bc4f', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-04-25 13:00:00', '2026-04-25 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('f2ccdaad-ba8b-4c7a-8c89-ccd6e13cb48c', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-04-14 17:00:00', '2026-04-14 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('2574b7c5-6b3e-4a22-b396-4f677d8c35bd', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-03-02 13:00:00', '2026-03-02 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2350cba3-4bc9-4374-867b-4db2be1237d9', '5089dd27-b02f-469d-910c-34dfb52642c2', '2026-02-19 11:00:00', '2026-02-19 12:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('ea2da53e-5ec6-472e-9b0a-f41c1fa2c2e2', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-06-20 16:00:00', '2026-06-20 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('a3ac17c8-6d37-42f6-bf3f-f7e61926fd75', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-04-28 16:00:00', '2026-04-28 17:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('d3daf0bb-e735-4fa2-9c4e-9508271e93ed', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-03-04 13:00:00', '2026-03-04 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('cb7e5972-992d-42e9-9f70-fb8ea0f97796', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-03-18 09:00:00', '2026-03-18 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('cf5803aa-3ab3-4f0c-b554-958e94a778cd', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-03-10 09:00:00', '2026-03-10 10:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('2995c546-5c04-47ee-8580-3ced98c40f29', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-02-25 18:00:00', '2026-02-25 19:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('315ad541-690b-459d-8a53-d02c20869231', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-06-26 17:00:00', '2026-06-26 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('8f0aa155-4a4c-4758-a81f-c5fd506709fd', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-04-25 13:00:00', '2026-04-25 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('bb04e712-310a-4ad9-a90d-2596906c753a', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-04-10 14:00:00', '2026-04-10 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('61361862-12ba-456f-926b-4ac078f0c906', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-03-02 14:00:00', '2026-03-02 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('600ce367-5c0f-4d1c-84da-f8041c8f7b0b', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-03-24 16:00:00', '2026-03-24 17:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('efcac2ac-5c83-41fa-a5e3-a4589a6e3331', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-04-30 10:00:00', '2026-04-30 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('36ba5a3b-17ca-4734-82f5-c9ef39b04e04', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-03-11 17:00:00', '2026-03-11 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('0d9793b1-c00b-4de7-8232-cd5ea31b79ed', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-03-21 09:00:00', '2026-03-21 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('f7e45ef0-6791-429c-aef4-8b69de89642b', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-04-23 09:00:00', '2026-04-23 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('bb2469f3-573b-4e37-9271-874308e0ebd2', 'e69deca2-7193-49e0-8e9f-daee0420a875', '2026-07-05 10:00:00', '2026-07-05 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('87a5d3b2-fe37-4b44-9b81-402ed4cbc092', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-04-03 13:00:00', '2026-04-03 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('8916a54f-df96-4e33-9d1f-7d51cd1c0747', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-05-17 14:00:00', '2026-05-17 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('e1d00dec-b629-4685-9dcd-5af57e91b2c9', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-04-13 11:00:00', '2026-04-13 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('fdc4af27-f2d8-4986-9033-3288be5a2da1', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-04-23 15:00:00', '2026-04-23 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('962e451a-a238-41e6-94be-625643b286b9', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-03-28 16:00:00', '2026-03-28 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('6639f963-c1e7-4478-ab72-9454796f0e08', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-06-19 11:00:00', '2026-06-19 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('203692de-fa52-491a-8beb-3f795ff0d60c', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-06-04 16:00:00', '2026-06-04 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('02b6bbd8-8868-4787-b340-b60bc736ce94', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-04-05 10:00:00', '2026-04-05 11:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('ddb17805-9e1c-4461-974d-a189e0966ef2', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-05-05 12:00:00', '2026-05-05 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('3ce2a754-bcee-45a9-ac3f-b15b8568d693', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-02-21 16:00:00', '2026-02-21 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('7ca499e7-a049-47f9-8a51-87c5c12663c5', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-05-18 10:00:00', '2026-05-18 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('a216410e-6886-481f-af2e-69ebf8736e90', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-03-16 14:00:00', '2026-03-16 15:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('e657179c-e691-4607-b557-ba2ced3a6428', '70b799ac-1620-4271-bc9d-ce54a41c3682', '2026-02-13 17:00:00', '2026-02-13 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('97dfd872-423a-4bcd-a8bd-df4d87177299', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-03-09 11:00:00', '2026-03-09 12:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('768bf5b7-0fe9-4c4e-9c9b-6ceebbb25341', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-06-08 16:00:00', '2026-06-08 17:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('e114510e-25f3-405d-8cfa-6da4a6a76a8c', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-02-13 15:00:00', '2026-02-13 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('35c67bf3-34d7-4596-80b5-e21de01ccdc9', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-04-16 10:00:00', '2026-04-16 11:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('c20d35e7-c4e7-4995-bbf2-91d82553ddf0', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-06-06 17:00:00', '2026-06-06 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('64bcb423-4cd1-4309-8385-8e11db715333', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-04-30 09:00:00', '2026-04-30 10:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('f98d8759-8bd5-4080-a438-ea502a30e6c4', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-07-06 17:00:00', '2026-07-06 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('9643987a-819e-4edb-a11d-5bd805bd9748', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-03-15 13:00:00', '2026-03-15 14:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('1c35a09e-cf75-4386-9171-2ae1d43bf681', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-07-05 11:00:00', '2026-07-05 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('ad42a8ab-485e-4742-b2d4-6803b9a81ab0', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-05-07 15:00:00', '2026-05-07 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('f46fa5d5-f8c7-4229-a2ce-7febbcc8275b', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-04-20 12:00:00', '2026-04-20 13:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('719217ea-17f3-454c-8305-99ff90d55270', '86d6b656-583a-4227-9f10-7b763b3f3ea1', '2026-03-05 10:00:00', '2026-03-05 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('6f5b8d36-1231-416e-89eb-bee9187f76a4', '582ada26-484e-4377-a94d-2761381c578b', '2026-02-10 13:00:00', '2026-02-10 14:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('65bb5e5a-841a-4395-bdc1-3c7ebd22b9a3', '582ada26-484e-4377-a94d-2761381c578b', '2026-06-21 16:00:00', '2026-06-21 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('8b3c6134-6bf4-47d4-bfe3-c33c82952e50', '582ada26-484e-4377-a94d-2761381c578b', '2026-03-19 15:00:00', '2026-03-19 16:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('f6006965-3362-4c95-80f3-36c6779a33bf', '582ada26-484e-4377-a94d-2761381c578b', '2026-03-13 15:00:00', '2026-03-13 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('b31b40df-3e82-4e0c-a1e5-f6c4c0389578', '582ada26-484e-4377-a94d-2761381c578b', '2026-04-28 17:00:00', '2026-04-28 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('e22b1884-28b0-47d8-afae-d1f1e254e475', '582ada26-484e-4377-a94d-2761381c578b', '2026-04-18 11:00:00', '2026-04-18 12:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('3c5dedd0-8a03-44a9-9db9-a10eede2de30', '582ada26-484e-4377-a94d-2761381c578b', '2026-03-12 10:00:00', '2026-03-12 11:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('21f5cd48-f419-49e1-b2fd-dc20af2c3ee2', '582ada26-484e-4377-a94d-2761381c578b', '2026-05-08 13:00:00', '2026-05-08 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('c06987c7-2533-40d4-8356-4593bd22d7c0', '582ada26-484e-4377-a94d-2761381c578b', '2026-04-20 11:00:00', '2026-04-20 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('5fd37625-915c-4b2c-9087-1cd416f7e57d', '582ada26-484e-4377-a94d-2761381c578b', '2026-03-15 12:00:00', '2026-03-15 13:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('3d515446-e7e5-41b4-8fc3-572d5ea6abb1', '582ada26-484e-4377-a94d-2761381c578b', '2026-02-25 18:00:00', '2026-02-25 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('13d2b6c1-23e3-4d99-84b7-410cf0e767fe', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-05-14 11:00:00', '2026-05-14 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('66b46f9e-df25-456d-8200-8a585ac68272', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-04-29 17:00:00', '2026-04-29 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('4fc8221d-b546-486c-b9ce-352191d6700f', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-06-13 15:00:00', '2026-06-13 16:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('2f520a3f-c9c0-42ff-91f5-891c9d2e4615', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-06-26 13:00:00', '2026-06-26 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('163caeba-d49f-41b0-b118-fc4fdef2aa11', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-06-06 14:00:00', '2026-06-06 15:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('6614826b-918b-4749-b566-a39e24c695ff', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-03-08 11:00:00', '2026-03-08 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2616fb73-5d68-4875-9c2f-aa204a3bcf7d', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-04-09 17:00:00', '2026-04-09 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('237b35dc-a705-4cf9-a57f-a47c63beff8d', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-02-28 10:00:00', '2026-02-28 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('365c7bf3-7aec-4f0c-8986-c450b41c2fb7', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-05-01 13:00:00', '2026-05-01 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('477e5c52-645f-4ad3-b5b4-a5acdf89c7b0', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-04-11 16:00:00', '2026-04-11 17:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('6799be6b-0f22-4d1b-a7da-9eb3f176a19d', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-02-26 11:00:00', '2026-02-26 12:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('b5fa51c2-15f2-4089-9bff-fc071af83643', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-05-16 15:00:00', '2026-05-16 16:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('0d212a53-3545-49b8-ad04-221af7a453e0', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-04-17 17:00:00', '2026-04-17 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('b601c8e8-bc3a-458f-8c8c-4b03a61dee1d', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', '2026-03-06 13:00:00', '2026-03-06 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('b8cfbcde-dd52-4b35-90d8-39a6f2733173', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-06-28 18:00:00', '2026-06-28 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('5dd8b802-8c19-4543-a84c-4231a0d3480e', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-06-07 18:00:00', '2026-06-07 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('9a9dbd27-3c68-47ba-8683-cd3031b23b5e', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-05-03 16:00:00', '2026-05-03 17:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('da9ad0d8-bbc5-4325-b9d5-febe29db7c1f', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-06-14 18:00:00', '2026-06-14 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('d20dae15-4f83-454a-8eee-07aa857cd188', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-03-24 10:00:00', '2026-03-24 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('61fe7145-b460-4e54-834a-48277b775cf9', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-05-16 12:00:00', '2026-05-16 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('11380b21-2a48-4890-9d34-139c8b17373a', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-03-17 10:00:00', '2026-03-17 11:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('e0fb415f-53a2-4cae-9d96-1df88eb1dddb', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-07-07 10:00:00', '2026-07-07 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('34e01308-0074-410e-895b-2fb426aa77bb', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-07-05 09:00:00', '2026-07-05 10:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('b4dcf4ed-d79b-4b89-9fe5-5cee80cec8c8', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-02-22 11:00:00', '2026-02-22 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('85f95e05-b486-4a3a-b803-70f152ff0de5', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-05-22 18:00:00', '2026-05-22 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('0805b648-33d5-46bf-b5e7-b331b4559643', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-03-29 18:00:00', '2026-03-29 19:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('e029fa13-d216-4db2-a2c1-9e349fa32753', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-02-16 14:00:00', '2026-02-16 15:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('49a1cf06-558e-4c69-b248-af1b89ca6da6', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '2026-06-16 14:00:00', '2026-06-16 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('f8491989-001a-40d4-8346-a5deda532c73', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-06-29 13:00:00', '2026-06-29 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('77b3c7a5-8081-4e28-99f4-8c9937cfeee0', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-04-17 12:00:00', '2026-04-17 13:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('a03c8bf9-4178-42ac-8fc5-84765528b8b0', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-05-21 18:00:00', '2026-05-21 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('3aba4d28-9781-4393-9ae9-e8d424054f6b', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-02-13 14:00:00', '2026-02-13 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('ff4162e3-4a15-4c20-8ba4-61be6946af38', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-04-30 11:00:00', '2026-04-30 12:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('ae4a0c71-a489-488c-84ae-edd588877667', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-02-08 14:00:00', '2026-02-08 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('139feef2-5fd2-4424-badc-7a7a3663afdb', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-04-19 14:00:00', '2026-04-19 15:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('ffcd8fe3-14da-4b02-8d42-5efde365af03', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-05-26 11:00:00', '2026-05-26 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('a9519db5-c625-4ab5-94e1-9d59a583b94e', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-04-02 14:00:00', '2026-04-02 15:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('9b742a0c-5eb3-41b4-a909-b77903d7c589', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-03-18 11:00:00', '2026-03-18 12:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('0b848846-12b2-4821-a98d-4758f76bb542', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-04-19 15:00:00', '2026-04-19 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('fd9325ec-e4a7-48b6-8767-457282058f1d', '6c7c202c-6e67-4771-8e6d-cea923775928', '2026-06-23 09:00:00', '2026-06-23 10:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('35c9a286-87ce-4478-a6d0-340321e706c9', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-05-31 11:00:00', '2026-05-31 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('eef9ddc4-b125-45ce-8b60-72dfa74942a9', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-05-05 16:00:00', '2026-05-05 17:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('8970b7d6-5ae0-4322-993e-69dbbe6af601', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-04-22 15:00:00', '2026-04-22 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('c0fe2e80-6b08-4137-84b2-fef3ad972a33', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-05-21 13:00:00', '2026-05-21 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('897223c8-2e65-4058-badf-f989d34d60c7', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-05-12 09:00:00', '2026-05-12 10:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('773836e3-159d-4373-b840-a751d680f5e8', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-06-01 11:00:00', '2026-06-01 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('991a6bac-2455-4005-8bbf-21aec0f0cb69', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-02-16 18:00:00', '2026-02-16 19:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('decf4d97-4b9f-445d-8bb4-c0f6dddd6c52', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-03-21 13:00:00', '2026-03-21 14:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('4ee40cf9-ddfe-49c0-91ab-4865a23dbdc4', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-04-21 12:00:00', '2026-04-21 13:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('3e840938-99ca-4755-89f6-0989b38c3a4e', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-02-11 10:00:00', '2026-02-11 11:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('49bbb146-e4cf-4b37-a279-cbaf7fa68b60', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-07-02 10:00:00', '2026-07-02 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('8b53216e-3379-4995-b8fd-5be12a45d034', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-03-18 16:00:00', '2026-03-18 17:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('e0f86003-601e-46de-8921-276fee3c3829', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', '2026-06-15 11:00:00', '2026-06-15 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('48ce8c8a-0166-4a15-99e9-a79d3c1fa7ee', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-02-22 11:00:00', '2026-02-22 12:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('674ce6a1-b8b9-4bbb-9f56-e20d69586676', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-02-16 15:00:00', '2026-02-16 16:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('9316f954-0219-482a-9ca7-a41de332a7ea', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-04-26 15:00:00', '2026-04-26 16:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('effaf5e1-273f-4b0f-8dc3-7a5e8fea4703', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-06-12 17:00:00', '2026-06-12 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('665f7af1-c375-4401-8ad2-ff545b772dbe', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-05-07 15:00:00', '2026-05-07 16:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('f72f747e-3bbb-417c-841e-64afe68d99bb', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-05-20 11:00:00', '2026-05-20 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('17f092ba-33f8-4fc8-98bb-2b3d689fa903', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-03-12 12:00:00', '2026-03-12 13:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('81a44069-3aa2-4f98-a00b-40f5cc2b6663', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-02-11 13:00:00', '2026-02-11 14:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('bc34535e-ff78-4e17-a025-809be64f7b70', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-03-15 17:00:00', '2026-03-15 18:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('b2a2164c-92ff-4e42-b85d-9e2b9d144686', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-06-22 15:00:00', '2026-06-22 16:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('b94d9a53-55e2-42e6-beea-e712ff580dd8', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-06-11 10:00:00', '2026-06-11 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('5ed2c04d-d52d-4bca-a940-200cebd9be98', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', '2026-06-11 10:00:00', '2026-06-11 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('b18c8327-6744-44f6-8f76-2c8c239570f4', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-06-30 14:00:00', '2026-06-30 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('f733cd78-7e20-4762-8065-2c1c6ba9d2fd', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-02-10 14:00:00', '2026-02-10 15:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('25d7fd97-6c62-440f-bafc-fc23a96c798e', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-05-15 17:00:00', '2026-05-15 18:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('a8d0f591-86dc-41fd-b037-cc3c57997c35', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-06-05 11:00:00', '2026-06-05 12:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('9431f4b0-d844-45d9-9bfc-4f9f1735e04d', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-05-22 13:00:00', '2026-05-22 14:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('880b4785-6874-4f1f-832f-1b5752ee6ec2', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-04-10 13:00:00', '2026-04-10 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('be8b51dc-4569-45e8-89d9-5552967e7406', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-06-01 18:00:00', '2026-06-01 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('16e1dc1c-b774-4b06-973e-f68e55756c19', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-06-09 16:00:00', '2026-06-09 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('88863b8e-9557-4e92-92cb-5a27b884cf98', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-05-04 17:00:00', '2026-05-04 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('b1bf6d47-e059-4a33-a8ba-d432ca92e9eb', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-07-05 16:00:00', '2026-07-05 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('edf8e06a-fd35-47b8-ad7e-47cb8b9b26e5', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-04-21 09:00:00', '2026-04-21 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('180098c3-7e6d-43cf-9958-31bf3725736e', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-07-01 14:00:00', '2026-07-01 15:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('74bbbc60-8b3c-4594-8397-2bfb33dbda42', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-05-14 18:00:00', '2026-05-14 19:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('aed92f7f-a1be-451c-970f-cbb7cf12bf20', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-02-19 09:00:00', '2026-02-19 10:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('0282ea77-8707-496a-b7f2-7b75d9c8090b', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-03-19 14:00:00', '2026-03-19 15:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('b2ea30e9-c960-4cf3-bb1c-7256c43f3d9c', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-05-06 12:00:00', '2026-05-06 13:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('2631686b-7571-45cf-b98a-a78e8021cb3b', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-06-25 12:00:00', '2026-06-25 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('9040701e-a98e-4a3a-ad8f-fa0bd3a7f54d', 'e0599544-24eb-416b-b10b-306d34f3f419', '2026-06-10 09:00:00', '2026-06-10 10:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('286ab7b6-3cae-4b86-8457-81a77352c451', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-06-27 16:00:00', '2026-06-27 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('6e41f1bf-1fbf-4e38-8286-ffb689fc535d', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-03-23 10:00:00', '2026-03-23 11:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('c78bae02-4a6b-403f-9814-0d990a436fa7', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-04-17 11:00:00', '2026-04-17 12:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('f78d324c-a46b-4a77-8828-9405bee20600', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-06-14 17:00:00', '2026-06-14 18:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('94e3f92c-8bac-4de3-b520-779981dbc336', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-03-06 10:00:00', '2026-03-06 11:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('096c52f9-22d9-4fe5-97c3-7bfe048cfb7f', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-06-09 12:00:00', '2026-06-09 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('04037261-a136-46a6-a059-06d2e5997bc0', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-04-16 09:00:00', '2026-04-16 10:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('01e1029a-c99f-45d4-b3a6-6d251718bc87', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-05-23 18:00:00', '2026-05-23 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('9108a87b-62c9-4589-a368-96d763e20179', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-03-26 12:00:00', '2026-03-26 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('2b9f0258-e3bb-4608-bc75-5a2793b9c47d', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-04-18 09:00:00', '2026-04-18 10:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('ec59bc09-4012-48c4-b9dc-abd0ac5788ba', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-04-03 10:00:00', '2026-04-03 11:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('2704bc32-a6c4-409d-845e-d07425ef564d', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-04-10 14:00:00', '2026-04-10 15:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('12e3012f-284f-4b13-8f7a-5d2777a01c53', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-02-08 12:00:00', '2026-02-08 13:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('d975dae7-2dff-4f9d-8ee5-467fb24633a4', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-04-29 15:00:00', '2026-04-29 16:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('2638c40a-c4f0-4cde-ae23-25d126e67022', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', '2026-04-03 10:00:00', '2026-04-03 11:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('4fe3cea5-63e8-4b82-9c8a-fbee5af29f48', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-03-30 13:00:00', '2026-03-30 14:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('235bf97d-5ce7-4771-9b69-bb07aadbae34', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-05-22 14:00:00', '2026-05-22 15:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('87a85199-d4e1-46c3-ac0d-5a3bf0da9df5', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-04-16 13:00:00', '2026-04-16 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('a11b3d41-7769-4f1e-b801-8649275f7abd', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-06-23 18:00:00', '2026-06-23 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('ee9e6900-2c83-43d8-88cc-5e10aaa8625a', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-04-27 11:00:00', '2026-04-27 12:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('6ef140a6-440b-4e49-b5a6-58c7a2b1a54b', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-04-07 15:00:00', '2026-04-07 16:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('b6ba1daf-0102-40a7-b12d-28bf135e7eea', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-05-06 10:00:00', '2026-05-06 11:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('b7f9b355-d126-43e9-87da-742f43c533a5', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-04-10 17:00:00', '2026-04-10 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('96d6dc6f-eff5-455d-8eae-bf699206e61e', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-02-26 15:00:00', '2026-02-26 16:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('ff993b2f-824a-4e1e-99cc-7917cc94a1cc', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-03-30 12:00:00', '2026-03-30 13:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('e4c6f150-aff6-4867-9087-59eae46b68f3', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '2026-04-22 18:00:00', '2026-04-22 19:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('f227c657-f942-4b10-8872-3631c711002d', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-05-30 13:00:00', '2026-05-30 14:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('6bbe5766-5418-45af-aa56-6f6b2a4fb589', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-05-10 10:00:00', '2026-05-10 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('fdaf5807-7db1-409a-9bb4-930e01abbb98', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-04-19 18:00:00', '2026-04-19 19:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('ad65bf37-b1f6-40de-9cc7-cbcdb83284ed', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-03-09 13:00:00', '2026-03-09 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('fddce31f-0ef2-44e5-8c7e-09edd3bad03d', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-05-15 10:00:00', '2026-05-15 11:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('f0f3e62e-8961-4ffc-a200-ad836a3cdf21', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-06-08 18:00:00', '2026-06-08 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('a9f620bf-1a5e-4586-b141-c8cdf8c91fd0', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-04-23 11:00:00', '2026-04-23 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('f6551845-cdaf-4044-8ef8-896f1fdac1aa', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-03-01 18:00:00', '2026-03-01 19:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('86b76544-314b-4131-ad8f-269b6bc71cac', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-02-13 11:00:00', '2026-02-13 12:00:00', 'отменен');
INSERT INTO public.availability_slots VALUES ('c079c260-e7ed-4a3b-919f-9c1e2c249499', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-05-14 12:00:00', '2026-05-14 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('609c0c74-0c39-45e9-bee3-7d3d041c8b59', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-05-30 12:00:00', '2026-05-30 13:00:00', 'забронирован');
INSERT INTO public.availability_slots VALUES ('6731f937-e26c-4f6f-a004-8368d1806d72', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-04-26 13:00:00', '2026-04-26 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('a5748da2-f25f-46b8-9b85-d8767074c4d8', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-06-13 14:00:00', '2026-06-13 15:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('0e8336e5-a07e-4895-b0db-01b75dc12b9d', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '2026-06-07 12:00:00', '2026-06-07 13:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('d9b4f240-adf0-453f-9ecf-c13af9d8378b', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-03-30 17:00:00', '2026-03-30 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('e1059459-56ed-487f-9ea3-09c7d28d1ded', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-02-23 13:00:00', '2026-02-23 14:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('64607990-8eae-40b8-8a3e-1090a67c8458', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-05-17 16:00:00', '2026-05-17 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('9a7cbfb4-6fac-4369-aee5-163fbe161048', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-04-05 17:00:00', '2026-04-05 18:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('cb3c8d8b-9890-48a1-a142-02c07ec90ded', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-04-14 11:00:00', '2026-04-14 12:00:00', 'недоступен');
INSERT INTO public.availability_slots VALUES ('4efc6130-0aee-4a1c-9078-b3e2e1e9ec08', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-03-25 17:00:00', '2026-03-25 18:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('7c15ae1a-85a7-4240-83a1-d1817c33aef8', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-04-03 10:00:00', '2026-04-03 11:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('1822d029-7298-4d71-b931-806fc76f52ed', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-02-16 12:00:00', '2026-02-16 13:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('b2394676-58d5-49de-866d-db336607a465', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-05-24 18:00:00', '2026-05-24 19:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('1de22ba9-0ea6-40dd-a66b-2fa92b904333', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-06-23 16:00:00', '2026-06-23 17:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('fe7062f1-9c5a-4d04-8d95-575c0f58ef14', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-05-15 11:00:00', '2026-05-15 12:00:00', 'свободен');
INSERT INTO public.availability_slots VALUES ('45f03d84-5f59-4523-a14d-3baea08770de', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-02-10 10:00:00', '2026-02-10 11:00:00', 'проведен');
INSERT INTO public.availability_slots VALUES ('b89654f7-83af-45c7-bc9d-6dc24ae63403', '88d891ed-928c-4a23-a572-6855b60c50b7', '2026-06-29 18:00:00', '2026-06-29 19:00:00', 'свободен');


--
-- TOC entry 4991 (class 0 OID 24770)
-- Dependencies: 217
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categories VALUES ('6777ef7c-3af1-4264-8ed7-f22951191744', 'Маркетинг');
INSERT INTO public.categories VALUES ('a7e9fadf-3921-466b-8bda-b68c904f855a', 'Финансы');
INSERT INTO public.categories VALUES ('132651b5-507d-41b0-b5b6-0e8cfca64368', 'Логистика');
INSERT INTO public.categories VALUES ('7f89048c-c357-4f73-89f4-bc0136aa56f1', 'IT и Разработка');
INSERT INTO public.categories VALUES ('f8b6dcd4-b85a-470d-9cbb-5387a0ce9d0a', 'Менеджмент');
INSERT INTO public.categories VALUES ('a4257156-4c00-456b-bd0b-6af4aabffdd2', 'Дизайн');
INSERT INTO public.categories VALUES ('632f2903-c1a9-4cc8-aef7-9e7012348677', 'Юриспруденция');
INSERT INTO public.categories VALUES ('52dddffe-6633-45c8-8eb9-49dc8143c6ed', 'HR');


--
-- TOC entry 4992 (class 0 OID 24774)
-- Dependencies: 218
-- Data for Name: course_reviews; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.course_reviews VALUES ('f884dc2f-024f-423a-99c1-38182216f011', 5, 'Спасибо, всё четко и по делу.', '2024-12-24', '34584fe4-0fe8-4f7f-ac1c-c0117cfd13b8');
INSERT INTO public.course_reviews VALUES ('bd00dafe-2bbe-436a-92e3-568d6df8ffd0', 4, 'Лучшая инвестиция в мой бизнес за этот год!', '2025-04-27', '0ffe63f2-7c11-4d05-828e-b2691803a858');
INSERT INTO public.course_reviews VALUES ('35ead291-2ab7-44cb-aaf2-d8a7a5948197', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-02-20', 'a5f6fb60-1f01-48a0-8aec-01ba08ecec97');
INSERT INTO public.course_reviews VALUES ('3fa253a1-07cd-4ff7-91b0-f6a64c15deac', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2026-02-21', '3e9cd510-3253-4374-9e33-b1b7013c1359');
INSERT INTO public.course_reviews VALUES ('a0b8afc5-35db-4226-93e9-c09f40e87a4d', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2026-03-15', '72704e82-9b0d-46ff-ac3a-cfab194fe7ac');
INSERT INTO public.course_reviews VALUES ('cc0d41bb-ced8-46e9-91d0-b860a2e9c821', 5, 'Специалист — профессионал своего дела, рекомендую.', '2026-01-20', 'b5e340ce-0b84-4ca9-9ff7-ff5af704921d');
INSERT INTO public.course_reviews VALUES ('3c9cc901-b521-4dfd-82cd-eb58c88a22f9', 2, 'Много воды, хотелось бы больше практики.', '2025-11-25', 'ef1bfd64-da91-4092-8c44-15e179d03c6c');
INSERT INTO public.course_reviews VALUES ('4b31e9ad-7524-4cbd-8c66-392f5aad10a5', 2, 'Много воды, хотелось бы больше практики.', '2024-08-24', '22d5a70e-2130-4e9c-ae2a-3d7a05e691ff');
INSERT INTO public.course_reviews VALUES ('7a937183-5c73-40d9-8443-c1d9558d5161', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2026-05-01', 'dafeb51e-b0e1-4b76-8ac0-3bdfa2132fac');
INSERT INTO public.course_reviews VALUES ('39e38002-09fc-434d-83cd-ad3b6ee47be5', 3, 'Материал хороший, но подача немного сухая.', '2026-04-11', 'a11a5926-f58d-487a-8a90-db6dec97e127');
INSERT INTO public.course_reviews VALUES ('92c25333-376b-42bd-b9c1-aaaf68e40d24', 3, 'Цена полностью оправдывает качество.', '2026-04-11', '9c3d13e2-7518-49e3-872a-b2349d66b8e1');
INSERT INTO public.course_reviews VALUES ('b07c5802-ddb3-4b77-b145-0f5e5ca2dd3e', 1, 'Зря потратил время и деньги.', '2025-09-04', '9143101a-794b-4297-81ec-4142a70bb147');
INSERT INTO public.course_reviews VALUES ('c1e8f2e8-52d6-48db-9cd1-2226508c0f90', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2026-01-01', '9e0b9852-d5e0-4a2d-b97a-5d0e05a1458e');
INSERT INTO public.course_reviews VALUES ('dac62ab6-a347-4f9c-8b8b-d1bc8fbb1359', 2, 'Зря потратил время и деньги.', '2025-10-02', 'dd1f5ffe-94cc-4226-a106-0ccf834298ba');
INSERT INTO public.course_reviews VALUES ('a8f0f538-661b-4e0e-bd90-83f3721dabc7', 1, 'Зря потратил время и деньги.', '2026-03-16', '0c00eafe-45f6-40de-b86b-e650d1f020c2');
INSERT INTO public.course_reviews VALUES ('cba38477-c156-42a6-9876-415c2357eae4', 5, 'Лучшая инвестиция в мой бизнес за этот год!', '2025-08-19', 'a1edbb67-2968-460e-956d-9c7090869cd8');
INSERT INTO public.course_reviews VALUES ('a8caaea3-3301-4b5f-af68-f44c5aaf8282', 2, 'Не узнал ничего нового, всё есть в открытом доступе.', '2026-04-15', 'f02708fc-9659-418f-85b3-288c338f7d68');
INSERT INTO public.course_reviews VALUES ('7f7d76a0-0e09-4b0f-8136-4297bdfee19b', 4, 'Отличный материал, очень помогло!', '2026-04-11', '561689ce-258e-41d4-83d4-7a58776adb0b');
INSERT INTO public.course_reviews VALUES ('9ff35a1f-f3fe-4c67-b24c-7242dbb86dc7', 3, 'Цена полностью оправдывает качество.', '2026-03-16', 'b5c64190-e7c5-479f-a413-19aa1f19e8bb');
INSERT INTO public.course_reviews VALUES ('11bec8bd-90a8-4bc1-9aa8-bc029005f331', 3, 'Цена полностью оправдывает качество.', '2026-03-18', 'e5a867a2-b4ec-4207-8695-aeb47d908d9e');
INSERT INTO public.course_reviews VALUES ('d462beb4-9e2e-424f-9bee-75e1c2b5470d', 2, 'Зря потратил время и деньги.', '2025-12-17', 'f82f10e7-5207-436b-956e-bd2fa6caeb08');
INSERT INTO public.course_reviews VALUES ('ce0fe61c-c591-4368-b46e-247deda96d45', 5, 'Специалист — профессионал своего дела, рекомендую.', '2026-04-05', '446028a9-0792-4e3a-8d7a-65cac06f137d');
INSERT INTO public.course_reviews VALUES ('a55a81aa-1098-43f2-9c59-f8ea073b0821', 5, 'Спасибо, всё четко и по делу.', '2026-04-12', '6ac891be-ea9b-4af8-affd-64acf9a82f8d');
INSERT INTO public.course_reviews VALUES ('d7324b09-e8e6-4536-81e3-43e30f31a06d', 3, 'Цена полностью оправдывает качество.', '2026-02-02', '368acc1c-67c5-41bf-b544-cf859748694d');
INSERT INTO public.course_reviews VALUES ('2af73e50-e476-4cb2-ade3-1d6393c95837', 1, 'Зря потратил время и деньги.', '2025-08-09', '0de87fb1-b888-41c2-b20a-469e73d8e587');
INSERT INTO public.course_reviews VALUES ('e782a3ce-0dd1-45b0-af3a-66dec2ace7a2', 5, 'Лучшая инвестиция в мой бизнес за этот год!', '2026-01-25', '7be4277a-b2c8-4209-9f90-c2c42bdb8677');
INSERT INTO public.course_reviews VALUES ('e1069a04-b569-44d2-9889-293c23b38c67', 2, 'Много воды, хотелось бы больше практики.', '2026-04-17', '89f4cb9a-3a92-4528-b73c-3781f7d82f68');
INSERT INTO public.course_reviews VALUES ('c4f4acfc-66be-4424-90e7-ada6c1ffd38d', 2, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-04-03', '86b8c6a8-413d-433e-92e4-6ed67401e015');
INSERT INTO public.course_reviews VALUES ('13ba229d-ad5a-491f-ad9e-b20e604fdf78', 5, 'Лучшая инвестиция в мой бизнес за этот год!', '2025-05-12', '20c74f20-48bb-400a-b4e5-0f0bb92f3f24');
INSERT INTO public.course_reviews VALUES ('81e7e4ac-529d-40e8-8bd0-caeaf1402327', 4, 'Спасибо, всё четко и по делу.', '2026-02-27', 'eb4a5137-9a19-4eb6-bca3-62cb20e06e69');
INSERT INTO public.course_reviews VALUES ('1eb7638f-2192-4929-beae-5cffa2e259de', 4, 'Спасибо, всё четко и по делу.', '2025-12-10', '664388db-0765-4423-b8c4-b0826328dee7');
INSERT INTO public.course_reviews VALUES ('44fef860-470d-4cb5-b9b8-0a3cc4c77f29', 5, 'Спасибо, всё четко и по делу.', '2025-11-21', '2c89fbc4-1339-4af5-ab7e-5a8e80567308');
INSERT INTO public.course_reviews VALUES ('36435d43-bc22-45d9-9ae1-3b132c0fe007', 4, 'Отличный материал, очень помогло!', '2026-04-18', '25da4773-91c0-40ca-8504-c8dbb32e2582');
INSERT INTO public.course_reviews VALUES ('1d84cfc9-d230-4e7b-9aa5-5166a1400847', 5, 'Спасибо, всё четко и по делу.', '2026-03-24', '3bd60fc7-39ad-4c24-a5b9-080c8f139ee2');
INSERT INTO public.course_reviews VALUES ('d21f2702-fa6f-4420-8e77-daf399eb93e9', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2026-02-02', 'a43c1611-e2cd-476c-95b2-45c752871002');
INSERT INTO public.course_reviews VALUES ('1ed54b7d-dde6-465a-9bd6-711509130ebe', 1, 'Зря потратил время и деньги.', '2025-10-02', '489b7196-a400-47a7-8b6f-50a95064241c');
INSERT INTO public.course_reviews VALUES ('a44c4713-1ff0-41ed-99b8-dce7a9411ec5', 2, 'Много воды, хотелось бы больше практики.', '2026-03-30', '8ea4c5b7-f7af-40c9-8a43-88bde3ab341a');
INSERT INTO public.course_reviews VALUES ('6cda2af1-a155-4116-9192-ed54db54e29f', 3, 'Цена полностью оправдывает качество.', '2026-03-30', '03bc9fb0-1e3a-48db-839d-2e0ba096adab');
INSERT INTO public.course_reviews VALUES ('7d86fc01-b6f9-4f7f-97ad-2685073c398d', 3, 'Цена полностью оправдывает качество.', '2026-04-01', 'b98285b9-f47c-4c14-86d8-d0a3360da09c');
INSERT INTO public.course_reviews VALUES ('acf0dba3-2647-4dce-9317-3bba829bbeea', 2, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-08-13', 'd3d3ba0f-46f6-4220-8525-c7c0528c4d0a');


--
-- TOC entry 4993 (class 0 OID 24782)
-- Dependencies: 219
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.courses VALUES ('3a8fd589-134b-4879-84e7-9ba7a75ceebb', 'Юридическая безопасность бизнеса', 'Практический видеокурс по современным методам продвижения и управления. Только рабочие инструменты без ''воды''. Доступ к материалам навсегда.', 34917.61, '2025-05-17', NULL, '88d891ed-928c-4a23-a572-6855b60c50b7', 'published');
INSERT INTO public.courses VALUES ('f1da1b58-c492-46b9-b986-97d2b8a79b3e', 'SMM для бизнеса 2024', 'Практический видеокурс по современным методам продвижения и управления. Только рабочие инструменты без ''воды''. Доступ к материалам навсегда.', 9959.01, '2026-02-19', NULL, 'bb90ff09-cafb-4403-92a2-07d928d8daa9', 'published');
INSERT INTO public.courses VALUES ('a8f76da3-cb1d-4c8c-ab4e-4da9ed955a56', 'Excel для финансиста', 'Интенсивный курс для начинающих предпринимателей. Вы узнаете, как правильно считать юнит-экономику, составлять P&L отчеты и не прогореть в первый год.', 8433.97, '2025-07-26', NULL, '86d6b656-583a-4227-9f10-7b763b3f3ea1', 'archived');
INSERT INTO public.courses VALUES ('bc79b86f-c88a-4d1f-a3b0-26adfb63334f', 'SMM для бизнеса 2024', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов и частых ошибок новичков.', 36321.82, '2025-04-22', NULL, '174f4d28-2b01-4a54-b27a-76a50b600e50', 'published');
INSERT INTO public.courses VALUES ('8618c102-115b-4f80-b0eb-5f89109d1864', 'Мастер-класс: B2B продажи', 'Практический видеокурс по современным методам продвижения и управления. Только рабочие инструменты без ''воды''. Доступ к материалам навсегда.', 30118.91, '2025-04-27', NULL, '88d891ed-928c-4a23-a572-6855b60c50b7', 'published');
INSERT INTO public.courses VALUES ('d69e936a-15b2-4506-ad7b-a103094a743f', 'SMM для бизнеса 2024', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов и частых ошибок новичков.', 30932.79, '2025-08-29', NULL, '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', 'archived');
INSERT INTO public.courses VALUES ('4c7fc281-d61d-44e6-8407-3f80ef617d13', 'Управление командой в кризис', 'Интенсивный курс для начинающих предпринимателей. Вы узнаете, как правильно считать юнит-экономику, составлять P&L отчеты и не прогореть в первый год.', 25176.34, '2025-11-03', NULL, '6c7c202c-6e67-4771-8e6d-cea923775928', 'published');
INSERT INTO public.courses VALUES ('a89be45e-197f-4219-8029-bc8d908e27e5', 'Управление командой в кризис', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 43726.23, '2026-01-28', NULL, 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', 'published');
INSERT INTO public.courses VALUES ('d81d5644-eb25-4405-8cdb-b7783daeae7e', 'Мастер-класс: B2B продажи', 'Практический видеокурс по современным методам продвижения и управления. Только рабочие инструменты без ''воды''. Доступ к материалам навсегда.', 16341.47, '2025-12-15', NULL, '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', 'published');
INSERT INTO public.courses VALUES ('9c854e77-244f-4f39-af0d-0ac4365b2bdf', 'Основы фин. грамотности для бизнеса', 'Практический видеокурс по современным методам продвижения и управления. Только рабочие инструменты без ''воды''. Доступ к материалам навсегда.', 22925.93, '2026-03-16', NULL, '5089dd27-b02f-469d-910c-34dfb52642c2', 'published');
INSERT INTO public.courses VALUES ('f7fc7b6d-d415-4b3f-a8f4-136268b28e02', 'Мастер-класс: B2B продажи', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 26910.89, '2026-01-16', NULL, 'b3df3dff-3594-4c43-b9da-4b936d7f1282', 'published');
INSERT INTO public.courses VALUES ('8b3d08dd-b510-400c-ad34-252fec1e29e8', 'Excel для финансиста', 'Интенсивный курс для начинающих предпринимателей. Вы узнаете, как правильно считать юнит-экономику, составлять P&L отчеты и не прогореть в первый год.', 23246.77, '2024-08-06', NULL, 'b407ec89-876f-43ed-ba50-289e55fbd869', 'published');
INSERT INTO public.courses VALUES ('18eb8272-e0aa-4dbd-beee-ef44e49604e4', 'Excel для финансиста', 'Интенсивный курс для начинающих предпринимателей. Вы узнаете, как правильно считать юнит-экономику, составлять P&L отчеты и не прогореть в первый год.', 29926.37, '2024-07-25', NULL, 'e69deca2-7193-49e0-8e9f-daee0420a875', 'published');
INSERT INTO public.courses VALUES ('d3070012-3ecb-479f-92f8-5831cc285a3f', 'Основы фин. грамотности для бизнеса', 'Практический видеокурс по современным методам продвижения и управления. Только рабочие инструменты без ''воды''. Доступ к материалам навсегда.', 5516.31, '2025-10-25', NULL, '582ada26-484e-4377-a94d-2761381c578b', 'published');
INSERT INTO public.courses VALUES ('7290d0d9-8713-480c-9b06-c5a67ba2a346', 'Тайм-менеджмент руководителя', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов и частых ошибок новичков.', 43145.71, '2025-07-25', NULL, '70b799ac-1620-4271-bc9d-ce54a41c3682', 'published');
INSERT INTO public.courses VALUES ('a1463c38-87f1-4087-b875-22d81d083f8c', 'SMM для бизнеса 2024', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов и частых ошибок новичков.', 14981.66, '2025-09-29', NULL, 'b3df3dff-3594-4c43-b9da-4b936d7f1282', 'published');
INSERT INTO public.courses VALUES ('f2e090e4-7489-4797-905a-78ada21207ba', 'Мастер-класс: B2B продажи', 'Интенсивный курс для начинающих предпринимателей. Вы узнаете, как правильно считать юнит-экономику, составлять P&L отчеты и не прогореть в первый год.', 35939.31, '2026-01-28', NULL, 'b3df3dff-3594-4c43-b9da-4b936d7f1282', 'published');
INSERT INTO public.courses VALUES ('9ae65e9e-9f59-47a5-ae14-90bfadbde12a', 'Основы фин. грамотности для бизнеса', 'Практический видеокурс по современным методам продвижения и управления. Только рабочие инструменты без ''воды''. Доступ к материалам навсегда.', 45784.21, '2024-07-07', NULL, '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', 'published');
INSERT INTO public.courses VALUES ('ec8d8bbd-8eb3-4e4c-8841-bf2a6452148e', 'Основы фин. грамотности для бизнеса', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов и частых ошибок новичков.', 10357.87, '2026-01-24', NULL, '86d6b656-583a-4227-9f10-7b763b3f3ea1', 'published');
INSERT INTO public.courses VALUES ('62f61fe7-d45a-42d8-aa73-8a276ae7abce', 'Юридическая безопасность бизнеса', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 35088.41, '2025-04-14', NULL, 'e69deca2-7193-49e0-8e9f-daee0420a875', 'published');
INSERT INTO public.courses VALUES ('03e174de-2023-4068-8b4e-42376a5941f2', 'Тайм-менеджмент руководителя', 'Интенсивный курс для начинающих предпринимателей. Вы узнаете, как правильно считать юнит-экономику, составлять P&L отчеты и не прогореть в первый год.', 16475.86, '2025-08-14', NULL, 'bb90ff09-cafb-4403-92a2-07d928d8daa9', 'published');
INSERT INTO public.courses VALUES ('4a11bc4d-a02d-4380-955f-df330418d5d7', 'Основы фин. грамотности для бизнеса', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 7059.35, '2025-03-24', NULL, '6c7c202c-6e67-4771-8e6d-cea923775928', 'published');
INSERT INTO public.courses VALUES ('c264d088-f827-4459-8184-3b0cf298d98a', 'Основы фин. грамотности для бизнеса', 'Пошаговое руководство: от регистрации ИП до найма первого сотрудника. Разбор реальных кейсов и частых ошибок новичков.', 26510.73, '2025-09-02', NULL, 'e0599544-24eb-416b-b10b-306d34f3f419', 'published');
INSERT INTO public.courses VALUES ('36123d5d-999b-4edf-baec-b02a9832463a', 'Юридическая безопасность бизнеса', 'Практический видеокурс по современным методам продвижения и управления. Только рабочие инструменты без ''воды''. Доступ к материалам навсегда.', 11703.01, '2026-03-18', NULL, 'e0599544-24eb-416b-b10b-306d34f3f419', 'published');
INSERT INTO public.courses VALUES ('8c6f5b84-09f7-4ea2-91cc-9fcfc337e29f', 'Юридическая безопасность бизнеса', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 12257.11, '2025-10-28', NULL, '86d6b656-583a-4227-9f10-7b763b3f3ea1', 'archived');
INSERT INTO public.courses VALUES ('1a8851a7-3606-4260-b9af-9a9548e0c329', 'Управление командой в кризис', 'Интенсивный курс для начинающих предпринимателей. Вы узнаете, как правильно считать юнит-экономику, составлять P&L отчеты и не прогореть в первый год.', 39414.93, '2024-11-09', NULL, 'e69deca2-7193-49e0-8e9f-daee0420a875', 'published');
INSERT INTO public.courses VALUES ('5ec4852e-6244-4d67-938f-24350d31d7d8', 'Мастер-класс: B2B продажи', 'Практический видеокурс по современным методам продвижения и управления. Только рабочие инструменты без ''воды''. Доступ к материалам навсегда.', 16509.23, '2025-06-09', NULL, 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', 'published');
INSERT INTO public.courses VALUES ('6dbcf88f-503d-4baf-9fcd-f782f24cb26c', 'Основы фин. грамотности для бизнеса', 'Набор готовых шаблонов и видеоинструкций для самостоятельного внедрения в свой бизнес.', 34394.88, '2025-09-26', NULL, 'b3df3dff-3594-4c43-b9da-4b936d7f1282', 'published');
INSERT INTO public.courses VALUES ('119bf936-d0ee-4696-a96e-16564396dc7b', 'Юридическая безопасность бизнеса', 'Практический видеокурс по современным методам продвижения и управления. Только рабочие инструменты без ''воды''. Доступ к материалам навсегда.', 7754.22, '2025-11-02', NULL, '70b799ac-1620-4271-bc9d-ce54a41c3682', 'published');
INSERT INTO public.courses VALUES ('a33cde47-9fb5-414a-90f0-d83af5ff79a7', 'Управление командой в кризис', 'Интенсивный курс для начинающих предпринимателей. Вы узнаете, как правильно считать юнит-экономику, составлять P&L отчеты и не прогореть в первый год.', 30899.46, '2025-07-17', NULL, 'e0599544-24eb-416b-b10b-306d34f3f419', 'published');


--
-- TOC entry 4994 (class 0 OID 24789)
-- Dependencies: 220
-- Data for Name: purchased_courses; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.purchased_courses VALUES ('34584fe4-0fe8-4f7f-ac1c-c0117cfd13b8', '7af5d1fb-0939-4871-9e0c-c3ce1d9673d6', '9ae65e9e-9f59-47a5-ae14-90bfadbde12a', '2024-12-06', '2025-12-06', 'expired');
INSERT INTO public.purchased_courses VALUES ('f487bab1-df97-4c7f-a9c7-49d4b709bc09', '7af5d1fb-0939-4871-9e0c-c3ce1d9673d6', '6dbcf88f-503d-4baf-9fcd-f782f24cb26c', '2025-09-09', '2026-09-09', 'active');
INSERT INTO public.purchased_courses VALUES ('ed08dd88-f8f0-4bdc-8787-4d1a3e200bda', '7af5d1fb-0939-4871-9e0c-c3ce1d9673d6', 'c264d088-f827-4459-8184-3b0cf298d98a', '2025-08-11', '2026-08-11', 'active');
INSERT INTO public.purchased_courses VALUES ('0ffe63f2-7c11-4d05-828e-b2691803a858', 'dcb7e75a-c89f-4b0b-a55f-f93b164652aa', '119bf936-d0ee-4696-a96e-16564396dc7b', '2025-04-14', '2026-04-14', 'expired');
INSERT INTO public.purchased_courses VALUES ('a5f6fb60-1f01-48a0-8aec-01ba08ecec97', 'dcb7e75a-c89f-4b0b-a55f-f93b164652aa', 'a1463c38-87f1-4087-b875-22d81d083f8c', '2025-02-18', '2026-02-18', 'expired');
INSERT INTO public.purchased_courses VALUES ('3e9cd510-3253-4374-9e33-b1b7013c1359', 'd5446445-74a8-49e9-9de0-529ecc7793a3', 'f2e090e4-7489-4797-905a-78ada21207ba', '2026-02-12', '2027-02-12', 'active');
INSERT INTO public.purchased_courses VALUES ('ec9fb320-d6ad-4b66-965f-996c15215717', 'd5446445-74a8-49e9-9de0-529ecc7793a3', 'a1463c38-87f1-4087-b875-22d81d083f8c', '2026-04-10', '2027-04-10', 'active');
INSERT INTO public.purchased_courses VALUES ('72704e82-9b0d-46ff-ac3a-cfab194fe7ac', 'd5446445-74a8-49e9-9de0-529ecc7793a3', '7290d0d9-8713-480c-9b06-c5a67ba2a346', '2026-02-27', '2027-02-27', 'active');
INSERT INTO public.purchased_courses VALUES ('b5e340ce-0b84-4ca9-9ff7-ff5af704921d', 'd5446445-74a8-49e9-9de0-529ecc7793a3', '119bf936-d0ee-4696-a96e-16564396dc7b', '2026-01-06', '2027-01-06', 'active');
INSERT INTO public.purchased_courses VALUES ('ef1bfd64-da91-4092-8c44-15e179d03c6c', '8b0275c9-9acb-4c08-93d0-d39d25b09094', 'a33cde47-9fb5-414a-90f0-d83af5ff79a7', '2025-11-13', '2026-11-13', 'active');
INSERT INTO public.purchased_courses VALUES ('22d5a70e-2130-4e9c-ae2a-3d7a05e691ff', '8b0275c9-9acb-4c08-93d0-d39d25b09094', '9c854e77-244f-4f39-af0d-0ac4365b2bdf', '2024-08-14', '2025-08-14', 'expired');
INSERT INTO public.purchased_courses VALUES ('e39928ae-04b9-4781-9802-82063b0c56ed', '8b0275c9-9acb-4c08-93d0-d39d25b09094', '4c7fc281-d61d-44e6-8407-3f80ef617d13', '2025-03-25', '2026-03-25', 'expired');
INSERT INTO public.purchased_courses VALUES ('dafeb51e-b0e1-4b76-8ac0-3bdfa2132fac', 'f0132695-2dd2-4cc3-b054-555903de6d7d', '4c7fc281-d61d-44e6-8407-3f80ef617d13', '2026-04-24', '2027-04-24', 'active');
INSERT INTO public.purchased_courses VALUES ('a11a5926-f58d-487a-8a90-db6dec97e127', 'a7a54bc0-d838-4016-8864-8c15cc32b2d9', '9c854e77-244f-4f39-af0d-0ac4365b2bdf', '2026-04-07', '2027-04-07', 'active');
INSERT INTO public.purchased_courses VALUES ('9c3d13e2-7518-49e3-872a-b2349d66b8e1', 'c470d455-cc38-4c0b-b6d3-1ddaf0695f16', '8c6f5b84-09f7-4ea2-91cc-9fcfc337e29f', '2026-03-29', '2027-03-29', 'active');
INSERT INTO public.purchased_courses VALUES ('9143101a-794b-4297-81ec-4142a70bb147', 'd28e35fb-58ae-4bbc-b419-b12ebe3118bd', 'd3070012-3ecb-479f-92f8-5831cc285a3f', '2025-08-22', '2026-08-22', 'active');
INSERT INTO public.purchased_courses VALUES ('b3b48bf5-ebb2-4a0b-b25d-7072f3b1dc6f', '3eac485f-02da-45fc-a87c-bdef8198c18c', 'c264d088-f827-4459-8184-3b0cf298d98a', '2026-01-04', '2027-01-04', 'active');
INSERT INTO public.purchased_courses VALUES ('cf5d33a5-21ec-497e-b2b5-9b5d40f26d74', '3eac485f-02da-45fc-a87c-bdef8198c18c', '119bf936-d0ee-4696-a96e-16564396dc7b', '2024-12-11', '2025-12-11', 'expired');
INSERT INTO public.purchased_courses VALUES ('9e0b9852-d5e0-4a2d-b97a-5d0e05a1458e', '5aad6155-d3fe-48f3-be60-ec1037050390', '4c7fc281-d61d-44e6-8407-3f80ef617d13', '2025-12-13', '2026-12-13', 'active');
INSERT INTO public.purchased_courses VALUES ('80462f67-78fc-4a8a-8608-79c0a142300f', '5aad6155-d3fe-48f3-be60-ec1037050390', '03e174de-2023-4068-8b4e-42376a5941f2', '2025-11-20', '2026-11-20', 'active');
INSERT INTO public.purchased_courses VALUES ('2b6d165e-3ca9-4719-b157-ccd76684ba8a', 'd760a6ae-9aeb-49b9-b6aa-eec5ffe9531e', '9c854e77-244f-4f39-af0d-0ac4365b2bdf', '2026-01-27', '2027-01-27', 'active');
INSERT INTO public.purchased_courses VALUES ('22e51a70-d8c9-435a-b196-5ddbb146aa4b', '617e7367-3e5c-4767-9edf-79c90c5ad0ff', '4c7fc281-d61d-44e6-8407-3f80ef617d13', '2025-05-26', '2026-05-26', 'active');
INSERT INTO public.purchased_courses VALUES ('dd1f5ffe-94cc-4226-a106-0ccf834298ba', 'd77a2d11-6001-415e-858f-c6b482f08ed2', '03e174de-2023-4068-8b4e-42376a5941f2', '2025-09-23', '2026-09-23', 'active');
INSERT INTO public.purchased_courses VALUES ('0c00eafe-45f6-40de-b86b-e650d1f020c2', 'ec73ed14-18fa-47c4-952b-36011af06896', 'a8f76da3-cb1d-4c8c-ab4e-4da9ed955a56', '2026-03-11', '2027-03-11', 'active');
INSERT INTO public.purchased_courses VALUES ('a1edbb67-2968-460e-956d-9c7090869cd8', 'ec73ed14-18fa-47c4-952b-36011af06896', 'a33cde47-9fb5-414a-90f0-d83af5ff79a7', '2025-08-02', '2026-08-02', 'active');
INSERT INTO public.purchased_courses VALUES ('f02708fc-9659-418f-85b3-288c338f7d68', '71543d46-b102-4b40-82aa-2d78c23e9542', '6dbcf88f-503d-4baf-9fcd-f782f24cb26c', '2026-03-29', '2027-03-29', 'active');
INSERT INTO public.purchased_courses VALUES ('561689ce-258e-41d4-83d4-7a58776adb0b', '71543d46-b102-4b40-82aa-2d78c23e9542', 'ec8d8bbd-8eb3-4e4c-8841-bf2a6452148e', '2026-03-31', '2027-03-31', 'active');
INSERT INTO public.purchased_courses VALUES ('f8f3f887-db9e-495a-b117-5c402f7940fb', 'ee265a4d-9c7b-46f8-b25b-9d4ac0a5c6df', '8b3d08dd-b510-400c-ad34-252fec1e29e8', '2026-03-09', '2027-03-09', 'active');
INSERT INTO public.purchased_courses VALUES ('5f49cc00-9ba3-4bbf-b6de-709694a40dfc', 'ee265a4d-9c7b-46f8-b25b-9d4ac0a5c6df', '36123d5d-999b-4edf-baec-b02a9832463a', '2026-05-06', '2027-05-06', 'active');
INSERT INTO public.purchased_courses VALUES ('b5c64190-e7c5-479f-a413-19aa1f19e8bb', 'db91092a-69aa-46f1-a4c5-69f7be4a9a90', 'c264d088-f827-4459-8184-3b0cf298d98a', '2026-02-25', '2027-02-25', 'active');
INSERT INTO public.purchased_courses VALUES ('e5a867a2-b4ec-4207-8695-aeb47d908d9e', 'db91092a-69aa-46f1-a4c5-69f7be4a9a90', 'a89be45e-197f-4219-8029-bc8d908e27e5', '2026-03-06', '2027-03-06', 'active');
INSERT INTO public.purchased_courses VALUES ('f82f10e7-5207-436b-956e-bd2fa6caeb08', 'db91092a-69aa-46f1-a4c5-69f7be4a9a90', 'f2e090e4-7489-4797-905a-78ada21207ba', '2025-12-04', '2026-12-04', 'active');
INSERT INTO public.purchased_courses VALUES ('39d16751-4bb8-459a-a1af-359078ea4a90', 'ce5ca999-f1eb-4c19-a50a-accb201681bb', '18eb8272-e0aa-4dbd-beee-ef44e49604e4', '2026-04-23', '2027-04-23', 'active');
INSERT INTO public.purchased_courses VALUES ('5c69a53a-3314-4e22-953b-fbbbb248bab5', '80fa2d37-dda0-4008-a947-32d4b28ff102', '5ec4852e-6244-4d67-938f-24350d31d7d8', '2026-02-08', '2027-02-08', 'active');
INSERT INTO public.purchased_courses VALUES ('7e419359-03a6-4ae5-b331-5255e5474ac3', '80fa2d37-dda0-4008-a947-32d4b28ff102', 'd81d5644-eb25-4405-8cdb-b7783daeae7e', '2026-04-04', '2027-04-04', 'active');
INSERT INTO public.purchased_courses VALUES ('446028a9-0792-4e3a-8d7a-65cac06f137d', '2f22b8d4-566e-4615-a4cf-08d80c4f5967', 'c264d088-f827-4459-8184-3b0cf298d98a', '2026-03-18', '2027-03-18', 'active');
INSERT INTO public.purchased_courses VALUES ('3793ade4-c90d-4d10-8222-90382d4a5ae1', '2f22b8d4-566e-4615-a4cf-08d80c4f5967', 'f1da1b58-c492-46b9-b986-97d2b8a79b3e', '2026-02-28', '2027-02-28', 'active');
INSERT INTO public.purchased_courses VALUES ('6ac891be-ea9b-4af8-affd-64acf9a82f8d', '2f22b8d4-566e-4615-a4cf-08d80c4f5967', '9ae65e9e-9f59-47a5-ae14-90bfadbde12a', '2026-04-07', '2027-04-07', 'active');
INSERT INTO public.purchased_courses VALUES ('368acc1c-67c5-41bf-b544-cf859748694d', 'f11f2cd3-d75b-4cef-a055-db2c931885e2', '6dbcf88f-503d-4baf-9fcd-f782f24cb26c', '2026-01-24', '2027-01-24', 'active');
INSERT INTO public.purchased_courses VALUES ('870ab85c-8f36-4493-9c9a-8a6dce23c9c6', 'f11f2cd3-d75b-4cef-a055-db2c931885e2', '3a8fd589-134b-4879-84e7-9ba7a75ceebb', '2026-04-24', '2027-04-24', 'active');
INSERT INTO public.purchased_courses VALUES ('0de87fb1-b888-41c2-b20a-469e73d8e587', '79e34960-f2ee-4ca0-a93b-f172d2801a3b', 'ec8d8bbd-8eb3-4e4c-8841-bf2a6452148e', '2025-08-05', '2026-08-05', 'active');
INSERT INTO public.purchased_courses VALUES ('7d0e4b5f-b891-46fc-bb7a-2533a49136d2', '79e34960-f2ee-4ca0-a93b-f172d2801a3b', '8b3d08dd-b510-400c-ad34-252fec1e29e8', '2025-08-20', '2026-08-20', 'active');
INSERT INTO public.purchased_courses VALUES ('22ff79ed-95ea-468c-a9ea-5c4cf951116b', '78af36a8-3047-4c4b-88b1-4ae5f1e795ef', '36123d5d-999b-4edf-baec-b02a9832463a', '2026-04-29', '2027-04-29', 'active');
INSERT INTO public.purchased_courses VALUES ('7be4277a-b2c8-4209-9f90-c2c42bdb8677', '78af36a8-3047-4c4b-88b1-4ae5f1e795ef', '8b3d08dd-b510-400c-ad34-252fec1e29e8', '2026-01-09', '2027-01-09', 'active');
INSERT INTO public.purchased_courses VALUES ('89f4cb9a-3a92-4528-b73c-3781f7d82f68', 'c557121d-38e8-49dd-8411-3d1d2c53f9fa', '4c7fc281-d61d-44e6-8407-3f80ef617d13', '2026-03-28', '2027-03-28', 'active');
INSERT INTO public.purchased_courses VALUES ('cfdc884e-d22b-419f-841e-4d8b52596702', 'c557121d-38e8-49dd-8411-3d1d2c53f9fa', '03e174de-2023-4068-8b4e-42376a5941f2', '2026-05-02', '2027-05-02', 'active');
INSERT INTO public.purchased_courses VALUES ('559a91dd-e5f0-4689-80eb-e115d514fcc9', '14e2e14a-d4ce-4068-90cf-ba3ffbcde32c', 'a89be45e-197f-4219-8029-bc8d908e27e5', '2026-04-25', '2027-04-25', 'active');
INSERT INTO public.purchased_courses VALUES ('685b8c95-9b4d-4c30-85dc-d58bcd59703e', '14e2e14a-d4ce-4068-90cf-ba3ffbcde32c', '7290d0d9-8713-480c-9b06-c5a67ba2a346', '2026-04-30', '2027-04-30', 'active');
INSERT INTO public.purchased_courses VALUES ('24cf684b-8e1c-42d5-84eb-c6117327404c', 'a071ef39-68ac-4006-97f5-1dc52317656a', '9ae65e9e-9f59-47a5-ae14-90bfadbde12a', '2025-10-24', '2026-10-24', 'active');
INSERT INTO public.purchased_courses VALUES ('3f499797-be59-467f-8ed3-d52871f84c7d', '76f89faf-1ae6-4bc5-9a5f-538a211b3335', '62f61fe7-d45a-42d8-aa73-8a276ae7abce', '2025-11-30', '2026-11-30', 'active');
INSERT INTO public.purchased_courses VALUES ('5769c10f-cf8c-42a3-a815-9755b8a7cf48', '76f89faf-1ae6-4bc5-9a5f-538a211b3335', 'a8f76da3-cb1d-4c8c-ab4e-4da9ed955a56', '2025-11-21', '2026-11-21', 'active');
INSERT INTO public.purchased_courses VALUES ('ccdf2fb0-126b-4603-bbb2-d1cf92df414c', '76f89faf-1ae6-4bc5-9a5f-538a211b3335', 'f7fc7b6d-d415-4b3f-a8f4-136268b28e02', '2025-09-05', '2026-09-05', 'active');
INSERT INTO public.purchased_courses VALUES ('86b8c6a8-413d-433e-92e4-6ed67401e015', 'fef3ee6e-48ad-4e55-82d5-755075dc938d', 'f2e090e4-7489-4797-905a-78ada21207ba', '2025-03-14', '2026-03-14', 'expired');
INSERT INTO public.purchased_courses VALUES ('89319af4-3d5d-4d6f-bc59-10a5b9352699', 'd4e9cfb7-2f50-49c2-b299-92ff1575c801', 'f7fc7b6d-d415-4b3f-a8f4-136268b28e02', '2025-08-03', '2026-08-03', 'active');
INSERT INTO public.purchased_courses VALUES ('20c74f20-48bb-400a-b4e5-0f0bb92f3f24', 'd4e9cfb7-2f50-49c2-b299-92ff1575c801', '1a8851a7-3606-4260-b9af-9a9548e0c329', '2025-05-06', '2026-05-06', 'expired');
INSERT INTO public.purchased_courses VALUES ('eb4a5137-9a19-4eb6-bca3-62cb20e06e69', '556e29e7-2d94-43a9-941d-4637653afae6', 'a8f76da3-cb1d-4c8c-ab4e-4da9ed955a56', '2026-02-10', '2027-02-10', 'active');
INSERT INTO public.purchased_courses VALUES ('a248cb4d-dc54-4978-96a3-d1ff4da17df9', 'b4a7a5a3-2d7f-4c77-81cc-d0084137c654', 'c264d088-f827-4459-8184-3b0cf298d98a', '2025-11-01', '2026-11-01', 'active');
INSERT INTO public.purchased_courses VALUES ('4303faef-a42b-43fd-90f3-31110eabbc6a', '41694892-efd6-49d5-9965-f64407334fed', '8c6f5b84-09f7-4ea2-91cc-9fcfc337e29f', '2026-04-18', '2027-04-18', 'active');
INSERT INTO public.purchased_courses VALUES ('af2fc6e3-8e12-41b7-9c54-5a4396aba2d8', '2027739a-ff17-46a0-8a87-263b348bb5ff', '18eb8272-e0aa-4dbd-beee-ef44e49604e4', '2025-07-16', '2026-07-16', 'active');
INSERT INTO public.purchased_courses VALUES ('26ae524a-f7a0-4a8d-9e4a-d6aee5353afa', '2027739a-ff17-46a0-8a87-263b348bb5ff', '8b3d08dd-b510-400c-ad34-252fec1e29e8', '2025-10-18', '2026-10-18', 'active');
INSERT INTO public.purchased_courses VALUES ('664388db-0765-4423-b8c4-b0826328dee7', '2027739a-ff17-46a0-8a87-263b348bb5ff', 'bc79b86f-c88a-4d1f-a3b0-26adfb63334f', '2025-12-07', '2026-12-07', 'active');
INSERT INTO public.purchased_courses VALUES ('2c89fbc4-1339-4af5-ab7e-5a8e80567308', '2c16ebc1-b8f4-4b31-8853-4413c5899d61', '5ec4852e-6244-4d67-938f-24350d31d7d8', '2025-11-07', '2026-11-07', 'active');
INSERT INTO public.purchased_courses VALUES ('8ef071a8-7eba-4148-a245-1cf8003d9849', '2d4262e5-7171-471e-90ca-d9d4c0ac9afe', 'ec8d8bbd-8eb3-4e4c-8841-bf2a6452148e', '2025-12-08', '2026-12-08', 'active');
INSERT INTO public.purchased_courses VALUES ('25da4773-91c0-40ca-8504-c8dbb32e2582', '4b8ec2d5-cb86-4b75-80e2-fa876f1d4360', '36123d5d-999b-4edf-baec-b02a9832463a', '2026-04-12', '2027-04-12', 'active');
INSERT INTO public.purchased_courses VALUES ('3bd60fc7-39ad-4c24-a5b9-080c8f139ee2', '4b8ec2d5-cb86-4b75-80e2-fa876f1d4360', '8c6f5b84-09f7-4ea2-91cc-9fcfc337e29f', '2026-03-19', '2027-03-19', 'active');
INSERT INTO public.purchased_courses VALUES ('8eeb491d-5126-49ae-8f78-6e5414fb4c00', 'eba28432-e0e8-4e83-be5c-9d5e64b8f776', '1a8851a7-3606-4260-b9af-9a9548e0c329', '2025-11-25', '2026-11-25', 'active');
INSERT INTO public.purchased_courses VALUES ('ffc6e930-93d9-4a19-acfb-e11510822ebd', 'eba28432-e0e8-4e83-be5c-9d5e64b8f776', 'c264d088-f827-4459-8184-3b0cf298d98a', '2025-12-18', '2026-12-18', 'active');
INSERT INTO public.purchased_courses VALUES ('a43c1611-e2cd-476c-95b2-45c752871002', 'eba28432-e0e8-4e83-be5c-9d5e64b8f776', '8c6f5b84-09f7-4ea2-91cc-9fcfc337e29f', '2026-01-30', '2027-01-30', 'active');
INSERT INTO public.purchased_courses VALUES ('489b7196-a400-47a7-8b6f-50a95064241c', '607733fe-e0af-4227-833e-a877633f5bd3', '03e174de-2023-4068-8b4e-42376a5941f2', '2025-09-22', '2026-09-22', 'active');
INSERT INTO public.purchased_courses VALUES ('7b87ef85-f703-42d0-9496-328581b2c8a8', '58a3b6bf-3bce-4522-a54f-486c75f6c406', 'f1da1b58-c492-46b9-b986-97d2b8a79b3e', '2026-03-15', '2027-03-15', 'active');
INSERT INTO public.purchased_courses VALUES ('af2295f5-760f-43c0-b1e7-91f0e16ccc53', '58a3b6bf-3bce-4522-a54f-486c75f6c406', '8618c102-115b-4f80-b0eb-5f89109d1864', '2026-02-19', '2027-02-19', 'active');
INSERT INTO public.purchased_courses VALUES ('d9c7329b-7fb9-4311-8575-32041bff153c', '58a3b6bf-3bce-4522-a54f-486c75f6c406', '8c6f5b84-09f7-4ea2-91cc-9fcfc337e29f', '2026-04-24', '2027-04-24', 'active');
INSERT INTO public.purchased_courses VALUES ('50178143-d774-414a-8849-096834f4eecb', '9205964d-8372-4563-89d4-b549d3d1ab01', '7290d0d9-8713-480c-9b06-c5a67ba2a346', '2025-10-26', '2026-10-26', 'active');
INSERT INTO public.purchased_courses VALUES ('525fd934-5cd6-41b9-88ff-f7c11d34cd7b', '87c81a7f-b8b9-4aa7-8c7c-5e252447dc0c', 'a1463c38-87f1-4087-b875-22d81d083f8c', '2025-11-08', '2026-11-08', 'active');
INSERT INTO public.purchased_courses VALUES ('d7e6a837-730c-4eb8-8f88-d2f65b0ebf41', '295e6eb5-15d9-4d1f-b648-5a1d7d1b15b2', '4c7fc281-d61d-44e6-8407-3f80ef617d13', '2026-04-02', '2027-04-02', 'active');
INSERT INTO public.purchased_courses VALUES ('8ea4c5b7-f7af-40c9-8a43-88bde3ab341a', '295e6eb5-15d9-4d1f-b648-5a1d7d1b15b2', '119bf936-d0ee-4696-a96e-16564396dc7b', '2026-03-14', '2027-03-14', 'active');
INSERT INTO public.purchased_courses VALUES ('03bc9fb0-1e3a-48db-839d-2e0ba096adab', '295e6eb5-15d9-4d1f-b648-5a1d7d1b15b2', 'a8f76da3-cb1d-4c8c-ab4e-4da9ed955a56', '2026-03-15', '2027-03-15', 'active');
INSERT INTO public.purchased_courses VALUES ('b98285b9-f47c-4c14-86d8-d0a3360da09c', '295e6eb5-15d9-4d1f-b648-5a1d7d1b15b2', '8618c102-115b-4f80-b0eb-5f89109d1864', '2026-03-30', '2027-03-30', 'active');
INSERT INTO public.purchased_courses VALUES ('10e08527-fc9b-46f3-a974-88d5f5076be2', '5614c63e-b164-439a-bfad-ad68b28d05f5', '18eb8272-e0aa-4dbd-beee-ef44e49604e4', '2025-04-13', '2026-04-13', 'expired');
INSERT INTO public.purchased_courses VALUES ('d3d3ba0f-46f6-4220-8525-c7c0528c4d0a', '5614c63e-b164-439a-bfad-ad68b28d05f5', 'a8f76da3-cb1d-4c8c-ab4e-4da9ed955a56', '2025-08-01', '2026-08-01', 'active');
INSERT INTO public.purchased_courses VALUES ('0cefa603-952a-433d-b0c0-1a8e90b4b177', '29199910-4a41-4c96-98af-484385e37f24', '8b3d08dd-b510-400c-ad34-252fec1e29e8', '2025-01-26', '2026-01-26', 'expired');
INSERT INTO public.purchased_courses VALUES ('6193d8b8-8b2f-4c74-8ad7-d6d42c414787', '29199910-4a41-4c96-98af-484385e37f24', '03e174de-2023-4068-8b4e-42376a5941f2', '2026-05-01', '2027-05-01', 'active');


--
-- TOC entry 4995 (class 0 OID 24794)
-- Dependencies: 221
-- Data for Name: service_bookings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.service_bookings VALUES ('3ce33320-57bb-4b2e-8fdb-852faaa4635f', 'e6f5427e-f9ef-4492-90d0-3384f045caa5', '7af5d1fb-0939-4871-9e0c-c3ce1d9673d6', '2024-11-21 14:17:22.80003', '2024-11-21 15:17:22.80003', 'завершено');
INSERT INTO public.service_bookings VALUES ('0ba5b51c-1264-4a9a-927e-c9db823d88ab', 'd363043a-9ff5-4b00-a7e2-e55cec25c791', '7af5d1fb-0939-4871-9e0c-c3ce1d9673d6', '2025-02-07 11:44:55.563185', '2025-02-07 12:44:55.563185', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('c97630e9-87ab-469c-bebd-c51e4d627fd8', '8161e4da-e19c-4a24-a1d3-bca8f12a0644', 'dcb7e75a-c89f-4b0b-a55f-f93b164652aa', '2025-08-12 12:52:43.401981', '2025-08-12 13:52:43.401981', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('6f09987d-903d-40a5-ac2e-2adb6d249cde', '98450b8d-0905-4226-9dc6-1afd8a993f43', 'd5446445-74a8-49e9-9de0-529ecc7793a3', '2026-04-21 21:45:14.259985', '2026-04-21 22:45:14.259985', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('1510607a-86ec-49cf-8bb5-7a804848db79', 'f5e0b0ca-f27f-4e9d-a0a4-1dbbee607aae', 'd5446445-74a8-49e9-9de0-529ecc7793a3', '2026-04-24 12:17:40.915103', '2026-04-24 13:17:40.915103', 'отменено');
INSERT INTO public.service_bookings VALUES ('ccd40085-3c63-42db-b9c2-9067fb3a6ed1', '60b62f2f-242d-47fc-8733-67288ec30cd9', 'd5446445-74a8-49e9-9de0-529ecc7793a3', '2026-04-13 03:19:42.563273', '2026-04-13 04:19:42.563273', 'завершено');
INSERT INTO public.service_bookings VALUES ('55020d37-6381-4758-b927-fa88d14a08aa', '4701b341-55ca-4f7f-8c97-86435779f58d', '8b0275c9-9acb-4c08-93d0-d39d25b09094', '2025-12-23 15:21:56.943481', '2025-12-23 16:21:56.943481', 'завершено');
INSERT INTO public.service_bookings VALUES ('ef2ca9f7-b682-483f-9112-df3e6f816c1c', 'bbc6c4ec-4fdc-4e2a-9629-7b78dda47f45', '8b0275c9-9acb-4c08-93d0-d39d25b09094', '2024-08-19 00:51:12.960739', '2024-08-19 01:51:12.960739', 'завершено');
INSERT INTO public.service_bookings VALUES ('372744bf-4875-48cf-9a66-f1d37ddb51d0', 'e971575c-a0fd-47c8-8ab5-58b78d646868', 'f0132695-2dd2-4cc3-b054-555903de6d7d', '2026-03-30 15:13:42.7491', '2026-03-30 16:13:42.7491', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('93bc0826-7556-4ce4-80af-bf335bef8241', 'c3f0a581-6c19-474c-acab-5202b120d603', 'f0132695-2dd2-4cc3-b054-555903de6d7d', '2026-03-15 03:01:14.051858', '2026-03-15 04:01:14.051858', 'отменено');
INSERT INTO public.service_bookings VALUES ('1d16b984-8c07-4752-a29a-0e391213e2cd', 'ea07fce7-c070-43e9-81a8-b7c8ed41f7ca', 'f0132695-2dd2-4cc3-b054-555903de6d7d', '2025-12-17 09:41:00.370123', '2025-12-17 10:41:00.370123', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('721d3f12-0820-4d9c-8921-4352526f549b', 'dcd7159f-e028-421d-8101-0ff3f5143eaf', 'a7a54bc0-d838-4016-8864-8c15cc32b2d9', '2026-01-21 03:56:23.24026', '2026-01-21 04:56:23.24026', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('61d6c2c5-ecce-40e2-bde8-b77e00a4bb3d', 'e6f5427e-f9ef-4492-90d0-3384f045caa5', 'a7a54bc0-d838-4016-8864-8c15cc32b2d9', '2026-03-03 15:15:04.338969', '2026-03-03 16:15:04.338969', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('d81c1c17-ae64-4c2c-9252-669a8fce3823', 'e6f5427e-f9ef-4492-90d0-3384f045caa5', 'a7a54bc0-d838-4016-8864-8c15cc32b2d9', '2025-11-06 18:57:40.962191', '2025-11-06 19:57:40.962191', 'завершено');
INSERT INTO public.service_bookings VALUES ('e5076dfa-78af-4b1b-a22a-a61f2d0a8341', '1f04b223-8f58-436f-af6f-681db42332bf', 'c470d455-cc38-4c0b-b6d3-1ddaf0695f16', '2025-09-25 15:43:34.600857', '2025-09-25 16:43:34.600857', 'завершено');
INSERT INTO public.service_bookings VALUES ('8068f63c-04f7-48e7-94f8-e23fb1160c4e', 'cdb0813b-d943-4207-9a8d-408f2b2fc7c8', 'd28e35fb-58ae-4bbc-b419-b12ebe3118bd', '2025-11-03 02:45:04.448458', '2025-11-03 03:45:04.448458', 'отменено');
INSERT INTO public.service_bookings VALUES ('95d7127d-ddef-4386-a008-0c90900c899e', 'b0791fea-9c6b-4c36-afdf-ed1374ae8c82', 'd28e35fb-58ae-4bbc-b419-b12ebe3118bd', '2025-12-09 05:59:49.048412', '2025-12-09 06:59:49.048412', 'завершено');
INSERT INTO public.service_bookings VALUES ('4e1090be-814a-4faa-8844-06e8c1d8526d', '76412a7a-35da-403f-b13a-1579129ea0f3', '3eac485f-02da-45fc-a87c-bdef8198c18c', '2024-10-27 19:17:11.391501', '2024-10-27 20:17:11.391501', 'завершено');
INSERT INTO public.service_bookings VALUES ('23acec67-fcf8-4534-9bf9-e80681a81938', '6d6e94a8-b716-4fc2-9748-78ea1d89e70f', 'd760a6ae-9aeb-49b9-b6aa-eec5ffe9531e', '2026-02-14 07:39:03.745769', '2026-02-14 08:39:03.745769', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('71b048fa-ffbe-42e3-845a-8f51ae3578d2', 'cb48e335-3ccb-4491-9160-703585b18669', 'd760a6ae-9aeb-49b9-b6aa-eec5ffe9531e', '2026-04-24 04:53:57.642439', '2026-04-24 05:53:57.642439', 'завершено');
INSERT INTO public.service_bookings VALUES ('b578a4fc-e11f-4b5e-acdc-ba3fbefce8a2', 'ba3a0175-c053-4173-ba00-245db4645a69', 'd77a2d11-6001-415e-858f-c6b482f08ed2', '2026-01-01 23:43:24.044221', '2026-01-02 00:43:24.044221', 'отменено');
INSERT INTO public.service_bookings VALUES ('af53c755-8862-47c3-9aab-a6aa889fac94', '4f615d69-3d65-4877-876c-6fea280c2a7f', 'ec73ed14-18fa-47c4-952b-36011af06896', '2026-03-05 00:13:26.677041', '2026-03-05 01:13:26.677041', 'завершено');
INSERT INTO public.service_bookings VALUES ('7291e0cf-0758-4209-9441-32451465ca9f', '7e0a1c54-56d5-4341-aff6-8a215c65a392', 'ec73ed14-18fa-47c4-952b-36011af06896', '2025-07-25 01:24:32.779276', '2025-07-25 02:24:32.779276', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('9e9191f3-45be-47f5-ba2c-3299c820fcfa', 'dcd7159f-e028-421d-8101-0ff3f5143eaf', '71543d46-b102-4b40-82aa-2d78c23e9542', '2026-06-05 09:38:06.953233', '2026-06-05 10:38:06.953233', 'ожидает_оплаты');
INSERT INTO public.service_bookings VALUES ('e4305593-a098-404c-94ed-47f8aa691c5d', '3a0d6511-9176-4ab6-a133-7229bb7f7037', 'ee265a4d-9c7b-46f8-b25b-9d4ac0a5c6df', '2026-03-09 23:17:41.934804', '2026-03-10 00:17:41.934804', 'отменено');
INSERT INTO public.service_bookings VALUES ('43b8c3f3-60c8-4e66-91fb-0b70edbf44e5', '4c15a4e4-9975-43ee-9f5f-393a8eb7efc0', 'db91092a-69aa-46f1-a4c5-69f7be4a9a90', '2026-04-06 11:17:23.515546', '2026-04-06 12:17:23.515546', 'завершено');
INSERT INTO public.service_bookings VALUES ('8769f46d-6658-4faa-b3aa-b826c4b03e5d', '87466623-f080-4f82-aeb9-81ab0f5667c1', 'ce5ca999-f1eb-4c19-a50a-accb201681bb', '2026-05-09 19:35:09.895882', '2026-05-09 20:35:09.895882', 'создано');
INSERT INTO public.service_bookings VALUES ('2c04c2f6-acf6-4e35-8b12-9cd6632fbbde', '93b78a2c-4505-4931-af60-60e07d09dc15', '80fa2d37-dda0-4008-a947-32d4b28ff102', '2026-01-28 02:44:24.742043', '2026-01-28 03:44:24.742043', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('0614d257-507c-4d8a-beb9-fb263d7e3fe7', '58018845-9705-43dc-9c15-a09d315910a3', '80fa2d37-dda0-4008-a947-32d4b28ff102', '2026-01-11 05:51:13.479392', '2026-01-11 06:51:13.479392', 'завершено');
INSERT INTO public.service_bookings VALUES ('83cbf7a9-0f05-4400-9de7-ae24818f7258', 'db1af11e-469b-40a7-b85c-e0b88369ce17', '80fa2d37-dda0-4008-a947-32d4b28ff102', '2026-03-30 17:13:45.528605', '2026-03-30 18:13:45.528605', 'отменено');
INSERT INTO public.service_bookings VALUES ('819089e1-8268-4061-953f-9364daccdd83', '7e0a1c54-56d5-4341-aff6-8a215c65a392', '2f22b8d4-566e-4615-a4cf-08d80c4f5967', '2026-02-13 01:19:12.278408', '2026-02-13 02:19:12.278408', 'завершено');
INSERT INTO public.service_bookings VALUES ('08ae25e5-c902-4bf8-8190-16890f585a2f', 'f99887cb-b432-41e3-9ce3-6b20dc462be9', '2f22b8d4-566e-4615-a4cf-08d80c4f5967', '2025-12-03 12:12:56.641069', '2025-12-03 13:12:56.641069', 'завершено');
INSERT INTO public.service_bookings VALUES ('4f6bc62d-650c-4a5f-8171-6b2e8e07e4c9', '29cc7cbe-6d31-49c2-8cef-725566b80438', '2f22b8d4-566e-4615-a4cf-08d80c4f5967', '2026-04-17 10:19:33.158801', '2026-04-17 11:19:33.158801', 'завершено');
INSERT INTO public.service_bookings VALUES ('b3064ae2-78b9-41f6-8084-d224bf6fb328', '76412a7a-35da-403f-b13a-1579129ea0f3', 'f11f2cd3-d75b-4cef-a055-db2c931885e2', '2026-04-03 07:41:08.857052', '2026-04-03 08:41:08.857052', 'завершено');
INSERT INTO public.service_bookings VALUES ('eff2a1d3-6163-4d37-98a8-62f9e6804e2e', '1f04b223-8f58-436f-af6f-681db42332bf', 'f11f2cd3-d75b-4cef-a055-db2c931885e2', '2026-03-17 08:51:13.981644', '2026-03-17 09:51:13.981644', 'завершено');
INSERT INTO public.service_bookings VALUES ('204877df-327a-4e31-85ca-b2af2ebd3a1b', 'c981e255-247e-4c27-8beb-8bb9dbf78eb9', '79e34960-f2ee-4ca0-a93b-f172d2801a3b', '2025-11-08 10:54:59.968714', '2025-11-08 11:54:59.968714', 'завершено');
INSERT INTO public.service_bookings VALUES ('1839413f-7399-45dd-9a3b-22df0a1e19ac', 'f99887cb-b432-41e3-9ce3-6b20dc462be9', '79e34960-f2ee-4ca0-a93b-f172d2801a3b', '2025-07-24 03:33:04.827192', '2025-07-24 04:33:04.827192', 'завершено');
INSERT INTO public.service_bookings VALUES ('43e5a996-72f9-4be9-86ef-673da8054a60', 'e971575c-a0fd-47c8-8ab5-58b78d646868', '78af36a8-3047-4c4b-88b1-4ae5f1e795ef', '2026-02-16 15:37:22.410457', '2026-02-16 16:37:22.410457', 'отменено');
INSERT INTO public.service_bookings VALUES ('85ac91fd-5b67-4ce4-8175-20e94f7e8614', '58018845-9705-43dc-9c15-a09d315910a3', '78af36a8-3047-4c4b-88b1-4ae5f1e795ef', '2025-06-18 23:03:11.708449', '2025-06-19 00:03:11.708449', 'завершено');
INSERT INTO public.service_bookings VALUES ('b554f7b9-ece2-447c-9624-fbcf8c656112', '60b62f2f-242d-47fc-8733-67288ec30cd9', 'c557121d-38e8-49dd-8411-3d1d2c53f9fa', '2026-05-23 10:09:49.049262', '2026-05-23 11:09:49.049262', 'создано');
INSERT INTO public.service_bookings VALUES ('7477cee7-0ae7-465a-a5fd-be8aa608a0fc', 'dba6a4db-a2b6-4f7d-b0e5-ce6e23761239', 'c557121d-38e8-49dd-8411-3d1d2c53f9fa', '2026-05-14 06:07:21.745764', '2026-05-14 07:07:21.745764', 'подтверждено');
INSERT INTO public.service_bookings VALUES ('ef453c45-bbe9-406f-852a-e4d7650b7611', '7497a885-c6b8-47a9-b9cf-7303ffc510e5', '14e2e14a-d4ce-4068-90cf-ba3ffbcde32c', '2026-04-13 09:28:08.932742', '2026-04-13 10:28:08.932742', 'отменено');
INSERT INTO public.service_bookings VALUES ('9bea6e48-0f70-42d7-9603-59385a967f94', 'cb48e335-3ccb-4491-9160-703585b18669', '14e2e14a-d4ce-4068-90cf-ba3ffbcde32c', '2026-04-24 00:33:58.879013', '2026-04-24 01:33:58.879013', 'отменено');
INSERT INTO public.service_bookings VALUES ('b924eb67-c10c-49a7-9f3c-35b32b318187', '2f1d0954-38c3-4b92-9d51-3b6ebc5441c4', 'b58401d3-64f4-4bc4-8d6d-e2f36aca7e4a', '2025-11-29 17:58:04.250477', '2025-11-29 18:58:04.250477', 'завершено');
INSERT INTO public.service_bookings VALUES ('932438ff-3e8d-41a5-917b-bf61fae928f7', 'd363043a-9ff5-4b00-a7e2-e55cec25c791', 'b58401d3-64f4-4bc4-8d6d-e2f36aca7e4a', '2025-12-18 09:43:15.637579', '2025-12-18 10:43:15.637579', 'завершено');
INSERT INTO public.service_bookings VALUES ('84b8a142-d944-407d-a975-548e99d526d9', 'd363043a-9ff5-4b00-a7e2-e55cec25c791', 'a071ef39-68ac-4006-97f5-1dc52317656a', '2026-01-12 21:41:59.166083', '2026-01-12 22:41:59.166083', 'завершено');
INSERT INTO public.service_bookings VALUES ('4c809bbf-b241-4f17-adac-af0ed3a6aafb', 'a1dbaf18-010f-4427-a6ad-d007d9ba1333', 'feff420f-5bd1-44f3-921a-effd234f78fc', '2025-05-14 22:38:06.326852', '2025-05-14 23:38:06.326852', 'завершено');
INSERT INTO public.service_bookings VALUES ('e8d32ca2-2a5e-463e-b532-8eeaf0c69c47', 'a1dbaf18-010f-4427-a6ad-d007d9ba1333', '76f89faf-1ae6-4bc5-9a5f-538a211b3335', '2025-12-06 00:54:06.482639', '2025-12-06 01:54:06.482639', 'завершено');
INSERT INTO public.service_bookings VALUES ('f050f0d8-6d60-4b9d-b1aa-d6fd322970cf', '81bf8064-1d2f-4d5a-9f39-07110375123a', '556e29e7-2d94-43a9-941d-4637653afae6', '2026-01-24 13:00:18.740628', '2026-01-24 14:00:18.740628', 'отменено');
INSERT INTO public.service_bookings VALUES ('e7e81ad4-1d53-43f6-9bf2-afc6d26f3f0f', 'aa288965-0aa2-4c2e-a7de-083477479d18', 'b4a7a5a3-2d7f-4c77-81cc-d0084137c654', '2025-12-21 16:35:10.247688', '2025-12-21 17:35:10.247688', 'отменено');
INSERT INTO public.service_bookings VALUES ('bcd28140-3ec5-4c64-baa8-60a2ab232e1c', '4f615d69-3d65-4877-876c-6fea280c2a7f', 'b4a7a5a3-2d7f-4c77-81cc-d0084137c654', '2026-02-13 17:12:14.223382', '2026-02-13 18:12:14.223382', 'завершено');
INSERT INTO public.service_bookings VALUES ('7b2c1204-c39b-4a0d-b23c-66f3f3d0b6fc', '3a0fa377-7035-4d4b-84f2-238cb1df2ef9', '9332fe43-ec3b-4704-927b-faf98b9b9cc3', '2026-03-31 10:40:41.864', '2026-03-31 11:40:41.864', 'завершено');
INSERT INTO public.service_bookings VALUES ('b38e623c-499f-4aeb-a034-f2fc4bf31d9e', '98450b8d-0905-4226-9dc6-1afd8a993f43', '41694892-efd6-49d5-9965-f64407334fed', '2026-03-13 15:50:38.937468', '2026-03-13 16:50:38.937468', 'отменено');
INSERT INTO public.service_bookings VALUES ('ed63a1fd-9ed4-47b0-a38f-6d591dd805a3', '87466623-f080-4f82-aeb9-81ab0f5667c1', '2d4262e5-7171-471e-90ca-d9d4c0ac9afe', '2026-03-09 09:15:36.42067', '2026-03-09 10:15:36.42067', 'завершено');
INSERT INTO public.service_bookings VALUES ('41785e93-c23a-462c-b52c-07b16c3bfcd0', '98450b8d-0905-4226-9dc6-1afd8a993f43', '2d4262e5-7171-471e-90ca-d9d4c0ac9afe', '2024-11-24 23:29:02.857763', '2024-11-25 00:29:02.857763', 'завершено');
INSERT INTO public.service_bookings VALUES ('412ad266-446a-4298-b39e-723f94cbfd9d', 'dcd7159f-e028-421d-8101-0ff3f5143eaf', '4b8ec2d5-cb86-4b75-80e2-fa876f1d4360', '2026-05-17 22:12:15.993438', '2026-05-17 23:12:15.993438', 'ожидает_оплаты');
INSERT INTO public.service_bookings VALUES ('32c25350-ba8d-4cf8-a2a7-004a35d6b990', '5d63297b-3bb4-4502-8876-fa96ececd8c8', 'eba28432-e0e8-4e83-be5c-9d5e64b8f776', '2026-05-14 03:13:33.188178', '2026-05-14 04:13:33.188178', 'подтверждено');
INSERT INTO public.service_bookings VALUES ('3c255bff-e02d-4dbe-bac9-283bc876a2cc', '60b62f2f-242d-47fc-8733-67288ec30cd9', 'eba28432-e0e8-4e83-be5c-9d5e64b8f776', '2026-03-27 15:59:09.406658', '2026-03-27 16:59:09.406658', 'отменено');
INSERT INTO public.service_bookings VALUES ('aa27243a-9228-4613-95bf-2dde37cfc3c5', 'bbc6c4ec-4fdc-4e2a-9629-7b78dda47f45', '607733fe-e0af-4227-833e-a877633f5bd3', '2025-08-28 08:51:47.870726', '2025-08-28 09:51:47.870726', 'завершено');
INSERT INTO public.service_bookings VALUES ('7fba2bab-f4cd-42b3-b52c-289a3db87cd6', 'ea07fce7-c070-43e9-81a8-b7c8ed41f7ca', '607733fe-e0af-4227-833e-a877633f5bd3', '2025-09-04 00:44:43.839998', '2025-09-04 01:44:43.839998', 'завершено');
INSERT INTO public.service_bookings VALUES ('96306422-c406-4244-beab-ab03dc31cf85', '50415186-3332-433e-af65-2f20740958c2', '58a3b6bf-3bce-4522-a54f-486c75f6c406', '2026-06-05 15:12:15.725767', '2026-06-05 16:12:15.725767', 'ожидает_оплаты');
INSERT INTO public.service_bookings VALUES ('b7612759-4bc6-4928-97c4-eebf2457437a', '045673b9-16df-4f91-8cd2-171713672717', '1d02b5a7-00d0-4348-9e05-cd2395dbfd8d', '2026-05-09 17:04:02.128882', '2026-05-09 18:04:02.128882', 'создано');
INSERT INTO public.service_bookings VALUES ('1cc4bc2d-5e50-4156-81ad-42b7ededfd1a', '927214ec-059d-45e5-8560-cc0918fcb4e4', '9205964d-8372-4563-89d4-b549d3d1ab01', '2025-08-30 05:20:14.547929', '2025-08-30 06:20:14.547929', 'завершено');
INSERT INTO public.service_bookings VALUES ('35899bea-d9b9-4aa0-8e72-738c1efa07c7', '2c2537e8-5b49-4ebb-8e4b-15844d6e50a5', '87c81a7f-b8b9-4aa7-8c7c-5e252447dc0c', '2025-12-30 21:15:21.323497', '2025-12-30 22:15:21.323497', 'завершено');
INSERT INTO public.service_bookings VALUES ('2e4c25f7-9955-4571-84b7-4fadd71ef026', 'f5558bec-45a7-4945-b042-0fdd506e97ea', '295e6eb5-15d9-4d1f-b648-5a1d7d1b15b2', '2026-06-07 01:14:25.071203', '2026-06-07 02:14:25.071203', 'создано');
INSERT INTO public.service_bookings VALUES ('3bf648c6-4d54-49b7-a718-e3e48c141232', '80a4d0cb-3e52-4877-8468-35cb9ff14c03', '5614c63e-b164-439a-bfad-ad68b28d05f5', '2026-04-25 15:01:21.578021', '2026-04-25 16:01:21.578021', 'завершено');
INSERT INTO public.service_bookings VALUES ('22bde857-5afa-4969-aba5-e43fcc53d6fc', '97ca912e-ed47-4d19-931a-042ab796d020', '29199910-4a41-4c96-98af-484385e37f24', '2024-11-20 11:12:54.656625', '2024-11-20 12:12:54.656625', 'завершено');
INSERT INTO public.service_bookings VALUES ('3c8ee60c-8f86-4fde-a6f8-c3132b5d0022', '6d6e94a8-b716-4fc2-9748-78ea1d89e70f', '29199910-4a41-4c96-98af-484385e37f24', '2025-11-06 00:03:29.119078', '2025-11-06 01:03:29.119078', 'клиент_не_явился');
INSERT INTO public.service_bookings VALUES ('7928499e-75be-4958-8916-529c0e99346a', '4c15a4e4-9975-43ee-9f5f-393a8eb7efc0', '29199910-4a41-4c96-98af-484385e37f24', '2025-08-27 14:02:49.003975', '2025-08-27 15:02:49.003975', 'клиент_не_явился');


--
-- TOC entry 4996 (class 0 OID 24798)
-- Dependencies: 222
-- Data for Name: service_reviews; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.service_reviews VALUES ('acb0b610-a7d9-4879-9711-4da70fe7e263', 3, 'Цена полностью оправдывает качество.', '2024-11-26', '3ce33320-57bb-4b2e-8fdb-852faaa4635f');
INSERT INTO public.service_reviews VALUES ('52b5b0eb-a812-428b-89b5-499a53d92996', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-02-12', '0ba5b51c-1264-4a9a-927e-c9db823d88ab');
INSERT INTO public.service_reviews VALUES ('aee36669-822f-41df-a61d-5d291ce375d9', 5, 'Лучшая инвестиция в мой бизнес за этот год!', '2026-04-26', '1510607a-86ec-49cf-8bb5-7a804848db79');
INSERT INTO public.service_reviews VALUES ('a1179a93-594b-41a6-8e95-5c314eb81409', 2, 'Зря потратил время и деньги.', '2026-04-14', 'ccd40085-3c63-42db-b9c2-9067fb3a6ed1');
INSERT INTO public.service_reviews VALUES ('3e3d207d-f1e1-47fd-a954-894d0ada962f', 1, 'Зря потратил время и деньги.', '2025-12-24', '55020d37-6381-4758-b927-fa88d14a08aa');
INSERT INTO public.service_reviews VALUES ('add411ef-2f13-4ad2-bc4f-fdfa07ca7b93', 4, 'Специалист — профессионал своего дела, рекомендую.', '2026-04-01', '372744bf-4875-48cf-9a66-f1d37ddb51d0');
INSERT INTO public.service_reviews VALUES ('932324bc-cd56-4a74-a373-a0c0bd6bbe83', 3, 'Цена полностью оправдывает качество.', '2026-03-20', '93bc0826-7556-4ce4-80af-bf335bef8241');
INSERT INTO public.service_reviews VALUES ('866dfeb0-5f95-4188-85bd-8aa590e12966', 2, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-09-28', 'e5076dfa-78af-4b1b-a22a-a61f2d0a8341');
INSERT INTO public.service_reviews VALUES ('20bb3da8-3877-41a4-b777-afe8bfaf4ea0', 3, 'Цена полностью оправдывает качество.', '2025-11-07', '8068f63c-04f7-48e7-94f8-e23fb1160c4e');
INSERT INTO public.service_reviews VALUES ('158bbb6f-4a39-49bf-9a7e-407a23f52031', 2, 'Много воды, хотелось бы больше практики.', '2025-12-12', '95d7127d-ddef-4386-a008-0c90900c899e');
INSERT INTO public.service_reviews VALUES ('02f1728e-af6c-40cf-be89-f67a886cd81b', 1, 'Много воды, хотелось бы больше практики.', '2024-10-29', '4e1090be-814a-4faa-8844-06e8c1d8526d');
INSERT INTO public.service_reviews VALUES ('f8ba3f26-fd40-4cb5-92b5-17691c39c6fa', 5, 'Лучшая инвестиция в мой бизнес за этот год!', '2026-02-16', '23acec67-fcf8-4534-9bf9-e80681a81938');
INSERT INTO public.service_reviews VALUES ('19e1730d-564a-4d43-b3c0-edabe0902966', 2, 'Много воды, хотелось бы больше практики.', '2026-03-09', 'af53c755-8862-47c3-9aab-a6aa889fac94');
INSERT INTO public.service_reviews VALUES ('a00a3a91-a014-4172-b4ab-8426b78c0eda', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2026-03-14', 'e4305593-a098-404c-94ed-47f8aa691c5d');
INSERT INTO public.service_reviews VALUES ('e225d355-1320-43d8-94ea-6f0eab5b6c88', 4, 'Специалист — профессионал своего дела, рекомендую.', '2026-04-11', '43b8c3f3-60c8-4e66-91fb-0b70edbf44e5');
INSERT INTO public.service_reviews VALUES ('9037d4f2-c04b-4246-915d-81628e257bb6', 1, 'Зря потратил время и деньги.', '2026-01-31', '2c04c2f6-acf6-4e35-8b12-9cd6632fbbde');
INSERT INTO public.service_reviews VALUES ('887e199b-445b-4cd3-ac45-804094f01fd6', 4, 'Лучшая инвестиция в мой бизнес за этот год!', '2026-01-13', '0614d257-507c-4d8a-beb9-fb263d7e3fe7');
INSERT INTO public.service_reviews VALUES ('4b9d671c-441d-4006-bce6-554234413300', 4, 'Лучшая инвестиция в мой бизнес за этот год!', '2026-04-02', '83cbf7a9-0f05-4400-9de7-ae24818f7258');
INSERT INTO public.service_reviews VALUES ('373f1651-d805-4bd7-b755-2afb2fbaae7e', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2026-02-16', '819089e1-8268-4061-953f-9364daccdd83');
INSERT INTO public.service_reviews VALUES ('c7f0c6c5-dcd9-40be-a38f-bfcd9d22337b', 3, 'Цена полностью оправдывает качество.', '2025-12-04', '08ae25e5-c902-4bf8-8190-16890f585a2f');
INSERT INTO public.service_reviews VALUES ('e3f82305-9de6-4b4a-b721-ca770cd7d84b', 4, 'Отличный материал, очень помогло!', '2026-04-22', '4f6bc62d-650c-4a5f-8171-6b2e8e07e4c9');
INSERT INTO public.service_reviews VALUES ('25494f08-f4c2-49c4-816b-06fdffbedaf6', 1, 'Много воды, хотелось бы больше практики.', '2026-03-19', 'eff2a1d3-6163-4d37-98a8-62f9e6804e2e');
INSERT INTO public.service_reviews VALUES ('5f9efc8d-3643-4311-9070-70b208cd0960', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-11-10', '204877df-327a-4e31-85ca-b2af2ebd3a1b');
INSERT INTO public.service_reviews VALUES ('f95be384-26d3-4750-8ef7-3d898607c802', 1, 'Много воды, хотелось бы больше практики.', '2025-07-28', '1839413f-7399-45dd-9a3b-22df0a1e19ac');
INSERT INTO public.service_reviews VALUES ('3af2a1d3-0bdb-40fe-b373-eb5de0d47cf7', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2026-02-21', '43e5a996-72f9-4be9-86ef-673da8054a60');
INSERT INTO public.service_reviews VALUES ('dd4809d7-deb4-4282-980c-7ac135533ad7', 3, 'Материал хороший, но подача немного сухая.', '2025-06-23', '85ac91fd-5b67-4ce4-8175-20e94f7e8614');
INSERT INTO public.service_reviews VALUES ('905087f3-5e4e-4b3b-abf9-75605e592826', 2, 'Много воды, хотелось бы больше практики.', '2026-04-26', '9bea6e48-0f70-42d7-9603-59385a967f94');
INSERT INTO public.service_reviews VALUES ('00804658-3d44-4e49-83e5-cf0823f3bcf5', 3, 'Остались некоторые вопросы, но в целом неплохо.', '2025-12-02', 'b924eb67-c10c-49a7-9f3c-35b32b318187');
INSERT INTO public.service_reviews VALUES ('0bcc7481-7109-428f-8312-face587f1345', 4, 'Специалист — профессионал своего дела, рекомендую.', '2025-12-19', '932438ff-3e8d-41a5-917b-bf61fae928f7');
INSERT INTO public.service_reviews VALUES ('99714ad8-40c3-4f22-ba67-b490a2c0641e', 4, 'Специалист — профессионал своего дела, рекомендую.', '2026-01-15', '84b8a142-d944-407d-a975-548e99d526d9');
INSERT INTO public.service_reviews VALUES ('3a992d4d-ec63-4894-98e1-630d90ab1cd2', 1, 'Много воды, хотелось бы больше практики.', '2025-12-09', 'e8d32ca2-2a5e-463e-b532-8eeaf0c69c47');
INSERT INTO public.service_reviews VALUES ('ace8e925-f025-440a-ad8e-03df058c5009', 1, 'Много воды, хотелось бы больше практики.', '2026-03-15', 'b38e623c-499f-4aeb-a034-f2fc4bf31d9e');
INSERT INTO public.service_reviews VALUES ('5e1464c1-008d-4f42-9838-f0d69bd283cf', 3, 'Материал хороший, но подача немного сухая.', '2026-03-11', 'ed63a1fd-9ed4-47b0-a38f-6d591dd805a3');
INSERT INTO public.service_reviews VALUES ('d367c369-0192-4d4e-9d5b-e407ae7935f5', 4, 'Спасибо, всё четко и по делу.', '2024-11-27', '41785e93-c23a-462c-b52c-07b16c3bfcd0');
INSERT INTO public.service_reviews VALUES ('e7286434-a15e-470b-9f4a-8904aaaff23f', 5, 'Спасибо, всё четко и по делу.', '2025-08-31', 'aa27243a-9228-4613-95bf-2dde37cfc3c5');
INSERT INTO public.service_reviews VALUES ('cb8c179a-53e5-4946-8699-ddaa911136ba', 2, 'Много воды, хотелось бы больше практики.', '2025-08-31', '1cc4bc2d-5e50-4156-81ad-42b7ededfd1a');
INSERT INTO public.service_reviews VALUES ('764f4798-0c9d-4acf-91db-b002fd2da34e', 2, 'Много воды, хотелось бы больше практики.', '2026-01-01', '35899bea-d9b9-4aa0-8e72-738c1efa07c7');
INSERT INTO public.service_reviews VALUES ('1e1997a1-fd2c-40d3-9dc0-3e02ed5711bf', 2, 'Зря потратил время и деньги.', '2026-04-26', '3bf648c6-4d54-49b7-a718-e3e48c141232');
INSERT INTO public.service_reviews VALUES ('a920fd13-4198-4481-a6b2-be36db53fafc', 1, 'Не узнал ничего нового, всё есть в открытом доступе.', '2025-11-08', '3c8ee60c-8f86-4fde-a6f8-c3132b5d0022');
INSERT INTO public.service_reviews VALUES ('35e74980-2c57-44f0-8107-588ccd066418', 4, 'Лучшая инвестиция в мой бизнес за этот год!', '2025-08-29', '7928499e-75be-4958-8916-529c0e99346a');


--
-- TOC entry 4997 (class 0 OID 24806)
-- Dependencies: 223
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.services VALUES ('1f04b223-8f58-436f-af6f-681db42332bf', '5089dd27-b02f-469d-910c-34dfb52642c2', 'Разбор фин. модели', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 45, 4900.60);
INSERT INTO public.services VALUES ('98450b8d-0905-4226-9dc6-1afd8a993f43', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', 'Внедрение CRM системы', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 45, 16604.44);
INSERT INTO public.services VALUES ('a65d4636-b9a8-4794-97de-5c934f69871d', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', 'Разработка бизнес-плана', 'Индивидуальная онлайн-встреча. Разберем вашу нишу и подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 90, 8946.07);
INSERT INTO public.services VALUES ('045673b9-16df-4f91-8cd2-171713672717', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', 'Внедрение CRM системы', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 90, 16109.92);
INSERT INTO public.services VALUES ('80a4d0cb-3e52-4877-8468-35cb9ff14c03', '07beb9d4-b4e3-407d-b017-c892dc1f769a', 'Разработка бизнес-плана', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 60, 2040.73);
INSERT INTO public.services VALUES ('dba6a4db-a2b6-4f7d-b0e5-ce6e23761239', 'e0599544-24eb-416b-b10b-306d34f3f419', 'Разбор фин. модели', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 45, 6770.02);
INSERT INTO public.services VALUES ('0913d756-5673-4fbb-acfe-2692ac9b8fb8', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', 'Разбор фин. модели', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 60, 6481.33);
INSERT INTO public.services VALUES ('917954aa-3fa3-43fa-92b4-4ee00af7cc55', '70b799ac-1620-4271-bc9d-ce54a41c3682', 'Разбор фин. модели', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 150, 9191.16);
INSERT INTO public.services VALUES ('ea07fce7-c070-43e9-81a8-b7c8ed41f7ca', 'b407ec89-876f-43ed-ba50-289e55fbd869', 'Разработка бизнес-плана', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 60, 11673.11);
INSERT INTO public.services VALUES ('e971575c-a0fd-47c8-8ab5-58b78d646868', '88d891ed-928c-4a23-a572-6855b60c50b7', 'Разработка бизнес-плана', 'Помогу выстроить прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 180, 7513.64);
INSERT INTO public.services VALUES ('8ef3e89f-a640-46d8-8c25-693ddae54df9', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', 'Построение отдела продаж', 'Индивидуальная онлайн-встреча. Разберем вашу нишу и подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 30, 10506.73);
INSERT INTO public.services VALUES ('d1b63de3-38b8-4b16-9a59-b3cd9b50e8b1', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', 'Консультация по налогам ИП/ООО', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 150, 16954.71);
INSERT INTO public.services VALUES ('db1af11e-469b-40a7-b85c-e0b88369ce17', '5089dd27-b02f-469d-910c-34dfb52642c2', 'Аудит маркетинговой стратегии', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 45, 12112.79);
INSERT INTO public.services VALUES ('87466623-f080-4f82-aeb9-81ab0f5667c1', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', 'Построение отдела продаж', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 90, 6224.94);
INSERT INTO public.services VALUES ('4701b341-55ca-4f7f-8c97-86435779f58d', 'e69deca2-7193-49e0-8e9f-daee0420a875', 'Оптимизация логистики', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 120, 14884.95);
INSERT INTO public.services VALUES ('ba3a0175-c053-4173-ba00-245db4645a69', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', 'Построение отдела продаж', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 180, 16845.69);
INSERT INTO public.services VALUES ('76412a7a-35da-403f-b13a-1579129ea0f3', '07beb9d4-b4e3-407d-b017-c892dc1f769a', 'HR-стратегия и найм', 'Индивидуальная онлайн-встреча. Разберем вашу нишу и подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 150, 9780.19);
INSERT INTO public.services VALUES ('2f1d0954-38c3-4b92-9d51-3b6ebc5441c4', 'a50c19d0-a789-473b-994d-52b9212cee87', 'Построение отдела продаж', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 120, 5245.12);
INSERT INTO public.services VALUES ('cb48e335-3ccb-4491-9160-703585b18669', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', 'HR-стратегия и найм', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 150, 19099.19);
INSERT INTO public.services VALUES ('2c2537e8-5b49-4ebb-8e4b-15844d6e50a5', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', 'HR-стратегия и найм', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 30, 13036.83);
INSERT INTO public.services VALUES ('7497a885-c6b8-47a9-b9cf-7303ffc510e5', '88d891ed-928c-4a23-a572-6855b60c50b7', 'Внедрение CRM системы', 'Индивидуальная онлайн-встреча. Разберем вашу нишу и подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 90, 8163.57);
INSERT INTO public.services VALUES ('4c15a4e4-9975-43ee-9f5f-393a8eb7efc0', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', 'Разработка бизнес-плана', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 60, 18707.68);
INSERT INTO public.services VALUES ('c981e255-247e-4c27-8beb-8bb9dbf78eb9', '86d6b656-583a-4227-9f10-7b763b3f3ea1', 'Консультация по налогам ИП/ООО', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 120, 15136.78);
INSERT INTO public.services VALUES ('4ce619db-8f29-47a9-aed8-97284db5668b', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', 'Разбор фин. модели', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 30, 12408.79);
INSERT INTO public.services VALUES ('106bbda2-c829-46f7-b2ee-53389dc5a7df', '07beb9d4-b4e3-407d-b017-c892dc1f769a', 'Разработка бизнес-плана', 'Индивидуальная онлайн-встреча. Разберем вашу нишу и подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 90, 15047.69);
INSERT INTO public.services VALUES ('f5558bec-45a7-4945-b042-0fdd506e97ea', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', 'Разработка бизнес-плана', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 180, 10524.76);
INSERT INTO public.services VALUES ('aa288965-0aa2-4c2e-a7de-083477479d18', '88d891ed-928c-4a23-a572-6855b60c50b7', 'HR-стратегия и найм', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 45, 3334.41);
INSERT INTO public.services VALUES ('6d6e94a8-b716-4fc2-9748-78ea1d89e70f', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', 'Консультация по налогам ИП/ООО', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 180, 2777.67);
INSERT INTO public.services VALUES ('f5e0b0ca-f27f-4e9d-a0a4-1dbbee607aae', '757e2a9d-624f-4bd2-a7ec-48331ca16a31', 'Аудит маркетинговой стратегии', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 45, 16789.88);
INSERT INTO public.services VALUES ('3a0fa377-7035-4d4b-84f2-238cb1df2ef9', '5089dd27-b02f-469d-910c-34dfb52642c2', 'Разбор фин. модели', 'Помогу выстроить прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 90, 8311.16);
INSERT INTO public.services VALUES ('7e0a1c54-56d5-4341-aff6-8a215c65a392', '07beb9d4-b4e3-407d-b017-c892dc1f769a', 'Анализ конкурентов', 'Индивидуальная онлайн-встреча. Разберем вашу нишу и подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 30, 4484.64);
INSERT INTO public.services VALUES ('f99887cb-b432-41e3-9ce3-6b20dc462be9', '582ada26-484e-4377-a94d-2761381c578b', 'Аудит маркетинговой стратегии', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 45, 17605.28);
INSERT INTO public.services VALUES ('bbc6c4ec-4fdc-4e2a-9629-7b78dda47f45', '582ada26-484e-4377-a94d-2761381c578b', 'HR-стратегия и найм', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 120, 1677.40);
INSERT INTO public.services VALUES ('c42de817-6553-4fd2-9f6c-29bb82e981a0', '5089dd27-b02f-469d-910c-34dfb52642c2', 'Построение отдела продаж', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 90, 7897.58);
INSERT INTO public.services VALUES ('927214ec-059d-45e5-8560-cc0918fcb4e4', '4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', 'Анализ конкурентов', 'Помогу выстроить прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 30, 8096.21);
INSERT INTO public.services VALUES ('3a0d6511-9176-4ab6-a133-7229bb7f7037', 'a50c19d0-a789-473b-994d-52b9212cee87', 'Оптимизация логистики', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 30, 16779.51);
INSERT INTO public.services VALUES ('8161e4da-e19c-4a24-a1d3-bca8f12a0644', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', 'Разработка бизнес-плана', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 30, 17090.93);
INSERT INTO public.services VALUES ('93b78a2c-4505-4931-af60-60e07d09dc15', '174f4d28-2b01-4a54-b27a-76a50b600e50', 'Построение отдела продаж', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 150, 12600.39);
INSERT INTO public.services VALUES ('60b62f2f-242d-47fc-8733-67288ec30cd9', '07beb9d4-b4e3-407d-b017-c892dc1f769a', 'HR-стратегия и найм', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 60, 18542.71);
INSERT INTO public.services VALUES ('5d63297b-3bb4-4502-8876-fa96ececd8c8', '70b799ac-1620-4271-bc9d-ce54a41c3682', 'Разработка бизнес-плана', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 150, 15038.85);
INSERT INTO public.services VALUES ('e15b728e-1134-4bfe-9771-ed7900f374aa', 'a50c19d0-a789-473b-994d-52b9212cee87', 'Разбор фин. модели', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 150, 13799.76);
INSERT INTO public.services VALUES ('d858e9a6-ed60-4930-ae60-02971e807ae9', 'a50c19d0-a789-473b-994d-52b9212cee87', 'Разработка бизнес-плана', 'Помогу выстроить прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 60, 2835.41);
INSERT INTO public.services VALUES ('cdb0813b-d943-4207-9a8d-408f2b2fc7c8', '174f4d28-2b01-4a54-b27a-76a50b600e50', 'Оптимизация логистики', 'Помогу выстроить прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 30, 19087.62);
INSERT INTO public.services VALUES ('29cc7cbe-6d31-49c2-8cef-725566b80438', 'a50c19d0-a789-473b-994d-52b9212cee87', 'Консультация по налогам ИП/ООО', 'Помогу выстроить прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 30, 18179.59);
INSERT INTO public.services VALUES ('4f615d69-3d65-4877-876c-6fea280c2a7f', 'e69deca2-7193-49e0-8e9f-daee0420a875', 'Построение отдела продаж', 'Помогу выстроить прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 45, 11117.92);
INSERT INTO public.services VALUES ('97ca912e-ed47-4d19-931a-042ab796d020', '174f4d28-2b01-4a54-b27a-76a50b600e50', 'Построение отдела продаж', 'Помогу выстроить прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 120, 10012.39);
INSERT INTO public.services VALUES ('50415186-3332-433e-af65-2f20740958c2', 'bb90ff09-cafb-4403-92a2-07d928d8daa9', 'Разбор фин. модели', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 120, 18393.35);
INSERT INTO public.services VALUES ('dcd7159f-e028-421d-8101-0ff3f5143eaf', 'e69deca2-7193-49e0-8e9f-daee0420a875', 'Разбор фин. модели', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 30, 13801.12);
INSERT INTO public.services VALUES ('58018845-9705-43dc-9c15-a09d315910a3', '174f4d28-2b01-4a54-b27a-76a50b600e50', 'Аудит маркетинговой стратегии', 'Индивидуальная онлайн-встреча. Разберем вашу нишу и подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 60, 17761.22);
INSERT INTO public.services VALUES ('e6f5427e-f9ef-4492-90d0-3384f045caa5', 'a50c19d0-a789-473b-994d-52b9212cee87', 'Построение отдела продаж', 'Помогу выстроить прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 90, 6199.11);
INSERT INTO public.services VALUES ('04754527-6492-4a48-ab1f-e611c15a43d5', 'eb2a31b9-8e64-4f7e-86a7-03678d49994b', 'Разработка бизнес-плана', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 180, 8944.93);
INSERT INTO public.services VALUES ('c3f0a581-6c19-474c-acab-5202b120d603', 'ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', 'Анализ конкурентов', 'Индивидуальная онлайн-встреча. Разберем вашу нишу и подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 60, 7999.32);
INSERT INTO public.services VALUES ('d363043a-9ff5-4b00-a7e2-e55cec25c791', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', 'Аудит маркетинговой стратегии', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 30, 6652.63);
INSERT INTO public.services VALUES ('33bf7362-3a96-4292-9f62-b1a3e6641c85', 'b3df3dff-3594-4c43-b9da-4b936d7f1282', 'HR-стратегия и найм', 'Помогу выстроить прозрачную систему мотивации и KPI для ваших сотрудников, чтобы они работали на результат.', 150, 19859.04);
INSERT INTO public.services VALUES ('b0791fea-9c6b-4c36-afdf-ed1374ae8c82', '6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', 'Построение отдела продаж', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 90, 7534.92);
INSERT INTO public.services VALUES ('7533296e-2121-4402-9bf0-291a25dcd72a', '174f4d28-2b01-4a54-b27a-76a50b600e50', 'Оптимизация логистики', 'Индивидуальная онлайн-встреча. Разберем вашу нишу и подберем оптимальный налоговый режим, чтобы не переплачивать государству.', 30, 17422.42);
INSERT INTO public.services VALUES ('81bf8064-1d2f-4d5a-9f39-07110375123a', '6c7c202c-6e67-4771-8e6d-cea923775928', 'Разбор фин. модели', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 120, 14977.30);
INSERT INTO public.services VALUES ('6164a3a4-6195-406b-ad0e-5249458b43ac', '174f4d28-2b01-4a54-b27a-76a50b600e50', 'Разбор фин. модели', 'Глубокий анализ ваших бизнес-процессов с предоставлением письменного отчета и рекомендаций по автоматизации и снижению издержек.', 90, 6009.89);
INSERT INTO public.services VALUES ('a1dbaf18-010f-4427-a6ad-d007d9ba1333', '174f4d28-2b01-4a54-b27a-76a50b600e50', 'Оптимизация логистики', 'Сессия вопрос-ответ с детальным погружением в специфику вашего бизнеса. Только практические советы.', 90, 11675.10);
INSERT INTO public.services VALUES ('4ed2e7ce-017b-4c91-9edb-d04efeb32305', '9410282f-eb82-40e3-bf8d-3a0fa6f0deed', 'Анализ конкурентов', 'Детальный разбор вашей текущей ситуации. Найдем узкие места и составим пошаговый план по увеличению конверсии и выручки.', 60, 4625.59);


--
-- TOC entry 4998 (class 0 OID 24812)
-- Dependencies: 224
-- Data for Name: specialist_categories; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.specialist_categories VALUES ('9410282f-eb82-40e3-bf8d-3a0fa6f0deed', '7f89048c-c357-4f73-89f4-bc0136aa56f1', 'Независимый аудитор');
INSERT INTO public.specialist_categories VALUES ('b407ec89-876f-43ed-ba50-289e55fbd869', '52dddffe-6633-45c8-8eb9-49dc8143c6ed', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('b407ec89-876f-43ed-ba50-289e55fbd869', '6777ef7c-3af1-4264-8ed7-f22951191744', 'Уровень Senior');
INSERT INTO public.specialist_categories VALUES ('b407ec89-876f-43ed-ba50-289e55fbd869', '132651b5-507d-41b0-b5b6-0e8cfca64368', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('07beb9d4-b4e3-407d-b017-c892dc1f769a', '7f89048c-c357-4f73-89f4-bc0136aa56f1', 'Lead-специалист');
INSERT INTO public.specialist_categories VALUES ('07beb9d4-b4e3-407d-b017-c892dc1f769a', '632f2903-c1a9-4cc8-aef7-9e7012348677', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('07beb9d4-b4e3-407d-b017-c892dc1f769a', 'f8b6dcd4-b85a-470d-9cbb-5387a0ce9d0a', 'Lead-специалист');
INSERT INTO public.specialist_categories VALUES ('174f4d28-2b01-4a54-b27a-76a50b600e50', '6777ef7c-3af1-4264-8ed7-f22951191744', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('174f4d28-2b01-4a54-b27a-76a50b600e50', 'f8b6dcd4-b85a-470d-9cbb-5387a0ce9d0a', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('a50c19d0-a789-473b-994d-52b9212cee87', '52dddffe-6633-45c8-8eb9-49dc8143c6ed', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('5089dd27-b02f-469d-910c-34dfb52642c2', 'f8b6dcd4-b85a-470d-9cbb-5387a0ce9d0a', 'Уровень Senior');
INSERT INTO public.specialist_categories VALUES ('e69deca2-7193-49e0-8e9f-daee0420a875', '632f2903-c1a9-4cc8-aef7-9e7012348677', 'Независимый аудитор');
INSERT INTO public.specialist_categories VALUES ('70b799ac-1620-4271-bc9d-ce54a41c3682', 'a7e9fadf-3921-466b-8bda-b68c904f855a', 'Уровень Senior');
INSERT INTO public.specialist_categories VALUES ('86d6b656-583a-4227-9f10-7b763b3f3ea1', '6777ef7c-3af1-4264-8ed7-f22951191744', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('86d6b656-583a-4227-9f10-7b763b3f3ea1', 'f8b6dcd4-b85a-470d-9cbb-5387a0ce9d0a', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('582ada26-484e-4377-a94d-2761381c578b', '6777ef7c-3af1-4264-8ed7-f22951191744', 'Lead-специалист');
INSERT INTO public.specialist_categories VALUES ('582ada26-484e-4377-a94d-2761381c578b', '632f2903-c1a9-4cc8-aef7-9e7012348677', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('b3df3dff-3594-4c43-b9da-4b936d7f1282', 'a4257156-4c00-456b-bd0b-6af4aabffdd2', 'Lead-специалист');
INSERT INTO public.specialist_categories VALUES ('4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '7f89048c-c357-4f73-89f4-bc0136aa56f1', 'Уровень Middle');
INSERT INTO public.specialist_categories VALUES ('4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '632f2903-c1a9-4cc8-aef7-9e7012348677', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', 'a4257156-4c00-456b-bd0b-6af4aabffdd2', 'Lead-специалист');
INSERT INTO public.specialist_categories VALUES ('6c7c202c-6e67-4771-8e6d-cea923775928', '6777ef7c-3af1-4264-8ed7-f22951191744', 'Уровень Middle');
INSERT INTO public.specialist_categories VALUES ('6c7c202c-6e67-4771-8e6d-cea923775928', '132651b5-507d-41b0-b5b6-0e8cfca64368', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('bb90ff09-cafb-4403-92a2-07d928d8daa9', 'a4257156-4c00-456b-bd0b-6af4aabffdd2', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('bb90ff09-cafb-4403-92a2-07d928d8daa9', '52dddffe-6633-45c8-8eb9-49dc8143c6ed', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('eb2a31b9-8e64-4f7e-86a7-03678d49994b', 'f8b6dcd4-b85a-470d-9cbb-5387a0ce9d0a', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('eb2a31b9-8e64-4f7e-86a7-03678d49994b', '52dddffe-6633-45c8-8eb9-49dc8143c6ed', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('e0599544-24eb-416b-b10b-306d34f3f419', '6777ef7c-3af1-4264-8ed7-f22951191744', 'Уровень Middle');
INSERT INTO public.specialist_categories VALUES ('757e2a9d-624f-4bd2-a7ec-48331ca16a31', 'a7e9fadf-3921-466b-8bda-b68c904f855a', 'Уровень Middle');
INSERT INTO public.specialist_categories VALUES ('757e2a9d-624f-4bd2-a7ec-48331ca16a31', 'a4257156-4c00-456b-bd0b-6af4aabffdd2', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('757e2a9d-624f-4bd2-a7ec-48331ca16a31', '6777ef7c-3af1-4264-8ed7-f22951191744', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', 'a4257156-4c00-456b-bd0b-6af4aabffdd2', 'Ментор и наставник');
INSERT INTO public.specialist_categories VALUES ('ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', '52dddffe-6633-45c8-8eb9-49dc8143c6ed', 'Независимый аудитор');
INSERT INTO public.specialist_categories VALUES ('6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '7f89048c-c357-4f73-89f4-bc0136aa56f1', 'Практикующий эксперт');
INSERT INTO public.specialist_categories VALUES ('6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '52dddffe-6633-45c8-8eb9-49dc8143c6ed', 'Независимый аудитор');
INSERT INTO public.specialist_categories VALUES ('6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', 'a4257156-4c00-456b-bd0b-6af4aabffdd2', 'Консультант-аналитик');
INSERT INTO public.specialist_categories VALUES ('88d891ed-928c-4a23-a572-6855b60c50b7', '6777ef7c-3af1-4264-8ed7-f22951191744', 'Независимый аудитор');
INSERT INTO public.specialist_categories VALUES ('88d891ed-928c-4a23-a572-6855b60c50b7', '132651b5-507d-41b0-b5b6-0e8cfca64368', 'Lead-специалист');


--
-- TOC entry 4999 (class 0 OID 24817)
-- Dependencies: 225
-- Data for Name: specialist_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.specialist_profiles VALUES ('9410282f-eb82-40e3-bf8d-3a0fa6f0deed', 'de75a2a8-50d0-438c-9305-27501f1904c2', 'Кризис-менеджер с опытом работы в ритейле. Оптимизирую расходы и сохраняю эффективность команды в турбулентные времена.', 18, '2025-06-18', 'active');
INSERT INTO public.specialist_profiles VALUES ('b407ec89-876f-43ed-ba50-289e55fbd869', '96d5b621-4431-4e00-9263-3d566f4f349c', 'Корпоративный юрист с 15-летним стажем. Защита интеллектуальной собственности, составление сложных договоров и представительство в суде.', 16, '2024-06-13', 'active');
INSERT INTO public.specialist_profiles VALUES ('07beb9d4-b4e3-407d-b017-c892dc1f769a', 'f24aad0e-0ce5-4767-a38d-09d32c7d07a6', 'IT-архитектор. Внедряю Битрикс24, amoCRM и 1С. Автоматизирую рутину, чтобы вы могли заниматься только стратегией.', 3, '2025-03-09', 'active');
INSERT INTO public.specialist_profiles VALUES ('174f4d28-2b01-4a54-b27a-76a50b600e50', 'b3321f3e-cbcd-46f8-acb4-f337d59c4e0f', 'Профессиональный HR-партнер. Знаю, как схантить лучших специалистов на рынке и снизить текучку кадров в 2 раза.', 8, '2024-08-23', 'suspended');
INSERT INTO public.specialist_profiles VALUES ('a50c19d0-a789-473b-994d-52b9212cee87', 'dededfca-a1ea-4324-9731-8d2352dd4298', 'Помогаю бизнесу расти. Более 10 лет в B2B продажах, выстроил отделы продаж для 15 крупных компаний.', 3, '2024-06-08', 'active');
INSERT INTO public.specialist_profiles VALUES ('5089dd27-b02f-469d-910c-34dfb52642c2', 'aa9bf891-e1cd-4ccb-a693-7e59b4819456', 'Кризис-менеджер с опытом работы в ритейле. Оптимизирую расходы и сохраняю эффективность команды в турбулентные времена.', 20, '2024-11-05', 'active');
INSERT INTO public.specialist_profiles VALUES ('e69deca2-7193-49e0-8e9f-daee0420a875', 'a38bb4e0-b02e-4088-9486-6d4a9d70c0ca', 'Помогаю бизнесу расти. Более 10 лет в B2B продажах, выстроил отделы продаж для 15 крупных компаний.', 6, '2024-07-17', 'active');
INSERT INTO public.specialist_profiles VALUES ('70b799ac-1620-4271-bc9d-ce54a41c3682', '185d4602-6b48-4cf4-934a-4af5acb1262f', 'Эксперт по маркетплейсам. Вывожу товары в ТОП на Wildberries и Ozon. Управляю рекламными бюджетами от 1 млн рублей.', 5, '2025-05-09', 'active');
INSERT INTO public.specialist_profiles VALUES ('86d6b656-583a-4227-9f10-7b763b3f3ea1', 'e96670b8-3449-4182-bc61-122beb179513', 'Сертифицированный аудитор. Разберу ваши финансы, найду кассовые разрывы и легально снижу налоговую нагрузку.', 3, '2025-07-07', 'active');
INSERT INTO public.specialist_profiles VALUES ('582ada26-484e-4377-a94d-2761381c578b', 'bdc58557-53c6-48af-9944-2ef575f75617', 'Эксперт по маркетплейсам. Вывожу товары в ТОП на Wildberries и Ozon. Управляю рекламными бюджетами от 1 млн рублей.', 16, '2024-12-25', 'active');
INSERT INTO public.specialist_profiles VALUES ('b3df3dff-3594-4c43-b9da-4b936d7f1282', '4c48e674-d26c-4e5f-8663-62032a4ee1da', 'Сертифицированный аудитор. Разберу ваши финансы, найду кассовые разрывы и легально снижу налоговую нагрузку.', 8, '2024-12-26', 'active');
INSERT INTO public.specialist_profiles VALUES ('4ea7ba5d-4892-4ed3-9779-b7d1b1023ca6', '88e7fc43-b5b3-4e10-912e-de451e80b79c', 'IT-архитектор. Внедряю Битрикс24, amoCRM и 1С. Автоматизирую рутину, чтобы вы могли заниматься только стратегией.', 13, '2024-06-15', 'suspended');
INSERT INTO public.specialist_profiles VALUES ('6c7c202c-6e67-4771-8e6d-cea923775928', '071c4cc5-0fcc-4aaa-9d26-0eab4e1bcd05', 'Эксперт по маркетплейсам. Вывожу товары в ТОП на Wildberries и Ozon. Управляю рекламными бюджетами от 1 млн рублей.', 15, '2024-11-16', 'active');
INSERT INTO public.specialist_profiles VALUES ('bb90ff09-cafb-4403-92a2-07d928d8daa9', '2008e2ee-f2d1-4059-8aec-a51f029f119f', 'IT-архитектор. Внедряю Битрикс24, amoCRM и 1С. Автоматизирую рутину, чтобы вы могли заниматься только стратегией.', 10, '2025-05-31', 'inactive');
INSERT INTO public.specialist_profiles VALUES ('eb2a31b9-8e64-4f7e-86a7-03678d49994b', '16d1099d-25a0-437f-b3e9-f122a9d21177', 'Эксперт по маркетплейсам. Вывожу товары в ТОП на Wildberries и Ozon. Управляю рекламными бюджетами от 1 млн рублей.', 2, '2025-05-15', 'active');
INSERT INTO public.specialist_profiles VALUES ('e0599544-24eb-416b-b10b-306d34f3f419', '8d5503e0-1070-4b91-809f-65235af7955c', 'Эксперт по маркетплейсам. Вывожу товары в ТОП на Wildberries и Ozon. Управляю рекламными бюджетами от 1 млн рублей.', 3, '2024-10-12', 'active');
INSERT INTO public.specialist_profiles VALUES ('757e2a9d-624f-4bd2-a7ec-48331ca16a31', '8777c501-66bf-41d5-9c66-d49f27e9e26b', 'Кризис-менеджер с опытом работы в ритейле. Оптимизирую расходы и сохраняю эффективность команды в турбулентные времена.', 12, '2025-04-30', 'active');
INSERT INTO public.specialist_profiles VALUES ('ae8fd7a3-d5f0-444b-aa41-c0dd202a76f6', 'bed0a05f-49cd-4720-b2ed-046625788faf', 'Сертифицированный аудитор. Разберу ваши финансы, найду кассовые разрывы и легально снижу налоговую нагрузку.', 6, '2025-05-11', 'active');
INSERT INTO public.specialist_profiles VALUES ('6c99bdd4-52cc-45b4-a9bc-d15b7c6ee45e', '75d80153-dc19-446b-9c9a-b3dfd7ec0713', 'Профессиональный HR-партнер. Знаю, как схантить лучших специалистов на рынке и снизить текучку кадров в 2 раза.', 9, '2025-02-18', 'active');
INSERT INTO public.specialist_profiles VALUES ('88d891ed-928c-4a23-a572-6855b60c50b7', '5a4a36ec-7c8b-4e23-b8dd-41333dbf999d', 'Эксперт по маркетплейсам. Вывожу товары в ТОП на Wildberries и Ozon. Управляю рекламными бюджетами от 1 млн рублей.', 3, '2024-10-24', 'active');


--
-- TOC entry 5000 (class 0 OID 24824)
-- Dependencies: 226
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES ('de75a2a8-50d0-438c-9305-27501f1904c2', 'roslynbradtke@luettgen.io', 'Stehr3873544', 'Hsk8Z&ATn72#', 'Анастасия', 'Попова', '71882018728', '2025-06-09', 'specialist');
INSERT INTO public.users VALUES ('96d5b621-4431-4e00-9263-3d566f4f349c', 'luragrant@pacocha.info', 'Strosin8962482', 'J5spG6x*#P7N', 'Анна', 'Васильева', '72306004801', '2024-06-10', 'specialist');
INSERT INTO public.users VALUES ('f24aad0e-0ce5-4767-a38d-09d32c7d07a6', 'jaimecorkery@rolfson.io', 'Nienow9533806', 'ZTqUICoDvVI8', 'Дарья', 'Михайлова', '71933863021', '2025-03-06', 'specialist');
INSERT INTO public.users VALUES ('b3321f3e-cbcd-46f8-acb4-f337d59c4e0f', 'earnestinekovacek@skiles.info', 'Hudson293925', 'Bd@0*#9o4?U#', 'Анна', 'Соколова', '76457799410', '2024-08-18', 'specialist');
INSERT INTO public.users VALUES ('dededfca-a1ea-4324-9731-8d2352dd4298', 'sheilabatz@fritsch.org', 'Kohler660391', 'Y38gS*2Jp!ee', 'Михаил', 'Смирнов', '74967616816', '2024-05-31', 'specialist');
INSERT INTO public.users VALUES ('aa9bf891-e1cd-4ccb-a693-7e59b4819456', 'eliseoyost@considine.net', 'Rippin810371', 'd4qT1@q@.-Sz', 'Анастасия', 'Михайлова', '72838822719', '2024-10-27', 'specialist');
INSERT INTO public.users VALUES ('a38bb4e0-b02e-4088-9486-6d4a9d70c0ca', 'orengreenfelder@green.net', 'Reichert3273839', '88zfK9x5JoWF', 'Анна', 'Соколова', '78218761191', '2024-07-11', 'specialist');
INSERT INTO public.users VALUES ('185d4602-6b48-4cf4-934a-4af5acb1262f', 'duncantromp@orn.net', 'Wyman4245135', 'p59kVQ!*zhCu', 'Екатерина', 'Кузнецова', '74496214845', '2025-05-01', 'specialist');
INSERT INTO public.users VALUES ('e96670b8-3449-4182-bc61-122beb179513', 'clarakovacek@welch.com', 'Tromp8794554', '6z24Mh?bL02n', 'Дмитрий', 'Волков', '71378716903', '2025-06-28', 'specialist');
INSERT INTO public.users VALUES ('bdc58557-53c6-48af-9944-2ef575f75617', 'roderickcrooks@goldner.org', 'Mitchell7803956', 'gPj88mjV&_31', 'Татьяна', 'Смирнова', '71395589196', '2024-12-22', 'specialist');
INSERT INTO public.users VALUES ('4c48e674-d26c-4e5f-8663-62032a4ee1da', 'kennethfranecki@hudson.com', 'Gerlach2205244', 'bzTw!x10eLB&', 'Андрей', 'Иванов', '75799829336', '2024-12-21', 'specialist');
INSERT INTO public.users VALUES ('88e7fc43-b5b3-4e10-912e-de451e80b79c', 'raymondhaag@satterfield.info', 'Carter4584165', '6*IFIDvQe.!Y', 'Илья', 'Фёдоров', '71572200746', '2024-06-08', 'specialist');
INSERT INTO public.users VALUES ('071c4cc5-0fcc-4aaa-9d26-0eab4e1bcd05', 'lloydspencer@predovic.biz', 'Stehr9077881', '@#nb#W905f6F', 'Алексей', 'Лебедев', '79525108374', '2024-11-12', 'specialist');
INSERT INTO public.users VALUES ('2008e2ee-f2d1-4059-8aec-a51f029f119f', 'dereckkrajcik@braun.name', 'Christiansen2535770', '@kPhxeO*AVOU', 'Михаил', 'Волков', '71662445872', '2025-05-22', 'specialist');
INSERT INTO public.users VALUES ('16d1099d-25a0-437f-b3e9-f122a9d21177', 'myrongibson@smith.com', 'Murazik4126494', 'W?JL-E&ZdQD0', 'Роман', 'Иванов', '77393607961', '2025-05-07', 'specialist');
INSERT INTO public.users VALUES ('8d5503e0-1070-4b91-809f-65235af7955c', 'daphneekub@gulgowski.io', 'Stoltenberg8048491', 'Nh94hU7cC904', 'Иван', 'Лебедев', '77991365328', '2024-10-07', 'specialist');
INSERT INTO public.users VALUES ('8777c501-66bf-41d5-9c66-d49f27e9e26b', 'emersongibson@treutel.net', 'Bayer1527614', 'K#SU8Fr1V6@e', 'Татьяна', 'Попова', '77167125923', '2025-04-24', 'specialist');
INSERT INTO public.users VALUES ('bed0a05f-49cd-4720-b2ed-046625788faf', 'cesarbruen@cassin.io', 'Ankunding5532679', 'O@Ts51HhM27H', 'Елена', 'Соколова', '74984562278', '2025-05-05', 'specialist');
INSERT INTO public.users VALUES ('75d80153-dc19-446b-9c9a-b3dfd7ec0713', 'destinihauck@mayer.net', 'Considine2316455', 'ctPg6Q0nn3ry', 'Юлия', 'Новикова', '75486994625', '2025-02-18', 'specialist');
INSERT INTO public.users VALUES ('5a4a36ec-7c8b-4e23-b8dd-41333dbf999d', 'giovannithompson@maggio.io', 'Rau4490529', 'wM7w24D&6xAu', 'Мария', 'Фёдорова', '71731678664', '2024-10-19', 'specialist');
INSERT INTO public.users VALUES ('7af5d1fb-0939-4871-9e0c-c3ce1d9673d6', 'felipalind@erdman.biz', 'Prohaska7714516', 'tN&zGs9.d?Jw', 'Артем', 'Васильев', '76139933168', '2024-11-07', 'client');
INSERT INTO public.users VALUES ('dcb7e75a-c89f-4b0b-a55f-f93b164652aa', 'scarlettbreitenberg@thiel.io', 'Runolfsson6816359', '##efnavb0zvn', 'Наталья', 'Соколова', '76793335957', '2025-01-27', 'client');
INSERT INTO public.users VALUES ('d5446445-74a8-49e9-9de0-529ecc7793a3', 'abdulcartwright@moore.com', 'Schowalter4684608', 'mNb2b5VC0m3G', 'Юлия', 'Петрова', '73049920438', '2025-12-23', 'client');
INSERT INTO public.users VALUES ('8b0275c9-9acb-4c08-93d0-d39d25b09094', 'guadalupeflatley@steuber.org', 'Gislason3006371', '940bMP_354B@', 'Татьяна', 'Кузнецова', '73560919946', '2024-07-24', 'client');
INSERT INTO public.users VALUES ('f0132695-2dd2-4cc3-b054-555903de6d7d', 'aurorekunde@beier.org', 'Osinski2106954', 'j9@jsJ9foxZb', 'Анна', 'Новикова', '76007458595', '2024-11-17', 'client');
INSERT INTO public.users VALUES ('a7a54bc0-d838-4016-8864-8c15cc32b2d9', 'jeffreystanton@gleichner.net', 'Greenfelder2649489', 'RwnM?FqwogpM', 'Наталья', 'Кузнецова', '71883766682', '2025-06-02', 'client');
INSERT INTO public.users VALUES ('c470d455-cc38-4c0b-b6d3-1ddaf0695f16', 'jarenbarton@little.com', 'Gerhold8048450', '2*t2at8N21V6', 'Екатерина', 'Смирнова', '76188926008', '2025-06-15', 'client');
INSERT INTO public.users VALUES ('d28e35fb-58ae-4bbc-b419-b12ebe3118bd', 'robertschimmel@ferry.org', 'Romaguera3466475', 'PFePDEg0X7g*', 'Иван', 'Морозов', '74570708306', '2024-05-11', 'client');
INSERT INTO public.users VALUES ('3eac485f-02da-45fc-a87c-bdef8198c18c', 'kyliebeatty@windler.com', 'Beier971699', 'T51TXWtscMN8', 'Дарья', 'Попова', '76525695350', '2024-10-23', 'client');
INSERT INTO public.users VALUES ('5aad6155-d3fe-48f3-be60-ec1037050390', 'rhiannonschmidt@fay.io', 'Littel177370', '1$_t7r4tI9Rc', 'Татьяна', 'Морозова', '73389136084', '2024-07-09', 'client');
INSERT INTO public.users VALUES ('d760a6ae-9aeb-49b9-b6aa-eec5ffe9531e', 'clarenicolas@rempel.biz', 'Denesik8156749', 't0IOCl?oM82d', 'Алексей', 'Смирнов', '75098854122', '2025-07-28', 'client');
INSERT INTO public.users VALUES ('617e7367-3e5c-4767-9edf-79c90c5ad0ff', 'haleighmorar@graham.com', 'Parker1117423', '&RWmppTUD-25', 'Анна', 'Фёдорова', '77827544851', '2024-08-09', 'client');
INSERT INTO public.users VALUES ('d77a2d11-6001-415e-858f-c6b482f08ed2', 'roycesauer@welch.name', 'Bode6977818', 'rBqVa83iYm$_', 'Екатерина', 'Васильева', '71738398549', '2024-09-16', 'client');
INSERT INTO public.users VALUES ('ec73ed14-18fa-47c4-952b-36011af06896', 'mosheschmitt@gottlieb.org', 'Bednar8668640', 'VJGL5Q8#NN@&', 'Елена', 'Волкова', '71507028708', '2025-06-03', 'client');
INSERT INTO public.users VALUES ('71543d46-b102-4b40-82aa-2d78c23e9542', 'cletusbrown@trantow.com', 'Senger1152803', '_?17FK02A892', 'Екатерина', 'Смирнова', '79309039371', '2026-03-25', 'client');
INSERT INTO public.users VALUES ('ee265a4d-9c7b-46f8-b25b-9d4ac0a5c6df', 'scottyarmstrong@hermann.biz', 'Frami3716474', '6yns&RW*&@K9', 'Дарья', 'Смирнова', '77783210977', '2026-01-25', 'client');
INSERT INTO public.users VALUES ('db91092a-69aa-46f1-a4c5-69f7be4a9a90', 'dariondibbert@cummerata.name', 'Adams3233907', 'aZ-DVq#E5!8@', 'Роман', 'Соколов', '73958678311', '2025-11-06', 'client');
INSERT INTO public.users VALUES ('ce5ca999-f1eb-4c19-a50a-accb201681bb', 'macijones@nader.io', 'Gutkowski7208876', '_T7$T7gjZKS1', 'Виктория', 'Попова', '73737873677', '2025-09-07', 'client');
INSERT INTO public.users VALUES ('80fa2d37-dda0-4008-a947-32d4b28ff102', 'joannewilkinson@farrell.net', 'Pouros8683715', '8yv$i?AYh4Z3', 'Мария', 'Васильева', '72700559528', '2025-12-02', 'client');
INSERT INTO public.users VALUES ('2f22b8d4-566e-4615-a4cf-08d80c4f5967', 'cliftonjohnston@mcdermott.info', 'Hodkiewicz6843266', 'INd4EZx6QQCw', 'Кирилл', 'Михайлов', '77413902338', '2025-12-01', 'client');
INSERT INTO public.users VALUES ('f11f2cd3-d75b-4cef-a055-db2c931885e2', 'jaedenhessel@kuvalis.org', 'Fritsch2403968', '4VdB96dWt6G9', 'Алина', 'Новикова', '73490635515', '2025-11-21', 'client');
INSERT INTO public.users VALUES ('79e34960-f2ee-4ca0-a93b-f172d2801a3b', 'emmaleemertz@senger.name', 'Koss9283673', '$XG@@&!4#Qd2', 'Алина', 'Новикова', '79422525173', '2025-02-07', 'client');
INSERT INTO public.users VALUES ('78af36a8-3047-4c4b-88b1-4ae5f1e795ef', 'cecilereynolds@crist.org', 'Fahey8349498', '?RH4PYp$4*Jp', 'Иван', 'Фёдоров', '71918380949', '2025-03-15', 'client');
INSERT INTO public.users VALUES ('c557121d-38e8-49dd-8411-3d1d2c53f9fa', 'wilfredohagenes@marks.name', 'McCullough211552', 'L9Luy8eCAQc5', 'Андрей', 'Соколов', '77374189512', '2026-03-06', 'client');
INSERT INTO public.users VALUES ('14e2e14a-d4ce-4068-90cf-ba3ffbcde32c', 'sydneymacejkovic@powlowski.net', 'Kozey8120658', 'gP6!295KX?RC', 'Илья', 'Михайлов', '78026862866', '2026-01-26', 'client');
INSERT INTO public.users VALUES ('b58401d3-64f4-4bc4-8d6d-e2f36aca7e4a', 'freddieluettgen@welch.org', 'Bradtke3676692', '&!dEp1cT6nnB', 'Сергей', 'Смирнов', '71880795294', '2025-09-04', 'client');
INSERT INTO public.users VALUES ('a071ef39-68ac-4006-97f5-1dc52317656a', 'jasminfeeney@wilkinson.net', 'Predovic1220775', 'nvhLoW.bDO3L', 'Виктор', 'Кузнецов', '73539360912', '2025-09-01', 'client');
INSERT INTO public.users VALUES ('feff420f-5bd1-44f3-921a-effd234f78fc', 'shayleekoepp@jones.biz', 'Kuvalis2724617', '&_W8#dnj4kdO', 'Дмитрий', 'Петров', '78698280157', '2024-11-03', 'client');
INSERT INTO public.users VALUES ('d3ab60ea-c5dd-4ff4-a253-d76442ada119', 'dorthaschinner@larkin.name', 'Konopelski9087727', 'u$25IW7Z1F0g', 'Ирина', 'Волкова', '71169988962', '2025-11-25', 'client');
INSERT INTO public.users VALUES ('76f89faf-1ae6-4bc5-9a5f-538a211b3335', 'anaiscrooks@glover.net', 'Farrell7692212', 'DR*3RXC_kP5.', 'Максим', 'Фёдоров', '74864912152', '2025-08-07', 'client');
INSERT INTO public.users VALUES ('fef3ee6e-48ad-4e55-82d5-755075dc938d', 'duncanhills@shields.info', 'Mann4243395', 'qKH2n5X2s3zU', 'Андрей', 'Михайлов', '75761219069', '2024-10-04', 'client');
INSERT INTO public.users VALUES ('d4e9cfb7-2f50-49c2-b299-92ff1575c801', 'wellingtonkeebler@schuppe.com', 'Wintheiser2824620', '8f1XW-5?lap$', 'Артем', 'Михайлов', '75249772188', '2025-01-30', 'client');
INSERT INTO public.users VALUES ('556e29e7-2d94-43a9-941d-4637653afae6', 'gaychristiansen@turcotte.name', 'Harber8917494', 'uPj1I!7&J.tw', 'Иван', 'Васильев', '78671585688', '2026-01-05', 'client');
INSERT INTO public.users VALUES ('b4a7a5a3-2d7f-4c77-81cc-d0084137c654', 'oswaldmurphy@veum.org', 'Waters2921789', 'QWovSOLMaj?3', 'Дмитрий', 'Михайлов', '79134559091', '2025-05-16', 'client');
INSERT INTO public.users VALUES ('9332fe43-ec3b-4704-927b-faf98b9b9cc3', 'ninahilll@collier.com', 'Hagenes7945739', '-1$-E9Zo1dU?', 'Илья', 'Иванов', '79843576729', '2026-03-02', 'client');
INSERT INTO public.users VALUES ('41694892-efd6-49d5-9965-f64407334fed', 'lulagleichner@walsh.biz', 'Ratke1786772', '1@wGP4xIy?fz', 'Анастасия', 'Иванова', '77808321080', '2026-02-12', 'client');
INSERT INTO public.users VALUES ('2027739a-ff17-46a0-8a87-263b348bb5ff', 'reagangislason@reichert.info', 'Hermiston6367453', 'PlNgN13iPARM', 'Алина', 'Васильева', '71177834359', '2025-06-27', 'client');
INSERT INTO public.users VALUES ('2c16ebc1-b8f4-4b31-8853-4413c5899d61', 'ottodaugherty@heidenreich.biz', 'Hermiston2075218', 'pE&064128z#d', 'Алексей', 'Петров', '72389659537', '2024-06-27', 'client');
INSERT INTO public.users VALUES ('02484dd8-15c7-4e9b-9c79-db9980fc3d84', 'isabellehoeger@keebler.biz', 'Terry1766321', 'iI2bKzk?WEfh', 'Анна', 'Соколова', '79668507194', '2026-01-20', 'client');
INSERT INTO public.users VALUES ('2d4262e5-7171-471e-90ca-d9d4c0ac9afe', 'kenneditremblay@rolfson.org', 'Schowalter3029900', 'm1*WLQ_-rfyD', 'Алексей', 'Фёдоров', '78352229858', '2024-10-17', 'client');
INSERT INTO public.users VALUES ('4b8ec2d5-cb86-4b75-80e2-fa876f1d4360', 'rachellejohnston@stanton.name', 'Mayer8528125', 'v9sT$RdG*@G*', 'Екатерина', 'Иванова', '71403650602', '2026-03-14', 'client');
INSERT INTO public.users VALUES ('eba28432-e0e8-4e83-be5c-9d5e64b8f776', 'maxiemorissette@schumm.org', 'Considine472323', 'Bs&tee@s!gZw', 'Екатерина', 'Соколова', '72174750570', '2025-10-05', 'client');
INSERT INTO public.users VALUES ('607733fe-e0af-4227-833e-a877633f5bd3', 'kaseymueller@harvey.org', 'Robel5732364', '2._.ubZ904@d', 'Александр', 'Иванов', '76483569858', '2025-06-28', 'client');
INSERT INTO public.users VALUES ('58a3b6bf-3bce-4522-a54f-486c75f6c406', 'madalineleannon@rodriguez.net', 'Schamberger697017', 'vT#JQ3Q3Cv!9', 'Иван', 'Фёдоров', '72502612719', '2026-01-18', 'client');
INSERT INTO public.users VALUES ('1d02b5a7-00d0-4348-9e05-cd2395dbfd8d', 'jennyferpurdy@legros.net', 'Wilkinson4543432', 'D$9Sw$m04Shx', 'Ольга', 'Соколова', '77783306601', '2025-01-03', 'client');
INSERT INTO public.users VALUES ('9205964d-8372-4563-89d4-b549d3d1ab01', 'cathybartell@purdy.net', 'Paucek6828612', 'FqS!?34AJ1fM', 'Юлия', 'Фёдорова', '72099650457', '2025-02-02', 'client');
INSERT INTO public.users VALUES ('87c81a7f-b8b9-4aa7-8c7c-5e252447dc0c', 'trenthilll@ryan.biz', 'Haley9338246', '&EC6_!BGT2-3', 'Ирина', 'Морозова', '78895264003', '2025-05-18', 'client');
INSERT INTO public.users VALUES ('295e6eb5-15d9-4d1f-b648-5a1d7d1b15b2', 'enosschmeler@kub.org', 'Pagac9021115', 'ut13Q-Y@0p*F', 'Александр', 'Кузнецов', '77179931937', '2026-03-13', 'client');
INSERT INTO public.users VALUES ('5614c63e-b164-439a-bfad-ad68b28d05f5', 'howardolson@hamill.net', 'Jacobson4152588', '3-#f-9x@0E14', 'Дмитрий', 'Михайлов', '73971563215', '2024-07-25', 'client');
INSERT INTO public.users VALUES ('29199910-4a41-4c96-98af-484385e37f24', 'oceanequigley@koss.net', 'Wunsch1413715', 'A1ISfo7Uob_Y', 'Иван', 'Соколов', '72631777634', '2024-10-14', 'client');


--
-- TOC entry 4804 (class 2606 OID 24832)
-- Name: availability_slots availability_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.availability_slots
    ADD CONSTRAINT availability_slots_pkey PRIMARY KEY (slot_id);


--
-- TOC entry 4806 (class 2606 OID 24834)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 4808 (class 2606 OID 24836)
-- Name: course_reviews course_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_reviews
    ADD CONSTRAINT course_reviews_pkey PRIMARY KEY (review_id);


--
-- TOC entry 4810 (class 2606 OID 24838)
-- Name: course_reviews course_reviews_purchased_course_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_reviews
    ADD CONSTRAINT course_reviews_purchased_course_id_key UNIQUE (purchased_course_id);


--
-- TOC entry 4812 (class 2606 OID 24840)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- TOC entry 4814 (class 2606 OID 24842)
-- Name: purchased_courses purchased_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchased_courses
    ADD CONSTRAINT purchased_courses_pkey PRIMARY KEY (purchased_course_id);


--
-- TOC entry 4816 (class 2606 OID 24844)
-- Name: service_bookings service_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_bookings
    ADD CONSTRAINT service_bookings_pkey PRIMARY KEY (booking_id);


--
-- TOC entry 4818 (class 2606 OID 24846)
-- Name: service_reviews service_reviews_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT service_reviews_booking_id_key UNIQUE (booking_id);


--
-- TOC entry 4820 (class 2606 OID 24848)
-- Name: service_reviews service_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT service_reviews_pkey PRIMARY KEY (review_id);


--
-- TOC entry 4822 (class 2606 OID 24850)
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (service_id);


--
-- TOC entry 4824 (class 2606 OID 24852)
-- Name: specialist_categories specialist_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_categories
    ADD CONSTRAINT specialist_categories_pkey PRIMARY KEY (profile_id, category_id);


--
-- TOC entry 4826 (class 2606 OID 24854)
-- Name: specialist_profiles specialist_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_profiles
    ADD CONSTRAINT specialist_profiles_pkey PRIMARY KEY (profile_id);


--
-- TOC entry 4828 (class 2606 OID 24856)
-- Name: specialist_profiles specialist_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_profiles
    ADD CONSTRAINT specialist_profiles_user_id_key UNIQUE (user_id);


--
-- TOC entry 4830 (class 2606 OID 24858)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4832 (class 2606 OID 24860)
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- TOC entry 4834 (class 2606 OID 24862)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4835 (class 2606 OID 24863)
-- Name: availability_slots availability_slots_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.availability_slots
    ADD CONSTRAINT availability_slots_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.specialist_profiles(profile_id) ON DELETE CASCADE;


--
-- TOC entry 4836 (class 2606 OID 24868)
-- Name: course_reviews course_reviews_purchased_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_reviews
    ADD CONSTRAINT course_reviews_purchased_course_id_fkey FOREIGN KEY (purchased_course_id) REFERENCES public.purchased_courses(purchased_course_id) ON DELETE CASCADE;


--
-- TOC entry 4837 (class 2606 OID 24873)
-- Name: courses courses_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.specialist_profiles(profile_id) ON DELETE CASCADE;


--
-- TOC entry 4838 (class 2606 OID 24878)
-- Name: purchased_courses purchased_courses_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchased_courses
    ADD CONSTRAINT purchased_courses_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- TOC entry 4839 (class 2606 OID 24883)
-- Name: purchased_courses purchased_courses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchased_courses
    ADD CONSTRAINT purchased_courses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4840 (class 2606 OID 24888)
-- Name: service_bookings service_bookings_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_bookings
    ADD CONSTRAINT service_bookings_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.services(service_id) ON DELETE CASCADE;


--
-- TOC entry 4841 (class 2606 OID 24893)
-- Name: service_bookings service_bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_bookings
    ADD CONSTRAINT service_bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4842 (class 2606 OID 24898)
-- Name: service_reviews service_reviews_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_reviews
    ADD CONSTRAINT service_reviews_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.service_bookings(booking_id) ON DELETE CASCADE;


--
-- TOC entry 4843 (class 2606 OID 24903)
-- Name: services services_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.specialist_profiles(profile_id) ON DELETE CASCADE;


--
-- TOC entry 4844 (class 2606 OID 24908)
-- Name: specialist_categories specialist_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_categories
    ADD CONSTRAINT specialist_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 4845 (class 2606 OID 24913)
-- Name: specialist_categories specialist_categories_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_categories
    ADD CONSTRAINT specialist_categories_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.specialist_profiles(profile_id) ON DELETE CASCADE;


--
-- TOC entry 4846 (class 2606 OID 24918)
-- Name: specialist_profiles specialist_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialist_profiles
    ADD CONSTRAINT specialist_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


-- Completed on 2026-05-08 12:43:26

--
-- PostgreSQL database dump complete
--

\unrestrict 2WkbU1fa7cy6RjLnN00Ua29FQ8Qd9C4FzzimOHvHm2tP0fRxm462a0uh9R4jEnG

