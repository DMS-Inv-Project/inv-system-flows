# Database Schema - Master Data Management

**Module**: 01-master-data
**System**: INVS Modern - Hospital Inventory Management System
**Version**: 2.2.0
**Last Updated**: 2025-01-22
**Database**: PostgreSQL 15
**ORM**: Prisma
**Scope**: Master Data Tables Only (11 tables)

---

## 📖 Table of Contents

1. [Overview](#overview)
2. [Schema Statistics](#schema-statistics)
3. [Quick Reference Table](#quick-reference-table)
4. [Master Data Tables](#master-data-tables)
   - [1. locations](#1-locations---storage-locations)
   - [2. departments](#2-departments---hospital-departments)
   - [3. budget_types](#3-budget_types---budget-type-groups)
   - [4. budget_categories](#4-budget_categories---budget-categories)
   - [5. budgets](#5-budgets---budget-allocations)
   - [6. bank](#6-bank---banks)
   - [7. companies](#7-companies---vendors-and-manufacturers)
   - [8. drug_generics](#8-drug_generics---generic-drugs)
   - [9. drugs](#9-drugs---trade-name-drugs)
   - [10. contracts](#10-contracts---purchase-contracts)
   - [11. contract_items](#11-contract_items---contract-line-items)

---

## Overview

This document provides detailed schema documentation for the **Master Data Management** module of the INVS Modern system. Master Data forms the foundation for all other modules in the system.

**Master Data Purpose**:
- Provide reference data for the entire system
- Define core entities (locations, departments, drugs, companies)
- Establish budget structure (types, categories, allocations)
- Manage contract and pricing information

**Related Modules** (refer to their own schema documentation):
- `02-budget-management` - Budget allocations, reservations, planning (4 tables)
- `03-procurement` - Purchase requests, orders, receipts (12 tables)
- `04-inventory` - Stock management, lot tracking (7 tables)
- `05-drug-return` - Distribution and returns (2 tables)
- `06-tmt-integration` - Thai Medical Terminology (7 tables)
- `07-hpp-system` - Hospital pharmaceutical products (2 tables)
- `08-his-integration` - HIS system integration (1 table)

**For Complete Database Reference**: See `docs/systems/DATABASE_SCHEMA_COMPLETE.md` (all 36 tables)

---

## Schema Statistics

### Master Data Module Summary

| Metric | Count | Details |
|--------|-------|---------|
| **Master Data Tables** | 11 | Core reference tables |
| **Estimated Records** | 2,000-10,000 | Depends on hospital size |
| **Growth Rate** | Low | Monthly updates |
| **Dependencies** | High | Referenced by all modules |
| **Enums Used** | 8 | Type-safe enumerations |
| **Foreign Keys** | 8 | Internal relationships |

### Table Size Estimates

| Table | Estimated Records | Growth Pattern |
|-------|-------------------|----------------|
| locations | 10-20 | Very Low (setup once) |
| departments | 20-50 | Very Low (organizational changes) |
| budget_types | 5-10 | Very Low (setup once) |
| budget_categories | 10-20 | Very Low (setup once) |
| budgets | 20-50 | Low (new combinations) |
| bank | 15-20 | Very Low (setup once) |
| companies | 100-500 | Medium (new vendors/manufacturers) |
| drug_generics | 500-2,000 | Medium (new drugs added) |
| drugs | 2,000-10,000 | High (new trade names, HPP products) |
| contracts | 50-200 | Medium (yearly contracts) |
| contract_items | 500-2,000 | Medium (contract details) |

---

## Quick Reference Table

### Master Data Tables (11 Tables)

| # | Table Name | Thai Name | Priority | Records | Key Purpose |
|---|------------|-----------|----------|---------|-------------|
| 1 | `locations` | สถานที่เก็บยา | ⭐⭐⭐ | 10-20 | Storage locations (warehouse, pharmacy, ward) |
| 2 | `departments` | แผนก | ⭐⭐⭐ | 20-50 | Hospital departments and structure |
| 3 | `budget_types` | ประเภทงบประมาณ | ⭐⭐ | 5-10 | Budget type groups (operational, investment) |
| 4 | `budget_categories` | หมวดงบ | ⭐⭐ | 10-20 | Budget expense categories |
| 5 | `budgets` | งบประมาณ | ⭐⭐⭐ | 20-50 | Budget type + category combinations |
| 6 | `bank` | ธนาคาร | ⭐ | 15-20 | Bank master data |
| 7 | `companies` | บริษัท | ⭐⭐⭐ | 100-500 | Vendors and manufacturers |
| 8 | `drug_generics` | ยาสามัญ | ⭐⭐⭐ | 500-2,000 | Generic drug catalog |
| 9 | `drugs` | ยาชื่อการค้า | ⭐⭐⭐ | 2,000-10,000 | Trade name drugs (ministry compliant) |
| 10 | `contracts` | สัญญาจัดซื้อ | ⭐⭐⭐ | 50-200 | Purchase contracts with vendors |
| 11 | `contract_items` | รายการในสัญญา | ⭐⭐ | 500-2,000 | Contract line items with pricing |

---

## Master Data Tables

### 1. locations - Storage Locations (สถานที่เก็บยา)

**Purpose**: Define storage locations throughout the hospital (warehouses, pharmacies, ward storage).

**Table Structure**:

| Field | Type | Length | Nullable | Default | UK | FK | Description (Thai/English) |
|-------|------|--------|----------|---------|----|----|---------------------------|
| **id** | BigInt | - | No | autoincrement | PK | - | Primary key / รหัสอ้างอิง |
| **location_code** | String | 10 | No | - | UK | - | Location code (unique) / รหัสสถานที่ |
| **location_name** | String | 100 | No | - | - | - | Location name / ชื่อสถานที่ |
| **location_type** | Enum | - | No | WAREHOUSE | - | - | Type (WAREHOUSE, PHARMACY, WARD, etc.) / ประเภทสถานที่ |
| **parent_id** | BigInt | - | Yes | null | - | FK→locations.id | Parent location for hierarchy / สถานที่แม่ |
| **address** | String | - | Yes | null | - | - | Physical address / ที่อยู่ |
| **responsible_person** | String | 50 | Yes | null | - | - | Person in charge / ผู้รับผิดชอบ |
| **is_active** | Boolean | - | No | true | - | - | Active status / สถานะใช้งาน |
| **created_at** | DateTime | - | No | now() | - | - | Creation timestamp / วันที่สร้าง |

**Relations**:
- **parent** → Location (self-reference for hierarchy)
- **children** ← Location[] (child locations)
- **inventory** ← Inventory[] (stock at this location)
- **drugLots** ← DrugLot[] (lots stored here)
- **distributionsFrom** ← DrugDistribution[] (distributions from this location)
- **distributionsTo** ← DrugDistribution[] (distributions to this location)
- **drugReturnItems** ← DrugReturnItem[] (returns to this location)

**Indexes**:
- Primary: `id`
- Unique: `location_code`
- Foreign: `parent_id`

**Business Rules**:
- Must have at least 1 WAREHOUSE location in system
- Must have at least 1 PHARMACY location in system
- Cannot delete location with inventory > 0
- Cannot delete location with child locations
- Recommended code format: `{TYPE}{NUMBER}` (e.g., WH001, PHARM01)

**Example Data**:
```sql
INSERT INTO locations (location_code, location_name, location_type, address, responsible_person)
VALUES
  ('WH001', 'คลังกลาง อาคารเภสัชกรรม', 'WAREHOUSE', 'ชั้น 1 อาคารเภสัชกรรม', 'นายสมชาย ใจดี'),
  ('PHARM-OPD', 'ห้องยาผู้ป่วยนอก', 'PHARMACY', 'ชั้น 1 อาคาร OPD', 'ภญ.สมหญิง เภสัชกร'),
  ('ICU-2A', 'คลัง ICU โซน 2A', 'WARD', 'ชั้น 2 อาคารผู้ป่วยใน', 'พยาบาล ICU');
```

---

### 2. departments - Hospital Departments (แผนก)

**Purpose**: Define hospital organizational structure and departments.

**Table Structure**:

| Field | Type | Length | Nullable | Default | UK | FK | Description |
|-------|------|--------|----------|---------|----|----|-------------|
| **id** | BigInt | - | No | autoincrement | PK | - | Primary key |
| **dept_code** | String | 10 | No | - | UK | - | Department code (unique) / รหัสแผนก |
| **dept_name** | String | 100 | No | - | - | - | Department name / ชื่อแผนก |
| **his_code** | String | 20 | Yes | null | - | - | HIS system code / รหัสใน HIS |
| **parent_id** | BigInt | - | Yes | null | - | FK→departments.id | Parent department / แผนกแม่ |
| **head_person** | String | 50 | Yes | null | - | - | Department head / หัวหน้าแผนก |
| **consumption_group** | Enum | - | Yes | null | - | - | ⭐ Ministry: Drug usage pattern (1-9) / กลุ่มการใช้ยา |
| **is_active** | Boolean | - | No | true | - | - | Active status / สถานะใช้งาน |
| **created_at** | DateTime | - | No | now() | - | - | Creation timestamp |

**Relations**:
- **parent** → Department (self-reference)
- **children** ← Department[]
- **budgetAllocations** ← BudgetAllocation[]
- **budgetPlans** ← BudgetPlan[]
- **purchaseOrders** ← PurchaseOrder[]
- **purchaseRequests** ← PurchaseRequest[]
- **drugDistributions** ← DrugDistribution[]
- **drugReturns** ← DrugReturn[]
- **tmtUsageStats** ← TmtUsageStats[]

**Indexes**:
- Primary: `id`
- Unique: `dept_code`
- Index: `his_code`
- Foreign: `parent_id`

**Ministry Compliance** ⭐:
- `consumption_group` required for departments that consume drugs
- Used in DISTRIBUTION export file (ฟิลด์ DEPT_TYPE)
- Values 1-9 represent different usage patterns (OPD/IPD mix)

**Example Data**:
```sql
INSERT INTO departments (dept_code, dept_name, his_code, consumption_group)
VALUES
  ('PHARM', 'ห้องยา', 'PHARM01', 'OPD_IPD_MIX'),
  ('OPD', 'แผนกผู้ป่วยนอก', 'OPD001', 'OPD_MAINLY'),
  ('IPD-MED', 'ห้องผู้ป่วยใน อายุรกรรม', 'IPD001', 'IPD_MAINLY');
```

---

### 3. budget_types - Budget Type Groups (ประเภทงบประมาณ)

**Purpose**: Define budget type classifications (Operational, Investment, Emergency).

| Field | Type | Length | Nullable | Default | UK | Description |
|-------|------|--------|----------|---------|----|----|
| **id** | BigInt | - | No | autoincrement | PK | Primary key |
| **type_code** | String | 10 | No | - | UK | Type code (e.g., OP001, INV001) |
| **type_name** | String | 100 | No | - | - | Type name / ชื่อประเภทงบ |
| **is_active** | Boolean | - | No | true | - | Active status |
| **created_at** | DateTime | - | No | now() | - | Creation timestamp |

**Relations**:
- **budgets** ← Budget[] (budgets using this type)

**Common Values**:
| type_code | type_name | Description |
|-----------|-----------|-------------|
| OP001 | งบดำเนินงาน - ยา | Operational - Drugs |
| OP002 | งบดำเนินงาน - เวชภัณฑ์ | Operational - Medical Supplies |
| OP003 | งบดำเนินงาน - วัสดุสิ้นเปลือง | Operational - Consumables |
| INV001 | งบลงทุน - เครื่องมือแพทย์ | Investment - Medical Equipment |
| INV002 | งบลงทุน - ระบบ IT | Investment - IT Systems |
| EM001 | งบฉุกเฉิน | Emergency Fund |

---

### 4. budget_categories - Budget Categories (หมวดค่าใช้จ่าย)

**Purpose**: Define budget expense categories for detailed budget classification.

| Field | Type | Length | Nullable | Default | UK | Description |
|-------|------|--------|----------|---------|----|----|
| **id** | BigInt | - | No | autoincrement | PK | Primary key |
| **category_code** | String | 10 | No | - | UK | Category code |
| **category_name** | String | 100 | No | - | - | Category name / ชื่อหมวดงบ |
| **acc_code** | String | 20 | Yes | null | - | Accounting code / รหัสผังบัญชี |
| **remark** | String | - | Yes | null | - | Remarks / หมายเหตุ |
| **is_active** | Boolean | - | No | true | - | Active status |
| **created_at** | DateTime | - | No | now() | - | Creation timestamp |

**Relations**:
- **budgets** ← Budget[]

**Common Values**:
| category_code | category_name | Description |
|---------------|---------------|-------------|
| CAT01 | ค่ายา | Drug expenses |
| CAT02 | ค่าเวชภัณฑ์ | Medical supply expenses |
| CAT03 | ค่าครุภัณฑ์ | Equipment expenses |
| CAT04 | ค่าบำรุงรักษา | Maintenance expenses |

---

### 5. budgets - Budget Allocations (งบประมาณ)

**Purpose**: Combine budget type and category to create specific budget classifications.

| Field | Type | Length | Nullable | Default | UK | FK | Description |
|-------|------|--------|----------|---------|----|----|-------------|
| **id** | BigInt | - | No | autoincrement | PK | - | Primary key |
| **budget_code** | String | 10 | No | - | UK | - | Combined budget code |
| **budget_type** | String | 10 | No | - | - | FK→budget_types.type_code | Budget type FK |
| **budget_category** | String | 10 | No | - | - | FK→budget_categories.category_code | Budget category FK |
| **budget_description** | String | - | Yes | null | - | - | Description / คำอธิบาย |
| **is_active** | Boolean | - | No | true | - | - | Active status |
| **created_at** | DateTime | - | No | now() | - | - | Creation timestamp |

**Relations**:
- **typeGroup** → BudgetTypeGroup (via budget_type)
- **category** → BudgetCategory (via budget_category)
- **budgetAllocations** ← BudgetAllocation[]
- **purchaseOrders** ← PurchaseOrder[]

**Business Rules**:
- Budget = Type + Category combination
- Example: `OP001-CAT01` = Operational Drugs budget
- Cannot delete if used in allocations

---

### 6. bank - Banks (ธนาคาร)

**Purpose**: Master data for banks (used in company bank accounts).

| Field | Type | Length | Nullable | Default | UK | Description |
|-------|------|--------|----------|---------|----|----|
| **bank_id** | BigInt | - | No | autoincrement | PK | Primary key |
| **bank_name** | String | 100 | No | - | - | Bank name / ชื่อธนาคาร |
| **is_active** | Boolean | - | No | true | - | Active status |
| **created_at** | DateTime | - | No | now() | - | Creation timestamp |

**Relations**:
- **companies** ← Company[] (companies with bank accounts)

**Common Banks**:
```
- ธนาคารกรุงเทพ
- ธนาคารกสิกรไทย
- ธนาคารไทยพาณิชย์
- ธนาคารกรุงไทย
- ธนาคารกรุงศรีอยุธยา
- ธนาคารออมสิน
- ธนาคารเพื่อการเกษตรและสหกรณ์การเกษตร (ธ.ก.ส.)
```

---

### 7. companies - Vendors and Manufacturers (บริษัท)

**Purpose**: Master data for drug vendors and manufacturers.

| Field | Type | Length | Nullable | Default | UK | FK | Description |
|-------|------|--------|----------|---------|----|----|-------------|
| **id** | BigInt | - | No | autoincrement | PK | - | Primary key |
| **company_code** | String | 10 | Yes | null | UK | - | Company code / รหัสบริษัท |
| **company_name** | String | 100 | No | - | - | - | Company name / ชื่อบริษัท |
| **company_type** | Enum | - | No | VENDOR | - | - | Type: VENDOR, MANUFACTURER, BOTH |
| **tax_id** | String | 20 | Yes | null | - | - | Tax ID 13 digits / เลขผู้เสียภาษี |
| **bank_code** | String | 20 | Yes | null | - | - | Bank account number / เลขบัญชี |
| **bank_account** | String | 100 | Yes | null | - | - | Bank account name / ชื่อบัญชี |
| **bank_id** | BigInt | - | Yes | null | - | FK→bank.bank_id | Bank FK |
| **address** | String | - | Yes | null | - | - | Address / ที่อยู่ |
| **phone** | String | 20 | Yes | null | - | - | Phone number / เบอร์โทร |
| **email** | String | 100 | Yes | null | - | - | Email |
| **contact_person** | String | 50 | Yes | null | - | - | Contact person / ผู้ติดต่อ |
| **tmt_manufacturer_code** | String | 20 | Yes | null | - | - | TMT manufacturer code |
| **fda_license_number** | String | 20 | Yes | null | - | - | FDA license / ใบอนุญาต อย. |
| **gmp_certificate** | String | 30 | Yes | null | - | - | GMP certificate / ใบ GMP |
| **is_active** | Boolean | - | No | true | - | - | Active status |
| **created_at** | DateTime | - | No | now() | - | - | Creation timestamp |
| **updated_at** | DateTime | - | No | now() | - | - | Last update timestamp |

**Relations**:
- **bank** → Bank (optional)
- **drugs** ← Drug[] (drugs manufactured)
- **purchaseOrders** ← PurchaseOrder[] (orders as vendor)
- **contracts** ← Contract[] (contracts)

**Company Types**:
- **VENDOR**: Vendor only (ผู้จำหน่าย)
- **MANUFACTURER**: Manufacturer only (ผู้ผลิต)
- **BOTH**: Both vendor and manufacturer

**Business Rules**:
- `company_code` must be unique if provided
- `tax_id` must be 13 digits if provided
- Cannot delete company with active purchase orders
- Cannot delete company with active contracts
- Cannot delete company linked to drugs (as manufacturer)

**Example Data**:
```sql
INSERT INTO companies (company_code, company_name, company_type, tax_id, phone, email)
VALUES
  ('GPO', 'องค์การเภสัชกรรม', 'BOTH', '0994000158378', '02-644-8000', 'contact@gpo.or.th'),
  ('ZUELLIG', 'Zuellig Pharma', 'VENDOR', '0105536001433', '02-123-4567', 'contact@zuellig.com'),
  ('PFIZER', 'Pfizer (Thailand) Ltd.', 'MANUFACTURER', '0105536002345', '02-234-5678', 'info@pfizer.co.th');
```

---

### 8. drug_generics - Generic Drugs (ยาสามัญ)

**Purpose**: Generic drug catalog (สามัญยา) - used for budget planning and reporting.

| Field | Type | Length | Nullable | Default | UK | Description |
|-------|------|--------|----------|---------|----|----|
| **id** | BigInt | - | No | autoincrement | PK | Primary key |
| **working_code** | String | 7 | No | - | UK | Working code (internal) / รหัสทำงาน |
| **drug_name** | String | 60 | No | - | - | Generic name / ชื่อสามัญ |
| **dosage_form** | String | 20 | No | - | - | Dosage form (TAB, CAP, INJ, etc.) |
| **sale_unit** | String | 5 | No | - | - | Sale unit (TAB, CAP, ml, etc.) |
| **composition** | String | 50 | Yes | null | - | Composition / ส่วนประกอบ |
| **strength** | Decimal | 10,2 | Yes | null | - | Strength value / ความแรง |
| **strength_unit** | String | 20 | Yes | null | - | Strength unit (mg, g, ml) |
| **standard_unit** | String | 10 | Yes | null | - | Standard unit / หน่วยมาตรฐาน |
| **therapeutic_group** | String | 50 | Yes | null | - | Therapeutic group / หมวดการรักษา |
| **is_active** | Boolean | - | No | true | - | Active status |
| **created_at** | DateTime | - | No | now() | - | Creation timestamp |

**TMT Fields**:
| Field | Description |
|-------|-------------|
| **tmt_vtm_code** | TMT VTM code (Virtual Therapeutic Moiety) |
| **tmt_vtm_id** | TMT VTM concept ID |
| **tmt_gp_code** | TMT GP code (Generic Product) |
| **tmt_gp_id** | TMT GP concept ID |
| **tmt_gpf_code** | TMT GP-F code (Generic Product Form) |
| **tmt_gpf_id** | TMT GP-F concept ID |
| **tmt_gpx_code** | TMT GP-X code (Generic Product Extended) |
| **tmt_gpx_id** | TMT GP-X concept ID |
| **tmt_code** | Generic TMT code |

**Relations**:
- **drugs** ← Drug[] (trade drugs linked to this generic)
- **hppProducts** ← HospitalPharmaceuticalProduct[]
- **purchaseRequestItems** ← PurchaseRequestItem[]
- **budgetPlanItems** ← BudgetPlanItem[]
- **tmtMappings** ← TmtMapping[]

**Business Rules**:
- `working_code` must be unique
- Recommended format: First 3 letters + sequential number (e.g., PAR0001, IBU0001)
- Cannot delete generic with linked trade drugs
- Used for budget planning at generic level

**Example Data**:
```sql
INSERT INTO drug_generics (working_code, drug_name, dosage_form, sale_unit, strength, strength_unit)
VALUES
  ('PAR0001', 'Paracetamol', 'TAB', 'TAB', 500, 'mg'),
  ('IBU0001', 'Ibuprofen', 'TAB', 'TAB', 400, 'mg'),
  ('AMX0001', 'Amoxicillin', 'CAP', 'CAP', 500, 'mg');
```

---

### 9. drugs - Trade Name Drugs (ยาชื่อการค้า)

**Purpose**: Trade name drug catalog with ministry compliance fields.

| Field | Type | Length | Nullable | Default | UK | FK | Description |
|-------|------|--------|----------|---------|----|----|-------------|
| **id** | BigInt | - | No | autoincrement | PK | - | Primary key |
| **drug_code** | String | 24 | No | - | UK | - | ⭐ Drug code (7-24 chars) / รหัสยา |
| **trade_name** | String | 100 | No | - | - | - | Trade name / ชื่อการค้า |
| **generic_id** | BigInt | - | Yes | null | - | FK→drug_generics.id | Generic drug FK (recommended) |
| **strength** | String | 50 | Yes | null | - | - | Strength / ความแรง |
| **dosage_form** | String | 30 | Yes | null | - | - | Dosage form / รูปแบบยา |
| **manufacturer_id** | BigInt | - | Yes | null | - | FK→companies.id | Manufacturer FK (required for ministry) |
| **atc_code** | String | 10 | Yes | null | - | - | ATC code (WHO classification) |
| **standard_code** | String | 24 | Yes | null | - | - | ⭐ 24-digit standard code / รหัสมาตรฐาน 24 หลัก |
| **barcode** | String | 20 | Yes | null | - | - | Barcode (EAN-13, EAN-8) |
| **pack_size** | Int | - | No | 1 | - | - | Pack size (units per pack) / ขนาดบรรจุ |
| **unit_price** | Decimal | 10,2 | Yes | null | - | - | Unit price (baht) / ราคาต่อหน่วย |
| **unit** | String | 10 | No | TAB | - | - | Unit (TAB, CAP, ml, etc.) |
| **is_active** | Boolean | - | No | true | - | - | Active status |
| **created_at** | DateTime | - | No | now() | - | - | Creation timestamp |
| **updated_at** | DateTime | - | No | now() | - | - | Last update timestamp |

**Ministry Compliance Fields** ⭐ (DMSIC Standards พ.ศ. 2568):

| Field | Type | Nullable | Description |
|-------|------|----------|-------------|
| **nlem_status** | Enum (E/N) | Yes | ⭐ NLEM status (E=Essential, N=Non-Essential) / สถานะบัญชียาหลัก |
| **drug_status** | Enum (1-4) | No (default: ACTIVE) | ⭐ Drug lifecycle status / สถานะวงจรชีวิต |
| **status_changed_date** | Date | Yes | ⭐ Date when status changed / วันที่เปลี่ยนสถานะ |
| **product_category** | Enum (1-5) | Yes | ⭐ Product type / ประเภทผลิตภัณฑ์ |

**TMT Fields**:
| Field | Description |
|-------|-------------|
| **tmt_tp_code** | TMT TP code (Trade Product) |
| **tmt_tp_id** | TMT TP concept ID |
| **tmt_tpu_code** | TMT TPU code (Trade Product Unit) |
| **tmt_tpu_id** | TMT TPU concept ID |
| **tmt_tpp_code** | TMT TPP code (Trade Product Pack) |
| **tmt_tpp_id** | TMT TPP concept ID |

**Hospital Product Fields**:
| Field | Description |
|-------|-------------|
| **hpp_type** | Hospital product type (R/M/F/X/OHPP) |
| **spec_prep** | Special preparation code |
| **is_hpp** | Is hospital pharmaceutical product (Boolean) |
| **base_product_id** | FK to base drug for compounded products |
| **formula_reference** | Formula reference |

**Other Fields**:
| Field | Description |
|-------|-------------|
| **nc24_code** | National Code 24-digit |
| **registration_number** | FDA registration / เลขทะเบียน อย. |
| **gpo_code** | GPO code (if applicable) |

**Relations**:
- **generic** → DrugGeneric (optional but recommended)
- **manufacturer** → Company (required for ministry compliance)
- **baseProduct** → Drug (for HPP)
- **derivedProducts** ← Drug[] (HPP derived from this drug)
- **inventory** ← Inventory[]
- **drugLots** ← DrugLot[]
- **purchaseOrderItems** ← PurchaseOrderItem[]
- **receiptItems** ← ReceiptItem[]
- **tmtMappings** ← TmtMapping[]
- **drugDistributionItems** ← DrugDistributionItem[]
- **contractItems** ← ContractItem[]
- **drugReturnItems** ← DrugReturnItem[]
- **hppBaseReferences** ← HospitalPharmaceuticalProduct[]
- **hppProducts** ← HospitalPharmaceuticalProduct[]

**Business Rules**:
- `drug_code` must be unique (7-24 characters)
- `standard_code` should be 24 characters if provided
- `pack_size` must be > 0
- Ministry compliance fields required for DRUGLIST export
- Cannot delete drug with inventory > 0
- Cannot delete drug with active contracts
- Should set `drug_status = REMOVED` instead of deleting

**Example Data**:
```sql
INSERT INTO drugs (
  drug_code, trade_name, generic_id, manufacturer_id, strength,
  dosage_form, pack_size, unit_price, unit,
  nlem_status, drug_status, product_category, status_changed_date
)
VALUES
  ('SARA500', 'Sara 500mg', 1, 1, '500 mg', 'TAB', 1000, 2.50, 'TAB',
   'E', 'ACTIVE', 'MODERN_REGISTERED', '2025-01-01'),
  ('TYLENOL500', 'Tylenol 500mg', 1, 3, '500 mg', 'TAB', 100, 3.50, 'TAB',
   'E', 'ACTIVE', 'MODERN_REGISTERED', '2025-01-01');
```

---

### 10. contracts - Purchase Contracts (สัญญาจัดซื้อ)

**Purpose**: Manage purchase contracts with vendors (pricing agreements and quantity commitments).

| Field | Type | Length | Nullable | Default | UK | FK | Description |
|-------|------|--------|----------|---------|----|----|-------------|
| **id** | BigInt | - | No | autoincrement | PK | - | Primary key |
| **contract_number** | String | 20 | No | - | UK | - | Contract number / เลขที่สัญญา |
| **contract_type** | Enum | - | No | - | - | - | Contract type (E_BIDDING, PRICE_AGREEMENT, etc.) |
| **vendor_id** | BigInt | - | No | - | - | FK→companies.id | Vendor FK / บริษัทผู้ขาย |
| **start_date** | Date | - | No | - | - | - | Contract start date / วันที่เริ่มสัญญา |
| **end_date** | Date | - | No | - | - | - | Contract end date / วันที่สิ้นสุดสัญญา |
| **total_value** | Decimal | 15,2 | No | - | - | - | Total contract value (baht) / มูลค่ารวม |
| **remaining_value** | Decimal | 15,2 | No | - | - | - | Remaining value / มูลค่าคงเหลือ |
| **fiscal_year** | String | 4 | No | - | - | - | Fiscal year (BE) / ปีงบประมาณ พ.ศ. |
| **status** | Enum | - | No | ACTIVE | - | - | Contract status |
| **contract_document** | String | 255 | Yes | null | - | - | Path to contract PDF |
| **approved_by** | String | 50 | Yes | null | - | - | Approver name |
| **approval_date** | Date | Yes | null | - | - | Approval date |

**Project Reference Fields**:
| Field | Length | Description |
|-------|--------|-------------|
| **committee_number** | 20 | Committee number / เลขที่คณะกรรมการ |
| **committee_name** | 60 | Committee name / ชื่อคณะกรรมการ |
| **committee_date** | Date | Committee approval date |
| **egp_number** | 30 | e-GP reference number / เลขที่ e-GP |
| **project_number** | 30 | Project code / รหัสโครงการ |
| **gf_number** | 10 | GF code |
| **notes** | Text | Notes / หมายเหตุ |

**System Fields**:
| Field | Description |
|-------|-------------|
| **created_at** | Creation timestamp |
| **updated_at** | Last update timestamp |

**Relations**:
- **vendor** → Company (vendor company)
- **items** ← ContractItem[] (contract line items)
- **purchaseOrders** ← PurchaseOrder[] (POs under this contract)

**Contract Types**:
| Value | Thai Name | Description |
|-------|-----------|-------------|
| E_BIDDING | ประกวดราคาอิเล็กทรอนิกส์ | Electronic bidding |
| PRICE_AGREEMENT | ตกลงราคา | Price agreement |
| QUOTATION | เฉพาะเจาะจง | Direct quotation |
| SPECIAL | พิเศษ | Special procurement |

**Contract Status**:
| Value | Thai Name | Description |
|-------|-----------|-------------|
| DRAFT | ร่าง | Draft contract |
| ACTIVE | ใช้งาน | Active contract |
| EXPIRED | หมดอายุ | Expired by date |
| CANCELLED | ยกเลิก | Cancelled |

**Business Rules**:
- `start_date` must be < `end_date`
- `remaining_value` = `total_value` initially
- `remaining_value` decreases when POs created
- Cannot create PO if `remaining_value` < PO amount
- Cannot delete contract with purchase orders
- Recommended contract number format: `CNT-{YEAR}-{NUMBER}`

**Example Data**:
```sql
INSERT INTO contracts (
  contract_number, contract_type, vendor_id,
  start_date, end_date, total_value, remaining_value,
  fiscal_year, status
)
VALUES
  ('CNT-2568-001', 'E_BIDDING', 1, '2025-01-01', '2025-12-31',
   1000000.00, 1000000.00, '2568', 'ACTIVE');
```

---

### 11. contract_items - Contract Line Items (รายการในสัญญา)

**Purpose**: Drugs included in contracts with agreed pricing and quantities.

| Field | Type | Length | Nullable | Default | UK | FK | Description |
|-------|------|--------|----------|---------|----|----|-------------|
| **id** | BigInt | - | No | autoincrement | PK | - | Primary key |
| **contract_id** | BigInt | - | No | - | - | FK→contracts.id | Contract FK |
| **drug_id** | BigInt | - | No | - | - | FK→drugs.id | Drug FK |
| **unit_price** | Decimal | 10,2 | No | - | - | - | Contract price per unit / ราคาตามสัญญา |
| **quantity_contracted** | Decimal | 10,2 | No | - | - | - | Total quantity contracted / จำนวนรวม |
| **quantity_remaining** | Decimal | 10,2 | No | - | - | - | Remaining quantity / จำนวนคงเหลือ |
| **min_order_quantity** | Decimal | 10,2 | Yes | null | - | - | Minimum order qty / จำนวนสั่งซื้อขั้นต่ำ |
| **max_order_quantity** | Decimal | 10,2 | Yes | null | - | - | Maximum order qty / จำนวนสั่งซื้อสูงสุด |
| **notes** | Text | - | Yes | null | - | - | Notes / หมายเหตุ |
| **created_at** | DateTime | - | No | now() | - | - | Creation timestamp |
| **updated_at** | DateTime | - | No | now() | - | - | Last update timestamp |

**Relations**:
- **contract** → Contract (parent contract)
- **drug** → Drug (drug item)

**Unique Constraints**:
- `@@unique([contract_id, drug_id])` - One drug per contract

**Business Rules**:
- Same drug can appear in multiple contracts (different vendors/prices)
- `quantity_remaining` ≤ `quantity_contracted`
- `unit_price` can differ from `drugs.unit_price` (contract price overrides)
- Cannot modify quantities after first PO created

**Example Data**:
```sql
INSERT INTO contract_items (
  contract_id, drug_id, unit_price,
  quantity_contracted, quantity_remaining
)
VALUES
  (1, 1, 2.30, 500000, 500000),  -- Sara 500mg: 500,000 tabs @ 2.30 baht
  (1, 2, 3.20, 300000, 300000);  -- Tylenol 500mg: 300,000 tabs @ 3.20 baht
```

---

## Document Status

**Module Scope**: ✅ Master Data Management (11 tables)
**Completion Status**: ✅ 100% Complete
**Last Updated**: 2025-01-22
**Version**: 2.2.0

---

## Summary

This document provides complete schema documentation for the **Master Data Management** module (11 tables). Master Data forms the foundational reference data for all other system modules.

### What's Documented Here

**✅ Complete Coverage (11 Master Data Tables)**:

1. **Storage & Organization** (2 tables):
   - `locations` - Storage locations (warehouse, pharmacy, ward)
   - `departments` - Hospital departments and structure

2. **Budget Structure** (3 tables):
   - `budget_types` - Budget type groups (operational, investment, emergency)
   - `budget_categories` - Budget expense categories
   - `budgets` - Budget type + category combinations

3. **Financial** (1 table):
   - `bank` - Bank master data

4. **Vendors & Products** (3 tables):
   - `companies` - Vendors and manufacturers
   - `drug_generics` - Generic drug catalog (working codes)
   - `drugs` - Trade name drugs (ministry compliant ⭐)

5. **Contracts** (2 tables):
   - `contracts` - Purchase contracts with vendors
   - `contract_items` - Contract line items with pricing

---

### Related System Modules

For other module documentation, see:

| Module | Tables | Location |
|--------|--------|----------|
| **Budget Management** | 4 tables | `docs/systems/02-budget-management/detailed/01-SCHEMA.md` |
| **Procurement** | 12 tables | `docs/systems/03-procurement/detailed/01-SCHEMA.md` |
| **Inventory** | 7 tables | `docs/systems/04-inventory/detailed/01-SCHEMA.md` |
| **Drug Return** | 2 tables | `docs/systems/05-drug-return/detailed/01-SCHEMA.md` |
| **TMT Integration** | 7 tables | `docs/systems/06-tmt-integration/detailed/01-SCHEMA.md` |
| **HPP System** | 2 tables | `docs/systems/07-hpp-system/detailed/01-SCHEMA.md` |
| **HIS Integration** | 1 table | `docs/systems/08-his-integration/detailed/01-SCHEMA.md` |
| **Complete Database** | All 36 tables | `docs/systems/DATABASE_SCHEMA_COMPLETE.md` ⭐ |

---

### Key Features Covered

**Master Data Capabilities**:
- ✅ **Location Hierarchy**: Multi-level storage location management
- ✅ **Department Structure**: Hierarchical organization with ministry compliance
- ✅ **Budget Framework**: Type + Category combination system
- ✅ **Vendor Management**: Comprehensive vendor/manufacturer database
- ✅ **Drug Catalog**: Generic + Trade name with TMT integration
- ✅ **Contract System**: Pricing agreements and quantity tracking
- ✅ **Ministry Compliance**: DMSIC Standards พ.ศ. 2568 (100% compliant) ⭐

**Data Relationships**:
- 8 Foreign Key relationships within Master Data tables
- Referenced by 25+ tables in other modules
- Foundation for budget control, procurement, and inventory

**Enums Used**:
| Enum | Values | Used In |
|------|--------|---------|
| `LocationType` | WAREHOUSE, PHARMACY, WARD, EMERGENCY, OPERATING_ROOM | locations |
| `CompanyType` | VENDOR, MANUFACTURER, BOTH | companies |
| `ContractType` | E_BIDDING, PRICE_AGREEMENT, QUOTATION, SPECIAL | contracts |
| `ContractStatus` | DRAFT, ACTIVE, EXPIRED, CANCELLED | contracts |
| `NlemStatus` | E, N | drugs ⭐ |
| `DrugStatus` | ACTIVE, SUSPENDED, REMOVED, INVESTIGATIONAL | drugs ⭐ |
| `ProductCategory` | MODERN_REGISTERED, MODERN_NOT_REGISTERED, TRADITIONAL_REGISTERED, etc. | drugs ⭐ |
| `DeptConsumptionGroup` | OPD_MAINLY, IPD_MAINLY, OPD_IPD_MIX, etc. | departments ⭐ |

---

### Technical References

**Schema Source**:
- **Prisma Schema**: `prisma/schema.prisma` (Master Data section, lines 1-400)
- **Business Functions**: `prisma/functions.sql` (12 functions total, Master Data used by all)
- **Reporting Views**: `prisma/views.sql` (11 views total)

**API Documentation**:
- **API Specification**: `docs/systems/01-master-data/api/API_SPECIFICATION.md`
- **Base Path**: `/api/master-data/*`
- **Endpoints**: 11 entity endpoints (locations, departments, drugs, etc.)

**Related Documentation**:
- **Validation Rules**: `03-VALIDATION-RULES.md`
- **State Machines**: `02-STATE-MACHINES.md`
- **Authorization**: `04-AUTHORIZATION.md`
- **Test Cases**: `05-TEST-CASES.md`
- **Integration**: `06-INTEGRATION.md`
- **Business Rules**: `07-BUSINESS-RULES.md`
- **Error Codes**: `08-ERROR-CODES.md`
- **Data Constraints**: `09-DATA-CONSTRAINTS.md`

---

### Statistics

| Metric | Value |
|--------|-------|
| **Tables Documented** | 11 |
| **Total Fields** | ~120 fields |
| **Foreign Keys** | 8 relationships |
| **Unique Constraints** | 11 (one per table minimum) |
| **Enums Referenced** | 8 enums |
| **Estimated Records** | 2,000-10,000 |
| **Documentation Lines** | ~680 lines |

---

### Document Template

This Master Data schema documentation serves as the **template and standard** for the other 7 system modules. Each module should follow this structure:

1. **Header**: Module name, scope, version
2. **Table of Contents**: Clear navigation
3. **Overview**: Purpose and relationships
4. **Statistics**: Table counts and estimates
5. **Quick Reference**: Summary table
6. **Detailed Tables**: Field-by-field documentation
7. **Document Status**: Completion and references

---

**End of Master Data Schema Documentation**

*Part of INVS Modern - Hospital Inventory Management System v2.2.0*
*Built with ❤️ for healthcare excellence*
