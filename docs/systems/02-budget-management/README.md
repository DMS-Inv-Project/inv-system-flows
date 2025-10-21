# 💰 Budget Management System

**Priority**: ⭐⭐⭐ High
**Tables**: 4 tables (budget_allocations, budget_reservations, budget_plans, budget_plan_items)
**Functions**: 4 database functions
**Complexity**: ⭐⭐⭐ สูง

## 📋 Overview

ระบบงบประมาณ แบ่งเป็น:
1. **Budget Allocation** - จัดสรรงบประมาณประจำปี (แบ่งไตรมาส Q1-Q4)
2. **Budget Reservation** - จองงบประมาณสำหรับ PR
3. **Budget Planning** - วางแผนระดับยา พร้อมข้อมูล 3 ปี
4. **Budget Functions** - ตรวจสอบและจองงบแบบ real-time

## 🗄️ Key Tables

### budget_allocations
จัดสรรงบประมาณประจำปี แบ่งเป็นไตรมาส (Q1-Q4)

### budget_plan_items
วางแผนระดับยา มีข้อมูล:
- ปริมาณใช้ย้อนหลัง 3 ปี
- แผนปีนี้แบ่งตามไตรมาส
- ติดตามจำนวนที่สั่งซื้อไปแล้ว

## 🔄 Workflow

```
1. จัดสรรงบ (Allocation) → แบ่งตาม Q1-Q4
2. วางแผนยา (Planning) → ระบุยาแต่ละตัว + จำนวน
3. สร้าง PR → จองงบ (Reservation)
4. อนุมัติ PR → Commit budget
5. สร้าง PO → ตัดงบจริง
```

## 🔌 Key API Endpoints

```typescript
// Check budget availability
POST /api/budget/check-availability
Body: { fiscalYear, budgetTypeId, departmentId, amount, quarter }

// Get budget status
GET /api/budget/status/:fiscalYear/:deptId

// Create budget plan
POST /api/budget/plans
Body: { fiscalYear, departmentId, items: [...] }
```

## 💼 Database Functions

1. `check_budget_availability()` - เช็คงบประมาณคงเหลือ
2. `reserve_budget()` - จองงบสำหรับ PR
3. `commit_budget()` - ตัดงบเมื่ออนุมัติ PO
4. `check_drug_in_budget_plan()` - เช็คว่ายาอยู่ในแผนหรือไม่

## ✅ Development Tasks

- [ ] Budget allocation CRUD
- [ ] Budget reservation management
- [ ] Drug-level budget planning
- [ ] Real-time budget checking
- [ ] Quarterly breakdown queries
- [ ] Budget vs actual reporting

**Related**: [Master Data](../01-master-data/README.md), [Procurement](../03-procurement/README.md)
