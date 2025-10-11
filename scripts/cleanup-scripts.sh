#!/bin/bash
# cleanup-scripts.sh
# Script to reorganize and cleanup scripts directory

set -e  # Exit on error

echo "🧹 INVS Modern - Scripts Cleanup"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "📍 Project root: $PROJECT_ROOT"
echo ""

# Confirmation
echo "${YELLOW}⚠️  This will reorganize the scripts directory:${NC}"
echo "  - Move active scripts to tmt/ and integration/"
echo "  - Archive legacy migration scripts"
echo "  - Delete debug scripts and large SQL files"
echo ""
read -p "Continue? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "${RED}✗ Cancelled${NC}"
    exit 1
fi

echo ""
echo "Step 1: Creating new directory structure..."
mkdir -p "$SCRIPT_DIR/archive/legacy-migration"
mkdir -p "$SCRIPT_DIR/archive/legacy-schemas"
mkdir -p "$SCRIPT_DIR/archive/analysis-results"
mkdir -p "$SCRIPT_DIR/tmt"
mkdir -p "$SCRIPT_DIR/integration"
mkdir -p "$SCRIPT_DIR/examples"
echo "${GREEN}✓ Directories created${NC}"

echo ""
echo "Step 2: Moving TMT scripts..."
[ -f "$SCRIPT_DIR/import-tmt-data.js" ] && mv "$SCRIPT_DIR/import-tmt-data.js" "$SCRIPT_DIR/tmt/"
[ -f "$SCRIPT_DIR/seed-tmt-references.ts" ] && mv "$SCRIPT_DIR/seed-tmt-references.ts" "$SCRIPT_DIR/tmt/"
[ -f "$SCRIPT_DIR/sync-tmt-updates.js" ] && mv "$SCRIPT_DIR/sync-tmt-updates.js" "$SCRIPT_DIR/tmt/"
[ -f "$SCRIPT_DIR/tmt-config.js" ] && mv "$SCRIPT_DIR/tmt-config.js" "$SCRIPT_DIR/tmt/"
echo "${GREEN}✓ TMT scripts moved${NC}"

echo ""
echo "Step 3: Moving integration scripts..."
[ -f "$SCRIPT_DIR/his-integration.ts" ] && mv "$SCRIPT_DIR/his-integration.ts" "$SCRIPT_DIR/integration/"
[ -f "$SCRIPT_DIR/validate-migration.js" ] && mv "$SCRIPT_DIR/validate-migration.js" "$SCRIPT_DIR/integration/"
echo "${GREEN}✓ Integration scripts moved${NC}"

echo ""
echo "Step 4: Moving example queries..."
[ -f "$SCRIPT_DIR/mysql-queries-examples.sql" ] && mv "$SCRIPT_DIR/mysql-queries-examples.sql" "$SCRIPT_DIR/examples/query-examples.sql"
echo "${GREEN}✓ Examples moved${NC}"

echo ""
echo "Step 5: Archiving legacy migration scripts..."
[ -f "$SCRIPT_DIR/analyze-legacy-structure.sql" ] && mv "$SCRIPT_DIR/analyze-legacy-structure.sql" "$SCRIPT_DIR/archive/legacy-migration/"
[ -f "$SCRIPT_DIR/run-analysis.sh" ] && mv "$SCRIPT_DIR/run-analysis.sh" "$SCRIPT_DIR/archive/legacy-migration/"
[ -f "$SCRIPT_DIR/create_clean_schema.py" ] && mv "$SCRIPT_DIR/create_clean_schema.py" "$SCRIPT_DIR/archive/legacy-migration/"
[ -f "$SCRIPT_DIR/extract_schema_only.py" ] && mv "$SCRIPT_DIR/extract_schema_only.py" "$SCRIPT_DIR/archive/legacy-migration/"
[ -f "$SCRIPT_DIR/mysql_to_postgresql_converter_v2.py" ] && mv "$SCRIPT_DIR/mysql_to_postgresql_converter_v2.py" "$SCRIPT_DIR/archive/legacy-migration/"
[ -f "$SCRIPT_DIR/migrate-legacy-to-modern.js" ] && mv "$SCRIPT_DIR/migrate-legacy-to-modern.js" "$SCRIPT_DIR/archive/legacy-migration/"
[ -f "$SCRIPT_DIR/migrate-to-tmt.sql" ] && mv "$SCRIPT_DIR/migrate-to-tmt.sql" "$SCRIPT_DIR/archive/legacy-migration/"
[ -f "$SCRIPT_DIR/import-mysql-data.sh" ] && mv "$SCRIPT_DIR/import-mysql-data.sh" "$SCRIPT_DIR/archive/legacy-migration/"
echo "${GREEN}✓ Migration scripts archived${NC}"

echo ""
echo "Step 6: Archiving legacy schemas..."
if [ -d "$SCRIPT_DIR/legacy-init" ]; then
    mv "$SCRIPT_DIR/legacy-init"/* "$SCRIPT_DIR/archive/legacy-schemas/" 2>/dev/null || true
    rmdir "$SCRIPT_DIR/legacy-init" 2>/dev/null || true
fi
echo "${GREEN}✓ Legacy schemas archived${NC}"

echo ""
echo "Step 7: Archiving analysis results..."
if [ -d "$SCRIPT_DIR/analysis-results" ]; then
    mv "$SCRIPT_DIR/analysis-results"/* "$SCRIPT_DIR/archive/analysis-results/" 2>/dev/null || true
    rmdir "$SCRIPT_DIR/analysis-results" 2>/dev/null || true
fi
echo "${GREEN}✓ Analysis results archived${NC}"

echo ""
echo "Step 8: Deleting debug scripts..."
[ -f "$SCRIPT_DIR/debug-tmt-excel.js" ] && rm "$SCRIPT_DIR/debug-tmt-excel.js"
[ -f "$SCRIPT_DIR/debug-tmt-relationships.js" ] && rm "$SCRIPT_DIR/debug-tmt-relationships.js"
[ -f "$SCRIPT_DIR/example-usage.js" ] && rm "$SCRIPT_DIR/example-usage.js"
echo "${GREEN}✓ Debug scripts deleted${NC}"

echo ""
echo "Step 9: Removing MySQL init directory..."
[ -d "$SCRIPT_DIR/mysql-init" ] && rm -rf "$SCRIPT_DIR/mysql-init"
echo "${GREEN}✓ MySQL init removed${NC}"

echo ""
echo "Step 10: Creating README files..."

# Main scripts README
cat > "$SCRIPT_DIR/README.md" << 'EOF'
# Scripts Directory

## Active Scripts (Use These)

### TMT Management (`tmt/`)
- `import-tmt-data.js` - Import TMT concepts from Excel files
- `seed-tmt-references.ts` - Seed TMT reference data to database
- `sync-tmt-updates.js` - Sync TMT data updates
- `tmt-config.js` - TMT system configuration

### Integration (`integration/`)
- `his-integration.ts` - HIS (Hospital Information System) integration
- `validate-migration.js` - Data validation and integrity checks

### Examples (`examples/`)
- `query-examples.sql` - Example SQL queries for common operations

## Archived Scripts (`archive/`)
Legacy migration scripts kept for reference only.
**These are no longer needed for normal operations.**

See `archive/README.md` for details.

## Usage

### Import TMT Data
```bash
node tmt/import-tmt-data.js
```

### Validate Data
```bash
node integration/validate-migration.js
```

### HIS Integration
```bash
ts-node integration/his-integration.ts
```

## Need Help?
See documentation in `docs/` or contact the development team.
EOF

# Archive README
cat > "$SCRIPT_DIR/archive/README.md" << 'EOF'
# Archived Scripts

These scripts were used during the initial MySQL → PostgreSQL migration.

**Status: Migration Complete ✅**

These scripts are kept for historical reference only and are not required for normal system operation.

## Contents

### `legacy-migration/`
Scripts used to migrate data from legacy MySQL system to modern PostgreSQL:
- Schema conversion tools
- Data migration scripts
- Analysis tools

### `legacy-schemas/`
Large SQL schema files (gitignored):
- Legacy database schemas
- Full data dumps

**Note:** Large files are not stored in git.
If needed, download from: [Add cloud storage link]

### `analysis-results/`
Results from legacy database analysis:
- Table structure analysis
- Data statistics
- Migration reports

## Do I Need These?

**Short answer: No**

The modern system is fully functional with:
- Complete Prisma schema (`prisma/schema.prisma`)
- Database functions (`prisma/functions.sql`)
- Database views (`prisma/views.sql`)
- Seed data (`prisma/seed.ts`)

These archived scripts are only useful if you need to:
1. Reference the migration process
2. Re-migrate from legacy MySQL (unlikely)
3. Understand legacy database structure

## Large Files

Large SQL files (>50MB) are excluded from git.

Download if needed:
- [Cloud Storage Link - Update this]

Or contact: [your-email@example.com]
EOF

# Legacy schemas README
cat > "$SCRIPT_DIR/archive/legacy-schemas/README.md" << 'EOF'
# Legacy Schema Files

**These large SQL files are not stored in git (.gitignored)**

## Files (if downloaded)

- `01-invs-legacy-schema.sql` (340MB) - Full legacy schema with data
- `01-schema-only.sql` (26MB) - Schema structure only
- `02-clean-schema.sql` (102KB) - Cleaned schema for reference

## Download

If you need these files for reference:
1. Download from: [Add cloud storage link]
2. Place files in this directory
3. They will be automatically ignored by git

## Usage

These are reference files only. The modern system uses Prisma schema instead.

To view legacy structure:
```bash
# View schema
psql -f 01-schema-only.sql

# Or use archived analysis results
cat ../analysis-results/*.txt
```
EOF

echo "${GREEN}✓ README files created${NC}"

echo ""
echo "Step 11: Showing final structure..."
echo ""
tree -L 2 "$SCRIPT_DIR" -I 'node_modules|*.sql' || ls -R "$SCRIPT_DIR"

echo ""
echo "${GREEN}✅ Cleanup complete!${NC}"
echo ""
echo "Summary:"
echo "  ✓ Active scripts organized in tmt/ and integration/"
echo "  ✓ Legacy scripts archived in archive/"
echo "  ✓ Debug scripts removed"
echo "  ✓ README files created"
echo ""
echo "Next steps:"
echo "  1. Review the new structure"
echo "  2. Test active scripts still work"
echo "  3. Commit changes: git add scripts/ && git commit"
echo ""
echo "${YELLOW}Note: Large SQL files should be in .gitignore${NC}"
echo "Check .gitignore before committing!"
