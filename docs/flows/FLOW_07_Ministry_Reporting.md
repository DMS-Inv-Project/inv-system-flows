# FLOW 07: Ministry Reporting
## กระทรวงสาธารณสุข - 5 แฟ้มข้อมูลมาตรฐาน

**Version**: 1.0.0
**Last Updated**: 2025-01-11
**Status**: ✅ Complete

---

## 🎯 Overview

ระบบรายงานข้อมูลยาให้กระทรวงสาธารณสุขตามมาตรฐานที่กำหนด รองรับ 5 แฟ้มข้อมูลหลัก พร้อมการ export เป็น CSV/JSON

### 5 Ministry Data Files

```
1. 📋 DRUGLIST      - บัญชีรายการยา (Drug Catalog)
2. 📊 PURCHASE PLAN - แผนการจัดซื้อ (Procurement Planning)
3. 📦 RECEIPT       - การรับยา (Goods Receipt)
4. 💊 DISTRIBUTION  - การจ่ายยา (Drug Dispensing)
5. 📈 INVENTORY     - ยาคงคลัง (Stock on Hand)
```

---

## 📊 Ministry Tables & Views

```
┌────────────────────────────────────────┐
│       MINISTRY REPORTING               │
└────────────────────────────────────────┘

Database Views (11 views):
┌──────────────────────┐
│ Export Views (5)     │
├──────────────────────┤
│ • export_druglist    │  ← File 1: Drug catalog
│ • export_purchase_   │  ← File 2: Purchase planning
│   plan               │
│ • export_receipt     │  ← File 3: Goods receipt
│ • export_distribution│  ← File 4: Drug dispensing
│ • export_inventory   │  ← File 5: Stock levels
└──────────────────────┘

┌──────────────────────┐
│ Operational Views(6) │
├──────────────────────┤
│ • budget_status_     │
│   current            │
│ • expiring_drugs     │
│ • low_stock_items    │
│ • current_stock_     │
│   summary            │
│ • budget_            │
│   reservations_active│
│ • purchase_order_    │
│   status             │
└──────────────────────┘
```

---

## 📋 FILE 1: DRUGLIST - บัญชีรายการยา

### Purpose
รายงานยาทั้งหมดที่มีในโรงพยาบาล พร้อม TMT Code และรายละเอียดยา

### View Definition

```sql
CREATE VIEW export_druglist AS
SELECT
    d.drug_code,
    d.trade_name,
    dg.working_code,
    dg.generic_name,
    d.strength,
    d.dosage_form,
    c.company_name as manufacturer,
    tm.tmt_code,
    tm.tmt_level,
    tm.nc24_code,
    d.unit_price,
    d.package_size,
    d.is_active,
    d.created_at,
    d.updated_at
FROM drugs d
JOIN drug_generics dg ON d.generic_id = dg.id
LEFT JOIN companies c ON d.manufacturer_id = c.id
LEFT JOIN tmt_mappings tm ON d.id = tm.drug_id AND tm.is_active = true
WHERE d.is_active = true
ORDER BY d.drug_code;
```

### Export Query

```sql
-- Export druglist for ministry
SELECT * FROM export_druglist;
```

**Expected Fields:**
```
drug_code         | PAR0001-000001-001
trade_name        | GPO Paracetamol 500mg
working_code      | PAR0001
generic_name      | Paracetamol
strength          | 500mg
dosage_form       | Tablet
manufacturer      | Government Pharmaceutical Organization
tmt_code          | TPU00001
tmt_level         | TPU
nc24_code         | NC24-001
unit_price        | 2.50
package_size      | 1000
is_active         | true
```

---

## 📊 FILE 2: PURCHASE PLAN - แผนการจัดซื้อ

### Purpose
รายงานแผนการจัดซื้อยา เพื่อติดตามและวิเคราะห์การจัดซื้อ

### View Definition

```sql
CREATE VIEW export_purchase_plan AS
SELECT
    pr.pr_number,
    pr.pr_date,
    pr.fiscal_year,
    dept.dept_code,
    dept.dept_name,
    bt.budget_code,
    bt.budget_name,
    d.drug_code,
    d.trade_name,
    dg.generic_name,
    pri.quantity_requested,
    pri.estimated_unit_cost,
    pri.estimated_total_cost,
    pr.status,
    pr.approval_date,
    ba.total_budget,
    ba.total_spent,
    ba.remaining_budget
FROM purchase_requests pr
JOIN purchase_request_items pri ON pr.id = pri.pr_id
JOIN drugs d ON pri.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN departments dept ON pr.department_id = dept.id
JOIN budget_types bt ON pr.budget_type_id = bt.id
LEFT JOIN budget_allocations ba ON pr.budget_allocation_id = ba.id
WHERE pr.status IN ('approved', 'converted')
ORDER BY pr.pr_date DESC, pr.pr_number;
```

---

## 📦 FILE 3: RECEIPT - การรับยา

### Purpose
รายงานการรับยาเข้าคลัง เพื่อติดตามการจัดหายา

### View Definition

```sql
CREATE VIEW export_receipt AS
SELECT
    r.receipt_number,
    r.receipt_date,
    po.po_number,
    po.po_date,
    c.company_name as vendor,
    d.drug_code,
    d.trade_name,
    dg.generic_name,
    ri.quantity_received,
    ri.unit_cost,
    ri.total_cost,
    ri.lot_number,
    ri.expiry_date,
    l.location_name as receive_location,
    r.status,
    r.verified_by,
    r.verified_date
FROM receipts r
JOIN purchase_orders po ON r.po_id = po.id
JOIN receipt_items ri ON r.id = ri.receipt_id
JOIN drugs d ON ri.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
LEFT JOIN companies c ON po.vendor_id = c.id
LEFT JOIN locations l ON r.location_id = l.id
WHERE r.status IN ('verified', 'posted')
ORDER BY r.receipt_date DESC, r.receipt_number;
```

---

## 💊 FILE 4: DISTRIBUTION - การจ่ายยา

### Purpose
รายงานการจ่ายยาให้หน่วยงาน เพื่อติดตามการใช้ยา

### View Definition

```sql
CREATE VIEW export_distribution AS
SELECT
    dd.distribution_number,
    dd.distribution_date,
    lf.location_name as from_location,
    lt.location_name as to_location,
    dept.dept_name as requesting_department,
    d.drug_code,
    d.trade_name,
    dg.generic_name,
    ddi.lot_number,
    ddi.quantity_dispensed,
    ddi.unit_cost,
    ddi.total_cost,
    ddi.expiry_date,
    dd.status,
    dd.dispensed_by,
    dd.dispensed_date
FROM drug_distributions dd
JOIN drug_distribution_items ddi ON dd.id = ddi.distribution_id
JOIN drugs d ON ddi.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN locations lf ON dd.from_location_id = lf.id
JOIN locations lt ON dd.to_location_id = lt.id
LEFT JOIN departments dept ON dd.requesting_dept_id = dept.id
WHERE dd.status = 'dispensed'
ORDER BY dd.distribution_date DESC, dd.distribution_number;
```

---

## 📈 FILE 5: INVENTORY - ยาคงคลัง

### Purpose
รายงานยาคงคลัง ณ สิ้นเดือน/ปี เพื่อติดตามมูลค่ายา

### View Definition

```sql
CREATE VIEW export_inventory AS
SELECT
    l.location_code,
    l.location_name,
    d.drug_code,
    d.trade_name,
    dg.working_code,
    dg.generic_name,
    inv.quantity_on_hand,
    inv.average_cost,
    (inv.quantity_on_hand * inv.average_cost) as total_value,
    inv.min_level,
    inv.max_level,
    inv.reorder_point,
    dl.lot_number,
    dl.quantity_available,
    dl.expiry_date,
    (dl.expiry_date - CURRENT_DATE)::INTEGER as days_until_expiry,
    inv.last_updated
FROM inventory inv
JOIN drugs d ON inv.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN locations l ON inv.location_id = l.id
LEFT JOIN drug_lots dl ON d.id = dl.drug_id
    AND dl.location_id = inv.location_id
    AND dl.is_active = true
    AND dl.quantity_available > 0
WHERE inv.quantity_on_hand > 0
ORDER BY l.location_code, d.drug_code, dl.expiry_date;
```

---

## 📊 Ministry Report Record

### Report Tracking Table

```sql
-- Track ministry report submissions
CREATE TABLE ministry_reports (
    id BIGSERIAL PRIMARY KEY,
    report_type VARCHAR(50) NOT NULL,  -- druglist, purchase_plan, etc.
    report_period VARCHAR(20) NOT NULL,  -- monthly, quarterly, annual
    report_date DATE NOT NULL,
    fiscal_year INTEGER NOT NULL,
    hospital_code VARCHAR(10),
    data_json JSONB,
    tmt_compliance_rate DECIMAL(5,2),
    total_items INTEGER,
    mapped_items INTEGER,
    verification_status VARCHAR(20),
    submitted_by BIGINT,
    submitted_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Generate Monthly Report

```sql
-- Generate and save monthly druglist report
INSERT INTO ministry_reports (
    report_type,
    report_period,
    report_date,
    fiscal_year,
    hospital_code,
    data_json,
    tmt_compliance_rate,
    total_items,
    mapped_items,
    verification_status,
    created_at
)
SELECT
    'druglist',
    'monthly',
    DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day',
    EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER + 543,  -- Thai year
    'H12345',  -- Hospital code
    jsonb_agg(row_to_json(t.*)),
    (COUNT(CASE WHEN tmt_code IS NOT NULL THEN 1 END)::DECIMAL / COUNT(*) * 100),
    COUNT(*),
    COUNT(CASE WHEN tmt_code IS NOT NULL THEN 1 END),
    'draft',
    CURRENT_TIMESTAMP
FROM export_druglist t;
```

---

## 🔄 Export Process Flow

```
1. Generate Report Data
   └─> Query respective view (export_*)

2. Validate Data
   ├─> Check required fields
   ├─> Verify TMT codes
   └─> Validate dates

3. Format Export
   ├─> CSV format (default)
   ├─> JSON format (optional)
   └─> Excel format (optional)

4. Save Report Record
   └─> Insert into ministry_reports

5. Submit to Ministry
   ├─> Upload to ministry portal
   └─> Update submission status
```

---

## 🎯 UI Mockup: Ministry Reports Dashboard

```
┌────────────────────────────────────────────────────────────────────┐
│  Ministry Reports                              [Generate Report ▼] │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  📊 Report Status (January 2025)                                   │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Report          │ Status    │ Items │ TMT % │ Last Update  │  │
│  ├─────────────────┼───────────┼───────┼───────┼──────────────┤  │
│  │ 1. Druglist     │ ✅ Ready  │ 1,200 │ 95%   │ 2025-01-31   │  │
│  │ 2. Purchase Plan│ ✅ Ready  │   145 │ 98%   │ 2025-01-31   │  │
│  │ 3. Receipt      │ ✅ Ready  │    89 │ 96%   │ 2025-01-31   │  │
│  │ 4. Distribution │ ✅ Ready  │   234 │ 97%   │ 2025-01-31   │  │
│  │ 5. Inventory    │ ✅ Ready  │   842 │ 95%   │ 2025-01-31   │  │
│  └─────────────────┴───────────┴───────┴───────┴──────────────┘  │
│                                                                     │
│  📅 Report Period                                                   │
│  Period: [January 2025 ▼]  Fiscal Year: [2568 ▼]                  │
│                                                                     │
│  📋 Previous Submissions                                            │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Date       │ Period      │ Report       │ Status  │ Download │  │
│  ├────────────┼─────────────┼──────────────┼─────────┼──────────┤  │
│  │ 2025-01-31 │ Jan 2025    │ All 5 files  │✅ Sent  │ [CSV][📄]│  │
│  │ 2024-12-31 │ Dec 2024    │ All 5 files  │✅ Sent  │ [CSV][📄]│  │
│  │ 2024-11-30 │ Nov 2024    │ All 5 files  │✅ Sent  │ [CSV][📄]│  │
│  └────────────┴─────────────┴──────────────┴─────────┴──────────┘  │
│                                                                     │
│  Actions                                                            │
│  [Generate All Reports] [Export CSV] [Export JSON] [Submit]        │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📊 Report Generation API

### Backend Endpoints (To Implement)

```typescript
// GET /api/ministry/reports/:type
// Generate specific report
export async function generateReport(
  type: 'druglist' | 'purchase_plan' | 'receipt' | 'distribution' | 'inventory',
  period: { year: number; month: number },
  format: 'json' | 'csv' | 'excel'
) {
  // 1. Query view data
  const data = await prisma.$queryRaw`
    SELECT * FROM export_${type}
    WHERE EXTRACT(YEAR FROM created_at) = ${period.year}
      AND EXTRACT(MONTH FROM created_at) = ${period.month}
  `
  
  // 2. Validate data
  const validation = validateReportData(data)
  
  // 3. Format export
  const exportData = formatReport(data, format)
  
  // 4. Save report record
  await saveReportRecord(type, period, data, validation)
  
  return exportData
}
```

---

## ✅ Compliance Checklist

### Monthly Requirements
- [ ] Generate all 5 reports before month-end
- [ ] Verify TMT mapping > 90%
- [ ] Validate all required fields
- [ ] Submit to ministry portal
- [ ] Archive reports

### Data Quality Checks
- [ ] No missing drug codes
- [ ] All active drugs have TMT codes
- [ ] Receipt dates match fiscal year
- [ ] Distribution quantities match inventory
- [ ] Stock values calculated correctly

---

## 📊 Key Metrics

```sql
-- Monthly report summary
SELECT
    report_type,
    report_period,
    total_items,
    mapped_items,
    ROUND((mapped_items::DECIMAL / total_items * 100), 2) as mapping_pct,
    verification_status,
    submitted_date
FROM ministry_reports
WHERE report_period LIKE '2025-%'
ORDER BY report_date DESC;
```

**Target Quality:**
```
✅ TMT Mapping: > 95%
✅ Data Completeness: 100%
✅ On-time Submission: Before month-end + 5 days
✅ Validation Errors: 0
```

---

## ✅ Implementation Checklist

### Database
- [x] 5 export views created
- [x] ministry_reports tracking table
- [x] Data validation queries
- [ ] Automated monthly generation

### Backend API (To Do)
- [ ] GET `/api/ministry/reports` - List all reports
- [ ] GET `/api/ministry/reports/:type` - Generate report
- [ ] POST `/api/ministry/reports/generate` - Batch generate
- [ ] GET `/api/ministry/reports/:id/export` - Export file
- [ ] POST `/api/ministry/reports/:id/submit` - Submit to ministry
- [ ] GET `/api/ministry/stats` - Compliance stats

### Frontend (To Do)
- [ ] Ministry reports dashboard
- [ ] Report generation interface
- [ ] Export options (CSV/JSON/Excel)
- [ ] Submission tracking
- [ ] Compliance indicators

---

## 📞 Related Documentation

- **[FLOW_06_TMT_Integration.md](./FLOW_06_TMT_Integration.md)** - TMT Mapping
- **[prisma/views.sql](../../prisma/views.sql)** - All 11 database views
- **Ministry Guidelines**: กระทรวงสาธารณสุข คู่มือรายงานข้อมูล

---

**Status**: ✅ Complete - 11 views created, ready for export
**Last Updated**: 2025-01-11

*Created with ❤️ for INVS Modern Team*
