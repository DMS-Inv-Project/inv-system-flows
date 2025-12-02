# Drug Return API Specifications

**Auto-generated from AegisX Backend**

This directory will contain OpenAPI specifications for Drug Return APIs.

## Endpoints

### Return Request
- POST /api/drug-returns - Create drug return
- GET /api/drug-returns - List returns (with filters)
- GET /api/drug-returns/:id - Get return details
- PUT /api/drug-returns/:id - Update return (DRAFT only)
- DELETE /api/drug-returns/:id - Cancel return (before POSTED)

### Submission & Verification
- POST /api/drug-returns/:id/submit - Submit return (DRAFT → SUBMITTED)
- POST /api/drug-returns/:id/verify - Verify and separate good/damaged (SUBMITTED → VERIFIED)

### Posting
- POST /api/drug-returns/:id/post - Post to inventory (VERIFIED → POSTED)

### Reports
- GET /api/drug-returns/department/:deptId - Return history by department
- GET /api/drug-returns/damaged - Damaged drugs summary
- GET /api/drug-returns/quarantine - Current quarantine stock
- GET /api/drug-returns/statistics - Return statistics (monthly/yearly)

### Disposal Management
- POST /api/drug-disposals - Create disposal document
- POST /api/drug-disposals/:id/complete - Mark disposal complete with photo evidence
- GET /api/drug-disposals - List disposal documents
- GET /api/drug-disposals/:id - Get disposal details

**Status:** Pending AegisX backend implementation
