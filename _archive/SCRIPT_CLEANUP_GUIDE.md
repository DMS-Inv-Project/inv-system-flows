# Script Cleanup Guide
## คู่มือทำความสะอาด Scripts

---

## 🎯 **สถานะปัจจุบัน**

ตอนนี้ระบบใหม่ (PostgreSQL + Prisma) ทำงานได้เต็มรูปแบบแล้ว:
- ✅ Schema สมบูรณ์ (32 tables)
- ✅ Functions & Views ครบถ้วน
- ✅ Seed data พร้อมใช้งาน
- ✅ TMT data imported (25,991 concepts)

Scripts เดิมส่วนใหญ่เป็น **migration tools** สำหรับย้ายข้อมูลจาก MySQL → PostgreSQL
**ตอนนี้ migration เสร็จแล้ว ไม่จำเป็นต้องใช้อีก**

---

## 📊 **การวิเคราะห์ Scripts**

### ✅ **ควรเก็บไว้** (Essential - 8 files, ~70KB)

```
scripts/
├── import-tmt-data.js              # 19KB - Import TMT concepts ⭐
├── seed-tmt-references.ts          # 9KB  - Seed TMT reference data
├── sync-tmt-updates.js             # 22KB - Sync TMT updates
├── tmt-config.js                   # 9KB  - TMT configuration
├── his-integration.ts              # 12KB - HIS integration logic
├── validate-migration.js           # 11KB - Validation tools (useful)
└── mysql-queries-examples.sql      # 4KB  - Query examples (documentation)
```

**เหตุผล:**
- TMT scripts: ใช้งานจริงในการ import/update TMT data
- HIS integration: สำหรับเชื่อมต่อระบบ HIS ในอนาคต
- Validation: มีประโยชน์สำหรับ check data integrity
- Examples: เป็นเอกสารประกอบ

---

### ⚠️ **ควรย้ายไป `archive/`** (Reference only - 9 files, ~400MB)

```
archive/legacy-migration/
├── analyze-legacy-structure.sql    # 5KB   - Legacy analysis
├── run-analysis.sh                 # 5KB   - Analysis script
├── create_clean_schema.py          # 8KB   - Schema cleaning
├── extract_schema_only.py          # 4KB   - Schema extraction
├── mysql_to_postgresql_converter_v2.py  # 12KB - Converter
├── migrate-legacy-to-modern.js     # 23KB  - Migration script
├── migrate-to-tmt.sql              # 16KB  - TMT migration
├── import-mysql-data.sh            # 2KB   - MySQL import
└── legacy-init/
    ├── 01-invs-legacy-schema.sql   # 340MB - Legacy schema + data ⚠️
    ├── 01-schema-only.sql          # 26MB  - Legacy schema only ⚠️
    ├── 02-clean-schema.sql         # 102KB - Cleaned schema
    └── table_list.txt              # 5KB   - Table reference

archive/analysis-results/           # 9 files - Analysis outputs
├── 01-table-overview.txt
├── 02-drug-tables.txt
├── ... (7 more files)
```

**เหตุผล:**
- ใช้แล้ว (migration เสร็จ)
- เก็บไว้เป็น reference case ต้องย้อนกลับดู legacy
- ย้ายออกจาก `scripts/` เพื่อให้ชัดเจนว่าไม่ได้ใช้งานแล้ว

---

### ❌ **ควรลบ** (Development artifacts - 4 files, ~1.4GB)

```
❌ DELETE:
├── INVS_MySQL_Database_20231119.sql   # 1.3GB - Full MySQL dump
├── debug-tmt-excel.js                 # 1KB   - Debug script
├── debug-tmt-relationships.js         # 1.4KB - Debug script
├── example-usage.js                   # 12KB  - Old example
└── mysql-init/
    └── 01-init.sql                    # 726B  - MySQL init (not needed)
```

**เหตุผล:**
- MySQL dump: ไม่จำเป็น (มี PostgreSQL แล้ว)
- Debug scripts: ใช้ขณะ development แล้ว
- Example usage: outdated
- MySQL init: ใช้ PostgreSQL แล้ว

---

## 🗂️ **โครงสร้างใหม่ที่แนะนำ**

```
scripts/
├── README.md                       # 🆕 อธิบายแต่ละ script
│
├── tmt/                            # ✅ TMT-related scripts
│   ├── import-tmt-data.js
│   ├── seed-tmt-references.ts
│   ├── sync-tmt-updates.js
│   └── tmt-config.js
│
├── integration/                    # ✅ Integration scripts
│   ├── his-integration.ts
│   └── validate-migration.js
│
├── examples/                       # ✅ Example queries
│   └── query-examples.sql
│
└── archive/                        # ⚠️ Old migration scripts (reference only)
    ├── README.md                   # Explain these are archived
    ├── legacy-migration/
    │   ├── analyze-legacy-structure.sql
    │   ├── run-analysis.sh
    │   ├── create_clean_schema.py
    │   ├── extract_schema_only.py
    │   ├── mysql_to_postgresql_converter_v2.py
    │   ├── migrate-legacy-to-modern.js
    │   ├── migrate-to-tmt.sql
    │   └── import-mysql-data.sh
    ├── legacy-schemas/             # Large SQL files (gitignored)
    │   ├── .gitkeep
    │   └── README.md              # Download instructions
    └── analysis-results/
        └── ... (all .txt files)
```

---

## ✅ **คำสั่งทำความสะอาด**

### ขั้นตอนที่ 1: สร้าง archive directory

```bash
cd /Users/sathitseethaphon/projects/dms-invs-projects/invs-modern

# Create archive structure
mkdir -p scripts/archive/legacy-migration
mkdir -p scripts/archive/legacy-schemas
mkdir -p scripts/archive/analysis-results
mkdir -p scripts/tmt
mkdir -p scripts/integration
mkdir -p scripts/examples
```

### ขั้นตอนที่ 2: ย้ายไฟล์ที่ยังมีประโยชน์

```bash
# Move TMT scripts
mv scripts/import-tmt-data.js scripts/tmt/
mv scripts/seed-tmt-references.ts scripts/tmt/
mv scripts/sync-tmt-updates.js scripts/tmt/
mv scripts/tmt-config.js scripts/tmt/

# Move integration scripts
mv scripts/his-integration.ts scripts/integration/
mv scripts/validate-migration.js scripts/integration/

# Move examples
mv scripts/mysql-queries-examples.sql scripts/examples/query-examples.sql
```

### ขั้นตอนที่ 3: Archive migration scripts

```bash
# Move legacy migration scripts
mv scripts/analyze-legacy-structure.sql scripts/archive/legacy-migration/
mv scripts/run-analysis.sh scripts/archive/legacy-migration/
mv scripts/create_clean_schema.py scripts/archive/legacy-migration/
mv scripts/extract_schema_only.py scripts/archive/legacy-migration/
mv scripts/mysql_to_postgresql_converter_v2.py scripts/archive/legacy-migration/
mv scripts/migrate-legacy-to-modern.js scripts/archive/legacy-migration/
mv scripts/migrate-to-tmt.sql scripts/archive/legacy-migration/
mv scripts/import-mysql-data.sh scripts/archive/legacy-migration/

# Move legacy schemas (will be gitignored)
mv scripts/legacy-init/* scripts/archive/legacy-schemas/
rmdir scripts/legacy-init

# Move analysis results
mv scripts/analysis-results/* scripts/archive/analysis-results/
rmdir scripts/analysis-results
```

### ขั้นตอนที่ 4: ลบไฟล์ที่ไม่จำเป็น

```bash
# Delete large MySQL dump (already gitignored)
rm scripts/INVS_MySQL_Database_20231119.sql

# Delete debug scripts
rm scripts/debug-tmt-excel.js
rm scripts/debug-tmt-relationships.js
rm scripts/example-usage.js

# Delete MySQL init
rm -rf scripts/mysql-init
```

### ขั้นตอนที่ 5: สร้าง README files

```bash
# Create main scripts README
cat > scripts/README.md << 'EOF'
# Scripts Directory

## Active Scripts (Use These)

### TMT Management (`tmt/`)
- `import-tmt-data.js` - Import TMT concepts from Excel
- `seed-tmt-references.ts` - Seed TMT reference data
- `sync-tmt-updates.js` - Sync TMT updates
- `tmt-config.js` - TMT configuration

### Integration (`integration/`)
- `his-integration.ts` - HIS integration logic
- `validate-migration.js` - Data validation tools

### Examples (`examples/`)
- `query-examples.sql` - Example SQL queries

## Archived Scripts (`archive/`)
Old migration scripts kept for reference only.
See `archive/README.md` for details.
EOF

# Create archive README
cat > scripts/archive/README.md << 'EOF'
# Archived Scripts

These scripts were used for the initial MySQL → PostgreSQL migration.
**Migration is complete - these scripts are no longer needed.**

Kept for reference purposes only.

## Contents

- `legacy-migration/` - Migration scripts and tools
- `legacy-schemas/` - Large SQL schema files (gitignored)
- `analysis-results/` - Legacy database analysis outputs

## Large Files

Large SQL files are not stored in git.
Download from: [Add cloud storage link]
EOF
```

---

## 📊 **ผลลัพธ์**

### ก่อนทำความสะอาด:
```
scripts/ (1.7GB total)
├── 25 files (mixed: active + migration + debug)
├── Large SQL dumps (1.4GB)
├── Migration tools (no longer needed)
└── Debug scripts (development artifacts)
```

### หลังทำความสะอาด:
```
scripts/ (~70KB active)
├── tmt/ (4 files) - ใช้งานจริง ⭐
├── integration/ (2 files) - ใช้งานจริง ⭐
├── examples/ (1 file) - เอกสารประกอบ
└── archive/ (~400MB gitignored)
    ├── legacy-migration/ - เก็บไว้ reference
    ├── legacy-schemas/ - gitignored
    └── analysis-results/ - เก็บไว้ reference
```

**ผลลัพธ์:**
- ลดขนาด: **1.7GB → 70KB** (ลด 99.996%)
- จำนวนไฟล์: **25 → 7 active files**
- ชัดเจน: แยก active vs archived
- Clone เร็วขึ้น: ~30 วินาที → ~5 วินาที

---

## ⚠️ **ข้อควรระวัง**

### ก่อนลบไฟล์:

1. **Backup ก่อน**
   ```bash
   # สำรองไฟล์ใหญ่ไปยัง external drive หรือ cloud
   tar -czf invs-legacy-backup-$(date +%Y%m%d).tar.gz \
     scripts/INVS_MySQL_Database_20231119.sql \
     scripts/legacy-init/
   ```

2. **ตรวจสอบว่าไม่มีใครใช้งาน**
   ```bash
   # Search for script references in codebase
   grep -r "import-mysql-data.sh" .
   grep -r "migrate-legacy-to-modern" .
   ```

3. **Test ว่าระบบยังทำงานได้**
   ```bash
   # Run essential scripts
   npm run db:seed
   node scripts/tmt/import-tmt-data.js --test
   ```

---

## 📋 **Checklist**

### Phase 1: Preparation
- [ ] Backup large SQL files to external storage
- [ ] Upload to cloud (Google Drive/Dropbox)
- [ ] Get shareable links
- [ ] Test download links

### Phase 2: Reorganize
- [ ] Create new directory structure
- [ ] Move active scripts to `tmt/` and `integration/`
- [ ] Move legacy scripts to `archive/`
- [ ] Create README files

### Phase 3: Cleanup
- [ ] Delete large SQL dumps
- [ ] Delete debug scripts
- [ ] Delete outdated examples
- [ ] Update .gitignore

### Phase 4: Verification
- [ ] Test active scripts still work
- [ ] Test fresh clone from git
- [ ] Update documentation
- [ ] Commit changes

---

## 🚀 **Quick Start (After Cleanup)**

```bash
# Clone repository (fast!)
git clone <repo-url>
cd invs-modern

# Install dependencies
npm install

# Setup database
docker-compose up -d
npm run db:push
npm run db:seed

# Import TMT data (if needed)
node scripts/tmt/import-tmt-data.js

# You're ready! 🎉
```

**No need to download 1.4GB of legacy data!**

---

## 📞 **Support**

หากต้องการไฟล์ legacy สำหรับ reference:
- ดาวน์โหลดจาก: [Cloud Storage Link]
- หรือติดต่อ: [your-email@example.com]

---

**Status**: Ready for Cleanup 🧹
**Last Updated**: 2025-01-10

*Maintained with ❤️ by the INVS Modern Team*
