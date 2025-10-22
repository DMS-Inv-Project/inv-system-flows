# Validation Rules & Error Handling
**Version**: 2.2.0 | **Last Updated**: 2025-01-21

> Complete validation rules, error codes, และ recovery strategies สำหรับระบบ Master Data

---

## 📖 Table of Contents

1. [Validation Levels](#validation-levels)
2. [Company Validation](#1-company-validation)
3. [Drug Generic Validation](#2-drug-generic-validation)
4. [Drug Validation](#3-drug-validation)
5. [Contract Validation](#4-contract-validation)
6. [Location/Department Validation](#5-locationdepartment-validation)
7. [Error Code Reference](#error-code-reference)
8. [Implementation Examples](#implementation-examples)

---

## Validation Levels

### 1. Field-Level Validation (Input Validation)
- Format validation
- Data type validation
- Length validation
- Required field checks

### 2. Business Validation (Business Rules)
- Cross-field validation
- Cross-table validation
- Uniqueness constraints
- Referential integrity

### 3. Database Constraints
- Primary keys
- Foreign keys
- Unique constraints
- Check constraints

---

## 1. Company Validation

### Field-Level Validation

| Field | Type | Required | Validation Rule | Error Code |
|-------|------|----------|----------------|------------|
| **company_code** | string | ✅ | `/^C\d{5}$/` (C00001-C99999) | COMP001 |
| **company_name** | string | ✅ | Length: 2-100 chars | COMP002 |
| **company_type** | enum | ✅ | VENDOR \| MANUFACTURER \| BOTH | COMP003 |
| **tax_id** | string | ❌ | 13 digits (if provided) | COMP004 |
| **email** | string | ❌ | Valid email format | COMP005 |
| **phone** | string | ❌ | 10 digits (Thai format) | COMP006 |
| **bank_id** | number | ❌ | Valid FK to bank.id | COMP007 |

### Business Validation Rules

#### Rule 1: Unique Company Code
```typescript
async function validateUniqueCompanyCode(code: string): Promise<void> {
  const existing = await prisma.company.findUnique({
    where: { companyCode: code }
  })

  if (existing) {
    throw new ValidationError('COMP001', 'Company code already exists', {
      field: 'companyCode',
      value: code,
      suggestion: 'Use a different company code'
    })
  }
}
```

**SQL Check**:
```sql
SELECT COUNT(*) FROM companies WHERE company_code = :code;
-- Must return 0 for new record
```

---

#### Rule 2: Cannot Delete Company with Active Relationships

**Check active contracts**:
```typescript
async function validateCanDeleteCompany(id: number): Promise<void> {
  const [contracts, purchaseOrders, drugs] = await Promise.all([
    prisma.contract.count({ where: { vendorId: id, status: 'ACTIVE' } }),
    prisma.purchaseOrder.count({
      where: {
        vendorId: id,
        status: { in: ['PENDING', 'SENT', 'PARTIAL_RECEIVED'] }
      }
    }),
    prisma.drug.count({ where: { manufacturerId: id, isActive: true } })
  ])

  const errors = []
  if (contracts > 0) {
    errors.push(`${contracts} active contract(s)`)
  }
  if (purchaseOrders > 0) {
    errors.push(`${purchaseOrders} active PO(s)`)
  }
  if (drugs > 0) {
    errors.push(`${drugs} active drug(s)`)
  }

  if (errors.length > 0) {
    throw new BusinessRuleError(
      'COMP010',
      `Cannot delete company. Has: ${errors.join(', ')}`,
      {
        activeContracts: contracts,
        activePOs: purchaseOrders,
        activeDrugs: drugs,
        recoveryAction: 'Close/transfer all relationships first'
      }
    )
  }
}
```

**SQL Check**:
```sql
-- Check all relationships
SELECT
  (SELECT COUNT(*) FROM contracts
   WHERE vendor_id = :id AND status = 'ACTIVE') as active_contracts,
  (SELECT COUNT(*) FROM purchase_orders
   WHERE vendor_id = :id
   AND status IN ('PENDING', 'SENT', 'PARTIAL_RECEIVED')) as active_pos,
  (SELECT COUNT(*) FROM drugs
   WHERE manufacturer_id = :id AND is_active = true) as active_drugs;

-- All must be 0
```

---

#### Rule 3: Tax ID Format (Thai)

```typescript
function validateThaiTaxId(taxId: string): boolean {
  // Must be 13 digits
  if (!/^\d{13}$/.test(taxId)) {
    return false
  }

  // Checksum validation (Thai algorithm)
  const digits = taxId.split('').map(Number)
  let sum = 0

  for (let i = 0; i < 12; i++) {
    sum += digits[i] * (13 - i)
  }

  const checkDigit = (11 - (sum % 11)) % 10

  return checkDigit === digits[12]
}

// Usage
if (!validateThaiTaxId(data.taxId)) {
  throw new ValidationError('COMP004', 'Invalid Thai tax ID format or checksum')
}
```

---

### Zod Schema Example

```typescript
import { z } from 'zod'

export const createCompanySchema = z.object({
  companyCode: z.string()
    .regex(/^C\d{5}$/, 'Company code must match format C00001')
    .length(6, 'Company code must be exactly 6 characters'),

  companyName: z.string()
    .min(2, 'Company name too short (min 2 chars)')
    .max(100, 'Company name too long (max 100 chars)'),

  companyType: z.enum(['VENDOR', 'MANUFACTURER', 'BOTH'], {
    errorMap: () => ({ message: 'Invalid company type' })
  }),

  taxId: z.string()
    .regex(/^\d{13}$/, 'Tax ID must be 13 digits')
    .refine(validateThaiTaxId, 'Invalid tax ID checksum')
    .optional(),

  email: z.string()
    .email('Invalid email format')
    .optional(),

  phone: z.string()
    .regex(/^0\d{9}$/, 'Phone must be 10 digits starting with 0')
    .optional(),

  bankId: z.number()
    .int('Bank ID must be integer')
    .positive('Bank ID must be positive')
    .optional()
})

// Usage in API
app.post('/api/companies', async (req, res) => {
  try {
    const validated = createCompanySchema.parse(req.body)
    const company = await createCompany(validated)
    res.status(201).json(company)
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({
        error: 'VALIDATION_ERROR',
        details: error.errors
      })
    }
    throw error
  }
})
```

---

## 2. Drug Generic Validation

### Field-Level Validation

| Field | Type | Required | Validation Rule | Error Code |
|-------|------|----------|----------------|------------|
| **working_code** | string | ✅ | `/^[A-Z]{3}\d{4}$/` (PAR0001) | DGEN001 |
| **drug_name** | string | ✅ | Length: 5-60 chars | DGEN002 |
| **dosage_form** | string | ✅ | Valid form (TAB, CAP, INJ, etc.) | DGEN003 |
| **sale_unit** | string | ✅ | Valid unit (TAB, CAP, VIAL, etc.) | DGEN004 |
| **strength** | decimal | ❌ | Must be > 0 if provided | DGEN005 |
| **strength_unit** | string | ❌ | Valid unit (mg, g, ml, etc.) | DGEN006 |

### Business Validation Rules

#### Rule 1: Unique Working Code
```typescript
async function validateUniqueWorkingCode(code: string): Promise<void> {
  const existing = await prisma.drugGeneric.findUnique({
    where: { workingCode: code }
  })

  if (existing) {
    throw new ValidationError('DGEN001', 'Working code already exists', {
      field: 'workingCode',
      value: code,
      existingDrug: existing.drugName
    })
  }
}
```

---

#### Rule 2: Dosage Form Must Be Valid

```typescript
const VALID_DOSAGE_FORMS = [
  'TAB', 'CAP', 'INJ', 'SYR', 'SUSP', 'CRE', 'OIN',
  'SOL', 'DROP', 'SUPP', 'POWDER', 'OTHER'
] as const

function validateDosageForm(form: string): boolean {
  return VALID_DOSAGE_FORMS.includes(form as any)
}

// Usage
if (!validateDosageForm(data.dosageForm)) {
  throw new ValidationError('DGEN003', 'Invalid dosage form', {
    field: 'dosageForm',
    value: data.dosageForm,
    validValues: VALID_DOSAGE_FORMS
  })
}
```

---

#### Rule 3: Cannot Delete if Has Active Drugs

```typescript
async function validateCanDeleteGeneric(id: number): Promise<void> {
  const activeDrugs = await prisma.drug.count({
    where: { genericId: id, isActive: true }
  })

  if (activeDrugs > 0) {
    throw new BusinessRuleError(
      'DGEN010',
      `Cannot delete generic. ${activeDrugs} active drug(s) still reference it`,
      {
        activeDrugs,
        recoveryAction: 'Deactivate or delete all related drugs first'
      }
    )
  }
}
```

---

## 3. Drug Validation

### Field-Level Validation

| Field | Type | Required | Validation Rule | Error Code |
|-------|------|----------|----------------|------------|
| **drug_code** | string | ✅ | `/^[A-Z0-9]{7,24}$/` | DRUG001 |
| **trade_name** | string | ✅ | Length: 5-100 chars | DRUG002 |
| **generic_id** | number | ✅ | Valid FK to drug_generics.id | DRUG003 |
| **manufacturer_id** | number | ✅ | Valid FK to companies.id | DRUG004 |
| **pack_size** | number | ❌ | Integer > 0 | DRUG005 |
| **unit_price** | decimal | ❌ | >= 0 | DRUG006 |
| **nlem_status** ⭐ | enum | ❌ | E \| N | DRUG007 |
| **drug_status** ⭐ | enum | ✅ | ACTIVE \| DISCONTINUED \| SPECIAL_CASE \| REMOVED | DRUG008 |
| **product_category** ⭐ | enum | ❌ | 1-5 (enum values) | DRUG009 |

### Business Validation Rules

#### Rule 1: Generic Must Exist

```typescript
async function validateGenericExists(genericId: number): Promise<void> {
  const generic = await prisma.drugGeneric.findUnique({
    where: { id: genericId }
  })

  if (!generic) {
    throw new ValidationError('DRUG003', 'Generic drug not found', {
      field: 'genericId',
      value: genericId,
      recoveryAction: 'Create generic drug first or use valid ID'
    })
  }

  if (!generic.isActive) {
    throw new BusinessRuleError(
      'DRUG011',
      'Cannot create drug for inactive generic',
      {
        genericId,
        genericName: generic.drugName,
        recoveryAction: 'Activate generic drug first'
      }
    )
  }
}
```

---

#### Rule 2: Manufacturer Must Be Active

```typescript
async function validateManufacturerActive(manufacturerId: number): Promise<void> {
  const manufacturer = await prisma.company.findUnique({
    where: { id: manufacturerId }
  })

  if (!manufacturer) {
    throw new ValidationError('DRUG004', 'Manufacturer not found')
  }

  if (!manufacturer.isActive) {
    throw new BusinessRuleError(
      'DRUG012',
      'Manufacturer is not active',
      {
        manufacturerId,
        companyName: manufacturer.companyName,
        recoveryAction: 'Activate manufacturer or choose different one'
      }
    )
  }

  if (manufacturer.companyType === 'VENDOR') {
    throw new BusinessRuleError(
      'DRUG013',
      'Selected company is VENDOR only, not a manufacturer',
      {
        companyId: manufacturerId,
        companyType: manufacturer.companyType,
        recoveryAction: 'Choose company with type MANUFACTURER or BOTH'
      }
    )
  }
}
```

---

#### Rule 3: Status Change Must Update Date ⭐ Ministry Requirement

```typescript
async function updateDrugStatus(
  drugId: number,
  newStatus: 'ACTIVE' | 'DISCONTINUED' | 'SPECIAL_CASE' | 'REMOVED',
  reason?: string
): Promise<Drug> {
  const drug = await prisma.drug.findUnique({ where: { id: drugId } })

  if (!drug) {
    throw new NotFoundError('Drug not found')
  }

  // Validate state transition (see state machine docs)
  validateStatusTransition(drug.drugStatus, newStatus)

  // Update with status_changed_date (CRITICAL for ministry reporting!)
  const updated = await prisma.drug.update({
    where: { id: drugId },
    data: {
      drugStatus: newStatus,
      statusChangedDate: new Date(), // ⭐ REQUIRED
      isActive: newStatus === 'ACTIVE' || newStatus === 'SPECIAL_CASE',
      updatedAt: new Date()
    }
  })

  // Optional: Log change for audit trail
  await createStatusChangeLog(drugId, drug.drugStatus, newStatus, reason)

  return updated
}
```

---

### Zod Schema with Ministry Fields ⭐

```typescript
export const createDrugSchema = z.object({
  drugCode: z.string()
    .regex(/^[A-Z0-9]{7,24}$/, 'Invalid drug code format'),

  tradeName: z.string()
    .min(5, 'Trade name too short')
    .max(100, 'Trade name too long'),

  genericId: z.number()
    .int()
    .positive(),

  manufacturerId: z.number()
    .int()
    .positive(),

  packSize: z.number()
    .int()
    .positive()
    .default(1),

  unitPrice: z.number()
    .nonnegative('Price cannot be negative')
    .optional(),

  // ⭐ Ministry Compliance Fields
  nlemStatus: z.enum(['E', 'N'], {
    errorMap: () => ({ message: 'NLEM status must be E (Essential) or N (Non-Essential)' })
  }).optional(),

  drugStatus: z.enum(['ACTIVE', 'DISCONTINUED', 'SPECIAL_CASE', 'REMOVED'])
    .default('ACTIVE'),

  productCategory: z.enum([
    'MODERN_REGISTERED',
    'MODERN_HOSPITAL',
    'HERBAL_REGISTERED',
    'HERBAL_HOSPITAL',
    'OTHER'
  ]).optional()
})

export const updateDrugStatusSchema = z.object({
  drugStatus: z.enum(['ACTIVE', 'DISCONTINUED', 'SPECIAL_CASE', 'REMOVED']),
  reason: z.string().optional()
})
```

---

## 4. Contract Validation

### Field-Level Validation

| Field | Type | Required | Validation Rule | Error Code |
|-------|------|----------|----------------|------------|
| **contract_number** | string | ✅ | Unique, 5-20 chars | CONT001 |
| **contract_type** | enum | ✅ | CENTRAL_PURCHASE \| SMALL_PURCHASE \| ANNUAL_CONTRACT | CONT002 |
| **vendor_id** | number | ✅ | Valid FK, company_type must allow VENDOR | CONT003 |
| **start_date** | date | ✅ | Valid date | CONT004 |
| **end_date** | date | ✅ | Must be > start_date | CONT005 |
| **total_value** | decimal | ✅ | Must be > 0 | CONT006 |
| **fiscal_year** | string | ✅ | 4 digits (พ.ศ.) | CONT007 |

### Business Validation Rules

#### Rule 1: Date Range Validation

```typescript
function validateContractDates(
  startDate: Date,
  endDate: Date
): void {
  if (startDate >= endDate) {
    throw new ValidationError('CONT005', 'End date must be after start date', {
      startDate: startDate.toISOString(),
      endDate: endDate.toISOString(),
      suggestion: 'Check date range'
    })
  }

  // Warn if contract is too long (> 3 years)
  const years = (endDate.getTime() - startDate.getTime()) / (365 * 24 * 60 * 60 * 1000)
  if (years > 3) {
    console.warn(`Contract duration is ${years.toFixed(1)} years (> 3 years)`)
  }
}
```

---

#### Rule 2: Contract Items Must Sum to Total Value

```typescript
async function validateContractItems(
  totalValue: number,
  items: Array<{ unitPrice: number; quantityContracted: number }>
): Promise<void> {
  const itemsTotal = items.reduce(
    (sum, item) => sum + (item.unitPrice * item.quantityContracted),
    0
  )

  const tolerance = 0.01 // Allow 1 baht difference for rounding
  const diff = Math.abs(itemsTotal - totalValue)

  if (diff > tolerance) {
    throw new BusinessRuleError(
      'CONT010',
      'Contract items total does not match contract total value',
      {
        contractTotal: totalValue,
        itemsTotal,
        difference: diff,
        recoveryAction: 'Adjust item prices or quantities to match total value'
      }
    )
  }
}
```

---

#### Rule 3: Cannot Exceed Remaining Value

```typescript
async function validatePOAgainstContract(
  contractId: number,
  poValue: number
): Promise<void> {
  const contract = await prisma.contract.findUnique({
    where: { id: contractId }
  })

  if (!contract) {
    throw new NotFoundError('Contract not found')
  }

  if (contract.status !== 'ACTIVE') {
    throw new BusinessRuleError(
      'CONT011',
      `Cannot create PO. Contract status is ${contract.status}`,
      {
        contractId,
        contractStatus: contract.status,
        recoveryAction: 'Use active contract only'
      }
    )
  }

  const remainingValue = contract.remainingValue.toNumber()
  if (poValue > remainingValue) {
    throw new BusinessRuleError(
      'CONT012',
      'PO value exceeds remaining contract value',
      {
        contractId,
        contractNumber: contract.contractNumber,
        remainingValue,
        requestedValue: poValue,
        overage: poValue - remainingValue,
        recoveryAction: `Reduce PO value to ${remainingValue} or less`
      }
    )
  }
}
```

---

## 5. Location/Department Validation

### Location Validation

| Field | Type | Required | Validation Rule | Error Code |
|-------|------|----------|----------------|------------|
| **location_code** | string | ✅ | Unique, 3-10 chars | LOC001 |
| **location_name** | string | ✅ | 5-100 chars | LOC002 |
| **location_type** | enum | ✅ | WAREHOUSE \| PHARMACY \| WARD \| EMERGENCY \| OR \| ICU \| GENERAL | LOC003 |
| **parent_id** | number | ❌ | Valid FK to locations.id | LOC004 |

#### Business Rule: Cannot Be Own Parent

```typescript
async function validateLocationParent(
  locationId: number | null,
  parentId: number | null
): Promise<void> {
  if (!parentId) return // No parent is OK

  if (locationId && locationId === parentId) {
    throw new BusinessRuleError('LOC010', 'Location cannot be its own parent')
  }

  // Check parent exists
  const parent = await prisma.location.findUnique({ where: { id: parentId } })
  if (!parent) {
    throw new ValidationError('LOC004', 'Parent location not found')
  }

  // Check for circular reference (if updating existing location)
  if (locationId) {
    const circular = await checkCircularReference(locationId, parentId)
    if (circular) {
      throw new BusinessRuleError(
        'LOC011',
        'Circular parent reference detected',
        { recoveryAction: 'Choose different parent' }
      )
    }
  }
}

async function checkCircularReference(
  locationId: number,
  parentId: number
): Promise<boolean> {
  let currentId: number | null = parentId

  while (currentId !== null) {
    if (currentId === locationId) return true

    const location = await prisma.location.findUnique({
      where: { id: currentId },
      select: { parentId: true }
    })

    currentId = location?.parentId || null
  }

  return false
}
```

### Department Validation

Similar to Location, plus:

| Field | Type | Required | Validation Rule | Error Code |
|-------|------|----------|----------------|------------|
| **consumption_group** ⭐ | enum | ❌ | OPD_IPD_MIX \| OPD_MAINLY \| ... | DEPT007 |

---

## Error Code Reference

### Company Errors (COMP)

| Code | Message | HTTP | Recovery |
|------|---------|------|----------|
| COMP001 | Company code already exists | 409 | Use different code |
| COMP002 | Invalid company name length | 400 | Adjust to 2-100 chars |
| COMP003 | Invalid company type | 400 | Use VENDOR/MANUFACTURER/BOTH |
| COMP004 | Invalid tax ID format/checksum | 400 | Check tax ID (13 digits) |
| COMP005 | Invalid email format | 400 | Use valid email |
| COMP006 | Invalid phone format | 400 | Use 10 digits (0x-xxxx-xxxx) |
| COMP007 | Bank not found | 404 | Use valid bank_id or omit |
| COMP010 | Has active relationships | 409 | Close contracts/POs/drugs first |
| COMP011 | Has active purchase orders | 409 | Complete or cancel POs |
| COMP020 | Already active | 400 | No action needed |
| COMP021 | Required fields missing for activation | 400 | Complete all required fields |

### Drug Generic Errors (DGEN)

| Code | Message | HTTP | Recovery |
|------|---------|------|----------|
| DGEN001 | Working code already exists | 409 | Use different code |
| DGEN002 | Invalid drug name length | 400 | Adjust to 5-60 chars |
| DGEN003 | Invalid dosage form | 400 | Use valid form (TAB/CAP/etc) |
| DGEN004 | Invalid sale unit | 400 | Use valid unit |
| DGEN005 | Invalid strength value | 400 | Must be > 0 |
| DGEN006 | Invalid strength unit | 400 | Use mg/g/ml/etc |
| DGEN010 | Has active drugs | 409 | Deactivate related drugs first |

### Drug Errors (DRUG)

| Code | Message | HTTP | Recovery |
|------|---------|------|----------|
| DRUG001 | Invalid drug code format | 400 | Use 7-24 alphanumeric chars |
| DRUG002 | Invalid trade name length | 400 | Adjust to 5-100 chars |
| DRUG003 | Generic drug not found | 404 | Create generic or use valid ID |
| DRUG004 | Manufacturer not found | 404 | Create company or use valid ID |
| DRUG005 | Invalid pack size | 400 | Must be integer > 0 |
| DRUG006 | Invalid unit price | 400 | Must be >= 0 |
| DRUG007 | Invalid NLEM status | 400 | Use E or N |
| DRUG008 | Invalid drug status | 400 | Use ACTIVE/DISCONTINUED/SPECIAL_CASE/REMOVED |
| DRUG009 | Invalid product category | 400 | Use 1-5 (enum values) |
| DRUG011 | Generic is inactive | 409 | Activate generic first |
| DRUG012 | Manufacturer is inactive | 409 | Activate manufacturer first |
| DRUG013 | Company is not manufacturer | 409 | Choose MANUFACTURER or BOTH type |
| DRUG020 | Invalid status transition | 400 | Check state machine rules |

### Contract Errors (CONT)

| Code | Message | HTTP | Recovery |
|------|---------|------|----------|
| CONT001 | Contract number already exists | 409 | Use different number |
| CONT002 | Invalid contract type | 400 | Use valid type |
| CONT003 | Vendor not found | 404 | Use valid vendor_id |
| CONT004 | Invalid start date | 400 | Use valid date |
| CONT005 | End date must be after start date | 400 | Adjust date range |
| CONT006 | Invalid total value | 400 | Must be > 0 |
| CONT007 | Invalid fiscal year | 400 | Use 4 digits (พ.ศ.) |
| CONT010 | Items total mismatch | 400 | Adjust items to match total |
| CONT011 | Contract not active | 409 | Use active contract |
| CONT012 | Exceeds remaining value | 409 | Reduce PO value |

### Location Errors (LOC)

| Code | Message | HTTP | Recovery |
|------|---------|------|----------|
| LOC001 | Location code already exists | 409 | Use different code |
| LOC002 | Invalid location name | 400 | Adjust to 5-100 chars |
| LOC003 | Invalid location type | 400 | Use valid type |
| LOC004 | Parent location not found | 404 | Use valid parent_id |
| LOC010 | Cannot be own parent | 400 | Choose different parent |
| LOC011 | Circular parent reference | 400 | Choose different parent |
| LOC020 | Has inventory, cannot deactivate | 409 | Transfer inventory first |

### Department Errors (DEPT)

| Code | Message | HTTP | Recovery |
|------|---------|------|----------|
| DEPT001 | Department code already exists | 409 | Use different code |
| DEPT007 | Invalid consumption group | 400 | Use valid enum value |
| DEPT020 | Has active budget allocations | 409 | Close budgets first |

---

## Implementation Examples

### Error Handler Middleware (Express)

```typescript
import { Request, Response, NextFunction } from 'express'
import { Prisma } from '@prisma/client'

// Custom error classes
class ValidationError extends Error {
  constructor(
    public code: string,
    message: string,
    public details?: any
  ) {
    super(message)
    this.name = 'ValidationError'
  }
}

class BusinessRuleError extends Error {
  constructor(
    public code: string,
    message: string,
    public details?: any
  ) {
    super(message)
    this.name = 'BusinessRuleError'
  }
}

// Error handler middleware
function errorHandler(
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
) {
  console.error('Error:', error)

  // Validation errors
  if (error instanceof ValidationError) {
    return res.status(400).json({
      error: error.code,
      message: error.message,
      details: error.details
    })
  }

  // Business rule errors
  if (error instanceof BusinessRuleError) {
    return res.status(409).json({
      error: error.code,
      message: error.message,
      details: error.details
    })
  }

  // Prisma errors
  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    // Unique constraint violation
    if (error.code === 'P2002') {
      const target = (error.meta?.target as string[]) || []
      return res.status(409).json({
        error: 'UNIQUE_VIOLATION',
        message: `Duplicate value for: ${target.join(', ')}`,
        details: { fields: target }
      })
    }

    // Foreign key constraint
    if (error.code === 'P2003') {
      return res.status(404).json({
        error: 'FOREIGN_KEY_VIOLATION',
        message: 'Related record not found',
        details: error.meta
      })
    }
  }

  // Default error
  res.status(500).json({
    error: 'INTERNAL_SERVER_ERROR',
    message: 'An unexpected error occurred'
  })
}

export { ValidationError, BusinessRuleError, errorHandler }
```

---

**🎯 Next**: See [Authorization](04-AUTHORIZATION.md) for permissions and role-based access control.

---

**Version**: 2.2.0
**Last Updated**: 2025-01-21
**Maintained by**: INVS Modern Team
