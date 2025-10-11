# INVS Modern 🏥

Modern Hospital Inventory Management System built with PostgreSQL, Prisma, and TypeScript.

**Version**: 1.0.0 | **Status**: ✅ Production Ready (Development Phase) | **Last Updated**: 2025-01-11

---

## 📊 Current Project Status

```
✅ Database: Complete (31 tables, 11 views, 10 functions)
✅ Docker Setup: Working (PostgreSQL + MySQL legacy)
✅ Documentation: Complete (13 comprehensive guides)
✅ Seed Data: Complete (5 entities, 29 records)
🚧 Backend API: Not started (Next priority)
🚧 Frontend: Not started
```

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
💊 Drugs in database: 0
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
3. **[FLOW_03_Procurement_Part1_PR.md](docs/flows/FLOW_03_Procurement_Part1_PR.md)** - Purchase requests
4. **[FLOW_08_Frontend_Purchase_Request.md](docs/flows/FLOW_08_Frontend_Purchase_Request.md)** - Frontend UI guide
5. **[DATA_FLOW_COMPLETE_GUIDE.md](docs/flows/DATA_FLOW_COMPLETE_GUIDE.md)** - All flows summary

### Technical Documentation
- **[prisma/schema.prisma](prisma/schema.prisma)** - Database schema (31 tables)
- **[prisma/functions.sql](prisma/functions.sql)** - Business logic functions (10)
- **[prisma/views.sql](prisma/views.sql)** - Reporting views (11)
- **[MYSQL_IMPORT_GUIDE.md](docs/MYSQL_IMPORT_GUIDE.md)** - Import legacy database

---

## 🗄️ Database Architecture

### Current Setup (Simplified 2-Database Architecture)

```
┌──────────────────────┐       ┌──────────────────────┐
│   MySQL (Legacy)     │       │ PostgreSQL (Modern)  │
│   Port: 3307         │       │  Port: 5434          │
│   invs_banpong       │◄─────►│  invs_modern         │
│   133 tables         │Compare│  31 tables           │
│   📖 Reference Only  │       │  📝 Production       │
└──────────────────────┘       └──────────────────────┘
       ↓                               ↓
  phpMyAdmin                      pgAdmin
  :8082                           :8081
```

### PostgreSQL (Production) - 31 Tables

**Master Data (6 tables)**
- `locations` - Storage locations
- `departments` - Hospital departments
- `budget_types` - Budget categories
- `companies` - Vendors/manufacturers
- `drug_generics` - Generic drug catalog
- `drugs` - Trade drugs with manufacturer links

**Budget Management (2 tables)**
- `budget_allocations` - Annual budget by quarter (Q1-Q4)
- `budget_reservations` - Budget reservation system

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

**Database Functions (10)**
- Budget: `check_budget_availability`, `reserve_budget`, `commit_budget`, `release_budget_reservation`
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
│   ├── schema.prisma          # 31 tables, 790 lines
│   ├── functions.sql          # 10 functions, 473 lines
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
│   ├── flows/                 # 4 detailed flow docs + complete guide
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
# Expected: 31 tables listed

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
| Database Design | ✅ Complete | 31 tables, normalized |
| Business Logic | ✅ Complete | 10 functions, 11 views |
| Documentation | ✅ Complete | 13 comprehensive guides |
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
