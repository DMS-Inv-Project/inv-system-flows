-- ========================================
-- INVS Modern - Master Data Export
-- Version: 1.3.0
-- Date: 2025-10-20
-- ========================================
-- 
-- Total Records: 39
-- Tables: 10
--
-- Usage:
--   psql -U invs_user -d invs_modern < master_data_export_clean.sql
--
-- ========================================

-- Disable triggers for faster import
SET session_replication_role = replica;

BEGIN;

-- ========================================
-- 1. LOCATIONS (5 records)
-- ========================================
 INSERT INTO locations (id, location_code, location_name, location_type, address, responsible_person, is_active, created_at) VALUES (1, 'EMRG', 'Emergency Department', 'emergency', 'Emergency Wing', 'Emergency Head Nurse', true, '2025-10-20 02:19:10.339');
 INSERT INTO locations (id, location_code, location_name, location_type, address, responsible_person, is_active, created_at) VALUES (2, 'MAIN', 'Main Warehouse', 'warehouse', 'Hospital Main Building', 'Warehouse Manager', true, '2025-10-20 02:19:10.339');
 INSERT INTO locations (id, location_code, location_name, location_type, address, responsible_person, is_active, created_at) VALUES (3, 'PHARM', 'Central Pharmacy', 'pharmacy', 'Ground Floor, Building A', 'Chief Pharmacist', true, '2025-10-20 02:19:10.339');
 INSERT INTO locations (id, location_code, location_name, location_type, address, responsible_person, is_active, created_at) VALUES (4, 'OPD', 'Outpatient Department', 'pharmacy', '1st Floor, Building A', 'OPD Pharmacist', true, '2025-10-20 02:19:10.339');
 INSERT INTO locations (id, location_code, location_name, location_type, address, responsible_person, is_active, created_at) VALUES (5, 'ICU', 'Intensive Care Unit', 'ward', '3rd Floor, Building B', 'ICU Head Nurse', true, '2025-10-20 02:19:10.339');


-- ========================================
-- 2. DEPARTMENTS (5 records)
-- ========================================
 INSERT INTO departments (id, dept_code, dept_name, his_code, head_person, is_active, created_at) VALUES (1, 'PHARM', 'Pharmacy Department', 'HIS-PHARM', 'Chief Pharmacist', true, '2025-10-20 02:19:10.371');
 INSERT INTO departments (id, dept_code, dept_name, his_code, head_person, is_active, created_at) VALUES (2, 'MED', 'Medical Department', 'HIS-MED', 'Chief Medical Officer', true, '2025-10-20 02:19:10.371');
 INSERT INTO departments (id, dept_code, dept_name, his_code, head_person, is_active, created_at) VALUES (3, 'ADMIN', 'Administration', 'HIS-ADM', 'Hospital Director', true, '2025-10-20 02:19:10.371');
 INSERT INTO departments (id, dept_code, dept_name, his_code, head_person, is_active, created_at) VALUES (4, 'LAB', 'Laboratory', 'HIS-LAB', 'Laboratory Director', true, '2025-10-20 02:19:10.371');
 INSERT INTO departments (id, dept_code, dept_name, his_code, head_person, is_active, created_at) VALUES (5, 'NURSE', 'Nursing Department', 'HIS-NURSE', 'Chief Nursing Officer', true, '2025-10-20 02:19:10.371');


-- ========================================
-- 3. BANKS (5 records)
-- ========================================
 INSERT INTO bank (bank_id, bank_name, is_active, created_at) VALUES (1, 'ธนาคารกรุงไทย', true, '2025-10-20 02:19:10.379');
 INSERT INTO bank (bank_id, bank_name, is_active, created_at) VALUES (2, 'ธนาคารกสิกรไทย', true, '2025-10-20 02:19:10.379');
 INSERT INTO bank (bank_id, bank_name, is_active, created_at) VALUES (3, 'ธนาคารไทยพาณิชย์', true, '2025-10-20 02:19:10.379');
 INSERT INTO bank (bank_id, bank_name, is_active, created_at) VALUES (4, 'ธนาคารกรุงเทพ', true, '2025-10-20 02:19:10.379');
 INSERT INTO bank (bank_id, bank_name, is_active, created_at) VALUES (5, 'ธนาคารกรุงศรีอยุธยา', true, '2025-10-20 02:19:10.379');


-- ========================================
-- 4. BUDGET TYPES (3 records)
-- ========================================
 INSERT INTO budget_types (id, type_code, type_name, is_active, created_at) VALUES (1, '01', 'งบเงินบำรุง', true, '2025-10-20 02:19:10.386');
 INSERT INTO budget_types (id, type_code, type_name, is_active, created_at) VALUES (2, '02', 'งบลงทุน', true, '2025-10-20 02:19:10.386');
 INSERT INTO budget_types (id, type_code, type_name, is_active, created_at) VALUES (3, '03', 'งบบุคลากร', true, '2025-10-20 02:19:10.386');


-- ========================================
-- 5. BUDGET CATEGORIES (3 records)
-- ========================================
 INSERT INTO budget_categories (id, category_code, category_name, acc_code, remark, is_active, created_at) VALUES (1, '0102', 'ยา', '1105010103.101', 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับยา', true, '2025-10-20 02:19:10.395');
 INSERT INTO budget_categories (id, category_code, category_name, acc_code, remark, is_active, created_at) VALUES (2, '0101', 'เวชภัณฑ์ไม่ใช่ยา', '1105010103.102', 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับเวชภัณฑ์ไม่ใช่ยา', true, '2025-10-20 02:19:10.394');
 INSERT INTO budget_categories (id, category_code, category_name, acc_code, remark, is_active, created_at) VALUES (3, '0103', 'เครื่องมือแพทย์', '1105010103.103', 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับเครื่องมือทางการแพทย์', true, '2025-10-20 02:19:10.395');


-- ========================================
-- 6. BUDGETS (2 records)
-- ========================================
 INSERT INTO budgets (id, budget_code, budget_type, budget_category, budget_description, is_active, created_at) VALUES (1, 'OP001', '01', '0101', 'งบประมาณสำหรับซื้อเวชภัณฑ์ไม่ใช่ยา', true, '2025-10-20 02:19:10.401');
 INSERT INTO budgets (id, budget_code, budget_type, budget_category, budget_description, is_active, created_at) VALUES (2, 'OP002', '01', '0102', 'งบประมาณสำหรับซื้อยา', true, '2025-10-20 02:19:10.401');


-- ========================================
-- 7. COMPANIES (5 records)
-- ========================================
 INSERT INTO companies (id, company_code, company_name, company_type, tax_id, bank_code, bank_account, bank_id, address, phone, email, contact_person, is_active, created_at, updated_at) VALUES (1, '000004', 'Sino-Thai Engineering & Construction PCL.', 'vendor', '0107537000781', '1234567890', 'บริษัท ไซโน-ไทย เอ็นจิเนียริ่ง แอนด์ คอนสตรัคชั่น จำกัด (มหาชน)', 4, '1011 Shinawatra Tower III, Viphavadi-Rangsit Road, Bangkok 10900', '02-642-8951', 'info@sinothai.co.th', 'Project Manager', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409');
 INSERT INTO companies (id, company_code, company_name, company_type, tax_id, bank_code, bank_account, bank_id, address, phone, email, contact_person, is_active, created_at, updated_at) VALUES (2, '000005', 'Berlin Pharmaceutical Industry Co., Ltd.', 'manufacturer', '0105536001234', '9876543210', 'บริษัท เบอร์ลินฟาร์มาซูติคอลอินดัสตรี จำกัด', 5, '123 Industrial Estate, Samut Prakan 10280', '02-324-5678', 'sales@berlin-pharma.co.th', 'Sales Director', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409');
 INSERT INTO companies (id, company_code, company_name, company_type, tax_id, bank_code, bank_account, bank_id, address, phone, email, contact_person, is_active, created_at, updated_at) VALUES (3, '000001', 'Government Pharmaceutical Organization (GPO)', 'both', '0994000158378', '3722699075', 'บริษัท ร่ำรวยเงินทอง จำกัด', 1, '75/1 Rama VI Road, Ratchathewi, Bangkok 10400', '02-203-8000', 'info@gpo.or.th', 'Sales Manager', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409');
 INSERT INTO companies (id, company_code, company_name, company_type, tax_id, bank_code, bank_account, bank_id, address, phone, email, contact_person, is_active, created_at, updated_at) VALUES (4, '000003', 'Pfizer (Thailand) Ltd.', 'manufacturer', '0105536028371', '7891234567', 'บริษัท ไฟเซอร์ (ประเทศไทย) จำกัด', 3, '1 Empire Tower, 47th Floor, Sathorn Road, Bangkok 10120', '02-670-1000', 'info.thailand@pfizer.com', 'Medical Affairs', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409');
 INSERT INTO companies (id, company_code, company_name, company_type, tax_id, bank_code, bank_account, bank_id, address, phone, email, contact_person, is_active, created_at, updated_at) VALUES (5, '000002', 'Zuellig Pharma (Thailand) Ltd.', 'vendor', '0105536041974', '4561234567', 'บริษัท ซูลลิกฟาร์มา (ประเทศไทย) จำกัด', 2, '3199 Rama IV Road, Khlong Toei, Bangkok 10110', '02-367-8100', 'thailand@zuelligpharma.com', 'Account Manager', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409');


-- ========================================
-- 8. DRUG GENERICS (5 records)
-- ========================================

-- ========================================
-- 9. DRUGS (3 records)
-- ========================================
 INSERT INTO drugs (id, drug_code, trade_name, generic_id, manufacturer_id, unit_price, unit, pack_size, is_active, created_at, updated_at) VALUES (1, 'PAR0001-000001-001', 'GPO Paracetamol 500mg', 2, 3, 1.50, 'TAB', 1000, true, '2025-10-20 02:19:10.429', '2025-10-20 02:19:10.429');
 INSERT INTO drugs (id, drug_code, trade_name, generic_id, manufacturer_id, unit_price, unit, pack_size, is_active, created_at, updated_at) VALUES (2, 'AMX0001-000002-001', 'Zuellig Amoxicillin 250mg', 1, 5, 3.00, 'CAP', 1000, true, '2025-10-20 02:19:10.429', '2025-10-20 02:19:10.429');
 INSERT INTO drugs (id, drug_code, trade_name, generic_id, manufacturer_id, unit_price, unit, pack_size, is_active, created_at, updated_at) VALUES (3, 'IBU0001-000001-001', 'GPO Ibuprofen 200mg', 4, 3, 2.50, 'TAB', 500, true, '2025-10-20 02:19:10.429', '2025-10-20 02:19:10.429');


-- ========================================
-- 10. BUDGET ALLOCATIONS (3 records)
-- ========================================
 INSERT INTO budget_allocations (id, fiscal_year, budget_id, department_id, total_budget, q1_budget, q2_budget, q3_budget, q4_budget, total_spent, q1_spent, q2_spent, q3_spent, q4_spent, remaining_budget, status, created_at, updated_at) VALUES (1, 2025, 1, 2, 3000000.00, 750000.00, 750000.00, 750000.00, 750000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 3000000.00, 'active', '2025-10-20 02:19:10.438', '2025-10-20 02:19:10.438');
 INSERT INTO budget_allocations (id, fiscal_year, budget_id, department_id, total_budget, q1_budget, q2_budget, q3_budget, q4_budget, total_spent, q1_spent, q2_spent, q3_spent, q4_spent, remaining_budget, status, created_at, updated_at) VALUES (2, 2025, 2, 1, 10000000.00, 2500000.00, 2500000.00, 2500000.00, 2500000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 10000000.00, 'active', '2025-10-20 02:19:10.438', '2025-10-20 02:19:10.438');
 INSERT INTO budget_allocations (id, fiscal_year, budget_id, department_id, total_budget, q1_budget, q2_budget, q3_budget, q4_budget, total_spent, q1_spent, q2_spent, q3_spent, q4_spent, remaining_budget, status, created_at, updated_at) VALUES (3, 2025, 2, 5, 5000000.00, 1250000.00, 1250000.00, 1250000.00, 1250000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 5000000.00, 'active', '2025-10-20 02:19:10.438', '2025-10-20 02:19:10.438');


-- ========================================
-- RESET SEQUENCES
-- ========================================
SELECT setval('locations_id_seq', (SELECT MAX(id) FROM locations));
SELECT setval('departments_id_seq', (SELECT MAX(id) FROM departments));
SELECT setval('bank_id_seq', (SELECT MAX(bank_id) FROM bank));
SELECT setval('budget_types_id_seq', (SELECT MAX(id) FROM budget_types));
SELECT setval('budget_categories_id_seq', (SELECT MAX(id) FROM budget_categories));
SELECT setval('budgets_id_seq', (SELECT MAX(id) FROM budgets));
SELECT setval('companies_id_seq', (SELECT MAX(id) FROM companies));
SELECT setval('drug_generics_id_seq', (SELECT MAX(id) FROM drug_generics));
SELECT setval('drugs_id_seq', (SELECT MAX(id) FROM drugs));
SELECT setval('budget_allocations_id_seq', (SELECT MAX(id) FROM budget_allocations));

COMMIT;

-- Enable triggers again
SET session_replication_role = DEFAULT;

-- ========================================
-- END OF EXPORT
-- ========================================
