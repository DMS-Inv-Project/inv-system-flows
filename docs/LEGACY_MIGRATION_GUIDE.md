# Legacy to Modern Migration Guide

คู่มือการ migrate ข้อมูลยาจากระบบ MySQL เดิมสู่ระบบ PostgreSQL ใหม่พร้อม TMT support

## 📋 ข้อกำหนดเบื้องต้น

### 1. Database Requirements
- **Source Database**: MySQL INVS (legacy system)
  - Host: localhost:3306
  - Database: `invs`
  - Tables: `company`, `drug_gn`, `drug_vn`, `inv_md`
  
- **Target Database**: PostgreSQL INVS Modern
  - Host: localhost:5433
  - Database: `invs_platform`
  - Schema: Prisma-managed with TMT support

### 2. System Requirements
- Node.js 18+
- Docker (สำหรับ database containers)
- npm dependencies: `mysql2`, `@prisma/client`, `prisma`

## 🚀 การติดตั้งและเตรียมพร้อม

### 1. Clone และ Setup
```bash
cd /path/to/invs-modern
npm install
```

### 2. ตรวจสอบ Database Connections
```bash
# ตรวจสอบ MySQL (legacy)
docker exec mysql-invs mysql -u root -pinvs123 -e "USE invs; SELECT COUNT(*) FROM drug_vn;"

# ตรวจสอบ PostgreSQL (modern)
docker exec postgresql-invs psql -U invs_user -d invs_platform -c "SELECT COUNT(*) FROM drugs;"
```

### 3. Backup ข้อมูลปัจจุบัน
```bash
# สร้าง backup ก่อนเริ่ม migration
docker exec postgresql-invs pg_dump -U invs_user invs_platform > backup_before_migration.sql
```

## 📊 สภาพข้อมูลในระบบเดิม

### ข้อมูลที่จะ Migrate (จากการวิเคราะห์)
```
Companies (company):      ~816 records
Drug Generics (drug_gn):  ~1,104 records  
Drugs (drug_vn):          ~7,258 records
  - มี TMT ID:            ~3,881 records (53.5%)
  - มีรหัส 24 หลัก:        ~5,830 records (80.3%)
Inventory (inv_md):       ~Active stock items
```

### โครงสร้างการ Mapping รหัสยา
```
WORKING_CODE (7-digit) → TMT ID (bigint) → 24-DIGIT Code (24-char)
     1:n relationship        1:1 or 1:n relationship
```

## 🔧 ขั้นตอนการ Migration

### Step 1: ทดสอบ Migration (Dry Run)
```bash
npm run migrate:legacy:dry-run
```

สิ่งที่จะเกิดขึ้น:
- ✅ ตรวจสอบการเชื่อมต่อ database
- ✅ สร้าง backup ข้อมูลปัจจุบัน
- ✅ Extract ข้อมูลจาก MySQL
- ✅ จำลองการ transform และ migrate
- ✅ แสดงผลสรุปโดยไม่เปลี่ยนแปลงข้อมูลจริง

### Step 2: Migration จริง
```bash
npm run migrate:legacy
```

Process ที่จะเกิดขึ้น:
1. **Backup Creation** - สร้าง backup ในโฟลเดอร์ `backups/migration/`
2. **Data Extraction** - ดึงข้อมูลจาก MySQL tables
3. **Companies Migration** - migrate บริษัท/vendor/manufacturer
4. **Drug Generics Migration** - migrate ยาระดับ generic
5. **Drugs Migration** - migrate ยาระดับ trade products
6. **Inventory Migration** - migrate ข้อมูล stock
7. **TMT Mappings Creation** - สร้าง TMT mappings จากข้อมูลที่มี
8. **Validation** - ตรวจสอบความถูกต้อง

### Step 3: ตรวจสอบผลลัพธ์
```bash
npm run migrate:validate
```

การตรวจสอบที่จะทำ:
- 📊 เปรียบเทียบจำนวนข้อมูล source vs target
- 🏷️ ตรวจสอบ TMT mappings และ coverage
- 🔍 ตรวจสอบ data integrity (orphaned records, duplicates)
- 💎 ตรวจสอบ data quality (empty fields, invalid data)

## 📁 ผลลัพธ์และไฟล์ที่สร้างขึ้น

### Backup Files
```
backups/migration/migration-backup-{timestamp}/
├── companies.json          - backup companies ก่อน migration
├── drug_generics.json      - backup drug generics ก่อน migration
├── drugs.json              - backup drugs ก่อน migration
├── inventory.json          - backup inventory ก่อน migration
└── metadata.json           - metadata ของ backup
```

### Log Files
```
logs/migration-{timestamp}.log  - migration log (if configured)
```

## 🎯 การใช้งาน Advanced Options

### Debug Mode
```bash
npm run migrate:legacy:debug
```
- เพิ่ม debug logging
- แสดงรายละเอียดการ transform ข้อมูล

### Custom Batch Size
```bash
node scripts/migrate-legacy-to-modern.js --batch-size 1000
```

### Configuration
แก้ไขใน `scripts/migrate-legacy-to-modern.js`:
```javascript
const CONFIG = {
  mysql: {
    host: 'localhost',      // MySQL host
    port: 3306,             // MySQL port
    user: 'root',           // MySQL user
    password: 'invs123',    // MySQL password
    database: 'invs'        // MySQL database
  },
  migration: {
    batchSize: 500,         // Records per batch
    dryRun: false,          // Set true for dry run
    backupPath: './backups/migration',
    logPath: './logs'
  }
};
```

## ⚠️ ข้อควรระวังและแนวทางแก้ไข

### 1. Connection Issues
**ปัญหา**: ไม่สามารถเชื่อมต่อ MySQL/PostgreSQL
```bash
# ตรวจสอบ containers
docker ps

# Start containers if needed
docker-compose up -d
```

### 2. Memory Issues
**ปัญหา**: หน่วยความจำไม่พอสำหรับข้อมูลใหญ่
```bash
# ลด batch size
node scripts/migrate-legacy-to-modern.js --batch-size 100
```

### 3. Data Type Mismatches
**ปัญหา**: ข้อมูลบางฟิลด์ไม่ตรงกับ schema ใหม่
- ตรวจสอบใน migration logs
- แก้ไข transformation logic ในฟังก์ชัน transform

### 4. Orphaned Records
**ปัญหา**: พบ orphaned records หลัง validation
```bash
# ใช้ Prisma Studio ตรวจสอบ
npm run db:studio
```

## 🔄 การ Rollback

### กรณีต้องการยกเลิก Migration
```bash
# 1. Stop application
# 2. Restore from backup
docker exec -i postgresql-invs psql -U invs_user invs_platform < backup_before_migration.sql

# 3. Reset Prisma
npm run db:push
```

## 📈 หลังจาก Migration เสร็จ

### 1. Import TMT Reference Data
```bash
npm run tmt:import
```

### 2. Update Drug Codes with TMT
```bash
npm run tmt:update-codes
```

### 3. Check TMT Statistics
```bash
npm run tmt:stats
```

### 4. Verify System Integration
```bash
# Test API endpoints
# Check Prisma Studio data
# Run application tests
```

## 📊 ตัวอย่างผลลัพธ์

### สถิติการ Migration ที่คาดหวัง
```
🎉 Migration completed successfully!
📊 DATA MIGRATION SUMMARY:
   Companies: 816 migrated
   Drug Generics: 1,104 migrated  
   Drugs: 7,258 migrated
   Inventory: ~3,000 items migrated
   TMT Mappings: ~3,881 created

🏷️ TMT INTEGRATION:
   TMT coverage: 53.5%
   24-digit coverage: 80.3%

🔍 DATA INTEGRITY:
   ✅ No integrity issues found

⏱️ Total time: ~45-90 seconds
```

## 🆘 การได้รับความช่วยเหลือ

### ปัญหาที่พบบ่อย
1. **Database Connection Failed**: ตรวจสอบ Docker containers และ credentials
2. **Migration Timeout**: เพิ่ม timeout หรือลด batch size
3. **TMT Mapping Failed**: ตรวจสอบว่ามี TMT concepts data หรือยัง
4. **Data Validation Failed**: ใช้ debug mode เพื่อดูรายละเอียด

### Log Analysis
```bash
# ดู migration logs
tail -f logs/migration-*.log

# ตรวจสอบ Prisma logs
DEBUG=prisma:query npm run migrate:legacy:debug
```

### ติดต่อสำหรับสนับสนุน
- อ่าน error logs ใน console output
- ตรวจสอบ backup files ใน `backups/migration/`
- รันคำสั่ง validation เพื่อหาปัญหา

---

## 📝 Migration Checklist

### ก่อน Migration
- [ ] ตรวจสอบ database connections
- [ ] สร้าง backup ข้อมูลปัจจุบัน
- [ ] ทดสอบด้วย dry-run mode
- [ ] ตรวจสอบ disk space เพียงพอ

### ระหว่าง Migration  
- [ ] Monitor migration progress
- [ ] ตรวจสอบ error logs
- [ ] Verify batch processing

### หลัง Migration
- [ ] รัน validation script
- [ ] ตรวจสอบ data counts
- [ ] ทดสอบ application functionality
- [ ] Import TMT reference data
- [ ] Update drug codes
- [ ] Document any issues found

*เอกสารนี้ครอบคลุมการ migrate ข้อมูลยาจากระบบเดิมสู่ระบบใหม่พร้อม TMT support แบบครบถ้วน*