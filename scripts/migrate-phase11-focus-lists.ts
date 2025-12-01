/**
 * Phase 11: Import Drug Focus Lists
 * บัญชียาพิเศษ (ยาเสพติด, วัตถุออกฤทธิ์, ยาแช่เย็น, etc.)
 *
 * Source: MySQL focus_list table (92 records)
 * Target: PostgreSQL drug_focus_lists table
 *
 * Maps:
 * - LIST_CODE (TRADE_CODE) → drugId (FK to drugs)
 * - LIST_TYPE → listType
 * - LIST_NAME → listName
 * - DEPT_ID → departmentId (FK to departments)
 * - USER_ID → createdBy
 *
 * Run: npx tsx scripts/migrate-phase11-focus-lists.ts
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

interface FocusListRow {
  LIST_CODE: number | null;
  LIST_TYPE: number | null;
  USER_ID: string | null;
  DEPT_ID: string | null;
  LIST_NAME: string | null;
}

async function main() {
  console.log('🚀 Phase 11: Importing Drug Focus Lists...\n');

  const mysqlConn = await mysql.createConnection(mysqlConfig);

  try {
    // ===========================================
    // Step 1: Build lookup maps
    // ===========================================
    console.log('📋 Step 1/3: Building lookup maps...');

    // Map drug_code → drug.id
    const drugs = await prisma.drug.findMany({
      select: { id: true, drugCode: true }
    });
    const drugCodeToDrugId = new Map<string, bigint>();
    for (const d of drugs) {
      drugCodeToDrugId.set(d.drugCode.trim(), d.id);
      // Also map numeric version (without leading zeros)
      const numericCode = parseInt(d.drugCode.trim(), 10);
      if (!isNaN(numericCode)) {
        drugCodeToDrugId.set(String(numericCode), d.id);
      }
    }
    console.log(`   - Drug codes mapped: ${drugCodeToDrugId.size}`);

    // Map dept_code → department.id
    const departments = await prisma.department.findMany({
      select: { id: true, deptCode: true }
    });
    const deptCodeToDeptId = new Map<string, bigint>();
    for (const dept of departments) {
      deptCodeToDeptId.set(dept.deptCode.trim(), dept.id);
    }
    console.log(`   - Department codes mapped: ${deptCodeToDeptId.size}`);
    console.log('   ✅ Lookup maps ready\n');

    // ===========================================
    // Step 2: Fetch data from MySQL
    // ===========================================
    console.log('📋 Step 2/3: Fetching data from MySQL...');
    const [focusLists] = await mysqlConn.query<FocusListRow[]>(`
      SELECT
        LIST_CODE,
        LIST_TYPE,
        USER_ID,
        DEPT_ID,
        LIST_NAME
      FROM focus_list
      ORDER BY LIST_CODE
    `);
    console.log(`   ✅ Fetched ${focusLists.length} focus list records\n`);

    // ===========================================
    // Step 3: Import to PostgreSQL
    // ===========================================
    console.log('📋 Step 3/3: Importing to PostgreSQL...');

    let imported = 0;
    let skipped = 0;
    let errors = 0;
    const errorLog: string[] = [];

    for (const row of focusLists) {
      try {
        // Resolve drugId from LIST_CODE (which is TRADE_CODE)
        if (!row.LIST_CODE) {
          skipped++;
          continue;
        }

        const listCode = String(row.LIST_CODE);
        let drugId = drugCodeToDrugId.get(listCode);

        // Try with padded zeros (e.g., "1" → "000001")
        if (!drugId) {
          const paddedCode = listCode.padStart(6, '0');
          drugId = drugCodeToDrugId.get(paddedCode);
        }

        if (!drugId) {
          skipped++;
          if (skipped <= 20) {
            errorLog.push(`Skipped: No drug found for LIST_CODE=${listCode}`);
          }
          continue;
        }

        // Resolve departmentId (optional)
        let departmentId: bigint | null = null;
        if (row.DEPT_ID) {
          departmentId = deptCodeToDeptId.get(row.DEPT_ID.trim()) || null;
        }

        // Clean list name
        const listName = row.LIST_NAME?.trim() || `Focus-${row.LIST_CODE}`;

        // Check if exists
        const existing = await prisma.drugFocusList.findFirst({
          where: {
            drugId: drugId,
            listName: listName
          }
        });

        if (existing) {
          // Update existing
          await prisma.drugFocusList.update({
            where: { id: existing.id },
            data: {
              listType: row.LIST_TYPE || null,
              departmentId: departmentId,
              createdBy: row.USER_ID?.trim() || null,
            }
          });
        } else {
          // Create new
          await prisma.drugFocusList.create({
            data: {
              drugId: drugId,
              listType: row.LIST_TYPE || null,
              listName: listName,
              departmentId: departmentId,
              createdBy: row.USER_ID?.trim() || null,
              isActive: true,
            }
          });
        }

        imported++;

        // Progress update
        if (imported % 20 === 0) {
          process.stdout.write(`\r   Progress: ${imported} records imported`);
        }
      } catch (err: any) {
        errors++;
        if (errors <= 10) {
          errorLog.push(`Error: LIST_CODE=${row.LIST_CODE} - ${err.message}`);
        }
      }
    }

    console.log(`\r   Progress: ${imported} records imported\n`);

    // ===========================================
    // Summary
    // ===========================================
    console.log('═══════════════════════════════════════');
    console.log('✅ Phase 11 Migration Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   Source records:      ${focusLists.length.toLocaleString()}`);
    console.log(`   Imported:            ${imported.toLocaleString()}`);
    console.log(`   Skipped (no match):  ${skipped.toLocaleString()}`);
    console.log(`   Errors:              ${errors.toLocaleString()}`);
    console.log('═══════════════════════════════════════');

    if (errorLog.length > 0) {
      console.log('\n⚠️  Sample issues:');
      errorLog.forEach(log => console.log(`   - ${log}`));
    }

    // Verify final count
    const finalCount = await prisma.drugFocusList.count();
    console.log(`\n📊 Final count in drug_focus_lists: ${finalCount.toLocaleString()}`);

    // Show list types summary
    const listTypes = await prisma.drugFocusList.groupBy({
      by: ['listType'],
      _count: true,
      orderBy: { listType: 'asc' }
    });
    console.log('\n📋 Focus list types:');
    for (const lt of listTypes) {
      console.log(`   - Type ${lt.listType || 'NULL'}: ${lt._count} drugs`);
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
