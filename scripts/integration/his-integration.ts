#!/usr/bin/env ts-node

/**
 * HIS Integration Script for TMT System
 * เชื่อมต่อระบบ TMT กับ HIS และสร้างรายงานสำหรับกระทรวงสาธารณสุข
 */

import { PrismaClient, HisMappingStatus, TmtLevel } from '@prisma/client';

const prisma = new PrismaClient();

interface DrugMappingResult {
  hisDrugCode: string;
  drugName: string;
  tmtConceptId?: bigint;
  tmtLevel?: TmtLevel;
  confidence?: number;
  status: HisMappingStatus;
}

interface MinistryReportData {
  reportType: string;
  reportPeriod: string;
  reportDate: Date;
  hospitalCode: string;
  totalItems: number;
  mappedItems: number;
  tmtComplianceRate: number;
  drugs: Array<{
    localCode: string;
    drugName: string;
    tmtCode?: string;
    tmtLevel?: string;
    nc24Code?: string;
  }>;
}

/**
 * Auto-map HIS drugs to TMT concepts using intelligent matching
 */
async function autoMapHisDrugsToTmt(): Promise<DrugMappingResult[]> {
  console.log('🔄 Starting automatic HIS drug to TMT mapping...');

  const hisDrugs = await prisma.hisDrugMaster.findMany({
    where: {
      mappingStatus: 'PENDING'
    }
  });

  const results: DrugMappingResult[] = [];

  for (const drug of hisDrugs) {
    console.log(`🔍 Mapping: ${drug.drugName}`);

    try {
      // Search for TMT concepts by name similarity
      const tmtConcepts = await prisma.tmtConcept.findMany({
        where: {
          OR: [
            {
              fsn: {
                contains: drug.genericName || drug.drugName,
                mode: 'insensitive'
              }
            },
            {
              preferredTerm: {
                contains: drug.genericName || drug.drugName,
                mode: 'insensitive'
              }
            }
          ],
          level: 'TPU', // Focus on TPU level since that's what we have
          isActive: true
        },
        take: 5
      });

      let bestMatch: typeof tmtConcepts[0] | null = null;
      let confidence = 0;

      if (tmtConcepts.length > 0) {
        // Simple scoring based on name similarity
        for (const concept of tmtConcepts) {
          const drugNameLower = (drug.genericName || drug.drugName).toLowerCase();
          const conceptNameLower = concept.fsn.toLowerCase();
          
          // Calculate similarity score (simple approach)
          let score = 0;
          const drugWords = drugNameLower.split(' ');
          
          for (const word of drugWords) {
            if (word.length > 3 && conceptNameLower.includes(word)) {
              score += word.length * 0.1;
            }
          }

          // Check if strength matches
          if (drug.strength && concept.strength) {
            const drugStrength = drug.strength.toLowerCase().replace(/\s/g, '');
            const conceptStrength = concept.strength.toLowerCase().replace(/\s/g, '');
            if (drugStrength === conceptStrength) {
              score += 0.3;
            }
          }

          // Check if dosage form matches
          if (drug.dosageForm && concept.dosageForm) {
            const drugForm = drug.dosageForm.toLowerCase();
            const conceptForm = concept.dosageForm.toLowerCase();
            if (drugForm.includes(conceptForm) || conceptForm.includes(drugForm)) {
              score += 0.2;
            }
          }

          if (score > confidence) {
            confidence = score;
            bestMatch = concept;
          }
        }
      }

      let status: HisMappingStatus = 'PENDING';
      let tmtConceptId: bigint | undefined;
      let tmtLevel: TmtLevel | undefined;

      if (bestMatch && confidence > 0.3) {
        // Auto-map if confidence is high enough
        status = confidence > 0.7 ? 'MAPPED' : 'PENDING';
        tmtConceptId = bestMatch.id;
        tmtLevel = bestMatch.level;

        // Update HIS drug master
        await prisma.hisDrugMaster.update({
          where: { id: drug.id },
          data: {
            tmtConceptId: bestMatch.id,
            tmtLevel: bestMatch.level,
            mappingConfidence: confidence,
            mappingStatus: status,
            lastSync: new Date()
          }
        });

        // Create TMT mapping record
        const existingMapping = await prisma.tmtMapping.findFirst({
          where: {
            workingCode: drug.hisDrugCode,
            tmtLevel: bestMatch.level,
            tmtId: bestMatch.tmtId
          }
        });

        if (existingMapping) {
          await prisma.tmtMapping.update({
            where: { id: existingMapping.id },
            data: {
              confidence: confidence,
              mappingSource: 'auto_his_sync',
              mappedBy: 'system',
              isActive: true,
              mappingDate: new Date()
            }
          });
        } else {
          await prisma.tmtMapping.create({
            data: {
              workingCode: drug.hisDrugCode,
              drugCode: drug.hisDrugCode,
              tmtLevel: bestMatch.level,
              tmtConceptId: bestMatch.id,
              tmtCode: bestMatch.conceptCode || null,
              tmtId: bestMatch.tmtId,
              mappingSource: 'auto_his_sync',
              confidence: confidence,
              mappedBy: 'system',
              isActive: true,
              isVerified: false,
              mappingDate: new Date()
            }
          });
        }

        console.log(`✅ Mapped ${drug.drugName} to TMT (confidence: ${confidence.toFixed(2)})`);
      } else {
        console.log(`❌ No suitable TMT match found for ${drug.drugName}`);
      }

      results.push({
        hisDrugCode: drug.hisDrugCode,
        drugName: drug.drugName,
        tmtConceptId,
        tmtLevel,
        confidence,
        status
      });

    } catch (error) {
      console.error(`❌ Error mapping ${drug.drugName}:`, error);
      results.push({
        hisDrugCode: drug.hisDrugCode,
        drugName: drug.drugName,
        status: 'PENDING'
      });
    }
  }

  return results;
}

/**
 * Generate Ministry report data
 */
async function generateMinistryReport(reportType: string): Promise<MinistryReportData> {
  console.log(`📊 Generating Ministry report: ${reportType}`);

  const hospitalCode = 'INVS001'; // Demo hospital code
  const reportDate = new Date();
  const reportPeriod = `${reportDate.getFullYear()}-${String(reportDate.getMonth() + 1).padStart(2, '0')}`;

  // Get all HIS drugs with their TMT mappings
  const hisDrugs = await prisma.hisDrugMaster.findMany({
    include: {
      tmtConcept: true
    }
  });

  const totalItems = hisDrugs.length;
  const mappedItems = hisDrugs.filter(drug => drug.tmtConceptId).length;
  const tmtComplianceRate = totalItems > 0 ? (mappedItems / totalItems) * 100 : 0;

  const drugs = hisDrugs.map(drug => ({
    localCode: drug.hisDrugCode,
    drugName: drug.drugName,
    tmtCode: drug.tmtConcept?.conceptCode || undefined,
    tmtLevel: drug.tmtLevel?.toString() || undefined,
    nc24Code: drug.nc24Code || undefined
  }));

  return {
    reportType,
    reportPeriod,
    reportDate,
    hospitalCode,
    totalItems,
    mappedItems,
    tmtComplianceRate: Math.round(tmtComplianceRate * 100) / 100,
    drugs
  };
}

/**
 * Save Ministry report to database
 */
async function saveMinistryReport(reportData: MinistryReportData): Promise<void> {
  await prisma.ministryReport.create({
    data: {
      reportType: reportData.reportType,
      reportPeriod: reportData.reportPeriod,
      reportDate: reportData.reportDate,
      hospitalCode: reportData.hospitalCode,
      dataJson: reportData as any,
      tmtComplianceRate: reportData.tmtComplianceRate,
      totalItems: reportData.totalItems,
      mappedItems: reportData.mappedItems,
      verificationStatus: 'DRAFT'
    }
  });

  console.log(`💾 Saved Ministry report: ${reportData.reportType}`);
}

/**
 * Generate comprehensive statistics
 */
async function generateSystemStats(): Promise<void> {
  console.log('\n📈 TMT-HIS Integration Statistics:');

  const stats = await Promise.all([
    prisma.tmtConcept.count(),
    prisma.tmtMapping.count(),
    prisma.hisDrugMaster.count(),
    prisma.hisDrugMaster.count({ where: { mappingStatus: 'MAPPED' } }),
    prisma.hisDrugMaster.count({ where: { mappingStatus: 'VERIFIED' } }),
    prisma.hisDrugMaster.count({ where: { mappingStatus: 'PENDING' } }),
    prisma.tmtManufacturer.count(),
    prisma.tmtDosageForm.count(),
    prisma.tmtUnit.count(),
    prisma.ministryReport.count()
  ]);

  const [
    tmtConcepts,
    tmtMappings,
    totalHisDrugs,
    mappedHisDrugs,
    verifiedHisDrugs,
    pendingHisDrugs,
    manufacturers,
    dosageForms,
    units,
    reports
  ] = stats;

  const mappingRate = totalHisDrugs > 0 ? (mappedHisDrugs / totalHisDrugs) * 100 : 0;
  const verificationRate = totalHisDrugs > 0 ? (verifiedHisDrugs / totalHisDrugs) * 100 : 0;

  console.log(`   🏥 HIS Drug Master Records: ${totalHisDrugs}`);
  console.log(`   ✅ Mapped to TMT: ${mappedHisDrugs} (${mappingRate.toFixed(1)}%)`);
  console.log(`   ✓ Verified Mappings: ${verifiedHisDrugs} (${verificationRate.toFixed(1)}%)`);
  console.log(`   ⏳ Pending Mappings: ${pendingHisDrugs}`);
  console.log(`   🔗 TMT Concepts Available: ${tmtConcepts}`);
  console.log(`   🎯 TMT Mappings Created: ${tmtMappings}`);
  console.log(`   🏭 Manufacturers: ${manufacturers}`);
  console.log(`   💊 Dosage Forms: ${dosageForms}`);
  console.log(`   📏 Units: ${units}`);
  console.log(`   📊 Ministry Reports: ${reports}`);
}

/**
 * Main execution function
 */
async function main() {
  const startTime = Date.now();
  console.log('🚀 Starting HIS-TMT Integration Process...\n');

  try {
    // 1. Auto-map HIS drugs to TMT
    const mappingResults = await autoMapHisDrugsToTmt();
    console.log(`\n✅ Processed ${mappingResults.length} HIS drug mappings`);

    // 2. Generate Ministry reports
    const reportTypes = ['druglist', 'inventory'];
    
    for (const reportType of reportTypes) {
      const reportData = await generateMinistryReport(reportType);
      await saveMinistryReport(reportData);
    }

    // 3. Generate system statistics
    await generateSystemStats();

    const duration = (Date.now() - startTime) / 1000;
    console.log(`\n🎉 HIS-TMT Integration completed successfully in ${duration.toFixed(2)} seconds`);

  } catch (error) {
    console.error('❌ HIS-TMT Integration failed:', error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

// CLI execution
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.includes('--help')) {
    console.log(`
HIS-TMT Integration Script

Usage: npx ts-node scripts/his-integration.ts [options]

Options:
  --map-only      Only perform drug mapping
  --report-only   Only generate Ministry reports
  --stats-only    Only show statistics
  --help          Show this help

Examples:
  npx ts-node scripts/his-integration.ts           # Full integration
  npx ts-node scripts/his-integration.ts --map-only     # Mapping only
  npx ts-node scripts/his-integration.ts --stats-only   # Statistics only
`);
    process.exit(0);
  }

  if (args.includes('--map-only')) {
    autoMapHisDrugsToTmt().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  } else if (args.includes('--report-only')) {
    generateMinistryReport('druglist')
      .then(data => saveMinistryReport(data))
      .then(() => process.exit(0))
      .catch(err => {
        console.error(err);
        process.exit(1);
      });
  } else if (args.includes('--stats-only')) {
    generateSystemStats().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  } else {
    // Full integration
    main().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  }
}

export {
  autoMapHisDrugsToTmt,
  generateMinistryReport,
  saveMinistryReport,
  generateSystemStats
};