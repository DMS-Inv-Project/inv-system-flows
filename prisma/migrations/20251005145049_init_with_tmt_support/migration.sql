-- CreateEnum
CREATE TYPE "LocationType" AS ENUM ('warehouse', 'pharmacy', 'ward', 'emergency', 'laboratory', 'operating_room');

-- CreateEnum
CREATE TYPE "CompanyType" AS ENUM ('vendor', 'manufacturer', 'both');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('receive', 'issue', 'transfer', 'adjust', 'return');

-- CreateEnum
CREATE TYPE "BudgetStatus" AS ENUM ('active', 'inactive', 'locked');

-- CreateEnum
CREATE TYPE "ReservationStatus" AS ENUM ('active', 'released', 'committed');

-- CreateEnum
CREATE TYPE "Urgency" AS ENUM ('urgent', 'normal', 'low');

-- CreateEnum
CREATE TYPE "RequestStatus" AS ENUM ('draft', 'submitted', 'approved', 'rejected', 'converted');

-- CreateEnum
CREATE TYPE "ItemStatus" AS ENUM ('pending', 'approved', 'rejected');

-- CreateEnum
CREATE TYPE "PoStatus" AS ENUM ('draft', 'pending', 'approved', 'sent', 'received', 'closed');

-- CreateEnum
CREATE TYPE "ReceiptStatus" AS ENUM ('draft', 'received', 'verified', 'posted');

-- CreateEnum
CREATE TYPE "TmtLevel" AS ENUM ('SUBS', 'VTM', 'GP', 'TP', 'GPU', 'TPU', 'GPP', 'TPP', 'GP-F', 'GP-X');

-- CreateEnum
CREATE TYPE "HppType" AS ENUM ('R', 'M', 'F', 'X', 'OHPP');

-- CreateEnum
CREATE TYPE "TmtRelationType" AS ENUM ('IS_A', 'HAS_ACTIVE_INGREDIENT', 'HAS_DOSE_FORM', 'HAS_MANUFACTURER', 'HAS_PACK_SIZE', 'HAS_STRENGTH', 'HAS_UNIT_OF_USE');

-- CreateTable
CREATE TABLE "locations" (
    "id" BIGSERIAL NOT NULL,
    "location_code" VARCHAR(10) NOT NULL,
    "location_name" VARCHAR(100) NOT NULL,
    "location_type" "LocationType" NOT NULL DEFAULT 'warehouse',
    "parent_id" BIGINT,
    "address" TEXT,
    "responsible_person" VARCHAR(50),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "departments" (
    "id" BIGSERIAL NOT NULL,
    "dept_code" VARCHAR(10) NOT NULL,
    "dept_name" VARCHAR(100) NOT NULL,
    "parent_id" BIGINT,
    "head_person" VARCHAR(50),
    "budget_code" VARCHAR(10),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "departments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "budget_types" (
    "id" BIGSERIAL NOT NULL,
    "budget_code" VARCHAR(10) NOT NULL,
    "budget_name" VARCHAR(100) NOT NULL,
    "budget_description" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "budget_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "companies" (
    "id" BIGSERIAL NOT NULL,
    "company_code" VARCHAR(10),
    "company_name" VARCHAR(100) NOT NULL,
    "company_type" "CompanyType" NOT NULL DEFAULT 'vendor',
    "tax_id" VARCHAR(20),
    "address" TEXT,
    "phone" VARCHAR(20),
    "email" VARCHAR(100),
    "contact_person" VARCHAR(50),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tmt_manufacturer_code" VARCHAR(20),
    "fda_license_number" VARCHAR(20),
    "gmp_certificate" VARCHAR(30),

    CONSTRAINT "companies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "drug_generics" (
    "id" BIGSERIAL NOT NULL,
    "working_code" VARCHAR(7) NOT NULL,
    "drug_name" VARCHAR(60) NOT NULL,
    "dosage_form" VARCHAR(20) NOT NULL,
    "sale_unit" VARCHAR(5) NOT NULL,
    "composition" VARCHAR(50),
    "strength" DECIMAL(10,2),
    "strength_unit" VARCHAR(20),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tmt_vtm_code" VARCHAR(10),
    "tmt_vtm_id" BIGINT,
    "tmt_gp_code" VARCHAR(10),
    "tmt_gp_id" BIGINT,
    "tmt_gpf_code" VARCHAR(10),
    "tmt_gpf_id" BIGINT,
    "tmt_gpx_code" VARCHAR(10),
    "tmt_gpx_id" BIGINT,
    "tmt_code" VARCHAR(10),
    "standard_unit" VARCHAR(10),
    "therapeutic_group" VARCHAR(50),

    CONSTRAINT "drug_generics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "drugs" (
    "id" BIGSERIAL NOT NULL,
    "drug_code" VARCHAR(24) NOT NULL,
    "trade_name" VARCHAR(100) NOT NULL,
    "generic_id" BIGINT,
    "strength" VARCHAR(50),
    "dosage_form" VARCHAR(30),
    "manufacturer_id" BIGINT,
    "atc_code" VARCHAR(10),
    "standard_code" VARCHAR(24),
    "barcode" VARCHAR(20),
    "pack_size" INTEGER NOT NULL DEFAULT 1,
    "unit" VARCHAR(10) NOT NULL DEFAULT 'TAB',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tmt_tp_code" VARCHAR(10),
    "tmt_tp_id" BIGINT,
    "tmt_tpu_code" VARCHAR(10),
    "tmt_tpu_id" BIGINT,
    "tmt_tpp_code" VARCHAR(10),
    "tmt_tpp_id" BIGINT,
    "nc24_code" VARCHAR(24),
    "registration_number" VARCHAR(20),
    "gpo_code" VARCHAR(15),
    "hpp_type" "HppType",
    "spec_prep" VARCHAR(10),
    "is_hpp" BOOLEAN NOT NULL DEFAULT false,
    "base_product_id" BIGINT,
    "formula_reference" TEXT,

    CONSTRAINT "drugs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventory" (
    "id" BIGSERIAL NOT NULL,
    "drug_id" BIGINT NOT NULL,
    "location_id" BIGINT NOT NULL,
    "quantity_on_hand" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "min_level" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "max_level" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "reorder_point" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "average_cost" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "last_cost" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "last_updated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "inventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "drug_lots" (
    "id" BIGSERIAL NOT NULL,
    "drug_id" BIGINT NOT NULL,
    "location_id" BIGINT NOT NULL,
    "lot_number" VARCHAR(20) NOT NULL,
    "expiry_date" DATE NOT NULL,
    "quantity_available" DECIMAL(10,2) NOT NULL,
    "unit_cost" DECIMAL(10,2) NOT NULL,
    "received_date" DATE NOT NULL,
    "receipt_id" BIGINT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "drug_lots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventory_transactions" (
    "id" BIGSERIAL NOT NULL,
    "inventory_id" BIGINT NOT NULL,
    "transaction_type" "TransactionType" NOT NULL,
    "quantity" DECIMAL(10,2) NOT NULL,
    "unit_cost" DECIMAL(10,2),
    "reference_id" BIGINT,
    "reference_type" VARCHAR(20),
    "notes" TEXT,
    "created_by" BIGINT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "inventory_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "budget_allocations" (
    "id" BIGSERIAL NOT NULL,
    "fiscal_year" INTEGER NOT NULL,
    "budget_type_id" BIGINT NOT NULL,
    "department_id" BIGINT NOT NULL,
    "total_budget" DECIMAL(15,2) NOT NULL,
    "q1_budget" DECIMAL(15,2) NOT NULL,
    "q2_budget" DECIMAL(15,2) NOT NULL,
    "q3_budget" DECIMAL(15,2) NOT NULL,
    "q4_budget" DECIMAL(15,2) NOT NULL,
    "total_spent" DECIMAL(15,2) NOT NULL DEFAULT 0,
    "q1_spent" DECIMAL(15,2) NOT NULL DEFAULT 0,
    "q2_spent" DECIMAL(15,2) NOT NULL DEFAULT 0,
    "q3_spent" DECIMAL(15,2) NOT NULL DEFAULT 0,
    "q4_spent" DECIMAL(15,2) NOT NULL DEFAULT 0,
    "remaining_budget" DECIMAL(15,2) NOT NULL,
    "status" "BudgetStatus" NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "budget_allocations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "budget_reservations" (
    "id" BIGSERIAL NOT NULL,
    "allocation_id" BIGINT NOT NULL,
    "pr_id" BIGINT,
    "po_id" BIGINT,
    "reserved_amount" DECIMAL(15,2) NOT NULL,
    "reservation_date" DATE NOT NULL,
    "status" "ReservationStatus" NOT NULL DEFAULT 'active',
    "expires_date" DATE,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "budget_reservations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_requests" (
    "id" BIGSERIAL NOT NULL,
    "pr_number" VARCHAR(20) NOT NULL,
    "pr_date" DATE NOT NULL,
    "department_id" BIGINT NOT NULL,
    "budget_allocation_id" BIGINT,
    "requested_amount" DECIMAL(15,2) NOT NULL,
    "purpose" TEXT,
    "urgency" "Urgency" NOT NULL DEFAULT 'normal',
    "status" "RequestStatus" NOT NULL DEFAULT 'draft',
    "requested_by" VARCHAR(50) NOT NULL,
    "approved_by" VARCHAR(50),
    "approval_date" DATE,
    "converted_to_po" BOOLEAN NOT NULL DEFAULT false,
    "po_id" BIGINT,
    "remarks" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "purchase_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_request_items" (
    "id" BIGSERIAL NOT NULL,
    "pr_id" BIGINT NOT NULL,
    "item_number" INTEGER NOT NULL,
    "generic_id" BIGINT,
    "description" TEXT,
    "quantity_requested" DECIMAL(10,2) NOT NULL,
    "estimated_unit_cost" DECIMAL(10,2),
    "estimated_total_cost" DECIMAL(15,2),
    "justification" TEXT,
    "status" "ItemStatus" NOT NULL DEFAULT 'pending',

    CONSTRAINT "purchase_request_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_orders" (
    "id" BIGSERIAL NOT NULL,
    "po_number" VARCHAR(20) NOT NULL,
    "vendor_id" BIGINT NOT NULL,
    "po_date" DATE NOT NULL,
    "delivery_date" DATE,
    "department_id" BIGINT,
    "budget_type_id" BIGINT,
    "status" "PoStatus" NOT NULL DEFAULT 'draft',
    "total_amount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "total_items" INTEGER NOT NULL DEFAULT 0,
    "notes" TEXT,
    "created_by" BIGINT NOT NULL,
    "approved_by" BIGINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "purchase_orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_order_items" (
    "id" BIGSERIAL NOT NULL,
    "po_id" BIGINT NOT NULL,
    "drug_id" BIGINT NOT NULL,
    "quantity_ordered" DECIMAL(10,2) NOT NULL,
    "unit_cost" DECIMAL(10,2) NOT NULL,
    "quantity_received" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "notes" TEXT,

    CONSTRAINT "purchase_order_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "receipts" (
    "id" BIGSERIAL NOT NULL,
    "receipt_number" VARCHAR(20) NOT NULL,
    "po_id" BIGINT NOT NULL,
    "receipt_date" DATE NOT NULL,
    "delivery_note" VARCHAR(50),
    "status" "ReceiptStatus" NOT NULL DEFAULT 'draft',
    "total_items" INTEGER NOT NULL DEFAULT 0,
    "total_amount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "received_by" BIGINT NOT NULL,
    "verified_by" BIGINT,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "receipts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "receipt_items" (
    "id" BIGSERIAL NOT NULL,
    "receipt_id" BIGINT NOT NULL,
    "drug_id" BIGINT NOT NULL,
    "quantity_received" DECIMAL(10,2) NOT NULL,
    "unit_cost" DECIMAL(10,2) NOT NULL,
    "lot_number" VARCHAR(20),
    "expiry_date" DATE,
    "notes" TEXT,

    CONSTRAINT "receipt_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tmt_concepts" (
    "id" BIGSERIAL NOT NULL,
    "tmt_id" BIGINT NOT NULL,
    "concept_code" VARCHAR(20),
    "level" "TmtLevel" NOT NULL,
    "fsn" VARCHAR(500) NOT NULL,
    "preferred_term" VARCHAR(300),
    "strength" VARCHAR(100),
    "dosage_form" VARCHAR(50),
    "manufacturer" VARCHAR(100),
    "pack_size" VARCHAR(50),
    "unit_of_use" VARCHAR(20),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "effective_date" TIMESTAMP(3),
    "release_date" VARCHAR(20),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tmt_concepts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tmt_relationships" (
    "id" BIGSERIAL NOT NULL,
    "parent_id" BIGINT NOT NULL,
    "child_id" BIGINT NOT NULL,
    "relationship_type" "TmtRelationType" NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "effective_date" TIMESTAMP(3),
    "release_date" VARCHAR(20),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tmt_relationships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hospital_pharmaceutical_products" (
    "id" BIGSERIAL NOT NULL,
    "hpp_code" VARCHAR(20) NOT NULL,
    "hpp_type" "HppType" NOT NULL,
    "product_name" VARCHAR(200) NOT NULL,
    "generic_id" BIGINT,
    "drug_id" BIGINT,
    "base_product_id" BIGINT,
    "strength" VARCHAR(100),
    "dosage_form" VARCHAR(50),
    "pack_size" VARCHAR(50),
    "unit_of_use" VARCHAR(20),
    "formula_reference" TEXT,
    "formula_source" VARCHAR(100),
    "tmt_code" VARCHAR(10),
    "tmt_id" BIGINT,
    "spec_prep" VARCHAR(10),
    "is_outsourced" BOOLEAN NOT NULL DEFAULT false,
    "hospital_code" VARCHAR(10),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "approved_by" VARCHAR(50),
    "approval_date" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "hospital_pharmaceutical_products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tmt_mappings" (
    "id" BIGSERIAL NOT NULL,
    "working_code" VARCHAR(7),
    "drug_code" VARCHAR(24),
    "generic_id" BIGINT,
    "drug_id" BIGINT,
    "tmt_level" "TmtLevel" NOT NULL,
    "tmt_concept_id" BIGINT NOT NULL,
    "tmt_code" VARCHAR(10),
    "tmt_id" BIGINT NOT NULL,
    "mapping_source" VARCHAR(50),
    "confidence" DECIMAL(3,2),
    "mapped_by" VARCHAR(50),
    "verified_by" VARCHAR(50),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,
    "mapping_date" TIMESTAMP(3) NOT NULL,
    "verification_date" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tmt_mappings_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "locations_location_code_key" ON "locations"("location_code");

-- CreateIndex
CREATE UNIQUE INDEX "departments_dept_code_key" ON "departments"("dept_code");

-- CreateIndex
CREATE UNIQUE INDEX "budget_types_budget_code_key" ON "budget_types"("budget_code");

-- CreateIndex
CREATE UNIQUE INDEX "companies_company_code_key" ON "companies"("company_code");

-- CreateIndex
CREATE UNIQUE INDEX "drug_generics_working_code_key" ON "drug_generics"("working_code");

-- CreateIndex
CREATE UNIQUE INDEX "drugs_drug_code_key" ON "drugs"("drug_code");

-- CreateIndex
CREATE UNIQUE INDEX "inventory_drug_id_location_id_key" ON "inventory"("drug_id", "location_id");

-- CreateIndex
CREATE UNIQUE INDEX "budget_allocations_fiscal_year_budget_type_id_department_id_key" ON "budget_allocations"("fiscal_year", "budget_type_id", "department_id");

-- CreateIndex
CREATE UNIQUE INDEX "purchase_requests_pr_number_key" ON "purchase_requests"("pr_number");

-- CreateIndex
CREATE UNIQUE INDEX "purchase_orders_po_number_key" ON "purchase_orders"("po_number");

-- CreateIndex
CREATE UNIQUE INDEX "purchase_order_items_po_id_drug_id_key" ON "purchase_order_items"("po_id", "drug_id");

-- CreateIndex
CREATE UNIQUE INDEX "receipts_receipt_number_key" ON "receipts"("receipt_number");

-- CreateIndex
CREATE UNIQUE INDEX "tmt_concepts_tmt_id_key" ON "tmt_concepts"("tmt_id");

-- CreateIndex
CREATE UNIQUE INDEX "tmt_relationships_parent_id_child_id_relationship_type_key" ON "tmt_relationships"("parent_id", "child_id", "relationship_type");

-- CreateIndex
CREATE UNIQUE INDEX "hospital_pharmaceutical_products_hpp_code_key" ON "hospital_pharmaceutical_products"("hpp_code");

-- AddForeignKey
ALTER TABLE "locations" ADD CONSTRAINT "locations_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drugs" ADD CONSTRAINT "drugs_generic_id_fkey" FOREIGN KEY ("generic_id") REFERENCES "drug_generics"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drugs" ADD CONSTRAINT "drugs_manufacturer_id_fkey" FOREIGN KEY ("manufacturer_id") REFERENCES "companies"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drugs" ADD CONSTRAINT "drugs_base_product_id_fkey" FOREIGN KEY ("base_product_id") REFERENCES "drugs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory" ADD CONSTRAINT "inventory_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory" ADD CONSTRAINT "inventory_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "locations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_lots" ADD CONSTRAINT "drug_lots_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_lots" ADD CONSTRAINT "drug_lots_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "locations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_lots" ADD CONSTRAINT "drug_lots_receipt_id_fkey" FOREIGN KEY ("receipt_id") REFERENCES "receipts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_transactions" ADD CONSTRAINT "inventory_transactions_inventory_id_fkey" FOREIGN KEY ("inventory_id") REFERENCES "inventory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_allocations" ADD CONSTRAINT "budget_allocations_budget_type_id_fkey" FOREIGN KEY ("budget_type_id") REFERENCES "budget_types"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_allocations" ADD CONSTRAINT "budget_allocations_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_reservations" ADD CONSTRAINT "budget_reservations_allocation_id_fkey" FOREIGN KEY ("allocation_id") REFERENCES "budget_allocations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_reservations" ADD CONSTRAINT "budget_reservations_pr_id_fkey" FOREIGN KEY ("pr_id") REFERENCES "purchase_requests"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "budget_reservations" ADD CONSTRAINT "budget_reservations_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "purchase_orders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_requests" ADD CONSTRAINT "purchase_requests_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_requests" ADD CONSTRAINT "purchase_requests_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "purchase_orders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_request_items" ADD CONSTRAINT "purchase_request_items_pr_id_fkey" FOREIGN KEY ("pr_id") REFERENCES "purchase_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_request_items" ADD CONSTRAINT "purchase_request_items_generic_id_fkey" FOREIGN KEY ("generic_id") REFERENCES "drug_generics"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_budget_type_id_fkey" FOREIGN KEY ("budget_type_id") REFERENCES "budget_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_order_items" ADD CONSTRAINT "purchase_order_items_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "purchase_orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_order_items" ADD CONSTRAINT "purchase_order_items_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "receipts" ADD CONSTRAINT "receipts_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "purchase_orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "receipt_items" ADD CONSTRAINT "receipt_items_receipt_id_fkey" FOREIGN KEY ("receipt_id") REFERENCES "receipts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "receipt_items" ADD CONSTRAINT "receipt_items_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tmt_relationships" ADD CONSTRAINT "tmt_relationships_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "tmt_concepts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tmt_relationships" ADD CONSTRAINT "tmt_relationships_child_id_fkey" FOREIGN KEY ("child_id") REFERENCES "tmt_concepts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hospital_pharmaceutical_products" ADD CONSTRAINT "hospital_pharmaceutical_products_generic_id_fkey" FOREIGN KEY ("generic_id") REFERENCES "drug_generics"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hospital_pharmaceutical_products" ADD CONSTRAINT "hospital_pharmaceutical_products_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hospital_pharmaceutical_products" ADD CONSTRAINT "hospital_pharmaceutical_products_base_product_id_fkey" FOREIGN KEY ("base_product_id") REFERENCES "drugs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tmt_mappings" ADD CONSTRAINT "tmt_mappings_generic_id_fkey" FOREIGN KEY ("generic_id") REFERENCES "drug_generics"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tmt_mappings" ADD CONSTRAINT "tmt_mappings_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tmt_mappings" ADD CONSTRAINT "tmt_mappings_tmt_concept_id_fkey" FOREIGN KEY ("tmt_concept_id") REFERENCES "tmt_concepts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
