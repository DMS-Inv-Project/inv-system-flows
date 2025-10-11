#!/usr/bin/env python3
"""
Enhanced MySQL to PostgreSQL Converter
Converts MySQL dump file to PostgreSQL-compatible format with better handling
"""

import re
import sys
import os

def convert_data_types(line):
    """Convert MySQL data types to PostgreSQL equivalents"""
    
    # AUTO_INCREMENT to SERIAL (handle various formats)
    line = re.sub(r'int\(\d+\)\s+NOT\s+NULL\s+AUTO_INCREMENT', 'SERIAL', line, flags=re.IGNORECASE)
    line = re.sub(r'bigint\(\d+\)\s+NOT\s+NULL\s+AUTO_INCREMENT', 'BIGSERIAL', line, flags=re.IGNORECASE)
    line = re.sub(r'INTEGER\s+NOT\s+NULL\s+AUTO_INCREMENT', 'SERIAL', line, flags=re.IGNORECASE)
    line = re.sub(r'BIGINT\s+NOT\s+NULL\s+AUTO_INCREMENT', 'BIGSERIAL', line, flags=re.IGNORECASE)
    
    # Remove size specifications from integer types
    line = re.sub(r'int\(\d+\)', 'INTEGER', line, flags=re.IGNORECASE)
    line = re.sub(r'bigint\(\d+\)', 'BIGINT', line, flags=re.IGNORECASE)
    line = re.sub(r'smallint\(\d+\)', 'SMALLINT', line, flags=re.IGNORECASE)
    line = re.sub(r'tinyint\(\d+\)', 'SMALLINT', line, flags=re.IGNORECASE)
    line = re.sub(r'mediumint\(\d+\)', 'INTEGER', line, flags=re.IGNORECASE)
    
    # Handle varchar/char with charset
    line = re.sub(r'varchar\((\d+)\)\s+CHARACTER\s+SET\s+\w+', r'VARCHAR(\1)', line, flags=re.IGNORECASE)
    line = re.sub(r'char\((\d+)\)\s+CHARACTER\s+SET\s+\w+', r'CHAR(\1)', line, flags=re.IGNORECASE)
    
    # Convert datetime to timestamp
    line = re.sub(r'\bdatetime\b', 'TIMESTAMP', line, flags=re.IGNORECASE)
    
    # Convert double to DOUBLE PRECISION
    line = re.sub(r'\bdouble\b', 'DOUBLE PRECISION', line, flags=re.IGNORECASE)
    
    # Convert text types
    line = re.sub(r'\blongtext\b', 'TEXT', line, flags=re.IGNORECASE)
    line = re.sub(r'\bmediumtext\b', 'TEXT', line, flags=re.IGNORECASE)
    line = re.sub(r'\btinytext\b', 'TEXT', line, flags=re.IGNORECASE)
    
    # Convert blob types
    line = re.sub(r'\blongblob\b', 'BYTEA', line, flags=re.IGNORECASE)
    line = re.sub(r'\bmediumblob\b', 'BYTEA', line, flags=re.IGNORECASE)
    line = re.sub(r'\btinyblob\b', 'BYTEA', line, flags=re.IGNORECASE)
    line = re.sub(r'\bblob\b', 'BYTEA', line, flags=re.IGNORECASE)
    
    # Remove COLLATE clauses
    line = re.sub(r'\s+COLLATE\s+\w+', '', line, flags=re.IGNORECASE)
    
    # Remove CHARSET clauses
    line = re.sub(r'\s+CHARACTER\s+SET\s+\w+', '', line, flags=re.IGNORECASE)
    line = re.sub(r'\s+CHARSET\s+\w+', '', line, flags=re.IGNORECASE)
    
    return line

def remove_mysql_syntax(line):
    """Remove MySQL-specific syntax"""
    
    # Remove backticks and replace with double quotes
    line = line.replace('`', '"')
    
    # Remove ENGINE, CHARSET clauses at end of CREATE TABLE
    line = re.sub(r'\)\s+ENGINE=\w+[^;]*;', ');', line, flags=re.IGNORECASE)
    
    # Remove AUTO_INCREMENT value from table definition  
    line = re.sub(r'AUTO_INCREMENT=\d+\s*', '', line, flags=re.IGNORECASE)
    
    # Remove DEFAULT CHARSET
    line = re.sub(r'DEFAULT\s+CHARSET=\w+', '', line, flags=re.IGNORECASE)
    
    # Remove USING BTREE/HASH from indexes
    line = re.sub(r'\s+USING\s+(BTREE|HASH)', '', line, flags=re.IGNORECASE)
    
    # Remove COMMENT clauses
    line = re.sub(r"\s+COMMENT\s+'[^']*'", '', line, flags=re.IGNORECASE)
    line = re.sub(r'\s+COMMENT\s+"[^"]*"', '', line, flags=re.IGNORECASE)
    
    return line

def should_skip_line(line):
    """Determine if a line should be skipped"""
    
    # Normalize line for checking
    line_upper = line.upper().strip()
    
    # Skip empty lines
    if not line.strip():
        return True
        
    # Skip MySQL comments
    if line.strip().startswith('--'):
        return True
    
    # Skip MySQL version-specific commands
    if line.startswith('/*!') and line.endswith('*/;'):
        return True
    
    # Skip DELIMITER statements and everything between them
    if 'DELIMITER' in line_upper:
        return True
    
    # Skip CREATE/DROP FUNCTION statements
    if line_upper.startswith('CREATE FUNCTION') or line_upper.startswith('DROP FUNCTION'):
        return True
    
    # Skip MySQL-specific statements
    skip_keywords = [
        'LOCK TABLES',
        'UNLOCK TABLES', 
        'SET FOREIGN_KEY_CHECKS',
        'SET UNIQUE_CHECKS',
        'SET AUTOCOMMIT',
        'SET SQL_MODE'
    ]
    
    for keyword in skip_keywords:
        if keyword in line_upper:
            return True
    
    return False

def convert_insert_statement(line):
    """Convert INSERT statements for PostgreSQL compatibility"""
    
    # Handle ON DUPLICATE KEY UPDATE (PostgreSQL uses ON CONFLICT)
    if 'ON DUPLICATE KEY UPDATE' in line.upper():
        # For now, just remove it - would need table-specific handling for proper UPSERT
        line = re.sub(r'\s+ON\s+DUPLICATE\s+KEY\s+UPDATE.*$', ';', line, flags=re.IGNORECASE)
    
    # Fix boolean values (be more specific to avoid replacing inside other strings)
    line = re.sub(r"'Y'(?=\s*[,)])", "'true'", line)
    line = re.sub(r"'N'(?=\s*[,)])", "'false'", line)
    
    # Handle NULL values in date fields that might be '0000-00-00'
    line = re.sub(r"'0000-00-00'", "NULL", line)
    line = re.sub(r"'0000-00-00 00:00:00'", "NULL", line)
    
    return line

def add_postgresql_header(output_file):
    """Add PostgreSQL-specific header to the file"""
    
    with open(output_file, 'w', encoding='utf-8') as outfile:
        outfile.write("-- PostgreSQL conversion of INVS Legacy Database\n")
        outfile.write("-- Generated by mysql_to_postgresql_converter_v2.py\n")
        outfile.write("-- Original source: INVS_MySQL_Database_20231119.sql\n")
        outfile.write(f"-- Converted on: {os.popen('date').read().strip()}\n")
        outfile.write("\n-- Set client encoding to UTF8\n")
        outfile.write("SET client_encoding = 'UTF8';\n")
        outfile.write("\n-- Disable triggers for faster import\n")
        outfile.write("SET session_replication_role = 'replica';\n")
        outfile.write("\n-- Start transaction\n")
        outfile.write("BEGIN;\n\n")

def process_mysql_dump(input_file, output_file):
    """Process the MySQL dump file and convert to PostgreSQL"""
    
    print(f"Converting {input_file} to {output_file}")
    
    # Add PostgreSQL header
    add_postgresql_header(output_file)
    
    with open(input_file, 'r', encoding='utf-8', errors='ignore') as infile:
        with open(output_file, 'a', encoding='utf-8') as outfile:
            
            line_count = 0
            converted_lines = 0
            in_function = False
            function_depth = 0
            current_table = None
            
            for line in infile:
                line_count += 1
                
                if line_count % 50000 == 0:
                    print(f"Processed {line_count} lines, converted {converted_lines} lines...")
                
                # Handle DELIMITER and function blocks more carefully
                if 'DELIMITER' in line.upper():
                    if 'DELIMITER ;' in line:
                        in_function = False
                        function_depth = 0
                    else:
                        in_function = True
                        function_depth = 1
                    continue
                
                # Skip content inside functions
                if in_function:
                    if 'BEGIN' in line.upper():
                        function_depth += 1
                    elif 'END' in line.upper():
                        function_depth -= 1
                        if function_depth <= 0:
                            in_function = False
                    continue
                
                # Skip certain lines
                if should_skip_line(line):
                    continue
                
                # Process the line
                original_line = line
                
                # Convert data types
                line = convert_data_types(line)
                
                # Remove MySQL-specific syntax
                line = remove_mysql_syntax(line)
                
                # Handle CREATE TABLE statements
                if line.upper().strip().startswith('CREATE TABLE'):
                    # Extract table name for context
                    match = re.search(r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?"?(\w+)"?', line, re.IGNORECASE)
                    if match:
                        current_table = match.group(1)
                        if converted_lines % 10 == 0:  # Print every 10th table to avoid spam
                            print(f"Converting table: {current_table}")
                
                # Convert INSERT statements
                if line.upper().strip().startswith('INSERT'):
                    line = convert_insert_statement(line)
                
                # Handle DELETE statements (keep them)
                if line.upper().strip().startswith('DELETE'):
                    pass  # Keep as-is
                
                # Write the converted line
                if line.strip():
                    outfile.write(line)
                    converted_lines += 1
    
    print(f"Conversion complete! Processed {line_count} lines, converted {converted_lines} lines")

def add_postgresql_footer(output_file):
    """Add PostgreSQL-specific footer to the file"""
    
    with open(output_file, 'a', encoding='utf-8') as outfile:
        outfile.write("\n\n-- Commit transaction\n")
        outfile.write("COMMIT;\n")
        outfile.write("\n-- Re-enable triggers\n")
        outfile.write("SET session_replication_role = 'origin';\n")
        outfile.write("\n-- Update sequences for SERIAL columns\n")
        outfile.write("-- Run these commands after data import to fix sequence values:\n")
        outfile.write("/*\n")
        
        # Try to identify SERIAL columns that need sequence updates
        serial_tables = []
        with open(output_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Find tables with SERIAL columns
        table_pattern = r'CREATE TABLE[^(]*"(\w+)"[^;]*SERIAL[^;]*;'
        matches = re.findall(table_pattern, content, re.IGNORECASE | re.DOTALL)
        
        for table_name in matches:
            # Try to find the SERIAL column name
            serial_pattern = rf'CREATE TABLE[^"]*"{table_name}"[^;]*"(\w+)"\s+SERIAL'
            serial_match = re.search(serial_pattern, content, re.IGNORECASE | re.DOTALL)
            if serial_match:
                column_name = serial_match.group(1)
                outfile.write(f"SELECT setval(pg_get_serial_sequence('{table_name}', '{column_name}'), \n")
                outfile.write(f"       COALESCE((SELECT MAX({column_name}) FROM {table_name}), 1));\n")
        
        outfile.write("*/\n")
        outfile.write("\n-- Create any missing indexes\n")
        outfile.write("-- Add custom indexes as needed based on your application requirements\n")
        outfile.write("\n-- Conversion completed successfully\n")
        outfile.write("-- Total tables converted: check the log output above\n")

def main():
    # Use current project structure paths
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    
    input_file = os.path.join(script_dir, "INVS_MySQL_Database_20231119.sql")
    output_dir = os.path.join(script_dir, "legacy-init")
    output_file = os.path.join(output_dir, "01-invs-legacy-schema.sql")
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    if not os.path.exists(input_file):
        print(f"Error: Input file {input_file} not found")
        return 1
    
    try:
        process_mysql_dump(input_file, output_file)
        add_postgresql_footer(output_file)
        
        # Count final tables
        with open(output_file, 'r', encoding='utf-8') as f:
            content = f.read()
            table_count = len(re.findall(r'CREATE TABLE', content, re.IGNORECASE))
        
        print(f"PostgreSQL schema file created at: {output_file}")
        print(f"Total tables converted: {table_count}")
        return 0
        
    except Exception as e:
        print(f"Error during conversion: {e}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())