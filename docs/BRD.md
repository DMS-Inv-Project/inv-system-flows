# Business Requirements Document (BRD)
# เอกสารกำหนดความต้องการทางธุรกิจ

**INVS Modern - Hospital Inventory Management System**  
**ระบบบริหารจัดการพัสดุยาและเวชภัณฑ์โรงพยาบาล**

---

## Document Information | ข้อมูลเอกสาร

| Field | Value |
|-------|-------|
| **Document Version** | 1.0.0 |
| **Date Created** | 2025-01-22 |
| **Last Updated** | 2025-01-22 |
| **Status** | Draft for Review |
| **Prepared By** | INVS Modern Development Team |
| **Approved By** | [Pending Approval] |

---

## Table of Contents | สารบัญ

1. [Executive Summary](#1-executive-summary--บทสรุปสำหรับผู้บริหาร)
2. [Project Information](#2-project-information--ข้อมูลโครงการ)
3. [Business Overview](#3-business-overview--ภาพรวมธุรกิจ)
4. [Problems and Requirements](#4-problems-and-requirements--ปัญหาและความต้องการ)
5. [Project Scope](#5-project-scope--ขอบเขตโครงการ)
6. [Functional Requirements](#6-functional-requirements--ความต้องการด้านการทำงาน)
7. [Business Rules](#7-business-rules--กฎทางธุรกิจ)
8. [Compliance Requirements](#8-compliance-requirements--ข้อกำหนดด้านกฎระเบียบ)
9. [User Roles and Permissions](#9-user-roles-and-permissions--บทบาทและสิทธิ์ผู้ใช้)
10. [Success Criteria](#10-success-criteria--เกณฑ์ความสำเร็จ)
11. [Assumptions and Constraints](#11-assumptions-and-constraints--สมมติฐานและข้อจำกัด)
12. [Risks and Mitigation](#12-risks-and-mitigation--ความเสี่ยงและการบริหารจัดการ)
13. [Appendices](#13-appendices--ภาคผนวก)

---

## 1. Executive Summary | บทสรุปสำหรับผู้บริหาร

### 1.1 Purpose | วัตถุประสงค์

**English:**  
INVS Modern is a comprehensive hospital inventory management system designed to modernize and streamline drug and medical supply procurement, inventory control, and distribution processes. This system replaces the legacy INVS system with a modern, scalable, and compliant solution.

**ภาษาไทย:**  
INVS Modern เป็นระบบบริหารจัดการพัสดุยาและเวชภัณฑ์โรงพยาบาลแบบครบวงจร ออกแบบมาเพื่อพัฒนาและปรับปรุงกระบวนการจัดซื้อ การควบคุมสต็อก และการจัดจ่ายยา โดยจะทดแทนระบบ INVS เดิมด้วยโซลูชันที่ทันสมัย รองรับการขยายงาน และสอดคล้องกับมาตรฐานที่กำหนด

### 1.2 Business Objectives | วัตถุประสงค์ทางธุรกิจ

1. **Improve Budget Control** | **ปรับปรุงการควบคุมงบประมาณ**
   - Real-time budget checking and reservation system
   - ระบบตรวจสอบและจองงบประมาณแบบทันที
   - Quarterly budget allocation and monitoring
   - การจัดสรรและติดตามงบประมาณรายไตรมาส

2. **Enhance Inventory Accuracy** | **เพิ่มความแม่นยำของสต็อกสินค้า**
   - FIFO/FEFO lot tracking to minimize waste
   - ระบบติดตามล็อตแบบ FIFO/FEFO เพื่อลดการสูญเสีย
   - Multi-location inventory management
   - การจัดการสต็อกแบบหลายสถานที่

3. **Ensure Ministry Compliance** | **รับประกันความสอดคล้องตามข้อกำหนดของกระทรวง**
   - 100% compliance with DMSIC Standards พ.ศ. 2568
   - สอดคล้องตามมาตรฐาน DMSIC พ.ศ. 2568 ครบ 100%
   - 5 mandatory export files for Ministry of Public Health
   - ไฟล์ส่งออก 5 ไฟล์ตามที่กระทรวงสาธารณสุขกำหนด

4. **Streamline Procurement Process** | **ปรับปรุงกระบวนการจัดซื้อ**
   - Automated purchase request workflows
   - ระบบขออนุมัติซื้อแบบอัตโนมัติ
   - Integration with contract management
   - บูรณาการกับระบบจัดการสัญญา

5. **Support Data-Driven Decisions** | **สนับสนุนการตัดสินใจโดยอาศัยข้อมูล**
   - Comprehensive reporting and analytics
   - รายงานและการวิเคราะห์ข้อมูลที่ครอบคลุม
   - Drug usage pattern analysis (ABC-VEN)
   - การวิเคราะห์รูปแบบการใช้ยา (ABC-VEN)

### 1.3 Expected Benefits | ประโยชน์ที่คาดว่าจะได้รับ

**Operational Benefits | ประโยชน์ด้านการดำเนินงาน:**
- ⏱️ 50% reduction in purchase request processing time
- ⏱️ ลดเวลาในการประมวลผลคำขอซื้อลง 50%
- 📉 30% reduction in expired drug waste
- 📉 ลดของเสียจากยาหมดอายุลง 30%
- 💰 20% improvement in budget utilization
- 💰 เพิ่มประสิทธิภาพการใช้งบประมาณขึ้น 20%

**Compliance Benefits | ประโยชน์ด้านกฎระเบียบ:**
- ✅ 100% accurate ministry reporting
- ✅ รายงานกระทรวงถูกต้องแม่นยำ 100%
- 🔐 Full audit trail for all transactions
- 🔐 มีร่องรอยการตรวจสอบครบถ้วนทุกธุรกรรม

**Strategic Benefits | ประโยชน์เชิงกลยุทธ์:**
- 📊 Better demand forecasting and planning
- 📊 การคาดการณ์และวางแผนความต้องการที่ดีขึ้น
- 🔄 Improved vendor relationship management
- 🔄 การบริหารความสัมพันธ์กับผู้ขายที่ดีขึ้น

---

## 2. Project Information | ข้อมูลโครงการ

### 2.1 Project Timeline | ระยะเวลาโครงการ

| Phase | Duration | Status |
|-------|----------|--------|
| **Phase 1: Database & Schema** | 3 months | ✅ Complete |
| ระยะที่ 1: ฐานข้อมูลและโครงสร้าง | 3 เดือน | เสร็จสมบูรณ์ |
| **Phase 2: Backend API** | 4 months | 🚧 Planned |
| ระยะที่ 2: Backend API | 4 เดือน | อยู่ระหว่างวางแผน |
| **Phase 3: Frontend Application** | 5 months | 🚧 Planned |
| ระยะที่ 3: ส่วนแสดงผลด้านหน้า | 5 เดือน | อยู่ระหว่างวางแผน |
| **Phase 4: Testing & Deployment** | 2 months | 🚧 Planned |
| ระยะที่ 4: ทดสอบและนำไปใช้งาน | 2 เดือน | อยู่ระหว่างวางแผน |

**Total Project Duration:** 14 months  
**ระยะเวลาโครงการทั้งหมด:** 14 เดือน

### 2.2 Project Stakeholders | ผู้มีส่วนได้ส่วนเสีย

**Primary Stakeholders | ผู้มีส่วนได้ส่วนเสียหลัก:**
- 🏥 Hospital Management (ผู้บริหารโรงพยาบาล)
- 💊 Pharmacy Department (แผนกเภสัชกรรม)
- 💰 Finance Department (แผนกการเงิน)
- 📦 Procurement Department (แผนกพัสดุและจัดซื้อ)
- 🏥 Clinical Departments (แผนกคลินิก)

**Secondary Stakeholders | ผู้มีส่วนได้ส่วนเสียรอง:**
- 📋 Ministry of Public Health (กระทรวงสาธารณสุข)
- 🏢 Vendors and Suppliers (ผู้จำหน่ายและผู้จัดหาสินค้า)
- 👨‍💻 IT Department (แผนกเทคโนโลยีสารสนเทศ)

### 2.3 Budget Overview | ภาพรวมงบประมาณ

| Category | Estimated Cost |
|----------|----------------|
| **Software Development** | [TBD] |
| การพัฒนาซอฟต์แวร์ | |
| **Infrastructure** | [TBD] |
| โครงสร้างพื้นฐาน | |
| **Training & Support** | [TBD] |
| การฝึกอบรมและสนับสนุน | |
| **Maintenance (Year 1)** | [TBD] |
| การบำรุงรักษา (ปีแรก) | |

---

## 3. Business Overview | ภาพรวมธุรกิจ

### 3.1 Current Environment | สภาพแวดล้อมปัจจุบัน

**Legacy System | ระบบเดิม:**
- Name: INVS (Inventory Management System)
- ชื่อ: ระบบบริหารจัดการพัสดุ INVS
- Database: MySQL (133 tables)
- ฐานข้อมูล: MySQL (133 ตาราง)
- Age: 10+ years
- อายุการใช้งาน: มากกว่า 10 ปี
- Status: Outdated, difficult to maintain, lacks modern features
- สถานะ: ล้าสมัย บำรุงรักษายาก ขาดฟีเจอร์ที่ทันสมัย

**Key Challenges with Legacy System | ปัญหาหลักของระบบเดิม:**

1. **No Real-time Budget Control**
   - ไม่มีการควบคุมงบประมาณแบบทันที
   - Budget overruns are common
   - การใช้งบประมาณเกินจำนวนที่กำหนดเกิดขึ้นบ่อย

2. **Limited Contract Management**
   - การจัดการสัญญามีข้อจำกัด
   - No integration with procurement workflow
   - ไม่มีการเชื่อมโยงกับกระบวนการจัดซื้อ

3. **Manual Ministry Reporting**
   - การรายงานให้กระทรวงทำด้วยมือ
   - Time-consuming and error-prone
   - ใช้เวลามากและเกิดข้อผิดพลาดได้ง่าย

4. **Weak Inventory Tracking**
   - การติดตามสต็อกไม่มีประสิทธิภาพ
   - Lot tracking is incomplete
   - การติดตามล็อตไม่ครบถ้วน
   - Expiry management is manual
   - การจัดการวันหมดอายุทำด้วยมือ

5. **No Mobile Access**
   - ไม่สามารถเข้าใช้งานผ่านมือถือได้
   - Desktop-only system
   - ระบบใช้งานได้เฉพาะคอมพิวเตอร์ตั้งโต๊ะเท่านั้น

### 3.2 Business Processes | กระบวนการทางธุรกิจ

**Core Business Processes | กระบวนการทางธุรกิจหลัก:**

```
1. Budget Planning (การวางแผนงบประมาณ)
   └─> Annual allocation → Quarterly breakdown → Department assignment

2. Procurement (การจัดซื้อ)
   └─> Need identification → Budget check → PR creation → Approval → PO → Receive goods

3. Inventory Management (การจัดการสต็อก)
   └─> Receive → Store → Track lot/expiry → Dispense (FIFO/FEFO) → Reorder

4. Distribution (การจัดจ่าย)
   └─> Department request → Check stock → Pick lot (FEFO) → Issue → Record

5. Reporting (การรายงาน)
   └─> Daily operations → Monthly summary → Quarterly review → Ministry submission
```

### 3.3 Business Volume | ปริมาณธุรกิจ

**Estimated Transaction Volume | ปริมาณธุรกรรมโดยประมาณ:**

| Transaction Type | Daily | Monthly | Yearly |
|------------------|-------|---------|--------|
| Purchase Requests | 10-15 | 300-450 | 3,600-5,400 |
| คำขอซื้อ | 10-15 | 300-450 | 3,600-5,400 |
| Goods Receipts | 5-10 | 150-300 | 1,800-3,600 |
| ใบรับสินค้า | 5-10 | 150-300 | 1,800-3,600 |
| Drug Distributions | 20-30 | 600-900 | 7,200-10,800 |
| การจัดจ่ายยา | 20-30 | 600-900 | 7,200-10,800 |
| Inventory Adjustments | 2-5 | 60-150 | 720-1,800 |
| การปรับปรุงสต็อก | 2-5 | 60-150 | 720-1,800 |

**Master Data Volume | ปริมาณข้อมูลหลัก:**
- Drug Generics: ~1,100 items (ยาชื่อสามัญ)
- Trade Drugs: ~1,200 items (ยาชื่อการค้า)
- Active Lots: ~3,000-5,000 lots (ล็อตที่ใช้งานอยู่)
- Vendors: ~100 companies (ผู้จำหน่าย)

---

## 4. Problems and Requirements | ปัญหาและความต้องการ

### 4.1 Problem Statements | การระบุปัญหา

#### Problem 1: Lack of Real-time Budget Control
**ปัญหาที่ 1: ขาดการควบคุมงบประมาณแบบทันที**

**Current Situation | สถานการณ์ปัจจุบัน:**
- Budget checking is done manually before each purchase
- การตรวจสอบงบประมาณทำด้วยมือก่อนการซื้อแต่ละครั้ง
- No automated reservation system
- ไม่มีระบบจองงบอัตโนมัติ
- Budget overruns discovered too late
- พบว่าใช้งบประมาณเกินเมื่อสายเกินไป

**Impact | ผลกระทบ:**
- 💰 15-20% budget overruns per year
- 💰 ใช้งบประมาณเกิน 15-20% ต่อปี
- ⏰ 2-3 hours daily spent on manual checking
- ⏰ ใช้เวลาตรวจสอบด้วยมือ 2-3 ชั่วโมงต่อวัน
- 📉 Poor budget utilization (unused allocations)
- 📉 การใช้งบประมาณไม่มีประสิทธิภาพ (งบที่ไม่ได้ใช้)

**Required Solution | โซลูชันที่ต้องการ:**
- ✅ Real-time budget availability checking
- ✅ ตรวจสอบงบประมาณคงเหลือแบบทันที
- ✅ Automatic budget reservation for pending PRs
- ✅ จองงบอัตโนมัติสำหรับคำขอซื้อที่รอการอนุมัติ
- ✅ Quarterly budget monitoring dashboard
- ✅ แดชบอร์ดติดตามงบประมาณรายไตรมาส

#### Problem 2: Incomplete Lot Tracking and Expiry Management
**ปัญหาที่ 2: การติดตามล็อตและวันหมดอายุไม่สมบูรณ์**

**Current Situation | สถานการณ์ปัจจุบัน:**
- Lot numbers recorded but not enforced in dispensing
- มีการบันทึกหมายเลขล็อต แต่ไม่มีการบังคับใช้ในการจ่ายยา
- No automated FIFO/FEFO logic
- ไม่มีระบบ FIFO/FEFO อัตโนมัติ
- Expiry alerts are manual and often missed
- การแจ้งเตือนวันหมดอายุทำด้วยมือและมักพลาด

**Impact | ผลกระทบ:**
- 💊 5-8% of drugs expire before use
- 💊 ยาหมดอายุก่อนนำไปใช้ 5-8%
- 💸 Estimated waste value: 500,000-1,000,000 THB/year
- 💸 มูลค่าการสูญเสียประมาณ: 500,000-1,000,000 บาท/ปี
- ⚠️ Risk of dispensing expired drugs
- ⚠️ มีความเสี่ยงในการจ่ายยาหมดอายุ

**Required Solution | โซลูชันที่ต้องการ:**
- ✅ Mandatory lot selection with FIFO/FEFO logic
- ✅ การเลือกล็อตแบบบังคับพร้อมตรรกะ FIFO/FEFO
- ✅ Automated expiry alerts (90/60/30 days before expiry)
- ✅ แจ้งเตือนวันหมดอายุอัตโนมัติ (90/60/30 วันก่อนหมดอายุ)
- ✅ Blocked dispensing for expired drugs
- ✅ ป้องกันการจ่ายยาที่หมดอายุ

#### Problem 3: No Contract Management System
**ปัญหาที่ 3: ไม่มีระบบจัดการสัญญา**

**Current Situation | สถานการณ์ปัจจุบัน:**
- Contracts managed in separate files (Excel/Paper)
- จัดการสัญญาในไฟล์แยก (Excel/กระดาษ)
- No integration with purchase orders
- ไม่มีการเชื่อมโยงกับใบสั่งซื้อ
- Cannot track contract spending vs. limit
- ไม่สามารถติดตามการใช้จ่ายตามสัญญาได้

**Impact | ผลกระทบ:**
- 📄 Contract compliance issues
- 📄 ปัญหาการปฏิบัติตามเงื่อนไขสัญญา
- 💰 Risk of exceeding contract limits
- 💰 มีความเสี่ยงใช้เงินเกินวงเงินสัญญา
- ⏰ Delayed procurement due to contract verification
- ⏰ การจัดซื้อล่าช้าเนื่องจากต้องตรวจสอบสัญญา

**Required Solution | โซลูชันที่ต้องการ:**
- ✅ Integrated contract management module
- ✅ โมดูลจัดการสัญญาแบบบูรณาการ
- ✅ Automatic contract selection in PR/PO
- ✅ เลือกสัญญาอัตโนมัติในคำขอซื้อ/ใบสั่งซื้อ
- ✅ Contract spending tracking and alerts
- ✅ ติดตามการใช้วงเงินสัญญาและแจ้งเตือน

#### Problem 4: Manual Ministry Reporting
**ปัญหาที่ 4: การรายงานให้กระทรวงทำด้วยมือ**

**Current Situation | สถานการณ์ปัจจุบัน:**
- 5 ministry files prepared manually each month
- จัดทำไฟล์รายงานให้กระทรวง 5 ไฟล์ด้วยมือทุกเดือน
- Data exported from multiple sources and combined
- ดึงข้อมูลจากหลายแหล่งแล้วนำมารวมกัน
- High error rate due to manual processes
- อัตราข้อผิดพลาดสูงเนื่องจากกระบวนการทำด้วยมือ

**Impact | ผลกระทบ:**
- ⏰ 8-10 hours per month spent on reporting
- ⏰ ใช้เวลา 8-10 ชั่วโมงต่อเดือนในการทำรายงาน
- ❌ 15-20% error rate requiring corrections
- ❌ อัตราข้อผิดพลาด 15-20% ต้องแก้ไข
- 📅 Late submissions due to complexity
- 📅 ส่งรายงานล่าช้าเนื่องจากความซับซ้อน

**Required Solution | โซลูชันที่ต้องการ:**
- ✅ Automated export of 5 ministry files
- ✅ ส่งออกไฟล์รายงาน 5 ไฟล์อัตโนมัติ
- ✅ 100% compliance with DMSIC Standards พ.ศ. 2568
- ✅ สอดคล้องตามมาตรฐาน DMSIC พ.ศ. 2568 ครบ 100%
- ✅ One-click export with data validation
- ✅ ส่งออกคลิกเดียวพร้อมตรวจสอบความถูกต้องของข้อมูล

#### Problem 5: Limited Reporting and Analytics
**ปัญหาที่ 5: การรายงานและการวิเคราะห์มีข้อจำกัด**

**Current Situation | สถานการณ์ปัจจุบัน:**
- Basic reports only (stock levels, transactions)
- มีเพียงรายงานพื้นฐาน (ระดับสต็อก, ธุรกรรม)
- No drug usage pattern analysis
- ไม่มีการวิเคราะห์รูปแบบการใช้ยา
- Cannot identify slow-moving or fast-moving items
- ไม่สามารถระบุสินค้าที่หมุนเวียนช้าหรือเร็วได้

**Impact | ผลกระทบ:**
- 📊 Poor demand forecasting
- 📊 การคาดการณ์ความต้องการไม่มีประสิทธิภาพ
- 💰 Overstocking slow-moving items
- 💰 สต็อกสินค้าหมุนเวียนช้าสูงเกินไป
- 📉 Stockouts of fast-moving items
- 📉 สต็อกสินค้าหมุนเวียนเร็วหมด

**Required Solution | โซลูชันที่ต้องการ:**
- ✅ ABC-VEN analysis for drug classification
- ✅ การวิเคราะห์ ABC-VEN สำหรับจัดกลุ่มยา
- ✅ Usage pattern reports with trends
- ✅ รายงานรูปแบบการใช้พร้อมแนวโน้ม
- ✅ Interactive dashboards for decision-making
- ✅ แดชบอร์ดแบบโต้ตอบได้สำหรับการตัดสินใจ

### 4.2 Requirements Summary | สรุปความต้องการ

**Must Have (Critical) | ต้องมี (สำคัญมาก):**
1. ✅ Real-time budget checking and control
2. ✅ FIFO/FEFO lot tracking
3. ✅ 100% Ministry compliance (5 export files)
4. ✅ Multi-location inventory management
5. ✅ Purchase request approval workflow

**Should Have (Important) | ควรมี (สำคัญ):**
1. ⭐ Contract management integration
2. ⭐ ABC-VEN analysis
3. ⭐ Mobile responsive interface
4. ⭐ Expiry alert system
5. ⭐ Vendor performance tracking

**Could Have (Nice to Have) | อาจมี (ดีถ้ามี):**
1. 💡 AI-powered demand forecasting
2. 💡 Barcode scanning integration
3. 💡 Automated reorder suggestions
4. 💡 SMS notifications
5. 💡 Multi-language support

---

## 5. Project Scope | ขอบเขตโครงการ

### 5.1 In Scope | อยู่ในขอบเขต

**System Components | องค์ประกอบของระบบ:**

#### 1. Master Data Management | การจัดการข้อมูลหลัก
- ✅ Drug catalog (Generic + Trade drugs)
- ✅ รายการยา (ยาชื่อสามัญ + ยาชื่อการค้า)
- ✅ Vendor/Company management
- ✅ การจัดการผู้จำหน่าย/บริษัท
- ✅ Location and department setup
- ✅ การตั้งค่าสถานที่และแผนก
- ✅ Budget type configuration
- ✅ การกำหนดค่าประเภทงบประมาณ

#### 2. Budget Management | การจัดการงบประมาณ
- ✅ Annual budget allocation
- ✅ การจัดสรรงบประมาณรายปี
- ✅ Quarterly budget breakdown (Q1-Q4)
- ✅ การแบ่งงบประมาณรายไตรมาส (Q1-Q4)
- ✅ Budget reservation system
- ✅ ระบบจองงบประมาณ
- ✅ Real-time availability checking
- ✅ ตรวจสอบงบประมาณคงเหลือแบบทันที
- ✅ Budget monitoring and reporting
- ✅ การติดตามและรายงานงบประมาณ

#### 3. Procurement Management | การจัดการจัดซื้อ
- ✅ Purchase request workflow
- ✅ กระบวนการขออนุมัติซื้อ
- ✅ Multi-level approval process
- ✅ กระบวนการอนุมัติหลายขั้นตอน
- ✅ Purchase order generation
- ✅ การสร้างใบสั่งซื้อ
- ✅ Goods receiving management
- ✅ การจัดการรับสินค้า
- ✅ Invoice reconciliation
- ✅ การตรวจสอบใบแจ้งหนี้

#### 4. Inventory Management | การจัดการสต็อก
- ✅ Multi-location stock tracking
- ✅ ติดตามสต็อกแบบหลายสถานที่
- ✅ FIFO/FEFO lot management
- ✅ การจัดการล็อตแบบ FIFO/FEFO
- ✅ Expiry date tracking
- ✅ ติดตามวันหมดอายุ
- ✅ Reorder point management
- ✅ การจัดการจุดสั่งซื้อซ้ำ
- ✅ Inventory adjustments and transfers
- ✅ การปรับปรุงและโอนย้ายสต็อก

#### 5. Distribution Management | การจัดการจัดจ่าย
- ✅ Department requisition workflow
- ✅ กระบวนการขอเบิกของแผนก
- ✅ FEFO-based lot selection
- ✅ การเลือกล็อตตามหลัก FEFO
- ✅ Distribution tracking and reporting
- ✅ ติดตามและรายงานการจัดจ่าย

#### 6. Reporting and Analytics | การรายงานและการวิเคราะห์
- ✅ Ministry export files (5 files)
- ✅ ไฟล์ส่งออกให้กระทรวง (5 ไฟล์)
  - DRUGLIST (รายการยา)
  - PURCHASEPLAN (แผนการจัดซื้อ)
  - RECEIPT (ใบรับสินค้า)
  - DISTRIBUTION (ใบจ่ายยา)
  - INVENTORY (สต็อกคงเหลือ)
- ✅ Budget status reports
- ✅ รายงานสถานะงบประมาณ
- ✅ Stock level reports
- ✅ รายงานระดับสต็อก
- ✅ Expiring drugs alerts
- ✅ การแจ้งเตือนยาใกล้หมดอายุ
- ✅ Usage pattern analysis
- ✅ การวิเคราะห์รูปแบบการใช้

### 5.2 Out of Scope | นอกขอบเขต

**Not Included in Current Phase | ไม่รวมอยู่ในระยะปัจจุบัน:**
- ❌ HIS (Hospital Information System) integration
- ❌ การเชื่อมโยงกับระบบสารสนเทศโรงพยาบาล (HIS)
- ❌ Electronic Health Records (EHR) integration
- ❌ การเชื่อมโยงกับระบบบันทึกสุขภาพอิเล็กทรอนิกส์ (EHR)
- ❌ Patient billing integration
- ❌ การเชื่อมโยงกับระบบเรียกเก็บเงินผู้ป่วย
- ❌ Pharmacy dispensing at ward level
- ❌ การจ่ายยาระดับหอผู้ป่วย
- ❌ Clinical decision support
- ❌ ระบบสนับสนุนการตัดสินใจทางคลินิก
- ❌ E-procurement with vendor portals
- ❌ การจัดซื้ออิเล็กทรอนิกส์ร่วมกับผู้จำหน่าย

**Future Considerations | พิจารณาในอนาคต:**
- 🔮 AI-powered demand forecasting
- 🔮 การคาดการณ์ความต้องการด้วยปัญญาประดิษฐ์
- 🔮 Blockchain for supply chain tracking
- 🔮 เทคโนโลยีบล็อกเชนสำหรับติดตามห่วงโซ่อุปทาน
- 🔮 IoT sensors for automated stock counting
- 🔮 เซ็นเซอร์ IoT สำหรับนับสต็อกอัตโนมัติ

---

## 7. Business Rules | กฎทางธุรกิจ

### 7.1 Budget Rules | กฎเกี่ยวกับงบประมาณ

**BR-BUD-001: Budget Allocation**
- Budget must be allocated by fiscal year (October 1 - September 30)
- งบประมาณต้องจัดสรรตามปีงบประมาณ (1 ตุลาคม - 30 กันยายน)
- Total quarterly allocation (Q1+Q2+Q3+Q4) must equal annual budget
- ผลรวมงบประมาณทั้ง 4 ไตรมาส (Q1+Q2+Q3+Q4) ต้องเท่ากับงบประมาณรายปี

**BR-BUD-002: Budget Checking**
- All purchase requests must have sufficient budget before approval
- คำขอซื้อทั้งหมดต้องมีงบประมาณเพียงพอก่อนการอนุมัติ
- Budget check considers current quarter allocation
- การตรวจสอบงบประมาณพิจารณาจากการจัดสรรของไตรมาสปัจจุบัน
- Reserved budget is excluded from available amount
- งบประมาณที่จองไว้จะไม่นับรวมในจำนวนที่พร้อมใช้

**BR-BUD-003: Budget Reservation**
- Budget is auto-reserved when PR is approved
- งบประมาณถูกจองโดยอัตโนมัติเมื่อคำขอซื้อได้รับอนุมัติ
- Reservation expires after 30 days if PO not created
- การจองหมดอายุหลัง 30 วัน หากไม่มีการสร้างใบสั่งซื้อ
- Expired reservations are auto-released
- การจองที่หมดอายุจะถูกปลดล็อกโดยอัตโนมัติ

**BR-BUD-004: Budget Commitment**
- Budget is committed when PO is finalized
- งบประมาณถูกยืนยันเมื่อใบสั่งซื้อแล้วเสร็จ
- Committed budget cannot be used for other purchases
- งบประมาณที่ยืนยันแล้วไม่สามารถใช้สำหรับการซื้ออื่นได้

### 7.2 Inventory Rules | กฎเกี่ยวกับสต็อก

**BR-INV-001: Lot Tracking**
- Every receipt must record lot number and expiry date
- การรับสินค้าทุกครั้งต้องบันทึกหมายเลขล็อตและวันหมดอายุ
- Lot number must be unique per drug per receipt
- หมายเลขล็อตต้องไม่ซ้ำกันสำหรับแต่ละยาในแต่ละครั้งที่รับ

**BR-INV-002: FIFO/FEFO Rules**
- Drug distribution must follow FEFO logic (earliest expiry first)
- การจัดจ่ายยาต้องตามหลัก FEFO (หมดอายุก่อนจ่ายก่อน)
- System shall block selection of expired lots
- ระบบต้องป้องกันการเลือกล็อตที่หมดอายุ
- FIFO applies if expiry dates are equal
- ใช้หลัก FIFO ถ้าวันหมดอายุเท่ากัน

**BR-INV-003: Expiry Alerts**
- Alert 90 days before expiry for critical/expensive drugs (A/V category)
- แจ้งเตือน 90 วันก่อนหมดอายุสำหรับยาสำคัญ/แพง (หมวด A/V)
- Alert 60 days before expiry for medium importance drugs (B category)
- แจ้งเตือน 60 วันก่อนหมดอายุสำหรับยาความสำคัญปานกลาง (หมวด B)
- Alert 30 days before expiry for all drugs
- แจ้งเตือน 30 วันก่อนหมดอายุสำหรับยาทุกรายการ

**BR-INV-004: Stock Levels**
- Minimum stock level must be less than maximum stock level
- ระดับสต็อกขั้นต่ำต้องน้อยกว่าระดับสูงสุด
- Reorder point should be between minimum and maximum
- จุดสั่งซื้อซ้ำควรอยู่ระหว่างขั้นต่ำและสูงสุด
- Low stock alert triggers when stock falls below reorder point
- การแจ้งเตือนสต็อกต่ำจะทำงานเมื่อสต็อกลดต่ำกว่าจุดสั่งซื้อซ้ำ

**BR-INV-005: Inventory Transactions**
- All inventory changes must be recorded with transaction type
- การเปลี่ยนแปลงสต็อกทั้งหมดต้องบันทึกพร้อมประเภทธุรกรรม
- Transaction types: RECEIVE, ISSUE, TRANSFER, ADJUST, RETURN
- ประเภทธุรกรรม: รับ, จ่าย, โอนย้าย, ปรับปรุง, คืน
- Negative stock balance is not allowed
- ไม่อนุญาตให้มียอดคงเหลือติดลบ

### 7.3 Procurement Rules | กฎเกี่ยวกับการจัดซื้อ

**BR-PROC-001: Purchase Request Approval**
- PR amount < 10,000 THB: Department head approval
- คำขอซื้อ < 10,000 บาท: หัวหน้าแผนกอนุมัติ
- PR amount 10,000-100,000 THB: Pharmacy manager + Finance approval
- คำขอซื้อ 10,000-100,000 บาท: หัวหน้าเภสัชกรรม + การเงินอนุมัติ
- PR amount > 100,000 THB: Pharmacy manager + Finance + Director approval
- คำขอซื้อ > 100,000 บาท: หัวหน้าเภสัชกรรม + การเงิน + ผู้อำนวยการอนุมัติ

**BR-PROC-002: Purchase Order**
- PO can only be created from approved PR
- ใบสั่งซื้อสามารถสร้างได้จากคำขอซื้อที่อนุมัติแล้วเท่านั้น
- PO amount cannot exceed PR approved amount
- จำนวนเงินในใบสั่งซื้อต้องไม่เกินจำนวนที่อนุมัติในคำขอซื้อ
- PO must have valid vendor
- ใบสั่งซื้อต้องระบุผู้จำหน่ายที่ถูกต้อง

**BR-PROC-003: Goods Receiving**
- Goods can only be received against valid PO
- สามารถรับสินค้าได้จากใบสั่งซื้อที่ถูกต้องเท่านั้น
- Received quantity cannot exceed PO quantity
- ปริมาณที่รับต้องไม่เกินปริมาณในใบสั่งซื้อ
- Partial receiving is allowed
- อนุญาตให้รับสินค้าเป็นบางส่วนได้

### 7.4 Distribution Rules | กฎเกี่ยวกับการจัดจ่าย

**BR-DIST-001: Distribution Request**
- Only authorized departments can request distribution
- เฉพาะแผนกที่ได้รับอนุญาตเท่านั้นที่สามารถขอจัดจ่ายได้
- Distribution request must specify required quantity
- คำขอจัดจ่ายต้องระบุปริมาณที่ต้องการ

**BR-DIST-002: Distribution Fulfillment**
- Distribution must use FEFO lot selection
- การจัดจ่ายต้องใช้การเลือกล็อตตามหลัก FEFO
- Cannot distribute from expired lots
- ไม่สามารถจัดจ่ายจากล็อตที่หมดอายุได้
- Source location must have sufficient stock
- สถานที่ต้นทางต้องมีสต็อกเพียงพอ

---

## 8. Compliance Requirements | ข้อกำหนดด้านกฎระเบียบ

### 8.1 Ministry of Public Health Requirements
**ข้อกำหนดของกระทรวงสาธารณสุข**

**DMSIC Standards พ.ศ. 2568:**
- ✅ 100% compliance with 79 required fields across 5 export files
- ✅ สอดคล้องครบ 100% กับฟิลด์ที่กำหนด 79 ฟิลด์ใน 5 ไฟล์ส่งออก

**Required Export Files:**
1. **DRUGLIST** - Drug Catalog (11 fields)
   - Drug code, name, manufacturer, NLEM status, etc.
   - รหัสยา, ชื่อ, ผู้ผลิต, สถานะ NLEM เป็นต้น

2. **PURCHASEPLAN** - Purchase Planning (20 fields)
   - Annual/quarterly purchase planning data
   - ข้อมูลการวางแผนจัดซื้อรายปี/รายไตรมาส

3. **RECEIPT** - Goods Receiving (22 fields)
   - Receipt details, lot information, expiry dates
   - รายละเอียดการรับสินค้า, ข้อมูลล็อต, วันหมดอายุ

4. **DISTRIBUTION** - Drug Distribution (11 fields)
   - Distribution to departments/wards
   - การจัดจ่ายให้แผนก/หอผู้ป่วย

5. **INVENTORY** - Stock Status (15 fields)
   - Current inventory levels by location
   - ระดับสต็อกปัจจุบันจำแนกตามสถานที่

**TMT Integration:**
- Support Thai Medical Terminology (TMT) code mapping
- รองรับการเชื่อมโยงรหัสศัพท์ทางการแพทย์ไทย (TMT)
- 25,991 TMT concepts in database
- มี 25,991 แนวคิด TMT ในฐานข้อมูล

### 8.2 Financial Regulations
**ข้อกำหนดด้านการเงิน**

**Budget Control:**
- Comply with Government Budget Act B.E. 2561
- ปฏิบัติตามพระราชบัญญัติวิธีการงบประมาณ พ.ศ. 2561
- Fiscal year: October 1 - September 30
- ปีงบประมาณ: 1 ตุลาคม - 30 กันยายน

**Procurement Regulations:**
- Follow Procurement Regulations B.E. 2560
- ปฏิบัติตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้าง พ.ศ. 2560
- Maintain complete audit trail
- รักษาร่องรอยการตรวจสอบที่สมบูรณ์

### 8.3 Data Protection (PDPA)
**การคุ้มครองข้อมูลส่วนบุคคล**

**Personal Data Protection Act B.E. 2562:**
- Protect employee and vendor personal data
- ปกป้องข้อมูลส่วนบุคคลของพนักงานและผู้จำหน่าย
- Implement proper access controls
- ใช้มาตรการควบคุมการเข้าถึงที่เหมาะสม
- Maintain data processing records
- จัดเก็บบันทึกการประมวลผลข้อมูล

### 8.4 Audit Requirements
**ข้อกำหนดการตรวจสอบ**

**Audit Trail:**
- Record all transactions with timestamp and user
- บันทึกธุรกรรมทั้งหมดพร้อมเวลาและผู้ใช้
- Log all approval actions
- บันทึกการอนุมัติทั้งหมด
- Maintain change history for critical data
- จัดเก็บประวัติการเปลี่ยนแปลงสำหรับข้อมูลสำคัญ

**Document Retention:**
- Keep transaction records for 10 years
- เก็บรักษาบันทึกธุรกรรม 10 ปี
- Maintain budget documents per fiscal year
- จัดเก็บเอกสารงบประมาณตามปีงบประมาณ

---

## 9. User Roles and Permissions | บทบาทและสิทธิ์ผู้ใช้

### 9.1 Role Definitions | คำจำกัดความของบทบาท

#### System Administrator | ผู้ดูแลระบบ
**Responsibilities | ความรับผิดชอบ:**
- System configuration and maintenance
- การตั้งค่าและบำรุงรักษาระบบ
- User management
- การจัดการผู้ใช้
- Master data setup
- การตั้งค่าข้อมูลหลัก

**Permissions | สิทธิ์:**
- ✅ Full access to all modules
- ✅ Manage users and roles
- ✅ Configure system settings
- ✅ View audit logs

#### Pharmacy Manager | หัวหน้าเภสัชกรรม
**Responsibilities | ความรับผิดชอบ:**
- Drug catalog management
- การจัดการรายการยา
- Purchase request approval
- การอนุมัติคำขอซื้อ
- Inventory oversight
- การดูแลสต็อก

**Permissions | สิทธิ์:**
- ✅ Approve purchase requests
- ✅ Manage drug catalog
- ✅ View all inventory reports
- ✅ Configure inventory parameters

#### Pharmacist | เภสัชกร
**Responsibilities | ความรับผิดชอบ:**
- Goods receiving
- การรับสินค้า
- Drug distribution
- การจัดจ่ายยา
- Inventory management
- การจัดการสต็อก

**Permissions | สิทธิ์:**
- ✅ Receive goods
- ✅ Create distribution orders
- ✅ View inventory
- ✅ Adjust inventory (with approval)

#### Procurement Officer | เจ้าหน้าที่พัสดุ
**Responsibilities | ความรับผิดชอบ:**
- Create purchase requests
- สร้างคำขอซื้อ
- Generate purchase orders
- สร้างใบสั่งซื้อ
- Vendor management
- การจัดการผู้จำหน่าย

**Permissions | สิทธิ์:**
- ✅ Create and edit purchase requests
- ✅ Create purchase orders
- ✅ Manage vendor information
- ✅ View budget availability

#### Finance Officer | เจ้าหน้าที่การเงิน
**Responsibilities | ความรับผิดชอบ:**
- Budget management
- การจัดการงบประมาณ
- Budget approval
- การอนุมัติงบประมาณ
- Financial reporting
- การรายงานทางการเงิน

**Permissions | สิทธิ์:**
- ✅ Create budget allocations
- ✅ Approve budget requests
- ✅ View financial reports
- ✅ Monitor budget utilization

#### Department Staff | เจ้าหน้าที่แผนก
**Responsibilities | ความรับผิดชอบ:**
- Request drug distribution
- ขอจัดจ่ายยา
- View department inventory
- ดูสต็อกของแผนก

**Permissions | สิทธิ์:**
- ✅ Create distribution requests
- ✅ View department stock
- 🚫 Cannot approve or receive goods

### 9.2 Permission Matrix | ตารางสิทธิ์การใช้งาน

| Function | Admin | Pharmacy Manager | Pharmacist | Procurement | Finance | Dept Staff |
|----------|-------|-----------------|------------|-------------|---------|------------|
| User Management | ✅ | 🚫 | 🚫 | 🚫 | 🚫 | 🚫 |
| Drug Catalog | ✅ | ✅ | 👁️ | 👁️ | 👁️ | 👁️ |
| Create PR | ✅ | ✅ | ✅ | ✅ | 🚫 | 🚫 |
| Approve PR | ✅ | ✅ | 🚫 | 🚫 | ✅ | 🚫 |
| Create PO | ✅ | ✅ | 🚫 | ✅ | 🚫 | 🚫 |
| Receive Goods | ✅ | ✅ | ✅ | 🚫 | 🚫 | 🚫 |
| Distribute Drugs | ✅ | ✅ | ✅ | 🚫 | 🚫 | 🚫 |
| Request Distribution | ✅ | ✅ | ✅ | 🚫 | 🚫 | ✅ |
| Budget Allocation | ✅ | 🚫 | 🚫 | 🚫 | ✅ | 🚫 |
| View Reports | ✅ | ✅ | 👁️ | 👁️ | ✅ | 👁️ |

**Legend:**
- ✅ = Full Access (เข้าถึงได้เต็มรูปแบบ)
- 👁️ = View Only (ดูได้อย่างเดียว)
- 🚫 = No Access (ไม่มีสิทธิ์)

---

## 10. Success Criteria | เกณฑ์ความสำเร็จ

### 10.1 Technical Success Criteria
**เกณฑ์ความสำเร็จด้านเทคนิค**

**System Performance:**
- ⚡ Page load time < 2 seconds
- ⚡ เวลาโหลดหน้าจอ < 2 วินาที
- ⚡ API response time < 500ms for 95% of requests
- ⚡ เวลาตอบสนอง API < 500 มิลลิวินาทีสำหรับ 95% ของคำขอ
- ⚡ System uptime > 99.5%
- ⚡ ระบบใช้งานได้ > 99.5% ของเวลา

**Data Accuracy:**
- ✅ 100% accuracy in ministry export files
- ✅ ความถูกต้อง 100% ในไฟล์ส่งออกให้กระทรวง
- ✅ Zero negative stock balances
- ✅ ไม่มียอดคงเหลือติดลบ
- ✅ Budget calculation accuracy > 99.99%
- ✅ ความแม่นยำการคำนวณงบประมาณ > 99.99%

**Security:**
- 🔐 All sensitive data encrypted at rest and in transit
- 🔐 ข้อมูลสำคัญทั้งหมดเข้ารหัสทั้งการจัดเก็บและการส่งผ่าน
- 🔐 Role-based access control implemented
- 🔐 ใช้การควบคุมการเข้าถึงตามบทบาท
- 🔐 Complete audit trail for all transactions
- 🔐 มีร่องรอยการตรวจสอบครบถ้วนทุกธุรกรรม

### 10.2 Business Success Criteria
**เกณฑ์ความสำเร็จด้านธุรกิจ**

**Operational Efficiency:**
- 📈 50% reduction in PR processing time (from 3 days to 1.5 days)
- 📈 ลดเวลาประมวลผลคำขอซื้อลง 50% (จาก 3 วัน เหลือ 1.5 วัน)
- 📈 30% reduction in drug expiry waste
- 📈 ลดการสูญเสียจากยาหมดอายุลง 30%
- 📈 20% improvement in budget utilization
- 📈 เพิ่มประสิทธิภาพการใช้งบประมาณขึ้น 20%

**Compliance:**
- ✅ 100% on-time ministry report submission
- ✅ ส่งรายงานให้กระทรวงตรงเวลา 100%
- ✅ Zero compliance violations
- ✅ ไม่มีการฝ่าฝืนกฎระเบียบ
- ✅ Pass external audit with no major findings
- ✅ ผ่านการตรวจสอบจากภายนอกโดยไม่มีข้อบกพร่องสำคัญ

**User Adoption:**
- 👥 80% user adoption within 3 months
- 👥 ผู้ใช้ 80% เริ่มใช้งานภายใน 3 เดือน
- 👥 User satisfaction score > 4.0/5.0
- 👥 คะแนนความพึงพอใจของผู้ใช้ > 4.0/5.0
- 👥 < 5 support tickets per week after 3 months
- 👥 < 5 คำร้องขอความช่วยเหลือต่อสัปดาห์หลัง 3 เดือน

**Cost Savings:**
- 💰 500,000-1,000,000 THB/year reduction in expired drug waste
- 💰 ลดการสูญเสียจากยาหมดอายุ 500,000-1,000,000 บาท/ปี
- 💰 100,000 THB/year reduction in manual report preparation
- 💰 ลดค่าใช้จ่ายในการทำรายงานด้วยมือ 100,000 บาท/ปี

---

## 11. Assumptions and Constraints | สมมติฐานและข้อจำกัด

### 11.1 Assumptions | สมมติฐาน

**Technical Assumptions:**
- Users have modern web browsers (Chrome, Firefox, Safari, Edge)
- ผู้ใช้มีเว็บเบราว์เซอร์รุ่นใหม่ (Chrome, Firefox, Safari, Edge)
- Internet connectivity available at all work locations
- มีอินเทอร์เน็ตที่สถานที่ทำงานทุกแห่ง
- PostgreSQL database server available
- มีเซิร์ฟเวอร์ฐานข้อมูล PostgreSQL พร้อมใช้งาน
- Docker infrastructure available for deployment
- มีโครงสร้างพื้นฐาน Docker สำหรับการติดตั้ง

**Business Assumptions:**
- Users will receive adequate training
- ผู้ใช้จะได้รับการฝึกอบรมอย่างเพียงพอ
- Legacy data can be migrated successfully
- สามารถย้ายข้อมูลจากระบบเดิมได้สำเร็จ
- Vendors will continue using current communication methods
- ผู้จำหน่ายจะใช้วิธีการสื่อสารปัจจุบันต่อไป
- Ministry reporting requirements remain stable
- ข้อกำหนดการรายงานให้กระทรวงคงที่

### 11.2 Constraints | ข้อจำกัด

**Technical Constraints:**
- Must use existing hospital IT infrastructure
- ต้องใช้โครงสร้างพื้นฐานเทคโนโลยีสารสนเทศของโรงพยาบาลที่มีอยู่
- Database schema cannot exceed 100 tables
- โครงสร้างฐานข้อมูลต้องไม่เกิน 100 ตาราง
- Must be compatible with Windows Server 2019+
- ต้องสามารถทำงานร่วมกับ Windows Server 2019 ขึ้นไป
- Response time must support 100 concurrent users
- เวลาตอบสนองต้องรองรับผู้ใช้พร้อมกัน 100 คน

**Budget Constraints:**
- Limited development budget
- งบประมาณสำหรับการพัฒนามีจำกัด
- Cannot purchase expensive third-party software
- ไม่สามารถซื้อซอฟต์แวร์จากบริษัทอื่นที่ราคาแพงได้
- Must use open-source technologies where possible
- ต้องใช้เทคโนโลยีโอเพนซอร์สเท่าที่เป็นไปได้

**Time Constraints:**
- Must complete Phase 1 (Database) before Q2 2025
- ต้องเสร็จสิ้นระยะที่ 1 (ฐานข้อมูล) ก่อน Q2 2025
- Full system must be operational by Q1 2026
- ระบบเต็มรูปแบบต้องพร้อมใช้งานภายใน Q1 2026

**Regulatory Constraints:**
- Must comply with all government regulations
- ต้องปฏิบัติตามกฎระเบียบของรัฐบาลทั้งหมด
- Cannot modify ministry export file formats
- ไม่สามารถแก้ไขรูปแบบไฟล์ส่งออกให้กระทรวงได้

---

## 12. Risks and Mitigation | ความเสี่ยงและการบริหารจัดการ

### 12.1 High Risk | ความเสี่ยงสูง

#### Risk 1: Data Migration Failure
**ความเสี่ยงที่ 1: การย้ายข้อมูลล้มเหลว**

**Description | คำอธิบาย:**
Legacy data may have inconsistencies or missing values that prevent successful migration.

ข้อมูลจากระบบเดิมอาจมีความไม่สอดคล้องหรือมีค่าที่ขาดหายไป ซึ่งทำให้การย้ายข้อมูลล้มเหลว

**Impact | ผลกระทบ:**
- ⚠️ Project delay of 1-2 months
- ⚠️ โครงการล่าช้า 1-2 เดือน
- ⚠️ Incomplete drug catalog
- ⚠️ รายการยาไม่สมบูรณ์
- ⚠️ Missing historical data
- ⚠️ ข้อมูลย้อนหลังสูญหาย

**Mitigation | การลดความเสี่ยง:**
- ✅ Perform data quality assessment before migration
- ✅ ประเมินคุณภาพข้อมูลก่อนทำการย้าย
- ✅ Create comprehensive data cleaning scripts
- ✅ สร้างสคริปต์ทำความสะอาดข้อมูลอย่างครอบคลุม
- ✅ Run pilot migration with sample data
- ✅ ทดลองย้ายข้อมูลตัวอย่างก่อน
- ✅ Have manual data entry backup plan
- ✅ มีแผนสำรองการป้อนข้อมูลด้วยมือ

#### Risk 2: User Resistance
**ความเสี่ยงที่ 2: ผู้ใช้ต่อต้านการเปลี่ยนแปลง**

**Description | คำอธิบาย:**
Staff may resist adopting new system due to comfort with legacy system.

พนักงานอาจต่อต้านการใช้ระบบใหม่เนื่องจากคุ้นเคยกับระบบเดิม

**Impact | ผลกระทบ:**
- ⚠️ Low user adoption rate
- ⚠️ อัตราการยอมรับของผู้ใช้ต่ำ
- ⚠️ Parallel use of old and new systems
- ⚠️ ใช้ระบบเก่าและระบบใหม่ควบคู่กัน
- ⚠️ Data entry errors
- ⚠️ ข้อผิดพลาดในการป้อนข้อมูล

**Mitigation | การลดความเสี่ยง:**
- ✅ Involve key users in design phase
- ✅ ให้ผู้ใช้หลักมีส่วนร่วมในขั้นตอนการออกแบบ
- ✅ Provide comprehensive training program
- ✅ จัดการฝึกอบรมอย่างครอบคลุม
- ✅ Create user-friendly interface
- ✅ สร้างส่วนติดต่อผู้ใช้ที่ใช้งานง่าย
- ✅ Have champions in each department
- ✅ มีผู้สนับสนุนในแต่ละแผนก
- ✅ Implement gradual rollout plan
- ✅ นำระบบไปใช้ทีละขั้นตอน

#### Risk 3: Budget Overrun
**ความเสี่ยงที่ 3: ใช้งบประมาณเกิน**

**Description | คำอธิบาย:**
Project may exceed allocated budget due to scope creep or technical challenges.

โครงการอาจใช้งบประมาณเกินที่กำหนดเนื่องจากขอบเขตขยายหรือปัญหาทางเทคนิค

**Impact | ผลกระทบ:**
- ⚠️ Project delays or incomplete features
- ⚠️ โครงการล่าช้าหรือฟีเจอร์ไม่สมบูรณ์
- ⚠️ Additional budget requests required
- ⚠️ ต้องขอเพิ่มงบประมาณ

**Mitigation | การลดความเสี่ยง:**
- ✅ Clear scope definition with priorities
- ✅ กำหนดขอบเขตที่ชัดเจนพร้อมลำดับความสำคัญ
- ✅ Regular budget monitoring
- ✅ ติดตามงบประมาณสม่ำเสมอ
- ✅ Use agile approach for flexibility
- ✅ ใช้วิธีการแบบอไจล์เพื่อความยืดหยุ่น
- ✅ Focus on must-have features first
- ✅ มุ่งเน้นฟีเจอร์ที่จำเป็นต้องมีก่อน

### 12.2 Medium Risk | ความเสี่ยงปานกลาง

#### Risk 4: Integration Complexity
**ความเสี่ยงที่ 4: ความซับซ้อนในการเชื่อมโยง**

**Description | คำอธิบาย:**
Future integration with HIS or other systems may be more complex than anticipated.

การเชื่อมโยงกับ HIS หรือระบบอื่นในอนาคตอาจซับซ้อนกว่าที่คาดการณ์

**Mitigation | การลดความเสี่ยง:**
- ✅ Design with integration points in mind
- ✅ ออกแบบโดยคำนึงถึงจุดเชื่อมโยง
- ✅ Use standard APIs and data formats
- ✅ ใช้ API และรูปแบบข้อมูลมาตรฐาน
- ✅ Document all interfaces thoroughly
- ✅ จัดทำเอกสารอินเทอร์เฟซทั้งหมดอย่างละเอียด

#### Risk 5: Performance Issues
**ความเสี่ยงที่ 5: ปัญหาด้านประสิทธิภาพ**

**Description | คำอธิบาย:**
System may experience slow performance with large data volumes.

ระบบอาจทำงานช้าเมื่อมีข้อมูลจำนวนมาก

**Mitigation | การลดความเสี่ยง:**
- ✅ Implement proper database indexing
- ✅ ใช้การจัดทำดัชนีฐานข้อมูลที่เหมาะสม
- ✅ Use caching strategies (Redis)
- ✅ ใช้กลยุทธ์แคช (Redis)
- ✅ Conduct load testing before go-live
- ✅ ทดสอบภาระก่อนเปิดใช้งานจริง
- ✅ Optimize SQL queries
- ✅ ปรับปรุงคำสั่ง SQL ให้มีประสิทธิภาพ

### 12.3 Low Risk | ความเสี่ยงต่ำ

#### Risk 6: Vendor Changes
**ความเสี่ยงที่ 6: การเปลี่ยนแปลงของผู้จำหน่าย**

**Description | คำอธิบาย:**
Vendors may change contact information or go out of business.

ผู้จำหน่ายอาจเปลี่ยนข้อมูลติดต่อหรือปิดกิจการ

**Mitigation | การลดความเสี่ยง:**
- ✅ Maintain updated vendor database
- ✅ ปรับปรุงฐานข้อมูลผู้จำหน่ายให้เป็นปัจจุบัน
- ✅ Allow soft deletion to preserve history
- ✅ อนุญาตให้ลบแบบ Soft เพื่อรักษาประวัติ

---

## 13. Appendices | ภาคผนวก

### 13.1 Glossary | อภิธานศัพท์

**ABC Analysis | การวิเคราะห์ ABC**
- Classification of drugs by value: A (high), B (medium), C (low)
- การจัดกลุ่มยาตามมูลค่า: A (สูง), B (ปานกลาง), C (ต่ำ)

**DMSIC (Drug and Medical Supply Information Center)**
- กรมบัญชีกลาง - Drug and Medical Supply Information Center
- กระทรวงการคลัง - ศูนย์ข้อมูลยาและเวชภัณฑ์

**FEFO (First Expire First Out)**
- Inventory management method that dispenses drugs with earliest expiry date first
- วิธีการจัดการสต็อกที่จ่ายยาที่หมดอายุก่อนออกก่อน

**FIFO (First In First Out)**
- Inventory management method that dispenses drugs received first
- วิธีการจัดการสต็อกที่จ่ายยาที่เข้ามาก่อนออกก่อน

**Fiscal Year | ปีงบประมาณ**
- Budget year from October 1 to September 30
- ปีงบประมาณตั้งแต่ 1 ตุลาคม ถึง 30 กันยายน

**Generic Drug | ยาชื่อสามัญ**
- Drug identified by its active pharmaceutical ingredient (API)
- ยาที่ระบุด้วยส่วนผสมสำคัญทางยา (API)

**HIS (Hospital Information System)**
- Comprehensive system managing all hospital operations
- ระบบสารสนเทศโรงพยาบาลแบบครบวงจร

**Lot Number**
- Unique identifier for a batch of drugs from manufacturer
- รหัสเฉพาะสำหรับยาแต่ละชุดจากผู้ผลิต

**NLEM (National List of Essential Medicines)**
- Government's list of essential drugs (E = Essential, N = Non-essential)
- บัญชียาหลักแห่งชาติ (E = จำเป็น, N = ไม่จำเป็น)

**PDPA (Personal Data Protection Act B.E. 2562)**
- Thai law protecting personal data privacy
- พระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562

**PO (Purchase Order) | ใบสั่งซื้อ**
- Official order to vendor to supply goods
- เอกสารสั่งซื้อสินค้าอย่างเป็นทางการจากผู้จำหน่าย

**PR (Purchase Request) | คำขอซื้อ**
- Internal request to procure goods
- คำขอภายในเพื่อจัดซื้อสินค้า

**TMT (Thai Medical Terminology)**
- Standard medical terminology system in Thai language
- ระบบศัพท์ทางการแพทย์มาตรฐานภาษาไทย

**Trade Drug | ยาชื่อการค้า**
- Branded drug product from manufacturer
- ผลิตภัณฑ์ยาชื่อการค้าจากผู้ผลิต

**VEN Analysis**
- Classification by criticality: V (Vital), E (Essential), N (Non-essential)
- การจัดกลุ่มตามความสำคัญ: V (สำคัญยิ่ง), E (จำเป็น), N (ไม่จำเป็น)

### 13.2 References | เอกสารอ้างอิง

**Government Regulations:**
1. พระราชบัญญัติวิธีการงบประมาณ พ.ศ. 2561 (Government Budget Act B.E. 2561)
2. ระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 (Procurement Regulations B.E. 2560)
3. พระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562 (Personal Data Protection Act B.E. 2562)

**Ministry Standards:**
1. DMSIC Standards พ.ศ. 2568 - Drug and Medical Supply Information Standards
2. Thai Medical Terminology (TMT) - ศัพท์ทางการแพทย์ไทย
3. NLEM List - บัญชียาหลักแห่งชาติ

**Technical Documentation:**
1. PostgreSQL 15 Documentation
2. Prisma ORM Documentation
3. Angular 20 Documentation
4. Fastify 5 Documentation

**Project Documents:**
1. INVS Modern - README.md
2. INVS Modern - PROJECT_STATUS.md
3. INVS Modern - Technical Requirements Document (TRD)
4. INVS Modern - Database Design Documentation
5. Legacy INVS Manual Analysis

### 13.3 Document History | ประวัติเอกสาร

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1 | 2025-01-15 | INVS Team | Initial draft |
| 0.2 | 2025-01-18 | INVS Team | Added compliance requirements |
| 1.0.0 | 2025-01-22 | INVS Team | Final version for review |

### 13.4 Approval | การอนุมัติ

**Document Status:** Draft for Review | ร่างสำหรับพิจารณา

**Approval Required From:**
- [ ] Hospital Director (ผู้อำนวยการโรงพยาบาล)
- [ ] Pharmacy Manager (หัวหน้าเภสัชกรรม)
- [ ] Finance Manager (หัวหน้าการเงิน)
- [ ] IT Manager (หัวหน้าเทคโนโลยีสารสนเทศ)
- [ ] Procurement Manager (หัวหน้าพัสดุ)

---

## Contact Information | ข้อมูลการติดต่อ

**Project Team:**
- Project Manager: [Name]
- Technical Lead: [Name]
- Business Analyst: [Name]

**For Questions or Feedback:**
- Email: invs-modern@hospital.go.th
- Phone: [TBD]
- Project Repository: /invs-modern

---

**END OF DOCUMENT | สิ้นสุดเอกสาร**

*Document prepared using INVS Manual, legacy database analysis, and Ministry of Public Health standards*

*เอกสารนี้จัดทำโดยอ้างอิงจากคู่มือ INVS, การวิเคราะห์ฐานข้อมูลระบบเดิม และมาตรฐานของกระทรวงสาธารณสุข*