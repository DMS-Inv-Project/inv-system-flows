/**
 * Phase 7: Import TMT (Thai Medical Terminology) Concepts
 *
 * Import TMT hierarchy from MySQL:
 * - VTM (Virtual Therapeutic Moiety) - สารออกฤทธิ์
 * - GP (Generic Product) - ยาสามัญ + รูปแบบ
 * - GPU (Generic Product + Unit) - ยาสามัญ + หน่วย
 * - TP (Trade Product) - ยาการค้า
 * - TPU (Trade Product + Unit) - ยาการค้า + หน่วย
 *
 * Total: ~102,449 concepts
 *
 * Run: npx tsx scripts/migrate-phase7-tmt-concepts.ts
 */

import { PrismaClient } from '@prisma/client';
import mysql from 'mysql2/promise';

const prisma = new PrismaClient();

// MySQL connection config
const mysqlConfig = {
  host: 'localhost',
  port: 3307,
  user: 'invs_user',
  password: 'invs123',
  database: 'invs_banpong',
  charset: 'utf8mb4'
};

// Helper: Parse date string "yyyyMMdd" → Date | null
function parseThaiDate(dateStr: string | null): Date | null {
  if (!dateStr || dateStr.length !== 8) return null;
  try {
    const year = parseInt(dateStr.substring(0, 4));
    const month = parseInt(dateStr.substring(4, 6)) - 1; // 0-indexed
    const day = parseInt(dateStr.substring(6, 8));
    const date = new Date(year, month, day);
    return isNaN(date.getTime()) ? null : date;
  } catch {
    return null;
  }
}

async function main() {
  console.log('🚀 Phase 7: Importing TMT Concepts...\n');
  console.log('📦 Estimated: 102,449 concepts (VTM + GP + GPU + TP + TPU)\n');

  const mysqlConn = await mysql.createConnection(mysqlConfig);

  try {
    let totalImported = 0;

    // ===========================================
    // 1. Import VTM (Virtual Therapeutic Moiety)
    // ===========================================
    console.log('📋 1/5: Importing VTM (สารออกฤทธิ์)...');
    const [vtmData] = await mysqlConn.query<any[]>(`
      SELECT
        vtmid,
        fsn,
        invalid,
        effect_date,
        issue_date
      FROM vtm
      WHERE invalid = 0 OR invalid IS NULL
      ORDER BY vtmid
    `);

    console.log(`   Found ${vtmData.length} VTM records`);
    let vtmCount = 0;
    const batchSize = 500;

    for (let i = 0; i < vtmData.length; i += batchSize) {
      const batch = vtmData.slice(i, i + batchSize);

      await prisma.$transaction(
        batch.map(vtm =>
          prisma.tmtConcept.upsert({
            where: { tmtId: BigInt(vtm.vtmid) },
            create: {
              tmtId: BigInt(vtm.vtmid),
              level: 'VTM',
              fsn: (vtm.fsn || `VTM-${vtm.vtmid}`).substring(0, 2000),
              preferredTerm: vtm.fsn ? vtm.fsn.substring(0, 300) : null,
              isActive: (vtm.invalid === 0 || vtm.invalid === null),
              effectiveDate: parseThaiDate(vtm.effect_date),
              releaseDate: vtm.issue_date ? vtm.issue_date.substring(0, 20) : null
            },
            update: {
              fsn: (vtm.fsn || `VTM-${vtm.vtmid}`).substring(0, 2000),
              preferredTerm: vtm.fsn ? vtm.fsn.substring(0, 300) : null,
              isActive: (vtm.invalid === 0 || vtm.invalid === null)
            }
          })
        )
      );

      vtmCount += batch.length;
      process.stdout.write(`\r   Progress: ${vtmCount}/${vtmData.length} VTM imported`);
    }
    console.log(`\n   ✅ Imported ${vtmCount} VTM concepts\n`);
    totalImported += vtmCount;

    // ===========================================
    // 2. Import GP (Generic Product)
    // ===========================================
    console.log('📋 2/5: Importing GP (ยาสามัญ + รูปแบบ)...');
    const [gpData] = await mysqlConn.query<any[]>(`
      SELECT
        gpid,
        fsn,
        vtmid,
        dformid,
        invalid,
        effect_date,
        issue_date
      FROM gp
      WHERE invalid = 0 OR invalid IS NULL
      ORDER BY gpid
    `);

    console.log(`   Found ${gpData.length} GP records`);
    let gpCount = 0;

    for (let i = 0; i < gpData.length; i += batchSize) {
      const batch = gpData.slice(i, i + batchSize);

      await prisma.$transaction(
        batch.map(gp =>
          prisma.tmtConcept.upsert({
            where: { tmtId: BigInt(gp.gpid) },
            create: {
              tmtId: BigInt(gp.gpid),
              level: 'GP',
              fsn: (gp.fsn || `GP-${gp.gpid}`).substring(0, 2000),
              preferredTerm: gp.fsn ? gp.fsn.substring(0, 300) : null,
              isActive: (gp.invalid === 0 || gp.invalid === null),
              effectiveDate: parseThaiDate(gp.effect_date),
              releaseDate: gp.issue_date ? gp.issue_date.substring(0, 20) : null
            },
            update: {
              fsn: (gp.fsn || `GP-${gp.gpid}`).substring(0, 2000),
              preferredTerm: gp.fsn ? gp.fsn.substring(0, 300) : null,
              isActive: (gp.invalid === 0 || gp.invalid === null)
            }
          })
        )
      );

      gpCount += batch.length;
      process.stdout.write(`\r   Progress: ${gpCount}/${gpData.length} GP imported`);
    }
    console.log(`\n   ✅ Imported ${gpCount} GP concepts\n`);
    totalImported += gpCount;

    // ===========================================
    // 3. Import GPU (Generic Product + Unit)
    // ===========================================
    console.log('📋 3/5: Importing GPU (ยาสามัญ + หน่วย)...');
    const [gpuData] = await mysqlConn.query<any[]>(`
      SELECT
        gpuid,
        gpid,
        contunitid,
        fsn,
        invalid
      FROM gpu
      WHERE invalid = 0 OR invalid IS NULL
      ORDER BY gpuid
    `);

    console.log(`   Found ${gpuData.length} GPU records`);
    let gpuCount = 0;

    for (let i = 0; i < gpuData.length; i += batchSize) {
      const batch = gpuData.slice(i, i + batchSize);

      await prisma.$transaction(
        batch.map(gpu =>
          prisma.tmtConcept.upsert({
            where: { tmtId: BigInt(gpu.gpuid) },
            create: {
              tmtId: BigInt(gpu.gpuid),
              level: 'GPU',
              fsn: (gpu.fsn || `GPU-${gpu.gpuid}`).substring(0, 2000),
              preferredTerm: gpu.fsn ? gpu.fsn.substring(0, 300) : null,
              isActive: (gpu.invalid === 0 || gpu.invalid === null)
            },
            update: {
              fsn: (gpu.fsn || `GPU-${gpu.gpuid}`).substring(0, 2000),
              preferredTerm: gpu.fsn ? gpu.fsn.substring(0, 300) : null,
              isActive: (gpu.invalid === 0 || gpu.invalid === null)
            }
          })
        )
      );

      gpuCount += batch.length;
      if (gpuCount % 1000 === 0) {
        process.stdout.write(`\r   Progress: ${gpuCount}/${gpuData.length} GPU imported`);
      }
    }
    console.log(`\r   Progress: ${gpuCount}/${gpuData.length} GPU imported`);
    console.log(`   ✅ Imported ${gpuCount} GPU concepts\n`);
    totalImported += gpuCount;

    // ===========================================
    // 4. Import TP (Trade Product)
    // ===========================================
    console.log('📋 4/5: Importing TP (ยาการค้า)...');
    const [tpData] = await mysqlConn.query<any[]>(`
      SELECT
        tpid,
        tradename,
        fsn,
        gpid,
        mftid,
        invalid,
        label_str,
        label_str_unit
      FROM tp
      WHERE invalid = 0 OR invalid IS NULL
      ORDER BY tpid
    `);

    console.log(`   Found ${tpData.length} TP records`);
    let tpCount = 0;

    for (let i = 0; i < tpData.length; i += batchSize) {
      const batch = tpData.slice(i, i + batchSize);

      await prisma.$transaction(
        batch.map(tp =>
          prisma.tmtConcept.upsert({
            where: { tmtId: BigInt(tp.tpid) },
            create: {
              tmtId: BigInt(tp.tpid),
              level: 'TP',
              fsn: (tp.fsn || tp.tradename || `TP-${tp.tpid}`).substring(0, 2000),
              preferredTerm: tp.tradename ? tp.tradename.substring(0, 300) : null,
              strength: tp.label_str ? String(tp.label_str).substring(0, 100) : null,
              isActive: (tp.invalid === 0 || tp.invalid === null)
            },
            update: {
              fsn: (tp.fsn || tp.tradename || `TP-${tp.tpid}`).substring(0, 2000),
              preferredTerm: tp.tradename ? tp.tradename.substring(0, 300) : null,
              strength: tp.label_str ? String(tp.label_str).substring(0, 100) : null,
              isActive: (tp.invalid === 0 || tp.invalid === null)
            }
          })
        )
      );

      tpCount += batch.length;
      if (tpCount % 1000 === 0) {
        process.stdout.write(`\r   Progress: ${tpCount}/${tpData.length} TP imported`);
      }
    }
    console.log(`\r   Progress: ${tpCount}/${tpData.length} TP imported`);
    console.log(`   ✅ Imported ${tpCount} TP concepts\n`);
    totalImported += tpCount;

    // ===========================================
    // 5. Import TPU (Trade Product + Unit)
    // ===========================================
    console.log('📋 5/5: Importing TPU (ยาการค้า + หน่วย)...');
    const [tpuData] = await mysqlConn.query<any[]>(`
      SELECT
        tpuid,
        tpid,
        gpuid,
        fsn,
        invalid
      FROM tpu
      WHERE invalid = 0 OR invalid IS NULL
      ORDER BY tpuid
    `);

    console.log(`   Found ${tpuData.length} TPU records`);
    let tpuCount = 0;

    for (let i = 0; i < tpuData.length; i += batchSize) {
      const batch = tpuData.slice(i, i + batchSize);

      await prisma.$transaction(
        batch.map(tpu =>
          prisma.tmtConcept.upsert({
            where: { tmtId: BigInt(tpu.tpuid) },
            create: {
              tmtId: BigInt(tpu.tpuid),
              level: 'TPU',
              fsn: (tpu.fsn || `TPU-${tpu.tpuid}`).substring(0, 2000),
              preferredTerm: tpu.fsn ? tpu.fsn.substring(0, 300) : null,
              isActive: (tpu.invalid === 0 || tpu.invalid === null)
            },
            update: {
              fsn: (tpu.fsn || `TPU-${tpu.tpuid}`).substring(0, 2000),
              preferredTerm: tpu.fsn ? tpu.fsn.substring(0, 300) : null,
              isActive: (tpu.invalid === 0 || tpu.invalid === null)
            }
          })
        )
      );

      tpuCount += batch.length;
      if (tpuCount % 1000 === 0) {
        process.stdout.write(`\r   Progress: ${tpuCount}/${tpuData.length} TPU imported`);
      }
    }
    console.log(`\r   Progress: ${tpuCount}/${tpuData.length} TPU imported`);
    console.log(`   ✅ Imported ${tpuCount} TPU concepts\n`);
    totalImported += tpuCount;

    // ===========================================
    // Summary
    // ===========================================
    console.log('═══════════════════════════════════════');
    console.log('✅ Phase 7 TMT Migration Summary:');
    console.log('═══════════════════════════════════════');
    console.log(`   VTM (สารออกฤทธิ์):      ${vtmCount.toLocaleString()} records`);
    console.log(`   GP (ยาสามัญ):          ${gpCount.toLocaleString()} records`);
    console.log(`   GPU (ยาสามัญ+หน่วย):    ${gpuCount.toLocaleString()} records`);
    console.log(`   TP (ยาการค้า):         ${tpCount.toLocaleString()} records`);
    console.log(`   TPU (ยาการค้า+หน่วย):   ${tpuCount.toLocaleString()} records`);
    console.log('═══════════════════════════════════════');
    console.log(`   Total:                  ${totalImported.toLocaleString()} concepts`);
    console.log('═══════════════════════════════════════\n');

    // Verification
    console.log('🔍 Verification:');
    const vtmInDb = await prisma.tmtConcept.count({ where: { level: 'VTM' } });
    const gpInDb = await prisma.tmtConcept.count({ where: { level: 'GP' } });
    const gpuInDb = await prisma.tmtConcept.count({ where: { level: 'GPU' } });
    const tpInDb = await prisma.tmtConcept.count({ where: { level: 'TP' } });
    const tpuInDb = await prisma.tmtConcept.count({ where: { level: 'TPU' } });
    const totalInDb = await prisma.tmtConcept.count();

    console.log(`   VTM in DB:  ${vtmInDb.toLocaleString()}`);
    console.log(`   GP in DB:   ${gpInDb.toLocaleString()}`);
    console.log(`   GPU in DB:  ${gpuInDb.toLocaleString()}`);
    console.log(`   TP in DB:   ${tpInDb.toLocaleString()}`);
    console.log(`   TPU in DB:  ${tpuInDb.toLocaleString()}`);
    console.log(`   Total:      ${totalInDb.toLocaleString()}\n`);

  } catch (error) {
    console.error('❌ Migration failed:', error);
    throw error;
  } finally {
    await mysqlConn.end();
    await prisma.$disconnect();
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
