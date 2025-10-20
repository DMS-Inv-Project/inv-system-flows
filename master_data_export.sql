--
-- PostgreSQL database dump
--

\restrict uK5b8CbFyXNBsAXoYgBjndEwUAKN6OyrBg8IlClXFNR759mXKNbCqH7pScNsLGE

-- Dumped from database version 15.14
-- Dumped by pg_dump version 15.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.bank VALUES (4, 'ธนาคารกรุงเทพ', true, '2025-10-20 02:19:10.379');
INSERT INTO public.bank VALUES (5, 'ธนาคารกรุงศรีอยุธยา', true, '2025-10-20 02:19:10.379');
INSERT INTO public.bank VALUES (1, 'ธนาคารกรุงไทย', true, '2025-10-20 02:19:10.379');
INSERT INTO public.bank VALUES (3, 'ธนาคารไทยพาณิชย์', true, '2025-10-20 02:19:10.379');
INSERT INTO public.bank VALUES (2, 'ธนาคารกสิกรไทย', true, '2025-10-20 02:19:10.379');


--
-- Data for Name: budget_categories; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.budget_categories VALUES (1, '0102', 'ยา', '1105010103.101', 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับยา', true, '2025-10-20 02:19:10.395');
INSERT INTO public.budget_categories VALUES (3, '0103', 'เครื่องมือแพทย์', '1105010103.103', 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับเครื่องมือทางการแพทย์', true, '2025-10-20 02:19:10.395');
INSERT INTO public.budget_categories VALUES (2, '0101', 'เวชภัณฑ์ไม่ใช่ยา', '1105010103.102', 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับเวชภัณฑ์ไม่ใช่ยา', true, '2025-10-20 02:19:10.394');


--
-- Data for Name: budget_types; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.budget_types VALUES (1, '01', 'งบเงินบำรุง', true, '2025-10-20 02:19:10.386');
INSERT INTO public.budget_types VALUES (2, '02', 'งบลงทุน', true, '2025-10-20 02:19:10.386');
INSERT INTO public.budget_types VALUES (3, '03', 'งบบุคลากร', true, '2025-10-20 02:19:10.386');


--
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.budgets VALUES (1, 'OP001', '01', '0101', 'งบประมาณสำหรับซื้อเวชภัณฑ์ไม่ใช่ยา', true, '2025-10-20 02:19:10.401');
INSERT INTO public.budgets VALUES (2, 'OP002', '01', '0102', 'งบประมาณสำหรับซื้อยา', true, '2025-10-20 02:19:10.401');


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.departments VALUES (1, 'PHARM', 'Pharmacy Department', 'HIS-PHARM', NULL, 'Chief Pharmacist', true, '2025-10-20 02:19:10.371');
INSERT INTO public.departments VALUES (4, 'LAB', 'Laboratory', 'HIS-LAB', NULL, 'Laboratory Director', true, '2025-10-20 02:19:10.371');
INSERT INTO public.departments VALUES (5, 'NURSE', 'Nursing Department', 'HIS-NURSE', NULL, 'Chief Nursing Officer', true, '2025-10-20 02:19:10.371');
INSERT INTO public.departments VALUES (3, 'ADMIN', 'Administration', 'HIS-ADM', NULL, 'Hospital Director', true, '2025-10-20 02:19:10.371');
INSERT INTO public.departments VALUES (2, 'MED', 'Medical Department', 'HIS-MED', NULL, 'Chief Medical Officer', true, '2025-10-20 02:19:10.371');


--
-- Data for Name: budget_allocations; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.budget_allocations VALUES (1, 2025, 1, 2, 3000000.00, 750000.00, 750000.00, 750000.00, 750000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 3000000.00, 'active', '2025-10-20 02:19:10.438', '2025-10-20 02:19:10.438');
INSERT INTO public.budget_allocations VALUES (2, 2025, 2, 1, 10000000.00, 2500000.00, 2500000.00, 2500000.00, 2500000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 10000000.00, 'active', '2025-10-20 02:19:10.438', '2025-10-20 02:19:10.438');
INSERT INTO public.budget_allocations VALUES (3, 2025, 2, 5, 5000000.00, 1250000.00, 1250000.00, 1250000.00, 1250000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 5000000.00, 'active', '2025-10-20 02:19:10.438', '2025-10-20 02:19:10.438');


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.companies VALUES (1, '000004', 'Sino-Thai Engineering & Construction PCL.', 'vendor', '0107537000781', '1234567890', 'บริษัท ไซโน-ไทย เอ็นจิเนียริ่ง แอนด์ คอนสตรัคชั่น จำกัด (มหาชน)', 4, '1011 Shinawatra Tower III, Viphavadi-Rangsit Road, Bangkok 10900', '02-642-8951', 'info@sinothai.co.th', 'Project Manager', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409', NULL, NULL, NULL);
INSERT INTO public.companies VALUES (5, '000002', 'Zuellig Pharma (Thailand) Ltd.', 'vendor', '0105536041974', '4561234567', 'บริษัท ซูลลิกฟาร์มา (ประเทศไทย) จำกัด', 2, '3199 Rama IV Road, Khlong Toei, Bangkok 10110', '02-367-8100', 'thailand@zuelligpharma.com', 'Account Manager', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409', NULL, NULL, NULL);
INSERT INTO public.companies VALUES (4, '000003', 'Pfizer (Thailand) Ltd.', 'manufacturer', '0105536028371', '7891234567', 'บริษัท ไฟเซอร์ (ประเทศไทย) จำกัด', 3, '1 Empire Tower, 47th Floor, Sathorn Road, Bangkok 10120', '02-670-1000', 'info.thailand@pfizer.com', 'Medical Affairs', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409', NULL, NULL, NULL);
INSERT INTO public.companies VALUES (2, '000005', 'Berlin Pharmaceutical Industry Co., Ltd.', 'manufacturer', '0105536001234', '9876543210', 'บริษัท เบอร์ลินฟาร์มาซูติคอลอินดัสตรี จำกัด', 5, '123 Industrial Estate, Samut Prakan 10280', '02-324-5678', 'sales@berlin-pharma.co.th', 'Sales Director', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409', NULL, NULL, NULL);
INSERT INTO public.companies VALUES (3, '000001', 'Government Pharmaceutical Organization (GPO)', 'both', '0994000158378', '3722699075', 'บริษัท ร่ำรวยเงินทอง จำกัด', 1, '75/1 Rama VI Road, Ratchathewi, Bangkok 10400', '02-203-8000', 'info@gpo.or.th', 'Sales Manager', true, '2025-10-20 02:19:10.409', '2025-10-20 02:19:10.409', NULL, NULL, NULL);


--
-- Data for Name: drug_generics; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.drug_generics VALUES (1, 'AMX0001', 'Amoxicillin', 'Capsule', 'CAP', 'Amoxicillin trihydrate', 250.00, 'mg', true, '2025-10-20 02:19:10.42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.drug_generics VALUES (3, 'ASP0001', 'Aspirin', 'Tablet', 'TAB', 'Acetylsalicylic acid', 100.00, 'mg', true, '2025-10-20 02:19:10.42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.drug_generics VALUES (4, 'IBU0001', 'Ibuprofen', 'Tablet', 'TAB', 'Ibuprofen', 200.00, 'mg', true, '2025-10-20 02:19:10.42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.drug_generics VALUES (5, 'OME0001', 'Omeprazole', 'Capsule', 'CAP', 'Omeprazole', 20.00, 'mg', true, '2025-10-20 02:19:10.42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.drug_generics VALUES (2, 'PAR0001', 'Paracetamol', 'Tablet', 'TAB', 'Paracetamol', 500.00, 'mg', true, '2025-10-20 02:19:10.42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: drugs; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.drugs VALUES (1, 'PAR0001-000001-001', 'GPO Paracetamol 500mg', 2, '500mg', 'Tablet', 3, 'N02BE01', 'PAR0001-000001-001', '8851234567890', 1000, 1.50, 'TAB', true, '2025-10-20 02:19:10.429', '2025-10-20 02:19:10.429', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL);
INSERT INTO public.drugs VALUES (2, 'AMX0001-000002-001', 'Zuellig Amoxicillin 250mg', 1, '250mg', 'Capsule', 5, 'J01CA04', 'AMX0001-000002-001', '8851234567892', 1000, 3.00, 'CAP', true, '2025-10-20 02:19:10.429', '2025-10-20 02:19:10.429', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL);
INSERT INTO public.drugs VALUES (3, 'IBU0001-000001-001', 'GPO Ibuprofen 200mg', 4, '200mg', 'Tablet', 3, 'M01AE01', 'IBU0001-000001-001', '8851234567891', 500, 2.50, 'TAB', true, '2025-10-20 02:19:10.429', '2025-10-20 02:19:10.429', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL);


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: invs_user
--

INSERT INTO public.locations VALUES (1, 'EMRG', 'Emergency Department', 'emergency', NULL, 'Emergency Wing', 'Emergency Head Nurse', true, '2025-10-20 02:19:10.339');
INSERT INTO public.locations VALUES (2, 'MAIN', 'Main Warehouse', 'warehouse', NULL, 'Hospital Main Building', 'Warehouse Manager', true, '2025-10-20 02:19:10.339');
INSERT INTO public.locations VALUES (3, 'PHARM', 'Central Pharmacy', 'pharmacy', NULL, 'Ground Floor, Building A', 'Chief Pharmacist', true, '2025-10-20 02:19:10.339');
INSERT INTO public.locations VALUES (4, 'OPD', 'Outpatient Department', 'pharmacy', NULL, '1st Floor, Building A', 'OPD Pharmacist', true, '2025-10-20 02:19:10.339');
INSERT INTO public.locations VALUES (5, 'ICU', 'Intensive Care Unit', 'ward', NULL, '3rd Floor, Building B', 'ICU Head Nurse', true, '2025-10-20 02:19:10.339');


--
-- Name: bank_bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.bank_bank_id_seq', 1, false);


--
-- Name: budget_allocations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.budget_allocations_id_seq', 3, true);


--
-- Name: budget_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.budget_categories_id_seq', 3, true);


--
-- Name: budget_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.budget_types_id_seq', 3, true);


--
-- Name: budgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.budgets_id_seq', 2, true);


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.companies_id_seq', 5, true);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.departments_id_seq', 5, true);


--
-- Name: drug_generics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.drug_generics_id_seq', 5, true);


--
-- Name: drugs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.drugs_id_seq', 3, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: invs_user
--

SELECT pg_catalog.setval('public.locations_id_seq', 5, true);


--
-- PostgreSQL database dump complete
--

\unrestrict uK5b8CbFyXNBsAXoYgBjndEwUAKN6OyrBg8IlClXFNR759mXKNbCqH7pScNsLGE

