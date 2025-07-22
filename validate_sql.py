#!/usr/bin/env python3
import re
import sys

def validate_sql_syntax(filename):
    """Basic SQL syntax validation"""
    errors = []
    warnings = []
    
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        return [f"Error reading file: {e}"], []
    
    lines = content.split('\n')
    
    # Basic syntax checks
    for i, line in enumerate(lines, 1):
        line_stripped = line.strip()
        if not line_stripped or line_stripped.startswith('--'):
            continue
            
        # Check for common syntax issues
        if line_stripped.endswith(',;'):
            errors.append(f"Line {i}: Invalid comma before semicolon")
            
        # Check for unclosed quotes
        quote_count = line_stripped.count("'") - line_stripped.count("\\'")
        if quote_count % 2 != 0:
            warnings.append(f"Line {i}: Potential unclosed quote")
            
        # Check for missing semicolons (basic check)
        if (line_stripped.upper().startswith(('CREATE', 'ALTER', 'INSERT', 'UPDATE', 'DELETE', 'DROP')) 
            and not line_stripped.endswith(';') 
            and not line_stripped.endswith('$$')
            and not line_stripped.endswith('(')):
            # Look ahead for semicolon in next few lines
            found_semicolon = False
            for j in range(i, min(i+5, len(lines))):
                if j < len(lines) and (';' in lines[j] or lines[j].strip().endswith('$$')):
                    found_semicolon = True
                    break
            if not found_semicolon:
                warnings.append(f"Line {i}: Statement may be missing semicolon")
    
    # Check for balanced parentheses
    paren_count = content.count('(') - content.count(')')
    if paren_count != 0:
        errors.append(f"Unbalanced parentheses: {paren_count} unclosed")
    
    # Check for balanced function blocks
    begin_count = len(re.findall(r'\bBEGIN\b', content, re.IGNORECASE))
    end_count = len(re.findall(r'\bEND\b', content, re.IGNORECASE))
    if begin_count != end_count:
        warnings.append(f"Potential unbalanced BEGIN/END blocks: {begin_count} BEGIN, {end_count} END")
    
    return errors, warnings

def main():
    files_to_check = [
        '01_create_tables.sql',
        '02_constraints_indexes.sql', 
        '03_row_level_security.sql',
        '04_functions_triggers.sql',
        '05_sample_data.sql',
        '00_complete_setup.sql'
    ]
    
    total_errors = 0
    total_warnings = 0
    
    print("SQL Syntax Validation Report")
    print("=" * 50)
    
    for filename in files_to_check:
        print(f"\nValidating {filename}...")
        errors, warnings = validate_sql_syntax(filename)
        
        if not errors and not warnings:
            print(f"✅ {filename}: PASSED - No issues found")
        else:
            if errors:
                print(f"❌ {filename}: {len(errors)} ERRORS found:")
                for error in errors:
                    print(f"   ERROR: {error}")
                total_errors += len(errors)
            
            if warnings:
                print(f"⚠️  {filename}: {len(warnings)} WARNINGS found:")
                for warning in warnings:
                    print(f"   WARNING: {warning}")
                total_warnings += len(warnings)
    
    print(f"\n" + "=" * 50)
    print(f"SUMMARY: {total_errors} errors, {total_warnings} warnings")
    
    if total_errors == 0:
        print("✅ All files passed basic syntax validation!")
        return 0
    else:
        print("❌ Some files have syntax errors that need attention.")
        return 1

if __name__ == "__main__":
    sys.exit(main())
