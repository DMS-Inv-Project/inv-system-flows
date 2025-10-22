# 🏢 Master Data - UI Mockups & User Flow

**Master Data Management - User Interface Mockups**

**Version:** 2.4.0
**Last Updated:** 2025-01-22

---

## 📋 Overview

เอกสารนี้แสดง UI mockups และ user flow สำหรับ Master Data Management ทั้ง 3 workflows:

1. **CRUD Operations** - Create, Read, Update, Delete (Drugs, Generics, Companies, Locations, Departments)
2. **Bulk Import** - นำเข้าข้อมูลจาก Excel/CSV
3. **Search & Filter** - ค้นหาและกรองข้อมูลขั้นสูง

---

## 🔄 Flow 1: CRUD Operations - Drug Management

### จุดประสงค์
จัดการข้อมูลยา (Drugs) - สร้าง, แก้ไข, ดู, ปิดการใช้งาน

---

### 📱 Screen 1: Drug List

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - Drug Master Data                     👤 Admin      [Logout]   │
├──────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  Drug Catalog                                                                    │
│                                                                                  │
│  [+ Add New Drug]     Filter: [Active ▼]  NLEM: [All ▼]  Search: [______] 🔍   │
│                                                                                  │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │ Drug Code              │ Trade Name      │ Generic   │ NLEM │ Price │ Action│ │
│  ├────────────────────────────────────────────────────────────────────────────┤ │
│  │ 123456789012345678901234│ Tylenol 500mg  │ Paraceta.│  E   │ ฿2.50 │[Edit] │ │
│  │ 234567890123456789012345│ Amoxil 500mg   │ Amoxici. │  E   │ ฿5.00 │[Edit] │ │
│  │ 345678901234567890123456│ Augmentin 625mg│ Amoxi+Ca │  E   │ ฿12.0 │[Edit] │ │
│  │ 456789012345678901234567│ Ibuprofen 400mg│ Ibupro.  │  N   │ ฿3.00 │[Edit] │ │
│  │ 567890123456789012345678│ Zocor 20mg     │ Simvast. │  N   │ ฿15.0 │[Edit] │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                                                                  │
│  Showing 5 of 1,248 drugs                                        [1] 2 3 ... 50 >│
│                                                                                  │
│  Legend: E = Essential (NLEM)  N = Non-Essential                                │
└──────────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User views drug list (default: Active drugs)
2. User can filter by status, NLEM, or search
3. User clicks **[+ Add New Drug]** to create
4. User clicks **[Edit]** to edit existing drug

---

### 📱 Screen 2: Create New Drug Form

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Add New Drug                                                      [?] [X]   │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Basic Information                                                           │
│                                                                              │
│  Drug Code: * (24 characters)                                                │
│  [123456789012345678901234_]                                                 │
│  ✓ Valid format (24 chars)                                                   │
│                                                                              │
│  Trade Name: *                                                               │
│  [Tylenol 500mg Tablet___________________________]                           │
│                                                                              │
│  Generic Drug: *                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │ Search generic: [Paracetamol____] 🔍                                 │   │
│  │                                                                      │   │
│  │ ● Paracetamol                                                        │   │
│  │   Working Code: PARA500 | ATC: N02BE01                              │   │
│  │   Common Names: Acetaminophen, PCM                                  │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  Manufacturer: *                                                             │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │ Search company: [GPO_______] 🔍                                      │   │
│  │                                                                      │   │
│  │ ● GPO (Government Pharmaceutical Organization)                       │   │
│  │   Type: Manufacturer | Country: Thailand                            │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ─────────────────────────────────────────────────────────────────────────  │
│  Ministry Compliance Fields                                                  │
│                                                                              │
│  NLEM Status: *                                                              │
│  ● Essential (E)    ○ Non-Essential (N)                                     │
│                                                                              │
│  Drug Status: *                                                              │
│  [STATUS_1 - Active ▼]                                                       │
│                                                                              │
│  Product Category: *                                                         │
│  [CATEGORY_1 - Drug ▼]                                                       │
│                                                                              │
│  Status Changed Date:                                                        │
│  [2025-01-22] (Auto-filled)                                                  │
│                                                                              │
│  ─────────────────────────────────────────────────────────────────────────  │
│  Pricing & Packaging                                                         │
│                                                                              │
│  Unit Price (THB): *          Package Size:        Package Unit:            │
│  [2.50___]                    [100____]            [TAB ▼]                   │
│                                                                              │
│  Strength:                    Dosage Form:                                   │
│  [500mg__]                    [Tablet ▼]                                     │
│                                                                              │
│  ☑ Active (is_active = true)                                                │
│                                                                              │
│  Notes (Optional):                                                           │
│  ┌────────────────────────────────────────────────────────────────────┐     │
│  │                                                                    │     │
│  └────────────────────────────────────────────────────────────────────┘     │
│                                                                              │
│  [Cancel]                                    [Save Draft]  [Create Drug]    │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User enters drug code (24 characters) - validates on blur
2. User enters trade name
3. User searches and selects generic drug
4. User searches and selects manufacturer
5. User selects NLEM status (E/N)
6. User selects drug status (STATUS_1)
7. User selects product category (CATEGORY_1)
8. User enters pricing and packaging info
9. System validates all required fields
10. User clicks **[Create Drug]**
11. System shows success message and returns to list

---

### 📱 Screen 3: Edit Drug Form

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Edit Drug - Tylenol 500mg                                         [?] [X]   │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Basic Information                                                           │
│                                                                              │
│  Drug Code: (Cannot be changed)                                             │
│  [123456789012345678901234] 🔒                                               │
│                                                                              │
│  Trade Name: *                                                               │
│  [Tylenol 500mg Tablet___________________________]                           │
│                                                                              │
│  Generic Drug: *                                                             │
│  [Paracetamol                                          ] [Change]            │
│  Working Code: PARA500                                                       │
│                                                                              │
│  Manufacturer: *                                                             │
│  [GPO (Government Pharmaceutical Organization)         ] [Change]            │
│                                                                              │
│  ─────────────────────────────────────────────────────────────────────────  │
│  Ministry Compliance Fields                                                  │
│                                                                              │
│  NLEM Status: *                                                              │
│  ● Essential (E)    ○ Non-Essential (N)                                     │
│                                                                              │
│  Drug Status: *                                                              │
│  [STATUS_1 - Active ▼]                                                       │
│  ⚠️ Changing status will update Status Changed Date                          │
│                                                                              │
│  Product Category: *                                                         │
│  [CATEGORY_1 - Drug ▼]                                                       │
│                                                                              │
│  Status Changed Date:                                                        │
│  [2025-01-15] (Last changed)                                                 │
│                                                                              │
│  ─────────────────────────────────────────────────────────────────────────  │
│  Pricing & Packaging                                                         │
│                                                                              │
│  Unit Price (THB): *          Package Size:        Package Unit:            │
│  [2.50___] → [2.75___]        [100____]            [TAB ▼]                   │
│  ℹ️ Price changed from ฿2.50                                                 │
│                                                                              │
│  Strength:                    Dosage Form:                                   │
│  [500mg__]                    [Tablet ▼]                                     │
│                                                                              │
│  ☑ Active (is_active = true)                                                │
│                                                                              │
│  Notes:                                                                      │
│  ┌────────────────────────────────────────────────────────────────────┐     │
│  │ Price updated per vendor quote dated 2025-01-22                   │     │
│  └────────────────────────────────────────────────────────────────────┘     │
│                                                                              │
│  Last Updated: 2025-01-15 by Admin                                           │
│                                                                              │
│  [Cancel]                                              [Update Drug]         │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User opens edit form (drug_code locked)
2. User modifies fields (e.g., price: ฿2.50 → ฿2.75)
3. System shows change indicators
4. User adds notes explaining changes
5. User clicks **[Update Drug]**
6. System updates record and shows success message

---

### 📱 Screen 4: Drug Detail View (Read-only)

```
┌──────────────────────────────────────────────────────────────────┐
│  Drug Details - Tylenol 500mg                          [Edit] [X]│
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Basic Information                                               │
│  ────────────────────────────────────────────────────────────    │
│  Drug Code:          123456789012345678901234                    │
│  Trade Name:         Tylenol 500mg Tablet                        │
│  Generic Drug:       Paracetamol (PARA500)                       │
│  Manufacturer:       GPO                                         │
│                                                                  │
│  Ministry Compliance                                             │
│  ────────────────────────────────────────────────────────────    │
│  NLEM Status:        E (Essential)                               │
│  Drug Status:        STATUS_1 (Active)                           │
│  Product Category:   CATEGORY_1 (Drug)                           │
│  Status Changed:     2025-01-15                                  │
│                                                                  │
│  Pricing & Packaging                                             │
│  ────────────────────────────────────────────────────────────    │
│  Unit Price:         ฿2.75                                       │
│  Package:            100 TAB                                     │
│  Strength:           500mg                                       │
│  Dosage Form:        Tablet                                      │
│                                                                  │
│  Status                                                          │
│  ────────────────────────────────────────────────────────────    │
│  Active:             ✓ Yes                                       │
│  Created:            2025-01-10 by Admin                         │
│  Last Updated:       2025-01-15 by Admin                         │
│                                                                  │
│  Usage Statistics                                                │
│  ────────────────────────────────────────────────────────────    │
│  In Purchase Requests:   5 PRs                                   │
│  In Inventory:           3 locations                             │
│  Total Stock:            15,000 tablets                          │
│                                                                  │
│                                        [Deactivate]  [Close]     │
└──────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User views complete drug details (read-only)
2. System shows usage statistics
3. User clicks **[Edit]** to modify
4. User clicks **[Deactivate]** to soft delete
5. User clicks **[Close]** to return to list

---

### 📱 Screen 5: Deactivate Confirmation

```
┌────────────────────────────────────────────────────────┐
│  Deactivate Drug                             [X]      │
├────────────────────────────────────────────────────────┤
│                                                        │
│  Are you sure you want to deactivate this drug?       │
│                                                        │
│  Drug: Tylenol 500mg (123456789012345678901234)       │
│                                                        │
│  ⚠️ Usage Check:                                       │
│  • Found in 5 purchase requests                       │
│  • Found in 3 inventory locations (15,000 tablets)    │
│  • Found in 2 budget plans                            │
│                                                        │
│  ✓ Deactivation is allowed                            │
│    (Existing records will remain unchanged)           │
│                                                        │
│  Reason for deactivation:                             │
│  ┌──────────────────────────────────────────────┐     │
│  │ Discontinued by manufacturer                 │     │
│  └──────────────────────────────────────────────┘     │
│                                                        │
│  Note: This drug will be marked as inactive           │
│  and hidden from new selections, but existing          │
│  records will not be affected.                         │
│                                                        │
│                          [Cancel]  [Deactivate]        │
└────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User clicks **[Deactivate]** from detail view
2. System checks usage in other modules
3. System shows warning if in use (but allows deactivation)
4. User enters reason for deactivation
5. User clicks **[Deactivate]**
6. System sets `is_active = false` and shows success

---

## 🔄 Flow 2: Bulk Import

### จุดประสงค์
นำเข้าข้อมูลยาจำนวนมากจากไฟล์ Excel/CSV พร้อม validation

---

### 📱 Screen 1: Import Selection

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - Drug Master Data                                           │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Drug Catalog                                                                │
│                                                                              │
│  [+ Add New Drug]  [📤 Bulk Import]  Filter: [Active ▼]  Search: [___] 🔍   │
│  ▲ Click here                                                                │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Drug Code              │ Trade Name      │ Generic   │ NLEM │ Price │   │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ ...                                                                    │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User clicks **[📤 Bulk Import]**
2. System opens import dialog

---

### 📱 Screen 2: Upload File

```
┌────────────────────────────────────────────────────────────────────┐
│  Bulk Import - Drugs                              Step 1 of 4  [X] │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Upload Import File                                                │
│                                                                    │
│  Supported Formats: Excel (.xlsx, .xls), CSV (.csv)                │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐ │
│  │                                                              │ │
│  │                    📁                                        │ │
│  │                                                              │ │
│  │         Drag and drop file here                             │ │
│  │                   or                                         │ │
│  │              [Browse Files]                                  │ │
│  │                                                              │ │
│  │   Maximum file size: 10 MB                                   │ │
│  │   Maximum rows: 10,000                                       │ │
│  │                                                              │ │
│  └──────────────────────────────────────────────────────────────┘ │
│                                                                    │
│  📥 Download Template:                                             │
│  • [Excel Template] - Pre-formatted with all required columns     │
│  • [CSV Template] - Simple CSV format                             │
│  • [Sample Data] - Example with 10 sample drugs                   │
│                                                                    │
│  Required Columns:                                                 │
│  • drug_code (24 characters)                                       │
│  • trade_name                                                      │
│  • generic_name or generic_id                                      │
│  • manufacturer_name or manufacturer_id                            │
│  • nlem_status (E or N)                                            │
│  • drug_status (STATUS_1, STATUS_2, STATUS_3, STATUS_4)            │
│  • product_category (CATEGORY_1 to CATEGORY_5)                     │
│  • unit_price                                                      │
│  • package_size                                                    │
│  • package_unit                                                    │
│                                                                    │
│  [Cancel]                                            [Next Step →] │
└────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User downloads template (optional)
2. User drags file or clicks **[Browse Files]**
3. System validates file format and size
4. User clicks **[Next Step →]**

---

### 📱 Screen 3: File Uploaded

```
┌────────────────────────────────────────────────────────────────────┐
│  Bulk Import - Drugs                              Step 1 of 4  [X] │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  File Uploaded Successfully                                        │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐ │
│  │ 📄 drugs_import_2025.xlsx                                    │ │
│  │ Size: 1.2 MB                                                 │ │
│  │ Rows: 500                                    [Remove File]   │ │
│  └──────────────────────────────────────────────────────────────┘ │
│                                                                    │
│  ✓ File format valid                                              │
│  ✓ File size within limit (1.2 MB < 10 MB)                        │
│  ✓ Row count within limit (500 < 10,000)                          │
│                                                                    │
│  Processing Options:                                               │
│  ☑ Skip duplicate drug_code (keep existing)                       │
│  ☐ Update existing drugs if found                                 │
│  ☑ Auto-map generic names to generic_id                           │
│  ☑ Auto-map manufacturer names to manufacturer_id                 │
│                                                                    │
│  [Cancel]                           [Validate Data →]              │
└────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. File uploaded successfully
2. User reviews processing options
3. User clicks **[Validate Data →]**
4. System starts validation

---

### 📱 Screen 4: Validation in Progress

```
┌────────────────────────────────────────────────────────────────────┐
│  Bulk Import - Drugs                              Step 2 of 4  [X] │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Validating Data...                                                │
│                                                                    │
│  Progress: 250 / 500 rows (50%)                                    │
│                                                                    │
│  ████████████████████░░░░░░░░░░░░░░░░░░░░░░░  50%                 │
│                                                                    │
│  Current Task: Validating drug codes...                            │
│                                                                    │
│  Validation Steps:                                                 │
│  ✓ File structure check                                            │
│  ✓ Required columns present                                        │
│  ⏳ Drug code format (24 chars)                                    │
│  ⏳ Generic name lookup                                            │
│  ⏳ Manufacturer name lookup                                       │
│  ⏳ NLEM status validation                                         │
│  ⏳ Price validation                                               │
│  ⏳ Duplicate check                                                │
│                                                                    │
│  Please wait...                                                    │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. System validates all rows
2. Shows real-time progress
3. Auto-advances when complete

---

### 📱 Screen 5: Validation Results

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Bulk Import - Drugs                              Step 3 of 4          [X]   │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Validation Complete                                                         │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ 📊 Validation Summary                                                  │ │
│  │                                                                        │ │
│  │ Total Rows:           500                                              │ │
│  │ ✓ Valid Rows:         487 (97.4%)   [Ready to import]                 │ │
│  │ ❌ Invalid Rows:       13 (2.6%)     [Will be skipped]                 │ │
│  │ ⚠️ Warnings:           25            [Review recommended]              │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Preview Valid Rows (First 5):                                               │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Row│Drug Code             │Trade Name      │Status        │Notes       │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ 1  │123456789012345678901234│Tylenol 500mg  │✓ Valid       │           │ │
│  │ 2  │234567890123456789012345│Amoxil 500mg   │✓ Valid       │           │ │
│  │ 3  │345678901234567890123456│Augmentin 625  │✓ Valid       │           │ │
│  │ 4  │456789012345678901234567│Ibuprofen 400  │⚠️ Warning    │Price high │ │
│  │ 5  │567890123456789012345678│Zocor 20mg     │✓ Valid       │           │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Preview Invalid Rows (First 5):                                             │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Row│Drug Code             │Trade Name      │Errors                      │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ 10 │123                   │Test Drug       │Drug code must be 24 chars │ │
│  │ 25 │234567890123456789012345│               │Trade name required        │ │
│  │ 47 │345678901234567890123456│Unknown Drug   │Generic not found          │ │
│  │ 88 │456789012345678901234567│Bad Price Drug │Invalid price: "N/A"       │ │
│  │ 99 │123456789012345678901234│Duplicate Drug │Drug code already exists   │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  [← Back]  [Download Error Report]  [Import Valid Only (487 rows)]          │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User reviews validation summary
2. User previews valid and invalid rows
3. User clicks **[Download Error Report]** to fix errors
4. User clicks **[Import Valid Only]** to proceed with 487 valid rows

---

### 📱 Screen 6: Import in Progress

```
┌────────────────────────────────────────────────────────────────────┐
│  Bulk Import - Drugs                              Step 4 of 4  [X] │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Importing Data...                                                 │
│                                                                    │
│  Progress: 300 / 487 rows (61.6%)                                  │
│                                                                    │
│  ████████████████████████████░░░░░░░░░░░░  61.6%                  │
│                                                                    │
│  Current Task: Creating drug records...                            │
│                                                                    │
│  Status:                                                           │
│  ✓ Imported: 300 drugs                                             │
│  ⏳ Remaining: 187 drugs                                            │
│  ❌ Failed: 0                                                       │
│                                                                    │
│  Estimated time remaining: 15 seconds                              │
│                                                                    │
│  Please do not close this window...                                │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. System imports valid rows to database
2. Shows real-time progress
3. Auto-advances when complete

---

### 📱 Screen 7: Import Complete

```
┌────────────────────────────────────────────────────────────────────┐
│  Bulk Import - Drugs                         Complete!         [X] │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  ✓ Import Completed Successfully                                  │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐ │
│  │ 📊 Import Summary                                            │ │
│  │                                                              │ │
│  │ Total Rows Processed:    500                                 │ │
│  │ ✓ Successfully Imported: 487 drugs                           │ │
│  │ ⏭️ Skipped (Invalid):     13 drugs                            │ │
│  │ ❌ Failed During Import:  0 drugs                             │ │
│  │                                                              │ │
│  │ Time Taken: 2 minutes 15 seconds                             │ │
│  └──────────────────────────────────────────────────────────────┘ │
│                                                                    │
│  What's Next?                                                      │
│  • View imported drugs in the drug list                           │
│  • Download error report to fix invalid rows                      │
│  • Import fixed data in a new batch                               │
│                                                                    │
│  Documents:                                                        │
│  [Download Import Log]                                             │
│  [Download Error Report (13 rows)]                                 │
│                                                                    │
│                    [Import More Files]  [Back to List]             │
└────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User reviews import summary
2. User downloads error report (optional)
3. User clicks **[Back to List]** to view imported drugs
4. System returns to drug list with success message

---

## 🔄 Flow 3: Search & Filter

### จุดประสงค์
ค้นหาและกรองข้อมูลยาด้วยเงื่อนไขหลายตัว

---

### 📱 Screen 1: Advanced Search

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - Drug Master Data                                           │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Drug Catalog                                                                │
│                                                                              │
│  [+ Add New Drug]  [📤 Import]  [🔍 Advanced Search]  Quick: [_____] 🔍      │
│                                  ▲ Click here                                │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Drug Code              │ Trade Name      │ Generic   │ NLEM │ Price │   │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User clicks **[🔍 Advanced Search]**
2. System opens advanced search panel

---

### 📱 Screen 2: Advanced Search Panel

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  Advanced Search - Drugs                                           [X]       │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Search Criteria                                                             │
│                                                                              │
│  Drug Code/Name:                                                             │
│  [Paracetamol___________________________________] (Contains)                  │
│                                                                              │
│  Generic Drug:                                                               │
│  [Select generic...                             ▼]                           │
│                                                                              │
│  Manufacturer:                                                               │
│  [Select manufacturer...                        ▼]                           │
│                                                                              │
│  NLEM Status:              Drug Status:          Product Category:          │
│  [All      ▼]              [All      ▼]          [All         ▼]            │
│  ○ All                     ○ All                 ○ All                       │
│  ○ Essential (E)           ○ STATUS_1            ○ CATEGORY_1                │
│  ○ Non-Essential (N)       ○ STATUS_2            ○ CATEGORY_2                │
│                            ○ STATUS_3            ○ CATEGORY_3                │
│                            ○ STATUS_4            ○ CATEGORY_4                │
│                                                  ○ CATEGORY_5                │
│                                                                              │
│  Price Range (THB):        Package Size:                                     │
│  [0.00__] to [999.99]      [___] to [___] [TAB ▼]                            │
│                                                                              │
│  Dosage Form:                                                                │
│  ☐ Tablet  ☐ Capsule  ☐ Syrup  ☐ Injection  ☐ Cream  ☐ Other               │
│                                                                              │
│  Status:                   Created Date:                                     │
│  ☑ Active                  [2024-01-01] to [2025-12-31] 📅                   │
│  ☐ Inactive                                                                  │
│  ☐ All                                                                       │
│                                                                              │
│  Sort By:                  Order:                                            │
│  [Trade Name ▼]            ○ Ascending  ● Descending                        │
│                                                                              │
│                    [Clear All]  [Cancel]  [Search]                           │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User enters search criteria (any combination)
2. User clicks **[Search]**
3. System applies filters and shows results

---

### 📱 Screen 3: Search Results

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - Drug Master Data                                           │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Search Results: "Paracetamol"                        [Modify Search] [Clear]│
│                                                                              │
│  Active Filters: NLEM: Essential | Price: ฿0-฿10 | Status: Active           │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Drug Code              │ Trade Name         │ Generic   │ Price │ Action│ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ 123456789012345678901234│ Tylenol 500mg     │ Paraceta.│ ฿2.50 │[View] │ │
│  │ 234567890123456789012345│ Panadol 500mg     │ Paraceta.│ ฿3.00 │[View] │ │
│  │ 345678901234567890123456│ Sara 500mg        │ Paraceta.│ ฿2.00 │[View] │ │
│  │ 456789012345678901234567│ Paracetamol GPO   │ Paraceta.│ ฿1.50 │[View] │ │
│  │ 567890123456789012345678│ Tylenol 325mg     │ Paraceta.│ ฿2.00 │[View] │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Found 5 drugs matching criteria                                [Export CSV] │
│                                                                              │
│  Showing 5 of 5 results                                                      │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User views filtered results
2. Active filters shown at top
3. User clicks **[Modify Search]** to adjust
4. User clicks **[Clear]** to reset filters
5. User clicks **[Export CSV]** to download results
6. User clicks **[View]** to see drug details

---

## 📊 Summary: Master Data UI Patterns

### CRUD Operations
- **Screens:** 5 screens (List, Create, Edit, View, Delete confirm)
- **Key Features:** Form validation, usage check, soft delete, audit trail
- **Complexity:** ⭐⭐ (Simple to Moderate)

### Bulk Import
- **Screens:** 7 screens (Upload, Validate, Preview, Import, Complete)
- **Key Features:** Template download, real-time validation, error reporting, auto-mapping
- **Complexity:** ⭐⭐⭐⭐ (Complex)

### Search & Filter
- **Screens:** 3 screens (List, Advanced search, Results)
- **Key Features:** Multiple filter criteria, real-time search, export results
- **Complexity:** ⭐⭐⭐ (Moderate)

---

## 🎨 UI Design Principles

### 1. Consistent Layout
- Header with navigation และ user menu
- Action buttons ด้านบน (Add, Import, Search)
- Table view พร้อม pagination
- Edit/View ในแต่ละ row

### 2. Progressive Disclosure
- Basic info → Advanced options
- Simple filters → Advanced search
- Quick actions → Bulk operations

### 3. Validation & Feedback
- Real-time field validation
- Clear error messages
- Success/warning indicators
- Progress bars for long operations

### 4. Data Safety
- Confirmation dialogs for destructive actions
- Soft delete (is_active = false)
- Usage check before deletion
- Audit trail (created_at, updated_at, created_by)

### 5. User Efficiency
- Quick search in header
- Keyboard shortcuts
- Bulk operations (Import)
- Export capabilities (CSV, Excel)

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.4.0
