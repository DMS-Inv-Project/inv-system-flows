# 🏥 HPP System - UI Mockups & User Flow

**Hospital Pharmaceutical Products (HPP) - User Interface Mockups**

**Version:** 2.2.0
**Last Updated:** 2025-01-22

---

## 📋 Overview

เอกสารนี้แสดง UI mockups และ user flow สำหรับการสร้าง Hospital Pharmaceutical Products (HPP) ทั้ง 4 ประเภท:

1. **HPP-R (Repackaged)** - บรรจุใหม่
2. **HPP-F (Formula)** - สูตรโรงพยาบาล
3. **HPP-M (Modified)** - ดัดแปลง
4. **HPP-X (Extemporaneous)** - ผสมตามสั่ง

---

## 🔄 Flow 1: Create Repackaged Product (HPP-R)

### จุดประสงค์
บรรจุยาจากบรรจุภัณฑ์ขนาดใหญ่เป็นขนาดเล็ก เช่น ยาเม็ดขวด 1,000 เม็ด → Blister pack 10 เม็ด

---

### 📱 Screen 1: HPP Product List

```
┌──────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - HPP Products                     👤 Admin    [Logout] │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  Hospital Pharmaceutical Products                                        │
│                                                                          │
│  [+ Create New HPP]     Filter: [All Types ▼]  Search: [________] 🔍   │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │ HPP Code    │ Product Name              │ Type   │ Status │ Action │ │
│  ├────────────────────────────────────────────────────────────────────┤ │
│  │ HPP-R-001   │ Paracetamol Blister x10   │ R      │ Active │ [Edit] │ │
│  │ HPP-F-001   │ Metoclopramide Solution   │ F      │ Active │ [View] │ │
│  │ HPP-M-001   │ Paracetamol 250mg Split   │ M      │ Active │ [Edit] │ │
│  │ HPP-X-001   │ Amoxicillin Custom Susp   │ X      │ Used   │ [View] │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│  Showing 4 of 25 products                                    [1] 2 3 >  │
└──────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User clicks **[+ Create New HPP]**
2. System shows HPP type selection dialog

---

### 📱 Screen 2: Select HPP Type

```
┌──────────────────────────────────────────────────────────┐
│  Select HPP Product Type                       [X]       │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  Choose the type of HPP product to create:               │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │  📦 R - Repackaged (บรรจุใหม่)                   │◄──│ Selected
│  │  Repackage bulk drugs into smaller units        │   │
│  │  Example: Bottle 1,000 tabs → Blister 10 tabs   │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │  ⚗️ F - Hospital Formula (สูตรโรงพยาบาล)         │   │
│  │  Hospital-developed standard formulations        │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │  ✂️ M - Modified (ดัดแปลง)                        │   │
│  │  Modify commercial products (split, dissolve)    │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │  🧪 X - Extemporaneous (ผสมตามสั่ง)              │   │
│  │  Patient-specific custom compounding             │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│                            [Cancel]  [Continue →]        │
└──────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User selects **"R - Repackaged"**
2. User clicks **[Continue →]**
3. System opens Repackage Form

---

### 📱 Screen 3: Repackage Form

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Repackaged Product (HPP-R)                              [?] [X]    │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Step 1: Select Base Drug                                                 │
│                                                                            │
│  Search Drug:  [Paracetamol 500________________] 🔍                        │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ ● Paracetamol 500mg Tablet (Bottle x1,000 tablets)                  │ │
│  │   Manufacturer: GPO                                                  │ │
│  │   Unit Cost: ฿0.50/tablet                                            │ │
│  │   In Stock: 50,000 tablets                                           │ │
│  ├──────────────────────────────────────────────────────────────────────┤ │
│  │ ○ Paracetamol 500mg Tablet (Bottle x500 tablets)                    │ │
│  │   Manufacturer: Zuellig Pharma                                       │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  Step 2: New Package Configuration                                        │
│                                                                            │
│  HPP Code:        [HPP-R-] [001]  (Auto-generated)                        │
│  Product Name:    [Paracetamol 500mg Blister Pack x10______________]      │
│                                                                            │
│  New Package Size:  [10] tablets per [Blister ▼]                          │
│  Packaging Cost:    [0.30] THB per blister                                │
│  Labor Cost:        [0.20] THB per blister                                │
│                                                                            │
│  ─────────────────────────────────────────────────────────────────────    │
│  Cost Breakdown (per blister):                                            │
│    Drug Cost:      ฿5.00  (10 tablets × ฿0.50)                           │
│    Packaging:      ฿0.30                                                  │
│    Labor:          ฿0.20                                                  │
│    ─────────────────────                                                  │
│    Total Cost:     ฿5.50 per blister                                      │
│  ─────────────────────────────────────────────────────────────────────    │
│                                                                            │
│  Notes (Optional):                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ Repackage for outpatient dispensing                               │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  ☑ Add to inventory after creation                                        │
│                                                                            │
│  [Cancel]                                    [Preview Label]  [Create HPP]│
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User searches and selects base drug
2. System auto-fills HPP code (HPP-R-001)
3. User enters new package size: 10 tablets per blister
4. User enters packaging cost: ฿0.30
5. User enters labor cost: ฿0.20
6. System calculates total cost: ฿5.50
7. User clicks **[Preview Label]** to see label mockup
8. User clicks **[Create HPP]** to save

---

### 📱 Screen 4: Label Preview

```
┌────────────────────────────────────────────────────────┐
│  Product Label Preview                       [Print]   │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ╔══════════════════════════════════════════════════╗ │
│  ║  Hospital Pharmaceutical Product                 ║ │
│  ╠══════════════════════════════════════════════════╣ │
│  ║                                                  ║ │
│  ║  HPP-R-001                                       ║ │
│  ║  Paracetamol 500mg Blister Pack x10              ║ │
│  ║                                                  ║ │
│  ║  Base Drug: Paracetamol 500mg Tablet             ║ │
│  ║  Generic: Paracetamol                            ║ │
│  ║  Package: 10 tablets per blister                 ║ │
│  ║  Unit Cost: ฿5.50 per blister                    ║ │
│  ║                                                  ║ │
│  ║  Expiry: [Same as base drug lot]                ║ │
│  ║  Manufactured: 2025-01-22                        ║ │
│  ║                                                  ║ │
│  ║  FOR HOSPITAL USE ONLY                           ║ │
│  ║  Store at room temperature                       ║ │
│  ║                                                  ║ │
│  ╚══════════════════════════════════════════════════╝ │
│                                                        │
│                         [Close]  [Print Label]         │
└────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User reviews label design
2. User clicks **[Print Label]** if needed
3. User closes preview
4. System creates HPP-R record and returns to list

---

## 🔄 Flow 2: Create Hospital Formula (HPP-F)

### จุดประสงค์
สร้างสูตรตำรับมาตรฐานของโรงพยาบาล พร้อมระบุ components ครบถ้วน

---

### 📱 Screen 1: Formula Basic Info

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Hospital Formula (HPP-F)                  Step 1 of 2    [?] [X]  │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Basic Information                                                         │
│                                                                            │
│  HPP Code:        [HPP-F-] [001]  (Auto-generated)                        │
│  Product Name:    [Metoclopramide Oral Solution 5mg/5mL____________]      │
│                                                                            │
│  Base Generic:                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ Search: [Metoclopramide________] 🔍                                  │ │
│  │                                                                      │ │
│  │ ● Metoclopramide                                                     │ │
│  │   ATC Code: A03FA01                                                  │ │
│  │   Working Code: METOCLO                                              │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  Target Strength:    [5] mg per [5] mL                                    │
│  Batch Size:         [100] mL                                             │
│                                                                            │
│  Storage Condition:  [Refrigerate 2-8°C ▼]                                │
│  Beyond Use Date:    [30] days                                            │
│                                                                            │
│  Formula Status:                                                           │
│  ○ Draft    ● Pending Approval    ○ Approved                              │
│                                                                            │
│  Notes:                                                                    │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ Standard hospital formula approved by P&T committee                │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  [Cancel]                                                  [Next: Add Components →]│
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User enters product name
2. User searches and selects base generic (Metoclopramide)
3. User enters target strength: 5mg per 5mL
4. User enters batch size: 100mL
5. User selects storage condition and beyond use date
6. User clicks **[Next: Add Components →]**

---

### 📱 Screen 2: Add Formulation Components

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Hospital Formula (HPP-F)                  Step 2 of 2    [?] [X]  │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  HPP-F-001: Metoclopramide Oral Solution 5mg/5mL                          │
│  Batch Size: 100 mL                                                        │
│                                                                            │
│  Formulation Components                                [+ Add Component]  │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ Component Type  │ Name                │ Strength  │ Ratio   │ Action │ │
│  ├──────────────────────────────────────────────────────────────────────┤ │
│  │ 🔴 ACTIVE       │ Metoclopramide HCl  │ 5mg/5mL   │ 0.0100  │ [Edit] │ │
│  │ 🟡 EXCIPIENT    │ Syrup Simple        │ -         │ 0.8800  │ [Edit] │ │
│  │ 🟢 PRESERVATIVE │ Sodium Benzoate     │ 0.1%      │ 0.0010  │ [Edit] │ │
│  │ 🔵 SOLVENT      │ Purified Water      │ -         │ 0.1090  │ [Edit] │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  Total Ratio: 1.0000 (100%) ✓                                             │
│                                                                            │
│  ─────────────────────────────────────────────────────────────────────    │
│  Validation Status:                                                        │
│  ✓ At least 1 ACTIVE component present                                    │
│  ✓ Total ratio equals 1.0 (±0.001)                                        │
│  ✓ All components have valid ratios                                       │
│  ─────────────────────────────────────────────────────────────────────    │
│                                                                            │
│  Preparation Method:                                                       │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ 1. Dissolve Metoclopramide HCl in 50mL purified water             │   │
│  │ 2. Add Syrup Simple and mix well                                  │   │
│  │ 3. Add Sodium Benzoate solution                                   │   │
│  │ 4. Add purified water to make 100mL                               │   │
│  │ 5. Mix thoroughly and transfer to bottle                          │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  [← Back]                            [Preview Formula Card]  [Create Formula]│
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User clicks **[+ Add Component]** for each ingredient
2. System validates:
   - At least 1 ACTIVE component required
   - Total ratio must = 1.0
3. User enters preparation method (optional)
4. User clicks **[Preview Formula Card]**
5. User clicks **[Create Formula]**

---

### 📱 Screen 3: Add Component Dialog

```
┌────────────────────────────────────────────────────┐
│  Add Formulation Component                   [X]  │
├────────────────────────────────────────────────────┤
│                                                    │
│  Component Type: *                                 │
│  ┌──────────────────────────────────────────────┐ │
│  │ ● ACTIVE (Active Ingredient)                 │ │
│  │ ○ EXCIPIENT (Filler, Binder)                 │ │
│  │ ○ PRESERVATIVE                               │ │
│  │ ○ SOLVENT (Water, Alcohol)                   │ │
│  │ ○ VEHICLE (Suspension base)                  │ │
│  │ ○ FLAVOR                                     │ │
│  └──────────────────────────────────────────────┘ │
│                                                    │
│  Component Name: *                                 │
│  [Metoclopramide HCl_____________________]         │
│                                                    │
│  Strength/Concentration:                           │
│  [5mg/5mL________________________]                 │
│                                                    │
│  Component Ratio: * (0.0000 - 1.0000)              │
│  [0.0100] = 1.00%                                  │
│                                                    │
│  Remaining ratio available: 0.9900 (99.00%)        │
│                                                    │
│                       [Cancel]  [Add Component]    │
└────────────────────────────────────────────────────┘
```

**User Flow:**
1. User selects component type (ACTIVE)
2. User enters component name
3. User enters strength (5mg/5mL)
4. User enters ratio (0.0100 = 1%)
5. System shows remaining ratio available
6. User clicks **[Add Component]**
7. Repeat for all components

---

### 📱 Screen 4: Formula Card Preview

```
┌──────────────────────────────────────────────────────────────┐
│  Formula Card Preview                          [Print] [X]   │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ╔════════════════════════════════════════════════════════╗ │
│  ║  HOSPITAL FORMULA - HPP-F-001                          ║ │
│  ╠════════════════════════════════════════════════════════╣ │
│  ║  Metoclopramide Oral Solution 5mg/5mL                  ║ │
│  ║                                                        ║ │
│  ║  FORMULATION (per 100mL):                             ║ │
│  ║                                                        ║ │
│  ║  Active Ingredient:                                   ║ │
│  ║    • Metoclopramide HCl ........... 100mg (1.0%)      ║ │
│  ║                                                        ║ │
│  ║  Excipients:                                          ║ │
│  ║    • Syrup Simple ................. 88g (88.0%)       ║ │
│  ║    • Purified Water ............... 10.9g (10.9%)     ║ │
│  ║                                                        ║ │
│  ║  Preservative:                                        ║ │
│  ║    • Sodium Benzoate 0.1% ......... 100mg (0.1%)      ║ │
│  ║                                                        ║ │
│  ║  PREPARATION METHOD:                                  ║ │
│  ║  1. Dissolve Metoclopramide HCl in 50mL water        ║ │
│  ║  2. Add Syrup Simple and mix well                    ║ │
│  ║  3. Add Sodium Benzoate solution                     ║ │
│  ║  4. Add water to make 100mL                          ║ │
│  ║  5. Mix thoroughly                                   ║ │
│  ║                                                        ║ │
│  ║  STORAGE: Refrigerate 2-8°C                           ║ │
│  ║  BEYOND USE DATE: 30 days                            ║ │
│  ║                                                        ║ │
│  ║  Prepared by: ___________ Date: ___________          ║ │
│  ║  Checked by: ____________ Date: ___________          ║ │
│  ╚════════════════════════════════════════════════════════╝ │
│                                                              │
│                         [Close]  [Print Formula Card]        │
└──────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User reviews complete formula card
2. User clicks **[Print Formula Card]** for documentation
3. User closes preview
4. System saves HPP-F record

---

## 🔄 Flow 3: Create Modified Product (HPP-M)

### จุดประสงค์
ดัดแปลงผลิตภัณฑ์การค้า เช่น แบ่งเม็ดยา, ละลายแคปซูล พร้อม safety checks

---

### 📱 Screen 1: Modification Form

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Modified Product (HPP-M)                                 [?] [X]   │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Step 1: Select Base Product to Modify                                    │
│                                                                            │
│  Search Product: [Paracetamol 500_________] 🔍                             │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ ● Paracetamol 500mg Tablet                                           │ │
│  │   Generic: Paracetamol                                               │ │
│  │   Dosage Form: Tablet                                                │ │
│  │   ✓ Has score line (safe to split)                                  │ │
│  │   ⚠️ Warning: Check if enteric-coated                                │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  Step 2: Modification Details                                             │
│                                                                            │
│  HPP Code:        [HPP-M-] [001]  (Auto-generated)                        │
│  Product Name:    [Paracetamol 250mg (Split Tablet)____________]          │
│                                                                            │
│  Modification Method: *                                                    │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ ● Split Tablet          ○ Dissolve Capsule                        │   │
│  │ ○ Crush & Suspend       ○ Other (specify)                         │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  Original Strength:  [500] mg                                             │
│  New Strength:       [250] mg                                             │
│  Modification Ratio: [0.5] (50%)                                          │
│                                                                            │
│  Detailed Instructions:                                                    │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ 1. Use tablet splitter for accuracy                               │   │
│  │ 2. Place tablet in splitter along score line                      │   │
│  │ 3. Press firmly to split evenly                                   │   │
│  │ 4. Inspect for even split - discard if uneven                     │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  Special Handling:                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ • Store split tablets in tight container                          │   │
│  │ • Protect from moisture                                           │   │
│  │ • Use within 7 days after splitting                               │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  [Cancel]                                 [Safety Check]  [Create Modified]│
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User searches and selects base product
2. System shows safety warnings (score line, coating status)
3. User selects modification method: Split Tablet
4. User enters new strength: 250mg (50% ratio)
5. User enters detailed instructions
6. User enters special handling requirements
7. User clicks **[Safety Check]** for validation

---

### 📱 Screen 2: Safety Check Dialog

```
┌────────────────────────────────────────────────────────────────┐
│  Safety Check - Modified Product                      [X]     │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  Product: Paracetamol 500mg → 250mg (Split)                   │
│                                                                │
│  Safety Assessment:                                            │
│                                                                │
│  ✓ PASS: Tablet has score line                                │
│  ✓ PASS: Not enteric-coated                                   │
│  ✓ PASS: Not extended-release                                 │
│  ✓ PASS: Not controlled-release                               │
│  ✓ PASS: Modification method appropriate                      │
│                                                                │
│  ⚠️ WARNINGS:                                                  │
│  • Split tablets have reduced stability                       │
│  • Use within 7 days after splitting                          │
│  • Store in tight, light-resistant container                  │
│                                                                │
│  Overall Status: ✓ SAFE TO PROCEED                            │
│                                                                │
│  Pharmacist Approval Required:                                │
│  ☑ I have reviewed the safety checks                          │
│  ☑ I approve this modification method                         │
│                                                                │
│  Approved by: [Select Pharmacist ▼]                           │
│                                                                │
│                           [Cancel]  [Approve & Continue]       │
└────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. System runs automatic safety checks
2. Shows PASS/FAIL for each criterion
3. Displays warnings if any
4. Pharmacist reviews and checks approval boxes
5. Pharmacist selects name from dropdown
6. Pharmacist clicks **[Approve & Continue]**
7. System creates HPP-M record

---

### 📱 Screen 3: Preparation Instructions Preview

```
┌────────────────────────────────────────────────────────────┐
│  Modified Product Preparation Instructions      [Print]   │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌────────────────────────────────────────────────────┐   │
│  │ MODIFIED PRODUCT - HPP-M-001                       │   │
│  ├────────────────────────────────────────────────────┤   │
│  │ Paracetamol 250mg (Split Tablet)                   │   │
│  │                                                    │   │
│  │ BASE PRODUCT:                                      │   │
│  │ • Paracetamol 500mg Tablet                        │   │
│  │                                                    │   │
│  │ MODIFICATION METHOD:                               │   │
│  │ 1. Use tablet splitter for accuracy               │   │
│  │ 2. Place tablet in splitter along score line      │   │
│  │ 3. Press firmly to split evenly                   │   │
│  │ 4. Inspect for even split - discard if uneven     │   │
│  │                                                    │   │
│  │ RESULTING STRENGTH: 250mg per half tablet         │   │
│  │                                                    │   │
│  │ STORAGE:                                           │   │
│  │ • Store split tablets in tight container          │   │
│  │ • Protect from moisture                           │   │
│  │ • Use within 7 days after splitting               │   │
│  │                                                    │   │
│  │ LABELING:                                          │   │
│  │ • "Paracetamol 250mg (Half Tablet)"               │   │
│  │ • Date prepared                                    │   │
│  │ • Use by date (7 days)                            │   │
│  │ • "FOR HOSPITAL USE ONLY"                         │   │
│  │                                                    │   │
│  │ ⚠️ PRECAUTIONS:                                    │   │
│  │ • Verify dose before dispensing                   │   │
│  │ • Counsel patient on use                          │   │
│  │                                                    │   │
│  │ Approved by: Dr. Smith   Date: 2025-01-22        │   │
│  └────────────────────────────────────────────────────┘   │
│                                                            │
│                   [Close]  [Print Instructions]            │
└────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User reviews preparation instructions
2. User clicks **[Print Instructions]** for documentation
3. Instructions posted at preparation area
4. System saves HPP-M with approved status

---

## 🔄 Flow 4: Create Extemporaneous Product (HPP-X)

### จุดประสงค์
ผสมยาเฉพาะรายผู้ป่วย (patient-specific) พร้อม QC และ documentation ครบถ้วน

---

### 📱 Screen 1: Prescription Review

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Extemporaneous Product (HPP-X)            Step 1 of 4    [?] [X]  │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Prescription Information                                                  │
│                                                                            │
│  Prescription ID: *  [RX789012_______]  [Verify]                           │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ Prescription Details:                                                │ │
│  │                                                                      │ │
│  │ Patient: John Doe (HN123456)                                        │ │
│  │ Age: 5 years   Weight: 18 kg                                        │ │
│  │                                                                      │ │
│  │ Drug: Amoxicillin 125mg PO TID × 7 days                             │ │
│  │ Notes: Patient cannot swallow capsules                              │ │
│  │                                                                      │ │
│  │ Prescriber: Dr. Jane Smith                                          │ │
│  │ Date: 2025-01-22                                                    │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  Commercial Product Check:                                                 │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ ⚠️ Commercial Amoxicillin Suspension 250mg/5mL available           │   │
│  │ ❌ Too strong for 5-year-old patient (requires 125mg/5mL)          │   │
│  │ ✓ Extemporaneous compounding required                              │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  Justification for Extemporaneous Preparation:                             │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ Commercial product strength too high for pediatric patient.        │   │
│  │ Custom 125mg/5mL suspension needed for accurate dosing.            │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  [Cancel]                                            [Next: Design Formula →]│
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User enters prescription ID: RX789012
2. User clicks **[Verify]**
3. System loads prescription details
4. System checks for commercial alternatives
5. System shows justification requirement
6. User enters justification
7. User clicks **[Next: Design Formula →]**

---

### 📱 Screen 2: Formula Design

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Extemporaneous Product (HPP-X)            Step 2 of 4    [?] [X]  │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Formula Design - Amoxicillin Suspension 125mg/5mL                         │
│                                                                            │
│  HPP Code:        [HPP-X-] [001]  (Auto-generated)                        │
│  Product Name:    [Amoxicillin Suspension 125mg/5mL (Custom)_____]        │
│                                                                            │
│  Patient: John Doe (HN123456)                                              │
│  Prescription: RX789012                                                    │
│                                                                            │
│  Target Parameters:                                                        │
│  Target Strength:  [125] mg per [5] mL                                    │
│  Quantity Needed:  [105] mL (for 7 days TID = 5mL × 3 × 7)               │
│  Beyond Use Date:  [14] days (suspension stability)                       │
│                                                                            │
│  ─────────────────────────────────────────────────────────────────────    │
│  Ingredient Calculation:                                                   │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │ Ingredient          │ Source         │ Qty Needed │ Ratio            │ │
│  ├──────────────────────────────────────────────────────────────────────┤ │
│  │ Amoxicillin Powder  │ 250mg capsules │ 11 caps    │ Active           │ │
│  │ Ora-Sweet SF        │ Vehicle        │ 50 mL      │ 47.6%            │ │
│  │ Ora-Plus            │ Vehicle        │ 50 mL      │ 47.6%            │ │
│  │ Cherry Flavor       │ Flavoring      │ 5 mL       │ 4.8%             │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  Total Amoxicillin: 11 × 250mg = 2,750mg                                  │
│  Total Volume: 105 mL                                                      │
│  Concentration: 2,750mg ÷ 105mL = 26.19mg/mL = 130.95mg/5mL              │
│                                                                            │
│  ⚠️ Calculated strength: 130.95mg/5mL (target: 125mg/5mL)                 │
│  Variance: 4.8% over target (acceptable <10%)                             │
│                                                                            │
│  Storage: [Refrigerate 2-8°C ▼]                                           │
│  ☑ Shake well before use                                                  │
│                                                                            │
│  [← Back]                      [Recalculate]  [Next: Review Worksheet →]  │
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User enters target strength: 125mg/5mL
2. User calculates quantity needed: 105mL
3. System calculates ingredients automatically
4. User reviews calculated strength: 130.95mg/5mL
5. System shows variance: 4.8% (acceptable)
6. User clicks **[Next: Review Worksheet →]**

---

### 📱 Screen 3: Compounding Worksheet

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Extemporaneous Product (HPP-X)            Step 3 of 4    [?] [X]  │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │ EXTEMPORANEOUS COMPOUNDING WORKSHEET                              │   │
│  ├────────────────────────────────────────────────────────────────────┤   │
│  │ HPP-X-001                                                          │   │
│  │ Amoxicillin Suspension 125mg/5mL (Custom)                          │   │
│  │                                                                    │   │
│  │ FOR PATIENT: John Doe (HN123456)                                  │   │
│  │ PRESCRIPTION: RX789012                                             │   │
│  │                                                                    │   │
│  │ QUANTITY TO PREPARE: 105 mL                                        │   │
│  │                                                                    │   │
│  │ INGREDIENTS:                                                       │   │
│  │ ☐ Amoxicillin 250mg capsules ....... 11 caps                      │   │
│  │ ☐ Ora-Sweet SF ...................... 50 mL                        │   │
│  │ ☐ Ora-Plus .......................... 50 mL                        │   │
│  │ ☐ Cherry Flavor ..................... 5 mL                         │   │
│  │                                                                    │   │
│  │ PROCEDURE:                                                         │   │
│  │ 1. ☐ Empty 11 Amoxicillin capsules into mortar                   │   │
│  │ 2. ☐ Add 10mL Ora-Plus and triturate to smooth paste             │   │
│  │ 3. ☐ Add 40mL Ora-Plus in portions, mix well                     │   │
│  │ 4. ☐ Transfer to graduated cylinder                              │   │
│  │ 5. ☐ Add 50mL Ora-Sweet SF, mix                                  │   │
│  │ 6. ☐ Add 5mL Cherry Flavor                                       │   │
│  │ 7. ☐ QS to 105mL with Ora-Sweet SF                               │   │
│  │ 8. ☐ Mix thoroughly                                               │   │
│  │                                                                    │   │
│  │ QUALITY CHECKS:                                                    │   │
│  │ ☐ Color: Off-white to pink                                        │   │
│  │ ☐ Consistency: Uniform suspension                                 │   │
│  │ ☐ Volume: 105mL ± 2mL                                             │   │
│  │ ☐ pH: 5.5-7.0 (measured: _____)                                   │   │
│  │                                                                    │   │
│  │ Prepared by: __________ Date: _____ Time: ____                    │   │
│  │ Checked by: ___________ Date: _____ Time: ____                    │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  [← Back]                [Print Worksheet]  [Next: Quality Check →]       │
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User reviews compounding worksheet
2. User clicks **[Print Worksheet]**
3. Pharmacist follows procedure (checks boxes on printed copy)
4. Pharmacist performs quality checks
5. Pharmacist enters measurements (pH, volume)
6. User clicks **[Next: Quality Check →]** after compounding

---

### 📱 Screen 4: Quality Check & Final Label

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Create Extemporaneous Product (HPP-X)            Step 4 of 4    [?] [X]  │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Quality Control Check                                                     │
│                                                                            │
│  Product: HPP-X-001 - Amoxicillin Suspension 125mg/5mL                     │
│                                                                            │
│  QC Parameters:                                                            │
│                                                                            │
│  Final Volume:    [105.5] mL   (Target: 105 ± 2mL) ✓                      │
│  Measured pH:     [6.5]        (Range: 5.5-7.0) ✓                         │
│                                                                            │
│  Appearance:                                                               │
│  ● Uniform suspension   ○ Non-uniform   ○ Separated                       │
│                                                                            │
│  Color:                                                                    │
│  ● Off-white to pink   ○ Abnormal color                                   │
│                                                                            │
│  Consistency:                                                              │
│  ● Smooth, pourable   ○ Too thick   ○ Too thin                            │
│                                                                            │
│  Overall QC Result:                                                        │
│  ● PASS - Product meets quality standards                                 │
│  ○ FAIL - Discard and prepare new batch                                   │
│                                                                            │
│  ─────────────────────────────────────────────────────────────────────    │
│  Final Label Preview:                                                      │
│                                                                            │
│  ╔═══════════════════════════════════════════════╗                        │
│  ║ PATIENT: JOHN DOE (HN123456)                 ║                        │
│  ╠═══════════════════════════════════════════════╣                        │
│  ║ AMOXICILLIN SUSPENSION                       ║                        │
│  ║ 125mg per 5mL                                ║                        │
│  ║                                              ║                        │
│  ║ QUANTITY: 105 mL                             ║                        │
│  ║                                              ║                        │
│  ║ DIRECTIONS:                                  ║                        │
│  ║ Take 5mL by mouth three times daily         ║                        │
│  ║ for 7 days                                   ║                        │
│  ║                                              ║                        │
│  ║ ⚠️ SHAKE WELL BEFORE USE                     ║                        │
│  ║ ⚠️ REFRIGERATE 2-8°C                         ║                        │
│  ║                                              ║                        │
│  ║ PREPARED: 2025-01-22                         ║                        │
│  ║ EXPIRY: 2025-02-05 (14 days)                ║                        │
│  ║                                              ║                        │
│  ║ Rx789012 | RPh: Dr. Smith                   ║                        │
│  ║ HPP-X-001                                    ║                        │
│  ╚═══════════════════════════════════════════════╝                        │
│                                                                            │
│  QC Performed by: [Select Pharmacist ▼]                                   │
│  Notes: [Optional QC notes_________________________]                      │
│                                                                            │
│  [← Back]                    [Print Label]  [Complete & Dispense]         │
└────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. Pharmacist enters QC measurements
   - Final volume: 105.5mL (within range)
   - pH: 6.5 (within range)
2. Pharmacist checks appearance, color, consistency
3. Pharmacist selects QC result: PASS
4. System generates final label with all info
5. Pharmacist reviews label
6. Pharmacist clicks **[Print Label]**
7. Pharmacist clicks **[Complete & Dispense]**
8. System saves HPP-X record with compounding log
9. Product ready for dispensing

---

### 📱 Screen 5: Compounding Log (Auto-saved)

```
┌──────────────────────────────────────────────────────────────┐
│  Compounding Log Saved                              [X]     │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ✓ HPP-X-001 created successfully                           │
│                                                              │
│  Compounding Record:                                         │
│                                                              │
│  Product: Amoxicillin Suspension 125mg/5mL (Custom)         │
│  Patient: John Doe (HN123456)                               │
│  Prescription: RX789012                                      │
│                                                              │
│  Prepared by: Dr. Smith                                     │
│  Prepared on: 2025-01-22 14:30                              │
│                                                              │
│  Checked by: Dr. Johnson                                    │
│  Checked on: 2025-01-22 14:45                               │
│                                                              │
│  QC Status: PASS                                            │
│  - Volume: 105.5mL                                          │
│  - pH: 6.5                                                  │
│  - Appearance: Uniform suspension                           │
│                                                              │
│  Beyond Use Date: 2025-02-05                                │
│                                                              │
│  Documents Generated:                                        │
│  ☑ Compounding Worksheet                                    │
│  ☑ Final Product Label                                      │
│  ☑ Compounding Log                                          │
│                                                              │
│                                    [Print All]  [Close]      │
└──────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. System shows completion summary
2. All documents auto-saved in system
3. User clicks **[Print All]** for physical records
4. User clicks **[Close]**
5. System returns to HPP product list
6. Product shows status: "Dispensed"

---

## 📊 Summary: UI Patterns by HPP Type

### HPP-R (Repackaged)
- **Screens:** 4 screens
- **Key Features:** Drug selection, package size, cost calculation, label preview
- **Complexity:** ⭐⭐ (Simple)

### HPP-F (Formula)
- **Screens:** 4 screens + component dialog
- **Key Features:** Multi-component addition, ratio validation, formula card
- **Complexity:** ⭐⭐⭐⭐ (Complex)

### HPP-M (Modified)
- **Screens:** 3 screens + safety dialog
- **Key Features:** Safety checks, pharmacist approval, preparation instructions
- **Complexity:** ⭐⭐⭐ (Moderate)

### HPP-X (Extemporaneous)
- **Screens:** 5 screens
- **Key Features:** Prescription link, formula calculator, QC checklist, compounding log
- **Complexity:** ⭐⭐⭐⭐⭐ (Most Complex)

---

## 🎨 UI Design Principles

### 1. Progressive Disclosure
- แสดงข้อมูลทีละขั้นตอน (Step 1, 2, 3...)
- ป้องกัน information overload
- User มองเห็น progress ได้ชัดเจน

### 2. Real-time Validation
- HPP-F: Total ratio validation
- HPP-M: Safety checks
- HPP-X: Strength calculation with variance

### 3. Preview Before Commit
- ทุก HPP type มี preview ก่อน save
- Label preview, Formula card, Instructions
- ให้ user ตรวจสอบก่อน finalize

### 4. Documentation Auto-generation
- System สร้าง documents อัตโนมัติ
- Worksheet, Labels, Formula cards
- พร้อม print ทันที

### 5. Safety First
- HPP-M: Mandatory safety checks
- HPP-X: QC checklist required
- Pharmacist approval for critical steps

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.2.0
