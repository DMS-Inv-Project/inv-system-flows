# Data Constraints - Master Data Management System

**Module**: Master Data
**Version**: 1.0.0
**Last Updated**: 2025-01-21
**Audience**: System Analysts, Business Analysts, Developers

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Location Constraints](#location-constraints)
3. [Department Constraints](#department-constraints)
4. [Company Constraints](#company-constraints)
5. [Drug Generic Constraints](#drug-generic-constraints)
6. [Drug Constraints](#drug-constraints)
7. [Budget-Related Constraints](#budget-related-constraints)
8. [Contract Constraints](#contract-constraints)
9. [Cross-Entity Business Rules](#cross-entity-business-rules)
10. [Ministry Compliance Constraints](#ministry-compliance-constraints)
11. [Data Quality Rules](#data-quality-rules)

---

## Overview

This document defines all data constraints, field limits, formats, and business rules for Master Data entities. These constraints ensure data quality, consistency, and compliance with business requirements and ministry regulations.

### Constraint Types

- **Field Constraints**: Length, format, data type, ranges
- **Business Rules**: Validation logic, state transitions, dependencies
- **Referential Integrity**: Foreign key constraints, cascade rules
- **Ministry Compliance**: Required fields for DMSIC Standards พ.ศ. 2568

---

## Location Constraints

### Table: `locations`

#### Field Constraints

| Field | Data Type | Required | Length/Range | Format | Unique | Notes |
|-------|-----------|----------|--------------|--------|--------|-------|
| **id** | BigInt | Yes | Auto | - | Yes | Primary key, auto-increment |
| **locationCode** | String | Yes | 3-20 chars | `^[A-Z0-9-]+$` | Yes | Uppercase letters, numbers, hyphen only |
| **locationName** | String | Yes | 1-100 chars | Thai/English | No | ชื่อสถานที่ (ไทย/อังกฤษ) |
| **locationType** | Enum | Yes | - | See enum values | No | WAREHOUSE, PHARMACY, WARD, EMERGENCY, OR, ICU, GENERAL |
| **parentId** | BigInt | No | - | Must exist in locations | No | Self-reference for hierarchy |
| **address** | String | No | 0-200 chars | Thai/English | No | ที่อยู่/รายละเอียดตำแหน่ง |
| **responsiblePerson** | String | No | 0-100 chars | Thai/English | No | ชื่อผู้รับผิดชอบ |
| **isActive** | Boolean | Yes | - | true/false | No | Default: true |
| **createdAt** | DateTime | Yes | Auto | ISO 8601 | No | Auto-generated |
| **updatedAt** | DateTime | Yes | Auto | ISO 8601 | No | Auto-updated |

#### Business Rules

1. **Uniqueness**:
   - `locationCode` must be unique across all locations
   - Cannot create duplicate location codes

2. **Hierarchy**:
   - `parentId` must reference an existing location
   - Cannot set self as parent (`parentId ≠ id`)
   - Maximum hierarchy depth: 3 levels (recommended)
   - Circular references not allowed

3. **System Requirements**:
   - Must have at least 1 WAREHOUSE location in system
   - Must have at least 1 PHARMACY location in system

4. **Deletion Rules**:
   - Cannot delete location with active inventory records
   - Cannot delete location with child locations
   - Can only soft delete (set `isActive = false`)

5. **Code Format**:
   - Recommended format: `{TYPE}{NUMBER}` (e.g., WH001, PHARM01)
   - Examples:
     - `WH001` - Warehouse 1
     - `PHARM-OPD` - OPD Pharmacy
     - `ICU-2A` - ICU Zone 2A

#### Example Valid Data

```json
{
  "locationCode": "WH001",
  "locationName": "คลังกลาง อาคารเภสัชกรรม",
  "locationType": "WAREHOUSE",
  "parentId": null,
  "address": "ชั้น 1 อาคารเภสัชกรรม",
  "responsiblePerson": "นายสมชาย ใจดี",
  "isActive": true
}
```

---

## Department Constraints

### Table: `departments`

#### Field Constraints

| Field | Data Type | Required | Length/Range | Format | Unique | Notes |
|-------|-----------|----------|--------------|--------|--------|-------|
| **id** | BigInt | Yes | Auto | - | Yes | Primary key |
| **deptCode** | String | Yes | 2-20 chars | `^[A-Z0-9-]+$` | Yes | Uppercase letters, numbers, hyphen |
| **deptName** | String | Yes | 1-100 chars | Thai/English | No | ชื่อแผนก |
| **hisCode** | String | No | 1-20 chars | Any | No | รหัสใน HIS system |
| **parentId** | BigInt | No | - | Must exist | No | Parent department |
| **headPerson** | String | No | 0-100 chars | Thai/English | No | หัวหน้าแผนก |
| **consumptionGroup** | Enum | No | - | 1-9 | No | Ministry field (รูปแบบการใช้ยา) |
| **isActive** | Boolean | Yes | - | true/false | No | Default: true |
| **createdAt** | DateTime | Yes | Auto | ISO 8601 | No | Auto-generated |
| **updatedAt** | DateTime | Yes | Auto | ISO 8601 | No | Auto-updated |

#### Consumption Group Values (Ministry Compliance)

| Value | Code | Description (Thai) | Description (English) | Usage Pattern |
|-------|------|-------------------|----------------------|---------------|
| **OPD_IPD_MIX** | 1 | ผสม OPD + IPD | Mixed OPD and IPD | OPD 40-60%, IPD 40-60% |
| **OPD_MAINLY** | 2 | OPD เป็นหลัก | Mainly OPD | OPD > 70% |
| **IPD_MAINLY** | 3 | IPD เป็นหลัก | Mainly IPD | IPD > 70% |
| **OTHER_INTERNAL** | 4 | อื่นๆ ภายใน รพ. | Other internal | OR, X-ray, Lab, ICU |
| **PRIMARY_CARE** | 5 | ศูนย์สุขภาพชุมชน | Primary care unit | รพ.สต., สอ. |
| **PC_TRANSFERRED** | 6 | ส่งต่อจากศูนย์สุขภาพ | Transferred from PC | ยาที่ รพ.สต. ส่งต่อมา |
| **OTHER_EXTERNAL** | 9 | อื่นๆ นอก รพ. | Other external | หน่วยงานภายนอก |

#### Business Rules

1. **Uniqueness**:
   - `deptCode` must be unique
   - `hisCode` should be unique if provided

2. **Hierarchy**:
   - `parentId` must reference existing department
   - Cannot set self as parent
   - Maximum depth: 3 levels

3. **Ministry Compliance**:
   - `consumptionGroup` required for departments that consume drugs
   - Used for ministry reporting (DISTRIBUTION file)

4. **Deletion Rules**:
   - Cannot delete department with active budget allocations
   - Cannot delete department with active purchase requests
   - Cannot delete department with child departments
   - Soft delete only

#### Example Valid Data

```json
{
  "deptCode": "PHARM",
  "deptName": "ห้องยา",
  "hisCode": "PHARM01",
  "parentId": null,
  "headPerson": "ภญ.สมหญิง เภสัชกร",
  "consumptionGroup": "OPD_IPD_MIX",
  "isActive": true
}
```

---

## Company Constraints

### Table: `companies`

#### Field Constraints

| Field | Data Type | Required | Length/Range | Format | Unique | Notes |
|-------|-----------|----------|--------------|--------|--------|-------|
| **id** | BigInt | Yes | Auto | - | Yes | Primary key |
| **companyCode** | String | Yes | 2-20 chars | `^[A-Z0-9-]+$` | Yes | Uppercase, numbers, hyphen |
| **companyName** | String | Yes | 1-200 chars | Thai/English | No | ชื่อบริษัท |
| **companyType** | Enum | Yes | - | VENDOR, MANUFACTURER, BOTH | No | ประเภทบริษัท |
| **taxId** | String | No | 13 chars | `^\d{13}$` | No | เลขผู้เสียภาษี 13 หลัก |
| **address** | String | No | 0-300 chars | Thai/English | No | ที่อยู่ |
| **phone** | String | No | 9-20 chars | See phone format | No | เบอร์โทรศัพท์ |
| **email** | String | No | 5-100 chars | Valid email format | No | อีเมล |
| **contactPerson** | String | No | 0-100 chars | Thai/English | No | ชื่อผู้ติดต่อ |
| **bankId** | BigInt | No | - | Must exist in banks | No | FK to banks table |
| **isActive** | Boolean | Yes | - | true/false | No | Default: true |
| **createdAt** | DateTime | Yes | Auto | ISO 8601 | No | Auto-generated |
| **updatedAt** | DateTime | Yes | Auto | ISO 8601 | No | Auto-updated |

#### Phone Number Formats (Thailand)

Acceptable formats:
- `02-123-4567` (Bangkok landline)
- `081-234-5678` (Mobile)
- `0812345678` (Mobile without hyphen)
- `+66812345678` (International format)

Regex: `^(\+66|0)[0-9]{8,9}$` or with hyphens: `^(\+66|0)[0-9]{1,2}-?[0-9]{3,4}-?[0-9]{4}$`

#### Tax ID Format (Thailand)

- Must be exactly 13 digits
- Format: `XXXXXXXXXXX XX` (no spaces in storage, display with spaces)
- Example: `0994000158378`
- Validation: Must follow Thai Tax ID checksum algorithm (optional)

#### Email Format

- Must follow RFC 5322 email format
- Example: `contact@gpo.co.th`
- Regex: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`

#### Business Rules

1. **Uniqueness**:
   - `companyCode` must be unique
   - `taxId` should be unique if provided (one company per tax ID)

2. **Company Type**:
   - `VENDOR` - Can be selected in purchase orders
   - `MANUFACTURER` - Can be linked to drugs
   - `BOTH` - Can be both vendor and manufacturer

3. **Financial Data**:
   - `taxId` required for contracts > 100,000 baht
   - `bankId` required for electronic payments

4. **Deletion Rules**:
   - Cannot delete company with active purchase orders
   - Cannot delete company with active contracts
   - Cannot delete company linked to drugs (as manufacturer)
   - Soft delete only

5. **Immutable Fields** (cannot change after creation):
   - `companyCode` - Cannot change

6. **Role-Based Updates**:
   - PHARMACIST can update: name, address, phone, email, contactPerson
   - FINANCE can update: taxId, bankId, bank details
   - ADMIN can update all fields

#### Example Valid Data

```json
{
  "companyCode": "GPO",
  "companyName": "องค์การเภสัชกรรม",
  "companyType": "BOTH",
  "taxId": "0994000158378",
  "address": "75/1 ถนนพระราม 6 ราชเทวี กรุงเทพฯ 10400",
  "phone": "02-644-8000",
  "email": "contact@gpo.or.th",
  "contactPerson": "นายติดต่อ GPO",
  "isActive": true
}
```

---

## Drug Generic Constraints

### Table: `drug_generics`

#### Field Constraints

| Field | Data Type | Required | Length/Range | Format | Unique | Notes |
|-------|-----------|----------|--------------|--------|--------|-------|
| **id** | BigInt | Yes | Auto | - | Yes | Primary key |
| **genericCode** | String | Yes | 3-20 chars | `^[A-Z0-9-]+$` | Yes | รหัสยาสามัญ |
| **genericName** | String | Yes | 1-200 chars | English | No | ชื่อสามัญ (English) |
| **workingCode** | String | No | 3-20 chars | `^[A-Z0-9]+$` | Yes | รหัสทำงาน (internal code) |
| **dosageForm** | String | No | 1-50 chars | See dosage forms | No | รูปแบบยา |
| **strength** | String | No | 1-50 chars | Number + Unit | No | ความแรง (e.g., "500") |
| **unit** | String | No | 1-20 chars | mg, g, ml, etc. | No | หน่วย |
| **therapeuticClass** | String | No | 1-100 chars | Any | No | หมวดการรักษา |
| **isActive** | Boolean | Yes | - | true/false | No | Default: true |
| **createdAt** | DateTime | Yes | Auto | ISO 8601 | No | Auto-generated |
| **updatedAt** | DateTime | Yes | Auto | ISO 8601 | No | Auto-updated |

#### Common Dosage Forms

| Code | Thai Name | English Name | Examples |
|------|-----------|--------------|----------|
| **TAB** | เม็ด | Tablet | Paracetamol tab 500mg |
| **CAP** | แคปซูล | Capsule | Amoxicillin cap 250mg |
| **INJ** | ฉีด | Injection | Insulin inj 100u/ml |
| **SYR** | น้ำเชื่อม | Syrup | Paracetamol syr 120mg/5ml |
| **SOL** | สารละลาย | Solution | NaCl 0.9% sol |
| **CRE** | ครีม | Cream | Hydrocortisone cre 1% |
| **OIN** | ขี้ผึ้ง | Ointment | Gentamicin oin |
| **SUS** | ซัสเพนชั่น | Suspension | Amoxicillin sus 250mg/5ml |
| **DRO** | หยด | Drops | Eye drop, ear drop |
| **INH** | สูดพ่น | Inhaler | Salbutamol inh |

#### Strength Format Examples

- `500` (with unit in separate field: mg)
- `250` (unit: mg)
- `1` (unit: g)
- `100` (unit: u/ml)

#### Business Rules

1. **Uniqueness**:
   - `genericCode` must be unique
   - `workingCode` must be unique if provided

2. **Name Format**:
   - `genericName` should be in English (international name)
   - Use proper capitalization (e.g., "Paracetamol" not "PARACETAMOL")

3. **Deletion Rules**:
   - Cannot delete generic with linked trade drugs
   - Cannot delete generic with active inventory
   - Soft delete only

4. **Code Format**:
   - Recommended: Use first 3 letters + sequential number
   - Examples:
     - `PAR001` - Paracetamol
     - `IBU001` - Ibuprofen
     - `AMX001` - Amoxicillin

#### Example Valid Data

```json
{
  "genericCode": "PAR001",
  "genericName": "Paracetamol",
  "workingCode": "PAR0001",
  "dosageForm": "TAB",
  "strength": "500",
  "unit": "mg",
  "therapeuticClass": "Analgesic/Antipyretic",
  "isActive": true
}
```

---

## Drug Constraints

### Table: `drugs`

#### Field Constraints

| Field | Data Type | Required | Length/Range | Format | Unique | Notes |
|-------|-----------|----------|--------------|--------|--------|-------|
| **id** | BigInt | Yes | Auto | - | Yes | Primary key |
| **drugCode** | String | Yes | 7-24 chars | `^[A-Z0-9]+$` | Yes | รหัสยาชื่อการค้า (24-digit standard) |
| **tradeName** | String | Yes | 1-200 chars | Thai/English | No | ชื่อการค้า |
| **genericId** | BigInt | No | - | Must exist | No | FK to drug_generics (recommended) |
| **manufacturerId** | BigInt | No | - | Must exist | No | FK to companies (required for ministry) |
| **strength** | String | No | 1-50 chars | Number + Unit | No | ความแรง (e.g., "500 mg") |
| **dosageForm** | String | No | 1-50 chars | See forms | No | รูปแบบยา |
| **packSize** | Int | Yes | 1-999,999 | Integer | No | ขนาดบรรจุ (units per pack) |
| **unitPrice** | Decimal | No | 0.0001-9,999,999.9999 | Decimal(10,4) | No | ราคาต่อหน่วย (บาท) |
| **unit** | String | Yes | 1-20 chars | TAB, CAP, etc. | No | หน่วยขาย |
| **standardCode** | String | No | 24 chars | 24-digit code | No | รหัสมาตรฐาน 24 หลัก ⭐ |
| **barcode** | String | No | 8-13 chars | EAN-8/EAN-13 | No | บาร์โค้ด |
| **atcCode** | String | No | 7 chars | ATC format | No | รหัส ATC |
| **nlemStatus** | Enum | No | - | E, N | No | ⭐ Ministry: ยาหลัก/เสริม |
| **drugStatus** | Enum | Yes | - | 1-4 | No | ⭐ Ministry: สถานะยา |
| **productCategory** | Enum | No | - | 1-5 | No | ⭐ Ministry: ประเภทผลิตภัณฑ์ |
| **statusChangedDate** | DateTime | No | Auto | ISO 8601 | No | ⭐ Ministry: วันที่เปลี่ยนสถานะ |
| **tmtTpuCode** | String | No | 1-20 chars | TMT code | No | รหัส TMT |
| **tmtTpuId** | BigInt | No | - | FK to tmt_concepts | No | TMT concept ID |
| **isActive** | Boolean | Yes | - | true/false | No | Default: true |
| **createdAt** | DateTime | Yes | Auto | ISO 8601 | No | Auto-generated |
| **updatedAt** | DateTime | Yes | Auto | ISO 8601 | No | Auto-updated |

#### Drug Code Formats

**24-Digit Standard Code** (รหัสมาตรฐาน 24 หลัก):
- Format: `XXYYYYYYYYYYYYYYYYYYYYYY`
- Total: 24 characters (uppercase letters and numbers)
- Example: `10123456789012345678SARA`
- Components:
  - First 2 digits: Category code
  - Next 18 digits: Sequential/classification
  - Last 4 digits: Product identifier

**Trade Code** (7-24 characters):
- Can be shorter than 24 digits for internal use
- Must be unique
- Examples:
  - `SARA500` (7 chars)
  - `TYLENOL500` (10 chars)
  - `GPO-PARA500` (11 chars)

#### NLEM Status (บัญชียาหลักแห่งชาติ) ⭐ Ministry Compliance

| Value | Code | Thai Name | English Name | Usage |
|-------|------|-----------|--------------|-------|
| **E** | E | ยาหลัก | Essential Drug | ยาในบัญชียาหลักแห่งชาติ |
| **N** | N | ยาเสริม | Non-Essential | ยานอกบัญชียาหลัก |

**Business Rules**:
- Required for ministry DRUGLIST export
- E-drugs have priority in budget planning
- E-drugs typically have price controls

#### Drug Status (สถานะวงจรชีวิต) ⭐ Ministry Compliance

| Value | Code | Thai Name | English Name | Description |
|-------|------|-----------|--------------|-------------|
| **ACTIVE** | 1 | ใช้งานปกติ | Active | Currently in use, can order/dispense |
| **DISCONTINUED** | 2 | ตัดจากบัญชีแต่ยังมียาเหลือ | Discontinued | No longer ordered, but stock remains |
| **SPECIAL_CASE** | 3 | ยาเฉพาะราย | Special Approval Required | Requires special approval before use |
| **REMOVED** | 4 | ตัดออกและไม่มียาเหลือ | Removed | Completely removed, no stock |

**State Transitions**:
```
ACTIVE → DISCONTINUED → REMOVED
ACTIVE → SPECIAL_CASE → DISCONTINUED → REMOVED
```

**Business Rules**:
- Status changes must update `statusChangedDate` automatically
- Reason required when changing from ACTIVE to DISCONTINUED (min 10 chars)
- Cannot create new purchase requests for DISCONTINUED drugs
- Cannot dispense REMOVED drugs

#### Product Category (ประเภทผลิตภัณฑ์) ⭐ Ministry Compliance

| Value | Code | Thai Name | English Name |
|-------|------|-----------|--------------|
| **MODERN_REGISTERED** | 1 | ยาแผนปัจจุบันที่ขึ้นทะเบียน อย. | Registered Modern Medicine |
| **MODERN_HOSPITAL** | 2 | ยาแผนปัจจุบันที่ผลิตใน รพ. | Hospital-Made Modern Medicine |
| **HERBAL_REGISTERED** | 3 | ยาสมุนไพรที่ขึ้นทะเบียน | Registered Herbal Medicine |
| **HERBAL_HOSPITAL** | 4 | ยาสมุนไพรที่ผลิตใน รพ. | Hospital-Made Herbal Medicine |
| **OTHER** | 5 | อื่นๆ | Other |

#### Pack Size Rules

- Minimum: 1 (single unit pack)
- Maximum: 999,999 (reasonable upper limit)
- Common values:
  - Tablets: 100, 500, 1000 tabs/box
  - Capsules: 100, 500 caps/box
  - Injections: 1, 10, 50 amps/box
  - Syrups: 1 bottle/box

#### Unit Price Rules

- Minimum: 0.0001 baht (smallest unit: 1 สตางค์)
- Maximum: 9,999,999.9999 baht
- Decimal places: 4 (for accurate calculations)
- Must be > 0 if selling to patients
- Examples:
  - Generic paracetamol: 0.50 baht/tab
  - Expensive biologics: 50,000 baht/vial

#### Barcode Formats

Acceptable formats:
- **EAN-13**: 13 digits (most common, e.g., `8851234567890`)
- **EAN-8**: 8 digits (compact products)
- **UPC**: 12 digits (US products)

Validation:
- Must contain only digits
- Must match checksum digit (optional validation)

#### ATC Code Format

- Format: `A00AA00` (7 characters)
- Example: `N02BE01` (Paracetamol)
- Structure:
  - 1st level (1 char): Anatomical main group (A-V)
  - 2nd level (2 digits): Therapeutic subgroup
  - 3rd level (1 char): Pharmacological subgroup
  - 4th level (1 char): Chemical subgroup
  - 5th level (2 digits): Chemical substance

#### Business Rules

1. **Uniqueness**:
   - `drugCode` must be unique
   - `standardCode` should be unique if provided
   - `barcode` can be duplicated (same barcode, different pack sizes)

2. **Required Relationships**:
   - `genericId` strongly recommended (for reporting and budget planning)
   - `manufacturerId` required for ministry compliance

3. **Ministry Compliance** ⭐:
   - For DRUGLIST export, required fields:
     - `drugCode` (or standardCode)
     - `tradeName`
     - `manufacturerId`
     - `nlemStatus`
     - `drugStatus`
     - `productCategory`
     - `statusChangedDate`

4. **Pricing**:
   - `unitPrice` can be null (to be determined later)
   - Price updated via purchase orders and contracts

5. **Deletion Rules**:
   - Cannot hard delete drugs
   - Cannot deactivate drugs with inventory > 0
   - Cannot deactivate drugs with active contracts
   - Should set `drugStatus = REMOVED` instead of deleting

6. **Status Change Rules**:
   - ACTIVE → DISCONTINUED: Must provide reason (min 10 chars)
   - Must update `statusChangedDate` automatically
   - PHARMACIST or ADMIN role required

7. **Immutable Fields** (cannot change after creation):
   - `drugCode`
   - `standardCode` (if set)

#### Example Valid Data

```json
{
  "drugCode": "SARA500",
  "tradeName": "Sara 500mg",
  "genericId": 1,
  "manufacturerId": 1,
  "strength": "500 mg",
  "dosageForm": "TAB",
  "packSize": 1000,
  "unitPrice": 2.50,
  "unit": "TAB",
  "standardCode": "10123456789012345678SARA",
  "barcode": "8851234567890",
  "atcCode": "N02BE01",
  "nlemStatus": "E",
  "drugStatus": "ACTIVE",
  "productCategory": "MODERN_REGISTERED",
  "statusChangedDate": "2025-01-01T00:00:00Z",
  "isActive": true
}
```

---

## Budget-Related Constraints

### BudgetTypeGroup Constraints

| Field | Required | Length/Range | Format | Unique | Notes |
|-------|----------|--------------|--------|--------|-------|
| **typeCode** | Yes | 3-10 chars | `^[A-Z0-9]+$` | Yes | Budget type code (e.g., OP001) |
| **typeName** | Yes | 1-100 chars | Thai | No | ชื่อประเภทงบ |
| **typeGroup** | Yes | Enum | OPERATIONAL, INVESTMENT, EMERGENCY | No | กลุ่มงบ |

**Common Type Codes**:
- `OP001` - งบดำเนินงาน - ยา (Operational - Drugs)
- `OP002` - งบดำเนินงาน - เวชภัณฑ์ (Operational - Medical Supplies)
- `OP003` - งบดำเนินงาน - วัสดุสิ้นเปลือง (Operational - Consumables)
- `INV001` - งบลงทุน - เครื่องมือแพทย์ (Investment - Medical Equipment)
- `INV002` - งบลงทุน - ระบบ IT (Investment - IT Systems)
- `EM001` - งบฉุกเฉิน (Emergency Fund)

### BudgetCategory Constraints

| Field | Required | Length/Range | Format | Unique | Notes |
|-------|----------|--------------|--------|--------|-------|
| **categoryCode** | Yes | 3-10 chars | `^[A-Z0-9]+$` | Yes | Category code |
| **categoryName** | Yes | 1-100 chars | Thai | No | ชื่อหมวดงบ |

**Common Category Codes**:
- `CAT01` - ค่ายา (Drugs)
- `CAT02` - ค่าเวชภัณฑ์ (Medical Supplies)
- `CAT03` - ค่าครุภัณฑ์ (Equipment)
- `CAT04` - ค่าบำรุงรักษา (Maintenance)

### Budget Constraints

| Field | Required | Length/Range | Format | Unique | Notes |
|-------|----------|--------------|--------|--------|-------|
| **budgetCode** | Yes | 3-20 chars | `^[A-Z0-9-]+$` | Yes | Combined budget code |
| **budgetType** | Yes | - | FK to BudgetTypeGroup | No | ประเภทงบ |
| **budgetCategory** | Yes | - | FK to BudgetCategory | No | หมวดงบ |

**Business Rules**:
- Budget = Type + Category combination
- Example: `OP001-CAT01` = Operational Drugs budget
- Cannot delete budget type/category if used in allocations

---

## Contract Constraints

### Table: `contracts`

#### Field Constraints

| Field | Data Type | Required | Length/Range | Format | Unique | Notes |
|-------|-----------|----------|--------------|--------|--------|-------|
| **contractNumber** | String | Yes | 5-50 chars | `^[A-Z0-9/-]+$` | Yes | เลขที่สัญญา |
| **contractType** | Enum | Yes | - | See enum | No | ประเภทสัญญา |
| **vendorId** | BigInt | Yes | - | FK to companies | No | บริษัทผู้ขาย |
| **startDate** | Date | Yes | - | ISO 8601 date | No | วันที่เริ่มสัญญา |
| **endDate** | Date | Yes | - | ISO 8601 date | No | วันที่สิ้นสุดสัญญา |
| **totalValue** | Decimal | Yes | 0.01-999,999,999.99 | Decimal(12,2) | No | มูลค่าสัญญา (บาท) |
| **remainingValue** | Decimal | Yes | 0-999,999,999.99 | Auto-calculated | No | มูลค่าคงเหลือ |
| **fiscalYear** | String | Yes | 4 chars | `^\d{4}$` | No | ปีงบประมาณ พ.ศ. |
| **status** | Enum | Yes | - | See enum | No | สถานะสัญญา |

#### Contract Type Values

| Value | Thai Name | Description |
|-------|-----------|-------------|
| **CENTRAL_PURCHASE** | จัดซื้อกลาง | Central government procurement |
| **SMALL_PURCHASE** | จัดซื้อเล็กน้อย | Small value procurement (<100k) |
| **ANNUAL_CONTRACT** | สัญญาประจำปี | Annual contract |
| **EMERGENCY_PURCHASE** | จัดซื้อฉุกเฉิน | Emergency procurement |

#### Contract Status Values

| Value | Thai Name | Description |
|-------|-----------|-------------|
| **DRAFT** | ร่าง | Draft, not active yet |
| **ACTIVE** | ใช้งาน | Active, can create POs |
| **EXPIRED** | หมดอายุ | Expired by date |
| **CLOSED** | ปิดสัญญา | Manually closed |
| **CANCELLED** | ยกเลิก | Cancelled |

#### Business Rules

1. **Date Validation**:
   - `startDate` must be < `endDate`
   - Cannot create contract with `endDate` in the past
   - Recommended: `endDate` - `startDate` <= 1 year for annual contracts

2. **Value Rules**:
   - `totalValue` must be > 0
   - `remainingValue` = `totalValue` initially
   - `remainingValue` decreases when POs created
   - Cannot create PO if `remainingValue` < PO amount

3. **Contract Number Format**:
   - Recommended: `CNT-{YEAR}-{NUMBER}`
   - Example: `CNT-2568-001`, `CNT-2025-042`
   - Can include fiscal year or calendar year

4. **Status Transitions**:
   ```
   DRAFT → ACTIVE → EXPIRED
   DRAFT → ACTIVE → CLOSED
   DRAFT → CANCELLED
   ```

5. **Deletion Rules**:
   - Cannot delete contract with purchase orders
   - Cannot delete ACTIVE contracts
   - Can delete DRAFT or CANCELLED contracts only

#### Example Valid Data

```json
{
  "contractNumber": "CNT-2568-001",
  "contractType": "ANNUAL_CONTRACT",
  "vendorId": 1,
  "startDate": "2025-01-01",
  "endDate": "2025-12-31",
  "totalValue": 1000000.00,
  "remainingValue": 1000000.00,
  "fiscalYear": "2568",
  "status": "ACTIVE"
}
```

### ContractItem Constraints

| Field | Required | Range | Notes |
|-------|----------|-------|-------|
| **contractId** | Yes | FK to contracts | สัญญา |
| **drugId** | Yes | FK to drugs | ยา |
| **unitPrice** | Yes | 0.0001-9,999,999.9999 | ราคาต่อหน่วย |
| **quantityContracted** | Yes | 1-999,999,999 | จำนวนตามสัญญา |
| **quantityRemaining** | Yes | 0-999,999,999 | จำนวนคงเหลือ |

**Business Rules**:
- Same drug can appear in multiple contracts (different vendors/prices)
- `quantityRemaining` ≤ `quantityContracted`
- `unitPrice` can differ from drug.unitPrice (contract price)

---

## Cross-Entity Business Rules

### 1. Location-Inventory Rules

- Cannot delete location with `inventory.quantityOnHand > 0`
- Cannot deactivate location with active drug lots
- Must transfer inventory before location deactivation

### 2. Company-Drug Rules

- Cannot delete company if set as manufacturer for any active drug
- Cannot delete company with active purchase orders
- Can change manufacturer only if drug has no inventory

### 3. Generic-Drug Rules

- Cannot delete generic if linked to any drug (active or inactive)
- Changing generic requires pharmacist approval
- Must maintain at least 1 trade drug per active generic

### 4. Drug-Inventory Rules

- Cannot delete drug with `inventory.quantityOnHand > 0`
- Cannot change `drugCode` if drug has inventory
- Cannot change `unit` if drug has inventory

### 5. Department-Budget Rules

- Cannot delete department with active budget allocations
- Cannot delete department with budget spent > 0
- Can deactivate department only at fiscal year end

### 6. Contract-Drug Rules

- Contract can only include drugs from specified vendor's catalog
- Unit price in contract overrides drug.unitPrice
- Contract items locked after first PO created

---

## Ministry Compliance Constraints

### Required Fields for Ministry Exports

#### DRUGLIST Export (รายการยา)
Required fields per drug:
- ✅ `drugCode` or `standardCode` (24-digit)
- ✅ `tradeName`
- ✅ `genericId` → `generic.genericName`
- ✅ `manufacturerId` → `manufacturer.companyName`
- ✅ `nlemStatus` (E/N)
- ✅ `drugStatus` (1-4)
- ✅ `productCategory` (1-5)
- ✅ `statusChangedDate`
- ✅ `strength`
- ✅ `dosageForm`
- ✅ `unit`

#### DISTRIBUTION Export (จ่ายยา)
Required fields:
- ✅ `departmentId` → `department.consumptionGroup` (1-9)
- ✅ Drug information (from DRUGLIST)
- ✅ Quantity distributed
- ✅ Distribution date

#### RECEIPT Export (รับยา)
Required fields:
- ✅ Purchase order reference
- ✅ Receipt date
- ✅ Vendor information
- ✅ Drug information
- ✅ Quantity received
- ✅ Unit price
- ✅ Lot number
- ✅ Expiry date

### Data Quality Requirements

1. **Completeness**:
   - All ministry-required fields must have values (not null)
   - Cannot export records with missing compliance fields

2. **Accuracy**:
   - `nlemStatus` must match official NLEM list
   - `drugStatus` must reflect actual usage status
   - `consumptionGroup` must represent actual department usage pattern

3. **Timeliness**:
   - `statusChangedDate` must be updated when `drugStatus` changes
   - Export data must be current (not > 1 month old)

---

## Data Quality Rules

### 1. Character Encoding

- **Database**: UTF-8 (supports Thai and English)
- **Thai Text**: Must be valid UTF-8 Thai characters (ก-ฮ, เ-ไ, ฯ, ๆ, etc.)
- **English Text**: ASCII printable characters
- **No Special Characters** in codes: Only A-Z, 0-9, hyphen (-)

### 2. Text Formatting

- **Trim**: All text fields trimmed (no leading/trailing spaces)
- **No Multiple Spaces**: Collapse multiple spaces to single space
- **Capitalization**:
  - Codes: UPPERCASE (locationCode, drugCode, companyCode)
  - Names: Proper Case (Drug names, Company names)

### 3. Number Formatting

- **Integers**: No leading zeros (except single 0)
- **Decimals**: Use period (.) as decimal separator (not comma)
- **Currency**: 2 decimal places for baht (display), 4 for calculations
- **Negative Numbers**: Use minus sign (-), not parentheses

### 4. Date/Time Formatting

- **Storage**: ISO 8601 format (YYYY-MM-DD HH:MM:SS)
- **Display**: Thai Buddhist year for Thai users (พ.ศ. 2568)
- **Timezone**: ICT (UTC+7) for Thailand
- **Date Only**: YYYY-MM-DD (no time component)

### 5. Null vs Empty String

- **Null**: Use for optional fields with no value
- **Empty String**: Avoid, use null instead
- **Zero**: Distinct from null (0 means "zero quantity", null means "unknown")

### 6. Boolean Values

- **Storage**: true/false (boolean type)
- **Display**: Yes/No, Active/Inactive (Thai: ใช้งาน/ไม่ใช้งาน)
- **Default**: Specify default value (usually true for isActive)

---

## Validation Error Messages

### Standard Error Format

```json
{
  "field": "drugCode",
  "code": "INVALID_FORMAT",
  "message": "Drug code must be 7-24 uppercase letters or numbers",
  "value": "abc123",
  "constraint": "^[A-Z0-9]{7,24}$"
}
```

### Common Validation Errors

| Code | Thai Message | English Message |
|------|--------------|-----------------|
| **REQUIRED** | จำเป็นต้องระบุ{field} | {field} is required |
| **TOO_SHORT** | {field} ต้องมีอย่างน้อย {min} ตัวอักษร | {field} must be at least {min} characters |
| **TOO_LONG** | {field} ต้องไม่เกิน {max} ตัวอักษร | {field} must not exceed {max} characters |
| **INVALID_FORMAT** | รูปแบบ{field}ไม่ถูกต้อง | Invalid {field} format |
| **DUPLICATE** | {field} ซ้ำกับข้อมูลที่มีอยู่ | Duplicate {field} |
| **NOT_FOUND** | ไม่พบข้อมูล{entity} | {entity} not found |
| **INVALID_REFERENCE** | {field} อ้างอิงข้อมูลที่ไม่มีอยู่ | {field} references non-existent record |
| **OUT_OF_RANGE** | {field} ต้องอยู่ในช่วง {min}-{max} | {field} must be between {min} and {max} |
| **BUSINESS_RULE** | {รายละเอียดกฎธุรกิจ} | {business rule details} |

---

## Summary Checklist

### For System Analysts

Before approving data design, verify:

- [ ] All field lengths defined and reasonable
- [ ] All unique constraints identified
- [ ] All foreign key relationships documented
- [ ] All enum values listed with descriptions
- [ ] All business rules documented
- [ ] All deletion/cascade rules defined
- [ ] All ministry compliance fields identified
- [ ] All data quality rules specified
- [ ] All validation error messages defined
- [ ] All cross-entity constraints documented

### For Developers

Before implementing, ensure:

- [ ] Database schema matches constraints
- [ ] Validation implemented for all constraints
- [ ] Error messages implemented (Thai + English)
- [ ] Business rules enforced in code
- [ ] Referential integrity enforced
- [ ] Ministry compliance fields required
- [ ] Test cases cover all constraints
- [ ] Documentation updated with any changes

---

**Version**: 1.0.0
**Last Updated**: 2025-01-21
**Status**: Ready for Review
**Next Review**: Before implementation

---

**Related Documents**:
- [01-SCHEMA.md](./01-SCHEMA.md) - Database schema details
- [03-VALIDATION-RULES.md](./03-VALIDATION-RULES.md) - Validation logic
- [04-AUTHORIZATION.md](./04-AUTHORIZATION.md) - Access control rules
- [API_SPECIFICATION.md](../api/API_SPECIFICATION.md) - API field formats
