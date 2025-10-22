# INVS Modern - Flow Documentation
## เอกสารการไหลของข้อมูลและ Workflows

---

## 📚 **สารบัญเอกสาร**

### 🚀 **เริ่มต้นที่นี่:**
- **[QUICK_START_GUIDE.md](./QUICK_START_GUIDE.md)**
  - คู่มือเริ่มต้นใช้งานระบบ
  - คำสั่งติดตั้งและรัน
  - ตัวอย่างการใช้งานเบื้องต้น
  - Troubleshooting

- **[DATA_FLOW_COMPLETE_GUIDE.md](./DATA_FLOW_COMPLETE_GUIDE.md)** ⭐
  - **Master Index** - สรุปทุก flow ในที่เดียว
  - ภาพรวมระบบทั้งหมด
  - End-to-end example
  - Database state tracking
  - KPIs และ monitoring queries

---

## 📖 **เอกสาร Flow แบบละเอียด**

### 1️⃣ **FLOW 01: Master Data Setup**
📄 **[FLOW_01_Master_Data_Setup.md](./FLOW_01_Master_Data_Setup.md)**

**ครอบคลุม:**
- Locations Setup (สถานที่จัดเก็บ)
- Departments Setup (หน่วยงาน)
- Budget Types Setup (ประเภทงบประมาณ)
- Companies Setup (บริษัทผู้ผลิต/จำหน่าย)
- Drug Generics Setup (ยาสามัญ)
- Drugs Setup (ยาการค้า)

**เนื้อหา:**
- ✅ UI Mockups สำหรับแต่ละหน้าจอ
- ✅ ตัวอย่างข้อมูลครบทุกฟิลด์
- ✅ SQL INSERT statements
- ✅ Validation rules
- ✅ Success criteria checklist

---

### 2️⃣ **FLOW 02: Budget Management**
📄 **[FLOW_02_Budget_Management.md](./FLOW_02_Budget_Management.md)**

**ครอบคลุม:**
- Budget Planning (วางแผนงบประมาณ)
- Budget Allocation (จัดสรรงบประมาณรายไตรมาส)
- Budget Availability Check (ตรวจสอบงบคงเหลือ)
- Budget Reservation (จองงบไว้สำหรับ PR)
- Budget Commitment (หักงบจริงเมื่ออนุมัติ PO)
- Budget Monitoring (ติดตามการใช้จ่าย)

**เนื้อหา:**
- ✅ 5 Phases workflow
- ✅ UI Mockups (Allocation form, Check dialog, Dashboard)
- ✅ Database Functions usage
- ✅ Budget calculation examples
- ✅ Real-time monitoring queries

**Key Functions:**
```sql
check_budget_availability()
reserve_budget()
commit_budget()
release_budget_reservation()
```

---

### 3️⃣ **FLOW 03: Procurement Workflow**

#### Part 1: Purchase Request (PR)
📄 **[FLOW_03_Procurement_Part1_PR.md](./FLOW_03_Procurement_Part1_PR.md)**

**ครอบคลุม:**
- PR Creation (สร้างคำขอซื้อ)
- Budget Check (ตรวจสอบงบประมาณ)
- Budget Reservation (จองงบ)
- PR Approval Workflow (อนุมัติคำขอ)

**เนื้อหา:**
- ✅ Complete PR workflow
- ✅ UI Mockups (PR Form, PR List, Approval screens)
- ✅ SQL examples สำหรับทุกขั้นตอน
- ✅ Budget integration
- ✅ Validation และ error handling

**Status Flow:**
```
draft → submitted → approved → converted
```

#### Part 2: Purchase Order (PO)
📄 **สรุปใน DATA_FLOW_COMPLETE_GUIDE.md**

**ครอบคลุม:**
- PO Creation from PR
- Trade Drug Selection
- Vendor Selection
- Budget Commitment
- PO Approval & Sending

#### Part 3: Goods Receipt
📄 **สรุปใน DATA_FLOW_COMPLETE_GUIDE.md**

**ครอบคลุม:**
- Receipt Creation
- Lot Number Recording
- Expiry Date Tracking
- Inventory Update
- PO Closure

---

### 4️⃣ **FLOW 04: Inventory Management**
📄 **สรุปใน DATA_FLOW_COMPLETE_GUIDE.md**

**ครอบคลุม:**
- Stock Level Tracking
- FIFO/FEFO Management
- Multi-location Support
- Transaction Logging
- Reorder Point Alerts

**Key Views:**
```sql
low_stock_items
expiring_drugs
current_stock_summary
```

**Key Functions:**
```sql
get_fifo_lots()
get_fefo_lots()
update_inventory_from_receipt()
```

---

### 5️⃣ **FLOW 05: Drug Distribution**
📄 **สรุปใน DATA_FLOW_COMPLETE_GUIDE.md**

**ครอบคลุม:**
- Department Request
- Stock Availability Check
- FEFO Lot Selection
- Drug Dispensing
- Inventory Auto-update

**Tables:**
- drug_distributions
- drug_distribution_items

---

### 6️⃣ **FLOW 06: TMT Integration**
📄 **สรุปใน DATA_FLOW_COMPLETE_GUIDE.md**

**ครอบคลุม:**
- Drug Code Mapping
- TMT Hierarchy (SUBS → VTM → GP → TP → GPU → TPU → GPP → TPP)
- NC24 Assignment
- HIS Integration
- Ministry Standards Compliance

**Tables:**
- tmt_concepts (25,991 records)
- tmt_mappings
- his_drug_master

---

### 7️⃣ **FLOW 07: Ministry Reporting**
📄 **สรุปใน DATA_FLOW_COMPLETE_GUIDE.md**

**ครอบคลุม:**
- 5 แฟ้มข้อมูล กระทรวงสาธารณสุข
  1. Druglist (บัญชีรายการยา)
  2. Purchase Plan (แผนจัดซื้อ)
  3. Receipt (การรับยา)
  4. Distribution (การจ่ายยา)
  5. Inventory (ยาคงคลัง)
- Export Functions
- Data Validation
- Report Generation

**Views:**
```sql
export_druglist
export_purchase_plan
export_receipt
export_distribution
export_inventory
```

---

## 🎯 **แนะนำการอ่าน**

### สำหรับนักพัฒนาใหม่:
1. **เริ่มที่** QUICK_START_GUIDE.md - ติดตั้งและรันระบบ
2. **อ่าน** DATA_FLOW_COMPLETE_GUIDE.md - ภาพรวมทั้งหมด
3. **ศึกษาแต่ละ Flow** ตามลำดับ 01 → 02 → 03 → ...

### สำหรับ Product Owner:
1. **อ่าน** DATA_FLOW_COMPLETE_GUIDE.md - End-to-end example
2. **Review** UI Mockups ในแต่ละ Flow document
3. **ตรวจสอบ** Business rules และ validation

### สำหรับ QA/Tester:
1. **ใช้** SQL examples เป็น test cases
2. **ตรวจสอบ** Expected results ในแต่ละขั้นตอน
3. **ทดสอบ** Error handling scenarios

### สำหรับ DBA:
1. **ดู** Database Functions (prisma/functions.sql)
2. **ดู** Database Views (prisma/views.sql)
3. **อ่าน** Monitoring queries ในแต่ละ Flow

---

## 📊 **โครงสร้าง Folder**

```
docs/flows/
├── README.md                           # ไฟล์นี้
├── QUICK_START_GUIDE.md               # เริ่มต้นที่นี่
├── DATA_FLOW_COMPLETE_GUIDE.md        # Master Index ⭐
├── FLOW_01_Master_Data_Setup.md       # Setup ข้อมูลพื้นฐาน
├── FLOW_02_Budget_Management.md       # บริหารงบประมาณ
└── FLOW_03_Procurement_Part1_PR.md    # Purchase Request
```

---

## 🔗 **เอกสารอื่นๆ ที่เกี่ยวข้อง**

### ใน docs/ (parent folder):
- **business-rules.md** - กฎธุรกิจและ authorization matrix
- **system-flows.md** - Flow diagrams ทั้งหมด
- **TMT_SYSTEM_COMPLETE.md** - ระบบ TMT แบบละเอียด
- **legacy-analysis.md** - การวิเคราะห์ระบบเดิม

### ใน prisma/:
- **schema.prisma** - Database schema (32 tables)
- **views.sql** - Database views (11 views)
- **functions.sql** - Database functions (10 functions)
- **seed.ts** - Master data seeding script

---

## ✅ **Quick Reference**

### System Components
- **32 Tables** - ครอบคลุมทุก workflow
- **11 Views** - Ministry + Operational reporting
- **10 Functions** - Budget + Inventory logic
- **6 Budget Types** - ประเภทงบประมาณ
- **5 Export Views** - แฟ้มข้อมูล กสธ.
- **25,991 TMT Concepts** - Thai Medical Terminology

### Key Technologies
- **Database**: PostgreSQL 15
- **ORM**: Prisma
- **Language**: TypeScript
- **Container**: Docker
- **Port**: 5434

### Development URLs
- **pgAdmin**: http://localhost:8081
- **Prisma Studio**: http://localhost:5555

---

## 📞 **สนับสนุน**

หากมีคำถามหรือต้องการความช่วยเหลือ:
1. ดูที่ **QUICK_START_GUIDE.md** สำหรับ troubleshooting
2. ตรวจสอบ database logs: `docker logs invs-modern-db`
3. ดู console output: `npm run dev`

---

**Last Updated**: 2025-01-10
**Version**: 1.0.0
**Status**: Production Ready ✅

*Created with ❤️ by Claude Code*
