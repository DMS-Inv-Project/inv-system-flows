#!/usr/bin/env node

/**
 * TMT Update Synchronization Script
 * จัดการการอัพเดทรหัส TMT เมื่อมีการเปลี่ยนแปลงจากกระทรวงสาธารณสุข
 * รองรับการ sync รหัสยาที่เปลี่ยนแปลงและการ backup ข้อมูลเดิม
 */

const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');
const xlsx = require('xlsx');

const prisma = new PrismaClient();

// Configuration
const CONFIG = {
  backupPath: '/Users/sathitseethaphon/projects/dms-invs-projects/invs-modern/backups',
  logPath: '/Users/sathitseethaphon/projects/dms-invs-projects/invs-modern/logs',
  batchSize: 500,
  logLevel: 'info'
};

// Logger
const logger = {
  debug: (msg) => CONFIG.logLevel === 'debug' && console.log(`[DEBUG] ${new Date().toISOString()} ${msg}`),
  info: (msg) => console.log(`[INFO] ${new Date().toISOString()} ${msg}`),
  warn: (msg) => console.warn(`[WARN] ${new Date().toISOString()} ${msg}`),
  error: (msg) => console.error(`[ERROR] ${new Date().toISOString()} ${msg}`)
};

/**
 * สร้าง backup ข้อมูล TMT ก่อนการ update
 */
async function createBackup() {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backupDir = path.join(CONFIG.backupPath, `tmt-backup-${timestamp}`);
  
  if (!fs.existsSync(CONFIG.backupPath)) {
    fs.mkdirSync(CONFIG.backupPath, { recursive: true });
  }
  
  fs.mkdirSync(backupDir, { recursive: true });
  
  logger.info(`Creating backup in ${backupDir}...`);
  
  try {
    // Backup TMT Concepts
    const concepts = await prisma.tmtConcept.findMany();
    fs.writeFileSync(
      path.join(backupDir, 'tmt_concepts.json'),
      JSON.stringify(concepts, null, 2)
    );
    
    // Backup TMT Relationships
    const relationships = await prisma.tmtRelationship.findMany();
    fs.writeFileSync(
      path.join(backupDir, 'tmt_relationships.json'),
      JSON.stringify(relationships, null, 2)
    );
    
    // Backup TMT Mappings
    const mappings = await prisma.tmtMapping.findMany();
    fs.writeFileSync(
      path.join(backupDir, 'tmt_mappings.json'),
      JSON.stringify(mappings, null, 2)
    );
    
    // Backup Drug TMT fields
    const drugGenerics = await prisma.drugGeneric.findMany({
      select: {
        id: true,
        workingCode: true,
        tmtVtmCode: true,
        tmtVtmId: true,
        tmtGpCode: true,
        tmtGpId: true,
        tmtGpfCode: true,
        tmtGpfId: true,
        tmtGpxCode: true,
        tmtGpxId: true,
        tmtCode: true
      }
    });
    fs.writeFileSync(
      path.join(backupDir, 'drug_generics_tmt.json'),
      JSON.stringify(drugGenerics, null, 2)
    );
    
    const drugs = await prisma.drug.findMany({
      select: {
        id: true,
        drugCode: true,
        tmtTpCode: true,
        tmtTpId: true,
        tmtTpuCode: true,
        tmtTpuId: true,
        tmtTppCode: true,
        tmtTppId: true,
        nc24Code: true,
        registrationNumber: true,
        gpoCode: true
      }
    });
    fs.writeFileSync(
      path.join(backupDir, 'drugs_tmt.json'),
      JSON.stringify(drugs, null, 2)
    );
    
    // สร้าง backup metadata
    const metadata = {
      backupDate: new Date().toISOString(),
      conceptsCount: concepts.length,
      relationshipsCount: relationships.length,
      mappingsCount: mappings.length,
      drugGenericsCount: drugGenerics.length,
      drugsCount: drugs.length
    };
    fs.writeFileSync(
      path.join(backupDir, 'metadata.json'),
      JSON.stringify(metadata, null, 2)
    );
    
    logger.info(`Backup completed: ${concepts.length} concepts, ${relationships.length} relationships, ${mappings.length} mappings`);
    return backupDir;
    
  } catch (error) {
    logger.error(`Backup failed: ${error.message}`);
    throw error;
  }
}

/**
 * เปรียบเทียบข้อมูล TMT ใหม่กับข้อมูลเดิม
 */
async function compareAndDetectChanges(newDataPath) {
  logger.info('Detecting changes in TMT data...');
  
  const changes = {
    newConcepts: [],
    updatedConcepts: [],
    inactivatedConcepts: [],
    newRelationships: [],
    updatedRelationships: [],
    inactivatedRelationships: []
  };
  
  try {
    // อ่านข้อมูลใหม่
    const newSnapshotFile = path.join(newDataPath, 'TMTRF_SNAPSHOT.xls');
    if (!fs.existsSync(newSnapshotFile)) {
      logger.warn(`New snapshot file not found: ${newSnapshotFile}`);
      return changes;
    }
    
    const workbook = xlsx.readFile(newSnapshotFile);
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    const newConcepts = xlsx.utils.sheet_to_json(worksheet);
    
    // เปรียบเทียบ TMT Concepts
    for (const newConcept of newConcepts) {
      const tmtId = parseInt(newConcept.TMTID);
      if (!tmtId) continue;
      
      const existingConcept = await prisma.tmtConcept.findUnique({
        where: { tmtId: tmtId }
      });
      
      if (!existingConcept) {
        // Concept ใหม่
        changes.newConcepts.push(newConcept);
      } else {
        // ตรวจสอบการเปลี่ยนแปลง
        const hasChanges = 
          existingConcept.fsn !== newConcept.FSN ||
          existingConcept.preferredTerm !== newConcept.PreferredTerm ||
          existingConcept.conceptCode !== newConcept.ConceptCode ||
          existingConcept.isActive !== (newConcept.IsActive !== 'false');
          
        if (hasChanges) {
          changes.updatedConcepts.push({
            existing: existingConcept,
            new: newConcept
          });
        }
      }
    }
    
    // ตรวจสอบ Concepts ที่ถูก inactivate
    const newTmtIds = new Set(newConcepts.map(c => parseInt(c.TMTID)).filter(id => id));
    const allExistingConcepts = await prisma.tmtConcept.findMany({
      where: { isActive: true }
    });
    
    for (const existingConcept of allExistingConcepts) {
      if (!newTmtIds.has(existingConcept.tmtId)) {
        changes.inactivatedConcepts.push(existingConcept);
      }
    }
    
    logger.info(`Changes detected: ${changes.newConcepts.length} new, ${changes.updatedConcepts.length} updated, ${changes.inactivatedConcepts.length} inactivated`);
    return changes;
    
  } catch (error) {
    logger.error(`Change detection failed: ${error.message}`);
    throw error;
  }
}

/**
 * อัพเดทรหัสยาตามการเปลี่ยนแปลง TMT
 */
async function updateDrugCodes(changes) {
  logger.info('Updating drug codes based on TMT changes...');
  
  let updatedDrugs = 0;
  let updatedGenerics = 0;
  let errors = 0;
  
  const updateLog = [];
  
  try {
    // อัพเดท Concepts ที่เปลี่ยนแปลง
    for (const change of changes.updatedConcepts) {
      const { existing, new: newData } = change;
      
      try {
        // อัพเดท TMT Concept
        await prisma.tmtConcept.update({
          where: { id: existing.id },
          data: {
            fsn: newData.FSN,
            preferredTerm: newData.PreferredTerm || null,
            conceptCode: newData.ConceptCode || null,
            strength: newData.Strength || null,
            dosageForm: newData.DosageForm || null,
            manufacturer: newData.Manufacturer || null,
            packSize: newData.PackSize || null,
            unitOfUse: newData.UnitOfUse || null,
            isActive: newData.IsActive !== 'false',
            updatedAt: new Date()
          }
        });
        
        // อัพเดทรหัสใน Drug Generics
        if (existing.level === 'VTM') {
          const affectedGenerics = await prisma.drugGeneric.updateMany({
            where: { tmtVtmId: existing.tmtId },
            data: { 
              tmtVtmCode: newData.ConceptCode || null,
              updatedAt: new Date()
            }
          });
          updatedGenerics += affectedGenerics.count;
        }
        
        if (existing.level === 'GP') {
          const affectedGenerics = await prisma.drugGeneric.updateMany({
            where: { tmtGpId: existing.tmtId },
            data: { 
              tmtGpCode: newData.ConceptCode || null,
              updatedAt: new Date()
            }
          });
          updatedGenerics += affectedGenerics.count;
        }
        
        // อัพเดทรหัสใน Drugs
        if (existing.level === 'TP') {
          const affectedDrugs = await prisma.drug.updateMany({
            where: { tmtTpId: existing.tmtId },
            data: { 
              tmtTpCode: newData.ConceptCode || null,
              updatedAt: new Date()
            }
          });
          updatedDrugs += affectedDrugs.count;
        }
        
        if (existing.level === 'TPU') {
          const affectedDrugs = await prisma.drug.updateMany({
            where: { tmtTpuId: existing.tmtId },
            data: { 
              tmtTpuCode: newData.ConceptCode || null,
              updatedAt: new Date()
            }
          });
          updatedDrugs += affectedDrugs.count;
        }
        
        updateLog.push({
          action: 'updated',
          tmtId: existing.tmtId,
          level: existing.level,
          oldCode: existing.conceptCode,
          newCode: newData.ConceptCode,
          oldFsn: existing.fsn,
          newFsn: newData.FSN
        });
        
      } catch (error) {
        errors++;
        logger.error(`Error updating concept ${existing.tmtId}: ${error.message}`);
      }
    }
    
    // เพิ่ม Concepts ใหม่
    for (const newConcept of changes.newConcepts) {
      try {
        const tmtId = parseInt(newConcept.TMTID);
        const level = mapTmtLevel(newConcept.Level);
        
        if (!tmtId || !level) continue;
        
        await prisma.tmtConcept.create({
          data: {
            tmtId: tmtId,
            conceptCode: newConcept.ConceptCode || null,
            level: level,
            fsn: newConcept.FSN,
            preferredTerm: newConcept.PreferredTerm || null,
            strength: newConcept.Strength || null,
            dosageForm: newConcept.DosageForm || null,
            manufacturer: newConcept.Manufacturer || null,
            packSize: newConcept.PackSize || null,
            unitOfUse: newConcept.UnitOfUse || null,
            isActive: newConcept.IsActive !== 'false',
            releaseDate: newConcept.ReleaseDate || new Date().toISOString().slice(0, 8)
          }
        });
        
        updateLog.push({
          action: 'created',
          tmtId: tmtId,
          level: level,
          code: newConcept.ConceptCode,
          fsn: newConcept.FSN
        });
        
      } catch (error) {
        errors++;
        logger.error(`Error creating concept ${newConcept.TMTID}: ${error.message}`);
      }
    }
    
    // Inactivate Concepts ที่ไม่มีแล้ว
    for (const inactiveConcept of changes.inactivatedConcepts) {
      try {
        await prisma.tmtConcept.update({
          where: { id: inactiveConcept.id },
          data: { 
            isActive: false,
            updatedAt: new Date()
          }
        });
        
        // อัพเดท TMT Mappings
        await prisma.tmtMapping.updateMany({
          where: { tmtConceptId: inactiveConcept.id },
          data: { 
            isActive: false,
            updatedAt: new Date()
          }
        });
        
        updateLog.push({
          action: 'inactivated',
          tmtId: inactiveConcept.tmtId,
          level: inactiveConcept.level,
          code: inactiveConcept.conceptCode,
          fsn: inactiveConcept.fsn
        });
        
      } catch (error) {
        errors++;
        logger.error(`Error inactivating concept ${inactiveConcept.tmtId}: ${error.message}`);
      }
    }
    
    // บันทึก update log
    const logDir = CONFIG.logPath;
    if (!fs.existsSync(logDir)) {
      fs.mkdirSync(logDir, { recursive: true });
    }
    
    const logFile = path.join(logDir, `tmt-update-${new Date().toISOString().slice(0, 10)}.json`);
    fs.writeFileSync(logFile, JSON.stringify({
      timestamp: new Date().toISOString(),
      summary: {
        updatedDrugs,
        updatedGenerics,
        errors,
        totalChanges: updateLog.length
      },
      changes: updateLog
    }, null, 2));
    
    logger.info(`Drug codes update completed: ${updatedDrugs} drugs, ${updatedGenerics} generics updated, ${errors} errors`);
    
    return {
      updatedDrugs,
      updatedGenerics,
      errors,
      logFile
    };
    
  } catch (error) {
    logger.error(`Drug codes update failed: ${error.message}`);
    throw error;
  }
}

/**
 * ตรวจสอบความถูกต้องหลังการ update
 */
async function validateUpdate() {
  logger.info('Validating TMT update...');
  
  const issues = [];
  
  try {
    // ตรวจสอบ orphaned mappings
    const orphanedMappings = await prisma.tmtMapping.findMany({
      where: {
        isActive: true,
        tmtConcept: {
          isActive: false
        }
      },
      include: {
        tmtConcept: true
      }
    });
    
    if (orphanedMappings.length > 0) {
      issues.push(`Found ${orphanedMappings.length} mappings pointing to inactive concepts`);
      
      // แก้ไขโดยการ inactivate mappings
      await prisma.tmtMapping.updateMany({
        where: {
          id: { in: orphanedMappings.map(m => m.id) }
        },
        data: { isActive: false }
      });
    }
    
    // ตรวจสอบ missing TMT IDs ใน drugs
    const drugsWithInvalidTmt = await prisma.drug.findMany({
      where: {
        OR: [
          {
            AND: [
              { tmtTpId: { not: null } },
              { 
                NOT: {
                  tmtTpId: {
                    in: await prisma.tmtConcept.findMany({
                      where: { isActive: true, level: 'TP' },
                      select: { tmtId: true }
                    }).then(concepts => concepts.map(c => c.tmtId))
                  }
                }
              }
            ]
          },
          {
            AND: [
              { tmtTpuId: { not: null } },
              { 
                NOT: {
                  tmtTpuId: {
                    in: await prisma.tmtConcept.findMany({
                      where: { isActive: true, level: 'TPU' },
                      select: { tmtId: true }
                    }).then(concepts => concepts.map(c => c.tmtId))
                  }
                }
              }
            ]
          }
        ]
      }
    });
    
    if (drugsWithInvalidTmt.length > 0) {
      issues.push(`Found ${drugsWithInvalidTmt.length} drugs with invalid TMT references`);
    }
    
    // ตรวจสอบ consistency ของรหัส
    const inconsistentCodes = await prisma.$queryRaw`
      SELECT 
        dg.working_code,
        dg.tmt_gp_code,
        tc.concept_code as actual_gp_code
      FROM drug_generics dg
      JOIN tmt_concepts tc ON dg.tmt_gp_id = tc.tmt_id
      WHERE dg.tmt_gp_code IS NOT NULL 
        AND dg.tmt_gp_code != tc.concept_code
        AND dg.is_active = true
        AND tc.is_active = true
    `;
    
    if (inconsistentCodes.length > 0) {
      issues.push(`Found ${inconsistentCodes.length} inconsistent TMT codes in drug generics`);
    }
    
    if (issues.length === 0) {
      logger.info('Validation passed: No issues found');
    } else {
      logger.warn(`Validation found ${issues.length} issues:`);
      issues.forEach(issue => logger.warn(`  - ${issue}`));
    }
    
    return issues;
    
  } catch (error) {
    logger.error(`Validation failed: ${error.message}`);
    throw error;
  }
}

/**
 * สร้างรายงานการ update
 */
async function generateUpdateReport(updateResult) {
  logger.info('Generating update report...');
  
  try {
    const [
      conceptCount,
      activeConceptCount,
      mappingCount,
      activeMappingCount,
      drugGenericWithTmt,
      drugWithTmt
    ] = await Promise.all([
      prisma.tmtConcept.count(),
      prisma.tmtConcept.count({ where: { isActive: true } }),
      prisma.tmtMapping.count(),
      prisma.tmtMapping.count({ where: { isActive: true } }),
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
    
    const report = {
      updateDate: new Date().toISOString(),
      updateSummary: updateResult,
      currentStats: {
        concepts: {
          total: conceptCount,
          active: activeConceptCount,
          inactive: conceptCount - activeConceptCount
        },
        mappings: {
          total: mappingCount,
          active: activeMappingCount,
          inactive: mappingCount - activeMappingCount
        },
        drugCoverage: {
          genericsWithTmt: drugGenericWithTmt,
          drugsWithTmt: drugWithTmt
        }
      }
    };
    
    const reportDir = CONFIG.logPath;
    if (!fs.existsSync(reportDir)) {
      fs.mkdirSync(reportDir, { recursive: true });
    }
    
    const reportFile = path.join(reportDir, `tmt-update-report-${new Date().toISOString().slice(0, 10)}.json`);
    fs.writeFileSync(reportFile, JSON.stringify(report, null, 2));
    
    logger.info('=== TMT Update Report ===');
    logger.info(`TMT Concepts: ${activeConceptCount}/${conceptCount} active`);
    logger.info(`TMT Mappings: ${activeMappingCount}/${mappingCount} active`);
    logger.info(`Drug Coverage: ${drugGenericWithTmt} generics, ${drugWithTmt} drugs with TMT`);
    logger.info(`Report saved: ${reportFile}`);
    
    return reportFile;
    
  } catch (error) {
    logger.error(`Report generation failed: ${error.message}`);
    throw error;
  }
}

/**
 * แปลง TMT Level string เป็น enum value
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
 * Main function
 */
async function main(newDataPath) {
  const startTime = Date.now();
  logger.info('Starting TMT Update Sync Process...');
  
  if (!newDataPath) {
    throw new Error('New TMT data path is required');
  }
  
  if (!fs.existsSync(newDataPath)) {
    throw new Error(`New TMT data path does not exist: ${newDataPath}`);
  }
  
  try {
    // 1. สร้าง Backup
    const backupDir = await createBackup();
    logger.info(`Backup created: ${backupDir}`);
    
    // 2. ตรวจหาการเปลี่ยนแปลง
    const changes = await compareAndDetectChanges(newDataPath);
    
    if (changes.newConcepts.length === 0 && 
        changes.updatedConcepts.length === 0 && 
        changes.inactivatedConcepts.length === 0) {
      logger.info('No changes detected. TMT data is up to date.');
      return;
    }
    
    // 3. อัพเดทรหัสยา
    const updateResult = await updateDrugCodes(changes);
    
    // 4. ตรวจสอบความถูกต้อง
    const validationIssues = await validateUpdate();
    
    // 5. สร้างรายงาน
    const reportFile = await generateUpdateReport(updateResult);
    
    const duration = (Date.now() - startTime) / 1000;
    logger.info(`TMT Update Sync completed successfully in ${duration.toFixed(2)} seconds`);
    logger.info(`Backup: ${backupDir}`);
    logger.info(`Report: ${reportFile}`);
    
    if (validationIssues.length > 0) {
      logger.warn(`${validationIssues.length} validation issues found. Please review the log.`);
    }
    
  } catch (error) {
    logger.error(`TMT Update Sync failed: ${error.message}`);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

// CLI execution
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.includes('--help') || args.length === 0) {
    console.log(`
TMT Update Synchronization Script

Usage: node sync-tmt-updates.js <new-data-path> [options]

Arguments:
  new-data-path       Path to directory containing new TMT data files

Options:
  --backup-only       Create backup only
  --detect-only       Detect changes only (no updates)
  --validate-only     Validate current data only
  --debug            Enable debug logging
  --help             Show this help

Examples:
  node sync-tmt-updates.js /path/to/new/tmt/data
  node sync-tmt-updates.js /path/to/new/tmt/data --debug
  node sync-tmt-updates.js /path/to/new/tmt/data --detect-only
`);
    process.exit(0);
  }
  
  const newDataPath = args[0];
  
  if (args.includes('--debug')) {
    CONFIG.logLevel = 'debug';
  }
  
  // Selective operations
  if (args.includes('--backup-only')) {
    createBackup().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  } else if (args.includes('--detect-only')) {
    compareAndDetectChanges(newDataPath).then(changes => {
      console.log(JSON.stringify(changes, null, 2));
      process.exit(0);
    }).catch(err => {
      console.error(err);
      process.exit(1);
    });
  } else if (args.includes('--validate-only')) {
    validateUpdate().then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  } else {
    // Full sync
    main(newDataPath).then(() => process.exit(0)).catch(err => {
      console.error(err);
      process.exit(1);
    });
  }
}

module.exports = {
  createBackup,
  compareAndDetectChanges,
  updateDrugCodes,
  validateUpdate,
  generateUpdateReport
};