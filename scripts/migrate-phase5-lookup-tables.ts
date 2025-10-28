/**
 * Phase 5: Import Lookup Tables
 * Priority 1 & 2 Master Data Lookups
 *
 * Tables to import:
 * 1. DosageForm (107 records from MySQL dosage_form)
 * 2. DrugUnit (88 records from MySQL sale_unit)
 * 3. AdjustmentReason (New data - standard reasons)
 * 4. Hospital (13,176 records from MySQL hosp)
 * 5. ReturnAction (New data - standard actions)
 *
 * Run: npx tsx scripts/migrate-phase5-lookup-tables.ts
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

async function main() {
  console.log('🚀 Phase 5: Importing Lookup Tables...\n');

  const mysqlConn = await mysql.createConnection(mysqlConfig);

  try {
    // ===========================================
    // 1. Import DosageForm (Priority 1)
    // ===========================================
    console.log('📋 1/5: Importing Dosage Forms...');
    const [dosageForms] = await mysqlConn.query<any[]>(`
      SELECT
        DFORM_ID as id,
        DFORM_NAME as name,
        HIDE as isHidden
      FROM dosage_form
      ORDER BY DFORM_ID
    `);

    let dosageFormCount = 0;
    for (const df of dosageForms) {
      await prisma.dosageForm.upsert({
        where: { code: String(df.id) },
        create: {
          code: String(df.id),
          name: df.name?.trim() || `Form-${df.id}`,
          isHidden: df.isHidden === 'Y',
        },
        update: {
          name: df.name?.trim() || `Form-${df.id}`,
          isHidden: df.isHidden === 'Y',
        },
      });
      dosageFormCount++;
    }
    console.log(`   ✅ Imported ${dosageFormCount} dosage forms\n`);

    // ===========================================
    // 2. Import DrugUnit (Priority 1)
    // ===========================================
    console.log('📋 2/5: Importing Drug Units...');
    const [drugUnits] = await mysqlConn.query<any[]>(`
      SELECT
        SU_ID as id,
        SALE_UNIT as name,
        SU_ID_EX as standardCode,
        HIDE as isHidden
      FROM sale_unit
      ORDER BY SU_ID
    `);

    let drugUnitCount = 0;
    for (const unit of drugUnits) {
      await prisma.drugUnit.upsert({
        where: { code: String(unit.id) },
        create: {
          code: String(unit.id),
          name: unit.name?.trim() || `Unit-${unit.id}`,
          standardCode: unit.standardCode?.trim() || null,
          isHidden: unit.isHidden === 'Y',
        },
        update: {
          name: unit.name?.trim() || `Unit-${unit.id}`,
          standardCode: unit.standardCode?.trim() || null,
          isHidden: unit.isHidden === 'Y',
        },
      });
      drugUnitCount++;
    }
    console.log(`   ✅ Imported ${drugUnitCount} drug units\n`);

    // ===========================================
    // 3. Create AdjustmentReason (Priority 1)
    // ===========================================
    console.log('📋 3/5: Creating Adjustment Reasons...');
    const adjustmentReasons = [
      { code: 1, reason: 'สินค้าชำรุด/เสียหาย', category: 'damage' },
      { code: 2, reason: 'สูญหาย', category: 'loss' },
      { code: 3, reason: 'พบสินค้าเกิน', category: 'found' },
      { code: 4, reason: 'ยาหมดอายุ', category: 'expired' },
      { code: 5, reason: 'ปรับปรุงยอดตามนับจริง', category: 'physical_count' },
      { code: 6, reason: 'แก้ไขข้อผิดพลาดระบบ', category: 'system_error' },
      { code: 7, reason: 'ส่งคืนผู้จำหน่าย', category: 'return_vendor' },
      { code: 8, reason: 'ทำลายทิ้ง', category: 'disposal' },
      { code: 9, reason: 'โอนย้ายหน่วยงาน', category: 'transfer' },
      { code: 10, reason: 'อื่นๆ', category: 'other' },
    ];

    let adjReasonCount = 0;
    for (const reason of adjustmentReasons) {
      await prisma.adjustmentReason.upsert({
        where: { code: reason.code },
        create: reason,
        update: { reason: reason.reason, category: reason.category },
      });
      adjReasonCount++;
    }
    console.log(`   ✅ Created ${adjReasonCount} adjustment reasons\n`);

    // ===========================================
    // 4. Import Hospital (Priority 2)
    // ===========================================
    console.log('📋 4/5: Importing Hospitals (this may take a while)...');
    const [hospitals] = await mysqlConn.query<any[]>(`
      SELECT
        HOSP_CODE as hospCode,
        HOSP_NAME as hospName
      FROM hosp
      ORDER BY HOSP_CODE
    `);

    let hospitalCount = 0;
    const batchSize = 1000;

    for (let i = 0; i < hospitals.length; i += batchSize) {
      const batch = hospitals.slice(i, i + batchSize);

      await prisma.$transaction(
        batch.map(hosp =>
          prisma.hospital.upsert({
            where: { hospCode: hosp.hospCode },
            create: {
              hospCode: hosp.hospCode,
              hospName: hosp.hospName?.trim() || `Hospital-${hosp.hospCode}`,
            },
            update: {
              hospName: hosp.hospName?.trim() || `Hospital-${hosp.hospCode}`,
            },
          })
        )
      );

      hospitalCount += batch.length;
      process.stdout.write(`\r   Progress: ${hospitalCount}/${hospitals.length} hospitals`);
    }
    console.log(`\n   ✅ Imported ${hospitalCount} hospitals\n`);

    // ===========================================
    // 5. Create ReturnAction (Priority 2)
    // ===========================================
    console.log('📋 5/5: Creating Return Actions...');
    const returnActions = [
      { code: 1, action: 'คืนเข้าคลัง (Restock)', actionType: 'restock' },
      { code: 2, action: 'ทำลายทิ้ง (Dispose)', actionType: 'dispose' },
      { code: 3, action: 'กักกัน (Quarantine)', actionType: 'quarantine' },
      { code: 4, action: 'คืนผู้จำหน่าย (Return to Vendor)', actionType: 'return_vendor' },
      { code: 5, action: 'ส่งซ่อม/แลกเปลี่ยน', actionType: 'repair_exchange' },
      { code: 6, action: 'โอนไปหน่วยงานอื่น', actionType: 'transfer' },
      { code: 7, action: 'รอตรวจสอบ', actionType: 'pending_inspection' },
      { code: 8, action: 'อื่นๆ', actionType: 'other' },
    ];

    let returnActionCount = 0;
    for (const action of returnActions) {
      await prisma.returnAction.upsert({
        where: { code: action.code },
        create: action,
        update: { action: action.action, actionType: action.actionType },
      });
      returnActionCount++;
    }
    console.log(`   ✅ Created ${returnActionCount} return actions\n`);

    // ===========================================
    // Summary
    // ===========================================
    console.log('═══════════════════════════════════════');
    console.log('✅ Phase 5 Migration Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   Dosage Forms:        ${dosageFormCount.toLocaleString()} records`);
    console.log(`   Drug Units:          ${drugUnitCount.toLocaleString()} records`);
    console.log(`   Adjustment Reasons:  ${adjReasonCount.toLocaleString()} records`);
    console.log(`   Hospitals:           ${hospitalCount.toLocaleString()} records`);
    console.log(`   Return Actions:      ${returnActionCount.toLocaleString()} records`);
    console.log('═══════════════════════════════════════');
    console.log(`   Total:               ${(dosageFormCount + drugUnitCount + adjReasonCount + hospitalCount + returnActionCount).toLocaleString()} records`);
    console.log('═══════════════════════════════════════\n');

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
