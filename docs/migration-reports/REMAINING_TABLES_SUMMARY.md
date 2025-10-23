# ตารางที่เหลือ (Remaining Tables)

**Date**: 2025-01-22
**Current Status**: 42/48 tables (90% complete)

---

## 📊 สรุปความคืบหน้า

### ✅ ทำเสร็จแล้ว (Completed)

**Phase 1** (4 tables):
- ✅ purchase_methods - 18 records
- ✅ purchase_types - 20 records
- ✅ return_reasons - 19 records
- ✅ drug_pack_ratios - 0/1,641 (structure ready)

**Phase 2** (3 items):
- ✅ drug_components - 0/736 (structure ready)
- ✅ drug_focus_lists - 0/92 (structure ready)
- ✅ tmt_units (UOM) - 85 records

**Total Completed**: 7 items, 142 records migrated

---

## ⏳ Phase 3: ตารางที่เหลือ (MEDIUM Priority)

### 1. **distribution_types** (dist_type) ⭐⭐⭐
**Records**: 2
**Complexity**: ⭐ Very Easy
**Time**: 10 minutes

**Data**:
1. ให้ยืม (Borrow/Lend)
2. คืน (Return)

**Purpose**: จำแนกประเภทการจ่ายยา (ถาวร vs ยืม-คืน)

**Impact**:
- ✅ แยกประเภทการจ่ายชัดเจน
- ✅ Audit trail สำหรับยืม-คืน

**Alternative**: อาจใช้ enum แทน table ได้

---

### 2. **purchase_order_reasons** (po_reason) ⭐⭐⭐
**Records**: 2
**Complexity**: ⭐ Very Easy
**Time**: 10 minutes

**Data**:
1. สั่งผิดรายการ (Ordered wrong item)
2. บริษัทไม่มีของส่งให้ (Vendor out of stock)

**Purpose**: เหตุผลการยกเลิก/แก้ไข PO

**Impact**:
- ✅ Audit trail สำหรับ PO changes
- ✅ Root cause analysis

**Alternative**: อาจใช้ free text field แทนได้

---

### 3. **document_workflows** (doc_flow) ⭐⭐⭐
**Records**: 8
**Complexity**: ⭐⭐ Easy
**Time**: 20 minutes

**Structure**:
```sql
- ref_no: varchar(7) (PK)
- send_date, receive_date: date
- send_dept_id, receive_dept_id: bigint (FK departments)
- total_invoices: int
- confirm_flag: boolean
- budget_type_id: bigint (FK budget_types)
```

**Purpose**: ติดตามการส่งเอกสาร/ใบแจ้งหนี้ระหว่างหน่วย

**Impact**:
- ✅ ติดตามเอกสารข้ามหน่วยงาน
- ✅ Workflow management
- ⚠️ อาจไม่จำเป็นมาก (ใช้ receipt/distribution แทนได้)

---

### 4. **budget_units** (gpu) ⭐⭐⭐⭐
**Records**: 10,847
**Complexity**: ⭐⭐⭐⭐⭐ Very Complex
**Time**: Several hours

**Structure**:
```sql
- gpuid: bigint (PK)
- gpid: bigint
- contunitid: bigint
- contvalue: decimal
- effect_date, invalid_date: date
- fsn: text (TMT full substance name)
- dispid, replace_id: bigint
```

**Purpose**: งบประมาณระดับ TMT substance (ละเอียดมาก)

**Analysis**:
- ตารางนี้เก็บ budget allocation ในระดับ TMT concept
- มี 10,847 records (มากมาย)
- เชื่อมโยงกับ TMT hierarchy
- ใช้สำหรับ government fund tracking ที่ละเอียดมาก

**Impact**:
- ✅ Budget tracking ระดับ substance
- ⚠️ ซับซ้อนมาก อาจไม่จำเป็น
- ⚠️ ต้องมี TMT data ครบก่อน

**Recommendation**:
- ⚠️ **ประเมินก่อนว่าจำเป็นหรือไม่**
- ถ้าไม่ใช้ ให้ skip ไป
- ถ้าใช้ ต้องศึกษาโครงสร้างให้ดีก่อน

---

## ⏸️ Optional / Low Priority

### 5. **drug_specifications** (drug_spec) ⭐⭐
**Records**: 116
**Complexity**: ⭐⭐ Easy
**Time**: 15 minutes

**Structure**:
```sql
- drug_id: bigint (PK, FK)
- specification_text: text
- attachment_file: bytea (PDF/images)
- file_name: varchar(30)
```

**Purpose**: แนบ spec sheet, datasheet, certificates

**Status**: ส่วนใหญ่เป็น NULL ในฐานเก่า

**Impact**:
- ⚠️ มีประโยชน์แต่ไม่เร่งด่วน
- ⚠️ ข้อมูลในฐานเก่าไม่ครบ

---

### 6. **adjustment_reasons** (adj_reason) ⭐
**Records**: 0 (empty!)
**Complexity**: ⭐ Very Easy
**Time**: 5 minutes

**Purpose**: เหตุผลการปรับสต็อก

**Status**: ตารางว่างเปล่าในฐาน MySQL

**Recommendation**: ⛔ **Skip** - ไม่มีข้อมูล

---

### 7. **budget_funds** (gf) ⭐
**Records**: 0 (empty!)
**Complexity**: ⭐ Very Easy
**Time**: 5 minutes

**Purpose**: Government fund tracking (เลขที่กันเงิน)

**Status**: ตารางว่างเปล่าในฐาน MySQL

**Recommendation**: ⛔ **Skip** - ไม่มีข้อมูล

---

## 📋 Priority Ranking

### 🔴 Skip (ไม่ต้องทำ)
1. ⛔ adjustment_reasons - Empty table
2. ⛔ budget_funds - Empty table

### 🟡 Optional (ทำถ้ามีเวลา)
3. ⏸️ drug_specifications - 116 records (mostly empty)

### 🟢 Recommended (ควรทำ)
4. ✅ distribution_types - 2 records (10 min)
5. ✅ purchase_order_reasons - 2 records (10 min)
6. ⚠️ document_workflows - 8 records (20 min) [evaluate first]

### 🔵 Complex (ต้องประเมิน)
7. ⚠️ budget_units - 10,847 records (several hours) [evaluate if needed]

---

## 🎯 Recommended Phase 3 Plan

### Option A: Quick & Essential (30 minutes)
```
1. distribution_types     - 10 min
2. purchase_order_reasons - 10 min
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total: 4 records, 20 minutes
```

**Result**: 95% complete (44/48 tables)

### Option B: Add Document Flow (50 minutes)
```
1. distribution_types     - 10 min
2. purchase_order_reasons - 10 min
3. document_workflows     - 20 min
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total: 12 records, 40 minutes
```

**Result**: 96% complete (45/48 tables)

### Option C: Full Phase 3 (Several days)
```
1. distribution_types     - 10 min
2. purchase_order_reasons - 10 min
3. document_workflows     - 20 min
4. budget_units          - Several hours (complex!)
5. drug_specifications   - 15 min
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total: 10,979 records, several hours
```

**Result**: 98% complete (47/48 tables)

---

## 💡 Recommendation

### ✅ Do Now (Quick Win)
**Option A**: distribution_types + purchase_order_reasons
- เวลา: 20 นาที
- ผลลัพธ์: 95% complete
- ง่าย, ได้ประโยชน์ทันที

### ⚠️ Evaluate First
**budget_units** (gpu):
- ถามผู้ใช้ว่าจำเป็นหรือไม่
- ถ้าไม่ใช้ ให้ skip เลย
- ถ้าใช้ ต้องศึกษาโครงสร้างให้ดี

### ⏸️ Nice to Have
- document_workflows - ถ้ามีเวลา
- drug_specifications - ไม่เร่งด่วน

---

## 📊 Current vs Target

### Current Status (After Phase 1 & 2)
```
Tables:     42/48 (90%)
Records:   142 migrated
Pending: 2,469 (need drug data)
```

### After Quick Phase 3 (Option A)
```
Tables:     44/48 (95%)
Records:   146 migrated
Time:       20 minutes
```

### Maximum (All tables)
```
Tables:     47/48 (98%)
Records: 11,121 migrated (if budget_units included)
Time:     Several hours
```

---

## 🚀 Next Action

**Immediate** (20 minutes):
```bash
# Phase 3A: Quick essentials
1. Add distribution_types table
2. Add purchase_order_reasons table
3. Migrate 4 records
4. Test and verify
5. Commit and push
```

**Then Ask User**:
- ใช้ document_workflows ไหม? (8 records)
- ใช้ budget_units ไหม? (10,847 records)
- ต้องการ drug_specifications ไหม? (116 records)

---

**Generated**: 2025-01-22
**Current Progress**: 90% (42/48 tables)
**Quick Win Available**: +5% in 20 minutes
**Version**: 2.3.0
