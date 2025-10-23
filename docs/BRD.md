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
INVS Modern เป็นระบบบริหารจัดการพัสดุยาและเวชภัณฑ์โรงพยาบาลแบบครบวงจร ออกแบบมาเพื่อพัฒนาและปรับปรุงกระบวนการจัดซื้อ การควบคุมสต็อก และการจัดจ่ายยา เพื่อทดแทนระบบ INVS เดิมด้วยโซลูชันที่ทันสมัย ขยายได้ และตรงตามมาตรฐาน

### 1.2 Business Objectives | วัตถุประสงค์ทางธุรกิจ

1. **Improve Budget Control** | **ปรับปรุงการควบคุมงบประมาณ**
   - Real-time budget checking and reservation system
   - ระบบตรวจสอบและจองงบประมาณแบบเรียลไทม์
   - Quarterly budget allocation and monitoring
   - การจัดสรรและติดตามงบประมาณรายไตรมาส

2. **Enhance Inventory Accuracy** | **เพิ่มความแม่นยำของสต็อกสินค้า**
   - FIFO/FEFO lot tracking to minimize waste
   - ระบบติดตาม Lot แบบ FIFO/FEFO เพื่อลดของเสีย
   - Multi-location inventory management
   - การจัดการสต็อกหลายสถานที่

3. **Ensure Ministry Compliance** | **รับรองความถูกต้องตามกระทรวง**
   - 100% compliance with DMSIC Standards พ.ศ. 2568
   - ปฏิบัติตามมาตรฐาน DMSIC พ.ศ. 2568 ครบ 100%
   - 5 mandatory export files for Ministry of Public Health
   - ไฟล์ส่งออก 5 ไฟล์ตามที่กระทรวงสาธารณสุขกำหนด

4. **Streamline Procurement Process** | **ปรับปรุงกระบวนการจัดซื้อ**
   - Automated purchase request workflows
   - ระบบขออนุมัติซื้อแบบอัตโนมัติ
   - Integration with contract management
   - บูรณาการกับระบบสัญญาจัดซื้อ

5. **Support Data-Driven Decisions** | **สนับสนุนการตัดสินใจด้วยข้อมูล**
   - Comprehensive reporting and analytics
   - รายงานและการวิเคราะห์ข้อมูลที่ครอบคลุม
   - Drug usage pattern analysis (ABC-VEN)
   - การวิเคราะห์รูปแบบการใช้ยา (ABC-VEN)

### 1.3 Expected Benefits | ประโยชน์ที่คาดว่าจะได้รับ

**Operational Benefits | ประโยชน์ด้านการดำเนินงาน:**
- ⏱️ 50% reduction in purchase request processing time
- ⏱️ ลดเวลาในการประมวลผลคำขอซื้อ 50%
- 📉 30% reduction in expired drug waste
- 📉 ลดของเสียจากยาหมดอายุ 30%
- 💰 20% improvement in budget utilization
- 💰 เพิ่มประสิทธิภาพการใช้งบประมาณ 20%

**Compliance Benefits | ประโยชน์ด้านกฎระเบียบ:**
- ✅ 100% accurate ministry reporting
- ✅ ความถูกต้อง 100% ในการรายงานกระทรวง
- 🔐 Full audit trail for all transactions
- 🔐 บันทึกการตรวจสอบครบถ้วนทุกธุรกรรม

**Strategic Benefits | ประโยชน์เชิงกลยุทธ์:**
- 📊 Better demand forecasting and planning
- 📊 การคาดการณ์และวางแผนความต้องการที่ดีขึ้น
- 🔄 Improved vendor relationship management
- 🔄 การบริหารจัดการความสัมพันธ์กับผู้ขายที่ดีขึ้น

---

## 2. Project Information | ข้อมูลโครงการ

### 2.1 Project Timeline | ระยะเวลาโครงการ

| Phase | Duration | Status |
|-------|----------|--------|
| **Phase 1: Database & Schema** | 3 months | ✅ Complete |
| ระยะที่ 1: ฐานข้อมูลและโครงสร้าง | 3 เดือน | เสร็จสมบูรณ์ |
| **Phase 2: Backend API** | 4 months | 🚧 Planned |
| ระยะที่ 2: Backend API | 4 เดือน | วางแผนไว้ |
| **Phase 3: Frontend Application** | 5 months | 🚧 Planned |
| ระยะที่ 3: แอปพลิเคชัน Frontend | 5 เดือน | วางแผนไว้ |
| **Phase 4: Testing & Deployment** | 2 months | 🚧 Planned |
| ระยะที่ 4: ทดสอบและติดตั้ง | 2 เดือน | วางแผนไว้ |

**Total Project Duration:** 14 months  
**ระยะเวลาโครงการทั้งหมด:** 14 เดือน

### 2.2 Project Stakeholders | ผู้มีส่วนได้ส่วนเสีย

**Primary Stakeholders | ผู้มีส่วนได้ส่วนเสียหลัก:**
- 🏥 Hospital Management (ผู้บริหารโรงพยาบาล)
- 💊 Pharmacy Department (แผนกเภสัชกรรม)
- 💰 Finance Department (แผนกการเงิน)
- 📦 Procurement Department (แผนกจัดซื้อ)
- 🏥 Clinical Departments (แผนกคลินิก)

**Secondary Stakeholders | ผู้มีส่วนได้ส่วนเสียรอง:**
- 📋 Ministry of Public Health (กระทรวงสาธารณสุข)
- 🏢 Vendors and Suppliers (ผู้ขายและซัพพลายเออร์)
- 👨‍💻 IT Department (แผนกไอที)

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
| การบำรุงรักษา (ปีที่ 1) | |

---

## 3. Business Overview | ภาพรวมธุรกิจ

### 3.1 Current Environment | สภาพแวดล้อมปัจจุบัน

**Legacy System | ระบบเดิม:**
- Name: INVS (Inventory Management System)
- ชื่อ: ระบบบริหารจัดการพัสดุ INVS
- Database: MySQL (133 tables)
- ฐานข้อมูล: MySQL (133 ตาราง)
- Age: 10+ years
- อายุ: มากกว่า 10 ปี
- Status: Outdated, difficult to maintain, lacks modern features
- สถานะ: ล้าสมัย บำรุงรักษายาก ขาดฟีเจอร์ทันสมัย

**Key Challenges with Legacy System | ปัญหาหลักของระบบเดิม:**

1. **No Real-time Budget Control**
   - ไม่มีการควบคุมงบประมาณแบบเรียลไทม์
   - Budget overruns are common
   - การใช้งบประมาณเกินเกิดขึ้นบ่อย

2. **Limited Contract Management**
   - ระบบบริหารสัญญาจำกัด
   - No integration with procurement workflow
   - ไม่มีการบูรณาการกับกระบวนการจัดซื้อ

3. **Manual Ministry Reporting**
   - การรายงานกระทรวงแบบ Manual
   - Time-consuming and error-prone
   - ใช้เวลานานและมีข้อผิดพลาด

4. **Weak Inventory Tracking**
   - การติดตามสต็อกไม่เข้มแข็ง
   - Lot tracking is incomplete
   - การติดตาม Lot ไม่ครบถ้วน
   - Expiry management is manual
   - การจัดการวันหมดอายุเป็นแบบ Manual

5. **No Mobile Access**
   - ไม่มีการเข้าถึงผ่านมือถือ
   - Desktop-only system
   - ระบบใช้งานได้เฉพาะคอมพิวเตอร์เท่านั้น

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
| ใบรับของ | 5-10 | 150-300 | 1,800-3,600 |
| Drug Distributions | 20-30 | 600-900 | 7,200-10,800 |
| ใบจ่ายยา | 20-30 | 600-900 | 7,200-10,800 |
| Inventory Adjustments | 2-5 | 60-150 | 720-1,800 |
| การปรับปรุงสต็อก | 2-5 | 60-150 | 720-1,800 |

**Master Data Volume | ปริมาณข้อมูลหลัก:**
- Drug Generics: ~1,100 items (ยาชื่อสามัญ)
- Trade Drugs: ~1,200 items (ยาชื่อการค้า)
- Active Lots: ~3,000-5,000 lots (Lot ที่ใช้งาน)
- Vendors: ~100 companies (ผู้ขาย)

---

## 4. Problems and Requirements | ปัญหาและความต้องการ

### 4.1 Problem Statements | การกำหนดปัญหา

#### Problem 1: Lack of Real-time Budget Control
**ปัญหาที่ 1: ขาดการควบคุมงบประมาณแบบเรียลไทม์**

**Current Situation | สถานการณ์ปัจจุบัน:**
- Budget checking is done manually before each purchase
- การตรวจสอบงบประมาณทำแบบ Manual ก่อนการซื้อแต่ละครั้ง
- No automated reservation system
- ไม่มีระบบจองงบอัตโนมัติ
- Budget overruns discovered too late
- ค้นพบการใช้งบเกินเมื่อสายเกินไป

**Impact | ผลกระทบ:**
- 💰 15-20% budget overruns per year
- 💰 ใช้งบเกิน 15-20% ต่อปี
- ⏰ 2-3 hours daily spent on manual checking
- ⏰ ใช้เวลาตรวจสอบ Manual 2-3 ชั่วโมงต่อวัน
- 📉 Poor budget utilization (unused allocations)
- 📉 การใช้งบไม่มีประสิทธิภาพ (งบที่ไม่ถูกใช้)

**Required Solution | โซลูชันที่ต้องการ:**
- ✅ Real-time budget availability checking
- ✅ ตรวจสอบงบคงเหลือแบบเรียลไทม์
- ✅ Automatic budget reservation for pending PRs
- ✅ จองงบอัตโนมัติสำหรับคำขอซื้อที่รอการอนุมัติ
- ✅ Quarterly budget monitoring dashboard
- ✅ แดชบอร์ดติดตามงบประมาณรายไตรมาส

#### Problem 2: Incomplete Lot Tracking and Expiry Management
**ปัญหาที่ 2: การติดตาม Lot และวันหมดอายุไม่สมบูรณ์**

**Current Situation | สถานการณ์ปัจจุบัน:**
- Lot numbers recorded but not enforced in dispensing
- บันทึก Lot แต่ไม่บังคับใช้ในการจ่ายยา
- No automated FIFO/FEFO logic
- ไม่มีระบบ FIFO/FEFO อัตโนมัติ
- Expiry alerts are manual and often missed
- การแจ้งเตือนวันหมดอายุเป็น Manual และมักพลาด

**Impact | ผลกระทบ:**
- 💊 5-8% of drugs expire before use
- 💊 ยาหมดอายุก่อนใช้ 5-8%
- 💸 Estimated waste value: 500,000-1,000,000 THB/year
- 💸 มูลค่าของเสียประมาณ: 500,000-1,000,000 บาท/ปี
- ⚠️ Risk of dispensing expired drugs
- ⚠️ ความเสี่ยงในการจ่ายยาหมดอายุ

**Required Solution | โซลูชันที่ต้องการ:**
- ✅ Mandatory lot selection with FIFO/FEFO logic
- ✅ การเลือก Lot แบบบังคับพร้อม FIFO/FEFO
- ✅ Automated expiry alerts (90/60/30 days before expiry)
- ✅ แจ้งเตือนวันหมดอายุอัตโนมัติ (90/60/30 วันก่อนหมดอายุ)
- ✅ Blocked dispensing for expired drugs
- ✅ บล็อคการจ่ายยาหมดอายุ

#### Problem 3: No Contract Management System
**ปัญหาที่ 3: ไม่มีระบบบริหารจัดการสัญญา**

**Current Situation | สถานการณ์ปัจจุบัน:**
- Contracts managed in separate files (Excel/Paper)
- จัดการสัญญาในไฟล์แยก (Excel/กระดาษ)
- No integration with purchase orders
- ไม่มีการบูรณาการกับใบสั่งซื้อ
- Cannot track contract spending vs. limit
- ไม่สามารถติดตามการใช้จ่ายตามสัญญา

**Impact | ผลกระทบ:**
- 📄 Contract compliance issues
- 📄 ปัญหาการปฏิบัติตามสัญญา
- 💰 Risk of exceeding contract limits
- 💰 ความเสี่ยงใช้เงินเกินขอบเขตสัญญา
- ⏰ Delayed procurement due to contract verification
- ⏰ การจัดซื้อล่าช้าเพราะต้องตรวจสอบสัญญา

**Required Solution | โซลูชันที่ต้องการ:**
- ✅ Integrated contract management module
- ✅ โมดูลบริหารจัดการสัญญาแบบบูรณาการ
- ✅ Automatic contract selection in PR/PO
- ✅ เลือกสัญญาอัตโนมัติในคำขอซื้อ/ใบสั่งซื้อ
- ✅ Contract spending tracking and alerts
- ✅ ติดตามการใช้งานสัญญาและแจ้งเตือน

#### Problem 4: Manual Ministry Reporting
**ปัญหาที่ 4: การรายงานกระทรวงแบบ Manual**

**Current Situation | สถานการณ์ปัจจุบัน:**
- 5 ministry files prepared manually each month
- จัดทำไฟล์รายงาน 5 ไฟล์แบบ Manual ทุกเดือน
- Data exported from multiple sources and combined
- ดึงข้อมูลจากหลายแหล่งแล้วรวมกัน
- High error rate due to manual processes
- อัตราข้อผิดพลาดสูงเพราะกระบวนการ Manual

**Impact | ผลกระทบ:**
- ⏰ 8-10 hours per month spent on reporting
- ⏰ ใช้เวลา 8-10 ชั่วโมงต่อเดือนในการทำรายงาน
- ❌ 15-20% error rate requiring corrections
- ❌ อัตราข้อผิดพลาด 15-20% ต้องแก้ไข
- 📅 Late submissions due to complexity
- 📅 ส่งรายงานล่าช้าเพราะความซับซ้อน

**Required Solution | โซลูชันที่ต้องการ:**
- ✅ Automated export of 5 ministry files
- ✅ ส่งออกไฟล์รายงาน 5 ไฟล์อัตโนมัติ
- ✅ 100% compliance with DMSIC Standards พ.ศ. 2568
- ✅ ปฏิบัติตามมาตรฐาน DMSIC พ.ศ. 2568 ครบ 100%
- ✅ One-click export with data validation
- ✅ ส่งออกคลิกเดียวพร้อมตรวจสอบข้อมูล

#### Problem 5: Limited Reporting and Analytics
**ปัญหาที่ 5: การรายงานและการวิเคราะห์จำกัด**

**Current Situation | สถานการณ์ปัจจุบัน:**
- Basic reports only (stock levels, transactions)
- รายงานพื้นฐานเท่านั้น (ระดับสต็อก, ธุรกรรม)
- No drug usage pattern analysis
- ไม่มีการวิเคราะห์รูปแบบการใช้ยา
- Cannot identify slow-moving or fast-moving items
- ไม่สามารถระบุสินค้าหมุนช้าหรือหมุนเร็ว

**Impact | ผลกระทบ:**
- 📊 Poor demand forecasting
- 📊 การคาดการณ์ความต้องการไม่ดี
- 💰 Overstocking slow-moving items
- 💰 สต็อกสินค้าหมุนช้าสูงเกินไป
- 📉 Stockouts of fast-moving items
- 📉 สต็อกสินค้าหมุนเร็วหมด

**Required Solution | โซลูชันที่ต้องการ:**
- ✅ ABC-VEN analysis for drug classification
- ✅ การวิเคราะห์ ABC-VEN สำหรับจัดกลุ่มยา
- ✅ Usage pattern reports with trends
- ✅ รายงานรูปแบบการใช้พร้อมแนวโน้ม
- ✅ Interactive dashboards for decision-making
- ✅ แดชบอร์ดแบบ Interactive สำหรับการตัดสินใจ

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

**System Components | องค์ประกอบระบบ:**

#### 1. Master Data Management | การจัดการข้อมูลหลัก
- ✅ Drug catalog (Generic + Trade drugs)
- ✅ แค็ตตาล็อกยา (ชื่อสามัญ + ชื่อการค้า)
- ✅ Vendor/Company management
- ✅ การจัดการผู้ขาย/บริษัท
- ✅ Location and department setup
- ✅ การตั้งค่าสถานที่และแผนก
- ✅ Budget type configuration
- ✅ การกำหนดประเภทงบประมาณ

#### 2. Budget Management | การจัดการงบประมาณ
- ✅ Annual budget allocation
- ✅ การจัดสรรงบประมาณรายปี
- ✅ Quarterly budget breakdown (Q1-Q4)
- ✅ แบ่งงบประมาณรายไตรมาส (Q1-Q4)
- ✅ Budget reservation system
- ✅ ระบบจองงบประมาณ
- ✅ Real-time availability checking
- ✅ ตรวจสอบงบคงเหลือแบบเรียลไทม์
- ✅ Budget monitoring and reporting
- ✅ การติดตามและรายงานงบประมาณ

#### 3. Procurement Management | การจัดการจัดซื้อ
- ✅ Purchase request workflow
- ✅ กระบวนการคำขอซื้อ
- ✅ Multi-level approval process
- ✅ การอนุมัติหลายระดับ
- ✅ Purchase order generation
- ✅ สร้างใบสั่งซื้อ
- ✅ Goods receiving management
- ✅ การจัดการรับของ
- ✅ Invoice reconciliation
- ✅ การตรวจสอบใบแจ้งหนี้

#### 4. Inventory Management | การจัดการสต็อก
- ✅ Multi-location stock tracking
- ✅ ติดตามสต็อกหลายสถานที่
- ✅ FIFO/FEFO lot management
- ✅ การจัดการ Lot แบบ FIFO/FEFO
- ✅ Expiry date tracking
- ✅ ติดตามวันหมดอายุ
- ✅ Reorder point management
- ✅ จัดการจุดสั่งซื้อใหม่
- ✅ Inventory adjustments and transfers
- ✅ การปรับปรุงและโอนย้ายสต็อก

#### 5. Distribution Management | การจัดการจัดจ่าย
- ✅ Department requisition workflow
- ✅ กระบวนการเบิกของแผนก
- ✅ FEFO-based lot selection
- ✅ การเลือก Lot แบบ FEFO
- ✅ Distribution tracking and reporting
- ✅ ติดตามและรายงานการจัดจ่าย

#### 6. Reporting and Analytics | การรายงานและการวิเคราะห์
- ✅ Ministry export files (5 files)
- ✅ ไฟล์ส่งออกกระทรวง (5 ไฟล์)
  - DRUGLIST (รายการยา)
  - PURCHASEPLAN (แผนการจัดซื้อ)
  - RECEIPT (ใบรับของ)
  - DISTRIBUTION (ใบจ่ายยา)
  - INVENTORY (สต็อกคงเหลือ)
- ✅ Budget status reports
- ✅ รายงานสถานะงบประมาณ
- ✅ Stock level reports
- ✅ รายงานระดับสต็อก
- ✅ Expiring drugs alerts
- ✅ แจ้งเตือนยาใกล้หมดอายุ
- ✅ Usage pattern analysis
- ✅ การวิเคราะห์รูปแบบการใช้

### 5.2 Out of Scope | นอกขอบเขต

**Not Included in Current Phase | ไม่รวมในระยะปัจจุบัน:**
- ❌ HIS (Hospital Information System) integration
- ❌ การบูรณาการกับระบบ HIS
- ❌ Electronic Health Records (EHR) integration
- ❌ การบูรณาการกับ EHR
- ❌ Patient billing integration
- ❌ การบูรณาการกับระบบเรียกเก็บเงินผู้ป่วย
- ❌ Pharmacy dispensing at ward level
- ❌ การจ่ายยาระดับหอผู้ป่วย
- ❌ Clinical decision support
- ❌ ระบบสนับสนุนการตัดสินใจทางคลินิก
- ❌ E-procurement with vendor portals
- ❌ จัดซื้ออิเล็กทรอนิกส์กับพอร์ทัลผู้ขาย

**Future Considerations | พิจารณาในอนาคต:**
- 🔮 AI-powered demand forecasting
- 🔮 การคาดการณ์ความต้องการด้วย AI
- 🔮 Blockchain for supply chain tracking
- 🔮 Blockchain สำหรับติดตามห่วงโซ่อุปทาน
- 🔮 IoT sensors for automated stock counting
- 🔮 เซ็นเซอร์ IoT สำหรับนับสต็อกอัตโนมัติ

---

## 6. Functional Requirements | ความต้องการด้านการทำงาน

### 6.1 Master Data Management Requirements

#### FR-MD-001: Drug Catalog Management
**ความต้องการ FR-MD-001: การจัดการแค็ตตาล็อกยา**

**Description | คำอธิบาย:**
System shall maintain a comprehensive drug catalog with both generic and trade drugs, including full DMSIC compliance fields.

ระบบต้องบำรุงรักษาแค็ตตาล็อกยาที่ครอบคลุมทั้งยาชื่อสามัญและชื่อการค้า รวมถึงข้อมูลตามมาตรฐาน DMSIC ครบถ้วน

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Support Generic Drug Master (DRUG24)
- [ ] รองรับฐานข้อมูลยาชื่อสามัญ (DRUG24)
- [ ] Support Trade Drug Catalog with manufacturer info
- [ ] รองรับแค็ตตาล็อกยาชื่อการค้าพร้อมข้อมูลผู้ผลิต
- [ ] Include NLEM status (E/N) for each drug
- [ ] ระบุสถานะ NLEM (E/N) สำหรับยาแต่ละรายการ
- [ ] Track drug status lifecycle (1-4)
- [ ] ติดตามวงจรชีวิตของยา (1-4)
- [ ] Support product category classification (1-5)
- [ ] รองรับการจัดกลุ่มหมวดหมู่สินค้า (1-5)
- [ ] Allow TMT code mapping
- [ ] อนุญาตให้เชื่อมโยงรหัส TMT

#### FR-MD-002: Vendor Management
**ความต้องการ FR-MD-002: การจัดการผู้ขาย**

**Description | คำอธิบาย:**
System shall maintain vendor information including contact details, payment terms, and performance metrics.

ระบบต้องบำรุงรักษาข้อมูลผู้ขาย รวมถึงรายละเอียดการติดต่อ เงื่อนไขการชำระเงิน และตัวชี้วัดประสิทธิภาพ

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Store vendor basic information (name, address, tax ID)
- [ ] เก็บข้อมูลพื้นฐานผู้ขาย (ชื่อ, ที่อยู่, เลขประจำตัวผู้เสียภาษี)
- [ ] Track vendor contact persons
- [ ] ติดตามผู้ติดต่อของผู้ขาย
- [ ] Record payment terms and conditions
- [ ] บันทึกเงื่อนไขการชำระเงิน
- [ ] Support vendor rating/evaluation
- [ ] รองรับการให้คะแนน/ประเมินผู้ขาย

#### FR-MD-003: Location and Department Setup
**ความต้องการ FR-MD-003: การตั้งค่าสถานที่และแผนก**

**Description | คำอธิบาย:**
System shall support multi-location inventory with department-level tracking and Ministry consumption group mapping.

ระบบต้องรองรับสต็อกหลายสถานที่พร้อมการติดตามระดับแผนกและเชื่อมโยงกลุ่มผู้บริโภคตามกระทรวง

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Define storage locations (warehouse, pharmacy, ward, etc.)
- [ ] กำหนดสถานที่เก็บ (คลังสินค้า, ห้องยา, หอผู้ป่วย ฯลฯ)
- [ ] Define departments with budget codes
- [ ] กำหนดแผนกพร้อมรหัสงบประมาณ
- [ ] Map departments to Ministry consumption groups (1-9)
- [ ] เชื่อมโยงแผนกกับกลุ่มผู้บริโภคตามกระทรวง (1-9)
- [ ] Support department hierarchy
- [ ] รองรับลำดับชั้นแผนก

### 6.2 Budget Management Requirements

#### FR-BUD-001: Budget Allocation
**ความต้องการ FR-BUD-001: การจัดสรรงบประมาณ**

**Description | คำอธิบาย:**
System shall support annual budget allocation with quarterly breakdown and real-time tracking.

ระบบต้องรองรับการจัดสรรงบประมาณรายปีพร้อมแบ่งรายไตรมาสและติดตามแบบเรียลไทม์

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Create annual budget by fiscal year
- [ ] สร้างงบประมาณรายปีตามปีงบประมาณ
- [ ] Allocate budget by type (OP001-drugs, OP002-equipment, etc.)
- [ ] จัดสรรงบตามประเภท (OP001-ยา, OP002-ครุภัณฑ์ ฯลฯ)
- [ ] Break down budget by quarter (Q1-Q4)
- [ ] แบ่งงบตามไตรมาส (Q1-Q4)
- [ ] Assign budget to departments
- [ ] มอบหมายงบให้แผนก
- [ ] Track budget utilization in real-time
- [ ] ติดตามการใช้งบแบบเรียลไทม์

#### FR-BUD-002: Budget Checking
**ความต้องการ FR-BUD-002: การตรวจสอบงบประมาณ**

**Description | คำอธิบาย:**
System shall check budget availability before approving purchase requests.

ระบบต้องตรวจสอบงบคงเหลือก่อนอนุมัติคำขอซื้อ

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Automatic budget check during PR approval
- [ ] ตรวจสอบงบอัตโนมัติระหว่างอนุมัติคำขอซื้อ
- [ ] Consider quarter-specific allocations
- [ ] พิจารณาการจัดสรรเฉพาะไตรมาส
- [ ] Block approval if budget insufficient
- [ ] บล็อคการอนุมัติถ้างบไม่เพียงพอ
- [ ] Display available budget to users
- [ ] แสดงงบคงเหลือให้ผู้ใช้
- [ ] Provide budget override with approval
- [ ] อนุญาตให้ใช้งบเกินพร้อมการอนุมัติ

#### FR-BUD-003: Budget Reservation
**ความต้องการ FR-BUD-003: การจองงบประมาณ**

**Description | คำอธิบาย:**
System shall reserve budget for approved purchase requests until PO is finalized.

ระบบต้องจองงบสำหรับคำขอซื้อที่อนุมัติแล้วจนกว่าใบสั่งซื้อจะแล้วเสร็จ

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Auto-reserve budget when PR approved
- [ ] จองงบอัตโนมัติเมื่อคำขอซื้อได้รับอนุมัติ
- [ ] Set expiration date for reservations
- [ ] กำหนดวันหมดอายุสำหรับการจอง
- [ ] Release expired reservations automatically
- [ ] ปลดล็อคการจองที่หมดอายุอัตโนมัติ
- [ ] Commit budget when PO finalized
- [ ] ยืนยันงบเมื่อใบสั่งซื้อแล้วเสร็จ

### 6.3 Procurement Requirements

#### FR-PROC-001: Purchase Request Creation
**ความต้องการ FR-PROC-001: การสร้างคำขอซื้อ**

**Description | คำอธิบาย:**
System shall allow authorized users to create purchase requests with drug details and justification.

ระบบต้องอนุญาตให้ผู้ใช้ที่ได้รับอนุญาตสร้างคำขอซื้อพร้อมรายละเอียดยาและเหตุผล

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Create PR with multiple drug items
- [ ] สร้างคำขอซื้อพร้อมยาหลายรายการ
- [ ] Specify quantity and unit price
- [ ] ระบุปริมาณและราคาต่อหน่วย
- [ ] Select budget type and quarter
- [ ] เลือกประเภทงบและไตรมาส
- [ ] Add justification/reason for purchase
- [ ] เพิ่มเหตุผลสำหรับการซื้อ
- [ ] Save as draft or submit for approval
- [ ] บันทึกเป็นแบบร่างหรือส่งเพื่ออนุมัติ

#### FR-PROC-002: PR Approval Workflow
**ความต้องการ FR-PROC-002: กระบวนการอนุมัติคำขอซื้อ**

**Description | คำอธิบาย:**
System shall route purchase requests through multi-level approval workflow based on amount and type.

ระบบต้องส่งคำขอซื้อผ่านกระบวนการอนุมัติหลายระดับตามจำนวนเงินและประเภท

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Route to appropriate approvers based on rules
- [ ] ส่งไปยังผู้อนุมัติที่เหมาะสมตามกฎ
- [ ] Support sequential and parallel approval
- [ ] รองรับการอนุมัติแบบลำดับและแบบขนาน
- [ ] Check budget availability before approval
- [ ] ตรวจสอบงบก่อนอนุมัติ
- [ ] Allow approval/rejection with comments
- [ ] อนุญาตให้อนุมัติ/ปฏิเสธพร้อมความคิดเห็น
- [ ] Send notifications to approvers and requestors
- [ ] ส่งการแจ้งเตือนไปยังผู้อนุมัติและผู้ขอ

#### FR-PROC-003: Purchase Order Generation
**ความต้องการ FR-PROC-003: การสร้างใบสั่งซื้อ**

**Description | คำอธิบาย:**
System shall generate purchase orders from approved purchase requests.

ระบบต้องสร้างใบสั่งซื้อจากคำขอซื้อที่ได้รับอนุมัติ

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Convert approved PR to PO
- [ ] แปลงคำขอซื้อที่อนุมัติเป็นใบสั่งซื้อ
- [ ] Select vendor for PO
- [ ] เลือกผู้ขายสำหรับใบสั่งซื้อ
- [ ] Include payment terms
- [ ] รวมเงื่อนไขการชำระเงิน
- [ ] Generate PO number automatically
- [ ] สร้างเลขใบสั่งซื้ออัตโนมัติ
- [ ] Print/Export PO for vendor
- [ ] พิมพ์/ส่งออกใบสั่งซื้อสำหรับผู้ขาย

#### FR-PROC-004: Goods Receiving
**ความต้องการ FR-PROC-004: การรับของ**

**Description | คำอธิบาย:**
System shall record goods receiving with lot information and quality checks.

ระบบต้องบันทึกการรับของพร้อมข้อมูล Lot และการตรวจสอบคุณภาพ

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Create receipt against PO
- [ ] สร้างใบรับของจากใบสั่งซื้อ
- [ ] Record lot numbers and expiry dates
- [ ] บันทึกหมายเลข Lot และวันหมดอายุ
- [ ] Record actual quantity received
- [ ] บันทึกปริมาณที่รับจริง
- [ ] Support partial receiving
- [ ] รองรับการรับของบางส่วน
- [ ] Update inventory upon receipt confirmation
- [ ] อัปเดตสต็อกเมื่อยืนยันการรับของ

### 6.4 Inventory Management Requirements

#### FR-INV-001: Multi-location Inventory Tracking
**ความต้องการ FR-INV-001: การติดตามสต็อกหลายสถานที่**

**Description | คำอธิบาย:**
System shall track inventory levels separately for each location.

ระบบต้องติดตามระดับสต็อกแยกตามแต่ละสถานที่

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Track stock by drug and location
- [ ] ติดตามสต็อกตามยาและสถานที่
- [ ] Support multiple storage locations
- [ ] รองรับสถานที่เก็บหลายแห่ง
- [ ] Display stock levels per location
- [ ] แสดงระดับสต็อกต่อสถานที่
- [ ] Support stock transfers between locations
- [ ] รองรับการโอนย้ายสต็อกระหว่างสถานที่

#### FR-INV-002: FIFO/FEFO Lot Management
**ความต้องการ FR-INV-002: การจัดการ Lot แบบ FIFO/FEFO**

**Description | คำอธิบาย:**
System shall enforce FIFO (First In First Out) or FEFO (First Expire First Out) rules for drug dispensing.

ระบบต้องบังคับใช้กฎ FIFO (เข้าก่อนออกก่อน) หรือ FEFO (หมดอายุก่อนออกก่อน) สำหรับการจ่ายยา

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Record lot information for all receipts
- [ ] บันทึกข้อมูล Lot สำหรับการรับทุกครั้ง
- [ ] Auto-suggest lots based on FIFO/FEFO
- [ ] แนะนำ Lot อัตโนมัติตาม FIFO/FEFO
- [ ] Track lot balance separately
- [ ] ติดตามยอดคงเหลือ Lot แยก
- [ ] Block dispensing from expired lots
- [ ] บล็อคการจ่ายจาก Lot ที่หมดอายุ

#### FR-INV-003: Expiry Management
**ความต้องการ FR-INV-003: การจัดการวันหมดอายุ**

**Description | คำอธิบาย:**
System shall track expiry dates and alert users about expiring drugs.

ระบบต้องติดตามวันหมดอายุและแจ้งเตือนผู้ใช้เกี่ยวกับยาที่ใกล้หมดอายุ

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Record expiry date for each lot
- [ ] บันทึกวันหมดอายุสำหรับแต่ละ Lot
- [ ] Alert 90 days before expiry (critical items)
- [ ] แจ้งเตือน 90 วันก่อนหมดอายุ (รายการสำคัญ)
- [ ] Alert 60 and 30 days before expiry
- [ ] แจ้งเตือน 60 และ 30 วันก่อนหมดอายุ
- [ ] Generate expiring drugs report
- [ ] สร้างรายงานยาใกล้หมดอายุ
- [ ] Block usage of expired drugs
- [ ] บล็อคการใช้ยาหมดอายุ

#### FR-INV-004: Reorder Point Management
**ความต้องการ FR-INV-004: การจัดการจุดสั่งซื้อใหม่**

**Description | คำอธิบาย:**
System shall support reorder point setting and low stock alerts.

ระบบต้องรองรับการตั้งค่าจุดสั่งซื้อใหม่และแจ้งเตือนสต็อกต่ำ

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Set min/max levels for each drug
- [ ] กำหนดระดับขั้นต่ำ/สูงสุดสำหรับแต่ละยา
- [ ] Generate low stock alerts
- [ ] สร้างการแจ้งเตือนสต็อกต่ำ
- [ ] Suggest reorder quantity
- [ ] แนะนำปริมาณสั่งซื้อใหม่
- [ ] Consider lead time in calculations
- [ ] พิจารณา Lead time ในการคำนวณ

### 6.5 Distribution Requirements

#### FR-DIST-001: Department Distribution
**ความต้องการ FR-DIST-001: การจัดจ่ายให้แผนก**

**Description | คำอธิบาย:**
System shall manage drug distribution from central pharmacy to departments.

ระบบต้องจัดการการจัดจ่ายยาจากห้องยากลางไปยังแผนกต่าง ๆ

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Create distribution request from department
- [ ] สร้างคำขอจัดจ่ายจากแผนก
- [ ] Select lots using FEFO logic
- [ ] เลือก Lot โดยใช้ตรรกะ FEFO
- [ ] Record distribution transaction
- [ ] บันทึกธุรกรรมการจัดจ่าย
- [ ] Update inventory for both locations
- [ ] อัปเดตสต็อกสำหรับทั้งสองสถานที่
- [ ] Generate distribution report
- [ ] สร้างรายงานการจัดจ่าย

### 6.6 Reporting Requirements

#### FR-REP-001: Ministry Export Files
**ความต้องการ FR-REP-001: ไฟล์ส่งออกกระทรวง**

**Description | คำอธิบาย:**
System shall generate 5 mandatory export files for Ministry of Public Health with 100% compliance to DMSIC Standards พ.ศ. 2568.

ระบบต้องสร้างไฟล์ส่งออก 5 ไฟล์ตามที่กระทรวงสาธารณสุขกำหนด โดยปฏิบัติตามมาตรฐาน DMSIC พ.ศ. 2568 ครบ 100%

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Export DRUGLIST (11 fields) - รายการยา
- [ ] Export PURCHASEPLAN (20 fields) - แผนการจัดซื้อ
- [ ] Export RECEIPT (22 fields) - ใบรับของ
- [ ] Export DISTRIBUTION (11 fields) - ใบจ่ายยา
- [ ] Export INVENTORY (15 fields) - สต็อกคงเหลือ
- [ ] Support one-click export
- [ ] รองรับการส่งออกคลิกเดียว
- [ ] Validate data before export
- [ ] ตรวจสอบข้อมูลก่อนส่งออก
- [ ] Export in standard text format
- [ ] ส่งออกในรูปแบบ Text มาตรฐาน

#### FR-REP-002: Operational Reports
**ความต้องการ FR-REP-002: รายงานการดำเนินงาน**

**Description | คำอธิบาย:**
System shall provide comprehensive operational reports for management.

ระบบต้องจัดเตรียมรายงานการดำเนินงานที่ครอบคลุมสำหรับการบริหาร

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Budget status report by department/quarter
- [ ] รายงานสถานะงบตามแผนก/ไตรมาส
- [ ] Stock level report by location
- [ ] รายงานระดับสต็อกตามสถานที่
- [ ] Expiring drugs report
- [ ] รายงานยาใกล้หมดอายุ
- [ ] Purchase order tracking report
- [ ] รายงานติดตามใบสั่งซื้อ
- [ ] Distribution summary report
- [ ] รายงานสรุปการจัดจ่าย

#### FR-REP-003: Analytics and Dashboards
**ความต้องการ FR-REP-003: การวิเคราะห์และแดชบอร์ด**

**Description | คำอธิบาย:**
System shall provide interactive dashboards for data visualization and analysis.

ระบบต้องจัดเตรียมแดชบอร์ดแบบ Interactive สำหรับการแสดงผลและวิเคราะห์ข้อมูล

**Acceptance Criteria | เกณฑ์การยอมรับ:**
- [ ] Budget utilization dashboard
- [ ] แดชบอร์ดการใช้งบประมาณ
- [ ] Inventory status dashboard
- [ ] แดชบอร์ดสถานะสต็อก
- [ ] ABC-VEN analysis
- [ ] การวิเคราะห์ ABC-VEN
- [ ] Usage trend analysis
- [ ] การวิเคราะห์แนวโน้มการใช้
- [ ] Vendor performance metrics
- [ ] ตัวชี้วัดประสิทธิภาพผู้ขาย

---

## 7. Business Rules | กฎทางธุรกิจ

### 7.1 Budget Rules | กฎเกี่ยวกับงบประมาณ

**BR-BUD-001: Budget Allocation**
- Budget must be allocated by fiscal year (October 1 - September 30)
- งบประมาณต้องจัดสรรตามปีงบประมาณ (1 ตุลาคม - 30 กันยายน)
- Total quarterly allocation (Q1+Q2+Q3+Q4) must equal annual budget
- ผลรวมงบทั้ง 4 ไตรมาส (Q1+Q2+Q3+Q4) ต้องเท่ากับงบรายปี

**BR-BUD-002: Budget Checking**
- All purchase requests must have sufficient budget before approval
- คำขอซื้อทั้งหมดต้องมีงบเพียงพอก่อนการอนุมัติ
- Budget check considers current quarter allocation
- การตรวจสอบงบพิจารณาการจัดสรรของไตรมาสปัจจุบัน
- Reserved budget is excluded from available amount
- งบที่จองไว้ไม่นับเป็นงบคงเหลือที่ใช้ได้

**BR-BUD-003: Budget Reservation**
- Budget is auto-reserved when PR is approved
- งบถูกจองอัตโนมัติเมื่อคำขอซื้อได้รับอนุมัติ
- Reservation expires after 30 days if PO not created
- การจองหมดอายุหลัง 30 วันถ้าไม่มีการสร้างใบสั่งซื้อ
- Expired reservations are auto-released
- การจองที่หมดอายุถูกปลดล็อคอัตโนมัติ

**BR-BUD-004: Budget Commitment**
- Budget is committed when PO is finalized
- งบถูกยืนยันเมื่อใบสั่งซื้อแล้วเสร็จ
- Committed budget cannot be used for other purchases
- งบที่ยืนยันแล้วไม่สามารถใช้สำหรับการซื้ออื่นได้

### 7.2 Inventory Rules | กฎเกี่ยวกับสต็อก

**BR-INV-001: Lot Tracking**
- Every receipt must record lot number and expiry date
- การรับทุกครั้งต้องบันทึกหมายเลข Lot และวันหมดอายุ
- Lot number must be unique per drug per receipt
- หมายเลข Lot ต้องไม่ซ้ำต่อยาต่อการรับแต่ละครั้ง

**BR-INV-002: FIFO/FEFO Rules**
- Drug distribution must follow FEFO logic (earliest expiry first)
- การจัดจ่ายยาต้องตามตรรกะ FEFO (หมดอายุก่อนออกก่อน)
- System shall block selection of expired lots
- ระบบต้องบล็อคการเลือก Lot ที่หมดอายุ
- FIFO applies if expiry dates are equal
- ใช้ FIFO ถ้าวันหมดอายุเท่ากัน

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
- จุดสั่งซื้อใหม่ควรอยู่ระหว่างขั้นต่ำและสูงสุด
- Low stock alert triggers when stock falls below reorder point
- แจ้งเตือนสต็อกต่ำเมื่อสต็อกต่ำกว่าจุดสั่งซื้อใหม่

**BR-INV-005: Inventory Transactions**
- All inventory changes must be recorded with transaction type
- การเปลี่ยนแปลงสต็อกทั้งหมดต้องบันทึกพร้อมประเภทธุรกรรม
- Transaction types: RECEIVE, ISSUE, TRANSFER, ADJUST, RETURN
- ประเภทธุรกรรม: รับ, จ่าย, โอน, ปรับปรุง, คืน
- Negative stock balance is not allowed
- ยอดคงเหลือติดลบไม่อนุญาต

### 7.3 Procurement Rules | กฎเกี่ยวกับการจัดซื้อ

**BR-PROC-001: Purchase Request Approval**
- PR amount < 10,000 THB: Department head approval
- คำขอซื้อ < 10,000 บาท: หัวหน้าแผนกอนุมัติ
- PR amount 10,000-100,000 THB: Pharmacy manager + Finance approval
- คำขอซื้อ 10,000-100,000 บาท: หัวหน้าเภสัช + การเงินอนุมัติ
- PR amount > 100,000 THB: Pharmacy manager + Finance + Director approval
- คำขอซื้อ > 100,000 บาท: หัวหน้าเภสัช + การเงิน + ผู้อำนวยการอนุมัติ

**BR-PROC-002: Purchase Order**
- PO can only be created from approved PR
- ใบสั่งซื้อสามารถสร้างได้จากคำขอซื้อที่อนุมัติแล้วเท่านั้น
- PO amount cannot exceed PR approved amount
- จำนวนเงินใบสั่งซื้อไม่สามารถเกินจำนวนที่อนุมัติในคำขอซื้อ
- PO must have valid vendor
- ใบสั่งซื้อต้องมีผู้ขายที่ถูกต้อง

**BR-PROC-003: Goods Receiving**
- Goods can only be received against valid PO
- สามารถรับของจากใบสั่งซื้อที่ถูกต้องเท่านั้น
- Received quantity cannot exceed PO quantity
- ปริมาณที่รับไม่สามารถเกินปริมาณในใบสั่งซื้อ
- Partial receiving is allowed
- อนุญาตให้รับของบางส่วน

### 7.4 Distribution Rules | กฎเกี่ยวกับการจัดจ่าย

**BR-DIST-001: Distribution Request**
- Only authorized departments can request distribution
- เฉพาะแผนกที่ได้รับอนุญาตเท่านั้นที่สามารถขอจัดจ่าย
- Distribution request must specify required quantity
- คำขอจัดจ่ายต้องระบุปริมาณที่ต้องการ

**BR-DIST-002: Distribution Fulfillment**
- Distribution must use FEFO lot selection
- การจัดจ่ายต้องใช้การเลือก Lot แบบ FEFO
- Cannot distribute from expired lots
- ไม่สามารถจัดจ่ายจาก Lot ที่หมดอายุ
- Source location must have sufficient stock
- สถานที่ต้นทางต้องมีสต็อกเพียงพอ

---

## 8. Compliance Requirements | ข้อกำหนดด้านกฎระเบียบ

### 8.1 Ministry of Public Health Requirements
**ข้อกำหนดกระทรวงสาธารณสุข**

**DMSIC Standards พ.ศ. 2568:**
- ✅ 100% compliance with 79 required fields across 5 export files
- ✅ ปฏิบัติตาม 79 ฟิลด์ที่กำหนด ครบ 100% ใน 5 ไฟล์ส่งออก

**Required Export Files:**
1. **DRUGLIST** - Drug Catalog (11 fields)
   - Drug code, name, manufacturer, NLEM status, etc.
   - รหัสยา, ชื่อ, ผู้ผลิต, สถานะ NLEM ฯลฯ

2. **PURCHASEPLAN** - Purchase Planning (20 fields)
   - Annual/quarterly purchase planning data
   - ข้อมูลการวางแผนจัดซื้อรายปี/ไตรมาส

3. **RECEIPT** - Goods Receiving (22 fields)
   - Receipt details, lot information, expiry dates
   - รายละเอียดการรับของ, ข้อมูล Lot, วันหมดอายุ

4. **DISTRIBUTION** - Drug Distribution (11 fields)
   - Distribution to departments/wards
   - การจัดจ่ายให้แผนก/หอผู้ป่วย

5. **INVENTORY** - Stock Status (15 fields)
   - Current inventory levels by location
   - ระดับสต็อกปัจจุบันตามสถานที่

**TMT Integration:**
- Support Thai Medical Terminology (TMT) code mapping
- รองรับการเชื่อมโยงรหัส TMT (ศัพท์ทางการแพทย์ไทย)
- 25,991 TMT concepts in database
- มี 25,991 รายการ TMT ในฐานข้อมูล

### 8.2 Financial Regulations
**ข้อกำหนดด้านการเงิน**

**Budget Control:**
- Comply with Government Budget Act B.E. 2561
- ปฏิบัติตามพระราชบัญญัติวิธีการงบประมาณ พ.ศ. 2561
- Fiscal year: October 1 - September 30
- ปีงบประมาณ: 1 ตุลาคม - 30 กันยายน

**Procurement Regulations:**
- Follow Procurement Regulations B.E. 2560
- ปฏิบัติตามระเบียบการจัดซื้อ พ.ศ. 2560
- Maintain complete audit trail
- รักษาบันทึกการตรวจสอบที่สมบูรณ์

### 8.3 Data Protection (PDPA)
**การคุ้มครองข้อมูลส่วนบุคคล**

**Personal Data Protection Act B.E. 2562:**
- Protect employee and vendor personal data
- ปกป้องข้อมูลส่วนบุคคลของพนักงานและผู้ขาย
- Implement proper access controls
- ใช้การควบคุมการเข้าถึงที่เหมาะสม
- Maintain data processing records
- บำรุงรักษาบันทึกการประมวลผลข้อมูล

### 8.4 Audit Requirements
**ข้อกำหนดการตรวจสอบ**

**Audit Trail:**
- Record all transactions with timestamp and user
- บันทึกธุรกรรมทั้งหมดพร้อม timestamp และผู้ใช้
- Log all approval actions
- บันทึกการดำเนินการอนุมัติทั้งหมด
- Maintain change history for critical data
- บำรุงรักษาประวัติการเปลี่ยนแปลงสำหรับข้อมูลสำคัญ

**Document Retention:**
- Keep transaction records for 10 years
- เก็บบันทึกธุรกรรม 10 ปี
- Maintain budget documents per fiscal year
- บำรุงรักษาเอกสารงบประมาณต่อปีงบประมาณ

---

## 9. User Roles and Permissions | บทบาทและสิทธิ์ผู้ใช้

### 9.1 Role Definitions | คำนิยามบทบาท

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
- การจัดการแค็ตตาล็อกยา
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
- การรับของ
- Drug distribution
- การจัดจ่ายยา
- Inventory management
- การจัดการสต็อก

**Permissions | สิทธิ์:**
- ✅ Receive goods
- ✅ Create distribution orders
- ✅ View inventory
- ✅ Adjust inventory (with approval)

#### Procurement Officer | เจ้าหน้าที่จัดซื้อ
**Responsibilities | ความรับผิดชอบ:**
- Create purchase requests
- สร้างคำขอซื้อ
- Generate purchase orders
- สร้างใบสั่งซื้อ
- Vendor management
- การจัดการผู้ขาย

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

### 9.2 Permission Matrix | ตารางสิทธิ์

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
- ✅ = Full Access (เข้าถึงเต็มที่)
- 👁️ = View Only (ดูได้อย่างเดียว)
- 🚫 = No Access (ไม่มีสิทธิ์)

---

## 10. Success Criteria | เกณฑ์ความสำเร็จ

### 10.1 Technical Success Criteria
**เกณฑ์ความสำเร็จด้านเทคนิค**

**System Performance:**
- ⚡ Page load time < 2 seconds
- ⚡ เวลาโหลดหน้าเว็บ < 2 วินาที
- ⚡ API response time < 500ms for 95% of requests
- ⚡ เวลาตอบสนอง API < 500ms สำหรับ 95% ของ request
- ⚡ System uptime > 99.5%
- ⚡ ระบบทำงาน > 99.5% ของเวลา

**Data Accuracy:**
- ✅ 100% accuracy in ministry export files
- ✅ ความถูกต้อง 100% ในไฟล์ส่งออกกระทรวง
- ✅ Zero negative stock balances
- ✅ ไม่มียอดคงเหลือติดลบ
- ✅ Budget calculation accuracy > 99.99%
- ✅ ความแม่นยำการคำนวณงบ > 99.99%

**Security:**
- 🔐 All sensitive data encrypted at rest and in transit
- 🔐 ข้อมูลสำคัญทั้งหมดเข้ารหัสในการจัดเก็บและส่งผ่าน
- 🔐 Role-based access control implemented
- 🔐 ใช้การควบคุมการเข้าถึงตามบทบาท
- 🔐 Complete audit trail for all transactions
- 🔐 บันทึกการตรวจสอบครบถ้วนทุกธุรกรรม

### 10.2 Business Success Criteria
**เกณฑ์ความสำเร็จด้านธุรกิจ**

**Operational Efficiency:**
- 📈 50% reduction in PR processing time (from 3 days to 1.5 days)
- 📈 ลดเวลาประมวลผลคำขอซื้อ 50% (จาก 3 วัน เป็น 1.5 วัน)
- 📈 30% reduction in drug expiry waste
- 📈 ลดของเสียจากยาหมดอายุ 30%
- 📈 20% improvement in budget utilization
- 📈 เพิ่มประสิทธิภาพการใช้งบ 20%

**Compliance:**
- ✅ 100% on-time ministry report submission
- ✅ ส่งรายงานกระทรวงตรงเวลา 100%
- ✅ Zero compliance violations
- ✅ ไม่มีการฝ่าฝืนกฎระเบียบ
- ✅ Pass external audit with no major findings
- ✅ ผ่านการตรวจสอบภายนอกโดยไม่มีข้อบกพร่องสำคัญ

**User Adoption:**
- 👥 80% user adoption within 3 months
- 👥 ผู้ใช้ 80% ใช้งานภายใน 3 เดือน
- 👥 User satisfaction score > 4.0/5.0
- 👥 คะแนนความพึงพอใจ > 4.0/5.0
- 👥 < 5 support tickets per week after 3 months
- 👥 < 5 ตั๋วสนับสนุนต่อสัปดาห์หลัง 3 เดือน

**Cost Savings:**
- 💰 500,000-1,000,000 THB/year reduction in expired drug waste
- 💰 ลดของเสียจากยาหมดอายุ 500,000-1,000,000 บาท/ปี
- 💰 100,000 THB/year reduction in manual report preparation
- 💰 ลดค่าใช้จ่ายในการทำรายงาน Manual 100,000 บาท/ปี

---

## 11. Assumptions and Constraints | สมมติฐานและข้อจำกัด

### 11.1 Assumptions | สมมติฐาน

**Technical Assumptions:**
- Users have modern web browsers (Chrome, Firefox, Safari, Edge)
- ผู้ใช้มีเว็บเบราว์เซอร์ทันสมัย (Chrome, Firefox, Safari, Edge)
- Internet connectivity available at all work locations
- มีอินเทอร์เน็ตที่สถานที่ทำงานทุกแห่ง
- PostgreSQL database server available
- มีเซิร์ฟเวอร์ฐานข้อมูล PostgreSQL
- Docker infrastructure available for deployment
- มีโครงสร้างพื้นฐาน Docker สำหรับติดตั้ง

**Business Assumptions:**
- Users will receive adequate training
- ผู้ใช้จะได้รับการฝึกอบรมที่เพียงพอ
- Legacy data can be migrated successfully
- ข้อมูลเดิมสามารถย้ายได้สำเร็จ
- Vendors will continue using current communication methods
- ผู้ขายจะใช้วิธีการสื่อสารปัจจุบันต่อไป
- Ministry reporting requirements remain stable
- ข้อกำหนดการรายงานกระทรวงคงที่

### 11.2 Constraints | ข้อจำกัด

**Technical Constraints:**
- Must use existing hospital IT infrastructure
- ต้องใช้โครงสร้างพื้นฐานไอทีโรงพยาบาลที่มีอยู่
- Database schema cannot exceed 100 tables
- โครงสร้างฐานข้อมูลไม่เกิน 100 ตาราง
- Must be compatible with Windows Server 2019+
- ต้องใช้งานได้กับ Windows Server 2019 ขึ้นไป
- Response time must support 100 concurrent users
- เวลาตอบสนองต้องรองรับผู้ใช้พร้อมกัน 100 คน

**Budget Constraints:**
- Limited development budget
- งบประมาณพัฒนาจำกัด
- Cannot purchase expensive third-party software
- ไม่สามารถซื้อซอฟต์แวร์บุคคลที่สามแพง ๆ
- Must use open-source technologies where possible
- ต้องใช้เทคโนโลยีโอเพนซอร์สเท่าที่เป็นไปได้

**Time Constraints:**
- Must complete Phase 1 (Database) before Q2 2025
- ต้องเสร็จ Phase 1 (ฐานข้อมูล) ก่อน Q2 2025
- Full system must be operational by Q1 2026
- ระบบเต็มรูปแบบต้องพร้อมใช้ภายใน Q1 2026

**Regulatory Constraints:**
- Must comply with all government regulations
- ต้องปฏิบัติตามกฎระเบียบรัฐบาลทั้งหมด
- Cannot modify ministry export file formats
- ไม่สามารถแก้ไขรูปแบบไฟล์ส่งออกกระทรวง

---

## 12. Risks and Mitigation | ความเสี่ยงและการบริหารจัดการ

### 12.1 High Risk | ความเสี่ยงสูง

#### Risk 1: Data Migration Failure
**ความเสี่ยงที่ 1: การย้ายข้อมูลล้มเหลว**

**Description | คำอธิบาย:**
Legacy data may have inconsistencies or missing values that prevent successful migration.

ข้อมูลเดิมอาจมีความไม่สอดคล้องหรือค่าที่หายไปซึ่งทำให้การย้ายข้อมูลล้มเหลว

**Impact | ผลกระทบ:**
- ⚠️ Project delay of 1-2 months
- ⚠️ โครงการล่าช้า 1-2 เดือน
- ⚠️ Incomplete drug catalog
- ⚠️ แค็ตตาล็อกยาไม่สมบูรณ์
- ⚠️ Missing historical data
- ⚠️ ข้อมูลประวัติหายไป

**Mitigation | การลดความเสี่ยง:**
- ✅ Perform data quality assessment before migration
- ✅ ประเมินคุณภาพข้อมูลก่อนย้าย
- ✅ Create comprehensive data cleaning scripts
- ✅ สร้างสคริปต์ทำความสะอาดข้อมูลที่ครอบคลุม
- ✅ Run pilot migration with sample data
- ✅ ทดลองย้ายข้อมูลตัวอย่างก่อน
- ✅ Have manual data entry backup plan
- ✅ มีแผนสำรองการป้อนข้อมูล Manual

#### Risk 2: User Resistance
**ความเสี่ยงที่ 2: ผู้ใช้ไม่ยอมรับระบบ**

**Description | คำอธิบาย:**
Staff may resist adopting new system due to comfort with legacy system.

พนักงานอาจไม่ยอมรับระบบใหม่เพราะคุ้นเคยกับระบบเดิม

**Impact | ผลกระทบ:**
- ⚠️ Low user adoption rate
- ⚠️ อัตราการใช้งานต่ำ
- ⚠️ Parallel use of old and new systems
- ⚠️ ใช้ระบบเก่าและใหม่ไปพร้อมกัน
- ⚠️ Data entry errors
- ⚠️ ข้อผิดพลาดในการป้อนข้อมูล

**Mitigation | การลดความเสี่ยง:**
- ✅ Involve key users in design phase
- ✅ ให้ผู้ใช้หลักมีส่วนร่วมในการออกแบบ
- ✅ Provide comprehensive training program
- ✅ จัดการฝึกอบรมที่ครอบคลุม
- ✅ Create user-friendly interface
- ✅ สร้างส่วนติดต่อผู้ใช้ที่ใช้งานง่าย
- ✅ Have champions in each department
- ✅ มีผู้สนับสนุนในแต่ละแผนก
- ✅ Implement gradual rollout plan
- ✅ เปิดตัวทีละขั้นตอน

#### Risk 3: Budget Overrun
**ความเสี่ยงที่ 3: ใช้งบประมาณเกิน**

**Description | คำอธิบาย:**
Project may exceed allocated budget due to scope creep or technical challenges.

โครงการอาจใช้งบเกินเนื่องจากขอบเขตขยายหรือความท้าทายทางเทคนิค

**Impact | ผลกระทบ:**
- ⚠️ Project delays or incomplete features
- ⚠️ โครงการล่าช้าหรือฟีเจอร์ไม่สมบูรณ์
- ⚠️ Additional budget requests required
- ⚠️ ต้องขอเพิ่มงบประมาณ

**Mitigation | การลดความเสี่ยง:**
- ✅ Clear scope definition with priorities
- ✅ กำหนดขอบเขตชัดเจนพร้อมลำดับความสำคัญ
- ✅ Regular budget monitoring
- ✅ ติดตามงบประมาณสม่ำเสมอ
- ✅ Use agile approach for flexibility
- ✅ ใช้วิธีการแบบ Agile เพื่อความยืดหยุ่น
- ✅ Focus on must-have features first
- ✅ มุ่งเน้นฟีเจอร์ที่ต้องมีก่อน

### 12.2 Medium Risk | ความเสี่ยงปานกลาง

#### Risk 4: Integration Complexity
**ความเสี่ยงที่ 4: ความซับซ้อนในการบูรณาการ**

**Description | คำอธิบาย:**
Future integration with HIS or other systems may be more complex than anticipated.

การบูรณาการกับ HIS หรือระบบอื่น ๆ ในอนาคตอาจซับซ้อนกว่าที่คาดการณ์

**Mitigation | การลดความเสี่ยง:**
- ✅ Design with integration points in mind
- ✅ ออกแบบโดยคำนึงถึงจุดบูรณาการ
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
- ✅ ใช้การทำ Index ฐานข้อมูลที่เหมาะสม
- ✅ Use caching strategies (Redis)
- ✅ ใช้กลยุทธ์ Cache (Redis)
- ✅ Conduct load testing before go-live
- ✅ ทดสอบภาระก่อนเปิดใช้งานจริง
- ✅ Optimize SQL queries
- ✅ ปรับปรุง SQL query

### 12.3 Low Risk | ความเสี่ยงต่ำ

#### Risk 6: Vendor Changes
**ความเสี่ยงที่ 6: การเปลี่ยนแปลงผู้ขาย**

**Description | คำอธิบาย:**
Vendors may change contact information or go out of business.

ผู้ขายอาจเปลี่ยนข้อมูลติดต่อหรือปิดกิจการ

**Mitigation | การลดความเสี่ยง:**
- ✅ Maintain updated vendor database
- ✅ บำรุงรักษาฐานข้อมูลผู้ขายให้ทันสมัย
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
- วิธีการจัดการสต็อกที่จ่ายยาที่เข้าก่อนออกก่อน

**Fiscal Year | ปีงบประมาณ**
- Budget year from October 1 to September 30
- ปีงบประมาณตั้งแต่ 1 ตุลาคม ถึง 30 กันยายน

**Generic Drug | ยาชื่อสามัญ**
- Drug identified by its active pharmaceutical ingredient (API)
- ยาที่ระบุด้วยตัวยาสำคัญ (API)

**HIS (Hospital Information System)**
- Comprehensive system managing all hospital operations
- ระบบบริหารจัดการโรงพยาบาลแบบครบวงจร

**Lot Number**
- Unique identifier for a batch of drugs from manufacturer
- รหัสเฉพาะสำหรับชุดยาจากผู้ผลิต

**NLEM (National List of Essential Medicines)**
- Government's list of essential drugs (E = Essential, N = Non-essential)
- บัญชียาหลักแห่งชาติ (E = จำเป็น, N = ไม่จำเป็น)

**PDPA (Personal Data Protection Act B.E. 2562)**
- Thai law protecting personal data privacy
- พระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562

**PO (Purchase Order) | ใบสั่งซื้อ**
- Official order to vendor to supply goods
- เอกสารสั่งซื้อสินค้าอย่างเป็นทางการ

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
- การจัดกลุ่มตามความสำคัญ: V (สำคัญมาก), E (จำเป็น), N (ไม่จำเป็น)

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
- [ ] IT Manager (หัวหน้าไอที)
- [ ] Procurement Manager (หัวหน้าจัดซื้อ)

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

*เอกสารนี้จัดทำโดยอ้างอิงจากคู่มือ INVS, การวิเคราะห์ฐานข้อมูลเดิม และมาตรฐานกระทรวงสาธารณสุข*
