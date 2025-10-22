# 🔄 Drug Return - UI Mockups & User Flow

**Drug Return System - User Interface Mockups**

**Version:** 2.2.0
**Last Updated:** 2025-01-22

---

## 📋 Overview

เอกสารนี้แสดง UI mockups สำหรับ Drug Return (คืนยาจากแผนก → คลังกลาง):

1. **Create Return** - สร้างใบคืนยา
2. **Process Return** - ตรวจสอบและรับคืน

---

## 🔄 Flow 1: Create Drug Return

### 📱 Screen: Create Return

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Create Drug Return                                                [X]       │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Return Information                                                          │
│                                                                              │
│  From Department: *         To Location: *                                   │
│  [ICU Ward ▼]               [Central Pharmacy ▼]                             │
│                                                                              │
│  Return Date: [2025-01-22] 📅    Return By: [Nurse Jane ▼]                  │
│                                                                              │
│  Return Reason: *                                                            │
│  ● Excess Stock    ○ Near Expiry    ○ Damaged    ○ Wrong Drug               │
│                                                                              │
│  Items to Return:                                             [+ Add Item]  │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Drug        │ Lot Number │ Expiry    │ Return Qty│ Condition       │ │ │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ Paracetamol │ LOT2024A   │ 2026-03   │ 200 tabs  │ ● Good ○ Damaged│ │ │
│  │ Amoxicillin │ LOT2024B   │ 2025-06   │ 100 caps  │ ● Good ○ Damaged│ │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Notes:                                                                      │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Excess stock from previous week, original packaging intact            │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  [Cancel]                                 [Save Draft]  [Submit Return]     │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. Ward staff creates return request
2. Selects items with lot numbers
3. Indicates condition (Good/Damaged)
4. Submits return

---

## 🔄 Flow 2: Process Return (Pharmacy)

### 📱 Screen: Accept Return

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Process Drug Return - RET-2025-045                                [X]       │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Return from: ICU Ward | Requested by: Nurse Jane | Date: 2025-01-22        │
│  Reason: Excess Stock                                                        │
│                                                                              │
│  Items to Inspect:                                                           │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Drug        │ Lot      │ Claimed│ Actual │ Condition│ Accept? │ Action │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ Paracetamol │ LOT2024A │ 200    │ [200_] │ ✓ Good   │ ☑ Yes  │ Stock  │ │
│  │ Amoxicillin │ LOT2024B │ 100    │ [100_] │ ✓ Good   │ ☑ Yes  │ Stock  │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Inspection Results:                                                         │
│  ● Accept All (return to stock)                                             │
│  ○ Reject All (return to sender)                                            │
│  ○ Partial Accept (specify per item)                                        │
│                                                                              │
│  Accepted By: [Select Pharmacist ▼]                                         │
│  Accepted Date: [2025-01-22] 📅  Time: [15:00]                              │
│                                                                              │
│  Notes:                                                                      │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ All items inspected. Original packaging intact. Accepted for restocking│ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│                                         [Reject]  [Accept Return]            │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. Pharmacist inspects returned items
2. Verifies quantities and conditions
3. Accepts or rejects
4. System updates inventory (add back to pharmacy)

---

## 📊 Summary

- **Return Creation:** Ward staff initiates with reason
- **Inspection:** Pharmacist verifies before accepting
- **Inventory Update:** Auto-update on acceptance

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.2.0
