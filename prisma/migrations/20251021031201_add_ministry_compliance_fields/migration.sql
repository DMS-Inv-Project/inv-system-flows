-- CreateEnum
CREATE TYPE "NlemStatus" AS ENUM ('E', 'N');

-- CreateEnum
CREATE TYPE "DrugStatus" AS ENUM ('1', '2', '3', '4');

-- CreateEnum
CREATE TYPE "ProductCategory" AS ENUM ('1', '2', '3', '4', '5');

-- CreateEnum
CREATE TYPE "DeptConsumptionGroup" AS ENUM ('1', '2', '3', '4', '5', '6', '9');

-- AlterTable
ALTER TABLE "departments" ADD COLUMN     "consumption_group" "DeptConsumptionGroup";

-- AlterTable
ALTER TABLE "drugs" ADD COLUMN     "drug_status" "DrugStatus" NOT NULL DEFAULT '1',
ADD COLUMN     "nlem_status" "NlemStatus",
ADD COLUMN     "product_category" "ProductCategory",
ADD COLUMN     "status_changed_date" DATE;
