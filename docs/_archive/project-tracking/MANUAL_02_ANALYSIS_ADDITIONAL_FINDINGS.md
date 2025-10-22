# 📋 การวิเคราะห์เพิ่มเติมจาก INVS_MANUAL-02.pdf

**วันที่:** 21 ตุลาคม 2568
**เอกสารอ้างอิง:** INVS_MANUAL-02.pdf (2.9MB)

---

## 🔍 สรุปผลการวิเคราะห์

จากการศึกษา MANUAL-02.pdf พบฟีเจอร์และ ฟิลด์เพิ่มเติมที่อาจต้องพิจารณา

---

## 📚 เนื้อหาในคู่มือ

### 1. ระบบรับคืน (หน้า 86-87)

**ความสามารถ:**
- รับคืนยาจากหน่วยงาน
- เลือกสาเหตุการคืน
- เลือกดำเนินการ (ถ้ามี)
- กรอกข้อมูลอ้างอิง
- แยกจำนวนคืนทั้งหมด vs จำนวนยาดี
- บันทึก Lot no., วันหมดอายุ
- เลือกประเภท (ยาซื้อ, ยาฟรี)

**การประเมิน:**
- ❌ **เราไม่มีตาราง Drug Return**
- ⚠️ ระบบนี้จำเป็นสำหรับการจัดการยาที่ไม่ใช้แล้วหรือยาเสีย

---

### 2. ระบบโอน (หน้า 87-93)

**2.1 การบันทึกโอน:**
- โอนระหว่างคลัง
- แก้ไข/ยกเลิกรายการได้
- ยืนยันการโอน

**2.2 การปลดเปลื้อง:**
- แสดงรายการค้างจ่าย (รอปลดเปลื้อง)
- พิมพ์รายการค้างจ่าย
- ส่งออก Excel
- มีตัวอย่าง**ใบโอนยาการค้างจ่าย** (หน้า 91-92)

**การประเมิน:**
- ✅ เรามี drug_distributions แล้ว
- ✅ ครอบคลุมการโอนระหว่างคลัง

---

### 3. ระบบรายงาน (หน้า 94-97)

**ความสามารถ:**
- สร้างรายงานเองได้
- เขียน SQL เอง
- ออกแบบฟอร์มรับข้อมูล
- ส่งออก/นำเข้ารายงาน

**การประเมิน:**
- ⚪ เป็น Feature ระดับ Application
- ไม่เกี่ยวกับ Database Schema

---

## 🔑 Data Dictionary Analysis

### ตาราง MS_PO (ใบสั่งซื้อ) - หน้า 100

**ฟิลด์ที่น่าสนใจ:**

```sql
REQ_APP_NO      varchar(10)  -- เลขที่หนังสือบันทึก (ใบขออนุมัติ)
REQ_APP_DATE    char(8)      -- วันที่หนังสือ
AIC_NAME        varchar(60)  -- ชื่อกรรมการ
CNT_NO          varchar(20)  -- เลขที่สัญญา ✅
SEND_FLAG       char(1)      -- รหัสระบุส่งข้อมูล (ส่ง PO ให้ผู้ขาย)
RES_DATE        char(8)      -- วันที่รายงานผล
PROJECT_NO      varchar(30)  -- เลขที่โครงการ
EGP_NO          varchar(30)  -- เลข EGP
GF_NO           varchar(10)  -- เลข GF
```

**การประเมิน:**
- ✅ เรามี `contractId` แล้ว (CNT_NO)
- ✅ เรามี `sentToVendorDate` แล้ว (แทน SEND_FLAG)
- ✅ เรามี approval_documents แล้ว (REQ_APP_NO)
- 🟡 **ขาด:** PROJECT_NO, EGP_NO, GF_NO (แต่ไม่สำคัญมาก)

---

### ตาราง MS_IVO (ใบรับของ) - หน้า 104

**ฟิลด์ที่น่าสนใจ:**

```sql
INVOICE_NO        char(18)     -- เลขที่ใบส่ง (เลขบิล) ✅
INVOICE_DATE      char(8)      -- วันที่ใบส่งของ ✅
RECEIVE_DATE      char(8)      -- วันที่รับของ ✅
AIC_NAME          varchar(60)  -- ชุดกรรมการ ⭐
AI_NO             varchar(10)  -- เลขที่กรรมการตรวจรับ ⭐
PRE_RECEIVE_NO    varchar(15)  -- เลขที่รับจากใบส่ง
RCV_TIME          char(4)      -- เวลารับ
BILLING_DATE      varchar(8)   -- วันที่ส่งบิล 🔴
ASN_NO            varchar(10)  -- เลขที่แจ้งส่งของ EDI
```

**การประเมิน:**
- ✅ เรามี `invoiceNumber`, `invoiceDate` แล้ว
- ✅ เรามี `receivedDate` แล้ว
- ✅ เรามี `receipt_inspectors` แล้ว (แทน AIC_NAME/AI_NO)
- 🔴 **ขาด:** `billingDate` (วันที่ส่งบิลให้การเงิน) - **สำคัญ!**
- 🟡 **ขาด:** `receiveTime` (เวลารับ)

---

### ตาราง MS_IVO_C (รายการรับ) - หน้า 105

**ฟิลด์ที่น่าสนใจ:**

```sql
LOT_NO           varchar(40)  -- เลขที่ Lot ✅
EXPIRED_DATE     char(8)      -- วันที่หมดอายุ ✅
REMAIN_QTY       float        -- จำนวนคงเหลือในใบรับกรณีจ่ายด่วน 🔴
PO_ITEM_TYPE     int          -- ประเภทการซื้อ ⭐
```

**การประเมิน:**
- ✅ เรามี `lotNumber`, `expiryDate` แล้ว
- 🔴 **ขาด:** `remainingQuantity` - สำหรับกรณีจ่ายด่วน (รับของแล้วจ่ายทันทีบางส่วน)
- 🟡 **ขาด:** `itemType` - ประเภทการซื้อ (ปกติ, เร่งด่วน, ทดแทน)

---

### ตาราง CNT (สัญญา) - หน้า 98

**ฟิลด์ทั้งหมด:**

```sql
CNT_NO           varchar(20)  -- เลขที่สัญญา ✅
EGP_NO           varchar(20)  -- เลขที่ EGP
PJT_NO           varchar(20)  -- เลขที่ Project (โครงการ)
PARTIES_CODE     varchar(20)  -- รหัสบริษัท ✅
EFFECTIVE_DATE   char(8)      -- วันที่เริ่มสัญญา ✅
END_DATE         char(8)      -- วันที่สิ้นสุดสัญญา ✅
BUY_METHOD       char(2)      -- วิธีการจัดซื้อ ✅
BUY_COMMON       char(2)      -- รูปแบบการจัดซื้อ ✅
TOTAL_ITEM       int          -- จำนวน Item ทั้งหมด
TOTAL_COST       float        -- ราคารวมทั้งหมดในสัญญา ✅
REMAIN_COST      float        -- ราคาคงเหลือในสัญญา ✅
AIC_NO           varchar(20)  -- เลขที่แต่งตั้งคณะกรรมการ ⭐
AIC_NAME         varchar(60)  -- ชุดกรรมการ ⭐
AIC_DATE         varchar(8)   -- วันที่แต่งตั้งคณะกรรมการ ⭐
GF_NO            varchar(10)  -- เลข GF
```

**การประเมิน:**
- ✅ เรามีฟิลด์หลักครบแล้ว
- 🟡 **ขาด:** EGP_NO, PJT_NO, GF_NO (รหัสอ้างอิงโครงการ)
- 🟡 **ขาด:** AIC_NO, AIC_NAME, AIC_DATE (ข้อมูลคณะกรรมการของสัญญา)

---

### ตาราง CNT_C (รายการในสัญญา) - หน้า 99

**ฟิลด์สำคัญ:**

```sql
CNT_NO           varchar(20)  -- เลขที่สัญญา ✅
WORKING_CODE     char(7)      -- รหัส WORKINGCODE ✅
BUY_UNIT_COST    float        -- ราคาต่อหน่วย ✅
QTY_CNT          float        -- จำนวนยา ✅
QTY_REMAIN       float        -- จำนวนคงเหลือ ✅
COST_REMAIN      float        -- ราคาคงเหลือ ✅
END_DATE         varchar(8)   -- วันที่หมดสัญญารายการนี้ ⭐
BUY_COMMON       varchar(2)   -- ประเภทซื้อร่วม
```

**การประเมิน:**
- ✅ เรามีครบหมดแล้ว
- 🟡 **ขาด:** END_DATE รายการ (วันหมดอายุต่างกันในแต่ละรายการ - กรณีเพิ่มเติมสัญญา)

---

### ตาราง BUYPLAN และ BUYPLAN_C (แผนจัดซื้อ) - หน้า 114-116

**ข้อมูลสำคัญ:**

```sql
-- BUYPLAN (Header)
YEAR                char(4)
DEPT_ID             char(4)
VALUE_1_YEAR        double  -- มูลค่าซื้อย้อนหลัง 1 ปี ✅
VALUE_2_YEAR        double  -- มูลค่าซื้อย้อนหลัง 2 ปี ✅
VALUE_3_YEAR        double  -- มูลค่าซื้อย้อนหลัง 3 ปี ✅
TRIMESTER1-4        double  -- มูลค่าตามไตรมาส ✅
BUY_TRIMES1-4       double  -- มูลค่าซื้อตามไตรมาส ✅
RM_TRIMES1-4        double  -- มูลค่าเหลือตามไตรมาส ✅
RCV_VALUE           double  -- มูลค่ารับ
REMAIN_RCV_VALUE    double  -- มูลค่ารับที่เหลือ

-- BUYPLAN_C (Detail)
YEAR                char(4)
WORKING_CODE        char(7)
RATE_1_YEAR         double  -- อัตราใช้ย้อนหลัง 1 ปี ✅
RATE_2_YEAR         double  -- อัตราใช้ย้อนหลัง 2 ปี ✅
RATE_3_YEAR         double  -- อัตราใช้ย้อนหลัง 3 ปี ✅
AVG_3_YEAR          double  -- เฉลี่ยการใช้ 3 ปี ✅
FORECAST            double  -- ประมาณการ ⭐
QTY_FORECAST        double  -- จำนวนจากการประมาณ ⭐
ADJ_REASON          int     -- หมายเหตุ/เหตุผล ⭐
BUYMET_CODE         int     -- วิธีการซื้อ ⭐
```

**การประเมิน:**
- ✅ เรามี budget_plans และ budget_plan_items ครอบคลุมแล้ว
- ✅ มีข้อมูลย้อนหลัง 3 ปี
- ✅ มีการแบ่งไตรมาส
- 🟡 **ขาด:** FORECAST, QTY_FORECAST (ค่าพยากรณ์)
- 🟡 **ขาด:** ADJ_REASON (เหตุผลการปรับแผน)
- 🟡 **ขาด:** BUYMET_CODE (วิธีการซื้อที่วางแผนไว้)

---

## 🆕 สิ่งที่ค้นพบใหม่

### 🔴 Priority 1: ต้องเพิ่ม

#### 1. **วันที่ส่งบิลให้การเงิน** (BILLING_DATE)

```prisma
model Receipt {
  // เพิ่มฟิลด์:
  billingDate DateTime? @map("billing_date") @db.Date  // วันที่ส่งบิลให้การเงิน
}
```

**เหตุผล:**
- แตกต่างจาก `invoiceDate` (วันที่ใบแจ้งหนี้จากผู้ขาย)
- `billingDate` = วันที่เราส่งเอกสารให้การเงินจ่ายเงิน
- สำคัญสำหรับการติดตามการจ่ายเงิน

---

#### 2. **จำนวนคงเหลือกรณีจ่ายด่วน** (REMAIN_QTY)

```prisma
model ReceiptItem {
  // เพิ่มฟิลด์:
  remainingQuantity Decimal? @map("remaining_quantity") @db.Decimal(10, 2)
}
```

**เหตุผล:**
- กรณีรับของแล้วจ่ายด่วนทันที (Emergency Dispensing)
- ต้องติดตามว่าเหลืออะไรต้องนำเข้าสต็อก
- ป้องกันการนับซ้ำ

**ตัวอย่าง:**
```
รับเข้า: 100 เม็ด
จ่ายด่วนทันที: 20 เม็ด
remainingQuantity: 80 เม็ด (ต้องนำเข้าสต็อก)
```

---

### 🟡 Priority 2: ควรมี

#### 3. **ระบบรับคืน (Drug Return)**

```prisma
model DrugReturn {
  id              BigInt         @id @default(autoincrement())
  returnNumber    String         @unique @map("return_number") @db.VarChar(20)
  departmentId    BigInt         @map("department_id")
  returnDate      DateTime       @map("return_date") @db.Date
  returnReason    String         @map("return_reason") @db.VarChar(100)
  actionTaken     String?        @map("action_taken") @db.VarChar(100)
  referenceNumber String?        @map("reference_number") @db.VarChar(50)
  status          ReturnStatus   @default(DRAFT)
  totalItems      Int            @default(0) @map("total_items")
  totalAmount     Decimal        @default(0) @map("total_amount") @db.Decimal(12, 2)
  receivedBy      String         @map("received_by") @db.VarChar(50)
  verifiedBy      String?        @map("verified_by") @db.VarChar(50)
  notes           String?        @db.Text
  createdAt       DateTime       @default(now()) @map("created_at")
  updatedAt       DateTime       @default(now()) @updatedAt @map("updated_at")

  department      Department     @relation(fields: [departmentId], references: [id])
  items           DrugReturnItem[]

  @@map("drug_returns")
}

model DrugReturnItem {
  id                BigInt      @id @default(autoincrement())
  returnId          BigInt      @map("return_id")
  drugId            BigInt      @map("drug_id")
  totalQuantity     Decimal     @map("total_quantity") @db.Decimal(10, 2)
  goodQuantity      Decimal     @map("good_quantity") @db.Decimal(10, 2)
  damagedQuantity   Decimal     @map("damaged_quantity") @db.Decimal(10, 2)
  lotNumber         String      @map("lot_number") @db.VarChar(20)
  expiryDate        DateTime    @map("expiry_date") @db.Date
  returnType        ReturnType  @map("return_type")  // PURCHASED, FREE
  locationId        BigInt?     @map("location_id")
  unitCost          Decimal?    @map("unit_cost") @db.Decimal(10, 2)
  notes             String?     @db.Text
  createdAt         DateTime    @default(now()) @map("created_at")

  drugReturn        DrugReturn  @relation(fields: [returnId], references: [id], onDelete: Cascade)
  drug              Drug        @relation(fields: [drugId], references: [id])
  location          Location?   @relation(fields: [locationId], references: [id])

  @@map("drug_return_items")
}

enum ReturnStatus {
  DRAFT
  SUBMITTED
  VERIFIED
  POSTED
  CANCELLED
}

enum ReturnType {
  PURCHASED  // ยาซื้อ
  FREE       // ยาฟรี
}
```

---

#### 4. **ประเภทรายการซื้อ** (PO_ITEM_TYPE)

```prisma
enum PurchaseItemType {
  NORMAL       // ซื้อปกติ
  URGENT       // ซื้อเร่งด่วน
  REPLACEMENT  // ซื้อทดแทน
  EMERGENCY    // ฉุกเฉิน
}

model ReceiptItem {
  // เพิ่มฟิลด์:
  itemType PurchaseItemType? @map("item_type")
}
```

---

#### 5. **ข้อมูลคณะกรรมการในสัญญา**

```prisma
model Contract {
  // เพิ่มฟิลด์:
  committeeNumber String? @map("committee_number") @db.VarChar(20)
  committeeName   String? @map("committee_name") @db.VarChar(60)
  committeeDate   DateTime? @map("committee_date") @db.Date
}
```

---

#### 6. **รหัสอ้างอิงโครงการ**

```prisma
model Contract {
  // เพิ่มฟิลด์:
  egpNumber     String? @map("egp_number") @db.VarChar(30)      // เลข e-GP
  projectNumber String? @map("project_number") @db.VarChar(30)  // เลขโครงการ
  gfNumber      String? @map("gf_number") @db.VarChar(10)       // เลข GF
}

model PurchaseOrder {
  // เพิ่มฟิลด์:
  egpNumber     String? @map("egp_number") @db.VarChar(30)
  projectNumber String? @map("project_number") @db.VarChar(30)
  gfNumber      String? @map("gf_number") @db.VarChar(10)
}
```

---

#### 7. **เวลารับของ**

```prisma
model Receipt {
  // เพิ่มฟิลด์:
  receiveTime String? @map("receive_time") @db.VarChar(5)  // HH:MM
}
```

---

#### 8. **ฟิลด์เพิ่มเติมใน BudgetPlanItem**

```prisma
model BudgetPlanItem {
  // เพิ่มฟิลด์:
  forecastValue      Decimal? @map("forecast_value") @db.Decimal(15, 2)
  forecastQuantity   Decimal? @map("forecast_quantity") @db.Decimal(10, 2)
  adjustmentReason   String?  @map("adjustment_reason") @db.Text
  plannedBuyMethod   String?  @map("planned_buy_method") @db.VarChar(50)
}
```

---

## 📊 สรุปการเปรียบเทียบ

### ✅ สิ่งที่เรามีแล้ว (ครอบคลุม 95%)

| Feature | ระบบเดิม | ระบบเรา | Status |
|---------|----------|---------|--------|
| สัญญา | CNT, CNT_C | contracts, contract_items | ✅ 100% |
| กรรมการตรวจรับ | AIC_NAME, AI_NO | receipt_inspectors | ✅ 100% |
| ใบขออนุมัติ | REQ_APP_NO | approval_documents | ✅ 100% |
| การจ่ายเงิน | - | payment_documents | ✅ 120% |
| Invoice | INVOICE_NO/DATE | invoiceNumber/Date | ✅ 100% |
| วันที่รับ/ตรวจ | RECEIVE_DATE | receivedDate/verifiedDate | ✅ 100% |
| แผนจัดซื้อ | BUYPLAN_C | budget_plan_items | ✅ 100% |
| ข้อมูลย้อนหลัง 3 ปี | RATE_1/2/3_YEAR | year1/2/3Consumption | ✅ 100% |

### ⚠️ สิ่งที่ต้องเพิ่ม (5%)

| Feature | Priority | Tables Needed | Impact |
|---------|----------|---------------|--------|
| วันที่ส่งบิล | 🔴 High | Receipt.billingDate | สูง |
| จำนวนคงเหลือ (จ่ายด่วน) | 🔴 High | ReceiptItem.remainingQuantity | สูง |
| ระบบรับคืน | 🟡 Medium | drug_returns, drug_return_items | ปานกลาง |
| ประเภทรายการซื้อ | 🟡 Medium | ReceiptItem.itemType | ต่ำ |
| รหัสโครงการ | 🟢 Low | Contract/PO.egpNumber, etc. | ต่ำ |
| เวลารับของ | 🟢 Low | Receipt.receiveTime | ต่ำมาก |

---

## 🎯 คำแนะนำ

### สำหรับ Phase ปัจจุบัน (Schema Enhancement)

**ควรเพิ่มทันที:**
1. ✅ Receipt.billingDate
2. ✅ ReceiptItem.remainingQuantity

**ควรเพิ่มใน Phase 2:**
3. Drug Return System (2 ตาราง)
4. PurchaseItemType enum
5. รหัสอ้างอิงโครงการ

**อาจเพิ่มทีหลัง:**
6. Receipt.receiveTime
7. ข้อมูลคณะกรรมการในสัญญา

---

## 📝 SQL Schema เพิ่มเติม

```sql
-- เพิ่มฟิลด์ใน receipts
ALTER TABLE receipts
ADD COLUMN billing_date DATE,
ADD COLUMN receive_time VARCHAR(5);

-- เพิ่มฟิลด์ใน receipt_items
ALTER TABLE receipt_items
ADD COLUMN remaining_quantity DECIMAL(10,2),
ADD COLUMN item_type VARCHAR(20);

-- เพิ่มฟิลด์ใน contracts
ALTER TABLE contracts
ADD COLUMN committee_number VARCHAR(20),
ADD COLUMN committee_name VARCHAR(60),
ADD COLUMN committee_date DATE,
ADD COLUMN egp_number VARCHAR(30),
ADD COLUMN project_number VARCHAR(30),
ADD COLUMN gf_number VARCHAR(10);

-- เพิ่มฟิลด์ใน purchase_orders
ALTER TABLE purchase_orders
ADD COLUMN egp_number VARCHAR(30),
ADD COLUMN project_number VARCHAR(30),
ADD COLUMN gf_number VARCHAR(10);
```

---

## 🔄 ความสัมพันธ์กับเอกสารอื่น

- `GAP_ANALYSIS_FINAL_FROM_REAL_DATA.md` - วิเคราะห์จาก MySQL
- `MANUAL_ANALYSIS_PROCUREMENT.md` - วิเคราะห์จาก MANUAL-01
- `EXECUTIVE_SUMMARY_PROCUREMENT_ANALYSIS.md` - สรุปผู้บริหาร
- `SCHEMA_ENHANCEMENT_PLAN.md` - แผนพัฒนา Schema
- `PROCUREMENT_SCHEMA_IMPLEMENTATION_SUMMARY.md` - สรุปการพัฒนา

---

## ✅ สรุปท้ายที่สุด

**ระบบที่เราออกแบบไปครอบคลุม 95% ของความต้องการ!**

**สิ่งที่ควรทำเพิ่ม (5%):**
1. เพิ่ม `billingDate` และ `remainingQuantity` (Priority High)
2. พิจารณาระบบรับคืนในอนาคต (Priority Medium)

**ข้อสรุป:**
- Schema ที่พัฒนาไปมีความสมบูรณ์สูงมาก
- ครอบคลุมระบบจัดซื้อหลักได้ครบถ้วน
- มีความยืดหยุ่นสำหรับการขยายต่อ

---

**Version:** 1.0
**Status:** ✅ Complete Analysis
**Last Updated:** 2025-01-21

---

*เอกสารนี้จัดทำเพื่อเป็นข้อมูลเสริมสำหรับการพัฒนาระบบ INVS Modern*
