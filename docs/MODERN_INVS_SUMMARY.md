# Modern Inventory Management System (PostgreSQL Design)
*Based on analysis of INVS Legacy System (Manual 01 & 02)*

## 1. Executive Summary
This design modernizes the legacy INVS structure. 
- **Legacy Approach:** Separated Generic (`DRUG_GN`) and Trade (`DRUG_VN`) tables, relied heavily on `char` types, and separated header/detail tables with suffix `_C` (e.g., `MS_PO` & `MS_PO_C`).
- **Modern Approach:** 
    - Uses strict Foreign Keys (FK).
    - Uses `DECIMAL` for financial calculations (replacing `Float`).
    - Centralizes "Transactions" for better audit trails (Stock Card).
    - Supports Thai Medicines Terminology (TMT) natively.
    - **Smart Features:** Integrated LASA safety, ABC/VEN Analysis, and GS1 DataMatrix support.

---

## 2. Master Data (Drug & Product)

### 2.1 Generic Drugs (Standard Lookup)
Corresponds to legacy `DRUG_GN`. Represents the clinical definition of the drug.

```sql
CREATE TABLE drug_generics (
    generic_id          SERIAL PRIMARY KEY,
    working_code        VARCHAR(20) UNIQUE, -- Legacy ID mapping
    generic_name        VARCHAR(255) NOT NULL,
    description         TEXT,
    
    -- TMT Integration
    gpu_id              VARCHAR(50), -- General Product Unit ID (TMT)
    
    -- Clinical Classifications
    therapeutic_group   VARCHAR(100), -- Group Code
    dosage_form         VARCHAR(100), -- Tablet, Syrup, etc.
    strength            VARCHAR(100), -- 500 mg, 10 ml
    
    -- Administrative Classifications
    is_ed               BOOLEAN DEFAULT FALSE, -- Essential Drug List (บัญชียาหลัก)
    ed_category         VARCHAR(10),           -- ก, ข, ค, ง, จ
    ven_class           VARCHAR(1),            -- V, E, N (Vital, Essential, Non-essential)
    
    -- Safety & LASA (NEW)
    is_high_alert       BOOLEAN DEFAULT FALSE, -- ยาความเสี่ยงสูง (HAM)
    lasa_group_id       INTEGER,               -- กลุ่มยาชื่อพ้อง/มองคล้าย
    storage_condition   TEXT,                  -- เช่น แช่เย็น 2-8°C
    warning_note        TEXT,                  -- ข้อความเตือนพิเศษ
    
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);
```

### 2.2 Trade Products (Purchasable Items)
Corresponds to legacy `DRUG_VN`. Represents the actual product from a specific manufacturer.

```sql
CREATE TABLE drug_products (
    product_id          SERIAL PRIMARY KEY,
    generic_id          INTEGER REFERENCES drug_generics(generic_id),
    
    trade_name          VARCHAR(255) NOT NULL,
    trade_code          VARCHAR(50), -- TPU Code (Trade Product Unit)
    bar_code            VARCHAR(50), -- GS1-13 or DataMatrix Reference
    
    manufacturer_id     INTEGER REFERENCES companies(company_id),
    distributor_id      INTEGER REFERENCES companies(company_id),
    
    -- Product Details
    reg_no              VARCHAR(50), -- Register No (เลขทะเบียน อย.)
    product_type        VARCHAR(20), -- Original, Generic, Import
    pack_size_desc      VARCHAR(100),
    
    -- Inventory Logic (NEW)
    reorder_point       DECIMAL(12, 2) DEFAULT 0, -- จุดสั่งซื้ออัตโนมัติ
    safety_stock        DECIMAL(12, 2) DEFAULT 0,
    
    -- Pricing
    standard_price      DECIMAL(12, 2), -- Reference Price (ราคากลาง)
    last_price          DECIMAL(12, 2), -- Last Purchase Price
    
    is_active           BOOLEAN DEFAULT TRUE
);
```

---

## 3. Partners (Companies)
Unified company table for Manufacturers and Vendors.

```sql
CREATE TABLE companies (
    company_id          SERIAL PRIMARY KEY,
    company_code        VARCHAR(20) UNIQUE,
    company_name        VARCHAR(255) NOT NULL,
    company_type        VARCHAR(20), -- Manufacturer, Vendor, Both
    tax_id              VARCHAR(20),
    credit_term_days    INTEGER DEFAULT 30,
    status              VARCHAR(20) DEFAULT 'ACTIVE'
);
```

---

## 4. Inventory Management (The Core)

### 4.1 Warehouses
```sql
CREATE TABLE warehouses (
    warehouse_id        SERIAL PRIMARY KEY,
    warehouse_name      VARCHAR(100) NOT NULL,
    warehouse_type      VARCHAR(20) -- MAIN, SUB, DISP
);
```

### 4.2 Stock Balance (Lot Control)
Implements FEFO (First Expire, First Out).

```sql
CREATE TABLE stock_balances (
    stock_id            SERIAL PRIMARY KEY,
    warehouse_id        INTEGER REFERENCES warehouses(warehouse_id),
    product_id          INTEGER REFERENCES drug_products(product_id),
    
    lot_no              VARCHAR(50) NOT NULL,
    expire_date         DATE NOT NULL,
    receive_date        DATE NOT NULL,
    
    quantity            DECIMAL(12, 2) NOT NULL, -- BASE UNIT
    cost_price          DECIMAL(12, 4) NOT NULL, -- Cost per BASE UNIT
    
    CONSTRAINT uq_stock UNIQUE (warehouse_id, product_id, lot_no, expire_date)
);
```

### 4.3 Transactions (Stock Card Engine)
Unified log for all movements. Supports "Time-travel" reporting.

```sql
CREATE TABLE stock_transactions (
    transaction_id      BIGSERIAL PRIMARY KEY,
    transaction_date    TIMESTAMP DEFAULT NOW(),
    transaction_type    VARCHAR(20) NOT NULL, 
    -- Types: RECEIVE_PO, ISSUE_REQ, TRANSFER, ADJUST, DISPENSE_HIS, RETURN
    
    ref_document_no     VARCHAR(50), 
    warehouse_id        INTEGER REFERENCES warehouses(warehouse_id),
    product_id          INTEGER REFERENCES drug_products(product_id),
    
    lot_no              VARCHAR(50),
    quantity_change     DECIMAL(12, 2) NOT NULL, -- Positive (IN), Negative (OUT)
    balance_after       DECIMAL(12, 2) NOT NULL, -- Balance snapshot for Stock Card
    unit_cost           DECIMAL(12, 4),
    
    user_id             INTEGER,
    remark              TEXT
);
```

---

## 5. Procurement & Budget Control

### 5.1 Budget Allocations
```sql
CREATE TABLE budget_allocations (
    budget_id           SERIAL PRIMARY KEY,
    fiscal_year         INTEGER NOT NULL,
    source_name         VARCHAR(100), -- เงินบำรุง, UC
    total_amount        DECIMAL(15, 2),
    pre_committed_amount DECIMAL(15, 2) DEFAULT 0, -- งบที่ถูกจอง (Locked by PO)
    used_amount         DECIMAL(15, 2) DEFAULT 0,    -- จ่ายจริง
    remaining_amount    DECIMAL(15, 2) GENERATED ALWAYS AS (total_amount - pre_committed_amount - used_amount) STORED
);
```

### 5.2 Purchase Orders
```sql
CREATE TABLE purchase_orders (
    po_id               SERIAL PRIMARY KEY,
    po_number           VARCHAR(50) UNIQUE NOT NULL,
    po_date             DATE DEFAULT CURRENT_DATE,
    budget_id           INTEGER REFERENCES budget_allocations(budget_id),
    vendor_id           INTEGER REFERENCES companies(company_id),
    
    total_amount        DECIMAL(12, 2),
    status              VARCHAR(20), -- DRAFT, APPROVED (Lock Budget), PARTIAL_RECEIVED, COMPLETED, CANCELLED
    
    created_by          INTEGER,
    approved_by         INTEGER
);
```

---

## 6. Smart Features & Analytics (NEW)

### 6.1 Safety: LASA & HAM Handling
- **Logic:** When selecting a drug, UI queries `lasa_group_id`. If exists, display warnings for other drugs in the same group.
- **Logic:** If `is_high_alert` is TRUE, require a second-user confirmation (Double Check) during dispensing.

### 6.2 Analytics: ABC/VEN Analysis View
```sql
CREATE VIEW inventory_abc_analysis AS
WITH drug_usage AS (
    SELECT 
        product_id,
        SUM(ABS(quantity_change) * unit_cost) as usage_value
    FROM stock_transactions
    WHERE transaction_type IN ('ISSUE_REQ', 'DISPENSE_HIS')
      AND transaction_date >= NOW() - INTERVAL '1 year'
    GROUP BY product_id
),
ranked AS (
    SELECT *, PERCENT_RANK() OVER (ORDER BY usage_value DESC) as p_rank FROM drug_usage
)
SELECT product_id, usage_value,
    CASE WHEN p_rank <= 0.8 THEN 'A' WHEN p_rank <= 0.95 THEN 'B' ELSE 'C' END as abc_class
FROM ranked;
```

### 6.3 Integration: GS1 DataMatrix (2D Barcode)
- **Standard:** `(01)GTIN (17)YYMMDD (10)LOT`
- **Feature:** Scanning a DataMatrix auto-fills: `Product ID`, `Expiry Date`, and `Lot Number` in the Receiving form.

---

## 7. Reporting & Operational Insights

### 7.1 Stock Card Report
- **Goal:** Real-time audit trail of every movement.
- **Query:** Select from `stock_transactions` ordered by `transaction_id`. Use `balance_after` to show running totals without re-calculating millions of rows.

### 7.2 Expiry Management Dashboard
- **RED:** Expired (Locked, cannot dispense).
- **ORANGE:** < 3 Months (Urgent return/transfer).
- **YELLOW:** < 6 Months (Monitor usage).

### 7.3 Auto-Reorder Logic
```sql
SELECT p.trade_name, s.qty, p.reorder_point
FROM drug_products p
JOIN (SELECT product_id, SUM(quantity) as qty FROM stock_balances GROUP BY product_id) s 
  ON p.product_id = s.product_id
WHERE s.qty <= p.reorder_point;
```

---

## 8. Migration Mapping Guide (Legacy -> New)

| Legacy Table | Legacy Field | New Table | New Field | Note |
| :--- | :--- | :--- | :--- | :--- |
| **DRUG_GN** | `WORKING_CODE` | `drug_generics` | `working_code` | |
| **DRUG_GN** | `GPUID` | `drug_generics` | `gpu_id` | Crucial for TMT |
| **DRUG_VN** | `TRADE_CODE` | `drug_products` | `trade_code` | TPU Code |
| **MS_PO** | `PO_NO` | `purchase_orders` | `po_number` | |
| **INV_MD** | `QTY_ON_HAND` | `stock_balances` | `quantity` | |

---

## 9. Recommendations for Implementation
1.  **Web/Mobile First:** Use React/Node.js for real-time warehouse access.
2.  **API-First:** Allow HIS to query stock via REST/GraphQL.
3.  **Real-time Stock Card:** Update balances immediately on transaction commitment.
4.  **Audit Trail:** Log `user_id` on every stock change for accountability.

---

**Version:** 1.1
**Status:** ✅ Modern Design Complete (Including Smart Features)
**Last Updated:** 2026-03-02
