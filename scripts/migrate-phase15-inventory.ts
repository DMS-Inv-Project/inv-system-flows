/**
 * Phase 15: Import Inventory Data
 * ข้อมูลคงคลัง (Stock levels & Lot tracking)
 *
 * Source: MySQL
 * - inv_md (7,106 records) → inventory
 * - inv_md_c (6,592 records) → drug_lots
 *
 * Run: npx tsx scripts/migrate-phase15-inventory.ts
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

interface InvMdRow {
  RECORD_NUMBER: number;
  WORKING_CODE: string | null;
  QTY_ON_HAND: number | null;
  MIN_LEVEL: number | null;
  MAX_LEVEL: number | null;
  REORDER_QTY: number | null;
  STD_PRICE: number | null;
  RATE: number | null;
  DEPT_ID: string | null;
  LOCATION: string | null;
  HIDE: string | null;
}

interface InvMdCRow {
  RECORD_NUMBER: number;
  WORKING_CODE: string | null;
  TRADE_CODE: string | null;
  LOT_NO: string | null;
  EXPIRED_DATE: string | null;
  QTY_ON_HAND: number | null;
  LOT_COST: number | null;
  PACK_COST: number | null;
  VENDOR_CODE: string | null;
  MANUFAC_CODE: string | null;
  DEPT_ID: string | null;
  LOCATION: string | null;
  BAR_CODE: string | null;
}

async function main() {
  console.log('🚀 Phase 15: Importing Inventory Data...\\n');

  const mysqlConn = await mysql.createConnection(mysqlConfig);

  try {
    // ===========================================
    // Step 1: Build lookup maps
    // ===========================================
    console.log('📋 Step 1/4: Building lookup maps...');

    // Map working_code → generic.id
    const generics = await prisma.drugGeneric.findMany({
      select: { id: true, workingCode: true }
    });
    const workingCodeToGenericId = new Map<string, bigint>();
    for (const g of generics) {
      workingCodeToGenericId.set(g.workingCode.trim(), g.id);
    }
    console.log(`   - Generic codes: ${workingCodeToGenericId.size}`);

    // Map drug_code → drug.id
    const drugs = await prisma.drug.findMany({
      select: { id: true, drugCode: true, genericId: true }
    });
    const drugCodeToId = new Map<string, bigint>();
    const drugCodeToGenericId = new Map<string, bigint | null>();
    for (const d of drugs) {
      drugCodeToId.set(d.drugCode.trim(), d.id);
      drugCodeToGenericId.set(d.drugCode.trim(), d.genericId);
    }
    console.log(`   - Drug codes: ${drugCodeToId.size}`);

    // Map dept_code → department.id (for location)
    const departments = await prisma.department.findMany({
      select: { id: true, deptCode: true }
    });
    const deptCodeToId = new Map<string, bigint>();
    for (const d of departments) {
      deptCodeToId.set(d.deptCode.trim(), d.id);
    }
    console.log(`   - Department codes: ${deptCodeToId.size}`);

    // Map location_code → location.id
    const locations = await prisma.location.findMany({
      select: { id: true, locationCode: true }
    });
    const locationCodeToId = new Map<string, bigint>();
    for (const l of locations) {
      locationCodeToId.set(l.locationCode.trim(), l.id);
    }
    console.log(`   - Location codes: ${locationCodeToId.size}`);

    // Map company_code → company.id
    const companies = await prisma.company.findMany({
      select: { id: true, companyCode: true }
    });
    const companyCodeToId = new Map<string, bigint>();
    for (const c of companies) {
      companyCodeToId.set(c.companyCode.trim(), c.id);
      // Also map without leading zeros
      const numericCode = parseInt(c.companyCode.trim(), 10);
      if (!isNaN(numericCode)) {
        companyCodeToId.set(String(numericCode), c.id);
      }
    }
    console.log(`   - Company codes: ${companyCodeToId.size}`);
    console.log('   ✅ Lookup maps ready\\n');

    // ===========================================
    // Step 2: Create locations from departments
    // ===========================================
    console.log('📋 Step 2/4: Creating locations from departments...');
    const [invDepts] = await mysqlConn.query<any[]>(`
      SELECT DISTINCT DEPT_ID FROM inv_md WHERE DEPT_ID IS NOT NULL
    `);

    let locationsCreated = 0;
    for (const row of invDepts) {
      const deptCode = row.DEPT_ID?.trim();
      if (!deptCode) continue;

      if (!locationCodeToId.has(deptCode)) {
        const deptName = (await prisma.department.findFirst({
          where: { deptCode: deptCode },
          select: { deptName: true }
        }))?.deptName || `Location ${deptCode}`;

        const location = await prisma.location.create({
          data: {
            locationCode: deptCode,
            locationName: deptName,
            locationType: 'PHARMACY',
            isActive: true
          }
        });
        locationCodeToId.set(deptCode, location.id);
        locationsCreated++;
      }
    }
    console.log(`   ✅ Created ${locationsCreated} new locations\\n`);

    // ===========================================
    // Step 3: Import Inventory (inv_md)
    // ===========================================
    console.log('📋 Step 3/4: Importing Inventory (inv_md)...');
    const [invMd] = await mysqlConn.query<InvMdRow[]>(`
      SELECT
        RECORD_NUMBER, WORKING_CODE, QTY_ON_HAND, MIN_LEVEL, MAX_LEVEL,
        REORDER_QTY, STD_PRICE, RATE, DEPT_ID, LOCATION, HIDE
      FROM inv_md
      WHERE HIDE IS NULL OR HIDE != 'Y'
      ORDER BY DEPT_ID, WORKING_CODE
    `);
    console.log(`   Source: ${invMd.length} inventory records`);

    let invImported = 0;
    let invSkipped = 0;

    for (const row of invMd) {
      if (!row.WORKING_CODE || !row.DEPT_ID) {
        invSkipped++;
        continue;
      }

      const workingCode = row.WORKING_CODE.trim();
      const deptCode = row.DEPT_ID.trim();

      // Try to get drug directly by drug_code (often same as working_code)
      let drugId = drugCodeToId.get(workingCode);

      // If not found, try to find via generic
      if (!drugId) {
        const genericId = workingCodeToGenericId.get(workingCode);
        if (genericId) {
          const drug = await prisma.drug.findFirst({
            where: { genericId: genericId },
            select: { id: true }
          });
          drugId = drug?.id;
        }
      }

      if (!drugId) {
        invSkipped++;
        continue;
      }

      // Get location ID
      let locationId = locationCodeToId.get(deptCode);
      if (!locationId) {
        // Create location on the fly
        const loc = await prisma.location.create({
          data: {
            locationCode: deptCode,
            locationName: `Location ${deptCode}`,
            locationType: 'PHARMACY',
            isActive: true
          }
        });
        locationId = loc.id;
        locationCodeToId.set(deptCode, locationId);
      }

      try {
        // Check if exists
        const existing = await prisma.inventory.findFirst({
          where: {
            drugId: drugId,
            locationId: locationId
          }
        });

        if (existing) {
          await prisma.inventory.update({
            where: { id: existing.id },
            data: {
              quantityOnHand: row.QTY_ON_HAND || 0,
              minLevel: row.MIN_LEVEL || 0,
              maxLevel: row.MAX_LEVEL || 0,
              reorderPoint: row.REORDER_QTY || 0,
              averageCost: row.STD_PRICE ? Number(row.STD_PRICE) : 0,
              lastCost: row.STD_PRICE ? Number(row.STD_PRICE) : 0,
            }
          });
        } else {
          await prisma.inventory.create({
            data: {
              drugId: drugId,
              locationId: locationId,
              quantityOnHand: row.QTY_ON_HAND || 0,
              minLevel: row.MIN_LEVEL || 0,
              maxLevel: row.MAX_LEVEL || 0,
              reorderPoint: row.REORDER_QTY || 0,
              averageCost: row.STD_PRICE ? Number(row.STD_PRICE) : 0,
              lastCost: row.STD_PRICE ? Number(row.STD_PRICE) : 0,
            }
          });
          invImported++;
        }

        if (invImported % 500 === 0 && invImported > 0) {
          process.stdout.write(`\\r   Progress: ${invImported} inventory records imported`);
        }
      } catch (err: any) {
        invSkipped++;
      }
    }

    console.log(`\\r   Progress: ${invImported} inventory records imported\\n`);

    // ===========================================
    // Step 4: Import Drug Lots (inv_md_c)
    // ===========================================
    console.log('📋 Step 4/4: Importing Drug Lots (inv_md_c)...');
    const [invMdC] = await mysqlConn.query<InvMdCRow[]>(`
      SELECT
        RECORD_NUMBER, WORKING_CODE, TRADE_CODE, LOT_NO, EXPIRED_DATE,
        QTY_ON_HAND, LOT_COST, PACK_COST, VENDOR_CODE, MANUFAC_CODE,
        DEPT_ID, LOCATION, BAR_CODE
      FROM inv_md_c
      WHERE QTY_ON_HAND > 0
      ORDER BY EXPIRED_DATE
    `);
    console.log(`   Source: ${invMdC.length} lot records (with stock > 0)`);

    let lotsImported = 0;
    let lotsSkipped = 0;

    for (const row of invMdC) {
      if (!row.WORKING_CODE && !row.TRADE_CODE) {
        lotsSkipped++;
        continue;
      }

      // Get drug ID
      let drugId: bigint | null = null;

      if (row.TRADE_CODE) {
        drugId = drugCodeToId.get(row.TRADE_CODE.trim()) || null;
      }

      if (!drugId && row.WORKING_CODE) {
        const genericId = workingCodeToGenericId.get(row.WORKING_CODE.trim());
        if (genericId) {
          const drug = await prisma.drug.findFirst({
            where: { genericId: genericId },
            select: { id: true }
          });
          drugId = drug?.id || null;
        }
      }

      if (!drugId) {
        lotsSkipped++;
        continue;
      }

      // Get location ID
      const deptCode = row.DEPT_ID?.trim();
      let locationId = deptCode ? locationCodeToId.get(deptCode) : null;

      if (!locationId && deptCode) {
        const loc = await prisma.location.create({
          data: {
            locationCode: deptCode,
            locationName: `Location ${deptCode}`,
            locationType: 'PHARMACY',
            isActive: true
          }
        });
        locationId = loc.id;
        locationCodeToId.set(deptCode, locationId);
      }

      if (!locationId) {
        locationId = (await prisma.location.findFirst())?.id || BigInt(1);
      }

      // Parse expiry date
      let expiryDate: Date | null = null;
      if (row.EXPIRED_DATE) {
        const dateStr = row.EXPIRED_DATE.trim();
        if (dateStr.length === 8) {
          // Format: YYYYMMDD
          const year = parseInt(dateStr.substring(0, 4));
          const month = parseInt(dateStr.substring(4, 6)) - 1;
          const day = parseInt(dateStr.substring(6, 8));
          expiryDate = new Date(year, month, day);
        } else if (dateStr.includes('-')) {
          expiryDate = new Date(dateStr);
        }
      }

      // Get vendor/manufacturer
      let vendorId: bigint | null = null;
      if (row.VENDOR_CODE) {
        vendorId = companyCodeToId.get(row.VENDOR_CODE.trim()) ||
                   companyCodeToId.get(row.VENDOR_CODE.trim().padStart(6, '0')) || null;
      }

      let manufacturerId: bigint | null = null;
      if (row.MANUFAC_CODE) {
        manufacturerId = companyCodeToId.get(row.MANUFAC_CODE.trim()) ||
                        companyCodeToId.get(row.MANUFAC_CODE.trim().padStart(6, '0')) || null;
      }

      const lotNo = row.LOT_NO?.trim() || `LOT-${row.RECORD_NUMBER}`;

      // Skip if no valid expiry date
      if (!expiryDate || isNaN(expiryDate.getTime())) {
        lotsSkipped++;
        continue;
      }

      try {
        // Check if lot exists
        const existingLot = await prisma.drugLot.findFirst({
          where: {
            drugId: drugId,
            locationId: locationId,
            lotNumber: lotNo
          }
        });

        if (existingLot) {
          await prisma.drugLot.update({
            where: { id: existingLot.id },
            data: {
              quantityAvailable: row.QTY_ON_HAND || 0,
              expiryDate: expiryDate,
              unitCost: row.LOT_COST ? Number(row.LOT_COST) : 0,
            }
          });
        } else {
          await prisma.drugLot.create({
            data: {
              drugId: drugId,
              locationId: locationId,
              lotNumber: lotNo.slice(0, 20),  // Max 20 chars
              quantityAvailable: row.QTY_ON_HAND || 0,
              expiryDate: expiryDate,
              unitCost: row.LOT_COST ? Number(row.LOT_COST) : 0,
              receivedDate: new Date(),
              isActive: true
            }
          });
          lotsImported++;
        }

        if (lotsImported % 500 === 0 && lotsImported > 0) {
          process.stdout.write(`\\r   Progress: ${lotsImported} lot records imported`);
        }
      } catch (err) {
        lotsSkipped++;
      }
    }

    console.log(`\\r   Progress: ${lotsImported} lot records imported\\n`);

    // ===========================================
    // Summary
    // ===========================================
    console.log('═══════════════════════════════════════');
    console.log('✅ Phase 15 Migration Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   Locations created:  ${locationsCreated}`);
    console.log(`   Inventory records:  ${invImported} imported, ${invSkipped} skipped`);
    console.log(`   Drug lots:          ${lotsImported} imported, ${lotsSkipped} skipped`);
    console.log('═══════════════════════════════════════');

    // Verify
    const finalCounts = await Promise.all([
      prisma.location.count(),
      prisma.inventory.count(),
      prisma.drugLot.count()
    ]);

    console.log(`\\n📊 Final counts:`);
    console.log(`   locations: ${finalCounts[0]}`);
    console.log(`   inventory: ${finalCounts[1]}`);
    console.log(`   drug_lots: ${finalCounts[2]}`);

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
