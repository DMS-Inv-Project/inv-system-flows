#!/usr/bin/env node

/**
 * TMT Data Import Script
 * Import และ Update ข้อมูล TMT จาก SNAPSHOT files
 * รองรับการ update รหัสยาเมื่อมีการเปลี่ยนแปลง
 */

const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');
const xlsx = require('xlsx');

const prisma = new PrismaClient();

// Configuration
const CONFIG = {
  dataPath: '/Users/sathitseethaphon/projects/dms-invs-projects/invs-modern/docs/manual-invs/TMTRF20250915/TMTRF20250915',
  relationshipPath: '/Users/sathitseethaphon/projects/dms-invs-projects/invs-modern/docs/manual-invs/TMTRF20250915/TMTRF20250915_BONUS/Relationship',
  batchSize: 1000,
  logLevel: 'info' // debug, info, warn, error
};

// Logger
const logger = {
  debug: (msg) => CONFIG.logLevel === 'debug' && console.log(`[DEBUG] ${msg}`),
  info: (msg) => console.log(`[INFO] ${msg}`),
  warn: (msg) => console.warn(`[WARN] ${msg}`),
  error: (msg) => console.error(`[ERROR] ${msg}`)
};

/**
 * อ่านไฟล์ Excel และแปลงเป็น JSON
 */
function readExcelFile(filePath) {
  try {
    logger.debug(`Reading Excel file: ${filePath}`);
    const workbook = xlsx.readFile(filePath);
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    
    // อ่านโดยไม่ใช้ header row เป็น field names เพื่อหลีกเลี่ยงปัญหา
    const data = xlsx.utils.sheet_to_json(worksheet, { header: 1 });
    
    // กรองเอาแค่ data rows (ข้าม header row)
    const dataRows = data.slice(1).filter(row => row && row.length > 0);
    
    logger.info(`Loaded ${dataRows.length} records from ${path.basename(filePath)}`);
    return dataRows;
  } catch (error) {
    logger.error(`Failed to read Excel file ${filePath}: ${error.message}`);
    throw error;
  }
}

/**
 * Parse change date from Excel format
 */
function parseChangeDate(changeDateStr) {
  if (!changeDateStr) return new Date();
  
  // Convert from YYYYMMDD format to proper date
  const dateStr = changeDateStr.toString();
  if (dateStr.length === 8) {
    const year = dateStr.substring(0, 4);
    const month = dateStr.substring(4, 6);
    const day = dateStr.substring(6, 8);
    const date = new Date(`${year}-${month}-${day}`);
    return isNaN(date.getTime()) ? new Date() : date;
  }
  
  return new Date();
}

/**
 * ตรวจสอบและสร้าง TMT Level mapping
 */
function mapTmtLevel(levelStr) {
  const levelMap = {
    'SUBS': 'SUBS',
    'VTM': 'VTM', 
    'GP': 'GP',
    'TP': 'TP',
    'GPU': 'GPU',
    'TPU': 'TPU',
    'GPP': 'GPP',
    'TPP': 'TPP',
    'GP-F': 'GP_F',
    'GP-X': 'GP_X'
  };
  return levelMap[levelStr] || null;
}

/**
 * Import TMT Concepts
 */
async function importTmtConcepts() {
  logger.info('Starting TMT Concepts import...');
  
  const snapshotFile = path.join(CONFIG.dataPath, 'TMTRF20250915_SNAPSHOT.xls');
  
  if (!fs.existsSync(snapshotFile)) {
    logger.warn(`Snapshot file not found: ${snapshotFile}`);
    return;
  }

  const concepts = readExcelFile(snapshotFile);
  let imported = 0;
  let updated = 0;
  let errors = 0;

  logger.info(`Processing ${concepts.length} TMT concepts...`);

  for (let i = 0; i < concepts.length; i += CONFIG.batchSize) {
    const batch = concepts.slice(i, i + CONFIG.batchSize);
    
    for (const concept of batch) {
      let tmtIdStr = null;
      
      try {
        // แปลงข้อมูลจาก Excel array format [TMTID, FSN, MANUFACTURER, CHANGEDATE]
        if (!Array.isArray(concept) || concept.length < 2) {
          continue;
        }
        
        tmtIdStr = concept[0];
        const fsn = concept[1];
        const manufacturer = concept[2];
        const changeDate = concept[3];
        
        if (!tmtIdStr || !fsn) {
          continue;
        }
        
        const tmtId = parseInt(tmtIdStr);
        if (isNaN(tmtId)) {
          continue;
        }
        
        // ดึง level จาก FSN (สุดท้ายใน parentheses)
        const levelMatch = fsn.match(/\(([A-Z]+)\)$/);
        const level = levelMatch ? mapTmtLevel(levelMatch[1]) : null;
        
        if (!level) {
          logger.warn(`Skipping concept with invalid level: TMTID=${tmtId}, FSN=${fsn.substring(0, 100)}...`);
          continue;
        }

        const conceptData = {
          tmtId: tmtId,
          conceptCode: tmtIdStr.toString(),
          level: level,
          fsn: fsn,
          preferredTerm: null,
          strength: null,
          dosageForm: null,
          manufacturer: manufacturer || null,
          packSize: null,
          unitOfUse: null,
          isActive: true,
          effectiveDate: parseChangeDate(changeDate),
          releaseDate: '20250915'
        };

        // Upsert TMT Concept
        const result = await prisma.tmtConcept.upsert({
          where: { tmtId: tmtId },
          update: {
            ...conceptData,
            updatedAt: new Date()
          },
          create: conceptData
        });

        if (result.createdAt.getTime() === result.updatedAt.getTime()) {
          imported++;
        } else {
          updated++;
        }

        if ((imported + updated) % 1000 === 0) {
          logger.info(`Processed ${imported + updated} concepts...`);
        }

      } catch (error) {
        errors++;
        logger.error(`Error processing concept ${tmtIdStr}: ${error.message}`);
        
        if (errors > 10) {
          logger.error('Too many errors, stopping import');
          break;
        }
      }
    }
    
    if (errors > 10) break;
  }

  logger.info(`TMT Concepts import completed: ${imported} imported, ${updated} updated, ${errors} errors`);
}

/**
 * Import TMT Relationships
 */
async function importTmtRelationships() {
  logger.info('Starting TMT Relationships import...');

  const relationshipFiles = [
    { file: 'VTMtoGP20250915.xls', parentKey: 'VTMID', childKey: 'GPID' },
    { file: 'GPtoTP20250915.xls', parentKey: 'GPID', childKey: 'TPID' },
    { file: 'GPtoGPU20250915.xls', parentKey: 'GPID', childKey: 'GPUID' },
    { file: 'GPUtoTPU20250915.xls', parentKey: 'GPUID', childKey: 'TPUID' }
  ];

  let totalImported = 0;
  let totalUpdated = 0;
  let totalErrors = 0;

  for (const { file, parentKey, childKey } of relationshipFiles) {
    const filePath = path.join(CONFIG.relationshipPath, file);
    
    if (!fs.existsSync(filePath)) {
      logger.warn(`Relationship file not found: ${filePath}`);
      continue;
    }

    // Use standard Excel reading (not array format) since headers are consistent
    const workbook = xlsx.readFile(filePath);
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    const relationships = xlsx.utils.sheet_to_json(worksheet);

    let imported = 0;
    let updated = 0;
    let errors = 0;

    logger.info(`Processing ${relationships.length} relationships from ${file}...`);

    for (const rel of relationships) {
      try {
        const parentTmtId = parseInt(rel[parentKey]);
        const childTmtId = parseInt(rel[childKey]);
        const relationType = 'IS_A'; // All relationships in these files are IS_A type

        if (isNaN(parentTmtId) || isNaN(childTmtId)) {
          logger.warn(`Skipping invalid relationship: Parent=${rel[parentKey]}, Child=${rel[childKey]}`);
          continue;
        }

        // หา concept IDs
        const [parentConcept, childConcept] = await Promise.all([
          prisma.tmtConcept.findUnique({ where: { tmtId: parentTmtId } }),
          prisma.tmtConcept.findUnique({ where: { tmtId: childTmtId } })
        ]);

        if (!parentConcept || !childConcept) {
          logger.warn(`Missing concepts for relationship: Parent=${parentTmtId}, Child=${childTmtId}`);
          continue;
        }

        const relationshipData = {
          parentId: parentConcept.id,
          childId: childConcept.id,
          relationshipType: relationType,
          isActive: true,
          effectiveDate: new Date(),
          releaseDate: '20250915'
        };

        // Upsert Relationship
        const result = await prisma.tmtRelationship.upsert({
          where: {
            parentId_childId_relationshipType: {
              parentId: parentConcept.id,
              childId: childConcept.id,
              relationshipType: relationType
            }
          },
          update: {
            ...relationshipData,
            updatedAt: new Date()
          },
          create: relationshipData
        });

        if (result.createdAt.getTime() === result.updatedAt.getTime()) {
          imported++;
        } else {
          updated++;
        }

        if ((imported + updated) % 1000 === 0) {
          logger.info(`Processed ${imported + updated} relationships from ${file}...`);
        }

      } catch (error) {
        errors++;
        logger.error(`Error processing relationship ${rel[parentKey]}->${rel[childKey]}: ${error.message}`);
        
        if (errors > 100) {
          logger.error('Too many errors, stopping this file');
          break;
        }
      }
    }

    totalImported += imported;
    totalUpdated += updated;
    totalErrors += errors;

    logger.info(`${file}: ${imported} imported, ${updated} updated, ${errors} errors`);
  }

  logger.info(`TMT Relationships import completed: ${totalImported} imported, ${totalUpdated} updated, ${totalErrors} errors`);
}

/**
 * Update Drug Codes จากข้อมูล TMT
 */
async function updateDrugCodes() {
  logger.info('Starting Drug Code updates...');

  let updated = 0;
  let errors = 0;

  // อัพเดท Drug Generics ด้วย TMT codes
  const generics = await prisma.drugGeneric.findMany({
    where: { isActive: true }
  });

  logger.info(`Processing ${generics.length} drug generics...`);

  for (const generic of generics) {
    try {
      // ค้นหา TMT concepts ที่เกี่ยวข้อง
      const concepts = await prisma.tmtConcept.findMany({
        where: {
          OR: [
            { fsn: { contains: generic.drugName, mode: 'insensitive' } },
            { preferredTerm: { contains: generic.drugName, mode: 'insensitive' } }
          ],
          level: { in: ['VTM', 'GP', 'GP_F', 'GP_X'] },
          isActive: true
        },
        take: 5
      });

      if (concepts.length === 0) continue;

      // เลือก concept ที่เหมาะสมที่สุด
      const vtmConcept = concepts.find(c => c.level === 'VTM');
      const gpConcept = concepts.find(c => c.level === 'GP');
      const gpfConcept = concepts.find(c => c.level === 'GP_F');
      const gpxConcept = concepts.find(c => c.level === 'GP_X');

      const updateData = {};
      
      if (vtmConcept) {
        updateData.tmtVtmCode = vtmConcept.conceptCode;
        updateData.tmtVtmId = vtmConcept.tmtId;
      }
      
      if (gpConcept) {
        updateData.tmtGpCode = gpConcept.conceptCode;
        updateData.tmtGpId = gpConcept.tmtId;
      }
      
      if (gpfConcept) {
        updateData.tmtGpfCode = gpfConcept.conceptCode;
        updateData.tmtGpfId = gpfConcept.tmtId;
      }
      
      if (gpxConcept) {
        updateData.tmtGpxCode = gpxConcept.conceptCode;
        updateData.tmtGpxId = gpxConcept.tmtId;
      }

      if (Object.keys(updateData).length > 0) {
        await prisma.drugGeneric.update({
          where: { id: generic.id },
          data: updateData
        });
        updated++;
      }

    } catch (error) {
      errors++;
      logger.error(`Error updating generic ${generic.workingCode}: ${error.message}`);
    }
  }

  // อัพเดท Drugs ด้วย TMT codes
  const drugs = await prisma.drug.findMany({
    where: { isActive: true },
    include: { generic: true, manufacturer: true }
  });

  logger.info(`Processing ${drugs.length} drugs...`);

  for (const drug of drugs) {
    try {
      // ค้นหา TMT concepts สำหรับ trade products
      const searchTerms = [drug.tradeName];
      if (drug.generic?.drugName) {
        searchTerms.push(drug.generic.drugName);
      }

      const concepts = await prisma.tmtConcept.findMany({
        where: {
          OR: searchTerms.map(term => ({
            fsn: { contains: term, mode: 'insensitive' }
          })),
          level: { in: ['TP', 'TPU', 'TPP'] },
          isActive: true
        },
        take: 5
      });

      if (concepts.length === 0) continue;

      const tpConcept = concepts.find(c => c.level === 'TP');
      const tpuConcept = concepts.find(c => c.level === 'TPU');
      const tppConcept = concepts.find(c => c.level === 'TPP');

      const updateData = {};
      
      if (tpConcept) {
        updateData.tmtTpCode = tpConcept.conceptCode;
        updateData.tmtTpId = tpConcept.tmtId;
      }
      
      if (tpuConcept) {
        updateData.tmtTpuCode = tpuConcept.conceptCode;
        updateData.tmtTpuId = tpuConcept.tmtId;
      }
      
      if (tppConcept) {
        updateData.tmtTppCode = tppConcept.conceptCode;
        updateData.tmtTppId = tppConcept.tmtId;
      }

      if (Object.keys(updateData).length > 0) {
        await prisma.drug.update({
          where: { id: drug.id },
          data: updateData
        });
        updated++;
      }

    } catch (error) {
      errors++;
      logger.error(`Error updating drug ${drug.drugCode}: ${error.message}`);
    }
  }

  logger.info(`Drug Code updates completed: ${updated} updated, ${errors} errors`);
}

/**
 * สร้าง TMT Mappings
 */
async function createTmtMappings() {
  logger.info('Starting TMT Mappings creation...');

  let created = 0;
  let errors = 0;

  // สร้าง mappings สำหรับ Drug Generics
  const generics = await prisma.drugGeneric.findMany({
    where: {
      isActive: true,
      OR: [
        { tmtVtmId: { not: null } },
        { tmtGpId: { not: null } },
        { tmtGpfId: { not: null } },
        { tmtGpxId: { not: null } }
      ]
    }
  });

  for (const generic of generics) {
    try {
      const mappings = [];

      if (generic.tmtVtmId) {
        mappings.push({
          workingCode: generic.workingCode,
          genericId: generic.id,
          tmtLevel: 'VTM',
          tmtId: generic.tmtVtmId,
          tmtCode: generic.tmtVtmCode,
          mappingSource: 'auto_import',
          confidence: 0.8,
          mappedBy: 'system',
          isActive: true,
          isVerified: false,
          mappingDate: new Date()
        });
      }

      if (generic.tmtGpId) {
        mappings.push({
          workingCode: generic.workingCode,
          genericId: generic.id,
          tmtLevel: 'GP',
          tmtId: generic.tmtGpId,
          tmtCode: generic.tmtGpCode,
          mappingSource: 'auto_import',
          confidence: 0.8,
          mappedBy: 'system',
          isActive: true,
          isVerified: false,
          mappingDate: new Date()
        });
      }

      for (const mapping of mappings) {
        // หา TMT Concept
        const concept = await prisma.tmtConcept.findUnique({
          where: { tmtId: mapping.tmtId }
        });

        if (concept) {
          await prisma.tmtMapping.upsert({
            where: {
              workingCode_tmtLevel_tmtId: {
                workingCode: mapping.workingCode,
                tmtLevel: mapping.tmtLevel,
                tmtId: mapping.tmtId
              }
            },
            update: mapping,
            create: {
              ...mapping,
              tmtConceptId: concept.id
            }
          });
          created++;
        }
      }

    } catch (error) {
      errors++;
      logger.error(`Error creating mapping for ${generic.workingCode}: ${error.message}`);
    }
  }

  logger.info(`TMT Mappings creation completed: ${created} created, ${errors} errors`);
}

/**
 * สถิติการ import
 */
async function showImportStats() {
  logger.info('=== TMT Import Statistics ===');
  
  const [
    conceptCount,
    relationshipCount,
    mappingCount,
    drugGenericWithTmt,
    drugWithTmt
  ] = await Promise.all([
    prisma.tmtConcept.count(),
    prisma.tmtRelationship.count(),
    prisma.tmtMapping.count(),
    prisma.drugGeneric.count({
      where: {
        OR: [
          { tmtVtmId: { not: null } },
          { tmtGpId: { not: null } }
        ]
      }
    }),
    prisma.drug.count({
      where: {
        OR: [
          { tmtTpId: { not: null } },
          { tmtTpuId: { not: null } }
        ]
      }
    })
  ]);

  logger.info(`TMT Concepts: ${conceptCount}`);
  logger.info(`TMT Relationships: ${relationshipCount}`);
  logger.info(`TMT Mappings: ${mappingCount}`);
  logger.info(`Drug Generics with TMT: ${drugGenericWithTmt}`);
  logger.info(`Drugs with TMT: ${drugWithTmt}`);
}

/**
 * Main function
 */
async function main() {
  const startTime = Date.now();
  logger.info('Starting TMT Data Import Process...');

  try {
    // 1. Import TMT Concepts
    await importTmtConcepts();

    // 2. Import TMT Relationships  
    await importTmtRelationships();

    // 3. Update Drug Codes
    await updateDrugCodes();

    // 4. Create TMT Mappings
    await createTmtMappings();

    // 5. Show Statistics
    await showImportStats();

    const duration = (Date.now() - startTime) / 1000;
    logger.info(`TMT Import completed successfully in ${duration.toFixed(2)} seconds`);

  } catch (error) {
    logger.error(`TMT Import failed: ${error.message}`);
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
TMT Data Import Script

Usage: node import-tmt-data.js [options]

Options:
  --concepts-only     Import only TMT concepts
  --relationships-only Import only TMT relationships
  --update-codes-only  Update drug codes only
  --mappings-only     Create mappings only
  --stats-only        Show statistics only
  --debug            Enable debug logging
  --help             Show this help

Examples:
  node import-tmt-data.js                    # Full import
  node import-tmt-data.js --concepts-only    # Import concepts only
  node import-tmt-data.js --debug            # Enable debug logging
`);
    process.exit(0);
  }

  if (args.includes('--debug')) {
    CONFIG.logLevel = 'debug';
  }

  // Selective imports
  if (args.includes('--concepts-only')) {
    importTmtConcepts().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  } else if (args.includes('--relationships-only')) {
    importTmtRelationships().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  } else if (args.includes('--update-codes-only')) {
    updateDrugCodes().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  } else if (args.includes('--mappings-only')) {
    createTmtMappings().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  } else if (args.includes('--stats-only')) {
    showImportStats().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  } else {
    // Full import
    main().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  }
}

module.exports = {
  importTmtConcepts,
  importTmtRelationships,
  updateDrugCodes,
  createTmtMappings,
  showImportStats
};