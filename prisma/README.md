# Prisma Database Setup

**INVS Modern - Hospital Drug Inventory Management System**

โฟลเดอร์นี้มีทุกอย่างที่จำเป็นสำหรับสร้างฐานข้อมูล PostgreSQL

---

## ไฟล์ในโฟลเดอร์

| ไฟล์ | ขนาด | คำอธิบาย |
|------|------|----------|
| `schema.prisma` | 60KB | Prisma schema (58 tables, 31 enums) |
| `schema.sql` | 140KB | DDL - CREATE TABLE, ENUM, INDEX |
| `seed.sql.gz` | 3.2MB | ข้อมูลทั้งหมด (~104K records) |
| `full_dump.sql.gz` | 3MB | รวม schema + data ในไฟล์เดียว |
| `functions.sql` | 22KB | 12 Business Logic Functions |
| `views.sql` | 14KB | 11 Reporting Views |
| `migrations/` | - | Prisma migration history (12 migrations) |

---

## วิธีใช้งาน

### ขั้นตอนที่ 1: สร้าง Database

```bash
# สร้าง database ใหม่
createdb -U postgres invs_modern

# หรือใช้ Docker
docker run -d --name invs-db \
  -e POSTGRES_USER=invs_user \
  -e POSTGRES_PASSWORD=invs123 \
  -e POSTGRES_DB=invs_modern \
  -p 5434:5432 \
  postgres:15-alpine
```

### ขั้นตอนที่ 2: Import ข้อมูล

**Option A: Full Dump (แนะนำ) - ไฟล์เดียวจบ**
```bash
gunzip -c full_dump.sql.gz | psql -U invs_user -d invs_modern
```

**Option B: แยกไฟล์**
```bash
# 1. สร้างโครงสร้าง
psql -U invs_user -d invs_modern -f schema.sql

# 2. ใส่ข้อมูล
gunzip -c seed.sql.gz | psql -U invs_user -d invs_modern
```

### ขั้นตอนที่ 3: สร้าง Functions และ Views

```bash
psql -U invs_user -d invs_modern -f functions.sql
psql -U invs_user -d invs_modern -f views.sql
```

### ขั้นตอนที่ 4: ตรวจสอบ

```bash
psql -U invs_user -d invs_modern -c "
SELECT
  (SELECT COUNT(*) FROM drugs) as drugs,
  (SELECT COUNT(*) FROM drug_generics) as generics,
  (SELECT COUNT(*) FROM companies) as companies,
  (SELECT COUNT(*) FROM ed_groups) as ed_groups,
  (SELECT COUNT(*) FROM tmt_concepts) as tmt_concepts;
"
```

ผลลัพธ์ที่ควรได้:
```
 drugs | generics | companies | ed_groups | tmt_concepts
-------+----------+-----------+-----------+--------------
  7261 |     1109 |       800 |       209 |        76904
```

---

## สำหรับ Prisma Client (Node.js)

ถ้าต้องการใช้ Prisma Client:

```bash
# 1. Install dependencies
npm install prisma @prisma/client

# 2. Set DATABASE_URL
echo 'DATABASE_URL="postgresql://invs_user:invs123@localhost:5434/invs_modern"' > .env

# 3. Generate client
npx prisma generate

# 4. (Optional) Push schema changes
npx prisma db push
```

---

## ข้อมูลในฐานข้อมูล

### Master Data
| ตาราง | จำนวน | คำอธิบาย |
|-------|------:|----------|
| drugs | 7,261 | ยาการค้า |
| drug_generics | 1,109 | ยาสามัญ (with ED classification) |
| companies | 800 | บริษัทผู้ผลิต/จำหน่าย |
| departments | 108 | หน่วยงาน |
| locations | 96 | สถานที่จัดเก็บ |
| ed_groups | 209 | กลุ่มการรักษา (Therapeutic Class) |

### Inventory
| ตาราง | จำนวน | คำอธิบาย |
|-------|------:|----------|
| inventory | 7,105 | สต็อกยา |
| drug_lots | 6,033 | ล็อตยา (FIFO/FEFO) |

### TMT Integration
| ตาราง | จำนวน | คำอธิบาย |
|-------|------:|----------|
| tmt_concepts | 76,904 | Thai Medical Terminology |

### Budget
| ตาราง | จำนวน | คำอธิบาย |
|-------|------:|----------|
| budget_plans | 3 | แผนงบประมาณ |
| budget_plan_items | 1,710 | รายการแผนงบประมาณ |

---

## ED Classification (Phase 16)

จากคู่มือ INVS หน้า 12 (บัญชี ED):

| Category | ชื่อไทย | จำนวน |
|----------|---------|------:|
| ED | บัญชียา ED (Essential Drug) | 852 |
| NED | บัญชียา NED (Non-Essential) | 149 |
| NDMS | เวชภัณฑ์มิใช่ยา | 5 |
| CM | สารเคมี | 89 |
| LS | วัสดุทางห้องปฏิบัติการ | 0 |
| PS | วัสดุทางเภสัชกรรม | 0 |

---

## Functions ที่มี

| Function | คำอธิบาย |
|----------|----------|
| `check_budget_availability()` | ตรวจสอบงบประมาณคงเหลือ |
| `reserve_budget()` | จองงบประมาณ |
| `commit_budget()` | ยืนยันใช้งบประมาณ |
| `release_budget_reservation()` | ปล่อยงบที่จองไว้ |
| `get_fifo_lots()` | ดึงล็อตยาตาม FIFO |
| `get_fefo_lots()` | ดึงล็อตยาตาม FEFO |
| `update_inventory_from_receipt()` | อัพเดทสต็อกจากใบรับ |

---

## Views ที่มี

| View | คำอธิบาย |
|------|----------|
| `export_druglist` | ส่งออกรายการยา (Ministry) |
| `export_purchase_plan` | ส่งออกแผนจัดซื้อ (Ministry) |
| `export_receipt` | ส่งออกใบรับ (Ministry) |
| `export_distribution` | ส่งออกการจ่าย (Ministry) |
| `export_inventory` | ส่งออกสต็อก (Ministry) |
| `budget_status_current` | สถานะงบประมาณปัจจุบัน |
| `low_stock_items` | รายการยาใกล้หมด |
| `expiring_drugs` | ยาใกล้หมดอายุ |

---

## Troubleshooting

### Error: database does not exist
```bash
createdb -U postgres invs_modern
```

### Error: permission denied
```bash
psql -U postgres -c "GRANT ALL ON DATABASE invs_modern TO invs_user;"
```

### Error: role does not exist
```bash
psql -U postgres -c "CREATE USER invs_user WITH PASSWORD 'invs123';"
```

---

**Version**: 3.1.0
**Last Updated**: 2024-12-10
**Total Records**: ~104,500
