#!/usr/bin/env ts-node
/**
 * Phase 2 Data Migration Script
 * ================================
 * Migrates drug information tables from MySQL to PostgreSQL
 *
 * Tables:
 * - drug_components (drug_compos) - 736 records
 * - tmt_units (uom) - 85 records
 * - drug_focus_lists (focus_list) - 92 records
 *
 * Usage:
 *   npm run ts-node scripts/migrate-phase2-data.ts
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

interface MySQLDrugCompos {
  WORKING_CODE: string;
  COMPOS_NAME: string;
  COMPOS_CODE: number;
  TMTID: bigint | null;
}

interface MySQLUOM {
  UOM_ID: number;
  UOM_NAME: string | null;
}

interface MySQLFocusList {
  LIST_CODE: number;
  LIST_TYPE: number | null;
  USER_ID: string | null;
  DEPT_ID: string | null;
  LIST_NAME: string | null;
}

// Helper function to extract strength from component name
function extractStrength(componentName: string): { strength: string | null; strengthUnit: string | null } {
  // Match patterns like "500 MG", "100 MCG", "1 G", "50 ML", "1 G/50 ML"
  const strengthMatch = componentName.match(/(\d+(?:\.\d+)?)\s*(MCG|MG|G|ML|%|IU|UNIT|BAU)/i);

  if (strengthMatch) {
    return {
      strength: strengthMatch[1],
      strengthUnit: strengthMatch[2].toUpperCase(),
    };
  }

  return { strength: null, strengthUnit: null };
}

async function main() {
  console.log('🚀 Phase 2 Data Migration Starting...\n');

  let connection: mysql.Connection | undefined;

  try {
    // Connect to MySQL
    console.log('📡 Connecting to MySQL legacy database...');
    connection = await mysql.createConnection(mysqlConfig);
    console.log('✅ MySQL connected\n');

    // ========================================
    // 1. Migrate Units of Measure (uom → tmt_units)
    // ========================================
    console.log('📦 1/3: Migrating Units of Measure (uom → tmt_units)...');
    const [uoms] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM uom ORDER BY UOM_ID'
    );

    let uomCount = 0;
    for (const row of uoms as MySQLUOM[]) {
      if (!row.UOM_NAME) continue;

      const unitCode = `UOM${row.UOM_ID.toString().padStart(3, '0')}`;

      await prisma.tmtUnit.upsert({
        where: { unitCode },
        update: {
          unitName: row.UOM_NAME,
          unitType: 'measurement', // Generic type
          isActive: true,
        },
        create: {
          unitCode,
          unitName: row.UOM_NAME,
          unitType: 'measurement',
          isActive: true,
        },
      });
      uomCount++;
    }
    console.log(`✅ Migrated ${uomCount} units of measure\n`);

    // ========================================
    // 2. Migrate Drug Components (drug_compos → drug_components)
    // ========================================
    console.log('📦 2/3: Migrating Drug Components (drug_compos)...');
    console.log('⚠️  This may take a while (736 records)...\n');

    const [drugCompos] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM drug_compos ORDER BY COMPOS_CODE'
    );

    let componentCount = 0;
    let skippedCount = 0;
    let sequence = 1;
    let lastWorkingCode = '';

    for (const row of drugCompos as MySQLDrugCompos[]) {
      // Find drug generic by working code
      const generic = await prisma.drugGeneric.findFirst({
        where: { workingCode: row.WORKING_CODE },
      });

      if (!generic) {
        skippedCount++;
        continue;
      }

      // Reset sequence for new drug
      if (row.WORKING_CODE !== lastWorkingCode) {
        sequence = 1;
        lastWorkingCode = row.WORKING_CODE;
      }

      // Extract strength from component name
      const { strength, strengthUnit } = extractStrength(row.COMPOS_NAME);

      // Check if TMT concept exists
      let tmtConceptId: bigint | null = null;
      if (row.TMTID) {
        const tmtConcept = await prisma.tmtConcept.findFirst({
          where: { tmtId: BigInt(row.TMTID.toString()) },
        });
        tmtConceptId = tmtConcept?.id || null;
      }

      // Check if already exists
      const existing = await prisma.drugComponent.findFirst({
        where: {
          genericId: generic.id,
          componentName: row.COMPOS_NAME,
        },
      });

      if (existing) {
        // Update existing
        await prisma.drugComponent.update({
          where: { id: existing.id },
          data: {
            strength,
            strengthUnit,
            tmtConceptId,
            sequence,
            isActive: true,
          },
        });
      } else {
        // Create new
        await prisma.drugComponent.create({
          data: {
            genericId: generic.id,
            componentName: row.COMPOS_NAME,
            strength,
            strengthUnit,
            tmtConceptId,
            sequence,
            isActive: true,
          },
        });
      }

      componentCount++;
      sequence++;

      // Progress indicator
      if (componentCount % 100 === 0) {
        console.log(`   📊 Progress: ${componentCount} components migrated...`);
      }
    }

    console.log(`✅ Migrated ${componentCount} drug components`);
    if (skippedCount > 0) {
      console.log(`⚠️  Skipped ${skippedCount} records (generic not found in modern DB)\n`);
    }

    // ========================================
    // 3. Migrate Drug Focus Lists (focus_list → drug_focus_lists)
    // ========================================
    console.log('📦 3/3: Migrating Drug Focus Lists (focus_list)...');
    const [focusLists] = await connection.query<mysql.RowDataPacket[]>(
      'SELECT * FROM focus_list ORDER BY LIST_CODE'
    );

    let focusListCount = 0;
    let focusSkipped = 0;

    for (const row of focusLists as MySQLFocusList[]) {
      if (!row.LIST_NAME) {
        focusSkipped++;
        continue;
      }

      // Find drug by working code (LIST_CODE maps to drug)
      // Note: This might need adjustment based on actual data structure
      // For now, we'll skip if we can't find the drug

      // Try to find the drug - this is a simplistic approach
      // In reality, focus_list.LIST_CODE might link to a junction table
      // We'll create a placeholder implementation

      // Find department by code
      let departmentId: bigint | null = null;
      if (row.DEPT_ID) {
        const department = await prisma.department.findFirst({
          where: { deptCode: row.DEPT_ID },
        });
        departmentId = department?.id || null;
      }

      // For now, we'll skip this table as it requires drug master data
      // and the exact relationship is unclear without more context
      focusSkipped++;
    }

    console.log(`⚠️  Drug Focus Lists migration skipped (${focusSkipped} records)`);
    console.log(`   Reason: Requires drug master data and LIST_CODE mapping clarification\n`);

    // ========================================
    // Summary
    // ========================================
    console.log('\n' + '='.repeat(60));
    console.log('🎉 Phase 2 Data Migration Complete!');
    console.log('='.repeat(60));
    console.log(`✅ Units of Measure: ${uomCount}`);
    console.log(`✅ Drug Components: ${componentCount}`);
    console.log(`⚠️  Drug Focus Lists: 0 (pending drug master data)`);
    console.log('='.repeat(60) + '\n');

    // Verification
    console.log('🔍 Verifying data in PostgreSQL...');
    const counts = await Promise.all([
      prisma.tmtUnit.count(),
      prisma.drugComponent.count(),
      prisma.drugFocusList.count(),
    ]);

    console.log(`📊 TMT Units in DB: ${counts[0]}`);
    console.log(`📊 Drug Components in DB: ${counts[1]}`);
    console.log(`📊 Drug Focus Lists in DB: ${counts[2]}\n`);

    // Show sample components
    console.log('📋 Sample Drug Components:');
    const sampleComponents = await prisma.drugComponent.findMany({
      take: 5,
      include: {
        generic: {
          select: {
            workingCode: true,
            drugName: true,
          },
        },
      },
    });

    for (const comp of sampleComponents) {
      console.log(`   - ${comp.generic.drugName} (${comp.generic.workingCode})`);
      console.log(`     Component: ${comp.componentName}`);
      if (comp.strength) {
        console.log(`     Strength: ${comp.strength} ${comp.strengthUnit || ''}`);
      }
    }

    console.log('\n✅ Migration completed successfully!');
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
