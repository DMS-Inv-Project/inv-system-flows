-- ============================================================
-- INVS Modern - Database Views for Ministry Reporting
-- ============================================================

-- ============================================================
-- 1. MINISTRY EXPORT VIEWS (5 แฟ้มข้อมูล กสธ.)
-- ============================================================

-- View 1: Export Druglist (บัญชีรายการยา)
CREATE OR REPLACE VIEW export_druglist AS
SELECT
    dg.working_code,
    dg.drug_name as generic_name,
    dg.tmt_code,
    dg.dosage_form,
    dg.sale_unit,
    dg.standard_unit,
    dg.therapeutic_group,
    d.drug_code,
    d.trade_name,
    d.nc24_code,
    d.registration_number,
    d.gpo_code,
    d.atc_code,
    d.strength,
    d.pack_size,
    d.unit,
    c.company_name as manufacturer,
    c.tax_id as manufacturer_tax_id,
    d.is_active,
    d.created_at,
    d.updated_at
FROM drug_generics dg
LEFT JOIN drugs d ON dg.id = d.generic_id
LEFT JOIN companies c ON d.manufacturer_id = c.id
WHERE dg.is_active = true
ORDER BY dg.working_code, d.drug_code;

-- View 2: Export Purchase Plan (แผนจัดซื้อยา)
CREATE OR REPLACE VIEW export_purchase_plan AS
SELECT
    pr.pr_number,
    pr.pr_date,
    dept.dept_code,
    dept.dept_name,
    bt.budget_code,
    bt.budget_name,
    ba.fiscal_year,
    pr.requested_amount,
    pr.status,
    pr.purpose,
    pr.urgency,
    pr.requested_by,
    pr.approved_by,
    pr.approval_date,
    pr.converted_to_po,
    pr.created_at
FROM purchase_requests pr
JOIN departments dept ON pr.department_id = dept.id
LEFT JOIN budget_allocations ba ON pr.budget_allocation_id = ba.id
LEFT JOIN budget_types bt ON ba.budget_type_id = bt.id
WHERE pr.status != 'draft'
ORDER BY pr.pr_date DESC, pr.pr_number;

-- View 3: Export Receipt (การรับยาเข้าคลัง)
CREATE OR REPLACE VIEW export_receipt AS
SELECT
    r.receipt_number,
    r.receipt_date,
    po.po_number,
    c.company_name as vendor_name,
    c.tax_id as vendor_tax_id,
    ri.drug_id,
    d.drug_code,
    dg.working_code,
    dg.drug_name as generic_name,
    d.trade_name,
    ri.quantity_received,
    ri.unit_cost,
    (ri.quantity_received * ri.unit_cost) as total_cost,
    ri.lot_number,
    ri.expiry_date,
    r.status,
    r.received_by,
    r.verified_by,
    r.created_at
FROM receipts r
JOIN purchase_orders po ON r.po_id = po.id
JOIN companies c ON po.vendor_id = c.id
JOIN receipt_items ri ON r.id = ri.receipt_id
JOIN drugs d ON ri.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
WHERE r.status IN ('received', 'verified', 'posted')
ORDER BY r.receipt_date DESC, r.receipt_number;

-- View 4: Export Distribution (การจ่ายยาออกจากคลัง)
CREATE OR REPLACE VIEW export_distribution AS
SELECT
    dd.distribution_number,
    dd.distribution_date,
    loc_from.location_name as from_location,
    loc_to.location_name as to_location,
    dept.dept_name as requesting_department,
    dd.purpose,
    ddi.drug_id,
    d.drug_code,
    dg.working_code,
    dg.drug_name as generic_name,
    d.trade_name,
    ddi.quantity_dispensed,
    ddi.unit_cost,
    ddi.total_cost,
    ddi.lot_number,
    ddi.expiry_date,
    dd.status,
    dd.dispensed_by,
    dd.dispensed_date,
    dd.created_at
FROM drug_distributions dd
JOIN locations loc_from ON dd.from_location_id = loc_from.id
LEFT JOIN locations loc_to ON dd.to_location_id = loc_to.id
LEFT JOIN departments dept ON dd.requesting_dept_id = dept.id
JOIN drug_distribution_items ddi ON dd.id = ddi.distribution_id
JOIN drugs d ON ddi.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
WHERE dd.status IN ('dispensed', 'completed')
ORDER BY dd.distribution_date DESC, dd.distribution_number;

-- View 5: Export Inventory (ยาคงคลัง)
CREATE OR REPLACE VIEW export_inventory AS
SELECT
    dg.working_code,
    dg.drug_name as generic_name,
    d.drug_code,
    d.trade_name,
    l.location_name,
    l.location_code,
    inv.quantity_on_hand,
    inv.min_level,
    inv.max_level,
    inv.reorder_point,
    inv.average_cost,
    inv.last_cost,
    (inv.quantity_on_hand * inv.average_cost) as inventory_value,
    dl.lot_number,
    dl.expiry_date,
    dl.quantity_available,
    dl.unit_cost,
    CURRENT_DATE as report_date,
    CASE
        WHEN inv.quantity_on_hand <= inv.min_level THEN 'LOW_STOCK'
        WHEN inv.quantity_on_hand >= inv.max_level THEN 'OVERSTOCK'
        ELSE 'NORMAL'
    END as stock_status,
    CASE
        WHEN dl.expiry_date <= CURRENT_DATE + INTERVAL '30 days' THEN 'EXPIRING_SOON'
        WHEN dl.expiry_date <= CURRENT_DATE THEN 'EXPIRED'
        ELSE 'OK'
    END as expiry_status
FROM inventory inv
JOIN drugs d ON inv.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN locations l ON inv.location_id = l.id
LEFT JOIN drug_lots dl ON d.id = dl.drug_id AND l.id = dl.location_id AND dl.is_active = true
WHERE inv.quantity_on_hand > 0 OR dl.quantity_available > 0
ORDER BY l.location_name, dg.working_code, dl.expiry_date;

-- ============================================================
-- 2. OPERATIONAL REPORTING VIEWS
-- ============================================================

-- Budget Status View (สถานะงบประมาณปัจจุบัน)
CREATE OR REPLACE VIEW budget_status_current AS
SELECT
    ba.id as allocation_id,
    ba.fiscal_year,
    bt.budget_code,
    bt.budget_name,
    dept.dept_code,
    dept.dept_name,
    ba.total_budget,
    ba.total_spent,
    ba.remaining_budget,
    (ba.total_spent / NULLIF(ba.total_budget, 0) * 100) as utilization_percentage,
    ba.q1_budget,
    ba.q1_spent,
    (ba.q1_budget - ba.q1_spent) as q1_remaining,
    ba.q2_budget,
    ba.q2_spent,
    (ba.q2_budget - ba.q2_spent) as q2_remaining,
    ba.q3_budget,
    ba.q3_spent,
    (ba.q3_budget - ba.q3_spent) as q3_remaining,
    ba.q4_budget,
    ba.q4_spent,
    (ba.q4_budget - ba.q4_spent) as q4_remaining,
    ba.status,
    ba.updated_at,
    CASE
        WHEN ba.total_spent > ba.total_budget THEN 'OVER_BUDGET'
        WHEN (ba.total_spent / NULLIF(ba.total_budget, 0)) > 0.9 THEN 'HIGH_UTILIZATION'
        WHEN (ba.total_spent / NULLIF(ba.total_budget, 0)) > 0.7 THEN 'MEDIUM_UTILIZATION'
        ELSE 'LOW_UTILIZATION'
    END as budget_alert_level
FROM budget_allocations ba
JOIN budget_types bt ON ba.budget_type_id = bt.id
JOIN departments dept ON ba.department_id = dept.id
WHERE ba.status = 'active'
ORDER BY ba.fiscal_year DESC, dept.dept_code, bt.budget_code;

-- Expiring Drugs View (ยาใกล้หมดอายุ)
CREATE OR REPLACE VIEW expiring_drugs AS
SELECT
    dl.id as lot_id,
    dg.working_code,
    dg.drug_name as generic_name,
    d.drug_code,
    d.trade_name,
    l.location_name,
    dl.lot_number,
    dl.expiry_date,
    dl.quantity_available,
    dl.unit_cost,
    (dl.quantity_available * dl.unit_cost) as loss_value,
    (dl.expiry_date - CURRENT_DATE) as days_until_expiry,
    CASE
        WHEN dl.expiry_date <= CURRENT_DATE THEN 'EXPIRED'
        WHEN dl.expiry_date <= CURRENT_DATE + INTERVAL '7 days' THEN 'CRITICAL'
        WHEN dl.expiry_date <= CURRENT_DATE + INTERVAL '30 days' THEN 'WARNING'
        WHEN dl.expiry_date <= CURRENT_DATE + INTERVAL '90 days' THEN 'WATCH'
        ELSE 'OK'
    END as urgency_level
FROM drug_lots dl
JOIN drugs d ON dl.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN locations l ON dl.location_id = l.id
WHERE dl.is_active = true
  AND dl.quantity_available > 0
  AND dl.expiry_date <= CURRENT_DATE + INTERVAL '90 days'
ORDER BY dl.expiry_date ASC, dl.quantity_available DESC;

-- Low Stock Items View (ยาที่ใกล้หมด)
CREATE OR REPLACE VIEW low_stock_items AS
SELECT
    inv.id as inventory_id,
    dg.working_code,
    dg.drug_name as generic_name,
    d.drug_code,
    d.trade_name,
    l.location_name,
    inv.quantity_on_hand,
    inv.min_level,
    inv.reorder_point,
    inv.max_level,
    (inv.min_level - inv.quantity_on_hand) as shortage_quantity,
    (inv.max_level - inv.quantity_on_hand) as order_quantity,
    inv.average_cost,
    ((inv.max_level - inv.quantity_on_hand) * inv.average_cost) as estimated_order_cost,
    inv.last_updated,
    CASE
        WHEN inv.quantity_on_hand = 0 THEN 'OUT_OF_STOCK'
        WHEN inv.quantity_on_hand <= inv.min_level THEN 'CRITICAL'
        WHEN inv.quantity_on_hand <= inv.reorder_point THEN 'LOW'
        ELSE 'NORMAL'
    END as stock_level
FROM inventory inv
JOIN drugs d ON inv.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
JOIN locations l ON inv.location_id = l.id
WHERE inv.quantity_on_hand <= inv.reorder_point
ORDER BY
    CASE
        WHEN inv.quantity_on_hand = 0 THEN 1
        WHEN inv.quantity_on_hand <= inv.min_level THEN 2
        ELSE 3
    END,
    inv.quantity_on_hand ASC;

-- Current Stock Summary View (สรุปสต็อกปัจจุบัน)
CREATE OR REPLACE VIEW current_stock_summary AS
SELECT
    dg.working_code,
    dg.drug_name as generic_name,
    d.drug_code,
    d.trade_name,
    SUM(inv.quantity_on_hand) as total_quantity,
    AVG(inv.average_cost) as avg_cost,
    SUM(inv.quantity_on_hand * inv.average_cost) as total_value,
    COUNT(DISTINCT inv.location_id) as location_count,
    MIN(inv.min_level) as overall_min_level,
    MAX(inv.max_level) as overall_max_level,
    MAX(inv.last_updated) as last_updated
FROM inventory inv
JOIN drugs d ON inv.drug_id = d.id
JOIN drug_generics dg ON d.generic_id = dg.id
WHERE inv.quantity_on_hand > 0
GROUP BY dg.working_code, dg.drug_name, d.drug_code, d.trade_name
ORDER BY total_value DESC;

-- Active Budget Reservations View (งบที่จองไว้)
CREATE OR REPLACE VIEW budget_reservations_active AS
SELECT
    br.id as reservation_id,
    ba.fiscal_year,
    bt.budget_code,
    bt.budget_name,
    dept.dept_name,
    br.reserved_amount,
    br.reservation_date,
    br.expires_date,
    (br.expires_date - CURRENT_DATE) as days_until_expiry,
    br.status,
    pr.pr_number,
    pr.purpose as pr_purpose,
    po.po_number,
    CASE
        WHEN br.status = 'active' AND br.expires_date <= CURRENT_DATE THEN 'EXPIRED'
        WHEN br.status = 'active' AND br.expires_date <= CURRENT_DATE + INTERVAL '7 days' THEN 'EXPIRING_SOON'
        ELSE 'ACTIVE'
    END as reservation_status
FROM budget_reservations br
JOIN budget_allocations ba ON br.allocation_id = ba.id
JOIN budget_types bt ON ba.budget_type_id = bt.id
JOIN departments dept ON ba.department_id = dept.id
LEFT JOIN purchase_requests pr ON br.pr_id = pr.id
LEFT JOIN purchase_orders po ON br.po_id = po.id
WHERE br.status = 'active'
ORDER BY br.expires_date ASC;

-- Purchase Order Status View (สถานะใบสั่งซื้อ)
CREATE OR REPLACE VIEW purchase_order_status AS
SELECT
    po.po_number,
    po.po_date,
    po.delivery_date,
    c.company_name as vendor_name,
    dept.dept_name,
    bt.budget_name,
    po.total_amount,
    po.total_items,
    po.status,
    COUNT(DISTINCT r.id) as receipt_count,
    SUM(COALESCE(poi.quantity_received, 0)) as total_received,
    SUM(poi.quantity_ordered) as total_ordered,
    (SUM(COALESCE(poi.quantity_received, 0)) / NULLIF(SUM(poi.quantity_ordered), 0) * 100) as fulfillment_percentage,
    po.created_at,
    po.updated_at,
    CASE
        WHEN po.status = 'sent' AND po.delivery_date < CURRENT_DATE THEN 'OVERDUE'
        WHEN po.status = 'sent' AND po.delivery_date <= CURRENT_DATE + INTERVAL '7 days' THEN 'DUE_SOON'
        ELSE po.status::text
    END as delivery_status
FROM purchase_orders po
JOIN companies c ON po.vendor_id = c.id
LEFT JOIN departments dept ON po.department_id = dept.id
LEFT JOIN budget_types bt ON po.budget_type_id = bt.id
LEFT JOIN purchase_order_items poi ON po.id = poi.po_id
LEFT JOIN receipts r ON po.id = r.po_id
GROUP BY po.id, po.po_number, po.po_date, po.delivery_date, c.company_name,
         dept.dept_name, bt.budget_name, po.total_amount, po.total_items,
         po.status, po.created_at, po.updated_at
ORDER BY po.po_date DESC;

-- ============================================================
-- Comments
-- ============================================================

COMMENT ON VIEW export_druglist IS 'แฟ้มที่ 1: บัญชีรายการยา - สำหรับส่งรายงานกระทรวงสาธารณสุข';
COMMENT ON VIEW export_purchase_plan IS 'แฟ้มที่ 2: แผนจัดซื้อยา - สำหรับส่งรายงานกระทรวงสาธารณสุข';
COMMENT ON VIEW export_receipt IS 'แฟ้มที่ 3: การรับยาเข้าคลัง - สำหรับส่งรายงานกระทรวงสาธารณสุข';
COMMENT ON VIEW export_distribution IS 'แฟ้มที่ 4: การจ่ายยาออกจากคลัง - สำหรับส่งรายงานกระทรวงสาธารณสุข';
COMMENT ON VIEW export_inventory IS 'แฟ้มที่ 5: ยาคงคลัง - สำหรับส่งรายงานกระทรวงสาธารณสุข';
COMMENT ON VIEW budget_status_current IS 'แสดงสถานะงบประมาณปัจจุบันแยกตามหน่วยงานและประเภทงบ';
COMMENT ON VIEW expiring_drugs IS 'รายการยาที่ใกล้หมดอายุภายใน 90 วัน เรียงตามความเร่งด่วน';
COMMENT ON VIEW low_stock_items IS 'รายการยาที่มีปริมาณต่ำกว่า reorder point ต้องสั่งซื้อเพิ่ม';
COMMENT ON VIEW current_stock_summary IS 'สรุปยอดสต็อกปัจจุบันรวมทุก location';
COMMENT ON VIEW budget_reservations_active IS 'รายการงบที่จองไว้และยังไม่ได้ใช้';
COMMENT ON VIEW purchase_order_status IS 'สถานะใบสั่งซื้อและการรับของ';
