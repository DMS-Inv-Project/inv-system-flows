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
