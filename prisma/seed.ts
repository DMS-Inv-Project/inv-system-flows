import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function main() {
  console.log('🌱 Seeding INVS Modern database...')

  // Seed Locations
  console.log('📍 Creating locations...')
  const locations = await Promise.all([
    prisma.location.upsert({
      where: { locationCode: 'MAIN' },
      update: {},
      create: {
        locationCode: 'MAIN',
        locationName: 'Main Warehouse',
        locationType: 'WAREHOUSE',
        address: 'Hospital Main Building',
        responsiblePerson: 'Warehouse Manager'
      }
    }),
    prisma.location.upsert({
      where: { locationCode: 'PHARM' },
      update: {},
      create: {
        locationCode: 'PHARM',
        locationName: 'Central Pharmacy',
        locationType: 'PHARMACY',
        address: 'Ground Floor, Building A',
        responsiblePerson: 'Chief Pharmacist'
      }
    }),
    prisma.location.upsert({
      where: { locationCode: 'EMRG' },
      update: {},
      create: {
        locationCode: 'EMRG',
        locationName: 'Emergency Department',
        locationType: 'EMERGENCY',
        address: 'Emergency Wing',
        responsiblePerson: 'Emergency Head Nurse'
      }
    }),
    prisma.location.upsert({
      where: { locationCode: 'ICU' },
      update: {},
      create: {
        locationCode: 'ICU',
        locationName: 'Intensive Care Unit',
        locationType: 'WARD',
        address: '3rd Floor, Building B',
        responsiblePerson: 'ICU Head Nurse'
      }
    }),
    prisma.location.upsert({
      where: { locationCode: 'OPD' },
      update: {},
      create: {
        locationCode: 'OPD',
        locationName: 'Outpatient Department',
        locationType: 'PHARMACY',
        address: '1st Floor, Building A',
        responsiblePerson: 'OPD Pharmacist'
      }
    })
  ])

  // Seed Departments
  console.log('🏥 Creating departments...')
  const departments = await Promise.all([
    prisma.department.upsert({
      where: { deptCode: 'ADMIN' },
      update: {},
      create: {
        deptCode: 'ADMIN',
        deptName: 'Administration',
        hisCode: 'HIS-ADM',
        headPerson: 'Hospital Director'
      }
    }),
    prisma.department.upsert({
      where: { deptCode: 'PHARM' },
      update: {},
      create: {
        deptCode: 'PHARM',
        deptName: 'Pharmacy Department',
        hisCode: 'HIS-PHARM',
        headPerson: 'Chief Pharmacist'
      }
    }),
    prisma.department.upsert({
      where: { deptCode: 'NURSE' },
      update: {},
      create: {
        deptCode: 'NURSE',
        deptName: 'Nursing Department',
        hisCode: 'HIS-NURSE',
        headPerson: 'Chief Nursing Officer'
      }
    }),
    prisma.department.upsert({
      where: { deptCode: 'MED' },
      update: {},
      create: {
        deptCode: 'MED',
        deptName: 'Medical Department',
        hisCode: 'HIS-MED',
        headPerson: 'Chief Medical Officer'
      }
    }),
    prisma.department.upsert({
      where: { deptCode: 'LAB' },
      update: {},
      create: {
        deptCode: 'LAB',
        deptName: 'Laboratory',
        hisCode: 'HIS-LAB',
        headPerson: 'Laboratory Director'
      }
    })
  ])

  // Seed Banks
  console.log('🏦 Creating banks...')
  const banks = await Promise.all([
    prisma.bank.upsert({
      where: { id: 1 },
      update: {},
      create: {
        id: 1,
        bankName: 'ธนาคารกรุงไทย'
      }
    }),
    prisma.bank.upsert({
      where: { id: 2 },
      update: {},
      create: {
        id: 2,
        bankName: 'ธนาคารกสิกรไทย'
      }
    }),
    prisma.bank.upsert({
      where: { id: 3 },
      update: {},
      create: {
        id: 3,
        bankName: 'ธนาคารไทยพาณิชย์'
      }
    }),
    prisma.bank.upsert({
      where: { id: 4 },
      update: {},
      create: {
        id: 4,
        bankName: 'ธนาคารกรุงเทพ'
      }
    }),
    prisma.bank.upsert({
      where: { id: 5 },
      update: {},
      create: {
        id: 5,
        bankName: 'ธนาคารกรุงศรีอยุธยา'
      }
    })
  ])

  // Seed Budget Type Groups
  console.log('📋 Creating budget type groups...')
  const budgetTypeGroups = await Promise.all([
    prisma.budgetTypeGroup.upsert({
      where: { typeCode: '01' },
      update: {},
      create: {
        typeCode: '01',
        typeName: 'งบเงินบำรุง'
      }
    }),
    prisma.budgetTypeGroup.upsert({
      where: { typeCode: '02' },
      update: {},
      create: {
        typeCode: '02',
        typeName: 'งบลงทุน'
      }
    }),
    prisma.budgetTypeGroup.upsert({
      where: { typeCode: '03' },
      update: {},
      create: {
        typeCode: '03',
        typeName: 'งบบุคลากร'
      }
    })
  ])

  // Seed Budget Categories
  console.log('📁 Creating budget categories...')
  const budgetCategories = await Promise.all([
    prisma.budgetCategory.upsert({
      where: { categoryCode: '0101' },
      update: {},
      create: {
        categoryCode: '0101',
        categoryName: 'เวชภัณฑ์ไม่ใช่ยา',
        accCode: '1105010103.102',
        remark: 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับเวชภัณฑ์ไม่ใช่ยา'
      }
    }),
    prisma.budgetCategory.upsert({
      where: { categoryCode: '0102' },
      update: {},
      create: {
        categoryCode: '0102',
        categoryName: 'ยา',
        accCode: '1105010103.101',
        remark: 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับยา'
      }
    }),
    prisma.budgetCategory.upsert({
      where: { categoryCode: '0103' },
      update: {},
      create: {
        categoryCode: '0103',
        categoryName: 'เครื่องมือแพทย์',
        accCode: '1105010103.103',
        remark: 'เป็นหมวดค่าใช้จ่ายเกี่ยวกับเครื่องมือทางการแพทย์'
      }
    })
  ])

  // Seed Budget Master
  console.log('💰 Creating budget master...')
  const budgets = await Promise.all([
    prisma.budget.upsert({
      where: { budgetCode: 'OP001' },
      update: {},
      create: {
        budgetCode: 'OP001',
        budgetType: '01',
        budgetCategory: '0101',
        budgetDescription: 'งบประมาณสำหรับซื้อเวชภัณฑ์ไม่ใช่ยา'
      }
    }),
    prisma.budget.upsert({
      where: { budgetCode: 'OP002' },
      update: {},
      create: {
        budgetCode: 'OP002',
        budgetType: '01',
        budgetCategory: '0102',
        budgetDescription: 'งบประมาณสำหรับซื้อยา'
      }
    })
  ])

  // Seed Companies
  console.log('🏢 Creating companies...')
  const companies = await Promise.all([
    prisma.company.upsert({
      where: { companyCode: '000001' },
      update: {
        bankCode: '3722699075',
        bankAccount: 'บริษัท ร่ำรวยเงินทอง จำกัด',
        bankId: 1
      },
      create: {
        companyCode: '000001',
        companyName: 'Government Pharmaceutical Organization (GPO)',
        companyType: 'BOTH',
        taxId: '0994000158378',
        bankCode: '3722699075',
        bankAccount: 'บริษัท ร่ำรวยเงินทอง จำกัด',
        bankId: 1, // ธนาคารกรุงไทย
        address: '75/1 Rama VI Road, Ratchathewi, Bangkok 10400',
        phone: '02-203-8000',
        email: 'info@gpo.or.th',
        contactPerson: 'Sales Manager'
      }
    }),
    prisma.company.upsert({
      where: { companyCode: '000002' },
      update: {
        bankCode: '4561234567',
        bankAccount: 'บริษัท ซูลลิกฟาร์มา (ประเทศไทย) จำกัด',
        bankId: 2
      },
      create: {
        companyCode: '000002',
        companyName: 'Zuellig Pharma (Thailand) Ltd.',
        companyType: 'VENDOR',
        taxId: '0105536041974',
        bankCode: '4561234567',
        bankAccount: 'บริษัท ซูลลิกฟาร์มา (ประเทศไทย) จำกัด',
        bankId: 2, // ธนาคารกสิกรไทย
        address: '3199 Rama IV Road, Khlong Toei, Bangkok 10110',
        phone: '02-367-8100',
        email: 'thailand@zuelligpharma.com',
        contactPerson: 'Account Manager'
      }
    }),
    prisma.company.upsert({
      where: { companyCode: '000003' },
      update: {
        bankCode: '7891234567',
        bankAccount: 'บริษัท ไฟเซอร์ (ประเทศไทย) จำกัด',
        bankId: 3
      },
      create: {
        companyCode: '000003',
        companyName: 'Pfizer (Thailand) Ltd.',
        companyType: 'MANUFACTURER',
        taxId: '0105536028371',
        bankCode: '7891234567',
        bankAccount: 'บริษัท ไฟเซอร์ (ประเทศไทย) จำกัด',
        bankId: 3, // ธนาคารไทยพาณิชย์
        address: '1 Empire Tower, 47th Floor, Sathorn Road, Bangkok 10120',
        phone: '02-670-1000',
        email: 'info.thailand@pfizer.com',
        contactPerson: 'Medical Affairs'
      }
    }),
    prisma.company.upsert({
      where: { companyCode: '000004' },
      update: {
        bankCode: '1234567890',
        bankAccount: 'บริษัท ไซโน-ไทย เอ็นจิเนียริ่ง แอนด์ คอนสตรัคชั่น จำกัด (มหาชน)',
        bankId: 4
      },
      create: {
        companyCode: '000004',
        companyName: 'Sino-Thai Engineering & Construction PCL.',
        companyType: 'VENDOR',
        taxId: '0107537000781',
        bankCode: '1234567890',
        bankAccount: 'บริษัท ไซโน-ไทย เอ็นจิเนียริ่ง แอนด์ คอนสตรัคชั่น จำกัด (มหาชน)',
        bankId: 4, // ธนาคารกรุงเทพ
        address: '1011 Shinawatra Tower III, Viphavadi-Rangsit Road, Bangkok 10900',
        phone: '02-642-8951',
        email: 'info@sinothai.co.th',
        contactPerson: 'Project Manager'
      }
    }),
    prisma.company.upsert({
      where: { companyCode: '000005' },
      update: {
        bankCode: '9876543210',
        bankAccount: 'บริษัท เบอร์ลินฟาร์มาซูติคอลอินดัสตรี จำกัด',
        bankId: 5
      },
      create: {
        companyCode: '000005',
        companyName: 'Berlin Pharmaceutical Industry Co., Ltd.',
        companyType: 'MANUFACTURER',
        taxId: '0105536001234',
        bankCode: '9876543210',
        bankAccount: 'บริษัท เบอร์ลินฟาร์มาซูติคอลอินดัสตรี จำกัด',
        bankId: 5, // ธนาคารกรุงศรีอยุธยา
        address: '123 Industrial Estate, Samut Prakan 10280',
        phone: '02-324-5678',
        email: 'sales@berlin-pharma.co.th',
        contactPerson: 'Sales Director'
      }
    })
  ])

  // Seed Drug Generics
  console.log('💊 Creating drug generics...')
  const drugGenerics = await Promise.all([
    prisma.drugGeneric.upsert({
      where: { workingCode: 'PAR0001' },
      update: {},
      create: {
        workingCode: 'PAR0001',
        drugName: 'Paracetamol',
        dosageForm: 'Tablet',
        saleUnit: 'TAB',
        composition: 'Paracetamol',
        strength: 500,
        strengthUnit: 'mg'
      }
    }),
    prisma.drugGeneric.upsert({
      where: { workingCode: 'IBU0001' },
      update: {},
      create: {
        workingCode: 'IBU0001',
        drugName: 'Ibuprofen',
        dosageForm: 'Tablet',
        saleUnit: 'TAB',
        composition: 'Ibuprofen',
        strength: 200,
        strengthUnit: 'mg'
      }
    }),
    prisma.drugGeneric.upsert({
      where: { workingCode: 'AMX0001' },
      update: {},
      create: {
        workingCode: 'AMX0001',
        drugName: 'Amoxicillin',
        dosageForm: 'Capsule',
        saleUnit: 'CAP',
        composition: 'Amoxicillin trihydrate',
        strength: 250,
        strengthUnit: 'mg'
      }
    }),
    prisma.drugGeneric.upsert({
      where: { workingCode: 'ASP0001' },
      update: {},
      create: {
        workingCode: 'ASP0001',
        drugName: 'Aspirin',
        dosageForm: 'Tablet',
        saleUnit: 'TAB',
        composition: 'Acetylsalicylic acid',
        strength: 100,
        strengthUnit: 'mg'
      }
    }),
    prisma.drugGeneric.upsert({
      where: { workingCode: 'OME0001' },
      update: {},
      create: {
        workingCode: 'OME0001',
        drugName: 'Omeprazole',
        dosageForm: 'Capsule',
        saleUnit: 'CAP',
        composition: 'Omeprazole',
        strength: 20,
        strengthUnit: 'mg'
      }
    })
  ])

  // Seed Drugs (Trade Names)
  console.log('💊 Creating drugs (trade names)...')
  const drugs = await Promise.all([
    prisma.drug.upsert({
      where: { drugCode: 'PAR0001-000001-001' },
      update: {},
      create: {
        drugCode: 'PAR0001-000001-001',
        tradeName: 'GPO Paracetamol 500mg',
        genericId: drugGenerics[0].id, // PAR0001
        manufacturerId: companies[0].id, // GPO
        strength: '500mg',
        dosageForm: 'Tablet',
        packSize: 1000,
        unitPrice: 1.50,
        unit: 'TAB',
        atcCode: 'N02BE01',
        standardCode: 'PAR0001-000001-001',
        barcode: '8851234567890'
      }
    }),
    prisma.drug.upsert({
      where: { drugCode: 'IBU0001-000001-001' },
      update: {},
      create: {
        drugCode: 'IBU0001-000001-001',
        tradeName: 'GPO Ibuprofen 200mg',
        genericId: drugGenerics[1].id, // IBU0001
        manufacturerId: companies[0].id, // GPO
        strength: '200mg',
        dosageForm: 'Tablet',
        packSize: 500,
        unitPrice: 2.50,
        unit: 'TAB',
        atcCode: 'M01AE01',
        standardCode: 'IBU0001-000001-001',
        barcode: '8851234567891'
      }
    }),
    prisma.drug.upsert({
      where: { drugCode: 'AMX0001-000002-001' },
      update: {},
      create: {
        drugCode: 'AMX0001-000002-001',
        tradeName: 'Zuellig Amoxicillin 250mg',
        genericId: drugGenerics[2].id, // AMX0001
        manufacturerId: companies[1].id, // Zuellig
        strength: '250mg',
        dosageForm: 'Capsule',
        packSize: 1000,
        unitPrice: 3.00,
        unit: 'CAP',
        atcCode: 'J01CA04',
        standardCode: 'AMX0001-000002-001',
        barcode: '8851234567892'
      }
    })
  ])

  // Create Budget Allocations for 2025
  console.log('📊 Creating budget allocations...')
  const budgetAllocations = await Promise.all([
    prisma.budgetAllocation.upsert({
      where: {
        fiscalYear_budgetId_departmentId: {
          fiscalYear: 2025,
          budgetId: budgets[1].id, // OP002 - ยา
          departmentId: departments[1].id   // PHARM
        }
      },
      update: {},
      create: {
        fiscalYear: 2025,
        budgetId: budgets[1].id,
        departmentId: departments[1].id,
        totalBudget: 10000000, // 10M บาท
        q1Budget: 2500000,
        q2Budget: 2500000,
        q3Budget: 2500000,
        q4Budget: 2500000,
        remainingBudget: 10000000
      }
    }),
    prisma.budgetAllocation.upsert({
      where: {
        fiscalYear_budgetId_departmentId: {
          fiscalYear: 2025,
          budgetId: budgets[1].id, // OP002 - ยา
          departmentId: departments[2].id   // NURSE
        }
      },
      update: {},
      create: {
        fiscalYear: 2025,
        budgetId: budgets[1].id,
        departmentId: departments[2].id,
        totalBudget: 5000000, // 5M บาท
        q1Budget: 1250000,
        q2Budget: 1250000,
        q3Budget: 1250000,
        q4Budget: 1250000,
        remainingBudget: 5000000
      }
    }),
    prisma.budgetAllocation.upsert({
      where: {
        fiscalYear_budgetId_departmentId: {
          fiscalYear: 2025,
          budgetId: budgets[0].id, // OP001 - เวชภัณฑ์ไม่ใช่ยา
          departmentId: departments[3].id   // MED
        }
      },
      update: {},
      create: {
        fiscalYear: 2025,
        budgetId: budgets[0].id,
        departmentId: departments[3].id,
        totalBudget: 3000000, // 3M บาท
        q1Budget: 750000,
        q2Budget: 750000,
        q3Budget: 750000,
        q4Budget: 750000,
        remainingBudget: 3000000
      }
    })
  ])

  console.log('✅ Seeding completed successfully!')
  console.log(`📍 Created ${locations.length} locations`)
  console.log(`🏥 Created ${departments.length} departments`)
  console.log(`🏦 Created ${banks.length} banks`)
  console.log(`📋 Created ${budgetTypeGroups.length} budget type groups`)
  console.log(`📁 Created ${budgetCategories.length} budget categories`)
  console.log(`💰 Created ${budgets.length} budgets`)
  console.log(`🏢 Created ${companies.length} companies`)
  console.log(`💊 Created ${drugGenerics.length} drug generics`)
  console.log(`💊 Created ${drugs.length} drugs (trade names)`)
  console.log(`📊 Created ${budgetAllocations.length} budget allocations`)
}

main()
  .catch((e) => {
    console.error('❌ Seeding failed:', e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })