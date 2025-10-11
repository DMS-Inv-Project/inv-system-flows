#!/bin/bash

# Script to import INVS original MySQL database
echo "🔄 Importing INVS Original MySQL Database"
echo "=========================================="

# Check if MySQL container is running
if ! docker ps | grep -q "invs-mysql-original"; then
    echo "❌ MySQL container is not running. Please start it first:"
    echo "   docker-compose up -d mysql-original"
    exit 1
fi

# Check if the SQL file exists
SQL_FILE="/Users/sathitseethaphon/projects/dms-invs-projects/invs-modern/scripts/INVS_MySQL_Database_20231119.sql"
if [ ! -f "$SQL_FILE" ]; then
    echo "❌ SQL file not found: $SQL_FILE"
    exit 1
fi

echo "📄 SQL file found: $(ls -lh "$SQL_FILE" | awk '{print $5}')"
echo "⏳ Starting import process... This may take several minutes..."

# Wait for MySQL to be ready
echo "🔍 Waiting for MySQL to be ready..."
for i in {1..30}; do
    if docker exec invs-mysql-original mysql -u invs_user -pinvs123 -e "SELECT 1" >/dev/null 2>&1; then
        echo "✅ MySQL is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ MySQL failed to start within 30 seconds"
        exit 1
    fi
    sleep 1
done

# Import the database
echo "📥 Importing database... Please wait..."
echo "   This is a large file (1.4GB) and may take 10-15 minutes"

# Use mysql command with specific settings for large import
docker exec -i invs-mysql-original mysql \
    -u invs_user \
    -pinvs123 \
    --default-character-set=utf8mb4 \
    --max_allowed_packet=1GB \
    --net_buffer_length=32K \
    invs_banpong < "$SQL_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Database import completed successfully!"
    
    # Verify the import
    echo "🔍 Verifying import..."
    TABLE_COUNT=$(docker exec invs-mysql-original mysql -u invs_user -pinvs123 invs_banpong -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='invs_banpong';" -s -N)
    echo "📊 Total tables imported: $TABLE_COUNT"
    
    # Show some sample tables
    echo "📋 Sample tables:"
    docker exec invs-mysql-original mysql -u invs_user -pinvs123 invs_banpong -e "SHOW TABLES LIMIT 10;"
    
    echo ""
    echo "🎉 Import completed successfully!"
    echo ""
    echo "🔗 You can now access the original database:"
    echo "   MySQL: localhost:3307/invs_banpong"
    echo "   phpMyAdmin: http://localhost:8082"
    echo "   User: invs_user"
    echo "   Password: invs123"
    
else
    echo "❌ Database import failed!"
    echo "Please check the error messages above."
    exit 1
fi