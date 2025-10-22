# Bulk Import API Specification

**Module**: Master Data Management
**Feature**: Bulk Import/Export
**Version**: 1.0.0
**Status**: Draft for Implementation

---

## 📋 Overview

Bulk Import API ช่วยให้ผู้ใช้สามารถ import ข้อมูล Master Data จำนวนมากผ่าน CSV/Excel files โดยมี validation และ error handling ที่ครบถ้วน

**Supported Entities:**
- `drugs` - Trade name drugs
- `drug-generics` - Generic drugs
- `companies` - Vendors/Manufacturers
- `locations` - Storage locations
- `departments` - Hospital departments
- `budget-types` - Budget type groups
- `contracts` - Contracts
- `contract-items` - Contract items

---

## 🔄 Import Flow

```
1. Download Template
   ↓
2. Fill Data in Excel/CSV
   ↓
3. Upload & Validate File
   ↓
4. Preview Results (with errors highlighted)
   ↓
5. Confirm Import (or fix & re-upload)
   ↓
6. Execute Import (with progress tracking)
   ↓
7. View Summary & Download Error Report
```

---

## 📡 API Endpoints

### 1. Download Import Template

**Purpose**: ดาวน์โหลด template file สำหรับ import

```http
GET /api/master-data/{entity}/import/template
```

**Path Parameters:**
- `entity` (string, required): Entity type
  - `drugs` | `drug-generics` | `companies` | `locations` | `departments` | `budget-types` | `contracts` | `contract-items`

**Query Parameters:**
- `format` (string, optional): File format
  - `csv` (default)
  - `excel` (.xlsx)
- `includeExample` (boolean, optional): Include sample data rows (default: true)
- `includeInstructions` (boolean, optional): Include instruction sheet (Excel only, default: true)

**Request Example:**

```bash
GET /api/master-data/drugs/import/template?format=excel&includeExample=true
```

**Response (200 OK):**

```
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
Content-Disposition: attachment; filename="drugs-import-template.xlsx"

[Binary Excel file]
```

**Excel Template Structure:**

Sheet 1: Instructions
```
# Drug Import Template
## Required Fields:
- drug_code (string, 7-24 chars, unique)
- trade_name (string, required)
- generic_id (number, FK to drug_generics)
- manufacturer_id (number, FK to companies)

## Optional Fields:
- strength (string)
- dosage_form (string)
- pack_size (number)
- unit_price (decimal)
...

## Notes:
- Maximum 1000 rows per import
- File size limit: 10MB
- Duplicate drug_code will be skipped
```

Sheet 2: Data
```
drug_code | trade_name | generic_id | manufacturer_id | strength | dosage_form | pack_size | unit_price | ...
---------|-----------|-----------|----------------|---------|------------|----------|-----------|----
(empty rows for user input)
```

Sheet 3: Example Data
```
drug_code | trade_name | generic_id | manufacturer_id | strength | dosage_form | pack_size | unit_price
PARA500  | Paracetamol 500mg | 1 | 1 | 500mg | TAB | 1000 | 2.50
IBU200   | Ibuprofen 200mg | 2 | 1 | 200mg | TAB | 500 | 3.00
```

---

### 2. Validate Import File

**Purpose**: อัปโหลดไฟล์เพื่อ validate ก่อน import จริง (ไม่บันทึกลง database)

```http
POST /api/master-data/{entity}/import/validate
```

**Path Parameters:**
- `entity` (string, required): Entity type

**Request Body (multipart/form-data):**

```
Content-Type: multipart/form-data

--boundary
Content-Disposition: form-data; name="file"; filename="drugs.xlsx"
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet

[Binary file data]
--boundary
Content-Disposition: form-data; name="options"
Content-Type: application/json

{
  "skipDuplicates": true,
  "continueOnError": true,
  "updateExisting": false,
  "dryRun": true
}
--boundary--
```

**Options:**
```typescript
interface ImportOptions {
  skipDuplicates?: boolean      // Skip duplicate records (default: true)
  continueOnError?: boolean     // Continue if some rows have errors (default: true)
  updateExisting?: boolean      // Update existing records if duplicate found (default: false)
  dryRun?: boolean             // Validate only, don't import (default: true)
}
```

**Request Example (JavaScript):**

```javascript
const validateImport = async (file) => {
  const formData = new FormData()
  formData.append('file', file)
  formData.append('options', JSON.stringify({
    skipDuplicates: true,
    continueOnError: true,
    updateExisting: false,
    dryRun: true
  }))

  const response = await fetch('/api/master-data/drugs/import/validate', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`
    },
    body: formData
  })

  return response.json()
}
```

**Response (200 OK):**

```json
{
  "success": true,
  "data": {
    "sessionId": "import_session_abc123xyz",
    "filename": "drugs.xlsx",
    "totalRows": 50,
    "validRows": 45,
    "invalidRows": 5,
    "summary": {
      "toCreate": 40,
      "toUpdate": 5,
      "toSkip": 5,
      "errors": 3,
      "warnings": 7
    },
    "preview": [
      {
        "rowNumber": 1,
        "status": "valid",
        "action": "create",
        "data": {
          "drug_code": "PARA500",
          "trade_name": "Paracetamol 500mg",
          "generic_id": 1,
          "manufacturer_id": 1,
          "unit_price": 2.50
        },
        "errors": [],
        "warnings": []
      },
      {
        "rowNumber": 2,
        "status": "warning",
        "action": "create",
        "data": {
          "drug_code": "IBU200",
          "trade_name": "Ibuprofen 200mg",
          "generic_id": 2,
          "manufacturer_id": 1
        },
        "errors": [],
        "warnings": [
          {
            "field": "unit_price",
            "message": "Unit price not provided, will use default value 0",
            "code": "MISSING_OPTIONAL_FIELD"
          }
        ]
      },
      {
        "rowNumber": 5,
        "status": "error",
        "action": "skip",
        "data": {
          "drug_code": "INVALID",
          "trade_name": "",
          "generic_id": 999,
          "manufacturer_id": null
        },
        "errors": [
          {
            "field": "trade_name",
            "message": "Trade name is required",
            "code": "REQUIRED_FIELD_MISSING",
            "severity": "error"
          },
          {
            "field": "generic_id",
            "message": "Generic drug with ID 999 not found",
            "code": "FOREIGN_KEY_NOT_FOUND",
            "severity": "error"
          },
          {
            "field": "manufacturer_id",
            "message": "Manufacturer ID is required",
            "code": "REQUIRED_FIELD_MISSING",
            "severity": "error"
          }
        ],
        "warnings": []
      },
      {
        "rowNumber": 10,
        "status": "duplicate",
        "action": "skip",
        "data": {
          "drug_code": "PARA500",
          "trade_name": "Paracetamol 500mg (Duplicate)"
        },
        "errors": [
          {
            "field": "drug_code",
            "message": "Drug code 'PARA500' already exists (Row 1)",
            "code": "DUPLICATE_IN_FILE",
            "severity": "error"
          }
        ],
        "warnings": []
      }
    ],
    "expiresAt": "2025-01-22T12:00:00Z"
  },
  "meta": {
    "timestamp": "2025-01-22T10:00:00Z",
    "version": "1.0.0",
    "requestId": "req_validate_123"
  }
}
```

**Response (400 Bad Request) - Invalid File:**

```json
{
  "success": false,
  "error": {
    "code": "INVALID_FILE",
    "message": "File validation failed",
    "details": [
      {
        "field": "file",
        "message": "File format not supported. Please use .csv or .xlsx",
        "code": "INVALID_FILE_FORMAT"
      }
    ]
  }
}
```

**Response (413 Payload Too Large):**

```json
{
  "success": false,
  "error": {
    "code": "FILE_TOO_LARGE",
    "message": "File size exceeds 10MB limit",
    "details": {
      "maxSize": 10485760,
      "actualSize": 15728640
    }
  }
}
```

**Row Status Types:**
- `valid` - ข้อมูลถูกต้อง พร้อม import
- `warning` - มี warning แต่ import ได้
- `error` - มี error ไม่สามารถ import ได้
- `duplicate` - ซ้ำกับข้อมูลที่มีอยู่แล้ว
- `duplicate_in_file` - ซ้ำกันภายในไฟล์เดียวกัน

**Action Types:**
- `create` - สร้างใหม่
- `update` - อัปเดตข้อมูลเดิม (if updateExisting = true)
- `skip` - ข้าม (duplicate หรือ error)

---

### 3. Execute Import

**Purpose**: ดำเนินการ import จริงหลังจาก validate แล้ว

```http
POST /api/master-data/{entity}/import/execute
```

**Path Parameters:**
- `entity` (string, required): Entity type

**Request Body (application/json):**

```json
{
  "sessionId": "import_session_abc123xyz",
  "options": {
    "skipDuplicates": true,
    "continueOnError": true,
    "updateExisting": false
  }
}
```

**Request Example:**

```typescript
const executeImport = async (sessionId: string) => {
  const response = await fetch('/api/master-data/drugs/import/execute', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({
      sessionId,
      options: {
        skipDuplicates: true,
        continueOnError: true
      }
    })
  })

  return response.json()
}
```

**Response (202 Accepted) - Import Started:**

```json
{
  "success": true,
  "data": {
    "jobId": "import_job_xyz789",
    "status": "processing",
    "message": "Import started. Use jobId to track progress.",
    "estimatedTime": 30,
    "trackingUrl": "/api/master-data/drugs/import/status/import_job_xyz789"
  },
  "meta": {
    "timestamp": "2025-01-22T10:05:00Z",
    "version": "1.0.0",
    "requestId": "req_execute_456"
  }
}
```

**Response (400 Bad Request) - Session Expired:**

```json
{
  "success": false,
  "error": {
    "code": "SESSION_EXPIRED",
    "message": "Import session expired or not found. Please validate the file again.",
    "details": {
      "sessionId": "import_session_abc123xyz",
      "expiresAt": "2025-01-22T12:00:00Z"
    }
  }
}
```

---

### 4. Track Import Progress

**Purpose**: ติดตามความคืบหน้าของการ import

```http
GET /api/master-data/{entity}/import/status/{jobId}
```

**Path Parameters:**
- `entity` (string, required): Entity type
- `jobId` (string, required): Job ID from execute response

**Request Example:**

```bash
GET /api/master-data/drugs/import/status/import_job_xyz789
```

**Response (200 OK) - In Progress:**

```json
{
  "success": true,
  "data": {
    "jobId": "import_job_xyz789",
    "status": "processing",
    "progress": {
      "current": 25,
      "total": 50,
      "percentage": 50
    },
    "summary": {
      "processed": 25,
      "successful": 22,
      "failed": 3,
      "skipped": 0
    },
    "currentRow": {
      "rowNumber": 26,
      "data": {
        "drug_code": "AMOX500",
        "trade_name": "Amoxicillin 500mg"
      }
    },
    "startedAt": "2025-01-22T10:05:00Z",
    "estimatedCompletion": "2025-01-22T10:06:00Z"
  },
  "meta": {
    "timestamp": "2025-01-22T10:05:30Z",
    "version": "1.0.0",
    "requestId": "req_status_789"
  }
}
```

**Response (200 OK) - Completed:**

```json
{
  "success": true,
  "data": {
    "jobId": "import_job_xyz789",
    "status": "completed",
    "progress": {
      "current": 50,
      "total": 50,
      "percentage": 100
    },
    "summary": {
      "processed": 50,
      "successful": 45,
      "failed": 5,
      "skipped": 0,
      "created": 40,
      "updated": 5
    },
    "errors": [
      {
        "rowNumber": 5,
        "data": {
          "drug_code": "INVALID",
          "trade_name": ""
        },
        "error": "Trade name is required"
      },
      {
        "rowNumber": 12,
        "data": {
          "drug_code": "TEST123",
          "generic_id": 999
        },
        "error": "Generic drug with ID 999 not found"
      }
    ],
    "startedAt": "2025-01-22T10:05:00Z",
    "completedAt": "2025-01-22T10:06:15Z",
    "duration": 75,
    "errorReportUrl": "/api/master-data/drugs/import/error-report/import_job_xyz789"
  },
  "meta": {
    "timestamp": "2025-01-22T10:06:15Z",
    "version": "1.0.0",
    "requestId": "req_status_completed"
  }
}
```

**Status Types:**
- `pending` - รอดำเนินการ
- `processing` - กำลัง import
- `completed` - เสร็จสิ้น
- `failed` - ล้มเหลว (error ทั้งหมด)
- `partial` - เสร็จสิ้นบางส่วน (บาง row สำเร็จ บาง row ล้มเหลว)
- `cancelled` - ยกเลิก

---

### 5. Download Error Report

**Purpose**: ดาวน์โหลดรายงาน errors จากการ import

```http
GET /api/master-data/{entity}/import/error-report/{jobId}
```

**Path Parameters:**
- `entity` (string, required): Entity type
- `jobId` (string, required): Job ID

**Query Parameters:**
- `format` (string, optional): Report format
  - `csv` (default)
  - `excel`
  - `json`

**Request Example:**

```bash
GET /api/master-data/drugs/import/error-report/import_job_xyz789?format=excel
```

**Response (200 OK):**

```
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
Content-Disposition: attachment; filename="drugs-import-errors-2025-01-22.xlsx"

[Binary Excel file]
```

**Excel Error Report Structure:**

```
Row # | Status | Drug Code | Trade Name | Generic ID | ... | Error Message | Error Code
------|--------|-----------|-----------|-----------|-----|---------------|------------
5     | ERROR  | INVALID   |           | 999       | ... | Trade name is required; Generic drug with ID 999 not found | REQUIRED_FIELD_MISSING, FOREIGN_KEY_NOT_FOUND
12    | ERROR  | TEST123   | Test Drug | 999       | ... | Generic drug with ID 999 not found | FOREIGN_KEY_NOT_FOUND
15    | SKIP   | PARA500   | Duplicate | 1         | ... | Drug code already exists | DUPLICATE_DRUG_CODE
```

---

### 6. Cancel Import Job

**Purpose**: ยกเลิกการ import ที่กำลังดำเนินการอยู่

```http
DELETE /api/master-data/{entity}/import/cancel/{jobId}
```

**Path Parameters:**
- `entity` (string, required): Entity type
- `jobId` (string, required): Job ID to cancel

**Request Example:**

```typescript
const cancelImport = async (jobId: string) => {
  const response = await fetch(`/api/master-data/drugs/import/cancel/${jobId}`, {
    method: 'DELETE',
    headers: {
      'Authorization': `Bearer ${token}`
    }
  })

  return response.json()
}
```

**Response (200 OK):**

```json
{
  "success": true,
  "data": {
    "jobId": "import_job_xyz789",
    "status": "cancelled",
    "message": "Import cancelled successfully",
    "summary": {
      "processed": 20,
      "successful": 18,
      "failed": 2,
      "cancelled": 30
    }
  },
  "meta": {
    "timestamp": "2025-01-22T10:05:45Z",
    "version": "1.0.0",
    "requestId": "req_cancel_999"
  }
}
```

**Response (400 Bad Request) - Cannot Cancel:**

```json
{
  "success": false,
  "error": {
    "code": "CANNOT_CANCEL",
    "message": "Import already completed and cannot be cancelled",
    "details": {
      "jobId": "import_job_xyz789",
      "status": "completed"
    }
  }
}
```

---

## 📊 Data Validation Rules

### Common Validations (All Entities)

```typescript
interface ValidationRule {
  field: string
  required: boolean
  type: 'string' | 'number' | 'boolean' | 'date' | 'enum'
  minLength?: number
  maxLength?: number
  min?: number
  max?: number
  pattern?: RegExp
  enum?: string[]
  foreignKey?: {
    table: string
    field: string
  }
  unique?: boolean
  customValidator?: (value: any, row: any) => ValidationError[]
}
```

### Drugs Import Validation

```typescript
const drugsValidation: ValidationRule[] = [
  {
    field: 'drug_code',
    required: true,
    type: 'string',
    minLength: 7,
    maxLength: 24,
    unique: true,
    pattern: /^[A-Z0-9-]+$/
  },
  {
    field: 'trade_name',
    required: true,
    type: 'string',
    minLength: 3,
    maxLength: 255
  },
  {
    field: 'generic_id',
    required: true,
    type: 'number',
    foreignKey: {
      table: 'drug_generics',
      field: 'id'
    }
  },
  {
    field: 'manufacturer_id',
    required: true,
    type: 'number',
    foreignKey: {
      table: 'companies',
      field: 'id'
    }
  },
  {
    field: 'unit_price',
    required: false,
    type: 'number',
    min: 0,
    max: 999999.99
  },
  {
    field: 'nlem_status',
    required: false,
    type: 'enum',
    enum: ['E', 'N']
  },
  {
    field: 'drug_status',
    required: false,
    type: 'enum',
    enum: ['ACTIVE', 'DISCONTINUED', 'SPECIAL_CASE', 'REMOVED']
  }
]
```

---

## 🚨 Error Codes

| Error Code | HTTP Status | Description | User Action |
|------------|-------------|-------------|-------------|
| `INVALID_FILE_FORMAT` | 400 | File format not supported | Upload .csv or .xlsx file |
| `FILE_TOO_LARGE` | 413 | File exceeds 10MB | Split file or reduce size |
| `FILE_EMPTY` | 400 | No data rows found | Add data to file |
| `TOO_MANY_ROWS` | 400 | Exceeds 1000 rows limit | Split into multiple files |
| `SESSION_EXPIRED` | 400 | Validation session expired (30 min) | Re-validate file |
| `REQUIRED_FIELD_MISSING` | 422 | Required field is empty | Fill required field |
| `INVALID_FIELD_TYPE` | 422 | Field type mismatch | Check data type |
| `FOREIGN_KEY_NOT_FOUND` | 422 | Referenced record not found | Create referenced record first |
| `DUPLICATE_IN_FILE` | 422 | Duplicate within same file | Remove duplicate rows |
| `DUPLICATE_IN_DATABASE` | 409 | Record already exists | Skip or enable updateExisting |
| `INVALID_ENUM_VALUE` | 422 | Invalid enum value | Use valid enum value |
| `FIELD_TOO_LONG` | 422 | Field exceeds max length | Reduce field length |
| `INVALID_FORMAT` | 422 | Field format invalid | Fix format (e.g., email, date) |
| `BUSINESS_RULE_VIOLATION` | 422 | Violates business rule | Check business rules |

---

## 💡 Implementation Notes

### 1. Session Management

```typescript
// Validate response มี sessionId และ expiresAt
// Backend ต้อง cache validated data ไว้ 30 นาที
// เพื่อให้ execute ได้โดยไม่ต้อง validate ซ้ำ

interface ImportSession {
  sessionId: string
  userId: string
  entity: string
  filename: string
  validatedData: any[]
  summary: ImportSummary
  createdAt: Date
  expiresAt: Date // createdAt + 30 minutes
}

// Store in Redis
await redis.setex(
  `import:session:${sessionId}`,
  1800, // 30 minutes
  JSON.stringify(session)
)
```

### 2. Progress Tracking

```typescript
// ใช้ WebSocket หรือ Server-Sent Events สำหรับ real-time progress
// หรือ polling ทุก 1-2 วินาที

// WebSocket Example
const ws = new WebSocket('ws://localhost:3383/api/master-data/drugs/import/stream')

ws.onmessage = (event) => {
  const progress = JSON.parse(event.data)
  console.log(`Progress: ${progress.percentage}%`)
}

// Polling Example
const pollProgress = async (jobId: string) => {
  const interval = setInterval(async () => {
    const response = await fetch(`/api/master-data/drugs/import/status/${jobId}`)
    const { data } = await response.json()

    if (data.status === 'completed' || data.status === 'failed') {
      clearInterval(interval)
    }

    updateUI(data)
  }, 1000)
}
```

### 3. File Processing

```typescript
// Backend ควรใช้ streaming สำหรับไฟล์ใหญ่
// ไม่โหลดทั้งไฟล์เข้า memory

import { Readable } from 'stream'
import XLSX from 'xlsx'
import csv from 'csv-parser'

async function* processExcelStream(fileBuffer: Buffer) {
  const workbook = XLSX.read(fileBuffer)
  const sheetName = workbook.SheetNames[0]
  const sheet = workbook.Sheets[sheetName]
  const rows = XLSX.utils.sheet_to_json(sheet)

  for (const row of rows) {
    yield row
  }
}

// Process row by row
for await (const row of processExcelStream(fileBuffer)) {
  const validationResult = await validateRow(row)
  // Store validation result
}
```

### 4. Transaction Handling

```typescript
// Import ควรใช้ transaction และ savepoints
// เพื่อ rollback ได้ถ้า error

import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

async function executeImport(sessionId: string) {
  const session = await getSession(sessionId)
  const results = []

  for (const row of session.validatedData) {
    try {
      const result = await prisma.$transaction(async (tx) => {
        if (row.action === 'create') {
          return await tx.drug.create({ data: row.data })
        } else if (row.action === 'update') {
          return await tx.drug.update({
            where: { id: row.data.id },
            data: row.data
          })
        }
      })

      results.push({ success: true, data: result })
    } catch (error) {
      results.push({ success: false, error: error.message })

      if (!options.continueOnError) {
        throw error // Rollback all
      }
    }
  }

  return results
}
```

### 5. Performance Optimization

```typescript
// Bulk insert สำหรับ performance
// แทนที่จะ insert ทีละ row

// Bad (Slow)
for (const row of validData) {
  await prisma.drug.create({ data: row })
}

// Good (Fast) - Batch insert
const BATCH_SIZE = 100
for (let i = 0; i < validData.length; i += BATCH_SIZE) {
  const batch = validData.slice(i, i + BATCH_SIZE)
  await prisma.drug.createMany({
    data: batch,
    skipDuplicates: true
  })
}
```

---

## 📝 TypeScript Types

```typescript
// Request Types
export interface ImportOptions {
  skipDuplicates?: boolean
  continueOnError?: boolean
  updateExisting?: boolean
  dryRun?: boolean
}

export interface ValidateImportRequest {
  file: File
  options?: ImportOptions
}

export interface ExecuteImportRequest {
  sessionId: string
  options?: Omit<ImportOptions, 'dryRun'>
}

// Response Types
export interface ImportSession {
  sessionId: string
  filename: string
  totalRows: number
  validRows: number
  invalidRows: number
  summary: ImportSummary
  preview: ImportRowPreview[]
  expiresAt: string
}

export interface ImportSummary {
  toCreate: number
  toUpdate: number
  toSkip: number
  errors: number
  warnings: number
}

export interface ImportRowPreview {
  rowNumber: number
  status: 'valid' | 'warning' | 'error' | 'duplicate'
  action: 'create' | 'update' | 'skip'
  data: Record<string, any>
  errors: ValidationError[]
  warnings: ValidationWarning[]
}

export interface ValidationError {
  field: string
  message: string
  code: string
  severity: 'error' | 'warning' | 'info'
}

export interface ValidationWarning {
  field: string
  message: string
  code?: string
}

export interface ImportJob {
  jobId: string
  status: 'pending' | 'processing' | 'completed' | 'failed' | 'partial' | 'cancelled'
  progress: ImportProgress
  summary: ImportJobSummary
  errors?: ImportError[]
  startedAt: string
  completedAt?: string
  estimatedCompletion?: string
  duration?: number
  errorReportUrl?: string
}

export interface ImportProgress {
  current: number
  total: number
  percentage: number
}

export interface ImportJobSummary {
  processed: number
  successful: number
  failed: number
  skipped: number
  created?: number
  updated?: number
}

export interface ImportError {
  rowNumber: number
  data: Record<string, any>
  error: string
  code?: string
}
```

---

## 🧪 Testing Scenarios

### Test Case 1: Successful Import (All Valid)

```typescript
// File: drugs-valid.xlsx
// 50 rows, all valid, no duplicates
// Expected: 50 created, 0 errors
```

### Test Case 2: Partial Success (Some Errors)

```typescript
// File: drugs-mixed.xlsx
// 50 rows: 40 valid, 10 errors
// Expected: 40 created, 10 failed (with continueOnError=true)
```

### Test Case 3: Duplicate Handling

```typescript
// File: drugs-duplicates.xlsx
// 50 rows: 45 unique, 5 duplicates
// Expected with skipDuplicates=true: 45 created, 5 skipped
// Expected with updateExisting=true: 45 updated, 0 created
```

### Test Case 4: Foreign Key Validation

```typescript
// File: drugs-invalid-fk.xlsx
// Row 5: generic_id = 999 (not exists)
// Expected: Row 5 error "Generic drug with ID 999 not found"
```

### Test Case 5: Large File Performance

```typescript
// File: drugs-large.xlsx
// 1000 rows (max limit)
// Expected: Complete within 60 seconds
```

### Test Case 6: File Format Errors

```typescript
// Invalid file formats
// 1. drugs.pdf → 400 INVALID_FILE_FORMAT
// 2. drugs-20mb.xlsx → 413 FILE_TOO_LARGE
// 3. drugs-empty.xlsx → 400 FILE_EMPTY
// 4. drugs-2000rows.xlsx → 400 TOO_MANY_ROWS
```

### Test Case 7: Session Expiry

```typescript
// 1. Validate file → sessionId
// 2. Wait 31 minutes
// 3. Execute import → 400 SESSION_EXPIRED
```

### Test Case 8: Cancel Import

```typescript
// 1. Start import (1000 rows)
// 2. After 500 rows processed, call cancel
// 3. Expected: 500 created, 500 cancelled
```

---

## 🔐 Security Considerations

### 1. File Upload Security

```typescript
// Validate file type (magic bytes, not just extension)
// Validate file size
// Scan for malware
// Sanitize filename
// Store uploaded files in isolated directory
```

### 2. Rate Limiting

```typescript
// Limit imports per user
// Max 10 imports per hour
// Max file size 10MB
// Max 1000 rows per import
```

### 3. Authorization

```typescript
// Check user permissions before import
// Different entities may require different permissions
// drugs → PHARMACIST, ADMIN
// companies → ADMIN, FINANCE
// locations → ADMIN, WAREHOUSE_MANAGER
```

### 4. Data Sanitization

```typescript
// Sanitize all input data
// Remove HTML tags
// Escape special characters
// Validate against XSS, SQL injection
```

---

## 📚 References

- AegisX Template: `/api/authors/bulk` (existing bulk operations pattern)
- OpenAPI 3.0 Spec: http://127.0.0.1:3383/documentation/json
- Multipart Upload: [MDN FormData](https://developer.mozilla.org/en-US/docs/Web/API/FormData)
- XLSX Processing: [SheetJS](https://docs.sheetjs.com/)
- CSV Processing: [csv-parser](https://www.npmjs.com/package/csv-parser)

---

**Status**: Ready for Implementation ✅
**Next Steps**: Implement in AegisX backend, then create workflow documentation
**Estimated Effort**: 3-4 days (Backend) + 2 days (Frontend)
