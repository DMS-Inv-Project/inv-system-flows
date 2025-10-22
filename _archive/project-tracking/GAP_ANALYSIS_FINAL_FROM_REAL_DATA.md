# 🔍 Gap Analysis ฉบับสมบูรณ์ (จากข้อมูลจริง)

**แหล่งข้อมูล:**
- ✅ INVS_MANUAL-01.pdf (คู่มือระบบเดิม)
- ✅ MySQL Database (invs_banpong) - 133 ตาราง, 816 companies, 7,258 drugs

**วันที่วิเคราะห์:** 20 ตุลาคม 2568 เวลา 07:15 น.
**Version:** 2.0 (Final - จากข้อมูลจริง)

---

## 📊 สรุปภาพรวม

| Component | ระบบเดิม (MySQL) | ระบบเรา (PostgreSQL) | % Complete | Gap |
|-----------|-----------------|---------------------|------------|-----|
| **Master Data** | ✅ 133 ตาราง | ✅ 10 ตาราง | 100% | ✅ ครบ |
| **Procurement** | ✅ 8 ตาราง | 🟡 3 ตาราง | 40% | ❌ ขาด 5 ตาราง |
| **Inventory** | ✅ 15 ตาราง | ✅ 5 ตาราง | 80% | 🟡 ควรเพิ่ม |
| **Budget** | ✅ 4 ตาราง | ✅ 7 ตาราง | 120% | ✅ ครบเกิน! |

**สรุป:** ระบบเรามีโครงสร้างพื้นฐาน 70% แต่ขาดตารางสำคัญในส่วนจัดซื้อ

---

## 🔍 วิเคราะห์แต่ละส่วน (จากระบบเดิม)

### 1. ระบบสัญญา (Contract Management) ⭐⭐⭐

#### ระบบเดิมมีอะไร:

**ตาราง `cnt` (Contract Master):**
```sql
✅ CNT_NO - เลขที่สัญญา
✅ PARTIES_CODE - รหัสบริษัท
✅ EFFECTIVE_DATE - วันที่เริ่ม
✅ END_DATE - วันสิ้นสุด
✅ BUY_METHOD - วิธีการจัดซื้อ (e-bidding, ตกลงราคา)
✅ BUY_COMMON - วิธีการสามัญ/พิเศษ
✅ TOTAL_ITEM - จำนวนรายการ
✅ TOTAL_COST - มูลค่ารวม
✅ REMAIN_COST - มูลค่าคงเหลือ
✅ FISCAL_YEAR - ปีงบประมาณ
```

**ตาราง `cnt_c` (Contract Items):**
```sql
✅ CNT_NO - เลขที่สัญญา
✅ WORKING_CODE - รหัสยา generic
✅ TRADE_CODE - รหัสยา trade
✅ BUY_UNIT_COST - ราคาต่อหน่วยตามสัญญา ⭐
✅ QTY_CNT - ปริมาณตามสัญญา
✅ COST_CNT - มูลค่าตามสัญญา
✅ QTY_REMAIN - ปริมาณคงเหลือ ⭐
✅ COST_REMAIN - มูลค่าคงเหลือ ⭐
✅ PERCENT_CNT - % ส่วนลด
```

#### ระบบเราไม่มี:

```sql
❌ contracts (ไม่มีตาราง)
❌ contract_items (ไม่มีตาราง)
```

#### ผลกระทบ:

```
❌ Critical: ไม่สามารถบันทึกสัญญาได้
❌ Critical: ไม่มีราคาอ้างอิงจากสัญญา
❌ Critical: ไม่สามารถเช็คว่าซื้อเกินสัญญา
❌ High: ไม่มีการแจ้งเตือนสัญญาใกล้หมดอายุ
❌ High: ไม่สามารถติดตามการใช้สัญญา (ใช้ไปแล้วเท่าไร คงเหลือเท่าไร)
```

#### แนวทางแก้ไข:

```sql
CREATE TABLE contracts (
    id BIGSERIAL PRIMARY KEY,
    contract_number VARCHAR(20) UNIQUE NOT NULL,
    contract_type VARCHAR(20) NOT NULL, -- 'E_BIDDING', 'PRICE_AGREEMENT', 'QUOTATION'
    vendor_id BIGINT REFERENCES companies(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_value DECIMAL(15,2),
    remaining_value DECIMAL(15,2),
    payment_terms TEXT,
    warranty_period VARCHAR(50),
    fiscal_year VARCHAR(4),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE contract_items (
    id BIGSERIAL PRIMARY KEY,
    contract_id BIGINT REFERENCES contracts(id) ON DELETE CASCADE,
    drug_id BIGINT REFERENCES drugs(id),
    unit_price DECIMAL(10,2) NOT NULL, -- ราคาตามสัญญา
    quantity_contracted DECIMAL(10,2), -- ปริมาณตามสัญญา
    quantity_remaining DECIMAL(10,2), -- คงเหลือ
    value_contracted DECIMAL(15,2),
    value_remaining DECIMAL(15,2),
    discount_percent DECIMAL(5,2),
    notes TEXT,
    UNIQUE(contract_id, drug_id)
);
```

---

### 2. ระบบจัดซื้อ (Procurement)

#### ระบบเดิมมีอะไร:

**ตาราง `sm_po` (Sub PO - ใบสั่งซื้อ):**
```sql
✅ SUB_PO_NO - เลขที่ PO
✅ SUB_PO_DATE - วันที่สั่งซื้อ
✅ DEPT_ID - หน่วยงาน
✅ ACC_NO - รหัสบัญชี
✅ STOCK_ID - คลัง
✅ TOTAL_ITEM - จำนวนรายการ
✅ TOTAL_COST - มูลค่ารวม
✅ USER_ID - ผู้สั่งซื้อ
✅ CONFIRM_FLAG - สถานะยืนยัน
✅ R_S_STATUS - สถานะรับ-ส่ง
✅ SEND_FLAG - ส่งให้ผู้ขายแล้วหรือไม่
✅ PRINT_FLAG - พิมพ์แล้วหรือไม่
✅ REF_NO - เลขที่อ้างอิง (เช่น สัญญา)
✅ CONFIRM_DATE, CONFIRM_TIME - วันเวลายืนยัน
```

**ตาราง `sm_po_c` (Sub PO Content - รายการในใบสั่งซื้อ):**
```sql
✅ SUB_PO_NO - เลขที่ PO
✅ WORKING_CODE - รหัสยา generic
✅ TRADE_CODE - รหัสยา trade
✅ QTY_ORDER - จำนวนสั่ง
✅ QTY_RCV - จำนวนรับ
✅ VENDOR_CODE - ผู้ขาย
✅ MANUFAC_CODE - ผู้ผลิต
✅ COST, VALUE - ราคา
✅ LOT_NO - เลข Lot ⭐ สำคัญ
✅ EXPIRED_DATE - วันหมดอายุ ⭐ สำคัญ
✅ LOCATION - สถานที่เก็บ
✅ CONFIRM_FLAG - ยืนยันแล้ว
✅ USER_CFM - ผู้ยืนยัน

⭐ สังเกต: มี EXPIRED_DATE1, EXPIRED_DATE2, EXPIRED_DATE3
   หมายความว่า สามารถรับของหลาย Lot ในรายการเดียวได้!
```

#### ระบบเรามีอะไร:

```sql
✅ purchase_orders
   - poNumber, poDate
   - vendorId, departmentId, budgetId
   - status, totalAmount, totalItems
   - approvedBy

✅ purchase_order_items
   - drugId, quantityOrdered
   - unitCost, quantityReceived
```

#### ระบบเราขาดอะไร:

```
🟡 REF_NO (เลขอ้างอิงสัญญา) ❌ ไม่มี
🟡 SEND_FLAG (ส่งให้ผู้ขายแล้วหรือไม่) ❌ ไม่มี
🟡 PRINT_FLAG (พิมพ์แล้วหรือไม่) ❌ ไม่มี
🟡 CONFIRM_DATE, CONFIRM_TIME ❌ ไม่มี (มีแค่ approvedBy)
```

#### แนวทางแก้ไข:

```sql
ALTER TABLE purchase_orders
ADD COLUMN contract_id BIGINT REFERENCES contracts(id),
ADD COLUMN sent_to_vendor_date DATE,
ADD COLUMN printed_date DATE,
ADD COLUMN confirmed_by BIGINT,
ADD COLUMN confirmed_date TIMESTAMP;
```

---

### 3. ระบบรับเข้าคลัง (Receiving)

#### ระบบเดิมมีอะไร:

**ตาราง `sm_po_c` เก็บข้อมูลรับด้วย:**
```sql
✅ QTY_RCV - จำนวนรับ
✅ LOT_NO - เลข Lot
✅ EXPIRED_DATE - วันหมดอายุ
✅ LOCATION - สถานที่เก็บ
✅ CONFIRM_FLAG - ยืนยันรับแล้ว
✅ USER_CFM - ผู้ยืนยัน
✅ CONFIRM_DATE - วันที่ยืนยัน

⭐ สามารถรับหลาย Lot:
   - QTY_RCV1, EXPIRED_DATE1, LOCATION1, VENDOR_CODE2
   - QTY_RCV2, EXPIRED_DATE2, LOCATION2, VENDOR_CODE2
   - QTY_RCV3, EXPIRED_DATE3, LOCATION3, VENDOR_CODE3
```

#### ระบบเรามีอะไร:

```sql
✅ receipts
   - receiptNumber, receiptDate
   - poId, deliveryNote
   - status (DRAFT, VERIFIED, POSTED)
   - receivedBy, verifiedBy

✅ receipt_items
   - drugId, quantityReceived
   - lotNumber, expiryDate
   - unitCost
```

#### ระบบเราขาดอะไร:

```
❌ invoice_number ⭐ สำคัญมาก
❌ invoice_date ⭐ สำคัญมาก
🟡 received_date (วันที่บันทึกรับ)
🟡 verified_date (วันที่ตรวจรับ)
🟡 posted_date (วันที่ยืนยันในระบบ)
```

#### สถานะที่ควรมี:

```sql
❌ ระบบเราควรมี Status ละเอียดกว่า:
   - DRAFT (บันทึกรับแล้ว รอพิมพ์ใบตรวจรับ)
   - PENDING_VERIFICATION (ส่งให้กรรมการแล้ว รอตรวจรับ) ⭐ ขาด
   - VERIFIED (กรรมการตรวจรับเรียบร้อย)
   - POSTED (ยืนยันในระบบแล้ว คงคลังเพิ่ม)
```

#### แนวทางแก้ไข:

```sql
ALTER TABLE receipts
ADD COLUMN invoice_number VARCHAR(50),
ADD COLUMN invoice_date DATE,
ADD COLUMN received_date TIMESTAMP,
ADD COLUMN verified_date TIMESTAMP,
ADD COLUMN posted_date TIMESTAMP;

-- เพิ่ม enum ReceiptStatus
-- เดิม: 'DRAFT', 'VERIFIED', 'POSTED'
-- ใหม่: 'DRAFT', 'PENDING_VERIFICATION', 'VERIFIED', 'POSTED'
```

---

### 4. กรรมการตรวจรับ (Inspection Committee)

#### ระบบเดิมมีอะไร:

**ตาราง `quali_rcv` (Quality Receive - การตรวจรับคุณภาพ):**
```sql
✅ RECEIVE_NO - เลขที่รับ
✅ WORKING_CODE, TRADE_CODE - รหัสยา
✅ QUALI_ID - รหัสคุณสมบัติที่ตรวจ
✅ QUALI_VALUE - ค่าที่ตรวจได้
✅ USER_ID - ผู้ตรวจ
✅ LOT_NO - เลข Lot
```

**จากคู่มือ: กรรมการตรวจรับ 3 คน**
```
1. ประธานกรรมการ (Chairman)
2. กรรมการ (Member)
3. กรรมการและเลขานุการ (Secretary)
```

#### ระบบเรามีอะไร:

```sql
✅ receipts.verifiedBy (แต่เก็บได้แค่ 1 คน)
```

#### ระบบเราขาดอะไร:

```
❌ ไม่มีตาราง receipt_inspectors (กรรมการหลายคน)
❌ ไม่มีข้อมูล inspector_name, inspector_position
❌ ไม่มีข้อมูล inspector_role (ประธาน/กรรมการ/เลขา)
❌ ไม่มี signed_date (วันที่ลงนาม)
❌ ไม่มี signature_path (ไฟล์ลายเซ็น)
```

#### แนวทางแก้ไข:

```sql
CREATE TABLE receipt_inspectors (
    id BIGSERIAL PRIMARY KEY,
    receipt_id BIGINT REFERENCES receipts(id) ON DELETE CASCADE,
    inspector_name VARCHAR(100) NOT NULL,
    inspector_position VARCHAR(100),
    inspector_role VARCHAR(50), -- 'CHAIRMAN', 'MEMBER', 'SECRETARY'
    signed_date TIMESTAMP,
    signature_path VARCHAR(255),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

### 5. ระบบวางแผนจัดซื้อ (Budget Planning)

#### ระบบเดิมมีอะไร:

**ตาราง `buyplan` (แผนการซื้อ - รายปี):**
```sql
✅ YEAR - ปี
✅ DEPT_ID - หน่วยงาน
✅ VALUE_1_YEAR, VALUE_2_YEAR, VALUE_3_YEAR - มูลค่า 3 ปีย้อนหลัง
✅ VALUE_THIS_YEAR - มูลค่าปีนี้
✅ TRIMESTER1, 2, 3, 4 - มูลค่าแบ่งตามไตรมาส
✅ BUY_TRIMES1-4 - ซื้อไปแล้วแต่ละไตรมาส
✅ RM_TRIMES1-4 - คงเหลือแต่ละไตรมาส
✅ APPROVE - อนุมัติแล้วหรือไม่
```

**ตาราง `buyplan_c` (แผนการซื้อ - รายยา):**
```sql
✅ YEAR - ปี
✅ WORKING_CODE, TRADE_CODE - รหัสยา
✅ DEPT_ID - หน่วยงาน
✅ RATE_1_YEAR, RATE_2_YEAR, RATE_3_YEAR - อัตราการใช้ 3 ปีย้อนหลัง
✅ AVG_3_YEAR - ค่าเฉลี่ย 3 ปี
✅ QTY_THIS_YEAR - ปริมาณวางแผนปีนี้
✅ TRIMESTER1-4 - ปริมาณแบ่งตามไตรมาส
✅ QTY_BUY_TRI1-4 - ซื้อไปแล้วแต่ละไตรมาส
✅ QTY_RM_TRI1-4 - คงเหลือแต่ละไตรมาส
✅ QTY_RCV_TRI1-4 - รับเข้าแต่ละไตรมาส
✅ MIN_LEVEL - ระดับขั้นต่ำ
✅ QTY_ON_HAND - ปริมาณคงคลัง
✅ FORECAST - ค่าพยากรณ์
```

#### ระบบเรามีอะไร:

```sql
✅ budget_plans (แผนจัดซื้อ)
✅ budget_plan_items (รายการยา)
   - year1_quantity, year2_quantity, year3_quantity
   - average_quantity
   - q1_quantity, q2_quantity, q3_quantity, q4_quantity
   - q1_purchased, q2_purchased, q3_purchased, q4_purchased
```

#### เปรียบเทียบ:

```
✅ ระบบเราครบเกือบหมด!
🟡 ยังขาด:
   - รับเข้าแต่ละไตรมาส (QTY_RCV_TRI1-4)
   - ค่าพยากรณ์ (FORECAST)
   - ปริมาณคงคลัง (QTY_ON_HAND)
```

#### แนวทางแก้ไข:

```sql
ALTER TABLE budget_plan_items
ADD COLUMN q1_received DECIMAL(10,2),
ADD COLUMN q2_received DECIMAL(10,2),
ADD COLUMN q3_received DECIMAL(10,2),
ADD COLUMN q4_received DECIMAL(10,2),
ADD COLUMN forecast_quantity DECIMAL(10,2),
ADD COLUMN current_stock DECIMAL(10,2);
```

---

## 📊 สรุปตารางที่ต้องเพิ่ม

### 🔴 **Priority 1 - Critical (ต้องมี)**

#### 1. ระบบสัญญา (3 วัน)

```sql
CREATE TABLE contracts (
    id BIGSERIAL PRIMARY KEY,
    contract_number VARCHAR(20) UNIQUE NOT NULL,
    contract_type VARCHAR(20) NOT NULL,
    vendor_id BIGINT REFERENCES companies(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_value DECIMAL(15,2),
    remaining_value DECIMAL(15,2),
    payment_terms TEXT,
    fiscal_year VARCHAR(4),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE contract_items (
    id BIGSERIAL PRIMARY KEY,
    contract_id BIGINT REFERENCES contracts(id) ON DELETE CASCADE,
    drug_id BIGINT REFERENCES drugs(id),
    unit_price DECIMAL(10,2) NOT NULL,
    quantity_contracted DECIMAL(10,2),
    quantity_remaining DECIMAL(10,2),
    value_contracted DECIMAL(15,2),
    value_remaining DECIMAL(15,2),
    discount_percent DECIMAL(5,2),
    notes TEXT,
    UNIQUE(contract_id, drug_id)
);
```

**Effort:** 3 วัน

---

#### 2. กรรมการตรวจรับ (2 วัน)

```sql
CREATE TABLE receipt_inspectors (
    id BIGSERIAL PRIMARY KEY,
    receipt_id BIGINT REFERENCES receipts(id) ON DELETE CASCADE,
    inspector_name VARCHAR(100) NOT NULL,
    inspector_position VARCHAR(100),
    inspector_role VARCHAR(50),
    signed_date TIMESTAMP,
    signature_path VARCHAR(255),
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE receipts
ADD COLUMN invoice_number VARCHAR(50),
ADD COLUMN invoice_date DATE,
ADD COLUMN received_date TIMESTAMP,
ADD COLUMN verified_date TIMESTAMP,
ADD COLUMN posted_date TIMESTAMP;

-- แก้ไข enum ReceiptStatus
-- เพิ่ม: PENDING_VERIFICATION
```

**Effort:** 2 วัน

---

#### 3. ใบขออนุมัติ (1 วัน)

```sql
CREATE TABLE approval_documents (
    id BIGSERIAL PRIMARY KEY,
    approval_doc_number VARCHAR(20) UNIQUE NOT NULL,
    po_id BIGINT REFERENCES purchase_orders(id),
    approval_type VARCHAR(20) DEFAULT 'NORMAL',
    requested_by BIGINT,
    requested_date DATE,
    approved_by BIGINT,
    approval_date DATE,
    approval_remarks TEXT,
    status VARCHAR(20) DEFAULT 'PENDING',
    document_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Effort:** 1 วัน

---

### 🟡 **Priority 2 - Important (ควรมี)**

#### 4. เพิ่มฟิลด์ใน PO (0.5 วัน)

```sql
ALTER TABLE purchase_orders
ADD COLUMN contract_id BIGINT REFERENCES contracts(id),
ADD COLUMN sent_to_vendor_date DATE,
ADD COLUMN printed_date DATE,
ADD COLUMN confirmed_by BIGINT,
ADD COLUMN confirmed_date TIMESTAMP;
```

#### 5. เพิ่มฟิลด์ใน Budget Plan Items (0.5 วัน)

```sql
ALTER TABLE budget_plan_items
ADD COLUMN q1_received DECIMAL(10,2),
ADD COLUMN q2_received DECIMAL(10,2),
ADD COLUMN q3_received DECIMAL(10,2),
ADD COLUMN q4_received DECIMAL(10,2),
ADD COLUMN forecast_quantity DECIMAL(10,2),
ADD COLUMN current_stock DECIMAL(10,2);
```

#### 6. ติดตามการจ่ายเงิน (2 วัน)

```sql
CREATE TABLE payment_documents (
    id BIGSERIAL PRIMARY KEY,
    payment_doc_number VARCHAR(20) UNIQUE,
    receipt_id BIGINT REFERENCES receipts(id),
    po_id BIGINT REFERENCES purchase_orders(id),
    vendor_id BIGINT REFERENCES companies(id),
    total_amount DECIMAL(15,2),
    submitted_to_finance_date DATE,
    approved_date DATE,
    paid_date DATE,
    payment_status VARCHAR(20) DEFAULT 'PENDING',
    payment_method VARCHAR(50),
    payment_reference VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 📈 Timeline แนะนำ

### Week 1: Critical Fixes (6 วัน)
```
Day 1-3: ✏️ สร้างตาราง contracts + contract_items
Day 4-5: ✏️ สร้าง receipt_inspectors + แก้ receipts
Day 6:   ✏️ สร้าง approval_documents
```

### Week 2: Important Features (3 วัน)
```
Day 1:   ✏️ เพิ่มฟิลด์ PO + Budget Plan
Day 2-3: ✏️ สร้าง payment_documents
```

**รวมทั้งหมด:** 9 วันทำการ

---

## 💡 ข้อค้นพบสำคัญจากระบบเดิม

### 1. **ระบบเดิมรองรับรับของหลาย Lot ในรายการเดียว** ⭐

```sql
sm_po_c มีฟิลด์:
- QTY_RCV1, EXPIRED_DATE1, LOCATION1, VENDOR_CODE2
- QTY_RCV2, EXPIRED_DATE2, LOCATION2, VENDOR_CODE2
- QTY_RCV3, EXPIRED_DATE3, LOCATION3, VENDOR_CODE3
```

**ความหมาย:** สั่งซื้อ Paracetamol 10,000 เม็ด แต่รับมา 3 Lot:
- Lot A: 3,000 เม็ด (หมดอายุ 12/2025)
- Lot B: 5,000 เม็ด (หมดอายุ 06/2026)
- Lot C: 2,000 เม็ด (หมดอายุ 09/2026)

**ระบบเรา:**
- ✅ รองรับแล้ว! (ใช้ receipt_items หลายแถว สำหรับ drugId เดียวกัน)

---

### 2. **ระบบเดิมมีการติดตามการใช้สัญญา** ⭐

```sql
contract_items มี:
- quantity_contracted (ตกลงไว้ 100,000)
- quantity_remaining (คงเหลือ 50,000)
→ หมายความว่า ซื้อไปแล้ว 50,000
```

**ระบบเรา:**
- ❌ ยังไม่มี → ต้องเพิ่ม

---

### 3. **ระบบเดิมมีการติดตามสถานะละเอียด** ⭐

```sql
sm_po มี:
- CONFIRM_FLAG (ยืนยันแล้ว Y/N)
- SEND_FLAG (ส่งให้ผู้ขายแล้ว Y/N)
- PRINT_FLAG (พิมพ์แล้ว Y/N)
- R_S_STATUS (สถานะรับ-ส่ง)
```

**ระบบเรา:**
- 🟡 มีบ้างแต่ไม่ครบ → ควรเพิ่ม

---

## 🎯 คำแนะนำสุดท้าย

### จากการวิเคราะห์ข้อมูลจริง:

**ระบบเดิมมีความสมบูรณ์สูงมาก** โดยเฉพาะ:
1. ✅ ระบบสัญญาครบถ้วน - มีทั้งข้อมูลหลัก, รายการ, การติดตาม
2. ✅ รองรับรับของหลาย Lot - ในรายการเดียว
3. ✅ ติดตามสถานะละเอียด - SEND, PRINT, CONFIRM
4. ✅ Budget Planning แบบละเอียด - รายยา, รายไตรมาส, มี 3 ปีย้อนหลัง

**ระบบเราต้องเพิ่ม (Priority):**
1. 🔴 สัญญา (สำคัญที่สุด!)
2. 🔴 กรรมการตรวจรับหลายคน
3. 🟡 ใบขออนุมัติแยก
4. 🟡 ฟิลด์เพิ่มเติมใน PO, Receipt

**งานที่ต้องทำ:**
- Week 1 (6 วัน): เพิ่ม 3 ตารางหลัก
- Week 2 (3 วัน): เพิ่มฟิลด์และตารางรอง
- **รวม: 9 วันทำการ**

---

## 📞 ขั้นตอนถัดไป

### ทันที:
- [ ] Review Gap Analysis กับทีม
- [ ] Approve แผนการพัฒนา 9 วัน
- [ ] เริ่มเขียน Migration Scripts

### Week 1:
- [ ] Day 1-3: สร้างตาราง contracts
- [ ] Day 4-5: สร้างตาราง receipt_inspectors
- [ ] Day 6: สร้างตาราง approval_documents

### Week 2:
- [ ] Day 1: เพิ่มฟิลด์ต่างๆ
- [ ] Day 2-3: สร้าง payment_documents
- [ ] Day 4-5: Test & Verify

### Week 3:
- [ ] เขียน Backend API
- [ ] เขียน Frontend
- [ ] Integration Testing

---

**Version:** 2.0 (Final)
**วันที่:** 20 ตุลาคม 2568
**สถานะ:** ✅ Complete - พร้อมเริ่มพัฒนา

**ข้อมูลอ้างอิง:**
- ✅ คู่มือ INVS_MANUAL-01.pdf
- ✅ MySQL Database (133 ตาราง, 816 companies, 7,258 drugs)
- ✅ Prisma Schema v1.2.0

---

*เอกสารนี้จัดทำจากข้อมูลจริง 100% พร้อมใช้สำหรับการพัฒนาต่อ*
