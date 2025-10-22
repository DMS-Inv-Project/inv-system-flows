# 🔍 การวิเคราะห์ระบบจัดซื้อ (Gap Analysis)

**เปรียบเทียบ:** ความต้องการจริง vs ระบบปัจจุบัน

**วันที่:** 20 ตุลาคม 2568
**Version:** 1.0

---

## 📊 สรุปภาพรวม

| หัวข้อ | สถานะ | หมายเหตุ |
|--------|------|---------|
| **โครงสร้างฐานข้อมูล** | 🟡 70% | มีตารางหลักครบ แต่ขาดรายละเอียดบางส่วน |
| **Business Logic** | ⚪ 20% | ยังไม่มี Functions/Procedures |
| **Frontend/API** | ⚪ 0% | ยังไม่เริ่มพัฒนา |

---

## ✅ สิ่งที่มีอยู่แล้ว (ตาราง Database)

### 1. ✅ **Master Data - ครบถ้วน 100%**

```sql
✅ locations (คลัง)
✅ departments (หน่วยงาน)
✅ budget_types (ประเภทงบ)
✅ budget_categories (หมวดค่าใช้จ่าย)
✅ budgets (งบประมาณ)
✅ companies (บริษัท)
✅ drug_generics (ยา generic)
✅ drugs (ยา trade name)
✅ bank (ธนาคาร)
```

### 2. ✅ **ตารางจัดซื้อหลัก - มีแล้ว**

```sql
✅ purchase_requests
   - prNumber, prDate, departmentId
   - budgetAllocationId, requestedAmount
   - status (DRAFT, PENDING, APPROVED, REJECTED)
   - requestedBy, approvedBy, approvalDate

✅ purchase_orders
   - poNumber, poDate, deliveryDate
   - vendorId, departmentId, budgetId
   - status (DRAFT, PENDING_APPROVAL, APPROVED, SENT, ...)
   - totalAmount, totalItems
   - createdBy, approvedBy

✅ receipts
   - receiptNumber, receiptDate, deliveryNote
   - poId
   - status (DRAFT, VERIFIED, POSTED)
   - receivedBy, verifiedBy
```

### 3. ✅ **ตารางงบประมาณ - มีแล้ว**

```sql
✅ budget_allocations
   - fiscalYear, budgetId, departmentId
   - totalAllocated, q1Budget, q2Budget, q3Budget, q4Budget
   - q1Spent, q2Spent, q3Spent, q4Spent
   - remainingBudget

✅ budget_reservations
   - reservationNumber, allocationId
   - prId, amount, expiresAt
   - status
```

---

## ❌ สิ่งที่ยังขาด (Gap Analysis)

### 🔴 **Gap 1: ไม่มีตาราง Contracts (สัญญา)**

**ความต้องการ:** ขั้นตอนที่ 2 - บันทึกสัญญา

**สิ่งที่ต้องการ:**
```sql
❌ ไม่มีตาราง: contracts
   - contract_number
   - contract_type (ตกลงราคา, e-bidding, สอบราคา)
   - vendor_id
   - start_date, end_date
   - total_value
   - payment_terms
   - warranty_period
   - status

❌ ไม่มีตาราง: contract_items
   - contract_id
   - drug_id
   - unit_price
   - min_quantity, max_quantity
   - discount_rate
```

**ผลกระทบ:**
- ❌ ไม่สามารถตรวจสอบว่ามีสัญญาหรือไม่
- ❌ ไม่สามารถดึงราคาจากสัญญามาใส่ PO อัตโนมัติ
- ❌ ไม่สามารถเช็คว่าซื้อเกินสัญญาหรือไม่

**แก้ไข:** ⚠️ ต้องเพิ่ม 2 ตาราง

---

### 🟡 **Gap 2: ตาราง PO ไม่รองรับ "ใบขออนุมัติ" แยกต่างหาก**

**ความต้องการ:** ขั้นตอนที่ 4 - สร้างใบขออนุมัติพร้อมกับ PO

**สิ่งที่มีอยู่:**
```sql
✅ purchase_orders มีฟิลด์:
   - approvedBy (ผู้อนุมัติ)
   - status (PENDING_APPROVAL, APPROVED)
```

**สิ่งที่ยังขาด:**
```sql
❌ ไม่มีตาราง: approval_documents
   - approval_doc_number
   - po_id
   - approval_type (ปกติ, พิเศษ, ด่วน)
   - requested_by
   - approved_by
   - approval_date
   - approval_remarks
   - document_path (PDF ใบขออนุมัติ)
```

**ผลกระทบ:**
- 🟡 ทำงานได้ แต่ไม่มีเอกสาร "ใบขออนุมัติ" แยกต่างหาก
- 🟡 ไม่สามารถพิมพ์ "ใบขออนุมัติ" ออกมาได้ (ต้องพิมพ์ PO แทน)
- 🟡 ไม่มีเลขที่ใบขออนุมัติแยก (ใช้เลข PO)

**แก้ไข:**
- Option 1: เพิ่มตาราง approval_documents ⭐ แนะนำ
- Option 2: เพิ่มฟิลด์ใน purchase_orders (approvalDocNumber, approvalDocPath)

---

### 🔴 **Gap 3: Receipt ไม่แยก "รับ" กับ "ตรวจรับ" ชัดเจน**

**ความต้องการ:** ขั้นตอนที่ 6-7 - แยกระหว่าง "รับเวชภัณฑ์" กับ "ตรวจรับ"

**สิ่งที่มีอยู่:**
```sql
✅ receipts มีฟิลด์:
   - receivedBy (ผู้รับ)
   - verifiedBy (ผู้ตรวจรับ)
   - status (DRAFT, VERIFIED, POSTED)
```

**ปัญหา:**
- 🔴 status มีแค่ 3 สถานะ (DRAFT, VERIFIED, POSTED)
- 🔴 ไม่มีสถานะ "รอตรวจรับ" (PENDING_VERIFICATION)
- 🔴 ไม่มีข้อมูลกรรมการตรวจรับ (คนเดียว)
- 🔴 ไม่มี timestamp แยก (receivedDate vs verifiedDate)
- 🔴 ไม่มีฟิลด์ invoice_number, invoice_date

**สิ่งที่ควรมี:**
```sql
📝 เพิ่มฟิลด์ใน receipts:
   - invoice_number
   - invoice_date
   - received_date (วันที่บันทึกรับ)
   - verified_date (วันที่กรรมการตรวจรับเสร็จ)
   - posted_date (วันที่ยืนยันในระบบ)

📝 เพิ่ม status ใหม่:
   - DRAFT (บันทึกรับแล้ว รอตรวจรับ)
   - PENDING_VERIFICATION (รอกรรมการตรวจรับ)
   - VERIFIED (กรรมการตรวจรับเรียบร้อย)
   - POSTED (ยืนยันในระบบแล้ว)

❌ ไม่มีตาราง: receipt_inspectors (กรรมการตรวจรับ)
   - receipt_id
   - inspector_name
   - inspector_position
   - signed_date
   - signature_path
   - remarks
```

**ผลกระทบ:**
- ❌ ไม่สามารถบันทึกกรรมการหลายคน
- ❌ ไม่สามารถติดตาม Timeline ของแต่ละขั้นตอน
- ❌ ไม่สามารถพิมพ์ใบตรวจรับที่มีลายเซ็นกรรมการครบ

**แก้ไข:** ⚠️ ต้องเพิ่มตาราง receipt_inspectors + แก้ไข enum ReceiptStatus

---

### 🟡 **Gap 4: ขาดตาราง "ซื้ออะไร?" (Reorder Suggestion)**

**ความต้องการ:** ขั้นตอนที่ 3 - ดูรายงานยาที่ถึงจุดสั่งซื้อ

**สิ่งที่มีอยู่:**
```sql
✅ inventory มีฟิลด์:
   - reorderPoint
   - minLevel, maxLevel
```

**สิ่งที่ยังขาด:**
```sql
❌ ไม่มี VIEW: reorder_suggestions
   - drug_id
   - location_id
   - quantity_on_hand
   - reorder_point
   - suggested_quantity
   - average_usage_per_month
   - last_purchase_date
   - last_vendor_id
   - last_unit_cost
   - contract_id (ถ้ามีสัญญา)
   - contract_price

❌ ไม่มี function: calculate_reorder_quantity()
❌ ไม่มี function: get_usage_analysis()
```

**ผลกระทบ:**
- 🟡 ต้องคำนวณเองทุกครั้ง
- 🟡 ไม่มีระบบแนะนำ "ควรซื้ออะไร"
- 🟡 ไม่มี ABC-VEN Analysis

**แก้ไข:**
- สร้าง View หรือ Function สำหรับวิเคราะห์

---

### 🟡 **Gap 5: PurchaseRequest (PR) ยังมีอยู่ แต่ไม่ต้องการใช้**

**ความต้องการ:** ไม่ต้องมี PR - คลังสั่งซื้อได้เลย

**สิ่งที่มีอยู่:**
```sql
✅ purchase_requests (มีตารางนี้อยู่)
✅ purchase_request_items
```

**ปัญหา:**
- 🟡 มีตาราง PR แต่ไม่ต้องใช้ตาม business process
- 🟡 มีความสัมพันธ์ระหว่าง PR → PO

**แนวทาง:**
- Option 1: เก็บตารางไว้ แต่ทำให้ optional (ถ้าอนาคตต้องการใช้)
- Option 2: ลบตารางออก (ถ้าแน่ใจว่าไม่ต้องใช้) ❌ ไม่แนะนำ

**คำแนะนำ:** ⭐ เก็บไว้ แต่ไม่ enforce ให้ต้องมี PR ก่อน PO

---

### 🟡 **Gap 6: ขาดตารางเอกสารส่งการเงิน**

**ความต้องการ:** ขั้นตอนที่ 8 - ส่งเอกสารการเงิน

**สิ่งที่ยังขาด:**
```sql
❌ ไม่มีตาราง: payment_documents
   - payment_doc_number
   - receipt_id
   - po_id
   - vendor_id
   - total_amount
   - payment_status (PENDING, APPROVED, PAID)
   - submitted_to_finance_date
   - paid_date
   - payment_method
   - payment_reference

❌ ไม่มีตาราง: payment_document_attachments
   - payment_doc_id
   - document_type (PO, RECEIPT, INVOICE, INSPECTION_REPORT)
   - file_path
   - uploaded_at
```

**ผลกระทบ:**
- 🟡 ไม่สามารถติดตามสถานะการจ่ายเงิน
- 🟡 ไม่ทราบว่าส่งเอกสารให้การเงินแล้วหรือยัง
- 🟡 ไม่ทราบว่าการเงินจ่ายเงินแล้วหรือยัง

**แก้ไข:** เพิ่มตาราง payment_documents (ถ้าต้องการติดตาม)

---

## 📊 สรุป Gap Analysis

### 🔴 **Priority 1: ต้องเพิ่ม (ทำงานไม่ได้ถ้าไม่มี)**

| # | Gap | ตาราง/ฟิลด์ที่ต้องเพิ่ม | Effort |
|---|-----|------------------------|---------|
| 1 | **สัญญา** | `contracts`, `contract_items` | 3 วัน |
| 2 | **กรรมการตรวจรับ** | `receipt_inspectors` + แก้ `receipts` | 2 วัน |
| 3 | **ใบขออนุมัติ** | `approval_documents` หรือแก้ `purchase_orders` | 1 วัน |

**รวม:** 6 วันทำการ

---

### 🟡 **Priority 2: แนะนำให้มี (ทำงานได้ แต่ไม่สมบูรณ์)**

| # | Gap | ตาราง/ฟิลด์ที่ต้องเพิ่ม | Effort |
|---|-----|------------------------|---------|
| 4 | **ซื้ออะไร?** | VIEW `reorder_suggestions` + functions | 2 วัน |
| 5 | **เอกสารการเงิน** | `payment_documents`, `payment_attachments` | 2 วัน |
| 6 | **Invoice** | เพิ่มฟิลด์ใน `receipts` | 0.5 วัน |

**รวม:** 4.5 วันทำการ

---

### 🟢 **Priority 3: มีดีมาก (Nice to have)**

| # | Gap | ตาราง/ฟิลด์ที่ต้องเพิ่ม | Effort |
|---|-----|------------------------|---------|
| 7 | **ABC-VEN Analysis** | VIEW/Function | 3 วัน |
| 8 | **Audit Trail** | เพิ่มตาราง `audit_logs` | 1 วัน |
| 9 | **Document Attachments** | `po_attachments`, `receipt_attachments` | 1 วัน |

**รวม:** 5 วันทำการ

---

## 🎯 แผนการพัฒนาที่แนะนำ

### Phase 1: Fix Critical Gaps (6 วัน) - ⚠️ จำเป็น

```sql
Week 1:
  ✅ Day 1-3: เพิ่มตาราง contracts + contract_items
  ✅ Day 4-5: เพิ่มตาราง receipt_inspectors + แก้ receipts
  ✅ Day 6: เพิ่ม approval_documents หรือแก้ purchase_orders
```

### Phase 2: Important Features (4.5 วัน) - แนะนำ

```sql
Week 2:
  ✅ Day 1-2: สร้าง VIEW reorder_suggestions + functions
  ✅ Day 3-4: เพิ่มตาราง payment_documents
  ✅ Day 5: เพิ่มฟิลด์ invoice ใน receipts
```

### Phase 3: Nice to have (5 วัน) - Optional

```sql
Week 3:
  ✅ Day 1-3: ABC-VEN Analysis
  ✅ Day 4: Audit Trail
  ✅ Day 5: Document Attachments
```

---

## 📝 รายละเอียดตารางที่ต้องเพิ่ม

### 1. ตาราง `contracts` (สัญญา)

```sql
CREATE TABLE contracts (
    id BIGSERIAL PRIMARY KEY,
    contract_number VARCHAR(20) UNIQUE NOT NULL,
    contract_type VARCHAR(20) NOT NULL, -- 'PRICE_AGREEMENT', 'E_BIDDING', 'QUOTATION'
    vendor_id BIGINT NOT NULL REFERENCES companies(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_value DECIMAL(15,2),
    payment_terms TEXT,
    warranty_period VARCHAR(50),
    status VARCHAR(20) DEFAULT 'ACTIVE', -- 'DRAFT', 'ACTIVE', 'EXPIRED', 'CANCELLED'
    created_by BIGINT,
    approved_by BIGINT,
    approval_date DATE,
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE contract_items (
    id BIGSERIAL PRIMARY KEY,
    contract_id BIGINT NOT NULL REFERENCES contracts(id) ON DELETE CASCADE,
    drug_id BIGINT NOT NULL REFERENCES drugs(id),
    unit_price DECIMAL(10,2) NOT NULL,
    min_quantity DECIMAL(10,2),
    max_quantity DECIMAL(10,2),
    discount_rate DECIMAL(5,2),
    notes TEXT,
    UNIQUE(contract_id, drug_id)
);
```

### 2. ตาราง `receipt_inspectors` (กรรมการตรวจรับ)

```sql
CREATE TABLE receipt_inspectors (
    id BIGSERIAL PRIMARY KEY,
    receipt_id BIGINT NOT NULL REFERENCES receipts(id) ON DELETE CASCADE,
    inspector_name VARCHAR(100) NOT NULL,
    inspector_position VARCHAR(100),
    inspector_role VARCHAR(50), -- 'CHAIRMAN', 'MEMBER', 'SECRETARY'
    signed_date TIMESTAMP,
    signature_path VARCHAR(255),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- เพิ่มฟิลด์ใน receipts
ALTER TABLE receipts
ADD COLUMN invoice_number VARCHAR(50),
ADD COLUMN invoice_date DATE,
ADD COLUMN received_date TIMESTAMP,
ADD COLUMN verified_date TIMESTAMP,
ADD COLUMN posted_date TIMESTAMP;

-- แก้ไข enum ReceiptStatus
-- เดิม: DRAFT, VERIFIED, POSTED
-- ใหม่: DRAFT, PENDING_VERIFICATION, VERIFIED, POSTED
```

### 3. ตาราง `approval_documents` (ใบขออนุมัติ)

```sql
CREATE TABLE approval_documents (
    id BIGSERIAL PRIMARY KEY,
    approval_doc_number VARCHAR(20) UNIQUE NOT NULL,
    po_id BIGINT NOT NULL REFERENCES purchase_orders(id),
    approval_type VARCHAR(20) DEFAULT 'NORMAL', -- 'NORMAL', 'URGENT', 'SPECIAL'
    requested_by BIGINT NOT NULL,
    requested_date DATE NOT NULL,
    approved_by BIGINT,
    approval_date DATE,
    approval_remarks TEXT,
    status VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED'
    document_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 4. VIEW `reorder_suggestions` (ซื้ออะไร?)

```sql
CREATE VIEW reorder_suggestions AS
SELECT
    i.drug_id,
    i.location_id,
    d.drug_code,
    d.trade_name,
    i.quantity_on_hand,
    i.reorder_point,
    i.min_level,
    i.max_level,
    CASE
        WHEN i.quantity_on_hand <= i.reorder_point
        THEN i.max_level - i.quantity_on_hand
        ELSE 0
    END as suggested_quantity,
    -- TODO: คำนวณ average usage
    -- TODO: ดึงข้อมูลการซื้อล่าสุด
    -- TODO: ดึงข้อมูลสัญญา (ถ้ามี)
FROM inventory i
JOIN drugs d ON i.drug_id = d.id
WHERE i.quantity_on_hand <= i.reorder_point
  AND i.is_active = true
ORDER BY
    CASE
        WHEN i.quantity_on_hand <= i.min_level THEN 1
        WHEN i.quantity_on_hand <= i.reorder_point THEN 2
        ELSE 3
    END,
    i.quantity_on_hand ASC;
```

---

## 🔥 Action Items

### สำหรับทีมพัฒนา:

- [ ] 1. Review Gap Analysis นี้กับทีม
- [ ] 2. ยืนยัน Priority และ Effort
- [ ] 3. เริ่ม Phase 1: เพิ่มตาราง contracts, receipt_inspectors, approval_documents
- [ ] 4. Update Prisma Schema
- [ ] 5. Run Migration
- [ ] 6. Update Seed Data
- [ ] 7. สร้าง Views และ Functions
- [ ] 8. เขียน API Endpoints
- [ ] 9. เขียน Frontend

### สำหรับ Product Owner:

- [ ] 1. Review และยืนยัน Gap Analysis
- [ ] 2. Prioritize features
- [ ] 3. กำหนด Timeline
- [ ] 4. Approve แผนการพัฒนา

---

## 📞 สรุปสั้นๆ

### ❓ **"ระบบเรารองรับแล้วหรือยัง?"**

**คำตอบ:** 🟡 **รองรับ 70% - ยังต้องเพิ่มเติม**

**สิ่งที่มีแล้ว:**
- ✅ Master Data ครบ
- ✅ ตาราง PO, Receipt พื้นฐาน
- ✅ ระบบงบประมาณ

**สิ่งที่ยังขาด (ต้องเพิ่ม):**
- ❌ สัญญา (Contracts)
- ❌ กรรมการตรวจรับหลายคน
- ❌ ใบขออนุมัติแยก
- 🟡 ระบบแนะนำ "ซื้ออะไร?"
- 🟡 ติดตามการจ่ายเงิน

**เวลาที่ต้องใช้แก้ไข:** 6-15 วันทำการ (ขึ้นกับ Priority)

---

**Version:** 1.0
**วันที่:** 20 ตุลาคม 2568
**ผู้จัดทำ:** INVS Development Team
**Status:** ✅ Ready for Review

---

*เอกสารนี้จัดทำขึ้นเพื่อวิเคราะห์ช่องว่างระหว่างความต้องการจริงกับระบบปัจจุบัน*
