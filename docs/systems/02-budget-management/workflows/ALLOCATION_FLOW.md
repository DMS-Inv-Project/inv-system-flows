# FLOW 02: Budget Management
## การบริหารจัดการงบประมาณแบบครบวงจร

---

## 📋 **ภาพรวม**

Budget Management Flow ครอบคลุมการจัดการงบประมาณตั้งแต่การวางแผน การจัดสรร การจอง การตัดงบ และการติดตาม

**5 ขั้นตอนหลัก:**
1. **Budget Planning** - วางแผนงบประมาณรายปี
2. **Budget Allocation** - จัดสรรงบแบ่งตามไตรมาส (Q1-Q4)
3. **Budget Check** - ตรวจสอบงบคงเหลือ
4. **Budget Reservation** - จองงบชั่วคราว (สำหรับ PR)
5. **Budget Commitment** - ตัดงบจริง (เมื่อ approve PO)

---

## 🔄 **Complete Flow Diagram**

```
┌───────────────────────────────────────────────────────────────┐
│              BUDGET MANAGEMENT LIFECYCLE                       │
└───────────────────────────────────────────────────────────────┘

Phase 1: ANNUAL PLANNING (ต้นปีงบประมาณ)
┌─────────────────────────────────────┐
│ Finance Manager                     │
│ └─> Plan Annual Budget             │
│     ├─> Total: 18M บาท            │
│     ├─> Q1: 4.5M (Jan-Mar)        │
│     ├─> Q2: 4.5M (Apr-Jun)        │
│     ├─> Q3: 4.5M (Jul-Sep)        │
│     └─> Q4: 4.5M (Oct-Dec)        │
└─────────────────────────────────────┘
         ↓
Phase 2: ALLOCATION (แบ่งตามหน่วยงาน)
┌─────────────────────────────────────┐
│ Allocate to Departments             │
│ ├─> Pharmacy Dept: 10M             │
│ │   └─> Budget Type: OP001 (ยา)   │
│ ├─> Nursing Dept: 5M               │
│ │   └─> Budget Type: OP001 (ยา)   │
│ └─> Medical Dept: 3M               │
│     └─> Budget Type: OP002 (เครื่อง)│
└─────────────────────────────────────┘
         ↓
Phase 3: USAGE (ใช้งานจริง)
┌─────────────────────────────────────┐
│ Department creates Purchase Request │
│ └─> Check Budget Available?        │
│     ├─[YES]─> Reserve Budget       │
│     │         (Lock temporarily)    │
│     │         └─> Create PR         │
│     │             └─> Approve PR    │
│     │                 └─> Create PO │
│     │                     └─> Commit│
│     │                         Budget│
│     └─[NO]──> Request More Budget  │
│                or Adjust PR         │
└─────────────────────────────────────┘
         ↓
Phase 4: MONITORING (ติดตามอย่างต่อเนื่อง)
┌─────────────────────────────────────┐
│ Real-time Budget Tracking           │
│ ├─> Total Spent                     │
│ ├─> Remaining Budget                │
│ ├─> Utilization % (per Quarter)    │
│ ├─> Reserved Amount                 │
│ └─> Alert if > 80%                  │
└─────────────────────────────────────┘
```

---

## 🖥️ **UI MOCKUP: Budget Allocation Screen**

```
╔════════════════════════════════════════════════════════════════╗
║  INVS Modern - Budget Allocation (FY 2025)               [X]  ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║  💰 Create New Budget Allocation                               ║
║                                                                ║
║  Fiscal Year:  [2025    ] (Jan 1 - Dec 31, 2025)             ║
║  Department:   [▼ Pharmacy Department (PHARM)           ]     ║
║  Budget Type:  [▼ OP001 - งบดำเนินงาน (ยา)              ]     ║
║                                                                ║
║  ┌──────────────────────────────────────────────────────────┐ ║
║  │  QUARTERLY BREAKDOWN                                     │ ║
║  ├──────────────────────────────────────────────────────────┤ ║
║  │  Total Budget:    [10,000,000.00] บาท                   │ ║
║  │                                                          │ ║
║  │  Q1 (Jan-Mar):    [2,500,000.00] บาท (25%)             │ ║
║  │  Q2 (Apr-Jun):    [2,500,000.00] บาท (25%)             │ ║
║  │  Q3 (Jul-Sep):    [2,500,000.00] บาท (25%)             │ ║
║  │  Q4 (Oct-Dec):    [2,500,000.00] บาท (25%)             │ ║
║  │                   ─────────────────────────              │ ║
║  │  Total:           10,000,000.00 บาท ✓                   │ ║
║  └──────────────────────────────────────────────────────────┘ ║
║                                                                ║
║  Status: [▼ ACTIVE  ]                                         ║
║          [ ] INACTIVE                                          ║
║          [✓] ACTIVE                                            ║
║          [ ] LOCKED                                            ║
║                                                                ║
║  [ Cancel ]                    [ Create Allocation ]           ║
║                                                                ║
╠════════════════════════════════════════════════════════════════╣
║  📊 Budget Summary - FY 2025                                   ║
║  ┌────────────────────────────────────────────────────────┐   ║
║  │Dept  │ Budget │ Total  │ Spent      │ Remaining  │ %  │   ║
║  ├──────┼────────┼────────┼────────────┼────────────┼────┤   ║
║  │PHARM │ OP001  │ 10.0M  │ 0.00       │ 10.0M      │ 0% │   ║
║  │NURSE │ OP001  │ 5.0M   │ 0.00       │ 5.0M       │ 0% │   ║
║  │MED   │ OP002  │ 3.0M   │ 0.00       │ 3.0M       │ 0% │   ║
║  │      │        │        │            │            │    │   ║
║  │TOTAL │        │ 18.0M  │ 0.00       │ 18.0M      │ 0% │   ║
║  └──────┴────────┴────────┴────────────┴────────────┴────┘   ║
╚════════════════════════════════════════════════════════════════╝
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 1 - Create Budget Allocation**

### Input Data

```json
{
  "fiscalYear": 2025,
  "departmentId": 2,
  "budgetTypeId": 1,
  "totalBudget": 10000000.00,
  "q1Budget": 2500000.00,
  "q2Budget": 2500000.00,
  "q3Budget": 2500000.00,
  "q4Budget": 2500000.00,
  "status": "ACTIVE"
}
```

### Database Operation

```sql
-- INSERT Budget Allocation
INSERT INTO budget_allocations (
  fiscal_year,
  budget_type_id,
  department_id,
  total_budget,
  q1_budget,
  q2_budget,
  q3_budget,
  q4_budget,
  total_spent,
  q1_spent,
  q2_spent,
  q3_spent,
  q4_spent,
  remaining_budget,
  status,
  created_at
) VALUES (
  2025,
  1, -- OP001
  2, -- Pharmacy Dept
  10000000.00,
  2500000.00,
  2500000.00,
  2500000.00,
  2500000.00,
  0.00,
  0.00,
  0.00,
  0.00,
  0.00,
  10000000.00,
  'active',
  CURRENT_TIMESTAMP
);

-- Verify with View
SELECT * FROM budget_status_current
WHERE fiscal_year = 2025
  AND dept_code = 'PHARM';
```

### Expected Result

```
allocation_id | fiscal_year | budget_code | dept_code | total_budget | total_spent | remaining | utilization_%
--------------+-------------+-------------+-----------+--------------+-------------+-----------+--------------
      1       |    2025     |   OP001     |   PHARM   | 10,000,000   |    0.00     | 10,000,000|    0.00%
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 2 - Check Budget Availability**

### Scenario: ตรวจสอบงบก่อนสร้าง PR

```sql
-- Call Function: check_budget_availability
SELECT * FROM check_budget_availability(
  p_fiscal_year := 2025,
  p_budget_type_id := 1,
  p_department_id := 2,
  p_amount := 500000.00,
  p_quarter := 1
);
```

### Output

```
available | allocation_id | total_budget | total_spent | remaining_budget | quarter_budget | quarter_spent | quarter_remaining | message
----------+---------------+--------------+-------------+------------------+----------------+---------------+-------------------+---------------------------
   true   |       1       | 10,000,000   |    0.00     |   10,000,000     |   2,500,000    |     0.00      |    2,500,000      | Budget available for Q1
```

---

## 🖥️ **UI MOCKUP: Budget Check Dialog**

```
╔════════════════════════════════════════════════════════════╗
║  Budget Availability Check                             [X] ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  Department:    Pharmacy Department                        ║
║  Budget Type:   OP001 - งบดำเนินงาน (ยา)                  ║
║  Request Amount: 500,000.00 บาท                           ║
║  Quarter:       Q1 (January - March 2025)                  ║
║                                                            ║
║  ┌────────────────────────────────────────────────────┐   ║
║  │  BUDGET SUMMARY                                    │   ║
║  ├────────────────────────────────────────────────────┤   ║
║  │  Q1 Total Budget:         2,500,000.00 บาท        │   ║
║  │  Q1 Already Spent:                0.00 บาท        │   ║
║  │  Q1 Reserved:                     0.00 บาท        │   ║
║  │  Q1 Available:            2,500,000.00 บาท  ✓     │   ║
║  │                           ─────────────────        │   ║
║  │  Request Amount:            500,000.00 บาท        │   ║
║  │  After Reserve:           2,000,000.00 บาท        │   ║
║  │                                                    │   ║
║  │  Status:  ✅ BUDGET AVAILABLE                      │   ║
║  │  Utilization: 20% (After reserve)                  │   ║
║  └────────────────────────────────────────────────────┘   ║
║                                                            ║
║             [ Cancel ]        [ Proceed with PR ]          ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 3 - Reserve Budget**

### Scenario: จองงบเมื่อสร้าง Purchase Request

```sql
-- Call Function: reserve_budget
SELECT reserve_budget(
  p_allocation_id := 1,
  p_pr_id := 1,
  p_amount := 500000.00,
  p_expires_days := 30
) as reservation_id;
```

### Output

```
reservation_id
--------------
      1
```

### Verify Reservation

```sql
SELECT
  br.id,
  br.reserved_amount,
  br.reservation_date,
  br.expires_date,
  br.status,
  pr.pr_number
FROM budget_reservations br
JOIN purchase_requests pr ON br.pr_id = pr.id
WHERE br.id = 1;
```

### Result

```
id | reserved_amount | reservation_date | expires_date | status | pr_number
---+-----------------+------------------+--------------+--------+-----------
 1 |    500,000.00   |   2025-01-15     |  2025-02-14  | active | PR-2025-001
```

---

## 🖥️ **UI MOCKUP: Budget Reservation Dashboard**

```
╔════════════════════════════════════════════════════════════════╗
║  INVS Modern - Budget Reservations                        [X] ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║  📊 Active Budget Reservations (2025)                          ║
║                                                                ║
║  Filters: [All Depts ▼] [All Budgets ▼] [Q1 ▼] [🔍 Search]   ║
║                                                                ║
║  ┌──────────────────────────────────────────────────────────┐ ║
║  │PR#       │Dept │Budget│Amount     │Reserved │Expires  │◄─┼─║
║  ├──────────┼─────┼──────┼───────────┼─────────┼─────────┼──┤ ║
║  │PR-2025-001│PHARM│OP001 │  500,000  │01/15/25│02/14/25 │⏰│ ║
║  │PR-2025-002│NURSE│OP001 │  300,000  │01/16/25│02/15/25 │⏰│ ║
║  │PR-2025-003│MED  │OP002 │  800,000  │01/10/25│02/09/25 │⚠│ ║
║  │PR-2025-004│PHARM│OP001 │  200,000  │01/18/25│02/17/25 │⏰│ ║
║  └──────────┴─────┴──────┴───────────┴─────────┴─────────┴──┘ ║
║                                                                ║
║  Legend: ⏰ = Active  ⚠ = Expiring Soon  ❌ = Expired         ║
║                                                                ║
║  Total Reserved: 1,800,000.00 บาท                             ║
║                                                                ║
║  Actions: [Release Selected] [Convert to PO] [Export Report]  ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 4 - Commit Budget**

### Scenario: ตัดงบจริงเมื่อ approve Purchase Order

```sql
-- Call Function: commit_budget
SELECT commit_budget(
  p_allocation_id := 1,
  p_po_id := 1,
  p_amount := 500000.00,
  p_quarter := 1
);
```

### Output

```
commit_budget
-------------
    true
```

### Verify Budget Update

```sql
-- Check Budget Allocation
SELECT
  fiscal_year,
  total_budget,
  total_spent,
  remaining_budget,
  q1_budget,
  q1_spent,
  (q1_spent / q1_budget * 100) as q1_utilization_pct
FROM budget_allocations
WHERE id = 1;
```

### Result

```
fiscal_year | total_budget | total_spent | remaining_budget | q1_budget | q1_spent | q1_utilization_pct
------------+--------------+-------------+------------------+-----------+----------+-------------------
   2025     | 10,000,000   |  500,000    |   9,500,000      | 2,500,000 | 500,000  |      20.00%
```

### Check Reservation Status

```sql
SELECT
  id,
  reserved_amount,
  status,
  po_id
FROM budget_reservations
WHERE pr_id = 1;
```

### Result

```
id | reserved_amount | status    | po_id
---+-----------------+-----------+------
 1 |    500,000.00   | committed |   1
```

---

## 🖥️ **UI MOCKUP: Budget Dashboard (After Commit)**

```
╔════════════════════════════════════════════════════════════════╗
║  INVS Modern - Budget Dashboard (FY 2025)                 [X] ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║  💰 Budget Utilization - Q1 2025                               ║
║                                                                ║
║  Department: Pharmacy (PHARM) | Budget: OP001 - ยา             ║
║                                                                ║
║  ┌──────────────────────────────────────────────────────────┐ ║
║  │  QUARTER 1 (January - March 2025)                        │ ║
║  ├──────────────────────────────────────────────────────────┤ ║
║  │  Allocated:       2,500,000.00 บาท                       │ ║
║  │  Spent:             500,000.00 บาท  ████░░░░░░  20%     │ ║
║  │  Reserved:          300,000.00 บาท  ███░░░░░░░  12%     │ ║
║  │  Available:       1,700,000.00 บาท  █████████░  68%     │ ║
║  └──────────────────────────────────────────────────────────┘ ║
║                                                                ║
║  ┌──────────────────────────────────────────────────────────┐ ║
║  │  ANNUAL SUMMARY                                          │ ║
║  ├──────────────────────────────────────────────────────────┤ ║
║  │  Total Budget:   10,000,000.00 บาท                       │ ║
║  │  Total Spent:       500,000.00 บาท  █░░░░░░░░░   5%     │ ║
║  │  Total Reserved:    300,000.00 บาท  ░░░░░░░░░░   3%     │ ║
║  │  Remaining:       9,200,000.00 บาท  █████████░  92%     │ ║
║  └──────────────────────────────────────────────────────────┘ ║
║                                                                ║
║  ⚠️ Alerts:                                                    ║
║  • PR-2025-003 reservation expires in 5 days                   ║
║  • Q1 budget 20% utilized (on track)                           ║
║                                                                ║
║  [View Details] [Generate Report] [Budget Transfer]            ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 5 - Release Budget**

### Scenario: ปลดล็อคงบเมื่อยกเลิก PR

```sql
-- Call Function: release_budget
SELECT release_budget(p_reservation_id := 2);
```

### Output

```
release_budget
--------------
     true
```

### Verify

```sql
SELECT
  id,
  reserved_amount,
  status,
  pr_id
FROM budget_reservations
WHERE id = 2;
```

### Result

```
id | reserved_amount | status   | pr_id
---+-----------------+----------+------
 2 |    300,000.00   | released |   2
```

---

## ✅ **Validation Rules**

### 1. Budget Allocation Validation

```sql
-- Check if allocation already exists for the year
SELECT COUNT(*) FROM budget_allocations
WHERE fiscal_year = 2025
  AND budget_type_id = 1
  AND department_id = 2;
-- Must be 0 for new allocation

-- Validate quarterly sum equals total
SELECT
  (q1_budget + q2_budget + q3_budget + q4_budget) = total_budget as valid
FROM budget_allocations WHERE id = :allocation_id;
-- Must return true
```

### 2. Budget Availability Check

```sql
-- Check remaining budget
SELECT remaining_budget >= :requested_amount as sufficient
FROM budget_allocations
WHERE id = :allocation_id AND status = 'active';
-- Must return true

-- Check quarterly budget
SELECT
  CASE
    WHEN :quarter = 1 THEN (q1_budget - q1_spent) >= :amount
    WHEN :quarter = 2 THEN (q2_budget - q2_spent) >= :amount
    WHEN :quarter = 3 THEN (q3_budget - q3_spent) >= :amount
    WHEN :quarter = 4 THEN (q4_budget - q4_spent) >= :amount
  END as sufficient
FROM budget_allocations WHERE id = :allocation_id;
-- Must return true
```

### 3. Reservation Validation

```sql
-- Check if budget available
SELECT remaining_budget >= :amount FROM budget_allocations WHERE id = :id;

-- Check if reservation expired
SELECT CURRENT_DATE <= expires_date FROM budget_reservations WHERE id = :id;

-- Check if already committed
SELECT status = 'active' FROM budget_reservations WHERE id = :id;
```

---

## 🚨 **Error Handling**

### Common Errors

| Error Code | Message | Solution |
|------------|---------|----------|
| `BUD001` | Budget allocation already exists | Use different dept/type/year |
| `BUD002` | Insufficient budget | Reduce amount or request more budget |
| `BUD003` | Quarterly sum doesn't match total | Adjust quarterly amounts |
| `BUD004` | Reservation expired | Create new PR or extend expiry |
| `BUD005` | Budget allocation not active | Activate budget first |
| `BUD006` | Quarter budget exceeded | Wait for next quarter or adjust |

### Example Error Response

```json
{
  "success": false,
  "errorCode": "BUD002",
  "message": "Insufficient budget in Q1",
  "details": {
    "requested": 500000.00,
    "available": 300000.00,
    "quarter": 1
  },
  "suggestion": "Reduce PR amount to 300,000 บาท or below"
}
```

---

## 📈 **Budget Monitoring Queries**

### Query 1: Budget Utilization by Department

```sql
SELECT
  dept.dept_name,
  bt.budget_name,
  ba.fiscal_year,
  ba.total_budget,
  ba.total_spent,
  ba.remaining_budget,
  ROUND((ba.total_spent / ba.total_budget * 100), 2) as utilization_pct,
  CASE
    WHEN ba.total_spent > ba.total_budget THEN 'OVER_BUDGET'
    WHEN (ba.total_spent / ba.total_budget) > 0.8 THEN 'HIGH'
    WHEN (ba.total_spent / ba.total_budget) > 0.5 THEN 'MEDIUM'
    ELSE 'LOW'
  END as alert_level
FROM budget_allocations ba
JOIN departments dept ON ba.department_id = dept.id
JOIN budget_types bt ON ba.budget_type_id = bt.id
WHERE ba.fiscal_year = 2025
  AND ba.status = 'active'
ORDER BY utilization_pct DESC;
```

### Query 2: Quarterly Budget Tracking

```sql
SELECT
  dept_name,
  budget_name,
  'Q1' as quarter,
  q1_budget as allocated,
  q1_spent as spent,
  (q1_budget - q1_spent) as remaining,
  ROUND((q1_spent / q1_budget * 100), 2) as utilization_pct
FROM budget_status_current
WHERE fiscal_year = 2025
UNION ALL
SELECT
  dept_name, budget_name, 'Q2', q2_budget, q2_spent,
  (q2_budget - q2_spent), ROUND((q2_spent / q2_budget * 100), 2)
FROM budget_status_current WHERE fiscal_year = 2025
-- ... Q3, Q4
ORDER BY dept_name, quarter;
```

### Query 3: Budget Reservations Summary

```sql
SELECT
  dept.dept_name,
  COUNT(*) as total_reservations,
  SUM(br.reserved_amount) as total_reserved,
  COUNT(CASE WHEN br.status = 'active' THEN 1 END) as active_count,
  COUNT(CASE WHEN br.expires_date < CURRENT_DATE THEN 1 END) as expired_count
FROM budget_reservations br
JOIN budget_allocations ba ON br.allocation_id = ba.id
JOIN departments dept ON ba.department_id = dept.id
WHERE ba.fiscal_year = 2025
GROUP BY dept.dept_name
ORDER BY total_reserved DESC;
```

---

## 🎯 **Success Criteria**

### ✅ Budget Management Checklist

- [ ] Budget allocations created for all departments
- [ ] Quarterly breakdown sums equal total budget
- [ ] Budget check function works correctly
- [ ] Budget reservation creates lock on amount
- [ ] Budget commitment deducts from allocation
- [ ] Budget release unlocks reserved amount
- [ ] Dashboard shows real-time utilization
- [ ] Alerts trigger at 80% utilization
- [ ] Expired reservations flagged
- [ ] Budget transfer workflow functional

### Key Performance Indicators

```
Metric                    | Target  | Current
--------------------------+---------+---------
Budget Accuracy           | 100%    | 100%
Reservation Expiry Rate   | < 5%    | 0%
Over-budget Incidents     | 0       | 0
Budget Utilization (Q1)   | 20-30%  | 20%
System Response Time      | < 2 sec | 0.5 sec
```

---

## 🎯 **Next Steps**

หลังจาก Budget Management พร้อม:

1. ✅ **Create Purchase Requests** - สร้าง PR พร้อมจองงบ (FLOW 03)
2. ✅ **Monitor Budget Usage** - ติดตามการใช้งบ real-time
3. ✅ **Handle Budget Transfers** - จัดการโอนงบระหว่างหน่วยงาน
4. ✅ **Generate Budget Reports** - สร้างรายงานงบประมาณ

---

**📝 Note**: Budget Management เป็นหัวใจสำคัญของระบบ INVS ต้องมีการควบคุมและติดตามอย่างเคร่งครัดเพื่อป้องกันการเกินงบ
