# 🚀 Drug Return System - API Development Guide

**System:** Drug Return
**Version:** 2.6.0
**Last Updated:** 2025-01-28
**Target Audience:** Backend Developers

---

## 📋 Overview

Drug return system handles returns from departments/patients and expired drug disposal:
- **Drug Returns** - Returns from wards/patients with reasons
- **Return Actions** - Disposal/return to stock/return to vendor
- **Inventory Updates** - Stock adjustments based on return action
- **Ministry Reporting** - DRUGDESTROY export for disposal

---

## 🔐 Authentication & Authorization

| Feature | Finance Manager | Dept Head | Pharmacist | Nurse | Other Staff |
|---------|----------------|-----------|------------|-------|-------------|
| Create Return | ✅ | ✅ | ✅ | ✅ | ❌ |
| Approve Return | ✅ | ❌ | ✅ | ❌ | ❌ |
| Process Return | ✅ | ❌ | ✅ | ❌ | ❌ |
| Destroy Drugs | ✅ | ❌ | ✅ | ❌ | ❌ |
| View Returns | ✅ All | ✅ Own dept | ✅ | ✅ Own dept | ❌ |

---

## 📊 API Development Priority

### Phase 1: Return Workflow (Week 1) ⭐

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 1 | `/api/drug-return/returns` | GET | List returns |
| 2 | `/api/drug-return/returns/:id` | GET | Get return details |
| 3 | `/api/drug-return/returns` | POST | Create return |
| 4 | `/api/drug-return/returns/:id/approve` | POST | Approve return |
| 5 | `/api/drug-return/returns/:id/process` | POST | Process (execute action) |

### Phase 2: Destruction & Reporting (Week 2)

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 6 | `/api/drug-return/destruction` | POST | Create destruction record |
| 7 | `/api/drug-return/ministry-export` | GET | DRUGDESTROY export |
| 8 | `/api/drug-return/actions` | GET | List available return actions |

---

## 🚨 Error Codes

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `RETURN_NOT_FOUND` | 404 | ไม่พบข้อมูลการคืนยา | Return ID doesn't exist |
| `INVALID_RETURN_ACTION` | 400 | การดำเนินการไม่ถูกต้อง | Invalid return_action_id |
| `ALREADY_PROCESSED` | 400 | ดำเนินการไปแล้ว | Return already processed |
| `INVALID_QUANTITY` | 400 | จำนวนไม่ถูกต้อง | Quantity <= 0 or > original qty |
| `LOT_MISMATCH` | 400 | Lot ไม่ตรงกับการจ่ายเดิม | Lot doesn't match original distribution |

---

## 📝 Request/Response Examples

### 1. Create Drug Return

**Endpoint:** `POST /api/drug-return/returns`

**Request:**
```typescript
{
  from_department_id: 5,  // ICU Ward
  to_location_id: 1,      // Central Pharmacy
  return_date: "2025-01-28",
  return_type: "WARD_RETURN",  // WARD_RETURN, PATIENT_RETURN, EXPIRED
  
  items: [
    {
      drug_id: 201,
      lot_id: 1,
      return_quantity: 50,
      return_reason: "EXPIRED",
      return_action_id: 3,  // DESTROY
      distribution_id: 123,  // Optional: original distribution
      notes: "Found expired during ward check"
    },
    {
      drug_id: 305,
      lot_id: 5,
      return_quantity: 100,
      return_reason: "EXCESS",
      return_action_id: 1,  // RETURN_TO_STOCK
      notes: "Ward overstocked"
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
    return_number: "RET-2025-01-050",
    from_department_id: 5,
    to_location_id: 1,
    return_type: "WARD_RETURN",
    status: "PENDING",
    return_date: "2025-01-28",
    
    from_department: {
      dept_name: "ICU Ward"
    },
    
    items: [
      {
        id: 1,
        drug_id: 201,
        lot_id: 1,
        return_quantity: 50,
        return_reason: "EXPIRED",
        return_action: {
          action_code: "DESTROY",
          action_name: "ทำลาย"
        },
        drug: {
          trade_name: "Tylenol 500mg"
        },
        lot: {
          lot_number: "LOT2024120001",
          expiry_date: "2025-01-15"  // Already expired
        }
      }
    ]
  },
  message: "สร้างรายการคืนยาสำเร็จ"
}
```

---

### 2. Process Return (Execute Action)

**Endpoint:** `POST /api/drug-return/returns/:id/process`

**Workflow:**
```typescript
async function processReturn(returnId: number) {
  const drugReturn = await prisma.drugReturn.findUnique({
    where: { id: returnId },
    include: { items: true }
  });
  
  await prisma.$transaction(async (tx) => {
    for (const item of drugReturn.items) {
      const action = await tx.returnAction.findUnique({
        where: { id: item.return_action_id }
      });
      
      switch (action.action_code) {
        case 'RETURN_TO_STOCK':
          // Add back to inventory
          await tx.inventory.update({
            where: {
              drug_id_location_id: {
                drug_id: item.drug_id,
                location_id: drugReturn.to_location_id
              }
            },
            data: {
              quantity_in_stock: { increment: item.return_quantity }
            }
          });
          
          // Update lot
          await tx.drugLot.update({
            where: { id: item.lot_id },
            data: {
              remaining_quantity: { increment: item.return_quantity }
            }
          });
          break;
          
        case 'DESTROY':
          // Create destruction record (for ministry reporting)
          await tx.drugDestruction.create({
            data: {
              drug_id: item.drug_id,
              lot_id: item.lot_id,
              quantity: item.return_quantity,
              destruction_date: new Date(),
              destruction_reason: item.return_reason,
              destruction_method: 'INCINERATION'
            }
          });
          break;
          
        case 'RETURN_TO_VENDOR':
          // Create vendor return record
          await tx.vendorReturn.create({
            data: {
              drug_id: item.drug_id,
              lot_id: item.lot_id,
              quantity: item.return_quantity,
              return_date: new Date()
            }
          });
          break;
      }
      
      // Create inventory transaction
      await tx.inventoryTransaction.create({
        data: {
          drug_id: item.drug_id,
          location_id: drugReturn.to_location_id,
          transaction_type: 'RETURN',
          quantity: item.return_quantity,
          lot_id: item.lot_id,
          reference_type: 'DRUG_RETURN',
          reference_id: drugReturn.id
        }
      });
    }
    
    // Update return status
    await tx.drugReturn.update({
      where: { id: returnId },
      data: {
        status: 'PROCESSED',
        processed_at: new Date()
      }
    });
  });
}
```

---

### 3. Ministry Export (DRUGDESTROY)

**Endpoint:** `GET /api/drug-return/ministry-export`

**Query Parameters:**
```typescript
{
  startDate: string,  // "2025-01-01"
  endDate: string,    // "2025-01-31"
  format: 'JSON' | 'CSV'  // Default: JSON
}
```

**Success Response:**
```typescript
{
  success: true,
  data: [
    {
      // 11 required fields for DRUGDESTROY export
      tmtid: "1234567",
      drugcode: "PARA500TAB001",
      drugname: "Tylenol 500mg",
      lotnumber: "LOT2024120001",
      expire: "2025-01-15",
      destroyqty: 50,
      unit: "TAB",
      destroydate: "2025-01-28",
      destroyreason: "EXPIRED",
      destroymethod: "INCINERATION",
      destroyby: "John Doe"
    }
  ],
  meta: {
    export_date: "2025-01-28T10:00:00Z",
    total_records: 15,
    total_destroyed_value: 12500.00
  }
}
```

---

## ⚙️ Environment Configuration

```env
# Return Configuration
RETURN_REQUIRE_APPROVAL=true               # Require approval before processing
RETURN_ALLOW_EXPIRED_RETURN_TO_STOCK=false # Prevent expired drugs from returning to stock
RETURN_REQUIRE_LOT_INFO=true               # Require lot number for returns
RETURN_DESTRUCTION_METHOD_DEFAULT=INCINERATION  # Default destruction method

# Ministry Reporting
RETURN_MINISTRY_EXPORT_SCHEDULE=monthly    # Auto-generate monthly reports
RETURN_NOTIFY_DESTRUCTION=true             # Notify on drug destruction
```

---

**Last Updated:** 2025-01-28 | **Version:** 2.6.0
**Built with ❤️ for INVS Modern Team**
