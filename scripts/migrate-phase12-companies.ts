/**
 * Phase 12: Import All Companies
 * บริษัท/Vendors/Manufacturers ทั้งหมด
 *
 * Source: MySQL company table (816 records)
 * Target: PostgreSQL companies table
 *
 * Run: npx tsx scripts/migrate-phase12-companies.ts
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

interface CompanyRow {
  COMPANY_CODE: number;
  COMPANY_NAME: string | null;
  VENDOR_FLAG: string | null;
  MANUFAC_FLAG: string | null;
  ADDRESS: string | null;
  TEL: string | null;
  FAX: string | null;
  EMAIL: string | null;
  TAX_ID: string | null;
  HIDE: string | null;
  BANK_ACC_NO: string | null;
  BANK_ACC_NAME: string | null;
  BANK_NAME: string | null;
  DETAILER: string | null;
}

async function main() {
  console.log('🚀 Phase 12: Importing All Companies...\n');

  const mysqlConn = await mysql.createConnection(mysqlConfig);

  try {
    // ===========================================
    // Step 1: Fetch data from MySQL
    // ===========================================
    console.log('📋 Step 1/2: Fetching data from MySQL...');
    const [companies] = await mysqlConn.query<CompanyRow[]>(`
      SELECT
        COMPANY_CODE,
        COMPANY_NAME,
        VENDOR_FLAG,
        MANUFAC_FLAG,
        ADDRESS,
        TEL,
        FAX,
        EMAIL,
        TAX_ID,
        HIDE,
        BANK_ACC_NO,
        BANK_ACC_NAME,
        BANK_NAME,
        DETAILER
      FROM company
      WHERE HIDE IS NULL OR HIDE != 'Y'
      ORDER BY COMPANY_CODE
    `);
    console.log(`   ✅ Fetched ${companies.length} company records\n`);

    // ===========================================
    // Step 2: Import to PostgreSQL
    // ===========================================
    console.log('📋 Step 2/2: Importing to PostgreSQL...');

    let imported = 0;
    let updated = 0;
    let errors = 0;
    const errorLog: string[] = [];

    for (const row of companies) {
      try {
        const companyCode = String(row.COMPANY_CODE).padStart(6, '0');
        const companyName = row.COMPANY_NAME?.trim() || `Company-${row.COMPANY_CODE}`;

        // Determine company type
        let companyType: 'VENDOR' | 'MANUFACTURER' | 'BOTH' = 'VENDOR';
        if (row.VENDOR_FLAG === 'Y' && row.MANUFAC_FLAG === 'Y') {
          companyType = 'BOTH';
        } else if (row.MANUFAC_FLAG === 'Y') {
          companyType = 'MANUFACTURER';
        }

        // Build address
        const address = row.ADDRESS?.trim() || null;

        // Upsert company
        const existing = await prisma.company.findUnique({
          where: { companyCode: companyCode }
        });

        if (existing) {
          await prisma.company.update({
            where: { companyCode: companyCode },
            data: {
              companyName: companyName,
              companyType: companyType,
              address: address,
              phone: row.TEL?.trim() || null,
              email: row.EMAIL?.trim() || null,
              taxId: row.TAX_ID?.trim() || null,
              bankCode: row.BANK_ACC_NO?.trim() || null,
              bankAccount: row.BANK_ACC_NAME?.trim() || null,
              contactPerson: row.DETAILER?.trim() || null,
              isActive: true,
            }
          });
          updated++;
        } else {
          await prisma.company.create({
            data: {
              companyCode: companyCode,
              companyName: companyName,
              companyType: companyType,
              address: address,
              phone: row.TEL?.trim() || null,
              email: row.EMAIL?.trim() || null,
              taxId: row.TAX_ID?.trim() || null,
              bankCode: row.BANK_ACC_NO?.trim() || null,
              bankAccount: row.BANK_ACC_NAME?.trim() || null,
              contactPerson: row.DETAILER?.trim() || null,
              isActive: true,
            }
          });
          imported++;
        }

        if ((imported + updated) % 100 === 0) {
          process.stdout.write(`\r   Progress: ${imported + updated} records processed`);
        }
      } catch (err: any) {
        errors++;
        if (errors <= 10) {
          errorLog.push(`Error: ${row.COMPANY_CODE} - ${err.message}`);
        }
      }
    }

    console.log(`\r   Progress: ${imported + updated} records processed\n`);

    // ===========================================
    // Summary
    // ===========================================
    console.log('═══════════════════════════════════════');
    console.log('✅ Phase 12 Migration Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   Source records:  ${companies.length.toLocaleString()}`);
    console.log(`   New imports:     ${imported.toLocaleString()}`);
    console.log(`   Updated:         ${updated.toLocaleString()}`);
    console.log(`   Errors:          ${errors.toLocaleString()}`);
    console.log('═══════════════════════════════════════');

    if (errorLog.length > 0) {
      console.log('\n⚠️  Sample errors:');
      errorLog.forEach(log => console.log(`   - ${log}`));
    }

    const finalCount = await prisma.company.count();
    console.log(`\n📊 Final count in companies: ${finalCount.toLocaleString()}`);

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
