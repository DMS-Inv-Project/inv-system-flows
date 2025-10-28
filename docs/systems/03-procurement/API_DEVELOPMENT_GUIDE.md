# 🚀 Procurement System - API Development Guide

**System:** Procurement (Purchase Request & Purchase Order)
**Version:** 2.6.0
**Last Updated:** 2025-01-28
**Target Audience:** Backend Developers

---

## 📋 Overview

Procurement system handles the complete purchasing workflow from requisition to receiving goods:
- **Purchase Requests (PR)** - Department requisitions with budget checking
- **Purchase Orders (PO)** - Approved orders sent to vendors
- **Receipts** - Goods receiving with lot tracking

---

## 🔐 Authentication & Authorization

| Feature | Finance Manager | Dept Head | Pharmacist | Nurse | Other Staff |
|---------|----------------|-----------|------------|-------|-------------|
| **Purchase Request** |
| Create PR | ✅ | ✅ | ✅ | ✅ | ✅ |
| Submit PR | ✅ | ✅ | ✅ | ✅ | ✅ |
| Approve PR (Dept) | ✅ | ✅ (Own dept) | ❌ | ❌ | ❌ |
| Approve PR (Final) | ✅ | ❌ | ❌ | ❌ | ❌ |
| Reject PR | ✅ | ✅ (Own dept) | ❌ | ❌ | ❌ |
| **Purchase Order** |
| Create PO | ✅ | ❌ | ✅ | ❌ | ❌ |
| Edit PO (DRAFT) | ✅ | ❌ | ✅ | ❌ | ❌ |
| Send PO to Vendor | ✅ | ❌ | ✅ | ❌ | ❌ |
| Cancel PO | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Receipt** |
| Create Receipt | ✅ | ❌ | ✅ | ❌ | ❌ |
| Post to Inventory | ✅ | ❌ | ✅ | ❌ | ❌ |
| Verify Receipt | ✅ | ✅ (Own dept) | ✅ | ❌ | ❌ |

---

## 📊 API Development Priority

### Phase 1: Purchase Request Workflow (Week 1-2) ⭐

**Critical path for procurement:**

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 1 | `/api/procurement/purchase-requests` | GET | List PRs by department/status |
| 2 | `/api/procurement/purchase-requests/:id` | GET | Get PR details with items |
| 3 | `/api/procurement/purchase-requests` | POST | Create new PR (Draft) |
| 4 | `/api/procurement/purchase-requests/:id/items` | POST | Add drugs to PR |
| 5 | `/api/procurement/purchase-requests/:id/submit` | POST | Submit for approval (reserves budget) |
| 6 | `/api/procurement/purchase-requests/:id/approve` | POST | Approve PR (dept/final) |
| 7 | `/api/procurement/purchase-requests/:id/reject` | POST | Reject PR (releases budget) |

**Budget Integration:**
- When PR submitted → Call `POST /api/budget/check-availability`
- If available → Call `POST /api/budget/reserve`
- If rejected → Call `POST /api/budget/reservations/:id/release`

---

### Phase 2: Purchase Order Workflow (Week 2-3)

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 8 | `/api/procurement/purchase-orders` | GET | List POs by status |
| 9 | `/api/procurement/purchase-orders/:id` | GET | Get PO details |
| 10 | `/api/procurement/purchase-orders` | POST | Create PO from approved PR |
| 11 | `/api/procurement/purchase-orders/:id/send` | POST | Send PO to vendor (commits budget) |
| 12 | `/api/procurement/purchase-orders/:id/cancel` | POST | Cancel PO |

**Budget Integration:**
- When PO sent → Call `POST /api/budget/commit`

---

### Phase 3: Goods Receipt (Week 3-4)

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 13 | `/api/procurement/receipts` | GET | List receipts |
| 14 | `/api/procurement/receipts/:id` | GET | Get receipt details |
| 15 | `/api/procurement/receipts` | POST | Create receipt from PO |
| 16 | `/api/procurement/receipts/:id/items` | POST | Add received items with lots |
| 17 | `/api/procurement/receipts/:id/post` | POST | Post to inventory (updates stock) |

**Inventory Integration:**
- When receipt posted → Updates `inventory` and `drug_lots` tables

---

## 🚨 Error Handling Standards

### Error Codes

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `PR_NOT_FOUND` | 404 | ไม่พบข้อมูล PR | PR ID doesn't exist |
| `PR_INVALID_STATUS` | 400 | สถานะ PR ไม่ถูกต้อง | Cannot perform action in current status |
| `PR_EMPTY_ITEMS` | 400 | PR ต้องมียาอย่างน้อย 1 รายการ | Submitting PR with no items |
| `BUDGET_NOT_AVAILABLE` | 400 | งบประมาณไม่เพียงพอ | Budget check failed |
| `BUDGET_NOT_RESERVED` | 400 | ไม่พบการจองงบประมาณ | PR has no budget reservation |
| `PO_NOT_FOUND` | 404 | ไม่พบข้อมูล PO | PO ID doesn't exist |
| `PO_INVALID_STATUS` | 400 | สถานะ PO ไม่ถูกต้อง | Cannot perform action in current status |
| `RECEIPT_NOT_FOUND` | 404 | ไม่พบข้อมูลใบรับ | Receipt ID doesn't exist |
| `RECEIPT_QTY_MISMATCH` | 400 | จำนวนรับไม่ตรงกับ PO | Received qty > ordered qty |
| `LOT_REQUIRED` | 400 | กรุณาระบุ Lot Number | Lot info required for receipt |

---

## 📝 Request/Response Examples

### 1. Create Purchase Request

**Endpoint:** `POST /api/procurement/purchase-requests`

**Request:**
```typescript
{
  department_id: 2,
  budget_id: 1,
  fiscal_year: 2025,
  request_date: "2025-04-15",
  urgency: "NORMAL",  // NORMAL, URGENT, EMERGENCY
  notes: "Regular monthly order",
  items: [
    {
      generic_id: 101,
      requested_quantity: 5000,
      estimated_unit_price: 2.50,
      notes: "Paracetamol 500mg"
    },
    {
      generic_id: 102,
      requested_quantity: 3000,
      estimated_unit_price: 3.00,
      notes: "Ibuprofen 400mg"
    }
  ]
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 123,
    pr_number: "PR-2025-04-001",
    department_id: 2,
    budget_id: 1,
    fiscal_year: 2025,
    status: "DRAFT",
    total_amount: 21500.00,
    request_date: "2025-04-15",
    created_at: "2025-04-15T09:00:00Z",

    department: {
      dept_name: "ห้องยา"
    },

    items: [
      {
        id: 1,
        generic_id: 101,
        requested_quantity: 5000,
        estimated_unit_price: 2.50,
        total_price: 12500.00,
        generic: {
          working_code: "0001001",
          generic_name: "Paracetamol 500mg TAB"
        }
      },
      {
        id: 2,
        generic_id: 102,
        requested_quantity: 3000,
        estimated_unit_price: 3.00,
        total_price: 9000.00,
        generic: {
          working_code: "0001002",
          generic_name: "Ibuprofen 400mg TAB"
        }
      }
    ]
  },
  message: "สร้าง PR สำเร็จ"
}
```

---

### 2. Submit PR for Approval (with Budget Check)

**Endpoint:** `POST /api/procurement/purchase-requests/:id/submit`

**Workflow:**
```typescript
async function submitPR(prId: number) {
  const pr = await prisma.purchaseRequest.findUnique({
    where: { id: prId },
    include: { items: true }
  });

  // Step 1: Check budget availability
  const budgetCheck = await fetch('/api/budget/check-availability', {
    method: 'POST',
    body: JSON.stringify({
      fiscal_year: pr.fiscal_year,
      budget_type_id: pr.budget_id,
      department_id: pr.department_id,
      amount: pr.total_amount,
      quarter: getCurrentQuarter()
    })
  });

  if (!budgetCheck.data.available) {
    throw new Error('BUDGET_NOT_AVAILABLE');
  }

  // Step 2: Reserve budget
  const reservation = await fetch('/api/budget/reserve', {
    method: 'POST',
    body: JSON.stringify({
      allocation_id: budgetCheck.data.allocation_id,
      pr_id: pr.id,
      amount: pr.total_amount,
      quarter: getCurrentQuarter()
    })
  });

  // Step 3: Update PR status
  await prisma.purchaseRequest.update({
    where: { id: prId },
    data: {
      status: 'SUBMITTED',
      reservation_id: reservation.data.reservation_id,
      submitted_at: new Date()
    }
  });

  return { success: true, message: 'ส่ง PR เพื่ออนุมัติสำเร็จ' };
}
```

---

### 3. Create PO from Approved PR

**Endpoint:** `POST /api/procurement/purchase-orders`

**Request:**
```typescript
{
  pr_id: 123,
  company_id: 5,  // Vendor
  po_date: "2025-04-20",
  delivery_date: "2025-05-10",
  payment_terms: "30 days",
  notes: "Deliver to main warehouse",

  items: [
    {
      pr_item_id: 1,
      drug_id: 201,  // Selected trade drug
      ordered_quantity: 5000,
      unit_price: 2.45,
      discount_percent: 2,
      vat_percent: 7
    },
    {
      pr_item_id: 2,
      drug_id: 302,
      ordered_quantity: 3000,
      unit_price: 2.95,
      discount_percent: 0,
      vat_percent: 7
    }
  ]
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 456,
    po_number: "PO-2025-04-010",
    pr_id: 123,
    company_id: 5,
    status: "DRAFT",
    po_date: "2025-04-20",
    total_before_discount: 21225.00,
    total_discount: 245.00,
    total_before_vat: 20980.00,
    vat_amount: 1468.60,
    total_amount: 22448.60,

    company: {
      company_name: "Johnson & Johnson"
    },

    items: [
      {
        id: 1,
        drug_id: 201,
        ordered_quantity: 5000,
        unit_price: 2.45,
        discount_amount: 245.00,
        subtotal: 12225.00,
        vat_amount: 855.75,
        total: 13080.75,

        drug: {
          drug_code: "PARA500TAB001",
          trade_name: "Tylenol 500mg"
        }
      }
    ]
  },
  message: "สร้าง PO สำเร็จ"
}
```

---

### 4. Send PO (Commit Budget)

**Endpoint:** `POST /api/procurement/purchase-orders/:id/send`

**Workflow:**
```typescript
async function sendPO(poId: number) {
  const po = await prisma.purchaseOrder.findUnique({
    where: { id: poId },
    include: {
      purchaseRequest: {
        include: { budgetReservation: true }
      }
    }
  });

  // Step 1: Commit budget
  await fetch('/api/budget/commit', {
    method: 'POST',
    body: JSON.stringify({
      allocation_id: po.purchaseRequest.budgetReservation.allocation_id,
      po_id: po.id,
      amount: po.total_amount,
      quarter: getCurrentQuarter()
    })
  });

  // Step 2: Update PO status
  await prisma.purchaseOrder.update({
    where: { id: poId },
    data: {
      status: 'SENT',
      sent_date: new Date()
    }
  });

  // Step 3: Send email/notification to vendor
  await sendVendorNotification(po);

  return { success: true, message: 'ส่ง PO ให้ผู้จำหน่ายสำเร็จ' };
}
```

---

### 5. Create Receipt

**Endpoint:** `POST /api/procurement/receipts`

**Request:**
```typescript
{
  po_id: 456,
  receipt_date: "2025-05-10",
  delivery_note_number: "DN-2025-05-100",
  received_by: 10,  // User ID
  location_id: 1,   // Receiving location

  items: [
    {
      po_item_id: 1,
      received_quantity: 5000,
      lot_number: "LOT2025050001",
      manufacture_date: "2024-12-01",
      expiry_date: "2027-12-01",
      unit_cost: 2.45
    },
    {
      po_item_id: 2,
      received_quantity: 3000,
      lot_number: "LOT2025050002",
      manufacture_date: "2024-11-15",
      expiry_date: "2027-11-15",
      unit_cost: 2.95
    }
  ]
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 789,
    receipt_number: "GR-2025-05-015",
    po_id: 456,
    receipt_date: "2025-05-10",
    status: "DRAFT",
    total_amount: 21100.00,

    items: [
      {
        id: 1,
        drug_id: 201,
        received_quantity: 5000,
        lot_number: "LOT2025050001",
        manufacture_date: "2024-12-01",
        expiry_date: "2027-12-01",
        unit_cost: 2.45,
        total_cost: 12250.00
      }
    ]
  },
  message: "สร้างใบรับสำเร็จ"
}
```

---

### 6. Post Receipt to Inventory

**Endpoint:** `POST /api/procurement/receipts/:id/post`

**Workflow:**
```typescript
async function postReceipt(receiptId: number) {
  const receipt = await prisma.receipt.findUnique({
    where: { id: receiptId },
    include: { items: true }
  });

  await prisma.$transaction(async (tx) => {
    // For each receipt item
    for (const item of receipt.items) {
      // 1. Create drug lot
      const lot = await tx.drugLot.create({
        data: {
          drug_id: item.drug_id,
          lot_number: item.lot_number,
          manufacture_date: item.manufacture_date,
          expiry_date: item.expiry_date,
          received_quantity: item.received_quantity,
          remaining_quantity: item.received_quantity,
          unit_cost: item.unit_cost,
          location_id: receipt.location_id
        }
      });

      // 2. Update inventory
      await tx.inventory.upsert({
        where: {
          drug_id_location_id: {
            drug_id: item.drug_id,
            location_id: receipt.location_id
          }
        },
        update: {
          quantity_in_stock: { increment: item.received_quantity }
        },
        create: {
          drug_id: item.drug_id,
          location_id: receipt.location_id,
          quantity_in_stock: item.received_quantity
        }
      });

      // 3. Create inventory transaction
      await tx.inventoryTransaction.create({
        data: {
          drug_id: item.drug_id,
          location_id: receipt.location_id,
          transaction_type: 'RECEIVE',
          quantity: item.received_quantity,
          lot_id: lot.id,
          reference_type: 'RECEIPT',
          reference_id: receipt.id,
          transaction_date: receipt.receipt_date
        }
      });
    }

    // 4. Update receipt status
    await tx.receipt.update({
      where: { id: receiptId },
      data: {
        status: 'POSTED',
        posted_at: new Date()
      }
    });
  });

  return { success: true, message: 'โพสต์ใบรับสู่คลังสำเร็จ' };
}
```

---

## ⚙️ Environment Configuration

```env
# Procurement Configuration
PROCUREMENT_PR_APPROVAL_LEVELS=2           # Number of approval levels (1-3)
PROCUREMENT_AUTO_CREATE_PO=false           # Auto-create PO when PR approved
PROCUREMENT_ALLOW_PARTIAL_RECEIPT=true     # Allow receiving partial quantities
PROCUREMENT_REQUIRE_LOT_INFO=true          # Require lot/expiry on receipt

# PO Configuration
PROCUREMENT_PO_NUMBER_PREFIX=PO            # PO number prefix
PROCUREMENT_PO_VALIDITY_DAYS=30            # PO validity period
PROCUREMENT_ALLOW_OVER_RECEIVE=false       # Allow receiving > ordered qty
PROCUREMENT_OVER_RECEIVE_PERCENT=10        # Max % to allow over-receiving

# Notifications
PROCUREMENT_NOTIFY_PR_APPROVAL=true        # Notify when PR needs approval
PROCUREMENT_NOTIFY_PO_SENT=true            # Notify vendor when PO sent
PROCUREMENT_NOTIFY_RECEIPT_READY=true      # Notify when goods arrive
```

---

## 🧪 Testing Guidelines

### Integration Test: Full Procurement Flow

```typescript
describe('Procurement Workflow: PR → PO → Receipt', () => {
  let prId, poId, receiptId;

  it('Step 1: Create PR', async () => {
    const response = await request(app)
      .post('/api/procurement/purchase-requests')
      .send({
        department_id: 2,
        budget_id: 1,
        items: [
          { generic_id: 101, requested_quantity: 1000, estimated_unit_price: 2.50 }
        ]
      });

    expect(response.status).toBe(200);
    prId = response.body.data.id;
  });

  it('Step 2: Submit PR (reserves budget)', async () => {
    const response = await request(app)
      .post(`/api/procurement/purchase-requests/${prId}/submit`);

    expect(response.status).toBe(200);
    expect(response.body.data.status).toBe('SUBMITTED');
    expect(response.body.data.reservation_id).toBeDefined();
  });

  it('Step 3: Approve PR', async () => {
    const response = await request(app)
      .post(`/api/procurement/purchase-requests/${prId}/approve`);

    expect(response.status).toBe(200);
    expect(response.body.data.status).toBe('APPROVED');
  });

  it('Step 4: Create PO from PR', async () => {
    const response = await request(app)
      .post('/api/procurement/purchase-orders')
      .send({
        pr_id: prId,
        company_id: 5,
        items: [
          { pr_item_id: 1, drug_id: 201, ordered_quantity: 1000, unit_price: 2.45 }
        ]
      });

    expect(response.status).toBe(200);
    poId = response.body.data.id;
  });

  it('Step 5: Send PO (commits budget)', async () => {
    const response = await request(app)
      .post(`/api/procurement/purchase-orders/${poId}/send`);

    expect(response.status).toBe(200);
    expect(response.body.data.status).toBe('SENT');
  });

  it('Step 6: Create Receipt', async () => {
    const response = await request(app)
      .post('/api/procurement/receipts')
      .send({
        po_id: poId,
        items: [
          {
            po_item_id: 1,
            received_quantity: 1000,
            lot_number: 'LOT001',
            expiry_date: '2027-12-31'
          }
        ]
      });

    expect(response.status).toBe(200);
    receiptId = response.body.data.id;
  });

  it('Step 7: Post Receipt (updates inventory)', async () => {
    const response = await request(app)
      .post(`/api/procurement/receipts/${receiptId}/post`);

    expect(response.status).toBe(200);

    // Verify inventory updated
    const inventory = await prisma.inventory.findFirst({
      where: { drug_id: 201, location_id: 1 }
    });
    expect(inventory.quantity_in_stock).toBeGreaterThanOrEqual(1000);
  });
});
```

---

**Last Updated:** 2025-01-28 | **Version:** 2.6.0
**Built with ❤️ for INVS Modern Team**
