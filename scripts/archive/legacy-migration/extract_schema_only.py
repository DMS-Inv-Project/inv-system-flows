#!/usr/bin/env python3
"""
Extract only schema (CREATE TABLE statements) from MySQL dump
This will be faster and more manageable for initial database setup
"""

import re
import os

def extract_schema_only():
    """Extract only CREATE TABLE statements and basic structure"""
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_file = os.path.join(script_dir, "INVS_MySQL_Database_20231119.sql")
    output_dir = os.path.join(script_dir, "legacy-init")
    schema_file = os.path.join(output_dir, "01-schema-only.sql")
    
    os.makedirs(output_dir, exist_ok=True)
    
    print(f"Extracting schema from {input_file}")
    
    with open(schema_file, 'w', encoding='utf-8') as outfile:
        # Write header
        outfile.write("-- INVS Legacy Database Schema Only\n")
        outfile.write("-- Extracted from MySQL dump for reference\n")
        outfile.write("SET client_encoding = 'UTF8';\n\n")
        
        with open(input_file, 'r', encoding='utf-8', errors='ignore') as infile:
            in_create_table = False
            current_table = ""
            table_count = 0
            
            for line_num, line in enumerate(infile):
                if line_num % 100000 == 0:
                    print(f"Processed {line_num} lines, found {table_count} tables...")
                
                # Skip MySQL-specific comments
                if line.strip().startswith('--') or line.strip().startswith('/*'):
                    continue
                
                # Detect CREATE TABLE start
                if line.upper().strip().startswith('CREATE TABLE'):
                    in_create_table = True
                    table_count += 1
                    
                    # Extract table name
                    match = re.search(r'CREATE\s+TABLE[^`]*`([^`]+)`', line, re.IGNORECASE)
                    if match:
                        current_table = match.group(1)
                        print(f"Found table: {current_table}")
                    
                    # Convert MySQL syntax to PostgreSQL
                    line = line.replace('`', '"')
                    line = re.sub(r'\s+ENGINE=\w+.*$', '', line)
                    
                    outfile.write(f"\n-- Table: {current_table}\n")
                    outfile.write(line)
                    continue
                
                # Process table definition lines
                if in_create_table:
                    # End of CREATE TABLE
                    if line.strip().endswith(');') or line.strip().endswith(') ENGINE'):
                        in_create_table = False
                        
                        # Clean up the closing line
                        line = re.sub(r'\)\s+ENGINE=.*$', ');', line)
                        line = line.replace('`', '"')
                        outfile.write(line)
                        outfile.write("\n")
                        continue
                    
                    # Convert column definitions
                    if line.strip() and not line.strip().startswith('--'):
                        # Basic MySQL to PostgreSQL conversions
                        line = line.replace('`', '"')
                        
                        # Convert data types
                        line = re.sub(r'int\(\d+\)', 'INTEGER', line, flags=re.IGNORECASE)
                        line = re.sub(r'bigint\(\d+\)', 'BIGINT', line, flags=re.IGNORECASE)
                        line = re.sub(r'varchar\((\d+)\)\s+COLLATE\s+\w+', r'VARCHAR(\1)', line, flags=re.IGNORECASE)
                        line = re.sub(r'char\((\d+)\)\s+COLLATE\s+\w+', r'CHAR(\1)', line, flags=re.IGNORECASE)
                        line = re.sub(r'\bdatetime\b', 'TIMESTAMP', line, flags=re.IGNORECASE)
                        line = re.sub(r'\bdouble\b', 'DOUBLE PRECISION', line, flags=re.IGNORECASE)
                        
                        # Remove MySQL-specific clauses
                        line = re.sub(r'\s+COLLATE\s+\w+', '', line, flags=re.IGNORECASE)
                        line = re.sub(r'\s+AUTO_INCREMENT', '', line, flags=re.IGNORECASE)
                        line = re.sub(r'\s+USING\s+BTREE', '', line, flags=re.IGNORECASE)
                        
                        outfile.write(line)
    
    print(f"Schema extraction complete! Found {table_count} tables")
    print(f"Schema saved to: {schema_file}")
    
    return table_count

if __name__ == "__main__":
    extract_schema_only()