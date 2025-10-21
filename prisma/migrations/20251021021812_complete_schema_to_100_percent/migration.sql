-- CreateEnum
CREATE TYPE "ReturnStatus" AS ENUM ('draft', 'submitted', 'verified', 'posted', 'cancelled');

-- CreateEnum
CREATE TYPE "ReturnType" AS ENUM ('purchased', 'free');

-- CreateEnum
CREATE TYPE "PurchaseItemType" AS ENUM ('normal', 'urgent', 'replacement', 'emergency');

-- AlterTable
ALTER TABLE "contracts" ADD COLUMN     "committee_date" DATE,
ADD COLUMN     "committee_name" VARCHAR(60),
ADD COLUMN     "committee_number" VARCHAR(20),
ADD COLUMN     "egp_number" VARCHAR(30),
ADD COLUMN     "gf_number" VARCHAR(10),
ADD COLUMN     "project_number" VARCHAR(30);

-- AlterTable
ALTER TABLE "purchase_orders" ADD COLUMN     "egp_number" VARCHAR(30),
ADD COLUMN     "gf_number" VARCHAR(10),
ADD COLUMN     "project_number" VARCHAR(30);

-- AlterTable
ALTER TABLE "receipt_items" ADD COLUMN     "item_type" "PurchaseItemType";

-- AlterTable
ALTER TABLE "receipts" ADD COLUMN     "receive_time" VARCHAR(5);

-- CreateTable
CREATE TABLE "drug_returns" (
    "id" BIGSERIAL NOT NULL,
    "return_number" VARCHAR(20) NOT NULL,
    "department_id" BIGINT NOT NULL,
    "return_date" DATE NOT NULL,
    "return_reason" VARCHAR(100) NOT NULL,
    "action_taken" VARCHAR(100),
    "reference_number" VARCHAR(50),
    "status" "ReturnStatus" NOT NULL DEFAULT 'draft',
    "total_items" INTEGER NOT NULL DEFAULT 0,
    "total_amount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "received_by" VARCHAR(50) NOT NULL,
    "verified_by" VARCHAR(50),
    "verified_date" DATE,
    "posted_date" DATE,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "drug_returns_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "drug_return_items" (
    "id" BIGSERIAL NOT NULL,
    "return_id" BIGINT NOT NULL,
    "drug_id" BIGINT NOT NULL,
    "total_quantity" DECIMAL(10,2) NOT NULL,
    "good_quantity" DECIMAL(10,2) NOT NULL,
    "damaged_quantity" DECIMAL(10,2) NOT NULL,
    "lot_number" VARCHAR(20) NOT NULL,
    "expiry_date" DATE NOT NULL,
    "return_type" "ReturnType" NOT NULL,
    "location_id" BIGINT,
    "unit_cost" DECIMAL(10,2),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "drug_return_items_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "drug_returns_return_number_key" ON "drug_returns"("return_number");

-- AddForeignKey
ALTER TABLE "drug_returns" ADD CONSTRAINT "drug_returns_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_return_items" ADD CONSTRAINT "drug_return_items_return_id_fkey" FOREIGN KEY ("return_id") REFERENCES "drug_returns"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_return_items" ADD CONSTRAINT "drug_return_items_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_return_items" ADD CONSTRAINT "drug_return_items_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;
