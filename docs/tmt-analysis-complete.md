# 🎯 การวิเคราะห์รหัสยา TMT และความสัมพันธ์กับระบบ INVS Modern

## 📋 **สรุปผลการวิเคราะห์จากเอกสาร TMT**

จากการศึกษาเอกสาร **TMT in Summary V3** และข้อมูล **TMTRF20250915** พบข้อมูลสำคัญดังนี้:

### 🏗️ **โครงสร้าง TMT (Thai Medicines Terminology)**

#### **8 ระดับของ TMT Concepts:**

1. **SUBS (Substance)** - สารตั้งต้น
2. **VTM (Virtual Therapeutic Moiety)** - สารที่ออกฤทธิ์ทางยา
3. **GP (Generic Product)** - ยาชื่อสามัญ (+ Strength + Dosage Form)
4. **TP (Trade Product)** - ยาชื่อการค้า (+ Manufacturer)
5. **GPU (Generic Product Use)** - ยาชื่อสามัญและหน่วยการใช้
6. **TPU (Trade Product Use)** - ยาชื่อการค้าและหน่วยการใช้
7. **GPP (Generic Product Pack)** - ยาชื่อสามัญและขนาดบรรจุ
8. **TPP (Trade Product Pack)** - ยาชื่อการค้าและขนาดบรรจุ

### 🔗 **ความสัมพันธ์ TMT กับระบบ INVS Modern**

#### **การ Mapping รหัสยา:**

```
ระบบ INVS Modern          →    TMT Hierarchy
-----------------------------------------------------
WORKING_CODE (7 หลัก)     →    GP/VTM Level
DRUG_CODE (24 หลัก)       →    TPU/TPP Level  
TMT_ID                    →    TP/TPU Level
NC24_CODE                 →    National Level
```

#### **ความสัมพันธ์ Hierarchy:**
```
SUBS → VTM → GP → TP → TPU → TPP
              ↓     ↓
             GPU → GPP
```

---

## 🔍 **การวิเคราะห์เทียบกับข้อมูลจริงในระบบ**

### **จากข้อมูล MySQL เดิม:**
- ยาทั้งหมด: **7,258 รายการ**
- มี TMT ID: **3,881 รายการ (53.5%)**
- มีรหัส 24 หลัก: **5,830 รายการ (80.3%)**

### **จากเอกสาร TMT Standard:**
- TMT Release: **TMTRF20250915** (ใช้ได้ถึง 15 ก.ย. 2568)
- ครอบคลุม: **8 Concepts** ระดับต่างกัน
- รองรับ: **Hospital Pharmaceutical Products (HPP)**

---

## 💡 **ข้อค้นพบสำคัญจากเอกสาร TMT**

### **1. Hospital Pharmaceutical Products (HPP)**

TMT รองรับยาโรงพยาบาล 4 ประเภท:

#### **R (Repackaged)** - ยาบรรจุใหม่
- นำยาสำเร็จรูปมาเปลี่ยนขนาดบรรจุ
- ใช้ TMTID ระดับ **TP**
- SpecPrep: "R1", "R2", "R3"...

#### **M (Modified)** - ยาปรุงใหม่  
- เปลี่ยนรูปแบบยาหรือความแรง
- ใช้ TMTID ระดับ **TP**
- SpecPrep: "M1", "M2", "M3"...

#### **F (Hospital Formula)** - ยาโรงพยาบาลตามเภสัชตำรับ
- ผลิตจากเภสัชตำรับมาตรฐาน
- ใช้ TMTID ระดับ **GP-F**
- SpecPrep: "F1", "F2", "F3"...

#### **X (Extemporaneous)** - ยาเตรียมเฉพาะราย
- สูตรผสมเฉพาะผู้ป่วย (เช่น TPN)
- ใช้ TMTID ระดับ **GP-X**
- SpecPrep: "X1", "X2", "X3"...

### **2. OHPP (Outsourced Hospital Pharmaceutical Product)**
- HPP ที่จำหน่ายให้โรงพยาบาลอื่น
- มีสถานะเทียบเท่า Trade Product
- ใช้ TMTID ระดับ **TPU**

---

## 🔧 **ข้อเสนอแนะการปรับปรุงระบบ INVS Modern**

### **1. เพิ่มฟิลด์ TMT Standard**

```prisma
model DrugGeneric {
  // ... existing fields
  tmtVtmCode       String?   @map("tmt_vtm_code") @db.VarChar(10)
  tmtGpCode        String?   @map("tmt_gp_code") @db.VarChar(10)
  tmtGpfCode       String?   @map("tmt_gpf_code") @db.VarChar(10) // GP-F
  tmtGpxCode       String?   @map("tmt_gpx_code") @db.VarChar(10) // GP-X
}

model Drug {
  // ... existing fields
  tmtTpCode        String?   @map("tmt_tp_code") @db.VarChar(10)
  tmtTpuCode       String?   @map("tmt_tpu_code") @db.VarChar(10)
  tmtTppCode       String?   @map("tmt_tpp_code") @db.VarChar(10)
  specPrep         String?   @map("spec_prep") @db.VarChar(10)    // R1, M2, F3, X1
  hppType          HppType?  @map("hpp_type")                    // R, M, F, X, OHPP
}

enum HppType {
  REPACKAGED         @map("R")    // ยาบรรจุใหม่
  MODIFIED           @map("M")    // ยาปรุงใหม่
  HOSPITAL_FORMULA   @map("F")    // ยาตามเภสัชตำรับ
  EXTEMPORANEOUS     @map("X")    // ยาเฉพาะราย
  OUTSOURCED         @map("OHPP") // ยาจำหน่าย
}
```

### **2. ตาราง TMT Mapping**

```prisma
model TmtMapping {
  id               BigInt    @id @default(autoincrement())
  workingCode      String    @map("working_code") @db.VarChar(7)
  tmtLevel         TmtLevel  @map("tmt_level")
  tmtCode          String    @map("tmt_code") @db.VarChar(10)
  tmtId            BigInt    @map("tmt_id")
  fsn              String?   @map("fsn") @db.VarChar(500)         // Fully Specified Name
  mappingDate      DateTime  @map("mapping_date")
  isActive         Boolean   @default(true) @map("is_active")
  
  @@map("tmt_mappings")
}

enum TmtLevel {
  SUBS   @map("SUBS")
  VTM    @map("VTM")
  GP     @map("GP")
  TP     @map("TP")
  GPU    @map("GPU")
  TPU    @map("TPU")
  GPP    @map("GPP")
  TPP    @map("TPP")
  GP_F   @map("GP-F")   // Hospital Formula
  GP_X   @map("GP-X")   // Extemporaneous
}
```

### **3. Hospital Pharmaceutical Products (HPP)**

```prisma
model HospitalPharmaceuticalProduct {
  id               BigInt    @id @default(autoincrement())
  hppCode          String    @unique @map("hpp_code") @db.VarChar(20)
  hppType          HppType   @map("hpp_type")
  baseProductId    BigInt?   @map("base_product_id")    // อ้างอิง trade product เดิม
  specPrep         String    @map("spec_prep") @db.VarChar(10)
  tmtCode          String?   @map("tmt_code") @db.VarChar(10)
  formulaReference String?   @map("formula_reference")  // อ้างอิงเภสัชตำรับ
  isOutsourced     Boolean   @default(false) @map("is_outsourced")
  
  // Relations
  baseProduct      Drug?     @relation(fields: [baseProductId], references: [id])
  
  @@map("hospital_pharmaceutical_products")
}
```

---

## 📊 **การใช้งาน TMT SNAPSHOT Files**

### **ไฟล์หลักที่ได้รับ:**

1. **TMTRF20250915_SNAPSHOT.xls** - ข้อมูลหลักทั้งหมด
2. **TMTRF20250915_FULL.xls** - ข้อมูลเต็ม
3. **TMTRF20250915_DELTA.xls** - ข้อมูลที่เปลี่ยนแปลง

### **BONUS Files:**
#### **Concept Files:**
- `VTM20250915.xls` - Virtual Therapeutic Moiety
- `GP20250915.xls` - Generic Product  
- `TP20250915.xls` - Trade Product
- `GPU20250915.xls` - Generic Product Use
- `TPU20250915.xls` - Trade Product Use
- `GPP20250915.xls` - Generic Product Pack
- `TPP20250915.xls` - Trade Product Pack

#### **Relationship Files:**
- `VTMtoGP20250915.xls` - VTM → GP mapping
- `GPtoTP20250915.xls` - GP → TP mapping  
- `GPtoGPU20250915.xls` - GP → GPU mapping
- `GPUtoTPU20250915.xls` - GPU → TPU mapping

### **วิธีการใช้งาน (ตามเอกสาร):**

#### **1. ค้นหาจากชื่อการค้า (Trade Name)**
```excel
1. เปิด TMTRF20250915_SNAPSHOT.xls
2. ใช้ Filter ที่คอลัมน์ FSN
3. พิมพ์ชื่อยา เช่น "crestor"
4. จะได้รหัส TMTID และข้อมูลครบถ้วน
```

#### **2. ค้นหาจากชื่อสามัญ (Generic Name)**
```excel
1. ใช้ Filter ที่คอลัมน์ FSN
2. พิมพ์ชื่อสามัญ เช่น "rosuvastatin"  
3. จะได้รายการทั้งหมดที่เกี่ยวข้อง
```

#### **3. Mapping แบบ Bulk**
```excel
1. วางรายการยาโรงพยาบาลใน Column A-B
2. วาง TMT SNAPSHOT ข้างๆ
3. ลาก TMTID และ FSN มาจับคู่
4. เพิ่ม Local Code mapping
```

---

## ✅ **สรุปและข้อเสนอแนะ**

### **จุดแข็งของระบบปัจจุบัน:**
- มี TMT ID ครอบคลุม **53.5%** ของยา
- มีรหัส 24 หลัก **80.3%** ของยา  
- โครงสร้างรองรับ TMT Hierarchy

### **สิ่งที่ต้องปรับปรุง:**
1. **เพิ่ม TMT Mapping Table** สำหรับจัดการ relationship
2. **รองรับ HPP (Hospital Pharmaceutical Products)** 
3. **Import TMT SNAPSHOT data** เป็น reference
4. **สร้าง API endpoints** สำหรับ TMT lookup

### **การดำเนินการต่อไป:**
1. **Phase 1**: เพิ่ม schema รองรับ TMT 
2. **Phase 2**: Import TMT reference data
3. **Phase 3**: สร้าง mapping tools
4. **Phase 4**: Integration กับ TMT Browser API

### **ประโยชน์ที่จะได้รับ:**
- **มาตรฐานระดับชาติ**: ใช้รหัสมาตรฐาน TMT
- **ความเข้ากันได้**: เชื่อมต่อกับระบบอื่นได้ง่าย
- **การรายงาน**: ส่งข้อมูลให้ กสธ. ตามมาตรฐาน
- **HPP Support**: รองรับยาที่ผลิตในโรงพยาบาล

---

*เอกสารนี้สรุปจากการวิเคราะห์ TMT Summary V3 และข้อมูล TMTRF20250915 จากกระทรวงสาธารณสุข*