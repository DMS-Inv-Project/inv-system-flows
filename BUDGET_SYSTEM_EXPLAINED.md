# 📊 BUDGET SYSTEM - โครงสร้างและการใช้งาน

**INVS Modern - Hospital Inventory Management System**

---

## 🎯 ภาพรวมระบบงบประมาณ

ระบบงบประมาณของ INVS Modern แบ่งออกเป็น **2 ส่วนหลัก**:

### 1️⃣ **โครงสร้างเดิม (Legacy Structure)** - กำลังใช้งานอยู่
- `budget_types` → การจัดสรรงบประมาณ และ Purchase Orders

### 2️⃣ **โครงสร้างใหม่ (New Structure)** - เพิ่งเพิ่มเข้ามา
- `budget_type` → `budget` → `budget_category` (โครงสร้าง 3 ชั้น)

---

## 📋 ตารางทั้งหมดในระบบ Budget (10 ตาราง)

### **Tables (7 ตาราง)**
1. ✅ `budget_types` - **[เดิม]** ประเภทงบประมาณสำหรับ allocations
2. ✅ `budget_type` - **[ใหม่]** ประเภทงบประมาณ (งบเงินบำรุง, งบลงทุน)
3. ✅ `budget_category` - **[ใหม่]** หมวดค่าใช้จ่าย (เวชภัณฑ์, ยา)
4. ✅ `budget` - **[ใหม่]** งบประมาณหลัก (เชื่อมโยง type และ category)
5. ✅ `budget_allocations` - การจัดสรรงบประมาณรายปี
6. ✅ `budget_plans` - แผนการใช้งบประมาณ (ระดับยา)
7. ✅ `budget_reservations` - การจองงบประมาณชั่วคราว

### **Views (3 ตาราง)**
8. ✅ `budget_status_current` - สถานะงบประมาณปัจจุบัน
9. ✅ `budget_reservations_active` - การจองงบประมาณที่ active
10. ⚠️ อีก 1 view (ถ้ามี)

---

## 🗂️ โครงสร้างและการทำงาน

### **📊 FLOW 1: โครงสร้างเดิม (กำลังใช้งานอยู่)**

```
┌─────────────────────┐
│   budget_types      │ ← [เดิม] OP001-ยา, OP002-เครื่องมือ, ฯลฯ
│   (6 records)       │
└──────────┬──────────┘
           │
           ├─────────────────────────────────┐
           │                                 │
           ▼                                 ▼
┌──────────────────────┐         ┌─────────────────────┐
│ budget_allocations   │         │  purchase_orders    │
│                      │         │                     │
│ - fiscal_year: 2025  │         │ - PO details        │
│ - department_id      │         │ - budget_type_id ───┤ FK
│ - budget_type_id ────┤ FK      │ - amount            │
│ - total_budget       │         └─────────────────────┘
│ - q1-q4_budget       │
│ - total_spent        │
│ - remaining          │
└──────────┬───────────┘
           │
           ├──────────────────┬────────────────┐
           │                  │                │
           ▼                  ▼                ▼
┌──────────────────┐  ┌─────────────┐  ┌──────────────┐
│  budget_plans    │  │ budget_     │  │ PR, PO, etc  │
│                  │  │ reservations│  │              │
│ - ระดับแผน       │  │             │  │              │
│ - แยกรายยา       │  │ - จองชั่วคราว│  │              │
└──────────────────┘  └─────────────┘  └──────────────┘
```

---

### **📊 FLOW 2: โครงสร้างใหม่ (เพิ่งเพิ่มเข้ามา)**

```
┌─────────────────────────┐
│   budget_type           │ ← [ใหม่] ประเภทงบประมาณ
│   (3 records)           │
│                         │
│ '01' - งบเงินบำรุง       │
│ '02' - งบลงทุน          │
│ '03' - งบบุคลากร        │
└────────────┬────────────┘
             │
             │ (type_code → budget_type)
             ▼
┌─────────────────────────┐
│   budget                │ ← [ใหม่] งบประมาณหลัก
│   (2 records)           │
│                         │
│ OP001 - เวชภัณฑ์ไม่ใช่ยา │
│ OP002 - ยา              │
└────────────┬────────────┘
             │
             │ (category_code → budget_category)
             ▼
┌─────────────────────────┐
│  budget_category        │ ← [ใหม่] หมวดค่าใช้จ่าย
│  (3 records)            │
│                         │
│ '0101' - เวชภัณฑ์ไม่ใช่ยา│
│         Acc: 1105010103.102
│ '0102' - ยา             │
│         Acc: 1105010103.101
│ '0103' - เครื่องมือแพทย์ │
└─────────────────────────┘
```

---

## 📝 อธิบายแต่ละตาราง

### **1. budget_types** (เดิม - กำลังใช้งาน) ⭐

**ใช้ทำอะไร:**
- เก็บประเภทงบประมาณสำหรับจัดสรรงบประมาณรายปี
- ใช้ในการอนุมัติ Purchase Orders

**ฟิลด์สำคัญ:**
```sql
- id                -- PK
- budget_code       -- 'OP001', 'OP002', etc.
- budget_name       -- 'งบดำเนินงาน - ยา'
- budget_description
```

**ถูกใช้โดย:**
- ✅ `budget_allocations.budget_type_id` (FK)
- ✅ `purchase_orders.budget_type_id` (FK)

**ข้อมูลปัจจุบัน:**
```
OP001 - งบดำเนินงาน - ยา
OP002 - งบดำเนินงาน - เครื่องมือ
OP003 - งบดำเนินงาน - วัสดุสิ้นเปลือง
INV001 - งบลงทุน - อุปกรณ์
INV002 - งบลงทุน - ระบบ IT
EM001 - งบฉุกเฉิน
```

---

### **2. budget_type** (ใหม่) 🆕

**ใช้ทำอะไร:**
- จัดกลุ่มงบประมาณตามประเภทหลัก (Type)
- เป็นระดับบนสุดของโครงสร้าง 3 ชั้น

**ฟิลด์สำคัญ:**
```sql
- type_code  -- '01', '02', '03'
- type_name  -- 'งบเงินบำรุง', 'งบลงทุน', 'งบบุคลากร'
```

**ถูกใช้โดย:**
- ✅ `budget.budget_type` (FK)

**ข้อมูลปัจจุบัน:**
```
'01' - งบเงินบำรุง
'02' - งบลงทุน
'03' - งบบุคลากร
```

---

### **3. budget_category** (ใหม่) 🆕

**ใช้ทำอะไร:**
- จัดกลุ่มงบประมาณตามหมวดค่าใช้จ่าย
- เชื่อมโยงกับรหัสผังบัญชี (Accounting Code)

**ฟิลด์สำคัญ:**
```sql
- category_code  -- '0101', '0102', '0103'
- category_name  -- 'เวชภัณฑ์ไม่ใช่ยา', 'ยา', 'เครื่องมือแพทย์'
- acc_code       -- '1105010103.102' (รหัสผังบัญชี)
- remark         -- หมายเหตุ
```

**ถูกใช้โดย:**
- ✅ `budget.budget_category` (FK)

**ข้อมูลปัจจุบัน:**
```
'0101' - เวชภัณฑ์ไม่ใช่ยา → Acc: 1105010103.102
'0102' - ยา → Acc: 1105010103.101
'0103' - เครื่องมือแพทย์ → Acc: 1105010103.103
```

---

### **4. budget** (ใหม่) 🆕

**ใช้ทำอะไร:**
- งบประมาณหลักที่เชื่อมโยง Type และ Category เข้าด้วยกัน
- ใช้สำหรับการอ้างอิงงบประมาณแบบครบถ้วน (รวมรหัสผังบัญชี)

**ฟิลด์สำคัญ:**
```sql
- budget_code        -- 'OP001', 'OP002'
- budget_type        -- '01' (FK → budget_type.type_code)
- budget_category    -- '0101' (FK → budget_category.category_code)
- budget_description
```

**ความสัมพันธ์:**
```
budget.budget_type → budget_type.type_code
budget.budget_category → budget_category.category_code
```

**ข้อมูลปัจจุบัน:**
```
OP001:
  - Type: '01' (งบเงินบำรุง)
  - Category: '0101' (เวชภัณฑ์ไม่ใช่ยา)
  - Acc Code: 1105010103.102

OP002:
  - Type: '01' (งบเงินบำรุง)
  - Category: '0102' (ยา)
  - Acc Code: 1105010103.101
```

**⚠️ หมายเหตุ:** ตอนนี้ยังไม่ถูกใช้โดยตารางอื่น (ยังไม่มี FK ชี้เข้ามา)

---

### **5. budget_allocations** ⭐⭐⭐

**ใช้ทำอะไร:**
- **จัดสรรงบประมาณรายปี** ให้แต่ละแผนก
- แบ่งงบประมาณเป็นรายไตรมาส (Q1-Q4)
- ติดตามยอดที่ใช้ไปและคงเหลือ

**ฟิลด์สำคัญ:**
```sql
-- การจัดสรร
- fiscal_year       -- 2025
- budget_type_id    -- FK → budget_types.id
- department_id     -- FK → departments.id

-- งบประมาณ
- total_budget      -- งบทั้งหมด
- q1_budget         -- งบ Q1
- q2_budget         -- งบ Q2
- q3_budget         -- งบ Q3
- q4_budget         -- งบ Q4

-- การใช้จ่าย
- total_spent       -- ใช้ไปทั้งหมด
- q1_spent          -- ใช้ไป Q1
- q2_spent          -- ใช้ไป Q2
- q3_spent          -- ใช้ไป Q3
- q4_spent          -- ใช้ไป Q4

-- สถานะ
- remaining_budget  -- คงเหลือ
- status            -- active, depleted, frozen
```

**ถูกใช้โดย:**
- ✅ `budget_plans` - แผนการใช้งบประมาณ
- ✅ `budget_reservations` - การจองงบประมาณ

**ตัวอย่างข้อมูล:**
```
Fiscal Year: 2025
Department: Pharmacy (PHARM)
Budget Type: OP001 - งบดำเนินงาน - ยา
Total Budget: 10,000,000 บาท
  - Q1: 2,500,000
  - Q2: 2,500,000
  - Q3: 2,500,000
  - Q4: 2,500,000
Total Spent: 0
Remaining: 10,000,000
```

---

### **6. budget_plans** ⭐⭐

**ใช้ทำอะไร:**
- **วางแผนการใช้งบประมาณ** ของแต่ละแผนก
- แยกรายละเอียดเป็นรายยา (ใน `budget_plan_items`)
- ติดตามว่าซื้อไปแล้วเท่าไหร่ เหลือเท่าไหร่

**ฟิลด์สำคัญ:**
```sql
-- การเชื่อมโยง
- budget_allocation_id  -- FK → budget_allocations.id
- department_id         -- FK → departments.id
- fiscal_year

-- งบที่วางแผน
- total_planned_budget   -- วางแผนทั้งหมด
- total_planned_quantity -- ปริมาณที่วางแผน
- q1_planned_budget
- q2_planned_budget
- q3_planned_budget
- q4_planned_budget

-- การซื้อจริง
- total_purchased
- q1_purchased
- q2_purchased
- q3_purchased
- q4_purchased

-- สถานะ
- remaining_budget
- status             -- draft, approved, in_progress, completed
- approved_by
- approval_date
```

**ถูกใช้โดย:**
- ✅ `budget_plan_items` - รายการยาในแผน

**ตัวอย่าง:**
```
แผนการใช้งบประมาณ ปี 2025 - แผนก Pharmacy
Allocation: งบดำเนินงาน - ยา (10M)
Planned: 9,000,000 บาท
  - Paracetamol: 2,000,000
  - Ibuprofen: 1,500,000
  - ฯลฯ
Purchased: 500,000 (ซื้อไปแล้ว)
Remaining: 8,500,000
Status: in_progress
```

---

### **7. budget_reservations** ⭐

**ใช้ทำอะไร:**
- **จองงบประมาณชั่วคราว** เมื่อสร้าง Purchase Request
- ป้องกันการใช้งบประมาณเกิน
- หมดอายุอัตโนมัติถ้าไม่อนุมัติ PR ภายในเวลาที่กำหนด

**ฟิลด์สำคัญ:**
```sql
- allocation_id      -- FK → budget_allocations.id
- pr_id             -- FK → purchase_requests.id (nullable)
- reserved_amount   -- จำนวนเงินที่จอง
- quarter           -- Q1, Q2, Q3, Q4
- expires_at        -- วันหมดอายุ
- status            -- active, released, committed
```

**วงจรการทำงาน:**
```
1. สร้าง PR → จองงบประมาณ (status: active)
2. PR อนุมัติ → สร้าง PO → commit งบประมาณ (status: committed)
3. PR ไม่อนุมัติ/หมดเวลา → ปลดล็อคงบประมาณ (status: released)
```

**ตัวอย่าง:**
```
PR-2025-001:
  - จองงบประมาณ: 500,000 บาท
  - Quarter: Q1
  - หมดอายุ: 7 วัน
  - สถานะ: active

เมื่อ PR อนุมัติ:
  - budget_allocations.q1_spent += 500,000
  - budget_reservations.status = committed
```

---

### **8. budget_status_current** (VIEW) 📊

**ใช้ทำอะไร:**
- แสดงสถานะงบประมาณปัจจุบันของทุกแผนก
- รวมข้อมูลจาก `budget_allocations`

**ข้อมูลที่แสดง:**
```sql
- department_name
- budget_type
- fiscal_year
- total_budget
- total_spent
- remaining_budget
- usage_percentage
- status
- ฯลฯ
```

---

### **9. budget_reservations_active** (VIEW) 📊

**ใช้ทำอะไร:**
- แสดงการจองงบประมาณที่ยัง active อยู่
- ติดตามงบประมาณที่ถูกจองไว้

---

## 🔄 การทำงานของระบบงบประมาณ

### **STEP 1: จัดสรรงบประมาณรายปี**
```sql
INSERT INTO budget_allocations (
  fiscal_year, budget_type_id, department_id,
  total_budget, q1_budget, q2_budget, q3_budget, q4_budget
) VALUES (
  2025, 1, 2,  -- OP001-ยา, Pharmacy
  10000000, 2500000, 2500000, 2500000, 2500000
);
```

### **STEP 2: วางแผนการใช้งบประมาณ**
```sql
-- สร้างแผน
INSERT INTO budget_plans (
  fiscal_year, department_id, budget_allocation_id,
  total_planned_budget, q1_planned_budget, ...
);

-- เพิ่มรายการยา
INSERT INTO budget_plan_items (
  budget_plan_id, generic_id,
  planned_quantity, estimated_unit_price, ...
);
```

### **STEP 3: สร้าง Purchase Request**
```sql
-- จองงบประมาณ
INSERT INTO budget_reservations (
  allocation_id, pr_id, reserved_amount, quarter
);
```

### **STEP 4: อนุมัติและสร้าง Purchase Order**
```sql
-- Commit งบประมาณ
UPDATE budget_allocations
SET q1_spent = q1_spent + 500000,
    remaining_budget = remaining_budget - 500000;

UPDATE budget_reservations
SET status = 'committed';
```

---

## 🎯 สรุป: ตาราง Budget ไหนใช้ทำอะไร

| ตาราง | จุดประสงค์ | ใช้โดย | สถานะ |
|-------|-----------|--------|-------|
| **budget_types** | ประเภทงบสำหรับ allocations | allocations, POs | ✅ Active |
| **budget_type** | ประเภทงบใหม่ (3 ชั้น) | budget | 🆕 New |
| **budget_category** | หมวดค่าใช้จ่าย + Acc Code | budget | 🆕 New |
| **budget** | งบประมาณหลัก (รวม type+category) | - | 🆕 New (ยังไม่ใช้) |
| **budget_allocations** | จัดสรรงบประมาณรายปี | plans, reservations | ✅ Active |
| **budget_plans** | แผนการใช้งบประมาณ | plan_items | ✅ Active |
| **budget_reservations** | จองงบประมาณชั่วคราว | - | ✅ Active |

---

## ⚠️ ปัญหาที่พบ: มี 2 โครงสร้างอยู่พร้อมกัน

### **โครงสร้างเดิม (กำลังใช้งาน):**
```
budget_types → budget_allocations → budget_plans
                                  → budget_reservations
             → purchase_orders
```

### **โครงสร้างใหม่ (ยังไม่ได้ใช้):**
```
budget_type → budget → budget_category
             (ยังไม่มี FK จากตารางอื่น)
```

### **แนวทางแก้ไข:**

**Option A: เก็บทั้ง 2 ระบบ** (แนะนำ)
- ใช้ `budget_types` สำหรับ allocations ต่อไป
- ใช้ `budget` + `budget_type` + `budget_category` สำหรับฟีเจอร์ใหม่ (เช่น รายงานผังบัญชี)

**Option B: Migrate ทั้งระบบ**
- แทนที่ `budget_types` ด้วย `budget`
- อัปเดต FK ทุกตาราง
- Migrate ข้อมูลเก่า

---

## 📞 สรุป

**ระบบงบประมาณ INVS Modern มี 2 โครงสร้าง:**

1. **เดิม**: `budget_types` → ใช้กับ allocations, plans, reservations, POs
2. **ใหม่**: `budget_type` + `budget` + `budget_category` → ยังไม่ได้เชื่อมกับระบบอื่น

**คำแนะนำ:** ควรตัดสินใจว่าจะใช้โครงสร้างไหน หรือจะรวมกันอย่างไร!

---

**Last Updated**: 2025-01-19
**Version**: 1.2.0
