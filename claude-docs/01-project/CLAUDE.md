# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## READ FIRST

| Document | Purpose |
|----------|---------|
| `HANDOFF.md` | Quick start for new Claude instances |
| `PROJECT_STATUS.md` | Current project status and data summary |
| `prisma/schema.prisma` | Database schema (57 tables) |
| `backup/invs_modern_full.sql.gz` | Full database backup (~103K records) |

**Version**: 3.0.0 | **Status**: Database + Data Complete | **Next**: Backend API

---

## Project Overview

**INVS Modern** is a database schema and documentation project for a hospital drug inventory management system. This is NOT a backend API or frontend project - it contains only:
- Prisma schema definition
- PostgreSQL functions and views
- TypeScript migration scripts for data import
- Comprehensive documentation

**Tech Stack**: PostgreSQL 15 + Prisma ORM + TypeScript

## Development Commands

### Database Operations
```bash
# Start containers (PostgreSQL + MySQL legacy + web UIs)
docker-compose up -d

# Generate Prisma client after schema changes
npm run db:generate

# Push schema changes to database (development)
npm run db:push

# Create and apply migrations (production-ready)
npm run db:migrate

# Seed master data
npm run db:seed

# Open Prisma Studio (visual database browser)
npm run db:studio

# Apply SQL functions and views
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/functions.sql
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/views.sql
```

### Data Migration (from MySQL legacy)
```bash
# Run individual phases (~103K records total)
npm run import:phase1   # Procurement master (57 records)
npm run import:phase2   # Drug components (821 records)
npm run import:phase3   # Distribution support (4 records)
npm run import:phase4   # Drug master (3,006 records)
npm run import:phase5   # Lookup tables (213 records)
npm run import:phase6   # FK mappings (1,085 records)
npm run import:phase7   # TMT concepts (76,904 records)
npm run import:phase8   # Drug-TMT mapping (561 records)
npm run import:phase9   # Drug pack ratios (1,266 records)
npm run import:phase10  # Drug components (736 records)
npm run import:phase11  # Focus lists (62 records)
npm run import:phase12  # Companies (800 records)
npm run import:phase13  # All drugs (6,092 records)
npm run import:phase14  # Budget management (1,713 records)
npm run import:phase15  # Inventory + lots (13,138 records)

# Grouped imports
npm run import:drugs    # Phase 1-4
npm run import:lookups  # Phase 5-6
npm run import:tmt      # Phase 7-8
```

### Quick Restore (Recommended)
```bash
# Restore from backup instead of running all phases
gunzip -c backup/invs_modern_full.sql.gz | docker exec -i invs-modern-db psql -U invs_user -d invs_modern
```

### Full Setup
```bash
npm run setup:fresh   # Schema + seed data only
npm run setup:full    # Schema + seed + all imports
```

### Test Connection
```bash
npm run dev           # Verify database connectivity
```

## Database Connection

**PostgreSQL (Production)**
- Port: 5434
- Database: invs_modern
- User: invs_user
- Password: invs123

**MySQL (Legacy Reference)**
- Port: 3307
- Database: invs_banpong
- User: invs_user
- Password: invs123

**Web Interfaces**
- Prisma Studio: http://localhost:5555 (run `npm run db:studio`)
- pgAdmin: http://localhost:8081 (admin@invs.com / invs123)
- phpMyAdmin: http://localhost:8082 (invs_user / invs123)

## Architecture

### Database Schema (57 tables, 30 enums)

**Master Data**: `locations`, `departments`, `budget_types`, `companies`, `drug_generics`, `drugs`

**Budget Management**: `budget_allocations`, `budget_reservations`, `budget_plans`, `budget_plan_items`

**Procurement**: `purchase_requests`, `purchase_request_items`, `purchase_orders`, `purchase_order_items`, `receipts`, `receipt_items`

**Inventory**: `inventory`, `drug_lots`, `inventory_transactions`

**Distribution**: `drug_distributions`, `drug_distribution_items`

**TMT Integration**: `tmt_concepts` (76,904 records), `tmt_mappings`, `his_drug_master`

**Lookup Tables**: `dosage_forms`, `drug_units`, `adjustment_reasons`, `return_actions`

### SQL Functions (12 total)
- `check_budget_availability()` - Real-time budget validation
- `reserve_budget()` - Reserve budget for purchase requests
- `commit_budget()` - Commit budget when PO approved
- `release_budget_reservation()` - Release expired reservations
- `check_drug_in_budget_plan()` - Validate PR against budget plan
- `update_budget_plan_purchase()` - Update purchased amounts
- `get_fifo_lots()` / `get_fefo_lots()` - Lot selection algorithms
- `update_inventory_from_receipt()` - Auto-update inventory

### Views (11 total)
**Ministry Exports**: `export_druglist`, `export_purchase_plan`, `export_receipt`, `export_distribution`, `export_inventory`

**Operational**: `budget_status_current`, `expiring_drugs`, `low_stock_items`, `current_stock_summary`, `budget_reservations_active`, `purchase_order_status`

## Key Files

| File | Purpose |
|------|---------|
| `prisma/schema.prisma` | Database schema (57 tables, 30 enums) |
| `prisma/functions.sql` | Business logic functions (12) |
| `prisma/views.sql` | Reporting views (11) |
| `prisma/seed.ts` | Master data seeding |
| `src/lib/prisma.ts` | Prisma client singleton |
| `scripts/migrate-phase*.ts` | Data migration scripts |

## Business Logic

### Budget Flow
```
Planning -> Allocation -> Request -> Control -> Monitoring
```
- Quarterly allocations (Q1-Q4)
- Real-time budget checking before purchase approval
- Automatic deduction when PO finalized

### Procurement Workflow
```
Draft PR -> Submit -> Budget Check -> Approve -> Create PO -> Send -> Receive -> Post to Inventory
```

### Inventory Rules
- FIFO/FEFO for drug dispensing
- Lot tracking with expiry dates
- Multi-location support (warehouse, pharmacy, ward)
- Transaction types: RECEIVE, ISSUE, TRANSFER, ADJUST, RETURN

## Development Guidelines

### Schema Changes
1. Edit `prisma/schema.prisma`
2. Run `npm run db:generate` to update client
3. Run `npm run db:push` (dev) or `npm run db:migrate` (prod)
4. Test with `npm run db:studio`

### Adding SQL Functions/Views
1. Add to `prisma/functions.sql` or `prisma/views.sql`
2. Apply with `docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/[file].sql`

### Prisma Patterns
- Use global instance from `src/lib/prisma.ts`
- Use `upsert` for idempotent operations
- Use transactions for multi-table operations
- Follow existing enum patterns for status fields

## Important Notes

- This repo contains **database schema + documentation only**
- Backend API and Frontend are separate projects
- PostgreSQL is the production database; MySQL is read-only legacy reference
- Ministry compliance is 100% complete (79/79 DMSIC fields)
- TMT (Thai Medical Terminology) integration: 76,904 concepts, 47.99% drug coverage
