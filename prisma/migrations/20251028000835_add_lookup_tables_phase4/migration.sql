-- AlterTable
ALTER TABLE "drug_generics" ADD COLUMN     "dosage_form_id" BIGINT,
ADD COLUMN     "sale_unit_id" BIGINT,
ALTER COLUMN "dosage_form" DROP NOT NULL,
ALTER COLUMN "sale_unit" DROP NOT NULL;

-- AlterTable
ALTER TABLE "drug_return_items" ADD COLUMN     "return_action_id" BIGINT;

-- AlterTable
ALTER TABLE "drugs" ADD COLUMN     "dosage_form_id" BIGINT,
ADD COLUMN     "unit_id" BIGINT,
ALTER COLUMN "unit" DROP NOT NULL,
ALTER COLUMN "unit" DROP DEFAULT;

-- AlterTable
ALTER TABLE "inventory_transactions" ADD COLUMN     "adjustment_reason_id" BIGINT;

-- CreateTable
CREATE TABLE "dosage_forms" (
    "id" BIGSERIAL NOT NULL,
    "code" VARCHAR(10) NOT NULL,
    "name" VARCHAR(60) NOT NULL,
    "name_en" VARCHAR(60),
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "dosage_forms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "drug_units" (
    "id" BIGSERIAL NOT NULL,
    "code" VARCHAR(10) NOT NULL,
    "name" VARCHAR(60) NOT NULL,
    "name_en" VARCHAR(60),
    "standard_code" VARCHAR(15),
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "drug_units_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "adjustment_reasons" (
    "id" BIGSERIAL NOT NULL,
    "code" INTEGER NOT NULL,
    "reason" VARCHAR(100) NOT NULL,
    "category" VARCHAR(30),
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "adjustment_reasons_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hospitals" (
    "id" BIGSERIAL NOT NULL,
    "hosp_code" VARCHAR(5) NOT NULL,
    "hosp_name" VARCHAR(100) NOT NULL,
    "hosp_type" VARCHAR(20),
    "province_code" VARCHAR(2),
    "area_code" VARCHAR(4),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "hospitals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "return_actions" (
    "id" BIGSERIAL NOT NULL,
    "code" INTEGER NOT NULL,
    "action" VARCHAR(60) NOT NULL,
    "action_type" VARCHAR(30),
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "return_actions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "dosage_forms_code_key" ON "dosage_forms"("code");

-- CreateIndex
CREATE UNIQUE INDEX "drug_units_code_key" ON "drug_units"("code");

-- CreateIndex
CREATE UNIQUE INDEX "adjustment_reasons_code_key" ON "adjustment_reasons"("code");

-- CreateIndex
CREATE UNIQUE INDEX "hospitals_hosp_code_key" ON "hospitals"("hosp_code");

-- CreateIndex
CREATE INDEX "hospitals_province_code_idx" ON "hospitals"("province_code");

-- CreateIndex
CREATE INDEX "hospitals_area_code_idx" ON "hospitals"("area_code");

-- CreateIndex
CREATE UNIQUE INDEX "return_actions_code_key" ON "return_actions"("code");

-- AddForeignKey
ALTER TABLE "drug_generics" ADD CONSTRAINT "drug_generics_dosage_form_id_fkey" FOREIGN KEY ("dosage_form_id") REFERENCES "dosage_forms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_generics" ADD CONSTRAINT "drug_generics_sale_unit_id_fkey" FOREIGN KEY ("sale_unit_id") REFERENCES "drug_units"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drugs" ADD CONSTRAINT "drugs_dosage_form_id_fkey" FOREIGN KEY ("dosage_form_id") REFERENCES "dosage_forms"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drugs" ADD CONSTRAINT "drugs_unit_id_fkey" FOREIGN KEY ("unit_id") REFERENCES "drug_units"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory_transactions" ADD CONSTRAINT "inventory_transactions_adjustment_reason_id_fkey" FOREIGN KEY ("adjustment_reason_id") REFERENCES "adjustment_reasons"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_return_items" ADD CONSTRAINT "drug_return_items_return_action_id_fkey" FOREIGN KEY ("return_action_id") REFERENCES "return_actions"("id") ON DELETE SET NULL ON UPDATE CASCADE;
