# TMT Integration API Specifications

**Auto-generated from AegisX Backend**

This directory will contain OpenAPI specifications for TMT Integration APIs.

## Endpoints

### TMT Data Management
- POST /api/tmt/load-concepts - Load TMT concepts from CSV (25,991 concepts)
- POST /api/tmt/load-relationships - Load hierarchy relationships
- POST /api/tmt/load-attributes - Load concept attributes
- GET /api/tmt/concepts - Search TMT concepts (fuzzy search)
- GET /api/tmt/concepts/:id - Get concept details
- GET /api/tmt/hierarchy/:id - Get concept hierarchy (parent/children)

### Master Data
- GET /api/tmt/manufacturers - List TMT manufacturers
- GET /api/tmt/dosage-forms - List TMT dosage forms (87 forms)
- GET /api/tmt/units - List TMT units

### Drug Mapping
- POST /api/tmt/mappings - Create drug-to-TMT mapping
- GET /api/tmt/mappings - List all mappings
- GET /api/tmt/mappings/drug/:drugId - Get mappings for specific drug
- PUT /api/tmt/mappings/:id - Update mapping
- DELETE /api/tmt/mappings/:id - Remove mapping
- POST /api/tmt/mappings/:id/verify - Verify mapping (pharmacist)

### AI-Assisted Mapping
- GET /api/tmt/suggest-mappings - Get AI-suggested TMT mappings for unmapped drugs
- POST /api/tmt/batch-map - Batch create mappings from suggestions

### Compliance
- GET /api/tmt/compliance - Get current compliance rate
- GET /api/tmt/unmapped-drugs - List unmapped drugs
- GET /api/tmt/compliance-history - Compliance rate over time
- POST /api/tmt/compliance-report - Generate ministry compliance report

### HIS Integration
- POST /api/tmt/his/import - Import HIS drug master
- GET /api/tmt/his/drugs - List HIS drugs
- POST /api/tmt/his/map - Map HIS drug to TMT

**Status:** Pending AegisX backend implementation
