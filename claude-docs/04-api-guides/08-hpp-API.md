# 🚀 HPP System - API Development Guide

**System:** Hospital Pharmaceutical Products (HPP)
**Version:** 2.6.0
**Last Updated:** 2025-01-28
**Target Audience:** Backend Developers

---

## 📋 Overview

HPP System manages hospital-made pharmaceutical products:
- **HPP Products** - Hospital-made products (repackaged, modified, formula, mixed, outsourced)
- **HPP Formulations** - Product formulation components
- **HPP Types** - R (Repackaged), M (Modified), F (Formula), X (Extemp), OHPP (Outsourced)
- **Ministry Compliance** - HPP reporting for custom products

---

## 🔐 Authentication & Authorization

| Feature | Finance Manager | Dept Head | Pharmacist | Nurse | Other Staff |
|---------|----------------|-----------|------------|-------|-------------|
| View HPP Products | ✅ | ✅ | ✅ | ✅ | ❌ |
| Create HPP Product | ✅ | ❌ | ✅ | ❌ | ❌ |
| Edit HPP Product | ✅ | ❌ | ✅ | ❌ | ❌ |
| Approve HPP Formula | ✅ | ❌ | ✅ | ❌ | ❌ |
| Add Formulation | ✅ | ❌ | ✅ | ❌ | ❌ |
| Inactivate HPP | ✅ | ❌ | ✅ | ❌ | ❌ |

---

## 📊 API Development Priority

### Phase 1: HPP CRUD (Week 1) ⭐

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 1 | `/api/hpp/products` | GET | List HPP products |
| 2 | `/api/hpp/products/:id` | GET | Get product details with formulation |
| 3 | `/api/hpp/products` | POST | Create HPP product |
| 4 | `/api/hpp/products/:id` | PUT | Update HPP product |
| 5 | `/api/hpp/products/:id` | DELETE | Inactivate product |

### Phase 2: Formulation Management (Week 2)

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 6 | `/api/hpp/products/:id/formulations` | GET | List formulations |
| 7 | `/api/hpp/products/:id/formulations` | POST | Add component |
| 8 | `/api/hpp/products/:id/formulations/:formId` | PUT | Update component |
| 9 | `/api/hpp/products/:id/formulations/:formId` | DELETE | Remove component |

### Phase 3: HPP Types & Reporting (Week 3)

| Priority | Endpoint | Method | Purpose |
|----------|----------|--------|---------|
| 10 | `/api/hpp/types` | GET | List HPP type definitions |
| 11 | `/api/hpp/products/by-type/:type` | GET | Filter by type (R/M/F/X/OHPP) |
| 12 | `/api/hpp/ministry-export` | GET | Ministry HPP report |

---

## 🚨 Error Codes

| Code | HTTP Status | Thai Message | When to Use |
|------|-------------|--------------|-------------|
| `HPP_NOT_FOUND` | 404 | ไม่พบข้อมูล HPP | HPP ID doesn't exist |
| `DUPLICATE_HPP_CODE` | 409 | รหัส HPP ซ้ำ | HPP code already exists |
| `INVALID_HPP_TYPE` | 400 | ประเภท HPP ไม่ถูกต้อง | Type must be R/M/F/X/OHPP |
| `FORMULATION_REQUIRED` | 400 | HPP ชนิด F ต้องมีส่วนประกอบ | Formula type needs formulation |
| `BASE_PRODUCT_REQUIRED` | 400 | HPP ชนิด M ต้องระบุผลิตภัณฑ์ต้นฉบับ | Modified type needs base_product_id |
| `INVALID_COMPONENT_RATIO` | 400 | อัตราส่วนส่วนประกอบไม่ถูกต้อง | Component ratios don't sum to 1.0 |

---

## 📝 Request/Response Examples

### 1. Create HPP Product (Repackaged)

**Endpoint:** `POST /api/hpp/products`

**Request:**
```typescript
{
  hpp_code: "HPP-R-001",
  hpp_type: "R",  // Repackaged
  product_name: "Paracetamol 500mg Blister x10",
  drug_id: 201,   // Original bulk drug
  tmt_code: "1234567",
  is_outsourced: false,
  is_active: true
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 1,
    hpp_code: "HPP-R-001",
    hpp_type: "R",
    product_name: "Paracetamol 500mg Blister x10",
    drug_id: 201,
    tmt_code: "1234567",
    is_outsourced: false,
    is_active: true,
    created_at: "2025-01-28T10:00:00Z",
    
    drug: {
      drug_code: "PARA500TAB001",
      trade_name: "Tylenol 500mg (Bulk)"
    }
  },
  message: "สร้าง HPP สำเร็จ"
}
```

---

### 2. Create HPP Product (Formula with Formulation)

**Endpoint:** `POST /api/hpp/products`

**Request:**
```typescript
{
  hpp_code: "HPP-F-001",
  hpp_type: "F",  // Formula
  product_name: "Metoclopramide Oral Solution 5mg/5mL",
  generic_id: 10,
  tmt_code: "1234568",
  is_outsourced: false,
  is_active: true,
  
  // Include formulation components
  formulations: [
    {
      component_type: "ACTIVE",
      component_name: "Metoclopramide HCl",
      component_strength: "5mg/5mL",
      component_ratio: 1.0
    },
    {
      component_type: "EXCIPIENT",
      component_name: "Syrup Simple",
      component_ratio: 0.8
    },
    {
      component_type: "PRESERVATIVE",
      component_name: "Sodium Benzoate",
      component_ratio: 0.01
    }
  ]
}
```

**Validation:**
```typescript
// HPP Type F requires formulation
if (hpp_type === 'F' && (!formulations || formulations.length === 0)) {
  throw new ValidationError('FORMULATION_REQUIRED');
}

// Must have at least one ACTIVE component
const activeComponents = formulations.filter(f => f.component_type === 'ACTIVE');
if (activeComponents.length === 0) {
  throw new ValidationError('At least one ACTIVE component required');
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 2,
    hpp_code: "HPP-F-001",
    hpp_type: "F",
    product_name: "Metoclopramide Oral Solution 5mg/5mL",
    generic_id: 10,
    is_active: true,
    
    generic: {
      working_code: "0001010",
      generic_name: "Metoclopramide 5mg/5mL SOLUTION"
    },
    
    formulations: [
      {
        id: 1,
        hpp_id: 2,
        component_type: "ACTIVE",
        component_name: "Metoclopramide HCl",
        component_strength: "5mg/5mL",
        component_ratio: 1.0
      },
      {
        id: 2,
        hpp_id: 2,
        component_type: "EXCIPIENT",
        component_name: "Syrup Simple",
        component_ratio: 0.8
      },
      {
        id: 3,
        hpp_id: 2,
        component_type: "PRESERVATIVE",
        component_name: "Sodium Benzoate",
        component_ratio: 0.01
      }
    ]
  },
  message: "สร้าง HPP Formula สำเร็จ"
}
```

---

### 3. Create Modified Product

**Endpoint:** `POST /api/hpp/products`

**Request:**
```typescript
{
  hpp_code: "HPP-M-001",
  hpp_type: "M",  // Modified
  product_name: "Paracetamol 250mg (Split Tablet)",
  base_product_id: 201,  // Original product
  tmt_code: "1234569",
  is_outsourced: false,
  is_active: true
}
```

**Validation:**
```typescript
// HPP Type M requires base_product_id
if (hpp_type === 'M' && !base_product_id) {
  throw new ValidationError('BASE_PRODUCT_REQUIRED');
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 3,
    hpp_code: "HPP-M-001",
    hpp_type: "M",
    product_name: "Paracetamol 250mg (Split Tablet)",
    base_product_id: 201,
    is_active: true,
    
    base_product: {
      drug_code: "PARA500TAB001",
      trade_name: "Tylenol 500mg"
    }
  },
  message: "สร้าง HPP Modified Product สำเร็จ"
}
```

---

### 4. Get HPP Product with Full Details

**Endpoint:** `GET /api/hpp/products/:id`

**Example Request:**
```
GET /api/hpp/products/2
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 2,
    hpp_code: "HPP-F-001",
    hpp_type: "F",
    product_name: "Metoclopramide Oral Solution 5mg/5mL",
    generic_id: 10,
    drug_id: null,
    base_product_id: null,
    tmt_code: "1234568",
    is_outsourced: false,
    is_active: true,
    created_at: "2025-01-28T10:00:00Z",
    updated_at: "2025-01-28T10:00:00Z",
    
    // Relations
    generic: {
      working_code: "0001010",
      generic_name: "Metoclopramide 5mg/5mL SOLUTION"
    },
    
    // Formulations
    formulations: [
      {
        id: 1,
        component_type: "ACTIVE",
        component_name: "Metoclopramide HCl",
        component_strength: "5mg/5mL",
        component_ratio: 1.0
      },
      {
        id: 2,
        component_type: "EXCIPIENT",
        component_name: "Syrup Simple",
        component_ratio: 0.8
      },
      {
        id: 3,
        component_type: "PRESERVATIVE",
        component_name: "Sodium Benzoate",
        component_ratio: 0.01
      }
    ],
    
    // Statistics
    _count: {
      formulations: 3
    }
  }
}
```

---

### 5. List HPP Products by Type

**Endpoint:** `GET /api/hpp/products/by-type/:type`

**Example Request:**
```
GET /api/hpp/products/by-type/F
```

**Success Response:**
```typescript
{
  success: true,
  data: [
    {
      id: 2,
      hpp_code: "HPP-F-001",
      hpp_type: "F",
      product_name: "Metoclopramide Oral Solution 5mg/5mL",
      is_active: true,
      formulation_count: 3,
      
      generic: {
        generic_name: "Metoclopramide 5mg/5mL SOLUTION"
      }
    },
    {
      id: 4,
      hpp_code: "HPP-F-002",
      hpp_type: "F",
      product_name: "Chlorhexidine Mouthwash 0.2%",
      is_active: true,
      formulation_count: 5
    }
  ],
  meta: {
    hpp_type: "F",
    type_name: "Hospital Formula",
    total: 15
  }
}
```

---

### 6. Add Formulation Component

**Endpoint:** `POST /api/hpp/products/:id/formulations`

**Request:**
```typescript
{
  component_type: "SOLVENT",
  component_name: "Purified Water",
  component_ratio: 0.19
}
```

**Success Response:**
```typescript
{
  success: true,
  data: {
    id: 4,
    hpp_id: 2,
    component_type: "SOLVENT",
    component_name: "Purified Water",
    component_strength: null,
    component_ratio: 0.19,
    created_at: "2025-01-28T11:00:00Z"
  },
  message: "เพิ่มส่วนประกอบสำเร็จ"
}
```

---

## ⚙️ Environment Configuration

```env
# HPP Configuration
HPP_CODE_PREFIX=HPP                        # HPP code prefix
HPP_REQUIRE_TMT_CODE=true                  # Require TMT code for HPP
HPP_REQUIRE_FORMULATION_FORMULA=true       # Formula type must have formulation
HPP_ALLOW_RATIO_TOLERANCE=0.01             # Allow 1% tolerance in component ratios

# Formula Approval
HPP_REQUIRE_COMMITTEE_APPROVAL=true        # Require hospital committee approval
HPP_APPROVAL_VALIDITY_YEARS=2              # Formula approval validity

# Outsourced Products
HPP_REQUIRE_CONTRACTOR_LICENSE=true        # Require contractor license for OHPP
HPP_CONTRACTOR_LICENSE_CHECK=true          # Verify license validity
```

---

## 🧪 Testing Guidelines

### Test HPP Types

```typescript
describe('HPP Product Types', () => {
  it('should create Repackaged HPP (R)', async () => {
    const response = await request(app)
      .post('/api/hpp/products')
      .send({
        hpp_code: 'HPP-R-001',
        hpp_type: 'R',
        product_name: 'Paracetamol Blister',
        drug_id: 201
      });
    
    expect(response.status).toBe(200);
    expect(response.body.data.hpp_type).toBe('R');
  });
  
  it('should require formulation for Formula type (F)', async () => {
    const response = await request(app)
      .post('/api/hpp/products')
      .send({
        hpp_code: 'HPP-F-001',
        hpp_type: 'F',
        product_name: 'Test Formula',
        generic_id: 10
        // Missing formulations
      });
    
    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe('FORMULATION_REQUIRED');
  });
  
  it('should require base_product_id for Modified type (M)', async () => {
    const response = await request(app)
      .post('/api/hpp/products')
      .send({
        hpp_code: 'HPP-M-001',
        hpp_type: 'M',
        product_name: 'Split Tablet'
        // Missing base_product_id
      });
    
    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe('BASE_PRODUCT_REQUIRED');
  });
});
```

---

**Last Updated:** 2025-01-28 | **Version:** 2.6.0
**Built with ❤️ for INVS Modern Team**
