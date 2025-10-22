# 💰 Budget Management - UI Mockups & User Flow

**Budget Management System - User Interface Mockups**

**Version:** 2.2.0
**Last Updated:** 2025-01-22

---

## 📋 Overview

เอกสารนี้แสดง UI mockups และ user flow สำหรับ Budget Management workflows สำคัญ:

1. **Budget Allocation** - จัดสรรงบประมาณประจำปี (แบ่งตาม Quarter)
2. **Budget Planning with Drugs** - วางแผนงบระดับยา (Drug-level planning)
3. **Budget Monitoring** - Dashboard ติดตามงบประมาณ

---

## 🔄 Flow 1: Budget Allocation

### จุดประสงค์
จัดสรรงบประมาณประจำปีให้แต่ละแผนก แบ่งเป็น Q1-Q4

---

### 📱 Screen 1: Budget Allocation Dashboard

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - Budget Management                  👤 Finance   [Logout]   │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Budget Allocation - Fiscal Year 2025                        [+ New Allocation]│
│                                                                              │
│  Summary by Department:                                                      │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Dept        │ Budget Type  │ Allocated    │ Spent       │ Remaining  │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ Pharmacy    │ OP001 - Drugs│ ฿10,000,000  │ ฿3,500,000  │ ฿6,500,000 │ │
│  │ Pharmacy    │ OP002 - Equip│ ฿2,000,000   │ ฿500,000    │ ฿1,500,000 │ │
│  │ ICU         │ OP001 - Drugs│ ฿5,000,000   │ ฿2,000,000  │ ฿3,000,000 │ │
│  │ OPD         │ OP001 - Drugs│ ฿3,000,000   │ ฿1,200,000  │ ฿1,800,000 │ │
│  │ Emergency   │ EM001 - Emerg│ ฿1,000,000   │ ฿100,000    │ ฿900,000   │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Total Allocated: ฿21,000,000 | Total Spent: ฿7,300,000 (34.8%)             │
│                                                                              │
│  Quick Stats:                                                                │
│  📊 Budget Utilization: 34.8%  ████████░░░░░░░░░░░░░░░░░░░  (Low)           │
│  💰 Total Remaining: ฿13,700,000                                             │
│  ⏱️ Fiscal Year Progress: Q1 Complete, In Q2 (48%)                           │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User views allocation summary
2. User clicks **[+ New Allocation]** to create

---

### 📱 Screen 2: Create Budget Allocation

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Budget Allocation                                        [?] [X]   │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Step 1: Basic Information                                                 │
│                                                                            │
│  Fiscal Year: *                                                            │
│  [2025 ▼]                                                                  │
│                                                                            │
│  Department: *                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ [Pharmacy Department ▼]                                              │ │
│  │                                                                      │ │
│  │ Dept Code: PHARM                                                     │ │
│  │ Head: Dr. Smith                                                      │ │
│  │ Existing Allocations: 2 (OP001, OP002)                              │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  Budget Type: *                                                            │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ [OP003 - Medical Supplies ▼]                                         │ │
│  │                                                                      │ │
│  │ Description: Operational - Medical Supplies                          │ │
│  │ Ministry Code: OP003                                                 │ │
│  │ ⚠️ No existing allocation for this type                              │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  Total Annual Budget: *                                                    │
│  [3,000,000.00] THB                                                        │
│                                                                            │
│  ─────────────────────────────────────────────────────────────────────    │
│  Step 2: Quarterly Distribution                                           │
│                                                                            │
│  Distribution Method:                                                      │
│  ● Equal (25% each quarter)    ○ Custom (manual per quarter)             │
│                                                                            │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ Quarter │ Amount (THB)   │ Percentage │ Spent      │ Remaining    │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │ Q1      │ 750,000.00     │ 25%        │ -          │ -            │   │
│  │ Q2      │ 750,000.00     │ 25%        │ -          │ -            │   │
│  │ Q3      │ 750,000.00     │ 25%        │ -          │ -            │   │
│  │ Q4      │ 750,000.00     │ 25%        │ -          │ -            │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │ Total   │ 3,000,000.00   │ 100% ✓     │ -          │ -            │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  Notes (Optional):                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ Annual allocation for medical supplies procurement                │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  [Cancel]                                      [Preview]  [Create Allocation]│
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User selects fiscal year: 2025
2. User selects department: Pharmacy
3. User selects budget type: OP003
4. User enters total: ฿3,000,000
5. User selects distribution: Equal (25% each)
6. System auto-fills quarterly amounts
7. User clicks **[Create Allocation]**

---

### 📱 Screen 3: Custom Quarterly Distribution

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Budget Allocation                                        [?] [X]   │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Distribution Method:                                                      │
│  ○ Equal (25% each quarter)    ● Custom (manual per quarter)             │
│                                                                            │
│  Total to Distribute: ฿3,000,000.00                                        │
│                                                                            │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ Quarter │ Amount (THB)   │ Percentage │ Status                     │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │ Q1      │ [1,000,000.00] │ 33.3%      │ ✓                          │   │
│  │ Q2      │ [800,000.00__] │ 26.7%      │ ✓                          │   │
│  │ Q3      │ [700,000.00__] │ 23.3%      │ ✓                          │   │
│  │ Q4      │ [500,000.00__] │ 16.7%      │ ✓                          │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │ Total   │ 3,000,000.00   │ 100.0% ✓   │ Valid                      │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  Validation:                                                               │
│  ✓ Total matches annual budget (฿3,000,000)                               │
│  ✓ All quarters have positive amounts                                     │
│  ✓ Percentage sum = 100%                                                  │
│                                                                            │
│  💡 Tip: Allocate more budget to high-demand quarters (Q1, Q2)            │
│                                                                            │
│  [Cancel]                                      [Preview]  [Create Allocation]│
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User selects "Custom" distribution
2. User enters custom amounts per quarter
3. System validates:
   - Sum = Total budget
   - All quarters > 0
   - Percentage = 100%
4. User clicks **[Create Allocation]**

---

## 🔄 Flow 2: Budget Planning with Drugs

### จุดประสงค์
วางแผนงบประมาณระดับยา (Drug-level) พร้อมข้อมูลประวัติ 3 ปี

---

### 📱 Screen 1: Budget Plans List

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - Budget Planning                                            │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Budget Plans (Drug-Level Planning)                       [+ Create New Plan]│
│                                                                              │
│  Fiscal Year: [2025 ▼]     Department: [All ▼]     Status: [Active ▼]       │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Plan ID │ Dept     │ Year │ Total Drugs │ Total Value │ Status │ Action│ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ BP-2025 │ Pharmacy │ 2025 │ 150 drugs   │ ฿8,500,000  │ Active │[View] │ │
│  │ BP-2024 │ Pharmacy │ 2024 │ 145 drugs   │ ฿7,800,000  │ Closed │[View] │ │
│  │ BP-2025 │ ICU      │ 2025 │ 85 drugs    │ ฿4,200,000  │ Active │[View] │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Showing 3 plans                                                             │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User views budget plans
2. User clicks **[+ Create New Plan]** or **[View]**

---

### 📱 Screen 2: Create Budget Plan

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Budget Plan (Drug-Level)                  Step 1 of 2     [?] [X] │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Plan Information                                                          │
│                                                                            │
│  Fiscal Year: *                                                            │
│  [2025 ▼]                                                                  │
│                                                                            │
│  Department: *                                                             │
│  [Pharmacy Department ▼]                                                   │
│  Budget Allocation: OP001 - Drugs (฿10,000,000)                           │
│                                                                            │
│  Plan Name:                                                                │
│  [Pharmacy Drug Budget Plan 2025_________________]                         │
│                                                                            │
│  Plan Period:                                                              │
│  Start: [2025-01-01] 📅    End: [2025-12-31] 📅                           │
│                                                                            │
│  Notes:                                                                    │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ Annual drug procurement plan for Pharmacy Department              │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  [Cancel]                                         [Next: Add Drugs →]      │
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User selects fiscal year and department
2. System shows available budget allocation
3. User clicks **[Next: Add Drugs →]**

---

### 📱 Screen 3: Add Drugs to Plan

```
┌────────────────────────────────────────────────────────────────────────────────┐
│  Create Budget Plan (Drug-Level)                  Step 2 of 2         [?] [X]│
├────────────────────────────────────────────────────────────────────────────────┤
│                                                                                │
│  Plan: Pharmacy Drug Budget Plan 2025                     [+ Add Drug Item]   │
│  Available Budget: ฿10,000,000                                                 │
│                                                                                │
│  Drugs in Plan:                                                                │
│                                                                                │
│  ┌──────────────────────────────────────────────────────────────────────────┐ │
│  │ Generic Drug  │ Planned Qty │ Unit Price │ Total Value │ Q1-Q4 │ Action │ │
│  ├──────────────────────────────────────────────────────────────────────────┤ │
│  │ Paracetamol   │ 500,000 tab │ ฿2.50      │ ฿1,250,000  │ [📊]  │ [Edit] │ │
│  │ Amoxicillin   │ 300,000 cap │ ฿5.00      │ ฿1,500,000  │ [📊]  │ [Edit] │ │
│  │ Ibuprofen     │ 200,000 tab │ ฿3.00      │ ฿600,000    │ [📊]  │ [Edit] │ │
│  └──────────────────────────────────────────────────────────────────────────┘ │
│                                                                                │
│  Summary:                                                                      │
│  Total Drugs: 3                                                                │
│  Total Planned: ฿3,350,000                                                     │
│  Remaining Budget: ฿6,650,000 (66.5%)                                          │
│                                                                                │
│  [← Back]               [Save Draft]  [Preview Plan]  [Create Budget Plan]    │
└────────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User clicks **[+ Add Drug Item]**
2. System opens drug selection dialog
3. User adds multiple drugs
4. User clicks **[Create Budget Plan]**

---

### 📱 Screen 4: Add Drug Item Dialog

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Add Drug to Budget Plan                                         [X]       │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Search Generic Drug: *                                                    │
│  [Paracetamol_________________] 🔍                                         │
│                                                                            │
│  ● Paracetamol                                                             │
│    Working Code: PARA500 | Current Price: ฿2.50/tab                       │
│                                                                            │
│  ─────────────────────────────────────────────────────────────────────    │
│  Historical Consumption (Last 3 Years):                                    │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ Year │ Quantity      │ Value          │ Avg/Month   │ Source       │ │
│  ├──────────────────────────────────────────────────────────────────────┤ │
│  │ 2024 │ 480,000 tabs  │ ฿1,200,000     │ 40,000      │ System       │ │
│  │ 2023 │ 450,000 tabs  │ ฿1,125,000     │ 37,500      │ System       │ │
│  │ 2022 │ 420,000 tabs  │ ฿1,050,000     │ 35,000      │ System       │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  💡 Recommended: 500,000 tabs (based on 5% growth trend)                  │
│                                                                            │
│  ─────────────────────────────────────────────────────────────────────    │
│  Planning for 2025:                                                        │
│                                                                            │
│  Planned Quantity: *                                                       │
│  [500,000] tabs (Annual)                                                   │
│                                                                            │
│  Estimated Unit Price:                                                     │
│  [2.50] THB/tab (Current: ฿2.50)                                           │
│                                                                            │
│  Quarterly Breakdown:                                                      │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ Quarter │ Quantity     │ Value        │ % of Annual                  │ │
│  ├──────────────────────────────────────────────────────────────────────┤ │
│  │ Q1      │ 125,000 tabs │ ฿312,500     │ 25%                          │ │
│  │ Q2      │ 125,000 tabs │ ฿312,500     │ 25%                          │ │
│  │ Q3      │ 125,000 tabs │ ฿312,500     │ 25%                          │ │
│  │ Q4      │ 125,000 tabs │ ฿312,500     │ 25%                          │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  Total Planned Value: ฿1,250,000                                           │
│                                                                            │
│                                             [Cancel]  [Add to Plan]        │
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User searches generic drug
2. System shows 3-year historical data
3. System recommends quantity based on trend
4. User enters planned quantity and price
5. System calculates quarterly breakdown (Equal or Custom)
6. User clicks **[Add to Plan]**

---

## 🔄 Flow 3: Budget Monitoring Dashboard

### จุดประสงค์
Dashboard สำหรับติดตามงบประมาณแบบ real-time

---

### 📱 Screen 1: Budget Monitoring Dashboard

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - Budget Monitoring Dashboard                                    │
├──────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  Fiscal Year 2025 - Overall Status                     As of: 2025-01-22 14:30  │
│                                                                                  │
│  ┌──────────────────────────────────────────────────────────────────────────┐   │
│  │ 💰 Total Budget         📊 Spent          🔒 Reserved        💵 Available │   │
│  │ ฿21,000,000             ฿7,300,000        ฿2,500,000        ฿11,200,000  │   │
│  │                         (34.8%)           (11.9%)           (53.3%)       │   │
│  └──────────────────────────────────────────────────────────────────────────┘   │
│                                                                                  │
│  Budget Utilization by Quarter:                                                 │
│                                                                                  │
│  ┌────────────────────────────────────────────────────────────────────────┐     │
│  │ Q1 (Jan-Mar)  ███████████████████████████████░  92%  ฿4,600,000/฿5M   │     │
│  │ Q2 (Apr-Jun)  ████████████░░░░░░░░░░░░░░░░░░░  48%  ฿2,400,000/฿5M   │     │
│  │ Q3 (Jul-Sep)  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0%  ฿0/฿5.5M          │     │
│  │ Q4 (Oct-Dec)  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0%  ฿0/฿5.5M          │     │
│  └────────────────────────────────────────────────────────────────────────┘     │
│                                                                                  │
│  Budget by Department:                                                           │
│                                                                                  │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │ Dept      │ Allocated   │ Spent      │ Reserved  │ Available │ % Used  │ │ │
│  ├────────────────────────────────────────────────────────────────────────────┤ │
│  │ Pharmacy  │ ฿12,000,000 │ ฿4,000,000 │ ฿1,500,000│ ฿6,500,000│ 33.3% ✓ │ │
│  │ ICU       │ ฿5,000,000  │ ฿2,000,000 │ ฿500,000  │ ฿2,500,000│ 40.0% ✓ │ │
│  │ OPD       │ ฿3,000,000  │ ฿1,200,000 │ ฿400,000  │ ฿1,400,000│ 40.0% ✓ │ │
│  │ Emergency │ ฿1,000,000  │ ฿100,000   │ ฿100,000  │ ฿800,000  │ 10.0% ✓ │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                                                                  │
│  ⚠️ Alerts:                                                                      │
│  • Q1 budget for Pharmacy almost depleted (92% used)                            │
│  • 5 budget reservations expiring within 7 days                                 │
│                                                                                  │
│  Recent Transactions:                                                            │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │ Date       │ Type        │ Dept     │ Amount      │ Reference           │ │ │
│  ├────────────────────────────────────────────────────────────────────────────┤ │
│  │ 2025-01-22 │ Committed   │ Pharmacy │ -฿250,000   │ PO-2025-045         │ │ │
│  │ 2025-01-21 │ Reserved    │ ICU      │ -฿150,000   │ PR-2025-123         │ │ │
│  │ 2025-01-20 │ Committed   │ OPD      │ -฿80,000    │ PO-2025-044         │ │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                                                                  │
│  [Export Report] [View Details] [Manage Reservations]                           │
└──────────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User views real-time budget status
2. User sees:
   - Total budget breakdown
   - Quarterly utilization
   - Department-wise allocation
   - Alerts and warnings
   - Recent transactions
3. User clicks **[View Details]** for drill-down
4. User clicks **[Manage Reservations]** to manage holds

---

### 📱 Screen 2: Department Budget Detail

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Budget Details - Pharmacy Department                               [X]     │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Fiscal Year 2025                                                            │
│                                                                              │
│  Budget Type: OP001 - Operational Drugs                                      │
│  Allocated: ฿10,000,000                                                      │
│                                                                              │
│  Quarterly Breakdown:                                                        │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Quarter│ Allocated  │ Spent      │ Reserved  │ Available │ % Used   │ │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ Q1     │ ฿2,500,000 │ ฿2,300,000 │ ฿150,000  │ ฿50,000   │ 92% ⚠️   │ │
│  │ Q2     │ ฿2,500,000 │ ฿1,500,000 │ ฿500,000  │ ฿500,000  │ 60% ✓    │ │
│  │ Q3     │ ฿2,500,000 │ ฿0         │ ฿0        │ ฿2,500,000│ 0%  ✓    │ │
│  │ Q4     │ ฿2,500,000 │ ฿0         │ ฿0        │ ฿2,500,000│ 0%  ✓    │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ Total  │ ฿10,000,000│ ฿3,800,000 │ ฿650,000  │ ฿5,550,000│ 38% ✓    │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Active Reservations (5):                                                    │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ PR Number   │ Amount    │ Reserved On │ Expires On │ Status        │ │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ PR-2025-123 │ ฿150,000  │ 2025-01-20  │ 2025-01-27 │ Active        │ │ │
│  │ PR-2025-118 │ ฿200,000  │ 2025-01-18  │ 2025-01-25 │ ⚠️ Expiring   │ │ │
│  │ PR-2025-115 │ ฿100,000  │ 2025-01-15  │ 2025-01-22 │ ⚠️ Expiring   │ │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Recent Commitments (3):                                                     │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ PO Number   │ Amount    │ Committed On│ Quarter │ Status           │ │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ PO-2025-045 │ ฿250,000  │ 2025-01-22  │ Q1      │ Committed        │ │ │
│  │ PO-2025-042 │ ฿180,000  │ 2025-01-21  │ Q1      │ Committed        │ │ │
│  │ PO-2025-040 │ ฿150,000  │ 2025-01-20  │ Q1      │ Committed        │ │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│                                         [Export Details]  [Close]            │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User views detailed quarterly breakdown
2. User sees active reservations (expiring soon highlighted)
3. User sees recent commitments (POs)
4. User clicks **[Export Details]** for report

---

## 📊 Summary: Budget Management UI Patterns

### Budget Allocation
- **Screens:** 3 screens (Dashboard, Create, Custom distribution)
- **Key Features:** Quarterly distribution (Equal/Custom), validation, preview
- **Complexity:** ⭐⭐⭐ (Moderate)

### Budget Planning with Drugs
- **Screens:** 4 screens (List, Create, Add drugs, Drug dialog)
- **Key Features:** Historical data (3 years), recommendation, quarterly breakdown
- **Complexity:** ⭐⭐⭐⭐ (Complex)

### Budget Monitoring
- **Screens:** 2 screens (Dashboard, Department detail)
- **Key Features:** Real-time status, alerts, transaction history, drill-down
- **Complexity:** ⭐⭐⭐ (Moderate)

---

## 🎨 UI Design Principles

### 1. Real-time Visibility
- Budget status อัปเดตแบบ real-time
- แสดง Allocated, Spent, Reserved, Available
- Progress bars สำหรับ % utilization

### 2. Quarterly Focus
- ทุก UI แสดงข้อมูลแยกตาม Q1-Q4
- Validation: Quarterly sum = Total
- Track spending per quarter

### 3. Historical Context
- แสดงข้อมูล 3 ปีย้อนหลัง (Budget Planning)
- Trend analysis และ recommendations
- Comparison YoY

### 4. Alerts & Warnings
- เตือนเมื่องบใกล้หมด (>90%)
- เตือนเมื่อ reservation ใกล้หมดอายุ
- Highlight ปัญหาในสีแดง/ส้ม

### 5. Drill-down Capability
- Dashboard → Department → Budget Type → Transactions
- ทุกระดับมีรายละเอียดที่ลึกขึ้น
- Export ได้ทุกระดับ

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.2.0
