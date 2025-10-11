# FLOW 01: Master Data Setup
## การตั้งค่าข้อมูลพื้นฐานระบบ INVS Modern

---

## 📋 **ภาพรวม**

Master Data คือข้อมูลพื้นฐานที่ต้องตั้งค่าก่อนเริ่มใช้งานระบบ ประกอบด้วย:
1. **Locations** - สถานที่เก็บยา
2. **Departments** - หน่วยงาน/แผนก
3. **Budget Types** - ประเภทงบประมาณ
4. **Companies** - ผู้ขาย/ผู้ผลิต
5. **Drug Generics** - ยาสามัญ
6. **Drugs** - ยาการค้า

---

## 🔄 **Flow Diagram**

```
┌─────────────────────────────────────────────────────────────┐
│                     MASTER DATA SETUP                        │
└─────────────────────────────────────────────────────────────┘

Step 1: Setup Locations (คลังยา, ห้องยา, หอผู้ป่วย)
   ↓
Step 2: Setup Departments (แผนกต่างๆ ในโรงพยาบาล)
   ↓
Step 3: Setup Budget Types (ประเภทงบประมาณ)
   ↓
Step 4: Setup Companies (ผู้ขาย/ผู้ผลิต)
   ↓
Step 5: Setup Drug Generics (ยาสามัญ - Working Code)
   ↓
Step 6: Setup Drugs (ยาการค้า - Trade Name)
   ↓
Step 7: Verify & Activate System
```

---

## 🖥️ **UI MOCKUP: Location Setup Screen**

```
╔══════════════════════════════════════════════════════════════╗
║  INVS Modern - Location Setup                          [X]  ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  📍 Add New Location                                         ║
║                                                              ║
║  Location Code: [PHARM    ]  (Max 10 chars)                ║
║  Location Name: [Central Pharmacy________________]          ║
║  Location Type: [▼ PHARMACY ]                               ║
║                 [ ] WAREHOUSE                                ║
║                 [✓] PHARMACY                                 ║
║                 [ ] WARD                                     ║
║                 [ ] EMERGENCY                                ║
║                 [ ] LABORATORY                               ║
║  Address:       [Ground Floor, Building A________]          ║
║  Responsible:   [Chief Pharmacist________________]          ║
║                                                              ║
║  Parent Location: [▼ None (Root Level)      ]               ║
║                                                              ║
║  [ Cancel ]                    [ Save Location ]            ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  Current Locations:                                          ║
║  ┌────────────────────────────────────────────────────────┐ ║
║  │ Code   │ Name                  │ Type      │ Active   │ ║
║  ├────────┼───────────────────────┼───────────┼──────────┤ ║
║  │ MAIN   │ Main Warehouse        │ WAREHOUSE │ ✓        │ ║
║  │ PHARM  │ Central Pharmacy      │ PHARMACY  │ ✓        │ ║
║  │ EMRG   │ Emergency Department  │ EMERGENCY │ ✓        │ ║
║  │ ICU    │ Intensive Care Unit   │ WARD      │ ✓        │ ║
║  │ OPD    │ Outpatient Department │ PHARMACY  │ ✓        │ ║
║  └────────┴───────────────────────┴───────────┴──────────┘ ║
╚══════════════════════════════════════════════════════════════╝
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 1 - Locations**

### ข้อมูลที่ต้องกรอก

```json
{
  "locationCode": "PHARM",
  "locationName": "Central Pharmacy",
  "locationType": "PHARMACY",
  "address": "Ground Floor, Building A",
  "responsiblePerson": "Chief Pharmacist",
  "parentId": null,
  "isActive": true
}
```

### Database Operation

```sql
-- INSERT Location
INSERT INTO locations (
  location_code,
  location_name,
  location_type,
  address,
  responsible_person,
  parent_id,
  is_active,
  created_at
) VALUES (
  'PHARM',
  'Central Pharmacy',
  'pharmacy',
  'Ground Floor, Building A',
  'Chief Pharmacist',
  NULL,
  true,
  CURRENT_TIMESTAMP
);

-- Verify
SELECT
  id,
  location_code,
  location_name,
  location_type
FROM locations
WHERE location_code = 'PHARM';
```

### Expected Result

```
 id | location_code | location_name    | location_type
----+---------------+------------------+--------------
  2 | PHARM         | Central Pharmacy | pharmacy
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 2 - Departments**

### ข้อมูลที่ต้องกรอก

```json
{
  "deptCode": "PHARM",
  "deptName": "Pharmacy Department",
  "headPerson": "Chief Pharmacist",
  "budgetCode": "PHA001",
  "parentId": null,
  "isActive": true
}
```

### Database Operation

```sql
-- INSERT Department
INSERT INTO departments (
  dept_code,
  dept_name,
  head_person,
  budget_code,
  parent_id,
  is_active,
  created_at
) VALUES (
  'PHARM',
  'Pharmacy Department',
  'Chief Pharmacist',
  'PHA001',
  NULL,
  true,
  CURRENT_TIMESTAMP
);

-- Verify
SELECT
  id,
  dept_code,
  dept_name,
  budget_code
FROM departments
WHERE dept_code = 'PHARM';
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 3 - Budget Types**

### ข้อมูลที่ต้องกรอก (ตามมาตรฐาน กสธ.)

```json
{
  "budgetCode": "OP001",
  "budgetName": "งบดำเนินงาน - ยา",
  "budgetDescription": "งบประมาณสำหรับซื้อยาและเวชภัณฑ์",
  "isActive": true
}
```

### Database Operation

```sql
-- INSERT Budget Type
INSERT INTO budget_types (
  budget_code,
  budget_name,
  budget_description,
  is_active,
  created_at
) VALUES (
  'OP001',
  'งบดำเนินงาน - ยา',
  'งบประมาณสำหรับซื้อยาและเวชภัณฑ์',
  true,
  CURRENT_TIMESTAMP
);

-- Verify all budget types
SELECT
  budget_code,
  budget_name
FROM budget_types
ORDER BY budget_code;
```

### Expected Result

```
budget_code | budget_name
------------+--------------------------------
EM001       | งบฉุกเฉิน
INV001      | งบลงทุน - อุปกรณ์
INV002      | งบลงทุน - ระบบ IT
OP001       | งบดำเนินงาน - ยา
OP002       | งบดำเนินงาน - เครื่องมือ
OP003       | งบดำเนินงาน - วัสดุสิ้นเปลือง
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 4 - Companies**

### ข้อมูลที่ต้องกรอก

```json
{
  "companyCode": "000001",
  "companyName": "Government Pharmaceutical Organization (GPO)",
  "companyType": "BOTH",
  "taxId": "0994000158378",
  "address": "75/1 Rama VI Road, Ratchathewi, Bangkok 10400",
  "phone": "02-203-8000",
  "email": "info@gpo.or.th",
  "contactPerson": "Sales Manager",
  "isActive": true
}
```

### Database Operation

```sql
-- INSERT Company
INSERT INTO companies (
  company_code,
  company_name,
  company_type,
  tax_id,
  address,
  phone,
  email,
  contact_person,
  is_active,
  created_at
) VALUES (
  '000001',
  'Government Pharmaceutical Organization (GPO)',
  'both',
  '0994000158378',
  '75/1 Rama VI Road, Ratchathewi, Bangkok 10400',
  '02-203-8000',
  'info@gpo.or.th',
  'Sales Manager',
  true,
  CURRENT_TIMESTAMP
);

-- Verify
SELECT
  company_code,
  company_name,
  company_type,
  phone
FROM companies
WHERE company_code = '000001';
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 5 - Drug Generics**

### ข้อมูลที่ต้องกรอก (Working Code System)

```json
{
  "workingCode": "PAR0001",
  "drugName": "Paracetamol",
  "dosageForm": "Tablet",
  "saleUnit": "TAB",
  "composition": "Paracetamol",
  "strength": 500.00,
  "strengthUnit": "mg",
  "standardUnit": "TAB",
  "therapeuticGroup": "Analgesic",
  "isActive": true
}
```

### Database Operation

```sql
-- INSERT Drug Generic
INSERT INTO drug_generics (
  working_code,
  drug_name,
  dosage_form,
  sale_unit,
  composition,
  strength,
  strength_unit,
  standard_unit,
  therapeutic_group,
  is_active,
  created_at
) VALUES (
  'PAR0001',
  'Paracetamol',
  'Tablet',
  'TAB',
  'Paracetamol',
  500.00,
  'mg',
  'TAB',
  'Analgesic',
  true,
  CURRENT_TIMESTAMP
);

-- Verify
SELECT
  working_code,
  drug_name,
  strength,
  strength_unit,
  dosage_form
FROM drug_generics
WHERE working_code = 'PAR0001';
```

### Expected Result

```
working_code | drug_name   | strength | strength_unit | dosage_form
-------------+-------------+----------+---------------+------------
PAR0001      | Paracetamol | 500.00   | mg            | Tablet
```

---

## 📊 **ตัวอย่างข้อมูล: STEP 6 - Drugs (Trade Names)**

### ข้อมูลที่ต้องกรอก

```json
{
  "drugCode": "PAR0001-000001-001",
  "tradeName": "GPO Paracetamol 500mg",
  "genericId": 1,
  "manufacturerId": 1,
  "strength": "500mg",
  "dosageForm": "Tablet",
  "packSize": 1000,
  "unit": "TAB",
  "atcCode": "N02BE01",
  "standardCode": "PAR0001-000001-001",
  "barcode": "8851234567890",
  "isActive": true
}
```

### Database Operation

```sql
-- INSERT Drug (Trade Name)
INSERT INTO drugs (
  drug_code,
  trade_name,
  generic_id,
  manufacturer_id,
  strength,
  dosage_form,
  pack_size,
  unit,
  atc_code,
  standard_code,
  barcode,
  is_active,
  created_at
) VALUES (
  'PAR0001-000001-001',
  'GPO Paracetamol 500mg',
  (SELECT id FROM drug_generics WHERE working_code = 'PAR0001'),
  (SELECT id FROM companies WHERE company_code = '000001'),
  '500mg',
  'Tablet',
  1000,
  'TAB',
  'N02BE01',
  'PAR0001-000001-001',
  '8851234567890',
  true,
  CURRENT_TIMESTAMP
);

-- Verify with JOIN
SELECT
  d.drug_code,
  d.trade_name,
  dg.working_code,
  dg.drug_name as generic_name,
  c.company_name,
  d.pack_size,
  d.unit
FROM drugs d
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN companies c ON d.manufacturer_id = c.id
WHERE d.drug_code = 'PAR0001-000001-001';
```

### Expected Result

```
drug_code            | trade_name              | working_code | generic_name | company_name                            | pack_size | unit
---------------------+-------------------------+--------------+--------------+-----------------------------------------+-----------+-----
PAR0001-000001-001   | GPO Paracetamol 500mg   | PAR0001      | Paracetamol  | Government Pharmaceutical Organization  | 1000      | TAB
```

---

## 🖥️ **UI MOCKUP: Drug Setup Screen**

```
╔══════════════════════════════════════════════════════════════╗
║  INVS Modern - Drug Setup (Trade Name)                 [X]  ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  💊 Add New Trade Drug                                       ║
║                                                              ║
║  Generic Drug: [▼ PAR0001 - Paracetamol 500mg Tablet   ]   ║
║  Trade Name:   [GPO Paracetamol 500mg__________________]   ║
║  Manufacturer: [▼ GPO - Government Pharmaceutical Org.  ]   ║
║                                                              ║
║  Drug Code:    [PAR0001-000001-001] (Auto-generated)        ║
║  Strength:     [500mg_____________]                          ║
║  Dosage Form:  [▼ Tablet        ]                           ║
║  Pack Size:    [1000    ] [▼ TAB]                           ║
║                                                              ║
║  ATC Code:     [N02BE01___________]                          ║
║  Barcode:      [8851234567890_____]                          ║
║  NC24 Code:    [________________] (Optional)                 ║
║                                                              ║
║  [ Cancel ]                    [ Save Drug ]                 ║
║                                                              ║
╠══════════════════════════════════════════════════════════════╣
║  Recently Added Drugs:                                       ║
║  ┌────────────────────────────────────────────────────────┐ ║
║  │ Code               │ Trade Name           │ Generic   │ ║
║  ├────────────────────┼──────────────────────┼───────────┤ ║
║  │ PAR0001-000001-001 │ GPO Paracetamol 500mg│ PAR0001   │ ║
║  │ IBU0001-000002-001 │ Brufen 200mg         │ IBU0001   │ ║
║  └────────────────────┴──────────────────────┴───────────┘ ║
╚══════════════════════════════════════════════════════════════╝
```

---

## ✅ **Validation Rules**

### 1. Location Validation
```sql
-- Check unique location code
SELECT COUNT(*) FROM locations WHERE location_code = 'PHARM';
-- Result must be 0 for new location

-- Check parent location exists
SELECT id FROM locations WHERE id = :parent_id;
-- Must return a valid ID if parent_id is not NULL
```

### 2. Department Validation
```sql
-- Check unique dept code
SELECT COUNT(*) FROM departments WHERE dept_code = 'PHARM';
-- Result must be 0 for new department

-- Check budget code format
SELECT :budget_code ~ '^[A-Z]{3}[0-9]{3}$';
-- Must return true (e.g., PHA001, MED001)
```

### 3. Drug Generic Validation
```sql
-- Check unique working code
SELECT COUNT(*) FROM drug_generics WHERE working_code = 'PAR0001';
-- Result must be 0 for new generic

-- Check working code format
SELECT :working_code ~ '^[A-Z]{3}[0-9]{4}$';
-- Must return true (e.g., PAR0001, IBU0001)
```

### 4. Drug Validation
```sql
-- Check generic exists
SELECT id FROM drug_generics WHERE id = :generic_id;

-- Check manufacturer exists
SELECT id FROM companies WHERE id = :manufacturer_id;

-- Check unique drug code
SELECT COUNT(*) FROM drugs WHERE drug_code = :drug_code;
-- Result must be 0 for new drug
```

---

## 🚨 **Error Handling**

### Common Errors

| Error Code | Message | Solution |
|------------|---------|----------|
| `LOC001` | Location code already exists | Use different location code |
| `DEPT001` | Department code already exists | Use different dept code |
| `DRUG001` | Working code already exists | Use different working code |
| `DRUG002` | Generic drug not found | Create generic drug first |
| `COMP001` | Company not found | Create company first |
| `VAL001` | Invalid code format | Follow code format rules |

### Example Error Response

```json
{
  "success": false,
  "errorCode": "LOC001",
  "message": "Location code 'PHARM' already exists",
  "field": "locationCode",
  "suggestedValue": "PHARM2"
}
```

---

## 📈 **Success Criteria**

### ✅ Completion Checklist

- [ ] **5+ Locations** created (Warehouse, Pharmacy, Ward, Emergency, OPD)
- [ ] **5+ Departments** created (Admin, Pharmacy, Nursing, Medical, Lab)
- [ ] **6 Budget Types** created (OP001, OP002, OP003, INV001, INV002, EM001)
- [ ] **5+ Companies** created (At least 3 vendors, 2 manufacturers)
- [ ] **10+ Drug Generics** created (Common drugs with working codes)
- [ ] **20+ Trade Drugs** created (Multiple brands per generic)
- [ ] All relationships verified (Drug → Generic, Drug → Manufacturer)

### Verification Query

```sql
-- Master Data Summary
SELECT
  'Locations' as entity, COUNT(*) as count FROM locations
UNION ALL
SELECT 'Departments', COUNT(*) FROM departments
UNION ALL
SELECT 'Budget Types', COUNT(*) FROM budget_types
UNION ALL
SELECT 'Companies', COUNT(*) FROM companies
UNION ALL
SELECT 'Drug Generics', COUNT(*) FROM drug_generics
UNION ALL
SELECT 'Trade Drugs', COUNT(*) FROM drugs
ORDER BY entity;
```

### Expected Minimum Counts

```
entity        | count
--------------+-------
Budget Types  |     6
Companies     |     5
Departments   |     5
Drug Generics |    10
Locations     |     5
Trade Drugs   |    20
```

---

## 🎯 **Next Steps**

หลังจาก Master Data Setup เสร็จ:

1. ✅ **Budget Allocation** - จัดสรรงบประมาณรายปี (FLOW 02)
2. ✅ **Initial Inventory** - ป้อนสต็อกยาเริ่มต้น (FLOW 04)
3. ✅ **User Setup** - สร้าง user accounts และกำหนดสิทธิ์
4. ✅ **System Testing** - ทดสอบการทำงานของระบบ

---

**📝 Note**: Master Data เป็นพื้นฐานสำคัญของระบบ ควรตรวจสอบความถูกต้องอย่างละเอียดก่อนเริ่มใช้งานจริง
