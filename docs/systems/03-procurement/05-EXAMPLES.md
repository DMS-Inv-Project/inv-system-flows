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
