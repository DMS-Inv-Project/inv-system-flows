# INVS Modern 🏥

Modern Hospital Inventory Management System built with PostgreSQL, Prisma, and TypeScript.

**Version**: 2.4.0 | **Status**: ✅ Schema Complete (Drug Master Imported 🔓) | **Last Updated**: 2025-01-22

---

## ⚠️ **Project Scope**

**This repository is a DATABASE SCHEMA + DOCUMENTATION PROJECT ONLY**

✅ What's included: Prisma schema, SQL functions/views, migration scripts, documentation
❌ Not included: Backend API, Frontend (separate projects)

---

## 📊 Current Project Status

```
✅ Database: Complete (52 tables, 11 views, 12 functions, 22 enums) ⭐ +16 tables
✅ Data Migrated: 3,152 records (Phase 1-4) 🔓 ⭐ NEW
✅ Drug Master: 1,109 generics + 1,169 trade drugs 🔓 ⭐ NEW
✅ Drug Components: 736 records (allergy checking) 🔓 ⭐ NEW
✅ Ministry Compliance: 100% COMPLETE (79/79 fields) 🎉
✅ 5 Export Files: DRUGLIST, PURCHASEPLAN, RECEIPT, DISTRIBUTION, INVENTORY
✅ Docker Setup: Working (PostgreSQL + MySQL legacy)
✅ Documentation: Complete (23 comprehensive guides + 4 migration reports)
✅ Seed Data: Complete (5 entities, 29 records)
✅ Budget Planning: Drug-level planning feature added
❌ Backend API: Not in this repo (separate project)
❌ Frontend: Not in this repo (separate project)
```

**🎊 Latest Achievement**: Phase 4 Complete - Drug Master Data Imported! (+2,059% data increase) 🔓

**📋 For complete status**: See [PROJECT_STATUS.md](PROJECT_STATUS.md)

---

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- Git

### 1. Start Database
```bash
# Start all containers (PostgreSQL + MySQL + pgAdmin + phpMyAdmin)
docker-compose up -d

# Check if containers are healthy
docker ps | grep invs
```

### 2. Setup Project
```bash
# Install dependencies
npm install

# Generate Prisma client
npm run db:generate

# Push schema to database
npm run db:push

# Seed master data
npm run db:seed

# Apply functions and views
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/functions.sql
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/views.sql
```

### 3. Verify Installation
```bash
# Test database connection
npm run dev

# Open Prisma Studio
npm run db:studio
# Navigate to: http://localhost:5555
```

**Expected Output:**
```
✅ Database connected successfully!
📍 Locations in database: 5
💊 Drug Generics in database: 1109
💊 Trade Drugs in database: 1169
🏢 Companies in database: 5
```

---

## 📚 Documentation

### Essential Guides (Start Here)
1. **[PROJECT_STATUS.md](PROJECT_STATUS.md)** ⭐ - Current status & next steps
2. **[SYSTEM_SETUP_GUIDE.md](SYSTEM_SETUP_GUIDE.md)** - Complete setup instructions
3. **[FINAL_SUMMARY.md](FINAL_SUMMARY.md)** - System architecture summary
4. **[docs/flows/QUICK_START_GUIDE.md](docs/flows/QUICK_START_GUIDE.md)** - Quick start guide

### Flow Documentation
1. **[FLOW_01_Master_Data_Setup.md](docs/flows/FLOW_01_Master_Data_Setup.md)** - Master data management
2. **[FLOW_02_Budget_Management.md](docs/flows/FLOW_02_Budget_Management.md)** - Budget control workflow
3. **[FLOW_02B_Budget_Planning_with_Drugs.md](docs/flows/FLOW_02B_Budget_Planning_with_Drugs.md)** - Drug-level budget planning ⭐ NEW
4. **[FLOW_03_Procurement_Part1_PR.md](docs/flows/FLOW_03_Procurement_Part1_PR.md)** - Purchase requests
5. **[FLOW_04_Inventory_Management.md](docs/flows/FLOW_04_Inventory_Management.md)** - Inventory & FIFO/FEFO
6. **[FLOW_05_Drug_Distribution.md](docs/flows/FLOW_05_Drug_Distribution.md)** - Department distribution
7. **[FLOW_06_TMT_Integration.md](docs/flows/FLOW_06_TMT_Integration.md)** - Thai Medical Terminology
8. **[FLOW_07_Ministry_Reporting.md](docs/flows/FLOW_07_Ministry_Reporting.md)** - Ministry reports (5 files)
9. **[FLOW_08_Frontend_Purchase_Request.md](docs/flows/FLOW_08_Frontend_Purchase_Request.md)** - Frontend UI guide
10. **[DATA_FLOW_COMPLETE_GUIDE.md](docs/flows/DATA_FLOW_COMPLETE_GUIDE.md)** - All flows summary

### Technical Documentation
- **[prisma/schema.prisma](prisma/schema.prisma)** - Database schema (52 tables, 22 enums) ⭐ **+16 tables**
- **[prisma/functions.sql](prisma/functions.sql)** - Business logic functions (12)
- **[prisma/views.sql](prisma/views.sql)** - Reporting views (11)
- **[MYSQL_IMPORT_GUIDE.md](docs/MYSQL_IMPORT_GUIDE.md)** - Import legacy database
- **[docs/project-tracking/MINISTRY_5_FILES_ANALYSIS.md](docs/project-tracking/MINISTRY_5_FILES_ANALYSIS.md)** - Ministry compliance analysis

### Migration Reports ⭐ NEW
- **[docs/MISSING_TABLES_ANALYSIS.md](docs/MISSING_TABLES_ANALYSIS.md)** - Original 12 missing tables analysis
- **[docs/PHASE1_MIGRATION_SUMMARY.md](docs/PHASE1_MIGRATION_SUMMARY.md)** - Phase 1: Procurement (4 tables, 57 records)
- **[docs/PHASE2_MIGRATION_SUMMARY.md](docs/PHASE2_MIGRATION_SUMMARY.md)** - Phase 2: Drug info (2 tables, 821 records)
- **[docs/PHASE3_MIGRATION_SUMMARY.md](docs/PHASE3_MIGRATION_SUMMARY.md)** - Phase 3: Distribution (2 tables, 4 records)
- **[docs/PHASE4_MIGRATION_SUMMARY.md](docs/PHASE4_MIGRATION_SUMMARY.md)** - Phase 4: Drug master (3,006 records) 🔓
- **[docs/REMAINING_TABLES_SUMMARY.md](docs/REMAINING_TABLES_SUMMARY.md)** - 4 optional tables left

---

## 🗄️ Database Architecture

### Current Setup (Simplified 2-Database Architecture)

```
┌──────────────────────┐       ┌──────────────────────┐
│   MySQL (Legacy)     │       │ PostgreSQL (Modern)  │
│   Port: 3307         │       │  Port: 5434          │
│   invs_banpong       │◄─────►│  invs_modern         │
│   133 tables         │Migrate│  52 tables ⭐ +16    │
│   📖 Reference Only  │       │  📝 Production       │
│                      │       │  22 enums            │
│                      │       │  3,152 records 🔓   │
│                      │       │  100% Ministry ✅    │
└──────────────────────┘       └──────────────────────┘
       ↓                               ↓
  phpMyAdmin                      pgAdmin
  :8082                           :8081
```

### PostgreSQL (Production) - 36 Tables ⭐

**Master Data (6 tables)**
- `locations` - Storage locations
- `departments` - Hospital departments + ministry consumption groups ⭐
- `budget_types` - Budget categories
- `companies` - Vendors/manufacturers
- `drug_generics` - Generic drug catalog
- `drugs` - Trade drugs + ministry compliance fields (NLEM, status, category) ⭐

**Budget Management (4 tables)** ⭐ NEW
- `budget_allocations` - Annual budget by quarter (Q1-Q4)
- `budget_reservations` - Budget reservation system
- `budget_plans` - Drug-level budget planning (from legacy system)
- `budget_plan_items` - Drug items with 3-year historical data

**Procurement (6 tables)**
- `purchase_requests` - Purchase request workflow
- `purchase_request_items` - PR line items
- `purchase_orders` - Purchase orders
- `purchase_order_items` - PO line items
- `receipts` - Goods receiving
- `receipt_items` - Receipt line items

**Inventory (3 tables)**
- `inventory` - Stock levels per location
- `drug_lots` - FIFO/FEFO lot tracking
- `inventory_transactions` - All movements

**Distribution (2 tables)**
- `drug_distributions` - Department distributions
- `drug_distribution_items` - Distribution line items

**TMT Integration (3 tables)**
- `tmt_concepts` - Thai Medical Terminology (25,991 concepts)
- `tmt_mappings` - Drug-TMT mappings
- `his_drug_master` - HIS integration

**Database Functions (12)** ⭐ NEW
- Budget: `check_budget_availability`, `reserve_budget`, `commit_budget`, `release_budget`
- Budget Planning: `check_drug_in_budget_plan`, `update_budget_plan_purchase` ⭐ NEW
- Inventory: `get_fifo_lots`, `get_fefo_lots`, `update_inventory_from_receipt`
- Others: 3 utility functions

**Database Views (11)**
- Ministry Exports: `export_druglist`, `export_purchase_plan`, `export_receipt`, `export_distribution`, `export_inventory`
- Operational: `budget_status_current`, `expiring_drugs`, `low_stock_items`, `current_stock_summary`, `budget_reservations_active`, `purchase_order_status`

---

## 📊 Database Access

### PostgreSQL (Production)
- **Host**: localhost
- **Port**: 5434
- **Database**: invs_modern
- **Username**: invs_user
- **Password**: invs123

### MySQL (Legacy Reference)
- **Host**: localhost
- **Port**: 3307
- **Database**: invs_banpong
- **Username**: invs_user
- **Password**: invs123

### Web Interfaces
- **Prisma Studio**: http://localhost:5555 (run `npm run db:studio`)
- **pgAdmin**: http://localhost:8081 (admin@invs.com / invs123)
- **phpMyAdmin**: http://localhost:8082 (invs_user / invs123)

---

## 🛠️ Available Scripts

### Development
```bash
npm run dev              # Start development server
npm run build            # Build TypeScript
npm start                # Run built application
```

### Database
```bash
npm run db:generate      # Generate Prisma client
npm run db:push          # Push schema to database
npm run db:migrate       # Create and run migration
npm run db:seed          # Seed master data
npm run db:studio        # Open Prisma Studio
```

### MySQL Legacy Import (Optional)
```bash
# Place SQL file in: scripts/INVS_MySQL_Database_20231119.sql
./scripts/import-mysql-legacy.sh
```

---

## 💰 Key Features

### 1. Budget Management
- ✅ Quarterly allocation (Q1-Q4)
- ✅ Real-time budget checking
- ✅ Budget reservation system
- ✅ Automatic budget commitment
- ✅ Budget monitoring dashboard
- ✅ **Drug-level budget planning** ⭐ NEW
  - Plan drug purchases with 3-year historical analysis
  - Quarterly quantity breakdown (Q1-Q4)
  - Track actual purchases vs. plan
  - Automatic PR validation against plan

**Example:**
```typescript
// Check budget availability
const available = await check_budget_availability(
  fiscal_year: 2025,
  budget_type_id: 1,
  department_id: 2,
  amount: 50000,
  quarter: 1
)

// Check if drug is in budget plan ⭐ NEW
const inPlan = await check_drug_in_budget_plan(
  fiscal_year: 2025,
  department_id: 2,
  generic_id: 1,
  requested_qty: 5000,
  quarter: 1
)
```

### 2. Procurement Workflow
```
Draft → Submit → Budget Check → Approve →
Create PO → Send → Receive → Post to Inventory
```

### 3. Inventory Management
- ✅ FIFO/FEFO lot tracking
- ✅ Multi-location support
- ✅ Expiry date monitoring
- ✅ Low stock alerts
- ✅ Average cost calculation

### 4. Ministry Compliance
- ✅ 5 export files for Ministry of Public Health
- ✅ TMT integration (25,991 concepts)
- ✅ HIS integration ready
- ✅ Standardized drug codes

---

## 📁 Project Structure

```
invs-modern/
├── prisma/
│   ├── schema.prisma          # 34 tables, 880+ lines ⭐
│   ├── functions.sql          # 12 functions, 610+ lines ⭐
│   ├── views.sql              # 11 views, 378 lines
│   ├── seed.ts                # Master data seeding
│   └── migrations/            # Version control
│
├── src/
│   ├── index.ts               # Database connection test
│   └── lib/
│       └── prisma.ts          # Prisma client setup
│
├── scripts/
│   ├── import-mysql-legacy.sh # MySQL import script
│   ├── tmt/                   # TMT management (4 scripts)
│   ├── integration/           # Integration scripts (2)
│   └── archive/               # Legacy scripts
│
├── docs/
│   ├── flows/                 # 9 detailed flow docs + complete guide ⭐
│   ├── MYSQL_IMPORT_GUIDE.md
│   ├── LARGE_FILES_GUIDE.md
│   └── SCRIPT_CLEANUP_GUIDE.md
│
├── SYSTEM_SETUP_GUIDE.md      # Complete setup guide
├── FINAL_SUMMARY.md           # System summary
├── PROJECT_STATUS.md          # Current status ⭐
├── CLAUDE.md                  # AI assistant context
├── README.md                  # This file
└── docker-compose.yml         # 2 databases + 2 UIs
```

---

## 🚧 Next Steps

### Phase 1: Backend API Development (Current Priority)

**Required:**
- [ ] REST API endpoints (Express/Fastify)
- [ ] Authentication & Authorization
- [ ] Request validation (Zod)
- [ ] Error handling middleware
- [ ] API documentation (Swagger/OpenAPI)

**Recommended Tech Stack:**
- Express.js or Fastify
- TypeScript + Prisma
- Zod for validation
- JWT for authentication

### Phase 2: Frontend Development

**Required:**
- [ ] React application setup
- [ ] Component library (shadcn/ui + TailwindCSS)
- [ ] State management (TanStack Query)
- [ ] Forms (React Hook Form + Zod)
- [ ] UI for all flows

**Reference:** See `docs/flows/FLOW_08_Frontend_Purchase_Request.md` for complete UI guide

---

## 🔄 Session Recovery (If Context Lost)

### Quick Health Check
```bash
# 1. Check containers
docker ps | grep invs
# Expected: 4 containers (postgres, mysql, pgadmin, phpmyadmin)

# 2. Test connection
npm run dev
# Expected: ✅ Database connected successfully!

# 3. Check tables
docker exec invs-modern-db psql -U invs_user -d invs_modern -c "\dt"
# Expected: 34 tables listed (includes budget_plans, budget_plan_items)

# 4. Read current status
cat PROJECT_STATUS.md
```

### If Something Broken
```bash
# Complete reset (deletes all data!)
docker-compose down -v

# Fresh setup (5 minutes)
docker-compose up -d
npm run db:generate
npm run db:push
npm run db:seed
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/functions.sql
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/views.sql
```

---

## 🔐 Environment Variables

Create `.env` file:
```env
DATABASE_URL="postgresql://invs_user:invs123@localhost:5434/invs_modern?schema=public"
NODE_ENV=development
PORT=3000
```

---

## 📈 Success Metrics

| Metric | Status | Details |
|--------|--------|---------|
| Database Design | ✅ Complete | 34 tables, normalized ⭐ |
| Business Logic | ✅ Complete | 12 functions, 11 views ⭐ |
| Documentation | ✅ Complete | 14 comprehensive guides ⭐ |
| Budget Planning | ✅ Complete | Drug-level planning ⭐ NEW |
| Docker Setup | ✅ Complete | Tested & verified |
| Backend API | 🚧 Not Started | Next priority |
| Frontend | 🚧 Not Started | After backend |

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🆘 Support

- **Documentation**: See `docs/` folder and `PROJECT_STATUS.md`
- **Setup Guide**: `SYSTEM_SETUP_GUIDE.md`
- **Flow Guides**: `docs/flows/` directory
- **Database Schema**: Use Prisma Studio (http://localhost:5555)

---

**INVS Modern** - Making hospital inventory management efficient and reliable! 🏥✨

**Status**: ✅ Ready for Backend API Development
**Last Verified**: 2025-01-11
**Next Phase**: Build REST API
