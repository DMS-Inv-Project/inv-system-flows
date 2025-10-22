# 🏥 Distribution - UI Mockups & User Flow

**Drug Distribution System - User Interface Mockups**

**Version:** 2.4.0
**Last Updated:** 2025-01-22

---

## 📋 Overview

เอกสารนี้แสดง UI mockups สำหรับ Drug Distribution:

1. **Create Distribution** - สร้างใบเบิกยา
2. **Issue Drugs** - จ่ายยาตาม FIFO/FEFO

---

## 🔄 Flow 1: Create Distribution Request

### 📱 Screen: Create Distribution

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Create Drug Distribution Request                                 [X]       │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Distribution Information                                                    │
│                                                                              │
│  From Location: *           To Department: *                                 │
│  [Central Pharmacy ▼]       [ICU Ward ▼]                                     │
│                                                                              │
│  Distribution Date: [2025-01-22] 📅    Request By: [Dr. Smith ▼]            │
│                                                                              │
│  Items:                                                   [+ Add Item]       │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Drug           │ Requested Qty │ Available │ Allocated │ Status      │ │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ Paracetamol    │ 1,000 tabs    │ 15,000    │ 1,000     │ ✓ Available │ │ │
│  │ Amoxicillin    │ 500 caps      │ 3,000     │ 500       │ ✓ Available │ │ │
│  │ Morphine 10mg  │ 50 amps       │ 50        │ 50        │ ⚠️ Limited  │ │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Notes:                                                                      │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Weekly stock replenishment for ICU                                    │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  [Cancel]                         [Save Draft]  [Submit Distribution]       │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User selects from/to locations
2. User adds items
3. System checks availability
4. User clicks **[Submit Distribution]**

---

## 🔄 Flow 2: Issue Drugs (Pick & Pack)

### 📱 Screen: Issue Drugs

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Issue Drugs - DIST-2025-089                                       [X]       │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Distribution: To ICU Ward | Date: 2025-01-22                                │
│                                                                              │
│  Pick List (FEFO Order):                                                     │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Drug        │ Qty Needed│ Pick From Lot│ Qty   │ Expiry    │ ☑ Picked │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ Paracetamol │ 1,000     │ LOT2024A     │ 1,000 │ 2026-03   │ [  ]     │ │
│  │ Amoxicillin │ 500       │ LOT2024B     │ 500   │ 2025-06   │ [  ]     │ │
│  │ Morphine    │ 50        │ LOT2025A     │ 50    │ 2027-01   │ [  ]     │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Issued By: [Select Pharmacist ▼]                                           │
│                                                                              │
│  Received By: [_____________] (Ward Staff Name)                              │
│  Received Date: [2025-01-22] 📅  Time: [14:30]                              │
│                                                                              │
│  ☑ All items checked    ☑ Quantities verified    ☑ Expiry dates checked     │
│                                                                              │
│                                         [Cancel]  [Complete Distribution]    │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. System shows pick list in FEFO order
2. Pharmacist picks items and checks boxes
3. Ward staff receives and signs
4. Pharmacist clicks **[Complete Distribution]**
5. System updates inventory (deduct from pharmacy, add to ward)

---

## 📊 Summary

- **Distribution Request:** Department-to-department transfers
- **FEFO Logic:** Auto-select lots that expire first
- **Two-way Verification:** Issued by + Received by

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.4.0
