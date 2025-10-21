-- CreateEnum
CREATE TYPE "ContractType" AS ENUM ('e_bidding', 'price_agreement', 'quotation', 'special');

-- CreateEnum
CREATE TYPE "ContractStatus" AS ENUM ('draft', 'active', 'expired', 'cancelled');

-- CreateEnum
CREATE TYPE "InspectorRole" AS ENUM ('chairman', 'member', 'secretary');

-- CreateEnum
CREATE TYPE "ApprovalType" AS ENUM ('normal', 'urgent', 'special');

-- CreateEnum
CREATE TYPE "ApprovalStatus" AS ENUM ('pending', 'approved', 'rejected', 'cancelled');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('pending', 'submitted', 'approved', 'paid', 'cancelled');

-- CreateEnum
CREATE TYPE "AttachmentType" AS ENUM ('purchase_order', 'receipt', 'invoice', 'inspection_report', 'delivery_note', 'other');

-- AlterEnum
ALTER TYPE "ReceiptStatus" ADD VALUE 'pending_verification';

-- AlterTable
ALTER TABLE "purchase_orders" ADD COLUMN     "confirmed_by" BIGINT,
ADD COLUMN     "confirmed_date" DATE,
ADD COLUMN     "contract_id" BIGINT,
ADD COLUMN     "printed_date" DATE,
ADD COLUMN     "sent_to_vendor_date" DATE;

-- AlterTable
ALTER TABLE "receipts" ADD COLUMN     "invoice_date" DATE,
ADD COLUMN     "invoice_number" VARCHAR(50),
ADD COLUMN     "posted_date" DATE,
ADD COLUMN     "received_date" DATE,
ADD COLUMN     "verified_date" DATE;

-- CreateTable
CREATE TABLE "contracts" (
    "id" BIGSERIAL NOT NULL,
    "contract_number" VARCHAR(20) NOT NULL,
    "contract_type" "ContractType" NOT NULL,
    "vendor_id" BIGINT NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "total_value" DECIMAL(15,2) NOT NULL,
    "remaining_value" DECIMAL(15,2) NOT NULL,
    "fiscal_year" VARCHAR(4) NOT NULL,
    "status" "ContractStatus" NOT NULL DEFAULT 'active',
    "contract_document" VARCHAR(255),
    "approved_by" VARCHAR(50),
    "approval_date" DATE,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "contracts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contract_items" (
    "id" BIGSERIAL NOT NULL,
    "contract_id" BIGINT NOT NULL,
    "drug_id" BIGINT NOT NULL,
    "unit_price" DECIMAL(10,2) NOT NULL,
    "quantity_contracted" DECIMAL(10,2) NOT NULL,
    "quantity_remaining" DECIMAL(10,2) NOT NULL,
    "min_order_quantity" DECIMAL(10,2),
    "max_order_quantity" DECIMAL(10,2),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "contract_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "receipt_inspectors" (
    "id" BIGSERIAL NOT NULL,
    "receipt_id" BIGINT NOT NULL,
    "inspector_name" VARCHAR(100) NOT NULL,
    "inspector_position" VARCHAR(100),
    "inspector_role" "InspectorRole" NOT NULL,
    "signed_date" DATE,
    "signature_path" VARCHAR(255),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "receipt_inspectors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "approval_documents" (
    "id" BIGSERIAL NOT NULL,
    "approval_doc_number" VARCHAR(20) NOT NULL,
    "po_id" BIGINT NOT NULL,
    "approval_type" "ApprovalType" NOT NULL DEFAULT 'normal',
    "requested_by" VARCHAR(50) NOT NULL,
    "requested_date" DATE NOT NULL,
    "approved_by" VARCHAR(50),
    "approval_date" DATE,
    "rejected_by" VARCHAR(50),
    "rejected_date" DATE,
    "rejection_reason" TEXT,
    "status" "ApprovalStatus" NOT NULL DEFAULT 'pending',
    "document_path" VARCHAR(255),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "approval_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_documents" (
    "id" BIGSERIAL NOT NULL,
    "payment_doc_number" VARCHAR(20) NOT NULL,
    "receipt_id" BIGINT NOT NULL,
    "po_id" BIGINT NOT NULL,
    "submitted_to_finance_by" VARCHAR(50),
    "submitted_to_finance_date" DATE,
    "approved_by_finance" VARCHAR(50),
    "approved_by_finance_date" DATE,
    "paid_date" DATE,
    "paid_amount" DECIMAL(15,2),
    "payment_method" VARCHAR(50),
    "reference_number" VARCHAR(50),
    "payment_status" "PaymentStatus" NOT NULL DEFAULT 'pending',
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_attachments" (
    "id" BIGSERIAL NOT NULL,
    "payment_doc_id" BIGINT NOT NULL,
    "attachment_type" "AttachmentType" NOT NULL,
    "file_name" VARCHAR(255) NOT NULL,
    "file_path" VARCHAR(500) NOT NULL,
    "file_size" INTEGER,
    "uploaded_by" VARCHAR(50) NOT NULL,
    "uploaded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT,

    CONSTRAINT "payment_attachments_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "contracts_contract_number_key" ON "contracts"("contract_number");

-- CreateIndex
CREATE UNIQUE INDEX "contract_items_contract_id_drug_id_key" ON "contract_items"("contract_id", "drug_id");

-- CreateIndex
CREATE UNIQUE INDEX "approval_documents_approval_doc_number_key" ON "approval_documents"("approval_doc_number");

-- CreateIndex
CREATE UNIQUE INDEX "payment_documents_payment_doc_number_key" ON "payment_documents"("payment_doc_number");

-- AddForeignKey
ALTER TABLE "contracts" ADD CONSTRAINT "contracts_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "companies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contract_items" ADD CONSTRAINT "contract_items_contract_id_fkey" FOREIGN KEY ("contract_id") REFERENCES "contracts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contract_items" ADD CONSTRAINT "contract_items_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_contract_id_fkey" FOREIGN KEY ("contract_id") REFERENCES "contracts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "receipt_inspectors" ADD CONSTRAINT "receipt_inspectors_receipt_id_fkey" FOREIGN KEY ("receipt_id") REFERENCES "receipts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "approval_documents" ADD CONSTRAINT "approval_documents_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "purchase_orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_documents" ADD CONSTRAINT "payment_documents_receipt_id_fkey" FOREIGN KEY ("receipt_id") REFERENCES "receipts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_documents" ADD CONSTRAINT "payment_documents_po_id_fkey" FOREIGN KEY ("po_id") REFERENCES "purchase_orders"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_attachments" ADD CONSTRAINT "payment_attachments_payment_doc_id_fkey" FOREIGN KEY ("payment_doc_id") REFERENCES "payment_documents"("id") ON DELETE CASCADE ON UPDATE CASCADE;
