# Procurement API Specifications

**Auto-generated from AegisX Backend**

This directory will contain OpenAPI specifications for Procurement APIs.

## Endpoints

### Purchase Request (PR)
- POST /api/purchase-requests - Create PR
- GET /api/purchase-requests - List PRs
- GET /api/purchase-requests/:id - Get PR detail
- PUT /api/purchase-requests/:id - Update PR
- POST /api/purchase-requests/:id/approve - Approve PR
- POST /api/purchase-requests/:id/reject - Reject PR
- DELETE /api/purchase-requests/:id - Delete draft PR

### Purchase Order (PO)
- POST /api/purchase-orders - Create PO from PR
- GET /api/purchase-orders - List POs
- GET /api/purchase-orders/:id - Get PO detail
- PUT /api/purchase-orders/:id - Update PO
- POST /api/purchase-orders/:id/send - Send PO to vendor
- POST /api/purchase-orders/:id/cancel - Cancel PO

### Goods Receipt (GR)
- POST /api/receipts - Create receipt
- GET /api/receipts - List receipts
- GET /api/receipts/:id - Get receipt detail
- PUT /api/receipts/:id - Update receipt
- POST /api/receipts/:id/approve - Approve receipt
- POST /api/receipts/:id/post - Post to inventory

### Contracts
- POST /api/contracts - Create contract
- GET /api/contracts - List contracts
- GET /api/contracts/:id - Get contract detail
- PUT /api/contracts/:id - Update contract
- GET /api/contracts/:id/items - Get contract items

### Payment
- POST /api/payments - Create payment document
- GET /api/payments - List payment documents
- GET /api/payments/:id - Get payment detail
- POST /api/payments/:id/attachments - Upload attachment

**Status:** Pending AegisX backend implementation
