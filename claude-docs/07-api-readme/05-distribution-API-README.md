# Distribution API Specifications

**Auto-generated from AegisX Backend**

This directory will contain OpenAPI specifications for Distribution APIs.

## Endpoints

### Distribution Request
- POST /api/distributions - Create distribution request
- GET /api/distributions - List distributions (with filters)
- GET /api/distributions/:id - Get distribution details
- PUT /api/distributions/:id - Update distribution (PENDING only)
- DELETE /api/distributions/:id - Cancel distribution (PENDING only)

### Approval
- POST /api/distributions/:id/approve - Approve distribution
- POST /api/distributions/:id/reject - Reject/cancel distribution

### Dispensing
- POST /api/distributions/:id/dispense - Dispense drugs (APPROVED → DISPENSED)
- GET /api/distributions/:id/preview-lots - Preview FIFO lots before dispensing

### Receipt
- POST /api/distributions/:id/complete - Mark as completed (department received)
- POST /api/distributions/:id/report-discrepancy - Report discrepancy

### Reports
- GET /api/distributions/department/:deptId - Distribution history by department
- GET /api/distributions/drug/:drugId - Usage history by drug
- GET /api/distributions/summary - Monthly/yearly summary
- GET /api/distributions/export - Export for ministry reporting

### Utilities
- GET /api/distributions/check-stock - Check stock availability for planned distribution
- GET /api/distributions/generate-number - Generate next distribution number

**Status:** Pending AegisX backend implementation
