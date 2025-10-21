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
