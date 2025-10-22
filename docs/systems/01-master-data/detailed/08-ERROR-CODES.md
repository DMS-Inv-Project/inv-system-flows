# Error Codes - Master Data Management

**Module**: 01-master-data
**System**: INVS Modern - Hospital Inventory Management System
**Version**: 2.2.0
**Last Updated**: 2025-01-22
**Purpose**: Standard error codes, messages, and handling strategies for Master Data module

---

## 📖 Table of Contents

1. [Overview](#overview)
2. [Error Code Structure](#error-code-structure)
3. [HTTP Status Code Mapping](#http-status-code-mapping)
4. [Common Errors](#common-errors)
5. [Entity-Specific Errors](#entity-specific-errors)
6. [Validation Errors](#validation-errors)
7. [Business Logic Errors](#business-logic-errors)
8. [Error Response Format](#error-response-format)
9. [Error Handling Examples](#error-handling-examples)

---

## Overview

This document defines standardized error codes for the Master Data Management module. Consistent error codes enable:

- **Clear Communication**: Developers and users understand what went wrong
- **Internationalization**: Support for Thai and English messages
- **Debugging**: Quick identification of error sources
- **Monitoring**: Track error frequency and patterns
- **Client Handling**: Frontend can handle specific errors appropriately

**Error Severity Levels**:
- 🔴 **CRITICAL**: System-breaking errors requiring immediate attention
- 🟡 **ERROR**: Operation failed, user action needed
- 🟠 **WARNING**: Operation succeeded with warnings
- 🔵 **INFO**: Informational messages

---

## Error Code Structure

### Format: `{MODULE}-{ENTITY}-{CATEGORY}{NUMBER}`

**Components**:
- `MODULE`: `MD` = Master Data
- `ENTITY`: 3-letter entity code
- `CATEGORY`: Error category (1 letter)
- `NUMBER`: Sequential number (01-99)

**Entity Codes**:
| Code | Entity | Example |
|------|--------|---------|
| `LOC` | locations | MD-LOC-V01 |
| `DEP` | departments | MD-DEP-V01 |
| `BTY` | budget_types | MD-BTY-V01 |
| `BCA` | budget_categories | MD-BCA-V01 |
| `BUD` | budgets | MD-BUD-V01 |
| `BNK` | bank | MD-BNK-V01 |
| `COM` | companies | MD-COM-V01 |
| `GEN` | drug_generics | MD-GEN-V01 |
| `DRG` | drugs | MD-DRG-V01 |
| `CON` | contracts | MD-CON-V01 |
| `CIT` | contract_items | MD-CIT-V01 |

**Category Codes**:
| Code | Category | Description |
|------|----------|-------------|
| `V` | Validation | Input validation errors |
| `B` | Business Logic | Business rule violations |
| `D` | Database | Database operation errors |
| `A` | Authorization | Permission errors |
| `N` | Not Found | Resource not found |
| `C` | Conflict | Data conflict errors |
| `S` | System | Internal system errors |

**Examples**:
- `MD-LOC-V01`: Location validation error #01
- `MD-DRG-B05`: Drug business logic error #05
- `MD-CON-N01`: Contract not found error #01
- `MD-COM-D03`: Company database error #03

---

## HTTP Status Code Mapping

| HTTP Status | Category | Usage |
|-------------|----------|-------|
| **200** | Success | Operation completed successfully |
| **201** | Created | Resource created successfully |
| **400** | Bad Request | Validation errors, invalid input |
| **401** | Unauthorized | Authentication required |
| **403** | Forbidden | Insufficient permissions |
| **404** | Not Found | Resource doesn't exist |
| **409** | Conflict | Duplicate key, constraint violation |
| **422** | Unprocessable Entity | Business logic violation |
| **500** | Internal Server Error | Unexpected system error |
| **503** | Service Unavailable | Database connection failed |

---

## Common Errors

### General Errors (MD-GEN)

#### MD-GEN-V01: Missing Required Field
**HTTP Status**: 400
**Message (EN)**: Required field '{field_name}' is missing
**Message (TH)**: ฟิลด์ '{field_name}' จำเป็นต้องกรอก
**Example**:
```json
{
  "code": "MD-GEN-V01",
  "message": "Required field 'location_code' is missing",
  "field": "location_code"
}
```

#### MD-GEN-V02: Invalid Field Format
**HTTP Status**: 400
**Message (EN)**: Field '{field_name}' has invalid format
**Message (TH)**: ฟิลด์ '{field_name}' รูปแบบไม่ถูกต้อง
**Details**: Include expected format in error response

#### MD-GEN-V03: Field Length Exceeded
**HTTP Status**: 400
**Message (EN)**: Field '{field_name}' exceeds maximum length of {max_length}
**Message (TH)**: ฟิลด์ '{field_name}' เกินความยาวสูงสุด {max_length} ตัวอักษร

#### MD-GEN-V04: Invalid Field Value
**HTTP Status**: 400
**Message (EN)**: Field '{field_name}' has invalid value '{value}'
**Message (TH)**: ฟิลด์ '{field_name}' มีค่าไม่ถูกต้อง '{value}'

#### MD-GEN-N01: Resource Not Found
**HTTP Status**: 404
**Message (EN)**: {entity} with {field}='{value}' not found
**Message (TH)**: ไม่พบข้อมูล {entity} ที่มี {field}='{value}'
**Example**:
```json
{
  "code": "MD-GEN-N01",
  "message": "Location with id='999' not found",
  "entity": "Location",
  "field": "id",
  "value": "999"
}
```

#### MD-GEN-C01: Duplicate Key Violation
**HTTP Status**: 409
**Message (EN)**: {entity} with {field}='{value}' already exists
**Message (TH)**: {entity} ที่มี {field}='{value}' มีอยู่แล้วในระบบ
**Example**:
```json
{
  "code": "MD-GEN-C01",
  "message": "Location with location_code='WH001' already exists",
  "entity": "Location",
  "field": "location_code",
  "value": "WH001"
}
```

#### MD-GEN-D01: Database Connection Failed
**HTTP Status**: 503
**Message (EN)**: Unable to connect to database
**Message (TH)**: ไม่สามารถเชื่อมต่อฐานข้อมูลได้
**Severity**: 🔴 CRITICAL

#### MD-GEN-D02: Database Query Failed
**HTTP Status**: 500
**Message (EN)**: Database query failed: {error_message}
**Message (TH)**: การ query ฐานข้อมูลล้มเหลว: {error_message}
**Severity**: 🔴 CRITICAL

#### MD-GEN-A01: Insufficient Permissions
**HTTP Status**: 403
**Message (EN)**: You don't have permission to {action} {entity}
**Message (TH)**: คุณไม่มีสิทธิ์ {action} {entity}

#### MD-GEN-S01: Internal Server Error
**HTTP Status**: 500
**Message (EN)**: An unexpected error occurred
**Message (TH)**: เกิดข้อผิดพลาดที่ไม่คาดคิด
**Severity**: 🔴 CRITICAL
**Note**: Log full error details, show generic message to user

---

## Entity-Specific Errors

### 1. Locations (MD-LOC)

#### MD-LOC-V01: Invalid Location Code Format
**HTTP Status**: 400
**Message (EN)**: Location code must be 3-20 uppercase alphanumeric characters
**Message (TH)**: รหัสสถานที่ต้องเป็นตัวอักษรและตัวเลขพิมพ์ใหญ่ 3-20 ตัว
**Pattern**: `^[A-Z0-9-]{3,20}$`
**Examples**: Valid: `WH001`, `PHARM-OPD`, Invalid: `wh001`, `W1`

#### MD-LOC-V02: Invalid Location Type
**HTTP Status**: 400
**Message (EN)**: Location type must be one of: WAREHOUSE, PHARMACY, WARD, EMERGENCY, OPERATING_ROOM
**Message (TH)**: ประเภทสถานที่ไม่ถูกต้อง
**Valid Values**: `WAREHOUSE`, `PHARMACY`, `WARD`, `EMERGENCY`, `OPERATING_ROOM`

#### MD-LOC-B01: Minimum Warehouse Requirement
**HTTP Status**: 422
**Message (EN)**: Cannot delete/deactivate the last active warehouse
**Message (TH)**: ไม่สามารถลบ/ปิดการใช้งานคลังสุดท้ายได้
**Severity**: 🔴 CRITICAL
**Business Rule**: BR-LOC-001

#### MD-LOC-B02: Minimum Pharmacy Requirement
**HTTP Status**: 422
**Message (EN)**: Cannot delete/deactivate the last active pharmacy
**Message (TH)**: ไม่สามารถลบ/ปิดการใช้งานห้องยาสุดท้ายได้
**Severity**: 🔴 CRITICAL
**Business Rule**: BR-LOC-002

#### MD-LOC-B03: Location Has Inventory
**HTTP Status**: 422
**Message (EN)**: Cannot delete location with inventory (quantity: {quantity})
**Message (TH)**: ไม่สามารถลบสถานที่ที่มียาคงเหลือ (จำนวน: {quantity})
**Severity**: 🟡 ERROR
**Business Rule**: BR-LOC-004
**Action**: Move inventory to another location first

#### MD-LOC-B04: Location Has Children
**HTTP Status**: 422
**Message (EN)**: Cannot delete location with child locations (count: {count})
**Message (TH)**: ไม่สามารถลบสถานที่ที่มีสถานที่ย่อย (จำนวน: {count})
**Severity**: 🟡 ERROR
**Business Rule**: BR-LOC-005

#### MD-LOC-B05: Self-Reference Not Allowed
**HTTP Status**: 422
**Message (EN)**: Location cannot be its own parent
**Message (TH)**: สถานที่ไม่สามารถเป็น parent ของตัวเองได้
**Business Rule**: BR-LOC-006

#### MD-LOC-B06: Circular Hierarchy Detected
**HTTP Status**: 422
**Message (EN)**: Circular hierarchy detected: {path}
**Message (TH)**: พบความสัมพันธ์แบบวงกลม: {path}
**Example**: `WH001 → PHARM01 → WARD2A → WH001`
**Business Rule**: BR-LOC-007

---

### 2. Departments (MD-DEP)

#### MD-DEP-V01: Invalid Department Code Format
**HTTP Status**: 400
**Message (EN)**: Department code must be 2-10 uppercase alphanumeric characters
**Message (TH)**: รหัสแผนกต้องเป็นตัวอักษรและตัวเลขพิมพ์ใหญ่ 2-10 ตัว
**Pattern**: `^[A-Z0-9-]{2,10}$`

#### MD-DEP-V02: Invalid Consumption Group
**HTTP Status**: 400
**Message (EN)**: Consumption group must be one of: OPD_MAINLY, IPD_MAINLY, OPD_IPD_MIX, etc.
**Message (TH)**: กลุ่มการใช้ยาไม่ถูกต้อง

#### MD-DEP-B01: Self-Reference Not Allowed
**HTTP Status**: 422
**Message (EN)**: Department cannot be its own parent
**Message (TH)**: แผนกไม่สามารถเป็น parent ของตัวเองได้

#### MD-DEP-B02: Missing Consumption Group
**HTTP Status**: 422
**Message (EN)**: Drug-consuming departments must have consumption_group set
**Message (TH)**: แผนกที่ใช้ยาต้องระบุกลุ่มการใช้ยา
**Severity**: 🟠 WARNING
**Business Rule**: BR-DEPT-004
**Note**: Required for ministry DISTRIBUTION export

---

### 3. Budget Types (MD-BTY)

#### MD-BTY-V01: Invalid Type Code Format
**HTTP Status**: 400
**Message (EN)**: Type code must match pattern: OP###, INV###, or EM###
**Message (TH)**: รหัสประเภทงบไม่ตรงตามรูปแบบ
**Pattern**: `^(OP|INV|EM)\d{3}$`

#### MD-BTY-B01: Cannot Delete Type With Budgets
**HTTP Status**: 422
**Message (EN)**: Cannot delete budget type with {count} active budgets
**Message (TH)**: ไม่สามารถลบประเภทงบที่มีงบประมาณใช้งานอยู่ {count} รายการ
**Business Rule**: BR-BTYPE-003

---

### 4. Budget Categories (MD-BCA)

#### MD-BCA-V01: Invalid Category Code Format
**HTTP Status**: 400
**Message (EN)**: Category code must be alphanumeric (3-10 characters)
**Message (TH)**: รหัสหมวดงบไม่ถูกต้อง

#### MD-BCA-V02: Invalid Accounting Code Format
**HTTP Status**: 400
**Message (EN)**: Accounting code must match pattern: ####-###
**Message (TH)**: รหัสผังบัญชีไม่ถูกต้อง
**Pattern**: `^\d{4}-\d{3}$`

#### MD-BCA-B01: Cannot Delete Category With Budgets
**HTTP Status**: 422
**Message (EN)**: Cannot delete budget category with {count} active budgets
**Message (TH)**: ไม่สามารถลบหมวดงบที่มีงบประมาณใช้งานอยู่ {count} รายการ

---

### 5. Budgets (MD-BUD)

#### MD-BUD-V01: Invalid Budget Code Format
**HTTP Status**: 400
**Message (EN)**: Budget code must follow pattern: {TYPE_CODE}-{CATEGORY_CODE}
**Message (TH)**: รหัสงบประมาณไม่ถูกต้อง
**Example**: `OP001-CAT01`

#### MD-BUD-B01: Duplicate Budget Combination
**HTTP Status**: 409
**Message (EN)**: Budget with type '{type}' and category '{category}' already exists
**Message (TH)**: งบประมาณประเภท '{type}' หมวด '{category}' มีอยู่แล้ว
**Business Rule**: BR-BUD-001

#### MD-BUD-B02: Cannot Delete Budget With Allocations
**HTTP Status**: 422
**Message (EN)**: Cannot delete budget with {count} allocations
**Message (TH)**: ไม่สามารถลบงบประมาณที่มีการจัดสรร {count} รายการ
**Business Rule**: BR-BUD-004

---

### 6. Bank (MD-BNK)

#### MD-BNK-V01: Invalid Bank Name
**HTTP Status**: 400
**Message (EN)**: Bank name cannot be empty
**Message (TH)**: ชื่อธนาคารต้องไม่ว่าง

#### MD-BNK-B01: Cannot Delete Bank With References
**HTTP Status**: 422
**Message (EN)**: Cannot delete bank referenced by {count} companies
**Message (TH)**: ไม่สามารถลบธนาคารที่มีบริษัทอ้างอิง {count} รายการ
**Business Rule**: BR-BANK-003

---

### 7. Companies (MD-COM)

#### MD-COM-V01: Invalid Company Code Format
**HTTP Status**: 400
**Message (EN)**: Company code must be uppercase alphanumeric (3-10 characters)
**Message (TH)**: รหัสบริษัทไม่ถูกต้อง

#### MD-COM-V02: Invalid Tax ID Format
**HTTP Status**: 400
**Message (EN)**: Tax ID must be exactly 13 digits
**Message (TH)**: เลขผู้เสียภาษีต้องเป็นตัวเลข 13 หลัก
**Pattern**: `^\d{13}$`
**Business Rule**: BR-COMP-002

#### MD-COM-V03: Invalid Tax ID Checksum
**HTTP Status**: 400
**Message (EN)**: Tax ID checksum validation failed
**Message (TH)**: เลขผู้เสียภาษีตรวจสอบความถูกต้องไม่ผ่าน
**Severity**: 🟠 WARNING
**Business Rule**: BR-COMP-003

#### MD-COM-V04: Invalid Email Format
**HTTP Status**: 400
**Message (EN)**: Email format is invalid
**Message (TH)**: รูปแบบอีเมลไม่ถูกต้อง

#### MD-COM-V05: Invalid Phone Format
**HTTP Status**: 400
**Message (EN)**: Phone number format is invalid
**Message (TH)**: รูปแบบเบอร์โทรศัพท์ไม่ถูกต้อง
**Expected**: `02-123-4567`, `0812345678`, `+66-2-123-4567`

#### MD-COM-V06: Bank Account Without Bank
**HTTP Status**: 400
**Message (EN)**: Bank account number requires bank_id to be set
**Message (TH)**: หมายเลขบัญชีต้องระบุธนาคารด้วย
**Business Rule**: BR-COMP-005

#### MD-COM-V07: Invalid Company Type
**HTTP Status**: 400
**Message (EN)**: Company type must be: VENDOR, MANUFACTURER, or BOTH
**Message (TH)**: ประเภทบริษัทไม่ถูกต้อง

#### MD-COM-B01: Cannot Delete With Active Contracts
**HTTP Status**: 422
**Message (EN)**: Cannot delete company with {count} active contracts
**Message (TH)**: ไม่สามารถลบบริษัทที่มีสัญญาใช้งานอยู่ {count} รายการ
**Business Rule**: BR-COMP-008

#### MD-COM-B02: Cannot Delete With Active POs
**HTTP Status**: 422
**Message (EN)**: Cannot delete company with {count} open purchase orders
**Message (TH)**: ไม่สามารถลบบริษัทที่มีใบสั่งซื้อเปิดอยู่ {count} รายการ
**Business Rule**: BR-COMP-009

#### MD-COM-B03: Cannot Delete Manufacturer With Drugs
**HTTP Status**: 422
**Message (EN)**: Cannot delete manufacturer linked to {count} drugs
**Message (TH)**: ไม่สามารถลบผู้ผลิตที่เชื่อมโยงกับยา {count} รายการ
**Business Rule**: BR-COMP-010

---

### 8. Drug Generics (MD-GEN)

#### MD-GEN-V01: Invalid Working Code Format
**HTTP Status**: 400
**Message (EN)**: Working code must follow pattern: XXX####
**Message (TH)**: รหัสทำงานไม่ถูกต้อง
**Pattern**: `^[A-Z]{3}\d{4}$`
**Example**: `PAR0001`, `IBU0001`
**Business Rule**: BR-GEN-002

#### MD-GEN-V02: Strength Without Unit
**HTTP Status**: 400
**Message (EN)**: Strength requires strength_unit to be set
**Message (TH)**: ความแรงยาต้องระบุหน่วยด้วย
**Business Rule**: BR-GEN-003

#### MD-GEN-B01: Cannot Delete With Trade Drugs
**HTTP Status**: 422
**Message (EN)**: Cannot delete generic linked to {count} trade drugs
**Message (TH)**: ไม่สามารถลบยาสามัญที่เชื่อมโยงกับยาการค้า {count} รายการ
**Business Rule**: BR-GEN-004

---

### 9. Drugs (MD-DRG)

#### MD-DRG-V01: Invalid Drug Code Format
**HTTP Status**: 400
**Message (EN)**: Drug code must be 7-24 characters
**Message (TH)**: รหัสยาต้องมีความยาว 7-24 ตัวอักษร
**Business Rule**: BR-DRUG-001

#### MD-DRG-V02: Invalid Standard Code Length ⭐
**HTTP Status**: 400
**Message (EN)**: Standard code must be exactly 24 characters
**Message (TH)**: รหัสมาตรฐานต้องมี 24 ตัวอักษร
**Business Rule**: BR-DRUG-002

#### MD-DRG-V03: Invalid Pack Size
**HTTP Status**: 400
**Message (EN)**: Pack size must be greater than 0
**Message (TH)**: ขนาดบรรจุต้องมากกว่า 0
**Business Rule**: BR-DRUG-003

#### MD-DRG-V04: Invalid Unit Price
**HTTP Status**: 400
**Message (EN)**: Unit price must be ≥ 0
**Message (TH)**: ราคาต่อหน่วยต้อง ≥ 0
**Business Rule**: BR-DRUG-004

#### MD-DRG-V05: Invalid NLEM Status ⭐
**HTTP Status**: 400
**Message (EN)**: NLEM status must be 'E' (Essential) or 'N' (Non-Essential)
**Message (TH)**: สถานะบัญชียาหลักต้องเป็น 'E' หรือ 'N'
**Business Rule**: BR-DRUG-007

#### MD-DRG-V06: Invalid Drug Status ⭐
**HTTP Status**: 400
**Message (EN)**: Drug status must be: ACTIVE, SUSPENDED, REMOVED, or INVESTIGATIONAL
**Message (TH)**: สถานะยาไม่ถูกต้อง
**Business Rule**: BR-DRUG-008

#### MD-DRG-V07: Invalid Product Category ⭐
**HTTP Status**: 400
**Message (EN)**: Product category must be 1-5
**Message (TH)**: ประเภทผลิตภัณฑ์ไม่ถูกต้อง
**Business Rule**: BR-DRUG-010

#### MD-DRG-B01: Missing Generic Reference
**HTTP Status**: 422
**Message (EN)**: Trade drug should link to a generic (generic_id)
**Message (TH)**: ยาการค้าควรเชื่อมโยงกับยาสามัญ
**Severity**: 🟠 WARNING
**Business Rule**: BR-DRUG-005

#### MD-DRG-B02: Missing Manufacturer for Ministry ⭐
**HTTP Status**: 422
**Message (EN)**: Manufacturer required for ministry DRUGLIST export
**Message (TH)**: ต้องระบุผู้ผลิตสำหรับส่งออกรายงานกระทรวง
**Severity**: 🟡 ERROR
**Business Rule**: BR-DRUG-006

#### MD-DRG-B03: Status Change Date Required ⭐
**HTTP Status**: 422
**Message (EN)**: Status change date required when drug_status changes
**Message (TH)**: ต้องระบุวันที่เปลี่ยนสถานะเมื่อสถานะยาเปลี่ยนแปลง
**Business Rule**: BR-DRUG-009

#### MD-DRG-B04: Cannot Delete With Inventory
**HTTP Status**: 422
**Message (EN)**: Cannot delete drug with inventory (quantity: {quantity})
**Message (TH)**: ไม่สามารถลบยาที่มียาคงเหลือ (จำนวน: {quantity})
**Action**: Set drug_status = REMOVED instead
**Business Rule**: BR-DRUG-011

#### MD-DRG-B05: Cannot Delete With Active Contracts
**HTTP Status**: 422
**Message (EN)**: Cannot delete drug in {count} active contract items
**Message (TH)**: ไม่สามารถลบยาที่อยู่ในสัญญา {count} รายการ
**Business Rule**: BR-DRUG-012

---

### 10. Contracts (MD-CON)

#### MD-CON-V01: Invalid Contract Number Format
**HTTP Status**: 400
**Message (EN)**: Contract number must follow pattern: CNT-YYYY-###
**Message (TH)**: เลขที่สัญญาไม่ตรงตามรูปแบบ
**Pattern**: `^CNT-\d{4}-\d{3,}$`
**Business Rule**: BR-CONT-002

#### MD-CON-V02: Invalid Date Range
**HTTP Status**: 400
**Message (EN)**: Contract end date must be after start date
**Message (TH)**: วันที่สิ้นสุดสัญญาต้องหลังวันที่เริ่มสัญญา
**Business Rule**: BR-CONT-003

#### MD-CON-V03: Invalid Fiscal Year Format
**HTTP Status**: 400
**Message (EN)**: Fiscal year must be 4-digit Buddhist Era (2500-2600)
**Message (TH)**: ปีงบประมาณต้องเป็นพุทธศักราช 4 หลัก (2500-2600)
**Business Rule**: BR-CONT-007

#### MD-CON-B01: Inactive Vendor
**HTTP Status**: 422
**Message (EN)**: Cannot create contract with inactive vendor
**Message (TH)**: ไม่สามารถสร้างสัญญากับผู้ขายที่ไม่ active
**Business Rule**: BR-CONT-011

#### MD-CON-B02: Exceeds Remaining Value
**HTTP Status**: 422
**Message (EN)**: PO amount ({po_amount}) exceeds contract remaining value ({remaining})
**Message (TH)**: มูลค่า PO ({po_amount}) เกินมูลค่าคงเหลือของสัญญา ({remaining})
**Business Rule**: BR-CONT-006

#### MD-CON-B03: Cannot Delete With POs
**HTTP Status**: 422
**Message (EN)**: Cannot delete contract with {count} purchase orders
**Message (TH)**: ไม่สามารถลบสัญญาที่มีใบสั่งซื้อ {count} รายการ
**Business Rule**: BR-CONT-008

#### MD-CON-B04: Invalid Status Transition
**HTTP Status**: 422
**Message (EN)**: Cannot change status from {from} to {to}
**Message (TH)**: ไม่สามารถเปลี่ยนสถานะจาก {from} เป็น {to}
**Valid Transitions**: DRAFT→ACTIVE, ACTIVE→EXPIRED, DRAFT/ACTIVE→CANCELLED
**Business Rule**: BR-CONT-009

---

### 11. Contract Items (MD-CIT)

#### MD-CIT-V01: Quantity Limit Violation
**HTTP Status**: 400
**Message (EN)**: min_order_quantity must be ≤ max_order_quantity
**Message (TH)**: จำนวนขั้นต่ำต้องน้อยกว่าหรือเท่ากับจำนวนสูงสุด
**Business Rule**: BR-CITEM-006

#### MD-CIT-B01: Duplicate Drug in Contract
**HTTP Status**: 409
**Message (EN)**: Drug already exists in this contract
**Message (TH)**: ยานี้มีอยู่ในสัญญาแล้ว
**Business Rule**: BR-CITEM-001

#### MD-CIT-B02: Below Minimum Order Quantity
**HTTP Status**: 422
**Message (EN)**: PO quantity ({qty}) is below minimum order quantity ({min})
**Message (TH)**: จำนวนสั่งซื้อ ({qty}) ต่ำกว่าจำนวนขั้นต่ำ ({min})
**Severity**: 🟠 WARNING
**Business Rule**: BR-CITEM-007

#### MD-CIT-B03: Exceeds Maximum Order Quantity
**HTTP Status**: 422
**Message (EN)**: PO quantity ({qty}) exceeds maximum order quantity ({max})
**Message (TH)**: จำนวนสั่งซื้อ ({qty}) เกินจำนวนสูงสุด ({max})
**Severity**: 🟠 WARNING
**Business Rule**: BR-CITEM-007

#### MD-CIT-B04: Cannot Modify After PO Created
**HTTP Status**: 422
**Message (EN)**: Cannot modify contract item after purchase order created
**Message (TH)**: ไม่สามารถแก้ไขรายการสัญญาหลังจากมีใบสั่งซื้อแล้ว
**Business Rule**: BR-CITEM-008

---

## Validation Errors

### Field Validation Errors (MD-VAL)

#### MD-VAL-001: Required Field Missing
**Fields**: All required fields
**HTTP Status**: 400
**Example**:
```json
{
  "code": "MD-VAL-001",
  "message": "Required fields missing",
  "fields": ["location_code", "location_name"]
}
```

#### MD-VAL-002: Invalid Data Type
**HTTP Status**: 400
**Message (EN)**: Field '{field}' must be of type {expected_type}
**Message (TH)**: ฟิลด์ '{field}' ต้องเป็นชนิด {expected_type}

#### MD-VAL-003: Value Out of Range
**HTTP Status**: 400
**Message (EN)**: Field '{field}' value must be between {min} and {max}
**Message (TH)**: ค่าของฟิลด์ '{field}' ต้องอยู่ระหว่าง {min} ถึง {max}

#### MD-VAL-004: Invalid Enum Value
**HTTP Status**: 400
**Message (EN)**: Field '{field}' must be one of: {allowed_values}
**Message (TH)**: ฟิลด์ '{field}' ต้องเป็นค่าใดค่าหนึ่งจาก: {allowed_values}

#### MD-VAL-005: Invalid Date Format
**HTTP Status**: 400
**Message (EN)**: Field '{field}' must be a valid date (YYYY-MM-DD)
**Message (TH)**: ฟิลด์ '{field}' ต้องเป็นวันที่รูปแบบ (YYYY-MM-DD)

---

## Business Logic Errors

### Reference Integrity (MD-REF)

#### MD-REF-001: Foreign Key Not Found
**HTTP Status**: 404
**Message (EN)**: Referenced {entity} with id={id} not found
**Message (TH)**: ไม่พบข้อมูล {entity} ที่อ้างอิง id={id}
**Example**: Referenced company (manufacturer_id=999) not found

#### MD-REF-002: Cannot Delete Referenced Entity
**HTTP Status**: 422
**Message (EN)**: Cannot delete {entity} referenced by {count} {referencing_entity}
**Message (TH)**: ไม่สามารถลบ {entity} ที่มี {referencing_entity} อ้างอิง {count} รายการ

#### MD-REF-003: Inactive Reference
**HTTP Status**: 422
**Message (EN)**: Cannot reference inactive {entity}
**Message (TH)**: ไม่สามารถอ้างอิง {entity} ที่ไม่ active

---

## Error Response Format

### Standard Error Response Structure

```typescript
interface ErrorResponse {
  // Error identification
  code: string;                    // Error code (e.g., "MD-LOC-V01")
  message: string;                 // Human-readable message
  message_th?: string;             // Thai translation (optional)

  // HTTP metadata
  status: number;                  // HTTP status code (400, 404, 422, etc.)
  timestamp: string;               // ISO 8601 timestamp
  path: string;                    // Request path
  method: string;                  // HTTP method (GET, POST, etc.)

  // Error details
  field?: string;                  // Field name (for validation errors)
  fields?: string[];               // Multiple fields (for batch validation)
  value?: any;                     // Invalid value
  entity?: string;                 // Entity name

  // Additional context
  details?: any;                   // Additional error context
  validationErrors?: ValidationError[];  // Multiple validation errors

  // Debugging (dev/test only)
  stack?: string;                  // Stack trace (not in production)
  requestId?: string;              // Request correlation ID
}

interface ValidationError {
  field: string;
  message: string;
  code: string;
  value?: any;
}
```

### Example Error Responses

#### 1. Validation Error (Single Field)
```json
{
  "code": "MD-LOC-V01",
  "message": "Location code must be 3-20 uppercase alphanumeric characters",
  "message_th": "รหัสสถานที่ต้องเป็นตัวอักษรและตัวเลขพิมพ์ใหญ่ 3-20 ตัว",
  "status": 400,
  "timestamp": "2025-01-22T10:30:00Z",
  "path": "/api/master-data/locations",
  "method": "POST",
  "field": "location_code",
  "value": "wh1",
  "details": {
    "pattern": "^[A-Z0-9-]{3,20}$",
    "examples": ["WH001", "PHARM-OPD"]
  }
}
```

#### 2. Multiple Validation Errors
```json
{
  "code": "MD-VAL-001",
  "message": "Multiple validation errors",
  "message_th": "พบข้อผิดพลาดหลายรายการ",
  "status": 400,
  "timestamp": "2025-01-22T10:30:00Z",
  "path": "/api/master-data/drugs",
  "method": "POST",
  "validationErrors": [
    {
      "field": "drug_code",
      "code": "MD-DRG-V01",
      "message": "Drug code must be 7-24 characters",
      "value": "SAR"
    },
    {
      "field": "pack_size",
      "code": "MD-DRG-V03",
      "message": "Pack size must be greater than 0",
      "value": 0
    }
  ]
}
```

#### 3. Business Logic Error
```json
{
  "code": "MD-LOC-B03",
  "message": "Cannot delete location with inventory (quantity: 500)",
  "message_th": "ไม่สามารถลบสถานที่ที่มียาคงเหลือ (จำนวน: 500)",
  "status": 422,
  "timestamp": "2025-01-22T10:30:00Z",
  "path": "/api/master-data/locations/5",
  "method": "DELETE",
  "entity": "Location",
  "details": {
    "location_id": 5,
    "location_code": "WH001",
    "inventory_count": 500,
    "action": "Move inventory to another location before deletion"
  }
}
```

#### 4. Not Found Error
```json
{
  "code": "MD-GEN-N01",
  "message": "Location with id='999' not found",
  "message_th": "ไม่พบข้อมูล Location ที่มี id='999'",
  "status": 404,
  "timestamp": "2025-01-22T10:30:00Z",
  "path": "/api/master-data/locations/999",
  "method": "GET",
  "entity": "Location",
  "field": "id",
  "value": "999"
}
```

#### 5. Duplicate Key Error
```json
{
  "code": "MD-GEN-C01",
  "message": "Location with location_code='WH001' already exists",
  "message_th": "Location ที่มี location_code='WH001' มีอยู่แล้วในระบบ",
  "status": 409,
  "timestamp": "2025-01-22T10:30:00Z",
  "path": "/api/master-data/locations",
  "method": "POST",
  "entity": "Location",
  "field": "location_code",
  "value": "WH001",
  "details": {
    "existing_id": 1,
    "action": "Use a different location_code or update the existing record"
  }
}
```

---

## Error Handling Examples

### Backend Error Handling (TypeScript)

```typescript
import { Prisma } from '@prisma/client';

// Custom error class
class AppError extends Error {
  constructor(
    public code: string,
    public message: string,
    public status: number,
    public details?: any
  ) {
    super(message);
    this.name = 'AppError';
  }
}

// Error handler middleware
function errorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  // Log error
  console.error('[Error]', {
    code: err instanceof AppError ? err.code : 'UNKNOWN',
    message: err.message,
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString()
  });

  // Handle Prisma errors
  if (err instanceof Prisma.PrismaClientKnownRequestError) {
    return handlePrismaError(err, req, res);
  }

  // Handle custom app errors
  if (err instanceof AppError) {
    return res.status(err.status).json({
      code: err.code,
      message: err.message,
      status: err.status,
      timestamp: new Date().toISOString(),
      path: req.path,
      method: req.method,
      details: err.details
    });
  }

  // Handle unexpected errors
  return res.status(500).json({
    code: 'MD-GEN-S01',
    message: 'An unexpected error occurred',
    status: 500,
    timestamp: new Date().toISOString(),
    path: req.path,
    method: req.method
  });
}

// Prisma error handler
function handlePrismaError(err: Prisma.PrismaClientKnownRequestError, req: Request, res: Response) {
  switch (err.code) {
    case 'P2002': // Unique constraint violation
      return res.status(409).json({
        code: 'MD-GEN-C01',
        message: `Duplicate key: ${err.meta?.target}`,
        status: 409,
        timestamp: new Date().toISOString(),
        path: req.path,
        method: req.method,
        field: err.meta?.target,
        details: err.meta
      });

    case 'P2025': // Record not found
      return res.status(404).json({
        code: 'MD-GEN-N01',
        message: 'Record not found',
        status: 404,
        timestamp: new Date().toISOString(),
        path: req.path,
        method: req.method
      });

    case 'P2003': // Foreign key constraint failed
      return res.status(400).json({
        code: 'MD-REF-001',
        message: 'Foreign key constraint failed',
        status: 400,
        timestamp: new Date().toISOString(),
        path: req.path,
        method: req.method,
        field: err.meta?.field_name
      });

    default:
      return res.status(500).json({
        code: 'MD-GEN-D02',
        message: 'Database query failed',
        status: 500,
        timestamp: new Date().toISOString(),
        path: req.path,
        method: req.method
      });
  }
}

// Example usage in route handler
async function createLocation(req: Request, res: Response, next: NextFunction) {
  try {
    const { location_code, location_name, location_type } = req.body;

    // Validation
    if (!location_code || location_code.length < 3 || location_code.length > 20) {
      throw new AppError(
        'MD-LOC-V01',
        'Location code must be 3-20 uppercase alphanumeric characters',
        400,
        { pattern: '^[A-Z0-9-]{3,20}$', value: location_code }
      );
    }

    // Business logic
    const location = await prisma.location.create({
      data: { location_code, location_name, location_type }
    });

    res.status(201).json(location);
  } catch (err) {
    next(err);
  }
}
```

### Frontend Error Handling (React/TypeScript)

```typescript
// API client with error handling
async function apiCall<T>(
  url: string,
  options?: RequestInit
): Promise<T> {
  try {
    const response = await fetch(url, options);

    if (!response.ok) {
      const error = await response.json();
      throw new APIError(error);
    }

    return await response.json();
  } catch (err) {
    if (err instanceof APIError) {
      throw err;
    }
    throw new APIError({
      code: 'CLIENT_ERROR',
      message: 'Network error occurred',
      status: 0
    });
  }
}

// Custom error class
class APIError extends Error {
  constructor(public error: ErrorResponse) {
    super(error.message);
    this.name = 'APIError';
  }
}

// Error display component
function ErrorAlert({ error }: { error: ErrorResponse }) {
  // Show Thai message if available, otherwise English
  const message = error.message_th || error.message;

  // Color based on status
  const severity = error.status >= 500 ? 'error' : 'warning';

  return (
    <Alert severity={severity}>
      <AlertTitle>Error Code: {error.code}</AlertTitle>
      {message}
      {error.details && (
        <pre>{JSON.stringify(error.details, null, 2)}</pre>
      )}
    </Alert>
  );
}

// Usage in component
function CreateLocationForm() {
  const [error, setError] = useState<ErrorResponse | null>(null);

  async function handleSubmit(data: LocationInput) {
    try {
      setError(null);
      await apiCall('/api/master-data/locations', {
        method: 'POST',
        body: JSON.stringify(data)
      });
      // Success handling
    } catch (err) {
      if (err instanceof APIError) {
        setError(err.error);

        // Handle specific error codes
        switch (err.error.code) {
          case 'MD-LOC-V01':
            // Show inline error on location_code field
            setFieldError('location_code', err.error.message);
            break;

          case 'MD-GEN-C01':
            // Show duplicate error
            toast.error('Location code already exists');
            break;

          default:
            // Show general error
            toast.error(err.error.message);
        }
      }
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      {error && <ErrorAlert error={error} />}
      {/* Form fields */}
    </form>
  );
}
```

---

## Error Code Summary

| Category | Code Range | Count | Examples |
|----------|------------|-------|----------|
| **General** | MD-GEN-* | 11 | V01-V04, N01, C01, D01-D02, A01, S01 |
| **Locations** | MD-LOC-* | 8 | V01-V02, B01-B06 |
| **Departments** | MD-DEP-* | 4 | V01-V02, B01-B02 |
| **Budget Types** | MD-BTY-* | 2 | V01, B01 |
| **Budget Categories** | MD-BCA-* | 3 | V01-V02, B01 |
| **Budgets** | MD-BUD-* | 3 | V01, B01-B02 |
| **Bank** | MD-BNK-* | 2 | V01, B01 |
| **Companies** | MD-COM-* | 13 | V01-V07, B01-B03 |
| **Drug Generics** | MD-GEN-* | 3 | V01-V02, B01 |
| **Drugs** | MD-DRG-* | 12 | V01-V07, B01-B05 |
| **Contracts** | MD-CON-* | 7 | V01-V03, B01-B04 |
| **Contract Items** | MD-CIT-* | 5 | V01, B01-B04 |
| **Validation** | MD-VAL-* | 5 | 001-005 |
| **References** | MD-REF-* | 3 | 001-003 |
| **Total** | | **81** | |

---

## Related Documentation

- **Schema Reference**: `01-SCHEMA.md` - Database structure
- **Business Rules**: `07-BUSINESS-RULES.md` - Business logic rules
- **Validation Rules**: `03-VALIDATION-RULES.md` - Input validation
- **Test Cases**: `05-TEST-CASES.md` - Error scenario tests
- **API Specification**: `../api/API_SPECIFICATION.md` - API endpoints

---

**Last Updated**: 2025-01-22
**Version**: 2.2.0
**Maintained By**: Development Team

---

**End of Error Codes Documentation**

*Part of INVS Modern - Hospital Inventory Management System*
