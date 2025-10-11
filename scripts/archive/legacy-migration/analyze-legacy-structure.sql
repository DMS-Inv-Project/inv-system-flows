-- INVS Legacy Database Analysis Queries
-- Use these queries to understand the structure and relationships

-- 1. Table overview with row count estimates
SELECT 
    schemaname,
    tablename,
    n_tup_ins as estimated_rows,
    pg_size_pretty(pg_total_relation_size('"'||tablename||'"')) as table_size
FROM pg_stat_user_tables 
ORDER BY tablename;

-- 2. Column analysis for all tables
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns 
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- 3. Tables that might be related to drugs/medications
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%drug%' 
    OR table_name ILIKE '%med%'
    OR column_name ILIKE '%drug%'
    OR column_name ILIKE '%working_code%'
  )
ORDER BY table_name, column_name;

-- 4. Tables related to purchase orders and procurement
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%po%'
    OR table_name ILIKE '%ms_%'
    OR table_name ILIKE '%buy%'
    OR table_name ILIKE '%purchase%'
    OR column_name ILIKE '%po_%'
  )
ORDER BY table_name, column_name;

-- 5. Tables related to inventory and stock
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%inv%'
    OR table_name ILIKE '%card%'
    OR table_name ILIKE '%stock%'
    OR column_name ILIKE '%qty%'
    OR column_name ILIKE '%stock%'
  )
ORDER BY table_name, column_name;

-- 6. Tables related to budget and finance
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%bdg%'
    OR table_name ILIKE '%budget%'
    OR table_name ILIKE '%cost%'
    OR column_name ILIKE '%budget%'
    OR column_name ILIKE '%cost%'
    OR column_name ILIKE '%price%'
    OR column_name ILIKE '%amount%'
  )
ORDER BY table_name, column_name;

-- 7. Tables related to companies/vendors
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%company%'
    OR table_name ILIKE '%vendor%'
    OR table_name ILIKE '%supplier%'
    OR column_name ILIKE '%company%'
    OR column_name ILIKE '%vendor%'
  )
ORDER BY table_name, column_name;

-- 8. Tables related to departments and locations
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%dept%'
    OR table_name ILIKE '%location%'
    OR column_name ILIKE '%dept%'
    OR column_name ILIKE '%location%'
    OR column_name ILIKE '%stock_id%'
  )
ORDER BY table_name, column_name;

-- 9. Find potential primary key columns (likely ID fields)
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    column_name ILIKE '%_id' 
    OR column_name ILIKE '%_no'
    OR column_name ILIKE '%_code'
    OR column_name = 'id'
  )
ORDER BY table_name, column_name;

-- 10. Tables with date/time columns (for understanding data flow)
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND data_type IN ('timestamp without time zone', 'timestamp with time zone', 'date')
ORDER BY table_name, column_name;

-- 11. Large text columns that might contain descriptions
SELECT 
    table_name,
    column_name,
    data_type,
    character_maximum_length
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND data_type IN ('text', 'character varying')
  AND (character_maximum_length > 100 OR character_maximum_length IS NULL)
ORDER BY table_name, column_name;

-- 12. Count all tables by category (based on naming patterns)
WITH table_categories AS (
  SELECT 
    table_name,
    CASE 
      WHEN table_name ILIKE '%drug%' OR table_name ILIKE '%med%' THEN 'Drug/Medicine'
      WHEN table_name ILIKE '%inv%' OR table_name ILIKE '%card%' THEN 'Inventory'
      WHEN table_name ILIKE '%po%' OR table_name ILIKE '%ms_%' OR table_name ILIKE '%buy%' THEN 'Procurement'
      WHEN table_name ILIKE '%bdg%' OR table_name ILIKE '%budget%' THEN 'Budget'
      WHEN table_name ILIKE '%company%' THEN 'Company/Vendor'
      WHEN table_name ILIKE '%dept%' OR table_name ILIKE '%location%' THEN 'Department/Location'
      WHEN table_name ILIKE '%patient%' OR table_name ILIKE '%opd%' THEN 'Patient/Clinical'
      ELSE 'Other/Reference'
    END as category
  FROM information_schema.tables 
  WHERE table_schema = 'public'
)
SELECT 
  category,
  COUNT(*) as table_count,
  array_agg(table_name ORDER BY table_name) as tables
FROM table_categories
GROUP BY category
ORDER BY table_count DESC;