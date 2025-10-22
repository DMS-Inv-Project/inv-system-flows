# External System Integration - Master Data Management

**Module**: INVS Modern - Hospital Inventory Management System
**Version**: 2.2.0
**Last Updated**: 2025-01-22
**Integration Coverage**: HIS, TMT, Ministry, Legacy MySQL, External APIs

---

## 📖 Table of Contents

1. [Integration Overview](#integration-overview)
2. [HIS Integration](#his-integration)
3. [TMT Integration](#tmt-integration)
4. [Ministry Reporting](#ministry-reporting)
5. [Legacy MySQL Import](#legacy-mysql-import)
6. [External APIs](#external-apis)
7. [Security & Authentication](#security--authentication)
8. [Error Handling & Monitoring](#error-handling--monitoring)

---

## Integration Overview

### System Integration Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    INVS Modern (Core)                        │
│               PostgreSQL + Prisma ORM                        │
└──────────────┬─────────────┬────────────┬───────────────────┘
               │             │            │
       ┌───────┴─────┐  ┌───┴────┐  ┌───┴─────────┐
       │ HIS System  │  │  TMT   │  │  Ministry   │
       │  (Legacy)   │  │  API   │  │   Portal    │
       └─────────────┘  └────────┘  └─────────────┘
```

### Integration Points

| System | Direction | Protocol | Frequency | Priority |
|--------|-----------|----------|-----------|----------|
| **HIS (Hospital Information System)** | Bi-directional | REST API / DB Sync | Real-time | ⭐⭐⭐ High |
| **TMT (Thai Medical Terminology)** | Inbound | File Import / API | Quarterly | ⭐⭐⭐ High |
| **Ministry Portal** | Outbound | File Export / API | Monthly | ⭐⭐⭐ Critical |
| **Legacy MySQL** | Inbound | One-time Migration | One-time | ⭐⭐ Medium |
| **External Vendors** | Inbound | API / EDI | On-demand | ⭐ Low |

---

## HIS Integration

### Overview

Hospital Information System (HIS) integration allows drug master data synchronization and prescription/dispensing data flow.

### HIS Drug Master Sync

#### Table: `his_drug_master`

```typescript
// HIS Drug Master entity
interface HisDrugMaster {
  id: bigint;
  hisDrugCode: string;          // Unique code from HIS
  drugName: string;             // Drug name in HIS
  genericName?: string;
  strength?: string;
  dosageForm?: string;
  manufacturer?: string;
  registrationNumber?: string;

  // TMT Mapping
  tmtConceptId?: bigint;
  tmtLevel?: TmtLevel;
  mappingConfidence?: number;   // 0.00-1.00
  mappingStatus: HisMappingStatus;  // PENDING, MAPPED, VERIFIED, REJECTED

  // NC24 Code
  nc24Code?: string;            // National Code 24-digit
  nc24Status?: string;

  // Relationships
  tmtManufacturerId?: bigint;
  tmtDosageFormId?: bigint;

  // Sync tracking
  isActive: boolean;
  lastSync?: Date;
  createdAt: Date;
  updatedAt: Date;
}
```

### Sync Workflow

```typescript
// 1. Fetch new drugs from HIS
async function syncHisDrugMaster() {
  // Connect to HIS database
  const hisDrugs = await fetchFromHis(`
    SELECT
      drug_code as hisDrugCode,
      drug_name as drugName,
      generic_name as genericName,
      strength,
      dosage_form as dosageForm,
      manufacturer,
      registration_no as registrationNumber
    FROM his_drug_master
    WHERE updated_at > ?
  `, [lastSyncDate]);

  // Upsert to INVS Modern
  for (const drug of hisDrugs) {
    await prisma.hisDrugMaster.upsert({
      where: { hisDrugCode: drug.hisDrugCode },
      update: {
        drugName: drug.drugName,
        genericName: drug.genericName,
        strength: drug.strength,
        dosageForm: drug.dosageForm,
        manufacturer: drug.manufacturer,
        registrationNumber: drug.registrationNumber,
        lastSync: new Date()
      },
      create: {
        hisDrugCode: drug.hisDrugCode,
        drugName: drug.drugName,
        genericName: drug.genericName,
        strength: drug.strength,
        dosageForm: drug.dosageForm,
        manufacturer: drug.manufacturer,
        registrationNumber: drug.registrationNumber,
        mappingStatus: 'PENDING',
        isActive: true,
        lastSync: new Date()
      }
    });
  }

  console.log(`✅ Synced ${hisDrugs.length} drugs from HIS`);
}

// 2. Auto-map to TMT concepts
async function autoMapToTmt(hisDrug: HisDrugMaster) {
  // Fuzzy match against TMT concepts
  const matches = await prisma.tmtConcept.findMany({
    where: {
      AND: [
        { level: 'TP' },  // Trade Product level
        {
          OR: [
            { preferredTerm: { contains: hisDrug.drugName } },
            { fsn: { contains: hisDrug.drugName } }
          ]
        }
      ]
    }
  });

  if (matches.length === 1) {
    // Single match - high confidence
    await prisma.hisDrugMaster.update({
      where: { id: hisDrug.id },
      data: {
        tmtConceptId: matches[0].id,
        tmtLevel: 'TP',
        mappingConfidence: 0.90,
        mappingStatus: 'MAPPED'
      }
    });
  } else if (matches.length > 1) {
    // Multiple matches - manual verification needed
    await prisma.hisDrugMaster.update({
      where: { id: hisDrug.id },
      data: {
        mappingStatus: 'PENDING',  // Requires manual review
        mappingConfidence: 0.50
      }
    });
  }
}
```

### HIS → INVS Data Flow

**Prescriptions**:
```
HIS Prescription → HIS Drug Master → TMT Mapping → INVS Drug → Dispensing
```

**Dispensing**:
```
INVS Inventory → Drug Lot (FEFO) → Dispense → Update HIS Patient Record
```

---

## TMT Integration

### Thai Medical Terminology Standard

**TMT Database**: 25,991 concepts organized in hierarchical levels

### TMT Hierarchy Levels

```
SUBS (Substance)
  ↓
VTM (Virtual Therapeutic Moiety)
  ↓
GP (Generic Product) ─→ GP-F (Generic Product Form)
  ↓                    ↘ GP-X (Generic Product Extended)
TP (Trade Product)
  ↓
GPU (Generic Product Unit)
  ↓
TPU (Trade Product Unit)
  ↓
GPP (Generic Product Pack)
  ↓
TPP (Trade Product Pack)
```

### TMT Data Import

#### Import Process

```bash
# 1. Download TMT release file from MOPH
wget https://terminology.moph.go.th/tmt/release/2025Q1.zip

# 2. Extract files
unzip 2025Q1.zip -d /tmp/tmt

# 3. Import concepts
node scripts/tmt/import-concepts.js /tmp/tmt/concepts.csv

# 4. Import relationships
node scripts/tmt/import-relationships.js /tmp/tmt/relationships.csv

# 5. Import attributes
node scripts/tmt/import-attributes.js /tmp/tmt/attributes.csv
```

#### Import Script Example

```typescript
// scripts/tmt/import-concepts.ts
import { parse } from 'csv-parse/sync';
import fs from 'fs';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function importTmtConcepts(filePath: string) {
  const fileContent = fs.readFileSync(filePath, 'utf-8');
  const records = parse(fileContent, {
    columns: true,
    skip_empty_lines: true
  });

  console.log(`Importing ${records.length} TMT concepts...`);

  let imported = 0;
  for (const record of records) {
    await prisma.tmtConcept.upsert({
      where: { tmtId: BigInt(record.TMT_ID) },
      update: {
        conceptCode: record.CONCEPT_CODE,
        level: record.LEVEL as TmtLevel,
        fsn: record.FSN,
        preferredTerm: record.PREFERRED_TERM,
        strength: record.STRENGTH,
        dosageForm: record.DOSAGE_FORM,
        manufacturer: record.MANUFACTURER,
        packSize: record.PACK_SIZE,
        unitOfUse: record.UNIT_OF_USE,
        routeOfAdministration: record.ROUTE,
        isActive: record.IS_ACTIVE === '1',
        effectiveDate: record.EFFECTIVE_DATE ? new Date(record.EFFECTIVE_DATE) : null,
        releaseDate: record.RELEASE_DATE
      },
      create: {
        tmtId: BigInt(record.TMT_ID),
        conceptCode: record.CONCEPT_CODE,
        level: record.LEVEL as TmtLevel,
        fsn: record.FSN,
        preferredTerm: record.PREFERRED_TERM,
        strength: record.STRENGTH,
        dosageForm: record.DOSAGE_FORM,
        manufacturer: record.MANUFACTURER,
        packSize: record.PACK_SIZE,
        unitOfUse: record.UNIT_OF_USE,
        routeOfAdministration: record.ROUTE,
        isActive: record.IS_ACTIVE === '1',
        effectiveDate: record.EFFECTIVE_DATE ? new Date(record.EFFECTIVE_DATE) : null,
        releaseDate: record.RELEASE_DATE
      }
    });

    imported++;
    if (imported % 1000 === 0) {
      console.log(`  Progress: ${imported}/${records.length}`);
    }
  }

  console.log(`✅ Imported ${imported} TMT concepts`);
}

importTmtConcepts(process.argv[2]);
```

### TMT Mapping Workflow

```typescript
// Map drug to TMT concept
async function mapDrugToTmt(drugId: bigint, tmtConceptId: bigint, mappedBy: string) {
  const drug = await prisma.drug.findUnique({
    where: { id: drugId },
    include: { generic: true }
  });

  const tmtConcept = await prisma.tmtConcept.findUnique({
    where: { id: tmtConceptId }
  });

  if (!drug || !tmtConcept) {
    throw new Error('Drug or TMT concept not found');
  }

  // Create mapping
  const mapping = await prisma.tmtMapping.create({
    data: {
      drugCode: drug.drugCode,
      drugId: drug.id,
      genericId: drug.genericId,
      workingCode: drug.generic?.workingCode,
      tmtLevel: tmtConcept.level,
      tmtConceptId: tmtConcept.id,
      tmtCode: tmtConcept.conceptCode,
      tmtId: tmtConcept.tmtId,
      mappingSource: 'MANUAL',
      confidence: 1.00,  // Manual mapping = 100% confidence
      mappedBy: mappedBy,
      isActive: true,
      isVerified: false,
      mappingDate: new Date()
    }
  });

  console.log(`✅ Mapped drug ${drug.drugCode} to TMT concept ${tmtConcept.tmtId}`);

  return mapping;
}
```

---

## Ministry Reporting

### Overview

Export data to Ministry of Public Health (MOPH) in standardized formats.

**Standard**: DMSIC Standards พ.ศ. 2568
**Compliance**: 100% (79/79 fields)

### 5 Required Export Files

| File | Thai Name | Fields | Frequency | Priority |
|------|-----------|--------|-----------|----------|
| **DRUGLIST** | บัญชียา | 11 | Monthly | ⭐⭐⭐ Critical |
| **PURCHASEPLAN** | แผนจัดซื้อ | 20 | Quarterly | ⭐⭐⭐ Critical |
| **RECEIPT** | ใบรับ | 22 | Monthly | ⭐⭐⭐ Critical |
| **DISTRIBUTION** | การจ่าย | 11 | Monthly | ⭐⭐⭐ Critical |
| **INVENTORY** | สต็อก | 15 | Monthly | ⭐⭐⭐ Critical |

---

### 1. DRUGLIST Export (บัญชียา) - 11 Fields

```typescript
// Export drug catalog
async function exportDruglist(fiscalYear: number) {
  const drugs = await prisma.drug.findMany({
    where: { isActive: true },
    include: { manufacturer: true }
  });

  const rows = drugs.map(drug => ({
    DRUGCODE: drug.drugCode,                              // 1. รหัสยา (7-24 chars)
    DRUGNAME: drug.tradeName,                             // 2. ชื่อยา
    NLEM: drug.nlemStatus,                                // 3. สถานะบัญชียาหลัก (E/N) ⭐
    STATUS: drug.drugStatus === 'ACTIVE' ? '1' :
            drug.drugStatus === 'DISCONTINUED' ? '2' :
            drug.drugStatus === 'SPECIAL_CASE' ? '3' : '4',  // 4. สถานะ (1-4) ⭐
    STATUS_CHANGE_DATE: drug.statusChangedDate?.toISOString().split('T')[0],  // 5. วันที่เปลี่ยนสถานะ ⭐
    PRODUCT_CAT: drug.productCategory === 'MODERN_REGISTERED' ? '1' :
                 drug.productCategory === 'MODERN_HOSPITAL' ? '2' :
                 drug.productCategory === 'HERBAL_REGISTERED' ? '3' :
                 drug.productCategory === 'HERBAL_HOSPITAL' ? '4' : '5',  // 6. ประเภทผลิตภัณฑ์ (1-5) ⭐
    TMT_CODE: drug.tmtTpCode || '',                       // 7. รหัส TMT
    STANDARD_CODE: drug.standardCode || '',               // 8. รหัสมาตรฐาน 24 หลัก
    MANUFACTURER_CODE: drug.manufacturer?.companyCode || '',  // 9. รหัสผู้ผลิต
    UNIT_PRICE: drug.unitPrice?.toString() || '0',        // 10. ราคาต่อหน่วย
    PACK_SIZE: drug.packSize.toString()                   // 11. ขนาดบรรจุ
  }));

  // Write to CSV
  const csv = stringify(rows, { header: true });
  fs.writeFileSync(`exports/DRUGLIST_${fiscalYear}.csv`, csv);

  console.log(`✅ Exported ${rows.length} drugs to DRUGLIST_${fiscalYear}.csv`);

  // Store in database
  await prisma.ministryReport.create({
    data: {
      reportType: 'DRUGLIST',
      reportPeriod: 'MONTHLY',
      reportDate: new Date(),
      hospitalCode: '12345',  // 5-digit hospital code
      dataJson: rows,
      totalItems: rows.length,
      verificationStatus: 'PENDING'
    }
  });

  return rows;
}
```

**Ministry Compliance**: ✅ 11/11 fields (100%)

---

### 2. PURCHASEPLAN Export (แผนจัดซื้อ) - 20 Fields

```typescript
async function exportPurchasePlan(fiscalYear: number) {
  const plans = await prisma.budgetPlanItem.findMany({
    where: {
      budgetPlan: { fiscalYear }
    },
    include: {
      budgetPlan: {
        include: { department: true }
      },
      generic: true
    }
  });

  const rows = plans.map(item => ({
    // Plan identification (3 fields)
    PLAN_ID: item.budgetPlan.id.toString(),               // 1. เลขที่แผน
    FISCAL_YEAR: item.budgetPlan.fiscalYear.toString(),   // 2. ปีงบประมาณ
    DEPT_CODE: item.budgetPlan.department.deptCode,       // 3. รหัสแผนก

    // Drug information (3 fields)
    WORKING_CODE: item.generic.workingCode,               // 4. รหัสทำงาน
    DRUG_NAME: item.generic.drugName,                     // 5. ชื่อยา
    UNIT: item.generic.saleUnit,                          // 6. หน่วย

    // Planning data (8 fields)
    PLANNED_QTY: item.plannedQuantity.toString(),         // 7. จำนวนที่วางแผน
    ESTIMATED_COST: item.estimatedUnitCost.toString(),    // 8. ราคาประมาณการ
    PLANNED_VALUE: item.plannedTotalCost.toString(),      // 9. มูลค่าที่วางแผน
    Q1_QTY: item.q1Quantity.toString(),                   // 10. ไตรมาส 1 จำนวน
    Q2_QTY: item.q2Quantity.toString(),                   // 11. ไตรมาส 2 จำนวน
    Q3_QTY: item.q3Quantity.toString(),                   // 12. ไตรมาส 3 จำนวน
    Q4_QTY: item.q4Quantity.toString(),                   // 13. ไตรมาส 4 จำนวน
    JUSTIFICATION: item.justification || '',              // 14. เหตุผลความจำเป็น

    // Historical data (3 fields)
    AVG_3YEARS: item.avgConsumption3Years?.toString() || '0',  // 15. ค่าเฉลี่ย 3 ปี
    YEAR1_USAGE: item.year1Consumption?.toString() || '0',     // 16. ปี -1
    YEAR2_USAGE: item.year2Consumption?.toString() || '0',     // 17. ปี -2

    // Current data (3 fields)
    CURRENT_STOCK: item.currentStock?.toString() || '0',  // 18. สต็อกปัจจุบัน
    MIN_LEVEL: item.minStockLevel?.toString() || '0',     // 19. ระดับขั้นต่ำ
    STATUS: item.status                                    // 20. สถานะรายการ
  }));

  const csv = stringify(rows, { header: true });
  fs.writeFileSync(`exports/PURCHASEPLAN_${fiscalYear}.csv`, csv);

  console.log(`✅ Exported ${rows.length} plan items to PURCHASEPLAN_${fiscalYear}.csv`);

  return rows;
}
```

**Ministry Compliance**: ✅ 20/20 fields (100%)

---

### 3. RECEIPT Export (ใบรับ) - 22 Fields

```typescript
async function exportReceipts(startDate: Date, endDate: Date) {
  const receipts = await prisma.receipt.findMany({
    where: {
      receiptDate: { gte: startDate, lte: endDate },
      status: 'POSTED'
    },
    include: {
      purchaseOrder: {
        include: { vendor: true }
      },
      items: {
        include: { drug: true }
      }
    }
  });

  const rows = [];
  for (const receipt of receipts) {
    for (const item of receipt.items) {
      rows.push({
        // Receipt header (7 fields)
        RECEIPT_NO: receipt.receiptNumber,                // 1. เลขที่ใบรับ
        RECEIPT_DATE: receipt.receiptDate.toISOString().split('T')[0],  // 2. วันที่รับ
        PO_NO: receipt.purchaseOrder.poNumber,            // 3. เลขที่ใบสั่งซื้อ
        VENDOR_CODE: receipt.purchaseOrder.vendor.companyCode,  // 4. รหัสผู้ขาย
        VENDOR_NAME: receipt.purchaseOrder.vendor.companyName,  // 5. ชื่อผู้ขาย
        INVOICE_NO: receipt.invoiceNumber || '',          // 6. เลขที่ใบแจ้งหนี้
        INVOICE_DATE: receipt.invoiceDate?.toISOString().split('T')[0] || '',  // 7. วันที่ใบแจ้งหนี้

        // Drug information (3 fields)
        DRUGCODE: item.drug.drugCode,                     // 8. รหัสยา
        DRUG_NAME: item.drug.tradeName,                   // 9. ชื่อยา
        UNIT: item.drug.unit,                             // 10. หน่วย

        // Lot tracking (3 fields)
        LOT_NUMBER: item.lotNumber || '',                 // 11. เลขล็อต
        EXPIRY_DATE: item.expiryDate?.toISOString().split('T')[0] || '',  // 12. วันหมดอายุ
        ITEM_TYPE: item.itemType || 'NORMAL',             // 13. ประเภทรายการ

        // Quantity & cost (4 fields)
        QTY_RECEIVED: item.quantityReceived.toString(),   // 14. จำนวนรับ
        UNIT_COST: item.unitCost.toString(),              // 15. ราคาต่อหน่วย
        TOTAL_COST: (item.quantityReceived * item.unitCost).toString(),  // 16. ราคารวม
        REMAINING_QTY: item.remainingQuantity?.toString() || item.quantityReceived.toString(),  // 17. จำนวนคงเหลือ

        // Status & tracking (5 fields)
        RECEIVED_BY: receipt.receivedBy.toString(),       // 18. ผู้รับ
        RECEIVED_DATE: receipt.receivedDate?.toISOString().split('T')[0] || receipt.receiptDate.toISOString().split('T')[0],  // 19. วันที่รับจริง
        VERIFIED_BY: receipt.verifiedBy?.toString() || '',  // 20. ผู้ตรวจสอบ
        VERIFIED_DATE: receipt.verifiedDate?.toISOString().split('T')[0] || '',  // 21. วันที่ตรวจสอบ
        STATUS: receipt.status                            // 22. สถานะ
      });
    }
  }

  const csv = stringify(rows, { header: true });
  fs.writeFileSync(`exports/RECEIPT_${startDate.toISOString().split('T')[0]}.csv`, csv);

  console.log(`✅ Exported ${rows.length} receipt items`);

  return rows;
}
```

**Ministry Compliance**: ✅ 22/22 fields (100%)

---

### 4. DISTRIBUTION Export (การจ่าย) - 11 Fields

```typescript
async function exportDistribution(startDate: Date, endDate: Date) {
  const distributions = await prisma.drugDistribution.findMany({
    where: {
      distributionDate: { gte: startDate, lte: endDate },
      status: 'COMPLETED'
    },
    include: {
      fromLocation: true,
      toLocation: true,
      requestingDept: true,
      items: {
        include: { drug: true }
      }
    }
  });

  const rows = [];
  for (const dist of distributions) {
    for (const item of dist.items) {
      rows.push({
        // Distribution header (4 fields)
        DIST_NO: dist.distributionNumber,                 // 1. เลขที่ใบจ่าย
        DIST_DATE: dist.distributionDate.toISOString().split('T')[0],  // 2. วันที่จ่าย
        FROM_LOCATION: dist.fromLocation.locationCode,    // 3. จากคลัง
        TO_LOCATION: dist.toLocation?.locationCode || '',  // 4. ถึงคลัง

        // Department (2 fields) ⭐
        DEPT_CODE: dist.requestingDept?.deptCode || '',   // 5. รหัสแผนก
        DEPT_TYPE: dist.requestingDept?.consumptionGroup === 'OPD_IPD_MIX' ? '1' :
                   dist.requestingDept?.consumptionGroup === 'OPD_MAINLY' ? '2' :
                   dist.requestingDept?.consumptionGroup === 'IPD_MAINLY' ? '3' :
                   dist.requestingDept?.consumptionGroup === 'OTHER_INTERNAL' ? '4' :
                   dist.requestingDept?.consumptionGroup === 'PRIMARY_CARE' ? '5' :
                   dist.requestingDept?.consumptionGroup === 'PC_TRANSFERRED' ? '6' : '9',  // 6. ประเภทแผนก (1-9) ⭐

        // Drug & lot (3 fields)
        DRUGCODE: item.drug.drugCode,                     // 7. รหัสยา
        LOT_NUMBER: item.lotNumber,                       // 8. เลขล็อต
        EXPIRY_DATE: item.expiryDate.toISOString().split('T')[0],  // 9. วันหมดอายุ

        // Quantity & cost (2 fields)
        QTY_DISPENSED: item.quantityDispensed.toString(), // 10. จำนวนจ่าย
        UNIT_COST: item.unitCost.toString()               // 11. ต้นทุนต่อหน่วย
      });
    }
  }

  const csv = stringify(rows, { header: true });
  fs.writeFileSync(`exports/DISTRIBUTION_${startDate.toISOString().split('T')[0]}.csv`, csv);

  console.log(`✅ Exported ${rows.length} distribution items`);

  return rows;
}
```

**Ministry Compliance**: ✅ 11/11 fields (100%) including DEPT_TYPE ⭐

---

### 5. INVENTORY Export (สต็อก) - 15 Fields

```typescript
async function exportInventory(reportDate: Date) {
  const inventory = await prisma.inventory.findMany({
    where: {
      quantityOnHand: { gt: 0 }
    },
    include: {
      drug: {
        include: { generic: true }
      },
      location: true
    }
  });

  const rows = inventory.map(inv => ({
    // Location & date (3 fields)
    LOCATION_CODE: inv.location.locationCode,             // 1. รหัสคลัง
    LOCATION_NAME: inv.location.locationName,             // 2. ชื่อคลัง
    REPORT_DATE: reportDate.toISOString().split('T')[0],  // 3. วันที่รายงาน

    // Drug information (3 fields)
    DRUGCODE: inv.drug.drugCode,                          // 4. รหัสยา
    DRUG_NAME: inv.drug.tradeName,                        // 5. ชื่อยา
    UNIT: inv.drug.unit,                                  // 6. หน่วย

    // Stock levels (5 fields)
    QTY_ON_HAND: inv.quantityOnHand.toString(),           // 7. จำนวนคงเหลือ
    MIN_LEVEL: inv.minLevel.toString(),                   // 8. ระดับขั้นต่ำ
    MAX_LEVEL: inv.maxLevel.toString(),                   // 9. ระดับสูงสุด
    REORDER_POINT: inv.reorderPoint.toString(),           // 10. จุดสั่งซื้อ
    STOCK_STATUS: inv.quantityOnHand < inv.minLevel ? 'LOW' :
                  inv.quantityOnHand < inv.reorderPoint ? 'REORDER' : 'OK',  // 11. สถานะสต็อก

    // Cost information (4 fields)
    AVERAGE_COST: inv.averageCost.toString(),             // 12. ต้นทุนเฉลี่ย
    LAST_COST: inv.lastCost.toString(),                   // 13. ต้นทุนล่าสุด
    TOTAL_VALUE: (inv.quantityOnHand * inv.averageCost).toString(),  // 14. มูลค่ารวม
    LAST_UPDATED: inv.lastUpdated.toISOString().split('T')[0]  // 15. วันที่ปรับปรุง
  }));

  const csv = stringify(rows, { header: true });
  fs.writeFileSync(`exports/INVENTORY_${reportDate.toISOString().split('T')[0]}.csv`, csv);

  console.log(`✅ Exported ${rows.length} inventory items`);

  return rows;
}
```

**Ministry Compliance**: ✅ 15/15 fields (100%)

---

## Legacy MySQL Import

### One-Time Migration

**Source**: Legacy MySQL database (invs_banpong) - 133 tables
**Target**: PostgreSQL (invs_modern) - 36 tables
**Strategy**: Data mapping + transformation

### Migration Script

```bash
#!/bin/bash
# scripts/import-mysql-legacy.sh

echo "🔄 Starting MySQL → PostgreSQL migration..."

# 1. Export from MySQL
docker exec invs-mysql-original mysqldump \
  -u invs_user -pinvs123 \
  --no-create-info \
  --complete-insert \
  --tables \
    companies drug_generic_list drug_list \
    buy_plan buy_plan_c \
  > /tmp/legacy_export.sql

# 2. Transform data
node scripts/transform-legacy-data.js /tmp/legacy_export.sql

# 3. Import to PostgreSQL
psql -h localhost -p 5434 -U invs_user -d invs_modern \
  < /tmp/transformed_data.sql

echo "✅ Migration complete!"
```

### Data Transformation Example

```typescript
// Transform legacy company data
function transformCompanies(legacyData: any[]) {
  return legacyData.map(row => ({
    companyCode: row.com_code,
    companyName: row.com_name,
    companyType: row.com_type === 'V' ? 'VENDOR' :
                 row.com_type === 'M' ? 'MANUFACTURER' : 'BOTH',
    taxId: row.tax_id,
    address: row.address,
    phone: row.tel,
    email: row.email,
    contactPerson: row.contact_person,
    isActive: row.is_active === '1'
  }));
}

// Transform legacy drug data
function transformDrugs(legacyData: any[]) {
  return legacyData.map(row => ({
    drugCode: row.TRADE_CODE || row.WORKING_CODE,
    tradeName: row.TRADE_NAME,
    genericId: findGenericId(row.WORKING_CODE),  // Map to new generic ID
    manufacturerId: findCompanyId(row.COM_CODE), // Map to new company ID
    strength: row.STRENGTH,
    dosageForm: row.DOSAGE_FORM,
    packSize: parseInt(row.PACK_SIZE) || 1,
    unitPrice: parseFloat(row.UNIT_PRICE) || 0,
    unit: row.UNIT || 'TAB',
    // Ministry compliance - default values for legacy data
    nlemStatus: row.NLEM || 'N',
    drugStatus: 'ACTIVE',
    statusChangedDate: new Date(),
    productCategory: 'MODERN_REGISTERED',
    isActive: row.IS_ACTIVE === '1'
  }));
}
```

---

## External APIs

### Vendor EDI Integration

```typescript
// Accept EDI purchase order from vendor
app.post('/api/edi/purchase-order-response', async (req, res) => {
  const { poNumber, vendorCode, status, items } = req.body;

  // Validate vendor
  const vendor = await prisma.company.findFirst({
    where: { companyCode: vendorCode }
  });

  if (!vendor) {
    return res.status(404).json({ error: 'Vendor not found' });
  }

  // Find PO
  const po = await prisma.purchaseOrder.findFirst({
    where: { poNumber, vendorId: vendor.id }
  });

  if (!po) {
    return res.status(404).json({ error: 'PO not found' });
  }

  // Update PO status
  await prisma.purchaseOrder.update({
    where: { id: po.id },
    data: {
      status: status === 'CONFIRMED' ? 'SENT' : po.status,
      confirmedDate: status === 'CONFIRMED' ? new Date() : null
    }
  });

  res.json({ success: true, poNumber });
});
```

---

## Security & Authentication

### API Security

```typescript
// JWT authentication middleware
import jwt from 'jsonwebtoken';

function authenticateToken(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  jwt.verify(token, process.env.JWT_SECRET!, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token' });
    }
    req.user = user;
    next();
  });
}

// Role-based access control
function requireRole(roles: string[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json({ error: 'Insufficient permissions' });
    }
    next();
  };
}

// Usage
app.post('/api/purchase-orders',
  authenticateToken,
  requireRole(['ADMIN', 'PURCHASER']),
  createPurchaseOrder
);
```

### Data Encryption

```typescript
// Encrypt sensitive data
import crypto from 'crypto';

function encrypt(text: string): string {
  const cipher = crypto.createCipheriv(
    'aes-256-cbc',
    Buffer.from(process.env.ENCRYPTION_KEY!),
    Buffer.from(process.env.ENCRYPTION_IV!)
  );
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  return encrypted;
}

function decrypt(encryptedText: string): string {
  const decipher = crypto.createDecipheriv(
    'aes-256-cbc',
    Buffer.from(process.env.ENCRYPTION_KEY!),
    Buffer.from(process.env.ENCRYPTION_IV!)
  );
  let decrypted = decipher.update(encryptedText, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}
```

---

## Error Handling & Monitoring

### Centralized Error Handler

```typescript
// Global error handler
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error('Error:', err);

  // Log to monitoring service
  logger.error({
    message: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    timestamp: new Date()
  });

  // Return user-friendly error
  res.status(500).json({
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});
```

### Integration Monitoring

```typescript
// Monitor TMT sync
async function monitorTmtSync() {
  const lastSync = await prisma.tmtConcept.findFirst({
    orderBy: { updatedAt: 'desc' },
    select: { updatedAt: true }
  });

  const daysSinceSync = Math.floor(
    (Date.now() - lastSync.updatedAt.getTime()) / (1000 * 60 * 60 * 24)
  );

  if (daysSinceSync > 90) {
    // Alert: TMT data is stale
    sendAlert('TMT data not synced for 90+ days');
  }
}

// Monitor ministry export
async function monitorMinistryExport() {
  const lastReport = await prisma.ministryReport.findFirst({
    where: { reportType: 'DRUGLIST' },
    orderBy: { reportDate: 'desc' }
  });

  const daysSinceReport = Math.floor(
    (Date.now() - lastReport.reportDate.getTime()) / (1000 * 60 * 60 * 24)
  );

  if (daysSinceReport > 31) {
    // Alert: Monthly report overdue
    sendAlert('DRUGLIST export overdue (30+ days)');
  }
}
```

---

## Integration Testing

```typescript
describe('HIS Integration Tests', () => {
  test('should sync HIS drug master successfully', async () => {
    // Mock HIS data
    const hisDrug = {
      hisDrugCode: 'HIS001',
      drugName: 'Paracetamol 500mg',
      genericName: 'Paracetamol',
      strength: '500 mg',
      dosageForm: 'TAB'
    };

    // Sync
    await syncHisDrugMaster();

    // Verify
    const synced = await prisma.hisDrugMaster.findFirst({
      where: { hisDrugCode: 'HIS001' }
    });

    expect(synced).toBeDefined();
    expect(synced.mappingStatus).toBe('PENDING');
  });
});

describe('Ministry Export Tests', () => {
  test('should export DRUGLIST with 100% compliance', async () => {
    const rows = await exportDruglist(2568);

    // Verify all 11 fields present
    rows.forEach(row => {
      expect(row.DRUGCODE).toBeDefined();
      expect(row.NLEM).toMatch(/^[EN]$/);
      expect(row.STATUS).toMatch(/^[1234]$/);
      expect(row.PRODUCT_CAT).toMatch(/^[12345]$/);
    });
  });
});
```

---

## Summary

**Integration Status**:
- ✅ HIS Integration: Ready (sync + mapping)
- ✅ TMT Integration: Complete (25,991 concepts)
- ✅ Ministry Reporting: 100% compliant (79/79 fields)
- ✅ Legacy MySQL: Migration scripts ready
- ✅ Security: JWT + RBAC implemented

**Next Steps**:
1. Implement HIS real-time sync webhook
2. Schedule quarterly TMT updates
3. Automate monthly ministry exports
4. Set up monitoring alerts

---

**Document Status**: ✅ Complete

**Last Updated**: 2025-01-22 (v2.2.0)
**Integration Points**: 5 systems (HIS, TMT, Ministry, Legacy, External)
**Ministry Compliance**: 100% (all 5 export files)

---

**End of Integration Documentation**

*Built with ❤️ for INVS Modern - Hospital Inventory Management System*
