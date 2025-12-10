--
-- PostgreSQL database dump
--

\restrict twYv23GCzbWyqs3mrsT8V69nshfnEgMgar8lKyvngQGA0qtB5X0EsJopBiPTALq

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: invs_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO invs_user;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: invs_user
--

COMMENT ON SCHEMA public IS '';


--
-- Name: ApprovalStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."ApprovalStatus" AS ENUM (
    'pending',
    'approved',
    'rejected',
    'cancelled'
);


ALTER TYPE public."ApprovalStatus" OWNER TO invs_user;

--
-- Name: ApprovalType; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."ApprovalType" AS ENUM (
    'normal',
    'urgent',
    'special'
);


ALTER TYPE public."ApprovalType" OWNER TO invs_user;

--
-- Name: AttachmentType; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."AttachmentType" AS ENUM (
    'purchase_order',
    'receipt',
    'invoice',
    'inspection_report',
    'delivery_note',
    'other'
);


ALTER TYPE public."AttachmentType" OWNER TO invs_user;

--
-- Name: BudgetPlanStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."BudgetPlanStatus" AS ENUM (
    'draft',
    'submitted',
    'approved',
    'rejected',
    'active',
    'closed'
);


ALTER TYPE public."BudgetPlanStatus" OWNER TO invs_user;

--
-- Name: BudgetStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."BudgetStatus" AS ENUM (
    'active',
    'inactive',
    'locked'
);


ALTER TYPE public."BudgetStatus" OWNER TO invs_user;

--
-- Name: CompanyType; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."CompanyType" AS ENUM (
    'vendor',
    'manufacturer',
    'both'
);


ALTER TYPE public."CompanyType" OWNER TO invs_user;

--
-- Name: ContractStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."ContractStatus" AS ENUM (
    'draft',
    'active',
    'expired',
    'cancelled'
);


ALTER TYPE public."ContractStatus" OWNER TO invs_user;

--
-- Name: ContractType; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."ContractType" AS ENUM (
    'e_bidding',
    'price_agreement',
    'quotation',
    'special'
);


ALTER TYPE public."ContractType" OWNER TO invs_user;

--
-- Name: DeptConsumptionGroup; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."DeptConsumptionGroup" AS ENUM (
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '9'
);


ALTER TYPE public."DeptConsumptionGroup" OWNER TO invs_user;

--
-- Name: DistributionStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."DistributionStatus" AS ENUM (
    'pending',
    'approved',
    'dispensed',
    'cancelled',
    'completed'
);


ALTER TYPE public."DistributionStatus" OWNER TO invs_user;

--
-- Name: DrugStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."DrugStatus" AS ENUM (
    '1',
    '2',
    '3',
    '4'
);


ALTER TYPE public."DrugStatus" OWNER TO invs_user;

--
-- Name: EdCategory; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."EdCategory" AS ENUM (
    'ED',
    'NED',
    'NDMS',
    'CM',
    'LS',
    'PS'
);


ALTER TYPE public."EdCategory" OWNER TO invs_user;

--
-- Name: HisMappingStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."HisMappingStatus" AS ENUM (
    'pending',
    'mapped',
    'verified',
    'rejected'
);


ALTER TYPE public."HisMappingStatus" OWNER TO invs_user;

--
-- Name: HppType; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."HppType" AS ENUM (
    'R',
    'M',
    'F',
    'X',
    'OHPP'
);


ALTER TYPE public."HppType" OWNER TO invs_user;

--
-- Name: InspectorRole; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."InspectorRole" AS ENUM (
    'chairman',
    'member',
    'secretary'
);


ALTER TYPE public."InspectorRole" OWNER TO invs_user;

--
-- Name: ItemStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."ItemStatus" AS ENUM (
    'pending',
    'approved',
    'rejected'
);


ALTER TYPE public."ItemStatus" OWNER TO invs_user;

--
-- Name: LocationType; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."LocationType" AS ENUM (
    'warehouse',
    'pharmacy',
    'ward',
    'emergency',
    'laboratory',
    'operating_room'
);


ALTER TYPE public."LocationType" OWNER TO invs_user;

--
-- Name: NlemStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."NlemStatus" AS ENUM (
    'E',
    'N'
);


ALTER TYPE public."NlemStatus" OWNER TO invs_user;

--
-- Name: PaymentStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."PaymentStatus" AS ENUM (
    'pending',
    'submitted',
    'approved',
    'paid',
    'cancelled'
);


ALTER TYPE public."PaymentStatus" OWNER TO invs_user;

--
-- Name: PoStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."PoStatus" AS ENUM (
    'draft',
    'pending',
    'approved',
    'sent',
    'received',
    'closed'
);


ALTER TYPE public."PoStatus" OWNER TO invs_user;

--
-- Name: ProductCategory; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."ProductCategory" AS ENUM (
    '1',
    '2',
    '3',
    '4',
    '5'
);


ALTER TYPE public."ProductCategory" OWNER TO invs_user;

--
-- Name: PurchaseItemType; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."PurchaseItemType" AS ENUM (
    'normal',
    'urgent',
    'replacement',
    'emergency'
);


ALTER TYPE public."PurchaseItemType" OWNER TO invs_user;

--
-- Name: ReceiptStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."ReceiptStatus" AS ENUM (
    'draft',
    'received',
    'verified',
    'posted',
    'pending_verification'
);


ALTER TYPE public."ReceiptStatus" OWNER TO invs_user;

--
-- Name: RequestStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."RequestStatus" AS ENUM (
    'draft',
    'submitted',
    'approved',
    'rejected',
    'converted'
);


ALTER TYPE public."RequestStatus" OWNER TO invs_user;

--
-- Name: ReservationStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."ReservationStatus" AS ENUM (
    'active',
    'released',
    'committed'
);


ALTER TYPE public."ReservationStatus" OWNER TO invs_user;

--
-- Name: ReturnStatus; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."ReturnStatus" AS ENUM (
    'draft',
    'submitted',
    'verified',
    'posted',
    'cancelled'
);


ALTER TYPE public."ReturnStatus" OWNER TO invs_user;

--
-- Name: ReturnType; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."ReturnType" AS ENUM (
    'purchased',
    'free'
);


ALTER TYPE public."ReturnType" OWNER TO invs_user;

--
-- Name: TmtLevel; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."TmtLevel" AS ENUM (
    'SUBS',
    'VTM',
    'GP',
    'TP',
    'GPU',
    'TPU',
    'GPP',
    'TPP',
    'GP-F',
    'GP-X'
);


ALTER TYPE public."TmtLevel" OWNER TO invs_user;

--
-- Name: TmtRelationType; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."TmtRelationType" AS ENUM (
    'IS_A',
    'HAS_ACTIVE_INGREDIENT',
    'HAS_DOSE_FORM',
    'HAS_MANUFACTURER',
    'HAS_PACK_SIZE',
    'HAS_STRENGTH',
    'HAS_UNIT_OF_USE',
    'HAS_ROUTE_OF_ADMINISTRATION'
);


ALTER TYPE public."TmtRelationType" OWNER TO invs_user;

--
-- Name: TransactionType; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."TransactionType" AS ENUM (
    'receive',
    'issue',
    'transfer',
    'adjust',
    'return'
);


ALTER TYPE public."TransactionType" OWNER TO invs_user;

--
-- Name: Urgency; Type: TYPE; Schema: public; Owner: invs_user
--

CREATE TYPE public."Urgency" AS ENUM (
    'urgent',
    'normal',
    'low'
);


ALTER TYPE public."Urgency" OWNER TO invs_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO invs_user;

--
-- Name: adjustment_reasons; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.adjustment_reasons (
    id bigint NOT NULL,
    code integer NOT NULL,
    reason character varying(100) NOT NULL,
    category character varying(30),
    is_hidden boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.adjustment_reasons OWNER TO invs_user;

--
-- Name: adjustment_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.adjustment_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adjustment_reasons_id_seq OWNER TO invs_user;

--
-- Name: adjustment_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.adjustment_reasons_id_seq OWNED BY public.adjustment_reasons.id;


--
-- Name: approval_documents; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.approval_documents (
    id bigint NOT NULL,
    approval_doc_number character varying(20) NOT NULL,
    po_id bigint NOT NULL,
    approval_type public."ApprovalType" DEFAULT 'normal'::public."ApprovalType" NOT NULL,
    requested_by character varying(50) NOT NULL,
    requested_date date NOT NULL,
    approved_by character varying(50),
    approval_date date,
    rejected_by character varying(50),
    rejected_date date,
    rejection_reason text,
    status public."ApprovalStatus" DEFAULT 'pending'::public."ApprovalStatus" NOT NULL,
    document_path character varying(255),
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.approval_documents OWNER TO invs_user;

--
-- Name: approval_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.approval_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.approval_documents_id_seq OWNER TO invs_user;

--
-- Name: approval_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.approval_documents_id_seq OWNED BY public.approval_documents.id;


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
-- Name: budget_plan_items; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.budget_plan_items (
    id bigint NOT NULL,
    budget_plan_id bigint NOT NULL,
    item_number integer NOT NULL,
    generic_id bigint NOT NULL,
    planned_quantity numeric(10,2) NOT NULL,
    estimated_unit_cost numeric(10,2) NOT NULL,
    planned_total_cost numeric(15,2) NOT NULL,
    q1_quantity numeric(10,2) DEFAULT 0 NOT NULL,
    q2_quantity numeric(10,2) DEFAULT 0 NOT NULL,
    q3_quantity numeric(10,2) DEFAULT 0 NOT NULL,
    q4_quantity numeric(10,2) DEFAULT 0 NOT NULL,
    q1_budget numeric(15,2) DEFAULT 0 NOT NULL,
    q2_budget numeric(15,2) DEFAULT 0 NOT NULL,
    q3_budget numeric(15,2) DEFAULT 0 NOT NULL,
    q4_budget numeric(15,2) DEFAULT 0 NOT NULL,
    purchased_quantity numeric(10,2) DEFAULT 0 NOT NULL,
    purchased_value numeric(15,2) DEFAULT 0 NOT NULL,
    q1_purchased_qty numeric(10,2) DEFAULT 0 NOT NULL,
    q2_purchased_qty numeric(10,2) DEFAULT 0 NOT NULL,
    q3_purchased_qty numeric(10,2) DEFAULT 0 NOT NULL,
    q4_purchased_qty numeric(10,2) DEFAULT 0 NOT NULL,
    remaining_quantity numeric(10,2) NOT NULL,
    remaining_value numeric(15,2) NOT NULL,
    avg_consumption_3_years numeric(10,2),
    year1_consumption numeric(10,2),
    year2_consumption numeric(10,2),
    year3_consumption numeric(10,2),
    forecast_method character varying(50),
    min_stock_level numeric(10,2),
    current_stock numeric(10,2),
    justification text,
    status public."ItemStatus" DEFAULT 'pending'::public."ItemStatus" NOT NULL,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.budget_plan_items OWNER TO invs_user;

--
-- Name: budget_plan_items_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.budget_plan_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.budget_plan_items_id_seq OWNER TO invs_user;

--
-- Name: budget_plan_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.budget_plan_items_id_seq OWNED BY public.budget_plan_items.id;


--
-- Name: budget_plans; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.budget_plans (
    id bigint NOT NULL,
    fiscal_year integer NOT NULL,
    department_id bigint NOT NULL,
    budget_allocation_id bigint NOT NULL,
    total_planned_budget numeric(15,2) NOT NULL,
    total_planned_quantity numeric(12,2) DEFAULT 0 NOT NULL,
    q1_planned_budget numeric(15,2) NOT NULL,
    q2_planned_budget numeric(15,2) NOT NULL,
    q3_planned_budget numeric(15,2) NOT NULL,
    q4_planned_budget numeric(15,2) NOT NULL,
    total_purchased numeric(15,2) DEFAULT 0 NOT NULL,
    q1_purchased numeric(15,2) DEFAULT 0 NOT NULL,
    q2_purchased numeric(15,2) DEFAULT 0 NOT NULL,
    q3_purchased numeric(15,2) DEFAULT 0 NOT NULL,
    q4_purchased numeric(15,2) DEFAULT 0 NOT NULL,
    remaining_budget numeric(15,2) NOT NULL,
    status public."BudgetPlanStatus" DEFAULT 'draft'::public."BudgetPlanStatus" NOT NULL,
    approved_by character varying(50),
    approval_date date,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.budget_plans OWNER TO invs_user;

--
-- Name: budget_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.budget_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.budget_plans_id_seq OWNER TO invs_user;

--
-- Name: budget_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.budget_plans_id_seq OWNED BY public.budget_plans.id;


--
-- Name: budget_reservations; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.budget_reservations (
    id bigint NOT NULL,
    allocation_id bigint NOT NULL,
    pr_id bigint,
    po_id bigint,
    reserved_amount numeric(15,2) NOT NULL,
    reservation_date date NOT NULL,
    status public."ReservationStatus" DEFAULT 'active'::public."ReservationStatus" NOT NULL,
    expires_date date,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.budget_reservations OWNER TO invs_user;

--
-- Name: budget_reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.budget_reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.budget_reservations_id_seq OWNER TO invs_user;

--
-- Name: budget_reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.budget_reservations_id_seq OWNED BY public.budget_reservations.id;


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
-- Name: contract_items; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.contract_items (
    id bigint NOT NULL,
    contract_id bigint NOT NULL,
    drug_id bigint NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    quantity_contracted numeric(10,2) NOT NULL,
    quantity_remaining numeric(10,2) NOT NULL,
    min_order_quantity numeric(10,2),
    max_order_quantity numeric(10,2),
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.contract_items OWNER TO invs_user;

--
-- Name: contract_items_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.contract_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contract_items_id_seq OWNER TO invs_user;

--
-- Name: contract_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.contract_items_id_seq OWNED BY public.contract_items.id;


--
-- Name: contracts; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.contracts (
    id bigint NOT NULL,
    contract_number character varying(20) NOT NULL,
    contract_type public."ContractType" NOT NULL,
    vendor_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    total_value numeric(15,2) NOT NULL,
    remaining_value numeric(15,2) NOT NULL,
    fiscal_year character varying(4) NOT NULL,
    status public."ContractStatus" DEFAULT 'active'::public."ContractStatus" NOT NULL,
    contract_document character varying(255),
    approved_by character varying(50),
    approval_date date,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    committee_date date,
    committee_name character varying(60),
    committee_number character varying(20),
    egp_number character varying(30),
    gf_number character varying(10),
    project_number character varying(30)
);


ALTER TABLE public.contracts OWNER TO invs_user;

--
-- Name: contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.contracts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contracts_id_seq OWNER TO invs_user;

--
-- Name: contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.contracts_id_seq OWNED BY public.contracts.id;


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
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    consumption_group public."DeptConsumptionGroup"
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
-- Name: distribution_types; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.distribution_types (
    id bigint NOT NULL,
    code integer NOT NULL,
    name character varying(60) NOT NULL,
    is_hidden boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.distribution_types OWNER TO invs_user;

--
-- Name: distribution_types_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.distribution_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.distribution_types_id_seq OWNER TO invs_user;

--
-- Name: distribution_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.distribution_types_id_seq OWNED BY public.distribution_types.id;


--
-- Name: dosage_forms; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.dosage_forms (
    id bigint NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(60) NOT NULL,
    name_en character varying(60),
    is_hidden boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.dosage_forms OWNER TO invs_user;

--
-- Name: dosage_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.dosage_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dosage_forms_id_seq OWNER TO invs_user;

--
-- Name: dosage_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.dosage_forms_id_seq OWNED BY public.dosage_forms.id;


--
-- Name: drug_components; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_components (
    id bigint NOT NULL,
    generic_id bigint NOT NULL,
    component_name character varying(100) NOT NULL,
    strength character varying(50),
    strength_unit character varying(20),
    tmt_concept_id bigint,
    sequence integer,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.drug_components OWNER TO invs_user;

--
-- Name: drug_components_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drug_components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_components_id_seq OWNER TO invs_user;

--
-- Name: drug_components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drug_components_id_seq OWNED BY public.drug_components.id;


--
-- Name: drug_distribution_items; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_distribution_items (
    id bigint NOT NULL,
    distribution_id bigint NOT NULL,
    item_number integer NOT NULL,
    drug_id bigint NOT NULL,
    lot_number character varying(20) NOT NULL,
    quantity_dispensed numeric(10,2) NOT NULL,
    unit_cost numeric(10,2) NOT NULL,
    total_cost numeric(12,2) NOT NULL,
    expiry_date date NOT NULL,
    batch_number character varying(20),
    purpose_detail character varying(200),
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.drug_distribution_items OWNER TO invs_user;

--
-- Name: drug_distribution_items_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drug_distribution_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_distribution_items_id_seq OWNER TO invs_user;

--
-- Name: drug_distribution_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drug_distribution_items_id_seq OWNED BY public.drug_distribution_items.id;


--
-- Name: drug_distributions; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_distributions (
    id bigint NOT NULL,
    distribution_number character varying(20) NOT NULL,
    distribution_date date NOT NULL,
    from_location_id bigint NOT NULL,
    to_location_id bigint,
    requesting_dept_id bigint,
    purpose text,
    requested_by character varying(50) NOT NULL,
    approved_by character varying(50),
    dispensed_by character varying(50),
    approval_date date,
    dispensed_date date,
    status public."DistributionStatus" DEFAULT 'pending'::public."DistributionStatus" NOT NULL,
    total_items integer DEFAULT 0 NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    distribution_type_id bigint
);


ALTER TABLE public.drug_distributions OWNER TO invs_user;

--
-- Name: drug_distributions_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drug_distributions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_distributions_id_seq OWNER TO invs_user;

--
-- Name: drug_distributions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drug_distributions_id_seq OWNED BY public.drug_distributions.id;


--
-- Name: drug_focus_lists; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_focus_lists (
    id bigint NOT NULL,
    drug_id bigint NOT NULL,
    list_type integer,
    list_name character varying(50) NOT NULL,
    department_id bigint,
    created_by character varying(32),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.drug_focus_lists OWNER TO invs_user;

--
-- Name: drug_focus_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drug_focus_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_focus_lists_id_seq OWNER TO invs_user;

--
-- Name: drug_focus_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drug_focus_lists_id_seq OWNED BY public.drug_focus_lists.id;


--
-- Name: drug_generics; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_generics (
    id bigint NOT NULL,
    working_code character varying(7) NOT NULL,
    drug_name character varying(60) NOT NULL,
    dosage_form character varying(20),
    sale_unit character varying(5),
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
    therapeutic_group character varying(50),
    dosage_form_id bigint,
    sale_unit_id bigint,
    ed_category public."EdCategory",
    ed_group_id bigint,
    ed_list integer,
    tmt_gpu_code character varying(10),
    tmt_gpu_id bigint
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
-- Name: drug_lots; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_lots (
    id bigint NOT NULL,
    drug_id bigint NOT NULL,
    location_id bigint NOT NULL,
    lot_number character varying(20) NOT NULL,
    expiry_date date NOT NULL,
    quantity_available numeric(10,2) NOT NULL,
    unit_cost numeric(10,2) NOT NULL,
    received_date date NOT NULL,
    receipt_id bigint,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.drug_lots OWNER TO invs_user;

--
-- Name: drug_lots_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drug_lots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_lots_id_seq OWNER TO invs_user;

--
-- Name: drug_lots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drug_lots_id_seq OWNED BY public.drug_lots.id;


--
-- Name: drug_pack_ratios; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_pack_ratios (
    id bigint NOT NULL,
    drug_id bigint NOT NULL,
    vendor_id bigint,
    manufacturer_id bigint,
    pack_ratio numeric(10,2) DEFAULT 1 NOT NULL,
    buy_unit_cost numeric(10,2),
    sale_unit_price numeric(10,2),
    pack_unit_id integer,
    subpack_unit_id integer,
    barcode character varying(14),
    last_purchase_date date,
    is_hidden boolean DEFAULT false NOT NULL,
    pack_code character varying(18),
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.drug_pack_ratios OWNER TO invs_user;

--
-- Name: drug_pack_ratios_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drug_pack_ratios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_pack_ratios_id_seq OWNER TO invs_user;

--
-- Name: drug_pack_ratios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drug_pack_ratios_id_seq OWNED BY public.drug_pack_ratios.id;


--
-- Name: drug_return_items; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_return_items (
    id bigint NOT NULL,
    return_id bigint NOT NULL,
    drug_id bigint NOT NULL,
    total_quantity numeric(10,2) NOT NULL,
    good_quantity numeric(10,2) NOT NULL,
    damaged_quantity numeric(10,2) NOT NULL,
    lot_number character varying(20) NOT NULL,
    expiry_date date NOT NULL,
    return_type public."ReturnType" NOT NULL,
    location_id bigint,
    unit_cost numeric(10,2),
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    return_action_id bigint
);


ALTER TABLE public.drug_return_items OWNER TO invs_user;

--
-- Name: drug_return_items_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drug_return_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_return_items_id_seq OWNER TO invs_user;

--
-- Name: drug_return_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drug_return_items_id_seq OWNED BY public.drug_return_items.id;


--
-- Name: drug_returns; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_returns (
    id bigint NOT NULL,
    return_number character varying(20) NOT NULL,
    department_id bigint NOT NULL,
    return_date date NOT NULL,
    action_taken character varying(100),
    reference_number character varying(50),
    status public."ReturnStatus" DEFAULT 'draft'::public."ReturnStatus" NOT NULL,
    total_items integer DEFAULT 0 NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    received_by character varying(50) NOT NULL,
    verified_by character varying(50),
    verified_date date,
    posted_date date,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    return_reason_id bigint,
    return_reason_text character varying(100)
);


ALTER TABLE public.drug_returns OWNER TO invs_user;

--
-- Name: drug_returns_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drug_returns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_returns_id_seq OWNER TO invs_user;

--
-- Name: drug_returns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drug_returns_id_seq OWNED BY public.drug_returns.id;


--
-- Name: drug_units; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.drug_units (
    id bigint NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(60) NOT NULL,
    name_en character varying(60),
    standard_code character varying(15),
    is_hidden boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.drug_units OWNER TO invs_user;

--
-- Name: drug_units_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.drug_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drug_units_id_seq OWNER TO invs_user;

--
-- Name: drug_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.drug_units_id_seq OWNED BY public.drug_units.id;


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
    unit character varying(10),
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
    formula_reference text,
    drug_status public."DrugStatus" DEFAULT '1'::public."DrugStatus" NOT NULL,
    nlem_status public."NlemStatus",
    product_category public."ProductCategory",
    status_changed_date date,
    dosage_form_id bigint,
    unit_id bigint
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
-- Name: ed_groups; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.ed_groups (
    id bigint NOT NULL,
    code character varying(8) NOT NULL,
    name character varying(60) NOT NULL,
    sub_commit_code integer,
    forecast double precision,
    is_hidden boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.ed_groups OWNER TO invs_user;

--
-- Name: ed_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.ed_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ed_groups_id_seq OWNER TO invs_user;

--
-- Name: ed_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.ed_groups_id_seq OWNED BY public.ed_groups.id;


--
-- Name: his_drug_master; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.his_drug_master (
    id bigint NOT NULL,
    his_drug_code character varying(50) NOT NULL,
    drug_name character varying(200) NOT NULL,
    generic_name character varying(200),
    strength character varying(100),
    dosage_form character varying(50),
    manufacturer character varying(200),
    registration_number character varying(30),
    tmt_concept_id bigint,
    tmt_level public."TmtLevel",
    mapping_confidence numeric(3,2),
    mapping_status public."HisMappingStatus" DEFAULT 'pending'::public."HisMappingStatus" NOT NULL,
    nc24_code character varying(24),
    nc24_status character varying(20),
    tmt_manufacturer_id bigint,
    tmt_dosage_form_id bigint,
    is_active boolean DEFAULT true NOT NULL,
    last_sync timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.his_drug_master OWNER TO invs_user;

--
-- Name: his_drug_master_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.his_drug_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.his_drug_master_id_seq OWNER TO invs_user;

--
-- Name: his_drug_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.his_drug_master_id_seq OWNED BY public.his_drug_master.id;


--
-- Name: hospital_pharmaceutical_products; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.hospital_pharmaceutical_products (
    id bigint NOT NULL,
    hpp_code character varying(20) NOT NULL,
    hpp_type public."HppType" NOT NULL,
    product_name character varying(200) NOT NULL,
    generic_id bigint,
    drug_id bigint,
    base_product_id bigint,
    strength character varying(100),
    dosage_form character varying(50),
    pack_size character varying(50),
    unit_of_use character varying(20),
    formula_reference text,
    formula_source character varying(100),
    tmt_code character varying(10),
    tmt_id bigint,
    spec_prep character varying(10),
    is_outsourced boolean DEFAULT false NOT NULL,
    hospital_code character varying(10),
    is_active boolean DEFAULT true NOT NULL,
    approved_by character varying(50),
    approval_date timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.hospital_pharmaceutical_products OWNER TO invs_user;

--
-- Name: hospital_pharmaceutical_products_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.hospital_pharmaceutical_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hospital_pharmaceutical_products_id_seq OWNER TO invs_user;

--
-- Name: hospital_pharmaceutical_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.hospital_pharmaceutical_products_id_seq OWNED BY public.hospital_pharmaceutical_products.id;


--
-- Name: hospitals; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.hospitals (
    id bigint NOT NULL,
    hosp_code character varying(5) NOT NULL,
    hosp_name character varying(100) NOT NULL,
    hosp_type character varying(20),
    province_code character varying(2),
    area_code character varying(4),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.hospitals OWNER TO invs_user;

--
-- Name: hospitals_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.hospitals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hospitals_id_seq OWNER TO invs_user;

--
-- Name: hospitals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.hospitals_id_seq OWNED BY public.hospitals.id;


--
-- Name: hpp_formulations; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.hpp_formulations (
    id bigint NOT NULL,
    hpp_id bigint NOT NULL,
    component_type character varying(20) NOT NULL,
    component_name character varying(200) NOT NULL,
    component_strength character varying(100),
    component_unit character varying(20),
    component_ratio numeric(10,4),
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.hpp_formulations OWNER TO invs_user;

--
-- Name: hpp_formulations_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.hpp_formulations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hpp_formulations_id_seq OWNER TO invs_user;

--
-- Name: hpp_formulations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.hpp_formulations_id_seq OWNED BY public.hpp_formulations.id;


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.inventory (
    id bigint NOT NULL,
    drug_id bigint NOT NULL,
    location_id bigint NOT NULL,
    quantity_on_hand numeric(10,2) DEFAULT 0 NOT NULL,
    min_level numeric(10,2) DEFAULT 0 NOT NULL,
    max_level numeric(10,2) DEFAULT 0 NOT NULL,
    reorder_point numeric(10,2) DEFAULT 0 NOT NULL,
    average_cost numeric(10,2) DEFAULT 0 NOT NULL,
    last_cost numeric(10,2) DEFAULT 0 NOT NULL,
    last_updated timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.inventory OWNER TO invs_user;

--
-- Name: inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_id_seq OWNER TO invs_user;

--
-- Name: inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.inventory_id_seq OWNED BY public.inventory.id;


--
-- Name: inventory_transactions; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.inventory_transactions (
    id bigint NOT NULL,
    inventory_id bigint NOT NULL,
    transaction_type public."TransactionType" NOT NULL,
    quantity numeric(10,2) NOT NULL,
    unit_cost numeric(10,2),
    reference_id bigint,
    reference_type character varying(20),
    notes text,
    created_by bigint NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    adjustment_reason_id bigint
);


ALTER TABLE public.inventory_transactions OWNER TO invs_user;

--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.inventory_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventory_transactions_id_seq OWNER TO invs_user;

--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.inventory_transactions_id_seq OWNED BY public.inventory_transactions.id;


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
-- Name: ministry_reports; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.ministry_reports (
    id bigint NOT NULL,
    report_type character varying(50) NOT NULL,
    report_period character varying(20) NOT NULL,
    report_date date NOT NULL,
    hospital_code character varying(10),
    data_json jsonb,
    tmt_compliance_rate numeric(5,2),
    total_items integer,
    mapped_items integer,
    verification_status character varying(20),
    submitted_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.ministry_reports OWNER TO invs_user;

--
-- Name: ministry_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.ministry_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ministry_reports_id_seq OWNER TO invs_user;

--
-- Name: ministry_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.ministry_reports_id_seq OWNED BY public.ministry_reports.id;


--
-- Name: payment_attachments; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.payment_attachments (
    id bigint NOT NULL,
    payment_doc_id bigint NOT NULL,
    attachment_type public."AttachmentType" NOT NULL,
    file_name character varying(255) NOT NULL,
    file_path character varying(500) NOT NULL,
    file_size integer,
    uploaded_by character varying(50) NOT NULL,
    uploaded_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    notes text
);


ALTER TABLE public.payment_attachments OWNER TO invs_user;

--
-- Name: payment_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.payment_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_attachments_id_seq OWNER TO invs_user;

--
-- Name: payment_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.payment_attachments_id_seq OWNED BY public.payment_attachments.id;


--
-- Name: payment_documents; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.payment_documents (
    id bigint NOT NULL,
    payment_doc_number character varying(20) NOT NULL,
    receipt_id bigint NOT NULL,
    po_id bigint NOT NULL,
    submitted_to_finance_by character varying(50),
    submitted_to_finance_date date,
    approved_by_finance character varying(50),
    approved_by_finance_date date,
    paid_date date,
    paid_amount numeric(15,2),
    payment_method character varying(50),
    reference_number character varying(50),
    payment_status public."PaymentStatus" DEFAULT 'pending'::public."PaymentStatus" NOT NULL,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.payment_documents OWNER TO invs_user;

--
-- Name: payment_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.payment_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_documents_id_seq OWNER TO invs_user;

--
-- Name: payment_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.payment_documents_id_seq OWNED BY public.payment_documents.id;


--
-- Name: purchase_methods; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.purchase_methods (
    id bigint NOT NULL,
    code integer NOT NULL,
    name character varying(50) NOT NULL,
    min_amount numeric(12,2),
    max_amount numeric(12,2),
    deal_days integer,
    authority_signer character varying(30),
    std_code character varying(6),
    report_forms character varying(60),
    is_hidden boolean DEFAULT false NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.purchase_methods OWNER TO invs_user;

--
-- Name: purchase_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.purchase_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_methods_id_seq OWNER TO invs_user;

--
-- Name: purchase_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.purchase_methods_id_seq OWNED BY public.purchase_methods.id;


--
-- Name: purchase_order_items; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.purchase_order_items (
    id bigint NOT NULL,
    po_id bigint NOT NULL,
    drug_id bigint NOT NULL,
    quantity_ordered numeric(10,2) NOT NULL,
    unit_cost numeric(10,2) NOT NULL,
    quantity_received numeric(10,2) DEFAULT 0 NOT NULL,
    notes text
);


ALTER TABLE public.purchase_order_items OWNER TO invs_user;

--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.purchase_order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_order_items_id_seq OWNER TO invs_user;

--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.purchase_order_items_id_seq OWNED BY public.purchase_order_items.id;


--
-- Name: purchase_order_reasons; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.purchase_order_reasons (
    id bigint NOT NULL,
    code integer NOT NULL,
    reason character varying(60) NOT NULL,
    is_hidden boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.purchase_order_reasons OWNER TO invs_user;

--
-- Name: purchase_order_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.purchase_order_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_order_reasons_id_seq OWNER TO invs_user;

--
-- Name: purchase_order_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.purchase_order_reasons_id_seq OWNED BY public.purchase_order_reasons.id;


--
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.purchase_orders (
    id bigint NOT NULL,
    po_number character varying(20) NOT NULL,
    vendor_id bigint NOT NULL,
    po_date date NOT NULL,
    delivery_date date,
    department_id bigint,
    budget_id bigint,
    status public."PoStatus" DEFAULT 'draft'::public."PoStatus" NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    total_items integer DEFAULT 0 NOT NULL,
    notes text,
    created_by bigint NOT NULL,
    approved_by bigint,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    confirmed_by bigint,
    confirmed_date date,
    contract_id bigint,
    printed_date date,
    sent_to_vendor_date date,
    egp_number character varying(30),
    gf_number character varying(10),
    project_number character varying(30),
    purchase_method_id bigint,
    purchase_type_id bigint
);


ALTER TABLE public.purchase_orders OWNER TO invs_user;

--
-- Name: purchase_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.purchase_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_orders_id_seq OWNER TO invs_user;

--
-- Name: purchase_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.purchase_orders_id_seq OWNED BY public.purchase_orders.id;


--
-- Name: purchase_request_items; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.purchase_request_items (
    id bigint NOT NULL,
    pr_id bigint NOT NULL,
    item_number integer NOT NULL,
    generic_id bigint,
    description text,
    quantity_requested numeric(10,2) NOT NULL,
    estimated_unit_cost numeric(10,2),
    estimated_total_cost numeric(15,2),
    justification text,
    status public."ItemStatus" DEFAULT 'pending'::public."ItemStatus" NOT NULL
);


ALTER TABLE public.purchase_request_items OWNER TO invs_user;

--
-- Name: purchase_request_items_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.purchase_request_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_request_items_id_seq OWNER TO invs_user;

--
-- Name: purchase_request_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.purchase_request_items_id_seq OWNED BY public.purchase_request_items.id;


--
-- Name: purchase_requests; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.purchase_requests (
    id bigint NOT NULL,
    pr_number character varying(20) NOT NULL,
    pr_date date NOT NULL,
    department_id bigint NOT NULL,
    budget_allocation_id bigint,
    requested_amount numeric(15,2) NOT NULL,
    purpose text,
    urgency public."Urgency" DEFAULT 'normal'::public."Urgency" NOT NULL,
    status public."RequestStatus" DEFAULT 'draft'::public."RequestStatus" NOT NULL,
    requested_by character varying(50) NOT NULL,
    approved_by character varying(50),
    approval_date date,
    converted_to_po boolean DEFAULT false NOT NULL,
    po_id bigint,
    remarks text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.purchase_requests OWNER TO invs_user;

--
-- Name: purchase_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.purchase_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_requests_id_seq OWNER TO invs_user;

--
-- Name: purchase_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.purchase_requests_id_seq OWNED BY public.purchase_requests.id;


--
-- Name: purchase_types; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.purchase_types (
    id bigint NOT NULL,
    code integer NOT NULL,
    name character varying(50) NOT NULL,
    authority_signer character varying(30),
    std_code character varying(6),
    deal_days integer,
    is_hidden boolean DEFAULT false NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.purchase_types OWNER TO invs_user;

--
-- Name: purchase_types_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.purchase_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_types_id_seq OWNER TO invs_user;

--
-- Name: purchase_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.purchase_types_id_seq OWNED BY public.purchase_types.id;


--
-- Name: receipt_inspectors; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.receipt_inspectors (
    id bigint NOT NULL,
    receipt_id bigint NOT NULL,
    inspector_name character varying(100) NOT NULL,
    inspector_position character varying(100),
    inspector_role public."InspectorRole" NOT NULL,
    signed_date date,
    signature_path character varying(255),
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.receipt_inspectors OWNER TO invs_user;

--
-- Name: receipt_inspectors_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.receipt_inspectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.receipt_inspectors_id_seq OWNER TO invs_user;

--
-- Name: receipt_inspectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.receipt_inspectors_id_seq OWNED BY public.receipt_inspectors.id;


--
-- Name: receipt_items; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.receipt_items (
    id bigint NOT NULL,
    receipt_id bigint NOT NULL,
    drug_id bigint NOT NULL,
    quantity_received numeric(10,2) NOT NULL,
    unit_cost numeric(10,2) NOT NULL,
    lot_number character varying(20),
    expiry_date date,
    notes text,
    remaining_quantity numeric(10,2),
    item_type public."PurchaseItemType"
);


ALTER TABLE public.receipt_items OWNER TO invs_user;

--
-- Name: receipt_items_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.receipt_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.receipt_items_id_seq OWNER TO invs_user;

--
-- Name: receipt_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.receipt_items_id_seq OWNED BY public.receipt_items.id;


--
-- Name: receipts; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.receipts (
    id bigint NOT NULL,
    receipt_number character varying(20) NOT NULL,
    po_id bigint NOT NULL,
    receipt_date date NOT NULL,
    delivery_note character varying(50),
    status public."ReceiptStatus" DEFAULT 'draft'::public."ReceiptStatus" NOT NULL,
    total_items integer DEFAULT 0 NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    received_by bigint NOT NULL,
    verified_by bigint,
    notes text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    invoice_date date,
    invoice_number character varying(50),
    posted_date date,
    received_date date,
    verified_date date,
    billing_date date,
    receive_time character varying(5)
);


ALTER TABLE public.receipts OWNER TO invs_user;

--
-- Name: receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.receipts_id_seq OWNER TO invs_user;

--
-- Name: receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.receipts_id_seq OWNED BY public.receipts.id;


--
-- Name: return_actions; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.return_actions (
    id bigint NOT NULL,
    code integer NOT NULL,
    action character varying(60) NOT NULL,
    action_type character varying(30),
    is_hidden boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.return_actions OWNER TO invs_user;

--
-- Name: return_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.return_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.return_actions_id_seq OWNER TO invs_user;

--
-- Name: return_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.return_actions_id_seq OWNED BY public.return_actions.id;


--
-- Name: return_reasons; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.return_reasons (
    id bigint NOT NULL,
    code integer NOT NULL,
    reason character varying(100) NOT NULL,
    category character varying(30),
    is_hidden boolean DEFAULT false NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.return_reasons OWNER TO invs_user;

--
-- Name: return_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.return_reasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.return_reasons_id_seq OWNER TO invs_user;

--
-- Name: return_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.return_reasons_id_seq OWNED BY public.return_reasons.id;


--
-- Name: tmt_attributes; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.tmt_attributes (
    id bigint NOT NULL,
    concept_id bigint NOT NULL,
    attribute_type character varying(50) NOT NULL,
    attribute_value text NOT NULL,
    value_type character varying(20) NOT NULL,
    unit character varying(20),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tmt_attributes OWNER TO invs_user;

--
-- Name: tmt_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.tmt_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmt_attributes_id_seq OWNER TO invs_user;

--
-- Name: tmt_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.tmt_attributes_id_seq OWNED BY public.tmt_attributes.id;


--
-- Name: tmt_concepts; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.tmt_concepts (
    id bigint NOT NULL,
    tmt_id bigint NOT NULL,
    concept_code character varying(20),
    level public."TmtLevel" NOT NULL,
    fsn character varying(2000) NOT NULL,
    preferred_term character varying(300),
    strength character varying(100),
    dosage_form character varying(50),
    manufacturer character varying(300),
    pack_size character varying(50),
    unit_of_use character varying(20),
    route_of_administration character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    effective_date timestamp(3) without time zone,
    release_date character varying(20),
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tmt_concepts OWNER TO invs_user;

--
-- Name: tmt_concepts_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.tmt_concepts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmt_concepts_id_seq OWNER TO invs_user;

--
-- Name: tmt_concepts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.tmt_concepts_id_seq OWNED BY public.tmt_concepts.id;


--
-- Name: tmt_dosage_forms; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.tmt_dosage_forms (
    id bigint NOT NULL,
    form_code character varying(20) NOT NULL,
    form_name character varying(100) NOT NULL,
    form_name_en character varying(100),
    category character varying(50),
    route_of_administration character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tmt_dosage_forms OWNER TO invs_user;

--
-- Name: tmt_dosage_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.tmt_dosage_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmt_dosage_forms_id_seq OWNER TO invs_user;

--
-- Name: tmt_dosage_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.tmt_dosage_forms_id_seq OWNED BY public.tmt_dosage_forms.id;


--
-- Name: tmt_manufacturers; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.tmt_manufacturers (
    id bigint NOT NULL,
    manufacturer_code character varying(20),
    manufacturer_name character varying(300) NOT NULL,
    manufacturer_name_en character varying(300),
    country_code character varying(3),
    fda_license character varying(50),
    gmp_status character varying(20),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tmt_manufacturers OWNER TO invs_user;

--
-- Name: tmt_manufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.tmt_manufacturers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmt_manufacturers_id_seq OWNER TO invs_user;

--
-- Name: tmt_manufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.tmt_manufacturers_id_seq OWNED BY public.tmt_manufacturers.id;


--
-- Name: tmt_mappings; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.tmt_mappings (
    id bigint NOT NULL,
    working_code character varying(7),
    drug_code character varying(24),
    generic_id bigint,
    drug_id bigint,
    tmt_level public."TmtLevel" NOT NULL,
    tmt_concept_id bigint NOT NULL,
    tmt_code character varying(10),
    tmt_id bigint NOT NULL,
    mapping_source character varying(50),
    confidence numeric(3,2),
    mapped_by character varying(50),
    verified_by character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    mapping_date timestamp(3) without time zone NOT NULL,
    verification_date timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tmt_mappings OWNER TO invs_user;

--
-- Name: tmt_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.tmt_mappings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmt_mappings_id_seq OWNER TO invs_user;

--
-- Name: tmt_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.tmt_mappings_id_seq OWNED BY public.tmt_mappings.id;


--
-- Name: tmt_relationships; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.tmt_relationships (
    id bigint NOT NULL,
    parent_id bigint NOT NULL,
    child_id bigint NOT NULL,
    relationship_type public."TmtRelationType" NOT NULL,
    strength_value character varying(100),
    dosage_form_value character varying(50),
    manufacturer_value character varying(300),
    pack_size_value character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    effective_date timestamp(3) without time zone,
    release_date character varying(20),
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tmt_relationships OWNER TO invs_user;

--
-- Name: tmt_relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.tmt_relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmt_relationships_id_seq OWNER TO invs_user;

--
-- Name: tmt_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.tmt_relationships_id_seq OWNED BY public.tmt_relationships.id;


--
-- Name: tmt_units; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.tmt_units (
    id bigint NOT NULL,
    unit_code character varying(20) NOT NULL,
    unit_name character varying(50) NOT NULL,
    unit_name_en character varying(50),
    unit_type character varying(20),
    base_unit character varying(20),
    conversion_factor numeric(15,6),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tmt_units OWNER TO invs_user;

--
-- Name: tmt_units_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.tmt_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmt_units_id_seq OWNER TO invs_user;

--
-- Name: tmt_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.tmt_units_id_seq OWNED BY public.tmt_units.id;


--
-- Name: tmt_usage_stats; Type: TABLE; Schema: public; Owner: invs_user
--

CREATE TABLE public.tmt_usage_stats (
    id bigint NOT NULL,
    period_type character varying(20) NOT NULL,
    period_date date NOT NULL,
    tmt_concept_id bigint,
    his_drug_master_id bigint,
    usage_count integer DEFAULT 0 NOT NULL,
    prescription_count integer DEFAULT 0 NOT NULL,
    dispensing_count integer DEFAULT 0 NOT NULL,
    consumption_amount numeric(15,3),
    unit character varying(20),
    department_id bigint,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tmt_usage_stats OWNER TO invs_user;

--
-- Name: tmt_usage_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: invs_user
--

CREATE SEQUENCE public.tmt_usage_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmt_usage_stats_id_seq OWNER TO invs_user;

--
-- Name: tmt_usage_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: invs_user
--

ALTER SEQUENCE public.tmt_usage_stats_id_seq OWNED BY public.tmt_usage_stats.id;


--
-- Name: adjustment_reasons id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.adjustment_reasons ALTER COLUMN id SET DEFAULT nextval('public.adjustment_reasons_id_seq'::regclass);


--
-- Name: approval_documents id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.approval_documents ALTER COLUMN id SET DEFAULT nextval('public.approval_documents_id_seq'::regclass);


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
-- Name: budget_plan_items id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_plan_items ALTER COLUMN id SET DEFAULT nextval('public.budget_plan_items_id_seq'::regclass);


--
-- Name: budget_plans id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_plans ALTER COLUMN id SET DEFAULT nextval('public.budget_plans_id_seq'::regclass);


--
-- Name: budget_reservations id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_reservations ALTER COLUMN id SET DEFAULT nextval('public.budget_reservations_id_seq'::regclass);


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
-- Name: contract_items id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.contract_items ALTER COLUMN id SET DEFAULT nextval('public.contract_items_id_seq'::regclass);


--
-- Name: contracts id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.contracts ALTER COLUMN id SET DEFAULT nextval('public.contracts_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: distribution_types id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.distribution_types ALTER COLUMN id SET DEFAULT nextval('public.distribution_types_id_seq'::regclass);


--
-- Name: dosage_forms id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.dosage_forms ALTER COLUMN id SET DEFAULT nextval('public.dosage_forms_id_seq'::regclass);


--
-- Name: drug_components id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_components ALTER COLUMN id SET DEFAULT nextval('public.drug_components_id_seq'::regclass);


--
-- Name: drug_distribution_items id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_distribution_items ALTER COLUMN id SET DEFAULT nextval('public.drug_distribution_items_id_seq'::regclass);


--
-- Name: drug_distributions id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_distributions ALTER COLUMN id SET DEFAULT nextval('public.drug_distributions_id_seq'::regclass);


--
-- Name: drug_focus_lists id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_focus_lists ALTER COLUMN id SET DEFAULT nextval('public.drug_focus_lists_id_seq'::regclass);


--
-- Name: drug_generics id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_generics ALTER COLUMN id SET DEFAULT nextval('public.drug_generics_id_seq'::regclass);


--
-- Name: drug_lots id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_lots ALTER COLUMN id SET DEFAULT nextval('public.drug_lots_id_seq'::regclass);


--
-- Name: drug_pack_ratios id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_pack_ratios ALTER COLUMN id SET DEFAULT nextval('public.drug_pack_ratios_id_seq'::regclass);


--
-- Name: drug_return_items id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_return_items ALTER COLUMN id SET DEFAULT nextval('public.drug_return_items_id_seq'::regclass);


--
-- Name: drug_returns id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_returns ALTER COLUMN id SET DEFAULT nextval('public.drug_returns_id_seq'::regclass);


--
-- Name: drug_units id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_units ALTER COLUMN id SET DEFAULT nextval('public.drug_units_id_seq'::regclass);


--
-- Name: drugs id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drugs ALTER COLUMN id SET DEFAULT nextval('public.drugs_id_seq'::regclass);


--
-- Name: ed_groups id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.ed_groups ALTER COLUMN id SET DEFAULT nextval('public.ed_groups_id_seq'::regclass);


--
-- Name: his_drug_master id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.his_drug_master ALTER COLUMN id SET DEFAULT nextval('public.his_drug_master_id_seq'::regclass);


--
-- Name: hospital_pharmaceutical_products id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hospital_pharmaceutical_products ALTER COLUMN id SET DEFAULT nextval('public.hospital_pharmaceutical_products_id_seq'::regclass);


--
-- Name: hospitals id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hospitals ALTER COLUMN id SET DEFAULT nextval('public.hospitals_id_seq'::regclass);


--
-- Name: hpp_formulations id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hpp_formulations ALTER COLUMN id SET DEFAULT nextval('public.hpp_formulations_id_seq'::regclass);


--
-- Name: inventory id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.inventory ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);


--
-- Name: inventory_transactions id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.inventory_transactions ALTER COLUMN id SET DEFAULT nextval('public.inventory_transactions_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: ministry_reports id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.ministry_reports ALTER COLUMN id SET DEFAULT nextval('public.ministry_reports_id_seq'::regclass);


--
-- Name: payment_attachments id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.payment_attachments ALTER COLUMN id SET DEFAULT nextval('public.payment_attachments_id_seq'::regclass);


--
-- Name: payment_documents id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.payment_documents ALTER COLUMN id SET DEFAULT nextval('public.payment_documents_id_seq'::regclass);


--
-- Name: purchase_methods id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_methods ALTER COLUMN id SET DEFAULT nextval('public.purchase_methods_id_seq'::regclass);


--
-- Name: purchase_order_items id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_order_items ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_items_id_seq'::regclass);


--
-- Name: purchase_order_reasons id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_order_reasons ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_reasons_id_seq'::regclass);


--
-- Name: purchase_orders id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_orders ALTER COLUMN id SET DEFAULT nextval('public.purchase_orders_id_seq'::regclass);


--
-- Name: purchase_request_items id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_request_items ALTER COLUMN id SET DEFAULT nextval('public.purchase_request_items_id_seq'::regclass);


--
-- Name: purchase_requests id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_requests ALTER COLUMN id SET DEFAULT nextval('public.purchase_requests_id_seq'::regclass);


--
-- Name: purchase_types id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_types ALTER COLUMN id SET DEFAULT nextval('public.purchase_types_id_seq'::regclass);


--
-- Name: receipt_inspectors id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.receipt_inspectors ALTER COLUMN id SET DEFAULT nextval('public.receipt_inspectors_id_seq'::regclass);


--
-- Name: receipt_items id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.receipt_items ALTER COLUMN id SET DEFAULT nextval('public.receipt_items_id_seq'::regclass);


--
-- Name: receipts id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.receipts ALTER COLUMN id SET DEFAULT nextval('public.receipts_id_seq'::regclass);


--
-- Name: return_actions id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.return_actions ALTER COLUMN id SET DEFAULT nextval('public.return_actions_id_seq'::regclass);


--
-- Name: return_reasons id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.return_reasons ALTER COLUMN id SET DEFAULT nextval('public.return_reasons_id_seq'::regclass);


--
-- Name: tmt_attributes id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_attributes ALTER COLUMN id SET DEFAULT nextval('public.tmt_attributes_id_seq'::regclass);


--
-- Name: tmt_concepts id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_concepts ALTER COLUMN id SET DEFAULT nextval('public.tmt_concepts_id_seq'::regclass);


--
-- Name: tmt_dosage_forms id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_dosage_forms ALTER COLUMN id SET DEFAULT nextval('public.tmt_dosage_forms_id_seq'::regclass);


--
-- Name: tmt_manufacturers id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_manufacturers ALTER COLUMN id SET DEFAULT nextval('public.tmt_manufacturers_id_seq'::regclass);


--
-- Name: tmt_mappings id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_mappings ALTER COLUMN id SET DEFAULT nextval('public.tmt_mappings_id_seq'::regclass);


--
-- Name: tmt_relationships id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_relationships ALTER COLUMN id SET DEFAULT nextval('public.tmt_relationships_id_seq'::regclass);


--
-- Name: tmt_units id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_units ALTER COLUMN id SET DEFAULT nextval('public.tmt_units_id_seq'::regclass);


--
-- Name: tmt_usage_stats id; Type: DEFAULT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_usage_stats ALTER COLUMN id SET DEFAULT nextval('public.tmt_usage_stats_id_seq'::regclass);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: adjustment_reasons adjustment_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.adjustment_reasons
    ADD CONSTRAINT adjustment_reasons_pkey PRIMARY KEY (id);


--
-- Name: approval_documents approval_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.approval_documents
    ADD CONSTRAINT approval_documents_pkey PRIMARY KEY (id);


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
-- Name: budget_plan_items budget_plan_items_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_plan_items
    ADD CONSTRAINT budget_plan_items_pkey PRIMARY KEY (id);


--
-- Name: budget_plans budget_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_plans
    ADD CONSTRAINT budget_plans_pkey PRIMARY KEY (id);


--
-- Name: budget_reservations budget_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_reservations
    ADD CONSTRAINT budget_reservations_pkey PRIMARY KEY (id);


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
-- Name: contract_items contract_items_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.contract_items
    ADD CONSTRAINT contract_items_pkey PRIMARY KEY (id);


--
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: distribution_types distribution_types_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.distribution_types
    ADD CONSTRAINT distribution_types_pkey PRIMARY KEY (id);


--
-- Name: dosage_forms dosage_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.dosage_forms
    ADD CONSTRAINT dosage_forms_pkey PRIMARY KEY (id);


--
-- Name: drug_components drug_components_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_components
    ADD CONSTRAINT drug_components_pkey PRIMARY KEY (id);


--
-- Name: drug_distribution_items drug_distribution_items_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_distribution_items
    ADD CONSTRAINT drug_distribution_items_pkey PRIMARY KEY (id);


--
-- Name: drug_distributions drug_distributions_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_distributions
    ADD CONSTRAINT drug_distributions_pkey PRIMARY KEY (id);


--
-- Name: drug_focus_lists drug_focus_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_focus_lists
    ADD CONSTRAINT drug_focus_lists_pkey PRIMARY KEY (id);


--
-- Name: drug_generics drug_generics_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_generics
    ADD CONSTRAINT drug_generics_pkey PRIMARY KEY (id);


--
-- Name: drug_lots drug_lots_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_lots
    ADD CONSTRAINT drug_lots_pkey PRIMARY KEY (id);


--
-- Name: drug_pack_ratios drug_pack_ratios_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_pack_ratios
    ADD CONSTRAINT drug_pack_ratios_pkey PRIMARY KEY (id);


--
-- Name: drug_return_items drug_return_items_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_return_items
    ADD CONSTRAINT drug_return_items_pkey PRIMARY KEY (id);


--
-- Name: drug_returns drug_returns_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_returns
    ADD CONSTRAINT drug_returns_pkey PRIMARY KEY (id);


--
-- Name: drug_units drug_units_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_units
    ADD CONSTRAINT drug_units_pkey PRIMARY KEY (id);


--
-- Name: drugs drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_pkey PRIMARY KEY (id);


--
-- Name: ed_groups ed_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.ed_groups
    ADD CONSTRAINT ed_groups_pkey PRIMARY KEY (id);


--
-- Name: his_drug_master his_drug_master_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.his_drug_master
    ADD CONSTRAINT his_drug_master_pkey PRIMARY KEY (id);


--
-- Name: hospital_pharmaceutical_products hospital_pharmaceutical_products_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hospital_pharmaceutical_products
    ADD CONSTRAINT hospital_pharmaceutical_products_pkey PRIMARY KEY (id);


--
-- Name: hospitals hospitals_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hospitals
    ADD CONSTRAINT hospitals_pkey PRIMARY KEY (id);


--
-- Name: hpp_formulations hpp_formulations_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hpp_formulations
    ADD CONSTRAINT hpp_formulations_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- Name: inventory_transactions inventory_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: ministry_reports ministry_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.ministry_reports
    ADD CONSTRAINT ministry_reports_pkey PRIMARY KEY (id);


--
-- Name: payment_attachments payment_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.payment_attachments
    ADD CONSTRAINT payment_attachments_pkey PRIMARY KEY (id);


--
-- Name: payment_documents payment_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.payment_documents
    ADD CONSTRAINT payment_documents_pkey PRIMARY KEY (id);


--
-- Name: purchase_methods purchase_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_methods
    ADD CONSTRAINT purchase_methods_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_reasons purchase_order_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_order_reasons
    ADD CONSTRAINT purchase_order_reasons_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: purchase_request_items purchase_request_items_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_request_items
    ADD CONSTRAINT purchase_request_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_requests purchase_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_pkey PRIMARY KEY (id);


--
-- Name: purchase_types purchase_types_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_types
    ADD CONSTRAINT purchase_types_pkey PRIMARY KEY (id);


--
-- Name: receipt_inspectors receipt_inspectors_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.receipt_inspectors
    ADD CONSTRAINT receipt_inspectors_pkey PRIMARY KEY (id);


--
-- Name: receipt_items receipt_items_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.receipt_items
    ADD CONSTRAINT receipt_items_pkey PRIMARY KEY (id);


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (id);


--
-- Name: return_actions return_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.return_actions
    ADD CONSTRAINT return_actions_pkey PRIMARY KEY (id);


--
-- Name: return_reasons return_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.return_reasons
    ADD CONSTRAINT return_reasons_pkey PRIMARY KEY (id);


--
-- Name: tmt_attributes tmt_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_attributes
    ADD CONSTRAINT tmt_attributes_pkey PRIMARY KEY (id);


--
-- Name: tmt_concepts tmt_concepts_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_concepts
    ADD CONSTRAINT tmt_concepts_pkey PRIMARY KEY (id);


--
-- Name: tmt_dosage_forms tmt_dosage_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_dosage_forms
    ADD CONSTRAINT tmt_dosage_forms_pkey PRIMARY KEY (id);


--
-- Name: tmt_manufacturers tmt_manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_manufacturers
    ADD CONSTRAINT tmt_manufacturers_pkey PRIMARY KEY (id);


--
-- Name: tmt_mappings tmt_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_mappings
    ADD CONSTRAINT tmt_mappings_pkey PRIMARY KEY (id);


--
-- Name: tmt_relationships tmt_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_relationships
    ADD CONSTRAINT tmt_relationships_pkey PRIMARY KEY (id);


--
-- Name: tmt_units tmt_units_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_units
    ADD CONSTRAINT tmt_units_pkey PRIMARY KEY (id);


--
-- Name: tmt_usage_stats tmt_usage_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_usage_stats
    ADD CONSTRAINT tmt_usage_stats_pkey PRIMARY KEY (id);


--
-- Name: adjustment_reasons_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX adjustment_reasons_code_key ON public.adjustment_reasons USING btree (code);


--
-- Name: approval_documents_approval_doc_number_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX approval_documents_approval_doc_number_key ON public.approval_documents USING btree (approval_doc_number);


--
-- Name: budget_allocations_fiscal_year_budget_id_department_id_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX budget_allocations_fiscal_year_budget_id_department_id_key ON public.budget_allocations USING btree (fiscal_year, budget_id, department_id);


--
-- Name: budget_categories_category_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX budget_categories_category_code_key ON public.budget_categories USING btree (category_code);


--
-- Name: budget_plan_items_budget_plan_id_item_number_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX budget_plan_items_budget_plan_id_item_number_key ON public.budget_plan_items USING btree (budget_plan_id, item_number);


--
-- Name: budget_plans_fiscal_year_department_id_budget_allocation_id_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX budget_plans_fiscal_year_department_id_budget_allocation_id_key ON public.budget_plans USING btree (fiscal_year, department_id, budget_allocation_id);


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
-- Name: contract_items_contract_id_drug_id_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX contract_items_contract_id_drug_id_key ON public.contract_items USING btree (contract_id, drug_id);


--
-- Name: contracts_contract_number_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX contracts_contract_number_key ON public.contracts USING btree (contract_number);


--
-- Name: departments_dept_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX departments_dept_code_key ON public.departments USING btree (dept_code);


--
-- Name: departments_his_code_idx; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE INDEX departments_his_code_idx ON public.departments USING btree (his_code);


--
-- Name: distribution_types_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX distribution_types_code_key ON public.distribution_types USING btree (code);


--
-- Name: dosage_forms_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX dosage_forms_code_key ON public.dosage_forms USING btree (code);


--
-- Name: drug_components_generic_id_idx; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE INDEX drug_components_generic_id_idx ON public.drug_components USING btree (generic_id);


--
-- Name: drug_components_tmt_concept_id_idx; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE INDEX drug_components_tmt_concept_id_idx ON public.drug_components USING btree (tmt_concept_id);


--
-- Name: drug_distributions_distribution_number_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX drug_distributions_distribution_number_key ON public.drug_distributions USING btree (distribution_number);


--
-- Name: drug_focus_lists_drug_id_idx; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE INDEX drug_focus_lists_drug_id_idx ON public.drug_focus_lists USING btree (drug_id);


--
-- Name: drug_focus_lists_list_type_idx; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE INDEX drug_focus_lists_list_type_idx ON public.drug_focus_lists USING btree (list_type);


--
-- Name: drug_generics_working_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX drug_generics_working_code_key ON public.drug_generics USING btree (working_code);


--
-- Name: drug_pack_ratios_drug_id_idx; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE INDEX drug_pack_ratios_drug_id_idx ON public.drug_pack_ratios USING btree (drug_id);


--
-- Name: drug_pack_ratios_vendor_id_idx; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE INDEX drug_pack_ratios_vendor_id_idx ON public.drug_pack_ratios USING btree (vendor_id);


--
-- Name: drug_returns_return_number_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX drug_returns_return_number_key ON public.drug_returns USING btree (return_number);


--
-- Name: drug_units_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX drug_units_code_key ON public.drug_units USING btree (code);


--
-- Name: drugs_drug_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX drugs_drug_code_key ON public.drugs USING btree (drug_code);


--
-- Name: ed_groups_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX ed_groups_code_key ON public.ed_groups USING btree (code);


--
-- Name: his_drug_master_his_drug_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX his_drug_master_his_drug_code_key ON public.his_drug_master USING btree (his_drug_code);


--
-- Name: hospital_pharmaceutical_products_hpp_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX hospital_pharmaceutical_products_hpp_code_key ON public.hospital_pharmaceutical_products USING btree (hpp_code);


--
-- Name: hospitals_area_code_idx; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE INDEX hospitals_area_code_idx ON public.hospitals USING btree (area_code);


--
-- Name: hospitals_hosp_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX hospitals_hosp_code_key ON public.hospitals USING btree (hosp_code);


--
-- Name: hospitals_province_code_idx; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE INDEX hospitals_province_code_idx ON public.hospitals USING btree (province_code);


--
-- Name: inventory_drug_id_location_id_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX inventory_drug_id_location_id_key ON public.inventory USING btree (drug_id, location_id);


--
-- Name: locations_location_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX locations_location_code_key ON public.locations USING btree (location_code);


--
-- Name: payment_documents_payment_doc_number_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX payment_documents_payment_doc_number_key ON public.payment_documents USING btree (payment_doc_number);


--
-- Name: purchase_methods_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX purchase_methods_code_key ON public.purchase_methods USING btree (code);


--
-- Name: purchase_order_items_po_id_drug_id_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX purchase_order_items_po_id_drug_id_key ON public.purchase_order_items USING btree (po_id, drug_id);


--
-- Name: purchase_order_reasons_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX purchase_order_reasons_code_key ON public.purchase_order_reasons USING btree (code);


--
-- Name: purchase_orders_po_number_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX purchase_orders_po_number_key ON public.purchase_orders USING btree (po_number);


--
-- Name: purchase_requests_pr_number_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX purchase_requests_pr_number_key ON public.purchase_requests USING btree (pr_number);


--
-- Name: purchase_types_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX purchase_types_code_key ON public.purchase_types USING btree (code);


--
-- Name: receipts_receipt_number_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX receipts_receipt_number_key ON public.receipts USING btree (receipt_number);


--
-- Name: return_actions_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX return_actions_code_key ON public.return_actions USING btree (code);


--
-- Name: return_reasons_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX return_reasons_code_key ON public.return_reasons USING btree (code);


--
-- Name: tmt_concepts_tmt_id_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX tmt_concepts_tmt_id_key ON public.tmt_concepts USING btree (tmt_id);


--
-- Name: tmt_dosage_forms_form_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX tmt_dosage_forms_form_code_key ON public.tmt_dosage_forms USING btree (form_code);


--
-- Name: tmt_manufacturers_manufacturer_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX tmt_manufacturers_manufacturer_code_key ON public.tmt_manufacturers USING btree (manufacturer_code);


--
-- Name: tmt_relationships_parent_id_child_id_relationship_type_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX tmt_relationships_parent_id_child_id_relationship_type_key ON public.tmt_relationships USING btree (parent_id, child_id, relationship_type);


--
-- Name: tmt_units_unit_code_key; Type: INDEX; Schema: public; Owner: invs_user
--

CREATE UNIQUE INDEX tmt_units_unit_code_key ON public.tmt_units USING btree (unit_code);


--
-- Name: approval_documents approval_documents_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.approval_documents
    ADD CONSTRAINT approval_documents_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: budget_plan_items budget_plan_items_budget_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_plan_items
    ADD CONSTRAINT budget_plan_items_budget_plan_id_fkey FOREIGN KEY (budget_plan_id) REFERENCES public.budget_plans(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: budget_plan_items budget_plan_items_generic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_plan_items
    ADD CONSTRAINT budget_plan_items_generic_id_fkey FOREIGN KEY (generic_id) REFERENCES public.drug_generics(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: budget_plans budget_plans_budget_allocation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_plans
    ADD CONSTRAINT budget_plans_budget_allocation_id_fkey FOREIGN KEY (budget_allocation_id) REFERENCES public.budget_allocations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: budget_plans budget_plans_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_plans
    ADD CONSTRAINT budget_plans_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: budget_reservations budget_reservations_allocation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_reservations
    ADD CONSTRAINT budget_reservations_allocation_id_fkey FOREIGN KEY (allocation_id) REFERENCES public.budget_allocations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: budget_reservations budget_reservations_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_reservations
    ADD CONSTRAINT budget_reservations_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: budget_reservations budget_reservations_pr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.budget_reservations
    ADD CONSTRAINT budget_reservations_pr_id_fkey FOREIGN KEY (pr_id) REFERENCES public.purchase_requests(id) ON UPDATE CASCADE ON DELETE SET NULL;


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
-- Name: contract_items contract_items_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.contract_items
    ADD CONSTRAINT contract_items_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES public.contracts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: contract_items contract_items_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.contract_items
    ADD CONSTRAINT contract_items_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: contracts contracts_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: departments departments_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_components drug_components_generic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_components
    ADD CONSTRAINT drug_components_generic_id_fkey FOREIGN KEY (generic_id) REFERENCES public.drug_generics(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: drug_components drug_components_tmt_concept_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_components
    ADD CONSTRAINT drug_components_tmt_concept_id_fkey FOREIGN KEY (tmt_concept_id) REFERENCES public.tmt_concepts(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_distribution_items drug_distribution_items_distribution_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_distribution_items
    ADD CONSTRAINT drug_distribution_items_distribution_id_fkey FOREIGN KEY (distribution_id) REFERENCES public.drug_distributions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: drug_distribution_items drug_distribution_items_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_distribution_items
    ADD CONSTRAINT drug_distribution_items_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: drug_distributions drug_distributions_distribution_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_distributions
    ADD CONSTRAINT drug_distributions_distribution_type_id_fkey FOREIGN KEY (distribution_type_id) REFERENCES public.distribution_types(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_distributions drug_distributions_from_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_distributions
    ADD CONSTRAINT drug_distributions_from_location_id_fkey FOREIGN KEY (from_location_id) REFERENCES public.locations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: drug_distributions drug_distributions_requesting_dept_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_distributions
    ADD CONSTRAINT drug_distributions_requesting_dept_id_fkey FOREIGN KEY (requesting_dept_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_distributions drug_distributions_to_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_distributions
    ADD CONSTRAINT drug_distributions_to_location_id_fkey FOREIGN KEY (to_location_id) REFERENCES public.locations(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_focus_lists drug_focus_lists_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_focus_lists
    ADD CONSTRAINT drug_focus_lists_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_focus_lists drug_focus_lists_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_focus_lists
    ADD CONSTRAINT drug_focus_lists_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: drug_generics drug_generics_dosage_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_generics
    ADD CONSTRAINT drug_generics_dosage_form_id_fkey FOREIGN KEY (dosage_form_id) REFERENCES public.dosage_forms(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_generics drug_generics_ed_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_generics
    ADD CONSTRAINT drug_generics_ed_group_id_fkey FOREIGN KEY (ed_group_id) REFERENCES public.ed_groups(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_generics drug_generics_sale_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_generics
    ADD CONSTRAINT drug_generics_sale_unit_id_fkey FOREIGN KEY (sale_unit_id) REFERENCES public.drug_units(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_lots drug_lots_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_lots
    ADD CONSTRAINT drug_lots_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: drug_lots drug_lots_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_lots
    ADD CONSTRAINT drug_lots_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: drug_lots drug_lots_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_lots
    ADD CONSTRAINT drug_lots_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.receipts(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_pack_ratios drug_pack_ratios_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_pack_ratios
    ADD CONSTRAINT drug_pack_ratios_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: drug_pack_ratios drug_pack_ratios_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_pack_ratios
    ADD CONSTRAINT drug_pack_ratios_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_pack_ratios drug_pack_ratios_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_pack_ratios
    ADD CONSTRAINT drug_pack_ratios_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_return_items drug_return_items_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_return_items
    ADD CONSTRAINT drug_return_items_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: drug_return_items drug_return_items_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_return_items
    ADD CONSTRAINT drug_return_items_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_return_items drug_return_items_return_action_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_return_items
    ADD CONSTRAINT drug_return_items_return_action_id_fkey FOREIGN KEY (return_action_id) REFERENCES public.return_actions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drug_return_items drug_return_items_return_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_return_items
    ADD CONSTRAINT drug_return_items_return_id_fkey FOREIGN KEY (return_id) REFERENCES public.drug_returns(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: drug_returns drug_returns_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_returns
    ADD CONSTRAINT drug_returns_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: drug_returns drug_returns_return_reason_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drug_returns
    ADD CONSTRAINT drug_returns_return_reason_id_fkey FOREIGN KEY (return_reason_id) REFERENCES public.return_reasons(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drugs drugs_base_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_base_product_id_fkey FOREIGN KEY (base_product_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: drugs drugs_dosage_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_dosage_form_id_fkey FOREIGN KEY (dosage_form_id) REFERENCES public.dosage_forms(id) ON UPDATE CASCADE ON DELETE SET NULL;


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
-- Name: drugs drugs_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.drug_units(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: his_drug_master his_drug_master_tmt_concept_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.his_drug_master
    ADD CONSTRAINT his_drug_master_tmt_concept_id_fkey FOREIGN KEY (tmt_concept_id) REFERENCES public.tmt_concepts(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: his_drug_master his_drug_master_tmt_dosage_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.his_drug_master
    ADD CONSTRAINT his_drug_master_tmt_dosage_form_id_fkey FOREIGN KEY (tmt_dosage_form_id) REFERENCES public.tmt_dosage_forms(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: his_drug_master his_drug_master_tmt_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.his_drug_master
    ADD CONSTRAINT his_drug_master_tmt_manufacturer_id_fkey FOREIGN KEY (tmt_manufacturer_id) REFERENCES public.tmt_manufacturers(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hospital_pharmaceutical_products hospital_pharmaceutical_products_base_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hospital_pharmaceutical_products
    ADD CONSTRAINT hospital_pharmaceutical_products_base_product_id_fkey FOREIGN KEY (base_product_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hospital_pharmaceutical_products hospital_pharmaceutical_products_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hospital_pharmaceutical_products
    ADD CONSTRAINT hospital_pharmaceutical_products_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hospital_pharmaceutical_products hospital_pharmaceutical_products_generic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hospital_pharmaceutical_products
    ADD CONSTRAINT hospital_pharmaceutical_products_generic_id_fkey FOREIGN KEY (generic_id) REFERENCES public.drug_generics(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hospital_pharmaceutical_products hospital_pharmaceutical_products_tmt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hospital_pharmaceutical_products
    ADD CONSTRAINT hospital_pharmaceutical_products_tmt_id_fkey FOREIGN KEY (tmt_id) REFERENCES public.tmt_concepts(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: hpp_formulations hpp_formulations_hpp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.hpp_formulations
    ADD CONSTRAINT hpp_formulations_hpp_id_fkey FOREIGN KEY (hpp_id) REFERENCES public.hospital_pharmaceutical_products(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory inventory_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inventory inventory_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inventory_transactions inventory_transactions_adjustment_reason_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_adjustment_reason_id_fkey FOREIGN KEY (adjustment_reason_id) REFERENCES public.adjustment_reasons(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: inventory_transactions inventory_transactions_inventory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES public.inventory(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: locations locations_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.locations(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: payment_attachments payment_attachments_payment_doc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.payment_attachments
    ADD CONSTRAINT payment_attachments_payment_doc_id_fkey FOREIGN KEY (payment_doc_id) REFERENCES public.payment_documents(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_documents payment_documents_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.payment_documents
    ADD CONSTRAINT payment_documents_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: payment_documents payment_documents_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.payment_documents
    ADD CONSTRAINT payment_documents_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.receipts(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: purchase_order_items purchase_order_items_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: purchase_order_items purchase_order_items_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: purchase_orders purchase_orders_budget_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_budget_id_fkey FOREIGN KEY (budget_id) REFERENCES public.budgets(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: purchase_orders purchase_orders_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES public.contracts(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: purchase_orders purchase_orders_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: purchase_orders purchase_orders_purchase_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_purchase_method_id_fkey FOREIGN KEY (purchase_method_id) REFERENCES public.purchase_methods(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: purchase_orders purchase_orders_purchase_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_purchase_type_id_fkey FOREIGN KEY (purchase_type_id) REFERENCES public.purchase_types(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: purchase_orders purchase_orders_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.companies(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: purchase_request_items purchase_request_items_generic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_request_items
    ADD CONSTRAINT purchase_request_items_generic_id_fkey FOREIGN KEY (generic_id) REFERENCES public.drug_generics(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: purchase_request_items purchase_request_items_pr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_request_items
    ADD CONSTRAINT purchase_request_items_pr_id_fkey FOREIGN KEY (pr_id) REFERENCES public.purchase_requests(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: purchase_requests purchase_requests_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: purchase_requests purchase_requests_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: receipt_inspectors receipt_inspectors_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.receipt_inspectors
    ADD CONSTRAINT receipt_inspectors_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.receipts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: receipt_items receipt_items_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.receipt_items
    ADD CONSTRAINT receipt_items_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: receipt_items receipt_items_receipt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.receipt_items
    ADD CONSTRAINT receipt_items_receipt_id_fkey FOREIGN KEY (receipt_id) REFERENCES public.receipts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: receipts receipts_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tmt_attributes tmt_attributes_concept_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_attributes
    ADD CONSTRAINT tmt_attributes_concept_id_fkey FOREIGN KEY (concept_id) REFERENCES public.tmt_concepts(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tmt_mappings tmt_mappings_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_mappings
    ADD CONSTRAINT tmt_mappings_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.drugs(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: tmt_mappings tmt_mappings_generic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_mappings
    ADD CONSTRAINT tmt_mappings_generic_id_fkey FOREIGN KEY (generic_id) REFERENCES public.drug_generics(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: tmt_mappings tmt_mappings_tmt_concept_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_mappings
    ADD CONSTRAINT tmt_mappings_tmt_concept_id_fkey FOREIGN KEY (tmt_concept_id) REFERENCES public.tmt_concepts(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tmt_relationships tmt_relationships_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_relationships
    ADD CONSTRAINT tmt_relationships_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.tmt_concepts(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tmt_relationships tmt_relationships_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_relationships
    ADD CONSTRAINT tmt_relationships_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.tmt_concepts(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tmt_usage_stats tmt_usage_stats_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_usage_stats
    ADD CONSTRAINT tmt_usage_stats_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: tmt_usage_stats tmt_usage_stats_his_drug_master_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_usage_stats
    ADD CONSTRAINT tmt_usage_stats_his_drug_master_id_fkey FOREIGN KEY (his_drug_master_id) REFERENCES public.his_drug_master(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: tmt_usage_stats tmt_usage_stats_tmt_concept_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: invs_user
--

ALTER TABLE ONLY public.tmt_usage_stats
    ADD CONSTRAINT tmt_usage_stats_tmt_concept_id_fkey FOREIGN KEY (tmt_concept_id) REFERENCES public.tmt_concepts(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: invs_user
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict twYv23GCzbWyqs3mrsT8V69nshfnEgMgar8lKyvngQGA0qtB5X0EsJopBiPTALq

