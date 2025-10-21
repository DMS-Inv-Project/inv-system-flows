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
