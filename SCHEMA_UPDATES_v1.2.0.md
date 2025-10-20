# INVS Modern - Schema Updates v1.2.0

**Updated**: 2025-01-19
**Status**: ✅ Completed and Tested

---

## 📋 Summary of Changes

Based on the master data operation files provided, the following enhancements have been made to the Prisma schema and seed data:

### New Tables Added (4 tables)

1. **`bank`** - ธนาคาร (Bank information)
2. **`budget_type`** - ประเภทงบประมาณ (Budget type groups)
3. **`budget_category`** - หมวดค่าใช้จ่าย (Budget categories)
4. **`budget`** - งบประมาณ (Budget master connecting type and category)

### Enhanced Tables (2 tables)

1. **`companies`** - Added bank-related fields
   - `bank_code` - เลขบัญชีธนาคาร
   - `bank_account` - ชื่อบัญชีธนาคาร
   - `bank_id` - FK to bank table

2. **`drugs`** - Added pricing field
   - `unit_price` - ราคาขายต่อหน่วย (Decimal 10,2)

---

## 🗃️ Database Schema Changes

### 1. Bank Table (New)

```prisma
model Bank {
  id        BigInt    @id @default(autoincrement()) @map("bank_id")
  bankName  String    @map("bank_name") @db.VarChar(100)
  isActive  Boolean   @default(true) @map("is_active")
  createdAt DateTime  @default(now()) @map("created_at")
  companies Company[]

  @@map("bank")
}
```

**Purpose**: Store bank information for company payment accounts

**Seed Data**: 5 major Thai banks
- ธนาคารกรุงไทย
- ธนาคารกสิกรไทย
- ธนาคารไทยพาณิชย์
- ธนาคารกรุงเทพ
- ธนาคารกรุงศรีอยุธยา

---

### 2. Budget Type Group (New)

```prisma
model BudgetTypeGroup {
  id         BigInt       @id @default(autoincrement())
  typeCode   String       @unique @map("type_code") @db.VarChar(10)
  typeName   String       @map("type_name") @db.VarChar(100)
  isActive   Boolean      @default(true) @map("is_active")
  createdAt  DateTime     @default(now()) @map("created_at")
  budgets    Budget[]

  @@map("budget_type")
}
```

**Purpose**: Classify budgets by type (งบเงินบำรุง, งบลงทุน, งบบุคลากร)

**Seed Data**: 3 budget types
- '01' - งบเงินบำรุง
- '02' - งบลงทุน
- '03' - งบบุคลากร

---

### 3. Budget Category (New)

```prisma
model BudgetCategory {
  id           BigInt       @id @default(autoincrement())
  categoryCode String       @unique @map("category_code") @db.VarChar(10)
  categoryName String       @map("category_name") @db.VarChar(100)
  accCode      String?      @map("acc_code") @db.VarChar(20) // รหัสผังบัญชี
  remark       String?      // หมายเหตุ
  isActive     Boolean      @default(true) @map("is_active")
  createdAt    DateTime     @default(now()) @map("created_at")
  budgets      Budget[]

  @@map("budget_category")
}
```

**Purpose**: Categorize budget expenses with accounting codes

**Seed Data**: 3 categories
- '0101' - เวชภัณฑ์ไม่ใช่ยา (acc: 1105010103.102)
- '0102' - ยา (acc: 1105010103.101)
- '0103' - เครื่องมือแพทย์ (acc: 1105010103.103)

---

### 4. Budget Master (New)

```prisma
model Budget {
  id                BigInt            @id @default(autoincrement())
  budgetCode        String            @unique @map("budget_code") @db.VarChar(10)
  budgetType        String            @map("budget_type") @db.VarChar(10) // FK
  budgetCategory    String            @map("budget_category") @db.VarChar(10) // FK
  budgetDescription String?           @map("budget_description")
  isActive          Boolean           @default(true) @map("is_active")
  createdAt         DateTime          @default(now()) @map("created_at")

  // Relations
  typeGroup         BudgetTypeGroup   @relation(fields: [budgetType], references: [typeCode])
  category          BudgetCategory    @relation(fields: [budgetCategory], references: [categoryCode])

  @@map("budget")
}
```

**Purpose**: Master budget configuration linking types and categories

**Seed Data**: 2 budgets
- 'OP001' - งบประมาณสำหรับซื้อเวชภัณฑ์ไม่ใช่ยา (type: '01', category: '0101')
- 'OP002' - งบประมาณสำหรับซื้อยา (type: '01', category: '0102')

---

### 5. Enhanced Company Model

**Added Fields**:
```prisma
// Bank Information
bankCode            String?         @map("bank_code") @db.VarChar(20) // เลขบัญชีธนาคาร
bankAccount         String?         @map("bank_account") @db.VarChar(100) // ชื่อบัญชีธนาคาร
bankId              BigInt?         @map("bank_id") // FK to bank

// Relation
bank                Bank?           @relation(fields: [bankId], references: [id])
```

**Example Seed Data**:
```typescript
companyCode: '000001',
companyName: 'Government Pharmaceutical Organization (GPO)',
taxId: '0994000158378',
bankCode: '3722699075',
bankAccount: 'บริษัท ร่ำรวยเงินทอง จำกัด',
bankId: 1, // ธนาคารกรุงไทย
```

---

### 6. Enhanced Drug Model

**Added Field**:
```prisma
unitPrice          Decimal?                        @map("unit_price") @db.Decimal(10, 2) // ราคาขายต่อหน่วย
```

**Example Seed Data**:
```typescript
drugCode: 'PAR0001-000001-001',
tradeName: 'GPO Paracetamol 500mg',
genericId: drugGenerics[0].id,
manufacturerId: companies[0].id,
strength: '500mg',
dosageForm: 'Tablet',
packSize: 1000,
unitPrice: 1.50, // ← NEW
unit: 'TAB',
atcCode: 'N02BE01',
standardCode: 'PAR0001-000001-001',
barcode: '8851234567890'
```

---

## 📊 Updated Seed Data Summary

### Master Data Created:

| Entity | Count | Description |
|--------|-------|-------------|
| **Banks** | 5 | Major Thai banks |
| **Budget Type Groups** | 3 | งบเงินบำรุง, งบลงทุน, งบบุคลากร |
| **Budget Categories** | 3 | เวชภัณฑ์ไม่ใช่ยา, ยา, เครื่องมือแพทย์ |
| **Budgets** | 2 | OP001, OP002 |
| **Companies** | 5 | With bank information |
| **Drug Generics** | 5 | Paracetamol, Ibuprofen, etc. |
| **Drugs (Trade)** | 3 | With unit prices |
| **Locations** | 5 | Warehouse, Pharmacy, etc. |
| **Departments** | 5 | Admin, Pharmacy, etc. |
| **Budget Types** | 6 | For allocations (existing) |
| **Budget Allocations** | 3 | For fiscal year 2025 |

**Total Records**: 44 master data records

---

## 🔗 Database Relationships

### Budget System Flow:
```
BudgetTypeGroup (budget_type)
    ↓ (typeCode → budgetType)
Budget (budget)
    ↓ (categoryCode → budgetCategory)
BudgetCategory (budget_category)
```

### Company-Bank Relationship:
```
Bank (bank)
    ↓ (id → bankId)
Company (companies)
```

### Drug Hierarchy:
```
DrugGeneric (drug_generics)
    ↓ (id → genericId)
Drug (drugs) ← manufacturer → Company
```

---

## ✅ Testing Results

### 1. Schema Generation
```bash
npm run db:generate
```
**Result**: ✅ Success - Prisma Client generated

### 2. Database Push
```bash
npm run db:push
```
**Result**: ✅ Success - Database schema synchronized

### 3. Seed Data
```bash
npm run db:seed
```
**Result**: ✅ Success - All master data created

**Output**:
```
✅ Seeding completed successfully!
📍 Created 5 locations
🏥 Created 5 departments
🏦 Created 5 banks
📋 Created 3 budget type groups
📁 Created 3 budget categories
💰 Created 2 budgets
💰 Created 6 budget types (for allocations)
🏢 Created 5 companies
💊 Created 5 drug generics
💊 Created 3 drugs (trade names)
📊 Created 3 budget allocations
```

### 4. Connection Test
```bash
npm run dev
```
**Result**: ✅ Success
```
✅ Database connected successfully!
📍 Locations in database: 5
💊 Drugs in database: 3
🏢 Companies in database: 5
```

---

## 📝 SQL Query Examples

### Budget Query (with JOINs)
```sql
-- Verify budget master with type and category
SELECT
  a.budget_code,
  a.budget_description,
  b.type_name,
  c.category_name,
  c.acc_code
FROM budget as a
INNER JOIN budget_type as b ON a.budget_type = b.type_code
INNER JOIN budget_category as c ON a.budget_category = c.category_code
ORDER BY a.budget_code;
```

### Company Query (with Bank)
```sql
-- Verify company with bank information
SELECT
  a.company_code,
  a.company_name,
  a.company_type,
  a.phone,
  a.bank_code,
  a.bank_account,
  b.bank_name
FROM companies as a
INNER JOIN bank as b ON a.bank_id = b.bank_id
WHERE a.company_code = '000001';
```

### Drug Query (with JOIN)
```sql
-- Verify drug with generic and manufacturer
SELECT
  d.drug_code,
  d.trade_name,
  dg.working_code,
  dg.drug_name as generic_name,
  c.company_name,
  d.pack_size,
  d.unit_price,
  d.unit
FROM drugs d
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN companies c ON d.manufacturer_id = c.id
WHERE d.drug_code = 'PAR0001-000001-001';
```

---

## 🎯 Key Features

### 1. Budget Management
- ✅ Hierarchical budget structure (Type → Budget → Category)
- ✅ Accounting code integration (acc_code)
- ✅ Support for multiple budget types and categories
- ✅ Backward compatible with existing BudgetAllocation system

### 2. Company Management
- ✅ Bank account information
- ✅ Payment tracking support
- ✅ Complete vendor/manufacturer profiles

### 3. Drug Pricing
- ✅ Unit price tracking per drug
- ✅ Support for procurement cost analysis
- ✅ Inventory valuation capability

---

## 🔄 Migration Path

### For Existing Deployments:

1. **Backup existing database**:
   ```bash
   docker exec invs-modern-db pg_dump -U invs_user invs_modern > backup_pre_v1.2.0.sql
   ```

2. **Pull latest changes**:
   ```bash
   git pull origin main
   ```

3. **Update schema**:
   ```bash
   npm run db:push
   ```

4. **Run seed (if fresh deployment)**:
   ```bash
   npm run db:seed
   ```

5. **Verify**:
   ```bash
   npm run dev
   ```

---

## 📚 Related Files

### Schema & Seed:
- `prisma/schema.prisma` - Updated schema (+4 tables, enhanced 2 tables)
- `prisma/seed.ts` - Updated seed data (+5 entity types)

### Documentation:
- `SCHEMA_UPDATES_v1.2.0.md` - This file
- `CLAUDE.md` - Updated project instructions
- `PROJECT_STATUS.md` - To be updated to v1.2.0

### Source Files:
- `/Users/sathitseethaphon/Downloads/Budget Database Operation.txt`
- `/Users/sathitseethaphon/Downloads/Companies Database Operation.txt`
- `/Users/sathitseethaphon/Downloads/Drug Tradname Database Operation.txt`

---

## 🆕 Version History

### v1.2.0 (2025-01-19)
- ✅ Added bank table and company bank fields
- ✅ Added budget type/category/master structure
- ✅ Added unit_price to drugs table
- ✅ Enhanced seed data with all new entities
- ✅ Tested and verified all changes

### v1.1.0 (2025-01-12)
- Budget planning with drug details (FLOW_02B)
- Manual historical data entry support

### v1.0.0 (Initial Release)
- Core system with 34 tables
- Basic master data seeding

---

## 📞 Support

**Database**: PostgreSQL 15-alpine (Port: 5434)
**Tables**: 37 tables (+3 from v1.1.0)
**Seed Records**: 44 master data records (+13 from v1.1.0)

**Status**: ✅ Production Ready (Development Phase)

---

*Last Updated: 2025-01-19*
*Generated for INVS Modern v1.2.0*
