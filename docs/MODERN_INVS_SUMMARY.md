# Modern Inventory Management System (PostgreSQL Design)
*Based on analysis of INVS Legacy System (Manual 01 & 02)*

## 1. Executive Summary
This design modernizes the legacy INVS structure. 
- **Legacy Approach:** Separated Generic (`DRUG_GN`) and Trade (`DRUG_VN`) tables, relied heavily on `char` types, and separated header/detail tables with suffix `_C` (e.g., `MS_PO` & `MS_PO_C`).
- **Modern Approach:** 
    - Uses strict Foreign Keys (FK).
    - Uses `DECIMAL` for financial calculations (replacing `Float`).
    - Centralizes "Transactions" for better audit trails (Stock Card).
    - Supports Thai Medicines Terminology (TMT) natively.

---

## 2. Master Data (Drug & Product)

### 2.1 Generic Drugs (Standard Lookup)
Corresponds to legacy `DRUG_GN`. Represents the clinical definition of the drug.

```sql
CREATE TABLE drug_generics (
    generic_id          SERIAL PRIMARY KEY,
    working_code        VARCHAR(20) UNIQUE, -- Legacy ID mapping
    generic_name        VARCHAR(255) NOT NULL,
    description         TEXT,
    
    -- TMT Integration
    gpu_id              VARCHAR(50), -- General Product Unit ID (TMT)
    
    -- Clinical Classifications
    therapeutic_group   VARCHAR(100), -- Group Code
    dosage_form         VARCHAR(100), -- Tablet, Syrup, etc.
    strength            VARCHAR(100), -- 500 mg, 10 ml
    
    -- Administrative Classifications
    is_ed               BOOLEAN DEFAULT FALSE, -- Essential Drug List (บัญชียาหลัก)
    ed_category         VARCHAR(10),           -- ก, ข, ค, ง, จ
    ven_class           VARCHAR(1),            -- V, E, N (Vital, Essential, Non-essential)
    high_alert          BOOLEAN DEFAULT FALSE,
    
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);
```

### 2.2 Trade Products (Purchasable Items)
Corresponds to legacy `DRUG_VN`. Represents the actual product from a specific manufacturer.

```sql
CREATE TABLE drug_products (
    product_id          SERIAL PRIMARY KEY,
    generic_id          INTEGER REFERENCES drug_generics(generic_id),
    
    trade_name          VARCHAR(255) NOT NULL,
    trade_code          VARCHAR(50), -- TPU Code (Trade Product Unit)
    bar_code            VARCHAR(50),
    
    manufacturer_id     INTEGER REFERENCES companies(company_id), -- Factory
    distributor_id      INTEGER REFERENCES companies(company_id), -- Vendor
    
    -- Product Details
    reg_no              VARCHAR(50), -- Register No (เลขทะเบียน อย.)
    product_type        VARCHAR(20), -- Original, Generic, Import
    pack_size_desc      VARCHAR(100), -- e.g., "10x10 Tablets"
    
    -- Pricing
    standard_price      DECIMAL(12, 2), -- Reference Price (ราคากลาง)
    last_price          DECIMAL(12, 2), -- Last Purchase Price
    
    is_active           BOOLEAN DEFAULT TRUE
);
```

### 2.3 Unit Conversions (Pack Ratios)
Critical for converting between "Purchasing Unit" (Box) and "Dispensing Unit" (Tablet).

```sql
CREATE TABLE product_units (
    unit_id             SERIAL PRIMARY KEY,
    product_id          INTEGER REFERENCES drug_products(product_id),
    
    unit_name           VARCHAR(50), -- Box, Pack, Bottle
    base_unit_name      VARCHAR(50), -- Tablet, ml (The smallest unit)
    conversion_qty      INTEGER NOT NULL, -- How many base units in this pack?
    
    is_purchasing_unit  BOOLEAN DEFAULT FALSE,
    is_dispensing_unit  BOOLEAN DEFAULT FALSE
);
```

---

## 3. Partners (Companies)
Legacy system separated vendor codes. Modern design unifies this.

```sql
CREATE TABLE companies (
    company_id          SERIAL PRIMARY KEY,
    company_code        VARCHAR(20) UNIQUE, -- Legacy Code
    company_name        VARCHAR(255) NOT NULL,
    company_type        VARCHAR(20), -- Manufacturer, Vendor, Both
    
    tax_id              VARCHAR(20),
    address             TEXT,
    phone               VARCHAR(50),
    email               VARCHAR(100),
    
    credit_term_days    INTEGER DEFAULT 30,
    status              VARCHAR(20) DEFAULT 'ACTIVE' -- ACTIVE, BLACKLIST
);
```

---

## 4. Inventory Management (The Core)

### 4.1 Warehouses
Locations within the hospital.

```sql
CREATE TABLE warehouses (
    warehouse_id        SERIAL PRIMARY KEY,
    warehouse_name      VARCHAR(100) NOT NULL,
    warehouse_type      VARCHAR(20), -- MAIN (คลังใหญ่), SUB (คลังย่อย), DISP (ห้องจ่ายยา)
    location_code       VARCHAR(20)
);
```

### 4.2 Stock Balance (Lot Control)
Implements FEFO (First Expire, First Out). Corresponds to `INV_MD` + `INV_MD_C`.

```sql
CREATE TABLE stock_balances (
    stock_id            SERIAL PRIMARY KEY,
    warehouse_id        INTEGER REFERENCES warehouses(warehouse_id),
    product_id          INTEGER REFERENCES drug_products(product_id),
    
    lot_no              VARCHAR(50) NOT NULL,
    serial_no           VARCHAR(100), -- For equipment/assets
    expire_date         DATE NOT NULL,
    receive_date        DATE NOT NULL,
    
    quantity            DECIMAL(12, 2) NOT NULL, -- Always stored in BASE UNIT
    cost_price          DECIMAL(12, 4) NOT NULL, -- Cost per BASE UNIT (supports precise avg)
    
    CONSTRAINT uq_stock UNIQUE (warehouse_id, product_id, lot_no, expire_date)
);
```

### 4.3 Transactions (Audit Trail)
Unified log for all movements (Receive, Issue, Return, Adjust). Replaces scattered transaction tables.

```sql
CREATE TABLE stock_transactions (
    transaction_id      BIGSERIAL PRIMARY KEY,
    transaction_date    TIMESTAMP DEFAULT NOW(),
    transaction_type    VARCHAR(20) NOT NULL, 
    -- Types: RECEIVE_PO, ISSUE_REQ, TRANSFER_IN, TRANSFER_OUT, RETURN_VENDOR, ADJUST, DISPENSE_HIS
    
    -- References
    ref_document_no     VARCHAR(50), -- PO No, Requisition No.
    warehouse_id        INTEGER REFERENCES warehouses(warehouse_id),
    product_id          INTEGER REFERENCES drug_products(product_id),
    
    -- Movement
    lot_no              VARCHAR(50),
    quantity_change     DECIMAL(12, 2) NOT NULL, -- Positive for IN, Negative for OUT
    balance_after       DECIMAL(12, 2) NOT NULL, -- Snapshot of balance
    unit_cost           DECIMAL(12, 4),          -- Cost at moment of transaction
    
    -- Meta
    user_id             INTEGER, -- Who did it
    remark              TEXT
);
```

---

## 5. Procurement (Purchasing)

### 5.1 Purchase Orders (Header)
Corresponds to legacy `MS_PO`.

```sql
CREATE TABLE purchase_orders (
    po_id               SERIAL PRIMARY KEY,
    po_number           VARCHAR(50) UNIQUE NOT NULL,
    po_date             DATE DEFAULT CURRENT_DATE,
    
    vendor_id           INTEGER REFERENCES companies(company_id),
    budget_year         INTEGER, -- Fiscal Year (e.g., 2026)
    budget_type         VARCHAR(50), -- UC, บำรุง, งบจังหวัด
    
    total_amount        DECIMAL(12, 2),
    status              VARCHAR(20) -- DRAFT, APPROVED, SENT, PARTIAL_RECEIVED, COMPLETED, CANCELLED
);
```

### 5.2 Purchase Order Items (Detail)
Corresponds to legacy `MS_PO_C`.

```sql
CREATE TABLE purchase_order_items (
    po_item_id          SERIAL PRIMARY KEY,
    po_id               INTEGER REFERENCES purchase_orders(po_id),
    product_id          INTEGER REFERENCES drug_products(product_id),
    
    qty_ordered         INTEGER NOT NULL,
    unit_id             INTEGER REFERENCES product_units(unit_id), -- Ordering Unit (e.g., Box)
    unit_price          DECIMAL(12, 2), -- Price per Ordering Unit
    total_price         DECIMAL(12, 2),
    
    qty_received        INTEGER DEFAULT 0, -- Track partial receiving
    is_free             BOOLEAN DEFAULT FALSE
);
```

---

## 6. Budget & Planning
Based on legacy `BUYPLAN`.

```sql
CREATE TABLE budget_allocations (
    budget_id           SERIAL PRIMARY KEY,
    fiscal_year         INTEGER NOT NULL,
    source_name         VARCHAR(100), -- เงินบำรุง, UC
    total_amount        DECIMAL(15, 2),
    used_amount         DECIMAL(15, 2) DEFAULT 0,
    remaining_amount    DECIMAL(15, 2) GENERATED ALWAYS AS (total_amount - used_amount) STORED
);
```

---

## 7. Migration Mapping Guide (Legacy -> New)

| Legacy Table | Legacy Field | New Table | New Field | Note |
| :--- | :--- | :--- | :--- | :--- |
| **DRUG_GN** | `WORKING_CODE` | `drug_generics` | `working_code` | Keep as reference |
| **DRUG_GN** | `GPUID` | `drug_generics` | `gpu_id` | Crucial for TMT |
| **DRUG_GN** | `IS_ED` | `drug_generics` | `is_ed` | Boolean conversion |
| **DRUG_VN** | `TRADE_CODE` | `drug_products` | `trade_code` | TPU Code |
| **DRUG_VN** | `24DIGIT` | `drug_products` | `bar_code` | Or separate standard code |
| **MS_PO** | `PO_NO` | `purchase_orders` | `po_number` | Direct mapping |
| **INV_MD** | `QTY_ON_HAND` | `stock_balances` | `quantity` | Needs Unit conversion check |
| **INV_MD** | `LOT_COST` | `stock_balances` | `cost_price` | |

## 8. Key Improvements
1.  **Strict Typing:** Replaced `float` with `DECIMAL` for currency and inventory quantities to prevent floating-point errors.
2.  **Normalization:** Manufacturer/Vendor are now in one `companies` table with a type flag, reducing duplication.
3.  **Stock Card:** The `stock_transactions` table allows for rebuilding the stock status at any point in time (Time-travel reporting), which was difficult in the legacy system that relied on static snapshots.
4.  **Unit Handling:** The system is designed to store inventory in **Base Units** (e.g., Tablet) while allowing Purchasing in **Pack Units** (e.g., Box), using the `product_units` conversion table. This solves the "Pack Ratio" issues found in legacy systems.

## 9. Recommendations for Modern System Implementation
To truly modernize the system beyond just the database structure, consider the following implementation strategies:

### 9.1 Architecture & Technology
*   **Web-Based Application:** Move away from the legacy Windows Form (Client-Server) model to a Web Application (React/Vue/Angular + Node/Go/Go). This allows access from any device, including tablets for stock counting in the warehouse.
*   **API-First Design:** Build a robust RESTful or GraphQL API. This ensures that the HIS (Hospital Information System) or mobile apps can interact with the inventory cleanly, rather than direct database connections which were common in legacy systems.

### 9.2 Functional Enhancements
*   **Real-time Stock Processing:** Legacy systems often required a "Process/Close Day" button to update balances. The new system should update `stock_balances` immediately upon transaction commitment (`stock_transactions`), providing real-time visibility.
*   **Smart Search (Full-Text):** Implement fuzzy search (e.g., PostgreSQL Trigram or Elasticsearch) allowing users to find drugs by typing partial names (Thai/English), trade names, or generic names in a single search box, solving the "exact match" frustration.
*   **GS1 DataMatrix Support:** Modern pharmaceutical standards use 2D Barcodes (GS1 DataMatrix) which contain Product ID, Lot No, and Expiry Date in a single scan. The system should be able to parse this string to auto-fill receiving forms.

### 9.3 UX/UI Improvements
*   **Actionable Dashboards:** Instead of static reports, provide a dashboard showing "Items near Expiry (Next 3/6 Months)" and "Below Minimum Stock" with direct "Create PO" buttons.
*   **Mobile Stock Counting:** Create a simplified mobile view for pharmacists/staff to walk around shelves and perform cycle counts without needing paper printouts.

### 9.4 Integration & Standards
*   **TMT Auto-Sync:** If possible, integrate with the TMT API to auto-update drug master data (new codes, price updates) to reduce manual data entry errors.
*   **Standardized Reports:** Pre-build reports required by the Ministry (reports 506, etc.) using the new clean data structure to automate monthly reporting burdens.

---

## 10. Core Entity Reference (แก่นสำคัญของระบบ)
สรุปฟิลด์ที่ "ต้องมี" (Mandatory) สำหรับการเริ่มต้นทำระบบ Inventory ใหม่ เพื่อให้รองรับทั้งงานคลังและการส่งข้อมูลภาครัฐ

### 10.1 Drug Generic (แก่นทางคลินิก)
*เป็นข้อมูลยาเชิงวิชาการที่ไม่เปลี่ยนตามยี่ห้อ*
- **working_code:** รหัสกรมฯ หรือรหัสภายในเดิม (ใช้เชื่อมโยงประวัติเก่า)
- **generic_name:** ชื่อสามัญทางยา (อังกฤษ) เช่น Paracetamol
- **gpu_id:** รหัส TMT GPU (สำคัญ: ใช้เทียบเคียงราคากลางทั่วประเทศ)
- **dosage_form:** รูปแบบยา (Tablet, Syrup, Injection)
- **strength:** ความแรงยา (500 mg, 10 ml)
- **ed_category:** บัญชียาหลัก (ก, ข, ค, ง, จ) - ใช้ควบคุมงบประมาณ
- **ven_category:** ประเภท V, E, N - ใช้ลำดับความสำคัญในการสำรองของ (V=ขาดไม่ได้)

### 10.2 Drug Product (แก่นทางการค้า)
*เป็นตัวสินค้าจริงที่ถืออยู่ในมือและสแกนเข้าคลัง*
- **generic_id:** (FK) เชื่อมกลับไปหาชื่อสามัญ
- **trade_name:** ชื่อทางการค้า (ยี่ห้อ) เช่น Tylenol
- **tpu_id:** รหัส TMT TPU (สำคัญ: ระบุยี่ห้อและขนาดบรรจุ ใช้เบิกเงินคืนกับ สปสช.)
- **nc24_code:** รหัสยา 24 หลัก (มาตรฐานเดิมของกระทรวงฯ ที่ยังต้องใช้ในรายงานหลายตัว)
- **barcode:** บาร์โค้ดสินค้า (ใช้สแกนรับ/จ่าย)
- **reg_no:** เลขทะเบียน อย. (ใช้ตรวจสอบความถูกต้องทางกฎหมาย)
- **manufacturer_id:** (FK) ใครเป็นคนผลิตสินค้าตัวนี้

### 10.3 Package / Units (แก่นการจัดการหน่วยนับ)
*เป็นส่วนที่ใช้คำนวณตัดสต็อก Multi-Unit*
- **product_id:** (FK) เชื่อมกับสินค้า
- **unit_name:** ชื่อหน่วย (กล่อง, แผง, ขวด)
- **base_unit_name:** หน่วยย่อยที่สุด (เม็ด, มล., หลอด) **<- ต้องมีเพื่อใช้เป็นแกนกลางการคำนวณ**
- **conversion_ratio:** ตัวคูณแปลงหน่วย (เช่น 1 กล่อง = 100 เม็ด)
- **is_buy_unit:** เป็นหน่วยที่ใช้สั่งซื้อหรือไม่ (เช่น ซื้อเป็นกล่อง)
- **is_dispense_unit:** เป็นหน่วยที่ใช้จ่ายยาหรือไม่ (เช่น จ่ายเป็นแผง หรือ เม็ด)

### 10.4 Companies (แก่นผู้ค้าและคู่สัญญา)
- **company_name:** ชื่อบริษัท (ที่ระบุในใบกำกับภาษี)
- **tax_id:** เลขประจำตัวผู้เสียภาษี (สำคัญ: ใช้ตรวจสอบความซ้ำซ้อนและออกเอกสารงบประมาณ)
- **company_type:** ประเภทบริษัท (ผู้ผลิต, ผู้จำหน่าย, หรือทั้งคู่)
- **credit_term:** ระยะเวลาสินเชื่อ (วัน) - ใช้คำนวณวันครบกำหนดชำระเงิน
- **is_active:** สถานะการใช้งาน (ใช้ปิดบริษัทที่เลิกติดต่อกันไปแล้ว)

---

## 11. Multi-ID Scenarios (กรณีที่ยาตัวเดียวต้องมีหลายรหัส)
ในการออกแบบระบบคลังยา แม้จะเป็นยาชนิดเดียวกันจากบริษัทเดียวกัน แต่บางกรณี "จำเป็น" ต้องแยกเป็นหลายรหัส (Product IDs) ด้วยเหตุผลดังนี้:

### 11.1 ต่างลักษณะบรรจุภัณฑ์ (TMT TPU Logic)
- **ตัวอย่าง:** Para 500mg แบบแผง (Strip) กับ แบบกระปุก (Loose)
- **เหตุผล:** รหัสมาตรฐาน TMT TPU จะแยกตามบรรจุภัณฑ์ขั้นต้น เนื่องจากมีผลต่ออายุการเก็บรักษาและการเบิกจ่ายเงินคืน (Reimbursement)

### 11.2 ต่างประเภทบัญชี (ED vs NED)
- **ตัวอย่าง:** ยาตัวเดียวกันแต่รหัสหนึ่งระบุเป็นยาในบัญชีหลัก (ED) และอีกรหัสเป็นยานอกบัญชี (NED)
- **เหตุผล:** เพื่อแยกงบประมาณการซื้อและการควบคุมการสั่งใช้ยาให้เป็นไปตามระเบียบภาครัฐ

### 11.3 ต่างแหล่งที่มาของต้นทุน (Purchase vs Donation)
- **ตัวอย่าง:** ยาที่จัดซื้อเอง (มีราคาทุน) กับ ยาที่ได้รับบริจาค หรือยาโครงการ (ต้นทุน 0 บาท)
- **เหตุผล:** หากใช้รหัสเดียวกันจะทำให้ "ราคาทุนเฉลี่ย (Moving Average Cost)" ผิดพลาด ส่งผลต่อมูลค่าคลังในงบการเงิน

### 11.4 ต่างแหล่งผลิต (Local vs Import)
- **ตัวอย่าง:** ยาแบรนด์เดียวกัน แต่รหัสหนึ่งผลิตในไทย อีกรหัสผลิตต่างประเทศ
- **เหตุผล:** เพื่อการตรวจสอบย้อนกลับ (Traceability) และเงื่อนไขสัญญาจัดซื้อภาครัฐที่อาจให้สิทธิพิเศษกับยาที่ผลิตในประเทศ

### 11.5 การเปลี่ยนรุ่นสินค้า (Product Evolution)
- **ตัวอย่าง:** บริษัทเปลี่ยนสูตรส่วนประกอบรอง หรือเปลี่ยนหน้าตาเม็ดยาใหม่
- **เหตุผล:** เพื่อความปลอดภัยของผู้ป่วย (Pharmacovigilance) หากเกิดอาการไม่พึงประสงค์ จะได้ระบุได้ชัดเจนว่าเป็นยา Lot ของรุ่นใด

**⚠️ ข้อควรระวัง:** ไม่ว่าจะแยกกี่รหัสสินค้า (Product IDs) **ทุกรหัสต้องวิ่งกลับไปหา Generic ID เดียวกันเสมอ** เพื่อให้ระบบสามารถสรุปยอดคงเหลือรวมของยาชนิดนั้นๆ ได้ในหน้าจอเดียว
