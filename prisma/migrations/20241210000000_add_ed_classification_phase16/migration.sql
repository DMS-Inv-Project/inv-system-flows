-- Phase 16: ED Classification Migration
-- Add ED Group table and ED classification fields to DrugGeneric
-- Source: คู่มือ INVS หน้า 12 (บัญชี ED)

-- 1. Create EdCategory enum
CREATE TYPE "EdCategory" AS ENUM ('ED', 'NED', 'NDMS', 'CM', 'LS', 'PS');

-- 2. Create ed_groups table (209 therapeutic classes from MySQL ed_group)
CREATE TABLE "ed_groups" (
    "id" BIGSERIAL NOT NULL,
    "code" VARCHAR(8) NOT NULL,
    "name" VARCHAR(60) NOT NULL,
    "sub_commit_code" INTEGER,
    "forecast" DOUBLE PRECISION,
    "is_hidden" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ed_groups_pkey" PRIMARY KEY ("id")
);

-- 3. Add unique constraint on code
CREATE UNIQUE INDEX "ed_groups_code_key" ON "ed_groups"("code");

-- 4. Add ED classification fields to drug_generics
ALTER TABLE "drug_generics" ADD COLUMN "ed_category" "EdCategory";
ALTER TABLE "drug_generics" ADD COLUMN "ed_list" INTEGER;
ALTER TABLE "drug_generics" ADD COLUMN "ed_group_id" BIGINT;

-- 5. Add foreign key constraint
ALTER TABLE "drug_generics" ADD CONSTRAINT "drug_generics_ed_group_id_fkey"
    FOREIGN KEY ("ed_group_id") REFERENCES "ed_groups"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Comments for documentation
COMMENT ON TYPE "EdCategory" IS 'ประเภทบัญชี ED จากคู่มือหน้า 12: ED=บัญชียาED, NED=บัญชียาNED, NDMS=เวชภัณฑ์มิใช่ยา, CM=สารเคมี, LS=วัสดุห้องปฏิบัติการ, PS=วัสดุเภสัชกรรม';
COMMENT ON TABLE "ed_groups" IS 'กลุ่มการรักษา/Therapeutic Classification จาก MySQL ed_group (209 records)';
COMMENT ON COLUMN "drug_generics"."ed_category" IS 'ประเภทบัญชี ED (ED/NED/NDMS/CM/LS/PS)';
COMMENT ON COLUMN "drug_generics"."ed_list" IS 'บัญชีย่อย ED 1-6 (NULL/-1/0 = ไม่ระบุ)';
COMMENT ON COLUMN "drug_generics"."ed_group_id" IS 'FK to ed_groups (therapeutic class)';
