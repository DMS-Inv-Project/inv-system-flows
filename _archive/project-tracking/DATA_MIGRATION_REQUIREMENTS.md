# รายการข้อมูลที่ต้องขอจาก รพ. เพื่อ Data Migration

**เอกสารนี้:** ระบุรายการข้อมูลที่ต้องขอจากโรงพยาบาลเพื่อนำมา migrate เข้าระบบ INVS Modern

**วันที่:** 20 ตุลาคม 2568
**Version:** 1.0

---

## 📋 สารบัญ

1. [Master Data (ข้อมูลหลัก) - **จำเป็น**](#1-master-data-ข้อมูลหลัก---จำเป็น)
2. [Transaction Data (ข้อมูลธุรกรรม) - **แนะนำ**](#2-transaction-data-ข้อมูลธุรกรรม---แนะนำ)
3. [Historical Data (ข้อมูลย้อนหลัง) - **ถ้ามี**](#3-historical-data-ข้อมูลย้อนหลัง---ถ้ามี)
4. [Configuration Data (ข้อมูลตั้งค่า) - **จำเป็น**](#4-configuration-data-ข้อมูลตั้งค่า---จำเป็น)
5. [รูปแบบไฟล์ที่รองรับ](#รูปแบบไฟล์ที่รองรับ)
6. [Checklist สำหรับ รพ.](#checklist-สำหรับ-รพ)

---

## 1. Master Data (ข้อมูลหลัก) - **จำเป็น**

### 1.1 📍 ข้อมูลสถานที่จัดเก็บ (Locations)

**ตาราง:** `locations`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| รหัสคลัง | Location Code | MAIN, PHARM, OPD | ✅ |
| ชื่อคลัง | Location Name | คลังกลาง, คลังเภสัช | ✅ |
| ประเภทคลัง | Type | warehouse, pharmacy, ward, emergency | ✅ |
| คลังแม่ (ถ้ามี) | Parent Location | MAIN → PHARM (คลังย่อย) | ❌ |
| สถานที่ตั้ง | Physical Location | อาคาร A ชั้น 1 | ❌ |
| ผู้รับผิดชอบ | Responsible Person | นางสาว A, นาย B | ❌ |

**จำนวนที่คาดหวัง:** 5-20 คลัง

**ตัวอย่างข้อมูล:**
```csv
location_code,location_name,location_type,parent_location,physical_location,responsible_person
MAIN,คลังกลาง,warehouse,,อาคาร A ชั้น 1,นายสมชาย ใจดี
PHARM,คลังเภสัช,pharmacy,MAIN,อาคาร A ชั้น 2,นางสาวสมหญิง รักษ์ดี
OPD,คลังผู้ป่วยนอก,pharmacy,PHARM,อาคาร B ชั้น 1,นางสาวมาลี ดีงาม
```

---

### 1.2 🏢 ข้อมูลหน่วยงาน (Departments)

**ตาราง:** `departments`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| รหัสหน่วยงาน | Department Code | PHARM, MED, NURSE | ✅ |
| ชื่อหน่วยงาน | Department Name | แผนกเภสัชกรรม, แผนกแพทย์ | ✅ |
| รหัส HIS (ถ้ามี) | HIS Code | HIS-PHARM, HIS-MED | ⭐ |
| หน่วยงานแม่ (ถ้ามี) | Parent Department | - | ❌ |
| ผู้อำนวยการ/หัวหน้า | Head of Department | ภญ. สมหญิง, นพ. สมชาย | ❌ |

**จำนวนที่คาดหวัง:** 5-30 หน่วยงาน

**หมายเหตุ:** รหัส HIS (HIS Code) สำคัญมากสำหรับการเชื่อมต่อกับระบบ HIS เพื่อตัดจ่ายอัตโนมัติ

**ตัวอย่างข้อมูล:**
```csv
dept_code,dept_name,his_code,parent_dept,head_of_dept
PHARM,แผนกเภสัชกรรม,HIS-PHARM,,ภญ. สมหญิง ใจดี
MED,แผนกแพทย์,HIS-MED,,นพ. สมชาย รักษ์ดี
NURSE,แผนกพยาบาล,HIS-NURSE,,พยาบาลวิชาชีพ มาลี ดีงาม
LAB,แผนกห้องปฏิบัติการ,HIS-LAB,,นางสาวสุดา วิเคราะห์ดี
```

---

### 1.3 🏭 ข้อมูลบริษัท (Companies - Vendors/Manufacturers)

**ตาราง:** `companies`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| รหัสบริษัท | Company Code | 000001, V001 | ✅ |
| ชื่อบริษัท | Company Name | บริษัท ABC จำกัด | ✅ |
| ประเภท | Type | vendor, manufacturer, both | ✅ |
| เลขประจำตัวผู้เสียภาษี | Tax ID | 0123456789012 | ⭐ |
| ชื่อบัญชีธนาคาร | Bank Account Name | บริษัท ABC จำกัด | ⭐ |
| ธนาคาร | Bank Name | กรุงไทย, กสิกร, ไทยพาณิชย์ | ⭐ |
| เลขที่บัญชี | Bank Account Number | 1234567890 | ⭐ |
| ที่อยู่ | Address | 123 ถนนสุขุมวิท กรุงเทพฯ | ✅ |
| โทรศัพท์ | Phone | 02-123-4567 | ✅ |
| อีเมล | Email | contact@abc.co.th | ❌ |
| ผู้ติดต่อ | Contact Person | นายสมชาย ขายดี | ❌ |

**จำนวนที่คาดหวัง:** 50-500 บริษัท

**หมายเหตุ:** ข้อมูลธนาคารสำคัญมากสำหรับการจ่ายเงิน

**ตัวอย่างข้อมูล:**
```csv
company_code,company_name,type,tax_id,bank_account,bank_name,account_number,address,phone,email,contact_person
000001,บริษัท GPO จำกัด,both,0994000158378,บริษัท GPO จำกัด,กรุงไทย,3722699075,"75/1 ถนนพระราม 6 กรุงเทพฯ",02-203-8000,info@gpo.or.th,นายสมชาย ขายดี
000002,บริษัท Zuellig จำกัด,vendor,0105536041974,บริษัท Zuellig จำกัด,กสิกร,4561234567,"3199 ถนนพระราม 4 กรุงเทพฯ",02-367-8100,thailand@zuellig.com,นางสาวมาลี ติดต่อดี
```

---

### 1.4 💊 ข้อมูลยา Generic (Drug Generics)

**ตาราง:** `drug_generics`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| รหัส Working Code | Working Code | PAR0001, AMX0001 | ✅ |
| ชื่อยา Generic | Drug Name | Paracetamol, Amoxicillin | ✅ |
| รูปแบบยา | Dosage Form | Tablet, Capsule, Injection | ✅ |
| รหัสรูปแบบยา | Dosage Form Code | TAB, CAP, INJ | ✅ |
| สารสำคัญ | Active Ingredient | Paracetamol 500mg | ❌ |
| ความแรง | Strength | 500 | ❌ |
| หน่วยความแรง | Strength Unit | mg, g, ml | ❌ |

**จำนวนที่คาดหวัง:** 500-5,000 รายการ

**ตัวอย่างข้อมูล:**
```csv
working_code,drug_name,dosage_form,form_code,active_ingredient,strength,strength_unit
PAR0001,Paracetamol,Tablet,TAB,Paracetamol,500,mg
AMX0001,Amoxicillin,Capsule,CAP,Amoxicillin trihydrate,250,mg
ASP0001,Aspirin,Tablet,TAB,Acetylsalicylic acid,100,mg
```

---

### 1.5 💊 ข้อมูลยา Trade Name (Drugs)

**ตาราง:** `drugs`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| รหัสยา | Drug Code | PAR0001-000001-001 | ✅ |
| ชื่อยา (Trade Name) | Trade Name | GPO Paracetamol 500mg | ✅ |
| รหัส Generic | Generic/Working Code | PAR0001 | ✅ |
| ความแรง | Strength | 500mg | ✅ |
| รูปแบบยา | Dosage Form | Tablet | ✅ |
| ผู้ผลิต | Manufacturer ID/Code | 000001 (GPO) | ✅ |
| รหัส TMT (ถ้ามี) | TMT Code | N02BE01 | ❌ |
| FDA Code (ถ้ามี) | FDA Registration | 1A 12/12345 | ❌ |
| Barcode | Barcode/EAN | 8851234567890 | ❌ |
| ขนาดบรรจุ | Pack Size | 1000 | ⭐ |
| **ราคาต่อหน่วย** | Unit Price | 1.50 | ⭐ |
| หน่วย | Unit | TAB, CAP, VIAL | ✅ |

**จำนวนที่คาดหวัง:** 1,000-10,000 รายการ

**หมายเหตุ:**
- ราคาต่อหน่วยสำคัญมากสำหรับการคำนวณงบประมาณ
- ขนาดบรรจุสำคัญสำหรับการสั่งซื้อ

**ตัวอย่างข้อมูล:**
```csv
drug_code,trade_name,generic_code,strength,dosage_form,manufacturer_code,tmt_code,fda_code,barcode,pack_size,unit_price,unit
PAR0001-000001-001,GPO Paracetamol 500mg,PAR0001,500mg,Tablet,000001,N02BE01,1A 12/12345,8851234567890,1000,1.50,TAB
AMX0001-000002-001,Zuellig Amoxicillin 250mg,AMX0001,250mg,Capsule,000002,J01CA04,1A 12/23456,8851234567892,1000,3.00,CAP
```

---

### 1.6 💰 ข้อมูลงบประมาณ (Budget System)

#### 1.6.1 ประเภทงบประมาณ (Budget Types)

**ตาราง:** `budget_types`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| รหัสประเภทงบ | Type Code | 01, 02, 03 | ✅ |
| ชื่อประเภทงบ | Type Name | งบเงินบำรุง, งบลงทุน | ✅ |

**ตัวอย่างข้อมูล:**
```csv
type_code,type_name
01,งบเงินบำรุง
02,งบลงทุน
03,งบบุคลากร
```

#### 1.6.2 หมวดค่าใช้จ่าย (Budget Categories)

**ตาราง:** `budget_categories`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| รหัสหมวด | Category Code | 0101, 0102, 0103 | ✅ |
| ชื่อหมวด | Category Name | เวชภัณฑ์ไม่ใช่ยา, ยา | ✅ |
| รหัสบัญชี | Accounting Code | 1105010103.101 | ⭐ |
| คำอธิบาย | Description | หมวดค่าใช้จ่ายเกี่ยวกับยา | ❌ |

**ตัวอย่างข้อมูล:**
```csv
category_code,category_name,acc_code,description
0101,เวชภัณฑ์ไม่ใช่ยา,1105010103.102,หมวดค่าใช้จ่ายเกี่ยวกับเวชภัณฑ์ไม่ใช่ยา
0102,ยา,1105010103.101,หมวดค่าใช้จ่ายเกี่ยวกับยา
0103,เครื่องมือแพทย์,1105010103.103,หมวดค่าใช้จ่ายเกี่ยวกับเครื่องมือทางการแพทย์
```

#### 1.6.3 งบประมาณหลัก (Budgets)

**ตาราง:** `budgets`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| รหัสงบประมาณ | Budget Code | OP001, OP002 | ✅ |
| ประเภทงบ | Budget Type Code | 01 (งบเงินบำรุง) | ✅ |
| หมวดค่าใช้จ่าย | Category Code | 0102 (ยา) | ✅ |
| คำอธิบาย | Description | งบประมาณสำหรับซื้อยา | ✅ |

**ตัวอย่างข้อมูล:**
```csv
budget_code,budget_type,budget_category,description
OP001,01,0101,งบประมาณสำหรับซื้อเวชภัณฑ์ไม่ใช่ยา
OP002,01,0102,งบประมาณสำหรับซื้อยา
```

---

## 2. Transaction Data (ข้อมูลธุรกรรม) - **แนะนำ**

### 2.1 📦 ข้อมูลคงคลังปัจจุบัน (Current Inventory)

**ตาราง:** `inventory`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| รหัสยา | Drug Code | PAR0001-000001-001 | ✅ |
| รหัสคลัง | Location Code | MAIN, PHARM | ✅ |
| จำนวนคงคลัง | Quantity On Hand | 5000 | ✅ |
| จุดสั่งซื้อ | Reorder Point | 1000 | ⭐ |
| จำนวนขั้นต่ำ | Min Level | 500 | ❌ |
| จำนวนสูงสุด | Max Level | 10000 | ❌ |

**ตัวอย่างข้อมูล:**
```csv
drug_code,location_code,quantity_on_hand,reorder_point,min_level,max_level
PAR0001-000001-001,MAIN,5000,1000,500,10000
PAR0001-000001-001,PHARM,500,200,100,1000
AMX0001-000002-001,MAIN,3000,800,400,8000
```

---

### 2.2 🏷️ ข้อมูล Lot ที่มีอยู่ (Drug Lots)

**ตาราง:** `drug_lots`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| รหัสยา | Drug Code | PAR0001-000001-001 | ✅ |
| เลข Lot | Lot Number | LOT2024001 | ✅ |
| วันหมดอายุ | Expiry Date | 2025-12-31 | ✅ |
| รหัสคลัง | Location Code | MAIN | ✅ |
| จำนวนคงเหลือ | Quantity Remaining | 1000 | ✅ |
| วันที่รับเข้า | Received Date | 2024-01-15 | ❌ |
| ราคาต่อหน่วย | Unit Cost | 1.50 | ❌ |

**ตัวอย่างข้อมูล:**
```csv
drug_code,lot_number,expiry_date,location_code,quantity_remaining,received_date,unit_cost
PAR0001-000001-001,LOT2024001,2025-12-31,MAIN,1000,2024-01-15,1.50
PAR0001-000001-001,LOT2024002,2026-06-30,MAIN,1500,2024-06-20,1.50
AMX0001-000002-001,LOT2024003,2025-09-30,PHARM,800,2024-03-10,3.00
```

---

### 2.3 💰 ข้อมูลการจัดสรรงบประมาณ (Budget Allocations)

**ตาราง:** `budget_allocations`

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| ปีงบประมาณ | Fiscal Year | 2025, 2568 | ✅ |
| รหัสงบประมาณ | Budget Code | OP002 | ✅ |
| รหัสหน่วยงาน | Department Code | PHARM | ✅ |
| งบรวมทั้งปี | Total Allocated | 10000000.00 | ✅ |
| งบไตรมาส 1 | Q1 Budget | 2500000.00 | ⭐ |
| งบไตรมาส 2 | Q2 Budget | 2500000.00 | ⭐ |
| งบไตรมาส 3 | Q3 Budget | 2500000.00 | ⭐ |
| งบไตรมาส 4 | Q4 Budget | 2500000.00 | ⭐ |

**ตัวอย่างข้อมูล:**
```csv
fiscal_year,budget_code,department_code,total_allocated,q1_budget,q2_budget,q3_budget,q4_budget
2025,OP002,PHARM,10000000.00,2500000.00,2500000.00,2500000.00,2500000.00
2025,OP001,MED,5000000.00,1250000.00,1250000.00,1250000.00,1250000.00
```

---

## 3. Historical Data (ข้อมูลย้อนหลัง) - **ถ้ามี**

### 3.1 📊 ข้อมูลการใช้ยาย้อนหลัง (Drug Usage History)

**วัตถุประสงค์:** สำหรับวิเคราะห์และวางแผนงบประมาณ

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| ปี | Year | 2024, 2023, 2022 | ✅ |
| เดือน | Month | 1-12 | ✅ |
| รหัสยา | Drug Code | PAR0001-000001-001 | ✅ |
| จำนวนที่ใช้ | Quantity Used | 5000 | ✅ |
| มูลค่า | Value | 7500.00 | ❌ |

**ระยะเวลาที่ต้องการ:** 3 ปีย้อนหลัง (ถ้ามี)

**ตัวอย่างข้อมูล:**
```csv
year,month,drug_code,quantity_used,value
2024,1,PAR0001-000001-001,5000,7500.00
2024,2,PAR0001-000001-001,4800,7200.00
2023,12,PAR0001-000001-001,5200,7800.00
```

---

### 3.2 📋 ข้อมูลการสั่งซื้อย้อนหลัง (Purchase History)

**วัตถุประสงค์:** สำหรับวิเคราะห์ผู้ขายและราคา

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| วันที่สั่งซื้อ | Order Date | 2024-01-15 | ✅ |
| เลขที่ PO | PO Number | PO2024001 | ✅ |
| รหัสผู้ขาย | Vendor Code | 000001 | ✅ |
| รหัสยา | Drug Code | PAR0001-000001-001 | ✅ |
| จำนวน | Quantity | 10000 | ✅ |
| ราคาต่อหน่วย | Unit Price | 1.50 | ✅ |
| มูลค่ารวม | Total Amount | 15000.00 | ❌ |

**ระยะเวลาที่ต้องการ:** 1-2 ปีย้อนหลัง (ถ้ามี)

---

## 4. Configuration Data (ข้อมูลตั้งค่า) - **จำเป็น**

### 4.1 👤 ข้อมูลผู้ใช้งาน (Users)

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง | จำเป็น |
|----------------|---------|---------|--------|
| Username | ชื่อผู้ใช้ | somchai.j, malee.d | ✅ |
| ชื่อ-นามสกุล | Full Name | นายสมชาย ใจดี | ✅ |
| อีเมล | Email | somchai@hospital.go.th | ⭐ |
| หน่วยงาน | Department | PHARM, MED | ✅ |
| ตำแหน่ง | Position | เภสัชกร, พยาบาล | ✅ |
| Role | Role | admin, pharmacist, user | ✅ |

**ตัวอย่างข้อมูล:**
```csv
username,full_name,email,department,position,role
somchai.j,นายสมชาย ใจดี,somchai.j@hospital.go.th,PHARM,เภสัชกร,pharmacist
malee.d,นางสาวมาลี ดีงาม,malee.d@hospital.go.th,PHARM,ผู้ช่วยเภสัชกร,user
admin,ผู้ดูแลระบบ,admin@hospital.go.th,IT,ผู้ดูแลระบบ,admin
```

---

### 4.2 ⚙️ ข้อมูลการตั้งค่า (System Settings)

| ฟิลด์ที่ต้องการ | คำอธิบาย | ตัวอย่าง |
|----------------|---------|---------|
| ชื่อโรงพยาบาล | Hospital Name | โรงพยาบาลบ้านโป่ง |
| ที่อยู่ | Hospital Address | 123 ถนนเพชรเกษม อ.บ้านโป่ง |
| โทรศัพท์ | Hospital Phone | 032-123456 |
| รหัส HIS (ถ้ามี) | HIS System Code | HIS-001 |
| URL HIS API (ถ้ามี) | HIS API URL | http://his.hospital.local/api |

---

## รูปแบบไฟล์ที่รองรับ

### ✅ รูปแบบที่แนะนำ (เรียงตามลำดับความสะดวก)

1. **CSV (UTF-8)** ⭐ แนะนำ
   - ง่ายที่สุด, import ได้เร็ว
   - ต้องเป็น UTF-8 เพื่อรองรับภาษาไทย

2. **Excel (.xlsx)**
   - สะดวกสำหรับ รพ.
   - แต่ละ sheet = แต่ละตาราง

3. **SQL Dump (.sql)**
   - สำหรับระบบที่ใช้ PostgreSQL/MySQL อยู่แล้ว
   - import ได้เร็วที่สุด

4. **JSON**
   - สำหรับระบบที่มี API

### ❌ รูปแบบที่ไม่แนะนำ
- PDF (ไม่สามารถ import อัตโนมัติได้)
- Image/Scan (ต้องพิมพ์ข้อมูลใหม่)
- Word Document (ยากต่อการ import)

---

## Checklist สำหรับ รพ.

### ✅ ขั้นตอนการเตรียมข้อมูล

#### Phase 1: Master Data (สัปดาห์ที่ 1-2)
- [ ] 1. รวบรวมข้อมูลสถานที่จัดเก็บ (Locations)
- [ ] 2. รวบรวมข้อมูลหน่วยงาน (Departments) **พร้อมรหัส HIS**
- [ ] 3. รวบรวมข้อมูลบริษัท (Companies) **พร้อมข้อมูลธนาคาร**
- [ ] 4. Export ข้อมูลยา Generic (Drug Generics)
- [ ] 5. Export ข้อมูลยา Trade Name (Drugs) **พร้อมราคา**
- [ ] 6. รวบรวมข้อมูลงบประมาณ (Budget System)

#### Phase 2: Transaction Data (สัปดาห์ที่ 3)
- [ ] 7. Export ข้อมูลคงคลังปัจจุบัน (Current Inventory)
- [ ] 8. Export ข้อมูล Lot ที่มีอยู่ (Drug Lots)
- [ ] 9. Export ข้อมูลการจัดสรรงบประมาณ (Budget Allocations)

#### Phase 3: Historical Data (สัปดาห์ที่ 4) - Optional
- [ ] 10. Export ข้อมูลการใช้ยาย้อนหลัง 3 ปี (ถ้ามี)
- [ ] 11. Export ข้อมูลการสั่งซื้อย้อนหลัง 1-2 ปี (ถ้ามี)

#### Phase 4: Configuration (สัปดาห์ที่ 4)
- [ ] 12. จัดทำรายชื่อผู้ใช้งาน (Users)
- [ ] 13. กำหนด Role และ Permission
- [ ] 14. รวบรวมข้อมูลการตั้งค่าระบบ

---

## 📊 สรุปลำดับความสำคัญ

### 🔴 **ลำดับ 1 - จำเป็นมาก (ไม่มีทำงานไม่ได้)**
1. ข้อมูลยา (Drugs) พร้อมราคา
2. ข้อมูลคลัง (Locations)
3. ข้อมูลหน่วยงาน (Departments) พร้อมรหัส HIS
4. ข้อมูลบริษัท (Companies) พร้อมข้อมูลธนาคาร

### 🟡 **ลำดับ 2 - แนะนำมาก (มีจะทำงานได้ดีขึ้น)**
5. ข้อมูลคงคลังปัจจุบัน (Current Inventory)
6. ข้อมูล Lot ที่มีอยู่ (Drug Lots)
7. ข้อมูลงบประมาณ (Budget System)
8. ข้อมูลผู้ใช้งาน (Users)

### 🟢 **ลำดับ 3 - มีดีมาก (สำหรับวิเคราะห์และวางแผน)**
9. ข้อมูลการใช้ยาย้อนหลัง 3 ปี
10. ข้อมูลการสั่งซื้อย้อนหลัง 1-2 ปี

---

## 📧 ติดต่อสอบถาม

หากมีข้อสงสัยเกี่ยวกับข้อมูลที่ต้องการ กรุณาติดต่อ:

- **ทีมพัฒนา INVS:** invs-dev@team.local
- **โทรศัพท์:** 02-XXX-XXXX
- **Line:** @invs-support

---

## 📎 ไฟล์ตัวอย่าง

ดาวน์โหลดไฟล์ตัวอย่าง (Template):
- [📥 CSV Templates (All Tables)](./templates/csv/)
- [📥 Excel Template (All Sheets)](./templates/INVS_Data_Template.xlsx)

---

**Version:** 1.0
**วันที่สร้าง:** 20 ตุลาคม 2568
**ผู้จัดทำ:** INVS Development Team
**สถานะ:** ✅ พร้อมใช้งาน

---

*เอกสารนี้จัดทำขึ้นเพื่อใช้ในการประสานงานกับโรงพยาบาลสำหรับการ migrate ข้อมูลเข้าระบบ INVS Modern*
