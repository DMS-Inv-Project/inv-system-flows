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
