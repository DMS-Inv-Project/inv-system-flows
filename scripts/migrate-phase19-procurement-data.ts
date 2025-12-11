/**
 * Phase 19: Procurement Data Migration
 *
 * Migrate from MySQL:
 * 1. drug_gn.LAST_BUY_COST → drug_generics.last_buy_cost
 * 2. drug_gn.LAST_VENDOR_CODE → drug_generics.last_vendor_code
 * 3. drug_gn.HOSP_LIST → drug_generics.hosp_list
 * 4. drug_vn.24DIGIT → drugs.nc24_code
 *
 * Run: npx tsx scripts/migrate-phase19-procurement-data.ts
 */

import { PrismaClient } from '@prisma/client';
import mysql from 'mysql2/promise';

const prisma = new PrismaClient();

async function main() {
  console.log('🚀 Phase 19: Procurement Data Migration...\n');
  console.log('═══════════════════════════════════════════════════════════');
  console.log('   Migrate: last_buy_cost, hosp_list, nc24_code');
  console.log('═══════════════════════════════════════════════════════════\n');

  const mysqlConn = await mysql.createConnection({
    host: 'localhost',
    port: 3307,
    user: 'invs_user',
    password: 'invs123',
    database: 'invs_banpong'
  });

  try {
    // ==========================================
    // Part 1: drug_generics procurement data
    // ==========================================
    console.log('📋 Part 1: Drug Generics procurement data...\n');

    const [gnRows] = await mysqlConn.execute<mysql.RowDataPacket[]>(`
      SELECT WORKING_CODE, LAST_BUY_COST, LAST_VENDOR_CODE, HOSP_LIST
      FROM drug_gn
      WHERE LAST_BUY_COST > 0 OR HOSP_LIST IS NOT NULL
    `);
    console.log(`   Found ${gnRows.length} records from MySQL drug_gn\n`);

    let gnUpdated = 0;
    let gnCostUpdated = 0;
    let gnHospUpdated = 0;

    for (const row of gnRows) {
      const code = row.WORKING_CODE?.trim();
      if (!code) continue;

      const updateData: any = {};

      if (row.LAST_BUY_COST > 0) {
        updateData.lastBuyCost = row.LAST_BUY_COST;
        gnCostUpdated++;
      }
      if (row.LAST_VENDOR_CODE) {
        updateData.lastVendorCode = row.LAST_VENDOR_CODE.trim();
      }
      if (row.HOSP_LIST) {
        updateData.hospList = row.HOSP_LIST;
        gnHospUpdated++;
      }

      if (Object.keys(updateData).length > 0) {
        try {
          await prisma.drugGeneric.update({
            where: { workingCode: code },
            data: updateData
          });
          gnUpdated++;
        } catch (e) {
          // Record not found in PostgreSQL, skip
        }
      }
    }

    console.log(`   ✅ Updated drug_generics: ${gnUpdated}`);
    console.log(`      - last_buy_cost: ${gnCostUpdated}`);
    console.log(`      - hosp_list: ${gnHospUpdated}\n`);

    // ==========================================
    // Part 2: drugs nc24_code (24DIGIT)
    // ==========================================
    console.log('📋 Part 2: Drugs NC24 code (24DIGIT)...\n');

    const [vnRows] = await mysqlConn.execute<mysql.RowDataPacket[]>(`
      SELECT TRADE_CODE, \`24DIGIT\`
      FROM drug_vn
      WHERE \`24DIGIT\` IS NOT NULL AND \`24DIGIT\` != ''
    `);
    console.log(`   Found ${vnRows.length} records with 24DIGIT from MySQL drug_vn\n`);

    let vnUpdated = 0;

    for (const row of vnRows) {
      const code = row.TRADE_CODE?.trim();
      const nc24 = row['24DIGIT']?.trim();
      if (!code || !nc24) continue;

      try {
        await prisma.drug.update({
          where: { drugCode: code },
          data: { nc24Code: nc24 }
        });
        vnUpdated++;
      } catch (e) {
        // Record not found in PostgreSQL, skip
      }
    }

    console.log(`   ✅ Updated drugs.nc24_code: ${vnUpdated}\n`);

    // ==========================================
    // Summary
    // ==========================================
    console.log('═══════════════════════════════════════════════════════════');
    console.log('   📊 PHASE 19 COMPLETE');
    console.log('═══════════════════════════════════════════════════════════\n');

    // Verify
    const gnStats = await prisma.drugGeneric.aggregate({
      _count: { lastBuyCost: true, hospList: true }
    });
    const vnStats = await prisma.drug.aggregate({
      _count: { nc24Code: true }
    });

    console.log('   Final counts:');
    console.log(`      drug_generics.last_buy_cost: ${gnStats._count.lastBuyCost}`);
    console.log(`      drug_generics.hosp_list: ${gnStats._count.hospList}`);
    console.log(`      drugs.nc24_code: ${vnStats._count.nc24Code}`);
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
    console.log('✅ Phase 19 completed!\n');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Phase 19 failed:', error);
    process.exit(1);
  });
