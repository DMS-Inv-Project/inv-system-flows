# INVS Modern - Quick Start Guide
## คู่มือเริ่มต้นใช้งานระบบ

---

## 🚀 **การติดตั้งและรัน**

### 1. เริ่มต้น Database
```bash
# Start all containers
docker-compose up -d

# Check containers are running
docker ps

# Expected: invs-modern-db, invs-modern-pgadmin
```

### 2. ติดตั้ง Dependencies
```bash
npm install
```

### 3. Setup Database Schema
```bash
# Generate Prisma client
npm run db:generate

# Push schema to database
npm run db:push

# Seed master data
npm run db:seed
```

### 4. Apply Views and Functions
```bash
# Create database views
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/views.sql

# Create database functions
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/functions.sql
```

### 5. Verify Installation
```bash
# Run application
npm run dev

# Open Prisma Studio
npm run db:studio
# Navigate to: http://localhost:5555
```

---

## 📊 **การใช้งานเบื้องต้น**

### ขั้นตอนที่ 1: ตรวจสอบข้อมูลพื้นฐาน

```sql
-- Connect to database
docker exec -it invs-modern-db psql -U invs_user -d invs_modern

-- Check master data
SELECT 'Locations' as table_name, COUNT(*) FROM locations
UNION ALL
SELECT 'Departments', COUNT(*) FROM departments
UNION ALL
SELECT 'Budget Types', COUNT(*) FROM budget_types
UNION ALL
SELECT 'Companies', COUNT(*) FROM companies
UNION ALL
SELECT 'Drug Generics', COUNT(*) FROM drug_generics
UNION ALL
SELECT 'Budget Allocations', COUNT(*) FROM budget_allocations;
```

**Expected Result:**
```
table_name        | count
------------------+-------
Locations         |     5
Departments       |     5
Budget Types      |     6
Companies         |     5
Drug Generics     |     5
Budget Allocations|     3
```

### ขั้นตอนที่ 2: สร้าง Purchase Request แรก

```sql
-- 1. Create PR
INSERT INTO purchase_requests (
  pr_number,
  pr_date,
  department_id,
  budget_allocation_id,
  status,
  requested_amount,
  purpose,
  urgency,
  requested_by,
  created_at
) VALUES (
  'PR-2025-001',
  CURRENT_DATE,
  2, -- Pharmacy Department
  1, -- Budget Allocation ID
  'draft',
  50000.00,
  'Stock replenishment for Paracetamol',
  'normal',
  'Pharmacist A',
  CURRENT_TIMESTAMP
) RETURNING id;
-- Save the returned ID (e.g., 1)

-- 2. Add PR Items
INSERT INTO purchase_request_items (
  pr_id,
  item_number,
  generic_id,
  quantity_requested,
  estimated_unit_cost,
  notes
) VALUES (
  1, -- Use PR ID from above
  1,
  1, -- Paracetamol generic
  5000,
  5.00,
  'Generic Paracetamol 500mg'
);

-- 3. Check Budget Availability
SELECT * FROM check_budget_availability(
  p_fiscal_year := 2025,
  p_budget_type_id := 1,
  p_department_id := 2,
  p_amount := 50000.00,
  p_quarter := 1
);

-- 4. If budget available, reserve it
SELECT reserve_budget(
  p_allocation_id := 1,
  p_pr_id := 1,
  p_amount := 50000.00,
  p_expires_days := 30
);

-- 5. Update PR status
UPDATE purchase_requests
SET status = 'submitted'
WHERE id = 1;
```

### ขั้นตอนที่ 3: ตรวจสอบรายงาน

```sql
-- Budget Status
SELECT * FROM budget_status_current
WHERE fiscal_year = 2025;

-- Active Reservations
SELECT * FROM budget_reservations_active;

-- Purchase Requests
SELECT
  pr_number,
  pr_date,
  status,
  requested_amount,
  requested_by
FROM purchase_requests
ORDER BY pr_date DESC;
```

---

## 🎯 **ฟีเจอร์หลักที่พร้อมใช้งาน**

### 1. Budget Management
- ✅ Budget Allocation (แบ่งงบรายไตรมาส)
- ✅ Budget Check (ตรวจสอบงบคงเหลือ)
- ✅ Budget Reservation (จองงบไว้สำหรับ PR)
- ✅ Budget Commitment (หักงบจริงเมื่ออนุมัติ PO)
- ✅ Real-time Monitoring (ติดตามการใช้จ่ายแบบทันที)

**Key Functions:**
```sql
check_budget_availability(fiscal_year, budget_type_id, department_id, amount, quarter)
reserve_budget(allocation_id, pr_id, amount, expires_days)
commit_budget(allocation_id, po_id, amount, quarter)
release_budget_reservation(reservation_id)
```

### 2. Procurement Workflow
- ✅ Purchase Request (PR) - สร้างคำขอซื้อ
- ✅ Purchase Order (PO) - สร้างใบสั่งซื้อ
- ✅ Goods Receipt - รับของเข้าคลัง
- ✅ Budget Integration - เชื่อมโยงงบประมาณ

**Workflow:**
```
Draft → Submitted → Approved → Converted to PO → Sent → Received → Closed
```

### 3. Inventory Management
- ✅ Multi-location Support - รองรับหลาย location
- ✅ FIFO/FEFO - จัดการลำดับการจ่าย
- ✅ Lot Tracking - ติดตาม lot number และวันหมดอายุ
- ✅ Stock Alerts - แจ้งเตือนสต็อกต่ำ/ใกล้หมดอายุ

**Key Functions:**
```sql
get_fifo_lots(drug_id, location_id, quantity_needed)
get_fefo_lots(drug_id, location_id, quantity_needed)
update_inventory_from_receipt(receipt_id)
```

### 4. Drug Distribution
- ✅ Department Requests - หน่วยงานขอเบิกยา
- ✅ FEFO Lot Selection - เลือก lot ตามวันหมดอายุ
- ✅ Inventory Auto-update - ปรับ stock อัตโนมัติ

### 5. TMT Integration
- ✅ Drug Code Mapping - แมพรหัสยากับ TMT
- ✅ HIS Integration - เชื่อมระบบ HIS
- ✅ Ministry Standards - มาตรฐาน กสธ.

### 6. Ministry Reporting
- ✅ 5 แฟ้มข้อมูล - ครบตามที่ กสธ. กำหนด
  1. export_druglist
  2. export_purchase_plan
  3. export_receipt
  4. export_distribution
  5. export_inventory

---

## 📖 **เอกสารอ้างอิง**

### เอกสารหลัก
1. **[FLOW_01_Master_Data_Setup.md](./FLOW_01_Master_Data_Setup.md)**
   - ตั้งค่าข้อมูลพื้นฐานทั้งหมด
   - Mockups และตัวอย่าง SQL

2. **[FLOW_02_Budget_Management.md](./FLOW_02_Budget_Management.md)**
   - บริหารงบประมาณแบบครบวงจร
   - Functions และ monitoring queries

3. **[FLOW_03_Procurement_Part1_PR.md](./FLOW_03_Procurement_Part1_PR.md)**
   - สร้างและอนุมัติ Purchase Request
   - Budget reservation workflow

4. **[DATA_FLOW_COMPLETE_GUIDE.md](./DATA_FLOW_COMPLETE_GUIDE.md)**
   - สรุปทุก flow พร้อมตัวอย่าง end-to-end
   - Database state ในแต่ละขั้นตอน

### เอกสารเทคนิค
- **[prisma/schema.prisma](../prisma/schema.prisma)** - Database schema
- **[prisma/views.sql](../prisma/views.sql)** - 11 reporting views
- **[prisma/functions.sql](../prisma/functions.sql)** - 10 business logic functions
- **[business-rules.md](./business-rules.md)** - Business rules & authorization

---

## 🔧 **Useful Commands**

### Database Operations
```bash
# Connect to database
docker exec -it invs-modern-db psql -U invs_user -d invs_modern

# View logs
docker logs invs-modern-db

# Restart database
docker-compose restart invs-modern-db

# Backup database
docker exec invs-modern-db pg_dump -U invs_user invs_modern > backup.sql

# Restore database
docker exec -i invs-modern-db psql -U invs_user invs_modern < backup.sql
```

### Prisma Operations
```bash
# Generate client
npm run db:generate

# Push schema changes
npm run db:push

# Create migration
npm run db:migrate

# Seed data
npm run db:seed

# Open Studio
npm run db:studio
```

### Development
```bash
# Run dev server
npm run dev

# Build TypeScript
npm run build

# Run production
npm start
```

---

## 🔍 **Monitoring Queries**

### Daily Health Check
```sql
-- System Overview
SELECT
  'Total PRs Today' as metric,
  COUNT(*)::text as value
FROM purchase_requests
WHERE pr_date = CURRENT_DATE
UNION ALL
SELECT 'Active POs', COUNT(*)::text
FROM purchase_orders
WHERE status IN ('approved', 'sent')
UNION ALL
SELECT 'Low Stock Items', COUNT(*)::text
FROM low_stock_items
UNION ALL
SELECT 'Drugs Expiring Soon', COUNT(*)::text
FROM expiring_drugs
WHERE urgency_level IN ('CRITICAL', 'WARNING')
UNION ALL
SELECT 'Active Budget Reservations', COUNT(*)::text
FROM budget_reservations_active;
```

### Budget Dashboard
```sql
-- Budget Utilization by Department
SELECT
  dept_name,
  budget_name,
  total_budget,
  total_spent,
  remaining_budget,
  ROUND(utilization_percentage, 2) as utilization_pct,
  budget_alert_level
FROM budget_status_current
WHERE fiscal_year = 2025
ORDER BY utilization_percentage DESC;
```

### Inventory Alerts
```sql
-- Critical Items
SELECT 'Low Stock' as alert_type, COUNT(*) as count
FROM low_stock_items
WHERE stock_level IN ('OUT_OF_STOCK', 'CRITICAL')
UNION ALL
SELECT 'Expiring Soon', COUNT(*)
FROM expiring_drugs
WHERE urgency_level = 'CRITICAL'
UNION ALL
SELECT 'Expired', COUNT(*)
FROM expiring_drugs
WHERE urgency_level = 'EXPIRED';
```

---

## ⚠️ **Common Issues & Solutions**

### Issue 1: Container won't start
```bash
# Check logs
docker logs invs-modern-db

# Remove and recreate
docker-compose down
docker-compose up -d
```

### Issue 2: Prisma client errors
```bash
# Regenerate client
npm run db:generate

# Clear node_modules
rm -rf node_modules
npm install
```

### Issue 3: Views not found
```bash
# Reapply views
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/views.sql
```

### Issue 4: Functions not found
```bash
# Reapply functions
docker exec -i invs-modern-db psql -U invs_user -d invs_modern < prisma/functions.sql
```

---

## 📞 **Support**

### Web Interfaces
- **pgAdmin**: http://localhost:8081
  - Email: admin@invs.com
  - Password: invs123

- **Prisma Studio**: http://localhost:5555
  - Run: `npm run db:studio`

### Connection Details
- **Host**: localhost
- **Port**: 5434
- **Database**: invs_modern
- **Username**: invs_user
- **Password**: invs123

---

## ✅ **Next Steps**

1. ✅ ระบบติดตั้งและรันสำเร็จ
2. ✅ ข้อมูลพื้นฐานพร้อมใช้งาน (seed data)
3. ✅ Views และ Functions ถูกสร้าง
4. 🔄 **ต่อไป**: พัฒนา Frontend/API สำหรับ:
   - Purchase Request UI
   - Budget Dashboard
   - Inventory Management
   - Drug Distribution
   - Ministry Reports Export

### Recommended Development Order
1. **Phase 1**: Master Data CRUD (Locations, Departments, Companies, Drugs)
2. **Phase 2**: Budget Allocation & Monitoring
3. **Phase 3**: Purchase Request Workflow
4. **Phase 4**: Purchase Order & Receipt
5. **Phase 5**: Inventory & Distribution
6. **Phase 6**: TMT Integration
7. **Phase 7**: Ministry Reporting

---

**🎉 ระบบพร้อมใช้งาน!**

สามารถเริ่มพัฒนา Frontend หรือ API ต่อได้ทันที โดยอ้างอิงจากเอกสาร Flow ที่เตรียมไว้

*Created with ❤️ by Claude Code*
