# 📖 Quick Reference Guide - INVS Modern v1.2.0

**สำหรับ**: นักพัฒนาที่ต้องการใช้งาน Master Data ใหม่

---

## 🚀 Quick Start

```bash
# 1. Start Docker
docker-compose up -d

# 2. Run seed (if fresh install)
npm run db:seed

# 3. Verify
npm run dev
```

---

## 📊 Master Data Available

### 🏦 Banks (5 ธนาคาร)
```typescript
const banks = await prisma.bank.findMany()
// [1] ธนาคารกรุงไทย
// [2] ธนาคารกสิกรไทย
// [3] ธนาคารไทยพาณิชย์
// [4] ธนาคารกรุงเทพ
// [5] ธนาคารกรุงศรีอยุธยา
```

### 💰 Budget System

```typescript
// Budget Type Groups
const budgetTypes = await prisma.budgetTypeGroup.findMany()
// '01' - งบเงินบำรุง
// '02' - งบลงทุน
// '03' - งบบุคลากร

// Budget Categories
const categories = await prisma.budgetCategory.findMany()
// '0101' - เวชภัณฑ์ไม่ใช่ยา (Acc: 1105010103.102)
// '0102' - ยา (Acc: 1105010103.101)
// '0103' - เครื่องมือแพทย์ (Acc: 1105010103.103)

// Budgets with full details
const budgets = await prisma.budget.findMany({
  include: {
    typeGroup: true,
    category: true
  }
})
```

### 🏢 Companies with Bank

```typescript
// Get company with bank info
const company = await prisma.company.findUnique({
  where: { companyCode: '000001' },
  include: { bank: true }
})

console.log(company.bank.bankName) // 'ธนาคารกรุงไทย'
console.log(company.bankAccount)   // 'บริษัท ร่ำรวยเงินทอง จำกัด'
console.log(company.bankCode)      // '3722699075'
```

### 💊 Drugs with Prices

```typescript
// Get drug with price and details
const drug = await prisma.drug.findUnique({
  where: { drugCode: 'PAR0001-000001-001' },
  include: {
    generic: true,
    manufacturer: true
  }
})

console.log(drug.tradeName)         // 'GPO Paracetamol 500mg'
console.log(drug.unitPrice)         // 1.50
console.log(drug.unit)              // 'TAB'
console.log(drug.manufacturer.companyName) // 'GPO'
```

---

## 🔍 Common Queries

### Query 1: Get Budget with Full Details

```typescript
const budgetWithDetails = await prisma.budget.findUnique({
  where: { budgetCode: 'OP001' },
  include: {
    typeGroup: true,
    category: true
  }
})

console.log({
  code: budgetWithDetails.budgetCode,
  description: budgetWithDetails.budgetDescription,
  type: budgetWithDetails.typeGroup.typeName,
  category: budgetWithDetails.category.categoryName,
  accCode: budgetWithDetails.category.accCode
})
```

### Query 2: Get All Companies with Bank Info

```typescript
const companiesWithBank = await prisma.company.findMany({
  where: {
    bankId: { not: null }
  },
  include: {
    bank: true
  },
  orderBy: { companyCode: 'asc' }
})

companiesWithBank.forEach(company => {
  console.log(`${company.companyName} → ${company.bank.bankName}`)
})
```

### Query 3: Get Drugs with Prices and Manufacturer

```typescript
const drugsWithPrices = await prisma.drug.findMany({
  where: {
    unitPrice: { not: null }
  },
  include: {
    generic: true,
    manufacturer: {
      include: { bank: true }
    }
  },
  orderBy: { unitPrice: 'asc' }
})

drugsWithPrices.forEach(drug => {
  console.log(`${drug.tradeName}: ${drug.unitPrice} ฿/${drug.unit}`)
  console.log(`  Manufacturer: ${drug.manufacturer.companyName}`)
  console.log(`  Bank: ${drug.manufacturer.bank.bankName}`)
})
```

### Query 4: Get Budget Categories with Usage Count

```typescript
const categoriesWithCount = await prisma.budgetCategory.findMany({
  include: {
    budgets: true,
    _count: {
      select: { budgets: true }
    }
  },
  orderBy: { categoryCode: 'asc' }
})

categoriesWithCount.forEach(cat => {
  console.log(`${cat.categoryName}: ${cat._count.budgets} budgets`)
  console.log(`  Acc Code: ${cat.accCode}`)
})
```

---

## 📝 Example Use Cases

### Use Case 1: Create Purchase Order with Budget Check

```typescript
// 1. Get budget info
const budget = await prisma.budget.findUnique({
  where: { budgetCode: 'OP002' },
  include: { category: true }
})

// 2. Get drug with price
const drug = await prisma.drug.findUnique({
  where: { drugCode: 'PAR0001-000001-001' },
  include: { manufacturer: { include: { bank: true } } }
})

// 3. Calculate total
const quantity = 5000
const total = Number(drug.unitPrice) * quantity

console.log({
  budget: budget.budgetDescription,
  category: budget.category.categoryName,
  accCode: budget.category.accCode,
  drug: drug.tradeName,
  manufacturer: drug.manufacturer.companyName,
  bank: drug.manufacturer.bank.bankName,
  bankAccount: drug.manufacturer.bankAccount,
  unitPrice: drug.unitPrice,
  quantity: quantity,
  total: total
})
```

### Use Case 2: Payment Processing

```typescript
// Get company with payment details
const supplier = await prisma.company.findUnique({
  where: { companyCode: '000002' },
  include: { bank: true }
})

const paymentInfo = {
  payTo: supplier.companyName,
  bank: supplier.bank.bankName,
  accountName: supplier.bankAccount,
  accountNumber: supplier.bankCode,
  taxId: supplier.taxId
}

console.log('Payment Information:', paymentInfo)
```

### Use Case 3: Budget Report

```typescript
// Get all budgets grouped by type
const budgetsByType = await prisma.budgetTypeGroup.findMany({
  include: {
    budgets: {
      include: {
        category: true
      }
    }
  },
  orderBy: { typeCode: 'asc' }
})

budgetsByType.forEach(type => {
  console.log(`\n${type.typeName} (${type.typeCode}):`)
  type.budgets.forEach(budget => {
    console.log(`  - ${budget.budgetCode}: ${budget.category.categoryName}`)
    console.log(`    Acc: ${budget.category.accCode}`)
  })
})
```

---

## 🎨 TypeScript Types

All types are auto-generated by Prisma:

```typescript
import { PrismaClient, Bank, Budget, BudgetTypeGroup, BudgetCategory, Company, Drug } from '@prisma/client'

// Type with relations
type CompanyWithBank = Company & {
  bank: Bank | null
}

type BudgetWithDetails = Budget & {
  typeGroup: BudgetTypeGroup
  category: BudgetCategory
}

type DrugWithDetails = Drug & {
  generic: DrugGeneric | null
  manufacturer: CompanyWithBank | null
}
```

---

## 🔧 Maintenance Commands

```bash
# Regenerate Prisma Client (after schema changes)
npm run db:generate

# Push schema changes to database
npm run db:push

# Re-seed data (will update existing records)
npm run db:seed

# Open Prisma Studio (GUI)
npm run db:studio

# Connect to PostgreSQL directly
docker exec -it invs-modern-db psql -U invs_user -d invs_modern
```

---

## 📚 Related Documentation

- `MASTER_DATA_COMPLETE.md` - Complete verification report
- `SCHEMA_UPDATES_v1.2.0.md` - Technical details
- `prisma/schema.prisma` - Database schema
- `prisma/seed.ts` - Seed data script

---

## 🆘 Troubleshooting

### Problem: Companies don't have bank info

```bash
# Re-run seed (it will update)
npm run db:seed
```

### Problem: Drugs don't have prices

```bash
# Re-run seed
npm run db:seed
```

### Problem: Budget structure is empty

```bash
# Check if tables exist
docker exec -it invs-modern-db psql -U invs_user -d invs_modern -c "\dt"

# Re-seed
npm run db:seed
```

---

**Version**: 1.2.0
**Last Updated**: 2025-01-19
**Status**: ✅ Production Ready

*Happy Coding!* 🚀
