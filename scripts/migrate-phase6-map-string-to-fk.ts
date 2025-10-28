/**
 * Phase 6: Map Existing String Fields to FK
 * แปลงข้อมูลเดิมจาก String → Foreign Keys
 *
 * Target:
 * 1. drug_generics: dosageForm, saleUnit → dosageFormId, saleUnitId
 * 2. drugs: dosageForm, unit → dosageFormId, unitId
 *
 * Run: npx tsx scripts/migrate-phase6-map-string-to-fk.ts
 */

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Helper function to normalize string for matching
function normalize(str: string | null): string {
  if (!str) return '';
  return str.trim().toUpperCase();
}

async function main() {
  console.log('🚀 Phase 6: Mapping String Fields to Foreign Keys...\n');

  try {
    // ===========================================
    // 1. Load all DosageForms and DrugUnits
    // ===========================================
    console.log('📋 Loading lookup tables...');
    const allDosageForms = await prisma.dosageForm.findMany();
    const allDrugUnits = await prisma.drugUnit.findMany();

    console.log(`   Found ${allDosageForms.length} dosage forms`);
    console.log(`   Found ${allDrugUnits.length} drug units\n`);

    // Create mapping dictionaries
    const dosageFormMap = new Map<string, bigint>();
    const drugUnitMap = new Map<string, bigint>();

    // Map dosage forms by normalized name
    for (const form of allDosageForms) {
      const normalized = normalize(form.name);
      dosageFormMap.set(normalized, form.id);
      // Also map English name if exists
      if (form.nameEn) {
        dosageFormMap.set(normalize(form.nameEn), form.id);
      }
    }

    // Map drug units by normalized name
    for (const unit of allDrugUnits) {
      const normalized = normalize(unit.name);
      drugUnitMap.set(normalized, unit.id);
      // Also map English name if exists
      if (unit.nameEn) {
        drugUnitMap.set(normalize(unit.nameEn), unit.id);
      }
    }

    // ===========================================
    // 2. Update DrugGeneric records
    // ===========================================
    console.log('💊 Updating DrugGeneric records...');
    const generics = await prisma.drugGeneric.findMany({
      where: {
        OR: [
          { dosageFormId: null },
          { saleUnitId: null }
        ]
      }
    });

    console.log(`   Found ${generics.length} generics to update`);

    let genericUpdated = 0;
    let genericDosageFormMatched = 0;
    let genericSaleUnitMatched = 0;
    const genericUnmatched: string[] = [];

    for (const generic of generics) {
      let dosageFormId = generic.dosageFormId;
      let saleUnitId = generic.saleUnitId;
      let updated = false;

      // Map dosageForm
      if (!dosageFormId && generic.dosageForm) {
        const normalized = normalize(generic.dosageForm);
        dosageFormId = dosageFormMap.get(normalized) || null;
        if (dosageFormId) {
          genericDosageFormMatched++;
          updated = true;
        } else {
          genericUnmatched.push(`Generic ${generic.workingCode}: dosageForm="${generic.dosageForm}" not found`);
        }
      }

      // Map saleUnit
      if (!saleUnitId && generic.saleUnit) {
        const normalized = normalize(generic.saleUnit);
        saleUnitId = drugUnitMap.get(normalized) || null;
        if (saleUnitId) {
          genericSaleUnitMatched++;
          updated = true;
        } else {
          genericUnmatched.push(`Generic ${generic.workingCode}: saleUnit="${generic.saleUnit}" not found`);
        }
      }

      // Update if any FK was found
      if (updated) {
        await prisma.drugGeneric.update({
          where: { id: generic.id },
          data: {
            dosageFormId,
            saleUnitId
          }
        });
        genericUpdated++;

        if (genericUpdated % 100 === 0) {
          process.stdout.write(`\r   Progress: ${genericUpdated}/${generics.length} generics updated`);
        }
      }
    }

    console.log(`\n   ✅ Updated ${genericUpdated} drug generics`);
    console.log(`      - Dosage forms matched: ${genericDosageFormMatched}`);
    console.log(`      - Sale units matched:   ${genericSaleUnitMatched}`);
    if (genericUnmatched.length > 0) {
      console.log(`      - Unmatched: ${genericUnmatched.length} (see details below)\n`);
    }

    // ===========================================
    // 3. Update Drug records
    // ===========================================
    console.log('\n💊 Updating Drug records...');
    const drugs = await prisma.drug.findMany({
      where: {
        OR: [
          { dosageFormId: null },
          { unitId: null }
        ]
      }
    });

    console.log(`   Found ${drugs.length} drugs to update`);

    let drugUpdated = 0;
    let drugDosageFormMatched = 0;
    let drugUnitMatched = 0;
    const drugUnmatched: string[] = [];

    for (const drug of drugs) {
      let dosageFormId = drug.dosageFormId;
      let unitId = drug.unitId;
      let updated = false;

      // Map dosageForm
      if (!dosageFormId && drug.dosageForm) {
        const normalized = normalize(drug.dosageForm);
        dosageFormId = dosageFormMap.get(normalized) || null;
        if (dosageFormId) {
          drugDosageFormMatched++;
          updated = true;
        } else {
          drugUnmatched.push(`Drug ${drug.drugCode}: dosageForm="${drug.dosageForm}" not found`);
        }
      }

      // Map unit
      if (!unitId && drug.unit) {
        const normalized = normalize(drug.unit);
        unitId = drugUnitMap.get(normalized) || null;
        if (unitId) {
          drugUnitMatched++;
          updated = true;
        } else {
          drugUnmatched.push(`Drug ${drug.drugCode}: unit="${drug.unit}" not found`);
        }
      }

      // Update if any FK was found
      if (updated) {
        await prisma.drug.update({
          where: { id: drug.id },
          data: {
            dosageFormId,
            unitId
          }
        });
        drugUpdated++;

        if (drugUpdated % 100 === 0) {
          process.stdout.write(`\r   Progress: ${drugUpdated}/${drugs.length} drugs updated`);
        }
      }
    }

    console.log(`\n   ✅ Updated ${drugUpdated} trade drugs`);
    console.log(`      - Dosage forms matched: ${drugDosageFormMatched}`);
    console.log(`      - Units matched:        ${drugUnitMatched}`);
    if (drugUnmatched.length > 0) {
      console.log(`      - Unmatched: ${drugUnmatched.length} (see details below)\n`);
    }

    // ===========================================
    // 4. Summary and Unmatched Report
    // ===========================================
    console.log('\n═══════════════════════════════════════');
    console.log('✅ Phase 6 Migration Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   DrugGenerics Updated:  ${genericUpdated.toLocaleString()}`);
    console.log(`   Drugs Updated:         ${drugUpdated.toLocaleString()}`);
    console.log('═══════════════════════════════════════');
    console.log(`   Total Updated:         ${(genericUpdated + drugUpdated).toLocaleString()}`);
    console.log('═══════════════════════════════════════\n');

    // Show unmatched items
    if (genericUnmatched.length > 0 || drugUnmatched.length > 0) {
      console.log('⚠️  Unmatched Items (need manual review):');
      console.log('─────────────────────────────────────────\n');

      if (genericUnmatched.length > 0) {
        console.log(`DrugGeneric Unmatched (${genericUnmatched.length}):`);
        // Show first 20 only
        genericUnmatched.slice(0, 20).forEach(msg => console.log(`   - ${msg}`));
        if (genericUnmatched.length > 20) {
          console.log(`   ... and ${genericUnmatched.length - 20} more\n`);
        }
      }

      if (drugUnmatched.length > 0) {
        console.log(`\nDrug Unmatched (${drugUnmatched.length}):`);
        // Show first 20 only
        drugUnmatched.slice(0, 20).forEach(msg => console.log(`   - ${msg}`));
        if (drugUnmatched.length > 20) {
          console.log(`   ... and ${drugUnmatched.length - 20} more\n`);
        }
      }

      console.log('\n💡 Tip: Run migrate-phase5-lookup-tables.ts again to import all 107 dosage forms and 88 units');
      console.log('   Then re-run this script to map the remaining items.\n');
    }

    // Verification
    console.log('🔍 Verification:');
    const genericsWithFK = await prisma.drugGeneric.count({
      where: {
        AND: [
          { dosageFormId: { not: null } },
          { saleUnitId: { not: null } }
        ]
      }
    });
    const genericsTotal = await prisma.drugGeneric.count();

    const drugsWithFK = await prisma.drug.count({
      where: {
        AND: [
          { dosageFormId: { not: null } },
          { unitId: { not: null } }
        ]
      }
    });
    const drugsTotal = await prisma.drug.count();

    console.log(`   DrugGenerics with FK: ${genericsWithFK}/${genericsTotal} (${(genericsWithFK/genericsTotal*100).toFixed(1)}%)`);
    console.log(`   Drugs with FK:        ${drugsWithFK}/${drugsTotal} (${(drugsWithFK/drugsTotal*100).toFixed(1)}%)`);

  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
