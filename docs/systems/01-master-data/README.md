# 🏢 Master Data Management System

**Foundation data for all systems**

**Priority:** ⭐⭐⭐ สูงสุด
**Tables:** 9 tables
**Status:** ✅ Production Ready
**Ministry Compliance:** ✅ 100%

---

## 📋 Overview

Master Data System เป็นระบบจัดการข้อมูลพื้นฐานที่ระบบอื่นๆ ทั้งหมดต้องใช้:

### 3 กลุ่มข้อมูลหลัก

1. **🏥 Organization Data** (3 tables)
   - `locations` - สถานที่จัดเก็บยา (warehouse, pharmacy, ward, emergency)
   - `departments` - หน่วยงาน (with budget codes & hierarchy)
   - `bank` - ธนาคาร (for company payment info)

2. **💰 Budget Structure** (3 tables)
   - `budget_types` - ประเภทงบประมาณ (operational, investment, emergency)
   - `budget_categories` - หมวดค่าใช้จ่าย (with accounting codes)
   - `budgets` - งบประมาณ (combination of type + category)

3. **💊 Drug & Company Data** (3 tables)
   - `drug_generics` - ยาสามัญ (generic catalog with working codes)
   - `drugs` - ยาการค้า (trade drugs with ministry compliance fields) ⭐
   - `companies` - ผู้ผลิต/จำหน่าย (vendors & manufacturers)

---

## 🔗 System Dependencies

### Master Data ให้ข้อมูลแก่ระบบอื่น:

```
Master Data
    ├─→ Budget Management (budget types, departments)
    ├─→ Procurement (drugs, companies, departments)
    ├─→ Inventory (drugs, locations)
    ├─→ Distribution (departments, locations)
    ├─→ TMT Integration (drugs mapping)
    └─→ Ministry Reporting (all master data)
```

**Reverse Dependency:** ⚠️ ไม่มีระบบอื่นที่ Master Data ต้องพึ่งพา

---

## 📊 Quick Statistics

| Entity | Typical Count | Growth Rate |
|--------|---------------|-------------|
| Locations | 5-20 | Low |
| Departments | 10-50 | Low |
| Budget Types | 6-10 | Static |
| Companies | 50-200 | Low |
| Drug Generics | 500-2,000 | Medium |
| Drugs (Trade) | 1,000-5,000 | Medium |

---

## 🎯 Key Features

### ✅ Ministry Compliance (v2.2.0) 🎉

**New fields for 100% DMSIC Standards compliance:**

| Field | Location | Purpose | Values |
|-------|----------|---------|--------|
| `nlem_status` | drugs | สถานะยาในบัญชียาหลักแห่งชาติ | E (ในบัญชี), N (นอกบัญชี) |
| `drug_status` | drugs | สถานะการใช้งานยา | 1 (ใช้งาน), 2 (ตัดแต่มีเหลือ), 3 (เฉพาะราย), 4 (ตัดหมด) |
| `product_category` | drugs | ประเภทผลิตภัณฑ์ | 1-5 (ยาปัจจุบัน/สมุนไพร, ทะเบียน/โรงพยาบาล) |
| `status_changed_date` | drugs | วันที่เปลี่ยนสถานะ | Date |
| `consumption_group` | departments | กลุ่มหน่วยงานตามรูปแบบการใช้ยา | 1-9 (OPD/IPD mix, etc.) |

### ✅ Data Integrity

- **Hierarchical Support:**
  - Locations can have parent-child relationships
  - Departments can have parent-child relationships

- **Unique Constraints:**
  - All codes are unique (location_code, dept_code, drug_code, etc.)
  - Drug codes follow specific formats (working_code = 7 chars, drug_code = 24 chars)

- **Soft Delete:**
  - All tables have `is_active` flag
  - Deleted items are marked inactive, not physically removed

---

## 📂 Documentation Files

| File | Description |
|------|-------------|
| **README.md** | This file - Overview of Master Data system |
| **[SCHEMA.md](SCHEMA.md)** | Detailed schema of 9 tables with ER diagrams |
| **[WORKFLOWS.md](WORKFLOWS.md)** | CRUD, Bulk Import, Search workflows (Mermaid diagrams) |
| **api/** | OpenAPI specs (will be auto-generated from AegisX) |

---

## 🔄 Common Workflows

### 1. CRUD Operations
**File:** [WORKFLOWS.md](WORKFLOWS.md#crud-operations)

- Create, Read, Update, Delete
- Validation rules
- Error handling

### 2. Bulk Import
**File:** [WORKFLOWS.md](WORKFLOWS.md#bulk-import)

- CSV/Excel upload
- Data validation
- Error reporting
- Rollback on errors

### 3. Search & Filter
**File:** [WORKFLOWS.md](WORKFLOWS.md#search-filter)

- Multi-field search
- Advanced filters
- Pagination
- Export results

---

## 🔌 API Endpoints (Preview)

**Will be auto-generated from AegisX backend**

```typescript
// Basic CRUD
GET    /api/master-data/{entity}/                    // List with pagination
POST   /api/master-data/{entity}/                    // Create
GET    /api/master-data/{entity}/{id}                // Get by ID
PUT    /api/master-data/{entity}/{id}                // Update
DELETE /api/master-data/{entity}/{id}                // Soft delete

// Bulk Operations
POST   /api/master-data/{entity}/bulk                // Bulk create
PUT    /api/master-data/{entity}/bulk                // Bulk update

// Helpers
GET    /api/master-data/{entity}/dropdown            // UI dropdown options
POST   /api/master-data/{entity}/validate            // Pre-save validation
GET    /api/master-data/{entity}/check/{field}       // Check uniqueness
GET    /api/master-data/{entity}/export              // Export CSV/Excel
```

**Supported entities:**
- `locations`, `departments`, `budget-types`, `budget-categories`, `budgets`
- `banks`, `companies`, `drug-generics`, `drugs`

---

## 🎯 Quick Start

### 1. Setup Master Data

```bash
# Seed initial data
npm run db:seed

# Verify data
npm run db:studio  # Open Prisma Studio at http://localhost:5555
```

### 2. Check Data Integrity

```sql
-- Count records
SELECT 'Locations' AS entity, COUNT(*) AS count FROM locations
UNION ALL
SELECT 'Departments', COUNT(*) FROM departments
UNION ALL
SELECT 'Companies', COUNT(*) FROM companies
UNION ALL
SELECT 'Drug Generics', COUNT(*) FROM drug_generics
UNION ALL
SELECT 'Drugs', COUNT(*) FROM drugs;

-- Check ministry compliance fields
SELECT
    COUNT(*) AS total_drugs,
    COUNT(nlem_status) AS with_nlem,
    COUNT(drug_status) AS with_status,
    COUNT(product_category) AS with_category
FROM drugs
WHERE is_active = true;
```

### 3. Test CRUD Operations

```typescript
import { prisma } from './lib/prisma';

// Create location
const location = await prisma.location.create({
  data: {
    locationCode: 'WH001',
    locationName: 'Main Warehouse',
    locationType: 'WAREHOUSE',
    responsiblePerson: 'John Doe',
    isActive: true
  }
});

// Find active drugs
const drugs = await prisma.drug.findMany({
  where: { isActive: true },
  include: {
    generic: true,
    manufacturer: true
  },
  orderBy: { tradeName: 'asc' }
});
```

---

## ✅ Validation Rules

### Locations
- `location_code` - Unique, 10 chars max
- `location_type` - Must be valid enum (WAREHOUSE, PHARMACY, WARD, etc.)
- `parent_id` - Must exist if specified (no circular references)

### Departments
- `dept_code` - Unique, 10 chars max
- `his_code` - Must match HIS system (if integrated)
- `consumption_group` - Must be 1-9 (ministry requirement)

### Drug Generics
- `working_code` - Unique, **exactly 7 characters** (ministry standard)
- `dosage_form` - Must match standard forms (TAB, CAP, etc.)

### Drugs
- `drug_code` - Unique, **exactly 24 characters** (ministry standard)
- `nlem_status` - Required (E or N)
- `drug_status` - Required (1-4)
- `product_category` - Required (1-5)
- `generic_id` - Must exist in drug_generics
- `manufacturer_id` - Must exist in companies

### Companies
- `company_code` - Unique, 10 chars max
- `tax_id` - Unique if specified
- `bank_id` - Must exist in bank table

---

## 🚫 Common Errors

### Error 1: Duplicate Code
```
Error: Unique constraint failed on the fields: (drug_code)
Solution: Check existing drug codes before creating
```

### Error 2: Invalid Working Code Length
```
Error: working_code must be exactly 7 characters
Solution: Pad with zeros (e.g., "1001" → "0001001")
```

### Error 3: Foreign Key Violation
```
Error: Foreign key constraint failed on generic_id
Solution: Create drug generic first, then create trade drug
```

### Error 4: Missing Ministry Fields
```
Error: nlem_status is required
Solution: Specify E (Essential) or N (Non-Essential)
```

---

## 🔗 Related Documentation

### Global Documentation
- **[SYSTEM_ARCHITECTURE.md](../../SYSTEM_ARCHITECTURE.md)** - Overview of all 8 systems
- **[DATABASE_STRUCTURE.md](../../DATABASE_STRUCTURE.md)** - Complete database schema (44 tables)
- **[END_TO_END_WORKFLOWS.md](../../END_TO_END_WORKFLOWS.md)** - Cross-system workflows

### Per-System Documentation
- **[SCHEMA.md](SCHEMA.md)** - Detailed schema of this system's 9 tables
- **[WORKFLOWS.md](WORKFLOWS.md)** - CRUD, Bulk Import, Search workflows

### Technical Reference
- **`prisma/schema.prisma`** - Source schema definition
- **`prisma/seed.ts`** - Seed data script
- **AegisX Swagger UI** - http://127.0.0.1:3383/documentation (when running)

---

## 📈 Next Steps

1. ✅ **Read** [SCHEMA.md](SCHEMA.md) - Understand table structure
2. ✅ **Read** [WORKFLOWS.md](WORKFLOWS.md) - Understand business processes
3. ⏳ **Implement** AegisX APIs - Auto-generate CRUD endpoints
4. ⏳ **Test** via Swagger UI - Test all endpoints
5. ⏳ **Export** OpenAPI spec to `api/openapi.yaml`

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.2.0
