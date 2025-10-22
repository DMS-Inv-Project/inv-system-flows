# TMT Database Design for HIS Integration

## Overview
ออกแบบโครงสร้างฐานข้อมูล TMT สำหรับระบบ INVS Modern ให้สามารถเชื่อมต่อกับ HIS และรองรับมาตรฐานกระทรวงสาธารณสุข

## Core TMT Tables

### 1. TMT Concepts (หลัก)
เก็บข้อมูล TMT ทุกระดับในตารางเดียว
```sql
tmt_concepts (
  id BIGSERIAL PRIMARY KEY,
  tmt_id BIGINT UNIQUE NOT NULL,
  concept_code VARCHAR(20),
  level TMT_LEVEL NOT NULL,
  fsn VARCHAR(2000) NOT NULL,
  preferred_term VARCHAR(300),
  strength VARCHAR(100),
  dosage_form VARCHAR(50),
  manufacturer VARCHAR(300),
  pack_size VARCHAR(50),
  unit_of_use VARCHAR(20),
  route_of_administration VARCHAR(50),
  is_active BOOLEAN DEFAULT true,
  effective_date DATE,
  release_date VARCHAR(20),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
)
```

### 2. TMT Relationships (ความสัมพันธ์)
เชื่อมโยงระหว่างระดับต่างๆ ของ TMT
```sql
tmt_relationships (
  id BIGSERIAL PRIMARY KEY,
  parent_id BIGINT REFERENCES tmt_concepts(id),
  child_id BIGINT REFERENCES tmt_concepts(id),
  relationship_type TMT_RELATION_TYPE NOT NULL,
  strength_value VARCHAR(100),
  dosage_form_value VARCHAR(50),
  manufacturer_value VARCHAR(300),
  pack_size_value VARCHAR(50),
  is_active BOOLEAN DEFAULT true,
  effective_date DATE,
  release_date VARCHAR(20),
  created_at TIMESTAMP DEFAULT now(),
  UNIQUE(parent_id, child_id, relationship_type)
)
```

### 3. TMT Attributes (คุณสมบัติเพิ่มเติม)
เก็บคุณสมบัติเพิ่มเติมแบบ flexible
```sql
tmt_attributes (
  id BIGSERIAL PRIMARY KEY,
  concept_id BIGINT REFERENCES tmt_concepts(id),
  attribute_type VARCHAR(50) NOT NULL,
  attribute_value TEXT,
  value_type VARCHAR(20), -- 'string', 'number', 'date', 'boolean'
  unit VARCHAR(20),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now()
)
```

### 4. TMT Code Mappings (การแมป)
เชื่อมโยงรหัสภายในโรงพยาบาลกับ TMT
```sql
tmt_mappings (
  id BIGSERIAL PRIMARY KEY,
  hospital_code VARCHAR(24) NOT NULL,
  hospital_code_type VARCHAR(20), -- 'working_code', 'drug_code', 'trade_code'
  tmt_concept_id BIGINT REFERENCES tmt_concepts(id),
  tmt_level TMT_LEVEL NOT NULL,
  mapping_source VARCHAR(50), -- 'manual', 'auto', 'import'
  confidence DECIMAL(3,2), -- 0.00-1.00
  mapped_by VARCHAR(50),
  verified_by VARCHAR(50),
  is_active BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  mapping_date TIMESTAMP NOT NULL,
  verification_date TIMESTAMP,
  notes TEXT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
)
```

## Reference Tables

### 5. TMT Manufacturers (ผู้ผลิต)
เก็บข้อมูลผู้ผลิตแยกต่างหาก
```sql
tmt_manufacturers (
  id BIGSERIAL PRIMARY KEY,
  manufacturer_code VARCHAR(20) UNIQUE,
  manufacturer_name VARCHAR(300) NOT NULL,
  manufacturer_name_en VARCHAR(300),
  country_code VARCHAR(3),
  fda_license VARCHAR(50),
  gmp_status VARCHAR(20),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
)
```

### 6. TMT Dosage Forms (รูปแบบยา)
```sql
tmt_dosage_forms (
  id BIGSERIAL PRIMARY KEY,
  form_code VARCHAR(20) UNIQUE,
  form_name VARCHAR(100) NOT NULL,
  form_name_en VARCHAR(100),
  category VARCHAR(50), -- 'solid', 'liquid', 'injection', etc.
  route_of_administration VARCHAR(50),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now()
)
```

### 7. TMT Units (หน่วย)
```sql
tmt_units (
  id BIGSERIAL PRIMARY KEY,
  unit_code VARCHAR(20) UNIQUE,
  unit_name VARCHAR(50) NOT NULL,
  unit_name_en VARCHAR(50),
  unit_type VARCHAR(20), -- 'strength', 'volume', 'weight', 'count'
  base_unit VARCHAR(20),
  conversion_factor DECIMAL(15,6),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now()
)
```

## HIS Integration Tables

### 8. HIS Drug Master (เชื่อมต่อ HIS)
```sql
his_drug_master (
  id BIGSERIAL PRIMARY KEY,
  his_drug_code VARCHAR(50) UNIQUE NOT NULL,
  drug_name VARCHAR(200) NOT NULL,
  generic_name VARCHAR(200),
  strength VARCHAR(100),
  dosage_form VARCHAR(50),
  manufacturer VARCHAR(200),
  registration_number VARCHAR(30),
  
  -- TMT Mappings
  tmt_concept_id BIGINT REFERENCES tmt_concepts(id),
  tmt_level TMT_LEVEL,
  mapping_confidence DECIMAL(3,2),
  mapping_status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'mapped', 'verified', 'rejected'
  
  -- 24NC Code (National Code)
  nc24_code VARCHAR(24),
  nc24_status VARCHAR(20),
  
  is_active BOOLEAN DEFAULT true,
  last_sync TIMESTAMP,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
)
```

### 9. Hospital Pharmaceutical Products (HPP)
```sql
hospital_pharmaceutical_products (
  id BIGSERIAL PRIMARY KEY,
  hpp_code VARCHAR(20) UNIQUE NOT NULL,
  hpp_type HPP_TYPE NOT NULL, -- 'R', 'M', 'F', 'X', 'OHPP'
  product_name VARCHAR(200) NOT NULL,
  base_product_id BIGINT REFERENCES his_drug_master(id),
  
  -- Formula Information
  formula_reference VARCHAR(100),
  preparation_method TEXT,
  storage_condition VARCHAR(200),
  stability_period VARCHAR(50),
  
  -- TMT Reference
  tmt_concept_id BIGINT REFERENCES tmt_concepts(id),
  tmt_level TMT_LEVEL DEFAULT 'GP_F',
  
  -- Approval
  approved_by VARCHAR(50),
  approval_date DATE,
  review_date DATE,
  
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
)
```

### 10. HPP Formulations (สูตรการเตรียม)
```sql
hpp_formulations (
  id BIGSERIAL PRIMARY KEY,
  hpp_id BIGINT REFERENCES hospital_pharmaceutical_products(id),
  component_type VARCHAR(20), -- 'active', 'excipient', 'base'
  component_name VARCHAR(200),
  component_strength VARCHAR(100),
  component_unit VARCHAR(20),
  component_ratio DECIMAL(10,4),
  notes TEXT,
  created_at TIMESTAMP DEFAULT now()
)
```

## Reporting and Analytics Tables

### 11. TMT Usage Statistics
```sql
tmt_usage_stats (
  id BIGSERIAL PRIMARY KEY,
  period_type VARCHAR(20), -- 'daily', 'monthly', 'yearly'
  period_date DATE NOT NULL,
  tmt_concept_id BIGINT REFERENCES tmt_concepts(id),
  usage_count INTEGER DEFAULT 0,
  prescription_count INTEGER DEFAULT 0,
  dispensing_count INTEGER DEFAULT 0,
  consumption_amount DECIMAL(15,3),
  unit VARCHAR(20),
  department_id BIGINT,
  created_at TIMESTAMP DEFAULT now()
)
```

### 12. Ministry Reporting Data
```sql
ministry_reports (
  id BIGSERIAL PRIMARY KEY,
  report_type VARCHAR(50), -- 'druglist', 'purchaseplan', 'receipt', 'distribution', 'inventory'
  report_period VARCHAR(20),
  report_date DATE NOT NULL,
  hospital_code VARCHAR(10),
  data_json JSONB,
  tmt_compliance_rate DECIMAL(5,2),
  total_items INTEGER,
  mapped_items INTEGER,
  verification_status VARCHAR(20),
  submitted_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT now()
)
```

## ENUMs Definition

```sql
-- TMT Levels
CREATE TYPE TMT_LEVEL AS ENUM (
  'SUBS', 'VTM', 'GP', 'TP', 'GPU', 'TPU', 'GPP', 'TPP', 'GP_F', 'GP_X'
);

-- TMT Relationship Types
CREATE TYPE TMT_RELATION_TYPE AS ENUM (
  'IS_A', 'HAS_ACTIVE_INGREDIENT', 'HAS_DOSE_FORM', 
  'HAS_MANUFACTURER', 'HAS_PACK_SIZE', 'HAS_STRENGTH', 
  'HAS_UNIT_OF_USE', 'HAS_ROUTE_OF_ADMINISTRATION'
);

-- HPP Types
CREATE TYPE HPP_TYPE AS ENUM (
  'R', 'M', 'F', 'X', 'OHPP'
);
```

## Indexes for Performance

```sql
-- TMT Concepts
CREATE INDEX idx_tmt_concepts_tmt_id ON tmt_concepts(tmt_id);
CREATE INDEX idx_tmt_concepts_level ON tmt_concepts(level);
CREATE INDEX idx_tmt_concepts_fsn ON tmt_concepts USING gin(to_tsvector('thai', fsn));

-- TMT Relationships
CREATE INDEX idx_tmt_relationships_parent ON tmt_relationships(parent_id);
CREATE INDEX idx_tmt_relationships_child ON tmt_relationships(child_id);

-- TMT Mappings
CREATE INDEX idx_tmt_mappings_hospital_code ON tmt_mappings(hospital_code);
CREATE INDEX idx_tmt_mappings_tmt_concept ON tmt_mappings(tmt_concept_id);
CREATE INDEX idx_tmt_mappings_level ON tmt_mappings(tmt_level);

-- HIS Integration
CREATE INDEX idx_his_drug_master_code ON his_drug_master(his_drug_code);
CREATE INDEX idx_his_drug_master_tmt ON his_drug_master(tmt_concept_id);
```

## Key Features

1. **ครอบคลุม TMT 8 ระดับ** - รองรับทุกระดับของ TMT hierarchy
2. **HIS Integration** - เชื่อมต่อกับระบบ HIS ได้อย่างสมบูรณ์
3. **Ministry Compliance** - รองรับการรายงานตามมาตรฐานกระทรวง
4. **HPP Management** - จัดการยา Hospital Pharmaceutical Products
5. **Flexible Mapping** - ระบบ mapping ที่ยืดหยุ่น
6. **Performance Optimized** - มี indexes สำหรับการค้นหาที่รวดเร็ว
7. **Audit Trail** - ติดตามการเปลี่ยนแปลงข้อมูล
8. **Multilingual Support** - รองรับทั้งภาษาไทยและอังกฤษ

## Implementation Phases

### Phase 1: Core TMT Tables
- tmt_concepts
- tmt_relationships  
- tmt_mappings

### Phase 2: Reference Data
- tmt_manufacturers
- tmt_dosage_forms
- tmt_units

### Phase 3: HIS Integration
- his_drug_master
- hospital_pharmaceutical_products
- hpp_formulations

### Phase 4: Reporting & Analytics
- tmt_usage_stats
- ministry_reports