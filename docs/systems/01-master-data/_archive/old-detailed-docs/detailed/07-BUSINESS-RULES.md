# Business Rules - Master Data Management

**Module**: 01-master-data
**System**: INVS Modern - Hospital Inventory Management System
**Version**: 2.2.0
**Last Updated**: 2025-01-22
**Purpose**: Centralized business logic, constraints, and rules for Master Data module

---

## 📖 Table of Contents

1. [Overview](#overview)
2. [Entity-Level Rules](#entity-level-rules)
3. [Cross-Entity Rules](#cross-entity-rules)
4. [Calculation Rules](#calculation-rules)
5. [Ministry Compliance Rules](#ministry-compliance-rules)
6. [Data Integrity Rules](#data-integrity-rules)
7. [Workflow Rules](#workflow-rules)
8. [Special Cases](#special-cases)

---

## Overview

This document defines business rules that govern the Master Data Management module. These rules ensure data integrity, consistency, and compliance with hospital policies and ministry regulations.

**Rule Categories**:
- **Entity Rules**: Rules specific to individual tables
- **Cross-Entity Rules**: Rules involving multiple tables
- **Calculation Rules**: Formulas and computed values
- **Ministry Compliance**: DMSIC Standards พ.ศ. 2568 requirements
- **Data Integrity**: Referential integrity and constraints
- **Workflow Rules**: State transitions and approval flows
- **Special Cases**: Edge cases and exceptional scenarios

**Rule Priority Levels**:
- 🔴 **Critical**: System cannot function without these rules
- 🟡 **Important**: Should be enforced but system can handle violations
- 🟢 **Recommended**: Best practices and guidelines

---

## Entity-Level Rules

### 1. Locations (Storage Locations)

#### BR-LOC-001: Minimum Warehouse Requirement 🔴
**Rule**: System must have at least 1 active WAREHOUSE location.
**Reason**: All drugs must be received into a warehouse before distribution.
**Validation**:
```typescript
const warehouseCount = await prisma.location.count({
  where: {
    location_type: 'WAREHOUSE',
    is_active: true
  }
});
if (warehouseCount === 0) {
  throw new Error('At least one active warehouse is required');
}
```

#### BR-LOC-002: Minimum Pharmacy Requirement 🔴
**Rule**: System must have at least 1 active PHARMACY location.
**Reason**: Drugs are dispensed from pharmacies to departments/patients.
**Validation**: Similar to BR-LOC-001 for PHARMACY type.

#### BR-LOC-003: Location Code Format 🟡
**Rule**: Location code should follow pattern `{TYPE}{NUMBER}`.
**Examples**:
- `WH001`, `WH002` - Warehouses
- `PHARM01`, `PHARM-OPD` - Pharmacies
- `ICU-2A`, `WARD3B` - Ward storage
**Validation**: Regex pattern `^[A-Z0-9-]+$` (3-20 characters)

#### BR-LOC-004: Prevent Deletion with Inventory 🔴
**Rule**: Cannot delete location if it has inventory > 0.
**Reason**: Would cause orphaned inventory records.
**Validation**:
```typescript
const inventoryCount = await prisma.inventory.count({
  where: { location_id: locationId, quantity_on_hand: { gt: 0 } }
});
if (inventoryCount > 0) {
  throw new Error('Cannot delete location with inventory');
}
```

#### BR-LOC-005: Prevent Deletion with Child Locations 🔴
**Rule**: Cannot delete parent location if it has child locations.
**Reason**: Would break hierarchical structure.
**Validation**: Check `parent_id` references before deletion.

#### BR-LOC-006: Self-Reference Prevention 🔴
**Rule**: Location cannot be its own parent (`parent_id` ≠ `id`).
**Reason**: Prevents circular hierarchy.

#### BR-LOC-007: Circular Hierarchy Prevention 🔴
**Rule**: Location hierarchy cannot create cycles (A → B → C → A).
**Reason**: Would cause infinite loops in tree traversal.
**Validation**: Traverse parent chain and detect cycles.

---

### 2. Departments (Hospital Departments)

#### BR-DEPT-001: Department Code Uniqueness 🔴
**Rule**: `dept_code` must be unique across all departments.
**Reason**: Used as business key for integration.
**Enforcement**: Database unique constraint.

#### BR-DEPT-002: Department Code Format 🟡
**Rule**: Department code should be uppercase alphanumeric (2-10 chars).
**Examples**: `PHARM`, `OPD`, `IPD-MED`, `LAB`
**Validation**: Regex `^[A-Z0-9-]{2,10}$`

#### BR-DEPT-003: Self-Reference Prevention 🔴
**Rule**: Department cannot be its own parent.
**Validation**: Same as BR-LOC-006.

#### BR-DEPT-004: Consumption Group for Drug Departments 🟡
**Rule**: Departments that consume drugs should have `consumption_group` set.
**Reason**: Required for ministry DISTRIBUTION export.
**Departments**: OPD, IPD, Emergency, OR, ICU (exclude Admin, Finance, IT)

#### BR-DEPT-005: HIS Code Integration 🟢
**Rule**: If hospital uses HIS system, `his_code` should be populated.
**Reason**: Enables data synchronization with HIS.
**Validation**: Check HIS integration settings.

---

### 3. Budget Types (Budget Type Groups)

#### BR-BTYPE-001: Type Code Uniqueness 🔴
**Rule**: `type_code` must be unique.
**Enforcement**: Database unique constraint.

#### BR-BTYPE-002: Standard Type Codes 🟡
**Rule**: Recommended to use standard prefixes:
- `OP***` - Operational budgets (OP001, OP002, OP003)
- `INV***` - Investment budgets (INV001, INV002)
- `EM***` - Emergency budgets (EM001)
**Reason**: Clear categorization and reporting.

#### BR-BTYPE-003: Prevent Deletion with Active Budgets 🔴
**Rule**: Cannot delete budget type if referenced by active budgets.
**Validation**: Check `budgets` table for references.

---

### 4. Budget Categories (Budget Categories)

#### BR-BCAT-001: Category Code Uniqueness 🔴
**Rule**: `category_code` must be unique.
**Enforcement**: Database unique constraint.

#### BR-BCAT-002: Accounting Code Format 🟡
**Rule**: If `acc_code` provided, should match hospital's chart of accounts format.
**Example**: `5001-001` (4-digit account + 3-digit sub-account)
**Validation**: Configurable regex pattern.

#### BR-BCAT-003: Prevent Deletion with Active Budgets 🔴
**Rule**: Cannot delete category if referenced by active budgets.

---

### 5. Budgets (Budget Combinations)

#### BR-BUD-001: Unique Budget Combination 🔴
**Rule**: Combination of `budget_type` + `budget_category` must be unique.
**Enforcement**: Database unique constraint.

#### BR-BUD-002: Budget Code Format 🟡
**Rule**: Budget code should follow pattern: `{TYPE_CODE}-{CATEGORY_CODE}`.
**Examples**: `OP001-CAT01`, `INV001-CAT03`
**Reason**: Clear identification and traceability.

#### BR-BUD-003: Valid Type and Category References 🔴
**Rule**: `budget_type` and `budget_category` must reference active records.
**Enforcement**: Foreign key constraints + active status check.

#### BR-BUD-004: Prevent Deletion with Allocations 🔴
**Rule**: Cannot delete budget if it has allocations in any fiscal year.
**Validation**: Check `budget_allocations` table.

---

### 6. Bank (Banks)

#### BR-BANK-001: Bank Name Required 🔴
**Rule**: Bank name cannot be empty.
**Validation**: String length > 0.

#### BR-BANK-002: Thai Bank Standard Names 🟢
**Rule**: For Thai banks, use official full names:
- "ธนาคารกรุงเทพ จำกัด (มหาชน)"
- "ธนาคารกสิกรไทย จำกัด (มหาชน)"
**Reason**: Consistency with official documents.

#### BR-BANK-003: Prevent Deletion with Company References 🔴
**Rule**: Cannot delete bank if referenced by any company.
**Validation**: Check `companies.bank_id` references.

---

### 7. Companies (Vendors & Manufacturers)

#### BR-COMP-001: Company Code Uniqueness 🔴
**Rule**: If `company_code` is provided, it must be unique.
**Enforcement**: Database unique constraint (when not null).

#### BR-COMP-002: Tax ID Validation 🟡
**Rule**: Thai tax ID must be exactly 13 digits.
**Validation**: Regex `^\d{13}$`
**Example**: `0994000158378`

#### BR-COMP-003: Tax ID Checksum Validation 🟢
**Rule**: Thai tax ID should pass MOD 11 checksum validation.
**Implementation**: Standard Thai tax ID algorithm.

#### BR-COMP-004: Company Type Consistency 🟡
**Rule**:
- VENDOR: Can have purchase orders
- MANUFACTURER: Can be linked to drugs
- BOTH: Can do both
**Validation**: Check company type before operations.

#### BR-COMP-005: Bank Account Validation 🟢
**Rule**: If bank account provided, `bank_id` must also be set.
**Validation**: Both or neither should be set.

#### BR-COMP-006: Email Format Validation 🟡
**Rule**: Email must be valid format if provided.
**Validation**: Standard email regex.

#### BR-COMP-007: Phone Format Validation 🟡
**Rule**: Phone should be Thai format (10 digits starting with 0) or international.
**Examples**: `02-123-4567`, `0812345678`, `+66-2-123-4567`

#### BR-COMP-008: Prevent Deletion with Active Contracts 🔴
**Rule**: Cannot delete company with active contracts (`status = ACTIVE`).
**Validation**: Check `contracts` table.

#### BR-COMP-009: Prevent Deletion with Active Purchase Orders 🔴
**Rule**: Cannot delete company with open purchase orders.
**Validation**: Check PO status (not CLOSED or CANCELLED).

#### BR-COMP-010: Prevent Deletion When Linked to Drugs 🔴
**Rule**: Cannot delete manufacturer if linked to any drugs.
**Reason**: Would orphan drug records.
**Validation**: Check `drugs.manufacturer_id` references.

---

### 8. Drug Generics (Generic Drugs)

#### BR-GEN-001: Working Code Uniqueness 🔴
**Rule**: `working_code` must be unique.
**Enforcement**: Database unique constraint.

#### BR-GEN-002: Working Code Format 🟡
**Rule**: Recommended format: First 3 letters of generic name + 4-digit sequential number.
**Examples**: `PAR0001` (Paracetamol), `IBU0001` (Ibuprofen), `AMX0001` (Amoxicillin)
**Validation**: Regex `^[A-Z]{3}\d{4}$`

#### BR-GEN-003: Strength Validation 🟡
**Rule**: If `strength` provided, `strength_unit` must also be provided.
**Examples**: strength=500, strength_unit='mg'
**Validation**: Both or neither should be set.

#### BR-GEN-004: Prevent Deletion with Trade Drugs 🔴
**Rule**: Cannot delete generic if it has linked trade drugs.
**Reason**: Trade drugs require generic reference for planning.
**Validation**: Check `drugs.generic_id` references.

#### BR-GEN-005: Dosage Form Validation 🟢
**Rule**: Dosage form should use standard abbreviations.
**Standards**: TAB, CAP, INJ, SOL, SUSP, CRE, OIN, etc.
**Reason**: Consistency across system.

---

### 9. Drugs (Trade Name Drugs)

#### BR-DRUG-001: Drug Code Uniqueness 🔴
**Rule**: `drug_code` must be unique (7-24 characters).
**Enforcement**: Database unique constraint.
**Examples**: `SARA500`, `TYLENOL500`, `PARACETAMOL500MG`

#### BR-DRUG-002: Standard Code Validation ⭐
**Rule**: If `standard_code` provided, must be exactly 24 characters.
**Reason**: Ministry standard for 24-digit code.
**Validation**: String length = 24.

#### BR-DRUG-003: Pack Size Validation 🔴
**Rule**: `pack_size` must be > 0.
**Reason**: Cannot have zero or negative pack size.
**Validation**: Integer > 0.

#### BR-DRUG-004: Unit Price Validation 🟡
**Rule**: `unit_price` should be ≥ 0 (can be 0 for free items).
**Validation**: Decimal ≥ 0.

#### BR-DRUG-005: Generic Recommendation 🟡
**Rule**: Trade drugs should link to a generic (`generic_id`).
**Reason**: Enables budget planning at generic level.
**Exception**: Hospital pharmaceutical products (HPP) may not have generic.

#### BR-DRUG-006: Manufacturer Requirement for Ministry ⭐
**Rule**: `manufacturer_id` required for drugs in DRUGLIST export.
**Reason**: Ministry compliance (DMSIC Standards พ.ศ. 2568).
**Validation**: Check if drug will be exported, enforce manufacturer.

#### BR-DRUG-007: NLEM Status Validation ⭐
**Rule**: `nlem_status` must be 'E' (Essential) or 'N' (Non-Essential) if set.
**Reason**: Ministry DRUGLIST export field.
**Enforcement**: Enum constraint.

#### BR-DRUG-008: Drug Status Lifecycle ⭐
**Rule**: Drug status follows lifecycle:
- `ACTIVE` (1) - Normal use
- `SUSPENDED` (2) - Temporarily stopped
- `REMOVED` (3) - Removed from use (soft delete)
- `INVESTIGATIONAL` (4) - Under review/testing
**Validation**: Enum constraint + status transition rules.

#### BR-DRUG-009: Status Change Date Requirement ⭐
**Rule**: When `drug_status` changes, update `status_changed_date`.
**Reason**: Ministry tracking requirement.
**Implementation**: Trigger or application logic.

#### BR-DRUG-010: Product Category Validation ⭐
**Rule**: `product_category` should be set for ministry compliance:
1. MODERN_REGISTERED - Modern medicine with Thai FDA registration
2. MODERN_NOT_REGISTERED - Modern medicine without Thai FDA
3. TRADITIONAL_REGISTERED - Traditional medicine with Thai FDA
4. TRADITIONAL_NOT_REGISTERED - Traditional medicine without Thai FDA
5. DANGEROUS_DRUG - Controlled substances
**Validation**: Enum constraint.

#### BR-DRUG-011: Prevent Deletion with Inventory 🔴
**Rule**: Cannot delete drug with inventory > 0.
**Reason**: Would cause orphaned inventory.
**Action**: Use `drug_status = REMOVED` instead.

#### BR-DRUG-012: Prevent Deletion with Active Contracts 🔴
**Rule**: Cannot delete drug in active contract items.
**Validation**: Check `contract_items` and contract status.

#### BR-DRUG-013: Soft Delete Recommendation 🟡
**Rule**: Instead of deleting, set `drug_status = REMOVED` and `is_active = false`.
**Reason**: Preserves historical data and audit trail.

#### BR-DRUG-014: HPP Flag Consistency 🟡
**Rule**: If `is_hpp = true`, should have either `hpp_type` or `base_product_id` set.
**Reason**: Hospital pharmaceutical products require additional metadata.

---

### 10. Contracts (Purchase Contracts)

#### BR-CONT-001: Contract Number Uniqueness 🔴
**Rule**: `contract_number` must be unique.
**Enforcement**: Database unique constraint.

#### BR-CONT-002: Contract Number Format 🟡
**Rule**: Recommended format: `CNT-{YEAR}-{NUMBER}`.
**Examples**: `CNT-2568-001`, `CNT-2568-002`
**Validation**: Regex `^CNT-\d{4}-\d{3,}$`

#### BR-CONT-003: Date Range Validation 🔴
**Rule**: `start_date` must be < `end_date`.
**Validation**: Date comparison.
**Error**: "Contract end date must be after start date"

#### BR-CONT-004: Initial Remaining Value 🔴
**Rule**: When creating contract, `remaining_value` = `total_value`.
**Validation**: On insert, set equal values.

#### BR-CONT-005: Remaining Value Tracking 🔴
**Rule**: `remaining_value` decreases when purchase orders created.
**Calculation**: `remaining_value -= PO.total_amount`
**Validation**: remaining_value ≥ 0 (cannot go negative)

#### BR-CONT-006: PO Creation Limit 🔴
**Rule**: Cannot create PO if `PO.total_amount > contract.remaining_value`.
**Error**: "Purchase order exceeds remaining contract value"
**Exception**: Allow if contract status allows over-commitment (configurable).

#### BR-CONT-007: Fiscal Year Format 🟡
**Rule**: `fiscal_year` should be Buddhist Era (BE) 4-digit year.
**Examples**: `2568`, `2569` (Thai fiscal year)
**Validation**: Regex `^\d{4}$`, value between 2500-2600.

#### BR-CONT-008: Prevent Deletion with Purchase Orders 🔴
**Rule**: Cannot delete contract if it has any purchase orders.
**Validation**: Check `purchase_orders.contract_id` references.

#### BR-CONT-009: Contract Status Transitions 🟡
**Rule**: Valid status transitions:
- DRAFT → ACTIVE (when approved)
- ACTIVE → EXPIRED (when end_date passed)
- DRAFT/ACTIVE → CANCELLED (manual cancellation)
**Validation**: State machine validation.

#### BR-CONT-010: Expired Contract Detection 🟡
**Rule**: Auto-update status to EXPIRED when current_date > end_date.
**Implementation**: Scheduled job or query-time check.

#### BR-CONT-011: Vendor Must Be Active 🟡
**Rule**: Cannot create contract with inactive vendor.
**Validation**: Check `companies.is_active = true`.

---

### 11. Contract Items (Contract Line Items)

#### BR-CITEM-001: Unique Drug Per Contract 🔴
**Rule**: Each drug can appear only once per contract.
**Enforcement**: Database unique constraint on `(contract_id, drug_id)`.

#### BR-CITEM-002: Same Drug in Multiple Contracts 🟢
**Rule**: Same drug CAN appear in different contracts (different vendors/prices).
**Use Case**: Compare prices across vendors, select best option.

#### BR-CITEM-003: Initial Quantity Remaining 🔴
**Rule**: When creating item, `quantity_remaining` = `quantity_contracted`.
**Validation**: On insert, set equal values.

#### BR-CITEM-004: Quantity Remaining Tracking 🔴
**Rule**: `quantity_remaining` decreases when PO items created.
**Calculation**: `quantity_remaining -= PO_item.quantity`
**Validation**: quantity_remaining ≥ 0

#### BR-CITEM-005: Contract Price Override 🟡
**Rule**: `unit_price` in contract item can differ from `drugs.unit_price`.
**Reason**: Contract price takes precedence for this vendor.
**Usage**: Use contract price when creating PO from this contract.

#### BR-CITEM-006: Quantity Limits Validation 🟡
**Rule**: If set, `min_order_quantity` ≤ `max_order_quantity`.
**Validation**: Comparison check.

#### BR-CITEM-007: MOQ/MAQ Enforcement 🟢
**Rule**: PO quantities should respect min/max order quantities.
**Validation**:
```typescript
if (poQty < contractItem.min_order_quantity) {
  warn('Below minimum order quantity');
}
if (poQty > contractItem.max_order_quantity) {
  warn('Exceeds maximum order quantity');
}
```

#### BR-CITEM-008: Prevent Modification After First PO 🟡
**Rule**: Cannot modify `quantity_contracted` after first PO created.
**Reason**: Would invalidate PO calculations.
**Action**: Create contract revision instead.

---

## Cross-Entity Rules

### Budget Structure Rules

#### BR-CROSS-001: Budget Three-Level Hierarchy 🔴
**Rule**: Budget structure follows: Type → Category → Budget.
**Example**:
- Type: `OP001` (Operational - Drugs)
- Category: `CAT01` (Drug expenses)
- Budget: `OP001-CAT01` (Operational drug budget)

**Enforcement**: Foreign key constraints.

#### BR-CROSS-002: Budget Deletion Cascade 🟡
**Rule**: Deleting budget type/category should fail if budgets exist.
**Alternative**: Implement soft delete with `is_active = false`.

---

### Drug Hierarchy Rules

#### BR-CROSS-003: Generic to Trade Relationship 🟢
**Rule**: One generic can have multiple trade drugs (1:N).
**Example**:
- Generic: `PAR0001` (Paracetamol 500mg)
- Trade: `SARA500`, `TYLENOL500`, `PARACETAMOL-GPO`

**Usage**: Budget planning at generic level, purchasing at trade level.

#### BR-CROSS-004: Drug to Manufacturer Relationship 🟡
**Rule**: Each drug has ONE manufacturer.
**Reason**: Ministry compliance requires manufacturer tracking.
**Exception**: HPP products manufactured by hospital itself.

---

### Contract and Drug Rules

#### BR-CROSS-005: Contract Drug Pricing 🟡
**Rule**: When creating PO from contract:
1. Use `contract_items.unit_price` (NOT `drugs.unit_price`)
2. Check `quantity_remaining` availability
3. Update both contract and contract item remaining values

**Implementation**: Transaction to ensure atomicity.

#### BR-CROSS-006: Multi-Contract Drug Selection 🟢
**Rule**: If drug appears in multiple active contracts, system should:
1. Show all available contracts
2. Allow user to select preferred vendor
3. Default to lowest price or preferred vendor

---

### Location and Department Rules

#### BR-CROSS-007: Department Default Location 🟢
**Rule**: Each department can have a default storage location.
**Usage**: Auto-populate location when distributing to department.
**Implementation**: Add optional `default_location_id` to departments (if needed).

---

## Calculation Rules

### Contract Value Calculations

#### BR-CALC-001: Contract Total Value 🔴
**Rule**: `contract.total_value` = SUM of all contract items.
**Formula**:
```
total_value = Σ(contract_items.quantity_contracted × contract_items.unit_price)
```

**Update Trigger**: Recalculate when contract items added/modified.

#### BR-CALC-002: Contract Remaining Value 🔴
**Rule**:
```
remaining_value = total_value - SUM(purchase_orders.total_amount)
```

**Update**: When PO status changes to APPROVED.

---

### Drug Pricing Calculations

#### BR-CALC-003: Pack Price Calculation 🟡
**Rule**:
```
pack_price = unit_price × pack_size
```

**Usage**: Display total pack cost to users.

---

## Ministry Compliance Rules

### DRUGLIST Export (11 fields) ⭐

#### BR-MIN-001: DRUGCODE Field (Required) 🔴
**Source**: `drugs.drug_code`
**Format**: 7-24 characters
**Validation**: Must be unique, not null.

#### BR-MIN-002: DRUGNAME Field (Required) 🔴
**Source**: `drugs.trade_name`
**Format**: Max 100 characters
**Validation**: Not null.

#### BR-MIN-003: NLEM Field (Required) ⭐
**Source**: `drugs.nlem_status`
**Values**: 'E' (Essential) or 'N' (Non-Essential)
**Validation**: Must be set for all active drugs.

#### BR-MIN-004: STATUS Field (Required) ⭐
**Source**: `drugs.drug_status`
**Values**: 1-4 (ACTIVE, SUSPENDED, REMOVED, INVESTIGATIONAL)
**Default**: 1 (ACTIVE)

#### BR-MIN-005: STATUS_CHANGE_DATE Field (Conditional) ⭐
**Source**: `drugs.status_changed_date`
**Required**: When status changes from initial value.
**Format**: Date (YYYY-MM-DD)

#### BR-MIN-006: PRODUCT_CAT Field (Required) ⭐
**Source**: `drugs.product_category`
**Values**: 1-5 (product type categories)
**Validation**: Must be set for all active drugs.

#### BR-MIN-007: TRADE_CODE Field (Optional) 🟢
**Source**: `drugs.drug_code`
**Same as**: DRUGCODE
**Usage**: Ministry reference.

#### BR-MIN-008: WORKING_CODE Field (Optional) 🟢
**Source**: `drug_generics.working_code` (via `drugs.generic_id`)
**Format**: 7 characters
**Usage**: Generic reference.

#### BR-MIN-009: MANUFACTURER Field (Required) ⭐
**Source**: `companies.company_name` (via `drugs.manufacturer_id`)
**Validation**: Manufacturer must be set.

#### BR-MIN-010: STANDARD_CODE Field (Optional) 🟡
**Source**: `drugs.standard_code`
**Format**: 24 characters if provided
**Validation**: Length check.

#### BR-MIN-011: BARCODE Field (Optional) 🟢
**Source**: `drugs.barcode`
**Format**: EAN-13, EAN-8, or custom
**Usage**: Barcode scanning.

---

### DISTRIBUTION Export ⭐

#### BR-MIN-020: DEPT_TYPE Field (Required) ⭐
**Source**: `departments.consumption_group`
**Values**: 1-9 (consumption patterns)
**Required**: For all departments that receive drug distributions.
**Validation**: Must be set for OPD, IPD, Emergency, OR departments.

---

## Data Integrity Rules

### Referential Integrity

#### BR-INT-001: Foreign Key Cascade Rules 🔴
**Delete Cascade**:
- `contract_items` when contract deleted (configurable)

**Delete Restrict** (prevent deletion):
- `budget_types` if referenced by budgets
- `budget_categories` if referenced by budgets
- `companies` if referenced by drugs (as manufacturer)
- `companies` if has active contracts
- `drug_generics` if referenced by drugs
- `locations` if has inventory
- `departments` if has budget allocations

#### BR-INT-002: Orphan Prevention 🔴
**Rule**: System should prevent orphaned records.
**Implementation**: Foreign key constraints + before-delete checks.

---

### Soft Delete Pattern

#### BR-INT-010: Soft Delete Implementation 🟡
**Tables with Soft Delete**:
- locations (`is_active`)
- departments (`is_active`)
- budget_types (`is_active`)
- budget_categories (`is_active`)
- budgets (`is_active`)
- bank (`is_active`)
- companies (`is_active`)
- drug_generics (`is_active`)
- drugs (`is_active` + `drug_status`)

**Rules**:
1. Never hard delete master data with dependencies
2. Set `is_active = false` instead
3. Exclude inactive records from default queries
4. Keep for historical reporting

---

## Workflow Rules

### Contract Approval Workflow

#### BR-WF-001: Contract Status Workflow 🟡
**States**: DRAFT → ACTIVE → EXPIRED / CANCELLED

**Transitions**:
```
DRAFT → ACTIVE:
  - Required: approved_by, approval_date
  - Validation: All contract items valid

ACTIVE → EXPIRED:
  - Trigger: end_date < current_date
  - Automatic: Scheduled job

DRAFT/ACTIVE → CANCELLED:
  - Required: Reason (in notes)
  - Validation: No pending POs
```

---

### Drug Status Workflow

#### BR-WF-002: Drug Lifecycle Workflow ⭐
**States**: ACTIVE (1) ↔ SUSPENDED (2) → REMOVED (3)

**Transitions**:
```
ACTIVE → SUSPENDED:
  - Reason: Temporary stock-out, quality issue
  - Reversible: Yes

SUSPENDED → ACTIVE:
  - Condition: Issue resolved

ACTIVE/SUSPENDED → REMOVED:
  - Reason: Permanent discontinuation
  - Reversible: No (use INVESTIGATIONAL for trials)

Any → INVESTIGATIONAL:
  - Use: New drugs under review
```

---

## Special Cases

### Edge Cases

#### BR-EDGE-001: Zero-Price Items 🟢
**Case**: Free samples, donations, ministry-provided items.
**Rule**: Allow `unit_price = 0`.
**Validation**: Skip price validation when price is exactly 0.

#### BR-EDGE-002: Hospital Pharmaceutical Products (HPP) 🟡
**Case**: Drugs compounded/prepared by hospital pharmacy.
**Rules**:
- `is_hpp = true`
- May not have `generic_id` (custom formulation)
- `manufacturer_id` = Hospital's own company record
- `hpp_type` should be set (R/M/F/X/OHPP)

#### BR-EDGE-003: Multi-Location Inventory 🟢
**Case**: Same drug stored in multiple locations.
**Rule**: Each location has separate inventory record.
**Calculation**: Total inventory = SUM across all locations.

#### BR-EDGE-004: Negative Inventory (Backorder) 🟡
**Case**: System allows negative inventory for backorder scenarios.
**Rule**: Configurable per location.
**Validation**: Warn user, allow override with reason.

#### BR-EDGE-005: Contract Price Lower Than Cost 🟢
**Case**: Contract price < average cost (good deal or loss leader).
**Rule**: Allow but log for review.
**Validation**: Warn if margin < threshold.

---

### Exception Handling

#### BR-EXC-001: Manual Override Flag 🟡
**Use**: When business rule needs exception.
**Implementation**:
- Add `override_reason` field (optional)
- Log override action
- Require supervisor approval

#### BR-EXC-002: Import Legacy Data 🟡
**Case**: Migrating from old system with incomplete data.
**Rules**:
- Relax non-critical validations during import
- Flag imported records for cleanup
- Provide data quality report

---

## Implementation Notes

### Priority Enforcement

**🔴 Critical Rules**:
- Enforce at database level (constraints, triggers)
- Enforce at application level (validation layer)
- Prevent operation if violated

**🟡 Important Rules**:
- Enforce at application level
- Show errors to user
- Allow admin override in some cases

**🟢 Recommended Rules**:
- Show warnings to user
- Allow user to proceed
- Log violations for review

---

### Testing Requirements

Each business rule should have:
1. **Unit Test**: Test rule in isolation
2. **Integration Test**: Test with related entities
3. **Edge Case Test**: Test boundary conditions
4. **Negative Test**: Ensure violations are caught

**Example Test**:
```typescript
describe('BR-CONT-003: Contract Date Range', () => {
  test('should reject contract with end_date <= start_date', async () => {
    const contract = {
      start_date: '2025-06-01',
      end_date: '2025-05-31', // BEFORE start_date
      // ... other fields
    };

    await expect(createContract(contract))
      .rejects
      .toThrow('Contract end date must be after start date');
  });
});
```

---

### Audit Trail

**Rules Requiring Audit**:
- BR-DRUG-009: Status changes (log who, when, why)
- BR-CONT-005: Contract value changes
- BR-EXC-001: Manual overrides

**Audit Fields**:
- `created_by`, `created_at` (all tables)
- `updated_by`, `updated_at` (where applicable)
- `approved_by`, `approval_date` (contracts, budgets)

---

## Rule Summary

| Category | Critical (🔴) | Important (🟡) | Recommended (🟢) | Total |
|----------|---------------|----------------|------------------|-------|
| Entity Rules | 35 | 20 | 15 | 70 |
| Cross-Entity | 3 | 3 | 2 | 8 |
| Calculations | 3 | 1 | 0 | 4 |
| Ministry | 7 | 2 | 2 | 11 |
| Integrity | 2 | 1 | 0 | 3 |
| Workflow | 0 | 2 | 0 | 2 |
| Special Cases | 0 | 3 | 3 | 6 |
| **Total** | **50** | **32** | **22** | **104** |

---

## Related Documentation

- **Schema Reference**: `01-SCHEMA.md` - Table structures
- **Validation Rules**: `03-VALIDATION-RULES.md` - Input validation
- **Data Constraints**: `09-DATA-CONSTRAINTS.md` - Field constraints
- **State Machines**: `02-STATE-MACHINES.md` - Status workflows
- **Error Codes**: `08-ERROR-CODES.md` - Error handling
- **Test Cases**: `05-TEST-CASES.md` - Test scenarios

---

**Last Updated**: 2025-01-22
**Version**: 2.2.0
**Maintained By**: Development Team

---

**End of Business Rules Documentation**

*Part of INVS Modern - Hospital Inventory Management System*
