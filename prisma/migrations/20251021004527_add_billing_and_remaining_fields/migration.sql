-- AlterTable
ALTER TABLE "receipt_items" ADD COLUMN     "remaining_quantity" DECIMAL(10,2);

-- AlterTable
ALTER TABLE "receipts" ADD COLUMN     "billing_date" DATE;
