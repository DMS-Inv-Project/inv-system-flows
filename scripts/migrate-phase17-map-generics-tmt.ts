/**
 * Phase 17: Map DrugGenerics to TMT Concepts using GPUID from MySQL
 *
 * Strategy:
 * 1. Read GPUID from MySQL drug_gn table
 * 2. Match with tmt_concepts.tmt_id (GPU level)
 * 3. Update drug_generics with tmt_gpu_id
 *
 * Run: npx tsx scripts/migrate-phase17-map-generics-tmt.ts
 */

import { PrismaClient } from '@prisma/client';
import mysql from 'mysql2/promise';

const prisma = new PrismaClient();

async function main() {
  console.log('🚀 Phase 17: Mapping Drug Generics to TMT using GPUID...\n');
  console.log('═══════════════════════════════════════════════════════════');
  console.log('   Drug Generics → TMT GPU (via MySQL GPUID)');
  console.log('═══════════════════════════════════════════════════════════\n');

  // Connect to MySQL
  const mysqlConn = await mysql.createConnection({
    host: 'localhost',
    port: 3307,
    user: 'invs_user',
    password: 'invs123',
    database: 'invs_banpong'
  });

  try {
    // Get GPUID mapping from MySQL
    console.log('📋 Loading GPUID from MySQL drug_gn...');
    const [rows] = await mysqlConn.execute<mysql.RowDataPacket[]>(`
      SELECT WORKING_CODE, DRUG_NAME, GPUID
      FROM drug_gn
      WHERE GPUID IS NOT NULL AND GPUID > 0
    `);
    console.log(`   Found ${rows.length} records with GPUID\n`);

    // Build GPUID lookup map
    const gpuidMap = new Map<string, number>();
    for (const row of rows) {
      gpuidMap.set(row.WORKING_CODE.trim(), row.GPUID);
    }

    // Get TMT concepts (GPU level) indexed by tmt_id
    console.log('📋 Loading TMT Concepts (GPU level)...');
    const tmtGpuConcepts = await prisma.tmtConcept.findMany({
      where: { level: 'GPU' },
      select: { id: true, tmtId: true, fsn: true }
    });
    console.log(`   Found ${tmtGpuConcepts.length} GPU concepts\n`);

    // Build TMT lookup by tmt_id
    const tmtByTmtId = new Map<bigint, { id: bigint; fsn: string }>();
    for (const tmt of tmtGpuConcepts) {
      tmtByTmtId.set(tmt.tmtId, { id: tmt.id, fsn: tmt.fsn || '' });
    }

    // Get all drug generics
    console.log('📋 Loading Drug Generics...');
    const drugGenerics = await prisma.drugGeneric.findMany({
      select: { id: true, workingCode: true, drugName: true }
    });
    console.log(`   Found ${drugGenerics.length} generics\n`);

    // Match using GPUID
    console.log('🔗 Matching via GPUID...');
    let matched = 0;
    let noGpuid = 0;
    let gpuidNotFound = 0;
    const matchedSamples: Array<{ code: string; drug: string; tmt: string }> = [];
    const notFoundSamples: Array<{ code: string; drug: string; gpuid: number }> = [];

    for (const drug of drugGenerics) {
      const gpuid = gpuidMap.get(drug.workingCode);

      if (!gpuid) {
        noGpuid++;
        continue;
      }

      // Find TMT by GPUID (tmt_id)
      const tmt = tmtByTmtId.get(BigInt(gpuid));

      if (tmt) {
        await prisma.drugGeneric.update({
          where: { id: drug.id },
          data: { tmtGpId: tmt.id }
        });
        matched++;

        if (matchedSamples.length < 15) {
          matchedSamples.push({
            code: drug.workingCode,
            drug: drug.drugName,
            tmt: tmt.fsn
          });
        }
      } else {
        gpuidNotFound++;
        if (notFoundSamples.length < 10) {
          notFoundSamples.push({
            code: drug.workingCode,
            drug: drug.drugName,
            gpuid
          });
        }
      }
    }

    // Results
    console.log(`\n   ✅ Matched via GPUID:      ${matched}`);
    console.log(`   ⚠️  No GPUID in MySQL:      ${noGpuid}`);
    console.log(`   ❌ GPUID not in TMT:        ${gpuidNotFound}`);
    console.log(`\n   📊 Coverage: ${(matched / drugGenerics.length * 100).toFixed(2)}%`);

    // Show matched samples
    console.log('\n   📝 Matched samples:');
    for (const m of matchedSamples) {
      console.log(`      ${m.code}: ${m.drug.substring(0, 35).padEnd(35)} → ${m.tmt.substring(0, 40)}`);
    }

    // Show GPUID not found in TMT
    if (notFoundSamples.length > 0) {
      console.log('\n   📝 GPUID not found in TMT (samples):');
      for (const s of notFoundSamples) {
        console.log(`      ${s.code}: ${s.drug} (GPUID: ${s.gpuid})`);
      }
    }

    console.log('\n═══════════════════════════════════════════════════════════');
    console.log('   📊 PHASE 17 COMPLETE (GPUID Matching)');
    console.log('═══════════════════════════════════════════════════════════\n');

  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    await mysqlConn.end();
    await prisma.$disconnect();
  }
}

main()
  .then(() => {
    console.log('✅ Phase 17 completed!\n');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Phase 17 failed:', error);
    process.exit(1);
  });
