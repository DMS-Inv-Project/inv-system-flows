-- AlterTable
ALTER TABLE "drug_distributions" ADD COLUMN     "distribution_type_id" BIGINT;

-- CreateTable
CREATE TABLE "distribution_types" (
    "id" BIGSERIAL NOT NULL,
    "code" INTEGER NOT NULL,
    "name" VARCHAR(60) NOT NULL,
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "distribution_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_order_reasons" (
    "id" BIGSERIAL NOT NULL,
    "code" INTEGER NOT NULL,
    "reason" VARCHAR(60) NOT NULL,
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "purchase_order_reasons_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "distribution_types_code_key" ON "distribution_types"("code");

-- CreateIndex
CREATE UNIQUE INDEX "purchase_order_reasons_code_key" ON "purchase_order_reasons"("code");

-- AddForeignKey
ALTER TABLE "drug_distributions" ADD CONSTRAINT "drug_distributions_distribution_type_id_fkey" FOREIGN KEY ("distribution_type_id") REFERENCES "distribution_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;
