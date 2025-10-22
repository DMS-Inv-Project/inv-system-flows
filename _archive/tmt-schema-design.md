# 🏗️ การปรับปรุงโครงสร้างฐานข้อมูลเพื่อรองรับ TMT Standard

## 📋 **สรุปการปรับปรุงที่จำเป็น**

### **1. ปรับปรุง Model เดิม**
- `DrugGeneric` - เพิ่มฟิลด์ TMT codes
- `Drug` - เพิ่มฟิลด์ TMT และ HPP support
- `Company` - เพิ่มข้อมูลผู้ผลิตตาม TMT

### **2. เพิ่ม Model ใหม่**
- `TmtConcept` - ข้อมูล TMT reference
- `TmtRelationship` - ความสัมพันธ์ระหว่าง concepts
- `HospitalPharmaceuticalProduct` - ยาโรงพยาบาล (HPP)
- `TmtMapping` - การจับคู่รหัสยา

### **3. เพิ่ม Enum ใหม่**
- `TmtLevel` - ระดับ TMT (SUBS, VTM, GP, TP, etc.)
- `HppType` - ประเภท HPP (R, M, F, X, OHPP)

---

## 🔧 **Schema การปรับปรุงแบบละเอียด**

### **1. ปรับปรุง DrugGeneric Model**

```prisma
model DrugGeneric {
  id               BigInt    @id @default(autoincrement())
  workingCode      String    @unique @map("working_code") @db.VarChar(7)
  drugName         String    @map("drug_name") @db.VarChar(60)
  dosageForm       String    @map("dosage_form") @db.VarChar(20)
  saleUnit         String    @map("sale_unit") @db.VarChar(5)
  composition      String?   @db.VarChar(50)
  strength         Decimal?  @db.Decimal(10, 2)
  strengthUnit     String?   @map("strength_unit") @db.VarChar(20)
  isActive         Boolean   @default(true) @map("is_active")
  createdAt        DateTime  @default(now()) @map("created_at")

  // 🆕 TMT Fields
  tmtVtmCode       String?   @map("tmt_vtm_code") @db.VarChar(10)     // VTM Code
  tmtVtmId         BigInt?   @map("tmt_vtm_id")                       // VTM TMTID
  tmtGpCode        String?   @map("tmt_gp_code") @db.VarChar(10)      // GP Code  
  tmtGpId          BigInt?   @map("tmt_gp_id")                        // GP TMTID
  tmtGpfCode       String?   @map("tmt_gpf_code") @db.VarChar(10)     // GP-F (Hospital Formula)
  tmtGpfId         BigInt?   @map("tmt_gpf_id")                       // GP-F TMTID
  tmtGpxCode       String?   @map("tmt_gpx_code") @db.VarChar(10)     // GP-X (Extemporaneous)
  tmtGpxId         BigInt?   @map("tmt_gpx_id")                       // GP-X TMTID
  
  // Standard Codes
  tmtCode          String?   @map("tmt_code") @db.VarChar(10)         // รหัสมาตรฐาน กสธ.
  standardUnit     String?   @map("standard_unit") @db.VarChar(10)    // หน่วยมาตรฐาน
  therapeuticGroup String?   @map("therapeutic_group") @db.VarChar(50) // กลุ่มยา
  
  // Relations
  drugs            Drug[]
  purchaseRequestItems PurchaseRequestItem[]
  tmtMappings      TmtMapping[]
  hppProducts      HospitalPharmaceuticalProduct[]

  @@map("drug_generics")
}
```

### **2. ปรับปรุง Drug Model**

```prisma
model Drug {
  id               BigInt    @id @default(autoincrement())
  drugCode         String    @unique @map("drug_code") @db.VarChar(24)
  tradeName        String    @map("trade_name") @db.VarChar(100)
  genericId        BigInt?   @map("generic_id")
  strength         String?   @db.VarChar(50)
  dosageForm       String?   @map("dosage_form") @db.VarChar(30)
  manufacturerId   BigInt?   @map("manufacturer_id")
  atcCode          String?   @map("atc_code") @db.VarChar(10)
  standardCode     String?   @map("standard_code") @db.VarChar(24)
  barcode          String?   @db.VarChar(20)
  packSize         Int       @default(1) @map("pack_size")
  unit             String    @default("TAB") @db.VarChar(10)
  isActive         Boolean   @default(true) @map("is_active")
  createdAt        DateTime  @default(now()) @map("created_at")
  updatedAt        DateTime  @default(now()) @updatedAt @map("updated_at")

  // 🆕 TMT Fields
  tmtTpCode        String?   @map("tmt_tp_code") @db.VarChar(10)      // TP Code
  tmtTpId          BigInt?   @map("tmt_tp_id")                        // TP TMTID
  tmtTpuCode       String?   @map("tmt_tpu_code") @db.VarChar(10)     // TPU Code
  tmtTpuId         BigInt?   @map("tmt_tpu_id")                       // TPU TMTID
  tmtTppCode       String?   @map("tmt_tpp_code") @db.VarChar(10)     // TPP Code
  tmtTppId         BigInt?   @map("tmt_tpp_id")                       // TPP TMTID
  
  // National Codes
  nc24Code         String?   @map("nc24_code") @db.VarChar(24)        // 24-digit National Code
  registrationNumber String? @map("registration_number") @db.VarChar(20) // เลขทะเบียน อย.
  gpoCode          String?   @map("gpo_code") @db.VarChar(15)         // รหัส อปท.
  
  // 🆕 HPP Fields
  hppType          HppType?  @map("hpp_type")                        // ประเภท HPP
  specPrep         String?   @map("spec_prep") @db.VarChar(10)       // R1, M2, F3, X1
  isHpp            Boolean   @default(false) @map("is_hpp")          // เป็น HPP หรือไม่
  baseProductId    BigInt?   @map("base_product_id")                 // อ้างอิง trade product เดิม (สำหรับ R, M)
  formulaReference String?   @map("formula_reference")               // อ้างอิงเภสัชตำรับ (สำหรับ F)

  // Relations
  generic          DrugGeneric? @relation(fields: [genericId], references: [id])
  manufacturer     Company?  @relation(fields: [manufacturerId], references: [id])
  baseProduct      Drug?     @relation("HppBaseProduct", fields: [baseProductId], references: [id])
  derivedProducts  Drug[]    @relation("HppBaseProduct")
  inventory        Inventory[]
  drugLots         DrugLot[]
  purchaseOrderItems PurchaseOrderItem[]
  receiptItems     ReceiptItem[]
  tmtMappings      TmtMapping[]
  hppProducts      HospitalPharmaceuticalProduct[]

  @@map("drugs")
}
```

### **3. เพิ่ม Model ใหม่: TMT Concept**

```prisma
// ตารางเก็บข้อมูล TMT Reference จาก SNAPSHOT files
model TmtConcept {
  id               BigInt    @id @default(autoincrement())
  tmtId            BigInt    @unique @map("tmt_id")                  // TMTID จาก TMT
  conceptCode      String?   @map("concept_code") @db.VarChar(20)    // รหัส concept
  level            TmtLevel  @map("level")                           // ระดับ TMT
  fsn              String    @map("fsn") @db.VarChar(500)           // Fully Specified Name
  preferredTerm    String?   @map("preferred_term") @db.VarChar(300) // ชื่อที่ใช้
  
  // Attributes from TMT
  strength         String?   @db.VarChar(100)                       // ความแรง
  dosageForm       String?   @map("dosage_form") @db.VarChar(50)    // รูปแบบยา
  manufacturer     String?   @db.VarChar(100)                       // ผู้ผลิต
  packSize         String?   @map("pack_size") @db.VarChar(50)      // ขนาดบรรจุ
  unitOfUse        String?   @map("unit_of_use") @db.VarChar(20)    // หน่วยการใช้
  
  // Status
  isActive         Boolean   @default(true) @map("is_active")
  effectiveDate    DateTime? @map("effective_date")                 // วันที่มีผล
  releaseDate      String?   @map("release_date") @db.VarChar(20)   // Release version
  createdAt        DateTime  @default(now()) @map("created_at")
  updatedAt        DateTime  @default(now()) @updatedAt @map("updated_at")

  // Relations
  parentRelations  TmtRelationship[] @relation("ParentConcept")
  childRelations   TmtRelationship[] @relation("ChildConcept")
  mappings         TmtMapping[]

  @@map("tmt_concepts")
}
```

### **4. เพิ่ม Model ใหม่: TMT Relationship**

```prisma
// ตารางเก็บความสัมพันธ์ระหว่าง TMT Concepts
model TmtRelationship {
  id               BigInt    @id @default(autoincrement())
  parentId         BigInt    @map("parent_id")                      // TMT Concept ระดับบน
  childId          BigInt    @map("child_id")                       // TMT Concept ระดับล่าง
  relationshipType TmtRelationType @map("relationship_type")        // ประเภทความสัมพันธ์
  
  // Attributes
  isActive         Boolean   @default(true) @map("is_active")
  effectiveDate    DateTime? @map("effective_date")
  releaseDate      String?   @map("release_date") @db.VarChar(20)
  createdAt        DateTime  @default(now()) @map("created_at")

  // Relations
  parent           TmtConcept @relation("ParentConcept", fields: [parentId], references: [id])
  child            TmtConcept @relation("ChildConcept", fields: [childId], references: [id])

  @@unique([parentId, childId, relationshipType])
  @@map("tmt_relationships")
}
```

### **5. เพิ่ม Model ใหม่: Hospital Pharmaceutical Product**

```prisma
// ตารางเฉพาะสำหรับยาโรงพยาบาล (HPP)
model HospitalPharmaceuticalProduct {
  id               BigInt    @id @default(autoincrement())
  hppCode          String    @unique @map("hpp_code") @db.VarChar(20) // รหัส HPP
  hppType          HppType   @map("hpp_type")                       // R, M, F, X, OHPP
  
  // Product Info
  productName      String    @map("product_name") @db.VarChar(200)  // ชื่อผลิตภัณฑ์
  genericId        BigInt?   @map("generic_id")                     // อ้างอิง DrugGeneric
  drugId           BigInt?   @map("drug_id")                        // อ้างอิง Drug (สำหรับ Trade)
  baseProductId    BigInt?   @map("base_product_id")                // ยาต้นแบบ (สำหรับ R, M)
  
  // Specifications
  strength         String?   @db.VarChar(100)                       // ความแรงใหม่
  dosageForm       String?   @map("dosage_form") @db.VarChar(50)    // รูปแบบยาใหม่
  packSize         String?   @map("pack_size") @db.VarChar(50)      // ขนาดบรรจุใหม่
  unitOfUse        String?   @map("unit_of_use") @db.VarChar(20)    // หน่วยการใช้
  
  // Formula Reference (สำหรับ F และ X)
  formulaReference String?   @map("formula_reference")              // อ้างอิงเภสัชตำรับ
  formulaSource    String?   @map("formula_source") @db.VarChar(100) // แหล่งที่มาสูตร
  
  // TMT Mapping
  tmtCode          String?   @map("tmt_code") @db.VarChar(10)       // TMT Code ที่เกี่ยวข้อง
  tmtId            BigInt?   @map("tmt_id")                         // TMT ID ที่เกี่ยวข้อง
  specPrep         String?   @map("spec_prep") @db.VarChar(10)      // R1, M2, F3, X1
  
  // Outsourcing (สำหรับ OHPP)
  isOutsourced     Boolean   @default(false) @map("is_outsourced")  // จำหน่ายให้โรงพยาบาลอื่น
  hospitalCode     String?   @map("hospital_code") @db.VarChar(10)  // รหัสโรงพยาบาลผู้ผลิต
  
  // Status
  isActive         Boolean   @default(true) @map("is_active")
  approvedBy       String?   @map("approved_by") @db.VarChar(50)    // ผู้อนุมัติ
  approvalDate     DateTime? @map("approval_date")                  // วันที่อนุมัติ
  createdAt        DateTime  @default(now()) @map("created_at")
  updatedAt        DateTime  @default(now()) @updatedAt @map("updated_at")

  // Relations
  generic          DrugGeneric? @relation(fields: [genericId], references: [id])
  drug             Drug?     @relation(fields: [drugId], references: [id])
  baseProduct      Drug?     @relation("HppBaseReference", fields: [baseProductId], references: [id])

  @@map("hospital_pharmaceutical_products")
}
```

### **6. เพิ่ม Model ใหม่: TMT Mapping**

```prisma
// ตารางสำหรับจับคู่รหัสยาภายในกับ TMT
model TmtMapping {
  id               BigInt    @id @default(autoincrement())
  
  // Local Reference
  workingCode      String?   @map("working_code") @db.VarChar(7)    // รหัสยา 7 หลัก
  drugCode         String?   @map("drug_code") @db.VarChar(24)      // รหัสยา 24 หลัก
  genericId        BigInt?   @map("generic_id")                     // อ้างอิง DrugGeneric
  drugId           BigInt?   @map("drug_id")                        // อ้างอิง Drug
  
  // TMT Reference
  tmtLevel         TmtLevel  @map("tmt_level")                      // ระดับ TMT
  tmtConceptId     BigInt    @map("tmt_concept_id")                 // อ้างอิง TmtConcept
  tmtCode          String?   @map("tmt_code") @db.VarChar(10)       // TMT Code
  tmtId            BigInt    @map("tmt_id")                         // TMT ID
  
  // Mapping Info
  mappingSource    String?   @map("mapping_source") @db.VarChar(50) // แหล่งที่มาการ mapping
  confidence       Decimal?  @db.Decimal(3, 2)                     // ความมั่นใจ (0.00-1.00)
  mappedBy         String?   @map("mapped_by") @db.VarChar(50)      // ผู้ทำ mapping
  verifiedBy       String?   @map("verified_by") @db.VarChar(50)    // ผู้ตรวจสอบ
  
  // Status
  isActive         Boolean   @default(true) @map("is_active")
  isVerified       Boolean   @default(false) @map("is_verified")    // ตรวจสอบแล้ว
  mappingDate      DateTime  @map("mapping_date")                   // วันที่ mapping
  verificationDate DateTime? @map("verification_date")              // วันที่ตรวจสอบ
  createdAt        DateTime  @default(now()) @map("created_at")
  updatedAt        DateTime  @default(now()) @updatedAt @map("updated_at")

  // Relations
  generic          DrugGeneric? @relation(fields: [genericId], references: [id])
  drug             Drug?     @relation(fields: [drugId], references: [id])
  tmtConcept       TmtConcept @relation(fields: [tmtConceptId], references: [id])

  @@map("tmt_mappings")
}
```

---

## 🏷️ **Enum ใหม่**

### **1. TMT Level Enum**

```prisma
enum TmtLevel {
  SUBS             @map("SUBS")      // Substance
  VTM              @map("VTM")       // Virtual Therapeutic Moiety  
  GP               @map("GP")        // Generic Product
  TP               @map("TP")        // Trade Product
  GPU              @map("GPU")       // Generic Product Use
  TPU              @map("TPU")       // Trade Product Use
  GPP              @map("GPP")       // Generic Product Pack
  TPP              @map("TPP")       // Trade Product Pack
  GP_F             @map("GP-F")      // Generic Product - Hospital Formula
  GP_X             @map("GP-X")      // Generic Product - Extemporaneous
}
```

### **2. HPP Type Enum**

```prisma
enum HppType {
  REPACKAGED       @map("R")         // ยาบรรจุใหม่
  MODIFIED         @map("M")         // ยาปรุงใหม่
  HOSPITAL_FORMULA @map("F")         // ยาตามเภสัชตำรับ
  EXTEMPORANEOUS   @map("X")         // ยาเตรียมเฉพาะราย
  OUTSOURCED       @map("OHPP")      // ยาจำหน่ายให้โรงพยาบาลอื่น
}
```

### **3. TMT Relationship Type Enum**

```prisma
enum TmtRelationType {
  IS_A             @map("IS_A")      // ความสัมพันธ์แบบ parent-child
  HAS_ACTIVE_INGREDIENT @map("HAS_ACTIVE_INGREDIENT")
  HAS_DOSE_FORM    @map("HAS_DOSE_FORM")
  HAS_MANUFACTURER @map("HAS_MANUFACTURER")
  HAS_PACK_SIZE    @map("HAS_PACK_SIZE")
  HAS_STRENGTH     @map("HAS_STRENGTH")
  HAS_UNIT_OF_USE  @map("HAS_UNIT_OF_USE")
}
```

---

## 📝 **สรุปการเปลี่ยนแปลง**

### **Tables เดิมที่ปรับปรุง:**
1. **`drug_generics`** - เพิ่ม TMT codes (VTM, GP, GP-F, GP-X)
2. **`drugs`** - เพิ่ม TMT codes (TP, TPU, TPP) และ HPP support

### **Tables ใหม่ที่เพิ่ม:**
1. **`tmt_concepts`** - ข้อมูล TMT reference (15,000+ records)
2. **`tmt_relationships`** - ความสัมพันธ์ TMT (50,000+ records)
3. **`hospital_pharmaceutical_products`** - ยาโรงพยาบาล HPP
4. **`tmt_mappings`** - การจับคู่รหัสยา

### **Enums ใหม่:**
1. **`TmtLevel`** - ระดับ TMT (8 levels)
2. **`HppType`** - ประเภท HPP (5 types)
3. **`TmtRelationType`** - ประเภทความสัมพันธ์ TMT

### **ประโยชน์ที่ได้:**
- รองรับมาตรฐาน TMT ครบถ้วน
- รองรับยาโรงพยาบาล (HPP)
- เชื่อมต่อกับระบบภายนอกได้
- ส่งรายงานให้ กสธ. ตามมาตรฐาน
- Backward compatibility กับระบบเดิม

---

*เอกสารนี้แสดงการปรับปรุงโครงสร้างฐานข้อมูลแบบครบถ้วนเพื่อรองรับมาตรฐาน TMT*