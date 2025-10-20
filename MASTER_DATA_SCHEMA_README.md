# Master Data Export with Schema - v1.2.0

**ไฟล์**: `master_data_with_schema.sql`
**ขนาด**: 996 บรรทัด
**สร้างเมื่อ**: 2025-10-20
**เวอร์ชัน**: 1.2.0

---

## 📋 รายละเอียด

ไฟล์นี้ประกอบด้วย **โครงสร้างตาราง (DDL) + ข้อมูล (Data)** ของ Master Data ทั้งหมด 10 ตาราง

### ✅ สิ่งที่รวมอยู่ในไฟล์

**โครงสร้างฐานข้อมูล (DDL):**
- CREATE TABLE statements (10 tables)
- CREATE SEQUENCE statements (auto-increment)
- CREATE INDEX statements (unique indexes)
- ALTER TABLE statements (foreign keys, constraints)
- DROP statements (clean up existing tables)

**ข้อมูล Master Data:**
- INSERT statements (39 records)
- 10 tables พร้อมข้อมูลครบถ้วน

---

## 📊 ตารางและข้อมูลที่ Export

| ตาราง | จำนวน Records | รายละเอียด |
|-------|--------------|-----------|
| **bank** | 5 | ธนาคารทั้งหมด (กรุงไทย, กสิกร, ไทยพาณิชย์, กรุงเทพ, กรุงศรี) |
| **budget_types** | 3 | ประเภทงบประมาณ (เงินบำรุง, ลงทุน, บุคลากร) |
| **budget_categories** | 3 | หมวดค่าใช้จ่าย (ยา, เวชภัณฑ์ไม่ใช่ยา, เครื่องมือแพทย์) |
| **budgets** | 2 | งบประมาณหลัก (OP001, OP002) |
| **budget_allocations** | 3 | การจัดสรรงบประมาณปี 2025 (รวม 18M) |
| **departments** | 5 | หน่วยงาน (PHARM, MED, NURSE, LAB, ADMIN) |
| **locations** | 5 | สถานที่จัดเก็บ (EMRG, MAIN, PHARM, OPD, ICU) |
| **companies** | 5 | บริษัท vendors/manufacturers พร้อมข้อมูลธนาคาร |
| **drug_generics** | 5 | ยา generic (Paracetamol, Amoxicillin, Aspirin, Ibuprofen, Omeprazole) |
| **drugs** | 3 | ยา trade name พร้อมราคา |
| **รวม** | **39** | |

---

## 🚀 วิธีใช้งาน

### 1. Import เข้าฐานข้อมูลใหม่

```bash
# ใช้ psql ผ่าน Docker
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < master_data_with_schema.sql

# ถ้าใช้ psql โดยตรง
psql -U invs_user -d invs_modern -f master_data_with_schema.sql
```

### 2. Import เข้าฐานข้อมูลที่มีอยู่ (จะลบตารางเก่าก่อน)

```bash
# คำเตือน: จะลบข้อมูลเดิมในตารางเหล่านี้
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < master_data_with_schema.sql
```

---

## ⚠️ คำเตือนสำคัญ

1. **ไฟล์นี้จะลบตารางเดิมก่อน (DROP TABLE IF EXISTS)**
   - หากมีข้อมูลเก่าอยู่ จะถูกลบทิ้ง
   - ใช้เฉพาะกับฐานข้อมูลใหม่ หรือต้องการ reset ข้อมูล

2. **Foreign Key Constraints**
   - ไฟล์จะลบ constraints ก่อน import
   - แล้วสร้าง constraints ใหม่หลัง import เสร็จ
   - ลำดับการ import จัดการอัตโนมัติแล้ว

3. **Sequences**
   - Auto-increment sequences จะถูก reset
   - ID ถัดไปจะเริ่มจาก max(id) + 1

---

## 📦 โครงสร้างไฟล์

```sql
# 1. Session Settings
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
...

# 2. Drop Existing Objects
DROP TABLE IF EXISTS public.bank;
DROP TABLE IF EXISTS public.budget_types;
...

# 3. Create Tables
CREATE TABLE public.bank (...);
CREATE TABLE public.budget_types (...);
...

# 4. Insert Data
INSERT INTO public.bank VALUES (...);
INSERT INTO public.budget_types VALUES (...);
...

# 5. Reset Sequences
SELECT pg_catalog.setval('public.bank_bank_id_seq', 5, true);
...

# 6. Create Indexes
CREATE UNIQUE INDEX budget_types_type_code_key ...;
...

# 7. Add Foreign Keys
ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_budget_type_fkey ...;
...
```

---

## 🔍 ตรวจสอบข้อมูลหลัง Import

```sql
-- ตรวจสอบจำนวน records
SELECT 'bank' as table_name, COUNT(*) FROM bank
UNION ALL
SELECT 'budget_types', COUNT(*) FROM budget_types
UNION ALL
SELECT 'budget_categories', COUNT(*) FROM budget_categories
UNION ALL
SELECT 'budgets', COUNT(*) FROM budgets
UNION ALL
SELECT 'budget_allocations', COUNT(*) FROM budget_allocations
UNION ALL
SELECT 'departments', COUNT(*) FROM departments
UNION ALL
SELECT 'locations', COUNT(*) FROM locations
UNION ALL
SELECT 'companies', COUNT(*) FROM companies
UNION ALL
SELECT 'drug_generics', COUNT(*) FROM drug_generics
UNION ALL
SELECT 'drugs', COUNT(*) FROM drugs;

-- ผลลัพธ์ที่คาดหวัง: 39 records รวม
```

### ตรวจสอบความสัมพันธ์

```sql
-- Budget hierarchy
SELECT
  bt.type_name,
  bc.category_name,
  b.budget_code,
  b.budget_description
FROM budgets b
JOIN budget_types bt ON b.budget_type = bt.type_code
JOIN budget_categories bc ON b.budget_category = bc.category_code;

-- Companies with Bank
SELECT
  c.company_code,
  c.company_name,
  bk.bank_name,
  c.bank_account
FROM companies c
LEFT JOIN bank bk ON c.bank_id = bk.bank_id;

-- Drugs with Manufacturer
SELECT
  d.drug_code,
  d.trade_name,
  dg.drug_name as generic_name,
  c.company_name as manufacturer
FROM drugs d
LEFT JOIN drug_generics dg ON d.generic_id = dg.id
LEFT JOIN companies c ON d.manufacturer_id = c.id;
```

---

## 💾 ข้อมูลเฉพาะที่สำคัญ

### Budget Summary 2025
```
งบเงินบำรุง (01):
  ├─ OP001: เวชภัณฑ์ไม่ใช่ยา → 3,000,000 บาท (Dept: MED)
  └─ OP002: ยา → 10,000,000 บาท (Dept: PHARM)
                  5,000,000 บาท (Dept: NURSE)

รวมงบประมาณ 2025: 18,000,000 บาท
```

### Companies with Bank Accounts
```
000001 - GPO → ธนาคารกรุงไทย (3722699075)
000002 - Zuellig → ธนาคารกสิกรไทย (4561234567)
000003 - Pfizer → ธนาคารไทยพาณิชย์ (7891234567)
000004 - Sino-Thai → ธนาคารกรุงเทพ (1234567890)
000005 - Berlin → ธนาคารกรุงศรีอยุธยา (9876543210)
```

### Drugs with Prices
```
PAR0001-000001-001 - GPO Paracetamol 500mg → 1.50 ฿/TAB
IBU0001-000001-001 - GPO Ibuprofen 200mg → 2.50 ฿/TAB
AMX0001-000002-001 - Zuellig Amoxicillin 250mg → 3.00 ฿/CAP
```

---

## 🔧 Troubleshooting

### ปัญหา: Cannot import - relation does not exist
**สาเหตุ**: ตารางอื่นๆ ที่มี foreign key อ้างอิงยังไม่ถูกสร้าง
**วิธีแก้**:
```bash
# Drop ตารางที่เกี่ยวข้องทั้งหมดก่อน
docker exec -i invs-modern-db psql -U invs_user -d invs_modern -c "
DROP TABLE IF EXISTS budget_allocations CASCADE;
DROP TABLE IF EXISTS budgets CASCADE;
DROP TABLE IF EXISTS budget_categories CASCADE;
DROP TABLE IF EXISTS budget_types CASCADE;
DROP TABLE IF EXISTS drugs CASCADE;
DROP TABLE IF EXISTS drug_generics CASCADE;
DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS bank CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
"

# แล้ว import ใหม่
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < master_data_with_schema.sql
```

### ปัญหา: Duplicate key error
**สาเหตุ**: มีข้อมูลเก่าอยู่แล้ว
**วิธีแก้**: ไฟล์มี `DROP TABLE IF EXISTS` อยู่แล้ว ควรจะไม่เกิดปัญหานี้

### ปัญหา: Encoding issues (Thai characters broken)
**สาเหตุ**: Client encoding ไม่ตรง
**วิธีแก้**:
```bash
docker exec -i invs-modern-db psql -U invs_user -d invs_modern -c "SET client_encoding = 'UTF8';" < master_data_with_schema.sql
```

---

## 📚 เอกสารที่เกี่ยวข้อง

- `MASTER_DATA_COMPLETE.md` - รายงานข้อมูล master data ทั้งหมด
- `QUICK_REFERENCE_v1.2.0.md` - คู่มือการใช้งาน master data
- `SCHEMA_UPDATES_v1.2.0.md` - รายละเอียดการอัพเดท schema
- `prisma/schema.prisma` - Prisma schema definition

---

## 📝 หมายเหตุ

1. ไฟล์นี้สร้างจาก `pg_dump` version 15.14
2. รองรับ PostgreSQL 15.x
3. ใช้ `--clean --if-exists --inserts` options
4. Safe สำหรับ version control (no COPY format, all INSERTs)
5. ไม่รวม permissions และ ownership (จะใช้ default owner)

---

## 🎯 Use Cases

### 1. Fresh Installation
```bash
# สร้างฐานข้อมูลใหม่
docker-compose up -d
npm run db:push  # สร้าง schema จาก Prisma
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < master_data_with_schema.sql
```

### 2. Reset Master Data
```bash
# ลบและสร้างข้อมูลใหม่
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < master_data_with_schema.sql
```

### 3. Share with Team
```bash
# แชร์ไฟล์ให้ทีมทำตาม
git add master_data_with_schema.sql MASTER_DATA_SCHEMA_README.md
git commit -m "Add master data with schema export"
git push
```

---

**เวอร์ชัน**: 1.2.0
**อัพเดทล่าสุด**: 2025-10-20
**สถานะ**: ✅ Ready to Use

---

*สร้างด้วย pg_dump และความรักจากทีม INVS Modern* 💙
