# 🚀 Master Data Management - API Development Guide

**System:** Master Data Management
**Version:** 2.6.0
**Last Updated:** 2025-01-28
**Target Audience:** Backend Developers

---

## 📋 Table of Contents

1. [Authentication & Authorization](#authentication--authorization)
2. [API Development Priority](#api-development-priority)
3. [Error Handling Standards](#error-handling-standards)
4. [Request/Response Examples](#requestresponse-examples)
5. [Environment Configuration](#environment-configuration)
6. [Testing Guidelines](#testing-guidelines)

---

## 🔐 Authentication & Authorization

### Role-Based Access Control (RBAC) Matrix

| Entity | Endpoint Pattern | Finance Manager | Dept Head | Pharmacist | Nurse | Other Staff |
|--------|-----------------|-----------------|-----------|------------|-------|-------------|
| **Organization Data** |
| Locations | `GET /api/master-data/locations` | ✅ | ✅ | ✅ | ✅ | ✅ |
| | `POST /api/master-data/locations` | ✅ | ❌ | ❌ | ❌ | ❌ |
| | `PUT /api/master-data/locations/:id` | ✅ | ❌ | ❌ | ❌ | ❌ |
| | `DELETE /api/master-data/locations/:id` | ✅ | ❌ | ❌ | ❌ | ❌ |
| Departments | `GET /api/master-data/departments` | ✅ | ✅ | ✅ | ✅ | ✅ |
| | `POST /api/master-data/departments` | ✅ | ❌ | ❌ | ❌ | ❌ |
| | `PUT /api/master-data/departments/:id` | ✅ | ✅ (Own) | ❌ | ❌ | ❌ |
| | `DELETE /api/master-data/departments/:id` | ✅ | ❌ | ❌ | ❌ | ❌ |
| Banks | `GET /api/master-data/banks` | ✅ | ✅ | ✅ | ❌ | ❌ |
| | `POST /api/master-data/banks` | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Budget Structure** |
| Budget Types | `GET /api/master-data/budget-types` | ✅ | ✅ | ✅ | ❌ | ❌ |
| | `POST /api/master-data/budget-types` | ✅ | ❌ | ❌ | ❌ | ❌ |
| Budget Categories | `GET /api/master-data/budget-categories` | ✅ | ✅ | ✅ | ❌ | ❌ |
| | `POST /api/master-data/budget-categories` | ✅ | ❌ | ❌ | ❌ | ❌ |
| Budgets | `GET /api/master-data/budgets` | ✅ | ✅ | ✅ | ❌ | ❌ |
| | `POST /api/master-data/budgets` | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Drug & Company Data** |
| Drug Generics | `GET /api/master-data/generics` | ✅ | ✅ | ✅ | ✅ | ✅ |
| | `GET /api/master-data/generics/:id` | ✅ | ✅ | ✅ | ✅ | ✅ |
| | `POST /api/master-data/generics` | ✅ | ❌ | ✅ | ❌ | ❌ |
| | `PUT /api/master-data/generics/:id` | ✅ | ❌ | ✅ | ❌ | ❌ |
| | `DELETE /api/master-data/generics/:id` | ✅ | ❌ | ❌ | ❌ | ❌ |
| Drugs | `GET /api/master-data/drugs` | ✅ | ✅ | ✅ | ✅ | ✅ |
| | `GET /api/master-data/drugs/:id` | ✅ | ✅ | ✅ | ✅ | ✅ |
| | `POST /api/master-data/drugs` | ✅ | ❌ | ✅ | ❌ | ❌ |
| | `PUT /api/master-data/drugs/:id` | ✅ | ❌ | ✅ | ❌ | ❌ |
| | `DELETE /api/master-data/drugs/:id` | ✅ | ❌ | ❌ | ❌ | ❌ |
| Companies | `GET /api/master-data/companies` | ✅ | ✅ | ✅ | ❌ | ❌ |
| | `POST /api/master-data/companies` | ✅ | ❌ | ✅ | ❌ | ❌ |
| | `PUT /api/master-data/companies/:id` | ✅ | ❌ | ✅ | ❌ | ❌ |
| **Drug Information Support** |
| Drug Components | `GET /api/master-data/drug-components` | ✅ | ✅ | ✅ | ✅ | ❌ |
| | `POST /api/master-data/drug-components` | ✅ | ❌ | ✅ | ❌ | ❌ |
| Drug Focus Lists | `GET /api/master-data/drug-focus-lists` | ✅ | ✅ | ✅ | ✅ | ❌ |
| | `POST /api/master-data/drug-focus-lists` | ✅ | ❌ | ✅ | ❌ | ❌ |
| Drug Pack Ratios | `GET /api/master-data/drug-pack-ratios` | ✅ | ✅ | ✅ | ❌ | ❌ |
| | `POST /api/master-data/drug-pack-ratios` | ✅ | ❌ | ✅ | ❌ | ❌ |
| **Lookup Tables** (Mostly Read-Only) |
| Dosage Forms | `GET /api/master-data/dosage-forms` | ✅ | ✅ | ✅ | ✅ | ✅ |
| | `POST /api/master-data/dosage-forms` | ✅ | ❌ | ❌ | ❌ | ❌ |
| Drug Units | `GET /api/master-data/drug-units` | ✅ | ✅ | ✅ | ✅ | ✅ |
| | `POST /api/master-data/drug-units` | ✅ | ❌ | ❌ | ❌ | ❌ |
| Adjustment Reasons | `GET /api/master-data/adjustment-reasons` | ✅ | ✅ | ✅ | ✅ | ✅ |
| | `POST /api/master-data/adjustment-reasons` | ✅ | ❌ | ❌ | ❌ | ❌ |
| Return Actions | `GET /api/master-data/return-actions` | ✅ | ✅ | ✅ | ✅ | ✅ |
| | `POST /api/master-data/return-actions` | ✅ | ❌ | ❌ | ❌ | ❌ |

**Legend:**
- ✅ = Full Access
- ❌ = No Access
- "Own" = Can only edit their own department's data

### Implementation Notes

**1. Soft Delete Pattern:**
```typescript
// All master data uses soft delete
async function softDelete(req, res) {
  const { id } = req.params;

  // Don't physically delete - just mark inactive
  await prisma.drug.update({
    where: { id: BigInt(id) },
    data: {
      isActive: false,
      updatedAt: new Date()
    }
  });

  return res.json({
    success: true,
    message: "Drug deactivated successfully"
  });
}
```

**2. Code Uniqueness Validation:**
```typescript
// Check uniqueness before creating
async function validateUniqueCode(model: string, codeField: string, codeValue: string) {
  const existing = await prisma[model].findFirst({
    where: { [codeField]: codeValue }
  });

  if (existing) {
    throw new ConflictError('DUPLICATE_CODE', `${codeField} already exists: ${codeValue}`);
  }
}
```

**3. Ministry Compliance Fields (v2.2.0):**
```typescript
// When creating/updating drugs, ensure ministry fields are included
const drugData = {
  // ... other fields
  nlem_status: 'E',        // E or N
  drug_status: 1,          // 1-4
  product_category: 1,     // 1-5
  status_changed_date: new Date()
};
```

---

## 📊 API Development Priority

### Phase 1: Lookup Tables - Must Have First (Week 1) ⭐

**Why:** These are referenced by other entities (drugs, generics, inventory)

| Priority | Endpoint | Method | Purpose | Records |
|----------|----------|--------|---------|---------|
| 1 | `/api/master-data/dosage-forms` | GET | List dosage forms (TAB, CAP, INJ, etc.) | 107 |
| 2 | `/api/master-data/drug-units` | GET | List drug units (mg, ml, unit, IU, etc.) | 88 |
| 3 | `/api/master-data/adjustment-reasons` | GET | List stock adjustment reasons | 10 |
| 4 | `/api/master-data/return-actions` | GET | List drug return actions | 8 |
| 5 | `/api/master-data/dosage-forms` | POST | Create dosage form (admin only) | - |
| 6 | `/api/master-data/drug-units` | POST | Create drug unit (admin only) | - |

**Development Order:**
```
1. Implement GET endpoints for all 4 lookup tables (read-only)
2. Add simple pagination (limit/offset)
3. Add search by name
4. Test with existing 213 records
5. Implement POST for admin (optional, low priority)
```

---

### Phase 2: Foundation Data (Week 1-2)

**Why:** Required before drugs can be created

| Priority | Entity | Endpoints | Purpose |
|----------|--------|-----------|---------|
| 7 | Companies | GET, POST, PUT | Manufacturers & vendors (57 records) |
| 8 | Locations | GET, POST, PUT, DELETE | Storage locations (5 records) |
| 9 | Departments | GET, POST, PUT, DELETE | Hospital departments (5 records) |
| 10 | Banks | GET, POST, PUT | Bank information for payments (5 records) |

**Key Features:**
- Full CRUD operations
- Search by code or name
- Filter by type (e.g., manufacturer vs vendor)
- Soft delete (mark isActive = false)

---

### Phase 3: Budget Structure (Week 2)

**Why:** Required for budget management system

| Priority | Entity | Endpoints | Purpose |
|----------|--------|-----------|---------|
| 11 | Budget Types | GET, POST, PUT | Budget types (6 records: OP, INV, EM) |
| 12 | Budget Categories | GET, POST, PUT | Budget categories (5 records) |
| 13 | Budgets | GET, POST, PUT | Budget combinations (type + category) |

---

### Phase 4: Drug Master Data (Week 2-3) ⭐

**Why:** Core data for inventory and procurement

| Priority | Entity | Endpoints | Purpose | Records |
|----------|--------|-----------|---------|---------|
| 14 | Drug Generics | GET, GET/:id, POST, PUT, DELETE | Generic drugs | 1,109 |
| 15 | Drugs | GET, GET/:id, POST, PUT, DELETE | Trade drugs | 1,169 |

**Critical Endpoints:**
```typescript
// Drug Generic CRUD
GET    /api/master-data/generics              // List with pagination
GET    /api/master-data/generics/:id          // Get single with relations
POST   /api/master-data/generics              // Create new generic
PUT    /api/master-data/generics/:id          // Update generic
DELETE /api/master-data/generics/:id          // Soft delete

// Drug (Trade) CRUD
GET    /api/master-data/drugs                 // List with pagination
GET    /api/master-data/drugs/:id             // Get single with relations
POST   /api/master-data/drugs                 // Create new drug
PUT    /api/master-data/drugs/:id             // Update drug
DELETE /api/master-data/drugs/:id             // Soft delete

// Search & Filter
GET    /api/master-data/generics/search?q=paracetamol
GET    /api/master-data/drugs/search?q=tylenol
GET    /api/master-data/drugs?genericId=101
GET    /api/master-data/drugs?manufacturerId=5
```

---

### Phase 5: Drug Information Support (Week 3-4)

**Why:** Supporting data for advanced features

| Priority | Entity | Endpoints | Purpose | Records |
|----------|--------|-----------|---------|---------|
| 16 | Drug Components | GET, POST, PUT | API/ingredients for allergy check | 736 |
| 17 | Drug Focus Lists | GET, POST, PUT | Special control lists | 92 |
| 18 | Drug Pack Ratios | GET, POST, PUT | Vendor-specific pack ratios | 1,641 |

---

### Phase 6: Advanced Features (Week 4+)

| Priority | Feature | Endpoints | Purpose |
|----------|---------|-----------|---------|
| 19 | Bulk Import | POST /api/master-data/drugs/bulk-import | Import CSV/Excel |
| 20 | Export | GET /api/master-data/drugs/export | Export to CSV/Excel |
| 21 | Audit Log | GET /api/master-data/audit-logs | Track changes |
| 22 | Ministry Export | GET /api/master-data/ministry-export | DRUGLIST export (11 fields) |

---

## 🚨 Error Handling Standards

### Standard Response Format

**Success Response:**
```typescript
{
  success: true,
  data: {
    // Response data here
  },
  meta?: {
    pagination?: {
      page: number,
      limit: number,
      total: number,
      totalPages: number
    },
    timestamp: string,
    request_id: string
  }
}
```

**Error Response:**
```typescript
{
  success: false,
  error: {
    code: string,           // Error code (see list below)
    message: string,        // Thai error message for UI
    message_en?: string,    // Optional English message
    details?: object,       // Optional additional details
    field?: string          // Optional field name for validation errors
  },
  meta?: {
    timestamp: string,
    request_id: string
  }
}
```

---

### Error Codes

#### **Master Data CRUD Errors**

| Code | HTTP Status | Thai Message | English Message | When to Use |
|------|-------------|--------------|-----------------|-------------|
| `DUPLICATE_CODE` | 409 | รหัสนี้มีในระบบแล้ว | Code already exists | Creating entity with duplicate code |
| `ENTITY_NOT_FOUND` | 404 | ไม่พบข้อมูล | Entity not found | Entity ID doesn't exist |
| `CANNOT_DELETE_IN_USE` | 400 | ไม่สามารถลบข้อมูลที่ถูกใช้งานอยู่ | Cannot delete entity in use | Deleting entity with FK references |
| `INACTIVE_ENTITY` | 400 | ข้อมูลนี้ถูกระงับการใช้งานแล้ว | Entity is inactive | Using inactive entity |

**Example Error Response:**
```typescript
{
  success: false,
  error: {
    code: "DUPLICATE_CODE",
    message: "รหัสยา PARA500 มีในระบบแล้ว",
    message_en: "Drug code PARA500 already exists",
    details: {
      field: "drug_code",
      value: "PARA500",
      existing_id: 123
    }
  }
}
```

---

#### **Drug-Specific Errors**

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `GENERIC_NOT_FOUND` | 404 | ไม่พบข้อมูลยาสามัญ | Generic ID doesn't exist |
| `MANUFACTURER_NOT_FOUND` | 404 | ไม่พบข้อมูลผู้ผลิต | Manufacturer ID doesn't exist |
| `INVALID_DOSAGE_FORM` | 400 | รูปแบบยาไม่ถูกต้อง | Invalid dosage form code |
| `INVALID_DRUG_UNIT` | 400 | หน่วยยาไม่ถูกต้อง | Invalid drug unit code |
| `INVALID_NLEM_STATUS` | 400 | สถานะ NLEM ต้องเป็น E หรือ N | Invalid NLEM status (must be E or N) |
| `INVALID_DRUG_STATUS` | 400 | สถานะยาต้องเป็น 1-4 | Invalid drug status (must be 1-4) |
| `INVALID_PRODUCT_CATEGORY` | 400 | ประเภทผลิตภัณฑ์ต้องเป็น 1-5 | Invalid product category (must be 1-5) |

---

#### **Validation Errors**

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `VALIDATION_ERROR` | 400 | ข้อมูลไม่ถูกต้อง | General validation failure |
| `REQUIRED_FIELD` | 400 | กรุณากรอก {field} | Required field missing |
| `INVALID_FORMAT` | 400 | รูปแบบ {field} ไม่ถูกต้อง | Wrong format (e.g., date, number) |
| `CODE_FORMAT_ERROR` | 400 | รหัส {field} ต้องมี {length} ตัวอักษร | Code length mismatch |

**Example Validation Error:**
```typescript
{
  success: false,
  error: {
    code: "VALIDATION_ERROR",
    message: "ข้อมูลไม่ถูกต้อง",
    details: {
      errors: [
        {
          field: "working_code",
          code: "CODE_FORMAT_ERROR",
          message: "รหัสยาสามัญต้องมี 7 ตัวอักษร"
        },
        {
          field: "generic_name",
          code: "REQUIRED_FIELD",
          message: "กรุณากรอกชื่อยาสามัญ"
        },
        {
          field: "nlem_status",
          code: "INVALID_NLEM_STATUS",
          message: "สถานะ NLEM ต้องเป็น E หรือ N"
        }
      ]
    }
  }
}
```

---

#### **Import/Export Errors**

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `IMPORT_FILE_ERROR` | 400 | ไฟล์ไม่ถูกต้อง | Invalid file format |
| `IMPORT_VALIDATION_ERROR` | 400 | พบข้อผิดพลาดในแถวที่ {row} | Validation error in specific row |
| `PARTIAL_IMPORT_SUCCESS` | 207 | นำเข้าสำเร็จบางส่วน | Some rows imported, some failed |

---

## 📝 Request/Response Examples

### 1. List Drug Generics (with Pagination & Search)

**Endpoint:** `GET /api/master-data/generics`

**Query Parameters:**
```typescript
{
  page?: number,           // Default: 1
  limit?: number,          // Default: 20
  search?: string,         // Search by working_code or generic_name
  isActive?: boolean,      // Filter by active status
  sortBy?: string,         // Sort field (default: working_code)
  sortOrder?: 'asc' | 'desc'  // Sort direction (default: asc)
}
```

**Example Request:**
```
GET /api/master-data/generics?page=1&limit=20&search=para&isActive=true
```

**Success Response:**
```typescript
{
  success: true,
  data: [
    {
      id: 101,
      working_code: "0001001",
      generic_name: "Paracetamol 500mg TAB",
      generic_name_en: "Paracetamol 500mg Tablet",
      strength: "500mg",
      dosage_form_id: 1,
      primary_unit_id: 10,
      is_active: true,
      created_at: "2025-01-15T10:00:00Z",
      updated_at: "2025-01-15T10:00:00Z",

      // Relations
      dosage_form: {
        form_code: "TAB",
        form_name: "เม็ด",
        form_name_en: "Tablet"
      },
      primary_unit: {
        unit_code: "TAB",
        unit_name: "เม็ด",
        unit_name_en: "Tablet"
      }
    },
    // ... more items
  ],
  meta: {
    pagination: {
      page: 1,
      limit: 20,
      total: 1109,
      totalPages: 56
    },
    timestamp: "2025-01-28T10:30:00Z",
    request_id: "req_abc123"
  }
}
```

---

### 2. Get Single Drug Generic (with Relations)

**Endpoint:** `GET /api/master-data/generics/:id`

**Example Request:**
```
GET /api/master-data/generics/101
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 101,
    working_code: "0001001",
    generic_name: "Paracetamol 500mg TAB",
    generic_name_en: "Paracetamol 500mg Tablet",
    strength: "500mg",
    dosage_form_id: 1,
    primary_unit_id: 10,
    is_active: true,
    created_at: "2025-01-15T10:00:00Z",
    updated_at: "2025-01-15T10:00:00Z",

    // Relations
    dosage_form: {
      id: 1,
      form_code: "TAB",
      form_name: "เม็ด",
      form_name_en: "Tablet"
    },
    primary_unit: {
      id: 10,
      unit_code: "TAB",
      unit_name: "เม็ด",
      unit_name_en: "Tablet"
    },

    // Related drugs (trade drugs based on this generic)
    drugs: [
      {
        id: 201,
        drug_code: "PARA500TAB001",
        trade_name: "Tylenol 500mg",
        manufacturer_id: 5,
        manufacturer: {
          company_name: "Johnson & Johnson"
        }
      },
      {
        id: 202,
        drug_code: "PARA500TAB002",
        trade_name: "Sara 500mg",
        manufacturer_id: 3
      }
    ],

    // Statistics
    _count: {
      drugs: 25  // Total trade drugs based on this generic
    }
  }
}
```

**Error Response (Not Found):**
```typescript
{
  success: false,
  error: {
    code: "ENTITY_NOT_FOUND",
    message: "ไม่พบข้อมูลยาสามัญ",
    message_en: "Drug generic not found",
    details: {
      id: 999,
      entity: "drug_generic"
    }
  }
}
```

---

### 3. Create Drug Generic

**Endpoint:** `POST /api/master-data/generics`

**Request:**
```typescript
{
  working_code: "0001050",
  generic_name: "Ibuprofen 400mg TAB",
  generic_name_en: "Ibuprofen 400mg Tablet",
  strength: "400mg",
  dosage_form_id: 1,        // TAB
  primary_unit_id: 10,      // Tablet
  is_active: true
}
```

**Validation:**
```typescript
// Server-side validation
async function validateGenericCreate(data) {
  // Check working_code format (must be 7 chars)
  if (data.working_code.length !== 7) {
    throw new ValidationError('CODE_FORMAT_ERROR', 'Working code must be 7 characters');
  }

  // Check uniqueness
  const existing = await prisma.drugGeneric.findUnique({
    where: { workingCode: data.working_code }
  });
  if (existing) {
    throw new ConflictError('DUPLICATE_CODE', 'Working code already exists');
  }

  // Validate foreign keys
  const dosageForm = await prisma.dosageForm.findUnique({
    where: { id: data.dosage_form_id }
  });
  if (!dosageForm) {
    throw new ValidationError('INVALID_DOSAGE_FORM');
  }

  const unit = await prisma.drugUnit.findUnique({
    where: { id: data.primary_unit_id }
  });
  if (!unit) {
    throw new ValidationError('INVALID_DRUG_UNIT');
  }
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 1110,
    working_code: "0001050",
    generic_name: "Ibuprofen 400mg TAB",
    generic_name_en: "Ibuprofen 400mg Tablet",
    strength: "400mg",
    dosage_form_id: 1,
    primary_unit_id: 10,
    is_active: true,
    created_at: "2025-01-28T10:30:00Z",
    updated_at: "2025-01-28T10:30:00Z",

    dosage_form: {
      form_code: "TAB",
      form_name: "เม็ด"
    },
    primary_unit: {
      unit_code: "TAB",
      unit_name: "เม็ด"
    }
  },
  message: "สร้างยาสามัญสำเร็จ"
}
```

---

### 4. Create Drug (Trade Drug)

**Endpoint:** `POST /api/master-data/drugs`

**Request:**
```typescript
{
  drug_code: "TYLENOL500TAB001",
  trade_name: "Tylenol 500mg",
  trade_name_en: "Tylenol 500mg Tablet",
  generic_id: 101,
  manufacturer_id: 5,
  dosage_form_id: 1,
  primary_unit_id: 10,
  strength: "500mg",

  // Ministry compliance fields (v2.2.0)
  nlem_status: "E",           // E = ในบัญชียาหลัก, N = นอกบัญชี
  drug_status: 1,             // 1 = ใช้งาน
  product_category: 1,        // 1 = ยาสมัยใหม่ ทะเบียนตำรับ
  status_changed_date: "2025-01-28",

  // Optional fields
  unit_price: 2.50,
  package_size: "10x10",
  storage_condition: "Room temperature",
  is_active: true
}
```

**Validation:**
```typescript
// Validate ministry compliance fields
function validateMinistryFields(data) {
  if (!['E', 'N'].includes(data.nlem_status)) {
    throw new ValidationError('INVALID_NLEM_STATUS');
  }

  if (![1, 2, 3, 4].includes(data.drug_status)) {
    throw new ValidationError('INVALID_DRUG_STATUS');
  }

  if (![1, 2, 3, 4, 5].includes(data.product_category)) {
    throw new ValidationError('INVALID_PRODUCT_CATEGORY');
  }
}

// Validate foreign keys
async function validateDrugReferences(data) {
  const generic = await prisma.drugGeneric.findUnique({
    where: { id: data.generic_id }
  });
  if (!generic) {
    throw new ValidationError('GENERIC_NOT_FOUND');
  }

  const manufacturer = await prisma.company.findUnique({
    where: { id: data.manufacturer_id }
  });
  if (!manufacturer || !manufacturer.is_manufacturer) {
    throw new ValidationError('MANUFACTURER_NOT_FOUND');
  }
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 1170,
    drug_code: "TYLENOL500TAB001",
    trade_name: "Tylenol 500mg",
    trade_name_en: "Tylenol 500mg Tablet",
    generic_id: 101,
    manufacturer_id: 5,
    dosage_form_id: 1,
    primary_unit_id: 10,
    strength: "500mg",
    nlem_status: "E",
    drug_status: 1,
    product_category: 1,
    status_changed_date: "2025-01-28T00:00:00Z",
    unit_price: 2.50,
    package_size: "10x10",
    storage_condition: "Room temperature",
    is_active: true,
    created_at: "2025-01-28T10:30:00Z",
    updated_at: "2025-01-28T10:30:00Z",

    // Relations
    generic: {
      working_code: "0001001",
      generic_name: "Paracetamol 500mg TAB"
    },
    manufacturer: {
      company_code: "MFG005",
      company_name: "Johnson & Johnson"
    },
    dosage_form: {
      form_code: "TAB",
      form_name: "เม็ด"
    },
    primary_unit: {
      unit_code: "TAB",
      unit_name: "เม็ด"
    }
  },
  message: "สร้างยาการค้าสำเร็จ"
}
```

---

### 5. Update Drug (Soft Fields Only)

**Endpoint:** `PUT /api/master-data/drugs/:id`

**Request:**
```typescript
{
  // Can update these fields
  unit_price: 2.75,
  storage_condition: "Keep in cool place",
  drug_status: 2,           // Changed to "ตัดแต่มีเหลือ"
  status_changed_date: "2025-01-28",

  // Cannot update these fields (immutable)
  // drug_code: "...",      // ❌ Immutable
  // generic_id: 102,       // ❌ Immutable
  // manufacturer_id: 6     // ❌ Immutable
}
```

**Business Rules:**
```typescript
// Immutable fields (cannot be updated after creation)
const IMMUTABLE_FIELDS = [
  'drug_code',
  'generic_id',
  'manufacturer_id',
  'dosage_form_id',
  'primary_unit_id'
];

// Soft fields (can be updated)
const UPDATABLE_FIELDS = [
  'trade_name',
  'trade_name_en',
  'strength',
  'nlem_status',
  'drug_status',
  'product_category',
  'status_changed_date',
  'unit_price',
  'package_size',
  'storage_condition'
];
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 1170,
    drug_code: "TYLENOL500TAB001",
    // ... all fields
    unit_price: 2.75,        // Updated
    drug_status: 2,          // Updated
    status_changed_date: "2025-01-28T00:00:00Z",  // Updated
    updated_at: "2025-01-28T11:00:00Z"
  },
  message: "แก้ไขข้อมูลยาสำเร็จ"
}
```

---

### 6. Soft Delete Drug

**Endpoint:** `DELETE /api/master-data/drugs/:id`

**Request:** (No body required)

**Validation:**
```typescript
// Check if drug is in use
async function validateDrugDeletion(drugId) {
  // Check if drug has inventory
  const inventory = await prisma.inventory.count({
    where: { drug_id: drugId }
  });

  if (inventory > 0) {
    throw new ConflictError('CANNOT_DELETE_IN_USE', 'Drug has inventory records');
  }

  // Check if drug has pending orders
  const orders = await prisma.purchaseOrderItem.count({
    where: {
      drug_id: drugId,
      purchaseOrder: {
        status: { in: ['PENDING', 'APPROVED'] }
      }
    }
  });

  if (orders > 0) {
    throw new ConflictError('CANNOT_DELETE_IN_USE', 'Drug has pending orders');
  }
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 1170,
    is_active: false,
    updated_at: "2025-01-28T11:30:00Z"
  },
  message: "ระงับการใช้งานยาสำเร็จ"
}
```

**Error Response (In Use):**
```typescript
{
  success: false,
  error: {
    code: "CANNOT_DELETE_IN_USE",
    message: "ไม่สามารถลบยาที่มีข้อมูลสต็อกในระบบ",
    message_en: "Cannot delete drug with inventory records",
    details: {
      drug_id: 1170,
      inventory_count: 5,
      locations: ["WH001", "PHAR001"]
    }
  }
}
```

---

### 7. Search Drugs (Advanced)

**Endpoint:** `GET /api/master-data/drugs/search`

**Query Parameters:**
```typescript
{
  q: string,                    // Search term (drug_code, trade_name, generic_name)
  genericId?: number,           // Filter by generic
  manufacturerId?: number,      // Filter by manufacturer
  dosageFormId?: number,        // Filter by dosage form
  nlemStatus?: 'E' | 'N',      // Filter by NLEM status
  drugStatus?: 1 | 2 | 3 | 4,  // Filter by drug status
  isActive?: boolean,           // Filter by active status
  minPrice?: number,            // Filter by price range
  maxPrice?: number,
  page?: number,
  limit?: number
}
```

**Example Request:**
```
GET /api/master-data/drugs/search?q=para&nlemStatus=E&isActive=true&page=1&limit=20
```

**Success Response:**
```typescript
{
  success: true,
  data: [
    {
      id: 201,
      drug_code: "PARA500TAB001",
      trade_name: "Tylenol 500mg",
      generic: {
        working_code: "0001001",
        generic_name: "Paracetamol 500mg TAB"
      },
      manufacturer: {
        company_name: "Johnson & Johnson"
      },
      nlem_status: "E",
      drug_status: 1,
      unit_price: 2.50,
      is_active: true
    },
    // ... more results
  ],
  meta: {
    pagination: {
      page: 1,
      limit: 20,
      total: 45,
      totalPages: 3
    },
    filters: {
      search_term: "para",
      nlem_status: "E",
      is_active: true
    }
  }
}
```

---

## ⚙️ Environment Configuration

**Required Environment Variables:**

```env
# Master Data Configuration
MASTER_DATA_CODE_PREFIX_GENERIC=00         # Prefix for generic working_code
MASTER_DATA_CODE_PREFIX_DRUG=DR            # Prefix for drug_code (optional)
MASTER_DATA_ALLOW_DELETE_IN_USE=false      # Allow deleting entities with FK references
MASTER_DATA_SOFT_DELETE=true               # Use soft delete (is_active flag)

# Pagination Defaults
MASTER_DATA_PAGE_SIZE_DEFAULT=20           # Default page size
MASTER_DATA_PAGE_SIZE_MAX=100              # Maximum page size

# Search Configuration
MASTER_DATA_SEARCH_MIN_LENGTH=2            # Minimum search term length
MASTER_DATA_SEARCH_FUZZY_MATCH=true        # Enable fuzzy matching

# Import/Export
MASTER_DATA_IMPORT_BATCH_SIZE=100          # Batch size for bulk import
MASTER_DATA_IMPORT_MAX_FILE_SIZE=10        # Max file size in MB
MASTER_DATA_EXPORT_MAX_RECORDS=10000       # Max records for export

# Ministry Compliance
MASTER_DATA_ENFORCE_MINISTRY_FIELDS=true   # Require ministry compliance fields
MASTER_DATA_DEFAULT_NLEM_STATUS=N          # Default NLEM status for new drugs
MASTER_DATA_DEFAULT_DRUG_STATUS=1          # Default drug status
MASTER_DATA_DEFAULT_PRODUCT_CATEGORY=1     # Default product category
```

**Usage in Code:**
```typescript
// config/master-data.config.ts
export const masterDataConfig = {
  codes: {
    genericPrefix: process.env.MASTER_DATA_CODE_PREFIX_GENERIC || '00',
    drugPrefix: process.env.MASTER_DATA_CODE_PREFIX_DRUG || 'DR'
  },

  allowDeleteInUse: process.env.MASTER_DATA_ALLOW_DELETE_IN_USE === 'true',
  softDelete: process.env.MASTER_DATA_SOFT_DELETE !== 'false', // Default true

  pagination: {
    defaultSize: parseInt(process.env.MASTER_DATA_PAGE_SIZE_DEFAULT || '20'),
    maxSize: parseInt(process.env.MASTER_DATA_PAGE_SIZE_MAX || '100')
  },

  search: {
    minLength: parseInt(process.env.MASTER_DATA_SEARCH_MIN_LENGTH || '2'),
    fuzzyMatch: process.env.MASTER_DATA_SEARCH_FUZZY_MATCH !== 'false'
  },

  imports: {
    batchSize: parseInt(process.env.MASTER_DATA_IMPORT_BATCH_SIZE || '100'),
    maxFileSize: parseInt(process.env.MASTER_DATA_IMPORT_MAX_FILE_SIZE || '10') * 1024 * 1024, // MB to bytes
    maxRecords: parseInt(process.env.MASTER_DATA_EXPORT_MAX_RECORDS || '10000')
  },

  ministry: {
    enforceFields: process.env.MASTER_DATA_ENFORCE_MINISTRY_FIELDS === 'true',
    defaultNlemStatus: process.env.MASTER_DATA_DEFAULT_NLEM_STATUS || 'N',
    defaultDrugStatus: parseInt(process.env.MASTER_DATA_DEFAULT_DRUG_STATUS || '1'),
    defaultProductCategory: parseInt(process.env.MASTER_DATA_DEFAULT_PRODUCT_CATEGORY || '1')
  }
};
```

---

## 🧪 Testing Guidelines

### Unit Tests

**Test CRUD Operations:**
```typescript
describe('Drug Generic CRUD', () => {
  it('should create drug generic with valid data', async () => {
    const data = {
      working_code: '0001999',
      generic_name: 'Test Drug 999mg TAB',
      generic_name_en: 'Test Drug 999mg Tablet',
      strength: '999mg',
      dosage_form_id: 1,
      primary_unit_id: 10,
      is_active: true
    };

    const result = await prisma.drugGeneric.create({ data });

    expect(result.id).toBeDefined();
    expect(result.working_code).toBe('0001999');
    expect(result.is_active).toBe(true);
  });

  it('should reject duplicate working_code', async () => {
    const data = {
      working_code: '0001001',  // Already exists
      generic_name: 'Duplicate Drug',
      // ... other fields
    };

    await expect(
      prisma.drugGeneric.create({ data })
    ).rejects.toThrow('Unique constraint violation');
  });

  it('should soft delete drug generic', async () => {
    const generic = await prisma.drugGeneric.create({
      data: {
        working_code: '0009999',
        generic_name: 'Temp Drug',
        // ... other fields
      }
    });

    // Soft delete
    await prisma.drugGeneric.update({
      where: { id: generic.id },
      data: { is_active: false }
    });

    const result = await prisma.drugGeneric.findUnique({
      where: { id: generic.id }
    });

    expect(result.is_active).toBe(false);
  });
});
```

---

### Integration Tests

**Test Full Drug Creation Workflow:**
```typescript
describe('Drug Creation Workflow', () => {
  let dosageForm, drugUnit, company, generic;

  beforeAll(async () => {
    // Setup prerequisites
    dosageForm = await prisma.dosageForm.create({
      data: { form_code: 'TEST', form_name: 'Test Form' }
    });

    drugUnit = await prisma.drugUnit.create({
      data: { unit_code: 'TEST', unit_name: 'Test Unit' }
    });

    company = await prisma.company.create({
      data: {
        company_code: 'TEST001',
        company_name: 'Test Company',
        is_manufacturer: true
      }
    });

    generic = await prisma.drugGeneric.create({
      data: {
        working_code: '9999999',
        generic_name: 'Test Generic 100mg',
        dosage_form_id: dosageForm.id,
        primary_unit_id: drugUnit.id
      }
    });
  });

  it('should create drug with all valid references', async () => {
    const response = await request(app)
      .post('/api/master-data/drugs')
      .send({
        drug_code: 'TEST100TAB001',
        trade_name: 'Test Drug 100mg',
        generic_id: generic.id,
        manufacturer_id: company.id,
        dosage_form_id: dosageForm.id,
        primary_unit_id: drugUnit.id,
        nlem_status: 'N',
        drug_status: 1,
        product_category: 1
      });

    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
    expect(response.body.data.id).toBeDefined();
    expect(response.body.data.drug_code).toBe('TEST100TAB001');
  });

  it('should reject drug with invalid generic_id', async () => {
    const response = await request(app)
      .post('/api/master-data/drugs')
      .send({
        drug_code: 'TEST200TAB001',
        trade_name: 'Test Drug 200mg',
        generic_id: 999999,  // Invalid
        manufacturer_id: company.id,
        dosage_form_id: dosageForm.id,
        primary_unit_id: drugUnit.id
      });

    expect(response.status).toBe(404);
    expect(response.body.success).toBe(false);
    expect(response.body.error.code).toBe('GENERIC_NOT_FOUND');
  });

  afterAll(async () => {
    // Cleanup
    await prisma.drug.deleteMany({ where: { generic_id: generic.id } });
    await prisma.drugGeneric.delete({ where: { id: generic.id } });
    await prisma.company.delete({ where: { id: company.id } });
    await prisma.dosageForm.delete({ where: { id: dosageForm.id } });
    await prisma.drugUnit.delete({ where: { id: drugUnit.id } });
  });
});
```

---

### Performance Tests

**Test Pagination Performance:**
```typescript
describe('Master Data Performance', () => {
  it('should list drugs with pagination in < 200ms', async () => {
    const start = Date.now();

    const response = await request(app)
      .get('/api/master-data/drugs?page=1&limit=20');

    const duration = Date.now() - start;

    expect(response.status).toBe(200);
    expect(duration).toBeLessThan(200);
  });

  it('should search drugs in < 300ms', async () => {
    const start = Date.now();

    const response = await request(app)
      .get('/api/master-data/drugs/search?q=para');

    const duration = Date.now() - start;

    expect(response.status).toBe(200);
    expect(duration).toBeLessThan(300);
  });

  it('should handle concurrent reads (100 requests)', async () => {
    const promises = Array(100).fill(null).map(() =>
      request(app).get('/api/master-data/drugs?page=1&limit=10')
    );

    const results = await Promise.all(promises);

    expect(results.every(r => r.status === 200)).toBe(true);
  });
});
```

---

### Ministry Compliance Tests

**Test DMSIC Standards Fields:**
```typescript
describe('Ministry Compliance (v2.2.0)', () => {
  it('should create drug with ministry fields', async () => {
    const response = await request(app)
      .post('/api/master-data/drugs')
      .send({
        drug_code: 'MINISTRY001',
        trade_name: 'Ministry Test Drug',
        generic_id: 101,
        manufacturer_id: 5,
        nlem_status: 'E',
        drug_status: 1,
        product_category: 1,
        status_changed_date: '2025-01-28'
      });

    expect(response.status).toBe(200);
    expect(response.body.data.nlem_status).toBe('E');
    expect(response.body.data.drug_status).toBe(1);
    expect(response.body.data.product_category).toBe(1);
  });

  it('should reject invalid NLEM status', async () => {
    const response = await request(app)
      .post('/api/master-data/drugs')
      .send({
        // ... other fields
        nlem_status: 'X',  // Invalid (must be E or N)
      });

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe('INVALID_NLEM_STATUS');
  });

  it('should reject invalid drug status', async () => {
    const response = await request(app)
      .post('/api/master-data/drugs')
      .send({
        // ... other fields
        drug_status: 5,  // Invalid (must be 1-4)
      });

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe('INVALID_DRUG_STATUS');
  });

  it('should export ministry-compliant DRUGLIST', async () => {
    const response = await request(app)
      .get('/api/master-data/ministry-export?type=DRUGLIST');

    expect(response.status).toBe(200);

    const data = response.body.data[0];
    expect(data).toHaveProperty('tmtid');
    expect(data).toHaveProperty('drugcode');
    expect(data).toHaveProperty('drugname');
    expect(data).toHaveProperty('nlem');
    expect(data).toHaveProperty('status');
    // ... expect all 11 required fields
  });
});
```

---

## 📚 Additional Resources

### Related Documentation
- **[README.md](README.md)** - System overview
- **[SCHEMA.md](SCHEMA.md)** - Database schema (16 tables)
- **[WORKFLOWS.md](WORKFLOWS.md)** - CRUD, Bulk Import, Search workflows
- **[../../SYSTEM_ARCHITECTURE.md](../../SYSTEM_ARCHITECTURE.md)** - Complete system architecture

### Database Schema Reference
- `prisma/schema.prisma` - Full schema definition
- `prisma/seed.ts` - Seed data script (81,353 records)

### Migration Reports
- `docs/migration-reports/phase1-4-summary.md` - Drug master migration
- `docs/migration-reports/phase5-lookup-tables.md` - Lookup tables migration

---

## 🎯 Quick Start for Developers

### Phase 1: Start Here (Day 1)

1. ✅ **Setup & Verify Data**
```bash
npm run db:studio  # Browse 81,353 migrated records
```

2. ✅ **Implement Read-Only Endpoints**
```typescript
// Start with lookup tables (simplest)
GET /api/master-data/dosage-forms
GET /api/master-data/drug-units
GET /api/master-data/adjustment-reasons
GET /api/master-data/return-actions
```

3. ✅ **Test with Existing Data**
```bash
curl http://localhost:3000/api/master-data/dosage-forms
# Should return 107 records
```

### Phase 2: CRUD Operations (Week 1)

4. ✅ **Implement Drug Generic CRUD**
```typescript
GET    /api/master-data/generics
GET    /api/master-data/generics/:id
POST   /api/master-data/generics
PUT    /api/master-data/generics/:id
DELETE /api/master-data/generics/:id
```

5. ✅ **Implement Drug CRUD**
```typescript
GET    /api/master-data/drugs
GET    /api/master-data/drugs/:id
POST   /api/master-data/drugs
PUT    /api/master-data/drugs/:id
DELETE /api/master-data/drugs/:id
```

### Phase 3: Testing (Week 1-2)

6. ✅ **Write Tests**
- Unit tests for CRUD operations
- Integration tests for workflows
- Ministry compliance tests

### Phase 4: Advanced Features (Week 2+)

7. ✅ **Search & Filter**
8. ✅ **Bulk Import/Export**
9. ✅ **Ministry Export (DRUGLIST)**

---

**Ready to Start?**

All 81,353 records are migrated and ready to use. Start with Phase 1 (read-only endpoints) and test with real data immediately!

---

**Last Updated:** 2025-01-28 | **Version:** 2.6.0
**Built with ❤️ for INVS Modern Team**
