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
