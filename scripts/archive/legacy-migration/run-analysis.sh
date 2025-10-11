#!/bin/bash

# Script to run legacy database analysis and generate reports
echo "🔍 Analyzing INVS Legacy Database Structure"
echo "=========================================="

# Create output directory
mkdir -p analysis-results

# Run each analysis query and save results
echo "1. Generating table overview..."
docker exec invs-legacy-db psql -U invs_user -d invs_legacy -c "
SELECT 
    tablename,
    pg_size_pretty(pg_total_relation_size('\"'||tablename||'\"')) as table_size
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;" > analysis-results/01-table-overview.txt

echo "2. Analyzing drug/medicine tables..."
docker exec invs-legacy-db psql -U invs_user -d invs_legacy -c "
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%drug%' 
    OR table_name ILIKE '%med%'
    OR column_name ILIKE '%drug%'
    OR column_name ILIKE '%working_code%'
  )
ORDER BY table_name, column_name;" > analysis-results/02-drug-tables.txt

echo "3. Analyzing procurement tables..."
docker exec invs-legacy-db psql -U invs_user -d invs_legacy -c "
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%po%'
    OR table_name ILIKE '%ms_%'
    OR table_name ILIKE '%buy%'
    OR column_name ILIKE '%po_%'
  )
ORDER BY table_name, column_name;" > analysis-results/03-procurement-tables.txt

echo "4. Analyzing inventory tables..."
docker exec invs-legacy-db psql -U invs_user -d invs_legacy -c "
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%inv%'
    OR table_name ILIKE '%card%'
    OR column_name ILIKE '%qty%'
    OR column_name ILIKE '%stock%'
  )
ORDER BY table_name, column_name;" > analysis-results/04-inventory-tables.txt

echo "5. Analyzing budget tables..."
docker exec invs-legacy-db psql -U invs_user -d invs_legacy -c "
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%bdg%'
    OR table_name ILIKE '%budget%'
    OR column_name ILIKE '%budget%'
    OR column_name ILIKE '%cost%'
    OR column_name ILIKE '%amount%'
  )
ORDER BY table_name, column_name;" > analysis-results/05-budget-tables.txt

echo "6. Analyzing master data tables..."
docker exec invs-legacy-db psql -U invs_user -d invs_legacy -c "
SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (
    table_name ILIKE '%company%'
    OR table_name ILIKE '%dept%'
    OR table_name ILIKE '%location%'
    OR table_name IN ('dosage_form', 'sale_unit', 'uom')
  )
ORDER BY table_name, column_name;" > analysis-results/06-master-data-tables.txt

echo "7. Categorizing all tables..."
docker exec invs-legacy-db psql -U invs_user -d invs_legacy -c "
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
ORDER BY table_count DESC;" > analysis-results/07-table-categories.txt

echo "8. Finding key identifier columns..."
docker exec invs-legacy-db psql -U invs_user -d invs_legacy -c "
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
ORDER BY table_name, column_name;" > analysis-results/08-key-columns.txt

echo "9. Analyzing date/time columns..."
docker exec invs-legacy-db psql -U invs_user -d invs_legacy -c "
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND (data_type IN ('timestamp without time zone', 'date') 
       OR column_name ILIKE '%date%'
       OR column_name ILIKE '%time%')
ORDER BY table_name, column_name;" > analysis-results/09-datetime-columns.txt

echo "✅ Analysis complete! Results saved in analysis-results/ directory"
echo ""
echo "📄 Generated files:"
ls -la analysis-results/
echo ""
echo "🔗 You can now connect to the legacy database:"
echo "   Host: localhost:5435"
echo "   Database: invs_legacy"
echo "   User: invs_user"
echo "   Password: invs123"