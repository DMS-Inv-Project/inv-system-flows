# Inventory API Specifications

**Auto-generated from AegisX Backend**

This directory will contain OpenAPI specifications for Inventory APIs.

## Endpoints

### Stock Levels
- GET /api/inventory - List all inventory records
- GET /api/inventory/:drugId/:locationId - Get stock for drug at location
- GET /api/inventory/low-stock - Get items below reorder point
- GET /api/inventory/valuation - Get inventory valuation report

### Lot Management
- GET /api/inventory/lots/:drugId/:locationId - Get all lots for drug
- GET /api/inventory/lots/:lotId - Get lot details
- GET /api/inventory/fifo-lots - Get FIFO lots (preview)
- GET /api/inventory/fefo-lots - Get FEFO lots (preview)
- GET /api/inventory/expiring - Get expiring lots (with days parameter)

### Stock Movements
- POST /api/inventory/receipts/:id/post - Post receipt to inventory
- POST /api/inventory/transfers - Transfer between locations
- GET /api/inventory/transfers - List transfer history
- GET /api/inventory/transfers/:id - Get transfer details

### Stock Adjustments
- POST /api/inventory/adjustments - Create stock adjustment
- GET /api/inventory/adjustments - List adjustments
- GET /api/inventory/adjustments/:id - Get adjustment details
- GET /api/inventory/count-sheets - Generate physical count sheets

### Expiry Management
- GET /api/inventory/expiring/:days - Get drugs expiring in X days
- POST /api/inventory/quarantine/:lotId - Move expired lot to quarantine
- GET /api/inventory/expiry-report - Generate expiry report
- GET /api/inventory/expired - Get expired lots

### Transactions
- GET /api/inventory/transactions/:inventoryId - Get transaction history
- GET /api/inventory/transactions/drug/:drugId - Get all transactions for drug

**Status:** Pending AegisX backend implementation
