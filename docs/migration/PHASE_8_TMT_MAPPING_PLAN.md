# Phase 8: Map Existing Drugs to TMT Concepts - Detailed Plan

**Status**: 🔜 Not Started
**Estimated Time**: 5-10 minutes
**Complexity**: Medium

---

## 📋 Overview

Phase 8 จะทำการ **map ยาการค้า (Trade Drugs)** ที่มีอยู่ในระบบเดิมเข้ากับ **TMT concepts** ที่เพิ่ง import เสร็จใน Phase 7

### จุดประสงค์
1. นำ TMT mapping ที่มีอยู่แล้วในระบบเดิม (MySQL) มาใช้ในระบบใหม่ (PostgreSQL)
2. เชื่อมโยงยาการค้าแต่ละรายการกับ TMT TPU (Trade Product + Unit) เพื่อใช้ในการ:
   - รายงานกระทรวง (Ministry Reporting)
   - มาตรฐานรหัสยา
   - เชื่อมต่อกับระบบอื่น (HIS, NHSO)
   - การวิเคราะห์ข้อมูล

---

## 📊 Current Status

### ฐานข้อมูลเดิม (MySQL - invs_banpong)
```
Table: drug_vn
- Total drugs: 7,258 รายการ
- Has TMTID: 3,881 รายการ (53.47%)
- No TMTID: 3,377 รายการ (46.53%)
- TMTID Range: 0 - 9,401,859
```

### ฐานข้อมูลใหม่ (PostgreSQL - invs_modern)
```
Table: drugs
- Total drugs: 1,169 รายการ
- Has tmt_tpu_id: 0 รายการ (0%)
- Has tmt_tp_id: 0 รายการ (0%)
```

### TMT Concepts Available
```
Table: tmt_concepts
- Total concepts: 76,904 รายการ
- TPU level: 29,027 รายการ (Trade Product + Unit)
- TP level: 27,360 รายการ (Trade Product)
```

---

## 🔍 Data Mapping Analysis

### 1. TMTID ชี้ไปที่ TPU Level

จากการตรวจสอบตัวอย่าง TMTID ทั้งหมดชี้ไปที่ **TPU (Trade Product + Unit)** ซึ่งเป็น level ที่ละเอียดที่สุด:

```sql
-- ตัวอย่าง TMTID จากระบบเดิม
TRADE_CODE: 10
TRADE_NAME: FUNGIZONE (AMPHOTERICIN B 50 MG)
TMTID: 755730

-- ตรงกับ TMT Concept
tmt_id: 755730
level: TPU
fsn: AMPHOTRET (BHARAT SERUMS AND VACCINES, INDIA)
     (amphotericin b 50 mg) powder for injection/infusion, 1 vial
```

### 2. Matching Strategy

**Primary Key Matching**: `drug_vn.TRADE_CODE` = `drugs.drug_code`

```
MySQL Legacy          PostgreSQL Modern
─────────────────     ─────────────────
drug_vn               drugs
├─ TRADE_CODE    →    ├─ drug_code
├─ TRADE_NAME    →    ├─ trade_name
├─ WORKING_CODE       ├─ generic_id
└─ TMTID         →    └─ tmt_tpu_id (NULL → update)
```

### 3. Expected Coverage

จากการวิเคราะห์:
- ยาในระบบใหม่: **1,169 รายการ**
- ยาในระบบเดิมที่มี TMTID: **3,881 รายการ** (53.47%)
- คาดว่า match ได้: **~50-60%** ของยาในระบบใหม่ (~600-700 รายการ)

**หมายเหตุ**: ไม่ได้ 100% เพราะ:
- ระบบใหม่อาจมียาใหม่ที่ไม่มีในระบบเดิม
- ระบบเดิมมียาเก่าที่ไม่ได้นำมาในระบบใหม่
- บางรายการอาจไม่มี TMTID ในระบบเดิม

---

## 🎯 Migration Strategy

### Step 1: Validate Data
ตรวจสอบข้อมูลก่อน migrate:
```sql
-- 1. ตรวจสอบจำนวน drugs ที่จะ match ได้
SELECT COUNT(DISTINCT dv.TRADE_CODE)
FROM drug_vn dv
INNER JOIN drugs d ON dv.TRADE_CODE = d.drug_code
WHERE dv.TMTID IS NOT NULL;

-- 2. ตรวจสอบว่า TMTID ทั้งหมดมีใน tmt_concepts หรือไม่
SELECT COUNT(DISTINCT dv.TMTID)
FROM drug_vn dv
WHERE dv.TMTID IS NOT NULL
  AND dv.TMTID NOT IN (SELECT tmt_id FROM tmt_concepts);
```

### Step 2: Map TPU Level
Update `drugs.tmt_tpu_id` จาก `drug_vn.TMTID`:
```typescript
// scripts/migrate-phase8-map-tmt.ts
const [drugsWithTmt] = await mysqlConn.query(`
  SELECT
    TRADE_CODE,
    TRADE_NAME,
    TMTID
  FROM drug_vn
  WHERE TMTID IS NOT NULL
    AND TMTID > 0
  ORDER BY TRADE_CODE
`);

for (const drug of drugsWithTmt) {
  // Verify TMTID exists in tmt_concepts
  const tmtConcept = await prisma.tmtConcept.findUnique({
    where: { tmtId: BigInt(drug.TMTID) }
  });

  if (tmtConcept && tmtConcept.level === 'TPU') {
    // Update drugs.tmt_tpu_id
    await prisma.drug.updateMany({
      where: { drugCode: drug.TRADE_CODE },
      data: { tmtTpuId: BigInt(drug.TMTID) }
    });
  }
}
```

### Step 3: Derive TP Level (Optional)
หาก TPU มี parent TP, อาจจะ derive TP ได้:
```sql
-- Update tmt_tp_id from TPU's parent TP
-- (ต้องมีการ link parent relationship ใน TMT ก่อน)
UPDATE drugs d
SET tmt_tp_id = (
  SELECT parent_tp_id
  FROM tmt_concepts
  WHERE tmt_id = d.tmt_tpu_id
    AND level = 'TPU'
)
WHERE d.tmt_tpu_id IS NOT NULL;
```

**หมายเหตุ**: ขั้นตอนนี้ต้องการข้อมูล parent relationship ระหว่าง TPU-TP ซึ่งอาจต้อง import เพิ่มเติม

---

## 📁 Implementation Plan

### File Structure
```
scripts/
├─ migrate-phase8-map-tmt.ts         (Main script)
└─ migrate-phase8-verify-tmt.ts      (Verification)

docs/migration/
├─ PHASE_8_TMT_MAPPING_PLAN.md       (This file)
└─ PHASE_8_TMT_MAPPING_SUMMARY.md    (After completion)
```

### Script Template
```typescript
/**
 * Phase 8: Map Existing Drugs to TMT Concepts
 *
 * Map drug_vn.TMTID → drugs.tmt_tpu_id
 *
 * Expected Coverage: ~50-60% of drugs (600-700 out of 1,169)
 *
 * Run: npx tsx scripts/migrate-phase8-map-tmt.ts
 */

import { PrismaClient } from '@prisma/client';
import mysql from 'mysql2/promise';

const prisma = new PrismaClient();

const mysqlConfig = {
  host: 'localhost',
  port: 3307,
  user: 'invs_user',
  password: 'invs123',
  database: 'invs_banpong',
  charset: 'utf8mb4'
};

async function main() {
  console.log('🚀 Phase 8: Mapping Drugs to TMT Concepts...\n');

  const mysqlConn = await mysql.createConnection(mysqlConfig);

  try {
    // Step 1: Load drugs with TMTID from MySQL
    console.log('📋 Step 1: Loading drugs with TMTID from legacy system...');
    const [drugsWithTmt] = await mysqlConn.query<any[]>(`
      SELECT
        TRADE_CODE,
        TRADE_NAME,
        WORKING_CODE,
        TMTID
      FROM drug_vn
      WHERE TMTID IS NOT NULL
        AND TMTID > 0
      ORDER BY TRADE_CODE
    `);

    console.log(`   Found ${drugsWithTmt.length} drugs with TMTID\n`);

    // Step 2: Validate TMT concepts exist
    console.log('🔍 Step 2: Validating TMT concepts...');
    const uniqueTmtIds = [...new Set(drugsWithTmt.map(d => BigInt(d.TMTID)))];
    const tmtConceptsInDb = await prisma.tmtConcept.findMany({
      where: { tmtId: { in: uniqueTmtIds } },
      select: { tmtId: true, level: true }
    });

    const tmtMap = new Map(tmtConceptsInDb.map(t => [t.tmtId.toString(), t.level]));
    console.log(`   Found ${tmtConceptsInDb.length}/${uniqueTmtIds.length} TMT concepts in database\n`);

    // Step 3: Map drugs to TMT
    console.log('💊 Step 3: Mapping drugs to TMT concepts...');
    let updatedCount = 0;
    let notFoundInNewDb = 0;
    let tmtNotFound = 0;
    let wrongLevel = 0;

    for (const drug of drugsWithTmt) {
      const tmtIdStr = BigInt(drug.TMTID).toString();

      // Check if TMTID exists and is TPU level
      if (!tmtMap.has(tmtIdStr)) {
        tmtNotFound++;
        continue;
      }

      const tmtLevel = tmtMap.get(tmtIdStr);
      if (tmtLevel !== 'TPU') {
        wrongLevel++;
        continue;
      }

      // Update drug in PostgreSQL
      const result = await prisma.drug.updateMany({
        where: { drugCode: drug.TRADE_CODE },
        data: { tmtTpuId: BigInt(drug.TMTID) }
      });

      if (result.count > 0) {
        updatedCount++;
        if (updatedCount % 100 === 0) {
          process.stdout.write(`\r   Progress: ${updatedCount} drugs mapped`);
        }
      } else {
        notFoundInNewDb++;
      }
    }

    console.log(`\n   ✅ Successfully mapped ${updatedCount} drugs\n`);

    // Step 4: Summary
    console.log('═══════════════════════════════════════');
    console.log('✅ Phase 8 TMT Mapping Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   Drugs with TMTID (legacy):  ${drugsWithTmt.length.toLocaleString()}`);
    console.log(`   Successfully mapped:         ${updatedCount.toLocaleString()}`);
    console.log(`   Not found in new DB:         ${notFoundInNewDb.toLocaleString()}`);
    console.log(`   TMT not in database:         ${tmtNotFound.toLocaleString()}`);
    console.log(`   Wrong TMT level:             ${wrongLevel.toLocaleString()}`);
    console.log('═══════════════════════════════════════\n');

    // Step 5: Verification
    console.log('🔍 Verification:');
    const drugsWithTpu = await prisma.drug.count({
      where: { tmtTpuId: { not: null } }
    });
    const totalDrugs = await prisma.drug.count();
    const coverage = (drugsWithTpu / totalDrugs * 100).toFixed(2);

    console.log(`   Drugs with TMT TPU: ${drugsWithTpu}/${totalDrugs} (${coverage}%)`);

    // Show sample mappings
    console.log('\n📋 Sample Mappings:');
    const samples = await prisma.drug.findMany({
      where: { tmtTpuId: { not: null } },
      include: {
        tmtTpu: {
          select: {
            tmtId: true,
            level: true,
            fsn: true,
            preferredTerm: true
          }
        }
      },
      take: 5
    });

    samples.forEach(drug => {
      console.log(`   ${drug.drugCode}: ${drug.tradeName}`);
      console.log(`   └─ TMT ${drug.tmtTpu?.tmtId}: ${drug.tmtTpu?.preferredTerm || drug.tmtTpu?.fsn}`);
    });

  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    await mysqlConn.end();
    await prisma.$disconnect();
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
```

---

## ✅ Success Criteria

1. **Coverage**: ได้ TMT mapping อย่างน้อย **50%** ของยาในระบบใหม่
2. **Accuracy**: TMTID ที่ map ต้องมีอยู่จริงใน `tmt_concepts` และเป็น level TPU
3. **Verification**: ตรวจสอบ sample drugs ว่า map ถูกต้อง
4. **Documentation**: สร้าง summary report หลัง migration เสร็จ

---

## 📊 Expected Results

### Before Migration
```
drugs table:
- Total: 1,169 drugs
- With TMT TPU: 0 (0%)
- With TMT TP: 0 (0%)
```

### After Migration (Estimated)
```
drugs table:
- Total: 1,169 drugs
- With TMT TPU: ~600-700 (50-60%)
- With TMT TP: 0 (0%) - Optional in future
```

---

## 🚧 Potential Issues

### 1. TRADE_CODE Mismatch
**Problem**: `drug_vn.TRADE_CODE` อาจไม่ตรงกับ `drugs.drug_code`

**Solutions**:
- ใช้ `WORKING_CODE` เป็น fallback match กับ `generic_id`
- ใช้ `TRADE_NAME` similarity matching
- Manual mapping table สำหรับ special cases

### 2. TMTID Not Found
**Problem**: TMTID บางตัวอาจไม่มีใน `tmt_concepts` (นอกช่วง 0-9,401,859)

**Solutions**:
- Skip และ log รายการที่ไม่พบ
- Import TMT concepts เพิ่มเติมถ้าจำเป็น

### 3. Wrong TMT Level
**Problem**: TMTID บางตัวอาจไม่ใช่ TPU level

**Solutions**:
- Validate level ก่อน update
- Log รายการที่ level ไม่ถูกต้อง

---

## 🔄 Future Enhancements

### Phase 8B: Derive Parent Relationships (Optional)
หากมีข้อมูล parent relationship ใน TMT:
```
TPU → TP → GPU → GP → VTM
```

สามารถ derive ได้:
- `drugs.tmt_tp_id` from `tmt_tpu.parent_tp_id`
- `drugs.tmt_gpu_id` from parent chain
- Link กับ `drug_generics.tmt_vtm_id`, `tmt_gp_id`

### Phase 8C: Manual Mapping UI (Future)
สร้าง UI สำหรับ manual mapping สำหรับยาที่ยังไม่มี TMT:
- Search TMT concepts
- Preview TMT details
- Bulk assign
- Export/Import mapping file

---

## 📚 Related Documentation

### Dependencies
- ✅ Phase 1-4: Master data migration
- ✅ Phase 5: Lookup tables
- ✅ Phase 6: String to FK mapping
- ✅ Phase 7: TMT concepts import

### References
- `PHASE_7_TMT_SUMMARY.md` - TMT concepts structure
- `FLOW_06_TMT_Integration.md` - TMT integration flow
- `FLOW_07_Ministry_Reporting.md` - Ministry export requirements

---

## 🎯 Next Steps

### To Start Phase 8:
1. Review this plan
2. Create migration script: `scripts/migrate-phase8-map-tmt.ts`
3. Test on sample data first
4. Run full migration
5. Verify results
6. Document findings

### Command to Run:
```bash
# Create script
touch scripts/migrate-phase8-map-tmt.ts

# Run migration
npx tsx scripts/migrate-phase8-map-tmt.ts

# Verify results
npm run db:studio  # Check drugs table
```

---

**Prepared By**: Claude Code
**Date**: 2025-01-22
**Version**: 1.0
**Status**: 📋 Planning Complete - Ready for Implementation
