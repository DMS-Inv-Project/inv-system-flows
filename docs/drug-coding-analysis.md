# การศึกษาความสัมพันธ์ของรหัสยาในระบบโรงพยาบาล

## 📊 ผลการวิเคราะห์จากข้อมูลจริงในระบบ INVS เดิม

### 🔍 **สถิติการใช้รหัสยาในระบบ**
```
ยาทั้งหมด:        7,258 รายการ
มี TMT ID:        3,881 รายการ (53.5%)
มีรหัส 24 หลัก:    5,830 รายการ (80.3%)
```

### 📋 **โครงสร้างรหัสยาในระบบจริง**

#### 1. **Local Code (WORKING_CODE)** - 7 หลัก
```
Format: 1234567 (char(7))
Example: 1071130, 2260200, 1270030
ใช้เป็น: รหัสยาหลักของโรงพยาบาล (Generic Level)
```

#### 2. **Trade Code (TRADE_CODE)** - Variable Length
```
Format: VARCHAR(18)
Example: "10", "1002", "1003", "1006"
ใช้เป็น: รหัสสินค้าเฉพาะของ vendor/manufacturer
```

#### 3. **TMT ID (TMTID)** - BigInt
```
Format: bigint(20)
Example: 755730, 761922, 962966, 528624
ใช้เป็น: รหัสมาตรฐาน Thai Medical Terminology
Coverage: 53.5% ของยาในระบบ
```

#### 4. **24-Digit Code (24DIGIT)** - 24 หลัก
```
Format: char(24)
Example: 100099000003852110281777
        100419280000460210181506
        218050420749999930481506
ใช้เป็น: รหัสมาตรฐานระดับชาติ (24NC)
Coverage: 80.3% ของยาในระบบ
```

#### 5. **Standard Code (STD_CODE)** - 24 หลัก
```
Format: char(24)
Status: ส่วนใหญ่เป็น NULL ในข้อมูลตัวอย่าง
ใช้เป็น: รหัสมาตรฐานเพิ่มเติม (อาจเป็น backup หรือ alternative)
```

---

## 🔗 **ความสัมพันธ์ระหว่างรหัสยา (Relationship Analysis)**

### **📈 การ Mapping ระหว่างรหัส**

#### **Local Code → TMT ID: 1:n Relationship**
```sql
-- ตัวอย่างจากข้อมูลจริง
WORKING_CODE  →  TMTID
1071130       →  755730    (ยาชนิดเดียวกัน)
2260200       →  761922    (ยาชนิดเดียวกัน)
```
- หนึ่ง Working Code (Generic) สามารถมี TMT ID ได้หลายตัว
- TMT ID แยกตาม strength, dosage form, และ manufacturer

#### **Local Code → 24-Digit Code: 1:n Relationship**  
```sql
-- ตัวอย่างจากข้อมูลจริง
WORKING_CODE  →  24DIGIT
1071130       →  100099000003852110281777
2260200       →  100419280000460210181506
1260460       →  218050420749999930481506
```
- หนึ่ง Working Code สามารถมี 24-Digit Code ได้หลายตัว
- 24-Digit Code แยกตาม Trade Product และ Packaging

#### **TMT ID → 24-Digit Code: 1:1 หรือ 1:n Relationship**
```sql
-- ข้อมูลตัวอย่าง
TMTID    →  24DIGIT
755730   →  100099000003852110281777
761922   →  100419280000460210181506
962966   →  NULL (ไม่มี 24-digit)
528624   →  NULL (ไม่มี 24-digit)
```
- TMT ID บางตัวไม่มี 24-Digit Code
- TMT ID อาจมี 24-Digit Code ได้มากกว่า 1 ตัว (แยกตาม packaging)

---

## 🏗️ **โครงสร้างลำดับชั้นที่แนะนำ (Recommended Hierarchy)**

### **Level 1: Generic Level**
```
WORKING_CODE (7 หลัก) - Hospital Generic Drug Code
├── 1071130 (Generic Drug A)
├── 2260200 (Generic Drug B)
└── 1270030 (Generic Drug C)
```

### **Level 2: Product Level**  
```
TMT ID (Variable) - Thai Medical Terminology Product Code
├── 755730 (Product A1 - Strength 10mg)
├── 761922 (Product B1 - Strength 25mg)
└── 962966 (Product C1 - Tablet form)
```

### **Level 3: Package Level**
```
24-Digit Code (24 หลัก) - National Package Code
├── 100099000003852110281777 (Package A1-1)
├── 100419280000460210181506 (Package B1-1)
└── 218050420749999930481506 (Package Various)
```

### **Level 4: Trade Level**
```
TRADE_CODE (Variable) - Vendor/Manufacturer Specific Code
├── "10" (Vendor A Product)
├── "1002" (Vendor B Product)  
└── "1003" (Vendor C Product)
```

---

## 💡 **การวิเคราะห์โครงสร้าง 24-Digit Code**

### **รูปแบบที่พบในข้อมูล:**
```
100099000003852110281777 (24 หลัก)
│││││││││││││││││││││││└─── Check Digit? (4 หลัก)
││││││││││││││││││└────── Date/Version? (4 หลัก: 1028)
│││││││││││││└─────────── Product Code? (4 หลัก: 8521)
││││││││└──────────────── Manufacturer? (4 หลัก: 0385)
│││└─────────────────────── Category/ATC? (4 หลัก: 9000)
└──────────────────────────── Country/System? (2 หลัก: 10)
```

### **การแยกหมวดหมู่:**
```
10xxxx... = ระบบยาประเภท A
21xxxx... = ระบบยาประเภท B  
```

---

## 🔧 **ข้อเสนอแนะสำหรับระบบ INVS Modern**

### **1. Database Schema Enhancement**

```prisma
model DrugGeneric {
  id               BigInt    @id @default(autoincrement())
  workingCode      String    @unique @map("working_code") @db.VarChar(7)
  drugName         String    @map("drug_name") @db.VarChar(60)
  
  // เพิ่มเติมสำหรับการ mapping
  tmtVtmCode       String?   @map("tmt_vtm_code") @db.VarChar(10)
  tmtGpCode        String?   @map("tmt_gp_code") @db.VarChar(10)
  
  // Relations
  drugs            Drug[]
  tmtMappings      TmtMapping[]
}

model Drug {
  id               BigInt    @id @default(autoincrement())
  drugCode         String    @unique @map("drug_code") @db.VarChar(24)
  tradeName        String    @map("trade_name") @db.VarChar(100)
  genericId        BigInt?   @map("generic_id")
  
  // รหัสมาตรฐาน
  tmtProductId     BigInt?   @map("tmt_product_id")
  nc24Code         String?   @map("nc24_code") @db.VarChar(24)
  stdCode          String?   @map("std_code") @db.VarChar(24)
  
  // Relations
  generic          DrugGeneric? @relation(fields: [genericId], references: [id])
}

// ตารางเพิ่มเติมสำหรับ TMT Mapping
model TmtMapping {
  id               BigInt    @id @default(autoincrement())
  workingCode      String    @map("working_code") @db.VarChar(7)
  tmtId            BigInt    @map("tmt_id")
  tmtLevel         String    @map("tmt_level") @db.VarChar(10) // VTM, GP, GPU, TP, TPU
  nc24Code         String?   @map("nc24_code") @db.VarChar(24)
  mappingDate      DateTime  @map("mapping_date")
  isActive         Boolean   @default(true) @map("is_active")
  
  // Relations
  drugGeneric      DrugGeneric @relation(fields: [workingCode], references: [workingCode])
  
  @@map("tmt_mappings")
}
```

### **2. Migration Strategy จากระบบเดิม**

```sql
-- Migration Script สำหรับ import ข้อมูล mapping
INSERT INTO tmt_mappings (working_code, tmt_id, nc24_code, mapping_date, is_active)
SELECT 
    WORKING_CODE,
    TMTID,
    `24DIGIT`,
    NOW(),
    TRUE
FROM drug_vn 
WHERE TMTID IS NOT NULL;

-- Update drug codes with 24-digit codes
UPDATE drugs d
SET nc24_code = (
    SELECT `24DIGIT` 
    FROM drug_vn dv 
    WHERE dv.TRADE_CODE = d.drug_code 
    AND dv.`24DIGIT` IS NOT NULL
    LIMIT 1
);
```

### **3. API Design สำหรับ Code Lookup**

```typescript
// Service สำหรับการค้นหารหัสยา
interface DrugCodeLookup {
  workingCode: string;      // 7-digit local code
  tmtId?: number;           // TMT ID
  nc24Code?: string;        // 24-digit national code
  stdCode?: string;         // Standard code
  tradeCode?: string;       // Vendor trade code
}

class DrugCodeService {
  // ค้นหาจาก Working Code
  async findByWorkingCode(workingCode: string): Promise<DrugCodeLookup[]>
  
  // ค้นหาจาก TMT ID
  async findByTmtId(tmtId: number): Promise<DrugCodeLookup[]>
  
  // ค้นหาจาก 24-digit Code
  async findByNc24Code(nc24Code: string): Promise<DrugCodeLookup[]>
  
  // สร้าง mapping ใหม่
  async createMapping(mapping: DrugCodeLookup): Promise<void>
}
```

---

## 📊 **สรุปการวิเคราะห์**

### **✅ จุดแข็งของระบบปัจจุบัน**
1. **ครอบคลุม 80%** ของยามีรหัส 24 หลัก
2. **TMT Integration** มีอยู่แล้ว 53% ของยา
3. **Local Code** เป็น foundation ที่แข็งแกร่ง
4. **Multiple Code Support** รองรับรหัสหลายระดับ

### **⚠️ จุดที่ต้องปรับปรุง**
1. **TMT Coverage** ยังไม่ครบ 100%
2. **Standard Code** ใช้งานน้อย
3. **Documentation** ขาดคู่มือการใช้งาน
4. **Validation** ไม่มีระบบตรวจสอบความถูกต้อง

### **🎯 แนวทางการพัฒนา**
1. **Phase 1**: Migrate existing mappings จากระบบเดิม
2. **Phase 2**: เชื่อมต่อกับ TMT Browser API
3. **Phase 3**: Implement 24-digit code validation
4. **Phase 4**: สร้าง automated mapping system

**สรุป**: ระบบมีพื้นฐานที่ดีและข้อมูล mapping ที่มีคุณภาพ ต้องเพิ่มการจัดการและ validation เท่านั้น

---

*เอกสารนี้วิเคราะห์จากข้อมูลจริงในระบบ INVS และการวิจัยมาตรฐานรหัสยาของประเทศไทย*