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

// MySQL connection config
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
    const notFoundDrugs: string[] = [];
    const wrongLevelDrugs: { code: string; level: string }[] = [];

    for (const drug of drugsWithTmt) {
      const tmtIdStr = BigInt(drug.TMTID).toString();

      // Check if TMTID exists
      if (!tmtMap.has(tmtIdStr)) {
        tmtNotFound++;
        continue;
      }

      const tmtLevel = tmtMap.get(tmtIdStr);

      // Check if TMT level is TPU
      if (tmtLevel !== 'TPU') {
        wrongLevel++;
        wrongLevelDrugs.push({ code: drug.TRADE_CODE, level: tmtLevel || 'unknown' });
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
        notFoundDrugs.push(drug.TRADE_CODE);
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

    console.log(`   Drugs with TMT TPU: ${drugsWithTpu}/${totalDrugs} (${coverage}%)\n`);

    // Step 6: Show sample mappings
    console.log('📋 Sample Mappings (First 10):');
    const samples = await prisma.drug.findMany({
      where: { tmtTpuId: { not: null } },
      select: {
        drugCode: true,
        tradeName: true,
        tmtTpuId: true
      },
      take: 10
    });

    for (const drug of samples) {
      const tmtConcept = await prisma.tmtConcept.findUnique({
        where: { tmtId: drug.tmtTpuId! },
        select: {
          tmtId: true,
          level: true,
          fsn: true,
          preferredTerm: true
        }
      });

      const fsnPreview = tmtConcept?.fsn ? tmtConcept.fsn.substring(0, 80) : 'N/A';
      console.log(`   ${drug.drugCode}: ${drug.tradeName?.substring(0, 40)}`);
      console.log(`   └─ TMT ${tmtConcept?.tmtId}: ${fsnPreview}...`);
    }

    // Step 7: Show issues (if any)
    if (wrongLevel > 0) {
      console.log(`\n⚠️  Drugs with wrong TMT level (first 10):`);
      wrongLevelDrugs.slice(0, 10).forEach(d => {
        console.log(`   - ${d.code} (level: ${d.level})`);
      });
      if (wrongLevelDrugs.length > 10) {
        console.log(`   ... and ${wrongLevelDrugs.length - 10} more`);
      }
    }

    if (notFoundInNewDb > 0) {
      console.log(`\n💡 ${notFoundInNewDb} drugs from legacy system not found in new database`);
      console.log(`   (This is normal - old drugs may not have been migrated)`);
    }

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
