-- INVS MySQL Original Database - Sample Queries
-- Use these queries to explore the original database structure and data

-- 1. Overview of main tables with data counts
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) AS 'Table Size (MB)'
FROM information_schema.tables 
WHERE table_schema = 'invs_banpong' 
    AND TABLE_ROWS > 0
ORDER BY TABLE_ROWS DESC 
LIMIT 20;

-- 2. Drug master data overview
SELECT 
    COUNT(*) as total_drugs,
    COUNT(CASE WHEN HIDE = 'Y' THEN 1 END) as hidden_drugs,
    COUNT(CASE WHEN HIDE != 'Y' OR HIDE IS NULL THEN 1 END) as active_drugs
FROM drug_gn;

-- 3. Sample drug data with working codes
SELECT 
    WORKING_CODE,
    DRUG_NAME,
    DOSAGE_FORM,
    PACK_UNIT,
    MIN_LEVEL,
    MAX_LEVEL,
    LAST_BUY_COST
FROM drug_gn 
WHERE HIDE != 'Y' OR HIDE IS NULL
ORDER BY LAST_BUY_COST DESC
LIMIT 10;

-- 4. Company/vendor overview
SELECT 
    COMPANY_CODE,
    COMPANY_NAME,
    COMPANY_TYPE,
    COMPANY_PROVINCE,
    COMPANY_TEL
FROM company 
WHERE HIDE != 'Y' OR HIDE IS NULL
ORDER BY COMPANY_NAME
LIMIT 15;

-- 5. Inventory card transactions (latest)
SELECT 
    c.WORKING_CODE,
    d.DRUG_NAME,
    c.OPERATION,
    c.QTY_IN,
    c.QTY_OUT,
    c.QTY_BALANCE,
    c.COST,
    c.TRAN_DATE,
    c.DEPT_ID,
    c.STOCK_ID
FROM card c
LEFT JOIN drug_gn d ON c.WORKING_CODE = d.WORKING_CODE
ORDER BY c.TRAN_DATE DESC
LIMIT 20;

-- 6. Purchase orders summary
SELECT 
    po.PO_NO,
    po.PO_DATE,
    po.VENDOR_CODE,
    c.COMPANY_NAME,
    po.TOTAL_AMOUNT,
    po.STATUS,
    COUNT(poc.WORKING_CODE) as total_items
FROM ms_po po
LEFT JOIN company c ON po.VENDOR_CODE = c.COMPANY_CODE
LEFT JOIN ms_po_c poc ON po.PO_NO = poc.PO_NO
WHERE po.PO_DATE >= '2023-01-01'
GROUP BY po.PO_NO, po.PO_DATE, po.VENDOR_CODE, c.COMPANY_NAME, po.TOTAL_AMOUNT, po.STATUS
ORDER BY po.PO_DATE DESC
LIMIT 15;

-- 7. Department overview
SELECT 
    DEPT_ID,
    DEPT_NAME,
    PARENT_DEPT_ID,
    DEPT_TYPE,
    STATUS
FROM dept_id
WHERE STATUS = 'A'
ORDER BY DEPT_NAME;

-- 8. Stock levels by location
SELECT 
    inv.WORKING_CODE,
    d.DRUG_NAME,
    inv.STOCK_ID,
    inv.QTY_BALANCE,
    inv.MIN_LEVEL,
    inv.MAX_LEVEL,
    CASE 
        WHEN inv.QTY_BALANCE <= inv.MIN_LEVEL THEN 'LOW_STOCK'
        WHEN inv.QTY_BALANCE >= inv.MAX_LEVEL THEN 'OVERSTOCK'
        ELSE 'NORMAL'
    END as stock_status
FROM inv_md inv
LEFT JOIN drug_gn d ON inv.WORKING_CODE = d.WORKING_CODE
WHERE inv.QTY_BALANCE > 0
ORDER BY inv.QTY_BALANCE DESC
LIMIT 20;

-- 9. Recent receiving transactions
SELECT 
    ivo.IVO_NO,
    ivo.IVO_DATE,
    ivo.PO_NO,
    ivo.VENDOR_CODE,
    c.COMPANY_NAME,
    ivo.TOTAL_AMOUNT,
    COUNT(ivoc.WORKING_CODE) as total_items
FROM ms_ivo ivo
LEFT JOIN company c ON ivo.VENDOR_CODE = c.COMPANY_CODE
LEFT JOIN ms_ivo_c ivoc ON ivo.IVO_NO = ivoc.IVO_NO
WHERE ivo.IVO_DATE >= '2023-01-01'
GROUP BY ivo.IVO_NO, ivo.IVO_DATE, ivo.PO_NO, ivo.VENDOR_CODE, c.COMPANY_NAME, ivo.TOTAL_AMOUNT
ORDER BY ivo.IVO_DATE DESC
LIMIT 15;

-- 10. Budget type overview
SELECT 
    BUDGET_TYPE,
    BUDGET_NAME,
    HIDE
FROM bdg_type
WHERE HIDE != 'Y' OR HIDE IS NULL
ORDER BY BUDGET_TYPE;

-- 11. Drug usage analysis (from card table)
SELECT 
    c.WORKING_CODE,
    d.DRUG_NAME,
    SUM(c.QTY_OUT) as total_dispensed,
    COUNT(*) as transaction_count,
    AVG(c.COST) as avg_cost,
    MAX(c.TRAN_DATE) as last_transaction
FROM card c
LEFT JOIN drug_gn d ON c.WORKING_CODE = d.WORKING_CODE
WHERE c.OPERATION = 'ISSUE' 
    AND c.TRAN_DATE >= '2023-01-01'
GROUP BY c.WORKING_CODE, d.DRUG_NAME
HAVING SUM(c.QTY_OUT) > 0
ORDER BY total_dispensed DESC
LIMIT 20;

-- 12. Monthly transaction summary
SELECT 
    DATE_FORMAT(TRAN_DATE, '%Y-%m') as month,
    COUNT(*) as total_transactions,
    SUM(QTY_IN) as total_received,
    SUM(QTY_OUT) as total_issued,
    SUM(COST * QTY_IN) as total_value_in,
    SUM(COST * QTY_OUT) as total_value_out
FROM card 
WHERE TRAN_DATE >= '2023-01-01'
GROUP BY DATE_FORMAT(TRAN_DATE, '%Y-%m')
ORDER BY month DESC;