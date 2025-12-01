/**
 * Phase 10: Import Drug Components
 * ส่วนประกอบยา (สารออกฤทธิ์)
 *
 * Source: MySQL drug_compos table (736 records)
 * Target: PostgreSQL drug_components table
 *
 * Maps:
 * - WORKING_CODE → genericId (FK to drug_generics)
 * - COMPOS_NAME → componentName
 * - COMPOS_CODE → sequence (ordering)
 * - TMTID → tmtConceptId (FK to tmt_concepts)
 *
 * Run: npx tsx scripts/migrate-phase10-drug-components.ts
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

interface DrugComposRow {
  WORKING_CODE: string | null;
  COMPOS_NAME: string | null;
  COMPOS_CODE: number;
  TMTID: number | null;
}

async function main() {
  console.log('🚀 Phase 10: Importing Drug Components...\n');

  const mysqlConn = await mysql.createConnection(mysqlConfig);

  try {
    // ===========================================
    // Step 1: Build lookup maps
    // ===========================================
    console.log('📋 Step 1/3: Building lookup maps...');

    // Map working_code → generic.id
    const generics = await prisma.drugGeneric.findMany({
      select: { id: true, workingCode: true }
    });
    const workingCodeToGenericId = new Map<string, bigint>();
    for (const g of generics) {
      workingCodeToGenericId.set(g.workingCode.trim(), g.id);
    }
    console.log(`   - Generic codes mapped: ${workingCodeToGenericId.size}`);

    // Map tmtId → tmt_concepts.id
    const tmtConcepts = await prisma.tmtConcept.findMany({
      select: { id: true, tmtId: true }
    });
    const tmtIdToConceptId = new Map<string, bigint>();
    for (const t of tmtConcepts) {
      tmtIdToConceptId.set(t.tmtId, t.id);
    }
    console.log(`   - TMT concepts mapped: ${tmtIdToConceptId.size}`);
    console.log('   ✅ Lookup maps ready\n');

    // ===========================================
    // Step 2: Fetch data from MySQL
    // ===========================================
    console.log('📋 Step 2/3: Fetching data from MySQL...');
    const [components] = await mysqlConn.query<DrugComposRow[]>(`
      SELECT
        WORKING_CODE,
        COMPOS_NAME,
        COMPOS_CODE,
        TMTID
      FROM drug_compos
      ORDER BY WORKING_CODE, COMPOS_CODE
    `);
    console.log(`   ✅ Fetched ${components.length} component records\n`);

    // ===========================================
    // Step 3: Import to PostgreSQL
    // ===========================================
    console.log('📋 Step 3/3: Importing to PostgreSQL...');

    let imported = 0;
    let skipped = 0;
    let errors = 0;
    const errorLog: string[] = [];

    for (const row of components) {
      try {
        // Resolve genericId
        if (!row.WORKING_CODE) {
          skipped++;
          continue;
        }

        const workingCode = row.WORKING_CODE.trim();
        const genericId = workingCodeToGenericId.get(workingCode);

        if (!genericId) {
          skipped++;
          if (skipped <= 10) {
            errorLog.push(`Skipped: No generic found for WORKING_CODE=${workingCode}`);
          }
          continue;
        }

        // Resolve tmtConceptId (optional)
        let tmtConceptId: bigint | null = null;
        if (row.TMTID) {
          tmtConceptId = tmtIdToConceptId.get(String(row.TMTID)) || null;
        }

        // Parse component name and strength
        const componentName = row.COMPOS_NAME?.trim() || `Component-${row.COMPOS_CODE}`;

        // Try to extract strength from name (e.g., "FENTANYL 100 MCG/2 ML")
        let strength: string | null = null;
        let strengthUnit: string | null = null;
        const strengthMatch = componentName.match(/(\d+(?:\.\d+)?)\s*(MCG|MG|G|ML|%|IU|UNIT)/i);
        if (strengthMatch) {
          strength = strengthMatch[1];
          strengthUnit = strengthMatch[2].toUpperCase();
        }

        // Upsert component
        await prisma.drugComponent.upsert({
          where: {
            id: BigInt(row.COMPOS_CODE) // Use COMPOS_CODE as unique identifier
          },
          create: {
            id: BigInt(row.COMPOS_CODE),
            genericId: genericId,
            componentName: componentName,
            strength: strength,
            strengthUnit: strengthUnit,
            tmtConceptId: tmtConceptId,
            sequence: row.COMPOS_CODE,
            isActive: true,
          },
          update: {
            genericId: genericId,
            componentName: componentName,
            strength: strength,
            strengthUnit: strengthUnit,
            tmtConceptId: tmtConceptId,
            sequence: row.COMPOS_CODE,
          }
        });

        imported++;

        // Progress update
        if (imported % 100 === 0) {
          process.stdout.write(`\r   Progress: ${imported} records imported`);
        }
      } catch (err: any) {
        errors++;
        if (errors <= 10) {
          errorLog.push(`Error: ${row.WORKING_CODE} - ${err.message}`);
        }
      }
    }

    console.log(`\r   Progress: ${imported} records imported\n`);

    // ===========================================
    // Summary
    // ===========================================
    console.log('═══════════════════════════════════════');
    console.log('✅ Phase 10 Migration Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   Source records:      ${components.length.toLocaleString()}`);
    console.log(`   Imported:            ${imported.toLocaleString()}`);
    console.log(`   Skipped (no match):  ${skipped.toLocaleString()}`);
    console.log(`   Errors:              ${errors.toLocaleString()}`);
    console.log('═══════════════════════════════════════');

    if (errorLog.length > 0) {
      console.log('\n⚠️  Sample issues:');
      errorLog.forEach(log => console.log(`   - ${log}`));
    }

    // Verify final count
    const finalCount = await prisma.drugComponent.count();
    console.log(`\n📊 Final count in drug_components: ${finalCount.toLocaleString()}`);

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
