#!/usr/bin/env ts-node

/**
 * TMT Reference Data Seeding Script
 * เติมข้อมูล reference สำหรับระบบ TMT
 */

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// TMT Manufacturers (ผู้ผลิตยา)
const tmtManufacturers = [
  {
    manufacturerCode: 'GPO001',
    manufacturerName: 'องค์การเภสัชกรรม',
    manufacturerNameEn: 'Government Pharmaceutical Organization',
    countryCode: 'THA',
    fdaLicense: 'GPO-001-2024',
    gmpStatus: 'APPROVED'
  },
  {
    manufacturerCode: 'ZUE001', 
    manufacturerName: 'บริษัท ซูลลิก ฟาร์มา (ประเทศไทย) จำกัด',
    manufacturerNameEn: 'Zuellig Pharma (Thailand) Ltd.',
    countryCode: 'THA',
    fdaLicense: 'ZUE-001-2024',
    gmpStatus: 'APPROVED'
  },
  {
    manufacturerCode: 'PFI001',
    manufacturerName: 'บริษัท ไฟเซอร์ (ประเทศไทย) จำกัด',
    manufacturerNameEn: 'Pfizer (Thailand) Ltd.',
    countryCode: 'THA',
    fdaLicense: 'PFI-001-2024',
    gmpStatus: 'APPROVED'
  },
  {
    manufacturerCode: 'SIN001',
    manufacturerName: 'บริษัท ไซโน-ไทย เอ็นจิเนียริ่ง แอนด์ คอนสตรัคชั่น จำกัด (มหาชน)',
    manufacturerNameEn: 'Sino-Thai Engineering & Construction PCL',
    countryCode: 'THA',
    fdaLicense: 'SIN-001-2024',
    gmpStatus: 'APPROVED'
  },
  {
    manufacturerCode: 'BER001',
    manufacturerName: 'บริษัท เบอร์ลิน ฟาร์มาซูติคอล อินดัสทรี่ จำกัด',
    manufacturerNameEn: 'Berlin Pharmaceutical Industry Co., Ltd.',
    countryCode: 'THA',
    fdaLicense: 'BER-001-2024', 
    gmpStatus: 'APPROVED'
  }
];

// TMT Dosage Forms (รูปแบบยา)
const tmtDosageForms = [
  {
    formCode: 'TAB',
    formName: 'เม็ด',
    formNameEn: 'Tablet',
    category: 'solid',
    routeOfAdministration: 'oral'
  },
  {
    formCode: 'CAP',
    formName: 'แคปซูล',
    formNameEn: 'Capsule',
    category: 'solid',
    routeOfAdministration: 'oral'
  },
  {
    formCode: 'SYR',
    formName: 'น้ำเชื่อม',
    formNameEn: 'Syrup',
    category: 'liquid',
    routeOfAdministration: 'oral'
  },
  {
    formCode: 'INJ',
    formName: 'ยาฉีด',
    formNameEn: 'Injection',
    category: 'injection',
    routeOfAdministration: 'parenteral'
  },
  {
    formCode: 'CRM',
    formName: 'ครีม',
    formNameEn: 'Cream',
    category: 'topical',
    routeOfAdministration: 'topical'
  },
  {
    formCode: 'OIN',
    formName: 'ยาครูด',
    formNameEn: 'Ointment',
    category: 'topical',
    routeOfAdministration: 'topical'
  },
  {
    formCode: 'DRP',
    formName: 'หยดตา',
    formNameEn: 'Eye Drops',
    category: 'liquid',
    routeOfAdministration: 'ophthalmic'
  },
  {
    formCode: 'SPR',
    formName: 'สเปรย์',
    formNameEn: 'Spray',
    category: 'liquid',
    routeOfAdministration: 'topical'
  },
  {
    formCode: 'SUP',
    formName: 'ยาเหน็บ',
    formNameEn: 'Suppository',
    category: 'solid',
    routeOfAdministration: 'rectal'
  },
  {
    formCode: 'LOZ',
    formName: 'ยาอม',
    formNameEn: 'Lozenge',
    category: 'solid',
    routeOfAdministration: 'oral'
  }
];

// TMT Units (หน่วย)
const tmtUnits = [
  {
    unitCode: 'MG',
    unitName: 'มิลลิกรัม',
    unitNameEn: 'Milligram',
    unitType: 'weight',
    baseUnit: 'G',
    conversionFactor: 0.001
  },
  {
    unitCode: 'G',
    unitName: 'กรัม',
    unitNameEn: 'Gram',
    unitType: 'weight',
    baseUnit: 'G',
    conversionFactor: 1.0
  },
  {
    unitCode: 'KG',
    unitName: 'กิโลกรัม',
    unitNameEn: 'Kilogram',
    unitType: 'weight',
    baseUnit: 'G',
    conversionFactor: 1000.0
  },
  {
    unitCode: 'ML',
    unitName: 'มิลลิลิตร',
    unitNameEn: 'Milliliter',
    unitType: 'volume',
    baseUnit: 'L',
    conversionFactor: 0.001
  },
  {
    unitCode: 'L',
    unitName: 'ลิตร',
    unitNameEn: 'Liter',
    unitType: 'volume',
    baseUnit: 'L',
    conversionFactor: 1.0
  },
  {
    unitCode: 'TAB',
    unitName: 'เม็ด',
    unitNameEn: 'Tablet',
    unitType: 'count',
    baseUnit: 'TAB',
    conversionFactor: 1.0
  },
  {
    unitCode: 'CAP',
    unitName: 'แคปซูล',
    unitNameEn: 'Capsule',
    unitType: 'count',
    baseUnit: 'CAP',
    conversionFactor: 1.0
  },
  {
    unitCode: 'AMP',
    unitName: 'แอมพูล',
    unitNameEn: 'Ampoule',
    unitType: 'count',
    baseUnit: 'AMP',
    conversionFactor: 1.0
  },
  {
    unitCode: 'VIA',
    unitName: 'ไวอัล',
    unitNameEn: 'Vial',
    unitType: 'count',
    baseUnit: 'VIA',
    conversionFactor: 1.0
  },
  {
    unitCode: 'BOT',
    unitName: 'ขวด',
    unitNameEn: 'Bottle',
    unitType: 'count',
    baseUnit: 'BOT',
    conversionFactor: 1.0
  },
  {
    unitCode: 'MCG',
    unitName: 'ไมโครกรัม',
    unitNameEn: 'Microgram',
    unitType: 'weight',
    baseUnit: 'G',
    conversionFactor: 0.000001
  },
  {
    unitCode: 'IU',
    unitName: 'หน่วยสากล',
    unitNameEn: 'International Unit',
    unitType: 'strength',
    baseUnit: 'IU',
    conversionFactor: 1.0
  }
];

// Sample HIS Drug Master Data (ข้อมูลยาตัวอย่างจาก HIS)
const sampleHisDrugs = [
  {
    hisDrugCode: 'HIS001',
    drugName: 'PARACETAMOL 500 MG TABLET',
    genericName: 'Paracetamol',
    strength: '500 mg',
    dosageForm: 'Tablet',
    manufacturer: 'GPO',
    registrationNumber: 'REG-001-2024',
    mappingStatus: 'PENDING' as const
  },
  {
    hisDrugCode: 'HIS002', 
    drugName: 'AMOXICILLIN 250 MG CAPSULE',
    genericName: 'Amoxicillin',
    strength: '250 mg',
    dosageForm: 'Capsule',
    manufacturer: 'Zuellig Pharma',
    registrationNumber: 'REG-002-2024',
    mappingStatus: 'PENDING' as const
  },
  {
    hisDrugCode: 'HIS003',
    drugName: 'IBUPROFEN 400 MG TABLET',
    genericName: 'Ibuprofen', 
    strength: '400 mg',
    dosageForm: 'Tablet',
    manufacturer: 'Pfizer',
    registrationNumber: 'REG-003-2024',
    mappingStatus: 'PENDING' as const
  },
  {
    hisDrugCode: 'HIS004',
    drugName: 'ASPIRIN 81 MG TABLET',
    genericName: 'Aspirin',
    strength: '81 mg',
    dosageForm: 'Tablet',
    manufacturer: 'GPO',
    registrationNumber: 'REG-004-2024',
    mappingStatus: 'PENDING' as const
  },
  {
    hisDrugCode: 'HIS005',
    drugName: 'OMEPRAZOLE 20 MG CAPSULE',
    genericName: 'Omeprazole',
    strength: '20 mg',
    dosageForm: 'Capsule',
    manufacturer: 'Berlin Pharmaceutical',
    registrationNumber: 'REG-005-2024',
    mappingStatus: 'PENDING' as const
  }
];

async function main() {
  console.log('🌱 Seeding TMT reference data...');

  try {
    // 1. Seed TMT Manufacturers
    console.log('📊 Seeding TMT Manufacturers...');
    for (const manufacturer of tmtManufacturers) {
      await prisma.tmtManufacturer.upsert({
        where: { manufacturerCode: manufacturer.manufacturerCode },
        update: manufacturer,
        create: manufacturer,
      });
    }
    console.log(`✅ Created ${tmtManufacturers.length} TMT manufacturers`);

    // 2. Seed TMT Dosage Forms
    console.log('📊 Seeding TMT Dosage Forms...');
    for (const dosageForm of tmtDosageForms) {
      await prisma.tmtDosageForm.upsert({
        where: { formCode: dosageForm.formCode },
        update: dosageForm,
        create: dosageForm,
      });
    }
    console.log(`✅ Created ${tmtDosageForms.length} TMT dosage forms`);

    // 3. Seed TMT Units
    console.log('📊 Seeding TMT Units...');
    for (const unit of tmtUnits) {
      await prisma.tmtUnit.upsert({
        where: { unitCode: unit.unitCode },
        update: unit,
        create: unit,
      });
    }
    console.log(`✅ Created ${tmtUnits.length} TMT units`);

    // 4. Seed Sample HIS Drug Master
    console.log('📊 Seeding Sample HIS Drug Master...');
    for (const drug of sampleHisDrugs) {
      await prisma.hisDrugMaster.upsert({
        where: { hisDrugCode: drug.hisDrugCode },
        update: drug,
        create: drug,
      });
    }
    console.log(`✅ Created ${sampleHisDrugs.length} HIS drug records`);

    // 5. Show Statistics
    const stats = await Promise.all([
      prisma.tmtManufacturer.count(),
      prisma.tmtDosageForm.count(),
      prisma.tmtUnit.count(),
      prisma.hisDrugMaster.count(),
      prisma.tmtConcept.count(),
      prisma.tmtMapping.count()
    ]);

    console.log('\n📈 TMT System Statistics:');
    console.log(`   TMT Manufacturers: ${stats[0]}`);
    console.log(`   TMT Dosage Forms: ${stats[1]}`);
    console.log(`   TMT Units: ${stats[2]}`);
    console.log(`   HIS Drug Master: ${stats[3]}`);
    console.log(`   TMT Concepts: ${stats[4]}`);
    console.log(`   TMT Mappings: ${stats[5]}`);

    console.log('\n🎉 TMT reference data seeding completed successfully!');

  } catch (error) {
    console.error('❌ Error seeding TMT reference data:', error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

if (require.main === module) {
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
}

export default main;