#!/usr/bin/env ts-node
/**
 * Phase 1 Data Migration Script
 * ================================
 * Migrates procurement master data from MySQL to PostgreSQL
 *
 * Tables:
 * - purchase_methods (buymethod) - 18 records
 * - purchase_types (buycommon) - 20 records
 * - return_reasons (rtn_reason) - 19 records
 * - drug_pack_ratios (pack_ratio) - 1,648 records
 *
 * Usage:
 *   npm run ts-node scripts/migrate-phase1-data.ts
 *
 * @version 2.3.0
 * @date 2025-01-21
 */

import { PrismaClient } from '@prisma/client';
import mysql from 'mysql2/promise';

const prisma = new PrismaClient();

// MySQL Legacy Database Connection
const mysqlConfig = {
  host: 'localhost',
  port: 3307,
  user: 'invs_user',
  password: 'invs123',
  database: 'invs_banpong',
};

interface MySQLBuyMethod {
  BUYMET_CODE: number;
  BUYMET_DES: string;
  HIDE: string;
  REPORT_NAME: string | null;
  DEAL_DAYS: number | null;
  MIN_AMT: number | null;
  MAX_AMT: number | null;
  AUTHOR_SIGN: string | null;
  STD_CODE: string | null;
  DEFAULT_FLAG: string | null;
}

interface MySQLBuyCommon {
  COMMON_CODE: number;
  COMMON_DES: string;
  HIDE: string;
  AUTHOR_SIGN: string | null;
  STD_CODE: string | null;
  DEAL_DAYS: number | null;
  DEFAULT_FLAG: string | null;
}

interface MySQLReturnReason {
  ID: number;
  RETURN_REASON: string;
  HIDE: string | null;
}

interface MySQLPackRatio {
  WORKING_CODE: string;
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
  console.log('🚀 Phase 1 Data Migration Starting...\n');

  let connection: mysql.Connection | undefined;

  try {
    // Connect to MySQL
    console.log('📡 Connecting to MySQL legacy database...');
    connection = await mysql.createConnection(mysqlConfig);
    console.log('✅ MySQL connected\n');

    // ========================================
    // 1. Migrate Purchase Methods (buymethod)
    // ========================================
    console.log('📦 1/4: Migrating Purchase Methods (buymethod)...');
    const [buyMethods] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM buymethod ORDER BY BUYMET_CODE'
    );

    let purchaseMethodCount = 0;
    for (const row of buyMethods as MySQLBuyMethod[]) {
      await prisma.purchaseMethod.upsert({
        where: { code: row.BUYMET_CODE },
        update: {
          name: row.BUYMET_DES,
          minAmount: row.MIN_AMT,
          maxAmount: row.MAX_AMT,
          dealDays: row.DEAL_DAYS,
          authoritySigner: row.AUTHOR_SIGN,
          stdCode: row.STD_CODE,
          reportForms: row.REPORT_NAME,
          isHidden: row.HIDE === 'Y',
          isDefault: row.DEFAULT_FLAG === 'Y',
        },
        create: {
          code: row.BUYMET_CODE,
          name: row.BUYMET_DES,
          minAmount: row.MIN_AMT,
          maxAmount: row.MAX_AMT,
          dealDays: row.DEAL_DAYS,
          authoritySigner: row.AUTHOR_SIGN,
          stdCode: row.STD_CODE,
          reportForms: row.REPORT_NAME,
          isHidden: row.HIDE === 'Y',
          isDefault: row.DEFAULT_FLAG === 'Y',
        },
      });
      purchaseMethodCount++;
    }
    console.log(`✅ Migrated ${purchaseMethodCount} purchase methods\n`);

    // ========================================
    // 2. Migrate Purchase Types (buycommon)
    // ========================================
    console.log('📦 2/4: Migrating Purchase Types (buycommon)...');
    const [buyCommons] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM buycommon ORDER BY COMMON_CODE'
    );

    let purchaseTypeCount = 0;
    for (const row of buyCommons as MySQLBuyCommon[]) {
      await prisma.purchaseType.upsert({
        where: { code: row.COMMON_CODE },
        update: {
          name: row.COMMON_DES,
          authoritySigner: row.AUTHOR_SIGN,
          stdCode: row.STD_CODE,
          dealDays: row.DEAL_DAYS,
          isHidden: row.HIDE === 'Y',
          isDefault: row.DEFAULT_FLAG === 'Y',
        },
        create: {
          code: row.COMMON_CODE,
          name: row.COMMON_DES,
          authoritySigner: row.AUTHOR_SIGN,
          stdCode: row.STD_CODE,
          dealDays: row.DEAL_DAYS,
          isHidden: row.HIDE === 'Y',
          isDefault: row.DEFAULT_FLAG === 'Y',
        },
      });
      purchaseTypeCount++;
    }
    console.log(`✅ Migrated ${purchaseTypeCount} purchase types\n`);

    // ========================================
    // 3. Migrate Return Reasons (rtn_reason)
    // ========================================
    console.log('📦 3/4: Migrating Return Reasons (rtn_reason)...');
    const [returnReasons] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM rtn_reason ORDER BY ID'
    );

    // Map return reasons to categories
    const getCategoryForReason = (id: number, reason: string): string => {
      // Clinical reasons (1, 6, 7, 8, 9, 15, 16, 17, 19)
      const clinicalIds = [1, 6, 7, 8, 9, 15, 16, 17, 19];
      if (clinicalIds.includes(id)) return 'clinical';

      // Quality reasons (10, 18)
      if ([10, 18].includes(id)) return 'quality';

      // Operational/error reasons (2, 3, 4, 5, 11, 12, 13, 14)
      return 'operational';
    };

    let returnReasonCount = 0;
    for (const row of returnReasons as MySQLReturnReason[]) {
      const category = getCategoryForReason(row.ID, row.RETURN_REASON);

      await prisma.returnReason.upsert({
        where: { code: row.ID },
        update: {
          reason: row.RETURN_REASON,
          category,
          isHidden: row.HIDE === 'Y',
        },
        create: {
          code: row.ID,
          reason: row.RETURN_REASON,
          category,
          isHidden: row.HIDE === 'Y',
        },
      });
      returnReasonCount++;
    }
    console.log(`✅ Migrated ${returnReasonCount} return reasons\n`);

    // ========================================
    // 4. Migrate Drug Pack Ratios (pack_ratio)
    // ========================================
    console.log('📦 4/4: Migrating Drug Pack Ratios (pack_ratio)...');
    console.log('⚠️  This may take a while (1,648 records)...\n');

    const [packRatios] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM pack_ratio WHERE HIDE = "N" OR HIDE IS NULL ORDER BY WORKING_CODE'
    );

    let packRatioCount = 0;
    let skippedCount = 0;

    for (const row of packRatios as MySQLPackRatio[]) {
      // Find drug by workingCode
      const drug = await prisma.drug.findFirst({
        where: {
          OR: [
            { drugCode: row.TRADE_CODE || '' },
            { generic: { workingCode: row.WORKING_CODE } },
          ],
        },
      });

      if (!drug) {
        skippedCount++;
        continue;
      }

      // Find vendor by code
      let vendorId: bigint | null = null;
      if (row.VENDOR_CODE) {
        const vendor = await prisma.company.findFirst({
          where: { companyCode: row.VENDOR_CODE },
        });
        vendorId = vendor?.id || null;
      }

      // Find manufacturer by code
      let manufacturerId: bigint | null = null;
      if (row.MANUFAC_CODE) {
        const manufacturer = await prisma.company.findFirst({
          where: { companyCode: row.MANUFAC_CODE },
        });
        manufacturerId = manufacturer?.id || null;
      }

      // Check if already exists
      const existing = await prisma.drugPackRatio.findFirst({
        where: {
          drugId: drug.id,
          vendorId,
          manufacturerId,
        },
      });

      if (existing) {
        // Update existing
        await prisma.drugPackRatio.update({
          where: { id: existing.id },
          data: {
            packRatio: row.PACK_RATIO || 1,
            buyUnitCost: row.BUY_UNIT_COST,
            saleUnitPrice: row.SALE_UNIT_PRICE,
            packUnitId: row.PACK_UNIT,
            subpackUnitId: row.SUBPACK_UNIT,
            barcode: row.BAR_CODE,
            lastPurchaseDate: row.LAST_BUY,
            packCode: row.PACK_CODE,
            isHidden: row.HIDE === 'Y',
          },
        });
      } else {
        // Create new
        await prisma.drugPackRatio.create({
          data: {
            drugId: drug.id,
            vendorId,
            manufacturerId,
            packRatio: row.PACK_RATIO || 1,
            buyUnitCost: row.BUY_UNIT_COST,
            saleUnitPrice: row.SALE_UNIT_PRICE,
            packUnitId: row.PACK_UNIT,
            subpackUnitId: row.SUBPACK_UNIT,
            barcode: row.BAR_CODE,
            lastPurchaseDate: row.LAST_BUY,
            packCode: row.PACK_CODE,
            isHidden: row.HIDE === 'Y',
          },
        });
      }

      packRatioCount++;

      // Progress indicator
      if (packRatioCount % 100 === 0) {
        console.log(`   📊 Progress: ${packRatioCount} records migrated...`);
      }
    }

    console.log(`✅ Migrated ${packRatioCount} drug pack ratios`);
    if (skippedCount > 0) {
      console.log(`⚠️  Skipped ${skippedCount} records (drug not found in modern DB)\n`);
    }

    // ========================================
    // Summary
    // ========================================
    console.log('\n' + '='.repeat(60));
    console.log('🎉 Phase 1 Data Migration Complete!');
    console.log('='.repeat(60));
    console.log(`✅ Purchase Methods: ${purchaseMethodCount}`);
    console.log(`✅ Purchase Types: ${purchaseTypeCount}`);
    console.log(`✅ Return Reasons: ${returnReasonCount}`);
    console.log(`✅ Drug Pack Ratios: ${packRatioCount}`);
    console.log('='.repeat(60) + '\n');

    // Verification
    console.log('🔍 Verifying data in PostgreSQL...');
    const counts = await Promise.all([
      prisma.purchaseMethod.count(),
      prisma.purchaseType.count(),
      prisma.returnReason.count(),
      prisma.drugPackRatio.count(),
    ]);

    console.log(`📊 Purchase Methods in DB: ${counts[0]}`);
    console.log(`📊 Purchase Types in DB: ${counts[1]}`);
    console.log(`📊 Return Reasons in DB: ${counts[2]}`);
    console.log(`📊 Drug Pack Ratios in DB: ${counts[3]}\n`);

    console.log('✅ Migration completed successfully!');
  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    if (connection) {
      await connection.end();
      console.log('📡 MySQL connection closed');
    }
    await prisma.$disconnect();
    console.log('📡 PostgreSQL connection closed');
  }
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
