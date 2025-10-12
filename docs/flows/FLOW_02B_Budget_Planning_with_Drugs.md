# FLOW 02B: Budget Planning with Drug Details
## การวางแผนงบประมาณพร้อมระบุรายการยา

**Version**: 1.0.0
**Last Updated**: 2025-01-11
**Status**: ✅ Complete

---

## 🎯 Overview

ระบบวางแผนงบประมาณแบบละเอียด โดยระบุรายการยาที่จะจัดซื้อล่วงหน้าตั้งแต่ต้นปีงบประมาณ รองรับการพยากรณ์ความต้องการจากข้อมูลย้อนหลัง 3 ปี

### Key Features

```
✅ Drug-level Budget Planning (ระบุยาแต่ละตัว)
✅ Quarterly Breakdown (Q1-Q4)
✅ Historical Data Analysis (3 years)
✅ Forecast Calculation (AI/Manual)
✅ Budget vs Actual Tracking
✅ Approval Workflow
✅ Integration with Purchase Request
```

---

## 📊 Budget Planning Tables (3 tables)

```
┌────────────────────────────────────────┐
│      BUDGET PLANNING SYSTEM            │
└────────────────────────────────────────┘

┌──────────────────────┐
│ budget_allocations   │  ← Budget Allocation (งบรวม)
│ ─────────────────    │
│ • fiscal_year        │
│ • budget_type_id     │
│ • department_id      │
│ • total_budget       │
│ • q1-q4_budget       │
│ • total_spent        │
└──────────────────────┘
         ↓ 1:1
┌──────────────────────┐
│ budget_plans         │  ← Budget Plan Header
│ ─────────────────    │
│ • fiscal_year        │
│ • department_id      │
│ • allocation_id      │
│ • total_planned      │
│ • q1-q4_planned      │
│ • status             │
└──────────────────────┘
         ↓ 1:N
┌──────────────────────┐
│ budget_plan_items    │  ← Drug Details ⭐
│ ─────────────────    │
│ • generic_id         │
│ • planned_quantity   │
│ • estimated_cost     │
│ • q1-q4_quantity     │
│ • q1-q4_budget       │
│ • year1-3_consumption│
│ • forecast_method    │
└──────────────────────┘
```

---

## 🔄 Complete Budget Planning Flow

```
PHASE 0: PREPARATION (ก่อนปีงบประมาณ)
┌──────────────────────────────────────┐
│ Step 1: Analyze Historical Data     │
│ └─> ดึงข้อมูลการใช้ยา 3 ปีย้อนหลัง │
│ └─> คำนวณค่าเฉลี่ย                  │
│ └─> ดูแนวโน้มการใช้                 │
└──────────────────────────────────────┘
         ↓
PHASE 1: BUDGET ALLOCATION (งบรวม)
┌──────────────────────────────────────┐
│ Step 2: Create Budget Allocation    │
│ └─> Finance allocates total budget  │
│ └─> By Department + Budget Type     │
│ └─> Total: 10M, Q1-Q4: 2.5M each   │
└──────────────────────────────────────┘
         ↓
PHASE 2: DETAILED PLANNING (ระบุยา)
┌──────────────────────────────────────┐
│ Step 3: Create Budget Plan          │
│ └─> Department creates plan          │
│ └─> Link to Budget Allocation       │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ Step 4: Add Drug Items               │
│ └─> ระบุยาแต่ละตัว (Generic Drug)   │
│ └─> จำนวนที่วางแผน                  │
│ └─> ราคาประมาณการ                   │
│ └─> แบ่งตามไตรมาส Q1-Q4            │
└──────────────────────────────────────┘
         ↓
┌──────────────────────────────────────┐
│ Step 5: Calculate Forecast           │
│ └─> Based on 3-year average          │
│ └─> Growth rate adjustment           │
│ └─> Current stock consideration      │
└──────────────────────────────────────┘
         ↓
PHASE 3: APPROVAL
┌──────────────────────────────────────┐
│ Step 6: Submit for Approval          │
│ └─> Department Head review           │
│ └─> Finance Manager approval         │
│ └─> Status: DRAFT → APPROVED        │
└──────────────────────────────────────┘
         ↓
PHASE 4: EXECUTION
┌──────────────────────────────────────┐
│ Step 7: Track vs Actual              │
│ └─> Monitor purchases against plan   │
│ └─> Update purchased amounts         │
│ └─> Alert if exceed plan             │
└──────────────────────────────────────┘
```

---

## 📝 STEP 1: Analyze Historical Data

### Query Historical Drug Usage

```sql
-- Get 3-year consumption history for planning
SELECT
    dg.working_code,
    dg.drug_name,
    dg.dosage_form,
    -- Year 1 (2022)
    COALESCE(SUM(CASE
        WHEN EXTRACT(YEAR FROM it.created_at) = 2022
        THEN ABS(it.quantity)
    END), 0) as year1_consumption,
    -- Year 2 (2023)
    COALESCE(SUM(CASE
        WHEN EXTRACT(YEAR FROM it.created_at) = 2023
        THEN ABS(it.quantity)
    END), 0) as year2_consumption,
    -- Year 3 (2024)
    COALESCE(SUM(CASE
        WHEN EXTRACT(YEAR FROM it.created_at) = 2024
        THEN ABS(it.quantity)
    END), 0) as year3_consumption,
    -- Average
    ROUND(
        COALESCE(SUM(ABS(it.quantity)), 0) / 3.0,
        2
    ) as avg_consumption_3years,
    -- Current Stock
    COALESCE(
        (SELECT SUM(quantity_on_hand)
         FROM inventory
         WHERE drug_id IN (
             SELECT id FROM drugs WHERE generic_id = dg.id
         )),
        0
    ) as current_stock
FROM drug_generics dg
LEFT JOIN drugs d ON dg.id = d.generic_id
LEFT JOIN inventory inv ON d.id = inv.drug_id
LEFT JOIN inventory_transactions it ON inv.id = it.inventory_id
    AND it.transaction_type = 'ISSUE'
    AND it.created_at >= '2022-01-01'
    AND it.created_at < '2025-01-01'
WHERE dg.is_active = true
GROUP BY dg.id, dg.working_code, dg.drug_name, dg.dosage_form
HAVING SUM(ABS(it.quantity)) > 0
ORDER BY avg_consumption_3years DESC;
```

**Expected Result:**
```
working_code | drug_name        | year1 | year2 | year3 | avg_3yr | current_stock
-------------+------------------+-------+-------+-------+---------+--------------
PAR0001      | Paracetamol 500mg| 95000 |105000 |110000 | 103333  | 15000
AMX0001      | Amoxicillin 250mg| 45000 | 48000 | 52000 |  48333  |  8000
OME0001      | Omeprazole 20mg  | 28000 | 30000 | 32000 |  30000  |  5000
```

---

## 📝 STEP 2: Create Budget Allocation (งบรวม)

```sql
-- Create budget allocation for Pharmacy Department
INSERT INTO budget_allocations (
    fiscal_year,
    budget_type_id,
    department_id,
    total_budget,
    q1_budget,
    q2_budget,
    q3_budget,
    q4_budget,
    total_spent,
    q1_spent,
    q2_spent,
    q3_spent,
    q4_spent,
    remaining_budget,
    status,
    created_at,
    updated_at
) VALUES (
    2025,                    -- Fiscal Year
    1,                       -- OP001 - งบยา
    2,                       -- Pharmacy Department
    10000000.00,             -- 10M total
    2500000.00,              -- Q1: 2.5M
    2500000.00,              -- Q2: 2.5M
    2500000.00,              -- Q3: 2.5M
    2500000.00,              -- Q4: 2.5M
    0.00,                    -- Not spent yet
    0.00, 0.00, 0.00, 0.00,  -- Q1-Q4 not spent
    10000000.00,             -- Full budget remaining
    'active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) RETURNING id;
-- Returns: 1
```

---

## 📝 STEP 3: Create Budget Plan

```sql
-- Create Budget Plan for detailed drug planning
INSERT INTO budget_plans (
    fiscal_year,
    department_id,
    budget_allocation_id,
    total_planned_budget,
    total_planned_quantity,
    q1_planned_budget,
    q2_planned_budget,
    q3_planned_budget,
    q4_planned_budget,
    total_purchased,
    q1_purchased,
    q2_purchased,
    q3_purchased,
    q4_purchased,
    remaining_budget,
    status,
    notes,
    created_at,
    updated_at
) VALUES (
    2025,                         -- Fiscal Year
    2,                            -- Pharmacy Department
    1,                            -- Link to allocation
    9500000.00,                   -- Plan to use 9.5M (95% of allocation)
    0,                            -- Will calculate from items
    2375000.00,                   -- Q1: 2.375M
    2375000.00,                   -- Q2: 2.375M
    2375000.00,                   -- Q3: 2.375M
    2375000.00,                   -- Q4: 2.375M
    0.00,                         -- Not purchased yet
    0.00, 0.00, 0.00, 0.00,      -- Q1-Q4 not purchased
    9500000.00,                   -- Remaining
    'draft',                      -- Status
    'Annual drug procurement plan based on 3-year consumption history',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) RETURNING id;
-- Returns: 1
```

---

## 📝 STEP 4: Add Drug Items to Plan

### Item 1: Paracetamol 500mg

```sql
INSERT INTO budget_plan_items (
    budget_plan_id,
    item_number,
    generic_id,
    planned_quantity,
    estimated_unit_cost,
    planned_total_cost,
    q1_quantity,
    q2_quantity,
    q3_quantity,
    q4_quantity,
    q1_budget,
    q2_budget,
    q3_budget,
    q4_budget,
    purchased_quantity,
    purchased_value,
    q1_purchased_qty,
    q2_purchased_qty,
    q3_purchased_qty,
    q4_purchased_qty,
    remaining_quantity,
    remaining_value,
    avg_consumption_3_years,
    year1_consumption,
    year2_consumption,
    year3_consumption,
    forecast_method,
    min_stock_level,
    current_stock,
    justification,
    status,
    notes,
    created_at,
    updated_at
) VALUES (
    1,                           -- budget_plan_id
    1,                           -- item_number
    1,                           -- PAR0001 - Paracetamol
    120000,                      -- Plan to buy 120,000 tablets
    2.50,                        -- Estimated 2.50 baht/tablet
    300000.00,                   -- Total 300,000 baht
    30000,                       -- Q1: 30,000
    30000,                       -- Q2: 30,000
    30000,                       -- Q3: 30,000
    30000,                       -- Q4: 30,000
    75000.00,                    -- Q1 budget
    75000.00,                    -- Q2 budget
    75000.00,                    -- Q3 budget
    75000.00,                    -- Q4 budget
    0,                           -- Not purchased yet
    0.00,                        -- Not purchased yet
    0, 0, 0, 0,                  -- Q1-Q4 not purchased
    120000,                      -- Remaining = planned
    300000.00,                   -- Remaining value
    103333,                      -- 3-year average
    95000,                       -- Year 1 (2022)
    105000,                      -- Year 2 (2023)
    110000,                      -- Year 3 (2024)
    'AVERAGE_WITH_GROWTH',       -- Forecast method
    10000,                       -- Min stock level
    15000,                       -- Current stock
    'High-demand drug. Consumption trend shows 5% annual growth. Plan 120,000 to cover annual demand plus safety stock.',
    'pending',
    'Review quarterly based on actual consumption',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);
```

### Item 2: Amoxicillin 250mg

```sql
INSERT INTO budget_plan_items (
    budget_plan_id,
    item_number,
    generic_id,
    planned_quantity,
    estimated_unit_cost,
    planned_total_cost,
    q1_quantity,
    q2_quantity,
    q3_quantity,
    q4_quantity,
    q1_budget,
    q2_budget,
    q3_budget,
    q4_budget,
    purchased_quantity,
    purchased_value,
    q1_purchased_qty,
    q2_purchased_qty,
    q3_purchased_qty,
    q4_purchased_qty,
    remaining_quantity,
    remaining_value,
    avg_consumption_3_years,
    year1_consumption,
    year2_consumption,
    year3_consumption,
    forecast_method,
    min_stock_level,
    current_stock,
    justification,
    status,
    created_at,
    updated_at
) VALUES (
    1, 2, 3,                     -- Plan 1, Item 2, Amoxicillin
    55000, 10.00, 550000.00,     -- 55,000 caps @ 10 baht = 550K
    13750, 13750, 13750, 13750,  -- Quarterly quantities
    137500, 137500, 137500, 137500, -- Quarterly budgets
    0, 0.00,                     -- Not purchased
    0, 0, 0, 0,                  -- Q1-Q4 not purchased
    55000, 550000.00,            -- Remaining
    48333,                       -- 3-year average
    45000, 48000, 52000,         -- Historical data
    'AVERAGE_WITH_GROWTH',
    5000,                        -- Min level
    8000,                        -- Current stock
    'Essential antibiotic. Growing consumption trend due to increased patient volume.',
    'pending',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);
```

### Update Budget Plan Summary

```sql
-- Update total planned quantity in budget plan
UPDATE budget_plans
SET
    total_planned_quantity = (
        SELECT SUM(planned_quantity)
        FROM budget_plan_items
        WHERE budget_plan_id = 1
    ),
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;
```

---

## 🎯 UI MOCKUP: Budget Planning Dashboard

```
╔════════════════════════════════════════════════════════════════════╗
║  INVS Modern - Budget Planning FY 2025                        [X] ║
╠════════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  💰 Budget Plan: Pharmacy Department                               ║
║  Fiscal Year: 2025 | Budget Type: OP001 - งบยา                    ║
║  Status: 📝 DRAFT                                                  ║
║                                                                    ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │  BUDGET SUMMARY                                              │ ║
║  ├──────────────────────────────────────────────────────────────┤ ║
║  │  Budget Allocated:     10,000,000.00 บาท                    │ ║
║  │  Budget Planned:        9,500,000.00 บาท (95%)              │ ║
║  │  Budget Reserved:         500,000.00 บาท (5% buffer)        │ ║
║  │                                                              │ ║
║  │  Q1-Q4 Breakdown:                                            │ ║
║  │  Q1: 2,375,000 | Q2: 2,375,000 | Q3: 2,375,000 | Q4: 2,375,000│ ║
║  └──────────────────────────────────────────────────────────────┘ ║
║                                                                    ║
║  📊 Drug Planning Items                  [+ Add Drug] [Import CSV]║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │#│Drug Name      │Qty Plan│Avg 3yr│Unit│Total    │Q1-Q4│Status│ ║
║  ├─┼───────────────┼────────┼───────┼────┼─────────┼─────┼──────┤ ║
║  │1│Paracetamol    │120,000 │103,333│2.50│ 300,000 │[📊]│✓     │ ║
║  │ │500mg Tab      │        │+16%   │    │         │     │      │ ║
║  ├─┼───────────────┼────────┼───────┼────┼─────────┼─────┼──────┤ ║
║  │2│Amoxicillin    │ 55,000 │ 48,333│10.0│ 550,000 │[📊]│✓     │ ║
║  │ │250mg Cap      │        │+14%   │    │         │     │      │ ║
║  ├─┼───────────────┼────────┼───────┼────┼─────────┼─────┼──────┤ ║
║  │3│Omeprazole     │ 35,000 │ 30,000│15.0│ 525,000 │[📊]│✓     │ ║
║  │ │20mg Cap       │        │+17%   │    │         │     │      │ ║
║  │...                                                            │ ║
║  └──────────────────────────────────────────────────────────────┘ ║
║                                                                    ║
║  📈 Summary Statistics                                             ║
║  • Total Items: 45 drugs                                          ║
║  • Total Planned Quantity: 892,500 units                          ║
║  • Total Planned Budget: 9,500,000 บาท                           ║
║  • Budget Utilization: 95% (✓ Within target)                     ║
║                                                                    ║
║  [💾 Save Draft] [📋 Preview Report] [✓ Submit for Approval]     ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
```

---

## 🎯 UI MOCKUP: Add/Edit Drug Item

```
╔════════════════════════════════════════════════════════════════════╗
║  Add Drug to Budget Plan                                      [X] ║
╠════════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  Drug Information                                                  ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │ Generic Drug: [PAR0001 - Paracetamol 500mg Tablet      ▼]   │ ║
║  │                                                              │ ║
║  │ 📊 Historical Data (3 years)                                │ ║
║  │ ├─ 2022: 95,000 tablets                                    │ ║
║  │ ├─ 2023: 105,000 tablets (+10.5%)                          │ ║
║  │ ├─ 2024: 110,000 tablets (+4.8%)                           │ ║
║  │ └─ Average: 103,333 tablets/year                           │ ║
║  │                                                              │ ║
║  │ 📦 Current Stock: 15,000 tablets                           │ ║
║  │ 🔻 Min Level: 10,000 tablets                               │ ║
║  └──────────────────────────────────────────────────────────────┘ ║
║                                                                    ║
║  Planning Details                                                  ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │ Forecast Method: [●] Average + Growth                        │ ║
║  │                  [ ] Manual Entry                            │ ║
║  │                  [ ] AI Prediction                           │ ║
║  │                                                              │ ║
║  │ Planned Quantity (Annual): [120,000] tablets                │ ║
║  │   ├─ Suggested: 113,465 (based on 10% growth)              │ ║
║  │   └─ Adjustment: +6,535 (safety buffer)                     │ ║
║  │                                                              │ ║
║  │ Estimated Unit Cost: [2.50] บาท                             │ ║
║  │   └─ Last Purchase: 2.45 บาท (Nov 2024)                    │ ║
║  │                                                              │ ║
║  │ Total Planned Cost: 300,000.00 บาท                          │ ║
║  └──────────────────────────────────────────────────────────────┘ ║
║                                                                    ║
║  Quarterly Distribution                                            ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │ Distribution: [●] Equal      [ ] Custom                      │ ║
║  │                                                              │ ║
║  │ Q1 (Jan-Mar):  [30,000] qty │  75,000.00 บาท  (25%)        │ ║
║  │ Q2 (Apr-Jun):  [30,000] qty │  75,000.00 บาท  (25%)        │ ║
║  │ Q3 (Jul-Sep):  [30,000] qty │  75,000.00 บาท  (25%)        │ ║
║  │ Q4 (Oct-Dec):  [30,000] qty │  75,000.00 บาท  (25%)        │ ║
║  │                ────────────────────────────────              │ ║
║  │ Total:         120,000 qty  │ 300,000.00 บาท  ✓            │ ║
║  └──────────────────────────────────────────────────────────────┘ ║
║                                                                    ║
║  Justification                                                     ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │ [High-demand drug. Consumption trend shows 5% annual      ]  │ ║
║  │ [growth. Plan 120,000 to cover annual demand plus safety  ]  │ ║
║  │ [stock.                                                    ]  │ ║
║  └──────────────────────────────────────────────────────────────┘ ║
║                                                                    ║
║                [Cancel]  [💾 Save]  [Save & Add Another]          ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
```

---

## 📝 STEP 5: Approval Workflow

```sql
-- Submit for Approval
UPDATE budget_plans
SET
    status = 'submitted',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- Department Head Approval
UPDATE budget_plans
SET
    status = 'approved',
    approved_by = 'Chief Pharmacist',
    approval_date = CURRENT_DATE,
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- Activate Plan
UPDATE budget_plans
SET
    status = 'active',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;
```

---

## 📝 STEP 6: Track Purchase vs Plan

### When Purchase Request is Created

```sql
-- Check against budget plan
SELECT
    bpi.id,
    dg.working_code,
    dg.drug_name,
    bpi.planned_quantity,
    bpi.purchased_quantity,
    bpi.remaining_quantity,
    bpi.planned_total_cost,
    bpi.purchased_value,
    bpi.remaining_value,
    -- Q1 check
    bpi.q1_quantity as q1_planned,
    bpi.q1_purchased_qty as q1_purchased,
    (bpi.q1_quantity - bpi.q1_purchased_qty) as q1_remaining
FROM budget_plan_items bpi
JOIN budget_plans bp ON bpi.budget_plan_id = bp.id
JOIN drug_generics dg ON bpi.generic_id = dg.id
WHERE bp.fiscal_year = 2025
    AND bp.department_id = 2
    AND bp.status = 'active'
    AND bpi.generic_id = 1  -- Paracetamol
    AND bpi.remaining_quantity > 0;
```

### Update When Purchase is Made

```sql
-- When PR approved and converted to PO (Q1 purchase of 10,000)
UPDATE budget_plan_items
SET
    purchased_quantity = purchased_quantity + 10000,
    purchased_value = purchased_value + 25000.00,
    q1_purchased_qty = q1_purchased_qty + 10000,
    remaining_quantity = planned_quantity - (purchased_quantity + 10000),
    remaining_value = planned_total_cost - (purchased_value + 25000.00),
    updated_at = CURRENT_TIMESTAMP
WHERE budget_plan_id = 1
    AND item_number = 1;

-- Update budget plan summary
UPDATE budget_plans
SET
    total_purchased = total_purchased + 25000.00,
    q1_purchased = q1_purchased + 25000.00,
    remaining_budget = total_planned_budget - (total_purchased + 25000.00),
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;
```

---

## 🎯 UI MOCKUP: Budget vs Actual Tracking

```
╔════════════════════════════════════════════════════════════════════╗
║  Budget Plan Tracking - Q1 2025                               [X] ║
╠════════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  Department: Pharmacy | Budget: OP001 - ยา                        ║
║  Period: January - March 2025                                      ║
║                                                                    ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │  Q1 SUMMARY                                                  │ ║
║  ├──────────────────────────────────────────────────────────────┤ ║
║  │  Planned Budget:      2,375,000.00 บาท                      │ ║
║  │  Purchased:             625,000.00 บาท  ████░░░░░░  26%     │ ║
║  │  Committed (PO):        250,000.00 บาท  ██░░░░░░░░  11%     │ ║
║  │  Available:           1,500,000.00 บาท  ██████░░░░  63%     │ ║
║  │                                                              │ ║
║  │  Status: ✅ On Track (37% utilized, 50% of quarter passed)  │ ║
║  └──────────────────────────────────────────────────────────────┘ ║
║                                                                    ║
║  📊 Drug-level Tracking                        [Export] [Refresh] ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │Drug        │Plan Q1│Purchased│Committed│Remaining│Status    │ ║
║  ├────────────┼───────┼─────────┼─────────┼─────────┼──────────┤ ║
║  │Paracetamol │30,000 │  10,000 │   5,000 │  15,000 │✅ On Tr │ ║
║  │500mg       │       │    33%  │    17%  │    50%  │          │ ║
║  ├────────────┼───────┼─────────┼─────────┼─────────┼──────────┤ ║
║  │Amoxicillin │13,750 │   8,000 │   2,000 │   3,750 │⚠️ High  │ ║
║  │250mg       │       │    58%  │    15%  │    27%  │          │ ║
║  ├────────────┼───────┼─────────┼─────────┼─────────┼──────────┤ ║
║  │Omeprazole  │ 8,750 │   2,000 │       0 │   6,750 │✅ Good  │ ║
║  │20mg        │       │    23%  │     0%  │    77%  │          │ ║
║  └────────────┴───────┴─────────┴─────────┴─────────┴──────────┘ ║
║                                                                    ║
║  ⚠️ Alerts:                                                        ║
║  • Amoxicillin 250mg: 73% utilized but only 50% of quarter       ║
║    → Consider adjusting Q2-Q4 plan                                ║
║  • 3 drugs below 20% utilization → Review if plan too high       ║
║                                                                    ║
║  [📊 View Detailed Report] [📧 Send to Finance] [✏️ Adjust Plan] ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
```

---

## 📊 Key Queries

### Query 1: Budget Plan Summary

```sql
SELECT
    bp.id,
    bp.fiscal_year,
    d.dept_name,
    bt.budget_name,
    ba.total_budget as allocated,
    bp.total_planned_budget as planned,
    bp.total_purchased as purchased,
    bp.remaining_budget,
    ROUND((bp.total_purchased / bp.total_planned_budget * 100), 2) as utilization_pct,
    COUNT(bpi.id) as total_items,
    bp.status,
    bp.approved_by,
    bp.approval_date
FROM budget_plans bp
JOIN budget_allocations ba ON bp.budget_allocation_id = ba.id
JOIN departments d ON bp.department_id = d.id
JOIN budget_types bt ON ba.budget_type_id = bt.id
LEFT JOIN budget_plan_items bpi ON bp.id = bpi.budget_plan_id
WHERE bp.fiscal_year = 2025
GROUP BY bp.id, bp.fiscal_year, d.dept_name, bt.budget_name,
         ba.total_budget, bp.total_planned_budget, bp.total_purchased,
         bp.remaining_budget, bp.status, bp.approved_by, bp.approval_date;
```

### Query 2: Drug-level Budget vs Actual

```sql
SELECT
    dg.working_code,
    dg.drug_name,
    dg.dosage_form,
    bpi.planned_quantity,
    bpi.purchased_quantity,
    bpi.remaining_quantity,
    bpi.planned_total_cost,
    bpi.purchased_value,
    bpi.remaining_value,
    ROUND((bpi.purchased_quantity::DECIMAL / bpi.planned_quantity * 100), 2) as qty_utilization_pct,
    ROUND((bpi.purchased_value / bpi.planned_total_cost * 100), 2) as budget_utilization_pct,
    -- Quarterly breakdown
    bpi.q1_quantity, bpi.q1_purchased_qty,
    bpi.q2_quantity, bpi.q2_purchased_qty,
    bpi.q3_quantity, bpi.q3_purchased_qty,
    bpi.q4_quantity, bpi.q4_purchased_qty,
    bpi.avg_consumption_3_years,
    bpi.forecast_method,
    bpi.status
FROM budget_plan_items bpi
JOIN budget_plans bp ON bpi.budget_plan_id = bp.id
JOIN drug_generics dg ON bpi.generic_id = dg.id
WHERE bp.fiscal_year = 2025
    AND bp.department_id = 2
    AND bp.status IN ('approved', 'active')
ORDER BY bpi.item_number;
```

### Query 3: Variance Analysis

```sql
-- Drugs with significant variance from plan
SELECT
    dg.working_code,
    dg.drug_name,
    bpi.planned_quantity,
    bpi.purchased_quantity,
    bpi.avg_consumption_3_years,
    (bpi.purchased_quantity - bpi.avg_consumption_3_years) as variance_from_avg,
    ROUND(
        ((bpi.purchased_quantity - bpi.avg_consumption_3_years)::DECIMAL
         / bpi.avg_consumption_3_years * 100),
        2
    ) as variance_pct,
    CASE
        WHEN bpi.purchased_quantity > (bpi.avg_consumption_3_years * 1.2)
            THEN 'OVER_BUYING'
        WHEN bpi.purchased_quantity < (bpi.avg_consumption_3_years * 0.8)
            THEN 'UNDER_BUYING'
        ELSE 'NORMAL'
    END as buying_pattern
FROM budget_plan_items bpi
JOIN budget_plans bp ON bpi.budget_plan_id = bp.id
JOIN drug_generics dg ON bpi.generic_id = dg.id
WHERE bp.fiscal_year = 2025
    AND bp.department_id = 2
    AND bpi.avg_consumption_3_years IS NOT NULL
ORDER BY ABS(variance_pct) DESC;
```

---

## 🔄 Integration with Purchase Request

### Check Budget Plan Before Creating PR

```sql
-- Function to check if drug is in budget plan
CREATE OR REPLACE FUNCTION check_drug_in_budget_plan(
    p_fiscal_year INT,
    p_department_id BIGINT,
    p_generic_id BIGINT,
    p_requested_qty DECIMAL,
    p_quarter INT
)
RETURNS TABLE (
    in_plan BOOLEAN,
    plan_item_id BIGINT,
    planned_qty DECIMAL,
    remaining_qty DECIMAL,
    quarter_planned DECIMAL,
    quarter_purchased DECIMAL,
    quarter_remaining DECIMAL,
    over_plan BOOLEAN,
    message TEXT
) AS $$
DECLARE
    v_plan_item budget_plan_items%ROWTYPE;
    v_quarter_planned DECIMAL;
    v_quarter_purchased DECIMAL;
BEGIN
    -- Get budget plan item
    SELECT * INTO v_plan_item
    FROM budget_plan_items bpi
    JOIN budget_plans bp ON bpi.budget_plan_id = bp.id
    WHERE bp.fiscal_year = p_fiscal_year
        AND bp.department_id = p_department_id
        AND bp.status IN ('approved', 'active')
        AND bpi.generic_id = p_generic_id;

    -- If not found in plan
    IF NOT FOUND THEN
        RETURN QUERY SELECT
            false, NULL::BIGINT, 0::DECIMAL, 0::DECIMAL,
            0::DECIMAL, 0::DECIMAL, 0::DECIMAL, false,
            'Drug not found in budget plan'::TEXT;
        RETURN;
    END IF;

    -- Get quarterly data
    CASE p_quarter
        WHEN 1 THEN
            v_quarter_planned := v_plan_item.q1_quantity;
            v_quarter_purchased := v_plan_item.q1_purchased_qty;
        WHEN 2 THEN
            v_quarter_planned := v_plan_item.q2_quantity;
            v_quarter_purchased := v_plan_item.q2_purchased_qty;
        WHEN 3 THEN
            v_quarter_planned := v_plan_item.q3_quantity;
            v_quarter_purchased := v_plan_item.q3_purchased_qty;
        WHEN 4 THEN
            v_quarter_planned := v_plan_item.q4_quantity;
            v_quarter_purchased := v_plan_item.q4_purchased_qty;
    END CASE;

    -- Return results
    RETURN QUERY SELECT
        true,
        v_plan_item.id,
        v_plan_item.planned_quantity,
        v_plan_item.remaining_quantity,
        v_quarter_planned,
        v_quarter_purchased,
        (v_quarter_planned - v_quarter_purchased),
        (p_requested_qty > (v_quarter_planned - v_quarter_purchased)),
        CASE
            WHEN p_requested_qty > (v_quarter_planned - v_quarter_purchased) THEN
                'Request exceeds quarterly plan'
            ELSE
                'Within budget plan'
        END;
END;
$$ LANGUAGE plpgsql;
```

### Usage in PR Creation

```sql
-- Check before creating PR
SELECT * FROM check_drug_in_budget_plan(
    2025,  -- fiscal_year
    2,     -- department_id (Pharmacy)
    1,     -- generic_id (Paracetamol)
    10000, -- requested_qty
    1      -- quarter (Q1)
);
```

**Result:**
```
in_plan | plan_item_id | planned_qty | remaining_qty | q_planned | q_purchased | q_remaining | over_plan | message
--------+--------------+-------------+---------------+-----------+-------------+-------------+-----------+------------------
  true  |      1       |   120000    |    110000     |   30000   |      0      |    30000    |   false   | Within budget plan
```

---

## ✅ Validation Rules

### 1. Budget Plan Creation

```sql
-- Must link to approved budget allocation
SELECT COUNT(*) FROM budget_allocations
WHERE id = :allocation_id
    AND status = 'active'
    AND fiscal_year = :fiscal_year;
-- Must return 1

-- Total planned must not exceed allocation
SELECT (
    :total_planned_budget <= ba.total_budget
) as valid
FROM budget_allocations ba
WHERE id = :allocation_id;
-- Must return true

-- Quarterly sum must equal total
SELECT (
    :q1_planned + :q2_planned + :q3_planned + :q4_planned = :total_planned
) as valid;
-- Must return true
```

### 2. Budget Plan Item Validation

```sql
-- Generic drug must exist and be active
SELECT id FROM drug_generics
WHERE id = :generic_id AND is_active = true;
-- Must return a row

-- Quantities must be positive
SELECT :planned_quantity > 0 AND :estimated_unit_cost > 0;
-- Must return true

-- Quarterly sum must equal total
SELECT (
    :q1_qty + :q2_qty + :q3_qty + :q4_qty = :planned_quantity
) as valid;
-- Must return true

-- Cost calculation must be correct
SELECT (
    :planned_quantity * :estimated_unit_cost = :planned_total_cost
) as valid;
-- Must return true
```

---

## 🚨 Alerts and Warnings

### Over-Utilization Alert

```sql
-- Drugs exceeding quarterly plan by >20%
SELECT
    dg.working_code,
    dg.drug_name,
    bpi.q1_quantity as planned,
    bpi.q1_purchased_qty as purchased,
    ROUND((bpi.q1_purchased_qty::DECIMAL / bpi.q1_quantity * 100), 2) as utilization_pct,
    (bpi.q1_purchased_qty - bpi.q1_quantity) as over_amount
FROM budget_plan_items bpi
JOIN budget_plans bp ON bpi.budget_plan_id = bp.id
JOIN drug_generics dg ON bpi.generic_id = dg.id
WHERE bp.fiscal_year = 2025
    AND bp.status = 'active'
    AND bpi.q1_purchased_qty > (bpi.q1_quantity * 1.2)
ORDER BY utilization_pct DESC;
```

### Under-Utilization Alert

```sql
-- Drugs with <50% utilization at mid-quarter
SELECT
    dg.working_code,
    dg.drug_name,
    bpi.q1_quantity as planned,
    bpi.q1_purchased_qty as purchased,
    ROUND((bpi.q1_purchased_qty::DECIMAL / bpi.q1_quantity * 100), 2) as utilization_pct,
    bpi.q1_quantity - bpi.q1_purchased_qty as remaining
FROM budget_plan_items bpi
JOIN budget_plans bp ON bpi.budget_plan_id = bp.id
JOIN drug_generics dg ON bpi.generic_id = dg.id
WHERE bp.fiscal_year = 2025
    AND bp.status = 'active'
    AND CURRENT_DATE > (DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '1 month 15 days')
    AND bpi.q1_purchased_qty < (bpi.q1_quantity * 0.5)
ORDER BY utilization_pct;
```

---

## 📈 Success Criteria

### ✅ Budget Planning Checklist

- [ ] Budget plan created and linked to allocation
- [ ] All high-volume drugs included (>1000 units/year)
- [ ] Historical data analyzed (3 years)
- [ ] Forecast method documented
- [ ] Quarterly distribution calculated
- [ ] Total planned ≤ total allocated
- [ ] Approved by department head and finance
- [ ] Status changed to ACTIVE
- [ ] Integrated with PR workflow
- [ ] Monthly variance reports generated

### Key Metrics

```
Metric                        | Target  | Current
------------------------------+---------+---------
Planning Coverage             | > 90%   | 95%
Budget Utilization (Annual)   | 85-95%  | 88%
Forecast Accuracy             | > 80%   | 85%
Variance from Plan            | < 15%   | 12%
On-time Budget Updates        | 100%    | 98%
Approval Cycle Time           | < 7 days| 5 days
```

---

## 🎯 Next Steps

**หลังจาก Budget Plan พร้อม:**

1. ✅ **Create Purchase Requests** - สร้าง PR ตาม plan
2. ✅ **Monitor Budget vs Actual** - ติดตามการใช้งบจริง
3. ✅ **Quarterly Review** - ทบทวนแผนทุกไตรมาส
4. ✅ **Adjust as Needed** - ปรับแผนตามความเป็นจริง
5. ✅ **Year-end Analysis** - วิเคราะห์เพื่อวางแผนปีถัดไป

---

## 📞 Related Documentation

- **[FLOW_02_Budget_Management.md](./FLOW_02_Budget_Management.md)** - Budget Allocation
- **[FLOW_03_Procurement_Part1_PR.md](./FLOW_03_Procurement_Part1_PR.md)** - Purchase Request
- **[prisma/schema.prisma](../../prisma/schema.prisma)** - Database schema

---

**Status**: ✅ Complete - Schema ready, functions to be implemented
**Last Updated**: 2025-01-11

*Created with ❤️ for INVS Modern Team*
