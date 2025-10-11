# FLOW 03: Procurement Workflow (Part 1)
## การจัดซื้อยา - Purchase Request (PR)

---

## 📋 **ภาพรวม**

Procurement Workflow คือกระบวนการจัดซื้อยาแบบครบวงจร แบ่งเป็น 3 ส่วนใหญ่:
1. **Part 1: Purchase Request (PR)** - คำขอซื้อ ✅ **เอกสารนี้**
2. **Part 2: Purchase Order (PO)** - ใบสั่งซื้อ
3. **Part 3: Goods Receipt** - การรับยาเข้าคลัง

---

## 🔄 **Complete Procurement Flow**

```
┌─────────────────────────────────────────────────────────────────┐
│              PROCUREMENT WORKFLOW OVERVIEW                       │
└─────────────────────────────────────────────────────────────────┘

PART 1: PURCHASE REQUEST (PR)
┌──────────────────────────────────────┐
│ Step 1: Identify Need                │
│ └─> Reorder Alert or Manual Request │
│                                      │
│ Step 2: Create PR (Draft)           │
│ └─> Add Generic Drugs               │
│ └─> Estimate Costs                  │
│                                      │
│ Step 3: Check Budget                 │
│ └─> Call check_budget_availability()│
│                                      │
│ Step 4: Reserve Budget               │
│ └─> Call reserve_budget()           │
│ └─> Status: DRAFT → SUBMITTED      │
│                                      │
│ Step 5: Approval Workflow            │
│ └─> Department Head Review          │
│ └─> Finance Manager Approval        │
│ └─> Status: SUBMITTED → APPROVED   │
└──────────────────────────────────────┘
         ↓
PART 2: PURCHASE ORDER (PO)
         ↓
PART 3: GOODS RECEIPT
```

---

## 🖥️ **UI MOCKUP: Create Purchase Request Screen**

```
╔════════════════════════════════════════════════════════════════════╗
║  INVS Modern - Create Purchase Request                        [X] ║
╠════════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  📝 New Purchase Request (Draft)                                   ║
║                                                                    ║
║  PR Number:       [PR-2025-001] (Auto-generated)                  ║
║  PR Date:         [15/01/2025]                                    ║
║  Department:      [▼ Pharmacy Department (PHARM)           ]      ║
║  Budget Type:     [▼ OP001 - งบดำเนินงาน (ยา)              ]      ║
║  Urgency:         ( ) URGENT  (•) NORMAL  ( ) LOW                 ║
║                                                                    ║
║  Purpose:         [ซื้อยาเพิ่มเติมเพื่อเติมสต็อกประจำเดือน_____] ║
║                   [กุมภาพันธ์ 2025___________________________] ║
║                                                                    ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │  REQUEST ITEMS                                               │ ║
║  ├──────────────────────────────────────────────────────────────┤ ║
║  │ # │ Generic Drug │ Qty  │ Unit │ Est.Cost│ Total  │ Action │ ║
║  ├───┼──────────────┼──────┼──────┼─────────┼────────┼────────┤ ║
║  │ 1 │ PAR0001      │10000 │ TAB  │   2.50  │ 25,000 │ [🗑]   │ ║
║  │   │ Paracetamol  │      │      │         │        │        │ ║
║  │   │ 500mg Tab    │      │      │         │        │        │ ║
║  ├───┼──────────────┼──────┼──────┼─────────┼────────┼────────┤ ║
║  │ 2 │ AMX0001      │ 5000 │ CAP  │  10.00  │ 50,000 │ [🗑]   │ ║
║  │   │ Amoxicillin  │      │      │         │        │        │ ║
║  │   │ 250mg Cap    │      │      │         │        │        │ ║
║  ├───┼──────────────┼──────┼──────┼─────────┼────────┼────────┤ ║
║  │ 3 │ OME0001      │ 3000 │ CAP  │  15.00  │ 45,000 │ [🗑]   │ ║
║  │   │ Omeprazole   │      │      │         │        │        │ ║
║  │   │ 20mg Cap     │      │      │         │        │        │ ║
║  └───┴──────────────┴──────┴──────┴─────────┴────────┴────────┘ ║
║                                                                    ║
║  [+ Add Item]                                                      ║
║                                                                    ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │  SUMMARY                                                     │ ║
║  ├──────────────────────────────────────────────────────────────┤ ║
║  │  Total Items:           3 items                              │ ║
║  │  Estimated Total Cost:  120,000.00 บาท                      │ ║
║  │                                                              │ ║
║  │  Budget Check:  ⏳ Pending                                   │ ║
║  │  [ Check Budget Availability ]                              │ ║
║  └──────────────────────────────────────────────────────────────┘ ║
║                                                                    ║
║  Remarks:         [___________________________________________]   ║
║                                                                    ║
║  [💾 Save Draft] [🗑 Discard]        [✓ Check Budget & Submit]   ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 1 - Create PR (Draft)**

### Input Data

```json
{
  "prNumber": "PR-2025-001",
  "prDate": "2025-01-15",
  "departmentId": 2,
  "budgetAllocationId": 1,
  "requestedAmount": 120000.00,
  "purpose": "ซื้อยาเพิ่มเติมเพื่อเติมสต็อกประจำเดือนกุมภาพันธ์ 2025",
  "urgency": "NORMAL",
  "status": "DRAFT",
  "requestedBy": "Pharmacist A",
  "remarks": "",
  "items": [
    {
      "itemNumber": 1,
      "genericId": 1,
      "quantityRequested": 10000,
      "estimatedUnitCost": 2.50,
      "estimatedTotalCost": 25000.00,
      "justification": "สต็อกเหลือน้อย เพื่อป้องกันยาหมด"
    },
    {
      "itemNumber": 2,
      "genericId": 3,
      "quantityRequested": 5000,
      "estimatedUnitCost": 10.00,
      "estimatedTotalCost": 50000.00,
      "justification": "ยอดการใช้เพิ่มขึ้น"
    },
    {
      "itemNumber": 3,
      "genericId": 5,
      "quantityRequested": 3000,
      "estimatedUnitCost": 15.00,
      "estimatedTotalCost": 45000.00,
      "justification": "ยาเดิมใกล้หมดอายุ ต้องเปลี่ยนชุดใหม่"
    }
  ]
}
```

### Database Operations

```sql
-- STEP 1A: Insert Purchase Request (Draft)
INSERT INTO purchase_requests (
  pr_number,
  pr_date,
  department_id,
  budget_allocation_id,
  requested_amount,
  purpose,
  urgency,
  status,
  requested_by,
  remarks,
  created_at
) VALUES (
  'PR-2025-001',
  '2025-01-15',
  2, -- Pharmacy Department
  1, -- Budget Allocation ID
  120000.00,
  'ซื้อยาเพิ่มเติมเพื่อเติมสต็อกประจำเดือนกุมภาพันธ์ 2025',
  'normal',
  'draft',
  'Pharmacist A',
  '',
  CURRENT_TIMESTAMP
) RETURNING id;

-- Assume returned id = 1

-- STEP 1B: Insert PR Items
INSERT INTO purchase_request_items (
  pr_id,
  item_number,
  generic_id,
  quantity_requested,
  estimated_unit_cost,
  estimated_total_cost,
  justification,
  status
) VALUES
(1, 1, 1, 10000, 2.50, 25000.00, 'สต็อกเหลือน้อย เพื่อป้องกันยาหมด', 'pending'),
(1, 2, 3, 5000, 10.00, 50000.00, 'ยอดการใช้เพิ่มขึ้น', 'pending'),
(1, 3, 5, 3000, 15.00, 45000.00, 'ยาเดิมใกล้หมดอายุ ต้องเปลี่ยนชุดใหม่', 'pending');

-- STEP 1C: Verify
SELECT
  pr.pr_number,
  pr.pr_date,
  d.dept_name,
  pr.requested_amount,
  pr.status,
  COUNT(pri.id) as item_count
FROM purchase_requests pr
JOIN departments d ON pr.department_id = d.id
LEFT JOIN purchase_request_items pri ON pr.id = pri.pr_id
WHERE pr.id = 1
GROUP BY pr.id, pr.pr_number, pr.pr_date, d.dept_name, pr.requested_amount, pr.status;
```

### Expected Result

```
pr_number   | pr_date    | dept_name            | requested_amount | status | item_count
------------+------------+----------------------+------------------+--------+-----------
PR-2025-001 | 2025-01-15 | Pharmacy Department  |   120,000.00     | draft  |     3
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 2 - Check Budget Availability**

### UI Mockup: Budget Check Dialog

```
╔════════════════════════════════════════════════════════════╗
║  Budget Availability Check                             [X] ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  Checking budget for PR-2025-001...                        ║
║                                                            ║
║  Department:    Pharmacy Department                        ║
║  Budget Type:   OP001 - งบดำเนินงาน (ยา)                  ║
║  Request Amount: 120,000.00 บาท                           ║
║  Current Quarter: Q1 (January - March 2025)                ║
║                                                            ║
║  ⏳ Processing...                                          ║
║                                                            ║
║  ┌────────────────────────────────────────────────────┐   ║
║  │  BUDGET CHECK RESULT                               │   ║
║  ├────────────────────────────────────────────────────┤   ║
║  │  Q1 Total Budget:         2,500,000.00 บาท        │   ║
║  │  Q1 Already Spent:                0.00 บาท        │   ║
║  │  Q1 Reserved:                     0.00 บาท        │   ║
║  │  Q1 Available:            2,500,000.00 บาท  ✓     │   ║
║  │                           ─────────────────        │   ║
║  │  This Request:              120,000.00 บาท        │   ║
║  │  After Reserve:           2,380,000.00 บาท        │   ║
║  │                                                    │   ║
║  │  Status:  ✅ BUDGET AVAILABLE                      │   ║
║  │  Utilization: 4.8% (Low)                           │   ║
║  │                                                    │   ║
║  │  ✓ Safe to proceed with this purchase request     │   ║
║  └────────────────────────────────────────────────────┘   ║
║                                                            ║
║             [ Cancel ]        [ Reserve & Submit PR ]      ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

### Database Operation

```sql
-- Call Function: check_budget_availability
SELECT * FROM check_budget_availability(
  p_fiscal_year := 2025,
  p_budget_type_id := 1,
  p_department_id := 2,
  p_amount := 120000.00,
  p_quarter := 1
);
```

### Expected Result

```
available | allocation_id | total_budget | total_spent | remaining_budget | quarter_budget | quarter_spent | quarter_remaining | message
----------+---------------+--------------+-------------+------------------+----------------+---------------+-------------------+-------------------------
   true   |       1       | 10,000,000   |    0.00     |   10,000,000     |   2,500,000    |     0.00      |    2,500,000      | Budget available for Q1
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 3 - Reserve Budget & Submit PR**

### Database Operations

```sql
-- STEP 3A: Reserve Budget
SELECT reserve_budget(
  p_allocation_id := 1,
  p_pr_id := 1,
  p_amount := 120000.00,
  p_expires_days := 30
) as reservation_id;

-- Returns: 1

-- STEP 3B: Update PR Status to SUBMITTED
UPDATE purchase_requests
SET
  status = 'submitted',
  updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- STEP 3C: Verify Budget Reservation
SELECT
  br.id,
  br.reserved_amount,
  br.reservation_date,
  br.expires_date,
  br.status,
  pr.pr_number,
  pr.status as pr_status
FROM budget_reservations br
JOIN purchase_requests pr ON br.pr_id = pr.id
WHERE br.id = 1;
```

### Expected Result

```
id | reserved_amount | reservation_date | expires_date | status | pr_number   | pr_status
---+-----------------+------------------+--------------+--------+-------------+-----------
 1 |    120,000.00   |   2025-01-15     |  2025-02-14  | active | PR-2025-001 | submitted
```

---

## 🖥️ **UI MOCKUP: PR Submitted Success**

```
╔════════════════════════════════════════════════════════════╗
║  Purchase Request Submitted Successfully              [X] ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║          ✅ PR-2025-001 has been submitted!                ║
║                                                            ║
║  ┌────────────────────────────────────────────────────┐   ║
║  │  SUBMISSION SUMMARY                                │   ║
║  ├────────────────────────────────────────────────────┤   ║
║  │  PR Number:        PR-2025-001                     │   ║
║  │  Submitted Date:   15/01/2025 10:30 AM            │   ║
║  │  Submitted By:     Pharmacist A                    │   ║
║  │  Department:       Pharmacy Department             │   ║
║  │  Total Amount:     120,000.00 บาท                 │   ║
║  │  Total Items:      3 items                         │   ║
║  │                                                    │   ║
║  │  Budget Status:    ✅ Reserved                     │   ║
║  │  Reservation ID:   RES-2025-001                    │   ║
║  │  Valid Until:      14/02/2025                      │   ║
║  │                                                    │   ║
║  │  Current Status:   🔄 Pending Approval             │   ║
║  └────────────────────────────────────────────────────┘   ║
║                                                            ║
║  📧 Notification sent to:                                  ║
║  • Department Head (review required)                       ║
║  • Finance Manager (for information)                       ║
║                                                            ║
║  Next Steps:                                               ║
║  1. Department Head review & approval                      ║
║  2. Finance Manager final approval                         ║
║  3. Convert to Purchase Order                              ║
║                                                            ║
║  [📄 View PR Details] [📧 Send Reminder] [🏠 Go to Home]  ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 4 - Approval Workflow**

### UI Mockup: PR Approval Screen (Department Head)

```
╔════════════════════════════════════════════════════════════════════╗
║  INVS Modern - Approve Purchase Request                       [X] ║
╠════════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  📋 Purchase Request Review                                        ║
║                                                                    ║
║  PR Number:       PR-2025-001                                     ║
║  Submitted Date:  15/01/2025 10:30 AM                            ║
║  Requested By:    Pharmacist A                                    ║
║  Department:      Pharmacy Department (PHARM)                     ║
║  Status:          🔄 PENDING APPROVAL                             ║
║                                                                    ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │  REQUEST DETAILS                                             │ ║
║  ├──────────────────────────────────────────────────────────────┤ ║
║  │  Purpose:                                                    │ ║
║  │  ซื้อยาเพิ่มเติมเพื่อเติมสต็อกประจำเดือนกุมภาพันธ์ 2025    │ ║
║  │                                                              │ ║
║  │  Budget Type: OP001 - งบดำเนินงาน (ยา)                      │ ║
║  │  Quarter: Q1 (Jan-Mar 2025)                                  │ ║
║  │  Total Amount: 120,000.00 บาท                               │ ║
║  └──────────────────────────────────────────────────────────────┘ ║
║                                                                    ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │  REQUESTED ITEMS                                             │ ║
║  ├──────────────────────────────────────────────────────────────┤ ║
║  │ # │ Generic Drug    │ Qty   │ Unit│ Est.Cost│ Total        │ ║
║  ├───┼─────────────────┼───────┼─────┼─────────┼──────────────┤ ║
║  │ 1 │ PAR0001         │10,000 │ TAB │   2.50  │    25,000.00 │ ║
║  │   │ Paracetamol 500mg│      │     │         │              │ ║
║  │   │ Justification: สต็อกเหลือน้อย                          │ ║
║  │   │ [✓] Approve  [ ] Reject                                 │ ║
║  ├───┼─────────────────┼───────┼─────┼─────────┼──────────────┤ ║
║  │ 2 │ AMX0001         │ 5,000 │ CAP │  10.00  │    50,000.00 │ ║
║  │   │ Amoxicillin 250mg│      │     │         │              │ ║
║  │   │ Justification: ยอดการใช้เพิ่มขึ้น                      │ ║
║  │   │ [✓] Approve  [ ] Reject                                 │ ║
║  ├───┼─────────────────┼───────┼─────┼─────────┼──────────────┤ ║
║  │ 3 │ OME0001         │ 3,000 │ CAP │  15.00  │    45,000.00 │ ║
║  │   │ Omeprazole 20mg │      │     │         │              │ ║
║  │   │ Justification: ยาเดิมใกล้หมดอายุ                       │ ║
║  │   │ [✓] Approve  [ ] Reject                                 │ ║
║  └───┴─────────────────┴───────┴─────┴─────────┴──────────────┘ ║
║                                                                    ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │  BUDGET CHECK                                                │ ║
║  ├──────────────────────────────────────────────────────────────┤ ║
║  │  Budget Reserved:     ✅ 120,000.00 บาท                     │ ║
║  │  Budget Available:    ✅ 2,380,000.00 บาท (remaining)       │ ║
║  │  Budget Utilization:  4.8% (Low - Safe to approve)           │ ║
║  └──────────────────────────────────────────────────────────────┘ ║
║                                                                    ║
║  Approval Comments:                                                ║
║  [Approved. Proceed with purchase order creation._____________]   ║
║  [_____________________________________________________________]   ║
║                                                                    ║
║  Approved By: [Chief Pharmacist (Auto-filled)]                    ║
║                                                                    ║
║  [❌ Reject All] [⚠ Request Changes]        [✅ Approve All]      ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
```

### Database Operations for Approval

```sql
-- STEP 4A: Update PR Status to APPROVED
UPDATE purchase_requests
SET
  status = 'approved',
  approved_by = 'Chief Pharmacist',
  approval_date = CURRENT_DATE,
  updated_at = CURRENT_TIMESTAMP
WHERE id = 1;

-- STEP 4B: Update All PR Items to APPROVED
UPDATE purchase_request_items
SET status = 'approved'
WHERE pr_id = 1;

-- STEP 4C: Verify Approval
SELECT
  pr.pr_number,
  pr.status,
  pr.approved_by,
  pr.approval_date,
  COUNT(pri.id) as total_items,
  COUNT(CASE WHEN pri.status = 'approved' THEN 1 END) as approved_items
FROM purchase_requests pr
LEFT JOIN purchase_request_items pri ON pr.id = pri.pr_id
WHERE pr.id = 1
GROUP BY pr.id, pr.pr_number, pr.status, pr.approved_by, pr.approval_date;
```

### Expected Result

```
pr_number   | status   | approved_by       | approval_date | total_items | approved_items
------------+----------+-------------------+---------------+-------------+---------------
PR-2025-001 | approved | Chief Pharmacist  |  2025-01-15   |      3      |       3
```

---

## 🖥️ **UI MOCKUP: PR List View**

```
╔════════════════════════════════════════════════════════════════════╗
║  INVS Modern - Purchase Requests                              [X] ║
╠════════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  📋 Purchase Request Management                                    ║
║                                                                    ║
║  [+ New PR] [🔍 Search] [🗂 Filter] [📊 Export]                    ║
║                                                                    ║
║  Status: [All ▼] Department: [All ▼] Date: [Jan 2025 ▼]          ║
║                                                                    ║
║  ┌──────────────────────────────────────────────────────────────┐ ║
║  │PR Number  │Date    │Dept │Amount     │Status    │Approval│◄─┼─║
║  ├───────────┼────────┼─────┼───────────┼──────────┼────────┼──┤ ║
║  │PR-2025-001│15/01/25│PHARM│ 120,000.00│✅APPROVED│✓ Chief │🔍│ ║
║  │           │        │     │           │          │  Pharm  │  │ ║
║  ├───────────┼────────┼─────┼───────────┼──────────┼────────┼──┤ ║
║  │PR-2025-002│16/01/25│NURSE│  80,000.00│🔄PENDING │⏳      │🔍│ ║
║  │           │        │     │           │          │        │  │ ║
║  ├───────────┼────────┼─────┼───────────┼──────────┼────────┼──┤ ║
║  │PR-2025-003│16/01/25│MED  │ 150,000.00│📝DRAFT   │-       │🔍│ ║
║  │           │        │     │           │          │        │  │ ║
║  ├───────────┼────────┼─────┼───────────┼──────────┼────────┼──┤ ║
║  │PR-2025-004│14/01/25│LAB  │  45,000.00│❌REJECTED│✗ Fin.  │🔍│ ║
║  │           │        │     │           │          │  Mgr    │  │ ║
║  └───────────┴────────┴─────┴───────────┴──────────┴────────┴──┘ ║
║                                                                    ║
║  Page 1 of 5        [<] [1] [2] [3] [4] [5] [>]                  ║
║                                                                    ║
║  Summary:                                                          ║
║  • Total PRs: 47                                                   ║
║  • Pending: 12  • Approved: 30  • Rejected: 3  • Draft: 2         ║
║  • Total Amount: 3,850,000.00 บาท                                 ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
```

---

## ✅ **Validation Rules**

### 1. PR Creation Validation

```sql
-- Check PR number uniqueness
SELECT COUNT(*) FROM purchase_requests WHERE pr_number = 'PR-2025-001';
-- Must be 0 for new PR

-- Validate department exists and is active
SELECT id, is_active FROM departments WHERE id = :department_id;
-- Must return active department

-- Validate budget allocation exists
SELECT id, status FROM budget_allocations
WHERE id = :budget_allocation_id AND status = 'active';
-- Must return active allocation

-- Validate requested amount > 0
SELECT :requested_amount > 0;
-- Must be true
```

### 2. PR Item Validation

```sql
-- Check generic drug exists
SELECT id, is_active FROM drug_generics WHERE id = :generic_id;
-- Must return active generic

-- Validate quantity > 0
SELECT :quantity_requested > 0;
-- Must be true

-- Validate estimated cost >= 0
SELECT :estimated_unit_cost >= 0;
-- Must be true

-- Check total calculation
SELECT (:quantity_requested * :estimated_unit_cost) = :estimated_total_cost;
-- Must be true
```

### 3. Budget Check Validation

```sql
-- Verify budget available before submission
SELECT available FROM check_budget_availability(
  :fiscal_year, :budget_type_id, :department_id, :amount, :quarter
);
-- Must return true

-- Check no expired reservations
SELECT COUNT(*) FROM budget_reservations
WHERE pr_id = :pr_id AND status = 'active' AND expires_date < CURRENT_DATE;
-- Must be 0
```

---

## 🚨 **Error Handling**

### Common Errors

| Error Code | Message | Solution |
|------------|---------|----------|
| `PR001` | PR number already exists | System will auto-generate unique number |
| `PR002` | Department not found | Select valid department |
| `PR003` | Budget allocation not found | Create budget allocation first |
| `PR004` | Insufficient budget | Reduce amount or request more budget |
| `PR005` | No items in PR | Add at least one item |
| `PR006` | Generic drug not found | Select valid generic drug |
| `PR007` | Invalid quantity | Quantity must be > 0 |
| `PR008` | Budget reservation expired | Create new PR |
| `PR009` | PR already approved | Cannot modify approved PR |

### Error Response Example

```json
{
  "success": false,
  "errorCode": "PR004",
  "message": "Insufficient budget for this request",
  "details": {
    "requested": 120000.00,
    "available": 80000.00,
    "quarter": 1
  },
  "suggestions": [
    "Reduce requested amount to 80,000 บาท or below",
    "Split into multiple PRs for different quarters",
    "Request budget transfer from another department"
  ]
}
```

---

## 📈 **Success Criteria**

### ✅ Purchase Request Checklist

- [ ] PR created with auto-generated number
- [ ] All items have valid generic drugs
- [ ] Estimated costs calculated correctly
- [ ] Budget availability checked
- [ ] Budget reserved successfully
- [ ] PR submitted with SUBMITTED status
- [ ] Notifications sent to approvers
- [ ] PR appears in approval queue
- [ ] Approval workflow completed
- [ ] PR status updated to APPROVED
- [ ] Ready for PO conversion

### Key Metrics

```sql
-- PR Performance Metrics
SELECT
  COUNT(*) as total_prs,
  COUNT(CASE WHEN status = 'draft' THEN 1 END) as draft_count,
  COUNT(CASE WHEN status = 'submitted' THEN 1 END) as submitted_count,
  COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_count,
  COUNT(CASE WHEN status = 'rejected' THEN 1 END) as rejected_count,
  AVG(EXTRACT(EPOCH FROM (approval_date - pr_date)) / 86400) as avg_approval_days,
  SUM(requested_amount) as total_amount
FROM purchase_requests
WHERE pr_date >= '2025-01-01'
  AND pr_date < '2025-02-01';
```

---

## 🎯 **Next Steps**

**หลังจาก PR Approved:**

1. ✅ **Convert to Purchase Order** (FLOW_03_Part2)
   - เปลี่ยนจาก Generic drugs → Trade drugs
   - เลือก Vendor
   - สร้าง PO

2. ✅ **Monitor Budget** (FLOW_02)
   - Budget Reservation → Commitment
   - Track utilization

3. ✅ **Receive Goods** (FLOW_03_Part3)
   - Create Receipt
   - Update Inventory

---

**📝 Note**: Part 1 นี้ครอบคลุมเฉพาะ Purchase Request (PR) เท่านั้น ดูต่อที่ Part 2 สำหรับ Purchase Order (PO) และ Part 3 สำหรับ Goods Receipt
