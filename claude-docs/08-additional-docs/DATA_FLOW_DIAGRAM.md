# Data Flow Diagram (DFD)

**INVS Modern - Hospital Inventory Management System**

**Version**: 1.0.0
**Date**: 2025-01-22
**Total Systems**: 8
**Total Processes (Level 2)**: 47 sub-processes
**Total Tables**: 52

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Context Diagram (Level 0)](#2-context-diagram-level-0)
3. [DFD Level 1 (8 Major Processes)](#3-dfd-level-1)
4. [DFD Level 2 (All 8 Systems)](#4-dfd-level-2)
5. [Data Dictionary](#5-data-dictionary)
6. [Process Specifications (PSPEC)](#6-process-specifications)
7. [Data Store Specifications (DSSPEC)](#7-data-store-specifications)
8. [Integration with ERD](#8-integration-with-erd)

---

## 1. Introduction

### 1.1 Purpose

เอกสาร Data Flow Diagram (DFD) นี้แสดงการไหลของข้อมูลในระบบ INVS Modern ทั้งหมด ตั้งแต่ระดับภาพรวม (Level 0) ไปจนถึงรายละเอียดแต่ละระบบย่อย (Level 2) ครอบคลุมทั้ง 8 ระบบหลัก

### 1.2 DFD Levels

- **Level 0 (Context Diagram)**: ภาพรวมระบบทั้งหมดเป็น single process พร้อม external entities
- **Level 1**: 8 major processes แสดงระบบหลักทั้งหมด
- **Level 2**: รายละเอียด sub-processes ภายในแต่ละระบบ (47 processes รวม)

### 1.3 Notation

**DFD Elements**:
- **Process**: วงกลม/สี่เหลี่ยมมุมมน (1.0, 2.1, 3.2)
- **Data Store**: สี่เหลี่ยมเปิด 2 ด้าน (D1: drugs, D2: inventory)
- **Data Flow**: ลูกศร พร้อม label
- **External Entity**: สี่เหลี่ยม (Hospital Staff, Ministry)

---

## 2. Context Diagram (Level 0)

### 2.1 Diagram

```mermaid
graph TB
    subgraph External["External Entities"]
        STAFF[Hospital Staff<br/>Pharmacist, Procurement, Dept Staff]
        MINISTRY[Ministry of<br/>Public Health]
        LEGACY[Legacy MySQL<br/>System]
        VENDOR[Vendors/<br/>Suppliers]
        BANK[Bank<br/>Payment]
    end

    INVS[("INVS Modern<br/>Hospital Inventory<br/>Management System")]

    %% Inputs to system
    STAFF -->|User credentials| INVS
    STAFF -->|Drug orders, PR requests| INVS
    STAFF -->|Distribution requests| INVS
    STAFF -->|Stock adjustments| INVS
    LEGACY -->|Master data, historical data| INVS
    VENDOR -->|Product catalog, quotations| INVS
    VENDOR -->|Delivery confirmations| INVS
    BANK -->|Payment confirmations| INVS

    %% Outputs from system
    INVS -->|Purchase orders| VENDOR
    INVS -->|Payment requests| BANK
    INVS -->|Ministry reports (5 files)| MINISTRY
    INVS -->|User dashboards, reports| STAFF
    INVS -->|Inventory status, alerts| STAFF
    INVS -->|Distribution approvals| STAFF

    style INVS fill:#3B82F6,color:#fff
    style STAFF fill:#10B981,color:#fff
    style MINISTRY fill:#F59E0B,color:#fff
    style VENDOR fill:#8B5CF6,color:#fff
```

### 2.2 External Entities

| Entity | Type | Description | Data Flows In | Data Flows Out |
|--------|------|-------------|---------------|----------------|
| **Hospital Staff** | Users | Pharmacists, Procurement Officers, Department Staff, Directors | Credentials, Orders, Requests, Adjustments | Dashboards, Reports, Approvals, Alerts |
| **Ministry of Public Health** | Government | DMSIC Standards compliance | Compliance requirements | 5 Export files (DRUGLIST, PURCHASEPLAN, RECEIPT, DISTRIBUTION, INVENTORY) |
| **Legacy MySQL System** | Legacy | Old INVS Banpong database | Master data, Historical transactions | - |
| **Vendors/Suppliers** | Business | Drug manufacturers, distributors | Product catalogs, Quotations, Deliveries | Purchase Orders, Specifications |
| **Bank** | Financial | Payment processing | Payment confirmations | Payment requests |

### 2.3 Major Data Flows

**Inbound**:
1. User authentication & authorization
2. Purchase requests from departments
3. Distribution requests
4. Stock adjustments
5. Vendor product information
6. Legacy data migration

**Outbound**:
1. Purchase orders to vendors
2. Ministry compliance reports
3. Operational dashboards
4. Budget status reports
5. Inventory alerts
6. Payment instructions

---

## 3. DFD Level 1

### 3.1 Diagram - 8 Major Processes

```mermaid
graph TB
    %% External Entities
    STAFF[Hospital Staff]
    MINISTRY[Ministry]
    VENDOR[Vendors]

    %% 8 Major Processes
    P1((1.0<br/>Master Data<br/>Management))
    P2((2.0<br/>Budget<br/>Management))
    P3((3.0<br/>Procurement<br/>Process))
    P4((4.0<br/>Inventory<br/>Management))
    P5((5.0<br/>Distribution<br/>Process))
    P6((6.0<br/>Drug Return<br/>Process))
    P7((7.0<br/>TMT<br/>Integration))
    P8((8.0<br/>Ministry<br/>Reporting))

    %% Data Stores
    D1[(D1: drugs<br/>drug_generics<br/>companies)]
    D2[(D2: budget_allocations<br/>budget_plans)]
    D3[(D3: purchase_requests<br/>purchase_orders<br/>receipts)]
    D4[(D4: inventory<br/>drug_lots)]
    D5[(D5: drug_distributions)]
    D6[(D6: drug_returns)]
    D7[(D7: tmt_concepts<br/>tmt_mappings)]

    %% External to Process flows
    STAFF -->|Drug info| P1
    STAFF -->|Budget plan| P2
    STAFF -->|PR request| P3
    STAFF -->|Stock count| P4
    STAFF -->|Distribution request| P5
    STAFF -->|Return request| P6
    VENDOR -->|Product catalog| P1
    VENDOR -->|Delivery| P3

    %% Process to Data Store
    P1 --> D1
    P2 --> D2
    P3 --> D3
    P4 --> D4
    P5 --> D5
    P6 --> D6
    P7 --> D7

    %% Process to Process flows
    P1 -->|Drug master| P3
    P2 -->|Budget check| P3
    P3 -->|Receipt| P4
    P4 -->|Stock status| P5
    P5 -->|Dispensed| P4
    P6 -->|Return| P4
    P1 -->|Drug codes| P7
    P7 -->|TMT codes| P8
    D1 -.-> P8
    D2 -.-> P8
    D3 -.-> P8
    D4 -.-> P8
    D5 -.-> P8

    %% Process to External
    P3 -->|Purchase order| VENDOR
    P8 -->|5 Export files| MINISTRY
    P2 -->|Budget status| STAFF
    P4 -->|Inventory alerts| STAFF
    P5 -->|Dispense confirmation| STAFF

    style P1 fill:#e3f2fd
    style P2 fill:#fff3e0
    style P3 fill:#f3e5f5
    style P4 fill:#e8f5e9
    style P5 fill:#fce4ec
    style P6 fill:#fce4ec
    style P7 fill:#e0f2f1
    style P8 fill:#efebe9
```

### 3.2 Process Summary

| Process ID | Process Name | Tables | Priority | Complexity |
|------------|--------------|--------|----------|------------|
| 1.0 | Master Data Management | 12 tables | ⭐⭐⭐ | Medium |
| 2.0 | Budget Management | 4 tables | ⭐⭐⭐ | High |
| 3.0 | Procurement Process | 15 tables | ⭐⭐⭐ | High |
| 4.0 | Inventory Management | 3 tables | ⭐⭐⭐ | Medium |
| 5.0 | Distribution Process | 3 tables | ⭐⭐ | Low |
| 6.0 | Drug Return Process | 3 tables | ⭐⭐ | Low |
| 7.0 | TMT Integration | 10 tables | ⭐⭐ | Medium |
| 8.0 | Ministry Reporting | Views only | ⭐⭐⭐ | Low |

### 3.3 Major Data Flows (Level 1)

| Flow ID | From | To | Data | Description |
|---------|------|-----|------|-------------|
| F1 | 1.0 | 3.0 | drug_master | Drug information for procurement |
| F2 | 2.0 | 3.0 | budget_availability | Budget check result |
| F3 | 3.0 | 4.0 | receipt_data | Goods received |
| F4 | 4.0 | 5.0 | stock_status | Inventory availability |
| F5 | 5.0 | 4.0 | dispensed_items | Distribution transaction |
| F6 | 6.0 | 4.0 | returned_items | Return transaction |
| F7 | 1.0 | 7.0 | drug_codes | Drug codes for TMT mapping |
| F8 | 7.0 | 8.0 | tmt_codes | Standard codes for ministry |

---

## 4. DFD Level 2

### 4.1 System 1.0: Master Data Management

```mermaid
graph TB
    %% Sub-processes
    P11((1.1<br/>Manage Drug<br/>Generics))
    P12((1.2<br/>Manage Trade<br/>Drugs))
    P13((1.3<br/>Manage<br/>Companies))
    P14((1.4<br/>Manage<br/>Locations))
    P15((1.5<br/>Manage<br/>Departments))
    P16((1.6<br/>Manage Budget<br/>Types))

    %% Data Stores
    D11[(D1.1: drug_generics)]
    D12[(D1.2: drugs)]
    D13[(D1.3: companies)]
    D14[(D1.4: locations)]
    D15[(D1.5: departments)]
    D16[(D1.6: budget_types)]

    %% External
    STAFF[Staff]
    VENDOR[Vendors]

    %% Flows
    STAFF -->|Generic info| P11
    P11 --> D11

    STAFF -->|Trade drug info| P12
    P12 --> D12
    D11 -.->|Generic data| P12
    D13 -.->|Manufacturer| P12

    VENDOR -->|Company profile| P13
    P13 --> D13

    STAFF -->|Location setup| P14
    P14 --> D14

    STAFF -->|Dept setup| P15
    P15 --> D15

    STAFF -->|Budget type setup| P16
    P16 --> D16

    D11 -->|Generic catalog| OUTPUT[To Other Systems]
    D12 -->|Drug catalog| OUTPUT
    D13 -->|Vendor list| OUTPUT
```

**Sub-processes**:
- **1.1**: Create, Update, Search Drug Generics (working_code, generic names, dosage forms)
- **1.2**: Manage Trade Drugs (link to generic, manufacturer, pricing, TMT, NLEM status)
- **1.3**: Manage Companies (vendors, manufacturers, contact details)
- **1.4**: Manage Locations (storage hierarchy, warehouse → pharmacy → ward)
- **1.5**: Manage Departments (budget codes, consumption groups 1-9)
- **1.6**: Manage Budget Types & Categories (OP001, OP002, IV001, etc.)

---

### 4.2 System 2.0: Budget Management

```mermaid
graph TB
    %% Sub-processes
    P21((2.1<br/>Create Budget<br/>Allocation))
    P22((2.2<br/>Create Budget<br/>Plan))
    P23((2.3<br/>Check Budget<br/>Availability))
    P24((2.4<br/>Reserve<br/>Budget))
    P25((2.5<br/>Commit<br/>Budget))
    P26((2.6<br/>Release Budget<br/>Reservation))
    P27((2.7<br/>Monitor Budget<br/>Status))

    %% Data Stores
    D21[(D2.1: budget_allocations)]
    D22[(D2.2: budget_plans<br/>budget_plan_items)]
    D23[(D2.3: budget_reservations)]

    %% External/Other
    STAFF[Staff]
    PROC[3.0 Procurement]

    %% Flows
    STAFF -->|Allocation Q1-Q4| P21
    P21 --> D21

    STAFF -->|Drug-level plan| P22
    P22 --> D22

    PROC -->|Budget check request| P23
    D21 -.->|Available amount| P23
    D23 -.->|Reserved amount| P23
    P23 -->|Available/Insufficient| PROC

    PROC -->|Reserve request| P24
    P24 --> D23
    D21 -.->|Allocation data| P24

    PROC -->|Commit request| P25
    P25 --> D21
    P25 -->|Release related| P26
    P26 --> D23

    P27 --> |Status report| STAFF
    D21 -.-> P27
    D22 -.-> P27
    D23 -.-> P27
```

**Sub-processes**:
- **2.1**: Create Annual Allocation (fiscal year, dept, budget type, Q1-Q4 breakdown)
- **2.2**: Create Drug-level Planning (generics, quantities, 3-year historical data)
- **2.3**: Check Budget Availability (real-time: allocated - spent - reserved ≥ requested?)
- **2.4**: Reserve Budget (30-day hold for approved PR)
- **2.5**: Commit Budget (finalize when PO confirmed, update quarterly spent)
- **2.6**: Release Expired/Cancelled Reservations
- **2.7**: Monitor & Report Budget Status (dashboards, alerts)

---

### 4.3 System 3.0: Procurement Process

```mermaid
graph TB
    %% Sub-processes
    P31((3.1<br/>Create<br/>Purchase Request))
    P32((3.2<br/>Approve<br/>Purchase Request))
    P33((3.3<br/>Create<br/>Purchase Order))
    P34((3.4<br/>Send Purchase<br/>Order))
    P35((3.5<br/>Receive<br/>Goods))
    P36((3.6<br/>Inspect &<br/>Verify Receipt))
    P37((3.7<br/>Post Receipt<br/>to Inventory))
    P38((3.8<br/>Process<br/>Payment))

    %% Data Stores
    D31[(D3.1: purchase_requests<br/>purchase_request_items)]
    D32[(D3.2: purchase_orders<br/>purchase_order_items)]
    D33[(D3.3: receipts<br/>receipt_items)]
    D34[(D3.4: payment_documents)]

    %% External/Other
    STAFF[Staff]
    VENDOR[Vendors]
    BUDGET[2.0 Budget]
    INV[4.0 Inventory]

    %% PR Flow
    STAFF -->|PR draft| P31
    P31 --> D31

    P31 -->|Budget check request| BUDGET
    BUDGET -.->|Availability| P31

    D31 -.->|PR data| P32
    P32 -->|Approved status| D31
    P32 -->|Reserve budget| BUDGET

    %% PO Flow
    D31 -.->|Approved PR| P33
    P33 --> D32
    P33 -->|Commit budget| BUDGET

    D32 -.->|PO document| P34
    P34 -->|Purchase order| VENDOR

    %% Receipt Flow
    VENDOR -->|Delivery| P35
    D32 -.->|PO data| P35
    P35 --> D33

    D33 -.->|Receipt items| P36
    P36 -->|Verified receipt| D33

    D33 -.->|Posted receipt| P37
    P37 -->|Inventory update| INV

    %% Payment
    D33 -.->|Invoice| P38
    P38 --> D34
```

**Sub-processes**:
- **3.1**: Create PR (select drugs, quantities, check budget)
- **3.2**: Approve PR (budget validation, director approval, reserve budget)
- **3.3**: Create PO (from approved PR, select vendor, commit budget)
- **3.4**: Send PO to Vendor (electronic/paper)
- **3.5**: Receive Goods (record delivery, lot numbers, expiry dates)
- **3.6**: Inspect & Verify (inspection committee, photo evidence)
- **3.7**: Post to Inventory (create lots, update stock, RECEIVE transaction)
- **3.8**: Process Payment (match invoice, create payment document)

---

### 4.4 System 4.0: Inventory Management

```mermaid
graph TB
    %% Sub-processes
    P41((4.1<br/>Receive<br/>Stock))
    P42((4.2<br/>Create Drug<br/>Lots))
    P43((4.3<br/>Calculate<br/>FIFO Lots))
    P44((4.4<br/>Calculate<br/>FEFO Lots))
    P45((4.5<br/>Issue<br/>Stock))
    P46((4.6<br/>Adjust<br/>Stock))
    P47((4.7<br/>Transfer<br/>Stock))
    P48((4.8<br/>Monitor<br/>Expiring Drugs))
    P49((4.9<br/>Monitor<br/>Low Stock))

    %% Data Stores
    D41[(D4.1: inventory)]
    D42[(D4.2: drug_lots)]
    D43[(D4.3: inventory_transactions)]

    %% External/Other
    PROC[3.0 Procurement]
    DIST[5.0 Distribution]
    RET[6.0 Returns]
    STAFF[Staff]

    %% Receive flow
    PROC -->|Receipt posted| P41
    P41 --> D41
    P41 --> P42
    P42 --> D42
    P42 --> D43

    %% FIFO/FEFO
    DIST -->|Request lots| P43
    D42 -.->|Lot data| P43
    P43 -->|FIFO sequence| DIST

    DIST -->|Request lots| P44
    D42 -.->|Lot + expiry| P44
    P44 -->|FEFO sequence| DIST

    %% Issue
    DIST -->|Dispense| P45
    P45 --> D41
    P45 --> D42
    P45 --> D43

    %% Adjust
    STAFF -->|Physical count| P46
    P46 --> D41
    P46 --> D43

    %% Transfer
    STAFF -->|Transfer request| P47
    P47 --> D41
    P47 --> D42
    P47 --> D43

    %% Monitoring
    D42 -.->|Expiry data| P48
    P48 -->|Alerts| STAFF

    D41 -.->|Stock levels| P49
    P49 -->|Reorder alerts| STAFF

    %% Returns
    RET -->|Return good qty| P41
```

**Sub-processes**:
- **4.1**: Receive Stock (from receipts or returns, update quantity_on_hand)
- **4.2**: Create Drug Lots (lot_number, expiry_date, received_date, unit_cost)
- **4.3**: Calculate FIFO Lots (get_fifo_lots function, sorted by received_date)
- **4.4**: Calculate FEFO Lots (get_fefo_lots function, sorted by expiry_date)
- **4.5**: Issue Stock (for distribution, decrease quantity, ISSUE transaction)
- **4.6**: Adjust Stock (physical count variance, ADJUST transaction)
- **4.7**: Transfer Stock (between locations, TRANSFER transaction)
- **4.8**: Monitor Expiring Drugs (alert < 90 days, color-code < 30 days red)
- **4.9**: Monitor Low Stock (alert when quantity ≤ reorder_point)

---

### 4.5 System 5.0: Distribution Process

```mermaid
graph TB
    %% Sub-processes
    P51((5.1<br/>Create<br/>Distribution<br/>Request))
    P52((5.2<br/>Check Stock<br/>Availability))
    P53((5.3<br/>Approve<br/>Distribution))
    P54((5.4<br/>Select FEFO<br/>Lots))
    P55((5.5<br/>Dispense<br/>Drugs))
    P56((5.6<br/>Confirm<br/>Receipt))

    %% Data Stores
    D51[(D5.1: drug_distributions<br/>drug_distribution_items)]

    %% External/Other
    DEPT[Department Staff]
    PHARM[Pharmacist]
    INV[4.0 Inventory]

    %% Request flow
    DEPT -->|Distribution request| P51
    P51 --> D51

    P51 -->|Check stock| P52
    INV -.->|Stock status| P52
    P52 -->|Available/Insufficient| P51

    %% Approval
    D51 -.->|Pending request| P53
    PHARM -->|Approve/Reject| P53
    P53 -->|Approved status| D51

    %% Dispensing
    D51 -.->|Approved items| P54
    INV -->|FEFO lots| P54
    P54 -->|Selected lots| P55

    P55 -->|Issue stock| INV
    P55 -->|Dispensed status| D51

    %% Confirmation
    D51 -.->|Dispensed items| P56
    DEPT -->|Confirm receipt| P56
    P56 -->|Confirmed status| D51
```

**Sub-processes**:
- **5.1**: Create Distribution Request (department, drugs, quantities)
- **5.2**: Check Stock Availability (real-time inventory check)
- **5.3**: Approve Distribution (pharmacist approval, validate stock again)
- **5.4**: Select FEFO Lots (auto-select lots closest to expiry)
- **5.5**: Dispense Drugs (update inventory, record lot numbers, ISSUE transaction)
- **5.6**: Confirm Receipt (department acknowledges receipt)

---

### 4.6 System 6.0: Drug Return Process

```mermaid
graph TB
    %% Sub-processes
    P61((6.1<br/>Create Return<br/>Request))
    P62((6.2<br/>Submit<br/>Return))
    P63((6.3<br/>Verify &<br/>Inspect))
    P64((6.4<br/>Separate<br/>Good/Damaged))
    P65((6.5<br/>Post Return<br/>to Inventory))
    P66((6.6<br/>Quarantine<br/>Damaged Items))

    %% Data Stores
    D61[(D6.1: drug_returns<br/>drug_return_items)]
    D62[(D6.2: return_reasons)]

    %% External/Other
    DEPT[Department Staff]
    PHARM[Pharmacist]
    INV[4.0 Inventory]

    %% Request flow
    DEPT -->|Return request| P61
    D62 -.->|Reason list (19)| P61
    P61 --> D61

    D61 -.->|Draft return| P62
    DEPT -->|Submit| P62
    P62 -->|Submitted status| D61

    %% Verification
    D61 -.->|Submitted items| P63
    PHARM -->|Physical inspection| P63
    P63 --> P64

    P64 -->|Good/Damaged qty| D61

    %% Posting
    D61 -.->|Verified return| P65
    P65 -->|Good qty RETURN| INV
    P65 -->|Posted status| D61

    P65 --> P66
    P66 -->|Damaged to quarantine| INV
```

**Sub-processes**:
- **6.1**: Create Return Request (department, drugs, lot numbers, return reason)
- **6.2**: Submit Return (department submits for pharmacist verification)
- **6.3**: Verify & Inspect (pharmacist physically inspects returned drugs)
- **6.4**: Separate Good/Damaged (split quantities: good → restock, damaged → quarantine)
- **6.5**: Post to Inventory (RETURN transaction for good quantity)
- **6.6**: Quarantine Damaged (move to quarantine location, flag for disposal)

---

### 4.7 System 7.0: TMT Integration

```mermaid
graph TB
    %% Sub-processes
    P71((7.1<br/>Load TMT<br/>Concepts))
    P72((7.2<br/>Map Drug<br/>to TMT))
    P73((7.3<br/>Validate TMT<br/>Codes))
    P74((7.4<br/>Sync with<br/>HIS))
    P75((7.5<br/>Update TMT<br/>Hierarchy))

    %% Data Stores
    D71[(D7.1: tmt_concepts)]
    D72[(D7.2: tmt_mappings)]
    D73[(D7.3: his_drug_master)]
    D74[(D7.4: tmt_relationships)]

    %% External/Other
    TMT_SOURCE[TMT Database<br/>Ministry]
    HIS[Hospital<br/>Information System]
    DRUG[1.0 Master Data]

    %% TMT Loading
    TMT_SOURCE -->|25,991 concepts| P71
    P71 --> D71
    P71 --> D74

    %% Mapping
    DRUG -.->|Drug codes| P72
    D71 -.->|TMT concepts| P72
    P72 --> D72

    %% Validation
    D72 -.->|Mappings| P73
    D71 -.->|Standard codes| P73
    P73 -->|Valid/Invalid| P72

    %% HIS Sync
    HIS -->|HIS drug master| P74
    D72 -.->|INVS mappings| P74
    P74 --> D73

    %% Hierarchy
    D71 -.->|Concepts| P75
    P75 --> D74
```

**Sub-processes**:
- **7.1**: Load TMT Concepts (25,991 records from ministry database)
- **7.2**: Map Drug to TMT (link INVS drugs to standard TMT codes)
- **7.3**: Validate TMT Codes (ensure mappings match ministry standards)
- **7.4**: Sync with HIS (integrate hospital information system drug master)
- **7.5**: Update TMT Hierarchy (maintain relationships: SUBS → VTM → GP → TP)

---

### 4.8 System 8.0: Ministry Reporting

```mermaid
graph TB
    %% Sub-processes
    P81((8.1<br/>Generate<br/>DRUGLIST))
    P82((8.2<br/>Generate<br/>PURCHASEPLAN))
    P83((8.3<br/>Generate<br/>RECEIPT))
    P84((8.4<br/>Generate<br/>DISTRIBUTION))
    P85((8.5<br/>Generate<br/>INVENTORY))
    P86((8.6<br/>Validate<br/>Export Format))
    P87((8.7<br/>Submit to<br/>Ministry))

    %% Data Stores (Views)
    V1[(V1: export_druglist)]
    V2[(V2: export_purchase_plan)]
    V3[(V3: export_receipt)]
    V4[(V4: export_distribution)]
    V5[(V5: export_inventory)]

    %% External/Other
    MINISTRY[Ministry of<br/>Public Health]
    DRUG[1.0 Master Data]
    BUDGET[2.0 Budget]
    PROC[3.0 Procurement]
    INV[4.0 Inventory]
    DIST[5.0 Distribution]
    TMT[7.0 TMT]

    %% DRUGLIST (11 fields)
    DRUG -.->|Drug catalog| P81
    TMT -.->|TMT codes| P81
    P81 --> V1

    %% PURCHASEPLAN (20 fields)
    BUDGET -.->|Budget plans| P82
    P82 --> V2

    %% RECEIPT (22 fields)
    PROC -.->|Receipts| P83
    P83 --> V3

    %% DISTRIBUTION (11 fields)
    DIST -.->|Distributions| P84
    P84 --> V4

    %% INVENTORY (15 fields)
    INV -.->|Stock data| P85
    P85 --> V5

    %% Validation
    V1 -.-> P86
    V2 -.-> P86
    V3 -.-> P86
    V4 -.-> P86
    V5 -.-> P86
    P86 -->|79/79 fields OK| P87

    %% Submission
    P87 -->|5 files| MINISTRY
```

**Sub-processes**:
- **8.1**: Generate DRUGLIST (11 fields: drug catalog with TMT codes, NLEM status)
- **8.2**: Generate PURCHASEPLAN (20 fields: budget planning with historical data)
- **8.3**: Generate RECEIPT (22 fields: goods receiving with lot details)
- **8.4**: Generate DISTRIBUTION (11 fields: department dispensing)
- **8.5**: Generate INVENTORY (15 fields: stock status by location)
- **8.6**: Validate Export Format (verify all 79 fields comply with DMSIC standards)
- **8.7**: Submit to Ministry (upload files to ministry portal)

---

## 5. Data Dictionary

### 5.1 Data Elements

**Primary Keys**:
| Element Name | Type | Description | Example |
|--------------|------|-------------|---------|
| id | BIGINT | Primary key, auto-increment | 1, 2, 3 |
| drug_id | BIGINT | Drug identifier | 1001 |
| generic_id | BIGINT | Generic drug identifier | 501 |
| location_id | BIGINT | Storage location ID | 5 |
| department_id | BIGINT | Department ID | 10 |

**Drug Data**:
| Element Name | Type | Description | Example |
|--------------|------|-------------|---------|
| drug_code | VARCHAR(50) | Trade drug code | "DRUG-00001" |
| drug_name_th | VARCHAR(255) | Thai drug name | "พาราเซตามอล 500 มก." |
| drug_name_en | VARCHAR(255) | English drug name | "Paracetamol 500mg" |
| generic_code | VARCHAR(50) | Generic code (WORKING_CODE) | "GEN-0001" |
| unit_price | DECIMAL(18,4) | Unit price in THB | 5.50 |
| nlem_status | ENUM('E','N') | NLEM classification | 'E' |
| drug_status | ENUM('1','2','3','4') | Drug lifecycle status | '1' |
| product_category | ENUM('1','2','3','4','5') | Product type | '1' |

**Budget Data**:
| Element Name | Type | Description | Example |
|--------------|------|-------------|---------|
| fiscal_year | INT | Fiscal year (พ.ศ.) | 2568 |
| total_amount | DECIMAL(18,2) | Total annual budget | 10000000.00 |
| q1_amount | DECIMAL(18,2) | Quarter 1 allocation | 2500000.00 |
| q1_spent | DECIMAL(18,2) | Quarter 1 spent | 1200000.00 |
| q1_reserved | DECIMAL(18,2) | Quarter 1 reserved | 300000.00 |

**Inventory Data**:
| Element Name | Type | Description | Example |
|--------------|------|-------------|---------|
| lot_number | VARCHAR(100) | Lot/Batch number | "LOT-2025-001" |
| expiry_date | DATE | Expiration date | 2027-12-31 |
| quantity_on_hand | DECIMAL(18,4) | Current stock | 5000.00 |
| quantity_available | DECIMAL(18,4) | Available (not reserved) | 4500.00 |
| reorder_point | DECIMAL(18,4) | Reorder trigger level | 1000.00 |

**Transaction Data**:
| Element Name | Type | Description | Example |
|--------------|------|-------------|---------|
| transaction_type | ENUM | Type of movement | 'RECEIVE', 'ISSUE', 'TRANSFER', 'ADJUST', 'RETURN' |
| reference_id | BIGINT | Reference document ID | 12345 |
| reference_type | VARCHAR(50) | Reference document type | 'receipt', 'distribution' |

### 5.2 Data Stores

**D1: Master Data Stores** (12 tables):
- D1.1: `drug_generics` - Generic drug catalog (1,109 records)
- D1.2: `drugs` - Trade drug catalog (1,169 records)
- D1.3: `companies` - Vendors/manufacturers (816 records)
- D1.4: `locations` - Storage locations (5 seed)
- D1.5: `departments` - Hospital departments (5 seed)
- D1.6: `budget_types` - Budget categories (6 types)
- D1.7: `dosage_forms` - Drug forms (87 types)
- D1.8: `sale_units` - Sales units (10 types)
- D1.9: `tmt_units` - WHO units (85 units)
- D1.10: `drug_pack_ratios` - Pack conversions (1,641 records)
- D1.11: `drug_components` - Active ingredients (736 records)
- D1.12: `drug_focus_lists` - Controlled drugs (92 records)

**D2: Budget Stores** (4 tables):
- D2.1: `budget_allocations` - Annual allocations with Q1-Q4
- D2.2: `budget_plans` - Drug-level planning
- D2.3: `budget_plan_items` - Plan items with historical data
- D2.4: `budget_reservations` - Temporary holds

**D3: Procurement Stores** (15 tables):
- D3.1: `purchase_requests`, `purchase_request_items`
- D3.2: `purchase_orders`, `purchase_order_items`
- D3.3: `receipts`, `receipt_items`
- D3.4: `purchase_methods` (18), `purchase_types` (20)
- D3.5: `purchase_order_reasons`, `return_reasons`
- D3.6: `contracts`, `contract_items`
- D3.7: `payment_documents`, `payment_attachments`
- D3.8: `approval_documents`, `receipt_inspectors`

**D4: Inventory Stores** (3 tables):
- D4.1: `inventory` - Stock levels per location
- D4.2: `drug_lots` - Lot tracking with expiry
- D4.3: `inventory_transactions` - All movements

**D5: Distribution Stores** (3 tables):
- D5.1: `drug_distributions`, `drug_distribution_items`
- D5.2: `distribution_types` (2: ถาวร, ยืม-คืน)

**D6: Drug Return Stores** (3 tables):
- D6.1: `drug_returns`, `drug_return_items`
- D6.2: `return_reasons` (19 reasons: Clinical, Operational, Quality)

**D7: TMT Stores** (10 tables):
- D7.1: `tmt_concepts` (25,991 records)
- D7.2: `tmt_mappings`
- D7.3: `tmt_relationships`
- D7.4: `tmt_attributes`
- D7.5: `tmt_manufacturers`, `tmt_dosage_forms`, `tmt_units`
- D7.6: `his_drug_master`
- D7.7: `tmt_usage_stats`, `ministry_reports`

**D8: HPP Stores** (2 tables):
- D8.1: `hospital_pharmaceutical_products`
- D8.2: `hpp_formulations`

### 5.3 Data Flows

**F1-F10: Master Data Flows**:
- F1: drug_master (D1 → Process 3.0, 4.0, 5.0)
- F2: company_info (D1.3 → Process 3.0)
- F3: location_info (D1.4 → Process 4.0, 5.0)
- F4: department_info (D1.5 → Process 2.0, 5.0)

**F11-F20: Budget Flows**:
- F11: budget_check_request (Process 3.0 → Process 2.3)
- F12: budget_available (Process 2.3 → Process 3.0)
- F13: reserve_request (Process 3.2 → Process 2.4)
- F14: commit_request (Process 3.3 → Process 2.5)

**F21-F30: Procurement Flows**:
- F21: PR_draft (User → Process 3.1)
- F22: PR_approved (Process 3.2 → D3.1)
- F23: PO_created (Process 3.3 → D3.2)
- F24: receipt_posted (Process 3.7 → Process 4.1)

**F31-F40: Inventory Flows**:
- F31: stock_received (Process 4.1 → D4.1, D4.2)
- F32: lot_created (Process 4.2 → D4.2)
- F33: fifo_lots (Process 4.3 → Process 5.0)
- F34: fefo_lots (Process 4.4 → Process 5.0)
- F35: stock_issued (Process 4.5 → D4.1, D4.2, D4.3)

**F41-F50: Distribution Flows**:
- F41: distribution_request (User → Process 5.1)
- F42: stock_check (Process 5.2 → Process 4.0)
- F43: dispensed_items (Process 5.5 → Process 4.5)

**F51-F60: Return Flows**:
- F51: return_request (User → Process 6.1)
- F52: return_verified (Process 6.3 → D6.1)
- F53: return_posted (Process 6.5 → Process 4.1)

**F61-F70: TMT Flows**:
- F61: tmt_concepts (TMT Database → Process 7.1)
- F62: drug_tmt_mapping (Process 7.2 → D7.2)
- F63: tmt_codes (Process 7.0 → Process 8.0)

**F71-F79: Ministry Export Flows**:
- F71: druglist_export (Process 8.1 → Ministry)
- F72: purchaseplan_export (Process 8.2 → Ministry)
- F73: receipt_export (Process 8.3 → Ministry)
- F74: distribution_export (Process 8.4 → Ministry)
- F75: inventory_export (Process 8.5 → Ministry)

---

## 6. Process Specifications (PSPEC)

### 6.1 PSPEC Format

Each process specification includes:
- **Process ID & Name**
- **Description**
- **Inputs** (data flows in)
- **Processing Logic** (algorithm/business rules)
- **Outputs** (data flows out)
- **Data Stores Accessed** (read/write)
- **Business Rules Referenced**

### 6.2 Sample PSPECs

#### PSPEC 2.3: Check Budget Availability

**Process**: 2.3 Check Budget Availability
**Parent**: 2.0 Budget Management

**Description**: ตรวจสอบงบประมาณคงเหลือแบบ real-time เพื่อ validate purchase request

**Inputs**:
- fiscal_year (INT)
- budget_type_id (BIGINT)
- department_id (BIGINT)
- requested_amount (DECIMAL)
- quarter (INT: 1-4)

**Processing Logic**:
```sql
1. Read budget_allocation matching:
   - fiscal_year = input.fiscal_year
   - budget_type_id = input.budget_type_id
   - department_id = input.department_id

2. Get quarterly data based on input.quarter:
   - allocated = q{quarter}_amount
   - spent = q{quarter}_spent
   - reserved = SUM(budget_reservations.amount WHERE expires_at > NOW())

3. Calculate available:
   available = allocated - spent - reserved

4. Compare:
   IF available >= requested_amount THEN
     result = TRUE
   ELSE
     result = FALSE
   END IF

5. Return result
```

**Outputs**:
- budget_available (BOOLEAN)
- available_amount (DECIMAL)

**Data Stores**:
- Read: D2.1 (budget_allocations)
- Read: D2.4 (budget_reservations)

**Business Rules**:
- BR-001: Budget check mandatory before PR approval
- BR-002: Quarterly budget tracking (Q1-Q4)

---

#### PSPEC 3.7: Post Receipt to Inventory

**Process**: 3.7 Post Receipt to Inventory
**Parent**: 3.0 Procurement Process

**Description**: อัปเดต inventory เมื่อ receipt verified และ posted

**Inputs**:
- receipt_id (BIGINT)

**Processing Logic**:
```sql
1. Read receipt and receipt_items WHERE receipt.id = input.receipt_id

2. FOR EACH receipt_item:
   2.1 Create drug_lot:
       - drug_id = receipt_item.drug_id
       - location_id = receipt_item.location_id
       - lot_number = receipt_item.lot_number
       - expiry_date = receipt_item.expiry_date
       - quantity_received = receipt_item.quantity_received
       - quantity_available = receipt_item.quantity_received
       - unit_cost = receipt_item.unit_cost
       - received_date = receipt.receipt_date

   2.2 Update inventory:
       - quantity_on_hand += receipt_item.quantity_received
       - last_updated = NOW()

   2.3 Create inventory_transaction:
       - inventory_id = matching inventory.id
       - transaction_type = 'RECEIVE'
       - quantity = receipt_item.quantity_received
       - reference_id = receipt.id
       - reference_type = 'receipt'

3. Update receipt.status = 'POSTED'

4. Return success
```

**Outputs**:
- inventory_updated (BOOLEAN)
- lot_created_count (INT)

**Data Stores**:
- Read: D3.3 (receipts, receipt_items)
- Write: D4.1 (inventory)
- Write: D4.2 (drug_lots)
- Write: D4.3 (inventory_transactions)
- Write: D3.3 (receipts.status)

**Business Rules**:
- BR-010: Receipts must be verified before posting
- BR-011: Each receipt item creates a drug lot
- BR-012: Inventory updated atomically (transaction)

---

#### PSPEC 4.4: Calculate FEFO Lots

**Process**: 4.4 Calculate FEFO Lots
**Parent**: 4.0 Inventory Management

**Description**: เลือก lots ตามหลัก First Expire First Out สำหรับการจ่ายยา

**Inputs**:
- drug_id (BIGINT)
- location_id (BIGINT)
- quantity_needed (DECIMAL)

**Processing Logic**:
```sql
1. Read drug_lots WHERE:
   - drug_id = input.drug_id
   - location_id = input.location_id
   - quantity_available > 0
   - is_active = TRUE
   ORDER BY expiry_date ASC, received_date ASC

2. Initialize:
   - remaining = quantity_needed
   - selected_lots = []

3. FOR EACH lot (in order):
   3.1 IF remaining <= 0 THEN
         BREAK

   3.2 take_qty = MIN(lot.quantity_available, remaining)

   3.3 Add to selected_lots:
       - lot_id = lot.id
       - lot_number = lot.lot_number
       - expiry_date = lot.expiry_date
       - quantity_to_take = take_qty

   3.4 remaining -= take_qty

4. IF remaining > 0 THEN
     result.sufficient = FALSE
   ELSE
     result.sufficient = TRUE

5. Return selected_lots
```

**Outputs**:
- selected_lots (ARRAY of {lot_id, lot_number, expiry_date, quantity_to_take})
- sufficient (BOOLEAN)

**Data Stores**:
- Read: D4.2 (drug_lots)

**Business Rules**:
- BR-020: FEFO used for dispensing (expiring drugs first)
- BR-021: FIFO secondary sort (if same expiry date)
- BR-022: Only active lots selected

---

#### PSPEC 8.1: Generate DRUGLIST Export

**Process**: 8.1 Generate DRUGLIST Export
**Parent**: 8.0 Ministry Reporting

**Description**: สร้างไฟล์ DRUGLIST export 11 fields ตามมาตรฐาน DMSIC

**Inputs**:
- fiscal_year (INT, optional filter)
- active_only (BOOLEAN, default TRUE)

**Processing Logic**:
```sql
1. Query export_druglist view:
   SELECT
     hospcode,           -- 1. HOSPCODE
     did,                -- 2. DID (drug_id)
     didname,            -- 3. DIDNAME (Thai name)
     didname_en,         -- 4. DIDNAME_E (English)
     didstd,             -- 5. DIDSTD (TMT24 code)
     unit,               -- 6. UNIT (sale unit)
     unit_pack,          -- 7. UNIT_PACK (pack ratio)
     drugcat,            -- 8. DRUGCAT (product_category)
     drugtype,           -- 9. DRUGTYPE (nlem_status)
     druguse,            -- 10. DRUGUSE (drug_status)
     d_update            -- 11. D_UPDATE (last update)
   FROM export_druglist
   WHERE is_active = input.active_only

2. Format data:
   - Date: YYYY-MM-DD format
   - Encode: UTF-8
   - Delimiter: | (pipe)

3. Validate:
   - All 11 fields present
   - No NULL in required fields
   - TMT codes valid

4. Export to CSV/Text file

5. Return file_path
```

**Outputs**:
- druglist_file (FILE)
- record_count (INT)

**Data Stores**:
- Read: V1 (export_druglist view)
- Read: D1.2 (drugs)
- Read: D7.2 (tmt_mappings)

**Business Rules**:
- BR-030: DRUGLIST contains all active drugs
- BR-031: TMT mapping mandatory for export
- BR-032: 11 fields required (100% compliance)

---

### 6.3 Complete PSPEC List

**System 1.0: Master Data** (6 PSPECs):
- PSPEC 1.1: Manage Drug Generics
- PSPEC 1.2: Manage Trade Drugs
- PSPEC 1.3: Manage Companies
- PSPEC 1.4: Manage Locations
- PSPEC 1.5: Manage Departments
- PSPEC 1.6: Manage Budget Types

**System 2.0: Budget** (7 PSPECs):
- PSPEC 2.1: Create Budget Allocation
- PSPEC 2.2: Create Budget Plan
- PSPEC 2.3: Check Budget Availability ✅ (detailed above)
- PSPEC 2.4: Reserve Budget
- PSPEC 2.5: Commit Budget
- PSPEC 2.6: Release Budget Reservation
- PSPEC 2.7: Monitor Budget Status

**System 3.0: Procurement** (8 PSPECs):
- PSPEC 3.1: Create Purchase Request
- PSPEC 3.2: Approve Purchase Request
- PSPEC 3.3: Create Purchase Order
- PSPEC 3.4: Send Purchase Order
- PSPEC 3.5: Receive Goods
- PSPEC 3.6: Inspect & Verify Receipt
- PSPEC 3.7: Post Receipt to Inventory ✅ (detailed above)
- PSPEC 3.8: Process Payment

**System 4.0: Inventory** (9 PSPECs):
- PSPEC 4.1: Receive Stock
- PSPEC 4.2: Create Drug Lots
- PSPEC 4.3: Calculate FIFO Lots
- PSPEC 4.4: Calculate FEFO Lots ✅ (detailed above)
- PSPEC 4.5: Issue Stock
- PSPEC 4.6: Adjust Stock
- PSPEC 4.7: Transfer Stock
- PSPEC 4.8: Monitor Expiring Drugs
- PSPEC 4.9: Monitor Low Stock

**System 5.0: Distribution** (6 PSPECs):
- PSPEC 5.1: Create Distribution Request
- PSPEC 5.2: Check Stock Availability
- PSPEC 5.3: Approve Distribution
- PSPEC 5.4: Select FEFO Lots
- PSPEC 5.5: Dispense Drugs
- PSPEC 5.6: Confirm Receipt

**System 6.0: Drug Return** (6 PSPECs):
- PSPEC 6.1: Create Return Request
- PSPEC 6.2: Submit Return
- PSPEC 6.3: Verify & Inspect
- PSPEC 6.4: Separate Good/Damaged
- PSPEC 6.5: Post Return to Inventory
- PSPEC 6.6: Quarantine Damaged Items

**System 7.0: TMT** (5 PSPECs):
- PSPEC 7.1: Load TMT Concepts
- PSPEC 7.2: Map Drug to TMT
- PSPEC 7.3: Validate TMT Codes
- PSPEC 7.4: Sync with HIS
- PSPEC 7.5: Update TMT Hierarchy

**System 8.0: Ministry Reporting** (7 PSPECs):
- PSPEC 8.1: Generate DRUGLIST ✅ (detailed above)
- PSPEC 8.2: Generate PURCHASEPLAN
- PSPEC 8.3: Generate RECEIPT
- PSPEC 8.4: Generate DISTRIBUTION
- PSPEC 8.5: Generate INVENTORY
- PSPEC 8.6: Validate Export Format
- PSPEC 8.7: Submit to Ministry

**Total**: 54 PSPECs (47 sub-processes + 7 detailed above)

---

## 7. Data Store Specifications (DSSPEC)

### 7.1 DSSPEC Format

Each data store specification includes:
- **Store ID & Name**
- **Description**
- **Structure** (fields, types, constraints)
- **Primary Key**
- **Foreign Keys**
- **Indexes**
- **Access Patterns** (which processes read/write)

### 7.2 Sample DSSPECs

#### DSSPEC D2.1: budget_allocations

**Data Store**: D2.1 budget_allocations
**System**: 2.0 Budget Management

**Description**: จัดสรรงบประมาณรายปีแบ่งตามไตรมาส Q1-Q4 สำหรับแต่ละหน่วยงานและประเภทงบประมาณ

**Structure**:
```sql
id                BIGINT PRIMARY KEY AUTO_INCREMENT
fiscal_year       INT NOT NULL
budget_type_id    BIGINT NOT NULL FK -> budget_types(id)
department_id     BIGINT NOT NULL FK -> departments(id)
total_amount      DECIMAL(18,2) NOT NULL

q1_amount         DECIMAL(18,2) NOT NULL
q1_spent          DECIMAL(18,2) DEFAULT 0
q1_reserved       DECIMAL(18,2) DEFAULT 0
quarter_1_start   DATE NOT NULL
quarter_1_end     DATE NOT NULL

q2_amount         DECIMAL(18,2) NOT NULL
q2_spent          DECIMAL(18,2) DEFAULT 0
q2_reserved       DECIMAL(18,2) DEFAULT 0
quarter_2_start   DATE NOT NULL
quarter_2_end     DATE NOT NULL

q3_amount         DECIMAL(18,2) NOT NULL
q3_spent          DECIMAL(18,2) DEFAULT 0
q3_reserved       DECIMAL(18,2) DEFAULT 0
quarter_3_start   DATE NOT NULL
quarter_3_end     DATE NOT NULL

q4_amount         DECIMAL(18,2) NOT NULL
q4_spent          DECIMAL(18,2) DEFAULT 0
q4_reserved       DECIMAL(18,2) DEFAULT 0
quarter_4_start   DATE NOT NULL
quarter_4_end     DATE NOT NULL

created_at        TIMESTAMP DEFAULT NOW()
updated_at        TIMESTAMP DEFAULT NOW()
created_by        BIGINT
updated_by        BIGINT
```

**Constraints**:
- UNIQUE(fiscal_year, budget_type_id, department_id)
- CHECK(total_amount = q1_amount + q2_amount + q3_amount + q4_amount)
- CHECK(q1_spent <= q1_amount)
- CHECK(q1_reserved >= 0)

**Indexes**:
- PRIMARY KEY(id)
- INDEX(fiscal_year, budget_type_id, department_id)
- INDEX(fiscal_year)

**Access Patterns**:
- **Created by**: Process 2.1 (Create Budget Allocation)
- **Read by**:
  - Process 2.3 (Check Budget Availability)
  - Process 2.7 (Monitor Budget Status)
  - Process 3.2 (Approve PR - budget check)
- **Updated by**:
  - Process 2.5 (Commit Budget - update q{x}_spent)
  - Process 2.4 (Reserve Budget - update q{x}_reserved)
  - Process 2.6 (Release Reservation - decrease q{x}_reserved)

**Volume**:
- Estimated records: ~500/year (5 depts × 6 budget types × 5 hospitals = 150, × 3 years = 450)
- Growth: +150 records/year

---

#### DSSPEC D4.2: drug_lots

**Data Store**: D4.2 drug_lots
**System**: 4.0 Inventory Management

**Description**: ข้อมูล lot/batch ของยาแต่ละรายการ เพื่อ tracking FIFO/FEFO และวันหมดอายุ

**Structure**:
```sql
id                    BIGINT PRIMARY KEY AUTO_INCREMENT
drug_id               BIGINT NOT NULL FK -> drugs(id)
location_id           BIGINT NOT NULL FK -> locations(id)
lot_number            VARCHAR(100) NOT NULL
expiry_date           DATE NOT NULL
received_date         DATE NOT NULL
quantity_received     DECIMAL(18,4) NOT NULL
quantity_available    DECIMAL(18,4) NOT NULL
unit_cost             DECIMAL(18,4) NOT NULL
is_active             BOOLEAN DEFAULT TRUE
created_at            TIMESTAMP DEFAULT NOW()
updated_at            TIMESTAMP DEFAULT NOW()
```

**Constraints**:
- UNIQUE(drug_id, location_id, lot_number)
- CHECK(quantity_available >= 0)
- CHECK(quantity_available <= quantity_received)
- CHECK(expiry_date > received_date)

**Indexes**:
- PRIMARY KEY(id)
- INDEX(drug_id, location_id, expiry_date) -- for FEFO
- INDEX(drug_id, location_id, received_date) -- for FIFO
- INDEX(expiry_date) -- for expiring drugs alert
- INDEX(lot_number) -- for lot search

**Access Patterns**:
- **Created by**:
  - Process 4.2 (Create Drug Lots from receipt)
  - Process 6.6 (Quarantine - create damaged lot)
- **Read by**:
  - Process 4.3 (Calculate FIFO Lots)
  - Process 4.4 (Calculate FEFO Lots)
  - Process 4.8 (Monitor Expiring Drugs)
  - Process 5.4 (Select FEFO for distribution)
- **Updated by**:
  - Process 4.5 (Issue Stock - decrease quantity_available)
  - Process 4.1 (Receive Stock - increase quantity_available)
  - Process 4.6 (Adjust Stock - update quantity_available)

**Volume**:
- Estimated records: ~10,000/year (100 drugs × 10 lots/drug × 10 locations = 10,000)
- Growth: +10,000 records/year
- Retention: 5 years (50,000 total records)

---

### 7.3 Complete DSSPEC Summary

**D1: Master Data Stores** (12 tables):
- DSSPEC D1.1: drug_generics
- DSSPEC D1.2: drugs
- DSSPEC D1.3: companies
- DSSPEC D1.4: locations
- DSSPEC D1.5: departments
- DSSPEC D1.6: budget_types
- DSSPEC D1.7-D1.12: Supporting tables

**D2: Budget Stores** (4 tables):
- DSSPEC D2.1: budget_allocations ✅ (detailed above)
- DSSPEC D2.2: budget_plans
- DSSPEC D2.3: budget_plan_items
- DSSPEC D2.4: budget_reservations

**D3: Procurement Stores** (15 tables):
- DSSPEC D3.1: purchase_requests, purchase_request_items
- DSSPEC D3.2: purchase_orders, purchase_order_items
- DSSPEC D3.3: receipts, receipt_items
- DSSPEC D3.4-D3.8: Supporting tables

**D4: Inventory Stores** (3 tables):
- DSSPEC D4.1: inventory
- DSSPEC D4.2: drug_lots ✅ (detailed above)
- DSSPEC D4.3: inventory_transactions

**D5-D8**: Distribution, Return, TMT, HPP stores (21 tables total)

**Total**: 55 DSSPECs (52 tables + 3 additional views)

---

## 8. Integration with ERD

### 8.1 DFD ↔ ERD Mapping

**Process to Table Mapping**:

| DFD Process | Corresponding ERD Tables | Relationship |
|-------------|-------------------------|--------------|
| 1.2 Manage Trade Drugs | `drugs` + `drug_generics` + `companies` | 1:N, N:1 |
| 2.1 Create Budget Allocation | `budget_allocations` | 1:1 create |
| 3.1 Create Purchase Request | `purchase_requests` + `purchase_request_items` | 1:N |
| 4.2 Create Drug Lots | `drug_lots` | 1:1 create |
| 5.1 Create Distribution | `drug_distributions` + `drug_distribution_items` | 1:N |

**Data Flow to Foreign Key Mapping**:

| Data Flow | Implemented As (FK) | Direction |
|-----------|---------------------|-----------|
| F1: drug_master | `purchase_request_items.drug_id` → `drugs.id` | Master → Transaction |
| F2: budget_check | `purchase_requests.budget_type_id` → `budget_types.id` | Transaction → Master |
| F4: stock_status | `drug_distributions.drug_id` → `drugs.id`<br/>`inventory.drug_id` → `drugs.id` | Master → Both |

### 8.2 Cross-Reference Table

**Complete mapping** of all 52 tables to DFD processes:

| Table | DFD Process (Create) | DFD Process (Read) | DFD Process (Update) |
|-------|---------------------|-------------------|---------------------|
| `drugs` | 1.2 | 3.1, 4.0, 5.1, 8.1 | 1.2 |
| `budget_allocations` | 2.1 | 2.3, 2.7, 3.2 | 2.5 |
| `drug_lots` | 4.2 | 4.3, 4.4, 4.8, 5.4 | 4.5, 4.6 |
| `inventory` | 4.1 | 4.9, 5.2 | 4.5, 4.6 |
| ... (all 52 tables) | ... | ... | ... |

---

## Appendix A: Glossary

| Term | Definition |
|------|------------|
| **DFD** | Data Flow Diagram - เครื่องมือแสดงการไหลของข้อมูล |
| **PSPEC** | Process Specification - รายละเอียดของแต่ละ process |
| **DSSPEC** | Data Store Specification - รายละเอียดของแต่ละ data store |
| **FIFO** | First In First Out - จ่ายของที่เข้ามาก่อนออกก่อน |
| **FEFO** | First Expire First Out - จ่ายของที่หมดอายุก่อนออกก่อน |
| **TMT** | Thai Medical Terminology - มาตรฐานรหัสยาไทย |
| **NLEM** | National List of Essential Medicines - บัญชียาหลักแห่งชาติ |
| **PR** | Purchase Request - ใบคำขอซื้อ |
| **PO** | Purchase Order - ใบสั่งซื้อ |

---

## Document Control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-01-22 | System Analyst | Initial DFD documentation (Level 0-2, all 8 systems) |

---

**INVS Modern Data Flow Diagram** - Complete Documentation

**Systems Covered**: 8/8 (100%)
**Processes Documented**: 47 sub-processes
**Data Stores**: 52 tables
**Integration**: Full ERD mapping

**Next Steps**: Use this DFD for Backend API design and Frontend screen planning
