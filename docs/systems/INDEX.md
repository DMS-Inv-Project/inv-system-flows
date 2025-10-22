# 📚 INVS Modern - Complete Documentation Index

**Version**: 2.2.0
**Last Updated**: 2025-01-22
**Status**: ✅ Production Ready (100% Ministry Compliant)
**Database**: PostgreSQL 15 | Prisma ORM | 36 Tables | 22 Enums

---

## 🚀 Quick Start

**New to INVS Modern? Start here:**

| Document | Description | Time |
|----------|-------------|------|
| 📖 **[QUICK_START_GUIDE.md](./QUICK_START_GUIDE.md)** | ติดตั้ง รัน ทดสอบระบบ | 10 min |
| 🔄 **[DATA_FLOW_COMPLETE_GUIDE.md](./DATA_FLOW_COMPLETE_GUIDE.md)** | End-to-end workflows ทั้งระบบ | 30 min |
| 📊 **[DATABASE_SCHEMA_COMPLETE.md](./DATABASE_SCHEMA_COMPLETE.md)** | Complete schema (36 tables) | Reference |

---

## 📂 System Modules (8 Modules)

### 1️⃣ Master Data Management
**Path**: [`01-master-data/`](./01-master-data/)
**Tables**: 11 | **Priority**: ⭐⭐⭐ Critical

**ข้อมูลพื้นฐาน**: Locations, Departments, Companies, Drugs, Contracts

| Documentation Type | Link |
|-------------------|------|
| 📘 **Module Overview** | [README.md](./01-master-data/README.md) |
| 👨‍💻 **Developer Handbook** | [DEVELOPER_HANDBOOK.md](./01-master-data/DEVELOPER_HANDBOOK.md) |
| 🔄 **Workflows** | [workflows/](./01-master-data/workflows/) |
| 📖 **Detailed Docs** | [detailed/](./01-master-data/detailed/) (9 files) |
| 🔌 **API Spec** | [api/API_SPECIFICATION.md](./01-master-data/api/API_SPECIFICATION.md) |

**Workflows Available**:
- [Setup Flow](./01-master-data/workflows/SETUP_FLOW.md) - Initial master data setup with UI mockups

**Detailed Documentation**:
- 01-SCHEMA.md - Database schema (11 tables)
- 02-STATE-MACHINES.md - Status workflows
- 03-VALIDATION-RULES.md - Input validation
- 04-AUTHORIZATION.md - Permissions
- 05-TEST-CASES.md - Test scenarios (30+ tests)
- 06-INTEGRATION.md - External systems (HIS, TMT, Ministry)
- 07-BUSINESS-RULES.md - Business logic (104 rules)
- 08-ERROR-CODES.md - Error handling (81 codes)
- 09-DATA-CONSTRAINTS.md - Field constraints

---

### 2️⃣ Budget Management
**Path**: [`02-budget-management/`](./02-budget-management/)
**Tables**: 4 | **Priority**: ⭐⭐⭐ Critical

**งบประมาณ**: Quarterly allocation, Drug-level planning, Real-time tracking

| Documentation Type | Link |
|-------------------|------|
| 📘 **Module Overview** | [README.md](./02-budget-management/README.md) |
| 🔄 **Workflows** | [workflows/](./02-budget-management/workflows/) |
| 📖 **Detailed Docs** | [detailed/](./02-budget-management/detailed/) |
| 🔌 **API Spec** | [api/](./02-budget-management/api/) |

**Workflows Available**:
- [Allocation Flow](./02-budget-management/workflows/ALLOCATION_FLOW.md) - Budget allocation process (5 phases)
- [Planning with Drugs](./02-budget-management/workflows/PLANNING_WITH_DRUGS.md) - Drug-level planning with 3-year history

**Key Features**:
- ✅ Quarterly budget (Q1-Q4)
- ✅ Drug-level planning
- ✅ Real-time budget checking
- ✅ Budget reservation system
- ✅ 3-year historical data

---

### 3️⃣ Procurement System
**Path**: [`03-procurement/`](./03-procurement/)
**Tables**: 12 | **Priority**: ⭐⭐⭐ Critical

**จัดซื้อ**: Contract → PR → PO → Receipt → Payment (Complete workflow)

| Documentation Type | Link |
|-------------------|------|
| 📘 **Module Overview** | [README.md](./03-procurement/README.md) |
| 🔄 **Workflows** | [workflows/](./03-procurement/workflows/) |
| 📖 **Detailed Docs** | [detailed/](./03-procurement/detailed/) |
| 🔌 **API Spec** | [api/](./03-procurement/api/) |

**Workflows Available**:
- [Purchase Request Flow](./03-procurement/workflows/PURCHASE_REQUEST_FLOW.md) - PR creation, approval, budget check
- [Frontend PR Guide](./03-procurement/workflows/FRONTEND_PR_GUIDE.md) - Complete UI mockups & code examples

**Process Flow**:
```
Contract → PR (Draft→Submit→Approve) → PO → Receipt → Payment → Close
           ↓
    Budget Check & Reservation
```

---

### 4️⃣ Inventory Management
**Path**: [`04-inventory/`](./04-inventory/)
**Tables**: 7 | **Priority**: ⭐⭐⭐ Critical

**คลังยา**: FIFO/FEFO, Multi-location, Lot tracking, Expiry alerts

| Documentation Type | Link |
|-------------------|------|
| 📘 **Module Overview** | [README.md](./04-inventory/README.md) |
| 🔄 **Workflows** | [workflows/](./04-inventory/workflows/) |
| 📖 **Detailed Docs** | [detailed/](./04-inventory/detailed/) |
| 🔌 **API Spec** | [api/](./04-inventory/api/) |

**Workflows Available**:
- [Management Flow](./04-inventory/workflows/MANAGEMENT_FLOW.md) - Stock tracking, FIFO/FEFO, reorder points
- [Distribution Flow](./04-inventory/workflows/DISTRIBUTION_FLOW.md) - Drug dispensing to departments

**Key Features**:
- ✅ FIFO/FEFO lot selection
- ✅ Multi-location support
- ✅ Expiry date tracking
- ✅ Reorder point alerts
- ✅ Inventory transactions audit

---

### 5️⃣ Drug Return System
**Path**: [`05-drug-return/`](./05-drug-return/)
**Tables**: 2 | **Priority**: ⭐⭐ Medium

**คืนยา**: Return drugs from departments (good/damaged)

| Documentation Type | Link |
|-------------------|------|
| 📘 **Module Overview** | [README.md](./05-drug-return/README.md) |
| 📖 **Detailed Docs** | [detailed/](./05-drug-return/detailed/) |
| 🔌 **API Spec** | [api/](./05-drug-return/api/) |

---

### 6️⃣ TMT Integration
**Path**: [`06-tmt-integration/`](./06-tmt-integration/)
**Tables**: 7 | **Priority**: ⭐⭐ Medium

**Thai Medical Terminology**: 25,991 concepts, Drug coding standards

| Documentation Type | Link |
|-------------------|------|
| 📘 **Module Overview** | [README.md](./06-tmt-integration/README.md) |
| 🔄 **Workflows** | [workflows/](./06-tmt-integration/workflows/) |
| 📖 **Detailed Docs** | [detailed/](./06-tmt-integration/detailed/) |
| 🔌 **API Spec** | [api/](./06-tmt-integration/api/) |

**Workflows Available**:
- [Integration Flow](./06-tmt-integration/workflows/INTEGRATION_FLOW.md) - TMT mapping, NC24 codes, HIS integration

**TMT Hierarchy**:
```
SUBS → VTM → GP → TP → GPU → TPU → GPP → TPP
```

---

### 7️⃣ HPP System
**Path**: [`07-hpp-system/`](./07-hpp-system/)
**Tables**: 2 | **Priority**: ⭐ Low (Optional)

**Hospital Pharmaceutical Products**: ยาผสมโรงพยาบาล

| Documentation Type | Link |
|-------------------|------|
| 📘 **Module Overview** | [README.md](./07-hpp-system/README.md) |
| 📖 **Detailed Docs** | [detailed/](./07-hpp-system/detailed/) |
| 🔌 **API Spec** | [api/](./07-hpp-system/api/) |

---

### 8️⃣ HIS Integration
**Path**: [`08-his-integration/`](./08-his-integration/)
**Tables**: 1 | **Priority**: ⭐⭐ Medium

**Hospital Information System**: Drug master synchronization

| Documentation Type | Link |
|-------------------|------|
| 📘 **Module Overview** | [README.md](./08-his-integration/README.md) |
| 📖 **Detailed Docs** | [detailed/](./08-his-integration/detailed/) |
| 🔌 **API Spec** | [api/](./08-his-integration/api/) |

---

## 🏥 Ministry Compliance

**DMSIC Standards พ.ศ. 2568**: 100% Compliant (79/79 fields) ✅

| Document | Description |
|----------|-------------|
| 📄 **[MINISTRY_REPORTING_FLOW.md](./MINISTRY_REPORTING_FLOW.md)** | 5 ministry export files workflow |

**Export Files (5 files)**:
1. ✅ **DRUGLIST** (11 fields) - Drug catalog
2. ✅ **PURCHASEPLAN** (20 fields) - Purchase planning
3. ✅ **RECEIPT** (22 fields) - Goods receiving
4. ✅ **DISTRIBUTION** (11 fields) - Drug distribution
5. ✅ **INVENTORY** (15 fields) - Stock status

**Database Views**:
- `export_druglist` - Ministry drug list
- `export_purchase_plan` - Purchase plan export
- `export_receipt` - Receipt export
- `export_distribution` - Distribution export
- `export_inventory` - Inventory export

---

## 🎯 Documentation by Role

### 👨‍💼 For Product Owners / Business Analysts

**Start with Business Flows:**
1. [Quick Start Guide](./QUICK_START_GUIDE.md) - System overview
2. [Complete Data Flow](./DATA_FLOW_COMPLETE_GUIDE.md) - End-to-end processes
3. Module **README.md** files - Business requirements
4. **Workflows** folders - Step-by-step processes with UI mockups

**Key Documents**:
- Business Rules: `{module}/detailed/07-BUSINESS-RULES.md`
- State Machines: `{module}/detailed/02-STATE-MACHINES.md`
- Validation Rules: `{module}/detailed/03-VALIDATION-RULES.md`

---

### 👨‍💻 For Backend Developers

**Start with Technical Docs:**
1. [Database Schema](./DATABASE_SCHEMA_COMPLETE.md) - All 36 tables
2. Module **DEVELOPER_HANDBOOK.md** - Implementation guide
3. **detailed/** folders - Technical specifications
4. **api/** folders - API specifications

**Key Documents**:
- Schema: `{module}/detailed/01-SCHEMA.md`
- Business Rules: `{module}/detailed/07-BUSINESS-RULES.md`
- Error Codes: `{module}/detailed/08-ERROR-CODES.md`
- Test Cases: `{module}/detailed/05-TEST-CASES.md`

**Database Functions** (12 functions):
- Budget: `check_budget_availability()`, `reserve_budget()`, `commit_budget()`
- Inventory: `get_fifo_lots()`, `get_fefo_lots()`, `update_inventory_from_receipt()`
- Planning: `check_drug_in_budget_plan()`, `update_budget_plan_purchase()`

**Database Views** (11 views):
- Ministry exports (5 views)
- Operational dashboards (6 views)

---

### 🎨 For Frontend Developers

**Start with UI Flows:**
1. [Frontend PR Guide](./03-procurement/workflows/FRONTEND_PR_GUIDE.md) - Complete UI examples
2. **workflows/** folders - UI mockups for all modules
3. **api/** folders - API endpoints

**Key Documents**:
- Workflows with UI mockups
- API Specifications
- Validation Rules
- Error Codes (for error handling)

**UI Patterns Available**:
- Form validation examples (Zod + React Hook Form)
- Table/List views (TanStack Table)
- Modal dialogs (shadcn/ui)
- State management (Zustand/React Query)

---

### 🧪 For QA / Testers

**Start with Test Scenarios:**
1. [Complete Data Flow](./DATA_FLOW_COMPLETE_GUIDE.md) - End-to-end test scenarios
2. **workflows/** folders - Step-by-step test cases
3. `{module}/detailed/05-TEST-CASES.md` - Unit & integration tests

**Key Documents**:
- Test Cases: `{module}/detailed/05-TEST-CASES.md`
- Validation Rules: `{module}/detailed/03-VALIDATION-RULES.md`
- Error Codes: `{module}/detailed/08-ERROR-CODES.md`
- Business Rules: `{module}/detailed/07-BUSINESS-RULES.md`

---

### 🗄️ For Database Administrators

**Start with Schema & Performance:**
1. [Database Schema Complete](./DATABASE_SCHEMA_COMPLETE.md) - All tables
2. **Prisma Schema**: `prisma/schema.prisma` - Source of truth
3. **Functions**: `prisma/functions.sql` - 12 business functions
4. **Views**: `prisma/views.sql` - 11 reporting views

**Key Topics**:
- Schema documentation
- Indexes & performance
- Business functions
- Reporting views
- Data constraints

---

## 📊 System Statistics

### Database Overview

| Metric | Count | Details |
|--------|-------|---------|
| **Tables** | 36 | Production database |
| **Enums** | 22 | Type-safe enumerations |
| **Functions** | 12 | Business logic functions |
| **Views** | 11 | Reporting views (5 ministry + 6 operational) |
| **Master Data** | 11 tables | Core reference data |
| **Budget** | 4 tables | Quarterly + planning |
| **Procurement** | 12 tables | Complete workflow |
| **Inventory** | 7 tables | FIFO/FEFO + multi-location |
| **TMT Concepts** | 25,991 | Thai Medical Terminology |

### Module Breakdown

| Module | Tables | Priority | Status |
|--------|--------|----------|--------|
| Master Data | 11 | ⭐⭐⭐ | ✅ 100% Documented |
| Budget Management | 4 | ⭐⭐⭐ | ✅ Complete |
| Procurement | 12 | ⭐⭐⭐ | ✅ Complete |
| Inventory | 7 | ⭐⭐⭐ | ✅ Complete |
| Drug Return | 2 | ⭐⭐ | Ready |
| TMT Integration | 7 | ⭐⭐ | Ready |
| HPP System | 2 | ⭐ | Optional |
| HIS Integration | 1 | ⭐⭐ | Ready |

### Documentation Statistics

| Type | Count | Total Lines |
|------|-------|-------------|
| **README files** | 8 | ~2,000 |
| **DEVELOPER_HANDBOOK** | 1 | ~400 |
| **Detailed docs** | 9 × 8 = 72 | ~20,000+ |
| **Workflows** | 10 | ~3,000 |
| **API Specs** | 8 | ~4,000 |
| **Total** | ~100 files | **~30,000 lines** |

---

## 🔗 External References

### Project Files

| Location | Description |
|----------|-------------|
| `prisma/schema.prisma` | Database schema (1,279 lines) - Source of truth |
| `prisma/functions.sql` | Business logic functions (610+ lines) |
| `prisma/views.sql` | Reporting views (378 lines) |
| `prisma/seed.ts` | Master data seeding |
| `src/index.ts` | Application entry point |
| `docker-compose.yml` | Container configuration |

### Development URLs

| Service | URL | Purpose |
|---------|-----|---------|
| **pgAdmin** | http://localhost:8081 | Database management |
| **Prisma Studio** | http://localhost:5555 | Visual data editor |
| **Application** | http://localhost:3000 | (When backend ready) |

---

## 🛠️ Tech Stack

### Backend (Ready for Development)
- **Database**: PostgreSQL 15-alpine (Port 5434)
- **ORM**: Prisma (with full type generation)
- **Language**: TypeScript + Node.js
- **Recommended Framework**: Express.js or Fastify

### Frontend (Recommended Stack)
- **Framework**: React 18+ with TypeScript
- **State Management**: TanStack Query (React Query) + Zustand
- **UI Components**: shadcn/ui + TailwindCSS
- **Forms**: React Hook Form + Zod
- **Tables**: TanStack Table

### DevOps
- **Containers**: Docker + Docker Compose
- **Database UI**: pgAdmin (PostgreSQL)
- **Version Control**: Git + GitHub

---

## 📞 Support & Contribution

### Getting Help

1. **Quick Issues**: Check [QUICK_START_GUIDE.md](./QUICK_START_GUIDE.md) troubleshooting
2. **Module Specific**: Read module README.md
3. **Database**: Check [DATABASE_SCHEMA_COMPLETE.md](./DATABASE_SCHEMA_COMPLETE.md)
4. **Workflows**: Review workflow documents with UI mockups

### Contributing

When adding new documentation:
1. Follow existing structure (README → detailed/ → workflows/ → api/)
2. Use Master Data as template
3. Include UI mockups for workflows
4. Add test cases
5. Document error codes

---

## 📅 Version History

| Version | Date | Changes |
|---------|------|---------|
| **2.2.0** | 2025-01-22 | ✅ Reorganized docs (flows/ → systems/), Complete INDEX |
| **2.1.0** | 2025-01-21 | ✅ 100% Ministry Compliance, Master Data complete |
| **2.0.0** | 2025-01-12 | ✅ Budget planning with drugs, Historical data support |
| **1.0.0** | 2025-01-11 | ✅ Initial system setup, 8 modules documented |

---

## 🎖️ Compliance & Standards

**✅ Ministry of Public Health (MOPH)**:
- DMSIC Standards พ.ศ. 2568: **100% Compliant** (79/79 fields)
- 5 Export files: DRUGLIST, PURCHASEPLAN, RECEIPT, DISTRIBUTION, INVENTORY
- TMT Integration: 25,991 concepts

**✅ Database Standards**:
- Prisma ORM with full type safety
- 12 Business logic functions
- 11 Reporting views
- Complete audit trails

**✅ Development Standards**:
- TypeScript for type safety
- Comprehensive documentation
- Test cases for all modules
- API specifications

---

## 🏆 Project Status

**Current Phase**: ✅ **Documentation Complete** - Ready for Development

**Next Steps**:
1. Backend API Development (Express/Fastify)
2. Frontend Application (React)
3. Authentication & Authorization
4. Production Deployment

**Documentation Coverage**: **100%** 🎉
- ✅ All 8 modules documented
- ✅ Complete workflows with UI mockups
- ✅ Business rules & constraints
- ✅ Error codes & test cases
- ✅ Ministry compliance verified

---

**Built with ❤️ for INVS Modern Team**

*Last Updated: 2025-01-22 | Version 2.2.0*
*Documentation maintained by Development Team*
