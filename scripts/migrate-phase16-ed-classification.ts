/**
 * Phase 16: Import ED Classification Data
 * ED Group (Therapeutic Classification) and ED Category mapping
 *
 * Tables/Fields to import:
 * 1. EdGroup (209 records from MySQL ed_group) - therapeutic class hierarchy
 * 2. DrugGeneric fields: edCategory, edList, edGroupId (from MySQL drug_gn)
 *
 * ED Category mapping (from manual page 12):
 * - ED: บัญชียา ED (Essential Drug list) - IS_ED=1
 * - NED: บัญชียา NED (Non-Essential Drug) - IS_ED=2
 * - NDMS: เวชภัณฑ์มิใช่ยา (GROUP_CODE starts with 93)
 * - CM: สารเคมี (GROUP_CODE starts with 96)
 * - LS: วัสดุทางห้องปฏิบัติการ (GROUP_CODE starts with 95)
 * - PS: วัสดุทางเภสัชกรรม (GROUP_CODE starts with 96)
 *
 * IS_ED values in MySQL:
 * - 1: ยา ED (with ED_LIST 1-6)
 * - 2: ยา NED
 * - 3: ? (4 records)
 * - 4: เวชภัณฑ์มิใช่ยา/วัสดุ
 *
 * Run: npx tsx scripts/migrate-phase16-ed-classification.ts
 */

import { PrismaClient, EdCategory } from '@prisma/client';
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

/**
 * Determine EdCategory based on IS_ED and GROUP_CODE
 */
function determineEdCategory(isEd: number | null, groupCode: string | null): EdCategory | null {
  // Check GROUP_CODE first for non-drug categories
  if (groupCode) {
    if (groupCode.startsWith('93')) return 'NDMS'; // เวชภัณฑ์มิใช่ยา
    if (groupCode.startsWith('94')) return 'NDMS'; // วัสดุการแพทย์ -> NDMS
    if (groupCode.startsWith('95')) return 'LS';   // วัสดุวิทยาศาสตร์/ห้องปฏิบัติการ
    if (groupCode.startsWith('96')) return 'CM';   // เภสัชเคมีภัณฑ์
    if (groupCode.startsWith('97')) return 'PS';   // อื่นๆ -> วัสดุทางเภสัชกรรม
  }

  // Check IS_ED for drug categories
  if (isEd === 1) return 'ED';   // บัญชียา ED
  if (isEd === 2) return 'NED';  // บัญชียา NED
  if (isEd === 4) return 'NDMS'; // เวชภัณฑ์มิใช่ยา

  // Default: try to infer from group code pattern
  if (groupCode && groupCode.startsWith('0')) {
    // Standard therapeutic classes (01-92) are drugs
    return 'ED'; // Default drug category
  }

  return null; // Unknown
}

async function main() {
  console.log('🚀 Phase 16: Importing ED Classification Data...\n');
  console.log('═══════════════════════════════════════════════════════════');
  console.log('   ED Classification Migration (คู่มือหน้า 12)');
  console.log('═══════════════════════════════════════════════════════════\n');

  const mysqlConn = await mysql.createConnection(mysqlConfig);

  try {
    // ===========================================
    // 1. Import EdGroup (Therapeutic Classification)
    // ===========================================
    console.log('📋 1/2: Importing ED Groups (Therapeutic Classes)...');
    const [edGroups] = await mysqlConn.query<any[]>(`
      SELECT
        RECORD_NUMBER as recordNumber,
        CODE as code,
        NAME as name,
        SUB_COMMIT_CODE as subCommitCode,
        FORECAST as forecast,
        hide as isHidden
      FROM ed_group
      ORDER BY CODE
    `);

    let edGroupCount = 0;
    for (const group of edGroups) {
      await prisma.edGroup.upsert({
        where: { code: group.code },
        create: {
          code: group.code,
          name: group.name?.trim() || `Group-${group.code}`,
          subCommitCode: group.subCommitCode,
          forecast: group.forecast,
          isHidden: group.isHidden === 'Y' || group.isHidden === '1',
        },
        update: {
          name: group.name?.trim() || `Group-${group.code}`,
          subCommitCode: group.subCommitCode,
          forecast: group.forecast,
          isHidden: group.isHidden === 'Y' || group.isHidden === '1',
        },
      });
      edGroupCount++;
    }
    console.log(`   ✅ Imported ${edGroupCount} ED groups\n`);

    // Show category summary
    console.log('   📊 ED Group Categories:');
    const categorySummary = await prisma.edGroup.groupBy({
      by: ['code'],
      _count: true,
    });

    // Count by prefix
    const prefixCounts: Record<string, number> = {};
    for (const item of categorySummary) {
      const prefix = item.code.substring(0, 2);
      prefixCounts[prefix] = (prefixCounts[prefix] || 0) + 1;
    }

    // Show key prefixes
    console.log(`      01-92: ${Object.entries(prefixCounts).filter(([k]) => k >= '01' && k <= '92').reduce((a, [, v]) => a + v, 0)} (Therapeutic Classes)`);
    console.log(`      93: ${prefixCounts['93'] || 0} (เวชภัณฑ์มิใช่ยา - NDMS)`);
    console.log(`      94: ${prefixCounts['94'] || 0} (วัสดุการแพทย์)`);
    console.log(`      95: ${prefixCounts['95'] || 0} (วัสดุวิทยาศาสตร์ - LS)`);
    console.log(`      96: ${prefixCounts['96'] || 0} (เภสัชเคมีภัณฑ์ - CM)`);
    console.log(`      97: ${prefixCounts['97'] || 0} (อื่นๆ - PS)\n`);

    // ===========================================
    // 2. Map DrugGeneric to ED Classification
    // ===========================================
    console.log('📋 2/2: Mapping Drug Generics to ED Classification...');

    // Get MySQL drug_gn data with ED fields
    const [drugGnData] = await mysqlConn.query<any[]>(`
      SELECT
        WORKING_CODE as workingCode,
        GROUP_CODE as groupCode,
        IS_ED as isEd,
        ED_LIST as edList
      FROM drug_gn
      WHERE WORKING_CODE IS NOT NULL
      ORDER BY WORKING_CODE
    `);

    console.log(`   Found ${drugGnData.length} records in MySQL drug_gn`);

    // Build lookup map for EdGroup by code
    const edGroupMap = new Map<string, bigint>();
    const allEdGroups = await prisma.edGroup.findMany({ select: { id: true, code: true } });
    for (const g of allEdGroups) {
      edGroupMap.set(g.code, g.id);
    }

    // Get all existing drug generics
    const existingGenerics = await prisma.drugGeneric.findMany({
      select: { id: true, workingCode: true }
    });
    const genericMap = new Map<string, bigint>();
    for (const g of existingGenerics) {
      genericMap.set(g.workingCode, g.id);
    }

    console.log(`   Found ${existingGenerics.length} drug generics in PostgreSQL`);

    // Update each matching generic
    let updatedCount = 0;
    let notFoundCount = 0;
    const categoryStats: Record<string, number> = {};

    for (const drug of drugGnData) {
      const genericId = genericMap.get(drug.workingCode);
      if (!genericId) {
        notFoundCount++;
        continue;
      }

      // Determine ED category
      const edCategory = determineEdCategory(drug.isEd, drug.groupCode);

      // Get ED group ID
      const edGroupId = drug.groupCode ? edGroupMap.get(drug.groupCode) : null;

      // Determine ED list (1-6, or null for non-ED)
      let edList: number | null = null;
      if (drug.edList && drug.edList > 0 && drug.edList <= 6) {
        edList = drug.edList;
      }

      // Update the generic
      await prisma.drugGeneric.update({
        where: { id: genericId },
        data: {
          edCategory: edCategory,
          edList: edList,
          edGroupId: edGroupId || null,
        },
      });

      updatedCount++;
      if (edCategory) {
        categoryStats[edCategory] = (categoryStats[edCategory] || 0) + 1;
      } else {
        categoryStats['UNKNOWN'] = (categoryStats['UNKNOWN'] || 0) + 1;
      }

      if (updatedCount % 200 === 0) {
        process.stdout.write(`\r   Progress: ${updatedCount} generics updated`);
      }
    }

    console.log(`\n   ✅ Updated ${updatedCount} drug generics with ED classification`);
    if (notFoundCount > 0) {
      console.log(`   ⚠️  ${notFoundCount} MySQL records not found in PostgreSQL (normal if not all migrated)`);
    }

    // Show category distribution
    console.log('\n   📊 ED Category Distribution:');
    console.log(`      ED (บัญชียา ED):      ${categoryStats['ED'] || 0}`);
    console.log(`      NED (บัญชียา NED):    ${categoryStats['NED'] || 0}`);
    console.log(`      NDMS (เวชภัณฑ์):      ${categoryStats['NDMS'] || 0}`);
    console.log(`      CM (สารเคมี):         ${categoryStats['CM'] || 0}`);
    console.log(`      LS (วัสดุห้องปฏิบัติการ): ${categoryStats['LS'] || 0}`);
    console.log(`      PS (วัสดุเภสัชกรรม):  ${categoryStats['PS'] || 0}`);
    console.log(`      UNKNOWN:              ${categoryStats['UNKNOWN'] || 0}`);

    // Show ED list distribution for ED category
    const edListStats = await prisma.drugGeneric.groupBy({
      by: ['edList'],
      where: { edCategory: 'ED' },
      _count: true,
    });

    console.log('\n   📊 ED List Distribution (for ED category):');
    for (const stat of edListStats.sort((a, b) => (a.edList || 0) - (b.edList || 0))) {
      const listLabel = stat.edList ? `บัญชี ${stat.edList}` : 'ไม่ระบุ';
      console.log(`      ${listLabel}: ${stat._count}`);
    }

    // ===========================================
    // Summary
    // ===========================================
    console.log('\n═══════════════════════════════════════════════════════════');
    console.log('   📊 PHASE 16 MIGRATION COMPLETE');
    console.log('═══════════════════════════════════════════════════════════');
    console.log(`   ED Groups imported:           ${edGroupCount}`);
    console.log(`   Drug Generics updated:        ${updatedCount}`);
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
    console.log('✅ Phase 16 completed successfully!\n');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Phase 16 failed:', error);
    process.exit(1);
  });
