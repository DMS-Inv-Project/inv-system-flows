# FLOW 04: Inventory Management
## การจัดการคลังยา - FIFO/FEFO และ Multi-location

**Version**: 1.0.0
**Last Updated**: 2025-01-11
**Status**: ✅ Complete

---

## 🎯 Overview

ระบบจัดการคลังยาแบบครบวงจร รองรับการติดตาม Stock หลาย Location พร้อมระบบ FIFO/FEFO สำหรับการจ่ายยาอย่างมีประสิทธิภาพ

### Key Features

```
✅ Multi-location Inventory Tracking
✅ FIFO (First In First Out) Management
✅ FEFO (First Expire First Out) Management
✅ Lot-based Tracking with Expiry Dates
✅ Reorder Point Alerts
✅ Low Stock Warnings
✅ Expiry Date Monitoring
✅ Average Cost Calculation (Weighted Average)
✅ Complete Transaction Audit Trail
```

---

## 📊 System Architecture

### Inventory Tables (3 tables)

```
┌─────────────────────────────────────────────────────┐
│               INVENTORY MANAGEMENT                   │
└─────────────────────────────────────────────────────┘

┌──────────────────┐
│   inventory      │  ← Stock Level per Drug/Location
│   ─────────────  │
│   • drug_id      │
│   • location_id  │
│   • quantity_on_hand
│   • min_level    │
│   • max_level    │
│   • reorder_point│
│   • average_cost │
└──────────────────┘
         ↓
┌──────────────────┐
│   drug_lots      │  ← FIFO/FEFO Lot Tracking
│   ─────────────  │
│   • lot_number   │
│   • drug_id      │
│   • location_id  │
│   • quantity_available
│   • unit_cost    │
│   • expiry_date  │
│   • receive_date │
└──────────────────┘
         ↓
┌──────────────────┐
│ inventory_       │  ← Complete Audit Trail
│ transactions     │
│   ─────────────  │
│   • transaction_type
│   • quantity     │
│   • reference_id │
│   • created_at   │
└──────────────────┘
```

---

## 🏢 Storage Locations

### Location Types

```sql
SELECT * FROM locations ORDER BY location_code;
```

**Result:**
```
id | location_code | location_name        | location_type | is_active
---+---------------+---------------------+---------------+----------
 1 | WH-MAIN       | Main Warehouse      | WAREHOUSE     | true
 2 | PH-CENTRAL    | Central Pharmacy    | PHARMACY      | true
 3 | WARD-EMERG    | Emergency Ward      | WARD          | true
 4 | WARD-ICU      | ICU                 | WARD          | true
 5 | WARD-OPD      | OPD                 | WARD          | true
```

### Location Hierarchy

```
WAREHOUSE (คลังหลัก)
    ↓ Transfer
PHARMACY (ห้องยา)
    ↓ Dispense
WARD (หอผู้ป่วย)
    • Emergency
    • ICU
    • OPD
    • Medical
    • Surgical
```

---

## 📦 Inventory Operations

### Transaction Types

| Type | Direction | Description | Use Case |
|------|-----------|-------------|----------|
| **RECEIVE** | + | รับเข้าคลัง | จาก Purchase Order |
| **ISSUE** | - | จ่ายออก | จ่ายให้หน่วยงาน |
| **TRANSFER** | +/- | โอนระหว่าง location | คลัง → ห้องยา |
| **ADJUST** | +/- | ปรับยอด | Stock count, ตรวจนับ |
| **RETURN** | + | รับคืน | ยาคืนจากหน่วยงาน |

---

## 🔄 FLOW 04.1: Receive Drugs (from Purchase Order)

### Flow Diagram

```
Receipt Posted
    ↓
Create Drug Lots
    ├─> lot_number (unique)
    ├─> quantity_available
    ├─> unit_cost
    ├─> expiry_date
    └─> receive_date
    ↓
Update Inventory Summary
    ├─> quantity_on_hand += quantity
    ├─> average_cost (weighted)
    └─> last_updated
    ↓
Create Transaction Log
    ├─> type: RECEIVE
    ├─> reference: receipt_id
    └─> audit trail
```

### Example: Receive Paracetamol

```sql
-- Step 1: Create Drug Lot (from receipt posting)
INSERT INTO drug_lots (
    lot_number,
    drug_id,
    location_id,
    quantity_original,
    quantity_available,
    unit_cost,
    receive_date,
    expiry_date,
    receipt_id,
    po_id,
    supplier_lot_number,
    is_active
) VALUES (
    'LOT-PAR-2025-001',
    1, -- Paracetamol
    1, -- Main Warehouse
    10000,
    10000,
    2.50,
    '2025-01-30',
    '2027-12-31',
    1,
    1,
    'GPO-PAR-20250130',
    true
) RETURNING id;

-- Step 2: Update Inventory Summary
INSERT INTO inventory (
    drug_id,
    location_id,
    quantity_on_hand,
    average_cost,
    min_level,
    max_level,
    reorder_point,
    last_updated
) VALUES (
    1, 1, 10000, 2.50, 1000, 20000, 2000, CURRENT_TIMESTAMP
)
ON CONFLICT (drug_id, location_id)
DO UPDATE SET
    quantity_on_hand = inventory.quantity_on_hand + 10000,
    average_cost = (
        (inventory.quantity_on_hand * inventory.average_cost) +
        (10000 * 2.50)
    ) / (inventory.quantity_on_hand + 10000),
    last_updated = CURRENT_TIMESTAMP;

-- Step 3: Create Transaction Log
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
    'receive',
    10000,
    2.50,
    1,
    'RECEIPT',
    'LOT-PAR-2025-001',
    'Received from PO-2025-001',
    1,
    CURRENT_TIMESTAMP
);
```

### Result: Inventory State

```sql
SELECT
    d.drug_code,
    d.trade_name,
    inv.quantity_on_hand,
    inv.average_cost,
    inv.min_level,
    inv.reorder_point,
    COUNT(dl.id) as active_lots
FROM inventory inv
JOIN drugs d ON inv.drug_id = d.id
LEFT JOIN drug_lots dl ON d.id = dl.drug_id
    AND dl.location_id = inv.location_id
    AND dl.is_active = true
WHERE inv.location_id = 1
GROUP BY d.drug_code, d.trade_name, inv.quantity_on_hand,
         inv.average_cost, inv.min_level, inv.reorder_point;
```

**Result:**
```
drug_code           | trade_name              | quantity_on_hand | average_cost | min_level | reorder_point | active_lots
--------------------+-------------------------+------------------+--------------+-----------+---------------+------------
PAR0001-000001-001  | GPO Paracetamol 500mg   |     10000        |    2.50      |   1000    |     2000      |     1
```

---

## 🎯 FLOW 04.2: FIFO/FEFO Management

### Database Functions

#### 1. get_fifo_lots() - First In First Out

```sql
CREATE OR REPLACE FUNCTION get_fifo_lots(
    p_drug_id BIGINT,
    p_location_id BIGINT,
    p_quantity_needed DECIMAL
)
RETURNS TABLE (
    lot_id BIGINT,
    lot_number VARCHAR,
    quantity_available DECIMAL,
    quantity_to_dispense DECIMAL,
    unit_cost DECIMAL,
    receive_date DATE,
    expiry_date DATE,
    days_until_expiry INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        dl.id,
        dl.lot_number,
        dl.quantity_available,
        CASE
            WHEN SUM(dl.quantity_available) OVER (ORDER BY dl.receive_date) <= p_quantity_needed
            THEN dl.quantity_available
            ELSE GREATEST(0, p_quantity_needed - COALESCE(
                SUM(dl.quantity_available) OVER (
                    ORDER BY dl.receive_date
                    ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                ), 0
            ))
        END as quantity_to_dispense,
        dl.unit_cost,
        dl.receive_date,
        dl.expiry_date,
        (dl.expiry_date - CURRENT_DATE)::INTEGER as days_until_expiry
    FROM drug_lots dl
    WHERE dl.drug_id = p_drug_id
        AND dl.location_id = p_location_id
        AND dl.is_active = true
        AND dl.quantity_available > 0
    ORDER BY dl.receive_date ASC, dl.id ASC;
END;
$$ LANGUAGE plpgsql;
```

#### 2. get_fefo_lots() - First Expire First Out

```sql
CREATE OR REPLACE FUNCTION get_fefo_lots(
    p_drug_id BIGINT,
    p_location_id BIGINT,
    p_quantity_needed DECIMAL
)
RETURNS TABLE (
    lot_id BIGINT,
    lot_number VARCHAR,
    quantity_available DECIMAL,
    quantity_to_dispense DECIMAL,
    unit_cost DECIMAL,
    expiry_date DATE,
    receive_date DATE,
    days_until_expiry INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        dl.id,
        dl.lot_number,
        dl.quantity_available,
        CASE
            WHEN SUM(dl.quantity_available) OVER (ORDER BY dl.expiry_date) <= p_quantity_needed
            THEN dl.quantity_available
            ELSE GREATEST(0, p_quantity_needed - COALESCE(
                SUM(dl.quantity_available) OVER (
                    ORDER BY dl.expiry_date
                    ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                ), 0
            ))
        END as quantity_to_dispense,
        dl.unit_cost,
        dl.expiry_date,
        dl.receive_date,
        (dl.expiry_date - CURRENT_DATE)::INTEGER as days_until_expiry
    FROM drug_lots dl
    WHERE dl.drug_id = p_drug_id
        AND dl.location_id = p_location_id
        AND dl.is_active = true
        AND dl.quantity_available > 0
        AND dl.expiry_date > CURRENT_DATE
    ORDER BY dl.expiry_date ASC, dl.receive_date ASC, dl.id ASC;
END;
$$ LANGUAGE plpgsql;
```

### Example: Get Lots for Dispensing

```sql
-- FIFO: Get oldest lots first
SELECT * FROM get_fifo_lots(
    p_drug_id := 1,
    p_location_id := 1,
    p_quantity_needed := 5000
);
```

**Result:**
```
lot_id | lot_number       | quantity_available | quantity_to_dispense | unit_cost | receive_date | expiry_date | days_until_expiry
-------+------------------+--------------------+----------------------+-----------+--------------+-------------+------------------
   1   | LOT-PAR-2025-001 |      10000         |         5000         |   2.50    | 2025-01-30   | 2027-12-31  |       1080
```

```sql
-- FEFO: Get earliest expiring lots first
SELECT * FROM get_fefo_lots(
    p_drug_id := 1,
    p_location_id := 1,
    p_quantity_needed := 5000
);
```

---

## 🔄 FLOW 04.3: Issue Drugs (Distribution)

### Flow Diagram

```
Distribution Request
    ↓
Check Stock Availability
    └─> Query inventory
    ↓
Select Lots (FEFO)
    └─> Call get_fefo_lots()
    ↓
Reduce Lot Quantities
    ├─> Update drug_lots.quantity_available
    └─> Set is_active = false if depleted
    ↓
Update Inventory Summary
    ├─> quantity_on_hand -= quantity
    └─> last_updated
    ↓
Create Transaction Log
    ├─> type: ISSUE
    └─> reference: distribution_id
```

### Example: Issue 5000 tablets

```sql
-- Step 1: Get lots to dispense (FEFO)
SELECT * FROM get_fefo_lots(1, 1, 5000);

-- Step 2: Reduce lot quantity
UPDATE drug_lots
SET
    quantity_available = quantity_available - 5000,
    is_active = CASE
        WHEN (quantity_available - 5000) <= 0 THEN false
        ELSE true
    END,
    updated_at = CURRENT_TIMESTAMP
WHERE lot_number = 'LOT-PAR-2025-001';

-- Step 3: Update inventory summary
UPDATE inventory
SET
    quantity_on_hand = quantity_on_hand - 5000,
    last_updated = CURRENT_TIMESTAMP
WHERE drug_id = 1 AND location_id = 1;

-- Step 4: Create transaction log
INSERT INTO inventory_transactions (
    inventory_id,
    transaction_type,
    quantity,
    unit_cost,
    reference_id,
    reference_type,
    lot_number,
    notes,
    created_by
) VALUES (
    1,
    'issue',
    -5000,
    2.50,
    1,
    'DISTRIBUTION',
    'LOT-PAR-2025-001',
    'Issued to Emergency Dept (DIST-2025-001)',
    1
);
```

### Result: Updated Inventory

```sql
SELECT * FROM inventory WHERE drug_id = 1 AND location_id = 1;
```

**Result:**
```
drug_id | location_id | quantity_on_hand | average_cost | min_level | max_level | reorder_point
--------+-------------+------------------+--------------+-----------+-----------+--------------
   1    |      1      |      5000        |    2.50      |   1000    |   20000   |    2000
```

---

## 📊 FLOW 04.4: Stock Monitoring & Alerts

### Monitoring Views

#### 1. Low Stock Items

```sql
CREATE VIEW low_stock_items AS
SELECT
    d.drug_code,
    d.trade_name,
    dg.generic_name,
    l.location_name,
    inv.quantity_on_hand,
    inv.min_level,
    inv.reorder_point,
    inv.max_level,
    CASE
        WHEN inv.quantity_on_hand = 0 THEN 'OUT_OF_STOCK'
        WHEN inv.quantity_on_hand <= inv.min_level THEN 'CRITICAL'
        WHEN inv.quantity_on_hand <= inv.reorder_point THEN 'LOW'
        ELSE 'NORMAL'
    END as stock_level,
    (inv.reorder_point - inv.quantity_on_hand) as quantity_to_order
FROM inventory inv
JOIN drugs d ON inv.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN locations l ON inv.location_id = l.id
WHERE inv.quantity_on_hand <= inv.reorder_point
ORDER BY
    CASE
        WHEN inv.quantity_on_hand = 0 THEN 1
        WHEN inv.quantity_on_hand <= inv.min_level THEN 2
        ELSE 3
    END,
    inv.quantity_on_hand ASC;
```

#### 2. Expiring Drugs

```sql
CREATE VIEW expiring_drugs AS
SELECT
    dl.lot_number,
    d.drug_code,
    d.trade_name,
    dg.generic_name,
    l.location_name,
    dl.quantity_available,
    dl.unit_cost,
    dl.expiry_date,
    (dl.expiry_date - CURRENT_DATE)::INTEGER as days_until_expiry,
    CASE
        WHEN dl.expiry_date <= CURRENT_DATE THEN 'EXPIRED'
        WHEN dl.expiry_date <= CURRENT_DATE + INTERVAL '30 days' THEN 'CRITICAL'
        WHEN dl.expiry_date <= CURRENT_DATE + INTERVAL '90 days' THEN 'WARNING'
        WHEN dl.expiry_date <= CURRENT_DATE + INTERVAL '180 days' THEN 'WATCH'
        ELSE 'NORMAL'
    END as urgency_level,
    (dl.quantity_available * dl.unit_cost) as value_at_risk
FROM drug_lots dl
JOIN drugs d ON dl.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN locations l ON dl.location_id = l.id
WHERE dl.is_active = true
    AND dl.quantity_available > 0
    AND dl.expiry_date <= CURRENT_DATE + INTERVAL '180 days'
ORDER BY
    CASE
        WHEN dl.expiry_date <= CURRENT_DATE THEN 1
        WHEN dl.expiry_date <= CURRENT_DATE + INTERVAL '30 days' THEN 2
        WHEN dl.expiry_date <= CURRENT_DATE + INTERVAL '90 days' THEN 3
        ELSE 4
    END,
    dl.expiry_date ASC;
```

#### 3. Current Stock Summary

```sql
CREATE VIEW current_stock_summary AS
SELECT
    l.location_code,
    l.location_name,
    d.drug_code,
    d.trade_name,
    dg.generic_name,
    inv.quantity_on_hand,
    inv.average_cost,
    (inv.quantity_on_hand * inv.average_cost) as total_value,
    inv.min_level,
    inv.max_level,
    inv.reorder_point,
    COUNT(DISTINCT dl.id) as active_lots,
    MIN(dl.expiry_date) as earliest_expiry,
    MAX(dl.expiry_date) as latest_expiry
FROM inventory inv
JOIN drugs d ON inv.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN locations l ON inv.location_id = l.id
LEFT JOIN drug_lots dl ON d.id = dl.drug_id
    AND dl.location_id = inv.location_id
    AND dl.is_active = true
    AND dl.quantity_available > 0
WHERE inv.quantity_on_hand > 0
GROUP BY
    l.location_code, l.location_name,
    d.drug_code, d.trade_name, dg.generic_name,
    inv.quantity_on_hand, inv.average_cost,
    inv.min_level, inv.max_level, inv.reorder_point
ORDER BY l.location_code, d.drug_code;
```

### Query Examples

```sql
-- Critical low stock items
SELECT * FROM low_stock_items
WHERE stock_level IN ('OUT_OF_STOCK', 'CRITICAL');

-- Drugs expiring in 30 days
SELECT * FROM expiring_drugs
WHERE urgency_level = 'CRITICAL'
ORDER BY days_until_expiry;

-- Stock value by location
SELECT
    location_name,
    COUNT(*) as total_drugs,
    SUM(total_value) as total_inventory_value
FROM current_stock_summary
GROUP BY location_name
ORDER BY total_inventory_value DESC;
```

---

## 🔄 FLOW 04.5: Stock Transfer Between Locations

### Flow Diagram

```
Transfer Request
    ├─> From: Warehouse
    └─> To: Pharmacy
    ↓
Check Source Stock
    └─> Verify availability
    ↓
Select Lots (FEFO)
    └─> From source location
    ↓
Reduce Source
    ├─> Update source drug_lots
    ├─> Update source inventory
    └─> Create ISSUE transaction
    ↓
Increase Destination
    ├─> Create/Update destination drug_lots
    ├─> Update destination inventory
    └─> Create RECEIVE transaction
```

### Example: Transfer Paracetamol

```sql
-- Step 1: Reduce from Warehouse (location_id = 1)
-- (Same as ISSUE operation)
UPDATE drug_lots
SET quantity_available = quantity_available - 2000
WHERE lot_number = 'LOT-PAR-2025-001' AND location_id = 1;

UPDATE inventory
SET quantity_on_hand = quantity_on_hand - 2000
WHERE drug_id = 1 AND location_id = 1;

INSERT INTO inventory_transactions (
    inventory_id, transaction_type, quantity, unit_cost,
    reference_type, lot_number, notes, created_by
) VALUES (
    1, 'transfer_out', -2000, 2.50,
    'TRANSFER', 'LOT-PAR-2025-001', 'Transfer to Central Pharmacy', 1
);

-- Step 2: Add to Pharmacy (location_id = 2)
INSERT INTO drug_lots (
    lot_number, drug_id, location_id,
    quantity_original, quantity_available,
    unit_cost, receive_date, expiry_date, is_active
) VALUES (
    'LOT-PAR-2025-001', 1, 2,
    2000, 2000, 2.50,
    CURRENT_DATE, '2027-12-31', true
);

INSERT INTO inventory (
    drug_id, location_id, quantity_on_hand, average_cost
) VALUES (1, 2, 2000, 2.50)
ON CONFLICT (drug_id, location_id)
DO UPDATE SET
    quantity_on_hand = inventory.quantity_on_hand + 2000,
    average_cost = (
        (inventory.quantity_on_hand * inventory.average_cost) + (2000 * 2.50)
    ) / (inventory.quantity_on_hand + 2000);

INSERT INTO inventory_transactions (
    inventory_id, transaction_type, quantity, unit_cost,
    reference_type, lot_number, notes, created_by
) VALUES (
    2, 'transfer_in', 2000, 2.50,
    'TRANSFER', 'LOT-PAR-2025-001', 'Transfer from Main Warehouse', 1
);
```

---

## 🎯 UI Mockup: Inventory Dashboard

```
┌────────────────────────────────────────────────────────────────────┐
│  INVS Modern - Inventory Dashboard                    🔍 [Search]  │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  📊 Summary Cards                                                   │
│  ┌──────────────┬──────────────┬──────────────┬──────────────┐    │
│  │ Total Items  │ Low Stock    │ Expiring Soon│ Out of Stock │    │
│  │    842       │     12       │      5       │      3       │    │
│  │              │  ⚠️ Warning  │  🔴 Critical │  ❌ Empty    │    │
│  └──────────────┴──────────────┴──────────────┴──────────────┘    │
│                                                                     │
│  🔔 Alerts (17)                                     [View All →]   │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ 🔴 Amoxicillin 250mg - OUT OF STOCK (Main Warehouse)       │  │
│  │ ⚠️  Paracetamol 500mg - Below reorder point (1500/2000)    │  │
│  │ 🟡 Omeprazole 20mg - Expiring in 25 days (Lot: OME-001)    │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  📦 Inventory by Location                     [+ Transfer Stock]   │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Location        │ Total Items │ Total Value │ Low Stock     │  │
│  ├─────────────────┼─────────────┼─────────────┼───────────────┤  │
│  │ Main Warehouse  │     324     │  2.5M ฿     │      5        │  │
│  │ Central Pharmacy│     198     │  1.2M ฿     │      3        │  │
│  │ Emergency Ward  │      85     │  420K ฿     │      2        │  │
│  │ ICU             │      92     │  680K ฿     │      1        │  │
│  │ OPD             │     143     │  520K ฿     │      1        │  │
│  └─────────────────┴─────────────┴─────────────┴───────────────┘  │
│                                                                     │
│  📋 Stock List                    [Filter ▼] [Export CSV] [Print] │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Drug Code  │ Drug Name          │ QOH  │ Min  │ Lots│ Status│  │
│  ├────────────┼────────────────────┼──────┼──────┼─────┼───────┤  │
│  │ PAR0001-.. │ Paracetamol 500mg  │ 5000 │ 1000 │  1  │ ✅ OK │  │
│  │ AMX0001-.. │ Amoxicillin 250mg  │    0 │ 500  │  0  │ ❌ OUT│  │
│  │ IBU0001-.. │ Ibuprofen 400mg    │ 1200 │ 800  │  2  │ ⚠️ LOW│  │
│  │ OME0001-.. │ Omeprazole 20mg    │ 3500 │ 1000 │  1  │ 🟡 EXP│  │
│  └────────────┴────────────────────┴──────┴──────┴─────┴───────┘  │
│                                           [1] 2 3 ... 10  Next →  │
└────────────────────────────────────────────────────────────────────┘
```

---

## 🎯 UI Mockup: Lot Details View

```
┌────────────────────────────────────────────────────────────────────┐
│  ← Back to Inventory          PAR0001-000001-001                   │
│  GPO Paracetamol 500mg (500mg Tablet)                             │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  📊 Stock Summary                                                   │
│  ┌──────────────┬──────────────┬──────────────┬──────────────┐    │
│  │ Total Stock  │ Avg Cost     │ Active Lots  │ Total Value  │    │
│  │   5,000 tabs │  2.50 ฿/tab  │      1       │  12,500 ฿    │    │
│  └──────────────┴──────────────┴──────────────┴──────────────┘    │
│                                                                     │
│  📦 Lot Details (FEFO Order)                                       │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Lot Number       │ Qty Available│ Expiry Date│ Days Left    │  │
│  ├──────────────────┼──────────────┼────────────┼──────────────┤  │
│  │ LOT-PAR-2025-001 │    5,000     │ 2027-12-31 │ 1080 days   │  │
│  │                  │              │            │ ✅ Good      │  │
│  └──────────────────┴──────────────┴────────────┴──────────────┘  │
│                                                                     │
│  📈 Stock Movement (Last 30 days)                                  │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │     ▲                                                         │  │
│  │10K  █                                                         │  │
│  │ 8K  █                                                         │  │
│  │ 6K  █     ▄                                                   │  │
│  │ 4K  █     █                                                   │  │
│  │ 2K  █▄    █▄                                                  │  │
│  │  0  ┴─────┴─────────────────────────────────────────────────→│  │
│  │     01/01 01/15 01/30                                         │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  📋 Recent Transactions                         [View All →]       │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Date       │ Type    │ Qty    │ Ref          │ Balance      │  │
│  ├────────────┼─────────┼────────┼──────────────┼──────────────┤  │
│  │ 2025-01-30 │ RECEIVE │ +10000 │ RC-2025-001  │ 10,000       │  │
│  │ 2025-02-01 │ ISSUE   │ -5000  │ DIST-2025-001│  5,000       │  │
│  └────────────┴─────────┴────────┴──────────────┴──────────────┘  │
│                                                                     │
│  [View Full History] [Transfer Stock] [Adjust Stock] [Print]      │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Business Rules

### Stock Level Thresholds

```typescript
interface StockThresholds {
  min_level: number        // ระดับต่ำสุด (จะเตือน)
  max_level: number        // ระดับสูงสุด (ไม่เกิน)
  reorder_point: number    // จุดสั่งซื้อ (เมื่อต่ำกว่านี้ต้องสั่ง)
  safety_stock: number     // Stock สำรอง (นอกเหนือ min)
}

// Calculation
reorder_point = min_level + safety_stock
max_level = reorder_point * 2.5 (โดยประมาณ)
```

### FIFO vs FEFO Selection

```typescript
// When to use FIFO
- General inventory operations
- Non-perishable items
- Standard transfers

// When to use FEFO
- Drug dispensing (always!)
- Distribution to wards
- Patient-facing operations
- Items approaching expiry
```

### Average Cost Calculation

```sql
-- Weighted Average Method
new_average_cost = (
    (old_quantity * old_cost) + (new_quantity * new_cost)
) / (old_quantity + new_quantity)

-- Example:
-- Old: 1000 tabs @ 2.00 = 2000
-- New: 500 tabs @ 3.00 = 1500
-- Avg: (2000 + 1500) / (1000 + 500) = 2.33
```

---

## ✅ Implementation Checklist

### Database
- [x] `inventory` table with min/max levels
- [x] `drug_lots` table with expiry tracking
- [x] `inventory_transactions` table for audit
- [x] `get_fifo_lots()` function
- [x] `get_fefo_lots()` function
- [x] `update_inventory_from_receipt()` function
- [x] `low_stock_items` view
- [x] `expiring_drugs` view
- [x] `current_stock_summary` view

### Backend API (To Do)
- [ ] GET `/api/inventory` - List inventory
- [ ] GET `/api/inventory/:id` - Get details
- [ ] GET `/api/inventory/:id/lots` - Get lot details
- [ ] GET `/api/inventory/:id/transactions` - Get transaction history
- [ ] POST `/api/inventory/transfer` - Transfer between locations
- [ ] POST `/api/inventory/adjust` - Stock adjustment
- [ ] GET `/api/inventory/alerts` - Get low stock & expiring alerts

### Frontend (To Do)
- [ ] Inventory dashboard with summary cards
- [ ] Stock list with filters
- [ ] Lot details view with FEFO order
- [ ] Stock transfer form
- [ ] Stock adjustment form
- [ ] Alert notifications
- [ ] Stock movement charts

---

## 📞 Related Documentation

- **[FLOW_03_Procurement_Part1_PR.md](./FLOW_03_Procurement_Part1_PR.md)** - Purchase Request
- **[FLOW_05_Drug_Distribution.md](./FLOW_05_Drug_Distribution.md)** - Drug Distribution
- **[prisma/functions.sql](../../prisma/functions.sql)** - Database functions
- **[prisma/views.sql](../../prisma/views.sql)** - Reporting views

---

**Status**: ✅ Complete - Ready for Implementation
**Last Updated**: 2025-01-11
**Next**: Implement Backend API endpoints

*Created with ❤️ for INVS Modern Team*
