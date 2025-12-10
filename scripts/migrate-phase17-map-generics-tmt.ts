/**
 * Phase 17: Map DrugGenerics to TMT Concepts (GP Level)
 *
 * Strategy (Improved):
 * 1. Parse drug_generics: extract ingredient, strength, dosage form
 * 2. Match with tmt_concepts GP level by:
 *    - Same ingredient name
 *    - Same strength (if available)
 *    - Same dosage form (if available)
 *
 * Run: npx tsx scripts/migrate-phase17-map-generics-tmt.ts
 */

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

interface ParsedDrug {
  ingredient: string;
  strength: string | null;
  strengthNum: number | null;
  unit: string | null;
  form: string | null;
}

/**
 * Dosage form mapping (Thai/English abbreviations to standard)
 */
const FORM_MAPPING: Record<string, string[]> = {
  'tablet': ['tab', 'tablet', 'tablets', 'เม็ด'],
  'capsule': ['cap', 'capsule', 'capsules', 'แคปซูล'],
  'injection': ['inj', 'injection', 'inject', 'ฉีด'],
  'syrup': ['syr', 'syrup', 'น้ำเชื่อม'],
  'suspension': ['susp', 'suspension', 'แขวนตะกอน'],
  'cream': ['cream', 'ครีม'],
  'ointment': ['oint', 'ointment', 'ขี้ผึ้ง'],
  'solution': ['sol', 'solution', 'soln', 'สารละลาย'],
  'drops': ['drop', 'drops', 'gtt', 'หยด'],
  'powder': ['powder', 'pwd', 'ผง'],
  'gel': ['gel', 'เจล'],
  'spray': ['spray', 'สเปรย์'],
  'inhaler': ['inhaler', 'inh', 'พ่น'],
  'suppository': ['supp', 'suppository', 'เหน็บ'],
  'patch': ['patch', 'แผ่นแปะ'],
  'eye': ['eye', 'ophthalmic', 'ตา'],
  'ear': ['ear', 'otic', 'หู'],
};

/**
 * Parse drug name to extract components
 */
function parseDrugName(name: string): ParsedDrug {
  const original = name;
  let normalized = name
    .toLowerCase()
    .replace(/\(.*?\)/g, ' ') // Remove parentheses content
    .replace(/\*|!|@|#|\$/g, '') // Remove special chars
    .replace(/\s+/g, ' ')
    .trim();

  // Extract strength (number + unit pattern)
  const strengthMatch = normalized.match(/(\d+(?:\.\d+)?)\s*(mg|g|ml|mcg|iu|%|u|mu|unit|units)/i);
  let strength: string | null = null;
  let strengthNum: number | null = null;
  let unit: string | null = null;

  if (strengthMatch) {
    strengthNum = parseFloat(strengthMatch[1]);
    unit = strengthMatch[2].toLowerCase();
    // Normalize units
    if (unit === 'g' && strengthNum < 10) {
      // Convert g to mg for comparison
      strengthNum = strengthNum * 1000;
      unit = 'mg';
    }
    if (unit === 'mu') unit = 'u'; // Million units
    strength = `${strengthNum} ${unit}`;
  }

  // Extract dosage form
  let form: string | null = null;
  for (const [standardForm, variants] of Object.entries(FORM_MAPPING)) {
    for (const variant of variants) {
      if (normalized.includes(variant)) {
        form = standardForm;
        break;
      }
    }
    if (form) break;
  }

  // Extract ingredient (first meaningful word/phrase)
  // Remove strength and form to get ingredient
  let ingredientStr = normalized
    .replace(/\d+(?:\.\d+)?\s*(mg|g|ml|mcg|iu|%|u|mu|unit|units)/gi, '')
    .replace(/tab|tablet|cap|capsule|inj|injection|syr|syrup|susp|suspension|cream|oint|ointment|sol|solution|drop|drops|powder|gel|spray|inhaler|supp|suppository|patch/gi, '')
    .replace(/\s+/g, ' ')
    .trim();

  // Get main ingredient (usually first part before numbers or special chars)
  const ingredient = ingredientStr.split(/\s+/)[0] || ingredientStr;

  return { ingredient, strength, strengthNum, unit, form };
}

/**
 * Parse TMT FSN similarly
 */
function parseTmtFsn(fsn: string): ParsedDrug {
  const normalized = fsn.toLowerCase();

  // Extract strength
  const strengthMatch = normalized.match(/(\d+(?:\.\d+)?)\s*(mg|g|ml|mcg|iu|%|u)/i);
  let strengthNum: number | null = null;
  let unit: string | null = null;
  let strength: string | null = null;

  if (strengthMatch) {
    strengthNum = parseFloat(strengthMatch[1]);
    unit = strengthMatch[2].toLowerCase();
    if (unit === 'g' && strengthNum < 10) {
      strengthNum = strengthNum * 1000;
      unit = 'mg';
    }
    strength = `${strengthNum} ${unit}`;
  }

  // Extract form from FSN
  let form: string | null = null;
  for (const [standardForm, variants] of Object.entries(FORM_MAPPING)) {
    for (const variant of variants) {
      if (normalized.includes(variant)) {
        form = standardForm;
        break;
      }
    }
    if (form) break;
  }

  // Also check TMT specific forms
  if (normalized.includes('film-coated tablet') || normalized.includes('tablet')) form = 'tablet';
  if (normalized.includes('capsule')) form = 'capsule';
  if (normalized.includes('solution for injection') || normalized.includes('injection')) form = 'injection';
  if (normalized.includes('oral solution') || normalized.includes('syrup')) form = 'syrup';

  // Get ingredient (first word)
  const ingredient = normalized.split(/\s+/)[0];

  return { ingredient, strength, strengthNum, unit, form };
}

/**
 * Calculate match score between drug and TMT
 */
function calculateMatchScore(drug: ParsedDrug, tmt: ParsedDrug): number {
  let score = 0;

  // Ingredient match (required)
  if (drug.ingredient !== tmt.ingredient) {
    // Try partial match
    if (!drug.ingredient.includes(tmt.ingredient) && !tmt.ingredient.includes(drug.ingredient)) {
      return 0; // No match at all
    }
    score += 50; // Partial ingredient match
  } else {
    score += 100; // Exact ingredient match
  }

  // Strength match (important)
  if (drug.strengthNum && tmt.strengthNum) {
    if (drug.strengthNum === tmt.strengthNum && drug.unit === tmt.unit) {
      score += 50; // Exact strength match
    } else if (Math.abs(drug.strengthNum - tmt.strengthNum) / drug.strengthNum < 0.1) {
      score += 25; // Close strength (within 10%)
    }
  }

  // Form match (important)
  if (drug.form && tmt.form) {
    if (drug.form === tmt.form) {
      score += 30; // Exact form match
    }
  }

  return score;
}

async function main() {
  console.log('🚀 Phase 17: Mapping Drug Generics to TMT Concepts (Improved)...\n');
  console.log('═══════════════════════════════════════════════════════════');
  console.log('   Drug Generics → TMT GP Level Mapping (Strict Matching)');
  console.log('═══════════════════════════════════════════════════════════\n');

  try {
    // Get all GP level TMT concepts
    console.log('📋 Loading TMT Concepts (GP level)...');
    const tmtGpConcepts = await prisma.tmtConcept.findMany({
      where: { level: 'GP' },
      select: { id: true, tmtId: true, fsn: true, preferredTerm: true }
    });
    console.log(`   Found ${tmtGpConcepts.length} GP concepts\n`);

    // Build index by first ingredient word
    const tmtByIngredient = new Map<string, Array<{ id: bigint; tmtId: bigint; fsn: string; parsed: ParsedDrug }>>();

    for (const tmt of tmtGpConcepts) {
      const parsed = parseTmtFsn(tmt.fsn || '');
      if (parsed.ingredient && parsed.ingredient.length > 2) {
        if (!tmtByIngredient.has(parsed.ingredient)) {
          tmtByIngredient.set(parsed.ingredient, []);
        }
        tmtByIngredient.get(parsed.ingredient)!.push({
          id: tmt.id,
          tmtId: tmt.tmtId,
          fsn: tmt.fsn || '',
          parsed
        });
      }
    }
    console.log(`   Built index with ${tmtByIngredient.size} unique ingredients\n`);

    // Get all drug generics
    console.log('📋 Loading Drug Generics...');
    const drugGenerics = await prisma.drugGeneric.findMany({
      select: { id: true, workingCode: true, drugName: true, tmtGpId: true }
    });
    console.log(`   Found ${drugGenerics.length} generics\n`);

    // Match with strict scoring
    console.log('🔗 Matching with strict criteria...');
    let exactMatch = 0;
    let goodMatch = 0;
    let partialMatch = 0;
    let noMatch = 0;
    const matchDetails: Array<{ code: string; drug: string; tmt: string; score: number }> = [];
    const unmatchedSamples: string[] = [];

    for (const drug of drugGenerics) {
      if (drug.tmtGpId) continue; // Skip already mapped

      const parsed = parseDrugName(drug.drugName);

      // Find candidates by ingredient
      const candidates = tmtByIngredient.get(parsed.ingredient) || [];

      let bestMatch: { id: bigint; fsn: string; score: number } | null = null;

      for (const candidate of candidates) {
        const score = calculateMatchScore(parsed, candidate.parsed);
        if (score > 0 && (!bestMatch || score > bestMatch.score)) {
          bestMatch = { id: candidate.id, fsn: candidate.fsn, score };
        }
      }

      // Only accept matches with score >= 130 (ingredient + strength or form)
      if (bestMatch && bestMatch.score >= 130) {
        await prisma.drugGeneric.update({
          where: { id: drug.id },
          data: { tmtGpId: bestMatch.id }
        });

        if (bestMatch.score >= 180) {
          exactMatch++;
        } else if (bestMatch.score >= 150) {
          goodMatch++;
        } else {
          partialMatch++;
        }

        if (matchDetails.length < 20) {
          matchDetails.push({
            code: drug.workingCode,
            drug: drug.drugName,
            tmt: bestMatch.fsn,
            score: bestMatch.score
          });
        }
      } else {
        noMatch++;
        if (unmatchedSamples.length < 10) {
          unmatchedSamples.push(`${drug.workingCode}: ${drug.drugName}`);
        }
      }
    }

    const totalMatched = exactMatch + goodMatch + partialMatch;
    console.log(`\n   ✅ Exact match (score >= 180):   ${exactMatch}`);
    console.log(`   ✅ Good match (score >= 150):    ${goodMatch}`);
    console.log(`   ⚠️  Partial match (score >= 130): ${partialMatch}`);
    console.log(`   ❌ No match:                     ${noMatch}`);
    console.log(`\n   📊 Total matched: ${totalMatched} (${(totalMatched / drugGenerics.length * 100).toFixed(2)}%)`);

    // Show match samples
    console.log('\n   📝 Sample matches:');
    for (const m of matchDetails.slice(0, 10)) {
      console.log(`      [${m.score}] ${m.drug.substring(0, 35).padEnd(35)} → ${m.tmt.substring(0, 45)}`);
    }

    // Show unmatched samples
    if (unmatchedSamples.length > 0) {
      console.log('\n   📝 Unmatched samples:');
      unmatchedSamples.forEach(s => console.log(`      - ${s}`));
    }

    // Final statistics
    console.log('\n═══════════════════════════════════════════════════════════');
    console.log('   📊 PHASE 17 COMPLETE (Strict Matching)');
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
