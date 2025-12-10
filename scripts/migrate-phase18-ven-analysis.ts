/**
 * Phase 18: VEN Analysis - Import VEN_FLAG from MySQL
 *
 * VEN Categories:
 * - V (Vital): ยาช่วยชีวิต/ขาดไม่ได้ เช่น Adrenaline, Antidote, Serum
 * - E (Essential): ยาจำเป็น ยาที่ใช้บ่อย/สำคัญ
 * - N (Non-essential): ยาไม่จำเป็น ทดแทนได้
 *
 * Run: npx tsx scripts/migrate-phase18-ven-analysis.ts
 */

import { PrismaClient, VenCategory } from '@prisma/client';
import mysql from 'mysql2/promise';

const prisma = new PrismaClient();

async function main() {
  console.log('🚀 Phase 18: VEN Analysis Migration...\n');
  console.log('═══════════════════════════════════════════════════════════');
  console.log('   VEN_FLAG from MySQL → ven_category in PostgreSQL');
  console.log('═══════════════════════════════════════════════════════════\n');

  // Connect to MySQL
  const mysqlConn = await mysql.createConnection({
    host: 'localhost',
    port: 3307,
    user: 'invs_user',
    password: 'invs123',
    database: 'invs_banpong'
  });

  try {
    // Get VEN_FLAG from MySQL
    console.log('📋 Loading VEN_FLAG from MySQL drug_gn...');
    const [rows] = await mysqlConn.execute<mysql.RowDataPacket[]>(`
      SELECT WORKING_CODE, DRUG_NAME, VEN_FLAG
      FROM drug_gn
      WHERE VEN_FLAG IS NOT NULL AND VEN_FLAG != ''
    `);
    console.log(`   Found ${rows.length} records with VEN_FLAG\n`);

    // Count by category
    const counts = { V: 0, E: 0, N: 0 };
    for (const row of rows) {
      const flag = row.VEN_FLAG?.trim();
      if (flag === 'V' || flag === 'E' || flag === 'N') {
        counts[flag]++;
      }
    }
    console.log('   Distribution:');
    console.log(`      V (Vital):        ${counts.V}`);
    console.log(`      E (Essential):    ${counts.E}`);
    console.log(`      N (Non-essential): ${counts.N}\n`);

    // Build VEN lookup map
    const venMap = new Map<string, VenCategory>();
    for (const row of rows) {
      const code = row.WORKING_CODE?.trim();
      const flag = row.VEN_FLAG?.trim();
      if (code && (flag === 'V' || flag === 'E' || flag === 'N')) {
        venMap.set(code, flag as VenCategory);
      }
    }

    // Get all drug generics
    console.log('📋 Loading Drug Generics from PostgreSQL...');
    const drugGenerics = await prisma.drugGeneric.findMany({
      select: { id: true, workingCode: true, drugName: true }
    });
    console.log(`   Found ${drugGenerics.length} generics\n`);

    // Update VEN category
    console.log('🔗 Updating VEN category...');
    let updated = 0;
    let notFound = 0;
    const samples: Array<{ code: string; name: string; ven: string }> = [];

    for (const drug of drugGenerics) {
      const ven = venMap.get(drug.workingCode);

      if (ven) {
        await prisma.drugGeneric.update({
          where: { id: drug.id },
          data: { venCategory: ven }
        });
        updated++;

        if (samples.length < 15) {
          samples.push({
            code: drug.workingCode,
            name: drug.drugName,
            ven
          });
        }
      } else {
        notFound++;
      }
    }

    // Results
    console.log(`\n   ✅ Updated:   ${updated}`);
    console.log(`   ⚠️  No VEN:    ${notFound}`);
    console.log(`\n   📊 Coverage: ${(updated / drugGenerics.length * 100).toFixed(2)}%`);

    // Show samples by category
    console.log('\n   📝 Sample V (Vital) drugs:');
    const vitalSamples = samples.filter(s => s.ven === 'V');
    for (const s of vitalSamples.slice(0, 5)) {
      console.log(`      [V] ${s.code}: ${s.name}`);
    }

    console.log('\n   📝 Sample E (Essential) drugs:');
    const essentialSamples = samples.filter(s => s.ven === 'E');
    for (const s of essentialSamples.slice(0, 5)) {
      console.log(`      [E] ${s.code}: ${s.name}`);
    }

    // Final statistics
    console.log('\n═══════════════════════════════════════════════════════════');
    console.log('   📊 PHASE 18 COMPLETE');
    console.log('═══════════════════════════════════════════════════════════');

    const stats = await prisma.drugGeneric.groupBy({
      by: ['venCategory'],
      _count: true,
    });

    console.log('\n   Final VEN Distribution:');
    for (const s of stats) {
      const label = s.venCategory === 'V' ? 'Vital' :
                    s.venCategory === 'E' ? 'Essential' :
                    s.venCategory === 'N' ? 'Non-essential' : 'Not set';
      console.log(`      ${s.venCategory || 'NULL'} (${label}): ${s._count}`);
    }
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
    console.log('✅ Phase 18 completed!\n');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Phase 18 failed:', error);
    process.exit(1);
  });
