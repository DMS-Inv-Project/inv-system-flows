# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## 🚨 SESSION RECOVERY - READ THIS FIRST

**If starting a new session or context was lost**, follow these steps immediately:

### Step 1: Read Current Status
```bash
# Read this file first to understand project state
cat PROJECT_STATUS.md
```

### Step 2: Verify System Health
```bash
# Check if containers are running
docker ps | grep invs
# Expected: 4 containers (invs-modern-db, invs-mysql-original, invs-modern-pgadmin, invs-phpmyadmin)

# Test database connection
npm run dev
# Expected: ✅ Database connected successfully!
```

### Step 3: Quick Facts (Current State)
- **Project Type**: 📋 Database Schema + Documentation ONLY
- **Status**: ✅ Full Data Migration Complete 🎉
- **Version**: 2.6.0 (Updated 2025-01-28)
- **Database**: 52 tables, 11 views, 12 functions, 22 enums ⭐
- **Data Migrated**: 81,353 records (Phase 1-8 COMPLETE) 🚀 ⭐ NEW
- **Drug Catalog**: 1,109 generics + 1,169 trade drugs 🔓
- **Lookup Tables**: 107 dosage forms + 88 drug units 🔓 ⭐ NEW
- **TMT Integration**: 76,904 concepts (5 levels) 🔓 ⭐ NEW
- **Drug-TMT Mapping**: 561 drugs (47.99% coverage) 🔓 ⭐ NEW
- **Ministry Compliance**: 100% COMPLETE (79/79 fields) 🎉
- **Budget Planning**: Drug-level planning with historical data
- **Backend API**: ❌ Not in this repo (separate project)
- **Frontend**: ❌ Not in this repo (separate project)
- **Last Verified**: 2025-01-28

### Step 4: Key Files to Review
1. `PROJECT_STATUS.md` - Complete current status
2. `README.md` - Quick start guide
3. `SYSTEM_SETUP_GUIDE.md` - Setup instructions
4. `FINAL_SUMMARY.md` - Architecture summary

---

## ⚠️ **IMPORTANT: Project Scope**

**This repository is a DATABASE SCHEMA + DOCUMENTATION PROJECT ONLY**

✅ **What this repo contains**:
- Prisma schema definition (`prisma/schema.prisma`)
- Database functions and views (`.sql` files)
- Migration scripts (TypeScript for data import)
- Comprehensive documentation (46 markdown files)
- Database setup and seed data

❌ **What this repo does NOT contain**:
- Backend API (Express/Fastify) - **Not in this repo**
- Frontend application (React) - **Not in this repo**
- Business logic controllers - **Not in this repo**
- API routes/endpoints - **Not in this repo**

**Purpose**: Schema-first design approach for hospital inventory management system. This repo serves as the **database layer blueprint** and **documentation hub** for the INVS Modern project.

---

## Project Overview

**INVS Modern** - Database schema and documentation for a modern hospital inventory management system built with PostgreSQL and Prisma ORM.

- **Database**: PostgreSQL 15-alpine (Container: invs-modern-db, Port: 5434)
- **ORM**: Prisma with full type safety
- **Primary Language**: TypeScript (for migration scripts only)
- **Version**: 2.6.0
- **Status**: ✅ Full Data Migration Complete (52 tables, 81,353 records migrated) 🚀

---

## Current System State

### ✅ What's Complete (This Repo)

**Database Infrastructure:**
- ✅ PostgreSQL (Production) - 52 tables, 22 enums ⭐
- ✅ MySQL (Legacy Reference) - Container ready, data migrated
- ✅ Database Functions - 12 business logic functions
- ✅ Database Views - 11 reporting views
- ✅ Data Migration - 81,353 records (Phase 1-8 COMPLETE) 🚀 ⭐ NEW
- ✅ Drug Master Data - 1,109 generics + 1,169 trade drugs 🔓
- ✅ Lookup Tables - 107 dosage forms + 88 drug units 🔓 ⭐ NEW
- ✅ TMT Integration - 76,904 concepts (5 levels) 🔓 ⭐ NEW
- ✅ Drug-TMT Mapping - 561 drugs (47.99% coverage) 🔓 ⭐ NEW
- ✅ Seed Data - Complete master data
- ✅ Docker Compose - 2 databases + 2 web UIs
- ✅ Budget Planning - Drug-level planning with historical data
- ✅ Ministry Compliance - 100% COMPLETE (79/79 fields) 🎉

**Documentation:**
- ✅ 54+ comprehensive guides created ⭐
- ✅ 8 Systems documentation (all updated to v2.6.0) ⭐
  - 01-master-data (Phase 5-8 impact)
  - 02-budget-management
  - 03-procurement
  - 04-inventory
  - 05-distribution
  - 06-drug-return
  - 07-tmt-integration (Phase 7-8 impact) ⭐
  - 08-hpp-system
- ✅ **8 API Development Guides** (100% complete) 🎉 ⭐ NEW
  - Complete RBAC matrix (5 roles)
  - API priorities (phased approach)
  - Error handling (150+ error codes)
  - Request/Response examples (40+)
  - Environment config
  - Testing guidelines
- ✅ 9 detailed flow documents with UI mockups
- ✅ 7 migration summary reports
- ✅ Complete system setup guide
- ✅ MySQL import guide
- ✅ Frontend development guide
- ✅ Ministry compliance analysis

**Testing:**
- ✅ Schema tested and verified (2025-01-28)
- ✅ All containers healthy
- ✅ Database connection verified
- ✅ Prisma queries working
- ✅ 81,353 records migrated successfully ⭐ NEW

### ❌ What's NOT in This Repo

**These are SEPARATE projects:**
- ❌ Backend API (Express/Fastify) - **Not in this repo**
- ❌ Authentication & Authorization - **Not in this repo**
- ❌ Frontend Application (React) - **Not in this repo**
- ❌ Production Deployment - **Not in this repo**

**This repo focus**: Database schema design + Documentation ONLY

---

## Development Commands

### Quick Health Check
```bash
# Verify everything is working
docker ps | grep invs          # Check containers (expect 4)
npm run dev                    # Test connection (expect ✅)
npm run db:studio              # Open Prisma Studio
```

### Database Management
```bash
# Start all containers
docker-compose up -d

# Stop services
docker-compose down

# Connect to PostgreSQL
docker exec -it invs-modern-db psql -U invs_user -d invs_modern

# Connect to MySQL (optional)
docker exec -it invs-mysql-original mysql -u invs_user -pinvs123 invs_banpong

# Generate Prisma client after schema changes
npm run db:generate

# Push schema changes to database
npm run db:push

# Create and apply migrations
npm run db:migrate

# Seed master data
npm run db:seed

# Apply functions and views
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/functions.sql
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/views.sql

# Open Prisma Studio for database visualization
npm run db:studio
```

### Application Development
```bash
# Install dependencies
npm install

# Development mode with auto-reload
npm run dev

# Build TypeScript to JavaScript
npm run build

# Run production build
npm start
```

---

## Database Connection Details

### PostgreSQL Modern Database (Production)
- Host: localhost
- Port: 5434
- Database: invs_modern
- Username: invs_user
- Password: invs123
- **Status**: ✅ Active, 52 tables, 11 views, 12 functions, 22 enums ⭐

### MySQL Original Database (Legacy Reference)
- Host: localhost
- Port: 3307
- Database: invs_banpong
- Username: invs_user
- Password: invs123
- **Status**: ⚠️ Container ready, data not imported (optional)
- **Import Script**: `./scripts/import-mysql-legacy.sh`

### Web Interfaces
**pgAdmin:**
- URL: http://localhost:8081
- Email: admin@invs.com
- Password: invs123

**phpMyAdmin:**
- URL: http://localhost:8082
- Username: invs_user
- Password: invs123

**Prisma Studio:**
- URL: http://localhost:5555 (after running `npm run db:studio`)

---

## Architecture Overview

### Current Database Architecture (Simplified)

```
┌──────────────────────┐       ┌──────────────────────┐
│   MySQL (Legacy)     │       │ PostgreSQL (Modern)  │
│   Port: 3307         │       │  Port: 5434          │
│   invs_banpong       │◄─────►│  invs_modern         │
│   133 tables         │Compare│  52 tables ⭐        │
│   📖 Reference Only  │       │  📝 Production       │
│                      │       │  22 enums ⭐         │
│                      │       │  100% Ministry ✅    │
└──────────────────────┘       └──────────────────────┘
       ↓                               ↓
  phpMyAdmin                     pgAdmin + Prisma
  :8082                          :8081    :5555
```

### Database Schema Structure (34 Tables)

#### 1. Master Data (6 tables)
- `locations` - Storage locations (warehouse, pharmacy, ward, emergency)
- `departments` - Hospital departments with budget codes and hierarchy
- `budget_types` - Budget categories (operational, investment, emergency)
- `companies` - Vendors and manufacturers with contact details
- `drug_generics` - Generic drug catalog with working codes
- `drugs` - Trade drug catalog linked to generics and manufacturers

#### 2. Inventory Management (3 tables)
- `inventory` - Stock levels per drug/location with min/max levels
- `drug_lots` - FIFO/FEFO lot tracking with expiry dates
- `inventory_transactions` - All inventory movements with audit trail

#### 3. Budget Management (4 tables) ⭐ NEW
- `budget_allocations` - Annual budget allocation by quarter (Q1-Q4)
- `budget_reservations` - Budget reservations for purchase requests
- `budget_plans` - Drug-level budget planning (from legacy buyplan) ⭐ NEW
- `budget_plan_items` - Drug items with 3-year historical data ⭐ NEW

#### 4. Procurement Workflow (6 tables)
- `purchase_requests` - Purchase request workflow with approval
- `purchase_request_items` - Detailed items in requests
- `purchase_orders` - Purchase orders with vendor integration
- `purchase_order_items` - Items in purchase orders
- `receipts` - Goods receiving documents
- `receipt_items` - Items received with lot information

#### 5. Distribution (2 tables)
- `drug_distributions` - Department distribution requests
- `drug_distribution_items` - Distribution line items

#### 6. TMT Integration (3 tables)
- `tmt_concepts` - Thai Medical Terminology (76,904 concepts) ⭐ NEW
- `tmt_mappings` - Drug-to-TMT code mappings (561 drugs mapped) ⭐ NEW
- `his_drug_master` - HIS integration master data

#### 7. Optional Historical Data (1 table)
- `historical_drug_data` - Manual/imported historical consumption data (optional)

#### 8. Others (9 tables)
- Supporting tables and audit logs

### Database Functions (12) ⭐

**Budget Management:**
- `check_budget_availability(fiscal_year, budget_type_id, department_id, amount, quarter)` - Real-time budget validation
- `reserve_budget(allocation_id, pr_id, amount, expires_days)` - Reserve budget for PR
- `commit_budget(allocation_id, po_id, amount, quarter)` - Commit budget when PO approved
- `release_budget_reservation(reservation_id)` - Release expired/cancelled reservations

**Budget Planning:** ⭐ NEW
- `check_drug_in_budget_plan(fiscal_year, department_id, generic_id, requested_qty, quarter)` - Validate PR against budget plan
- `update_budget_plan_purchase(plan_item_id, quantity, value, quarter)` - Update purchased amounts

**Inventory Management:**
- `get_fifo_lots(drug_id, location_id, quantity_needed)` - Get lots in FIFO order
- `get_fefo_lots(drug_id, location_id, quantity_needed)` - Get lots in FEFO order
- `update_inventory_from_receipt(receipt_id)` - Auto-update inventory on receipt

**Utilities:**
- 3 additional utility functions

### Database Views (11)

**Ministry Exports (5 views):**
- `export_druglist` - Drug catalog for ministry reporting
- `export_purchase_plan` - Purchase planning data
- `export_receipt` - Goods receiving records
- `export_distribution` - Distribution records
- `export_inventory` - Inventory status

**Operational Views (6 views):**
- `budget_status_current` - Real-time budget status by department
- `expiring_drugs` - Drugs approaching expiry date
- `low_stock_items` - Items below reorder point
- `current_stock_summary` - Stock summary by location
- `budget_reservations_active` - Active budget reservations
- `purchase_order_status` - PO tracking dashboard

---

## Key Business Logic

### Budget Control Flow
```typescript
// Budget flows: Planning → Allocation → Request → Control → Monitoring
// Each department has quarterly budget allocations (Q1-Q4)
// Real-time budget checking before purchase approval
// Automatic budget deduction when purchase orders are finalized
```

### Inventory Management Rules
- **FIFO/FEFO**: First In First Out / First Expire First Out
- **Reorder Points**: Automatic calculation based on usage patterns
- **Multi-location**: Support for warehouse, pharmacy, ward storage
- **Lot Tracking**: Complete traceability with expiry date management

### Procurement Workflow
```
Draft PR → Submit → Budget Check → Approve → Create PO → Send → Receive → Post to Inventory
```

---

## Important Files and Directories

### Status & Documentation (READ FIRST)
- `PROJECT_STATUS.md` ⭐ - Current status, next steps, session recovery
- `README.md` - Quick start and overview
- `SYSTEM_SETUP_GUIDE.md` - Complete setup instructions
- `FINAL_SUMMARY.md` - System architecture summary
- `CLAUDE.md` - This file

### Core Database Files (Schema ONLY)
- `src/index.ts` - Database connection test script
- `src/lib/prisma.ts` - Prisma client configuration with global instance pattern
- `prisma/schema.prisma` - Complete database schema (52 tables, 22 enums, 950+ lines) ⭐
- `prisma/functions.sql` - Business logic functions (12 functions, 610+ lines) ⭐
- `prisma/views.sql` - Reporting views (11 views, 378 lines)
- `prisma/seed.ts` - Master data seeding script

### Migration Scripts (Data Import)
- `scripts/migrate-phase1-data.ts` - Procurement master data (57 records)
- `scripts/migrate-phase2-data.ts` - Drug components & UOM (821 records)
- `scripts/migrate-phase3-data.ts` - Distribution support (4 records)
- `scripts/migrate-phase4-drug-master.ts` - Drug master data (3,006 records)
- `scripts/migrate-phase5-lookup-tables.ts` - Lookup tables (213 records) ⭐ NEW
- `scripts/migrate-phase6-map-string-to-fk.ts` - FK mappings (1,085 mappings) ⭐ NEW
- `scripts/migrate-phase7-tmt-concepts.ts` - TMT concepts (76,904 records) ⭐ NEW
- `scripts/migrate-phase8-map-tmt.ts` - Drug-TMT mapping (561 mappings) ⭐ NEW
- `scripts/import-mysql-legacy.sh` - Import MySQL legacy database (optional)
- `scripts/tmt/` - TMT management scripts (4 files)
- `scripts/integration/` - Integration scripts (2 files)
- `scripts/archive/` - Archived legacy migration scripts

### Flow Documentation
- `docs/flows/QUICK_START_GUIDE.md` - Quick start guide
- `docs/flows/DATA_FLOW_COMPLETE_GUIDE.md` - All flows summary (updated)
- `docs/flows/FLOW_01_Master_Data_Setup.md` - Master data setup
- `docs/flows/FLOW_02_Budget_Management.md` - Budget management
- `docs/flows/FLOW_02B_Budget_Planning_with_Drugs.md` - Drug-level planning ⭐ NEW
- `docs/flows/FLOW_03_Procurement_Part1_PR.md` - Purchase requests
- `docs/flows/FLOW_04_Inventory_Management.md` - Inventory & FIFO/FEFO
- `docs/flows/FLOW_05_Drug_Distribution.md` - Distribution
- `docs/flows/FLOW_06_TMT_Integration.md` - Thai Medical Terminology
- `docs/flows/FLOW_07_Ministry_Reporting.md` - Ministry reports
- `docs/flows/FLOW_08_Frontend_Purchase_Request.md` - Frontend UI guide with mockups

### Configuration
- `docker-compose.yml` - 2 databases + 2 web UIs (PostgreSQL, MySQL, pgAdmin, phpMyAdmin)
- `tsconfig.json` - TypeScript configuration for ES2020 target
- `package.json` - Dependencies and npm scripts
- `.env` - Environment variables (DATABASE_URL)

---

## Data Seeding

The seed script (`prisma/seed.ts`) creates:
- 5 Locations (Main Warehouse, Central Pharmacy, Emergency, ICU, OPD)
- 5 Departments (Admin, Pharmacy, Nursing, Medical, Laboratory)
- 6 Budget Types (Operational drugs/equipment/supplies, Investment equipment/IT, Emergency)
- 5 Companies (GPO, Zuellig Pharma, Pfizer, Sino-Thai, Berlin Pharmaceutical)
- 5 Drug Generics (Paracetamol, Ibuprofen, Amoxicillin, Aspirin, Omeprazole)
- 3 Budget Allocations for 2025 fiscal year

**Status**: ✅ Seed data loaded and verified

---

## Development Guidelines

### Working with Database Schema
- Always generate Prisma client after schema changes: `npm run db:generate`
- Use `npm run db:push` for development schema changes
- Use `npm run db:migrate` for production-ready migrations
- Test schema changes with `npm run db:studio`

### TypeScript Best Practices
- Use Prisma generated types for database operations
- Enable strict TypeScript compilation
- Use the global Prisma instance from `src/lib/prisma.ts`
- Follow existing patterns in seed file for data operations

### Database Operations
- Use Prisma's `upsert` for idempotent operations
- Implement proper error handling for database connections
- Use transactions for multi-table operations
- Follow the established enum patterns for status fields

### Budget System Integration
- Always check budget availability before creating purchase orders
- Respect quarterly budget allocations (Q1-Q4)
- Use budget reservations for temporary holds
- Implement proper audit trails for budget transactions

### Inventory Management
- Respect FIFO/FEFO rules for drug dispensing
- Maintain proper lot tracking with expiry dates
- Update stock levels atomically
- Use appropriate transaction types (RECEIVE, ISSUE, TRANSFER, ADJUST, RETURN)

---

## Environment Variables

Required `.env` file:
```env
DATABASE_URL="postgresql://invs_user:invs123@localhost:5434/invs_modern?schema=public"
NODE_ENV=development
```

---

## Next Steps (For Other Projects)

⚠️ **IMPORTANT**: This repo contains DATABASE SCHEMA ONLY. Backend API and Frontend are SEPARATE projects.

### For Backend API Project (Separate Repo)

**Not in this repo** - Create a new repository for backend API

**Recommended tech stack:**
- Express.js or Fastify
- TypeScript + Prisma (import schema from this repo)
- Zod for validation
- JWT for authentication

**Use this repo's schema:**
```bash
# In backend project, reference this schema
cp ../invs-modern/prisma/schema.prisma ./prisma/
npm run db:generate
```

**Required Endpoints:**
1. Authentication (POST /api/auth/login, /logout)
2. Master Data CRUD (GET/POST/PUT/DELETE /api/[entity])
3. Purchase Request workflow (POST /api/purchase-requests)
4. Budget checking (POST /api/budget/check-availability)
5. Inventory queries (GET /api/inventory)

### For Frontend Project (Separate Repo)

**Not in this repo** - Create a new repository for frontend

**Recommended tech stack:**
- React + TypeScript
- TanStack Query (React Query)
- shadcn/ui + TailwindCSS
- React Hook Form + Zod

**Use this repo's documentation:**
- See `docs/flows/FLOW_08_Frontend_Purchase_Request.md` for complete UI mockups
- See `docs/systems/` for API specifications
- See `docs/flows/` for business logic and workflows

### This Repo Focus

✅ **Continue to maintain:**
- Database schema design
- Migration scripts
- Documentation
- Business logic in SQL functions/views
- Schema evolution and versioning

---

## Prisma Configuration

The project uses Prisma with:
- PostgreSQL provider
- Full type generation
- Query logging enabled in development
- Connection pooling
- Global instance pattern to prevent multiple connections

---

## Testing Database Connection

Run the main application to test database connectivity:
```bash
npm run dev
```

**Expected Output:**
```
🏥 INVS Modern - Hospital Inventory Management System
📊 Connecting to database...
✅ Database connected successfully!
📍 Locations in database: 5
💊 Drugs in database: 1169
🏢 Companies in database: 5
```

---

## Session Recovery Checklist

If you're starting a new session and lost context:

### Quick Verification (2 minutes)
- [ ] Read `PROJECT_STATUS.md` for current status
- [ ] Run `docker ps | grep invs` - Expect 4 containers
- [ ] Run `npm run dev` - Expect ✅ success message
- [ ] Check `git log --oneline -5` - See recent commits

### If System Not Working
```bash
# Complete reset (deletes all data)
docker-compose down -v
docker-compose up -d

# Full setup (5 minutes)
npm install
npm run db:generate
npm run db:push
npm run db:seed
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/functions.sql
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/views.sql

# Verify
npm run dev
```

### Key Questions to Ask User
1. "What schema changes or documentation updates do you need?"
2. "Should I add more tables or modify existing schema?"
3. "Do you need to migrate more data from MySQL?"
4. "Should I update or create new documentation?"

**Remember**: This repo is for **database schema + documentation ONLY**. For backend/frontend work, that's in separate projects.

---

## Important Notes

### Database Strategy
- **PostgreSQL (Prisma)**: Primary production database
  - Use for ALL new development
  - Type-safe with Prisma client
  - Clean, modern schema (31 tables)

- **MySQL (Legacy)**: Reference only
  - Optional import for comparison
  - Read-only access
  - Historical data reference (133 tables)
  - Import script: `./scripts/import-mysql-legacy.sh`

### Git Repository
- **Size**: ~100MB (without large SQL files)
- **Large Files**: Gitignored
- **SQL Dump**: `INVS_MySQL_Database_20231119.sql` (1.3GB, not in repo)

---

## Support Resources

### Documentation
- **Setup**: `SYSTEM_SETUP_GUIDE.md`
- **Status**: `PROJECT_STATUS.md`
- **Summary**: `FINAL_SUMMARY.md`
- **Quick Start**: `docs/flows/QUICK_START_GUIDE.md`
- **All Flows**: `docs/flows/DATA_FLOW_COMPLETE_GUIDE.md`

### Technical Reference
- **Schema**: `prisma/schema.prisma`
- **Functions**: `prisma/functions.sql`
- **Views**: `prisma/views.sql`
- **Business Rules**: `docs/business-rules.md`

---

---

## 🆕 Latest Updates (v2.6.0 - 2025-01-28) 🚀

### ✅ Full Data Migration Complete!

**Implementation Completed**: Phase 5-8 migrations (81,353 total records)

### Added Data
- ✅ **Phase 5: Lookup Tables** ⭐ NEW
  - `dosage_forms`: 107 records (tablet, capsule, injection, etc.)
  - `drug_units`: 88 records (mg, ml, units, IU, etc.)
  - `adjustment_reasons`: 10 records (expired, damaged, lost, etc.)
  - `return_actions`: 8 records (refund, replace, credit, etc.)
  - Total: 213 records

- ✅ **Phase 6: Foreign Key Mappings** ⭐ NEW
  - Mapped 1,082 drug generics to dosage forms (97.6% coverage)
  - Converted legacy string fields to proper FK relationships
  - Total: 1,085 mappings

- ✅ **Phase 7: TMT Concepts** ⭐ NEW
  - Imported complete Thai Medical Terminology hierarchy
  - 5 levels: VTM → GP → GPU → TP → TPU
  - Total: 76,904 concepts

- ✅ **Phase 8: Drug-TMT Mapping** ⭐ NEW
  - Mapped 561 drugs to TMT TPU level (47.99% coverage)
  - Enabled ministry reporting compliance
  - Ready for HIS integration

### Migration Statistics
- Total Records: 3,152 → 81,353 (+78,201 records)
- Total Time: ~16 minutes
- Success Rate: 100%
- Database Size: ~50-80 MB

### Key Changes
- Database version: v2.4.0 → v2.6.0
- Documentation: Added 3 migration reports (Phase 5-8)
- Setup: Added `npm run setup:full` for complete data import
- Backup: Can restore full database in 1 minute
- Status: ✅ Production Ready for Backend Development

---

## 📜 Previous Updates (v2.2.0 - 2025-01-21) 🎉

### ✅ Achieved 100% Ministry Compliance!

**Implementation Completed**: All 79 required fields for DMSIC Standards พ.ศ. 2568

### Added Features
- ✅ **Ministry Compliance Fields** ⭐ 100% COMPLETE
  - Added 4 enums: `NlemStatus`, `DrugStatus`, `ProductCategory`, `DeptConsumptionGroup`
  - Added 5 fields to support all 79 ministry requirements:
    - `drugs.nlem_status` - NLEM classification (E/N)
    - `drugs.drug_status` - Drug status lifecycle (1-4)
    - `drugs.product_category` - Product type (1-5)
    - `drugs.status_changed_date` - Status change tracking
    - `departments.consumption_group` - Department consumption type (1-9)
  - Migration: `20251021031201_add_ministry_compliance_fields`

### Ministry Export Files Status
✅ **DRUGLIST**: 100% (11/11 fields) - Drug catalog
✅ **PURCHASEPLAN**: 100% (20/20 fields) - Purchase planning
✅ **RECEIPT**: 100% (22/22 fields) - Goods receiving
✅ **DISTRIBUTION**: 100% (11/11 fields) - Drug distribution
✅ **INVENTORY**: 100% (15/15 fields) - Stock status

**Total**: 79/79 fields (100%) 🎉

### Key Changes
- Enums: 18 → 22 (+4 ministry compliance enums)
- Tables: Altered 2 tables (drugs, departments)
- Fields: Added 5 new fields for ministry compliance
- Documentation: Added ministry compliance analysis document
- Status: ✅ 100% Ministry Compliant - Ahead of Schedule!

---

## 📜 Previous Updates (v1.1.0 - 2025-01-12) - Budget Planning

### Added Features
- ✅ **Budget Planning with Drug Details** (FLOW_02B)
  - Drug-level budget planning matching legacy buyplan/buyplan_c
  - 3-year historical consumption analysis
  - Quarterly breakdown (Q1-Q4) for detailed planning
  - Purchase vs plan tracking
  - 2 new tables: `budget_plans`, `budget_plan_items`
  - 2 new functions: `check_drug_in_budget_plan`, `update_budget_plan_purchase`

- ✅ **Manual Historical Data Entry**
  - Support for new system deployments without historical data
  - `historical_drug_data` table for manual/imported data (optional)
  - CSV bulk import with validation
  - Multiple data sources (system, manual, legacy_import, estimated)
  - Complete UI mockups for data entry workflows

### Key Changes
- Tables: 31 → 34 (+3: budget_plans, budget_plan_items, historical_drug_data)
- Functions: 10 → 12 (+2 budget planning functions)
- Documentation: 13 → 14 guides (+FLOW_02B)
- Schema: 790 → 880+ lines
- SQL Functions: 473 → 610+ lines

---

**Version**: 2.6.0
**Last Verified**: 2025-01-28
**Status**: ✅ Production Ready (Full Data Migration Complete)
**Next Phase**: Backend API Development

*Built with ❤️ for the INVS Modern Team*
*Database + Full Data (81K records) Ready for Backend Development! 🚀*
