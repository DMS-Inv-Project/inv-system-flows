# ⚙️ Technical Requirements Document (TRD)

**Project:** INVS Modern - Hospital Inventory Management System
**Version:** 2.4.0
**Date:** 2025-01-22
**Status:** Production Ready (Database Schema Phase)

---

## 1. Executive Summary

### 1.1 Technical Overview
INVS Modern is built as a modern, type-safe database-centric application using PostgreSQL 15, Prisma ORM, and TypeScript. The architecture emphasizes data integrity, business logic at the database layer, and comprehensive audit trails.

### 1.2 Current Implementation Status
- ✅ **Database Schema**: 52 tables, 22 enums, 11 views, 12 functions
- ✅ **Data Migration**: 3,152 records (Phases 1-4 complete)
- ✅ **Ministry Compliance**: 100% (79/79 fields)
- ⏳ **Backend API**: Not started (planned)
- ⏳ **Frontend**: Not started (planned)

### 1.3 Technology Stack

**Database Tier:**
- PostgreSQL 15-alpine
- Prisma ORM 5.x (Type-safe query builder)
- Database Functions (Business logic in PL/pgSQL)
- Materialized Views (Performance optimization)

**Backend API Tier** (Planned):
- Node.js 20.x LTS
- TypeScript 5.x (Strict mode)
- Express.js or Fastify (REST API)
- Zod (Runtime validation)
- JWT (Authentication)

**Frontend Tier** (Planned):
- React 18.x + TypeScript
- TanStack Query (Data fetching)
- shadcn/ui + TailwindCSS (UI components)
- React Hook Form + Zod (Forms)

---

## 2. System Architecture

### 2.1 Architecture Style
**Three-Tier Architecture** with emphasis on database-centric design:

```
┌─────────────────────────────────────────────────┐
│           Frontend (Web Browser)                │
│  React + TypeScript + TanStack Query            │
└───────────────┬─────────────────────────────────┘
                │ HTTPS/JSON
                │ REST API
┌───────────────▼─────────────────────────────────┐
│           Backend API Server                    │
│  Node.js + Express/Fastify + Prisma             │
│  - Authentication & Authorization               │
│  - Request Validation (Zod)                     │
│  - Business Logic Orchestration                 │
│  - Error Handling                               │
└───────────────┬─────────────────────────────────┘
                │ Prisma Client
                │ Type-safe queries
┌───────────────▼─────────────────────────────────┐
│        PostgreSQL Database                      │
│  - 44 Tables (Normalized 3NF)                   │
│  - 22 Enums (Type safety)                       │
│  - 12 Functions (Business logic)                │
│  - 11 Views (Reporting)                         │
│  - Row-level Security (Future)                  │
│  - Audit Triggers                               │
└─────────────────────────────────────────────────┘
```

### 2.2 Design Principles

**Database-Centric Design:**
- Critical business logic implemented as database functions
- Data validation at database level (constraints, triggers)
- Atomic transactions ensure consistency
- Views provide denormalized data for reporting

**Type Safety Throughout:**
- Prisma generates TypeScript types from database schema
- Zod validates runtime data at API boundaries
- TypeScript strict mode catches compile-time errors
- No `any` types allowed

**Separation of Concerns:**
- Database: Data integrity and business rules
- Backend: API orchestration and authentication
- Frontend: User interface and experience

---

## 3. Database Technical Requirements

### 3.1 Database Server (TR-DB-001)

**PostgreSQL Configuration:**
```
Version: PostgreSQL 15.x
Max Connections: 100
Shared Buffers: 1GB (25% of RAM)
Effective Cache Size: 3GB (75% of RAM)
Work Memory: 10MB
Maintenance Work Memory: 256MB
WAL Level: replica
Max WAL Size: 2GB
Checkpoint Completion Target: 0.9
```

**Container Specifications:**
```yaml
Image: postgres:15-alpine
CPU: 2 cores minimum
RAM: 4GB minimum, 8GB recommended
Storage: 100GB SSD with 1000 IOPS
Network: Private network only
```

**Connection Pooling:**
- Prisma connection pool size: 10-20 connections
- Connection timeout: 10 seconds
- Idle timeout: 600 seconds
- Statement timeout: 30 seconds

**Acceptance Criteria:**
- Database handles 100 concurrent connections
- Query response time <100ms for indexed lookups
- Transaction commit time <50ms
- Backup completion time <30 minutes

### 3.2 Schema Design (TR-DB-002)

**Normalization:**
- All tables in Third Normal Form (3NF)
- No repeating groups
- No transitive dependencies
- Foreign key constraints enforced

**Primary Keys:**
- All tables have `id` as primary key
- Type: SERIAL (auto-increment integer)
- Surrogate keys preferred over natural keys

**Timestamps:**
- All tables have `created_at TIMESTAMP DEFAULT NOW()`
- Mutable tables have `updated_at TIMESTAMP DEFAULT NOW()`
- Update trigger maintains `updated_at` automatically

**Soft Deletes:**
- Critical tables (transactions, audit logs): No deletes allowed
- Master data: `deleted_at TIMESTAMP NULL` for soft delete
- Views filter out soft-deleted records

**Audit Trail:**
- All state changes logged with user ID and timestamp
- Audit log table: `audit_logs (entity_type, entity_id, action, old_value, new_value, user_id, timestamp)`
- Retention: 10 years

**Acceptance Criteria:**
- No orphaned foreign keys (verified by FK constraints)
- No data redundancy (verified by normalization rules)
- All timestamps in UTC timezone
- Audit logs capture 100% of critical operations

### 3.3 Database Functions (TR-DB-003)

**Business Logic Functions (12 implemented):**

**Budget Management Functions:**
```sql
-- Check budget availability
check_budget_availability(
  fiscal_year INT,
  budget_type_id INT,
  department_id INT,
  amount DECIMAL,
  quarter INT
) RETURNS TABLE(available BOOLEAN, available_amount DECIMAL)

-- Reserve budget
reserve_budget(
  allocation_id INT,
  pr_id INT,
  amount DECIMAL,
  expires_days INT DEFAULT 30
) RETURNS INT

-- Commit budget
commit_budget(
  allocation_id INT,
  po_id INT,
  amount DECIMAL,
  quarter INT
) RETURNS BOOLEAN

-- Release reservation
release_budget_reservation(
  reservation_id INT
) RETURNS BOOLEAN
```

**Budget Planning Functions:**
```sql
-- Check drug in budget plan
check_drug_in_budget_plan(
  fiscal_year INT,
  department_id INT,
  generic_id INT,
  requested_qty DECIMAL,
  quarter INT
) RETURNS TABLE(in_plan BOOLEAN, planned_qty DECIMAL, remaining_qty DECIMAL)

-- Update budget plan purchase
update_budget_plan_purchase(
  plan_item_id INT,
  quantity DECIMAL,
  value DECIMAL,
  quarter INT
) RETURNS BOOLEAN
```

**Inventory Functions:**
```sql
-- Get FIFO lots
get_fifo_lots(
  drug_id INT,
  location_id INT,
  quantity_needed DECIMAL
) RETURNS TABLE(lot_id INT, lot_number TEXT, quantity DECIMAL, expiry_date DATE)

-- Get FEFO lots
get_fefo_lots(
  drug_id INT,
  location_id INT,
  quantity_needed DECIMAL
) RETURNS TABLE(lot_id INT, lot_number TEXT, quantity DECIMAL, expiry_date DATE)

-- Update inventory from receipt
update_inventory_from_receipt(
  receipt_id INT
) RETURNS BOOLEAN
```

**Performance Requirements:**
- Budget availability check: <500ms
- Lot selection (FIFO/FEFO): <200ms
- Inventory update: <100ms
- All functions use prepared statements

**Acceptance Criteria:**
- Functions handle edge cases (zero quantity, null inputs)
- Functions roll back on error
- Functions log execution in audit trail
- Unit tests cover 100% of function logic

### 3.4 Database Views (TR-DB-004)

**Reporting Views (11 implemented):**

**Ministry Export Views (5 views):**
```sql
export_druglist          -- 11 fields for drug catalog
export_purchase_plan     -- 20 fields for purchase planning
export_receipt           -- 22 fields for goods receiving
export_distribution      -- 11 fields for distribution
export_inventory         -- 15 fields for stock status
```

**Operational Views (6 views):**
```sql
budget_status_current         -- Real-time budget by department
expiring_drugs                -- Drugs expiring in 30/60/90 days
low_stock_items               -- Items below reorder point
current_stock_summary         -- Stock by location
budget_reservations_active    -- Active reservations
purchase_order_status         -- PO tracking
```

**View Requirements:**
- Views use efficient joins (indexed columns)
- Complex views use materialized views
- Materialized views refresh every 1 hour
- Views respect soft-delete filters

**Acceptance Criteria:**
- View queries return in <1 second for 10,000 rows
- Ministry export views pass validation 100%
- Views include helpful column aliases

### 3.5 Enums and Types (TR-DB-005)

**Enums Implemented (22 enums):**
- `UserRole` - 6 roles (ADMIN, PHARMACIST, PROCUREMENT_OFFICER, DEPARTMENT_STAFF, DIRECTOR, AUDITOR)
- `PrStatus` - 8 states (DRAFT, SUBMITTED, BUDGET_CHECK, BUDGET_RESERVED, APPROVED, REJECTED, CANCELLED, PO_CREATED)
- `PoStatus` - 9 states (DRAFT, PENDING_APPROVAL, APPROVED, SENT, PARTIAL_RECEIVED, FULLY_RECEIVED, COMPLETED, CANCELLED, CLOSED)
- `ReceiptStatus` - 4 states (DRAFT, INSPECTING, APPROVED, POSTED)
- `ReservationStatus` - 4 states (ACTIVE, COMMITTED, RELEASED, EXPIRED)
- `TransactionType` - 5 types (RECEIVE, ISSUE, TRANSFER, ADJUST, RETURN)
- `DistributionStatus` - 4 states (DRAFT, PENDING, APPROVED, FULFILLED)
- `ReturnStatus` - 4 states (DRAFT, INSPECTING, APPROVED, COMPLETED)
- `NlemStatus` - 2 values (E=Essential, N=Non-essential)
- `DrugStatus` - 4 values (1=Active, 2=Inactive, 3=Discontinued, 4=Out of stock)
- `ProductCategory` - 5 values (1=Drug, 2=Supply, 3=Equipment, 4=Chemical, 5=Other)
- `DeptConsumptionGroup` - 9 values (1=OPD, 2=IPD, 3=Emergency, etc.)
- 10 more enums for various classifications

**Enum Requirements:**
- All enums defined in Prisma schema
- Enum values match ministry standards
- Enum changes require migration
- No magic strings in code

**Acceptance Criteria:**
- 100% type safety (no string literals)
- Database constraints enforce enum values
- API returns enum values as strings
- Frontend displays localized enum labels

---

## 4. Backend API Technical Requirements

### 4.1 API Architecture (TR-API-001)

**Framework:** Express.js or Fastify
**API Style:** RESTful JSON API
**API Version:** v1 (URL prefix: `/api/v1`)

**Directory Structure:**
```
src/
├── index.ts                 # App entry point
├── lib/
│   ├── prisma.ts           # Prisma client singleton
│   ├── jwt.ts              # JWT utilities
│   └── logger.ts           # Winston logger
├── middleware/
│   ├── auth.ts             # JWT authentication
│   ├── rbac.ts             # Role-based access control
│   ├── validate.ts         # Zod validation
│   ├── error.ts            # Error handling
│   └── logger.ts           # Request logging
├── routes/
│   ├── auth.routes.ts      # /api/v1/auth
│   ├── drugs.routes.ts     # /api/v1/drugs
│   ├── pr.routes.ts        # /api/v1/purchase-requests
│   ├── po.routes.ts        # /api/v1/purchase-orders
│   ├── inventory.routes.ts # /api/v1/inventory
│   ├── distribution.routes.ts
│   └── reports.routes.ts
├── controllers/
│   └── [entity].controller.ts
├── services/
│   └── [entity].service.ts
├── validators/
│   └── [entity].validator.ts
└── types/
    └── [entity].types.ts
```

**Layered Architecture:**
- **Routes**: HTTP routing and request parsing
- **Middleware**: Authentication, validation, error handling
- **Controllers**: Request/response handling
- **Services**: Business logic orchestration
- **Prisma Client**: Database access

**Acceptance Criteria:**
- Clear separation of concerns
- Dependency injection for testability
- No business logic in controllers
- All database access via Prisma

### 4.2 Authentication (TR-API-002)

**JWT Implementation:**
```typescript
interface JWTPayload {
  userId: number;
  username: string;
  role: UserRole;
  departmentId: number | null;
  iat: number;  // Issued at
  exp: number;  // Expiry
}
```

**Token Configuration:**
- Algorithm: RS256 (asymmetric)
- Access token expiry: 1 hour
- Refresh token expiry: 7 days
- Token storage: httpOnly secure cookie (no localStorage)

**Authentication Flow:**
```
POST /api/v1/auth/login
  ← { username, password }
  → { accessToken, refreshToken, user }

POST /api/v1/auth/refresh
  ← { refreshToken }
  → { accessToken }

POST /api/v1/auth/logout
  → Invalidate refresh token
```

**Password Security:**
- Hashing: bcrypt with cost factor 12
- Minimum length: 8 characters
- Complexity: 1 uppercase, 1 lowercase, 1 number, 1 special char
- Lockout: 5 failed attempts → 15 min lockout

**Acceptance Criteria:**
- All API endpoints require authentication (except /auth/login)
- Expired tokens return 401 Unauthorized
- Failed logins are rate-limited
- Passwords never logged or returned in API

### 4.3 Authorization (TR-API-003)

**Role-Based Access Control (RBAC):**

| Role | Permissions |
|------|-------------|
| **ADMIN** | Full access to all resources |
| **PHARMACIST** | Manage drugs, inventory, distributions, returns |
| **PROCUREMENT_OFFICER** | Manage PRs, POs, receipts, vendors |
| **DEPARTMENT_STAFF** | Create distribution requests, view own department data |
| **DIRECTOR** | Approve PRs/POs, view all reports |
| **AUDITOR** | Read-only access to all data + audit logs |

**Authorization Middleware:**
```typescript
// Require specific role
requireRole(['ADMIN', 'PHARMACIST'])

// Require own resource or admin
requireOwnershipOrAdmin(resourceId)

// Require department access
requireDepartmentAccess(departmentId)
```

**Acceptance Criteria:**
- Unauthorized access returns 403 Forbidden
- Role checks happen before business logic
- Department-level data isolation enforced
- Audit logs record authorization failures

### 4.4 Request Validation (TR-API-004)

**Validation Library:** Zod

**Validation Strategy:**
- All request bodies validated with Zod schemas
- All query parameters validated
- All path parameters validated
- Validation errors return 400 Bad Request

**Example Validator:**
```typescript
// validators/pr.validator.ts
import { z } from 'zod';

export const createPrSchema = z.object({
  body: z.object({
    department_id: z.number().int().positive(),
    budget_type_id: z.number().int().positive(),
    fiscal_year: z.number().int().min(2020).max(2100),
    quarter: z.number().int().min(1).max(4),
    justification: z.string().min(10).max(500),
    items: z.array(z.object({
      drug_id: z.number().int().positive(),
      quantity: z.number().positive(),
      unit_price: z.number().positive(),
    })).min(1).max(100),
  }),
});

// Usage in route
router.post('/purchase-requests',
  authenticate,
  validate(createPrSchema),
  prController.create
);
```

**Acceptance Criteria:**
- Invalid requests return helpful error messages
- Validation happens before database access
- Zod schemas co-located with TypeScript types
- Validation errors include field-level details

### 4.5 Error Handling (TR-API-005)

**Error Response Format:**
```typescript
interface ErrorResponse {
  error: {
    code: string;           // Machine-readable error code
    message: string;        // Human-readable message
    details?: any;          // Additional error details
    timestamp: string;      // ISO 8601 timestamp
    path: string;           // Request path
    requestId: string;      // Trace ID for debugging
  }
}
```

**Error Types:**
- 400 Bad Request: Validation errors
- 401 Unauthorized: Authentication failure
- 403 Forbidden: Authorization failure
- 404 Not Found: Resource not found
- 409 Conflict: Business rule violation (e.g., budget exceeded)
- 422 Unprocessable Entity: Business logic error
- 500 Internal Server Error: Unexpected errors

**Error Handling Middleware:**
```typescript
app.use((err, req, res, next) => {
  logger.error('Error:', { err, req: { method: req.method, url: req.url } });

  if (err instanceof ZodError) {
    return res.status(400).json({ error: formatZodError(err) });
  }

  if (err instanceof PrismaClientKnownRequestError) {
    return res.status(409).json({ error: formatPrismaError(err) });
  }

  return res.status(500).json({
    error: {
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred',
      timestamp: new Date().toISOString(),
      path: req.path,
      requestId: req.id,
    }
  });
});
```

**Acceptance Criteria:**
- All errors return consistent JSON format
- Stack traces only in development mode
- Errors are logged with context
- Request IDs enable error tracing

### 4.6 API Endpoints (TR-API-006)

**Required Endpoints:**

**Authentication:**
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/logout` - User logout
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/auth/me` - Get current user info

**Drugs:**
- `GET /api/v1/drugs` - List drugs (with search, pagination)
- `GET /api/v1/drugs/:id` - Get drug details
- `POST /api/v1/drugs` - Create drug (PHARMACIST, ADMIN)
- `PUT /api/v1/drugs/:id` - Update drug (PHARMACIST, ADMIN)
- `DELETE /api/v1/drugs/:id` - Delete drug (ADMIN only)
- `GET /api/v1/drugs/:id/lots` - Get drug lots
- `GET /api/v1/drugs/search` - Search drugs (autocomplete)

**Purchase Requests:**
- `GET /api/v1/purchase-requests` - List PRs (filtered by role)
- `GET /api/v1/purchase-requests/:id` - Get PR details
- `POST /api/v1/purchase-requests` - Create PR
- `PUT /api/v1/purchase-requests/:id` - Update PR (DRAFT only)
- `POST /api/v1/purchase-requests/:id/submit` - Submit PR for approval
- `POST /api/v1/purchase-requests/:id/approve` - Approve PR (DIRECTOR)
- `POST /api/v1/purchase-requests/:id/reject` - Reject PR (DIRECTOR)
- `POST /api/v1/purchase-requests/:id/cancel` - Cancel PR
- `GET /api/v1/purchase-requests/:id/budget-check` - Check budget availability

**Purchase Orders:**
- `GET /api/v1/purchase-orders` - List POs
- `GET /api/v1/purchase-orders/:id` - Get PO details
- `POST /api/v1/purchase-orders/:id/approve` - Approve PO
- `POST /api/v1/purchase-orders/:id/send` - Send PO to vendor
- `GET /api/v1/purchase-orders/:id/pdf` - Generate PO PDF

**Inventory:**
- `GET /api/v1/inventory` - List inventory (by location)
- `GET /api/v1/inventory/:drug_id/locations/:location_id` - Get stock level
- `GET /api/v1/inventory/low-stock` - Low stock items
- `GET /api/v1/inventory/expiring` - Expiring drugs
- `POST /api/v1/inventory/adjust` - Stock adjustment (PHARMACIST)
- `GET /api/v1/inventory/transactions` - Transaction history

**Distributions:**
- `GET /api/v1/distributions` - List distribution requests
- `GET /api/v1/distributions/:id` - Get distribution details
- `POST /api/v1/distributions` - Create distribution request
- `POST /api/v1/distributions/:id/approve` - Approve distribution
- `POST /api/v1/distributions/:id/fulfill` - Fulfill distribution

**Reports:**
- `GET /api/v1/reports/budget-status` - Budget status report
- `GET /api/v1/reports/ministry/druglist` - Ministry DRUGLIST export
- `GET /api/v1/reports/ministry/receipt` - Ministry RECEIPT export
- `GET /api/v1/reports/procurement-summary` - Procurement summary
- `GET /api/v1/reports/inventory-valuation` - Inventory valuation

**API Response Format:**
```typescript
// Success response
{
  data: T,              // Response data
  meta?: {              // Optional metadata
    total: number,      // Total records (for pagination)
    page: number,       // Current page
    limit: number,      // Records per page
  }
}

// List response with pagination
GET /api/v1/drugs?page=2&limit=50&search=paracetamol
{
  data: Drug[],
  meta: {
    total: 1169,
    page: 2,
    limit: 50,
    totalPages: 24
  }
}
```

**Acceptance Criteria:**
- All endpoints documented with OpenAPI/Swagger
- Response times <500ms for simple queries
- Pagination for all list endpoints
- Search supports partial matching (ILIKE)
- Filters support common use cases

### 4.7 Performance (TR-API-007)

**Requirements:**
- API response time <500ms (p95)
- Database query time <200ms (p95)
- Support 100 concurrent requests
- Throughput: 1,000 requests per minute
- Connection pooling with 10-20 connections

**Optimization Strategies:**
- Database indexes on foreign keys and search fields
- Prisma query optimization (select only needed fields)
- Response caching for read-heavy endpoints (Redis)
- Pagination limits (max 100 records per page)
- Async/await for non-blocking I/O

**Monitoring:**
- Log slow queries (>500ms)
- Track API endpoint latencies
- Monitor database connection pool
- Alert on error rate >1%

**Acceptance Criteria:**
- Load testing confirms 100 concurrent users
- Slow queries are identified and optimized
- API latency dashboard available
- Performance regressions caught in CI/CD

### 4.8 Logging (TR-API-008)

**Logging Library:** Winston

**Log Levels:**
- **error**: Errors requiring immediate attention
- **warn**: Warning conditions
- **info**: General informational messages
- **debug**: Debug-level messages (development only)

**Log Format:**
```json
{
  "timestamp": "2025-01-22T10:30:45.123Z",
  "level": "info",
  "message": "PR created successfully",
  "context": {
    "userId": 123,
    "prId": 456,
    "department": "Pharmacy"
  },
  "requestId": "req-abc-123",
  "duration": 234
}
```

**What to Log:**
- All API requests (method, path, user, duration)
- Authentication events (login, logout, failed attempts)
- Authorization failures
- Business logic errors
- Database query errors
- Slow queries (>500ms)

**What NOT to Log:**
- Passwords or tokens
- Personal sensitive data
- Full request bodies (only IDs)

**Acceptance Criteria:**
- Logs are JSON formatted for parsing
- Logs include request ID for tracing
- Log rotation: 10 files, 10MB each
- Logs retained for 90 days

---

## 5. Frontend Technical Requirements

### 5.1 Frontend Architecture (TR-FE-001)

**Framework:** React 18.x with TypeScript
**Build Tool:** Vite
**State Management:** TanStack Query + Zustand (global state)
**Routing:** React Router v6
**UI Library:** shadcn/ui + TailwindCSS

**Directory Structure:**
```
src/
├── main.tsx                # App entry point
├── App.tsx                 # Root component
├── lib/
│   ├── api.ts             # API client (Axios)
│   ├── auth.ts            # Auth utilities
│   └── queryClient.ts     # TanStack Query config
├── hooks/
│   ├── useAuth.ts         # Authentication hook
│   ├── useDrugs.ts        # Drug queries
│   ├── usePR.ts           # PR queries/mutations
│   └── useInventory.ts    # Inventory queries
├── components/
│   ├── ui/                # shadcn/ui components
│   ├── layout/
│   │   ├── Header.tsx
│   │   ├── Sidebar.tsx
│   │   └── Layout.tsx
│   ├── common/
│   │   ├── DataTable.tsx
│   │   ├── SearchInput.tsx
│   │   ├── Pagination.tsx
│   │   └── StatusBadge.tsx
│   └── [module]/
│       ├── DrugList.tsx
│       ├── DrugForm.tsx
│       └── DrugDetail.tsx
├── pages/
│   ├── LoginPage.tsx
│   ├── DashboardPage.tsx
│   ├── drugs/
│   │   ├── DrugListPage.tsx
│   │   ├── DrugDetailPage.tsx
│   │   └── DrugFormPage.tsx
│   ├── purchase-requests/
│   └── inventory/
├── types/
│   └── api.types.ts       # API response types
└── utils/
    ├── formatters.ts
    └── validators.ts
```

**Acceptance Criteria:**
- Component reusability >70%
- No prop drilling (use context or state management)
- Consistent file naming convention
- Clear separation of UI and business logic

### 5.2 Data Fetching (TR-FE-002)

**Library:** TanStack Query (React Query)

**Query Configuration:**
```typescript
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000,     // 5 minutes
      cacheTime: 10 * 60 * 1000,    // 10 minutes
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
});
```

**Example Hook:**
```typescript
// hooks/useDrugs.ts
export function useDrugs(params?: DrugSearchParams) {
  return useQuery({
    queryKey: ['drugs', params],
    queryFn: () => api.get('/api/v1/drugs', { params }),
    staleTime: 5 * 60 * 1000,
  });
}

export function useCreateDrug() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreateDrugInput) => api.post('/api/v1/drugs', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['drugs'] });
    },
  });
}
```

**Acceptance Criteria:**
- All API calls use TanStack Query
- Loading states displayed for all queries
- Error boundaries catch query errors
- Cache invalidation on mutations

### 5.3 Forms (TR-FE-003)

**Library:** React Hook Form + Zod

**Form Implementation:**
```typescript
const prFormSchema = z.object({
  department_id: z.number(),
  budget_type_id: z.number(),
  fiscal_year: z.number(),
  quarter: z.number().min(1).max(4),
  justification: z.string().min(10),
  items: z.array(z.object({
    drug_id: z.number(),
    quantity: z.number().positive(),
    unit_price: z.number().positive(),
  })).min(1),
});

type PRFormData = z.infer<typeof prFormSchema>;

function PRForm() {
  const { register, handleSubmit, formState: { errors } } = useForm<PRFormData>({
    resolver: zodResolver(prFormSchema),
  });

  const createPR = useCreatePR();

  const onSubmit = (data: PRFormData) => {
    createPR.mutate(data);
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* Form fields */}
    </form>
  );
}
```

**Form Requirements:**
- Client-side validation with Zod
- Field-level error messages
- Disabled submit during API call
- Success/error notifications
- Auto-save for long forms (every 30 seconds)

**Acceptance Criteria:**
- All forms use React Hook Form
- Validation errors displayed clearly
- Forms are accessible (ARIA labels)
- Loading states during submission

### 5.4 UI Components (TR-FE-004)

**Component Library:** shadcn/ui + TailwindCSS

**Core Components:**
- Button, Input, Select, Checkbox, Radio
- Dialog (Modal), Alert, Toast (Notifications)
- Card, Table, Badge, Tabs
- DatePicker, Autocomplete, Combobox
- DataTable (with sorting, filtering, pagination)

**Styling:**
- TailwindCSS utility classes
- Custom theme with hospital branding
- Dark mode support (optional)
- Responsive design (mobile-first)

**Acceptance Criteria:**
- Consistent design system
- Accessible components (WCAG 2.1 AA)
- Responsive on mobile (≥375px width)
- Loading skeletons for async content

### 5.5 Internationalization (TR-FE-005)

**Primary Language:** Thai
**Secondary Language:** English

**Library:** react-i18next

**Translation Structure:**
```typescript
// locales/th.json
{
  "common": {
    "save": "บันทึก",
    "cancel": "ยกเลิก",
    "search": "ค้นหา"
  },
  "drug": {
    "title": "รายการยา",
    "add": "เพิ่มยา",
    "edit": "แก้ไขยา"
  },
  "validation": {
    "required": "กรุณากรอกข้อมูล",
    "minLength": "ต้องมีอย่างน้อย {{count}} ตัวอักษร"
  }
}
```

**Acceptance Criteria:**
- All UI text is translatable
- Language switcher in header
- Date/number formatting locale-aware
- RTL support not required

### 5.6 Performance (TR-FE-006)

**Requirements:**
- First Contentful Paint (FCP) <1.5 seconds
- Largest Contentful Paint (LCP) <2.5 seconds
- Time to Interactive (TTI) <3.5 seconds
- Cumulative Layout Shift (CLS) <0.1
- Bundle size <500KB gzipped

**Optimization:**
- Code splitting (React.lazy)
- Image optimization (WebP format)
- Tree shaking (remove unused code)
- Memoization (React.memo, useMemo)
- Virtual scrolling for long lists (TanStack Virtual)

**Acceptance Criteria:**
- Lighthouse score >90
- Bundle analysis shows no large dependencies
- Images are lazy-loaded
- List virtualization for >100 items

### 5.7 Testing (TR-FE-007)

**Testing Stack:**
- Unit: Vitest + React Testing Library
- E2E: Playwright

**Test Coverage:**
- Critical user flows: 100%
- Components: 80%
- Utilities: 90%

**Example Test:**
```typescript
// components/DrugList.test.tsx
describe('DrugList', () => {
  it('displays drug list', async () => {
    const { getByText } = render(<DrugList />);
    await waitFor(() => {
      expect(getByText('Paracetamol')).toBeInTheDocument();
    });
  });

  it('handles search', async () => {
    const { getByPlaceholderText } = render(<DrugList />);
    const search = getByPlaceholderText('Search drugs...');
    fireEvent.change(search, { target: { value: 'para' } });
    await waitFor(() => {
      expect(mockApiCall).toHaveBeenCalledWith(expect.objectContaining({
        search: 'para'
      }));
    });
  });
});
```

**Acceptance Criteria:**
- All PRs require passing tests
- E2E tests cover critical workflows
- CI runs tests on every commit

---

## 6. Infrastructure Requirements

### 6.1 Development Environment (TR-INF-001)

**Docker Compose Setup:**
```yaml
services:
  db:
    image: postgres:15-alpine
    ports: ["5434:5432"]
    volumes:
      - postgres-data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: invs_user
      POSTGRES_PASSWORD: invs123
      POSTGRES_DB: invs_modern

  pgadmin:
    image: dpage/pgadmin4
    ports: ["8081:80"]

  api:  # Future
    build: .
    ports: ["3000:3000"]
    depends_on: [db]

  frontend:  # Future
    build: ./frontend
    ports: ["5173:5173"]
```

**Developer Machine Requirements:**
- OS: macOS, Linux, or Windows with WSL2
- CPU: 4 cores minimum
- RAM: 8GB minimum
- Storage: 20GB free space
- Node.js: v20.x LTS
- Docker: v24.x
- Git: v2.x

**Acceptance Criteria:**
- New developer setup in <30 minutes
- README has step-by-step setup guide
- Docker containers start without errors
- `npm run dev` works after setup

### 6.2 CI/CD Pipeline (TR-INF-002)

**CI Tool:** GitHub Actions

**Pipeline Stages:**
```yaml
stages:
  - lint      # ESLint + Prettier
  - test      # Unit tests + E2E tests
  - build     # TypeScript compilation
  - deploy    # Deploy to staging/production
```

**Checks Required:**
- All tests pass
- Lint errors: 0
- Test coverage >80%
- Build succeeds
- No security vulnerabilities (npm audit)

**Deployment:**
- Push to `develop` → Deploy to staging
- Push to `main` → Deploy to production (manual approval)

**Acceptance Criteria:**
- CI runs on every PR
- Failed checks block merge
- Deployment takes <10 minutes
- Rollback capability in <5 minutes

### 6.3 Monitoring (TR-INF-003)

**Application Monitoring:**
- Winston logs → File system
- Error tracking: Sentry (optional)
- API metrics: Prometheus (optional)
- Uptime monitoring: UptimeRobot (optional)

**Database Monitoring:**
- PostgreSQL logs
- Slow query log (>500ms)
- Connection pool metrics
- Database size growth

**Alerts:**
- API error rate >1%
- Database connection failures
- Disk space <10GB free
- CPU usage >80% for 5 minutes

**Acceptance Criteria:**
- Logs are searchable
- Alerts sent to IT team within 5 minutes
- Dashboards show key metrics

### 6.4 Backup and Recovery (TR-INF-004)

**Database Backup:**
- Full backup: Daily at 02:00 AM
- Incremental backup: Every 4 hours
- Retention: 30 days online, 1 year archived
- Backup location: Network storage + cloud backup

**Backup Script:**
```bash
#!/bin/bash
# Daily full backup
pg_dump -U invs_user -h localhost -p 5434 invs_modern | \
  gzip > /backups/invs_$(date +%Y%m%d).sql.gz

# Keep last 30 days
find /backups -name "invs_*.sql.gz" -mtime +30 -delete
```

**Recovery Testing:**
- Monthly restore test
- RTO (Recovery Time Objective): <4 hours
- RPO (Recovery Point Objective): <1 hour

**Acceptance Criteria:**
- Backups run without failures
- Restore tested successfully monthly
- Backup files verified (not corrupted)
- Off-site backup confirmed

---

## 7. Security Requirements

### 7.1 Authentication Security (TR-SEC-001)

**Requirements:**
- JWT tokens with RS256 algorithm
- Access tokens: 1 hour expiry
- Refresh tokens: 7 days expiry, single use
- Token blacklist for logout
- HTTPS only (TLS 1.3)
- httpOnly secure cookies

**Password Policy:**
- Minimum 8 characters
- Complexity: 1 uppercase, 1 lowercase, 1 number, 1 special
- bcrypt hashing (cost factor 12)
- Password history (last 5 passwords)
- Password expiry: 90 days (for privileged users)

**Acceptance Criteria:**
- Tokens cannot be forged
- Expired tokens rejected
- Passwords never transmitted in plain text
- Session hijacking prevented

### 7.2 Authorization Security (TR-SEC-002)

**Requirements:**
- Role-based access control (RBAC)
- Principle of least privilege
- Department-level data isolation
- Audit trail for all access attempts

**Implementation:**
- Check authorization on every request
- Verify resource ownership
- Log failed authorization attempts
- Rate limit by user (100 requests/minute)

**Acceptance Criteria:**
- Users cannot access unauthorized resources
- SQL injection prevented (Prisma parameterized queries)
- IDOR (Insecure Direct Object Reference) prevented
- Authorization tests pass

### 7.3 Data Security (TR-SEC-003)

**Encryption:**
- In transit: TLS 1.3
- At rest: Database encryption (LUKS or database-level)
- Sensitive fields: Additional encryption (AES-256)

**Data Masking:**
- Logs mask sensitive data (passwords, tokens)
- Non-production environments use anonymized data
- PII (Personal Identifiable Information) handling per PDPA

**Acceptance Criteria:**
- All traffic over HTTPS
- Database backups encrypted
- Sensitive data not logged
- Data breach risk minimized

### 7.4 API Security (TR-SEC-004)

**Requirements:**
- Input validation (Zod)
- Output encoding (prevent XSS)
- CSRF protection (tokens)
- CORS configuration (whitelist origins)
- Rate limiting (100 req/min per user, 1000 req/min global)
- SQL injection prevention (Prisma ORM)

**Security Headers:**
```
Content-Security-Policy: default-src 'self'
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Strict-Transport-Security: max-age=31536000
```

**Acceptance Criteria:**
- OWASP Top 10 vulnerabilities addressed
- Security headers present
- Penetration test shows no critical issues
- Rate limiting prevents DoS

---

## 8. Integration Requirements

### 8.1 HIS Integration (TR-INT-001)

**Integration Point:** Hospital Information System (HIS)

**Data Exchange:**
- **From HIS to INVS:**
  - Patient prescriptions (for distribution)
  - Department master data
  - User authentication (SSO)
- **From INVS to HIS:**
  - Drug dispensing records
  - Drug availability status
  - Drug pricing information

**Integration Method:**
- Primary: REST API
- Fallback: HL7 v2.x messages
- Frequency: Real-time for prescriptions, daily for master data

**Acceptance Criteria:**
- 99% message delivery success
- <5 seconds latency for prescription sync
- Error handling and retry logic
- Data reconciliation daily

### 8.2 e-GP Integration (TR-INT-002)

**Integration Point:** e-Government Procurement (e-GP) system

**Data Exchange:**
- **To e-GP:**
  - Purchase plans (annual)
  - Purchase orders (>500,000 THB)
- **From e-GP:**
  - Tender results
  - Approved vendor list

**Integration Method:**
- API: REST or SOAP (per e-GP specification)
- File: CSV upload/download
- Frequency: As needed

**Acceptance Criteria:**
- Successful data submission to e-GP
- Compliance with e-GP data format
- Audit trail of submissions

### 8.3 Ministry Reporting (TR-INT-003)

**Integration Point:** Ministry of Public Health reporting portal

**Reports:**
- DRUGLIST: Drug catalog (quarterly)
- PURCHASEPLAN: Purchase planning (annual)
- RECEIPT: Goods receiving (monthly)
- DISTRIBUTION: Distribution records (monthly)
- INVENTORY: Stock status (monthly)

**Format:** CSV with ministry-specified columns

**Acceptance Criteria:**
- 100% validation pass rate
- All 79 required fields populated
- Timely submission (within deadlines)

---

## 9. Testing Requirements

### 9.1 Unit Testing (TR-TEST-001)

**Framework:** Vitest (backend), Jest/Vitest (frontend)
**Coverage Target:** 80% overall

**Test Coverage:**
- Database functions: 100%
- API services: 80%
- API controllers: 70%
- React components: 80%
- Utility functions: 90%

**Example Test:**
```typescript
describe('Budget Service', () => {
  it('checks budget availability correctly', async () => {
    const result = await budgetService.checkAvailability({
      fiscalYear: 2025,
      budgetTypeId: 1,
      departmentId: 1,
      amount: 100000,
      quarter: 1,
    });
    expect(result.available).toBe(true);
  });
});
```

**Acceptance Criteria:**
- All new code has unit tests
- Tests run in <30 seconds
- Tests are deterministic (no flaky tests)

### 9.2 Integration Testing (TR-TEST-002)

**Scope:** API endpoints with database

**Test Database:**
- Separate test database
- Reset before each test suite
- Seed with test data

**Example Test:**
```typescript
describe('POST /api/v1/purchase-requests', () => {
  it('creates PR successfully', async () => {
    const response = await request(app)
      .post('/api/v1/purchase-requests')
      .set('Authorization', `Bearer ${testToken}`)
      .send(prData);

    expect(response.status).toBe(201);
    expect(response.body.data.status).toBe('DRAFT');
  });

  it('rejects PR without authentication', async () => {
    const response = await request(app)
      .post('/api/v1/purchase-requests')
      .send(prData);

    expect(response.status).toBe(401);
  });
});
```

**Acceptance Criteria:**
- Critical endpoints have integration tests
- Tests cover happy path + error cases
- Tests run in <2 minutes

### 9.3 E2E Testing (TR-TEST-003)

**Framework:** Playwright

**Critical Flows:**
1. User login → Create PR → Submit → Approve → Create PO
2. Receive goods → Inspect → Post to inventory
3. Create distribution request → Approve → Fulfill
4. View budget status → Check available budget
5. Generate ministry report → Export CSV

**Test Environment:**
- Staging environment
- Test data reset daily
- Run nightly

**Acceptance Criteria:**
- All critical flows have E2E tests
- Tests run in <10 minutes
- Tests pass consistently (>95% success rate)

### 9.4 Performance Testing (TR-TEST-004)

**Tool:** k6 or Apache JMeter

**Scenarios:**
- Baseline: 10 concurrent users, 1 hour
- Load: 100 concurrent users, 30 minutes
- Stress: 200 concurrent users, 10 minutes
- Spike: 0→100→0 users over 5 minutes

**Performance Targets:**
- API response time (p95): <500ms
- Database query time (p95): <200ms
- Error rate: <1%
- Throughput: >1,000 requests/minute

**Acceptance Criteria:**
- Performance tests run weekly
- Regressions detected and fixed
- System scales to 100 concurrent users

### 9.5 Security Testing (TR-TEST-005)

**Automated Security Scanning:**
- Dependency vulnerabilities: `npm audit`
- SAST: SonarQube or similar
- Container scanning: Trivy

**Manual Security Testing:**
- Penetration testing: Annual
- Code review: Every PR
- Security checklist: Pre-deployment

**Acceptance Criteria:**
- No critical vulnerabilities
- High/medium vulnerabilities fixed within 30 days
- Security review passed

---

## 10. Documentation Requirements

### 10.1 Technical Documentation (TR-DOC-001)

**Required Documents:**
- ✅ Business Requirements Document (BRD.md)
- ✅ Technical Requirements Document (TRD.md) [This document]
- ✅ Database Design Document (DATABASE_DESIGN.md)
- ✅ System Architecture (SYSTEM_ARCHITECTURE.md)
- API Documentation (OpenAPI/Swagger)
- Deployment Guide
- Operations Manual

**Acceptance Criteria:**
- All documents versioned in Git
- Documents reviewed quarterly
- Documents updated with changes

### 10.2 API Documentation (TR-DOC-002)

**Format:** OpenAPI 3.0 (Swagger)

**Required Sections:**
- Authentication
- All endpoints with examples
- Request/response schemas
- Error codes and messages
- Rate limiting information

**Tools:**
- Generate from code: `@nestjs/swagger` or `tsoa`
- Interactive docs: Swagger UI
- API testing: Postman collection

**Acceptance Criteria:**
- API docs always in sync with code
- Examples are working and tested
- Interactive docs available at `/api/docs`

### 10.3 Code Documentation (TR-DOC-003)

**Standards:**
- JSDoc comments for all public functions
- README in each module directory
- Code examples in comments
- Complex logic explained

**Example:**
```typescript
/**
 * Checks if sufficient budget is available for a purchase request.
 *
 * @param fiscalYear - The fiscal year (e.g., 2025)
 * @param budgetTypeId - ID of budget type (1-6)
 * @param departmentId - ID of requesting department
 * @param amount - Requested amount in THB
 * @param quarter - Quarter (1-4)
 * @returns Promise resolving to budget availability result
 *
 * @throws {PrismaClientKnownRequestError} If database query fails
 * @throws {BusinessRuleError} If budget allocation not found
 *
 * @example
 * const result = await checkBudgetAvailability(2025, 1, 10, 100000, 1);
 * if (result.available) {
 *   // Proceed with PR creation
 * }
 */
async function checkBudgetAvailability(...) {
  // Implementation
}
```

**Acceptance Criteria:**
- All exported functions documented
- Complex algorithms explained
- API contracts clear

### 10.4 User Documentation (TR-DOC-004)

**Required:**
- User Manual (Thai + English)
- Quick Start Guide
- Video tutorials (screencasts)
- FAQ
- Training materials

**Delivery:**
- Online help system in app
- Downloadable PDF
- Video hosting (YouTube)

**Acceptance Criteria:**
- Non-technical users can follow guides
- Videos <5 minutes each
- Documentation covers all features

---

## 11. Acceptance Criteria

### 11.1 Database Acceptance

- ✅ 52 tables created and seeded
- ✅ 22 enums defined
- ✅ 11 views created
- ✅ 12 functions implemented
- ✅ 3,152 records migrated
- ✅ 100% ministry compliance (79/79 fields)
- ⏳ Backup/restore tested
- ⏳ Performance benchmarks met

### 11.2 Backend API Acceptance

- ⏳ All required endpoints implemented
- ⏳ Authentication and authorization working
- ⏳ API documentation complete
- ⏳ Unit test coverage >80%
- ⏳ Integration tests pass
- ⏳ Performance targets met
- ⏳ Security review passed

### 11.3 Frontend Acceptance

- ⏳ All pages implemented
- ⏳ Responsive design (mobile + desktop)
- ⏳ Thai language support
- ⏳ Forms validated
- ⏳ Loading states displayed
- ⏳ Error handling graceful
- ⏳ Lighthouse score >90

### 11.4 Integration Acceptance

- ⏳ HIS integration working
- ⏳ e-GP integration working
- ⏳ Ministry reports generate correctly
- ⏳ Data synchronization verified

### 11.5 UAT Acceptance

- ⏳ All user stories tested
- ⏳ Critical bugs fixed
- ⏳ User feedback addressed
- ⏳ Training completed
- ⏳ User acceptance sign-off

---

## 12. Appendices

### Appendix A: Technology Decisions

| Decision | Technology | Rationale |
|----------|-----------|-----------|
| Database | PostgreSQL 15 | Hospital IT standard, ACID compliance, JSON support |
| ORM | Prisma | Type safety, great DX, auto-migrations |
| Language | TypeScript | Type safety reduces bugs, great tooling |
| Backend | Node.js + Express | JavaScript ecosystem, async I/O, large community |
| Frontend | React | Component model, large ecosystem, hospital preference |
| Validation | Zod | Type-safe validation, integrates with TypeScript |
| Testing | Vitest + Playwright | Fast, modern, great DX |

### Appendix B: Related Documents

- **BRD.md** - Business Requirements Document
- **DATABASE_DESIGN.md** - Database schema and ERD
- **SYSTEM_ARCHITECTURE.md** - System architecture overview
- **PROJECT_STATUS.md** - Current project status

### Appendix C: Change History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-01-01 | Project Team | Initial draft |
| 2.0.0 | 2025-01-10 | Project Team | Post-migration update |
| 2.4.0 | 2025-01-22 | Claude Code | Complete TRD with technical specs |

---

**End of Technical Requirements Document**
