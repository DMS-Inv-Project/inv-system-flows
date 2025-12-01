# Database Backup

## File Info
- **File**: `invs_modern_full.sql.gz`
- **Size**: ~3MB (compressed)
- **Date**: 2024-12-01
- **Records**: ~103,000 records

## Contents
- Schema (52 tables, 22 enums)
- All migrated data from Phase 1-15
- Master Data, Budget, Inventory, TMT, etc.

## How to Restore

### 1. Start containers
```bash
docker-compose up -d
```

### 2. Restore database
```bash
# Decompress and restore
gunzip -c backup/invs_modern_full.sql.gz | docker exec -i invs-modern-db psql -U invs_user -d invs_modern
```

### 3. Verify
```bash
npm run dev
# Should show: ✅ Database connected successfully!
```

## Alternative: Fresh Setup

If you want to start fresh and run migrations:
```bash
npm run db:push
npm run db:seed
npm run import:phase1
# ... run all phases
```

## Create New Backup

```bash
docker exec invs-modern-db pg_dump -U invs_user -d invs_modern | gzip > backup/invs_modern_full.sql.gz
```
