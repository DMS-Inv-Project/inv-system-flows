# 📚 INVS Modern - Developer Documentation Index

**Version**: 2.2.0
**Last Updated**: 2025-01-21
**Status**: Production Ready (100% Complete)

---

## 🎯 เอกสารนี้สำหรับใคร?

เอกสารชุดนี้เตรียมไว้สำหรับ **Developer Team** ที่จะพัฒนา:
- 🔧 Backend API (Express/Fastify + TypeScript)
- 🎨 Frontend Application (React + TypeScript)
- 📊 Database Integration
- 🧪 Testing & Quality Assurance

---

## 📋 โครงสร้างเอกสาร

เอกสารแบ่งตาม **8 ระบบหลัก** ดังนี้:

### 1. 📦 Master Data Management
**Path**: `01-master-data/`
- ข้อมูลพื้นฐานทั้งหมด (locations, departments, companies, drugs)
- **Tables**: 10 tables
- **Priority**: ⭐⭐⭐ สูง (ต้องทำก่อน)
- [📖 Read Documentation →](01-master-data/README.md)

### 2. 💰 Budget Management
**Path**: `02-budget-management/`
- ระบบงบประมาณแบบไตรมาส (Q1-Q4)
- วางแผนระดับยา + ข้อมูล 3 ปี
- **Tables**: 4 tables
- **Priority**: ⭐⭐⭐ สูง
- [📖 Read Documentation →](02-budget-management/README.md)

### 3. 🛒 Procurement System
**Path**: `03-procurement/`
- สัญญา → PR → PO → Receipt → Payment
- Workflow ที่สมบูรณ์ที่สุด
- **Tables**: 12 tables
- **Priority**: ⭐⭐⭐ สูง
- [📖 Read Documentation →](03-procurement/README.md)

### 4. 📦 Inventory Management
**Path**: `04-inventory/`
- คลังยา FIFO/FEFO + Multi-location
- Distribution + Audit trail
- **Tables**: 7 tables
- **Priority**: ⭐⭐⭐ สูง
- [📖 Read Documentation →](04-inventory/README.md)

### 5. 🔄 Drug Return System
**Path**: `05-drug-return/`
- รับคืนยาจากแผนก (ของดี/เสีย)
- **Tables**: 2 tables
- **Priority**: ⭐⭐ ปานกลาง
- [📖 Read Documentation →](05-drug-return/README.md)

### 6. 🏥 TMT Integration
**Path**: `06-tmt-integration/`
- Thai Medical Terminology (25,991 concepts)
- Drug coding standard
- **Tables**: 7 tables
- **Priority**: ⭐⭐ ปานกลาง
- [📖 Read Documentation →](06-tmt-integration/README.md)

### 7. 💊 HPP System
**Path**: `07-hpp-system/`
- Hospital Pharmaceutical Products
- ยาผสมโรงพยาบาล
- **Tables**: 2 tables
- **Priority**: ⭐ ต่ำ (Optional)
- [📖 Read Documentation →](07-hpp-system/README.md)

### 8. 🔌 HIS Integration
**Path**: `08-his-integration/`
- Hospital Information System
- Drug master mapping
- **Tables**: 1 table
- **Priority**: ⭐ ต่ำ (Optional)
- [📖 Read Documentation →](08-his-integration/README.md)

---

## 🗺️ System Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                   INVS Modern System                        │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
    ┌───▼───┐          ┌────▼────┐        ┌────▼────┐
    │ Master│          │ Budget  │        │Procure- │
    │ Data  │─────────▶│ Mgmt    │───────▶│ ment    │
    └───┬───┘          └────┬────┘        └────┬────┘
        │                   │                   │
        │              ┌────▼────┐              │
        │              │ Budget  │              │
        │              │Planning │              │
        │              └─────────┘              │
        │                                       │
        └───────────────┬───────────────────────┘
                        │
                   ┌────▼────┐
                   │Inventory│
                   │  Mgmt   │
                   └────┬────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
    ┌───▼───┐      ┌────▼────┐    ┌────▼────┐
    │ Drug  │      │  Drug   │    │  TMT    │
    │Return │      │  Dist   │    │Integr.  │
    └───────┘      └─────────┘    └─────────┘
```

---

## 📊 Database Summary

| System | Tables | Enums | Functions | Views | Priority |
|--------|--------|-------|-----------|-------|----------|
| **Master Data** | 10 | 2 | 0 | 0 | ⭐⭐⭐ |
| **Budget** | 4 | 1 | 4 | 2 | ⭐⭐⭐ |
| **Procurement** | 12 | 8 | 0 | 1 | ⭐⭐⭐ |
| **Inventory** | 7 | 2 | 6 | 4 | ⭐⭐⭐ |
| **Drug Return** | 2 | 2 | 0 | 0 | ⭐⭐ |
| **TMT** | 7 | 2 | 0 | 0 | ⭐⭐ |
| **HPP** | 2 | 1 | 0 | 0 | ⭐ |
| **HIS** | 1 | 1 | 0 | 0 | ⭐ |
| **TOTAL** | **44** | **22** | **12** | **11** | - |

---

## 🚀 Quick Start for Developers

### 1. Setup Development Environment

```bash
# Clone repository
git clone <repository-url>
cd invs-modern

# Install dependencies
npm install

# Start database
docker-compose up -d

# Generate Prisma client
npm run db:generate

# Run database migrations
npm run db:migrate

# Seed master data
npm run db:seed

# Apply functions and views
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/functions.sql
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/views.sql

# Start development
npm run dev
```

### 2. Verify Installation

```bash
# Test database connection
npm run dev

# Open Prisma Studio
npm run db:studio
# → http://localhost:5555

# Open pgAdmin
# → http://localhost:8081
# Email: admin@invs.com / Password: invs123
```

---

## 📖 แนะนำการอ่านเอกสาร

### สำหรับ Backend Developer

**ขั้นตอนที่ 1**: อ่านตามลำดับความสำคัญ
1. [Master Data](01-master-data/README.md) - เริ่มที่นี่
2. [Budget Management](02-budget-management/README.md)
3. [Procurement](03-procurement/README.md)
4. [Inventory](04-inventory/README.md)

**ขั้นตอนที่ 2**: ระบบเสริม (ทำภายหลัง)
5. [Drug Return](05-drug-return/README.md)
6. [TMT Integration](06-tmt-integration/README.md)
7. [HPP System](07-hpp-system/README.md)
8. [HIS Integration](08-his-integration/README.md)

### สำหรับ Frontend Developer

**ควรอ่านก่อน**:
1. [Master Data](01-master-data/README.md) - ข้อมูลพื้นฐาน
2. [Procurement Flow](03-procurement/README.md) - Flow หลัก
3. [Budget Management](02-budget-management/README.md) - งบประมาณ

**อ้างอิง UI/UX**:
- `docs/flows/FLOW_08_Frontend_Purchase_Request.md` - มี mockups

---

## 🔧 Tech Stack

### Backend (Recommended)
- **Framework**: Express.js หรือ Fastify
- **Language**: TypeScript
- **ORM**: Prisma (already configured)
- **Validation**: Zod
- **Authentication**: JWT
- **API Docs**: Swagger/OpenAPI

### Frontend (Recommended)
- **Framework**: React + TypeScript
- **State Management**: TanStack Query (React Query)
- **UI Components**: shadcn/ui + TailwindCSS
- **Forms**: React Hook Form + Zod
- **Routing**: React Router v6

### Database
- **Production**: PostgreSQL 15-alpine
- **ORM**: Prisma
- **Migration**: Prisma Migrate
- **Studio**: Prisma Studio

---

## 📝 สิ่งที่แต่ละ System Documentation มี

แต่ละระบบจะมีเอกสารครอบคลุม:

1. **📋 Overview**
   - สรุประบบ
   - Business requirements
   - Key features

2. **🗄️ Database Schema**
   - ตารางทั้งหมดพร้อม relationships
   - Enums ที่เกี่ยวข้อง
   - Indexes และ constraints

3. **🔄 Flow Diagram**
   - Workflow diagram (Mermaid)
   - Status transitions
   - Business rules

4. **🔌 API Endpoints**
   - Suggested endpoints
   - Request/Response examples
   - Validation rules

5. **💼 Business Logic**
   - Database functions
   - Calculated fields
   - Business rules

6. **🧪 Sample Code**
   - Prisma queries
   - TypeScript types
   - Example implementations

7. **✅ Checklist**
   - Development tasks
   - Testing requirements
   - Integration points

---

## 🎯 Development Roadmap

### Phase 1: Core Systems (ทำก่อน) ⭐⭐⭐

**Week 1-2**: Master Data + Budget
- [ ] Master Data CRUD APIs
- [ ] Budget allocation APIs
- [ ] Budget checking functions
- [ ] Basic authentication

**Week 3-4**: Procurement (Part 1)
- [ ] Purchase Request APIs
- [ ] Approval workflow
- [ ] Budget integration
- [ ] Purchase Order APIs

**Week 5-6**: Procurement (Part 2) + Inventory
- [ ] Receipt APIs
- [ ] Inventory updates
- [ ] FIFO/FEFO logic
- [ ] Stock queries

### Phase 2: Supporting Systems (ทำภายหลัง) ⭐⭐

**Week 7-8**: Distribution + Returns
- [ ] Drug distribution APIs
- [ ] Drug return APIs
- [ ] Location transfers

**Week 9-10**: Integrations
- [ ] TMT code mapping
- [ ] HIS integration
- [ ] Ministry export APIs

### Phase 3: Advanced Features (Optional) ⭐

**Week 11-12**: Advanced
- [ ] HPP formulations
- [ ] Analytics & reports
- [ ] Performance optimization

---

## 📞 Support & Resources

### Documentation
- **Database Schema**: `prisma/schema.prisma`
- **Functions**: `prisma/functions.sql`
- **Views**: `prisma/views.sql`
- **Flow Guides**: `docs/flows/`
- **Coverage Report**: `docs/project-tracking/COMPLETE_SYSTEM_COVERAGE_REPORT.md`

### Tools
- **Prisma Studio**: http://localhost:5555
- **pgAdmin**: http://localhost:8081
- **API Docs**: (To be created)

### Contact
- **Project Owner**: [Name]
- **Tech Lead**: [Name]
- **Repository**: [URL]

---

## 🎉 Ready to Start!

เลือกระบบที่ต้องการพัฒนา แล้วเริ่มอ่านเอกสารจาก README.md ในแต่ละ folder

**Happy Coding!** 🚀

---

**Created**: 2025-01-21
**Version**: 2.2.0
**Status**: ✅ Production Ready

*Made with ❤️ for INVS Modern Development Team*
