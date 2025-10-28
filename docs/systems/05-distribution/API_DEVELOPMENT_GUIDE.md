# 🚀 Drug Distribution - API Development Guide

**System:** Drug Distribution
**Version:** 2.6.0
**Last Updated:** 2025-01-28
**Target Audience:** Backend Developers

---

## 📋 Overview

Distribution system manages drug dispensing to departments/wards:
- **Distribution Requests** - Ward/OPD requests for drugs
- **Distribution Items** - Individual drug items with lot tracking
- **FIFO/FEFO Dispensing** - Automatic lot selection
- **Inventory Deduction** - Auto-update stock on distribution

---

## 🔐 Authentication & Authorization

| Feature | Finance Manager | Dept Head | Pharmacist | Nurse | Other Staff |
|---------|----------------|-----------|------------|-------|-------------|
| Create Distribution | ✅ | ✅ (To own dept) | ✅ | ✅ (To own dept) | ❌ |
| Approve Distribution | ✅ | ❌ | ✅ | ❌ | ❌ |
| Post Distribution | ✅ | ❌ | ✅ | ❌ | ❌ |
| View Own Dept | ✅ All | ✅ Own | ✅ All | ✅ Own | ❌ |
| Cancel Distribution | ✅ | ❌ | ✅ | ❌ | ❌ |

---

## 📊 API Development Priority

### Phase 1: Distribution Request (Week 1) ⭐

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 1 | `/api/distribution/requests` | GET | List distribution requests |
| 2 | `/api/distribution/requests/:id` | GET | Get request details |
| 3 | `/api/distribution/requests` | POST | Create distribution request |
| 4 | `/api/distribution/requests/:id/items` | POST | Add drugs to request |
| 5 | `/api/distribution/requests/:id/approve` | POST | Approve request |
| 6 | `/api/distribution/requests/:id/post` | POST | Post (updates inventory) |

### Phase 2: FIFO/FEFO Integration (Week 2)

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 7 | `/api/distribution/lots/suggest` | GET | Suggest lots (FIFO/FEFO) |
| 8 | `/api/distribution/requests/:id/cancel` | POST | Cancel distribution |

---

## 🚨 Error Codes

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `DISTRIBUTION_NOT_FOUND` | 404 | ไม่พบข้อมูลการจ่าย | Distribution ID doesn't exist |
| `INSUFFICIENT_STOCK` | 400 | สต็อกไม่เพียงพอสำหรับการจ่าย | Stock < requested qty |
| `NO_LOTS_AVAILABLE` | 400 | ไม่มี Lot ที่พร้อมจ่าย | All lots expired/depleted |
| `INVALID_STATUS` | 400 | สถานะไม่ถูกต้อง | Cannot perform action in current status |
| `ALREADY_POSTED` | 400 | จ่ายยาไปแล้ว | Distribution already posted |

---

## 📝 Request/Response Examples

### 1. Create Distribution Request

**Endpoint:** `POST /api/distribution/requests`

**Request:**
```typescript
{
  from_location_id: 1,    // Pharmacy
  to_department_id: 5,    // ICU Ward
  distribution_date: "2025-01-28",
  requested_by: 10,
  notes: "Emergency order",

  items: [
    {
      drug_id: 201,
      requested_quantity: 500,
      urgency: "NORMAL"  // NORMAL, URGENT, EMERGENCY
    },
    {
      drug_id: 305,
      requested_quantity: 200,
      urgency: "URGENT"
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
    distribution_number: "DIST-2025-01-100",
    from_location_id: 1,
    to_department_id: 5,
    status: "PENDING",
    distribution_date: "2025-01-28",
    
    from_location: {
      location_name: "Central Pharmacy"
    },
    
    to_department: {
      dept_name: "ICU Ward"
    },
    
    items: [
      {
        id: 1,
        drug_id: 201,
        requested_quantity: 500,
        available_stock: 8500,
        drug: {
          trade_name: "Tylenol 500mg"
        }
      }
    ]
  },
  message: "สร้างรายการจ่ายสำเร็จ"
}
```

---

### 2. Suggest Lots (FIFO/FEFO)

**Endpoint:** `GET /api/distribution/lots/suggest`

**Query Parameters:**
```typescript
{
  drugId: number,
  locationId: number,
  quantity: number,
  method: 'FIFO' | 'FEFO'  // Default: FEFO
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    drug_id: 201,
    location_id: 1,
    requested_quantity: 500,
    method: "FEFO",
    
    suggested_lots: [
      {
        lot_id: 2,
        lot_number: "LOT2025010001",
        expiry_date: "2026-06-01",
        available_quantity: 300,
        dispense_quantity: 300,  // Take all 300 from this lot
        days_until_expiry: 489
      },
      {
        lot_id: 1,
        lot_number: "LOT2024120001",
        expiry_date: "2027-06-01",
        available_quantity: 3200,
        dispense_quantity: 200,  // Take remaining 200 from this lot
        days_until_expiry: 854
      }
    ],
    
    total_dispensed: 500,
    lots_used: 2
  }
}
```

---

### 3. Post Distribution (Update Inventory)

**Endpoint:** `POST /api/distribution/requests/:id/post`

**Workflow:**
```typescript
async function postDistribution(distributionId: number) {
  const dist = await prisma.drugDistribution.findUnique({
    where: { id: distributionId },
    include: { items: true }
  });
  
  await prisma.$transaction(async (tx) => {
    for (const item of dist.items) {
      // Get FEFO lots
      const lots = await getFEFOLots(item.drug_id, dist.from_location_id, item.requested_quantity);
      
      for (const lot of lots) {
        // Deduct from lot
        await tx.drugLot.update({
          where: { id: lot.lot_id },
          data: {
            remaining_quantity: { decrement: lot.dispense_quantity }
          }
        });
        
        // Create transaction
        await tx.inventoryTransaction.create({
          data: {
            drug_id: item.drug_id,
            location_id: dist.from_location_id,
            transaction_type: 'ISSUE',
            quantity: -lot.dispense_quantity,
            lot_id: lot.lot_id,
            reference_type: 'DISTRIBUTION',
            reference_id: dist.id
          }
        });
      }
      
      // Update inventory
      await tx.inventory.update({
        where: {
          drug_id_location_id: {
            drug_id: item.drug_id,
            location_id: dist.from_location_id
          }
        },
        data: {
          quantity_in_stock: { decrement: item.requested_quantity }
        }
      });
    }
    
    // Update distribution status
    await tx.drugDistribution.update({
      where: { id: distributionId },
      data: {
        status: 'COMPLETED',
        posted_at: new Date()
      }
    });
  });
}
```

---

## ⚙️ Environment Configuration

```env
# Distribution Configuration
DISTRIBUTION_DEFAULT_METHOD=FEFO           # FIFO or FEFO
DISTRIBUTION_ALLOW_PARTIAL=true            # Allow partial distribution if insufficient stock
DISTRIBUTION_REQUIRE_APPROVAL=true         # Require approval before posting
DISTRIBUTION_AUTO_DEDUCT_INVENTORY=true    # Auto-update inventory when posted

# Notifications
DISTRIBUTION_NOTIFY_REQUEST=true           # Notify pharmacist on new request
DISTRIBUTION_NOTIFY_URGENT=true            # Alert on urgent/emergency requests
DISTRIBUTION_NOTIFY_COMPLETED=true         # Notify requestor when completed
```

---

**Last Updated:** 2025-01-28 | **Version:** 2.6.0
**Built with ❤️ for INVS Modern Team**
