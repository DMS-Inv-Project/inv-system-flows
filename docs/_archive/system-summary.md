# INVS Modern - สรุปโครงสร้างระบบและมาตรฐาน กสธ.

## 📊 1. สรุปโครงสร้างข้อมูลพื้นฐานทั้งหมด

### 🏗️ โครงสร้างหลัก (16 ตาราง)

#### 1.1 Master Data (6 ตาราง)
```
locations          - สถานที่เก็บ (คลัง, ห้องยา, หอผู้ป่วย)
departments        - หน่วยงาน/แผนก โรงพยาบาล
budget_types       - ประเภทงบประมาณ (OP001-ยา, OP002-เครื่องมือ)
companies          - บริษัท/ผู้ขาย/ผู้ผลิต (816 รายการ)
drug_generics      - ยาชื่อสามัญ (Working Code 7 หลัก, 1,104 รายการ)
drugs              - ยาชื่อการค้า (Trade Name)
```

#### 1.2 Budget Management (2 ตาราง)
```
budget_allocations - การจัดสรรงบประมาณ (แบ่งเป็นไตรมาส Q1-Q4)
budget_reservations - การจองงบประมาณ (Reserve → Commit)
```

#### 1.3 Procurement (4 ตาราง)
```
purchase_requests      - คำขอซื้อ (PR)
purchase_request_items - รายการในคำขอซื้อ
purchase_orders        - ใบสั่งซื้อ (PO)
purchase_order_items   - รายการในใบสั่งซื้อ
```

#### 1.4 Inventory Management (3 ตาราง)
```
inventory              - สต็อกยาตาม location
drug_lots              - การติดตาม lot number และวันหมดอายุ (FIFO/FEFO)
inventory_transactions - รายการเคลื่อนไหวทั้งหมด
```

#### 1.5 Receiving (2 ตาราง)
```
receipts      - การรับยาเข้าคลัง
receipt_items - รายการยาที่รับเข้า
```

### 🔑 Key Features
- **Working Code System**: รหัสยา 7 หลัก ตามมาตรฐานโรงพยาบาล
- **FIFO/FEFO Management**: จัดการ lot และวันหมดอายุ
- **Multi-location Inventory**: แยกสต็อกตาม location
- **Real-time Budget Control**: ตรวจสอบงบประมาณแบบ real-time
- **Quarterly Budget Tracking**: ติดตามงบประมาณรายไตรมาส

---

## 📋 2. การวิเคราะห์มาตรฐานข้อมูลบริหารเวชภัณฑ์ กระทรวงสาธารณสุข

### 🗂️ ข้อกำหนด 5 แฟ้มข้อมูลหลัก

#### แฟ้มที่ 1: **Druglist (บัญชีรายการยา)**
- **สถานะ**: ✅ **รองรับครบ 100%**
- **แหล่งข้อมูล**: `drug_generics` + `drugs` + `companies`
- **เนื้อหา**: รายการยาทั้งหมด, รหัสยา, ชื่อยา, ผู้ผลิต, ราคา
- **ข้อมูลหลัก**: Working Code, Trade Name, Manufacturer, Unit Cost

#### แฟ้มที่ 2: **Purchase Plan (แผนปฏิบัติการจัดซื้อยา)**
- **สถานะ**: ✅ **รองรับครบ 100%**
- **แหล่งข้อมูล**: `purchase_requests` + `purchase_request_items` + `budget_allocations`
- **เนื้อหา**: แผนการซื้อยาประจำปี, งบประมาณและการจัดสรร
- **ข้อมูลหลัก**: PR Number, Budget Code, Request Amount, Approval Status

#### แฟ้มที่ 3: **Receipt (การรับยาเข้าคลัง)**
- **สถานะ**: ✅ **รองรับครบ 100%**
- **แหล่งข้อมูล**: `receipts` + `receipt_items` + `drug_lots`
- **เนื้อหา**: รายการรับยาเข้าคลัง, Lot number, วันหมดอายุ, ราคา
- **ข้อมูลหลัก**: Receipt Number, PO Number, Lot Number, Expiry Date

#### แฟ้มที่ 4: **Distribution (การจ่ายยาออกจากคลัง)**
- **สถานะ**: ⚠️ **ต้องเพิ่มเติม 70%**
- **ข้อมูลปัจจุบัน**: `inventory_transactions` แบบทั่วไป
- **ข้อมูลที่ขาด**: ตารางเฉพาะการจ่ายยา, หน่วยงานรับ, วัตถุประสงค์
- **ต้องเพิ่ม**: `drug_distributions` + `drug_distribution_items`

#### แฟ้มที่ 5: **Inventory (ยาคงคลัง)**
- **สถานะ**: ✅ **รองรับครบ 100%**
- **แหล่งข้อมูล**: `inventory` + `drug_lots` + `locations`
- **เนื้อหา**: สต็อกยาคงเหลือ ณ วันที่, แยกตาม location และ lot
- **ข้อมูลหลัก**: Stock Balance, Min/Max Levels, Location, Lot Details

---

## 🔍 3. ตรวจสอบความครอบคลุมของโครงสร้างปัจจุบันกับมาตรฐาน กสธ.

### ✅ **จุดแข็งของระบบปัจจุบัน**

#### 3.1 Budget Management
- ✅ งบประมาณแบ่งตามไตรมาส (Q1-Q4) ตามปีงบประมาณ
- ✅ ระบบจองงบและตัดงบแบบ real-time
- ✅ เชื่อมโยงงบประมาณกับ Purchase Request/Order
- ✅ ติดตามการใช้จ่ายแยกตามหน่วยงาน

#### 3.2 Drug Management
- ✅ Working Code System (7 หลัก) ตามมาตรฐานโรงพยาบาล
- ✅ แยกระหว่าง Generic Name และ Trade Name ชัดเจน
- ✅ รองรับข้อมูลผู้ผลิตและผู้จำหน่าย
- ✅ ATC Code และ Standard Code สำหรับมาตรฐานสากล

#### 3.3 Inventory Control
- ✅ FIFO/FEFO Management ตาม lot number
- ✅ Multi-location inventory tracking
- ✅ ระบบแจ้งเตือน reorder point
- ✅ การติดตามวันหมดอายุแบบ real-time

#### 3.4 Procurement Process
- ✅ ครบวงจร: PR → PO → Receipt → Inventory
- ✅ ระบบอนุมัติตามสายงาน
- ✅ เชื่อมโยงกับงบประมาณ
- ✅ ประวัติการสั่งซื้อครบถ้วน

### ⚠️ **จุดที่ต้องปรับปรุง**

#### 3.1 Distribution Management (ขาดหาย 30%)
```sql
-- ต้องเพิ่มตารางใหม่
CREATE TABLE drug_distributions (
  id BIGINT PRIMARY KEY,
  distribution_number VARCHAR(20) UNIQUE,
  distribution_date DATE,
  requesting_department_id BIGINT,
  purpose TEXT,
  approved_by BIGINT,
  status ENUM('pending', 'approved', 'dispensed'),
  total_items INT,
  created_at TIMESTAMP
);

CREATE TABLE drug_distribution_items (
  id BIGINT PRIMARY KEY,
  distribution_id BIGINT,
  drug_id BIGINT,
  lot_number VARCHAR(20),
  quantity_dispensed DECIMAL(10,2),
  unit_cost DECIMAL(10,2),
  expiry_date DATE,
  purpose VARCHAR(100)
);
```

#### 3.2 มาตรฐานรหัสยา กสธ.
- ⚠️ **TMT Code** (รหัสมาตรฐาน กสธ.) - ต้องเพิ่มใน `drug_generics`
- ⚠️ **24NC Code** (รหัส 24 หลัก) - ต้องเพิ่มใน `drugs`
- ✅ **ATC Code** - มีอยู่แล้วใน `drugs`

#### 3.3 Unit Standardization
- ⚠️ **Standard Unit** ตามมาตรฐาน กสธ. - ต้องปรับปรุงใน `drug_generics`
- ⚠️ **Pack Size Standardization** - ต้องปรับปรุงการจัดการ pack size

---

## 💡 4. ข้อเสนะแนะการปรับปรุงโครงสร้างให้รองรับมาตรฐาน

### 🚀 **Phase 1: เพิ่มตาราง Distribution (สำคัญมาก)**

#### 4.1 เพิ่มตาราง Drug Distribution
```sql
-- Prisma Schema เพิ่มเติม
model DrugDistribution {
  id               BigInt    @id @default(autoincrement())
  distributionNumber String  @unique @map("distribution_number") @db.VarChar(20)
  distributionDate DateTime  @map("distribution_date") @db.Date
  requestingDeptId BigInt    @map("requesting_dept_id")
  purpose          String?
  approvedBy       BigInt?   @map("approved_by")
  status           DistributionStatus @default(PENDING)
  totalItems       Int       @default(0) @map("total_items")
  totalAmount      Decimal   @default(0) @map("total_amount") @db.Decimal(12, 2)
  createdAt        DateTime  @default(now()) @map("created_at")

  // Relations
  requestingDept   Department @relation(fields: [requestingDeptId], references: [id])
  items            DrugDistributionItem[]

  @@map("drug_distributions")
}

model DrugDistributionItem {
  id               BigInt    @id @default(autoincrement())
  distributionId   BigInt    @map("distribution_id")
  drugId           BigInt    @map("drug_id")
  lotNumber        String    @map("lot_number") @db.VarChar(20)
  quantityDispensed Decimal  @map("quantity_dispensed") @db.Decimal(10, 2)
  unitCost         Decimal   @map("unit_cost") @db.Decimal(10, 2)
  expiryDate       DateTime  @map("expiry_date") @db.Date
  purpose          String?   @db.VarChar(100)

  // Relations
  distribution     DrugDistribution @relation(fields: [distributionId], references: [id])
  drug             Drug      @relation(fields: [drugId], references: [id])

  @@map("drug_distribution_items")
}

enum DistributionStatus {
  PENDING    @map("pending")
  APPROVED   @map("approved")
  DISPENSED  @map("dispensed")
  CANCELLED  @map("cancelled")
}
```

### 🔧 **Phase 2: เพิ่มฟิลด์มาตรฐาน กสธ.**

#### 4.2 ปรับปรุง Drug Generics
```sql
-- เพิ่มฟิลด์ใน drug_generics
ALTER TABLE drug_generics ADD COLUMN tmt_code VARCHAR(10);
ALTER TABLE drug_generics ADD COLUMN standard_unit VARCHAR(10);
ALTER TABLE drug_generics ADD COLUMN therapeutic_group VARCHAR(50);

-- เพิ่มฟิลด์ใน drugs  
ALTER TABLE drugs ADD COLUMN nc24_code VARCHAR(24);
ALTER TABLE drugs ADD COLUMN registration_number VARCHAR(20);
ALTER TABLE drugs ADD COLUMN gpo_code VARCHAR(15);
```

#### 4.3 ปรับปรุง Prisma Schema
```prisma
model DrugGeneric {
  // ... existing fields
  tmtCode          String?   @map("tmt_code") @db.VarChar(10)
  standardUnit     String?   @map("standard_unit") @db.VarChar(10)
  therapeuticGroup String?   @map("therapeutic_group") @db.VarChar(50)
}

model Drug {
  // ... existing fields
  nc24Code         String?   @map("nc24_code") @db.VarChar(24)
  registrationNumber String? @map("registration_number") @db.VarChar(20)
  gpoCode          String?   @map("gpo_code") @db.VarChar(15)
}
```

### 📊 **Phase 3: สร้าง Export Views**

#### 4.4 Views สำหรับส่งออกข้อมูลตามมาตรฐาน กสธ.
```sql
-- View สำหรับแฟ้ม Druglist
CREATE VIEW export_druglist AS
SELECT 
    dg.working_code,
    dg.drug_name,
    dg.tmt_code,
    dg.dosage_form,
    dg.standard_unit,
    dg.therapeutic_group,
    d.drug_code,
    d.trade_name,
    d.nc24_code,
    d.registration_number,
    c.company_name as manufacturer,
    d.pack_size,
    d.unit
FROM drug_generics dg
LEFT JOIN drugs d ON dg.id = d.generic_id
LEFT JOIN companies c ON d.manufacturer_id = c.id
WHERE dg.is_active = true;

-- View สำหรับแฟ้ม Purchase Plan
CREATE VIEW export_purchase_plan AS
SELECT 
    pr.pr_number,
    pr.pr_date,
    dept.dept_name,
    bt.budget_name,
    ba.fiscal_year,
    pr.requested_amount,
    pr.status,
    pr.purpose
FROM purchase_requests pr
JOIN departments dept ON pr.department_id = dept.id
JOIN budget_allocations ba ON pr.budget_allocation_id = ba.id
JOIN budget_types bt ON ba.budget_type_id = bt.id
WHERE pr.status != 'DRAFT';

-- View สำหรับแฟ้ม Receipt
CREATE VIEW export_receipt AS
SELECT 
    r.receipt_number,
    r.receipt_date,
    r.po_id,
    po.po_number,
    ri.drug_id,
    d.drug_code,
    dg.working_code,
    dg.drug_name,
    ri.quantity_received,
    ri.unit_cost,
    ri.lot_number,
    ri.expiry_date,
    c.company_name as vendor
FROM receipts r
JOIN receipt_items ri ON r.id = ri.receipt_id
JOIN drugs d ON ri.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN purchase_orders po ON r.po_id = po.id
JOIN companies c ON po.vendor_id = c.id
WHERE r.status = 'POSTED';

-- View สำหรับแฟ้ม Distribution (หลังเพิ่มตาราง)
CREATE VIEW export_distribution AS
SELECT 
    dd.distribution_number,
    dd.distribution_date,
    dept.dept_name as requesting_department,
    ddi.drug_id,
    d.drug_code,
    dg.working_code,
    dg.drug_name,
    ddi.quantity_dispensed,
    ddi.unit_cost,
    ddi.lot_number,
    ddi.expiry_date,
    ddi.purpose
FROM drug_distributions dd
JOIN drug_distribution_items ddi ON dd.id = ddi.distribution_id
JOIN departments dept ON dd.requesting_dept_id = dept.id
JOIN drugs d ON ddi.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
WHERE dd.status = 'DISPENSED';

-- View สำหรับแฟ้ม Inventory
CREATE VIEW export_inventory AS
SELECT 
    dg.working_code,
    dg.drug_name,
    d.drug_code,
    d.trade_name,
    l.location_name,
    inv.quantity_on_hand,
    inv.min_level,
    inv.max_level,
    inv.average_cost,
    dl.lot_number,
    dl.expiry_date,
    dl.quantity_available,
    dl.unit_cost,
    CURRENT_DATE as report_date
FROM inventory inv
JOIN drugs d ON inv.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN locations l ON inv.location_id = l.id
LEFT JOIN drug_lots dl ON d.id = dl.drug_id AND l.id = dl.location_id
WHERE inv.quantity_on_hand > 0 AND dl.is_active = true;
```

### 📈 **สรุปความพร้อมหลังปรับปรุง**

| แฟ้มข้อมูล | ก่อนปรับปรุง | หลังปรับปรุง | การดำเนินการ |
|------------|-------------|-------------|-------------|
| **Druglist** | ✅ 100% | ✅ 100% | เพิ่ม TMT Code |
| **Purchase Plan** | ✅ 100% | ✅ 100% | พร้อมใช้งาน |
| **Receipt** | ✅ 100% | ✅ 100% | พร้อมใช้งาน |
| **Distribution** | ⚠️ 70% | ✅ 100% | เพิ่มตาราง Distribution |
| **Inventory** | ✅ 100% | ✅ 100% | พร้อมใช้งาน |

### 🎯 **ลำดับความสำคัญในการพัฒนา**

1. **เร่งด่วน**: เพิ่มตาราง `drug_distributions` และ `drug_distribution_items`
2. **สำคัญ**: เพิ่ม TMT Code และ NC24 Code ตามมาตรฐาน กสธ.
3. **ควรมี**: สร้าง Export Views สำหรับส่งออกข้อมูล 5 แฟ้ม
4. **เสริม**: API endpoints สำหรับ export ข้อมูลตามรูปแบบ กสธ.

**สรุป**: ระบบ INVS Modern มีความพร้อม **90%** ในการรองรับมาตรฐาน กสธ. ต้องเพิ่มเติมเฉพาะส่วน Distribution Management เท่านั้น

---

*เอกสารนี้จัดทำเพื่อประเมินความพร้อมของระบบ INVS Modern ในการรองรับมาตรฐานข้อมูลบริหารเวชภัณฑ์ของกระทรวงสาธารณสุข*