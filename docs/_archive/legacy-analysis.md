# INVS Legacy Database Analysis

## 🔍 Overview

การวิเคราะห์โครงสร้างฐานข้อมูลระบบ INVS เดิม เพื่อเป็นแนวทางในการออกแบบและพัฒนาระบบใหม่ที่มีประสิทธิภาพและทันสมัยมากขึ้น

## 📊 Database Statistics

- **Total Tables**: 143 ตาราง
- **Database Engine**: MySQL/MariaDB → PostgreSQL (converted)
- **Character Encoding**: UTF-8 (Thai language support)
- **Database Size**: ~1.4GB (original dump)

## 🗂️ Table Categorization

### 1. Other/Reference Tables (71 ตาราง)
ตารางข้อมูลอ้างอิงและตารางสนับสนุน
- Configuration และ System tables
- Reference data (AIC codes, geographical data)
- Lookup tables (marital status, occupation, religion)

### 2. Procurement Tables (24 ตาราง)
ระบบจัดซื้อจัดจ้าง
- **Core Tables**:
  - `ms_po`, `ms_po_c` - Purchase Orders (หลัก)
  - `buyplan`, `buyplan_c` - Budget Planning
  - `ms_ivo`, `ms_ivo_c` - Invoice/Receipt
  - `sm_po`, `sm_po_c` - Distribution/Issue
- **Supporting Tables**: vendor management, purchase requests

### 3. Drug/Medicine Tables (21 ตาราง)
ระบบข้อมูลยาและเวชภัณฑ์
- **Core Tables**:
  - `drug_gn` - Generic drugs (ยาชื่อสามัญ)
  - `drug_vn` - Trade/Brand drugs (ยาชื่อการค้า)
  - `drug_compos` - Drug composition
- **Key Field**: `WORKING_CODE` - รหัสยาหลักของระบบ

### 4. Inventory Tables (19 ตาราง)
ระบบคลังสินค้า
- **Core Tables**:
  - `card` - Inventory transaction card (การเคลื่อนไหวยา)
  - `inv_md`, `inv_md_c` - Inventory master data
  - `inv_rtn`, `inv_rtn_c` - Return transactions
- **Features**: FIFO tracking, lot management, expiry date control

### 5. Department/Location Tables (3 ตาราง)
- `dept_id` - Department master
- `location` - Storage locations
- `dept_map` - Department mapping

### 6. Budget Tables (2 ตาราง)
- `bdg_type` - Budget types
- `bdg_amt` - Budget amounts

### 7. Patient/Clinical Tables (2 ตาราง)
- `patient` - Patient information
- `opd_h` - OPD transactions

### 8. Company/Vendor Tables (1 ตาราง)
- `company` - Vendor/supplier information

## 🔑 Key Design Patterns

### Working Code System
- **Central Identifier**: `WORKING_CODE` (7 characters)
- **Usage**: เป็น primary key สำหรับ drugs ในทุกตาราง
- **Format**: ตัวเลข 7 หลัก (เช่น 1310880, 1270350)

### Purchase Order Workflow
```
Purchase Planning (buyplan) 
→ Purchase Order (ms_po) 
→ Purchase Order Items (ms_po_c)
→ Invoice/Receipt (ms_ivo) 
→ Distribution (sm_po)
```

### Inventory Management
```
Drug Master (drug_gn/drug_vn) 
→ Inventory Transactions (card)
→ Stock Balance (inv_md)
→ Distribution Control (sm_po)
```

## 💡 Key Business Logic Insights

### 1. Drug Management
- **Dual Structure**: Generic (`drug_gn`) และ Trade name (`drug_vn`)
- **Working Code**: รหัสยาหลัก 7 หลักที่ใช้ทั่วทั้งระบบ
- **Multi-level tracking**: composition, dosage form, strength

### 2. Inventory Control
- **Card System**: บันทึกการเคลื่อนไหวทุก transaction ในตาราง `card`
- **Lot Management**: ติดตาม lot number และ expiry date
- **Location-based**: แยกคลังตามสถานที่เก็บ

### 3. Procurement Process
- **Multi-step workflow**: จากการวางแผน → สั่งซื้อ → รับของ → จ่าย
- **Budget integration**: เชื่อมโยงกับระบบงบประมาณ
- **Vendor management**: จัดการผู้จำหน่าย

### 4. Data Relationships
- **WORKING_CODE**: เชื่อมโยงข้อมูลยาทั่วทั้งระบบ
- **PO_NO**: เชื่อมโยง purchase order กับ items
- **VENDOR_CODE**: เชื่อมโยงกับข้อมูลผู้จำหน่าย

## 🚀 Recommendations for New System

### 1. Database Modernization
#### ✅ Keep (ควรคงไว้)
- **Working Code concept** - effective drug identification
- **Card-based transaction logging** - comprehensive audit trail
- **Multi-location inventory** - flexible storage management
- **Lot tracking with expiry** - essential for drug safety

#### 🔄 Improve (ควรปรับปรุง)
- **Normalize data structure** - reduce redundancy
- **Add proper foreign keys** - ensure data integrity
- **Implement proper indexing** - improve performance
- **Standardize naming conventions** - improve maintainability

#### ❌ Replace (ควรเปลี่ยน)
- **Complex table naming** - use clearer, consistent names
- **Date format inconsistency** - standardize date handling
- **Manual sequence management** - use auto-increment/sequences

### 2. New System Architecture

#### Core Modules
1. **Master Data Management**
   - Companies (vendors/manufacturers)
   - Locations & Departments
   - Drug catalog (generic + trade)
   - Units of measurement

2. **Inventory Management**
   - Real-time stock tracking
   - FIFO/FEFO with expiry management
   - Multi-location support
   - Automated reorder points

3. **Procurement System**
   - Purchase request workflow
   - Purchase order management
   - Goods receiving
   - Invoice processing

4. **Budget Management**
   - Budget allocation by department
   - Real-time budget tracking
   - Purchase approval workflow
   - Quarterly reporting

#### Technology Stack
- **Database**: PostgreSQL (already selected)
- **ORM**: Prisma (already selected)
- **Language**: TypeScript (already selected)
- **Architecture**: Modern event-driven with proper API design

### 3. Data Migration Strategy

#### Phase 1: Master Data
- Companies → `companies` table
- Drug generics → `drug_generics` table
- Locations → `locations` table
- Departments → `departments` table

#### Phase 2: Core Business Data
- Working codes mapping
- Current inventory levels
- Active purchase orders
- Budget allocations

#### Phase 3: Historical Data
- Transaction history (selective)
- Archived documents
- Reporting data

## 🔗 Legacy Database Access

The legacy database is available for reference:
- **Host**: localhost:5435
- **Database**: invs_legacy
- **User**: invs_user
- **Password**: invs123

Use the analysis scripts in `/scripts/analysis-results/` for detailed exploration.

## 📝 Next Steps

1. **Detailed Table Mapping**: Map legacy tables to new schema design
2. **Business Logic Documentation**: Document complex business rules
3. **Data Migration Scripts**: Create automated migration tools
4. **Performance Testing**: Benchmark queries against legacy structure
5. **User Training**: Prepare documentation for system transition

---

**Generated**: October 2025  
**Purpose**: Legacy system analysis for INVS Modern development