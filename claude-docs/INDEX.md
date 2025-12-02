# Claude Development Documentation Index

**INVS Modern - Hospital Drug Inventory Management System**
**For: Backend API & Frontend Development**
**Last Updated**: 2024-12-02

---

## Quick Start - Read Order

```
1. HANDOFF.md         (5 min)  - Quick project overview
2. PROJECT_STATUS.md  (3 min)  - Current data status
3. schema.prisma      (ref)    - Database schema (57 tables)
4. BRD.md             (15 min) - Business requirements
5. System API guides  (per feature)
```

---

## Folder Structure

```
claude-docs/
├── INDEX.md                 <- YOU ARE HERE
│
├── 01-project/              <- Project Overview (อ่านก่อน)
│   ├── HANDOFF.md           - Quick start for new developers
│   ├── PROJECT_STATUS.md    - Current status & data counts
│   ├── SYSTEM_ALIGNMENT.md  - 8 systems alignment report
│   └── CLAUDE.md            - Claude Code instructions
│
├── 02-schema/               <- Database (Reference)
│   ├── schema.prisma        - 57 tables, 30 enums
│   ├── functions.sql        - 12 business logic functions
│   ├── views.sql            - 11 reporting views
│   └── seed.ts              - Master data seeding script
│
├── 03-business/             <- Business Analysis
│   ├── BRD.md               - Business Requirements (สำคัญ)
│   ├── TRD.md               - Technical Requirements
│   ├── DATABASE_DESIGN.md   - Full database design
│   └── END_TO_END_WORKFLOWS.md - Complete business flows
│
├── 04-api-guides/           <- API Development (per system)
│   ├── 01-master-data-*.md  - Master Data APIs
│   ├── 02-budget-*.md       - Budget Management APIs
│   ├── 03-procurement-*.md  - Procurement APIs
│   ├── 04-inventory-*.md    - Inventory APIs
│   ├── 05-distribution-*.md - Distribution APIs
│   ├── 06-return-*.md       - Drug Return APIs
│   ├── 07-tmt-*.md          - TMT Integration APIs
│   └── 08-hpp-*.md          - HPP System APIs
│
├── 05-workflows/            <- Workflow Details
│   ├── XX-*-WORKFLOWS.md    - Per-system workflow diagrams
│   └── 03-procurement-STATE_DIAGRAMS.md - PR/PO state transitions
│
├── 06-mock-ui/              <- UI Mockups (8 systems)
│   ├── 01-master-data-UI.md - Master data screens
│   ├── 02-budget-UI.md      - Budget management screens
│   ├── 03-procurement-UI.md - Procurement screens
│   ├── 04-inventory-UI.md   - Inventory screens
│   ├── 05-distribution-UI.md - Distribution screens
│   ├── 06-return-UI.md      - Drug return screens
│   ├── 07-tmt-UI.md         - TMT integration screens
│   └── 08-hpp-UI.md         - HPP system screens
│
├── 07-api-readme/           <- API Implementation READMEs
│   ├── 01-master-data-API-README.md
│   ├── 02-budget-API-README.md
│   ├── 03-procurement-API-README.md
│   ├── 04-inventory-API-README.md
│   ├── 05-distribution-API-README.md
│   ├── 06-return-API-README.md
│   ├── 07-tmt-API-README.md
│   └── 08-hpp-API-README.md
│
├── 08-additional-docs/      <- Additional Analysis Documents
│   ├── DATA_FLOW_DIAGRAM.md     - DFD Level 0-2 (47 processes)
│   ├── USE_CASE_DOCUMENT.md     - 28 use cases, 6 actors
│   ├── UI_UX_DESIGN.md          - Angular 18+ design system
│   ├── TEST_PLAN.md             - Testing strategy & test cases
│   ├── SYSTEM_ARCHITECTURE.md   - Architecture overview
│   ├── PROJECT_PLAN.md          - 16-week development plan
│   ├── DATABASE_STRUCTURE.md    - Complete DB documentation
│   ├── BUDGET_SYSTEM_EXPLAINED.md - Budget system details
│   ├── SETUP_FRESH_CLONE.md     - Fresh setup guide
│   └── SYSTEM_SETUP_GUIDE.md    - System configuration
│
└── invs_modern_full.sql.gz  <- Database Backup (~103K records)
```

---

## 8 Core Systems Overview

| # | System | Tables | Records | Priority |
|---|--------|--------|---------|----------|
| 1 | Master Data | 18 | 9,473 | **Must Do First** |
| 2 | Budget Management | 6 | 1,713 | Phase 1 |
| 3 | Procurement | 12 | 0 | Phase 2 |
| 4 | Inventory | 3 | 13,138 | Phase 2 |
| 5 | Distribution | 3 | 0 | Phase 3 |
| 6 | Drug Return | 4 | 0 | Phase 3 |
| 7 | TMT Integration | 9 | 76,904 | Phase 3 |
| 8 | HPP System | 2 | 0 | Phase 4 |

**Total: 57 tables, ~101,000 records**

---

## Database Quick Reference

### Connection
```
Host: localhost
Port: 5434
Database: invs_modern
User: invs_user
Password: invs123
```

### Key Tables
- `drugs` (7,261 records) - Trade drug catalog
- `drug_generics` (1,109) - Generic drug catalog
- `companies` (800) - Vendors/manufacturers
- `departments` (108) - Hospital departments
- `locations` (96) - Storage locations
- `inventory` (7,105) - Stock levels
- `drug_lots` (6,033) - Lot tracking (FIFO/FEFO)
- `tmt_concepts` (76,904) - Thai Medical Terminology
- `budget_plan_items` (1,710) - Budget planning items

### Important Functions
```sql
-- Budget checking
SELECT * FROM check_budget_availability(fiscal_year, budget_type_id, dept_id, amount, quarter);

-- Lot selection (FIFO/FEFO)
SELECT * FROM get_fifo_lots(drug_id, location_id, qty_needed);
SELECT * FROM get_fefo_lots(drug_id, location_id, qty_needed);
```

---

## API Development Order

### Phase 1: Foundation
1. Authentication (JWT)
2. User Management
3. Master Data CRUD (drugs, companies, departments, locations)

### Phase 2: Core Operations
4. Budget Management (allocations, reservations)
5. Procurement (PR → PO → Receipt workflow)
6. Inventory (stock tracking, lot management)

### Phase 3: Advanced
7. Distribution (department requisitions)
8. Drug Returns
9. TMT Integration
10. HPP System

---

## User Roles (RBAC)

| Role | Description |
|------|-------------|
| ADMIN | Full system access |
| PHARMACIST | Drug management, dispensing |
| INVENTORY_STAFF | Stock management, receiving |
| DEPARTMENT_USER | Request drugs, view stock |
| VIEWER | Read-only access |

---

## Ministry Compliance

**100% DMSIC Standards พ.ศ. 2568 (79/79 fields)**

5 Export Files:
1. DRUGLIST (11 fields)
2. PURCHASEPLAN (20 fields)
3. RECEIPT (22 fields)
4. DISTRIBUTION (11 fields)
5. INVENTORY (15 fields)

Views ready: `export_druglist`, `export_purchase_plan`, etc.

---

## Document Guide by Task

### "I want to understand the project"
1. `01-project/HANDOFF.md`
2. `01-project/PROJECT_STATUS.md`
3. `03-business/BRD.md`

### "I want to understand the database"
1. `02-schema/schema.prisma`
2. `03-business/DATABASE_DESIGN.md`
3. `02-schema/functions.sql`

### "I want to build Master Data APIs"
1. `04-api-guides/01-master-data-README.md`
2. `04-api-guides/01-master-data-SCHEMA.md`
3. `04-api-guides/01-master-data-API.md`

### "I want to build Budget APIs"
1. `04-api-guides/02-budget-README.md`
2. `04-api-guides/02-budget-SCHEMA.md`
3. `04-api-guides/02-budget-API.md`
4. `05-workflows/02-budget-WORKFLOWS.md`

### "I want to build Procurement APIs"
1. `04-api-guides/03-procurement-README.md`
2. `04-api-guides/03-procurement-SCHEMA.md`
3. `04-api-guides/03-procurement-API.md`
4. `05-workflows/03-procurement-WORKFLOWS.md`
5. `05-workflows/03-procurement-STATE_DIAGRAMS.md`

### "I want to build the UI/Frontend"
1. `06-mock-ui/XX-*-UI.md` - UI Mockups per system
2. `07-api-readme/XX-*-API-README.md` - API specs for frontend integration
3. `08-additional-docs/UI_UX_DESIGN.md` - Design system & standards

### "I want to understand data flows"
1. `08-additional-docs/DATA_FLOW_DIAGRAM.md` - DFD Level 0-2
2. `08-additional-docs/USE_CASE_DOCUMENT.md` - 28 use cases

### "I want to set up the project"
1. `08-additional-docs/SETUP_FRESH_CLONE.md` - Fresh clone setup
2. `08-additional-docs/SYSTEM_SETUP_GUIDE.md` - System configuration
3. `02-schema/seed.ts` - Seed data script

### "I want to understand complete business flows"
1. `03-business/END_TO_END_WORKFLOWS.md`
2. System-specific workflows in `05-workflows/`

---

## Key Business Rules

### Budget Rules
- Budget allocated by fiscal year (Oct 1 - Sep 30)
- Quarterly breakdown (Q1-Q4)
- Auto-reserve on PR approval, commit on PO approval
- Reservation expires after 30 days

### Inventory Rules
- FIFO/FEFO lot tracking mandatory
- Expiry alerts: 90/60/30 days
- Negative stock not allowed
- All movements logged with transaction type

### Procurement Rules
- PR approval by amount threshold
- PO only from approved PR
- Receipt can be partial
- Auto-update inventory on receipt post

---

## File Sizes (Total: ~4.5MB)

| Folder | Size | Files |
|--------|------|-------|
| 01-project | 34KB | 4 |
| 02-schema | 148KB | 4 |
| 03-business | 267KB | 4 |
| 04-api-guides | 382KB | 24 |
| 05-workflows | 220KB | 9 |
| 06-mock-ui | 232KB | 8 |
| 07-api-readme | 14KB | 8 |
| 08-additional-docs | 450KB | 10 |
| invs_modern_full.sql.gz | 3MB | 1 |

---

## Notes

- All files are self-contained markdown
- Copy entire `claude-docs/` folder to new project
- Database backup available: `backup/invs_modern_full.sql.gz`
- Schema uses Prisma ORM (TypeScript)

---

*Updated: 2025-12-02 | Database: 57 tables, 30 enums, ~101K records*
