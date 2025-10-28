# 🚀 TMT Integration - API Development Guide

**System:** Thai Medical Terminology (TMT) Integration
**Version:** 2.6.0
**Last Updated:** 2025-01-28
**Target Audience:** Backend Developers

---

## 📋 Overview

TMT Integration provides standardized drug terminology for ministry reporting:
- **TMT Concepts** - 76,904 Thai Medical Terminology concepts (Phase 7)
- **Drug-TMT Mappings** - 561 drugs mapped (47.99% coverage) (Phase 8)
- **Hierarchy** - 5-level structure (VTM → GP → GPU → TP → TPU)
- **Ministry Compliance** - Required for DMSIC Standards reporting

---

## 🔐 Authentication & Authorization

| Feature | Finance Manager | Dept Head | Pharmacist | Nurse | Other Staff |
|---------|----------------|-----------|------------|-------|-------------|
| View TMT Concepts | ✅ | ✅ | ✅ | ✅ | ❌ |
| Search TMT | ✅ | ✅ | ✅ | ✅ | ❌ |
| Map Drug to TMT | ✅ | ❌ | ✅ | ❌ | ❌ |
| View Mappings | ✅ | ✅ | ✅ | ❌ | ❌ |
| Export Ministry Data | ✅ | ❌ | ✅ | ❌ | ❌ |

**Note:** TMT data is mostly read-only. Mapping is done by pharmacists/admins.

---

## 📊 API Development Priority

### Phase 1: TMT Search & Lookup (Week 1) ⭐

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 1 | `/api/tmt/concepts` | GET | List TMT concepts (paginated) |
| 2 | `/api/tmt/concepts/:id` | GET | Get concept details |
| 3 | `/api/tmt/concepts/search` | GET | Search by name/code |
| 4 | `/api/tmt/hierarchy/:conceptId` | GET | Get concept hierarchy (parents/children) |

### Phase 2: Drug-TMT Mapping (Week 2)

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 5 | `/api/tmt/mappings` | GET | List drug-TMT mappings |
| 6 | `/api/tmt/mappings` | POST | Create mapping |
| 7 | `/api/tmt/mappings/:id` | PUT | Update mapping |
| 8 | `/api/tmt/mappings/:id` | DELETE | Remove mapping |
| 9 | `/api/tmt/drugs/:drugId/mappings` | GET | Get TMT for specific drug |

### Phase 3: Ministry Reporting (Week 3)

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 10 | `/api/tmt/coverage-report` | GET | TMT mapping coverage statistics |
| 11 | `/api/tmt/ministry-export` | GET | Export mapped drugs for ministry |

---

## 🚨 Error Codes

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `TMT_CONCEPT_NOT_FOUND` | 404 | ไม่พบรหัส TMT | TMT concept ID doesn't exist |
| `DRUG_NOT_FOUND` | 404 | ไม่พบข้อมูลยา | Drug ID doesn't exist |
| `MAPPING_EXISTS` | 409 | ยานี้มีการ map TMT แล้ว | Drug already mapped to TMT |
| `INVALID_TMT_LEVEL` | 400 | ระดับ TMT ไม่ถูกต้อง | TMT level must be VTM/GP/GPU/TP/TPU |
| `UNMAPPED_DRUG` | 404 | ยานี้ยังไม่ได้ map กับ TMT | Drug has no TMT mapping |

---

## 📝 Request/Response Examples

### 1. Search TMT Concepts

**Endpoint:** `GET /api/tmt/concepts/search`

**Query Parameters:**
```typescript
{
  q: string,                    // Search term (tmt_code or name)
  level?: 'VTM' | 'GP' | 'GPU' | 'TP' | 'TPU',  // Filter by level
  page?: number,
  limit?: number
}
```

**Example Request:**
```
GET /api/tmt/concepts/search?q=paracetamol&level=GP
```

**Success Response:**
```typescript
{
  success: true,
  data: [
    {
      id: 1001,
      tmt_code: "0000001234",
      tmt_name_thai: "พาราเซตามอล เม็ด",
      tmt_name_english: "Paracetamol Tablet",
      tmt_level: "GP",  // Generic Product
      parent_tmt_id: 500,  // Links to VTM level
      has_children: true,
      created_at: "2025-01-20T10:00:00Z",
      
      // Parent (VTM level)
      parent: {
        tmt_code: "0000000123",
        tmt_name_thai: "พาราเซตามอล",
        tmt_level: "VTM"
      },
      
      // Statistics
      _count: {
        children: 15,  // GPU level concepts
        drug_mappings: 25  // Drugs mapped to this concept
      }
    }
  ],
  meta: {
    pagination: { page: 1, limit: 20, total: 150 }
  }
}
```

---

### 2. Get TMT Hierarchy

**Endpoint:** `GET /api/tmt/hierarchy/:conceptId`

**Example Request:**
```
GET /api/tmt/hierarchy/1001
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    concept: {
      id: 1001,
      tmt_code: "0000001234",
      tmt_name_thai: "พาราเซตามอล เม็ด",
      tmt_level: "GP"
    },
    
    // Hierarchy path (bottom-up)
    hierarchy: [
      {
        level: "VTM",
        tmt_code: "0000000123",
        tmt_name_thai: "พาราเซตามอล"
      },
      {
        level: "GP",
        tmt_code: "0000001234",
        tmt_name_thai: "พาราเซตามอล เม็ด" // Current
      }
    ],
    
    // Children (GPU level)
    children: [
      {
        id: 2001,
        tmt_code: "0000002345",
        tmt_name_thai: "พาราเซตามอล 500 มิลลิกรัม เม็ด",
        tmt_level: "GPU",
        _count: { drug_mappings: 10 }
      },
      {
        id: 2002,
        tmt_code: "0000002346",
        tmt_name_thai: "พาราเซตามอล 650 มิลลิกรัม เม็ด",
        tmt_level: "GPU",
        _count: { drug_mappings: 5 }
      }
    ]
  }
}
```

---

### 3. Create Drug-TMT Mapping

**Endpoint:** `POST /api/tmt/mappings`

**Request:**
```typescript
{
  drug_id: 201,
  tmt_concept_id: 2001,  // GPU level recommended
  mapping_confidence: "HIGH",  // HIGH, MEDIUM, LOW
  mapped_by: 10,
  notes: "Exact match - Paracetamol 500mg TAB"
}
```

**Validation:**
```typescript
// Check drug exists
const drug = await prisma.drug.findUnique({
  where: { id: drug_id }
});
if (!drug) {
  throw new NotFoundError('DRUG_NOT_FOUND');
}

// Check TMT concept exists
const concept = await prisma.tmtConcept.findUnique({
  where: { id: tmt_concept_id }
});
if (!concept) {
  throw new NotFoundError('TMT_CONCEPT_NOT_FOUND');
}

// Check duplicate mapping
const existing = await prisma.tmtMapping.findFirst({
  where: { drug_id: drug_id }
});
if (existing) {
  throw new ConflictError('MAPPING_EXISTS');
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 1,
    drug_id: 201,
    tmt_concept_id: 2001,
    mapping_confidence: "HIGH",
    created_at: "2025-01-28T10:00:00Z",
    
    drug: {
      drug_code: "PARA500TAB001",
      trade_name: "Tylenol 500mg",
      generic: {
        generic_name: "Paracetamol 500mg TAB"
      }
    },
    
    tmt_concept: {
      tmt_code: "0000002345",
      tmt_name_thai: "พาราเซตามอล 500 มิลลิกรัม เม็ด",
      tmt_level: "GPU"
    }
  },
  message: "Map ยากับ TMT สำเร็จ"
}
```

---

### 4. Get Drug TMT Mapping

**Endpoint:** `GET /api/tmt/drugs/:drugId/mappings`

**Example Request:**
```
GET /api/tmt/drugs/201/mappings
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    drug_id: 201,
    drug: {
      drug_code: "PARA500TAB001",
      trade_name: "Tylenol 500mg"
    },
    
    mapping: {
      id: 1,
      tmt_concept_id: 2001,
      mapping_confidence: "HIGH",
      created_at: "2025-01-28T10:00:00Z",
      
      // TMT concept with full hierarchy
      tmt_concept: {
        tmt_code: "0000002345",
        tmt_name_thai: "พาราเซตามอล 500 มิลลิกรัม เม็ด",
        tmt_level: "GPU",
        
        hierarchy: [
          { level: "VTM", tmt_code: "0000000123", tmt_name_thai: "พาราเซตามอล" },
          { level: "GP", tmt_code: "0000001234", tmt_name_thai: "พาราเซตามอล เม็ด" },
          { level: "GPU", tmt_code: "0000002345", tmt_name_thai: "พาราเซตามอล 500 มิลลิกรัม เม็ด" }
        ]
      }
    }
  }
}
```

**Error Response (Unmapped):**
```typescript
{
  success: false,
  error: {
    code: "UNMAPPED_DRUG",
    message: "ยานี้ยังไม่ได้ map กับ TMT",
    message_en: "Drug has no TMT mapping",
    details: {
      drug_id: 201,
      drug_name: "Tylenol 500mg",
      suggestion: "ใช้ /api/tmt/concepts/search เพื่อค้นหา TMT ที่เหมาะสม"
    }
  }
}
```

---

### 5. TMT Coverage Report

**Endpoint:** `GET /api/tmt/coverage-report`

**Success Response:**
```typescript
{
  success: true,
  data: {
    summary: {
      total_drugs: 1169,
      mapped_drugs: 561,
      unmapped_drugs: 608,
      coverage_percent: 47.99
    },
    
    by_confidence: {
      high: 450,
      medium: 85,
      low: 26
    },
    
    by_tmt_level: {
      VTM: 15,
      GP: 120,
      GPU: 380,  // Most mappings at GPU level
      TP: 40,
      TPU: 6
    },
    
    top_unmapped_drugs: [
      {
        drug_id: 305,
        drug_code: "AMX1000CAP001",
        trade_name: "Amoxicillin 1000mg",
        usage_count: 5000,  // High usage but unmapped
        priority: "HIGH"
      }
    ],
    
    recent_mappings: [
      {
        drug_id: 201,
        drug_name: "Tylenol 500mg",
        tmt_code: "0000002345",
        mapped_at: "2025-01-28T10:00:00Z",
        mapped_by: "John Doe"
      }
    ]
  }
}
```

---

## ⚙️ Environment Configuration

```env
# TMT Configuration
TMT_DEFAULT_SEARCH_LIMIT=20                # Default search results
TMT_SEARCH_MIN_LENGTH=3                    # Minimum search term length
TMT_ENABLE_FUZZY_SEARCH=true               # Enable fuzzy matching
TMT_CACHE_CONCEPTS=true                    # Cache TMT concepts in Redis
TMT_CACHE_TTL=3600                         # Cache TTL in seconds (1 hour)

# Mapping Configuration
TMT_REQUIRE_DRUG_MAPPING=false             # Require TMT mapping for new drugs
TMT_AUTO_SUGGEST_MAPPINGS=true             # Auto-suggest based on name similarity
TMT_MAPPING_APPROVAL_REQUIRED=false        # Require approval for mappings

# Ministry Reporting
TMT_EXPORT_INCLUDE_UNMAPPED=true           # Include unmapped drugs in export
TMT_EXPORT_DEFAULT_TMT_CODE=0000000000     # Default code for unmapped drugs
```

---

## 🧪 Testing Guidelines

### Test TMT Search & Hierarchy

```typescript
describe('TMT Integration', () => {
  it('should search TMT concepts by name', async () => {
    const response = await request(app)
      .get('/api/tmt/concepts/search?q=paracetamol');
    
    expect(response.status).toBe(200);
    expect(response.body.data.length).toBeGreaterThan(0);
    expect(response.body.data[0]).toHaveProperty('tmt_code');
    expect(response.body.data[0]).toHaveProperty('tmt_level');
  });
  
  it('should get TMT hierarchy', async () => {
    const response = await request(app)
      .get('/api/tmt/hierarchy/1001');
    
    expect(response.status).toBe(200);
    expect(response.body.data.hierarchy).toBeInstanceOf(Array);
    expect(response.body.data.hierarchy.length).toBeGreaterThan(0);
  });
  
  it('should create drug-TMT mapping', async () => {
    const response = await request(app)
      .post('/api/tmt/mappings')
      .send({
        drug_id: 201,
        tmt_concept_id: 2001,
        mapping_confidence: 'HIGH'
      });
    
    expect(response.status).toBe(200);
    expect(response.body.data.drug_id).toBe(201);
    expect(response.body.data.tmt_concept_id).toBe(2001);
  });
});
```

---

**Last Updated:** 2025-01-28 | **Version:** 2.6.0
**Built with ❤️ for INVS Modern Team**
