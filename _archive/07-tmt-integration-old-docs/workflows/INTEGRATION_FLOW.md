# FLOW 06: TMT Integration
## Thai Medical Terminology - Drug Code Mapping & Standards

**Version**: 1.0.0
**Last Updated**: 2025-01-11
**Status**: ✅ Complete

---

## 🎯 Overview

ระบบเชื่อมต่อกับ Thai Medical Terminology (TMT) เพื่อมาตรฐานรหัสยาตามที่กระทรวงสาธารณสุขกำหนด รองรับการส่งข้อมูลให้ กสธ. และ HIS

### Key Features

```
✅ TMT Concept Database (25,991 concepts)
✅ Automatic Drug-TMT Mapping
✅ NC24 Code Support
✅ HIS Integration
✅ Ministry Reporting Compliance
✅ Multi-level Hierarchy (SUBS → TPP)
```

---

## 📊 TMT Tables (3 tables)

```
┌────────────────────────────────────────┐
│          TMT INTEGRATION               │
└────────────────────────────────────────┘

┌──────────────────────┐
│   tmt_concepts       │  ← TMT Concept Database
│   ─────────────────  │    (25,991 concepts)
│   • tmt_id           │
│   • tmt_code         │
│   • tmt_name_th      │
│   • tmt_name_en      │
│   • level (SUBS-TPP) │
│   • nc24_code        │
└──────────────────────┘
         ↓
┌──────────────────────┐
│   tmt_mappings       │  ← Drug → TMT Mapping
│   ─────────────────  │
│   • working_code     │
│   • drug_code        │
│   • tmt_concept_id   │
│   • confidence       │
│   • mapping_source   │
└──────────────────────┘
         ↓
┌──────────────────────┐
│   his_drug_master    │  ← HIS Integration
│   ─────────────────  │
│   • his_drug_code    │
│   • tmt_concept_id   │
│   • mapping_status   │
└──────────────────────┘
```

---

## 🏗️ TMT Hierarchy Levels

### 8-Level Structure

```
1. SUBS - Substance (สาร)
   Example: Paracetamol
   ↓
2. VTM - Virtual Therapeutic Moiety (สารสำคัญ)
   Example: Paracetamol
   ↓
3. GP - Generic Product (ยาสามัญ)
   Example: Paracetamol 500mg
   ↓
4. TP - Trade Product (ยาการค้า)
   Example: GPO Paracetamol
   ↓
5. GPU - Generic Product Unit (ยาสามัญ รูปแบบและความแรง)
   Example: Paracetamol 500mg Tablet
   ↓
6. TPU - Trade Product Unit (ยาการค้า รูปแบบและความแรง)
   Example: GPO Paracetamol 500mg Tablet
   ↓
7. GPP - Generic Product Pack (ยาสามัญ บรรจุภัณฑ์)
   Example: Paracetamol 500mg Tablet x 100's
   ↓
8. TPP - Trade Product Pack (ยาการค้า บรรจุภัณฑ์)
   Example: GPO Paracetamol 500mg Tablet x 100's
```

### Recommended Mapping Level

```
✅ TPU (Trade Product Unit) - Most commonly used
   - มีข้อมูลครบถ้วน (trade name + strength + form)
   - เหมาะกับการใช้งานจริงในโรงพยาบาล
   - รองรับการ trace ได้ถึง manufacturer

Alternative:
✅ GPU (Generic Product Unit) - For generic drugs
✅ TPP (Trade Product Pack) - If pack size is critical
```

---

## 🔄 FLOW 06.1: Import TMT Concepts

### Import from TMT Database

```sql
-- Step 1: Import TMT Concepts (25,991 records)
-- Source: TMTRF files from Ministry of Public Health

INSERT INTO tmt_concepts (
    tmt_id,
    tmt_code,
    tmt_name_th,
    tmt_name_en,
    level,
    nc24_code,
    parent_id,
    is_active,
    created_at
)
SELECT
    tmt_id,
    tmt_code,
    tmt_name_th,
    tmt_name_en,
    level,
    nc24_code,
    parent_id,
    true,
    CURRENT_TIMESTAMP
FROM external_tmt_source
WHERE level IN ('TPU', 'GPU', 'TPP');  -- Focus on commonly used levels

-- Step 2: Verify Import
SELECT
    level,
    COUNT(*) as concept_count
FROM tmt_concepts
WHERE is_active = true
GROUP BY level
ORDER BY
    CASE level
        WHEN 'SUBS' THEN 1
        WHEN 'VTM' THEN 2
        WHEN 'GP' THEN 3
        WHEN 'TP' THEN 4
        WHEN 'GPU' THEN 5
        WHEN 'TPU' THEN 6
        WHEN 'GPP' THEN 7
        WHEN 'TPP' THEN 8
    END;
```

**Expected Result:**
```
level | concept_count
------+--------------
TPU   |     12,450
GPU   |      8,320
TPP   |      5,221
```

---

## 🔄 FLOW 06.2: Map Drugs to TMT

### Automatic Mapping

```sql
-- Create TMT Mapping for Drug
INSERT INTO tmt_mappings (
    working_code,
    drug_code,
    generic_id,
    drug_id,
    tmt_level,
    tmt_concept_id,
    tmt_code,
    tmt_id,
    nc24_code,
    mapping_source,
    confidence,
    mapped_by,
    is_active,
    mapping_date
) VALUES (
    'PAR0001',
    'PAR0001-000001-001',
    1,  -- Generic: Paracetamol
    1,  -- Drug: GPO Paracetamol 500mg
    'TPU',
    12345,  -- TMT Concept ID
    'TPU00001',
    12345,
    'NC24-001',
    'auto',  -- auto, manual, verified
    0.95,  -- Confidence score (0-1)
    'System',
    true,
    CURRENT_DATE
);
```

### Mapping Algorithm

```typescript
// Pseudo-code for automatic mapping
function mapDrugToTMT(drug: Drug): TMTMapping {
  // 1. Extract key components
  const components = {
    genericName: drug.generic.generic_name,
    strength: drug.strength,
    dosageForm: drug.dosage_form,
    tradeName: drug.trade_name
  }
  
  // 2. Search TMT database
  const candidates = searchTMT({
    name: components.genericName,
    strength: components.strength,
    form: components.dosageForm,
    level: 'TPU'  // Prefer TPU level
  })
  
  // 3. Calculate confidence score
  const bestMatch = candidates[0]
  const confidence = calculateSimilarity(drug, bestMatch)
  
  // 4. Auto-map if confidence > 0.9
  if (confidence > 0.9) {
    return createMapping(drug, bestMatch, 'auto', confidence)
  } else {
    return createMapping(drug, bestMatch, 'manual', confidence)
  }
}
```

### Manual Verification

```sql
-- Query unmapped or low-confidence drugs
SELECT
    d.drug_code,
    d.trade_name,
    dg.generic_name,
    d.strength,
    d.dosage_form,
    tm.tmt_code,
    tm.confidence,
    tm.mapping_source
FROM drugs d
JOIN drug_generics dg ON d.generic_id = dg.id
LEFT JOIN tmt_mappings tm ON d.id = tm.drug_id
WHERE tm.confidence < 0.9 OR tm.id IS NULL
ORDER BY d.drug_code;
```

---

## 🔄 FLOW 06.3: HIS Integration

### Sync from HIS to INVS

```sql
-- Import drug master from HIS
INSERT INTO his_drug_master (
    his_drug_code,
    drug_name,
    generic_name,
    strength,
    dosage_form,
    manufacturer,
    tmt_concept_id,
    tmt_level,
    nc24_code,
    mapping_confidence,
    mapping_status,
    is_active,
    last_sync_date
) VALUES (
    'HIS-PAR-001',
    'GPO Paracetamol 500mg Tab',
    'Paracetamol',
    '500mg',
    'Tablet',
    'GPO',
    12345,  -- TMT Concept ID
    'TPU',
    'NC24-001',
    0.95,
    'mapped',  -- unmapped, mapped, verified
    true,
    CURRENT_TIMESTAMP
);

-- Link HIS drug to INVS drug
UPDATE drugs
SET his_drug_code = 'HIS-PAR-001'
WHERE drug_code = 'PAR0001-000001-001';
```

### Sync Status Monitoring

```sql
-- Check HIS sync status
SELECT
    mapping_status,
    COUNT(*) as drug_count,
    ROUND(AVG(mapping_confidence) * 100, 2) as avg_confidence_pct
FROM his_drug_master
WHERE is_active = true
GROUP BY mapping_status;
```

**Expected Result:**
```
mapping_status | drug_count | avg_confidence_pct
---------------+------------+-------------------
mapped         |    1,042   |       94.50
verified       |      856   |       98.20
unmapped       |       45   |       null
```

---

## 📊 TMT Compliance Report

### Query for Ministry Reporting

```sql
-- TMT Compliance Summary
SELECT
    COUNT(DISTINCT d.id) as total_drugs,
    COUNT(DISTINCT tm.drug_id) as mapped_drugs,
    COUNT(DISTINCT CASE WHEN tm.confidence >= 0.9 THEN tm.drug_id END) as high_confidence_drugs,
    ROUND(
        COUNT(DISTINCT tm.drug_id)::NUMERIC / COUNT(DISTINCT d.id) * 100,
        2
    ) as mapping_percentage,
    ROUND(
        AVG(tm.confidence) * 100,
        2
    ) as avg_confidence_pct
FROM drugs d
LEFT JOIN tmt_mappings tm ON d.id = tm.drug_id AND tm.is_active = true
WHERE d.is_active = true;
```

**Target Metrics:**
```
total_drugs: 1,200
mapped_drugs: 1,140  (95%)
high_confidence_drugs: 1,080  (90%)
mapping_percentage: 95.00%
avg_confidence_pct: 94.50%

✅ Target: > 90% mapping rate
✅ Target: > 85% high confidence
```

---

## 🎯 UI Mockup: TMT Mapping Interface

```
┌────────────────────────────────────────────────────────────────────┐
│  TMT Mapping - Drug to Standard Code Mapping        [Auto Map All]│
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  📊 Mapping Summary                                                 │
│  ┌──────────────┬──────────────┬──────────────┬──────────────┐    │
│  │ Total Drugs  │ Mapped       │ High Conf    │ Unmapped     │    │
│  │    1,200     │  1,140 (95%) │ 1,080 (90%)  │   60 (5%)    │    │
│  └──────────────┴──────────────┴──────────────┴──────────────┘    │
│                                                                     │
│  🔍 Drug Mapping List                [Filter: Unmapped ▼] [Search]│
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Drug Code  │ Drug Name          │ TMT Code  │ Conf │ Status │  │
│  ├────────────┼────────────────────┼───────────┼──────┼────────┤  │
│  │ PAR0001-..│ Paracetamol 500mg  │ TPU00001  │ 95%  │✅ Auto │  │
│  │ AMX0001-..│ Amoxicillin 250mg  │ TPU00025  │ 92%  │✅ Auto │  │
│  │ IBU0001-..│ Ibuprofen 400mg    │ TPU00042  │ 88%  │⚠️ Check│  │
│  │ CIP0001-..│ Ciprofloxacin 500mg│ -         │  -   │❌ None │  │
│  └────────────┴────────────────────┴───────────┴──────┴────────┘  │
│                                                                     │
│  📝 Selected: Ciprofloxacin 500mg Tablet             [Map Manually]│
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │ Search TMT: [ciprofloxacin 500                      ] [🔍]  │  │
│  │                                                             │  │
│  │ Suggested Matches:                                          │  │
│  │ ○ TPU05234 - Ciprofloxacin 500mg Tablet (Generic)    92%   │  │
│  │ ○ TPU05235 - Ciprofloxacin 500mg Film-coated Tab     88%   │  │
│  │ ○ TPU05236 - Ciprofloxacin HCl 500mg Tablet          85%   │  │
│  │                                                             │  │
│  │ Selected: TPU05234                                          │  │
│  │ Confidence: [========·] 92%                                 │  │
│  │ Mapping Source: [Manual ▼]                                 │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
│                    [Cancel]  [Save Mapping]  [Verify]              │
└────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 FLOW 06.4: Ministry Export with TMT

### Export Druglist with TMT Codes

```sql
-- Ministry Export: Druglist with TMT
SELECT
    d.drug_code as "DRUG_CODE",
    d.trade_name as "DRUG_NAME",
    dg.generic_name as "GENERIC_NAME",
    d.strength as "STRENGTH",
    d.dosage_form as "DOSAGE_FORM",
    c.company_name as "MANUFACTURER",
    tm.tmt_code as "TMT_CODE",
    tm.tmt_level as "TMT_LEVEL",
    tm.nc24_code as "NC24_CODE",
    CASE
        WHEN tm.confidence >= 0.9 THEN 'HIGH'
        WHEN tm.confidence >= 0.75 THEN 'MEDIUM'
        ELSE 'LOW'
    END as "MAPPING_QUALITY",
    d.is_active as "IS_ACTIVE"
FROM drugs d
JOIN drug_generics dg ON d.generic_id = dg.id
LEFT JOIN companies c ON d.manufacturer_id = c.id
LEFT JOIN tmt_mappings tm ON d.id = tm.drug_id AND tm.is_active = true
WHERE d.is_active = true
ORDER BY d.drug_code;
```

---

## 📊 Key Performance Indicators

### TMT Mapping Quality Metrics

```sql
-- Mapping quality by level
SELECT
    tmt_level,
    COUNT(*) as mapping_count,
    ROUND(AVG(confidence) * 100, 2) as avg_confidence,
    COUNT(CASE WHEN mapping_source = 'auto' THEN 1 END) as auto_mapped,
    COUNT(CASE WHEN mapping_source = 'manual' THEN 1 END) as manual_mapped,
    COUNT(CASE WHEN mapping_source = 'verified' THEN 1 END) as verified
FROM tmt_mappings
WHERE is_active = true
GROUP BY tmt_level;
```

**Target Goals:**
```
✅ Mapping Coverage: > 95%
✅ High Confidence (>0.9): > 85%
✅ Verified Mappings: > 50%
✅ Auto-mapped: > 70%
```

---

## ✅ Implementation Checklist

### Database
- [x] `tmt_concepts` table (25,991 concepts)
- [x] `tmt_mappings` table
- [x] `his_drug_master` table
- [x] Import scripts for TMT data
- [x] Mapping algorithm

### Backend API (To Do)
- [ ] GET `/api/tmt/concepts` - Search TMT concepts
- [ ] POST `/api/tmt/map` - Create drug-TMT mapping
- [ ] PUT `/api/tmt/verify/:id` - Verify mapping
- [ ] GET `/api/tmt/unmapped` - Get unmapped drugs
- [ ] GET `/api/tmt/stats` - Mapping statistics
- [ ] POST `/api/tmt/sync-his` - Sync from HIS

### Frontend (To Do)
- [ ] TMT mapping dashboard
- [ ] Drug-TMT mapping interface
- [ ] Search TMT concepts
- [ ] Verify mappings
- [ ] Compliance report

---

## 📞 Related Documentation

- **[FLOW_07_Ministry_Reporting.md](./FLOW_07_Ministry_Reporting.md)** - Ministry Reports
- **[prisma/schema.prisma](../../prisma/schema.prisma)** - TMT tables
- **Ministry TMT Documentation**: https://tmt.moph.go.th

---

**Status**: ✅ Complete - 25,991 TMT concepts loaded
**Last Updated**: 2025-01-11

*Created with ❤️ for INVS Modern Team*
