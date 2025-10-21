#!/bin/bash

# Function to create procurement schema
create_procurement_schema() {
cat > 03-procurement/01-SCHEMA.md << 'EOF'
# Database Schema - Procurement System

## Tables Overview (12 tables)

### Contracts (2 tables)
- `contracts` - สัญญาจัดซื้อ
- `contract_items` - รายการในสัญญา

### Purchase Requests (2 tables)
- `purchase_requests` - ใบขอซื้อ
- `purchase_request_items` - รายการในใบขอซื้อ

### Purchase Orders (2 tables)
- `purchase_orders` - ใบสั่งซื้อ
- `purchase_order_items` - รายการในใบสั่งซื้อ

### Receipts (3 tables)
- `receipts` - การรับของ
- `receipt_items` - รายการรับ
- `receipt_inspectors` - กรรมการตรวจรับ

### Approvals & Payments (3 tables)
- `approval_documents` - ใบขออนุมัติ
- `payment_documents` - เอกสารการเงิน
- `payment_attachments` - ไฟล์แนบ

## Key Enums (8 enums)

```prisma
enum ContractType {
  E_BIDDING, PRICE_AGREEMENT, QUOTATION, SPECIAL
}

enum ContractStatus {
  DRAFT, ACTIVE, EXPIRED, CANCELLED
}

enum RequestStatus {
  DRAFT, SUBMITTED, APPROVED, REJECTED, CONVERTED
}

enum PoStatus {
  DRAFT, PENDING, APPROVED, SENT, RECEIVED, CLOSED
}

enum ReceiptStatus {
  DRAFT, RECEIVED, PENDING_VERIFICATION, VERIFIED, POSTED
}

enum InspectorRole {
  CHAIRMAN, MEMBER, SECRETARY
}

enum ApprovalType {
  NORMAL, URGENT, SPECIAL
}

enum PaymentStatus {
  PENDING, SUBMITTED, APPROVED, PAID, CANCELLED
}
```

See `prisma/schema.prisma` for complete definitions.
EOF
}

# Function to create procurement flow
create_procurement_flow() {
cat > 03-procurement/02-FLOW.md << 'EOF'
# Workflow Diagrams - Procurement System

## Complete Procurement Flow

```mermaid
graph TD
    A[Contract] -->|ราคาอ้างอิง| B[Purchase Request]
    B -->|Submit| C{Budget OK?}
    C -->|Yes| D[Approve PR]
    C -->|No| E[Reject]
    D --> F[Create PO]
    F -->|Send| G[Vendor]
    G -->|Deliver| H[Receive Goods]
    H -->|Inspect| I[Committee Sign]
    I --> J[Post to Inventory]
    J --> K[Create Payment Doc]
    K --> L[Pay Vendor]
```

## Status Transitions

### Purchase Request
```
DRAFT → SUBMITTED → APPROVED → CONVERTED (to PO)
              ↓
          REJECTED
```

### Purchase Order
```
DRAFT → PENDING → APPROVED → SENT → RECEIVED → CLOSED
```

### Receipt
```
DRAFT → RECEIVED → PENDING_VERIFICATION → VERIFIED → POSTED
```

### Payment
```
PENDING → SUBMITTED → APPROVED → PAID
                 ↓
            CANCELLED
```
EOF
}

# Function to create procurement API
create_procurement_api() {
cat > 03-procurement/03-API.md << 'EOF'
# API Endpoints - Procurement System

## Contracts

```
GET    /api/procurement/contracts
POST   /api/procurement/contracts
GET    /api/procurement/contracts/:id
PUT    /api/procurement/contracts/:id
DELETE /api/procurement/contracts/:id

GET    /api/procurement/contracts/:id/items
GET    /api/procurement/contracts/:id/remaining-value
```

## Purchase Requests

```
GET    /api/procurement/purchase-requests
POST   /api/procurement/purchase-requests
GET    /api/procurement/purchase-requests/:id
PUT    /api/procurement/purchase-requests/:id

POST   /api/procurement/purchase-requests/:id/submit
POST   /api/procurement/purchase-requests/:id/approve
POST   /api/procurement/purchase-requests/:id/reject
POST   /api/procurement/purchase-requests/:id/convert-to-po
```

## Purchase Orders

```
GET    /api/procurement/purchase-orders
POST   /api/procurement/purchase-orders
GET    /api/procurement/purchase-orders/:id
PUT    /api/procurement/purchase-orders/:id

POST   /api/procurement/purchase-orders/:id/send-to-vendor
POST   /api/procurement/purchase-orders/:id/cancel
```

## Receipts

```
GET    /api/procurement/receipts
POST   /api/procurement/receipts
GET    /api/procurement/receipts/:id
PUT    /api/procurement/receipts/:id

POST   /api/procurement/receipts/:id/add-inspector
POST   /api/procurement/receipts/:id/verify
POST   /api/procurement/receipts/:id/post-to-inventory
```

## Payments

```
GET    /api/procurement/payments
POST   /api/procurement/payments
GET    /api/procurement/payments/:id

POST   /api/procurement/payments/:id/submit
POST   /api/procurement/payments/:id/approve
POST   /api/procurement/payments/:id/mark-paid
```
EOF
}

# Function to create procurement business logic
create_procurement_business() {
cat > 03-procurement/04-BUSINESS-LOGIC.md << 'EOF'
# Business Logic - Procurement System

## Key Business Rules

### Contracts
- Contract must have start date < end date
- Remaining value cannot be negative
- Cannot delete contract with active POs

### Purchase Requests
- Must check budget before approval
- Cannot approve if budget insufficient
- Can only convert approved PR to PO
- Items must have valid drug_id

### Purchase Orders
- Must reference approved PR or valid contract
- Cannot modify after sent to vendor
- Total amount must match sum of items

### Receipts
- Must have at least 3 inspectors (chairman, members, secretary)
- Lot number and expiry date required for drugs
- remaining_quantity for emergency dispensing
- billing_date separate from invoice_date

### Payments
- Must reference verified receipt
- Cannot pay before approval
- Track all document attachments

## Validation Rules

```typescript
// PR Budget Check
if (pr.totalAmount > availableBudget) {
  throw new Error('Budget insufficient');
}

// Receipt Inspector Count
if (receipt.inspectors.length < 3) {
  throw new Error('At least 3 inspectors required');
}

// PO Contract Check
if (po.contractId) {
  const contract = await getContract(po.contractId);
  if (contract.remainingValue < po.totalAmount) {
    throw new Error('Contract value exceeded');
  }
}
```
EOF
}

# Function to create procurement examples
create_procurement_examples() {
cat > 03-procurement/05-EXAMPLES.md << 'EOF'
# Code Examples - Procurement System

## Create Purchase Request

```typescript
const pr = await prisma.purchaseRequest.create({
  data: {
    requestNumber: 'PR-2025-001',
    departmentId: 1,
    requestDate: new Date(),
    urgency: 'NORMAL',
    status: 'DRAFT',
    items: {
      create: [
        {
          drugId: 100,
          quantityRequested: 1000,
          estimatedUnitCost: 2.50,
          budgetYear: 2025
        }
      ]
    }
  },
  include: { items: true }
});
```

## Approve PR with Budget Check

```typescript
// Check budget
const budgetCheck = await prisma.$queryRaw`
  SELECT * FROM check_budget_availability(
    ${fiscalYear},
    ${budgetTypeId},
    ${departmentId},
    ${amount},
    ${quarter}
  );
`;

if (budgetCheck.available) {
  // Reserve budget
  await prisma.$queryRaw`
    SELECT * FROM reserve_budget(
      ${allocationId},
      ${prId},
      ${amount},
      7  -- expires in 7 days
    );
  `;

  // Approve PR
  await prisma.purchaseRequest.update({
    where: { id: prId },
    data: { status: 'APPROVED' }
  });
}
```

## Create Receipt with Inspectors

```typescript
const receipt = await prisma.receipt.create({
  data: {
    receiptNumber: 'RCV-2025-001',
    poId: poId,
    receivedDate: new Date(),
    status: 'RECEIVED',
    inspectors: {
      create: [
        {
          inspectorName: 'นายประธาน',
          inspectorRole: 'CHAIRMAN'
        },
        {
          inspectorName: 'นายกรรมการ 1',
          inspectorRole: 'MEMBER'
        },
        {
          inspectorName: 'นางเลขา',
          inspectorRole: 'SECRETARY'
        }
      ]
    },
    items: {
      create: [
        {
          drugId: 100,
          quantityReceived: 1000,
          remainingQuantity: 980, // 20 dispensed
          lotNumber: 'LOT2025001',
          expiryDate: new Date('2027-12-31'),
          unitCost: 2.45
        }
      ]
    }
  },
  include: {
    inspectors: true,
    items: true
  }
});
```
EOF
}

# Execute all creation functions for Procurement
create_procurement_schema
create_procurement_flow
create_procurement_api
create_procurement_business
create_procurement_examples

# Create Inventory System
cat > 04-inventory/README.md << 'EOF'
# 📦 Inventory Management System

**Priority**: ⭐⭐⭐ High | **Tables**: 7 | **Time**: 2 weeks

## 📚 Documentation

- [01-SCHEMA.md](01-SCHEMA.md) - Database tables
- [02-FLOW.md](02-FLOW.md) - FIFO/FEFO workflows
- [03-API.md](03-API.md) - API endpoints
- [04-BUSINESS-LOGIC.md](04-BUSINESS-LOGIC.md) - Lot management
- [05-EXAMPLES.md](05-EXAMPLES.md) - Code samples

## Key Features

- FIFO/FEFO lot tracking
- Multi-location inventory
- Expiry date management
- Distribution to departments
- Drug returns

**Related**: [Procurement](../03-procurement/README.md), [Drug Return](../05-drug-return/README.md)
EOF

# Create supporting systems
for system in 05-drug-return 06-tmt-integration 07-hpp-system 08-his-integration; do
  system_name=$(echo $system | cut -d'-' -f2-)
  cat > $system/README.md << EOF2
# $(echo $system_name | tr '-' ' ' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1') System

**Tables**: See SCHEMA.md | **Priority**: ⭐⭐ Medium

## Documentation

- [SCHEMA.md](SCHEMA.md) - Database structure
- [API.md](API.md) - API endpoints

## Quick Info

See individual files for details.
EOF2
done

echo "✅ Documentation created successfully!"
