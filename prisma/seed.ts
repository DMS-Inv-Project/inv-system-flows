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
        headPerson: 'Hospital Director',
        budgetCode: 'ADM001'
      }
    }),
    prisma.department.upsert({
      where: { deptCode: 'PHARM' },
      update: {},
      create: {
        deptCode: 'PHARM',
        deptName: 'Pharmacy Department',
        headPerson: 'Chief Pharmacist',
        budgetCode: 'PHA001'
      }
    }),
    prisma.department.upsert({
      where: { deptCode: 'NURSE' },
      update: {},
      create: {
        deptCode: 'NURSE',
        deptName: 'Nursing Department',
        headPerson: 'Chief Nursing Officer',
        budgetCode: 'NUR001'
      }
    }),
    prisma.department.upsert({
      where: { deptCode: 'MED' },
      update: {},
      create: {
        deptCode: 'MED',
        deptName: 'Medical Department',
        headPerson: 'Chief Medical Officer',
        budgetCode: 'MED001'
      }
    }),
    prisma.department.upsert({
      where: { deptCode: 'LAB' },
      update: {},
      create: {
        deptCode: 'LAB',
        deptName: 'Laboratory',
        headPerson: 'Laboratory Director',
        budgetCode: 'LAB001'
      }
    })
  ])

  // Seed Budget Types
  console.log('💰 Creating budget types...')
  const budgetTypes = await Promise.all([
    prisma.budgetType.upsert({
      where: { budgetCode: 'OP001' },
      update: {},
      create: {
        budgetCode: 'OP001',
        budgetName: 'งบดำเนินงาน - ยา',
        budgetDescription: 'งบประมาณสำหรับซื้อยาและเวชภัณฑ์'
      }
    }),
    prisma.budgetType.upsert({
      where: { budgetCode: 'OP002' },
      update: {},
      create: {
        budgetCode: 'OP002',
        budgetName: 'งบดำเนินงาน - เครื่องมือ',
        budgetDescription: 'งบประมาณสำหรับซื้อเครื่องมือทางการแพทย์'
      }
    }),
    prisma.budgetType.upsert({
      where: { budgetCode: 'OP003' },
      update: {},
      create: {
        budgetCode: 'OP003',
        budgetName: 'งบดำเนินงาน - วัสดุสิ้นเปลือง',
        budgetDescription: 'งบประมาณสำหรับวัสดุสิ้นเปลืองทั่วไป'
      }
    }),
    prisma.budgetType.upsert({
      where: { budgetCode: 'INV001' },
      update: {},
      create: {
        budgetCode: 'INV001',
        budgetName: 'งบลงทุน - อุปกรณ์',
        budgetDescription: 'งบประมาณสำหรับซื้ออุปกรณ์การแพทย์'
      }
    }),
    prisma.budgetType.upsert({
      where: { budgetCode: 'INV002' },
      update: {},
      create: {
        budgetCode: 'INV002',
        budgetName: 'งบลงทุน - ระบบ IT',
        budgetDescription: 'งบประมาณสำหรับพัฒนาระบบสารสนเทศ'
      }
    }),
    prisma.budgetType.upsert({
      where: { budgetCode: 'EM001' },
      update: {},
      create: {
        budgetCode: 'EM001',
        budgetName: 'งบฉุกเฉิน',
        budgetDescription: 'งบประมาณสำหรับสถานการณ์ฉุกเฉิน'
      }
    })
  ])

  // Seed Companies
  console.log('🏢 Creating companies...')
  const companies = await Promise.all([
    prisma.company.upsert({
      where: { companyCode: '000001' },
      update: {},
      create: {
        companyCode: '000001',
        companyName: 'Government Pharmaceutical Organization (GPO)',
        companyType: 'BOTH',
        taxId: '0994000158378',
        address: '75/1 Rama VI Road, Ratchathewi, Bangkok 10400',
        phone: '02-203-8000',
        email: 'info@gpo.or.th',
        contactPerson: 'Sales Manager'
      }
    }),
    prisma.company.upsert({
      where: { companyCode: '000002' },
      update: {},
      create: {
        companyCode: '000002',
        companyName: 'Zuellig Pharma (Thailand) Ltd.',
        companyType: 'VENDOR',
        taxId: '0105536041974',
        address: '3199 Rama IV Road, Khlong Toei, Bangkok 10110',
        phone: '02-367-8100',
        email: 'thailand@zuelligpharma.com',
        contactPerson: 'Account Manager'
      }
    }),
    prisma.company.upsert({
      where: { companyCode: '000003' },
      update: {},
      create: {
        companyCode: '000003',
        companyName: 'Pfizer (Thailand) Ltd.',
        companyType: 'MANUFACTURER',
        taxId: '0105536028371',
        address: '1 Empire Tower, 47th Floor, Sathorn Road, Bangkok 10120',
        phone: '02-670-1000',
        email: 'info.thailand@pfizer.com',
        contactPerson: 'Medical Affairs'
      }
    }),
    prisma.company.upsert({
      where: { companyCode: '000004' },
      update: {},
      create: {
        companyCode: '000004',
        companyName: 'Sino-Thai Engineering & Construction PCL.',
        companyType: 'VENDOR',
        taxId: '0107537000781',
        address: '1011 Shinawatra Tower III, Viphavadi-Rangsit Road, Bangkok 10900',
        phone: '02-642-8951',
        email: 'info@sinothai.co.th',
        contactPerson: 'Project Manager'
      }
    }),
    prisma.company.upsert({
      where: { companyCode: '000005' },
      update: {},
      create: {
        companyCode: '000005',
        companyName: 'Berlin Pharmaceutical Industry Co., Ltd.',
        companyType: 'MANUFACTURER',
        taxId: '0105536001234',
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

  // Create Budget Allocations for 2025
  console.log('📊 Creating budget allocations...')
  const budgetAllocations = await Promise.all([
    prisma.budgetAllocation.upsert({
      where: {
        fiscalYear_budgetTypeId_departmentId: {
          fiscalYear: 2025,
          budgetTypeId: budgetTypes[0].id, // OP001 - ยา
          departmentId: departments[1].id   // PHARM
        }
      },
      update: {},
      create: {
        fiscalYear: 2025,
        budgetTypeId: budgetTypes[0].id,
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
        fiscalYear_budgetTypeId_departmentId: {
          fiscalYear: 2025,
          budgetTypeId: budgetTypes[0].id, // OP001 - ยา
          departmentId: departments[2].id   // NURSE
        }
      },
      update: {},
      create: {
        fiscalYear: 2025,
        budgetTypeId: budgetTypes[0].id,
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
        fiscalYear_budgetTypeId_departmentId: {
          fiscalYear: 2025,
          budgetTypeId: budgetTypes[1].id, // OP002 - เครื่องมือ
          departmentId: departments[3].id   // MED
        }
      },
      update: {},
      create: {
        fiscalYear: 2025,
        budgetTypeId: budgetTypes[1].id,
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
  console.log(`💰 Created ${budgetTypes.length} budget types`)
  console.log(`🏢 Created ${companies.length} companies`)
  console.log(`💊 Created ${drugGenerics.length} drug generics`)
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