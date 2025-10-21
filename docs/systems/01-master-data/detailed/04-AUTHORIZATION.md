# Authorization & Permissions - Master Data System

**Module**: Master Data Management
**Version**: 1.0.0
**Last Updated**: 2025-01-21

---

## Table of Contents

1. [Overview](#overview)
2. [Roles & Responsibilities](#roles--responsibilities)
3. [Permissions Matrix](#permissions-matrix)
4. [Implementation](#implementation)
5. [Security Rules](#security-rules)
6. [Code Examples](#code-examples)

---

## Overview

Authorization controls who can access and modify master data in the INVS system. This document defines:

- User roles and their responsibilities (บทบาทและหน้าที่)
- Permissions for each entity type
- Security rules and constraints
- Implementation patterns

### Key Principles

1. **Role-Based Access Control (RBAC)** - Permissions based on user roles
2. **Least Privilege** - Users get minimum permissions needed (สิทธิ์น้อยที่สุดที่จำเป็น)
3. **Separation of Duties** - Critical operations require multiple roles
4. **Audit Trail** - All changes are logged for accountability

---

## Roles & Responsibilities

### 1. ADMIN - System Administrator

**Thai Name**: ผู้ดูแลระบบ

**Responsibilities**:
- Full system access and configuration
- User management
- Master data setup and maintenance
- System-wide settings

**Permissions**: ALL (Create, Read, Update, Delete, Activate/Deactivate)

**Typical Users**: IT administrators, system managers

---

### 2. PHARMACIST - Pharmacist

**Thai Name**: เภสัชกร

**Responsibilities**:
- Drug master data management (จัดการข้อมูลยา)
- Generic drug catalog maintenance
- Drug status updates (compliance with ministry regulations)
- Company/vendor verification

**Permissions**:
- Drugs: Create, Read, Update, Status Change
- Drug Generics: Create, Read, Update
- Companies: Read, Create (for new vendors)
- Locations: Read
- Departments: Read

**Typical Users**: Chief pharmacist, senior pharmacists

---

### 3. WAREHOUSE_MANAGER - Warehouse Manager

**Thai Name**: หัวหน้าคลัง

**Responsibilities**:
- Location management (จัดการคลังและสถานที่เก็บยา)
- Storage organization
- Inventory location setup
- Company information (for deliveries)

**Permissions**:
- Locations: Create, Read, Update
- Companies: Read, Create
- Drugs: Read
- Drug Generics: Read
- Departments: Read

**Typical Users**: Warehouse supervisor, inventory manager

---

### 4. FINANCE - Finance Officer

**Thai Name**: เจ้าหน้าที่การเงิน

**Responsibilities**:
- Company financial verification (ตรวจสอบข้อมูลการเงินบริษัท)
- Budget type and category management
- Contract verification
- Vendor payment processing

**Permissions**:
- Companies: Read, Update (tax info, bank details)
- Budget Types: Create, Read, Update
- Budget Categories: Create, Read, Update
- Budgets: Create, Read, Update
- Banks: Create, Read, Update
- Departments: Read
- Drugs: Read (for pricing)

**Typical Users**: Finance officers, accountants

---

### 5. DEPT_HEAD - Department Head

**Thai Name**: หัวหน้าแผนก

**Responsibilities**:
- Department information management
- Staff assignments (การจัดการข้อมูลแผนก)
- Budget planning for department
- View master data for departmental use

**Permissions**:
- Departments: Read, Update (own department only)
- Locations: Read
- Drugs: Read
- Drug Generics: Read
- Companies: Read
- Budgets: Read (own department only)

**Typical Users**: Department directors, unit managers

---

### 6. VIEWER - Read-Only User

**Thai Name**: ผู้ใช้งานทั่วไป (ดูข้อมูลอย่างเดียว)

**Responsibilities**:
- View master data for reference
- Generate reports
- No modification rights

**Permissions**:
- All Entities: Read Only

**Typical Users**: Staff, nurses, general users

---

## Permissions Matrix

### Master Data Entities

| Entity | ADMIN | PHARMACIST | WAREHOUSE_MANAGER | FINANCE | DEPT_HEAD | VIEWER |
|--------|-------|------------|-------------------|---------|-----------|--------|
| **Locations** (สถานที่เก็บยา) |
| Create | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Read | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Update | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Delete | ✅ | ❌ | ⚠️¹ | ❌ | ❌ | ❌ |
| Activate/Deactivate | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| **Departments** (แผนก) |
| Create | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Read | ✅ | ✅ | ✅ | ✅ | ✅² | ✅ |
| Update | ✅ | ❌ | ❌ | ❌ | ✅² | ❌ |
| Delete | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Activate/Deactivate | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Companies** (บริษัท) |
| Create | ✅ | ✅³ | ✅³ | ✅ | ❌ | ❌ |
| Read | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Update | ✅ | ✅⁴ | ❌ | ✅⁵ | ❌ | ❌ |
| Delete | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Activate/Deactivate | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Drug Generics** (ยาสามัญ) |
| Create | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Read | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Update | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete | ✅ | ⚠️⁶ | ❌ | ❌ | ❌ | ❌ |
| Activate/Deactivate | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Drugs** (ยาชื่อการค้า) |
| Create | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Read | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Update | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete | ✅ | ⚠️⁶ | ❌ | ❌ | ❌ | ❌ |
| Change Status⁷ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Activate/Deactivate | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Budget Types** (ประเภทงบ) |
| Create | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Read | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Update | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Delete | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Budget Categories** (หมวดงบ) |
| Create | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Read | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Update | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Delete | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Budgets** (งบประมาณ) |
| Create | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Read | ✅ | ✅ | ✅ | ✅ | ✅² | ✅ |
| Update | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Delete | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Banks** (ธนาคาร) |
| Create | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Read | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Update | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Delete | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

**Legend**:
- ✅ = Allowed
- ❌ = Not allowed
- ⚠️ = Conditional/Restricted

**Notes**:
1. ⚠️¹ Warehouse Manager can only soft delete (set `isActive = false`)
2. ✅² Department Head can only access their own department
3. ✅³ Can create new vendors/manufacturers (subject to approval workflow)
4. ✅⁴ Pharmacist can update contact info, cannot change tax/financial details
5. ✅⁵ Finance can update tax ID, bank details, financial information
6. ⚠️⁶ Can soft delete only if no dependent records (inventory, contracts, etc.)
7. Status Change = Update `drugStatus` field (ACTIVE → DISCONTINUED → REMOVED) per ministry compliance

---

## Security Rules

### Rule 1: Data Scoping

**Department-Level Access**:

```typescript
// Department heads can only access their own department's data
// (หัวหน้าแผนกเห็นข้อมูลเฉพาะแผนกของตัวเอง)
if (user.role === 'DEPT_HEAD') {
  queryFilter = {
    departmentId: user.departmentId  // Scope to user's department
  }
}
```

### Rule 2: Soft Delete Only

**Never Hard Delete Master Data**:

```typescript
// Always use soft delete for master data
// (ห้ามลบจริง ให้ใช้ soft delete เท่านั้น)
async function deleteLocation(id: number, userId: number) {
  // Check if user has permission
  if (!hasPermission(userId, 'location:delete')) {
    throw new ForbiddenError('No permission to delete locations')
  }

  // Soft delete only
  await prisma.location.update({
    where: { id },
    data: {
      isActive: false,
      updatedAt: new Date(),
      updatedBy: userId
    }
  })
}
```

### Rule 3: Audit All Changes

**Log All Modifications**:

```typescript
// Log all master data changes
// (บันทึกการเปลี่ยนแปลงทั้งหมด)
async function updateDrug(id: number, data: any, userId: number) {
  await prisma.$transaction(async (tx) => {
    // Update drug
    const updated = await tx.drug.update({
      where: { id },
      data: {
        ...data,
        updatedAt: new Date(),
        updatedBy: userId
      }
    })

    // Create audit log
    await tx.auditLog.create({
      data: {
        entityType: 'drug',
        entityId: id,
        action: 'UPDATE',
        userId: userId,
        changes: data,
        timestamp: new Date()
      }
    })

    return updated
  })
}
```

### Rule 4: Critical Operations Require Verification

**Ministry Compliance Status Changes**:

```typescript
// Changing drug status requires pharmacist role
// (การเปลี่ยนสถานะยาต้องมีสิทธิ์เภสัชกร)
async function changeDrugStatus(
  drugId: number,
  newStatus: DrugStatus,
  userId: number,
  reason: string
) {
  const user = await getUser(userId)

  // Only ADMIN or PHARMACIST can change drug status
  if (!['ADMIN', 'PHARMACIST'].includes(user.role)) {
    throw new ForbiddenError('Only pharmacists can change drug status')
  }

  // Must provide reason for status change
  if (!reason || reason.trim().length < 10) {
    throw new ValidationError('Must provide detailed reason (min 10 chars)')
  }

  await prisma.drug.update({
    where: { id: drugId },
    data: {
      drugStatus: newStatus,
      statusChangedDate: new Date(),  // ⭐ Ministry compliance
      statusChangeReason: reason,
      updatedBy: userId
    }
  })
}
```

### Rule 5: Read-Only Fields

**Certain fields cannot be modified after creation**:

```typescript
// Fields that cannot be changed after creation
// (ฟิลด์ที่ห้ามแก้ไขหลังสร้างแล้ว)
const IMMUTABLE_FIELDS = [
  'id',
  'createdAt',
  'createdBy'
]

// Example: Company code cannot be changed
const COMPANY_IMMUTABLE_FIELDS = [
  ...IMMUTABLE_FIELDS,
  'companyCode'  // Cannot change after creation
]
```

---

## Implementation

### Database Schema

**User & Role Tables**:

```prisma
model User {
  id           BigInt   @id @default(autoincrement())
  username     String   @unique
  email        String   @unique
  passwordHash String
  role         UserRole
  departmentId BigInt?
  isActive     Boolean  @default(true)
  createdAt    DateTime @default(now())

  department   Department? @relation(fields: [departmentId])
}

enum UserRole {
  ADMIN
  PHARMACIST
  WAREHOUSE_MANAGER
  FINANCE
  DEPT_HEAD
  VIEWER
}

model Permission {
  id         BigInt   @id @default(autoincrement())
  role       UserRole
  resource   String   // e.g., 'location', 'drug', 'company'
  action     String   // e.g., 'create', 'read', 'update', 'delete'
  conditions Json?    // Additional conditions (e.g., departmentId match)
  createdAt  DateTime @default(now())

  @@unique([role, resource, action])
}
```

### Middleware Implementation

**Express Authorization Middleware**:

```typescript
import { Request, Response, NextFunction } from 'express'

// Check if user has permission for resource and action
// (ตรวจสอบว่าผู้ใช้มีสิทธิ์เข้าถึง resource และ action หรือไม่)
function authorize(resource: string, action: string) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const user = req.user // From auth middleware

      if (!user) {
        return res.status(401).json({ error: 'Not authenticated' })
      }

      // Check permission
      const hasPermission = await checkPermission(user, resource, action)

      if (!hasPermission) {
        return res.status(403).json({
          error: 'Forbidden',
          message: `User role '${user.role}' does not have '${action}' permission for '${resource}'`
        })
      }

      next()
    } catch (error) {
      next(error)
    }
  }
}

// Usage in routes:
app.post('/api/master-data/drugs',
  authenticate(),
  authorize('drug', 'create'),
  async (req, res) => {
    // Create drug logic
  }
)
```

### Permission Check Function

```typescript
// Check if user has specific permission
// (ตรวจสอบสิทธิ์ของผู้ใช้)
async function checkPermission(
  user: User,
  resource: string,
  action: string,
  context?: any
): Promise<boolean> {
  // ADMIN has all permissions
  if (user.role === 'ADMIN') {
    return true
  }

  // Get permission from database
  const permission = await prisma.permission.findUnique({
    where: {
      role_resource_action: {
        role: user.role,
        resource: resource,
        action: action
      }
    }
  })

  if (!permission) {
    return false
  }

  // Check additional conditions
  if (permission.conditions) {
    // Example: Department head can only access own department
    if (user.role === 'DEPT_HEAD' && context?.departmentId) {
      return context.departmentId === user.departmentId
    }
  }

  return true
}
```

### Row-Level Security

```typescript
// Apply row-level filters based on user role
// (กรองข้อมูลตามสิทธิ์ผู้ใช้)
function applySecurityFilter(user: User, baseQuery: any) {
  // Department heads only see their department's data
  if (user.role === 'DEPT_HEAD') {
    return {
      ...baseQuery,
      where: {
        ...baseQuery.where,
        departmentId: user.departmentId
      }
    }
  }

  return baseQuery
}

// Example usage:
async function getBudgets(user: User, filters: any) {
  let query = {
    where: {
      fiscalYear: filters.fiscalYear,
      isActive: true
    }
  }

  // Apply security filter based on user role
  query = applySecurityFilter(user, query)

  const budgets = await prisma.budgetAllocation.findMany(query)
  return budgets
}
```

---

## Code Examples

### Example 1: Creating a New Drug (Pharmacist)

```typescript
// POST /api/master-data/drugs
app.post('/api/master-data/drugs',
  authenticate(),
  authorize('drug', 'create'),
  async (req, res) => {
    const user = req.user
    const data = req.body

    // Validate input
    const schema = z.object({
      drugCode: z.string().min(7).max(24),
      tradeName: z.string().min(1),
      genericId: z.number().int().positive(),
      manufacturerId: z.number().int().positive(),
      nlemStatus: z.enum(['E', 'N']).optional(),
      drugStatus: z.enum(['ACTIVE', 'DISCONTINUED', 'SPECIAL_CASE', 'REMOVED']),
      productCategory: z.enum(['MODERN_REGISTERED', 'MODERN_HOSPITAL', 'HERBAL_REGISTERED', 'HERBAL_HOSPITAL', 'OTHER'])
    })

    const validated = schema.parse(data)

    // Create drug with audit
    const drug = await prisma.drug.create({
      data: {
        ...validated,
        statusChangedDate: new Date(),  // ⭐ Ministry compliance
        createdBy: user.id,
        isActive: true
      },
      include: {
        generic: true,
        manufacturer: true
      }
    })

    // Log activity
    await logActivity({
      userId: user.id,
      action: 'CREATE_DRUG',
      entityType: 'drug',
      entityId: drug.id,
      details: `Created drug: ${drug.tradeName}`
    })

    res.status(201).json(drug)
  }
)
```

### Example 2: Updating Company Info (Different Permissions)

```typescript
// PUT /api/master-data/companies/:id
app.put('/api/master-data/companies/:id',
  authenticate(),
  authorize('company', 'update'),
  async (req, res) => {
    const user = req.user
    const companyId = parseInt(req.params.id)
    const updates = req.body

    // Filter allowed fields based on role
    let allowedUpdates = {}

    if (user.role === 'PHARMACIST') {
      // Pharmacist can only update contact info
      // (เภสัชกรแก้ไขได้เฉพาะข้อมูลติดต่อ)
      allowedUpdates = {
        companyName: updates.companyName,
        address: updates.address,
        phone: updates.phone,
        email: updates.email,
        contactPerson: updates.contactPerson
      }
    } else if (user.role === 'FINANCE') {
      // Finance can update financial info
      // (การเงินแก้ไขข้อมูลทางการเงินได้)
      allowedUpdates = {
        taxId: updates.taxId,
        bankAccountNumber: updates.bankAccountNumber,
        bankId: updates.bankId
      }
    } else if (user.role === 'ADMIN') {
      // Admin can update everything
      allowedUpdates = updates
    }

    // Update company
    const company = await prisma.company.update({
      where: { id: companyId },
      data: {
        ...allowedUpdates,
        updatedBy: user.id,
        updatedAt: new Date()
      }
    })

    res.json(company)
  }
)
```

### Example 3: Department Head Viewing Budgets

```typescript
// GET /api/master-data/budgets
app.get('/api/master-data/budgets',
  authenticate(),
  authorize('budget', 'read'),
  async (req, res) => {
    const user = req.user

    // Build query with security filter
    let query: any = {
      where: {
        fiscalYear: req.query.fiscalYear || '2568',
        isActive: true
      }
    }

    // Department heads only see their own department's budget
    // (หัวหน้าแผนกเห็นเฉพาะงบประมาณของแผนกตนเอง)
    if (user.role === 'DEPT_HEAD') {
      query.where.departmentId = user.departmentId
    }

    const budgets = await prisma.budgetAllocation.findMany({
      ...query,
      include: {
        budgetType: true,
        department: true
      }
    })

    res.json(budgets)
  }
)
```

---

## Best Practices

### 1. Defense in Depth

Implement authorization at multiple levels:
- **API Level**: Middleware checks (ตรวจสอบที่ API middleware)
- **Business Logic**: Function-level checks
- **Database**: Row-level security filters

### 2. Fail Securely

```typescript
// Default to deny if permission check fails
// (ปฏิเสธทันทีถ้าตรวจสอบสิทธิ์ไม่ผ่าน)
try {
  const hasPermission = await checkPermission(user, resource, action)
  if (!hasPermission) {
    throw new ForbiddenError('Access denied')
  }
} catch (error) {
  // If error during permission check, deny access
  throw new ForbiddenError('Access denied')
}
```

### 3. Log All Authorization Failures

```typescript
// Log failed authorization attempts for security audit
// (บันทึกความพยายามเข้าถึงที่ไม่ได้รับอนุญาต)
if (!hasPermission) {
  await logSecurityEvent({
    type: 'AUTHORIZATION_FAILED',
    userId: user.id,
    resource: resource,
    action: action,
    timestamp: new Date(),
    ipAddress: req.ip
  })
  throw new ForbiddenError('Access denied')
}
```

### 4. Separate Read and Write Permissions

```typescript
// Different permissions for reading vs modifying
// (แยกสิทธิ์การอ่านกับการแก้ไข)
const permissions = {
  'drug:read': ['ADMIN', 'PHARMACIST', 'WAREHOUSE_MANAGER', 'FINANCE', 'DEPT_HEAD', 'VIEWER'],
  'drug:create': ['ADMIN', 'PHARMACIST'],
  'drug:update': ['ADMIN', 'PHARMACIST'],
  'drug:delete': ['ADMIN'],
  'drug:changeStatus': ['ADMIN', 'PHARMACIST']  // Ministry compliance
}
```

---

## Testing Authorization

```typescript
describe('Drug Authorization', () => {
  it('should allow pharmacist to create drugs', async () => {
    const user = { id: 1, role: 'PHARMACIST' }
    const result = await checkPermission(user, 'drug', 'create')
    expect(result).toBe(true)
  })

  it('should deny warehouse manager from creating drugs', async () => {
    const user = { id: 2, role: 'WAREHOUSE_MANAGER' }
    const result = await checkPermission(user, 'drug', 'create')
    expect(result).toBe(false)
  })

  it('should allow department head to read only their department budget', async () => {
    const user = { id: 3, role: 'DEPT_HEAD', departmentId: 5 }

    // Should succeed for their department
    const allowed = await checkPermission(user, 'budget', 'read', { departmentId: 5 })
    expect(allowed).toBe(true)

    // Should fail for other department
    const denied = await checkPermission(user, 'budget', 'read', { departmentId: 10 })
    expect(denied).toBe(false)
  })
})
```

---

**Version**: 1.0.0
**Last Updated**: 2025-01-21
**Status**: Ready for Implementation
