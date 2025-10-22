# 📦 Inventory - UI Mockups & User Flow

**Inventory Management System - User Interface Mockups**

**Version:** 2.4.0
**Last Updated:** 2025-01-22

---

## 📋 Overview

เอกสารนี้แสดง UI mockups สำหรับ Inventory Management:

1. **Stock View** - ดูสต๊อกแบบ real-time
2. **Lot Management** - จัดการล็อตยา (FIFO/FEFO)
3. **Stock Adjustment** - ปรับสต๊อก

---

## 🔄 Flow 1: Stock View Dashboard

### 📱 Screen: Current Stock

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - Inventory Management                                           │
├──────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  Current Stock - Central Pharmacy                           Location: [All ▼]   │
│                                                                                  │
│  Quick Stats:                                                                    │
│  📦 Total Items: 1,248 | ⚠️ Low Stock: 45 | 🔴 Expired: 2 | ⏰ Near Expiry: 18  │
│                                                                                  │
│  Filter: [All ▼]  Status: [Active ▼]  Search: [_______] 🔍                      │
│                                                                                  │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │ Drug           │ Location  │ Stock │ Min │ Status        │ Oldest Exp │ │ │ │
│  ├────────────────────────────────────────────────────────────────────────────┤ │
│  │ Paracetamol    │ Pharmacy  │15,000 │5,000│ ✓ Sufficient  │ 2026-03    │ │ │
│  │ Amoxicillin    │ Pharmacy  │ 3,000 │3,500│ ⚠️ Low Stock   │ 2025-06    │ │ │
│  │ Ibuprofen      │ Pharmacy  │ 8,500 │2,000│ ✓ Sufficient  │ 2027-01    │ │ │
│  │ Aspirin        │ Emergency │   200 │  500│ 🔴 Reorder    │ 2025-03    │ │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                                                                  │
│  [View Lots] [Adjust Stock] [Export Report]                                     │
└──────────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User views real-time stock levels
2. System highlights low stock and near expiry
3. User clicks **[View Lots]** to see lot details

---

## 🔄 Flow 2: Lot Management (FIFO/FEFO)

### 📱 Screen: Drug Lots

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Drug Lots - Paracetamol 500mg                                     [X]       │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Location: Central Pharmacy | Total Stock: 15,000 tablets                    │
│                                                                              │
│  Lot List (FEFO Order - First Expire First Out):                             │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Lot Number │ Qty    │ Unit Cost│ Expiry Date│ Days Left│ FIFO│ FEFO │ │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ LOT2024A   │ 2,000  │ ฿2.50    │ 2026-03-15 │ 418 days │ 3rd │ 1st  │ │ │
│  │ LOT2024B   │ 3,000  │ ฿2.45    │ 2026-08-20 │ 576 days │ 2nd │ 2nd  │ │ │
│  │ LOT2025A   │ 10,000 │ ฿2.40    │ 2027-01-10 │ 719 days │ 1st │ 3rd  │ │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Dispensing Order:                                                           │
│  ● FEFO (Recommended) - Expire first    ○ FIFO - Oldest first               │
│                                                                              │
│  Next to Dispense (FEFO): LOT2024A (Expires in 418 days)                    │
│                                                                              │
│                                                [Close]                       │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User views all lots for specific drug
2. System shows FIFO and FEFO order
3. System recommends next lot to dispense (FEFO)

---

## 🔄 Flow 3: Stock Adjustment

### 📱 Screen: Adjust Stock

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Stock Adjustment                                                  [X]       │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Drug: [Paracetamol 500mg ▼]     Location: [Central Pharmacy ▼]             │
│  Current Stock: 15,000 tablets                                               │
│                                                                              │
│  Adjustment Type: *                                                          │
│  ○ Add (Increase)    ● Subtract (Decrease)    ○ Set to Specific Amount      │
│                                                                              │
│  Quantity to Adjust: *                                                       │
│  [-500] tablets (Subtract 500)                                               │
│                                                                              │
│  Result: 15,000 - 500 = 14,500 tablets                                       │
│                                                                              │
│  Reason: *                                                                   │
│  [Damaged/Expired ▼]                                                         │
│                                                                              │
│  Lot Number: *                                                               │
│  [LOT2024A ▼] (Expiry: 2026-03-15, Available: 2,000)                         │
│                                                                              │
│  Notes:                                                                      │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Damaged during transport - 500 tablets broken                         │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ⚠️ This adjustment will create inventory transaction record.               │
│                                                                              │
│                                        [Cancel]  [Post Adjustment]           │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User selects drug and location
2. User selects adjustment type (Add/Subtract/Set)
3. User enters quantity and reason
4. User selects lot number
5. User clicks **[Post Adjustment]**
6. System creates inventory_transaction record

---

## 📊 Summary

- **Stock View:** Real-time, color-coded alerts (low/expired/near expiry)
- **Lot Management:** FIFO/FEFO tracking with expiry monitoring
- **Adjustments:** Full audit trail with reason codes

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.4.0
