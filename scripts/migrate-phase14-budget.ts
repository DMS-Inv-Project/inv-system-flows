/**
 * Phase 14: Import Budget Management Data
 * ระบบงบประมาณ (แผนซื้อ/แผนงบ)
 *
 * Source: MySQL
 * - dept_id (103 records) → departments
 * - buyplan (3 records) → budget_plans
 * - buyplan_c (1,710 records) → budget_plan_items
 *
 * Run: npx tsx scripts/migrate-phase14-budget.ts
 */

import { PrismaClient } from '@prisma/client';
import mysql from 'mysql2/promise';

const prisma = new PrismaClient();

const mysqlConfig = {
  host: 'localhost',
  port: 3307,
  user: 'invs_user',
  password: 'invs123',
  database: 'invs_banpong',
  charset: 'utf8mb4'
};

interface DeptRow {
  DEPT_ID: string;
  DEPT_NAME: string | null;
  HIDE: string | null;
  DEPT_TYPE: number | null;
  KEEP_INV: string | null;
}

interface BuyplanRow {
  YEAR: string | null;
  DEPT_ID: string | null;
  VALUE_THIS_YEAR: number | null;
  TRIMESTER1: number | null;
  TRIMESTER2: number | null;
  TRIMESTER3: number | null;
  TRIMESTER4: number | null;
  BUY_TRIMES1: number | null;
  BUY_TRIMES2: number | null;
  BUY_TRIMES3: number | null;
  BUY_TRIMES4: number | null;
  REMAIN_VALUE: number | null;
  APPROVE: string | null;
}

interface BuyplanCRow {
  YEAR: string | null;
  DEPT_ID: string | null;
  WORKING_CODE: string | null;
  TRADE_CODE: string | null;
  QTY_THIS_YEAR: number | null;
  VALUE_THIS_YEAR: number | null;
  PACK_UNIT_COST: number | null;
  QTY_TRI1: number | null;
  QTY_TRI2: number | null;
  QTY_TRI3: number | null;
  QTY_TRI4: number | null;
  TRIMESTER1: number | null;
  TRIMESTER2: number | null;
  TRIMESTER3: number | null;
  TRIMESTER4: number | null;
  QTY_BUY_TRI1: number | null;
  QTY_BUY_TRI2: number | null;
  QTY_BUY_TRI3: number | null;
  QTY_BUY_TRI4: number | null;
  BUY_QTY: number | null;
  BUY_VALUE: number | null;
  REMAIN_QTY: number | null;
  REMAIN_VALUE: number | null;
  RATE_1_YEAR: number | null;
  RATE_2_YEAR: number | null;
  RATE_3_YEAR: number | null;
  AVG_3_YEAR: number | null;
  MIN_LEVEL: number | null;
  QTY_ON_HAND: number | null;
  HIDE: string | null;
}

async function main() {
  console.log('🚀 Phase 14: Importing Budget Management Data...\\n');

  const mysqlConn = await mysql.createConnection(mysqlConfig);

  try {
    // ===========================================
    // Step 1: Import Departments
    // ===========================================
    console.log('📋 Step 1/4: Importing Departments...');
    const [depts] = await mysqlConn.query<DeptRow[]>(`
      SELECT DEPT_ID, DEPT_NAME, HIDE, DEPT_TYPE, KEEP_INV
      FROM dept_id
      WHERE HIDE = 'N'
      ORDER BY DEPT_ID
    `);
    console.log(`   Source: ${depts.length} departments`);

    let deptImported = 0;
    const deptCodeToId = new Map<string, bigint>();

    for (const row of depts) {
      const deptCode = row.DEPT_ID.trim();
      const deptName = row.DEPT_NAME?.trim() || `Department-${deptCode}`;

      const existing = await prisma.department.findFirst({
        where: { deptCode: deptCode }
      });

      if (existing) {
        deptCodeToId.set(deptCode, existing.id);
      } else {
        const dept = await prisma.department.create({
          data: {
            deptCode: deptCode,
            deptName: deptName.slice(0, 100),
            isActive: true,
          }
        });
        deptCodeToId.set(deptCode, dept.id);
        deptImported++;
      }
    }

    // Also map existing seed departments
    const existingDepts = await prisma.department.findMany();
    for (const d of existingDepts) {
      deptCodeToId.set(d.deptCode, d.id);
    }

    console.log(`   ✅ Departments: ${deptImported} imported (${deptCodeToId.size} total mapped)\\n`);

    // ===========================================
    // Step 2: Build lookup maps
    // ===========================================
    console.log('📋 Step 2/4: Building lookup maps...');

    // Map working_code → generic.id
    const generics = await prisma.drugGeneric.findMany({
      select: { id: true, workingCode: true }
    });
    const workingCodeToGenericId = new Map<string, bigint>();
    for (const g of generics) {
      workingCodeToGenericId.set(g.workingCode.trim(), g.id);
    }
    console.log(`   - Generic codes: ${workingCodeToGenericId.size}`);

    // Get default budget allocation (or create one)
    let defaultAllocation = await prisma.budgetAllocation.findFirst({
      where: { fiscalYear: 2024 }
    });

    if (!defaultAllocation) {
      // Get or create budget type group
      let budgetTypeGroup = await prisma.budgetTypeGroup.findFirst();
      if (!budgetTypeGroup) {
        budgetTypeGroup = await prisma.budgetTypeGroup.create({
          data: {
            typeCode: 'DRUG',
            typeName: 'งบประมาณยา',
            isActive: true
          }
        });
      }

      // Get or create budget category
      let budgetCategory = await prisma.budgetCategory.findFirst();
      if (!budgetCategory) {
        budgetCategory = await prisma.budgetCategory.create({
          data: {
            categoryCode: 'MED',
            categoryName: 'ค่ายาและเวชภัณฑ์',
            isActive: true
          }
        });
      }

      // Get or create budget
      let budget = await prisma.budget.findFirst();
      if (!budget) {
        budget = await prisma.budget.create({
          data: {
            budgetCode: 'DRUG01',
            budgetType: budgetTypeGroup.typeCode,
            budgetCategory: budgetCategory.categoryCode,
            budgetDescription: 'งบประมาณจัดซื้อยาและเวชภัณฑ์',
            isActive: true
          }
        });
      }

      // Get first department
      const firstDept = await prisma.department.findFirst();

      defaultAllocation = await prisma.budgetAllocation.create({
        data: {
          fiscalYear: 2024,
          budgetId: budget.id,
          departmentId: firstDept!.id,
          totalBudget: 200000000,
          q1Budget: 50000000,
          q2Budget: 50000000,
          q3Budget: 50000000,
          q4Budget: 50000000,
          totalSpent: 0,
          q1Spent: 0,
          q2Spent: 0,
          q3Spent: 0,
          q4Spent: 0,
          remainingBudget: 200000000,
          status: 'ACTIVE'
        }
      });
    }

    console.log(`   - Default allocation ID: ${defaultAllocation.id}`);
    console.log('   ✅ Lookup maps ready\\n');

    // ===========================================
    // Step 3: Import Budget Plans (buyplan)
    // ===========================================
    console.log('📋 Step 3/4: Importing Budget Plans...');
    const [buyplans] = await mysqlConn.query<BuyplanRow[]>(`
      SELECT
        YEAR, DEPT_ID, VALUE_THIS_YEAR,
        TRIMESTER1, TRIMESTER2, TRIMESTER3, TRIMESTER4,
        BUY_TRIMES1, BUY_TRIMES2, BUY_TRIMES3, BUY_TRIMES4,
        REMAIN_VALUE, APPROVE
      FROM buyplan
      ORDER BY YEAR DESC
    `);
    console.log(`   Source: ${buyplans.length} budget plans`);

    const yearDeptToPlanId = new Map<string, bigint>();
    let plansImported = 0;

    for (const row of buyplans) {
      if (!row.YEAR || !row.DEPT_ID) continue;

      const year = parseInt(row.YEAR);
      const deptCode = row.DEPT_ID.trim();
      let departmentId = deptCodeToId.get(deptCode);

      if (!departmentId) {
        // Create department if not exists
        const newDept = await prisma.department.create({
          data: {
            deptCode: deptCode,
            deptName: `Department ${deptCode}`,
            isActive: true
          }
        });
        departmentId = newDept.id;
        deptCodeToId.set(deptCode, departmentId);
      }

      // Check if plan exists
      const existingPlan = await prisma.budgetPlan.findFirst({
        where: {
          fiscalYear: year,
          departmentId: departmentId
        }
      });

      let planId: bigint;

      if (existingPlan) {
        planId = existingPlan.id;
        await prisma.budgetPlan.update({
          where: { id: existingPlan.id },
          data: {
            totalPlannedBudget: row.VALUE_THIS_YEAR || 0,
            q1PlannedBudget: row.TRIMESTER1 || 0,
            q2PlannedBudget: row.TRIMESTER2 || 0,
            q3PlannedBudget: row.TRIMESTER3 || 0,
            q4PlannedBudget: row.TRIMESTER4 || 0,
            q1Purchased: row.BUY_TRIMES1 || 0,
            q2Purchased: row.BUY_TRIMES2 || 0,
            q3Purchased: row.BUY_TRIMES3 || 0,
            q4Purchased: row.BUY_TRIMES4 || 0,
            totalPurchased: (row.BUY_TRIMES1 || 0) + (row.BUY_TRIMES2 || 0) +
                           (row.BUY_TRIMES3 || 0) + (row.BUY_TRIMES4 || 0),
            remainingBudget: row.REMAIN_VALUE || 0,
            status: row.APPROVE === 'Y' ? 'APPROVED' : 'DRAFT'
          }
        });
      } else {
        const plan = await prisma.budgetPlan.create({
          data: {
            fiscalYear: year,
            departmentId: departmentId,
            budgetAllocationId: defaultAllocation.id,
            totalPlannedBudget: row.VALUE_THIS_YEAR || 0,
            totalPlannedQuantity: 0,
            q1PlannedBudget: row.TRIMESTER1 || 0,
            q2PlannedBudget: row.TRIMESTER2 || 0,
            q3PlannedBudget: row.TRIMESTER3 || 0,
            q4PlannedBudget: row.TRIMESTER4 || 0,
            q1Purchased: row.BUY_TRIMES1 || 0,
            q2Purchased: row.BUY_TRIMES2 || 0,
            q3Purchased: row.BUY_TRIMES3 || 0,
            q4Purchased: row.BUY_TRIMES4 || 0,
            totalPurchased: (row.BUY_TRIMES1 || 0) + (row.BUY_TRIMES2 || 0) +
                           (row.BUY_TRIMES3 || 0) + (row.BUY_TRIMES4 || 0),
            remainingBudget: row.REMAIN_VALUE || 0,
            status: row.APPROVE === 'Y' ? 'APPROVED' : 'DRAFT'
          }
        });
        planId = plan.id;
        plansImported++;
      }

      yearDeptToPlanId.set(`${year}-${deptCode}`, planId);
    }

    console.log(`   ✅ Budget plans: ${plansImported} imported (${yearDeptToPlanId.size} total)\\n`);

    // ===========================================
    // Step 4: Import Budget Plan Items (buyplan_c)
    // ===========================================
    console.log('📋 Step 4/4: Importing Budget Plan Items...');
    const [buyplanItems] = await mysqlConn.query<BuyplanCRow[]>(`
      SELECT
        YEAR, DEPT_ID, WORKING_CODE, TRADE_CODE,
        QTY_THIS_YEAR, VALUE_THIS_YEAR, PACK_UNIT_COST,
        QTY_TRI1, QTY_TRI2, QTY_TRI3, QTY_TRI4,
        TRIMESTER1, TRIMESTER2, TRIMESTER3, TRIMESTER4,
        QTY_BUY_TRI1, QTY_BUY_TRI2, QTY_BUY_TRI3, QTY_BUY_TRI4,
        BUY_QTY, BUY_VALUE, REMAIN_QTY, REMAIN_VALUE,
        RATE_1_YEAR, RATE_2_YEAR, RATE_3_YEAR, AVG_3_YEAR,
        MIN_LEVEL, QTY_ON_HAND, HIDE
      FROM buyplan_c
      WHERE HIDE IS NULL OR HIDE != 'Y'
      ORDER BY YEAR DESC, WORKING_CODE
    `);
    console.log(`   Source: ${buyplanItems.length} budget plan items`);

    let itemsImported = 0;
    let itemsSkipped = 0;
    let itemNumber = 0;

    for (const row of buyplanItems) {
      if (!row.YEAR || !row.DEPT_ID || !row.WORKING_CODE) {
        itemsSkipped++;
        continue;
      }

      const year = parseInt(row.YEAR);
      const deptCode = row.DEPT_ID.trim();
      const workingCode = row.WORKING_CODE.trim();

      // Get plan ID
      const planKey = `${year}-${deptCode}`;
      let planId = yearDeptToPlanId.get(planKey);

      if (!planId) {
        // Create plan if not exists
        let departmentId = deptCodeToId.get(deptCode);
        if (!departmentId) {
          const newDept = await prisma.department.create({
            data: {
              deptCode: deptCode,
              deptName: `Department ${deptCode}`,
              isActive: true
            }
          });
          departmentId = newDept.id;
          deptCodeToId.set(deptCode, departmentId);
        }

        const plan = await prisma.budgetPlan.create({
          data: {
            fiscalYear: year,
            departmentId: departmentId,
            budgetAllocationId: defaultAllocation.id,
            totalPlannedBudget: 0,
            totalPlannedQuantity: 0,
            q1PlannedBudget: 0,
            q2PlannedBudget: 0,
            q3PlannedBudget: 0,
            q4PlannedBudget: 0,
            remainingBudget: 0,
            status: 'DRAFT'
          }
        });
        planId = plan.id;
        yearDeptToPlanId.set(planKey, planId);
        itemNumber = 0;
      }

      // Get generic ID
      const genericId = workingCodeToGenericId.get(workingCode);
      if (!genericId) {
        itemsSkipped++;
        continue;
      }

      itemNumber++;

      try {
        // Check existing
        const existingItem = await prisma.budgetPlanItem.findFirst({
          where: {
            budgetPlanId: planId,
            genericId: genericId
          }
        });

        if (existingItem) {
          await prisma.budgetPlanItem.update({
            where: { id: existingItem.id },
            data: {
              plannedQuantity: row.QTY_THIS_YEAR || 0,
              estimatedUnitCost: row.PACK_UNIT_COST || 0,
              plannedTotalCost: row.VALUE_THIS_YEAR || 0,
              q1Quantity: row.QTY_TRI1 || 0,
              q2Quantity: row.QTY_TRI2 || 0,
              q3Quantity: row.QTY_TRI3 || 0,
              q4Quantity: row.QTY_TRI4 || 0,
              q1Budget: row.TRIMESTER1 || 0,
              q2Budget: row.TRIMESTER2 || 0,
              q3Budget: row.TRIMESTER3 || 0,
              q4Budget: row.TRIMESTER4 || 0,
              q1PurchasedQty: row.QTY_BUY_TRI1 || 0,
              q2PurchasedQty: row.QTY_BUY_TRI2 || 0,
              q3PurchasedQty: row.QTY_BUY_TRI3 || 0,
              q4PurchasedQty: row.QTY_BUY_TRI4 || 0,
              purchasedQuantity: row.BUY_QTY || 0,
              purchasedValue: row.BUY_VALUE || 0,
              remainingQuantity: row.REMAIN_QTY || 0,
              remainingValue: row.REMAIN_VALUE || 0,
              year1Consumption: row.RATE_1_YEAR,
              year2Consumption: row.RATE_2_YEAR,
              year3Consumption: row.RATE_3_YEAR,
              avgConsumption3Years: row.AVG_3_YEAR,
              minStockLevel: row.MIN_LEVEL,
              currentStock: row.QTY_ON_HAND
            }
          });
        } else {
          await prisma.budgetPlanItem.create({
            data: {
              budgetPlanId: planId,
              itemNumber: itemNumber,
              genericId: genericId,
              plannedQuantity: row.QTY_THIS_YEAR || 0,
              estimatedUnitCost: row.PACK_UNIT_COST || 0,
              plannedTotalCost: row.VALUE_THIS_YEAR || 0,
              q1Quantity: row.QTY_TRI1 || 0,
              q2Quantity: row.QTY_TRI2 || 0,
              q3Quantity: row.QTY_TRI3 || 0,
              q4Quantity: row.QTY_TRI4 || 0,
              q1Budget: row.TRIMESTER1 || 0,
              q2Budget: row.TRIMESTER2 || 0,
              q3Budget: row.TRIMESTER3 || 0,
              q4Budget: row.TRIMESTER4 || 0,
              q1PurchasedQty: row.QTY_BUY_TRI1 || 0,
              q2PurchasedQty: row.QTY_BUY_TRI2 || 0,
              q3PurchasedQty: row.QTY_BUY_TRI3 || 0,
              q4PurchasedQty: row.QTY_BUY_TRI4 || 0,
              purchasedQuantity: row.BUY_QTY || 0,
              purchasedValue: row.BUY_VALUE || 0,
              remainingQuantity: row.REMAIN_QTY || 0,
              remainingValue: row.REMAIN_VALUE || 0,
              year1Consumption: row.RATE_1_YEAR,
              year2Consumption: row.RATE_2_YEAR,
              year3Consumption: row.RATE_3_YEAR,
              avgConsumption3Years: row.AVG_3_YEAR,
              minStockLevel: row.MIN_LEVEL,
              currentStock: row.QTY_ON_HAND,
              status: 'PENDING'
            }
          });
          itemsImported++;
        }

        if (itemsImported % 200 === 0 && itemsImported > 0) {
          process.stdout.write(`\\r   Progress: ${itemsImported} items imported`);
        }
      } catch (err: any) {
        itemsSkipped++;
      }
    }

    console.log(`\\r   Progress: ${itemsImported} items imported\\n`);

    // ===========================================
    // Summary
    // ===========================================
    console.log('═══════════════════════════════════════');
    console.log('✅ Phase 14 Migration Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   Departments:        ${deptImported} imported`);
    console.log(`   Budget Plans:       ${plansImported} imported`);
    console.log(`   Plan Items:         ${itemsImported} imported`);
    console.log(`   Items Skipped:      ${itemsSkipped}`);
    console.log('═══════════════════════════════════════');

    // Verify
    const finalCounts = await Promise.all([
      prisma.department.count(),
      prisma.budgetPlan.count(),
      prisma.budgetPlanItem.count()
    ]);

    console.log(`\\n📊 Final counts:`);
    console.log(`   departments: ${finalCounts[0]}`);
    console.log(`   budget_plans: ${finalCounts[1]}`);
    console.log(`   budget_plan_items: ${finalCounts[2]}`);

  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    await mysqlConn.end();
    await prisma.$disconnect();
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
