# 🚀 Inventory Management - API Development Guide

**System:** Inventory Management
**Version:** 2.6.0
**Last Updated:** 2025-01-28
**Target Audience:** Backend Developers

---

## 📋 Overview

Inventory system manages drug stock levels, lot tracking (FIFO/FEFO), and stock adjustments:
- **Inventory** - Stock levels per drug/location
- **Drug Lots** - FIFO/FEFO lot tracking with expiry dates
- **Stock Adjustments** - Manual adjustments with audit trail
- **Inventory Transactions** - Complete audit log of all movements

---

## 🔐 Authentication & Authorization

| Feature | Finance Manager | Dept Head | Pharmacist | Nurse | Other Staff |
|---------|----------------|-----------|------------|-------|-------------|
| View Stock Levels | ✅ All locations | ✅ Own locations | ✅ | ✅ | ❌ |
| View Lot Details | ✅ | ✅ | ✅ | ✅ | ❌ |
| Stock Adjustment | ✅ | ❌ | ✅ | ❌ | ❌ |
| Set Min/Max Levels | ✅ | ❌ | ✅ | ❌ | ❌ |
| View Transactions | ✅ All | ✅ Own dept | ✅ Own dept | ❌ | ❌ |
| Low Stock Alerts | ✅ | ✅ | ✅ | ❌ | ❌ |
| Expiry Alerts | ✅ | ✅ | ✅ | ✅ | ❌ |

---

## 📊 API Development Priority

### Phase 1: Stock Inquiry (Week 1) ⭐

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 1 | `/api/inventory/stock` | GET | List stock by location/drug |
| 2 | `/api/inventory/stock/:drugId/:locationId` | GET | Get specific stock level |
| 3 | `/api/inventory/lots` | GET | List active lots (FIFO order) |
| 4 | `/api/inventory/lots/expiring` | GET | Get expiring lots (< 6 months) |
| 5 | `/api/inventory/lots/:id` | GET | Get lot details |

### Phase 2: Stock Management (Week 2)

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 6 | `/api/inventory/adjustments` | POST | Create stock adjustment |
| 7 | `/api/inventory/adjustments` | GET | List adjustments history |
| 8 | `/api/inventory/min-max` | PUT | Update min/max levels |
| 9 | `/api/inventory/transfers` | POST | Transfer between locations |

### Phase 3: Reporting & Alerts (Week 3)

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 10 | `/api/inventory/low-stock` | GET | Get drugs below min level |
| 11 | `/api/inventory/transactions` | GET | View transaction history |
| 12 | `/api/inventory/valuation` | GET | Stock valuation report |

---

## 🚨 Error Codes

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `STOCK_NOT_FOUND` | 404 | ไม่พบข้อมูลสต็อก | Inventory record doesn't exist |
| `INSUFFICIENT_STOCK` | 400 | สต็อกไม่เพียงพอ | Cannot issue/transfer (qty > available) |
| `LOT_NOT_FOUND` | 404 | ไม่พบข้อมูล Lot | Lot ID doesn't exist |
| `LOT_EXPIRED` | 400 | Lot นี้หมดอายุแล้ว | Cannot use expired lot |
| `LOT_DEPLETED` | 400 | Lot นี้หมดแล้ว | Lot remaining_quantity = 0 |
| `INVALID_ADJUSTMENT_REASON` | 400 | เหตุผลการปรับสต็อกไม่ถูกต้อง | Invalid adjustment_reason_id |
| `NEGATIVE_STOCK` | 400 | สต็อกไม่สามารถติดลบได้ | Adjustment would result in negative stock |

---

## 📝 Request/Response Examples

### 1. Get Stock Levels

**Endpoint:** `GET /api/inventory/stock`

**Query Parameters:**
```typescript
{
  locationId?: number,
  drugId?: number,
  belowMin?: boolean,    // Filter drugs below min level
  search?: string,       // Search by drug name
  page?: number,
  limit?: number
}
```

**Success Response:**
```typescript
{
  success: true,
  data: [
    {
      drug_id: 201,
      location_id: 1,
      quantity_in_stock: 8500,
      min_level: 5000,
      max_level: 20000,
      reorder_point: 7000,
      reorder_quantity: 15000,
      last_updated: "2025-01-28T10:00:00Z",

      drug: {
        drug_code: "PARA500TAB001",
        trade_name: "Tylenol 500mg",
        unit_price: 2.50
      },

      location: {
        location_code: "WH001",
        location_name: "Main Warehouse"
      },

      // Stock status
      stock_status: "OK",  // OK, LOW, CRITICAL, OVERSTOCK
      days_of_supply: 42,  // Based on average usage
      stock_value: 21250.00
    }
  ],
  meta: {
    pagination: { page: 1, limit: 20, total: 1169 }
  }
}
```

---

### 2. Get FIFO Lots

**Endpoint:** `GET /api/inventory/lots`

**Query Parameters:**
```typescript
{
  drugId: number,
  locationId: number,
  orderBy?: 'FIFO' | 'FEFO',  // Default: FIFO
  includeExpired?: boolean      // Default: false
}
```

**Success Response:**
```typescript
{
  success: true,
  data: [
    {
      id: 1,
      drug_id: 201,
      location_id: 1,
      lot_number: "LOT2024120001",
      manufacture_date: "2024-06-01",
      expiry_date: "2027-06-01",
      received_quantity: 5000,
      remaining_quantity: 3200,
      unit_cost: 2.45,
      received_date: "2024-12-15",

      // Lot status
      is_expired: false,
      days_until_expiry: 854,
      expiry_status: "OK",  // OK, WARN (< 6 months), CRITICAL (< 3 months), EXPIRED

      // Usage info
      dispensed_quantity: 1800,
      utilization_percent: 36.0
    },
    {
      id: 2,
      lot_number: "LOT2025010001",
      remaining_quantity: 5000,
      expiry_date: "2028-01-01",
      days_until_expiry: 1003,
      expiry_status: "OK"
    }
  ]
}
```

---

### 3. Create Stock Adjustment

**Endpoint:** `POST /api/inventory/adjustments`

**Request:**
```typescript
{
  drug_id: 201,
  location_id: 1,
  adjustment_type: "ADD",  // ADD or SUBTRACT
  quantity: 100,
  adjustment_reason_id: 3,  // Lookup table: damaged, expired, found, lost, etc.
  lot_id: 1,  // Optional: specific lot
  notes: "Found during physical count",
  adjustment_date: "2025-01-28"
}
```

**Validation:**
```typescript
// Check if adjustment would cause negative stock
if (adjustment_type === 'SUBTRACT') {
  const currentStock = await prisma.inventory.findUnique({
    where: {
      drug_id_location_id: { drug_id, location_id }
    }
  });

  if (currentStock.quantity_in_stock < quantity) {
    throw new ValidationError('INSUFFICIENT_STOCK');
  }
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 456,
    drug_id: 201,
    location_id: 1,
    adjustment_type: "ADD",
    quantity: 100,
    previous_quantity: 8500,
    new_quantity: 8600,
    adjustment_reason_id: 3,
    adjustment_reason: {
      reason_code: "FOUND",
      reason_name: "พบเพิ่มจากการตรวจนับ"
    },
    notes: "Found during physical count",
    created_by: 10,
    created_at: "2025-01-28T10:30:00Z"
  },
  message: "ปรับปรุงสต็อกสำเร็จ"
}
```

---

### 4. Get Expiring Drugs

**Endpoint:** `GET /api/inventory/lots/expiring`

**Query Parameters:**
```typescript
{
  daysThreshold?: number,  // Default: 180 (6 months)
  locationId?: number,
  page?: number,
  limit?: number
}
```

**Success Response:**
```typescript
{
  success: true,
  data: [
    {
      lot_id: 5,
      drug_id: 305,
      location_id: 1,
      lot_number: "LOT2023060001",
      expiry_date: "2025-06-01",
      days_until_expiry: 124,
      remaining_quantity: 500,
      unit_cost: 15.00,
      total_value: 7500.00,

      drug: {
        drug_code: "AMX1000CAP001",
        trade_name: "Amoxicillin 1000mg"
      },

      location: {
        location_code: "PHAR001",
        location_name: "Central Pharmacy"
      },

      expiry_status: "CRITICAL",  // < 6 months
      recommendation: "ใช้หมุนเวียนก่อน Lot อื่น (FEFO)"
    }
  ],
  meta: {
    summary: {
      total_lots: 15,
      total_value: 125000.00,
      critical_lots: 5,  // < 3 months
      warning_lots: 10   // 3-6 months
    }
  }
}
```

---

### 5. Stock Transfer

**Endpoint:** `POST /api/inventory/transfers`

**Request:**
```typescript
{
  drug_id: 201,
  from_location_id: 1,    // Main Warehouse
  to_location_id: 2,      // Central Pharmacy
  quantity: 500,
  lot_id: 1,              // Optional: specific lot
  transfer_date: "2025-01-28",
  requested_by: 10,
  notes: "Regular replenishment"
}
```

**Validation:**
```typescript
// Check stock at source location
const sourceStock = await prisma.inventory.findUnique({
  where: {
    drug_id_location_id: {
      drug_id: drug_id,
      location_id: from_location_id
    }
  }
});

if (sourceStock.quantity_in_stock < quantity) {
  throw new ValidationError('INSUFFICIENT_STOCK');
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    transfer_id: 789,
    drug_id: 201,
    from_location_id: 1,
    to_location_id: 2,
    quantity: 500,
    transfer_date: "2025-01-28",

    // Transaction records created
    transactions: [
      {
        id: 1001,
        transaction_type: "TRANSFER_OUT",
        location_id: 1,
        quantity: -500,
        new_balance: 8000
      },
      {
        id: 1002,
        transaction_type: "TRANSFER_IN",
        location_id: 2,
        quantity: 500,
        new_balance: 3500
      }
    ]
  },
  message: "โอนย้ายสต็อกสำเร็จ"
}
```

---

### 6. Get Low Stock Items

**Endpoint:** `GET /api/inventory/low-stock`

**Query Parameters:**
```typescript
{
  locationId?: number,
  urgency?: 'LOW' | 'CRITICAL',  // LOW = below reorder point, CRITICAL = below min level
  page?: number,
  limit?: number
}
```

**Success Response:**
```typescript
{
  success: true,
  data: [
    {
      drug_id: 405,
      location_id: 2,
      current_stock: 450,
      min_level: 500,
      reorder_point: 700,
      reorder_quantity: 2000,
      urgency: "CRITICAL",

      drug: {
        drug_code: "IBU400TAB001",
        trade_name: "Ibuprofen 400mg",
        unit_price: 3.00
      },

      location: {
        location_name: "Central Pharmacy"
      },

      // Stock analysis
      days_of_supply: 5,
      average_daily_usage: 90,
      suggested_order_quantity: 2000,
      last_received_date: "2024-12-15",
      days_since_last_received: 44
    }
  ],
  meta: {
    summary: {
      critical_items: 5,   // Below min level
      low_items: 12,       // Below reorder point
      total_value_needed: 85000.00
    }
  }
}
```

---

## ⚙️ Environment Configuration

```env
# Inventory Configuration
INVENTORY_ALLOW_NEGATIVE_STOCK=false       # Prevent negative stock
INVENTORY_EXPIRY_WARNING_DAYS=180          # Warn when < 6 months to expiry
INVENTORY_EXPIRY_CRITICAL_DAYS=90          # Critical when < 3 months
INVENTORY_AUTO_REORDER=false                # Auto-create PR when below reorder point

# FIFO/FEFO Configuration
INVENTORY_DEFAULT_DISPENSING_METHOD=FEFO   # FIFO or FEFO
INVENTORY_ALLOW_SKIP_LOTS=false            # Allow using newer lots before older

# Stock Adjustment
INVENTORY_REQUIRE_APPROVAL_ADJUSTMENT=true # Adjustments need approval
INVENTORY_MAX_ADJUSTMENT_PERCENT=20        # Max % adjustment without approval

# Notifications
INVENTORY_NOTIFY_LOW_STOCK=true            # Alert on low stock
INVENTORY_NOTIFY_EXPIRING_DRUGS=true       # Alert on expiring drugs
INVENTORY_NOTIFY_EXPIRED_DRUGS=true        # Alert on expired drugs
INVENTORY_EXPIRY_CHECK_SCHEDULE=daily      # Daily/weekly expiry check
```

---

## 🧪 Testing Guidelines

### Test FIFO/FEFO Logic

```typescript
describe('FIFO/FEFO Lot Selection', () => {
  let drug, location, lot1, lot2, lot3;

  beforeAll(async () => {
    drug = await createTestDrug();
    location = await createTestLocation();

    // Create 3 lots with different dates
    lot1 = await prisma.drugLot.create({
      data: {
        drug_id: drug.id,
        location_id: location.id,
        lot_number: 'LOT001',
        received_date: '2024-01-01',
        expiry_date: '2027-01-01',
        remaining_quantity: 1000
      }
    });

    lot2 = await prisma.drugLot.create({
      data: {
        drug_id: drug.id,
        location_id: location.id,
        lot_number: 'LOT002',
        received_date: '2024-06-01',
        expiry_date: '2026-06-01',  // Expires earlier
        remaining_quantity: 1000
      }
    });

    lot3 = await prisma.drugLot.create({
      data: {
        drug_id: drug.id,
        location_id: location.id,
        lot_number: 'LOT003',
        received_date: '2025-01-01',
        expiry_date: '2028-01-01',
        remaining_quantity: 1000
      }
    });
  });

  it('should return lots in FIFO order (oldest first)', async () => {
    const response = await request(app)
      .get(`/api/inventory/lots?drugId=${drug.id}&locationId=${location.id}&orderBy=FIFO`);

    expect(response.body.data[0].lot_number).toBe('LOT001');  // Oldest received
    expect(response.body.data[1].lot_number).toBe('LOT002');
    expect(response.body.data[2].lot_number).toBe('LOT003');
  });

  it('should return lots in FEFO order (earliest expiry first)', async () => {
    const response = await request(app)
      .get(`/api/inventory/lots?drugId=${drug.id}&locationId=${location.id}&orderBy=FEFO`);

    expect(response.body.data[0].lot_number).toBe('LOT002');  // Expires earliest
    expect(response.body.data[1].lot_number).toBe('LOT001');
    expect(response.body.data[2].lot_number).toBe('LOT003');
  });
});
```

---

**Last Updated:** 2025-01-28 | **Version:** 2.6.0
**Built with ❤️ for INVS Modern Team**
