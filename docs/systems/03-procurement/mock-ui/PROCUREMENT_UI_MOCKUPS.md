# 🛒 Procurement - UI Mockups & User Flow

**Procurement System - User Interface Mockups**

**Version:** 2.2.0
**Last Updated:** 2025-01-22

---

## 📋 Overview

เอกสารนี้แสดง UI mockups และ user flow สำหรับ Procurement workflows:

1. **Purchase Request (PR)** - สร้างและอนุมัติใบขอซื้อ
2. **Purchase Order (PO)** - สร้าง PO จาก PR ที่อนุมัติแล้ว
3. **Goods Receipt** - รับยาเข้าคลัง

---

## 🔄 Flow 1: Create Purchase Request (PR)

### จุดประสงค์
สร้างใบขอซื้อพร้อมตรวจสอบงบประมาณ real-time

---

### 📱 Screen 1: PR List

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - Purchase Requests                  👤 Pharmacist [Logout]│
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Purchase Requests                                         [+ Create New PR]│
│                                                                             │
│  Status: [All ▼]  Department: [All ▼]  Search: [_______] 🔍                │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ PR Number   │ Date       │ Dept     │ Items │ Value    │ Status  │ │ │ │
│  ├───────────────────────────────────────────────────────────────────────┤ │
│  │ PR-2025-125 │ 2025-01-22 │ Pharmacy │ 5     │ ฿250,000 │ Pending │ │ │
│  │ PR-2025-124 │ 2025-01-21 │ ICU      │ 3     │ ฿150,000 │ Approved│ │ │
│  │ PR-2025-123 │ 2025-01-20 │ Pharmacy │ 8     │ ฿180,000 │ Approved│ │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User clicks **[+ Create New PR]**

---

### 📱 Screen 2: Create PR Form

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  Create Purchase Request                                          [?] [X]  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  PR Information                                                             │
│                                                                             │
│  Department: *          Budget Type: *          Quarter: *                 │
│  [Pharmacy ▼]           [OP001 - Drugs ▼]       [Q2 ▼]                     │
│  Available: ฿2,500,000                                                      │
│                                                                             │
│  PR Date: [2025-01-22] 📅    Purpose: [Stock replenishment__________]      │
│                                                                             │
│  Items:                                                      [+ Add Item]   │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Generic Drug      │ Qty       │ Est. Price │ Total     │ In Plan? │ │ │ │
│  ├───────────────────────────────────────────────────────────────────────┤ │
│  │ Paracetamol 500mg │ 10,000    │ ฿2.50      │ ฿25,000   │ ✓ Yes    │ │ │
│  │ Amoxicillin 500mg │ 5,000     │ ฿5.00      │ ฿25,000   │ ✓ Yes    │ │ │
│  │ Ibuprofen 400mg   │ 3,000     │ ฿3.00      │ ฿9,000    │ ⚠️ No    │ │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ 💰 Budget Check:                                                    │   │
│  │ • Available Budget (Q2): ฿2,500,000                                 │   │
│  │ • This PR Total: ฿59,000                                            │   │
│  │ • After Reserve: ฿2,441,000                                         │   │
│  │ • Status: ✓ Budget Available                                        │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  [Cancel]                             [Save Draft]  [Submit for Approval]  │
└─────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User selects department, budget type, quarter
2. User adds items (drugs)
3. System checks budget real-time
4. User clicks **[Submit for Approval]**

---

## 🔄 Flow 2: Approve Purchase Request

### 📱 Screen: PR Approval

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  Approve Purchase Request - PR-2025-125                           [X]       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Submitted by: Pharmacist | Date: 2025-01-22 10:30                          │
│  Department: Pharmacy | Budget: OP001 - Q2                                  │
│                                                                             │
│  Items (3):                                                                 │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Generic Drug      │ Qty    │ Est. Price│ Total    │ In Plan?        │ │ │
│  ├───────────────────────────────────────────────────────────────────────┤ │
│  │ Paracetamol 500mg │ 10,000 │ ฿2.50     │ ฿25,000  │ ✓ Yes           │ │ │
│  │ Amoxicillin 500mg │ 5,000  │ ฿5.00     │ ฿25,000  │ ✓ Yes           │ │ │
│  │ Ibuprofen 400mg   │ 3,000  │ ฿3.00     │ ฿9,000   │ ⚠️ Not in plan  │ │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  Budget Check:                                                              │
│  ✓ Available: ฿2,500,000 | Request: ฿59,000 | Remaining: ฿2,441,000        │
│                                                                             │
│  Approval Decision:                                                         │
│  ● Approve    ○ Reject    ○ Request Changes                                │
│                                                                             │
│  Comments:                                                                  │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ Approved. Ibuprofen not in plan but essential for patient care.    │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│                                      [Cancel]  [Submit Decision]            │
└─────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. Approver reviews PR
2. System shows budget check
3. Approver selects decision and adds comments
4. Approver clicks **[Submit Decision]**

---

## 🔄 Flow 3: Create Purchase Order

### 📱 Screen: Create PO from PR

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  Create Purchase Order from PR-2025-125                           [X]       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  PO Information                                                             │
│                                                                             │
│  PO Number: [PO-2025-] [046] (Auto)    PO Date: [2025-01-22] 📅            │
│                                                                             │
│  Vendor: *                                                                  │
│  [GPO (Government Pharmaceutical Organization) ▼]                           │
│  Contact: Tel 02-123-4567 | Email: sales@gpo.or.th                          │
│                                                                             │
│  Items from PR-2025-125:                                                    │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Drug              │ PR Qty │ PO Qty │ Unit Price │ Discount│ Total  │ │ │
│  ├───────────────────────────────────────────────────────────────────────┤ │
│  │ Paracetamol 500mg │ 10,000 │ 10,000 │ ฿2.45      │ 2%      │ ฿24,010│ │ │
│  │ Amoxicillin 500mg │ 5,000  │ 5,000  │ ฿4.90      │ 2%      │ ฿24,010│ │ │
│  │ Ibuprofen 400mg   │ 3,000  │ 3,000  │ ฿2.95      │ 2%      │ ฿8,673 │ │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  Subtotal: ฿56,693 | VAT (7%): ฿3,969 | Total: ฿60,662                     │
│                                                                             │
│  Delivery Terms:                                                            │
│  Expected Delivery: [2025-02-05] 📅    Payment Terms: [Net 30 ▼]           │
│                                                                             │
│  [Cancel]                                  [Preview PO]  [Create PO]        │
└─────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User selects approved PR
2. User selects vendor
3. User enters actual prices (may differ from estimate)
4. System calculates total with VAT
5. User clicks **[Create PO]**

---

## 🔄 Flow 4: Goods Receipt

### 📱 Screen: Record Receipt

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  Goods Receipt - PO-2025-046                                      [X]       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  PO Details:                                                                │
│  Vendor: GPO | PO Date: 2025-01-22 | Expected: 2025-02-05                  │
│                                                                             │
│  Receipt Information:                                                       │
│  Receipt Number: [RCV-2025-] [078] (Auto)                                   │
│  Receipt Date: [2025-02-05] 📅    Received By: [Select Staff ▼]            │
│                                                                             │
│  Items Received:                                                            │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │ Drug          │ Ordered│ Received│ Lot No.     │ Expiry    │ Status │ │ │
│  ├───────────────────────────────────────────────────────────────────────┤ │
│  │ Paracetamol   │ 10,000 │ [10,000]│ [LOT2025A_]│ [2027-12] │ ✓ Match│ │ │
│  │ Amoxicillin   │ 5,000  │ [5,000_]│ [LOT2025B_]│ [2026-06] │ ✓ Match│ │ │
│  │ Ibuprofen     │ 3,000  │ [2,900_]│ [LOT2025C_]│ [2027-03] │ ⚠️ Short│ │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  ⚠️ Quantity Discrepancy:                                                  │
│  Ibuprofen: Ordered 3,000, Received 2,900 (Short 100 units)                │
│                                                                             │
│  Notes:                                                                     │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │ Ibuprofen short 100 units. Vendor will deliver backorder next week.│   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  Location: [Central Pharmacy ▼]                                             │
│                                                                             │
│  [Cancel]                       [Save Draft]  [Post to Inventory]           │
└─────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User selects PO to receive
2. User enters receipt info
3. User records lot number and expiry for each item
4. User enters actual quantity received
5. System highlights discrepancies
6. User adds notes
7. User clicks **[Post to Inventory]** → Updates inventory + lot tables

---

## 📊 Summary

### Purchase Request (PR)
- **Screens:** 2 (List, Create with budget check)
- **Key Feature:** Real-time budget validation
- **Complexity:** ⭐⭐⭐ (Moderate)

### Purchase Order (PO)
- **Screens:** 1 (Create from PR)
- **Key Feature:** Vendor selection, price update, VAT calculation
- **Complexity:** ⭐⭐ (Simple)

### Goods Receipt
- **Screens:** 1 (Record receipt with lot info)
- **Key Feature:** Lot/expiry tracking, quantity verification, FIFO preparation
- **Complexity:** ⭐⭐⭐ (Moderate)

---

## 🎨 UI Principles

1. **Budget-First:** ตรวจสอบงบก่อนสร้าง PR เสมอ
2. **Approval Workflow:** แสดง status และ comments ชัดเจน
3. **Data Linkage:** PR → PO → Receipt (เชื่อมโยงกัน)
4. **Quality Control:** ตรวจสอบ lot/expiry, quantity ที่รับ
5. **Auto-posting:** Receipt → Inventory & Lot (อัตโนมัติ)

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.2.0
