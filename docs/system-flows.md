# INVS Modern - System Flows & Business Processes

## 🔄 Core Business Flows

### 1. Budget Management Flow

```mermaid
graph TD
    A[Annual Budget Planning] --> B[Create Budget Allocations]
    B --> C[Quarterly Budget Distribution]
    C --> D[Department Budget Requests]
    D --> E{Budget Available?}
    E -->|Yes| F[Create Budget Reservation]
    E -->|No| G[Request Additional Budget]
    F --> H[Purchase Request Creation]
    G --> I[Budget Transfer/Approval]
    I --> F
    H --> J[Budget Commitment]
    J --> K[Purchase Order Creation]
    K --> L[Final Budget Deduction]
```

**Key Steps:**
1. **Budget Allocation**: ตั้งงบประมาณรายปีแบ่งเป็น Q1-Q4
2. **Budget Reservation**: จองงบเมื่อมี Purchase Request
3. **Budget Commitment**: ตัดงบเมื่อ approve Purchase Order
4. **Real-time Tracking**: ติดตามการใช้งบแบบ real-time

### 2. Procurement Flow

```mermaid
graph TD
    A[Identify Need] --> B[Create Purchase Request]
    B --> C[Add PR Items with Generic Drugs]
    C --> D[Check Budget Availability]
    D --> E{Budget OK?}
    E -->|Yes| F[Submit for Approval]
    E -->|No| G[Adjust Request or Get More Budget]
    F --> H[Department Head Approval]
    H --> I[Convert to Purchase Order]
    I --> J[Specify Trade Drugs & Vendor]
    J --> K[PO Approval]
    K --> L[Send PO to Vendor]
    L --> M[Receive Goods]
    M --> N[Create Receipt]
    N --> O[Update Inventory]
    O --> P[Update Budget Spent]
```

**Key Steps:**
1. **Purchase Request**: เริ่มจาก generic drugs, ระบุจำนวนและเหตุผล
2. **Budget Check**: ตรวจสอบงบประมาณ แล้วจองงบ
3. **Approval Workflow**: อนุมัติตามสายงาน
4. **Purchase Order**: เปลี่ยนเป็น trade drugs, เลือก vendor
5. **Goods Receipt**: รับของ สร้าง lot, อัปเดต inventory

### 3. Inventory Management Flow

```mermaid
graph TD
    A[Receive Goods] --> B[Create Drug Lots]
    B --> C[Update Inventory Levels]
    C --> D[FIFO/FEFO Management]
    D --> E[Stock Level Monitoring]
    E --> F{Below Min Level?}
    F -->|Yes| G[Generate Reorder Alert]
    F -->|No| H[Normal Operation]
    G --> I[Create Purchase Request]
    I --> J[Back to Procurement Flow]
    H --> K{Expiry Check}
    K --> L[FEFO Distribution]
    L --> M[Issue to Departments]
    M --> N[Update Transaction Log]
```

**Key Features:**
- **FIFO/FEFO**: First In First Out / First Expire First Out
- **Multi-location**: แยก stock ตาม location
- **Automatic Reorder**: แจ้งเตือนเมื่อถึง reorder point
- **Lot Tracking**: ติดตาม lot number และ expiry date

### 4. Drug Distribution Flow

```mermaid
graph TD
    A[Department Request] --> B[Check Stock Availability]
    B --> C{Stock Available?}
    C -->|Yes| D[Select Lots by FEFO]
    C -->|No| E[Back Order/Emergency Purchase]
    D --> F[Create Issue Transaction]
    F --> G[Update Inventory Balance]
    G --> H[Update Lot Quantities]
    H --> I[Generate Distribution Record]
    I --> J[Department Receives Drugs]
```

## 🗂️ Data Relationships

### Master Data Hierarchy
```
Company (Vendors/Manufacturers)
├── Drugs (Trade Names)
│   └── DrugGeneric (Generic Names)
├── Locations (Storage Areas)
│   └── Inventory (Stock per Location)
└── Departments (Hospital Units)
    └── Budget Allocations
```

### Transaction Flow
```
Purchase Request → Purchase Order → Receipt → Inventory Transaction
                     ↓
                Budget Reservation → Budget Commitment
```

## 🔐 Authorization Matrix

### Budget Operations
| Role | Create Budget | Approve Budget | Transfer Budget | Emergency Override |
|------|---------------|----------------|-----------------|-------------------|
| Department Head | ✓ | ❌ | ✓ (with approval) | ❌ |
| Finance Manager | ✓ | ✓ | ✓ | ❌ |
| Hospital Director | ✓ | ✓ | ✓ | ✓ |

### Procurement Operations
| Role | Create PR | Approve PR | Create PO | Approve PO | Receive Goods |
|------|-----------|------------|-----------|------------|---------------|
| Requestor | ✓ | ❌ | ❌ | ❌ | ❌ |
| Department Head | ✓ | ✓ | ❌ | ✓ | ✓ |
| Procurement Officer | ✓ | ✓ | ✓ | ❌ | ✓ |
| Finance Manager | ❌ | ✓ | ❌ | ✓ | ❌ |

### Inventory Operations
| Role | View Stock | Issue Drugs | Adjust Stock | Transfer Stock |
|------|------------|-------------|--------------|----------------|
| Staff | ✓ | ❌ | ❌ | ❌ |
| Pharmacist | ✓ | ✓ | ✓ | ✓ |
| Inventory Manager | ✓ | ✓ | ✓ | ✓ |

## 📊 Reporting Flows

### Daily Reports
- Low stock alerts (below reorder point)
- Expiring drugs (within 30 days)
- Budget utilization by department
- Pending approvals

### Monthly Reports
- Budget vs actual spending
- Inventory turnover analysis
- Vendor performance metrics
- Drug usage patterns

### Annual Reports
- Total budget utilization
- Inventory valuation
- Purchase order summary
- Cost savings analysis

## ⚠️ Exception Handling

### Budget Exceptions
- Emergency override for critical drugs
- Budget transfer between departments
- Post-facto budget adjustments
- Temporary budget increase procedures

### Inventory Exceptions
- Manual stock adjustments with justification
- Emergency drug dispensing
- Direct delivery to departments (bypass warehouse)
- Return processing for defective items

### System Exceptions
- Fallback to manual processes during downtime
- Data recovery procedures
- Manual override capabilities
- Backup approval workflows

## 🔄 Integration Points

### Internal Systems
- HIS (Hospital Information System)
- Financial System
- HR System (for user management)
- Laboratory System

### External Systems
- Vendor EDI systems
- Government reporting systems
- Drug regulatory databases
- Banking systems for payments

---

*This document provides a comprehensive overview of all business flows in the INVS Modern system.*