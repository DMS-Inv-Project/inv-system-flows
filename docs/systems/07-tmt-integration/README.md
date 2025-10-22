# 🔗 TMT Integration System

**Thai Medical Terminology (TMT) for Ministry Compliance**

**Priority:** ⭐⭐⭐ สูง (Ministry Requirement)
**Tables:** 10 tables
**TMT Concepts:** 25,991 loaded
**Status:** ✅ Production Ready
**Workflows:** 3 major processes

---

## 📋 Overview

TMT Integration System จัดการการเชื่อมต่อกับมาตรฐาน Thai Medical Terminology:

### 3 โมดูลหลัก

1. **📚 TMT Data Management** (7 tables)
   - `tmt_concepts` - 25,991 TMT concepts (10 levels)
   - `tmt_relationships` - Hierarchy relationships
   - `tmt_attributes` - Additional properties
   - `tmt_manufacturers` - Manufacturer codes
   - `tmt_dosage_forms` - 87 dosage form codes
   - `tmt_units` - Unit codes with conversion
   - Ministry-standard reference data

2. **🔗 Drug-to-TMT Mapping** (1 table)
   - `tmt_mappings` - Hospital drugs → TMT concepts
   - Pharmacist verification required
   - One-to-one mapping
   - Preferred level: GP (Generic Product)

3. **📊 Compliance & Reporting** (2 tables)
   - `his_drug_master` - HIS integration
   - `tmt_usage_stats` - Usage tracking
   - `ministry_reports` - Compliance reports
   - Target: >= 95% drugs mapped

---

## 🎯 Key Features

### ✅ 25,991 TMT Concepts Loaded

**10-Level Hierarchy:**
```
SUBS → VTM → GP → TP → GPU → TPU → GPP → TPP → GP-F → GP-X
```

### ✅ Drug-to-TMT Mapping

**Pharmacist-verified mapping:**
- Search TMT by drug name/strength
- AI-suggested matches with confidence score
- One-to-one mapping per drug
- Preferred at GP (Generic Product) level

### ✅ Ministry Compliance

**100% DMSIC Standards:**
- TMT code in DRUGLIST export (field 10)
- Compliance rate tracking
- Unmapped drugs alerts
- Quarterly ministry reports

### ✅ HIS Integration

**Hospital Information System:**
- HIS drug master mapping
- NC24 code support (legacy)
- Mapping status tracking
- Usage statistics

---

## 🔗 System Dependencies

### TMT Integration ให้ข้อมูลแก่:

```
TMT Integration
    ├─→ Ministry Reporting (TMT code in DRUGLIST)
    ├─→ Dashboard (compliance rate, unmapped alerts)
    └─→ Drug Master (TMT code reference)
```

### TMT Integration ใช้ข้อมูลจาก:

```
Master Data → TMT Integration
    ├─ drug_generics → map to TMT
    └─ drugs → map to TMT

Distribution → TMT Integration
    └─ usage → tmt_usage_stats

Ministry → TMT Integration
    └─ TMT data updates (CSV download)
```

---

## 📂 Documentation Files

| File | Description |
|------|-------------|
| **README.md** | This file - Overview of TMT Integration |
| **[SCHEMA.md](SCHEMA.md)** | Database schema: 10 tables + TMT hierarchy + 25,991 concepts |
| **[WORKFLOWS.md](WORKFLOWS.md)** | Business workflows: 3 major flows (Loading, Mapping, Compliance) |
| **api/** | OpenAPI specs (will be auto-generated from AegisX) |

---

## 🎯 Quick Start

### 1. Load TMT Concepts (Initial Setup)

```typescript
// Load 25,991 TMT concepts from ministry CSV
const count = await loadTMTConcepts('./data/tmt_concepts.csv');
console.log(`Loaded ${count} TMT concepts`);
// Output: Loaded 25991 TMT concepts
```

### 2. Search TMT Concepts

```typescript
// Search for Paracetamol at GP level
const matches = await prisma.tmtConcept.findMany({
  where: {
    preferred_term: { contains: 'Paracetamol', mode: 'insensitive' },
    level: 'GP',
    is_active: true
  },
  take: 10
});

console.log(`Found ${matches.length} matches`);
```

### 3. Map Drug to TMT

```typescript
// Map Paracetamol 500mg to TMT
const mapping = await prisma.tmtMapping.create({
  data: {
    generic_id: 1n,
    tmt_concept_id: 12345n,  // TMT concept ID
    tmt_level: 'GP',
    is_verified: true,
    verified_by: userId
  }
});
```

### 4. Check Compliance Rate

```typescript
const total = await prisma.drug.count({ where: { is_active: true } });
const mapped = await prisma.drug.count({
  where: {
    is_active: true,
    tmtMappings: { some: { is_verified: true } }
  }
});

const rate = (mapped / total) * 100;
console.log(`TMT Compliance: ${rate.toFixed(2)}%`);
// Target: >= 95%
```

### 5. Get Unmapped Drugs

```typescript
const unmapped = await prisma.drug.findMany({
  where: {
    is_active: true,
    tmtMappings: { none: {} }
  },
  include: {
    generic: true
  },
  take: 20
});

console.log(`Found ${unmapped.length} unmapped drugs - action required!`);
```

---

## 🔗 Related Documentation

### Global Documentation
- **[SYSTEM_ARCHITECTURE.md](../../SYSTEM_ARCHITECTURE.md)** - Overview of all 8 systems
- **[DATABASE_STRUCTURE.md](../../DATABASE_STRUCTURE.md)** - Complete database schema (44 tables)
- **[END_TO_END_WORKFLOWS.md](../../END_TO_END_WORKFLOWS.md)** - Cross-system workflows

### Per-System Documentation
- **[SCHEMA.md](SCHEMA.md)** - Detailed schema of this system's 10 tables + 25,991 concepts
- **[WORKFLOWS.md](WORKFLOWS.md)** - 3 business workflows: TMT Loading, Mapping, Compliance

### Related Systems
- **[Master Data](../01-master-data/README.md)** - Drug generics and drugs
- **[Distribution](../05-distribution/README.md)** - Usage tracking

### Technical Reference
- **`prisma/schema.prisma`** - Source schema definition
- **`scripts/tmt/`** - TMT import scripts
- **AegisX Swagger UI** - http://127.0.0.1:3383/documentation (when running)

---

## 📈 Next Steps

1. ✅ **Read** [SCHEMA.md](SCHEMA.md) - Understand 10 tables + TMT hierarchy
2. ✅ **Read** [WORKFLOWS.md](WORKFLOWS.md) - Understand 3 business workflows
3. ⏳ **Load** TMT Data - Download and load 25,991 concepts
4. ⏳ **Map** Drugs - Map all active drugs to TMT
5. ⏳ **Monitor** Compliance - Track >= 95% target
6. ⏳ **Integrate** HIS - Map HIS drug master
7. ⏳ **Report** Ministry - Generate quarterly reports

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.2.0
