# API Specification - Master Data Management

**Module**: Master Data
**Base Path**: `/api/master-data`
**Version**: 1.0.0
**Authentication**: Required (JWT Bearer Token)

---

## Table of Contents

1. [API Architecture](#api-architecture)
2. [Authentication](#authentication)
3. [Common Patterns](#common-patterns)
4. [Locations API](#locations-api)
5. [Departments API](#departments-api)
6. [Companies API](#companies-api)
7. [Drug Generics API](#drug-generics-api)
8. [Drugs API](#drugs-api)
9. [Budget Management API](#budget-management-api)
10. [Error Responses](#error-responses)

---

## API Architecture

### Design Pattern: Grouped Namespace

This API uses a **grouped namespace pattern** with module-based prefixes to organize endpoints logically and support scalability.

**Why Grouped Pattern?**

✅ **Clear Organization** - Easy to identify which module an endpoint belongs to
✅ **Namespace Separation** - Prevents endpoint conflicts between modules
✅ **Authorization Control** - Easier to apply permissions by module (e.g., all `/api/master-data/*` requires specific roles)
✅ **Scalability** - Adding new modules doesn't conflict with existing endpoints
✅ **Documentation** - Logical grouping makes API documentation clearer

### System-Wide API Structure

The INVS system uses the following module-based API paths:

| Module | Base Path | Purpose | Examples |
|--------|-----------|---------|----------|
| **Master Data** | `/api/master-data` | Core master data (ข้อมูลหลัก) | `/api/master-data/drugs`<br>`/api/master-data/companies` |
| **Budget** | `/api/budget` | Budget management (งบประมาณ) | `/api/budget/allocations`<br>`/api/budget/reservations` |
| **Procurement** | `/api/procurement` | Purchase requests & orders (จัดซื้อ) | `/api/procurement/purchase-requests`<br>`/api/procurement/purchase-orders` |
| **Inventory** | `/api/inventory` | Stock & lot management (คลังยา) | `/api/inventory/stock`<br>`/api/inventory/lots` |
| **Distribution** | `/api/distribution` | Drug distribution (จ่ายยา) | `/api/distribution/requests`<br>`/api/distribution/dispense` |
| **Reporting** | `/api/reporting` | Reports & analytics (รายงาน) | `/api/reporting/ministry-exports`<br>`/api/reporting/usage-stats` |
| **Auth** | `/api/auth` | Authentication (ระบบยืนยันตัวตน) | `/api/auth/login`<br>`/api/auth/logout` |

### Cross-Module Operation Example

Example workflow showing how modules work together:

```
1. Create Purchase Request (Procurement)
   POST /api/procurement/purchase-requests
   {
     "departmentId": 5,
     "budgetId": 10,
     "items": [
       { "drugId": 100, "quantity": 1000 }
     ]
   }

2. Check Budget Availability (Budget Module)
   → Internal call to /api/budget/check-availability
   → Validates budget has sufficient funds

3. Reserve Budget (Budget Module)
   → Internal call to /api/budget/reservations
   → Temporarily holds budget amount

4. Approve & Create PO (Procurement)
   PATCH /api/procurement/purchase-requests/123/approve
   → Creates Purchase Order

5. Receive Goods (Inventory)
   POST /api/inventory/receipts
   → Updates inventory levels
   → Commits budget reservation

6. Update Stock (Inventory)
   → Inventory updated automatically
   GET /api/inventory/stock?drugId=100
```

### URL Versioning Strategy

Currently using **implicit v1** (no version in URL). When v2 is needed:

```
Current:  /api/master-data/drugs
Future:   /api/v2/master-data/drugs  (when breaking changes needed)
```

### Alternative Patterns Considered

| Pattern | Example | Why Not Used |
|---------|---------|--------------|
| **Flat/Short** | `/api/drugs` | ❌ Risk of endpoint conflicts in large system |
| **Hybrid** | `/api/drugs` + `/api/master/bulk` | ❌ Inconsistent pattern, hard to document |
| **Versioned Only** | `/api/v1/drugs` | ❌ Not needed yet, adds unnecessary length |

---

## Authentication

All endpoints require JWT authentication via Bearer token:

```http
Authorization: Bearer <jwt_token>
```

### Get Authentication Token

```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "pharmacist01",
  "password": "SecurePass123"
}
```

**Response**:

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "pharmacist01",
    "role": "PHARMACIST",
    "departmentId": 5
  },
  "expiresIn": "24h"
}
```

---

## Common Patterns

### Pagination

All list endpoints support pagination:

```http
GET /api/master-data/drugs?page=1&limit=20
```

**Response**:

```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

### Filtering

```http
GET /api/master-data/drugs?active=true&nlemStatus=E&search=paracetamol
```

### Sorting

```http
GET /api/master-data/drugs?sortBy=tradeName&order=asc
```

### Standard Response Format

**Success**:

```json
{
  "success": true,
  "data": { ... }
}
```

**Error**:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [...]
  }
}
```

---

## Locations API

Manage storage locations (คลัง, ห้องยา, หอผู้ป่วย).

### List Locations

```http
GET /api/master-data/locations
```

**Query Parameters**:
- `type` (optional): Filter by location type (WAREHOUSE, PHARMACY, WARD, etc.)
- `active` (optional): Filter by active status (true/false)
- `search` (optional): Search by code or name
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)

**Example**:

```http
GET /api/master-data/locations?type=WAREHOUSE&active=true&page=1&limit=10
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "locationCode": "WH001",
      "locationName": "คลังกลาง",  // Main warehouse
      "locationType": "WAREHOUSE",
      "parentId": null,
      "address": "ชั้น 1 อาคารเภสัชกรรม",
      "responsiblePerson": "นายสมชาย ใจดี",
      "isActive": true,
      "createdAt": "2025-01-01T00:00:00Z",
      "updatedAt": "2025-01-01T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 15,
    "totalPages": 2
  }
}
```

---

### Get Location by ID

```http
GET /api/master-data/locations/:id
```

**Example**:

```http
GET /api/master-data/locations/1
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "id": 1,
    "locationCode": "WH001",
    "locationName": "คลังกลาง",
    "locationType": "WAREHOUSE",
    "parentId": null,
    "parent": null,
    "children": [
      {
        "id": 2,
        "locationCode": "WH001-A",
        "locationName": "โซน A",
        "locationType": "WAREHOUSE"
      }
    ],
    "address": "ชั้น 1 อาคารเภสัชกรรม",
    "responsiblePerson": "นายสมชาย ใจดี",
    "isActive": true,
    "createdAt": "2025-01-01T00:00:00Z",
    "updatedAt": "2025-01-01T00:00:00Z"
  }
}
```

---

### Create Location

```http
POST /api/master-data/locations
Content-Type: application/json
Authorization: Bearer <token>
```

**Required Role**: ADMIN, WAREHOUSE_MANAGER

**Request Body**:

```json
{
  "locationCode": "PHARM001",
  "locationName": "ห้องยาผู้ป่วยนอก",  // OPD pharmacy
  "locationType": "PHARMACY",
  "parentId": null,
  "address": "ชั้น 1 อาคารผู้ป่วยนอก",
  "responsiblePerson": "ภญ.สมหญิง ดีมาก"
}
```

**Field Descriptions**:
- `locationCode` (string, required): Unique location code (รหัสสถานที่ ต้องไม่ซ้ำ)
- `locationName` (string, required): Location name (ชื่อสถานที่)
- `locationType` (enum, required): Type of location
  - `WAREHOUSE` - Main warehouse (คลังกลาง)
  - `PHARMACY` - Pharmacy (ห้องยา)
  - `WARD` - Ward storage (คลังหอผู้ป่วย)
  - `EMERGENCY` - Emergency room (ห้องฉุกเฉิน)
  - `OR` - Operating room (ห้องผ่าตัด)
  - `ICU` - ICU storage
  - `GENERAL` - General storage
- `parentId` (number, optional): Parent location ID for hierarchy (สถานที่แม่)
- `address` (string, optional): Physical address (ที่อยู่)
- `responsiblePerson` (string, optional): Person in charge (ผู้รับผิดชอบ)

**Response** (201 Created):

```json
{
  "success": true,
  "data": {
    "id": 10,
    "locationCode": "PHARM001",
    "locationName": "ห้องยาผู้ป่วยนอก",
    "locationType": "PHARMACY",
    "isActive": true,
    "createdAt": "2025-01-21T10:00:00Z"
  }
}
```

---

### Update Location

```http
PUT /api/master-data/locations/:id
Content-Type: application/json
Authorization: Bearer <token>
```

**Required Role**: ADMIN, WAREHOUSE_MANAGER

**Request Body** (partial update allowed):

```json
{
  "locationName": "ห้องยาผู้ป่วยนอก (ชั้น 1)",
  "responsiblePerson": "ภญ.สมหญิง ดีมาก"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "id": 10,
    "locationCode": "PHARM001",
    "locationName": "ห้องยาผู้ป่วยนอก (ชั้น 1)",
    "updatedAt": "2025-01-21T11:00:00Z"
  }
}
```

---

### Deactivate Location

```http
PATCH /api/master-data/locations/:id/deactivate
Authorization: Bearer <token>
```

**Required Role**: ADMIN, WAREHOUSE_MANAGER

**Response** (200 OK):

```json
{
  "success": true,
  "message": "Location deactivated successfully",
  "data": {
    "id": 10,
    "isActive": false
  }
}
```

---

## Departments API

Manage hospital departments (แผนกต่างๆ ในโรงพยาบาล).

### List Departments

```http
GET /api/master-data/departments
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "deptCode": "PHARM",
      "deptName": "ห้องยา",  // Pharmacy department
      "hisCode": "PHARM01",
      "parentId": null,
      "headPerson": "ภญ.หัวหน้า เภสัชกรรม",
      "consumptionGroup": "OPD_IPD_MIX",  // Mixed OPD+IPD (ผสม OPD+IPD)
      "isActive": true
    }
  ]
}
```

---

### Create Department

```http
POST /api/master-data/departments
Content-Type: application/json
```

**Required Role**: ADMIN

**Request Body**:

```json
{
  "deptCode": "OPD",
  "deptName": "แผนกผู้ป่วยนอก",  // Outpatient department
  "hisCode": "OPD001",
  "parentId": null,
  "headPerson": "นพ.หัวหน้า OPD",
  "consumptionGroup": "OPD_MAINLY"  // Mainly OPD (OPD มากกว่า 70%)
}
```

**Field Descriptions**:
- `consumptionGroup` (enum, optional): Drug usage pattern for ministry reporting (กลุ่มการใช้ยาสำหรับรายงานกระทรวง)
  - `OPD_IPD_MIX` - 1: Mixed OPD+IPD (ผสม OPD+IPD)
  - `OPD_MAINLY` - 2: Mainly OPD >70% (OPD มากกว่า 70%)
  - `IPD_MAINLY` - 3: Mainly IPD >70% (IPD มากกว่า 70%)
  - `OTHER_INTERNAL` - 4: Other internal (OR, X-ray, Lab)
  - `PRIMARY_CARE` - 5: Primary care unit (รพ.สต.)
  - `PC_TRANSFERRED` - 6: Transferred from primary care (รพ.สต. ถ่ายโอน)
  - `OTHER_EXTERNAL` - 9: Other external (อื่นๆ นอก รพ.)

**Response** (201 Created):

```json
{
  "success": true,
  "data": {
    "id": 5,
    "deptCode": "OPD",
    "deptName": "แผนกผู้ป่วยนอก",
    "consumptionGroup": "OPD_MAINLY",
    "isActive": true
  }
}
```

---

## Companies API

Manage vendors and manufacturers (บริษัทผู้ขาย/ผู้ผลิต).

### List Companies

```http
GET /api/master-data/companies?type=VENDOR&active=true
```

**Query Parameters**:
- `type` (optional): VENDOR, MANUFACTURER, BOTH
- `active` (optional): true/false
- `search` (optional): Search by code or name

**Response** (200 OK):

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "companyCode": "GPO001",
      "companyName": "องค์การเภสัชกรรม",  // Government Pharmaceutical Organization
      "companyType": "BOTH",
      "taxId": "0994000158378",
      "address": "75/1 ถนนพระราม 6 กรุงเทพฯ",
      "phone": "02-644-8000",
      "email": "contact@gpo.or.th",
      "contactPerson": "นายติดต่อ GPO",
      "isActive": true
    }
  ]
}
```

---

### Create Company

```http
POST /api/master-data/companies
Content-Type: application/json
```

**Required Role**: ADMIN, PHARMACIST, WAREHOUSE_MANAGER, FINANCE

**Request Body**:

```json
{
  "companyCode": "ZUELLIG",
  "companyName": "Zuellig Pharma",
  "companyType": "VENDOR",
  "taxId": "0105536001433",
  "address": "123 ถนนสาทร กรุงเทพฯ",
  "phone": "02-123-4567",
  "email": "contact@zuellig.com",
  "contactPerson": "Mr. John Doe"
}
```

**Field Descriptions**:
- `companyCode` (string, required): Unique company code (รหัสบริษัท)
- `companyName` (string, required): Company name (ชื่อบริษัท)
- `companyType` (enum, required): Type of company
  - `VENDOR` - Vendor only (ผู้จำหน่าย)
  - `MANUFACTURER` - Manufacturer only (ผู้ผลิต)
  - `BOTH` - Both vendor and manufacturer
- `taxId` (string, optional): Tax ID 13 digits (เลขผู้เสียภาษี 13 หลัก)
- `contactPerson` (string, optional): Contact person (ผู้ติดต่อ)

**Response** (201 Created):

```json
{
  "success": true,
  "data": {
    "id": 10,
    "companyCode": "ZUELLIG",
    "companyName": "Zuellig Pharma",
    "companyType": "VENDOR",
    "isActive": true
  }
}
```

---

## Drug Generics API

Manage generic drug catalog (ยาสามัญ).

### List Drug Generics

```http
GET /api/master-data/drug-generics?search=paracetamol&active=true
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "genericCode": "PAR001",
      "genericName": "Paracetamol",
      "workingCode": "PAR0001",
      "dosageForm": "TAB",  // Tablet (เม็ด)
      "strength": "500",
      "unit": "mg",
      "therapeuticClass": "Analgesic/Antipyretic",
      "isActive": true,
      "_count": {
        "drugs": 15  // Number of trade drugs linked (จำนวนยาชื่อการค้า)
      }
    }
  ]
}
```

---

### Create Drug Generic

```http
POST /api/master-data/drug-generics
Content-Type: application/json
```

**Required Role**: ADMIN, PHARMACIST

**Request Body**:

```json
{
  "genericCode": "IBU001",
  "genericName": "Ibuprofen",
  "workingCode": "IBU0001",
  "dosageForm": "TAB",
  "strength": "400",
  "unit": "mg",
  "therapeuticClass": "NSAID"
}
```

**Response** (201 Created):

```json
{
  "success": true,
  "data": {
    "id": 50,
    "genericCode": "IBU001",
    "genericName": "Ibuprofen",
    "isActive": true
  }
}
```

---

## Drugs API

Manage trade name drugs (ยาชื่อการค้า) with ministry compliance fields.

### List Drugs

```http
GET /api/master-data/drugs?search=sara&nlemStatus=E&active=true
```

**Query Parameters**:
- `search` (optional): Search by drug code or trade name
- `genericId` (optional): Filter by generic drug
- `manufacturerId` (optional): Filter by manufacturer
- `nlemStatus` (optional): E or N (Essential/Non-Essential)
- `drugStatus` (optional): ACTIVE, DISCONTINUED, SPECIAL_CASE, REMOVED
- `productCategory` (optional): 1-5
- `active` (optional): true/false

**Response** (200 OK):

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "drugCode": "SARA500",
      "tradeName": "Sara 500mg",
      "strength": "500 mg",
      "dosageForm": "TAB",
      "packSize": 1000,  // 1000 tablets per box (บรรจุ 1000 เม็ด/กล่อง)
      "unitPrice": "2.50",
      "unit": "TAB",
      "nlemStatus": "E",  // Essential drug (ยาหลักแห่งชาติ)
      "drugStatus": "ACTIVE",  // Currently active (ยังใช้งาน)
      "productCategory": "MODERN_REGISTERED",  // Registered modern medicine
      "statusChangedDate": "2025-01-01T00:00:00Z",
      "isActive": true,
      "generic": {
        "id": 1,
        "genericName": "Paracetamol"
      },
      "manufacturer": {
        "id": 1,
        "companyName": "องค์การเภสัชกรรม"
      }
    }
  ]
}
```

---

### Get Drug by ID

```http
GET /api/master-data/drugs/:id
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "id": 1,
    "drugCode": "SARA500",
    "tradeName": "Sara 500mg",
    "strength": "500 mg",
    "dosageForm": "TAB",
    "packSize": 1000,
    "unitPrice": "2.50",
    "unit": "TAB",
    "standardCode": "10123456789012345678SARA",  // 24-digit standard code
    "barcode": "8851234567890",
    "nlemStatus": "E",
    "drugStatus": "ACTIVE",
    "productCategory": "MODERN_REGISTERED",
    "statusChangedDate": "2025-01-01T00:00:00Z",
    "isActive": true,
    "generic": {
      "id": 1,
      "genericCode": "PAR001",
      "genericName": "Paracetamol",
      "workingCode": "PAR0001"
    },
    "manufacturer": {
      "id": 1,
      "companyCode": "GPO001",
      "companyName": "องค์การเภสัชกรรม",
      "companyType": "BOTH"
    },
    "inventory": [
      {
        "locationId": 1,
        "quantityOnHand": 5000,  // Current stock (ยอดคงเหลือ)
        "location": {
          "locationName": "คลังกลาง"
        }
      }
    ]
  }
}
```

---

### Create Drug

```http
POST /api/master-data/drugs
Content-Type: application/json
```

**Required Role**: ADMIN, PHARMACIST

**Request Body**:

```json
{
  "drugCode": "TYLENOL500",
  "tradeName": "Tylenol 500mg",
  "genericId": 1,
  "manufacturerId": 5,
  "strength": "500 mg",
  "dosageForm": "TAB",
  "packSize": 100,
  "unitPrice": 3.50,
  "unit": "TAB",
  "standardCode": "10123456789012345678TYLE",
  "barcode": "8851234567891",
  "nlemStatus": "E",
  "drugStatus": "ACTIVE",
  "productCategory": "MODERN_REGISTERED"
}
```

**Field Descriptions - Ministry Compliance ⭐**:
- `nlemStatus` (enum, optional): NLEM status (สถานะบัญชียาหลักแห่งชาติ)
  - `E` - Essential drug (ยาหลัก)
  - `N` - Non-essential drug (ยาเสริม)
- `drugStatus` (enum, required): Drug lifecycle status (สถานะวงจรชีวิต)
  - `ACTIVE` - 1: Active (ใช้งานปกติ)
  - `DISCONTINUED` - 2: Discontinued but stock remains (ตัดจากบัญชีแต่ยังมียาเหลือ)
  - `SPECIAL_CASE` - 3: Special approval required (กรณีพิเศษ ต้องขออนุมัติ)
  - `REMOVED` - 4: Removed completely (ตัดออกและไม่มียาเหลือ)
- `productCategory` (enum, optional): Product type (ประเภทผลิตภัณฑ์)
  - `MODERN_REGISTERED` - 1: Registered modern medicine (ยาแผนปัจจุบันขึ้นทะเบียน อย.)
  - `MODERN_HOSPITAL` - 2: Hospital-made modern medicine (ยาแผนปัจจุบันผลิตโรงพยาบาล)
  - `HERBAL_REGISTERED` - 3: Registered herbal medicine (ยาสมุนไพรขึ้นทะเบียน)
  - `HERBAL_HOSPITAL` - 4: Hospital-made herbal medicine (ยาสมุนไพรผลิตโรงพยาบาล)
  - `OTHER` - 5: Other (อื่นๆ)
- `statusChangedDate` (datetime, auto-set): Date when drug status changed (วันที่เปลี่ยนสถานะ)

**Response** (201 Created):

```json
{
  "success": true,
  "data": {
    "id": 100,
    "drugCode": "TYLENOL500",
    "tradeName": "Tylenol 500mg",
    "nlemStatus": "E",
    "drugStatus": "ACTIVE",
    "productCategory": "MODERN_REGISTERED",
    "statusChangedDate": "2025-01-21T10:00:00Z",
    "isActive": true
  }
}
```

---

### Update Drug

```http
PUT /api/master-data/drugs/:id
Content-Type: application/json
```

**Required Role**: ADMIN, PHARMACIST

**Request Body** (partial update allowed):

```json
{
  "tradeName": "Tylenol 500mg (New Formula)",
  "unitPrice": 3.75
}
```

---

### Change Drug Status (Ministry Compliance)

```http
PATCH /api/master-data/drugs/:id/status
Content-Type: application/json
```

**Required Role**: ADMIN, PHARMACIST

**Request Body**:

```json
{
  "drugStatus": "DISCONTINUED",
  "reason": "ยาเลิกผลิตจากบริษัท ไม่สามารถจัดหาได้อีกต่อไป"  // Reason for status change (min 10 chars)
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "message": "Drug status changed successfully",
  "data": {
    "id": 1,
    "drugCode": "SARA500",
    "drugStatus": "DISCONTINUED",
    "statusChangedDate": "2025-01-21T10:00:00Z",  // ⭐ Auto-updated
    "statusChangeReason": "ยาเลิกผลิตจากบริษัท ไม่สามารถจัดหาได้อีกต่อไป"
  }
}
```

---

## Budget Management API

### List Budget Types

```http
GET /api/master-data/budget-types
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "typeCode": "OP001",
      "typeName": "งบดำเนินงาน - ยา",  // Operational budget - Drugs
      "typeGroup": "OPERATIONAL",
      "isActive": true
    }
  ]
}
```

---

## Error Responses

### 400 Bad Request - Validation Error

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "drugCode",
        "message": "Drug code must be between 7-24 characters"
      },
      {
        "field": "packSize",
        "message": "Pack size must be greater than 0"
      }
    ]
  }
}
```

### 401 Unauthorized - Not Authenticated

```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication required. Please provide a valid JWT token."
  }
}
```

### 403 Forbidden - No Permission

```json
{
  "success": false,
  "error": {
    "code": "FORBIDDEN",
    "message": "User role 'VIEWER' does not have 'create' permission for 'drug'"
  }
}
```

### 404 Not Found

```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Drug with ID 999 not found"
  }
}
```

### 409 Conflict - Duplicate

```json
{
  "success": false,
  "error": {
    "code": "DUPLICATE_ERROR",
    "message": "Company code 'GPO001' already exists"
  }
}
```

### 422 Unprocessable Entity - Business Rule Violation

```json
{
  "success": false,
  "error": {
    "code": "BUSINESS_RULE_ERROR",
    "message": "Cannot deactivate company with 3 active contracts. Please close contracts first.",
    "details": {
      "activeContracts": 3
    }
  }
}
```

### 500 Internal Server Error

```json
{
  "success": false,
  "error": {
    "code": "INTERNAL_ERROR",
    "message": "An unexpected error occurred. Please try again later.",
    "requestId": "req_abc123xyz"
  }
}
```

---

## Rate Limiting

API requests are rate-limited:
- **Authenticated users**: 1000 requests per hour
- **Public endpoints**: 100 requests per hour

Rate limit headers:

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 995
X-RateLimit-Reset: 1642851600
```

---

## Versioning

API version is specified in the URL:

```http
GET /api/v1/master-data/drugs
```

Current version: `v1`

---

**Version**: 1.0.0
**Last Updated**: 2025-01-21
**Status**: Ready for Implementation

For Postman collection and detailed examples, see `POSTMAN_EXAMPLES.json`.
