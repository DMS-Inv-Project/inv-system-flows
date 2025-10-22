# Schema - Drug Return

## Tables

### drug_returns
- Header: return_number, department_id, return_date
- Status: draft → submitted → verified → posted

### drug_return_items
- Items: drug_id, good_quantity, damaged_quantity
- Lot tracking: lot_number, expiry_date
- Location: where to return
