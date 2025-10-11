import { PrismaClient } from '@prisma/client'
import { Client } from 'pg'

const prisma = new PrismaClient()

// Connection to old INVS database (if available)
const oldDbConfig = {
  host: 'localhost',
  port: 5433,
  database: 'invs_platform',
  user: 'invs_user',
  password: 'invs123'
}

interface OldCompany {
  company_code: string
  company_name: string
  vendor_flag: string
  manufac_flag: string
  tax_id?: string
  address?: string
  address2?: string
  tel?: string
  fax?: string
  email?: string
  detailer?: string
  hide: string
}

interface OldDrugGeneric {
  working_code: string
  drug_name: string
  dosage_form: string
  sale_unit: string
  composition?: string
  strength?: number
  strength_unit?: string
}

interface OldInventory {
  working_code: string
  qty_on_hand: number
  min_level: number
  max_level: number
  reorder_qty: number
  total_cost: number
  std_price: number
}

async function migrateFromOldSystem() {
  console.log('🔄 Starting data migration from old INVS system...')
  
  let oldClient: Client | null = null
  
  try {
    // Connect to old database
    oldClient = new Client(oldDbConfig)
    await oldClient.connect()
    console.log('✅ Connected to old database')
    
    // Migrate Companies
    await migrateCompanies(oldClient)
    
    // Migrate Drug Generics
    await migrateDrugGenerics(oldClient)
    
    // Migrate Drugs (Trade)
    await migrateDrugs(oldClient)
    
    // Migrate Inventory
    await migrateInventory(oldClient)
    
    console.log('🎉 Migration completed successfully!')
    
  } catch (error) {
    console.error('❌ Migration failed:', error)
    throw error
  } finally {
    if (oldClient) {
      await oldClient.end()
    }
  }
}

async function migrateCompanies(oldClient: Client) {
  console.log('🏢 Migrating companies...')
  
  try {
    const result = await oldClient.query(`
      SELECT 
        company_code, company_name, vendor_flag, manufac_flag,
        tax_id, address, address2, tel, fax, email, detailer, hide
      FROM companies 
      WHERE is_active = true
      ORDER BY company_code
    `)
    
    const companies: OldCompany[] = result.rows
    let migrated = 0
    
    for (const company of companies) {
      try {
        const companyType = 
          company.vendor_flag === 'Y' && company.manufac_flag === 'Y' ? 'BOTH' :
          company.vendor_flag === 'Y' ? 'VENDOR' :
          company.manufac_flag === 'Y' ? 'MANUFACTURER' : 'VENDOR'
        
        await prisma.company.upsert({
          where: { companyCode: company.company_code?.padStart(6, '0') || '' },
          update: {},
          create: {
            companyCode: company.company_code?.padStart(6, '0') || '',
            companyName: company.company_name || '',
            companyType: companyType as any,
            taxId: company.tax_id,
            address: [company.address, company.address2].filter(Boolean).join(' '),
            phone: company.tel,
            email: company.email,
            contactPerson: company.detailer,
            isActive: company.hide !== 'Y'
          }
        })
        migrated++
      } catch (error) {
        console.warn(`⚠️ Failed to migrate company ${company.company_code}:`, error)
      }
    }
    
    console.log(`✅ Migrated ${migrated}/${companies.length} companies`)
    
  } catch (error) {
    console.warn('⚠️ Company migration table not found or failed:', error)
  }
}

async function migrateDrugGenerics(oldClient: Client) {
  console.log('💊 Migrating drug generics...')
  
  try {
    const result = await oldClient.query(`
      SELECT 
        working_code, drug_name, dosage_form, sale_unit,
        composition, strength, strength_unit
      FROM drug_generics 
      WHERE is_active = true
      ORDER BY working_code
    `)
    
    const generics: OldDrugGeneric[] = result.rows
    let migrated = 0
    
    for (const generic of generics) {
      try {
        await prisma.drugGeneric.upsert({
          where: { workingCode: generic.working_code },
          update: {},
          create: {
            workingCode: generic.working_code,
            drugName: generic.drug_name,
            dosageForm: generic.dosage_form,
            saleUnit: generic.sale_unit,
            composition: generic.composition,
            strength: generic.strength,
            strengthUnit: generic.strength_unit
          }
        })
        migrated++
      } catch (error) {
        console.warn(`⚠️ Failed to migrate generic ${generic.working_code}:`, error)
      }
    }
    
    console.log(`✅ Migrated ${migrated}/${generics.length} drug generics`)
    
  } catch (error) {
    console.warn('⚠️ Drug generics migration table not found or failed:', error)
  }
}

async function migrateDrugs(oldClient: Client) {
  console.log('🔬 Migrating drugs...')
  
  try {
    const result = await oldClient.query(`
      SELECT 
        d.drug_code, d.trade_name, d.strength, d.dosage_form,
        d.atc_code, d.standard_code, d.barcode, d.pack_size, d.unit,
        d.generic_id, d.manufacturer_id, d.is_active
      FROM drugs d
      WHERE d.is_active = true
      ORDER BY d.drug_code
    `)
    
    const drugs = result.rows
    let migrated = 0
    
    for (const drug of drugs) {
      try {
        await prisma.drug.upsert({
          where: { drugCode: drug.drug_code },
          update: {},
          create: {
            drugCode: drug.drug_code,
            tradeName: drug.trade_name,
            strength: drug.strength,
            dosageForm: drug.dosage_form,
            atcCode: drug.atc_code,
            standardCode: drug.standard_code,
            barcode: drug.barcode,
            packSize: drug.pack_size || 1,
            unit: drug.unit || 'TAB',
            genericId: drug.generic_id,
            manufacturerId: drug.manufacturer_id,
            isActive: drug.is_active
          }
        })
        migrated++
      } catch (error) {
        console.warn(`⚠️ Failed to migrate drug ${drug.drug_code}:`, error)
      }
    }
    
    console.log(`✅ Migrated ${migrated}/${drugs.length} drugs`)
    
  } catch (error) {
    console.warn('⚠️ Drugs migration table not found or failed:', error)
  }
}

async function migrateInventory(oldClient: Client) {
  console.log('📦 Migrating inventory...')
  
  try {
    const result = await oldClient.query(`
      SELECT 
        i.drug_id, i.location_id, i.quantity_on_hand,
        i.min_level, i.max_level, i.reorder_point,
        i.average_cost, i.last_cost
      FROM inventory i
      WHERE i.quantity_on_hand > 0
      ORDER BY i.drug_id, i.location_id
    `)
    
    const inventoryItems = result.rows
    let migrated = 0
    
    for (const item of inventoryItems) {
      try {
        await prisma.inventory.upsert({
          where: {
            drugId_locationId: {
              drugId: item.drug_id,
              locationId: item.location_id
            }
          },
          update: {},
          create: {
            drugId: item.drug_id,
            locationId: item.location_id,
            quantityOnHand: item.quantity_on_hand,
            minLevel: item.min_level,
            maxLevel: item.max_level,
            reorderPoint: item.reorder_point,
            averageCost: item.average_cost,
            lastCost: item.last_cost
          }
        })
        migrated++
      } catch (error) {
        console.warn(`⚠️ Failed to migrate inventory item:`, error)
      }
    }
    
    console.log(`✅ Migrated ${migrated}/${inventoryItems.length} inventory items`)
    
  } catch (error) {
    console.warn('⚠️ Inventory migration table not found or failed:', error)
  }
}

// Manual migration functions for development
async function createSampleDrugs() {
  console.log('🧪 Creating sample drugs...')
  
  // Get references
  const gpo = await prisma.company.findFirst({ where: { companyCode: '000001' } })
  const zuellig = await prisma.company.findFirst({ where: { companyCode: '000002' } })
  const mainWarehouse = await prisma.location.findFirst({ where: { locationCode: 'MAIN' } })
  
  if (!gpo || !zuellig || !mainWarehouse) {
    console.error('❌ Required master data not found')
    return
  }
  
  // Create sample drugs
  const sampleDrugs = [
    {
      drugCode: 'PAR500-GPO-001',
      tradeName: 'GPO Paracetamol 500mg',
      genericId: 1, // Assuming Paracetamol generic ID
      manufacturerId: gpo.id,
      strength: '500mg',
      dosageForm: 'Tablet',
      atcCode: 'N02BE01',
      packSize: 1000,
      unit: 'TAB'
    },
    {
      drugCode: 'IBU200-ZUE-001',
      tradeName: 'Advil 200mg',
      genericId: 2, // Assuming Ibuprofen generic ID
      manufacturerId: zuellig.id,
      strength: '200mg',
      dosageForm: 'Tablet',
      atcCode: 'M01AE01',
      packSize: 100,
      unit: 'TAB'
    }
  ]
  
  for (const drugData of sampleDrugs) {
    try {
      const drug = await prisma.drug.upsert({
        where: { drugCode: drugData.drugCode },
        update: {},
        create: drugData
      })
      
      // Create inventory record
      await prisma.inventory.upsert({
        where: {
          drugId_locationId: {
            drugId: drug.id,
            locationId: mainWarehouse.id
          }
        },
        update: {},
        create: {
          drugId: drug.id,
          locationId: mainWarehouse.id,
          quantityOnHand: 5000,
          minLevel: 1000,
          maxLevel: 10000,
          reorderPoint: 2000,
          averageCost: 2.50,
          lastCost: 2.75
        }
      })
      
      console.log(`✅ Created drug: ${drugData.tradeName}`)
    } catch (error) {
      console.warn(`⚠️ Failed to create drug ${drugData.drugCode}:`, error)
    }
  }
}

// Main function
async function main() {
  try {
    console.log('🚀 Starting INVS data migration...')
    
    // Try to migrate from old system first
    try {
      await migrateFromOldSystem()
    } catch (error) {
      console.warn('⚠️ Old system migration failed, creating sample data instead:', error)
      await createSampleDrugs()
    }
    
    // Verify migration
    const stats = {
      companies: await prisma.company.count(),
      drugGenerics: await prisma.drugGeneric.count(),
      drugs: await prisma.drug.count(),
      inventory: await prisma.inventory.count(),
      locations: await prisma.location.count(),
      departments: await prisma.department.count(),
      budgetTypes: await prisma.budgetType.count()
    }
    
    console.log('📊 Migration Summary:')
    console.log(`🏢 Companies: ${stats.companies}`)
    console.log(`💊 Drug Generics: ${stats.drugGenerics}`)
    console.log(`🔬 Drugs: ${stats.drugs}`)
    console.log(`📦 Inventory Items: ${stats.inventory}`)
    console.log(`📍 Locations: ${stats.locations}`)
    console.log(`🏥 Departments: ${stats.departments}`)
    console.log(`💰 Budget Types: ${stats.budgetTypes}`)
    
  } catch (error) {
    console.error('❌ Migration failed:', error)
    throw error
  } finally {
    await prisma.$disconnect()
  }
}

// Run if called directly
if (require.main === module) {
  main()
    .catch((error) => {
      console.error('💥 Migration error:', error)
      process.exit(1)
    })
}