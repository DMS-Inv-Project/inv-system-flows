--
-- PostgreSQL database dump
--

\restrict WDp7nOd2zKoIdDe6byBcRgbximQVuCFhbZhg05fdpigXMswO3uGFawWcgFpuc0g

-- Dumped from database version 15.14
-- Dumped by pg_dump version 15.14

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

ALTER TABLE IF EXISTS ONLY public.locations DROP CONSTRAINT IF EXISTS locations_parent_id_fkey;
ALTER TABLE IF EXISTS ONLY public.drugs DROP CONSTRAINT IF EXISTS drugs_manufacturer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.drugs DROP CONSTRAINT IF EXISTS drugs_generic_id_fkey;
ALTER TABLE IF EXISTS ONLY public.drugs DROP CONSTRAINT IF EXISTS drugs_base_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.departments DROP CONSTRAINT IF EXISTS departments_parent_id_fkey;
ALTER TABLE IF EXISTS ONLY public.companies DROP CONSTRAINT IF EXISTS companies_bank_id_fkey;
ALTER TABLE IF EXISTS ONLY public.budgets DROP CONSTRAINT IF EXISTS budgets_budget_type_fkey;
ALTER TABLE IF EXISTS ONLY public.budgets DROP CONSTRAINT IF EXISTS budgets_budget_category_fkey;
ALTER TABLE IF EXISTS ONLY public.budget_allocations DROP CONSTRAINT IF EXISTS budget_allocations_department_id_fkey;
ALTER TABLE IF EXISTS ONLY public.budget_allocations DROP CONSTRAINT IF EXISTS budget_allocations_budget_id_fkey;
DROP INDEX IF EXISTS public.locations_location_code_key;
DROP INDEX IF EXISTS public.drugs_drug_code_key;
DROP INDEX IF EXISTS public.drug_generics_working_code_key;
DROP INDEX IF EXISTS public.departments_his_code_idx;
DROP INDEX IF EXISTS public.departments_dept_code_key;
DROP INDEX IF EXISTS public.companies_company_code_key;
DROP INDEX IF EXISTS public.budgets_budget_code_key;
DROP INDEX IF EXISTS public.budget_types_type_code_key;
DROP INDEX IF EXISTS public.budget_categories_category_code_key;
DROP INDEX IF EXISTS public.budget_allocations_fiscal_year_budget_id_department_id_key;
ALTER TABLE IF EXISTS ONLY public.locations DROP CONSTRAINT IF EXISTS locations_pkey;
ALTER TABLE IF EXISTS ONLY public.drugs DROP CONSTRAINT IF EXISTS drugs_pkey;
ALTER TABLE IF EXISTS ONLY public.drug_generics DROP CONSTRAINT IF EXISTS drug_generics_pkey;
ALTER TABLE IF EXISTS ONLY public.departments DROP CONSTRAINT IF EXISTS departments_pkey;
ALTER TABLE IF EXISTS ONLY public.companies DROP CONSTRAINT IF EXISTS companies_pkey;
ALTER TABLE IF EXISTS ONLY public.budgets DROP CONSTRAINT IF EXISTS budgets_pkey;
ALTER TABLE IF EXISTS ONLY public.budget_types DROP CONSTRAINT IF EXISTS budget_types_pkey;
ALTER TABLE IF EXISTS ONLY public.budget_categories DROP CONSTRAINT IF EXISTS budget_categories_pkey;
ALTER TABLE IF EXISTS ONLY public.budget_allocations DROP CONSTRAINT IF EXISTS budget_allocations_pkey;
ALTER TABLE IF EXISTS ONLY public.bank DROP CONSTRAINT IF EXISTS bank_pkey;
ALTER TABLE IF EXISTS public.locations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.drugs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.drug_generics ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.departments ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.companies ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.budgets ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.budget_types ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.budget_categories ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.budget_allocations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bank ALTER COLUMN bank_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.locations_id_seq;
DROP TABLE IF EXISTS public.locations;
DROP SEQUENCE IF EXISTS public.drugs_id_seq;
DROP TABLE IF EXISTS public.drugs;
DROP SEQUENCE IF EXISTS public.drug_generics_id_seq;
DROP TABLE IF EXISTS public.drug_generics;
DROP SEQUENCE IF EXISTS public.departments_id_seq;
DROP TABLE IF EXISTS public.departments;
DROP SEQUENCE IF EXISTS public.companies_id_seq;
DROP TABLE IF EXISTS public.companies;
DROP SEQUENCE IF EXISTS public.budgets_id_seq;
DROP TABLE IF EXISTS public.budgets;
DROP SEQUENCE IF EXISTS public.budget_types_id_seq;
DROP TABLE IF EXISTS public.budget_types;
DROP SEQUENCE IF EXISTS public.budget_categories_id_seq;
DROP TABLE IF EXISTS public.budget_categories;
DROP SEQUENCE IF EXISTS public.budget_allocations_id_seq;
DROP TABLE IF EXISTS public.budget_allocations;
DROP SEQUENCE IF EXISTS public.bank_bank_id_seq;
DROP TABLE IF EXISTS public.bank;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bank; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.bank (
    bank_id bigint NOT NULL,
    bank_name character varying(100) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.bank OWNER TO invs_user;

--
-- Name: bank_bank_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.bank_bank_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bank_bank_id_seq OWNER TO invs_user;

--
-- Name: bank_bank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.bank_bank_id_seq OWNED BY public.bank.bank_id;


--
-- Name: budget_allocations; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.budget_allocations (
    id bigint NOT NULL,
    fiscal_year integer NOT NULL,
    budget_id bigint NOT NULL,
    department_id bigint NOT NULL,
    total_budget numeric(15,2) NOT NULL,
    q1_budget numeric(15,2) NOT NULL,
    q2_budget numeric(15,2) NOT NULL,
    q3_budget numeric(15,2) NOT NULL,
    q4_budget numeric(15,2) NOT NULL,
    total_spent numeric(15,2) DEFAULT 0 NOT NULL,
    q1_spent numeric(15,2) DEFAULT 0 NOT NULL,
    q2_spent numeric(15,2) DEFAULT 0 NOT NULL,
    q3_spent numeric(15,2) DEFAULT 0 NOT NULL,
    q4_spent numeric(15,2) DEFAULT 0 NOT NULL,
    remaining_budget numeric(15,2) NOT NULL,
    status public."BudgetStatus" DEFAULT 'active'::public."BudgetStatus" NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.budget_allocations OWNER TO invs_user;

--
-- Name: budget_allocations_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.budget_allocations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.budget_allocations_id_seq OWNER TO invs_user;

--
-- Name: budget_allocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.budget_allocations_id_seq OWNED BY public.budget_allocations.id;


--
-- Name: budget_categories; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.budget_categories (
    id bigint NOT NULL,
    category_code character varying(10) NOT NULL,
    category_name character varying(100) NOT NULL,
    acc_code character varying(20),
    remark text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.budget_categories OWNER TO invs_user;

--
-- Name: budget_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.budget_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.budget_categories_id_seq OWNER TO invs_user;

--
-- Name: budget_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.budget_categories_id_seq OWNED BY public.budget_categories.id;


--
-- Name: budget_types; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.budget_types (
    id bigint NOT NULL,
    type_code character varying(10) NOT NULL,
    type_name character varying(100) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.budget_types OWNER TO invs_user;

--
-- Name: budget_types_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.budget_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.budget_types_id_seq OWNER TO invs_user;

--
-- Name: budget_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.budget_types_id_seq OWNED BY public.budget_types.id;


--
-- Name: budgets; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.budgets (
    id bigint NOT NULL,
    budget_code character varying(10) NOT NULL,
    budget_type character varying(10) NOT NULL,
    budget_category character varying(10) NOT NULL,
    budget_description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.budgets OWNER TO invs_user;

--
-- Name: budgets_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.budgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.budgets_id_seq OWNER TO invs_user;

--
-- Name: budgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.budgets_id_seq OWNED BY public.budgets.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.companies (
    id bigint NOT NULL,
    company_code character varying(10),
    company_name character varying(100) NOT NULL,
    company_type public."CompanyType" DEFAULT 'vendor'::public."CompanyType" NOT NULL,
    tax_id character varying(20),
    bank_code character varying(20),
    bank_account character varying(100),
    bank_id bigint,
    address text,
    phone character varying(20),
    email character varying(100),
    contact_person character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tmt_manufacturer_code character varying(20),
    fda_license_number character varying(20),
    gmp_certificate character varying(30)
);


ALTER TABLE public.companies OWNER TO invs_user;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.companies_id_seq OWNER TO invs_user;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.departments (
    id bigint NOT NULL,
    dept_code character varying(10) NOT NULL,
    dept_name character varying(100) NOT NULL,
    his_code character varying(20),
    parent_id bigint,
    head_person character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.departments OWNER TO invs_user;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departments_id_seq OWNER TO invs_user;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: drug_generics; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_generics (
    id bigint NOT NULL,
    working_code character varying(7) NOT NULL,
    drug_name character varying(60) NOT NULL,
    dosage_form character varying(20) NOT NULL,
    sale_unit character varying(5) NOT NULL,
    composition character varying(50),
    strength numeric(10,2),
    strength_unit character varying(20),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tmt_vtm_code character varying(10),
    tmt_vtm_id bigint,
    tmt_gp_code character varying(10),
    tmt_gp_id bigint,
    tmt_gpf_code character varying(10),
    tmt_gpf_id bigint,
    tmt_gpx_code character varying(10),
    tmt_gpx_id bigint,
    tmt_code character varying(10),
    standard_unit character varying(10),
    therapeutic_group character varying(50)
);


ALTER TABLE public.drug_generics OWNER TO invs_user;

--
-- Name: drug_generics_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drug_generics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_generics_id_seq OWNER TO invs_user;

--
-- Name: drug_generics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drug_generics_id_seq OWNED BY public.drug_generics.id;


--
-- Name: drugs; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drugs (
    id bigint NOT NULL,
    drug_code character varying(24) NOT NULL,
    trade_name character varying(100) NOT NULL,
    generic_id bigint,
    strength character varying(50),
    dosage_form character varying(30),
    manufacturer_id bigint,
    atc_code character varying(10),
    standard_code character varying(24),
    barcode character varying(20),
    pack_size integer DEFAULT 1 NOT NULL,
    unit_price numeric(10,2),
    unit character varying(10) DEFAULT 'TAB'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tmt_tp_code character varying(10),
    tmt_tp_id bigint,
    tmt_tpu_code character varying(10),
    tmt_tpu_id bigint,
    tmt_tpp_code character varying(10),
    tmt_tpp_id bigint,
    nc24_code character varying(24),
    registration_number character varying(20),
    gpo_code character varying(15),
    hpp_type public."HppType",
    spec_prep character varying(10),
    is_hpp boolean DEFAULT false NOT NULL,
    base_product_id bigint,
    formula_reference text
);


ALTER TABLE public.drugs OWNER TO invs_user;

--
-- Name: drugs_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drugs_id_seq OWNER TO invs_user;

--
-- Name: drugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drugs_id_seq OWNED BY public.drugs.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    location_code character varying(10) NOT NULL,
    location_name character varying(100) NOT NULL,
    location_type public."LocationType" DEFAULT 'warehouse'::public."LocationType" NOT NULL,
    parent_id bigint,
    address text,
    responsible_person character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.locations OWNER TO invs_user;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.locations_id_seq OWNER TO invs_user;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: bank bank_id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.bank ALTER COLUMN bank_id SET DEFAULT nextval('public.bank_bank_id_seq'::regclass);


--
-- Name: budget_allocations id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_allocations ALTER COLUMN id SET DEFAULT nextval('public.budget_allocations_id_seq'::regclass);


--
-- Name: budget_categories id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_categories ALTER COLUMN id SET DEFAULT nextval('public.budget_categories_id_seq'::regclass);


--
-- Name: budget_types id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_types ALTER COLUMN id SET DEFAULT nextval('public.budget_types_id_seq'::regclass);


--
-- Name: budgets id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budgets ALTER COLUMN id SET DEFAULT nextval('public.budgets_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: drug_generics id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_generics ALTER COLUMN id SET DEFAULT nextval('public.drug_generics_id_seq'::regclass);


--
-- Name: drugs id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drugs ALTER COLUMN id SET DEFAULT nextval('public.drugs_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.bank VALUES (4, 'ธนาคารกรุงเทพ', true, '2025-10-20 02:19:10.379');
INSERT INTO public.bank VALUES (5, 'ธนาคารกรุงศรีอยุธยา', true, '2025-10-20 02:19:10.379');
INSERT INTO public.bank VALUES (1, 'ธนาคารกรุงไทย', true, '2025-10-20 02:19:10.379');
INSERT INTO public.bank VALUES (3, 'ธนาคารไทยพาณิชย์', true, '2025-10-20 02:19:10.379');
INSERT INTO public.bank VALUES (2, 'ธนาคารกสิกรไทย', true, '2025-10-20 02:19:10.379');


--
-- Data for Name: budget_allocations; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.budget_allocations VALUES (1, 2025, 1, 2, 3000000.00, 750000.00, 750000.00, 750000.00, 750000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 3000000.00, 'active', '2025-10-20 02:19:10.438', '2025-10-20 02:19:10.438');
INSERT INTO public.budget_allocations VALUES (2, 2025, 2, 1, 10000000.00, 2500000.00, 2500000.00, 2500000.00, 2500000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 10000000.00, 'active', '2025-10-20 02:19:10.438', '2025-10-20 02:19:10.438');
INSERT INTO public.budget_allocations VALUES (3, 2025, 2, 5, 5000000.00, 1250000.00, 1250000.00, 1250000.00, 1250000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 5000000.00, 'active', '2025-10-20 02:19:10.438', '2025-10-20 02:19:10.438');


--
-- Data for Name: budget_categories; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.budget_categories VALUES (1, '0102', 'ยา', '1105010103.101', 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับยา', true, '2025-10-20 02:19:10.395');
INSERT INTO public.budget_categories VALUES (3, '0103', 'เครื่องมือแพทย์', '1105010103.103', 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับเครื่องมือทางการแพทย์', true, '2025-10-20 02:19:10.395');
INSERT INTO public.budget_categories VALUES (2, '0101', 'เวชภัณฑ์ไม่ใช่ยา', '1105010103.102', 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับเวชภัณฑ์ไม่ใช่ยา', true, '2025-10-20 02:19:10.394');


--
-- Data for Name: budget_types; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.budget_types VALUES (1, '01', 'งบเงินบำรุง', true, '2025-10-20 02:19:10.386');
INSERT INTO public.budget_types VALUES (2, '02', 'งบลงทุน', true, '2025-10-20 02:19:10.386');
INSERT INTO public.budget_types VALUES (3, '03', 'งบบุคลากร', true, '2025-10-20 02:19:10.386');


--
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.budgets VALUES (1, 'OP001', '01', '0101', 'งบประมาณสำหรับซื้อเวชภัณฑ์ไม่ใช่ยา', true, '2025-10-20 02:19:10.401');
INSERT INTO public.budgets VALUES (2, 'OP002', '01', '0102', 'งบประมาณสำหรับซื้อยา', true, '2025-10-20 02:19:10.401');


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.companies VALUES (1, '000004', 'Sino-Thai Engineering & Construction PCL.', 'vendor', '0107537000781', '1234567890', 'บริษัท ไซโน-ไทย เอ็นจิเนียริ่ง แอนด์ คอนสตรัคชั่น จำกัด (มหาชน)', 4, '1011 Shinawatra Tower III, Viphavadi-Rangsit Road, Bangkok 10900', '02-642-8951', 'info@sinothai.co.th', 'Project Manager', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409', NULL, NULL, NULL);
INSERT INTO public.companies VALUES (5, '000002', 'Zuellig Pharma (Thailand) Ltd.', 'vendor', '0105536041974', '4561234567', 'บริษัท ซูลลิกฟาร์มา (ประเทศไทย) จำกัด', 2, '3199 Rama IV Road, Khlong Toei, Bangkok 10110', '02-367-8100', 'thailand@zuelligpharma.com', 'Account Manager', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409', NULL, NULL, NULL);
INSERT INTO public.companies VALUES (4, '000003', 'Pfizer (Thailand) Ltd.', 'manufacturer', '0105536028371', '7891234567', 'บริษัท ไฟเซอร์ (ประเทศไทย) จำกัด', 3, '1 Empire Tower, 47th Floor, Sathorn Road, Bangkok 10120', '02-670-1000', 'info.thailand@pfizer.com', 'Medical Affairs', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409', NULL, NULL, NULL);
INSERT INTO public.companies VALUES (2, '000005', 'Berlin Pharmaceutical Industry Co., Ltd.', 'manufacturer', '0105536001234', '9876543210', 'บริษัท เบอร์ลินฟาร์มาซูติคอลอินดัสตรี จำกัด', 5, '123 Industrial Estate, Samut Prakan 10280', '02-324-5678', 'sales@berlin-pharma.co.th', 'Sales Director', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409', NULL, NULL, NULL);
INSERT INTO public.companies VALUES (3, '000001', 'Government Pharmaceutical Organization (GPO)', 'both', '0994000158378', '3722699075', 'บริษัท ร่ำรวยเงินทอง จำกัด', 1, '75/1 Rama VI Road, Ratchathewi, Bangkok 10400', '02-203-8000', 'info@gpo.or.th', 'Sales Manager', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409', NULL, NULL, NULL);


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.departments VALUES (1, 'PHARM', 'Pharmacy Department', 'HIS-PHARM', NULL, 'Chief Pharmacist', true, '2025-10-20 02:19:10.371');
INSERT INTO public.departments VALUES (4, 'LAB', 'Laboratory', 'HIS-LAB', NULL, 'Laboratory Director', true, '2025-10-20 02:19:10.371');
INSERT INTO public.departments VALUES (5, 'NURSE', 'Nursing Department', 'HIS-NURSE', NULL, 'Chief Nursing Officer', true, '2025-10-20 02:19:10.371');
INSERT INTO public.departments VALUES (3, 'ADMIN', 'Administration', 'HIS-ADM', NULL, 'Hospital Director', true, '2025-10-20 02:19:10.371');
INSERT INTO public.departments VALUES (2, 'MED', 'Medical Department', 'HIS-MED', NULL, 'Chief Medical Officer', true, '2025-10-20 02:19:10.371');


--
-- Data for Name: drug_generics; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.drug_generics VALUES (1, 'AMX0001', 'Amoxicillin', 'Capsule', 'CAP', 'Amoxicillin trihydrate', 250.00, 'mg', true, '2025-10-20 02:19:10.42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.drug_generics VALUES (3, 'ASP0001', 'Aspirin', 'Tablet', 'TAB', 'Acetylsalicylic acid', 100.00, 'mg', true, '2025-10-20 02:19:10.42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.drug_generics VALUES (4, 'IBU0001', 'Ibuprofen', 'Tablet', 'TAB', 'Ibuprofen', 200.00, 'mg', true, '2025-10-20 02:19:10.42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.drug_generics VALUES (5, 'OME0001', 'Omeprazole', 'Capsule', 'CAP', 'Omeprazole', 20.00, 'mg', true, '2025-10-20 02:19:10.42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.drug_generics VALUES (2, 'PAR0001', 'Paracetamol', 'Tablet', 'TAB', 'Paracetamol', 500.00, 'mg', true, '2025-10-20 02:19:10.42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: drugs; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.drugs VALUES (1, 'PAR0001-000001-001', 'GPO Paracetamol 500mg', 2, '500mg', 'Tablet', 3, 'N02BE01', 'PAR0001-000001-001', '8851234567890', 1000, 1.50, 'TAB', true, '2025-10-20 02:19:10.429', '2025-10-20 02:19:10.429', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL);
INSERT INTO public.drugs VALUES (2, 'AMX0001-000002-001', 'Zuellig Amoxicillin 250mg', 1, '250mg', 'Capsule', 5, 'J01CA04', 'AMX0001-000002-001', '8851234567892', 1000, 3.00, 'CAP', true, '2025-10-20 02:19:10.429', '2025-10-20 02:19:10.429', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL);
INSERT INTO public.drugs VALUES (3, 'IBU0001-000001-001', 'GPO Ibuprofen 200mg', 4, '200mg', 'Tablet', 3, 'M01AE01', 'IBU0001-000001-001', '8851234567891', 500, 2.50, 'TAB', true, '2025-10-20 02:19:10.429', '2025-10-20 02:19:10.429', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL);


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.locations VALUES (1, 'EMRG', 'Emergency Department', 'emergency', NULL, 'Emergency Wing', 'Emergency Head Nurse', true, '2025-10-20 02:19:10.339');
INSERT INTO public.locations VALUES (2, 'MAIN', 'Main Warehouse', 'warehouse', NULL, 'Hospital Main Building', 'Warehouse Manager', true, '2025-10-20 02:19:10.339');
INSERT INTO public.locations VALUES (3, 'PHARM', 'Central Pharmacy', 'pharmacy', NULL, 'Ground Floor, Building A', 'Chief Pharmacist', true, '2025-10-20 02:19:10.339');
INSERT INTO public.locations VALUES (4, 'OPD', 'Outpatient Department', 'pharmacy', NULL, '1st Floor, Building A', 'OPD Pharmacist', true, '2025-10-20 02:19:10.339');
INSERT INTO public.locations VALUES (5, 'ICU', 'Intensive Care Unit', 'ward', NULL, '3rd Floor, Building B', 'ICU Head Nurse', true, '2025-10-20 02:19:10.339');


--
-- Name: bank_bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.bank_bank_id_seq', 1, false);


--
-- Name: budget_allocations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.budget_allocations_id_seq', 3, true);


--
-- Name: budget_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.budget_categories_id_seq', 3, true);


--
-- Name: budget_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.budget_types_id_seq', 3, true);


--
-- Name: budgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.budgets_id_seq', 2, true);


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.companies_id_seq', 5, true);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.departments_id_seq', 5, true);


--
-- Name: drug_generics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.drug_generics_id_seq', 5, true);


--
-- Name: drugs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.drugs_id_seq', 3, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.locations_id_seq', 5, true);


--
-- Name: bank bank_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (bank_id);


--
-- Name: budget_allocations budget_allocations_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_allocations
    ADD CONSTRAINT budget_allocations_pkey PRIMARY KEY (id);


--
-- Name: budget_categories budget_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_categories
    ADD CONSTRAINT budget_categories_pkey PRIMARY KEY (id);


--
-- Name: budget_types budget_types_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_types
    ADD CONSTRAINT budget_types_pkey PRIMARY KEY (id);


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: drug_generics drug_generics_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_generics
    ADD CONSTRAINT drug_generics_pkey PRIMARY KEY (id);


--
-- Name: drugs drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: budget_allocations_fiscal_year_budget_id_department_id_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX budget_allocations_fiscal_year_budget_id_department_id_key ON public.budget_allocations USING btree (fiscal_year, budget_id, department_id);


--
-- Name: budget_categories_category_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX budget_categories_category_code_key ON public.budget_categories USING btree (category_code);


--
-- Name: budget_types_type_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX budget_types_type_code_key ON public.budget_types USING btree (type_code);


--
-- Name: budgets_budget_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX budgets_budget_code_key ON public.budgets USING btree (budget_code);


--
-- Name: companies_company_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX companies_company_code_key ON public.companies USING btree (company_code);


--
-- Name: departments_dept_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX departments_dept_code_key ON public.departments USING btree (dept_code);


--
-- Name: departments_his_code_idx; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE INDEX departments_his_code_idx ON public.departments USING btree (his_code);


--
-- Name: drug_generics_working_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX drug_generics_working_code_key ON public.drug_generics USING btree (working_code);


--
-- Name: drugs_drug_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX drugs_drug_code_key ON public.drugs USING btree (drug_code);


--
-- Name: locations_location_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX locations_location_code_key ON public.locations USING btree (location_code);


--
-- Name: budget_allocations budget_allocations_budget_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_allocations
    ADD CONSTRAINT budget_allocations_budget_id_fkey FOREIGN KEY (budget_id) REFERENCES public.budgets(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: budget_allocations budget_allocations_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_allocations
    ADD CONSTRAINT budget_allocations_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: budgets budgets_budget_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_budget_category_fkey FOREIGN KEY (budget_category) REFERENCES public.budget_categories(category_code) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: budgets budgets_budget_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_budget_type_fkey FOREIGN KEY (budget_type) REFERENCES public.budget_types(type_code) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: companies companies_bank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_bank_id_fkey FOREIGN KEY (bank_id) REFERENCES public.bank(bank_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: departments departments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drugs drugs_base_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_base_product_id_fkey FOREIGN KEY (base_product_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drugs drugs_generic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_generic_id_fkey FOREIGN KEY (generic_id) REFERENCES public.drug_generics(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drugs drugs_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: locations locations_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.locations(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict WDp7nOd2zKoIdDe6byBcRgbximQVuCFhbZhg05fdpigXMswO3uGFawWcgFpuc0g

