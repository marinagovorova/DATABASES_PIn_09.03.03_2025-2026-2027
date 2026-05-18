--
-- PostgreSQL database dump
--

\restrict z1LFfmc2RJ9onoWSbU2R4sZHsjWHBnGiIFzHwRuFFlIBtHzua7bKG6FeEQdw0co

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-03-30 12:56:49

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
-- TOC entry 5 (class 2615 OID 17268)
-- Name: publishing; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA publishing;


ALTER SCHEMA publishing OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 17270)
-- Name: author; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.author (
    id integer NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    middle_name character varying(50),
    email character varying(100)
);


ALTER TABLE publishing.author OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17269)
-- Name: author_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.author_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.author_id_seq OWNER TO postgres;

--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 219
-- Name: author_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.author_id_seq OWNED BY publishing.author.id;


--
-- TOC entry 222 (class 1259 OID 17285)
-- Name: book; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.book (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    category character varying(50) NOT NULL,
    year integer,
    pages integer NOT NULL,
    CONSTRAINT book_pages_check CHECK ((pages > 0))
);


ALTER TABLE publishing.book OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17302)
-- Name: book_author; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.book_author (
    id integer NOT NULL,
    book_id integer NOT NULL,
    author_id integer NOT NULL,
    author_order integer CONSTRAINT book_author_outhor_order_not_null NOT NULL,
    CONSTRAINT book_author_outhor_order_check CHECK ((author_order > 0))
);


ALTER TABLE publishing.book_author OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17301)
-- Name: book_author_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.book_author_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.book_author_id_seq OWNER TO postgres;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 223
-- Name: book_author_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.book_author_id_seq OWNED BY publishing.book_author.id;


--
-- TOC entry 221 (class 1259 OID 17284)
-- Name: book_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.book_id_seq OWNER TO postgres;

--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 221
-- Name: book_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.book_id_seq OWNED BY publishing.book.id;


--
-- TOC entry 240 (class 1259 OID 17455)
-- Name: tech_task; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.tech_task (
    id bigint CONSTRAINT check_task_id_not_null NOT NULL,
    edition_id integer CONSTRAINT check_task_edition_id_not_null NOT NULL,
    description character varying(255)
);


ALTER TABLE publishing.tech_task OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17454)
-- Name: check_task_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.check_task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.check_task_id_seq OWNER TO postgres;

--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 239
-- Name: check_task_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.check_task_id_seq OWNED BY publishing.tech_task.id;


--
-- TOC entry 238 (class 1259 OID 17428)
-- Name: contract; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.contract (
    id integer NOT NULL,
    order_id integer NOT NULL,
    customer_id integer NOT NULL,
    contract_number integer NOT NULL,
    sign_date date,
    close_date date,
    CONSTRAINT contract_check CHECK ((close_date > sign_date))
);


ALTER TABLE publishing.contract OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17427)
-- Name: contract_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.contract_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.contract_id_seq OWNER TO postgres;

--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 237
-- Name: contract_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.contract_id_seq OWNED BY publishing.contract.id;


--
-- TOC entry 230 (class 1259 OID 17351)
-- Name: customer; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.customer (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    address character varying(200),
    phone character varying(20)
);


ALTER TABLE publishing.customer OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17350)
-- Name: customer_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.customer_id_seq OWNER TO postgres;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 229
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.customer_id_seq OWNED BY publishing.customer.id;


--
-- TOC entry 226 (class 1259 OID 17314)
-- Name: edition; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.edition (
    id integer NOT NULL,
    book_id integer NOT NULL,
    isbn character varying(20) NOT NULL,
    edition_number integer,
    year integer,
    pages integer NOT NULL,
    price numeric(10,2) NOT NULL,
    CONSTRAINT edition_pages_check CHECK ((pages > 0)),
    CONSTRAINT edition_price_check CHECK ((price > (0)::numeric))
);


ALTER TABLE publishing.edition OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17313)
-- Name: edition_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.edition_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.edition_id_seq OWNER TO postgres;

--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 225
-- Name: edition_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.edition_id_seq OWNED BY publishing.edition.id;


--
-- TOC entry 242 (class 1259 OID 17469)
-- Name: editor; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.editor (
    id integer NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    middle_name character varying(50)
);


ALTER TABLE publishing.editor OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17468)
-- Name: editor_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.editor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.editor_id_seq OWNER TO postgres;

--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 241
-- Name: editor_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.editor_id_seq OWNED BY publishing.editor.id;


--
-- TOC entry 232 (class 1259 OID 17360)
-- Name: manager; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.manager (
    id integer NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    middle_name character varying(50)
);


ALTER TABLE publishing.manager OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17359)
-- Name: manager_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.manager_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.manager_id_seq OWNER TO postgres;

--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 231
-- Name: manager_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.manager_id_seq OWNED BY publishing.manager.id;


--
-- TOC entry 234 (class 1259 OID 17370)
-- Name: order; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing."order" (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    manager_id integer NOT NULL,
    order_date date NOT NULL,
    status character varying(20) NOT NULL
);


ALTER TABLE publishing."order" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17369)
-- Name: order_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.order_id_seq OWNER TO postgres;

--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 233
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.order_id_seq OWNED BY publishing."order".id;


--
-- TOC entry 236 (class 1259 OID 17406)
-- Name: order_item; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.order_item (
    id integer NOT NULL,
    order_id integer NOT NULL,
    edition_id integer NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT order_item_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE publishing.order_item OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17405)
-- Name: order_item_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.order_item_id_seq OWNER TO postgres;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 235
-- Name: order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.order_item_id_seq OWNED BY publishing.order_item.id;


--
-- TOC entry 228 (class 1259 OID 17335)
-- Name: print_run; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.print_run (
    id integer NOT NULL,
    edition_id integer NOT NULL,
    quantity integer NOT NULL,
    print_date date,
    CONSTRAINT print_run_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE publishing.print_run OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17334)
-- Name: print_run_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.print_run_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.print_run_id_seq OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 227
-- Name: print_run_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.print_run_id_seq OWNED BY publishing.print_run.id;


--
-- TOC entry 244 (class 1259 OID 17479)
-- Name: tech_task_editor; Type: TABLE; Schema: publishing; Owner: postgres
--

CREATE TABLE publishing.tech_task_editor (
    id integer NOT NULL,
    tech_task_id integer NOT NULL,
    editor_id integer NOT NULL,
    is_main boolean
);


ALTER TABLE publishing.tech_task_editor OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17478)
-- Name: tech_task_editor_id_seq; Type: SEQUENCE; Schema: publishing; Owner: postgres
--

CREATE SEQUENCE publishing.tech_task_editor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE publishing.tech_task_editor_id_seq OWNER TO postgres;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 243
-- Name: tech_task_editor_id_seq; Type: SEQUENCE OWNED BY; Schema: publishing; Owner: postgres
--

ALTER SEQUENCE publishing.tech_task_editor_id_seq OWNED BY publishing.tech_task_editor.id;


--
-- TOC entry 4916 (class 2604 OID 17273)
-- Name: author id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.author ALTER COLUMN id SET DEFAULT nextval('publishing.author_id_seq'::regclass);


--
-- TOC entry 4917 (class 2604 OID 17288)
-- Name: book id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book ALTER COLUMN id SET DEFAULT nextval('publishing.book_id_seq'::regclass);


--
-- TOC entry 4918 (class 2604 OID 17305)
-- Name: book_author id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book_author ALTER COLUMN id SET DEFAULT nextval('publishing.book_author_id_seq'::regclass);


--
-- TOC entry 4925 (class 2604 OID 17431)
-- Name: contract id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.contract ALTER COLUMN id SET DEFAULT nextval('publishing.contract_id_seq'::regclass);


--
-- TOC entry 4921 (class 2604 OID 17354)
-- Name: customer id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.customer ALTER COLUMN id SET DEFAULT nextval('publishing.customer_id_seq'::regclass);


--
-- TOC entry 4919 (class 2604 OID 17317)
-- Name: edition id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.edition ALTER COLUMN id SET DEFAULT nextval('publishing.edition_id_seq'::regclass);


--
-- TOC entry 4927 (class 2604 OID 17472)
-- Name: editor id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.editor ALTER COLUMN id SET DEFAULT nextval('publishing.editor_id_seq'::regclass);


--
-- TOC entry 4922 (class 2604 OID 17363)
-- Name: manager id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.manager ALTER COLUMN id SET DEFAULT nextval('publishing.manager_id_seq'::regclass);


--
-- TOC entry 4923 (class 2604 OID 17373)
-- Name: order id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing."order" ALTER COLUMN id SET DEFAULT nextval('publishing.order_id_seq'::regclass);


--
-- TOC entry 4924 (class 2604 OID 17409)
-- Name: order_item id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.order_item ALTER COLUMN id SET DEFAULT nextval('publishing.order_item_id_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 17338)
-- Name: print_run id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.print_run ALTER COLUMN id SET DEFAULT nextval('publishing.print_run_id_seq'::regclass);


--
-- TOC entry 4926 (class 2604 OID 17458)
-- Name: tech_task id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.tech_task ALTER COLUMN id SET DEFAULT nextval('publishing.check_task_id_seq'::regclass);


--
-- TOC entry 4928 (class 2604 OID 17482)
-- Name: tech_task_editor id; Type: DEFAULT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.tech_task_editor ALTER COLUMN id SET DEFAULT nextval('publishing.tech_task_editor_id_seq'::regclass);


--
-- TOC entry 5122 (class 0 OID 17270)
-- Dependencies: 220
-- Data for Name: author; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.author (id, last_name, first_name, middle_name, email) FROM stdin;
301	Lewis	Justin	\N	user246@mail.com
302	Garcia	Anthony	\N	user946@mail.com
303	Williams	Richard	\N	user214@mail.com
304	Williams	James	\N	user263@mail.com
305	Smith	Gregory	\N	user659@mail.com
306	Kuznetsov	Benjamin	\N	user391@mail.com
307	Lee	Jonathan	\N	user372@mail.com
308	Jackson	Justin	\N	user360@mail.com
309	Martinez	Patrick	\N	user13@mail.com
310	Thomas	William	\N	user174@mail.com
311	Wilson	Patrick	\N	user298@mail.com
312	Martinez	Ryan	\N	user854@mail.com
313	Petrov	Jonathan	\N	user922@mail.com
314	Walker	Jonathan	\N	user908@mail.com
315	Miller	Richard	\N	user932@mail.com
316	Jackson	James	\N	user420@mail.com
317	Clark	John	\N	user725@mail.com
318	Taylor	Patrick	\N	user115@mail.com
319	Taylor	Joseph	\N	user278@mail.com
320	Jones	Gregory	\N	user797@mail.com
321	Sidorov	Peter	\N	user821@mail.com
322	Lee	Chris	\N	user632@mail.com
323	Young	Brian	\N	user288@mail.com
324	Kuznetsov	Scott	\N	user362@mail.com
325	Martinez	Ryan	\N	user778@mail.com
326	Lewis	Patrick	\N	user242@mail.com
327	Williams	Daniel	\N	user772@mail.com
328	Kuznetsov	Nicholas	\N	user850@mail.com
329	Thomas	David	\N	user538@mail.com
330	Sidorov	Paul	\N	user115@mail.com
331	Lopez	Sergey	\N	user870@mail.com
332	Harris	William	\N	user411@mail.com
333	Hernandez	Thomas	\N	user65@mail.com
334	Kuznetsov	Charles	\N	user491@mail.com
335	Gonzalez	Mark	\N	user690@mail.com
336	Robinson	Nicholas	\N	user468@mail.com
337	Jones	Joseph	\N	user472@mail.com
338	Lopez	Daniel	\N	user600@mail.com
339	Hernandez	Steven	\N	user955@mail.com
340	Petrov	Kevin	\N	user942@mail.com
341	Smith	James	\N	user242@mail.com
342	Brown	David	\N	user981@mail.com
343	Johnson	Scott	\N	user43@mail.com
344	Johnson	Andrew	\N	user25@mail.com
345	Clark	Eric	\N	user906@mail.com
346	Martin	Jonathan	\N	user387@mail.com
347	Hernandez	Andrew	\N	user768@mail.com
348	Lopez	Robert	\N	user113@mail.com
349	Williams	Chris	\N	user821@mail.com
350	Moore	Chris	\N	user435@mail.com
151	Кузнецов	Иван	\N	user515@mail.com
152	Иванов	Сергей	\N	user753@mail.com
153	Сидоров	Сергей	\N	user984@mail.com
154	Кузнецов	Алексей	\N	user69@mail.com
155	Кузнецов	Дмитрий	\N	user770@mail.com
156	Сидоров	Алексей	\N	user989@mail.com
157	Иванов	Сергей	\N	user733@mail.com
158	Смирнов	Петр	\N	user923@mail.com
159	Смирнов	Иван	\N	user60@mail.com
160	Петров	Иван	\N	user779@mail.com
161	Сидоров	Алексей	\N	user693@mail.com
162	Смирнов	Сергей	\N	user572@mail.com
163	Петров	Алексей	\N	user768@mail.com
164	Смирнов	Иван	\N	user448@mail.com
165	Сидоров	Сергей	\N	user347@mail.com
166	Сидоров	Дмитрий	\N	user356@mail.com
167	Петров	Алексей	\N	user59@mail.com
168	Смирнов	Дмитрий	\N	user724@mail.com
169	Сидоров	Алексей	\N	user445@mail.com
170	Кузнецов	Иван	\N	user120@mail.com
171	Петров	Дмитрий	\N	user475@mail.com
172	Сидоров	Сергей	\N	user163@mail.com
173	Смирнов	Алексей	\N	user452@mail.com
174	Петров	Дмитрий	\N	user411@mail.com
175	Иванов	Сергей	\N	user986@mail.com
176	Иванов	Дмитрий	\N	user824@mail.com
177	Петров	Сергей	\N	user706@mail.com
178	Смирнов	Сергей	\N	user201@mail.com
179	Иванов	Иван	\N	user392@mail.com
180	Кузнецов	Иван	\N	user561@mail.com
181	Петров	Петр	\N	user783@mail.com
182	Кузнецов	Алексей	\N	user604@mail.com
183	Петров	Алексей	\N	user615@mail.com
184	Кузнецов	Дмитрий	\N	user104@mail.com
185	Смирнов	Дмитрий	\N	user499@mail.com
186	Кузнецов	Сергей	\N	user704@mail.com
187	Смирнов	Сергей	\N	user675@mail.com
188	Петров	Петр	\N	user812@mail.com
189	Смирнов	Дмитрий	\N	user533@mail.com
190	Смирнов	Иван	\N	user499@mail.com
191	Иванов	Петр	\N	user423@mail.com
192	Смирнов	Петр	\N	user46@mail.com
193	Иванов	Петр	\N	user834@mail.com
194	Иванов	Алексей	\N	user645@mail.com
195	Кузнецов	Алексей	\N	user295@mail.com
196	Смирнов	Алексей	\N	user590@mail.com
197	Петров	Алексей	\N	user35@mail.com
198	Иванов	Алексей	\N	user778@mail.com
199	Сидоров	Сергей	\N	user896@mail.com
200	Смирнов	Иван	\N	user772@mail.com
201	White	Robert	\N	user92@mail.com
202	Anderson	David	\N	user805@mail.com
203	Wilson	Matthew	\N	user932@mail.com
204	Thomas	Thomas	\N	user567@mail.com
205	Gonzalez	Peter	\N	user72@mail.com
206	Kuznetsov	Dmitry	\N	user631@mail.com
207	Anderson	Joseph	\N	user844@mail.com
208	Harris	John	\N	user410@mail.com
209	Hernandez	Justin	\N	user998@mail.com
210	Lewis	Richard	\N	user629@mail.com
211	Brown	Matthew	\N	user745@mail.com
212	Jones	Alex	\N	user658@mail.com
213	Walker	Ryan	\N	user230@mail.com
214	Martin	Michael	\N	user45@mail.com
215	Petrov	Michael	\N	user920@mail.com
216	Jones	Jonathan	\N	user74@mail.com
217	Walker	Benjamin	\N	user197@mail.com
218	Sidorov	Anthony	\N	user794@mail.com
219	Brown	Brian	\N	user383@mail.com
220	Wilson	Joseph	\N	user782@mail.com
221	Brown	Ryan	\N	user855@mail.com
222	Anderson	Richard	\N	user360@mail.com
223	Petrov	Jason	\N	user345@mail.com
224	Jones	Dmitry	\N	user525@mail.com
225	Wilson	Kevin	\N	user575@mail.com
226	Jackson	Justin	\N	user486@mail.com
227	Rodriguez	Sergey	\N	user286@mail.com
228	Clark	Michael	\N	user76@mail.com
229	Robinson	Patrick	\N	user857@mail.com
230	Harris	Joseph	\N	user896@mail.com
231	Williams	John	\N	user352@mail.com
232	Johnson	William	\N	user926@mail.com
233	Martin	Nicholas	\N	user152@mail.com
234	Kuznetsov	Dmitry	\N	user751@mail.com
235	Jackson	Robert	\N	user923@mail.com
236	Thomas	John	\N	user733@mail.com
237	Jackson	Scott	\N	user463@mail.com
238	Sidorov	Sergey	\N	user977@mail.com
239	Taylor	David	\N	user959@mail.com
240	Petrov	Andrew	\N	user902@mail.com
241	Robinson	Justin	\N	user913@mail.com
242	Rodriguez	Benjamin	\N	user940@mail.com
243	Petrov	Matthew	\N	user626@mail.com
244	Garcia	Mark	\N	user608@mail.com
245	Wilson	Daniel	\N	user931@mail.com
246	Moore	Sergey	\N	user265@mail.com
247	Garcia	Dmitry	\N	user726@mail.com
248	Garcia	David	\N	user642@mail.com
249	Davis	Peter	\N	user814@mail.com
250	Clark	Dmitry	\N	user726@mail.com
\.


--
-- TOC entry 5124 (class 0 OID 17285)
-- Dependencies: 222
-- Data for Name: book; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.book (id, title, category, year, pages) FROM stdin;
301	HTML & CSS Design	Алгоритмы	2016	434
302	Agile Methodologies	БД	2019	159
303	Frontend Development	Программирование	2002	969
304	React for Beginners	Программирование	2014	124
305	SQL for Everyone	БД	2012	447
306	Data Science Handbook	БД	2002	253
307	APIs and Microservices	Программирование	2016	354
308	Docker Essentials	БД	2010	493
309	Vue.js Mastery	БД	2016	485
310	Kotlin for Android	Программирование	2005	888
311	Backend Development	Программирование	2001	582
312	Ruby on Rails Guide	БД	2006	880
313	Node.js Guide	Алгоритмы	2012	710
314	JavaScript Essentials	БД	2014	484
315	DevOps Practices	БД	2020	266
316	Game Development	БД	2008	255
317	Introduction to AI	Алгоритмы	2017	842
318	SQL for Everyone	Алгоритмы	2019	881
319	Cloud Computing	Программирование	2008	233
320	Deep Learning with Python	БД	2008	640
321	Docker Essentials	Программирование	2007	134
322	Python 101	Программирование	2008	776
323	Cloud Computing	БД	2008	185
324	Software Testing	БД	2020	876
325	SQL for Everyone	Алгоритмы	2022	933
326	Java in Practice	Программирование	2018	490
327	Python 101	Алгоритмы	2016	201
328	Ruby on Rails Guide	Алгоритмы	2014	528
329	React for Beginners	Алгоритмы	2013	584
330	Agile Methodologies	Программирование	2013	981
331	JavaScript Essentials	Программирование	2008	934
332	SQL for Everyone	Алгоритмы	2003	308
333	Networking 101	Программирование	2005	130
334	Functional Programming	Алгоритмы	2012	212
335	Big Data Analytics	БД	2013	846
336	Java in Practice	Алгоритмы	2024	975
337	Docker Essentials	Алгоритмы	2011	675
338	Vue.js Mastery	Программирование	2014	328
339	Kotlin for Android	Программирование	2001	627
340	Vue.js Mastery	Алгоритмы	2009	357
341	Linux Administration	БД	2023	337
342	Introduction to AI	Программирование	2001	144
343	APIs and Microservices	БД	2012	712
344	Blockchain Fundamentals	Программирование	2004	371
345	Networking 101	Программирование	2019	738
346	Backend Development	БД	2004	878
347	Blockchain Fundamentals	Программирование	2007	816
348	Cybersecurity Basics	Программирование	2014	650
151	SQL для всех	Программирование	2024	813
152	SQL для всех	Программирование	2005	829
153	Python 101	Программирование	2011	552
154	Базы данных	Алгоритмы	2004	124
155	Базы данных	Программирование	2021	811
156	SQL для всех	Программирование	2009	720
157	Python 101	Алгоритмы	2013	615
158	Алгоритмы	Программирование	2014	767
159	Алгоритмы	Программирование	2003	157
160	Python 101	Алгоритмы	2001	372
161	Python 101	Алгоритмы	2004	492
162	SQL для всех	БД	2023	830
163	Backend разработка	БД	2007	478
164	SQL для всех	Алгоритмы	2020	244
165	Python 101	БД	2000	911
166	Backend разработка	Программирование	2000	786
167	Python 101	БД	2006	443
168	Алгоритмы	Программирование	2019	549
169	SQL для всех	БД	2002	782
170	Python 101	Программирование	2003	301
171	Python 101	Программирование	2017	109
172	SQL для всех	Алгоритмы	2009	942
173	Python 101	Алгоритмы	2020	669
174	Алгоритмы	Программирование	2014	344
175	Базы данных	Программирование	2013	539
176	Backend разработка	БД	2002	791
177	Алгоритмы	Алгоритмы	2015	600
178	SQL для всех	БД	2011	190
179	Python 101	БД	2011	786
180	SQL для всех	Программирование	2017	356
181	Backend разработка	Алгоритмы	2001	486
182	SQL для всех	БД	2006	830
183	SQL для всех	БД	2004	774
184	Backend разработка	Программирование	2024	624
185	Алгоритмы	Программирование	2022	188
186	SQL для всех	Программирование	2001	403
187	Алгоритмы	Программирование	2023	891
188	Базы данных	БД	2013	573
189	SQL для всех	Алгоритмы	2020	926
190	Алгоритмы	Алгоритмы	2011	739
191	Python 101	Алгоритмы	2024	545
192	Backend разработка	БД	2015	683
193	Backend разработка	БД	2012	124
194	Backend разработка	БД	2017	836
195	Базы данных	Алгоритмы	2001	816
196	Backend разработка	Алгоритмы	2007	886
197	Базы данных	Программирование	2024	620
198	Backend разработка	Алгоритмы	2018	826
199	Python 101	БД	2012	805
200	SQL для всех	Программирование	2011	348
201	Big Data Analytics	БД	2001	678
202	Agile Methodologies	Алгоритмы	2016	966
203	Java in Practice	БД	2024	137
204	Go Programming	Алгоритмы	2022	402
205	Software Testing	БД	2022	656
206	Swift Fundamentals	Программирование	2020	947
207	Kotlin for Android	Алгоритмы	2014	193
208	Linux Administration	БД	2002	659
209	Introduction to AI	Программирование	2017	863
210	Cybersecurity Basics	БД	2016	762
211	Python 101	Программирование	2006	813
212	Cloud Computing	Программирование	2014	367
213	Linux Administration	Алгоритмы	2011	466
214	Vue.js Mastery	Программирование	2005	712
215	Blockchain Fundamentals	Программирование	2013	902
216	Databases	Алгоритмы	2008	553
217	Big Data Analytics	Программирование	2003	886
218	Vue.js Mastery	Программирование	2001	438
219	Cloud Computing	Программирование	2003	524
220	Cybersecurity Basics	БД	2011	603
221	Go Programming	Программирование	2005	190
222	Java in Practice	Программирование	2001	878
223	HTML & CSS Design	Алгоритмы	2002	807
224	React for Beginners	Алгоритмы	2011	930
225	Linux Administration	БД	2013	675
226	Networking 101	БД	2017	116
227	C++ Programming	Программирование	2001	420
228	Machine Learning Basics	Программирование	2004	121
229	Databases	Алгоритмы	2010	745
230	Networking 101	БД	2019	901
231	Node.js Guide	БД	2024	193
232	SQL for Everyone	Алгоритмы	2008	208
233	Big Data Analytics	БД	2007	264
234	React for Beginners	Программирование	2000	389
235	Python 101	Программирование	2008	803
236	DevOps Practices	БД	2022	654
237	DevOps Practices	Программирование	2007	131
238	Big Data Analytics	Алгоритмы	2023	771
239	APIs and Microservices	Алгоритмы	2009	253
240	Vue.js Mastery	БД	2024	546
241	Cloud Computing	Программирование	2020	218
242	Databases	БД	2018	652
243	SQL for Everyone	Алгоритмы	2005	120
244	Deep Learning with Python	БД	2019	865
245	Introduction to AI	Программирование	2023	281
246	DevOps Practices	Программирование	2003	817
247	SQL for Everyone	БД	2019	180
248	JavaScript Essentials	Программирование	2002	386
249	HTML & CSS Design	Алгоритмы	2000	779
250	Big Data Analytics	Алгоритмы	2002	702
349	Networking 101	БД	2022	772
350	Kotlin for Android	Программирование	2020	910
\.


--
-- TOC entry 5126 (class 0 OID 17302)
-- Dependencies: 224
-- Data for Name: book_author; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.book_author (id, book_id, author_id, author_order) FROM stdin;
301	220	243	1
302	234	221	3
303	213	248	2
304	229	221	3
305	247	249	2
306	240	242	2
307	245	209	3
308	231	219	3
309	218	244	2
310	222	224	1
311	216	228	1
312	205	211	2
313	234	241	1
314	238	248	1
315	242	225	2
316	238	236	1
317	247	220	2
318	202	241	1
319	224	221	3
320	241	238	3
321	226	204	1
322	230	228	1
323	204	237	1
324	242	208	2
325	243	225	3
326	205	223	1
327	240	206	3
328	210	239	1
329	234	201	2
330	209	237	3
331	226	223	1
332	212	242	2
333	217	237	1
334	202	226	2
335	242	231	1
336	223	241	2
337	248	223	3
338	244	243	3
339	229	220	3
340	219	240	1
341	225	233	3
342	212	249	1
343	207	238	2
344	217	224	2
345	218	232	1
346	238	204	3
347	245	245	1
348	218	228	1
349	239	217	3
350	249	215	2
351	208	213	3
352	216	203	1
353	201	241	2
354	217	211	3
355	215	204	1
356	204	233	1
357	218	207	1
358	247	216	2
359	223	229	3
360	217	206	2
361	235	208	3
362	213	222	2
363	223	227	2
364	247	237	3
365	231	240	2
366	237	244	2
367	211	242	2
368	205	246	3
369	214	235	3
370	222	237	2
371	227	246	3
372	232	245	2
373	227	209	3
374	236	240	3
375	245	223	2
376	216	216	3
377	205	247	3
378	245	218	3
379	227	230	3
380	234	208	1
381	212	250	2
382	212	234	3
383	237	212	2
384	237	240	3
385	211	209	2
386	226	242	3
387	219	248	3
388	239	203	2
389	240	204	1
390	219	217	3
391	207	202	2
392	219	224	3
393	207	203	3
394	231	208	1
395	235	217	1
396	218	236	1
397	245	214	2
398	206	229	3
399	210	212	2
400	245	228	2
201	193	196	3
202	191	168	3
203	153	157	2
204	156	198	2
205	189	174	1
206	153	176	1
207	164	172	2
208	153	176	2
209	167	171	3
210	156	193	2
211	196	166	2
212	176	195	2
213	183	174	2
214	168	160	2
215	152	177	3
216	195	153	1
217	196	164	1
218	181	192	3
219	189	177	2
220	196	200	2
221	200	200	3
222	151	181	2
223	180	153	2
224	159	189	2
225	184	171	3
226	197	162	3
227	198	180	2
228	195	168	3
229	198	153	3
230	174	161	2
231	154	152	1
232	199	192	2
233	160	177	1
234	168	171	1
235	200	167	2
236	189	160	2
237	177	172	3
238	177	171	1
239	184	155	3
240	191	152	3
241	172	181	2
242	184	162	3
243	185	174	1
244	188	197	2
245	183	165	2
246	190	188	3
247	182	194	2
248	160	170	1
249	161	168	1
250	167	175	2
251	154	190	2
252	182	178	1
253	167	173	3
254	180	154	2
255	174	160	2
256	172	158	2
257	166	184	2
258	171	199	3
259	185	163	1
260	161	170	2
261	154	172	1
262	152	157	2
263	177	196	3
264	184	151	2
265	190	196	1
266	157	182	1
267	171	176	1
268	175	189	3
269	186	166	2
270	194	183	1
271	162	175	3
272	151	194	2
273	179	180	3
274	190	180	1
275	190	158	1
276	156	174	2
277	187	199	1
278	199	190	3
279	161	153	2
280	200	159	1
281	165	198	2
282	171	170	2
283	153	164	2
284	175	198	2
285	188	194	2
286	183	161	2
287	198	172	3
288	187	170	3
289	168	197	1
290	178	151	2
291	160	200	2
292	199	191	1
293	186	198	1
294	169	151	2
295	162	155	3
296	158	166	1
297	174	160	2
298	159	154	1
299	170	153	1
300	181	180	1
501	329	326	2
502	332	329	3
503	309	339	1
504	345	341	1
505	319	329	1
506	301	309	1
507	333	325	1
508	315	318	2
509	327	330	3
510	322	313	3
511	349	336	2
512	322	307	3
513	348	306	2
514	350	301	3
515	306	309	2
516	319	319	3
517	317	324	1
518	315	346	1
519	319	323	1
520	335	325	2
521	312	317	1
522	340	311	2
523	301	332	3
524	348	308	1
525	329	344	1
526	305	317	1
527	344	337	2
528	341	337	3
529	314	304	1
530	349	346	2
531	332	326	3
532	345	328	3
533	319	324	3
534	330	314	2
535	324	326	2
536	312	309	3
537	321	331	2
538	314	337	3
539	311	319	1
540	319	337	2
541	306	305	1
542	322	322	1
543	319	317	3
544	325	306	2
545	312	322	1
546	303	317	1
547	341	322	1
548	302	346	3
549	330	327	2
550	321	349	3
551	313	310	1
552	318	327	3
553	323	314	2
554	301	331	2
555	321	330	3
556	307	331	3
557	336	350	2
558	301	310	3
559	307	317	1
560	327	332	2
561	313	334	3
562	328	317	3
563	340	308	1
564	335	346	2
565	339	342	2
566	308	334	3
567	347	326	1
568	332	302	2
569	350	331	2
570	306	328	2
571	349	315	3
572	306	317	1
573	318	332	2
574	338	315	2
575	340	348	3
576	323	336	3
577	344	330	1
578	338	325	1
579	345	333	1
580	338	343	3
581	343	350	1
582	317	302	2
583	336	302	2
584	324	344	3
585	317	337	3
586	327	337	3
587	333	324	2
588	301	334	3
589	345	344	3
590	350	320	1
591	305	347	2
592	343	302	3
593	310	304	1
594	339	324	1
595	329	330	1
596	339	340	3
597	312	337	2
598	321	317	1
599	312	344	2
600	326	314	1
\.


--
-- TOC entry 5140 (class 0 OID 17428)
-- Dependencies: 238
-- Data for Name: contract; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.contract (id, order_id, customer_id, contract_number, sign_date, close_date) FROM stdin;
2	373	175	30091	2017-12-10	2018-01-15
3	342	159	42837	2017-05-18	\N
4	390	179	50768	2021-09-24	2022-03-03
5	361	171	45208	2024-03-19	2024-03-30
6	396	153	23961	2019-04-19	2019-08-01
7	312	152	17797	2024-08-27	2024-09-27
8	337	168	48493	2021-11-28	2022-03-14
9	323	164	53801	2015-06-21	\N
10	354	178	64228	2024-07-04	2024-11-29
11	331	162	23815	2020-06-20	2020-12-12
12	385	177	68229	2017-05-20	\N
13	338	156	54494	2022-11-18	2023-02-10
14	328	152	42827	2018-04-16	2018-10-01
15	348	179	39971	2019-12-30	2020-03-10
16	328	151	78425	2023-06-29	2023-11-13
17	403	168	80170	2016-04-08	2016-05-25
18	392	171	13849	2024-08-30	\N
19	331	172	68628	2018-12-31	\N
20	322	152	99203	2017-12-06	2018-04-22
21	326	172	74717	2023-09-25	\N
22	363	163	42314	2022-08-02	2022-12-14
23	331	174	82707	2017-08-15	2017-11-19
24	405	178	97762	2019-09-04	2020-02-08
25	369	151	60488	2019-12-10	2020-01-21
26	346	161	34256	2018-10-08	2018-12-28
27	307	158	15854	2015-06-24	\N
28	340	161	20064	2015-11-08	2016-02-09
29	340	160	50125	2020-01-25	\N
30	388	177	26895	2018-12-12	2019-05-13
31	341	160	38700	2022-08-13	2023-01-14
32	346	156	98973	2020-01-20	2020-05-10
33	353	167	40512	2018-01-27	\N
34	401	168	95125	2015-05-03	2015-08-03
35	375	164	86642	2018-03-28	2018-06-30
36	384	153	94835	2019-06-17	\N
37	377	178	80922	2021-01-16	\N
38	362	156	17601	2017-09-02	2018-02-20
39	376	175	27407	2023-07-14	\N
40	382	158	24211	2023-08-15	\N
41	396	173	26727	2016-08-23	\N
42	401	174	17227	2015-11-22	2016-01-03
43	363	162	20046	2016-11-21	2017-05-03
44	317	178	46601	2023-05-20	2023-10-16
45	377	161	65715	2018-07-12	2018-08-21
46	313	151	17226	2018-10-24	2018-11-14
47	347	167	66466	2021-06-08	\N
48	394	176	94746	2023-02-13	2023-06-26
49	346	155	51112	2023-11-04	2024-02-06
50	355	161	36225	2018-07-31	2018-12-22
51	357	166	15422	2021-05-13	2021-06-04
52	325	179	98242	2020-07-28	2020-10-21
53	328	157	20772	2019-05-04	2019-10-16
54	308	161	79661	2023-10-09	2024-02-03
55	365	160	77351	2019-06-24	2019-08-14
56	363	153	76457	2020-04-10	\N
57	357	159	42576	2021-09-24	\N
58	342	180	97240	2020-05-31	\N
59	401	166	51104	2018-04-29	\N
60	392	169	11030	2022-01-11	2022-03-19
61	369	164	57697	2015-01-02	2015-02-26
62	317	162	18941	2016-08-28	\N
63	318	158	19792	2021-12-27	2022-04-25
64	399	180	58937	2022-06-05	2022-10-10
65	369	162	15359	2023-07-12	\N
66	326	166	88568	2015-08-10	2016-01-31
67	342	155	82776	2024-12-12	\N
68	380	153	69652	2023-08-13	\N
69	391	179	41653	2022-12-11	\N
70	329	159	30085	2016-02-08	2016-04-13
71	393	160	84650	2017-09-25	2017-12-16
72	323	161	50559	2018-06-13	2018-09-22
73	355	172	17461	2024-08-19	\N
74	374	180	87074	2016-08-13	2016-10-09
75	352	175	89350	2023-05-09	2023-07-27
76	319	165	48178	2017-06-27	2017-11-03
77	380	157	90942	2022-02-09	\N
78	387	165	77710	2023-01-16	2023-06-19
79	361	164	86688	2016-01-01	\N
80	388	158	10790	2015-02-14	2015-03-13
81	403	177	64201	2019-10-24	2020-03-11
\.


--
-- TOC entry 5132 (class 0 OID 17351)
-- Dependencies: 230
-- Data for Name: customer; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.customer (id, name, address, phone) FROM stdin;
91	Компания 34	Москва	+79900473738
92	Компания 72	Москва	+79617191922
93	Компания 41	Москва	+79719010840
94	Компания 1	Москва	+79900277413
95	Компания 29	Москва	+79259449859
96	Компания 95	Москва	+79583298768
97	Компания 68	Москва	+79392107504
98	Компания 44	Москва	+79463882715
99	Компания 52	Москва	+79915366067
100	Компания 22	Москва	+79257602158
101	Компания 44	Москва	+79816219425
102	Компания 64	Москва	+79437090536
103	Компания 5	Москва	+79242338124
104	Компания 40	Москва	+79673905845
105	Компания 28	Москва	+79630075903
106	Компания 27	Москва	+79665322055
107	Компания 16	Москва	+79348811452
108	Компания 62	Москва	+79535849069
109	Компания 58	Москва	+79587618685
110	Компания 79	Москва	+79979819277
111	Компания 66	Москва	+79826408588
112	Компания 22	Москва	+79632790081
113	Компания 13	Москва	+79607541199
114	Компания 28	Москва	+79128709197
115	Компания 39	Москва	+79340829474
116	Компания 41	Москва	+79122812070
117	Компания 39	Москва	+79266973111
118	Компания 90	Москва	+79557322235
119	Компания 71	Москва	+79817807193
120	Компания 40	Москва	+79884421435
61	Компания 64	Москва	+79406290630
62	Компания 80	Москва	+79180245334
63	Компания 73	Москва	+79217843393
64	Компания 77	Москва	+79556900684
65	Компания 64	Москва	+79287461481
66	Компания 58	Москва	+79966032097
67	Компания 49	Москва	+79738908317
68	Компания 98	Москва	+79195384506
69	Компания 10	Москва	+79913056980
70	Компания 97	Москва	+79608420809
71	Компания 55	Москва	+79142942185
72	Компания 66	Москва	+79715152359
73	Компания 88	Москва	+79483036931
74	Компания 100	Москва	+79155465261
75	Компания 46	Москва	+79677264428
76	Компания 96	Москва	+79621975565
77	Компания 38	Москва	+79332094420
78	Компания 16	Москва	+79176206924
79	Компания 50	Москва	+79784324767
80	Компания 53	Москва	+79965510110
81	Компания 91	Москва	+79527836439
82	Компания 50	Москва	+79167285871
83	Компания 55	Москва	+79637684329
84	Компания 60	Москва	+79577047311
85	Компания 57	Москва	+79534800239
86	Компания 26	Москва	+79771306364
87	Компания 47	Москва	+79562906601
88	Компания 25	Москва	+79789212679
89	Компания 86	Москва	+79477897216
90	Компания 51	Москва	+79358018026
151	Компания 87	Москва	+79280358276
152	Компания 41	Москва	+79278602104
153	Компания 59	Москва	+79473506266
154	Компания 85	Москва	+79844606090
155	Компания 88	Москва	+79976599569
156	Компания 30	Москва	+79523752286
157	Компания 26	Москва	+79922276504
158	Компания 97	Москва	+79156959066
159	Компания 49	Москва	+79628015170
160	Компания 73	Москва	+79323524447
161	Компания 88	Москва	+79377565396
162	Компания 86	Москва	+79382512460
163	Компания 97	Москва	+79532788897
164	Компания 40	Москва	+79135918750
165	Компания 87	Москва	+79334125255
166	Компания 75	Москва	+79947495185
167	Компания 92	Москва	+79415621982
168	Компания 85	Москва	+79922301754
169	Компания 31	Москва	+79911329018
170	Компания 17	Москва	+79463989394
171	Компания 76	Москва	+79343579529
172	Компания 7	Москва	+79534165603
173	Компания 28	Москва	+79538026933
174	Компания 17	Москва	+79600258902
175	Компания 32	Москва	+79387083612
176	Компания 99	Москва	+79828593072
177	Компания 97	Москва	+79600828515
178	Компания 55	Москва	+79302613948
179	Компания 100	Москва	+79557083299
180	Компания 84	Москва	+79738356647
\.


--
-- TOC entry 5128 (class 0 OID 17314)
-- Dependencies: 226
-- Data for Name: edition; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.edition (id, book_id, isbn, edition_number, year, pages, price) FROM stdin;
241	214	6604223555304	\N	2011	214	1576.12
242	208	4097975769063	\N	2023	688	1143.96
243	225	7549945348999	\N	2016	784	383.68
244	208	4321445238796	\N	2015	641	1727.84
245	210	5482504611560	\N	2010	545	1475.80
246	230	2475724730406	\N	2012	901	1654.65
247	219	2331484042079	\N	2002	923	1653.49
248	247	6226304267321	\N	2008	613	1738.22
249	201	6932039009167	\N	2014	744	1896.79
250	244	4847128925322	\N	2005	864	635.08
251	231	3465749091164	\N	2021	833	1205.92
252	216	2599567344633	\N	2022	178	418.87
253	214	1333234962378	\N	2005	957	758.46
254	224	8103506594926	\N	2020	600	1719.56
255	228	6251983580587	\N	2020	428	1935.15
256	212	4252761834146	\N	2005	371	1552.54
257	214	1927359989200	\N	2021	848	671.99
258	213	5703705917544	\N	2017	948	571.15
259	239	4582266097125	\N	2015	774	1448.98
260	225	7178947351210	\N	2013	424	472.34
261	219	3578634719147	\N	2018	344	1179.87
262	225	5397058246559	\N	2003	456	433.06
263	220	7086203765928	\N	2002	512	1786.28
264	226	7663027624403	\N	2002	109	778.75
265	208	9866258935173	\N	2014	445	1585.33
266	250	1010181583172	\N	2006	718	770.84
267	243	6805776917305	\N	2012	821	1502.51
268	233	7886313206808	\N	2013	982	1605.22
269	218	2914389090935	\N	2023	455	1830.83
270	207	7323349112123	\N	2008	424	347.66
271	209	1222623665450	\N	2020	191	1900.74
272	211	6497224706570	\N	2021	629	1750.22
273	223	3294559225788	\N	2005	165	751.36
274	246	6672376419639	\N	2024	272	1857.83
275	239	3716967794742	\N	2014	927	1588.21
276	225	9521031233206	\N	2001	572	1856.55
277	220	8132541139880	\N	2009	138	1078.00
278	215	5682678452253	\N	2001	436	1897.69
279	216	7662345446957	\N	2024	557	283.28
280	234	7862940148429	\N	2012	244	1873.31
281	250	2856320642653	\N	2009	377	434.45
282	236	3501137381717	\N	2014	339	1645.28
283	223	4748532600922	\N	2022	861	1041.88
284	207	5016651012378	\N	2022	323	938.35
285	232	1293232964647	\N	2022	916	991.07
286	209	4629848878710	\N	2017	129	1251.89
287	218	2350205483145	\N	2014	724	1142.44
288	242	1348065169921	\N	2008	677	908.49
289	248	9374763050209	\N	2012	278	468.04
290	218	9752276446543	\N	2011	432	938.40
291	225	7814717239314	\N	2014	415	1483.97
292	229	3679140898326	\N	2012	367	1699.96
293	233	1330958830484	\N	2006	219	1063.77
294	221	2192973941182	\N	2005	141	227.01
295	218	6154718333958	\N	2015	325	894.58
296	214	2028075716494	\N	2012	894	506.95
297	208	5151598727464	\N	2016	158	1689.11
298	219	4139778207028	\N	2020	960	912.89
299	206	5143172888641	\N	2014	106	550.75
300	213	4302291260777	\N	2016	902	1139.57
301	242	3835065385733	\N	2021	860	1874.38
302	212	8799127137550	\N	2013	659	271.55
303	239	7094997084602	\N	2018	927	521.85
304	241	6387017705949	\N	2003	444	1049.10
305	223	8074944900539	\N	2018	618	1992.31
306	227	5158753314972	\N	2019	809	1855.20
307	206	8433445420286	\N	2012	295	1528.45
308	231	1160867781668	\N	2014	200	434.21
309	230	5429322658651	\N	2016	244	1329.37
310	234	4881873087730	\N	2011	132	263.02
311	227	3877898913204	\N	2020	193	941.06
312	219	3978282483745	\N	2007	514	777.03
313	214	8599662068194	\N	2018	309	1560.04
314	202	1631364094970	\N	2016	219	781.59
315	240	7570043735857	\N	2018	736	1193.93
316	239	6439083551194	\N	2008	277	1079.46
317	242	1638497559835	\N	2021	529	1415.69
318	203	6906787980290	\N	2001	405	1301.07
319	233	7630564743901	\N	2005	750	281.40
320	206	1855835843440	\N	2024	340	1244.30
161	188	2665724612492	\N	2014	820	643.89
162	152	9970094449295	\N	2012	898	559.75
163	160	1366098893535	\N	2001	468	603.79
164	195	5415265638898	\N	2016	251	1638.68
165	175	4906997817621	\N	2009	694	277.40
166	166	5701907437941	\N	2010	124	574.68
167	195	8914115203914	\N	2018	669	360.04
168	193	3441592525311	\N	2015	717	1093.28
169	167	2041427800372	\N	2022	751	1899.74
170	185	8321025022588	\N	2009	958	1630.16
171	155	1654346657662	\N	2020	483	1026.52
172	181	6125560678693	\N	2020	495	629.24
173	192	5130930521497	\N	2018	971	1596.72
174	169	9880639932072	\N	2015	248	518.83
175	154	2517544534675	\N	2002	137	238.37
176	197	4154619389931	\N	2013	246	252.80
177	191	3227141367837	\N	2001	261	1899.39
178	163	1411048107694	\N	2002	209	1096.27
179	182	2302203256038	\N	2016	741	260.16
180	156	6638016452627	\N	2012	252	1447.77
181	195	1899051704879	\N	2014	701	664.09
182	174	3194302323339	\N	2019	663	876.05
183	173	5545844959589	\N	2005	872	928.59
184	188	7455854619425	\N	2012	788	1539.72
185	196	6415683245733	\N	2016	580	1411.19
186	167	2449005530581	\N	2000	351	1924.90
187	179	9511588030799	\N	2023	191	802.15
188	152	1725999963247	\N	2016	409	1986.44
189	157	6864502949434	\N	2008	244	501.59
190	167	8607162159486	\N	2020	934	690.10
191	173	9994008703752	\N	2013	411	1944.30
192	188	8566334110881	\N	2017	932	1850.74
193	199	3610930063055	\N	2024	993	581.96
194	199	3417050740764	\N	2009	563	1421.75
195	152	9017885384143	\N	2010	976	1433.09
196	181	5444609618862	\N	2012	117	999.94
197	160	1521339872707	\N	2008	733	949.04
198	174	5768501432661	\N	2022	317	1418.40
199	179	4160257377955	\N	2014	704	1157.89
200	163	9530160471884	\N	2007	745	1535.16
201	183	5670676921125	\N	2023	937	1934.36
202	160	3040405127707	\N	2004	832	1906.58
203	187	8489158119379	\N	2013	932	1460.81
204	177	1598803505288	\N	2006	473	784.76
205	161	1908797976150	\N	2006	127	936.92
206	196	8215357664362	\N	2000	604	1800.97
207	163	2795338674449	\N	2017	906	1110.17
208	199	9604533304965	\N	2007	858	756.41
209	155	5312389305634	\N	2004	458	1103.20
210	182	8578325358486	\N	2015	619	564.39
211	185	2867372294910	\N	2010	645	250.00
212	195	6710041125451	\N	2005	900	1828.98
213	153	4083660425926	\N	2022	907	1817.88
214	162	1216762823033	\N	2018	221	790.41
215	173	2170080014699	\N	2004	829	1957.50
216	199	3931791763432	\N	2012	449	1476.52
217	156	3366895709084	\N	2005	969	982.58
218	196	1565667056502	\N	2004	599	888.47
219	174	5550733350731	\N	2001	714	1975.92
220	184	4734040634047	\N	2023	475	1025.92
221	162	6439995891165	\N	2011	969	729.60
222	166	1070247610725	\N	2005	545	856.89
223	176	4883887843748	\N	2011	457	1182.67
224	163	6620114388629	\N	2007	387	1325.50
225	175	7217406538602	\N	2002	274	1633.14
226	194	3177300702173	\N	2024	842	1406.42
227	186	9701801763836	\N	2015	999	1724.99
228	195	2888949040110	\N	2019	208	1777.49
229	170	8379036131129	\N	2006	474	683.67
230	186	7109882458562	\N	2011	935	842.03
231	178	1238936069357	\N	2016	389	1650.83
232	175	2527866365174	\N	2002	272	426.72
233	184	8690028188081	\N	2016	103	1206.86
234	192	7465644423298	\N	2018	1000	238.35
235	178	7278964506422	\N	2016	860	264.31
236	161	2483787235847	\N	2023	338	239.61
237	172	8519294303116	\N	2004	210	1021.48
238	158	3226165410776	\N	2007	382	660.68
239	192	3279344022111	\N	2011	560	1550.88
240	156	3055033886925	\N	2019	801	1856.49
401	313	5438650342534	4	2020	606	396.57
402	317	4072897396128	4	2007	155	272.48
403	315	1373120701207	1	2005	528	1219.85
404	336	1844261239986	3	2022	770	1456.42
405	329	8651860724032	4	2010	945	803.53
406	345	2468425747589	4	2000	751	1637.71
407	321	3162581639046	3	2012	339	1585.92
408	339	2085534707447	2	2001	559	1587.98
409	311	3594526518147	3	2012	279	942.33
410	347	6937124182242	3	2018	545	1006.95
411	325	2278786746673	2	2001	397	819.10
412	326	9644083452190	3	2010	262	1321.03
413	304	4485170000512	5	2020	668	405.50
414	346	7614202938880	4	2021	861	536.14
415	346	6208648199745	1	2017	681	1348.30
416	320	9686901772341	3	2011	777	1828.10
417	324	4880561944889	4	2004	372	218.17
418	320	5991550834156	3	2023	494	1876.75
419	327	8413405624009	2	2024	521	1765.53
420	318	7061677816801	4	2014	732	334.96
421	316	5440467547915	2	2003	441	495.19
422	303	9121222330361	1	2020	370	846.98
423	328	3818084679885	1	2001	186	963.52
424	350	8458190569422	4	2019	891	632.77
425	319	7991466952742	3	2001	136	400.72
426	343	6753717950997	2	2010	675	1595.52
427	348	3037158604087	3	2020	238	1291.25
428	315	9512312999063	4	2017	869	578.72
429	338	6081692618654	2	2002	933	1130.30
430	313	6361989379536	3	2011	404	228.08
431	311	7920502528193	4	2008	246	976.21
432	328	2066085651765	1	2007	779	885.92
433	315	6516956248875	2	2003	995	786.29
434	335	2774806406145	5	2010	122	1241.74
435	317	1389042034262	5	2020	891	277.49
436	344	2160576916832	1	2002	459	1877.77
437	346	9768798626776	5	2019	186	1890.74
438	345	5666889537335	5	2005	579	301.10
439	315	4087467611545	2	2012	115	1578.15
440	305	5194898861777	1	2017	518	1528.60
441	313	7975211827503	1	2023	295	312.54
442	307	8633036375974	4	2007	192	1096.73
443	301	4832008225167	3	2022	500	885.40
444	322	3722081770582	4	2007	153	1245.57
445	303	7311881157368	2	2020	188	1533.43
446	302	1058391430485	5	2019	535	1500.23
447	301	8860464182332	3	2016	851	521.62
448	329	4446838403106	5	2008	193	887.80
449	310	9869413228786	4	2011	950	1067.80
450	336	3882500691478	5	2012	714	514.13
451	303	7535495086684	4	2008	759	1601.81
452	329	4207453777779	5	2023	416	236.91
453	327	2503168243929	2	2020	695	1200.71
454	303	3436872671577	2	2004	403	703.59
455	316	9458120388584	2	2013	206	245.00
456	341	4245643498550	5	2023	627	1526.33
457	329	1163649232764	3	2016	817	452.24
458	326	1388728692899	4	2009	367	984.87
459	308	3522329953226	1	2021	711	920.29
460	321	4045792785691	1	2006	835	1067.25
461	319	8572274805306	3	2016	805	1093.77
462	337	4327919150416	2	2024	401	1507.80
463	311	3351303256367	2	2007	980	1852.85
464	330	6888170961248	5	2022	645	1206.19
465	304	4853056981481	1	2003	920	1466.12
466	347	6355950111861	5	2007	482	1875.29
467	334	8042018262585	2	2014	210	970.83
468	319	5965160798548	1	2020	505	1372.42
469	345	9161708033298	2	2014	694	635.18
470	309	8782581547575	3	2008	584	548.29
471	305	7187059528707	2	2004	458	435.79
472	345	6173358397185	1	2008	906	829.39
473	338	8079950934403	2	2005	399	281.49
474	327	4888764515060	1	2016	451	205.43
475	336	6546064407068	5	2012	438	1938.55
476	330	8024690685223	2	2022	117	517.88
477	322	8990687304446	2	2010	966	1096.47
478	312	8097396485237	4	2007	350	1473.19
479	307	8009431761441	1	2011	202	327.44
480	302	2916869853674	4	2010	663	556.17
\.


--
-- TOC entry 5144 (class 0 OID 17469)
-- Dependencies: 242
-- Data for Name: editor; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.editor (id, last_name, first_name, middle_name) FROM stdin;
16	Gonzalez	Timothy	Сергеевич
17	Jackson	Patrick	\N
18	Martinez	David	Петрович
19	Petrov	Patrick	Александрович
20	Moore	Sergey	Петрович
21	Young	Daniel	Петрович
22	White	John	Сергеевич
23	White	Andrew	Александрович
24	Harris	Jason	Петрович
25	Miller	Eric	\N
26	Kuznetsov	Andrew	Александрович
27	Martin	Robert	Петрович
28	Miller	Thomas	Иванович
29	Martinez	Mark	\N
30	Perez	James	Петрович
\.


--
-- TOC entry 5134 (class 0 OID 17360)
-- Dependencies: 232
-- Data for Name: manager; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.manager (id, last_name, first_name, middle_name) FROM stdin;
21	Кузнецов	Сергей	\N
22	Кузнецов	Иван	\N
23	Кузнецов	Иван	\N
24	Петров	Алексей	\N
25	Петров	Иван	\N
26	Сидоров	Петр	\N
27	Смирнов	Дмитрий	\N
28	Петров	Дмитрий	\N
29	Петров	Алексей	\N
30	Кузнецов	Дмитрий	\N
31	Hernandez	Thomas	\N
32	Garcia	Jonathan	\N
33	Johnson	Richard	\N
34	Jackson	Jonathan	\N
35	Martin	James	\N
36	Brown	John	\N
37	Smith	Thomas	\N
38	Wilson	Nicholas	\N
39	Martin	Nicholas	\N
40	Jackson	Scott	\N
51	Hernandez	Mark	\N
52	Perez	Jonathan	\N
53	Brown	Jason	\N
54	Anderson	Paul	\N
55	Wilson	Robert	\N
56	Martin	Dmitry	\N
57	Robinson	Richard	\N
58	Rodriguez	Richard	\N
59	Rodriguez	Nicholas	\N
60	Garcia	Daniel	\N
\.


--
-- TOC entry 5136 (class 0 OID 17370)
-- Dependencies: 234
-- Data for Name: order; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing."order" (id, customer_id, manager_id, order_date, status) FROM stdin;
306	165	54	2024-06-03	in procgress
307	155	58	2019-02-02	done
308	163	57	2020-12-21	new
6	90	28	2021-02-11	done
7	69	21	2024-01-23	in procgress
8	62	29	2017-07-11	in procgress
9	72	30	2024-11-12	new
10	88	24	2018-09-06	new
11	67	30	2016-01-13	new
12	88	21	2016-10-26	new
13	61	25	2023-09-03	in procgress
14	67	24	2017-12-16	done
15	68	23	2021-08-06	done
16	81	27	2019-04-29	new
17	75	25	2022-03-23	new
18	64	22	2019-09-12	done
19	73	30	2015-11-03	new
20	64	25	2021-07-31	in procgress
21	69	21	2021-03-28	new
22	78	23	2017-04-07	new
23	68	27	2020-03-16	in procgress
24	84	28	2021-03-31	done
25	71	22	2016-01-12	in procgress
26	67	30	2024-10-24	new
27	82	28	2023-01-06	in procgress
28	66	29	2023-11-23	done
29	78	25	2023-07-14	done
30	79	25	2015-04-15	done
31	74	23	2019-10-30	done
32	83	27	2023-03-16	in procgress
33	78	24	2015-10-13	in procgress
34	84	21	2021-01-16	done
35	90	21	2017-03-14	in procgress
36	90	24	2015-09-05	in procgress
37	63	26	2023-10-15	done
38	74	28	2021-01-28	in procgress
39	74	30	2019-12-04	done
40	68	22	2024-07-26	done
41	79	26	2022-10-28	new
42	86	28	2017-05-27	done
43	88	28	2018-07-29	new
44	65	28	2018-01-25	done
45	63	28	2023-07-20	in procgress
46	90	30	2024-06-27	done
47	61	23	2016-01-29	done
48	76	27	2017-08-28	done
49	74	21	2016-06-15	in procgress
50	73	23	2022-10-23	new
51	71	30	2019-03-20	done
52	63	30	2021-10-12	done
53	72	28	2017-08-26	done
54	65	21	2018-08-15	done
55	69	23	2015-04-06	done
56	72	22	2016-06-01	new
57	72	28	2019-06-21	done
58	88	26	2015-08-24	done
59	64	28	2018-12-20	new
60	65	22	2018-11-04	new
61	64	30	2019-05-28	done
62	72	23	2024-10-24	in procgress
63	77	27	2015-08-26	done
64	64	28	2016-11-10	new
65	86	25	2015-07-11	new
66	67	23	2021-11-15	in procgress
67	65	26	2015-08-21	done
68	85	28	2018-12-26	new
69	77	25	2019-08-31	done
70	83	23	2019-01-30	new
71	64	24	2018-08-11	in procgress
72	64	24	2015-03-25	done
73	66	25	2022-04-09	in procgress
74	78	22	2020-09-18	done
75	81	29	2022-01-24	new
76	82	29	2022-12-06	done
77	78	22	2016-05-16	done
78	88	28	2024-06-12	done
79	81	21	2016-05-28	new
80	85	25	2020-08-02	new
81	69	21	2016-07-04	done
82	82	27	2023-06-23	in procgress
83	87	26	2020-12-10	done
84	74	29	2020-01-09	new
85	63	21	2017-11-07	new
86	74	25	2015-01-21	in procgress
87	86	21	2019-09-01	in procgress
88	68	27	2022-09-04	in procgress
89	69	24	2017-08-01	in procgress
90	67	23	2015-11-05	done
91	78	29	2022-01-20	in procgress
92	70	24	2023-10-01	in procgress
93	79	24	2018-10-08	new
94	65	22	2021-05-27	new
95	63	28	2015-10-23	done
96	62	21	2020-02-04	in procgress
97	67	30	2020-08-01	done
98	72	28	2024-03-28	done
99	88	23	2015-08-08	in procgress
100	73	28	2024-11-11	new
101	61	29	2022-04-23	done
102	61	29	2023-12-19	in procgress
103	72	24	2019-10-08	in procgress
104	74	28	2015-06-14	in procgress
105	70	22	2018-09-30	done
106	111	34	2018-05-18	in procgress
107	111	33	2019-04-03	in procgress
108	107	34	2023-02-12	new
109	116	36	2023-10-25	new
110	113	38	2023-11-30	in procgress
111	114	40	2022-03-29	new
112	91	31	2021-08-10	new
113	100	34	2016-10-03	new
114	104	37	2018-09-26	done
115	106	40	2022-12-17	new
116	99	31	2019-10-14	in procgress
117	99	36	2020-04-27	new
118	119	33	2019-01-29	new
119	107	40	2022-02-28	new
120	98	35	2016-04-12	new
121	103	36	2017-04-29	new
122	102	33	2022-06-28	new
123	118	35	2022-12-21	in procgress
124	96	39	2019-03-23	in procgress
125	108	38	2021-05-24	done
126	102	34	2020-05-18	new
127	109	32	2015-07-13	in procgress
128	110	37	2021-02-16	new
129	120	37	2024-05-29	new
130	106	38	2022-06-30	done
131	106	34	2022-09-22	in procgress
132	97	35	2018-09-27	done
133	120	34	2018-05-31	in procgress
134	99	33	2021-06-25	done
135	94	37	2023-11-17	done
136	93	31	2023-04-22	in procgress
137	97	33	2016-03-27	new
138	93	38	2023-03-06	in procgress
139	117	39	2023-05-27	in procgress
140	113	37	2023-11-27	done
141	101	33	2024-12-03	new
142	98	38	2024-06-09	in procgress
143	97	31	2024-03-01	new
144	98	36	2018-10-07	new
145	96	38	2023-10-22	done
146	119	39	2022-12-03	in procgress
147	97	31	2022-12-02	in procgress
148	113	33	2022-01-18	new
149	100	33	2016-07-23	in procgress
150	118	31	2019-09-22	new
151	100	31	2015-04-20	in procgress
152	116	38	2017-08-18	new
153	102	32	2015-06-19	done
154	94	33	2024-01-16	done
155	109	39	2019-01-17	done
156	110	39	2022-11-06	done
157	101	33	2017-02-04	done
158	93	32	2015-11-20	new
159	108	33	2017-06-10	new
160	93	37	2023-04-04	in procgress
161	109	31	2020-10-08	in procgress
162	93	36	2019-02-10	in procgress
163	97	40	2018-10-01	new
164	93	35	2018-09-11	done
165	102	31	2020-10-27	done
166	97	36	2024-07-20	done
167	93	32	2017-10-15	new
168	94	34	2015-10-26	new
169	104	31	2018-06-24	new
170	99	37	2018-07-11	in procgress
171	119	35	2022-10-23	in procgress
172	97	31	2023-04-27	new
173	110	38	2022-09-27	done
174	104	31	2019-07-20	new
175	111	31	2021-02-10	new
176	120	36	2023-12-02	done
177	97	38	2022-07-31	new
178	102	33	2024-08-10	in procgress
179	101	36	2023-06-11	in procgress
180	117	40	2015-10-24	new
181	91	40	2022-08-09	new
182	97	32	2019-04-09	in procgress
183	105	36	2022-03-28	done
184	95	37	2023-02-02	new
185	108	32	2024-12-23	new
186	104	39	2019-08-12	in procgress
187	113	33	2020-01-25	new
188	108	40	2024-02-28	in procgress
189	103	37	2019-05-25	in procgress
190	112	32	2018-11-27	new
191	104	34	2015-02-15	new
192	96	38	2015-06-04	new
193	99	36	2015-04-23	in procgress
194	95	32	2021-06-06	new
195	113	37	2022-06-23	new
196	120	35	2021-08-11	done
197	101	37	2016-04-04	new
198	115	37	2015-09-23	done
199	119	36	2024-12-01	done
200	120	32	2023-09-17	in procgress
201	101	36	2020-01-08	done
202	96	37	2015-05-30	new
203	104	40	2021-06-11	done
204	103	32	2020-07-09	in procgress
205	120	39	2017-06-12	new
309	162	59	2015-12-21	in procgress
310	152	55	2022-09-14	done
311	178	57	2021-06-11	in procgress
312	154	58	2015-06-13	done
313	180	53	2023-04-16	in procgress
314	162	53	2022-01-11	in procgress
315	169	60	2019-11-19	in procgress
316	151	51	2024-03-08	new
317	151	56	2022-07-10	done
318	159	60	2024-08-20	done
319	172	59	2019-12-01	in procgress
320	167	58	2024-10-20	new
321	167	51	2020-10-17	done
322	158	60	2016-08-27	new
323	164	59	2018-11-15	new
324	155	58	2018-03-14	new
325	156	54	2023-06-18	done
326	174	57	2015-07-08	in procgress
327	170	57	2019-11-06	new
328	177	57	2015-05-09	in procgress
329	168	60	2024-09-24	new
330	166	57	2023-12-16	in procgress
331	154	52	2023-11-17	done
332	165	58	2016-04-13	in procgress
333	169	59	2017-09-29	new
334	175	57	2018-06-24	new
335	176	58	2024-06-18	done
336	176	55	2017-08-04	in procgress
337	161	55	2017-12-24	new
338	175	55	2021-12-11	in procgress
339	158	57	2020-05-17	done
340	172	53	2016-03-14	done
341	172	58	2024-09-30	in procgress
342	169	57	2016-09-06	new
343	167	57	2021-10-02	in procgress
344	172	60	2015-11-05	in procgress
345	155	59	2023-05-19	new
346	173	52	2022-10-02	in procgress
347	165	56	2019-01-17	in procgress
348	169	52	2021-04-12	done
349	156	54	2020-08-30	in procgress
350	155	56	2018-03-02	in procgress
351	169	54	2021-05-02	in procgress
352	160	60	2017-09-02	new
353	156	55	2017-03-29	done
354	157	56	2022-09-08	in procgress
355	163	54	2018-07-02	in procgress
356	179	60	2018-10-10	new
357	171	55	2017-08-01	new
358	161	51	2021-07-19	done
359	178	58	2015-09-25	done
360	177	59	2024-02-02	done
361	173	58	2019-09-14	in procgress
362	160	57	2020-05-06	in procgress
363	159	58	2016-09-25	in procgress
364	174	51	2015-07-09	in procgress
365	179	59	2024-07-21	done
366	161	59	2018-10-29	done
367	177	52	2020-05-06	in procgress
368	176	55	2023-06-10	new
369	157	59	2020-06-21	done
370	151	59	2016-01-17	in procgress
371	157	55	2022-12-16	done
372	161	57	2023-08-03	in procgress
373	179	59	2021-04-20	new
374	173	56	2017-04-09	done
375	156	55	2024-06-19	done
376	166	54	2017-06-15	done
377	156	53	2015-01-16	in procgress
378	151	52	2021-11-01	done
379	173	53	2019-05-13	in procgress
380	175	59	2015-10-18	done
381	180	51	2022-04-08	new
382	156	56	2018-02-19	in procgress
383	156	55	2015-11-09	new
384	156	52	2015-10-24	new
385	157	53	2016-12-07	new
386	156	52	2016-01-18	new
387	168	56	2024-05-23	done
388	157	54	2021-02-15	in procgress
389	160	57	2015-02-15	done
390	165	52	2024-02-07	done
391	160	53	2015-11-29	new
392	159	56	2018-07-13	new
393	171	56	2020-01-25	new
394	176	57	2022-02-26	done
395	167	56	2015-01-13	new
396	174	52	2016-02-04	done
397	166	51	2019-02-22	in procgress
398	158	60	2020-08-23	done
399	177	51	2022-11-22	in procgress
400	153	60	2018-05-17	in procgress
401	177	59	2020-05-17	in procgress
402	178	52	2019-11-27	new
403	157	56	2016-01-18	new
404	155	58	2020-10-31	new
405	178	56	2022-10-02	in procgress
\.


--
-- TOC entry 5138 (class 0 OID 17406)
-- Dependencies: 236
-- Data for Name: order_item; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.order_item (id, order_id, edition_id, quantity) FROM stdin;
1	12	210	49
2	102	202	31
3	53	239	37
4	11	188	38
5	26	174	6
6	104	173	6
7	70	207	46
8	36	215	40
9	83	207	11
10	10	179	45
11	71	194	6
12	55	232	41
13	56	178	49
14	76	161	27
15	23	192	16
16	55	215	13
17	78	170	15
18	46	193	9
19	20	172	3
20	36	210	43
21	13	234	49
22	73	202	10
23	85	238	12
24	48	171	38
25	74	198	38
26	16	180	15
27	43	196	10
28	27	235	14
29	80	172	36
30	97	195	42
31	44	219	4
32	86	186	23
33	34	177	33
34	105	221	42
35	76	166	7
36	25	238	33
37	12	235	35
38	58	194	12
39	16	225	15
40	47	162	47
41	48	187	36
42	38	239	9
43	23	169	17
44	48	196	45
45	22	221	28
46	76	229	13
47	50	188	3
48	52	211	20
49	69	168	26
50	20	161	42
51	16	224	29
52	19	186	44
53	41	204	9
54	34	204	13
55	90	197	4
56	86	211	17
57	36	212	14
58	65	212	50
59	81	233	18
60	7	202	25
61	6	177	45
62	40	183	18
63	74	163	31
64	15	190	8
65	70	207	37
66	44	179	8
67	88	177	38
68	43	166	27
69	105	185	34
70	36	182	12
71	76	214	39
72	77	162	50
73	92	183	50
74	28	212	30
75	67	213	32
76	91	161	45
77	48	198	6
78	19	234	38
79	95	179	21
80	95	222	8
81	99	220	45
82	67	225	20
83	101	169	10
84	101	171	23
85	87	180	12
86	47	219	12
87	96	202	6
88	90	170	18
89	8	161	33
90	6	169	37
91	18	222	8
92	100	184	4
93	34	234	41
94	41	215	43
95	76	227	46
96	55	176	19
97	43	237	35
98	14	214	18
99	53	226	30
100	91	209	3
101	54	190	35
102	55	193	32
103	33	231	31
104	21	183	5
105	94	235	32
106	61	171	16
107	62	213	17
108	84	162	38
109	36	170	22
110	105	201	36
111	18	239	38
112	95	162	45
113	83	198	29
114	66	225	23
115	83	192	24
116	53	239	34
117	28	217	20
118	76	187	12
119	64	171	17
120	27	234	43
121	45	215	6
122	49	163	3
123	99	162	16
124	48	205	28
125	20	228	35
126	21	233	9
127	11	196	29
128	62	180	10
129	24	230	25
130	7	222	8
131	10	216	7
132	63	223	5
133	33	211	19
134	55	200	34
135	36	195	18
136	95	219	17
137	83	191	14
138	80	232	8
139	76	178	35
140	42	196	17
141	17	211	11
142	62	220	15
143	55	165	6
144	49	161	14
145	35	220	48
146	7	167	16
147	17	188	25
148	101	197	12
149	68	198	50
150	50	200	28
151	56	201	29
152	54	184	15
153	8	231	49
154	21	162	18
155	54	163	12
156	7	216	15
157	25	235	10
158	33	162	24
159	63	207	37
160	58	164	2
161	44	200	1
162	8	198	24
163	36	223	46
164	16	205	30
165	10	192	19
166	6	171	13
167	26	204	44
168	74	215	35
169	17	183	7
170	19	216	33
171	56	189	46
172	96	164	7
173	78	174	41
174	60	173	44
175	17	169	3
176	13	213	28
177	27	197	18
178	71	232	12
179	12	177	15
180	29	222	5
181	44	187	48
182	62	190	43
183	34	175	3
184	63	197	40
185	49	215	15
186	102	221	35
187	59	190	24
188	93	220	21
189	17	217	4
190	105	209	22
191	34	190	50
192	7	197	14
193	6	204	32
194	62	179	21
195	102	167	48
196	42	163	5
197	98	181	34
198	79	195	31
199	80	186	40
200	98	206	42
201	171	258	45
202	178	250	5
203	199	251	22
204	204	290	8
205	152	276	2
206	111	246	35
207	113	281	35
208	146	285	2
209	139	319	31
210	194	313	37
211	168	301	20
212	156	299	19
213	166	314	50
214	106	280	27
215	116	311	23
216	175	250	42
217	164	301	47
218	186	266	26
219	205	280	36
220	148	265	1
221	198	249	25
222	180	296	49
223	185	243	48
224	139	241	29
225	202	260	1
226	107	307	46
227	187	304	14
228	181	294	43
229	115	298	38
230	146	275	42
231	188	277	20
232	200	296	2
233	162	267	21
234	204	258	42
235	182	285	29
236	117	256	3
237	106	270	36
238	202	312	48
239	107	253	10
240	196	256	24
241	134	301	18
242	184	275	36
243	138	308	6
244	143	289	18
245	198	294	9
246	177	281	17
247	145	246	35
248	148	299	31
249	174	279	7
250	147	296	7
251	189	261	44
252	154	278	4
253	172	255	6
254	109	250	32
255	121	296	11
256	176	282	12
257	116	254	31
258	114	285	27
259	203	264	7
260	142	243	47
261	200	275	6
262	114	288	7
263	181	284	27
264	155	277	26
265	137	242	14
266	113	256	44
267	199	252	5
268	195	264	42
269	163	274	9
270	108	298	31
271	204	290	28
272	178	300	45
273	113	284	15
274	168	266	9
275	156	299	44
276	150	313	41
277	119	317	50
278	182	249	40
279	186	279	26
280	192	315	1
281	193	261	30
282	124	269	43
283	141	259	3
284	168	291	45
285	160	248	3
286	185	248	33
287	180	248	25
288	203	264	48
289	173	255	21
290	115	246	30
291	146	258	46
292	113	241	28
293	108	304	21
294	191	249	49
295	118	314	1
296	146	255	32
297	195	243	23
298	118	279	4
299	136	245	5
300	164	288	2
301	202	241	21
302	125	274	43
303	146	263	14
304	118	290	43
305	190	242	50
306	204	306	50
307	163	277	27
308	109	273	34
309	152	241	19
310	120	304	46
311	148	245	13
312	155	315	40
313	200	253	3
314	188	292	36
315	190	269	31
316	172	259	36
317	148	297	12
318	107	261	8
319	110	313	27
320	166	281	14
321	205	306	49
322	200	314	25
323	187	276	27
324	185	260	6
325	112	243	12
326	133	249	36
327	143	284	15
328	139	317	20
329	161	317	24
330	111	257	24
331	190	272	10
332	169	282	41
333	141	260	1
334	113	251	40
335	123	296	13
336	150	304	44
337	178	304	50
338	167	257	10
339	107	259	9
340	136	274	15
341	113	294	5
342	183	302	49
343	178	278	34
344	196	264	46
345	177	257	6
346	164	273	37
347	183	291	40
348	131	255	47
349	165	299	43
350	194	253	27
351	115	276	32
352	137	271	31
353	137	247	41
354	196	287	8
355	204	276	50
356	145	242	2
357	196	280	30
358	171	288	21
359	185	311	3
360	109	315	42
361	179	257	23
362	154	267	6
363	170	310	5
364	203	287	44
365	183	315	5
366	181	309	8
367	135	297	18
368	143	288	41
369	169	281	39
370	107	280	42
371	165	311	18
372	109	243	22
373	168	270	24
374	196	282	2
375	204	245	20
376	117	274	42
377	130	274	11
378	191	299	40
379	176	290	40
380	127	287	37
381	177	270	20
382	126	304	5
383	158	249	41
384	191	283	44
385	155	244	38
386	160	261	24
387	127	319	6
388	198	299	30
389	147	249	22
390	150	255	19
391	174	308	39
392	118	268	15
393	150	256	46
394	113	257	31
395	204	317	50
396	166	312	4
397	203	242	40
398	204	252	21
399	205	278	45
400	156	279	43
601	376	463	21
602	375	466	46
603	356	470	18
604	371	403	23
605	380	428	1
606	342	463	44
607	312	448	28
608	342	422	37
609	317	445	40
610	389	461	4
611	390	461	42
612	342	470	15
613	334	427	25
614	349	436	2
615	308	472	3
616	319	445	38
617	338	405	35
618	310	478	31
619	377	439	20
620	391	407	15
621	397	427	37
622	353	480	39
623	386	445	34
624	355	415	8
625	388	408	18
626	355	412	6
627	385	470	12
628	340	450	25
629	313	467	28
630	388	451	1
631	335	470	31
632	364	447	50
633	356	480	12
634	332	433	8
635	356	480	7
636	388	460	24
637	361	478	40
638	314	447	14
639	339	445	5
640	370	436	19
641	360	411	27
642	331	422	23
643	369	441	1
644	323	459	22
645	370	443	28
646	389	437	44
647	345	432	35
648	349	420	24
649	376	447	50
650	379	437	30
651	371	435	5
652	310	458	6
653	351	475	17
654	333	470	18
655	311	461	5
656	405	458	35
657	342	445	42
658	374	459	13
659	330	471	49
660	345	466	29
661	340	476	44
662	373	459	47
663	356	472	45
664	398	414	35
665	387	448	36
666	319	448	22
667	351	402	12
668	366	467	33
669	375	459	45
670	326	455	29
671	360	432	11
672	308	453	5
673	308	435	4
674	342	425	7
675	392	432	36
676	383	408	19
677	321	405	9
678	381	477	16
679	337	409	19
680	317	464	34
681	319	455	50
682	335	462	6
683	335	451	1
684	332	415	18
685	341	409	41
686	325	474	39
687	317	436	26
688	344	407	48
689	336	455	41
690	345	442	25
691	356	424	19
692	322	447	13
693	363	478	4
694	309	407	49
695	345	469	1
696	343	445	15
697	337	467	14
698	323	407	42
699	353	435	3
700	324	411	44
701	381	476	15
702	338	436	36
703	370	444	41
704	385	423	43
705	394	423	23
706	398	424	42
707	404	470	42
708	313	410	31
709	337	456	46
710	392	449	27
711	331	459	3
712	394	447	32
713	387	434	27
714	395	472	32
715	354	410	18
716	307	412	39
717	339	423	44
718	332	466	47
719	385	407	41
720	350	462	29
721	312	427	27
722	403	473	40
723	347	464	27
724	391	405	21
725	337	466	33
726	320	420	4
727	399	412	22
728	392	425	44
729	315	466	20
730	320	431	5
731	328	452	13
732	370	468	17
733	329	409	30
734	316	426	41
735	308	434	39
736	328	441	8
737	334	456	20
738	388	414	47
739	329	433	49
740	366	466	19
741	362	425	39
742	363	409	35
743	361	423	16
744	369	477	38
745	349	421	16
746	315	443	21
747	357	463	15
748	317	453	23
749	373	417	37
750	332	471	44
751	405	444	10
752	387	450	44
753	359	465	18
754	308	462	45
755	340	457	40
756	400	418	13
757	336	402	40
758	320	422	5
759	331	404	15
760	323	469	24
761	404	452	13
762	404	412	16
763	383	446	42
764	380	452	4
765	390	416	9
766	402	457	3
767	342	404	43
768	341	476	33
769	403	416	24
770	313	424	17
771	394	477	2
772	336	426	48
773	386	416	28
774	387	422	31
775	331	432	20
776	395	406	33
777	394	455	44
778	315	403	3
779	404	451	4
780	357	476	38
781	348	404	13
782	357	456	33
783	353	446	19
784	357	438	49
785	307	405	42
786	308	435	39
787	351	402	2
788	397	452	21
789	401	467	43
790	309	471	26
791	404	405	24
792	390	422	41
793	323	431	45
794	405	446	6
795	332	442	39
796	342	458	5
797	323	464	24
798	330	455	37
799	395	464	43
800	355	408	33
\.


--
-- TOC entry 5130 (class 0 OID 17335)
-- Dependencies: 228
-- Data for Name: print_run; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.print_run (id, edition_id, quantity, print_date) FROM stdin;
301	294	119	2023-10-14
302	276	7166	2020-08-08
303	296	7966	2018-10-06
304	242	7595	2016-06-29
305	295	7231	2019-09-25
306	295	1080	2021-12-01
307	292	9378	2015-11-13
308	291	1688	2016-12-22
309	311	2636	2021-11-01
310	268	2525	2019-11-21
311	254	2712	2018-09-27
312	268	196	2020-12-13
313	244	9359	2017-03-22
314	260	3866	2016-12-01
315	261	4891	2017-03-08
316	290	8717	2018-05-09
317	292	6516	2019-12-07
318	279	1973	2016-12-26
319	271	3435	2019-06-24
320	267	8660	2020-05-18
321	282	3143	2017-07-08
322	307	4535	2016-01-18
323	301	8469	2016-04-16
324	286	9214	2019-07-14
325	279	872	2019-09-17
326	289	6981	2024-12-30
327	287	2290	2021-02-19
328	316	234	2022-08-10
329	288	5946	2022-08-07
330	304	5021	2016-06-21
331	268	8514	2015-05-07
332	300	101	2023-06-11
333	256	7050	2019-09-29
334	289	1012	2022-01-02
335	274	7549	2024-09-06
336	260	7428	2016-10-05
337	288	6187	2018-08-02
338	264	2265	2018-05-05
339	265	7214	2017-03-31
340	264	8216	2017-05-14
341	298	3656	2019-10-28
342	244	9043	2022-12-20
343	274	9062	2018-07-20
344	320	2704	2024-10-04
345	264	1416	2015-06-30
346	253	785	2015-12-12
347	300	6428	2019-11-13
348	243	1884	2017-08-25
349	276	7212	2017-01-16
350	255	5077	2017-12-30
351	288	4600	2023-12-05
352	242	4865	2017-07-15
353	295	8027	2021-10-01
354	290	8970	2024-12-30
355	288	861	2016-06-27
356	316	5424	2015-07-05
357	258	7953	2022-09-09
358	269	2277	2020-03-02
359	302	6324	2017-08-04
360	253	1630	2023-03-24
361	281	1240	2022-04-07
362	312	5200	2015-03-21
363	282	2787	2022-08-29
364	260	3308	2020-02-19
365	253	5246	2023-10-02
366	310	8714	2023-02-09
367	300	7305	2022-08-08
368	317	1105	2023-06-06
369	253	4793	2019-06-05
370	276	1114	2023-02-16
371	248	3810	2017-12-15
372	277	1594	2019-05-20
373	287	2282	2021-06-23
374	259	8622	2018-05-10
375	260	3207	2019-01-27
376	301	7813	2019-11-05
377	268	2654	2019-12-22
378	315	729	2024-11-29
379	296	7061	2016-10-16
380	288	5046	2015-01-31
381	293	8830	2020-05-28
382	303	5963	2017-11-17
383	249	7235	2019-03-07
384	257	6198	2016-05-26
385	282	9415	2023-03-14
386	246	1018	2019-05-13
387	287	7203	2024-09-24
388	287	9050	2024-05-06
389	307	3363	2020-04-16
390	293	4510	2020-05-25
391	311	4315	2022-09-09
392	317	5332	2017-03-09
393	274	7731	2020-04-03
394	259	3265	2021-09-06
395	250	9506	2020-07-23
396	294	8135	2021-01-29
397	266	6744	2021-08-07
398	262	4042	2019-10-08
399	306	8578	2018-09-10
400	295	938	2019-11-14
201	211	6882	2021-06-22
202	196	7313	2019-07-24
203	216	4023	2016-02-02
204	216	702	2016-09-12
205	201	8803	2024-09-09
206	208	5789	2021-03-19
207	220	5160	2017-07-10
208	165	3925	2024-03-14
209	172	1387	2017-08-18
210	202	5191	2016-12-18
211	185	3819	2018-08-07
212	174	6591	2017-04-22
213	175	4017	2024-05-11
214	171	5291	2024-02-27
215	219	1765	2024-11-13
216	233	7326	2017-05-26
217	195	9763	2016-10-02
218	226	5571	2017-12-05
219	177	2057	2016-11-11
220	175	3752	2021-06-27
221	224	2974	2022-08-28
222	211	5466	2018-07-01
223	194	8541	2021-07-24
224	207	8101	2021-07-03
225	219	9572	2021-08-28
226	222	916	2017-11-09
227	197	8134	2024-08-02
228	240	4013	2016-05-22
229	229	2541	2022-07-21
230	207	3871	2023-08-06
231	225	5828	2019-12-02
232	211	9466	2021-06-14
233	163	2164	2020-05-28
234	216	2519	2015-05-05
235	180	1680	2017-01-14
236	209	5620	2021-04-03
237	232	2182	2023-07-13
238	220	905	2022-01-08
239	216	2335	2021-03-23
240	215	5074	2023-02-21
241	187	4281	2019-07-26
242	221	6028	2023-09-10
243	201	475	2020-02-23
244	175	3805	2024-02-28
245	187	5797	2023-01-24
246	173	8847	2020-01-01
247	229	8738	2016-09-12
248	236	9754	2023-04-03
249	189	1375	2016-05-22
250	191	8121	2019-02-27
251	171	6422	2023-09-17
252	221	6793	2015-08-12
253	232	7220	2016-11-11
254	236	4472	2023-07-15
255	214	2117	2023-12-30
256	173	4774	2021-07-04
257	173	5667	2018-02-17
258	219	5793	2015-02-23
259	176	9627	2017-01-02
260	240	710	2015-07-18
261	230	2942	2021-08-26
262	209	7190	2022-05-24
263	240	6047	2024-04-22
264	235	3183	2022-03-08
265	218	7871	2023-03-05
266	191	7993	2022-07-25
267	190	5953	2021-06-02
268	189	9105	2019-07-13
269	162	3193	2023-11-05
270	225	6509	2020-12-15
271	173	3775	2017-05-22
272	181	1701	2024-07-13
273	233	7474	2022-10-14
274	223	6497	2017-09-05
275	181	1153	2017-10-26
276	192	4892	2020-02-12
277	199	4145	2017-05-06
278	186	9778	2015-06-17
279	181	1072	2020-03-06
280	182	4916	2017-10-08
281	173	554	2018-05-08
282	200	9589	2019-07-06
283	192	7687	2024-08-16
284	190	2422	2017-07-24
285	221	5005	2018-09-18
286	239	4545	2018-09-18
287	207	4596	2016-11-06
288	231	605	2016-06-17
289	194	2659	2019-06-22
290	227	8269	2023-04-18
291	210	1748	2020-11-28
292	195	1091	2018-02-07
293	232	9185	2019-09-23
294	217	3493	2019-04-19
295	197	302	2023-09-29
296	234	4107	2015-10-08
297	167	8960	2017-05-29
298	191	3717	2018-03-04
299	206	6358	2020-08-26
300	215	6260	2015-08-31
501	418	6681	2022-06-10
502	437	577	2023-09-11
503	422	834	2019-01-05
504	438	9488	2021-09-06
505	469	2177	2017-07-02
506	470	2231	2017-08-28
507	477	7798	2015-08-06
508	421	7792	2024-05-02
509	454	1323	2023-11-01
510	424	9450	2020-03-30
511	449	5524	2021-10-14
512	474	9580	2016-12-14
513	477	1207	2015-06-12
514	433	1028	2019-06-25
515	468	279	2020-09-02
516	478	3483	2023-01-17
517	443	1817	2023-08-29
518	435	5522	2017-09-05
519	473	4445	2017-05-24
520	410	5114	2020-01-04
521	441	851	2022-06-06
522	411	3692	2017-06-20
523	459	3511	2021-05-03
524	461	4905	2021-12-13
525	467	7619	2016-01-14
526	435	3036	2023-05-15
527	462	6960	2024-02-10
528	460	7973	2021-03-19
529	402	938	2022-07-29
530	420	3437	2017-04-03
531	473	1674	2022-11-19
532	407	9510	2024-08-10
533	450	5253	2023-07-16
534	409	4648	2023-05-23
535	446	8108	2015-10-14
536	460	9776	2019-02-26
537	466	164	2021-09-13
538	419	8093	2015-10-09
539	449	4903	2015-06-02
540	449	9650	2018-05-26
541	470	2988	2022-06-01
542	475	4105	2020-11-05
543	459	2155	2016-11-21
544	472	3217	2015-12-02
545	451	6409	2023-07-12
546	428	1817	2015-10-23
547	465	711	2024-06-18
548	448	5830	2024-09-28
549	427	5242	2017-08-13
550	465	8521	2021-09-18
551	468	7591	2016-07-01
552	419	6131	2017-02-12
553	446	9385	2024-02-08
554	478	818	2024-09-15
555	421	7438	2018-05-12
556	407	8480	2024-05-13
557	433	7213	2022-08-13
558	424	2250	2018-05-20
559	451	301	2016-05-30
560	408	2100	2024-09-21
561	441	3585	2023-05-01
562	475	4126	2019-06-01
563	411	3441	2018-05-15
564	408	4650	2015-08-18
565	450	5861	2015-04-30
566	410	5817	2022-10-09
567	467	9714	2016-07-02
568	451	4105	2020-12-01
569	448	8328	2015-11-29
570	464	6582	2023-02-05
571	458	4379	2019-09-07
572	469	2988	2015-09-26
573	474	9163	2020-09-22
574	435	8690	2018-03-10
575	477	6111	2015-05-12
576	412	4313	2017-04-26
577	431	1454	2015-03-08
578	450	3350	2015-09-30
579	436	9371	2023-08-27
580	461	6892	2018-08-29
581	422	306	2019-04-11
582	478	6437	2016-03-26
583	446	4614	2016-01-21
584	420	8806	2019-12-18
585	417	9366	2022-05-29
586	413	3340	2016-08-23
587	474	2058	2024-12-04
588	439	6910	2024-05-10
589	456	7501	2017-06-24
590	468	8794	2017-01-17
591	478	280	2022-01-01
592	476	6402	2023-07-19
593	408	2221	2016-04-02
594	469	8594	2019-11-18
595	431	5182	2020-03-26
596	417	1846	2018-07-07
597	438	8417	2020-10-30
598	423	3346	2019-07-26
599	427	6881	2018-07-18
600	468	1995	2024-06-09
\.


--
-- TOC entry 5142 (class 0 OID 17455)
-- Dependencies: 240
-- Data for Name: tech_task; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.tech_task (id, edition_id, description) FROM stdin;
1	420	Корректура текста
2	479	Техническое редактирование
3	446	Подготовка оригинал-макета
4	422	Корректура текста
5	470	Дизайн обложки
6	407	Верстка книги
7	468	Проверка на плагиат
8	476	Техническое редактирование
9	476	Корректура текста
10	425	Техническое редактирование
11	428	Техническое редактирование
12	455	Верстка книги
13	403	Верстка книги
14	459	Верстка книги
15	432	Верстка книги
16	477	Корректура текста
17	413	Корректура текста
18	458	Техническое редактирование
19	448	Корректура текста
20	477	Подготовка оригинал-макета
21	453	Дизайн обложки
22	416	Техническое редактирование
23	457	Подготовка оригинал-макета
24	480	Корректура текста
25	444	Проверка на плагиат
26	460	Проверка на плагиат
27	476	Верстка книги
28	432	Дизайн обложки
29	409	Корректура текста
30	432	Верстка книги
31	458	Проверка на плагиат
32	464	Техническое редактирование
33	429	Техническое редактирование
34	431	Корректура текста
35	456	Верстка книги
36	434	Корректура текста
37	450	Проверка на плагиат
38	477	Техническое редактирование
39	480	Проверка на плагиат
40	478	Проверка на плагиат
41	434	Верстка книги
42	418	Проверка на плагиат
43	413	Дизайн обложки
44	413	Техническое редактирование
45	445	Корректура текста
46	429	Техническое редактирование
47	431	Корректура текста
48	463	Верстка книги
49	402	Подготовка оригинал-макета
50	431	Корректура текста
51	455	Проверка на плагиат
52	474	Корректура текста
53	463	Подготовка оригинал-макета
54	429	Подготовка оригинал-макета
55	414	Подготовка оригинал-макета
56	409	Техническое редактирование
57	414	Подготовка оригинал-макета
58	409	Техническое редактирование
59	479	Подготовка оригинал-макета
60	450	Подготовка оригинал-макета
61	410	Корректура текста
62	414	Дизайн обложки
63	447	Проверка на плагиат
64	473	Верстка книги
65	404	Проверка на плагиат
66	442	Техническое редактирование
67	453	Корректура текста
68	429	Дизайн обложки
69	469	Верстка книги
70	447	Проверка на плагиат
71	410	Верстка книги
72	446	Техническое редактирование
73	415	Проверка на плагиат
74	433	Подготовка оригинал-макета
75	464	Проверка на плагиат
76	407	Дизайн обложки
77	450	Техническое редактирование
78	409	Корректура текста
79	476	Дизайн обложки
80	431	Подготовка оригинал-макета
81	406	Дизайн обложки
82	466	Корректура текста
83	441	Техническое редактирование
84	473	Дизайн обложки
85	449	Техническое редактирование
86	445	Проверка на плагиат
87	424	Техническое редактирование
88	471	Проверка на плагиат
89	446	Проверка на плагиат
90	473	Дизайн обложки
\.


--
-- TOC entry 5146 (class 0 OID 17479)
-- Dependencies: 244
-- Data for Name: tech_task_editor; Type: TABLE DATA; Schema: publishing; Owner: postgres
--

COPY publishing.tech_task_editor (id, tech_task_id, editor_id, is_main) FROM stdin;
1	2	24	f
2	22	28	t
3	55	20	f
4	37	25	t
5	85	25	t
6	34	17	f
7	21	21	t
8	11	22	t
9	68	16	f
10	35	16	t
11	7	27	f
12	84	16	t
13	4	25	t
14	47	30	f
15	70	18	f
16	32	25	t
17	88	29	t
18	49	27	f
19	27	24	f
20	85	19	f
21	55	29	f
22	56	28	t
23	74	18	t
24	6	24	t
25	6	28	f
26	32	25	t
27	59	23	f
28	19	28	f
29	72	25	t
30	36	17	t
31	13	30	f
32	75	20	f
33	3	28	f
34	64	30	f
35	87	30	t
36	67	21	f
37	1	30	f
38	20	20	t
39	89	17	f
40	47	30	f
41	17	17	f
42	9	26	f
43	4	29	t
44	57	29	f
45	16	28	f
46	49	20	t
47	47	25	t
48	11	19	t
49	35	30	f
50	78	28	t
51	18	16	t
52	8	17	f
53	36	26	t
54	25	26	t
55	65	24	f
56	50	18	f
57	28	20	t
58	17	24	t
59	65	26	f
60	48	28	t
61	56	29	f
62	49	24	t
63	89	18	t
64	43	16	f
65	27	30	f
66	65	22	f
67	51	21	t
68	39	23	t
69	21	29	f
70	18	16	f
71	7	18	t
72	79	16	f
73	15	21	f
74	64	27	f
75	12	30	f
76	74	16	t
77	13	24	f
78	81	23	f
79	21	19	t
80	76	30	f
81	49	28	f
82	38	20	f
83	83	28	f
84	89	19	f
85	14	19	f
86	35	28	f
87	36	18	f
88	19	16	t
89	42	30	f
90	14	17	t
91	2	25	t
92	73	16	f
93	23	17	f
94	79	19	t
95	36	29	f
96	5	28	t
97	32	29	f
98	29	28	f
99	24	22	f
100	56	19	f
101	20	17	t
102	74	19	f
103	57	23	t
104	53	24	t
105	35	19	f
106	76	24	f
107	16	19	f
108	8	21	f
109	77	26	t
110	76	21	f
111	67	23	t
112	40	24	t
113	66	30	t
114	29	27	f
115	1	22	t
116	66	22	f
117	9	24	f
118	81	25	t
119	60	20	t
120	70	30	t
\.


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 219
-- Name: author_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.author_id_seq', 350, true);


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 223
-- Name: book_author_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.book_author_id_seq', 600, true);


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 221
-- Name: book_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.book_id_seq', 350, true);


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 239
-- Name: check_task_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.check_task_id_seq', 90, true);


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 237
-- Name: contract_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.contract_id_seq', 81, true);


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 229
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.customer_id_seq', 180, true);


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 225
-- Name: edition_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.edition_id_seq', 480, true);


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 241
-- Name: editor_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.editor_id_seq', 30, true);


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 231
-- Name: manager_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.manager_id_seq', 60, true);


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 233
-- Name: order_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.order_id_seq', 405, true);


--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 235
-- Name: order_item_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.order_item_id_seq', 800, true);


--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 227
-- Name: print_run_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.print_run_id_seq', 600, true);


--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 243
-- Name: tech_task_editor_id_seq; Type: SEQUENCE SET; Schema: publishing; Owner: postgres
--

SELECT pg_catalog.setval('publishing.tech_task_editor_id_seq', 120, true);


--
-- TOC entry 4938 (class 2606 OID 17278)
-- Name: author author_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.author
    ADD CONSTRAINT author_pkey PRIMARY KEY (id);


--
-- TOC entry 4942 (class 2606 OID 17312)
-- Name: book_author book_author_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book_author
    ADD CONSTRAINT book_author_pkey PRIMARY KEY (id);


--
-- TOC entry 4940 (class 2606 OID 17295)
-- Name: book book_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (id);


--
-- TOC entry 4960 (class 2606 OID 17462)
-- Name: tech_task check_task_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.tech_task
    ADD CONSTRAINT check_task_pkey PRIMARY KEY (id);


--
-- TOC entry 4958 (class 2606 OID 17438)
-- Name: contract contract_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (id);


--
-- TOC entry 4950 (class 2606 OID 17358)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- TOC entry 4944 (class 2606 OID 17326)
-- Name: edition edition_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.edition
    ADD CONSTRAINT edition_pkey PRIMARY KEY (id);


--
-- TOC entry 4962 (class 2606 OID 17477)
-- Name: editor editor_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.editor
    ADD CONSTRAINT editor_pkey PRIMARY KEY (id);


--
-- TOC entry 4946 (class 2606 OID 17328)
-- Name: edition isbn; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.edition
    ADD CONSTRAINT isbn UNIQUE (isbn);


--
-- TOC entry 4952 (class 2606 OID 17368)
-- Name: manager manager_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.manager
    ADD CONSTRAINT manager_pkey PRIMARY KEY (id);


--
-- TOC entry 4956 (class 2606 OID 17416)
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4954 (class 2606 OID 17381)
-- Name: order order_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- TOC entry 4934 (class 2606 OID 17382)
-- Name: order order_status_check; Type: CHECK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE publishing."order"
    ADD CONSTRAINT order_status_check CHECK (((status)::text = ANY ((ARRAY['new'::character varying, 'in procgress'::character varying, 'done'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4948 (class 2606 OID 17344)
-- Name: print_run print_run_pkey; Type: CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.print_run
    ADD CONSTRAINT print_run_pkey PRIMARY KEY (id);


--
-- TOC entry 4971 (class 2606 OID 17463)
-- Name: tech_task check_task_edition_id_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.tech_task
    ADD CONSTRAINT check_task_edition_id_fkey FOREIGN KEY (edition_id) REFERENCES publishing.edition(id);


--
-- TOC entry 4969 (class 2606 OID 17449)
-- Name: contract contract_customer_id_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.contract
    ADD CONSTRAINT contract_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES publishing.customer(id) NOT VALID;


--
-- TOC entry 4970 (class 2606 OID 17439)
-- Name: contract contract_order_id_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.contract
    ADD CONSTRAINT contract_order_id_fkey FOREIGN KEY (order_id) REFERENCES publishing."order"(id);


--
-- TOC entry 4963 (class 2606 OID 17329)
-- Name: edition fk_book_author_book; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.edition
    ADD CONSTRAINT fk_book_author_book FOREIGN KEY (book_id) REFERENCES publishing.book(id) NOT VALID;


--
-- TOC entry 4965 (class 2606 OID 17383)
-- Name: order order_customer_id_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES publishing.customer(id) NOT VALID;


--
-- TOC entry 4967 (class 2606 OID 17422)
-- Name: order_item order_item_edition_id_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.order_item
    ADD CONSTRAINT order_item_edition_id_fkey FOREIGN KEY (edition_id) REFERENCES publishing.edition(id);


--
-- TOC entry 4968 (class 2606 OID 17417)
-- Name: order_item order_item_order_id_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.order_item
    ADD CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id) REFERENCES publishing."order"(id);


--
-- TOC entry 4966 (class 2606 OID 17388)
-- Name: order order_manager_id_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing."order"
    ADD CONSTRAINT order_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES publishing.manager(id) NOT VALID;


--
-- TOC entry 4964 (class 2606 OID 17345)
-- Name: print_run print_run_edition_id_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.print_run
    ADD CONSTRAINT print_run_edition_id_fkey FOREIGN KEY (edition_id) REFERENCES publishing.edition(id) NOT VALID;


--
-- TOC entry 4972 (class 2606 OID 17493)
-- Name: tech_task_editor tech_task_editor_editor_id_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.tech_task_editor
    ADD CONSTRAINT tech_task_editor_editor_id_fkey FOREIGN KEY (editor_id) REFERENCES publishing.editor(id) NOT VALID;


--
-- TOC entry 4973 (class 2606 OID 17488)
-- Name: tech_task_editor tech_task_editor_tech_task_id_fkey; Type: FK CONSTRAINT; Schema: publishing; Owner: postgres
--

ALTER TABLE ONLY publishing.tech_task_editor
    ADD CONSTRAINT tech_task_editor_tech_task_id_fkey FOREIGN KEY (tech_task_id) REFERENCES publishing.tech_task(id) NOT VALID;


-- Completed on 2026-03-30 12:56:49

--
-- PostgreSQL database dump complete
--

\unrestrict z1LFfmc2RJ9onoWSbU2R4sZHsjWHBnGiIFzHwRuFFlIBtHzua7bKG6FeEQdw0co

