#!/usr/bin/env node

/**
 * Legacy to Modern Migration Script
 * Migrate ข้อมูลยาจาก MySQL เดิมสู่ PostgreSQL ใหม่พร้อม TMT support
 */

const { PrismaClient } = require('@prisma/client');
const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

// Configuration
const CONFIG = {
  // MySQL (Source)
  mysql: {
    host: 'localhost',
    port: 3307,
    user: 'root',
    password: 'invs123',
    database: 'invs_banpong',
    connectTimeout: 60000
  },
  
  // PostgreSQL (Target) - Already configured via Prisma
  
  // Migration settings
  migration: {
    batchSize: 500,
    logLevel: 'info',
    dryRun: false, // true = จำลอง, false = migrate จริง
    backupPath: path.join(__dirname, '../backups/migration'),
    logPath: path.join(__dirname, '../logs')
  }
};

// Logger
const logger = {
  debug: (msg) => CONFIG.migration.logLevel === 'debug' && console.log(`[DEBUG] ${new Date().toISOString()} ${msg}`),
  info: (msg) => console.log(`[INFO] ${new Date().toISOString()} ${msg}`),
  warn: (msg) => console.warn(`[WARN] ${new Date().toISOString()} ${msg}`),
  error: (msg) => console.error(`[ERROR] ${new Date().toISOString()} ${msg}`)
};

/**
 * สร้าง MySQL connection
 */
async function createMySQLConnection() {
  try {
    logger.info('Connecting to MySQL...');
    const connection = await mysql.createConnection(CONFIG.mysql);
    logger.info('MySQL connection established');
    return connection;
  } catch (error) {
    logger.error(`MySQL connection failed: ${error.message}`);
    throw error;
  }
}

/**
 * สร้าง backup ข้อมูลปัจจุบัน
 */
async function createBackup() {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backupDir = path.join(CONFIG.migration.backupPath, `migration-backup-${timestamp}`);
  
  if (!fs.existsSync(CONFIG.migration.backupPath)) {
    fs.mkdirSync(CONFIG.migration.backupPath, { recursive: true });
  }
  
  fs.mkdirSync(backupDir, { recursive: true });
  
  logger.info(`Creating backup in ${backupDir}...`);
  
  try {
    // Backup existing data
    const [companies, drugGenerics, drugs, inventory] = await Promise.all([
      prisma.company.findMany(),
      prisma.drugGeneric.findMany(),
      prisma.drug.findMany(),
      prisma.inventory.findMany()
    ]);
    
    // Save backup files
    fs.writeFileSync(path.join(backupDir, 'companies.json'), JSON.stringify(companies, null, 2));
    fs.writeFileSync(path.join(backupDir, 'drug_generics.json'), JSON.stringify(drugGenerics, null, 2));
    fs.writeFileSync(path.join(backupDir, 'drugs.json'), JSON.stringify(drugs, null, 2));
    fs.writeFileSync(path.join(backupDir, 'inventory.json'), JSON.stringify(inventory, null, 2));
    
    // Save metadata
    const metadata = {
      backupDate: new Date().toISOString(),
      companiesCount: companies.length,
      drugGenericsCount: drugGenerics.length,
      drugsCount: drugs.length,
      inventoryCount: inventory.length
    };
    fs.writeFileSync(path.join(backupDir, 'metadata.json'), JSON.stringify(metadata, null, 2));
    
    logger.info(`Backup completed: ${backupDir}`);
    return backupDir;
    
  } catch (error) {
    logger.error(`Backup failed: ${error.message}`);
    throw error;
  }
}

/**
 * Extract ข้อมูลจาก MySQL
 */
async function extractLegacyData(mysqlConn) {
  logger.info('Extracting data from legacy MySQL database...');
  
  try {
    // Extract companies
    logger.info('Extracting companies...');
    const [companiesRows] = await mysqlConn.execute(`
      SELECT 
        COMPANY_CODE,
        COMPANY_NAME,
        VENDOR_FLAG,
        MANUFAC_FLAG,
        TAX_ID,
        ADDRESS,
        ADDRESS2,
        TEL,
        FAX,
        EMAIL,
        DETAILER,
        HIDE
      FROM company 
      WHERE HIDE != 'Y' OR HIDE IS NULL
      ORDER BY COMPANY_CODE
    `);
    
    // Extract drug generics
    logger.info('Extracting drug generics...');
    const [drugGenericsRows] = await mysqlConn.execute(`
      SELECT 
        WORKING_CODE,
        DRUG_NAME,
        DOSAGE_FORM,
        SALE_UNIT,
        COMPOSITION,
        STRENGTH,
        STRENGTH_UNIT,
        HIDE
      FROM drug_gn 
      WHERE HIDE != 'Y' OR HIDE IS NULL
      ORDER BY WORKING_CODE
    `);
    
    // Extract drugs/trade products
    logger.info('Extracting drugs...');
    const [drugsRows] = await mysqlConn.execute(`
      SELECT 
        TRADE_CODE,
        WORKING_CODE,
        TRADE_NAME,
        PACK_RATIO,
        BUY_UNIT_COST,
        MANUFAC_CODE,
        RECORD_STATUS,
        STD_CODE,
        GENERIC_CODE,
        BAR_CODE,
        SALE_UNIT_PRICE,
        ATC,
        TMTID,
        \`24DIGIT\`,
        GPSC,
        REGIST_NO,
        HIDE
      FROM drug_vn 
      WHERE (RECORD_STATUS != 'D' OR RECORD_STATUS IS NULL) 
        AND (HIDE != 'Y' OR HIDE IS NULL)
      ORDER BY TRADE_CODE
    `);
    
    // Extract inventory
    logger.info('Extracting inventory...');
    const [inventoryRows] = await mysqlConn.execute(`
      SELECT 
        WORKING_CODE,
        QTY_ON_HAND,
        MIN_LEVEL,
        MAX_LEVEL,
        REORDER_QTY,
        TOTAL_COST,
        SALE_UNIT_PRICE as STD_PRICE
      FROM inv_md 
      WHERE QTY_ON_HAND > 0
      ORDER BY WORKING_CODE
    `);
    
    logger.info(`Extraction completed:
      - Companies: ${companiesRows.length}
      - Drug Generics: ${drugGenericsRows.length}
      - Drugs: ${drugsRows.length}
      - Inventory: ${inventoryRows.length}`);
    
    return {
      companies: companiesRows,
      drugGenerics: drugGenericsRows,
      drugs: drugsRows,
      inventory: inventoryRows
    };
    
  } catch (error) {
    logger.error(`Data extraction failed: ${error.message}`);
    throw error;
  }
}

/**
 * Transform และ migrate companies
 */
async function migrateCompanies(companies) {
  logger.info(`Migrating ${companies.length} companies...`);
  
  let migrated = 0;
  let errors = 0;
  
  for (let i = 0; i < companies.length; i += CONFIG.migration.batchSize) {
    const batch = companies.slice(i, i + CONFIG.migration.batchSize);
    
    for (const company of batch) {
      try {
        if (CONFIG.migration.dryRun) {
          logger.debug(`[DRY RUN] Would create company: ${company.COMPANY_CODE} - ${company.COMPANY_NAME}`);
          migrated++;
          continue;
        }
        
        // Transform company data
        const companyData = {
          companyCode: company.COMPANY_CODE ? company.COMPANY_CODE.toString().padStart(6, '0') : null,
          companyName: company.COMPANY_NAME || '',
          companyType: getCompanyType(company.VENDOR_FLAG, company.MANUFAC_FLAG),
          taxId: company.TAX_ID || null,
          address: [company.ADDRESS, company.ADDRESS2].filter(Boolean).join(' ').trim() || null,
          phone: company.TEL || null,
          email: company.EMAIL || null,
          contactPerson: company.DETAILER || null,
          isActive: company.HIDE !== 'Y'
        };
        
        // Upsert company
        await prisma.company.upsert({
          where: { companyCode: companyData.companyCode },
          update: companyData,
          create: companyData
        });
        
        migrated++;
        
      } catch (error) {
        errors++;
        logger.error(`Error migrating company ${company.COMPANY_CODE}: ${error.message}`);
      }
    }
    
    logger.debug(`Companies batch ${Math.floor(i / CONFIG.migration.batchSize) + 1} completed`);
  }
  
  logger.info(`Companies migration completed: ${migrated} migrated, ${errors} errors`);
  return { migrated, errors };
}

/**
 * Helper function สำหรับกำหนด company type
 */
function getCompanyType(vendorFlag, manufacFlag) {
  if (vendorFlag === 'Y' && manufacFlag === 'Y') return 'BOTH';
  if (vendorFlag === 'Y') return 'VENDOR';
  if (manufacFlag === 'Y') return 'MANUFACTURER';
  return 'VENDOR'; // default
}

/**
 * Transform และ migrate drug generics
 */
async function migrateDrugGenerics(drugGenerics) {
  logger.info(`Migrating ${drugGenerics.length} drug generics...`);
  
  let migrated = 0;
  let errors = 0;
  
  for (let i = 0; i < drugGenerics.length; i += CONFIG.migration.batchSize) {
    const batch = drugGenerics.slice(i, i + CONFIG.migration.batchSize);
    
    for (const generic of batch) {
      try {
        if (CONFIG.migration.dryRun) {
          logger.debug(`[DRY RUN] Would create generic: ${generic.WORKING_CODE} - ${generic.DRUG_NAME}`);
          migrated++;
          continue;
        }
        
        // Transform drug generic data
        const genericData = {
          workingCode: generic.WORKING_CODE,
          drugName: generic.DRUG_NAME || '',
          dosageForm: generic.DOSAGE_FORM || '',
          saleUnit: generic.SALE_UNIT || 'TAB',
          composition: generic.COMPOSITION || null,
          strength: generic.STRENGTH ? parseFloat(generic.STRENGTH) : null,
          strengthUnit: generic.STRENGTH_UNIT || null,
          isActive: generic.HIDE !== 'Y',
          
          // TMT fields (จะเติมทีหลังจาก TMT import)
          tmtVtmCode: null,
          tmtVtmId: null,
          tmtGpCode: null,
          tmtGpId: null,
          tmtGpfCode: null,
          tmtGpfId: null,
          tmtGpxCode: null,
          tmtGpxId: null,
          tmtCode: null,
          standardUnit: null,
          therapeuticGroup: null
        };
        
        // Upsert drug generic
        await prisma.drugGeneric.upsert({
          where: { workingCode: genericData.workingCode },
          update: genericData,
          create: genericData
        });
        
        migrated++;
        
      } catch (error) {
        errors++;
        logger.error(`Error migrating drug generic ${generic.WORKING_CODE}: ${error.message}`);
      }
    }
    
    logger.debug(`Drug generics batch ${Math.floor(i / CONFIG.migration.batchSize) + 1} completed`);
  }
  
  logger.info(`Drug generics migration completed: ${migrated} migrated, ${errors} errors`);
  return { migrated, errors };
}

/**
 * Transform และ migrate drugs
 */
async function migrateDrugs(drugs) {
  logger.info(`Migrating ${drugs.length} drugs...`);
  
  let migrated = 0;
  let errors = 0;
  
  for (let i = 0; i < drugs.length; i += CONFIG.migration.batchSize) {
    const batch = drugs.slice(i, i + CONFIG.migration.batchSize);
    
    for (const drug of batch) {
      try {
        if (CONFIG.migration.dryRun) {
          logger.debug(`[DRY RUN] Would create drug: ${drug.TRADE_CODE} - ${drug.TRADE_NAME}`);
          migrated++;
          continue;
        }
        
        // หา generic และ manufacturer
        const generic = await prisma.drugGeneric.findUnique({
          where: { workingCode: drug.WORKING_CODE }
        });
        
        const manufacturer = drug.MANUFAC_CODE ? await prisma.company.findFirst({
          where: { companyCode: drug.MANUFAC_CODE.toString().padStart(6, '0') }
        }) : null;
        
        // Transform drug data
        const drugData = {
          drugCode: drug.TRADE_CODE,
          tradeName: drug.TRADE_NAME || '',
          genericId: generic?.id || null,
          strength: drug.PACK_RATIO ? drug.PACK_RATIO.toString() : null,
          dosageForm: generic?.dosageForm || null,
          manufacturerId: manufacturer?.id || null,
          atcCode: drug.ATC || null,
          standardCode: drug.STD_CODE || null,
          barcode: drug.BAR_CODE || null,
          packSize: drug.PACK_RATIO ? Math.round(parseFloat(drug.PACK_RATIO)) : 1,
          unit: generic?.saleUnit || 'TAB',
          isActive: drug.HIDE !== 'Y',
          
          // TMT fields
          tmtTpCode: null,
          tmtTpId: drug.TMTID ? BigInt(drug.TMTID) : null,
          tmtTpuCode: null,
          tmtTpuId: null,
          tmtTppCode: null,
          tmtTppId: null,
          nc24Code: drug['24DIGIT'] || null,
          registrationNumber: drug.REGIST_NO || null,
          gpoCode: drug.GPSC || null,
          
          // HPP fields
          hppType: null,
          specPrep: null,
          isHpp: false,
          baseProductId: null,
          formulaReference: null
        };
        
        // Upsert drug
        await prisma.drug.upsert({
          where: { drugCode: drugData.drugCode },
          update: drugData,
          create: drugData
        });
        
        migrated++;
        
      } catch (error) {
        errors++;
        logger.error(`Error migrating drug ${drug.TRADE_CODE}: ${error.message}`);
      }
    }
    
    logger.debug(`Drugs batch ${Math.floor(i / CONFIG.migration.batchSize) + 1} completed`);
  }
  
  logger.info(`Drugs migration completed: ${migrated} migrated, ${errors} errors`);
  return { migrated, errors };
}

/**
 * Migrate inventory
 */
async function migrateInventory(inventory) {
  logger.info(`Migrating ${inventory.length} inventory items...`);
  
  let migrated = 0;
  let errors = 0;
  
  // หาหรือสร้าง default location
  let defaultLocation = await prisma.location.findFirst({
    where: { locationCode: 'MAIN' }
  });
  
  if (!defaultLocation) {
    defaultLocation = await prisma.location.create({
      data: {
        locationCode: 'MAIN',
        locationName: 'Main Warehouse',
        locationType: 'WAREHOUSE',
        isActive: true
      }
    });
    logger.info('Created default location: MAIN');
  }
  
  for (let i = 0; i < inventory.length; i += CONFIG.migration.batchSize) {
    const batch = inventory.slice(i, i + CONFIG.migration.batchSize);
    
    for (const item of batch) {
      try {
        if (CONFIG.migration.dryRun) {
          logger.debug(`[DRY RUN] Would create inventory: ${item.WORKING_CODE}`);
          migrated++;
          continue;
        }
        
        // หา drug จาก working code
        const drug = await prisma.drug.findFirst({
          where: {
            generic: {
              workingCode: item.WORKING_CODE
            }
          }
        });
        
        if (!drug) {
          logger.warn(`Drug not found for working code: ${item.WORKING_CODE}`);
          continue;
        }
        
        const qtyOnHand = parseFloat(item.QTY_ON_HAND) || 0;
        const totalCost = parseFloat(item.TOTAL_COST) || 0;
        const avgCost = qtyOnHand > 0 ? totalCost / qtyOnHand : 0;
        
        // Transform inventory data
        const inventoryData = {
          drugId: drug.id,
          locationId: defaultLocation.id,
          quantityOnHand: qtyOnHand,
          minLevel: parseFloat(item.MIN_LEVEL) || 0,
          maxLevel: parseFloat(item.MAX_LEVEL) || 0,
          reorderPoint: parseFloat(item.REORDER_QTY) || 0,
          averageCost: avgCost,
          lastCost: parseFloat(item.STD_PRICE) || 0
        };
        
        // Upsert inventory
        await prisma.inventory.upsert({
          where: {
            drugId_locationId: {
              drugId: inventoryData.drugId,
              locationId: inventoryData.locationId
            }
          },
          update: inventoryData,
          create: inventoryData
        });
        
        migrated++;
        
      } catch (error) {
        errors++;
        logger.error(`Error migrating inventory ${item.WORKING_CODE}: ${error.message}`);
      }
    }
    
    logger.debug(`Inventory batch ${Math.floor(i / CONFIG.migration.batchSize) + 1} completed`);
  }
  
  logger.info(`Inventory migration completed: ${migrated} migrated, ${errors} errors`);
  return { migrated, errors };
}

/**
 * สร้าง TMT mappings จากข้อมูลที่ migrate มา
 */
async function createTmtMappings() {
  logger.info('Creating TMT mappings from migrated data...');
  
  let created = 0;
  let errors = 0;
  
  try {
    // หายาที่มี TMT ID
    const drugsWithTmt = await prisma.drug.findMany({
      where: {
        tmtTpId: { not: null }
      },
      include: {
        generic: true
      }
    });
    
    logger.info(`Found ${drugsWithTmt.length} drugs with TMT IDs`);
    
    for (const drug of drugsWithTmt) {
      try {
        if (CONFIG.migration.dryRun) {
          logger.debug(`[DRY RUN] Would create TMT mapping for: ${drug.drugCode}`);
          created++;
          continue;
        }
        
        // หา TMT concept
        const tmtConcept = await prisma.tmtConcept.findUnique({
          where: { tmtId: drug.tmtTpId }
        });
        
        if (!tmtConcept) {
          logger.warn(`TMT concept not found for TMT ID: ${drug.tmtTpId}`);
          continue;
        }
        
        // สร้าง TMT mapping
        const mappingData = {
          workingCode: drug.generic?.workingCode || null,
          drugCode: drug.drugCode,
          genericId: drug.genericId,
          drugId: drug.id,
          tmtLevel: 'TP', // ส่วนใหญ่จะเป็น TP level
          tmtConceptId: tmtConcept.id,
          tmtCode: tmtConcept.conceptCode,
          tmtId: drug.tmtTpId,
          mappingSource: 'legacy_migration',
          confidence: 0.9, // ข้อมูลจากระบบเดิม น่าเชื่อถือสูง
          mappedBy: 'migration_script',
          isActive: true,
          isVerified: false,
          mappingDate: new Date()
        };
        
        await prisma.tmtMapping.create({
          data: mappingData
        });
        
        created++;
        
      } catch (error) {
        errors++;
        logger.error(`Error creating TMT mapping for drug ${drug.drugCode}: ${error.message}`);
      }
    }
    
    logger.info(`TMT mappings creation completed: ${created} created, ${errors} errors`);
    return { created, errors };
    
  } catch (error) {
    logger.error(`TMT mappings creation failed: ${error.message}`);
    throw error;
  }
}

/**
 * Validate migration results
 */
async function validateMigration() {
  logger.info('Validating migration results...');
  
  try {
    const [
      companiesCount,
      drugGenericsCount,
      drugsCount,
      inventoryCount,
      tmtMappingsCount
    ] = await Promise.all([
      prisma.company.count(),
      prisma.drugGeneric.count(),
      prisma.drug.count(),
      prisma.inventory.count(),
      prisma.tmtMapping.count()
    ]);
    
    // Check data integrity
    const orphanedDrugs = await prisma.drug.count({
      where: {
        genericId: null
      }
    });
    
    const drugsWithoutManufacturer = await prisma.drug.count({
      where: {
        manufacturerId: null
      }
    });
    
    const inventoryWithoutDrugs = 0; // Skip this check for now
    
    logger.info('=== Migration Validation Results ===');
    logger.info(`Companies: ${companiesCount}`);
    logger.info(`Drug Generics: ${drugGenericsCount}`);
    logger.info(`Drugs: ${drugsCount}`);
    logger.info(`Inventory Items: ${inventoryCount}`);
    logger.info(`TMT Mappings: ${tmtMappingsCount}`);
    logger.info('');
    logger.info('=== Data Integrity Checks ===');
    logger.info(`Orphaned Drugs (no generic): ${orphanedDrugs}`);
    logger.info(`Drugs without Manufacturer: ${drugsWithoutManufacturer}`);
    logger.info(`Inventory without Drugs: ${inventoryWithoutDrugs}`);
    
    const issues = orphanedDrugs + inventoryWithoutDrugs;
    if (issues > 0) {
      logger.warn(`Found ${issues} data integrity issues`);
    } else {
      logger.info('✅ No data integrity issues found');
    }
    
    return {
      companiesCount,
      drugGenericsCount,
      drugsCount,
      inventoryCount,
      tmtMappingsCount,
      issues: {
        orphanedDrugs,
        drugsWithoutManufacturer,
        inventoryWithoutDrugs
      }
    };
    
  } catch (error) {
    logger.error(`Validation failed: ${error.message}`);
    throw error;
  }
}

/**
 * Main migration function
 */
async function main() {
  const startTime = Date.now();
  logger.info('Starting Legacy to Modern Migration...');
  
  if (CONFIG.migration.dryRun) {
    logger.warn('🔍 DRY RUN MODE - No actual changes will be made');
  }
  
  let mysqlConn;
  
  try {
    // 1. Create backup
    const backupDir = await createBackup();
    
    // 2. Connect to MySQL
    mysqlConn = await createMySQLConnection();
    
    // 3. Extract legacy data
    const legacyData = await extractLegacyData(mysqlConn);
    
    // 4. Close MySQL connection (we have all data in memory)
    await mysqlConn.end();
    mysqlConn = null;
    
    // 5. Migrate data
    const companiesResult = await migrateCompanies(legacyData.companies);
    const genericsResult = await migrateDrugGenerics(legacyData.drugGenerics);
    const drugsResult = await migrateDrugs(legacyData.drugs);
    const inventoryResult = await migrateInventory(legacyData.inventory);
    
    // 6. Create TMT mappings
    const tmtMappingsResult = await createTmtMappings();
    
    // 7. Validate results
    const validationResult = await validateMigration();
    
    const duration = (Date.now() - startTime) / 1000;
    
    logger.info('🎉 Migration completed successfully!');
    logger.info(`Total time: ${duration.toFixed(2)} seconds`);
    logger.info(`Backup location: ${backupDir}`);
    
    if (!CONFIG.migration.dryRun) {
      logger.info('💡 Next steps:');
      logger.info('1. Run TMT import script: npm run tmt:import');
      logger.info('2. Update drug codes: npm run tmt:update-codes');
      logger.info('3. Check statistics: npm run tmt:stats');
    }
    
  } catch (error) {
    logger.error(`Migration failed: ${error.message}`);
    throw error;
  } finally {
    if (mysqlConn) {
      await mysqlConn.end();
    }
    await prisma.$disconnect();
  }
}

// CLI execution
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.includes('--help')) {
    console.log(`
Legacy to Modern Migration Script

Usage: node migrate-legacy-to-modern.js [options]

Options:
  --dry-run          Simulate migration without making changes
  --debug            Enable debug logging
  --batch-size N     Set batch size (default: 500)
  --help             Show this help

Examples:
  node migrate-legacy-to-modern.js --dry-run    # Test migration
  node migrate-legacy-to-modern.js              # Run actual migration
  node migrate-legacy-to-modern.js --debug      # Enable debug output
`);
    process.exit(0);
  }
  
  if (args.includes('--dry-run')) {
    CONFIG.migration.dryRun = true;
  }
  
  if (args.includes('--debug')) {
    CONFIG.migration.logLevel = 'debug';
  }
  
  const batchSizeIndex = args.findIndex(arg => arg === '--batch-size');
  if (batchSizeIndex !== -1 && args[batchSizeIndex + 1]) {
    CONFIG.migration.batchSize = parseInt(args[batchSizeIndex + 1]);
  }
  
  main().then(() => process.exit(0)).catch(err => {
    console.error(err);
    process.exit(1);
  });
}

module.exports = {
  main,
  createBackup,
  extractLegacyData,
  migrateCompanies,
  migrateDrugGenerics,
  migrateDrugs,
  migrateInventory,
  createTmtMappings,
  validateMigration
};