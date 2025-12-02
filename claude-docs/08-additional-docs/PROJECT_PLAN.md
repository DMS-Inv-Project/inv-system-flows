# Project Plan & Gantt Chart

**INVS Modern - Hospital Inventory Management System**

**Version**: 1.0.0
**Date**: 2025-01-22
**Project Duration**: 16 weeks (estimated)
**Status**: Planning Phase

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Project Objectives](#2-project-objectives)
3. [Project Scope](#3-project-scope)
4. [Project Organization](#4-project-organization)
5. [Project Phases](#5-project-phases)
6. [Detailed Task Breakdown](#6-detailed-task-breakdown)
7. [Gantt Chart](#7-gantt-chart)
8. [Resource Allocation](#8-resource-allocation)
9. [Risk Management](#9-risk-management)
10. [Budget Estimate](#10-budget-estimate)
11. [Communication Plan](#11-communication-plan)
12. [Quality Assurance](#12-quality-assurance)
13. [Change Management](#13-change-management)

---

## 1. Project Overview

### 1.1 Project Background

INVS Modern is a database-centric hospital inventory management system designed to replace legacy MySQL-based systems with a modern PostgreSQL architecture. The project has successfully completed the database design, schema implementation, and documentation phases. The system manages drug inventory, budget control, procurement workflows, and Ministry of Public Health compliance reporting.

### 1.2 Current Status (as of 2025-01-22)

**✅ Completed Phases**:
- Database Design (52 tables, 22 enums)
- Database Schema Implementation (Prisma ORM)
- Business Logic Functions (12 functions)
- Reporting Views (11 views)
- Data Migration (3,152 records from legacy system)
- Ministry Compliance (100% - 79/79 fields)
- Comprehensive Documentation (23 guides)

**🚧 Remaining Phases**:
- Backend API Development
- Frontend Application Development
- System Integration & Testing
- User Acceptance Testing
- Production Deployment

### 1.3 Project Vision

To deliver a modern, efficient, and compliant hospital inventory management system that:
- Streamlines drug procurement and inventory processes
- Ensures 100% Ministry of Public Health compliance
- Provides real-time budget control and monitoring
- Supports FIFO/FEFO inventory management
- Integrates with Thai Medical Terminology (TMT) standards
- Delivers intuitive user experience for hospital staff

---

## 2. Project Objectives

### 2.1 Primary Objectives

1. **Backend API Development**
   - Build RESTful API with Express.js/Fastify
   - Implement authentication and authorization
   - Create endpoints for all 28 use cases
   - Ensure API security and performance
   - Achieve 85%+ test coverage

2. **Frontend Application Development**
   - Build responsive React application
   - Implement all user interfaces per mockups
   - Integrate with Backend API
   - Ensure accessibility and usability
   - Support Thai language interface

3. **System Integration**
   - Integrate Frontend → Backend → Database layers
   - Ensure end-to-end workflow functionality
   - Validate data consistency across all systems
   - Test all 28 use cases

4. **Quality Assurance**
   - Execute comprehensive test plan
   - Achieve 90%+ code coverage
   - Validate Ministry compliance
   - Conduct performance testing
   - Complete UAT with stakeholders

5. **Production Deployment**
   - Deploy to production environment
   - Migrate legacy data (if required)
   - Train end users
   - Provide documentation and support
   - Ensure system stability

### 2.2 Success Criteria

| Criterion | Target | Measurement |
|-----------|--------|-------------|
| **API Coverage** | 100% of use cases | All 28 use cases have API endpoints |
| **Test Coverage** | 90%+ code coverage | Vitest coverage report |
| **Performance** | < 2s page load | Performance testing |
| **Ministry Compliance** | 100% (79/79 fields) | Export validation |
| **User Satisfaction** | 85%+ satisfaction | UAT survey |
| **Defect Rate** | < 5 defects/KLOC | Defect tracking |
| **Uptime** | 99.5%+ availability | Production monitoring |
| **User Training** | 100% staff trained | Training attendance |

---

## 3. Project Scope

### 3.1 In Scope

#### 3.1.1 Backend API (Phase 1)

**Technology Stack**:
- Express.js or Fastify (Node.js)
- TypeScript + Prisma ORM
- Zod for validation
- JWT for authentication
- Winston for logging

**Deliverables**:
- Authentication endpoints (login, logout, refresh token)
- Master Data CRUD APIs (drugs, companies, locations, departments)
- Budget Management APIs (allocations, planning, checking)
- Procurement APIs (PR, PO, receipt workflows)
- Inventory APIs (stock, lots, FIFO/FEFO)
- Distribution APIs (department requests)
- Drug Return APIs (returns, good/damaged separation)
- Reporting APIs (ministry exports, operational reports)
- API Documentation (OpenAPI/Swagger)
- Unit and integration tests

#### 3.1.2 Frontend Application (Phase 2)

**Technology Stack**:
- React 18 + TypeScript
- TanStack Query (React Query) for data fetching
- shadcn/ui + TailwindCSS for UI components
- React Hook Form + Zod for forms
- Recharts for data visualization
- i18next for Thai/English localization

**Deliverables**:
- Authentication screens (login, logout)
- Dashboard (budget status, stock levels, alerts)
- Master Data screens (manage drugs, companies, etc.)
- Budget Management screens (allocations, planning)
- Procurement screens (PR workflow, PO management, receipt)
- Inventory screens (stock view, lot tracking, adjustments)
- Distribution screens (department requests, dispensing)
- Drug Return screens (returns, verification)
- Reporting screens (ministry exports, operational reports)
- User profile and settings
- Responsive design (desktop, tablet)
- Accessibility compliance (WCAG 2.1 Level AA)

#### 3.1.3 Integration & Testing (Phase 3)

**Deliverables**:
- End-to-end integration tests
- Performance testing and optimization
- Security testing and hardening
- User Acceptance Testing (UAT)
- Load testing (50+ concurrent users)
- Defect resolution
- Test reports and documentation

#### 3.1.4 Deployment & Training (Phase 4)

**Deliverables**:
- Production environment setup (Docker/Kubernetes)
- Database migration scripts
- Backup and recovery procedures
- Monitoring and alerting setup
- User training materials
- Administrator training
- End-user training sessions
- System documentation
- Handover to operations team

### 3.2 Out of Scope

**Not Included in Current Project**:
- ❌ Mobile native applications (iOS/Android)
- ❌ Integration with external hospital systems (beyond HIS drug master)
- ❌ Advanced analytics and business intelligence
- ❌ Barcode/RFID integration
- ❌ E-signature integration
- ❌ Multi-hospital/multi-tenant support
- ❌ Real-time collaboration features
- ❌ Offline mode

**Future Phases** (Post-Launch):
- Mobile responsive PWA (Progressive Web App)
- Advanced reporting and analytics
- Integration with other hospital systems (HIS, Accounting)
- Barcode scanning for inventory
- Automated stock replenishment AI

### 3.3 Assumptions

1. PostgreSQL database is stable and production-ready
2. Docker environment is available for deployment
3. Hospital staff will be available for UAT
4. Legacy data migration is one-time (no ongoing sync)
5. Network infrastructure supports web application
6. All stakeholders approve designs before development
7. Ministry compliance requirements won't change during project
8. Test environment mirrors production environment

### 3.4 Constraints

1. **Budget**: Limited development resources (2-3 developers)
2. **Timeline**: Target completion in 16 weeks
3. **Technology**: Must use TypeScript + Prisma + React stack
4. **Compliance**: Must maintain 100% Ministry compliance
5. **Resources**: Development team availability
6. **Environment**: Docker-based deployment only

---

## 4. Project Organization

### 4.1 Project Team

#### 4.1.1 Core Team

| Role | Name | Responsibility | Allocation |
|------|------|----------------|------------|
| **Project Manager** | [TBD] | Overall project delivery, stakeholder management | 50% |
| **Technical Lead** | [TBD] | Architecture, code reviews, technical decisions | 100% |
| **Backend Developer 1** | [TBD] | API development, database integration | 100% |
| **Backend Developer 2** | [TBD] | API development, testing | 100% |
| **Frontend Developer 1** | [TBD] | UI development, React components | 100% |
| **Frontend Developer 2** | [TBD] | UI development, state management | 100% |
| **QA Engineer** | [TBD] | Test planning, test execution, quality assurance | 100% |
| **DevOps Engineer** | [TBD] | Deployment, CI/CD, monitoring | 50% |
| **UX/UI Designer** | [TBD] | UI design, mockups, usability testing | 25% |
| **Business Analyst** | [TBD] | Requirements, UAT coordination | 50% |

**Total FTE**: ~7.75 Full-Time Equivalents

#### 4.1.2 Stakeholders

| Stakeholder | Role | Involvement |
|-------------|------|-------------|
| **Hospital Director** | Sponsor | Final approval, budget allocation |
| **Pharmacy Director** | Primary User | Requirements, UAT, training |
| **Procurement Manager** | Key User | Procurement workflow validation |
| **Finance Manager** | Key User | Budget system validation |
| **IT Manager** | Technical | Infrastructure, deployment support |
| **Ministry Liaison** | Compliance | Ensure ministry compliance |

### 4.2 Governance Structure

**Decision Making**:
- **Strategic Decisions**: Steering Committee (Hospital Director, Pharmacy Director, IT Manager)
- **Technical Decisions**: Technical Lead + Development Team
- **Scope Changes**: Project Manager + Steering Committee approval required

**Meeting Schedule**:
- **Daily Standup**: 15 min, development team (Mon-Fri)
- **Weekly Status**: 1 hour, project team + stakeholders (Friday)
- **Bi-weekly Sprint Review**: 2 hours, demo and retrospective (every 2 weeks)
- **Monthly Steering Committee**: 1 hour, strategic review (1st Monday of month)

### 4.3 Communication Plan

See [Section 11: Communication Plan](#11-communication-plan)

---

## 5. Project Phases

### 5.1 Phase Overview

```
Phase 0: Database & Documentation (COMPLETED) ✅
  └─ 52 tables, 12 functions, 11 views, 23 docs
         ↓
Phase 1: Backend API Development (Weeks 1-5) 🚧
  └─ RESTful API, Auth, Testing
         ↓
Phase 2: Frontend Development (Weeks 6-10) ⏳
  └─ React App, UI Components, Integration
         ↓
Phase 3: Integration & Testing (Weeks 11-13) ⏳
  └─ E2E Testing, UAT, Performance
         ↓
Phase 4: Deployment & Training (Weeks 14-16) ⏳
  └─ Production Deploy, Training, Handover
         ↓
Phase 5: Production Launch (Week 17+) ⏳
  └─ Go-Live, Support, Monitoring
```

### 5.2 Phase Details

#### Phase 0: Database & Documentation ✅ (COMPLETED)

**Duration**: 8 weeks (Dec 2024 - Jan 2025)
**Status**: ✅ 100% Complete

**Achievements**:
- ✅ 52 tables designed and implemented
- ✅ 22 enums for data consistency
- ✅ 12 business logic functions
- ✅ 11 reporting views (Ministry compliance)
- ✅ 3,152 records migrated (Phase 1-4)
- ✅ 100% Ministry compliance (79/79 fields)
- ✅ 23 comprehensive documentation guides
- ✅ BRD, TRD, Database Design, Use Cases, Test Plan

**Deliverables Completed**:
- Prisma schema (1,050+ lines)
- SQL functions (610+ lines)
- SQL views (378 lines)
- Complete documentation suite
- Docker Compose setup
- Seed data and migration scripts

#### Phase 1: Backend API Development 🚧 (Weeks 1-5)

**Duration**: 5 weeks
**Objective**: Build production-ready RESTful API

**Week 1-2: Setup & Authentication**
- Project setup (Express/Fastify + TypeScript)
- Database connection with Prisma
- Authentication system (JWT)
- Authorization middleware (role-based)
- API documentation setup (Swagger)
- Error handling middleware
- Logging setup (Winston)
- Request validation (Zod)

**Week 2-3: Core API Endpoints**
- Master Data CRUD (drugs, companies, locations, departments)
- Budget Management APIs (allocations, planning, checking)
- Procurement APIs (PR workflow)

**Week 3-4: Workflow APIs**
- Purchase Order APIs
- Receipt APIs
- Inventory APIs (stock, lots, FIFO/FEFO)
- Distribution APIs

**Week 4-5: Advanced APIs & Testing**
- Drug Return APIs
- Reporting APIs (Ministry exports)
- Unit tests (Vitest)
- Integration tests (Supertest)
- API performance optimization
- Security hardening

**Deliverables**:
- Working REST API (all endpoints)
- JWT authentication
- OpenAPI/Swagger documentation
- Unit tests (85%+ coverage)
- Integration tests (critical flows)
- API deployment guide

#### Phase 2: Frontend Development ⏳ (Weeks 6-10)

**Duration**: 5 weeks
**Objective**: Build responsive React application

**Week 6-7: Setup & Core Components**
- React project setup (Vite + TypeScript)
- UI library integration (shadcn/ui + Tailwind)
- State management (TanStack Query)
- Form library (React Hook Form + Zod)
- Routing setup (React Router)
- Authentication screens (login, logout)
- Dashboard layout and navigation
- Master Data screens (drugs, companies)

**Week 7-8: Budget & Procurement UI**
- Budget allocation screens
- Budget planning screens (drug-level)
- Purchase Request workflow UI
- Purchase Order management UI
- Receipt processing UI

**Week 8-9: Inventory & Distribution UI**
- Inventory dashboard
- Lot tracking screens (FIFO/FEFO)
- Stock adjustment UI
- Distribution request UI
- Drug dispensing workflow UI

**Week 9-10: Returns, Reports & Polish**
- Drug return screens
- Good/damaged separation UI
- Ministry export screens (5 reports)
- Operational report screens
- UI polish and refinement
- Responsive design (desktop, tablet)
- Accessibility improvements
- Thai language support (i18next)

**Deliverables**:
- Complete React application
- All 28 use cases implemented
- Responsive UI (desktop, tablet)
- Thai/English localization
- Component tests (Vitest)
- E2E tests (Playwright) - critical paths
- User guide documentation

#### Phase 3: Integration & Testing ⏳ (Weeks 11-13)

**Duration**: 3 weeks
**Objective**: Validate system quality and performance

**Week 11: Integration Testing**
- End-to-end workflow testing
- Frontend-Backend integration validation
- Database transaction testing
- Ministry export validation
- Cross-browser testing (Chrome, Firefox, Edge)
- Defect fixing (high-priority)

**Week 12: Performance & Security Testing**
- Load testing (50+ concurrent users)
- Performance optimization (< 2s page load)
- Database query optimization
- Security testing (OWASP Top 10)
- Penetration testing (basic)
- Defect fixing (medium-priority)

**Week 13: User Acceptance Testing (UAT)**
- UAT environment setup
- UAT test case execution (with hospital staff)
- Feedback collection
- Defect fixing (UAT findings)
- Final regression testing
- Sign-off preparation

**Deliverables**:
- Integration test report
- Performance test report
- Security audit report
- UAT test report
- Defect resolution summary
- Final quality report
- UAT sign-off document

#### Phase 4: Deployment & Training ⏳ (Weeks 14-16)

**Duration**: 3 weeks
**Objective**: Deploy to production and train users

**Week 14: Production Setup**
- Production environment setup (Docker/Kubernetes)
- Database migration to production
- SSL certificate setup
- Backup and recovery configuration
- Monitoring and alerting setup (Prometheus, Grafana)
- CI/CD pipeline setup (GitHub Actions)

**Week 15: Training & Documentation**
- Administrator training (2 days)
  - System configuration
  - User management
  - Backup/restore procedures
  - Troubleshooting
- End-user training (5 days)
  - Day 1: Pharmacists (procurement, inventory)
  - Day 2: Procurement officers (PR, PO)
  - Day 3: Department staff (distribution, returns)
  - Day 4: Finance (budget management)
  - Day 5: Management (reporting, dashboards)
- Training materials creation
- User manual finalization
- Administrator guide

**Week 16: Soft Launch & Handover**
- Soft launch (parallel run with legacy system)
- Production monitoring
- Issue resolution (hotfixes)
- Performance tuning
- Handover to operations team
- Knowledge transfer sessions
- Support procedures documentation

**Deliverables**:
- Production deployment
- Backup/recovery procedures
- Monitoring dashboards
- Training materials (videos, guides)
- User manual (Thai language)
- Administrator guide
- Handover documentation
- Support SOP

---

## 6. Detailed Task Breakdown

### 6.1 Work Breakdown Structure (WBS)

```
1. INVS Modern Project
   1.1 Phase 0: Database & Documentation ✅
       1.1.1 Database Design ✅
       1.1.2 Schema Implementation ✅
       1.1.3 Functions & Views ✅
       1.1.4 Data Migration ✅
       1.1.5 Documentation ✅

   1.2 Phase 1: Backend API Development 🚧
       1.2.1 Project Setup (Week 1)
           1.2.1.1 Initialize Node.js project
           1.2.1.2 Setup Express/Fastify
           1.2.1.3 Configure TypeScript
           1.2.1.4 Setup Prisma integration
           1.2.1.5 Configure ESLint + Prettier
           1.2.1.6 Setup environment variables

       1.2.2 Authentication & Authorization (Week 1-2)
           1.2.2.1 JWT token generation
           1.2.2.2 Login endpoint
           1.2.2.3 Logout endpoint
           1.2.2.4 Refresh token endpoint
           1.2.2.5 Password hashing (bcrypt)
           1.2.2.6 Role-based authorization middleware
           1.2.2.7 Authentication testing

       1.2.3 Core Infrastructure (Week 1-2)
           1.2.3.1 Error handling middleware
           1.2.3.2 Request validation (Zod)
           1.2.3.3 Logging setup (Winston)
           1.2.3.4 API documentation (Swagger)
           1.2.3.5 CORS configuration
           1.2.3.6 Rate limiting

       1.2.4 Master Data APIs (Week 2)
           1.2.4.1 Drug Generics CRUD
           1.2.4.2 Trade Drugs CRUD
           1.2.4.3 Companies CRUD
           1.2.4.4 Locations CRUD
           1.2.4.5 Departments CRUD
           1.2.4.6 TMT integration endpoints

       1.2.5 Budget Management APIs (Week 2-3)
           1.2.5.1 Budget Allocations CRUD
           1.2.5.2 Budget Planning CRUD
           1.2.5.3 Budget availability check endpoint
           1.2.5.4 Budget reservation endpoints
           1.2.5.5 Budget commitment endpoints
           1.2.5.6 Budget reporting endpoints

       1.2.6 Procurement APIs (Week 3)
           1.2.6.1 Purchase Request CRUD
           1.2.6.2 PR workflow endpoints (submit, approve, reject)
           1.2.6.3 Purchase Order CRUD
           1.2.6.4 PO workflow endpoints
           1.2.6.5 Receipt CRUD
           1.2.6.6 Receipt posting endpoint

       1.2.7 Inventory APIs (Week 3-4)
           1.2.7.1 Inventory query endpoints
           1.2.7.2 Drug lots endpoints
           1.2.7.3 FIFO/FEFO lot selection
           1.2.7.4 Stock adjustment endpoints
           1.2.7.5 Inventory transaction endpoints
           1.2.7.6 Expiring drugs endpoint
           1.2.7.7 Low stock items endpoint

       1.2.8 Distribution APIs (Week 4)
           1.2.8.1 Distribution CRUD
           1.2.8.2 Distribution workflow endpoints
           1.2.8.3 Dispensing endpoint (FIFO/FEFO)
           1.2.8.4 Distribution history endpoint

       1.2.9 Drug Return APIs (Week 4)
           1.2.9.1 Drug Return CRUD
           1.2.9.2 Return verification endpoint
           1.2.9.3 Good/damaged separation
           1.2.9.4 Return posting endpoint

       1.2.10 Reporting APIs (Week 4-5)
           1.2.10.1 Ministry export endpoints (5 files)
           1.2.10.2 Budget status reports
           1.2.10.3 Operational reports (6 views)
           1.2.10.4 Custom report builder

       1.2.11 Testing (Week 5)
           1.2.11.1 Unit tests (85%+ coverage)
           1.2.11.2 Integration tests (critical flows)
           1.2.11.3 Performance testing
           1.2.11.4 Security testing
           1.2.11.5 API documentation validation

   1.3 Phase 2: Frontend Development ⏳
       1.3.1 Project Setup (Week 6)
           1.3.1.1 Initialize React project (Vite)
           1.3.1.2 Setup TypeScript
           1.3.1.3 Configure TailwindCSS
           1.3.1.4 Install shadcn/ui
           1.3.1.5 Setup TanStack Query
           1.3.1.6 Configure React Router
           1.3.1.7 Setup i18next (Thai/English)

       1.3.2 Authentication UI (Week 6)
           1.3.2.1 Login screen
           1.3.2.2 Logout functionality
           1.3.2.3 Token management
           1.3.2.4 Protected routes
           1.3.2.5 Session timeout handling

       1.3.3 Layout & Navigation (Week 6)
           1.3.3.1 Main layout component
           1.3.3.2 Side navigation menu
           1.3.3.3 Top bar (user profile, notifications)
           1.3.3.4 Breadcrumbs
           1.3.3.5 Footer

       1.3.4 Dashboard (Week 6)
           1.3.4.1 Budget status widgets
           1.3.4.2 Stock level widgets
           1.3.4.3 Expiring drugs alert
           1.3.4.4 Low stock alert
           1.3.4.5 Recent activities
           1.3.4.6 Quick actions

       1.3.5 Master Data Screens (Week 6-7)
           1.3.5.1 Drug Generics management
           1.3.5.2 Trade Drugs management
           1.3.5.3 Companies management
           1.3.5.4 Locations management
           1.3.5.5 Departments management
           1.3.5.6 Data table components
           1.3.5.7 Form components

       1.3.6 Budget Management Screens (Week 7-8)
           1.3.6.1 Budget Allocations screen
           1.3.6.2 Budget Planning screen
           1.3.6.3 Budget Plan Items screen
           1.3.6.4 Budget availability check UI
           1.3.6.5 Budget status dashboard
           1.3.6.6 Budget reports

       1.3.7 Procurement Screens (Week 8)
           1.3.7.1 Purchase Request list
           1.3.7.2 Create/Edit PR form
           1.3.7.3 PR approval workflow UI
           1.3.7.4 Purchase Order list
           1.3.7.5 Create/Edit PO form
           1.3.7.6 Receipt list
           1.3.7.7 Create/Edit Receipt form
           1.3.7.8 Receipt posting UI

       1.3.8 Inventory Screens (Week 8-9)
           1.3.8.1 Inventory dashboard
           1.3.8.2 Stock levels by location
           1.3.8.3 Drug lots tracking
           1.3.8.4 FIFO/FEFO lot viewer
           1.3.8.5 Stock adjustment form
           1.3.8.6 Expiring drugs report
           1.3.8.7 Low stock items report

       1.3.9 Distribution Screens (Week 9)
           1.3.9.1 Distribution request list
           1.3.9.2 Create distribution form
           1.3.9.3 Distribution approval UI
           1.3.9.4 Drug dispensing screen
           1.3.9.5 Distribution confirmation
           1.3.9.6 Distribution history

       1.3.10 Drug Return Screens (Week 9)
           1.3.10.1 Return request list
           1.3.10.2 Create return form
           1.3.10.3 Return verification screen
           1.3.10.4 Good/damaged separation UI
           1.3.10.5 Return posting UI

       1.3.11 Reporting Screens (Week 10)
           1.3.11.1 Ministry export screens (5 reports)
           1.3.11.2 Budget reports
           1.3.11.3 Inventory reports
           1.3.11.4 Operational reports
           1.3.11.5 Custom report filters
           1.3.11.6 Export to Excel/CSV

       1.3.12 UI Polish & Accessibility (Week 10)
           1.3.12.1 Responsive design (desktop, tablet)
           1.3.12.2 Accessibility audit (WCAG 2.1)
           1.3.12.3 Thai language translations
           1.3.12.4 Loading states
           1.3.12.5 Error handling UI
           1.3.12.6 Confirmation dialogs
           1.3.12.7 Toast notifications

       1.3.13 Testing (Week 10)
           1.3.13.1 Component tests (Vitest)
           1.3.13.2 E2E tests (Playwright) - critical paths
           1.3.13.3 Visual regression tests
           1.3.13.4 Accessibility tests

   1.4 Phase 3: Integration & Testing ⏳
       1.4.1 Integration Testing (Week 11)
           1.4.1.1 End-to-end workflow testing (28 use cases)
           1.4.1.2 Frontend-Backend integration
           1.4.1.3 Database transaction testing
           1.4.1.4 Ministry export validation
           1.4.1.5 Cross-browser testing
           1.4.1.6 Defect fixing (P1, P2)

       1.4.2 Performance Testing (Week 12)
           1.4.2.1 Load testing setup
           1.4.2.2 50+ concurrent users test
           1.4.2.3 Database query optimization
           1.4.2.4 API response time optimization
           1.4.2.5 Frontend performance optimization
           1.4.2.6 Performance test report

       1.4.3 Security Testing (Week 12)
           1.4.3.1 OWASP Top 10 testing
           1.4.3.2 SQL injection testing
           1.4.3.3 XSS testing
           1.4.3.4 CSRF protection validation
           1.4.3.5 Authentication/Authorization testing
           1.4.3.6 Security audit report

       1.4.4 UAT Preparation (Week 13)
           1.4.4.1 UAT environment setup
           1.4.4.2 UAT test case preparation
           1.4.4.3 UAT user account setup
           1.4.4.4 UAT training (for testers)

       1.4.5 UAT Execution (Week 13)
           1.4.5.1 UAT test execution (hospital staff)
           1.4.5.2 Feedback collection
           1.4.5.3 Defect logging
           1.4.5.4 Defect fixing (UAT findings)
           1.4.5.5 Final regression testing

       1.4.6 UAT Sign-off (Week 13)
           1.4.6.1 UAT test report
           1.4.6.2 Defect resolution summary
           1.4.6.3 Sign-off document preparation
           1.4.6.4 Stakeholder sign-off meeting

   1.5 Phase 4: Deployment & Training ⏳
       1.5.1 Production Environment Setup (Week 14)
           1.5.1.1 Server provisioning
           1.5.1.2 Docker/Kubernetes setup
           1.5.1.3 PostgreSQL production setup
           1.5.1.4 SSL certificate installation
           1.5.1.5 Firewall configuration
           1.5.1.6 Load balancer setup

       1.5.2 Deployment Automation (Week 14)
           1.5.2.1 CI/CD pipeline (GitHub Actions)
           1.5.2.2 Automated testing in pipeline
           1.5.2.3 Database migration automation
           1.5.2.4 Blue-green deployment setup
           1.5.2.5 Rollback procedures

       1.5.3 Monitoring & Alerting (Week 14)
           1.5.3.1 Prometheus setup
           1.5.3.2 Grafana dashboards
           1.5.3.3 Application metrics
           1.5.3.4 Database metrics
           1.5.3.5 Alert rules configuration
           1.5.3.6 On-call rotation setup

       1.5.4 Backup & Recovery (Week 14)
           1.5.4.1 Automated database backups
           1.5.4.2 Backup verification
           1.5.4.3 Recovery procedure testing
           1.5.4.4 Backup retention policy
           1.5.4.5 Disaster recovery plan

       1.5.5 Training Materials (Week 15)
           1.5.5.1 User manual (Thai language)
           1.5.5.2 Administrator guide
           1.5.5.3 Training videos (screen recordings)
           1.5.5.4 Quick reference guides
           1.5.5.5 FAQ document

       1.5.6 Training Execution (Week 15)
           1.5.6.1 Administrator training (2 days)
           1.5.6.2 Pharmacist training (1 day)
           1.5.6.3 Procurement officer training (1 day)
           1.5.6.4 Department staff training (1 day)
           1.5.6.5 Finance team training (1 day)
           1.5.6.6 Management training (0.5 day)

       1.5.7 Data Migration (Week 15-16)
           1.5.7.1 Legacy data extraction
           1.5.7.2 Data cleaning and validation
           1.5.7.3 Data migration scripts
           1.5.7.4 Migration execution
           1.5.7.5 Data verification

       1.5.8 Soft Launch (Week 16)
           1.5.8.1 Production deployment
           1.5.8.2 Smoke testing
           1.5.8.3 Parallel run (with legacy system)
           1.5.8.4 Issue monitoring
           1.5.8.5 Hotfix deployment (if needed)

       1.5.9 Handover (Week 16)
           1.5.9.1 Knowledge transfer sessions
           1.5.9.2 Support procedures documentation
           1.5.9.3 Escalation procedures
           1.5.9.4 Maintenance schedule
           1.5.9.5 Handover sign-off
```

---

## 7. Gantt Chart

### 7.1 High-Level Gantt Chart (16 Weeks)

```
┌────────────┬───────────────────────────────────────────────────────────────────────────┐
│ Phase      │ Week 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16                      │
├────────────┼───────────────────────────────────────────────────────────────────────────┤
│ Phase 0    │ ████████ (COMPLETED ✅)                                                   │
│ Database   │                                                                           │
├────────────┼───────────────────────────────────────────────────────────────────────────┤
│ Phase 1    │ ███████████████████████                                                   │
│ Backend    │ │<─── Week 1-5 ────>│                                                     │
│ API        │ Setup  │Core APIs│Workflow│Testing                                        │
├────────────┼───────────────────────────────────────────────────────────────────────────┤
│ Phase 2    │                     ███████████████████████                               │
│ Frontend   │                     │<───── Week 6-10 ──────>│                            │
│ Development│                     Setup│Budget│Inv │Reports│Polish                      │
├────────────┼───────────────────────────────────────────────────────────────────────────┤
│ Phase 3    │                                             █████████████                 │
│ Integration│                                             │<─ Week 11-13 ─>│            │
│ & Testing  │                                             Integ│Perf│UAT                │
├────────────┼───────────────────────────────────────────────────────────────────────────┤
│ Phase 4    │                                                           ███████████████ │
│ Deployment │                                                           │<─Week 14-16──>│
│ & Training │                                                           Deploy│Train│Go │
└────────────┴───────────────────────────────────────────────────────────────────────────┘

Legend:
█ Active development
│ Phase boundary
✅ Completed
```

### 7.2 Detailed Gantt Chart

#### Phase 1: Backend API Development (Weeks 1-5)

```
Task                           │ W1  │ W2  │ W3  │ W4  │ W5  │ Owner
───────────────────────────────┼─────┼─────┼─────┼─────┼─────┼──────────────
Setup & Infrastructure         │ ███ │     │     │     │     │ Backend Dev 1
Authentication                 │ ███ │ ██  │     │     │     │ Backend Dev 1
Core Infrastructure            │ ███ │ ██  │     │     │     │ Backend Dev 2
Master Data APIs               │     │ ███ │     │     │     │ Backend Dev 1
Budget Management APIs         │     │ ███ │ ██  │     │     │ Backend Dev 2
Procurement APIs               │     │     │ ███ │ ██  │     │ Backend Dev 1
Inventory APIs                 │     │     │ ███ │ ██  │     │ Backend Dev 2
Distribution APIs              │     │     │     │ ███ │     │ Backend Dev 1
Drug Return APIs               │     │     │     │ ███ │     │ Backend Dev 2
Reporting APIs                 │     │     │     │ ███ │ ██  │ Backend Dev 1
Unit Testing                   │     │     │ ─── │ ─── │ ███ │ QA Engineer
Integration Testing            │     │     │     │ ─── │ ███ │ QA Engineer
API Documentation              │ ─── │ ─── │ ─── │ ─── │ ███ │ Technical Lead
Performance Testing            │     │     │     │     │ ███ │ QA Engineer

Legend: ███ Active work, ─── Ongoing task
```

#### Phase 2: Frontend Development (Weeks 6-10)

```
Task                           │ W6  │ W7  │ W8  │ W9  │ W10 │ Owner
───────────────────────────────┼─────┼─────┼─────┼─────┼─────┼──────────────
Project Setup                  │ ███ │     │     │     │     │ Frontend Dev 1
Authentication UI              │ ███ │     │     │     │     │ Frontend Dev 1
Layout & Navigation            │ ███ │     │     │     │     │ Frontend Dev 2
Dashboard                      │ ███ │ ██  │     │     │     │ Frontend Dev 2
Master Data Screens            │ ███ │ ███ │     │     │     │ Frontend Dev 1
Budget Screens                 │     │ ███ │ ███ │     │     │ Frontend Dev 1
Procurement Screens            │     │     │ ███ │ ██  │     │ Frontend Dev 2
Inventory Screens              │     │     │ ███ │ ███ │     │ Frontend Dev 1
Distribution Screens           │     │     │     │ ███ │     │ Frontend Dev 2
Drug Return Screens            │     │     │     │ ███ │     │ Frontend Dev 1
Reporting Screens              │     │     │     │ ███ │ ██  │ Frontend Dev 2
UI Polish & Accessibility      │     │     │     │     │ ███ │ UX/UI Designer
Component Testing              │     │ ─── │ ─── │ ─── │ ███ │ QA Engineer
E2E Testing (Critical Paths)   │     │     │     │ ─── │ ███ │ QA Engineer

Legend: ███ Active work, ─── Ongoing task
```

#### Phase 3: Integration & Testing (Weeks 11-13)

```
Task                           │ W11 │ W12 │ W13 │ Owner
───────────────────────────────┼─────┼─────┼─────┼────────────────
Integration Testing            │ ███ │ ██  │     │ QA Engineer
Defect Fixing (Integration)    │ ███ │ ██  │     │ Dev Team
Performance Testing            │     │ ███ │     │ QA + DevOps
Performance Optimization       │     │ ███ │ ██  │ Dev Team
Security Testing               │     │ ███ │     │ QA Engineer
Security Hardening             │     │ ███ │ ██  │ Dev Team
UAT Preparation                │     │ ██  │ ██  │ BA + QA
UAT Execution                  │     │     │ ███ │ Hospital Staff
UAT Defect Fixing              │     │     │ ███ │ Dev Team
Final Regression Testing       │     │     │ ███ │ QA Engineer
UAT Sign-off                   │     │     │ ███ │ PM + Stakeholders

Legend: ███ Active work, ─── Ongoing task
```

#### Phase 4: Deployment & Training (Weeks 14-16)

```
Task                           │ W14 │ W15 │ W16 │ Owner
───────────────────────────────┼─────┼─────┼─────┼────────────────
Production Environment Setup   │ ███ │     │     │ DevOps Engineer
CI/CD Pipeline                 │ ███ │     │     │ DevOps Engineer
Monitoring & Alerting          │ ███ │ ██  │     │ DevOps Engineer
Backup & Recovery              │ ███ │     │     │ DevOps Engineer
Training Materials Creation    │ ██  │ ███ │     │ BA + UX Designer
Administrator Training         │     │ ███ │     │ Technical Lead
End-User Training              │     │ ███ │ ██  │ BA + Pharmacist
Data Migration                 │     │ ███ │ ██  │ Backend Dev
Production Deployment          │     │     │ ███ │ DevOps Engineer
Soft Launch (Parallel Run)     │     │     │ ███ │ PM + All
Issue Monitoring & Hotfixes    │     │     │ ███ │ Dev Team
Handover to Operations         │     │     │ ███ │ PM + Technical Lead

Legend: ███ Active work, ─── Ongoing task
```

### 7.3 Critical Path

**Critical Path Tasks** (cannot be delayed without delaying project):

```
Week 1: Project Setup → Authentication
   ↓
Week 2: Master Data APIs
   ↓
Week 3: Procurement APIs
   ↓
Week 4: Inventory APIs
   ↓
Week 5: Testing & Documentation
   ↓
Week 6: Frontend Setup → Authentication UI
   ↓
Week 7-8: Budget & Procurement UI
   ↓
Week 9-10: Inventory & Distribution UI
   ↓
Week 11: Integration Testing
   ↓
Week 12: Performance & Security Testing
   ↓
Week 13: UAT & Sign-off
   ↓
Week 14: Production Setup
   ↓
Week 15: Training
   ↓
Week 16: Deployment & Go-Live
```

**Total Critical Path Duration**: 16 weeks

---

## 8. Resource Allocation

### 8.1 Resource Plan by Phase

#### Phase 1: Backend API (Weeks 1-5)

| Resource | Role | Weeks 1-5 | FTE | Tasks |
|----------|------|-----------|-----|-------|
| Dev 1 | Backend Developer | 5 weeks | 100% | Setup, Auth, Master Data, Procurement, Reporting |
| Dev 2 | Backend Developer | 5 weeks | 100% | Infrastructure, Budget, Inventory, Distribution, Returns |
| QA | QA Engineer | 5 weeks | 100% | Testing, Quality Assurance |
| TL | Technical Lead | 5 weeks | 50% | Code reviews, Architecture decisions |
| PM | Project Manager | 5 weeks | 25% | Planning, Coordination |

**Total FTE**: 4.75

#### Phase 2: Frontend (Weeks 6-10)

| Resource | Role | Weeks 6-10 | FTE | Tasks |
|----------|------|------------|-----|-------|
| FE Dev 1 | Frontend Developer | 5 weeks | 100% | Setup, Auth, Master Data, Budget, Inventory, Returns |
| FE Dev 2 | Frontend Developer | 5 weeks | 100% | Layout, Dashboard, Procurement, Distribution, Reporting |
| UX | UX/UI Designer | 5 weeks | 25% | UI Polish, Accessibility |
| QA | QA Engineer | 5 weeks | 100% | Component tests, E2E tests |
| TL | Technical Lead | 5 weeks | 50% | Code reviews, Architecture |
| PM | Project Manager | 5 weeks | 50% | Planning, Stakeholder management |

**Total FTE**: 4.25

#### Phase 3: Integration & Testing (Weeks 11-13)

| Resource | Role | Weeks 11-13 | FTE | Tasks |
|----------|------|-------------|-----|-------|
| Dev Team | All Developers | 3 weeks | 100% | Defect fixing, Optimization |
| QA | QA Engineer | 3 weeks | 100% | Integration, Performance, Security testing |
| DevOps | DevOps Engineer | 3 weeks | 50% | Performance tuning, Infrastructure |
| BA | Business Analyst | 3 weeks | 100% | UAT preparation, coordination |
| Hospital Staff | UAT Testers | Week 13 | 50% | UAT execution |
| PM | Project Manager | 3 weeks | 100% | UAT management, Sign-off |

**Total FTE**: 5.5 (Week 11-12), 6.0 (Week 13)

#### Phase 4: Deployment & Training (Weeks 14-16)

| Resource | Role | Weeks 14-16 | FTE | Tasks |
|----------|------|-------------|-----|-------|
| DevOps | DevOps Engineer | 3 weeks | 100% | Production setup, Deployment |
| Dev Team | All Developers | 3 weeks | 50% | Hotfixes, Support |
| BA | Business Analyst | 3 weeks | 100% | Training coordination, Materials |
| TL | Technical Lead | 3 weeks | 50% | Administrator training, Handover |
| Pharmacist | Subject Matter Expert | Week 15 | 100% | Training delivery |
| PM | Project Manager | 3 weeks | 100% | Deployment management, Handover |

**Total FTE**: 5.0

### 8.2 Resource Histogram

```
FTE
10│
 9│
 8│
 7│                                                              ██
 6│                                                           ██ ██ ██
 5│ ██ ██ ██ ██ ██           ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██
 4│ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██
 3│ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██
 2│ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██
 1│ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██
 0└┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴
  W1 W2 W3 W4 W5 W6 W7 W8 W9 W10W11W12W13W14W15W16

  Phase 1         Phase 2              Phase 3    Phase 4
  (Backend)       (Frontend)           (Testing)  (Deploy)
```

**Peak Resource Usage**: Week 13 (UAT week) - 6.0 FTE
**Average Resource Usage**: ~5.0 FTE

---

## 9. Risk Management

### 9.1 Risk Register

| ID | Risk | Probability | Impact | Score | Mitigation | Owner |
|----|------|-------------|--------|-------|------------|-------|
| R1 | **Key developer unavailability** | Medium | High | 15 | Cross-training, documentation, backup resources | PM |
| R2 | **Scope creep from stakeholders** | High | Medium | 12 | Strict change control, sign-off requirements | PM |
| R3 | **API performance issues** | Medium | High | 15 | Early performance testing, optimization, caching | Tech Lead |
| R4 | **Ministry requirements change** | Low | Critical | 15 | Monitor official announcements, modular design | BA |
| R5 | **Integration bugs Frontend-Backend** | Medium | Medium | 9 | Continuous integration, early integration testing | QA |
| R6 | **UAT delays due to user availability** | High | Medium | 12 | Flexible UAT schedule, backup testers | BA + PM |
| R7 | **Database migration data loss** | Low | Critical | 15 | Multiple backups, migration testing, rollback plan | DevOps |
| R8 | **Production deployment failures** | Medium | High | 15 | Blue-green deployment, rollback procedures, dry runs | DevOps |
| R9 | **User resistance to new system** | Medium | Medium | 9 | Comprehensive training, change management, support | PM + BA |
| R10 | **Legacy system parallel run issues** | Medium | Medium | 9 | Clear cutover plan, extended parallel run | PM |
| R11 | **Budget overrun** | Medium | High | 15 | Regular budget reviews, prioritization | PM |
| R12 | **Timeline delays** | High | High | 20 | Buffer time, critical path management, daily tracking | PM |

**Risk Scoring**: Probability × Impact (1-5 scale)
- **Critical (16-25)**: Immediate action required
- **High (11-15)**: Active monitoring and mitigation
- **Medium (6-10)**: Regular monitoring
- **Low (1-5)**: Accept and monitor

### 9.2 Risk Response Strategies

#### R1: Key Developer Unavailability
**Mitigation**:
- Cross-train team members on critical components
- Maintain comprehensive code documentation
- Keep backup resources on standby
- Use pair programming for critical features

**Contingency**:
- Adjust timeline if extended absence
- Engage contractor for critical skills

#### R2: Scope Creep
**Mitigation**:
- Formal change request process
- Change control board approval required
- Document all scope changes with impact analysis
- Regular stakeholder alignment meetings

**Contingency**:
- Defer non-critical changes to Phase 2
- Negotiate timeline or resource adjustment

#### R3: API Performance Issues
**Mitigation**:
- Performance testing from Week 3
- Database query optimization
- Implement caching (Redis)
- Use database indexes effectively

**Contingency**:
- Dedicated optimization sprint
- Database scaling (read replicas)

#### R4: Ministry Requirements Change
**Mitigation**:
- Monitor DMSIC announcements weekly
- Modular design for export views
- Version control for export schemas
- Regular compliance audits

**Contingency**:
- Emergency update sprint
- Parallel support for old and new formats

#### R12: Timeline Delays
**Mitigation**:
- Daily standup tracking
- Weekly progress reports
- Early identification of blockers
- 10% buffer time built into schedule

**Contingency**:
- Prioritize critical features (MVP)
- Defer non-critical features
- Request timeline extension with justification

---

## 10. Budget Estimate

### 10.1 Personnel Costs

**Assumptions**:
- Average developer rate: ฿80,000/month
- Average specialist rate: ฿100,000/month
- Project duration: 4 months (16 weeks)

| Role | FTE | Duration | Rate/Month | Total |
|------|-----|----------|------------|-------|
| **Backend Developer 1** | 1.0 | 4 months | ฿80,000 | ฿320,000 |
| **Backend Developer 2** | 1.0 | 4 months | ฿80,000 | ฿320,000 |
| **Frontend Developer 1** | 1.0 | 4 months | ฿80,000 | ฿320,000 |
| **Frontend Developer 2** | 1.0 | 4 months | ฿80,000 | ฿320,000 |
| **Technical Lead** | 0.5 | 4 months | ฿100,000 | ฿200,000 |
| **QA Engineer** | 1.0 | 4 months | ฿70,000 | ฿280,000 |
| **DevOps Engineer** | 0.5 | 4 months | ฿100,000 | ฿200,000 |
| **UX/UI Designer** | 0.25 | 4 months | ฿80,000 | ฿80,000 |
| **Business Analyst** | 0.5 | 4 months | ฿70,000 | ฿140,000 |
| **Project Manager** | 0.5 | 4 months | ฿90,000 | ฿180,000 |
| **Subtotal Personnel** |  |  |  | **฿2,360,000** |

### 10.2 Infrastructure Costs

| Item | Quantity | Duration | Rate/Month | Total |
|------|----------|----------|------------|-------|
| **Production Server** (8 vCPU, 16GB RAM) | 2 | 4 months | ฿5,000 | ฿40,000 |
| **Database Server** (4 vCPU, 16GB RAM) | 1 | 4 months | ฿4,000 | ฿16,000 |
| **Development/Test Servers** | 3 | 4 months | ฿2,000 | ฿24,000 |
| **Load Balancer** | 1 | 4 months | ฿2,000 | ฿8,000 |
| **Storage** (500GB SSD) | 1 | 4 months | ฿1,500 | ฿6,000 |
| **Backup Storage** (1TB) | 1 | 4 months | ฿1,000 | ฿4,000 |
| **SSL Certificate** | 1 | 1 year | ฿10,000 | ฿10,000 |
| **Domain Registration** | 1 | 1 year | ฿500 | ฿500 |
| **Monitoring Tools** (Grafana Cloud) | 1 | 4 months | ฿3,000 | ฿12,000 |
| **Subtotal Infrastructure** |  |  |  | **฿120,500** |

### 10.3 Software & Tools

| Item | Quantity | Type | Cost |
|------|----------|------|------|
| **Node.js** | - | Open Source | ฿0 |
| **React** | - | Open Source | ฿0 |
| **PostgreSQL** | - | Open Source | ฿0 |
| **Prisma** | - | Open Source | ฿0 |
| **VS Code** | - | Free | ฿0 |
| **GitHub** (Team Plan) | 10 users | 4 months @ ฿150/user/month | ฿6,000 |
| **Testing Tools** (Vitest, Playwright) | - | Open Source | ฿0 |
| **Design Tools** (Figma Pro) | 2 users | 4 months @ ฿400/user/month | ฿3,200 |
| **Project Management** (Jira/Linear) | 10 users | 4 months @ ฿200/user/month | ฿8,000 |
| **Subtotal Software** |  |  | **฿17,200** |

### 10.4 Other Costs

| Item | Description | Cost |
|------|-------------|------|
| **Training** | Training materials, venue, refreshments | ฿50,000 |
| **Documentation** | User manuals, videos (professional editing) | ฿30,000 |
| **Contingency** | 10% of total budget | ฿258,770 |
| **Subtotal Other** |  | **฿338,770** |

### 10.5 Total Budget

| Category | Amount | % of Total |
|----------|--------|------------|
| **Personnel** | ฿2,360,000 | 81.5% |
| **Infrastructure** | ฿120,500 | 4.2% |
| **Software & Tools** | ฿17,200 | 0.6% |
| **Other (Training, Docs, Contingency)** | ฿338,770 | 11.7% |
| **TOTAL BUDGET** | **฿2,836,470** | 100% |

**Budget Breakdown**:
- **Phase 1 (Backend)**: ฿700,000 (25%)
- **Phase 2 (Frontend)**: ฿850,000 (30%)
- **Phase 3 (Testing)**: ฿550,000 (19%)
- **Phase 4 (Deployment)**: ฿450,000 (16%)
- **Contingency**: ฿286,470 (10%)

---

## 11. Communication Plan

### 11.1 Communication Matrix

| Audience | Information | Frequency | Method | Owner |
|----------|-------------|-----------|--------|-------|
| **Development Team** | Daily progress, blockers | Daily | Standup (15 min) | Tech Lead |
| **Project Team** | Weekly status, risks, issues | Weekly | Status Meeting (1 hour) | PM |
| **Stakeholders** | Progress, milestones, decisions | Bi-weekly | Sprint Review (2 hours) | PM |
| **Steering Committee** | Strategic updates, budget, risks | Monthly | Executive Meeting (1 hour) | PM + Sponsor |
| **End Users** | Training, updates, go-live | As needed | Email, Training Sessions | BA |
| **IT Operations** | Technical updates, deployment | Weekly | Tech Meeting (30 min) | DevOps |

### 11.2 Status Reporting

**Weekly Status Report Template**:
```markdown
# INVS Modern - Week [X] Status Report
**Date**: [Report Date]
**Reporting Period**: [Start Date] - [End Date]

## Executive Summary
[2-3 sentences on overall progress]

## Progress This Week
### Completed
- [Task 1]
- [Task 2]

### In Progress
- [Task 3] - 60% complete
- [Task 4] - 30% complete

### Planned Next Week
- [Task 5]
- [Task 6]

## Milestones
| Milestone | Target Date | Status |
|-----------|-------------|--------|
| Backend API Complete | Week 5 | On Track ✅ |
| Frontend Complete | Week 10 | On Track ✅ |

## Risks & Issues
| ID | Description | Impact | Status | Mitigation |
|----|-------------|--------|--------|------------|
| R1 | Developer sick leave | Medium | Active | Backup assigned |

## Budget Status
- **Spent to Date**: ฿X
- **Remaining Budget**: ฿Y
- **Variance**: On Budget ✅

## Decisions Needed
1. [Decision 1] - Needed by [Date]
2. [Decision 2] - Needed by [Date]

## Next Week Focus
[2-3 key priorities]
```

### 11.3 Escalation Path

**Level 1: Team Level** (0-2 days)
- Issue identified by team member
- Discuss in daily standup
- Technical Lead coordinates resolution

**Level 2: Project Manager** (3-5 days)
- Issue escalated to PM if unresolved
- PM assesses impact and options
- PM coordinates with stakeholders

**Level 3: Steering Committee** (5+ days or critical)
- Major scope/budget/timeline impacts
- Steering Committee reviews options
- Formal decision and approval

---

## 12. Quality Assurance

### 12.1 Quality Standards

**Code Quality**:
- TypeScript strict mode enabled
- ESLint + Prettier for code formatting
- Code review required for all PRs
- Minimum 85% test coverage
- No critical security vulnerabilities (OWASP Top 10)

**Testing Standards**:
- Unit tests for all business logic
- Integration tests for API endpoints
- E2E tests for critical user flows
- Performance tests (< 2s page load)
- Accessibility tests (WCAG 2.1 Level AA)

**Documentation Standards**:
- API documentation (OpenAPI/Swagger)
- Code comments for complex logic
- User manual (Thai language)
- Administrator guide
- Deployment guide

### 12.2 Quality Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Code Coverage** | 90%+ | Vitest coverage report |
| **API Response Time** | < 500ms (95th percentile) | Performance tests |
| **Page Load Time** | < 2s | Lighthouse/WebPageTest |
| **Accessibility Score** | 90+ | Lighthouse accessibility |
| **Defect Density** | < 5 defects/KLOC | Defect tracking |
| **UAT Pass Rate** | 95%+ | UAT test results |

### 12.3 Quality Gates

**Phase 1 Exit Criteria** (Backend API):
- ✅ All API endpoints implemented (28 use cases)
- ✅ Unit test coverage ≥ 85%
- ✅ Integration tests passing
- ✅ API documentation complete
- ✅ No critical defects
- ✅ Code review completed

**Phase 2 Exit Criteria** (Frontend):
- ✅ All UI screens implemented (28 use cases)
- ✅ Component test coverage ≥ 70%
- ✅ E2E tests passing (critical paths)
- ✅ Accessibility score ≥ 90
- ✅ Responsive design (desktop, tablet)
- ✅ Thai language support

**Phase 3 Exit Criteria** (Testing):
- ✅ Integration tests passing (100%)
- ✅ Performance tests meeting targets
- ✅ Security audit passed
- ✅ UAT sign-off obtained
- ✅ All high-priority defects resolved

**Phase 4 Exit Criteria** (Deployment):
- ✅ Production environment stable
- ✅ All users trained
- ✅ Backup and recovery tested
- ✅ Monitoring and alerting active
- ✅ Handover complete

---

## 13. Change Management

### 13.1 Change Control Process

**Change Request Procedure**:

1. **Request Submission**
   - Requester fills out Change Request Form
   - Include: Description, Justification, Impact Analysis
   - Submit to Project Manager

2. **Impact Analysis**
   - PM assesses impact on scope, schedule, budget, quality
   - Technical Lead assesses technical feasibility
   - QA assesses testing impact

3. **Review & Approval**
   - **Small Changes** (< 2 days effort): PM approval
   - **Medium Changes** (2-5 days effort): Steering Committee approval
   - **Large Changes** (> 5 days effort): Formal scope change, contract amendment

4. **Implementation**
   - Update project plan and schedule
   - Communicate change to team
   - Execute change
   - Verify and close

5. **Documentation**
   - Update project documentation
   - Log change in change log
   - Update stakeholders

### 13.2 Change Request Form

```markdown
# Change Request Form

**CR Number**: CR-[YYYY]-[###]
**Date**: [Submission Date]
**Requested By**: [Name, Department]

## Change Description
[Detailed description of the requested change]

## Justification
[Why is this change needed?]

## Impact Analysis
### Scope
- [ ] In Scope - Minor adjustment
- [ ] Out of Scope - New feature

### Schedule
- **Estimated Effort**: [X] days
- **Impact on Timeline**: [None / Delay by X days]

### Budget
- **Estimated Cost**: ฿[X]
- **Budget Impact**: [None / Additional ฿X needed]

### Quality/Risk
- **Quality Impact**: [None / Low / Medium / High]
- **Risks**: [List any risks]

## Priority
- [ ] Critical - Blocker for go-live
- [ ] High - Important for business
- [ ] Medium - Nice to have
- [ ] Low - Future enhancement

## Decision
- [ ] Approved
- [ ] Rejected
- [ ] Deferred to Phase 2

**Approved By**: _________________ **Date**: _______
**Comments**: [Approval comments]
```

### 13.3 Change Log

| CR ID | Date | Requester | Description | Impact | Status | Decision |
|-------|------|-----------|-------------|--------|--------|----------|
| CR-2025-001 | 2025-02-01 | Pharmacy | Add drug barcode field | +1 day | Closed | Approved |
| CR-2025-002 | 2025-02-05 | Finance | Change budget report format | +2 days | Closed | Approved |
| CR-2025-003 | 2025-02-10 | IT | Add LDAP authentication | +10 days | Open | Deferred |

---

## 14. Appendices

### 14.1 Glossary

| Term | Definition |
|------|------------|
| **API** | Application Programming Interface |
| **BRD** | Business Requirements Document |
| **CI/CD** | Continuous Integration/Continuous Deployment |
| **E2E** | End-to-End (testing) |
| **FEFO** | First Expire First Out |
| **FIFO** | First In First Out |
| **FTE** | Full-Time Equivalent |
| **KLOC** | Thousand Lines of Code |
| **NLEM** | National List of Essential Medicines |
| **ORM** | Object-Relational Mapping (Prisma) |
| **PO** | Purchase Order |
| **PR** | Purchase Request |
| **QA** | Quality Assurance |
| **SOP** | Standard Operating Procedure |
| **TMT** | Thai Medical Terminology |
| **TRD** | Technical Requirements Document |
| **UAT** | User Acceptance Testing |
| **WCAG** | Web Content Accessibility Guidelines |

### 14.2 Acronyms

| Acronym | Full Name |
|---------|-----------|
| **DMSIC** | Drug and Medical Supply Information Center |
| **GPO** | Government Pharmaceutical Organization |
| **HIS** | Hospital Information System |
| **ICU** | Intensive Care Unit |
| **IPD** | Inpatient Department |
| **OPD** | Outpatient Department |
| **OWASP** | Open Web Application Security Project |
| **PWA** | Progressive Web App |
| **REST** | Representational State Transfer |
| **SSL** | Secure Sockets Layer |
| **UI/UX** | User Interface/User Experience |
| **VM** | Virtual Machine |

### 14.3 References

1. [Business Requirements Document (BRD)](BRD.md)
2. [Technical Requirements Document (TRD)](TRD.md)
3. [Use Case Document](USE_CASE_DOCUMENT.md)
4. [Test Plan](TEST_PLAN.md)
5. [Database Design Document](DATABASE_DESIGN.md)
6. [README.md](../README.md)
7. [PROJECT_STATUS.md](../PROJECT_STATUS.md)

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-01-22 | Project Team | Initial project plan and Gantt chart |

**Approval**:
- [ ] Project Manager: _________________ Date: _______
- [ ] Technical Lead: _________________ Date: _______
- [ ] Steering Committee: _________________ Date: _______

---

**INVS Modern Project Plan** - Your Roadmap to Success 🚀

**Ready to Begin**: Phase 1 (Backend API Development) starts Week 1!

**Contact**:
- Project Manager: [Name] - [Email]
- Technical Lead: [Name] - [Email]
