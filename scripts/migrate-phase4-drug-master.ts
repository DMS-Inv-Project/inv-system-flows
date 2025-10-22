#!/usr/bin/env ts-node
/**
 * Phase 4 Drug Master Data Migration Script
 * =========================================
 * Migrates drug master data from MySQL to PostgreSQL
 *
 * Tables:
 * - dosage_form (107 records) → tmt_dosage_forms
 * - drug_gn (1,104 records) → drug_generics
 * - drug_vn (7,258 records) → drugs
 *
 * Total: 8,469 records
 *
 * Usage:
 *   npm run ts-node scripts/migrate-phase4-drug-master.ts
 *
 * @version 2.3.0
 * @date 2025-01-22
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

interface MySQLDosageForm {
  DFORM_ID: number;
  DFORM_NAME: string;
  HIDE: string | null;
}

interface MySQLSaleUnit {
  SU_ID: number;
  SALE_UNIT: string;
  HIDE: string | null;
}

interface MySQLDrugGeneric {
  WORKING_CODE: string;
  DRUG_NAME: string;
  DOSAGE_FORM: string | null;
  SALE_UNIT: string | null;
  COMPOSITION: string | null;
  STRENGTH: number | null;
  STRENGTH_UNIT: string | null;
  DFORM_ID: number | null;
  SALE_UNIT_ID: number | null;
  TMTID: number | null;
}

interface MySQLDrugVendor {
  TRADE_CODE: string;
  WORKING_CODE: string | null;
  TRADE_NAME: string;
  VENDOR_CODE: string | null;
  MANUFAC_CODE: string | null;
  PACK_RATIO: number | null;
  REGIST_NO: string | null;
  STD_CODE: string | null;
  GENERIC_CODE: string | null;
  BAR_CODE: string | null;
  TMTID: number | null;
  HIDE: string | null;
}

async function main() {
  console.log('🚀 Phase 4 Drug Master Data Migration Starting...\\n');
  console.log('📦 Importing 8,469 records (dosage forms + generics + trade drugs)\\n');

  let connection: mysql.Connection | undefined;

  try {
    // Connect to MySQL
    console.log('📡 Connecting to MySQL legacy database...');
    connection = await mysql.createConnection(mysqlConfig);
    console.log('✅ MySQL connected\\n');

    // ========================================
    // 1. Load Dosage Forms for Lookup (reference data only)
    // ========================================
    console.log('📦 1/4: Loading Dosage Forms for mapping...');
    const [dosageForms] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM dosage_form ORDER BY DFORM_ID'
    );

    const dosageFormMap = new Map<number, string>(); // DFORM_ID -> form_name
    for (const row of dosageForms as MySQLDosageForm[]) {
      dosageFormMap.set(row.DFORM_ID, row.DFORM_NAME);
    }
    console.log(`✅ Loaded ${dosageFormMap.size} dosage forms for lookup\\n`);

    // ========================================
    // 2. Load Sale Units for Lookup
    // ========================================
    console.log('📦 2/4: Loading Sale Units for mapping...');
    const [saleUnits] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM sale_unit ORDER BY SU_ID'
    );

    const saleUnitMap = new Map<number, string>(); // SU_ID -> sale_unit_name
    for (const row of saleUnits as MySQLSaleUnit[]) {
      saleUnitMap.set(row.SU_ID, row.SALE_UNIT);
    }
    console.log(`✅ Loaded ${saleUnitMap.size} sale units for lookup\\n`);

    // ========================================
    // 3. Migrate Drug Generics (drug_gn → drug_generics)
    // ========================================
    console.log('📦 3/4: Migrating Drug Generics (drug_gn)...');
    const [drugGenerics] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM drug_gn ORDER BY WORKING_CODE'
    );

    let drugGenericCount = 0;
    const workingCodeMap = new Map<string, bigint>(); // WORKING_CODE -> drug_generic.id

    for (const row of drugGenerics as MySQLDrugGeneric[]) {
      // Lookup dosage form and sale unit text
      const dosageFormText = row.DFORM_ID ? dosageFormMap.get(row.DFORM_ID) || row.DOSAGE_FORM || 'UNKNOWN' : row.DOSAGE_FORM || 'UNKNOWN';
      const saleUnitText = row.SALE_UNIT_ID ? saleUnitMap.get(row.SALE_UNIT_ID) || row.SALE_UNIT || 'UNIT' : row.SALE_UNIT || 'UNIT';

      const generic = await prisma.drugGeneric.upsert({
        where: { workingCode: row.WORKING_CODE },
        update: {
          drugName: row.DRUG_NAME,
          dosageForm: dosageFormText.slice(0, 20), // Max 20 chars
          saleUnit: saleUnitText.slice(0, 5), // Max 5 chars
          composition: row.COMPOSITION,
          strength: row.STRENGTH,
          strengthUnit: row.STRENGTH_UNIT,
        },
        create: {
          workingCode: row.WORKING_CODE,
          drugName: row.DRUG_NAME,
          dosageForm: dosageFormText.slice(0, 20),
          saleUnit: saleUnitText.slice(0, 5),
          composition: row.COMPOSITION,
          strength: row.STRENGTH,
          strengthUnit: row.STRENGTH_UNIT,
          isActive: true,
        },
      });

      workingCodeMap.set(row.WORKING_CODE, generic.id);
      drugGenericCount++;

      if (drugGenericCount % 100 === 0) {
        console.log(`   ... ${drugGenericCount}/${drugGenerics.length} generics imported`);
      }
    }
    console.log(`✅ Migrated ${drugGenericCount} drug generics\\n`);

    // ========================================
    // 4. Migrate Trade Drugs (drug_vn → drugs)
    // ========================================
    console.log('📦 4/4: Migrating Trade Drugs (drug_vn)...');
    const [tradeDrugs] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM drug_vn WHERE HIDE IS NULL OR HIDE != \'Y\' ORDER BY TRADE_CODE'
    );

    let tradeDrugCount = 0;
    let skippedCount = 0;

    for (const row of tradeDrugs as MySQLDrugVendor[]) {
      // Skip if no WORKING_CODE (can't link to generic)
      if (!row.WORKING_CODE) {
        skippedCount++;
        continue;
      }

      // Lookup generic ID
      const genericId = workingCodeMap.get(row.WORKING_CODE);
      if (!genericId) {
        skippedCount++;
        continue;
      }

      // Lookup manufacturer
      let manufacturerId: bigint | null = null;
      if (row.MANUFAC_CODE) {
        const manufacturer = await prisma.company.findUnique({
          where: { companyCode: row.MANUFAC_CODE },
        });
        manufacturerId = manufacturer?.id || null;
      }

      await prisma.drug.upsert({
        where: { drugCode: row.TRADE_CODE },
        update: {
          tradeName: row.TRADE_NAME,
          genericId: genericId,
          manufacturerId: manufacturerId,
          standardCode: row.STD_CODE,
          barcode: row.BAR_CODE,
          packSize: row.PACK_RATIO ? Math.floor(row.PACK_RATIO) : 1,
          registrationNumber: row.REGIST_NO,
        },
        create: {
          drugCode: row.TRADE_CODE,
          tradeName: row.TRADE_NAME,
          genericId: genericId,
          manufacturerId: manufacturerId,
          standardCode: row.STD_CODE,
          barcode: row.BAR_CODE,
          packSize: row.PACK_RATIO ? Math.floor(row.PACK_RATIO) : 1,
          registrationNumber: row.REGIST_NO,
        },
      });

      tradeDrugCount++;

      if (tradeDrugCount % 500 === 0) {
        console.log(`   ... ${tradeDrugCount}/${tradeDrugs.length} trade drugs imported`);
      }
    }
    console.log(`✅ Migrated ${tradeDrugCount} trade drugs (${skippedCount} skipped)\\n`);

    // ========================================
    // Summary
    // ========================================
    console.log('\\n' + '='.repeat(70));
    console.log('🎉 Phase 4 Drug Master Data Migration Complete!');
    console.log('='.repeat(70));
    console.log(`✅ Drug Generics: ${drugGenericCount}`);
    console.log(`✅ Trade Drugs: ${tradeDrugCount} (${skippedCount} skipped)`);
    console.log(`📦 Total: ${drugGenericCount + tradeDrugCount} records`);
    console.log('='.repeat(70) + '\\n');

    // Verification
    console.log('🔍 Verifying data in PostgreSQL...');
    const counts = await Promise.all([
      prisma.drugGeneric.count(),
      prisma.drug.count(),
    ]);

    console.log(`📊 Drug Generics in DB: ${counts[0]}`);
    console.log(`📊 Trade Drugs in DB: ${counts[1]}`);

    console.log('\\n✅ Phase 4 migration completed successfully!');
    console.log('📈 Next: Re-run Phase 2 migration to populate drug components & focus lists');
    console.log('   Command: npx ts-node scripts/migrate-phase2-data.ts');
  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    if (connection) {
      await connection.end();
      console.log('\\n📡 MySQL connection closed');
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
