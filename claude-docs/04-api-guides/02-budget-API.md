# 🚀 Budget Management - API Development Guide

**System:** Budget Management
**Version:** 2.6.0
**Last Updated:** 2025-01-28
**Target Audience:** Backend Developers

---

## 📋 Table of Contents

1. [Authentication & Authorization](#authentication--authorization)
2. [API Development Priority](#api-development-priority)
3. [Error Handling Standards](#error-handling-standards)
4. [Request/Response Examples](#requestresponse-examples)
5. [Environment Configuration](#environment-configuration)
6. [Testing Guidelines](#testing-guidelines)

---

## 🔐 Authentication & Authorization

### Role-Based Access Control (RBAC) Matrix

| Feature | Endpoint | Finance Manager | Dept Head | Pharmacist | Nurse | Other Staff |
|---------|----------|----------------|-----------|------------|-------|-------------|
| **Budget Allocation** |
| View All Allocations | `GET /api/budget/allocations` | ✅ All depts | ✅ Own dept | ✅ Own dept | ✅ Own dept | ✅ Own dept |
| Create Allocation | `POST /api/budget/allocations` | ✅ | ❌ | ❌ | ❌ | ❌ |
| Update Allocation | `PUT /api/budget/allocations/:id` | ✅ | ❌ | ❌ | ❌ | ❌ |
| View Dashboard | `GET /api/budget/dashboard` | ✅ All depts | ✅ Own dept | ✅ Own dept | ✅ Own dept | ❌ |
| **Budget Planning** |
| Create Plan | `POST /api/budget/plans` | ✅ | ✅ | ✅ | ❌ | ❌ |
| Edit Plan (DRAFT) | `PUT /api/budget/plans/:id` | ✅ | ✅ | ✅ | ❌ | ❌ |
| Submit for Approval | `POST /api/budget/plans/:id/submit` | ✅ | ✅ | ✅ | ❌ | ❌ |
| Approve Plan | `POST /api/budget/plans/:id/approve` | ✅ | ✅ (Own dept) | ❌ | ❌ | ❌ |
| Reject Plan | `POST /api/budget/plans/:id/reject` | ✅ | ✅ (Own dept) | ❌ | ❌ | ❌ |
| **Budget Reservation** |
| Check Availability | `POST /api/budget/check-availability` | ✅ | ✅ | ✅ | ✅ | ✅ |
| Reserve Budget | `POST /api/budget/reserve` | 🔄 Auto | 🔄 Auto | 🔄 Auto | 🔄 Auto | 🔄 Auto |
| Release Reservation | `POST /api/budget/reservations/:id/release` | ✅ | ✅ (Own) | ✅ (Own) | ✅ (Own) | ❌ |
| **Budget Monitoring** |
| View Status | `GET /api/budget/status` | ✅ All depts | ✅ Own dept | ✅ Own dept | ✅ Own dept | ❌ |
| View Reservations | `GET /api/budget/reservations/active` | ✅ All depts | ✅ Own dept | ✅ Own dept | ❌ | ❌ |
| Export Reports | `GET /api/budget/reports/export` | ✅ | ✅ (Own dept) | ❌ | ❌ | ❌ |

**Legend:**
- ✅ = Full Access
- ❌ = No Access
- 🔄 = Automatic (system-triggered, not direct user call)
- "Own dept" = Can only access their own department's data
- "All depts" = Can access all departments' data

### Implementation Notes

**1. Department Scoping:**
```typescript
// Middleware to enforce department scoping
async function enforceDepartmentScope(req, res, next) {
  const user = req.user;
  const requestedDeptId = req.params.departmentId || req.body.department_id;

  // Finance Manager can access all departments
  if (user.role === 'FINANCE_MANAGER') {
    return next();
  }

  // Others can only access their own department
  if (user.department_id !== requestedDeptId) {
    return res.status(403).json({
      success: false,
      error: {
        code: 'UNAUTHORIZED',
        message: 'You can only access your own department data'
      }
    });
  }

  next();
}
```

**2. Plan Approval Hierarchy:**
```
Pharmacist creates plan (DRAFT)
   ↓
Pharmacist submits (SUBMITTED)
   ↓
Department Head approves (APPROVED) ← Can approve for own department only
   ↓
Finance Manager can override/modify (APPROVED/REVISED)
```

**3. Automatic Budget Operations:**
- `reserve_budget()` is called automatically when PR is created
- `commit_budget()` is called automatically when PO is approved
- `release_budget_reservation()` is called automatically when PR is rejected/expired

---

## 📊 API Development Priority

### Phase 1: Critical - Must Have First (Week 1) ⭐

**Why:** Procurement system depends on these endpoints

| Priority | Endpoint | Method | Purpose | Dependencies |
|----------|----------|--------|---------|--------------|
| 1 | `/api/budget/check-availability` | POST | Check if budget available | None |
| 2 | `/api/budget/reserve` | POST | Reserve budget for PR | Budget allocation must exist |
| 3 | `/api/budget/commit` | POST | Commit budget when PO approved | Reservation must exist |
| 4 | `/api/budget/reservations/:id/release` | POST | Release expired/cancelled reservations | Reservation must exist |

**Development Order:**
```typescript
// 1. Implement check_budget_availability
// 2. Test with various scenarios (sufficient/insufficient budget)
// 3. Implement reserve_budget
// 4. Test reservation creation and expiry
// 5. Implement commit_budget
// 6. Test full flow: check → reserve → commit
// 7. Implement release_budget_reservation
// 8. Test auto-release on expiry
```

---

### Phase 2: Budget Management (Week 2)

**Why:** Finance team needs to set up budgets

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 5 | `/api/budget/allocations` | GET | List allocations by year/dept |
| 6 | `/api/budget/allocations/:id` | GET | Get single allocation details |
| 7 | `/api/budget/allocations` | POST | Create new allocation |
| 8 | `/api/budget/allocations/:id` | PUT | Update allocation |
| 9 | `/api/budget/dashboard/:year/:dept` | GET | Budget dashboard view |

---

### Phase 3: Budget Planning (Week 3)

**Why:** Departments need to plan drug purchases

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 10 | `/api/budget/plans` | GET | List plans by year/dept |
| 11 | `/api/budget/plans` | POST | Create new plan |
| 12 | `/api/budget/plans/:id/items` | GET | Get plan items |
| 13 | `/api/budget/plans/:id/items` | POST | Add drug to plan |
| 14 | `/api/budget/plans/:id/items/:itemId` | PUT | Update plan item |
| 15 | `/api/budget/plans/:id/items/:itemId` | DELETE | Remove drug from plan |
| 16 | `/api/budget/plans/:id/submit` | POST | Submit for approval |
| 17 | `/api/budget/plans/:id/approve` | POST | Approve plan |
| 18 | `/api/budget/plans/:id/reject` | POST | Reject plan |

---

### Phase 4: Monitoring & Reports (Week 4)

**Why:** Management needs visibility

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 19 | `/api/budget/status` | GET | Budget status summary |
| 20 | `/api/budget/reservations/active` | GET | Active reservations list |
| 21 | `/api/budget/trends/:year/:dept` | GET | Spending trends chart |
| 22 | `/api/budget/reports/export` | GET | Export budget reports |

---

## 🚨 Error Handling Standards

### Standard Response Format

**Success Response:**
```typescript
{
  success: true,
  data: {
    // Response data here
  },
  message?: string,  // Optional success message
  meta?: {           // Optional metadata
    timestamp: "2025-01-28T10:30:00Z",
    request_id: "req_abc123"
  }
}
```

**Error Response:**
```typescript
{
  success: false,
  error: {
    code: string,           // Error code (see list below)
    message: string,        // Thai error message for UI
    message_en?: string,    // Optional English message
    details?: object,       // Optional additional details
    field?: string          // Optional field name for validation errors
  },
  meta?: {
    timestamp: "2025-01-28T10:30:00Z",
    request_id: "req_abc123"
  }
}
```

---

### Error Codes

#### **Budget Allocation Errors**

| Code | HTTP Status | Thai Message | English Message | When to Use |
|------|-------------|--------------|-----------------|-------------|
| `INSUFFICIENT_BUDGET` | 400 | งบประมาณไม่เพียงพอ | Insufficient budget available | Budget check fails |
| `DUPLICATE_ALLOCATION` | 409 | มีการจัดสรรงบประมาณนี้แล้ว | Budget allocation already exists | Creating duplicate allocation |
| `INVALID_QUARTER_SUM` | 400 | ผลรวมงบรายไตรมาสไม่เท่ากับงบรวม | Quarterly budgets must sum to total | Q1+Q2+Q3+Q4 ≠ Total |
| `BUDGET_NOT_FOUND` | 404 | ไม่พบข้อมูลงบประมาณ | Budget allocation not found | Allocation ID doesn't exist |
| `INVALID_QUARTER` | 400 | ไตรมาสไม่ถูกต้อง (ต้อง 1-4) | Invalid quarter (must be 1-4) | Quarter not in 1-4 range |

**Example Error Response:**
```typescript
{
  success: false,
  error: {
    code: "INSUFFICIENT_BUDGET",
    message: "งบประมาณไม่เพียงพอ",
    message_en: "Insufficient budget available",
    details: {
      requested: 150000.00,
      available: 100000.00,
      shortage: 50000.00,
      quarter: 2,
      fiscal_year: 2025,
      department: "Pharmacy Department"
    }
  }
}
```

---

#### **Budget Planning Errors**

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `PLAN_NOT_FOUND` | 404 | ไม่พบแผนงบประมาณ | Plan ID doesn't exist |
| `PLAN_NOT_APPROVED` | 400 | แผนงบประมาณยังไม่ได้รับอนุมัติ | Plan status is not APPROVED |
| `PLAN_ALREADY_SUBMITTED` | 400 | แผนนี้ส่งอนุมัติแล้ว | Cannot edit submitted plan |
| `DUPLICATE_PLAN_ITEM` | 409 | ยานี้อยู่ในแผนแล้ว | Drug already in plan |
| `PLAN_ITEM_NOT_FOUND` | 404 | ไม่พบรายการยาในแผน | Plan item doesn't exist |
| `EMPTY_PLAN` | 400 | แผนต้องมียาอย่างน้อย 1 รายการ | Plan has no items |

**Example Warning (Not in Plan):**
```typescript
{
  success: true,
  data: {
    available: true,
    // ... budget check data
  },
  warnings: [
    {
      code: "NOT_IN_PLAN",
      message: "ยา Paracetamol 500mg ไม่อยู่ในแผนงบประมาณ",
      severity: "WARNING"
    }
  ]
}
```

---

#### **Budget Reservation Errors**

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `RESERVATION_NOT_FOUND` | 404 | ไม่พบข้อมูลการจองงบประมาณ | Reservation ID doesn't exist |
| `RESERVATION_EXPIRED` | 400 | การจองงบประมาณหมดอายุแล้ว | Reservation expired |
| `RESERVATION_ALREADY_RELEASED` | 400 | การจองงบนี้ถูกปลดล็อคแล้ว | Already released |
| `DUPLICATE_RESERVATION` | 409 | PR นี้มีการจองงบแล้ว | PR already has reservation |

---

#### **Authentication & Authorization Errors**

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `UNAUTHORIZED` | 403 | คุณไม่มีสิทธิ์เข้าถึงข้อมูลนี้ | User lacks permission |
| `INVALID_TOKEN` | 401 | Token ไม่ถูกต้อง | JWT token invalid |
| `TOKEN_EXPIRED` | 401 | Token หมดอายุ | JWT token expired |
| `DEPARTMENT_MISMATCH` | 403 | คุณสามารถเข้าถึงข้อมูลแผนกตัวเองเท่านั้น | Accessing other dept data |

---

#### **Validation Errors**

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `VALIDATION_ERROR` | 400 | ข้อมูลไม่ถูกต้อง | General validation failure |
| `REQUIRED_FIELD` | 400 | กรุณากรอก {field} | Required field missing |
| `INVALID_FORMAT` | 400 | รูปแบบ {field} ไม่ถูกต้อง | Wrong format (e.g., date, number) |
| `OUT_OF_RANGE` | 400 | {field} ต้องอยู่ระหว่าง {min} ถึง {max} | Value out of range |

**Example Validation Error:**
```typescript
{
  success: false,
  error: {
    code: "VALIDATION_ERROR",
    message: "ข้อมูลไม่ถูกต้อง",
    details: {
      errors: [
        {
          field: "total_budget",
          code: "REQUIRED_FIELD",
          message: "กรุณากรอกงบประมาณรวม"
        },
        {
          field: "fiscal_year",
          code: "OUT_OF_RANGE",
          message: "ปีงบประมาณต้องอยู่ระหว่าง 2020 ถึง 2030"
        }
      ]
    }
  }
}
```

---

## 📝 Request/Response Examples

### 1. Check Budget Availability

**Endpoint:** `POST /api/budget/check-availability`

**Purpose:** ตรวจสอบว่างบประมาณเพียงพอสำหรับ PR หรือไม่

**Request:**
```typescript
{
  fiscal_year: 2025,
  budget_type_id: 1,        // OP001 - ยาและเวชภัณฑ์
  department_id: 2,         // Pharmacy Department
  amount: 150000.00,
  quarter: 2                // Q2 (Apr-Jun)
}
```

**Success Response (Available):**
```typescript
{
  success: true,
  data: {
    available: true,
    allocation_id: 1,
    total_budget: 10000000.00,
    total_spent: 3321500.00,
    remaining_budget: 6678500.00,
    quarter_budget: 2500000.00,
    quarter_spent: 1821500.00,
    quarter_remaining: 678500.00,
    utilization_percent: 33.22,
    quarter_utilization_percent: 72.86
  },
  message: "งบประมาณเพียงพอสำหรับการสั่งซื้อ"
}
```

**Error Response (Insufficient):**
```typescript
{
  success: false,
  error: {
    code: "INSUFFICIENT_BUDGET",
    message: "งบประมาณไม่เพียงพอ",
    details: {
      requested: 800000.00,
      available: 678500.00,
      shortage: 121500.00,
      quarter: 2,
      quarter_budget: 2500000.00,
      quarter_spent: 1821500.00,
      quarter_remaining: 678500.00
    }
  }
}
```

---

### 2. Reserve Budget (Internal - Called by Procurement)

**Endpoint:** `POST /api/budget/reserve`

**Purpose:** จองงบประมาณเมื่อสร้าง PR

**Request:**
```typescript
{
  allocation_id: 1,
  pr_id: 123,
  amount: 150000.00,
  quarter: 2,
  expires_days: 30          // Optional, default 30
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    reservation_id: 456,
    allocation_id: 1,
    pr_id: 123,
    reserved_amount: 150000.00,
    quarter: 2,
    reservation_date: "2025-04-15T09:00:00Z",
    expires_date: "2025-05-15T09:00:00Z",
    is_released: false
  },
  message: "จองงบประมาณสำเร็จ หมดอายุวันที่ 15 พ.ค. 2568"
}
```

**Error Response:**
```typescript
{
  success: false,
  error: {
    code: "DUPLICATE_RESERVATION",
    message: "PR นี้มีการจองงบประมาณแล้ว",
    details: {
      pr_id: 123,
      existing_reservation_id: 450,
      reserved_amount: 150000.00
    }
  }
}
```

---

### 3. Create Budget Allocation

**Endpoint:** `POST /api/budget/allocations`

**Purpose:** สร้างการจัดสรรงบประมาณประจำปี

**Request:**
```typescript
{
  fiscal_year: 2025,
  budget_id: 1,             // OP001 - ยาและเวชภัณฑ์
  department_id: 2,         // Pharmacy Department
  total_budget: 10000000.00,
  q1_budget: 2500000.00,
  q2_budget: 2500000.00,
  q3_budget: 2500000.00,
  q4_budget: 2500000.00
}
```

**Validation:**
```typescript
// Server-side validation
if (q1_budget + q2_budget + q3_budget + q4_budget !== total_budget) {
  throw new ValidationError('INVALID_QUARTER_SUM');
}

if (total_budget <= 0) {
  throw new ValidationError('Total budget must be positive');
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 1,
    fiscal_year: 2025,
    budget_id: 1,
    department_id: 2,
    total_budget: 10000000.00,
    q1_budget: 2500000.00,
    q2_budget: 2500000.00,
    q3_budget: 2500000.00,
    q4_budget: 2500000.00,
    q1_spent: 0,
    q2_spent: 0,
    q3_spent: 0,
    q4_spent: 0,
    total_spent: 0,
    remaining_budget: 10000000.00,
    status: "ACTIVE",
    created_at: "2025-01-15T10:00:00Z",

    // Include related data
    budget: {
      id: 1,
      budget_code: "OP001",
      budget_type: {
        type_name: "งบดำเนินงาน",
        type_code: "OP"
      },
      budget_category: {
        category_name: "ยาและเวชภัณฑ์"
      }
    },
    department: {
      id: 2,
      dept_name: "ห้องยา",
      dept_code: "PHAR"
    }
  },
  message: "สร้างการจัดสรรงบประมาณสำเร็จ"
}
```

---

### 4. Create Budget Plan

**Endpoint:** `POST /api/budget/plans`

**Purpose:** สร้างแผนงบประมาณระดับยา

**Request:**
```typescript
{
  fiscal_year: 2025,
  department_id: 2,
  plan_name: "แผนจัดซื้อยาประจำปี 2025 - ห้องยา"
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 1,
    fiscal_year: 2025,
    department_id: 2,
    plan_name: "แผนจัดซื้อยาประจำปี 2025 - ห้องยา",
    total_planned_amount: 0,
    status: "DRAFT",
    is_active: true,
    created_at: "2025-01-15T10:00:00Z",
    department: {
      id: 2,
      dept_name: "ห้องยา"
    }
  },
  message: "สร้างแผนงบประมาณสำเร็จ"
}
```

---

### 5. Add Drug to Budget Plan

**Endpoint:** `POST /api/budget/plans/:planId/items`

**Purpose:** เพิ่มยาลงในแผนงบประมาณ

**Request:**
```typescript
{
  generic_id: 101,          // Paracetamol 500mg

  // Historical consumption (optional - auto-fetch if available)
  last_year_qty: 50000,
  two_years_ago_qty: 48000,
  three_years_ago_qty: 45000,

  // Planning for current year
  planned_quantity: 52000,
  estimated_unit_price: 2.50,

  // Quarterly breakdown
  q1_planned_qty: 13000,
  q2_planned_qty: 13000,
  q3_planned_qty: 13000,
  q4_planned_qty: 13000,

  notes: "เพิ่ม 10% จากปีที่แล้วเนื่องจากคาดว่าผู้ป่วยเพิ่มขึ้น"
}
```

**Validation:**
```typescript
// Auto-calculate total value
const total_planned_value = planned_quantity * estimated_unit_price;

// Validate quarterly sum
if (q1_planned_qty + q2_planned_qty + q3_planned_qty + q4_planned_qty !== planned_quantity) {
  throw new ValidationError('INVALID_QUARTER_SUM');
}

// Check duplicate
const existing = await prisma.budgetPlanItem.findFirst({
  where: { budget_plan_id: planId, generic_id: generic_id }
});
if (existing) {
  throw new ConflictError('DUPLICATE_PLAN_ITEM');
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 1,
    budget_plan_id: 1,
    generic_id: 101,

    // Historical
    last_year_qty: 50000,
    two_years_ago_qty: 48000,
    three_years_ago_qty: 45000,
    avg_consumption: 47667,

    // Planning
    planned_quantity: 52000,
    estimated_unit_price: 2.50,
    total_planned_value: 130000.00,

    // Quarterly
    q1_planned_qty: 13000,
    q2_planned_qty: 13000,
    q3_planned_qty: 13000,
    q4_planned_qty: 13000,

    // Purchase tracking
    q1_purchased_qty: 0,
    q2_purchased_qty: 0,
    q3_purchased_qty: 0,
    q4_purchased_qty: 0,
    total_purchased_qty: 0,
    total_purchased_value: 0,

    notes: "เพิ่ม 10% จากปีที่แล้วเนื่องจากคาดว่าผู้ป่วยเพิ่มขึ้น",
    created_at: "2025-01-15T10:30:00Z",

    // Include drug info
    generic: {
      id: 101,
      working_code: "0001001",
      generic_name: "Paracetamol 500mg TAB",
      dosage_form: "Tablet"
    }
  },
  message: "เพิ่มยาลงในแผนสำเร็จ"
}
```

---

### 6. Get Budget Dashboard

**Endpoint:** `GET /api/budget/dashboard/:fiscalYear/:departmentId`

**Example:** `GET /api/budget/dashboard/2025/2`

**Success Response:**
```typescript
{
  success: true,
  data: {
    fiscal_year: 2025,
    department: {
      id: 2,
      dept_name: "ห้องยา",
      dept_code: "PHAR"
    },

    // Summary cards
    summary: {
      total_budget: 10000000.00,
      total_spent: 3321500.00,
      total_reserved: 79300.00,
      remaining_budget: 6599200.00,
      utilization_percent: 33.99
    },

    // By budget type
    by_budget_type: [
      {
        budget_code: "OP001",
        budget_name: "ยาและเวชภัณฑ์",
        allocated: 10000000.00,
        spent: 3321500.00,
        reserved: 79300.00,
        remaining: 6599200.00,
        percent: 33.99
      }
    ],

    // Quarterly breakdown
    quarterly: {
      q1: {
        budget: 2500000.00,
        spent: 1500000.00,
        reserved: 0,
        remaining: 1000000.00,
        percent: 60.00,
        status: "COMPLETED"
      },
      q2: {
        budget: 2500000.00,
        spent: 1821500.00,
        reserved: 79300.00,
        remaining: 599200.00,
        percent: 76.03,
        status: "CURRENT"
      },
      q3: {
        budget: 2500000.00,
        spent: 0,
        reserved: 0,
        remaining: 2500000.00,
        percent: 0,
        status: "UPCOMING"
      },
      q4: {
        budget: 2500000.00,
        spent: 0,
        reserved: 0,
        remaining: 2500000.00,
        percent: 0,
        status: "UPCOMING"
      }
    },

    // Active reservations
    active_reservations: [
      {
        reservation_id: 456,
        pr_number: "PR-2025-04-001",
        pr_id: 123,
        amount: 21500.00,
        quarter: 2,
        expires_date: "2025-05-15T09:00:00Z",
        days_until_expiry: 15
      },
      {
        reservation_id: 458,
        pr_number: "PR-2025-04-003",
        pr_id: 125,
        amount: 45000.00,
        quarter: 2,
        expires_date: "2025-05-18T09:00:00Z",
        days_until_expiry: 18
      }
    ],

    // Alerts
    alerts: [
      {
        type: "WARNING",
        code: "HIGH_UTILIZATION",
        message: "งบประมาณ Q2 ใช้ไปแล้ว 76% เข้าใกล้เกณฑ์เตือน"
      }
    ]
  }
}
```

---

### 7. Submit Budget Plan for Approval

**Endpoint:** `POST /api/budget/plans/:planId/submit`

**Request:**
```typescript
{
  // No body required - just change status
}
```

**Validation:**
```typescript
// Check plan has items
const itemCount = await prisma.budgetPlanItem.count({
  where: { budget_plan_id: planId }
});

if (itemCount === 0) {
  throw new ValidationError('EMPTY_PLAN');
}

// Check all items are valid
const invalidItems = await prisma.budgetPlanItem.findMany({
  where: {
    budget_plan_id: planId,
    OR: [
      { planned_quantity: { lte: 0 } },
      { estimated_unit_price: { lte: 0 } }
    ]
  }
});

if (invalidItems.length > 0) {
  throw new ValidationError('INVALID_PLAN_ITEMS');
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 1,
    status: "SUBMITTED",
    submitted_at: "2025-01-15T14:30:00Z",
    item_count: 25,
    total_planned_amount: 2500000.00
  },
  message: "ส่งแผนงบประมาณเพื่ออนุมัติสำเร็จ"
}
```

---

## ⚙️ Environment Configuration

**Required Environment Variables:**

```env
# Budget System Configuration
BUDGET_RESERVATION_EXPIRES_DAYS=30        # จำนวนวันก่อน reservation หมดอายุ
BUDGET_ALERT_THRESHOLD_PERCENT=80         # เตือนเมื่อใช้งบเกิน % นี้
BUDGET_CRITICAL_THRESHOLD_PERCENT=90      # เตือนวิกฤตเมื่อใช้งบเกิน % นี้
BUDGET_ALLOW_OVER_PLAN=true               # อนุญาตให้ซื้อยาที่ไม่อยู่ในแผนหรือไม่ (true/false)
BUDGET_AUTO_RELEASE_EXPIRED=true          # Auto-release expired reservations (true/false)
BUDGET_FISCAL_YEAR_START_MONTH=10         # ปีงบประมาณเริ่มเดือนอะไร (1-12, default: 10 = Oct)

# Notification Settings
BUDGET_NOTIFY_ON_APPROVAL=true            # ส่ง notification เมื่ออนุมัติ plan
BUDGET_NOTIFY_HIGH_UTILIZATION=true       # ส่ง notification เมื่อใช้งบสูง
BUDGET_NOTIFY_EXPIRING_RESERVATION=true   # ส่ง notification เมื่อ reservation ใกล้หมดอายุ
BUDGET_NOTIFY_DAYS_BEFORE_EXPIRY=7        # แจ้งเตือนกี่วันก่อนหมดอายุ
```

**Usage in Code:**
```typescript
// config/budget.config.ts
export const budgetConfig = {
  reservationExpiresDays: parseInt(process.env.BUDGET_RESERVATION_EXPIRES_DAYS || '30'),
  alertThreshold: parseFloat(process.env.BUDGET_ALERT_THRESHOLD_PERCENT || '80'),
  criticalThreshold: parseFloat(process.env.BUDGET_CRITICAL_THRESHOLD_PERCENT || '90'),
  allowOverPlan: process.env.BUDGET_ALLOW_OVER_PLAN === 'true',
  autoReleaseExpired: process.env.BUDGET_AUTO_RELEASE_EXPIRED === 'true',
  fiscalYearStartMonth: parseInt(process.env.BUDGET_FISCAL_YEAR_START_MONTH || '10'),

  notifications: {
    onApproval: process.env.BUDGET_NOTIFY_ON_APPROVAL === 'true',
    highUtilization: process.env.BUDGET_NOTIFY_HIGH_UTILIZATION === 'true',
    expiringReservation: process.env.BUDGET_NOTIFY_EXPIRING_RESERVATION === 'true',
    daysBeforeExpiry: parseInt(process.env.BUDGET_NOTIFY_DAYS_BEFORE_EXPIRY || '7')
  }
};
```

---

## 🧪 Testing Guidelines

### Unit Tests

**Test Database Functions:**
```typescript
describe('check_budget_availability', () => {
  it('should return available=true when budget sufficient', async () => {
    const result = await prisma.$queryRaw`
      SELECT * FROM check_budget_availability(2025, 1, 2, 100000.00, 2)
    `;
    expect(result[0].available).toBe(true);
    expect(result[0].remaining_budget).toBeGreaterThanOrEqual(100000);
  });

  it('should return available=false when budget insufficient', async () => {
    const result = await prisma.$queryRaw`
      SELECT * FROM check_budget_availability(2025, 1, 2, 10000000.00, 2)
    `;
    expect(result[0].available).toBe(false);
  });

  it('should return error when allocation not found', async () => {
    const result = await prisma.$queryRaw`
      SELECT * FROM check_budget_availability(2099, 999, 999, 100000.00, 2)
    `;
    expect(result[0].available).toBe(false);
    expect(result[0].message).toContain('No active budget allocation found');
  });
});
```

---

### Integration Tests

**Test Full Budget Workflow:**
```typescript
describe('Budget Workflow: Check → Reserve → Commit', () => {
  let allocationId: number;
  let prId: number;
  let reservationId: number;

  beforeAll(async () => {
    // Setup: Create allocation
    const allocation = await prisma.budgetAllocation.create({
      data: {
        fiscal_year: 2025,
        budget_id: 1,
        department_id: 2,
        total_budget: 10000000,
        q1_budget: 2500000,
        q2_budget: 2500000,
        q3_budget: 2500000,
        q4_budget: 2500000
      }
    });
    allocationId = allocation.id;
  });

  it('Step 1: Check budget availability', async () => {
    const response = await request(app)
      .post('/api/budget/check-availability')
      .send({
        fiscal_year: 2025,
        budget_type_id: 1,
        department_id: 2,
        amount: 150000,
        quarter: 2
      });

    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
    expect(response.body.data.available).toBe(true);
  });

  it('Step 2: Reserve budget for PR', async () => {
    // Create PR first
    const pr = await prisma.purchaseRequest.create({
      data: {
        pr_number: 'PR-TEST-001',
        department_id: 2,
        total_amount: 150000
      }
    });
    prId = pr.id;

    // Reserve budget
    const response = await request(app)
      .post('/api/budget/reserve')
      .send({
        allocation_id: allocationId,
        pr_id: prId,
        amount: 150000,
        quarter: 2
      });

    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
    expect(response.body.data.reservation_id).toBeDefined();
    reservationId = response.body.data.reservation_id;
  });

  it('Step 3: Commit budget when PO approved', async () => {
    const response = await request(app)
      .post('/api/budget/commit')
      .send({
        allocation_id: allocationId,
        po_id: 1,
        amount: 150000,
        quarter: 2
      });

    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);

    // Verify allocation updated
    const allocation = await prisma.budgetAllocation.findUnique({
      where: { id: allocationId }
    });
    expect(allocation.q2_spent).toBe(150000);
    expect(allocation.total_spent).toBe(150000);

    // Verify reservation released
    const reservation = await prisma.budgetReservation.findUnique({
      where: { id: reservationId }
    });
    expect(reservation.is_released).toBe(true);
  });

  afterAll(async () => {
    // Cleanup
    await prisma.budgetReservation.deleteMany();
    await prisma.purchaseRequest.deleteMany();
    await prisma.budgetAllocation.deleteMany();
  });
});
```

---

### Performance Tests

**Test Scenarios:**
```typescript
describe('Budget System Performance', () => {
  it('should check budget availability in < 100ms', async () => {
    const start = Date.now();
    await prisma.$queryRaw`
      SELECT * FROM check_budget_availability(2025, 1, 2, 100000.00, 2)
    `;
    const duration = Date.now() - start;
    expect(duration).toBeLessThan(100);
  });

  it('should handle 100 concurrent budget checks', async () => {
    const promises = Array(100).fill(null).map(() =>
      request(app)
        .post('/api/budget/check-availability')
        .send({
          fiscal_year: 2025,
          budget_type_id: 1,
          department_id: 2,
          amount: 10000,
          quarter: 2
        })
    );

    const results = await Promise.all(promises);
    expect(results.every(r => r.status === 200)).toBe(true);
  });
});
```

---

## 📚 Additional Resources

### Related Documentation
- **[README.md](README.md)** - System overview
- **[SCHEMA.md](SCHEMA.md)** - Database schema (4 tables + 6 functions)
- **[WORKFLOWS.md](WORKFLOWS.md)** - 5 business workflows with diagrams
- **[../../SYSTEM_ARCHITECTURE.md](../../SYSTEM_ARCHITECTURE.md)** - Complete system architecture

### Database Functions Reference
- `prisma/functions.sql` - Full SQL implementation of 6 budget functions

### Frontend Development
- See `docs/flows/FLOW_08_Frontend_Purchase_Request.md` for UI mockups

---

**Ready to Start?**

1. ✅ Implement Phase 1 endpoints (check, reserve, commit, release)
2. ✅ Write unit tests for database functions
3. ✅ Write integration tests for full workflows
4. ✅ Set up error handling with standard format
5. ✅ Configure environment variables
6. ✅ Test with Postman/Insomnia using examples above

**Questions?** Contact the database team or refer to WORKFLOWS.md for detailed business logic.

---

**Last Updated:** 2025-01-28 | **Version:** 2.6.0
**Built with ❤️ for INVS Modern Team**
