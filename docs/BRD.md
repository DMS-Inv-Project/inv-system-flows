# 📋 Business Requirements Document (BRD)

**Project:** INVS Modern - Hospital Inventory Management System
**Version:** 2.4.0
**Date:** 2025-01-22
**Status:** Production Ready

---

## 1. Executive Summary

### 1.1 Project Overview
INVS Modern is a comprehensive hospital drug inventory management system designed for Thai hospitals to manage drug procurement, inventory tracking, distribution, and budget control in compliance with Ministry of Public Health regulations.

### 1.2 Business Objectives
1. **Streamline Procurement Process**: Reduce procurement cycle time by 40%
2. **Improve Budget Control**: Achieve 100% budget compliance with real-time monitoring
3. **Ensure Drug Safety**: Implement FIFO/FEFO inventory management to prevent expired drug dispensing
4. **Ministry Compliance**: Meet 100% DMSIC Standards พ.ศ. 2568 requirements (79/79 fields)
5. **Reduce Drug Waste**: Decrease expired drug losses by 30% through lot tracking

### 1.3 Success Criteria
- ✅ 100% Ministry of Public Health compliance (ACHIEVED)
- ✅ Complete drug master data migration (3,152 records MIGRATED)
- 🎯 <2 seconds response time for budget availability checks
- 🎯 Zero budget overspending incidents
- 🎯 95% user satisfaction rating
- 🎯 50% reduction in manual data entry time

---

## 2. Business Requirements

### 2.1 Stakeholder Requirements

#### 2.1.1 Hospital Administrators
**Needs:**
- Real-time budget monitoring dashboard
- Quarterly and annual budget reports
- Drug expense analysis by department
- Vendor performance reports
- Compliance audit trails

**Pain Points:**
- Manual budget tracking in Excel
- Delayed approval processes
- Lack of real-time visibility
- Difficult to enforce budget limits

#### 2.1.2 Pharmacy Department
**Needs:**
- Fast drug catalog search (>1,000 drugs)
- Lot number and expiry date tracking
- FIFO/FEFO automatic suggestions
- Stock level monitoring with alerts
- Distribution request management

**Pain Points:**
- Time-consuming manual lot tracking
- Expired drug incidents
- Stock discrepancies
- Complex distribution workflows

#### 2.1.3 Procurement Department
**Needs:**
- Purchase request workflow automation
- Budget availability checking before PO creation
- Vendor catalog management
- Receipt inspection and approval
- Purchase history tracking

**Pain Points:**
- Paper-based approval workflows
- Budget overruns discovered too late
- Manual data entry errors
- Lack of purchase analytics

#### 2.1.4 Clinical Departments
**Needs:**
- Quick drug distribution requests
- Stock availability checking
- Usage history tracking
- Return management for unused drugs

**Pain Points:**
- Delayed drug distribution
- Unclear stock status
- Manual requisition forms
- No tracking of returned drugs

#### 2.1.5 IT Department
**Needs:**
- RESTful API for HIS integration
- Database backup and recovery
- User access control management
- System monitoring and logging

**Pain Points:**
- Legacy system integration challenges
- Data synchronization issues
- Security vulnerabilities
- Poor system documentation

---

## 3. Functional Requirements

### 3.1 Master Data Management (FR-001)

#### FR-001.1: Drug Catalog Management
**Priority:** Critical
**Description:** Manage comprehensive drug catalog with 1,109 generic drugs and 1,169 trade drugs

**Requirements:**
- Support both generic drugs and trade drugs
- Link trade drugs to generic drugs
- Support multiple dosage forms (87 types)
- Track manufacturer and vendor information
- Support Thai Medical Terminology (TMT) mapping (25,991 concepts)
- Store working codes, trade codes, TMT codes

**Acceptance Criteria:**
- Users can search drugs by name, code, or generic
- System displays linked generic information for trade drugs
- TMT mapping achieves ≥95% coverage
- Search results return in <1 second for 1,000+ drugs

#### FR-001.2: Vendor Management
**Priority:** High
**Description:** Maintain vendor catalog with contact and contract information

**Requirements:**
- Store vendor company details (name, tax ID, address)
- Track multiple contact persons per vendor
- Support vendor status (active, suspended, blacklisted)
- Link vendors to purchasable drugs

**Acceptance Criteria:**
- System prevents PO creation for inactive vendors
- Contact information is validated (email format, phone number)
- Vendor list can be exported for reporting

#### FR-001.3: Location Management
**Priority:** High
**Description:** Define storage locations for inventory tracking

**Requirements:**
- Support multiple location types (warehouse, pharmacy, ward, emergency)
- Define location hierarchy (building → floor → room)
- Set location capacity and storage conditions
- Track location status (active, maintenance, closed)

**Acceptance Criteria:**
- Inventory can be tracked by specific location
- Location capacity warnings are displayed
- Storage conditions are enforced (e.g., refrigerated drugs)

### 3.2 Budget Management System (FR-002)

#### FR-002.1: Budget Allocation
**Priority:** Critical
**Description:** Manage annual budget allocations by department and budget type

**Requirements:**
- Support 6 budget types (OP001-drugs, OP002-equipment, OP003-supplies, IV001-equipment, IV002-IT, EM001-emergency)
- Allocate budget by fiscal year and quarter (Q1-Q4)
- Track allocated, reserved, spent, and available amounts
- Support budget revisions and adjustments

**Acceptance Criteria:**
- Budget allocations sum correctly by quarter and year
- System prevents spending beyond allocated amount
- Budget changes are logged with user and timestamp
- Available budget is calculated in real-time: `allocated - reserved - spent`

#### FR-002.2: Budget Planning with Drug Details
**Priority:** High
**Description:** Plan drug purchases at drug-generic level with historical data

**Requirements:**
- Plan by drug generic with target quantity and budget
- Support quarterly breakdown (Q1-Q4)
- Display 3-year historical consumption data
- Track purchased vs planned amounts
- Calculate variance and provide alerts

**Acceptance Criteria:**
- Pharmacists can view 3-year consumption history per drug
- System suggests purchase quantities based on historical average
- Variances >20% from plan generate warnings
- Plan vs actual reports available monthly

#### FR-002.3: Budget Reservation
**Priority:** Critical
**Description:** Temporarily reserve budget when PR is submitted

**Requirements:**
- Reserve budget automatically when PR status = BUDGET_RESERVED
- Set reservation expiry (default 30 days)
- Release reservation on PR rejection/cancellation
- Commit reservation to spent on PO approval
- Track reservation status (ACTIVE, COMMITTED, RELEASED, EXPIRED)

**Acceptance Criteria:**
- Budget availability check passes only if sufficient unreserved budget
- Reservations auto-expire after 30 days
- Expired reservations release budget back to available
- All budget state changes are logged in audit trail

#### FR-002.4: Budget Monitoring
**Priority:** High
**Description:** Real-time budget monitoring and reporting

**Requirements:**
- Dashboard showing budget status by department
- Monthly spending trends and forecasts
- Budget utilization percentage calculations
- Alerts for budget thresholds (80%, 90%, 95%)
- Export budget reports to Excel/PDF

**Acceptance Criteria:**
- Dashboard updates in real-time (<5 seconds after transaction)
- Alerts are sent to department heads when thresholds crossed
- Reports match accounting system (zero discrepancies)
- Historical budget data is retained for 10 years

### 3.3 Procurement Workflow (FR-003)

#### FR-003.1: Purchase Request (PR) Creation
**Priority:** Critical
**Description:** Create and submit purchase requests with budget validation

**Requirements:**
- Create PR with multiple drug items
- Select drugs from catalog with autocomplete
- Specify quantity, unit price, and budget type
- Attach justification documents
- Validate against budget plan (if exists)
- Check budget availability before submission

**Acceptance Criteria:**
- PR form validates all required fields
- Budget check shows real-time available amount
- System prevents submission if budget insufficient
- Draft PRs can be saved and edited later
- PR number is auto-generated with format: PR-YYYY-NNNN

#### FR-003.2: PR Approval Workflow
**Priority:** Critical
**Description:** Multi-level approval workflow with budget reservation

**Requirements:**
- PR workflow states: DRAFT → SUBMITTED → BUDGET_CHECK → BUDGET_RESERVED → APPROVED → PO_CREATED
- Reserve budget when status = BUDGET_RESERVED
- Require director approval for PRs >100,000 THB
- Allow rejection with reason
- Support cancellation before approval
- Send email notifications at each state change

**Acceptance Criteria:**
- Approvers receive email within 1 minute
- Approval actions are logged with timestamp and user
- Budget is reserved immediately after budget check passes
- Rejected PRs release budget reservation
- Approval history is viewable in PR detail page

#### FR-003.3: Purchase Order (PO) Generation
**Priority:** Critical
**Description:** Auto-generate PO from approved PR

**Requirements:**
- Auto-create PO when PR status = APPROVED
- Select vendor from company catalog
- Copy items from PR with quantities
- Generate PO number format: PO-YYYY-NNNN
- Set delivery date and terms
- Commit budget when PO is approved
- Support PO revision if needed

**Acceptance Criteria:**
- PO is created within 5 seconds of PR approval
- PO items match PR items exactly
- Budget is committed (moved from reserved to spent)
- PO can be printed/exported to PDF
- Vendor receives email notification with PO PDF

#### FR-003.4: Goods Receipt and Inspection
**Priority:** Critical
**Description:** Record goods receipt with quality inspection

**Requirements:**
- Create receipt document linked to PO
- Record received quantity vs ordered quantity
- Support partial receipts (multiple deliveries)
- Enter lot numbers and expiry dates
- Committee inspection approval required
- Handle rejected receipts (return to vendor)
- Update PO status based on received quantities

**Acceptance Criteria:**
- Receipt can be created for partial quantities
- Lot numbers and expiry dates are mandatory
- Inspection committee can approve/reject with reason
- Approved receipts auto-update inventory
- PO status changes to FULLY_RECEIVED when all items received

### 3.4 Inventory Management (FR-004)

#### FR-004.1: Stock Level Tracking
**Priority:** Critical
**Description:** Track stock levels by drug, location, and lot

**Requirements:**
- Real-time stock quantity updates
- Track by location (warehouse, pharmacy, ward)
- Support multiple lots per drug with FIFO/FEFO
- Set min/max stock levels per drug/location
- Calculate reorder points automatically
- Generate low stock alerts

**Acceptance Criteria:**
- Stock levels update immediately after transactions
- Low stock alerts sent when qty < reorder point
- Stock discrepancies can be investigated via transaction log
- Zero stock levels prevent distribution unless emergency override

#### FR-004.2: Lot Management (FIFO/FEFO)
**Priority:** Critical
**Description:** Track drug lots with expiry dates using FIFO/FEFO logic

**Requirements:**
- Create lot records when goods are received
- Store lot number, expiry date, quantity on hand
- Implement FIFO (First In First Out) algorithm
- Implement FEFO (First Expire First Out) algorithm
- Generate expiring drug reports (30, 60, 90 days)
- Prevent dispensing of expired lots
- Support lot adjustments with reason codes

**Acceptance Criteria:**
- System suggests oldest lot first (FIFO) or nearest expiry (FEFO)
- Expired lots are auto-flagged and blocked from dispensing
- Expiring drug report sent weekly to pharmacy head
- Lot adjustments require supervisor approval
- Full lot traceability from receipt to distribution

#### FR-004.3: Inventory Transactions
**Priority:** High
**Description:** Log all inventory movements with audit trail

**Requirements:**
- Record transaction types: RECEIVE, ISSUE, TRANSFER, ADJUST, RETURN
- Log user, timestamp, quantity, lot, from/to location
- Support transaction reversal (with approval)
- Link transactions to source documents (PO, Distribution, Return)
- Generate inventory movement reports

**Acceptance Criteria:**
- Every stock change has a corresponding transaction record
- Transaction log is immutable (no delete, only reverse)
- Reports reconcile with physical stock counts
- Transaction history is retained for 10 years

### 3.5 Drug Distribution (FR-005)

#### FR-005.1: Distribution Request
**Priority:** High
**Description:** Create and fulfill drug distribution requests from departments

**Requirements:**
- Departments create distribution requests with multiple items
- Select drugs from catalog with current stock display
- Specify requested quantity and urgency
- Check stock availability before submission
- Support STAT (emergency) requests with priority handling
- Track request status: DRAFT → PENDING → APPROVED → FULFILLED

**Acceptance Criteria:**
- Unavailable drugs are clearly marked in catalog
- STAT requests appear at top of fulfillment queue
- Requested quantities are validated against stock
- Distribution requests can be partially fulfilled
- Fulfillment updates inventory immediately

#### FR-005.2: Distribution Fulfillment
**Priority:** High
**Description:** Process distribution requests with lot selection

**Requirements:**
- Pharmacist reviews pending distribution requests
- System suggests lots using FIFO or FEFO
- Pharmacist can override lot selection with reason
- Record actual distributed quantity (may differ from requested)
- Print distribution slip with lot numbers and expiry dates
- Transfer inventory from pharmacy to department location

**Acceptance Criteria:**
- Distribution slip includes all traceability information
- Inventory is transferred atomically (pharmacy decrease, department increase)
- Partial fulfillments are tracked separately
- Unfulfilled items remain in pending status

### 3.6 Drug Return Management (FR-006)

#### FR-006.1: Drug Return Process
**Priority:** Medium
**Description:** Handle drug returns from departments to pharmacy

**Requirements:**
- Create return document with return reason (19 predefined reasons)
- Return reason categories: Clinical, Operational, Quality
- Verify lot numbers and expiry dates
- Inspect drug condition (sealed, opened, damaged)
- Process return types: RETURN_TO_STOCK, RETURN_TO_VENDOR, DISPOSE
- Update inventory based on return type

**Acceptance Criteria:**
- Return reasons must be selected from predefined list
- Opened or damaged drugs cannot be returned to stock
- Return to stock updates inventory immediately
- Return to vendor creates vendor credit note
- Disposal requires authorized signature

### 3.7 Reporting and Analytics (FR-007)

#### FR-007.1: Ministry of Public Health Reports
**Priority:** Critical
**Description:** Generate standard reports for ministry compliance

**Requirements:**
- Export DRUGLIST format (11 fields, 79 total ministry fields achieved)
- Export PURCHASEPLAN format (20 fields)
- Export RECEIPT format (22 fields)
- Export DISTRIBUTION format (11 fields)
- Export INVENTORY format (15 fields)
- Support CSV and Excel formats
- Include all mandatory fields per DMSIC Standards พ.ศ. 2568

**Acceptance Criteria:**
- Exports pass ministry validation tool (100% pass rate)
- All 79 required fields are populated correctly
- Reports can be generated on-demand or scheduled
- Historical reports are archived for 10 years

#### FR-007.2: Operational Dashboards
**Priority:** High
**Description:** Real-time operational dashboards for daily management

**Requirements:**
- Budget status dashboard (by department, budget type)
- Inventory status dashboard (stock levels, expiring drugs)
- Procurement pipeline dashboard (PR/PO status)
- Distribution queue dashboard (pending requests)
- Vendor performance dashboard (on-time delivery, quality)

**Acceptance Criteria:**
- Dashboards load in <3 seconds
- Data refreshes every 5 minutes
- Charts are interactive with drill-down capability
- Dashboards are role-based (admin sees all, department sees own)

#### FR-007.3: Custom Reports
**Priority:** Medium
**Description:** Flexible report builder for ad-hoc analysis

**Requirements:**
- Select data tables and fields
- Apply filters (date range, department, drug type)
- Group by and aggregate functions (SUM, AVG, COUNT)
- Export to Excel, PDF, CSV
- Save report templates for reuse
- Schedule automated report generation

**Acceptance Criteria:**
- Non-technical users can create simple reports
- Report builder has template library (10+ templates)
- Scheduled reports are delivered via email
- Large reports (>10,000 rows) export successfully

---

## 4. Non-Functional Requirements

### 4.1 Performance (NFR-001)

**Requirements:**
- Page load time <2 seconds for 95% of requests
- API response time <500ms for simple queries
- Budget availability check completes in <1 second
- Support 100 concurrent users
- Database queries optimized with proper indexing
- Handle 10,000+ drug catalog searches per day

**Acceptance Criteria:**
- Load testing confirms performance targets
- Slow queries (>1 second) are logged and optimized
- System remains responsive during peak hours (8-10 AM)

### 4.2 Security (NFR-002)

**Requirements:**
- Role-based access control (RBAC) with 6 roles:
  - Admin, Pharmacist, Procurement Officer, Department Staff, Director, Auditor
- All API requests require authentication (JWT tokens)
- Passwords hashed with bcrypt (cost factor 12)
- Audit log for all data changes (who, what, when)
- HTTPS only (TLS 1.3)
- SQL injection prevention via parameterized queries (Prisma ORM)
- XSS protection via input sanitization
- CSRF protection via tokens

**Acceptance Criteria:**
- Penetration testing shows no critical vulnerabilities
- Failed login attempts are rate-limited (5 attempts → 15 min lockout)
- All sensitive data is encrypted at rest and in transit
- Audit logs are immutable and tamper-proof

### 4.3 Scalability (NFR-003)

**Requirements:**
- Support hospital growth from 200 to 500 beds
- Handle 5-year data retention (estimated 1M+ transactions)
- Database partitioning for large tables (transactions, audit logs)
- Horizontal scaling capability for API servers
- Connection pooling for database (max 20 connections)

**Acceptance Criteria:**
- Database size growth <20 GB per year
- Query performance does not degrade with 5 years of data
- System can scale to 500 concurrent users with infrastructure upgrade

### 4.4 Availability (NFR-004)

**Requirements:**
- 99.5% uptime (target 43.8 hours downtime per year)
- Scheduled maintenance window: Sunday 02:00-04:00 AM
- Automated database backups every 4 hours
- Point-in-time recovery capability (last 30 days)
- Disaster recovery plan with RTO <4 hours, RPO <1 hour

**Acceptance Criteria:**
- Backup restoration tested monthly
- System recovers from database failure in <1 hour
- No data loss in disaster scenarios

### 4.5 Usability (NFR-005)

**Requirements:**
- Thai language interface (primary)
- English language option (secondary)
- Responsive design for desktop, tablet, mobile
- Keyboard shortcuts for power users
- Consistent UI/UX patterns across modules
- Accessibility compliance (WCAG 2.1 Level AA)
- User training materials and help documentation

**Acceptance Criteria:**
- New users can complete basic tasks after 2 hours of training
- User satisfaction score ≥4.0/5.0
- Mobile interface usable on phones ≥5.5 inch screens
- Screen reader compatible for visually impaired users

### 4.6 Maintainability (NFR-006)

**Requirements:**
- TypeScript codebase with strict type checking
- Prisma ORM for type-safe database access
- Comprehensive code documentation (JSDoc)
- Unit test coverage ≥80%
- Integration test coverage for critical workflows
- Database migration scripts version-controlled
- API documentation via OpenAPI/Swagger

**Acceptance Criteria:**
- New developers can set up dev environment in <30 minutes
- Code changes pass automated tests before deployment
- API documentation is always up-to-date with code

---

## 5. Business Rules

### 5.1 Budget Control Rules

**BR-001:** Budget availability check is mandatory before PR submission
- Exception: Emergency purchases can be approved with director override

**BR-002:** Budget reservation expires after 30 days if PR not approved
- System auto-releases expired reservations daily

**BR-003:** Budget cannot be exceeded at department + budget type + fiscal year level
- System prevents PO creation if budget insufficient

**BR-004:** Budget revisions require CFO approval for amounts >500,000 THB

**BR-005:** Quarterly budget can be reallocated within same fiscal year
- Reallocation requires department head + CFO approval

### 5.2 Procurement Rules

**BR-006:** PR approval required before PO creation (no exception)

**BR-007:** PO approval required before sending to vendor
- Exception: Emergency PO can be sent with provisional approval

**BR-008:** Purchase methods based on value:
- <100,000 THB: Direct purchase
- 100,000-500,000 THB: Price comparison (3 vendors)
- >500,000 THB: Public tender via e-GP system

**BR-009:** Goods receipt requires committee inspection for POs >50,000 THB
- Committee minimum 3 members: pharmacist, nurse, procurement officer

**BR-010:** Partial receipts allowed up to 10% variance from ordered quantity
- Variance >10% requires purchase order amendment

### 5.3 Inventory Rules

**BR-011:** FIFO/FEFO lot selection is default, manual override requires reason

**BR-012:** Expired drugs are auto-blocked from distribution
- Disposal requires authorized signature and reason

**BR-013:** Stock adjustments >5% require manager approval
- Adjustments are audited monthly

**BR-014:** Drug distribution to departments updates inventory immediately
- No delayed posting allowed

**BR-015:** Negative stock levels are prevented (system validation)
- Exception: Emergency override with director approval

### 5.4 Drug Return Rules

**BR-016:** Returns accepted only if drug sealed and not expired
- Opened drugs require quality check before return to stock

**BR-017:** Return reasons must be documented (select from 19 predefined reasons)

**BR-018:** Returns >10,000 THB require pharmacy head approval

**BR-019:** Return to vendor generates credit note automatically
- Credit note applied to next purchase from same vendor

### 5.5 Ministry Compliance Rules

**BR-020:** All drug catalog entries must have TMT code mapping
- Target ≥95% mapping coverage

**BR-021:** Ministry reports must be submitted quarterly
- Deadline: 15th day of month following quarter end

**BR-022:** All 79 ministry-required fields must be populated
- System validation prevents saving incomplete records

---

## 6. Data Requirements

### 6.1 Master Data

**Volume:**
- Drug Generics: 1,109 records ✅ (migrated)
- Trade Drugs: 1,169 records ✅ (migrated)
- Companies: 816 records ✅ (migrated)
- TMT Concepts: 25,991 records ✅ (migrated)
- Locations: 5 records ✅ (seeded)
- Departments: 5 records ✅ (seeded)
- Budget Types: 6 records ✅ (seeded)

**Data Quality:**
- Drug names in Thai and English
- Valid TMT code mapping for ≥95% drugs
- Accurate manufacturer and vendor links
- Current pricing information (updated quarterly)

### 6.2 Transactional Data

**Volume Estimates (per year):**
- Purchase Requests: ~500 PRs
- Purchase Orders: ~400 POs
- Receipts: ~600 receipts (partial receipts)
- Distributions: ~10,000 distributions
- Inventory Transactions: ~50,000 transactions
- Drug Returns: ~200 returns

**Data Retention:**
- Transactional data: 10 years
- Audit logs: 10 years
- Backups: 30 days online, 1 year archived

### 6.3 Data Migration

**Source:** Legacy MySQL database (133 tables)
**Status:** ✅ Phase 1-4 completed (3,152 records migrated)
**Phases:**
- Phase 1: Procurement methods and return reasons (57 records) ✅
- Phase 2: Drug components and focus lists (828 records) ✅
- Phase 3: Distribution types (2 records) ✅
- Phase 4: Drug master data (3,006 records) ✅

**Data Cleansing:**
- Remove duplicate drug entries
- Standardize Thai language encoding (UTF-8)
- Validate TMT code mappings
- Correct missing manufacturer links

---

## 7. Constraints and Assumptions

### 7.1 Constraints

**Technical Constraints:**
- Must use PostgreSQL 15+ (hospital IT standard)
- Must integrate with existing HIS via HL7/FHIR
- Must run on hospital private cloud (no public cloud)
- Database size limit: 100 GB initial allocation

**Business Constraints:**
- Budget: 5 million THB for development and 1-year support
- Timeline: 6 months development + 3 months UAT
- Hospital cannot stop operations during implementation
- Training must be completed before go-live

**Regulatory Constraints:**
- Must comply with Ministry of Public Health regulations
- Must comply with Personal Data Protection Act (PDPA)
- Must pass hospital security audit
- Must obtain ministry system certification

### 7.2 Assumptions

**Technical Assumptions:**
- Hospital has stable network infrastructure (99% uptime)
- Workstations meet minimum specs (4GB RAM, modern browser)
- IT team can manage PostgreSQL and Node.js applications
- Integration with HIS will be provided by HIS vendor

**Business Assumptions:**
- Users have basic computer skills
- Hospital provides dedicated project team (5 people)
- Current data quality is acceptable (80%+ accuracy)
- Vendor cooperation for integration

**Operational Assumptions:**
- Parallel run period of 2 months acceptable
- Legacy system will remain available for 6 months post go-live
- Users available for UAT 4 hours per day for 3 months

---

## 8. Risks and Mitigation

### 8.1 Technical Risks

**Risk 1: Data Migration Quality Issues**
- Impact: High
- Probability: Medium
- Mitigation:
  - Comprehensive data cleansing scripts
  - Validation reports before migration
  - Parallel run to verify data accuracy
  - Rollback plan if issues found

**Risk 2: Performance Degradation with Large Data**
- Impact: High
- Probability: Low
- Mitigation:
  - Database indexing strategy
  - Query optimization and load testing
  - Connection pooling and caching
  - Database partitioning for large tables

**Risk 3: HIS Integration Failures**
- Impact: High
- Probability: Medium
- Mitigation:
  - Detailed integration specification
  - Test environment with HIS sandbox
  - Fallback to manual data entry
  - Regular sync validation

### 8.2 Business Risks

**Risk 4: User Resistance to Change**
- Impact: Medium
- Probability: High
- Mitigation:
  - Early user involvement in design
  - Comprehensive training program
  - Super user program (train the trainer)
  - Quick wins to build confidence

**Risk 5: Budget Overrun**
- Impact: High
- Probability: Medium
- Mitigation:
  - Detailed project plan with buffer
  - Weekly budget tracking
  - Scope change control process
  - Phased implementation if needed

### 8.3 Regulatory Risks

**Risk 6: Ministry Certification Delay**
- Impact: High
- Probability: Low
- Mitigation:
  - Early engagement with ministry
  - Compliance checklist validation
  - Practice certification submission
  - Buffer time in project plan

---

## 9. Dependencies

### 9.1 External Dependencies

**Ministry of Public Health:**
- TMT code updates (quarterly)
- Compliance standards updates
- Certification process
- Reporting format changes

**Hospital Information System (HIS):**
- Patient data integration
- Prescription data feed
- User authentication (SSO)
- Department master data sync

**Vendors:**
- Drug pricing updates
- Product availability status
- Electronic ordering capability
- Invoice integration

### 9.2 Internal Dependencies

**IT Department:**
- Infrastructure provisioning
- Network configuration
- Backup systems
- Monitoring tools setup

**Pharmacy Department:**
- Business process documentation
- User requirements validation
- UAT participation
- Training feedback

**Finance Department:**
- Budget allocation approval
- Accounting system integration
- Cost center mapping
- Financial reporting requirements

---

## 10. Approval

### 10.1 Document Review

| Reviewer | Role | Status | Date |
|----------|------|--------|------|
| Dr. Somchai Pattana | Hospital Director | ⏳ Pending | - |
| Khun Pimchanok Lee | Pharmacy Head | ⏳ Pending | - |
| Khun Surasak Wong | IT Manager | ⏳ Pending | - |
| Khun Narisa Tan | CFO | ⏳ Pending | - |
| Khun Wichai Kumar | Procurement Head | ⏳ Pending | - |

### 10.2 Sign-Off

This document will be considered approved when all reviewers have signed off.

**Document Version:** 2.4.0
**Created Date:** 2025-01-22
**Author:** INVS Modern Project Team
**Next Review Date:** 2025-07-22 (6 months)

---

## Appendices

### Appendix A: Acronyms and Definitions

| Term | Definition |
|------|------------|
| BRD | Business Requirements Document |
| DMSIC | Drug and Medical Supply Information Center |
| FEFO | First Expire First Out |
| FIFO | First In First Out |
| HIS | Hospital Information System |
| NLEM | National List of Essential Medicines |
| PDPA | Personal Data Protection Act |
| PO | Purchase Order |
| PR | Purchase Request |
| TMT | Thai Medical Terminology |
| UAT | User Acceptance Testing |

### Appendix B: Related Documents

- Technical Requirements Document (TRD.md)
- Database Design Document (DATABASE_DESIGN.md)
- System Architecture Document (docs/SYSTEM_ARCHITECTURE.md)
- API Design Document (TBD)
- User Interface Design (docs/mock-ui/)
- Test Plan (TBD)

### Appendix C: Change History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-01-01 | Project Team | Initial draft |
| 2.0.0 | 2025-01-10 | Project Team | Post-migration update |
| 2.2.0 | 2025-01-20 | Project Team | Ministry compliance achieved |
| 2.4.0 | 2025-01-22 | Claude Code | Complete BRD with all requirements |

---

**End of Business Requirements Document**
