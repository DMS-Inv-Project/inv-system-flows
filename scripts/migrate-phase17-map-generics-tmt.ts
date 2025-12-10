/**
 * Phase 17: Map DrugGenerics to TMT Concepts (GP Level)
 *
 * Strategy:
 * 1. Extract key drug name from drug_generics (remove dosage, form, etc.)
 * 2. Match with tmt_concepts GP level by fsn/preferred_term
 * 3. Update drug_generics.tmt_gp_id
 *
 * Run: npx tsx scripts/migrate-phase17-map-generics-tmt.ts
 */

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

/**
 * Normalize drug name for matching
 * - Convert to lowercase
 * - Remove special characters
 * - Extract main ingredient name
 */
function normalizeDrugName(name: string): string {
  return name
    .toLowerCase()
    .replace(/\(.*?\)/g, '') // Remove parentheses content
    .replace(/\*|!|@|#|\$/g, '') // Remove special chars
    .replace(/\d+\s*(mg|g|ml|mcg|iu|%)/gi, '') // Remove dosage
    .replace(/tab|cap|inj|syr|susp|cream|oint|sol|powder|tablet|capsule|injection|syrup/gi, '') // Remove dosage forms
    .replace(/\s+/g, ' ')
    .trim();
}

/**
 * Extract main ingredient from drug name
 */
function extractMainIngredient(name: string): string {
  const normalized = normalizeDrugName(name);
  // Get first word (usually main ingredient)
  const words = normalized.split(' ').filter(w => w.length > 2);
  return words[0] || normalized;
}

async function main() {
  console.log('🚀 Phase 17: Mapping Drug Generics to TMT Concepts...\n');
  console.log('═══════════════════════════════════════════════════════════');
  console.log('   Drug Generics → TMT GP Level Mapping');
  console.log('═══════════════════════════════════════════════════════════\n');

  try {
    // Get all GP level TMT concepts
    console.log('📋 Loading TMT Concepts (GP level)...');
    const tmtGpConcepts = await prisma.tmtConcept.findMany({
      where: { level: 'GP' },
      select: { id: true, tmtId: true, fsn: true, preferredTerm: true }
    });
    console.log(`   Found ${tmtGpConcepts.length} GP concepts\n`);

    // Build search index
    const tmtIndex = new Map<string, { id: bigint; tmtId: bigint; fsn: string }>();
    for (const tmt of tmtGpConcepts) {
      // Index by normalized fsn
      const normalizedFsn = normalizeDrugName(tmt.fsn || '');
      const mainIngredient = extractMainIngredient(tmt.fsn || '');

      if (normalizedFsn) {
        tmtIndex.set(normalizedFsn, { id: tmt.id, tmtId: tmt.tmtId, fsn: tmt.fsn || '' });
      }
      if (mainIngredient && mainIngredient.length > 3) {
        if (!tmtIndex.has(mainIngredient)) {
          tmtIndex.set(mainIngredient, { id: tmt.id, tmtId: tmt.tmtId, fsn: tmt.fsn || '' });
        }
      }
    }
    console.log(`   Built index with ${tmtIndex.size} entries\n`);

    // Get all drug generics
    console.log('📋 Loading Drug Generics...');
    const drugGenerics = await prisma.drugGeneric.findMany({
      select: { id: true, workingCode: true, drugName: true, tmtGpId: true }
    });
    console.log(`   Found ${drugGenerics.length} generics\n`);

    // Match and update
    console.log('🔗 Matching drug generics to TMT...');
    let matchedCount = 0;
    let alreadyMappedCount = 0;
    let unmatchedCount = 0;
    const unmatchedSamples: string[] = [];

    for (const drug of drugGenerics) {
      // Skip if already mapped
      if (drug.tmtGpId) {
        alreadyMappedCount++;
        continue;
      }

      const normalizedName = normalizeDrugName(drug.drugName);
      const mainIngredient = extractMainIngredient(drug.drugName);

      // Try exact match first
      let match = tmtIndex.get(normalizedName);

      // Try main ingredient match
      if (!match && mainIngredient) {
        match = tmtIndex.get(mainIngredient);
      }

      // Try fuzzy match (find TMT containing the main ingredient)
      if (!match && mainIngredient && mainIngredient.length > 3) {
        for (const [key, value] of tmtIndex) {
          if (key.includes(mainIngredient) || mainIngredient.includes(key)) {
            match = value;
            break;
          }
        }
      }

      if (match) {
        await prisma.drugGeneric.update({
          where: { id: drug.id },
          data: { tmtGpId: match.id }
        });
        matchedCount++;

        if (matchedCount % 100 === 0) {
          process.stdout.write(`\r   Progress: ${matchedCount} matched`);
        }
      } else {
        unmatchedCount++;
        if (unmatchedSamples.length < 20) {
          unmatchedSamples.push(`${drug.workingCode}: ${drug.drugName}`);
        }
      }
    }

    console.log(`\n\n   ✅ Matched: ${matchedCount}`);
    console.log(`   ⏭️  Already mapped: ${alreadyMappedCount}`);
    console.log(`   ❌ Unmatched: ${unmatchedCount}`);

    // Show coverage
    const totalProcessed = matchedCount + alreadyMappedCount + unmatchedCount;
    const coverage = ((matchedCount + alreadyMappedCount) / totalProcessed * 100).toFixed(2);
    console.log(`\n   📊 Coverage: ${coverage}%`);

    // Show unmatched samples
    if (unmatchedSamples.length > 0) {
      console.log('\n   📝 Unmatched samples (first 20):');
      unmatchedSamples.forEach(s => console.log(`      - ${s}`));
    }

    // Final statistics
    console.log('\n═══════════════════════════════════════════════════════════');
    console.log('   📊 PHASE 17 COMPLETE');
    console.log('═══════════════════════════════════════════════════════════');

    const finalStats = await prisma.drugGeneric.groupBy({
      by: ['tmtGpId'],
      _count: true,
    });

    const withTmt = finalStats.filter(s => s.tmtGpId !== null).reduce((a, s) => a + s._count, 0);
    const withoutTmt = finalStats.filter(s => s.tmtGpId === null).reduce((a, s) => a + s._count, 0);

    console.log(`   Drug Generics with TMT:    ${withTmt}`);
    console.log(`   Drug Generics without TMT: ${withoutTmt}`);
    console.log(`   Total:                     ${withTmt + withoutTmt}`);
    console.log('═══════════════════════════════════════════════════════════\n');

  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

main()
  .then(() => {
    console.log('✅ Phase 17 completed!\n');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Phase 17 failed:', error);
    process.exit(1);
  });
