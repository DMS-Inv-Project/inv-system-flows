# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**INVS Modern** - A modern hospital inventory management system built with PostgreSQL, Prisma ORM, and TypeScript. This system manages drug inventory, budget control, and procurement workflows for hospital environments.

- **Database**: PostgreSQL 15-alpine (Container: invs-modern-db, Port: 5434)
- **ORM**: Prisma with full type safety
- **Primary Language**: TypeScript with Node.js
- **Status**: Active Development

## Development Commands

### Database Management
```bash
# Start PostgreSQL container with pgAdmin
docker-compose up -d

# Stop services
docker-compose down

# Connect to database directly
docker exec -it invs-modern-db psql -U invs_user -d invs_modern

# Generate Prisma client after schema changes
npm run db:generate

# Push schema changes to database
npm run db:push

# Create and apply migrations
npm run db:migrate

# Seed master data
npm run db:seed

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

# Type checking (no separate command - included in build)
npm run build
```

## Database Connection Details

**PostgreSQL Modern Database:**
- Host: localhost
- Port: 5434
- Database: invs_modern
- Username: invs_user
- Password: invs123

**PostgreSQL Legacy Database (Reference):**
- Host: localhost
- Port: 5435
- Database: invs_legacy
- Username: invs_user
- Password: invs123

**MySQL Original Database (Native):**
- Host: localhost
- Port: 3307
- Database: invs_banpong
- Username: invs_user
- Password: invs123

**pgAdmin Web Interface:**
- URL: http://localhost:8081
- Email: admin@invs.local
- Password: invs123

**phpMyAdmin Web Interface:**
- URL: http://localhost:8082
- Username: invs_user
- Password: invs123

**Prisma Studio:**
- URL: http://localhost:5555 (after running `npm run db:studio`)

## Architecture Overview

### Database Schema Structure (16 Tables)

The system uses a comprehensive schema with the following model groups:

#### 1. Master Data (6 models)
- `Location` - Storage locations (warehouse, pharmacy, ward, emergency)
- `Department` - Hospital departments with budget codes and hierarchy
- `BudgetType` - Budget categories (operational, investment, emergency)
- `Company` - Vendors and manufacturers with contact details
- `DrugGeneric` - Generic drug catalog with working codes
- `Drug` - Trade drug catalog linked to generics and manufacturers

#### 2. Inventory Management (3 models)
- `Inventory` - Stock levels per drug/location with min/max levels
- `DrugLot` - FIFO/FEFO lot tracking with expiry dates
- `InventoryTransaction` - All inventory movements with audit trail

#### 3. Budget Management (2 models)
- `BudgetAllocation` - Annual budget allocation by quarter (Q1-Q4)
- `BudgetReservation` - Budget reservations for purchase requests

#### 4. Procurement Workflow (5 models)
- `PurchaseRequest` - Purchase request workflow with approval
- `PurchaseRequestItem` - Detailed items in requests
- `PurchaseOrder` - Purchase orders with vendor integration
- `PurchaseOrderItem` - Items in purchase orders
- `Receipt` - Goods receiving documents
- `ReceiptItem` - Items received with lot information

### Key Business Logic

#### Budget Control Flow
```typescript
// Budget flows: Planning → Allocation → Request → Control → Monitoring
// Each department has quarterly budget allocations (Q1-Q4)
// Real-time budget checking before purchase approval
// Automatic budget deduction when purchase orders are finalized
```

#### Inventory Management Rules
- **FIFO/FEFO**: First In First Out / First Expire First Out
- **Reorder Points**: Automatic calculation based on usage patterns
- **Multi-location**: Support for warehouse, pharmacy, ward storage
- **Lot Tracking**: Complete traceability with expiry date management

#### Procurement Workflow
```
Draft PR → Submit → Budget Check → Approve → Create PO → Send → Receive → Post to Inventory
```

### Prisma Configuration

The project uses Prisma with:
- PostgreSQL provider
- Full type generation
- Query logging enabled in development
- Connection pooling
- Global instance pattern to prevent multiple connections

### Data Seeding

The seed script creates:
- 5 Locations (Main Warehouse, Central Pharmacy, Emergency, ICU, OPD)
- 5 Departments (Admin, Pharmacy, Nursing, Medical, Laboratory)
- 6 Budget Types (Operational drugs/equipment/supplies, Investment equipment/IT, Emergency)
- 5 Companies (GPO, Zuellig Pharma, Pfizer, Sino-Thai, Berlin Pharmaceutical)
- 5 Drug Generics (Paracetamol, Ibuprofen, Amoxicillin, Aspirin, Omeprazole)
- 3 Budget Allocations for 2025 fiscal year

## Important Files and Directories

### Core Application
- `src/index.ts` - Main application entry point with database connection test
- `src/lib/prisma.ts` - Prisma client configuration with global instance pattern
- `prisma/schema.prisma` - Complete database schema definition
- `prisma/seed.ts` - Master data seeding script

### Legacy Database Analysis
- `scripts/analyze-legacy-structure.sql` - SQL queries for analyzing legacy database
- `scripts/run-analysis.sh` - Automated analysis script
- `scripts/analysis-results/` - Generated analysis reports
- `docs/legacy-analysis.md` - Comprehensive legacy system analysis

### Migration and Conversion
- `scripts/mysql_to_postgresql_converter_v2.py` - MySQL to PostgreSQL converter
- `scripts/create_clean_schema.py` - Clean schema extractor
- `scripts/legacy-init/` - Legacy database initialization files

### Configuration
- `docker-compose.yml` - Database containers (PostgreSQL modern/legacy, MySQL original) and web interfaces
- `tsconfig.json` - TypeScript configuration for ES2020 target
- `package.json` - Dependencies and npm scripts

### Documentation
- `docs/business-rules.md` - Comprehensive business rules and authorization matrix
- `docs/legacy-analysis.md` - Legacy system analysis and migration recommendations
- `README.md` - Project setup and feature overview

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

## Environment Variables

Required `.env` file:
```env
DATABASE_URL="postgresql://invs_user:invs123@localhost:5434/invs_modern?schema=public"
NODE_ENV=development
```

## Legacy Database Reference

The legacy INVS database has been imported for reference and analysis:

### Available Analysis Tools
```bash
# Run comprehensive database analysis (PostgreSQL legacy)
cd scripts && ./run-analysis.sh

# Connect to PostgreSQL legacy database directly
docker exec -it invs-legacy-db psql -U invs_user -d invs_legacy

# Connect to MySQL original database directly
docker exec -it invs-mysql-original mysql -u invs_user -pinvs123 invs_banpong

# Run specific analysis queries
docker exec -i invs-legacy-db psql -U invs_user -d invs_legacy < analyze-legacy-structure.sql
```

### Key Legacy System Insights
- **133 tables** in MySQL original, **143 tables** in PostgreSQL converted
- **Working Code System**: 7-digit identifiers for drugs (`WORKING_CODE`)
- **Card-based Transactions**: Complete audit trail in `card` table (275,532 records)
- **Multi-location Inventory**: Location-based stock management
- **Complex Procurement Flow**: `buyplan` → `ms_po` → `ms_ivo` → `sm_po`
- **Rich Data**: 816 companies, 1,104 drugs, extensive transaction history

### Legacy vs Modern Mapping
- Legacy `drug_gn` → Modern `DrugGeneric`
- Legacy `drug_vn` → Modern `Drug`
- Legacy `company` → Modern `Company`
- Legacy `card` → Modern `InventoryTransaction`
- Legacy `ms_po` → Modern `PurchaseOrder`

## Testing Database Connection

Run the main application to test database connectivity:
```bash
npm run dev
# Should show: Database connected successfully! and entity counts
```