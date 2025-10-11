#!/bin/bash
# import-mysql-legacy.sh
# Import MySQL legacy database for reference and comparison

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 INVS Modern - MySQL Legacy Database Import${NC}"
echo "=============================================="
echo ""

# Configuration
CONTAINER_NAME="invs-mysql-original"
DB_NAME="invs_banpong"
DB_USER="invs_user"
DB_PASS="invs123"
SQL_FILE="${SQL_FILE:-./scripts/INVS_MySQL_Database_20231119.sql}"
EXPECTED_TABLES=133

# Step 1: Check if MySQL container is running
echo -e "${YELLOW}[1/5]${NC} Checking MySQL container..."
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    echo -e "${RED}❌ MySQL container is not running${NC}"
    echo ""
    echo "Starting MySQL container..."
    docker-compose up -d mysql-original

    echo "Waiting for container to start..."
    sleep 5

    if ! docker ps | grep -q "$CONTAINER_NAME"; then
        echo -e "${RED}❌ Failed to start MySQL container${NC}"
        echo "Try: docker-compose up -d mysql-original"
        exit 1
    fi
fi
echo -e "${GREEN}✓ MySQL container is running${NC}"

# Step 2: Check if SQL file exists
echo ""
echo -e "${YELLOW}[2/5]${NC} Checking SQL file..."
if [ ! -f "$SQL_FILE" ]; then
    echo -e "${RED}❌ SQL file not found: $SQL_FILE${NC}"
    echo ""
    echo "Please download the file and place it at:"
    echo "  $SQL_FILE"
    echo ""
    echo "Or set custom path:"
    echo "  SQL_FILE=/path/to/file.sql $0"
    exit 1
fi

FILE_SIZE=$(ls -lh "$SQL_FILE" | awk '{print $5}')
echo -e "${GREEN}✓ SQL file found: $FILE_SIZE${NC}"

# Step 3: Wait for MySQL to be ready
echo ""
echo -e "${YELLOW}[3/5]${NC} Waiting for MySQL to be ready..."
MAX_RETRIES=30
RETRY=0
while [ $RETRY -lt $MAX_RETRIES ]; do
    if docker exec $CONTAINER_NAME mysql -u root -p$DB_PASS -e "SELECT 1" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ MySQL is ready!${NC}"
        break
    fi

    RETRY=$((RETRY+1))
    if [ $RETRY -eq $MAX_RETRIES ]; then
        echo -e "${RED}❌ MySQL failed to start within ${MAX_RETRIES} seconds${NC}"
        echo "Check logs: docker logs $CONTAINER_NAME"
        exit 1
    fi

    echo -n "."
    sleep 1
done

# Step 4: Check if database already exists and has data
echo ""
echo -e "${YELLOW}[4/5]${NC} Checking existing data..."
EXISTING_TABLES=$(docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_PASS $DB_NAME \
    -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_NAME';" \
    -s -N 2>/dev/null || echo "0")

if [ "$EXISTING_TABLES" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Database already has $EXISTING_TABLES tables${NC}"
    echo ""
    read -p "Do you want to re-import? This will DROP and recreate the database. (y/N) " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Import cancelled"
        echo ""
        echo "Existing database info:"
        docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_PASS $DB_NAME \
            -e "SELECT COUNT(*) as table_count FROM information_schema.tables WHERE table_schema='$DB_NAME';"
        exit 0
    fi

    echo "Dropping existing database..."
    docker exec $CONTAINER_NAME mysql -u root -p$DB_PASS \
        -e "DROP DATABASE IF EXISTS $DB_NAME; CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
else
    echo -e "${GREEN}✓ Database is empty, ready for import${NC}"
fi

# Step 5: Import database
echo ""
echo -e "${YELLOW}[5/5]${NC} Importing database..."
echo -e "${BLUE}📥 This may take 10-15 minutes for a 1.3GB file${NC}"
echo "Started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Show progress (approximate)
(
    while kill -0 $$ 2>/dev/null; do
        sleep 10
        echo -n "."
    done
) &
PROGRESS_PID=$!

# Import with optimized settings
docker exec -i $CONTAINER_NAME mysql \
    -u $DB_USER \
    -p$DB_PASS \
    --default-character-set=utf8mb4 \
    --max_allowed_packet=1G \
    --net_buffer_length=1M \
    $DB_NAME < "$SQL_FILE" 2>&1

IMPORT_STATUS=$?
kill $PROGRESS_PID 2>/dev/null || true

echo ""
echo "Completed at: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

if [ $IMPORT_STATUS -ne 0 ]; then
    echo -e "${RED}❌ Database import failed!${NC}"
    echo "Please check the error messages above"
    exit 1
fi

# Verification
echo -e "${GREEN}✅ Import completed successfully!${NC}"
echo ""
echo "🔍 Verifying import..."

# Count tables
TABLE_COUNT=$(docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_PASS $DB_NAME \
    -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_NAME';" \
    -s -N)

echo "📊 Total tables: $TABLE_COUNT (expected: ~$EXPECTED_TABLES)"

if [ "$TABLE_COUNT" -lt 100 ]; then
    echo -e "${YELLOW}⚠️  Warning: Table count seems low. Import may be incomplete.${NC}"
fi

# Show key table counts
echo ""
echo "📋 Key table data:"
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_PASS $DB_NAME -e "
SELECT 'drug_gn (generics)' as table_name, COUNT(*) as record_count FROM drug_gn
UNION ALL SELECT 'drug_vn (trade drugs)', COUNT(*) FROM drug_vn
UNION ALL SELECT 'company', COUNT(*) FROM company
UNION ALL SELECT 'inv_md (inventory)', COUNT(*) FROM inv_md
UNION ALL SELECT 'card (transactions)', COUNT(*) FROM card
ORDER BY table_name;
" 2>/dev/null || echo "Some tables may not exist yet"

echo ""
echo -e "${GREEN}🎉 Import completed successfully!${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}📌 Access Information:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "MySQL CLI:"
echo "  docker exec -it $CONTAINER_NAME mysql -u $DB_USER -p$DB_PASS $DB_NAME"
echo ""
echo "phpMyAdmin (Web Interface):"
echo "  URL: http://localhost:8082"
echo "  Server: $CONTAINER_NAME"
echo "  Username: $DB_USER"
echo "  Password: $DB_PASS"
echo "  Database: $DB_NAME"
echo ""
echo "Connection Details:"
echo "  Host: localhost"
echo "  Port: 3307"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"
echo "  Password: $DB_PASS"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}💡 This database is for REFERENCE only${NC}"
echo "   Use PostgreSQL (Prisma) for all development"
echo ""
