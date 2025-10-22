/*
  Warnings:

  - You are about to drop the column `return_reason` on the `drug_returns` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "drug_returns" DROP COLUMN "return_reason",
ADD COLUMN     "return_reason_id" BIGINT,
ADD COLUMN     "return_reason_text" VARCHAR(100);

-- AlterTable
ALTER TABLE "purchase_orders" ADD COLUMN     "purchase_method_id" BIGINT,
ADD COLUMN     "purchase_type_id" BIGINT;

-- CreateTable
CREATE TABLE "purchase_methods" (
    "id" BIGSERIAL NOT NULL,
    "code" INTEGER NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "min_amount" DECIMAL(12,2),
    "max_amount" DECIMAL(12,2),
    "deal_days" INTEGER,
    "authority_signer" VARCHAR(30),
    "std_code" VARCHAR(6),
    "report_forms" VARCHAR(60),
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "purchase_methods_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_types" (
    "id" BIGSERIAL NOT NULL,
    "code" INTEGER NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "authority_signer" VARCHAR(30),
    "std_code" VARCHAR(6),
    "deal_days" INTEGER,
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "purchase_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "drug_pack_ratios" (
    "id" BIGSERIAL NOT NULL,
    "drug_id" BIGINT NOT NULL,
    "vendor_id" BIGINT,
    "manufacturer_id" BIGINT,
    "pack_ratio" DECIMAL(10,2) NOT NULL DEFAULT 1,
    "buy_unit_cost" DECIMAL(10,2),
    "sale_unit_price" DECIMAL(10,2),
    "pack_unit_id" INTEGER,
    "subpack_unit_id" INTEGER,
    "barcode" VARCHAR(14),
    "last_purchase_date" DATE,
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "pack_code" VARCHAR(18),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "drug_pack_ratios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "return_reasons" (
    "id" BIGSERIAL NOT NULL,
    "code" INTEGER NOT NULL,
    "reason" VARCHAR(100) NOT NULL,
    "category" VARCHAR(30),
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "return_reasons_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "purchase_methods_code_key" ON "purchase_methods"("code");

-- CreateIndex
CREATE UNIQUE INDEX "purchase_types_code_key" ON "purchase_types"("code");

-- CreateIndex
CREATE INDEX "drug_pack_ratios_drug_id_idx" ON "drug_pack_ratios"("drug_id");

-- CreateIndex
CREATE INDEX "drug_pack_ratios_vendor_id_idx" ON "drug_pack_ratios"("vendor_id");

-- CreateIndex
CREATE UNIQUE INDEX "return_reasons_code_key" ON "return_reasons"("code");

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_purchase_method_id_fkey" FOREIGN KEY ("purchase_method_id") REFERENCES "purchase_methods"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_orders" ADD CONSTRAINT "purchase_orders_purchase_type_id_fkey" FOREIGN KEY ("purchase_type_id") REFERENCES "purchase_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_returns" ADD CONSTRAINT "drug_returns_return_reason_id_fkey" FOREIGN KEY ("return_reason_id") REFERENCES "return_reasons"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_pack_ratios" ADD CONSTRAINT "drug_pack_ratios_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_pack_ratios" ADD CONSTRAINT "drug_pack_ratios_vendor_id_fkey" FOREIGN KEY ("vendor_id") REFERENCES "companies"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_pack_ratios" ADD CONSTRAINT "drug_pack_ratios_manufacturer_id_fkey" FOREIGN KEY ("manufacturer_id") REFERENCES "companies"("id") ON DELETE SET NULL ON UPDATE CASCADE;
