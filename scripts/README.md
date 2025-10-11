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
