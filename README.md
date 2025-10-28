# INVS Modern 🏥

Modern Hospital Inventory Management System built with PostgreSQL, Prisma, and TypeScript.

**Version**: 2.6.0 | **Status**: ✅ Full Data Migration Complete 🎉 | **Last Updated**: 2025-01-28

---

## ⚠️ **Project Scope**

**This repository is a DATABASE SCHEMA + DOCUMENTATION PROJECT ONLY**

✅ What's included: Prisma schema, SQL functions/views, migration scripts, full data (81K records), documentation
❌ Not included: Backend API, Frontend (separate projects)

---

## 📊 Current Project Status

```
✅ Database: Complete (52 tables, 11 views, 12 functions, 22 enums)
✅ Data Migrated: 81,353 records (Phase 1-8 COMPLETE) 🚀 ⭐ NEW
✅ Drug Master: 1,109 generics + 1,169 trade drugs 🔓
✅ Lookup Tables: 107 dosage forms + 88 drug units 🔓 ⭐ NEW
✅ TMT Integration: 76,904 concepts (5 levels) 🔓 ⭐ NEW
✅ Drug-TMT Mapping: 561 drugs (47.99% coverage) 🔓 ⭐ NEW
✅ Ministry Compliance: 100% COMPLETE (79/79 fields) 🎉
✅ Docker Setup: Working (4 containers)
✅ Documentation: Complete (46+ guides + 7 migration reports) ⭐
✅ Seed Data: Complete with TMT samples
🚀 Backend API: Ready to start (full data available)
🚀 Frontend: Ready to start (full data available)
```

**🎊 Latest Achievement**: Phase 8 Complete - Full Data Migration Done! (81,353 records) 🎉

**📋 For complete status**: See [PROJECT_STATUS.md](PROJECT_STATUS.md)

---

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- Git

### Option 1: Basic Setup (10 minutes) - For Development

```bash
# 1. Clone and install
git clone <repo-url>
cd invs-modern
npm install

# 2. Start containers
docker-compose up -d

# 3. Setup with basic data
npm run setup:fresh

# 4. Verify
npm run dev
```

**You get**: Schema + ~50 basic records

### Option 2: Full Data Import (20 minutes) - Production-Like

```bash
# 1. Clone and install
git clone <repo-url>
cd invs-modern
npm install

# 2. Start containers
docker-compose up -d

# 3. Setup with ALL data
npm run setup:full

# 4. Verify and explore
npm run dev
npm run db:studio  # http://localhost:5555
```

**You get**: Schema + 81,353 records (all Phase 1-8 data)

### Option 3: Backup Restore (5 minutes) - Fastest ⭐

```bash
# 1. Clone and install
git clone <repo-url>
cd invs-modern
npm install

# 2. Start containers
docker-compose up -d

# 3. Restore from backup
gunzip -c backup-full.sql.gz | docker exec -i invs-modern-db psql -U invs_user -d invs_modern
npm run db:generate

# 4. Verify
npm run dev
```

**You get**: Complete database in 1 minute!

---

## 📦 What Data is Included?

### After Full Import (`npm run setup:full`):

| Category | Records | Source |
|----------|---------|--------|
| **Master Data** | ~50 | Seed script |
| **Drug Master** | 3,006 | Phase 1-4 |
| **Lookup Tables** | 213 | Phase 5 ⭐ NEW |
| **FK Mappings** | 1,085 | Phase 6 ⭐ NEW |
| **TMT Concepts** | 76,904 | Phase 7 ⭐ NEW |
| **Drug-TMT Map** | 561 | Phase 8 ⭐ NEW |
| **Total** | **81,353** | **COMPLETE** 🎉 |

**Breakdown:**
- Companies: 5
- Locations: 5
- Departments: 5
- Drug Generics: 1,109 (97.6% with FK mapping)
- Trade Drugs: 1,169 (47.99% with TMT)
- Dosage Forms: 107
- Drug Units: 88
- TMT Concepts: 76,904 (VTM→GP→GPU→TP→TPU)

---

## 🗂️ Project Structure

```
invs-modern/
├── prisma/
│   ├── schema.prisma          # 52 tables, 22 enums (950+ lines)
│   ├── functions.sql          # 12 business functions (610+ lines)
│   ├── views.sql              # 11 reporting views (378 lines)
│   ├── seed.ts               # Master data seeding
│   └── migrations/            # 11 migrations
│
├── scripts/
│   ├── migrate-phase1-data.ts          # Phase 1 (57 records)
│   ├── migrate-phase2-data.ts          # Phase 2 (821 records)
│   ├── migrate-phase3-data.ts          # Phase 3 (4 records)
│   ├── migrate-phase4-drug-master.ts   # Phase 4 (3,006 records)
│   ├── migrate-phase5-lookup-tables.ts # Phase 5 (213 records) ⭐
│   ├── migrate-phase6-map-string-to-fk.ts # Phase 6 (1,085 mappings) ⭐
│   ├── migrate-phase7-tmt-concepts.ts  # Phase 7 (76,904 records) ⭐
│   └── migrate-phase8-map-tmt.ts       # Phase 8 (561 mappings) ⭐
│
├── docs/
│   ├── flows/                 # 9 detailed flow documents
│   ├── migration/             # Phase 7-8 summaries ⭐ NEW
│   ├── migration-reports/     # Phase 1-4 reports
│   ├── BRD.md                # Business Requirements (Thai, 67KB)
│   └── TRD.md                # Technical Requirements (Thai, 106KB)
│
├── QUICK_START.md            # Quick start guide ⭐ NEW
├── SETUP_FRESH_CLONE.md      # Detailed clone setup ⭐ NEW
├── PROJECT_STATUS.md          # Complete project status
├── CLAUDE.md                  # AI assistant context
└── docker-compose.yml         # 4 containers setup
```

---

## 💻 Available Commands

### Setup Commands
```bash
npm run setup:fresh      # Migrate + Seed (basic data)
npm run setup:full       # Migrate + Seed + Import All (81K records)
```

### Database Commands
```bash
npm run db:migrate       # Apply migrations
npm run db:seed          # Seed basic data
npm run db:reset         # Reset database
npm run db:studio        # Open Prisma Studio (http://localhost:5555)
npm run db:generate      # Generate Prisma Client
```

### Import Commands (Individual)
```bash
npm run import:phase1    # Procurement master (57)
npm run import:phase2    # Drug components (821)
npm run import:phase3    # Distribution support (4)
npm run import:phase4    # Drug master (3,006)
npm run import:phase5    # Lookup tables (213) ⭐
npm run import:phase6    # FK mappings (1,085) ⭐
npm run import:phase7    # TMT concepts (76,904) ⭐
npm run import:phase8    # Drug-TMT map (561) ⭐
```

### Import Commands (Groups)
```bash
npm run import:all       # All phases 1-8 (20 min)
npm run import:drugs     # Phase 1-4 only (5 min)
npm run import:lookups   # Phase 5-6 only (2 min)
npm run import:tmt       # Phase 7-8 only (7 min)
```

### Development Commands
```bash
npm run build            # Build TypeScript
npm run dev              # Test database connection
npm start                # Run production build
```

---

## 🔍 Web Interfaces

**Prisma Studio** (Database Browser)
- URL: http://localhost:5555
- Command: `npm run db:studio`
- Features: Browse all tables, edit data, run queries

**pgAdmin** (PostgreSQL Management)
- URL: http://localhost:8081
- Email: admin@invs.com
- Password: invs123

**phpMyAdmin** (MySQL Reference)
- URL: http://localhost:8082
- Username: invs_user
- Password: invs123

---

## 🗄️ Database Connections

**PostgreSQL (Modern - Production)**
- Host: localhost
- Port: 5434
- Database: invs_modern
- Username: invs_user
- Password: invs123

**MySQL (Legacy - Reference Only)**
- Host: localhost
- Port: 3307
- Database: invs_banpong
- Username: invs_user
- Password: invs123

---

## 📚 Documentation

### Quick Guides
- **[QUICK_START.md](QUICK_START.md)** - Quick start for fresh clone ⭐ NEW
- **[SETUP_FRESH_CLONE.md](SETUP_FRESH_CLONE.md)** - Detailed setup guide ⭐ NEW
- **[PROJECT_STATUS.md](PROJECT_STATUS.md)** - Complete project status
- **[SYSTEM_SETUP_GUIDE.md](SYSTEM_SETUP_GUIDE.md)** - System setup instructions

### Business & Technical Docs
- **[docs/BRD.md](docs/BRD.md)** - Business Requirements Document (Thai)
- **[docs/TRD.md](docs/TRD.md)** - Technical Requirements Document (Thai)
- **[docs/DATABASE_DESIGN.md](docs/DATABASE_DESIGN.md)** - Database design
- **[docs/SYSTEM_ARCHITECTURE.md](docs/SYSTEM_ARCHITECTURE.md)** - System architecture

### Flow Documentation (9 flows)
1. **FLOW_01**: Master Data Setup
2. **FLOW_02**: Budget Management
3. **FLOW_02B**: Budget Planning with Drugs ⭐
4. **FLOW_03**: Procurement (Purchase Request)
5. **FLOW_04**: Inventory Management
6. **FLOW_05**: Drug Distribution
7. **FLOW_06**: TMT Integration
8. **FLOW_07**: Ministry Reporting
9. **FLOW_08**: Frontend Purchase Request (UI mockups)

### Migration Documentation
- **Phase 1-4**: [docs/migration-reports/](docs/migration-reports/) (4 reports)
- **Phase 7-8**: [docs/migration/](docs/migration/) (3 reports) ⭐ NEW
  - PHASE_7_TMT_SUMMARY.md
  - PHASE_8_TMT_MAPPING_PLAN.md
  - PHASE_8_TMT_MAPPING_SUMMARY.md

---

## 🎯 Database Features

### Business Logic Functions (12)
- Budget checking & reservation
- Drug-level budget plan validation ⭐
- FIFO/FEFO inventory allocation
- Inventory updates from receipts
- Budget plan purchase tracking

### Reporting Views (11)
- Ministry exports (5 views):
  - DRUGLIST, PURCHASEPLAN, RECEIPT, DISTRIBUTION, INVENTORY
- Operational views (6 views):
  - Budget status, Expiring drugs, Low stock, Current stock, etc.

### Ministry Compliance
- ✅ 100% COMPLETE (79/79 required fields)
- ✅ All 5 export files supported
- ✅ DMSIC Standards พ.ศ. 2568 compliant

### TMT Integration ⭐ NEW
- ✅ 76,904 concepts (5 levels)
- ✅ Full hierarchy: VTM → GP → GPU → TP → TPU
- ✅ 561 drugs mapped to TMT TPU
- ✅ Ready for ministry reporting & HIS integration

---

## 📊 Database Statistics

```sql
-- After full import (npm run setup:full):

Total Tables:           52
Total Enums:            22
Total Views:            11
Total Functions:        12

Total Records:          81,353
  - Master Data:        ~50
  - Drug Master:        3,006
  - Lookup Tables:      213
  - FK Mappings:        1,085
  - TMT Concepts:       76,904
  - Drug-TMT Map:       561

Database Size:          ~50-80 MB
```

---

## ✅ Verification

### Check Database Connection
```bash
npm run dev
```

Expected output:
```
✅ Database connected successfully!
📍 Locations in database: 5
💊 Drugs in database: 1169
🏢 Companies in database: 5
```

### Check Data Completeness
```bash
npm run db:studio
```

Then browse:
- `tmt_concepts` table (expect 76,904 records) ⭐
- `drugs` table (expect 1,169 records)
- `drug_generics` table (expect 1,109 records)
- `dosage_forms` table (expect 107 records) ⭐
- `drug_units` table (expect 88 records) ⭐

---

## 🚀 Next Steps

### Option 1: Backend API Development (Recommended)

**Why now?**
- ✅ Complete schema (52 tables)
- ✅ Full data (81,353 records)
- ✅ Business functions ready
- ✅ TMT integration ready

**Suggested stack:**
- Fastify 5 + Prisma + TypeScript
- Zod for validation
- JWT authentication
- Swagger/OpenAPI docs

### Option 2: Frontend Development

**Why now?**
- ✅ Complete data for UI testing
- ✅ Can use Prisma Studio as mock API
- ✅ UI mockups available (FLOW_08)

**Suggested stack:**
- React + TypeScript + Vite
- shadcn/ui + TailwindCSS
- TanStack Query
- React Hook Form + Zod

---

## 🔧 Troubleshooting

### Common Issues

**Containers not starting:**
```bash
docker-compose down -v
docker-compose up -d
```

**Migration drift error:**
```bash
npm run db:migrate -- --force
```

**Import fails:**
```bash
# Check MySQL container
docker ps | grep mysql
docker-compose restart invs-mysql-original

# Re-run specific phase
npm run import:phase5  # example
```

**Database reset:**
```bash
npm run db:reset
npm run setup:full
```

---

## 📞 Support

### Issues & Questions
- Check [PROJECT_STATUS.md](PROJECT_STATUS.md) for current status
- Check [QUICK_START.md](QUICK_START.md) for setup help
- Check [SETUP_FRESH_CLONE.md](SETUP_FRESH_CLONE.md) for detailed guide

### Additional Resources
- Prisma Documentation: https://www.prisma.io/docs
- PostgreSQL Documentation: https://www.postgresql.org/docs/
- Docker Documentation: https://docs.docker.com/

---

## 📈 Version History

### v2.6.0 (2025-01-28) ⭐ CURRENT
- ✅ Phase 5-8 migration complete
- ✅ Lookup tables imported (213 records)
- ✅ FK mappings complete (1,085 mappings)
- ✅ TMT concepts imported (76,904 records)
- ✅ Drug-TMT mapping complete (561 drugs)
- ✅ Total records: 81,353 (Full dataset)
- ✅ Production ready for backend development

### v2.5.0 (2025-01-23)
- ✅ BRD + TRD documentation complete (Thai)
- ✅ Phase 1-4 migration complete (3,152 records)
- ✅ Ministry compliance 100% complete

### v2.4.0 (2025-01-22)
- ✅ Phase 4 drug master migration (3,006 records)
- ✅ 52 tables complete
- ✅ Drug catalog unlocked

---

## 📝 License

MIT License

---

## 🤝 Contributing

This is a database schema project. For contribution guidelines, please refer to the documentation.

---

**Status**: ✅ **PRODUCTION READY** (Full Data Migration Complete)
**Version**: 2.6.0
**Last Updated**: 2025-01-28

*Built with ❤️ for INVS Modern Team*
*Database + Full Data (81K records) Ready for Backend Development! 🚀*
