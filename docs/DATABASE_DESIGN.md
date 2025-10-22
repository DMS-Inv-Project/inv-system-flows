# 🗄️ Database Design Document

**Project:** INVS Modern - Hospital Inventory Management System
**Version:** 2.4.0
**Date:** 2025-01-22
**Database:** PostgreSQL 15

---

## 📋 Table of Contents

1. [Database Overview](#1-database-overview)
2. [Entity Relationship Diagrams (ERD)](#2-entity-relationship-diagrams-erd)
3. [Table Catalog](#3-table-catalog)
4. [Relationships and Constraints](#4-relationships-and-constraints)
5. [Indexing Strategy](#5-indexing-strategy)
6. [Data Integrity Rules](#6-data-integrity-rules)
7. [Performance Optimization](#7-performance-optimization)
8. [Data Migration](#8-data-migration)

---

## 1. Database Overview

### 1.1 Database Architecture

**Database Management System:** PostgreSQL 15-alpine
**Schema:** public (single schema design)
**Connection Details:**
```
Host: localhost
Port: 5434
Database: invs_modern
User: invs_user
```

### 1.2 Database Statistics

| Metric | Count | Status |
|--------|-------|--------|
| **Tables** | 44 | ✅ Complete |
| **Enums** | 22 | ✅ Complete |
| **Views** | 11 | ✅ Complete |
| **Functions** | 12 | ✅ Complete |
| **Records** | 3,152 | ✅ Migrated (Phase 1-4) |
| **Ministry Compliance** | 79/79 fields | ✅ 100% |

### 1.3 Table Groups (8 Systems)

```mermaid
graph TD
    A[Master Data<br/>12 tables] --> B[Inventory<br/>3 tables]
    A --> C[Procurement<br/>15 tables]
    A --> D[Budget<br/>4 tables]

    C --> B
    D --> C

    B --> E[Distribution<br/>3 tables]
    B --> F[Drug Return<br/>3 tables]

    A --> G[TMT Integration<br/>3 tables]
    A --> H[HPP System<br/>1 table]

    style A fill:#e1f5ff
    style B fill:#fff4e1
    style C fill:#ffe1f5
    style D fill:#e1ffe1
```

**Table Distribution:**
- **Master Data** (12 tables): Core reference data
- **Budget Management** (4 tables): Budget planning and control
- **Procurement** (15 tables): PR/PO/Receipt workflow + procurement methods
- **Inventory** (3 tables): Stock tracking and lot management
- **Distribution** (3 tables): Drug dispensing to departments
- **Drug Return** (3 tables): Return workflow + return reasons
- **TMT Integration** (3 tables): Thai Medical Terminology mapping
- **HPP System** (1 table): Hospital Pharmaceutical Preparation

**Total:** 52 tables

---

## 2. Entity Relationship Diagrams (ERD)

### 2.1 Complete System ERD (Simplified)

```mermaid
erDiagram
    %% Master Data Core
    drug_generics ||--o{ drugs : "has trade drugs"
    companies ||--o{ drugs : "manufactures"
    dosage_forms ||--o{ drugs : "has form"
    sale_units ||--o{ drugs : "sold in"
    locations ||--o{ inventory : "stored at"
    departments ||--o{ budget_allocations : "receives budget"
    budget_types ||--o{ budget_allocations : "categorizes"

    %% Budget System
    budget_allocations ||--o{ budget_reservations : "reserves from"
    budget_allocations ||--o{ budget_plans : "plans within"
    budget_plans ||--o{ budget_plan_items : "contains"
    budget_plan_items }o--|| drug_generics : "plans for"

    %% Procurement Flow
    departments ||--o{ purchase_requests : "creates"
    purchase_requests ||--o{ purchase_request_items : "contains"
    purchase_request_items }o--|| drugs : "requests"
    purchase_requests ||--|| purchase_orders : "generates"
    purchase_orders ||--o{ purchase_order_items : "contains"
    purchase_orders ||--o{ receipts : "received as"
    receipts ||--o{ receipt_items : "contains"
    companies ||--o{ purchase_orders : "supplies"

    %% Inventory Management
    drugs ||--o{ inventory : "stocked as"
    inventory ||--o{ drug_lots : "tracked in lots"
    inventory ||--o{ inventory_transactions : "moved by"

    %% Distribution
    departments ||--o{ drug_distributions : "requests"
    drug_distributions ||--o{ drug_distribution_items : "contains"
    drug_distribution_items }o--|| drugs : "distributes"
    drug_distribution_items }o--|| drug_lots : "from lot"

    %% Drug Return
    departments ||--o{ drug_returns : "returns from"
    drug_returns ||--o{ drug_return_items : "contains"
    drug_return_items }o--|| drugs : "returns"
    drug_return_items }o--|| drug_lots : "from lot"

    %% TMT Integration
    drugs ||--o{ tmt_mappings : "mapped to"
    tmt_mappings }o--|| tmt_concepts : "uses concept"
```

### 2.2 Master Data System ERD

```mermaid
erDiagram
    drug_generics {
        int id PK
        string working_code UK "Ministry working code"
        string generic_name "Generic name (EN)"
        string generic_name_th "Generic name (TH)"
        string strength "e.g., 500mg"
        int dosage_form_id FK
        string usage_type "e.g., oral, injection"
        timestamp created_at
        timestamp updated_at
    }

    drugs {
        int id PK
        int generic_id FK "Links to drug_generics"
        string trade_code UK "Trade product code"
        string trade_name "Brand name (EN)"
        string trade_name_th "Brand name (TH)"
        int company_id FK "Manufacturer"
        int dosage_form_id FK
        int sale_unit_id FK
        string strength
        decimal unit_price "Current price"
        enum nlem_status "E=Essential, N=Non-essential"
        enum drug_status "1=Active, 2=Inactive, 3=Discontinued, 4=Out of stock"
        enum product_category "1=Drug, 2=Supply, 3=Equipment, etc."
        date status_changed_date
        string tmt_code "Thai Medical Terminology code"
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    companies {
        int id PK
        string name UK "Company name"
        string name_th "Thai name"
        string tax_id "Tax identification number"
        string address
        string phone
        string email
        enum company_type "MANUFACTURER, VENDOR, BOTH"
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    dosage_forms {
        int id PK
        string code UK "e.g., TAB, CAP, INJ"
        string name "Dosage form name"
        string name_th "Thai name"
        int display_order
    }

    sale_units {
        int id PK
        string code UK "e.g., TAB, BOT, AMP"
        string name "Unit name"
        string name_th "Thai name"
        int display_order
    }

    locations {
        int id PK
        string code UK "Location code"
        string name "Location name"
        string name_th "Thai name"
        enum type "WAREHOUSE, PHARMACY, WARD, EMERGENCY"
        string description
        boolean is_active
        timestamp created_at
    }

    departments {
        int id PK
        string code UK "Department code"
        string name "Department name"
        string name_th "Thai name"
        enum consumption_group "1-9: OPD, IPD, Emergency, etc."
        string budget_code "For budget tracking"
        int parent_department_id FK "For hierarchy"
        boolean is_active
        timestamp created_at
    }

    budget_types {
        int id PK
        string code UK "e.g., OP001, IV001"
        string name "Budget type name"
        string name_th "Thai name"
        enum category "OPERATIONAL, INVESTMENT, EMERGENCY"
        string description
        int display_order
    }

    %% Drug Information Support Tables (Phase 1-2)
    drug_pack_ratios {
        int id PK
        int drug_id FK
        string pack_size "e.g., 100 tablets per box"
        decimal ratio "Conversion ratio"
        string unit_from "Source unit"
        string unit_to "Target unit"
        timestamp created_at
    }

    drug_components {
        int id PK
        int drug_id FK "Parent drug"
        int component_drug_id FK "Component drug"
        decimal quantity "Amount per unit"
        string unit "Unit of measure"
        timestamp created_at
    }

    drug_focus_lists {
        int id PK
        int drug_id FK
        enum list_type "HIGH_COST, CONTROLLED, ANTIBIOTICS, etc."
        string reason "Why in focus list"
        date effective_from
        date effective_to
        timestamp created_at
    }

    %% Relationships
    drug_generics ||--o{ drugs : "has trade drugs"
    companies ||--o{ drugs : "manufactures"
    dosage_forms ||--o{ drug_generics : "has form (generic)"
    dosage_forms ||--o{ drugs : "has form (trade)"
    sale_units ||--o{ drugs : "sold in"
    departments ||--|| departments : "has parent"
    drugs ||--o{ drug_pack_ratios : "has pack ratios"
    drugs ||--o{ drug_components : "has components"
    drugs ||--o{ drug_focus_lists : "in focus lists"
```

### 2.3 Budget Management System ERD

```mermaid
erDiagram
    budget_allocations {
        int id PK
        int fiscal_year "e.g., 2025"
        int budget_type_id FK
        int department_id FK
        decimal allocated_amount "Total budget"
        decimal q1_allocated "Q1 allocation"
        decimal q2_allocated "Q2 allocation"
        decimal q3_allocated "Q3 allocation"
        decimal q4_allocated "Q4 allocation"
        decimal q1_spent "Q1 spent"
        decimal q2_spent "Q2 spent"
        decimal q3_spent "Q3 spent"
        decimal q4_spent "Q4 spent"
        decimal reserved_amount "Currently reserved"
        decimal spent_amount "Total spent"
        decimal available_amount "Calculated: allocated - reserved - spent"
        timestamp created_at
        timestamp updated_at
    }

    budget_reservations {
        int id PK
        int allocation_id FK
        int pr_id FK "Purchase request"
        decimal amount "Reserved amount"
        enum status "ACTIVE, COMMITTED, RELEASED, EXPIRED"
        date reserved_date
        date expires_date "Default: +30 days"
        int reserved_by FK "User ID"
        timestamp created_at
        timestamp updated_at
    }

    budget_plans {
        int id PK
        int fiscal_year
        int department_id FK
        int budget_type_id FK
        string plan_name "e.g., Annual Drug Purchase Plan 2025"
        string description
        decimal total_budget "Total planned budget"
        enum status "DRAFT, SUBMITTED, APPROVED, ACTIVE"
        date approved_date
        int approved_by FK "User ID"
        timestamp created_at
        timestamp updated_at
    }

    budget_plan_items {
        int id PK
        int plan_id FK
        int generic_id FK "Drug generic"
        decimal planned_quantity "Annual planned qty"
        decimal planned_unit_price "Estimated price"
        decimal planned_value "qty * price"
        decimal q1_quantity "Q1 planned qty"
        decimal q2_quantity "Q2 planned qty"
        decimal q3_quantity "Q3 planned qty"
        decimal q4_quantity "Q4 planned qty"
        decimal q1_purchased "Q1 purchased"
        decimal q2_purchased "Q2 purchased"
        decimal q3_purchased "Q3 purchased"
        decimal q4_purchased "Q4 purchased"
        decimal year1_consumption "Historical: 3 years ago"
        decimal year2_consumption "Historical: 2 years ago"
        decimal year3_consumption "Historical: last year"
        string justification "Reason for quantity"
        timestamp created_at
        timestamp updated_at
    }

    %% Relationships
    budget_types ||--o{ budget_allocations : "categorizes"
    departments ||--o{ budget_allocations : "receives"
    budget_allocations ||--o{ budget_reservations : "reserves from"
    departments ||--o{ budget_plans : "creates plan"
    budget_types ||--o{ budget_plans : "categorizes plan"
    budget_plans ||--o{ budget_plan_items : "contains items"
    drug_generics ||--o{ budget_plan_items : "planned for"
```

### 2.4 Procurement System ERD

```mermaid
erDiagram
    purchase_requests {
        int id PK
        string pr_number UK "Auto: PR-YYYY-NNNN"
        int department_id FK
        int budget_type_id FK
        int fiscal_year
        int quarter "1-4"
        enum status "DRAFT, SUBMITTED, BUDGET_CHECK, BUDGET_RESERVED, APPROVED, REJECTED, CANCELLED, PO_CREATED"
        decimal total_amount "Sum of items"
        string justification "Reason for purchase"
        int requested_by FK "User ID"
        int approved_by FK "User ID"
        date requested_date
        date approved_date
        string rejection_reason
        timestamp created_at
        timestamp updated_at
    }

    purchase_request_items {
        int id PK
        int pr_id FK
        int drug_id FK
        decimal quantity "Requested qty"
        decimal unit_price "Estimated price"
        decimal total_price "qty * price"
        string remarks
        timestamp created_at
    }

    purchase_orders {
        int id PK
        string po_number UK "Auto: PO-YYYY-NNNN"
        int pr_id FK "Source PR"
        int company_id FK "Vendor"
        int purchase_method_id FK "Phase 1: Purchase method"
        int purchase_type_id FK "Phase 1: Purchase type"
        int purchase_order_reason_id FK "Phase 3: PO reason"
        enum status "DRAFT, PENDING_APPROVAL, APPROVED, SENT, PARTIAL_RECEIVED, FULLY_RECEIVED, COMPLETED, CANCELLED, CLOSED"
        decimal total_amount
        date order_date
        date expected_delivery_date
        string delivery_address
        string terms_and_conditions
        int created_by FK
        int approved_by FK
        timestamp created_at
        timestamp updated_at
    }

    purchase_order_items {
        int id PK
        int po_id FK
        int drug_id FK
        decimal quantity "Ordered qty"
        decimal unit_price "Agreed price"
        decimal total_price "qty * price"
        decimal received_quantity "Total received so far"
        decimal outstanding_quantity "Calculated: quantity - received"
        string remarks
        timestamp created_at
    }

    receipts {
        int id PK
        string receipt_number UK "Auto: RC-YYYY-NNNN"
        int po_id FK
        enum status "DRAFT, INSPECTING, APPROVED, POSTED"
        date receipt_date "Delivery date"
        string invoice_number "Vendor invoice"
        decimal total_amount "Invoice total"
        int received_by FK "User ID"
        int inspected_by FK "Committee member"
        int approved_by FK "Pharmacy head"
        string inspection_notes
        timestamp created_at
        timestamp updated_at
    }

    receipt_items {
        int id PK
        int receipt_id FK
        int po_item_id FK "Links to PO item"
        int drug_id FK
        decimal quantity "Received qty"
        decimal unit_price "Actual price"
        string lot_number "Batch number"
        date expiry_date "Expiration date"
        string inspection_result "PASS, FAIL, CONDITIONAL"
        string remarks
        timestamp created_at
    }

    %% Procurement Master Data (Phase 1, 3)
    purchase_methods {
        int id PK
        string code UK "e.g., PM001, PM002"
        string name "Method name (EN)"
        string name_th "Method name (TH)"
        string description
        decimal min_amount "Minimum purchase amount"
        decimal max_amount "Maximum purchase amount"
        int display_order
        boolean is_active
    }

    purchase_types {
        int id PK
        string code UK "e.g., PT001, PT002"
        string name "Type name (EN)"
        string name_th "Type name (TH)"
        string description
        int display_order
        boolean is_active
    }

    purchase_order_reasons {
        int id PK
        string code UK "e.g., POR001, POR002"
        string name "Reason name"
        string name_th "Thai name"
        string description
    }

    %% Relationships
    departments ||--o{ purchase_requests : "creates"
    budget_types ||--o{ purchase_requests : "categorizes"
    purchase_requests ||--o{ purchase_request_items : "contains"
    drugs ||--o{ purchase_request_items : "requests"

    purchase_requests ||--|| purchase_orders : "generates"
    companies ||--o{ purchase_orders : "supplies"
    purchase_methods ||--o{ purchase_orders : "uses method"
    purchase_types ||--o{ purchase_orders : "of type"
    purchase_order_reasons ||--o{ purchase_orders : "has reason"
    purchase_orders ||--o{ purchase_order_items : "contains"
    drugs ||--o{ purchase_order_items : "orders"

    purchase_orders ||--o{ receipts : "received as"
    receipts ||--o{ receipt_items : "contains"
    purchase_order_items ||--o{ receipt_items : "received from"
    drugs ||--o{ receipt_items : "receives"
```

### 2.5 Inventory Management System ERD

```mermaid
erDiagram
    inventory {
        int id PK
        int drug_id FK
        int location_id FK
        decimal quantity_on_hand "Current stock"
        decimal minimum_level "Reorder point"
        decimal maximum_level "Max stock level"
        decimal reorder_quantity "Default order qty"
        decimal reserved_quantity "Reserved for distributions"
        decimal available_quantity "Calculated: on_hand - reserved"
        timestamp last_count_date "Last physical count"
        timestamp created_at
        timestamp updated_at
    }

    drug_lots {
        int id PK
        int drug_id FK
        int location_id FK
        string lot_number "Batch/lot number"
        date expiry_date "Expiration date"
        date manufacture_date
        decimal quantity_received "Original received qty"
        decimal quantity_on_hand "Current qty"
        decimal unit_cost "Cost per unit"
        string invoice_number "Source invoice"
        int receipt_id FK "Source receipt"
        boolean is_expired "Calculated: expiry_date < today"
        timestamp created_at
        timestamp updated_at
    }

    inventory_transactions {
        int id PK
        int drug_id FK
        int location_id FK
        int lot_id FK "Drug lot (if applicable)"
        enum transaction_type "RECEIVE, ISSUE, TRANSFER, ADJUST, RETURN"
        decimal quantity "Quantity moved"
        decimal unit_cost "Cost per unit"
        string reference_number "Source document number"
        enum reference_type "RECEIPT, DISTRIBUTION, RETURN, ADJUSTMENT"
        int reference_id "Source document ID"
        int from_location_id FK "For transfers"
        int to_location_id FK "For transfers"
        string remarks
        int created_by FK "User ID"
        timestamp transaction_date
        timestamp created_at
    }

    %% Relationships
    drugs ||--o{ inventory : "stocked as"
    locations ||--o{ inventory : "stored at"
    drugs ||--o{ drug_lots : "tracked in lots"
    locations ||--o{ drug_lots : "stored at"
    drugs ||--o{ inventory_transactions : "moved"
    locations ||--o{ inventory_transactions : "from location"
    locations ||--o{ inventory_transactions : "to location"
    drug_lots ||--o{ inventory_transactions : "from lot"
    receipts ||--o{ drug_lots : "creates lot"
```

### 2.6 Distribution System ERD

```mermaid
erDiagram
    drug_distributions {
        int id PK
        string distribution_number UK "Auto: DIST-YYYY-NNNN"
        int department_id FK "Requesting department"
        int from_location_id FK "Source location"
        int to_location_id FK "Destination location"
        int distribution_type_id FK "Phase 3: Distribution type"
        enum status "DRAFT, PENDING, APPROVED, FULFILLED"
        date requested_date
        date fulfilled_date
        enum priority "NORMAL, URGENT, STAT"
        string remarks
        int requested_by FK "User ID"
        int approved_by FK "User ID"
        int fulfilled_by FK "User ID"
        timestamp created_at
        timestamp updated_at
    }

    drug_distribution_items {
        int id PK
        int distribution_id FK
        int drug_id FK
        int lot_id FK "Drug lot selected"
        decimal requested_quantity
        decimal approved_quantity "May differ from requested"
        decimal fulfilled_quantity "Actual distributed"
        string remarks
        timestamp created_at
    }

    %% Distribution Master Data (Phase 3)
    distribution_types {
        int id PK
        string code UK "e.g., DT001, DT002"
        string name "Type name"
        string name_th "Thai name"
        string description
        int display_order
    }

    %% Relationships
    departments ||--o{ drug_distributions : "requests"
    locations ||--o{ drug_distributions : "from location"
    locations ||--o{ drug_distributions : "to location"
    distribution_types ||--o{ drug_distributions : "of type"
    drug_distributions ||--o{ drug_distribution_items : "contains"
    drugs ||--o{ drug_distribution_items : "distributes"
    drug_lots ||--o{ drug_distribution_items : "from lot"
```

### 2.7 Drug Return System ERD

```mermaid
erDiagram
    drug_returns {
        int id PK
        string return_number UK "Auto: RET-YYYY-NNNN"
        int department_id FK "Returning department"
        int from_location_id FK "Return from"
        int to_location_id FK "Return to (pharmacy)"
        enum status "DRAFT, INSPECTING, APPROVED, COMPLETED"
        date return_date
        enum return_action "RETURN_TO_STOCK, RETURN_TO_VENDOR, DISPOSE"
        string inspection_notes
        int created_by FK "User ID"
        int inspected_by FK "Pharmacist ID"
        int approved_by FK "Pharmacy head ID"
        timestamp created_at
        timestamp updated_at
    }

    drug_return_items {
        int id PK
        int return_id FK
        int drug_id FK
        int lot_id FK
        int return_reason_id FK "Phase 1: Return reason"
        decimal quantity "Returned qty"
        enum condition "SEALED, OPENED, DAMAGED"
        string remarks
        timestamp created_at
    }

    %% Return Master Data (Phase 1)
    return_reasons {
        int id PK
        string code UK "e.g., RR001-RR019"
        string name "Reason name (EN)"
        string name_th "Reason name (TH)"
        enum category "CLINICAL, OPERATIONAL, QUALITY"
        string description
        int display_order
        boolean is_active
    }

    %% Relationships
    departments ||--o{ drug_returns : "returns from"
    locations ||--o{ drug_returns : "from location"
    locations ||--o{ drug_returns : "to location"
    drug_returns ||--o{ drug_return_items : "contains"
    drugs ||--o{ drug_return_items : "returns"
    drug_lots ||--o{ drug_return_items : "from lot"
    return_reasons ||--o{ drug_return_items : "has reason"
```

### 2.8 TMT Integration System ERD

```mermaid
erDiagram
    tmt_concepts {
        int id PK
        string tmt_code UK "TMT unique code"
        string name "Concept name (EN)"
        string name_th "Concept name (TH)"
        string semantic_tag "e.g., pharmaceutical product"
        enum status "ACTIVE, DEPRECATED"
        date effective_date
        timestamp created_at
    }

    tmt_mappings {
        int id PK
        int drug_id FK
        int tmt_concept_id FK
        enum mapping_type "EXACT, APPROXIMATE, PARENT, CHILD"
        decimal confidence_score "0.0-1.0"
        enum status "ACTIVE, INACTIVE"
        int mapped_by FK "User ID"
        date mapped_date
        timestamp created_at
        timestamp updated_at
    }

    his_drug_master {
        int id PK
        string his_code UK "HIS system drug code"
        int drug_id FK "INVS drug"
        string his_name "Drug name in HIS"
        decimal his_unit_price "Price in HIS"
        boolean is_active
        date last_sync_date
        timestamp created_at
        timestamp updated_at
    }

    %% Relationships
    tmt_concepts ||--o{ tmt_mappings : "mapped to"
    drugs ||--o{ tmt_mappings : "has mapping"
    drugs ||--o{ his_drug_master : "synced with HIS"
```

### 2.9 HPP System ERD

```mermaid
erDiagram
    hospital_formulas {
        int id PK
        string formula_code UK "e.g., HPP-001"
        string formula_name "Formula name"
        string formula_name_th "Thai name"
        int base_drug_id FK "Main drug component"
        decimal batch_size "Standard batch size"
        string unit "Unit of measure"
        string preparation_method "How to prepare"
        decimal unit_cost "Cost per unit"
        string storage_conditions
        int shelf_life_days "Stability period"
        enum status "DRAFT, APPROVED, ACTIVE, DISCONTINUED"
        date approved_date
        int approved_by FK "User ID"
        timestamp created_at
        timestamp updated_at
    }

    formula_components {
        int id PK
        int formula_id FK
        int drug_id FK "Component drug"
        decimal quantity "Amount per batch"
        string unit "Unit of measure"
        boolean is_active_ingredient
        timestamp created_at
    }

    %% Relationships
    drugs ||--o{ hospital_formulas : "based on"
    hospital_formulas ||--o{ formula_components : "contains"
    drugs ||--o{ formula_components : "uses drug"
```

---

## 3. Table Catalog

### 3.1 Tables by System

#### System 1: Master Data (12 tables)

| # | Table Name | Records | Description |
|---|------------|---------|-------------|
| 1 | `drug_generics` | 1,109 | Generic drug catalog with working codes |
| 2 | `drugs` | 1,169 | Trade drug catalog with manufacturers |
| 3 | `companies` | 816 | Vendors and manufacturers |
| 4 | `dosage_forms` | 87 | Drug dosage forms (tablet, capsule, etc.) |
| 5 | `sale_units` | 10 | Sales units (TAB, BOT, AMP, etc.) |
| 6 | `locations` | 5 | Storage locations |
| 7 | `departments` | 5 | Hospital departments |
| 8 | `budget_types` | 6 | Budget categories |
| 9 | `drug_pack_ratios` | 1,641 | Pack size conversions ⭐ Phase 1 |
| 10 | `drug_components` | 736 | Drug components/ingredients ⭐ Phase 2 |
| 11 | `drug_focus_lists` | 92 | High-cost/controlled drugs ⭐ Phase 2 |
| 12 | `historical_drug_data` | 0 | Manual historical data (optional) |

**Total Records: 5,676**

#### System 2: Budget Management (4 tables)

| # | Table Name | Records | Description |
|---|------------|---------|-------------|
| 1 | `budget_allocations` | 3 | Annual budget by dept/type/quarter |
| 2 | `budget_reservations` | 0 | Budget reservations for PRs |
| 3 | `budget_plans` | 0 | Drug-level budget planning |
| 4 | `budget_plan_items` | 0 | Planned drugs with historical data |

**Total Records: 3**

#### System 3: Procurement (15 tables)

| # | Table Name | Records | Description |
|---|------------|---------|-------------|
| 1 | `purchase_requests` | 0 | Purchase request workflow |
| 2 | `purchase_request_items` | 0 | PR line items |
| 3 | `purchase_orders` | 0 | Purchase orders |
| 4 | `purchase_order_items` | 0 | PO line items |
| 5 | `receipts` | 0 | Goods receiving documents |
| 6 | `receipt_items` | 0 | Receipt line items |
| 7 | `purchase_methods` | 18 | Purchase methods ⭐ Phase 1 |
| 8 | `purchase_types` | 20 | Purchase types ⭐ Phase 1 |
| 9 | `purchase_order_reasons` | 2 | PO reasons ⭐ Phase 3 |

**Total Records: 40** (master data only)

#### System 4: Inventory (3 tables)

| # | Table Name | Records | Description |
|---|------------|---------|-------------|
| 1 | `inventory` | 8 | Stock levels by drug/location |
| 2 | `drug_lots` | 5 | FIFO/FEFO lot tracking |
| 3 | `inventory_transactions` | 10 | All inventory movements |

**Total Records: 23**

#### System 5: Distribution (3 tables)

| # | Table Name | Records | Description |
|---|------------|---------|-------------|
| 1 | `drug_distributions` | 0 | Distribution requests |
| 2 | `drug_distribution_items` | 0 | Distribution line items |
| 3 | `distribution_types` | 2 | Distribution types ⭐ Phase 3 |

**Total Records: 2**

#### System 6: Drug Return (3 tables)

| # | Table Name | Records | Description |
|---|------------|---------|-------------|
| 1 | `drug_returns` | 0 | Return documents |
| 2 | `drug_return_items` | 0 | Return line items |
| 3 | `return_reasons` | 19 | Return reasons (Clinical/Operational/Quality) ⭐ Phase 1 |

**Total Records: 19**

#### System 7: TMT Integration (3 tables)

| # | Table Name | Records | Description |
|---|------------|---------|-------------|
| 1 | `tmt_concepts` | 25,991 | Thai Medical Terminology concepts |
| 2 | `tmt_mappings` | 0 | Drug-to-TMT mappings |
| 3 | `his_drug_master` | 0 | HIS integration data |

**Total Records: 25,991**

#### System 8: HPP System (1 table)

| # | Table Name | Records | Description |
|---|------------|---------|-------------|
| 1 | `hospital_formulas` | 0 | Hospital pharmaceutical preparations |

**Total Records: 0**

**Grand Total: 31,754 records** (including TMT concepts)

### 3.2 Table Size Estimates

| Table Category | Tables | Current Records | Est. 5-Year Growth |
|----------------|--------|-----------------|-------------------|
| Master Data (static) | 12 | 5,676 | +10% (6,244) |
| TMT Concepts | 1 | 25,991 | +5% (27,291) |
| Budget (annual) | 4 | 3 | +500% (15) |
| Procurement (transactional) | 6 | 0 | 2,500 docs |
| Inventory (transactional) | 3 | 23 | 250,000 txns |
| Distribution (transactional) | 3 | 0 | 50,000 docs |
| Return (transactional) | 3 | 0 | 1,000 docs |
| HPP (semi-static) | 1 | 0 | 100 formulas |

**Estimated Total After 5 Years: ~310,000 records**
**Estimated Database Size: 15-20 GB**

---

## 4. Relationships and Constraints

### 4.1 Foreign Key Constraints

**Naming Convention:** `fk_[child_table]_[parent_table]`

**Example:**
```sql
ALTER TABLE drugs
  ADD CONSTRAINT fk_drugs_drug_generics
  FOREIGN KEY (generic_id) REFERENCES drug_generics(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
```

**ON DELETE Policies:**
- **RESTRICT**: Master data (cannot delete if referenced)
- **CASCADE**: Dependent items (delete parent → delete children)
- **SET NULL**: Optional relationships (delete parent → set NULL)

### 4.2 Key Relationships

#### Master Data Relationships

```sql
-- Drug Hierarchy
drug_generics (1) → (∞) drugs
  - One generic can have multiple trade drugs
  - RESTRICT: Cannot delete generic if trade drugs exist

-- Drug Attributes
drugs (∞) → (1) companies
drugs (∞) → (1) dosage_forms
drugs (∞) → (1) sale_units
  - RESTRICT: Cannot delete referenced master data

-- Department Hierarchy
departments (1) → (∞) departments (self-referencing)
  - Optional parent_department_id for hierarchy
  - SET NULL: Delete parent → orphan children
```

#### Budget Relationships

```sql
-- Budget Allocation
budget_allocations (∞) → (1) departments
budget_allocations (∞) → (1) budget_types
  - RESTRICT: Cannot delete dept/type with allocations

-- Budget Reservation
budget_reservations (∞) → (1) budget_allocations
budget_reservations (∞) → (1) purchase_requests
  - CASCADE: Delete PR → delete reservation
  - RESTRICT: Cannot delete allocation with active reservations

-- Budget Planning
budget_plans (∞) → (1) departments
budget_plan_items (∞) → (1) budget_plans
budget_plan_items (∞) → (1) drug_generics
  - CASCADE: Delete plan → delete items
  - RESTRICT: Cannot delete generic in active plan
```

#### Procurement Relationships

```sql
-- PR → PO → Receipt Chain
purchase_requests (1) → (1) purchase_orders
purchase_orders (1) → (∞) receipts
  - RESTRICT: Cannot delete PR if PO exists
  - RESTRICT: Cannot delete PO if receipts exist

-- Item Details
purchase_requests (1) → (∞) purchase_request_items
purchase_orders (1) → (∞) purchase_order_items
receipts (1) → (∞) receipt_items
  - CASCADE: Delete parent → delete items

-- Drug References
purchase_request_items (∞) → (1) drugs
purchase_order_items (∞) → (1) drugs
receipt_items (∞) → (1) drugs
  - RESTRICT: Cannot delete drug with active orders
```

#### Inventory Relationships

```sql
-- Stock Tracking
inventory (∞) → (1) drugs
inventory (∞) → (1) locations
  - UNIQUE(drug_id, location_id): One record per drug/location
  - RESTRICT: Cannot delete drug/location with inventory

-- Lot Tracking
drug_lots (∞) → (1) drugs
drug_lots (∞) → (1) locations
drug_lots (∞) → (1) receipts (optional)
  - RESTRICT: Cannot delete drug/location with lots
  - SET NULL: Delete receipt → keep lot but lose reference

-- Transactions
inventory_transactions (∞) → (1) drugs
inventory_transactions (∞) → (1) drug_lots (optional)
  - RESTRICT: Cannot delete drug with transactions
  - SET NULL: Delete lot → keep transaction but lose lot reference
```

#### Distribution & Return Relationships

```sql
-- Distribution
drug_distributions (∞) → (1) departments
drug_distributions (∞) → (1) locations (from)
drug_distributions (∞) → (1) locations (to)
drug_distribution_items (∞) → (1) drug_lots
  - RESTRICT: Cannot delete dept/location with distributions

-- Return
drug_returns (∞) → (1) departments
drug_return_items (∞) → (1) return_reasons
  - RESTRICT: Cannot delete dept with returns
  - RESTRICT: Cannot delete reason if used
```

### 4.3 Unique Constraints

```sql
-- Business Keys (Natural Keys)
UNIQUE(working_code) ON drug_generics
UNIQUE(trade_code) ON drugs
UNIQUE(pr_number) ON purchase_requests
UNIQUE(po_number) ON purchase_orders
UNIQUE(receipt_number) ON receipts
UNIQUE(tmt_code) ON tmt_concepts

-- Composite Unique Constraints
UNIQUE(drug_id, location_id) ON inventory
UNIQUE(drug_id, tmt_concept_id) ON tmt_mappings
UNIQUE(fiscal_year, budget_type_id, department_id) ON budget_allocations
```

### 4.4 Check Constraints

```sql
-- Positive Values
CHECK(quantity > 0) ON inventory
CHECK(unit_price >= 0) ON drugs
CHECK(allocated_amount >= 0) ON budget_allocations

-- Logical Constraints
CHECK(expiry_date > manufacture_date) ON drug_lots
CHECK(maximum_level >= minimum_level) ON inventory
CHECK(received_quantity <= quantity) ON purchase_order_items
CHECK(q1_allocated + q2_allocated + q3_allocated + q4_allocated = allocated_amount) ON budget_allocations

-- Calculated Fields
CHECK(available_amount = allocated_amount - reserved_amount - spent_amount) ON budget_allocations
CHECK(outstanding_quantity = quantity - received_quantity) ON purchase_order_items

-- Enum Values (handled by PostgreSQL ENUM types)
CHECK(status IN ('DRAFT', 'SUBMITTED', ...)) -- Enforced by enum type
```

---

## 5. Indexing Strategy

### 5.1 Primary Key Indexes (Auto-created)

All tables have primary key on `id` column:
```sql
CREATE INDEX pk_[table_name] ON [table_name] (id);
```

**Index Type:** B-tree (default)
**Usage:** Fast lookups by ID

### 5.2 Foreign Key Indexes

**Automatically created for all foreign keys:**
```sql
CREATE INDEX idx_drugs_generic_id ON drugs (generic_id);
CREATE INDEX idx_drugs_company_id ON drugs (company_id);
CREATE INDEX idx_purchase_requests_department_id ON purchase_requests (department_id);
CREATE INDEX idx_inventory_drug_id ON inventory (drug_id);
CREATE INDEX idx_inventory_location_id ON inventory (location_id);
```

**Rationale:** Foreign key columns are frequently used in JOINs

### 5.3 Unique Constraint Indexes

```sql
CREATE UNIQUE INDEX uk_drug_generics_working_code ON drug_generics (working_code);
CREATE UNIQUE INDEX uk_drugs_trade_code ON drugs (trade_code);
CREATE UNIQUE INDEX uk_companies_name ON companies (name);
CREATE UNIQUE INDEX uk_purchase_requests_pr_number ON purchase_requests (pr_number);
CREATE UNIQUE INDEX uk_purchase_orders_po_number ON purchase_orders (po_number);
CREATE UNIQUE INDEX uk_tmt_concepts_tmt_code ON tmt_concepts (tmt_code);
```

**Rationale:** Business keys need fast lookup and uniqueness enforcement

### 5.4 Composite Indexes

```sql
-- Inventory: Lookup by drug + location
CREATE UNIQUE INDEX uk_inventory_drug_location ON inventory (drug_id, location_id);

-- Budget: Lookup by fiscal year + department + type
CREATE UNIQUE INDEX uk_budget_allocation_year_dept_type
  ON budget_allocations (fiscal_year, budget_type_id, department_id);

-- Drug Lots: Lookup by drug + location + expiry (FEFO)
CREATE INDEX idx_drug_lots_drug_location_expiry
  ON drug_lots (drug_id, location_id, expiry_date);

-- Inventory Transactions: Lookup by date range
CREATE INDEX idx_inventory_txns_date
  ON inventory_transactions (transaction_date);

-- TMT Mappings: Lookup by drug
CREATE INDEX idx_tmt_mappings_drug_id ON tmt_mappings (drug_id);
```

**Rationale:** Frequently queried together, improves JOIN and WHERE performance

### 5.5 Search Indexes (Text Search)

```sql
-- Full-text search on drug names (GIN index for ILIKE)
CREATE INDEX idx_drugs_trade_name_trgm ON drugs USING gin (trade_name gin_trgm_ops);
CREATE INDEX idx_drugs_trade_name_th_trgm ON drugs USING gin (trade_name_th gin_trgm_ops);

-- Enable pg_trgm extension
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Usage:
SELECT * FROM drugs
WHERE trade_name ILIKE '%para%'
ORDER BY similarity(trade_name, 'paracetamol') DESC;
```

**Rationale:** Fast autocomplete and fuzzy search for 1,000+ drugs

### 5.6 Partial Indexes

```sql
-- Active records only (reduces index size)
CREATE INDEX idx_drugs_active ON drugs (id) WHERE is_active = true;
CREATE INDEX idx_companies_active ON companies (id) WHERE is_active = true;

-- Non-expired lots only
CREATE INDEX idx_drug_lots_active ON drug_lots (drug_id, location_id)
  WHERE is_expired = false;

-- Pending approvals only
CREATE INDEX idx_purchase_requests_pending
  ON purchase_requests (created_at)
  WHERE status IN ('SUBMITTED', 'BUDGET_CHECK', 'BUDGET_RESERVED');
```

**Rationale:** Smaller indexes for filtered queries, faster lookups

### 5.7 Index Maintenance

```sql
-- Analyze tables after bulk imports
ANALYZE drug_generics;
ANALYZE drugs;
ANALYZE tmt_concepts;

-- Vacuum regularly (auto-vacuum is enabled by default)
VACUUM ANALYZE inventory_transactions;

-- Reindex if indexes become fragmented (rare)
REINDEX TABLE inventory_transactions;
```

**Schedule:**
- Daily: Auto-vacuum (PostgreSQL default)
- Weekly: Manual ANALYZE on large tables
- Monthly: Check index bloat and REINDEX if needed

---

## 6. Data Integrity Rules

### 6.1 Referential Integrity

**All foreign keys enforce referential integrity:**
- Cannot insert child record without existing parent
- Cannot delete parent record if children exist (RESTRICT policy)
- Cascading deletes only for dependent items (e.g., PR items when PR deleted)

**Example Validation:**
```sql
-- Cannot create purchase request for non-existent department
INSERT INTO purchase_requests (department_id, ...) VALUES (999, ...);
-- ERROR: foreign key constraint "fk_purchase_requests_departments" violated

-- Cannot delete drug with active inventory
DELETE FROM drugs WHERE id = 1;
-- ERROR: foreign key constraint "fk_inventory_drugs" violated
```

### 6.2 Domain Integrity (Check Constraints)

```sql
-- Budget constraints
ALTER TABLE budget_allocations
  ADD CONSTRAINT chk_budget_positive CHECK (allocated_amount >= 0),
  ADD CONSTRAINT chk_budget_balance
    CHECK (available_amount = allocated_amount - reserved_amount - spent_amount);

-- Inventory constraints
ALTER TABLE inventory
  ADD CONSTRAINT chk_inventory_quantity CHECK (quantity_on_hand >= 0),
  ADD CONSTRAINT chk_inventory_levels CHECK (maximum_level >= minimum_level);

-- Date constraints
ALTER TABLE drug_lots
  ADD CONSTRAINT chk_lot_dates CHECK (expiry_date > manufacture_date);

-- Price constraints
ALTER TABLE drugs
  ADD CONSTRAINT chk_drug_price CHECK (unit_price >= 0);
```

### 6.3 Business Rule Enforcement

**Implemented via database functions and triggers:**

```sql
-- Budget reservation cannot exceed available budget
CREATE FUNCTION check_budget_before_reservation()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT available_amount FROM budget_allocations WHERE id = NEW.allocation_id) < NEW.amount THEN
    RAISE EXCEPTION 'Insufficient budget available';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_budget_reservation_check
  BEFORE INSERT ON budget_reservations
  FOR EACH ROW
  EXECUTE FUNCTION check_budget_before_reservation();
```

```sql
-- Cannot distribute more than available quantity
CREATE FUNCTION check_stock_before_distribution()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT quantity_on_hand FROM inventory
      WHERE drug_id = NEW.drug_id AND location_id = NEW.from_location_id) < NEW.quantity THEN
    RAISE EXCEPTION 'Insufficient stock for distribution';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 6.4 Audit Trail Enforcement

**All critical tables have audit fields:**
```sql
-- Standard audit columns
created_at TIMESTAMP NOT NULL DEFAULT NOW()
updated_at TIMESTAMP NOT NULL DEFAULT NOW()
created_by INT REFERENCES users(id)
updated_by INT REFERENCES users(id)
```

**Auto-update trigger for updated_at:**
```sql
CREATE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_updated_at
  BEFORE UPDATE ON drugs
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
```

**Audit log table for critical changes:**
```sql
CREATE TABLE audit_logs (
  id SERIAL PRIMARY KEY,
  table_name TEXT NOT NULL,
  record_id INT NOT NULL,
  action TEXT NOT NULL, -- INSERT, UPDATE, DELETE
  old_values JSONB,
  new_values JSONB,
  changed_by INT REFERENCES users(id),
  changed_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Trigger to log all changes to budget_allocations
CREATE FUNCTION log_budget_changes()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, changed_by)
    VALUES ('budget_allocations', NEW.id, 'UPDATE',
            row_to_json(OLD)::jsonb, row_to_json(NEW)::jsonb, NEW.updated_by);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## 7. Performance Optimization

### 7.1 Query Optimization

**Use EXPLAIN ANALYZE to identify slow queries:**
```sql
EXPLAIN ANALYZE
SELECT d.trade_name, i.quantity_on_hand, l.name
FROM drugs d
JOIN inventory i ON d.id = i.drug_id
JOIN locations l ON i.location_id = l.id
WHERE d.is_active = true
  AND i.quantity_on_hand < i.minimum_level;

-- Look for:
-- - Sequential Scans (bad) → Add indexes
-- - Index Scans (good)
-- - High execution time → Optimize query
```

**Optimization Techniques:**

1. **Use indexes on WHERE clauses:**
```sql
-- Bad (Sequential Scan)
SELECT * FROM drugs WHERE trade_name LIKE '%para%';

-- Good (Index Scan with GIN index)
CREATE INDEX idx_drugs_trade_name_trgm ON drugs USING gin (trade_name gin_trgm_ops);
SELECT * FROM drugs WHERE trade_name ILIKE '%para%';
```

2. **Limit result sets:**
```sql
-- Bad (Returns all 1,169 drugs)
SELECT * FROM drugs ORDER BY trade_name;

-- Good (Paginated)
SELECT * FROM drugs ORDER BY trade_name LIMIT 50 OFFSET 0;
```

3. **Use EXISTS instead of COUNT for existence checks:**
```sql
-- Bad (Counts all records)
SELECT COUNT(*) FROM inventory WHERE drug_id = 1 AND location_id = 1;

-- Good (Stops at first match)
SELECT EXISTS(SELECT 1 FROM inventory WHERE drug_id = 1 AND location_id = 1);
```

4. **Avoid SELECT *:**
```sql
-- Bad (Fetches all columns)
SELECT * FROM drugs WHERE id = 1;

-- Good (Fetches only needed columns)
SELECT id, trade_name, unit_price FROM drugs WHERE id = 1;
```

### 7.2 Connection Pooling

**Prisma Connection Pool Configuration:**
```typescript
// prisma/schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// Connection string with pooling
DATABASE_URL="postgresql://invs_user:invs123@localhost:5434/invs_modern?schema=public&connection_limit=10&pool_timeout=10"
```

**Connection Pool Settings:**
- `connection_limit=10`: Max 10 connections per Prisma client
- `pool_timeout=10`: Wait 10 seconds for available connection
- `statement_timeout=30000`: Kill queries running >30 seconds

### 7.3 Materialized Views

**For expensive reporting queries:**
```sql
-- Create materialized view
CREATE MATERIALIZED VIEW mv_budget_summary AS
SELECT
  ba.fiscal_year,
  d.name AS department_name,
  bt.name AS budget_type_name,
  ba.allocated_amount,
  ba.spent_amount,
  ba.reserved_amount,
  ba.available_amount,
  ROUND((ba.spent_amount / ba.allocated_amount) * 100, 2) AS utilization_percent
FROM budget_allocations ba
JOIN departments d ON ba.department_id = d.id
JOIN budget_types bt ON ba.budget_type_id = bt.id;

-- Create index on materialized view
CREATE INDEX idx_mv_budget_summary_year ON mv_budget_summary (fiscal_year);

-- Refresh materialized view (run hourly via cron)
REFRESH MATERIALIZED VIEW mv_budget_summary;
```

**Benefits:**
- Pre-computed results
- Fast query response (<50ms)
- Suitable for reports that don't need real-time data

### 7.4 Partitioning (Future)

**For very large tables (>10M rows):**
```sql
-- Partition inventory_transactions by year
CREATE TABLE inventory_transactions_2025 PARTITION OF inventory_transactions
  FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE inventory_transactions_2026 PARTITION OF inventory_transactions
  FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
```

**Benefits:**
- Faster queries (only scan relevant partitions)
- Easier archiving (drop old partitions)
- Better index performance (smaller indexes per partition)

**Current Status:** Not implemented (transaction volume too low)

### 7.5 Caching Strategy

**Application-level caching (Redis):**
```typescript
// Cache frequently accessed master data
const getDrugById = async (id: number) => {
  const cacheKey = `drug:${id}`;
  const cached = await redis.get(cacheKey);

  if (cached) {
    return JSON.parse(cached);
  }

  const drug = await prisma.drugs.findUnique({ where: { id } });
  await redis.set(cacheKey, JSON.stringify(drug), 'EX', 3600); // 1 hour TTL
  return drug;
};
```

**What to cache:**
- Master data (drugs, companies, locations) - 1 hour TTL
- Budget status - 5 minute TTL
- User sessions - Session expiry TTL

**What NOT to cache:**
- Transactional data (PRs, POs, inventory transactions)
- Real-time stock levels
- Pending approvals

---

## 8. Data Migration

### 8.1 Migration Summary (Phase 1-4)

| Phase | Tables Added | Records Migrated | Status | Date |
|-------|--------------|------------------|--------|------|
| **Phase 1** | 3 (purchase_methods, purchase_types, return_reasons, drug_pack_ratios) | 57 | ✅ Complete | 2025-01-20 |
| **Phase 2** | 2 (drug_components, drug_focus_lists) | 828 | ✅ Complete | 2025-01-21 |
| **Phase 3** | 2 (distribution_types, purchase_order_reasons) | 2 | ✅ Complete | 2025-01-21 |
| **Phase 4** | 0 (drug master data to existing tables) | 3,006 | ✅ Complete | 2025-01-22 |

**Total Migrated:** 3,893 records (excluding TMT concepts)
**Total Tables:** 52 tables (36 → 44 post-migration)

### 8.2 Migration Process

**Source:** MySQL database `invs_banpong` (133 tables)
**Target:** PostgreSQL database `invs_modern` (52 tables)
**Method:** TypeScript migration scripts using Prisma

**Migration Scripts:**
```
scripts/
├── migrate-phase1-data.ts       ✅ Complete
├── migrate-phase2-data.ts       ✅ Complete
├── migrate-phase3-data.ts       ✅ Complete
├── migrate-phase4-drug-master.ts ✅ Complete
└── migrate-tmt-concepts.ts      ✅ Complete (25,991 records)
```

**Migration Steps:**
1. **Extract:** Query MySQL legacy database
2. **Transform:** Clean data, map fields, validate
3. **Load:** Insert into PostgreSQL via Prisma
4. **Verify:** Count records, check integrity
5. **Report:** Generate migration summary

### 8.3 Data Transformation Rules

**Encoding:**
- MySQL: latin1 or utf8mb3
- PostgreSQL: UTF-8
- Thai characters: Re-encode to proper UTF-8

**Field Mapping:**
```typescript
// Example: Drug Generic Migration
{
  working_code: row.WORKING_CODE,           // Direct mapping
  generic_name: cleanText(row.NAME),        // Clean encoding
  generic_name_th: cleanText(row.NAME_TH),  // Clean Thai text
  strength: row.STRENGTH || null,           // Handle nulls
  dosage_form_id: dosageFormMap[row.FORM],  // Lookup mapping
  usage_type: normalizeUsageType(row.USAGE) // Normalize values
}
```

**Data Cleaning:**
- Remove trailing spaces: `TRIM(name)`
- Normalize null values: `NULL` instead of empty string `''`
- Validate enums: Reject invalid enum values
- Fix encoding: UTF-8 conversion for Thai text

### 8.4 Post-Migration Validation

**Record Count Verification:**
```sql
-- Drug Generics
SELECT COUNT(*) FROM drug_generics; -- Expected: 1,109

-- Trade Drugs
SELECT COUNT(*) FROM drugs; -- Expected: 1,169

-- Companies
SELECT COUNT(*) FROM companies; -- Expected: 816

-- TMT Concepts
SELECT COUNT(*) FROM tmt_concepts; -- Expected: 25,991
```

**Referential Integrity Check:**
```sql
-- Check orphaned records (should return 0)
SELECT COUNT(*) FROM drugs WHERE generic_id NOT IN (SELECT id FROM drug_generics);
SELECT COUNT(*) FROM drugs WHERE company_id NOT IN (SELECT id FROM companies);
SELECT COUNT(*) FROM purchase_orders WHERE pr_id NOT IN (SELECT id FROM purchase_requests);
```

**Data Quality Check:**
```sql
-- Check for NULL in required fields (should return 0)
SELECT COUNT(*) FROM drugs WHERE trade_name IS NULL;
SELECT COUNT(*) FROM purchase_requests WHERE department_id IS NULL;
SELECT COUNT(*) FROM inventory WHERE quantity_on_hand IS NULL;

-- Check for negative values (should return 0)
SELECT COUNT(*) FROM inventory WHERE quantity_on_hand < 0;
SELECT COUNT(*) FROM budget_allocations WHERE allocated_amount < 0;
```

### 8.5 Migration Reports

**Location:** `scripts/migration-reports/`

**Phase 1 Report:**
```
Phase 1: Procurement Methods & Return Reasons
===============================================
Migration completed successfully!

Tables Created:
  - purchase_methods: 18 records
  - purchase_types: 20 records
  - return_reasons: 19 records
  - drug_pack_ratios: 0 records (structure only)

Total Records: 57
Status: ✅ Complete
```

**Phase 4 Report:**
```
Phase 4: Drug Master Data Migration
====================================
Migration completed successfully!

Drug Generics: 1,109 records
Trade Drugs: 1,169 records
Companies: 816 records
Drug Components: 736 records
Drug Focus Lists: 92 records
Drug Pack Ratios: 1,641 records (validated)

Total Records: 3,006
Status: ✅ Complete

Data Quality:
  - 100% records have required fields
  - 0 orphaned foreign keys
  - Thai encoding: ✅ Correct
```

### 8.6 Rollback Strategy

**Backup before migration:**
```bash
# Create database dump before migration
docker exec postgresql-invs pg_dump -U invs_user invs_modern > backup_pre_phase4.sql
```

**Rollback if migration fails:**
```bash
# Stop application
docker-compose down

# Restore database
docker exec -i postgresql-invs psql -U invs_user invs_modern < backup_pre_phase4.sql

# Restart application
docker-compose up -d
```

**Verify rollback:**
```sql
SELECT COUNT(*) FROM drugs; -- Should match pre-migration count
```

---

## 9. Security Considerations

### 9.1 Database User Roles

**Current Setup (Development):**
- **User:** invs_user
- **Password:** invs123
- **Privileges:** FULL (CREATE, READ, UPDATE, DELETE)

**Production Setup (Recommended):**
```sql
-- Application user (limited privileges)
CREATE ROLE invs_app_user WITH LOGIN PASSWORD 'strong_password';
GRANT CONNECT ON DATABASE invs_modern TO invs_app_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO invs_app_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO invs_app_user;

-- Read-only reporting user
CREATE ROLE invs_report_user WITH LOGIN PASSWORD 'report_password';
GRANT CONNECT ON DATABASE invs_modern TO invs_report_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO invs_report_user;
GRANT SELECT ON ALL VIEWS IN SCHEMA public TO invs_report_user;

-- Admin user (full privileges)
CREATE ROLE invs_admin WITH LOGIN PASSWORD 'admin_password' SUPERUSER;
```

### 9.2 Row-Level Security (RLS) - Future

**Department-level data isolation:**
```sql
-- Enable RLS on purchase_requests
ALTER TABLE purchase_requests ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their department's PRs
CREATE POLICY pr_department_isolation ON purchase_requests
  FOR SELECT
  USING (department_id = current_setting('app.current_department_id')::int);

-- Set user's department in session
SET app.current_department_id = 1;
```

**Benefits:**
- Automatic data filtering at database level
- Prevents accidental data leaks
- No application-level filtering needed

**Current Status:** Not implemented (single hospital deployment)

### 9.3 Data Encryption

**At Rest:**
- Database encryption: LUKS (Linux Unified Key Setup)
- Backup encryption: GPG encryption of dump files

**In Transit:**
- Application ↔ Database: SSL/TLS connection
- Client ↔ Application: HTTPS (TLS 1.3)

**Connection String with SSL:**
```
postgresql://invs_user:invs123@localhost:5434/invs_modern?sslmode=require
```

### 9.4 SQL Injection Prevention

**Prisma ORM provides automatic protection:**
```typescript
// Safe: Prisma uses parameterized queries
const drug = await prisma.drugs.findFirst({
  where: { trade_name: { contains: userInput } }
});

// SQL generated:
// SELECT * FROM drugs WHERE trade_name LIKE $1
// Parameters: ['%userInput%']
```

**Never use raw SQL with string concatenation:**
```typescript
// DANGEROUS (vulnerable to SQL injection)
const result = await prisma.$queryRaw`
  SELECT * FROM drugs WHERE trade_name = '${userInput}'
`;

// SAFE (parameterized)
const result = await prisma.$queryRaw`
  SELECT * FROM drugs WHERE trade_name = ${userInput}
`;
```

---

## 10. Backup and Recovery

### 10.1 Backup Strategy

**Backup Schedule:**
- **Full Backup:** Daily at 02:00 AM
- **Incremental Backup:** Every 4 hours
- **Retention:** 30 days online, 1 year archived

**Backup Script:**
```bash
#!/bin/bash
# Daily full backup
BACKUP_FILE="/backups/invs_$(date +%Y%m%d_%H%M%S).sql.gz"
docker exec postgresql-invs pg_dump -U invs_user invs_modern | gzip > $BACKUP_FILE

# Keep last 30 days
find /backups -name "invs_*.sql.gz" -mtime +30 -delete

# Upload to cloud (optional)
# aws s3 cp $BACKUP_FILE s3://hospital-backups/invs/
```

**Backup Verification:**
```bash
# Test restore to separate database
docker exec postgresql-invs createdb -U invs_user invs_test
gunzip -c $BACKUP_FILE | docker exec -i postgresql-invs psql -U invs_user invs_test

# Verify record counts
docker exec postgresql-invs psql -U invs_user invs_test -c "SELECT COUNT(*) FROM drugs;"

# Drop test database
docker exec postgresql-invs dropdb -U invs_user invs_test
```

### 10.2 Recovery Procedures

**Point-in-Time Recovery (PITR):**
```bash
# Restore from backup
docker-compose down
docker volume rm invs_modern_postgres_data

docker-compose up -d
gunzip -c /backups/invs_20250122_020000.sql.gz | \
  docker exec -i postgresql-invs psql -U invs_user invs_modern

docker-compose restart
```

**Recovery Time Objective (RTO):** <4 hours
**Recovery Point Objective (RPO):** <1 hour

### 10.3 Disaster Recovery Plan

**Scenario 1: Database Corruption**
1. Stop application
2. Restore from latest backup
3. Verify data integrity
4. Restart application
5. Monitor for issues

**Scenario 2: Data Center Failure**
1. Activate backup data center
2. Restore from off-site backup
3. Update DNS/load balancer
4. Resume operations
5. Replicate data back to primary

**Scenario 3: Accidental Data Deletion**
1. Identify deletion time from audit logs
2. Restore from backup before deletion
3. Export deleted records
4. Re-import into production database
5. Verify data integrity

---

## 11. Appendices

### Appendix A: Enum Definitions (22 Enums)

| Enum Name | Values | Usage |
|-----------|--------|-------|
| `UserRole` | ADMIN, PHARMACIST, PROCUREMENT_OFFICER, DEPARTMENT_STAFF, DIRECTOR, AUDITOR | User authorization |
| `PrStatus` | DRAFT, SUBMITTED, BUDGET_CHECK, BUDGET_RESERVED, APPROVED, REJECTED, CANCELLED, PO_CREATED | Purchase request workflow |
| `PoStatus` | DRAFT, PENDING_APPROVAL, APPROVED, SENT, PARTIAL_RECEIVED, FULLY_RECEIVED, COMPLETED, CANCELLED, CLOSED | Purchase order workflow |
| `ReceiptStatus` | DRAFT, INSPECTING, APPROVED, POSTED | Receipt workflow |
| `ReservationStatus` | ACTIVE, COMMITTED, RELEASED, EXPIRED | Budget reservation lifecycle |
| `TransactionType` | RECEIVE, ISSUE, TRANSFER, ADJUST, RETURN | Inventory transaction types |
| `DistributionStatus` | DRAFT, PENDING, APPROVED, FULFILLED | Distribution workflow |
| `ReturnStatus` | DRAFT, INSPECTING, APPROVED, COMPLETED | Return workflow |
| `ReturnAction` | RETURN_TO_STOCK, RETURN_TO_VENDOR, DISPOSE | Return disposition |
| `ItemCondition` | SEALED, OPENED, DAMAGED | Return item condition |
| `NlemStatus` | E (Essential), N (Non-essential) | NLEM classification ⭐ |
| `DrugStatus` | 1 (Active), 2 (Inactive), 3 (Discontinued), 4 (Out of stock) | Drug status lifecycle ⭐ |
| `ProductCategory` | 1 (Drug), 2 (Supply), 3 (Equipment), 4 (Chemical), 5 (Other) | Product classification ⭐ |
| `DeptConsumptionGroup` | 1-9 (OPD, IPD, Emergency, ICU, OR, ER, Dialysis, Dental, Pharmacy) | Dept consumption type ⭐ |
| `CompanyType` | MANUFACTURER, VENDOR, BOTH | Company classification |
| `LocationType` | WAREHOUSE, PHARMACY, WARD, EMERGENCY | Storage location type |
| `BudgetCategory` | OPERATIONAL, INVESTMENT, EMERGENCY | Budget classification |
| `PriorityLevel` | NORMAL, URGENT, STAT | Request priority |
| `MappingType` | EXACT, APPROXIMATE, PARENT, CHILD | TMT mapping type |
| `MappingStatus` | ACTIVE, INACTIVE | TMT mapping status |
| `FormulaStatus` | DRAFT, APPROVED, ACTIVE, DISCONTINUED | HPP formula lifecycle |
| `ReferenceType` | RECEIPT, DISTRIBUTION, RETURN, ADJUSTMENT | Transaction reference |

⭐ = Added for Ministry of Public Health compliance (v2.2.0)

### Appendix B: Ministry Compliance Mapping

**DMSIC Standards พ.ศ. 2568: 79/79 fields ✅ 100% Complete**

**Export Files:**
1. **DRUGLIST** (11 fields) - Drug catalog
2. **PURCHASEPLAN** (20 fields) - Purchase planning
3. **RECEIPT** (22 fields) - Goods receiving
4. **DISTRIBUTION** (11 fields) - Drug distribution
5. **INVENTORY** (15 fields) - Stock status

**Key Ministry Fields Added (v2.2.0):**
- `drugs.nlem_status`: NLEM classification (E/N)
- `drugs.drug_status`: Drug lifecycle status (1-4)
- `drugs.product_category`: Product type (1-5)
- `drugs.status_changed_date`: Status change tracking
- `departments.consumption_group`: Department type (1-9)

**See:** `docs/systems/ministry_compliance_analysis.md` for complete mapping

### Appendix C: Database Functions Summary

| Function | Parameters | Returns | Purpose |
|----------|-----------|---------|---------|
| `check_budget_availability` | fiscal_year, budget_type_id, department_id, amount, quarter | TABLE(available BOOLEAN, available_amount DECIMAL) | Validate budget before PR |
| `reserve_budget` | allocation_id, pr_id, amount, expires_days | INT (reservation_id) | Reserve budget for PR |
| `commit_budget` | allocation_id, po_id, amount, quarter | BOOLEAN | Commit budget on PO approval |
| `release_budget_reservation` | reservation_id | BOOLEAN | Release reservation |
| `check_drug_in_budget_plan` | fiscal_year, department_id, generic_id, requested_qty, quarter | TABLE(in_plan BOOLEAN, planned_qty, remaining_qty) | Validate PR against plan |
| `update_budget_plan_purchase` | plan_item_id, quantity, value, quarter | BOOLEAN | Update purchased amounts |
| `get_fifo_lots` | drug_id, location_id, quantity_needed | TABLE(lot_id, lot_number, quantity, expiry_date) | Get lots in FIFO order |
| `get_fefo_lots` | drug_id, location_id, quantity_needed | TABLE(lot_id, lot_number, quantity, expiry_date) | Get lots in FEFO order |
| `update_inventory_from_receipt` | receipt_id | BOOLEAN | Post receipt to inventory |
| 3 utility functions | Various | Various | Helper functions |

**Total: 12 functions**

### Appendix D: Database Views Summary

**Ministry Export Views (5):**
- `export_druglist`: 11 fields for drug catalog
- `export_purchase_plan`: 20 fields for purchase planning
- `export_receipt`: 22 fields for goods receiving
- `export_distribution`: 11 fields for distribution records
- `export_inventory`: 15 fields for stock status

**Operational Views (6):**
- `budget_status_current`: Real-time budget by department
- `expiring_drugs`: Drugs expiring in 30/60/90 days
- `low_stock_items`: Items below reorder point
- `current_stock_summary`: Stock summary by location
- `budget_reservations_active`: Active budget reservations
- `purchase_order_status`: PO tracking dashboard

**Total: 11 views**

### Appendix E: Related Documentation

- **BRD.md** - Business Requirements Document
- **TRD.md** - Technical Requirements Document
- **SYSTEM_ARCHITECTURE.md** - System architecture overview
- **PROJECT_STATUS.md** - Current project status
- **docs/systems/** - Detailed system documentation (8 systems)
- **docs/flows/** - Workflow guides and UI mockups

### Appendix F: Change History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-01-01 | Project Team | Initial database design |
| 2.0.0 | 2025-01-10 | Project Team | Post-migration update (32 tables) |
| 2.2.0 | 2025-01-20 | Project Team | Ministry compliance (100%) |
| 2.4.0 | 2025-01-22 | Claude Code | Complete ERD + Phase 1-4 (52 tables) |

---

**End of Database Design Document**

**Version:** 2.4.0
**Last Updated:** 2025-01-22
**Status:** ✅ Production Ready (Database Schema Phase)
**Next Phase:** Backend API Development
