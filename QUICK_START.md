# Quick Start Guide

สำหรับ clone repo ใหม่และต้องการข้อมูลเต็ม

---

## 🚀 Option 1: Quick Setup (Basic Data Only)

**เวลา**: 10 นาที | **ข้อมูล**: ~50 records

```bash
# 1. Clone & Install
git clone <repo-url>
cd invs-modern
npm install

# 2. Start containers
docker-compose up -d

# 3. Setup database
npm run setup:fresh

# 4. Verify
npm run dev
```

✅ **ได้อะไร**:
- Schema ครบ 52 tables
- Master data พื้นฐาน (companies, locations, departments)
- ยาตัวอย่าง 8 รายการ
- TMT ตัวอย่าง 3 รายการ

---

## 🎯 Option 2: Full Import (Production-Like Data)

**เวลา**: 20 นาที | **ข้อมูล**: 81,353 records

```bash
# 1. Clone & Install
git clone <repo-url>
cd invs-modern
npm install

# 2. Start containers
docker-compose up -d

# 3. Setup with full data
npm run setup:full

# 4. Verify
npm run dev
npm run db:studio
```

✅ **ได้อะไร**:
- Drug Master: 1,109 generics + 1,169 trade drugs
- Lookup Tables: 107 dosage forms + 88 units
- TMT Concepts: 76,904 records (all 5 levels)
- Drug-TMT Mapping: 561 drugs

---

## 📦 Available Commands

### Setup Commands
```bash
npm run setup:fresh      # Migrate + Seed (basic data)
npm run setup:full       # Migrate + Seed + Import All
```

### Database Commands
```bash
npm run db:migrate       # Apply migrations
npm run db:seed          # Seed basic data
npm run db:reset         # Reset database
npm run db:studio        # Open Prisma Studio
npm run db:generate      # Generate Prisma Client
```

### Import Commands (Individual)
```bash
npm run import:phase1    # Procurement master (57 records)
npm run import:phase2    # Drug components (821 records)
npm run import:phase3    # Distribution support (4 records)
npm run import:phase4    # Drug master (3,006 records)
npm run import:phase5    # Lookup tables (213 records)
npm run import:phase6    # FK mappings (1,085 mappings)
npm run import:phase7    # TMT concepts (76,904 records)
npm run import:phase8    # Drug-TMT map (561 drugs)
```

### Import Commands (Groups)
```bash
npm run import:all       # Import everything (Phase 1-8)
npm run import:drugs     # Import Phase 1-4 only
npm run import:lookups   # Import Phase 5-6 only
npm run import:tmt       # Import Phase 7-8 only
```

---

## 🔍 Verify Setup

### Check Data Counts
```bash
npm run dev
```

**Expected Output (Full Import)**:
```
✅ Database connected successfully!
📍 Locations: 5
💊 Drugs: 1,169
🏢 Companies: 5
```

### Open Visual Database Browser
```bash
npm run db:studio
```
Opens http://localhost:5555

### Check Specific Table
```bash
docker exec -i invs-modern-db psql -U invs_user -d invs_modern -c "SELECT COUNT(*) FROM tmt_concepts;"
```

---

## ⚡ Fastest Setup (Using Backup)

**เวลา**: 5 นาที | **ข้อมูล**: Full dataset

### 1. Create Backup (One Time)
```bash
# After running setup:full
docker exec invs-modern-db pg_dump -U invs_user invs_modern | gzip > backup.sql.gz
```

### 2. Restore on New Machine
```bash
# Start database
docker-compose up -d

# Restore backup
gunzip -c backup.sql.gz | docker exec -i invs-modern-db psql -U invs_user -d invs_modern

# Generate Prisma Client
npm run db:generate

# Done! ✅
```

---

## 📋 What Gets Migrated vs What Doesn't

### ✅ From Migration (`npm run db:migrate`)
- 52 tables (structure)
- 22 enums
- All columns, indexes, constraints
- Foreign keys

### ❌ NOT from Migration (Need Import)
- Master data (companies, locations)
- Lookup tables (dosage_forms, drug_units)
- Drug catalog (1,109 generics + 1,169 drugs)
- TMT concepts (76,904 records)
- Drug-TMT mappings (561 drugs)

### 💾 Data Sources

| Data | Command | Records |
|------|---------|---------|
| **Basic Seed** | `npm run db:seed` | ~50 |
| **Full Import** | `npm run import:all` | 81,353 |

---

## 🚨 Troubleshooting

### Migration Drift Error
```bash
npm run db:migrate -- --force
```

### Reset Everything
```bash
npm run db:reset
npm run setup:full
```

### MySQL Not Connected
```bash
docker-compose restart invs-mysql-original
```

### Check Containers
```bash
docker ps | grep invs
# Should see 4 containers running
```

---

## 📚 Full Documentation

- **SETUP_FRESH_CLONE.md** - Complete setup guide
- **README.md** - Project overview
- **SYSTEM_SETUP_GUIDE.md** - Detailed system setup
- **PROJECT_STATUS.md** - Current status

---

**Pro Tip**: สร้าง backup หลัง setup:full แล้ว commit to Git LFS เพื่อให้ทีมอื่นๆ restore ได้เร็วใน 1 นาที! 🚀
