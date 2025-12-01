/**
 * Phase 9: Import Drug Pack Ratios
 * อัตราส่วนบรรจุภัณฑ์และราคา
 *
 * Source: MySQL pack_ratio table (1,648 records)
 * Target: PostgreSQL drug_pack_ratios table
 *
 * Maps:
 * - WORKING_CODE/TRADE_CODE → drugId (FK to drugs)
 * - VENDOR_CODE → vendorId (FK to companies)
 * - MANUFAC_CODE → manufacturerId (FK to companies)
 * - PACK_RATIO → packRatio (conversion factor)
 * - BUY_UNIT_COST → buyUnitCost
 * - SALE_UNIT_PRICE → saleUnitPrice
 * - BAR_CODE → barcode
 * - PACK_UNIT → packUnitId
 * - SUBPACK_UNIT → subpackUnitId
 *
 * Run: npx tsx scripts/migrate-phase9-pack-ratios.ts
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

interface PackRatioRow {
  WORKING_CODE: string | null;
  VENDOR_CODE: string | null;
  PACK_RATIO: number | null;
  BUY_UNIT_COST: number | null;
  MANUFAC_CODE: string | null;
  LAST_BUY: Date | null;
  BAR_CODE: string | null;
  SALE_UNIT_PRICE: number | null;
  TRADE_CODE: string | null;
  PACK_UNIT: number | null;
  SUBPACK_UNIT: number | null;
  HIDE: string | null;
  PACK_CODE: string | null;
}

async function main() {
  console.log('🚀 Phase 9: Importing Drug Pack Ratios...\n');

  const mysqlConn = await mysql.createConnection(mysqlConfig);

  try {
    // ===========================================
    // Step 1: Build lookup maps for FK resolution
    // ===========================================
    console.log('📋 Step 1/3: Building lookup maps...');

    // Map drug_code → drug.id
    const drugs = await prisma.drug.findMany({
      select: { id: true, drugCode: true, genericId: true }
    });
    const drugCodeToId = new Map<string, bigint>();
    for (const drug of drugs) {
      drugCodeToId.set(drug.drugCode.trim(), drug.id);
    }
    console.log(`   - Drug codes mapped: ${drugCodeToId.size}`);

    // Map working_code (generic) → list of drug.id
    const genericToDrugIds = new Map<string, bigint[]>();
    const generics = await prisma.drugGeneric.findMany({
      select: { id: true, workingCode: true }
    });
    const workingCodeToGenericId = new Map<string, bigint>();
    for (const g of generics) {
      workingCodeToGenericId.set(g.workingCode.trim(), g.id);
    }

    for (const drug of drugs) {
      if (drug.genericId) {
        const generic = generics.find(g => g.id === drug.genericId);
        if (generic) {
          const code = generic.workingCode.trim();
          if (!genericToDrugIds.has(code)) {
            genericToDrugIds.set(code, []);
          }
          genericToDrugIds.get(code)!.push(drug.id);
        }
      }
    }
    console.log(`   - Generic codes mapped: ${genericToDrugIds.size}`);

    // Map company_code → company.id
    const companies = await prisma.company.findMany({
      select: { id: true, companyCode: true }
    });
    const companyCodeToId = new Map<string, bigint>();
    for (const company of companies) {
      companyCodeToId.set(company.companyCode.trim(), company.id);
    }
    console.log(`   - Company codes mapped: ${companyCodeToId.size}`);

    console.log('   ✅ Lookup maps ready\n');

    // ===========================================
    // Step 2: Fetch pack_ratio data from MySQL
    // ===========================================
    console.log('📋 Step 2/3: Fetching data from MySQL...');
    const [packRatios] = await mysqlConn.query<PackRatioRow[]>(`
      SELECT
        WORKING_CODE,
        VENDOR_CODE,
        PACK_RATIO,
        BUY_UNIT_COST,
        MANUFAC_CODE,
        LAST_BUY,
        BAR_CODE,
        SALE_UNIT_PRICE,
        TRADE_CODE,
        PACK_UNIT,
        SUBPACK_UNIT,
        HIDE,
        PACK_CODE
      FROM pack_ratio
      WHERE HIDE IS NULL OR HIDE != 'Y'
      ORDER BY WORKING_CODE, TRADE_CODE
    `);
    console.log(`   ✅ Fetched ${packRatios.length} pack ratio records\n`);

    // ===========================================
    // Step 3: Import to PostgreSQL
    // ===========================================
    console.log('📋 Step 3/3: Importing to PostgreSQL...');

    let imported = 0;
    let skipped = 0;
    let errors = 0;
    const batchSize = 100;
    const errorLog: string[] = [];

    for (let i = 0; i < packRatios.length; i += batchSize) {
      const batch = packRatios.slice(i, i + batchSize);

      for (const row of batch) {
        try {
          // Resolve drugId
          let drugId: bigint | null = null;

          // Priority 1: Use TRADE_CODE if available
          if (row.TRADE_CODE) {
            const tradeCode = row.TRADE_CODE.trim();
            if (drugCodeToId.has(tradeCode)) {
              drugId = drugCodeToId.get(tradeCode)!;
            }
          }

          // Priority 2: Use WORKING_CODE (generic) to find first matching drug
          if (!drugId && row.WORKING_CODE) {
            const workingCode = row.WORKING_CODE.trim();
            const drugIds = genericToDrugIds.get(workingCode);
            if (drugIds && drugIds.length > 0) {
              drugId = drugIds[0]; // Take first matching drug
            }
          }

          // Skip if no drug found
          if (!drugId) {
            skipped++;
            if (skipped <= 20) {
              errorLog.push(`Skipped: No drug found for WORKING_CODE=${row.WORKING_CODE}, TRADE_CODE=${row.TRADE_CODE}`);
            }
            continue;
          }

          // Resolve vendorId
          let vendorId: bigint | null = null;
          if (row.VENDOR_CODE) {
            vendorId = companyCodeToId.get(row.VENDOR_CODE.trim()) || null;
          }

          // Resolve manufacturerId
          let manufacturerId: bigint | null = null;
          if (row.MANUFAC_CODE) {
            manufacturerId = companyCodeToId.get(row.MANUFAC_CODE.trim()) || null;
          }

          // Create unique key for upsert
          const existingRatio = await prisma.drugPackRatio.findFirst({
            where: {
              drugId: drugId,
              vendorId: vendorId,
              packCode: row.PACK_CODE?.trim() || null
            }
          });

          if (existingRatio) {
            // Update existing
            await prisma.drugPackRatio.update({
              where: { id: existingRatio.id },
              data: {
                packRatio: row.PACK_RATIO ? Number(row.PACK_RATIO) : 1,
                buyUnitCost: row.BUY_UNIT_COST ? Number(row.BUY_UNIT_COST) : null,
                saleUnitPrice: row.SALE_UNIT_PRICE ? Number(row.SALE_UNIT_PRICE) : null,
                manufacturerId: manufacturerId,
                barcode: row.BAR_CODE?.trim() || null,
                packUnitId: row.PACK_UNIT || null,
                subpackUnitId: row.SUBPACK_UNIT || null,
                lastPurchaseDate: row.LAST_BUY || null,
                isHidden: row.HIDE === 'Y',
                packCode: row.PACK_CODE?.trim() || null,
              }
            });
          } else {
            // Create new
            await prisma.drugPackRatio.create({
              data: {
                drugId: drugId,
                vendorId: vendorId,
                manufacturerId: manufacturerId,
                packRatio: row.PACK_RATIO ? Number(row.PACK_RATIO) : 1,
                buyUnitCost: row.BUY_UNIT_COST ? Number(row.BUY_UNIT_COST) : null,
                saleUnitPrice: row.SALE_UNIT_PRICE ? Number(row.SALE_UNIT_PRICE) : null,
                barcode: row.BAR_CODE?.trim() || null,
                packUnitId: row.PACK_UNIT || null,
                subpackUnitId: row.SUBPACK_UNIT || null,
                lastPurchaseDate: row.LAST_BUY || null,
                isHidden: row.HIDE === 'Y',
                packCode: row.PACK_CODE?.trim() || null,
              }
            });
          }

          imported++;
        } catch (err: any) {
          errors++;
          if (errors <= 10) {
            errorLog.push(`Error: ${row.WORKING_CODE}/${row.TRADE_CODE} - ${err.message}`);
          }
        }
      }

      // Progress update
      const progress = Math.min(i + batchSize, packRatios.length);
      process.stdout.write(`\r   Progress: ${progress}/${packRatios.length} records processed`);
    }

    console.log('\n');

    // ===========================================
    // Summary
    // ===========================================
    console.log('═══════════════════════════════════════');
    console.log('✅ Phase 9 Migration Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   Source records:      ${packRatios.length.toLocaleString()}`);
    console.log(`   Imported:            ${imported.toLocaleString()}`);
    console.log(`   Skipped (no match):  ${skipped.toLocaleString()}`);
    console.log(`   Errors:              ${errors.toLocaleString()}`);
    console.log('═══════════════════════════════════════');

    // Show error samples
    if (errorLog.length > 0) {
      console.log('\n⚠️  Sample issues (first 20):');
      errorLog.forEach(log => console.log(`   - ${log}`));
    }

    // Verify final count
    const finalCount = await prisma.drugPackRatio.count();
    console.log(`\n📊 Final count in drug_pack_ratios: ${finalCount.toLocaleString()}`);

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
