#!/usr/bin/env python3
"""
Create clean PostgreSQL schema from MySQL dump
Focus only on CREATE TABLE statements with proper conversions
"""

import re
import os

def clean_mysql_to_postgresql():
    """Extract and convert only CREATE TABLE statements properly"""
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_file = os.path.join(script_dir, "INVS_MySQL_Database_20231119.sql")
    output_dir = os.path.join(script_dir, "legacy-init")
    clean_schema_file = os.path.join(output_dir, "02-clean-schema.sql")
    
    os.makedirs(output_dir, exist_ok=True)
    
    print(f"Creating clean PostgreSQL schema from {input_file}")
    
    tables_found = []
    
    with open(clean_schema_file, 'w', encoding='utf-8') as outfile:
        # Write header
        outfile.write("-- INVS Legacy Database - Clean PostgreSQL Schema\n")
        outfile.write("-- Converted from MySQL dump\n")
        outfile.write("SET client_encoding = 'UTF8';\n")
        outfile.write("SET standard_conforming_strings = on;\n\n")
        
        with open(input_file, 'r', encoding='utf-8', errors='ignore') as infile:
            in_create_table = False
            current_table_lines = []
            current_table_name = ""
            
            for line_num, line in enumerate(infile):
                if line_num % 100000 == 0:
                    print(f"Processed {line_num} lines, found {len(tables_found)} tables...")
                
                # Detect CREATE TABLE start
                if line.upper().strip().startswith('CREATE TABLE'):
                    in_create_table = True
                    current_table_lines = []
                    
                    # Extract table name
                    match = re.search(r'CREATE\s+TABLE[^`]*`([^`]+)`', line, re.IGNORECASE)
                    if match:
                        current_table_name = match.group(1)
                        tables_found.append(current_table_name)
                        print(f"Processing table: {current_table_name}")
                    
                    current_table_lines.append(line)
                    continue
                
                # Collect table definition lines
                if in_create_table:
                    current_table_lines.append(line)
                    
                    # End of CREATE TABLE
                    if line.strip().endswith(');') or ') ENGINE=' in line:
                        in_create_table = False
                        
                        # Process the complete table definition
                        processed_table = process_table_definition(current_table_lines, current_table_name)
                        outfile.write(processed_table)
                        outfile.write("\n")
                        
                        current_table_lines = []
                        continue
    
    print(f"Clean schema creation complete!")
    print(f"Total tables processed: {len(tables_found)}")
    print(f"Schema saved to: {clean_schema_file}")
    
    # Write table list for reference
    table_list_file = os.path.join(output_dir, "table_list.txt")
    with open(table_list_file, 'w', encoding='utf-8') as f:
        f.write("Tables found in INVS Legacy Database:\n")
        f.write("=====================================\n\n")
        for i, table in enumerate(tables_found, 1):
            f.write(f"{i:3d}. {table}\n")
    
    print(f"Table list saved to: {table_list_file}")
    return len(tables_found)

def process_table_definition(lines, table_name):
    """Process and convert a single CREATE TABLE definition"""
    
    result = []
    result.append(f"\n-- Table: {table_name}\n")
    
    column_lines = []
    
    for i, line in enumerate(lines):
        # First line - CREATE TABLE
        if i == 0:
            line = line.replace('`', '"')
            line = re.sub(r'IF NOT EXISTS\s+', '', line, flags=re.IGNORECASE)
            result.append(line)
            continue
        
        # Last line - closing with ENGINE
        if ') ENGINE=' in line or line.strip().endswith(');'):
            break
        
        # Column definitions
        if line.strip() and not line.strip().startswith('--'):
            # Remove backticks
            line = line.replace('`', '"')
            
            # Convert MySQL data types to PostgreSQL
            line = convert_mysql_types(line)
            
            # Remove MySQL-specific clauses
            line = remove_mysql_clauses(line)
            
            # Skip index definitions for now
            if any(keyword in line.upper() for keyword in ['KEY ', 'INDEX ', 'CONSTRAINT ']):
                continue
            
            # Clean up the line and add to column list
            line = line.strip()
            if line and not line.endswith(','):
                line += ','
            column_lines.append('  ' + line)
    
    # Process column lines to remove trailing comma from last column
    if column_lines:
        # Remove trailing comma from last column
        last_line = column_lines[-1].rstrip(',')
        column_lines[-1] = last_line
        
        # Add all column lines
        result.extend([line + '\n' for line in column_lines])
    
    result.append(");\n")
    return ''.join(result)

def convert_mysql_types(line):
    """Convert MySQL data types to PostgreSQL equivalents"""
    
    # Integer types
    line = re.sub(r'\bint\(\d+\)', 'INTEGER', line, flags=re.IGNORECASE)
    line = re.sub(r'\bbigint\(\d+\)', 'BIGINT', line, flags=re.IGNORECASE)
    line = re.sub(r'\bsmallint\(\d+\)', 'SMALLINT', line, flags=re.IGNORECASE)
    line = re.sub(r'\btinyint\(\d+\)', 'SMALLINT', line, flags=re.IGNORECASE)
    line = re.sub(r'\bmediumint\(\d+\)', 'INTEGER', line, flags=re.IGNORECASE)
    
    # String types with charset/collate
    line = re.sub(r'varchar\((\d+)\)\s+COLLATE\s+\w+', r'VARCHAR(\1)', line, flags=re.IGNORECASE)
    line = re.sub(r'char\((\d+)\)\s+COLLATE\s+\w+', r'CHAR(\1)', line, flags=re.IGNORECASE)
    line = re.sub(r'varchar\((\d+)\)\s+CHARACTER\s+SET\s+\w+', r'VARCHAR(\1)', line, flags=re.IGNORECASE)
    line = re.sub(r'char\((\d+)\)\s+CHARACTER\s+SET\s+\w+', r'CHAR(\1)', line, flags=re.IGNORECASE)
    
    # Date/time types
    line = re.sub(r'\bdatetime\b', 'TIMESTAMP', line, flags=re.IGNORECASE)
    line = re.sub(r'\btimestamp\b', 'TIMESTAMP', line, flags=re.IGNORECASE)
    
    # Numeric types
    line = re.sub(r'\bdouble\b', 'DOUBLE PRECISION', line, flags=re.IGNORECASE)
    line = re.sub(r'\bfloat\b', 'REAL', line, flags=re.IGNORECASE)
    
    # Text types
    line = re.sub(r'\blongtext\b', 'TEXT', line, flags=re.IGNORECASE)
    line = re.sub(r'\bmediumtext\b', 'TEXT', line, flags=re.IGNORECASE)
    line = re.sub(r'\btinytext\b', 'TEXT', line, flags=re.IGNORECASE)
    
    # Binary types
    line = re.sub(r'\blongblob\b', 'BYTEA', line, flags=re.IGNORECASE)
    line = re.sub(r'\bmediumblob\b', 'BYTEA', line, flags=re.IGNORECASE)
    line = re.sub(r'\btinyblob\b', 'BYTEA', line, flags=re.IGNORECASE)
    line = re.sub(r'\bblob\b', 'BYTEA', line, flags=re.IGNORECASE)
    
    return line

def remove_mysql_clauses(line):
    """Remove MySQL-specific clauses"""
    
    # Remove collate clauses
    line = re.sub(r'\s+COLLATE\s+\w+', '', line, flags=re.IGNORECASE)
    
    # Remove character set clauses
    line = re.sub(r'\s+CHARACTER\s+SET\s+\w+', '', line, flags=re.IGNORECASE)
    line = re.sub(r'\s+CHARSET\s+\w+', '', line, flags=re.IGNORECASE)
    
    # Remove auto increment
    line = re.sub(r'\s+AUTO_INCREMENT', '', line, flags=re.IGNORECASE)
    
    # Remove comments
    line = re.sub(r"\s+COMMENT\s+'[^']*'", '', line, flags=re.IGNORECASE)
    line = re.sub(r'\s+COMMENT\s+"[^"]*"', '', line, flags=re.IGNORECASE)
    
    # Remove using btree/hash
    line = re.sub(r'\s+USING\s+(BTREE|HASH)', '', line, flags=re.IGNORECASE)
    
    return line

if __name__ == "__main__":
    clean_mysql_to_postgresql()