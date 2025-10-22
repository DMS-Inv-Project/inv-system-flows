# 🗄️ INVS Modern - Database Structure

**Complete Database Schema Documentation**

**Version:** 2.4.0
**Last Updated:** 2025-01-22
**Database:** PostgreSQL 15-alpine
**ORM:** Prisma
**Data Status:** 3,152 records migrated (Phase 1-4) 🔓

---

## 📊 Database Statistics

```yaml
Total Tables: 44
Total Enums: 22
Total Views: 11
Total Functions: 12
Ministry Compliance: ✅ 100% (79/79 fields)
```

---

## 📋 Table of Contents

1. [Database Overview](#database-overview)
2. [Complete ER Diagram](#complete-er-diagram)
3. [System-by-System Details](#system-by-system-details)
4. [Cross-System Relationships](#cross-system-relationships)
5. [Database Functions](#database-functions)
6. [Database Views](#database-views)
7. [Enums Reference](#enums-reference)

---

## 🎯 Database Overview

### Tables Grouped by System

| System | Tables | Description |
|--------|--------|-------------|
| 🏢 **Master Data** | 9 | locations, departments, budget_types, budget_categories, budgets, bank, companies, drug_generics, drugs |
| 💰 **Budget Management** | 4 | budget_allocations, budget_plans, budget_plan_items, budget_reservations |
| 🛒 **Procurement** | 12 | contracts, contract_items, purchase_requests, purchase_request_items, purchase_orders, purchase_order_items, receipts, receipt_items, receipt_inspectors, approval_documents, payment_documents, payment_attachments |
| 📦 **Inventory** | 3 | inventory, drug_lots, inventory_transactions |
| 🏥 **Distribution** | 2 | drug_distributions, drug_distribution_items |
| 🔄 **Drug Return** | 2 | drug_returns, drug_return_items |
| 🔗 **TMT Integration** | 10 | tmt_concepts, tmt_relationships, tmt_mappings, tmt_attributes, tmt_manufacturers, tmt_dosage_forms, tmt_units, his_drug_master, tmt_usage_stats, ministry_reports |
| 🏥 **HPP System** | 2 | hospital_pharmaceutical_products, hpp_formulations |
| **TOTAL** | **44** | |

---

## 🗺️ Complete ER Diagram

### High-Level System Relationships

```mermaid
erDiagram
    %% Master Data System (Blue)
    LOCATIONS ||--o{ INVENTORY : "stores"
    LOCATIONS ||--o{ DRUG_LOTS : "contains"
    DEPARTMENTS ||--o{ BUDGET_ALLOCATIONS : "receives"
    DEPARTMENTS ||--o{ PURCHASE_REQUESTS : "requests"
    COMPANIES ||--o{ DRUGS : "manufactures"
    COMPANIES ||--o{ PURCHASE_ORDERS : "supplies"
    DRUG_GENERICS ||--o{ DRUGS : "generic-of"
    DRUGS ||--o{ INVENTORY : "tracked"
    BUDGETS ||--o{ BUDGET_ALLOCATIONS : "allocated"

    %% Budget System (Orange)
    BUDGET_ALLOCATIONS ||--o{ BUDGET_PLANS : "plans"
    BUDGET_ALLOCATIONS ||--o{ BUDGET_RESERVATIONS : "reserves"
    BUDGET_PLANS ||--o{ BUDGET_PLAN_ITEMS : "contains"
    BUDGET_RESERVATIONS ||--o{ PURCHASE_REQUESTS : "for-PR"

    %% Procurement System (Purple)
    CONTRACTS ||--o{ CONTRACT_ITEMS : "contains"
    PURCHASE_REQUESTS ||--o{ PURCHASE_REQUEST_ITEMS : "contains"
    PURCHASE_ORDERS ||--o{ PURCHASE_ORDER_ITEMS : "contains"
    PURCHASE_ORDERS ||--o{ RECEIPTS : "receives"
    RECEIPTS ||--o{ RECEIPT_ITEMS : "contains"
    RECEIPTS ||--o{ RECEIPT_INSPECTORS : "inspected-by"
    PURCHASE_ORDERS ||--o{ APPROVAL_DOCUMENTS : "approved-by"
    RECEIPTS ||--o{ PAYMENT_DOCUMENTS : "paid-via"

    %% Inventory System (Green)
    INVENTORY ||--o{ INVENTORY_TRANSACTIONS : "tracks"
    RECEIPTS ||--o{ DRUG_LOTS : "creates"

    %% Distribution System (Pink)
    DRUG_DISTRIBUTIONS ||--o{ DRUG_DISTRIBUTION_ITEMS : "contains"

    %% Return System (Pink)
    DRUG_RETURNS ||--o{ DRUG_RETURN_ITEMS : "contains"

    %% TMT Integration (Teal)
    TMT_CONCEPTS ||--o{ TMT_RELATIONSHIPS : "relates"
    TMT_CONCEPTS ||--o{ TMT_MAPPINGS : "maps-to"
    DRUGS ||--o{ TMT_MAPPINGS : "maps-from"

    %% HPP System (Yellow)
    HOSPITAL_PHARMACEUTICAL_PRODUCTS ||--o{ HPP_FORMULATIONS : "contains"
```

---

## 📚 System-by-System Details

### 1️⃣ Master Data Management (9 Tables)

```mermaid
erDiagram
    LOCATIONS {
        bigint id PK
        string location_code UK
        string location_name
        enum location_type
        bigint parent_id FK
        string responsible_person
        boolean is_active
    }

    DEPARTMENTS {
        bigint id PK
        string dept_code UK
        string dept_name
        string his_code
        bigint parent_id FK
        enum consumption_group "Ministry field"
        boolean is_active
    }

    BUDGET_TYPE_GROUP {
        bigint id PK
        string type_code UK
        string type_name
        boolean is_active
    }

    BUDGET_CATEGORY {
        bigint id PK
        string category_code UK
        string category_name
        string acc_code
        boolean is_active
    }

    BUDGET {
        bigint id PK
        string budget_code UK
        string budget_type FK
        string budget_category FK
        string budget_description
        boolean is_active
    }

    BANK {
        bigint id PK
        string bank_name
        boolean is_active
    }

    COMPANIES {
        bigint id PK
        string company_code UK
        string company_name
        enum company_type
        string tax_id
        bigint bank_id FK
        string bank_account
        string tmt_manufacturer_code
        boolean is_active
    }

    DRUG_GENERICS {
        bigint id PK
        string working_code UK "7 chars"
        string drug_name
        string dosage_form
        string sale_unit
        string composition
        string tmt_vtm_code "TMT codes"
        string tmt_gp_code
        boolean is_active
    }

    DRUGS {
        bigint id PK
        string drug_code UK "24 chars"
        string trade_name
        bigint generic_id FK
        bigint manufacturer_id FK
        string atc_code
        enum nlem_status "Ministry: E/N"
        enum drug_status "Ministry: 1-4"
        enum product_category "Ministry: 1-5"
        datetime status_changed_date "Ministry"
        string tmt_tp_code "TMT codes"
        boolean is_active
    }

    LOCATIONS ||--o{ LOCATIONS : "parent-child"
    DEPARTMENTS ||--o{ DEPARTMENTS : "parent-child"
    BUDGET ||--o| BUDGET_TYPE_GROUP : "belongs-to"
    BUDGET ||--o| BUDGET_CATEGORY : "belongs-to"
    COMPANIES ||--o| BANK : "banks-with"
    DRUG_GENERICS ||--o{ DRUGS : "has-trades"
    COMPANIES ||--o{ DRUGS : "manufactures"
```

**Ministry Compliance Fields:**
- `drugs.nlem_status` - สถานะยาในบัญชียาหลักแห่งชาติ (E=ในบัญชี, N=นอกบัญชี)
- `drugs.drug_status` - สถานะการใช้งาน (1=ใช้งาน, 2=ตัดแต่มีเหลือ, 3=เฉพาะราย, 4=ตัดหมด)
- `drugs.product_category` - ประเภทผลิตภัณฑ์ (1=ยาปัจจุบันทะเบียน, 2=ยาโรงพยาบาล, 3=สมุนไพรทะเบียน, 4=สมุนไพรโรงพยาบาล, 5=อื่นๆ)
- `drugs.status_changed_date` - วันที่เปลี่ยนสถานะ
- `departments.consumption_group` - กลุ่มหน่วยงานตามรูปแบบการใช้ยา (1-9)

---

### 2️⃣ Budget Management (4 Tables)

```mermaid
erDiagram
    BUDGET_ALLOCATIONS {
        bigint id PK
        int fiscal_year
        bigint budget_id FK
        bigint department_id FK
        decimal total_budget
        decimal q1_budget "Quarter 1"
        decimal q2_budget "Quarter 2"
        decimal q3_budget "Quarter 3"
        decimal q4_budget "Quarter 4"
        decimal total_spent
        decimal q1_spent
        decimal q2_spent
        decimal q3_spent
        decimal q4_spent
        decimal remaining_budget
        enum status
    }

    BUDGET_PLANS {
        bigint id PK
        int fiscal_year
        bigint department_id FK
        bigint budget_allocation_id FK
        decimal total_planned_budget
        decimal q1_planned_budget
        decimal q2_planned_budget
        decimal q3_planned_budget
        decimal q4_planned_budget
        decimal total_purchased
        enum status
        string approved_by
        date approval_date
    }

    BUDGET_PLAN_ITEMS {
        bigint id PK
        bigint budget_plan_id FK
        int item_number
        bigint generic_id FK
        decimal planned_quantity
        decimal estimated_unit_cost
        decimal year1_consumption "3-year"
        decimal year2_consumption "history"
        decimal year3_consumption "data"
        decimal avg_consumption_3_years
        decimal q1_quantity
        decimal q2_quantity
        decimal q3_quantity
        decimal q4_quantity
        decimal purchased_quantity
        enum status
    }

    BUDGET_RESERVATIONS {
        bigint id PK
        bigint allocation_id FK
        bigint pr_id FK
        bigint po_id FK
        decimal reserved_amount
        date reservation_date
        date expires_date
        enum status
    }

    BUDGET_ALLOCATIONS ||--o{ BUDGET_PLANS : "has"
    BUDGET_ALLOCATIONS ||--o{ BUDGET_RESERVATIONS : "reserves"
    BUDGET_PLANS ||--o{ BUDGET_PLAN_ITEMS : "contains"
    BUDGET_RESERVATIONS ||--o| PURCHASE_REQUESTS : "for"
    BUDGET_RESERVATIONS ||--o| PURCHASE_ORDERS : "for"
```

**Key Features:**
- Quarterly budget tracking (Q1-Q4)
- Drug-level planning with 3-year historical data
- Budget reservation system for PR approval
- Automatic budget commitment on PO

---

### 3️⃣ Procurement System (12 Tables)

```mermaid
erDiagram
    CONTRACTS {
        bigint id PK
        string contract_number UK
        enum contract_type
        bigint vendor_id FK
        date start_date
        date end_date
        decimal total_value
        decimal remaining_value
        string fiscal_year
        enum status
        string egp_number
        string project_number
    }

    CONTRACT_ITEMS {
        bigint id PK
        bigint contract_id FK
        bigint drug_id FK
        decimal unit_price
        decimal quantity_contracted
        decimal quantity_remaining
    }

    PURCHASE_REQUESTS {
        bigint id PK
        string pr_number UK
        date pr_date
        bigint department_id FK
        bigint budget_allocation_id FK
        decimal requested_amount
        enum urgency
        enum status
        string requested_by
        string approved_by
        boolean converted_to_po
    }

    PURCHASE_REQUEST_ITEMS {
        bigint id PK
        bigint pr_id FK
        int item_number
        bigint generic_id FK
        decimal quantity_requested
        decimal estimated_unit_cost
        enum status
    }

    PURCHASE_ORDERS {
        bigint id PK
        string po_number UK
        bigint vendor_id FK
        date po_date
        bigint department_id FK
        bigint budget_id FK
        bigint contract_id FK
        enum status
        decimal total_amount
        date sent_to_vendor_date
        string egp_number
    }

    PURCHASE_ORDER_ITEMS {
        bigint id PK
        bigint po_id FK
        bigint drug_id FK
        decimal quantity_ordered
        decimal unit_cost
        decimal quantity_received
    }

    RECEIPTS {
        bigint id PK
        string receipt_number UK
        bigint po_id FK
        date receipt_date
        string delivery_note
        string invoice_number
        date invoice_date
        enum status
        bigint received_by
        bigint verified_by
        date posted_date
    }

    RECEIPT_ITEMS {
        bigint id PK
        bigint receipt_id FK
        bigint drug_id FK
        decimal quantity_received
        decimal unit_cost
        string lot_number
        date expiry_date
        enum item_type
    }

    RECEIPT_INSPECTORS {
        bigint id PK
        bigint receipt_id FK
        string inspector_name
        string inspector_position
        enum inspector_role
        date signed_date
    }

    APPROVAL_DOCUMENTS {
        bigint id PK
        string approval_doc_number UK
        bigint po_id FK
        enum approval_type
        string approved_by
        date approval_date
        enum status
    }

    PAYMENT_DOCUMENTS {
        bigint id PK
        string payment_doc_number UK
        bigint receipt_id FK
        bigint po_id FK
        date submitted_to_finance_date
        date paid_date
        decimal paid_amount
        enum payment_status
    }

    PAYMENT_ATTACHMENTS {
        bigint id PK
        bigint payment_doc_id FK
        enum attachment_type
        string file_name
        string file_path
    }

    CONTRACTS ||--o{ CONTRACT_ITEMS : "contains"
    PURCHASE_REQUESTS ||--o{ PURCHASE_REQUEST_ITEMS : "contains"
    PURCHASE_ORDERS ||--o{ PURCHASE_ORDER_ITEMS : "contains"
    PURCHASE_ORDERS ||--o{ RECEIPTS : "receives"
    RECEIPTS ||--o{ RECEIPT_ITEMS : "contains"
    RECEIPTS ||--o{ RECEIPT_INSPECTORS : "inspected"
    PURCHASE_ORDERS ||--o{ APPROVAL_DOCUMENTS : "approved"
    RECEIPTS ||--o{ PAYMENT_DOCUMENTS : "paid"
    PAYMENT_DOCUMENTS ||--o{ PAYMENT_ATTACHMENTS : "has"
```

**Workflow States:**
- **PR:** draft → submitted → approved → converted
- **PO:** draft → pending → approved → sent → received → closed
- **Receipt:** draft → received → pending_verification → verified → posted
- **Payment:** pending → submitted → approved → paid

---

### 4️⃣ Inventory Management (3 Tables)

```mermaid
erDiagram
    INVENTORY {
        bigint id PK
        bigint drug_id FK
        bigint location_id FK
        decimal quantity_on_hand
        decimal min_level
        decimal max_level
        decimal reorder_point
        decimal average_cost
        decimal last_cost
        datetime last_updated
    }

    DRUG_LOTS {
        bigint id PK
        bigint drug_id FK
        bigint location_id FK
        string lot_number
        date expiry_date
        decimal quantity_available
        decimal unit_cost
        date received_date
        bigint receipt_id FK
        boolean is_active
    }

    INVENTORY_TRANSACTIONS {
        bigint id PK
        bigint inventory_id FK
        enum transaction_type
        decimal quantity
        decimal unit_cost
        bigint reference_id
        string reference_type
        string notes
        bigint created_by
    }

    INVENTORY ||--o{ INVENTORY_TRANSACTIONS : "tracks"
    DRUG_LOTS ||--o| RECEIPTS : "from"
```

**Transaction Types:**
- `RECEIVE` - รับเข้า (from receipt)
- `ISSUE` - เบิกออก (distribution)
- `TRANSFER` - โอนระหว่าง location
- `ADJUST` - ปรับปรุง (count adjustment)
- `RETURN` - รับคืน (return from department)

**Key Features:**
- Multi-location inventory tracking
- FIFO/FEFO lot management
- Min/max/reorder point alerts
- Complete audit trail

---

### 5️⃣ Distribution System (2 Tables)

```mermaid
erDiagram
    DRUG_DISTRIBUTIONS {
        bigint id PK
        string distribution_number UK
        date distribution_date
        bigint from_location_id FK
        bigint to_location_id FK
        bigint requesting_dept_id FK
        string requested_by
        string approved_by
        string dispensed_by
        enum status
        int total_items
        decimal total_amount
    }

    DRUG_DISTRIBUTION_ITEMS {
        bigint id PK
        bigint distribution_id FK
        int item_number
        bigint drug_id FK
        string lot_number
        decimal quantity_dispensed
        decimal unit_cost
        date expiry_date
    }

    DRUG_DISTRIBUTIONS ||--o{ DRUG_DISTRIBUTION_ITEMS : "contains"
```

**Status Flow:** pending → approved → dispensed → completed

---

### 6️⃣ Drug Return System (2 Tables)

```mermaid
erDiagram
    DRUG_RETURNS {
        bigint id PK
        string return_number UK
        bigint department_id FK
        date return_date
        string return_reason
        string action_taken
        enum status
        int total_items
        decimal total_amount
        string received_by
        string verified_by
    }

    DRUG_RETURN_ITEMS {
        bigint id PK
        bigint return_id FK
        bigint drug_id FK
        decimal total_quantity
        decimal good_quantity
        decimal damaged_quantity
        string lot_number
        date expiry_date
        enum return_type
        bigint location_id FK
    }

    DRUG_RETURNS ||--o{ DRUG_RETURN_ITEMS : "contains"
```

**Return Types:**
- `PURCHASED` - ยาที่ซื้อมา
- `FREE` - ยาแจกฟรี

**Status Flow:** draft → submitted → verified → posted → cancelled

---

### 7️⃣ TMT Integration (10 Tables)

```mermaid
erDiagram
    TMT_CONCEPTS {
        bigint id PK
        bigint tmt_id UK
        string concept_code
        enum level
        string fsn
        string preferred_term
        string strength
        string dosage_form
        boolean is_active
    }

    TMT_RELATIONSHIPS {
        bigint id PK
        bigint parent_id FK
        bigint child_id FK
        enum relationship_type
        boolean is_active
    }

    TMT_MAPPINGS {
        bigint id PK
        string working_code
        string drug_code
        bigint generic_id FK
        bigint drug_id FK
        enum tmt_level
        bigint tmt_concept_id FK
        bigint tmt_id
        boolean is_verified
    }

    TMT_ATTRIBUTES {
        bigint id PK
        bigint concept_id FK
        string attribute_type
        string attribute_value
    }

    TMT_MANUFACTURERS {
        bigint id PK
        string manufacturer_code UK
        string manufacturer_name
        boolean is_active
    }

    TMT_DOSAGE_FORMS {
        bigint id PK
        string form_code UK
        string form_name
        boolean is_active
    }

    TMT_UNITS {
        bigint id PK
        string unit_code UK
        string unit_name
        decimal conversion_factor
    }

    HIS_DRUG_MASTER {
        bigint id PK
        string his_drug_code UK
        string drug_name
        bigint tmt_concept_id FK
        enum tmt_level
        enum mapping_status
        string nc24_code
    }

    TMT_USAGE_STATS {
        bigint id PK
        string period_type
        date period_date
        bigint tmt_concept_id FK
        bigint his_drug_master_id FK
        int usage_count
        bigint department_id FK
    }

    MINISTRY_REPORTS {
        bigint id PK
        string report_type
        string report_period
        date report_date
        json data_json
        decimal tmt_compliance_rate
    }

    TMT_CONCEPTS ||--o{ TMT_RELATIONSHIPS : "parent"
    TMT_CONCEPTS ||--o{ TMT_RELATIONSHIPS : "child"
    TMT_CONCEPTS ||--o{ TMT_MAPPINGS : "maps"
    TMT_CONCEPTS ||--o{ TMT_ATTRIBUTES : "has"
    TMT_CONCEPTS ||--o{ HIS_DRUG_MASTER : "maps"
```

**TMT Hierarchy Levels:**
```
SUBS → VTM → GP → TP → GPU → TPU → GPP → TPP → GP-F → GP-X
```

**25,991 TMT Concepts** loaded for ministry compliance

---

### 8️⃣ HPP System (2 Tables)

```mermaid
erDiagram
    HOSPITAL_PHARMACEUTICAL_PRODUCTS {
        bigint id PK
        string hpp_code UK
        enum hpp_type
        string product_name
        bigint generic_id FK
        bigint drug_id FK
        bigint base_product_id FK
        string tmt_code
        boolean is_outsourced
        boolean is_active
    }

    HPP_FORMULATIONS {
        bigint id PK
        bigint hpp_id FK
        string component_type
        string component_name
        string component_strength
        decimal component_ratio
    }

    HOSPITAL_PHARMACEUTICAL_PRODUCTS ||--o{ HPP_FORMULATIONS : "contains"
```

**HPP Types:**
- `R` - Repackaged (บรรจุใหม่)
- `M` - Modified (ดัดแปลง)
- `F` - Hospital Formula (สูตรโรงพยาบาล)
- `X` - Extemporaneous (ผสมตามสั่ง)
- `OHPP` - Outsourced (จ้างผลิตภายนอก)

---

## 🔗 Cross-System Relationships

### Foreign Key Matrix

| From System | From Table | To System | To Table | Relationship |
|-------------|------------|-----------|----------|--------------|
| Budget | budget_allocations | Master Data | budgets | Which budget type |
| Budget | budget_allocations | Master Data | departments | Budget owner |
| Budget | budget_plan_items | Master Data | drug_generics | Plan by generic |
| Budget | budget_reservations | Procurement | purchase_requests | Reserve for PR |
| Procurement | purchase_requests | Master Data | departments | Requesting dept |
| Procurement | purchase_orders | Master Data | companies | Vendor |
| Procurement | purchase_orders | Procurement | contracts | Under contract |
| Procurement | purchase_order_items | Master Data | drugs | Which drug |
| Procurement | receipts | Procurement | purchase_orders | From PO |
| Inventory | inventory | Master Data | drugs | Which drug |
| Inventory | inventory | Master Data | locations | Where stored |
| Inventory | drug_lots | Procurement | receipts | Created from |
| Distribution | drug_distributions | Master Data | locations | From/To location |
| Distribution | drug_distributions | Master Data | departments | Requesting dept |
| Distribution | drug_distribution_items | Master Data | drugs | Which drug |
| Return | drug_returns | Master Data | departments | Returning dept |
| Return | drug_return_items | Master Data | drugs | Which drug |
| Return | drug_return_items | Master Data | locations | Return to location |
| TMT | tmt_mappings | Master Data | drug_generics | Map generic |
| TMT | tmt_mappings | Master Data | drugs | Map trade drug |
| HPP | hospital_pharmaceutical_products | Master Data | drug_generics | Base generic |
| HPP | hospital_pharmaceutical_products | Master Data | drugs | Base drug |

---

## ⚡ Database Functions

### Budget Management Functions (6)

```sql
-- Check if budget is available
check_budget_availability(
    fiscal_year INT,
    budget_type_id BIGINT,
    department_id BIGINT,
    amount DECIMAL,
    quarter INT
) RETURNS TABLE(available BOOLEAN, remaining DECIMAL)

-- Reserve budget for PR (expires after N days)
reserve_budget(
    allocation_id BIGINT,
    pr_id BIGINT,
    amount DECIMAL,
    expires_days INT DEFAULT 30
) RETURNS BIGINT

-- Commit budget when PO approved
commit_budget(
    allocation_id BIGINT,
    po_id BIGINT,
    amount DECIMAL,
    quarter INT
) RETURNS BOOLEAN

-- Release expired/cancelled reservations
release_budget_reservation(
    reservation_id BIGINT
) RETURNS BOOLEAN

-- Check if drug in budget plan
check_drug_in_budget_plan(
    fiscal_year INT,
    department_id BIGINT,
    generic_id BIGINT,
    requested_qty DECIMAL,
    quarter INT
) RETURNS TABLE(in_plan BOOLEAN, remaining_qty DECIMAL)

-- Update budget plan purchased amounts
update_budget_plan_purchase(
    plan_item_id BIGINT,
    quantity DECIMAL,
    value DECIMAL,
    quarter INT
) RETURNS BOOLEAN
```

### Inventory Management Functions (3)

```sql
-- Get lots in FIFO order (oldest first)
get_fifo_lots(
    drug_id BIGINT,
    location_id BIGINT,
    quantity_needed DECIMAL
) RETURNS TABLE(lot_id BIGINT, lot_number VARCHAR, quantity DECIMAL, unit_cost DECIMAL)

-- Get lots in FEFO order (expires first)
get_fefo_lots(
    drug_id BIGINT,
    location_id BIGINT,
    quantity_needed DECIMAL
) RETURNS TABLE(lot_id BIGINT, lot_number VARCHAR, expiry_date DATE, quantity DECIMAL)

-- Auto-update inventory when receipt posted
update_inventory_from_receipt(
    receipt_id BIGINT
) RETURNS BOOLEAN
```

### Utility Functions (3)

Additional utility functions for data validation and calculations.

---

## 📊 Database Views

### Ministry Export Views (5)

```sql
-- 1. DRUGLIST - บัญชีรายการยา (11 fields)
CREATE VIEW export_druglist AS
SELECT
    d.drug_code AS DRUGCODE,
    d.trade_name AS DRUGNAME,
    dg.working_code AS WORKINGCODE,
    d.nlem_status AS NLEM,
    d.drug_status AS STATUS,
    d.status_changed_date AS STATUSDATE,
    d.product_category AS PRODUCT_CAT,
    -- ... (11 fields total)
FROM drugs d
LEFT JOIN drug_generics dg ON d.generic_id = dg.id;

-- 2. PURCHASEPLAN - แผนจัดซื้อ (20 fields)
CREATE VIEW export_purchase_plan AS
SELECT
    bp.fiscal_year AS YEAR,
    d.dept_code AS DEPTCODE,
    dg.working_code AS WORKINGCODE,
    bpi.planned_quantity AS PLANQTY,
    -- ... (20 fields total)
FROM budget_plan_items bpi
JOIN budget_plans bp ON bpi.budget_plan_id = bp.id;

-- 3. RECEIPT - การรับยา (22 fields)
CREATE VIEW export_receipt AS
SELECT
    r.receipt_number AS RECEIPTNO,
    r.receipt_date AS RECEIPTDATE,
    po.po_number AS PONO,
    -- ... (22 fields total)
FROM receipts r
JOIN purchase_orders po ON r.po_id = po.id;

-- 4. DISTRIBUTION - การจ่ายยา (11 fields)
CREATE VIEW export_distribution AS
SELECT
    dd.distribution_number AS DISTNO,
    dd.distribution_date AS DISTDATE,
    dept.dept_code AS DEPTCODE,
    dept.consumption_group AS DEPT_TYPE,
    -- ... (11 fields total)
FROM drug_distributions dd
JOIN departments dept ON dd.requesting_dept_id = dept.id;

-- 5. INVENTORY - ยาคงคลัง (15 fields)
CREATE VIEW export_inventory AS
SELECT
    d.drug_code AS DRUGCODE,
    l.location_code AS LOCCODE,
    i.quantity_on_hand AS QTY,
    -- ... (15 fields total)
FROM inventory i
JOIN drugs d ON i.drug_id = d.id
JOIN locations l ON i.location_id = l.id;
```

**Total:** 79 fields = **100% Ministry Compliance** ✅

### Operational Views (6)

```sql
-- Budget status by department
CREATE VIEW budget_status_current AS
SELECT
    ba.fiscal_year,
    d.dept_name,
    bt.type_name,
    ba.total_budget,
    ba.total_spent,
    ba.remaining_budget,
    ROUND((ba.total_spent / ba.total_budget * 100), 2) AS percent_used
FROM budget_allocations ba
JOIN departments d ON ba.department_id = d.id
JOIN budgets b ON ba.budget_id = b.id
JOIN budget_types bt ON b.budget_type = bt.type_code;

-- Drugs approaching expiry (within 90 days)
CREATE VIEW expiring_drugs AS
SELECT
    d.drug_code,
    d.trade_name,
    dl.lot_number,
    dl.expiry_date,
    dl.quantity_available,
    l.location_name,
    (dl.expiry_date - CURRENT_DATE) AS days_to_expiry
FROM drug_lots dl
JOIN drugs d ON dl.drug_id = d.id
JOIN locations l ON dl.location_id = l.id
WHERE dl.expiry_date <= CURRENT_DATE + INTERVAL '90 days'
  AND dl.quantity_available > 0;

-- Low stock items
CREATE VIEW low_stock_items AS
SELECT
    d.drug_code,
    d.trade_name,
    l.location_name,
    i.quantity_on_hand,
    i.reorder_point,
    i.min_level
FROM inventory i
JOIN drugs d ON i.drug_id = d.id
JOIN locations l ON i.location_id = l.id
WHERE i.quantity_on_hand <= i.reorder_point;

-- Stock summary by location
CREATE VIEW current_stock_summary AS
SELECT
    l.location_name,
    COUNT(DISTINCT i.drug_id) AS total_drugs,
    SUM(i.quantity_on_hand) AS total_quantity,
    SUM(i.quantity_on_hand * i.average_cost) AS total_value
FROM inventory i
JOIN locations l ON i.location_id = l.id
GROUP BY l.id, l.location_name;

-- Active budget reservations
CREATE VIEW budget_reservations_active AS
SELECT
    br.id,
    pr.pr_number,
    d.dept_name,
    br.reserved_amount,
    br.reservation_date,
    br.expires_date,
    (br.expires_date - CURRENT_DATE) AS days_remaining
FROM budget_reservations br
JOIN purchase_requests pr ON br.pr_id = pr.id
JOIN departments d ON pr.department_id = d.id
WHERE br.status = 'active'
  AND br.expires_date >= CURRENT_DATE;

-- Purchase order status dashboard
CREATE VIEW purchase_order_status AS
SELECT
    po.po_number,
    po.po_date,
    c.company_name AS vendor,
    d.dept_name,
    po.total_amount,
    po.status,
    COUNT(poi.id) AS total_items,
    SUM(poi.quantity_received) AS items_received,
    CASE
        WHEN SUM(poi.quantity_ordered) = SUM(poi.quantity_received) THEN 'Complete'
        WHEN SUM(poi.quantity_received) > 0 THEN 'Partial'
        ELSE 'Pending'
    END AS delivery_status
FROM purchase_orders po
JOIN companies c ON po.vendor_id = c.id
LEFT JOIN departments d ON po.department_id = d.id
LEFT JOIN purchase_order_items poi ON po.id = poi.po_id
GROUP BY po.id, c.company_name, d.dept_name;
```

---

## 🏷️ Enums Reference

### Total: 22 Enums

#### System Operation Enums (11)
1. **LocationType** - warehouse, pharmacy, ward, emergency, laboratory, operating_room
2. **CompanyType** - vendor, manufacturer, both
3. **TransactionType** - receive, issue, transfer, adjust, return
4. **BudgetStatus** - active, inactive, locked
5. **ReservationStatus** - active, released, committed
6. **Urgency** - urgent, normal, low
7. **RequestStatus** - draft, submitted, approved, rejected, converted
8. **ItemStatus** - pending, approved, rejected
9. **PoStatus** - draft, pending, approved, sent, received, closed
10. **ReceiptStatus** - draft, received, pending_verification, verified, posted
11. **DistributionStatus** - pending, approved, dispensed, cancelled, completed

#### Procurement System Enums (6)
12. **ContractType** - e_bidding, price_agreement, quotation, special
13. **ContractStatus** - draft, active, expired, cancelled
14. **InspectorRole** - chairman, member, secretary
15. **ApprovalType** - normal, urgent, special
16. **ApprovalStatus** - pending, approved, rejected, cancelled
17. **PaymentStatus** - pending, submitted, approved, paid, cancelled
18. **PurchaseItemType** - normal, urgent, replacement, emergency
19. **AttachmentType** - purchase_order, receipt, invoice, inspection_report, delivery_note, other

#### Ministry Compliance Enums (4) ⭐ NEW v2.2.0
20. **NlemStatus** - E (Essential), N (Non-Essential)
21. **DrugStatus** - 1 (Active), 2 (Discontinued), 3 (Special case), 4 (Removed)
22. **ProductCategory** - 1 (Modern registered), 2 (Modern hospital), 3 (Herbal registered), 4 (Herbal hospital), 5 (Other)
23. **DeptConsumptionGroup** - 1-9 (OPD/IPD mix, OPD mainly, IPD mainly, etc.)

#### TMT System Enums (2)
24. **TmtLevel** - SUBS, VTM, GP, TP, GPU, TPU, GPP, TPP, GP-F, GP-X
25. **HppType** - R (Repackaged), M (Modified), F (Formula), X (Extemporaneous), OHPP (Outsourced)
26. **TmtRelationType** - IS_A, HAS_ACTIVE_INGREDIENT, HAS_DOSE_FORM, etc.
27. **HisMappingStatus** - pending, mapped, verified, rejected

#### Other Enums (2)
28. **ReturnStatus** - draft, submitted, verified, posted, cancelled
29. **ReturnType** - purchased, free
30. **BudgetPlanStatus** - draft, submitted, approved, rejected, active, closed

---

## 🎯 Database Indexes

**Auto-generated by Prisma:**
- Primary keys (id columns)
- Unique constraints (code columns)
- Foreign keys

**Custom Indexes:**
- `departments.his_code` - HIS integration lookup
- All `@unique` fields in schema

---

## 📈 Database Performance

### Table Size Estimates

| Table | Estimated Rows/Year | Growth Rate |
|-------|-------------------|-------------|
| tmt_concepts | 25,991 (static) | Static |
| drugs | 1,000-5,000 | Low |
| drug_generics | 500-2,000 | Low |
| companies | 50-200 | Low |
| purchase_orders | 500-2,000 | Medium |
| receipts | 500-2,000 | Medium |
| inventory_transactions | 10,000-50,000 | High |
| drug_distributions | 2,000-10,000 | High |
| budget_plan_items | 1,000-5,000 | Medium |

### Partitioning Recommendations

**High-volume tables** (future consideration):
- `inventory_transactions` - Partition by created_at (monthly)
- `tmt_usage_stats` - Partition by period_date (quarterly)
- `ministry_reports` - Partition by report_period (yearly)

---

## 🔒 Data Integrity Rules

### Cascade Rules

**ON DELETE CASCADE:**
- `contract_items` → `contracts`
- `budget_plan_items` → `budget_plans`
- `purchase_request_items` → `purchase_requests`
- `purchase_order_items` → `purchase_orders`
- `receipt_items` → `receipts`
- `drug_distribution_items` → `drug_distributions`
- `drug_return_items` → `drug_returns`
- `hpp_formulations` → `hospital_pharmaceutical_products`

**PROTECT (No cascade):**
- `drugs` - Cannot delete if used in inventory
- `companies` - Cannot delete if has purchase orders
- `budget_allocations` - Cannot delete if has reservations

### Unique Constraints

All business documents have unique codes:
- `drug_generics.working_code` (7 chars)
- `drugs.drug_code` (24 chars)
- `purchase_requests.pr_number`
- `purchase_orders.po_number`
- `receipts.receipt_number`
- `contracts.contract_number`
- `drug_distributions.distribution_number`
- `drug_returns.return_number`

---

## 📚 Related Documentation

- [SYSTEM_ARCHITECTURE.md](SYSTEM_ARCHITECTURE.md) - System overview
- [END_TO_END_WORKFLOWS.md](END_TO_END_WORKFLOWS.md) - Data flows
- `prisma/schema.prisma` - Source schema definition
- `prisma/functions.sql` - Function implementations
- `prisma/views.sql` - View definitions

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.2.0
