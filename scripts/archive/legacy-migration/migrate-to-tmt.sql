-- INVS Modern - Migration Script to TMT Support
-- This script adds TMT support to existing database

-- =====================================================
-- STEP 1: ADD TMT FIELDS TO EXISTING TABLES
-- =====================================================

-- Add TMT fields to drug_generics table
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS tmt_vtm_code VARCHAR(10);
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS tmt_vtm_id BIGINT;
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS tmt_gp_code VARCHAR(10);
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS tmt_gp_id BIGINT;
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS tmt_gpf_code VARCHAR(10);
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS tmt_gpf_id BIGINT;
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS tmt_gpx_code VARCHAR(10);
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS tmt_gpx_id BIGINT;
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS tmt_code VARCHAR(10);
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS standard_unit VARCHAR(10);
ALTER TABLE drug_generics ADD COLUMN IF NOT EXISTS therapeutic_group VARCHAR(50);

-- Add indexes for TMT fields in drug_generics
CREATE INDEX IF NOT EXISTS idx_drug_generics_tmt_vtm_code ON drug_generics(tmt_vtm_code);
CREATE INDEX IF NOT EXISTS idx_drug_generics_tmt_gp_code ON drug_generics(tmt_gp_code);
CREATE INDEX IF NOT EXISTS idx_drug_generics_tmt_code ON drug_generics(tmt_code);

-- Add TMT fields to drugs table
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS tmt_tp_code VARCHAR(10);
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS tmt_tp_id BIGINT;
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS tmt_tpu_code VARCHAR(10);
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS tmt_tpu_id BIGINT;
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS tmt_tpp_code VARCHAR(10);
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS tmt_tpp_id BIGINT;
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS nc24_code VARCHAR(24);
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS registration_number VARCHAR(20);
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS gpo_code VARCHAR(15);

-- Add HPP fields to drugs table
CREATE TYPE hpp_type AS ENUM ('R', 'M', 'F', 'X', 'OHPP');
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS hpp_type hpp_type;
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS spec_prep VARCHAR(10);
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS is_hpp BOOLEAN DEFAULT FALSE;
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS base_product_id BIGINT;
ALTER TABLE drugs ADD COLUMN IF NOT EXISTS formula_reference TEXT;

-- Add foreign key constraint for base_product_id (self-reference)
ALTER TABLE drugs ADD CONSTRAINT fk_drugs_base_product 
    FOREIGN KEY (base_product_id) REFERENCES drugs(id);

-- Add indexes for TMT fields in drugs
CREATE INDEX IF NOT EXISTS idx_drugs_tmt_tp_code ON drugs(tmt_tp_code);
CREATE INDEX IF NOT EXISTS idx_drugs_tmt_tpu_code ON drugs(tmt_tpu_code);
CREATE INDEX IF NOT EXISTS idx_drugs_nc24_code ON drugs(nc24_code);
CREATE INDEX IF NOT EXISTS idx_drugs_hpp_type ON drugs(hpp_type);
CREATE INDEX IF NOT EXISTS idx_drugs_is_hpp ON drugs(is_hpp);

-- Add TMT fields to companies table
ALTER TABLE companies ADD COLUMN IF NOT EXISTS tmt_manufacturer_code VARCHAR(20);
ALTER TABLE companies ADD COLUMN IF NOT EXISTS fda_license_number VARCHAR(20);
ALTER TABLE companies ADD COLUMN IF NOT EXISTS gmp_certificate VARCHAR(30);

-- =====================================================
-- STEP 2: CREATE TMT ENUMS
-- =====================================================

-- Create TMT Level enum
CREATE TYPE tmt_level AS ENUM (
    'SUBS', 'VTM', 'GP', 'TP', 'GPU', 'TPU', 'GPP', 'TPP', 'GP-F', 'GP-X'
);

-- Create TMT Relationship Type enum
CREATE TYPE tmt_relation_type AS ENUM (
    'IS_A', 'HAS_ACTIVE_INGREDIENT', 'HAS_DOSE_FORM', 
    'HAS_MANUFACTURER', 'HAS_PACK_SIZE', 'HAS_STRENGTH', 'HAS_UNIT_OF_USE'
);

-- =====================================================
-- STEP 3: CREATE NEW TMT TABLES
-- =====================================================

-- Create TMT Concepts table
CREATE TABLE IF NOT EXISTS tmt_concepts (
    id BIGSERIAL PRIMARY KEY,
    tmt_id BIGINT UNIQUE NOT NULL,
    concept_code VARCHAR(20),
    level tmt_level NOT NULL,
    fsn VARCHAR(500) NOT NULL,
    preferred_term VARCHAR(300),
    strength VARCHAR(100),
    dosage_form VARCHAR(50),
    manufacturer VARCHAR(100),
    pack_size VARCHAR(50),
    unit_of_use VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    effective_date TIMESTAMP,
    release_date VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for TMT Concepts
CREATE INDEX IF NOT EXISTS idx_tmt_concepts_tmt_id ON tmt_concepts(tmt_id);
CREATE INDEX IF NOT EXISTS idx_tmt_concepts_level ON tmt_concepts(level);
CREATE INDEX IF NOT EXISTS idx_tmt_concepts_fsn ON tmt_concepts USING gin(to_tsvector('english', fsn));
CREATE INDEX IF NOT EXISTS idx_tmt_concepts_active ON tmt_concepts(is_active);

-- Create TMT Relationships table
CREATE TABLE IF NOT EXISTS tmt_relationships (
    id BIGSERIAL PRIMARY KEY,
    parent_id BIGINT NOT NULL,
    child_id BIGINT NOT NULL,
    relationship_type tmt_relation_type NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    effective_date TIMESTAMP,
    release_date VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES tmt_concepts(id),
    FOREIGN KEY (child_id) REFERENCES tmt_concepts(id),
    UNIQUE(parent_id, child_id, relationship_type)
);

-- Create indexes for TMT Relationships
CREATE INDEX IF NOT EXISTS idx_tmt_relationships_parent ON tmt_relationships(parent_id);
CREATE INDEX IF NOT EXISTS idx_tmt_relationships_child ON tmt_relationships(child_id);
CREATE INDEX IF NOT EXISTS idx_tmt_relationships_type ON tmt_relationships(relationship_type);

-- Create Hospital Pharmaceutical Products table
CREATE TABLE IF NOT EXISTS hospital_pharmaceutical_products (
    id BIGSERIAL PRIMARY KEY,
    hpp_code VARCHAR(20) UNIQUE NOT NULL,
    hpp_type hpp_type NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    generic_id BIGINT,
    drug_id BIGINT,
    base_product_id BIGINT,
    strength VARCHAR(100),
    dosage_form VARCHAR(50),
    pack_size VARCHAR(50),
    unit_of_use VARCHAR(20),
    formula_reference TEXT,
    formula_source VARCHAR(100),
    tmt_code VARCHAR(10),
    tmt_id BIGINT,
    spec_prep VARCHAR(10),
    is_outsourced BOOLEAN DEFAULT FALSE,
    hospital_code VARCHAR(10),
    is_active BOOLEAN DEFAULT TRUE,
    approved_by VARCHAR(50),
    approval_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (generic_id) REFERENCES drug_generics(id),
    FOREIGN KEY (drug_id) REFERENCES drugs(id),
    FOREIGN KEY (base_product_id) REFERENCES drugs(id)
);

-- Create indexes for HPP
CREATE INDEX IF NOT EXISTS idx_hpp_code ON hospital_pharmaceutical_products(hpp_code);
CREATE INDEX IF NOT EXISTS idx_hpp_type ON hospital_pharmaceutical_products(hpp_type);
CREATE INDEX IF NOT EXISTS idx_hpp_generic ON hospital_pharmaceutical_products(generic_id);
CREATE INDEX IF NOT EXISTS idx_hpp_drug ON hospital_pharmaceutical_products(drug_id);
CREATE INDEX IF NOT EXISTS idx_hpp_tmt_code ON hospital_pharmaceutical_products(tmt_code);

-- Create TMT Mappings table
CREATE TABLE IF NOT EXISTS tmt_mappings (
    id BIGSERIAL PRIMARY KEY,
    working_code VARCHAR(7),
    drug_code VARCHAR(24),
    generic_id BIGINT,
    drug_id BIGINT,
    tmt_level tmt_level NOT NULL,
    tmt_concept_id BIGINT NOT NULL,
    tmt_code VARCHAR(10),
    tmt_id BIGINT NOT NULL,
    mapping_source VARCHAR(50),
    confidence DECIMAL(3,2),
    mapped_by VARCHAR(50),
    verified_by VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    mapping_date TIMESTAMP NOT NULL,
    verification_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (generic_id) REFERENCES drug_generics(id),
    FOREIGN KEY (drug_id) REFERENCES drugs(id),
    FOREIGN KEY (tmt_concept_id) REFERENCES tmt_concepts(id)
);

-- Create indexes for TMT Mappings
CREATE INDEX IF NOT EXISTS idx_tmt_mappings_working_code ON tmt_mappings(working_code);
CREATE INDEX IF NOT EXISTS idx_tmt_mappings_drug_code ON tmt_mappings(drug_code);
CREATE INDEX IF NOT EXISTS idx_tmt_mappings_generic ON tmt_mappings(generic_id);
CREATE INDEX IF NOT EXISTS idx_tmt_mappings_drug ON tmt_mappings(drug_id);
CREATE INDEX IF NOT EXISTS idx_tmt_mappings_tmt_level ON tmt_mappings(tmt_level);
CREATE INDEX IF NOT EXISTS idx_tmt_mappings_tmt_concept ON tmt_mappings(tmt_concept_id);
CREATE INDEX IF NOT EXISTS idx_tmt_mappings_verified ON tmt_mappings(is_verified);

-- =====================================================
-- STEP 4: CREATE VIEWS FOR TMT DATA ACCESS
-- =====================================================

-- View for drug with TMT information
CREATE OR REPLACE VIEW v_drugs_with_tmt AS
SELECT 
    d.*,
    dg.working_code,
    dg.tmt_vtm_code,
    dg.tmt_gp_code,
    dg.tmt_code as generic_tmt_code,
    tm_tp.tmt_id as tp_tmt_id,
    tm_tp.fsn as tp_fsn,
    tm_tpu.tmt_id as tpu_tmt_id,
    tm_tpu.fsn as tpu_fsn,
    c.company_name as manufacturer_name
FROM drugs d
LEFT JOIN drug_generics dg ON d.generic_id = dg.id
LEFT JOIN companies c ON d.manufacturer_id = c.id
LEFT JOIN tmt_concepts tm_tp ON d.tmt_tp_id = tm_tp.tmt_id
LEFT JOIN tmt_concepts tm_tpu ON d.tmt_tpu_id = tm_tpu.tmt_id;

-- View for TMT hierarchy
CREATE OR REPLACE VIEW v_tmt_hierarchy AS
SELECT 
    p.tmt_id as parent_tmt_id,
    p.level as parent_level,
    p.fsn as parent_fsn,
    r.relationship_type,
    c.tmt_id as child_tmt_id,
    c.level as child_level,
    c.fsn as child_fsn
FROM tmt_relationships r
JOIN tmt_concepts p ON r.parent_id = p.id
JOIN tmt_concepts c ON r.child_id = c.id
WHERE r.is_active = TRUE;

-- View for HPP summary
CREATE OR REPLACE VIEW v_hpp_summary AS
SELECT 
    hpp.*,
    dg.working_code,
    dg.drug_name as generic_name,
    d.trade_name,
    bd.trade_name as base_product_name,
    tc.fsn as tmt_fsn
FROM hospital_pharmaceutical_products hpp
LEFT JOIN drug_generics dg ON hpp.generic_id = dg.id
LEFT JOIN drugs d ON hpp.drug_id = d.id
LEFT JOIN drugs bd ON hpp.base_product_id = bd.id
LEFT JOIN tmt_concepts tc ON hpp.tmt_id = tc.tmt_id
WHERE hpp.is_active = TRUE;

-- =====================================================
-- STEP 5: CREATE FUNCTIONS FOR TMT OPERATIONS
-- =====================================================

-- Function to check TMT mapping completeness
CREATE OR REPLACE FUNCTION check_tmt_mapping_completeness()
RETURNS TABLE(
    table_name TEXT,
    total_records BIGINT,
    mapped_records BIGINT,
    mapping_percentage DECIMAL(5,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        'drug_generics'::TEXT,
        COUNT(*)::BIGINT,
        COUNT(tmt_gp_code)::BIGINT,
        ROUND((COUNT(tmt_gp_code)::DECIMAL / COUNT(*)) * 100, 2)
    FROM drug_generics
    WHERE is_active = TRUE
    
    UNION ALL
    
    SELECT 
        'drugs'::TEXT,
        COUNT(*)::BIGINT,
        COUNT(tmt_tpu_code)::BIGINT,
        ROUND((COUNT(tmt_tpu_code)::DECIMAL / COUNT(*)) * 100, 2)
    FROM drugs
    WHERE is_active = TRUE;
END;
$$ LANGUAGE plpgsql;

-- Function to find TMT concept by search term
CREATE OR REPLACE FUNCTION search_tmt_concept(search_term TEXT, tmt_level_filter tmt_level DEFAULT NULL)
RETURNS TABLE(
    tmt_id BIGINT,
    concept_code VARCHAR(20),
    level tmt_level,
    fsn VARCHAR(500),
    preferred_term VARCHAR(300)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        tc.tmt_id,
        tc.concept_code,
        tc.level,
        tc.fsn,
        tc.preferred_term
    FROM tmt_concepts tc
    WHERE tc.is_active = TRUE
        AND (tc.fsn ILIKE '%' || search_term || '%' 
             OR tc.preferred_term ILIKE '%' || search_term || '%')
        AND (tmt_level_filter IS NULL OR tc.level = tmt_level_filter)
    ORDER BY 
        CASE 
            WHEN tc.fsn ILIKE search_term || '%' THEN 1
            WHEN tc.preferred_term ILIKE search_term || '%' THEN 2
            ELSE 3
        END,
        tc.fsn;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- STEP 6: INSERT SAMPLE DATA FOR TESTING
-- =====================================================

-- Insert sample TMT concepts (for testing)
INSERT INTO tmt_concepts (tmt_id, concept_code, level, fsn, preferred_term, is_active) VALUES
(1001, 'VTM001', 'VTM', 'paracetamol (Virtual Therapeutic Moiety)', 'paracetamol', TRUE),
(2001, 'GP001', 'GP', 'paracetamol 500mg tablet', 'paracetamol 500mg tablet', TRUE),
(3001, 'TP001', 'TP', 'TYLENOL (paracetamol 500mg tablet)', 'TYLENOL 500mg', TRUE),
(4001, 'TPU001', 'TPU', 'TYLENOL (paracetamol 500mg tablet, 1 tablet)', 'TYLENOL 500mg 1 tab', TRUE)
ON CONFLICT (tmt_id) DO NOTHING;

-- Insert sample relationships
INSERT INTO tmt_relationships (parent_id, child_id, relationship_type, is_active) VALUES
((SELECT id FROM tmt_concepts WHERE tmt_id = 1001), (SELECT id FROM tmt_concepts WHERE tmt_id = 2001), 'IS_A', TRUE),
((SELECT id FROM tmt_concepts WHERE tmt_id = 2001), (SELECT id FROM tmt_concepts WHERE tmt_id = 3001), 'IS_A', TRUE),
((SELECT id FROM tmt_concepts WHERE tmt_id = 3001), (SELECT id FROM tmt_concepts WHERE tmt_id = 4001), 'IS_A', TRUE)
ON CONFLICT (parent_id, child_id, relationship_type) DO NOTHING;

-- =====================================================
-- STEP 7: UPDATE TRIGGERS FOR AUTOMATIC TIMESTAMP
-- =====================================================

-- Create function for updating timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for TMT tables
CREATE TRIGGER trigger_tmt_concepts_updated_at
    BEFORE UPDATE ON tmt_concepts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_hpp_updated_at
    BEFORE UPDATE ON hospital_pharmaceutical_products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_tmt_mappings_updated_at
    BEFORE UPDATE ON tmt_mappings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- STEP 8: VALIDATION AND CLEANUP
-- =====================================================

-- Create function to validate TMT data integrity
CREATE OR REPLACE FUNCTION validate_tmt_data_integrity()
RETURNS TABLE(
    check_name TEXT,
    status TEXT,
    message TEXT
) AS $$
BEGIN
    -- Check for orphaned TMT mappings
    RETURN QUERY
    SELECT 
        'orphaned_mappings'::TEXT,
        CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END::TEXT,
        'Found ' || COUNT(*) || ' orphaned TMT mappings'::TEXT
    FROM tmt_mappings tm
    LEFT JOIN tmt_concepts tc ON tm.tmt_concept_id = tc.id
    WHERE tc.id IS NULL;
    
    -- Check for invalid TMT references in drugs
    RETURN QUERY
    SELECT 
        'invalid_drug_tmt_refs'::TEXT,
        CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END::TEXT,
        'Found ' || COUNT(*) || ' drugs with invalid TMT references'::TEXT
    FROM drugs d
    WHERE d.tmt_tpu_id IS NOT NULL 
        AND NOT EXISTS (SELECT 1 FROM tmt_concepts tc WHERE tc.tmt_id = d.tmt_tpu_id);
    
    -- Check for invalid TMT references in drug_generics
    RETURN QUERY
    SELECT 
        'invalid_generic_tmt_refs'::TEXT,
        CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END::TEXT,
        'Found ' || COUNT(*) || ' generics with invalid TMT references'::TEXT
    FROM drug_generics dg
    WHERE dg.tmt_gp_id IS NOT NULL 
        AND NOT EXISTS (SELECT 1 FROM tmt_concepts tc WHERE tc.tmt_id = dg.tmt_gp_id);
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE 'TMT Migration completed successfully!';
    RAISE NOTICE 'New tables created: tmt_concepts, tmt_relationships, hospital_pharmaceutical_products, tmt_mappings';
    RAISE NOTICE 'Enhanced tables: drug_generics, drugs, companies';
    RAISE NOTICE 'Views created: v_drugs_with_tmt, v_tmt_hierarchy, v_hpp_summary';
    RAISE NOTICE 'Functions created: check_tmt_mapping_completeness(), search_tmt_concept(), validate_tmt_data_integrity()';
    RAISE NOTICE 'Run SELECT * FROM check_tmt_mapping_completeness(); to check mapping status';
    RAISE NOTICE 'Run SELECT * FROM validate_tmt_data_integrity(); to validate data integrity';
END $$;