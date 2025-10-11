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
- **Status**: ✅ Production Ready (Development Phase)
- **Database**: 31 tables, 11 views, 10 functions (all created)
- **Seed Data**: Complete (5 locations, 5 departments, 6 budget types, 5 companies, 5 drugs)
- **Backend API**: 🚧 Not started (Next priority)
- **Frontend**: 🚧 Not started
- **Last Verified**: 2025-01-11

### Step 4: Key Files to Review
1. `PROJECT_STATUS.md` - Complete current status
2. `README.md` - Quick start guide
3. `SYSTEM_SETUP_GUIDE.md` - Setup instructions
4. `FINAL_SUMMARY.md` - Architecture summary

---

## Project Overview

**INVS Modern** - A modern hospital inventory management system built with PostgreSQL, Prisma ORM, and TypeScript. This system manages drug inventory, budget control, and procurement workflows for hospital environments.

- **Database**: PostgreSQL 15-alpine (Container: invs-modern-db, Port: 5434)
- **ORM**: Prisma with full type safety
- **Primary Language**: TypeScript with Node.js
- **Version**: 1.0.0
- **Status**: ✅ Production Ready (Development Phase - Database Complete)

---

## Current System State

### ✅ What's Complete

**Database Infrastructure:**
- ✅ PostgreSQL (Production) - 31 tables created
- ✅ MySQL (Legacy Reference) - Container ready, optional import
- ✅ Database Functions - 10 business logic functions
- ✅ Database Views - 11 reporting views
- ✅ Seed Data - Master data loaded
- ✅ Docker Compose - 2 databases + 2 web UIs

**Documentation:**
- ✅ 13 comprehensive guides created
- ✅ 4 detailed flow documents with UI mockups
- ✅ Complete system setup guide
- ✅ MySQL import guide
- ✅ Frontend development guide

**Testing:**
- ✅ Fresh setup tested (2025-01-11)
- ✅ All containers healthy
- ✅ Database connection verified
- ✅ Prisma queries working

### 🚧 What's NOT Complete

- ❌ Backend API (Express/Fastify)
- ❌ Authentication & Authorization
- ❌ Frontend Application (React)
- ❌ Production Deployment

**Next Priority**: Backend API Development

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
- **Status**: ✅ Active, 31 tables, 11 views, 10 functions

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
│   133 tables         │Compare│  31 tables           │
│   📖 Reference Only  │       │  📝 Production       │
└──────────────────────┘       └──────────────────────┘
       ↓                               ↓
  phpMyAdmin                     pgAdmin + Prisma
  :8082                          :8081    :5555
```

### Database Schema Structure (31 Tables)

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

#### 3. Budget Management (2 tables)
- `budget_allocations` - Annual budget allocation by quarter (Q1-Q4)
- `budget_reservations` - Budget reservations for purchase requests

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
- `tmt_concepts` - Thai Medical Terminology (25,991 concepts)
- `tmt_mappings` - Drug-to-TMT code mappings
- `his_drug_master` - HIS integration master data

#### 7. Others (9 tables)
- Supporting tables and audit logs

### Database Functions (10)

**Budget Management:**
- `check_budget_availability(fiscal_year, budget_type_id, department_id, amount, quarter)` - Real-time budget validation
- `reserve_budget(allocation_id, pr_id, amount, expires_days)` - Reserve budget for PR
- `commit_budget(allocation_id, po_id, amount, quarter)` - Commit budget when PO approved
- `release_budget_reservation(reservation_id)` - Release expired/cancelled reservations

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

### Core Application
- `src/index.ts` - Main application entry point with database connection test
- `src/lib/prisma.ts` - Prisma client configuration with global instance pattern
- `prisma/schema.prisma` - Complete database schema (31 tables, 790 lines)
- `prisma/functions.sql` - Business logic functions (10 functions, 473 lines)
- `prisma/views.sql` - Reporting views (11 views, 378 lines)
- `prisma/seed.ts` - Master data seeding script

### Scripts
- `scripts/import-mysql-legacy.sh` - Import MySQL legacy database
- `scripts/tmt/` - TMT management scripts (4 files)
- `scripts/integration/` - Integration scripts (2 files)
- `scripts/archive/` - Archived legacy migration scripts

### Flow Documentation
- `docs/flows/QUICK_START_GUIDE.md` - Quick start guide
- `docs/flows/DATA_FLOW_COMPLETE_GUIDE.md` - All flows summary
- `docs/flows/FLOW_01_Master_Data_Setup.md` - Master data setup
- `docs/flows/FLOW_02_Budget_Management.md` - Budget management
- `docs/flows/FLOW_03_Procurement_Part1_PR.md` - Purchase requests
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

## Next Steps / Roadmap

### Phase 1: Backend API Development (CURRENT PRIORITY)

**Setup:**
```bash
# Recommended tech stack:
- Express.js or Fastify
- TypeScript + Prisma
- Zod for validation
- JWT for authentication
```

**Required Endpoints:**
1. Authentication (POST /api/auth/login, /logout)
2. Master Data CRUD (GET/POST/PUT/DELETE /api/[entity])
3. Purchase Request workflow (POST /api/purchase-requests)
4. Budget checking (POST /api/budget/check-availability)
5. Inventory queries (GET /api/inventory)

### Phase 2: Frontend Development

**Setup:**
```bash
# Recommended tech stack:
- React + TypeScript
- TanStack Query (React Query)
- shadcn/ui + TailwindCSS
- React Hook Form + Zod
```

**Reference**: See `docs/flows/FLOW_08_Frontend_Purchase_Request.md` for complete UI mockups and code examples

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
💊 Drugs in database: 0
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
1. "What's the current task or next feature to implement?"
2. "Do you need help with backend API or frontend development?"
3. "Should I review any specific flow or documentation?"

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

**Version**: 1.0.0
**Last Verified**: 2025-01-11
**Status**: ✅ Production Ready (Development Phase)
**Next Phase**: Backend API Development

*Built with ❤️ for the INVS Modern Team*
