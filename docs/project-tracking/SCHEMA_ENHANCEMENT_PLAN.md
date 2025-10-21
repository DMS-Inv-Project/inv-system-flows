# 🎯 แผนพัฒนา Schema ระบบจัดซื้อ INVS Modern

**วันที่:** 20 ตุลาคม 2568
**Version:** 1.0 (Action Plan)
**สถานะ:** 🔄 Ready to Implement

---

## 📊 ข้อมูลจากระบบเดิม (MySQL)

| ตาราง | Records | ความสำคัญ | สถานะระบบเรา |
|-------|---------|-----------|-------------|
| **cnt** (สัญญา) | 2 | ⭐⭐⭐ | ❌ ไม่มี |
| **cnt_c** (รายการสัญญา) | 2 | ⭐⭐⭐ | ❌ ไม่มี |
| **sm_po** (Sub PO) | 1,793 | ⭐⭐⭐ | 🟡 มีแต่ไม่ครบ |
| **sm_po_c** (Sub PO Items) | 21,275 | ⭐⭐⭐ | 🟡 มีแต่ไม่ครบ |
| **ms_po** (Main PO) | 1,552 | ⭐⭐ | 🟡 มีแต่ไม่ครบ |
| **buyplan** (แผนจัดซื้อ) | 3 | ⭐⭐ | ✅ มีแล้ว |
| **buyplan_c** (รายการแผน) | 1,642 | ⭐⭐ | ✅ มีแล้ว |
| **quali_rcv** (ตรวจรับ) | 0 | ⭐⭐⭐ | ❌ ไม่มี |

---

## 🎯 Feature ที่ยังขาดทั้งหมด

### 🔴 **Priority 1: Critical (ต้องมี 100%)**

#### 1. ระบบสัญญา (Contract Management System)

**ตารางใหม่:**
- ✅ `contracts` - สัญญาหลัก
- ✅ `contract_items` - รายการในสัญญา

**Features:**
```
✅ บันทึกสัญญาจัดซื้อ (ตกลงราคา, e-bidding, สอบราคา)
✅ กำหนดรายการยาและราคาในสัญญา
✅ ติดตามวงเงินสัญญา (ใช้ไป/คงเหลือ)
✅ แจ้งเตือนสัญญาใกล้หมดอายุ
✅ ดึงราคาจากสัญญามาใส่ PO อัตโนมัติ
✅ เช็คว่าซื้อเกินสัญญาหรือไม่
```

---

#### 2. กรรมการตรวจรับ (Inspection Committee)

**ตารางใหม่:**
- ✅ `receipt_inspectors` - กรรมการตรวจรับ 3 คน

**แก้ไข:**
- ✅ เพิ่มฟิลด์ใน `receipts`: invoice_number, invoice_date, received_date, verified_date, posted_date

**Features:**
```
✅ บันทึกกรรมการหลายคน (ประธาน, กรรมการ, เลขา)
✅ ลายเซ็นกรรมการ (signature_path)
✅ Timeline แยกชัดเจน (รับ → ตรวจรับ → ยืนยัน)
✅ พิมพ์ใบตรวจรับที่มีข้อมูลกรรมการครบ
```

---

#### 3. ใบขออนุมัติแยกต่างหาก (Approval Documents)

**ตารางใหม่:**
- ✅ `approval_documents` - ใบขออนุมัติ (เลขที่แยกจาก PO)

**Features:**
```
✅ เลขที่ใบอนุมัติแยกจาก PO
✅ บันทึกครั้งเดียวได้ 2 เอกสาร (PO + Approval)
✅ Approval workflow (หลายระดับ)
✅ Approval history log
```

---

#### 4. ติดตามการจ่ายเงิน (Payment Tracking)

**ตารางใหม่:**
- ✅ `payment_documents` - เอกสารการจ่ายเงิน
- ✅ `payment_attachments` - ไฟล์แนบเอกสาร

**Features:**
```
✅ ติดตามสถานะการจ่ายเงิน (PENDING, APPROVED, PAID)
✅ ทราบว่าส่งเอกสารให้การเงินแล้วหรือยัง
✅ ทราบว่าการเงินจ่ายเงินแล้วหรือยัง
✅ เก็บไฟล์แนบเอกสาร (PO, Receipt, Invoice, etc.)
```

---

### 🟡 **Priority 2: Important (ควรมี)**

#### 5. เพิ่มฟิลด์ใน PO

**แก้ไข `purchase_orders`:**
```
✅ contract_id - อ้างอิงสัญญา
✅ sent_to_vendor_date - วันที่ส่งให้ผู้ขาย
✅ printed_date - วันที่พิมพ์
✅ confirmed_by - ผู้ยืนยัน
✅ confirmed_date - วันที่ยืนยัน
```

---

#### 6. เพิ่มฟิลด์ใน Budget Plan Items

**แก้ไข `budget_plan_items`:**
```
✅ q1_received, q2_received, q3_received, q4_received
✅ forecast_quantity
✅ current_stock
```

---

#### 7. ระบบแนะนำ "ควรซื้ออะไร?" (Reorder Suggestions)

**VIEW ใหม่:**
- ✅ `reorder_suggestions` - แนะนำยาที่ควรสั่งซื้อ

**Functions ใหม่:**
- ✅ `calculate_suggested_quantity()`
- ✅ `get_average_usage()`
- ✅ `get_last_purchase_info()`

---

## 📝 Schema ใหม่ทั้งหมด (Prisma)

### 1. Contracts (สัญญา)

```prisma
model Contract {
  id                BigInt            @id @default(autoincrement())
  contractNumber    String            @unique @map("contract_number") @db.VarChar(20)
  contractType      ContractType      @map("contract_type") // E_BIDDING, PRICE_AGREEMENT, QUOTATION, SPECIAL
  vendorId          BigInt            @map("vendor_id")
  startDate         DateTime          @map("start_date") @db.Date
  endDate           DateTime          @map("end_date") @db.Date
  totalValue        Decimal           @map("total_value") @db.Decimal(15, 2)
  remainingValue    Decimal           @map("remaining_value") @db.Decimal(15, 2)
  paymentTerms      String?           @map("payment_terms") @db.Text
  warrantyPeriod    String?           @map("warranty_period") @db.VarChar(50)
  fiscalYear        String            @map("fiscal_year") @db.VarChar(4)
  status            ContractStatus    @default(ACTIVE) // DRAFT, ACTIVE, EXPIRED, CANCELLED
  remarks           String?           @db.Text
  createdBy         BigInt?           @map("created_by")
  approvedBy        BigInt?           @map("approved_by")
  approvalDate      DateTime?         @map("approval_date") @db.Date
  createdAt         DateTime          @default(now()) @map("created_at")
  updatedAt         DateTime          @default(now()) @updatedAt @map("updated_at")

  // Relations
  vendor            Company           @relation(fields: [vendorId], references: [id])
  items             ContractItem[]
  purchaseOrders    PurchaseOrder[]

  @@map("contracts")
}

model ContractItem {
  id                  BigInt    @id @default(autoincrement())
  contractId          BigInt    @map("contract_id")
  drugId              BigInt    @map("drug_id")
  unitPrice           Decimal   @map("unit_price") @db.Decimal(10, 2)
  quantityContracted  Decimal   @map("quantity_contracted") @db.Decimal(10, 2)
  quantityRemaining   Decimal   @map("quantity_remaining") @db.Decimal(10, 2)
  valueContracted     Decimal   @map("value_contracted") @db.Decimal(15, 2)
  valueRemaining      Decimal   @map("value_remaining") @db.Decimal(15, 2)
  discountPercent     Decimal?  @map("discount_percent") @db.Decimal(5, 2)
  notes               String?   @db.Text
  createdAt           DateTime  @default(now()) @map("created_at")

  // Relations
  contract            Contract  @relation(fields: [contractId], references: [id], onDelete: Cascade)
  drug                Drug      @relation(fields: [drugId], references: [id])

  @@unique([contractId, drugId])
  @@map("contract_items")
}

enum ContractType {
  E_BIDDING
  PRICE_AGREEMENT
  QUOTATION
  SPECIAL
}

enum ContractStatus {
  DRAFT
  ACTIVE
  EXPIRED
  CANCELLED
}
```

---

### 2. Receipt Inspectors (กรรมการตรวจรับ)

```prisma
model ReceiptInspector {
  id                BigInt    @id @default(autoincrement())
  receiptId         BigInt    @map("receipt_id")
  inspectorName     String    @map("inspector_name") @db.VarChar(100)
  inspectorPosition String?   @map("inspector_position") @db.VarChar(100)
  inspectorRole     InspectorRole @map("inspector_role") // CHAIRMAN, MEMBER, SECRETARY
  signedDate        DateTime? @map("signed_date")
  signaturePath     String?   @map("signature_path") @db.VarChar(255)
  remarks           String?   @db.Text
  createdAt         DateTime  @default(now()) @map("created_at")

  // Relations
  receipt           Receipt   @relation(fields: [receiptId], references: [id], onDelete: Cascade)

  @@map("receipt_inspectors")
}

enum InspectorRole {
  CHAIRMAN
  MEMBER
  SECRETARY
}

// แก้ไข Receipt model ที่มีอยู่
model Receipt {
  // ... existing fields ...
  invoiceNumber     String?             @map("invoice_number") @db.VarChar(50)
  invoiceDate       DateTime?           @map("invoice_date") @db.Date
  receivedDate      DateTime?           @map("received_date")
  verifiedDate      DateTime?           @map("verified_date")
  postedDate        DateTime?           @map("posted_date")

  // Relations
  inspectors        ReceiptInspector[]  // เพิ่ม relation
  paymentDocuments  PaymentDocument[]   // เพิ่ม relation
}

// แก้ไข enum ReceiptStatus
enum ReceiptStatus {
  DRAFT                  // บันทึกรับแล้ว รอพิมพ์ใบตรวจรับ
  PENDING_VERIFICATION   // ส่งให้กรรมการแล้ว รอตรวจรับ ⭐ เพิ่มใหม่
  VERIFIED              // กรรมการตรวจรับเรียบร้อย
  POSTED                // ยืนยันในระบบแล้ว คงคลังเพิ่ม
}
```

---

### 3. Approval Documents (ใบขออนุมัติ)

```prisma
model ApprovalDocument {
  id                  BigInt          @id @default(autoincrement())
  approvalDocNumber   String          @unique @map("approval_doc_number") @db.VarChar(20)
  poId                BigInt          @map("po_id")
  approvalType        ApprovalType    @default(NORMAL) @map("approval_type")
  requestedBy         BigInt          @map("requested_by")
  requestedDate       DateTime        @map("requested_date") @db.Date
  approvedBy          BigInt?         @map("approved_by")
  approvalDate        DateTime?       @map("approval_date") @db.Date
  approvalRemarks     String?         @map("approval_remarks") @db.Text
  status              ApprovalStatus  @default(PENDING)
  documentPath        String?         @map("document_path") @db.VarChar(255)
  createdAt           DateTime        @default(now()) @map("created_at")
  updatedAt           DateTime        @default(now()) @updatedAt @map("updated_at")

  // Relations
  purchaseOrder       PurchaseOrder   @relation(fields: [poId], references: [id])

  @@map("approval_documents")
}

enum ApprovalType {
  NORMAL
  URGENT
  SPECIAL
}

enum ApprovalStatus {
  PENDING
  APPROVED
  REJECTED
  CANCELLED
}
```

---

### 4. Payment Documents (การจ่ายเงิน)

```prisma
model PaymentDocument {
  id                      BigInt              @id @default(autoincrement())
  paymentDocNumber        String              @unique @map("payment_doc_number") @db.VarChar(20)
  receiptId               BigInt              @map("receipt_id")
  poId                    BigInt              @map("po_id")
  vendorId                BigInt              @map("vendor_id")
  totalAmount             Decimal             @map("total_amount") @db.Decimal(15, 2)
  submittedToFinanceDate  DateTime?           @map("submitted_to_finance_date") @db.Date
  approvedDate            DateTime?           @map("approved_date") @db.Date
  paidDate                DateTime?           @map("paid_date") @db.Date
  paymentStatus           PaymentStatus       @default(PENDING) @map("payment_status")
  paymentMethod           String?             @map("payment_method") @db.VarChar(50)
  paymentReference        String?             @map("payment_reference") @db.VarChar(100)
  remarks                 String?             @db.Text
  createdAt               DateTime            @default(now()) @map("created_at")
  updatedAt               DateTime            @default(now()) @updatedAt @map("updated_at")

  // Relations
  receipt                 Receipt             @relation(fields: [receiptId], references: [id])
  purchaseOrder           PurchaseOrder       @relation(fields: [poId], references: [id])
  vendor                  Company             @relation(fields: [vendorId], references: [id])
  attachments             PaymentAttachment[]

  @@map("payment_documents")
}

model PaymentAttachment {
  id                BigInt          @id @default(autoincrement())
  paymentDocId      BigInt          @map("payment_doc_id")
  attachmentType    AttachmentType  @map("attachment_type")
  fileName          String          @map("file_name") @db.VarChar(255)
  filePath          String          @map("file_path") @db.VarChar(500)
  fileSize          BigInt?         @map("file_size")
  uploadedAt        DateTime        @default(now()) @map("uploaded_at")
  uploadedBy        BigInt?         @map("uploaded_by")

  // Relations
  paymentDocument   PaymentDocument @relation(fields: [paymentDocId], references: [id], onDelete: Cascade)

  @@map("payment_attachments")
}

enum PaymentStatus {
  PENDING
  SUBMITTED
  APPROVED
  PAID
  CANCELLED
}

enum AttachmentType {
  PURCHASE_ORDER
  RECEIPT
  INVOICE
  INSPECTION_REPORT
  DELIVERY_NOTE
  OTHER
}
```

---

### 5. แก้ไข PurchaseOrder (เพิ่มฟิลด์)

```prisma
model PurchaseOrder {
  // ... existing fields ...
  contractId          BigInt?         @map("contract_id")
  sentToVendorDate    DateTime?       @map("sent_to_vendor_date") @db.Date
  printedDate         DateTime?       @map("printed_date") @db.Date
  confirmedBy         BigInt?         @map("confirmed_by")
  confirmedDate       DateTime?       @map("confirmed_date")

  // Relations (เพิ่ม)
  contract            Contract?       @relation(fields: [contractId], references: [id])
  approvalDocuments   ApprovalDocument[]
  paymentDocuments    PaymentDocument[]
}
```

---

### 6. แก้ไข BudgetPlanItem (เพิ่มฟิลด์)

```prisma
model BudgetPlanItem {
  // ... existing fields ...
  q1Received          Decimal?        @map("q1_received") @db.Decimal(10, 2)
  q2Received          Decimal?        @map("q2_received") @db.Decimal(10, 2)
  q3Received          Decimal?        @map("q3_received") @db.Decimal(10, 2)
  q4Received          Decimal?        @map("q4_received") @db.Decimal(10, 2)
  forecastQuantity    Decimal?        @map("forecast_quantity") @db.Decimal(10, 2)
  currentStock        Decimal?        @map("current_stock") @db.Decimal(10, 2)
}
```

---

## 📊 สรุปตารางใหม่และการแก้ไข

### ตารางใหม่ (5 ตาราง):
1. ✅ `contracts` - สัญญาหลัก
2. ✅ `contract_items` - รายการในสัญญา
3. ✅ `receipt_inspectors` - กรรมการตรวจรับ
4. ✅ `approval_documents` - ใบขออนุมัติ
5. ✅ `payment_documents` - เอกสารจ่ายเงิน
6. ✅ `payment_attachments` - ไฟล์แนบเอกสาร

### ตารางที่แก้ไข (3 ตาราง):
1. ✅ `receipts` - เพิ่ม 5 ฟิลด์
2. ✅ `purchase_orders` - เพิ่ม 5 ฟิลด์
3. ✅ `budget_plan_items` - เพิ่ม 6 ฟิลด์

### Enum ใหม่ (7 enum):
1. ✅ `ContractType`
2. ✅ `ContractStatus`
3. ✅ `InspectorRole`
4. ✅ `ApprovalType`
5. ✅ `ApprovalStatus`
6. ✅ `PaymentStatus`
7. ✅ `AttachmentType`

### Enum ที่แก้ไข (1 enum):
1. ✅ `ReceiptStatus` - เพิ่ม `PENDING_VERIFICATION`

---

## ⏰ Timeline

### Week 1: Database Schema (6 วัน)

**Day 1-2: ระบบสัญญา**
- [ ] เพิ่ม Contract model
- [ ] เพิ่ม ContractItem model
- [ ] เพิ่ม enum ContractType, ContractStatus
- [ ] Test relations

**Day 3-4: ระบบตรวจรับและอนุมัติ**
- [ ] เพิ่ม ReceiptInspector model
- [ ] แก้ไข Receipt model (5 ฟิลด์)
- [ ] แก้ไข enum ReceiptStatus
- [ ] เพิ่ม ApprovalDocument model
- [ ] เพิ่ม enum ApprovalType, ApprovalStatus, InspectorRole
- [ ] Test relations

**Day 5-6: ระบบจ่ายเงินและแก้ไขอื่นๆ**
- [ ] เพิ่ม PaymentDocument model
- [ ] เพิ่ม PaymentAttachment model
- [ ] เพิ่ม enum PaymentStatus, AttachmentType
- [ ] แก้ไข PurchaseOrder (5 ฟิลด์)
- [ ] แก้ไข BudgetPlanItem (6 ฟิลด์)
- [ ] Test relations ทั้งหมด

---

### Week 2: Migration & Seed (3 วัน)

**Day 1: Migration**
- [ ] สร้าง migration file
- [ ] Review migration SQL
- [ ] Run migration
- [ ] Verify database schema

**Day 2: Seed Data**
- [ ] เพิ่ม seed สำหรับ contracts (2 records)
- [ ] เพิ่ม seed สำหรับ contract_items (2 records)
- [ ] Test contract relations
- [ ] Test PO → Contract link

**Day 3: Testing**
- [ ] Test ทุก model ใหม่
- [ ] Test relations ทั้งหมด
- [ ] Test Prisma queries
- [ ] Verify data integrity

---

## 📝 Checklist ก่อนเริ่มงาน

### Prerequisites:
- [x] ✅ วิเคราะห์ระบบเดิมเสร็จแล้ว
- [x] ✅ ออกแบบ schema ใหม่เสร็จแล้ว
- [ ] ⏳ Backup ฐานข้อมูลปัจจุบัน
- [ ] ⏳ สร้าง branch ใหม่สำหรับ schema enhancement

### Ready to Start:
- [ ] เริ่ม Day 1: สร้าง Contract models
- [ ] เริ่ม Day 2: สร้าง ContractItem model
- [ ] เริ่ม Day 3: สร้าง ReceiptInspector + ApprovalDocument
- [ ] เริ่ม Day 4: ทดสอบ models ทั้งหมด
- [ ] เริ่ม Day 5: สร้าง Payment models
- [ ] เริ่ม Day 6: แก้ไข models ที่มีอยู่
- [ ] เริ่ม Day 7: สร้าง migration
- [ ] เริ่ม Day 8: อัพเดท seed data
- [ ] เริ่ม Day 9: Testing & Verification

---

## 🎯 Success Criteria

### Database:
- ✅ สร้างตารางใหม่ 6 ตาราง
- ✅ แก้ไขตารางเดิม 3 ตาราง
- ✅ เพิ่ม enum ใหม่ 7 enum
- ✅ แก้ไข enum เดิม 1 enum

### Functionality:
- ✅ สามารถบันทึกสัญญาได้
- ✅ สามารถบันทึกกรรมการหลายคนได้
- ✅ สามารถสร้างใบอนุมัติแยกได้
- ✅ สามารถติดตามการจ่ายเงินได้
- ✅ PO เชื่อมกับสัญญาได้

### Testing:
- ✅ Prisma generate สำเร็จ
- ✅ Migration run สำเร็จ
- ✅ Seed data สำเร็จ
- ✅ Query ทุก model ได้
- ✅ Relations ทำงานถูกต้อง

---

## 📞 Next Steps

1. **Backup ฐานข้อมูล**
```bash
npm run db:backup
```

2. **สร้าง Git Branch**
```bash
git checkout -b feature/schema-enhancement
```

3. **เริ่มแก้ไข Prisma Schema**
```bash
# แก้ไขไฟล์ prisma/schema.prisma
```

4. **Generate & Push**
```bash
npm run db:generate
npm run db:push
```

5. **Create Migration**
```bash
npm run db:migrate
```

6. **Update Seed**
```bash
# แก้ไขไฟล์ prisma/seed.ts
npm run db:seed
```

---

**Status:** ✅ Schema Design Complete - Ready to Implement
**Start Date:** TBD (รอ Approval)
**Estimated Completion:** 9 วันทำการ

---

*เอกสารนี้เป็นแผนงานสมบูรณ์สำหรับพัฒนา Schema ระบบจัดซื้อ*
