# MySQL Legacy Database Import Guide
## คู่มือนำเข้าฐานข้อมูล MySQL เดิม (สำหรับเปรียบเทียบ)

---

## 🎯 **วัตถุประสงค์**

นำเข้าฐานข้อมูล MySQL เดิม (invs_banpong) เพื่อ:
1. ✅ **อ้างอิง** - ดูโครงสร้างและข้อมูลเดิม
2. ✅ **เปรียบเทียบ** - เทียบกับ PostgreSQL (Prisma) ใหม่
3. ✅ **ตรวจสอบ** - ให้แน่ใจว่าไม่มีข้อมูลตกหล่น
4. ❌ **ไม่ใช้** - Convert หรือ migrate (ใช้ Prisma สร้างใหม่แล้ว)

---

## 🏗️ **สถาปัตยกรรมระบบ**

```
┌─────────────────────────────────────────────────────────────┐
│                     INVS Modern System                       │
└─────────────────────────────────────────────────────────────┘

  ┌────────────────────┐              ┌────────────────────┐
  │  MySQL (Legacy)    │              │ PostgreSQL (New)   │
  │  Port: 3307        │              │ Port: 5434         │
  │  DB: invs_banpong  │              │ DB: invs_modern    │
  │                    │              │                    │
  │  - 133 tables      │              │ - 32 tables        │
  │  - Full data       │              │ - Prisma schema    │
  │  - UTF8MB4         │              │ - Clean design     │
  │  - Read only       │◄─Compare────►│ - Production use   │
  └────────────────────┘              └────────────────────┘
           │                                     │
           │                                     │
     ┌─────▼──────┐                       ┌─────▼──────┐
     │ phpMyAdmin │                       │  pgAdmin   │
     │ :8082      │                       │  :8081     │
     └────────────┘                       └────────────┘
```

---

## 📋 **Prerequisites**

### 1. ไฟล์ SQL Dump
```
INVS_MySQL_Database_20231119.sql (1.3GB)
```

**วางไฟล์ที่:**
```
/Users/sathitseethaphon/projects/dms-invs-projects/invs-modern/scripts/
```

### 2. Docker & Docker Compose
```bash
docker --version  # >= 20.10
docker-compose --version  # >= 1.29
```

### 3. เนื้อที่ว่าง
- **ต้องการ**: ~5GB
  - SQL file: 1.3GB
  - MySQL data: ~3GB
  - Temp space: ~0.7GB

---

## 🚀 **Quick Start**

### Step 1: Start MySQL Container

```bash
# Start only MySQL (ไม่ต้องรอ PostgreSQL)
docker-compose up -d mysql-original

# Check status
docker ps | grep mysql
```

**Expected Output:**
```
invs-mysql-original   Up 10 seconds   0.0.0.0:3307->3306/tcp
```

### Step 2: Import Database

```bash
# Run import script
cd /Users/sathitseethaphon/projects/dms-invs-projects/invs-modern
chmod +x scripts/import-mysql-legacy.sh
./scripts/import-mysql-legacy.sh
```

**Timeline:**
```
⏱️ Import time: ~10-15 minutes
📊 Progress indicators:
  - Wait for MySQL ready: ~10 seconds
  - Import SQL: ~10 minutes
  - Verify tables: ~30 seconds
```

### Step 3: Verify Import

```bash
# Check table count
docker exec invs-mysql-original mysql -u invs_user -pinvs123 \
  -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='invs_banpong';"

# Expected: 133 tables
```

---

## 🔧 **Import Script Details**

### Script Location
```
scripts/import-mysql-legacy.sh  ← Active script (use this!)
```

### What It Does

1. **Check Prerequisites**
   - MySQL container running?
   - SQL file exists?

2. **Wait for MySQL Ready**
   - Max 30 seconds timeout
   - Connection test every second

3. **Import Database**
   ```bash
   docker exec -i invs-mysql-original mysql \
     -u invs_user -pinvs123 \
     --default-character-set=utf8mb4 \
     --max_allowed_packet=1GB \
     invs_banpong < INVS_MySQL_Database_20231119.sql
   ```

4. **Verify Import**
   - Count tables
   - Show sample tables
   - Display access info

### Script Usage

```bash
# Basic usage
./scripts/import-mysql-legacy.sh

# With custom SQL file
SQL_FILE=/path/to/file.sql ./scripts/import-mysql-legacy.sh

# Check script without running
cat scripts/import-mysql-legacy.sh
```

---

## 🔍 **Access & Tools**

### MySQL CLI Access

```bash
# Connect to MySQL
docker exec -it invs-mysql-original mysql -u invs_user -pinvs123 invs_banpong

# Show tables
SHOW TABLES;

# Check specific table
DESC drug_gn;
SELECT COUNT(*) FROM drug_gn;

# Export query results
docker exec invs-mysql-original mysql -u invs_user -pinvs123 invs_banpong \
  -e "SELECT * FROM drug_gn LIMIT 10;" > output.txt
```

### phpMyAdmin (Web Interface)

```
URL: http://localhost:8082
Server: mysql-original
Username: invs_user
Password: invs123
Database: invs_banpong
```

**Features:**
- ✅ Browse tables
- ✅ Run queries
- ✅ Export data
- ✅ View structure
- ✅ Search data

---

## 📊 **Database Comparison**

### Key Tables to Compare

| Purpose | MySQL (Legacy) | PostgreSQL (Prisma) | Notes |
|---------|----------------|---------------------|-------|
| **Drug Generics** | `drug_gn` | `drug_generics` | Same data, different structure |
| **Trade Drugs** | `drug_vn` | `drugs` | Linked to generics |
| **Companies** | `company` | `companies` | Vendor/manufacturer |
| **Inventory** | `inv_md` | `inventory` | Stock levels |
| **Lots** | `card` | `drug_lots` | FIFO/FEFO tracking |
| **PO** | `ms_po`, `ms_po_c` | `purchase_orders`, `purchase_order_items` | Simplified structure |
| **Budget** | ❌ None | `budget_allocations`, `budget_reservations` | New feature! |

### Comparison Queries

#### Check Drug Count
```sql
-- MySQL
SELECT COUNT(*) as total_generics FROM drug_gn WHERE ACTIVE = 'Y';
-- Expected: ~1,104

-- PostgreSQL
SELECT COUNT(*) as total_generics FROM drug_generics WHERE is_active = true;
-- Expected: ~1,104 (after data import)
```

#### Check Company Count
```sql
-- MySQL
SELECT COUNT(*) FROM company;
-- Expected: 816

-- PostgreSQL
SELECT COUNT(*) FROM companies WHERE is_active = true;
-- Expected: 5 (seed data) + more when imported
```

---

## 🛠️ **Useful Commands**

### Docker Management

```bash
# Start MySQL only
docker-compose up -d mysql-original

# Stop MySQL
docker-compose stop mysql-original

# View logs
docker logs invs-mysql-original -f

# Restart MySQL
docker-compose restart mysql-original

# Remove MySQL (delete data!)
docker-compose down
docker volume rm invs-modern_mysql_data
```

### Backup MySQL

```bash
# Backup to file
docker exec invs-mysql-original mysqldump \
  -u invs_user -pinvs123 \
  invs_banpong > backup_$(date +%Y%m%d).sql

# Restore from backup
docker exec -i invs-mysql-original mysql \
  -u invs_user -pinvs123 \
  invs_banpong < backup_20250111.sql
```

### Query Examples

```sql
-- Find drug by name
SELECT * FROM drug_gn WHERE DRUG_NAME LIKE '%Paracetamol%';

-- Check inventory
SELECT
  dg.WORKING_CODE,
  dg.DRUG_NAME,
  im.QOH as quantity_on_hand,
  im.MNLEVEL as min_level
FROM inv_md im
JOIN drug_gn dg ON im.WORKING_CODE = dg.WORKING_CODE
WHERE im.QOH < im.MNLEVEL;

-- Get company info
SELECT
  COMP_NAME,
  TAX_ID,
  ADDRESS
FROM company
WHERE COMP_NAME LIKE '%GPO%';
```

---

## ⚠️ **Important Notes**

### 1. Read-Only Database
```
MySQL legacy database is for REFERENCE ONLY
Do NOT modify data in MySQL
All new operations use PostgreSQL (Prisma)
```

### 2. Character Encoding
```
MySQL: UTF8MB4 (Thai language supported)
Files: Make sure to save as UTF-8
Queries: Use --default-character-set=utf8mb4
```

### 3. Large File Handling
```
SQL file is 1.3GB (gitignored)
Download separately if needed
Import takes 10-15 minutes
Requires ~5GB disk space
```

### 4. Port Configuration
```
MySQL Legacy:     localhost:3307
PostgreSQL Modern: localhost:5434
No conflicts!
```

---

## 🐛 **Troubleshooting**

### Problem 1: SQL File Not Found

```bash
# Check file exists
ls -lh scripts/INVS_MySQL_Database_20231119.sql

# If missing, download from:
# [Add cloud storage link]

# Or check if in wrong location:
find . -name "INVS_MySQL*.sql"
```

### Problem 2: MySQL Container Not Starting

```bash
# Check logs
docker logs invs-mysql-original

# Common issues:
# - Port 3307 already in use
# - Not enough memory
# - Corrupt volume

# Solution: Remove and recreate
docker-compose down
docker volume rm invs-modern_mysql_data
docker-compose up -d mysql-original
```

### Problem 3: Import Fails or Hangs

```bash
# Check MySQL is ready
docker exec invs-mysql-original mysql -u root -pinvs123 -e "SELECT 1;"

# Check disk space
df -h

# Try manual import with progress
docker exec -i invs-mysql-original mysql \
  -u invs_user -pinvs123 \
  --verbose \
  invs_banpong < scripts/INVS_MySQL_Database_20231119.sql
```

### Problem 4: Character Encoding Issues

```bash
# Set correct charset
docker exec invs-mysql-original mysql -u invs_user -pinvs123 \
  -e "SET NAMES utf8mb4;"

# Check table charset
docker exec invs-mysql-original mysql -u invs_user -pinvs123 \
  -e "SHOW CREATE TABLE drug_gn;" invs_banpong
```

---

## 📚 **Reference**

### MySQL Tables (Legacy) - 133 tables

**Drug Management:**
- `drug_gn` - Generic drugs (1,104 records)
- `drug_vn` - Trade drugs
- `dosage_form` - Dosage forms (87 types)
- `sale_unit` - Units (10 types)

**Inventory:**
- `inv_md` - Inventory master
- `card` - Transaction card (FIFO/FEFO)
- `inv_md_c` - Inventory items

**Procurement:**
- `ms_po` - Purchase orders
- `ms_po_c` - PO items
- `ms_ivo` - Invoices
- `sm_po` - Distribution orders

**Master Data:**
- `company` - Companies (816 records)
- `dept_id` - Departments
- `location` - Storage locations

---

## ✅ **Verification Checklist**

After import, verify:

- [ ] MySQL container running on port 3307
- [ ] Database `invs_banpong` exists
- [ ] 133 tables imported
- [ ] Sample queries work
- [ ] phpMyAdmin accessible
- [ ] Thai characters display correctly
- [ ] Data counts match expected values

### Quick Verification Script

```bash
#!/bin/bash
echo "🔍 Verifying MySQL Import..."

# Check container
docker ps | grep mysql-original || echo "❌ Container not running"

# Check database
docker exec invs-mysql-original mysql -u invs_user -pinvs123 \
  -e "USE invs_banpong; SELECT 'OK' as status;" || echo "❌ Database not found"

# Check tables
TABLE_COUNT=$(docker exec invs-mysql-original mysql -u invs_user -pinvs123 invs_banpong -s -N \
  -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='invs_banpong';")
echo "📊 Tables: $TABLE_COUNT (expected: 133)"

# Check key tables
docker exec invs-mysql-original mysql -u invs_user -pinvs123 invs_banpong \
  -e "SELECT 'drug_gn' as tbl, COUNT(*) as cnt FROM drug_gn
      UNION ALL SELECT 'company', COUNT(*) FROM company
      UNION ALL SELECT 'card', COUNT(*) FROM card;"

echo "✅ Verification complete!"
```

---

## 🎯 **Next Steps**

After successful import:

1. **Explore Data**
   ```bash
   # Use phpMyAdmin: http://localhost:8082
   # Or MySQL CLI
   ```

2. **Compare Structures**
   ```bash
   # Compare MySQL vs PostgreSQL tables
   # Use scripts/compare-schemas.sh (if exists)
   ```

3. **Development**
   ```bash
   # Use PostgreSQL (Prisma) for all new development
   # Reference MySQL only when needed
   ```

---

**Status**: Ready for Import ✅
**Last Updated**: 2025-01-11

*Maintained with ❤️ by the INVS Modern Team*
