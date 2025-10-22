# INVS Modern - Business Rules & Logic

## 🏥 System Overview

The INVS Modern system manages hospital inventory with integrated budget control and procurement workflow. This document outlines the core business rules and logic.

## 💰 Budget Management Rules

### 1. Budget Allocation Structure
- **Fiscal Year**: January 1 - December 31
- **Quarterly Breakdown**: Q1-Q4 allocation required
- **Department-Based**: Each department has separate budget allocations
- **Type-Based**: Different budgets for drugs, equipment, supplies, etc.

### 2. Budget Control Logic
```
Total Budget = Q1 + Q2 + Q3 + Q4
Remaining Budget = Total Budget - Total Spent
Quarter Budget Available = Quarter Budget - Quarter Spent
```

### 3. Budget Validation Rules
- Purchase requests must not exceed available quarterly budget
- Budget reservations expire after 30 days if not converted to PO
- Budget transfers require approval from both departments
- Emergency budget can be used only with special authorization

### 4. Budget Status Types
- **ACTIVE**: Normal operation, purchases allowed
- **INACTIVE**: Budget suspended, no new purchases
- **LOCKED**: End of fiscal year, no modifications allowed

## 📦 Inventory Management Rules

### 1. Stock Level Management
```
Reorder Point = (Daily Usage × Lead Time) + Safety Stock
Safety Stock = Minimum Level
Maximum Level = Reorder Point + Economic Order Quantity
```

### 2. FIFO/FEFO Rules
- **FIFO**: First In, First Out for non-expirable items
- **FEFO**: First Expire, First Out for drugs with expiry dates
- Expiring lots (< 30 days) must be used first
- Expired lots are automatically quarantined

### 3. Inventory Transaction Types
- **RECEIVE**: Goods received from purchase orders
- **ISSUE**: Dispensing to departments/patients
- **TRANSFER**: Movement between locations
- **ADJUST**: Stock corrections (count differences)
- **RETURN**: Returns from departments

### 4. Location Hierarchy
- **WAREHOUSE**: Central storage, bulk quantities
- **PHARMACY**: Patient dispensing, unit quantities
- **WARD**: Department-specific storage
- **EMERGENCY**: Critical care immediate access

## 🛒 Procurement Workflow

### 1. Purchase Request Process
```
Draft → Submitted → Budget Check → Approved → Convert to PO
```

### 2. Purchase Request Rules
- All requests must have department authorization
- Budget availability check before approval
- Items must reference valid drug generics
- Estimated costs required for budget planning

### 3. Purchase Order Process
```
Draft → Pending → Approved → Sent → Received → Closed
```

### 4. Purchase Order Rules
- Must have valid vendor assignment
- Budget commitment occurs on approval
- Delivery dates must be realistic (vendor lead time)
- Partial receipts allowed with tracking

### 5. Goods Receipt Rules
- Must reference valid purchase order
- Quantities cannot exceed ordered amounts
- Lot numbers and expiry dates mandatory for drugs
- Quality checks before posting to inventory

## 🔒 Authorization Matrix

### Budget Operations
| Operation | Department Head | Finance Manager | Hospital Director |
|-----------|----------------|-----------------|-------------------|
| Budget Request | ✓ | ✓ | ✓ |
| Budget Approval | - | ✓ | ✓ |
| Budget Transfer | ✓ (Both Depts) | ✓ | ✓ |
| Emergency Budget | - | - | ✓ |

### Procurement Operations
| Operation | Requestor | Department Head | Procurement | Finance |
|-----------|-----------|----------------|-------------|---------|
| Create PR | ✓ | ✓ | ✓ | - |
| Approve PR | - | ✓ | ✓ | ✓ |
| Create PO | - | - | ✓ | - |
| Approve PO | - | ✓ | ✓ | ✓ |
| Receive Goods | ✓ | ✓ | ✓ | - |

### Inventory Operations
| Operation | Staff | Pharmacist | Inventory Manager |
|-----------|-------|------------|-------------------|
| View Stock | ✓ | ✓ | ✓ |
| Issue Drugs | - | ✓ | ✓ |
| Adjust Stock | - | ✓ | ✓ |
| Transfer Stock | - | ✓ | ✓ |

## 📊 Reporting Requirements

### Daily Reports
- Low stock items (below reorder point)
- Expiring items (within 30 days)
- Budget utilization by department
- Pending purchase requests

### Monthly Reports
- Budget vs actual spending
- Inventory turnover analysis
- Vendor performance metrics
- ABC analysis for drug usage

### Annual Reports
- Total budget utilization
- Inventory valuation
- Purchase order summary
- Cost savings analysis

## ⚠️ Alert System

### Critical Alerts (Immediate Action)
- Drug expiry within 7 days
- Negative inventory quantities
- Budget exceeded (over 100%)
- System errors in transactions

### Warning Alerts (Action Within 24h)
- Stock below minimum level
- Budget utilization over 80%
- Pending purchase requests > 5 days
- Unmatched receipts

### Information Alerts (Weekly Review)
- Slow-moving inventory
- Vendor delivery delays
- Seasonal demand patterns
- Cost variance analysis

## 🔄 Data Validation Rules

### Master Data
- Company codes must be unique and 6 digits
- Drug codes follow pattern: {GENERIC}-{MANUFACTURER}-{SEQUENCE}
- Working codes for generics: {DRUG}{NUMBER} (PAR0001)
- All monetary amounts must be positive

### Transactional Data
- Quantities cannot be negative (except adjustments)
- Dates cannot be in the future (except planning)
- All foreign key references must be valid
- Audit trail required for all changes

## 🚨 Exception Handling

### Budget Exceptions
- Emergency override for critical drugs
- Budget transfer for urgent requirements
- Temporary budget increase approval process
- Post-facto budget adjustments

### Inventory Exceptions
- Manual stock adjustments with justification
- Emergency drug dispensing without prescription
- Direct delivery to departments (bypass warehouse)
- Return processing for defective items

### System Exceptions
- Fallback to manual processes during downtime
- Data recovery procedures for corruption
- Backup approval workflows
- Manual override capabilities for administrators

## 📅 Periodic Processes

### Daily
- Calculate reorder requirements
- Process automated replenishment
- Update budget utilization
- Generate alert notifications

### Weekly
- Physical inventory spot checks
- Vendor performance review
- Budget variance analysis
- System health monitoring

### Monthly
- Full inventory reconciliation
- Budget reallocation if needed
- Vendor payment processing
- Performance metrics calculation

### Annually
- Complete physical inventory count
- Budget planning for next fiscal year
- System performance optimization
- Business rule review and updates

---

*These business rules ensure the INVS Modern system operates efficiently while maintaining proper controls and compliance with hospital policies.*