# API Documentation

**Status**: 🚧 Pending - Will be auto-generated from AegisX backend

---

## 📋 Overview

Master Data API documentation will be automatically generated from the AegisX OpenAPI specification.

**Source**: AegisX backend template
**URL**: http://127.0.0.1:3383/documentation/json

---

## 📂 Structure

```
api/
├── openapi.yaml          # ← Will be generated from AegisX
├── examples/
│   ├── javascript.md     # ← Code examples (Fetch/Axios)
│   ├── typescript.md     # ← TypeScript + React Query
│   ├── python.md         # ← Python requests library
│   └── curl.md           # ← cURL commands
└── README.md             # ← This file
```

---

## 🔄 How to Generate OpenAPI Spec

### Option 1: Export from AegisX (Recommended)

```bash
# Get OpenAPI JSON from running AegisX server
curl http://127.0.0.1:3383/documentation/json > openapi.json

# Convert to YAML (optional, using yq or online converter)
yq eval -P openapi.json > openapi.yaml
```

### Option 2: Use Swagger UI Export

1. Open http://127.0.0.1:3383/documentation
2. Click "Download" → "openapi.json" or "openapi.yaml"
3. Save to this folder

---

## 📝 What Will Be Included

### Core Endpoints (from AegisX pattern)

**Master Data CRUD:**
```
GET    /api/master-data/{entity}/              # List with pagination
POST   /api/master-data/{entity}/              # Create
GET    /api/master-data/{entity}/{id}          # Get by ID
PUT    /api/master-data/{entity}/{id}          # Update
DELETE /api/master-data/{entity}/{id}          # Delete
```

**Bulk Operations:**
```
POST   /api/master-data/{entity}/bulk          # Bulk create
PUT    /api/master-data/{entity}/bulk          # Bulk update
DELETE /api/master-data/{entity}/bulk          # Bulk delete
```

**Helpers:**
```
GET    /api/master-data/{entity}/dropdown      # UI dropdown options
POST   /api/master-data/{entity}/validate      # Pre-save validation
GET    /api/master-data/{entity}/check/{field} # Check uniqueness
GET    /api/master-data/{entity}/export        # Export CSV/Excel
```

**Bulk Import (to be implemented):**
```
GET    /api/master-data/{entity}/import/template           # Download template
POST   /api/master-data/{entity}/import/validate           # Validate file
POST   /api/master-data/{entity}/import/execute            # Execute import
GET    /api/master-data/{entity}/import/status/{jobId}     # Track progress
GET    /api/master-data/{entity}/import/error-report/{jobId} # Error report
DELETE /api/master-data/{entity}/import/cancel/{jobId}     # Cancel import
```

### Entities Supported

- `drugs` - Trade name drugs
- `drug-generics` - Generic drugs
- `companies` - Vendors/Manufacturers
- `locations` - Storage locations
- `departments` - Hospital departments
- `budget-types` - Budget type groups
- `contracts` - Contracts
- `contract-items` - Contract items

---

## 🎯 Next Steps

1. ✅ Implement Master Data endpoints in AegisX backend
2. ✅ Test all endpoints via Swagger UI
3. ⏳ Export OpenAPI spec to this folder
4. ⏳ Create code examples in `examples/` folder
5. ⏳ Generate Postman collection from OpenAPI

---

## 📚 References

- **AegisX Swagger UI**: http://127.0.0.1:3383/documentation
- **OpenAPI JSON**: http://127.0.0.1:3383/documentation/json
- **Authors API Example**: Already implemented in AegisX (use as pattern)
- **Bulk Import Spec**: `../_archive/BULK_IMPORT_API_SPEC.md` (reference only)

---

**Last Updated**: 2025-01-22
**Status**: Waiting for AegisX implementation
