-- ============================================================
-- INVS Modern - Database Functions & Stored Procedures
-- ============================================================

-- ============================================================
-- 1. BUDGET MANAGEMENT FUNCTIONS
-- ============================================================

-- Function: Check Budget Availability
-- ตรวจสอบว่างบประมาณเพียงพอหรือไม่
CREATE OR REPLACE FUNCTION check_budget_availability(
    p_fiscal_year INT,
    p_budget_type_id BIGINT,
    p_department_id BIGINT,
    p_amount DECIMAL(15,2),
    p_quarter INT DEFAULT NULL
)
RETURNS TABLE (
    available BOOLEAN,
    allocation_id BIGINT,
    total_budget DECIMAL(15,2),
    total_spent DECIMAL(15,2),
    remaining_budget DECIMAL(15,2),
    quarter_budget DECIMAL(15,2),
    quarter_spent DECIMAL(15,2),
    quarter_remaining DECIMAL(15,2),
    message TEXT
) AS $$
DECLARE
    v_allocation budget_allocations%ROWTYPE;
    v_q_budget DECIMAL(15,2);
    v_q_spent DECIMAL(15,2);
    v_q_remaining DECIMAL(15,2);
BEGIN
    -- ดึงข้อมูล budget allocation
    SELECT * INTO v_allocation
    FROM budget_allocations
    WHERE fiscal_year = p_fiscal_year
      AND budget_type_id = p_budget_type_id
      AND department_id = p_department_id
      AND status = 'ACTIVE';

    -- ถ้าไม่พบ allocation
    IF NOT FOUND THEN
        RETURN QUERY SELECT
            FALSE,
            NULL::BIGINT,
            0::DECIMAL(15,2),
            0::DECIMAL(15,2),
            0::DECIMAL(15,2),
            0::DECIMAL(15,2),
            0::DECIMAL(15,2),
            0::DECIMAL(15,2),
            'No active budget allocation found'::TEXT;
        RETURN;
    END IF;

    -- ตรวจสอบตามไตรมาส (ถ้าระบุ)
    IF p_quarter IS NOT NULL THEN
        CASE p_quarter
            WHEN 1 THEN
                v_q_budget := v_allocation.q1_budget;
                v_q_spent := v_allocation.q1_spent;
            WHEN 2 THEN
                v_q_budget := v_allocation.q2_budget;
                v_q_spent := v_allocation.q2_spent;
            WHEN 3 THEN
                v_q_budget := v_allocation.q3_budget;
                v_q_spent := v_allocation.q3_spent;
            WHEN 4 THEN
                v_q_budget := v_allocation.q4_budget;
                v_q_spent := v_allocation.q4_spent;
            ELSE
                v_q_budget := 0;
                v_q_spent := 0;
        END CASE;

        v_q_remaining := v_q_budget - v_q_spent;

        -- ตรวจสอบงบไตรมาส
        IF v_q_remaining >= p_amount THEN
            RETURN QUERY SELECT
                TRUE,
                v_allocation.id,
                v_allocation.total_budget,
                v_allocation.total_spent,
                v_allocation.remaining_budget,
                v_q_budget,
                v_q_spent,
                v_q_remaining,
                format('Budget available for Q%s', p_quarter)::TEXT;
        ELSE
            RETURN QUERY SELECT
                FALSE,
                v_allocation.id,
                v_allocation.total_budget,
                v_allocation.total_spent,
                v_allocation.remaining_budget,
                v_q_budget,
                v_q_spent,
                v_q_remaining,
                format('Insufficient budget for Q%s (need: %s, available: %s)',
                    p_quarter, p_amount, v_q_remaining)::TEXT;
        END IF;
    ELSE
        -- ตรวจสอบงบรวมทั้งปี
        IF v_allocation.remaining_budget >= p_amount THEN
            RETURN QUERY SELECT
                TRUE,
                v_allocation.id,
                v_allocation.total_budget,
                v_allocation.total_spent,
                v_allocation.remaining_budget,
                NULL::DECIMAL(15,2),
                NULL::DECIMAL(15,2),
                NULL::DECIMAL(15,2),
                'Budget available (annual check)'::TEXT;
        ELSE
            RETURN QUERY SELECT
                FALSE,
                v_allocation.id,
                v_allocation.total_budget,
                v_allocation.total_spent,
                v_allocation.remaining_budget,
                NULL::DECIMAL(15,2),
                NULL::DECIMAL(15,2),
                NULL::DECIMAL(15,2),
                format('Insufficient budget (need: %s, available: %s)',
                    p_amount, v_allocation.remaining_budget)::TEXT;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function: Reserve Budget
-- จองงบประมาณสำหรับ Purchase Request
CREATE OR REPLACE FUNCTION reserve_budget(
    p_allocation_id BIGINT,
    p_pr_id BIGINT,
    p_amount DECIMAL(15,2),
    p_expires_days INT DEFAULT 30
)
RETURNS BIGINT AS $$
DECLARE
    v_reservation_id BIGINT;
    v_remaining_budget DECIMAL(15,2);
BEGIN
    -- ตรวจสอบงบคงเหลือ
    SELECT remaining_budget INTO v_remaining_budget
    FROM budget_allocations
    WHERE id = p_allocation_id AND status = 'ACTIVE';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Budget allocation not found or inactive';
    END IF;

    IF v_remaining_budget < p_amount THEN
        RAISE EXCEPTION 'Insufficient budget (available: %, requested: %)',
            v_remaining_budget, p_amount;
    END IF;

    -- สร้าง reservation
    INSERT INTO budget_reservations (
        allocation_id,
        pr_id,
        reserved_amount,
        reservation_date,
        expires_date,
        status
    ) VALUES (
        p_allocation_id,
        p_pr_id,
        p_amount,
        CURRENT_DATE,
        CURRENT_DATE + (p_expires_days || ' days')::INTERVAL,
        'ACTIVE'
    ) RETURNING id INTO v_reservation_id;

    RETURN v_reservation_id;
END;
$$ LANGUAGE plpgsql;

-- Function: Commit Budget
-- ตัดงบประมาณจริงเมื่อ approve Purchase Order
CREATE OR REPLACE FUNCTION commit_budget(
    p_allocation_id BIGINT,
    p_po_id BIGINT,
    p_amount DECIMAL(15,2),
    p_quarter INT
)
RETURNS BOOLEAN AS $$
DECLARE
    v_remaining_budget DECIMAL(15,2);
BEGIN
    -- ตรวจสอบงบคงเหลือ
    SELECT remaining_budget INTO v_remaining_budget
    FROM budget_allocations
    WHERE id = p_allocation_id AND status = 'ACTIVE';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Budget allocation not found or inactive';
    END IF;

    IF v_remaining_budget < p_amount THEN
        RAISE EXCEPTION 'Insufficient budget (available: %, requested: %)',
            v_remaining_budget, p_amount;
    END IF;

    -- อัปเดตงบประมาณ
    UPDATE budget_allocations
    SET
        total_spent = total_spent + p_amount,
        remaining_budget = remaining_budget - p_amount,
        q1_spent = CASE WHEN p_quarter = 1 THEN q1_spent + p_amount ELSE q1_spent END,
        q2_spent = CASE WHEN p_quarter = 2 THEN q2_spent + p_amount ELSE q2_spent END,
        q3_spent = CASE WHEN p_quarter = 3 THEN q3_spent + p_amount ELSE q3_spent END,
        q4_spent = CASE WHEN p_quarter = 4 THEN q4_spent + p_amount ELSE q4_spent END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_allocation_id;

    -- อัปเดต reservation status
    UPDATE budget_reservations
    SET status = 'COMMITTED', po_id = p_po_id
    WHERE allocation_id = p_allocation_id AND status = 'ACTIVE';

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Function: Release Budget
-- ปลดล็อคงบประมาณที่จองไว้ (เมื่อยกเลิก PR)
CREATE OR REPLACE FUNCTION release_budget(
    p_reservation_id BIGINT
)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE budget_reservations
    SET status = 'RELEASED'
    WHERE id = p_reservation_id AND status = 'ACTIVE';

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Reservation not found or already released/committed';
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Function: Check Drug in Budget Plan
-- ตรวจสอบว่ายาอยู่ในแผนจัดซื้อหรือไม่ และเหลืองบพอหรือไม่
CREATE OR REPLACE FUNCTION check_drug_in_budget_plan(
    p_fiscal_year INT,
    p_department_id BIGINT,
    p_generic_id BIGINT,
    p_requested_qty DECIMAL(10,2),
    p_quarter INT
)
RETURNS TABLE (
    in_plan BOOLEAN,
    plan_item_id BIGINT,
    planned_qty DECIMAL(10,2),
    remaining_qty DECIMAL(10,2),
    quarter_planned DECIMAL(10,2),
    quarter_purchased DECIMAL(10,2),
    quarter_remaining DECIMAL(10,2),
    over_plan BOOLEAN,
    message TEXT
) AS $$
DECLARE
    v_plan_item budget_plan_items%ROWTYPE;
    v_quarter_planned DECIMAL(10,2);
    v_quarter_purchased DECIMAL(10,2);
BEGIN
    -- ดึงข้อมูล budget plan item
    SELECT bpi.* INTO v_plan_item
    FROM budget_plan_items bpi
    JOIN budget_plans bp ON bpi.budget_plan_id = bp.id
    WHERE bp.fiscal_year = p_fiscal_year
        AND bp.department_id = p_department_id
        AND bp.status IN ('APPROVED', 'ACTIVE')
        AND bpi.generic_id = p_generic_id;

    -- ถ้าไม่พบในแผน
    IF NOT FOUND THEN
        RETURN QUERY SELECT
            FALSE,
            NULL::BIGINT,
            0::DECIMAL(10,2),
            0::DECIMAL(10,2),
            0::DECIMAL(10,2),
            0::DECIMAL(10,2),
            0::DECIMAL(10,2),
            FALSE,
            'Drug not found in budget plan'::TEXT;
        RETURN;
    END IF;

    -- ดึงข้อมูลไตรมาส
    CASE p_quarter
        WHEN 1 THEN
            v_quarter_planned := v_plan_item.q1_quantity;
            v_quarter_purchased := v_plan_item.q1_purchased_qty;
        WHEN 2 THEN
            v_quarter_planned := v_plan_item.q2_quantity;
            v_quarter_purchased := v_plan_item.q2_purchased_qty;
        WHEN 3 THEN
            v_quarter_planned := v_plan_item.q3_quantity;
            v_quarter_purchased := v_plan_item.q3_purchased_qty;
        WHEN 4 THEN
            v_quarter_planned := v_plan_item.q4_quantity;
            v_quarter_purchased := v_plan_item.q4_purchased_qty;
        ELSE
            v_quarter_planned := 0;
            v_quarter_purchased := 0;
    END CASE;

    -- คำนวณเหลือและคืนผลลัพธ์
    RETURN QUERY SELECT
        TRUE,
        v_plan_item.id,
        v_plan_item.planned_quantity,
        v_plan_item.remaining_quantity,
        v_quarter_planned,
        v_quarter_purchased,
        (v_quarter_planned - v_quarter_purchased),
        (p_requested_qty > (v_quarter_planned - v_quarter_purchased)),
        CASE
            WHEN p_requested_qty > (v_quarter_planned - v_quarter_purchased) THEN
                format('Request exceeds quarterly plan (planned: %s, purchased: %s, requested: %s)',
                    v_quarter_planned, v_quarter_purchased, p_requested_qty)
            ELSE
                'Within budget plan'
        END::TEXT;
END;
$$ LANGUAGE plpgsql;

-- Function: Update Budget Plan Purchase
-- อัปเดตยอดจัดซื้อในแผนงบประมาณ
CREATE OR REPLACE FUNCTION update_budget_plan_purchase(
    p_plan_item_id BIGINT,
    p_quantity DECIMAL(10,2),
    p_value DECIMAL(15,2),
    p_quarter INT
)
RETURNS BOOLEAN AS $$
BEGIN
    -- อัปเดตยอดจัดซื้อในแผน
    UPDATE budget_plan_items
    SET
        purchased_quantity = purchased_quantity + p_quantity,
        purchased_value = purchased_value + p_value,
        remaining_quantity = planned_quantity - (purchased_quantity + p_quantity),
        remaining_value = planned_total_cost - (purchased_value + p_value),
        q1_purchased_qty = CASE WHEN p_quarter = 1 THEN q1_purchased_qty + p_quantity ELSE q1_purchased_qty END,
        q2_purchased_qty = CASE WHEN p_quarter = 2 THEN q2_purchased_qty + p_quantity ELSE q2_purchased_qty END,
        q3_purchased_qty = CASE WHEN p_quarter = 3 THEN q3_purchased_qty + p_quantity ELSE q3_purchased_qty END,
        q4_purchased_qty = CASE WHEN p_quarter = 4 THEN q4_purchased_qty + p_quantity ELSE q4_purchased_qty END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_plan_item_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Budget plan item not found';
    END IF;

    -- อัปเดตยอดรวมในแผน
    UPDATE budget_plans bp
    SET
        total_purchased = total_purchased + p_value,
        remaining_budget = total_planned_budget - (total_purchased + p_value),
        q1_purchased = CASE WHEN p_quarter = 1 THEN q1_purchased + p_value ELSE q1_purchased END,
        q2_purchased = CASE WHEN p_quarter = 2 THEN q2_purchased + p_value ELSE q2_purchased END,
        q3_purchased = CASE WHEN p_quarter = 3 THEN q3_purchased + p_value ELSE q3_purchased END,
        q4_purchased = CASE WHEN p_quarter = 4 THEN q4_purchased + p_value ELSE q4_purchased END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = (SELECT budget_plan_id FROM budget_plan_items WHERE id = p_plan_item_id);

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 2. INVENTORY MANAGEMENT FUNCTIONS
-- ============================================================

-- Function: Calculate Reorder Point
-- คำนวณจุด reorder (สำหรับอัปเดตอัตโนมัติ)
CREATE OR REPLACE FUNCTION calculate_reorder_point(
    p_drug_id BIGINT,
    p_location_id BIGINT,
    p_daily_usage DECIMAL(10,2),
    p_lead_time_days INT,
    p_safety_stock_percentage DECIMAL(5,2) DEFAULT 20.0
)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_reorder_point DECIMAL(10,2);
    v_safety_stock DECIMAL(10,2);
BEGIN
    -- คำนวณ safety stock
    v_safety_stock := (p_daily_usage * p_lead_time_days) * (p_safety_stock_percentage / 100);

    -- คำนวณ reorder point
    v_reorder_point := (p_daily_usage * p_lead_time_days) + v_safety_stock;

    -- อัปเดตใน inventory
    UPDATE inventory
    SET reorder_point = v_reorder_point,
        min_level = v_safety_stock
    WHERE drug_id = p_drug_id AND location_id = p_location_id;

    RETURN v_reorder_point;
END;
$$ LANGUAGE plpgsql;

-- Function: Get FIFO Lots
-- ดึง lot ตามหลัก FIFO (First In First Out)
CREATE OR REPLACE FUNCTION get_fifo_lots(
    p_drug_id BIGINT,
    p_location_id BIGINT,
    p_quantity_needed DECIMAL(10,2)
)
RETURNS TABLE (
    lot_id BIGINT,
    lot_number VARCHAR(20),
    quantity_available DECIMAL(10,2),
    quantity_to_dispense DECIMAL(10,2),
    unit_cost DECIMAL(10,2),
    expiry_date DATE
) AS $$
DECLARE
    v_remaining DECIMAL(10,2) := p_quantity_needed;
    v_lot RECORD;
BEGIN
    FOR v_lot IN
        SELECT id, lot_number, quantity_available, unit_cost, expiry_date
        FROM drug_lots
        WHERE drug_id = p_drug_id
          AND location_id = p_location_id
          AND is_active = true
          AND quantity_available > 0
        ORDER BY received_date ASC, expiry_date ASC
    LOOP
        IF v_remaining <= 0 THEN
            EXIT;
        END IF;

        RETURN QUERY SELECT
            v_lot.id,
            v_lot.lot_number,
            v_lot.quantity_available,
            LEAST(v_lot.quantity_available, v_remaining),
            v_lot.unit_cost,
            v_lot.expiry_date;

        v_remaining := v_remaining - LEAST(v_lot.quantity_available, v_remaining);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function: Get FEFO Lots
-- ดึง lot ตามหลัก FEFO (First Expire First Out)
CREATE OR REPLACE FUNCTION get_fefo_lots(
    p_drug_id BIGINT,
    p_location_id BIGINT,
    p_quantity_needed DECIMAL(10,2)
)
RETURNS TABLE (
    lot_id BIGINT,
    lot_number VARCHAR(20),
    quantity_available DECIMAL(10,2),
    quantity_to_dispense DECIMAL(10,2),
    unit_cost DECIMAL(10,2),
    expiry_date DATE,
    days_until_expiry INT
) AS $$
DECLARE
    v_remaining DECIMAL(10,2) := p_quantity_needed;
    v_lot RECORD;
BEGIN
    FOR v_lot IN
        SELECT id, lot_number, quantity_available, unit_cost, expiry_date,
               (expiry_date - CURRENT_DATE) as days_left
        FROM drug_lots
        WHERE drug_id = p_drug_id
          AND location_id = p_location_id
          AND is_active = true
          AND quantity_available > 0
          AND expiry_date > CURRENT_DATE
        ORDER BY expiry_date ASC, received_date ASC
    LOOP
        IF v_remaining <= 0 THEN
            EXIT;
        END IF;

        RETURN QUERY SELECT
            v_lot.id,
            v_lot.lot_number,
            v_lot.quantity_available,
            LEAST(v_lot.quantity_available, v_remaining),
            v_lot.unit_cost,
            v_lot.expiry_date,
            v_lot.days_left;

        v_remaining := v_remaining - LEAST(v_lot.quantity_available, v_remaining);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function: Update Inventory from Receipt
-- อัปเดต inventory เมื่อรับยา
CREATE OR REPLACE FUNCTION update_inventory_from_receipt(
    p_receipt_id BIGINT
)
RETURNS BOOLEAN AS $$
DECLARE
    v_item RECORD;
    v_inventory_id BIGINT;
BEGIN
    -- วนลูปทุกรายการใน receipt
    FOR v_item IN
        SELECT ri.drug_id, ri.quantity_received, ri.unit_cost, ri.lot_number, ri.expiry_date
        FROM receipt_items ri
        WHERE ri.receipt_id = p_receipt_id
    LOOP
        -- ตรวจสอบว่ามี inventory record หรือยัง
        SELECT id INTO v_inventory_id
        FROM inventory
        WHERE drug_id = v_item.drug_id AND location_id = 1; -- Default location

        IF NOT FOUND THEN
            -- สร้าง inventory ใหม่
            INSERT INTO inventory (drug_id, location_id, quantity_on_hand, average_cost, last_cost)
            VALUES (v_item.drug_id, 1, v_item.quantity_received, v_item.unit_cost, v_item.unit_cost)
            RETURNING id INTO v_inventory_id;
        ELSE
            -- อัปเดต inventory ที่มีอยู่
            UPDATE inventory
            SET
                quantity_on_hand = quantity_on_hand + v_item.quantity_received,
                average_cost = ((quantity_on_hand * average_cost) + (v_item.quantity_received * v_item.unit_cost)) /
                               (quantity_on_hand + v_item.quantity_received),
                last_cost = v_item.unit_cost,
                last_updated = CURRENT_TIMESTAMP
            WHERE id = v_inventory_id;
        END IF;

        -- สร้าง drug lot
        INSERT INTO drug_lots (
            drug_id, location_id, lot_number, expiry_date,
            quantity_available, unit_cost, received_date, receipt_id
        ) VALUES (
            v_item.drug_id, 1, v_item.lot_number, v_item.expiry_date,
            v_item.quantity_received, v_item.unit_cost, CURRENT_DATE, p_receipt_id
        );

        -- บันทึก transaction
        INSERT INTO inventory_transactions (
            inventory_id, transaction_type, quantity, unit_cost,
            reference_id, reference_type, created_by, notes
        ) VALUES (
            v_inventory_id, 'RECEIVE', v_item.quantity_received, v_item.unit_cost,
            p_receipt_id, 'RECEIPT', 1, 'Auto-updated from receipt'
        );
    END LOOP;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 3. UTILITY FUNCTIONS
-- ============================================================

-- Function: Get Current Quarter
-- หาไตรมาสปัจจุบัน
CREATE OR REPLACE FUNCTION get_current_quarter()
RETURNS INT AS $$
BEGIN
    RETURN EXTRACT(QUARTER FROM CURRENT_DATE);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Function: Get Fiscal Year
-- หาปีงบประมาณปัจจุบัน
CREATE OR REPLACE FUNCTION get_fiscal_year()
RETURNS INT AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM CURRENT_DATE);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ============================================================
-- Comments
-- ============================================================

COMMENT ON FUNCTION check_budget_availability IS 'ตรวจสอบว่างบประมาณเพียงพอหรือไม่ (ทั้งรายปีและรายไตรมาส)';
COMMENT ON FUNCTION reserve_budget IS 'จองงบประมาณสำหรับ Purchase Request (ล็อคงบชั่วคราว)';
COMMENT ON FUNCTION commit_budget IS 'ตัดงบประมาณจริงเมื่อ approve Purchase Order';
COMMENT ON FUNCTION release_budget IS 'ปลดล็อคงบประมาณที่จองไว้ (เมื่อยกเลิก PR)';
COMMENT ON FUNCTION check_drug_in_budget_plan IS 'ตรวจสอบว่ายาอยู่ในแผนจัดซื้อหรือไม่ และเหลือจำนวนพอหรือไม่ (แยกรายไตรมาส)';
COMMENT ON FUNCTION update_budget_plan_purchase IS 'อัปเดตยอดจัดซื้อในแผนงบประมาณเมื่อจัดซื้อจริง';
COMMENT ON FUNCTION calculate_reorder_point IS 'คำนวณจุด reorder point โดยใช้ daily usage และ lead time';
COMMENT ON FUNCTION get_fifo_lots IS 'ดึง lot ตามหลัก FIFO (First In First Out)';
COMMENT ON FUNCTION get_fefo_lots IS 'ดึง lot ตามหลัก FEFO (First Expire First Out)';
COMMENT ON FUNCTION update_inventory_from_receipt IS 'อัปเดต inventory อัตโนมัติเมื่อรับยา';
COMMENT ON FUNCTION get_current_quarter IS 'หาไตรมาสปัจจุบัน (1-4)';
COMMENT ON FUNCTION get_fiscal_year IS 'หาปีงบประมาณปัจจุบัน';
