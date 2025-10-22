-- CreateTable
CREATE TABLE "drug_components" (
    "id" BIGSERIAL NOT NULL,
    "generic_id" BIGINT NOT NULL,
    "component_name" VARCHAR(100) NOT NULL,
    "strength" VARCHAR(50),
    "strength_unit" VARCHAR(20),
    "tmt_concept_id" BIGINT,
    "sequence" INTEGER,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "drug_components_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "drug_focus_lists" (
    "id" BIGSERIAL NOT NULL,
    "drug_id" BIGINT NOT NULL,
    "list_type" INTEGER,
    "list_name" VARCHAR(50) NOT NULL,
    "department_id" BIGINT,
    "created_by" VARCHAR(32),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "drug_focus_lists_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "drug_components_generic_id_idx" ON "drug_components"("generic_id");

-- CreateIndex
CREATE INDEX "drug_components_tmt_concept_id_idx" ON "drug_components"("tmt_concept_id");

-- CreateIndex
CREATE INDEX "drug_focus_lists_drug_id_idx" ON "drug_focus_lists"("drug_id");

-- CreateIndex
CREATE INDEX "drug_focus_lists_list_type_idx" ON "drug_focus_lists"("list_type");

-- AddForeignKey
ALTER TABLE "drug_components" ADD CONSTRAINT "drug_components_generic_id_fkey" FOREIGN KEY ("generic_id") REFERENCES "drug_generics"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_components" ADD CONSTRAINT "drug_components_tmt_concept_id_fkey" FOREIGN KEY ("tmt_concept_id") REFERENCES "tmt_concepts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_focus_lists" ADD CONSTRAINT "drug_focus_lists_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drug_focus_lists" ADD CONSTRAINT "drug_focus_lists_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE CASCADE;
