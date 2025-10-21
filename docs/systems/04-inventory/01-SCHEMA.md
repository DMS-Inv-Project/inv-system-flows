# Schema - Inventory System

## Tables (7)

1. `inventory` - Stock levels per drug/location
2. `drug_lots` - FIFO/FEFO lot tracking
3. `inventory_transactions` - All movements audit trail
4. `drug_distributions` - Distribution headers
5. `drug_distribution_items` - Distribution items

See `prisma/schema.prisma` lines 278-380
