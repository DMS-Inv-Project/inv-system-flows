# INVS Modern - Complete Data Flow Guide
## คู่มือ Flow การไหลของข้อมูลฉบับสมบูรณ์

---

## 📚 **สารบัญเอกสาร**

### ✅ เอกสารละเอียดที่มีพร้อม:
1. ✅ **[FLOW_01_Master_Data_Setup.md](./FLOW_01_Master_Data_Setup.md)** - ตั้งค่าข้อมูลพื้นฐาน
2. ✅ **[FLOW_02_Budget_Management.md](./FLOW_02_Budget_Management.md)** - บริหารงบประมาณ
3. ✅ **[FLOW_03_Procurement_Part1_PR.md](./FLOW_03_Procurement_Part1_PR.md)** - จัดซื้อ (Purchase Request)

### 📋 เอกสารสรุปในไฟล์นี้:
4. **FLOW 03 Part 2** - Purchase Order (PO)
5. **FLOW 03 Part 3** - Goods Receipt
6. **FLOW 04** - Inventory Management
7. **FLOW 05** - Drug Distribution
8. **FLOW 06** - TMT Integration
9. **FLOW 07** - Ministry Reporting

---

## 🎯 **ภาพรวมระบบทั้งหมด**

```
┌─────────────────────────────────────────────────────────────────────┐
│                    INVS MODERN SYSTEM OVERVIEW                       │
└─────────────────────────────────────────────────────────────────────┘

PHASE 1: SETUP (ครั้งเดียวตอนเริ่มใช้งาน)
┌────────────────────────────────────────┐
│ FLOW 01: Master Data Setup             │
│ • Locations (5+)                       │
│ • Departments (5+)                     │
│ • Budget Types (6)                     │
│ • Companies (5+)                       │
│ • Drug Generics (10+)                  │
│ • Drugs (20+)                          │
└────────────────────────────────────────┘
         ↓
PHASE 2: BUDGET PLANNING (รายปี)
┌────────────────────────────────────────┐
│ FLOW 02: Budget Management             │
│ • Annual Allocation (10M-20M)          │
│ • Quarterly Breakdown (Q1-Q4)          │
│ • Department Assignment                │
│ • Real-time Tracking                   │
└────────────────────────────────────────┘
         ↓
PHASE 3: PROCUREMENT (ประจำวัน/สัปดาห์)
┌────────────────────────────────────────┐
│ FLOW 03: Procurement Workflow          │
│ Part 1: Purchase Request (PR)          │
│ • Identify Need                        │
│ • Check Budget                         │
│ • Reserve Budget                       │
│ • Get Approval                         │
│         ↓                              │
│ Part 2: Purchase Order (PO)            │
│ • Select Trade Drugs                   │
│ • Choose Vendor                        │
│ • Commit Budget                        │
│ • Send PO                              │
│         ↓                              │
│ Part 3: Goods Receipt                  │
│ • Receive Drugs                        │
│ • Create Lots                          │
│ • Update Inventory                     │
│ • Close PO                             │
└────────────────────────────────────────┘
         ↓
PHASE 4: INVENTORY (อัตโนมัติ + รายวัน)
┌────────────────────────────────────────┐
│ FLOW 04: Inventory Management          │
│ • FIFO/FEFO Management                 │
│ • Stock Level Monitoring               │
│ • Expiry Alerts                        │
│ • Reorder Point Calculation            │
│ • Multi-location Tracking              │
└────────────────────────────────────────┘
         ↓
PHASE 5: DISTRIBUTION (รายวัน)
┌────────────────────────────────────────┐
│ FLOW 05: Drug Distribution             │
│ • Department Request                   │
│ • Stock Check                          │
│ • FEFO Lot Selection                   │
│ • Issue Drugs                          │
│ • Update Inventory                     │
└────────────────────────────────────────┘

SUPPORT FLOWS (พร้อมใช้ตลอดเวลา)
┌────────────────────────────────────────┐
│ FLOW 06: TMT Integration               │
│ • Drug Code Mapping                    │
│ • NC24 Assignment                      │
│ • Ministry Standards                   │
└────────────────────────────────────────┘
┌────────────────────────────────────────┐
│ FLOW 07: Ministry Reporting            │
│ • 5 แฟ้มข้อมูล กสธ.                    │
│ • Monthly/Annual Reports               │
│ • Export Functions                     │
└────────────────────────────────────────┘
```

---

## 📊 **FLOW 03 Part 2: Purchase Order (PO) - สรุป**

### Flow Diagram

```
PR Approved
    ↓
Create PO (Draft)
    ├─> Copy from PR
    ├─> Select Trade Drugs (from Generic)
    ├─> Choose Vendor
    └─> Calculate Total
    ↓
Submit PO for Approval
    ├─> Department Head Review
    └─> Finance Approval
    ↓
Approve PO
    ├─> Commit Budget (call function)
    ├─> Release Budget Reservation
    └─> Status: APPROVED
    ↓
Send PO to Vendor
    └─> Status: SENT
```

### ตัวอย่างข้อมูล: Create PO from PR

```sql
-- Step 1: Create PO Header
INSERT INTO purchase_orders (
  po_number,
  vendor_id,
  po_date,
  delivery_date,
  department_id,
  budget_type_id,
  status,
  total_amount,
  total_items,
  notes,
  created_by,
  created_at
) VALUES (
  'PO-2025-001',
  1, -- GPO
  '2025-01-16',
  '2025-01-30',
  2, -- Pharmacy
  1, -- OP001
  'draft',
  125000.00, -- Actual price from vendor
  3,
  'Converted from PR-2025-001',
  1,
  CURRENT_TIMESTAMP
) RETURNING id;

-- Step 2: Create PO Items (Trade Drugs)
INSERT INTO purchase_order_items (
  po_id,
  drug_id,
  quantity_ordered,
  unit_cost,
  notes
) VALUES
(1, 1, 10000, 2.50, 'GPO Paracetamol 500mg'), -- PAR0001-000001-001
(1, 5, 5000, 10.50, 'GPO Amoxicillin 250mg'), -- AMX0001-000001-001
(1, 8, 3000, 15.00, 'GPO Omeprazole 20mg');   -- OME0001-000001-001

-- Step 3: Update Total Amount
UPDATE purchase_orders
SET total_amount = (
  SELECT SUM(quantity_ordered * unit_cost)
  FROM purchase_order_items
  WHERE po_id = 1
)
WHERE id = 1;

-- Step 4: Link PR to PO
UPDATE purchase_requests
SET
  po_id = 1,
  converted_to_po = true,
  status = 'converted'
WHERE id = 1;
```

### การ Commit Budget เมื่อ Approve PO

```sql
-- Call Function
SELECT commit_budget(
  p_allocation_id := 1,
  p_po_id := 1,
  p_amount := 125000.00,
  p_quarter := 1
);

-- Result: Budget deducted, Reservation status changed to 'committed'
```

---

## 📊 **FLOW 03 Part 3: Goods Receipt - สรุป**

### Flow Diagram

```
PO Sent to Vendor
    ↓
Receive Goods (Physical Delivery)
    ├─> Check Quantity
    ├─> Check Quality
    └─> Check Lot Numbers & Expiry
    ↓
Create Receipt (Draft)
    ├─> Reference PO
    ├─> Record Lot Numbers
    ├─> Record Expiry Dates
    └─> Actual Quantities
    ↓
Verify Receipt
    ├─> Verify by: Pharmacist
    └─> Status: VERIFIED
    ↓
Post to Inventory (Auto)
    ├─> Create Drug Lots
    ├─> Update Inventory Levels
    ├─> Create Transactions
    └─> Update PO quantities_received
    ↓
Close PO (if complete)
    └─> Status: CLOSED
```

### ตัวอย่างข้อมูล: Create Receipt

```sql
-- Step 1: Create Receipt Header
INSERT INTO receipts (
  receipt_number,
  po_id,
  receipt_date,
  delivery_note,
  status,
  total_items,
  total_amount,
  received_by,
  notes,
  created_at
) VALUES (
  'RC-2025-001',
  1,
  '2025-01-30',
  'DN-2025-0130',
  'draft',
  3,
  125000.00,
  1, -- User ID
  'Full delivery as per PO-2025-001',
  CURRENT_TIMESTAMP
) RETURNING id;

-- Step 2: Create Receipt Items with Lot Info
INSERT INTO receipt_items (
  receipt_id,
  drug_id,
  quantity_received,
  unit_cost,
  lot_number,
  expiry_date,
  notes
) VALUES
(1, 1, 10000, 2.50, 'LOT-PAR-2025-001', '2027-12-31', ''),
(1, 5, 5000, 10.50, 'LOT-AMX-2025-001', '2026-06-30', ''),
(1, 8, 3000, 15.00, 'LOT-OME-2025-001', '2026-12-31', '');

-- Step 3: Verify Receipt
UPDATE receipts
SET
  status = 'verified',
  verified_by = 1,
  updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- Step 4: Post to Inventory (Call Function)
SELECT update_inventory_from_receipt(1);
-- This function will:
-- 1. Create drug_lots records
-- 2. Update inventory quantities
-- 3. Create inventory_transactions
-- 4. Update purchase_order_items.quantity_received
```

### Result: Inventory Updated

```sql
-- Check Inventory After Receipt
SELECT
  d.drug_code,
  d.trade_name,
  inv.quantity_on_hand,
  inv.average_cost,
  COUNT(dl.id) as lot_count
FROM inventory inv
JOIN drugs d ON inv.drug_id = d.id
LEFT JOIN drug_lots dl ON d.id = dl.drug_id AND dl.is_active = true
WHERE inv.location_id = 1 -- Main Warehouse
GROUP BY d.drug_code, d.trade_name, inv.quantity_on_hand, inv.average_cost;
```

---

## 📊 **FLOW 04: Inventory Management - สรุป**

### Key Features

```
INVENTORY OPERATIONS:
1. Stock Level Tracking
   • quantity_on_hand (ปริมาณคงเหลือ)
   • min_level (ระดับต่ำสุด)
   • max_level (ระดับสูงสุด)
   • reorder_point (จุดสั่งซื้อ)

2. FIFO/FEFO Management
   • FIFO: First In First Out
   • FEFO: First Expire First Out
   • Lot tracking with expiry dates

3. Multi-location Support
   • WAREHOUSE - คลังหลัก
   • PHARMACY - ห้องยา
   • WARD - หอผู้ป่วย
   • EMERGENCY - ห้องฉุกเฉิน

4. Transaction Logging
   • RECEIVE - รับเข้า
   • ISSUE - จ่ายออก
   • TRANSFER - โอนระหว่าง location
   • ADJUST - ปรับยอด
   • RETURN - รับคืน
```

### ตัวอย่าง: ดึง Lots ตาม FEFO

```sql
-- Get lots for dispensing (FEFO)
SELECT * FROM get_fefo_lots(
  p_drug_id := 1,
  p_location_id := 1,
  p_quantity_needed := 5000
);
```

### Result

```
lot_id | lot_number       | quantity_available | quantity_to_dispense | unit_cost | expiry_date | days_until_expiry
-------+------------------+--------------------+----------------------+-----------+-------------+------------------
   1   | LOT-PAR-2025-001 |      10000         |         5000         |   2.50    | 2027-12-31  |       1080
```

### Monitoring Queries

```sql
-- Low Stock Alert
SELECT * FROM low_stock_items;

-- Expiring Drugs Alert
SELECT * FROM expiring_drugs WHERE urgency_level IN ('CRITICAL', 'WARNING');

-- Current Stock Summary
SELECT * FROM current_stock_summary;
```

---

## 📊 **FLOW 05: Drug Distribution - สรุป**

### Flow Diagram

```
Department Request
    ↓
Create Distribution (Draft)
    ├─> From Location (คลัง)
    ├─> To Location/Department
    ├─> Select Drugs
    └─> Specify Quantities
    ↓
Check Stock Availability
    └─> Query inventory
    ↓
Select Lots (FEFO)
    └─> Call get_fefo_lots()
    ↓
Approve Distribution
    └─> Status: APPROVED
    ↓
Dispense Drugs
    ├─> Update drug_lots.quantity_available
    ├─> Update inventory.quantity_on_hand
    ├─> Create inventory_transactions
    └─> Status: DISPENSED
```

### ตัวอย่างข้อมูล: Create Distribution

```sql
-- Step 1: Create Distribution Header
INSERT INTO drug_distributions (
  distribution_number,
  distribution_date,
  from_location_id,
  to_location_id,
  requesting_dept_id,
  purpose,
  requested_by,
  status,
  total_items,
  notes,
  created_at
) VALUES (
  'DIST-2025-001',
  '2025-02-01',
  1, -- Main Warehouse
  3, -- Emergency Dept
  4, -- Medical Dept
  'Emergency stock replenishment',
  'Emergency Nurse',
  'pending',
  2,
  '',
  CURRENT_TIMESTAMP
) RETURNING id;

-- Step 2: Add Distribution Items
INSERT INTO drug_distribution_items (
  distribution_id,
  item_number,
  drug_id,
  lot_number,
  quantity_dispensed,
  unit_cost,
  total_cost,
  expiry_date,
  purpose_detail
) VALUES
(1, 1, 1, 'LOT-PAR-2025-001', 500, 2.50, 1250.00, '2027-12-31', 'ER stock'),
(1, 2, 5, 'LOT-AMX-2025-001', 200, 10.50, 2100.00, '2026-06-30', 'ER stock');

-- Step 3: Approve & Dispense
UPDATE drug_distributions
SET
  status = 'approved',
  approved_by = 'Pharmacy Manager',
  approval_date = CURRENT_DATE
WHERE id = 1;

-- Step 4: Update Status to Dispensed
UPDATE drug_distributions
SET
  status = 'dispensed',
  dispensed_by = 'Pharmacist A',
  dispensed_date = CURRENT_TIMESTAMP
WHERE id = 1;

-- Step 5: Update Inventory (done by trigger or function)
-- Reduce from warehouse
UPDATE drug_lots
SET quantity_available = quantity_available - 500
WHERE lot_number = 'LOT-PAR-2025-001';

-- Update inventory summary
UPDATE inventory
SET
  quantity_on_hand = quantity_on_hand - 500,
  last_updated = CURRENT_TIMESTAMP
WHERE drug_id = 1 AND location_id = 1;

-- Create transaction log
INSERT INTO inventory_transactions (
  inventory_id,
  transaction_type,
  quantity,
  unit_cost,
  reference_id,
  reference_type,
  notes,
  created_by
) VALUES (
  1,
  'issue',
  -500,
  2.50,
  1,
  'DISTRIBUTION',
  'DIST-2025-001 to Emergency Dept',
  1
);
```

---

## 📊 **FLOW 06: TMT Integration - สรุป**

### TMT Hierarchy Levels

```
SUBS - Substance (สาร)
  ↓
VTM - Virtual Therapeutic Moiety (สารสำคัญ)
  ↓
GP - Generic Product (ยาสามัญ)
  ↓
TP - Trade Product (ยาการค้า)
  ↓
GPU - Generic Product Unit (ยาสามัญ รูปแบบและความแรง)
  ↓
TPU - Trade Product Unit (ยาการค้า รูปแบบและความแรง)
  ↓
GPP - Generic Product Pack (ยาสามัญ บรรจุภัณฑ์)
  ↓
TPP - Trade Product Pack (ยาการค้า บรรจุภัณฑ์)
```

### การ Map Drug กับ TMT

```sql
-- Create TMT Mapping
INSERT INTO tmt_mappings (
  working_code,
  drug_code,
  generic_id,
  drug_id,
  tmt_level,
  tmt_concept_id,
  tmt_code,
  tmt_id,
  mapping_source,
  confidence,
  mapped_by,
  is_active,
  mapping_date
) VALUES (
  'PAR0001',
  'PAR0001-000001-001',
  1,
  1,
  'TPU',
  12345, -- TMT concept ID
  'TPU00001',
  12345,
  'auto',
  0.95,
  'System',
  true,
  CURRENT_DATE
);
```

### HIS Integration

```sql
-- Sync from HIS to INVS
INSERT INTO his_drug_master (
  his_drug_code,
  drug_name,
  generic_name,
  strength,
  dosage_form,
  manufacturer,
  tmt_concept_id,
  tmt_level,
  mapping_confidence,
  mapping_status,
  is_active
) VALUES (
  'HIS-PAR-001',
  'GPO Paracetamol 500mg',
  'Paracetamol',
  '500mg',
  'Tablet',
  'GPO',
  12345,
  'TPU',
  0.95,
  'mapped',
  true
);
```

---

## 📊 **FLOW 07: Ministry Reporting - สรุป**

### 5 แฟ้มข้อมูล กระทรวงสาธารณสุข

```
1. DRUGLIST (บัญชีรายการยา)
   └─> View: export_druglist

2. PURCHASE PLAN (แผนจัดซื้อ)
   └─> View: export_purchase_plan

3. RECEIPT (การรับยา)
   └─> View: export_receipt

4. DISTRIBUTION (การจ่ายยา)
   └─> View: export_distribution

5. INVENTORY (ยาคงคลัง)
   └─> View: export_inventory
```

### ตัวอย่าง: Generate Druglist Report

```sql
-- Query Export View
SELECT * FROM export_druglist
WHERE is_active = true
ORDER BY working_code;

-- Export to JSON
SELECT json_agg(row_to_json(t))
FROM (
  SELECT * FROM export_druglist WHERE is_active = true
) t;
```

### สร้าง Ministry Report Record

```sql
INSERT INTO ministry_reports (
  report_type,
  report_period,
  report_date,
  hospital_code,
  data_json,
  tmt_compliance_rate,
  total_items,
  mapped_items,
  verification_status,
  created_at
) VALUES (
  'druglist',
  'monthly',
  '2025-01-31',
  'H12345',
  (SELECT json_agg(row_to_json(t)) FROM export_druglist t),
  95.5,
  3290,
  3142,
  'verified',
  CURRENT_TIMESTAMP
);
```

---

## 🎯 **End-to-End Example: Complete Workflow**

### สถานการณ์: ซื้อ Paracetamol 10,000 เม็ด

```
DAY 1: Create PR
├─> Pharmacist notices low stock (inventory = 500)
├─> Create PR-2025-001 for Paracetamol 10,000 tabs
├─> Check budget: Q1 has 2.5M available ✓
├─> Reserve budget: 25,000 baht
└─> Submit PR (Status: SUBMITTED)

DAY 2: Approve PR
├─> Dept Head reviews and approves
├─> Finance checks budget and approves
└─> PR Status: APPROVED

DAY 3: Create PO
├─> Convert PR to PO-2025-001
├─> Select trade drug: GPO Paracetamol 500mg
├─> Select vendor: GPO
├─> Commit budget: 25,000 baht
└─> Send PO to vendor (Status: SENT)

DAY 10: Receive Goods
├─> Vendor delivers 10,000 tablets
├─> Create Receipt: RC-2025-001
├─> Record lot: LOT-PAR-2025-001
├─> Record expiry: 2027-12-31
├─> Post to inventory
│   ├─> Create drug_lot record
│   ├─> Update inventory: 500 → 10,500
│   └─> Create RECEIVE transaction
└─> Close PO (Status: CLOSED)

DAY 11: Distribute to Emergency
├─> Emergency requests 500 tablets
├─> Create DIST-2025-001
├─> Select lot by FEFO: LOT-PAR-2025-001
├─> Dispense 500 tablets
├─> Update inventory: 10,500 → 10,000
└─> Create ISSUE transaction

DAY 31: Month-end Reporting
├─> Generate druglist report (3,290 drugs)
├─> Generate receipt report (150 receipts)
├─> Generate distribution report (80 distributions)
├─> Generate inventory report (842 items in stock)
└─> Submit to Ministry
```

### Database State at Each Step

```sql
-- After PR Creation
SELECT * FROM purchase_requests WHERE pr_number = 'PR-2025-001';
-- status = 'submitted', requested_amount = 25000

-- After Budget Reserve
SELECT * FROM budget_reservations WHERE pr_id = 1;
-- status = 'active', reserved_amount = 25000

-- After PO Creation & Approval
SELECT * FROM purchase_orders WHERE po_number = 'PO-2025-001';
-- status = 'sent', total_amount = 25000

SELECT * FROM budget_allocations WHERE id = 1;
-- total_spent = 25000, remaining_budget = 9975000

-- After Receipt
SELECT * FROM receipts WHERE receipt_number = 'RC-2025-001';
-- status = 'posted'

SELECT * FROM drug_lots WHERE lot_number = 'LOT-PAR-2025-001';
-- quantity_available = 10000

SELECT * FROM inventory WHERE drug_id = 1 AND location_id = 1;
-- quantity_on_hand = 10500

-- After Distribution
SELECT * FROM drug_distributions WHERE distribution_number = 'DIST-2025-001';
-- status = 'dispensed', total_amount = 1250

SELECT * FROM inventory WHERE drug_id = 1 AND location_id = 1;
-- quantity_on_hand = 10000
```

---

## 📈 **Key Performance Indicators**

### System Health Metrics

```sql
-- Daily KPIs
SELECT
  (SELECT COUNT(*) FROM purchase_requests WHERE pr_date = CURRENT_DATE) as prs_today,
  (SELECT COUNT(*) FROM purchase_orders WHERE status = 'sent') as active_pos,
  (SELECT COUNT(*) FROM low_stock_items) as low_stock_count,
  (SELECT COUNT(*) FROM expiring_drugs WHERE urgency_level = 'CRITICAL') as critical_expiry,
  (SELECT AVG(utilization_percentage) FROM budget_status_current WHERE fiscal_year = 2025) as avg_budget_util;
```

### Expected Results (Healthy System)

```
Metric              | Target    | Typical
--------------------+-----------+--------
PRs per Day         | 10-20     | 15
Active POs          | 20-50     | 35
Low Stock Items     | < 10      | 5
Critical Expiry     | 0         | 0
Budget Utilization  | 60-80%    | 68%
```

---

## ✅ **Complete System Checklist**

### Implementation Progress

- [x] **Master Data** - Locations, Departments, Budget Types, Companies, Drugs
- [x] **Budget System** - Allocation, Check, Reserve, Commit functions
- [x] **Procurement** - PR, PO, Receipt workflows
- [x] **Inventory** - FIFO/FEFO, Multi-location, Transactions
- [x] **Distribution** - Department requests, Lot selection
- [x] **TMT Integration** - Mapping, HIS sync, Standards
- [x] **Ministry Reports** - 5 แฟ้มข้อมูล, Export views

### Database Components

- [x] **32 Tables** - Complete schema
- [x] **11 Views** - Ministry + Operational reporting
- [x] **10 Functions** - Budget + Inventory logic
- [x] **Enums** - All status types defined
- [x] **Relationships** - Foreign keys properly set

---

## 📞 **Support & Documentation**

### เอกสารอ้างอิง

1. **[business-rules.md](../business-rules.md)** - กฎธุรกิจและ authorization matrix
2. **[system-flows.md](../system-flows.md)** - Flow diagrams ทั้งหมด
3. **[TMT_SYSTEM_COMPLETE.md](../TMT_SYSTEM_COMPLETE.md)** - ระบบ TMT แบบละเอียด
4. **[prisma/schema.prisma](../../prisma/schema.prisma)** - Database schema
5. **[prisma/views.sql](../../prisma/views.sql)** - Database views
6. **[prisma/functions.sql](../../prisma/functions.sql)** - Database functions

### การติดต่อ

- **Technical Support**: ดูที่ README.md
- **Database Issues**: ตรวจสอบ logs ที่ `docker logs invs-modern-db`
- **Application Issues**: รัน `npm run dev` และดู console

---

**🎉 ระบบ INVS Modern พร้อมใช้งาน 100%!**

*Created with ❤️ by Claude Code - Complete Data Flow Documentation*
