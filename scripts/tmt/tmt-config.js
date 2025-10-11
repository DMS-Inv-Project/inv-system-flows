/**
 * TMT Configuration File
 * กำหนดค่าต่างๆ สำหรับการ import และ sync ข้อมูล TMT
 */

const path = require('path');

module.exports = {
  // =====================================================
  // PATHS
  // =====================================================
  paths: {
    // ที่อยู่ไฟล์ TMT data จากกระทรวงสาธารณสุข
    tmtDataPath: path.join(__dirname, '../docs/manual-invs/TMTRF20250915'),
    
    // ที่เก็บ backup files
    backupPath: path.join(__dirname, '../backups'),
    
    // ที่เก็บ log files
    logPath: path.join(__dirname, '../logs'),
    
    // ที่เก็บ report files
    reportPath: path.join(__dirname, '../reports')
  },

  // =====================================================
  // TMT FILES MAPPING
  // =====================================================
  files: {
    // ไฟล์หลัก TMT SNAPSHOT
    snapshot: 'TMTRF20250915_SNAPSHOT.xls',
    
    // ไฟล์ relationship
    relationships: {
      vtmToGp: 'VTMtoGP20250915.xls',
      gpToTp: 'GPtoTP20250915.xls',
      gpToGpu: 'GPtoGPU20250915.xls',
      gpuToTpu: 'GPUtoTPU20250915.xls'
    },
    
    // ไฟล์ concept แยกตาม level (optional)
    concepts: {
      vtm: 'VTM20250915.xls',
      gp: 'GP20250915.xls',
      tp: 'TP20250915.xls',
      gpu: 'GPU20250915.xls',
      tpu: 'TPU20250915.xls',
      gpp: 'GPP20250915.xls',
      tpp: 'TPP20250915.xls'
    }
  },

  // =====================================================
  // IMPORT SETTINGS
  // =====================================================
  import: {
    // จำนวน records ที่ process ต่อ batch
    batchSize: 1000,
    
    // จำนวน records สูงสุดสำหรับ testing
    maxRecordsForTest: 100,
    
    // ความเชื่อมั่นในการ mapping อัตโนมัติ
    defaultConfidence: 0.8,
    
    // การ retry เมื่อเกิด error
    retryAttempts: 3,
    retryDelay: 1000, // milliseconds
    
    // การ validate ข้อมูลก่อน import
    validation: {
      enabled: true,
      strictMode: false, // true = หยุดเมื่อเจอ error, false = skip และทำต่อ
      requiredFields: ['TMTID', 'Level', 'FSN']
    }
  },

  // =====================================================
  // SYNC SETTINGS
  // =====================================================
  sync: {
    // การ backup อัตโนมัติก่อน sync
    autoBackup: true,
    
    // จำนวน backup files ที่เก็บไว้
    maxBackupFiles: 5,
    
    // การ validate หลัง sync
    postSyncValidation: true,
    
    // การสร้างรายงานอัตโนมัติ
    autoReport: true,
    
    // การ rollback อัตโนมัติเมื่อเกิด error ร้ายแรง
    autoRollback: false
  },

  // =====================================================
  // LOGGING
  // =====================================================
  logging: {
    // ระดับการ log: debug, info, warn, error
    level: 'info',
    
    // การเก็บ log ในไฟล์
    saveToFile: true,
    
    // การ rotate log files
    maxLogFiles: 10,
    maxLogSize: '10MB',
    
    // รูปแบบการแสดงเวลา
    timeFormat: 'YYYY-MM-DD HH:mm:ss'
  },

  // =====================================================
  // MAPPING RULES
  // =====================================================
  mapping: {
    // กฎการ match drug name กับ TMT FSN
    drugNameMatching: {
      // การ normalize ชื่อยาก่อนการ match
      normalize: {
        removeSpecialChars: true,
        toLowerCase: true,
        removeBrands: ['®', '™', '©'],
        removeCommonWords: ['tablet', 'capsule', 'injection', 'syrup']
      },
      
      // ความเชื่อมั่นตามประเภทการ match
      confidenceScores: {
        exactMatch: 1.0,
        partialMatch: 0.8,
        fuzzyMatch: 0.6,
        genericMatch: 0.4
      },
      
      // การจัดลำดับความสำคัญของ TMT levels
      levelPriority: ['TPU', 'TP', 'GP', 'VTM']
    },
    
    // กฎการ map manufacturer
    manufacturerMapping: {
      enabled: true,
      confidenceThreshold: 0.7,
      
      // การ normalize ชื่อผู้ผลิต
      aliases: {
        'GPO': ['Government Pharmaceutical Organization', 'องค์การเภสัชกรรม'],
        'Pfizer': ['Pfizer Ltd.', 'Pfizer (Thailand) Ltd.'],
        'GSK': ['GlaxoSmithKline', 'Glaxo Wellcome']
      }
    }
  },

  // =====================================================
  // VALIDATION RULES
  // =====================================================
  validation: {
    // กฎการตรวจสอบ TMT ID
    tmtId: {
      required: true,
      type: 'number',
      min: 1,
      max: 999999999
    },
    
    // กฎการตรวจสอบ FSN
    fsn: {
      required: true,
      type: 'string',
      maxLength: 500,
      notEmpty: true
    },
    
    // กฎการตรวจสอบ Level
    level: {
      required: true,
      allowedValues: ['SUBS', 'VTM', 'GP', 'TP', 'GPU', 'TPU', 'GPP', 'TPP', 'GP-F', 'GP-X']
    },
    
    // กฎการตรวจสอบ Concept Code
    conceptCode: {
      pattern: /^[A-Z0-9]+$/,
      maxLength: 20
    },
    
    // การตรวจสอบความสัมพันธ์
    relationships: {
      preventCircular: true,
      allowedTypes: ['IS_A', 'HAS_ACTIVE_INGREDIENT', 'HAS_DOSE_FORM', 'HAS_MANUFACTURER', 'HAS_PACK_SIZE', 'HAS_STRENGTH', 'HAS_UNIT_OF_USE']
    }
  },

  // =====================================================
  // PERFORMANCE SETTINGS
  // =====================================================
  performance: {
    // การใช้ memory
    maxMemoryUsage: '2GB',
    
    // การ process แบบ parallel
    maxConcurrency: 5,
    
    // การใช้ connection pool
    database: {
      maxConnections: 10,
      acquireTimeout: 60000,
      createTimeout: 30000,
      destroyTimeout: 5000,
      idleTimeout: 30000,
      reapInterval: 1000
    },
    
    // การ optimize query
    queryOptimization: {
      useBulkInsert: true,
      bulkInsertSize: 500,
      useIndexHints: true,
      enableQueryCache: true
    }
  },

  // =====================================================
  // ERROR HANDLING
  // =====================================================
  errorHandling: {
    // การจัดการ error ระหว่าง import
    onImportError: 'continue', // stop, continue, retry
    
    // การจัดการ duplicate records
    onDuplicate: 'update', // skip, update, error
    
    // การจัดการ missing references
    onMissingReference: 'warn', // ignore, warn, error
    
    // การจัดการ invalid data
    onInvalidData: 'skip', // skip, fix, error
    
    // การส่ง notification เมื่อเกิด error
    notifications: {
      enabled: false,
      email: 'admin@hospital.go.th',
      webhook: null
    }
  },

  // =====================================================
  // ENVIRONMENT SPECIFIC
  // =====================================================
  environments: {
    development: {
      import: {
        batchSize: 100,
        maxRecordsForTest: 50
      },
      logging: {
        level: 'debug'
      }
    },
    
    production: {
      import: {
        batchSize: 2000,
        maxRecordsForTest: null
      },
      logging: {
        level: 'info'
      },
      sync: {
        autoBackup: true,
        autoRollback: true
      }
    },
    
    testing: {
      import: {
        batchSize: 10,
        maxRecordsForTest: 20
      },
      logging: {
        level: 'debug',
        saveToFile: false
      }
    }
  }
};

// Helper function to get environment-specific config
module.exports.getConfig = function(env = 'development') {
  const baseConfig = module.exports;
  const envConfig = baseConfig.environments[env] || {};
  
  // Deep merge environment config with base config
  return mergeDeep(baseConfig, envConfig);
};

// Deep merge utility function
function mergeDeep(target, source) {
  const output = Object.assign({}, target);
  if (isObject(target) && isObject(source)) {
    Object.keys(source).forEach(key => {
      if (isObject(source[key])) {
        if (!(key in target))
          Object.assign(output, { [key]: source[key] });
        else
          output[key] = mergeDeep(target[key], source[key]);
      } else {
        Object.assign(output, { [key]: source[key] });
      }
    });
  }
  return output;
}

function isObject(item) {
  return (item && typeof item === "object" && !Array.isArray(item));
}