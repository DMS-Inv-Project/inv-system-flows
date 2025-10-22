# FLOW 05: Drug Distribution
## การจ่ายยาให้หน่วยงาน - Department Distribution System

**Version**: 1.0.0
**Last Updated**: 2025-01-11
**Status**: ✅ Complete

---

## 🎯 Overview

ระบบจ่ายยาจากคลังหลัก/ห้องยาไปยังหน่วยงานต่างๆ ในโรงพยาบาล พร้อมระบบ FEFO และการติดตาม Lot อัตโนมัติ

### Key Features

```
✅ Department-based Distribution
✅ FEFO Lot Selection (First Expire First Out)
✅ Multi-item Distribution
✅ Automatic Inventory Update
✅ Complete Audit Trail
✅ Return/Cancel Support
```

---

## 📊 Distribution Tables (2 tables)

```
┌────────────────────────────────────────┐
│        DRUG DISTRIBUTION               │
└────────────────────────────────────────┘

┌──────────────────────┐
│ drug_distributions   │  ← Distribution Header
│ ───────────────────  │
│ • distribution_number│
│ • distribution_date  │
│ • from_location_id   │
│ • to_location_id     │
│ • requesting_dept_id │
│ • status             │
│ • total_items        │
└──────────────────────┘
         ↓ 1:N
┌──────────────────────┐
│ drug_distribution_   │  ← Distribution Items
│ items                │
│ ───────────────────  │
│ • drug_id            │
│ • lot_number         │
│ • quantity_dispensed │
│ • unit_cost          │
│ • expiry_date        │
└──────────────────────┘
```

---

## 🔄 Complete Distribution Flow

```
1. Department Request
   ├─> Ward/Department identifies need
   └─> Requests drugs from pharmacy/warehouse

2. Create Distribution (Draft)
   ├─> From Location (source)
   ├─> To Location (destination)
   ├─> Requesting Department
   └─> List of drugs needed

3. Check Stock Availability
   └─> Query inventory for each drug

4. Select Lots (FEFO)
   ├─> Call get_fefo_lots() for each drug
   └─> Prioritize earliest expiry

5. Approve Distribution
   ├─> Verify quantities
   ├─> Confirm lot selection
   └─> Status: APPROVED

6. Dispense Drugs
   ├─> Update drug_lots (reduce quantity)
   ├─> Update inventory (reduce stock)
   ├─> Create transactions
   └─> Status: DISPENSED

7. Receive at Department
   └─> Acknowledge receipt
   └─> Status: RECEIVED
```

---

## 📝 FLOW 05.1: Create Distribution Request

### Example: Emergency Department Requests Drugs

```sql
-- Step 1: Create Distribution Header
INSERT INTO drug_distributions (
    distribution_number,
    distribution_date,
    from_location_id,
    to_location_id,
    requesting_dept_id,
    purpose,
    urgency,
    requested_by,
    status,
    total_items,
    notes,
    created_at
) VALUES (
    'DIST-2025-001',
    CURRENT_DATE,
    1, -- Main Warehouse
    3, -- Emergency Ward
    4, -- Medical Department
    'Emergency stock replenishment',
    'urgent',
    'Emergency Nurse',
    'pending',
    3,
    'Urgent request for high-demand drugs',
    CURRENT_TIMESTAMP
) RETURNING id;

-- Step 2: Add Distribution Items (what they need)
INSERT INTO drug_distribution_items (
    distribution_id,
    item_number,
    drug_id,
    quantity_requested,
    purpose_detail
) VALUES
(1, 1, 1, 500, 'ER stock - Paracetamol'),
(1, 2, 5, 200, 'ER stock - Amoxicillin'),
(1, 3, 8, 100, 'ER stock - Omeprazole');
```

---

## 🎯 FLOW 05.2: Select Lots (FEFO)

### Using get_fefo_lots() Function

```sql
-- For each drug, get lots in FEFO order
SELECT * FROM get_fefo_lots(
    p_drug_id := 1,  -- Paracetamol
    p_location_id := 1,  -- Main Warehouse
    p_quantity_needed := 500
);
```

**Result:**
```
lot_id | lot_number       | quantity_available | quantity_to_dispense | expiry_date | days_until_expiry
-------+------------------+--------------------+----------------------+-------------+------------------
   1   | LOT-PAR-2025-001 |      5000          |         500          | 2027-12-31  |       1080
```

### Update Distribution Items with Lot Info

```sql
-- Update items with selected lot information
UPDATE drug_distribution_items
SET
    lot_number = 'LOT-PAR-2025-001',
    quantity_dispensed = 500,
    unit_cost = 2.50,
    total_cost = 1250.00,
    expiry_date = '2027-12-31'
WHERE distribution_id = 1 AND item_number = 1;

-- Repeat for other items...
```

---

## 📦 FLOW 05.3: Approve & Dispense

```sql
-- Step 1: Approve Distribution
UPDATE drug_distributions
SET
    status = 'approved',
    approved_by = 'Pharmacy Manager',
    approval_date = CURRENT_TIMESTAMP,
    total_amount = (
        SELECT SUM(total_cost)
        FROM drug_distribution_items
        WHERE distribution_id = 1
    )
WHERE id = 1;

-- Step 2: Dispense (Update Inventory)
-- For each item:

-- 2.1: Reduce Lot Quantity
UPDATE drug_lots
SET
    quantity_available = quantity_available - 500,
    is_active = CASE
        WHEN (quantity_available - 500) <= 0 THEN false
        ELSE true
    END,
    updated_at = CURRENT_TIMESTAMP
WHERE lot_number = 'LOT-PAR-2025-001' AND location_id = 1;

-- 2.2: Update Inventory Summary
UPDATE inventory
SET
    quantity_on_hand = quantity_on_hand - 500,
    last_updated = CURRENT_TIMESTAMP
WHERE drug_id = 1 AND location_id = 1;

-- 2.3: Create Transaction Log
INSERT INTO inventory_transactions (
    inventory_id,
    transaction_type,
    quantity,
    unit_cost,
    reference_id,
    reference_type,
    lot_number,
    notes,
    created_by,
    created_at
) VALUES (
    1,
    'issue',
    -500,
    2.50,
    1,
    'DISTRIBUTION',
    'LOT-PAR-2025-001',
    'DIST-2025-001 to Emergency Department',
    1,
    CURRENT_TIMESTAMP
);

-- Step 3: Mark as Dispensed
UPDATE drug_distributions
SET
    status = 'dispensed',
    dispensed_by = 'Pharmacist A',
    dispensed_date = CURRENT_TIMESTAMP
WHERE id = 1;
```

---

## 🎯 UI Mockup: Distribution Request Form

```
┌────────────────────────────────────────────────────────────────────┐
│  Create Distribution Request                                [X]    │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Distribution Information                                           │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Distribution Number: DIST-2025-001 (auto)                   │  │
│  │ Date: [2025-02-01]                                          │  │
│  │                                                             │  │
│  │ From Location:  [Main Warehouse ▼]                         │  │
│  │ To Location:    [Emergency Ward ▼]                         │  │
│  │ Requesting Dept:[Medical Dept ▼]                           │  │
│  │                                                             │  │
│  │ Purpose: [Emergency stock replenishment                  ]  │  │
│  │ Urgency: [⚠️ Urgent ▼]                                     │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  Requested Items                             [+ Add Drug]          │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ # │ Drug Name          │ Qty Requested │ Available │ Action │  │
│  ├───┼────────────────────┼───────────────┼───────────┼────────┤  │
│  │ 1 │ Paracetamol 500mg  │    500        │   5,000   │  [X]   │  │
│  │ 2 │ Amoxicillin 250mg  │    200        │   3,000   │  [X]   │  │
│  │ 3 │ Omeprazole 20mg    │    100        │   1,500   │  [X]   │  │
│  └───┴────────────────────┴───────────────┴───────────┴────────┘  │
│                                                                     │
│  Notes                                                              │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Urgent request for ER stock replenishment                   │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
│             [Cancel]  [Save as Draft]  [Submit Request]            │
└────────────────────────────────────────────────────────────────────┘
```

---

## 🎯 UI Mockup: Distribution Approval

```
┌────────────────────────────────────────────────────────────────────┐
│  Distribution Request - DIST-2025-001                  [Approve]   │
├────────────────────────────────────────────────────────────────────┤
│  Status: 🟡 Pending Approval                                       │
│  From: Main Warehouse → To: Emergency Ward                         │
│  Requested by: Emergency Nurse (Medical Dept)                      │
│  Date: 2025-02-01  Urgency: ⚠️ Urgent                             │
│                                                                     │
│  Items with Auto-Selected Lots (FEFO)                              │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Drug              │ Qty │ Lot Number       │ Expiry  │ Cost  │  │
│  ├───────────────────┼─────┼──────────────────┼─────────┼───────┤  │
│  │ Paracetamol 500mg │ 500 │ LOT-PAR-2025-001 │2027-12  │1,250฿ │  │
│  │ Amoxicillin 250mg │ 200 │ LOT-AMX-2025-001 │2026-06  │2,100฿ │  │
│  │ Omeprazole 20mg   │ 100 │ LOT-OME-2025-001 │2026-12  │1,500฿ │  │
│  │                   │     │                  │ Total:  │4,850฿ │  │
│  └───────────────────┴─────┴──────────────────┴─────────┴───────┘  │
│                                                                     │
│  ✅ All items available                                            │
│  ✅ No expiry concerns (all > 180 days)                           │
│  ✅ FEFO order applied                                            │
│                                                                     │
│  Approval Notes                                                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ [Approved for urgent ER needs                             ]  │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
│           [Reject]  [Request Changes]  [✓ Approve & Dispense]     │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Distribution Status Workflow

```
PENDING      → Request created, waiting approval
    ↓
APPROVED     → Approved by pharmacy manager
    ↓
DISPENSED    → Drugs dispensed, inventory updated
    ↓
RECEIVED     → Acknowledged by receiving department
    ↓
CLOSED       → Transaction complete
```

**Cancellation/Return:**
```
Any Status → CANCELLED  (before dispensed)
DISPENSED  → RETURNED   (partial/full return)
```

---

## 🔍 Monitoring Queries

```sql
-- Active distribution requests
SELECT
    d.distribution_number,
    d.distribution_date,
    lf.location_name as from_location,
    lt.location_name as to_location,
    dept.dept_name as requesting_dept,
    d.status,
    d.urgency,
    d.total_items,
    d.total_amount,
    d.requested_by
FROM drug_distributions d
JOIN locations lf ON d.from_location_id = lf.id
JOIN locations lt ON d.to_location_id = lt.id
JOIN departments dept ON d.requesting_dept_id = dept.id
WHERE d.status IN ('pending', 'approved')
ORDER BY
    CASE d.urgency
        WHEN 'critical' THEN 1
        WHEN 'urgent' THEN 2
        WHEN 'normal' THEN 3
    END,
    d.distribution_date;

-- Distribution by department (monthly)
SELECT
    dept.dept_name,
    COUNT(d.id) as total_distributions,
    SUM(d.total_amount) as total_cost,
    AVG(d.total_items) as avg_items_per_distribution
FROM drug_distributions d
JOIN departments dept ON d.requesting_dept_id = dept.id
WHERE d.distribution_date >= DATE_TRUNC('month', CURRENT_DATE)
    AND d.status = 'dispensed'
GROUP BY dept.dept_name
ORDER BY total_cost DESC;
```

---

## ✅ Implementation Checklist

### Database
- [x] `drug_distributions` table
- [x] `drug_distribution_items` table
- [x] Integration with `get_fefo_lots()` function
- [x] Automatic inventory updates
- [x] Transaction logging

### Backend API (To Do)
- [ ] POST `/api/distributions` - Create distribution request
- [ ] GET `/api/distributions` - List distributions
- [ ] GET `/api/distributions/:id` - Get details
- [ ] PUT `/api/distributions/:id/approve` - Approve
- [ ] PUT `/api/distributions/:id/dispense` - Dispense
- [ ] PUT `/api/distributions/:id/receive` - Mark as received
- [ ] POST `/api/distributions/:id/cancel` - Cancel
- [ ] POST `/api/distributions/:id/return` - Process return

### Frontend (To Do)
- [ ] Distribution request form
- [ ] Approval screen with FEFO lot display
- [ ] Distribution list with filters
- [ ] Department distribution dashboard
- [ ] Return/cancel interface

---

## 📞 Related Documentation

- **[FLOW_04_Inventory_Management.md](./FLOW_04_Inventory_Management.md)** - Inventory & FEFO
- **[prisma/functions.sql](../../prisma/functions.sql)** - get_fefo_lots() function
- **[prisma/schema.prisma](../../prisma/schema.prisma)** - Database schema

---

**Status**: ✅ Complete - Ready for Implementation
**Last Updated**: 2025-01-11

*Created with ❤️ for INVS Modern Team*
