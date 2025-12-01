/**
 * Phase 13: Import ALL Drugs (including hidden and orphaned)
 * ยาทั้งหมดจาก drug_vn รวมถึงยาที่ซ่อนและยาที่ไม่มี generic
 *
 * Source: MySQL drug_vn table (7,258 records)
 * Target: PostgreSQL drugs table
 *
 * Features:
 * - Import ALL drugs (not just active)
 * - Allow null genericId for orphaned drugs
 * - Track isActive based on HIDE flag
 * - Import additional fields (TMTID, ATC, etc.)
 *
 * Run: npx tsx scripts/migrate-phase13-all-drugs.ts
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

interface DrugVnRow {
  TRADE_CODE: string;
  WORKING_CODE: string | null;
  TRADE_NAME: string | null;
  VENDOR_CODE: string | null;
  MANUFAC_CODE: string | null;
  PACK_RATIO: number | null;
  REGIST_NO: string | null;
  STD_CODE: string | null;
  GENERIC_CODE: string | null;
  BAR_CODE: string | null;
  TMTID: number | null;
  ATC: string | null;
  HIDE: string | null;
  SALE_UNIT_PRICE: number | null;
  BUY_UNIT_COST: number | null;
  NOTE: string | null;
}

async function main() {
  console.log('🚀 Phase 13: Importing ALL Drugs...\\n');

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

    // Map company_code → company.id
    const companies = await prisma.company.findMany({
      select: { id: true, companyCode: true }
    });
    const companyCodeToId = new Map<string, bigint>();
    for (const c of companies) {
      companyCodeToId.set(c.companyCode.trim(), c.id);
      // Also try without leading zeros
      const numericCode = parseInt(c.companyCode.trim(), 10);
      if (!isNaN(numericCode)) {
        companyCodeToId.set(String(numericCode), c.id);
      }
    }
    console.log(`   - Company codes mapped: ${companyCodeToId.size}`);
    console.log('   ✅ Lookup maps ready\\n');

    // ===========================================
    // Step 2: Fetch data from MySQL
    // ===========================================
    console.log('📋 Step 2/3: Fetching data from MySQL...');
    const [drugs] = await mysqlConn.query<DrugVnRow[]>(`
      SELECT
        TRADE_CODE,
        WORKING_CODE,
        TRADE_NAME,
        VENDOR_CODE,
        MANUFAC_CODE,
        PACK_RATIO,
        REGIST_NO,
        STD_CODE,
        GENERIC_CODE,
        BAR_CODE,
        TMTID,
        ATC,
        HIDE,
        SALE_UNIT_PRICE,
        BUY_UNIT_COST,
        NOTE
      FROM drug_vn
      ORDER BY TRADE_CODE
    `);
    console.log(`   ✅ Fetched ${drugs.length} drug records\\n`);

    // ===========================================
    // Step 3: Import to PostgreSQL
    // ===========================================
    console.log('📋 Step 3/3: Importing to PostgreSQL...');

    let imported = 0;
    let updated = 0;
    let errors = 0;
    let withGeneric = 0;
    let withoutGeneric = 0;
    const errorLog: string[] = [];

    for (const row of drugs) {
      try {
        const drugCode = row.TRADE_CODE.trim();
        const tradeName = row.TRADE_NAME?.trim() || `Drug-${drugCode}`;

        // Resolve genericId (allow null)
        let genericId: bigint | null = null;
        if (row.WORKING_CODE) {
          const workingCode = row.WORKING_CODE.trim();
          genericId = workingCodeToGenericId.get(workingCode) || null;
        }

        if (genericId) {
          withGeneric++;
        } else {
          withoutGeneric++;
        }

        // Resolve manufacturerId
        let manufacturerId: bigint | null = null;
        if (row.MANUFAC_CODE) {
          const manuCode = row.MANUFAC_CODE.trim();
          manufacturerId = companyCodeToId.get(manuCode) || null;
          // Try padded version
          if (!manufacturerId) {
            manufacturerId = companyCodeToId.get(manuCode.padStart(6, '0')) || null;
          }
        }

        // Determine if active
        const isActive = row.HIDE !== 'Y';

        // Check if exists
        const existing = await prisma.drug.findUnique({
          where: { drugCode: drugCode }
        });

        if (existing) {
          await prisma.drug.update({
            where: { drugCode: drugCode },
            data: {
              tradeName: tradeName.slice(0, 100),
              genericId: genericId,
              manufacturerId: manufacturerId,
              standardCode: row.STD_CODE?.trim() || null,
              barcode: row.BAR_CODE?.trim()?.slice(0, 20) || null,
              packSize: row.PACK_RATIO ? Math.floor(row.PACK_RATIO) : 1,
              registrationNumber: row.REGIST_NO?.trim()?.slice(0, 20) || null,
              atcCode: row.ATC?.trim()?.slice(0, 10) || null,
              unitPrice: row.SALE_UNIT_PRICE ? Number(row.SALE_UNIT_PRICE) : null,
              isActive: isActive,
            }
          });
          updated++;
        } else {
          await prisma.drug.create({
            data: {
              drugCode: drugCode,
              tradeName: tradeName.slice(0, 100),
              genericId: genericId,
              manufacturerId: manufacturerId,
              standardCode: row.STD_CODE?.trim() || null,
              barcode: row.BAR_CODE?.trim()?.slice(0, 20) || null,
              packSize: row.PACK_RATIO ? Math.floor(row.PACK_RATIO) : 1,
              registrationNumber: row.REGIST_NO?.trim()?.slice(0, 20) || null,
              atcCode: row.ATC?.trim()?.slice(0, 10) || null,
              unitPrice: row.SALE_UNIT_PRICE ? Number(row.SALE_UNIT_PRICE) : null,
              isActive: isActive,
            }
          });
          imported++;
        }

        if ((imported + updated) % 500 === 0) {
          process.stdout.write(`\\r   Progress: ${imported + updated} records processed`);
        }
      } catch (err: any) {
        errors++;
        if (errors <= 10) {
          errorLog.push(`Error: ${row.TRADE_CODE} - ${err.message}`);
        }
      }
    }

    console.log(`\\r   Progress: ${imported + updated} records processed\\n`);

    // ===========================================
    // Summary
    // ===========================================
    console.log('═══════════════════════════════════════');
    console.log('✅ Phase 13 Migration Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   Source records:      ${drugs.length.toLocaleString()}`);
    console.log(`   New imports:         ${imported.toLocaleString()}`);
    console.log(`   Updated:             ${updated.toLocaleString()}`);
    console.log(`   Errors:              ${errors.toLocaleString()}`);
    console.log('───────────────────────────────────────');
    console.log(`   With generic link:   ${withGeneric.toLocaleString()}`);
    console.log(`   Without generic:     ${withoutGeneric.toLocaleString()}`);
    console.log('═══════════════════════════════════════');

    if (errorLog.length > 0) {
      console.log('\\n⚠️  Sample errors:');
      errorLog.forEach(log => console.log(`   - ${log}`));
    }

    const finalCount = await prisma.drug.count();
    const activeCount = await prisma.drug.count({ where: { isActive: true } });
    console.log(`\\n📊 Final count in drugs: ${finalCount.toLocaleString()} (${activeCount.toLocaleString()} active)`);

  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    await mysqlConn.end();
    await prisma.$disconnect();
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
