# HPP System API Specifications

**Auto-generated from AegisX Backend**

This directory will contain OpenAPI specifications for Hospital Pharmaceutical Products (HPP) APIs.

## Endpoints

### HPP Product Management
- POST /api/hpp/repackaged - Create repackaged product (HPP-R)
- POST /api/hpp/modified - Create modified product (HPP-M)
- POST /api/hpp/formula - Create hospital formula (HPP-F)
- POST /api/hpp/extemporaneous - Create extemporaneous product (HPP-X)
- POST /api/hpp/outsourced - Create outsourced product (OHPP)
- GET /api/hpp - List all HPP products with filters
- GET /api/hpp/:id - Get HPP product details with formulation
- PUT /api/hpp/:id - Update HPP product
- PATCH /api/hpp/:id/deactivate - Deactivate HPP product
- DELETE /api/hpp/:id - Soft delete HPP product

### Formulation Management
- POST /api/hpp/:id/components - Add formulation components (for F type)
- GET /api/hpp/:id/components - Get all components for a formula
- PUT /api/hpp/:id/components/:componentId - Update component
- DELETE /api/hpp/:id/components/:componentId - Remove component
- POST /api/hpp/:id/validate-formula - Validate formulation ratios

### HPP Search & Filter
- GET /api/hpp?type=R - Filter by HPP type
- GET /api/hpp?search=paracetamol - Search by product name
- GET /api/hpp?generic_id=1 - Filter by generic drug
- GET /api/hpp?is_active=true - Filter active products
- GET /api/hpp?is_outsourced=true - Filter outsourced products

### Reports & Statistics
- GET /api/hpp/stats - Get HPP product statistics by type
- GET /api/hpp/components/popular - Get most used components
- GET /api/hpp/expiring - Get HPP products approaching expiry
- POST /api/hpp/reports/production-log - Generate production log report
- POST /api/hpp/reports/formula-card/:id - Generate formula card PDF

### Quality Control
- POST /api/hpp/:id/qc-check - Record QC check result
- GET /api/hpp/:id/qc-history - Get QC history
- POST /api/hpp/:id/approve - Pharmacist approval (for F, X types)
- POST /api/hpp/:id/reject - Reject product

### Integration
- GET /api/hpp/for-inventory - Get HPP products for inventory management
- GET /api/hpp/for-distribution - Get HPP products for distribution
- POST /api/hpp/map-tmt - Map HPP product to TMT code
- GET /api/hpp/ministry-export - Export HPP data for ministry reporting

**Status:** Pending AegisX backend implementation
