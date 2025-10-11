# 📥 TMT Data Import & Sync Guide

คู่มือการใช้งาน scripts สำหรับ import และ sync ข้อมูล TMT (Thai Medical Terminology) 

## 🚀 **Quick Start**

### 1. ติดตั้ง Dependencies
```bash
npm install xlsx
```

### 2. Import ข้อมูล TMT ครั้งแรก
```bash
npm run tmt:import
```

### 3. ตรวจสอบสถิติ
```bash
npm run tmt:stats
```

---

## 📋 **Available Scripts**

### **Import Scripts**
```bash
# Import ข้อมูล TMT ทั้งหมด (แรกครั้ง)
npm run tmt:import

# Import เฉพาะ TMT Concepts
npm run tmt:import:concepts

# Import เฉพาะ TMT Relationships  
npm run tmt:import:relationships

# อัพเดทรหัสยาเท่านั้น
npm run tmt:update-codes

# แสดงสถิติปัจจุบัน
npm run tmt:stats
```

### **Sync Scripts (เมื่อมีการอัพเดท)**
```bash
# Sync ข้อมูลใหม่จากกระทรวงสาธารณสุข
npm run tmt:sync /path/to/new/tmt/data

# สร้าง backup เท่านั้น
node scripts/sync-tmt-updates.js /path/to/new/data --backup-only

# ตรวจสอบการเปลี่ยนแปลงเท่านั้น
node scripts/sync-tmt-updates.js /path/to/new/data --detect-only

# ตรวจสอบความถูกต้องของข้อมูลปัจจุบัน
node scripts/sync-tmt-updates.js /path/to/new/data --validate-only
```

---

## 📁 **โครงสร้างไฟล์ TMT Data**

### **ไฟล์ที่ต้องมีสำหรับ Import**
```
docs/manual-invs/TMTRF20250915/
├── TMTRF20250915_SNAPSHOT.xls     # ข้อมูลหลักทั้งหมด
├── VTMtoGP20250915.xls            # ความสัมพันธ์ VTM → GP
├── GPtoTP20250915.xls             # ความสัมพันธ์ GP → TP
├── GPtoGPU20250915.xls            # ความสัมพันธ์ GP → GPU
└── GPUtoTPU20250915.xls           # ความสัมพันธ์ GPU → TPU
```

### **โครงสร้างไฟล์ Backup**
```
backups/
└── tmt-backup-2025-10-05T14-30-00-000Z/
    ├── metadata.json              # ข้อมูลสถิติ backup
    ├── tmt_concepts.json          # TMT Concepts
    ├── tmt_relationships.json     # TMT Relationships
    ├── tmt_mappings.json          # TMT Mappings
    ├── drug_generics_tmt.json     # รหัส TMT ใน Drug Generics
    └── drugs_tmt.json             # รหัส TMT ใน Drugs
```

### **โครงสร้างไฟล์ Logs**
```
logs/
├── tmt-update-2025-10-05.json     # Log การ update
└── tmt-update-report-2025-10-05.json  # รายงานการ update
```

---

## 🔧 **การใช้งานแบบละเอียด**

### **1. Import ข้อมูล TMT ครั้งแรก**

```bash
# Import ทั้งหมด
node scripts/import-tmt-data.js

# หรือใช้ npm script
npm run tmt:import
```

**สิ่งที่จะเกิดขึ้น:**
1. อ่านไฟล์ `TMTRF20250915_SNAPSHOT.xls`
2. Import TMT Concepts (~15,000+ records)
3. Import TMT Relationships (~50,000+ records)  
4. อัพเดทรหัส TMT ใน Drug Generics และ Drugs
5. สร้าง TMT Mappings สำหรับการเชื่อมโยง

### **2. Sync ข้อมูลเมื่อมีการอัพเดท**

```bash
# เมื่อได้รับไฟล์ TMT ใหม่จากกระทรวงสาธารณสุข
node scripts/sync-tmt-updates.js /path/to/new/TMTRF20251201/
```

**สิ่งที่จะเกิดขึ้น:**
1. สร้าง Backup ข้อมูลเดิมอัตโนมัติ
2. เปรียบเทียบข้อมูลใหม่กับข้อมูลเดิม
3. ตรวจหา Concepts ใหม่, อัพเดท, หรือ inactive
4. อัพเดทรหัสยาในระบบตามการเปลี่ยนแปลง
5. ตรวจสอบความถูกต้องของข้อมูล
6. สร้างรายงานการอัพเดท

### **3. การ Import แบบ Selective**

```bash
# Import เฉพาะ Concepts
npm run tmt:import:concepts

# Import เฉพาะ Relationships
npm run tmt:import:relationships

# อัพเดทรหัสยาเท่านั้น
npm run tmt:update-codes

# Debug mode
node scripts/import-tmt-data.js --debug
```

---

## 📊 **การตรวจสอบสถิติ**

### **แสดงสถิติปัจจุบัน**
```bash
npm run tmt:stats
```

**Output:**
```
[INFO] === TMT Import Statistics ===
[INFO] TMT Concepts: 15847
[INFO] TMT Relationships: 52341  
[INFO] TMT Mappings: 1205
[INFO] Drug Generics with TMT: 892
[INFO] Drugs with TMT: 1456
```

### **ตรวจสอบ TMT Coverage**
```sql
-- ดู Drug Generics ที่มี TMT code
SELECT 
  COUNT(*) as total_generics,
  COUNT(tmt_gp_code) as with_gp_code,
  COUNT(tmt_vtm_code) as with_vtm_code,
  ROUND(COUNT(tmt_gp_code)::DECIMAL / COUNT(*) * 100, 2) as gp_coverage_percent
FROM drug_generics 
WHERE is_active = true;

-- ดู Drugs ที่มี TMT code  
SELECT 
  COUNT(*) as total_drugs,
  COUNT(tmt_tpu_code) as with_tpu_code,
  COUNT(nc24_code) as with_nc24_code,
  ROUND(COUNT(tmt_tpu_code)::DECIMAL / COUNT(*) * 100, 2) as tpu_coverage_percent
FROM drugs 
WHERE is_active = true;
```

---

## ⚙️ **Configuration**

### **ปรับแต่งการทำงาน** (`import-tmt-data.js`)
```javascript
const CONFIG = {
  dataPath: '/path/to/tmt/data',     // Path ของไฟล์ TMT
  batchSize: 1000,                   // จำนวน records ต่อ batch
  logLevel: 'info'                   // debug, info, warn, error
};
```

### **ปรับแต่งการ Sync** (`sync-tmt-updates.js`)
```javascript
const CONFIG = {
  backupPath: './backups',           // Path สำหรับ backup
  logPath: './logs',                 // Path สำหรับ logs
  batchSize: 500,                    // จำนวน records ต่อ batch
  logLevel: 'info'                   // debug, info, warn, error
};
```

---

## 🛠️ **Troubleshooting**

### **1. ปัญหาการอ่านไฟล์ Excel**
```bash
# ตรวจสอบว่าไฟล์มีอยู่และ readable
ls -la docs/manual-invs/TMTRF20250915/
```

**แก้ไข:**
- ตรวจสอบ path ของไฟล์
- ตรวจสอบ permission
- ตรวจสอบว่าไฟล์ไม่เสียหาย

### **2. Memory Error (ข้อมูลใหญ่)**
```bash
# เพิ่ม memory limit
node --max-old-space-size=4096 scripts/import-tmt-data.js
```

**แก้ไข:**
- ลด `batchSize` ใน config
- Import แบบแยกขั้นตอน
- ใช้ `--concepts-only` หรือ `--relationships-only`

### **3. Database Connection Error**
```bash
# ตรวจสอบการเชื่อมต่อ database
docker exec invs-modern-db psql -U invs_user -d invs_modern -c "SELECT 1"
```

**แก้ไข:**
- ตรวจสอบ DATABASE_URL ใน `.env`
- ตรวจสอบว่า PostgreSQL container ทำงาน
- รัน `npx prisma generate`

### **4. TMT Mapping Issues**
```bash
# ตรวจสอบ orphaned mappings
node scripts/sync-tmt-updates.js /path/to/data --validate-only
```

**แก้ไข:**
- รัน validation script
- ตรวจสอบ log files
- Re-import ข้อมูลใหม่หากจำเป็น

---

## 📋 **Best Practices**

### **1. ก่อน Import ข้อมูลใหญ่**
```bash
# สร้าง backup ก่อน
npm run tmt:sync /dummy/path --backup-only

# ทดสอบกับข้อมูลน้อยก่อน
node scripts/import-tmt-data.js --concepts-only --debug
```

### **2. การ Monitor**
```bash
# ตรวจสอบ logs อย่างสม่ำเสมอ
tail -f logs/tmt-update-$(date +%Y-%m-%d).json

# ตรวจสอบสถิติหลัง import
npm run tmt:stats
```

### **3. การ Backup**
```bash
# สร้าง backup manual ก่อนการอัพเดทใหญ่
node scripts/sync-tmt-updates.js /path/to/data --backup-only

# เก็บ backup ไว้อย่างน้อย 3 versions
```

### **4. การ Validate**
```bash
# Validate หลังการ import
node scripts/sync-tmt-updates.js /dummy/path --validate-only

# ตรวจสอบ data integrity  
npx prisma studio
```

---

## 📞 **การติดต่อ & Support**

หากพบปัญหาหรือต้องการความช่วยเหลือ:

1. ตรวจสอบ log files ใน `logs/` directory
2. รัน validation script
3. ตรวจสอบ database connection
4. ดู error messages ใน console

สำหรับข้อมูลเพิ่มเติมเกี่ยวกับ TMT Standard:
- เอกสาร TMT Summary V3 จากกระทรวงสาธารณสุข
- ไฟล์ข้อมูล TMT Reference ใน `docs/manual-invs/`

---

*เอกสารนี้อัพเดทล่าสุด: 5 ตุลาคม 2568*